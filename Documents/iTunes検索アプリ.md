# iTunes検索アプリ

<!-- TOC -->

- [iTunes検索アプリ](#itunes検索アプリ)
    - [クラス関連図](#クラス関連図)
    - [主なクラス](#主なクラス)
        - [View](#view)
        - [VC](#vc)
        - [ViewModel](#viewmodel)
        - [Repository](#repository)
        - [APIクライアント](#apiクライアント)
        - [DB](#db)
        - [モデル](#モデル)
    - [フローチャート](#フローチャート)
        - [ユーザー検索フォーム入力時](#ユーザー検索フォーム入力時)
        - [検索処理](#検索処理)
        - [表示項目](#表示項目)
    - [モデル](#モデル-1)
        - [エンティティ](#エンティティ)
            - [Artwork](#artwork)
            - [ArtworkDto](#artworkdto)
            - [iTunesTrack: Codable](#itunestrack-codable)
        - [永続化](#永続化)
            - [ArtworkDto: Realm.Object](#artworkdto-realmobject)
    - [その他](#その他)
        - [ATS対応](#ats対応)
            - [ATSを無効にする](#atsを無効にする)
            - [ATSの対象外となるドメインを指定する](#atsの対象外となるドメインを指定する)
            - [基本的にATS を無効にし、ATS の対象にするドメインを Info.plist に記載する](#基本的にats-を無効にしats-の対象にするドメインを-infoplist-に記載する)
    - [Reference](#reference)
        - [View](#view-1)
        - [Library/スニペット](#libraryスニペット)
        - [ドキュメント作成](#ドキュメント作成)
        - [Realm](#realm)
            - [Realmが対応しているNSPredicateのクエリ](#realmが対応しているnspredicateのクエリ)
        - [その他](#その他-1)

<!-- /TOC -->

## クラス関連図

![iTunes検索アプリ-クラス関連図](https://github.com/sahara-ooga/ios-itunes-search-app/raw/feature/documents/Documents/iTunes検索アプリ-クラス関連図.png)

## 主なクラス

### View

|名前|説明|
|----|----|
|iTunesCell|iTunes Search APIの検索結果を表すTableViewCell|

### VC

|名前|説明|備考|
|----|----|----|
|RootVC|検索結果を表示するTableViewのVC||
|SearchResultVC|検索結果を表示するTableViewのVC||
|EmptyResultVC|検索結果が無かった場合に表示するVC|「該当の音楽が見つかりません。」を表示|

### ViewModel

|名前|説明|
|----|----|
|SearchResultViewModel|検索結果画面のViewModel|


### Repository

|名前|説明|
|----|----|
|iTunesRepository|iTunes Search APIの検索結果を供給する|
|ArtworkRepository|検索結果の画像を供給する|


### APIクライアント

|名前|説明|
|----|----|
|iTunesSearchAPIClient|ツイッターのAPIとの通信を行う|
|ArtworkClient|検索結果の画像を取得する|

### DB

|名前|説明|
|----|----|
|ArtworkDao|Realmとの情報の入出力を担当する|

### モデル

|名前|説明|
|----|----|
|iTunesTrack|iTunes Search APIの検索結果を表す|
|Artwork|画像情報|
|ArtworkDto|Realmとの入出力に使用|

## フローチャート

### ユーザー検索フォーム入力時

![iTunes検索アプリ-フローチャート-ユーザー検索フォーム入力時](https://github.com/sahara-ooga/ios-itunes-search-app/raw/feature/documents/Documents/iTunes検索アプリ-フローチャート-ユーザー検索フォーム入力時.png)

### 検索処理

![iTunes検索アプリ-フローチャート-検索・画像取得処理](https://github.com/sahara-ooga/ios-itunes-search-app/raw/1057243f466ad19390f0fcaf93ef2b8568171796/Documents/iTunes検索アプリ-フローチャート-検索・画像取得処理.png)

### 表示項目

APIレスポンスの項目のうち、表示に使用するのは以下の通り。
表示順は、返却された際の順番をそのまま用いるものとする。
| 表示項目       | 対応するレスポンスJSONの項目名 | 備考 |
|----------------|---------------|------|
| アーティスト名  | artistName    |      |
| サムネイル画像 | artworkUrl100 |      |
| 曲名           | trackName    |      |

## モデル

### エンティティ

検索結果を表す構造体、画像情報を表す構造体が必要。

#### Artwork

画像情報を表す構造体。

| 変数名 | 型 | 説明 | 備考 |
|-----------|---------|-----------------|-----------------|
| id | Int | ID | |
| url | String | アートワーク画像のURL| |
| image | UIImage | アートワーク画像のイメージ | |

#### ArtworkDto

画像情報を表す構造体。RealmのObject型を継承。

| 変数名 | 型 | 説明 | 備考 |
|-----------|---------|-----------------|-----------------|
| url | String | アートワーク画像のURL| |
| data | Data | アートワーク画像のバイナリデータ| 検索結果と別途にダウンロードする必要がある |
| image | UIImage? | アートワーク画像のイメージ | artworkDataから変換して渡す計算型プロパティ |

#### iTunesTrack: Codable
iTunes 検索 APIのレスポンスのうち曲情報を表す構造体。

| 変数名 | 型 | 説明 | 備考 |
|-----------|---------|-----------------|-----------------|
| artworkUrl | String | サムネイル画像のURL | JSONからのデコード時、artworkUrl100とのマッピングが必要 |
| artistName | String | アーティスト名 |  |
| trackName | String | 曲名 | |

### 永続化

Realmを使用して、画像と画像URLの組を保存する。


#### ArtworkDto: Realm.Object

Realmに入出力するアートワークの情報。画像のキャッシュとして動作する。

| 変数名 | 型 | 説明 | 備考 |
|-----------|---------|-----------------|-----------------|
| id | Int | ID | primaryKeyに設定 |
| url | String | アートワーク画像のURL |  |
| _image | UIImage? | アートワーク画像のイメージ | デフォルト値をnilで設定 |
| imageData | Data? | アートワーク画像のバイナリデータ | デフォルト値をnilで設定 |
| image | UIImage? | アートワーク画像のイメージ | 計算型プロパティ |

```swift
class ArtworkDto: Object {
    @objc dynamic var id = 0
    @objc dynamic var url = ""

    @objc dynamic private var _image: UIImage? = nil
    @objc dynamic private var imageData: Data? = nil
    @objc dynamic var image: UIImage?{
        set{
            //imageにsetすると、自動的に_imageに値が保持され、imageDataにも変換&setされる。
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
}
```

## その他

### ATS対応

指定されたアートワークのURLがHTTPSでないときがある。そのため、ATSの除外設定が必要。
[[iOS 9] iOS 9 で追加された App Transport Security の概要 ｜ Developers.IO](https://dev.classmethod.jp/smartphone/iphone/ios-9-intro-ats/)

#### ATSを無効にする

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

#### ATSの対象外となるドメインを指定する

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>insecure.example.com</key>
        <dict>
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

#### 基本的にATS を無効にし、ATS の対象にするドメインを Info.plist に記載する

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>secure.example.com</key>
        <dict>
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <false/>
        </dict>
    </dict>
</dict>
```


## Reference

[第十回スキルアップ　実践編 · stv-ekushida/iOSTraining Wiki](https://github.com/stv-ekushida/iOSTraining/wiki/%E7%AC%AC%E5%8D%81%E5%9B%9E%E3%82%B9%E3%82%AD%E3%83%AB%E3%82%A2%E3%83%83%E3%83%97%E3%80%80%E5%AE%9F%E8%B7%B5%E7%B7%A8)

[iTunes Search API – Affiliate Resources](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/)

### View

[StoryboardのUIView一部切り替えについて](https://ja.stackoverflow.com/questions/10584/storyboard%E3%81%AEuiview%E4%B8%80%E9%83%A8%E5%88%87%E3%82%8A%E6%9B%BF%E3%81%88%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6#)

### Library/スニペット

[sahara-ooga/ios-realm-demo: iOS Realmを利用したCRUD操作のサンプルです。(Swift4)](https://github.com/sahara-ooga/ios-realm-demo)


[sahara-ooga/RepositoryTool: library to use repository pattarn in Swift.](https://github.com/sahara-ooga/RepositoryTool)

[sahara-ooga/ios-uikit-uisearchbar-demo: iOS UISearchBarのサンプル(Swift4)](https://github.com/sahara-ooga/ios-uikit-uisearchbar-demo)

### ドキュメント作成
[PlantUML Cheat Sheet - Qiita](https://qiita.com/ogomr/items/0b5c4de7f38fd1482a48)
[Visual Studio CodeでMarkdown目次(TOC)を作成する便利Plugin - Qiita](https://qiita.com/bj1024/items/16ec641dc88f74028192)

### Realm

#### Realmが対応しているNSPredicateのクエリ

[NSPredicate Cheatsheet](https://academy.realm.io/posts/nspredicate-cheatsheet/?_ga=2.63641642.441769819.1523724404-1920108131.1518421353)

[[iOS] Realmを使ってみた 〜環境構築からCRUDまで〜 ｜ Developers.IO](https://dev.classmethod.jp/smartphone/iphone/start-ios-realm-crud/)

### その他

[vanilla-di-manifesto/swift at master · vanilla-manifesto/vanilla-di-manifesto](https://github.com/vanilla-manifesto/vanilla-di-manifesto/tree/master/swift)

[Reachability.swiftで通信状況を確認する - しめ鯖日記](http://www.cl9.info/entry/2017/10/24/144857)

[Reachability.swift/ViewController.swift at master · ashleymills/Reachability.swift](https://github.com/ashleymills/Reachability.swift/blob/master/ReachabilitySample/ViewController.swift)

[iOS 9で追加されたNSLayoutAnchor使うと簡単にわかりやすく間違えずにNSLayoutConstraint（制約）が作れます【Auto Layout】 - Qiita](https://qiita.com/yucovin/items/4bebcc7a8b1088b374c9)

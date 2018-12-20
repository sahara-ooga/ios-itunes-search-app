//
//  VC+Util.swift
//  ios-itunes-search-app
//
//  Created by yogasawara@stv on 2018/04/15.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}
extension UIViewController {
    func showOKAlert(title: String,
                     message: String,
                     okButtonHandler: @escaping (UIAlertAction) -> Void ) {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction = UIAlertAction(title: "OK",
                                          style: UIAlertAction.Style.default,
                                          handler: okButtonHandler)
        // ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
}

//
//  PagingMenuViewController.swift
//  SecretSNS
//
//  Created by 米津純生 on 2021/02/01.
//

import UIKit
import Tabman
import Pageboy

final class PagingMenuViewController: TabmanViewController {
    
    private var viewControllers = [UIViewController]()
    // ページングメニューに対応したビューコントローラ
    override func viewDidLoad() {
            super.viewDidLoad()
            self.dataSource = self

            //tabmanの宣言
            let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)

        bar.buttons.customize { (button) in
            button.tintColor = UIColor.red
            button.selectedFont = UIFont(name: "PottaOne-Regular", size: 17)
        }
            addBar(bar, dataSource: self, at: .top)
        }
    private func setTabsControllers() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let likeVC = storyboard.instantiateViewController(withIdentifier: "likeVC")
           let MyVC = storyboard.instantiateViewController(withIdentifier: "MyVC")

           viewControllers = [
            MyVC,likeVC
           ]
       }
}
    extension PagingMenuViewController: PageboyViewControllerDataSource, TMBarDataSource{
        func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {

            let titilename = ["自分の投稿","いいねした投稿"]
            var items = [TMBarItem]()

            for i in titilename {
                let title = TMBarItem(title: i)
                items.append(title)
            }
            return items[index]
        }

        func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
            setTabsControllers()
            return viewControllers.count
        }

        func viewController(for pageboyViewController: PageboyViewController,
                            at index: PageboyViewController.PageIndex) -> UIViewController? {
            return viewControllers[index]
        }

        func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
            return nil
        }

        func barItem(for tabViewController: TabmanViewController, at index: Int) -> TMBarItemable {
            return TMBarItem(title: "Page \(index)")
        }


    }


    

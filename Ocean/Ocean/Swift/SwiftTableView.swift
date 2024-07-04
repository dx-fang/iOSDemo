//
//  SwiftTableView.swift
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/19.
//

import Foundation
import UIKit
// 使用@objc标记（对于类成员函数或属性），或者将类标记为@objcMembers（自动应用@objc到类的所有成员上）。
//@objcMembers class SwiftViewController: NSObject {
//    func testFunction() {
//        print("This is a test function")
//    }
//}

@objcMembers class SwiftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    let data = ["行1", "行2", "行3"] // 示例数据
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化tableView
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self // 设置数据源
        tableView.delegate = self // 设置代理
        
        // 注册UITableViewCell类
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 将tableView添加到当前视图
        self.view.addSubview(tableView)
    }
    
    // UITableViewDataSource协议方法
    
    // 返回表格行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // 返回对应的单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 从重用队列中获取单元格
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // 设置单元格内容
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    // UITableViewDelegate协议方法
    
    // 处理行选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("选中了第\(indexPath.row)行")
        // 取消选中状态
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

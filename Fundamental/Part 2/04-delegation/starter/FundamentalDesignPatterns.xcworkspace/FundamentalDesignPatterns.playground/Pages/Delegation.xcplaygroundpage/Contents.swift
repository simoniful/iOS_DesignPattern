/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Delegation
 - - - - - - - - - -
 ![Delegation Diagram](Delegation_Diagram.png)
 
 The delegation pattern allows an object to use a helper object to perform a task, instead of doing the task itself.
 
 This allows for code reuse through object composition, instead of inheritance.
 
 ## Code Example
 */


import UIKit

public protocol MenuViewControllerDelegate: AnyObject {
    func menuViewController(_ menuViewController: MenuViewController, didSelectItemAtIndex index: Int)
}

public class MenuViewController : UIViewController {
    public weak var delegate: MenuViewControllerDelegate?
    
    // 1
    @IBOutlet public var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // 2
    private let items = ["Item 1", "Item 2", "Item 3"]
}

// 3
// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menuViewController(self, didSelectItemAtIndex: indexPath.row)
    }
}

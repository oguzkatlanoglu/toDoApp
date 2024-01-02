import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var plans = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.plans = UserDefaults.standard.stringArray(forKey: "plans") ?? []
        title = "To Do List"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        
    }
    
    @objc func addButton(){
        let alert = UIAlertController(title: "Your Plan", message: "What Are You Going To Do Day?", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Enter plan..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    
                
                    DispatchQueue.main.async {
                        var currentPlans = UserDefaults.standard.stringArray(forKey: "plans") ?? []
                        currentPlans.append(text)
                        UserDefaults.standard.setValue(currentPlans, forKey: "plans")
                        self?.plans.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        
        present(alert, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = plans[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.plans.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


}

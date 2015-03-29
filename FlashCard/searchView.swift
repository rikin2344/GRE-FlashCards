import UIKit
import QuartzCore
import CoreData

var wchview = 0

class searchView: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate{
    
    var cellID = "custCell"
    var searchResultWord = NSArray()
    var results = NSArray()
    var inittransform = CATransform3D(m11: 0, m12: 0, m13: 0, m14: 0, m21: 0, m22: 0, m23: 0, m24: 0, m31: 0, m32: 0, m33: 0, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)
    var shownIndexed = [AnyObject]()
    
    @IBOutlet var tableView: UITableView! = UITableView()
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.translucent = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        
        //Registering NIb
        var nib: UINib? = UINib(nibName: "searchViewNib", bundle: nil)
        tableView.registerNib(nib!, forCellReuseIdentifier: cellID)
        
        //Setting up the navigation bar
        self.navigationController!.navigationBar.titleTextAttributes = aE.navigationBarColorDictionary
        //self.searchDisplayController.displaysSearchBarInNavigationBar = true
        self.navigationController!.navigationBar.translucent = true
        
        //Querying data from CoreData Model
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        results = result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TableView delegates methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (tableView == searchDisplayController!.searchResultsTableView) {
            return self.searchResultWord.count
        }else{
            return results.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var data = results[indexPath.row] as NSManagedObject
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "NewCell")
        //Setting the contents of the cell
        if (tableView == searchDisplayController!.searchResultsTableView) {
            var data1 = searchResultWord[indexPath.row] as NSManagedObject
            cell.textLabel!.text = (data1.valueForKey("wordName") as String).capitalizedString
            var tempMeaning = data1.valueForKey("meaning") as String
            tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("*", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("@", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            cell.detailTextLabel!.text = tempMeaning
        }
        else {
            cell.textLabel!.text = (data.valueForKey("wordName") as String).capitalizedString
            var tempMeaning = data.valueForKey("meaning") as String
            tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("*", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("@", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            cell.detailTextLabel!.text = tempMeaning
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if searchResultWord.count == 0 {
            var data1 = results[indexPath.row] as NSManagedObject
            wordSelected = data1.valueForKey("wordName") as String
            self.tabBarController!.selectedIndex = 2
            
        }else {
            var data1 = searchResultWord[indexPath.row] as NSManagedObject
            wordSelected = data1.valueForKey("wordName") as String
            self.tabBarController!.selectedIndex = 2
        }
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        //Setting the animation
        
        if (tableView != searchDisplayController!.searchResultsTableView) {
            var tempArray:NSMutableArray = NSMutableArray(array: shownIndexed)
            if tempArray.containsObject(indexPath) == false {
                shownIndexed.append(indexPath)
                
                cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
                UIView.animateWithDuration(0.25, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1,1,1)
                })
                if shownIndexed.count == 10 {
                    shownIndexed.removeAtIndex(0)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    //MARK: Search Bar Methods
    func filterContentForSearchText(searchText: String){
        var searchTextLower = searchText.lowercaseString
        
        //Querying data from CoreData Model
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "wordName CONTAINS %@ || meaning CONTAINS %@", searchTextLower,searchTextLower)
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        searchResultWord = result
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    
}
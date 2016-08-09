//
//  MasterViewController.swift
//  WhitehousePetitions
//
//  Created by My Nguyen on 8/7/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    // an array of dictionaries; each holding a string for its key and another string for its value.
    var objects = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // White House URL
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            // the first MasterViewController loads the original JSON
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            // the second loads only petitions that have at least 10,0000 signatures
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        // obtain a queue with QoS of type User Initiated
        let queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        // dispatch_async() takes 2 parameters: a queue, and a closure
        // again, declare [unowned self] to avoid strong reference cycles in the closure
        dispatch_async(queue) { [unowned self] in
            // make sure URL is valid
            if let url = NSURL(string: urlString) {
                // extract the contents of the URL
                if let data = try? NSData(contentsOfURL: url, options: []) {
                    // create a SwiftyJSON object based on the whole URL content
                    let json = JSON(data: data)
                    // extract the "status" metadata from JSON
                    if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                        self.parseJSON(json)
                    } else {
                        self.showError()
                    }
                } else {
                    self.showError()
                }
            } else {
                self.showError()
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        // set the correct title and subtitle
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }

    func parseJSON(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let signatureCount = result["signatureCount"].stringValue
            let object = ["title": title, "body": body, "signatureCount": signatureCount]

            objects.append(object)
        }

        tableView.reloadData()
    }

    func showError() {
        let title = "Loading error"
        let message = "There was a problem with the feed; please check your connection and try again."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}


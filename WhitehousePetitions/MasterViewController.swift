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
        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        // make sure URL is valid
        if let url = NSURL(string: urlString) {
            // extract the contents of the URL
            if let data = try? NSData(contentsOfURL: url, options: []) {
                // create a SwiftyJSON object based on the whole URL content
                let json = JSON(data: data)
                // extract the "status" metadata from JSON
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    print("status is 200")
                    parseJSON(json)
                }
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
        print("count: \(objects.count)")

        tableView.reloadData()
    }
}


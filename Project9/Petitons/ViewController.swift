//
//  ViewController.swift
//  Petitons
//
//  Created by Adarsh Singh on 21/08/23.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    

    let search = UISearchController(searchResultsController: nil)
    var petitions = [Petition]()
   
    override func viewDidLoad()  {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBarSetup()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action:#selector(showDetail))
        performSelector(inBackground: #selector(Api), with: nil)
    }
    // Api Table data
    
    @objc func Api(){
        let urlString: String
        if navigationController?.tabBarItem.tag == 0{
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            } else {
                
                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            }
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                    return
                }
        
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        
    }
    //Api info
    @objc
    func showDetail(){
        let ac = UIAlertController(title: "Api Info", message: "We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // Error Handling
    @objc func showError(){
       
            let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(ac, animated: true)
        
    }
   // Converting link to json data
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetition = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetition.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }else{
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = detailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // ALL about search
    private func searchBarSetup(){
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        navigationItem.searchController = search
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        if searchText == ""{
            Api()
        }else{
            Api()
            petitions = petitions.filter{
                $0.title.contains(searchText)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
            
    }

}


//
//  ViewController.swift
//  Currency Converter
//
//  Created by Cesar Miguel Chavez on 27/09/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var arrayCurrencies:[String] = []
    var arrayCurrenciesValue:[Double] = []
    var infoData:String = ""
    

    @IBOutlet weak var tableViewRates: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getRatesClicked(_ sender: Any) {
        getRates()
        print("OK")
    }
    
    func getRates(){
        
        let baseHNL = "&base=HNL"
        var urlFixer = "http://data.fixer.io/api/latest?access_key=b1006e5c1409b097ba4be9ad6742f892&base"
        
        #warning("Comentar linea de abajo en caso de obtener el error: base_currency_access_restricted")
        //urlFixer = urlFixer+baseHNL
        
        let url = URL(string: urlFixer)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!){(data, response, error) in
            
            if error != nil {
                self.showAlert(error: error!.localizedDescription)
            }else{
                do{
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                                    
                        print(jsonResult)
                        
                        let errorResponse = jsonResult.value(forKey: "error") as? NSDictionary
                        
                        if errorResponse != nil {
                            
                            let code:String = String(errorResponse?.value(forKey: "code") as! Int)
                            let type:String = errorResponse?.value(forKey: "type") as! String
                            
                            if let info = errorResponse?.value(forKey: "info") as? String {
                                self.infoData = info
                            }
                            
                            let lmError:String = String(code)+" "+self.infoData+" "+type
                            self.showAlert(error: lmError)
                            
                        }else{
                            
                            let rates = jsonResult.value(forKey: "rates") as? NSDictionary
                            //self.arrayCurrencies = NSArray(object: rates as Any)
                            print("Only rates \(String(describing: rates))")
                            
                            for (key,value) in rates! {
                                self.arrayCurrencies.append(key as! String)
                                self.arrayCurrenciesValue.append(value as! Double)
                            }
                            
                            DispatchQueue.main.async() {
                                self.tableViewRates.reloadData()
                            }
                            
                        }
                        
                    }
                    
                }catch{
                    print("Error in serialization")
                }
            }
        }
        
        task.resume()
        
    }
    
    func showAlert(error: String){
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayCurrencies.count
    }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = self.arrayCurrencies[indexPath.row]+": "+String(self.arrayCurrenciesValue[indexPath.row])
        cell.textLabel?.textAlignment = .center
        return cell
    }
    

}


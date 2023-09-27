//
//  ViewController.swift
//  Currency Converter
//
//  Created by Cesar Miguel Chavez on 27/09/23.
//

import UIKit

class ViewController: UIViewController {
    
    let arrayCurrencies:NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func getRatesClicked(_ sender: Any) {
        getRates()
        print("OK")
    }
    
    func getRates(){
        
        let url = URL(string: "https://data.fixer.io/api/latest?access_key=b1006e5c1409b097ba4be9ad6742f892&base=HNL")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!){(data, response, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                do{
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                                    
                                    print(jsonResult)
                                    //Use GCD to invoke the completion handler on the main thread
                                    /*DispatchQueue.main.async() {
                                      completion(NSArray(object: teamResult), Int(teamInput.text!)!)
                                    }*/
                                }
                    /*if let convertedCurrencyJsonIntoArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {

                        print(convertedCurrencyJsonIntoArray)
                    }else{
                        print("error in serialization")
                    }*/
                }catch{
                    print("Error in serialization")
                }
            }
        }
        
        task.resume()
        
    }
    

}


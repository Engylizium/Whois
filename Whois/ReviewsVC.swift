//
//  ReviewsVC.swift
//  Whois
//
//  Created by Peresvet Sobolev on 01/10/2019.
//  Copyright © 2019 Peresvet Sobolev. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
 
class ReviewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard

    var callerNumber = ""

    var reviews: [String] = []
    
    var reviewsDict: [Int:[String]] = [:]

    let siteList = ["https://xn----dtbofgvdd5ah.xn--p1ai/", "https://zvonili.com/phone/", "https://www.neberitrubku.ru/nomer-telefona/", "https://ss1.ru/"]
    
    let xpathForReview = ["//div [@class='vsekomment9']", "//blockquote [@class='card-blockquote']", "//span [@class='review_comment']", "//div [@itemprop='reviewBody']"]
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var numberTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "First Launch") == true {
            defaults.set(true, forKey: "First Launch")
        } else {
            print("Show Swipe to close")
            
            defaults.set(true, forKey: "First Launch")
        }
        
        getReviews(callerNumber)
    }
    
    // TableView Handling
    
    // Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.reviews.count;
    }
    
    // Dequeue cells and setup additional settings
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = self.TableView.dequeueReusableCell(withIdentifier: "cell") as! reviewCell
            
            cell.reviewText.text = reviews[indexPath.row]
            cell.backgroundCellView.layer.cornerRadius = 10.0
            return cell
    }
    
    // HTML Data Extraction
    
    func getHTML(_ url: String, siteNum: Int)
    {
        AF.request(url).validate().responseString { response in
            switch response.result {
            case .success(let HTMLstring):
                print("Success")
                self.htmlParse(HTMLstring, siteNum: siteNum)
                if (siteNum == (self.siteList.count - 1)) {
                    self.filterReviews()
                    self.animateReload()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    func htmlParse(_ html: String, siteNum: Int)
    {
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8)
        {
            for comment in doc.xpath(xpathForReview[siteNum])
            {
                if (comment.text! != "") {
                    reviewsDict[siteNum, default: []].append(comment.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                }
            }
            if (siteNum == 0) {
                if let numberType = doc.at_xpath("//*[@id='onomere2']/div[5]/text()") {
                setLabels(doc.at_xpath("//*[@id='onomere2']/div[3]/text()")!.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
                          doc.at_xpath("//*[@id='onomere2']/div[4]/text()")!.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
                          numberType.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                }
            }
        }
    }
    
    func setLabels (_ region: String, _ provider: String, _ numberType: String) {
        regionLabel.text = region
        providerLabel.text = provider
        
        if numberType == "landline" { numberTypeLabel.text = "Проводной" }
        else { numberTypeLabel.text = "Сотовый" }
    }
    
    func filterReviews() {
        // Append loaded reviews in order to reviews array
        for siteNum in 0...siteList.count {
            if let reviewsArray = reviewsDict[siteNum] { reviews += reviewsArray }
        }
        // Remove duplicate reviews from array and capitalize first letter
        reviews = reviews.map {$0.lowercased()}.uniqueElements.map {$0.prefix(1).uppercased() + $0.lowercased().dropFirst()}
    }
    
    func animateReload() {
        DispatchQueue.main.async {
            if self.reviews.count == 0 {
                UIView.transition(with: self.TableView,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: { self.TableView.setEmptyView() })
            } else {
                self.TableView.restore()
                UIView.transition(with: self.TableView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { self.TableView.reloadData() })
            }
        }
    }
    
    func getReviews(_ phoneNumber: String) {
        for site in siteList
        {
            let siteNum = siteList.firstIndex(of: site)!
            switch siteNum {
            case 0:
                getHTML(site + phoneNumber + "/", siteNum: siteNum)
            case 2:
                getHTML(site + "8" + phoneNumber, siteNum: siteNum)
            default:
                getHTML(site + phoneNumber, siteNum: siteNum)
            }
        }
        
    }
    
} // End of Class

class reviewCell : UITableViewCell
{
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var reviewText: UILabel!
}

public extension Sequence where Element: Equatable {
  var uniqueElements: [Element] {
    return self.reduce(into: []) {
      uniqueElements, element in

      if !uniqueElements.contains(element) {
        uniqueElements.append(element)
      }
    }
  }
}

extension UITableView {
    func setEmptyView() {
        let empView = UINib(nibName: "EmptyReviews", bundle: .main).instantiate(withOwner: nil, options: nil).first as! UIView
        self.backgroundView = empView
    }
    func restore() {
        self.backgroundView = nil
    }
}

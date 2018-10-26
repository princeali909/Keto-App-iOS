//
//  ViewController.swift
//  Keto-Station
//
//  Created by Ali Halawa on 9/6/18.
//  Copyright © 2018 Ali Halawa. All rights reserved.
//

import UIKit
import Charts
import Foundation

class DateAxisFormatter : NSObject, IAxisValueFormatter {
    
    private var dateFormatter: DateFormatter!
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
    }

}



class DataPoint : NSObject, NSCoding {
    
    var date : TimeInterval = 0
    var weight : Double = 0
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(weight, forKey: "weight")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        date = aDecoder.decodeDouble(forKey: "date")
        weight = aDecoder.decodeDouble(forKey: "weight")
    }
    
    convenience init(date : TimeInterval, weight: Double) {
        self.init()
        self.date = date
        self.weight = weight
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var inputWeight: UITextField!
    @IBOutlet weak var progressGraph: LineChartView!
    
    var numbers = [DataPoint]()
    

    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressGraph.xAxis.valueFormatter = DateAxisFormatter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func weightUpdater(_ sender: Any) {
        
        guard let text = inputWeight.text, let input  = Double(text) else {
            print("Invalid input")
            return
        }
        
        let dataPoint = DataPoint(date: Date().timeIntervalSince1970, weight: input)
        numbers.append(dataPoint)
        
        let encoded = NSKeyedArchiver.archivedData(withRootObject: numbers)
        UserDefaults.standard.set(encoded, forKey: "dataPoints")
        updateGraph()
        inputWeight.text = ""
    }
    
    
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() 
        let xAxis = progressGraph.xAxis
        xAxis.labelPosition = .bottom
        

        numbers.forEach { dataPoint in
            
            let value = ChartDataEntry(x: dataPoint.date, y: dataPoint.weight)
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Date")
        line1.colors = [NSUIColor.blue]
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        progressGraph.data = data
        progressGraph.chartDescription?.text = "Weight Progress"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputWeight.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.value(forKey: "dataPoints") as? Data,
            let points = NSKeyedUnarchiver.unarchiveObject(with: data) as? [DataPoint] {
            numbers = points
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
    
    



//
//  CalculatorViewController.swift
//  Keto-Station
//
//  Created by Ali Halawa on 9/8/18.
//  Copyright © 2018 Ali Halawa. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    //text fields
    @IBOutlet weak var WeightInputField: UITextField!
    @IBOutlet weak var HeightInFeetField: UITextField!
    @IBOutlet weak var HeightInInchesField: UITextField!
    @IBOutlet weak var AgeInputField: UITextField!
    @IBOutlet weak var BFPInputField: UITextField!
    
    // labels
    @IBOutlet weak var RMRLabel: UILabel!
    @IBOutlet weak var DCELabel: UILabel!
    @IBOutlet weak var LBMLabel: UILabel!
    @IBOutlet weak var CalorieGoalLabel: UILabel!
    @IBOutlet weak var ProteinGoalLabel: UILabel!
    @IBOutlet weak var FatGoalLabel: UILabel!
    @IBOutlet weak var CarbLimitLabel: UILabel!
    
    
    // Button pressed
    var male = false
    var female = false
    var sedentary = false
    var low_Activity = false
    var active = false
    var high_Activity = false
    var lose_Weight = false
    var maintain_Weight = false
    var gain_Weight = false
    
    //Buttons
    
    @IBOutlet weak var MaleButton: UIButton!
    @IBOutlet weak var FemaleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WeightInputField.delegate = self
        HeightInFeetField.delegate = self
        HeightInInchesField.delegate = self
        AgeInputField.delegate = self
        BFPInputField.delegate = self
        self.hideKeyboard()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_Male(_ sender: Any) {
        male = true
        female = false
    }
    
    @IBAction func btn_Female(_ sender: Any) {
        female = true
        male = false
    }
    
    @IBAction func btn_Sedentary(_ sender: Any) {
        sedentary = true
        low_Activity = false
        active = false
        high_Activity = false
    }
    
    @IBAction func btn_LowActivity(_ sender: Any) {
        low_Activity = true
        sedentary = false
        active = false
        high_Activity = false
    }
    
    @IBAction func btn_Active(_ sender: Any) {
        active = true
        sedentary = false
        low_Activity = false
        high_Activity = false
    }
    
    @IBAction func btn_HighActivity(_ sender: Any) {
        high_Activity = true
        sedentary = false
        low_Activity = false
        active = false
    }
    
    @IBAction func btn_LoseWeight(_ sender: Any) {
        lose_Weight = true
        maintain_Weight = false
        gain_Weight = false
        RMRLabel.text = String(restingMetabolicRate().rounded()) + "kcals"
        DCELabel.text = String(dailyCaloricExpenditure().rounded()) + "kcals"
        LBMLabel.text = String(leanBodyMass().rounded()) + "lbs"
        CalorieGoalLabel.text = String(calorieGoals().rounded()) + "kcals"
        ProteinGoalLabel.text = String(proteinGoals().rounded()) + "g"
        FatGoalLabel.text = String(FatGoals().rounded()) + "g"
        CarbLimitLabel.text = "25 g"
    }
    
    @IBAction func btn_MaintainWeight(_ sender: Any) {
        maintain_Weight = true
        lose_Weight = false
        gain_Weight = false
        RMRLabel.text = String(restingMetabolicRate().rounded()) + "kcals"
        DCELabel.text = String(dailyCaloricExpenditure().rounded()) + "kcals"
        LBMLabel.text = String(leanBodyMass().rounded()) + "lbs"
        CalorieGoalLabel.text = String(calorieGoals().rounded()) + "kcals"
        ProteinGoalLabel.text = String(proteinGoals().rounded()) + "g"
        FatGoalLabel.text = String(FatGoals().rounded()) + "g"
        CarbLimitLabel.text = "25 g"
    }
    
    @IBAction func btn_GainWeight(_ sender: Any) {
        gain_Weight = true
        maintain_Weight = false
        lose_Weight = false
        RMRLabel.text = String(restingMetabolicRate().rounded()) + "kcals"
        DCELabel.text = String(dailyCaloricExpenditure().rounded()) + "kcals"
        LBMLabel.text = String(leanBodyMass().rounded()) + "lbs"
        CalorieGoalLabel.text = String(calorieGoals().rounded()) + "kcals"
        ProteinGoalLabel.text = String(proteinGoals().rounded()) + "g"
        FatGoalLabel.text = String(FatGoals().rounded()) + "g"
        CarbLimitLabel.text = "25.0g"
    }
    
    
    func restingMetabolicRate() -> Double {
        var bmr: Double = 0
        let heightInFeet = Double(HeightInFeetField.text!)!
        let heightInInches = Double(HeightInInchesField.text!)!
        let weight = Double(WeightInputField.text!)!
        let age = Double(AgeInputField.text!)!
        if(male == true){
            let bmrPart1 = (6.2 * weight)
            let bmrPart2 = (12.7 * ((heightInFeet * 12) + heightInInches))
            let bmrPart3 = (6.76 *  age)
            bmr = 66.0 + bmrPart1 + bmrPart2 - bmrPart3
        }
        else{
            let bmrPart1 = (4.35 * weight)
            let bmrPart2 = (4.7 * ((heightInFeet * 12) + heightInInches))
            let bmrPart3 =  (4.7 * age)
            bmr = 655.1 + bmrPart1 + bmrPart2 - bmrPart3
        }
        
        return bmr
    }
    
    func dailyCaloricExpenditure() -> Double{
        let bmr: Double = restingMetabolicRate()
        var activityLevelFactor: Double = 0
        if(sedentary == true){
            activityLevelFactor = 1
        }
        else if(low_Activity == true){
            activityLevelFactor = 1.11
        }
        else if(active == true){
            activityLevelFactor = 1.25
        }
        else{
            activityLevelFactor = 1.48
        }
        let dce = bmr * activityLevelFactor
        return dce
        
    }
    
    func leanBodyMass() -> Double{
        let weight = Double(WeightInputField.text!)
        let bfp = Double(BFPInputField.text!)! / 100
        let leanBodyMass = weight! - (weight! * bfp)
        return leanBodyMass
    }
    
    func calorieGoals() -> Double {
        let dce = dailyCaloricExpenditure()
        var calorieGoal: Double = 0
        if(lose_Weight == true) {
            calorieGoal = dce - (dce * 0.10)
        }
        else if(maintain_Weight == true) {
            calorieGoal = dce
        }
        else{
            calorieGoal = dce + (dce * 0.10)
        }
        return calorieGoal
        
    }
    
    func proteinGoals() -> Double{
        let protein = leanBodyMass()
        return protein
    }
    
    func FatGoals() -> Double{
        let calorieGoal = calorieGoals()
        let fat = (0.7 * calorieGoal) / 9
        return fat
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    
    
    

}

extension CalculatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return  true
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}



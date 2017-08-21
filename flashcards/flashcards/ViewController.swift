//
//  ViewController.swift
//  flashcards
//
//  Created by Brian Richardson on 8/20/17.
//  Copyright © 2017 bzztbomb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func answerHit(_ sender: UIButton) {
    let alert = UIAlertController(title: "Flashcards", message:sender.tag == 3 ? "Correct!" : "Wrong, answer is 4", preferredStyle: UIAlertControllerStyle.alert);
    alert.addAction(UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default));
    self.present(alert, animated: true, completion: nil);
  }
}


//
//  ViewController.swift
//  flashcards
//
//  Created by Brian Richardson on 8/20/17.
//  Copyright © 2017 bzztbomb. All rights reserved.
//

import UIKit
import SQLite

struct Card {
  var question : String = ""
  var answers : [String] = []
  var correctIndex : Int = -1
}

class FlashData {
  var db : Connection? = nil
  
  func initDB() throws {
    let path = Bundle.main.path(forResource: "flashcards", ofType: "db")!
    db = try Connection(path, readonly: true)
  }
  
  func question() throws -> Card {
    var ret = Card()
    var rowid : Int64 = 0
    for row in try db!.prepare("SELECT id, sidea, sideb FROM cards ORDER BY random() LIMIT 1") {
      rowid = row[0] as! Int64
      ret.question = row[1] as! String
      ret.answers.append(row[2] as! String)
    }
    for row in try db!.prepare("SELECT sideb FROM cards WHERE id != \(rowid) ORDER BY random() LIMIT 3") {
      ret.answers.append(row[0] as! String)
    }
    ret.correctIndex = Int(arc4random_uniform(4))
    let correct = ret.answers[0]
    let swap = ret.answers[ret.correctIndex]
    ret.answers[ret.correctIndex] = correct
    ret.answers[0] = swap
    return ret
  }
}

class ViewController: UIViewController {

  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet var answers: [UIButton]!
  
  var db : FlashData = FlashData()
  var currCard : Card? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    try? db.initDB()
    try? nextQuestion()
  }

  func nextQuestion() throws {
    let card = try? db.question()
    if (card != nil) {
      let c = card!
      questionLabel.text = c.question
      for (index, answer) in c.answers.enumerated() {
        answers[index].setTitle(answer, for: UIControlState.normal)
      }
      currCard = c
    }
  }

  @IBAction func answerHit(_ sender: UIButton) {
    if (sender.tag == currCard!.correctIndex) {
      try? self.nextQuestion()
    } else {
      let alert = UIAlertController(title: "Flashcards", message: "Wrong, answer is \(currCard!.answers[currCard!.correctIndex])", preferredStyle: UIAlertControllerStyle.alert);
      alert.addAction(UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default));
      self.present(alert, animated: true, completion: {
        try? self.nextQuestion()
      });
    }
  }
}


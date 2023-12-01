//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jan Grimm on 01.12.23.
//

import SwiftUI

struct ContentView: View {
    //.shuffled rearranges the order of the properties of the array everytime the array is called.
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    //picks a random number between 0 and 3. Is used to pick the country later on.
    @State private var correctAnswer = Int.random(in: 0...2)
    //properties for handling the alert.
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var tapped = ""
    @State private var rounds = 0
    @State private var roundTitle = ""
    @State private var showingReset = false
    
    var body: some View {
        ZStack {
            //location both set to the same position on screen makes for a hard line between both colors.
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary) //blue color shines through
                            .font(.subheadline.weight(.heavy)) //.font is perfect for dynamic resizing.
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            flagReset(rounds)
                            tapped = countries[number]
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule) //capsule rounds the edges that are closest
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            //padding to have the vstack frame not match the boundaries of the screen.
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Correct" {
                Text("Your score is \(score)")
            } else {
                Text("That's the flag of \(tapped).")
                Text("Your score is \(score). Try again.")
            }
            
        }
        
        .alert(roundTitle, isPresented: $showingReset) {
            Button("Start Again", action: startOver)
        } message: {
            Text("You've finished this game with a score of \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 100
            rounds += 1
        } else {
            scoreTitle = "False"
            rounds += 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
 
    func flagReset(_ number: Int) {
        if number == 8 {
            roundTitle = "You made it!"
            showingReset = true
        }
    }
    
    func startOver() {
        rounds = 0
        score = 0
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Oliver Hu on 12/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var questionNumber = 1
    @State private var maxQuestions = false
    @State private var flagSelected = -1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(.orange), location: 0.3),
                .init(color: Color(red: 0.16, green: 0.95, blue: 0.56), location: 1.2),
            ], center: .top, startRadius: 200, endRadius: 550)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                                flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                  
                        }
                        .rotation3DEffect(.degrees(flagSelected == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .animation(.bouncy, value: flagSelected)
                        .opacity(flagSelected == number || flagSelected == -1 ? 1 : 0.25)
                        .animation(.easeInOut(duration: 1), value: flagSelected)
                        .scaleEffect(flagSelected == number || flagSelected == -1 ? 1 : 0.90)
                        .saturation(flagSelected == number || flagSelected == -1 ? 1 : 0)
                        .animation(.easeInOut(duration: 1), value: flagSelected)
                        .accessibilityLabel(labels[countries[number], default: "Unknown flag"])


                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 25))
                
                Spacer()
                Spacer()
                
                Text("Score: \(currentScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(currentScore)")
        }
        .alert(Text("Game over"), isPresented: $maxQuestions) {
            Button("Press to reset game", action: reset)
        } message: {
            Text("Your final score is \(currentScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        flagSelected = number
        showingScore = true
        
    }
    
    func askQuestion() {
        flagSelected = -1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionNumber += 1
        if questionNumber > 8 {
            maxQuestions = true
        }
    }
    
    func reset() {
        flagSelected = -1
        currentScore = 0
        questionNumber = 1

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

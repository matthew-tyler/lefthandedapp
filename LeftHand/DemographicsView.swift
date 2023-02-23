/*
 DemographicsView.swift
 */

import Foundation
import PencilKit
import SwiftUI

struct DemographicsView: View
{
    @State var parent: LeftHandApp
    @State var result: User

    var sexes = ["Male", "Female", "Non-Binary", "Withheld"]
    @State var selectedSex: String

    var ages = ["1-10", "11-20", "21-30", "31-40", "41-50", "51-60", "61-70", "71-80", "81-90", ">90", "Withheld"]
    @State var selectedAge: String

    var handedness = ["Left", "Right", "Ambidextrous", "Withheld"]
    @State var selectedHandedness: String

    var writingHand = ["Left", "Right", "Ambidextrous", "Withheld"]
    @State var selectedWritingHand: String
    
    var writingHabit = ["More than once a day", "More than once a month", "Less than once a month","Withheld"]
    @State var selectedWritingHabit: String
    
    // Meeting: Suggested question, how often one uses a stylus on tablet
    var stylusHabit = ["More than once a day", "More than once a month", "Less than once a month","Withheld"]
    @State var selectedStylusHabit: String
    
    // Meeting: Unsure why this question.
    var educationLevel = ["School", "Bachelor", "Masters", "PhD", "Withheld"]
    @State var selectedEducationLevel: String

    init(_ parent: LeftHandApp, result: User)
    {
        _parent = State(initialValue: parent)
        self.result = result
        self.selectedSex = result.sex
        self.selectedAge = result.age
        self.selectedHandedness = result.handedness
        self.selectedWritingHand = result.writingHand
        self.selectedEducationLevel = result.educationLevel
        self.selectedWritingHabit = result.writingHabit
        self.selectedStylusHabit = result.stylusHabit
    }

    var body: some View
    {
        Group
        {
            Image("OtagoLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            Text("University of Otago").font(.largeTitle)
            Text("Writing Experiment").font(.largeTitle)
            Text("").font(.largeTitle)
            Text("Please provide a little information about yourself").font(.title)
        }
        Spacer()
        Group
        {
            HStack
            {
                Spacer().frame(width: 20)
                Text("Sex:").font(.title)
                Spacer()
            }
            HStack
            {
                Spacer().frame(width: 40)
                Picker("Sex:", selection: $selectedSex)
                {
                    ForEach(sexes, id: \.self)
                    {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }
            Spacer()
        }

        Group
        {
            HStack
            {
                Spacer().frame(width: 20)
                Text("Age:").font(.title)
                Spacer()
            }
            HStack
            {
                Spacer().frame(width: 40)
                Picker("Age:", selection: $selectedAge)
                {
                    ForEach(ages, id: \.self)
                    {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }
            Spacer()
        }

        Group
        {
            HStack
            {
                Spacer().frame(width: 20)
                Text("Writing Hand:").font(.title)
                Spacer()
            }
            HStack
            {
                Spacer().frame(width: 40)
                Picker("Writing Hand:", selection: $selectedWritingHand)
                {
                    ForEach(writingHand, id: \.self)
                    {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }
            Spacer()
        }

        Group
        {
            HStack
            {
                Spacer().frame(width: 20)
                Text("Handedness:").font(.title)
                Spacer()
            }
            HStack
            {
                Spacer().frame(width: 40)
                Picker("Handedness:", selection: $selectedHandedness)
                {
                    ForEach(handedness, id: \.self)
                    {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }
            Spacer()
        }

        Group
        {
            HStack
            {
                Spacer().frame(width: 20)
                Text("Writing Habit:").font(.title)
                Spacer()
            }
            HStack
            {
                Spacer().frame(width: 40)
                Picker("Writing Habit:", selection: $selectedWritingHabit)
                {
                    ForEach(writingHabit, id: \.self)
                    {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }
            Spacer()
        }
        Group
        {
            HStack
            {
                Spacer().frame(width: 20)
                Text("Stylus Habit:").font(.title)
                Spacer()
            }
            HStack
            {
                Spacer().frame(width: 40)
                Picker("Stylus Habit:", selection: $selectedStylusHabit)
                {
                    ForEach(stylusHabit, id: \.self)
                    {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }
            Spacer()
        }

        Group
        {
            HStack
            {
                Spacer().frame(width: 20)
                Text("Highest Qualification:").font(.title)
                Spacer()
            }
            HStack
            {
                Spacer().frame(width: 40)
                Picker("EducationLevel:", selection: $selectedEducationLevel)
                {
                    ForEach(educationLevel, id: \.self)
                    {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }
            Spacer()
        }

        Group
        {
            Spacer()
            HStack
            {
                Spacer()
                Button("Continue...")
                {
                    parent.coordinator.screen = Screen.writings

                    result.sex = selectedSex
                    result.age = selectedAge
                    result.handedness = selectedHandedness
                    result.writingHand = selectedWritingHand
                    result.educationLevel = selectedEducationLevel
                    switch selectedWritingHabit {
                        case "More than once a day":
                            result.writingHabit = "Regularly"
                        case "More than once a month":
                            result.writingHabit = "Irregularly"
                        case "Less than once a month":
                            result.writingHabit = "Rarely"
                        default:
                            result.writingHabit = "Withheld"
                    }
                    switch selectedStylusHabit {
                        case "More than once a day":
                            result.stylusHabit = "Regularly"
                        case "More than once a month":
                            result.stylusHabit = "Irregularly"
                        case "Less than once a month":
                            result.stylusHabit = "Rarely"
                        default:
                            result.stylusHabit = "Withheld"
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                Spacer().frame(width: 20)
                Button("QUIT")
                {
                    parent.person.rewind()
                    parent.coordinator.screen = Screen.consent
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                Spacer()
            }
            Spacer()
        }
    }
}

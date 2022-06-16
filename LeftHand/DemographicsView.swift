/*
	DemographicsView.swift
*/

import Foundation
import SwiftUI
import PencilKit

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

	var educationLevel = ["School", "Batchelor", "Masters", "Phd", "Withheld"]
	@State var selectedEducationLevel: String

	init(_ parent: LeftHandApp, result : User)
		{
		_parent = State(initialValue: parent)
		self.result = result
		self.selectedSex = result.sex
		self.selectedAge = result.age
		self.selectedHandedness = result.handedness
		self.selectedWritingHand = result.writingHand
		self.selectedEducationLevel = result.educationLevel
		}

    var body: some View
		{
		VStack
			{
			HStack
				{
				Spacer()
				Text("Sex ")
					Picker("Sex:", selection: $selectedSex)
					{
					ForEach(sexes, id: \.self)
						{
						Text($0)
						}
					}.pickerStyle(SegmentedPickerStyle())
				Spacer()
				}
			HStack
				{
				Spacer()
				Text("Age ")
				Picker("Age:", selection: $selectedAge)
					{
					ForEach(ages, id: \.self)
						{
						Text($0)
						}
					}.pickerStyle(SegmentedPickerStyle())
				Spacer()
				}
			HStack
				{
				Spacer()
				Text("Handedness ")
				Picker("Handedness:", selection: $selectedHandedness)
					{
					ForEach(handedness, id: \.self)
						{
						Text($0)
						}
					}.pickerStyle(SegmentedPickerStyle())
				Spacer()
				}
			HStack
				{
				Spacer()
				Text("Writing Hand ")
				Picker("Writing Hand:", selection: $selectedWritingHand)
					{
					ForEach(writingHand, id: \.self)
						{
						Text($0)
						}
					}.pickerStyle(SegmentedPickerStyle())
				Spacer()
				}
			HStack
				{
				Spacer()
				Text("Highest Qualification ")
				Picker("EducationLevel:", selection: $selectedEducationLevel)
					{
					ForEach(educationLevel, id: \.self)
						{
						Text($0)
						}
					}.pickerStyle(SegmentedPickerStyle())
				Spacer()
				}
			Button("Continue...")
				{
				parent.coordinator.screen = Screen.writings

				result.sex = selectedSex
				result.age = selectedAge
				result.handedness = selectedHandedness
				result.writingHand = selectedWritingHand
				result.educationLevel = selectedEducationLevel
				}
			}
		}
	}


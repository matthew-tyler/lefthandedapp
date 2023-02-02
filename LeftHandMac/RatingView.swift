//
//  RatingView.swift
//  LeftHandMac
//
//  Created by Matt Tyler on 5/01/23.
//
import SwiftUI
import CoreData
import PencilKit

struct RatingView: View {
    
    
    @Environment(\.managedObjectContext) var moc
    
    
    @FetchRequest(sortDescriptors: []) var writing: FetchedResults<Writing>
    
    
    func getImage(with id: UUID?) -> (NSImage?, Writing?)
    {
        guard let id = id else { return (nil, nil) }
        let request = Writing.fetchRequest() as NSFetchRequest<Writing>
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        guard let items = try? moc.fetch(request) else { return (nil, nil) }
        
        let imageData = items.first
        let path = try! PKDrawing(data: imageData!.data!)
        return (path.image(from: path.bounds, scale: 1), imageData)
    }
    
    @State private var score = 0
    
    var body: some View {
        
        VStack
        {
            
            
//            Image()

            
            Picker("Score 0-10", selection: $score) {
                ForEach(0...10, id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }.pickerStyle(SegmentedPickerStyle())
            Button("Submit"){
                print(score)
            }
        }
    }
    
    
}

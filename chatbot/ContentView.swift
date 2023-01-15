//
//  ContentView.swift
//  chatbot
//
//  Created by Balaska Zoltán on 2023. 01. 15..
//

import OpenAISwift
import SwiftUI

final class ViewModel: ObservableObject{
    init() {}
    
    private var client: OpenAISwift?
    
    func setup () {
        client = OpenAISwift(authToken: "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")
        
    }
    
    func send (text: String, completion: @escaping(String) -> Void){
        client?.sendCompletion(with: text, maxTokens: 1000, completionHandler: {result in
            
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
        
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    
    var body: some View {
        VStack(alignment: .leading){
            ForEach(models , id: \.self){ string in
                Text(string)
            }
            Spacer()
            
            HStack{
                TextField("Ide írj...", text: $text)
                Button("Küld"){
                    send()
                    
                }
            }
        }
        .onAppear{
            viewModel.setup()
        }
        .padding()
    }
    
    func send(){
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        models.append("Én: \(text)")
        viewModel.send(text: text) { respons in
            DispatchQueue.main.async {
                self.models.append("ChatBot mondja: "+respons)
                self.text = ""
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

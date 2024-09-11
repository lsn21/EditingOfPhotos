//
//  ImagesView.swift
//  EditingOfPhotos
//
//  Created by SIARHEI LUKYANAU on 08.09.2024.
//

import SwiftUI
import PhotosUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImagesView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    @State private var showingDrawingView = false
    @State private var showingTextEditor = false
    @State private var textToEdit = ""
    @State private var textFont: Font = .system(size: 20)
    @State private var textColor: Color = .black
    @State private var currentFilter: String = "None"

    var body: some View {
        VStack {
            if let uiImage = selectedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .rotationEffect(rotation, anchor: .center)
                    .frame(width: 300, height: 300)
                    .border(Color.black, width: 1)
                    .overlay(TextOverlay(text: textToEdit, font: textFont, color: textColor))
                    .sheet(isPresented: $showingDrawingView) {
                        DrawingView(image: $selectedImage)
                    }
            } else {
                Text("Выберите изображение")
                    .foregroundColor(.gray)
            }
            Spacer()
            ImagePicker(image: $selectedImage)
            Spacer()
            HStack {
                Button(action: { rotation += .degrees(90) }) {
                    Text("Повернуть вправо")
                }
                .padding()
                
                Button(action: { rotation -= .degrees(90) }) {
                    Text("Повернуть влево")
                }
                .padding()
                
                Button(action: { scale = 1.0; rotation = .zero }) {
                    Text("Сбросить масштаб")
                }
                .padding()
            }
            Button(action: { showingTextEditor = true }) {
                Text("Добавить текст")
            }
            .padding()
            .sheet(isPresented: $showingTextEditor) {
                TextEditorView(text: $textToEdit, font: $textFont, color: $textColor)
            }
            HStack {
                Button("Применить фильтр") {
                    applyFilter("CISepiaTone")
                }
                Button("Сбросить фильтры") {
                    if let image = selectedImage {
                        selectedImage = image // Убедитесь, что у вас есть оригинальное изображение для сброса
                    }
                }
            }
        }
        .padding()
    }
    
    private func applyFilter(_ filterName: String) {
        guard let inputImage = selectedImage else { return }
        let context = CIContext()
        let ciImage = CIImage(image: inputImage)
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let outputImage = filter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            selectedImage = UIImage(cgImage: cgImage)
        }
    }
}

struct TextOverlay: View {
    var text: String
    var font: Font
    var color: Color
    
    var body: some View {
        ZStack {
            if !text.isEmpty {
                Text(text)
                    .font(font)
                    .foregroundColor(color)
                    .offset(x: 0, y: 0) // Вы можете настроить позицию текста
            }
        }
    }
}

struct TextEditorView: View {
    @Binding var text: String
    @Binding var font: Font
    @Binding var color: Color
    
    var body: some View {
        VStack {
            TextField("Введите текст", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Сохранить") {
                // Вы можете добавить функционал для сохранения шрифта и цвета
            }
        }
        .padding()
    }
}

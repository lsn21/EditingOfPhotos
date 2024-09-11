//
//  ImagePicker.swift
//  EditingOfPhotos
//
//  Created by SIARHEI LUKYANAU on 08.09.2024.
//

import PhotosUI
import SwiftUI

struct ImagePicker: View {
    @Binding var image: UIImage?
    @State private var isImagePickerPresented = false
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        Button("Выбрать изображение") {
            isImagePickerPresented = true
        }
        .photosPicker(isPresented: $isImagePickerPresented, selection: $selectedItem)
        .onChange(of: selectedItem) { newItem in
            Task {
                // Попытка извлечь выбранный элемент в виде данных
                if let newItem = newItem {
                    // Извлечение выбранного элемента
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            image = uiImage
                        }
                    }
                }
            }
        }
    }
}

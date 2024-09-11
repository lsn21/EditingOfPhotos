//
//  DrawingView.swift
//  EditingOfPhotos
//
//  Created by SIARHEI LUKYANAU on 08.09.2024.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @Binding var image: UIImage?
    @State private var canvasView = PKCanvasView()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            CanvasView(canvasView: $canvasView) // Передаем объект PKCanvasView как Binding
                .frame(maxWidth: .infinity, maxHeight: 400)

            Button("Сохранить рисунок") {
                saveDrawing() // Вызов метода сохранения
            }
            .padding()
        }
    }

    private func saveDrawing() {
        // Начинаем создание нового графического контекста
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, 0.0)
        // Рисуем текущее состояние canvasView в контекст
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)

        // Получаем изображение из текущего графического контекста
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Обновляем изображение
        image = newImage
        presentationMode.wrappedValue.dismiss()
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView // Передаем PKCanvasView через Binding

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 2) // Установка инструмента
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Здесь можно обновить представление при необходимости
    }
}

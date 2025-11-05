import SwiftUI

struct MediaView: View {
  @StateObject private var viewModel = MediaGeneratorViewModel()
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Изображения")) {
          TextField("Количество обычных изображений", text: $viewModel.imageCountText)
            .keyboardType(.numberPad)
          
          Button("Генерировать изображения") {
            viewModel.generateImages()
          }
          
          TextField("Количество изображений с дубликатами", text: $viewModel.duplicateImageCountText)
            .keyboardType(.numberPad)
          
          Button("Генерировать с дубликатами") {
            viewModel.generateImagesWithDuplicates()
          }
        }
        
        Section(header: Text("Видео")) {
          TextField("Количество видео", text: $viewModel.videoCountText)
            .keyboardType(.numberPad)
          
          Button("Генерировать видео") {
            viewModel.generateVideos()
          }
        }
        
        Section {
          ProgressView(value: viewModel.progress)
          Text(viewModel.statusText).font(.caption)
        }
      }
      .navigationTitle("Генератор")
    }
  }
}

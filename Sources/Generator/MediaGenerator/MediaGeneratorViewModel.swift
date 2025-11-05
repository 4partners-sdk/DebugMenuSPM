import SwiftUI
import Photos
import AVFoundation
import CoreGraphics

class MediaGeneratorViewModel: ObservableObject {
  @Published var imageCountText = ""
  @Published var duplicateImageCountText = ""
  @Published var videoCountText = ""
  @Published var progress: Float = 0
  @Published var statusText = ""
  
  func generateImage(seed: Int, copyNumber: Int?) -> UIImage {
    let size = CGSize(width: 300, height: 300)
    let renderer = UIGraphicsImageRenderer(size: size)
    
    return renderer.image { context in
      let ctx = context.cgContext
      let hue = CGFloat((seed * 37) % 360) / 360.0
      let bgColor = UIColor(hue: hue, saturation: 0.6, brightness: 0.9, alpha: 1.0)
      ctx.setFillColor(bgColor.cgColor)
      ctx.fill(CGRect(origin: .zero, size: size))
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      let text = copyNumber == nil ? "Image #\(seed)" : "Image #\(seed) - Copy \(copyNumber!)"
      
      let attrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 24, weight: .bold),
        .paragraphStyle: paragraphStyle,
        .foregroundColor: UIColor.white
      ]
      
      let textRect = CGRect(x: 0, y: size.height / 2 - 20, width: size.width, height: 40)
      text.draw(with: textRect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
  }
  
  func saveImage(_ image: UIImage, creationDate: Date) {
    PHPhotoLibrary.shared().performChanges {
      let request = PHAssetCreationRequest.forAsset()
      if let data = image.jpegData(compressionQuality: 1.0) {
        request.addResource(with: .photo, data: data, options: nil)
        request.creationDate = creationDate
      }
    }
  }
  
  func generateImages() {
    guard let count = Int(imageCountText), count > 0 else { return }
    
    DispatchQueue.global().async {
      for i in 1...count {
        let image = self.generateImage(seed: i, copyNumber: nil)
        let date = Date().addingTimeInterval(Double(i))
        self.saveImage(image, creationDate: date)
        
        DispatchQueue.main.async {
          self.progress = Float(i) / Float(count)
          self.statusText = "Генерация... \(i)/\(count)"
        }
      }
      DispatchQueue.main.async {
        self.statusText = "Готово!"
      }
    }
  }
  
  func generateImagesWithDuplicates() {
    guard let groupCount = Int(duplicateImageCountText), groupCount > 0 else { return }
    
    var groupedImages: [[Int]] = []
    var total = 0
    
    for _ in 0..<groupCount {
      let copyCount = Int.random(in: 1...10)
      groupedImages.append(Array(0...copyCount))
      total += copyCount + 1
    }
    
    DispatchQueue.global().async {
      var generated = 0
      for (index, copies) in groupedImages.enumerated() {
        let seed = index + 1
        let date = Date().addingTimeInterval(Double(index))
        for copyNum in copies {
          let image = self.generateImage(seed: seed, copyNumber: copyNum == 0 ? nil : copyNum)
          self.saveImage(image, creationDate: date)
          generated += 1
          DispatchQueue.main.async {
            self.progress = Float(generated) / Float(total)
            self.statusText = "Генерация... \(generated)/\(total)"
          }
        }
        Thread.sleep(forTimeInterval: 1.0)
      }
      
      DispatchQueue.main.async {
        self.statusText = "Готово!"
      }
    }
  }
  
  func generateVideos() {
    guard let count = Int(videoCountText), count > 0 else { return }
    
    let group = DispatchGroup()
    for i in 1...count {
      group.enter()
      let duration = Int.random(in: 10...60)
      let fileName = "video_\(i)_\(Int(Date().timeIntervalSince1970))"
      generateSimpleTextVideo(fileName: fileName, text: "Видео #\(i)", backgroundSeed: i, durationInSeconds: duration) {
        DispatchQueue.main.async {
          self.progress = Float(i) / Float(count)
          self.statusText = "Генерация... \(i)/\(count)"
        }
        group.leave()
      }
    }
    
    group.notify(queue: .main) {
      self.statusText = "Все видео сгенерированы!"
    }
  }
  
  private func generateSimpleTextVideo(fileName: String, text: String, backgroundSeed: Int, durationInSeconds: Int, completion: @escaping () -> Void) {
    let size = CGSize(width: 720, height: 1280)
    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).mp4")
    let fps: Int32 = 30
    let frameCount = durationInSeconds * Int(fps)
    
    guard let writer = try? AVAssetWriter(outputURL: fileURL, fileType: .mp4) else {
      completion()
      return
    }
    
    let input = AVAssetWriterInput(mediaType: .video, outputSettings: [
      AVVideoCodecKey: AVVideoCodecType.h264,
      AVVideoWidthKey: Int(size.width),
      AVVideoHeightKey: Int(size.height)
    ])
    
    let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: [
      kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
      kCVPixelBufferWidthKey as String: Int(size.width),
      kCVPixelBufferHeightKey as String: Int(size.height)
    ])
    
    writer.add(input)
    writer.startWriting()
    writer.startSession(atSourceTime: .zero)
    
    input.requestMediaDataWhenReady(on: DispatchQueue(label: "videoQueue")) {
      var frame = 0
      while frame < frameCount {
        if input.isReadyForMoreMediaData,
           let buffer = self.createPixelBuffer(size: size, text: text, backgroundSeed: backgroundSeed) {
          let time = CMTime(value: CMTimeValue(frame), timescale: fps)
          adaptor.append(buffer, withPresentationTime: time)
          frame += 1
        }
      }
      
      input.markAsFinished()
      writer.finishWriting {
        self.saveVideoToPhotoLibrary(fileURL)
        completion()
      }
    }
  }
  
  private func createPixelBuffer(size: CGSize, text: String, backgroundSeed: Int) -> CVPixelBuffer? {
    var buffer: CVPixelBuffer?
    let attrs: [CFString: Any] = [
      kCVPixelBufferCGImageCompatibilityKey: true,
      kCVPixelBufferCGBitmapContextCompatibilityKey: true
    ]
    guard CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height),
                              kCVPixelFormatType_32ARGB, attrs as CFDictionary, &buffer) == kCVReturnSuccess,
          let pixelBuffer = buffer else { return nil }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, [])
    defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }
    
    guard let context = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer),
                                  width: Int(size.width),
                                  height: Int(size.height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    else { return nil }
    
    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    
    let hue = CGFloat((backgroundSeed * 53) % 360) / 360.0
    let bgColor = UIColor(hue: hue, saturation: 0.6, brightness: 0.8, alpha: 1.0)
    context.setFillColor(bgColor.cgColor)
    context.fill(CGRect(origin: .zero, size: size))
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let attirs: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 60),
      .foregroundColor: UIColor.white,
      .paragraphStyle: paragraphStyle
    ]
    
    let attributedString = NSAttributedString(string: text, attributes: attirs)
    let textRect = CGRect(x: 0, y: size.height / 2 - 40, width: size.width, height: 80)
    
    UIGraphicsPushContext(context)
    attributedString.draw(in: textRect)
    UIGraphicsPopContext()
    
    return pixelBuffer
  }
  
  private func saveVideoToPhotoLibrary(_ url: URL) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
    }) { success, error in
      if let error = error {
        print("Ошибка при сохранении видео: \(error.localizedDescription)")
      } else {
        print("Видео сохранено.")
      }
    }
  }
}

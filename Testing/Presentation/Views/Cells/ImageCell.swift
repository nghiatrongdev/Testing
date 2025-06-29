//
//  ImageCell.swift
//  Testing
//
//  Created by NghiaNT on 24/6/25.
//

import UIKit

class ImageCell: UITableViewCell {
    @IBOutlet weak var sizeLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    private var dataTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
        
    }
    override func prepareForReuse() {
      super.prepareForReuse()
      dataTask?.cancel()
      imgView.image = nil
    }
    
    func setupModel(_ photo: PhotoEntity) {
        print(photo)
      nameLb.text = photo.author
      sizeLb.text = "Size: \(photo.width)×\(photo.height)"

      
      if let cached = ImageCache.shared.image(for: photo.download_url) {
        imgView.image = cached
      } else {
        let url = URL(string: photo.download_url)!
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
          guard
            let self = self,
            let data = data,
            let img = UIImage(data: data)
          else { return }
          ImageCache.shared.save(img, for: photo.download_url)
          DispatchQueue.main.async {
            self.imgView.image = img
          }
        }
        dataTask?.resume()
      }
    }
}

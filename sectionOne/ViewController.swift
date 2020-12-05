//
//  ViewController.swift
//  sectionOne
//
//  Created by Maria on 04/12/2020.
//

import UIKit


class ViewController: UIViewController {
    
    fileprivate var items: [String] = [
        "image1",
        "image3",
        "image4",
        "image5",
        "image6",
        "image7",
        "image8",
        "image9",
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        
        
        view.addSubview(collection)
        
        //        collection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //        collection.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        //        collection.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collection.dataSource = self
        collection.delegate = self
        collection.dragDelegate = self
        collection.dropDelegate = self
        collection.dragInteractionEnabled = true
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        collection.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
    }
    
    fileprivate func reorderItems (coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView){
        
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            
            collectionView.performBatchUpdates ({
                self.items.remove(at: sourceIndexPath.item)
                self.items.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath)
        cell.backgroundColor = .white
        
        let image = UIImage(named: self.items[indexPath.row])
        let cellImage = UIImageView(image: image)
        //        cellImage.contentMode = .scaleToFill
        cellImage.contentMode = .scaleAspectFill
        cellImage.clipsToBounds = true
        cell.contentView.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        cellImage.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 4).isActive = true
        cellImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -4).isActive = true
        cellImage.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -0).isActive = true
        return cell
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let square = (collectionView.frame.width - 8) / 3
        
        return CGSize(width: square , height: square)
    }
}

extension ViewController : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension ViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
}

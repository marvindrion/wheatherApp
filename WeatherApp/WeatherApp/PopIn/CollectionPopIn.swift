//
//  CollectionPopIn.swift
//  WeatherApp
//
//  Created by Marvin DRION on 04/10/2017.
//  Copyright © 2017 Marvin DRION. All rights reserved.
//

import Popover

class CollectionPopIn: Popover {

    var data: [AnyObject]!
    var collectionView: UICollectionView!
    var selectedItems: [AnyObject]? = []

    weak open var delegate: CollectionPopInDelegate!

    //Init avec des données
    convenience init(delegate: CollectionPopInDelegate, data: [AnyObject], options: [PopoverOption]?) {
        self.init(delegate: delegate, data: data, options: options, showHandler: nil, dismissHandler: nil)
    }

    //Init avec des données et une taille de frame
    convenience init(delegate: CollectionPopInDelegate, data: [AnyObject], options: [PopoverOption]?, width: Double, height: Double) {
        self.init(delegate: delegate, data: data, options: options, showHandler: nil, dismissHandler: nil)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }

    init(delegate: CollectionPopInDelegate, data: [AnyObject], options: [PopoverOption]?, showHandler: (() -> Void)?, dismissHandler: (() -> Void)?) {
        super.init()
        self.delegate = delegate
        self.data = data

        let collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        //La collectionView fait 300*300 si on ne lui spécifie pas de taille dans l'init
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: collectionViewLayout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ButtonChoiceCell", bundle: Bundle.main), forCellWithReuseIdentifier: NSStringFromClass(ButtonChoiceCell.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //Affiche la popin au milieu de l'écran
    func showAsDialog() {

        print("self.collectionView.contentSize.height ", self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        if self.collectionView.collectionViewLayout.collectionViewContentSize.height < self.collectionView.frame.size.height {
            var frame: CGRect = self.collectionView.frame
            frame.size.height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionView.frame = frame

            var popFrame: CGRect = self.frame
            popFrame.size.height = self.collectionView.frame.height
           self.frame = popFrame
        }
        super.showAsDialog(self.collectionView)
    }

    func show(fromView: UIView) {
        print("self.collectionView.contentSize.height ", self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        print(collectionView.frame.size.height)
        if self.collectionView.collectionViewLayout.collectionViewContentSize.height < self.collectionView.frame.size.height {
            var frame: CGRect = self.collectionView.frame
            frame.size.height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionView.frame = frame

            var popFrame: CGRect = self.frame
            popFrame.size.height = self.collectionView.frame.height
            self.frame = popFrame
        }
        super.show(self.collectionView, fromView: fromView)
    }
}

extension CollectionPopIn: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Intégration de la sélection côté CollectionView, ne fonctionne pas en sélection multiple en l'état : est-ce un problème ?
        self.selectedItems?.removeAll()

        let selection = data[indexPath.row]
        self.selectedItems?.append(selection)

        collectionView.reloadData()

        delegate?.didSelectItem(object: selection)//data[indexPath.row])
    }
}

extension CollectionPopIn: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let choiceButtonCell: ButtonChoiceCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ButtonChoiceCell.self), for: indexPath) as! ButtonChoiceCell
        let id = self.delegate.getId(object: self.data[indexPath.row])
        choiceButtonCell.id = id
        let label = self.delegate?.getLabel(object: self.data[indexPath.row])
        choiceButtonCell.choiceLabel.text = label
        choiceButtonCell.backgroundColor = UIColor.white

        //Customise l'apparence de la cellule des items selectionnés
        if self.selectedItems != nil {
            for item in self.selectedItems! {
                let selectedItemId = self.delegate.getId(object: item)
                if id == selectedItemId {
                    choiceButtonCell.backgroundColor = UIColor(hexString: "0404B4")
                    choiceButtonCell.choiceLabel.textColor = UIColor.white
                    choiceButtonCell.layer.borderWidth = 0
                    //FIXME
                    choiceButtonCell.layer.borderColor = UIColor.black.cgColor
                    break
                } else {
                    choiceButtonCell.backgroundColor = UIColor.white
                    choiceButtonCell.choiceLabel.textColor = UIColor(hexString: "0404B4")
                    choiceButtonCell.layer.borderWidth = 1.5
                    choiceButtonCell.layer.borderColor = UIColor.lightGray.cgColor
                }
            }
        }
        return choiceButtonCell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return attributes
    }
}

extension CollectionPopIn: UICollectionViewDelegateFlowLayout {

    //Rend la taille des cellules dynamiques (en fonction de la taille des label)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let label = self.delegate.getLabel(object: self.data[indexPath.row])
        let myString: NSString = label as NSString
        //TODO : Récupérer la fontSize du storyboard pour ne pas avoir à la modifier dans la ligne ci dessous
        var size: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0)])
        size.width += 20
        size.height += 10
        return size
    }
}

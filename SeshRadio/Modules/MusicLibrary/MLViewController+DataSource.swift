//
//  MusicLibraryViewController+Extensions.swift
//  SeshRadio
//
//  Created by spooky on 1/3/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import FSPagerView

extension MLViewController: FSPagerViewDataSource, FSPagerViewDelegate, UICollectionViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == self.featuredPagerView {
            return self.featured.count
        } else if pagerView == self.albumsPagerView {
            return self.albums.count
        } else if pagerView == self.artistsPagerView {
            return self.artists.count
        }
        
        return 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView == self.featuredPagerView {
            let featured = self.featured[index]
            let cell = pagerView
                .dequeueReusableCell(withReuseIdentifier: kFeaturedCellIdentifier,
                                     at: index) as! FeaturedViewCell
            cell.setFeatured(featured)
            return cell
        } else if pagerView == self.albumsPagerView {
            let cell = pagerView
                .dequeueReusableCell(withReuseIdentifier: kAlbumCellIdentifier,
                                     at: index) as! AlbumViewCell
            let album = self.albums[index]
            
            cell.setAlbum(album)
            
            return cell
        } else if pagerView == self.artistsPagerView {
            let cell = pagerView
                .dequeueReusableCell(withReuseIdentifier: kArtistCellIdentifier,
                                     at: index) as! ArtistViewCell
            let artist = self.artists[index]
            cell.clipsToBounds = false
            
            cell.setArtist(artist)
            
            return cell
        }
        
        return FSPagerViewCell()
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if pagerView == self.artistsPagerView {
            let artist = self.artists[index]
            let controller = MLArtistViewController()
            controller.artist = artist
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else if pagerView == self.albumsPagerView {
            let album = self.albums[index]
            
            self.tracksViewer.setDataType(.albums)
            self.tracksViewer.setAlbum(album)
            
            self.navigationController?.pushViewController(self.tracksViewer, animated: true)
        } else if pagerView == self.featuredPagerView {
            //let featured = self.featured[index]
            
            let controller = MLFeaturedViewController()
            controller.featured = self.featured[index]
            //controller.featured = featured
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        FeedBackGenerator.shared.impact(style: .light)
    }

    
}



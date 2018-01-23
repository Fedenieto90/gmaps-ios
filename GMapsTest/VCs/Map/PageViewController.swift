//
//  PageViewController.swift
//  GMapsTest
//
//  Created by Federico Nieto on 1/17/18.
//  Copyright © 2018 fede. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController
{
    var pages = [UIViewController]()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
        
        var provincesBottomSheetVCs = [UINavigationController]()
        for province in ProvincesHelper.provinces() {
            let vc = getViewController(withIdentifier: "BottomSheetNav") as! UINavigationController
            vc.navigationBar.isTranslucent = false
            vc.navigationBar.setBackgroundImage(UIImage(), for: .default)
            vc.navigationBar.shadowImage = UIImage()
            (vc.childViewControllers.first as! BottomSheetVC).province = province
            (vc.childViewControllers.first as! BottomSheetVC).delegate = self
            provincesBottomSheetVCs.append(vc)
        }
        pages = provincesBottomSheetVCs
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return nil }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return ProvincesHelper.provinces().count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let province = (pageViewController.viewControllers?.first?.childViewControllers.first as! BottomSheetVC).province!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PageChanged"), object: nil, userInfo: ["province" : province])
    }
    
}

extension PageViewController : BottomSheetVCDelegate {
    
    func didChangePage(province : Province) {
        let index = ProvincesHelper.provinces().index(where: {$0.id == province.id})!
        let viewController = pages[index]
        self.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }
    
    
    
}

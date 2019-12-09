//
//  AppDelegate.swift
//  MSZNearBy
//
//  Created by MSZ on 12/5/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appDelegates: [UIApplicationDelegate]  = [AppConfigurator()]
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        for delegate in appDelegates {
            _ = delegate.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
                Singletons.coreDataStackManager.fetch(query: VenueEntity.fetchRequest()).then { (sss)  in
                                sss.forEach({ (oo) in
                                    print(message: oo.lat)
                                    print(message: oo.name)
                                    print(message: oo.location)

                                })

                }.catch { (eeee) in
                    print(message: eeee)
                }
        //       print(message: Singletons.coreDataStackManager.fetch(query: VenueEntity.fetchRequest()))
        //        let reques = ExploreVenuesAPIRequest(longLate: "31.254174,29.973721", radius: 500, offset: 4, limit: 20)
        //
        //        Singletons.apiManager.perform(apiRequest: reques,
        //                                      providerType: Singletons.apiRequestProvider,
        //                                      outputType: APIExploreResponseModel.self).catch { ( error) in
        //            print(error.localizedDescription)
        //        }.then { (sssss) in
        //            var cs =  sssss.groups?[0].items?.map({ (bbb) -> VenueEntity in
        //            let cccccc = VenueEntity(entity: VenueEntity.entity(), insertInto: nil)
        //                cccccc.venueId = bbb.venue?.venueId ?? ""
        //            cccccc.name = bbb.venue?.name ?? ""
        //                cccccc.location = bbb.venue?.location?.formattedAddress?.joined(separator: " ") ?? ""
        //            return cccccc
        //            })
        //
        //
        //            cs?.forEach({ (oo) in
        //                print(message: oo)
        //                Singletons.coreDataStackManager.insert(data: oo)
        //
        //            })
        //        }
        //
        //
        //        let request = VenuePhotosAPIRequest(venueId: "4e5a6a78b993732579f639df")
        //
        //        Singletons.apiManager.perform(apiRequest: request,
        //                                      providerType: Singletons.apiRequestProvider,
        //                                      outputType: APIVenuePhotosResponseModel.self).catch { ( error) in
        //                                        print(message: error.localizedDescription)
        //        }.then { (sssss) in
        //
        //
        //        }

        return true
    }

}

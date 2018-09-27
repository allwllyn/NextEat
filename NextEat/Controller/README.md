

NEXT EAT

    This app is for creating lists of restaurants you would like to try, or have tried and want to remember. It uses the Yelp API to for gathering restaurant information.

    Restaurants can be saved and notes can be written, and saved, about the stored restaurant.


IMPLEMENTATION

    The StartController presents a text field for searching for restaurants nearby. The top right corner of the StartController has a "List" button that will become enabled once the user has saved at least one restaurant.

    To save a restaurant, you search, and are the presented with the PlaceListController. From here, you click a restaurant that seems interesting, and will be taked to the PlaceDetailController. The PlaceDetailController shows info about the restaurant gathered using the Yelp API. If the users touches the big "+" button, the restaurant will be saved and placed on a list by the name of the in which it is located.

HOW TO BUILD

    Built with Xcode 9.4
    iOS 11.4
    Swift 4.1
    Requires UIKit and CoreData

AUTHOR

    Andrew Llewellyn - Built for Udacity iOS Developer Nanodegree final project.

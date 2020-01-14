# Whim assignment

Known issues:

- Short load time at application startup, until current location is obtained
- SVG images are not handled
- Apple Directions API was used instead of Google Directions API. I started developing using MapKit framework, and discovered too late that you cannot use Apple maps with Google Directions API (legal reasons firstly)

The application architecture is based on the coordinator pattern. Coordinators are responsible for navigation and application flow. A coordinator can handle other coordinators and handlers (these are application components with a clear, limited responsability), using a Router component (this is the component which performs navigation).
Coordinators are also responsible for clearing up all the dependencies they used, to avoid memory leaks.
Each significant logic component of an application can be a coordinator.

Main components defined in the application:

1. Coordinators

- **Application coordinator.** This is the main coordinator, which composes the application. Its responsability is to start the main flow. No view controllers are instantiated in this coordinator.

- **Navigation coordinator.** This coordinator has three responsabilities: it instantiates the Map View Controller, it handles location permissions and it handles network connectivity. This coordinator also offloads some of the Map View Controller. In our case, the navigation towards Safari when opening a Wikipedia link is performed here.

- **Permissions coordinator.** This coordinator composes two handlers, to handle location permission. It uses a pre permission handler and a location handler which display an informational alert to the user before requesting the location permission and then requests the permission if the user confirmed the alert. This flow is defined in this way to avoid users accidentaly dismissing the location permissions.

2. Handlers

- **Reachability handler.** This handler listens for network events, and when the network state changes, it notifies its parent coordinator, which in our case is the **Navigation coordinator**

- **Prepermission handler.** This handler displays and alert message to the user.

- **LocationHandler.** This handler checks for the location permission status, asks for the location permission status and listens for a location changed event. When a new location event is triggered, the handler notifies the **Navigation coordinator** which will notify the Map View Controller to load the point of interests.

3. Factories

- **Coordinator factory.** Responsible for creating coordinators.

- **Handler factory.** Responsible for creating handlers.

- **Module factory.** Responsible for instantiating view controllers and for dependency injection.

4. Router

- **Router**. Handles the navigation.


Libraries used:

1. **Alamofire**. Used for performing requests. I preferred to use this library because I have used it in all the projects I developed. It is really helpfull, especially when having to deal with authentication.

2. **RxSwift**. The API is constructed around Observables: each request is wrapped in an Observable, which is then passed towards the view client. The view client usually combines, flattens, maps the Observable, delaying the execution of the request, until subscribe is called. All the requests are performed on background work schedulers.

3. **Kingfisher**. Used for downloading the images. Very straighforward and extensible. For example, even tough now SVGs are not correctly processed, a new image processor can be created using Kingfisher, which handles SVG images. Also, has out of the box image caching.

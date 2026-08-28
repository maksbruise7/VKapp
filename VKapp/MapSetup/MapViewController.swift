import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - UI Elements
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .standard
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
    }()
    
    private let addPinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("map_add_pin".localized, for: .normal)
        button.backgroundColor = .appBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let routeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("map_route".localized, for: .normal)
        button.backgroundColor = .appGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("map_clear".localized, for: .normal)
        button.backgroundColor = .appRed
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "map_add_pin_hint".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .appTextSecondary
        label.backgroundColor = .appMapInfoBackground
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var selectedPin: MKPointAnnotation?
    private var userLocation: CLLocation?
    private var currentRoute: MKPolyline?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMapView()
        setupLocationManager()  // ✅ Теперь этот метод существует
        setupGestures()
        updateLocalization()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLocalization),
            name: Notification.Name("LanguageChanged"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .appMapBackground
        updateLocalization()
        
        view.addSubview(mapView)
        view.addSubview(addPinButton)
        view.addSubview(routeButton)
        view.addSubview(clearButton)
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addPinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addPinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addPinButton.widthAnchor.constraint(equalToConstant: 90),
            addPinButton.heightAnchor.constraint(equalToConstant: 36),
            
            routeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            routeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            routeButton.widthAnchor.constraint(equalToConstant: 110),
            routeButton.heightAnchor.constraint(equalToConstant: 36),
            
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            clearButton.widthAnchor.constraint(equalToConstant: 90),
            clearButton.heightAnchor.constraint(equalToConstant: 36),
            
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
        
        addPinButton.addTarget(self, action: #selector(addPinButtonTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsBuildings = true
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        mapView.pointOfInterestFilter = .includingAll
        
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                mapView.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    // ✅ ДОБАВЛЯЕМ МЕТОД setupLocationManager()
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupGestures() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Localization
    @objc private func updateLocalization() {
        title = "map_title".localized
        addPinButton.setTitle("map_add_pin".localized, for: .normal)
        routeButton.setTitle("map_route".localized, for: .normal)
        clearButton.setTitle("map_clear".localized, for: .normal)
        infoLabel.text = "map_add_pin_hint".localized
    }
    
    // MARK: - Actions
    @objc private func addPinButtonTapped() {
        if let userLocation = userLocation {
            let region = MKCoordinateRegion(
                center: userLocation.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            mapView.setRegion(region, animated: true)
        }
    }
    
    @objc private func routeButtonTapped() {
        guard let selectedPin = selectedPin,
              let userLocation = userLocation else {
            showAlert(message: "map_no_pin".localized)
            return
        }
        
        buildRoute(from: userLocation, to: selectedPin.coordinate)
    }
    
    @objc private func clearButtonTapped() {
        let annotationsToRemove = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(annotationsToRemove)
        
        if let route = currentRoute {
            mapView.removeOverlay(route)
            currentRoute = nil
        }
        
        selectedPin = nil
        routeButton.isEnabled = false
        routeButton.alpha = 0.5
        infoLabel.text = "map_add_pin_hint".localized
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            addPin(at: coordinate)
        }
    }
    
    // MARK: - Pin Management
    private func addPin(at coordinate: CLLocationCoordinate2D) {
        if let oldPin = selectedPin {
            mapView.removeAnnotation(oldPin)
        }
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "📍 " + "map_pin_added".localized(with: "")
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            var address = "Unknown address"
            if let placemark = placemarks?.first {
                address = placemark.name ?? placemark.locality ?? "Unknown address"
            } else {
                address = "Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)"
            }
            pin.subtitle = address
            self?.infoLabel.text = "map_pin_added".localized(with: address)
        }
        
        mapView.addAnnotation(pin)
        selectedPin = pin
        routeButton.isEnabled = true
        routeButton.alpha = 1.0
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Route Building
    private func buildRoute(from source: CLLocation, to destination: CLLocationCoordinate2D) {
        if let oldRoute = currentRoute {
            mapView.removeOverlay(oldRoute)
            currentRoute = nil
        }
        
        let sourcePlacemark = MKPlacemark(coordinate: source.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        
        infoLabel.text = "map_route_building".localized
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(message: "map_route_error".localized + ": \(error.localizedDescription)")
                    return
                }
                
                guard let route = response?.routes.first else {
                    self.showAlert(message: "map_route_not_found".localized)
                    return
                }
                
                self.currentRoute = route.polyline
                self.mapView.addOverlay(route.polyline)
                
                let distance = route.distance / 1000
                let time = route.expectedTravelTime / 60
                
                self.infoLabel.text = "map_route_ready".localized(with: distance, Int(time))
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
            }
        }
    }
    
    // MARK: - Helpers
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "info".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "CustomPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        } else {
            annotationView?.annotation = annotation
        }
        
        if let markerView = annotationView as? MKMarkerAnnotationView {
            markerView.markerTintColor = .systemRed
            markerView.glyphText = "📍"
            markerView.titleVisibility = .visible
            markerView.subtitleVisibility = .visible
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            renderer.lineDashPattern = [0, 10]
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        
        if mapView.userLocation.location == nil {
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        case .denied, .restricted:
            showAlert(message: "map_allow_location".localized)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
}

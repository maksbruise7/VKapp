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
        button.setTitle("📍 Точка", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let routeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🗺️ Маршрут", for: .normal)
        button.backgroundColor = .systemGreen
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
        button.setTitle("🗑️ Очистить", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Нажмите на карту, чтобы добавить точку"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.backgroundColor = .white.withAlphaComponent(0.9)
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
        setupLocationManager()
        setupGestures()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Карта"
        
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
            
            // Уменьшенные кнопки
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
        
        // Actions
        addPinButton.addTarget(self, action: #selector(addPinButtonTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    private func setupMapView() {
        mapView.delegate = self
        
        // Настройка внешнего вида карты
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsBuildings = true
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        mapView.pointOfInterestFilter = .includingAll
    }
    
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
            showAlert(message: "Сначала добавьте точку на карте")
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
        infoLabel.text = "Нажмите на карту, чтобы добавить точку"
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
        pin.title = "📍 Выбранная точка"
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                pin.subtitle = placemark.name ?? placemark.locality ?? "Неизвестный адрес"
            } else {
                pin.subtitle = "Широта: \(coordinate.latitude), Долгота: \(coordinate.longitude)"
            }
            self?.infoLabel.text = "📍 \(pin.subtitle ?? "")"
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
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(message: "Ошибка построения маршрута: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else {
                self.showAlert(message: "Маршрут не найден")
                return
            }
            
            self.currentRoute = route.polyline
            self.mapView.addOverlay(route.polyline)
            
            let distance = route.distance / 1000
            let time = route.expectedTravelTime / 60
            
            self.infoLabel.text = """
            🗺️ Маршрут: \(String(format: "%.1f", distance)) км, \(Int(time)) мин
            """
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }
    }
    
    // MARK: - Helpers
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Информация", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
        print("Ошибка получения местоположения: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        case .denied, .restricted:
            showAlert(message: "Разрешите доступ к геолокации в настройках")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

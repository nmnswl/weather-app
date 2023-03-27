//
//  NetworkMonitor.swift
//  WeatherApp

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public var isConnected = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        //Method to start monitoring network connection
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print(self?.isConnected ?? false)
        }
    }
    
    func stopMonitoring() {
        //Method to stop monitoring network connection
        monitor.cancel()
    }
}

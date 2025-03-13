//
//  HomeViewModel.swift
//  CathayTest
//
//  Created by 季紅 on 2025/2/8.
//
import Combine
import Foundation


// MARK: - HomeViewModelType

protocol HomeViewModelInputs {
    func viewDidLoad()
    func didSelectBalanceVersion(_ version: BalanceVersion)
    func refresh()
}

protocol HomeViewModelOutputs {
    var banners: AnyPublisher<[BannerList], Never> { get }
    var favorites: AnyPublisher<[FavoriteList], Never> { get }
    var notifications: AnyPublisher<[Message], Never> { get }
    var balance: AnyPublisher<TotalBalance?, Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
    var error: AnyPublisher<String?, Never> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

// MARK: - HomeViewModel

final class HomeViewModel: HomeViewModelType, HomeViewModelInputs, HomeViewModelOutputs {
    // MARK: - HomeViewModelType
    
    var inputs: HomeViewModelInputs { return self }
    var outputs: HomeViewModelOutputs { return self }
    
    // MARK: - HomeViewModelInputs
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    func viewDidLoad() {
        viewDidLoadSubject.send(())
    }
    
    private let balanceVersionSubject = PassthroughSubject<BalanceVersion, Never>()
    func didSelectBalanceVersion(_ version: BalanceVersion) {
        balanceVersionSubject.send(version)
    }
    
    private let refreshSubject = PassthroughSubject<Void, Never>()
    func refresh() {
        refreshSubject.send(())
    }
    
    // MARK: - HomeViewModelOutputs
    
    private let bannersSubject = CurrentValueSubject<[BannerList], Never>([])
    var banners: AnyPublisher<[BannerList], Never> { return bannersSubject.eraseToAnyPublisher() }
    
    private let favoritesSubject = CurrentValueSubject<[FavoriteList], Never>([])
    var favorites: AnyPublisher<[FavoriteList], Never> { return favoritesSubject.eraseToAnyPublisher() }
    
    private let notificationsSubject = CurrentValueSubject<[Message], Never>([])
    var notifications: AnyPublisher<[Message], Never> { return notificationsSubject.eraseToAnyPublisher() }
    
    private let balanceSubject = CurrentValueSubject<TotalBalance?, Never>(nil)
    var balance: AnyPublisher<TotalBalance?, Never> { return balanceSubject.eraseToAnyPublisher() }
    
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var isLoading: AnyPublisher<Bool, Never> { return isLoadingSubject.eraseToAnyPublisher() }
    
    private let errorSubject = PassthroughSubject<String?, Never>()
    var error: AnyPublisher<String?, Never> { return errorSubject.eraseToAnyPublisher() }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    private let apiManager: APIManager
    
    // MARK: - Initialization
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
        
        bindInputs()
    }
    
    private func bindInputs() {
        // 處理 viewDidLoad 事件
        let loadTrigger = viewDidLoadSubject
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoadingSubject.send(true)
            })
        
        // 處理刷新事件
        let refreshTrigger = refreshSubject
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoadingSubject.send(true)
            })
        
        // 合併初始加載和刷新事件
        let loadData = Publishers.Merge(loadTrigger, refreshTrigger)
        
        // 獲取橫幅資料
        loadData
            .flatMap { [weak self] _ -> AnyPublisher<[BannerList], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.fetchBanners()
            }
            .sink { [weak self] banners in
                self?.bannersSubject.send(banners)
                self?.isLoadingSubject.send(false)
            }
            .store(in: &cancellables)
        
        // 獲取收藏列表
        loadData
            .flatMap { [weak self] _ -> AnyPublisher<[FavoriteList], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.fetchFavorites()
            }
            .sink { [weak self] favorites in
                self?.favoritesSubject.send(favorites)
            }
            .store(in: &cancellables)
        
        // 獲取通知列表
        loadData
            .flatMap { [weak self] _ -> AnyPublisher<[Message], Never> in
                guard let self = self else { return Just([]).eraseToAnyPublisher() }
                return self.fetchNotifications()
            }
            .sink { [weak self] notifications in
                self?.notificationsSubject.send(notifications)
            }
            .store(in: &cancellables)
        
        // 處理餘額版本選擇
        balanceVersionSubject
            .flatMap { [weak self] version -> AnyPublisher<TotalBalance?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                return self.fetchTotalBalance(version: version)
            }
            .sink { [weak self] balance in
                self?.balanceSubject.send(balance)
            }
            .store(in: &cancellables)
        
        // 初始化時預設加載版本 1 的餘額
        viewDidLoadSubject
            .first()
            .map { _ in BalanceVersion.v1 }
            .subscribe(balanceVersionSubject)
            .store(in: &cancellables)
    }
    
    // MARK: - API Requests
    
    private func fetchBanners() -> AnyPublisher<[BannerList], Never> {
        return Future<[BannerList], APIError> { [weak self] promise in
            guard let self = self else {
                promise(.success([]))
                return
            }
            
            let targetType = BannerAPI.Banner()
            self.apiManager.request(targetType) { result in
                switch result {
                case let .success(response):
                    promise(.success(response?.bannerList ?? []))
                case let .failure(error):
                    self.errorSubject.send(error.localizedDescription)
                    promise(.success([]))
                }
            }
        }
        .catch { [weak self] error -> AnyPublisher<[BannerList], Never> in
            self?.errorSubject.send(error.localizedDescription)
            return Just([]).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    private func fetchFavorites() -> AnyPublisher<[FavoriteList], Never> {
        return Future<[FavoriteList], APIError> { [weak self] promise in
            guard let self = self else {
                promise(.success([]))
                return
            }
            
            let targetType = FavoriteListAPI.FavoriteList()
            self.apiManager.request(targetType) { result in
                switch result {
                case let .success(response):
                    promise(.success(response?.favoriteList ?? []))
                case let .failure(error):
                    self.errorSubject.send(error.localizedDescription)
                    promise(.success([]))
                }
            }
        }
        .catch { [weak self] error -> AnyPublisher<[FavoriteList], Never> in
            self?.errorSubject.send(error.localizedDescription)
            return Just([]).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    private func fetchNotifications() -> AnyPublisher<[Message], Never> {
        return Future<[Message], APIError> { [weak self] promise in
            guard let self = self else {
                promise(.success([]))
                return
            }
            
            let targetType = NotificationAPI.NotificationList()
            self.apiManager.request(targetType) { result in
                switch result {
                case let .success(response):
                    promise(.success(response?.messages ?? []))
                case let .failure(error):
                    self.errorSubject.send(error.localizedDescription)
                    promise(.success([]))
                }
            }
        }
        .catch { [weak self] error -> AnyPublisher<[Message], Never> in
            self?.errorSubject.send(error.localizedDescription)
            return Just([]).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    private enum BalanceAPIType {
        case usd1, usd2, khr1, khr2
    }
    
    private func fetchTotalBalance(version: BalanceVersion) -> AnyPublisher<TotalBalance?, Never> {
        let usdType: BalanceAPIType = (version == .v1) ? .usd1 : .usd2
        let khrType: BalanceAPIType = (version == .v1) ? .khr1 : .khr2
        
        return Publishers.Zip(
            getTotalBalance(type: usdType),
            getTotalBalance(type: khrType)
        )
        .map { usdTotal, khrTotal in
            return TotalBalance(usd: usdTotal, khr: khrTotal)
        }
        .catch { [weak self] error -> AnyPublisher<TotalBalance?, Never> in
            self?.errorSubject.send("取得總餘額失敗")
            return Just(nil).eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func getTotalBalance(type: BalanceAPIType) -> AnyPublisher<Double, APIError> {
        let savingsPublisher: AnyPublisher<Double, APIError>
        let fixedPublisher: AnyPublisher<Double, APIError>
        let digitalPublisher: AnyPublisher<Double, APIError>
        
        switch type {
        case .usd1:
            savingsPublisher = fetchBalance(for: AmountAPI.USDSavings1())
            fixedPublisher = fetchBalance(for: AmountAPI.USDFixed1())
            digitalPublisher = fetchBalance(for: AmountAPI.USDDigital1())
        case .usd2:
            savingsPublisher = fetchBalance(for: AmountAPI.USDSavings2())
            fixedPublisher = fetchBalance(for: AmountAPI.USDFixed2())
            digitalPublisher = fetchBalance(for: AmountAPI.USDDigital2())
        case .khr1:
            savingsPublisher = fetchBalance(for: AmountAPI.KHRSavings1())
            fixedPublisher = fetchBalance(for: AmountAPI.KHRFixed1())
            digitalPublisher = fetchBalance(for: AmountAPI.KHRDigital1())
        case .khr2:
            savingsPublisher = fetchBalance(for: AmountAPI.KHRSavings2())
            fixedPublisher = fetchBalance(for: AmountAPI.KHRFixed2())
            digitalPublisher = fetchBalance(for: AmountAPI.KHRDigital2())
        }
        
        return Publishers.Zip3(savingsPublisher, fixedPublisher, digitalPublisher)
            .map { $0 + $1 + $2 }
            .eraseToAnyPublisher()
    }
    
    private func fetchBalance<T: AmountAPITargetType>(for targetType: T) -> AnyPublisher<Double, APIError> where T.Response: BalanceResponse {
        return Future<Double, APIError> { [weak self] promise in
            guard let self = self else {
                promise(.success(0))
                return
            }
            
            self.apiManager.request(targetType) { result in
                switch result {
                case let .success(response):
                    let balance = response?.balanceList.reduce(0) { $0 + $1.balance } ?? 0
                    promise(.success(balance))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - 測試用的協議定義

// 為了方便測試，定義一個 APIManagerType 協議
//protocol APIManagerType {
//    func request<T: TargetType>(_ target: T, completion: @escaping (Result<T.Response?, APIError>) -> Void)
//}
//
//// 擴展現有的 APIManager 符合這個協議
//extension APIManager: APIManagerType {}

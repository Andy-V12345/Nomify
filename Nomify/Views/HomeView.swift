//
//  HomeView.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import SwiftUI
import FirebaseAuth
import CodeScanner

enum UseState {
    case normal, loading, error, showData
}

struct HomeView: View {
    
    @State var isConfiguring = false
    @State private var isViewingProfile = false
    @State var loadingText = ""
    @State var isSearchDisabled = true
    @State var isScanningDisabled = false
    @State var isTakingPhoto = false
    @State var isPhotoDisabled = false
    @State var imageData: Data = .init(capacity: 0)
    @State var isScanning = false
    @State var errorText = ""
    @State var useState: UseState = .normal
    
    @FocusState var isSearchFocused: Bool
    
    @State var foodSearch = ""
    @State var overallRisk: Double = 0
    @State var riskRatings: [String: Double] = [:]
    @State var foodItem = ""
    @State var recommendation = ""
    @State var alternatives: [Alternative] = []
    
    @Environment(AuthInfo.self) private var authInfo
    
    let firestoreServices = FirestoreServices()
    
    func loadFoodAnalysis(foodString: String) async {
        do {
            print("getting analysis")
            if let foodAnalysis = try await GeminiServices.getAnalysis(foodItem: foodString, allergenProfile: authInfo.userInfo!.allergenProfile) {
                recommendation = foodAnalysis.recommendation
                overallRisk = Double(foodAnalysis.overallRiskRating)
                
                riskRatings.removeAll()
                
                for (allergen, risk) in foodAnalysis.riskRating {
                    riskRatings[allergen] = Double(risk)
                }
                
                alternatives = foodAnalysis.alternatives
                
                useState = .showData
            }
            else {
                
                useState = .error
                errorText = "Couldn't find the food you're looking for!"
            }
            
            isSearchDisabled = false
        }
        catch {
            print("error analyzing food")
            useState = .error
            errorText = "Something went wrong! Please try again."
            isSearchDisabled = false
        }
    }
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack {
                        HStack {
                            Text("Nomify")
                                .font(.largeTitle)
                                .bold()
                            
                            Spacer()
                            
                            Button(action: {
                                isViewingProfile = true
                                isSearchFocused = false
                            }, label: {
                                Image(systemName: "person.circle.fill")
                                    .font(.title)
                            })
                        } //: Header HStack
                        .foregroundStyle(Color("themeGreen"))
                        
                        VStack(spacing: 15) {
                            SearchBar(text: $foodSearch, placeholder: "Search for a food")
                                .focused($isSearchFocused)
                                
                            HStack(spacing: 15) {
                                Button(action: {
                                    foodItem = foodSearch.trimmingCharacters(in: .whitespacesAndNewlines)
                                    isSearchFocused = false
                                    isSearchDisabled = true
                                    useState = .loading
                                    loadingText = "Nomifying your food!"
                                    
                                    Task {
                                        await loadFoodAnalysis(foodString: foodItem)
                                    }
                                }, label: {
                                    Text("Search")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .bold()
                                        .padding(.vertical, 15)
                                        .frame(maxWidth: .infinity)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("themeGreen")))
                                })
                                .disabled(foodSearch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSearchDisabled)
                                .opacity(foodSearch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSearchDisabled ? 0.6 : 1)
                                
                                Button(action: {
                                    isTakingPhoto = true
                                }, label: {
                                    Image(systemName: "camera.viewfinder")
                                        .foregroundStyle(.black)
                                        .font(.title)
                                })
                                .disabled(isPhotoDisabled)
                                .opacity(isPhotoDisabled ? 0.4 : 1)
                                
                                Button(action: {
                                    isScanning = true
                                }, label: {
                                    Image(systemName: "barcode.viewfinder")
                                        .foregroundStyle(.black)
                                        .font(.title)
                                })
                                .disabled(isScanningDisabled)
                                .opacity(isScanningDisabled ? 0.4 : 1)
                            } //: HStack
                        } //: VStack
                    } //: Header + SearchBar VStack
                    
                    if useState == .normal {
                        Text("Search a food item or scan a barcode, and Nomify will give you an analysis based on your allergen profile!")
                            .foregroundStyle(.gray)
                            .italic()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                    else if useState == .loading {
                        Spacer()
                        
                        VStack(spacing: 10) {
                            LoadingSpinner(size: 25)
                            
                            Text(loadingText)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color("themeGreen"))
                                .italic()
                            
                        }
                        
                        Spacer()
                    }
                    else if useState == .error {
                        Spacer()
                        
                        VStack(spacing: 5) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.headline)
                            
                            Text(errorText)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.subheadline)
                                
                        }
                        .bold()
                        .foregroundStyle(Color("themeGreen"))
                        
                        Spacer()
                    }
                    else {
                        VStack {
                            Text("Results for \"\(foodItem)\"")
                                .bold()
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Disclaimer: Please double-check the ingredients list and consult with a medical professional for personalized guidance.")
                                .fontWeight(.semibold)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } //: Result + Disclaimer Text VStack
                        .foregroundStyle(.black)
                        
                        ScrollView {
                            VStack(spacing: 15) {
                                VStack(spacing: 8) {
                                    Text("Risk Rating")
                                        .bold()
                                        .foregroundStyle(Color("themeGreen"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    VStack(spacing: 20) {
                                        AllergenRiskRating(allergen: "Overall Risk", riskRating: overallRisk)
                                        
                                        Text("\(recommendation)")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fontWeight(.semibold)
                                            .font(.subheadline)
                                            .foregroundStyle(.black)
                                        
                                        if !riskRatings.isEmpty {
                                            Divider()
                                            
                                            ForEach(Array(riskRatings.keys), id: \.self) { allergen in
                                                AllergenRiskRating(allergen: allergen.capitalized, riskRating: riskRatings[allergen]!)
                                            }
                                        }
                                        
                                    }
                                } //: Risk Ratings VStack
                                .padding(20)
                                .background(Color.gray.opacity(0.05).clipShape(RoundedRectangle(cornerRadius: 15)))
                                
                                if !alternatives.isEmpty {
                                    
                                    VStack(spacing: 8) {
                                        Text("Alternative Brands/Recipes")
                                            .bold()
                                            .foregroundStyle(Color("themeGreen"))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Spacer()
                                        
                                        VStack(spacing: 20) {
                                            ForEach(0..<alternatives.count, id:\.self) { i in
                                                AlternativesLink(name: alternatives[i].name, url: alternatives[i].url)
                                            }
                                        }
                                    }
                                    .padding(20)
                                    .background(Color.gray.opacity(0.05).clipShape(RoundedRectangle(cornerRadius: 15)))
                                }
                                
                            } //: ScrollView VStack
                        } //: ScrollView
                        .scrollIndicators(.hidden)
                    }
                    
                } //: VStack
                .padding(.vertical, 20)
                .padding(.horizontal, 25)
                .onChange(of: foodSearch) { old, new in
                    if new.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        isSearchDisabled = true
                    }
                    else {
                        isSearchDisabled = false
                    }
                }
                .onChange(of: useState) { old, new in
                    if new == .loading {
                        isSearchDisabled = true
                        isScanningDisabled = true
                        isPhotoDisabled = true
                    }
                    else {
                        isSearchDisabled = foodSearch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        isScanningDisabled = false
                        isPhotoDisabled = false
                    }
                }
                .onChange(of: isTakingPhoto) { old, new in
                    if old && !new && imageData.count != 0 {
                        // TODO: PROCESS imageData
                        
                        useState = .loading
                        loadingText = "Analyzing your photo!"
                        
                        Task {
                            if let processedFood = await APIServices.analyzeFoodImage(encodedImage: imageData.base64) {
                                loadingText = "Nomifying your food!"
                                foodItem = processedFood.foodItem
                                
                                await loadFoodAnalysis(foodString: processedFood.foodItem)
                            }
                            else {
                                useState = .error
                                errorText = "Couldn't identify a food item!"
                            }
                        }
                    }
                }
                .onAppear {
                    Task {
                        let userInfo = await firestoreServices.getUserInfo(uid: authInfo.user!.uid)
                        
                        authInfo.userInfo = userInfo
                        
                        if userInfo == nil || !userInfo!.isConfigured {
                            isConfiguring = true
                        }
                    }
                    
                    if foodSearch.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        isSearchDisabled = true
                    }
                }
                .fullScreenCover(isPresented: $isConfiguring, content: {
                    AllergenProfileView(allergenProfile: authInfo.userInfo?.allergenProfile)
                })
                .sheet(isPresented: $isTakingPhoto, content: {
                    ImagePicker(selectedImage: $imageData, show: $isTakingPhoto, sourceType: .camera)
                })
                .sheet(isPresented: $isScanning, content: {
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            
                            Text("Scan a barcode!")
                                .font(.headline)
                                .bold()
                            
                            Spacer()
                            
                            Button(action: {
                                isScanning = false
                            }, label: {
                                Image(systemName: "xmark")
                            })
                            
                        }
                        .foregroundStyle(Color("themeGreen"))
                        .padding(.horizontal)
                        
                        
                        CodeScannerView(codeTypes: [.upce, .ean13], completion: { result in
                            switch result {
                            case .success(let result):
                                let details = result.string
                                let barcodeId = String(details.dropFirst())
                                
                                useState = .loading
                                loadingText = "Processing your barcode!"
                                
                                Task {
                                    do {
                                        if let food = try await USDAServices.getFoodData(barcodeId: barcodeId) {
                                            
                                            loadingText = "Nomifying your food!"
                                            
                                            foodItem = "\(food.brandName ?? "") \(food.description)"
                                            await loadFoodAnalysis(foodString: foodItem)
                                        }
                                        else {
                                            useState = .error
                                            errorText = "Couldn't find your food item!"
                                        }
                                    }
                                    catch {
                                        useState = .error
                                        errorText = "Couldn't find your food item!"
                                    }
                                }
                            case .failure(let error):
                                print("error scanning: \(error.localizedDescription)")
                            }
                            isScanning = false
                        })
                    }
                    .padding(.top, 20)
                    .background(Color.white)
                })
                
                SideBar(isViewingProfile: $isViewingProfile, isConfiguring: $isConfiguring)
                
            } //: ZStack
            .preferredColorScheme(.light)
            .onTapGesture {
                isSearchFocused = false
            }
        }
        .ignoresSafeArea(.keyboard)
        
    }
}

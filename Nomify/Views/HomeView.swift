//
//  HomeView.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import SwiftUI
import FirebaseAuth
import CodeScanner

struct HomeView: View {
    
    @State var isConfiguring = false
    @State private var isViewingProfile = false
    @State var isLoading = false
    @State var showData = false
    @State var isErrorNomifying = false
    @State var isSearchDisabled = true
    @State var isScanning = false
    
    @FocusState var isSearchFocused: Bool
    
    @State var foodSearch = ""
    @State var overallRisk: Double = 0
    @State var riskRatings: [String: Double] = [:]
    @State var foodItem = ""
    @State var recommendation = ""
    @State var alternatives: [Alternative] = []
    
    @Environment(AuthInfo.self) private var authInfo
    
    let firebaseServices = FirebaseServices()
    
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
                                
                            HStack(spacing: 25) {
                                Button(action: {
                                    // TODO: SEARCH FOOD ITEM
                                    foodItem = foodSearch.trimmingCharacters(in: .whitespacesAndNewlines)
                                    isSearchFocused = false
                                    isSearchDisabled = true
                                    showData = false
                                    isLoading = true
                                    
                                    Task {
                                        do {
                                            print("getting analysis")
                                            if let foodAnalysis = try await GeminiServices.getAnalysis(foodItem: foodItem, allergenProfile: authInfo.userInfo!.allergenProfile) {
                                                recommendation = foodAnalysis.recommendation
                                                overallRisk = Double(foodAnalysis.overallRiskRating)
                                                
                                                riskRatings.removeAll()
                                                
                                                for (allergen, risk) in foodAnalysis.riskRating {
                                                    riskRatings[allergen] = Double(risk)
                                                }
                                                
                                                alternatives = foodAnalysis.alternatives
                                                
                                                isLoading = false
                                                isErrorNomifying = false
                                                showData = true
                                            }
                                            else {
                                                
                                                isLoading = false
                                                showData = true
                                                isErrorNomifying = true
                                            }
                                            
                                            isSearchDisabled = false
                                        }
                                        catch {
                                            print("error")
                                            isLoading = false
                                            showData = true
                                            isErrorNomifying = true
                                            isSearchDisabled = false
                                        }
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
                                .disabled(foodSearch == "" || isSearchDisabled)
                                .opacity(foodSearch == "" || isSearchDisabled ? 0.6 : 1)
                                
                                Button(action: {
                                    // TODO: BARCODE SCANNER
                                    isScanning = true
                                }, label: {
                                    Image(systemName: "barcode.viewfinder")
                                        .foregroundStyle(.black)
                                        .font(.title)
                                })
                            } //: HStack
                        } //: VStack
                    } //: Header + SearchBar VStack
                    
                    if showData {
                        
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
                        
                        if !isErrorNomifying {
                            
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
                        else {
                            Spacer()
                            
                            VStack(spacing: 5) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.headline)
                                
                                Text("Apologies, something went wrong! Please try again.")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.subheadline)
                                    
                            }
                            .bold()
                            .foregroundStyle(Color("themeGreen"))
                            
                            Spacer()
                        }
                    }
                    else {
                        if isLoading {
                            Spacer()
                            
                            VStack(spacing: 10) {
                                LoadingSpinner(size: 25)
                                
                                Text("Nomifying your food")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color("themeGreen"))
                                    .italic()
                                
                            }
                            
                            Spacer()
                        }
                        else {
                            Text("Search a food item or scan a barcode, and Nomify will give you an analysis based on your allergen profile!")
                                .foregroundStyle(.gray)
                                .italic()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                        }
                        
                    }
                    
                } //: VStack
                .padding(.vertical, 20)
                .padding(.horizontal, 25)
                .onChange(of: foodSearch) { old, new in
                    if new == "" {
                        isSearchDisabled = true
                    }
                    else {
                        isSearchDisabled = false
                    }
                }
                .onAppear {
                    Task {
                        let userInfo = await firebaseServices.getUserInfo(uid: authInfo.user!.uid)
                        
                        authInfo.userInfo = userInfo
                        
                        if userInfo == nil || !userInfo!.isConfigured {
                            isConfiguring = true
                        }
                    }
                    
                    if foodSearch == "" {
                        isSearchDisabled = true
                    }
                }
                .fullScreenCover(isPresented: $isConfiguring, content: {
                    AllergenProfileView(allergenProfile: authInfo.userInfo?.allergenProfile)
                })
                .sheet(isPresented: $isScanning, content: {
                    CodeScannerView(codeTypes: [.upce, .ean13], completion: { result in
                        switch result {
                        case .success(let result):
                            let details = result.string
                            print(details)
                        case .failure(let error):
                            print("error scanning: \(error.localizedDescription)")
                        }
                        isScanning = false
                    })
                })
                
                SideBar(isViewingProfile: $isViewingProfile, isConfiguring: $isConfiguring)
                
            } //: ZStack
            .preferredColorScheme(.light)
            .onTapGesture {
                isSearchFocused = false
            }
        }
        
    }
}

  /// Copyright (c) 2020 Razeware LLC
  ///
  /// Permission is hereby granted, free of charge, to any person obtaining a copy
  /// of this software and associated documentation files (the "Software"), to deal
  /// in the Software without restriction, including without limitation the rights
  /// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  /// copies of the Software, and to permit persons to whom the Software is
  /// furnished to do so, subject to the following conditions:
  ///
  /// The above copyright notice and this permission notice shall be included in
  /// all copies or substantial portions of the Software.
  ///
  /// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
  /// distribute, sublicense, create a derivative work, and/or sell copies of the
  /// Software in any work that is designed, intended, or marketed for pedagogical or
  /// instructional purposes related to programming, coding, application development,
  /// or information technology.  Permission for such use, copying, modification,
  /// merger, publication, distribution, sublicensing, creation of derivative works,
  /// or sale is expressly withheld.
  ///
  /// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  /// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  /// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  /// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  /// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  /// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  /// THE SOFTWARE.
  
  import SwiftUI
  
  extension AnyTransition {
    static var flightDetailsTransition: AnyTransition {
      let insertion = AnyTransition.move(edge: .leading)
      let removal = AnyTransition.move(edge: .bottom).combined(with: .opacity)
      return .asymmetric(insertion: insertion, removal: removal)
    }
  }

  extension AnyTransition {
    static var buttonLabelTransition: AnyTransition {
      let insertion = AnyTransition.move(edge: .leading)
      let removal = AnyTransition.scale
      return .asymmetric(insertion: insertion, removal: removal)
    }
  }
  
  struct CheckInInfo : Identifiable {
    let id = UUID()
    let airline: String
    let flight: String
  }
  
  struct FlightBoardInformation: View {
    var flight: FlightInformation
    @Binding var showModal: Bool
    @State private var showDetails = false
    
    var flightDetailAnimation : Animation {
      Animation.easeInOut
    }
    
    var body: some View {
      VStack(alignment: .leading) {
        HStack{
          Text("\(flight.airline) Flight \(flight.number)")
            .font(.largeTitle)
          Spacer()
          Button("Done", action: {
            self.showModal = false
          })
        }
        Text("\(flight.direction == .arrival ? "From: " : "To: ") \(flight.otherAirport)")
        Text(flight.flightStatus)
          .foregroundColor(Color(flight.timelineColor))
        FlightConditionals(flight: self.flight)
        Button(action: {
          withAnimation {
            self.showDetails.toggle()
          }
        }) {
          HStack {
            if showDetails {
              Text("Hide Details")
              .transition(.buttonLabelTransition)
            } else {
              Text("Show Details")
              .transition(.buttonLabelTransition)
            }
            Spacer()
            Image(systemName: "chevron.up.square")
              .scaleEffect(showDetails ? 2 : 1)
              .rotationEffect(.degrees(showDetails ? 0 : 180))
              .animation(flightDetailAnimation)
          }
        }
        if showDetails {
          FlightDetails(flight: flight)
            .transition(.flightDetailsTransition)
        }
        Spacer()
      }.font(.headline).padding(10)
    }
  }
  
  struct FlightBoardInformation_Previews: PreviewProvider {
    static var previews: some View {
      FlightBoardInformation(flight:
        FlightInformation.generateFlight(0),
                             showModal: .constant(true))
    }
  }

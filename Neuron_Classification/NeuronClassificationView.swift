//
//MIT License
//
//Copyright © 2025 Cong Le
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
//
//  NeuronClassificationView.swift
//  Neuron_Classification
//
//  Created by Cong Le on 6/29/25.
//

import SwiftUI

// MARK: - Data Models
// It's a best practice to model your data separately from your views.
// This makes the code cleaner, more testable, and easier to manage.

/// Represents the functional role of a neurotransmitter.
enum NeurotransmitterFunction: String, CaseIterable {
    case excitatory = "Excitatory"
    case inhibitory = "Inhibitory"
    case modulatory = "Modulatory"

    /// Provides a distinct color for each function type for better UI visualization.
    var color: Color {
        switch self {
        case .excitatory: .red
        case .inhibitory: .blue
        case .modulatory: .purple
        }
    }
}

/// A structure to hold information about a specific neuron polarity type.
struct NeuronPolarityType: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let example: String
    let iconName: String
}

/// A structure to hold information about a specific neurotransmitter.
struct Neurotransmitter: Identifiable {
    let id = UUID()
    let name: String
    let function: NeurotransmitterFunction
    let keyRoles: String
    let iconName: String
}

// MARK: - View Model / Data Source
// This class acts as a source of truth for the view's data. In a larger app,
// this might fetch data from a network or database.

class NeuronClassificationViewModel: ObservableObject {
    
    /// An array of structural classifications for neurons based on their polarity.
    let polarityTypes: [NeuronPolarityType] = [
        .init(name: "Multipolar", description: "One axon and many dendrites.", example: "Most common type in the CNS (e.g., motor neurons).", iconName: "arrow.up.and.down.and.arrow.left.and.right"),
        .init(name: "Bipolar", description: "One axon and one dendrite.", example: "Found in retina, olfactory system.", iconName: "arrow.up.and.down"),
        .init(name: "Unipolar", description: "Single process emerges from soma.", example: "Primarily sensory neurons (e.g., dorsal root ganglia).", iconName: "arrow.up"),
        .init(name: "Anaxonic", description: "Axon is indistinguishable from dendrites.", example: "Found in the brain and retina.", iconName: "circle.grid.3x3.fill")
    ]
    
    /// An array of key neurotransmitters, classified by their primary function.
    let neurotransmitters: [Neurotransmitter] = [
        .init(name: "Glutamate", function: .excitatory, keyRoles: "The primary excitatory neurotransmitter; crucial for learning and memory.", iconName: "brain.head.profile"),
        .init(name: "GABA", function: .inhibitory, keyRoles: "The primary inhibitory neurotransmitter; reduces neuronal excitability throughout the brain.", iconName: "bed.double.fill"),
        .init(name: "Dopamine", function: .modulatory, keyRoles: "Controls reward, motivation, and motor control. Implicated in Parkinson's disease.", iconName: "smiley.fill"),
        .init(name: "Serotonin", function: .modulatory, keyRoles: "Regulates mood, appetite, and sleep. Targeted by many antidepressants.", iconName: "dial.medium.fill"),
        .init(name: "Acetylcholine", function: .excitatory, keyRoles: "Activates muscles at the neuromuscular junction; also involved in memory.", iconName: "figure.run"),
        .init(name: "Noradrenaline", function: .excitatory, keyRoles: "Governs arousal, alertness, and the 'fight-or-flight' response.", iconName: "bolt.fill")
    ]
}

// MARK: - Main View

/// A view that presents the different ways neurons are classified.
/// It is structured into three clear sections: Structural, Functional, and by Neurotransmitter.
struct NeuronClassificationView: View {
    
    /// The source of data for this view.
    @StateObject private var viewModel = NeuronClassificationViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    structuralSection
                    functionalSection
                    neurotransmitterSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Neuron Classification")
        }
    }
    
    /// The UI section for displaying structural classifications.
    private var structuralSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("1. Structural Classification (by Polarity)")
                .font(.title2).bold()
                .padding(.bottom, 5)
            
            Text("Based on the number of processes (neurites) extending from the cell body (soma).")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.polarityTypes) { polarityType in
                        PolarityCardView(polarityType: polarityType)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
            // A subtle negative horizontal padding to make the scroll view touch the screen edges.
            .padding(.horizontal, -20)
        }
    }
    
    /// The UI section for displaying functional classifications.
    private var functionalSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("2. Functional Classification (by Signal Direction)")
                .font(.title2).bold()
            
            Text("Based on the direction of signal transmission relative to the Central Nervous System (CNS).")
                .font(.subheadline)
                .foregroundColor(.secondary)

            FunctionalPathwayView()
        }
    }
    
    /// The UI section for displaying classifications by neurotransmitter.
    private var neurotransmitterSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("3. Classification by Neurotransmitter")
                .font(.title2).bold()
            
            Text("Neurons can be grouped by the primary chemical messenger they release.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                ForEach(viewModel.neurotransmitters) { neurotransmitter in
                    NeurotransmitterRowView(neurotransmitter: neurotransmitter)
                }
            }
        }
    }
}

// MARK: - Child Views (Composition)

/// A card view to display a single structural neuron type.
struct PolarityCardView: View {
    let polarityType: NeuronPolarityType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: polarityType.iconName)
                .font(.title)
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(polarityType.name)
                .font(.headline)
                .bold()
            
            Text(polarityType.description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(polarityType.example)
                .font(.caption2)
                .padding(.top, 5)
                .foregroundColor(.primary.opacity(0.7))
        }
        .padding()
        .frame(width: 180, height: 180, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}


/// A view that visually represents the functional pathway of a neural signal.
struct FunctionalPathwayView: View {
    var body: some View {
        VStack(spacing: 0) {
            FunctionalRoleView(
                icon: "sensor.tag.fill",
                title: "Stimulus",
                subtitle: "(Light, Sound, Touch)",
                color: .green
            )
            
            Image(systemName: "arrow.down.circle.fill")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.vertical, 8)
                
            FunctionalRoleView(
                icon: "wave.3.right.circle.fill",
                title: "Afferent (Sensory) Neuron",
                subtitle: "Transmits signal towards CNS",
                color: .blue
            )

            Image(systemName: "arrow.down.circle.fill")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.vertical, 8)
            
            FunctionalRoleView(
                icon: "link.circle.fill",
                title: "Interneuron",
                subtitle: "Connects neurons within CNS",
                color: .orange
            )
            
            Image(systemName: "arrow.down.circle.fill")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.vertical, 8)
            
            FunctionalRoleView(
                icon: "wave.3.left.circle.fill",
                title: "Efferent (Motor) Neuron",
                subtitle: "Transmits signal away from CNS",
                color: .purple
            )

            Image(systemName: "arrow.down.circle.fill")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.vertical, 8)
            
            FunctionalRoleView(
                icon: "figure.walk.motion",
                title: "Effector",
                subtitle: "(Muscle or Gland)",
                color: .red
            )
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
    }
}

/// A helper view for `FunctionalPathwayView` to reduce code duplication.
struct FunctionalRoleView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

/// A view that displays information about a single neurotransmitter in a list format.
struct NeurotransmitterRowView: View {
    let neurotransmitter: Neurotransmitter

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: neurotransmitter.iconName)
                .font(.title2)
                .frame(width: 30)
                .foregroundColor(neurotransmitter.function.color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(neurotransmitter.name)
                    .font(.headline)
                
                Text(neurotransmitter.keyRoles)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text(neurotransmitter.function.rawValue)
                .font(.caption.bold())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(neurotransmitter.function.color.opacity(0.2))
                .foregroundColor(neurotransmitter.function.color)
                .cornerRadius(8)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
}



// MARK: - Preview
// This allows you to see the view's design in Xcode without running the app.
#Preview {
    NeuronClassificationView()
}

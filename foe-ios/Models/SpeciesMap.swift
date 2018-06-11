//
//  SpeciesMap.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-06-10.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation

class SpeciesMap {
    
    static private var map = [
        "bombus_impatiens": "Common eastern bumble bee",
        "bombus_tenarius": "Tri-coloured bumble bee",
        "bombus_rufocinctus": "Red-belted bumble bee",
        "bombus_bimaculatus": "Two-spotted bumble bee",
        "bombus_borealis": "Northern amber bumble bee",
        "bombus_vagans": "Half-black bumble bee",
        "bombus_affinis": "Rusty-patched bumble bee",
        "bombus_griseocollis": "Brown-belted bumble bee",
        "bombus_citrinus": "Lemon cuckoo bumble bee",
        "bombus_perplexus": "Confusing bumble bee",
        "bombus_pensylvanicus": "American bumble bee",
        "bombus_sylvicola": "Forest bumble bee",
        "bombus_sandersoni": "Sanderson bumble bee",
        "bombus_nevadensis": "Nevada bumble bee",
        "bombus_auricomus": "Black and gold bumble bee",
        "bombus_terricola": "Yellow-banded bumble bee",
        "bombus_fervidus": "Yellow bumble bee",
        "bombus_flavifrons": "Yellow head bumble bee",
        "bombus_occidentalis": "Common western bumble bee",
        "bombus_melanopygus": "Black tail bumble bee",
        "bombus_bifarius": "Two-form bumble bee",
        "bombus_huntii": "Hunt bumble bee",
        "bombus_vosnesenski": "Vosnesensky bumble bee",
        "bombus_cryptarum": "Cryptic bumble bee",
        "bombus_mixtus": "Fuzzy-horned bumble bee",
        "bombus_centralis": "Central bumble bee",
        "bombus_bohemicus": "Gypsy cuckoo bumble bee",
        ]
    
    static func getBinomialName(sighting:Sighting) -> String {
        return "Bombus " + sighting.getSpecies()
    }
    
    static func getCommonName(sighting:Sighting) -> String {
        return map["bombus_" + sighting.getSpecies()]!
    }
}

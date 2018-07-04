//
//  Nutrient.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//
// A Struct for representing a nutrient.
// Contains static instances of all possible nutrients.

import Foundation

struct Nutrient {
	// MARK: Properties
	let nutrientId: Int
	let name: String
	let unit: Unit
	
	init(_ nutrientId: Int, _ name: String, _ unit: Unit) {
		self.nutrientId = nutrientId
		self.name = name
		self.unit = unit
	}
	
	//Static predefined Nutrients
	static let Water = Nutrient(255, "Water", Unit.Gram)
	static let Energy_KCAL = Nutrient(208, "Energy", Unit.KCAL)
	static let Energy_KJ = Nutrient(268, "Energy", Unit.KJ)
	static let Protein = Nutrient(203, "Protein", Unit.Gram)
	static let Total_lipid = Nutrient(204, "Total_lipid (fat)", Unit.Gram)
	static let Ash = Nutrient(207, "Ash", Unit.Gram)
	static let Carbohydrate_by_difference = Nutrient(205, "Carbohydrate_by_difference", Unit.Gram)
	static let Fiber_total_dietary = Nutrient(291, "Fiber_total_dietary", Unit.Gram)
	static let Fiber_soluble = Nutrient(295, "Fiber_soluble", Unit.Gram)
	static let Fiber_insoluble = Nutrient(297, "Fiber_insoluble", Unit.Gram)
	static let Sugars_total = Nutrient(269, "Sugars_total", Unit.Gram)
	static let Sugars_added = Nutrient(539, "Sugars_added", Unit.Gram)
	static let Sucrose = Nutrient(210, "Sucrose", Unit.Gram)
	static let Glucose = Nutrient(211, "Glucose (dextrose)", Unit.Gram)
	static let Fructose = Nutrient(212, "Fructose", Unit.Gram)
	static let Lactose = Nutrient(213, "Lactose", Unit.Gram)
	static let Maltose = Nutrient(214, "Maltose", Unit.Gram)
	static let Galactose = Nutrient(287, "Galactose", Unit.Gram)
	static let Sugar_alcohols = Nutrient(299, "Sugar_alcohols", Unit.Gram)
	static let Starch = Nutrient(209, "Starch", Unit.Gram)
	static let Calcium = Nutrient(301, "Calcium", Unit.Miligram)
	static let Iron = Nutrient(303, "Iron", Unit.Miligram)
	static let Magnesium = Nutrient(304, "Magnesium", Unit.Miligram)
	static let Phosphorus = Nutrient(305, "Phosphorus", Unit.Miligram)
	static let Potassium = Nutrient(306, "Potassium", Unit.Miligram)
	static let Sodium = Nutrient(307, "Sodium", Unit.Miligram)
	static let Zinc = Nutrient(309, "Zinc", Unit.Miligram)
	static let Copper = Nutrient(312, "Copper", Unit.Miligram)
	static let Manganese = Nutrient(315, "Manganese", Unit.Miligram)
	static let Selenium = Nutrient(317, "Selenium", Unit.Microgram)
	static let Fluoride = Nutrient(313, "Fluoride", Unit.Microgram)
	static let Iodine = Nutrient(314, "Iodine", Unit.IU)
	static let Vitamin = Nutrient(401, "Vitamin C", Unit.Miligram)
	static let Thiamin = Nutrient(404, "Thiamin", Unit.Miligram)
	static let Riboflavin = Nutrient(405, "Riboflavin", Unit.Miligram)
	static let Niacin = Nutrient(406, "Niacin", Unit.Miligram)
	static let Pantothenic = Nutrient(410, "Pantothenic acid", Unit.Miligram)
	static let VitaminB6 = Nutrient(415, "VitaminB6", Unit.Miligram)
	static let Folate_total = Nutrient(417, "Folate_total", Unit.Microgram)
	static let Folic_acid = Nutrient(431, "Folic_acid", Unit.Microgram)
	static let Folate_food = Nutrient(432, "Folate_food", Unit.Microgram)
	static let Folate_DFE = Nutrient(435, "Folate_DFE", Unit.Microgram)
	static let Choline_total = Nutrient(421, "Choline_total", Unit.Miligram)
	static let Betaine = Nutrient(454, "Betaine", Unit.Miligram)
	static let VitaminB12 = Nutrient(418, "VitaminB12", Unit.Microgram)
	static let VitaminB12_added = Nutrient(578, "VitaminB12_added", Unit.Microgram)
	static let Biotin = Nutrient(416, "Biotin", Unit.IU)
	static let VitaminA_RAE = Nutrient(320, "VitaminA_RAE", Unit.Microgram)
	static let Retinol = Nutrient(319, "Retinol", Unit.Microgram)
	static let Carotene_beta = Nutrient(321, "Carotene_beta", Unit.Microgram)
	static let Carotene_alpha = Nutrient(322, "Carotene_alpha", Unit.Microgram)
	static let Cryptoxanthin_beta = Nutrient(334, "Cryptoxanthin_beta", Unit.Microgram)
	static let VitaminA_IU = Nutrient(318, "VitaminA_IU", Unit.IU)
	static let Lycopene = Nutrient(337, "Lycopene", Unit.Microgram)
	static let Lutein_and_zeaxanthin = Nutrient(338, "Lutein_and_zeaxanthin", Unit.Microgram)
	static let VitaminE = Nutrient(323, "VitaminE_alpha_tocopherol", Unit.Miligram)
	static let VitaminE_added = Nutrient(573, "VitaminE_added", Unit.Miligram)
	static let Tocopherol_beta = Nutrient(341, "Tocopherol_beta", Unit.Miligram)
	static let Tocopherol_gamma = Nutrient(342, "Tocopherol_gamma", Unit.Miligram)
	static let Tocopherol_delta = Nutrient(343, "Tocopherol_delta", Unit.Miligram)
	static let Tocotrienol_alpha = Nutrient(344, "Tocotrienol_alpha", Unit.Miligram)
	static let Tocotrienol_beta = Nutrient(345, "Tocotrienol_beta", Unit.Miligram)
	static let Tocotrienol_gamma = Nutrient(346, "Tocotrienol_gamma", Unit.Miligram)
	static let Tocotrienol_delta = Nutrient(347, "Tocotrienol_delta", Unit.Miligram)
	static let Vitamin_D_D2_and_D3 = Nutrient(328, "Vitamin_D_D2_and_D3", Unit.Microgram)
	static let Vitamin_D2_ergocalciferol = Nutrient(325, "Vitamin_D2_ergocalciferol", Unit.Microgram)
	static let Vitamin_D3_cholecalciferol = Nutrient(326, "Vitamin_D3_cholecalciferol", Unit.Microgram)
	static let Vitamin_D = Nutrient(324, "Vitamin_D", Unit.IU)
	static let Vitamin_K_phylloquinone = Nutrient(430, "Vitamin_K_phylloquinone", Unit.Microgram)
	static let Dihydrophylloquinone = Nutrient(429, "Dihydrophylloquinone", Unit.Microgram)
	static let Menaquinone_4 = Nutrient(428, "Menaquinone_4", Unit.Microgram)
	static let Fatty_acids_total_saturated = Nutrient(606, "Fatty_acids_total_saturated", Unit.Gram)
	static let Fatty_acids_total_monounsaturated = Nutrient(645, "Fatty_acids_total_monounsaturated", Unit.Gram)
	static let Fatty_acids_total_polyunsaturated = Nutrient(646, "Fatty_acids_total_polyunsaturated", Unit.Gram)
	static let Fatty_acids_total_trans = Nutrient(605, "Fatty_acids_total_trans", Unit.Gram)
	static let Fatty_acids_total_trans_monoenoic = Nutrient(693, "Fatty_acids_total_trans_monoenoic", Unit.Gram)
	static let Fatty_acids_total_trans_polyenoic = Nutrient(695, "Fatty_acids_total_trans_polyenoic", Unit.Gram)
	static let Cholesterol = Nutrient(601, "Cholesterol", Unit.Miligram)
	static let Phytosterols = Nutrient(636, "Phytosterols", Unit.Miligram)
	static let Stigmasterol = Nutrient(638, "Stigmasterol", Unit.Miligram)
	static let Campesterol = Nutrient(639, "Campesterol", Unit.Miligram)
	static let Beta_sitosterol = Nutrient(641, "Beta_sitosterol", Unit.Miligram)
	static let Tryptophan = Nutrient(501, "Tryptophan", Unit.Gram)
	static let Threonine = Nutrient(502, "Threonine", Unit.Gram)
	static let Isoleucine = Nutrient(503, "Isoleucine", Unit.Gram)
	static let Leucine = Nutrient(504, "Leucine", Unit.Gram)
	static let Lysine = Nutrient(505, "Lysine", Unit.Gram)
	static let Methionine = Nutrient(506, "Methionine", Unit.Gram)
	static let Cystine = Nutrient(507, "Cystine", Unit.Gram)
	static let Phenylalanine = Nutrient(508, "Phenylalanine", Unit.Gram)
	static let Tyrosine = Nutrient(509, "Tyrosine", Unit.Gram)
	static let Valine = Nutrient(510, "Valine", Unit.Gram)
	static let Arginine = Nutrient(511, "Arginine", Unit.Gram)
	static let Histidine = Nutrient(512, "Histidine", Unit.Gram)
	static let Alanine = Nutrient(513, "Alanine", Unit.Gram)
	static let Aspartic_acid = Nutrient(514, "Aspartic_acid", Unit.Gram)
	static let Glutamic_acid = Nutrient(515, "Glutamic_acid", Unit.Gram)
	static let Glycine = Nutrient(516, "Glycine", Unit.Gram)
	static let Proline = Nutrient(517, "Proline", Unit.Gram)
	static let Serine = Nutrient(518, "Serine", Unit.Gram)
	static let Hydroxyproline = Nutrient(521, "Hydroxyproline", Unit.Gram)
	static let Alcohol_ethyl = Nutrient(221, "Alcohol_ethyl", Unit.Gram)
	static let Caffeine = Nutrient(262, "Caffeine", Unit.Miligram)
	static let Theobromine = Nutrient(263, "Theobromine", Unit.Miligram)
	
	// Test nutrients
//	static let TestBitterNutrientA = Nutrient(276, "TestBitterNutrientA", Unit.Miligram)
//	static let TestBitterNutrientB = Nutrient(277, "TestBitterNutrientB", Unit.Miligram)
}

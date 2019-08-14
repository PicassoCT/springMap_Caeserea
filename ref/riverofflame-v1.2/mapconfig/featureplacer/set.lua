----------------------------------------------------------

local setcfg = {
	unitlist = {
	},
	buildinglist = {
	},
	objectlist = {
		-- geo
		{ name = 'GDecal'	,x = 1866	,z = 652	,rot = "0" },
		{ name = 'GDecal'	,x = 5535	,z = 1533	,rot = "0" },
		{ name = 'GDecal'	,x = 5300	,z = 5488	,rot = "0" },
		{ name = 'GDecal'	,x = 1637	,z = 4630	,rot = "0" },

		-- n
		{ name = 'GreyRock3'	,x = 2500	,z = 300	,rot = "10000" },
		{ name = 'GreyRock4'	,x = 3200	,z = 450	,rot = "30" },
		{ name = 'GreyRock4'	,x = 3700	,z = 550	,rot = "10000" },
		{ name = 'GreyRock3'	,x = 4000	,z = 1600	,rot = "23000" },
		{ name = 'GreyRock3'	,x = 4700	,z = 530	,rot = "33000" },
		{ name = 'GreyRock4'	,x = 5000	,z = 1400	,rot = "20000" },
		{ name = 'GreyRock4'	,x = 6000	,z = 630	,rot = "12000" },
		{ name = 'GreyRock3'	,x = 6500	,z = 2400	,rot = "0" },

		{ name = 'GreyRock5'	,x = 2800	,z = 600	,rot = "0" },
		{ name = 'GreyRock6'	,x = 3200	,z = 450	,rot = "12000" },
		{ name = 'GreyRock6'	,x = 3700	,z = 700	,rot = "0" },
		{ name = 'GreyRock5'	,x = 4200	,z = 1900	,rot = "33000" },
		{ name = 'GreyRock5'	,x = 4800	,z = 1000	,rot = "0" },
		{ name = 'GreyRock6'	,x = 4900	,z = 2340	,rot = "1000" },
		{ name = 'GreyRock6'	,x = 6400	,z = 1100	,rot = "0" },
		{ name = 'GreyRock5'	,x = 6900	,z = 2700	,rot = "8700" },

		{ name = 'GreyRock5'	,x = 3400	,z = 930	,rot = "0" },
		{ name = 'GreyRock6'	,x = 3500	,z = 820	,rot = "3000" },
		{ name = 'GreyRock6'	,x = 3500	,z = 230	,rot = "0" },
		{ name = 'GreyRock5'	,x = 4300	,z = 1730	,rot = "25000" },
		{ name = 'GreyRock5'	,x = 4600	,z = 1120	,rot = "0" },
		{ name = 'GreyRock6'	,x = 4900	,z = 2340	,rot = "10000" },
		{ name = 'GreyRock6'	,x = 5900	,z = 2350	,rot = "12000" },
		{ name = 'GreyRock5'	,x = 7000	,z = 1600	,rot = "0" },


		-- s
		{ name = 'GreyRock3'	,x = 7168-2500	,z = 6144-300	,rot = "0" },
		{ name = 'GreyRock4'	,x = 7168-3200	,z = 6144-450	,rot = "7800" },
		{ name = 'GreyRock4'	,x = 7168-3700	,z = 6144-550	,rot = "10000" },
		{ name = 'GreyRock3'	,x = 7168-4000	,z = 6144-1600	,rot = "0" },
		{ name = 'GreyRock3'	,x = 7168-4700	,z = 6144-530	,rot = "0" },
		{ name = 'GreyRock4'	,x = 7168-5000	,z = 6144-1400	,rot = "10000" },
		{ name = 'GreyRock4'	,x = 7168-6000	,z = 6144-630	,rot = "33000" },
		{ name = 'GreyRock3'	,x = 7168-6500	,z = 6144-2400	,rot = "0" },

		{ name = 'GreyRock5'	,x = 7168-2800	,z = 6144-600	,rot = "0" },
		{ name = 'GreyRock6'	,x = 7168-3200	,z = 6144-450	,rot = "30000" },
		{ name = 'GreyRock6'	,x = 7168-3700	,z = 6144-700	,rot = "0" },
		{ name = 'GreyRock5'	,x = 7168-4200	,z = 6144-1900	,rot = "0" },
		{ name = 'GreyRock5'	,x = 7168-4930	,z = 6144-1120	,rot = "0" },
		{ name = 'GreyRock6'	,x = 7168-4900	,z = 6144-2340	,rot = "33000" },
		{ name = 'GreyRock6'	,x = 7168-6400	,z = 6144-1100	,rot = "13000" },
		{ name = 'GreyRock5'	,x = 7168-6900	,z = 6144-2700	,rot = "22000" },

		{ name = 'GreyRock5'	,x = 7168-3400	,z = 6144-930	,rot = "0" },
		{ name = 'GreyRock6'	,x = 7168-3500	,z = 6144-820	,rot = "11000" },
		{ name = 'GreyRock6'	,x = 7168-3500	,z = 6144-230	,rot = "23000" },
		{ name = 'GreyRock5'	,x = 7168-4300	,z = 6144-1730	,rot = "33000" },
		{ name = 'GreyRock5'	,x = 7168-4600	,z = 6144-1120	,rot = "22000" },
		{ name = 'GreyRock6'	,x = 7168-4900	,z = 6144-2340	,rot = "0" },
		{ name = 'GreyRock6'	,x = 7168-5900	,z = 6144-2350	,rot = "11000" },
		{ name = 'GreyRock5'	,x = 7168-7000	,z = 6144-1600	,rot = "0" },
	},
}
return setcfg
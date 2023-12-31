const growthCurveConfig = {
    colCount : 28,
    rowCount : 90,
    xAxis: function(customAxis){
        var xAxisArr = [];
        for(var i=0; i <= this.colCount; i++){
            xAxisArr.push({
                index: i,
                desc: i+22,
                showDesc : (i%2 == 0) ? true : false,
                subDesc: (customAxis)&&(customAxis.length)&&(i >= customAxis.length) ? "" : customAxis[i]
            });
        }
        return xAxisArr;
    },
    yAxisArr:[
        {
            code: "lengthUnit",
            desc: "长度左侧垂直坐标轴",
            unitDesc: "Centimeters",
            startRow: 45,
            endRow: 90,
            minimum: 15,
            maximum: 60,
            interval: 1,
            align: "left"
        },{
            code: "weightUnit",
            desc: "重量右侧垂直坐标轴",
            unitDesc: "Weight(kilograms)",
            startRow: 0,
            endRow: 70,
            minimum: 0,
            maximum: 7,
            interval: 0.1,
            align: "right"
        },{
            code: "weightUnit2",
            desc: "重量左侧垂直坐标轴",
            unitDesc: "Weight(kilograms)",
            startRow: 0,
            endRow: 40,
            minimum: 0,
            maximum: 4,
            interval: 0.1,
            align: "left"
        },{
            code: "lengthUnit2",
            desc: "长度右侧垂直坐标轴",
            unitDesc: "Centimeters",
            startRow: 70,
            endRow: 90,
            minimum: 40,
            maximum: 60,
            interval: 1,
            align: "right"
        }
    ],
    lengend: [
        {
            code: "crossLine",
            desc: "叉线",
            type: "crossLine",
            strokeColor: "blue",
            data: [{x:-4,y:4},{x:4,y:-4},{x:-4,y:-4},{x:4,y:4}]
        }
    ],
    strokeColor : "black",
    curve:[
        {
            code: "UpperMaxLengthLimit",	///身高3%
            desc: "女孩身长最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"3%", fontSize: 15, yOffSet: -8, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.15 *x *x + 0.35*x + 25.5;
				var y = -0.0009*x*x*x+0.0271*x*x+1.0021*x+24.587;
				//var y = 0.00005*x*x*x*x-0.0036*x*x*x+0.0778*x*x+0.6617*x+25.158;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///身高10%
            desc: "女孩身长最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"10%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.15 *x *x + 0.35*x + 25.5;
				//var y = -0.0008*x*x*x+0.018*x*x+1.1491*x+25.412;
				var y = 0.00005*x*x*x*x-0.0037*x*x*x+0.0742*x*x+0.7723*x+26.044;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///身高50%
            desc: "女孩身长最大范围",
            lineDash: [5,0],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"50%", fontSize: 15, yOffSet: -15, strokeColor: "black"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = -0.0198 *x *x + 1.6655*x + 26.737;
				//var y = -0.0008*x*x*x+0.018*x*x+1.1491*x+25.412;
				//var y = 0.00005*x*x*x*x-0.0037*x*x*x+0.0742*x*x+0.7723*x+26.044;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///身高90%
            desc: "女孩身长最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"90%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0251 *x *x + 1.8098*x + 29.006;
				//var y = -0.024 *x *x + 1.784*x + 29.103;
				//var y = 0.00001*x*x*x-0.0257*x*x+1.8169*x+28.988;
				var y = 0.0002*x*x*x-0.0318*x*x+1.8766*x+28.86;
				//var y = 0.00009*x*x*x*x-0.0049*x*x*x+0.0635*x*x+1.2376*x+29.931;
				//var y = 0.000000006*x*x*x*x*x+0.00009*x*x*x*x-0.0049*x*x*x+0.0634*x*x+1.2381*x+29.93;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///身高97%
            desc: "女孩身长最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"97%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"Length", fontSize: 20, yOffSet: -80, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0275 *x *x + 1.872*x + 30.083;
				var y = 0.0003*x*x*x-0.0385*x*x+2.0017*x+29.743;
				//var y = 0.00005*x*x*x*x-0.0036*x*x*x+0.0778*x*x+0.6617*x+25.158;
                return y;
            }
        },	
		{
            code: "UpperMaxLengthLimit",	///体重3%
            desc: "女孩体重最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"3%", fontSize: 15, yOffSet: -8, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.15 *x *x + 0.35*x + 25.5;
				var y = -0.0003*x*x*x+0.0156*x*x-0.0679*x+0.4862;
				//var y = 0.00001*x*x*x*x-0.001*x*x*x+0.0286*x*x-0.1549*x+0.6322;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///体重10%
            desc: "女孩体重最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"10%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.0021 *x *x + 0.1041*x + 0.1259;
				//var y = -0.0003*x*x*x + 0.0138*x*x - 0.0327*x + 0.4819;
				var y = 0.00001*x*x*x*x-0.0009*x*x*x+0.0264*x*x-0.117*x+0.6234;
                //var y = 0.000001*x*x*x*x*x-0.00007*x*x*x*x+0.0012*x*x*x+0.0018*x*x-0.0048*x+0.4853;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///体重50%
            desc: "女孩体重最大范围",
            lineDash: [5,0],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"50%", fontSize: 15, yOffSet: -15, strokeColor: "black"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0198 *x *x + 1.6655*x + 26.737;
				var y = -0.0002*x*x*x+0.0101*x*x+0.0461*x+0.4514;
				//var y = 0.00005*x*x*x*x-0.0037*x*x*x+0.0742*x*x+0.7723*x+26.044;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///体重90%
            desc: "女孩体重最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"90%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0251 *x *x + 1.8098*x + 29.006;
				//var y = -0.024 *x *x + 1.784*x + 29.103;
				//var y = 0.00001*x*x*x-0.0257*x*x+1.8169*x+28.988;
				var y = -0.0002*x*x*x+0.0094*x*x+0.0945*x+0.4844;
				//var y = 0.00001*x*x*x*x-0.001*x*x*x+0.0239*x*x-0.0027*x+0.6476;
				//var y = 0.000000006*x*x*x*x*x+0.00009*x*x*x*x-0.0049*x*x*x+0.0634*x*x+1.2381*x+29.93;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///体重97%
            desc: "女孩体重最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"97%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"Weight", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0275 *x *x + 1.872*x + 30.083;
				var y = -0.0002*x*x*x+0.0099*x*x+0.1093*x+0.5138;
				//var y = 0.00005*x*x*x*x-0.0036*x*x*x+0.0778*x*x+0.6617*x+25.158;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围3%
            desc: "女孩头围最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"3%", fontSize: 15, yOffSet: -8, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.15 *x *x + 0.35*x + 25.5;
				var y = 0.00003*x*x*x*x-0.0021*x*x*x+0.035*x*x+0.6942*x+17.457;
				//var y = 0.00005*x*x*x*x-0.0036*x*x*x+0.0778*x*x+0.6617*x+25.158;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围10%
            desc: "女孩头围最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"10%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.15 *x *x + 0.35*x + 25.5;
				var y = -0.0003*x*x*x+-0.0003*x*x+0.9562*x+17.794;
				//var y = 0.00005*x*x*x*x-0.0033*x*x*x+0.0558*x*x+0.5791*x+18.426;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围50%
            desc: "女孩头围最大范围",
            lineDash: [5,0],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"50%", fontSize: 15, yOffSet: -15, strokeColor: "black"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0174 *x *x + 1.1928*x + 18.805;
				var y = -0.0002*x*x*x-0.0085*x*x+1.0883*x+19.079;
				//var y = 0.00006*x*x*x*x-0.0034*x*x*x+0.0526*x*x+0.6781*x+19.767;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围90%
            desc: "女孩头围最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"90%", fontSize: 15, yOffSet: -12, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0186 *x *x + 1.2199*x + 20.499;
				var y = -0.00003*x*x*x-0.0172*x*x+1.2034*x+20.543;
				//var y = 0.0002*x*x*x-0.0318*x*x+1.8766*x+28.86;
				//var y = 0.00009*x*x*x*x-0.0049*x*x*x+0.0635*x*x+1.2376*x+29.931;
				//var y = 0.000000006*x*x*x*x*x+0.00009*x*x*x*x-0.0049*x*x*x+0.0634*x*x+1.2381*x+29.93;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围97%
            desc: "女孩头围最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Girls",
            lineInfo: [{index:12, textInfo:"97%", fontSize: 15, yOffSet: -18, strokeColor: "red"},{index:8, textInfo:"Head Circumference", fontSize: 20, yOffSet: 50, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0275 *x *x + 1.872*x + 30.083;
				var y = -0.00003*x*x*x-0.0187*x*x+1.252*x+21.008;
				//var y = 0.00005*x*x*x*x-0.0036*x*x*x+0.0778*x*x+0.6617*x+25.158;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///身高3%
            desc: "男孩身长最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"3%", fontSize: 15, yOffSet: -8, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0143 *x *x + 1.5251*x + 25.008;
				var y = -0.0006*x*x*x+0.0112*x*x+1.234*x+25.748;
				//var y = 0.00007*x*x*x*x-0.0045*x*x*x+0.0822*x*x+0.773*x+26.498;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///身高10%
            desc: "男孩身长最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"10%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.15 *x *x + 0.35*x + 25.5;
				//var y = -0.0004*x*x*x-0.0003*x*x+1.3689*x+26.79;
				var y = 0.00006*x*x*x*x-0.0037*x*x*x+0.0602*x*x+0.9758*x+27.43;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///身高50%
            desc: "男孩身长最大范围",
            lineDash: [5,0],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"50%", fontSize: 15, yOffSet: -15, strokeColor: "black"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = -0.0177 *x *x + 1.6281*x + 27.574;
				//var y = -0.0008*x*x*x+0.018*x*x+1.1491*x+25.412;
				//var y = 0.00005*x*x*x*x-0.0037*x*x*x+0.0742*x*x+0.7723*x+26.044;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///身高90%
            desc: "男孩身长最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"90%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
				var y = -0.023 *x *x + 1.7605*x + 29.957;
				//var y = 0.00004*x*x*x-0.0216*x*x+1.7451*x+29.993;
				//var y = 0.00009*x*x*x*x-0.0049*x*x*x+0.0635*x*x+1.2376*x+29.931;
				//var y = 0.000000006*x*x*x*x*x+0.00009*x*x*x*x-0.0049*x*x*x+0.0634*x*x+1.2381*x+29.93;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///身高97%
            desc: "男孩身长最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"97%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"Length", fontSize: 20, yOffSet: -80, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = -0.027 *x *x + 1.8584*x + 30.962;
				//var y = 0.0003*x*x*x-0.0385*x*x+2.0017*x+29.743;
				//var y = 0.00005*x*x*x*x-0.0036*x*x*x+0.0778*x*x+0.6617*x+25.158;
                return y;
            }
        },	
		{
            code: "UpperMaxLengthLimit",	///体重3%
            desc: "男孩体重最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"3%", fontSize: 15, yOffSet: -8, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = 0.0032 *x *x + 0.0791*x + 0.1361;
				//var y = -0.0003*x*x*x+0.0148*x*x-0.0584*x+0.497;
				//var y = 0.000009*x*x*x*x-0.0008*x*x*x+0.0242*x*x-0.1209*x+0.602;
				//var y = 0.000001*x*x*x*x*x-0.00009*x*x*x*x+0.0018*x*x*x-0.0044*x*x+0.0081*x+0.4448;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///体重10%
            desc: "男孩体重最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"10%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = 0.0027 *x *x + 0.1011*x + 0.1724;
				//var y = -0.0002*x*x*x + 0.0135*x*x - 0.0259*x + 0.5057;
				////var y = 0.000007*x*x*x*x-0.0007*x*x*x+0.0216*x*x-0.0805*x+0.5974;
				//var y = 0.000001*x*x*x*x*x-0.00007*x*x*x*x+0.0013*x*x*x-0.0009*x*x+0.0197*x+0.4766;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///体重50%
            desc: "男孩体重最大范围",
            lineDash: [5,0],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"50%", fontSize: 15, yOffSet: -15, strokeColor: "black"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.0022 *x *x + 0.1418*x + 0.2427;
				//var y = -0.0002*x*x*x+0.01*x*x+0.0503*x+0.4832;
				var y = 0.000007*x*x*x*x-0.0006*x*x*x+0.0181*x*x-0.0041*x+0.5743;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///体重90%
            desc: "男孩体重最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"90%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.002 *x *x + 0.1781*x + 0.3188;
				//var y = -0.0002 *x *x*x + 0.0086*x*x + 0.1004*x+0.5229;
				var y = 0.00001*x*x*x*x-0.0007*x*x*x+0.0195*x*x+0.0273*x+0.6454;
				//var y = 0.0000008*x*x*x*x*x+0.00007*x*x*x*x-0.0023*x*x*x+0.0365*x*x-0.0485*x+0.7367;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///体重97%
            desc: "男孩体重最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "weightUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"97%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"Weight", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = 0.0021 *x *x + 0.192*x + 0.3188;
				var y = -0.0001*x*x*x+0.0083*x*x+0.1191*x+0.5532;
				//var y = 0.00001*x*x*x*x-0.0007*x*x*x+0.019*x*x+0.047*x+0.6742;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围3%
            desc: "男孩头围最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"3%", fontSize: 15, yOffSet: -8, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = -0.0127 *x *x + 1.0667*x + 17.269;
				//var y = -0.00002*x*x*x-0.0124*x*x+1.0477*x+18.239;
				//var y = 0.00004*x*x*x*x-0.0022*x*x*x+0.0269*x*x+0.7927*x+18.654;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围10%
            desc: "男孩头围最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"10%", fontSize: 15, yOffSet: -15, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = -0.0138 *x *x + 1.0971*x + 17.945;
				//var y = 0.00004*x*x*x-0.014*x*x+1.0994*x+17.94;
				//var y = 0.00003*x*x*x*x-0.0018*x*x*x+0.02*x*x+0.8716*x+18.322;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围50%
            desc: "男孩头围最大范围",
            lineDash: [5,0],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"50%", fontSize: 15, yOffSet: -15, strokeColor: "black"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = -0.0156 *x *x + 1.1465*x + 19.478;
				//var y = -0.0002*x*x*x-0.0085*x*x+1.0883*x+19.079;
				//var y = 0.00006*x*x*x*x-0.0034*x*x*x+0.0526*x*x+0.6781*x+19.767;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围90%
            desc: "男孩头围最大范围",
            lineDash: [2,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"90%", fontSize: 15, yOffSet: -12, strokeColor: "red"},{index:8, textInfo:"", fontSize: 20, yOffSet: -100, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                var y = -0.018 *x *x + 1.2182*x + 20.843;
				//var y = -0.00003*x*x*x-0.0172*x*x+1.2034*x+20.543;
				//var y = 0.0002*x*x*x-0.0318*x*x+1.8766*x+28.86;
				//var y = 0.00009*x*x*x*x-0.0049*x*x*x+0.0635*x*x+1.2376*x+29.931;
				//var y = 0.000000006*x*x*x*x*x+0.00009*x*x*x*x-0.0049*x*x*x+0.0634*x*x+1.2381*x+29.93;
                return y;
            }
        },
		{
            code: "UpperMaxLengthLimit",	///头围97%
            desc: "男孩头围最大范围",
            lineDash: [1,5],
            strokeColor: "red",
            lengendCode: "crossLine",
            yAxisCode: "lengthUnit",
            genderType: "Boys",
            lineInfo: [{index:12, textInfo:"97%", fontSize: 15, yOffSet: -18, strokeColor: "red"},{index:8, textInfo:"Head Circumference", fontSize: 20, yOffSet: 50, strokeColor: "red"}],
            startIndex: 1,
            endIndex: 28,
            data: [],
            fn: function(x){
                //var y = -0.0187 *x *x + 1.12375*x + 21.619;
				var y = 0.00009*x*x*x-0.0228*x*x+1.2857*x+21.492;
				//var y = 0.00005*x*x*x*x-0.0036*x*x*x+0.0778*x*x+0.6617*x+25.158;
                return y;
            }
        }
    ]
};

DisplaySheet.prototype.drawAreas = function () {
    for (var i = 0; i < this.currentPage.Areas.length; i++) {
        if(this.currentPage.Areas[i].Code == "growthCurve"){
            this.drawArea(this.currentPage.Areas[i]);
            this.drawGrowthChart(this.currentPage.Areas[i]);
        }else{
            this.drawArea(this.currentPage.Areas[i]);
        }
    }
}

DisplaySheet.prototype.drawGrowthChart = function(area){
    var rect = {
        left: area.DisplayRect.left * this.ratio.x,
        top: area.DisplayRect.top * this.ratio.y,
        width: area.DisplayRect.width * this.ratio.x,
        height: area.DisplayRect.height * this.ratio.y
    };

    //绘制横线
    for(var i=0; i< growthCurveConfig.colCount; i++){
        var lineStartPos = {
            x: rect.left + (rect.width / growthCurveConfig.colCount) * i,
            y: rect.top
        };
        var lineEndPos = {
            x: rect.left + (rect.width / growthCurveConfig.colCount) * i,
            y: rect.top + rect.height
        };
        var lineScalePos = {
            x: rect.left + (rect.width / growthCurveConfig.colCount) * i,
            y: rect.top + rect.height - (rect.height / growthCurveConfig.rowCount) * 0.8
        };

        if((i+2)%4 == 0){
            this.drawContext.drawLine(lineStartPos, lineEndPos, growthCurveConfig.strokeStyle);
        }else{
            this.drawContext.drawDashLine(lineStartPos, lineEndPos, growthCurveConfig.strokeStyle);
        }
        this.drawContext.drawLine(lineScalePos, lineEndPos, growthCurveConfig.strokeStyle);
    }

    //绘制竖线
    for(var j=0; j < growthCurveConfig.rowCount; j++){
        var lineStartPos = {
            x: rect.left,
            y: rect.top + (rect.height / growthCurveConfig.rowCount) * j
        };
        var lineEndPos = {
            x: rect.left + rect.width,
            y: rect.top + (rect.height / growthCurveConfig.rowCount) * j
        }
        var lineScalePos = {
            x: rect.left + (rect.height / growthCurveConfig.rowCount) * 0.8,
            y: rect.top + (rect.height / growthCurveConfig.rowCount) * j
        };

        if( j % 5 == 0){
            this.drawContext.drawLine(lineStartPos, lineEndPos, growthCurveConfig.strokeStyle);
        }else{
            this.drawContext.drawDashLine(lineStartPos, lineEndPos, growthCurveConfig.strokeStyle);
        }
        this.drawContext.drawLine(lineStartPos, lineScalePos, growthCurveConfig.strokeStyle);
    }
    
    //绘制横坐标轴
    this.drawXScale(rect);
    //绘制竖坐标轴
    this.drawYScale(rect);

    this.gender = "";
    var patSex = this.valueObject["Gender"];
    if(patSex == "男"){
        this.gender = "Boys";
    }else{
        this.gender = "Girls";
    }

    //绘制默认范围曲线
    for(var i=0; i < growthCurveConfig.curve.length; i++){
        if(growthCurveConfig.curve[i].genderType == this.gender){
            this.drawCurve(rect, growthCurveConfig.curve[i]);
        }
    }

    var weightCurve = {
        code: "WeightData",
        desc: "体重",
        lineDash: null,
        strokeColor: "green",
        lengendCode: "crossLine",
        yAxisCode: "weightUnit",
        genderType: null,
        data: this.getWeightDataList()
    };
    this.drawCurve(rect, weightCurve);
	
	var heightCurve = {
        code: "HeightData",
        desc: "身高",
        lineDash: null,
        strokeColor: "blue",
        lengendCode: "crossLine",
        yAxisCode: "lengthUnit",
        genderType: null,
        data: this.getHeightDataList()
    };
    this.drawCurve(rect, heightCurve);
	
	var headCircumferenceCurve = {
        code: "HeadCircumferenceData",
        desc: "头围",
        lineDash: null,
        strokeColor: "red",
        lengendCode: "crossLine",
        yAxisCode: "lengthUnit",
        genderType: null,
        data: this.getHeadCircumferenceDataList()
    };
    this.drawCurve(rect, headCircumferenceCurve);

    //绘制性别标识
    var genderPos = {x: rect.left + rect.width * 0.1, y: rect.top + rect.height * 0.5};
    this.drawGenderInfo(this.gender, genderPos, "Sans-serif", "100", "#8D8E89");
}

DisplaySheet.prototype.drawXScale = function(rect){
    var areaItemStyle = areaItemStyle = this.getStyleByCode("AreaItemStyle");
    var textColor = areaItemStyle.FontStyle.FontColor;
    var fontSize = areaItemStyle.FontStyle.FontSize * this.ratio.fontRatio;
    var textStyle = areaItemStyle.FontStyle.Weight + " " + fontSize + "px " + areaItemStyle.FontStyle.FontName;
    
    var xAxisArr = this.getXAxisInfo();
    for(var i=0; i < xAxisArr.length; i++){
        if(!xAxisArr[i].showDesc) continue;

        var text = xAxisArr[i].desc;
        var textWidth = this.canvasContext.measureTextWidth(text, textColor, textStyle);
        var textPos = {
            x: rect.left - textWidth/2 + rect.width / growthCurveConfig.colCount * i,
            y: rect.top + rect.height
        }
        this.drawContext.drawString(text, textPos, textColor, textStyle);

        var subText = xAxisArr[i].subDesc;
        var subTextWidth = this.canvasContext.measureTextWidth(subText, textColor, textStyle);
        var subTextPos = {
            x: rect.left - subTextWidth/2 + rect.width / growthCurveConfig.colCount * i,
            y: rect.top + rect.height + fontSize * 1.5
        }
        this.drawContext.drawString(subText, subTextPos, textColor, textStyle);
    }
}

DisplaySheet.prototype.drawYScale = function(rect){
    var areaItemStyle = areaItemStyle = this.getStyleByCode("AreaItemStyle");
    var textColor = areaItemStyle.FontStyle.FontColor;
    var fontSize = areaItemStyle.FontStyle.FontSize * this.ratio.fontRatio;
    var textStyle = areaItemStyle.FontStyle.Weight + " " + fontSize + "px " + areaItemStyle.FontStyle.FontName;

    var yAxisArr = growthCurveConfig.yAxisArr;
    for(var i = 0; i < yAxisArr.length; i++){
        var startRow = yAxisArr[i].startRow;
        var endRow = yAxisArr[i].endRow;
        var minValue = yAxisArr[i].minimum;
        var maxValue = yAxisArr[i].maximum;
        var interval = yAxisArr[i].interval;
        var align = yAxisArr[i].align;
        var maxTextWidth = 0;
        var unitDesc = yAxisArr[i].unitDesc;
        for(var j = startRow; j <= endRow; j++){
            if(j%5 ==0){
                var text = (j - startRow) * interval + minValue;

                var textWidth = this.canvasContext.measureTextWidth(text, textColor, textStyle);
                var textPos = {
                    x: rect.left - textWidth,
                    y: rect.top + rect.height - j * (rect.height / growthCurveConfig.rowCount) - fontSize/2
                }
                if(align == "right"){
                    textPos.x = rect.left + rect.width
                }
                if(j > 0) this.drawContext.drawString(text, textPos, textColor, textStyle);
                if(maxTextWidth < textWidth) maxTextWidth = textWidth;
            }
        }
        var unitDescWidth = this.canvasContext.measureTextWidth(unitDesc, textColor, textStyle);
        var maxTextHeight = endRow * (rect.height / growthCurveConfig.rowCount);
        var unitDescPos = {
            x: rect.left - maxTextWidth *1.5,
            y: rect.top + rect.height - maxTextHeight/2 - unitDescWidth/2 - startRow * (rect.height / growthCurveConfig.rowCount)/2
        }
        if(align == "right"){
            unitDescPos.x = rect.left + rect.width + maxTextWidth * 1.5;
        }
        this.drawContext.drawVerticalString(unitDesc, unitDescPos, textColor, textStyle, fontSize, "", "", 0);
    }
}

DisplaySheet.prototype.drawLengend = function(position, lengend, strokeColor, lineWidth){
    if(lengend.type == "crossLine"){
        var lineStartPos1 = {
            x: position.x + lengend.data[0].x,
            y: position.y + lengend.data[0].y,
        };
        var lineEndPos1 = {
            x: position.x + lengend.data[1].x,
            y: position.y + lengend.data[1].y,
        };

        var lineStartPos2 = {
            x: position.x + lengend.data[2].x,
            y: position.y + lengend.data[2].y,
        };
        var lineEndPos2 = {
            x: position.x + lengend.data[3].x,
            y: position.y + lengend.data[3].y,
        };
        this.drawContext.drawLine(lineStartPos1, lineEndPos1, strokeColor, lineWidth);
        this.drawContext.drawLine(lineStartPos2, lineEndPos2, strokeColor, lineWidth);
    }
}

DisplaySheet.prototype.drawCurve = function(rect, curveInfo){
    var yAxisInfo = this.getYAxisByCode(curveInfo.yAxisCode);
    if(curveInfo.data && curveInfo.data.length){
        var lastDataPos = null;
        for(var i=0; i < curveInfo.data.length; i++){
            var singleData = curveInfo.data[i];
            var xPos = rect.left + (rect.width / growthCurveConfig.colCount) * singleData.index;
            var yPos = getYPostionByValue(singleData.value, rect, yAxisInfo);
            if(yPos < rect.top) continue;
            if(yPos > rect.top + rect.height) continue;
            var pos = { x: xPos, y: yPos };
            var lineWidth = 3;
            this.drawLengend(pos, growthCurveConfig.lengend[0], curveInfo.strokeColor, lineWidth);
            if(i >= 1){
                if(lastDataPos) {
                    if(curveInfo.lineDash){
                        this.drawContext.drawDashLine(lastDataPos, pos, curveInfo.strokeColor, curveInfo.lineDash);
                    }else{
                        this.drawContext.drawLine(lastDataPos, pos, curveInfo.strokeColor, lineWidth);
                    }
                }
            }
            lastDataPos = pos;
        }
    }

    if(curveInfo.fn){
        var lastCurveDataPos = null;
        for(var i = curveInfo.startIndex; i < curveInfo.endIndex; i += 0.1){
            var value = curveInfo.fn(i);
            var xPos = rect.left + (rect.width / growthCurveConfig.colCount) * i;
            var yPos = getYPostionByValue(value, rect, yAxisInfo)
            if(yPos < rect.top) continue;
            if(yPos > rect.top + rect.height) continue;
            var pos = {x: xPos, y: yPos};
            if(lastCurveDataPos){
                if(curveInfo.lineDash){
                    this.drawContext.drawDashLine(lastCurveDataPos, pos, curveInfo.strokeColor, curveInfo.lineDash);
                }else{
                    this.drawContext.drawLine(lastCurveDataPos, pos, curveInfo.strokeColor);
                }
            }
            lastCurveDataPos = pos;
        }
    }
    if(curveInfo.lineInfo && curveInfo.lineInfo.length && curveInfo.fn){
        var areaItemStyle = this.getStyleByCode("AreaItemStyle");
        for(var i = 0; i < curveInfo.lineInfo.length; i++){
            var info = curveInfo.lineInfo[i];
            var value = curveInfo.fn(info.index);
            var xPos = rect.left + (rect.width / growthCurveConfig.colCount) * info.index;
            var yPos = getYPostionByValue(value, rect, yAxisInfo)
            var textColor = info.strokeColor;
            var fontSize = info.fontSize * this.ratio.fontRatio;
            var yOffSet = info.yOffSet * this.ratio.y;
            var textStyle = areaItemStyle.FontStyle.Weight + " " + fontSize + "px " + areaItemStyle.FontStyle.FontName;
            var text = info.textInfo;
            var textPos = {x: xPos, y: yPos + yOffSet};
            this.drawContext.drawString(text, textPos, textColor, textStyle);
        }
    }

    function getYPostionByValue(value, rect, yAxisInfo){
        var valueLength = ((yAxisInfo.maximum - yAxisInfo.minimum)/yAxisInfo.interval) / ((yAxisInfo.endRow- yAxisInfo.startRow) * yAxisInfo.interval) * (rect.height / growthCurveConfig.rowCount);
        var yPos = rect.top + rect.height - ((value - yAxisInfo.minimum) * valueLength + yAxisInfo.startRow * (rect.height / growthCurveConfig.rowCount));
        return yPos;
    }
}

DisplaySheet.prototype.getYAxisByCode = function(yAxisCode) {
    var result = null;
    var yAxisArr = growthCurveConfig.yAxisArr;
    for(var i = 0; i < yAxisArr.length; i++){
        var code = yAxisArr[i].code;
        if(code == yAxisCode){
            result = yAxisArr[i];
        }
    }
    return result;
}

DisplaySheet.prototype.drawGenderInfo = function(genderText, textPos, fontFamily, fontSize, textColor){
    var textStyle = "bold " + fontSize * this.ratio.fontRatio + "px " + fontFamily;
    this.drawContext.drawString(genderText, textPos, textColor, textStyle);
}

DisplaySheet.prototype.loadPatWeightInfo = function(){
    var icuaId = dhccl.getQueryString("icuaId");
    var patWeightData = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: "web.DHCICUPatWeightInfo",
        QueryName: "FindICUPatWeightInfo",
        Arg1: icuaId,
        ArgCnt: 1
    }, "json");
    return patWeightData;
}

DisplaySheet.prototype.initSheet = function(){
    this.patWeightData = this.loadPatWeightInfo();

    this.setPageSize();
    this.setCurrentPage(this.sheet.Pages[0].PageNo);
}

DisplaySheet.prototype.getXAxisInfo = function(){
    var xAxisArr = [];
    for(var i=0; i <= growthCurveConfig.colCount; i++){
        var xAxisInfo = {
            index: i,
            desc: i+22,
            showDesc : (i%2 == 0) ? true : false,
            dateTime: "",
            subDesc: ""
        };

        if(i < this.patWeightData.length){
            var datetime = this.patWeightData[i].StartDatetime;
            var date = datetime.split(' ')[0];
            var dateMonthAndDay = date.split('-')[1] + '-' + date.split('-')[2];
            xAxisInfo.dateTime = datetime;
            xAxisInfo.subDesc = dateMonthAndDay;
        }
        xAxisArr.push(xAxisInfo);
    }
    return xAxisArr;
}

DisplaySheet.prototype.getDataIndexByXAxis = function(singleData){
    var index = null;
    var xAxisArr = this.getXAxisInfo()
    for(var i=0; i< xAxisArr.length; i++){
        if(xAxisArr[i].dateTime == singleData.StartDatetime){
            index = i;
        }
    }
    return index;
}

DisplaySheet.prototype.getWeightDataList = function(){
    var weightDataList = [];
    for(var i=0; i < this.patWeightData.length; i++){
        var index = this.getDataIndexByXAxis(this.patWeightData[i]);
        if(index == null) continue;
        weightDataList.push({
            index: index,
            value: parseFloat(this.patWeightData[i].Weight)
        });
    }
    return weightDataList;
}

DisplaySheet.prototype.getHeightDataList = function(){
    var heightDataList = [];
    for(var i=0; i < this.patWeightData.length; i++){
        var index = this.getDataIndexByXAxis(this.patWeightData[i]);
        if(index == null) continue;
        heightDataList.push({
            index: index,
            value: parseFloat(this.patWeightData[i].Height)
        });
    }
    return heightDataList;
}

DisplaySheet.prototype.getHeadCircumferenceDataList = function(){
    var headCircumferenceDataList = [];
    for(var i=0; i < this.patWeightData.length; i++){
        var index = this.getDataIndexByXAxis(this.patWeightData[i]);
        if(index == null) continue;
        headCircumferenceDataList.push({
            index: index,
            value: parseFloat(this.patWeightData[i].HeadCircumference)
        });
    }
    return headCircumferenceDataList;
}

$(initPage);

function initPage() {

    var sheetContext = new SheetContext({});
    sheetContext.loadSheetData(function(data){
        var sheet = data.Sheet;
        var valueObject = sheetContext.getCommonConstData();

        var readonly = dhccl.getQueryString("readonly") == "true"?true:false;
        var canvas = document.getElementById("myCanvas");
        var displaySheet = new DisplaySheet({
            canvas: canvas,
            sheet: sheet,
            editMode: true,
            valueObject: valueObject,
            ratio: {
                x: 14 / 12,
                y: 14 / 12,
                fontRatio: 14 / 12
            },
            onPageResize: function () {
                HIDPI();
            },
            onPageLoaded: function(){
                var scriptPath = sheet.ScriptPath;
                if(scriptPath){
                    loadJS(scriptPath, function(){});
                }
            }
        });

        var editPluginManager = new EditPluginManager({
            sheetContext: sheetContext,
            readonly: readonly
        });
        editPluginManager.setEditPluginList(displaySheet.getEditPluginArea());


        $("#pageNoTabs").PageNoTabs({
            pages: displaySheet.getPageNoArray(),
            hideAddNewButton: true,
            hideRemoveButton: true,
            onPageNoTabSelected: function (pageNo) {
                displaySheet.setCurrentPage(pageNo);
                editPluginManager.setEditPluginList(displaySheet.getEditPluginArea());
                editPluginManager.showCurrentPageEditPlugin(pageNo);
            }
        });

        $(canvas).data("displaySheet",displaySheet);


        $("#btnPrint").linkbutton({
            onClick: function () {
                if (displaySheet.getPageSetting().PrintCheckRequired) {
                    if (!editPluginManager.checkRequired()) return;
                }

                var valueObject = editPluginManager.getValueObject();
                var tableValuesArray = null;
                var lodopPrintView = window.LodopPrintView.instance;
                if (!lodopPrintView) {
                    lodopPrintView = window.LodopPrintView.init({
                        sheetData: sheet,
                        valueObject: valueObject
                    });
                } else {
                    lodopPrintView.setPrintData(valueObject, tableValuesArray);
                }
                lodopPrintView.print();
            }
        });

        $("#btnRefresh").linkbutton({
            onClick: function () {
                window.location.reload();
            }
        });

        function HIDPI() {
            var ratio = window.devicePixelRatio || 1;
            var canvas = document.getElementById("myCanvas");
            var context = canvas.getContext("2d");
            var oldWidth = canvas.width;
            var oldHeight = canvas.height;
            canvas.width = oldWidth * ratio;
            canvas.height = oldHeight * ratio;
            canvas.style.width = oldWidth + "px";
            canvas.style.height = oldHeight + "px";
            context.scale(ratio, ratio);
        }

        function loadJS(url, onJsLoaded) {
            var script = document.createElement('script');
            script.type = 'text/javascript';
            script.src = url;
            //IE
            if (script.readyState) {
                script.onreadystatechange = function () {
                    if (script.readyState == 'loaded' || script.readyState == 'complete') {
                        script.onreadystatechange = null;
                        if(onJsLoaded) onJsLoaded();
                    }
                };
            } else {
                //其他浏览器
                script.onload = function () {
                    if(onJsLoaded) onJsLoaded();
                };
            }
            document.getElementsByTagName('head')[0].appendChild(script);
        }

    }, false);
}
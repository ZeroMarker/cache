/*
模块:			药房公共
子模块:			药房公共-处方预览(住院、门诊，西药、草药预览均调用此方法)
Author:			MaYuqiang
Date Created:	2022-04-01
pha/op/v4/previewpresc.js
*/
var PHA_PRESC = {
	// 处方预览		
	PREVIEW: function (_option) {	
		var prescNo = _option.prescNo||'';			// 处方号
		var preAdmType = _option.preAdmType||'';		// 就诊类型	
		var zfFlag = _option.zfFlag||'';			// 正方、底方
		var prtType = _option.prtType||'DISPPREVIEW';	// 发药预览
		var useFlag = _option.useFlag||'';			// 使用位置(1-医生站，2-审方，3-已审未发，4-已发，5-药房打印处方)
		var iframeID = _option.iframeID||'';		// 需要展示预览的frameId
		var cyFlag = _option.cyFlag||'';			// 草药标志
		/* 住院处方 */
		if(preAdmType == "IP"){
			var prtData = tkMakeServerCall("web.DHCINPHA.Common.Print","PrescPrintData",prescNo,zfFlag,prtType,useFlag);
			var jsonData = JSON.parse(prtData);
			var xmlTemplate = jsonData.Templet || "";
			if (xmlTemplate == "") {
				return;
			}
			var backgroundColor = "white";
			if (jsonData.Para.PrescTitle) {
				var prescTitle = jsonData.Para.PrescTitle;
				if ((prescTitle.indexOf("麻") >= 0) || (prescTitle.indexOf("精一") >= 0)) {
					backgroundColor = "#F5A89A";
				}else if(prescTitle.indexOf("儿科") >= 0){
					backgroundColor = "#90EE90";
			    }else if(prescTitle.indexOf("急诊") >= 0){
					backgroundColor = "#FFFF96";
			    }
			}
		}else{	
			/* 门诊处方 */
			var prtData=tkMakeServerCall("PHA.OP.COM.Print","PrescPrintData",prescNo,zfFlag,prtType,useFlag);
			var jsonData = JSON.parse(prtData);
			var xmlTemplate = jsonData.Templet || "";
			if (xmlTemplate == "") {
				return;
			}
			var backgroundColor = "white";
			if (jsonData.Para.PrescTitle) {
				var prescTitle = jsonData.Para.PrescTitle;
				if ((prescTitle.indexOf("麻") >= 0) || (prescTitle.indexOf("精一") >= 0)) {
					backgroundColor = "#F5A89A";
			    }else if(prescTitle.indexOf("儿科") >= 0){
					backgroundColor = "#90EE90";
			    }else if(prescTitle.indexOf("急诊") >= 0){
					backgroundColor = "#FFFF96";
			    }
			}
		}
			
		PRINTCOM.XML({
			printBy: 'inv',
			XMLTemplate: xmlTemplate,
			data: jsonData,
			iframeID: iframeID,
			preview: {
				showButtons: false,
				backgroundColor: backgroundColor,
				bodyColor: backgroundColor
			},
			listItem:{
				styler: function(value, rowData, rowIndex){
					var stockFlag = String.fromCharCode(1);
					if ((value || '').indexOf(stockFlag) > 0){
						return 'color:red;' ;
					}
				}
			}
			//aptListFields: ["label6", "printUserName", "label8", "printDate"]
			//listBorder: {headBorder:false, style:4, startX:1, endX:180, space:4}
			//page: {rows:15, x:20, y:2, fontname:'黑体', fontbold:'false', fontsize:'12', format:'第{1}页/共{2}页'}
		});	
		
	}	
		
}

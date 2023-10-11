/*
ģ��:			ҩ������
��ģ��:			ҩ������-����Ԥ��(סԺ�������ҩ����ҩԤ�������ô˷���)
Author:			MaYuqiang
Date Created:	2022-04-01
pha/op/v4/previewpresc.js
*/
var PHA_PRESC = {
	// ����Ԥ��		
	PREVIEW: function (_option) {	
		var prescNo = _option.prescNo||'';			// ������
		var preAdmType = _option.preAdmType||'';		// ��������	
		var zfFlag = _option.zfFlag||'';			// �������׷�
		var prtType = _option.prtType||'DISPPREVIEW';	// ��ҩԤ��
		var useFlag = _option.useFlag||'';			// ʹ��λ��(1-ҽ��վ��2-�󷽣�3-����δ����4-�ѷ���5-ҩ����ӡ����)
		var iframeID = _option.iframeID||'';		// ��ҪչʾԤ����frameId
		var cyFlag = _option.cyFlag||'';			// ��ҩ��־
		/* סԺ���� */
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
				if ((prescTitle.indexOf("��") >= 0) || (prescTitle.indexOf("��һ") >= 0)) {
					backgroundColor = "#F5A89A";
				}else if(prescTitle.indexOf("����") >= 0){
					backgroundColor = "#90EE90";
			    }else if(prescTitle.indexOf("����") >= 0){
					backgroundColor = "#FFFF96";
			    }
			}
		}else{	
			/* ���ﴦ�� */
			var prtData=tkMakeServerCall("PHA.OP.COM.Print","PrescPrintData",prescNo,zfFlag,prtType,useFlag);
			var jsonData = JSON.parse(prtData);
			var xmlTemplate = jsonData.Templet || "";
			if (xmlTemplate == "") {
				return;
			}
			var backgroundColor = "white";
			if (jsonData.Para.PrescTitle) {
				var prescTitle = jsonData.Para.PrescTitle;
				if ((prescTitle.indexOf("��") >= 0) || (prescTitle.indexOf("��һ") >= 0)) {
					backgroundColor = "#F5A89A";
			    }else if(prescTitle.indexOf("����") >= 0){
					backgroundColor = "#90EE90";
			    }else if(prescTitle.indexOf("����") >= 0){
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
			//page: {rows:15, x:20, y:2, fontname:'����', fontbold:'false', fontsize:'12', format:'��{1}ҳ/��{2}ҳ'}
		});	
		
	}	
		
}

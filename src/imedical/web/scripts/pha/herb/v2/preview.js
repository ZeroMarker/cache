/**
ģ��:		��ҩ������
��ģ��:		��ҩ������-����Ԥ��
Creator:	MaYuqiang
CreateDate:	2020-11-06
preview.js
*/
var PHA_HERB = {
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
				showButtons: true,
				buttonsAlign: 'bottom',
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
		
	},	




	//����,���ڲ�ҩ��ҳ
	Row: "",
	//Ԥ������߶�
	Height: "",
	//����ɫ
	Background: "#FFFFFF",
	/**
	 * Presc ����Ԥ����ʾ
	 * @param {String} _Id : ������ʾ��htmlԪ��id
	 * @param {Object} _opts 
	 *					_opts.PrescNo : ������
	 *					_opts.AdmType : �������ͣ�I/O��
	 *					_opts.PrtType : ����(Ԥ��/��ӡ),��ȱʡ,Ĭ��ΪԤ��
	 *					_opts.zf : ����/�׷�,Ĭ�ϵ׷�
	 *					_opts.CY : ��ҩ��־,Ĭ�ϲ�ҩ
	 */
	Presc: function(_Id, _opts){
		PHA_HERB.Clear(_Id);
		var _data = PHA_HERB.Data(_opts);
		if(_data == null){ return; }
		if($.isEmptyObject(_data)) {return;}
		if(_data.msg) { 
			PHA_HERB.Error(_Id, _data);
			return; 
		}
		var _tmpList = _data.List;
		var _page = 1;
		while(_tmpList.length > 0){
			_data.List = _tmpList.splice(0, PHA_HERB.Row)
			PHA_HERB.View(_Id, _data, _page);
			_page++;
		}
	},
	/**
	 * Data ��ȡ����,������Ĭ��ֵ
	 * @param {Object} _opts : ������ʾ������
	 */
	Data: function(_opts){
		var _prescNo = _opts.PrescNo;
		var _prtType = _opts.PrtType || "DISPPREVIEW";
		var _zf = _opts.zf || "�׷�";
		var _data;
		if((_opts.AdmType == "I")||(_prescNo.indexOf("I")>-1)){
			_data = PHA_HERB.InData(_prescNo, _prtType, _zf);
		}else{
			_data = PHA_HERB.OutData(_prescNo, _prtType, _zf);
		}
		if($.isEmptyObject(_data)) {return null;}
		if(_data.msg) {return _data;}
		if (_data.Templet.indexOf("Ver")<0){
			PHA_HERB.Height="550px";
			PHA_HERB.Row=12;
		}else{
			PHA_HERB.Height="720px";
			PHA_HERB.Row=16;
		}
		if(_opts.CY != "Y"){
			PHA_HERB.Row = _data.List.length;
		}
		var _title = _data.Para.PrescTitle;
		if(_title.indexOf("����")>"-1"){
			PHA_HERB.Background="#F5A89A";
	    }else if(_title.indexOf("����")>"-1"){
			PHA_HERB.Background="#90EE90";
	    }else if(_title.indexOf("����")>"-1"){
			PHA_HERB.Background="#FFFF96";
	    }
		return _data;
	},
	/**
	 * Presc ��ȡ���ﴦ������
	 * @param {String} _prescNo :������
	 * @param {String} _prtType : ����(Ԥ��/��ӡ)
	 * @param {String} _zf : ����/�׷�
	 * @return {Object} ��������
	 */
	OutData: function(_prescNo, _prtType, _zf){
		var _data = $cm({
			ClassName: "PHA.OP.COM.Print",
			MethodName: "PrescPrintData",
			PrescNo: _prescNo,
			ZfFlag: _zf,
			PrtType: _prtType,
			dataType: "json"
		}, false )
		return _data;
	},
	/**
	 * Presc ��ȡסԺ��������
	 * @param {String} _prescNo :������
	 * @param {String} _prtType : ����(Ԥ��/��ӡ)
	 * @param {String} _zf : ����/�׷�
	 * @return {Object} ��������
	 */
	InData: function(_prescNo, _prtType, _zf){
		var _data = $cm({
			ClassName: "web.DHCINPHA.Common.Print",
			MethodName: "PrescPrintData",
			PrescNo: _prescNo,
			ZfFlag: _zf,
			PrtType: _prtType,
			dataType: "json"
		}, false )
		return _data;
	},
	/**
	 * Clear �������Ԥ����ʾ
	 * @param {String} _Id : ������ʾ��htmlԪ��id
	 */
	Clear: function(_Id){
		$("#"+ _Id).html("");
	},
	/**
	 * Presc ʵ�ִ���Ԥ��
	 * @param {String} _Id : ������ʾ��htmlԪ��id
	 * @param {Object} _data : ������ʾ������
	 * @param {String} _page : ��ҩ��ҳ��,��ȱʡ
	 */
	View: function(_Id, _data, _page){
		if(!_page) { _page = 1 ;}
		var _tmpDivId = "divPreReport" + _page;
		var _htmlStr = "<div style='position:relative;height:" ;
			_htmlStr += PHA_HERB.Height +";background:"
			_htmlStr += PHA_HERB.Background +";' id=" + _tmpDivId + "></div>";
		$("#"+ _Id).append(_htmlStr); 
		var _prescHtml=DHCSTXMLPrint_Preview.JsonToHtml(_data);
		$("#"+ _tmpDivId).html(_prescHtml);
	},
	/**
	 * Error ������Ϣ��ʾ
	 * @param {String} _Id : ������ʾ��htmlԪ��id
	 * @param {Object} _data : ������ʾ������
	 */
	Error: function(_Id, _data){
		var _htmlStr = "<h1>" + _data.msg + "</h1>"
		$("#"+ _Id).append(_htmlStr); 
	}
}

//Ԥ������
function PrescView(PrePrescParamStr,prtType){
	if(document.getElementById("divPreLayout")==null){ return; }
	var PrePrescParamStrArr=PrePrescParamStr.split("^");
	var preAdmType=PrePrescParamStrArr[0]||"";
	var prescNo=PrePrescParamStrArr[1]||"";
	var cyFlag=PrePrescParamStrArr[2]||"";
	var prtData="{}";
	//�����סԺ���ݷֿ��Ա��Ժ����չ�Ը�ǿ
	if(preAdmType=="DHCINPHA"){
		prtData=tkMakeServerCall("web.DHCINPHA.Common.Print","PrescPrintData",prescNo,"�׷�",prtType);
	}else{
		prtData=tkMakeServerCall("PHA.OP.COM.Print","PrescPrintData",prescNo,"�׷�",prtType);
	}
	if (prtData=="{}"){
		return;
	}
	$("#divPreLayout").html("");
	var prtJson=JSON.parse(prtData);
	var newPrtJson={}
	$.extend(newPrtJson,prtJson);
	// �ǲ�ҩ
	if (cyFlag!="Y"){
		var prescHtml=DHCSTXMLPrint_Preview.JsonToHtml(newPrtJson);
		$("#divPreReport").html(prescHtml);
	}else{
		// ��ҩ����ǩ�߶��Լ�ÿҳlist����
		var templetCode=prtJson.Templet;
		if (templetCode.indexOf("Ver")<0){
			var PreViewHeight="550px";
			var cyListLimit=12;
		}else{
			var PreViewHeight="720px";
			var cyListLimit=16;
		}
		var prescTitle=prtJson.Para.PrescTitle;
		var prtList=prtJson.List;
		var prtListLen=prtList.length;
		// �����ҳ
		newPrtJson.List=[];
		var pageInt=parseInt(prtListLen/cyListLimit);
		var pageRem=prtListLen%cyListLimit;
		if (pageRem>0){
			pageInt++;
		}
		for (var pageI=0;pageI<pageInt;pageI++){
			// ȡList
			var newPrtList=[];
			var start=pageI*cyListLimit;
			var end=start+cyListLimit;
			newPrtList=prtList.slice(start,end);
			//newPrtList = newPrtList.slice(0,1)
			newPrtJson.List=newPrtList;
			var prescHtml=DHCSTXMLPrint_Preview.JsonToHtml(newPrtJson);
			var divLayOut = document.getElementById("divPreLayout");
			var newdiv = document.createElement("div");
			newdiv.id="divPreReport"+pageI;
			newdiv.style.position="relative";
			newdiv.style.height=PreViewHeight;		
			if(prescTitle.indexOf("����")>"-1"){
				newdiv.style.background="#F5A89A";
		    }else if(prescTitle.indexOf("����")>"-1"){
				newdiv.style.background="#90EE90";
		    }else if(prescTitle.indexOf("����")>"-1"){
				newdiv.style.background="#FFFF96";
		    }
			divLayOut.appendChild(newdiv);
			$("#divPreReport"+pageI).html(prescHtml);	
		}
	}
};

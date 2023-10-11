/**
模块:		中药房公共
子模块:		中药房公共-处方预览
Creator:	MaYuqiang
CreateDate:	2020-11-06
preview.js
*/
var PHA_HERB = {
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
			//page: {rows:15, x:20, y:2, fontname:'黑体', fontbold:'false', fontsize:'12', format:'第{1}页/共{2}页'}
		});	
		
	},	




	//行数,用于草药分页
	Row: "",
	//预览界面高度
	Height: "",
	//背景色
	Background: "#FFFFFF",
	/**
	 * Presc 处方预览显示
	 * @param {String} _Id : 用于显示的html元素id
	 * @param {Object} _opts 
	 *					_opts.PrescNo : 处方号
	 *					_opts.AdmType : 就诊类型（I/O）
	 *					_opts.PrtType : 类型(预览/打印),可缺省,默认为预览
	 *					_opts.zf : 正方/底方,默认底方
	 *					_opts.CY : 草药标志,默认草药
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
	 * Data 获取数据,并设置默认值
	 * @param {Object} _opts : 用于显示的数据
	 */
	Data: function(_opts){
		var _prescNo = _opts.PrescNo;
		var _prtType = _opts.PrtType || "DISPPREVIEW";
		var _zf = _opts.zf || "底方";
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
		if(_title.indexOf("毒麻")>"-1"){
			PHA_HERB.Background="#F5A89A";
	    }else if(_title.indexOf("儿科")>"-1"){
			PHA_HERB.Background="#90EE90";
	    }else if(_title.indexOf("急诊")>"-1"){
			PHA_HERB.Background="#FFFF96";
	    }
		return _data;
	},
	/**
	 * Presc 获取门诊处方数据
	 * @param {String} _prescNo :处方号
	 * @param {String} _prtType : 类型(预览/打印)
	 * @param {String} _zf : 正方/底方
	 * @return {Object} 处方数据
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
	 * Presc 获取住院处方数据
	 * @param {String} _prescNo :处方号
	 * @param {String} _prtType : 类型(预览/打印)
	 * @param {String} _zf : 正方/底方
	 * @return {Object} 处方数据
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
	 * Clear 清除处方预览显示
	 * @param {String} _Id : 用于显示的html元素id
	 */
	Clear: function(_Id){
		$("#"+ _Id).html("");
	},
	/**
	 * Presc 实现处方预览
	 * @param {String} _Id : 用于显示的html元素id
	 * @param {Object} _data : 用于显示的数据
	 * @param {String} _page : 草药分页用,可缺省
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
	 * Error 错误信息显示
	 * @param {String} _Id : 用于显示的html元素id
	 * @param {Object} _data : 用于显示的数据
	 */
	Error: function(_Id, _data){
		var _htmlStr = "<h1>" + _data.msg + "</h1>"
		$("#"+ _Id).append(_htmlStr); 
	}
}

//预览方法
function PrescView(PrePrescParamStr,prtType){
	if(document.getElementById("divPreLayout")==null){ return; }
	var PrePrescParamStrArr=PrePrescParamStr.split("^");
	var preAdmType=PrePrescParamStrArr[0]||"";
	var prescNo=PrePrescParamStrArr[1]||"";
	var cyFlag=PrePrescParamStrArr[2]||"";
	var prtData="{}";
	//门诊和住院数据分开以便以后可扩展性更强
	if(preAdmType=="DHCINPHA"){
		prtData=tkMakeServerCall("web.DHCINPHA.Common.Print","PrescPrintData",prescNo,"底方",prtType);
	}else{
		prtData=tkMakeServerCall("PHA.OP.COM.Print","PrescPrintData",prescNo,"底方",prtType);
	}
	if (prtData=="{}"){
		return;
	}
	$("#divPreLayout").html("");
	var prtJson=JSON.parse(prtData);
	var newPrtJson={}
	$.extend(newPrtJson,prtJson);
	// 非草药
	if (cyFlag!="Y"){
		var prescHtml=DHCSTXMLPrint_Preview.JsonToHtml(newPrtJson);
		$("#divPreReport").html(prescHtml);
	}else{
		// 草药处方签高度以及每页list行数
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
		// 处理分页
		newPrtJson.List=[];
		var pageInt=parseInt(prtListLen/cyListLimit);
		var pageRem=prtListLen%cyListLimit;
		if (pageRem>0){
			pageInt++;
		}
		for (var pageI=0;pageI<pageInt;pageI++){
			// 取List
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
			if(prescTitle.indexOf("毒麻")>"-1"){
				newdiv.style.background="#F5A89A";
		    }else if(prescTitle.indexOf("儿科")>"-1"){
				newdiv.style.background="#90EE90";
		    }else if(prescTitle.indexOf("急诊")>"-1"){
				newdiv.style.background="#FFFF96";
		    }
			divLayOut.appendChild(newdiv);
			$("#divPreReport"+pageI).html(prescHtml);	
		}
	}
};

/**
模块:		药房公共
子模块:		药房公共-处方预览
Creator:	hulihua
CreateDate:	2019-07-11
preview.js
*/
var DEC_PRESC = {
	//行数,用于草药分页
	Row: "",
	//预览界面高度
	Height: "",
	//背景色
	Background: "#FFFFFF",
	//草药标志
	/**
	 * Layout 创建处方预览panel
	 * @param {String} _Id : 父元素的id
	 * @param {Object} _opts panel属性将覆盖默认属性
	 * 				   	_opts.divId 显示处方信息的div的id
	 * @return {String} 创建的用于显示信息的元素id，可在预览信息时作为参数	
	 */
	Layout: function(_Id, _opts) {
		if(!_Id){
			return;	
		}
		_opts = _opts || {};
		if(parseInt(_opts.width)>0) { 	//mm单位转换px
			_opts.width = (new unitConversion().mmConversionPx(parseInt(_opts.width)));
		}else{
			_opts.width = 700;
		}
		var _conHtmlId = _opts.divId || "divPreLayout";
		var _defOpts = {
			region: 'west',
		    split: true,
		    headerCls: 'panel-header-gray',
		    bodyCls: 'panel-body-gray',
		    iconCls: 'icon-paper',
		    width: 700,
		    title: "处方预览",
		    content: '<div id="' + _conHtmlId + '"></div>'
		}
		var nOpts = $.extend({}, _defOpts, _opts)
		$('#'+_Id).layout('add', nOpts);
		return _conHtmlId;
	},
	/**
	 * Presc 处方预览显示
	 * @param {String} _Id : 用于显示的html元素id
	 * @param {Object} _opts 
	 *					_opts.PrescNo : 处方号
	 *					_opts.AdmType : 就诊类型（I/O）
	 *					_opts.PrtType : 类型(预览/打印),可缺省,默认为预览
	 *					_opts.zf : 正方/底方,默认底方
	 *					_opts.CY : 正方/底方,默认底方
	 */
	Presc: function(_Id, _opts){
		DEC_PRESC.Clear(_Id);
		var _data = DEC_PRESC.Data(_opts);
		if(_data == null){ return; }
		if($.isEmptyObject(_data)) {return;}
		if(_data.msg) { 
			DEC_PRESC.Error(_Id, _data);
			return; 
		}
		var _tmpList = _data.List;
		var _page = 1;
		while(_tmpList.length > 0){
			_data.List = _tmpList.splice(0, DEC_PRESC.Row)
			DEC_PRESC.View(_Id, _data, _page);
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
			_data = DEC_PRESC.InData(_prescNo, _prtType, _zf);
		}else{
			_data = DEC_PRESC.OutData(_prescNo, _prtType, _zf);
		}
		if($.isEmptyObject(_data)) {return null;}
		if(_data.msg) {return _data;}
		if (_data.Templet.indexOf("Ver")<0){
			DEC_PRESC.Height="550px";
			DEC_PRESC.Row=12;
		}else{
			DEC_PRESC.Height="720px";
			DEC_PRESC.Row=16;
		}
		if(_opts.CY != "Y"){
			DEC_PRESC.Row = _data.List.length;
		}
		var _title = _data.Para.PrescTitle;
		if(_title.indexOf("毒麻")>"-1"){
			DEC_PRESC.Background="#F5A89A";
	    }else if(_title.indexOf("儿科")>"-1"){
			DEC_PRESC.Background="#90EE90";
	    }else if(_title.indexOf("急诊")>"-1"){
			DEC_PRESC.Background="#FFFF96";
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
			_htmlStr += DEC_PRESC.Height +";background:"
			_htmlStr += DEC_PRESC.Background +";' id=" + _tmpDivId + "></div>";
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

/**
 *像素和毫米互转 
 *	new unitConversion().mmConversionPx(50)
 *	new unitConversion().pxConversionMm(50)
 */
function unitConversion() {
    /**
     * 获取DPI
     * @returns {Array}
     */
    this.conversion_getDPI =function () {
        var arrDPI = new Array;
        if (window.screen.deviceXDPI) {
            arrDPI[0] = window.screen.deviceXDPI;
            arrDPI[1] = window.screen.deviceYDPI;
        } else {
            var tmpNode = document.createElement("DIV");
            tmpNode.style.cssText = "width:1in;height:1in;position:absolute;left:0px;top:0px;z-index:99;visibility:hidden";
            document.body.appendChild(tmpNode);
            arrDPI[0] = parseInt(tmpNode.offsetWidth);
            arrDPI[1] = parseInt(tmpNode.offsetHeight);
            tmpNode.parentNode.removeChild(tmpNode);
        }
        return arrDPI;
    };
    /**
     * px转换为mm
     * @param value
     * @returns {number}
     */
    this.pxConversionMm = function (value) {
        var inch = value/this.conversion_getDPI()[0];
        var c_value = inch * 25.4;
        return c_value;
    };
    /**
     * mm转换为px
     * @param value
     * @returns {number}
     */
    this.mmConversionPx = function (value) {
        var inch = value/25.4;
        var c_value = inch*this.conversion_getDPI()[0];
        return c_value;
    }
}
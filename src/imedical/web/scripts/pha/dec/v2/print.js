/**
 * @模块:     煎药室打印相关
 * @编写日期: 2019-07-26
 * @编写人:   pushuangcai
 */
var DEC_PRINT = {
	Init: function(){
		return;
	},
	/**
	 * DecInfo 煎药信息panel
	 * @param {String} id hisui的layout的Id
	 * @param {Object} _opts panel属性将覆盖默认属性
	 * 					_opts.divId 显示标签信息的div的id	
	 */
	DecInfo: function(_id, _opts){
		if(!_id){ 
			return; 
		}
		_opts = _opts || {};
		var _conHtmlId = _opts.divId || (_id + "PanelPreDecInfo");
		var _defOpts = {
			width: 600,
		    title: "煎药信息",
			split: true,
		    region: 'west',
		    bodyCls: 'panel-body-gray',
		    iconCls: 'icon-paper',
		    headerCls: 'panel-header-gray',
		    content: '<div id="'+ _conHtmlId + '"></div>'
		}
		var _nOpts = $.extend({}, _defOpts, _opts);
		$('#'+_id).layout('add', _nOpts);
		return _conHtmlId;
	},
	//需显示或打印数据
	Data: function(_opts){
		var prescno = _opts.PrescNo || "";
		if(prescno == ""){
			//PHA.Popover({showType: "show", msg: "条码号为空！", type: 'alert'});
			return null;
		}
		var jsonData = $cm({
			ClassName: "PHA.DEC.PrtLab.Query", 
			MethodName: "GetLabPrtData",
			prescno:  prescno }, 
			false 
		)
		if(jsonData.errCode!=""){
			PHA.Popover({showType: "show", msg: jsonData.errCode, type: 'error'});
			return null;
		}
		return jsonData;	
	},
	PRINT: {
		//lodop打印
		LodopPrint: function(_opts){
			var jsonData = DEC_PRINT.Data(_opts);
			if(jsonData==null) return;
			LodopPrtLabel(jsonData, _opts.Num);
		},
		//xml打印
		XMLPrint: function(_opts){
			var jsonData = DEC_PRINT.Data(_opts);
			if(jsonData==null) return;
			var xmlPrtObj=DHCSTXMLPrint_JsonToXml(jsonData);	
			DHCSTGetXMLConfig(xmlPrtObj.xmlTemplet);
			DHCSTPrintFun(xmlPrtObj.xmlPara,xmlPrtObj.xmlList);
		},
		// 煎药信息打印
		DecInfoPrint:function(_opts){
			var jsonData = DEC_PRINT.Data(_opts);
			if(jsonData==null) return;
			LodopPrtDecInfo(jsonData);
		}
	},
	/**
	 * VIEW 显示煎药信息
	 * @param {String} id 显示内容的html元素的id
	 * @param {Object} _opts 
	 *					_opts.PrescNo 处方号
	 */
	VIEW: function (_id, _opts){
		if(!_id){ 
			return; 
		}
		_opts = _opts || {}
		
		$("#" + _id).html("");
		var jsonData = DEC_PRINT.Data(_opts);
		if(jsonData==null) return;
		var prescHtml = DHCSTXMLPrint_Preview.JsonToHtml(jsonData);
		$("#" + _id).html(prescHtml);
		return this
	},
	PRINTBoxLabel: {
		//lodop打印
		LodopPrint: function(_opts){
			var jsonData = DEC_PRINT.Data(_opts);
			if(jsonData==null) return;
			LodopPrtLabel(jsonData, _opts.Num);
		}
	},
}

/**
 * 调用lodop打印标签
 * @method LodopPrtLabel
 * @param 需打印数据
 */
function LodopPrtLabel(param, labNum){

	if(typeof(labNum)=="undefined") {
		labNum = "";
	}
	var jsonData = param;
	LabNum = labNum || jsonData.Para.LabNum;
	var prescNo = jsonData.Para.PrescNo;
	var patNo = jsonData.Para.PatNo;
	var patName = jsonData.Para.PatName;
	var deptLoc = jsonData.Para.DeptLoc
	if(jsonData.Para.TypeCode=="I"){
		var deptLoc = deptLoc + "(床位:"+jsonData.Para.BedNo+")"
	}
	var decInfo = jsonData.Para.QueInfo;

	var prtJson = {};
		prtJson.Para = {
			"PrescNo": prescNo,
			"PatNo": patNo,
			"PatName": patName,
			"OrdLocDesc": deptLoc,
			"DecInfo":decInfo
		}
	for(var i = 0; i < LabNum; i++){
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: "PHADECPrescLabel",
			data: prtJson
		});
	}
	
}

/// MaYuqiang 20210303
// 打印煎药室封箱贴
function PrintBoxLabel(BoxId, ReprintFlag) {
	if (typeof(ReprintFlag) == "undefined") {
		var ReprintFlag = "";
	} else {
		ReprintFlag = "【补】";
	}
	var PrintInfoStr = tkMakeServerCall("PHA.DEC.Com.Print", "GetBoxLabelInfo", BoxId);
	var PrintArr = PrintInfoStr.split("^");
	
	// boxNo _"^"_ frLocDesc _"^"_ toLocDesc _"^"_ boxDateTime _"^"_ prescNum
	// 物流箱信息
	var BoxNo = PrintArr[0];
	var FrLocDesc = PrintArr[1];
	var ToLocDesc = PrintArr[2];
	var BoxDate = PrintArr[3];
	var BoxTime = PrintArr[4];
	var PrescNum = PrintArr[5];
	var PrescFacNum = PrintArr[6];
	
	var prtJson = {};
	prtJson.Para = {
		"BoxNoCode": BoxNo,
		"BoxNo": BoxNo,
		"ReprintFlag": ReprintFlag,
		"FormLocDesc": "发放科室：" + FrLocDesc,
		"ToLocDesc": "接收科室：" + ToLocDesc,
		"BoxDate": "装箱日期：" + BoxDate,
		"BoxTime": "装箱时间：" + BoxTime,
		"PrescNum": "装箱付数："+PrescFacNum
	}
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHADECBoxLabel",
		data: prtJson
	});
}

/// MaYuqiang 20220613
// 打印煎药信息
function LodopPrtDecInfo(param){
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHADecPrtLabel",
		data: param
	});
}

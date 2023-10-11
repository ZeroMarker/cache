/**
 * @ģ��:     ��ҩ�Ҵ�ӡ���
 * @��д����: 2019-07-26
 * @��д��:   pushuangcai
 */
var DEC_PRINT = {
	Init: function(){
		return;
	},
	/**
	 * DecInfo ��ҩ��Ϣpanel
	 * @param {String} id hisui��layout��Id
	 * @param {Object} _opts panel���Խ�����Ĭ������
	 * 					_opts.divId ��ʾ��ǩ��Ϣ��div��id	
	 */
	DecInfo: function(_id, _opts){
		if(!_id){ 
			return; 
		}
		_opts = _opts || {};
		var _conHtmlId = _opts.divId || (_id + "PanelPreDecInfo");
		var _defOpts = {
			width: 600,
		    title: "��ҩ��Ϣ",
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
	//����ʾ���ӡ����
	Data: function(_opts){
		var prescno = _opts.PrescNo || "";
		if(prescno == ""){
			//PHA.Popover({showType: "show", msg: "�����Ϊ�գ�", type: 'alert'});
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
		//lodop��ӡ
		LodopPrint: function(_opts){
			var jsonData = DEC_PRINT.Data(_opts);
			if(jsonData==null) return;
			LodopPrtLabel(jsonData, _opts.Num);
		},
		//xml��ӡ
		XMLPrint: function(_opts){
			var jsonData = DEC_PRINT.Data(_opts);
			if(jsonData==null) return;
			var xmlPrtObj=DHCSTXMLPrint_JsonToXml(jsonData);	
			DHCSTGetXMLConfig(xmlPrtObj.xmlTemplet);
			DHCSTPrintFun(xmlPrtObj.xmlPara,xmlPrtObj.xmlList);
		},
		// ��ҩ��Ϣ��ӡ
		DecInfoPrint:function(_opts){
			var jsonData = DEC_PRINT.Data(_opts);
			if(jsonData==null) return;
			LodopPrtDecInfo(jsonData);
		}
	},
	/**
	 * VIEW ��ʾ��ҩ��Ϣ
	 * @param {String} id ��ʾ���ݵ�htmlԪ�ص�id
	 * @param {Object} _opts 
	 *					_opts.PrescNo ������
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
		//lodop��ӡ
		LodopPrint: function(_opts){
			var jsonData = DEC_PRINT.Data(_opts);
			if(jsonData==null) return;
			LodopPrtLabel(jsonData, _opts.Num);
		}
	},
}

/**
 * ����lodop��ӡ��ǩ
 * @method LodopPrtLabel
 * @param ���ӡ����
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
		var deptLoc = deptLoc + "(��λ:"+jsonData.Para.BedNo+")"
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
// ��ӡ��ҩ�ҷ�����
function PrintBoxLabel(BoxId, ReprintFlag) {
	if (typeof(ReprintFlag) == "undefined") {
		var ReprintFlag = "";
	} else {
		ReprintFlag = "������";
	}
	var PrintInfoStr = tkMakeServerCall("PHA.DEC.Com.Print", "GetBoxLabelInfo", BoxId);
	var PrintArr = PrintInfoStr.split("^");
	
	// boxNo _"^"_ frLocDesc _"^"_ toLocDesc _"^"_ boxDateTime _"^"_ prescNum
	// ��������Ϣ
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
		"FormLocDesc": "���ſ��ң�" + FrLocDesc,
		"ToLocDesc": "���տ��ң�" + ToLocDesc,
		"BoxDate": "װ�����ڣ�" + BoxDate,
		"BoxTime": "װ��ʱ�䣺" + BoxTime,
		"PrescNum": "װ�丶����"+PrescFacNum
	}
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHADECBoxLabel",
		data: prtJson
	});
}

/// MaYuqiang 20220613
// ��ӡ��ҩ��Ϣ
function LodopPrtDecInfo(param){
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHADecPrtLabel",
		data: param
	});
}

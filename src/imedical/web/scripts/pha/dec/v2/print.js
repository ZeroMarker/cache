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
	}
}

/**
 * ����lodop��ӡ��ǩ
 * @method LodopPrtLabel
 * @param ���ӡ����
 */
function LodopPrtLabel(param, labNum){
	if(typeof(labNum)=="undefined") {labNum = "";}
	var jsonData = param;
	var htmlStr = "";
	htmlStr += "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:19px;font-family:Microsoft Yahei} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:19px;text-align:left} tfoot,th,tr,td{font-weight:normal}</style><table>";
	htmlStr += "<tbody>";
	htmlStr += "<tr>";
	htmlStr += "<td>" + "�ǼǺ�" +"</td>";
	htmlStr += "<td>" + jsonData.Para.PatNo +"</td>";
	htmlStr += "<td>" + " ����" +"</td>";
	htmlStr += "<td>" + jsonData.Para.PatName +"</td>";
	htmlStr += "</tr>";
	htmlStr += "<tr>";
	htmlStr += "<td>" + "��&nbsp;&nbsp;&nbsp;��" +"</td>";
	var deptLoc = jsonData.Para.DeptLoc
	if(jsonData.Para.TypeCode=="I"){
		var deptLoc = deptLoc + "(��λ:"+jsonData.Para.BedNo+")"
	}
	htmlStr += "<td colspan='3'>" + deptLoc +"</td>";
	/*if(jsonData.Para.TypeCode=="I"){
		htmlStr += "<td>" + " ��λ" +"</td>";
		htmlStr += "<td>" + "10��" +"</td>";
	}*/
	htmlStr += "</tr>";
	htmlStr += "<tr>";
	htmlStr += "<td  colspan='4'>" + jsonData.Para.QueInfo +"</td>";
	htmlStr += "</tr>";
	
	htmlStr += "</tbody>";
	
	DECLODOP = getLodop();
	LabNum = labNum || jsonData.Para.LabNum;
	for(var i = 0; i < LabNum; i++){
		DECLODOP.PRINT_INIT("��ҩ��ǩ");
		DECLODOP.SET_PRINT_STYLE("FontName", "Microsoft Yahei");
	    DECLODOP.SET_PRINT_PAGESIZE(1, "500mm", "300mm", "");
	    DECLODOP.SET_PRINT_STYLEA(0, "FontName", "Microsoft Yahei");
	    DECLODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
	    DECLODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
	    DECLODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	    // ��ά��
	    DECLODOP.ADD_PRINT_BARCODE("5mm", "3mm", "30mm", "30mm", "QRCode", jsonData.Para.PrescNo);
	    DECLODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	    DECLODOP.SET_PRINT_STYLEA(0, "Alignment", 3);
	    DECLODOP.ADD_PRINT_TABLE("6mm", "26mm", "200mm", "40mm" , htmlStr);
    	DECLODOP.PRINT();
	}
}
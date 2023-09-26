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
	}
}

/**
 * 调用lodop打印标签
 * @method LodopPrtLabel
 * @param 需打印数据
 */
function LodopPrtLabel(param, labNum){
	if(typeof(labNum)=="undefined") {labNum = "";}
	var jsonData = param;
	var htmlStr = "";
	htmlStr += "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:19px;font-family:Microsoft Yahei} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:19px;text-align:left} tfoot,th,tr,td{font-weight:normal}</style><table>";
	htmlStr += "<tbody>";
	htmlStr += "<tr>";
	htmlStr += "<td>" + "登记号" +"</td>";
	htmlStr += "<td>" + jsonData.Para.PatNo +"</td>";
	htmlStr += "<td>" + " 姓名" +"</td>";
	htmlStr += "<td>" + jsonData.Para.PatName +"</td>";
	htmlStr += "</tr>";
	htmlStr += "<tr>";
	htmlStr += "<td>" + "科&nbsp;&nbsp;&nbsp;室" +"</td>";
	var deptLoc = jsonData.Para.DeptLoc
	if(jsonData.Para.TypeCode=="I"){
		var deptLoc = deptLoc + "(床位:"+jsonData.Para.BedNo+")"
	}
	htmlStr += "<td colspan='3'>" + deptLoc +"</td>";
	/*if(jsonData.Para.TypeCode=="I"){
		htmlStr += "<td>" + " 床位" +"</td>";
		htmlStr += "<td>" + "10床" +"</td>";
	}*/
	htmlStr += "</tr>";
	htmlStr += "<tr>";
	htmlStr += "<td  colspan='4'>" + jsonData.Para.QueInfo +"</td>";
	htmlStr += "</tr>";
	
	htmlStr += "</tbody>";
	
	DECLODOP = getLodop();
	LabNum = labNum || jsonData.Para.LabNum;
	for(var i = 0; i < LabNum; i++){
		DECLODOP.PRINT_INIT("煎药标签");
		DECLODOP.SET_PRINT_STYLE("FontName", "Microsoft Yahei");
	    DECLODOP.SET_PRINT_PAGESIZE(1, "500mm", "300mm", "");
	    DECLODOP.SET_PRINT_STYLEA(0, "FontName", "Microsoft Yahei");
	    DECLODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
	    DECLODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
	    DECLODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	    // 二维码
	    DECLODOP.ADD_PRINT_BARCODE("5mm", "3mm", "30mm", "30mm", "QRCode", jsonData.Para.PrescNo);
	    DECLODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	    DECLODOP.SET_PRINT_STYLEA(0, "Alignment", 3);
	    DECLODOP.ADD_PRINT_TABLE("6mm", "26mm", "200mm", "40mm" , htmlStr);
    	DECLODOP.PRINT();
	}
}
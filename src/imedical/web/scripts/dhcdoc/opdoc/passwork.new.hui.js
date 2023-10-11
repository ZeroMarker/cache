/**
 * passwork.hui.js 医生交排班新版本
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * TABL: DHCDoc_ExceedReason
 */
//页面全局变量
var PageLogicObj = {
	m_DurDataGrid : "",
	m_DefaultDate:"",	//日期框默认显示的日期
	m_DeafultBCode:"",	//当前所属时间的班次代码
	m_initLabelCount:0,	//初始化标签次数,用来计算是否需要重新设置班次div大小
	m_LabelCode:"",		//用来存储当前所选的标签
	m_Type: "",
	m_Win : "",
	m_BCode: "",
	m_SaveDate:""		//班次保存日期
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	PageHandle();
})


function Init(){
	InitBaseData();
	PageLogicObj.m_DefaultDate = GetDefaultDate();
	PageLogicObj.m_DeafultBCode = GetDefaultBCode();
	PageLogicObj.m_XMLStr = GetXMLStr();
	InitSummaryTable();
	InitWorkPanel(PageLogicObj.m_DeafultBCode);
	InitBCLabelTitle(PageLogicObj.m_DefaultDate, PageLogicObj.m_DeafultBCode);	//初始化班次查询标签title
	InitBCTip(session['LOGON.CTLOCID'],PageLogicObj.m_DefaultDate,PageLogicObj.m_DeafultBCode);
	//类型下拉框
	PageLogicObj.m_Type = $HUI.combobox("#i-type", {
		url:$URL+"?ClassName=web.DHCDocPassWork&QueryName=QryPassWorkType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		/*,onSelect: function (r) {
			findConfig();
		},
		onChange: function (newValue, oldValue) {
			if (newValue == undefined) {
				findConfig();
			}
		}*/
	});	
	//病区下拉框 
	var inHosp = session['LOGON.HOSPID'];
	PageLogicObj.m_ward = $HUI.combobox("#i-ward", {
		url:$URL+"?ClassName=web.DHCDocPassWorkE2&QueryName=QryWard&rowid=" + "" + "&inHosp="+inHosp+"&ResultSetType=array",	//session['LOGON.CTLOCID']
		valueField:'LINKCTLOCDR',
		textField:'LINKCTLocDesc',
		defaultFilter:4,
		//multiple:true,
		//rowStyle:'checkbox', //显示成勾选行形式
		blurValidValue:true
		/*,onSelect: function (r) {
			findConfig();
		},
		onChange: function (newValue, oldValue) {
			if (newValue == undefined) {
				findConfig();
			}
		}*/
	});	
	//日期框
	$("#i-date").datebox({
		required:true,
		editable:false,
		onSelect: function (date) {
			var curDate = $(this).datebox("getValue");
			var tempFlag = EnableSelectDate(curDate);
			if (!tempFlag) {
				$(this).datebox('setValue', PageLogicObj.m_DefaultDate);
				return false;
			}
			var BCType = GetBCType();
			InitBCLabelTitle(curDate,BCType);
			//设置提示信息
			InitBCTip(session['LOGON.CTLOCID'],curDate,BCType);
			LoadData();
			findConfig();
		}
	})
	//初始化表格
	PageLogicObj.m_DurDataGrid = InitDurDataGrid();
}

/**
 * 设置提示信息
 * @param {*} LocId ：科室ID
 * @param {*} FindDate ：查询日期
 * @param {*} BCode ：班次code
 */
function InitBCTip (LocId, FindDate, BCode) {
	var responseText = $.m({
		ClassName:"web.DHCDocPassWorkE2",
		MethodName:"InitBCTip",
		LocId:LocId,
		FindDate: FindDate,
		BCode:BCode
	},false);
	$("#i-bc-tip").html(responseText);
	
}

/**
 * 初始化基础数据
 */
function InitBaseData () {
	var responseText = $.m({
		ClassName:"DHCDoc.DHCDocConfig.PassWork",
		MethodName:"InitBaseData",
	},false);

	return responseText;
}

/**
 * 初始化查询标签Title
 * 
 * @param {*} FindDate : 查询日期
 * @param {*} BCode ：班次代码
 */
function InitBCLabelTitle (FindDate, inBCode) {
	PageLogicObj.m_initLabelCount++;
	FindDate = FindDate||($("#i-date").datebox('getValue'));
	var responseText = $.m({
		ClassName:"web.DHCDocPassWorkE2",
		MethodName:"InitBCLabelTitle",
		FindDate: FindDate,
		LocId:session['LOGON.CTLOCID']
	},false);
	var resultArr = responseText.split("^");
	//先清空标签
	$("#i-bctitle").html("");
	//处理班次达到3班以上时，标签显示溢出问题
	if ((resultArr.length>3)&&(PageLogicObj.m_initLabelCount==1)) {	
		$("#bc").css("height","65px");
		$('#i-north').panel({height:295});	//335
		//$("#i-north").css("height","355px");
		//$('#i-north').panel({height:200});
		//alert(1);
		$('#i-layout').layout('resize');
	}
	for (var i=0; i<resultArr.length; i++) {
		var cDomStr = resultArr[i];
		if ((i+1)%3 == 0) {
			cDomStr = cDomStr + "<br/>"
		}
		var $cDom = $(cDomStr);
		$("#i-bctitle").append($cDom);
	}
	//得到当前的时间的班次信息
	responseText = $.m({
		ClassName:"web.DHCDocPassWorkE2",
		MethodName:"GetCurrentBC"
	},false);
	resultArr = responseText.split("^");
	var BCode = resultArr[0];
	//设置面板标题
	$("#work-d").panel("setTitle", resultArr[1]);
	//设置选中的标签
	if (PageLogicObj.m_initLabelCount==1) {
		$("#LB-"+BCode).addClass("selected");
		PageLogicObj.m_LabelCode = BCode;
		//设置当前班次提示
		var tipContent = $.m({
			ClassName:"web.DHCDocPassWorkE2",
			MethodName:"GetCurrentBCTip"
		},false);
		tipContent = "<label class='c-label c-tip'>当前班次：" + tipContent + "</label>";
		$("#i-tip").html(tipContent);
	} else {
		if ($("#LB-" + PageLogicObj.m_LabelCode).length>0) {
			$("#LB-" + PageLogicObj.m_LabelCode).addClass("selected");
		} else if ($("#LB-"+BCode).length>0) {
			$("#LB-"+BCode).addClass("selected");
		} else {
			$($("#i-bctitle label")[0]).addClass("selected");
		}
	}
	//设置保存日期
	PageLogicObj.m_SaveDate = $("#BT-"+BCode).text();
	//添加班次标签事件
	InitBCLabelEvent();
}

/**
 * 初始化面板
 */
function InitWorkPanel(BCode) {
	$("#WorkD-Panel").removeClass("c-hidden");
	$("#work-d-save").linkbutton();
	var workPanel = $HUI.panel("#work-d",{
		//fit:true,
		//height:400,
		title:"HH",
		headerCls:'panel-header-card-gray'
	});
}
/**
 * 初始化数据汇总Table
 */
function InitSummaryTable () {
	var responseText = $.m({
		ClassName:"web.DHCDocPassWorkE2",
		MethodName:"InitSummaryTable"
	},false);
	var $cDom = $(responseText)
	$("#SummaryTable").append($cDom);
}
 /**
 * 获取：日期框默认显示的日期
 */
function GetDefaultDate () {
	var ret = tkMakeServerCall("web.DHCDocPassWork", "GetDefaultDate");
	return ret;
}

/**
 * 获取：当前所属时间的班次代码
 */
function GetDefaultBCode() {
	var ret = tkMakeServerCall("web.DHCDocPassWorkE2", "GetCurrentBCCode");
	return ret;
}

/**
 * 获取：当前所属时间的班次代码
 */
function GetXMLStr() {
	var responseText = $.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"GetClassPropertyList",
		cls: "web.DHCDocPassWork"
	},false);
	return responseText;
}

/**
 * 判断所选日期是否在可选的范围内
 * @param {*} SelectDate 
 */
function EnableSelectDate (SelectDate) {
	var responseText = $.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"EnableSelectDate",
		SelectDate: SelectDate
	},false);
	if (responseText == 0) {
		return true;
	} else {
		return false;
	}
}
function DisableAll () {
	// $("#work-n").panel({
	// 	headerCls:'panel-header-card-gray'
	// });
	$("input").attr("disabled", "disabled");
	$("#work-n-table input");
	$(".validatebox-text").removeAttr("disabled");
	PageLogicObj.m_Type.disable();
	$(".hisui-linkbutton").linkbutton("disable");
	$(".datagrid-toolbar a").linkbutton("disable");
}
function EnableAll () {
	$("input").removeAttr("disabled");
	PageLogicObj.m_Type.enable();
	$(".hisui-linkbutton").linkbutton("enable");
	$(".datagrid-toolbar a").linkbutton("enable");
}
function DisableNight () {
	EnableAll();
	$("#work-n-table input").attr("disabled", "disabled");
	$("#work-n-save").linkbutton("disable");
}
function InitEditStatus () {
	var editFlag = tkMakeServerCall("web.DHCDocPassWork", "IfEnableEdit", PageLogicObj.m_DefaultDate);
	if (editFlag == "NO-ALL") {
		DisableAll();

	} else if (editFlag == "OK-ALL") {
		EnableAll();
	} else if (editFlag == "OK-D") {
		DisableNight();
	}
}
/**
 * 初始化事件
 */
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(editPatInfo);	//修改病人信息
	//保存班次
	$("#work-d-save").click(function(){
		SaveBCInfo()
	});
	$("#i-tip").click(function () {
		$("#i-date").datebox('setValue', PageLogicObj.m_DefaultDate);
		InitBCLabelTitle(PageLogicObj.m_DefaultDate,PageLogicObj.m_DeafultBCode);
		$("#LB-"+PageLogicObj.m_DeafultBCode).trigger("click");
	});
	$("#i-selfPeron").click(SelfPersonFind);
	$("#i-selfLoc").click(SelfLocFind);
	$("#i-export").click(exportData);
	$("#i-collapse").click(function(){
		$('#i-layout').layout('collapse','north');  
	})
	$("#i-prevBC").switchbox({
		onText:"所有",
		offText:"上一班",
		size:"small",
		onSwitchChange: function (e,obj) {
			if (obj.value) {
				//加载所有
				findConfig();
			} else {
				//上一班次
				findConfig();
			}
		}
	})
	$("#i-print").click(function () {
		printPWData();
	});
	$(document.body).bind("keydown",BodykeydownHandler)
	document.onkeydown = DocumentOnKeyDown;
}

/**
 * 初始化班次标签事件
 */
function InitBCLabelEvent(){
	$("#i-bctitle label").on("click", function(){
		var onid = $(this).attr("id");
		var onBCode = onid.split("-")[1];
		var onname = $(this).attr("name");
		PageLogicObj.m_LabelCode = onBCode;
		$("#i-bctitle label").each(function (i, obj) {
			var cid = $(this).attr("id");
			if (cid == onid) {
				$(this).addClass("selected");
			} else {
				$(this).removeClass("selected");
			}
		})
		//设置标题
		$("#work-d").panel("setTitle", onname);
		//设置保存日期
		PageLogicObj.m_SaveDate = $("#BT-"+onBCode).text();
		//设置提示信息
		InitBCTip(session['LOGON.CTLOCID'],PageLogicObj.m_SaveDate,onBCode);
		findConfig();
	});
}
/**
 * 初始化弹出框事件
 */
function InitDGEvent() {
	$("#dg-patno").keydown(function (event) {
        if (event.which == 13 || event.which == 9) {
            var PatNo = $('#dg-patno').val();
			//if (PatNo=="") return;
			if ((PatNo.length<10)&&(PatNo!="")) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#dg-patno').val(PatNo);
        }
    });
}
/**
 * 保存班次信息
 */
function SaveBCInfo () {
	var BCType = GetBCType();
	var bT = "d";	//BCType.toLowerCase();
	var FXMLStr = BulidXMLData(bT);
	var Note = $.trim($("#" + bT + "-Note").val());
	var Pwd = $("#" + bT + "-Pwd").val();
	var LocId = session['LOGON.CTLOCID'];
	var userid = session['LOGON.USERID'];
	var FindDate = PageLogicObj.m_SaveDate; 	//$("#i-date").datebox('getValue');
	var BaseInfo = LocId + "^" + userid + "^" + Pwd + "^" + FindDate + "^" + BCType;
	//web.DHCOEOrdItem.PinNumberValid
	$.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"SaveBCInfo",
		BaseInfo: BaseInfo,
		XMLStr: FXMLStr,
		Note: Note,
	},function (responseText){
		if(responseText == 0) {
			$.messager.alert('提示',"保存成功！" , "info");
			findConfig();
			$("#d-Pwd").val("");
			//设置提示信息
			InitBCTip(session['LOGON.CTLOCID'],PageLogicObj.m_SaveDate,BCType);
			return true;
		} else if (responseText == 2) {
			$.messager.alert('提示','签名密码错误！' , "info");
			return false;
		} else if (responseText == 3) {
			$.messager.alert('提示','不是交班人不允许修改！' , "info");
			return false;
		} else {
			$.messager.alert('提示','加载失败: '+ responseText , "info");
			return false;
		}
	})

}

function BulidXMLData (bcType) {
	/*var PreSum = $("#" + bcType + "-PreSum").val();
	var NowSum = $("#" + bcType + "-NowSum").val();
	var OutHospNum = $("#" + bcType + "-OutHospNum").val();
	var InHospNum = $("#" + bcType + "-InHospNum").val();
	var OutWardNum = $("#" + bcType + "-OutWardNum").val();
	var InWardNum = $("#" + bcType + "-InWardNum").val();
	var OperNum = $("#" + bcType + "-OperNum").val();
	var SeverityNum = $("#" + bcType + "-SeverityNum").val();
	var CritiNum = $("#" + bcType + "-CritiNum").val();
	var DeathNum = $("#" + bcType + "-DeathNum").val();
	var XMLJson = {
		"PreSum" : PreSum,
		"NowSum" : NowSum,
		"OutHospNum" : OutHospNum,
		"InHospNum" : InHospNum,
		"OutWardNum" : OutWardNum,
		"InWardNum" : InWardNum,
		"OperNum" : OperNum,
		"SeverityNum" : SeverityNum,
		"CritiNum" : CritiNum,
		"DeathNum" : DeathNum,
	};*/
	var FXMLStr = "";
	/*var responseText = $.m({
		ClassName:"web.DHCDocPassWork",
		MethodName:"GetClassPropertyList",
		cls: "web.DHCDocPassWork"
	},false);*/
	//var responseText = tkMakeServerCall("web.DHCBL.UDHCCommFunLibary", "GetClassPropertyList", "web.DHCDocPassWork");
	var XMLNodes = PageLogicObj.m_XMLStr.split("^");
	for (var i=0; i < XMLNodes.length; i++) {
		var curNode = XMLNodes[i];
		if ((curNode=="Note")||(curNode=="PWId")) {
			continue;
		}
		var curValue = $("#" + bcType + "-" + curNode).val();
		if (FXMLStr == "") {
			FXMLStr = "<PW>" + "<" + curNode + ">" + curValue + "</" + curNode + ">";	//XMLJson[curNode]
		} else {
			FXMLStr = FXMLStr + "<" + curNode + ">" + curValue + "</" + curNode + ">"
		}
	}
	if (FXMLStr !="") {
		FXMLStr = FXMLStr + "</PW>";
	} 
	return FXMLStr;
}

function PageHandle(){
	$("#i-date").datebox("setValue", PageLogicObj.m_DefaultDate);
	LoadData();
}

/**
 * QP
 * 加载汇总数据
 * 去除异步加载，防止多次点击查询时，在IE下导致每次数据不一致问题。
 */
function LoadData() {
	var BCType = GetBCType();
	var responseText = $.m({
		ClassName:"web.DHCDocPassWorkE2",
		MethodName:"GetPWSummary",
		Para: session['LOGON.CTLOCID'] + "^" + PageLogicObj.m_SaveDate + "^" + session['LOGON.USERID'],
		FindType:BCType
	},false)
	if(responseText != "") {
		var jsonData = $.parseJSON(responseText);
		var XMLNodes = PageLogicObj.m_XMLStr.split("^");
		for (var i=0; i < XMLNodes.length; i++) {
			var curNode = XMLNodes[i];
			$("#d" + "-" + curNode).val(jsonData[0][curNode]);
			if (curNode == "PWId") {
				var mainId = "m_" + BCType + "MainId";
				PageLogicObj[mainId] = jsonData[0][curNode];
			}
		}
		/*
		var workData = responseText.split("^");
		var _idPrex = "#" + "d"	//workType.toLowerCase();
		$(_idPrex + "-PreSum").val(workData[0]);
		$(_idPrex + "-NowSum").val(workData[1]);
		$(_idPrex + "-OutHospNum").val(workData[2]);
		$(_idPrex + "-InHospNum").val(workData[3]);
		$(_idPrex + "-OutWardNum").val(workData[4]);
		$(_idPrex + "-InWardNum").val(workData[5]);
		$(_idPrex + "-OperNum").val(workData[6]);
		$(_idPrex + "-SeverityNum").val(workData[7]);
		$(_idPrex + "-CritiNum").val(workData[8]);
		$(_idPrex + "-DeathNum").val(workData[9]);
		$(_idPrex + "-Note").val(workData[10]);
		var workType = BCType;
		var mainId = "m_" + workType + "MainId";
		PageLogicObj[mainId] = workData[11];
		*/
	} else {
		//$.messager.alert('提示','数据加载失败: '+ responseText , "info");
		//return false;
	}
}

function InitDurDataGrid(){
	var BCType = GetBCType();
	var columns = [[
		
		{field:'PatWorkTypeDesc',title:'类型',width:100},
		{field:'fillFlag',title:'填写标志',width:100,
			formatter:function(value,row,index){
				if (value == 1) {
					return "<span class='fillspan'>已填写</span>";
				} if (value == 2) {
					return "<span class='fillspan-no'>未填写</span>";
				} else {
					return "<span class='fillspan-nosave'>未保存</span>";
				}
			}
		},
		{field:'PatNo',title:'登记号',width:150},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:100},
		{field:'PatAge',title:'年龄',width:100},
		{field:'PatWardDesc',title:'病区',width:100,hidden:true},
		{field:'AdmDocDesc',title:'主管医生',width:100},
		{field:'PatDiagnos',title:'诊断',width:250},
		{field:'PatOperName',title:'手术',width:100},
		{field:'PatMedicareNo',title:'住院号',width:100},
		{field:'CurBedCode',title:'床号',width:100},
		{field:'BCRemark',title:'交班信息',width:100,
			formatter:function(value,row,index){
				var text = value;
				if ((row.BCItemId!="")&&(text == "")) text = "编辑"
				if (row.BCItemId == "") text="";
				//var s = '<a style="color:#40A2DE; cursor:pointer;" onclick="EditDWork(' + "'" + row.BCItemId + "'" + ') ">' + text + '</a>';
				var s = '<a style="color:#40A2DE; cursor:pointer;" onclick="LoadTPLURL(' + "'" + row.BCItemId + "'" + ", '" + row.TplURL + "'" + ", '" + row.EpisodeID + "'"+ ", '" + row.PatWorkType + "'" + ') ">' + text + '</a>';
				return s;
			}
		},
		{field:'BCRemarkUser',title:'更新人',width:100},
		{field:'BCRemarkUserID',title:'更新人ID',width:100,hidden:true},
		{field:'PatientID',title:'病人ID',width:100,hidden:true},
		{field:'EpisodeID',title:'就诊ID',width:100,hidden:true},
		{field:'BCItemId',title:'子表ID',width:100,hidden:true},
		{field:'TplURL',title:'TplURL',width:100,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-durGrid", {
		fit : true,
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "web.DHCDocPassWorkE2",
			QueryName : "FindPassWorkPatList",
			LocId: session['LOGON.CTLOCID'],
			FindDate: PageLogicObj.m_SaveDate,	//PageLogicObj.m_DefaultDate,
			UserId: '',	//session['LOGON.USERID'],
			FindBCType:BCType
		},
		//idField:'Rowid',
		columns :columns,
		toolbar:[{
				text:'新增',
				id:'i-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'i-edit',
				iconCls: 'icon-write-order'
			},
			{
				text:'导出',
				id:'i-export',
				iconCls: 'icon-export'
			}
			,
			{
				text:'打印',
				id:'i-print',
				iconCls: 'icon-print'
			}
		]
	});
	
	return DurDataGrid;
}

//编辑或新增
function opDialog(action,ItemID) {
	var bcType = GetBCType();
	var mainIdStr = "m_" + bcType + "MainId";
	var mainId = PageLogicObj[mainIdStr]||"";
	if (mainId == "") {
		$.messager.alert('提示','请先保存班次信息!',"info");
		return false;
	}
	
	var _title = "", _icon = "" ;
	if (action == "add") {
		_title = "新增";
		_icon = "icon-w-add";
		$("#dg-action").val("add");
		$("#dg-id").val("");
	} else {
		_title = "修改";
		_icon = "icon-w-edit";
		$("#dg-action").val("edit");
		$("#dg-id").val(ItemID);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	var PatInfo = "", PatArr = "";
	if (!!ItemID) {
		PatInfo = $.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"GetPatInfoByItemID",
			ItemID: ItemID
		},false);
	}
	PageLogicObj.m_DG_BC = $HUI.combobox("#dg-bc", {
		url:$URL+"?ClassName=web.DHCDocPassWorkE2&QueryName=QryPassWorkBC&ResultSetType=array",
		valueField:'id',
		value:bcType,
		disabled:true,
		textField:'desc'
		
	});	
	PageLogicObj.m_DG_Type = $HUI.combobox("#dg-type", {
		url:$URL+"?ClassName=web.DHCDocPassWork&QueryName=QryPassWorkType&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
	});	
	
	if (action == "add") {
		$("#dg-patno").val("");
		$("#dg-content").val("");
		PageLogicObj.m_BCode = "";
	} else {
		PatArr = PatInfo.split(String.fromCharCode(1));
		$("#dg-content").val(PatArr[4]);
		_title = _title + PatArr[0];
		PageLogicObj.m_BCode = PatArr[7];
		//if (PatArr[0] == "白班") PageLogicObj.m_BCode = "D";
		//else PageLogicObj.m_BCode = "N";
	}
	hiddenItem(action,PatArr);
	var cWin = $HUI.window('#i-dialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		//maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-dialog').addClass("c-hidden");
		}
	});
	InitDGEvent();
	PageLogicObj.m_Win = cWin;
}

function hiddenItem(action, PatArr) {
	if (action == "add") {
		$("#dg-patinfo").addClass("c-hidden");
		$("#dg-add-tr").removeClass("c-hidden");
		$("#dg-add-tr2").removeClass("c-hidden");
		$("#dg-msg").html("");
		$("#i-pre").addClass("")
		$("#i-pre").addClass("c-hidden");
		$("#i-next").addClass("c-hidden");
	} else {
		$("#dg-add-tr").addClass("c-hidden");
		$("#dg-add-tr2").addClass("c-hidden");
		$("#dg-patinfo").removeClass("c-hidden");
		$("#i-pre").removeClass("c-hidden");
		$("#i-next").removeClass("c-hidden");
		var baseMsg = "<span class='tip'>" + PatArr[0] + "—>" + PatArr[1] + "—>" + PatArr[2] + "—>" + PatArr[3] + "—>" + PatArr[6] + "</span>";
		baseMsg = baseMsg + "<br/><a class='findLab' onclick='seeLabDetail("+ PatArr[5] + ")'>点击查看检验检查信息</a>";
		$("#dg-msg").html(baseMsg);
	}
}
function deConfig () {
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocExceedReason",
			MethodName:"Delete",
			'ID': selected.ExceedID,
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','删除成功',"info");
				PageLogicObj.m_DurDataGrid.reload();
			} else {
				$.messager.alert('提示','修改失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
}

function setDurTime() {
	if($('#i-time').hasClass("c-hidden")) {
		$('#i-time').removeClass("c-hidden");
	};
	//赋值
	$.m({
		ClassName:"web.DHCDocExceedReason",
		MethodName:"GetExceedDate",
		'AdmType':"O"
	},function (responseText){
		$("#i-time-mz").val(responseText);	
	})
	
	$.m({
		ClassName:"web.DHCDocExceedReason",
		MethodName:"GetExceedDate",
		'AdmType':"E"
	},function (responseText){
		$("#i-time-jz").val(responseText);	
	})
	
	//
	var cWin = $HUI.window('#i-time', {
		title: "设置限定时间",
		//iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-time').addClass("c-hidden");
		}
	});
	PageLogicObj.m_TimeWin = cWin;
}

function saveTime () {	
	var mzTime = $.trim($("#i-time-mz").val());	
	var jzTime = $.trim($("#i-time-jz").val());	
	var otn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","O",mzTime);
	var etn=tkMakeServerCall("web.DHCDocExceedReason","SetExceedDate","E",jzTime);
	$.messager.alert('提示','设置成功',"info");
	PageLogicObj.m_TimeWin.close();
}

/**
 * 上一个和下一个
 * @param {*} action 
 */
function editCfg (action) {	//从0开始
	//var data = PageLogicObj.m_DurDataGrid.getData();
	//var total = data.total;
	var options = PageLogicObj.m_DurDataGrid.getPager().data("pagination").options;
	var pageSize = options.pageSize;
	//var options = $("#sourceDG" ).datagrid("getPager").data("pagination").options;
	//curr = options.pageNumber;  
	//console.log(curr);
	//size = options.pageSize;
	var selectedOld = PageLogicObj.m_DurDataGrid.getSelected();
	var oldRowIndex = PageLogicObj.m_DurDataGrid.getRowIndex(selectedOld);
	var newIndex = "-1"
	if (action == "next") {
		newIndex = oldRowIndex + 1;
		if (newIndex >= pageSize) {
			$.messager.alert('提示','已是当前最后一行!',"info");
			return false;
		}
	} else {
		newIndex = oldRowIndex - 1
		if (newIndex < 0) {
			$.messager.alert('提示','已是第一行!',"info");
			return false;
		}
	}

	PageLogicObj.m_DurDataGrid.selectRow(newIndex);
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert('提示','已是当前最后一行!',"info");
		return false;
	}
	var _itemStr = "BCItemId";	//PageLogicObj.m_BCode + "ItemId";
	opDialog("edit", selected[_itemStr]);
}

/**
 * 保存交班内容
 */
function saveCfg() {
	var id = $("#dg-id").val();
	var action = $("#dg-action").val();
	var bcType = PageLogicObj.m_DG_BC.getValue()||"";
	var workType = PageLogicObj.m_DG_Type.getValue()||"";
	var content = $.trim($("#dg-content").val());
	var patno = $.trim($("#dg-patno").val());
	var mainIdStr = "m_" + bcType + "MainId";
	var admId = "", mainId = "", hasFlag = "";
	if ((action == "add")&&(bcType == "")) {
		$.messager.alert('提示','班次不能为空!',"info");
		return false;
	}
	if ((action == "add")&&(workType == "")) {
		$.messager.alert('提示','类型不能为空!',"info");
		return false;
	}
	if ((action == "add")&&(patno == "")) {
		$.messager.alert('提示','登记号不能为空!',"info");
		return false;
	}
	if ((action == "edit")&&(content == "")) {
		$.messager.alert('提示','请输入交班内容!',"info");
		return false;
	}
	if (action == "add") {
		admId = $.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"GetAdmIdByPatNo",
			PapmiNo: patno
		},false);
		if (admId == "") {
			$.messager.alert('提示','无法获取该病人的就诊信息!',"info");
			return false;
		}
		mainId = PageLogicObj[mainIdStr]||"";
		if (mainId == "") {
			$.messager.alert('提示','请先保存班次信息!',"info");
			return false;
		}
		var hasFlag = $.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"IfHasPat",
			InPara: mainId + "^" + admId + "^" + session['LOGON.CTLOCID'] + "^" + workType
		},false);
		if (hasFlag == 1) {
			$.messager.alert('提示','已经添加过该病人信息!',"info");
			return false;
		}
		//类型^就诊ID^科室ID^交班日期^交班人^ID
		var InPara = workType + "^" + admId + "^" + session['LOGON.CTLOCID'] + "^^" + session['LOGON.USERID'] + "^" + id;
		$.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"SavePWDetail",
			DDPWRowID: mainId,
			PatDetail: InPara,
			BCNote: content,
			Action:"Add"
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','新增成功',"info");
				PageLogicObj.m_Win.close();
				//PageLogicObj.m_DurDataGrid.reload();
				findConfig();
			} else if (responseText == "-103") {
				$.messager.alert('提示','不是交班人不允许添加！' , "info");
				return false;
			} else {
				$.messager.alert('提示','添加失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		$.m({
			ClassName:"web.DHCDocPassWork",
			MethodName:"EditPWDetail",
			UserId: session['LOGON.USERID'],
			ItemId: id,
			BCNote: content
		},function (responseText){
			if(responseText == 0) {
				var selectedOld = PageLogicObj.m_DurDataGrid.getSelected();
				var rowIndexOld = PageLogicObj.m_DurDataGrid.getRowIndex(selectedOld);
				//PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
				$.messager.alert('提示','修改成功',"info",function() {
					PageLogicObj.m_DurDataGrid.selectRow(rowIndexOld);
				});
				
			} else if (responseText == "-103") {
				$.messager.alert('提示','不是交班人不允许修改！' , "info");
				return false;
			} else {
				$.messager.alert('提示','修改失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
	}
	
}

function SwitchBCType(BCType) {
	PageLogicObj.m_SaveDate = $("#BT-"+BCType).text();
	alert($("#BT-"+BCType).text());
	/* if (BCType == "D") {
		$("#i-WorkD").addClass("selected");
		$("#i-WorkN").removeClass("selected");
		PageLogicObj.m_SaveDate = $("#BCD-D").text();
	} else {
		$("#i-WorkN").addClass("selected");
		$("#i-WorkD").removeClass("selected");
		PageLogicObj.m_SaveDate = $("#BCD-N").text();
	} */
}
/**
 * 导出数据
 */
function exportData () {
	var userid = session['LOGON.USERID'];
	var selfLocFlag = $("#i-selfLoc").hasClass("selected");
	if (selfLocFlag) {
		userid = "";
	}
	var BCType = GetBCType();
	if (BCType == "") {
		$.messager.alert('提示','请选择班次！' , "info");
		return false;
	}
	var PrevFlag = $("#i-prevBC").switchbox("getValue")?0:1;
	var bcType = "d";	//BCType.toLowerCase();
	var PreSum = $("#" + bcType + "-PreSum").val();
	var NowSum = $("#" + bcType + "-NowSum").val();
	var OutHospNum = $("#" + bcType + "-OutHospNum").val();
	var InHospNum = $("#" + bcType + "-InHospNum").val();
	var OutWardNum = $("#" + bcType + "-OutWardNum").val();
	var InWardNum = $("#" + bcType + "-InWardNum").val();
	var OperNum = $("#" + bcType + "-OperNum").val();
	var SeverityNum = $("#" + bcType + "-SeverityNum").val();
	var CritiNum = $("#" + bcType + "-CritiNum").val();
	var DeathNum = $("#" + bcType + "-DeathNum").val();
	var Note = $.trim($("#" + bcType + "-Note").val());
	var xmlData = PreSum + "^" + OutHospNum + "^" + InHospNum + "^" + OutWardNum + "^" + InWardNum;
	xmlData = xmlData + "^" + OperNum + "^" + SeverityNum + "^" + CritiNum + "^" + DeathNum + "^" + NowSum;
	var rtn = $cm({
		//dataType:'text',
		//ResultSetType:'Excel',
		ExcelName:'JBData',
	    ResultSetType:"ExcelPlugin",
		ClassName:'web.DHCDocPassWorkE2',
		QueryName:'ExportData',
		LocId: session['LOGON.CTLOCID'],
		FindDate: PageLogicObj.m_SaveDate,	//$("#i-date").datebox('getValue'),
		UserId: userid,
		FindPatWorkType:PageLogicObj.m_Type.getValue(),
		FindPatNo:$("#i-patno").val(),
		FindBCType: BCType,
		Note: Note,
		XmlData: xmlData,
		FindWard:PageLogicObj.m_ward.getValue(),
		PrevFlag:PrevFlag
	}, false);
	$.messager.popover({msg: '打印/导出成功！',type:'success',timeout: 1000});
	//location.href = rtn;
}

function findConfig (flag) {
	var userid = session['LOGON.USERID'];
	var selfLocFlag = $("#i-selfLoc").hasClass("selected");
	if (selfLocFlag) {
		userid = "";
	}
	var BCType = GetBCType();
	if (BCType == "") {
		$.messager.alert('提示','请选择班次！' , "info");
		return false;
	}
	var PrevFlag = $("#i-prevBC").switchbox("getValue")?0:1;
	LoadData();
	PageLogicObj.m_DurDataGrid.reload({
		ClassName : "web.DHCDocPassWorkE2",
		QueryName : "FindPassWorkPatList",
		LocId: session['LOGON.CTLOCID'],
		FindDate: PageLogicObj.m_SaveDate,	//$("#i-date").datebox('getValue'),
		UserId: userid,
		FindPatWorkType:PageLogicObj.m_Type.getValue(),
		FindPatNo:$("#i-patno").val(),
		FindBCType: BCType,
		FindWard: PageLogicObj.m_ward.getValue(),
		PrevFlag: PrevFlag

	});
}

/**
 * 得到当前的的班次
 */
function GetBCType() {
	var mRtn = ""
	$("#i-bctitle label").each(function (i, obj) {
		var cid = $(this).attr("id");
		if ($(this).hasClass("selected")) {
			mRtn = cid.split("-")[1];
		}
	})

	return mRtn;
}

function SelfPersonFind () {
	$("#i-selfPeron").addClass("selected");
	$("#i-selfLoc").removeClass("selected");
	findConfig();
}

function SelfLocFind () {
	$("#i-selfLoc").addClass("selected");
	$("#i-selfPeron").removeClass("selected");
	findConfig();
}

/**
 * 修改交班信息
 * @param {*} ItemID ：子表ID
 */
function EditDWork (ItemID) {
	opDialog("edit", ItemID);
}

function editPatInfo () {
	var bcType = GetBCType();
	var mainIdStr = "m_" + bcType + "MainId";
	var mainId = PageLogicObj[mainIdStr]||"";
	if (mainId == "") {
		$.messager.alert('提示','请先保存班次信息!',"info");
		return false;
	}
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert('提示','请选择一条记录！' , "info");
		return false;
	}
	
	var BCode = GetBCType()
	var PatientID = selected["PatientID"];
	var EpisodeID = selected["EpisodeID"];
	var PatName = selected["PatName"];
	var BCItemId = selected["BCItemId"];
	var src="dhcdoc.passwork.editpat.hui.csp?EpisodeID="+EpisodeID+"&BCItemId="+BCItemId+"&BCode="+BCode+"&PatName="+PatName+"&PatientID="+PatientID;
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("EditPatInfo","修改类型", 450, 345,"icon-w-edit","",$code,"");
	
}
//加载模板
function LoadTPLURL (BCItemId,TplURL,EpisodeID,PatWorkType) {
	/*var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert('提示','请选择一条记录！' , "info");
		return false;
	}
	var TplURL = selected["TplURL"];*/
	//alert(BCItemId + ": " + TplURL);
	//return;
	//var BCode = GetBCType()
	//var PatientID = selected["PatientID"];
	//var EpisodeID = selected["EpisodeID"];
	//var PatName = selected["PatName"];
	//var BCItemId = selected["BCItemId"];
	
	var TPLInfo = $.m({
			ClassName:"web.DHCDocPassWorkE2",
			MethodName:"GetTPLInfo",
			PatWorkType: PatWorkType
		},false);
	
	if (TPLInfo == "") {
		$.messager.alert('提示','请先配置模板相关参数！' , "info");
		return false;
	}
	var TPLArr = TPLInfo.split(",");
	var tplWidth = TPLArr[0];
	var tplHeight = TPLArr[1];
	var src=TplURL + "?BCItemId="+BCItemId+"&TplURL="+TplURL+"&EpisodeID="+EpisodeID;
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("TPLURL","修改交班内容", tplWidth, tplHeight,"icon-w-edit","",$code,"");
	
}

//加载模板
function ReLoadTPLURL (BCItemId,TplURL,EpisodeID,PatWorkType) {
	/*var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert('提示','请选择一条记录！' , "info");
		return false;
	}
	var TplURL = selected["TplURL"];*/
	//alert(BCItemId + ": " + TplURL);
	//return;
	//var BCode = GetBCType()
	//var PatientID = selected["PatientID"];
	//var EpisodeID = selected["EpisodeID"];
	//var PatName = selected["PatName"];
	//var BCItemId = selected["BCItemId"];
	if (TplURL == "") {
		$.messager.alert('提示','请先配置模板URL！' , "info");
		return false;
	}
	
	var TPLInfo = $.m({
			ClassName:"web.DHCDocPassWorkE2",
			MethodName:"GetTPLInfo",
			PatWorkType: PatWorkType
		},false);
	
	if (TPLInfo == "") {
		$.messager.alert('提示','请先配置模板相关参数！' , "info");
		return false;
	}
	var TPLArr = TPLInfo.split(",");
	var tplWidth = TPLArr[0];
	var tplHeight = TPLArr[1];
	
	var src=TplURL + "?BCItemId="+BCItemId+"&TplURL="+TplURL+"&EpisodeID="+EpisodeID;
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	RecreateModalDialog("TPLURL","修改交班内容", tplWidth, tplHeight,"icon-w-edit","",$code,"");
	
}

/**
 * 上一个和下一个
 * @param {*} action 
 */
function NextOrPrev (action) {	//从0开始
	//var data = PageLogicObj.m_DurDataGrid.getData();
	//var total = data.total;
	var options = PageLogicObj.m_DurDataGrid.getPager().data("pagination").options;
	var pageSize = options.pageSize;
	var pageNumber = options.pageNumber;	//当前页数
	var total = options.total;			//总记录数
	var totalPageNumber = Math.ceil(total/pageSize);	//总页数
	if (pageNumber == totalPageNumber) {
		if ((total%pageSize)!=0) {
			pageSize = total%pageSize;
		}
	}
	//var options = $("#sourceDG" ).datagrid("getPager").data("pagination").options;
	//curr = options.pageNumber;  
	//console.log(curr);
	//size = options.pageSize;
	var selectedOld = PageLogicObj.m_DurDataGrid.getSelected();
	var oldRowIndex = PageLogicObj.m_DurDataGrid.getRowIndex(selectedOld);
	var newIndex = "-1"
	if (action == "next") {
		newIndex = oldRowIndex + 1;
		if (newIndex >= pageSize) {
			$.messager.alert('提示','已是当前最后一行!',"info");
			return false;
		}
	} else {
		newIndex = oldRowIndex - 1
		if (newIndex < 0) {
			$.messager.alert('提示','已是第一行!',"info");
			return false;
		}
	}
	PageLogicObj.m_DurDataGrid.selectRow(newIndex);
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert('提示','已是当前最后一行!',"info");
		return false;
	}
	//var _itemStr = "BCItemId";	//PageLogicObj.m_BCode + "ItemId";
	//opDialog("edit", );
	var TplURL = selected["TplURL"];
	var BCItemId = selected["BCItemId"];
	var EpisodeID = selected["EpisodeID"];
	var PatWorkType = selected["PatWorkType"];
	var rtnOBJ = {
		"BCItemId" :BCItemId,
		"TplURL": TplURL,
		"EpisodeID":EpisodeID,
		"PatWorkType": PatWorkType
	}
	return rtnOBJ;
}

function seeLabDetail(EpisodeID) {
	//epr.newfw.episodelistbrowser.csp
	var lnk= "emr.record.browse.csp?"+"&EpisodeID="+EpisodeID;
	if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
   	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=1000,height=1000');
}

function printPWData() {
	var LocId = session['LOGON.CTLOCID'];
	var FindDate = PageLogicObj.m_SaveDate;
	var UserId = session['LOGON.USERID'];
	var FindPatWorkType = PageLogicObj.m_Type.getValue()||"";
	var FindPatNo = $.trim($("#i-patno").val());
	var selfLocFlag = $("#i-selfLoc").hasClass("selected");
	if (selfLocFlag) {
		UserId = "";
	}
	var BCType = GetBCType();
	if (BCType == "") {
		$.messager.alert('提示','请选择班次！' , "info");
		return false;
	}
	var FindBCType = BCType;
	var FindWard = PageLogicObj.m_ward.getValue()||"";
	var PrevFlag = $("#i-prevBC").switchbox("getValue")?0:1;
	
	var hasSave = $.cm({ 
		ClassName:"web.DHCDocPassWorkF1",
		MethodName:"HasSave", 
		dataType:"text",
		LocId:LocId,
		FindDate:FindDate,
		BCode:FindBCType
	},false);
	
	if (hasSave==0) {
		$.messager.alert('提示','请先保存班次信息！' , "info");
		return false;
	}
	
	var param = "LocId="+LocId+"&FindDate="+FindDate+"&UserId="+UserId+"&FindPatWorkType="+FindPatWorkType;
	param = param +"&FindPatNo="+FindPatNo+"&FindBCType="+FindBCType+"&FindWard="+FindWard+"&PrevFlag="+PrevFlag;
	
	
	//websys_printview("DHCPassWork","isLodop=1&showPrintBtn=1&"+param,"width=830,height=660,top=20,left=100");
	websys_printout("DHCPassWork","isLodop=1&showPrintBtn=1&"+param,"width=830,height=660,top=20,left=100");
	//websys_printout("DHCPassWork",param);
	//websys_printview("DHCPassWork","showPrintBtn=1&EpisodeID="+1+"&Loc="+95+"&BCode=M&PrintDate=2019-06-06","width=830,height=660,top=20,left=100");
	//websys_printout("DHCPassWork","EpisodeID="+1+"&Loc="+95+"&BCode=M&PrintDate=2019-06-06");
	//websys_printout("LodopTest","isLodop=0&EpisodeID="+1+"&loc="+2);
}

function printPWDataOld () {
	var LocId = session['LOGON.CTLOCID'];
		var FindDate = PageLogicObj.m_SaveDate;
		var UserId = session['LOGON.USERID'];
		var FindPatWorkType = PageLogicObj.m_Type.getValue()||"";
		var FindPatNo = $.trim($("#i-patno").val());
		var selfLocFlag = $("#i-selfLoc").hasClass("selected");
		if (selfLocFlag) {
			UserId = "";
		}
		var BCType = GetBCType();
		if (BCType == "") {
			$.messager.alert('提示','请选择班次！' , "info");
			return false;
		}
		var FindBCType = BCType;
		var FindWard = PageLogicObj.m_ward.getValue()||"";
		var PrevFlag = $("#i-prevBC").switchbox("getValue")?0:1;
		
		var param = "LocId="+LocId+"&FindDate="+FindDate+"&UserId="+UserId+"&FindPatWorkType="+FindPatWorkType;
		param = param +"&FindPatNo="+FindPatNo+"&FindBCType="+FindBCType+"&FindWard="+FindWard+"&PrevFlag="+PrevFlag;
		
		/// 加载XML
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCPassWorkNew")
		var LODOP = getLodop();	
		
		inpara = [];
				var arr = [];
				//arr.push({type:"invoice",PrtDevice:"pdfprinter"});
				var cury = 30;
				var content = "    一方面需要通过各种管理手段以及规章制度来保证，另一方面需要结合各种新技术，通过可行的技术途径来整合各种资源，明确将职责落实到具体个人，提高医院对病案质量的管理能力，通过统计、分析、预警、三级质量评定等事前控制手段，能有效的提醒和督促医务人员按时、按质完成病历书写工作。提高病历甲级率，从而提高医院提供综合竞争力。"
				arr.push({type:"text",name:"lbl1",value:"一、提高病历合格率",x:19,y:cury,fontsize:16})
				cury = cury+7;
				var val1 = autoWordEnter(content,46);
				var len = val1.split("\n").length,
				height=len*6;
				arr.push({type:"text",name:"lbl2",value:val1,x:19,y:cury});
				cury = cury+height;
				arr.push({type:"line",sx:19,sy:cury,ex:220,ey:cury++});
				arr.push({type:"text",name:"lbl3",value:"二、节省时间",x:19,y:cury,fontsize:16})
				cury = cury+7;
				content = "    对于医生来说，每天要接治多名患者，日常工作中70%的时间用于手工书写病历。通过电子病历系统提供的多种规范化的模板及辅助工具，不仅可以将医务人员从繁琐重复的病历文书书写工作中解脱出来，集中精力关注病人的诊疗，而且通过模板书写的病历更加完整、规范，同时，还可使医生将更多的时间用于提高自身的业务水平，收治更多的患者，从而可以提高医院的经济效益和医疗水平。"
				var val2 = autoWordEnter(content,46);
				len = val2.split("\n").length;
				height=len*6;
				arr.push({type:"text",name:"lbl4",value:val2,x:19,y:cury});
				cury = cury+height;
				arr.push({type:"line",sx:19,sy:cury,ex:220,ey:cury++});
				cury = cury+2
				arr.push({type:"text",name:"lbl6",value:"打印日期:",x:25,y:cury,fontsize:14});
				arr.push({type:"text",name:"lbl7",value:"2019-03-20",x:50,y:cury,fontsize:14});
				arr.push({type:"text",name:"lbl5",value:"打印人:",x:180,y:cury,fontsize:14});
				arr.push({type:"text",name:"lbl8",value:"张医生",x:200,y:cury,fontsize:14});
				DHC_PrintByLodop(LODOP,inpara,"",arr,"示例二")
		return
		$cm({
			ClassName:"web.DHCDocPassWorkF1",
			MethodName:"GetPWPrintData",
			LocId:LocId,
			FindDate:FindDate,
			FindBCType:FindBCType,
			dataType:"text"
		},function(rtn){
				inpara = rtn;
				$cm({
					ClassName:"web.DHCDocPassWorkF1",
					QueryName:"QryPWList",
					LocId:LocId,
					FindDate:FindDate,
					UserId:UserId,
					FindPatWorkType:FindPatWorkType,
					FindPatNo:FindPatNo,
					FindBCType:FindBCType,
					FindWard:FindWard,
					PrevFlag:PrevFlag,
					page:1,
					rows:99999,
				},function(rs){
					var arr = [];
					var cury = 35;
					for (var j=1; j < rs.total; j++) {
						if (j == 2) {
							break;
						}
						//arr.push({type:"line",sx:19,sy:cury,ex:220,ey:cury++});
						var PatOBJ = rs.rows[j];
						//标题：
						var titleCode = "title" + j ; 
						var title = PatOBJ.seqno + "、" + PatOBJ.PatName + " " + PatOBJ.PatSex + " " + " " + PatOBJ.PatAge + "";
						//基本信息：
						var baseCode = "base" + j ; 
						var baseInfo = "住院号：" + PatOBJ.PatMedicareNo + " 床号：" + PatOBJ.CurBedCode + " 交班本人：" + PatOBJ.BCRemarkUser + " 交班日期：" + PatOBJ.FindDate
						//交班信息
						var contentCode = "content" + j ; 
						var content = "交班信息：" + PatOBJ.BCRemark;
						arr.push({type:"text",name:titleCode,value:title,x:19,y:cury,fontsize:12})	//标题
						cury = cury+7;
						arr.push({type:"text",name:baseCode,value:baseInfo,x:19,y:cury,fontsize:12})	//基本信息
						cury = cury+7;
						var val1 = autoWordEnter(content,46);
						var len = val1.split("\n").length;
						var CH = len * 7;
						alert(len)
						arr.push({type:"text",name:contentCode,value:val1,x:19,y:cury});
						cury = cury + CH;
						
						
					}
					
					DHC_PrintByLodop(LODOP,inpara,"",arr,"交班本");
					
				});
				
		})
		//websys_printview("DHCPassWork","showPrintBtn=1&"+param,"width=830,height=660,top=20,left=100");
		//websys_printout("DHCPassWork",param);
		//websys_printview("DHCPassWork","showPrintBtn=1&EpisodeID="+1+"&Loc="+95+"&BCode=M&PrintDate=2019-06-06","width=830,height=660,top=20,left=100");
		//websys_printout("DHCPassWork","EpisodeID="+1+"&Loc="+95+"&BCode=M&PrintDate=2019-06-06");
		//websys_printout("LodopTest","isLodop=0&EpisodeID="+1+"&loc="+2);
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}

function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("i-patno")>=0){
			var PatNo=$('#i-patno').val();
			//if (PatNo=="") return;
			if ((PatNo.length<10)&&(PatNo!="")) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$('#i-patno').val(PatNo);
			findConfig ();
			return false;
		}
		return true;
	}
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}

function RecreateModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
	if (_width == null)
		_width = 800;
	if (_height == null)
		_height = 500;
	$("#"+id).dialog({
		title: _title,
		width: _width,
		height: _height,
		cache: false,
		iconCls: _icon,
		//href: _url,
		collapsible: false,
		minimizable:false,
		maximizable: false,
		resizable: false,
		modal: true,
		closed: false,
		closable: true,
		content:_content,
		onClose:function(){
			destroyDialog(id);
		}
	});
}

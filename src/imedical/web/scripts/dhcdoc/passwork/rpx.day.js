/**
 * rpx.day.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */

var PageLogicObj = {
	m_Grid:"",
	j_Global:{}
}

$(function(){
	Init();
	InitEvent();
	PageHandle();
})

function Init(){
	GetDefaultValue();
	InitCombox();
	InitGrid();
}
function InitEvent(){
	$("#Reset").click(ResetHandler);
	$("#Find").click(FindHandler);
	//$("#RPX").click(RPXHandler)
}
function PageHandle() {
	FindHandler();
	var borderStyle="1px dashed #ccc";
	if (HISUIStyleCode=="lite") {
		borderStyle="1px dashed #E2E2E2";
	} else {
		borderStyle="1px dashed #ccc";
	}
	setTimeout(function() {
		$("#i-north").css("border-bottom",borderStyle);
	}, 10);
}
function InitCombox() {
	PageLogicObj.m_Loc = $HUI.combobox("#Loc", {
		url:$URL+"?ClassName=DHCDoc.PW.COM.Query&QueryName=QryGetdep&InHosp="+session['LOGON.HOSPID']+"&TypeList=I"+"&ResultSetType=array&InMID="+PageLogicObj.j_Global.DefaultType,
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		mode:'remote',
		onBeforeLoad:function(param){
			param.InDesc = param["q"];
		}
	});
	
	PageLogicObj.m_Hosp = $HUI.combobox("#Hosp", {
		url:$URL+"?ClassName=DHCDoc.PW.COM.Query&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		disabled:true,
		value:session['LOGON.HOSPID'],
		blurValidValue:true,
		onLoadSuccess:function () {
				
		},
		onSelect: function (data) {
			if (!!data) {
				PageLogicObj.m_Loc.clear();
				var url = $URL+"?ClassName=DHCDoc.PW.COM.Query&QueryName=QryGetdep&InHosp="+data.id+"&TypeList=I"+"&ResultSetType=array";
				PageLogicObj.m_Loc.reload(url)
			}
			
		}
	});

	PageLogicObj.m_MType = $HUI.combobox("#MType", {
		url:$URL+"?ClassName=DHCDoc.PW.CFG.BCMain&QueryName=QryHospType&InHosp="+session['LOGON.HOSPID']+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		mode:'remote',
		value:PageLogicObj.j_Global.DefaultType,
		onSelect: function (data) {
			if (!!data) {
				PageLogicObj.m_Loc.clear();
				var url = $URL+"?ClassName=DHCDoc.PW.COM.Query&QueryName=QryGetdep&InHosp="+session['LOGON.HOSPID']+"&TypeList=I"+"&ResultSetType=array&InMID="+data.id;
				PageLogicObj.m_Loc.reload(url)
			}
			
		}
	});


}
function FindHandler() {
	var InLocId = PageLogicObj.m_Loc.getValue()||"",
		InBCDate = $("#BCDate").datebox("getValue")||"",
		InMID = PageLogicObj.m_MType.getValue()||"",
		InHosp=PageLogicObj.m_Hosp.getValue()||"";
	
	if (InHosp=="") {
		$.messager.alert("提示", "院区不能为空！", "info");
		return false;
	}
	if (InMID=="") {
		$.messager.alert("提示", "请选择班次类型！", "info");
		return false;
	}
	if (InBCDate=="") {
		$.messager.alert("提示", "日期不能为空！", "info");
		return false;
	}
	ParaOBJ = {
		InLocId:InLocId,
		InBCDate:InBCDate,
		InHosp:InHosp,
		InMID:InMID
	}
	InitGrid(ParaOBJ);


	/*PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.PW.RPX.NMain",
		QueryName : "DayQry",
		InLocId:InLocId,
		InBCDate:InBCDate,
		InHosp:InHosp,
		InMID:InMID
	})*/
	
}

function RPXHandler () {
	var InLocId = PageLogicObj.m_Loc.getValue()||"",
		InBCDate = $("#BCDate").datebox("getValue")||"",
		InMID = PageLogicObj.m_MType.getValue()||"",
		InHosp=PageLogicObj.m_Hosp.getValue()||"";

	var param = "InLocId="+InLocId+"&InBCDate="+InBCDate+"&InHosp="+InHosp+"&InMID="+InMID+"&IsRpx=1";
	var URL = "dhccpmrunqianreport.csp?reportName=PassWork-Day.rpx&"+param;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-list',
		title:$g('报表预览/导出/打印'),
		width:1000,height:800
	})

}

function ResetHandler () {
	PageLogicObj.m_Loc.clear();
	var URL=$URL+"?ClassName=DHCDoc.PW.COM.Query&QueryName=QryGetdep&InHosp="+session['LOGON.HOSPID']+"&TypeList=I"+"&ResultSetType=array&InMID="+PageLogicObj.j_Global.DefaultType;
	PageLogicObj.m_Loc.reload(URL);
	PageLogicObj.m_Hosp.setValue(session['LOGON.HOSPID'])
	PageLogicObj.m_MType.select(PageLogicObj.j_Global.DefaultType);
	$("#BCDate").datebox("setValue",PageLogicObj.j_Global.DefaultDate);
	FindHandler();
}
function GetDefaultValue () {
	PageLogicObj.j_Global = $cm({
		ClassName: "DHCDoc.PW.RPX.NMain",
		MethodName: "GetPageGloabl",
		InHosp: session['LOGON.HOSPID']
	},false);
	$("#BCDate").datebox("setValue",PageLogicObj.j_Global.DefaultDate);
}

function InitGrid(ParaOBJ){
	ParaOBJ = ParaOBJ||"";
	if (ParaOBJ != "") {
		InLocId = ParaOBJ.InLocId
		InBCDate = ParaOBJ.InBCDate
		InHosp = ParaOBJ.InHosp
		InMID = ParaOBJ.InMID
	} else {
		InLocId = ""
		InBCDate = PageLogicObj.j_Global.DefaultDate
		InHosp = session['LOGON.HOSPID']
		InMID = PageLogicObj.j_Global.DefaultType
	}
	var columnsNew = $cm({
		ClassName:"DHCDoc.PW.RPX.NMain",
		MethodName:"GetDayColumns",
		InMID:InMID
	},false);

	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : false,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		nowrap:false,
		//headerCls:'panel-header-gray',
		pageSize:20,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.PW.RPX.NMain",
			QueryName : "DayQry",
			InLocId:InLocId,
			InBCDate:InBCDate,
			InHosp:InHosp,
			InMID:InMID
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		//frozenColumns:frozenColumns,
		toolbar:[
				{
						text:'报表预览/导出/打印',
						id:'RPX',
						iconCls: 'icon-paper-table',
						handler : function () {
							RPXHandler();
						}
				}
				/*,
				{
						text:'患者费用',
						id:'i-edit',
						iconCls: 'icon-pat-fee-det'
				},{
						text:'化验结果',
						id:'i-delete',
						iconCls: 'icon-write-order'
				},{
						text:'检查结果',
						id:'i-delete',
						iconCls: 'icon-end-adm'
				}*/
					
		],
		columns :[columnsNew]
	});
	
	PageLogicObj.m_Grid = DataGrid;
}

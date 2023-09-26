var SessionObj = {
	GUSERID : curUserID,
	GUSERCODE : curUserCode,
	GUSERNAME : curUserName,
	GGROURPID : session['LOGON.GROUPID'],
	GGROURPDESC : session['LOGON.GROUPDESC'],
	GLOCID : curLocID,
	GHOSPID : session['LOGON.HOSPID'],
	LANGID : session['LOGON.LANGID']
}
var QUERY_URL = {
	QUERY_GRID_URL : "./dhceq.jquery.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhceq.jquery.combo.easyui.csp"
};
var GlobalObj = {
	PlanDR : "",
	SourceTypeDR : "",
	EquipDR : "",
	ModelDR : "",
	MaintUserDR : "",
	MaintLocDR : "",
	MaintTypeDR : "",
	NotSendMessFlagDR : "",
	UseLocDR : "",
	InvalidMsgFlagDR : "",
	ItemDR : "",
	EquipTypeDR : "",
	StatCatDR : "",
	EquipCatDR : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="Plan") {this.PlanDR = "";}
		if (vElementID=="SourceType") {this.SourceTypeDR = "";}
		if (vElementID=="Equip") {this.EquipDR = "";}
		if (vElementID=="Model") {this.ModelDR = "";}
		if (vElementID=="MaintUser") {this.MaintUserDR = "";}
		if (vElementID=="MaintLoc") {this.MaintLocDR = "";}
		if (vElementID=="MaintType") {this.MaintTypeDR = "";}
		if (vElementID=="NotSendMessFlag") {this.NotSendMessFlagDR = "";}
		if (vElementID=="UseLoc") {this.UseLocDR = "";}
		if (vElementID=="InvalidMsgFlag") {this.InvalidMsgFlagDR = "";}
		if (vElementID=="Item") {this.ItemDR = "";}
		if (vElementID=="EquipType") {this.EquipTypeDR = "";}
		if (vElementID=="StatCat") {this.StatCatDR = "";}
		if (vElementID=="EquipCat") {this.EquipCatDR = "";}
	},
	ClearAll : function()
	{
		this.PlanDR = "";
		this.SourceTypeDR = "";
		this.EquipDR = "";
		this.ModelDR = "";
		this.MaintUserDR = "";
		this.MaintLocDR = "";
		this.MaintTypeDR = "";
		this.NotSendMessFlagDR = "";
		this.UseLocDR = "";
		this.InvalidMsgFlagDR = "";
		this.ItemDR = "";
		this.EquipTypeDR = "";
		this.StatCatDR = "";
		this.EquipCatDR = "";
	}
}

function log(val)
{
	//console.log(val);
}
//�������
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);

function initDocument()
{
	//GlobalObj.ClearAll();
	initPanel();
}


function initPanel()
{
	initTopPanel();
	initTopData();				//����������ݳ�ʼ����
}

//��ʼ����ѯͷ���
function initTopPanel()
{
	jQuery("#BFind").linkbutton({iconCls: 'icon-search'});
	jQuery("#BFind").on("click", BFind_Clicked);
	jQuery("#BPrint").linkbutton({iconCls: 'icon-print'});
	jQuery("#BPrint").on("click", BPrint_Clicked);
	//��ֵԪ�ض���onchange�¼�,��У����Ч��
	initNumElement("FromYear^ToYear");
	initPlanPanel();			//�ƻ�
	initEquipPanel();			//�豸
	initModelPanel();			//�ͺ�
	initMaintTypePanel();		//ά������
	initMaintUserPanel();		//ά����
	initMaintLocPanel();		//ά������
	initUseLocPanel();			//����
	initItemPanel();			//�豸��
	initEquipTypePanel();		//�豸����
	initStatCatPanel();			//�豸����
	initEquipCatPanel();		//�豸����
}
function initSourceTypeData()
{
	if (jQuery("#SourceType").prop("type")!="hidden")
	{
		jQuery("#SourceType").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '11',
				text: '��������'
			},{
				id: '21',
				text: '���'
			},{
				id: '22',
				text: 'ת��'
			},{
				id: '23',
				text: '����'
			},{
				id: '31',
				text: 'ά��'
			},{
				id: '34',
				text: '����'
			},{
				id: '64',
				text: '����'
			}],
			onSelect: function() {GlobalObj.SourceTypeDR=jQuery("#SourceType").combobox("getValue");}
		});
	}
}
function initInvalidMsgFlagData()
{
	if (jQuery("#InvalidMsgFlag").prop("type")!="hidden")
	{
		jQuery("#InvalidMsgFlag").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: 'All'
			},{
				id: 'Y',
				text: 'Yes'
			},{
				id: 'N',
				text: 'No'
			}],
			onSelect: function() {GlobalObj.InvalidMsgFlagDR=jQuery("#InvalidMsgFlag").combobox("getValue");}
		});
	}
}
function initNotSendMessFlagData()
{
	if (jQuery("#NotSendMessFlag").prop("type")!="hidden")
	{
		jQuery("#NotSendMessFlag").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: 'ȫ��'
			},{
				id: 'N',
				text: '�ѽ�����Ϣ'
			},{
				id: 'Y',
				text: 'δ������Ϣ'
			}],
			onSelect: function() {GlobalObj.NotSendMessFlagDR=jQuery("#NotSendMessFlag").combobox("getValue");}
		});
	}
}

function initTopData()
{
	/*
	initPlanData();				//�ƻ�
	initEquipData();			//�豸
	initModelData();			//�ͺ�
	initMaintTypeData();		//ά������
	initMaintUserData();		//ά����
	initMaintLocData();			//ά������
	initUseLocData();			//����
	initItemData();				//�豸��
	initEquipTypeData();		//�豸����
	initStatCatData();			//�豸����
	initEquipCatData();			//�豸����
	*/
	initSourceTypeData();		//ҵ������
	initNotSendMessFlagData();			//δ���ձ�־
	initInvalidMsgFlagData();		//�쳣��Ϣ
}
/**********************************************��������******************************************/
//����Ĭ�Ͻ���
function setFocus(id)
{
	if(jQuery("#" + id).length)
	{
		jQuery("#" + id).focus();
	}
}

/***����DataGrid����*/
function loadDataGridStore(DataGridID, queryParams)
{
	window.setTimeout(function()
	{
		var jQueryGridObj = jQuery("#" + DataGridID);
		jQuery.extend(jQueryGridObj.datagrid("options"),{
			url : QUERY_URL.QUERY_GRID_URL,
			queryParams : queryParams
		});
		jQueryGridObj.datagrid("load");
	},0);
}

/***����ComboGrid����*/
function loadComboGridStore(ComboGridID, queryParams)
{
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// ��ȡ���ݱ�����
	var opts = grid.datagrid("options");
	opts.url = QUERY_URL.QUERY_GRID_URL;
	grid.datagrid('load', queryParams);
}
function initComboGrid(vElementID,vElementName,vWidth,vEditFlag)
{
	if (jQuery("#"+vElementID).prop("type")!="hidden")		//��ʾԪ�ؼ���
	{
		jQuery("#"+vElementID).combogrid({
			fit:true,
			panelWidth:vWidth,
			border:false,
			checkOnSelect: false, 
			selectOnCheck: false,
			striped: true,
			singleSelect : true,
			url: null,
			fitColumns:false,
			autoRowHeight:false,
			cache: false,
			editable: vEditFlag,
			loadMsg:'���ݼ����С���', 
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		    idField: 'TRowID',    
		    textField: 'TName',
		    pagination:true,
		    pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
		    columns:[[
		        {field:'TName',title:vElementName,width:350},
		        {field:'TRowID',title:'ID',width:30,hidden:true},
		        ]],
		    onLoadSuccess:function(data) {},
		    onLoadError:function() {jQuery.messager.messageShow("","","",vElementName, "����"+vElementName+"�б�ʧ��!");},
			onChange:function(newValue, oldValue){GlobalObj.ClearData(vElementID);},
		    onSelect: function(rowIndex, rowData) {SetValue(vElementID);},
		    keyHandler:{
			    query:function(){},
			    enter:function(){ComboGridKeyEnter(vElementID);},
			    up:function(){ComboGridKeyUp(vElementID);},
			    down:function(){ComboGridKeyDown(vElementID);},
			    left:function(){},
			    right:function(){}
			    }
		});
		jQuery("#TD"+vElementID).focusin(function(){LoadData(vElementID)});
	}
}
function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if (vElementID=="Plan") {initPlanData();}
	if (vElementID=="Equip") {initEquipData();}
	if (vElementID=="Model") {initModelData();}
	if (vElementID=="MaintType") {initMaintTypeData();}
	if (vElementID=="MaintUser") {initMaintUserData();}
	if (vElementID=="MaintLoc") {initMaintLocData();}
	if (vElementID=="UseLoc") {initUseLocData();}
	if (vElementID=="Item") {initItemData();}
	if (vElementID=="EquipType") {initEquipTypeData();}
	if (vElementID=="StatCat") {initStatCatData();}
	if (vElementID=="EquipCat") {initEquipCatData();}
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="Plan") {GlobalObj.PlanDR = CurValue;}
	if (vElementID=="Equip") {GlobalObj.EquipDR = CurValue;}
	if (vElementID=="Model") {GlobalObj.ModelDR = CurValue;}
	if (vElementID=="MaintType") {GlobalObj.MaintTypeDR = CurValue;}
	if (vElementID=="MaintUser") {GlobalObj.MaintUserDR = CurValue;}
	if (vElementID=="MaintLoc") {GlobalObj.MaintLocDR = CurValue;}
	if (vElementID=="UseLoc") {GlobalObj.UseLocDR = CurValue;}
	if (vElementID=="Item") {GlobalObj.ItemDR = CurValue;}
	if (vElementID=="EquipType") {GlobalObj.EquipTypeDR = CurValue;}
	if (vElementID=="StatCat") {GlobalObj.StatCatDR = CurValue;}
	if (vElementID=="EquipCat") {GlobalObj.EquipCatDR = CurValue;}
	
}
//��ʼ���Ŵ�����
function initComboData(vElementID,vClassName,vQueryName,vQueryParams,vQueryParamsNum)
{
	if (jQuery("#"+vElementID).prop("type")!="hidden")		//��ʾԪ�ؼ���
	{
		var queryParams = new Object();
		var ParamsInfo=vQueryParams.split(",")
		queryParams.ClassName = vClassName;
		queryParams.QueryName = vQueryName;
		for(var i=1; i<=vQueryParamsNum; i++)
		{
			if (i==1) {queryParams.Arg1 = ParamsInfo[0];}
			if (i==2) {queryParams.Arg2 = ParamsInfo[1];}
			if (i==3) {queryParams.Arg3 = ParamsInfo[2];}
			if (i==4) {queryParams.Arg4 = ParamsInfo[3];}
			if (i==5) {queryParams.Arg5 = ParamsInfo[4];}
			if (i==6) {queryParams.Arg6 = ParamsInfo[5];}
			if (i==7) {queryParams.Arg7 = ParamsInfo[6];}
			if (i==8) {queryParams.Arg8 = ParamsInfo[7];}
			if (i==9) {queryParams.Arg9 = ParamsInfo[8];}
			if (i==10) {queryParams.Arg10 = ParamsInfo[9];}
			if (i==11) {queryParams.Arg11 = ParamsInfo[10];}
			if (i==12) {queryParams.Arg12 = ParamsInfo[11];}
			if (i==13) {queryParams.Arg13 = ParamsInfo[12];}
			if (i==14) {queryParams.Arg14 = ParamsInfo[13];}
			if (i==15) {queryParams.Arg15 = ParamsInfo[14];}
			if (i==16) {queryParams.Arg16 = ParamsInfo[15];}
		}
		queryParams.ArgCnt = vQueryParamsNum;
		loadComboGridStore(vElementID, queryParams);
	}
}
function initNumElement(vElements)
{
	var ElementInfo=vElements.split("^");
	for(var i=1; i<=ElementInfo.length; i++)
	{
		var CurElement=ElementInfo[i-1]
		if (jQuery("#"+CurElement).prop("type")!="hidden")
		{
			jQuery("#"+CurElement).change(function(){NumChange(CurElement)});

		}
	}
}
function NumChange(vElementID)
{
	var ElementValue=jQuery("#"+vElementID).val();
	if ((ElementValue!="")&&(isNaN(ElementValue)))
	{
		alertShow("����ȷ������ֵ!")
		return
	}
}
function GetComboGridDesc(vElements,vElements2)
{
	var ReturnStr=""
	if (vElements!="")
	{
		var ElementsInfo=vElements.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var vElementID=ElementsInfo[i-1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vElementID+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	if (vElements2!="")
	{
		var ElementsInfo=vElements2.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var CurElement=ElementsInfo[i-1]
			var CurElementInfo=CurElement.split("=");
			var vParamName=CurElementInfo[0];
			var vElementID=CurElementInfo[1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vParamName+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	return ReturnStr
}
/*****************************************��ʼ���Ŵ�******************************************/
function initPlanPanel()
{
	initComboGrid("Plan","ά���ƻ�",400,true);
}
function initPlanData()
{
	var vParams=GlobalObj.SourceTypeDR+","+jQuery("#Plan").combogrid("getText")+","+GlobalObj.EquipDR+","+GlobalObj.MaintLocDR+","+jQuery("#QXType").val();
	initComboData("Plan","web.DHCEQ.Process.DHCEQFind","GetPlanName",vParams,5)
}
function initMaintTypePanel()
{
	initComboGrid("MaintType","ά������",400,true);
}
function initMaintTypeData()
{
	var vParams=jQuery("#MaintType").combogrid("getText")+","+GlobalObj.SourceTypeDR
	initComboData("MaintType","web.DHCEQ.Process.DHCEQFind","MaintTypeLookUp",vParams,2)
}
function initMaintLocPanel()
{
	initComboGrid("MaintLoc","ά������",400,true);
}
function initMaintLocData()
{
	var vParams=","+jQuery("#MaintLoc").combogrid("getText")+",,0102,"
	initComboData("MaintLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}
function initEquipPanel()
{
	var vElementID="Equip"
	var vElementName="�豸����"
	var vWidth=450
	var vEditFlag=true
	if (jQuery("#"+vElementID).prop("type")!="hidden")		//��ʾԪ�ؼ���
	{
		jQuery("#"+vElementID).combogrid({
			panelWidth:vWidth,
			border:false,
			checkOnSelect: false, 
			selectOnCheck: false,
			striped: true,
			singleSelect : true,
			url: null,
			fitColumns:false,
			autoRowHeight:false,
			cache: false,
			editable: vEditFlag,
			loadMsg:'���ݼ����С���', 
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		    idField: 'TRowID',    
		    textField: 'TName',
		    pagination:true,
		    pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
		    columns:[[
		        {field:'TName',title:vElementName,width:250},
		        {field:'TRowID',title:'ID',width:30,hidden:true},
		        {field:'TNo',title:'�豸���',width:30,width:150},
		        ]],
		    onLoadSuccess:function(data) {},
		    onLoadError:function() {jQuery.messager.messageShow("","","",vElementName, "����"+vElementName+"�б�ʧ��!");},
			onChange: function(newValue, oldValue){GlobalObj.ClearData(vElementID);},
			onSelect: function(rowIndex, rowData) {SetValue(vElementID);},
		    keyHandler:{
			    query:function(){},
			    enter:function(){ComboGridKeyEnter(vElementID);},
			    up:function(){ComboGridKeyUp(vElementID);},
			    down:function(){ComboGridKeyDown(vElementID);},
			    left:function(){},
			    right:function(){}
			    }
		});
		jQuery("#TD"+vElementID).focusin(function(){LoadData(vElementID)});
	}
}
function initEquipData()
{
	var vParams=jQuery("#Equip").combogrid("getText")+",,,,,"
	initComboData("Equip","web.DHCEQ.Process.DHCEQFind","GetShortEquip",vParams,6)
}
function initUseLocPanel()
{
	initComboGrid("UseLoc","��������",400,true);
}
function initUseLocData()
{
	var vParams=","+jQuery("#UseLoc").combogrid("getText")+",,0102,"
	initComboData("UseLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}

function initMaintUserPanel()
{
	initComboGrid("MaintUser","ά����",400,true);
}
function initMaintUserData()
{
	var vParams=jQuery("#MaintUser").combogrid("getText")
	initComboData("MaintUser","web.DHCEQ.Process.DHCEQFind","User",vParams,1)
}
function initModelPanel()
{
	initComboGrid("Model","����ͺ�",400,true);
}
function initModelData()
{
	var vParams=GlobalObj.ItemDR+","+jQuery("#Model").combogrid("getText")
	initComboData("Model","web.DHCEQ.Process.DHCEQFind","GetModel",vParams,2)
}
function initItemPanel()
{
	initComboGrid("Item","�豸��",400,true);
}
function initItemData()
{
	var vParams=GlobalObj.EquipTypeDR+","+GlobalObj.StatCatDR+","+jQuery("#Item").combogrid("getText")+","
	initComboData("Item","web.DHCEQ.Process.DHCEQFind","GetMasterItem",vParams,4)
}
function initEquipTypePanel()
{
	initComboGrid("EquipType","�豸����",400,true);
}
function initEquipTypeData()
{
	var vParams=jQuery("#EquipType").combogrid("getText")
	initComboData("EquipType","web.DHCEQ.Process.DHCEQFind","GetEquipType",vParams,1)
}
function initStatCatPanel()
{
	initComboGrid("StatCat","�豸����",400,true);
}
function initStatCatData()
{
	var vParams=jQuery("#StatCat").combogrid("getText")+GlobalObj.EquipTypeDR
	initComboData("StatCat","web.DHCEQ.Process.DHCEQFind","StatCatLookUp",vParams,2)
}
function initEquipCatPanel()
{
	initComboGrid("EquipCat","�豸����",400,true);
}
function initEquipCatData()
{
	var vParams=jQuery("#EquipCat").combogrid("getText")
	initComboData("EquipCat","web.DHCEQ.Process.DHCEQFind","EquipCatLookUp",vParams,1)
}
/***************************************�Ŵ󾵻س��¼���������*******************************************/
function ComboGridKeyUp(vElementID)
{
    var pClosed = jQuery("#"+vElementID).combogrid("panel").panel("options").closed;
    if (pClosed) {jQuery("#"+vElementID).combogrid("showPanel");}
    var grid = jQuery("#"+vElementID).combogrid("grid");
    var rowSelected = grid.datagrid("getSelected");
    if (rowSelected != null)
    {
        var rowIndex = grid.datagrid("getRowIndex", rowSelected);
        if (rowIndex > 0)
        {
            rowIndex = rowIndex - 1;
            grid.datagrid("selectRow", rowIndex);
        }
    }
    else if (grid.datagrid("getRows").length > 0)
    {
        grid.datagrid("selectRow", 0);
    }
}
function ComboGridKeyDown(vElementID)
{
    var pClosed = jQuery("#"+vElementID).combogrid("panel").panel("options").closed;
    if (pClosed) {jQuery("#"+vElementID).combogrid("showPanel");}
    var grid = jQuery("#"+vElementID).combogrid("grid");
    var rowSelected = grid.datagrid("getSelected");
    if (rowSelected != null)
    {
        var totalRow = grid.datagrid("getRows").length;
        var rowIndex = grid.datagrid("getRowIndex", rowSelected);
        if (rowIndex < totalRow - 1)
        {
            rowIndex = rowIndex + 1;
            grid.datagrid("selectRow", rowIndex);
        }
    }
    else if (grid.datagrid("getRows").length > 0)
    {
        grid.datagrid("selectRow", 0);
    }
}
function ComboGridKeyEnter(vElementID)
{
    var grid = jQuery("#"+vElementID).combogrid("grid");
    var rowSelected = grid.datagrid("getSelected");
    var SelectTxt=""
    if (rowSelected!=null)
    {
	    SelectTxt=rowSelected[grid.datagrid('options').textField]
    }
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if ((rowSelected!=null)&&(SelectTxt==ElementTxt))
	{
		var pClosed = jQuery("#"+vElementID).combogrid("panel").panel("options").closed;
		if (!pClosed){jQuery("#"+vElementID).combogrid("hidePanel");}
	}
	else
	{
		GlobalObj.ClearData(vElementID);
	    LoadData(vElementID);
	}
}
/***************************************��ť���ú���*****************************************************/
function BPrint_Clicked()
{
	document.getElementById('ReportFilePrint').contentWindow.document.frames["RunQianReport"].report1_print()
}
function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&vBussTypeDR="+GlobalObj.SourceTypeDR;
	lnk=lnk+"&vStartDate="+GetJQueryDate('#StartDate');
	lnk=lnk+"&vEndDate="+GetJQueryDate('#EndDate');
	lnk=lnk+"&vNotSendMessFlag="+GlobalObj.NotSendMessFlagDR;
	lnk=lnk+"&InvalidMsgFlag="+GlobalObj.InvalidMsgFlagDR;
	lnk=lnk+"&vBussNo="+jQuery("#BussNo").val();
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}

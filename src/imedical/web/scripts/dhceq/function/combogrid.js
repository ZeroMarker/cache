//Create By DJ 20160126 combogrid�ؼ��¼�����
//====================================================================
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
/***����ComboGrid���***/
function initComboGrid(vElementID,vElementName,vWidth,vEditFlag)
{
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
		        {field:'TName',title:vElementName,width:350},
		        {field:'TRowID',title:'ID',width:30,hidden:true},
		        {field:'TCode',title:"����",width:100},
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
//��ʼ��Combogrid����
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
//ComboGridKeyUp�¼�����
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
//ComboGridKeyDown�¼�����
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
//ComboGridKeyEnter�¼�����
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
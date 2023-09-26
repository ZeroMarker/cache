/* 
 * FileName:	dhcbillmenu.taritemupbaseinfo.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	收费项目基础信息修改日志
 * Description: 
*/
var path="";

var PUBLIC_CONSTANTUBI={
	SESSION:{
		GROUP_ROWID : session['LOGON.GROUPID'],
        GROUP_DESC : session['LOGON.GROUPDESC'],
        GUSER_ROWID : session['LOGON.USERID'],
        GUSER_NAME : session['LOGON.USERNAME'],
        GUSER_CODE : session['LOGON.USERCODE'],
		HOSPID : session['LOGON.HOSPID']
	},
	URL:{
		QUERY_GRID_URL : "./dhcbill.query.grid.easyuiorder.csp",
		QUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp",
		METHOD_URL : "./dhc.method.easyui.csp"
	},
	CATE:{
		TARCATE : "",
		TARSUBCATE : "",
		SUBCATEINDEX : "",
		ARCNUM : 9,	//query input num
		TABLE : ""
	},
	METHOD:{
		CLS : "DHCBILLConfig.DHCBILLFIND",
		QUERY : "FindUpBaseInfo"
	}
};

$(function(){
	initGrid();
	//initLoadGrid("")
});

function initGrid(){
	// 初始化Columns
	var CateColumns = [[
		{ field: 'TTarRowid', title: 'TarRowid', width: 50, align: 'left', sortable: true, resizable: true, hidden: true },
		{ field: 'TUBIRowid', title: 'UBIRowid', width: 50, align: 'left', sortable: true, resizable: true, hidden: true },
		{ field: 'TTarDesc', title: '最新项目名称', width: 250, align: 'left', sortable: true, resizable: true },
		{ field: 'TUBIAvailDate', title: '生效日期', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TUBIAvailTime', title: '生效时间', width: 80, align: 'right', sortable: true, resizable: true },
		{ field: 'TUBIExpirationDate', title: '失效日期', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TUBIExpirationTime', title: '失效时间', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TUBIUpdDate', title: '修改日期', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TUBIUpdTime', title: '修改时间', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TUBIUpdUser', title: '修改人', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TUBIUpdHospDesc', title: '医院名称', width: 150, align: 'center', sortable: true, resizable: true }
	]];
	
	// 初始化DataGrid
	$('#tTarUBIDetail').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : '',
		loadMsg : '加载中,请稍后...',  
		pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		pageList : [15,50,100,200],
		columns : CateColumns,
		toolbar : '#tUBIToolBar',
		onSelect : function(rowIndex, rowData) {
		},
		onDblClickRow : function(rowIndex, rowData){
			$('#tTarUBIDetail').datagrid('selectRow',rowIndex);
			var selected=$("#tTarUBIDetail").datagrid('getRows'); //获取所有行集合对象
			UBIRowid=selected[rowIndex].TUBIRowid;
			OpenUBDWinView();
		},
		onLoadSuccess:function(data){  
		}
	});
}

function initLoadGrid(ExpStr)
{
	var SearchAlias="",SearchCode="",SearchDesc="";
	var SearchAvailDate="",SearchExpirationDate="",SearchUpdDate="";
	var SearchTarRowid="";
	if (ExpStr!="") {
		SearchAlias=ExpStr.split("###")[0];
		SearchCode=ExpStr.split("###")[1];
		SearchDesc=ExpStr.split("###")[2];
		SearchAvailDate=ExpStr.split("###")[3];
		SearchExpirationDate=ExpStr.split("###")[4];
		SearchUpdDate=ExpStr.split("###")[5];
	}
	var ubiqueryParams = new Object();
	ubiqueryParams.ClassName = PUBLIC_CONSTANTUBI.METHOD.CLS;
	ubiqueryParams.QueryName = PUBLIC_CONSTANTUBI.METHOD.QUERY;
	ubiqueryParams.Arg1 = SearchAlias;
	ubiqueryParams.Arg2 = SearchCode;
	ubiqueryParams.Arg3 = SearchDesc;
	ubiqueryParams.Arg4 = SearchAvailDate;
	ubiqueryParams.Arg5 = SearchExpirationDate;
	ubiqueryParams.Arg6 = SearchUpdDate;
	ubiqueryParams.Arg7 = SearchTarRowid;
	ubiqueryParams.Arg8 = PUBLIC_CONSTANTUBI.SESSION.HOSPID;
	ubiqueryParams.Arg9 = PUBLIC_CONSTANTUBI.SESSION.GUSER_ROWID;
	ubiqueryParams.ArgCnt = PUBLIC_CONSTANTUBI.CATE.ARCNUM;
	loadDataGridStore("tTarUBIDetail", ubiqueryParams);
}

///加载DataGrid数据
function loadDataGridStore(DataGridID, ubiqueryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = PUBLIC_CONSTANTUBI.URL.QUERY_GRID_URL;
	jQueryGridObj.datagrid('load', ubiqueryParams);
}

$('#UBIBtnClear').bind('click', function(){
	location.reload();
});

$('#UBIBtnFind').bind('click', function(){
	UBIFindClick();
});

function Grid(objSheet,xlsTop,xlsLeft,hrow,lrow)
{   
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(1).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(2).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(3).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(4).LineStyle=1 ;
}

function OpenUBDWinView()
{
	//var winWidth=1090;
	var winWidth=590;
	var winHeight=590;
	$('#wintTarUBDDetail').window({
		title:"收费项目基础信息修改日志明细",
		width:winWidth,
		height:winHeight,
		top:5,
		modal:true,
		resizable:false,
		minimizable:false,
		maximizable:false
	});
	//$('#wintTarUBDDetail').window('open');
	$('#wintTarUBDDetail').window('refresh', 'dhcbillmenu.taritemupbasedetail.csp');
}
function UBIFindClick()
{
	var TxtCode=$('#UBITxtCode').val();
	var TxtDesc=$('#UBITxtDesc').val();
	var TxtAlias=$('#UBITxtAlias').val();
	var TxtAvailDateS="",TxtAvailDateE="",TxtExpirationDateS="",TxtExpirationDateE="";
	if($('#TxtAvailDateS')) {TxtAvailDateS=$('#TxtAvailDateS').datebox('getValue');}
	if($('#TxtAvailDateE')) {TxtAvailDateE=$('#TxtAvailDateE').datebox('getValue');}
	if($('#TxtExpirationDateS')) {TxtExpirationDateS=$('#TxtExpirationDateS').datebox('getValue');}
	if($('#TxtExpirationDateE')) {TxtExpirationDateE=$('#TxtExpirationDateE').datebox('getValue');}
	var TxtUpdDateS=$('#TxtUpdDateS').datebox('getValue');
	var TxtUpdDateE=$('#TxtUpdDateE').datebox('getValue');
	var TxtAvailDate=TxtAvailDateS+"^"+TxtAvailDateE;
	var TxtExpirationDate=TxtExpirationDateS+"^"+TxtExpirationDateE;
	var TxtUpdDate=TxtUpdDateS+"^"+TxtUpdDateE;

	var TarStr=TxtAlias+"###"+TxtCode+"###"+TxtDesc+"###"+TxtAvailDate+"###"+TxtExpirationDate+"###"+TxtUpdDate;
	initLoadGrid(TarStr);
}


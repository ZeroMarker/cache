/* 
 * FileName:	dhcbillmenu.taritem.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	收费项目
 * Description: 
*/
var path="";

var PUBLIC_CONSTANT={
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
		ARCNUM : 6,	//query input num
		TABLE : ""
	},
	METHOD:{
		CLS : "DHCBILLConfig.DHCBILLFIND",
		QUERY : "FindTarItem",
		INSERT : "Insert",
		UPDATE : "Update",
		DELETE : "Delete"
	}
};

$(function(){
	initGrid();
	//initLoadGrid("")
	if(BDPAutDisableFlag('BtnAdd')){
		$('#BtnAdd').hide();
	}
	if(BDPAutDisableFlag('BtnExport')){
		$('#BtnExport').hide();
	}
	if(BDPAutDisableFlag('BtnDetails')){
		$('#BtnDetails').hide();
	}
	if(BDPAutDisableFlag('BtnAliass')){
		$('#BtnAliass').hide();
	}
	BodyKeyDownInit();
	document.onkeydown = document_OnKeyDown;
});

function initGrid(){
	// 初始化Columns
	var FrozenCateColumns = [[
		{ field: 'code', title: '项目代码', width: 100, align: 'left', sortable: true, resizable: true },
		{ field: 'desc', title: '项目名称', width: 250, align: 'left', sortable: true, resizable: true }
	]];
	var CateColumns = [[
		//{ field: 'code', title: '项目代码', width: 100, align: 'left', sortable: true, resizable: true },
		//{ field: 'desc', title: '项目名称', width: 250, align: 'left', sortable: true, resizable: true },
		{ field: 'TarUomDesc', title: '单位', width: 50, align: 'center', sortable: true, resizable: true },
		{ field: 'TarPrice', title: '单价', width: 80, align: 'right', sortable: true, resizable: true },
		{ field: 'TarActiveFlag', title: '有效标志', width: 50, align: 'center', sortable: true, resizable: true },
		{ field: 'TarSubCateDesc', title: '收费项目子类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TarAcctCateDesc', title: '收费会计子类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TarInpatCateDesc', title: '住院费用子类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TarOutpatCateDesc', title: '门诊费用子类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TarEMCCateDesc', title: '经济核算子类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TarMRCateDesc', title: '旧病案首页子类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TarNewMRCateDesc', title: '新病案首页子类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TarSpecialFlag', title: '特殊项目代码', width: 50, align: 'center', sortable: true, resizable: true },
		{ field: 'TarExternalCode', title: '外部代码', width: 100, align: 'left', sortable: true, resizable: true },
		{ field: 'TarChargeBasis', title: '收费依据', width: 100, align: 'left', sortable: true, resizable: true },
		{ field: 'TarInsuIPName', title: '住院生育保险类型', width: 100, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'TarInsuOPName', title: '门诊生育保险类型', width: 100, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'TarEngName', title: '收费说明', width: 100, align: 'left', sortable: true, resizable: true },
		{ field: 'TCreateUser', title: '创建人', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TCreateDate', title: '创建日期', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TCreateTime', title: '创建时间', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TInsuFL', title: '医保分类', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'rowid', title: '表ID', width: 50, align: 'center', sortable: true, resizable: true },
		{ field: 'SubCate', title: 'SubCate', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'AccCate', title: 'AccCate', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'IcCate', title: 'IcCate', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'OcCate', title: 'OcCate', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'EcCate', title: 'EcCate', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'MrCate', title: 'MrCate', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'NewMrCate', title: 'NewMrCate', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'Tjob', title: 'Tjob', align: 'center', sortable: true, resizable: true, hidden: true }
	]];
	
	// 初始化DataGrid
	$('#tTarCate').datagrid({  
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
		frozenColumns : FrozenCateColumns,
		columns : CateColumns,
		toolbar : '#tToolBar',
		onRowContextMenu : function(e, rowIndex, rowData) {
			e.preventDefault();
			$('#tTarCate').datagrid('selectRow',rowIndex);
			var selected=$("#tTarCate").datagrid('getRows'); //获取所有行集合对象
			selected[rowIndex].rowid;
			$('#winmenu').menu('show', {
				left:e.pageX,
				top:e.pageY
			}); 
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		}
	});
}

function initLoadGrid(ExpStr)
{
	var SearchCode="",SearchDesc="",SearchAlias="",SearchStr="";
	if(ExpStr != ""){
		SearchCode = ExpStr.split("###")[0];
		SearchDesc = ExpStr.split("###")[1];
		SearchAlias = ExpStr.split("###")[2];
		SearchStr = ExpStr.split("###")[3];
	}
	var queryParams = new Object();
	queryParams.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
	queryParams.QueryName = PUBLIC_CONSTANT.METHOD.QUERY;
	queryParams.Arg1 = SearchCode;	//项目代码
	queryParams.Arg2 = SearchDesc;	//项目名称
	queryParams.Arg3 = SearchAlias;	//项目别名
	queryParams.Arg4 = SearchStr;	//查询串
	queryParams.Arg5 = PUBLIC_CONSTANT.SESSION.HOSPID;	//医院
	queryParams.Arg6 = PUBLIC_CONSTANT.SESSION.GUSER_ROWID;	//用户
	queryParams.ArgCnt = PUBLIC_CONSTANT.CATE.ARCNUM;
	loadDataGridStore("tTarCate", queryParams);
}

///加载DataGrid数据
function loadDataGridStore(DataGridID, queryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	jQueryGridObj.datagrid('load', queryParams);
}

$('#BtnAdd').bind('click', function(){
	var winWidth=1090;
	var winHeight=590;
	$('#wintar').window({
		title:"收费项目信息",
		width:winWidth,
		height:winHeight,
		top:5,
		center:true,
		modal:true,
		resizable:false,
		minimizable:false,
		maximizable:false,
		collapsible:false
	});
	$('#tTarCate').datagrid('selectRow','');
	$('#wintar').window('refresh', 'dhcbillmenu.taritemdetail.csp');
});

$('#BtnExport').bind('click', function(){
	EportTar();
});

$('#BtnClear').bind('click', function(){
	location.reload();
});

$('#BtnFind').bind('click', function(){
	FindClick();
});

///导出收费项
function EportTar(){
 	if (!!window.ActiveXObject || "ActiveXObject" in window){
	}else{
 		alert("此导出只支持IE浏览器!");
		return;
	}
 	var job="";
	var rows = $('#tTarCate').datagrid('getRows').length;
	if(rows!=""){
		$('#tTarCate').datagrid('selectRow',0);
		var selected = $('#tTarCate').datagrid('getSelected');
		job = selected.Tjob
	}
	if(job == ""){$.messager.alert('消息',"获取导出数据失败!");return;}
	//获取模板路径
	var path=tkMakeServerCall("DHCBILLConfig.DHCBILLFIND","GetPath");
	if(path==""){$.messager.alert('消息',"获取模板路径失败!");return;}
	var datanum=tkMakeServerCall("DHCBILLConfig.DHCBILLFIND","GetTarNum",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job)
	if((datanum=="") || (datanum==0)){$.messager.alert('消息',"没有需要导出的收费项!");return;}
	var datanum=eval(datanum)
	var Template=path+"ExportTar.xls"
	var xlApp = new ActiveXObject("Excel.Application");//不支持Google浏览器，只支持IE
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet
	xlApp.Visible=true;
	for ( i=1 ; i <= datanum ; i++){
		var value=tkMakeServerCall("DHCBILLConfig.DHCBILLFIND","GetTarData",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job,i)
		var ValueStr=value.split("^");
		var Vlen=ValueStr.length;
		for(j = 0; j < Vlen; j++){
			xlsheet.cells(i+1,j+1).value=ValueStr[j];
		}
	}
	Grid(xlsheet,1,1,datanum,Vlen)
	//xlsheet.PrintPreview();
	xlBook.Close (savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlBook=null;
	xlsheet=null;
}

///导出收费项	服务器端导出，模拟标签下载
function EportTarNew(){
	var job="";
	var rows = $('#tTarCate').datagrid('getRows').length;
	if(rows!=""){
		$('#tTarCate').datagrid('selectRow',0);
		var selected = $('#tTarCate').datagrid('getSelected');
		job = selected.Tjob
	}
	if(job == ""){$.messager.alert('消息',"获取导出数据失败!");return;}
	var datanum=tkMakeServerCall("DHCBILLConfig.DHCBILLFIND","GetTarNum",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job)
	if((datanum=="") || (datanum==0)){$.messager.alert('消息',"没有需要导出的收费项!");return;}
	var datanum=eval(datanum);
	var fileName="ExportTar.xls";
	var allStr="";
	for ( i=1 ; i <= datanum ; i++){
		var value=tkMakeServerCall("DHCBILLConfig.DHCBILLFIND","GetTarData",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job,i)
		var ValueStr=value.split("^");
		var Vlen=ValueStr.length;
		var columStr="";
		for(j = 0; j < Vlen; j++){
			if (columStr==""){
				columStr = ValueStr[j];
			}else{
				columStr = columStr +","+ ValueStr[j];
			}
		}
		if (allStr=="") {
			allStr = columStr;
		}else{
			allStr += columStr;
		}
		allStr += "\r\n";
	}

	var uri = 'data:text/xls;charset=utf-8,\ufeff' + encodeURIComponent(allStr);
	//创建a标签模拟点击下载
	var downloadLink = document.createElement("tExport");
	downloadLink.href = uri;
	downloadLink.download = fileName;
	document.body.appendChild(downloadLink);
	downloadLink.click();
	document.body.removeChild(downloadLink);
}

function Grid(objSheet,xlsTop,xlsLeft,hrow,lrow)
{   
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(1).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(2).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(3).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(4).LineStyle=1 ;
}

function OpenWinView()
{
	var winWidth=1090;
	var winHeight=590;
	$('#wintar').window({
		title:"收费项目信息",
		width:winWidth,
		height:winHeight,
		top:5,
		modal:true,
		resizable:false,
		minimizable:false,
		maximizable:false,
		collapsible:false
	});
	$('#wintar').window('refresh', 'dhcbillmenu.taritemdetail.csp');
}

function GetAlias()
{
	var winWidth=370;
	var winHeight=450;
	$('#winalias').window({
		title:"别名信息",
		width:winWidth,
		height:winHeight,
		modal:true,
		resizable:false,
		minimizable:false,
		maximizable:false,
		collapsible:false
	});
	$('#winalias').window('refresh', 'dhcbillmenu.taritemalias.csp');
}

function GetUPBaseInfo()
{
	var winWidth=1090;
	var winHeight=590;
	$('#winupbaseinfo').window({
		title:"收费项目基础信息修改日志",
		width:winWidth,
		height:winHeight,
		top:5,
		modal:true,
		resizable:false,
		minimizable:false,
		maximizable:false,
		collapsible:false
	});
	$('#winupbaseinfo').window('refresh', 'dhcbillmenu.taritemupbaseinfo.csp');
}

function FindClick()
{
	var TxtCode=$('#TxtCode').val();
	var TxtDesc=$('#TxtDesc').val();
	var TxtAlias=$('#TxtAlias').val();
	var TxtInsuDesc=$('#TxtInsuDesc').val();
	var TxtChargeDescrip=$('#TxtChargeDescrip').val();
	var TxtChargeReason=$('#TxtChargeReason').val();
	var TxtLowprice=$('#TxtLowprice').val();
	var TxtHighprice=$('#TxtHighprice').val();
	var ComboSubCate=$('#ComboSubCate').combobox('getValue');
	var ComboAccCate=$('#ComboAccCate').combobox('getValue');
	var ComboIpCate=$('#ComboIpCate').combobox('getValue');
	var ComboOpCate=$('#ComboOpCate').combobox('getValue');
	var ComboEmcCate=$('#ComboEmcCate').combobox('getValue');
	var ComboMrCate=$('#ComboMrCate').combobox('getValue');
	var ComboNMrCate=$('#ComboNMrCate').combobox('getValue');
	var ComboActive=$('#ComboActive').combobox('getValue');
	var ComboUnitPrice=$('#ComboUnitPrice').combobox('getValue');
	var ComboChargeReason=$('#ComboChargeReason').combobox('getValue');
	var ComboMedi=$('#ComboMedi').combobox('getValue');
	
	var CheckDateFlag=$('#CheckDate').prop("checked");
	if(CheckDateFlag==true){CheckDateFlag="Y";}
	else{CheckDateFlag="N";}
	var TxtStDate=$('#TxtStDate').datebox('getValue');
	var TxtEndDate=$('#TxtEndDate').datebox('getValue');

	var TxtStr=ComboSubCate+"^"+ComboOpCate+"^"+ComboIpCate+"^"+ComboAccCate+"^"+ComboEmcCate+"^"+ComboMrCate;
	var TxtStr=TxtStr+"^"+TxtInsuDesc+"^"+TxtChargeDescrip+"^"+TxtChargeReason+"^"+ComboActive+"^"+ComboUnitPrice;
	var TxtStr=TxtStr+"^"+ComboChargeReason+"^"+ComboMedi+"^"+""+"^"+"";
	var TxtStr=TxtStr+"^"+TxtLowprice+"^"+TxtHighprice+"^"+ComboNMrCate;
	var TxtStr=TxtStr+"!@#"+CheckDateFlag+"^"+TxtStDate+"^"+TxtEndDate;

	var TarStr=TxtCode+"###"+TxtDesc+"###"+TxtAlias+"###"+TxtStr;
	initLoadGrid(TarStr);
}

function BodyKeyDownInit()
{
	$(document).keydown(function(e){
		if(e.which == 117) {
			if(!BDPAutDisableFlag('BtnAdd')){
				$('#BtnAdd').trigger("click");
			}
		}
		if(e.which == 118) {
			if(!BDPAutDisableFlag('BtnClear')){
				$('#BtnClear').trigger("click");
			}
		}
		if(e.which == 119) {
			$('#BtnFind').trigger("click");
		}
	});
}

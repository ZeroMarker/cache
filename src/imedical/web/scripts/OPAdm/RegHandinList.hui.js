var PageLogicObj={
	m_RegHandinListTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	RegHandinListTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_RegHandinListTabDataGrid=InitRegHandinListTabDataGrid();
}
function InitRegHandinListTabDataGrid(){
	var Columns=[[ 
		{field:'TID',title:'行号',width:100,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BRegHaninDetails(\'' + row["TID"] + '\')">'+value+'</a>';
				return btn;
			}
		},
		{field:'TUserCode',title:'挂号员代码',width:100},
		{field:'TUserName',title:'挂号员',width:100},
		{field:'TAdmTot',title:'挂号总数',width:100},
		{field:'TRefundAdmTot',title:'退号数',width:90},
		{field:'TAdmAmtSum',title:'挂号金额',width:90,align:'right'},
    ]]
	var RegHandinListTabDataGrid=$("#RegHandinListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		rownumbers:true,
		autoRowHeight : false,
		pagination : false,  
		//pageSize: 30,
		//pageList : [30,100,200],
		idField:'TID',
		columns :Columns
	});
	return RegHandinListTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(RegHandinListTabDataGridLoad);
	$('#BPrint').click(BPrintClickHandle); 
}
function PageHandle(){
	DisableBtn("BPrint",true);  
	$("#StDate,#EndDate").datebox('setValue',ServerObj.CurDay);
}
function RegHandinListTabDataGridLoad(){
	$.q({
	    ClassName : "web.UDHCJFOPHandinReg11",
	    QueryName : "QueryHandinRegList",
	    StDate:$("#StDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'),
	    Pagerows:PageLogicObj.m_RegHandinListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		//PageLogicObj.m_RegHandinListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_RegHandinListTabDataGrid.datagrid('loadData',GridData);
		if (GridData['total']>0){
			DisableBtn("BPrint",false);  
		}else{
			DisableBtn("BPrint",true);  
		}
	}); 
}
function BRegHaninDetails(TID){
	var src="opadm.reghandin.hui.csp?RepID="+TID;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","挂号员日结账明细", '720', '612',"icon-w-edit","",$code,"");
}
function BPrintClickHandle(){
   var myPrtXMLName="UDHCRegHandinRptList";
   DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);
   var path=$.cm({
		ClassName:"web.UDHCJFCOMMON",
		MethodName:"getpath",
		dataType:"text"
   },false);
	var Template=path+"UDHCJFOP.HandinRegList11.xls";
	try{
		var xlApp= new ActiveXObject("Excel.Application"); 
		var xlBook= xlApp.Workbooks.Add(Template); 
		var xlSheet = xlBook.ActiveSheet;	
		var xlsheet = xlBook.WorkSheets("Sheet1");
	}
	catch(e) {
  		$.messager.alert("提示","要打印该表您必须安装Excel电子表格软件,同时浏览器须使用'ActiveX 控件',您的浏览器须允许执行控件 请点击帮助了解浏览器设置方法");
  		return "";
	}
	var columnNumber=1;
	xlsheet.cells(2, columnNumber).value = "行号";
	xlsheet.cells(2, columnNumber+1).value = "挂号员";
	xlsheet.cells(2, columnNumber+2).value = "挂号总数";
	xlsheet.cells(2, columnNumber+3).value = "退号数";
	xlsheet.cells(2, columnNumber+4).value = "挂号金额";
	xlsheet.cells(2, columnNumber+5).value = "挂号员代码";
	var rows=PageLogicObj.m_RegHandinListTabDataGrid.datagrid('getRows');
	for (var i=0;i<rows.length;i++){
		xlsheet.cells(i+3, columnNumber).value = rows[i]['TID'];
		xlsheet.cells(i+3, columnNumber+1).value = rows[i]['TUserName'];
		xlsheet.cells(i+3, columnNumber+2).value = rows[i]['TAdmTot'];
		xlsheet.cells(i+3, columnNumber+3).value = rows[i]['TRefundAdmTot'];
		xlsheet.cells(i+3, columnNumber+4).value = rows[i]['TAdmAmtSum'];
		xlsheet.cells(i+3, columnNumber+5).value = rows[i]['TUserCode'];
	}
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
	return true;
}
function XMLPrint(TxtInfo,ListInfo){
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
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
	    },
	    onBeforeOpen:function(){
		    if (_event!="") eval(_event);
		    return true;
		}
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
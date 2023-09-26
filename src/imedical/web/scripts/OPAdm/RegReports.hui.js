var PageLogicObj={
	m_RegReptsTabDataGrid:"",
	m_SuseID:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	RegReptsTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_RegReptsTabDataGrid=InitRegReptsTabDataGrid();
}
function InitRegReptsTabDataGrid(){
	var Columns=[[ 
		{field:'TUserCode',title:'工号',width:100},
		{field:'TUserName',title:'姓名',width:100},
		{field:'TRegType',title:'挂号类别',width:100},
		{field:'TRegNum',title:'挂号人次',width:100},
		{field:'TRegSum',title:'收款金额',width:90,align:'right'},
		{field:'TRefNum',title:'退号人次',width:90},
		{field:'TRefSum',title:'退款金额',width:150,align:'right'},
		{field:'THandNum',title:'合计人次',width:180},
		{field:'THandSum',title:'挂号金额',width:100,align:'right'}, 
		{field:'TPRTAcount',title:'价格',width:100,align:'right'}
    ]]
	var RegReptsTabDataGrid=$("#RegReptsTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'TRegType',
		columns :Columns
	});
	return RegReptsTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(RegReptsTabDataGridLoad);
	$('#BImportData').click(BImportDataClickHandle);
}
function PageHandle(){
	if (ServerObj.status==""){
		$('#RegUser').attr("disabled",true);
		$("#RegUser").val(session['LOGON.USERNAME']);
		PageLogicObj.m_SuseID=session['LOGON.USERID'];
	}else{
		$("#pagetitle").panel('setTitle','挂号员日报汇总');
		InitRegUserLookUp();
	}
	$("#StDate,#EndDate").datebox('setValue',ServerObj.CurDay);
}
function RegReptsTabDataGridLoad(){
	if (ServerObj.status!=""){
		if ($("#RegUser").lookup('getText')==""){
			PageLogicObj.m_SuseID="";
		}
	}
	$.q({
	    ClassName : "web.DHCOPRegReports",
	    QueryName : "StatAllUsr",
	    StDate:$("#StDate").datebox('getValue'), EdDate:$("#EndDate").datebox('getValue'), 
	    ctloc:session['LOGON.CTLOCID'], userid:session['LOGON.USERID'], SuseID:PageLogicObj.m_SuseID,
	    Pagerows:PageLogicObj.m_RegReptsTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RegReptsTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function BImportDataClickHandle(){
	var path=$.cm({
		ClassName:"web.UDHCJFCOMMON",
		MethodName:"getpath",
		dataType:"text"
	},false);
	if(ServerObj.status=="ZZ"){
		Template=path+"DHCOPRegReportsZZ.xls";
	}else{
		Template=path+"DHCOPRegReports.xls";
	}
	//改成调用摸板进行打印还需GetPath(),至于汇总，可另设置一隐藏元素，取另一个GLOBAL
	 var ctloc=session['LOGON.CTLOCID'];
	 var userid=session['LOGON.USERID'];
	 var rows,pagerow;
	 var PrintRTN=$.cm({
		ClassName:"web.DHCOPRegReports",
		MethodName:"GetRPtRow",
		ctloc:ctloc, userid:userid,
		dataType:"text"
	  },false);
	 var PrintArr=PrintRTN.split("^");
	 var PrintRows=PrintArr[0];
	 var userName=PrintArr[1];
     if (PrintRows==0){return ;}
	 try{
		var oXL = new ActiveXObject("Excel.Application"); 
		var oWB = oXL.Workbooks.Add(Template); 
		var oSheet = oWB.ActiveSheet; 
		var mainrows=PrintRows;
	}
	catch(e) {
	  	$.messager.alert("提示","要打印该表您必须安装Excel电子表格软件,同时浏览器须使用'ActiveX 控件',您的浏览器须允许执行控件 请点击帮助了解浏览器设置方法");
	  	return "";
	}
  	if(ServerObj.status=="ZZ"){
	  	oSheet.Cells(1,2).value =ServerObj.HospName+"挂号员日报表汇总";
  	}else{
	  	oSheet.Cells(1,2).value =ServerObj.HospName+"挂号员日报表";
  	}
  	oSheet.Cells(2,4).value =$("#StDate").datebox('getValue');
  	oSheet.Cells(2,7).value =$("#EndDate").datebox('getValue');
  	oSheet.Cells(2,11).value =userName;
   	for (i=3;i<=mainrows+2;i++){ 
   	  var PrintSet=$.cm({
		ClassName:"web.DHCOPRegReports",
		MethodName:"GetRPtRowInf",
		ctloc:ctloc, userid:userid,t:i-2,
		dataType:"text"
	  },false); 
       var sstr=PrintSet.split("^")
       oSheet.Cells(i+1,1).HorizontalAlignment=3;//左对齐
       oSheet.Range(oSheet.Cells(i+1,3),oSheet.Cells(i+1,9)).HorizontalAlignment =-4108;//居中
       oSheet.Cells(i+1,1).value =sstr[0];
       oSheet.Cells(i+1,2).value =sstr[1];
       oSheet.Cells(i+1,3).value =sstr[2];
       oSheet.Cells(i+1,4).value =sstr[9];
       oSheet.Cells(i+1,5).value =sstr[3];
       oSheet.Cells(i+1,6).value =sstr[4];
       oSheet.Cells(i+1,7).value =sstr[5];
       oSheet.Cells(i+1,8).value =sstr[6];
       oSheet.Cells(i+1,9).value =sstr[7];
       oSheet.Cells(i+1,10).value =sstr[8];
	 }
	 mainrows=parseInt(mainrows)+4;
	 gridlist(oSheet,4,mainrows,1,10);
	 oSheet.printout;
	 oWB.Close (savechanges=false);
	 oXL.Quit();
	 oXL=null;
	 oSheet=null;
}
function gridlist(objSheet,row1,row2,c1,c2){
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(4).LineStyle=1; 
}
function DrawLine(Row,xlsheet){
	var Range=xlsheet.Range(xlsheet.Cells(Row,1),xlsheet.Cells(Row,9));
	Range.Borders(9).LineStyle = 3;     // 线的格式
	Range.Borders(9).Weight = 2;
	Range.Borders(9).ColorIndex = -4105;          // 9表示下边线
}
function InitRegUserLookUp(){
	$("#RegUser").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'SSUSR_RowId',
        textField:'SSUSR_Name',
        columns:[[   
            {field:'SSUSR_RowId',title:'',hidden:true},
			{field:'SSUSR_Name',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCUserGroup',QueryName: 'Finduse1'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{Desc:desc});
	    },
	    onSelect:function(index, rec){
		    PageLogicObj.m_SuseID=rec['SSUSR_RowId'];
		}
    });
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
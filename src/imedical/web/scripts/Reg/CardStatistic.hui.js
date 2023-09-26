var PageLogicObj={
	m_CardListTabDataGrid:"",
	m_UserRowId:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function PageHandle(){
	//卡类型
	LoadUser();
	$("#StartDate,#EndDate").datebox('setValue',ServerObj.CurData);
	CardStatisticTabDataGridLoad();
}
function InitEvent(){
	$("#BFind").click(CardStatisticTabDataGridLoad);
	$("#BExport").click(ExportClickHandler);
}
function Init(){
	PageLogicObj.m_CardStatisticTabDataGrid=InitCardStatisticTabDataGrid();
}
function InitCardStatisticTabDataGrid(){
	var Columns=[[ 
		{field:'CFRowid',hidden:true,title:''},
		{field:'CFUserDesc',title:'操作员',width:80},
		{field:'CFCreatDate',title:'建卡日期',width:100},
		{field:'CFCreatTime',title:'建卡时间',width:100},
		{field:'CFCancelDate',title:'退卡日期',width:100},
		{field:'CFCancelTime',title:'退卡时间',width:100},
		{field:'CFCardNo',title:'卡号',width:150},
		{field:'CFFormerCardNo',title:'原卡号',width:150},
		{field:'PapmiName',title:'患者姓名',width:120},
		{field:'PapmiSexDesc',title:'性别',width:80},
		{field:'myPatType',title:'患者类型',width:90},
		{field:'PapmiBirth',title:'出生日期',width:100},
		{field:'EmployeeFunction',title:'患者级别',width:100},
		{field:'SecretLevel',title:'患者密级',width:100}
    ]]
	var CardStatisticTabDataGrid=$("#CardStatisticTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'CFRowid',
		columns :Columns,
		onSelect:function(index, row){
		}
	});
	return CardStatisticTabDataGrid;
}
function CardStatisticTabDataGridLoad(){
	if ($("#CardOperUser").lookup('getText')=="") PageLogicObj.m_UserRowId="";
	if ($("#Own").checkbox('getValue')){
		PageLogicObj.m_UserRowId=session['LOGON.USERID'];
	}
	$.cm({
	    ClassName : "web.DHCCardStatistic",
	    QueryName : "CardStatistic",
	    CardOperUserDr:PageLogicObj.m_UserRowId,
	    StartDate:$("#StartDate").datebox('getValue'),
	    EndDate:$("#EndDate").datebox('getValue'),
	    ChangeCardFlag:$("#ChangeCardFlag").checkbox('getValue')?'on':'',
	    CardOperUser:PageLogicObj.m_UserRowId,
	    ReplaceCardFlag:$("#ReplaceCardFlag").checkbox('getValue')?'on':'',
	    Pagerows:PageLogicObj.m_CardStatisticTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_CardStatisticTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function LoadUser(){
	$("#CardOperUser").lookup({
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
        panelHeight:400,
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
			if (rec!=undefined){
				$("#CardOperUser").lookup('setText',rec["SSUSR_Name"])
				PageLogicObj.m_UserRowId=rec["SSUSR_RowId"];
				//CardStatisticTabDataGridLoad();
				var o=$HUI.checkbox("#Own");
				if (PageLogicObj.m_UserRowId==session['LOGON.USERID']){
					o.setValue(true);
				}else{
					o.setValue(false);
					/*setTimeout(function(){
						$("#CardOperUser").lookup('setText',rec["SSUSR_Name"])
						PageLogicObj.m_UserRowId=rec["SSUSR_RowId"];
					})*/
				}
			}
		}
    });
}
function OwnClickHandler(){
	setTimeout(function(){
		var o=$HUI.checkbox("#Own");
		if (o.getValue()){
			PageLogicObj.m_UserRowId=session['LOGON.USERID'];
			$("#CardOperUser").lookup('setText',session['LOGON.USERNAME']);
		}else{
			if (PageLogicObj.m_UserRowId==session['LOGON.USERID']){
				PageLogicObj.m_UserRowId="";
				$("#CardOperUser").lookup('setText',"");
			}
		}
		CardStatisticTabDataGridLoad();
	});
}
function ChangeCardFlagClickHandler(){
	var o=$HUI.checkbox("#ChangeCardFlag");
	if (o.getValue()==true){
		var b=$HUI.checkbox("#ReplaceCardFlag");
		b.setValue(false);
		}
	setTimeout(function(){
		CardStatisticTabDataGridLoad();
	});
}
function ReplaceCardFlagClickHandler(){
	var o=$HUI.checkbox("#ReplaceCardFlag");
	if (o.getValue()==true){
		var b=$HUI.checkbox("#ChangeCardFlag");
		b.setValue(false);
		}
	setTimeout(function(){
		CardStatisticTabDataGridLoad();
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
function ExportClickHandler() {
	if ($("#CardOperUser").lookup('getText')=="") PageLogicObj.m_UserRowId="";
	if ($("#Own").checkbox('getValue')){
		PageLogicObj.m_UserRowId=session['LOGON.USERID'];
	}	
	$cm({
	    ExcelName:"建/换/补卡统计",
		localDir:"Self", 
	    ResultSetType:"ExcelPlugin",
		ClassName : "web.DHCCardStatistic",
	    QueryName : "CardStatisticExport",
	    CardOperUserDr:PageLogicObj.m_UserRowId,
	    StartDate:$("#StartDate").datebox('getValue'),
	    EndDate:$("#EndDate").datebox('getValue'),
	    ChangeCardFlag:$("#ChangeCardFlag").checkbox('getValue')?'on':'',
	    CardOperUser:PageLogicObj.m_UserRowId,
	    ReplaceCardFlag:$("#ReplaceCardFlag").checkbox('getValue')?'on':'',
	}, false);
	return;
	
	
	if ($("#CardOperUser").lookup('getText')=="") PageLogicObj.m_UserRowId="";
	if ($("#Own").checkbox('getValue')){
		PageLogicObj.m_UserRowId=session['LOGON.USERID'];
	}
	var FileName="CardStatisticQuery";
	var oXL = new ActiveXObject("Excel.Application"); //创建AX对象excel   
	var oWB = oXL.Workbooks.Add(); //获取workbook对象   
	var oSheet = oWB.ActiveSheet; //激活当前sheet
	oSheet.Columns.NumberFormatLocal = "@";
	//设置工作薄名称  
	oSheet.name = FileName; 
	PageLogicObj.m_FindFlag=1;
	$.cm({
	ClassName : "web.DHCCardStatistic",
		QueryName : "CardStatistic",
		CardOperUserDr:PageLogicObj.m_UserRowId,
		StartDate:$("#StartDate").datebox('getValue'),
		EndDate:$("#EndDate").datebox('getValue'),
		ChangeCardFlag:$("#ChangeCardFlag").checkbox('getValue')?'on':'',
		CardOperUser:PageLogicObj.m_UserRowId,
		ReplaceCardFlag:$("#ReplaceCardFlag").checkbox('getValue')?'on':'',
		rows:99999
	},function(data){
		try{
		var rowArr=data.rows; 
		if(rowArr.length==0) return;
		var columns=$("#CardStatisticTab").datagrid('options').columns[0];   
		for(var i=0; i<rowArr.length; i++) {
			for(var j=0; j<columns.length; j++) {
				if(columns[j].hidden) continue;
				if(i==0) oSheet.cells(i+1,j+1)=columns[j].title;
				var val=rowArr[i][columns[j].field];
				if(columns[j].formatter) val="";
				oSheet.cells(i+2,1)=i+1;
				oSheet.cells(i+2,j+1)=val;
			}
		}
		oXL.Visible = false; //设置excel可见属性
		var fname = oXL.Application.GetSaveAsFilename(FileName+".xls", "Excel Spreadsheets (*.xls), *.xls");
		oWB.SaveAs(fname);
		oWB.Close(savechanges=false);
		oXL.Quit();
		oXL=null;
		}catch(e){
			$.messager.alert("提示",e.message);
		};
	});
}
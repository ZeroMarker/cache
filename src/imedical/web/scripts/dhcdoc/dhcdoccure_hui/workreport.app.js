var CureReportDataGrid;
$(document).ready(function(){
	Init();
  	InitEvent();
	//CureReportDataGridLoad();
});

function Init(){
	$HUI.combobox('#CureStatus',{      
    	valueField:'Code',   
    	textField:'Desc',
    	data: [{
			Code: 'ANA',Desc: $g('申请未预约') //未预约过一次
		},{
			Code: 'ANC',Desc: $g('预约未治疗') //预约过但未治疗一次
		},{
			Code: 'AC',Desc: $g('在治疗') //存在未治疗
		},{
			Code: 'A',Desc: $g('预约(包含未治疗在治疗)') //ANC+AC
		},{
			Code: 'C',Desc: $g('已取消')
		},{
			Code: 'F',Desc: $g('已完成')
		},{
			Code: 'ALL',Desc: $g('全部')
		}]
    	//url:$URL+"?ClassName="+PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME+"&QueryName=FindCureStatus&ResultSetType=array",
	});
	var DateTypeObj=$HUI.combobox('#DateType',{     
    	valueField:'Code',   
    	textField:'Desc',
    	data: [{
			Code: 'APPOINT',Desc: $g('预约日期')
		},{
			Code: 'APPLY',Desc: $g('申请日期')
		}]
	});
	
	DateTypeObj.select("APPOINT");
	InitDate();
  	InitCureReportDataGrid();	
	
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		InitLoc();
		InitResGroup();
	  	InitArcimDesc(); 
	  	CureReportDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitLoc();
		InitResGroup();
	  	InitArcimDesc(); 
	  	CureReportDataGridLoad();
	}	
	//workreport.inititem.js
}
function InitEvent(){
	$('#btnFind').click(CureReportDataGridLoad);
    $('#btnExport').click(ExportCureReport);
	$('#btnPrint').click(PrintCureReport);
}

function InitCureReportDataGrid()
{
	CureReportDataGrid=$('#tabCureReportList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : 20,
		pageList : [20,50,100],
		columns :[
			[ 
				{field:'PatNo',title:'登记号',width:120, resizable: false},   
				{field:'PatName',title:'病人姓名',width:80, resizable: false},   
				{field:'PatSex',title:'性别',width:40, resizable: false},
				{field:'PatAge',title:'年龄',width:50, resizable: false},
				{field:'PatTel',title:'联系电话',width:100, resizable: false},
				{field:'CureDate',title:'申请日期',width:100, resizable: false}, 
				{field:'ArcimDesc',title:'治疗项目',width:150, resizable: false},
				{field:'OrderAddDept',title:'申请科室',width:100, resizable: false},
				{field:'UnitPrice',title:'单价',width:50, resizable: false}, 
				{field:'OrdQty',title:'数量',width:40, resizable: false}, 
				{field:'OrdBillUOM',title:'单位',width:40, resizable: false}, 
				{field:'OrdPrice',title:'总金额(元)',width:80, resizable: false}, 
				{field:'OrdBilled',title:'是否缴费',width:80, resizable: false}, 
				{field:'ApplyCureRecord',title:'预约明细',width:200, resizable: false},
				{field:'OrdReLoc',title:'接收科室',width:100, resizable: false},   
				{field:'ApplyStatus',title:'申请单状态',width:80, resizable: false},				
				{field:'ApplyAppedTimes',title:'已预约次数',width:80, resizable: false},
				{field:'ApplyNoAppTimes',title:'未预约次数',width:80, resizable: false},
				{field:'ApplyFinishTimes',title:'已治疗次数',width:80, resizable: false},
				{field:'ApplyNoFinishTimes',title:'未治疗次数',width:80, resizable: false},		
				{field:'ApplyUser',title:'申请医生',width:80,hidden:true},
				{field:'ApplyDateTime',title:'申请时间',width:80,hidden:true},
				{field:'DCARowId',title:'DCARowId',width:10,hidden:true},	 
				{field:'Job',title:'Job',width:30,hidden:true}  
			 ]
		] 
	});
}
function CureReportDataGridLoad()
{
	var DateType=$("#DateType").combogrid("getValue");
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var queryLoc=$("#ComboLoc").combogrid("getValues");
	var queryLocStr="";
	if(queryLoc!=""){
		var queryLocArr=queryLoc //.split(",");
		for(var i=0;i<queryLocArr.length;i++){
			if(queryLocStr==""){queryLocStr=queryLocArr[i];}
			else{queryLocStr=queryLocStr+"^"+queryLocArr[i];}
		}
	}
	var queryStatus=$("#CureStatus").combogrid("getValue");
	//var queryArcim=$("#ComboArcim").combogrid("getValue");
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
	var queryArcim=PageSizeItemObj.m_SelectArcimID;
	var queryGroup=$('#ResGroup').combobox('getValue');
	var queryOrderLoc=$('#ComboOrderLoc').combobox('getValue');
	var UserHospID=Util_GetSelUserHospID();	
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"QryWorkReport",
		'DateType':DateType,
		'StartDate':StartDate,
		'EndDate':EndDate,
		'UserID':session['LOGON.USERID'],
		'queryLoc':queryLocStr,
		'queryStatus':queryStatus,
		'queryArcim':queryArcim,
		'queryGroup':queryGroup,
		'queryOrderLoc':queryOrderLoc,
		'UserHospID':UserHospID,
		Pagerows:CureReportDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureReportDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function ExportCureReport(){
	try{
		var DateType=$("#DateType").combogrid("getValue");
		var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
		var queryLoc=$("#ComboLoc").combogrid("getValues");
		var queryLocStr="";
		if(queryLoc!=""){
			var queryLocArr=queryLoc //.split(",");
			for(var i=0;i<queryLocArr.length;i++){
				if(queryLocStr==""){queryLocStr=queryLocArr[i];}
				else{queryLocStr=queryLocStr+"^"+queryLocArr[i];}
			}
		}
		var queryStatus=$("#CureStatus").combogrid("getValue");
		//var queryArcim=$("#ComboArcim").combogrid("getValue");
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
		var queryArcim=PageSizeItemObj.m_SelectArcimID;
		var queryGroup=$('#ResGroup').combobox('getValue');
		var queryOrderLoc=$('#ComboOrderLoc').combobox('getValue');
		var Hospital=""; //tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+$g("治疗预约统计");
		
		//异步导出,同步加false
		$cm({
			//dataType:'text',
			ResultSetType:'ExcelPlugin',
			ExcelName:Title,
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportExport",
			'DateType':DateType,
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryLoc':queryLocStr,
			'queryStatus':queryStatus,
			'queryArcim':queryArcim,
			'queryGroup':queryGroup,
			'queryOrderLoc':queryOrderLoc
		});
		//location.href = rtn;
	}catch(e){
		alert(e.message);	
	}
}

function PrintCureReport(){
	try{
		//打印
		var PrintNum = 1; //打印次数
		var IndirPrint = "N"; //是否预览打印
		var Hospital=""; //tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+$g("治疗预约统计");
		var TaskName=Title; //打印任务名称
		var DateType=$("#DateType").combogrid("getValue");
		var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
		var queryLoc=$("#ComboLoc").combogrid("getValues");
		var queryLocStr="";
		if(queryLoc!=""){
			var queryLocArr=queryLoc //.split(",");
			for(var i=0;i<queryLocArr.length;i++){
				if(queryLocStr==""){queryLocStr=queryLocArr[i];}
				else{queryLocStr=queryLocStr+"^"+queryLocArr[i];}
			}
		}
		var queryStatus=$("#CureStatus").combogrid("getValue");
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
		var queryArcim=PageSizeItemObj.m_SelectArcimID;
		var queryGroup=$('#ResGroup').combobox('getValue');
		var queryOrderLoc=$('#ComboOrderLoc').combobox('getValue');
		//导出
		var GridData = $cm({
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportExport",
			'DateType':DateType,
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryLoc':queryLocStr,
			'queryStatus':queryStatus,
			'queryArcim':queryArcim,
			'queryGroup':queryGroup,
			'queryOrderLoc':queryOrderLoc
		}, false);
		var DetailData=GridData.rows; //明细信息
		if (DetailData.length==0) {
			$.messager.alert("提示","没有需要打印的数据!");
			return false
		}
		//明细信息展示
		var Cols=[
			{field:"PatNo",title:"登记号",width:"10%",align:"left"},
			{field:"PatName",title:"患者姓名",width:"10%",align:"left"},
			{field:"PatSex",title:"性别",width:"5%",align:"left"},
			{field:"PatAge",title:"年龄",width:"5%",align:"left"},
			{field:"CureDate",title:"申请日期",width:"10%",align:"left"},
			{field:"ArcimDesc",title:"治疗项目",width:"10%",align:"left"},
			{field:"UnitPrice",title:"单价(元)",width:"10%",align:"right"},
			{field:"OrdQty",title:"数量",width:"10%",align:"right"},
			{field:"OrdPrice",title:"总金额(元)",width:"10%",align:"right"},
			{field:"OrdBilled",title:"是否缴费",width:"10%",align:"left"},
			{field:"OrdReLoc",title:"接收科室",width:"10%",align:"left"},
			{field:"ApplyStatus",title:"申请单状态",width:"10%",align:"left"},
			{field:"ApplyAppedTimes",title:"已预约次数",width:"10%",align:"right"},
			{field:"ApplyNoAppTimes",title:"未预约次数",width:"10%",align:"right"},
			{field:"ApplyFinishTimes",title:"已治疗次数",width:"10%",align:"right"},
			{field:"ApplyNoFinishTimes",title:"未治疗次数",width:"10%",align:"right"},
			{field:"ApplyCureRecord",title:"预约明细",width:"15%",align:"left"}
		];	
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
	}catch(e){
		alert(e.message);	
	}
}

var CureReportDataGrid;
$(document).ready(function(){
	Init();
  	InitEvent();
	//CureReportDataGridLoad();
});

function Init(){
	$HUI.combobox('#CureStatus',{      
    	valueField:'CureStatusCode',   
    	textField:'CureStatusDesc',
    	url:$URL+"?ClassName="+PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME+"&QueryName=FindCureStatus&ResultSetType=array",
	});
	var DateTypeObj=$HUI.combobox('#DateType',{     
    	valueField:'Code',   
    	textField:'Desc',
    	data: [{
			Code: 'APPOINT',
			Desc: '预约日期'
		},{
			Code: 'APPLY',
			Desc: '申请日期'
		}]

	});
	
	//$('#DateType').combobox('select',"APPOINT")
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
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCARowId",
		//pageNumber:0,
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
				{field:'PatNo',title:'登记号',width:120, resizable: true},   
				{field:'PatName',title:'病人姓名',width:80, resizable: true},   
				{field:'PatSex',title:'性别',width:40, resizable: true},
				{field:'PatAge',title:'年龄',width:50, resizable: true},
				{field:'PatTel',title:'联系电话',width:100, resizable: true},
				{field:'CureDate',title:'申请日期',width:100, resizable: true}, 
				{field:'ArcimDesc',title:'治疗项目',width:150, resizable: true},
				{field:'OrderAddDept',title:'申请科室',width:100, resizable: true},
				{field:'UnitPrice',title:'单价',width:50, resizable: true}, 
				{field:'OrdQty',title:'数量',width:40, resizable: true}, 
				{field:'OrdBillUOM',title:'单位',width:40, resizable: true}, 
				{field:'OrdPrice',title:'总金额(元)',width:80, resizable: true}, 
				{field:'OrdBilled',title:'是否缴费',width:80, resizable: true}, 
				{field:'ApplyCureRecord',title:'预约明细',width:200, resizable: true},
				{field:'OrdReLoc',title:'接收科室',width:100, resizable: true},   
				{field:'ApplyStatus',title:'申请单状态',width:80, resizable: true},
				{field:'ApplyFinishUser',title:'执行人',width:80, resizable: true},
				{field:'Job',title:'Job',width:30,hidden:true},
				{field:'ApplyAppedTimes',title:'已预约次数',width:80, resizable: true},
				{field:'ApplyNoAppTimes',title:'未预约次数',width:80, resizable: true},
				{field:'ApplyFinishTimes',title:'已治疗次数',width:80, resizable: true},
				{field:'ApplyNoFinishTimes',title:'未治疗次数',width:80, resizable: true},		
				{field:'ApplyUser',title:'申请医生',width:80,hidden:true},
				{field:'ApplyDateTime',title:'申请时间',width:80,hidden:true},
				{field:'DCARowId',title:'DCARowId',width:10,hidden:true}  	   
			 ]] 
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
		var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+"治疗预约统计";
		
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
		
		/*var UserID=session['LOGON.USERID'];
		var RowIDs=CureReportDataGrid.datagrid('getRows');
		//if(RowIDs.length)
		var RowNum=RowIDs.length;
		if(RowNum==0){
			$.messager.alert("提示","未有需要导出的数据");
			return false;
		}
		CureReportDataGrid.datagrid('selectRow',0);
		var ProcessNo=""
		var row = CureReportDataGrid.datagrid('getSelected');
		if (row){
			ProcessNo=row.Job
		}
		if(ProcessNo==""){
			$.messager.alert("提示","获取进程号错误");
			return false;
		}
		var datacount=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetWorkReportNum",ProcessNo,UserID);
		if(datacount==0){
			$.messager.alert("提示","获取导出数据错误");
			return false;
		}
		var xlApp,xlsheet,xlBook;
		var TemplatePath=ServerObj.PrintBath+"DHCDocCureWorkReport.xlsx";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(TemplatePath);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
    	
    	var StartDate=$("#StartDate").datebox("getValue");
    	if(StartDate.indexOf("/")>0){
	    	//var StartDateArr=StartDate.split("/");
	    	//var StartDate=StartDateArr[2]+"-"+StartDateArr[0]+"-"+StartDateArr[1];
    	}
		//var EndDate=$("#EndDate").datebox("getValue");
		//var EndDateArr=EndDate.split("/");
    	//var EndDate=EndDateArr[2]+"-"+EndDateArr[0]+"-"+EndDateArr[1];
    	var EndDate=$("#EndDate").datebox("getValue");
    	var DateStr=StartDate+"至"+EndDate
    	xlsheet.cells(2,10)=DateStr;
    	xlsheet.cells(2,12)="";
    	var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+"治疗预约统计";
    	xlsheet.cells(1,1)=Title;
    	var xlsrow=3;
	    for(var i=1;i<=datacount;i++){
			var ret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetWorkReportInfo",ProcessNo,i,UserID);
			if(ret=="") return ;
			var arr=ret.split("^");
			xlsrow=xlsrow+1;
			var PatientNo=arr[1]
			var PatientName=arr[2]
			var PatientSex=arr[3]
			var PatientAge=arr[4]
			var PatientTel=arr[5]
			var AdmType=arr[6]
			var AdmDep=arr[7]
			var ArcimDesc=arr[8]
			var OrderQty=arr[9]
			var BillingUOM=arr[10]
			var OrderReLoc=arr[11]
			var ApplyStatus=arr[12]
			var ApplyUser=arr[13]
			var ApplyDate=arr[14]
			var ApplyAppedTimes=arr[15]
			var ApplyNoAppTimes=arr[16]
			var ApplyFinishTimes=arr[17]
			var ApplyNoFinishTimes=arr[18]
			var OrdPrice=arr[19]
			var OrdBilled=arr[20]
			var UnitPrice=arr[21]
			var ApplyFinishUser=arr[22]
			var CureDate=arr[23]
			var CureDetail=arr[24]
			CureDetail=CureDetail.replace(/<br>/g," ")
		    xlsheet.cells(xlsrow,1)=PatientNo;
		    xlsheet.cells(xlsrow,2)=PatientName;
		    xlsheet.cells(xlsrow,3)=PatientSex;
		    xlsheet.cells(xlsrow,4)=PatientAge;
		    xlsheet.cells(xlsrow,5)=CureDate;
		    xlsheet.cells(xlsrow,6)=ArcimDesc;
		    xlsheet.cells(xlsrow,7)=UnitPrice;
		    xlsheet.cells(xlsrow,8)=OrderQty+"/"+BillingUOM;
		    xlsheet.cells(xlsrow,9)=OrdPrice;
		    xlsheet.cells(xlsrow,10)=OrdBilled;
		    xlsheet.cells(xlsrow,11)=OrderReLoc;
		    xlsheet.cells(xlsrow,12)=ApplyAppedTimes;
		    xlsheet.cells(xlsrow,13)=ApplyNoAppTimes;
		    xlsheet.cells(xlsrow,14)=ApplyFinishTimes;
		    xlsheet.cells(xlsrow,15)=ApplyNoFinishTimes;
		    xlsheet.cells(xlsrow,16)=ApplyFinishUser;
			xlsheet.cells(xlsrow,17)=CureDetail;
	    }
	    //xlsheet.printout;
	    gridlist(xlsheet,4,xlsrow,1,17)
		xlBook.Close (savechanges=true);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;*/
	}catch(e){
		alert(e.message);	
	}
}


function PrintCureReport(){
	try{
		//打印
		var PrintNum = 1; //打印次数
		var IndirPrint = "N"; //是否预览打印
		var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+"治疗预约统计";
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
		var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+"治疗预约统计";
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
			{field:"PatSex",title:"性别",width:"10%",align:"left"},
			{field:"PatAge",title:"年龄",width:"10%",align:"left"},
			{field:"CureDate",title:"申请日期",width:"10%",align:"left"},
			{field:"ArcimDesc",title:"治疗项目",width:"10%",align:"left"},
			{field:"UnitPrice",title:"单价(元)",width:"10%",align:"right"},
			{field:"OrdQty",title:"数量",width:"10%",align:"right"},
			{field:"OrdPrice",title:"总金额(元)",width:"10%",align:"right"},
			{field:"OrdBilled",title:"是否缴费",width:"10%",align:"left"},
			{field:"OrdReLoc",title:"接收科室",width:"10%",align:"left"},
			{field:"ApplyAppedTimes",title:"已预约次数",width:"10%",align:"right"},
			{field:"ApplyNoAppTimes",title:"未预约次数",width:"10%",align:"right"},
			{field:"ApplyFinishTimes",title:"已治疗次数",width:"10%",align:"right"},
			{field:"ApplyNoFinishTimes",title:"未治疗次数",width:"10%",align:"right"},
			{field:"ApplyFinishUser",title:"执行人",width:"10%",align:"left"},
			{field:"ApplyCureRecord",title:"预约明细",width:"10%",align:"left"}
		];	
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
		
		/*var UserID=session['LOGON.USERID'];
		var RowIDs=CureReportDataGrid.datagrid('getRows');
		//if(RowIDs.length)
		var RowNum=RowIDs.length;
		if(RowNum==0){
			$.messager.alert("提示","未有需要导出的数据");
			return false;
		}
		CureReportDataGrid.datagrid('selectRow',0);
		var ProcessNo=""
		var row = CureReportDataGrid.datagrid('getSelected');
		if (row){
			ProcessNo=row.Job
		}
		if(ProcessNo==""){
			$.messager.alert("提示","获取进程号错误");
			return false;
		}
		var datacount=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetWorkReportNum",ProcessNo,UserID);
		if(datacount==0){
			$.messager.alert("提示","获取导出数据错误");
			return false;
		}
		var xlApp,xlsheet,xlBook;
		var TemplatePath=ServerObj.PrintBath+"DHCDocCureWorkReportPrt.xlsx";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(TemplatePath);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
    	var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+"治疗预约统计";
    	xlsheet.cells(1,1)=Title;
    	var StartDate=$("#StartDate").datebox("getValue");
    	var EndDate=$("#EndDate").datebox("getValue");
    	//var StartDateArr=StartDate.split("/");
    	//var StartDate=StartDateArr[2]+"-"+StartDateArr[0]+"-"+StartDateArr[1];
		//var EndDate=$("#EndDate").datebox("getValue");
		//var EndDateArr=EndDate.split("/");
    	//var EndDate=EndDateArr[2]+"-"+EndDateArr[0]+"-"+EndDateArr[1];
    	var DateStr=StartDate+"至"+EndDate
    	xlsheet.cells(2,11)=DateStr;
    	xlsheet.cells(2,12)="";
    	var xlsrow=3;
	    for(var i=1;i<=datacount;i++){
			var ret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetWorkReportInfo",ProcessNo,i,UserID);
			if(ret=="") return ;
			
			var arr=ret.split("^");
			xlsrow=xlsrow+1;
			var PatientNo=arr[1]
			var PatientName=arr[2]
			var PatientSex=arr[3]
			var PatientAge=arr[4]
			var PatientTel=arr[5]
			var AdmType=arr[6]
			var AdmDep=arr[7]
			var ArcimDesc=arr[8]
			var OrderQty=arr[9]
			var BillingUOM=arr[10]
			var OrderReLoc=arr[11]
			var ApplyStatus=arr[12]
			var ApplyUser=arr[13]
			var ApplyDate=arr[14]
			var ApplyAppedTimes=arr[15]
			var ApplyNoAppTimes=arr[16]
			var ApplyFinishTimes=arr[17]
			var ApplyNoFinishTimes=arr[18]
			var OrdPrice=arr[19]
			var OrdBilled=arr[20]
			var UnitPrice=arr[21]
			var ApplyFinishUser=arr[22]
			var CureDate=arr[23]
			var CureDetail=arr[24]
			CureDetail=CureDetail.replace(/<br>/g," ")
		    xlsheet.cells(xlsrow,1)=PatientNo;
		    xlsheet.cells(xlsrow,2)=PatientName;
		    xlsheet.cells(xlsrow,3)=PatientSex;
		    xlsheet.cells(xlsrow,4)=PatientAge;		    
		    xlsheet.cells(xlsrow,5)=ArcimDesc;
		    xlsheet.cells(xlsrow,6)=UnitPrice;
		    xlsheet.cells(xlsrow,7)=OrderQty+"/"+BillingUOM;
		    xlsheet.cells(xlsrow,8)=OrdPrice;
		    xlsheet.cells(xlsrow,9)=OrdBilled;
		    xlsheet.cells(xlsrow,10)=OrderReLoc;
			xlsheet.cells(xlsrow,11)=CureDetail;
			xlsheet.cells(xlsrow,12)=ApplyFinishUser;
			xlsheet.cells(xlsrow,13)=ApplyStatus;
	    }
	    //xlsheet.printout;
	    gridlist(xlsheet,4,xlsrow,1,13)
		xlsheet.printout;
		//xlApp.ActiveWorkBook.Saved = false;
		//alert(1)
		xlBook.Close (savechanges=false);
		//alert(12)		
		//xlApp.Visible=false;
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;*/
	}catch(e){
		alert(e.message);	
	}
}

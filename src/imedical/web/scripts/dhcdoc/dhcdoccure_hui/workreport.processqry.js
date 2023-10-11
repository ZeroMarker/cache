var CureProcessDataGrid;
$(document).ready(function(){
	Init();
  	InitEvent();
  	CureProcessDataGridLoad();
});

function Init(){
	var CureStatusData=[{
			Code: 'F',
			Desc: $g('��ִ��')
		},{
			Code: 'C',
			Desc: $g('����ִ��')
		},{
			Code: 'D',
			Desc: $g('ִֹͣ��')
		},{
			Code: 'ALL',
			Desc: $g('ȫ��')
		}
	] 
	if(ServerObj.CureAppVersion=="V1"){
		CureStatusData.push({
			Code: 'I',
			Desc: $g('ԤԼ')
		})	
		CureStatusData.push({
			Code: 'C',
			Desc: $g('ȡ��ԤԼ')
		})	
		CureStatusData.push({
			Code: 'E',
			Desc: $g('ֱ��ִ��')
		})	
	}
	$HUI.combobox('#CureStatus',{       
    	valueField:'Code',   
    	textField:'Desc',
    	data: CureStatusData
	});
	
	InitDate();
  	InitLoc(); 
  	InitResGroup();
  	InitArcimDesc(); 
  	InitCureProcessDataGrid();	
}

function InitEvent(){
	$('#btnFind').click(function(){
		   CureProcessDataGridLoad();
    });
    
    $('#btnClear').click(function(){
		   ClearClickHandle();
    });
    
    $('#btnExport').bind('click', function(){
		   ExportCureProcess();
    });
	
	$('#btnPrint').bind('click', function(){
		   PrintCureProcess();
    });
}

function ClearClickHandle(){
	InitDate();
	$('#CureStatus,#ResGroup').combobox('setValue',"");
	$HUI.lookup("#ComboArcim").setText("");
    PageSizeItemObj.m_SelectArcimID="";    	
}

function InitCureProcessDataGrid()
{
	CureProcessDataGrid=$('#tabCureProcessList').datagrid({  
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
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true, 
		idField:"DCAARowId",
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
				//{field:'RowCheck',checkbox:true},     
				{field:'PatNo',title:'�ǼǺ�',width:90},   
				{field:'PatName',title:'��������',width:80},   
				{field:'PatSex',title:'�Ա�',width:40},
				{field:'PatAge',title:'����',width:50},
				{field:'PatTel',title:'��ϵ�绰',width:100},
				{field:'PAAdmWard',title:'���߲���',width:100},
				{field:'PAAdmBed',title:'����',width:80},
				{field:'ApplyNo',title:'�������뵥��',width:110},
				{field:'ArcimDesc',title:'������Ŀ',width:150},
				{field:'ApplyStatus',title:'����״̬',width:80},
				{field:'OrdReLoc',title:'���տ���',width:100},   
				{field:'ApplyAppInfo',title:'ԤԼ��ϸ',width:150},
				{field:'AppointStatus',title:'����״̬',width:80},
				{field:'RecordInfo',title:'���ƽ��',width:120},
				{field:'ApplyInfo',title:'�ǼǼ�¼',width:150}, 
				{field:'IStatusInfo',title:'ԤԼ��¼',width:150},
				{field:'CStatusInfo',title:'ȡ��ԤԼ��¼',width:150},
				{field:'AStatusInfo',title:'������ɼ�¼',width:150},
				{field:'Job',title:'Job',width:30,hidden:true},
				{field:'DCAARowId',title:'DCAARowId',width:50,hidden:true}  	   
			 ]] 
	});
}
function CureProcessDataGridLoad()
{
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var queryLoc=session['LOGON.CTLOCID'];
	//$("#ComboLoc").combogrid("getValues");
	var queryStatus=$("#CureStatus").combogrid("getValue");
	//var queryArcim=$("#ComboArcim").combogrid("getValue");
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
	var queryArcim=PageSizeItemObj.m_SelectArcimID;
	var queryGroup=$('#ResGroup').combobox('getValue');
	var SessionStr="^" + com_Util.GetSessionStr();
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"QryCureProcess",
		StartDate:StartDate,
		EndDate:EndDate,
		UserID:session['LOGON.USERID'],
		queryLoc:queryLoc,
		queryStatus:queryStatus,
		queryArcim:queryArcim,
		queryGroup:queryGroup,
		EpisodeID:ServerObj.EpisodeID,
		SessionStr:SessionStr,
		Pagerows:CureProcessDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureProcessDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function ExportCureProcess(){
	try{
		var UserID=session['LOGON.USERID'];
		var RowIDs=CureProcessDataGrid.datagrid('getRows');
		//if(RowIDs.length)
		var RowNum=RowIDs.length;
		if(RowNum==0){
			$.messager.alert("��ʾ","δ����Ҫ����������");
			return false;
		}
		CureProcessDataGrid.datagrid('selectRow',0);
		var ProcessNo=""
		var row = CureProcessDataGrid.datagrid('getSelected');
		if (row){
			ProcessNo=row.Job
		}
		if(ProcessNo==""){
			$.messager.alert("��ʾ","��ȡ���̺Ŵ���");
			return false;
		}
		var datacount=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetWorkReportNum",ProcessNo,UserID);
		if(datacount==0){
			$.messager.alert("��ʾ","��ȡ�������ݴ���");
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
	    	var StartDateArr=StartDate.split("/");
	    	var StartDate=StartDateArr[2]+"-"+StartDateArr[0]+"-"+StartDateArr[1];
    	}
		//var EndDate=$("#EndDate").datebox("getValue");
		//var EndDateArr=EndDate.split("/");
    	//var EndDate=EndDateArr[2]+"-"+EndDateArr[0]+"-"+EndDateArr[1];
    	var DateStr=StartDate //+"��"+StartDate
    	//alert(DateStr)
    	xlsheet.cells(2,10)=DateStr;
    	//var LocStr=$("#ComboLoc").combogrid("getText");
    	//var LocStrArr=LocStr.split("-");
    	//xlsheet.cells(2,13)=LocStr;
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
		xlsheet=null;
	}catch(e){
		alert(e.message);	
	}
}


function PrintCureProcess(){
	try{
		var UserID=session['LOGON.USERID'];
		var RowIDs=CureProcessDataGrid.datagrid('getRows');
		//if(RowIDs.length)
		var RowNum=RowIDs.length;
		if(RowNum==0){
			$.messager.alert("��ʾ","δ����Ҫ����������");
			return false;
		}
		CureProcessDataGrid.datagrid('selectRow',0);
		var ProcessNo=""
		var row = CureProcessDataGrid.datagrid('getSelected');
		if (row){
			ProcessNo=row.Job
		}
		if(ProcessNo==""){
			$.messager.alert("��ʾ","��ȡ���̺Ŵ���");
			return false;
		}
		var datacount=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetWorkReportNum",ProcessNo,UserID);
		if(datacount==0){
			$.messager.alert("��ʾ","��ȡ�������ݴ���");
			return false;
		}
		var xlApp,xlsheet,xlBook;
		var TemplatePath=ServerObj.PrintBath+"DHCDocCureWorkReportPrt.xlsx";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(TemplatePath);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
    	
    	var StartDate=$("#StartDate").datebox("getValue");
    	//var StartDateArr=StartDate.split("/");
    	//var StartDate=StartDateArr[2]+"-"+StartDateArr[0]+"-"+StartDateArr[1];
		//var EndDate=$("#EndDate").datebox("getValue");
		//var EndDateArr=EndDate.split("/");
    	//var EndDate=EndDateArr[2]+"-"+EndDateArr[0]+"-"+EndDateArr[1];
    	var DateStr=StartDate //+"��"+StartDate
    	xlsheet.cells(2,8)=DateStr;
    	//var LocStr=$("#ComboLoc").combogrid("getText");
    	//var LocStrArr=LocStr.split("-");
    	//xlsheet.cells(2,13)=LocStr;
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
		xlsheet=null;
	}catch(e){
		alert(e.message);	
	}
}
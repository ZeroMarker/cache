var CureReportDataGrid;
$(document).ready(function(){
	Init();
	InitEvent();
	CureReportDataGridLoad();
});
function Init(){
	InitDate();
	InitDoc(); 
  	InitArcimDesc(); 
  	InitCureReportDataGrid();	
}

function InitEvent(){
	$('#btnFind').bind('click', function(){
		CureReportDataGridLoad();
    });
    
    $('#btnExport').bind('click', function(){
		ExportCureReport();
    });
}

function InitCureReportDataGrid()
{
	CureReportDataGrid=$('#tabRecordReportList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,
		idField:"DCARowId",
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
				{field:'PatientNo',title:'���ߵǼǺ�',width:105,align:'left'},
				{field:'PatientName',title:'��������',width:85,align:'left'},
				{field:'PatientTel',title:'��ϵ�绰',width:85,align:'left'},
				{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left'},
				{field:'OrderDate',title:'��������',width:100,align:'left'},
				{field:'OrderLoc',title:'��������',width:100,align:'left'},
				{field:'OrderRecLoc',title:'ҽ�����տ���',width:115,align:'left'},   
				{field:'FinishUser',title:'ִ����',width:100,align:'left'},   
				//{field:'CureDate',title:'��������',width:100,align:'left'}, 
				{field:'ExcuteRet',title:'���ƽ��',width:150,align:'left'}, 	
				{field:'CureDate',title:'����ʱ��',width:100,align:'left'} ,
        		{field:'DCRResponse',title:'���Ʒ�Ӧ',width:150,align:'left'} ,
        		{field:'DCREffect',title:'����Ч��',width:150,align:'left'} ,			
				{field:'UnitPrice',title:'����(Ԫ)',width:80,align:'left'}, 
				{field:'OrderQty',title:'ִ������',width:85,align:'left'}, 
				{field:'OrdBillUOM',title:'��λ',width:80,align:'left'}, 
				{field:'OrdPrice',title:'�ܽ��(Ԫ)',width:105,align:'right'}, 
				{field:'Job',title:'Job',width:30,align:'left',hidden:true}   
			 ]] 
	});
}
function CureReportDataGridLoad()
{
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var queryLoc=""; //$("#ComboLoc").combogrid("getValues");
	var queryLocStr="";
	var queryDoc=$("#ComboDoc").combogrid("getValue");
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
	var queryArcim=PageSizeItemObj.m_SelectArcimID;
	var queryGroup=""; //$('#ResGroup').combobox('getValue');
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"QryRecordReport",
		'StartDate':StartDate,
		'EndDate':EndDate,
		'UserID':session['LOGON.USERID'],
		'queryLoc':queryLocStr,
		'queryDoc':queryDoc,
		'queryArcim':queryArcim,
		'queryGroup':queryGroup,
		'queryExcuteRet':"",
		Pagerows:CureReportDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureReportDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})	
	CureReportDataGrid.datagrid('unselectAll');
}
function ExportCureReport(){
	try{
		var Title="���Ƽ�¼���ͳ��"
		var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
		var queryLoc=""; //$("#ComboLoc").combogrid("getValues");
		var queryLocStr="";
		var queryDoc=$("#ComboDoc").combogrid("getValue");
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
		var queryArcim=PageSizeItemObj.m_SelectArcimID;
		var queryGroup=""; //$('#ResGroup').combobox('getValue');
		//����
		$cm({
			//dataType:'text',
			ResultSetType:'ExcelPlugin',
			ExcelName:Title,
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryRecordReportExport",
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryLoc':queryLocStr,
			'queryDoc':queryDoc,
			'queryArcim':queryArcim,
			'queryGroup':queryGroup,
			'queryExcuteRet':""
		});
		//location.href = rtn;		
		return;
		
		var UserID=session['LOGON.USERID'];
		var RowIDs=CureReportDataGrid.datagrid('getRows');
		//if(RowIDs.length)
		var RowNum=RowIDs.length;
		if(RowNum==0){
			$.messager.alert("��ʾ","δ����Ҫ����������");
			return false;
		}
		CureReportDataGrid.datagrid('selectRow',0);
		var ProcessNo=""
		var row = CureReportDataGrid.datagrid('getSelected');
		if (row){
			ProcessNo=row.Job
		}

		if(ProcessNo==""){
			$.messager.alert("��ʾ","��ȡ���̺Ŵ���");
			return false;
		}
		var datacount=tkMakeServerCall("DHCDoc.DHCDocCure.WordReport","GetQryRecordReportNum",ProcessNo,UserID);
		if(datacount==0){
			$.messager.alert("��ʾ","��ȡ�������ݴ���");
			return false;
		}
	
		var xlApp,xlsheet,xlBook;
		var TemplatePath=ServerObj.PrintBath+"DHCDocCureRecordReport.xlsx";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(TemplatePath);
	    
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
    	
    	var StartDate=$("#StartDate").datebox("getValue");
    	//var StartDateArr=StartDate.split("/");
    	//var StartDate=StartDateArr[2]+"-"+StartDateArr[0]+"-"+StartDateArr[1];
		var EndDate=$("#EndDate").datebox("getValue");
		//var EndDateArr=EndDate.split("/");
    	//var EndDate=EndDateArr[2]+"-"+EndDateArr[0]+"-"+EndDateArr[1];
    	var DateStr=StartDate+"��"+EndDate
    	xlsheet.cells(2,3)=DateStr;
    	var myret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetLocDesc",session['LOGON.CTLOCID']);
		var Title=myret+"���Ƽ�¼���ͳ��"
    	xlsheet.cells(1,1)=Title;
    	var xlsrow=3;
	    for(var i=1;i<=datacount;i++){
			var ret=tkMakeServerCall("DHCDoc.DHCDocCure.WordReport","GetQryRecordReportInfo",ProcessNo,i,UserID);
			if(ret=="") return ;
			//DCARowId_"^"_OrderReLoc_"^"_FinishUser_"^"_CureDate_"^"_ArcimDesc_"^"_UnitPrice
			//_"^"_OrderQty_"^"_OrdBillUOM_"^"_OrdPrice_"^"_PatientNo_"^"_PatientName_"^"_OrderLoc_"^"_PatientTel_"^"_OrdDate
			var arr=ret.split("^");
			xlsrow=xlsrow+1;
			var OrderReLoc=arr[1]
			var FinishUser=arr[2]
			var CureDate=arr[3]
			var ArcimDesc=arr[4]
			var UnitPrice=arr[5]
			var OrderQty=arr[6]
			var OrdBillUOM=arr[7]
			var OrdPrice=arr[8]
			var PatientNo=arr[9]
			var PatientName=arr[10]
			var OrderLoc=arr[11]
			var OrdDate=arr[13]
			var CureRecord=arr[14]
			xlsheet.cells(xlsrow,1)=PatientNo;
			xlsheet.cells(xlsrow,2)=PatientName;
			xlsheet.cells(xlsrow,3)=ArcimDesc;
			xlsheet.cells(xlsrow,4)=OrdDate;
			xlsheet.cells(xlsrow,5)=OrderLoc;
		    xlsheet.cells(xlsrow,6)=OrderReLoc;
		    xlsheet.cells(xlsrow,7)=FinishUser;
		    xlsheet.cells(xlsrow,8)=CureDate;
		    xlsheet.cells(xlsrow,9)=CureRecord;
		    //xlsheet.cells(xlsrow,5)=UnitPrice;
		    xlsheet.cells(xlsrow,10)=UnitPrice;
		    xlsheet.cells(xlsrow,11)=OrderQty+"/"+OrdBillUOM;
		    xlsheet.cells(xlsrow,12)=OrdPrice;
	    }
	    //xlsheet.printout;
	    gridlist(xlsheet,4,xlsrow,1,12)
		xlBook.Close (savechanges=true);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}catch(e){
		alert(e.message);	
	}
}
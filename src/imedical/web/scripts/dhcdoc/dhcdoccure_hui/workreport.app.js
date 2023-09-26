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
			Desc: 'ԤԼ����'
		},{
			Code: 'APPLY',
			Desc: '��������'
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
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCARowId",
		//pageNumber:0,
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
				{field:'PatNo',title:'�ǼǺ�',width:120, resizable: true},   
				{field:'PatName',title:'��������',width:80, resizable: true},   
				{field:'PatSex',title:'�Ա�',width:40, resizable: true},
				{field:'PatAge',title:'����',width:50, resizable: true},
				{field:'PatTel',title:'��ϵ�绰',width:100, resizable: true},
				{field:'CureDate',title:'��������',width:100, resizable: true}, 
				{field:'ArcimDesc',title:'������Ŀ',width:150, resizable: true},
				{field:'OrderAddDept',title:'�������',width:100, resizable: true},
				{field:'UnitPrice',title:'����',width:50, resizable: true}, 
				{field:'OrdQty',title:'����',width:40, resizable: true}, 
				{field:'OrdBillUOM',title:'��λ',width:40, resizable: true}, 
				{field:'OrdPrice',title:'�ܽ��(Ԫ)',width:80, resizable: true}, 
				{field:'OrdBilled',title:'�Ƿ�ɷ�',width:80, resizable: true}, 
				{field:'ApplyCureRecord',title:'ԤԼ��ϸ',width:200, resizable: true},
				{field:'OrdReLoc',title:'���տ���',width:100, resizable: true},   
				{field:'ApplyStatus',title:'���뵥״̬',width:80, resizable: true},
				{field:'ApplyFinishUser',title:'ִ����',width:80, resizable: true},
				{field:'Job',title:'Job',width:30,hidden:true},
				{field:'ApplyAppedTimes',title:'��ԤԼ����',width:80, resizable: true},
				{field:'ApplyNoAppTimes',title:'δԤԼ����',width:80, resizable: true},
				{field:'ApplyFinishTimes',title:'�����ƴ���',width:80, resizable: true},
				{field:'ApplyNoFinishTimes',title:'δ���ƴ���',width:80, resizable: true},		
				{field:'ApplyUser',title:'����ҽ��',width:80,hidden:true},
				{field:'ApplyDateTime',title:'����ʱ��',width:80,hidden:true},
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
		var Title=Hospital+"����ԤԼͳ��";
		
		//�첽����,ͬ����false
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
	    	//var StartDateArr=StartDate.split("/");
	    	//var StartDate=StartDateArr[2]+"-"+StartDateArr[0]+"-"+StartDateArr[1];
    	}
		//var EndDate=$("#EndDate").datebox("getValue");
		//var EndDateArr=EndDate.split("/");
    	//var EndDate=EndDateArr[2]+"-"+EndDateArr[0]+"-"+EndDateArr[1];
    	var EndDate=$("#EndDate").datebox("getValue");
    	var DateStr=StartDate+"��"+EndDate
    	xlsheet.cells(2,10)=DateStr;
    	xlsheet.cells(2,12)="";
    	var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+"����ԤԼͳ��";
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
		//��ӡ
		var PrintNum = 1; //��ӡ����
		var IndirPrint = "N"; //�Ƿ�Ԥ����ӡ
		var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+"����ԤԼͳ��";
		var TaskName=Title; //��ӡ��������
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
		var Title=Hospital+"����ԤԼͳ��";
		//����
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
		var DetailData=GridData.rows; //��ϸ��Ϣ
		if (DetailData.length==0) {
			$.messager.alert("��ʾ","û����Ҫ��ӡ������!");
			return false
		}
		//��ϸ��Ϣչʾ
		var Cols=[
			{field:"PatNo",title:"�ǼǺ�",width:"10%",align:"left"},
			{field:"PatName",title:"��������",width:"10%",align:"left"},
			{field:"PatSex",title:"�Ա�",width:"10%",align:"left"},
			{field:"PatAge",title:"����",width:"10%",align:"left"},
			{field:"CureDate",title:"��������",width:"10%",align:"left"},
			{field:"ArcimDesc",title:"������Ŀ",width:"10%",align:"left"},
			{field:"UnitPrice",title:"����(Ԫ)",width:"10%",align:"right"},
			{field:"OrdQty",title:"����",width:"10%",align:"right"},
			{field:"OrdPrice",title:"�ܽ��(Ԫ)",width:"10%",align:"right"},
			{field:"OrdBilled",title:"�Ƿ�ɷ�",width:"10%",align:"left"},
			{field:"OrdReLoc",title:"���տ���",width:"10%",align:"left"},
			{field:"ApplyAppedTimes",title:"��ԤԼ����",width:"10%",align:"right"},
			{field:"ApplyNoAppTimes",title:"δԤԼ����",width:"10%",align:"right"},
			{field:"ApplyFinishTimes",title:"�����ƴ���",width:"10%",align:"right"},
			{field:"ApplyNoFinishTimes",title:"δ���ƴ���",width:"10%",align:"right"},
			{field:"ApplyFinishUser",title:"ִ����",width:"10%",align:"left"},
			{field:"ApplyCureRecord",title:"ԤԼ��ϸ",width:"10%",align:"left"}
		];	
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
		
		/*var UserID=session['LOGON.USERID'];
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
    	var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+"����ԤԼͳ��";
    	xlsheet.cells(1,1)=Title;
    	var StartDate=$("#StartDate").datebox("getValue");
    	var EndDate=$("#EndDate").datebox("getValue");
    	//var StartDateArr=StartDate.split("/");
    	//var StartDate=StartDateArr[2]+"-"+StartDateArr[0]+"-"+StartDateArr[1];
		//var EndDate=$("#EndDate").datebox("getValue");
		//var EndDateArr=EndDate.split("/");
    	//var EndDate=EndDateArr[2]+"-"+EndDateArr[0]+"-"+EndDateArr[1];
    	var DateStr=StartDate+"��"+EndDate
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

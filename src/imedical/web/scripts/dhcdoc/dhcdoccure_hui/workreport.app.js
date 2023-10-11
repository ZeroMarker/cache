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
			Code: 'ANA',Desc: $g('����δԤԼ') //δԤԼ��һ��
		},{
			Code: 'ANC',Desc: $g('ԤԼδ����') //ԤԼ����δ����һ��
		},{
			Code: 'AC',Desc: $g('������') //����δ����
		},{
			Code: 'A',Desc: $g('ԤԼ(����δ����������)') //ANC+AC
		},{
			Code: 'C',Desc: $g('��ȡ��')
		},{
			Code: 'F',Desc: $g('�����')
		},{
			Code: 'ALL',Desc: $g('ȫ��')
		}]
    	//url:$URL+"?ClassName="+PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME+"&QueryName=FindCureStatus&ResultSetType=array",
	});
	var DateTypeObj=$HUI.combobox('#DateType',{     
    	valueField:'Code',   
    	textField:'Desc',
    	data: [{
			Code: 'APPOINT',Desc: $g('ԤԼ����')
		},{
			Code: 'APPLY',Desc: $g('��������')
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
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : 20,
		pageList : [20,50,100],
		columns :[
			[ 
				{field:'PatNo',title:'�ǼǺ�',width:120, resizable: false},   
				{field:'PatName',title:'��������',width:80, resizable: false},   
				{field:'PatSex',title:'�Ա�',width:40, resizable: false},
				{field:'PatAge',title:'����',width:50, resizable: false},
				{field:'PatTel',title:'��ϵ�绰',width:100, resizable: false},
				{field:'CureDate',title:'��������',width:100, resizable: false}, 
				{field:'ArcimDesc',title:'������Ŀ',width:150, resizable: false},
				{field:'OrderAddDept',title:'�������',width:100, resizable: false},
				{field:'UnitPrice',title:'����',width:50, resizable: false}, 
				{field:'OrdQty',title:'����',width:40, resizable: false}, 
				{field:'OrdBillUOM',title:'��λ',width:40, resizable: false}, 
				{field:'OrdPrice',title:'�ܽ��(Ԫ)',width:80, resizable: false}, 
				{field:'OrdBilled',title:'�Ƿ�ɷ�',width:80, resizable: false}, 
				{field:'ApplyCureRecord',title:'ԤԼ��ϸ',width:200, resizable: false},
				{field:'OrdReLoc',title:'���տ���',width:100, resizable: false},   
				{field:'ApplyStatus',title:'���뵥״̬',width:80, resizable: false},				
				{field:'ApplyAppedTimes',title:'��ԤԼ����',width:80, resizable: false},
				{field:'ApplyNoAppTimes',title:'δԤԼ����',width:80, resizable: false},
				{field:'ApplyFinishTimes',title:'�����ƴ���',width:80, resizable: false},
				{field:'ApplyNoFinishTimes',title:'δ���ƴ���',width:80, resizable: false},		
				{field:'ApplyUser',title:'����ҽ��',width:80,hidden:true},
				{field:'ApplyDateTime',title:'����ʱ��',width:80,hidden:true},
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
		var Title=Hospital+$g("����ԤԼͳ��");
		
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
	}catch(e){
		alert(e.message);	
	}
}

function PrintCureReport(){
	try{
		//��ӡ
		var PrintNum = 1; //��ӡ����
		var IndirPrint = "N"; //�Ƿ�Ԥ����ӡ
		var Hospital=""; //tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+$g("����ԤԼͳ��");
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
			{field:"PatSex",title:"�Ա�",width:"5%",align:"left"},
			{field:"PatAge",title:"����",width:"5%",align:"left"},
			{field:"CureDate",title:"��������",width:"10%",align:"left"},
			{field:"ArcimDesc",title:"������Ŀ",width:"10%",align:"left"},
			{field:"UnitPrice",title:"����(Ԫ)",width:"10%",align:"right"},
			{field:"OrdQty",title:"����",width:"10%",align:"right"},
			{field:"OrdPrice",title:"�ܽ��(Ԫ)",width:"10%",align:"right"},
			{field:"OrdBilled",title:"�Ƿ�ɷ�",width:"10%",align:"left"},
			{field:"OrdReLoc",title:"���տ���",width:"10%",align:"left"},
			{field:"ApplyStatus",title:"���뵥״̬",width:"10%",align:"left"},
			{field:"ApplyAppedTimes",title:"��ԤԼ����",width:"10%",align:"right"},
			{field:"ApplyNoAppTimes",title:"δԤԼ����",width:"10%",align:"right"},
			{field:"ApplyFinishTimes",title:"�����ƴ���",width:"10%",align:"right"},
			{field:"ApplyNoFinishTimes",title:"δ���ƴ���",width:"10%",align:"right"},
			{field:"ApplyCureRecord",title:"ԤԼ��ϸ",width:"15%",align:"left"}
		];	
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
	}catch(e){
		alert(e.message);	
	}
}

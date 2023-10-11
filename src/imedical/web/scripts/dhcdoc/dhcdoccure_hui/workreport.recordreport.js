var PageLogicObj={
	CureReportDataGrid:"",
	EChartObj:"",
	HasGifDocList:new Array(),		//�����Ƿ���ǩ��ͼƬ
	cspName:"doccure.workreport.recordreport.hui.csp"
}
$(document).ready(function(){
	Init();
	InitEvent();
});
function Init(){
	InitDate(ServerObj.CurrentDate);
	InitDoc(); 
	InitComboAdm();
  	InitArcimDesc(); 
  	
	var HospIdTdWidth=$("#HospIdTd").width()
	var opt={width:HospIdTdWidth}
	var hospComp = GenUserHospComp(opt);
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		ClearHandle();
		InitComboAdm();
  		InitArcimDesc(); 
		//PageLogicObj.CureReportDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',{total: 0, rows: []}); 
		CureReportDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess = function(e,t){
		InitCureReportDataGrid();
		CureReportDataGridLoad();
	}
}
function InitEvent(){
	$('#btnFind').click(function(){
		if ($("#patNo").val()!=""){
			PatNoHandle(CureReportDataGridLoad);
		}else{
			CureReportDataGridLoad();
		}	
	});
	$('#btnClear').click(function(){
		ClearHandle();
	})
	InitPatNoEvent(CureReportDataGridLoad);
	$('#ApplyNo').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			CureReportDataGridLoad();
		}
	});
}

function ClearHandle(){
	$("#PatMedNo,#patNo,#PatientID,#ApplyNo,#PAAdmID").val("");
	InitDate(ServerObj.CurrentDate);
	PageSizeItemObj.m_SelectArcimID="";    
	$("#ComboArcim").lookup('setText','');
	$("#ComboAdm").lookup('setText','');
	$("#ComboDoc").combobox('select','');	
}

function InitComboAdm()
{
	$("#ComboAdm").lookup({
       	url:$URL,
        mode:'remote',
        method:"Get",
        idField:'PaadmRowid',
        textField:'PaadmNo',
        columns:[[  
        	{field:'PaadmRowid',title:'',width:100,hidden:true},
			{field:'PatNo',title:'�ǼǺ�',width:100},
			{field:'PatName',title:'��������',width:100,sortable:true},
			{field:'Birth',title:'��������',width:95,sortable:true},
			{field:'PatSex',title:'�Ա�',width:40,sortable:true},
			{field:'PaadmNo',title:'�����',width:120,sortable:true},
			{field:'AdmTypeDesc',title:'��������',width:80,sortable:true},
			{field:'InPatFlag',title:'״̬',width:80,sortable:true},
			{field:'InPatLoc',title:'�������',width:120,sortable:true}
        ]], 
        pagination:true,
        panelWidth:600,
        isCombo:true,
        minQueryLen:1,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.DHCDocCure.WordReport',QueryName: 'patnamelookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
	        if(typeof(Util_GetSelHospID)=="function"){
				var UserHospID=Util_GetSelHospID(); //common.util.js
			}else{
				var UserHospID=Util_GetSelUserHospID();	
			}
			var ExpStr=UserHospID+"^"+session['LOGON.LANGID']+"^"+PageLogicObj.cspName;
			param = $.extend(param,{PatID:"",PatName:desc,HospDr:UserHospID,ExpStr:ExpStr});
	    },
	    onSelect:function(index, row){
		    $("#PAAdmID").val(row['PaadmRowid']);
		    CureReportDataGridLoad();
		},onHidePanel:function(){
            var gtext=$HUI.lookup("#ComboAdm").getText();
            if((gtext=="")){
	        	$("#PAAdmID").val("");
	        }
		}
    });  
};

function InitCureReportDataGrid()
{
	PageLogicObj.CureReportDataGrid=$('#tabRecordReportList').datagrid({  
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
		idField:"OEORERowID",
		pageSize : 20,
		pageList : [20,50,100],
		toolbar:[{
			id:'btnPrintCure',
			text:'���Ƶ���ӡ',
			iconCls:'icon-print',
			handler:function(){
				PrintCureReport();
			}
		},{
			id:'btnExport',
			text:'ȫ������',
			iconCls:'icon-export',
			handler:function(){
				ExportCureReport();
			}
		}],
		columns :[[ 
				{field:'PatientNo',title:'���ߵǼǺ�',width:105,align:'left'},
				{field:'PatientName',title:'��������',width:85,align:'left'},
				{field:'PatientTel',title:'��ϵ�绰',width:100,align:'left'},
				{field:'OrderDate',title:'��������',width:100,align:'left'},
				{field:'ApplyNo',title:'���뵥��',width:110,align:'left'},
				{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left'},
				{field:'FinishUser',title:'ִ����',width:100,align:'left'},   
				//{field:'CureDate',title:'��������',width:100,align:'left'}, 
				{field:'CureDate',title:'����ʱ��',width:100,align:'left'},
				{field:'DCRDetail',title:'��������',width:80,align:'left',
					formatter:function(value,row,index){
						if(row.DCRRowID!=""){
							return '<a href="###" '+'onclick=ShowCureDetail(\"'+row.DCRRowID+'\",\"'+row.DCRMapID+'\");>'+"<span class='fillspan-nosave'>"+$g("�����鿴")+"</span>"+"</a>"
						}else{
							return "";	
						}
					}
				},
				{field:'ExcuteRet',title:'���Ƽ�¼���',width:200,align:'left'}, 	
        		{field:'DCRResponse',title:'���Ʒ�Ӧ',width:200,align:'left'} ,
        		{field:'DCREffect',title:'����Ч��',width:200,align:'left'} ,
				{field:'OrderLoc',title:'��������',width:120,align:'left'},
				{field:'OrderRecLoc',title:'ҽ�����տ���',width:120,align:'left'},   			
				{field:'UnitPrice',title:'����(Ԫ)',width:80,align:'left'}, 
				{field:'OrderQty',title:'ִ������',width:85,align:'left'}, 
				{field:'OrdBillUOM',title:'��λ',width:80,align:'left'}, 
				{field:'OrdPrice',title:'�ܽ��(Ԫ)',width:105,align:'right'}, 
				{field:'Job',title:'Job',width:30,align:'left',hidden:true},   
				{field:'Adm',title:'Adm',width:30,align:'left',hidden:true},
				{field:'OEORERowID',title:'OEORERowID',width:30,align:'left',hidden:true},
				{field:'DCRRowID',title:'DCRRowID',width:30,align:'left',hidden:true},
				{field:'DCRMapID',title:'DCRMapID',width:30,align:'left',hidden:true}
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
	if(gtext==""){PageSizeItemObj.m_SelectArcimID=""};
	var queryArcim=PageSizeItemObj.m_SelectArcimID;
	var gtext=$HUI.lookup("#ComboAdm").getText();
	if(gtext==""){$("#PAAdmID").val("")};
	var queryAdmID=$("#PAAdmID").val();
	var queryPatID=$("#PatientID").val();
	var queryApplyNo=$("#ApplyNo").val();
	var ExpStr=PageLogicObj.cspName+ "^" + com_Util.GetSessionStr();
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"QryRecordReport",
		'StartDate':StartDate,
		'EndDate':EndDate,
		'UserID':session['LOGON.USERID'],
		'queryLoc':queryLocStr,
		'queryDoc':queryDoc,
		'queryArcim':queryArcim,
		'queryAdmID':queryAdmID,
		'queryPatID':queryPatID,
		'queryApplyNo':queryApplyNo,
		ExpStr:ExpStr,
		Pagerows:PageLogicObj.CureReportDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureReportDataGrid.datagrid('unselectAll');
		PageLogicObj.CureReportDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})	
}

function ShowCureDetail(DCRRowID,DCRMapID){
	if(DCRRowID==""){
		$.messager.alert('��ʾ','δ��ȡ�����Ƽ�¼ID��Ϣ!','warning');
		return false;
	}
	var argObj={
		DHCDocCureRecordLinkPage:"", //ServerObj.DHCDocCureRecordLinkPage,
		DCRRowId:DCRRowID,
		DCATempId:DCRMapID,
		PageShowFromWay:"ShowFromEmrList"
	}
	com_openwin.ShowCureRecordDiag(argObj);
}

function ExportCureReport(){
	try{
		var Title="���Ƽ�¼��"
		var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
        var queryLoc=""; //$("#ComboLoc").combogrid("getValues");
        var queryLocStr="";
		var queryDoc=$("#ComboDoc").combogrid("getValue");
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext==""){PageSizeItemObj.m_SelectArcimID=""};
		var queryArcim=PageSizeItemObj.m_SelectArcimID;
		var gtext=$HUI.lookup("#ComboAdm").getText();
		if(gtext==""){$("#PAAdmID").val("")};
		var queryAdmID=$("#PAAdmID").val();
		var queryPatID=$("#PatientID").val();
		var queryApplyNo=$("#ApplyNo").val();
		var ExpStr=PageLogicObj.cspName+ "^" + com_Util.GetSessionStr();
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
			'queryAdmID':queryAdmID,
			'queryPatID':queryPatID,
			'queryApplyNo':queryApplyNo,
			ExpStr:ExpStr
		});
		//location.href = rtn;		
		return;
	}catch(e){
		$.messager.alert("��ʾ",e.message,"error");
	}
}

function PrintCureReport(){
    try{
		var Title=$g("���Ƽ�¼��");
		var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
        var queryLoc=""; //$("#ComboLoc").combogrid("getValues");
        var queryLocStr="";
		var queryDoc=$("#ComboDoc").combogrid("getValue");
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext==""){PageSizeItemObj.m_SelectArcimID=""};
		var queryArcim=PageSizeItemObj.m_SelectArcimID;
		var gtext=$HUI.lookup("#ComboAdm").getText();
		if(gtext==""){$("#PAAdmID").val("")};
		var queryAdmID=$("#PAAdmID").val();
		var queryPatID=$("#PatientID").val();
		var queryApplyNo=$("#ApplyNo").val();		
		var ExpStr=PageLogicObj.cspName+ "^" + com_Util.GetSessionStr();
		var PrintNum = 1; //��ӡ����
		var IndirPrint = "N"; //�Ƿ�Ԥ����ӡ
		var TaskName=Title; //��ӡ��������
		
		var AdmArr=[];
		var ListData = PageLogicObj.CureReportDataGrid.datagrid('getData');
		for (i=0;i<ListData.originalRows.length;i++){
			var AdmId=ListData.originalRows[i].Adm;
			if(AdmArr.indexOf(AdmId)<0){
				AdmArr.push(AdmId);
			}
		}
				
		for(var i=0;i<AdmArr.length;i++){
			var queryAdmID=AdmArr[i];	
			var GridData=$.cm({
				ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
				QueryName:"QryRecordReportExport",
				'StartDate':StartDate,
				'EndDate':EndDate,
				'UserID':session['LOGON.USERID'],
				'queryLoc':queryLocStr,
				'queryDoc':queryDoc,
				'queryArcim':queryArcim,
				'queryAdmID':queryAdmID,
				'queryPatID':queryPatID,
				'queryApplyNo':queryApplyNo,
				ExpStr:ExpStr,
				Pagerows:PageLogicObj.CureReportDataGrid.datagrid("options").pageSize,
				rows:99999
			},false)	
			var DetailData=GridData.rows; //��ϸ��Ϣ
			if (DetailData.length==0) {
				$.messager.alert("��ʾ","û����Ҫ��ӡ������!","warning");
				return false;
			}
			var DetailData=getPrintInfo(DetailData);
			//��ϸ��Ϣչʾ
			var Cols=[
				{field:"DCRCureDate",title:"����",width:"8%",align:"center"},
                {field:"DCRCureTime",title:"ʱ��",width:"8%",align:"center"},
                {field:"ArcimDesc",title:"������Ŀ",width:"17%",align:"left"},
				{field:"ExcuteRet",title:"���Ƽ�¼",width:"47%",align:"left"},
				{field:"FinishUser",title:"ҽ��ǩ��",width:"10%",align:"center",imageFlag:true},
				{field:"PatientNameT",title:"����ǩ��",width:"10%",align:"center"}
			];	
			//var SubText="�Ʊ�:-  ����:-  �Ա�:-  ����:-  סԺ��:-";
			var SubText=$g("����Ʊ�")+":-  "+$g("����")+":-  "+$g("�Ա�")+":-  "+$g("����")+":-  "+$g("�ǼǺ�")+":-";
			SubText=$.cm({
				ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
				MethodName:"GetSubText",
				AdmID:queryAdmID,
				SessionStr:com_Util.GetSessionStr(),
				dataType:"text"
			},false)	
			PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData,{
				subText:SubText,
				hospTitle:"Y"	
			})
		}
		
    }catch(e){
		$.messager.alert("��ʾ",e.message,"error");
	}
}

function getPrintInfo(DetailData){
	
	for (var i=0;i<DetailData.length;i++){
		var userID=DetailData[i].CreateUserDR;
		if (userID!=""){
			if (typeof PageLogicObj.HasGifDocList[userID] =="undefined"){
				var GifFlag=getBase64Str(userID);
				PageLogicObj.HasGifDocList[userID]=GifFlag;
			}
			if (PageLogicObj.HasGifDocList[userID]!=''){
				DetailData[i].FinishUser=PageLogicObj.HasGifDocList[userID]; //"<img src='c://"+DetailData[i].CreateUserDR+".gif'>"
			}
		}
	}
	return DetailData;
}
function getBase64Str(USERID){
	var ImgBase64=tkMakeServerCall("web.UDHCPrescript","GetDocGifCode",USERID);
	if(ImgBase64!=""){
		ImgBase64='data:image/png;base64,'+	ImgBase64; //��jpg IE����
	}
	return ImgBase64
}
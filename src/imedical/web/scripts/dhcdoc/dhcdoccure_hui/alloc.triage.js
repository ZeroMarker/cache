var PageLogicObj={
	CureWorkListDataGrid:"",
	cspName:"doccure.alloc.triage.hui.csp"
}

$(function(){
	Init();
	InitEvent();
	PageHandle();
	//LoadCureAllocDataGrid(); ��ʼ���ݼ��طŵ�InitPerStatus onLoadSuccess��
});

function Init() {
	//InitCardType();
	InitServiceGroup();
	InitOrderDoc();
	InitPerStatus();
	InitTimeRange();
	PageLogicObj.CureWorkListDataGrid=InitCureWorkListDataGrid();
	$("#sttDate").datebox("setValue",ServerObj.CurrDateHtml);
	$("#endDate").datebox("setValue",ServerObj.CurrDateHtml);
}

function InitEvent() {
	$("#btnFind").click(LoadCureAllocDataGrid);
	$("#btnClear").click(ClearHandle);
	InitPatNoEvent(LoadCureAllocDataGrid);
	InitCardNoEvent(LoadCureAllocDataGrid);
}

function PageHandle() {	
	
}

function ClearHandle(){
	$('.search-table input[class*="validatebox"]').val("");
	$('.search-table input[type="checkbox"]').checkbox('uncheck');
	$('.search-table input[class*="combobox"]').combobox('select','');
	$("#sttDate,#endDate").datebox("setValue",ServerObj.CurrDateHtml);	
	$("#CardTypeNew,#CardNo,#cardNo,#patNo,#PatientID,#ApplyNo,#PatMedNo").val("");
	$("#PerStatus").combobox("setValue", ServerObj.DefPerState);
	$HUI.checkbox("#C_"+ServerObj.DefPerState).check();	
}

function InitCureWorkListDataGrid() {
	var cureWorkListToolBar = [{
			id:'BtnReport',
			text:'����',
			iconCls:'icon-check-reg',
			handler:function(){
				ReportCure();		 
			}
		},{
			id:'BtnCancelReport',
			text:'ȡ������',
			iconCls:'icon-cancel',
			handler:function(){
				CancelReportCure();		 
			}
		}
	];
	if(ServerObj.CureAppVersion=="V1"){
		var cureWorkListColumns=[[   
			{field: 'LocDesc', title:'����', width: 150, align: 'left', resizable: true},    
			{field: 'ResourceDesc', title: '��Դ', width: 80, align: 'left', resizable: true},
			{field: 'TimeDesc', title: 'ʱ��', width: 60, align: 'left', resizable: true},
			{field: 'StartTime', title: '��ʼʱ��', width: 80, align: 'left',resizable: true},
			{field: 'EndTime', title: '����ʱ��', width: 80, align: 'left',resizable: true},
			{field: 'ServiceGroupDesc', title: '������', width: 80, align: 'left',resizable: true},
			{field: 'DDCRSStatus', title: '�Ű�״̬', width: 80, align: 'left',resizable: true},
			{field: 'DCAAStatus', title: 'ԤԼ״̬', width: 80, align: 'left',resizable: true},
			{field: 'ReqUser', title: 'ԤԼ������', width: 80, align: 'left',resizable: true},
			{field: 'ReqDate', title: 'ԤԼ����ʱ��', width: 120, align: 'left',resizable: true},
			{field: 'LastUpdateUser', title: '������', width: 80, align: 'left',resizable: true,hidden: true},
			{field: 'LastUpdateDate', title: '����ʱ��', width: 80, align: 'left',resizable: true,hidden: true},
			{field: 'OEOREDR', title: 'ִ�м�¼ID', width: 60, align: 'left',hidden: true},
			{field: 'ServiceGroupID', title: '������', width: 60, align: 'left',hidden: true}
		 ]]
		var cureFrozenListColumns=[[
			{field:'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true}, 
			{field:'CureApplyNo',title:'���뵥��',width:110,align:'left'},   
			{field:'PatNo',title:'�ǼǺ�',width:100,align:'left'},   
			{field:'PatName',title:'����',width:80,align:'left'},   
			{field:'PatOther',title:'����������Ϣ',width:200,align:'left', resizable: true},
			{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left', resizable: true},
			//{field:'DCAAQty',title:'��������',width:70,align:'left', resizable: true},
			{field:'DDCRSDate', title:'ԤԼ��������', width: 100, align: 'left', resizable: true},
			{field:'DCASeqNo',title:'�Ŷ����',width:80,align:'left'},
			{field:'CallStatus', title: '�Ⱥ�״̬', width: 80, align: 'left',resizable: true},
			{field:'CallStatusCode', title: '�Ⱥ�״̬Code', width: 80, align: 'left',hidden: true},
		]]
	}else{
		cureWorkListToolBar.push({
			id:'BtnPrint',
			text:'��ӡ������',
			iconCls:'icon-print',
			handler:function(){
				PrintReportCure();		 
			}
		})
		var cureWorkListColumns=[[   
			{field: 'QueDate', title:'ԤԼ��������', width: 100, align: 'left', resizable: true},
			{field: 'QueLocDesc', title:'���ƿ���', width: 150, align: 'left', resizable: true},    
			{field: 'ResourceDesc', title: '������Դ', width: 100, align: 'left', resizable: true},
			{field: 'TimeRangeDesc', title: '����ʱ��', width: 150, align: 'left', resizable: true},
			{field: 'QueOperUser', title: 'ԤԼ������', width: 80, align: 'left',resizable: true},
			{field: 'QueInsertDate', title: 'ԤԼ����ʱ��', width: 160, align: 'left',resizable: true},
			{field: 'QueStatusUser', title: '��������', width: 80, align: 'left',resizable: true},
			{field: 'QueStatusDate', title: '������ʱ��', width: 160, align: 'left',resizable: true},
		 ]]
		var cureFrozenListColumns=[[
			{field:'Rowid', title: 'ID', width: 1, align: 'left', hidden:true}, 
			{field:'PatNo',title:'�ǼǺ�',width:100,align:'left'},   
			{field:'PatName',title:'����',width:80,align:'left'},   
			{field:'PatOther',title:'����������Ϣ',width:200,align:'left'},
			{field:'QueNo',title:'�Ŷ����',width:80,align:'left'},
			{field:'QueStatus', title: '����״̬', width: 80, align: 'left'},
			{field:'QueStatusCode', title: '����״̬Code',hidden: true},
			{field:'QueCallStatus', title: '����״̬',width: 90,
				formatter:function(value,row,index){
					if (value == "N"){
						return "<span class='fillspan-bg-skyblue'>"+$g("����")+"</span>";
					}else if (value == "Y"){
						return "<span class='fillspan-bg-lightgreen'>"+$g("���ں���")+"</span>";
					}else{
						return "";	
					}
				}
			}
		]]
	}
    			 
	var CureWorkListDataGrid=$('#tabCureWorkList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : true,
		nowrap: false,
		collapsible:false,
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true, 
		singleSelect : true,
		idField:"Rowid",
		pageSize : 20,
		pageList : [20,30,50],
		frozenColumns : cureFrozenListColumns,
		columns : cureWorkListColumns,
    	toolbar : cureWorkListToolBar
	});
	return CureWorkListDataGrid;
}

function LoadCureAllocDataGrid() {	
	var PatientID=$("#PatientID").val();
	var PerStatus="";
	var chkobj=$("input[type='checkbox']:checked");
	if(chkobj.length>0){
		var checkedId=$("input[type='checkbox']:checked")[0]["id"];
		var PerStatus=checkedId.split("_")[1];
		if(PerStatus==0)PerStatus="";
	}
	var PatMedNo=$("#PatMedNo").val();
	var CheckAdmType="",queryOrderLoc=""; //$("#ComboOrderLoc").combobox("getValue");
	if(ServerObj.CureAppVersion=="V1"){
		var sttDate=$('#sttDate').datebox('getValue');
		var endDate=$('#endDate').datebox('getValue');
		var ServiceGroup=$("#serviceGroup").combobox('getValue');
		var ApplyNo=$("#ApplyNo").val();
		var ExpStr="^"+session['LOGON.USERID']+ "^" + session['LOGON.HOSPID']+ "^" + session['LOGON.LANGID']+ "^" + PageLogicObj.cspName;
		var MethodParamObj={
			ClassName:"DHCDoc.DHCDocCure.Appointment",
			QueryName:"FindCurrentAppointmentListHUI",
			'LocId':session['LOGON.CTLOCID'],
			'UserId':session['LOGON.USERID'],
			'StartDate':sttDate,
			'EndDate':endDate,
			'QPatientID':PatientID,
			'ServiceGroupId':ServiceGroup,
			'QueryStatus':PerStatus,
			'QApplyNo':ApplyNo,
			'QPatMedNo':PatMedNo,
			'CheckAdmType':CheckAdmType,
			'queryArcim':"",
			'queryOrderLoc':queryOrderLoc,
			'allocFlag':"Y",
			'ExpStr':ExpStr,
		}
	}else{
		var queryResource=$("#Resource").combobox("getValue");
		var queryTimeRange=$("#TimeRange").combobox("getValue");
		var ReportFlag="Y",PatName="";
		var MethodParamObj={
			ClassName:"DHCDoc.DHCDocCure.Alloc",
			QueryName:"FindCureAllocList",
			qPatientID:PatientID, 
			qStatus:PerStatus, 
			qQueDate:"", 
			qTimeRange:queryTimeRange, 
			qResource:queryResource, 
			qExpStr:ReportFlag+"^"+PatName+"^"+PatMedNo, 
			SessionStr:PageLogicObj.cspName+"^"+com_Util.GetSessionStr(), 
		}
	}
	$.extend(MethodParamObj,{
		Pagerows:PageLogicObj.CureWorkListDataGrid.datagrid("options").pageSize,
		rows:99999	
	})
	$.cm(MethodParamObj,function(GridData){
		PageLogicObj.CureWorkListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		PageLogicObj.CureWorkListDataGrid.datagrid("clearSelections");
	});
}

function InitServiceGroup() {
	$HUI.combobox("#serviceGroup",{
	    valueField:'Rowid',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&ResultSetType=array",
	});
}

function InitTimeRange(){
	var HospDr=session['LOGON.HOSPID'];
	if($("#TimeRange").length>0){
		$HUI.combobox("#TimeRange",{
			valueField:'Rowid',   
			textField:'Desc',
			url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryBookTime&HospID="+HospDr+"&ResultSetType=array",
		})
	}
}

function InitOrderDoc(LocID){
	var LocID=session['LOGON.CTLOCID'];
	$HUI.combobox("#Resource",{
		valueField:'TRowid',   
    	textField:'TResDesc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+LocID+"&ResultSetType=array",
    	filter: function(q, row){
			return (row["TResDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}	
	})
}

function InitPerStatus() {
	$.q({
		ClassName:"DHCDoc.DHCDocCure.CureCall",
		QueryName:"CurePerStatusDataNew",
		dataType:"json"
	},function(Data) {
		var td = $("td[class='td-chk']"); 
		var splitLabel="<lable style='padding-right:5px'>&nbsp;</label>"
		var chkhtml="<input id='C_0' class='hisui-checkbox' type='checkbox' label='"+$g("ȫ��")+"'>"+splitLabel;
		$(".td-chk").append(chkhtml)
		var DataLen=Data["rows"].length;
		for (var i=0;i<DataLen;i++){
			var RowId=Data["rows"][i].RowId;
			var Desc=Data["rows"][i].ShowName;
			if (!Desc) Desc=Data["rows"][i].Desc;
			var chkhtml="<input id='C_"+RowId+"' class='hisui-checkbox' type='checkbox' label='"+$g(Desc)+"'>";
			if(i<(DataLen-1))chkhtml=chkhtml+splitLabel;
			$(".td-chk").append(chkhtml)
		}
		$.parser.parse($(".td-chk"));
		
		$HUI.checkbox(".hisui-checkbox",{
	        onChecked:function(e,value){
		        var id=e.target.id;
		        $(".hisui-checkbox").not("#"+id).checkbox('setValue',false);
		        setTimeout(function(){LoadCureAllocDataGrid();});
	        },onUnchecked:function(e,value){
		        var chkobj=$("input[type='checkbox']:checked");
				if(chkobj.length==0){
					setTimeout(function(){LoadCureAllocDataGrid();});
				}
	        }
	    });
	    if(ServerObj.DefPerState!=""){
			$HUI.checkbox("#C_"+ServerObj.DefPerState).check();	
		}
	})
}

function ReportCure() {
	if(ServerObj.CureAppVersion=="V1"){
		ReportCureV1();
		return;
	}
	var rowData = PageLogicObj.CureWorkListDataGrid.datagrid("getSelections");
	if (!rowData || rowData.length == 0) {
		$.messager.alert("����", "��ѡ��һλ���߱���.", 'error')
		return false;
	}
	var QueStr="", HasNoChecked=true;
	$.each(rowData,function(index,sel) {
		var QueId=sel.Rowid;
		var ReportStatusCode=sel.QueStatusCode;
		if (ReportStatusCode != "Report" && ReportStatusCode != "Pass") { //&& ReportStatusCode != "Complete"
			$.messager.alert("����", "����������״̬���߲��ܽ��б�������.", 'error')
			HasNoChecked=false;
			return false;
		}
		if (QueStr=="") QueStr=QueId;
		else  QueStr=QueStr+"^"+QueId;
	});
	if (!HasNoChecked) return false;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Alloc",
		MethodName:"UpdateBatch",
		QueStr:QueStr,
		StatusCode:"Wait",
		UserId:session['LOGON.USERID'],
		dataType:"text"
	},function(ret) {
		if (ret=="") {
			$.messager.popover({msg: '�����ɹ�',type:'success',timeout: 1000});
			LoadCureAllocDataGrid();
		}else {
			$.messager.alert("��ʾ", $g("����ʧ��,�������:")+ret, "error")
		}
	})
}
function CancelReportCure() {
	if(ServerObj.CureAppVersion=="V1"){
		CancelReportCureV1();
		return;
	}
	var rowData = PageLogicObj.CureWorkListDataGrid.datagrid("getSelections");
	if (!rowData || rowData.length == 0) {
		$.messager.alert("����", "��ѡ��һλ����ȡ������.", 'error')
		return false;
	}
	var QueStr="", HasNoChecked=true;
	$.each(rowData,function(index,sel) {
		var QueId=sel.Rowid;
		var ReportStatusCode=sel.QueStatusCode;
		if (ReportStatusCode != "Wait" && ReportStatusCode != "Pass") {
			$.messager.alert("����", "�Ⱥ򡢹���״̬���߲��ܽ���ȡ����������.", 'error')
			HasNoChecked=false;
			return false;
		}
		if (QueStr=="") QueStr=QueId;
		else  QueStr=QueStr+"^"+QueId;
	});
	if (!HasNoChecked) return false;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Alloc",
		MethodName:"UpdateBatch",
		QueStr:QueStr,
		StatusCode:"Report",
		UserId:session['LOGON.USERID'],
		dataType:"text"
	},function(ret) {
		if (ret=="") {
			$.messager.popover({msg: 'ȡ�������ɹ�',type:'success',timeout: 1000});
			LoadCureAllocDataGrid();
		}else {
			$.messager.alert("��ʾ", $g("ȡ������ʧ��,�������")+ret, "error")
		}
	})
}
function ReportCureV1(){
	var rowData = PageLogicObj.CureWorkListDataGrid.datagrid("getSelected");
	if (!rowData || rowData.length == 0) {
		$.messager.alert("����", "��ѡ��һλ�����ٱ���.", 'error')
		return false;
	}
	var DCAARowId=rowData.Rowid;
	var CallState=rowData.CallStatusCode;
	if (CallState != "Report" && CallState != "Pass" && CallState != "") {
		$.messager.alert("��ʾ", "����������״̬���߲��ܽ��б�������.", 'warning')
		return false;
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureCall",
		MethodName:"DHCDocCureReport",
		CallRowId:DCAARowId,
		Type:"Wait",
		SourceType:"AP",
		dataType:"text"
	},function(ret) {
		if (ret=="0") {
			$.messager.popover({msg: '�����ɹ�',type:'success',timeout: 1000});
			LoadCureAllocDataGrid();
		}else {
			$.messager.alert("��ʾ", "����ʧ��", "error")
		}
	})
}

function CancelReportCureV1() {
	var rowData = PageLogicObj.CureWorkListDataGrid.datagrid("getSelected");
	if (!rowData || rowData.length == 0) {
		$.messager.alert("����", "��ѡ��һλ�����ٽ���ȡ������.", 'error')
		return false;
	}
	var DCAARowId=rowData.Rowid;
	var CallState=rowData.CallStatusCode;
	if (CallState != "Wait") {
		$.messager.alert("��ʾ", "�Ⱥ�״̬���߲��ܽ���ȡ������.", 'warning')
		return false;
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureCall",
		MethodName:"DHCDocCureReport",
		CallRowId:DCAARowId,
		Type:"Report",
		SourceType:"AP",
		dataType:"text"
	},function(ret) {
		if (ret=="0") {
			$.messager.popover({msg: 'ȡ�������ɹ�',type:'success',timeout: 1000});
			LoadCureAllocDataGrid();
		}else {
			$.messager.alert("��ʾ", "ȡ������ʧ��", "error")
		}
	})
}

function PrintReportCure(){
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocCureAppReportPrt");
	var rowData = PageLogicObj.CureWorkListDataGrid.datagrid("getSelected");
	if (!rowData || rowData.length == 0) {
		$.messager.alert("����", "��ѡ��һλ���ߴ�ӡ.", 'info')
		return false;
	}
	var QueId=rowData.Rowid;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Alloc",
		MethodName:"GetPrintData",
		QueId:QueId,
		LogLocID:session['LOGON.CTLOCID'],
		LogUserID:session['LOGON.USERID'],
		dataType:"text"
	},function(ret){
		if (ret!="") {
			var Arr=ret.split(String.fromCharCode(1));
			DHC_PrintByLodop(getLodop(),Arr[0],Arr[1],"","");
		}else {
			$.messager.alert("��ʾ", "δ��ȡ��Ҫ��ӡ������!","error")
		}
	})	
}
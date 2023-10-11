var PageLogicObj={
	CureWorkListDataGrid:"",
	cspName:"doccure.alloc.triage.hui.csp"
}

$(function(){
	Init();
	InitEvent();
	PageHandle();
	//LoadCureAllocDataGrid(); 初始数据加载放到InitPerStatus onLoadSuccess中
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
			text:'报到',
			iconCls:'icon-check-reg',
			handler:function(){
				ReportCure();		 
			}
		},{
			id:'BtnCancelReport',
			text:'取消报到',
			iconCls:'icon-cancel',
			handler:function(){
				CancelReportCure();		 
			}
		}
	];
	if(ServerObj.CureAppVersion=="V1"){
		var cureWorkListColumns=[[   
			{field: 'LocDesc', title:'科室', width: 150, align: 'left', resizable: true},    
			{field: 'ResourceDesc', title: '资源', width: 80, align: 'left', resizable: true},
			{field: 'TimeDesc', title: '时段', width: 60, align: 'left', resizable: true},
			{field: 'StartTime', title: '开始时间', width: 80, align: 'left',resizable: true},
			{field: 'EndTime', title: '结束时间', width: 80, align: 'left',resizable: true},
			{field: 'ServiceGroupDesc', title: '服务组', width: 80, align: 'left',resizable: true},
			{field: 'DDCRSStatus', title: '排班状态', width: 80, align: 'left',resizable: true},
			{field: 'DCAAStatus', title: '预约状态', width: 80, align: 'left',resizable: true},
			{field: 'ReqUser', title: '预约操作人', width: 80, align: 'left',resizable: true},
			{field: 'ReqDate', title: '预约操作时间', width: 120, align: 'left',resizable: true},
			{field: 'LastUpdateUser', title: '更新人', width: 80, align: 'left',resizable: true,hidden: true},
			{field: 'LastUpdateDate', title: '更新时间', width: 80, align: 'left',resizable: true,hidden: true},
			{field: 'OEOREDR', title: '执行记录ID', width: 60, align: 'left',hidden: true},
			{field: 'ServiceGroupID', title: '服务组', width: 60, align: 'left',hidden: true}
		 ]]
		var cureFrozenListColumns=[[
			{field:'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true}, 
			{field:'CureApplyNo',title:'申请单号',width:110,align:'left'},   
			{field:'PatNo',title:'登记号',width:100,align:'left'},   
			{field:'PatName',title:'姓名',width:80,align:'left'},   
			{field:'PatOther',title:'患者其他信息',width:200,align:'left', resizable: true},
			{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true},
			//{field:'DCAAQty',title:'治疗数量',width:70,align:'left', resizable: true},
			{field:'DDCRSDate', title:'预约治疗日期', width: 100, align: 'left', resizable: true},
			{field:'DCASeqNo',title:'排队序号',width:80,align:'left'},
			{field:'CallStatus', title: '等候状态', width: 80, align: 'left',resizable: true},
			{field:'CallStatusCode', title: '等候状态Code', width: 80, align: 'left',hidden: true},
		]]
	}else{
		cureWorkListToolBar.push({
			id:'BtnPrint',
			text:'打印报到条',
			iconCls:'icon-print',
			handler:function(){
				PrintReportCure();		 
			}
		})
		var cureWorkListColumns=[[   
			{field: 'QueDate', title:'预约治疗日期', width: 100, align: 'left', resizable: true},
			{field: 'QueLocDesc', title:'治疗科室', width: 150, align: 'left', resizable: true},    
			{field: 'ResourceDesc', title: '治疗资源', width: 100, align: 'left', resizable: true},
			{field: 'TimeRangeDesc', title: '治疗时段', width: 150, align: 'left', resizable: true},
			{field: 'QueOperUser', title: '预约操作人', width: 80, align: 'left',resizable: true},
			{field: 'QueInsertDate', title: '预约操作时间', width: 160, align: 'left',resizable: true},
			{field: 'QueStatusUser', title: '最后更新人', width: 80, align: 'left',resizable: true},
			{field: 'QueStatusDate', title: '最后更新时间', width: 160, align: 'left',resizable: true},
		 ]]
		var cureFrozenListColumns=[[
			{field:'Rowid', title: 'ID', width: 1, align: 'left', hidden:true}, 
			{field:'PatNo',title:'登记号',width:100,align:'left'},   
			{field:'PatName',title:'姓名',width:80,align:'left'},   
			{field:'PatOther',title:'患者其他信息',width:200,align:'left'},
			{field:'QueNo',title:'排队序号',width:80,align:'left'},
			{field:'QueStatus', title: '报到状态', width: 80, align: 'left'},
			{field:'QueStatusCode', title: '报到状态Code',hidden: true},
			{field:'QueCallStatus', title: '呼叫状态',width: 90,
				formatter:function(value,row,index){
					if (value == "N"){
						return "<span class='fillspan-bg-skyblue'>"+$g("过号")+"</span>";
					}else if (value == "Y"){
						return "<span class='fillspan-bg-lightgreen'>"+$g("正在呼叫")+"</span>";
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
		loadMsg : '加载中..',  
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
		var chkhtml="<input id='C_0' class='hisui-checkbox' type='checkbox' label='"+$g("全部")+"'>"+splitLabel;
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
		$.messager.alert("错误", "请选择一位患者报到.", 'error')
		return false;
	}
	var QueStr="", HasNoChecked=true;
	$.each(rowData,function(index,sel) {
		var QueId=sel.Rowid;
		var ReportStatusCode=sel.QueStatusCode;
		if (ReportStatusCode != "Report" && ReportStatusCode != "Pass") { //&& ReportStatusCode != "Complete"
			$.messager.alert("错误", "报到、过号状态患者才能进行报到操作.", 'error')
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
			$.messager.popover({msg: '报到成功',type:'success',timeout: 1000});
			LoadCureAllocDataGrid();
		}else {
			$.messager.alert("提示", $g("报到失败,错误代码:")+ret, "error")
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
		$.messager.alert("错误", "请选择一位患者取消报到.", 'error')
		return false;
	}
	var QueStr="", HasNoChecked=true;
	$.each(rowData,function(index,sel) {
		var QueId=sel.Rowid;
		var ReportStatusCode=sel.QueStatusCode;
		if (ReportStatusCode != "Wait" && ReportStatusCode != "Pass") {
			$.messager.alert("错误", "等候、过号状态患者才能进行取消报到操作.", 'error')
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
			$.messager.popover({msg: '取消报到成功',type:'success',timeout: 1000});
			LoadCureAllocDataGrid();
		}else {
			$.messager.alert("提示", $g("取消报到失败,错误代码")+ret, "error")
		}
	})
}
function ReportCureV1(){
	var rowData = PageLogicObj.CureWorkListDataGrid.datagrid("getSelected");
	if (!rowData || rowData.length == 0) {
		$.messager.alert("错误", "请选择一位患者再报到.", 'error')
		return false;
	}
	var DCAARowId=rowData.Rowid;
	var CallState=rowData.CallStatusCode;
	if (CallState != "Report" && CallState != "Pass" && CallState != "") {
		$.messager.alert("提示", "报到、过号状态患者才能进行报到操作.", 'warning')
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
			$.messager.popover({msg: '报到成功',type:'success',timeout: 1000});
			LoadCureAllocDataGrid();
		}else {
			$.messager.alert("提示", "报到失败", "error")
		}
	})
}

function CancelReportCureV1() {
	var rowData = PageLogicObj.CureWorkListDataGrid.datagrid("getSelected");
	if (!rowData || rowData.length == 0) {
		$.messager.alert("错误", "请选择一位病人再进行取消操作.", 'error')
		return false;
	}
	var DCAARowId=rowData.Rowid;
	var CallState=rowData.CallStatusCode;
	if (CallState != "Wait") {
		$.messager.alert("提示", "等候状态患者才能进行取消报到.", 'warning')
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
			$.messager.popover({msg: '取消报到成功',type:'success',timeout: 1000});
			LoadCureAllocDataGrid();
		}else {
			$.messager.alert("提示", "取消报到失败", "error")
		}
	})
}

function PrintReportCure(){
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocCureAppReportPrt");
	var rowData = PageLogicObj.CureWorkListDataGrid.datagrid("getSelected");
	if (!rowData || rowData.length == 0) {
		$.messager.alert("错误", "请选择一位患者打印.", 'info')
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
			$.messager.alert("提示", "未获取需要打印的数据!","error")
		}
	})	
}
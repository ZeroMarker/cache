var PageLogicObj={
	m_APPCancelTabDataGrid:"",
	m_DocRowId:"",
	m_deptRowId:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	$("#CardNo").focus();
})
function InitEvent(){
	$("#readcard").click(ReadCardClickHandler);
	$("#Find").click(APPCancelTabDataGridLoad);
	$("#CardNo").change(CardNoChangeHandle);
	$("#RegNo").change(RegNoChangeHandle);
	$("#BSaveAppt").click(BSaveApptClickHandle);
	$("#Clean").click(CleanClickHandle);
	$(document.body).bind("keydown",BodykeydownHandler);
}
function PageHandle(){
	InitTimeRange();
	InitLoc();
	InitDoc();
	//挂号员
	LoadGhuse();
	if (ServerObj.vRBASID!=""){
		$("#RBAS").val(ServerObj.vRBASID);
		APPCancelTabDataGridLoad();
	}
	//预约类型
	InitAppPatType();
}
function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//回车事件或者
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("RegNo")>=0){
			RegNoKeydownHandler(e);
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			CardNoKeydownHandler(e);
			return false;
		}
		return true;
	}
	window.onhelp = function() { return false };
	return true;
}
function RegNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var RegNo=$("#RegNo").val();
		if (RegNo!="") {
			if (RegNo.length<10){
				for (var i=(10-RegNo.length-1); i>=0; i--) {
					RegNo="0"+RegNo
				}
			}
		}
		$("#RegNo").val(RegNo);
		var PatInfoStr=$.cm({
		    ClassName : "web.DHCOPAdmReg",
		    MethodName : "GetPatDetailBroker",
		    dataType:"text",
		    itmjs:"",
		    itmjsex:"GetPatDetailToHUI",
		    val:RegNo,
	    },false);
	    if (PatInfoStr!=""){
		    $("#PatientID").val(PatInfoStr.split("^")[6]);
		    APPCancelTabDataGridLoad();
		}else{
			return false();
		}
	}
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		CheckCardNo();
	}
}
function CheckCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return false;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
}
function CardNoKeyDownCallBack(myrtn){
	var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#PatientID").val(PatientID);
			$("#RegNo").val("");
			APPCancelTabDataGridLoad();	
			event.keyCode=13;			
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#PatientID").val(PatientID);
			$("#RegNo").val("");
			APPCancelTabDataGridLoad();	
			event.keyCode=13;
			break;
		default:
	}
}
function CardNoChangeHandle(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") {
		$("#PatientID,#CardTypeNew").val("");
	}
}
function SetPatientInfo(PatientNo,CardNo,PatientID){
	if (PatientNo!='') {
		$("#RegNo").val(PatientNo);
		$("#CardNo").val(CardNo);
		$("#PatientID").val(PatientID);
	}
}
function Init(){
	PageLogicObj.m_APPCancelTabDataGrid=InitAPPCancelTabDataGrid();
}
function InitAPPCancelTabDataGrid(){
	var toolbar=[{
		text:"取消预约",
		iconCls: 'icon-edit',
		handler: function(){CancelClickHandler()}
	},{
		text:"修改无卡预约信息",
		id:"ChangeApptInfo",
		iconCls: 'icon-write-order',
		handler: function(){ChangePatientInfoHandler()}
	}
	]
	var Columns=[[ 
		{field:'RowId',hidden:true,title:''},
		{field:'AppDate',title:'预约日期',width:100},
		{field:'DepDesc',title:'科室',width:100},
		{field:'DocDesc',title:'医生',width:105},
		{field:'SessType',title:'医生职称',width:105},
		{field:'MethodDesc',title:'预约方式',width:100},
		{field:'QueueNo',title:'诊号',width:50},
		{field:'StatusDesc',title:'预约状态',width:80,
			styler: function(value,row,index){
				if (value!="已预约"){
					return 'background-color:red;color:white;';
				}
			}
		},
		{field:'StatusChangeDate',title:'取号/取消日期',width:100},
		{field:'StatusChangeTime',title:'取号/取消时间',width:100},
		{field:'StatusChangeUserName',title:'取号/取消办理人',width:110},
		{field:'PatientName',title:'患者姓名',width:80},
		{field:'Sum',title:'金额',width:50,align:'right'},
		//{field:'ReasonForCancel',title:'取消预约原因',width:200},
		{field:'RBASStatusDesc',title:'医生状态',width:140,},
		{field:'RBASStatusReason',title:'停替诊原因',width:100},
		{field:'TRDoc',title:'替诊医生',width:80},
		{field:'PAPERTel',title:'预约人电话',width:150,align:'center'},
		{field:'CardCommonAppInfo',title:'公共卡预约信息',width:200},
		{field:'EmployeeFunction',title:'患者级别',width:100},
		{field:'SecretLevel',title:'患者密级',width:100} 
    ]]
	var APPCancelTabDataGrid=$("#APPCancelTab").datagrid({
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
		idField:'RowId',
		columns :Columns,
		toolbar:toolbar,
		onSelect:function(rowIndex, rowData){
			if (rowData["CardCommonAppInfo"]!=""){
				$("#ChangeApptInfo").linkbutton("enable");
			}else{
				$("#ChangeApptInfo").linkbutton("disable");
			}
		},
		onRowContextMenu:function(e, index, row){
			e.preventDefault(); //阻止浏览器捕获右键事件
			PageLogicObj.m_APPCancelTabDataGrid.datagrid("selectRow",index);
			setTimeout(function(){ShowGridRightMenu(e,index, row);});
		}
	});
	APPCancelTabDataGrid.datagrid('loadData', {"total":0,"rows":[]});
	return APPCancelTabDataGrid;
}
function APPCancelTabDataGridLoad(){
	if ($("#Find").hasClass('l-btn-disabled')){
		return false;
	}
	if ($("#Loc").lookup('getText')==""){
		PageLogicObj.m_deptRowId="";
	}
	if ($("#Doc").lookup('getText')==""){
		PageLogicObj.m_DocRowId="";
	}
	var vRBASID=$("#RBAS").val();
	if (vRBASID!=""){
		if (vRBASID.split("||").length<2){
			$.messager.alert("提示","预约序列号格式错误!请填写正确的序列号,如:1||2||3或1||2");
			return false;
		}
	}
	var StartDate=$HUI.datebox("#UpdateDate").getValue();
	var EndDate="";
	if (StartDate==""){
		StartDate=ServerObj.CurDay;
	}else{
		EndDate=StartDate;
	}
	var StatusStr="",NoArrive="",ArriveOn="",OnCancle=""
	if ($("#NoArrive").checkbox('getValue')==true){
		NoArrive="I"
	}
	if ($("#ArriveOn").checkbox('getValue')==true){
		ArriveOn="A"
	}
	if ($("#OnCancle").checkbox('getValue')==true){
		OnCancle="X"
	}	
	StatusStr=NoArrive+ArriveOn+OnCancle;
	DisableBtn("Find",true);
	$.q({
	    ClassName : "web.DHCRBAppointment",
	    QueryName : "Find",
	    AdmDepRowId:PageLogicObj.m_deptRowId,
	    AdmDocRowId:PageLogicObj.m_DocRowId,
	    StartDate:StartDate, EndDate:EndDate,
	    PatientNo:$("#RegNo").val(), PatientID:$("#PatientID").val(),
	    AppStatus:StatusStr, vRBASID:vRBASID, PatName:$("#PatName").val(),
	    PatTel:$("#PatTel").val(), PatCredNo:$("#PatCredNo").val(), TimeRangeRowID:$("#TimeRange").combobox('getValue'),
	    UpdateUser:$("#Ghuse").combobox('getValue'),
	    Pagerows:PageLogicObj.m_APPCancelTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_APPCancelTabDataGrid.datagrid('unselectAll');
		if ((GridData['rows'].length>0)&&(GridData['rows'][0]['RowId']=="")){
			PageLogicObj.m_APPCancelTabDataGrid.datagrid('loadData', {"total":0,"rows":[]});
		}else{
			PageLogicObj.m_APPCancelTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		}
		setTimeout(function(){
			DisableBtn("Find",false);
		})
	}); 
}
function InitTimeRange(){
	$.cm({
	    ClassName : "web.DHCOPAdmReg",
	    MethodName : "GetTimeRangeStr",
	    Flag:1,
	    dataType:"text"
	},function(data){
		var arr=new Array();
		for (var i=0;i<data.split("^").length;i++){
			var id=data.split("^")[i].split(String.fromCharCode(1))[0];
			var text=data.split("^")[i].split(String.fromCharCode(1))[1].split("-")[0];
			arr.push({"id":id,"text":text});
		}
		var cbox = $HUI.combobox("#TimeRange", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				data: arr,
		 });
	}); 
}
function InitLoc(){
	$("#Loc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'rowid',
        textField:'OPLocdesc',
        columns:[[  
            {field:'rowid',title:'',hidden:true},
			{field:'OPLocdesc',title:'科室名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:410,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCOPReg',QueryName: 'OPLoclookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc, hospid:session['LOGON.HOSPID']});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
			    PageLogicObj.m_deptRowId=rec["rowid"];
				$("#Doc").lookup('setText','');
				PageLogicObj.m_DocRowId="";
			});
		}
    });
}
function InitDoc(){
	$("#Doc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'rowid',
        textField:'OPLocdesc',
        columns:[[  
            {field:'rowid',title:'',hidden:true},
			{field:'OPLocdesc',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:410,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCOPRegReports',QueryName: 'OPDoclookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if ($("#Loc").lookup('getText')==""){
				PageLogicObj.m_deptRowId="";
			}
			param = $.extend(param,{locid:PageLogicObj.m_deptRowId,DocDesc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
			    PageLogicObj.m_DocRowId=rec["rowid"];
			});
		}
    });
}
function CancelClickHandler(){
	var row=PageLogicObj.m_APPCancelTabDataGrid.datagrid('getSelected');
	if (!row){
		$.messager.alert("提示","请选择需要取消预约的记录!");
		return false;
	}
	var ret=$.cm({
	    ClassName : "web.DHCRBAppointment",
	    MethodName : "CancelAppointment",
	    dataType:"text",
	    APPTRowId:row['RowId'], UserRowId:session['LOGON.USERID']
	},false);
	if (ret=="0"){
		$.messager.popover({msg: '取消预约成功!',type:'success'});
		APPCancelTabDataGridLoad();
	}else{
		if (ret=="-201") {
			$.messager.alert("提示","此预约已取号!");return false;
		}else if (ret=="-202") {
			$.messager.alert("提示","此预约已取消!");return false;
		}else if (ret=="-203") {
			$.messager.alert("提示","此预约已爽约!");return false;
		}
		$.messager.alert("提示","取消预约失败!"+"ErrCode:"+ret);
		return false;
	}
}
function ReadCardClickHandler(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function ChangePatientInfoHandler(){
	var row=PageLogicObj.m_APPCancelTabDataGrid.datagrid('getSelected');
	if (!row){
		$.messager.alert("提示","请选择需要修改信息的记录!");
		return false;
	}
	$("#Changeinfo-dialog").dialog("open");
	$("#TApptName").val(row['PatientName']);
	$("#TApptCredNo").val(row['CardCommonAppInfo'].split(":")[1]);
	$("#TApptPhone").val(row['PAPERTel']);
	$("#TAppPatType").combobox('select',row["AppPatTypeDr"]);
}
function BSaveApptClickHandle(){
	var row=PageLogicObj.m_APPCancelTabDataGrid.datagrid('getSelected');
	if (!row){
		$.messager.alert("提示","请选择需要修改信息的记录!");
		return false;
	}
	var TApptName=$("#TApptName").val();
	if (TApptName==""){
		$.messager.alert("提示","请填写预约人姓名!","info",function(){
			$("#TApptName").focus();
		});
		return false;
	}
	var TApptCredNo=$("#TApptCredNo").val();
	if (TApptCredNo==""){
		$.messager.alert("提示","请填写预约人身份证号!","info",function(){
			$("#TApptCredNo").focus();
		});
		return false;
	}else{
		var myIsID=DHCWeb_IsIdCardNo(TApptCredNo);
		if (!myIsID){
			$("#TApptCredNo").focus();
			return false;
		}
	}
	var TApptPhone=$("#TApptPhone").val();
	if (TApptPhone==""){
		$.messager.alert("提示","请填写预约人联系电话!","info",function(){
			$("#TApptPhone").focus();
		});
		return false;
	}else{
		if (!CheckTelOrMobile(TApptPhone,"TApptPhone","预约人联系电话")) return false;
	}
	var AppPatType=$('#TAppPatType').combobox('getValue');
	var ret=$.cm({
	    ClassName : "web.DHCRBAppointment",
	    MethodName : "UpDateApptInfo",
	    dataType:"text",
	    RBAppId:row['RowId'], AppPatCredNo:TApptCredNo,AppPatTel:TApptPhone,AppPatName:TApptName,AppPatType:AppPatType
	},false);
	if (ret=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});
		$("#Changeinfo-dialog").dialog("close");
		APPCancelTabDataGridLoad();
	}
}
function CheckTelOrMobile(telephone,Name,Type){
	if (telephone.length==8) return true;
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+"电话长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}
function LoadGhuse(){
	$.cm({
		ClassName:"web.DHCUserGroup",
		QueryName:"Finduse1",
		Desc:"",
		HOSPID:session['LOGON.HOSPID'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#Ghuse", {
				valueField: 'SSUSR_RowId',
				textField: 'SSUSR_Name', 
				editable:true,
				enterNullValueClear:false,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["SSUSR_Name"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["SSUSR_Initials"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
function RegNoChangeHandle(){
	var RegNo=$("#RegNo").val();
	if (RegNo=="") {
		$("#PatientID").val("");
	}
}
function CleanClickHandle(){
	$("#RBAS,#CardTypeNew,#CardNo,#Loc,#PatCredNo,#PatName,#PatTel,#RegNo,#Doc").val("");
	PageLogicObj.m_deptRowId=""
	PageLogicObj.m_DocRowId=""
	$("#TimeRange,#Ghuse").combobox('select',"");
	$HUI.datebox("#UpdateDate").setValue("")
	$("#OnCancle,#ArriveOn").checkbox('setValue',false); 
	$("#NoArrive").checkbox('setValue',true); 
}
function InitAppPatType(){
	var Patdata=[{"id":"1","text":"本人"},{"id":"2","text":"父母或子女"},{"id":"3","text":"其他关系"}]
	var cbox = $HUI.combobox("#TAppPatType", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: Patdata,
			onLoadSuccess:function(data){
				$HUI.combobox("#TAppPatType").setValue(1);
			}
	 });
}
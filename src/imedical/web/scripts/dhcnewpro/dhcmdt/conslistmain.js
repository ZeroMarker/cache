//===========================================================================================
// 作者：      qqa
// 编写日期:   2019-04-23
// 描述:	   会诊查询届满
//===========================================================================================

var showModel="1";
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// 页面初始化函数
function initPageDefault(){
		
	initCombobox();	  /// 初始化combobox
	
	initDatagrid();	  /// 初始化datagrid
	
	initMethod();     /// 绑定事件
	
	multi_Language(); /// 多语言支持
}

function initCombobox(){

	/// 开始日期
	$HUI.datebox("#startDate").setValue(GetCurSystemDate(-7));
	
	/// 结束日期
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
	
	/// 会诊状态
	$HUI.combobox("#consStatus",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetListMdtStatus&HospID="+ LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        qryConsList();
	    }	
	})	
	
	/// 疑难病种 
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+ LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        qryConsList();
	    }	
	})
	
	$("#bt_make").linkbutton('disable'); /// 处理按钮
	$("#bt_acc").linkbutton('disable');  /// 评估按钮
	$("#bt_exe").linkbutton('disable');  /// 执行按钮
}

function initDatagrid(){
	///  定义columns
	var columns=[[
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'疑难病种',width:140},
		{field:'PrvDesc',title:'号别',width:120},
		{field:'PreTime',title:'预约时间',width:180},
		{field:'PayMony',title:'收费状态',width:80,align:'center',formatter:
			function (value, row, index){
				if (value == "未收费"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstStatus',title:'会诊状态',width:80,align:'center',formatter:
			function (value, row, index){
				if (value == "撤销"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'isAccFlag',title:'是否接收',width:80,align:'center'},
		{field:'PatNo',title:'病人ID',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:60},
		{field:'PatAge',title:'年龄',width:60},
		{field:'PatLoc',title:'就诊科室',width:120},
		{field:'PatDiag',title:'诊断',width:140},
		{field:'CstRLoc',title:'申请会诊科室',width:120},
		{field:'CstRUser',title:'申请会诊医师',width:100},
		{field:'CstRTime',title:'申请时间',width:160},
		{field:'CstTrePro',title:'简要病历',width:400,formatter:SetCellField},
		{field:'CstPurpose',title:'会诊理由及要求',width:400,formatter:SetCellField},
		{field:'CstLocArr',title:'参加会诊科室',width:220},
		{field:'CstPrvArr',title:'参加会诊医师',width:220},
		{field:'CstNPlace',title:'会诊地点',width:200},
		{field:'PrintFlag',title:'打印',width:80,align:'center',formatter:
			function (value, row, index){
				if (row.PrintFlag.indexOf("Z")!=-1){return '<font style="color:green;font-weight:bold;">已打印</font>'}
				else {return '<font style="color:red;font-weight:bold;">未打印</font>'}
			}
		},
		{field:'ID',title:'ID',width:100},
		{field:'EpisodeID',title:'EpisodeID',width:100}
	]];
	
	var option = {
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			
			setConsNum(data); /// 绑定提示消息
		},
		onDblClickRow: function (rowIndex, rowData) {
			showMdtDetail(rowData.EpisodeID, rowData.ID);
        },
       	onClickRow:function (rowIndex, rowData) {
			// setEprFromData(rowData);
        },
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == "已审"){
				return 'background-color:pink;';
			}
		}
	};
	/// 就诊类型
	var param = getParams();
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetMdtQuery&Params="+param;
	new ListComponent('PatList', columns, uniturl, option).Init(); 
	
}

function showMdtDetail(EpisodeID,mdtID){
	var Link = "dhcmdt.write.csp?EpisodeID="+EpisodeID +"&ID="+mdtID; //+"&seeCstType=1";
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-paper',
		closed:"true"
	};

	$("#mdtPopFrame").attr("src",Link);
	new WindowUX($g('MDT会诊查看'), 'mdtPopWin', 950, (window.screen.availHeight - 150), option).Init();
	
}

function setConsNum(data){
	
	// 本人申请
	var cstUserNumText = $("#cstUserNum").linkbutton("options").text;
	if (cstUserNumText != ""){
		$('#cstUserNum').linkbutton({ text: cstUserNumText.split("(")[0] + "(" + data.IsCstUserNum +")" });
	}
	// 本人会诊
	var IsCsUserNumText = $("#csUserNum").linkbutton("options").text;
	if (IsCsUserNumText != ""){
		$('#csUserNum').linkbutton({ text: IsCsUserNumText.split("(")[0] + "(" + data.IsCsUserNum +")" });
	}
	// 本组会诊
	var cstUserNumText = $("#GroupUserNum").linkbutton("options").text;
	if (IsCsUserNumText != ""){
		$('#GroupUserNum').linkbutton({ text: cstUserNumText.split("(")[0] + "(" + data.IsGroupUserNum +")" });
	}

//	$("#cstUserNum").html("本人申请(" + data.IsCstUserNum +")");
//	$(".l-btn-text:contains('本人会诊')").html("本人会诊(" + data.IsCsUserNum +")");
//	$(".l-btn-text:contains('本组会诊')").html("本组会诊(" + data.IsGroupUserNum +")");	
	return;
}

function qrySelfSend(type){
	
	if(type=="1"){
		$('#bt_acc').linkbutton({text:$g('评估')});
		if($("#cstUserNum").hasClass("btn-select")) return;
		$("#csUserNum").removeClass("btn-select");
		$("#cstUserNum").addClass("btn-select");
		$("#GroupUserNum").removeClass("btn-select");
		$("#bt_cancel").linkbutton('enable');  /// 取消会诊按钮
		$("#bt_acc").linkbutton('disable');  /// 评估按钮
		$("#bt_exe").linkbutton('disable');  /// 执行按钮
		$("#bt_make").linkbutton('disable'); /// 处理按钮
		$("#bt_Revisionexp").linkbutton('enable');  /// 修改专家
		
		$("#bt_make").show(); /// 处理按钮
		$("#bt_acc").show();  /// 评估按钮
		$("#bt_exe").show();  /// 执行按钮	
		$("#bt_cancel").show();	
		$("#bt_Revisionexp").show();  /// 修改专家
	}
	
	if(type=="2"){
		$('#bt_acc').linkbutton({text:$g('评估')});
		if($("#csUserNum").hasClass("btn-select")) return;
		$("#cstUserNum").removeClass("btn-select");
		$("#csUserNum").addClass("btn-select");
		$("#GroupUserNum").removeClass("btn-select");
		$("#bt_Revisionexp").linkbutton('disable');  /// 修改专家
		$("#bt_exe").linkbutton('disable');
		$("#bt_acc").linkbutton('enable');  /// 评估按钮
		$("#bt_exe").linkbutton('enable');  /// 执行按钮
		$("#bt_make").linkbutton('enable'); /// 处理按钮
		
		$("#bt_make").show(); /// 处理按钮
		$("#bt_acc").show();  /// 评估按钮
		$("#bt_exe").show();  /// 执行按钮	
		$("#bt_cancel").show();
		$("#bt_Revisionexp").show();  /// 修改专家
	}
	
	if(type=="3"){
		if($("#GroupUserNum").hasClass("btn-select")) return;
		$("#cstUserNum").removeClass("btn-select");
		$("#csUserNum").removeClass("btn-select");
		$("#GroupUserNum").addClass("btn-select");
		$("#bt_Revisionexp").hide();  /// 修改专家
	    
		$("#bt_acc").hide();  /// 评估按钮
		$("#bt_exe").hide();  /// 执行按钮	
		$("#bt_cancel").hide();	
		$("#bt_make").hide();	
			
	}
	showModel = type;
	qryConsList();
	return;
}

function qryConsList(){
	var params = getParams();
	$("#PatList").datagrid("load",{"Params":params}); 
}

function getParams(){
	var params="";
	var stDate = $HUI.datebox("#startDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();
	var argLocID = "";
	var argPatNo = $("#regNo").val();
	var PatName = $("#PatName").val();
	var argDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	var consStatus = $HUI.combobox("#consStatus").getValue();
	
	var LgUserID  = session['LOGON.USERID'];
	params = stDate+"^"+endDate+"^"+argLocID+"^"+argPatNo+"^"+(argDisGrp||"")+"^"+(consStatus||"")+"^"+showModel+"^"+LgUserID +"^"+ PatName +"^^"+ HasCenter;
	return params;	
}

/// 登记号
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#regNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			$("#regNo").val(GetWholePatNo(PatNo));
		}
		qryConsList();  /// 查询
	}
}

///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCMDTCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// 处理特殊字符
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

function initMethod(){
	$("#regNo").bind('keypress',PatNo_KeyPress);
}


/// 病人信息
function PatBaseWin(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	var EpisodeID = rowData.EpisodeID; ///rowData.AppAdmID;
	var PatientID = rowData.PatientID;
	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择会诊记录后重试！","warning");
		return;
	}
	var mradm = "";
	/// 新版病历
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

function setEprFromData(rowData){
	var EpisodeID = rowData.AppAdmID;   //预约挂号
	var PatientID = rowData.PatientID;
	if(EpisodeID==""){
		return;	
	}
	setEprMenuForm (EpisodeID,PatientID,"","");
	return;
}

var setEprMenuForm = function(adm,papmi,mradm,canGiveBirth){
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		frm.mradm.value = mradm; 				//DHCDocMainView.EpisodeID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if (frm.canGiveBirth) frm.canGiveBirth.value = canGiveBirth;
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
}

function cancelMdtCons(){
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	if (rowData.CstStatus != "发送"){
		$.messager.alert('提示',"当前申请单非发送状态，不允许撤销会诊","error");
		return;
	}
	
//	if(rowData.PayMony=="已收费"){
//		$.messager.alert('提示',"当前申请单已经收费，不允许撤销会诊","error");
//		return;
//	}
	var CstID =  rowData.ID;
	$.messager.confirm('确认对话框','您确定要撤销当前会诊申请吗？', function(r){
		if (r){
			runClassMethod("web.DHCMDTConsult","CancelMdtCons",{"CstID":CstID, "LgParam":LgParam},function(jsonString){

				if (jsonString < 0){
					if(jsonString==-2) {
						$.messager.alert("提示:","当前状态非发送状态不允许撤销！");
					}else if(jsonString==-1){
						$.messager.alert("提示:","已收费申请不允许撤销，请填写退费申请！");
					}else if(jsonString==-3){
						$.messager.alert("提示:","医嘱已执行，请护士先撤消执行！");
					}else{
						$.messager.alert("提示:","撤销会诊失败，失败原因:"+jsonString);
					}
				}else{
					$.messager.alert("提示:","撤销成功！","info");
					qryConsList();
				}
			},'text',false)
		}
	});
}


/// 发送mdt申请
function mdtSend(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if (rowData.CstStatus != ""){
		$.messager.alert('提示',"当前状态不为保存状态，不允许发送！","error");
		return;
	}
	
	var EpisodeID = rowData.EpisodeID;
	var CstID = rowData.ID;
	
	/// 验证病人是否允许开医嘱
	TakOrdMsg = GetPatNotTakOrdMsg(EpisodeID);
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg,"warning");
		return;	
	}
	
	/// 诊断判断
	if (GetMRDiagnoseCount(EpisodeID) == 0){
		$.messager.alert("提示:","病人没有诊断,请先录入！","warning",function(){DiagPopWin()});
		return;	
	}
	
	/// 医疗结算判断
	if (GetIsMidDischarged(EpisodeID) == 1){
		$.messager.alert("提示:","此病人已做医疗结算,不允许医生再开医嘱！","warning");
		return;	
	}
	
	if (CstID == ""){
		$.messager.alert("提示:","请保存会诊申请后，再发送！","warning");
		return;
	}
	
	runClassMethod("web.DHCMDTConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam,"IpAddress":ClientIPAddress},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单已发送，不能再次发送！","warning");
			return;
		}
		if (jsonString < 0){
			if(jsonString==-12){
				$.messager.alert("提示:","会诊申请发送失败，失败原因病人已经具有当日此号别，不允许再次预约！","warning");		
			}
			$.messager.alert("提示:","会诊申请发送失败，失败原因:"+jsonString,"warning");
		}else{
			//isShowPageButton();     /// 动态设置页面显示的按钮内容
			$.messager.alert("提示:","发送成功！","info");
			qryConsList();
		}
	},'',false)
}


/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsg(EpisodeID){

	var NotTakOrdMsg = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

/// 获取病人的诊断记录数
function GetMRDiagnoseCount(EpisodeID){

	var Count = 0;
	/// 调用医生站的判断
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}

/// 获取医疗结算标志
function GetIsMidDischarged(EpisodeID){

	var MidDischargedFlag = 0;
	/// 调用医生站的判断
	runClassMethod("web.DHCAPPExaReport","GetIsMidDischarged",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			MidDischargedFlag = jsonString;
		}
	},'',false)

	return MidDischargedFlag;
}


/// 弹出诊断窗口
function DiagPopWin(){
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

/// 病例评估
function mdtHandleWin(FlagCode){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var stCode = "";  /// MDT申请状态
	if (FlagCode == "P") stCode = (HasCenter == 1)?"30":"20";
	if (FlagCode == "E") stCode = "40";
	if ((FlagCode != "L")&(GetIsOperFlag(rowData.ID, stCode) != "1")){
		$.messager.alert("提示:","申请单当前状态，不允许进行该操作！","warning");
		return;
	}
	
	var WriType=""; WidthFlag = 0; isShowModel = 1;
	if (FlagCode == "P") WriType = "P";
	if (FlagCode == "E") WriType = "E";
	if (FlagCode == "L") isShowModel = 3;
	var Link = "dhcmdt.execonclusion.csp?EpisodeID="+rowData.EpisodeID +"&ID="+rowData.ID +"&WriType="+WriType+"&showModel="+isShowModel;
	mdtPopWin(FlagCode, Link); /// 弹出MDT会诊处理窗口
}

/// 弹出MDT会诊处理窗口
function mdtPopWin(FlagCode, Link){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-w-paper',
		closed:"true"
	};
	if (FlagCode == "H"){
		new WindowUX($g('会诊处理'), 'newRefOpWin', 600, 290, option).Init();
	}else if (FlagCode == "R"){
		$("#mdtPopAccFrame").attr("src",Link);
		new WindowUX($g('MDT修改医生'), 'mdtPopAccWin', (window.screen.availWidth - 100), 520, option).Init();
	}else{
		$("#mdtPopAccFrame").attr("src",Link);
		var WinTitle = "";
		if (FlagCode == "L"){
			WinTitle = $g("会诊病历");
		}else{
			WinTitle = FlagCode == "P"?$g("评估"):$g("执行");
		}
		new WindowUX(WinTitle||$g('MDT病例评估'), 'mdtPopAccWin', 1100, (window.screen.availHeight - 150), option).Init();
	}
}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCMDTCom","GetCurSysTime",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// 接收
function AcceptCstNo(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if (rowData.CstStatus == "接收"){
		$.messager.alert('提示',"当前会诊已接收，不能重复接收!","error");
		return;
	}
	
//	if ((GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
//		$.messager.alert("提示:","申请单当前状态，不允许进行处理操作！","warning");
//		return;
//	}
	var stCode = (HasCenter == 1)?"30^40":"20^40";
	if (GetIsTakOperFlag(rowData.ID, stCode) != "1"){
		$.messager.alert("提示:","申请单当前状态，不允许进行该操作！","warning");
		return;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","AcceptCstMas",{"CstID":CstID, "LgUserID":LgUserID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非待接收状态，不允许进行接收操作！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","申请单已接收，不能再次接收！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请接收失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","接收成功！","info");
			$("#newRefOpWin").window("close");
			$('#PatList').datagrid('reload');
		}
	},'',false)	
}

/// 会诊处理
function mdtCsHandle(){

	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}

	var stCode = (HasCenter == 1)?"30^40":"20^40";
	if (GetIsTakOperFlag(rowData.ID, stCode) != "1"){
		$.messager.alert("提示:","申请单当前状态，不允许进行该操作！","warning");
		return;
	}
		
//	if ((GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
//		$.messager.alert("提示:","申请单当前状态，不允许进行处理操作！","warning");
//		return;
//	}
	
	$("#CstRefReason").val(rowData.CsDocRes);    /// 不能参加原因
	var FlagCode="H";
	mdtPopWin(FlagCode, ""); /// 弹出MDT会诊处理窗口
}

/// 拒绝参加会诊
function RefCstNo(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if ((GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
		$.messager.alert("提示:","申请单当前状态，不允许进行处理操作！","warning");
		return;
	}
	
	var CstRefReason = $("#CstRefReason").val(); /// 不能参加原因
	if (CstRefReason == ""){
		$.messager.alert('提示',"请填写，不能参加原因!","error");
		return;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","RefCstMas",{"CstID":CstID, "LgUserID":LgUserID, "CstNote":CstRefReason},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","您无权限操作当前该申请单！","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","申请单非待安排状态，不允许进行拒绝收操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","会诊申请拒绝失败，失败原因:"+jsonString,"warning");
		}else{
			//$.messager.alert("提示:","拒绝成功！","info");
			$("#CstRefReason").val("");    /// 不能参加原因
			$("#newRefOpWin").window("close");
			$('#PatList').datagrid('reload');
		}
	},'',false)	
}

/// 是否允许操作
function GetIsOperFlag(CstID, stCode){

	var IsModFlag = ""; /// 是否允许修改
	runClassMethod("web.DHCMDTConsult","GetIsOperFlag",{"CstID":CstID, "stCode":stCode},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// 是否允许操作
function GetIsTakOperFlag(CstID, stCodes){

	var IsModFlag = ""; /// 是否允许修改
	runClassMethod("web.DHCMDTConsult","GetIsTakOperFlag",{"CstID":CstID, "stCodes":stCodes},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// 子页面调用
function reLoadMainPanel(EpisodeID){
	
	$('#PatList').datagrid('reload');
	$("#mdtPopAccWin").window("close");
//	if (EpisodeID){
//		OpenEmr(EpisodeID);
//	}
}

/// 打开病人电子病历界面
function OpenEmr(EpisodeID){
	
	/// 新版病历
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 打印
function Print(){
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	var mCstID = rowData.ID;
	window.open("dhcmdt.printconsmdtopin.csp?CstID="+mCstID);
	
	$("#PatList").datagrid("reload");
	return;
}

/// 弹出MDT会诊处理窗口
function mdtHandle(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	if ((GetIsOperFlag(rowData.ID, "20") != "1")&(GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
		$.messager.alert("提示:","申请单当前状态，不允许进行此操作！","warning");
		return;
	}
	var Link=""
	Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID;

	mdtPopWin("R", Link); /// 弹出MDT会诊处理窗口
}

/// 修改专家
function modProWin(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if ((GetIsOperFlag(rowData.ID, "20") != "1")&(GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
		$.messager.alert("提示:","申请单当前状态，不允许进行此操作！","warning");
		return;
	}
	
	var Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID;
	commonShowWin({
		url: Link,
		title: $g("修改专家"),
		width: 1200,
		height: 590
	})	
}

/// 多语言支持
function multi_Language(){
	
	$g("提示");
	$g("请先选择一行记录!");
	$g("申请单当前状态，不允许进行此操作！");
	$g("会诊申请拒绝失败，失败原因:");
	$g("申请单非待安排状态，不允许进行拒绝收操作！");
	$g("您无权限操作当前该申请单！");
	$g("请填写，不能参加原因!");
	$g("申请单当前状态，不允许进行处理操作！");
	$g("申请单当前状态，不允许进行该操作！");
	$g("接收成功！");
	$g("会诊申请接收失败，失败原因:");
	$g("申请单已接收，不能再次接收！");
	$g("申请单非待接收状态，不允许进行接收操作！");
	$g("申请单当前状态，不允许进行该操作！");
	$g("发送成功！");
	$g("会诊申请发送失败，失败原因:");
	$g("会诊申请发送失败，失败原因病人已经具有当日此号别，不允许再次预约！");
	$g("申请单已发送，不能再次发送！");
	$g("请保存会诊申请后，再发送！");
	$g("此病人已做医疗结算,不允许医生再开医嘱！");
	$g("病人没有诊断,请先录入！");
	$g("当前状态不为保存状态，不允许发送！");
	$g("取消成功！");
	$g("撤销会诊失败，失败原因:");
	$g("已经预约成功的申请不允许撤销！");
	$g("当前状态非发送状态不允许撤销！");
	$g("您确定要取消当前会诊申请吗？");
	$g("确认对话框");
	$g("当前申请单已经收费，不允许撤销会诊");
	$g("当前申请单非发送状态，不允许撤销会诊");
	$g("请选择会诊记录后重试！");
	$g("错误提示");
	$g("登记号输入错误！");
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

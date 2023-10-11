//===========================================================================================
// 作者：      qqa
// 编写日期:   2019-04-23
// 描述:	   会诊查询届满
//===========================================================================================

var showModel="1";
var LgUserCode = session['LOGON.USERCODE'];  /// 
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var PageWidth=""     //弹出页面的宽度，自适应
var WinName=""
/// 页面初始化函数
function initPageDefault(){
	
	
	InitNorth();  //住院医生，侧菜单，按就诊查询
	getWidth()
		
	initCombobox();	  /// 初始化combobox
	
	initDatagrid();	  /// 初始化datagrid
	
	initMethod();     /// 绑定事件
	
	multi_Language(); /// 多语言支持
	
	initQuery();
	
	LoadMoreScr();
}

//住院医生，侧菜单，按就诊查询
function InitNorth(){
	if(window.name){ //侧菜单标识
		if(window.name=="idhcmdt_conslistmainIP"){
			WinName=1;
			//$('#myLayout').layout('remove','north');
		}
	}
	
}
function initQuery(){
	if(LgUserCode.indexOf("wyzj")!=-1){
		$("#csUserNum").click();
	}
}

function initCombobox(){

	/// 开始日期
	$HUI.datebox("#startDate").setValue(GetCurSystemDate(-7));
	
	/// 结束日期
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
	
	/// 会诊状态
	$HUI.combobox("#consStatus",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetListMdtStatus&HospID="+ LgHospID+"&MWToken="+websys_getMWToken(),
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        qryConsList();
	    }	
	})	
	
	/// 疑难病种 
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+ LgHospID+"&MWToken="+websys_getMWToken(),
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        qryConsList();
	    }	
	})
	
	/// 接替专家 
	$HUI.combobox("#mdtRepExpert",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LgLocID+"&MWToken="+websys_getMWToken(),
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        
	    }	
	})
	
	$("#bt_make").linkbutton('disable'); /// 处理按钮
	$("#bt_acc").linkbutton('disable');  /// 评估按钮
	$("#bt_exe").linkbutton('disable');  /// 执行按钮
	$("#bt_feedback").linkbutton('enable'); ///会诊反馈
	$("#bt_Reply").linkbutton('disable'); 	///会诊回复
	$("#bt_make").hide(); /// 处理按钮
	$("#bt_acc").hide();  /// 评估按钮
	$("#bt_exe").hide();  /// 执行按钮
	$("#bt_RevAcc").hide();  /// 取消评估
	$("#bt_RevExe").hide();  /// 取消执行
	$("#bt_Reply").hide();	 ///会诊回复
	$("#bt_conssig").hide();
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
				if ($g(value) == $g("未收费")){return '<font style="color:red;font-weight:bold;">'+$g(value)+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+$g(value)+'</font>'}
			}
		},
		{field:'CstStatus',title:'会诊状态',width:80,align:'center',formatter:
			function (value, row, index){
				if ($g(value) == $g("撤销")){return '<font style="color:red;font-weight:bold;">'+$g(value)+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+$g(value)+'</font>'}
			}
		},
		{field:'isAccFlag',title:'是否接收',width:80,align:'center'},
		{field:'AcceptNotes',title:'拒绝原因',width:140},
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
		{field:'OutHospConsDoc',title:'参加外院医师',width:220},
		{field:'CstNPlace',title:'会诊地点',width:200},
		{field:'PrintFlag',title:'告知单',width:80,align:'center',formatter:
			function (value, row, index){
				if (row.PrintFlag.indexOf("Z")!=-1){return '<font style="color:green;font-weight:bold;">'+$g("已打印")+'</font>'}
				else {return '<font style="color:red;font-weight:bold;">'+$g("未打印")+'</font>'}
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
			setTipMes();
		},
		onDblClickRow: function (rowIndex, rowData) {
			showMdtDetail(rowData.EpisodeID, rowData.PatientID, rowData.ID);
			return;
			if(!IsOpenMoreScreen){
				showMdtDetail(rowData.EpisodeID, rowData.PatientID, rowData.ID);	
			}
        },
       	onClickRow:function (rowIndex, rowData) {
			// setEprFromData(rowData);
			setMenuButton(rowData);
			openViceScreen(rowData.ID,rowData.EpisodeID,rowData.DisGrpID);
        },
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == "已审"){
				return 'background-color:pink;';
			}
		}
	};
	/// 就诊类型
	var param = getParams();
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetMdtQuery&Params="+param+"&MWToken="+websys_getMWToken();
	new ListComponent('PatList', columns, uniturl, option).Init(); 
	
}

function setTipMes(){
	if(!$("#tip").length){
		var html='<div id="tip" style="word-break:break-all;border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
		$('body').append(html);
	}
	
	/// 鼠标离开
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mousemove':function(){
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				//right:10+'px',
				//bottom:5+'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})	
}

/// 设置按钮状态
function setMenuButton(rowData){
	
	if ((showModel != 2)&&(showModel!=3)) return;
	
	if (rowData.stCode < 40){
		$("#bt_acc").show();     /// 评估
		$("#bt_RevAcc").hide();  /// 取消评估
	}else{
		$("#bt_acc").hide();     /// 评估
		$("#bt_RevAcc").show();  /// 取消评估
	}
	
	if (rowData.stCode < 80){
		$("#bt_exe").show();     /// 执行
		$("#bt_RevExe").hide();  /// 取消执行
	}else{
		$("#bt_exe").hide();     /// 执行
		$("#bt_RevExe").show();  /// 取消执行
	}
}

/// show MDT申请单
function showMdtDetail(EpisodeID,PatientID,mdtID){
	var Link = "dhcmdt.reqcontainer.csp?EpisodeID="+EpisodeID +"&PatientID="+PatientID+"&ID="+mdtID+"&MWToken="+websys_getMWToken(); //+"&seeCstType=1";
	commonShowWin({
		url: Link,
		title: 'MDT申请单',
		width: PageWidth,
		height: window.screen.availHeight - 120
	})	
}

function setConsNum(data){
	
	// 本人申请
	$('#cstUserCount').html("(" + data.IsCstUserNum +")");

	// 本科申请
	$('#cstLocCount').html("(" + data.IsCstLocNum +")");
	
	// 本人会诊
	$('#csUserCount').html("(" + data.IsCsUserNum +")");
	
	// 本组会诊
	$('#groupUserCount').html("(" + data.IsGroupUserNum +")");
	


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
		$("#cstLocNum").removeClass("btn-select");
		$("#bt_cancel").linkbutton('enable');  /// 取消会诊按钮
		$("#bt_acc").linkbutton('disable');  /// 评估按钮
		$("#bt_exe").linkbutton('disable');  /// 执行按钮
		$("#bt_make").linkbutton('disable'); /// 处理按钮
		$("#bt_Revisionexp").linkbutton('enable');  /// 修改专家
		$("#bt_feedback").linkbutton('enable'); ///会诊反馈
		$("#bt_Reply").linkbutton('disable'); 	///会诊回复
		$("#bt_make").hide(); /// 处理按钮
		$("#bt_acc").show();  /// 评估按钮
		$("#bt_exe").hide();  /// 执行按钮
		$("#bt_feedback").show(); ///会诊反馈
		$("#bt_Reply").hide(); 	 ///会诊回复
		$("#bt_conssig").hide();
		$("#bt_RevAcc").hide();  /// 取消评估
		$("#bt_RevExe").hide();  /// 取消执行
		
		$("#bt_cancel").show();	
		$("#bt_Revisionexp").show();  /// 修改专家
	}
	
	if(type=="2"){
		$('#bt_acc').linkbutton({text:$g('评估')});
		if($("#csUserNum").hasClass("btn-select")) return;
		$("#csUserNum").addClass("btn-select");
		$("#cstUserNum").removeClass("btn-select");
		$("#GroupUserNum").removeClass("btn-select");
		$("#cstLocNum").removeClass("btn-select");
		$("#bt_cancel").linkbutton('disable');  /// 取消会诊按钮
		$("#bt_Revisionexp").linkbutton('enable');  /// 修改专家
		$("#bt_exe").linkbutton('disable');
		$("#bt_acc").linkbutton('enable');  /// 评估按钮
		$("#bt_exe").linkbutton('enable');  /// 执行按钮
		$("#bt_make").linkbutton('enable'); /// 处理按钮
		$("#bt_feedback").linkbutton('disable'); ///会诊反馈
		$("#bt_Reply").linkbutton('enable'); 	 ///会诊回复
		$("#bt_cancel").hide();				///取消会诊
		$("#bt_Revisionexp").show();		///修改专家
		$("#bt_make").show(); /// 处理按钮
		$("#bt_acc").show();  /// 评估按钮
		$("#bt_exe").show();  /// 执行按钮	
		$("#bt_feedback").hide(); ///会诊反馈
		$("#bt_Reply").show(); 	 ///会诊回复
		$("#bt_conssig").show();
	}
	
	if(type=="3"){
		if($("#GroupUserNum").hasClass("btn-select")) return;
		$("#cstUserNum").removeClass("btn-select");
		$("#csUserNum").removeClass("btn-select");
		$("#GroupUserNum").addClass("btn-select");
		$("#cstLocNum").removeClass("btn-select");
		$("#bt_Revisionexp").hide();  /// 修改专家
	    
		$("#bt_acc").hide();  /// 评估按钮
		$("#bt_exe").hide();  /// 执行按钮	
		$("#bt_feedback").hide(); ///会诊反馈
		$("#bt_Reply").hide(); 	 ///会诊回复
		$("#bt_conssig").show();
		$("#bt_exe").show();     /// 执行
		$("#bt_RevAcc").hide();  /// 取消评估
		$("#bt_RevExe").hide();  /// 取消执行
		$("#bt_cancel").hide();	
		$("#bt_make").hide();		
		$("#bt_exe").linkbutton('enable');  /// 执行按钮
	}
	
	if(type=="4"){
		$('#bt_acc').linkbutton({text:$g('评估')});
		if($("#cstLocNum").hasClass("btn-select")) return;
		$("#csUserNum").removeClass("btn-select");
		$("#cstUserNum").removeClass("btn-select");
		$("#GroupUserNum").removeClass("btn-select");
		$("#cstLocNum").addClass("btn-select");
		$("#bt_cancel").linkbutton('enable');  /// 取消会诊按钮
		$("#bt_acc").linkbutton('disable');  /// 评估按钮
		$("#bt_exe").linkbutton('disable');  /// 执行按钮
		$("#bt_make").linkbutton('disable'); /// 处理按钮
		$("#bt_Revisionexp").linkbutton('enable');  /// 修改专家
		$("#bt_feedback").linkbutton('enable'); ///会诊反馈
		$("#bt_Reply").linkbutton('disable'); 	///会诊回复
		$("#bt_make").hide(); /// 处理按钮
		$("#bt_acc").show();  /// 评估按钮
		$("#bt_exe").hide();  /// 执行按钮
		$("#bt_feedback").show(); ///会诊反馈
		$("#bt_Reply").hide(); 	 ///会诊回复
		$("#bt_conssig").hide();
		$("#bt_RevAcc").hide();  /// 取消评估
		$("#bt_RevExe").hide();  /// 取消执行
		
		$("#bt_cancel").show();	
		$("#bt_Revisionexp").show();  /// 修改专家
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
	
	var checkedRadioJObj = $("input[name='stateOfCharge']:checked");
    var ChargeFlag=checkedRadioJObj.val();

	params = stDate+"^"+endDate+"^"+argLocID+"^"+argPatNo+"^"+(argDisGrp||"")+
			"^"+(consStatus||"")+"^"+showModel+"^"+LgUserID +"^"+ PatName +"^"+
			ChargeFlag+"^"+ HasCenter +"^"+ LgLocID +"^"+ LgHospID;
	
	if(WinName==1){
		var EpisodeID=""
		var frm = dhcsys_getmenuform();
		if((frm)){
				EpisodeID=frm.EpisodeID.value
			}
		params=params+"^"+EpisodeID;
	}
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
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID="+"&MWToken="+websys_getMWToken();
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
	var IsValid=GetIsTakOperFlagNew(rowData.ID,"10");
	if (IsValid!=0){
		$.messager.alert('提示',IsValid,"error");
		return;
	}
	
	if(rowData.CstRUserID!=LgUserID){
		$.messager.alert('提示','取消本人申请的申请单!','error');
		return;
	}
	
	var CstID =  rowData.ID;
	$.messager.confirm('确认对话框','您确定要撤销当前会诊申请吗？', function(r){
		if (r){
			runClassMethod("web.DHCMDTConsult","CancelMdtCons",{"CstID":CstID, "LgParam":LgParam},function(jsonString){

				if (jsonString != 0){
					$.messager.alert("提示:","失败,信息:"+jsonString,"info");
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
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

/// 病例评估:Out
function mdtHandleWin(FlagCode){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if(rowData.PayMony==="未收费"){
		if(FlagCode=="E"){
			$.messager.alert("提示:","未收费,禁止完成操作！","warning");
			return;
		}
	}
	
	var stCode = "";  /// MDT申请状态
	if (FlagCode == "P") stCode = (HasCenter != 0)?"30^35":"20^35";
	//if (FlagCode == "E") stCode = "40^75";
	if (FlagCode == "E"){
		var IsValid=GetIsTakOperFlagNew(rowData.ID,"80");
		if (IsValid!=0){
			$.messager.alert('提示',IsValid,"error");
			return;
		}
	}
	
	var WriType=""; WidthFlag = 0; isShowModel = 1;
	if (FlagCode == "P") WriType = "P";
	if (FlagCode == "E") WriType = "E";
	if (FlagCode == "L") isShowModel = 3;
	var Link = "dhcmdt.execonclusion.csp?EpisodeID="+rowData.EpisodeID +"&ID="+rowData.ID +"&WriType="+WriType+"&showModel="+isShowModel+"&MWToken="+websys_getMWToken();
	mdtPopWin(FlagCode, Link); /// 弹出MDT会诊处理窗口
}

function OpenConssig(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if(rowData.PayMony==="未收费"){
		$.messager.alert("提示:","未收费,禁止签到操作！","warning");
		return;	
	}

	var IsValid=GetIsTakOperFlagNew(rowData.ID,"70");
	if (IsValid!=0){
		$.messager.alert('提示',IsValid,"error");
		return;
	}
	var link = "dhcmdt.conssignin.csp?ID="+rowData.ID+"&MWToken="+websys_getMWToken();
	
	$("#mdtPopAccFrame").attr("src",link);	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-w-paper',
		closed:"true"
	};
	new WindowUX($g('会诊签到'), 'mdtPopAccWin', 800, (window.screen.availHeight - 350), option).Init();
}

/// 弹出MDT会诊处理窗口
function mdtPopWin(FlagCode, Link){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		onBeforeOpen:function(){
			if(FlagCode=="H"){
				ShowNowAccData();
			}
		},
		onClose:function(){
			if(FlagCode=="H"){
				ClearNowAccData();	
			}
		},
		iconCls:'icon-w-paper',
		closed:"true"
	};
	if (FlagCode == "H"){
		new WindowUX($g('会诊处理'), 'newRefOpWin', 600, 330, option).Init();
	}else if (FlagCode == "R"){
		$("#mdtPopAccFrame").attr("src",Link);
		new WindowUX($g('MDT修改医生'), 'mdtPopAccWin', (window.screen.availWidth - 100), 520, option).Init();
	}else{
		$("#mdtPopAccFrame").attr("src",Link);
		var WinTitle = "";
		if (FlagCode == "L"){
			WinTitle = $g("会诊病历");
		}else{
			WinTitle = FlagCode == "P"?$g("评估"):$g("完成");
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
	
	var IsValid=GetIsTakOperFlagNew(rowData.ID,"50");
	if (IsValid!=0){
		$.messager.alert('提示',IsValid,"error");
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
	
	if(rowData.PayMony===$g("未收费")){
		$.messager.alert("提示:","未收费,不允许接收或者拒绝操作！","warning");
		return;	
	}

	var itmCodes = "75^80"; /// 有无中心时，控制在何种状态下允许编辑
	if (GetIsTakOperFlag(rowData.ID, itmCodes)=="1"){
		$.messager.alert("提示:","申请单已经具有完成操作,不允许接收或者拒绝操作！","warning");
		return;
	}
	
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
	
	var IsValid=GetIsTakOperFlagNew(rowData.ID,"60");
	if (IsValid!=0){
		$.messager.alert('提示',IsValid,"error");
		return;
	}
	
	var MdtRepExp = $HUI.combobox("#mdtRepExpert").getText();
	
	var CstRefReason = $("#CstRefReason").val(); /// 不能参加原因
	if (CstRefReason == ""){
		$.messager.alert('提示',"请填写，不能参加原因!","error");
		return;
	}
	
	///接替专家
	if(MdtRepExp!=""){
		CstRefReason = CstRefReason +" 接替专家为："+ MdtRepExp;
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

/// 是否允许操作
function GetIsTakOperFlagNew(CstID, ToStCode){
	var Ret=$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"ValidStatus",
		ID:CstID,ToStatusIdCode:ToStCode,
		dataType:"text"
	}, false);
	return Ret;
}

/// 是否允许取消完成
function GetIsCompUser(CstID){
	///是否会诊完成人
	var isCompUserInfo=$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"IsCompUser",
		CstID:CstID,
		UserID:LgUserID,
		dataType:"text"
	}, false);
	return isCompUserInfo;

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
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID="+"&MWToken="+websys_getMWToken();
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
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
	Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID+"&MWToken="+websys_getMWToken();

	mdtPopWin("R", Link); /// 弹出MDT会诊处理窗口
}

/// 修改专家
function modProWin(){
	
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if(showModel=="1"){
		if (GetIsTakOperFlag(rowData.ID, "20^30") != "1"){ //if (GetIsOperFlag(rowData.ID, "20") != "1"){ //hxy 2022-02-17
			$.messager.alert("提示:","非发送和安排状态,不允许进行修改专家!","warning");
			return;
		}
	}
	
	///非本人申请
	if(showModel!="1"){
		var itmCodes = "75^80"; /// 有无中心时，控制在何种状态下允许编辑
		if (GetIsTakOperFlag(rowData.ID, itmCodes)=="1"){
			$.messager.alert("提示:","申请单已经具有完成操作,不允许修改会诊专家！","warning");
			return;
		}
	}
	
	var Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID+"&MWToken="+websys_getMWToken();
	commonShowWin({
		url: Link,
		title: $g("修改专家"),
		width: 1200,
		height: 590
	})	
}

// 取消评估:out
function mCancelEva(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var stCode = "40^75";
	if (GetIsTakOperFlag(rowData.ID, stCode) != "1"){
		$.messager.alert("提示:","申请单当前状态，不允许进行该操作！","warning");
		return;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","modConsultStatus",{"CstID":CstID, "stCodes":stCode, "userID":LgUserID, "WriType":"P"},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","申请单非评估状态，不允许进行取消评估操作！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","取消评估失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","取消评估成功！","info");
			$('#PatList').datagrid('reload');
		}
	},'',false)	
}

// 取消执行
function mCancelExe(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var IsValid=GetIsTakOperFlagNew(rowData.ID,"75");
	if (IsValid!=0){
		$.messager.alert('提示',IsValid,"error");
		return;
	}
	
	var IsCompUserInfo = GetIsCompUser(rowData.ID);
	var IsCompUser=IsCompUserInfo.split("^")[0];
	var CompUserName=IsCompUserInfo.split("^")[1];
	if((IsCompUser!=1)&&(CANCOMPSELF==1)){
		$.messager.alert("提示","非会诊完成人,不允许取消完成!完成人是:"+CompUserName,"error");
		return;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","modConsultStatus",{"CstID":CstID, "stCodes":"", "userID":LgUserID, "WriType":"E"},function(jsonString){
		
		if(jsonString==0){
			$.messager.alert("提示:","取消执行成功！","info");
			$('#PatList').datagrid('reload');		
		}else{
			$.messager.alert("提示:","失败,信息:"+jsonString,"warning");
		}
	},'',false)	
}


/// 资料审查
function matRev(){
	
    var rowData = $('#PatList').datagrid('getSelected');
    if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}

	
	var linkUrl ="dhcmdt.matreview.csp";
	if(IsOpenMoreScreen!="0") linkUrl="dhcmdt.mdtmodelwrite.csp";
		
	linkUrl+="?ID="+rowData.ID +"&mdtMakResID="+rowData.mdtMakResID+"&DisGrpID="+ rowData.DisGrpID+"&EpisodeID="+ rowData.EpisodeID+"&MWToken="+websys_getMWToken();
	
	commonShowWin({
		url: linkUrl,
		title: $g("资料审查"),
		width: $(window).width()-100,
		height: $(window).height() - 60
	})	
}

function ShowNowAccData(){
	var rowData = $('#PatList').datagrid('getSelected');
    if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	var CstID=rowData.ID;
	var Ret=$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"GetCsAcceptNotes",
		"ID":CstID,"LgUserID":LgUserID,
		dataType:"text"
	},function(Ret){
		var RetArr=Ret.split("^");
		RetArr[0]!=""?$("#NowStatus").html("("+RetArr[0]+")"):"";
		$("#CstRefReason").val(RetArr[1]);
	});
} 


function ClearNowAccData(){
	$("#NowStatus").html("");
	$("#CstRefReason").val("");
}

function mdtUpload(){
	var rowData = $('#PatList').datagrid('getSelected');
    if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	var lnk = "dhcmdt.uploadify.csp?MdtCstID="+rowData.ID+"&MWToken="+websys_getMWToken();
	commonShowWin({
		url: lnk,
		title: '上传查看文件',
		width:PageWidth,height:screen.availHeight-150,
	});
}

//会诊反馈/回复
function feedBackWin(flag){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var EpisodeID = rowData.EpisodeID; ///rowData.AppAdmID;
	var PatientID = rowData.PatientID;
	var CstID = rowData.ID

	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择会诊记录后重试！","warning");
		return;
	}
	
	
	
	var mradm = "";
	var title=(flag == "F"?"会诊反馈":"会诊回复");
	var itmCodes = "80"; /// 有无中心时，控制在何种状态下允许编辑
	if (GetIsTakOperFlag(rowData.ID, itmCodes)!="1"){
		$.messager.alert("提示:","申请单未完成,不允许"+title+"！","warning");
		return;
	}
	var link = "";
	var _wWidth=$(window).width()-100;
	var _wHeight=$(window).height()-150;
	
	if(flag == "F"){
		if(IsOpenMoreScreen) link="dhcmdt.waitinglistall.csp";
		if(!IsOpenMoreScreen) link="dhcmdt.folupmain.csp";
	}else{
		if(IsOpenMoreScreen) {
			link = "dhcmdt.reply.csp";
			_wWidth = 800;
		}
		if(!IsOpenMoreScreen) link = "dhcmdt.replymain.csp";
		
	}
	
	link=link+"?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&ID="+CstID+"&CstID="+CstID+"&MWToken="+websys_getMWToken();


	commonShowWin({
		url: link,
		title: $g("会诊反馈"),
		width:_wWidth,
		height: _wHeight,
		onClose: function(){
			var rowData = $HUI.datagrid("#PatList").getSelected();
			if(rowData){
				openViceScreen(rowData.ID,rowData.EpisodeID,rowData.DisGrpID);	
			}
		}
	})	
}


/// 打印
function Print(){
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if (GetIsOperFlag(rowData.ID, "10") == "1"){
		$.messager.alert('提示',"当前会诊已撤销，不能打印!","error");
		return;
	}
	
	var mCstID = rowData.ID;
	if(PrintWay==1){
	    window.open("dhcmdt.printconsmdtopin.csp?CstID="+mCstID+"&MWToken="+websys_getMWToken());
	}else{
	    PrintCons(mCstID);  /// 打印会诊申请单	
	}
	
	$("#PatList").datagrid("reload");
	return;
}


/// 打印告知单
function printInfoSing(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	if (rowData.PayMony == $g("未收费")){
		//$.messager.alert('提示',"当前会诊未收费，不能打印!","error");
		//return;
	}
	
	if (GetIsOperFlag(rowData.ID, "10") == "1"){
		$.messager.alert('提示',"当前会诊已撤销，不能打印!","error");
		return;
	}
	
	var mCstID = rowData.ID;
	PrintCst_REQ(mCstID,mdtDisGrp);  /// 打印会诊申请单
	InsCsMasPrintFlag(mCstID,"Z"); ///修改申请打印字段 
	$("#PatList").datagrid("reload");
	return;
}

/// 打印之情同意书
function PrintInfoCons(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var CstID = rowData.ID;
	
	PrintConsent(CstID);
	return;
}

/// 打印之情同意书
function PrintConfApp(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var CstID = rowData.ID;
	
	PrintMakeDoc(CstID);
	return;
}

/// 电子病历窗口
function OpenEmrWin(){
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var CstID = rowData.ID;
	
	var RetData=$.cm({ 
		ClassName:"web.DHCMDTConsultQuery",
		MethodName:"OpenEmrData",
		CstID:CstID,
		dataType:"text"
	}, false);
	var RetDataArr=RetData.split("^");
	var EpisodeID=RetDataArr[0];
	var InstanceID=RetDataArr[1];
	
	var lnk ="emr.interface.ip.mdtconsult.csp?EpisodeID="+ EpisodeID +"&InstanceID="+InstanceID+"&FromCode="+CstID+"&CTlocID="+LgLocID+"&UserID="+LgUserID+"&DisplayType=&NavShowType=&RecordShowType=&ShowNav=N"+"&MWToken="+websys_getMWToken()
	websys_showModal({
		url:lnk,
		title:"MDT病历",
		iconCls:"icon-w-paper",
		width:PageWidth,
		height:800,
		onClose: function() {	
		}
	});	
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

//根据父页面取弹出框的宽度
function getWidth(){
	
	var width=$("#pf-hc").css("width")
	var twidth = Number(width.split("px")[0])+Number(40);
	PageWidth=twidth
}

function LoadMoreScr(){
	if(!IsOpenMoreScreen) return;
	//openViceScreen();
	
	openLoginSucessScreen();
	
}

function openLoginSucessScreen(){
	var Obj={
		usercode:LgUserCode
	}
	
	websys_emit("onHISLogonSuccess",Obj);	
}

function openViceScreen(ID,EpisodeID,DisGrpID){
	var Obj={
		ID:ID,
		EpisodeID:EpisodeID,
		DisGrpID:DisGrpID,
		Action:"externalapp"
	}
	
	websys_emit("onMdtConsMakePlanOpen",Obj);	
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

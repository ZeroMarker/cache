//===========================================================================================
// 作者：      huaxiaoying
// 编写日期:   2018-05-07
// 描述:	   急诊病人状态改变
//===========================================================================================
var userId = session['LOGON.USERID'];
var ctlocId = session['LOGON.CTLOCID'];
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var EpisodeID
/// 页面初始化函数
function initPageDefault(){
    LoadEpisodeID();          /// 初始化就诊号
    InitParams();             /// 初始化参数
	InitPageComponent(); 	  /// 初始化界面控件内容
	if(EpisodeID == ""){	  ///用户大会
	    return false;
    } //2022-11-09
	setEnableDisDom("");
	LoadHandler();
	GetPatBaseInfo();         /// 病人就诊信息
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitPageEditFlag();       /// 初始化页面默认组件
}
function LoadEpisodeID(){
	
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2011-10-24 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed
	
	var frm = dhcadvdhcsys_getmenuform();
	if (frm) {
	    EpisodeID = frm.EpisodeID.value;
	}
	EpisodeID=!EpisodeID?"":getParam("EpisodeID"); //用户大会
}

function InitParams(){
	
	
	var params = EpisodeID
	///获取全局变量
	runClassMethod("web.DHCEMVisitStat","GetParams",{"Params":params},function(retString){
		DateFormat = retString.split("^")[0];
		DeceasedFlag = retString.split("^")[1];
		CurDate = retString.split("^")[2];
		CurTime = retString.split("^")[3];
	},'',false)
}

/// 初始化界面控件内容
function InitPageComponent(){
	$('#UndoDischargeW').window('close'); //关闭弹窗

	///改变状态日期
	$HUI.datebox("#ChangeDate").setValue(CurDate);
	$HUI.timespinner("#ChangeTime").setValue(CurTime);
	
	///病人状态
	$HUI.combobox("#State",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatStatus&MethodName=GetAccessStatJsonList&LgParams="+LgParams,
		//w ##Class(web.DHCADMVisitStat).GetUserAccessStat("E","4634")
		valueField:'id',
		textField:'text',
		panelHeight:"150",
		blurValidValue:true,
		onSelect:function(option){
			var ret = validitStat(option.id);
			ret?ret=setEnableDisDom(option.id):"";
			ret?ret=setDateTimeDesc(option.id):"";
			return;
	    }	
	})
	
	///急诊病区
	$HUI.combobox("#EmWard",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetEmWard&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'text',
		//panelHeight:"auto",
		blurValidValue:true,
		onSelect:function(option){
	      
	    }	
	})
	
	///入院病区
	$HUI.combobox("#InWard",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetInWard&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		//panelHeight:"auto",
		mode:'remote',
		onSelect:function(option){
	      
	    }	
	})
	
	
	///病人当前状态
	runClassMethod("web.DHCADMVisitStat","GetPatCurStat",{"EpisodeID":EpisodeID},function(jsonString){
		var stat=jsonString.split("^")
		$("#CurState").val(stat[1]);
		if(stat[0]=="Discharge"){ //if(stat[1]=="离院"){
			$("#Cancel").css("display","inline");
			$HUI.combobox("#State").disable();			
		}else if((stat[0]=="Stay")||(stat[0]=="Salvage")){ //}else if((stat[1]=="留观")||(stat[1]=="抢救")){
			$("#CancelObs").css("display","inline");
		}
	},'',false)
	
	///急诊等级
	runClassMethod("web.DHCEMVisitStat","GetPAADMPriorityDR",{"EpisodeID":EpisodeID},function(jsonString){
		$("#EmClass").val(jsonString);
	},'',false)
	
	
	///撤销结算原因
	$HUI.combobox("#CancelRea",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetRFDDesc",
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		blurValidValue:true,
		onSelect:function(option){
	    }	
	})
	
	/// 离院原因
  	$HUI.combobox("#LeaveReason",{
		url:"",
		valueField:'value',
		textField:'text',
		panelHeight:"auto",
		onShowPanel:function(){
			var StatCode = $HUI.combobox("#State").getValue();
			var unitUrl=$URL+"?ClassName=web.DHCEMDicItem&MethodName=jsonConsItem&mCode="+StatCode+"&HospID="+session['LOGON.HOSPID'];
			$("#LeaveReason").combobox('reload',unitUrl);
		}
	})
	
	if(DeceasedFlag=="Y"){
		$("#patStatus").css("color","red");
		$("#patStatus").html($g("(患者已故)"));
	}
}

/// 初始化页面默认组件
function InitPageEditFlag(){
	
	$HUI.combobox("#LeaveReason").disable();    /// 离院日期
}

function setDateTimeDesc(stateDesc){
	if(stateDesc=="Discharge"){
		$("#changeDateLab").text($g("离院日期"));
		$("#changeTimeLab").text($g("离院时间"));
		$("#updateNoteLab").text($g("离院原因"));
	}else if(stateDesc=="Displace"){
		$("#changeDateLab").text($g("转院日期"));
		$("#changeTimeLab").text($g("转院时间"));
	}else if((stateDesc=="SalDeath")||(stateDesc=="Death")){    
		$("#changeDateLab").text($g("死亡日期"));
		$("#changeTimeLab").text($g("死亡时间"));
		$("#updateNoteLab").text($g("死亡原因"));
	}else if(stateDesc=="DisplaceOrInHospital"){
		$("#changeDateLab").text($g("转入院日期"));
		$("#changeTimeLab").text($g("转入院时间"));
		$("#updateNoteLab").text($g("转入院原因"));
	}else{
		$("#changeDateLab").text($g("改变状态日期"));
		$("#changeTimeLab").text($g("时间"));
		$("#updateNoteLab").text($g("离院原因"));
	}
	
	return true;
}

function validitStat(stateDesc){
	var ret=1;
	if(DeceasedFlag=="Y"){
		if(stateDesc!="Discharge"){
			ret=0;
			$HUI.combobox("#State").setValue("");
			$.messager.alert("提示:","患者已故,不允许此操作");
		}
	}
	return ret;
}

//界面控制
function setEnableDisDom(stateDesc){
	
	if(stateDesc==""){
		$("#CurState").attr("disabled","disabled");  //病人当前状态不可编辑  
		$HUI.datebox("#ChangeDate").disable();
		$HUI.timespinner("#ChangeTime").disable();
		$HUI.combobox("#InWard").disable();
		$HUI.combobox("#EmWard").disable();
		$("#EmClass").attr("disabled","disabled");	
		$HUI.linkbutton("#Update").disable();
		$("#EmRemark").attr("disabled", true); /// 转入医院
		return;
	}else{
		$HUI.datebox("#ChangeDate").enable();
		$HUI.timespinner("#ChangeTime").enable();	
		$HUI.linkbutton("#Update").enable();
	}
	
	//留观
	if((stateDesc=="Stay")||stateDesc=="Salvage"){
		$HUI.combobox("#EmWard").enable();
	}else{
		$HUI.combobox("#EmWard").disable();
		$HUI.combobox("#EmWard").setValue("");
	}
	
	//离院
	if(stateDesc=="Discharge"){
		$HUI.datebox("#LeaveDate").enable();
		$HUI.timespinner("#LeaveTime").enable();
		$HUI.combobox("#LeaveReason").enable();
		$HUI.combobox("#LeaveReason").setValue("");
	}else{
		$HUI.datebox("#LeaveDate").setValue("");
		$HUI.timespinner("#LeaveTime").setValue("");
		$HUI.datebox("#LeaveDate").disable();
		$HUI.timespinner("#LeaveTime").disable();
		$HUI.combobox("#LeaveReason").disable();
		$HUI.combobox("#LeaveReason").setValue("");
	}
	
	//入院
	if(stateDesc=="Inhospital"){
		$HUI.combobox("#InWard").enable();
	}else{
		$HUI.combobox("#InWard").disable();
		$HUI.combobox("#InWard").setValue("");
		$HUI.combobox("#EmWard").setValue("");
	}

	// 转入医院
	if(stateDesc=="Displace"){
		$("#EmRemark").attr("disabled", false);
	}else{
		$("#EmRemark").val("").attr("disabled", true);
	}
	
	// 转入医院
	if(stateDesc=="DisplaceOrInHospital"){
		$HUI.combobox("#InWard").enable();
		$("#EmRemark").attr("disabled", false);
	}else{
		$HUI.combobox("#InWard").disable();
		$HUI.combobox("#InWard").setValue("");
		$HUI.combobox("#EmWard").setValue("");
		$("#EmRemark").val("").attr("disabled", true);
	}
	
	
	//原因下拉控制，死亡、离院、转入院可以选择
	if((stateDesc=="Death")||(stateDesc=="Discharge")||(stateDesc=="DisplaceOrInHospital")){
		$HUI.combobox("#LeaveReason").enable();
	}else{
		$HUI.combobox("#LeaveReason").disable();
		$HUI.combobox("#LeaveReason").setValue("");
	}
	
	return true;
}

//[{"id":"Arrival","text":"到达"},{"id":"Exam","text":"检查"},{"id":"Test","text":"检验"},{"id":"Therapy","text":"治疗"},{"id":"Stay","text":"留观"},{"id":"Inhospital","text":"入院"},{"id":"Displace","text":"转院"},{"id":"Operation","text":"手术"},{"id":"Salvage","text":"抢救"},{"id":"SalDeath","text":"抢救死亡"},{"id":"Death","text":"来时死亡"},{"id":"SalSucess","text":"抢救脱危"}]

function LoadHandler(){
	runClassMethod("web.DHCEMPatChange","GetAdmType",
		{'admId':EpisodeID},
		function(retStr){
			if (retStr!="E") {
				alert("只能对急诊病人操作!");
				return;
			}
	},'',false)
	
}

///  效验时间栏录入数据合法性
function CheckEmPcsTime(id){

	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if ((InTime.length != 4)&(InTime.length != 6)){
		$.messager.alert("提示:","请录入正确的时间格式！<span style='color:red;'>例如:18:23:00,请录入1823或者182300</span>");
		$('#'+ id).val("");
		return "";
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("提示:","小时数不能大于23！");
		$('#'+ id).val("");
		return "";
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("提示:","分钟数不能大于59！");
		$('#'+ id).val("");
		return "";
	}
	
	var second = InTime.substring(4,6);
	if (second==""){
		second="00";
	}
	if (second > 59){
		$.messager.alert("提示:","秒数不能大于59！");
		$('#'+ id).val("");
		return "";
	}
	
	return hour +":"+ itme+":"+second;
}

/// 获取焦点后时间栏设置
function SetEmPcsTime(id){
	
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	InTime = InTime.replace(":","");
	return InTime;
}

///更新
function Update(){
	
	var StatCode = $HUI.combobox("#State").getValue();
	
	if ((StatCode == "")|| (StatCode == undefined))  {
		$.messager.alert("提示:","请选择病人状态!");
		return;
	}

	var DateStr=$HUI.datebox("#ChangeDate").getValue();
	var TimeStr=$HUI.timespinner("#ChangeTime").getValue();
	if ((DateStr == "") || (TimeStr == "")) {
		$.messager.alert("提示:","日期与时间不能为空!");
		return;
	}
	
	var visitStatDesc = $HUI.combobox("#State").getText();
	var curVisitStatDesc = $("#CurState").val();
	if (curVisitStatDesc == visitStatDesc) { 
		$.messager.alert("提示:","病人当前状态,不能与更新状态相同(针对离院召回,再离院时,请先清空病人当前状态)"); 
		return; 
	}

	///留观抢救判断
	if ((StatCode == "Stay")||(StatCode == "Salvage")) {
		var EmergencyDesc = $HUI.combobox("#EmWard").getValue();    
		if (EmergencyDesc == "") {
			$.messager.alert("提示:","留观请选择病区!")
			return;
		}
		var ret = tkMakeServerCall("web.DHCBillInterface", "GetnotPayOrderByRegno", "", EpisodeID)
		if ((ret == 1)&(isTakStayFlag == 0)) {	
			$.messager.alert("提示:","病人存在未结算医嘱,不能办理留观");
			return;
		}
		
		var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetIfStaying", EpisodeID)
		if (ret == 1) {
			$.messager.alert("提示:","病人已经在留观,不能再次办理留观");
			return;
		}

		var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetIfHaveNoPayOrder", EpisodeID)
		if (ret == 1) {
			$.messager.alert("提示:","病人有未结算的急诊留观账单，请先到【急诊留观结算】进行结算");
			return;
		}
	}

	var wardDesc = $HUI.combobox("#InWard").getText();   //后台默认传描述
	var emWardId = $HUI.combobox("#EmWard").getValue(); 
	wardDesc==""?wardDesc=$HUI.combobox("#EmWard").getText():"";

	var VsNote = "";
	// 转入医院
	if (StatCode=="DisplaceOrInHospital"){
		var EmRemark = $("#EmRemark").val();
		VsNote = $HUI.combobox("#LeaveReason").getText();
		if(VsNote==""){
			$.messager.alert("提示","转入院原因不能为空！");
			return;	
		}
		EmRemark==""?"":VsNote=VsNote+"["+EmRemark+"]";
	}
	// 离院
	if(StatCode=="Discharge"){
		VsNote = $HUI.combobox("#LeaveReason").getText();              //离院原因
		if(VsNote==""){
			$.messager.alert("提示","离院原因不能为空!");
			return;	
		}	
	}
	
	// 死亡
	if(StatCode=="Death"){
		VsNote = $HUI.combobox("#LeaveReason").getText();              //离院原因
		if(VsNote==""){
			$.messager.alert("提示","死亡原因不能为空!");
			return;	
		}	
	}
	
	
	///参数
	var params = EpisodeID+"^"+StatCode+"^"+DateStr+"^"+TimeStr+"^"+userId+"^"+wardDesc+"^"+emWardId+"^"+0+"^"+ctlocId
	params = params+"^"+""+"^"+"" +"^"+ VsNote +"^"+ "";
	
	///需关注医嘱判断
	if(StatCode=="Discharge"){
		var retObject=[];
		runClassMethod("web.DHCEMPatChange","GetAbnormalOrder",{'EpisodeID':EpisodeID,"LgParams":LgParams},function(jsonString){
			retObject = jsonString;
		},'json',false)
		
		if(retObject.length){
		
			var abnormalMsgs = retObject[0].abnormalMsgs;
			var ifCanOper=retObject[0].ifCanOper;
			var ifCanOper="",ifOtherCanOper="",tipMustSeeMsg="",tipOtherMsg="";
			for (var k in abnormalMsgs){
				var itmObj = abnormalMsgs[k];
				if(itmObj["ifCanOper"]||itmObj["ifOtherCanOper"]){
					itmObj["ifCanOper"]?ifCanOper=1:"";
					itmObj["ifOtherCanOper"]?ifOtherCanOper=1:"";
					tipMustSeeMsg+=((tipMustSeeMsg?";":"")+itmObj["abnormalMsg"]);
				}else{
					tipOtherMsg+=((tipOtherMsg?";":"")+itmObj["abnormalMsg"]);
				}
			}
			
			var tipHtml=(tipMustSeeMsg?"流程控制内容:<span style='color:red'>"+tipMustSeeMsg+"</span>":"")+
						(tipOtherMsg?"提示内容:<span style='color:blue'>"+tipOtherMsg+"</span>":"");
			if(ifOtherCanOper=="1"){
				$.messager.alert("提示:",tipHtml,"info");
			}else{
				if(ifCanOper=="1"){
					$.messager.alert("提示:",tipHtml,"info",function(){
						websys_createWindow("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+EpisodeID+"&defaultTypeCode=D","","width=99% height=99%");
					});	
				}else{
					///提示：可以选择是进入需处理医嘱，选择否直接通过
					$.messager.defaults = { ok: $g("处理"), cancel: $g("忽略") };
					$.messager.confirm("提示:", tipHtml, function (data) {
					    if (data) {
							websys_createWindow("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+EpisodeID+"&defaultTypeCode=D","","width=99% height=99%");
							return;
					    }else{
						    InsertVis(params,LgParams);	
							return;    
						}
					});
				}
			}
			return;
		}
	}
	
	
	InsertVis(params,LgParams);	
	return;
}

function InsertVis(params,LgParams){
	runClassMethod("web.DHCEMVisitStat","InsertVis",{"Params":params,"LgParams":LgParams},
		function(retStr){
			if (retStr != ""){
				if (retStr != 0) {
					if (retStr.indexOf("预交金") != -1){
						$.messager.alert("提示:",retStr,"info",function(){
							if(retStr.indexOf("预交金评估信息")){
								OpenPayAdv(EpisodeID);
							}
						});
					}else{
						$.messager.alert("提示:",retStr,"info");
					}
				}else {
					$.messager.alert("提示:","操作成功!","info",function(){
						FlashPage();
					});
				}
			}
		},'')	
}

function OpenPayAdv(EpisodeID){
	var url="dhcem.pay.advpayass.csp?EpisodeID="+EpisodeID;
	websys_showModal({
		url: url,
		width: '97%',
		height: '95%',
		iconCls:"icon-w-paper",
		title: $g('预交金评估'),
		closed: true,
		modal:true,
		onClose:function(){
			
		}
	});	
}

///撤销结算
function UndoDischarge() {

	var resStr = tkMakeServerCall("web.DHCADTDischarge", "GetFinalStat", EpisodeID)
	if (resStr != "0") {
		$.messager.alert("提示",resStr)
		return;
	}
	$('#UndoDischargeW').window('open');  
}
///撤销结算更新
function UpdateUndo(){
	var reverseDesc=$HUI.combobox("#CancelRea").getText(); 
	///qqa 2018-07-27 统一使用护士执行撤销结算按钮
	runClassMethod("web.DHCEMPatChange","DelDisorReversePay",{"Adm":EpisodeID,"userId":userId,"reverseDesc":reverseDesc},
		function(retStr){
			if (retStr != 0) $.messager.alert("提示:",retStr); 
			else {
				$.messager.alert("提示:","操作成功!");
				FlashPage();
			}
	},'')

}

///2017-11-13  添加获取病人菜单信息方法
function dhcadvdhcsys_getmenuform(){
	var frm = null;
	try{
		var win=top.frames['eprmenu'];
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if(frm) return frm;
		}
		//在新窗口打开的界面
		win = opener;
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if (frm) return frm;
		}
		win = parent.frames[0];
		if (win){
			frm = win.document.forms["fEPRMENU"];
			if (frm) return frm;
		}
		if (top){
			frm =top.document.forms["fEPRMENU"];
			if(frm) return frm
		}
	}catch(e){}
	return frm;
}


/// 病人就诊信息
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMInComUseMethod","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).html(jsonObject[this.id]);
			if(HISUIStyleCode==="lite"){
				if (jsonObject.PatSex == $g("男")){
					$("#PatPhoto").attr("src","../images/man_lite.png");
				}else if (jsonObject.PatSex == $g("女")){
					$("#PatPhoto").attr("src","../images/woman_lite.png");
				}else{
					$("#PatPhoto").attr("src","../images/unman_lite.png");
				}
			}else{

				if (jsonObject.PatSex == $g("男")){
					$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
				}else if (jsonObject.PatSex == $g("女")){
					$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
				}else{
					$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/unman.png");
				}
			}
		})
	},'json',false)
}

/// 页面DataGrid初始定义已选列表
function InitPageDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'vsID',title:'vsID',width:100,align:'center',hidden:true},
		{field:'vsDesc',title:'病人状态',width:80,align:'center'},
		{field:'vsDate',title:'状态日期',width:100,align:'center'},
		{field:'vsTime',title:'状态时间',width:100,align:'center'},
		{field:'PatLoc',title:'病人科室',width:100,align:'center'},
		{field:'User',title:'操作人',width:100,align:'center'},
		{field:'Ward',title:'入院病区',width:100,align:'center'},
		{field:'vsNote',title:'备注信息',width:140,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
		toolbar:[],
	    onLoadSuccess:function (data) { //数据加载完毕事件
	    	
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMVisitStat&MethodName=JsonQryVisitHis&EpisodeID="+ EpisodeID;
	new ListComponent('visgrid', columns, uniturl, option).Init();
}


///撤销留观
function UndoPatObs() {

	var resStr = tkMakeServerCall("web.DHCEMVisitStat", "UndoPatObs", EpisodeID,LgParams)
	if (resStr != "0") {
		$.messager.alert("提示",resStr)
	}else{
		$.messager.alert("提示","撤销留观成功!","info",function(){
			FlashPage();
		})
	}
	return;
}

function FlashPage(){
	try{
		if(window.opener!=null){
			if(typeof window.opener.parentFlash=="function"){
				window.opener.parentFlash();
			}
		}
		
		///局部刷新：床位图弹出
		if(window.parent.top){
			if(window.parent.top.frames[0]){
				if("function" === typeof window.parent.top.frames[0].localRefresh){
					window.parent.top.frames[0].localRefresh();
				}
				window.parent.top.websys_showModal("close");
			}		
		}
	}catch(err){
		console.error(err);
	}
	
	window.location.reload();
	return;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

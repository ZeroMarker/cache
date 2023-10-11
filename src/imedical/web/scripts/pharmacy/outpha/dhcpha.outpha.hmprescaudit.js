/*
 *模块:			中药房
 *子模块:		中药房-门诊草药审方
 *createdate:	2018-12-14
 *creator:		hulihua
*/
DHCPHA_CONSTANT.DEFAULT.APPTYPE="OA";
DHCPHA_CONSTANT.URL.THIS_URL=ChangeCspPathToAll("dhcpha.outpha.outmonitor.save.csp");
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var str=tkMakeServerCall("web.DHCOutPhCommon", "GetPassProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
var strArr=str.split("^");
var RePassNeedCancle=strArr[1];
var clearFlag = ""
var PatientInfo = {
	adm: 0,
	patientID: 0,
	prescno: 0
};
$(function(){
	CheckPermission();	
	/* 初始化插件 start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	var tmpstartdate=FormatDateT("t-2")
	//$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	//$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	InitPrescModalTab();
	InitGridAudit();	
	/* 表单元素事件 start*/
	//登记号回车事件
	$('#txt-patno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-patno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryGridPrescAudit();
			}	
		}
	});
	
	//卡号回车事件
	$('#txt-cardno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txt-cardno").val());
			if (cardno!=""){
				BtnReadCardHandler();
			}
			SetFocus();	
		}
	});
	
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	
	$("#chk-audit").on("ifChanged",function(){
		if (clearFlag!="Y"){
			QueryGridPrescAudit()
		}
	})
	
	$("#txt-cardno").focus();
	/* 表单元素事件 end*/
	InitBodyStyle();
})

//载入数据
window.onload=function(){
	if (LoadPatNo!=""){
		$('#txt-patno').val(LoadPatNo);
	}
	if(LoadOrdItmId!=""){
		InitParams();
	}
	setTimeout("QueryGridPrescAudit()",500);
}
function InitParams(){
	var retVal=tkMakeServerCall("PHA.COM.Method","GetOrdItmInfoForTipMess",LoadOrdItmId);
    if(retVal!="{}"){
	    var retJson=JSON.parse(retVal)
		var ordDate=retJson.ordDate;
		$("#date-start").data('daterangepicker').setStartDate(ordDate);
		$("#date-start").data('daterangepicker').setEndDate(ordDate);
	}
}
//初始化发药table
function InitGridAudit(){
	var columns=[
		{header:$g("分析结果"),index:'druguse',name:'druguse',width:65,formatter: druguseFormatter},
		{header:$g("审方结果"),index:'TAuditResult',name:'TAuditResult',width:65,cellattr: addPhDispStatCellAttr},
		{header:$g("发药状态"),index:'TDspStatus',name:'TDspStatus',width:65,hidden:true},
		{header:$g("是否加急"),name:"TEmergFlag",index:"TEmergFlag",width:70,
			formatter: function(value, options, rowdata){
				if(value == "Y"){
					return $g("是");	
				}else{
					return $g("否");	
				}
			}	
		},
		{header:$g("姓名"),index:'TPatName',name:'TPatName',width:100},
		{header:$g("登记号"),index:'TPmiNo',name:'TPmiNo',width:100},
		{header:$g("处方号"),index:'TPrescNo',name:'TPrescNo',width:110},
		{header:$g("处方剂型"),index:"TPrescType",name:"TPrescType",width:80},
		{header:$g("付数"),index:"TFactor",name:"TFactor",width:80},
		{header:$g("费别"),index:"TBillType",name:"TBillType",width:60},
		{header:$g("诊断"),index:'TMR',name:'TMR',width:300,align:'left'},
		//鉴于现在标库上还没有慢病诊断录入的地方，经与测试组沟通后暂时先隐藏此列信息 MaYuqiang 20200320
		{header:$g("慢病诊断"),index:'TMBDiagnos',name:'TMBDiagnos',width:150,align:'left',hidden:true},
		{header:$g("性别"),index:'TPatSex',name:'TPatSex',width:40},
		{header:$g("年龄"),index:'TPatAge',name:'TPatAge',width:40},
		{header:$g("科室"),index:'TPatLoc',name:'TPatLoc',width:100},
		{header:$g("拒绝理由"),name:"TRefResult",index:"TRefResult",width:300,align:'left'},
		{header:$g("申诉理由"),name:"TDocNote",index:"TDocNote",width:300,align:'left'},
		{header:'TAdm',index:'TAdm',name:'TAdm',width:60,hidden:true},
		{header:'TPapmi',index:'TPapmi',name:'TPapmi',width:60,hidden:true},
		{header:'TPatLoc',index:'TPatLoc',name:'TPatLoc',width:60,hidden:true},
		{header:'TOeori',index:'TOeori',name:'TOeori',width:60,hidden:true},
		{header:$g("病人密级"),index:'TEncryptLevel',name:'TEncryptLevel',width:70,hidden:true},
		{header:$g("病人级别"),index:'TPatLevel',name:'TPatLevel',width:70,hidden:true}
	]; 
	var jqOptions={
		datatype:'local',
		colModel: columns, //列
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=PHA.OP.HMPreAudit.Query&MethodName=jsGetAdmPrescList', //查询后台	
		height: DhcphaJqGridHeight(1,3)+26,
		shrinkToFit: false,
		pager: "#jqGridPager", //分页控件的id 
		rownumbers: true,
		viewrecords: true, 
		onSelectRow:function(id,status){
			QueryGridAuditSub();
			var id = $(this).jqGrid('getGridParam', 'selrow');
			if (id) {
				var selrowdata = $(this).jqGrid('getRowData', id);
				PatientInfo.adm = selrowdata.TAdm;
				PatientInfo.prescno = selrowdata.TPrescNo;
				PatientInfo.patientID=selrowdata.TPapmi;
			}
	},
	loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#ifrm-presc").attr("src","");
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$("#grid-cypresc").dhcphaJqGrid(jqOptions);
}

//查询发药列表
function QueryGridPrescAudit(){
 	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
 	var phalocid=DHCPHA_CONSTANT.DEFAULT.LOC.id;
	var chkaudit="";
	if($("#chk-audit").is(':checked')){
		chkaudit="Y";
	}else{
	    chkaudit="";
	}
	var patno=$("#txt-patno").val();
	var params=stdate+tmpSplit+enddate+tmpSplit+phalocid+tmpSplit+patno+tmpSplit+chkaudit;		
	$("#grid-cypresc").setGridParam({
		datatype:'json',
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	$("#ifrm-presc").attr("src","");
}
//查询发药明细
function QueryGridAuditSub(){
	var selectid = $("#grid-cypresc").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-cypresc").jqGrid('getRowData', selectid);
	var prescNo = selrowdata.TPrescNo;
	var dispFlag = selrowdata.TFyFlag;
	var phartype = "OP";		// 门诊类型
	var zfFlag = "底方"
	var useFlag = "2" 			// 处方审核
	var cyflag = "Y"
	
	PHA_PRESC.PREVIEW({
		prescNo: prescNo,			
		preAdmType: phartype,
		zfFlag: zfFlag,
		prtType: 'DISPPREVIEW',
		useFlag: useFlag,
		iframeID: 'ifrm-presc',
		cyFlag: cyflag
	});
	
	//$("#ifrm-presc").attr("src",ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp")+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW");
}

 //审核通过
function PassPresc(){
	if (DhcphaGridIsEmpty("#grid-cypresc")==true){
		return;
	}
	var selectid=$("#grid-cypresc").jqGrid('getGridParam','selrow');
	if (selectid==null){
	    dhcphaMsgBox.alert("请先选中需要审核的处方！");
	    return;
	}
	var selrowdata = $("#grid-cypresc").jqGrid('getRowData', selectid);
	var fyflag=selrowdata.TFyFlag;
	if (fyflag=="OK"){
		dhcphaMsgBox.alert("该处方已发药，不能审核通过!");
		return;
	}
	var auditresult=selrowdata.TAuditResult;
	 if (auditresult.indexOf("接受")>-1) {
        dhcphaMsgBox.alert("该处方审方已经接受,不能审核通过!");
        return;
    }
	if(RePassNeedCancle=="Y"){
	    if (auditresult == "通过") {
	        dhcphaMsgBox.alert("您选择的处方已通过,不能再次审核通过 !");
	        return;
	    }
	    else if (auditresult.indexOf("拒绝") != "-1"){
		    dhcphaMsgBox.alert("您选择的处方已拒绝,需撤消之前的审核记录才能再次审核 !");
	        return;
		}
    }

	var prescno=selrowdata.TPrescNo;
	var orditemStr=tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery","GetOrdStrByPrescno",prescno);
	var retVal=orditemStr.split("&&")[0];
	var orditem=orditemStr.split("&&")[1];
	if (retVal < 0) {
	        dhcphaMsgBox.alert(orditem+"不能再次审核通过 !");
	        return;
	    } 
	var ret = "Y";
	var reasondr = "";
	var advicetxt = "";
	var factxt = "";
	var phnote = "";
	var guser = session['LOGON.USERID'];
	var ggroup = session['LOGON.GROUPID'];
	var input = ret + tmpSplit + guser + tmpSplit + advicetxt + tmpSplit + factxt + tmpSplit + phnote + tmpSplit + ggroup + tmpSplit + orditem;
	var input = input + tmpSplit + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
	SaveCommontResult(reasondr, input);
}

//审核拒绝
function RefusePresc(){
	if (DhcphaGridIsEmpty("#grid-cypresc")==true){
		return;
	}
	var selectid=$("#grid-cypresc").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-cypresc").jqGrid('getRowData', selectid);
	if (selectid==null){
	    dhcphaMsgBox.alert("没有选中处方,不能拒绝!");
	    return;
	}
	var prescno=selrowdata.TPrescNo;
	if(prescno==""){
		dhcphaMsgBox.alert("请选择要拒绝的处方");
		return;
	}
  	var dspstatus=selrowdata.TDspStatus;
	if (dspstatus.indexOf("TC")<0){
		dhcphaMsgBox.alert("您选择的处方已发药,无法拒绝!");
		return;
	}
	var auditresult=selrowdata.TAuditResult;
	if (auditresult.indexOf("接受")>-1) {
        dhcphaMsgBox.alert("该处方审方已经接受,不能审核拒绝!");
        return;
    }
	if(RePassNeedCancle=="Y"){
	    if (auditresult == "通过") {
	        dhcphaMsgBox.alert("您选择的处方已通过,需撤消之前的审核记录才能再次审核 !");
	        return;
	    }
	    else if (auditresult.indexOf("拒绝") != "-1"){
		    dhcphaMsgBox.alert("您选择的处方已拒绝,需撤消之前的审核记录才能再次审核 !");
	        return;
		}
    }
 
	var waycode = OutPhaWay;
	var orditm=selrowdata.TOeori;
    ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:prescno,
		selType:"PRESCNO"
	},SaveCommontResultEX,{orditm:orditm});   	 
}
function SaveCommontResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return "";
	}
	var retarr = reasonStr.split("@");
	var ret = "N";
	var reasondr = retarr[0];
	var advicetxt = retarr[2];
	var factxt = retarr[1];
	var phnote = retarr[3];
	var User = session['LOGON.USERID'];
	var grpdr = session['LOGON.GROUPID'];
	var input = ret + tmpSplit + User + tmpSplit + advicetxt + tmpSplit + factxt + tmpSplit + phnote + tmpSplit + grpdr + tmpSplit + origOpts.orditm;
	var input = input + tmpSplit + DHCPHA_CONSTANT.DEFAULT.APPTYPE;
	SaveCommontResult(reasondr, input)
}
//审核拒绝
function SaveCommontResult(reasondr, input){
	$.ajax({
		url:DHCPHA_CONSTANT.URL.THIS_URL + '?action=SaveOPAuditResult&Input=' + encodeURI(input) + '&ReasonDr=' + reasondr,
		type:'post',   
		success:function(data){	
			var retjson=JSON.parse("["+data+"]");
			//alert("retjson[0].retvalue: "+retjson[0].retvalue)
			if (retjson[0].retvalue==0){
				QueryGridPrescAudit();
				if (top && top.HideExecMsgWin) {
		            top.HideExecMsgWin();
		        }
			}else{
				dhcphaMsgBox.alert(retjson.retinfo);
				return
			} 
		},  
		error:function(){}  
	})
}

 //获取处方审核结果 
function GetOrdAuditResultByPresc(prescno){
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc",prescno);
	return ref;
}

//清空
function ClearConditions(){
	clearFlag = "Y"
	var cardoptions={
		id:"#sel-cardtype"
	}
	$('#chk-audit').iCheck('uncheck');
	InitSelectCardType(cardoptions);
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$("#grid-cypresc").clearJqGrid();
	$("#ifrm-presc").attr("src","");
	var tmpstartdate=FormatDateT("t-2")
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	SetFocus();
	clearFlag = "N"
}

//处方审核扩展信息modal
function ViewPrescAddInfo(){
	var grid_records = $("#grid-cypresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("当前界面无数据!");
		return;
	}
  	var selectid=$("#grid-cypresc").jqGrid('getGridParam','selrow');
  	if (selectid==null){
		dhcphaMsgBox.alert("请先选中需要查看的处方记录!");
		return;  
	}
	$("#modal-prescinfo").modal('show');
}
//注册modaltab事件
function InitPrescModalTab(){
	$("#ul-monitoraddinfo a").on('click',function(){
		var adm = PatientInfo.adm;
		var prescno = PatientInfo.prescno;
		var patientID=PatientInfo.patientID; 	
		var tabId=$(this).attr("id")
		if (tabId=="tab-allergy"){
		    $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcdoc.allergyenter.csp'+'?PatientID=' + patientID + '&EpisodeID=' + adm+"&IsOnlyShowPAList=Y")); 
		}
		if (tabId=="tab-risquery"){
			$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcapp.inspectrs.csp'+ '?PatientID=' + patientID + '&EpisodeID=' + adm));
		}
		if (tabId=="tab-libquery"){
			$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcapp.seepatlis.csp'+'?PatientID=' + patientID + '&EpisodeID=' + adm+'&NoReaded='+'1')); 
		}
		if (tabId=="tab-eprquery"){
			$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('emr.browse.manage.csp'+ '?PatientID=' + patientID + '&EpisodeID='+adm+'&EpisodeLocID=' + session['LOGON.CTLOCID'])); 
			//$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('emr.interface.browse.episode.csp'+ '?PatientID=' + patientID + '&EpisodeID='+adm+'&EpisodeLocID=' + session['LOGON.CTLOCID'])); 
		}		
		if (tabId=="tab-orderquery"){
			$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('oeorder.opbillinfo.csp'+'?EpisodeID=' +adm)); 
		}
	})
	$('#modal-prescinfo').on('show.bs.modal', function () {
		$("#modal-prescinfo .modal-dialog").width($(window).width()*0.9);
		$("#ifrm-outmonitor").height($(window).height()*0.9-140)
	  	//$('#ifrm-outmonitor').attr('src', "dhcpha.comment.queryorditemds.csp?EpisodeID=" + PatientInfo.adm); 
		$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcdoc.allergyenter.csp'+'?PatientID=' + PatientInfo.patientID + '&EpisodeID=' + PatientInfo.adm+"&IsOnlyShowPAList=Y")); 
	  	var selectid=$("#grid-cypresc").jqGrid('getGridParam','selrow');
	  	var selectdata=$('#grid-cypresc').jqGrid('getRowData',selectid);
	  	var patoptions={
			id:"#dhcpha-patinfo",
			orditem:selectdata.TOeori  
		};
	  	AppendPatientOrdInfo(patoptions);
	  	var tabId=$(this).attr("id");
	  	if(tabId!="tab-allergy"){
			setTimeout("ClickAllergy()",100)
		}
	})
	$("#modal-prescinfo").on("hidden.bs.modal", function() {
	    //$(this).removeData("bs.modal");
	});
	$("#tab-beforeindrug").hide();
}

function ClickAllergy()
{
	$("#tab-allergy").click();
}

//查看日志
function ViewPrescMonitorLog(){
	var grid_records = $("#grid-cypresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("当前界面无数据!");
		return;
	}
  	var selectid=$("#grid-cypresc").jqGrid('getGridParam','selrow');
  	if (selectid==null){
		dhcphaMsgBox.alert("请先选中需要查看的处方记录!");
		return;  
	}
	var selectdata=$('#grid-cypresc').jqGrid('getRowData',selectid);
	var orditm=selectdata.TOeori;
	var logoptions={
		id:"#modal-monitorlog",
		orditm:orditm,
		fromgrid:"#grid-cypresc",
		fromgridselid:selectid	
	};
	InitOutMonitorLogBody(logoptions);
}

function PrescAnalyse(){
	var passTypeStr=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",gGroupId,gLocId,gUserID);
	if (passType==""){
		dhcphaMsgBox.alert("未设置处方分析接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商");
		return;
	}
	var passTypeData = passTypeStr.split("^")
	var passType = passTypeData[0]
	if (passType=="DHC"){
		// 东华知识库
		 DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "grid-cypresc", 
		 	MOeori: "TOeori",
		 	PrescNo:"TPrescNo", 
		 	GridType: "JqGrid", 
		 	Field: "druguse",
		 	ResultField:"druguseresult"
		 });
	}else if (passType=="DT"){
		// 大通
		// StartDaTongDll(); 
		// DaTongPrescAnalyse();  
	}else if (passType=="MK"){
		// 美康
		//MKPrescAnalyse(); 
	}else if (passType=="YY"){
	}
}

//权限验证
function CheckPermission(){
	$.ajax({
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCOUTPHA.InfoCommon&MethodName=CheckPermission'+
			'&groupid='+gGroupId+'&userid='+gUserID+'&locid='+gLocId,
		type:'post',   
		success:function(data){ 
			var retjson=JSON.parse(data);
			var retdata= retjson[0];
			var permissionmsg="",permissioninfo="";
			if (retdata.phloc==""){
				permissionmsg="药房科室:"+defaultLocDesc;
				permissioninfo="尚未在门诊药房人员代码维护!"	
			}else {
				permissionmsg="工号:"+gUserCode+"　　姓名:"+gUserName;
				if (retdata.phuser==""){					
					permissioninfo="尚未在门诊药房人员代码维护!"
				}else if(retdata.phnouse=="Y"){
					permissioninfo="门诊药房人员代码维护中已设置为无效!"
				}else if(retdata.phaudit!="Y"){
					permissioninfo="门诊药房人员代码维护中未设置审核权限!"
				}
			}
			if (permissioninfo!=""){	
				$('#modal-dhcpha-permission').modal({backdrop: 'static', keyboard: false}); //点灰色区域不关闭
				$('#modal-dhcpha-permission').on('show.bs.modal', function () {
					$("#lb-permission").text(permissionmsg)
					$("#lb-permissioninfo").text(permissioninfo)
		
				})
				$("#modal-dhcpha-permission").modal('show');
			}
		},  
		error:function(){}  
	})
}

function InitBodyStyle(){
	var height1=$("[class='container-fluid dhcpha-condition-container']").height();
	var height3=parseFloat($("[class='panel div_content']").css('margin-top'));
	var height4=parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height5=parseFloat($("[class='panel-heading']").height());
	var height6=parseFloat($("[class='container-fluid presccontainer']").height());
	var tableheight=$(window).height()-height1*2-height3-height4-height5-12;
	var dbLayoutWidth=$("[class='panel div_content']").width();
	if (!(!!window.ActiveXObject || "ActiveXObject" in window))  {
		dbLayoutWidth = dbLayoutWidth-7;
	}
	var dbLayoutCss={
		width:dbLayoutWidth,
		height:tableheight
	};
	$("#ifrm-presc").css(dbLayoutCss);
}

//格式化列
function druguseFormatter(cellvalue, options, rowdata){
	if (cellvalue==undefined){
		cellvalue="";
	}
	var imageid="";
	if (cellvalue=="0"){
		imageid="warning0.gif";
	}else if (cellvalue=="1"){
		imageid="yellowlight.gif";
	}else if (cellvalue=="2"){
		imageid="warning2.gif"
	}
	else if (cellvalue=="3"){
		imageid="warning3.gif"
	}
	else if (cellvalue=="4"){
		imageid="warning4.gif"
	}
	if (imageid==""){
		return cellvalue;
	}
	//return '<img src="../scripts/pharmacy/images/'+imageid+'" ></img>'
	return '<img src="'+DHCPHA_CONSTANT.URL.PATH+'/scripts/pharmacy/images/' + imageid + '" ></img>'
}

function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata){
	if (val=="通过"){
		return "class=dhcpha-record-passed";
	}else if (val=="申诉"){
		return "class=dhcpha-record-appeal";
	}else if (val=="拒绝"){
		return "class=dhcpha-record-refused";
	}else{
		return "";
	}
}

//读卡
function BtnReadCardHandler(){
	var readcardoptions={
		CardTypeId:"sel-cardtype",
		CardNoId:"txt-cardno",
		PatNoId:"txt-patno"		
	}
	DhcphaReadCardCommon(readcardoptions,ReadCardReturn)
}
//读卡返回操作
function ReadCardReturn(){
	QueryGridPrescAudit();
}

/***********************大通相关 start****************************/
//初始化 
function StartDaTongDll(){
	dtywzxUI(0,0,"");
}
//调用
function dtywzxUI(nCode,lParam,sXML){
   var result;
   result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);
   return result;
}
//分析
function DaTongPrescAnalyse(){
	
	var mainrows=$("#grid-presc").getGridParam('records');
	if (mainrows==0){
	  	dhcphaMsgBox.alert("没有明细记录!");
		return;		
	}
	for (var i=1;i<=mainrows;i++){
		dtywzxUI(3, 0, "");
		var tmprowdata=$('#grid-presc').jqGrid('getRowData',i);
		var orditem = tmprowdata.orditem;
		var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
		myrtn = dtywzxUI(28676, 1, myPrescXML);
		var newdata={
			druguse:myrtn
		};	
		$("#grid-presc").jqGrid('setRowData',i,newdata);

	}
}

/***********************大通相关 end  ****************************/

/***********************美康相关 start****************************/
// add by MaYuqiang 20181025	
function MKPrescAnalyse() {
	
	var mainrows=$("#grid-presc").getGridParam('records');
	if (mainrows==0){
		dhcphaMsgBox.alert("没有明细记录!");
		return;		
	}

	for (var i=1;i<=mainrows;i++){
		var tmprowdata=$('#grid-presc').jqGrid('getRowData',i);
		var orditem = tmprowdata.orditem;
		var prescno = tmprowdata.prescno;
		
		var myrtn = HLYYPreseCheck(prescno,0); 
		
		var newdata={
			druguse:myrtn
		};	
		$("#grid-presc").jqGrid('setRowData',i,newdata);
	}
}


function HLYYPreseCheck(prescno,flag){
	var XHZYRetCode=0  //处方检查返回代码
	MKXHZY1(prescno,flag);
	//若为同步处理,取用McPASS.ScreenHighestSlcode
	//若为异步处理,需调用回调函数处理.
	//同步异步为McConfig.js MC_Is_SyncCheck true-同步;false-异步
	XHZYRetCode=McPASS.ScreenHighestSlcode;
	return XHZYRetCode	
}

function MKXHZY1(prescno,flag){
	MCInit1(prescno);
	HisScreenData1(prescno);
	MDC_DoCheck(HIS_dealwithPASSCheck,flag);
}

function MCInit1(prescno) {
	var PrescStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var prescdetail=PrescStr.split("^")
	var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];  
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode ="mzyf"  //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
        if (result > 0) {
        }
        else {
            //alert("没问题");
        }

	return result ;
}


function HisScreenData1(prescno){
	var Orders="";
	var Para1=""
	
	var PrescMStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var PrescMInfo=PrescMStr.split("^")
	var Orders=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
	if (Orders==""){return;}
	var DocName=PrescMInfo[2];
	var EpisodeID=PrescMInfo[5];
	if (EpisodeID==""){return}
	var ret=tkMakeServerCall("web.DHCHLYY","GetPrescInfo",EpisodeID,Orders,DocName);
	var TempArr=ret.split(String.fromCharCode(2));
	var PatInfo=TempArr[0];
	var MedCondInfo=TempArr[1];
	var AllergenInfo=TempArr[2];
	var OrderInfo=TempArr[3];
	var PatArr=PatInfo.split("^");
	
	
	var ppi = new Params_MC_Patient_In();
	ppi.PatCode = PatArr[0];			// 病人编码
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // 住院次数
	ppi.Name = PatArr[1];				// 病人姓名
	ppi.Sex = PatArr[2];				// 性别
	ppi.Birthday = PatArr[3];			// 出生年月
	
	ppi.HeightCM = PatArr[5];			// 身高
	ppi.WeighKG = PatArr[6];			// 体重
	ppi.DeptCode  = PatArr[8];			// 住院科室
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// 医生
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// 使用时间
	ppi.CheckMode = MC_global_CheckMode
	ppi.IsDoSave = 1
	MCpatientInfo  = ppi;
    var arrayDrug = new Array();
	var pri;
  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
  	//alert(OrderInfo)
  	McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++){    
		var OrderArr=OrderInfoArr[i].split("^");
		//传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//药品序号
        drug.OrderNo =OrderArr[0]; 		        		//医嘱号
        drug.DrugUniqueCode = OrderArr[1];  	//药品编码
        drug.DrugName =  OrderArr[2]; 			//药品名称
        drug.DosePerTime = OrderArr[3]; 	   //单次用量
		drug.DoseUnit =OrderArr[4];   	        //给药单位      
        drug.Frequency =OrderArr[5]; 	        //用药频次
        drug.RouteCode = OrderArr[8]; 	   		//给药途径编码
        drug.RouteName = OrderArr[8];   		//给药途径名称
		drug.StartTime = OrderArr[6];			//开嘱时间
        drug.EndTime = OrderArr[7]; 			//停嘱时间
        drug.ExecuteTime = ""; 	   				//执行时间
		drug.GroupTag = OrderArr[10]; 	       //成组标记
        drug.IsTempDrug = OrderArr[11];          //是否临时用药 0-长期 1-临时
        drug.OrderType = 0;    //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //开嘱科室编码
        drug.DeptName =  PrescMInfo[4]; 	  //开嘱科室名称
        drug.DoctorCode =PrescMInfo[6];   //开嘱医生编码
        drug.DoctorName =PrescMInfo[2];     //开嘱医生姓名
		drug.RecipNo = "";            //处方号
        drug.Num = "";                //药品开出数量
        drug.NumUnit = "";            //药品开出数量单位          
        drug.Purpose = 0;             //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
		drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
		drug.Remark = "";             //医嘱备注 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
        
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //序号  
      	allergen.AllerCode = AllergenArr[0];    //编码
      	allergen.AllerName = AllergenArr[1];    //名称  
      	allergen.AllerSymptom =AllergenArr[3]; //过敏症状 
      	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//病生状态类数组
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//诊断序号
     	medcond.DiseaseCode = MedCondArr[0];        //诊断编码
      	medcond.DiseaseName = MedCondArr[1];     //诊断名称
 		medcond.RecipNo = "";              //处方号
      	arrayMedCond[arrayMedCond.length] = medcond;     
      
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

/***********************美康相关 end  ****************************/					
function SetFocus()
{
	$("#txt-cardno").focus();
}

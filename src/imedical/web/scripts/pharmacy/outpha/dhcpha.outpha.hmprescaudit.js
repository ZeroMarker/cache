/*
 *ģ��:			��ҩ��
 *��ģ��:		��ҩ��-�����ҩ��
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
	/* ��ʼ����� start*/
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
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
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
	
	//���Żس��¼�
	$('#txt-cardno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txt-cardno").val());
			if (cardno!=""){
				BtnReadCardHandler();
			}
			SetFocus();	
		}
	});
	
	//�������лس��¼�
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
	/* ��Ԫ���¼� end*/
	InitBodyStyle();
})

//��������
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
//��ʼ����ҩtable
function InitGridAudit(){
	var columns=[
		{header:$g("�������"),index:'druguse',name:'druguse',width:65,formatter: druguseFormatter},
		{header:$g("�󷽽��"),index:'TAuditResult',name:'TAuditResult',width:65,cellattr: addPhDispStatCellAttr},
		{header:$g("��ҩ״̬"),index:'TDspStatus',name:'TDspStatus',width:65,hidden:true},
		{header:$g("�Ƿ�Ӽ�"),name:"TEmergFlag",index:"TEmergFlag",width:70,
			formatter: function(value, options, rowdata){
				if(value == "Y"){
					return $g("��");	
				}else{
					return $g("��");	
				}
			}	
		},
		{header:$g("����"),index:'TPatName',name:'TPatName',width:100},
		{header:$g("�ǼǺ�"),index:'TPmiNo',name:'TPmiNo',width:100},
		{header:$g("������"),index:'TPrescNo',name:'TPrescNo',width:110},
		{header:$g("��������"),index:"TPrescType",name:"TPrescType",width:80},
		{header:$g("����"),index:"TFactor",name:"TFactor",width:80},
		{header:$g("�ѱ�"),index:"TBillType",name:"TBillType",width:60},
		{header:$g("���"),index:'TMR',name:'TMR',width:300,align:'left'},
		//�������ڱ���ϻ�û���������¼��ĵط�����������鹵ͨ����ʱ�����ش�����Ϣ MaYuqiang 20200320
		{header:$g("�������"),index:'TMBDiagnos',name:'TMBDiagnos',width:150,align:'left',hidden:true},
		{header:$g("�Ա�"),index:'TPatSex',name:'TPatSex',width:40},
		{header:$g("����"),index:'TPatAge',name:'TPatAge',width:40},
		{header:$g("����"),index:'TPatLoc',name:'TPatLoc',width:100},
		{header:$g("�ܾ�����"),name:"TRefResult",index:"TRefResult",width:300,align:'left'},
		{header:$g("��������"),name:"TDocNote",index:"TDocNote",width:300,align:'left'},
		{header:'TAdm',index:'TAdm',name:'TAdm',width:60,hidden:true},
		{header:'TPapmi',index:'TPapmi',name:'TPapmi',width:60,hidden:true},
		{header:'TPatLoc',index:'TPatLoc',name:'TPatLoc',width:60,hidden:true},
		{header:'TOeori',index:'TOeori',name:'TOeori',width:60,hidden:true},
		{header:$g("�����ܼ�"),index:'TEncryptLevel',name:'TEncryptLevel',width:70,hidden:true},
		{header:$g("���˼���"),index:'TPatLevel',name:'TPatLevel',width:70,hidden:true}
	]; 
	var jqOptions={
		datatype:'local',
		colModel: columns, //��
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=PHA.OP.HMPreAudit.Query&MethodName=jsGetAdmPrescList', //��ѯ��̨	
		height: DhcphaJqGridHeight(1,3)+26,
		shrinkToFit: false,
		pager: "#jqGridPager", //��ҳ�ؼ���id 
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

//��ѯ��ҩ�б�
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
//��ѯ��ҩ��ϸ
function QueryGridAuditSub(){
	var selectid = $("#grid-cypresc").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-cypresc").jqGrid('getRowData', selectid);
	var prescNo = selrowdata.TPrescNo;
	var dispFlag = selrowdata.TFyFlag;
	var phartype = "OP";		// ��������
	var zfFlag = "�׷�"
	var useFlag = "2" 			// �������
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

 //���ͨ��
function PassPresc(){
	if (DhcphaGridIsEmpty("#grid-cypresc")==true){
		return;
	}
	var selectid=$("#grid-cypresc").jqGrid('getGridParam','selrow');
	if (selectid==null){
	    dhcphaMsgBox.alert("����ѡ����Ҫ��˵Ĵ�����");
	    return;
	}
	var selrowdata = $("#grid-cypresc").jqGrid('getRowData', selectid);
	var fyflag=selrowdata.TFyFlag;
	if (fyflag=="OK"){
		dhcphaMsgBox.alert("�ô����ѷ�ҩ���������ͨ��!");
		return;
	}
	var auditresult=selrowdata.TAuditResult;
	 if (auditresult.indexOf("����")>-1) {
        dhcphaMsgBox.alert("�ô������Ѿ�����,�������ͨ��!");
        return;
    }
	if(RePassNeedCancle=="Y"){
	    if (auditresult == "ͨ��") {
	        dhcphaMsgBox.alert("��ѡ��Ĵ�����ͨ��,�����ٴ����ͨ�� !");
	        return;
	    }
	    else if (auditresult.indexOf("�ܾ�") != "-1"){
		    dhcphaMsgBox.alert("��ѡ��Ĵ����Ѿܾ�,�賷��֮ǰ����˼�¼�����ٴ���� !");
	        return;
		}
    }

	var prescno=selrowdata.TPrescNo;
	var orditemStr=tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery","GetOrdStrByPrescno",prescno);
	var retVal=orditemStr.split("&&")[0];
	var orditem=orditemStr.split("&&")[1];
	if (retVal < 0) {
	        dhcphaMsgBox.alert(orditem+"�����ٴ����ͨ�� !");
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

//��˾ܾ�
function RefusePresc(){
	if (DhcphaGridIsEmpty("#grid-cypresc")==true){
		return;
	}
	var selectid=$("#grid-cypresc").jqGrid('getGridParam','selrow');
	var selrowdata = $("#grid-cypresc").jqGrid('getRowData', selectid);
	if (selectid==null){
	    dhcphaMsgBox.alert("û��ѡ�д���,���ܾܾ�!");
	    return;
	}
	var prescno=selrowdata.TPrescNo;
	if(prescno==""){
		dhcphaMsgBox.alert("��ѡ��Ҫ�ܾ��Ĵ���");
		return;
	}
  	var dspstatus=selrowdata.TDspStatus;
	if (dspstatus.indexOf("TC")<0){
		dhcphaMsgBox.alert("��ѡ��Ĵ����ѷ�ҩ,�޷��ܾ�!");
		return;
	}
	var auditresult=selrowdata.TAuditResult;
	if (auditresult.indexOf("����")>-1) {
        dhcphaMsgBox.alert("�ô������Ѿ�����,������˾ܾ�!");
        return;
    }
	if(RePassNeedCancle=="Y"){
	    if (auditresult == "ͨ��") {
	        dhcphaMsgBox.alert("��ѡ��Ĵ�����ͨ��,�賷��֮ǰ����˼�¼�����ٴ���� !");
	        return;
	    }
	    else if (auditresult.indexOf("�ܾ�") != "-1"){
		    dhcphaMsgBox.alert("��ѡ��Ĵ����Ѿܾ�,�賷��֮ǰ����˼�¼�����ٴ���� !");
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
//��˾ܾ�
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

 //��ȡ������˽�� 
function GetOrdAuditResultByPresc(prescno){
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc",prescno);
	return ref;
}

//���
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

//���������չ��Ϣmodal
function ViewPrescAddInfo(){
	var grid_records = $("#grid-cypresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("��ǰ����������!");
		return;
	}
  	var selectid=$("#grid-cypresc").jqGrid('getGridParam','selrow');
  	if (selectid==null){
		dhcphaMsgBox.alert("����ѡ����Ҫ�鿴�Ĵ�����¼!");
		return;  
	}
	$("#modal-prescinfo").modal('show');
}
//ע��modaltab�¼�
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

//�鿴��־
function ViewPrescMonitorLog(){
	var grid_records = $("#grid-cypresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("��ǰ����������!");
		return;
	}
  	var selectid=$("#grid-cypresc").jqGrid('getGridParam','selrow');
  	if (selectid==null){
		dhcphaMsgBox.alert("����ѡ����Ҫ�鿴�Ĵ�����¼!");
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
		dhcphaMsgBox.alert("δ���ô��������ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����");
		return;
	}
	var passTypeData = passTypeStr.split("^")
	var passType = passTypeData[0]
	if (passType=="DHC"){
		// ����֪ʶ��
		 DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "grid-cypresc", 
		 	MOeori: "TOeori",
		 	PrescNo:"TPrescNo", 
		 	GridType: "JqGrid", 
		 	Field: "druguse",
		 	ResultField:"druguseresult"
		 });
	}else if (passType=="DT"){
		// ��ͨ
		// StartDaTongDll(); 
		// DaTongPrescAnalyse();  
	}else if (passType=="MK"){
		// ����
		//MKPrescAnalyse(); 
	}else if (passType=="YY"){
	}
}

//Ȩ����֤
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
				permissionmsg="ҩ������:"+defaultLocDesc;
				permissioninfo="��δ������ҩ����Ա����ά��!"	
			}else {
				permissionmsg="����:"+gUserCode+"��������:"+gUserName;
				if (retdata.phuser==""){					
					permissioninfo="��δ������ҩ����Ա����ά��!"
				}else if(retdata.phnouse=="Y"){
					permissioninfo="����ҩ����Ա����ά����������Ϊ��Ч!"
				}else if(retdata.phaudit!="Y"){
					permissioninfo="����ҩ����Ա����ά����δ�������Ȩ��!"
				}
			}
			if (permissioninfo!=""){	
				$('#modal-dhcpha-permission').modal({backdrop: 'static', keyboard: false}); //���ɫ���򲻹ر�
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

//��ʽ����
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
	if (val=="ͨ��"){
		return "class=dhcpha-record-passed";
	}else if (val=="����"){
		return "class=dhcpha-record-appeal";
	}else if (val=="�ܾ�"){
		return "class=dhcpha-record-refused";
	}else{
		return "";
	}
}

//����
function BtnReadCardHandler(){
	var readcardoptions={
		CardTypeId:"sel-cardtype",
		CardNoId:"txt-cardno",
		PatNoId:"txt-patno"		
	}
	DhcphaReadCardCommon(readcardoptions,ReadCardReturn)
}
//�������ز���
function ReadCardReturn(){
	QueryGridPrescAudit();
}

/***********************��ͨ��� start****************************/
//��ʼ�� 
function StartDaTongDll(){
	dtywzxUI(0,0,"");
}
//����
function dtywzxUI(nCode,lParam,sXML){
   var result;
   result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);
   return result;
}
//����
function DaTongPrescAnalyse(){
	
	var mainrows=$("#grid-presc").getGridParam('records');
	if (mainrows==0){
	  	dhcphaMsgBox.alert("û����ϸ��¼!");
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

/***********************��ͨ��� end  ****************************/

/***********************������� start****************************/
// add by MaYuqiang 20181025	
function MKPrescAnalyse() {
	
	var mainrows=$("#grid-presc").getGridParam('records');
	if (mainrows==0){
		dhcphaMsgBox.alert("û����ϸ��¼!");
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
	var XHZYRetCode=0  //������鷵�ش���
	MKXHZY1(prescno,flag);
	//��Ϊͬ������,ȡ��McPASS.ScreenHighestSlcode
	//��Ϊ�첽����,����ûص���������.
	//ͬ���첽ΪMcConfig.js MC_Is_SyncCheck true-ͬ��;false-�첽
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
            //alert("û����");
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
	ppi.PatCode = PatArr[0];			// ���˱���
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // סԺ����
	ppi.Name = PatArr[1];				// ��������
	ppi.Sex = PatArr[2];				// �Ա�
	ppi.Birthday = PatArr[3];			// ��������
	
	ppi.HeightCM = PatArr[5];			// ���
	ppi.WeighKG = PatArr[6];			// ����
	ppi.DeptCode  = PatArr[8];			// סԺ����
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// ҽ��
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// ʹ��ʱ��
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
		//����core�ģ�������core���ر�Ƶ�Ψһ��ţ�����ĵ�div��idҲӦ�ú���������
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//ҩƷ���
        drug.OrderNo =OrderArr[0]; 		        		//ҽ����
        drug.DrugUniqueCode = OrderArr[1];  	//ҩƷ����
        drug.DrugName =  OrderArr[2]; 			//ҩƷ����
        drug.DosePerTime = OrderArr[3]; 	   //��������
		drug.DoseUnit =OrderArr[4];   	        //��ҩ��λ      
        drug.Frequency =OrderArr[5]; 	        //��ҩƵ��
        drug.RouteCode = OrderArr[8]; 	   		//��ҩ;������
        drug.RouteName = OrderArr[8];   		//��ҩ;������
		drug.StartTime = OrderArr[6];			//����ʱ��
        drug.EndTime = OrderArr[7]; 			//ͣ��ʱ��
        drug.ExecuteTime = ""; 	   				//ִ��ʱ��
		drug.GroupTag = OrderArr[10]; 	       //������
        drug.IsTempDrug = OrderArr[11];          //�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
        drug.OrderType = 0;    //ҽ������� 0-����(Ĭ��);1-������;2-��ͣ��;3-��Ժ��ҩ
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //�������ұ���
        drug.DeptName =  PrescMInfo[4]; 	  //������������
        drug.DoctorCode =PrescMInfo[6];   //����ҽ������
        drug.DoctorName =PrescMInfo[2];     //����ҽ������
		drug.RecipNo = "";            //������
        drug.Num = "";                //ҩƷ��������
        drug.NumUnit = "";            //ҩƷ����������λ          
        drug.Purpose = 0;             //��ҩĿ��(1Ԥ����2���ƣ�3Ԥ��+����, 0Ĭ��)  
        drug.OprCode = ""; //�������,���Ӧ������,��','����,��ʾ��ҩΪ�ñ�Ŷ�Ӧ��������ҩ
		drug.MediTime = ""; //��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
		drug.Remark = "";             //ҽ����ע 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
        
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //���  
      	allergen.AllerCode = AllergenArr[0];    //����
      	allergen.AllerName = AllergenArr[1];    //����  
      	allergen.AllerSymptom =AllergenArr[3]; //����֢״ 
      	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//����״̬������
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//������
     	medcond.DiseaseCode = MedCondArr[0];        //��ϱ���
      	medcond.DiseaseName = MedCondArr[1];     //�������
 		medcond.RecipNo = "";              //������
      	arrayMedCond[arrayMedCond.length] = medcond;     
      
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

/***********************������� end  ****************************/					
function SetFocus()
{
	$("#txt-cardno").focus();
}

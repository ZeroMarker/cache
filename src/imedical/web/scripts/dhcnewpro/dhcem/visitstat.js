//===========================================================================================
// ���ߣ�      huaxiaoying
// ��д����:   2018-05-07
// ����:	   ���ﲡ��״̬�ı�
//===========================================================================================
var userId = session['LOGON.USERID'];
var ctlocId = session['LOGON.CTLOCID'];
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var EpisodeID
/// ҳ���ʼ������
function initPageDefault(){
    LoadEpisodeID();          /// ��ʼ�������
    InitParams();             /// ��ʼ������
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	setEnableDisDom("");
	LoadHandler();
	GetPatBaseInfo();         /// ���˾�����Ϣ
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
	InitPageEditFlag();       /// ��ʼ��ҳ��Ĭ�����
}
function LoadEpisodeID(){
	var frm = dhcadvdhcsys_getmenuform();
	if (frm) {
	    EpisodeID = frm.EpisodeID.value;
	}
}

function InitParams(){
	
	
	var params = EpisodeID
	///��ȡȫ�ֱ���
	runClassMethod("web.DHCEMVisitStat","GetParams",{"Params":params},function(retString){
		DateFormat = retString.split("^")[0];
		DeceasedFlag = retString.split("^")[1];
		CurDate = retString.split("^")[2];
		CurTime = retString.split("^")[3];
	},'',false)
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	$('#UndoDischargeW').window('close'); //�رյ���

	///�ı�״̬����
	$HUI.datebox("#ChangeDate").setValue(CurDate);
	$HUI.timespinner("#ChangeTime").setValue(CurTime);
	
	///����״̬
	$HUI.combobox("#State",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatStatus&MethodName=GetAccessStatJsonList&LgParams="+LgParams,
		//w ##Class(web.DHCADMVisitStat).GetUserAccessStat("E","4634")
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		onSelect:function(option){
			var ret = validitStat(option.id);
			ret?ret=setEnableDisDom(option.id):"";
			ret?ret=setDateTimeDesc(option.id):"";
			return;
	    }	
	})
	
	///���ﲡ��
	$HUI.combobox("#EmWard",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetEmWard&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'text',
		//panelHeight:"auto",
		blurValidValue:true,
		onSelect:function(option){
	      
	    }	
	})
	
	///��Ժ����
	$HUI.combobox("#InWard",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetInWard&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		//panelHeight:"auto",
		onSelect:function(option){
	      
	    }	
	})
	
	
	///���˵�ǰ״̬
	runClassMethod("web.DHCADMVisitStat","GetPatCurStat",{"EpisodeID":EpisodeID},function(jsonString){
		var stat=jsonString.split("^")
		$("#CurState").val(stat[1]);
		if(stat[1]=="��Ժ"){
			$("#Cancel").css("display","inline");
			$HUI.combobox("#State").disable();			
		}
	},'',false)
	
	///����ȼ�
	runClassMethod("web.DHCEMVisitStat","GetPAADMPriorityDR",{"EpisodeID":EpisodeID},function(jsonString){
		$("#EmClass").val(jsonString);
	},'',false)
	
	
	///��������ԭ��
	$HUI.combobox("#CancelRea",{
		url:LINK_CSP+"?ClassName=web.DHCEMVisitStat&MethodName=GetRFDDesc",
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		blurValidValue:true,
		onSelect:function(option){
	    }	
	})
	
	/// ��Ժԭ��
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
		$("#patStatus").html("(�����ѹ�)");
	}
}

/// ��ʼ��ҳ��Ĭ�����
function InitPageEditFlag(){
	
	$HUI.combobox("#LeaveReason").disable();    /// ��Ժ����
}

function setDateTimeDesc(stateDesc){
	if(stateDesc=="Discharge"){
		$("#changeDateLab").text("��Ժ����");
		$("#changeTimeLab").text("��Ժʱ��");
		$("#updateNoteLab").text("��Ժԭ��");
	}else if(stateDesc=="Displace"){
		$("#changeDateLab").text("תԺ����");
		$("#changeTimeLab").text("תԺʱ��");
	}else if((stateDesc=="SalDeath")||(stateDesc=="Death")){    
		$("#changeDateLab").text("��������");
		$("#changeTimeLab").text("����ʱ��");
		$("#updateNoteLab").text("����ԭ��");
	}else if(stateDesc=="DisplaceOrInHospital"){
		$("#changeDateLab").text("ת��Ժ����");
		$("#changeTimeLab").text("ת��Ժʱ��");
		$("#updateNoteLab").text("ת��Ժԭ��");
	}else{
		$("#changeDateLab").text("�ı�״̬����");
		$("#changeTimeLab").text("ʱ��");
		$("#updateNoteLab").text("��Ժԭ��");
	}
	
	return true;
}

function validitStat(stateDesc){
	var ret=1;
	if(DeceasedFlag=="Y"){
		if(stateDesc!="Discharge"){
			ret=0;
			$HUI.combobox("#State").setValue("");
			$.messager.alert("��ʾ:","�����ѹ�,�������˲���");
		}
	}
	return ret;
}

//�������
function setEnableDisDom(stateDesc){
	
	if(stateDesc==""){
		$("#CurState").attr("disabled","disabled");  //���˵�ǰ״̬���ɱ༭  
		$HUI.datebox("#ChangeDate").disable();
		$HUI.timespinner("#ChangeTime").disable();
		$HUI.combobox("#InWard").disable();
		$HUI.combobox("#EmWard").disable();
		$("#EmClass").attr("disabled","disabled");	
		$HUI.linkbutton("#Update").disable();
		$("#EmRemark").attr("disabled", true); /// ת��ҽԺ
		return;
	}else{
		$HUI.datebox("#ChangeDate").enable();
		$HUI.timespinner("#ChangeTime").enable();	
		$HUI.linkbutton("#Update").enable();
	}
	
	//����
	if((stateDesc=="Stay")||stateDesc=="Salvage"){
		$HUI.combobox("#EmWard").enable();
	}else{
		$HUI.combobox("#EmWard").disable();
		$HUI.combobox("#EmWard").setValue("");
	}
	
	//��Ժ
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
	
	//��Ժ
	if(stateDesc=="Inhospital"){
		$HUI.combobox("#InWard").enable();
	}else{
		$HUI.combobox("#InWard").disable();
		$HUI.combobox("#InWard").setValue("");
		$HUI.combobox("#EmWard").setValue("");
	}

	// ת��ҽԺ
	if(stateDesc=="Displace"){
		$("#EmRemark").attr("disabled", false);
	}else{
		$("#EmRemark").val("").attr("disabled", true);
	}
	
	// ת��ҽԺ
	if(stateDesc=="DisplaceOrInHospital"){
		$HUI.combobox("#InWard").enable();
		$("#EmRemark").attr("disabled", false);
	}else{
		$HUI.combobox("#InWard").disable();
		$HUI.combobox("#InWard").setValue("");
		$HUI.combobox("#EmWard").setValue("");
		$("#EmRemark").val("").attr("disabled", true);
	}
	
	
	//ԭ���������ƣ���������Ժ��ת��Ժ����ѡ��
	if((stateDesc=="Death")||(stateDesc=="Discharge")||(stateDesc=="DisplaceOrInHospital")){
		$HUI.combobox("#LeaveReason").enable();
	}else{
		$HUI.combobox("#LeaveReason").disable();
		$HUI.combobox("#LeaveReason").setValue("");
	}
	
	return true;
}

//[{"id":"Arrival","text":"����"},{"id":"Exam","text":"���"},{"id":"Test","text":"����"},{"id":"Therapy","text":"����"},{"id":"Stay","text":"����"},{"id":"Inhospital","text":"��Ժ"},{"id":"Displace","text":"תԺ"},{"id":"Operation","text":"����"},{"id":"Salvage","text":"����"},{"id":"SalDeath","text":"��������"},{"id":"Death","text":"��ʱ����"},{"id":"SalSucess","text":"������Σ"}]

function LoadHandler(){
	runClassMethod("web.DHCEMPatChange","GetAdmType",
		{'admId':EpisodeID},
		function(retStr){
			if (retStr!="E") {
				alert("ֻ�ܶԼ��ﲡ�˲���!");
				return;
			}
	},'',false)
	
}

///  Ч��ʱ����¼�����ݺϷ���
function CheckEmPcsTime(id){

	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if ((InTime.length != 4)&(InTime.length != 6)){
		$.messager.alert("��ʾ:","��¼����ȷ��ʱ���ʽ��<span style='color:red;'>����:18:23:00,��¼��1823����182300</span>");
		$('#'+ id).val("");
		return "";
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("��ʾ:","Сʱ�����ܴ���23��");
		$('#'+ id).val("");
		return "";
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("��ʾ:","���������ܴ���59��");
		$('#'+ id).val("");
		return "";
	}
	
	var second = InTime.substring(4,6);
	if (second==""){
		second="00";
	}
	if (second > 59){
		$.messager.alert("��ʾ:","�������ܴ���59��");
		$('#'+ id).val("");
		return "";
	}
	
	return hour +":"+ itme+":"+second;
}

/// ��ȡ�����ʱ��������
function SetEmPcsTime(id){
	
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	InTime = InTime.replace(":","");
	return InTime;
}

///����
function Update(){
	
	var StatCode = $HUI.combobox("#State").getValue();
	
	if ((StatCode == "")|| (StatCode == undefined))  {
		$.messager.alert("��ʾ:","��ѡ����״̬!");
		return;
	}

	var DateStr=$HUI.datebox("#ChangeDate").getValue();
	var TimeStr=$HUI.timespinner("#ChangeTime").getValue();
	if ((DateStr == "") || (TimeStr == "")) {
		$.messager.alert("��ʾ:","������ʱ�䲻��Ϊ��!");
		return;
	}
	
	var visitStatDesc = $HUI.combobox("#State").getText();
	var curVisitStatDesc = $("#CurState").val();
	if (curVisitStatDesc == visitStatDesc) { 
		$.messager.alert("��ʾ:","���˵�ǰ״̬,���������״̬��ͬ(�����Ժ�ٻ�,����Ժʱ,������ղ��˵�ǰ״̬)"); 
		return; 
	}

	var isControl=0,abnOrdInfo="";
	if(StatCode=="Discharge"){
		var retInfo=serverCall("web.DHCEMPatChange","GetAbnormalOrder",{'EpisodeID':EpisodeID});
		if(retInfo!=0){
			isControl=retInfo.split(",")[0];
			abnOrdInfo=retInfo.substring(2,retInfo.length);
		}
		if(abnOrdInfo!=""){
			if(isControl!=0){
				$.messager.alert("��ʾ:","���ȴ������עҽ�������עҽ����Ϣ:"+abnOrdInfo,"info",function(){
					websys_createWindow("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+EpisodeID+"&defaultTypeCode=D","","width=99% height=99%");
				});
				return;
			}
		}
	}
	
	
	

	///���������ж�
	if ((StatCode == "Stay")||(StatCode == "Salvage")) {
		var EmergencyDesc = $HUI.combobox("#EmWard").getValue();    
		if (EmergencyDesc == "") {
			$.messager.alert("��ʾ:","������ѡ����!")
			return;
		}
		var ret = tkMakeServerCall("web.DHCBillInterface", "GetnotPayOrderByRegno", "", EpisodeID)
		if (ret == 1) {	
			$.messager.alert("��ʾ:","���˴���δ����ҽ��,���ܰ�������");
			return;
		}
		
		var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetIfStaying", EpisodeID)
		if (ret == 1) {
			$.messager.alert("��ʾ:","�����Ѿ�������,�����ٴΰ�������");
			return;
		}

		var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetIfHaveNoPayOrder", EpisodeID)
		if (ret == 1) {
			$.messager.alert("��ʾ:","������δ����ļ��������˵������ȵ����������۽��㡿���н���");
			return;
		}
	}

	var wardDesc = $HUI.combobox("#InWard").getText();   //��̨Ĭ�ϴ�����
	var emWardId = $HUI.combobox("#EmWard").getValue(); 
	wardDesc==""?wardDesc=$HUI.combobox("#EmWard").getText():"";

	var VsNote = "";
	// ת��ҽԺ
	if (StatCode=="DisplaceOrInHospital"){
		var EmRemark = $("#EmRemark").val();
		VsNote = $HUI.combobox("#LeaveReason").getText();
		if(VsNote==""){
			$.messager.alert("��ʾ","ת��Ժԭ����Ϊ�գ�");
			return;	
		}
		EmRemark==""?"":VsNote=VsNote+"["+EmRemark+"]";
	}
	// ��Ժ
	if(StatCode=="Discharge"){
		VsNote = $HUI.combobox("#LeaveReason").getText();              //��Ժԭ��
		if(VsNote==""){
			$.messager.alert("��ʾ","��Ժԭ����Ϊ��!");
			return;	
		}	
	}
	
	// ����
	if(StatCode=="Death"){
		VsNote = $HUI.combobox("#LeaveReason").getText();              //��Ժԭ��
		if(VsNote==""){
			$.messager.alert("��ʾ","����ԭ����Ϊ��!");
			return;	
		}	
	}
	
	
	var params = EpisodeID+"^"+StatCode+"^"+DateStr+"^"+TimeStr+"^"+userId+"^"+wardDesc+"^"+emWardId+"^"+0+"^"+ctlocId
	params = params+"^"+""+"^"+"" +"^"+ VsNote +"^"+ "";
	
	if((isControl==0)&&(abnOrdInfo!="")&&(StatCode=="Discharge")){			///���עҽ��δ���ùܿأ�ֻ��ʾ��
		$.messager.confirm('��ʾ', '�����账��ҽ�����Ƿ�ȷ����Ժ����?', function(result){  
        	if(result) {
	        	InsertVis(params,LgParams);
	        }
	    })
	}else{
		InsertVis(params,LgParams);	
	}
	return;
}

function InsertVis(params,LgParams){
	runClassMethod("web.DHCEMVisitStat","InsertVis",{"Params":params,"LgParams":LgParams},
		function(retStr){
			if (retStr != ""){
				if (retStr != 0) {
					if (retStr.indexOf("Ԥ����") != -1){
						$.messager.alert("��ʾ:",retStr,"info",function(){
							if(retStr.indexOf("Ԥ����������Ϣ")){
								window.open("dhcem.pay.advpayass.csp?EpisodeID="+EpisodeID);
							}
						});
					}else{
						$.messager.alert("��ʾ:",retStr,"info");
					}
				}else {
					$.messager.alert("��ʾ:","�����ɹ�!","info",function(){
						if(window.opener.parentFlash){
							window.opener.parentFlash();
						}
						window.location.reload();	
					});
				}
			}
		},'')	
}

///��������
function UndoDischarge() {

	var resStr = tkMakeServerCall("web.DHCADTDischarge", "GetFinalStat", EpisodeID)
	if (resStr != "0") {
		$.messager.alert("��ʾ",resStr)
		return;
	}
	$('#UndoDischargeW').window('open');  
}
///�����������
function UpdateUndo(){
	var reverseDesc=$HUI.combobox("#CancelRea").getText(); 
	///qqa 2018-07-27 ͳһʹ�û�ʿִ�г������㰴ť
	runClassMethod("web.DHCEMPatChange","DelDisorReversePay",{"Adm":EpisodeID,"userId":userId,"reverseDesc":reverseDesc},
		function(retStr){
			if (retStr != 0) $.messager.alert("��ʾ:",retStr); 
			else {
				$.messager.alert("��ʾ:","�����ɹ�!");
				if(window.opener.parentFlash){
					window.opener.parentFlash();
				}
				window.location.reload();
			}
	},'')

}

///2017-11-13  ���ӻ�ȡ���˲˵���Ϣ����
function dhcadvdhcsys_getmenuform(){
	var frm = null;
	try{
		var win=top.frames['eprmenu'];
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if(frm) return frm;
		}
		//���´��ڴ򿪵Ľ���
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


/// ���˾�����Ϣ
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "Ů"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/unman.png");
			}
		})
	},'json',false)
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPageDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'vsID',title:'vsID',width:100,align:'center',hidden:true},
		{field:'vsDesc',title:'����״̬',width:80,align:'center'},
		{field:'vsDate',title:'״̬����',width:100,align:'center'},
		{field:'vsTime',title:'״̬ʱ��',width:100,align:'center'},
		{field:'PatLoc',title:'���˿���',width:100,align:'center'},
		{field:'User',title:'������',width:100,align:'center'},
		{field:'Ward',title:'��Ժ����',width:100,align:'center'},
		{field:'vsNote',title:'��ע��Ϣ',width:140,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
	    onLoadSuccess:function (data) { //���ݼ�������¼�
	    	
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMVisitStat&MethodName=JsonQryVisitHis&EpisodeID="+ EpisodeID;
	new ListComponent('visgrid', columns, uniturl, option).Init();
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
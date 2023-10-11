//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2017-11-24
// ����:	   ���ﲡ���б�
//===========================================================================================

var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var defaultCardTypeDr;  /// Ĭ�Ͽ�����
var m_CardNoLength = 0;
var m_CCMRowID = "" ;
var PatListType = "Per"; /// �����б�
var PatArrFlag = "N";
var EmWardID = "";	     /// ���Ȳ���ID
var GlobleTypeCode="";
var PatType = "E"; var LgCtLocID=session['LOGON.CTLOCID']; var LgUserID=session['LOGON.USERID'];
var EmPatTypeArr = [{"value":"Loc","text":$g('���Ʋ���')}, {"value":"Per","text":$g('���˲���')}, {"value":"Grp","text":$g('���鲡��')},{"value":"Obs","text":$g('���۲���')}]; ///{"value":"A","text":'ȫ������'}, 

/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ��ҳ����ʽ
	InitPageStyle();
	
	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();
	
	InitDateBox();
	
	/// ��ʼ�����ز����б�
	InitPatList();
	
	InitPatInfoPanel();
	
	/// ��ѡ���¼�
	InitCheck();
	
	///Ĭ�ϲ�ѯһ��
	QryEmPatList()
}

function InitCheck(){
	//$HUI.checkbox("#PatDisEpi").setDisable(true);	  //��ʼ��Ĭ��Ϊ����״̬
}

/// ��ʼ��ҳ����ʽ
function InitPageStyle(){

	if (navigator.userAgent.indexOf("Chrome") == "-1"){
		$("#pf-bd").css({"height":$(document).height() - 140});
	}else{
		$("#pf-bd").css({"height":$(document).height() - 155});
	}
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	DateFormat = "";
	runClassMethod("web.DHCEMInComUseMethod","GetParams",{Params:""},
		function (rtn){
			DateFormat = rtn;
		},"text",false
	)	
	
	//EpisodeID = getParam("EpisodeID");
}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	$HUI.combobox("#KeptLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=jsonListWard&HospID="+session['LOGON.HOSPID'],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			$("#QytType").combobox("setValue","Obs");
			$HUI.checkbox("#PatEpiYes").setValue(true);
	        QryEmPatList();
	    }	
	})
	
	///�������
	$HUI.combobox("#AdmLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatLoc&HospID="+session['LOGON.HOSPID'],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			$("#QytType").combobox("setValue","Obs");
			$HUI.checkbox("#PatEpiYes").setValue(true);
	        QryEmPatList();
	    }	
	})	
	
	$HUI.combobox("#CheckLev",{
		data:[
			{"value":"1","text":$g("��")},//hxy 2020-02-21 ԭ��1 2 3 4
			{"value":"2","text":$g("��")},
			{"value":"3","text":$g("��")},
			{"value":"4","text":$g("��a��")},
			{"value":"5","text":$g("��b��")} //ed
		],
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       QryEmPatList();
	    }	
	})	
		
	
	/// ����
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
			if(option.value!="Obs"){
				$("#KeptLoc").combobox("setValue","");
				$("#AdmLoc").combobox("setValue","");
				$HUI.checkbox("#PatDisEpi").setValue(false);  ///ֻ����Ժ
			}else{
				$HUI.checkbox("#PatEpiYes").setValue(true);	
			}
			LoadEmPatByLoc(option.value);
		}
	}
	new ListCombobox("QytType",'',EmPatTypeArr,option).init();
	$("#QytType").combobox("setValue","Per");
	
	/// �ǼǺ�/����/���� �س��¼�
	$("#TmpCondition").bind('keypress',TmpCon_KeyPress);
	
	/// ���� �س��¼�
	$("#EmCardNo").bind('keypress',EmCardNo_KeyPress);

	$("#more").bind('click',MoreCondition);
}



/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	
	var frozenColumns=[[
		{field:'ItmXH',title:'���',width:40,align:'center'}
		]];
	///  ����columns
	var columns=[[
		//{field:'ItmXH',title:'���',width:40,align:'center'},
		//{field:'PAAdmBed',title:'����',width:80},
		{field:'PAAdmPriority',title:'��ǰ�ּ�',width:70,align:'center',formatter:setCellPAAdmPriority},
		{field:'LocSeqNo',title:'˳���',width:60,align:'center'},
		{field:'PatLevel',title:'��ʼ�ּ�',width:70,align:'center',formatter:setCellLevLabel},
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'PatName',title:'����',width:100},
		{field:'PatSex',title:'�Ա�',width:60,align:'center'},
		{field:'PatAge',title:'����',width:70,align:'center'},
		{field:'PCLvArea',title:'����',width:60,align:'center',styler:setCellAreaLabel},
		{field:'PAAdmDepCodeDR',title:'�������',width:120},
		{field:'PAAdmWard',title:'����',width:120,align:'center'},					 //+
		{field:'PAAdmBed',title:'����',width:80,align:'center'},                     //+
		{field:'Diagnosis',title:'���',width:190,align:'center'},
		{field:'PAAdmDate',title:'��������',width:120,align:'center'},
		{field:'PAAdmTime',title:'����ʱ��',width:120,align:'center'},				 //+
		{field:'WalkStatus',title:'״̬',width:80,align:'center'},				     //+
		{field:'RegDoctor',title:'�ű�',width:120,align:'center'},
		{field:'BillType',title:'��������',width:80,align:'center'},
		{field:'PAAdmDocCodeDR',title:'ҽ��',width:100,align:'center'},
		//{field:'LabPng',title:'������',width:70,align:'center',formatter: setCellLabLabel},
		{field:'PatGreFlag',title:'��ɫͨ��',width:70,align:'center',formatter:setCellGreenLabel},
		//{field:'PAAdmDate',title:'���ʱ��',width:150,align:'center',formatter:function(value, rowData, rowIndex){
		//	return rowData.PAAdmDate+"  "+rowData.PAAdmTime;
		//}},
		{field:'PCLvNurse',title:'���ﻤʿ',width:100},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'},
		//{field:'ItmPng',title:'��������',width:100},
		//{field:'OrdPng',title:'ҽ��',width:120},
		//{field:'StrTime',title:'����ʱ��',width:120},
		//{field:'ItmUnObr',title:'ͼ��˵�',width:80,
		//		formatter: function(value,row,index){
		//			return reservedToHtml(value);
		//		}},
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		headerCls:'panel-header-gray',
		toolbar:'#toolbar',
		rownumbers : false,
		singleSelect : true,
		pagination: true,
		frozenColumns:frozenColumns,
		onClickRow:function(rowIndex, rowData){
			
			setEprMenuForm(rowData.EpisodeID,rowData.PatientID,rowData.mradm,"");
	    },
		onLoadSuccess:function(data){
			
			///  ���÷�������
            if (typeof data.EmPatLevTotal == "undefined"){return;}
        	$(".l-btn-text:contains('"+$g("����")+"')").html($g("����")+"(" + data.EmPatLevCnt1 +")");
        	$(".l-btn-text:contains('"+$g("����")+"')").html($g("����")+"(" + data.EmPatLevCnt2 +")"); //hxy 2020-02-21 st
			$(".l-btn-text:contains('"+$g("����")+"')").html($g("����")+"(" + data.EmPatLevCnt3 +")"); //ԭ��EmPatLevCnt2
			$(".l-btn-text:contains('"+$g("����")+"')").html($g("����")+"(" + data.EmPatLevCnt4 +")"); //ԭ��EmPatLevCnt3 ed
		},
		rowStyler:function(index,rowData){   

	    },
	    onDblClickRow: function (rowIndex, rowData) {
		    setEprMenuForm(rowData.EpisodeID,rowData.PatientID,rowData.mradm,"");
		    PageJumpControl();
			//˫��ѡ���б༭
        }
	};
	/// ��������
	var param = "^^^"+ PatType +"^^^^N^^^^^"+LgCtLocID +"^"+ LgUserID +"^^^^^"+ PatListType;
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=JSonQryEmMainPatList&params="+param;
	new ListComponent('PatList', columns, uniturl, option).Init(); 
}

/// ����ͼ��˵�
function reservedToHtml(str){
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

/// ������ͼ��
function setCellLabLabel(value, rowData, rowIndex){
	
	var html = '<a href="javascript:void(0);" onclick="showLabWin(1,'+ rowData.PatientID +')"><img src="../scripts/dhcnewpro/images/em_exam.png"/></a>';
	html += '<a href="javascript:void(0);" onclick="showLabWin(2,'+ rowData.PatientID +')"><img src="../scripts/dhcnewpro/images/em_lab.png"/></a>';
	return html;	
}

/// �ּ�
function setCellLevLabel(value, rowData, rowIndex){
	var fontColor = "";
	/*if ((value == "1��")||(value == "2��")){ fontColor = "#F16E57";} //hxy 2020-02-21 st
	if (value == "3��"){ fontColor = "#FFB746";}
	if (value == "4��"){ fontColor = "#2AB66A";}*/
	if (value == "1��"){ fontColor = "#F16E57";}
	if (value == "2��"){ fontColor = "orange";}
	if (value == "3��"){ fontColor = "#FFB746";}
	if ((value == "4��")||(value == "5��")){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>"; //hxy 2020-02-21
}

function setCellPAAdmPriority(value, rowData, rowIndex){
	var fontColor = "";
	/*if ((value == "1��")||(value == "2��")){ fontColor = "#F16E57";} //hxy 2020-02-21 st
	if (value == "3��"){ fontColor = "#FFB746";}
	if (value == "4��"){ fontColor = "#2AB66A";}*/
	if (value == "1��"){ fontColor = "#F16E57";}
	if (value == "2��"){ fontColor = "orange";}
	if (value == "3��"){ fontColor = "#FFB746";}
	if ((value == "4��")||(value == "5��")){ fontColor = "#2AB66A";} //ed
	return "<font color='" + fontColor + "'>"+setCell(value)+"</font>";	//hxy 2020-02-21
}

/// ��ɫͨ��
/// zhouxin
/// 2018-07-18
function setCellGreenLabel(value, rowData, rowIndex){
	var fontColor = "";
	var html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.EpisodeID+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/></a>';
	if (value == "��"){ html = '<a href="javascript:void(0);" onclick="showGreenRec('+rowData.EpisodeID+')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"/></a>'; }
	return html;
	
}
function showGreenRec(adm){
	var option = {
		minimizable:false,
		iconCls:'icon-save',
		onClose:function(){QryEmPatList()}
	}
	new WindowUX("��ɫͨ��","PatLabWin", 700, 420 , option).Init();
	
	var LinkUrl ='dhcem.green.rec.csp?EpisodeID='+adm;
	if ('undefined'!==typeof websys_getMWToken){
		LinkUrl += "&MWToken="+websys_getMWToken()
	}
	var content = '<iframe class="page-iframe" src="'+ LinkUrl +'" frameborder="no" border="no" height="98%" width="100%" scrolling="no"></iframe>';
	$("#PatLabWin").html(content);
	return;		
}

/// ȥ��
function setCellAreaLabel(value, row, index){
	if (value == $g("����")){
		return 'background-color:#F16E57;color:white';
	}else if (value == $g("����")){ //hxy 2020-02-21 st
		return 'background-color:orange;color:white'; //ed
	}else if (value == $g("����")){
		return 'background-color:#FFB746;color:white';
	}else if (value == $g("����")){
		return 'background-color:#2AB66A;color:white';
	}else{
		return '';
	}
}

/// ��ȡ������Ϣ
function GetEmRegPatInfo(){
	
	runClassMethod("web.DHCEMDocMainOutPat","GetEmRegPatInfo",{"EpisodeID": EpisodeID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			InitPatInfoPanel(rowData);
		}
	},'json',false)
}

/// ����
function CallPatient(){
	
	///���ýкŹ�˾��webervice���к���
	runClassMethod("web.DHCDocOutPatientList","SendCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
			if(retArr[0]=="0"){
				search("");  /// ��ѯ�����б�
				return;
			}
		}
	},'',false)
}

/// �ظ�����
function reCallPatient(){

	///���ýкŹ�˾��webervice�����ظ�����
	runClassMethod("web.DHCDocOutPatientList","SendReCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
		}
	},'',false)
}

/// ����
function OutCallQueue(){
	
	//var rowData = $('#patTable').bootstrapTable('getAllSelections');
	if (SelectedRowData == ""){
		dhccBox.alert("����ѡ��Ҫ���ŵĲ��˺����ԣ�","register-one");
		return;
	}
	var AdmDate=SelectedRowData.PAAdmDate;
	if (CheckAdmDate(AdmDate)==false) {
		dhccBox.alert("��ѡ���վ��ﲡ�ˣ�","register-one");
		return;
	}
	if(SelectedRowData.Called == ""){
		dhccBox.alert("û�к��еĲ��˲��ܹ��ţ�","register-one");
		return;
	}

	var PatName=SelectedRowData.PatName;
	var Patient="�ǼǺ�: "+SelectedRowData.PatNo+" ����: "+PatName;
	dhccBox.confirm("�Ի���",Patient + "�Ƿ���Ҫ����?","my-modalone",function(res){
		if (res){
			var EpisodeID = SelectedRowData.EpisodeID; /// ����ID
			var DoctorId = SelectedRowData.RegDocDr;   /// ҽ��ID
			runClassMethod("web.DHCDocOutPatientList","SetSkipStatus",{"Adm":CardTypeID,"DocDr":DocDr},function(jsonString){
	
				if (jsonString != ""){
					dhccBox.alert("����ʧ�ܣ�ʧ��ԭ��:" + jsonString,"register-one");
				}
			},'',false)

			search(""); /// ���²�ѯ�����б�	
		}
	})
}

/// �ǼǺ�/����/���� �س��¼�
function TmpCon_KeyPress(e){

	if(e.keyCode == 13){
		var TmpCondition = $("#TmpCondition").val();
		if (!TmpCondition.replace(/[\d]/gi,"")&(TmpCondition != "")){
			///  �ǼǺŲ�0
			TmpCondition = GetWholePatNo(TmpCondition);
			$("#TmpCondition").val(TmpCondition);
		}
		QryEmPatList();
	}
}

/// ��ѯ
function QryEmPatList(){
	/// ����
	var CardNo = $("#EmCardNo").val();
	var TmpCondition = $("#TmpCondition").val();
	/// ��ʼ����
	var StartDate = $HUI.datebox("#StartDate").getValue();
	/// ��������
	var EndDate = $HUI.datebox("#EndDate").getValue();
	var DisHosp = $HUI.checkbox("#PatDisEpi").getValue();
	DisHosp=DisHosp==true?"D":"AD";
	var PatEpi = $HUI.checkbox("#PatEpiYes").getValue();
	PatEpi=PatEpi==true?"Y":"N";
	
	PatListType = ($HUI.combobox("#QytType").getValue()==undefined?"":$HUI.combobox("#QytType").getValue());
	EmWardID = ($HUI.combobox("#KeptLoc").getValue()==undefined?"":$HUI.combobox("#KeptLoc").getValue());
	CheckLev = ($HUI.combobox("#CheckLev").getValue()==undefined?"":$HUI.combobox("#CheckLev").getValue());   //qqa 20180310 ���ӵ�ǰ�ּ���ѯ����
	AdmLoc = ($HUI.combobox("#AdmLoc").getValue()==undefined?"":$HUI.combobox("#AdmLoc").getValue());  
	
	var params = "^^^"+ PatType +"^"+ CardNo +"^"+ StartDate +"^"+ EndDate +"^"+ PatEpi +"^^^^^"+LgCtLocID +"^"+ LgUserID +"^^"+ TmpCondition 
		+"^^"+GlobleTypeCode+"^"+ PatListType +"^"+ EmWardID+"^"+CheckLev+"^^"+DisHosp + "^"+ AdmLoc
	
	
	$("#PatList").datagrid("load",{"params":params}); 
}

/// ���� ��
function ReadCard() {
	DHCACC_GetAccInfo7(ReadCardCallback);
}
/// ����
function ReadCardCallback(rtnValue){
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
		case '0':
			$('#EmCardNo').val(myAry[1]);
			patientId = myAry[4];
			break;
		case '-200':
			$.messager.alert("��ʾ", "����Ч", "info", function() {
				$("#EmCardNo").focus();
			});
			break;
		case '-201':
			$('#EmCardNo').val(myAry[1]);
			patientId = myAry[4];
			break;
		default:
		}
	if (patientId != "") {
		QryEmPatList();   /// ��ѯ
	}
}

function M1Card_InitPassWord(){
	
	try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
    }catch(e){}
}

/// ���ز����б�
function LoadEmPatByCurType(TypeCode){
	
	/// ����
	var CardNo = $("#EmCardNo").val();
	var TmpCondition = $("#TmpCondition").val();
	var StayInWard = ""; var OutArrQue = ""; var OutRegQue = "";
	if (TypeCode == "E"){ StayInWard = "E"; }  /// ��������
	if (TypeCode == "R"){ StayInWard = "R"; }  /// ��������
	//var params = "^^^"+ PatType +"^^^^"+ OutArrQue +"^"+ OutRegQue +"^^^^"+LgCtLocID +"^"+ LgUserID +"^^"+ TmpCondition +"^"+ StayInWard;
	//$("#PatList").datagrid("load",{"params":params}); 
}

/// ����ȥ��
function TransPatToArea(Type){
	GlobleTypeCode = Type;
	QryEmPatList();
	GlobleTypeCode="" ;  //
	return;
}

///  ���Żس�
function EmCardNo_KeyPress(e){

	if(e.keyCode == 13){
		var CardNo = $("#EmCardNo").val();
		if (CardNo == "") return;
		DHCACC_GetAccInfo("", CardNo, "", "", ReadCardCallback);
	}
}

/// ���ز����б�
function LoadEmPatByLoc(PatListType){
	
	PatListType = PatListType;
	QryEmPatList();  /// ��ѯ�����б�
	
}

function EmRadio_KeyPress(event,value){

	//LoadEmPatByCurType(TypeCode)
}

var resetEprMenuForm = function(){
	setEprMenuForm("","","","");
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


function InitDateBox(){
	$HUI.datebox("#StartDate").setValue(formatDate(0));
	$HUI.datebox("#EndDate").setValue(formatDate(0));	
}

/// �����ѯ����
function MoreCondition(){

	if ($(".more-panel").is(":hidden")){
		$(".more-panel").css("display","block");
		$("#pf-bd").height($("#pf-bd").height()-32);
		$("#PatList").datagrid("resize",{height:$("#pf-bd").height()-32})
		$(".more i").removeClass("more-bk-down").addClass("more-bk-up");
	}else{
		$(".more-panel").css("display","");
		$("#pf-bd").height($("#pf-bd").height()+32);
		$("#PatList").datagrid("resize",{height:$("#pf-bd").height()+32});
		$(".more i").removeClass("more-bk-up").addClass("more-bk-down");
		$HUI.datebox("#StartDate").setValue("");
		$HUI.datebox("#EndDate").setValue("");
	}
}

/// ���������鴰��
function showLabWin(LabType, PatientID){
	/*
	var lnk =(LabType == "1"?"dhcem.seepatlis.csp":"dhcem.inspectrs.csp")+"?PatientID="+PatientID;
	var openCss = 'width='+(window.screen.availWidth)+',height='+(window.screen.availHeight-10)+ ', top=0, left=0, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	window.open(lnk,'newwindow',openCss) 
	*/
	/// ����ҽ�����б���
	var option = {
		iconCls:'icon-save'
	}
	var WinTitle = LabType == "1"?"����":"���";
	new WindowUX(WinTitle,"PatLabWin", $(document).width(), $(document).height()-20 , option).Init();
	
	var LinkUrl = (LabType == "1"?"dhcem.seepatlis.csp":"dhcem.inspectrs.csp")+"?PatientID="+PatientID;
	if ('undefined'!==typeof websys_getMWToken){
		LinkUrl += "&MWToken="+websys_getMWToken()
	}
	var content = '<iframe class="page-iframe" src="'+ LinkUrl +'" frameborder="no" border="no" height="100%" width="100%" scrolling="auto"></iframe>';
	$("#PatLabWin").html(content);	
	return;
}

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('������ʾ',"�ǼǺ��������");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// ��ת������ҽ������
function PageJumpControl(){
	var LinkUrl ="websys.csp?a=a&homeTab=dhcem.patoverviews.csp&PersonBanner=dhcdoc.patinfo.banner.csp&PatientListPage=dhcem.patlist.csp&TMENU=57449&TPAGID=148500597";
	if ('undefined'!==typeof websys_getMWToken){
		LinkUrl += "&MWToken="+websys_getMWToken()
	}
    window.location = LinkUrl;
}

/// ����
function LoadPatArrYes(event,value){
	if (value){
		$("[name='EM']").each(function(){
			$HUI.checkbox("#"+this.id).setValue(false);
		})
	}else{
		if(!$HUI.checkbox("#PatEpiNo").getValue()){
			$HUI.checkbox("#PatEpiNo").setValue(true);
		}
	}
}
/// ����
function LoadPatArrNo(event,value){
	if (value){
		$("[name='EM']").each(function(){
			$HUI.checkbox("#"+this.id).setValue(false);
		})
	}else{
		if(!$HUI.checkbox("#PatEpiYes").getValue()){
			$HUI.checkbox("#PatEpiYes").setValue(true);
		}
	}
}

function ClickPatDisEpi(event,value){
	if(value){
		$("#QytType").combobox("setValue","Obs");
		$HUI.checkbox("#PatEpiYes").setValue(true);
		QryEmPatList();
	}
	return;
}

//hxy 2020-02-21
function setCell(value){
	if(value=="1��"){value=$g("��");}
	if(value=="2��"){value=$g("��");}
	if(value=="3��"){value=$g("��");}
	if(value=="4��"){value=$g("��a��");}
	if(value=="5��"){value=$g("��b��");}
	return value;
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })

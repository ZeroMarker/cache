//===========================================================================================
// ���ߣ�      qqa
// ��д����:   2019-04-23
// ����:	   �����ѯ����
//===========================================================================================

var showModel="1";
var LgUserCode = session['LOGON.USERCODE'];  /// 
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var PageWidth=""     //����ҳ��Ŀ�ȣ�����Ӧ
var WinName=""
/// ҳ���ʼ������
function initPageDefault(){
	
	
	InitNorth();  //סԺҽ������˵����������ѯ
	getWidth()
		
	initCombobox();	  /// ��ʼ��combobox
	
	initDatagrid();	  /// ��ʼ��datagrid
	
	initMethod();     /// ���¼�
	
	multi_Language(); /// ������֧��
	
	initQuery();
	
	LoadMoreScr();
}

//סԺҽ������˵����������ѯ
function InitNorth(){
	if(window.name){ //��˵���ʶ
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

	/// ��ʼ����
	$HUI.datebox("#startDate").setValue(GetCurSystemDate(-7));
	
	/// ��������
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
	
	/// ����״̬
	$HUI.combobox("#consStatus",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetListMdtStatus&HospID="+ LgHospID+"&MWToken="+websys_getMWToken(),
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        qryConsList();
	    }	
	})	
	
	/// ���Ѳ��� 
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+ LgHospID+"&MWToken="+websys_getMWToken(),
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        qryConsList();
	    }	
	})
	
	/// ����ר�� 
	$HUI.combobox("#mdtRepExpert",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonLocCareProv&LocID="+ LgLocID+"&MWToken="+websys_getMWToken(),
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        
	    }	
	})
	
	$("#bt_make").linkbutton('disable'); /// ����ť
	$("#bt_acc").linkbutton('disable');  /// ������ť
	$("#bt_exe").linkbutton('disable');  /// ִ�а�ť
	$("#bt_feedback").linkbutton('enable'); ///���ﷴ��
	$("#bt_Reply").linkbutton('disable'); 	///����ظ�
	$("#bt_make").hide(); /// ����ť
	$("#bt_acc").hide();  /// ������ť
	$("#bt_exe").hide();  /// ִ�а�ť
	$("#bt_RevAcc").hide();  /// ȡ������
	$("#bt_RevExe").hide();  /// ȡ��ִ��
	$("#bt_Reply").hide();	 ///����ظ�
	$("#bt_conssig").hide();
}

function initDatagrid(){
	///  ����columns
	var columns=[[
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'���Ѳ���',width:140},
		{field:'PrvDesc',title:'�ű�',width:120},
		{field:'PreTime',title:'ԤԼʱ��',width:180},
		{field:'PayMony',title:'�շ�״̬',width:80,align:'center',formatter:
			function (value, row, index){
				if ($g(value) == $g("δ�շ�")){return '<font style="color:red;font-weight:bold;">'+$g(value)+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+$g(value)+'</font>'}
			}
		},
		{field:'CstStatus',title:'����״̬',width:80,align:'center',formatter:
			function (value, row, index){
				if ($g(value) == $g("����")){return '<font style="color:red;font-weight:bold;">'+$g(value)+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+$g(value)+'</font>'}
			}
		},
		{field:'isAccFlag',title:'�Ƿ����',width:80,align:'center'},
		{field:'AcceptNotes',title:'�ܾ�ԭ��',width:140},
		{field:'PatNo',title:'����ID',width:100},
		{field:'PatName',title:'����',width:100},
		{field:'PatSex',title:'�Ա�',width:60},
		{field:'PatAge',title:'����',width:60},
		{field:'PatLoc',title:'�������',width:120},
		{field:'PatDiag',title:'���',width:140},
		{field:'CstRLoc',title:'����������',width:120},
		{field:'CstRUser',title:'�������ҽʦ',width:100},
		{field:'CstRTime',title:'����ʱ��',width:160},
		{field:'CstTrePro',title:'��Ҫ����',width:400,formatter:SetCellField},
		{field:'CstPurpose',title:'�������ɼ�Ҫ��',width:400,formatter:SetCellField},
		{field:'CstLocArr',title:'�μӻ������',width:220},
		{field:'CstPrvArr',title:'�μӻ���ҽʦ',width:220},
		{field:'OutHospConsDoc',title:'�μ���Ժҽʦ',width:220},
		{field:'CstNPlace',title:'����ص�',width:200},
		{field:'PrintFlag',title:'��֪��',width:80,align:'center',formatter:
			function (value, row, index){
				if (row.PrintFlag.indexOf("Z")!=-1){return '<font style="color:green;font-weight:bold;">'+$g("�Ѵ�ӡ")+'</font>'}
				else {return '<font style="color:red;font-weight:bold;">'+$g("δ��ӡ")+'</font>'}
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
			setConsNum(data); /// ����ʾ��Ϣ
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
			if (rowData.AuditFlag == "����"){
				return 'background-color:pink;';
			}
		}
	};
	/// ��������
	var param = getParams();
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetMdtQuery&Params="+param+"&MWToken="+websys_getMWToken();
	new ListComponent('PatList', columns, uniturl, option).Init(); 
	
}

function setTipMes(){
	if(!$("#tip").length){
		var html='<div id="tip" style="word-break:break-all;border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
		$('body').append(html);
	}
	
	/// ����뿪
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mousemove':function(){
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip ��ʾ��λ�ú������趨
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

/// ���ð�ť״̬
function setMenuButton(rowData){
	
	if ((showModel != 2)&&(showModel!=3)) return;
	
	if (rowData.stCode < 40){
		$("#bt_acc").show();     /// ����
		$("#bt_RevAcc").hide();  /// ȡ������
	}else{
		$("#bt_acc").hide();     /// ����
		$("#bt_RevAcc").show();  /// ȡ������
	}
	
	if (rowData.stCode < 80){
		$("#bt_exe").show();     /// ִ��
		$("#bt_RevExe").hide();  /// ȡ��ִ��
	}else{
		$("#bt_exe").hide();     /// ִ��
		$("#bt_RevExe").show();  /// ȡ��ִ��
	}
}

/// show MDT���뵥
function showMdtDetail(EpisodeID,PatientID,mdtID){
	var Link = "dhcmdt.reqcontainer.csp?EpisodeID="+EpisodeID +"&PatientID="+PatientID+"&ID="+mdtID+"&MWToken="+websys_getMWToken(); //+"&seeCstType=1";
	commonShowWin({
		url: Link,
		title: 'MDT���뵥',
		width: PageWidth,
		height: window.screen.availHeight - 120
	})	
}

function setConsNum(data){
	
	// ��������
	$('#cstUserCount').html("(" + data.IsCstUserNum +")");

	// ��������
	$('#cstLocCount').html("(" + data.IsCstLocNum +")");
	
	// ���˻���
	$('#csUserCount').html("(" + data.IsCsUserNum +")");
	
	// �������
	$('#groupUserCount').html("(" + data.IsGroupUserNum +")");
	


//	$("#cstUserNum").html("��������(" + data.IsCstUserNum +")");
//	$(".l-btn-text:contains('���˻���')").html("���˻���(" + data.IsCsUserNum +")");
//	$(".l-btn-text:contains('�������')").html("�������(" + data.IsGroupUserNum +")");	
	return;
}

function qrySelfSend(type){
	
	if(type=="1"){
		$('#bt_acc').linkbutton({text:$g('����')});
		if($("#cstUserNum").hasClass("btn-select")) return;
		$("#csUserNum").removeClass("btn-select");
		$("#cstUserNum").addClass("btn-select");
		$("#GroupUserNum").removeClass("btn-select");
		$("#cstLocNum").removeClass("btn-select");
		$("#bt_cancel").linkbutton('enable');  /// ȡ�����ﰴť
		$("#bt_acc").linkbutton('disable');  /// ������ť
		$("#bt_exe").linkbutton('disable');  /// ִ�а�ť
		$("#bt_make").linkbutton('disable'); /// ����ť
		$("#bt_Revisionexp").linkbutton('enable');  /// �޸�ר��
		$("#bt_feedback").linkbutton('enable'); ///���ﷴ��
		$("#bt_Reply").linkbutton('disable'); 	///����ظ�
		$("#bt_make").hide(); /// ����ť
		$("#bt_acc").show();  /// ������ť
		$("#bt_exe").hide();  /// ִ�а�ť
		$("#bt_feedback").show(); ///���ﷴ��
		$("#bt_Reply").hide(); 	 ///����ظ�
		$("#bt_conssig").hide();
		$("#bt_RevAcc").hide();  /// ȡ������
		$("#bt_RevExe").hide();  /// ȡ��ִ��
		
		$("#bt_cancel").show();	
		$("#bt_Revisionexp").show();  /// �޸�ר��
	}
	
	if(type=="2"){
		$('#bt_acc').linkbutton({text:$g('����')});
		if($("#csUserNum").hasClass("btn-select")) return;
		$("#csUserNum").addClass("btn-select");
		$("#cstUserNum").removeClass("btn-select");
		$("#GroupUserNum").removeClass("btn-select");
		$("#cstLocNum").removeClass("btn-select");
		$("#bt_cancel").linkbutton('disable');  /// ȡ�����ﰴť
		$("#bt_Revisionexp").linkbutton('enable');  /// �޸�ר��
		$("#bt_exe").linkbutton('disable');
		$("#bt_acc").linkbutton('enable');  /// ������ť
		$("#bt_exe").linkbutton('enable');  /// ִ�а�ť
		$("#bt_make").linkbutton('enable'); /// ����ť
		$("#bt_feedback").linkbutton('disable'); ///���ﷴ��
		$("#bt_Reply").linkbutton('enable'); 	 ///����ظ�
		$("#bt_cancel").hide();				///ȡ������
		$("#bt_Revisionexp").show();		///�޸�ר��
		$("#bt_make").show(); /// ����ť
		$("#bt_acc").show();  /// ������ť
		$("#bt_exe").show();  /// ִ�а�ť	
		$("#bt_feedback").hide(); ///���ﷴ��
		$("#bt_Reply").show(); 	 ///����ظ�
		$("#bt_conssig").show();
	}
	
	if(type=="3"){
		if($("#GroupUserNum").hasClass("btn-select")) return;
		$("#cstUserNum").removeClass("btn-select");
		$("#csUserNum").removeClass("btn-select");
		$("#GroupUserNum").addClass("btn-select");
		$("#cstLocNum").removeClass("btn-select");
		$("#bt_Revisionexp").hide();  /// �޸�ר��
	    
		$("#bt_acc").hide();  /// ������ť
		$("#bt_exe").hide();  /// ִ�а�ť	
		$("#bt_feedback").hide(); ///���ﷴ��
		$("#bt_Reply").hide(); 	 ///����ظ�
		$("#bt_conssig").show();
		$("#bt_exe").show();     /// ִ��
		$("#bt_RevAcc").hide();  /// ȡ������
		$("#bt_RevExe").hide();  /// ȡ��ִ��
		$("#bt_cancel").hide();	
		$("#bt_make").hide();		
		$("#bt_exe").linkbutton('enable');  /// ִ�а�ť
	}
	
	if(type=="4"){
		$('#bt_acc').linkbutton({text:$g('����')});
		if($("#cstLocNum").hasClass("btn-select")) return;
		$("#csUserNum").removeClass("btn-select");
		$("#cstUserNum").removeClass("btn-select");
		$("#GroupUserNum").removeClass("btn-select");
		$("#cstLocNum").addClass("btn-select");
		$("#bt_cancel").linkbutton('enable');  /// ȡ�����ﰴť
		$("#bt_acc").linkbutton('disable');  /// ������ť
		$("#bt_exe").linkbutton('disable');  /// ִ�а�ť
		$("#bt_make").linkbutton('disable'); /// ����ť
		$("#bt_Revisionexp").linkbutton('enable');  /// �޸�ר��
		$("#bt_feedback").linkbutton('enable'); ///���ﷴ��
		$("#bt_Reply").linkbutton('disable'); 	///����ظ�
		$("#bt_make").hide(); /// ����ť
		$("#bt_acc").show();  /// ������ť
		$("#bt_exe").hide();  /// ִ�а�ť
		$("#bt_feedback").show(); ///���ﷴ��
		$("#bt_Reply").hide(); 	 ///����ظ�
		$("#bt_conssig").hide();
		$("#bt_RevAcc").hide();  /// ȡ������
		$("#bt_RevExe").hide();  /// ȡ��ִ��
		
		$("#bt_cancel").show();	
		$("#bt_Revisionexp").show();  /// �޸�ר��
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

/// �ǼǺ�
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#regNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  �ǼǺŲ�0
			$("#regNo").val(GetWholePatNo(PatNo));
		}
		qryConsList();  /// ��ѯ
	}
}

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCMDTCom","GetPatRegNoLen",{},function(jsonString){

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

/// ���������ַ�
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

function initMethod(){
	$("#regNo").bind('keypress',PatNo_KeyPress);
}


/// ������Ϣ
function PatBaseWin(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	var EpisodeID = rowData.EpisodeID; ///rowData.AppAdmID;
	var PatientID = rowData.PatientID;
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼�����ԣ�","warning");
		return;
	}
	var mradm = "";
	/// �°没��
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID="+"&MWToken="+websys_getMWToken();
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

function setEprFromData(rowData){
	var EpisodeID = rowData.AppAdmID;   //ԤԼ�Һ�
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
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	var IsValid=GetIsTakOperFlagNew(rowData.ID,"10");
	if (IsValid!=0){
		$.messager.alert('��ʾ',IsValid,"error");
		return;
	}
	
	if(rowData.CstRUserID!=LgUserID){
		$.messager.alert('��ʾ','ȡ��������������뵥!','error');
		return;
	}
	
	var CstID =  rowData.ID;
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫ������ǰ����������', function(r){
		if (r){
			runClassMethod("web.DHCMDTConsult","CancelMdtCons",{"CstID":CstID, "LgParam":LgParam},function(jsonString){

				if (jsonString != 0){
					$.messager.alert("��ʾ:","ʧ��,��Ϣ:"+jsonString,"info");
				}else{
					$.messager.alert("��ʾ:","�����ɹ���","info");
					qryConsList();
				}
			},'text',false)
		}
	});
}


/// ����mdt����
function mdtSend(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if (rowData.CstStatus != ""){
		$.messager.alert('��ʾ',"��ǰ״̬��Ϊ����״̬���������ͣ�","error");
		return;
	}
	
	var EpisodeID = rowData.EpisodeID;
	var CstID = rowData.ID;
	
	/// ��֤�����Ƿ�����ҽ��
	TakOrdMsg = GetPatNotTakOrdMsg(EpisodeID);
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg,"warning");
		return;	
	}
	
	/// ����ж�
	if (GetMRDiagnoseCount(EpisodeID) == 0){
		$.messager.alert("��ʾ:","����û�����,����¼�룡","warning",function(){DiagPopWin()});
		return;	
	}
	
	/// ҽ�ƽ����ж�
	if (GetIsMidDischarged(EpisodeID) == 1){
		$.messager.alert("��ʾ:","�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����","warning");
		return;	
	}
	
	if (CstID == ""){
		$.messager.alert("��ʾ:","�뱣�����������ٷ��ͣ�","warning");
		return;
	}
	
	runClassMethod("web.DHCMDTConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam,"IpAddress":ClientIPAddress},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�ѷ��ͣ������ٴη��ͣ�","warning");
			return;
		}
		if (jsonString < 0){
			if(jsonString==-12){
				$.messager.alert("��ʾ:","�������뷢��ʧ�ܣ�ʧ��ԭ�����Ѿ����е��մ˺ű𣬲������ٴ�ԤԼ��","warning");		
			}
			$.messager.alert("��ʾ:","�������뷢��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			//isShowPageButton();     /// ��̬����ҳ����ʾ�İ�ť����
			$.messager.alert("��ʾ:","���ͳɹ���","info");
			qryConsList();
		}
	},'',false)
}


/// ��֤�����Ƿ�����ҽ��
function GetPatNotTakOrdMsg(EpisodeID){

	var NotTakOrdMsg = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

/// ��ȡ���˵���ϼ�¼��
function GetMRDiagnoseCount(EpisodeID){

	var Count = 0;
	/// ����ҽ��վ���ж�
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}

/// ��ȡҽ�ƽ����־
function GetIsMidDischarged(EpisodeID){

	var MidDischargedFlag = 0;
	/// ����ҽ��վ���ж�
	runClassMethod("web.DHCAPPExaReport","GetIsMidDischarged",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			MidDischargedFlag = jsonString;
		}
	},'',false)

	return MidDischargedFlag;
}


/// ������ϴ���
function DiagPopWin(){
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

/// ��������:Out
function mdtHandleWin(FlagCode){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if(rowData.PayMony==="δ�շ�"){
		if(FlagCode=="E"){
			$.messager.alert("��ʾ:","δ�շ�,��ֹ��ɲ�����","warning");
			return;
		}
	}
	
	var stCode = "";  /// MDT����״̬
	if (FlagCode == "P") stCode = (HasCenter != 0)?"30^35":"20^35";
	//if (FlagCode == "E") stCode = "40^75";
	if (FlagCode == "E"){
		var IsValid=GetIsTakOperFlagNew(rowData.ID,"80");
		if (IsValid!=0){
			$.messager.alert('��ʾ',IsValid,"error");
			return;
		}
	}
	
	var WriType=""; WidthFlag = 0; isShowModel = 1;
	if (FlagCode == "P") WriType = "P";
	if (FlagCode == "E") WriType = "E";
	if (FlagCode == "L") isShowModel = 3;
	var Link = "dhcmdt.execonclusion.csp?EpisodeID="+rowData.EpisodeID +"&ID="+rowData.ID +"&WriType="+WriType+"&showModel="+isShowModel+"&MWToken="+websys_getMWToken();
	mdtPopWin(FlagCode, Link); /// ����MDT���ﴦ����
}

function OpenConssig(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if(rowData.PayMony==="δ�շ�"){
		$.messager.alert("��ʾ:","δ�շ�,��ֹǩ��������","warning");
		return;	
	}

	var IsValid=GetIsTakOperFlagNew(rowData.ID,"70");
	if (IsValid!=0){
		$.messager.alert('��ʾ',IsValid,"error");
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
	new WindowUX($g('����ǩ��'), 'mdtPopAccWin', 800, (window.screen.availHeight - 350), option).Init();
}

/// ����MDT���ﴦ����
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
		new WindowUX($g('���ﴦ��'), 'newRefOpWin', 600, 330, option).Init();
	}else if (FlagCode == "R"){
		$("#mdtPopAccFrame").attr("src",Link);
		new WindowUX($g('MDT�޸�ҽ��'), 'mdtPopAccWin', (window.screen.availWidth - 100), 520, option).Init();
	}else{
		$("#mdtPopAccFrame").attr("src",Link);
		var WinTitle = "";
		if (FlagCode == "L"){
			WinTitle = $g("���ﲡ��");
		}else{
			WinTitle = FlagCode == "P"?$g("����"):$g("���");
		}
		new WindowUX(WinTitle||$g('MDT��������'), 'mdtPopAccWin', 1100, (window.screen.availHeight - 150), option).Init();
	}
}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCMDTCom","GetCurSysTime",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// ����
function AcceptCstNo(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var IsValid=GetIsTakOperFlagNew(rowData.ID,"50");
	if (IsValid!=0){
		$.messager.alert('��ʾ',IsValid,"error");
		return;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","AcceptCstMas",{"CstID":CstID, "LgUserID":LgUserID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������н��ղ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","���뵥�ѽ��գ������ٴν��գ�","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","���ճɹ���","info");
			$("#newRefOpWin").window("close");
			$('#PatList').datagrid('reload');
		}
	},'',false)	
}

/// ���ﴦ��
function mdtCsHandle(){

	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if(rowData.PayMony===$g("δ�շ�")){
		$.messager.alert("��ʾ:","δ�շ�,��������ջ��߾ܾ�������","warning");
		return;	
	}

	var itmCodes = "75^80"; /// ��������ʱ�������ں���״̬������༭
	if (GetIsTakOperFlag(rowData.ID, itmCodes)=="1"){
		$.messager.alert("��ʾ:","���뵥�Ѿ�������ɲ���,��������ջ��߾ܾ�������","warning");
		return;
	}
	
	$("#CstRefReason").val(rowData.CsDocRes);    /// ���ܲμ�ԭ��
	var FlagCode="H";
	mdtPopWin(FlagCode, ""); /// ����MDT���ﴦ����
}

/// �ܾ��μӻ���
function RefCstNo(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var IsValid=GetIsTakOperFlagNew(rowData.ID,"60");
	if (IsValid!=0){
		$.messager.alert('��ʾ',IsValid,"error");
		return;
	}
	
	var MdtRepExp = $HUI.combobox("#mdtRepExpert").getText();
	
	var CstRefReason = $("#CstRefReason").val(); /// ���ܲμ�ԭ��
	if (CstRefReason == ""){
		$.messager.alert('��ʾ',"����д�����ܲμ�ԭ��!","error");
		return;
	}
	
	///����ר��
	if(MdtRepExp!=""){
		CstRefReason = CstRefReason +" ����ר��Ϊ��"+ MdtRepExp;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","RefCstMas",{"CstID":CstID, "LgUserID":LgUserID, "CstNote":CstRefReason},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","����Ȩ�޲�����ǰ�����뵥��","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������оܾ��ղ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ܾ�ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			//$.messager.alert("��ʾ:","�ܾ��ɹ���","info");
			$("#CstRefReason").val("");    /// ���ܲμ�ԭ��
			$("#newRefOpWin").window("close");
			$('#PatList').datagrid('reload');
		}
	},'',false)	
}

/// �Ƿ��������
function GetIsOperFlag(CstID, stCode){

	var IsModFlag = ""; /// �Ƿ������޸�
	runClassMethod("web.DHCMDTConsult","GetIsOperFlag",{"CstID":CstID, "stCode":stCode},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// �Ƿ��������
function GetIsTakOperFlag(CstID, stCodes){

	var IsModFlag = ""; /// �Ƿ������޸�
	runClassMethod("web.DHCMDTConsult","GetIsTakOperFlag",{"CstID":CstID, "stCodes":stCodes},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// �Ƿ��������
function GetIsTakOperFlagNew(CstID, ToStCode){
	var Ret=$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"ValidStatus",
		ID:CstID,ToStatusIdCode:ToStCode,
		dataType:"text"
	}, false);
	return Ret;
}

/// �Ƿ�����ȡ�����
function GetIsCompUser(CstID){
	///�Ƿ���������
	var isCompUserInfo=$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"IsCompUser",
		CstID:CstID,
		UserID:LgUserID,
		dataType:"text"
	}, false);
	return isCompUserInfo;

}

/// ��ҳ�����
function reLoadMainPanel(EpisodeID){
	
	$('#PatList').datagrid('reload');
	$("#mdtPopAccWin").window("close");
//	if (EpisodeID){
//		OpenEmr(EpisodeID);
//	}
}

/// �򿪲��˵��Ӳ�������
function OpenEmr(EpisodeID){
	
	/// �°没��
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID="+"&MWToken="+websys_getMWToken();
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ����MDT���ﴦ����
function mdtHandle(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	if ((GetIsOperFlag(rowData.ID, "20") != "1")&(GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д˲�����","warning");
		return;
	}
	var Link=""
	Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID+"&MWToken="+websys_getMWToken();

	mdtPopWin("R", Link); /// ����MDT���ﴦ����
}

/// �޸�ר��
function modProWin(){
	
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if(showModel=="1"){
		if (GetIsTakOperFlag(rowData.ID, "20^30") != "1"){ //if (GetIsOperFlag(rowData.ID, "20") != "1"){ //hxy 2022-02-17
			$.messager.alert("��ʾ:","�Ƿ��ͺͰ���״̬,����������޸�ר��!","warning");
			return;
		}
	}
	
	///�Ǳ�������
	if(showModel!="1"){
		var itmCodes = "75^80"; /// ��������ʱ�������ں���״̬������༭
		if (GetIsTakOperFlag(rowData.ID, itmCodes)=="1"){
			$.messager.alert("��ʾ:","���뵥�Ѿ�������ɲ���,�������޸Ļ���ר�ң�","warning");
			return;
		}
	}
	
	var Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID+"&MWToken="+websys_getMWToken();
	commonShowWin({
		url: Link,
		title: $g("�޸�ר��"),
		width: 1200,
		height: 590
	})	
}

// ȡ������:out
function mCancelEva(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var stCode = "40^75";
	if (GetIsTakOperFlag(rowData.ID, stCode) != "1"){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������иò�����","warning");
		return;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","modConsultStatus",{"CstID":CstID, "stCodes":stCode, "userID":LgUserID, "WriType":"P"},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥������״̬�����������ȡ������������","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","ȡ������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","ȡ�������ɹ���","info");
			$('#PatList').datagrid('reload');
		}
	},'',false)	
}

// ȡ��ִ��
function mCancelExe(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var IsValid=GetIsTakOperFlagNew(rowData.ID,"75");
	if (IsValid!=0){
		$.messager.alert('��ʾ',IsValid,"error");
		return;
	}
	
	var IsCompUserInfo = GetIsCompUser(rowData.ID);
	var IsCompUser=IsCompUserInfo.split("^")[0];
	var CompUserName=IsCompUserInfo.split("^")[1];
	if((IsCompUser!=1)&&(CANCOMPSELF==1)){
		$.messager.alert("��ʾ","�ǻ��������,������ȡ�����!�������:"+CompUserName,"error");
		return;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","modConsultStatus",{"CstID":CstID, "stCodes":"", "userID":LgUserID, "WriType":"E"},function(jsonString){
		
		if(jsonString==0){
			$.messager.alert("��ʾ:","ȡ��ִ�гɹ���","info");
			$('#PatList').datagrid('reload');		
		}else{
			$.messager.alert("��ʾ:","ʧ��,��Ϣ:"+jsonString,"warning");
		}
	},'',false)	
}


/// �������
function matRev(){
	
    var rowData = $('#PatList').datagrid('getSelected');
    if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}

	
	var linkUrl ="dhcmdt.matreview.csp";
	if(IsOpenMoreScreen!="0") linkUrl="dhcmdt.mdtmodelwrite.csp";
		
	linkUrl+="?ID="+rowData.ID +"&mdtMakResID="+rowData.mdtMakResID+"&DisGrpID="+ rowData.DisGrpID+"&EpisodeID="+ rowData.EpisodeID+"&MWToken="+websys_getMWToken();
	
	commonShowWin({
		url: linkUrl,
		title: $g("�������"),
		width: $(window).width()-100,
		height: $(window).height() - 60
	})	
}

function ShowNowAccData(){
	var rowData = $('#PatList').datagrid('getSelected');
    if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
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
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	var lnk = "dhcmdt.uploadify.csp?MdtCstID="+rowData.ID+"&MWToken="+websys_getMWToken();
	commonShowWin({
		url: lnk,
		title: '�ϴ��鿴�ļ�',
		width:PageWidth,height:screen.availHeight-150,
	});
}

//���ﷴ��/�ظ�
function feedBackWin(flag){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var EpisodeID = rowData.EpisodeID; ///rowData.AppAdmID;
	var PatientID = rowData.PatientID;
	var CstID = rowData.ID

	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼�����ԣ�","warning");
		return;
	}
	
	
	
	var mradm = "";
	var title=(flag == "F"?"���ﷴ��":"����ظ�");
	var itmCodes = "80"; /// ��������ʱ�������ں���״̬������༭
	if (GetIsTakOperFlag(rowData.ID, itmCodes)!="1"){
		$.messager.alert("��ʾ:","���뵥δ���,������"+title+"��","warning");
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
		title: $g("���ﷴ��"),
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


/// ��ӡ
function Print(){
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if (GetIsOperFlag(rowData.ID, "10") == "1"){
		$.messager.alert('��ʾ',"��ǰ�����ѳ��������ܴ�ӡ!","error");
		return;
	}
	
	var mCstID = rowData.ID;
	if(PrintWay==1){
	    window.open("dhcmdt.printconsmdtopin.csp?CstID="+mCstID+"&MWToken="+websys_getMWToken());
	}else{
	    PrintCons(mCstID);  /// ��ӡ�������뵥	
	}
	
	$("#PatList").datagrid("reload");
	return;
}


/// ��ӡ��֪��
function printInfoSing(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if (rowData.PayMony == $g("δ�շ�")){
		//$.messager.alert('��ʾ',"��ǰ����δ�շѣ����ܴ�ӡ!","error");
		//return;
	}
	
	if (GetIsOperFlag(rowData.ID, "10") == "1"){
		$.messager.alert('��ʾ',"��ǰ�����ѳ��������ܴ�ӡ!","error");
		return;
	}
	
	var mCstID = rowData.ID;
	PrintCst_REQ(mCstID,mdtDisGrp);  /// ��ӡ�������뵥
	InsCsMasPrintFlag(mCstID,"Z"); ///�޸������ӡ�ֶ� 
	$("#PatList").datagrid("reload");
	return;
}

/// ��ӡ֮��ͬ����
function PrintInfoCons(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var CstID = rowData.ID;
	
	PrintConsent(CstID);
	return;
}

/// ��ӡ֮��ͬ����
function PrintConfApp(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var CstID = rowData.ID;
	
	PrintMakeDoc(CstID);
	return;
}

/// ���Ӳ�������
function OpenEmrWin(){
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
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
		title:"MDT����",
		iconCls:"icon-w-paper",
		width:PageWidth,
		height:800,
		onClose: function() {	
		}
	});	
}

/// ������֧��
function multi_Language(){
	
	$g("��ʾ");
	$g("����ѡ��һ�м�¼!");
	$g("���뵥��ǰ״̬����������д˲�����");
	$g("��������ܾ�ʧ�ܣ�ʧ��ԭ��:");
	$g("���뵥�Ǵ�����״̬����������оܾ��ղ�����");
	$g("����Ȩ�޲�����ǰ�����뵥��");
	$g("����д�����ܲμ�ԭ��!");
	$g("���뵥��ǰ״̬����������д��������");
	$g("���뵥��ǰ״̬����������иò�����");
	$g("���ճɹ���");
	$g("�����������ʧ�ܣ�ʧ��ԭ��:");
	$g("���뵥�ѽ��գ������ٴν��գ�");
	$g("���뵥�Ǵ�����״̬����������н��ղ�����");
	$g("���뵥��ǰ״̬����������иò�����");
	$g("���ͳɹ���");
	$g("�������뷢��ʧ�ܣ�ʧ��ԭ��:");
	$g("�������뷢��ʧ�ܣ�ʧ��ԭ�����Ѿ����е��մ˺ű𣬲������ٴ�ԤԼ��");
	$g("���뵥�ѷ��ͣ������ٴη��ͣ�");
	$g("�뱣�����������ٷ��ͣ�");
	$g("�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����");
	$g("����û�����,����¼�룡");
	$g("��ǰ״̬��Ϊ����״̬���������ͣ�");
	$g("ȡ���ɹ���");
	$g("��������ʧ�ܣ�ʧ��ԭ��:");
	$g("�Ѿ�ԤԼ�ɹ������벻��������");
	$g("��ǰ״̬�Ƿ���״̬����������");
	$g("��ȷ��Ҫȡ����ǰ����������");
	$g("ȷ�϶Ի���");
	$g("��ǰ���뵥�Ѿ��շѣ�������������");
	$g("��ǰ���뵥�Ƿ���״̬��������������");
	$g("��ѡ������¼�����ԣ�");
	$g("������ʾ");
	$g("�ǼǺ��������");
}

//���ݸ�ҳ��ȡ������Ŀ��
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

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })

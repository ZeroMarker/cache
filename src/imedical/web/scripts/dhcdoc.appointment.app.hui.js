var PageLogicObj = {
	RBApptScheduleList:"",
	ASRowId:"", //ѡ��ĳ����¼
	OldID:"",
	OldColor:"",
	SelectSeqNum:"", //��ʱ��ѡ������
	SelectMethcode:"", //ѡ����������ԤԼ��ʽCODE
	SelectTimeRange:"", //��ʱ��ѡ��ʱ����Ϣ
	AppAddFlag:"",
	PatientNo:""
}
$(function(){
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//�¼���ʼ��
	InitEvent();
	$("#CardNo").focus();
});
function PageHandle(){
	//֤����Ϣ
	$("[name='CCreadNum'],[name='mesage']").hide()
	//�������������Ƿ�����޿�ԤԼ
	if (ServerObj.CanNoCardApp!="Y"){
		$("#CNoCardApp").hide()
	}
	//Ĭ��չʾԤԼ��ť
	$("#CAppoint").show();
	$("#CAdd").hide()
	;PageLogicObj.AppAddFlag="APP"
	//�޿�ԤԼչʾ֤����Ϣ��дλ��
	$("#NoCardApp").checkbox({
		onChecked:function(){
			ClearPatInfo("N");
			if ((ServerObj.CommonCardNoStr.split("&").length)>1){
			   $('#CommonCardWin').window('open');	
			   InitCommonCardWin();
			}else{
				CommonCardclickRadio(ServerObj.CommonCardNoStr)
			}
			$("[name='CCreadNum'],[name='mesage']").show()
		},
		onUnchecked:function(){
			$("[name='CCreadNum'],[name='mesage']").hide();
			ClearPatInfo();
		}
	})
	//��ʼ��������Ϣ
	if (ServerObj.PatNo!=""){
		$("#PatNo").val(ServerObj.PatNo)
		PatNoSearch()
	}
	//��ʼ�������¼
	PageLogicObj.RBApptScheduleList=intAppTable()
	document.onkeydown = DocumentOnKeyDown;
	if (window.parent.PageLogicObj.LockPatientID==""){
		$("#BLockPatient").find(".l-btn-text").text($g("��������"));
	}else{
		$("#BLockPatient").find(".l-btn-text").text($g("ȡ������"));
		ServerObj.PatientID=window.parent.PageLogicObj.LockPatientID
		if (ServerObj.PatientID!=""){
			var PatNo=$.cm({
				ClassName:"web.DHCDocAppointmentHui",
				MethodName:"GetPatientNo",
				dataType:"text",
				PatientID:ServerObj.PatientID
			},false);
			ServerObj.PatNo=PatNo
		}
		//��ʼ��������Ϣ
		if (ServerObj.PatNo!=""){
			$("#PatNo").val(ServerObj.PatNo)
			PatNoSearch()
		}	
	}
}
function InitEvent()
{
	//ԤԼ
	$("#Appoint").click(function(){AppointClick("APP")});
	//ԤԼ
	$("#Add").click(function(){AddClick("DOCADD")});
	//�س��¼�
	$("#PatNo").keydown(function (e){
			var keycode = e.which;
			if(keycode==13){
				var patno=$("#PatNo").val()
				ClearPatInfo() 
				$("#PatNo").val(patno)	
				PatNoSearch()
			}
		}
	)
	$("#PatNo").keyup(function (e){
			if ($("#PatNo").val()==""){
				ClearPatInfo()
			}
		}
	)
	
	//�س��¼�
	$("#CardNo").keydown(function (e){
			var keycode = e.which;
			if(keycode==13){		
				CardNoKeyDownHandler()
			}
		}
	)
	$("#CardNo").keyup(function (e){
			if ($("#CardNo").val()==""){
				ClearPatInfo()
			}
		}
	)
	
	
	//����
	$("#BReadCard").click(ReadCardClickHandler);
	
	//��������
	$("#BLockPatient").click(BLockPatientClickHandler);
	//���߲�ѯ
	$("#BFindPat").click(BFindPatClick);
	//������Դ
	LoadTableList()
}

//���Żس�
function CardNoKeyDownHandler()
{
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return;
	ClearPatInfo() 
	$("#CardNo").val(CardNo)	
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardTypeCallBack);
	return false;
}


//�����¶�������
function ReadCardClickHandler()
{
	//�°�
	DHCACC_GetAccInfo7(CardTypeCallBack);
}

//��������
function CardTypeCallBack(myrtn)
{
    var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").val(CardNo);
			$("#PatNo").val(PatientNo);
			PatNoSearch()		
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч!","info",function(){
				$("#CardNo").focus();
			});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").val(CardNo);
			$("#CardTypeRowID").val(myary[8])
			$("#PatNo").val(PatientNo);
			PatNoSearch()
			break;
		default:
	}
}


//ԤԼ
function AppointClick(RegType)
{
	var rtn=CheckBeforeAppoint("APP")
	if (!rtn){return}
	var PatientID=ServerObj.PatientID
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var ASRowId=PageLogicObj.ASRowId;
	var QueueNo=PageLogicObj.SelectSeqNum;
	var SelectTimeRange=PageLogicObj.SelectTimeRange;
	var MethCode=PageLogicObj.SelectMethcode;
	var Note=$("#Note").val().replace(/(^\s*)|(\s*$)/g,'');
	var index=$('#RBApptScheduleList').datagrid('getRowIndex',ASRowId);
	var AppDate=$('#RBApptScheduleList').datagrid('getRows')[index]['AppDate'];
	var htmlAppDate=$cm({
		ClassName:"websys.Conversions",
		MethodName:"DateHtmlToLogical",
		dataType:"text",
		d:AppDate
	},false);
	//��֯�޿�ԤԼ��Ϣ
	var AppPatInfo=""
	var NoCardApp=$("#NoCardApp").checkbox('getValue')
	if (NoCardApp){
		var Name=$("#Name").val().replace(/(^\s*)|(\s*$)/g,'');
		var Phone=$("#Phone").val().replace(/(^\s*)|(\s*$)/g,'');
		var CreadNum=$("#CreadNum").val().replace(/(^\s*)|(\s*$)/g,'');
		var Address=""
		var AppPatInfo=Name+"$"+CreadNum+"$"+Phone+"$"+Address+"$$"+ServerObj.IDCredTypeId;
		/*var CommonPatientID=$.cm({
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetCommonPatientID",
			dataType:"text"
		},false);
		if (CommonPatientID==""){
			$.messager.alert("��ʾ","����ϵ��Ϣ��ά����������!")
			return false
		}
		PatientID=CommonPatientID.split("^")[0];*/
	}
	
	//��ȡԤԼ��ʽ
	if (MethCode==""){
		var MethCode=$cm({
			ClassName:"web.DHCDocAppointmentHui",
			MethodName:"GetAppointMethCode",
			dataType:"text",
			ASRowId:ASRowId,
			AppMethCodeStr:ServerObj.AppMethCodeStr,
		},false);
	
	}
	if (MethCode==""){
		$.messager.alert("��ʾ","ԤԼ��ʽ��Ч!")
		return false
	}
	//�жϿ����ԤԼ��������
	if (MethCode=="DOC"){
		var CheckFlag=$cm({
			ClassName:"web.DHCDocRegDocAppiont",
			MethodName:"CheckForASNumber",
			dataType:"text",
			ASRowID:ASRowId,
			LoginLocID:session['LOGON.CTLOCID'],
		},false);
		if (CheckFlag=="1"){
			$.messager.alert("��ʾ","���������ԤԼ����������")
			return false	
		}
	}
	var ret=$cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"OPAppDocBroker",
		dataType:"text",
		PatientID:PatientID,
		ASRowId:ASRowId,
		QueueNo:QueueNo,
		UserRowId:UserID,
		MethCode:MethCode,
		RegType:RegType,
		AppPatInfo:AppPatInfo,
		ExpStr:SelectTimeRange,
		Note:Note,
	},false);
	var retArr=ret.split("^");
	if(retArr[0]==0){
		$.messager.popover({msg: 'ԤԼ�ɹ�!',type:'success'});
		PageLogicObj.SelectSeqNum="",PageLogicObj.SelectTimeRange="";
		//������Դ
		LoadTableList();
		var AppID=retArr[1]; //ԤԼID
		//��Ҫͬ����ˢ�´��ڵ�������Ϣ
		try{
			window.parent.IntCalender();
			window.parent.LoadtabAppList();
			window.parent.AddClass(htmlAppDate);
		}catch(e){}
		//��ӡԤԼ��
		if (AppID!=""){
			PrintAPPMesag(AppID);
		}
		IntTimeRange("");
		if (window.parent.PageLogicObj.LockPatientID==""){
			ClearPatInfo();
		}
		/*if (r){
		    window.parent.destroyDialog("Appoint");
		}*/
	}else{
		var rettip=retArr[0];
  		if (retArr[0]==-203)rettip="ͣ�������İ������ԤԼ��";
  		if (retArr[0]==-301)rettip="����ÿ��ԤԼ�޶";
  		if (retArr[0]==-302)rettip="����ÿ��ԤԼ��ͬҽ�����޶";
		if (retArr[0]==-304)rettip="����ÿ��ÿ��ͬʱ��ͬ����ͬҽ���޶";
  		if (retArr[0]==-201)rettip="û��ԤԼ��Դ��";
  		if (retArr[0]==-223)rettip="��ԤԼ�����ѽ�������,��ʱ�޷�ԤԼ��"
  		if (retArr[0]==-303)rettip="�˲��˳���ÿ��ÿ�����ͬ�����޶"
  		if (retArr[0]==-402)rettip="��δ��ԤԼʱ��!"	
		$.messager.alert("��ʾ","ԤԼʧ�ܣ�"+rettip)
		LoadTableList()
		return false
	}
}

//ԤԼ�Ӻ�֮ǰ��⻼����Ч��Ϣ.
function CheckBeforeAppoint(Type)
{
	if (PageLogicObj.ASRowId==""){
		$.messager.alert("��ʾ","����ѡ����Ҫ��ԤԼ/�Ӻš����Ű���Ϣ!")
		return false
	}
	var CardNo=$("#CardNo").val();
	var CardTypeRowID=$("#CardTypeRowID").val();
	if ((CardNo=="")&&(CardTypeRowID =="")) {
		var CardNoStr=$.cm({
		    ClassName : "web.DHCOPAdmReg",
		    MethodName : "GetCardNoByPatientNo",
		    dataType:"text",
		    PatientNo:$("#PatNo").val()
	    },false);
	    var CardNo=CardNoStr.split("^")[0];
	    var CardTypeRowID=CardNoStr.split("^")[1];
	}
	if (CardNo!="") {
		var TemporaryCardFlag=CheckTemporaryCard(CardNo, CardTypeRowID);
		var IsTempCard=TemporaryCardFlag.split("^")[0];
		var DiscDate=TemporaryCardFlag.split("^")[1];
		if (IsTempCard=="Y"){
			if (Type =="APP") {
				$.messager.alert("��ʾ","��ʱ�����ܽ���ԤԼ!");
			}else if (Type =="ADD"){
				$.messager.alert("��ʾ","��ʱ��ֻ�ܹҼ����!");
			}
			return false;
		}
	}
	//���ԤԼ��Ҫ������Ϣ
	var NoCardApp=$("#NoCardApp").checkbox('getValue')
	if (!NoCardApp){
		if (ServerObj.PatientID==""){
			$.messager.alert("��ʾ","��ͨ��������������ǼǺ�ȷ����Ч�Ļ�����Ϣ!")
			return false
		}
		//���ߺ��������
		var BlackStr=$cm({
			ClassName:"web.DHCRBAppointment",
			MethodName:"GetLimitAppFlag",
			dataType:"text",
			PatientId:ServerObj.PatientID,
			IDCardNo:"",
		},false);
		var BlackFlag=BlackStr.split("^")[0];
		if (BlackFlag==1){
			$.messager.alert("��ʾ","���ߴ���ΥԼ��¼,�Ѿ������������������ԤԼ!")
			return false
		}
		
	}else{
		if (ServerObj.PatientID==""){
			$.messager.alert("��ʾ","��ͨ��������������ǼǺ�ȷ����Ч�Ļ�����Ϣ!")
			return false
		}
		var Name=$("#Name").val().replace(/(^\s*)|(\s*$)/g,'');
		if (Name==""){$.messager.alert("��ʾ","��������Ч�Ļ�������!");return false;}
		var Phone=$("#Phone").val().replace(/(^\s*)|(\s*$)/g,'');
		if (Phone==""){$.messager.alert("��ʾ","�����뻼����ϵ�绰!");return false;}
		var CreadNum=$("#CreadNum").val().replace(/(^\s*)|(\s*$)/g,'');
		if (CreadNum==""){$.messager.alert("��ʾ","�����뻼����Ч֤����Ϣ");return false;}
		if(CreadNum!=""){
		    var myIsID=DHCWeb_IsIdCardNo(CreadNum);
			if (!myIsID){
				$("#CreadNum").focus();
				return false;
			}
	  	}
	  	if (!CheckTelOrMobile(Phone,"Phone","��ϵ�绰")) return false;
		//֤���ŵĺ��������
		var BlackStr=$cm({
			ClassName:"web.DHCRBAppointment",
			MethodName:"GetLimitAppFlag",
			dataType:"text",
			PatientId:"",
			IDCardNo:CreadNum,
		},false);
		var BlackFlag=BlackStr.split("^")[0];
		if (BlackFlag==1){
			$.messager.alert("��ʾ","��֤���������ΥԼ��¼,�ѱ�����������С�������ԤԼ!")
			return false
		}
		
	}
	return true;
}

//�Ӻ�
function AddClick(RegType)
{
	var rtn=CheckBeforeAppoint("ADD")
	if (!rtn){return}
	var PatientID=ServerObj.PatientID
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var ASRowId=PageLogicObj.ASRowId;
	var QueueNo=""
	var SelectTimeRange=""
	var MethCode="DOCADD"
	var Note=$("#Note").val().replace(/(^\s*)|(\s*$)/g,'');
	var index=$('#RBApptScheduleList').datagrid('getRowIndex',ASRowId);
	var AppDate=$('#RBApptScheduleList').datagrid('getRows')[index]['AppDate'];
	var htmlAppDate=$cm({
		ClassName:"websys.Conversions",
		MethodName:"DateHtmlToLogical",
		dataType:"text",
		d:AppDate
	},false);
	//��֯�޿�ԤԼ��Ϣ
	var AppPatInfo=""
	var NoCardApp=$("#NoCardApp").checkbox('getValue')
	if (NoCardApp){
		var Name=$("#Name").val().replace(/(^\s*)|(\s*$)/g,'');
		var Phone=$("#Phone").val().replace(/(^\s*)|(\s*$)/g,'');
		var CreadNum=$("#CreadNum").val().replace(/(^\s*)|(\s*$)/g,'');
		
		var Address=""
		var AppPatInfo=Name+"$"+CreadNum+"$"+Phone+"$"+Address;
	}
	
	if (MethCode==""){
		$.messager.alert("��ʾ","ԤԼ��ʽ��Ч!")
		return false
	}
	
	var ret=$cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"OPAppDocBroker",
		dataType:"text",
		PatientID:PatientID,
		ASRowId:ASRowId,
		QueueNo:QueueNo,
		UserRowId:UserID,
		MethCode:MethCode,
		RegType:RegType,
		AppPatInfo:AppPatInfo,
		ExpStr:"",
		Note:Note,
	},false);
	var retArr=ret.split("^");
	if(retArr[0]==0){
		$.messager.alert('��ʾ', '�Ӻųɹ�')//, function(r){
			//������Դ
			LoadTableList();
			var AppID=retArr[1]; //ԤԼID
			//��Ҫͬ����ˢ�´��ڵ�������Ϣ
			try{
				window.parent.IntCalender();
				window.parent.LoadtabAppList();
				window.parent.AddClass(htmlAppDate);
			}catch(e){}
			//��ӡԤԼ��
			if (AppID!=""){
				PrintAPPMesag(AppID);
			}
			if (window.parent.PageLogicObj.LockPatientID==""){
				ClearPatInfo();
			}
			//if (r){
			//    window.parent.destroyDialog("Appoint");
			//} 
		//});
	}else{
		var rettip="";
  		if (retArr[0]==-203)rettip="��ͣ�������İ������ԤԼ��";
  		else if (retArr[0]==-301)rettip="������ÿ��ԤԼ�޶";
  		else if (retArr[0]==-302)rettip="������ÿ��ԤԼ��ͬҽ�����޶";
  		else if (retArr[0]==-304)rettip="������ÿ��ÿ��ͬʱ��ͬ����ͬҽ���޶";
  		else if (retArr[0]==-201)rettip="��û��ԤԼ��Դ��";
  		else if (retArr[0]==-223)rettip="����ԤԼ�����ѽ�������,��ʱ�޷�ԤԼ."
  		else if (retArr[0]==-303)rettip="���˲��˳���ÿ��ÿ�����ͬ�����޶�"	
  		else if (retArr[0]==-403)rettip="����δ���Ӻ�ʱ��!"	
  		else if (retArr[0]==-404)rettip="���Ѿ����˴��Ű��¼����ʱ���!"	
  		else if (retArr[0]==-405)rettip="���Ǳ��˺ű��ܼӺ�!"	
  		else if (retArr[0]==-213) rettip="���Ѿ�����ֹͣ�Һ�,������Ӻţ�";
  		else rettip="��"+retArr
  		if(RegType=="DOCADD"){rettip="�Ӻ�ʧ��"+rettip}
  		else{rettip="ԤԼʧ��"+rettip}
		$.messager.alert("��ʾ",rettip)
		LoadTableList()
		return false
	}
	
	
	
}
///�жϿ��Ƿ�����ʱ��
function CheckTemporaryCard(CardNo, CardTypeDr) {
	var TemporaryCardFlag=$.cm({
		ClassName:"web.DHCBL.CARD.UCardRefInfo",
		MethodName:"GetTemporaryCardFlag",
		CardTypeId:CardTypeDr,
		CardNo:CardNo,
		dataType:"text"
	},false)
	return TemporaryCardFlag
}


//�ǼǺŻس�
function PatNoSearch()
{
	var patno=$("#PatNo").val();
	if ((patno.length<ServerObj.PatNumLength)&&(ServerObj.PatNumLength!=0)) {
			for (var i=(ServerObj.PatNumLength-patno.length-1); i>=0; i--) {
				patno="0"+patno;
			}
	}
	$("#PatNo").val(patno)
	var rtn=$cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"getPatMesageByPatNo",
		dataType:"text",
		PatNo:patno,
		PatDr:"",
	},false);
	window.setTimeout("SetPatInfo('"+rtn+"')");
	
}

//���û�����Ϣ
function SetPatInfo(rtn) {
	if (rtn==""){
		$.messager.alert("��ʾ","������Ϣ��Ч��")
		return 
	}
	var CardNo=$("#CardNo").val()
	var CardTypeDr=$("#CardTypeRowID").val()
	var TempCardFlag=CheckTemporaryCard(CardNo, CardTypeDr)
	if(TempCardFlag=="Y") {
		$.messager.alert("��ʾ","��ʱ�����ܽ���ԤԼ�Ӻţ�")
		return 
	}
	var rtnarry=rtn.split("^")
	$("#Name").val(rtnarry[2])
	$("#Age").val(rtnarry[4])
	$("#Sex").val(rtnarry[3])
	$("#Phone").val(rtnarry[6])
	$("#AppBreakCount").val(rtnarry[15])
	var IsDeceased=rtnarry[16];
	if (IsDeceased =="Y") {
		$.messager.alert("��ʾ","����������!","info",function(){
			ClearPatInfo();
			$("#CardNo").focus();
		})
		return false;
	} 
	//$("#CreadNum").val(rtnarry[14]); //Ĭ�ϲ�չʾ����֤����Ϣ��ֹ��Ϣй¶
	ServerObj.PatientID=rtnarry[0]
	LoadTableList()
}
function LoadTableList()
{
	//��Ҫ���뻼����Ϣ ��ȡ�۸��ۿ�
	IntTimeRange("")
	$cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"FindApptSchedule",
		ApptSchedule:ServerObj.RBASRowID,
		AppointMethCode:ServerObj.AppMethCodeStr,
		PAPMIID:ServerObj.PatientID,
	},function(GridData){
		PageLogicObj.RBApptScheduleList.datagrid('unselectAll').datagrid('loadData',GridData)
	});	
}
function intAppTable()
{
	var tabdatagrid=$('#RBApptScheduleList').datagrid({  
	fit : true,
	width : 'auto',
	border : false,
	striped : true,
	singleSelect : true,
	checkOnSelect:false,
	//fitColumns : true,
	autoRowHeight : false,
	nowrap: false,
	collapsible:false,
	url : '',
	loadMsg : '������..',  
	pagination : false,  //
	rownumbers : true,  //
	idField:"RBScheduleDr",
	pageNumber:0,
	pageSize : 30,
	toolbar:[],
	pageList : [30,50,100],
	columns :[[ 
				{field:'AppDate',title:"��������",width:150,align:'left'},
				{field:'week',title:"����",width:60,align:'left'},
				{field:'timerangedesc',title:"����ʱ��",width:100,align:'left'}, 
				{field:'markdesc',title:"�ű�",width:150,align:'left'},
				{field:'sesstype',title:"���Ｖ��",width:150,align:'left'},
				{field:'AllNum',title:"����",width:150,align:'left'},
				{field:'UserNum',title:"������",width:100,align:'left'},
				{field:'CanUseNum',title:"������",width:100,align:'left'},
				{field:'totalnum',title:"�����޶�",width:100,align:'left'},
				{field:'addnum',title:"�Ӻ��޶�",width:100,align:'left'},
				{field:'booknum',title:"ԤԼ�޶�",width:100,align:'left'},
				{field:'roomdesc',title:"����",width:100,align:'left'},
				{field:'price',title:"���",width:100,align:'left'},
				{field:'SessionClinicGroupDesc',title:"רҵ��",width:100,align:'left'},
				{field:'AddFlag',title:"AddFlag",width:35,align:'left',hidden:true},
				{field:'RBScheduleDr',title:"�Ű�ID",width:35,align:'left',hidden:true},
				
			 ]] ,
			onSelect:function (rowIndex, rowData){
				//ѡ�п���ԤԼ/�Ӻ�
				var AddFlag=rowData.AddFlag
				if (AddFlag=="Y"){
					$("#CAppoint").hide();$("#CAdd").show();$('#timerangelist').html("");PageLogicObj.AppAddFlag="ADD";
					$("#CNoCardApp").hide()
				}
				else{
					$("#CAppoint").show();$("#CAdd").hide();IntTimeRange(rowData.RBScheduleDr);PageLogicObj.AppAddFlag="APP";
					$("#CNoCardApp").show();
				}
				
				//ѡ����Դ
				PageLogicObj.ASRowId=rowData.RBScheduleDr;
				
			},
			onLoadSuccess:function(rowData){
				$(this).datagrid('unselectAll');
				PageLogicObj.ASRowId="";
				for (var i=0;i<rowData.rows.length;i++){
					var SelectFlag=rowData.rows[i].SelectFlag
					if (SelectFlag==1){
						$(this).datagrid("selectRow",i)
						var AddFlag=rowData.rows[i].AddFlag
						if (AddFlag=="Y"){
							$("#CAppoint").hide();$("#CAdd").show();$('#timerangelist').html("");PageLogicObj.AppAddFlag="ADD";
							$("#CNoCardApp").hide()
						}
						else{
							$("#CAppoint").show();$("#CAdd").hide();IntTimeRange(rowData.rows[i].RBScheduleDr);PageLogicObj.AppAddFlag="APP";
							$("#CNoCardApp").show();
						}
						
						//ѡ����Դ
						PageLogicObj.ASRowId=rowData.rows[i].RBScheduleDr;
						}
					}
			},
			onUnselectAll:function(index, row){
				//IntTimeRange("");
			}
	
});
return tabdatagrid	
}

function IntTimeRange(ASRowId)
{
	PageLogicObj.OldID=""
	PageLogicObj.OldColor=""
	/*var datahtml = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"GetTimeRangeStrApp",
		dataType:"text",
		ASRowid:ASRowId,
		AppMedthod:ServerObj.AppMethCodeStr,
		MaxWeight:$("#timerangelist").width()
	},false);
	$('#timerangelist').html(datahtml)*/
	if (ASRowId=="") {
		$('#timerangelist').html("");
		return;
	}
	var innerHTML="<table border='1' class='diytable' cellspacing='1' cellpadding='0'>";
	var TimeRangeJson = $.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetTimeRangeStrApp",
	    ASRowid:ASRowId,
	    AppMedthod:ServerObj.AppMethCodeStr,
	    dataType:"text"
	},false);
	TimeRangeJson=eval('(' + TimeRangeJson + ')');
	var width=$("#timerangelist").width();
	var height=$("#timerangelist").height();
	var MaxLen=5;MaxCol=0;colNum=0;
	var Len=TimeRangeJson['row'].length;
	var col=TimeRangeJson['row'];
	for (var j=0;j<Len;j++){
		if (j%MaxLen==0) {
            innerHTML=innerHTML+"<tr>";
        }
		var SeqNo=col[j]['SeqNo'];
		var Time=col[j]['Time'];
		var Status=col[j]['Status'];
		if(Status==0){
			innerHTML=innerHTML+"<td class='td-seqno-invalid'>"+"<span class='td-seqno'>"+$g("����:��")+"</span><br><span class='td-time'>"+Time+"</span></td>";
		}else{
			innerHTML=innerHTML+"<td onclick=dbtdclick(this) ondblclick=dbtdclick(this) id='"+ASRowId+"_table_"+Time+"'>"+"<span class='td-seqno'>"+$g("����:��")+"</span><br><span class='td-time'>"+Time+"</span></td>";
		}
		innerHTML=innerHTML+"</td>";
		colNum=colNum+1;
		if (colNum==MaxLen) {
			innerHTML=innerHTML+"</tr>";
			colNum=0;
		}
		if (col.length>MaxCol) MaxCol=col.length;
	}
	if (colNum!=0)  innerHTML=innerHTML+"</tr>";
		innerHTML=innerHTML+"</table>";
	if (Len==0){
		innerHTML="";
	}
	$('#timerangelist').html(innerHTML);
}
function dbtdclick(obj){
	var id=obj.id;
	var Time=id.split("_table_")[1];
	PageLogicObj.SelectTimeRange=Time;
	$(".td-selecct").removeClass("td-selecct");
	$(obj).addClass("td-selecct");
}
//��ʱ��ѡ��ص�
function selectseqnum(seqno,statu)
{
	if (statu!=0){return}
	if (PageLogicObj.OldID==seqno){
		$('#SEQ'+PageLogicObj.OldID).removeClass("timerangediv-select")
		$('#SEQ'+PageLogicObj.OldID).addClass("timerangediv"); 
	
		PageLogicObj.SelectSeqNum=""
		PageLogicObj.SelectMethcode=""
		PageLogicObj.SelectTimeRange=""
		PageLogicObj.OldID=""
		PageLogicObj.OldColor=""
	}else{
		if (PageLogicObj.OldID!=""){
			$('#SEQ'+PageLogicObj.OldID).removeClass("timerangediv-select");
			$('#SEQ'+PageLogicObj.OldID).addClass("timerangediv");
		}
		$('#SEQ'+seqno).addClass("timerangediv-select"); 
		
		//ѡ�����Ϣ
		PageLogicObj.OldID=seqno
		PageLogicObj.SelectSeqNum=seqno
		PageLogicObj.SelectTimeRange=($('#SEQ'+seqno).attr("timrange"))
		PageLogicObj.SelectMethcode=($('#SEQ'+seqno).attr("methcode"))
	}		
}

///���������Ϣ
function ClearPatInfo(isReLoadRBASTable)
{
	if (!isReLoadRBASTable) isReLoadRBASTable="";
	$("#Name").val('')
	$("#Age").val('')
	$("#Sex").val('')
	$("#AppBreakCount").val('')
	$("#CreadNum").val('')
	$("#Note").val('')
	$("#PatNo").val('')
	$("#Phone").val('')
	$("#CardNo").val('')
	$("#CardTypeNew").val('');
	$("#CreadNum").val('');
	ServerObj.PatientID="";
	ServerObj.PatNo="";
	$("#CardTypeRowID").val('')
	$("#NoCardApp").checkbox('uncheck');
	if (isReLoadRBASTable!="N") {
		LoadTableList();
	}
}

//ԤԼ��ӡ�¼��뷽�� ������ԤԼ�Ĳ�ѯ����һ��
function PrintAPPMesag(AppID)
{
	DHCP_GetXMLConfig("XMLObject","DHCOPAppointPrint");
	
	$.cm({
		ClassName:"DHCDoc.Common.pa",
		MethodName:"GetAppPrintData",
		AppARowid:AppID,
		dataType:"json"
	},function(data){
		var PDlime=String.fromCharCode(2);
		var PrtObj=data[0];
		var MyPara="CardNo"+PDlime+PrtObj['CardNo']+"^"+"PatNo"+PDlime+PrtObj['PatNo']+"^"+"PatName"+PDlime+PrtObj['PatName']+"^"+"RegDep"+PDlime+PrtObj['RegDep'];
		var MyPara=MyPara+"^"+"SessionType"+PDlime+PrtObj['SessionType']+"^"+"MarkDesc"+PDlime+PrtObj['MarkDesc']+"^"+"Total"+PDlime+PrtObj['Total'];
		var MyPara=MyPara+"^"+"AdmDate"+PDlime+PrtObj['AdmDate']+"^"+"APPDate"+PDlime+PrtObj['APPDate']+"^"+"SeqNo"+PDlime+PrtObj['SeqNo'];
		var MyPara=MyPara+"^"+"UserCode"+PDlime+PrtObj['UserCode'];
		var MyPara=MyPara+"^"+"MethType"+PDlime+"["+PrtObj['APPTMethod']+"]"
		var MyPara=MyPara+"^"+"AdmTimeRange"+PDlime+PrtObj['AdmTimeRange'] //�������ʱ��
		var myobj=document.getElementById("ClsBillPrint");
		//DHCP_PrintFun(myobj,MyPara,"");
		DHC_PrintByLodop(getLodop(),MyPara,"","","");
	});
}

function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		/*
		if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			CardNoKeydownHandler(e);
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("PatNo")>=0){
			PatNoKeydownHandler(e);
			return false;
		}
		*/
		return false;
	}
	if (keyCode==115){
		//�������
		ReadCardClickHandler()
		return false;
	}
	if (keyCode==120){
		if (PageLogicObj.AppAddFlag=="APP"){return true;}
		//�Ӻſ��
		AddClick("DOCADD")
		return true;
	}
	if (keyCode==121){
		if (PageLogicObj.AppAddFlag=="ADD"){return true;}
		//ԤԼ���
		AppointClick("APP")
		return true;
	}
	return true;
}

function LoadPage(RBASRowID,PatientID,AppMethCodeStr,CanNoCardApp){
	ServerObj.RBASRowID=RBASRowID;
	if (PatientID!=""){
		ClearPatInfo();
		ServerObj.PatientID=PatientID
	}
	PageLogicObj.SelectSeqNum="",PageLogicObj.SelectTimeRange="";
	ServerObj.AppMethCodeStr=AppMethCodeStr
	ServerObj.CanNoCardApp=CanNoCardApp
	//�������������Ƿ�����޿�ԤԼ
	if (ServerObj.CanNoCardApp!="Y"){
		$("#CNoCardApp").hide()
	}
	$("#NoCardApp").checkbox('uncheck');
	if (RBASRowID) {
		var ASDate=$(".selectCls" , parent.document)[0].id;
		if (ASDate == ServerObj.nowDate) {
			$("#CNoCardApp").hide();
		}else{
			$("#CNoCardApp").show();
		}
	}else{
		$("#CNoCardApp").hide();
	}
	if (ServerObj.PatientID!=""){
		var PatNo=$.cm({
			ClassName:"web.DHCDocAppointmentHui",
			MethodName:"GetPatientNo",
			dataType:"text",
			PatientID:ServerObj.PatientID
		},false);
		ServerObj.PatNo=PatNo
	}
	//��ʼ��������Ϣ
	if (ServerObj.PatNo!=""){
		$("#PatNo").val(ServerObj.PatNo)
		PatNoSearch()
	}
	//������Դ
	if (ServerObj.RBASRowID!=""){
		LoadTableList()
	}else{
		PageLogicObj.RBApptScheduleList.datagrid('loadData',{"rows":[],"total":0,"curPage":1})
	}
	IntTimeRange("");
	if (window.parent.PageLogicObj.LockPatientID==""){
		$("#BLockPatient").find(".l-btn-text").text($g("��������"));
	}else{
		$("#BLockPatient").find(".l-btn-text").text($g("ȡ������"));	
	}
}
function BLockPatientClickHandler(){
	if (ServerObj.PatientID!=""){
		var text=$("#BLockPatient").find(".l-btn-text").text()
		if (text==$g("��������")){
			window.parent.PageLogicObj.LockPatientID=ServerObj.PatientID;
			$("#BLockPatient").find(".l-btn-text").text($g("ȡ������"));
		}else{
			window.parent.PageLogicObj.LockPatientID=""
			$("#BLockPatient").find(".l-btn-text").text($g("��������"));
		}
	}else{
		$.messager.alert("��ʾ","���ȡ���ߺ��ٽ�������");
		return ;
	}
}
function CheckTelOrMobile(telephone,Name,Type){
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.indexOf('-')>=0){
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
			websys_setfocus(Name);
	        return false;
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}
function BFindPatClick() {
	var src="doc.patlistquery.hui.csp";
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	var $width=$(window.parent).width()-100
	var $height=$(window.parent).height()-80
	window.parent.createModalDialog("FindPatInfo","���߲�ѯ", $width, $height,"icon-w-find","",$code,"");
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content
    });
}
function InitCommonCardWin(){
	$("#CommonCardChoose").empty();
	retArry=ServerObj.CommonCardNoStr.split("&");
	htmlstr='<table class="search-table" style="margin:10px auto;">';
	for (var i=0; i<retArry.length; i++){
		htmlstr=htmlstr+'<tr><td colSpan=""><a class="hisui-linkbutton l-btn l-btn-small" id="Commoncard'+retArry[i]+'" onclick="CommonCardclickRadio('+"'"+retArry[i]+"'"+')" data-options="" group=""><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">'+retArry[i]+'</span><span class="l-btn-icon icon-w-plus">&nbsp;</span></span></a></td></tr>'
	}
	htmlstr=htmlstr+'</table>';
	$("#CommonCardChoose").append(htmlstr);
}
function CommonCardclickRadio(ChoseCommonCardNo){
	$('#CommonCardWin').window('close');	
	var PatientNomyrtn=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetCommonCardNoandPatientNo",
		dataType:"text",
		ChoseCommonCardNo:ChoseCommonCardNo
	},false);
	if (PatientNomyrtn==""){
		$.messager.alert("��ʾ","��ά��������."); 
		$("#NoCardApp").checkbox('uncheck');      				
		return false;
	}else{
		var CardNo=PatientNomyrtn.split("^")[0]
		var PatientNo=PatientNomyrtn.split("^")[1];
		var CardTypeNew=PatientNomyrtn.split("^")[2];
		$("#CardNo").val(CardNo);
		$("#PatNo").val(PatientNo);
		$("#CardTypeNew").val(CardTypeNew);
		PatNoSearch()
	}
}

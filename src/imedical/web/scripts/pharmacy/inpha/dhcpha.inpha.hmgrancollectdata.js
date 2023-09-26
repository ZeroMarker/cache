/*
ģ��:		��ҩ��ҩ
��ģ��:		��ҩ��ҩ-���������ݲɼ�
Creator:	hulihua
CreateDate:	2018-01-18
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var grancollectid="";						//�ɼ���
DhcphaTempBarCode="";
$(function(){
	/*��ʼ����� start*/
	InitMedBatNo();				//��ҩ����
	InitGridGranPresc();	
	/*��ʼ����� end*/
	//����س��¼�
	$('#txt-barcode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			AddBarPrescNo();	 
		}     
	});
	
	//���Żس��¼�
	$('#txt-usercode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetUserInfo();
		}    		 
	});
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(event){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
	
	$("button").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
	
	/* �󶨰�ť�¼� start*/
	$("#a-help").popover({
		animation:true,
		placement:'bottom',
		trigger: 'hover',
		html:true,
		content:'<div style="width:300px;">*��ܰ��ʾ*</br>����ɨ������,��ɨ�蹤��Ŷ~</div>' 
	});
	/* �󶨰�ť�¼� end*/
	
	SetDefaultCode();
	$("#grid-medbroregpresc").setGridWidth("")
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

///Ĭ�ϵ�¼����Ϣ
function SetDefaultCode(){
	grancollectid=gUserID;
	$('#recorduser').text(gUserName);
}

///��ʼ����ҩ����
function InitMedBatNo(){
	var data = [
	 { id: 1, text: '��һ��' },
	 { id: 2, text: '�ڶ���' }
	 ];
	var selectoption={
	  data: data,
      width:'8em',
      allowClear:false,
      minimumResultsForSearch: Infinity
	};
	$("#sel-medbatno").dhcphaSelect(selectoption);			
}

//��ʼ������������table
function InitGridGranPresc(){
	var columns=[
		{header:'TPhac',index:'TPhac',name:'TPhac',width:30,hidden:true},
	    {header:'������',index:'TPrescNo',name:'TPrescNo',width:80},
	    {header:'��������',index:'TDoctorLoc',name:'TDoctorLoc',width:120,align:'left'},
		{header:'�ǼǺ�',index:'TPatNo',name:'TPatNo',width:60},
		{header:'��������',index:'TPatName',name:'TPatName',width:60},
		{header:'�Ա�',index:'TSex',name:'TSex',width:60},
		{header:'����',index:'TPatAge',name:'TPatAge',width:30},
		{header:'����',index:'TFactor',name:'TFactor',width:60},
		{header:'�÷�',index:'TInstruc',name:'TInstruc',width:60},
		{header:'��ҩ��ʽ',index:'TCookType',name:'TCookType',width:60}  
	]; 
	var jqOptions={
		datatype:'local',
	    colModel: columns, //��	
	    height: DispConfirmCanUseHeight(),
	    shrinkToFit:true,
	    rownumbers:true,
		ondblClickRow:function(){
			DelBarPrescNo();
		}
	};
	$("#grid-medbrogranpresc").dhcphaJqGrid(jqOptions);
}

//���ӽ�ҩ�б���Ϣ��
function AddBarPrescNo(){
	DhcphaTempBarCode="";
	var barcode=$.trim($("#txt-barcode").val());
	var dispgridrows=$("#grid-medbrogranpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-medbrogranpresc").jqGrid('getRowData',i);
		var tmpprescno=tmpselecteddata["TPrescNo"];
		if(tmpprescno==barcode){
			dhcphaMsgBox.alert("�ô�����ɨ��!");
			$("#txt-barcode").val("");
			return false;	
		}
	}
	var ResutStr=tkMakeServerCall("web.DHCINPHA.HMNurseReceive.NurseReceiveQuery","GetGranPresByBarCode",barcode, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	if((ResutStr<0)||(ResutStr=="")||(ResutStr==null)){
		if(ResutStr=="-1"){
			dhcphaMsgBox.alert("������Ϊ��!");	
		}else if(ResutStr=="-2"){
			dhcphaMsgBox.alert("�ô���������!");
		}else if(ResutStr=="-3"){
			dhcphaMsgBox.alert("�ô�����δ��ҩ��!");
		}else if(ResutStr=="-4"){
			dhcphaMsgBox.alert("�ô�����ҩ������!");
		}else if(ResutStr=="-5"){
			dhcphaMsgBox.alert("�ô������ǿ�����!");
		}else if(ResutStr=="-6"){
			dhcphaMsgBox.alert("�ô����Ѿ����ɼ�!");
		}else if(ResutStr=="-7"){
			dhcphaMsgBox.alert("�ô����Ǳ�Ժ������,���ʵ!");
		}else{
			dhcphaMsgBox.alert("������Ϣ����,���ʵ!");	
		}
		$("#txt-barcode").val("");
		return false;
	}
	var ResutStrArr=ResutStr.split(tmpSplit)
	var PrescNo=ResutStrArr[0];
	var PatNo=ResutStrArr[1];
	var PatName=ResutStrArr[2];
	var Sex=ResutStrArr[3];
	var PatAge=ResutStrArr[4];
	var Instruc=ResutStrArr[5];
	var Factor=ResutStrArr[6];
	var CookType=ResutStrArr[7];
	var DoctorLoc=ResutStrArr[8];
	var Phac=ResutStrArr[9];
	var datarow = {
		TPhac:Phac, 
		TPrescNo: PrescNo,
		TPatNo: PatNo,
		TPatName: PatName,
		TSex: Sex,
		TPatAge:PatAge,
		TFactor: Factor,
		TInstruc: Instruc,
		TCookType: CookType,
		TDoctorLoc:DoctorLoc
	};
	var id = $("#grid-medbrogranpresc").find("tr").length;
	var su = $("#grid-medbrogranpresc").jqGrid('addRowData',id, datarow);
	if (!su){
  		dhcphaMsgBox.alert("ɨ��ʧ�ܣ����ʵ��");
	}
	$("#txt-barcode").val("");
	DhcphaTempBarCode="";
	return false;
}

function DelBarPrescNo() {
	var id = $("#grid-medbrogranpresc").jqGrid('getGridParam', 'selrow');
	var su = $("#grid-medbrogranpresc").jqGrid('delRowData',id);
	if (!su){
		dhcphaMsgBox.alert("ɾ��ʧ�ܣ�������˫��ɾ����");
		return false;
	} 
}

//��֤�û���Ϣ��ִ��ȷ��
function ExecuteSure(){
	DhcphaTempBarCode="";
	if ((grancollectid=="")||(grancollectid==null)){
		dhcphaMsgBox.alert("���Ų���Ϊ��!");
		return false;
	}
	var medbatno=$('#sel-medbatno').val();
	if((medbatno=="")||(medbatno==null)){
		dhcphaMsgBox.alert("����ѡ���������ҩ���Σ�");
		return false;
	}
	var grid_records = $("#grid-medbrogranpresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("��ǰ�����޿�������������,����ɨ����������룡");
		$("#txt-barcode").val("");
		return false;
	}
	
	var firstrowdata = $("#grid-medbrogranpresc").jqGrid("getRowData", 1); //��ȡ��һ������
	var prescno=firstrowdata.TPrescNo;			
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("����ϵ����ʦ��֤�����Ƿ��������!");
		return false;
	}
	var dispgridrows=$("#grid-medbrogranpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-medbrogranpresc").jqGrid('getRowData',i);
		var tmpphac=tmpselecteddata["TPhac"];
		var tmpprescno=tmpselecteddata["TPrescNo"];
		var SqlStr=tmpphac+tmpSplit+grancollectid+tmpSplit+medbatno;
		var retValue=tkMakeServerCall("web.DHCINPHA.HMNurseReceive.NurseReceiveQuery","SaveGranCollectData",SqlStr);
		if(retValue!=0){
			var Msg=retValue.split("^")[1];
			dhcphaMsgBox.alert("��ȡ&nbsp&nbsp<b><font color=#CC1B04 size=5 >"+tmpprescno+"</font></b>&nbsp&nbspʧ��!<br/>"+Msg);
			continue;
		}
	}
	ClearConditons();
	return false;	 	       	 
}

///��¼��ȡ�˵���Ϣ
function SetUserInfo(){
	var usercode=$.trim($("#txt-usercode").val());
	if(usercode==""){
		usercode=gUserCode;
	}
	if (usercode==""){
		dhcphaMsgBox.alert("��������!");
		return false;
	}
	var defaultinfo=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserDefaultInfo",usercode);
	var ss=defaultinfo.split("^");
	grancollectid=ss[0];
	$('#recorduser').text(ss[2]);
	$("#txt-usercode").val("")
	return false;		
}

function ClearConditons(){
	DhcphaTempBarCode="";
	$("#txt-barcode").val("");  
	$("#txt-usercode").val(""); 
	$("#grid-medbrogranpresc").jqGrid("clearGridData");	
	$("#sel-medbatno").val("");
	InitMedBatNo();				//��ҩ����
	SetDefaultCode();
}
//��ҳ��table���ø߶�
function DispConfirmCanUseHeight(){
	var height1=parseFloat($("[class='container-fluid dhcpha-containter']").height());
	var height2=parseFloat($("[class='panel-heading']").outerHeight());
	var height3=parseFloat($(".div_content").css("margin-top"));
	var height4=parseFloat($(".div_content").css("margin-bottom"));
	var height5=parseFloat($(".dhcpha-row-split").outerHeight());
	var tableheight=$(window).height()-height1-height4-height2-height3-height5-DhcphaGridTrHeight+40;
	return tableheight;
}

function CheckTxtFocus(){
	var txtfocus1=$("#txt-barcode").is(":focus");
	var txtfocus2=$("#txt-usercode").is(":focus")
	if ((txtfocus1!=true)&&(txtfocus2!=true)){
		return false;
	}
	return true;	
}

//����keydown,���ڶ�λɨ��ǹɨ����ֵ
function OnKeyDownHandler(){
	
	if (CheckTxtFocus()!=true){
		if (event.keyCode==13){
			if (DhcphaTempBarCode.length>6){
				$("#txt-barcode").val(DhcphaTempBarCode);
				AddBarPrescNo();
			}else{
				$("#txt-usercode").val(DhcphaTempBarCode);
				if ($("#grid-medbrogranpresc").getGridParam('records')>0){
					ExecuteSure();
				}
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode)
		}
	}
}
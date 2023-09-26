/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-��ʿҩ����ȡ�Ǽ�
Creator:	hulihua
CreateDate:	2018-01-17
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var registerid="";						//�Ǽ���
DhcphaTempBarCode="";
$(function(){
	/*��ʼ����� start*/
	InitGridDispConfirm();	
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
	$("#grid-recordregpresc").setGridWidth("")
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

///Ĭ�ϵ�¼��Ϊ�Ǽ���
function SetDefaultCode(){
	registerid=gUserID;
	$('#recorduser').text(gUserName);
}

//��ʼ����ϸtable
function InitGridDispConfirm(){
	var columns=[
		{header:'TPhac',index:'TPhac',name:'TPhac',width:20,hidden:true},
	    {header:'������',index:'TPrescNo',name:'TPrescNo',width:80},
	    {header:'��������',index:'TDoctorLoc',name:'TDoctorLoc',width:100,align:'left'},
		{header:'�ǼǺ�',index:'TPatNo',name:'TPatNo',width:60},
		{header:'��������',index:'TPatName',name:'TPatName',width:60},
		{header:'�Ա�',index:'TSex',name:'TSex',width:60},
		{header:'����',index:'TPatAge',name:'TPatAge',width:30},
		{header:'����',index:'TFactor',name:'TFactor',width:60},
		{header:'�÷�',index:'TInstruc',name:'TInstruc',width:60},
		{header:'��ҩ��ʽ',index:'TCookType',name:'TCookType',width:60},
		{header:'�Ǽ�״̬',index:'TStatue',name:'TStatue',width:50,hidden:true},
		{header:'��ҩ��',index:'TCollectUserName',name:'TCollectUserName',width:60},
		{header:'��ҩʱ��',index:'TCollectDate',name:'TCollectDate',width:120}  
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
	$("#grid-recordregpresc").dhcphaJqGrid(jqOptions);
}

//���Ӵ����б���Ϣ��
function AddBarPrescNo(){
	var barcode=$.trim($("#txt-barcode").val());
	var dispgridrows=$("#grid-recordregpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-recordregpresc").jqGrid('getRowData',i);
		var tmpprescno=tmpselecteddata["TPrescNo"];
		if(tmpprescno==barcode){
			dhcphaMsgBox.alert("�ô�����ɨ��!");
			$("#txt-barcode").val("");
			return false;	
		}
	}
	var ResutStr=tkMakeServerCall("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","GetPhaPrescByBarCode",barcode,DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
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
			dhcphaMsgBox.alert("�ô����ѵǼ�!");
		}else if(ResutStr=="-6"){
			dhcphaMsgBox.alert("�ô�������ҩ!");
		}else if(ResutStr=="-11"){
			dhcphaMsgBox.alert("�ô����ǵ�ǰԺ������,���ʵ!");
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
	var Statue=ResutStrArr[9];
	var CollectUserName=ResutStrArr[10];
	var CollectDate=ResutStrArr[11];
	var Phac=ResutStrArr[12];
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
		  TDoctorLoc:DoctorLoc,
		  TStatue:Statue,
		  TCollectUserName:CollectUserName,
		  TCollectDate:CollectDate
	};
	//console.log(datarow)
	var id = $("#grid-recordregpresc").find("tr").length;
	var su = $("#grid-recordregpresc").jqGrid('addRowData',id, datarow);
	if (!su){
  		dhcphaMsgBox.alert("ɨ��ʧ�ܣ����ʵ��");
	}
	$("#txt-barcode").val("");
	DhcphaTempBarCode="";
	return false;
}

function DelBarPrescNo() {
	var id = $("#grid-recordregpresc").jqGrid('getGridParam', 'selrow');
	var su = $("#grid-recordregpresc").jqGrid('delRowData',id);
	if (!su){
		dhcphaMsgBox.alert("ɾ��ʧ�ܣ�������˫��ɾ����");
	}
	return false; 
}

//��֤�û���Ϣ��ִ��ȷ��
function ExecuteSure(){
	DhcphaTempBarCode="";
	if ((registerid=="")||(registerid==null)){
		dhcphaMsgBox.alert("�Ǽ��˲���Ϊ��!");
		return false;
	}
	var grid_records = $("#grid-recordregpresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("��ǰ�����޴�������,����ɨ�账�����룡");
		$("#txt-barcode").val("");
		return false;
	}

	var firstrowdata = $("#grid-recordregpresc").jqGrid("getRowData", 1); //��ȡ��һ������
	var prescno=firstrowdata.TPrescNo;			
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("����ϵ��Ϣ������֤�����Ƿ��������!");
		return false;
	}
	var dispgridrows=$("#grid-recordregpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-recordregpresc").jqGrid('getRowData',i);
		var tmpphac=tmpselecteddata["TPhac"];
		var tmpprescno=tmpselecteddata["TPrescNo"];
		var SqlStr=tmpphac+tmpSplit+registerid+tmpSplit+tmpprescno;
		var retValue=tkMakeServerCall("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","SavePreReg",SqlStr);
		if(retValue!=0){
			var Msg=retValue.split("^")[1];
			dhcphaMsgBox.alert("��¼&nbsp&nbsp<b><font color=#CC1B04 size=5 >"+tmpprescno+"</font></b>&nbsp&nbspʧ��!<br/>"+Msg);
			continue;
		}
	}
	ClearConditons();
	return false;	 	       	 
}

///��¼�Ǽ��˵���Ϣ
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
	if (defaultinfo==""){
		$('#recorduser').text("");
		$("#txt-usercode").val("")
		registerid = ""
		dhcphaMsgBox.alert("�˹��Ų����ڣ����ʵ������!");
	}
	else {
		var ss=defaultinfo.split("^");
		registerid=ss[0];
		$('#recorduser').text(ss[2]);
		$("#txt-usercode").val("")
	}
	
	return false;		
}

function ClearConditons(){
	DhcphaTempBarCode="";
	$("#txt-barcode").val("");  
	$("#txt-usercode").val("");
	SetDefaultCode(); 
	$("#grid-recordregpresc").jqGrid("clearGridData");	
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
				if ($("#grid-recordregpresc").getGridParam('records')>0){
					ExecuteSure();
				}
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode)
		}
	}
}
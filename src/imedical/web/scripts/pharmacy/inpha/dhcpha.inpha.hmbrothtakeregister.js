/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-��ʿ��ҩ��ȡ�Ǽ�
Creator:	hulihua
CreateDate:	2018-01-17
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var brotakeregid="";						//��ҩ��ȡ�Ǽ���
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
	$("#grid-medbroregpresc").setGridWidth("")
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

///Ĭ�ϵ�¼����Ϣ
function SetDefaultCode(){
	brotakeregid=gUserID;
	$('#recorduser').text(gUserName);
}


//��ʼ����ϸtable
function InitGridDispConfirm(){
	var columns=[
		{header:'TPhmbiId',index:'TPhmbiId',name:'TPhmbiId',width:20,hidden:true},
	    {header:'������',index:'TPrescNo',name:'TPrescNo',width:80},
	    {header:'����',index:'TWardLoc',name:'TWardLoc',width:120,align:'left'},
	    {header:'��������',index:'TDoctorLoc',name:'TDoctorLoc',width:100,align:'left'},
		{header:'�ǼǺ�',index:'TPatNo',name:'TPatNo',width:60},
		{header:'��������',index:'TPatName',name:'TPatName',width:60},
		{header:'�Ա�',index:'TSex',name:'TSex',width:60},
		{header:'����',index:'TPatAge',name:'TPatAge',width:30},
		{header:'����',index:'TFactor',name:'TFactor',width:60},
		{header:'Ӧ��ҩ����',index:'TBrothDate',name:'TBrothDate',width:80},
		{header:'Ӧ�Ҵ���',index:'TUncovMedPocNum',name:'TUncovMedPocNum',width:60},
		{header:'�����',index:'TBarCode',name:'TBarCode',width:120}  
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
	$("#grid-medbroregpresc").dhcphaJqGrid(jqOptions);
}

//���ӽ�ҩ�б���Ϣ��
function AddBarPrescNo(){
	DhcphaTempBarCode="";
	var barcode=$.trim($("#txt-barcode").val());
	var dispgridrows=$("#grid-medbroregpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-medbroregpresc").jqGrid('getRowData',i);
		var tmpprescno=tmpselecteddata["TPrescNo"];
		if(tmpprescno==barcode){
			dhcphaMsgBox.alert("�ô�����ɨ��!");
			$("#txt-barcode").val("");
			return false;	
		}
	}
	var ResutStr=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","GetMedBroPresByBarCode",barcode);
	var RetCode=ResutStr.split("^")[0];
	var RetMessage=ResutStr.split("^")[1];
	if((RetCode<0)||(RetCode=="")||(RetCode==null)){
		dhcphaMsgBox.alert(RetMessage);	
		$("#txt-barcode").val("");
		return false;
	}
	var ResutListStrArr=ResutStr.split("&&");
	for (i=0;i<ResutListStrArr.length;i++){
		var ResutStr=ResutListStrArr[i];
		var ResutStrArr=ResutStr.split(tmpSplit)
		var PrescNo=ResutStrArr[0];
		var PatNo=ResutStrArr[1];
		var PatName=ResutStrArr[2];
		var Sex=ResutStrArr[3];
		var PatAge=ResutStrArr[4];
		var Factor=ResutStrArr[5];
		var DoctorLoc=ResutStrArr[6];
		var WardLoc=ResutStrArr[7];
		var BrothDate=ResutStrArr[8];
		var BarCode=ResutStrArr[9];
		var UncovMedPocNum=ResutStrArr[10];
		var PhmbiId=ResutStrArr[11];
		var datarow = {
			  TPhmbiId:PhmbiId,
			  TPrescNo: PrescNo,
			  TPatNo: PatNo,
			  TPatName: PatName,
			  TSex: Sex,
			  TPatAge:PatAge,
			  TFactor:Factor,
			  TDoctorLoc:DoctorLoc,
			  TWardLoc:WardLoc,
			  TBrothDate: BrothDate,
			  TBarCode:BarCode,
			  TUncovMedPocNum:UncovMedPocNum
		};
		//console.log(datarow)
		var id = $("#grid-medbroregpresc").find("tr").length;
		var su = $("#grid-medbroregpresc").jqGrid('addRowData',id, datarow);
		if (!su){
	  		dhcphaMsgBox.alert("ɨ��ʧ�ܣ����ʵ��");
		}

	}

	$("#txt-barcode").val("");
	DhcphaTempBarCode="";
	return false;
}

function DelBarPrescNo() {
	var id = $("#grid-medbroregpresc").jqGrid('getGridParam', 'selrow');
	var su = $("#grid-medbroregpresc").jqGrid('delRowData',id);
	if (!su){
		dhcphaMsgBox.alert("ɾ��ʧ�ܣ�������˫��ɾ����");
	}
	return false; 
}

//��֤�û���Ϣ��ִ��ȷ��
function ExecuteSure(){
	DhcphaTempBarCode="";
	if ((brotakeregid=="")||(brotakeregid==null)){
		dhcphaMsgBox.alert("��ҩ��ȡ�˲���Ϊ��!");
		return false;
	}
	var grid_records = $("#grid-medbroregpresc").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("��ǰ�����޽�ҩ����,����ɨ���ҩ���룡");
		$("#txt-barcode").val("");
		return;
	}

	var firstrowdata = $("#grid-medbroregpresc").jqGrid("getRowData", 1); //��ȡ��һ������
	var prescno=firstrowdata.TPrescNo;			
	if ((prescno=="")||(prescno==undefined)){
		dhcphaMsgBox.alert("����ϵ��Ϣ������֤�����Ƿ��������!");
		return false;
	}
	var dispgridrows=$("#grid-medbroregpresc").getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-medbroregpresc").jqGrid('getRowData',i);
		var tmpphmbiid=tmpselecteddata["TPhmbiId"];
		var tmpbarcode=tmpselecteddata["TBarCode"];
		var SqlStr=tmpphmbiid+tmpSplit+brotakeregid;
		var retValue=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","SaveNuresTakeData",SqlStr);
		if(retValue!=0){
			var Msg=retValue.split("^")[1];
			dhcphaMsgBox.alert("��ȡ&nbsp&nbsp<b><font color=#CC1B04 size=5 >"+tmpbarcode+"</font></b>&nbsp&nbspʧ��!<br/>"+Msg);
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
	brotakeregid=ss[0];
	$('#recorduser').text(ss[2]);
	$("#txt-usercode").val("")
	return false;		
}

function ClearConditons(){
	DhcphaTempBarCode="";
	$("#txt-barcode").val("");  
	$("#txt-usercode").val(""); 
	$("#grid-medbroregpresc").jqGrid("clearGridData");	
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
				if ($("#grid-medbroregpresc").getGridParam('records')>0){
					ExecuteSure();
				}
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode)
		}
	}
}
/*
ģ��:		�ƶ�ҩ��
��ģ��:		�ƶ�ҩ��-������ʿǩ��
Creator:	hulihua
CreateDate:	2016-10-24
*/
DhcphaTempBarCode="";
$(function(){
	/*��ʼ����� start*/
	InitGridPhBoxReceive();	
	/*��ʼ����� end*/
	//������Żس��¼�
	$('#txt-phboxno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			QueryPhBoxInfo();	 
		}     
	});
	
	//���Żس��¼�
	$('#txt-usercode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			if($('#txt-usercode').val().trim()==""){
				return;	
			}
			ExecuteSure();
		}    		 
	});
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
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
		content:'<div style="width:300px;">*��ܰ��ʾ*</br>����ɨ���������,��ɨ�蹤��Ŷ~</div>' //
	});
	/* �󶨰�ť�¼� end*/
	
	//��ѯ��¼�û������ǩ������
	QueryDayRecBoxCount();
	document.onkeydown=OnKeyDownHandler;
})

//��ʼ����������Ϣtable
function InitGridPhBoxReceive(){
	var columns=[
		{header:'TPhbID',index:'TPhbID',name:'TPhbID',width:30,hidden:true},
	    {header:'���',index:'TPhbNo',name:'TPhbNo',width:60},
		{header:'����',index:'TPhbNum',name:'TPhbNum',width:30},
		{header:'ҩ��������',index:'TUserPhHand',name:'TUserPhHand',width:60},
		{header:'ҩ����������',index:'TDatePhHand',name:'TDatePhHand',width:60},
		{header:'ҩ������ʱ��',index:'TTimePhHand',name:'TTimePhHand',width:60},
		{header:'������Ա',index:'TUserLogistics',name:'TUserLogistics',width:60},
		{header:'�����˶���',index:'TUserWardChk',name:'TUserWardChk',width:60},
		{header:'�����˶�����',index:'TDateWardChk',name:'TDateWardChk',width:60},
		{header:'�����˶�ʱ��',index:'TTimeWardChk',name:'TTimeWardChk',width:60}
	    
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseReceive.NurseReceiveQuery&MethodName=GetInPhBoxInfo',	
	    height: DispConfirmCanUseHeight(),
	    shrinkToFit:true
	};
	$("#grid-phboxinfo").dhcphaJqGrid(jqOptions);
}
//��ѯ��������Ϣ
function QueryPhBoxInfo(){
	DhcphaTempBarCode="";
	var boxno=$.trim($("#txt-phboxno").val());
	if (boxno!=''){
		var retValue=tkMakeServerCall("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","CheckBoxNoStatue",boxno,gLocId);
		var retCode=retValue.split("^")[0];
		var retMessage=retValue.split("^")[1];
		if(retCode<0){
			dhcphaMsgBox.alert(retMessage);
		}else{
			var params=boxno;
			$("#grid-phboxinfo").setGridParam({
				postData:{
					'params':params
				}
			}).trigger("reloadGrid"); 
			$("#txt-usercode").focus();         
		}			
	}
	else{
		dhcphaMsgBox.alert("�������Ϊ��,���ʵ!"); 
	}
	$("#txt-phboxno").val("");
}
//��֤�û���Ϣ��ִ��ȷ��
function ExecuteSure(){
	DhcphaTempBarCode="";
	var usercode=$.trim($("#txt-usercode").val());
	var grid_records = $("#grid-phboxinfo").getGridParam('records');
	if (grid_records==0){
		dhcphaMsgBox.alert("��ǰ��������������Ϣ����,����ɨ��������ţ�");
		$("#txt-usercode").val("");
		$("#txt-phboxno").val("");
		return;
	}
	if (usercode==""){
		dhcphaMsgBox.alert("ǩ�չ��ƺŲ���Ϊ��!");
		$("#txt-usercode").val("");
		$("#txt-phboxno").val("");
		return;
	}
	var retValue= tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserIdByLogCode",usercode);
	if(retValue==0){
		dhcphaMsgBox.alert("������Ĺ��ƺ���HIS��û��ά��,���ʵ!");
		$("#txt-usercode").val("");
		return;
	}
	else{
		var firstrowdata = $("#grid-phboxinfo").jqGrid("getRowData", 1); //��ȡ��һ������
		var phbrow=firstrowdata.TPhbID;			
		if ((phbrow=="")||(phbrow==undefined)){
			dhcphaMsgBox.alert("����ϵ����ʦ��֤�����Ƿ��������!");
			return;
		}
		var userdr=retValue;
		var params=phbrow+"^"+userdr;
		var retval=tkMakeServerCall("web.DHCINPHA.MTNurseReceive.SqlDbNurseReceive","UpdatePHBoxInfo",params); 
		$("#grid-phboxinfo").setGridParam({
			postData:{
				'params':phbrow
			}
		}).trigger("reloadGrid");
		var  tmpnum=parseFloat($("#lbl-recboxcount").text())+1;
        $("#lbl-recboxcount").text(tmpnum)
		$("#txt-phboxno").val("");  
        $("#txt-usercode").val(""); 
	}        	 
}

function QueryDayRecBoxCount(){
	var usercode=$.trim($("#txt-usercode").val());
	var retval=tkMakeServerCall("web.DHCINPHA.MTNurseReceive.NurseReceiveQuery","GetUserRcBoxCount",gUserID,usercode,gLocId); 
	$("#lbl-recboxcount").text(retval);
	$("#txt-phboxno").focus();
}

function ClearConditons(){
	$("#txt-phboxno").val("");  
	$("#txt-usercode").val("");  
	$("#grid-phboxinfo").jqGrid("clearGridData");
	DhcphaTempBarCode="";	
}

//��ҳ��table���ø߶�
function DispConfirmCanUseHeight(){
	var height1=parseFloat($("[class='container-fluid dhcpha-containter']").height());
	var height2=parseFloat($("[class='panel-heading']").outerHeight());
	var height3=parseFloat($("#firstrow").outerHeight());
	var height4=parseFloat($(".div_content").css("margin-top"));
	var height5=parseFloat($(".div_content").css("margin-bottom"));
	var height6=parseFloat($(".dhcpha-row-split").outerHeight());
	var tableheight=height1-height5-height3-height2-height4-height6-DhcphaGridTrHeight
	return tableheight;
}

function CheckTxtFocus(){
	var txtfocus1=$("#txt-phboxno").is(":focus");
	var txtfocus2=$("#txt-usercode").is(":focus")
	if ((txtfocus1!=true)&(txtfocus2!=true)){
		return false;
	}
	return true;	
}

//����keydown,���ڶ�λɨ��ǹɨ����ֵ
function OnKeyDownHandler(){
	if (CheckTxtFocus()!=true){
		if (event.keyCode==13){
			if (DhcphaTempBarCode.length>10){
				$("#txt-phboxno").val(DhcphaTempBarCode);
				QueryPhBoxInfo();
			}else{
				if(DhcphaTempBarCode==""){
					return;	
				}
				$("#txt-usercode").val(DhcphaTempBarCode);
				if ($("#grid-phboxinfo").getGridParam('records')>0){
					ExecuteSure();
				}
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode)
		}
	}
}

//����	DHCPEAdvancePayment.Find.hisui.js
//����	��쿨����	
//����	2019.07.01
//������  xy
$(function(){
		
	InitCombobox();
	
	//Ĭ��ʱ��
	Initdate();
	
	InitAdvancePaymentGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    
    //����
    $("#BClear").click(function() {	
		BClear_click();		
        });
      
    
     //����
	$("#BReadCard").click(function() {	
		ReadCardClickHandle();		
        });
    
    $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });
   
     
    $("#CardNo").keydown(function(e) {
			if(e.keyCode==13){
				CardNo_Change();
			}
			
        });
         
    $("#TJCardType").combobox({
		onSelect:function(){
		CardType_change();	
		}
	});
	
	$("#ATJCardType").combobox({
			onSelect:function(){
			ATJCardType_change();	
		}
	    }); 
	    
    //����
	 $("#BNew").click(function() {		
			BNew_click();	
        });
        
      	
     $("#ARegNo").keydown(function(e) {
			if(e.keyCode==13){
				ARegNo_change();
			}
			
        });
        
    $("#ARegNo").change(function(){
        ARegNo_change();
	}); 
	 
   $("#ACardNo").keydown(function(e) {
			if(e.keyCode==13){
				ACardNo_Change();
			}
			
        });

	  $("#PayMode").combobox({
			onSelect:function(){
			PayMode_change(); 
		}
	    }); 
        
        
   //Ĭ����쿨����Ϊ"Ԥ�ɽ�"
	$("#TJCardType").combobox('setValue',"R");
   
   
})
/****************************************************�����������**********************************/
function PayMode_change()
{
	var PayModeNew=$("#PayMode").combobox('getValue');
	if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayModeNew="";}
	 var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayModeNew);
	if((PayModeDesc!="")&&(PayModeDesc.indexOf("֧Ʊ")>=0)){
		$("#No").attr('disabled',false);
	}else{
		
		$("#No").attr('disabled',true);
		$("#No").val("");
	}
	
}

//����
function BNew_click()
{
	
	$("#myWin").show();

		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-card',
			resizable:true,
			title:'��쿨����',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				iconCls:'icon-w-add',
				text:'�½�',
				id:'BSave',
				handler:function(){
					BSave_click()
				}
			},{
				iconCls:'icon-w-update',
				text:'�޸�״̬',
				id:'BChangeStatus',
				handler:function(){
					BChangeStatus()
				}
			},{
				iconCls:'icon-w-card',
				text:'����',
				id:'BReadCard_btn',
				handler:function(){
					BReadCard()
				}
			},{
				iconCls:'icon-w-clean',
				text:'����',
				id:'BClear_btn',
				handler:function(){
					BClear()
				}
			},{
				iconCls:'icon-w-close',
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
			}]
		});
		
		$('#form-save').form("clear");
		$("#ATJCardType").combobox('setValue',"R");
		$("#AStatus").combobox('setValue',"N");
		FillData(1);
		SetInvNo();
		AElementEnble();
		$("#PayMode").combobox('setValue',"1");
		$("#No").attr('disabled',true);
		
}



//�޸�״̬
function BChangeStatus(){
	
	var RowID=$("#RowID").val();
	if (RowID=="")
	{
		$.messager.alert("��ʾ","û��Ҫ�޸ĵļ�¼","info");
		return false;
	}
	var Status=$("#AStatus").combobox('getValue');
	var Remark=$("#MRemark").val();
	var Strings=RowID+"^"+Status+"^"+Remark;
	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","UpdateData","3",Strings)
	var RetArr=ret.split("^");
	if (RetArr[0]!=0)
	{
		$.messager.alert("��ʾ",RetArr[0],"info");
		return false;
	}
	$.messager.alert("��ʾ","�������","success");
	
	
	AElementEnble();
}


//����
function BClear(){
	$("#ARegNo,#AName,#ACardTypeNew,#ACardNo,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#RowID,#PADM").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#AStatus").combobox('setValue',"N");
     $("#PayMode").combobox('setValue',"1");
	
	var RowID=$("#RowID").val()
	if (RowID=="")
	{
		
		SetCElement("BSave","�½�");
		
	}
}


function ACardNo_Change()
{
	var myCardNo=$("#ACardNo").val();
	if (myCardNo=="") {
		$.messager.alert("��ʾ","����Ϊ��","info");
		return;
	}
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","",CardTypeCallBack);
		return false;
	
}

//����
function BReadCard(){
	DHCACC_GetAccInfo7(CardTypeCallBack);
}

function CardTypeCallBack(myrtn){
	//alert(myrtn)
	
	var CardNo=$("#ACardNo").val();
	var CardTypeNew=$("#ACardTypeNew").val();
	$("#ARegNo,#AName,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#PADM").val("");
	 $(".hisui-checkbox").checkbox('setValue',false);
	$("#AStatus").combobox('setValue',"N");
     $("#PayMode").combobox('setValue',"1");
	//$(".textbox").val('');
	$("#ACardTypeNew").val(CardTypeNew);
	
   var myary=myrtn.split("^");
   var rtn=myary[0];
   if ((rtn=="0")||(rtn=="-201")){
		var PatientID=myary[4];
		var PatientNo=myary[5];
		var CardNo=myary[1];
		$("#CardTypeRowID").val(myary[8]);
		$("#ACardNo").focus().val(CardNo);
		$("#ARegNo").val(PatientNo);
		ARegNo_change();
	}else if(rtn=="-200"){
		/*$.messager.alert("��ʾ","����Ч!","info",function(){
			$("#ACardNo").val(CardNo).focus();
		});
		*/
		$.messager.popover({msg: "����Ч!", type: "info"});
		$("#CardNo").focus().val(CardNo);

		return false;
	}
}

function ARegNo_change()
{
	var Type=$("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue')==undefined)||($("#ATJCardType").combobox('getValue')=="")){var Type="";}
	if(Type==""){
		$.messager.alert("��ʾ","��ѡ����쿨����","info");
		$.messager.alert("��ʾ","��ѡ����쿨����","info");
		return false;
	}
	$("#RowID").val("");
	var RowID=$("#RowID").val();
	if (RowID=="")
	{
		
		SetCElement("BSave","�½�");
		
		
	}
	
	FillPatientData();
	AElementEnble();
	
}

function FillPatientData()
{
	var HospID=session['LOGON.HOSPID']
	
	var Type=$("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue')==undefined)||($("#ATJCardType").combobox('getValue')=="")){var Type="";}
	
	var RegNo=$("#ARegNo").val();
	if (RegNo=="") return;
	
	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetPatientInfo",RegNo,Type,HospID)
	if (Type!="C")
	{
		if (Data=="")
		{    $("#AName,#ACardTypeNew,#ACardNo,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#PADM").val("");
	         $(".hisui-checkbox").checkbox('setValue',false);
	         $("#AStatus").combobox('setValue',"N");
     			$("#PayMode").combobox('setValue',"1");
			 $.messager.popover({msg: "��Ч�ĵǼǺ�", type: "info"});
			
			return false;
		}
		var DataArr=Data.split("^");
		$("#ARegNo").val(DataArr[0]);
		$("#AName").val(DataArr[1]);
		$("#Age").val(DataArr[2]);
		$("#Sex").val(DataArr[3]);
		$("#ACardNo").val(DataArr[4]);
		//���ݵǼǺŴ��������� 
		var CardTypeNewStr=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",$("#ARegNo").val());
		if(CardTypeNewStr!=""){
			
			var CardTypeNew=CardTypeNewStr.split("^")[1];
		    $("#ACardTypeNew").val(CardTypeNew);
		}

		if (DataArr[5]==""){
			$("#Amount,#Remark").val("");	
		}
		if (DataArr[5]!="")
		{
			$("#RowID").val(DataArr[5]);
			FillData(0);
		}
	}
	else
	{
		if (Data=="")
		{    
			 $("#AName,#ACardTypeNew,#ACardNo,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#PADM").val("");
	         $(".hisui-checkbox").checkbox('setValue',false);
	         $("#AStatus").combobox('setValue',"N");
     		 $("#PayMode").combobox('setValue',"1");
			return false;
		}
		var DataArr=Data.split("^");
		
		$("#ARegNo").val(DataArr[0]);
		$("#AName").val(DataArr[1]);
		$("#Age").val(DataArr[2]);
		$("#Sex").val(DataArr[3]);
		$("#ACardNo").val(DataArr[4]);
		$("#AStatus").combobox('setValue',DataArr[6]);

		if (DataArr[5]!="")
		{
			$("#RowID").val(DataArr[5]);
			FillData(0);
		}
	}
	var Fee=$("#Fee").val();
	if (Fee=="")
	{
		//websys_setfocus("Fee");
	}
	else
	{
		//websys_setfocus("BSave");
	}
	return true;
}

function FillData(Flag)
{
	var RowID=$("#RowID").val();
	//alert(RowID)
	if (RowID=="")
	{
		
		SetCElement("BSave","�½�");
		return false;
	}
	else
	{
		
			
		var Type=$("#ATJCardType").combobox('getValue');
		if (($("#ATJCardType").combobox('getValue')==undefined)||($("#ATJCardType").combobox('getValue')=="")){var Type="";}
		if ((Type!="R")&&(Type!="C"))
		{
			$("#BSave").linkbutton('disable');
		
		}
		else
		{	
			$("#BSave").linkbutton('enable');
			SetCElement("BSave","��ֵ");
			
		}
	}
	
	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetData",RowID)
	var DataArr=Data.split("^");

	if(Type=="C"){$("#ARegNo").val(DataArr[1]);}
	if(Type!="C"){$("#ARegNo").val(DataArr[0]);}
	
	$("#ATJCardType").combobox('setValue',DataArr[2]);
	
	$("#Amount").val(changeTwoDecima(DataArr[3]));
	$("#AStatus").combobox('setValue',DataArr[4]);
	$("#Remark").val(DataArr[8]);

	//SetOneData("PassWord",DataArr[9]);
	if (Flag==1)
	{
		FillPatientData()
	}
	
}

//����С�������λ
function changeTwoDecima(num)
{

    var num=Math.floor(num * 100) / 100;
    
    var num=num.toString();
    
    if(num.indexOf('.')>0){
		if(num.split(".")[1].length<2){num=num+"0"};
    }else{
	    num=num+".00"
    }
    return num
}
function BSave_click()
{
	var Type=$("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue')==undefined)||($("#ATJCardType").combobox('getValue')=="")){var Type="";}
	if(Type==""){
		$.messager.alert("��ʾ","��ѡ����쿨����","info");
		return false
	
	}
	
	var RegNo=$.trim($("#ARegNo").val());
	if ((RegNo=="")&&(Type=="R")) {
		$.messager.alert("��ʾ","������ǼǺ�","info");
		return;
	}
	if ((RegNo=="")&&(Type=="C")) {
		$.messager.alert("��ʾ","��������𿨺�","info");
		return;
	}
	if((Type=="C")&&(document.getElementById('BSave').innerHTML.indexOf("�½�")>-1)){
		var flag=tkMakeServerCall("web.DHCPE.AdvancePayment","IsExsistCardByCardNo",RegNo);
		if(flag=="1"){
			$.messager.alert("��ʾ","�ÿ����ѱ�ʹ�ã���������õĿ���","info"); 
			 $("#ARegNo").val("");
		    return false;
		}
	}

	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetPatientInfo",RegNo,Type)
	if (Type!="C")
	{
		if (Data=="")
		{
			$.messager.alert("��ʾ","��Ч�ĵǼǺ�","info");
			return false;
		}
	}

	var NoPrint="";
	var NoPrintFlag=$("#NoPrintFlag").checkbox('getValue');
	if(NoPrintFlag){NoPrint="Y";}
	else{NoPrint=""}
	
	var RowID=$("#RowID").val();
	var APCRowID="";
	if (RowID!="")
	{
		var InvID=$("#CurInv").val();
		var InvID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvID);
		if (InvID=="")
		{
			$.messager.alert("��ʾ","û�з�Ʊ,���ܳ�ֵ","info");
			return false;
		}
		var Fee=$("#Fee").val();
		if (Fee=="")
		{
			$.messager.alert("��ʾ","��ֵ����Ϊ��","info");
			return false;
		}
		if ((isNaN(Fee))||(Fee=="")||(Fee==0)||(Fee<0)){
			$.messager.alert("��ʾ","��������ȷ�ĳ�ֵ���","info");
			return false;
		}
		
		if((Fee!="")&&(Fee.indexOf(".")!="-1")&&(Fee.toString().split(".")[1].length>2))
		{
			$.messager.alert("��ʾ","��ֵ���С������ܳ�����λ","info");
			return false;
		}
		
		
		var PayMode=$("#PayMode").combobox('getValue');
		if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayMode="";}
		if(PayMode=="")
		{
			$.messager.alert("��ʾ","֧����ʽ����Ϊ��","info");
			return false;
		}
		var CardInfo="";
		var CardInfo=$("#No").val();
		var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
		if(PayModeDesc.indexOf("֧Ʊ")>=0){

			if(CardInfo==""){
			$.messager.alert("��ʾ","������֧Ʊ��","info");
			return false;
			}
		}
		var Remark=$("#Remark").val();
		var MRemark=$("#MRemark").val();
		var PADM=$("#PADM").val();
		var InStrings=RowID+"^"+Fee+"^"+InvID+"^"+PayMode+"^"+MRemark+"^"+NoPrint+"^"+PADM+"^"+CardInfo+"^"+Remark;
		//alert(InStrings)
		var Type=$("#ATJCardType").combobox('getValue');
		if (($("#ATJCardType").combobox('getValue')==undefined)||($("#ATJCardType").combobox('getValue')=="")){var Type="";}
		if (Type=="C")
		{
			var sName=$.trim($("#AName").val());
			if (sName==""){
				$.messager.alert("��ʾ","��������Ϊ��","info");	
				return false;
			}
			
			var sSex=$("#Sex").val();
			if((sSex!="")&&(sSex!="��")&&(sSex!="Ů")&&(sSex!="����")){
				$.messager.alert("��ʾ","�Ա�����д:�С�Ů������","info");
				websys_setfocus("Sex");	
				return false;
			}
			var sAge=$("#Age").val();
			if (!(IsFloat(sAge))) {
				$.messager.alert("��ʾ","�����ʽ�Ƿ�","info"); 
				websys_setfocus("Age");		
				return false;
			}
			
			InStrings=InStrings+"&"+sName+"^"+sSex+"^"+sAge
		}
		
		var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","UpdateData","2",InStrings)
		var RetArr=ret.split("^");
		if (RetArr[0]!=0)
		{
			alert(RetArr[0]);
			return false;
		}else{
			APCRowID=RetArr[2];
		}
	}
	else
	{
		var RegNo=$.trim($("#ARegNo").val());
		
		var Type=$("#ATJCardType").combobox('getValue');
		if (($("#ATJCardType").combobox('getValue')==undefined)||($("#ATJCardType").combobox('getValue')=="")){var Type="";}
		var CardNo="";
		if (Type!="C")
		{
			if (RegNo=="")
			{
				$.messager.alert("��ʾ","�ǼǺŲ���Ϊ��","info");
				return false;
			}
		}
		else
		{
		
			var CardNo=RegNo;
			var RegNo="";
			if (CardNo=="")
			{
				$.messager.alert("��ʾ","���Ų���Ϊ��","info");
				return false;
			}
		}
		var Amount=$("#Amount").val();
		var Status=$("#AStatus").combobox('getValue');
		if (Status!="N")
		{
			$.messager.alert("��ʾ","���ǿ��õ�״̬","info");
			return false;
		}
		var Date="",Time="",User=""
		var Remark=$("#Remark").val()
		var PassWord=""
		//var PassWord=GetOneData("PassWord")
		var Fee=$("#Fee").val();
		
		var CardInfo="";
		var CardInfo=$("#No").val();
		var PayMode=$("#PayMode").combobox('getValue');
		if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayMode="";}
		if(PayMode=="")
		{
			$.messager.alert("��ʾ","֧����ʽ����Ϊ��","info");
			return false;
		}
		var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
		if(PayModeDesc.indexOf("֧Ʊ")>=0){

			if(CardInfo==""){
				$.messager.alert("��ʾ","������֧Ʊ��","info");
				return false;
			}
		}

		if (Fee!="")
		{
			var InvID=$("#CurInv").val();
			var InvID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvID);
			if (InvID=="")
			{
				$.messager.alert("��ʾ","û�з�Ʊ,���ܳ�ֵ","info");
				return false;
			}
		}else  if (Fee=="")
		{
		
			if ((Type=="C")||(Type=="R"))
			{
				$.messager.alert("��ʾ","��ֵ����Ϊ��","info");
				return false;
			}
		}
		if ((isNaN(Fee))||(Fee=="")||(Fee==0)||(Fee<0)){
			$.messager.alert("��ʾ","��������ȷ�ĳ�ֵ���","info");
			return false;
		}
        if((Fee!="")&&(Fee.indexOf(".")!="-1")&&(Fee.toString().split(".")[1].length>2))
		{
			$.messager.alert("��ʾ","��ֵ���С������ܳ�����λ","info");
			return false;
		}
		var PayMode=$("#PayMode").combobox('getValue');
		if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayMode="";}
		if(PayMode=="")
		{
			$.messager.alert("��ʾ","֧����ʽ����Ϊ��","info");
			return false;
		}
		var MRemark=$("#MRemark").val();
		if((MRemark=="")&&(Remark!="")){var MRemark=Remark;}
		var PADM=$("#PADM").val();
		var InStrings="^"+RegNo+"^"+CardNo+"^"+Type+"^"+Amount
					  +"^"+Status+"^"+Date+"^"+Time+"^"+User
					  +"^"+Remark+"^"+PassWord+"&"+Fee+"^"+InvID+"^"+PayMode+"^"+MRemark+"^"+NoPrint+"^"+PADM+"^"+CardInfo;
		//alert(InStrings)
		if (Type=="C")
		{
			var sName=$.trim($("#AName").val());
			if (sName==""){
				$.messager.alert("��ʾ","��������Ϊ��","info");
				return false;
			}
			var sSex=$("#Sex").val();
			if((sSex!="")&&(sSex!="��")&&(sSex!="Ů")&&(sSex!="����")){
				$.messager.alert("��ʾ","�Ա�����д:�С�Ů������","info");
				websys_setfocus("Sex");	
				return false;
			}
			var sAge=$("#Age").val();
			if (!(IsFloat(sAge))) {
				$.messager.alert("��ʾ","�����ʽ�Ƿ�","info"); 
				websys_setfocus("Age");		
				return false;
			}
				
			InStrings=InStrings+"&"+sName+"^"+sSex+"^"+sAge
		}
		var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","UpdateData","1",InStrings)
		var RetArr=ret.split("^");
		//alert(ret)
		if (RetArr[0]!=0)
		{
			alert(RetArr[0])
			return false;
		}else{
			APCRowID=RetArr[2];
		}
	}
	if(APCRowID!=""){
		var extPayInfo=tkMakeServerCall("web.DHCPE.AdvancePayment","GetPayInfoByAPCRowID",APCRowID);
		if(extPayInfo!=""){
			var char1 = String.fromCharCode(1)
			var baseInfo = extPayInfo.split(char1)[1];
			var patId = baseInfo.split("^")[0];
			var paadm = baseInfo.split("^")[1];
			var scanFlag = baseInfo.split("^")[2];
			var payInfo = extPayInfo.split(char1)[0];
			var payArr = payInfo.split("^");
			var payDR = payArr[0];
			var payCode = payArr[1];
			var payAmt = payArr[2];
			if (scanFlag == "1") {
				/*var expStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.HOSPID'];
				var str = "dhcbarcodepay.csp";
				var payBarCode = window.showModalDialog(str, "", 'dialogWidth:300px;dialogHeight:150px;resizable:yes'); //HTML��ʽ��ģ̬�Ի���
				if ((payBarCode == "") || (payBarCode == "undefind")) {
					$.messager.alert("��ʾ","�۷�ʧ��","info");
				}
				var PEBarCodePayStr = tkMakeServerCall("MHC.BarCodePay", "PEBarCodePay", paadm, payBarCode, APCRowID, payAmt, payDR, expStr);
				var rtnAry = PEBarCodePayStr.split("^");
				if (rtnAry[0] != 0) {
					$.messager.alert("��ʾ","�۷�ʧ��","info");
				} else{
					
				}*/
			}else{
				//����^��ȫ��^Ժ��^����ԱID^����ID^����^ҵ���ָ�봮(��!�ָ�,��Ϊ��)
				var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^" + patId + "^" + paadm + "^^C^" + APCRowID;
				var PayCenterRtn = PayService("PEDEP", payDR, payAmt, expStr);
				if (PayCenterRtn.ResultCode!= "0") {
						$.messager.alert("��ʾ","������֧��ʧ�ܣ�"+PayCenterRtn.ResultMsg+"\n�������շ�","info");
				} else {
					var ETPRowID = PayCenterRtn.ETPRowID;	
					if (ETPRowID != "") {
						var ReFlag = RelationService(ETPRowID, APCRowID, "PEDEP");
						if (ReFlag.ResultCode != "0") {
							$.messager.alert("��ʾ","�Ʒѹ���ʧ�ܣ�����ϵ��Ϣ�ƣ�\n" + ReFlag.ResultMsg,"info");
						}
					}	
				}
			}
		}
	}
	PrintReceipt();
	$("#Fee").val("");
	
	if ((Fee!="")&&(NoPrint==""))
	{
		var InvID=$("#CurInv").val();
		PrintInv(InvID)
	}
	
	BFind_click();
	$('#myWin').dialog('close'); 
	
}


function PrintReceipt()
{
	var CardNo=$("#ARegNo").val()
	var Cost=$("#Fee").val();
	PrintAccSheet(CardNo,Cost);
}
function PrintAccSheet(CardNo,Cost){
	if (CardNo=="") return;
	if (Cost=="") return;

	var PayModeDR=21;
	var Type=$("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue')==undefined)||($("#ATJCardType").combobox('getValue')=="")){var Type="";}
	var CurrentBalance=tkMakeServerCall("web.DHCPE.AdvancePayment","GetAPAmount",PayModeDR+"^"+Type,CardNo);
	var DateTime=tkMakeServerCall("web.DHCPE.Cashier","GetDateTimeStr");

	var Delim=String.fromCharCode(2);
	var TxtInfo="CardNo"+Delim+CardNo;
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+Cost;
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+CurrentBalance;
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime;
	 var CardNoL="����:"
    if(Type=="R"){var CardNoL="�ǼǺ�:";}
    else{
	     var CardNoL="����:"
    }
	var TxtInfo=TxtInfo+"^"+"CardNoL"+Delim+CardNoL;
	var HosName="";
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
    var TxtInfo=TxtInfo+"^"+"HosName"+Delim+HosName;
	PrintBalance(TxtInfo);
	
}
// ��ӡ���֧�������
function PrintBalance(TxtInfo)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEReceipt");
	var myobj=document.getElementById("ClsBillPrint");
	var Delim=String.fromCharCode(2);
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(�̻����)";
	DHCP_PrintFun(myobj,TxtInfoPat,"");
}

//��ӡ��Ʊ
function PrintInv(InvID)
{
	var InvName=$("#InvName").val();
	
	var TxtInfo=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInvoiceInfo",InvID,"1",InvName);
	var ListInfo=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInvoiceInfo",InvID,"2",InvName);
	if (TxtInfo=="") return
	
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","");
	
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}






function ATJCardType_change(){
	AElementEnble();
	$("#ARegNo,#AName,#ACardTypeNew,#ACardNo,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName").val("");
	$("#RowID").val("");
	
}
function AElementEnble()
{
	
	var Type=$("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue')==undefined)||($("#ATJCardType").combobox('getValue')=="")){var Type="";}
	//alert(Type)
	if(Type=="R"){
		$("#BChangeStatus").linkbutton('disable');
		$("#BReadCard_btn").linkbutton('enable');
		$("#AStatus").combobox('disable');
		$("#AStatus").combobox('setValue',"N");
		
	}else{
		$("#AStatus").combobox('enable');
		$("#BReadCard_btn").linkbutton('disable');
		$("#BChangeStatus").linkbutton('enable');
		var Status=$("#AStatus").combobox('getValue');
		if (Status!="N")
		{
			$("#BSave").linkbutton('disable');
			
		}else{
			$("#BSave").linkbutton('enable');
		}
	}

	if ((Type!="R")&&(Type!="C"))
	{
		$("#Fee").attr('disabled',true);
		$("#PayMode").attr('disabled',true);
		
	}else{
		$("#Fee").attr('disabled',false);
		$("#PayMode").attr('disabled',false);
	}
	
	
	if (Type=="C")
		{
			
			document.getElementById("cARegNo").innerHTML="���𿨺�";
			$("#ACardNo").css('display','none');//����
			$("#cACardNo").css('display','none');//����
			$("#ACardTypeNew").css('display','none');//����
			$("#cACardTypeNew").css('display','none');//����
			//$("#ARegNo").css('display','none');//����
			
			$("#ATName").attr('disabled',false);
			$("#Sex").attr('disabled',false);
			$("#Age").attr('disabled',true); 
			//$("#BReadCard").linkbutton('disable');
			

		}
		else
		{
			document.getElementById("cARegNo").innerHTML="�ǼǺ�";
			$("#ACardNo").css('display','block');//��ʾ
			$("#cACardNo").css('display','block');//��ʾ
			$("#ACardTypeNew").css('display','block');//��ʾ
			$("#cACardTypeNew").css('display','block');//��ʾ
			
			//$("#ARegNo").css('display','block');//��ʾ
			$("#ARegNo").attr('disabled',false);
			
			$("#ATName").attr('disabled',true);
			$("#Sex").attr('disabled',true);
			$("#Age").attr('disabled',true);
			
			//$("#APCardNo").css('display','none');//����
			
			//$("#BReadCard").linkbutton('enable');
			
		}
	
}
//��ȡ��ǰ��Ʊ��
function SetInvNo()
{ 
	var userId=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]=="")){
	    $.messager.alert('��ʾ','û����ȷ�ķ�Ʊ��',"info");
	    return false;
    }
    
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    $("#CurInv").val(No);
    	 		   
}
/****************************************************�����������End**********************************/

function CardType_change()
{
	
	ElementEnble();
}

function ElementEnble()
{
	CardType=$("#TJCardType").combobox('getValue');
     if (CardType=="C")
		{
			 document.getElementById('cRegNo').innerHTML="���𿨺�";
			$("#CardNo").css('display','none');
			$("#cCardNo").css('display','none');
			$("#CardTypeNew").css('display','none');
			$("#cCardTypeNew").css('display','none');
			$("#BReadCard").css('display','none');
			
			
		}
	 if (CardType=="R")
		{
			 document.getElementById('cRegNo').innerHTML="�ǼǺ�";
			 $("#CardNo").css('display','block');
			$("#cCardNo").css('display','block');
			$("#CardTypeNew").css('display','block');
			$("#cCardTypeNew").css('display','block');
			$("#BReadCard").css('display','block');
			
			
			
		}	
}

//��ѯ
function BFind_click(){
	var HospID=session['LOGON.HOSPID']
	
	var Type=$("#TJCardType").combobox('getValue');
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=$("#RegNo").val();

  if(Type=="R"){
	   	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
			$("#RegNo").val(iRegNo)
		};
	   var columns =[[
			{field:'TRowID',title:'ID',hidden: true},
			{field:'TRegNo',width:150,title:'�ǼǺ�'},
		 	{field:'TCardNo',title:'���𿨺�',hidden: true},
			{field:'TName',width:150,title:'����'},
			{field:'TAmount',width:150,title:'���',align:'right'},
			{field:'TStatus',width:60,title:'״̬'},
			{field:'TRemark',width:200,title:'��ע'},
			{field:'TUser',width:120,title:'����Ա'},
			{field:'TDate',width:120,title:'����'},
			{field:'TTime',width:120,title:'ʱ��'},
			{field:'TSex',width:80,title:'�Ա�'},
			{field:'TAge',width:80,title:'����'},	
						 
		]];


	   }
	if(Type=="C"){
	   var columns =[[
			{field:'TRowID',title:'ID',hidden: true},
			{field:'TRegNo',title:'�ǼǺ�',hidden: true},
		 	{field:'TCardNo',width:150,title:'���𿨺�'},
			{field:'TName',width:150,title:'����'},
			{field:'TAmount',width:150,title:'���',align:'right'},
			{field:'TStatus',width:60,title:'״̬'},
			{field:'TRemark',width:200,title:'��ע'},
			{field:'TUser',width:120,title:'����Ա'},
			{field:'TDate',width:120,title:'����'},
			{field:'TTime',width:120,title:'ʱ��'},
			{field:'TSex',width:80,title:'�Ա�'},
			{field:'TAge',width:80,title:'����'},	
						 
		]];
	   }
	   
	   $HUI.datagrid("#AdvancePaymentGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAdvancePaymentNew",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Status:$("#Status").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			CardType:$("#TJCardType").combobox('getValue'),
			HospID:HospID

		},
		columns:columns,		
	})
   
   
	
}



function CardNo_Change()
{
	var myCardNo=$("#CardNo").val();
	if (myCardNo=="") {
		$.messager.alert("��ʾ","����Ϊ��","info");
		return;
	}
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","",CardNoKeyDownCallBack);
		return false;
	
}
//����
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}

function CardNoKeyDownCallBack(myrtn){
	//alert(myrtn)
	var CardNo=$("#CardNo").val();
	var CardTypeNew=$("#CardTypeNew").val();
	$(".textbox").val('');
	$("#CardTypeNew").val(CardTypeNew);
   var myary=myrtn.split("^");
   var rtn=myary[0];
   if ((rtn=="0")||(rtn=="-201")){
		var PatientID=myary[4];
		var PatientNo=myary[5];
		var CardNo=myary[1];
		$("#CardTypeRowID").val(myary[8]);
		$("#CardNo").focus().val(CardNo);
		$("#RegNo").val(PatientNo);
		BFind_click();
	}else if(rtn=="-200"){
		$.messager.popover({msg: "����Ч!", type: "info"});
		$("#CardNo").focus().val(CardNo);
		/*$.messager.alert("��ʾ","����Ч!","info",function(){
			$("#CardNo").val(CardNo).focus();
		});
		*/
		
		return false;
	}
}

//����
function BClear_click(){
	$("#RegNo,#Name,#CardTypeNew,#CardNo").val("");
	$(".hisui-combobox").combobox('setValue',"");
	$("#BReadCard").linkbutton('enable');
	//Ĭ��ʱ��
	Initdate();
	 //Ĭ����쿨����Ϊ"Ԥ�ɽ�"
	$("#TJCardType").combobox('setValue',"R");
	CardType_change()
	BFind_click();

}


var columns =[[
			{field:'TRowID',title:'ID',hidden: true},
			{field:'TRegNo',width:'150',title:'�ǼǺ�'},
		 	{field:'TCardNo',title:'���𿨺�',hidden: true},
			{field:'TName',width:'150',title:'����'},
			{field:'TAmount',width:'150',title:'���',align:'right'},
			{field:'TStatus',width:'60',title:'״̬'},
			{field:'TRemark',width:'200',title:'��ע'},
			{field:'TUser',width:'120',title:'����Ա'},
			{field:'TDate',width:'120',title:'����'},
			{field:'TTime',width:'120',title:'ʱ��'},
			{field:'TSex',width:'80',title:'�Ա�'},
			{field:'TAge',width:'80',title:'����'},	
						 
		]];
				
function InitAdvancePaymentGrid(){
	$HUI.datagrid("#AdvancePaymentGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAdvancePaymentNew",
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			CardType:"R",

		},
		columns:columns,
		onSelect: function (rowIndex, rowData) {	
			
		}
			
	})	
}

function  InitCombobox(){
	//��쿨����
	var TJTypeObj = $HUI.combobox("#TJCardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'R',text:'Ԥ�ɽ�'},
            {id:'C',text:'����'},
           
        ]

	});
		
	//״̬
	var StatusObj = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'N',text:'����'},
            {id:'A',text:'����'},
            {id:'L',text:'��ʧ'},
            {id:'F',text:'����'},
           
           
        ]

	});	
	
	//��쿨����
	var ATJTypeObj = $HUI.combobox("#ATJCardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'R',text:'Ԥ�ɽ�'},
            {id:'C',text:'����'},
           
        ]

	});
		
	//״̬
	var AStatusObj = $HUI.combobox("#AStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'N',text:'����'},
            {id:'A',text:'����'},
            {id:'L',text:'��ʧ'},
            {id:'F',text:'����'},
           
           
        ]

	});	
	
	
	// ֧����ʽ	
	var RPObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCardPayMode&ResultSetType=array",
		valueField:'id',
		textField:'text',
		panelHeight:'140',	
		})	
			
}


//����Ĭ��ʱ��Ϊ����
function Initdate()
{
	var today = getDefStDate(0);
	$("#BeginDate").datebox('setValue', today);
	$("#EndDate").datebox('setValue', today);
}

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	if(""==$.trim(Value)) { 
		return true; 
	}else { Value=Value.toString(); }
	reg=/^((\d+\.\d*[1-9]\d*)|(\d*[1-9]\d*\.\d+)|(\d*[1-9]\d*))$/
	//reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
	
}
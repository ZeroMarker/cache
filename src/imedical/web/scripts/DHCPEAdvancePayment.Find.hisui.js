
//名称	DHCPEAdvancePayment.Find.hisui.js
//功能	体检卡管理	
//创建	2019.07.01
//创建人  xy
$(function(){
		
	InitCombobox();
	
	//默认时间
	Initdate();
	
	InitAdvancePaymentGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    
    //清屏
    $("#BClear").click(function() {	
		BClear_click();		
        });
      
    
     //读卡
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
	    
    //新增
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
        
        
   //默认体检卡类型为"预缴金"
	$("#TJCardType").combobox('setValue',"R");
   
   
})
/****************************************************新增区域代码**********************************/
function PayMode_change()
{
	var PayModeNew=$("#PayMode").combobox('getValue');
	if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayModeNew="";}
	 var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayModeNew);
	if((PayModeDesc!="")&&(PayModeDesc.indexOf("支票")>=0)){
		$("#No").attr('disabled',false);
	}else{
		
		$("#No").attr('disabled',true);
		$("#No").val("");
	}
	
}

//新增
function BNew_click()
{
	
	$("#myWin").show();

		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-card',
			resizable:true,
			title:'体检卡管理',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				iconCls:'icon-w-add',
				text:'新建',
				id:'BSave',
				handler:function(){
					BSave_click()
				}
			},{
				iconCls:'icon-w-update',
				text:'修改状态',
				id:'BChangeStatus',
				handler:function(){
					BChangeStatus()
				}
			},{
				iconCls:'icon-w-card',
				text:'读卡',
				id:'BReadCard_btn',
				handler:function(){
					BReadCard()
				}
			},{
				iconCls:'icon-w-clean',
				text:'清屏',
				id:'BClear_btn',
				handler:function(){
					BClear()
				}
			},{
				iconCls:'icon-w-close',
				text:'关闭',
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



//修改状态
function BChangeStatus(){
	
	var RowID=$("#RowID").val();
	if (RowID=="")
	{
		$.messager.alert("提示","没有要修改的记录","info");
		return false;
	}
	var Status=$("#AStatus").combobox('getValue');
	var Remark=$("#MRemark").val();
	var Strings=RowID+"^"+Status+"^"+Remark;
	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","UpdateData","3",Strings)
	var RetArr=ret.split("^");
	if (RetArr[0]!=0)
	{
		$.messager.alert("提示",RetArr[0],"info");
		return false;
	}
	$.messager.alert("提示","操作完成","success");
	
	
	AElementEnble();
}


//清屏
function BClear(){
	$("#ARegNo,#AName,#ACardTypeNew,#ACardNo,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#RowID,#PADM").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#AStatus").combobox('setValue',"N");
     $("#PayMode").combobox('setValue',"1");
	
	var RowID=$("#RowID").val()
	if (RowID=="")
	{
		
		SetCElement("BSave","新建");
		
	}
}


function ACardNo_Change()
{
	var myCardNo=$("#ACardNo").val();
	if (myCardNo=="") {
		$.messager.alert("提示","卡号为空","info");
		return;
	}
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","",CardTypeCallBack);
		return false;
	
}

//读卡
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
		/*$.messager.alert("提示","卡无效!","info",function(){
			$("#ACardNo").val(CardNo).focus();
		});
		*/
		$.messager.popover({msg: "卡无效!", type: "info"});
		$("#CardNo").focus().val(CardNo);

		return false;
	}
}

function ARegNo_change()
{
	var Type=$("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue')==undefined)||($("#ATJCardType").combobox('getValue')=="")){var Type="";}
	if(Type==""){
		$.messager.alert("提示","请选择体检卡类型","info");
		$.messager.alert("提示","请选择体检卡类型","info");
		return false;
	}
	$("#RowID").val("");
	var RowID=$("#RowID").val();
	if (RowID=="")
	{
		
		SetCElement("BSave","新建");
		
		
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
			 $.messager.popover({msg: "无效的登记号", type: "info"});
			
			return false;
		}
		var DataArr=Data.split("^");
		$("#ARegNo").val(DataArr[0]);
		$("#AName").val(DataArr[1]);
		$("#Age").val(DataArr[2]);
		$("#Sex").val(DataArr[3]);
		$("#ACardNo").val(DataArr[4]);
		//根据登记号带出卡类型 
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
		
		SetCElement("BSave","新建");
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
			SetCElement("BSave","充值");
			
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

//保留小数点后两位
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
		$.messager.alert("提示","请选择体检卡类型","info");
		return false
	
	}
	
	var RegNo=$.trim($("#ARegNo").val());
	if ((RegNo=="")&&(Type=="R")) {
		$.messager.alert("提示","请输入登记号","info");
		return;
	}
	if ((RegNo=="")&&(Type=="C")) {
		$.messager.alert("提示","请输入代金卡号","info");
		return;
	}
	if((Type=="C")&&(document.getElementById('BSave').innerHTML.indexOf("新建")>-1)){
		var flag=tkMakeServerCall("web.DHCPE.AdvancePayment","IsExsistCardByCardNo",RegNo);
		if(flag=="1"){
			$.messager.alert("提示","该卡号已被使用，请输入可用的卡号","info"); 
			 $("#ARegNo").val("");
		    return false;
		}
	}

	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetPatientInfo",RegNo,Type)
	if (Type!="C")
	{
		if (Data=="")
		{
			$.messager.alert("提示","无效的登记号","info");
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
			$.messager.alert("提示","没有发票,不能充值","info");
			return false;
		}
		var Fee=$("#Fee").val();
		if (Fee=="")
		{
			$.messager.alert("提示","充值金额不能为空","info");
			return false;
		}
		if ((isNaN(Fee))||(Fee=="")||(Fee==0)||(Fee<0)){
			$.messager.alert("提示","请输入正确的充值金额","info");
			return false;
		}
		
		if((Fee!="")&&(Fee.indexOf(".")!="-1")&&(Fee.toString().split(".")[1].length>2))
		{
			$.messager.alert("提示","充值金额小数点后不能超过两位","info");
			return false;
		}
		
		
		var PayMode=$("#PayMode").combobox('getValue');
		if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayMode="";}
		if(PayMode=="")
		{
			$.messager.alert("提示","支付方式不能为空","info");
			return false;
		}
		var CardInfo="";
		var CardInfo=$("#No").val();
		var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
		if(PayModeDesc.indexOf("支票")>=0){

			if(CardInfo==""){
			$.messager.alert("提示","请输入支票号","info");
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
				$.messager.alert("提示","姓名不能为空","info");	
				return false;
			}
			
			var sSex=$("#Sex").val();
			if((sSex!="")&&(sSex!="男")&&(sSex!="女")&&(sSex!="不限")){
				$.messager.alert("提示","性别请填写:男、女、不限","info");
				websys_setfocus("Sex");	
				return false;
			}
			var sAge=$("#Age").val();
			if (!(IsFloat(sAge))) {
				$.messager.alert("提示","年龄格式非法","info"); 
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
				$.messager.alert("提示","登记号不能为空","info");
				return false;
			}
		}
		else
		{
		
			var CardNo=RegNo;
			var RegNo="";
			if (CardNo=="")
			{
				$.messager.alert("提示","卡号不能为空","info");
				return false;
			}
		}
		var Amount=$("#Amount").val();
		var Status=$("#AStatus").combobox('getValue');
		if (Status!="N")
		{
			$.messager.alert("提示","不是可用的状态","info");
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
			$.messager.alert("提示","支付方式不能为空","info");
			return false;
		}
		var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
		if(PayModeDesc.indexOf("支票")>=0){

			if(CardInfo==""){
				$.messager.alert("提示","请输入支票号","info");
				return false;
			}
		}

		if (Fee!="")
		{
			var InvID=$("#CurInv").val();
			var InvID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvID);
			if (InvID=="")
			{
				$.messager.alert("提示","没有发票,不能充值","info");
				return false;
			}
		}else  if (Fee=="")
		{
		
			if ((Type=="C")||(Type=="R"))
			{
				$.messager.alert("提示","充值金额不能为空","info");
				return false;
			}
		}
		if ((isNaN(Fee))||(Fee=="")||(Fee==0)||(Fee<0)){
			$.messager.alert("提示","请输入正确的充值金额","info");
			return false;
		}
        if((Fee!="")&&(Fee.indexOf(".")!="-1")&&(Fee.toString().split(".")[1].length>2))
		{
			$.messager.alert("提示","充值金额小数点后不能超过两位","info");
			return false;
		}
		var PayMode=$("#PayMode").combobox('getValue');
		if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayMode="";}
		if(PayMode=="")
		{
			$.messager.alert("提示","支付方式不能为空","info");
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
				$.messager.alert("提示","姓名不能为空","info");
				return false;
			}
			var sSex=$("#Sex").val();
			if((sSex!="")&&(sSex!="男")&&(sSex!="女")&&(sSex!="不限")){
				$.messager.alert("提示","性别请填写:男、女、不限","info");
				websys_setfocus("Sex");	
				return false;
			}
			var sAge=$("#Age").val();
			if (!(IsFloat(sAge))) {
				$.messager.alert("提示","年龄格式非法","info"); 
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
				var payBarCode = window.showModalDialog(str, "", 'dialogWidth:300px;dialogHeight:150px;resizable:yes'); //HTML样式的模态对话框
				if ((payBarCode == "") || (payBarCode == "undefind")) {
					$.messager.alert("提示","扣费失败","info");
				}
				var PEBarCodePayStr = tkMakeServerCall("MHC.BarCodePay", "PEBarCodePay", paadm, payBarCode, APCRowID, payAmt, payDR, expStr);
				var rtnAry = PEBarCodePayStr.split("^");
				if (rtnAry[0] != 0) {
					$.messager.alert("提示","扣费失败","info");
				} else{
					
				}*/
			}else{
				//科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
				var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^" + patId + "^" + paadm + "^^C^" + APCRowID;
				var PayCenterRtn = PayService("PEDEP", payDR, payAmt, expStr);
				if (PayCenterRtn.ResultCode!= "0") {
						$.messager.alert("提示","第三方支付失败："+PayCenterRtn.ResultMsg+"\n请重新收费","info");
				} else {
					var ETPRowID = PayCenterRtn.ETPRowID;	
					if (ETPRowID != "") {
						var ReFlag = RelationService(ETPRowID, APCRowID, "PEDEP");
						if (ReFlag.ResultCode != "0") {
							$.messager.alert("提示","计费关联失败，请联系信息科！\n" + ReFlag.ResultMsg,"info");
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
	 var CardNoL="卡号:"
    if(Type=="R"){var CardNoL="登记号:";}
    else{
	     var CardNoL="卡号:"
    }
	var TxtInfo=TxtInfo+"^"+"CardNoL"+Delim+CardNoL;
	var HosName="";
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
    var TxtInfo=TxtInfo+"^"+"HosName"+Delim+HosName;
	PrintBalance(TxtInfo);
	
}
// 打印体检支付卡余额
function PrintBalance(TxtInfo)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEReceipt");
	var myobj=document.getElementById("ClsBillPrint");
	var Delim=String.fromCharCode(2);
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(商户存根)";
	DHCP_PrintFun(myobj,TxtInfoPat,"");
}

//打印发票
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
			
			document.getElementById("cARegNo").innerHTML="代金卡号";
			$("#ACardNo").css('display','none');//隐藏
			$("#cACardNo").css('display','none');//隐藏
			$("#ACardTypeNew").css('display','none');//隐藏
			$("#cACardTypeNew").css('display','none');//隐藏
			//$("#ARegNo").css('display','none');//隐藏
			
			$("#ATName").attr('disabled',false);
			$("#Sex").attr('disabled',false);
			$("#Age").attr('disabled',true); 
			//$("#BReadCard").linkbutton('disable');
			

		}
		else
		{
			document.getElementById("cARegNo").innerHTML="登记号";
			$("#ACardNo").css('display','block');//显示
			$("#cACardNo").css('display','block');//显示
			$("#ACardTypeNew").css('display','block');//显示
			$("#cACardTypeNew").css('display','block');//显示
			
			//$("#ARegNo").css('display','block');//显示
			$("#ARegNo").attr('disabled',false);
			
			$("#ATName").attr('disabled',true);
			$("#Sex").attr('disabled',true);
			$("#Age").attr('disabled',true);
			
			//$("#APCardNo").css('display','none');//隐藏
			
			//$("#BReadCard").linkbutton('enable');
			
		}
	
}
//获取当前发票号
function SetInvNo()
{ 
	var userId=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]=="")){
	    $.messager.alert('提示','没有正确的发票号',"info");
	    return false;
    }
    
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    $("#CurInv").val(No);
    	 		   
}
/****************************************************新增区域代码End**********************************/

function CardType_change()
{
	
	ElementEnble();
}

function ElementEnble()
{
	CardType=$("#TJCardType").combobox('getValue');
     if (CardType=="C")
		{
			 document.getElementById('cRegNo').innerHTML="代金卡号";
			$("#CardNo").css('display','none');
			$("#cCardNo").css('display','none');
			$("#CardTypeNew").css('display','none');
			$("#cCardTypeNew").css('display','none');
			$("#BReadCard").css('display','none');
			
			
		}
	 if (CardType=="R")
		{
			 document.getElementById('cRegNo').innerHTML="登记号";
			 $("#CardNo").css('display','block');
			$("#cCardNo").css('display','block');
			$("#CardTypeNew").css('display','block');
			$("#cCardTypeNew").css('display','block');
			$("#BReadCard").css('display','block');
			
			
			
		}	
}

//查询
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
			{field:'TRegNo',width:150,title:'登记号'},
		 	{field:'TCardNo',title:'代金卡号',hidden: true},
			{field:'TName',width:150,title:'姓名'},
			{field:'TAmount',width:150,title:'金额',align:'right'},
			{field:'TStatus',width:60,title:'状态'},
			{field:'TRemark',width:200,title:'备注'},
			{field:'TUser',width:120,title:'操作员'},
			{field:'TDate',width:120,title:'日期'},
			{field:'TTime',width:120,title:'时间'},
			{field:'TSex',width:80,title:'性别'},
			{field:'TAge',width:80,title:'年龄'},	
						 
		]];


	   }
	if(Type=="C"){
	   var columns =[[
			{field:'TRowID',title:'ID',hidden: true},
			{field:'TRegNo',title:'登记号',hidden: true},
		 	{field:'TCardNo',width:150,title:'代金卡号'},
			{field:'TName',width:150,title:'姓名'},
			{field:'TAmount',width:150,title:'金额',align:'right'},
			{field:'TStatus',width:60,title:'状态'},
			{field:'TRemark',width:200,title:'备注'},
			{field:'TUser',width:120,title:'操作员'},
			{field:'TDate',width:120,title:'日期'},
			{field:'TTime',width:120,title:'时间'},
			{field:'TSex',width:80,title:'性别'},
			{field:'TAge',width:80,title:'年龄'},	
						 
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
		$.messager.alert("提示","卡号为空","info");
		return;
	}
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","",CardNoKeyDownCallBack);
		return false;
	
}
//读卡
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
		$.messager.popover({msg: "卡无效!", type: "info"});
		$("#CardNo").focus().val(CardNo);
		/*$.messager.alert("提示","卡无效!","info",function(){
			$("#CardNo").val(CardNo).focus();
		});
		*/
		
		return false;
	}
}

//清屏
function BClear_click(){
	$("#RegNo,#Name,#CardTypeNew,#CardNo").val("");
	$(".hisui-combobox").combobox('setValue',"");
	$("#BReadCard").linkbutton('enable');
	//默认时间
	Initdate();
	 //默认体检卡类型为"预缴金"
	$("#TJCardType").combobox('setValue',"R");
	CardType_change()
	BFind_click();

}


var columns =[[
			{field:'TRowID',title:'ID',hidden: true},
			{field:'TRegNo',width:'150',title:'登记号'},
		 	{field:'TCardNo',title:'代金卡号',hidden: true},
			{field:'TName',width:'150',title:'姓名'},
			{field:'TAmount',width:'150',title:'金额',align:'right'},
			{field:'TStatus',width:'60',title:'状态'},
			{field:'TRemark',width:'200',title:'备注'},
			{field:'TUser',width:'120',title:'操作员'},
			{field:'TDate',width:'120',title:'日期'},
			{field:'TTime',width:'120',title:'时间'},
			{field:'TSex',width:'80',title:'性别'},
			{field:'TAge',width:'80',title:'年龄'},	
						 
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
	//体检卡类型
	var TJTypeObj = $HUI.combobox("#TJCardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'R',text:'预缴金'},
            {id:'C',text:'代金卡'},
           
        ]

	});
		
	//状态
	var StatusObj = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'N',text:'正常'},
            {id:'A',text:'作废'},
            {id:'L',text:'挂失'},
            {id:'F',text:'冻结'},
           
           
        ]

	});	
	
	//体检卡类型
	var ATJTypeObj = $HUI.combobox("#ATJCardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'R',text:'预缴金'},
            {id:'C',text:'代金卡'},
           
        ]

	});
		
	//状态
	var AStatusObj = $HUI.combobox("#AStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'N',text:'正常'},
            {id:'A',text:'作废'},
            {id:'L',text:'挂失'},
            {id:'F',text:'冻结'},
           
           
        ]

	});	
	
	
	// 支付方式	
	var RPObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCardPayMode&ResultSetType=array",
		valueField:'id',
		textField:'text',
		panelHeight:'140',	
		})	
			
}


//设置默认时间为当天
function Initdate()
{
	var today = getDefStDate(0);
	$("#BeginDate").datebox('setValue', today);
	$("#EndDate").datebox('setValue', today);
}

//验证是否为浮点数
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
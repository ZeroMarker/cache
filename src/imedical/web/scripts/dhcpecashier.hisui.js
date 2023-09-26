//名称	dhcpecashier.hisui.js
//功能	收费	
//创建	2019.04.26
//创建人  yupeng
var CardFee=0;
var payedInfo="";	///结算支付信息
var CardFlag="N";
var rowCount=0;
var roundingfee=0;
var MainName="";
$(function(){
	LoadCard();	
		
	InitCashierTableGrid();
		
    $("#Find").click(function() {	
		Find_click();
			
        }); 
    $("#CardNo").change(function(){
  			CardNoOnChange();
		});
		
		$("#CardNo").keydown(function(e) {
			
			if(e.keyCode==13){
				CardNoOnChange();
			}
			
   });   
   
    var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;   
        
    $('#BBilled').linkbutton('disable');   
    $("#BBilled").click(function() {	
    	BBilled_click();		
        }); 

	var obj=document.getElementById("RegNo");
	if (obj) 
	{	
		obj.onkeydown=RegNo_KeyDown;
	}   
    var obj=document.getElementById("Name");
	if (obj) 
	{	
		obj.onkeydown=Name_KeyDown;
	}       
    $("#BPrintDetail").click(function() {	
    	PrintInvByPreAudit();		
        });     
    $("#BAddRound").click(function() {	
    	BAddRound_Click();		
        });
	$("#BDeleteRoundItem").click(function() {	
    	BDeleteRoundItem_Click();		
        });  
        
    
        
   
	
	var obj=document.getElementById("No");
	if (obj) 
	{
		obj.onkeydown=No_KeyDown;
	}  
	
   	$("#AmountToPay").blur(function(){
  		Amount_Change();
	});     
        
    InitBillInfo();  
    
    $("#MultiSelect").checkbox({
        
        
        	onCheckChange:function(e,value){
	        	
	        	if(value)
	        	{
	       	 		$("#CashierTable").datagrid({ singleSelect: false });
	        	}
	        	else
	        	{
		        	$("#CashierTable").datagrid({ singleSelect: true });
		        }
		        
		        Find_click(); 
	        
        }
    }); 
     
     $("#PayMode").combogrid({
			onSelect:function(){
			PayMode_change(); 
		}
	    }); 
	    
   $("#PayMode").combogrid("setValue",defaultpaymode);  
   
    var invno=getValueById("CurNo");
   
	var Amount=getValueById("Amount");
	if ((""!=invno))
	{
		$('#BBilled').linkbutton('enable');
		
	} 

	//凑整费按钮灰化处理
	intiRoundingFee();
	
	if(TransGIADM)
	{
			
				$.messager.alert("提示","请核对收费信息！","info", function () {
					
				$("#PreAuditPayTable").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:TransADMType,CRMADM:"",GIADM:TransGIADM,AppType:"Fee"});
				$("#FeeListTable").datagrid('load',{ClassName:"web.DHCPE.ItemFeeList",QueryName:"FindItemFeeList",PreAudits:""});
				
				setValueById("ADMType",TransADMType);
 
				setValueById("GIADM",TransGIADM);
				
				var counter=getValueById("Counter");
				if (counter=="") counter=0; 
				
				for (i=0;i<=counter;i++)
				{
					$("#PayModeTR"+i).remove(); 
					
				}
				setValueById("Counter",0);
				
				setValueById("AmountToPay","");
				setValueById("No","");
				setValueById("Remark","");
				setValueById("InvName","");
				setValueById("TaxpayerNum","");
				setValueById("Rounding","");
				setValueById("RoundRemark","");
				setValueById("Change",0);
				setValueById("Amount","");
				//SetInvNo();
					
            
        		})
        		
        		
        		;
				
	}
        
})

function RegNo_KeyDown(){
	if (event.keyCode==13)
	{
		Find_click();
		var RegNo=getValueById("RegNo")
		RegNo=RegNoMask(RegNo)
		setValueById("RegNo",RegNo)
		
	}
}

function CardNo_Change()
{
	var myCardNo=$("#CardNo").val();
	
	if (myCardNo=="") {
		$.messager.alert("提示","卡号为空","info");
		return;
	}
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","",CardTypeKeydownHandler);
		return false;
	
}
function CardNoMask(CardNo)
{
	if (CardNo=="") return CardNo;
	var CardNo=tkMakeServerCall("web.DHCPE.DHCPECommon","CardNoMask",CardNo);
	return CardNo;
}
function RegNoMask(RegNo)
{
	if (RegNo=="") return RegNo;
	var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
	return RegNo;
}
function Name_KeyDown(){
	if (event.keyCode==13)
	{
		Find_click();
		
	}
}

function BDeleteRoundItem_Click()
{
	DeleteRoundFee();
}
function DeleteRoundFee()
{
	var IDs=GetSelectedIds();
	if (IDs=="") return false;
	var ret=tkMakeServerCall("web.DHCPE.CashierEx","DeleteRoundFee",IDs)
	if (ret==""){
		$.messager.alert("提示","操作完成!","info");
		var admtype=getValueById("ADMType")
   		var iadm=getValueById("GIADM")
   	
   		$("#PreAuditPayTable").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:admtype,CRMADM:"",GIADM:iadm,AppType:"Fee"});
		setValueById("Rounding","")
		return true
	}
	$.messager.alert("提示",ret,"info");

}
function BAddRound_Click()
{
	InsertRoundFee();
}

function CheckRoundFee()
{
	roundingfee=0;
	roundingfee=$("#Rounding").val();
	if (""==roundingfee) roundingfee=0;
	if (minroundingfee=="") minroundingfee=0;	
	if ((roundingitem=="")&&(roundingfee!=0)) 
	{
		$.messager.alert("提示","没有设置凑整费项目","info");
		return "";
	}	
	return "";
}

function InsertRoundFee()
{	
	
	var userId=session['LOGON.USERID'];
	var locId=session['LOGON.CTLOCID'];
	var peAdmType=getValueById("ADMType");
    var peAdmId=getValueById("GIADM");
    var preoradd="PRE"
    if (""==peAdmId)
    {	
    	$.messager.alert("提示","请先选择要操作的患者!","info");
	    return;	
	}
	    
	var err=CheckRoundFee();
	
	if (""!=err) 
	{	
		$.messager.alert("提示",err,"info");
		return;
	}	
	if (0==roundingfee)
	{	
		$.messager.alert("提示","请输入凑整费!","info");
		return;
	}
	
    var PAuditRowid="";
	var selectrow = $("#PreAuditPayTable").datagrid("getChecked");//获取的是数组，多行数据
	
	for(var i=0;i<selectrow.length;i++){
		
		PAuditRowid=selectrow[i].TRowId
			

	}
	
	var peAdmId=tkMakeServerCall("web.DHCPE.Cashier","GetPreIAdmID",peAdmType,peAdmId,PAuditRowid)
	
	if (""==peAdmId)
    {	
    	$.messager.alert("提示","请先选择要操作的患者!","info");
	    return;	
	}
	if ("I"==peAdmType) preoradd="ADD"	    
	peAdmType="PERSON";
	
	flag=tkMakeServerCall("web.DHCPE.PreItemList","IsExistItem",peAdmId, peAdmType, roundingitem, "")
	
    if ("1"==flag) {
    	if (!(confirm("已经存在凑整费?是否再增加?"))) {  return false; }
    }
    
    var RoundType=$HUI.combobox("#RoundType").getValue();
    
    var RoundRemark=getValueById('RoundRemark');
   
    var roundingitemStr=roundingitem+"&"+roundingfee+"&"+RoundType+"&"+RoundRemark;
    //alert(peAdmId+"^"+peAdmType+"^"+preoradd+"^"+roundingitemStr+"^"+userId)
    flag=tkMakeServerCall("web.DHCPE.PreItemList","IInsertItem",peAdmId, peAdmType,preoradd,roundingitemStr, "",userId)
	
	

	if (flag=="Notice"){
		$.messager.alert("提示","已审核,需取消审核!","info");
		
		return false;
	}
    if (flag!="") {
	    $.messager.alert("提示","保存失败!"+flag,"info");
	   	return false;
    }
   	
   	var admtype=getValueById("ADMType")
   	var iadm=getValueById("GIADM")
   	
   	$("#PreAuditPayTable").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:admtype,CRMADM:"",GIADM:iadm,AppType:"Fee"});
	setValueById("Rounding","")
   		
}

function PayMode_change()
{
	
	setValueById("Remark","")
	setValueById("No","")
	if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJYJJ")
	{
		var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM", getValueById("ADMType"), getValueById("GIADM"));
		setValueById("Remark", yjjamount)
	}
}


function Amount_Change()
{
	SetChange(0);
}

function No_KeyDown()
{
	if($("#PayMode").combogrid('grid').datagrid('getSelected').Code=="TJDJK")
			
	{
		var djkamount=tkMakeServerCall("web.DHCPE.PreAudit","GetDJAmount",getValueById("No"));	
				
		setValueById("Remark",djkamount)
				
	}
	
	
}

function Amount_KeyDown()
{
	if (event.keyCode==13)
	{
		Amount_Change(0);
		
	}
}

function CheckData()
{
	return SetChange(1);
}

function GetListFlag(admtype)
{
	if (admtype!="I") return 0;
	
	return ListFlag;
}


function PrintInvByPreAudit()
{
	
	var IDs=GetSelectedIds();
	
	if (IDs=="") return false;
	var ListInfo=tkMakeServerCall("web.DHCPE.CashierEx","GetListInfo",IDs)
	
	var TxtInfo=tkMakeServerCall("web.DHCPE.CashierEx","GetTextInfo",IDs)
	
	PrintDetail(TxtInfo,ListInfo);
}

function GetCardInfo(payedInfo) {
	var Balance="";
	var CardNo="";
	var CardInfo="";
	var Delim=String.fromCharCode(2);
	var PayedArr=payedInfo.split("#");
	var PayModeStr=PayedArr[0];
	var PayModeArr=PayModeStr.split("^");
	var Len=PayModeArr.length;
	for (i=0;i<Len;i++){
		var PayModeNod=PayModeArr[i];
		var PayModeNodArr=PayModeNod.split(",");
		var PayModeDR=PayModeNodArr[0];
		var ExpStr=PayModeNodArr[2];
		if (PayModeDR==21){
			
			var Balance=tkMakeServerCall("web.DHCPE.AdvancePayment.GetAPAmount","GetAPAmount",PayModeDR,ExpStr)
			
			var CardNo=ExpStr;
		
			if (CardInfo==""){
				CardInfo=CardNo+"^"+Balance;
			}else{
				CardInfo=CardInfo+Delim+CardNo+"^"+Balance;
			}
		}
	}
	
	return CardInfo;
}
/*
function BBilled_click() {
	
	
	var checkflag=$("#MultiSelect").checkbox("getValue");
	if(checkflag)
	{
	
	$.messager.confirm("确定", "主结算人为："+MainName+"，确定要进行本次结算吗?", function(r) {
		if (r) {
			cashier();
		} else {
			return false;
		}
	});
	}
	
	else
	{
		$.messager.confirm("确定", "确定要进行本次结算吗?", function(r) {
		if (r) {
			cashier();
		} else {
			return false;
		}
		});
		
	}
}
*/
function BBilled_click() {
	

	var checkflag=$("#MultiSelect").checkbox("getValue");
	if(checkflag)
	{
	
	$.messager.confirm("确定", "主结算人为："+MainName+"，确定要进行本次结算吗?", function(r) {
		if (r) {
			cashier();
		} else {
			return false;
		}
	});
	}
	
	else
	{
		var flag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","IsExsistPre",getValueById("GIADM"))
		if(flag=="1"){
			$.messager.confirm("确定", "团体中有未登记的人员不能结算，是否自动登记？", function(r) {
				if (r) {
					var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateGIADMInfo",getValueById("GIADM"))
			        if(ret=="0"){
				        $.messager.alert("提示","登记成功！","success")
				        return false;
			        }
					
				} else {
					return false;
				}
			});
				
				
			}else{
		$.messager.confirm("确定", "确定要进行本次结算吗?", function(r) {
		if (r) {
			
			
			cashier();
		} else {
			return false;
		}
		});
		
	}
	}
	
}

/**
 * 结算程序
 * @return   
 * @Author   wangguoying
 * @DateTime 2020-02-14
 */
function cashier() {
	ybkFlag = 0; //医保卡标记
	var ret = CheckData();
	if (ret.toString() != "") {
		return false;
	}
	if (payedInfo == "") return;
	var HospitalID = session['LOGON.HOSPID'];
	var userId = session['LOGON.USERID'];
	var locId = session['LOGON.CTLOCID'];
	var invNo = getValueById("CurNo");
	var invNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetInvnoNotZM", invNo)
	var invId = getValueById("InvID");
	var peAdmType = getValueById("ADMType");
	var peAdmId = getValueById("GIADM");
	
	var strrowid="" //多人结算adm串
	var rows = $("#CashierTable").datagrid("getChecked");//获取的是数组，多行数据
	for(var i=0;i<rows.length;i++){
				 
		if(strrowid==""){
				strrowid=rows[i].TRowId;
			}else{
				strrowid=strrowid+","+rows[i].TRowId;
			}
	}
	
	
	
	var RemainAccount="NotCPPFlag";
	var amount;
	var CurrRegNo = ""
	var CardAccID = "";
	var myCardTypeValue = "";
	if (CardFlag == "Y") {
		var obj = document.getElementById("CurRegNo"); //得到当前操作的人员对应的登记号
		if (obj) CurrRegNo = obj.value;
		
		myCardTypeValue = getValueById("CardType")
		var m_SelectCardTypeDR="";
		if (myCardTypeValue != "") m_SelectCardTypeDR = myCardTypeValue.split("^")[0];
		if (m_SelectCardTypeDR=="1"){
            var obj=document.getElementById('CardNo');
            var iCardNo=obj.value;
            
            var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,iCardNo,"");
    
        }else{
            var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
        }
		var Ret = myrtn.split("^");
		if (Ret[0] != "0") {
			$.messager.alert("提示", "帐户不正确!", "info")
			return false;
		}
		var flag = Ret[0];
		CardAccID = Ret[7];
		var ReturnStr = tkMakeServerCall("web.DHCPE.DHCPEPAY", "CheckAccount", CardAccID, CurrRegNo);
		if (ReturnStr == "1") {
			$.messager.alert("提示", "请用本人卡账户进行消费!", "info");
			return false;
		}
		var BalanceStr = tkMakeServerCall("web.DHCPE.DHCPEPAY", "GetBalance", CardAccID, CardFee);
		var Balance = BalanceStr.split("^")[0]
		var ReturnStr = BalanceStr.split("^")[1]
		if (parseFloat(Balance) < parseFloat(CardFee)) {
			$.messager.alert("提示", "卡余额不足" + ReturnStr, "info");
			return;
		}
		var RemainAccount=ReturnStr;
		var obj = document.getElementById("CardID");
		if (obj) {
			obj.value = CardAccID
		}
	}

	amount = getValueById("Amount");
	var listFlag = GetListFlag(peAdmType);
	payedInfo = payedInfo + "#" + CardAccID;
	var payedLength = payedInfo.split("^").length;
	var paymodeDescStr = "";
	var paymodeDesc = ""
	for (i = 0; i < payedLength; i++) {
		var paymodeID = payedInfo.split("^")[i].split(",")[0];
		if (paymodeID != "") {
			var paymodeDesc = tkMakeServerCall("web.DHCPE.Cashier", "GetPayModeDesc", paymodeID);
		}
		if (paymodeDescStr == "") {
			var paymodeDescStr = paymodeDesc;
		} else {
			var paymodeDescStr = paymodeDescStr + "^" + paymodeDesc;
		}

	}

	if (paymodeDescStr.indexOf("体检预交金") >= 0) {

		if ((paymodeDescStr.indexOf("现金") >= 0) || (paymodeDescStr.indexOf("支票") >= 0) || (paymodeDescStr.indexOf("银行卡") >= 0)) {
			$.messager.alert("提示", "体检预交金不能与其他方式混合支付!", "info");
			return false;
		}
	}
	if (paymodeDescStr.indexOf("体检代金卡") >= 0) {

		if ((paymodeDescStr.indexOf("现金") >= 0) || (paymodeDescStr.indexOf("支票") >= 0) || (paymodeDescStr.indexOf("银行卡") >= 0)) {
			$.messager.alert("提示", "体检代金卡不能与其他方式混合支付!", "info");
			return false;
		}
	}

   if ((paymodeDescStr.indexOf("体检预交金") >= 0)||(paymodeDescStr.indexOf("体检代金卡") >= 0)){
	
	  var RemainAccount=$("#Remark").val().split("余")[1];
		 
}


	var InsuObj = $("#InsuPay").checkbox('getValue');
	var InsuFlag = "N";
	if (InsuObj) {
		InsuFlag = "Y"
		if (payedLength > 1) {
			$.messager.alert("提示", "医保客人,只能使用一种支付方式!", "info");
			return;
		}
	}
	var InvName = "";
	InvName = getValueById("InvName")
	var invNo = invNo + "^" + InvName

	var OldCardInfo = GetCardInfo(payedInfo);

	var NoPrintInv = "0";
	var obj = $("#NoPrintInv").checkbox('getValue');
	if (obj) NoPrintInv = "1";
	invNo = invNo + "^" + NoPrintInv;
	var AdmReason = "",
		AdmSorce = "";
	if (InsuFlag == "Y") {
		AdmReason = getValueById("AdmReason");
		if (AdmReason == "") {
			$.messager.alert("提示", "请选择收费对应的费别!", "info");
			return false;
		}
		AdmSorce = "";
	}
	invNo = invNo + "^" + AdmReason;
	var TaxpayerNum = "";
	var obj = document.getElementById("TaxpayerNum");
	if (obj) TaxpayerNum = obj.value;
	var invNo = invNo + "^" + TaxpayerNum
	

	//预结算
	ret = tkMakeServerCall("web.DHCPE.Cashier","Cashier", '', '', ids, "", amount, payedInfo, userId, locId, invNo, invId, peAdmType, peAdmId, listFlag, "1", HospitalID,strrowid);
	tmp = ret.split("^");
	var ETPRowID = ""; //计费交易订单ID
	var PEBarCodePayStr = "";
	var InsuID = ""; //医保结算ID
	if (tmp[0] == "") {
		if (InsuFlag == "Y") {
			//var insuRtn = insurancePay(tmp[2], amount, userId, AdmSorce, AdmReason) //DHCPEPayService.js
			var insuRtn = insurancePay(tmp[2], RemainAccount, userId, AdmSorce, AdmReason) //DHCPEPayService.js
			if (insuRtn.ResultCode!= "0") {
				$.messager.alert("提示", insuRtn.ResultMsg, "info");
				return false;
			} else if (insuRtn.ExpStr != "") {
				InsuID = insuRtn.ExpStr.split("^")[0];
				amount = parseFloat(insuRtn.ExpStr.split("^")[1]); //取出医保结算后的自费金额
			}
		}
		//调用第三方支付  一定要先医保再第三方
		var extRtn = extPay(tmp[2], userId, InsuID, AdmSorce, AdmReason);
		if (extRtn.ResultCode != "0") {
			$.messager.alert("提示", extRtn.ResultMsg, "info");
			return false;
		} else {
			ETPRowID = extRtn.ETPRowID;
			PEBarCodePayStr = extRtn.PEBarCodePayStr;
		}
	} else {
		$.messager.alert("提示", "结算失败Err:" + ret, "info"); //预结算失败
		return false;
	}
	//真正的结算
	var ret = tkMakeServerCall("web.DHCPE.Cashier", "RealCashier", tmp[2], userId, invNo);
	tmp = ret.split("^");
	//alert("tmp:"+tmp)
	if (tmp[0] == "") {
		//关联计费交易记录
		if (ETPRowID != "") {
			var ReFlag = RelationService(ETPRowID, tmp[2], "PE")
			if (ReFlag.ResultCode != "0") {
				alert("计费关联失败，请联系信息科！\n" + ReFlag.ResultMsg);
			}
		}
		//更新互联网交易记录
		if (PEBarCodePayStr != "") {
			var relate = tkMakeServerCall("web.DHCPE.CashierEx", "SetRelationPEBarCode", tmp[2], PEBarCodePayStr);
		}
		var CardInfo = GetCardInfo(payedInfo);

		if (tmp[1] != "") {
			if (payedInfo.split(",")[0] == "1") {
				RunSingPaidAmt();
			}
			if (CardAccID != "") {
				var Balance = tkMakeServerCall("web.DHCPE.DHCPEPAY", "getCardAmount", CardAccID);
				$.messager.alert("提示", "卡余额:" + Balance, "info");
			}
			var InvListFlag = listFlag;
			if (tmp[3] == 1) InvListFlag = 0;
			$.messager.alert("提示", "结算成功!", "info");
			setValueById("AmountToPay","");
   			setValueById("Change",0);

			$("#PreAuditPayTable").datagrid('load', {
				ClassName: "web.DHCPE.PreAudit",
				QueryName: "SerchPreAudit",
				ADMType: peAdmType,
				CRMADM: "",
				GIADM: peAdmId,
				AppType: "Fee"
			});
			SetInvNo();

			PrintBill(tmp[1], InvListFlag);
			if (tmp[3] == 1) {
				PrintInvDetail(tmp[2], 1);
			}

		} else {
			$.messager.alert("提示", "支付成功!", "info");
			setValueById("AmountToPay","");
   			setValueById("Change",0);

			$("#PreAuditPayTable").datagrid('load', {
				ClassName: "web.DHCPE.PreAudit",
				QueryName: "SerchPreAudit",
				ADMType: peAdmType,
				CRMADM: "",
				GIADM: peAdmId,
				AppType: "Fee"
			});
			if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJDJK")

			{
				var djkamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetDJAmount", getValueById("No"));

				setValueById("Remark", djkamount)

			}
			if ($("#PayMode").combogrid('grid').datagrid('getSelected').Code == "TJYJJ")

			{
				var yjjamount = tkMakeServerCall("web.DHCPE.PreAudit", "GetAPAmountByIADM", getValueById("ADMType"), getValueById("GIADM"));
				setValueById("Remark", yjjamount)
			}

			PrintInvDetail(tmp[2], 1);
		}


		var DateTime = tkMakeServerCall("web.DHCPE.Cashier", "GetDateTimeStr");

		var Delim = String.fromCharCode(2);
		if (CardInfo != "") {
			var OldOneArr = OldCardInfo.split(Delim);
			var OneArr = CardInfo.split(Delim);
			var CardLength = OneArr.length;
			for (var i = 0; i < CardLength; i++) {
				var OneCardInfo = OneArr[i];
				var OldOneCardInfo = OldOneArr[i];
				var CardInfoArr = OneCardInfo.split("^");
				var OldCardInfoArr = OldOneCardInfo.split("^");
				var CardNo = CardInfoArr[0];
				var Cost = OldCardInfoArr[1] - CardInfoArr[1];
				Cost = Cost.toFixed(2);
				var TxtInfo = "CardNo" + Delim + CardNo;
				TxtInfo = TxtInfo + "^" + "Cost" + Delim + Cost;
				TxtInfo = TxtInfo + "^" + "CurrentBalance" + Delim + CardInfoArr[1];;
				TxtInfo = TxtInfo + "^" + "DateTime" + Delim + DateTime;
				PrintBalance(TxtInfo);
			}


		}


		var PreInvPrtInfo = tmp[1] + "$" + payedInfo + "$" + amount;
		var lnk = location.href;
		var index = lnk.indexOf("&PreInvPrtInfo=");
		if (index > -1) {
			tmp = lnk.substring(index, lnk.length);
			lnk = lnk.substring(0, index);
		}
		lnk = lnk + "&PreInvPrtInfo=" + PreInvPrtInfo;
	} else { //真正的结算失败
		$.messager.alert("提示", "结算失败Err:" + ret, "info");
		return false;
	}
}

// 打印体检支付卡余额
function PrintBalance(TxtInfo)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTBalance");
	//var myobj=document.getElementById("ClsBillPrint");
	var Delim=String.fromCharCode(2);
	var TxtInfoHosp=TxtInfo+"^"+"BottomRemark"+Delim+"(持卡人存根)";
	//DHCP_PrintFun(myobj,TxtInfoHosp,"");
	DHC_PrintByLodop(getLodop(),TxtInfoHosp,"","","");
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(商户存根)";
	//DHCP_PrintFun(myobj,TxtInfoPat,"");
	DHC_PrintByLodop(getLodop(),TxtInfoPat,"","","");
}

function PrintBill(invid,listFlag)
{   
  	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
  	
	var peAdmType=getValueById("ADMType");
	
	var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,invid)
	
	var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,invid,listFlag)
	
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","");
	//var myobj=document.getElementById("ClsBillPrint");
	
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function PrintInvDetail(invid,listFlag)
{
	var peAdmType=getValueById("ADMType");
	var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,invid,"List")
	
	var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,invid,listFlag,"1")
	
	PrintDetail(TxtInfo,ListInfo);
	
}

function PrintDetail(TxtInfo,ListInfo)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText:true}"); 
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	
}

function SetNextPayModeValue()
{
	var Src=window.event.srcElement;
	var CurID=Src.id;
	
	var Sort=Src.id.split("AmountToPay")[1];
	if (Sort==""){
		Sort=1;
	}else{
		Sort=getValueById("Counter");
	}
	var NextID="AmountToPay"+Sort;
	var obj=document.getElementById("Amount");
	var TotalAmt=obj.value;
	var Amt=0
	for (var i=0;i<Sort;i++){
		if (i==0){
			var ExpStr="";
		}else{
			var ExpStr=i;
		}
		var obj=document.getElementById("AmountToPay"+ExpStr);
		if(obj){
			Amt=(+Amt)+(+obj.value);
		}

	}
	var obj=document.getElementById(NextID);
	
	var objpluse=(+TotalAmt).toFixed(2)-(+Amt).toFixed(2);
	objpluse=objpluse.toFixed(2);
	
	if (obj) obj.value=objpluse
	
}
///计算找零
///ischeck:  0,计算合计-应付合计 得出找零并给Change赋值
///			 1,验证是否 计算合计-应付合计=找零,且默认支付方式支付的金额大于找零
function SetChange(ischeck)
{
	SetNextPayModeValue();
	
	var amount,i,obj,suffix;
	var paymode,payamount,no;
	var paymodeids,tmppaymode,hasSpecialPayMode;
	payedInfo="";
	paymodeids="";
	hasSpecialPayMode=0;
	amount=getValueById("Amount");
	CashierMin=CashierMin;
	
	remainfee=0;
	var i;
	var cashierfee=0;
	var changefee=0;
	var totalAmount=0;	
	var amount=getValueById("Amount");
	if ((amount=="")||(amount<=0))
	{
		$.messager.alert("提示","没有要结算的内容!","info");
		return false;
	}
	
	var counter=getValueById("Counter");
	if (counter=="") counter=0
	if (counter=="0")
	{ 
		var AmountValue=getValueById("AmountToPay");
		
		if (AmountValue=="")
	   	{	
		var AmountValue=getValueById("Amount");
		
        setValueById("AmountToPay",AmountValue);
       	}
	}
	counter=parseInt(counter);
	
	CardFlag="N"  
	CardFee=0
	
	for (i=0;i<=counter;i++)
	{
		
		if (i==0)
		{ suffix="";}
		else
		{ suffix=i;}
		
		obj=document.getElementById("PayMode"+suffix)
		if (obj)
		{
			paymode=$("#PayMode"+suffix).combogrid("getValue");
			if (($("#PayMode"+suffix).combogrid("getValue")==undefined)||($("#PayMode"+suffix).combogrid("getValue")=="")){var paymode="";}
			if(paymode==""){
				
				return false;
				}

			
		    
			var AmountValue=$("#AmountToPay").val();
			
			if (AmountValue=="")
			{
				
			var amount=getValueById("Amount");
		
			$("#AmountToPay").val(amount);
			}
			
			tmppaymode=","+paymode+",";
			
			payamount=$("#AmountToPay"+suffix).val();  
			
			paymodecode = $("#PayMode"+suffix).combogrid('grid').datagrid('getSelected').Code;
			
			if (paymodeids.indexOf(tmppaymode)>-1)
			{
				$.messager.alert("提示","同一种支付方式只能有一条!","info");
				return false;
			}
			else
			{
				if (paymodeids=="") paymodeids=",";
				paymodeids=paymodeids+paymode+",";
			}
			
			
			if (specialpaymodes.indexOf(tmppaymode)>-1)
			{
				hasSpecialPayMode=1;
			}
			
			payamount=$("#AmountToPay"+suffix).val();
			
			no=$("#No"+suffix).val();
			
			if (paymode=="")
			{
				websys_setfocus("PayMode"+suffix)
				$.messager.alert("提示","请选择支付方式!","info");
				return false;
			}
			if (getValueById("PayMode"+suffix)=="")
			{
				websys_setfocus("PayMode"+suffix)
				$.messager.alert("提示","请选择支付方式!","info");
				return false;
			}
			if ((payamount=="")||(isNaN(payamount)==true)) 
			{
				//websys_setfocus("AmountToPay"+suffix)
				
				setValueById("Change",0);
				$.messager.alert("提示","请输入正确的支付金额!","info");
				return false;
			}		
			if (paymodecode=="CPP")     
			{  
				CardFlag="Y"
				CardFee=payamount 
			}	
				
			if (parseFloat(payamount)<=0)
			{
				//websys_setfocus("AmountToPay"+suffix)
				setValueById("Change",0);
				$.messager.alert("提示","请输入正确的支付金额!","info");
				return false;			
			}
			
			if (defaultpaymode==paymode)
			{
				cashierfee=parseFloat(payamount);				
				totalAmount=totalAmount+parseFloat(payamount);	
				var DefaultPaymodeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",defaultpaymode);
				
				if(DefaultPaymodeDesc=="支票"){cashierfee=cashierfee+","+no}

			}
			else
			{
				if (""!=payedInfo) payedInfo=payedInfo+"^";
				totalAmount=totalAmount+parseFloat(payamount);
				payedInfo=payedInfo+paymode+","+payamount+","+no;
			}
		}		
	}
	if (parseFloat(totalAmount)=="") changefee=parseFloat(cashierfee)+parseFloat(totalAmount)-parseFloat(amount);
	changefee=changefee.toFixed(2);
	
	
	sswrAmount=getValueById("sswrAmount");
	
	if (paymode=="1")
	{
		changefee=parseFloat(totalAmount)-parseFloat(amount); 
	}
	else{
		
		changefee=parseFloat(totalAmount)-parseFloat(amount);
	}
	
	changefee=changefee.toFixed(2);
	
	setValueById("Change",changefee);
	
	
	if (1==ischeck)
	{
		if (parseFloat(changefee)<0)
		{
			var Insurance=getValueById("GetInsurance");
			if (Insurance=="")
			{
				$.messager.alert("提示","金额不足!","info");
				return false;
			}
			else
			{
				if (Insurance!="Y")
				{
					if (!confirm("剩余金额"+(-changefee)+"使用保险支付?"))
					{
						
							$.messager.alert("提示","金额不足!","info");
							return false;
					}
					else
					{
						Insurance="Y"
						if (parseFloat(cashierfee)>0)
						{
							if (""!=payedInfo) payedInfo=payedInfo+"^";
							payedInfo=payedInfo+defaultpaymode+","+cashierfee+",";
						}
					}
				}
				else
				{
					if (parseFloat(cashierfee)>0)
					{
						if (""!=payedInfo) payedInfo=payedInfo+"^";
						payedInfo=payedInfo+defaultpaymode+","+cashierfee+",";
					}
				}	
			}
			
		}
		else if (parseFloat(changefee)>0)
		{
			if (parseFloat(cashierfee)>0)
			{
				if (parseFloat(cashierfee)<=parseFloat(changefee)) 
				{	
					
				$.messager.alert("提示","请输入正确的支付金额!","info");
				return false;}
				cashierfee=parseFloat(cashierfee)-parseFloat(changefee);
				if (""!=payedInfo) payedInfo=payedInfo+"^";
				payedInfo=payedInfo+defaultpaymode+","+cashierfee+",";
			}
			else
			{
				if (hasSpecialPayMode==1)
				{
					/*
					var href="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPayMode&PayAmount="+changefee+"&CashierInfo="+defaultpaymode+"^"+CashierMin;
					var ret=showModalDialog(href,'','',"dialogHeight:200px;dialogWidth:300px;center:yes;help:no;resizable:no;status:no;")
					if (!ret||""==ret)
					{
						payedInfo=""; 
						return "";
					}
					if (""!=payedInfo) payedInfo=payedInfo+"^";
					payedInfo=payedInfo+ret;
					*/
				}
				else
				{
					$.messager.alert("提示","该支付方式不能找零!","info");
					
					return false;
				}
			}
		}
		else
		{
			if (parseFloat(cashierfee)>0)
			{
				if (""!=payedInfo) payedInfo=payedInfo+"^";
				payedInfo=payedInfo+defaultpaymode+","+cashierfee+",";
			}
		}
		
		return "";
	}	
}



function InitBillInfo()
{
	obj=document.getElementById("CurNo");
	if (obj) obj.readOnly=true;

	obj=document.getElementById("Amount");
	if (obj) obj.readOnly=true;
	obj=document.getElementById("Change");
	if (obj) obj.readOnly=true;
	obj=document.getElementById("sswrAmount");
	if (obj) obj.readOnly=true;
	
	SetInvNo();
}
function SetInvNo()
{
	var userId=session['LOGON.USERID'];

    
    ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
   
    var No=""
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]==""))
    {	
		$.messager.alert("提示","没有设置正确的发票号","info"); 
	}
	else{
     if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
	}
	
	$("#CurNo").val(No);
	$("#InvID").val(invNo[1]);
    
}
function AddPayMode()
{
	//Amount_Change();
	var counter=getValueById("Counter");
	if (counter=="") counter=0; 
	counter=parseInt(counter)+1;
	
	AddPayModeHtml="<tr id='PayModeTR"+counter+"'><td><div><select class='hisui-combogrid' type='text' Id='PayMode"+counter+"' name='PayMode"+counter+"' style='width:110px;' editable='false'></select></div></td>"
         +
         "<td><div><input class='hisui-numberbox textbox' data-options='precision:2' Id='AmountToPay"+counter+"' style='width:93px;'/></div></td>"
         +
         "<td><div><input class='hisui-validatebox textbox' Id='No"+counter+"' style='width:100px;'/></div></td>"
         + 
         "<td><div><input class='hisui-validatebox textbox' Id='Remark"+counter+"' style='width:100px;'/></div></td>"
         + 
         "<td><a href='#' onclick='DelPayMode("+counter+")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0 /></a></td>"
         +
         "</tr>"
	
	$("#PayModeTable").append(AddPayModeHtml);
	setValueById("Counter",counter);
	
	
	$("#No"+counter).keypress(function (e) {
            if (e.which == 13) {
                    if($("#PayMode"+counter).combogrid('grid').datagrid('getSelected').Code=="TJDJK")
			
					{
							var djkamount=tkMakeServerCall("web.DHCPE.PreAudit","GetDJAmount",getValueById("No"+counter));	
				
							setValueById("Remark"+counter,djkamount)
				
					}
                }
		});
	
	
	$("#AmountToPay"+counter).blur(function(){
  		Amount_Change();
	}); 
	
	
	$HUI.combogrid("#PayMode"+counter,{
		panelWidth:130,
		url:$URL+"?ClassName=web.DHCPE.Cashier&QueryName=GetCashierMode",
		mode:'remote',
		delay:200,
		idField:'Hidden',
		textField:'Description',
		onSelect: function (rowIndex, rowData){
			if(hasExistPayMode("PayMode"+counter,rowData.Code)){
				$("#PayMode"+counter).combogrid("setValue","");
				$.messager.alert("提示","【"+rowData.Description+"】已存在！","info");
				return ;
			}
			if(rowData.Code=="TJYJJ")
			
			{
				var yjjamount=tkMakeServerCall("web.DHCPE.PreAudit","GetAPAmountByIADM",getValueById("ADMType"),getValueById("GIADM"));	
				
				setValueById("Remark"+counter,yjjamount)
				
			}else{
					setValueById("Remark"+counter,"")
					setValueById("No"+counter,"")

			}
			
			
			},
		columns:[[
			{field:'Hidden',hidden:true},
			{field:'Code',title:'编码',width:80,hidden:true},
			{field:'Description',title:'名称',width:110}
		]]
		});
	
	
}

/**
 * [当前支付方式是否已存在]
 * @param    {[string]}    elementId   [当前元素ID]
 * @param    {[string]}    payModeCode [支付方式代码]
 * @return   {Boolean}           
 * @Author   wangguoying
 * @DateTime 2020-01-17
 */
function hasExistPayMode(elementId,payModeCode){
	var paymodeCodes=",";
	var counter=getValueById("Counter");
	if (counter=="") counter=0
	if (counter=="0")
	{ 
		return false;
	}
	counter=parseInt(counter);
	for (i=0;i<=counter;i++)
	{
		if (i==0)
		{ 
			suffix="";
		}
		else
		{ 
			suffix=i;
		}
		if(("PayMode"+suffix)==elementId) continue;		
		obj=document.getElementById("PayMode"+suffix)
		if (obj)
		{
			paymode=$("#PayMode"+suffix).combogrid("getValue");
			if (($("#PayMode"+suffix).combogrid("getValue")==undefined)||($("#PayMode"+suffix).combogrid("getValue")=="")){var paymode="";}
			if(paymode==""){				
				continue;
			}			
			paymodecode = $("#PayMode"+suffix).combogrid('grid').datagrid('getSelected').Code;
			paymodeCodes=paymodeCodes+paymodecode+",";
		}
	}
	if(paymodeCodes.indexOf(","+payModeCode+",")>-1) return true;
	return false;
}
function DelPayMode(rowIndex)
{
	$("#PayModeTR"+rowIndex).remove(); 
	SetChange(0);
	
}

function LoadCard()
{
	var HospID=session['LOGON.HOSPID']
	$.m({
			ClassName:"web.UDHCOPOtherLB",
			MethodName:"ReadCardTypeDefineListBroker",
			JSFunName:"GetCardTypeToHUIJson",
			ListName:"",
			SessionStr:"^^^^"+HospID
		},function(val){
			
			var ComboJson=JSON.parse(val); 
			
			$HUI.combobox('#CardType',{
				data:ComboJson,
				valueField:'id',    
				textField:'text',
			onSelect:function(record){
				CardTypeKeydownHandler();
			}
		});
		CardTypeKeydownHandler();
		});
	
	
}
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}

function CardTypeKeydownHandler(){
	var SelValue=$HUI.combobox("#CardType").getValue();
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	
	if (myary[16]=="Handle"){;
		$("#CardNo").attr("disabled",false);
		DisableBtn("ReadCard",true);
		$("#CardNo").focus();
	}else{
		$("#CardNo").attr("disabled",true);
		DisableBtn("ReadCard",false);
		$("#ReadCard").focus();
		
		m_CCMRowID=GetCardEqRowIdA();
		var myobj=document.getElementById("CardNo");
		
		if (myobj){myobj.readOnly = false;} 
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled = false;
		}
		DHCWeb_setfocus("ReadCard");
	}
}
function GetCardEqRowIdA(){
	var CardEqRowId="";
	var CardTypeValue=$HUI.combobox("#CardType").getValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=$HUI.combobox("#CardType").getValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}
function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=$HUI.combobox("#CardType").getValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}

function FormatCardNo(){
	var CardNo=DHCC_GetElementData("CardNo");
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo;
}


function ReadCardClickHandler(){
	var SelValue=$HUI.combobox("#CardType").getValue();
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	
	var myary=SelValue.split("^");
	var myEquipDR=myary[14];
	
	var rtn = DHCACC_GetAccInfoHISUI(myCardTypeDR, myEquipDR);
	
	
	
	var ReturnArr=rtn.split("^");
	
	if (ReturnArr[0]=="-200")
	{
		 var cardvalue=rtn.split("^")[1];
		 return false;
	}
	$('#RegNo').val(ReturnArr[5]);
	if(PreCashier!=1)
	{
		RegNoOnChange();
	}
	$('#CardNo').val(ReturnArr[1]);
	
	
	
} 
function DHCACC_GetAccInfoHISUI(CardTypeDR, EquipDR)
{
	
	//var myrtn =DHCACC_ReadMagCard(EquipDR);
	
	var myrtn =DHCACC_ReadMagCard(EquipDR,"R", "23");
	
	var rtn=0;
	var myLeftM=0;
	var myAccRowID="";
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	var myGetCardTypeDR="";
	var mySCTTip="";
	var myary=myrtn.split("^");
	var encmeth="";
	if (myary[0]==0){
		rtn=myary[0];
		myCardNo=myary[1];
		myCheckNo=myary[2];
	
			var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
			var myrtn=tkMakeServerCall("web.UDHCAccManageCLSIF","getaccinfofromcardno",myCardNo,myCheckNo, myExpStr);
			
			var myary=myrtn.split("^");
			if(myary[0]==0)
			{
			rtn=myary[0];
			
			
			var myAccRowID=myary[1];
			var myLeftM=myary[3];
			var myPAPMI=myary[7];
			var myPAPMNo=myary[8];
			var myAccType=myary[10];
			var myAccGrpLeftM=myary[17]
			if (myary.length>12){
				myGetCardTypeDR=myary[12];
			}
			if (myary.length>13){
				mySCTTip = myary[13];
			}
			}
		
	}else{
		rtn=myary[0];
		
	}
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID+"^"+myGetCardTypeDR+"^"+mySCTTip+"^"+myAccGrpLeftM;
}


function Find_click()
{
	
	$("#CashierTable").datagrid('load',{ClassName:"web.DHCPE.DHCPEIAdm",QueryName:"CashierForHISUI",PAPMINo:getValueById("RegNo"),IADMName:getValueById("Name"),AuditDateBegin:getValueById("StartDate"),AuditDateEnd:getValueById("EndDate")}); 
	$("#PreAuditPayTable").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:"",CRMADM:"",GIADM:"",AppType:"Fee"});
	$("#FeeListTable").datagrid('load',{ClassName:"web.DHCPE.ItemFeeList",QueryName:"FindItemFeeList",PreAudits:""});
	setValueById("ADMType","");
	setValueById("GIADM","");
    setValueById("CurRegNo","");
				
				
				var counter=getValueById("Counter");
				if (counter=="") counter=0; 
				
				for (i=0;i<=counter;i++)
				{
					$("#PayModeTR"+i).remove(); 
					
				}
				setValueById("Counter",0);
				
				setValueById("AmountToPay","");
				setValueById("No","");
				setValueById("Remark","");
				setValueById("InvName","");
				setValueById("TaxpayerNum","");
				setValueById("Rounding","");
				setValueById("RoundRemark","");
				setValueById("Change",0);
				setValueById("Amount","");
				SetInvNo();
				intiRoundingFee();		
				if($("#PayMode").combogrid('grid').datagrid('getSelected').Code=="TJYJJ")
				{
					var yjjamount=tkMakeServerCall("web.DHCPE.PreAudit","GetAPAmountByIADM",getValueById("ADMType"),getValueById("GIADM"));	
				
					setValueById("Remark",yjjamount)
				
				}	
	
}





function SplitItem(rowid)
{
	/*
	var str = "dhcpesplitaudit.csp?AuditID="+rowid+"&SplitType=person";
	websys_lu(str,false,'width=1200,height=600,hisui=true,title=收费记录拆分')
	*/
	var ADMType=$("#ADMType").val();
    var GIADM=$("#GIADM").val();
	 if(ADMType=="I"){var lnk="dhcpesplitaudit.hiui.csp?AuditID="+rowid+"&SplitType=item"+"&ADMType="+ADMType+"&GIADM="+GIADM;	}	
	if(ADMType=="G"){var lnk="dhcpesplitaudit.hiui.csp?AuditID="+rowid+"&SplitType=person"+"&ADMType="+ADMType+"&GIADM="+GIADM;	}	
	var wwidth=1400;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes, '
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin) 

	return true;

	
}


function GetSelectedIds()
{
	
	
	var ids=""
	var selectrow = $("#PreAuditPayTable").datagrid("getChecked");//获取的是数组，多行数据
	
	for(var i=0;i<selectrow.length;i++){
		if (ids==""){
				ids=selectrow[i].TRowId
			}else{
				ids=ids+","+selectrow[i].TRowId
			}

	}
	
	
	return ids;
}


function CardNoOnChange()
{
	
	CardNoChangeAppHISUI("RegNo","CardNo","RegNoOnChange()","Clear_click()","0");
	
}
function CardNoChangeAppHISUI(RegNoElement,CardElement,AppFunction,AppFunctionClear,ClearFlag)
{
	
	var obj;
	var CardNo="",SelectCardTypeRowID="";
	obj=document.getElementById(CardElement);
	if (obj) CardNo=obj.value;
	if (CardNo=="") return;
	if (ClearFlag=="1") eval(AppFunctionClear);
	obj.value=CardNo;
	
	var SelValue=$HUI.combobox("#CardType").getValue();
	if (SelValue==""){return;}
	var myary=SelValue.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR==""){return;}
	SelectCardTypeRowID=myCardTypeDR;
	
	CardNo=CardNo+"$"+SelectCardTypeRowID;
	
	RegNo=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetRelate",CardNo,"C");
	
	if (RegNo=="") return;
	obj=document.getElementById(RegNoElement);
	if (obj)
	{
		obj.value=RegNo;
		eval(AppFunction);
	}
}



function RegNoOnChange()
{
	
	if(PreCashier!=1)
	{
		Find_click();
	}
	
	var CardNo=getValueById("CardNo")
	CardNo=RegNoMask(CardNo)
	setValueById("CardNo",CardNo)
}

function Clear_click()
{
	
}

function Calculate()
{
	
	var amount;
	
	ids="";
	amount=0;

    
    ids=GetSelectedIds();
    try{
	    if (ids!="") amount=tkMakeServerCall("web.DHCPE.Cashier","GetAuditsAmount",'','',ids);
    }
	catch(e)
	{	alert(e.message);}
    return amount;
}


function intiRoundingFee(){
		var peAdmType=$("#ADMType").val();
		if(peAdmType=="") {var peAdmType=TransADMType;}
		var roundfeemode=tkMakeServerCall("web.DHCPE.Cashier","GetRoundingFeeMode",session['LOGON.USERID']) 
		if ((roundfeemode==0)||((roundfeemode==1)&&(peAdmType!="I"))||((roundfeemode==2)&&(peAdmType=="I")))
			{ 
				$("#BAddRound").linkbutton('disable');
				$("#BDeleteRoundItem").linkbutton('disable'); 
					
			}else{
				$("#BAddRound").linkbutton('enable');
				$("#BDeleteRoundItem").linkbutton('enable');
					
		}
				
}


function InitCashierTableGrid()
{
	
	$HUI.datagrid("#CashierTable",{
		url:$URL,
		fit : true,
		border : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		singleSelect: true,
		checkOnSelect: true,
		selectOnCheck: true,
		pageSize: 20,
		pageList : [20,100,200],
		toolbar:[],
		queryParams:{
			ClassName:"web.DHCPE.DHCPEIAdm",
			QueryName:"CashierForHISUI",
			PAPMINo:getValueById("RegNo"),
			IADMName:getValueById("Name"),
			AuditDateBegin:getValueById("StartDate"),
			AuditDateEnd:getValueById("EndDate")
		},
		columns:[[
	
		    {field:'TRowId',checkbox:true},
			{field:'TNewHPNo',title:'体检号',width:'120'},
			{field:'TPapmiNo',title:'登记号',width:'120'},
			{field:'TName',title:'姓名',width:'120'},
			{field:'TRegDate',title:'到达(登记)日期'},
			{field:'TStatus',title:'状态'},
			{field:'TAsCharged',title:'视同收费'},
			{field:'TGAdmDesc',title:'团体名称',width:'150'},
			{field:'TTeamDesc',title:'分组名称',width:'100'},
			{field:'TConfirmStatus',title:'需要确认加项'},
			{field:'TAdmType',hidden:true}
		]],
		
		
		onCheck: function (rowIndex, rowData) {
			
			 var strrowid="",strtype=""
			 var rows = $("#CashierTable").datagrid("getChecked");//获取的是数组，多行数据
			 for(var i=0;i<rows.length;i++){
				 
				 if(strrowid==""){
					 	strtype=rows[i].TAdmType;
						strrowid=rows[i].TRowId;
						setValueById("CurRegNo",rows[i].TPapmiNo);
						setValueById("GIADM",rows[i].TRowId);
						MainName=rows[i].TName;
				 }else{
						strrowid=strrowid+","+rows[i].TRowId;
						strtype=strtype+","+rows[i].TAdmType;
				}

				 
				 
			 }
			 
			 if((strtype.indexOf("G")!=-1)&&(strtype.indexOf("I")!=-1))
			 {
				 $.messager.alert("提示","个人和团体不能一起结算！","info");
				 $("#CashierTable").datagrid('unselectRow',rowIndex);
				 
				 
			 }
			 else
			 {
			 	$("#PreAuditPayTable").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:rowData.TAdmType,CRMADM:"",GIADM:strrowid,AppType:"Fee"});
			 
				$("#FeeListTable").datagrid('load',{ClassName:"web.DHCPE.ItemFeeList",QueryName:"FindItemFeeList",PreAudits:""});
			
				setValueById("ADMType",rowData.TAdmType);
 
				
				
				var counter=getValueById("Counter");
				if (counter=="") counter=0; 
				
				for (i=0;i<=counter;i++)
				{
					$("#PayModeTR"+i).remove(); 
					
				}
				setValueById("Counter",0);
				
				setValueById("AmountToPay","");
				setValueById("No","");
				setValueById("Remark","");
				setValueById("InvName","");
				setValueById("TaxpayerNum","");
				setValueById("Rounding","");
				setValueById("RoundRemark","");
				setValueById("Change",0);
				setValueById("Amount","");
				SetInvNo();
				intiRoundingFee();		
				if($("#PayMode").combogrid('grid').datagrid('getSelected').Code=="TJYJJ")
				{
					var yjjamount=tkMakeServerCall("web.DHCPE.PreAudit","GetAPAmountByIADM",getValueById("ADMType"),getValueById("GIADM"));	
				
					setValueById("Remark",yjjamount)
				
				}
			 }
		},
		
		onUncheck: function (rowIndex, rowData) {
			
			 var strrowid=""
			 var rows = $("#CashierTable").datagrid("getChecked");//获取的是数组，多行数据
			 for(var i=0;i<rows.length;i++){
				 
				 if(strrowid==""){
						strrowid=rows[i].TRowId;
						setValueById("CurRegNo",rows[i].TPapmiNo);
						setValueById("GIADM",rows[i].TRowId);
						setValueById("ADMType",rows[i].TAdmType);
						MainName=rows[i].TName;
				 }else{
						strrowid=strrowid+","+rows[i].TRowId;
				}
				var RealType=rows[i].TAdmType;
				 
				 
			 }
				
			 	$("#PreAuditPayTable").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:RealType,CRMADM:"",GIADM:strrowid,AppType:"Fee"});
			 	
			 	if(strrowid=="")
			 	{
				$("#FeeListTable").datagrid('load',{ClassName:"web.DHCPE.ItemFeeList",QueryName:"FindItemFeeList",PreAudits:""});
			
				setValueById("ADMType","");
 
				setValueById("GIADM","");
				
				var counter=getValueById("Counter");
				if (counter=="") counter=0; 
				
				for (i=0;i<=counter;i++)
				{
					$("#PayModeTR"+i).remove(); 
					
				}
				setValueById("Counter",0);
				
				setValueById("AmountToPay","");
				setValueById("No","");
				setValueById("Remark","");
				setValueById("InvName","");
				setValueById("TaxpayerNum","");
				setValueById("Rounding","");
				setValueById("RoundRemark","");
				setValueById("Change",0);
				setValueById("Amount","");
				SetInvNo();
				intiRoundingFee();		
				if($("#PayMode").combogrid('grid').datagrid('getSelected').Code=="TJYJJ")
				{
					var yjjamount=tkMakeServerCall("web.DHCPE.PreAudit","GetAPAmountByIADM",getValueById("ADMType"),getValueById("GIADM"));	
				
					setValueById("Remark",yjjamount)
				
				}
			 	}
				
		},
		onDblClickRow: function(rowIndex, rowData){ 
			var checkflag=$("#MultiSelect").checkbox("getValue");
			if(checkflag)
			{
			setValueById("GIADM",rowData.TRowId);
			setValueById("CurRegNo",rowData.TPapmiNo);
			MainName=rowData.TName;
			$.messager.alert("提示","设置主结算人为："+rowData.TName,"info");
			}
		},
		
		onLoadSuccess: function(rowData){
			
			
		$('#CashierTable').datagrid('clearSelections'); //一定要加上这一句，要不然datagrid会记住之前的选中
	    $("#CashierTable").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
		}
			
	});
	
	$HUI.datagrid("#PreAuditPayTable",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PreAudit",
			QueryName:"SerchPreAudit",
			ADMType:"", 
			CRMADM:"", 
			GIADM:"", 
			AppType:""
		},
		onCheck:function(rowIndex,rowData){
			
			
			
			if (rowData.TChargedStatus=="已收费") {
		            //设置datagrid中某行不能被选中
					$('#PreAuditPayTable').datagrid('unselectRow', rowIndex);
				}
			
			
			var amount = Calculate();
			
			var sswrAmount=parseFloat(amount).toFixed(1);
			
	
			setValueById("Amount",amount);

			setValueById("sswrAmount",sswrAmount);
			
			
			
			var ids=GetSelectedIds();
			
			$("#FeeListTable").datagrid('load',{ClassName:"web.DHCPE.ItemFeeList",QueryName:"FindItemFeeList",PreAudits:ids});
				
			
	
		},
		onUncheck:function(rowIndex,rowData){
			
			var amount = Calculate();
			
			var sswrAmount=parseFloat(amount).toFixed(1);
			
	
			setValueById("Amount",amount);

			setValueById("sswrAmount",sswrAmount);	
			
			
			var strrowid=""
			 var rows = $("#PreAuditPayTable").datagrid("getChecked");//获取的是数组，多行数据
			 for(var i=0;i<rows.length;i++){
				 
				 if(strrowid==""){
						strrowid=rows[i].TRowId;
				 }else{
						strrowid=strrowid+","+rows[i].TRowId;
				}

				 
				 
			 }
			
			
			$("#FeeListTable").datagrid('load',{ClassName:"web.DHCPE.ItemFeeList",QueryName:"FindItemFeeList",PreAudits:strrowid});
			
			
			
			
		},
		
		//加载完毕后获取所有的checkbox遍历
		onLoadSuccess: function(rowData){
			
			
		$('#PreAuditPayTable').datagrid('clearSelections'); //一定要加上这一句，要不然datagrid会记住之前的选中
	    $("#PreAuditPayTable").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
	    var objtbl = $("#PreAuditPayTable").datagrid('getRows');
		if (rowData) { 
		   
		  //遍历datagrid的行            
		 $.each(rowData.rows, function (index) {
			    
			 	if(objtbl[index].TChargedStatus=="已收费"){	 
			  		$("#PreAuditPayTable.datagrid-row[datagrid-row-index="+index+"] input[type='checkbox']").attr('disabled','disabled');
				 } else{ 
				 			
				 	$('#PreAuditPayTable').datagrid('checkRow',index);
				 		
			 	}
		 });
		 
		 
		 }		
    		
		},
		toolbar:[],
		columns:[[
			{field:'TDiscountedAmount',checkbox:true},
		    {field:'TRowId',hidden: true},
			{field:'TRebate',title:'折扣率',width:'90'},
			{field:'TAccountAmount',title:'应收金额',align:'right',width:'90'},
			{field:'TFactAmount',title:'最终金额',align:'right',width:'90'},
			{field:'TAuditedStatus',title:'审核状态',width:'90'},
			{field:'TChargedStatus',title:'收费状态'},
			{field:'TPrivilegeMode',title:'优惠形式'},
			{field:'TType',title:'类型'},
			{field:'TSplit',title:'拆分',align:'center',
				formatter:function(value,row,index){
					return "<a href='#' onclick='SplitItem(\""+row.TRowId+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/transfer.png' border=0/>\
					</a>";
			}},
			{field:'TRemark',title:'备注',width:'120'},
			{field:'TTeamName',title:'分组名称',width:'180'}
		]]
			
	});
	
	
	$HUI.datagrid("#FeeListTable",{
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
		toolbar:[],
		queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			PreAudits:""
		},
		columns:[[
	
		    {field:'FactAmount',title:'最终金额',align:'right'},
			{field:'ItemName',title:'项目名称'},
			{field:'FeeTypeDesc',title:'类别'},
			{field:'OrdStatusDesc',title:'执行状态'},
			{field:'PatName',title:'姓名'}
		]],
		onSelect: function (rowIndex, rowData) {
			   
				
					
		}
		
			
	});
	
	
	var PayModeObj = $HUI.combogrid("#PayMode",{
		panelWidth:130,
		url:$URL+"?ClassName=web.DHCPE.Cashier&QueryName=GetCashierMode",
		mode:'remote',
		delay:200,
		idField:'Hidden',
		textField:'Description',
		onSelect: function (rowIndex, rowData){
			if(rowData.Code=="TJYJJ")
			
			{
				var yjjamount=tkMakeServerCall("web.DHCPE.PreAudit","GetAPAmountByIADM",getValueById("ADMType"),getValueById("GIADM"));	
				
				setValueById("Remark",yjjamount)
				
			}
			
			
			
			
			},
		columns:[[
			{field:'Hidden',hidden:true},
			{field:'Code',title:'编码',width:80,hidden:true},
			{field:'Description',title:'名称',width:110}
		]]
		});
	
		var RoundTypeObj = $HUI.combobox("#RoundType",{
		valueField:'id',textField:'text',selectOnNavigation:false,panelHeight:"auto",editable:false,
		
		data:[
			{id:'1',text:'定额卡',"selected":true},{id:'2',text:'西院区缴费'},{id:'3',text:'换套餐补费'},{id:'4',text:'其他'}
		]
	
		});
		
		var AdmReasonObj = $HUI.combobox("#AdmReason",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=OutAdmReason&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onSelect:function(record){
			$('#YLLB').combobox('setValue',"");
			$('#YLLB').combobox('reload');
			
		}
		});
		var YLLBObj = $HUI.combobox("#YLLB",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=OutYLLB&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		mode:'remote',
		onBeforeLoad:function(param){
			
			var AdmReason=$("#AdmReason").combobox("getValue");
			param.AdmReason = AdmReason;
			param.HospID=session['LOGON.HOSPID'];
		}
		});
	
}

//名称	dhcperefund.hisui.js
//功能	退费	
//创建	2019.04.26
//创建人  yupeng
var OnePayMode=0;
var paymodecount=0;
var CardFlag="";
var newInvAmount=0;
$(function(){
	$("#BFind").css({"width":"110px"});
	$("#BPrintProve").css({"width":"110px"});
	
	$("#BPrintList").css({"width":"120px"});
	$("#BGREPrint").css({"width":"120px"});
	
	InitCombobox();
	InButtonInfoNew();
	InitInvListQueryTabDataGrid();
	
	obj =document.getElementById("BRefund");
	if(obj){obj.style.display="none";}
	obj =document.getElementById("BAllRefund");
	if(obj){obj.style.display="none";}
	
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
    $("#BPrintDanZ").click(function() {	
		BPrintDanZ();	
        });  
        
    $("#RepeatPrint").click(function() {	
		RepeatPrint_Click();		
        });    
        
    $("#BRefund").click(function() {	
		BRefund_Click();		
        });    
    $("#BAllRefund").click(function() {	
		BAllRefund_Click();		
        });    
     
     //读卡
	$("#BReadCard").click(function() {	
		ReadCardClickHandle();		
        });
        
    $("#BGREPrint").click(function() {	
		BGREPrint_Click();		
        });    
      
     
    //打印收据证明
	$("#BPrintProve").click(function() {	
		BPrintProve_click();		
        });
        
    //打印清单
	$("#BPrintList").click(function() {	
		BPrintList_click();		
        });
  
   $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        }); 
          
   $("#InvNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });  
         
   $("#PatName").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();	
			}
			
        });   
   
   $("#CardNo").keydown(function(e) {
			
			if(e.keyCode==13){
				CardNoKeydownHandler();
			}
			
        }); 
	
   $('#CardNo').change(CardNoChange);
     
	
        
})

function RepeatPrint_Click()
{
	Refund(1,0);
	return;
}


function BAllRefund_Click()
{
	if($("#BAllRefund").linkbutton('options').disabled==true){return;}
	Refund(1,1);
	return;
}


function BRefund_Click()
{
	if($("#BRefund").linkbutton('options').disabled==true){return;}
	Refund(0,0);
	return;
}
function BGREPrint_Click()
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
	var obj=document.getElementById('RPFRowId');
	
	if (obj && ""!=obj.value) {
		var PEINVDR=obj.value;
		var peAdmType=tkMakeServerCall("web.DHCPE.Cashier","GetAdmType",PEINVDR)
		var obj=document.getElementById("RPFInvNo");
			if(obj && ""==obj.value){
			$.messager.alert("提示","发票为退费的负记录,不能打印!","info");
		     return ;
			}
	
	}else
    		{ 
    			$.messager.alert("提示","请选择要重打发票的记录!","info"); 
	    		return ;
	    	}
    
		var listFlag=GetListFlag(peAdmType);
		
		
		var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,PEINVDR)
		
		var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,PEINVDR,listFlag)
		//alert(ListInfo)
		DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText: true}");
		//var myobj=document.getElementById("ClsBillPrint");
		//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

var idTmr="";
function BPrintDanZ()
{
	var invPrtId=getValueById("RPFRowId");
	if (invPrtId==""){
		$.messager.alert("提示","没有退费发票!","info");
		return false;
	}
	var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetRefundInfo",invPrtId)
	if (info==""){
		$.messager.alert("提示","还没有做退费申请!","info");
		return false;
	}
	var char_1=String.fromCharCode(1);
	var char_2=String.fromCharCode(2);
	var infoArr=info.split(char_1);
	var patientInfo=infoArr[0];
	var patientArr=patientInfo.split("^");
	var orditemInfo=infoArr[1];
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEDropItemRequest.xls';
	
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
	xlsheet.cells(1,1).Value=HosName;

	xlsheet.cells(4,2).Value=patientArr[0];
	xlsheet.cells(4,5).Value=patientArr[1];
	xlsheet.cells(5,2).Value=patientArr[2];
	xlsheet.cells(6,2).Value=patientArr[3];
	xlsheet.cells(6,6).Value=patientArr[4];
	var orditemArr=orditemInfo.split(char_2);
	var row=9;
	var i=orditemArr.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++){
		var oneOrdItem=orditemArr[iLLoop];
		var oneOrdArr=oneOrdItem.split("^");
		xlsheet.cells(row+iLLoop,1).Value=oneOrdArr[0];
		xlsheet.cells(row+iLLoop,5).Value=oneOrdArr[1];
	}
	
	
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 

	
}
function Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}
function GetPayModeInfo(IsAllRefund)
{
	var i,amount,backamount,backtotal,remainamount;
	var total;
	var paymodeinfos="";
	CanChangePayModes=","+CanChangePayModes+",";
	backtotal=0;
	newInvAmount=0
	var ErrInfo="";
	var peAdmId=getValueById("GIADM");

	for (i=0;i<paymodecount;i++)
	{
		amount=$("#PayedAmount"+i).val()
		backamount=$("#RefundAmount"+i).val()
		
		if (isNaN(backamount)==true) 
		{
			$.messager.alert("提示","请输入有效的金额!","info");
			return -1;
		}		
		if (backamount=="") backamount=0;
		var InvPrtId=getValueById("RPFRowId");
		var ssr=tkMakeServerCall("web.DHCPE.Cashier","GetssrAmountByInv",InvPrtId); //获取发票的舍入金额
		remainamount=parseFloat(amount)-parseFloat(backamount)-(ssr*(-1));
		
		if (remainamount<0)
		{
			var tmppaymodedr=$("#PayMode"+i).combogrid("getValue");
			tmppaymodedr=","+tmppaymodedr+",";
			if (CanChangePayModes.indexOf(tmppaymodedr)==-1)
			{
			$.messager.alert("提示","请输入有效的金额!","info");
			return -1;}
		}		
		backtotal=parseFloat(backtotal)+parseFloat(backamount);
		
		newInvAmount=newInvAmount+remainamount;
		if (($("#PayMode"+i).combogrid('grid').datagrid('getSelected').Code=="ZP")&&(getValueById('No'+i)=="")) 
		{
			$.messager.alert("提示","支票退费，支票号不允许为空！","info");
			return -1;
		}
		if ((getValueById("NewPayMode"+i)==2)&&(getValueById('No'+i)=="")) 
		{
			$.messager.alert("提示","支票方式退费，支票号不允许为空！","info");
			return -1;
		}
		
		if (IsAllRefund=="1")
		{
			if (($("#PayMode"+i).combogrid('grid').datagrid('getSelected').Code=="CPP"))  CardFlag="1"
		} 
	    else
	   	{
			if (($("#PayMode"+i).combogrid('grid').datagrid('getSelected').Code=="CPP")&&(parseFloat(backamount)!=""))  CardFlag="1"  
		}
			
		if (remainamount!=0)
		{
			
			if (paymodeinfos!="") paymodeinfos=paymodeinfos+"^";
			paymodeinfos=paymodeinfos+$("#PayMode"+i).combogrid("getValue");
			paymodeinfos=paymodeinfos+","+remainamount;
			paymodeinfos=paymodeinfos+","+getValueById('No'+i);
			
			paymodeinfos=paymodeinfos+","+parseFloat(backamount);
			paymodeinfos=paymodeinfos+","+getValueById('NewPayMode'+i);
		
			var OldPayMode=$("#PayMode"+i).combogrid("getValue");
			var NewPayMode=getValueById('NewPayMode'+i);
			var No=getValueById('No'+i);
			var Info=tkMakeServerCall("web.DHCPE.CashierEx","JudgeTJKRemainAmount",peAdmId,remainamount,NewPayMode,No,OldPayMode);
			
			if(Info!="") var ErrInfo=Info;

			
		}
	}
	
	total=getValueById('BackAmount');
	
	if (backtotal!=total)
	{ 	
		$.messager.alert("提示","退费合计金额不一致!","info");
		return -1;
		}
			
	if(ErrInfo!=""){
		$.messager.alert("提示",ErrInfo,"info");
		return -1;
	}
	
	return paymodeinfos;
}

function GetAccPayModeInfo(IsAllRefund)
{
	var InvPrtId=getValueById("RPFRowId");
	var ssr=tkMakeServerCall("web.DHCPE.Cashier","GetssrAmountByInv",InvPrtId); //获取发票的舍入金额

	var i,amount,backamount,backtotal,remainamount;
	var total;
	var paymodeinfos="";
	CanChangePayModes=","+CanChangePayModes+",";
	backtotal=0;
	newInvAmount=0
	for (i=0;i<paymodecount;i++)
	{
		amount=$("#PayedAmount"+i).val();
		backamount=$("#RefundAmount"+i).val();
		if (isNaN(backamount)==true) 
		{
			$.messager.alert("提示","请输入有效的金额!","info");
			return -1;
		}		
		if (backamount=="") backamount=0;
		
		remainamount=parseFloat(amount)-parseFloat(backamount)-(ssr*(-1));
		
		if (remainamount<0)
		{
			var tmppaymodedr=$("#PayMode"+i).combogrid("getValue");
			tmppaymodedr=","+tmppaymodedr+",";
			if (CanChangePayModes.indexOf(tmppaymodedr)==-1)
			{$.messager.alert("提示","请输入有效的金额!","info");
			return -1;}
		}		
		backtotal=parseFloat(backtotal)+parseFloat(backamount);
		newInvAmount=newInvAmount+remainamount;
		if (IsAllRefund=="1")	
		{
			if (($("#PayMode"+i).combogrid('grid').datagrid('getSelected').Code=="CPP"))  CardFlag="1"
		}                                        
	    else
	   	{
			if (($("#PayMode"+i).combogrid('grid').datagrid('getSelected').Code=="CPP")&&(parseFloat(backamount)!=""))  CardFlag="1"  
		}	
		if (1)
		{
			if (paymodeinfos!="") paymodeinfos=paymodeinfos+"^";
			paymodeinfos=paymodeinfos+$("#PayMode"+i).combogrid("getValue");
			paymodeinfos=paymodeinfos+","+remainamount;
			paymodeinfos=paymodeinfos+","+getValueById('No'+i);
			paymodeinfos=paymodeinfos+","+parseFloat(backamount);
		}		
	}
	total=getValueById('BackAmount');

	if (backtotal!=total)
	{ 	$.messager.alert("提示","退费合计金额不一致!","info");
		return -1;}
	return paymodeinfos;
}

function GetCardInfo(payedInfo) {
	var Balance="";
	var CardNo="";
	var CardInfo="";
	var DateTime="";
	var PayedArr=payedInfo.split("#");
	var PayModeStr=PayedArr[0];
	var PayModeArr=PayModeStr.split("^");
	var Len=PayModeArr.length;
	for (i=0;i<Len;i++){
		var PayModeNod=PayModeArr[i];
		var PayModeNodArr=PayModeNod.split(",");
		var PayModeDR=PayModeNodArr[0];
		if (PayModeDR==21){
			var CardNo=PayModeNodArr[2];
			CardNoArr=CardNo.split("%");
			CardNo=CardNoArr[0];
			var Balance=tkMakeServerCall("web.DHCPE.AdvancePayment","GetAPAmount",PayModeDR,CardNo);
			Balance=parseFloat(Balance).toFixed(2);
			var DateTime=tkMakeServerCall("web.DHCPE.Cashier","GetDateTimeStr");
			CardInfo=CardNo+"^"+Balance+"^"+DateTime;
		}
	}
	return CardInfo;
}
function disabledButton()
{
	$HUI.linkbutton("#BAllRefund").disable();
	$HUI.linkbutton("#BRefund").disable();
	
}
function Refund(IsReprint,IsAllRefund)
{
	

	var userId=session['LOGON.USERID'];
	var locId=session['LOGON.CTLOCID'];
	var HospitalID=session['LOGON.HOSPID'];
	var invNo=getValueById("CurNo");
	var invNo=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",invNo);
	var InvName=getValueById("InvName");
	invNo=invNo+"^"+InvName;
	
  	var NoPrintInv="0";
  	var obj=$("#NoPrintInv").checkbox('getValue');
  	if (obj) NoPrintInv="1";
  	
  	
  	invNo=invNo+"^"+NoPrintInv;
	
    var invId=getValueById("InvID");
    var peAdmType=getValueById("ADMType");
    var peAdmId=getValueById("GIADM");
    
	var InvPrtId=getValueById("RPFRowId");
	
	var SelectIds=getValueById("SelectIds");

	if ((InvPrtId==""))
	{
		$.messager.alert("提示","请先选择发票!","info");
		return;
	}
	
	if ((SelectIds=="")&&(IsReprint==0))
	{
		$.messager.alert("提示","请选择要退费的项目!","info");
		return;
	}
	if ((SelectIds!="")&&(IsReprint==1))
	{
		$.messager.alert("提示","全退不需要选择退费项目!","info");
		return;
	}
	if ((IsReprint=="1")&&(IsAllRefund=="0"))
	{
		setValueById("BackAmount",0);
		setValueById("RefundAmount0",0);
	}
	
	//药品权限控制 如果退费时，药品仍是发药状态，进行提示需先退药  
	
	
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","DrugPermControl",InvPrtId,"1");

	if (flag=="1") 
	
	{
		$.messager.alert("提示","存在已发药数据,需要先退药!","info");
	 	return false;
	 } 
	 
	
	var payedInfo=GetPayModeInfo(IsAllRefund);
	
	if (-1==payedInfo) return;
	
	var AccPayModeInfo=GetAccPayModeInfo(IsAllRefund);
	
	var InsuID="",InsuFlag=0;
	var InsuID=tkMakeServerCall("web.DHCPE.DHCPEBillCharge","GetInsuID",InvPrtId,"0");
	
	var AdmReason="";
	if (InsuID!=""){
		AdmReason=getValueById("AdmReason");
		if (AdmReason==""){
			$.messager.alert("提示","费别不能为空!","info");
			return false;
		}
		invNo=invNo+"^"+AdmReason;
		var AdmSorce=""
		var ExpStr="^^^^^"
		try
		{
			var ret=InsuPEDivideStrike("0",userId,InsuID,AdmSorce,AdmReason,ExpStr,"N")
			if (ret!="0"){
				$.messager.alert("提示","医保退费失败,请和信息中心联系!","info");
				return false;
			}
		}
		catch(e){
			$.messager.alert("提示","调用医保失败,请和信息中心联系^"+e.message,"info");
			return false;
		}
		InsuFlag=1;
	}else{
		invNo=invNo+"^"+AdmReason;
	}

	
	var listFlag=GetListFlag(peAdmType);                                                      
	var AccID="";             
    if (CardFlag=="1")
    {
	 	
		var myCardTypeValue=getValueById("CardTypeNew")
		var CardTypeID=myCardTypeValue.split("^")[0];
		var myrtn=DHCACC_GetAccInfo(CardTypeID,myCardTypeValue);
      	var myary=myrtn.split("^");
		var rtn=myary[0];
		switch (rtn){
		case "0":
			AccID=myary[7];
			break;
		case "-200": 
			$.messager.alert("提示","卡无效","info");
			break;
		case "-201" :	
			break;
		default:
		}

    	if (AccID==""){ 	
			$.messager.alert("提示","卡消费请读卡!","info");
			return false;
			}  
    	
	 	var CurrRegNo=getValueById("CurRegNo")
		var ReturnStr=tkMakeServerCall("web.DHCPE.DHCPEPAY","CheckAccount",AccID,CurrRegNo);
		
		
		if (ReturnStr=="1"){$.messager.alert("提示","请用本人卡账户进行消费!","info");return false; }
	   
		
		
    }                                                                             
    	var RefuntInfo=""+"^"+AccID+"^"+"";
    	var CardInfo=GetCardInfo(AccPayModeInfo);	
    	var CardInfoArr=CardInfo.split("^");
		var CardNo=CardInfoArr[0];
		var OriginBalance=CardInfoArr[1];
	
    var TaxpayerNum=getValueById("TaxpayerNum");
    var invNo=invNo+"^"+TaxpayerNum;
	
	//alert(InvPrtId+"^"+userId+"^"+locId+"^"+SelectIds+"^"+payedInfo+"^"+newInvAmount+"^"+invNo+"^"+invId+"^"+peAdmType+"^"+peAdmId+"^"+IsReprint+"^"+listFlag+"^"+IsAllRefund+"^"+RefuntInfo+"^"+HospitalID)
	
	var ret=tkMakeServerCall("web.DHCPE.Cashier","DropInvPrt",InvPrtId,userId,locId,SelectIds,payedInfo,newInvAmount,invNo,invId,peAdmType,peAdmId,IsReprint,listFlag,IsAllRefund,RefuntInfo,HospitalID);
	
   
    var CardInfo=GetCardInfo(AccPayModeInfo);
	var CardInfoArr=CardInfo.split("^");
	var CardNo=CardInfoArr[0];
	var AfterBalance=CardInfoArr[1];
	var Cost=OriginBalance-AfterBalance;
	Cost=Cost.toFixed(2);
	
	
	var DateTime=tkMakeServerCall("web.DHCPE.Cashier","GetDateTimeStr");
	var Delim=String.fromCharCode(2);
	var TxtInfo="CardNo"+Delim+CardNo;
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+Cost;
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+AfterBalance;
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime;
	
   
    disabledButton();
    var tmp=ret.split("^");
    if (tmp[0]=="")
    {	
    	if (IsReprint==0) 
    	{
	    	$.messager.alert("提示","退费成功!请回收发票!","info");
    		
    	}
    	else
    	{
	    	if (IsAllRefund=="0") $.messager.alert("提示","重打发票成功!请回收发票!","info");
    		if (IsAllRefund=="1") $.messager.alert("提示","退费成功!请回收发票!","info");
    	}
    	
		var Balance=tkMakeServerCall("web.DHCPE.DHCPEPAY","getCardAmount",AccID);
		setValueById("Balance","卡余额:"+Balance)
				    
    	if (ret!=""&&IsAllRefund=="0"){
	    	
	    	var ETPRowID="";
			var NewInsuID=""
			if (InsuFlag == "1") {
				var insuRtn=insurancePay(tmp[2],"",userId,AdmSorce,admReason);  //DHCPEPayService.js
				if(insuRtn.ResultCode!="0"){
					$.messager.alert("提示",insuRtn.ResultMsg,"info");
					return false;
				}else if(insuRtn.ExpStr!=""){
					NewInsuID=insuRtn.ExpStr.split("^")[0];
				}
				//计算是否需要第三方支付补缴(主要用于医保全退再收失败时，选择第三方支付方式补缴)
				var extRtn=extPay(tmp[2],userId,NewInsuID,AdmSorce,admReason);
				if(extRtn.ResultCode!="0"){
					$.messager.alert("提示",extRtn.ResultMsg,"info");
					return false;
				}else{
					ETPRowID=extRtn.ETPRowID;
				}
			}
			var newInvNo=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
			var ret=tkMakeServerCall("web.DHCPE.Cashier","RealCashier",tmp[2],userId,newInvNo.split("^")[0]);
    		var tmp=ret.split("^");
    		if (tmp[0]!=""){
	    		$.messager.alert("提示","再收费失败，请处理预结算记录","info");
	    		return false;
    		}
    		
    		//关联计费交易记录
			if (ETPRowID != "") {			
				var ReFlag = RelationService(SFETPRowID, tmp[2], "PE")
				if (ReFlag.ResultCode != "0") {
					$.messager.alert("提示","计费关联失败，请联系信息科！\n" + ReFlag.ResultMsg,"info");
				}			
			}
			var IfPrintMinusInvFlag=tkMakeServerCall("web.DHCPE.HISUICommon","IfPrintMinusInvFlag");
    		if(IfPrintMinusInvFlag=="Y"){
    	       PrintMinusBill(tmp[1],tmp[2],tmp[3]);
    		}   	   
    		PrintBill(tmp[1],tmp[2],tmp[3]);
    	}
    	var rfdRtn=extRefund("",InvPrtId);  //DHCPEPayService
		if(rfdRtn.ResultCode!="0"){
			$.messager.alert("提示",rfdRtn.ResultMsg,"info");
		}
    	
    	if ((CardNo!="")&&(parseFloat(Cost)<-0.01)) {
    		PrintBalance(TxtInfo);
    	}
    	
    	
    	 $('#ordItmList').datagrid('load', {
				ClassName: 'web.DHCPE.ItemFeeList',
				QueryName: 'FindItemFeeList',
				InvPrtId: "",
		
			});
		 
		ClearInitInvInfo();
    	BFind_click(); 
    	
  
    }
    else
    {
		if (InsuFlag=="1")
		{
			$.messager.alert("提示","医保已经退费成功,体检退费失败,请和信息中心联系!","info");
		}
		else if (IsReprint==0) 
			{
				$.messager.alert("提示","退费失败!"+tmp[0],"info");
			}
		else
			{
				$.messager.alert("提示","重打发票失败!"+tmp[0],"info");
			}
	}
}

function ClearInitInvInfo()
{
	var paymodeinfos=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeInfo",$("#RPFRowId").val());
	
	if (paymodeinfos=="") return;
	var paymodeinfoStr=paymodeinfos.split("%%");
	var paymodeinfo=paymodeinfoStr[0].split("&");
	
	paymodecount = paymodeinfo.length;
	for(var I = 0; I < paymodecount; I++)
	{
			$("#PayMode"+I).combogrid("setValue","");
			$("#PayedAmount"+I).val("")
		    $("#No"+I).val("")
		    $("#RefundAmount"+I).val("");
		    $("#NewPayMode"+I).combobox("setValue","");
		    
		 
	
	}
	
	$("#Balance,#InvName,#TaxpayerNum,#NewAmount,#BackAmount").val("")
	$("#AdmReason").combobox("setValue","");
	
}

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

function PrintBill(invprtid,relInvPrtID,PrintListFlag)
{
	var peAdmType=getValueById("ADMType");
	var listFlag=GetListFlag(peAdmType);
	if (invprtid=="")
	{
		return false;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
	
	var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,invprtid);
	
	
	
	var InvListFlag=listFlag;
	if (PrintListFlag==1) InvListFlag=0;
	var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,invprtid,InvListFlag)
	
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText:true}");
	if (PrintListFlag==1){
	    		PrintInvDetail(invprtid,1);
	}
}

function PrintMinusBill(invprtid,relInvPrtID,PrintListFlag)
{
	
	var MunusInv=tkMakeServerCall("web.DHCPE.Cashier","GetMinusInv",invprtid)
	if (MunusInv=="")
	{
		return false;
	}

	//alert(MunusInv+"MunusInv")
	var peAdmType=getValueById("ADMType");
	var listFlag=GetListFlag(peAdmType);
	if (invprtid=="")
	{
		return false;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
	var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,MunusInv);

	var InvListFlag=listFlag;
	if (PrintListFlag==1) InvListFlag=0;
	var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,MunusInv,InvListFlag)
	//alert(ListInfo);
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText:true}");
	if (PrintListFlag==1){
	    		PrintInvDetail(MunusInv,1);
	}
}

function PrintInvDetail(invid,listFlag)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");
	var peAdmType=getValueById("ADMType");
	
	var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,invid,"List");
	
	var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,invid,listFlag,"1");
	
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText:true}");
}

function CardNoChange(){
	var CardNo=$("#CardNo").val();
	if (CardNo==""){
		$("#CardTypeNew,#CardTypeRowID").val("");
	}
}
function CardNoKeydownHandler(){
		var CardNo=$("#CardNo").val();
		if (CardNo=="") return;
		CheckCardNo();
		return false;
	
}
function CheckCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return false;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
}
 //读卡
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}

function CardNoKeyDownCallBack(myrtn){
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
		$.messager.alert("提示","卡无效!","info",function(){
			$("#CardNo").val(CardNo).focus();
		});
		return false;
	}
}


//打印收据证明xml
function BPrintProveXML_click(){
	
	var PEINVDR=$('#RPFRowId').val();
	if(PEINVDR==""){
		$.messager.alert("提示","请选择要打印清单的记录","info");
	    	return ;
	}
	var InvNo=$('#RPFInvNo').val();
	if(InvNo=="")
	{
		$.messager.alert("提示","发票为退费的负记录,不能打印","info");
		return ;
	}
	
	var PrintData=tkMakeServerCall("web.DHCPE.CashierEx","GetProveInfoXML",PEINVDR);
	 
	 var Char_3=String.fromCharCode(3);
	 var DataArr=PrintData.split(Char_3);
	 var BaseInfo=DataArr[0];
	 var ItemFeeInfo=DataArr[2];
	 var TxtInfo=BaseInfo;
	 var ListInfo=ItemFeeInfo;
	 //alert("TxtInfo:"+TxtInfo)
	 //alert("ListInfo:"+ListInfo)
	 DHCP_GetXMLConfig("InvPrintEncrypt","PEInvProve");
	 DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText: true}");
	 //var myobj=document.getElementById("ClsBillPrint");
	// DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	
}

 //打印收据证明
function BPrintProve_click(){
	 BPrintProveXML_click()
	return false; 
	
	var PEINVDR=$('#RPFRowId').val();
	if(PEINVDR==""){
		$.messager.alert("提示","请选择要打印清单的记录","info");
	    	return ;
	}
	var InvNo=$('#RPFInvNo').val();
	if(InvNo=="")
	{
		$.messager.alert("提示","发票为退费的负记录,不能打印","info");
		return ;
	}
	
	
	 var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEProvePrt.xls';
	 var PrintData=tkMakeServerCall("web.DHCPE.CashierEx","GetProveInfo",PEINVDR);
	
		xlApp= new ActiveXObject("Excel.Application"); //固定
		xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
		xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
		var Char_3=String.fromCharCode(3);
		var Char_2=String.fromCharCode(2);
		var DataArr=PrintData.split(Char_3);
		var BaseInfo=DataArr[0];
		var BaseArr=BaseInfo.split("^");
		
		
		var Str="经查询"+BaseArr[0]+"同志在我院开出的收据号为"+BaseArr[1];
		var Length=Str.length
		if(Length>31) {
			var m=1;
			xlsheet.cells(5,3)=Str.substr(0,30);
			xlsheet.Rows(6).insert();
			 xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,8)).mergecells=true
			xlsheet.cells(6,2)=Str.substr(30,Length);
			
			
		}else{
			var m=0;
			xlsheet.cells(5,3)="经查询"+BaseArr[0]+"同志在我院开出的收据号为"+BaseArr[1];
		}
        
        xlsheet.cells(7+m,5)=BaseArr[2];
		var Rows=7+m;

		var CatInfo=DataArr[1];
		var CatArr=CatInfo.split(Char_2);
		var CatLength=CatArr.length;
		for (var i=0;i<CatLength;i++)
		{
			var OneCatInfo=CatArr[i];
			var OneArr=OneCatInfo.split("^");
			Rows=Rows+1;
			xlsheet.cells(Rows,4)=OneArr[0];
			xlsheet.cells(Rows,6)=OneArr[1];
		}
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="实付";
		xlsheet.cells(Rows,6)=BaseArr[4];
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="合计";
		xlsheet.cells(Rows,6)=BaseArr[3];
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="大写";
		xlsheet.cells(Rows,6)=BaseArr[5];
		Rows=Rows+2;
		var ItemFeeInfo=DataArr[2];
		var ItemFeeArr=ItemFeeInfo.split(Char_2)
		var ItemFeeLength=ItemFeeArr.length;
		for (var i=0;i<ItemFeeLength;i++)
		{
			Rows=Rows+1;
			xlsheet.cells(Rows,1)=(i+1);
			var OneInfo=ItemFeeArr[i];
			var OneArr=OneInfo.split("^");
			xlsheet.cells(Rows,2)=OneArr[0];
			xlsheet.cells(Rows,5)=OneArr[1];
			xlsheet.cells(Rows,6)=OneArr[2];
			xlsheet.cells(Rows,7)=OneArr[3];
			xlsheet.cells(Rows,8)=OneArr[4];
		}
		Rows=Rows+1;
		xlsheet.cells(Rows,2)="合计";
		xlsheet.cells(Rows,8)=BaseArr[4];
		Rows=Rows+3;
		xlsheet.cells(Rows,2)="特此证明";
		xlsheet.cells(Rows+1,7)=BaseArr[6];
		var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
		xlsheet.cells(Rows,7)=HosName;
		xlsheet.cells(Rows,7).HorizontalAlignment=1;
		xlsheet.cells(Rows+1,7).HorizontalAlignment=1;

		xlsheet.printout;
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null;
	
}


//打印清单
function BPrintList_click(){
	
	var PEINVDR=$('#RPFRowId').val();
	if(PEINVDR==""){
		    $.messager.alert("提示","请选择要打印清单的记录","info");
	    	return ;
	}
	var peAdmType=tkMakeServerCall("web.DHCPE.Cashier","GetAdmType",PEINVDR);
	var InvNo=$('#RPFInvNo').val();
	if(InvNo=="")
	{   
	    $.messager.alert("提示","发票为退费的负记录,不能打印","info");
		return ;
	}
	
	var listFlag=GetListFlag(peAdmType);
	var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,PEINVDR,"List");
	var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,PEINVDR,1,"1");
	
	
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText: true}");
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function GetListFlag(admtype)
{
	if (admtype!="I") return 0;
	var InvListFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetInvListFlag");
	if (InvListFlag=="1") return 1;
	return 0;
	
}



//查询
function BFind_click()
{
	$('#RPFRowId').val("");
	InButtonInfo();
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
		iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
		$("#RegNo").val(iRegNo)
	}

	$("#InvListQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.InvPrt",
			QueryName:"FindInvPrtList",
			InvNo:$("#InvNo").val(),
			PatName:$("#PatName").val(),
			RegNo:$("#RegNo").val(),
			User:$("#User").val(), 
			CardNo:$("#CardNo").val(),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RPFlag:$("#RPFlag").combogrid('getValue'),
			isApply:isApply
			});
	$('#ordItmList').datagrid('load', {
				ClassName: 'web.DHCPE.ItemFeeList',
				QueryName: 'FindItemFeeList',
				InvPrtId: ""
		
			});

}



function InitInvInfo()
{
	 var SelectIds=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefund",$('#RPFRowId').val(),1);
    $("#RefundAmount0").attr('disabled',false);
    $("#RefundAmount1").attr('disabled',false);
    if(SelectIds==""){
	    $("#RefundAmount0").attr('disabled',true);
        $("#RefundAmount1").attr('disabled',true);
    } 

	var paymodeinfos=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeInfo",$('#RPFRowId').val());
	
	if (paymodeinfos=="") return;
	var paymodeinfoStr=paymodeinfos.split("%%");
	var paymodeinfo=paymodeinfoStr[0].split("&");
	
	paymodecount = paymodeinfo.length;
	for(var I = 0; I < paymodecount; I++)
	{
		var paymode=paymodeinfo[I].split("^");
		if (I>1) AddNewRow(I);
		$("#PayMode"+I).combogrid("setValue",paymode[0]);  
		if ((paymode[1]=="体检预交金")||(paymode[1]=="体检代金卡"))
		{
			$("#NewPayMode0").combobox("disable");
		}
		else 
		{
			$("#NewPayMode0").combobox("enable");
			
		}
		$("#PayedAmount"+I).val(paymode[2])
		$("#No"+I).val(paymode[3])

		$("#RefundAmount"+I).attr('disabled',false);
	   if(SelectIds==""){$("#RefundAmount"+I).attr('disabled',true);} 
	   if($("#PayMode"+I).combogrid("getValue")==""||$("#PayMode"+I).combogrid("getValue")=="undefind")
	   {
		    $("#NewPayMode"+I).combobox("disable");		   
		    $("#No"+I).attr('disabled',true);
			$("#RefundAmount"+I).attr('disabled',true);
	   }

	}
	if (I==1) 
	{
		OnePayMode=1;
		$("#NewPayMode"+I).combobox("disable");		   
		$("#No"+I).attr('disabled',true);
		$("#RefundAmount"+I).attr('disabled',true);
	}
		
}




function AddNewRow(index)
{
	AddPayModeHtml='<tr id="PayModetr'+index+'"><td><div><select class="hisui-combogrid" Id="PayMode'+index+'" name="PayMode'+index+'" style="width:110px;" editable="false" disabled="true"></select></div></td>'
         +
         '<td><div><input class="hisui-numberbox textbox" Id="PayedAmount'+index+'" data-options="precision:2" style="width:100px;" disabled="true"/></div></td>'
         +
         '<td><div><input class="hisui-numberbox textbox" Id="RefundAmount'+index+'" data-options="precision:2" style="width:100px;"/></div></td>'
         +
         '<td><div><input class="hisui-validatebox textbox" Id="No'+index+'" style="width:100px;"/></div></td>'
         +
         '<td><div><select class="hisui-combobox" Id="NewPayMode'+index+'" name="NewPayMode'+index+'" style="width:110px;" editable="false"></select></div></td></tr>'
	
	$("#PayModeTable").append(AddPayModeHtml);
	
	
	$HUI.combogrid("#PayMode"+index,{
		panelWidth:220,
		url:$URL+"?ClassName=web.DHCPE.Cashier&QueryName=GetCashierMode",
		mode:'remote',
		delay:200,
		idField:'Hidden',
		textField:'Description',
		
		columns:[[
			{field:'Hidden',hidden:true},
			{field:'Code',title:'编码',width:80},
			{field:'Description',title:'名称',width:110}
		]]
		});
		
	$HUI.combobox("#NewPayMode"+index,{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=OutPayMode&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})		
	
	
}


function DeleteNewRow(){
	
	 for(var I = 2; I <5 ; I++){
            $("#PayModetr"+I).remove();        
	}

}

function InitChecked(){
	
	
	
	 var invPrtId=$("#RPFRowId").val();
		if (invPrtId==""){
			return false;
		} 
		
	
    var SelectIds=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefund",invPrtId,1);
       
	
	//设置SelectIds中的值
	setValueById("SelectIds",SelectIds);
	
	//退费总金额
	var backAmount=0;
	if(SelectIds!=""){	
		backAmount=SelectIds.split(";")[1];
		
	}else{
		backAmount=getValueById("NewAmount")
	}
	
	setValueById("BackAmount",backAmount);
	
	if (OnePayMode==1){
		
		setValueById('RefundAmount0',backAmount);
	}
	
}

function SetInvNo()
{	
	var userId=session['LOGON.USERID'];
	
    var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
    
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]==""))
    	{	
    	$.messager.alert("提示","没有设置正确的发票号!","info");  		
    	return;
    	}
    
	if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    setValueById("CurNo",No);

    setValueById("InvID",invNo[1]);    
    return ;
}

function InitBillInfo()
{
	SetInvNo();
}
function InButtonInfoNew(){
	if(isApply=="2"){
		
		obj =document.getElementById("BPrintDanZ");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("RepeatPrint");
		if(obj){obj.style.display="";}
		obj =document.getElementById("BGREPrint");
		if(obj){obj.style.display="";}
		
	}
	if(isApply=="1"){
		obj =document.getElementById("BPrintDanZ");
		//if(obj){obj.style.display="";}
		if(obj){obj.style.display="none";}
		obj =document.getElementById("RepeatPrint");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("BGREPrint");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("BPrintList");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("BPrintProve");
		if(obj){obj.style.display="none";}

	}
}

function InButtonInfo()
{
	
	
	var invId=getValueById("RPFRowId");
	
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefundFlag",invId)
	
	
	if(flag=="")
	{
		obj =document.getElementById("BAllRefund");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("BRefund");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("RepeatPrint");
		if(obj){obj.style.display="none";}
		
		
	}
	
	if(flag=="1"){
		obj =document.getElementById("BAllRefund");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("BRefund");
		if(obj){obj.style.display="";}
		obj =document.getElementById("RepeatPrint");
		if(obj){obj.style.display="none";}
		$HUI.linkbutton("#BRefund").enable();
	}
	if(flag=="0")
	{
		obj =document.getElementById("BRefund");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("BAllRefund");
		if(obj){obj.style.display="";}
		obj =document.getElementById("RepeatPrint");
		if(obj){obj.style.display="none";}
		$HUI.linkbutton("#BAllRefund").enable();
	}
	
	if(isApply=="2")
	{
		obj =document.getElementById("BAllRefund");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("BRefund");
		if(obj){obj.style.display="none";}
		obj =document.getElementById("RepeatPrint");
		if(obj){obj.style.display="";}
		obj =document.getElementById("BPrintDanZ");
		if(obj){obj.style.display="none";}

		var NoPrintInv=$("#NoPrintInv").checkbox('getValue');
		if (NoPrintInv) { 
		    	$("#RepeatPrint").css('display','none');//隐藏	
		   }else{
				 $("#RepeatPrint").css('display','block');//显示
		   }
	
		   var paymodeinfos=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeInfo",invId);
		   	if(paymodeinfos.indexOf("体检代金卡")>-1){
				$("#RepeatPrint").css('display','none');//隐藏
			}
			if(paymodeinfos.indexOf("体检预交金")>-1){
				$("#RepeatPrint").css('display','none');//隐藏
			}
	}
	
}

function InitInvListQueryTabDataGrid()
{
	
	$HUI.datagrid("#InvListQueryTab",{
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
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.InvPrt",
			QueryName:"FindInvPrtList",
			InvNo:$("#InvNo").val(),
			PatName:$("#PatName").val(),
			RegNo:$("#RegNo").val(),
			User:$("#User").val(), 
			CardNo:$("#CardNo").val(),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RPFlag:$("#RPFlag").combogrid('getValue'),
			isApply:isApply
				
		},
		columns:[[
		    {field:'TRowId',title:'TRowId',hidden: true},	
		    {field:'TInvNo',title:'发票号'},
			{field:'TPatName',title:'姓名'},
			{field:'TRegNo',title:'登记号'},
			{field:'TAmount',title:'金额',align:'right'},
			{field:'TFlag',title:'状态'},
			{field:'TUser',title:'收费员'},
			{field:'TInvDate',title:'收费日期'},
			{field:'TRPFlag',title:'结账标志',align:'center'},
			{field:'TRPDate',title:'结账日期'},
			{field:'TSex',title:'性别'},
			{field:'TAge',title:'年龄'},
			{field:'TDropDate',title:'作废日期',hidden: true},
			{field:'TRInvNo',title:'被退费的发票号',hidden: true},
			{field:'TPayMode',title:'支付方式'},
			{field:'TRoundInfo',title:'凑整费',align:'right'},
			{field:'TInvName',title:'发票名称'},
			{field:'Tsswr',title:'分币误差',align:'right'},
			{field:'TAdmType',hidden: true},
			{field:'TGIAdm',hidden: true},
			
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			
			$('#RPFRowId').val(rowData.TRowId);
			$('#RPFInvNo').val(rowData.TInvNo);
			$('#ADMType').val(rowData.TAdmType);
			$('#GIADM').val(rowData.TGIAdm);
			$('#CurRegNo').val(rowData.TRegNo);
			$('#NewAmount').val(NewAmount);
			$('#ordItmList').datagrid('load', {
				ClassName: 'web.DHCPE.ItemFeeList',
				QueryName: 'FindItemFeeList',
				InvPrtId: rowData.TRowId
		
			});


			DeleteNewRow();

			$("#PayMode1").combogrid("setValue","");  
			setValueById("PayedAmount1","");
			setValueById("RefundAmount1","");
			setValueById("No1","");
			setValueById("NewPayMode1","");
			
			
			
			setValueById("Balance","");
			setValueById("InvName","");
			setValueById("TaxpayerNum","");
			
			
			var NoPrint=tkMakeServerCall("web.DHCPE.CashierEx","GetSSPFlag",rowData.TRowId);
			if(NoPrint==1) $("#NoPrintInv").checkbox('setValue',true);
			else 	$("#NoPrintInv").checkbox('setValue',false);

			InButtonInfo();
			InitInvInfo();
			InitBillInfo();
			InitChecked();
			
			
			var BackAmount=getValueById('BackAmount');
			if(rowData.TRowId!=""){
				var InvPrtId=getValueById("RPFRowId");
				var ssr=tkMakeServerCall("web.DHCPE.Cashier","GetssrAmountByInv",InvPrtId); //获取发票的舍入金额
				var NewAmount=tkMakeServerCall("web.DHCPE.DHCPEBillCharge","GetAmountByInv",rowData.TRowId);
				NewAmount=NewAmount-BackAmount-(ssr*(-1));
				$('#NewAmount').val(NewAmount.toFixed(2));
			}else{
				$('#NewAmount').val("");
				$('#BackAmount').val("");
				
			}

			
			
			}
			
	});
	
	
	$HUI.datagrid('#ordItmList', {	
		fit: true,
		striped: true, //是否显示斑马线效果
		singleSelect: false,
		selectOnCheck: false,
		checkOnSelect:false,
		autoRowHeight: false,
		showFooter: true,
		url: $URL,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageSize: 20,
		pageList: [20, 30, 40, 50],
	    queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
				
		},
		toolbar:[],
		columns: [[{
					title: '选择',
					field: 'Select',
					checkbox:true,
					/*formatter:function(value,rowData,index){
						return "<input type='checkbox' onclick=\"GetSelectIds('" + value + "', '" + index + "')\"/>"; 
					}*/
				
				}, {
					title: '销售金额',
					field: 'FactAmount',
					align: 'right'
				}, {
					title: '项目名称',
					field: 'ItemName'
				}, {
					title: '执行状态',
					field: 'OrdStatusDesc'
				}, {
					title: '优惠形式',
					field: 'PrivilegeMode'
				}, {
					title: '优惠内容',
					field: 'Privilege',
					hidden: true
				}, {
					title: '姓名',
					field: 'PatName'
				}, {
					title: '登记号',
					field: 'PatRegNo'
				}, {
					title: 'RowId',
					field: 'RowId',
					hidden: true
				},{
					title: 'FeeType',
					field: 'FeeType',
					hidden: true
				}
			]],
			
	
			
			
	onLoadSuccess: function (rowData) { 
	   $('#ordItmList').datagrid('clearSelections'); //一定要加上这一句，要不然datagrid会记住之前的选中
	   $("#ordItmList").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");

	 
	   	
        var invPrtId=$("#RPFRowId").val();
		if (invPrtId==""){
			return false;
		} 
		
	
        var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefund",invPrtId);
       
	    var objtbl = $("#ordItmList").datagrid('getRows');
	              
		if (rowData) { 
		   
		  //遍历datagrid的行            
		 $.each(rowData.rows, function (index) {
			    $(".datagrid-row[datagrid-row-index="+index+"] input[type='checkbox']").attr('disabled','disabled');
			 	
			 	if(info.indexOf(objtbl[index].RowId)>=0){
				 //加载页面时根据后台类方法返回值判断datagrid里面checkbox是否被勾选
				 $('#ordItmList').datagrid('checkRow',index);
			
			 	}
		 });
		 
		 
		 }
		}
		            
	});
	
	
	
}


function InitCombobox()
{
	// 日结标记	
	var RPObj = $HUI.combobox("#RPFlag",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRPFlag&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
	
	// 支付方式	
	var PayModeObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJPayMode&ResultSetType=array",
		valueField:'id',
		textField:'text'
		
		})
	// 支付方式	
	var NewPayMode0Obj = $HUI.combobox("#NewPayMode0",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=OutPayMode&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})	
	var NewPayMode1Obj = $HUI.combobox("#NewPayMode1",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=OutPayMode&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})		
	var AdmReasonObj = $HUI.combobox("#AdmReason",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=OutAdmReason&ResultSetType=array",
		valueField:'id',
		textField:'desc',
			onSelect:function(record){
			
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
		}
		});		
	var PayMode0Obj = $HUI.combogrid("#PayMode0",{
		panelWidth:220,
		url:$URL+"?ClassName=web.DHCPE.Cashier&QueryName=GetCashierMode",
		mode:'remote',
		delay:200,
		idField:'Hidden',
		textField:'Description',
		
		columns:[[
			{field:'Hidden',hidden:true},
			{field:'Code',title:'编码',width:80},
			{field:'Description',title:'名称',width:110}
		]]
		});	
	var PayMode1Obj = $HUI.combogrid("#PayMode1",{
		panelWidth:220,
		url:$URL+"?ClassName=web.DHCPE.Cashier&QueryName=GetCashierMode",
		mode:'remote',
		delay:200,
		idField:'Hidden',
		textField:'Description',
		
		columns:[[
			{field:'Hidden',hidden:true},
			{field:'Code',title:'编码',width:80},
			{field:'Description',title:'名称',width:110}
		]]
		});	
}







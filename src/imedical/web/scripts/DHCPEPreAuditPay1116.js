//页面初始化
//
var payModeName="";
var payedInfo="";	///结算支付信息
var pAmount=0;	
var ids="";	///审核id串
var defaultpaymode=""
var remainfee=0;
var roundingfee=0;
var roundingitem="";
var BAddobj;
var BBillobj;
var BAddRoundobj;
var specialpaymodes;
var Insurance="N"
var ybkFlag=0;
var ybkAmount=0;
var SelectedRow=0;
var CardFlag="N";
var CardFee=0;
var m_SelectCardTypeDR="";
function DocumentKeyDown()
{
	var eSrc=window.event.srcElement;
	if (eSrc.id=="BBilled"){
		if (!confirm(t['ConfirmBilled'])) return false;
		BBilled_click();
		return false;
	}
	if ((event.keyCode==13)||(event.keyCode==40)||(event.keyCode==39)) {event.keyCode=9}
	if ((event.keyCode==38)||(event.keyCode==37)) {
		event.keyCode=25
	}
}
function BodyLoadHandler()
{
	//alert('b')
	document.onkeydown=DocumentKeyDown;
	BAddobj=document.getElementById("BAdd");
	if (BAddobj){BAddobj.onclick=BAdd_Click;
	BAddobj.disabled=true;}
	BBillobj=document.getElementById("BBilled");
	if (BBillobj) BBillobj.onclick=BBilled_click;
	BBillobj.disabled=true;     
	
	ReadYBCardobj=document.getElementById("ReadYBCard");
	if (ReadYBCardobj) ReadYBCardobj.onclick=ReadYBCard_click;   
	
	var peAdmType=GetCtlValueById("ADMType");
	var roundfeemode=GetCtlValueById("RoundingFeeMode");
	if (peAdmType!="I")
	{
		var InsuObj=document.getElementById("InsuPay");
		if (InsuObj){
			HideElement("InsuPay");
			HideElement("cInsuPay");
		}
	}
	if ((roundfeemode==0)||((roundfeemode==1)&&(peAdmType!="I"))||((roundfeemode==2)&&(peAdmType=="I")))
	{
		HiddenRoundFee();
	}
	else
	{	
		BAddRoundobj=document.getElementById("BAddRound");
		if (BAddRoundobj) BAddRoundobj.onclick=BAddRound_Click;
		BAddRoundobj.disabled=true;
	}
	var obj=document.getElementById("PayMode");
	if (obj) 
	{	obj.onkeydown=PayMode_KeyDown;
		obj.onchange=PayMode_KeyUp;
	}
	obj=document.getElementById("No");
	if (obj) 
	{	obj.onchange=No_Change;
	}
	obj=document.getElementById("AmountToPay");
	if (obj) 
	{	obj.onchange=Amount_Change;
		obj.onkeydown=Amount_KeyDown;
	}
	obj=document.getElementById("BPrintDetail");
	if (obj) obj.onclick=PrintInvByPreAudit;
	obj=document.getElementById("BReprint");
	if (obj) obj.onclick=BReprint_Click;
	
	var paymodelookup="ld"+GetCtlValueById("GetComponentID")+"iPayMode";
	obj=document.getElementById(paymodelookup);
	if (obj) obj.onclick=PayMode_Click;
	
	obj=document.getElementById("PrintCatFlag");
	if (obj) {obj.onclick=PrintCatFlag_Click;
	  obj.checked=false};
	InitListEvent();
		
	InitBillInfo();		
	defaultpaymode=GetCtlValueById("PayModeDR");
	specialpaymodes=GetCtlValueById("SpecialPayModes");
	specialpaymodes=","+specialpaymodes+",";
	websys_setfocus("AmountToPay");
	websys_setfocus("PayMode");
	var invno=GetCtlValueById("CurNo");
	var Amount=GetCtlValueById("Amount");
	if ((""!=invno)&&(parseFloat(Amount)!=0))
	{
		if (BAddobj) BAddobj.disabled=false;
		BBillobj.disabled=false;
		if (BAddRoundobj) BAddRoundobj.disabled=false;
	}
	RefreshChild()	
	RunSingReceiveAmt();
	//websys_setfocus("AmountToPay");
	var Name="";
	obj=document.getElementById("GetInvName");
	if (obj) Name=obj.value;
	if (parent.parent.ALertWin) parent.parent.ALertWin.SetDisplayValue(Name,Amount,"");
	//parent.parent.ALertWin.SetIAmount(Amount);
	websys_setfocus("PayMode");
}
function RefreshChild()
{
	var rowid =""
	var objtbl=document.getElementById('tDHCPEPreAuditPay');	
	if (objtbl)
	{
		if (objtbl.rows.length>1) rowid=GetCtlValueById("RowIDz1");			
	}
	RefreshFeeList(rowid);	
}
function RefreshFeeList(rowid){
	parent.frames["DHCPEFeeList"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEFeeList&PreAudits='+rowid;
}
function SelectRowHandler(){  


	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEPreAuditPay');
	
	if (objtbl){ var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	var rowid=""
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
		//ShowCurRecord(selectrow);
		SelectedRow = selectrow;
		rowid=GetCtlValueById("RowIDz"+selectrow);
		
	}
	else{ SelectedRow=0; }
	RefreshFeeList(rowid)
}
function InitBillInfo()
{
	///xml print requird
	
	
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

function InitListEvent()
{
	var chargedStatus,status,i,objChk;
	var objtbl=document.getElementById('tDHCPEPreAuditPay');
	if (!objtbl) return;
	
	var rows=objtbl.rows.length; 
	
	for (i=1;i<=rows;i++)
	{
		objChk=document.getElementById('TSeclectz'+i);
		if (objChk)
		{
			chargedStatus=document.getElementById('ChargedStatusz'+i);
			if ((chargedStatus)&&(chargedStatus.innerText=="未收费"))
			{
				objChk.disabled=false;
				objChk.onclick=Chk_Click;
					
				objChk.checked=true;
				/*status=document.getElementById('AuditedStatusz'+i);
				
				if ((status)&&((status.innerText=="已审核")||(status.innerText=="不需审核")))
				{	
					objChk.disabled=false;
					objChk.onclick=Chk_Click;
					
					objChk.checked=true;					
				}*/
			}
		}
	}			
	Chk_Click();	
}

function Chk_Click()
{
	//var eSrc = window.event.srcElement;
	
	var amount = Calculate();
	var Name="";
	obj=document.getElementById("GetInvName");
	if (obj) Name=obj.value;
	if (parent.parent.ALertWin) parent.parent.ALertWin.SetDisplayValue(Name,amount,"");
	var sswrAmount=parseFloat(amount).toFixed(1);
	var PayMode="";
	var obj=document.getElementById("PayModeDR");
	if (obj)PayMode=obj.value;
	//if (PayMode==1){
	//	SetCtlValueById("Amount",sswrAmount,0);
	//}else{
	//var amount=commafy(amount)
		SetCtlValueById("Amount",amount,0);
	//}
	
	SetCtlValueById("sswrAmount",sswrAmount,0);
}

function Calculate()
{
	
	var encmeth,amount;
	
	ids=""
	amount=0;
	var obj=document.getElementById('GetAuditAmount');
	if (obj) 
    	{encmeth=obj.value;}
    else
    	{return amount}
    
    ids=GetSelectedIds();
    try{
	    //alert(ids);
	    if (ids!="") amount=cspRunServerMethod(encmeth,'','',ids)
    }
	catch(e)
	{	alert(e.message);		}
    return amount;
}

function GetSelectedIds()
{
	var i,objChk,ids;
	var objtbl=document.getElementById('tDHCPEPreAuditPay');
	ids="";
	if (!objtbl) return ids;
	
	var rows=objtbl.rows.length; 
	for (i=1;i<=rows;i++)
	{
		objChk=document.getElementById('TSeclectz'+i);
		if ((objChk)&&(objChk.checked==true))
		{
			if (ids!="") ids=ids+",";
			ids=ids+document.getElementById('RowIDz'+i).value;			
		}
	}
	return ids;
}

function BAdd_Click()
{
	if (!BAddobj.disabled) AddNewRow();
}



function AddNewRow()
{
	var tbl=GetParentTable("PayMode");
	if (tbl)
	{		
		var endrow=GetCtlValueById("EndRow");
		var counter=GetCtlValueById("Counter");
		if (counter=="") counter=0;		
		counter=parseInt(counter)+1;
		endrow=parseInt(endrow)+1
		SetCtlValueById("EndRow",endrow,0);
		SetCtlValueById("Counter",counter,0);
		tbl.insertRow(endrow);
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();              //add by zhouli
		var htmlex="<IMG id='PayModeLookup"+counter+"' src='../images/websys/lookup.gif' onclick='PayMode_Click();' >"
		tbl.rows[endrow].cells[0].innerHTML="<input id='PayMode"+counter+"' name='PayMode"+counter+"' onkeydown='PayMode_KeyDown();' onchange='PayMode_KeyUp();' >"+htmlex;
		CloneStyle("PayMode","PayMode"+counter);
		tbl.rows[endrow].cells[1].innerHTML="<input id='AmountToPay"+counter+"' name='AmountToPay"+counter+"' onchange='Amount_Change();' onkeydown='Amount_KeyDown();' >";
		CloneStyle("AmountToPay","AmountToPay"+counter);
		tbl.rows[endrow].cells[2].innerHTML="<input id='No"+counter+"' onchange=No_Change(); name='No"+counter+"'>";
		CloneStyle("No","No"+counter);
		tbl.rows[endrow].cells[3].innerHTML="<a href='#' id='BDelete"+counter+"' name='BDelete"+counter+"' onclick='DelRow();'><img SRC='../images/websys/delete.gif' BORDER='0'></A>";
		tbl.rows[endrow].cells[4].innerHTML="<input id='PayMode"+counter+"DR' name='PayMode"+counter+"DR' type='hidden'>";
		tbl.rows[endrow].cells[5].innerHTML="<input id='PayMode"+counter+"Code' name='PayMode"+counter+"Code' type='hidden'>"      //add by zhouli 
		websys_setfocus("PayMode"+counter);
		
	}	
}

function DelRow()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var tb=GetParentTable("PayMode");
	if (tb) 
	{
		tb.deleteRow(rowObj.rowIndex);
		var endrow=GetCtlValueById("EndRow");		
		endrow=parseInt(endrow)-1
		SetCtlValueById("EndRow",endrow,0);
		SetChange(0);
	}
	
}

function CloneStyle(source,target)
{
	var objSource=document.getElementById(source);
	if (!objSource) return;
	var objtarget=document.getElementById(target);
	if (!objtarget) return;
	objtarget.style.width=objSource.style.width;
}
function No_Change()
{
	var obj,CardNo="",Counter="",encmeth="",PayModeID="",ExpStr=""; 
	obj=window.event.srcElement;
	CardNo=obj.value;
	Counter=obj.id.split("No")[1];
	obj=document.getElementById("PayMode"+Counter+"DR");
	if (obj) PayModeID=obj.value;
	var peAdmType=GetCtlValueById("ADMType");
	var peAdmId=GetCtlValueById("GIADM");
	encmeth=GetCtlValueById("GetCardAmount");
	ExpStr=CardNo;
	var ret=cspRunServerMethod(encmeth,PayModeID,ExpStr);
	obj=document.getElementById("Balance");
	if (obj) obj.value=ret;
}
function PayMode_KeyUp()
{
	var eSrc=window.event.srcElement;
	var objDR=document.getElementById(eSrc.name+"DR");
	objDR.value="";	
}

function GetParentTable(ename)
{
	var obj=document.getElementById(ename);
	if (!obj) return null;
	while(obj!=null)
	{
		obj=obj.parentElement;
		if ((obj)&&(obj.tagName.toUpperCase()=="TABLE")) return obj;
	}
	return null;
}

function BBilled_click()
{	
	if (BBillobj.disabled) return;
	
	ybkFlag=0;
	var ret=CheckData();
	
	if (ret!="") 
	{	alert(ret);
		return;}
	if (payedInfo=="") return;
	

	
	
	var userId=session['LOGON.USERID'];
	var locId=session['LOGON.CTLOCID'];
	var invNo=GetCtlValueById("CurNo");
	var invId=GetCtlValueById("InvID");
	var peAdmType=GetCtlValueById("ADMType");
 
	var peAdmId=GetCtlValueById("GIADM");
	var encmeth,amount;
	// add by zhouli start----------------------
	var CurrRegNo=""
	var CardAccID="";                    
	var myCardTypeValue="";
	if (CardFlag=="Y")
	{
		var obj=document.getElementById("CurRegNo");  //得到当前操作的人员对应的登记号
		if (obj) CurrRegNo=obj.value;
		var frm=parent.parent.frames[0]; 
		var CardTypeDefineObj=frm.document.getElementById("CardTypeDefine");
		if (CardTypeDefineObj){
			var myIdx=CardTypeDefineObj.options.selectedIndex;
			if(myIdx>=0){
				myCardTypeValue=CardTypeDefineObj.options[myIdx].value;
			}
		}
		if (myCardTypeValue!="") m_SelectCardTypeDR=myCardTypeValue.split("^")[0];
		
		if (m_SelectCardTypeDR==""){
	
		}else{
			var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
		}
		var Ret=myrtn.split("^");
		if (Ret[0]!="0")
		{
			alert("帐户不正确")
			return false;
		}
		var flag=Ret[0];
		CardAccID=Ret[7];
		
		var obj=document.getElementById("CheckAccount");
	   	if (obj)		
		{
			var encmeth=obj.value;
			var ReturnStr=cspRunServerMethod(encmeth,CardAccID,CurrRegNo);
		  	if (ReturnStr=="1"){alert("请用本人卡账户进行消费!");return false; }
		}
		var Obj=document.getElementById("GetBalanceByID");
	
		if (Obj)
		{
			var encmeth=Obj.value;
			var BalanceStr=cspRunServerMethod(encmeth,CardAccID,CardFee);
			var Balance=BalanceStr.split("^")[0]
			var ReturnStr=BalanceStr.split("^")[1]
	         }     
	        if(parseFloat(Balance)<parseFloat(CardFee)){alert("卡余额不足"+ReturnStr);return;}
		
	    	var obj=document.getElementById("CardID");
		if (obj) {obj.value=CardAccID}    
        } // add by zhouli end-------------	
		
	amount=GetCtlValueById("Amount");	
	var obj=document.getElementById('GetCashier');
	if (obj){
		encmeth=obj.value;
	}else{
		alert(t['NoCashier']);
		return;	
	}
    
	var listFlag=GetListFlag(peAdmType);
    
	payedInfo=payedInfo+"#"+CardAccID; 				 	// add by zhouli 
    
	var payedLength=payedInfo.split("^").length;
	var InsuObj=document.getElementById("InsuPay");
	var InsuFlag="N";
	if (InsuObj&&InsuObj.checked)
	{
		InsuFlag="Y"
		if (payedLength>1)
		{
		    alert("医保客人,只能使用一种支付方式.");
		    return;
		}
	}
	var InvName="";
	var obj=document.getElementById("InvName");
	if (obj) InvName=obj.value;
	var invNo=invNo+"^"+InvName
	//验证是否可以结算
	//preAuditIds, crmOrderIds, amount, payedInfo,userId,locId)
	ret=cspRunServerMethod(encmeth,'','',ids,"",amount,payedInfo,userId,locId,invNo,invId,peAdmType,peAdmId,listFlag,"1");
	if (ret!="")
	{
		alert(t['Failed']+"  Err:"+ret);
		return;
	}
	
	var CardInfo=GetCardInfo(payedInfo);
	var CardInfoArr=CardInfo.split("^");
	var CardNo=CardInfoArr[0];
	var OriginBalance=CardInfoArr[1];
    
	//真正结算
	//preAuditIds, crmOrderIds, amount, payedInfo,userId,locId)
	ret=cspRunServerMethod(encmeth,'','',ids,"",amount,payedInfo,userId,locId,invNo,invId,peAdmType,peAdmId,listFlag,"0");
	
	var CardInfo=GetCardInfo(payedInfo);
	var CardInfoArr=CardInfo.split("^");
	var CardNo=CardInfoArr[0];
	var AfterBalance=CardInfoArr[1];
	var Cost=OriginBalance-AfterBalance;
	Cost=Cost.toFixed(2);
	
	var encmeth=GetCtlValueById("GetCurrDateTime");
	var DateTime=cspRunServerMethod(encmeth);
	var Delim=String.fromCharCode(2);
	var TxtInfo="CardNo"+Delim+CardNo;
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+Cost;
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+AfterBalance;
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime;
    
	tmp=ret.split("^");
 
    if (tmp[0]=="") 
    {   
	    if (tmp[1]!="")
	    {
	    	if (payedInfo.split(",")[0]=="1"){
	    		RunSingPaidAmt();
	    	}
	    	if (InsuFlag=="Y")
		    {
			var ExpStr="^^5^CHANGETOYB^";
	    		try
				{
					var ret=InsuPEDivide("0",tmp[1],userId,ExpStr,"","N");
	    			var InsuArr=ret.split("^");
	    			var ret=InsuArr[0];
	    			if ((ret=="-3")||(ret=="-4"))
	    			{ 
	    			//回滚刚收费的发票
	    			 	var obj=document.getElementById("DeleteInvInfo");
					 	if (obj)
				    	{
							var encmeth2=obj.value;
							var Return=cspRunServerMethod(encmeth2,tmp[1],userId);
							if (Return=="") { 
								alert("医保结算失败");return false ;}
							else {
								alert(Return);return false ;
							}
                    	}
	    			}
                    if (ret=="-1")
                    {
	                    if (parent.parent.ALertWin) parent.parent.ALertWin.SetIAmount(amount);
	                  alert("医保结算失败,本次收费为全自费")
		    		}
	   
	    		
	    			else{
		    			if (parent.parent.ALertWin) parent.parent.ALertWin.SetIAmount(InsuArr[2]);
		    			alert("医保结算成功,病人自费金额为:"+InsuArr[2])
		    		
	    			}
				}
	    		catch(e){
			
					alert("调用医保失败^"+e.message)
				}
	    		
		    }else{
			    if (parent.parent.ALertWin) parent.parent.ALertWin.SetIAmount(amount);
		    }
		    	
			// add by zhouli start----------------  
			if (CardAccID!="") {
				var Obj=document.getElementById("getCardAmountClass");     
				if (Obj)
				{
					var encmeth=Obj.value;
					var Balance=cspRunServerMethod(encmeth,CardAccID);
				}
				alert("卡余额："+Balance)
			}// add by zhouli end----------------
		var InvListFlag=listFlag;
		if (tmp[3]==1) InvListFlag=0;    
	    	PrintBill(tmp[1],InvListFlag);
	    	if (tmp[3]==1){
	    		PrintInvDetail(tmp[2],1);
	    	}
            //BarCodePrint(tmp[1])    //参数为发票ID      add by zl       
            //RisInfoPrint(tmp[1])    //参数为发票ID    add by zl 
	    }
	    else
	    {
		    alert("支付成功")
	   	    PrintInvDetail(tmp[2],1);
		  //PrintTJYJJDetails(amount,peAdmType,peAdmId)  //体检预交金时调用
	    }
	    
	    if (CardNo!="") PrintBalance(TxtInfo);
	    
    	var PreInvPrtInfo=tmp[1]+"$"+payedInfo+"$"+amount;
    	var lnk=location.href;
    	var index=lnk.indexOf("&PreInvPrtInfo=");
    	if (index>-1)
    	{
    	tmp=lnk.substring(index,lnk.length);    	
    	lnk=lnk.substring(0,index);
    	}
    	lnk=lnk+"&PreInvPrtInfo="+PreInvPrtInfo;
    	//parent.location.reload();
    	//location.reload();	    
	    }
	else
	{	alert(t['Failed']+"  Err:"+ret);
	}	
}

function PayMode_Click()
{
	var eSrc=window.event.srcElement;
	payModeName=eSrc.id;
	if (payModeName.indexOf("PayModeLookup")==-1)
	{	payModeName="PayMode";}
	else
	{	payModeName=payModeName.replace("PayModeLookup","PayMode");}
	var url='websys.lookup.csp';
	url += "?ID=&CONTEXT=K"+"web.DHCPE.Cashier:GetCashierMode";
	url += "&TLUJSF=SetPayMode";
	websys_lu(url,1,'');
	return websys_cancel();
	
}

function ReadYBCard_click()
{
	var INSUCHUANG=ReadINSUCardfrm("","ZY")//读医保卡
}

function PayMode_KeyDown()
{
	if (event.keyCode==13)
	{
		var eSrc=window.event.srcElement;
		payModeName=eSrc.id;		
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.Cashier:GetCashierMode";
		url += "&TLUJSF=SetPayMode";
		websys_lu(url,1,'');
		return websys_cancel();
		event.keyCode=9
	}
}

function SetPayMode(value)
{
	list=value.split("^");
	SetCtlValueById(payModeName,list[0],0);
	SetCtlValueById(payModeName+"DR",list[1],0);
	SetCtlValueById(payModeName+"Code",list[2],1);       //add by zhouli
	/* 中山三院现金四舍五入其他支付方式不四舍五入
	if (list[1]!=1){
		var AmountValue=GetCtlValueById("Amount");
		SetCtlValueById("AmountToPay",AmountValue,0);}

	else{
		//var AmountValue=GetCtlValueById("Amount");
		//AmountValue=parseFloat(AmountValue).toFixed(1);
		SetCtlValueById("AmountToPay","",0);
	}
	*/
	SetChange(0);
	var amountname=payModeName.replace("PayMode","AmountToPay");
	websys_setfocus(amountname);
}


function CheckData()
{
	return SetChange(1);
}

function Amount_KeyDown()
{
	if (event.keyCode==13)
	{
		Amount_Change(0);
		if (remainfee==0) 
		{
			websys_setfocus("BBilled");
		}
	}
}

///金额变化时计算找零
function Amount_Change()
{
	SetChange(0);
}

function BAddRound_Click()
{
	if (!BAddRoundobj.disabled)	InsertRoundFee();
}

function CheckRoundFee()
{
	roundingfee=GetCtlValueById("Rounding");
	if (""==roundingfee) roundingfee=0;
	var minroundingfee=GetCtlValueById("RoundFeeLimitMin");
	if (minroundingfee=="") minroundingfee=0;
	//if (roundingfee<minroundingfee) return t['OverRoundLimit'];	
	roundingitem=GetCtlValueById("RoundingItem");
	if ((roundingitem=="")&&(roundingfee!=0)) return t['NoRoundFee'];
	return "";
}

function InsertRoundFee()
{	
	var userId=session['LOGON.USERID'];
	var locId=session['LOGON.CTLOCID'];
	var peAdmType=GetCtlValueById("ADMType");
    var peAdmId=GetCtlValueById("GIADM");
    var preoradd="PRE"
    if (""==peAdmId)
    {	alert(t['NoSelectPat']);
	    return;	}
	    
	var err=CheckRoundFee();
	if (""!=err) 
	{	alert(err);
		return;}	
	if (0==roundingfee)
	{	alert("请输入凑整费");
		return;}
	var tbl=document.getElementById('tDHCPEPreAuditPay');	//add  by zl  start
	var row=tbl.rows.length;

    for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		if (obj && obj.checked) 
		{
		var PAuditRowid=GetCtlValueById("RowIDz"+iLLoop);
	
		}
    }									//add  by zl  end
	var encmeth=GetCtlValueById('GetPreIAdm',1);
	var peAdmId=cspRunServerMethod(encmeth, peAdmType,peAdmId)
	if (""==peAdmId)
    {	alert(t['NoSelectPat']);
	    return;	}
	if ("I"==peAdmType) preoradd="ADD"	    
	peAdmType="PERSON";
	
	encmeth=GetCtlValueById('txtIsExistItem',1);
	flag=cspRunServerMethod(encmeth,peAdmId, peAdmType, roundingitem, "")
    if ("1"==flag) {
    	if (!(confirm("已经存在凑整费?是否再增加?"))) {  return false; }
    }
    roundingitem=roundingitem+"&"+roundingfee;
    //alert(peAdmType+" "+peAdmId+" "+roundingitem+ " " +roundingfee+" "+preoradd);
    encmeth=GetCtlValueById('txtAddBox',1);
    //alert(peAdmId+";"+peAdmType+";"+preoradd+";"+roundingitem+";"+""+";"+userId)
    flag=cspRunServerMethod(encmeth,peAdmId, peAdmType,preoradd,roundingitem, "",userId)

	if (flag=="Notice"){
		alert("已审核,需取消审核!");
		return false;
	}
    if (flag!="") {
	   	alert(t['ErrSave']+":"+flag);
	   	return false;
    }
   	location.reload();
}

function SetInvNo()
{
	var userId=session['LOGON.USERID'];
	var obj=document.getElementById('GetInvNo');
	if (obj) 
		{encmeth=obj.value;}
    else
    	{	alert(t['NoCorrectInv']);
	    	return ;	}
    
    ret=cspRunServerMethod(encmeth,userId)
   
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]==""))
    	{	alert(t['NoCorrectInv']);  		}
    SetCtlValueById("CurNo",invNo[0],0);
    SetCtlValueById("InvID",invNo[1],0);    
    return ;
}

function PrintBill(invid,listFlag)
{   
  	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	var peAdmType=GetCtlValueById("ADMType");
	var encmeth=GetCtlValueById("GetInvoiceInfo");
	var TxtInfo=cspRunServerMethod(encmeth,peAdmType,invid)

	var encmeth=GetCtlValueById("GetInvoiceList");
	var ListInfo=cspRunServerMethod(encmeth,peAdmType,invid,listFlag)
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

// 打印体检支付卡余额
function PrintBalance(TxtInfo)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTBalance");
	var myobj=document.getElementById("ClsBillPrint");
	var Delim=String.fromCharCode(2);
	var TxtInfoHosp=TxtInfo+"^"+"BottomRemark"+Delim+"(持卡人存根)";
	DHCP_PrintFun(myobj,TxtInfoHosp,"");
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(商户存根)";
	DHCP_PrintFun(myobj,TxtInfoPat,"");
}

function PrintTest()
{
	//DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	var ListInfo="";
	var c=String.fromCharCode(2);
	var TxtInfo="PatName"+c+"testabc";
	var TxtInfo=TxtInfo+"^"+"RegNo"+c+"1231231";
	var TxtInfo=TxtInfo+"^"+"CGJC"+c+"5";
	var TxtInfo=TxtInfo+"^"+"PaySumPY"+c+"伍元整";
	var TxtInfo=TxtInfo+"^"+"PaySum"+c+"5.00";
	var TxtInfo=TxtInfo+"^"+"OpenID"+c+"123-123";
	var TxtInfo=TxtInfo+"^"+"InvNo"+c+"323423421";
	var TxtInfo=TxtInfo+"^"+"Date"+c+"2007-4-27";
	
	var myobj=document.getElementById("ClsBillPrint");
	//"Star NX-500"
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function HiddenRoundFee()
{
	HideElement("Rounding");
	HideElement("cRounding");
	HideElement("BAddRound");	
}

function HideElement(id)
{
	var obj=document.getElementById(id);
	if (obj) obj.style.display="none";
}

function BReprint_Click()
{
	Refund();
}

function Refund()
{
	var userId=session['LOGON.USERID'];
	var locId=session['LOGON.CTLOCID'];
	var invNo=GetCtlValueById("CurNo");
    var invId=GetCtlValueById("InvID");
    var peAdmType=GetCtlValueById("ADMType");
    var peAdmId=GetCtlValueById("GIADM");
    
    var preInvPrtInfo=GetCtlValueById("PreInvPrtInfo");
    var list=preInvPrtInfo.split("$");
	var InvPrtId=list[0];
	var payedInfo=list[1];
	var newInvAmount=list[2];
	
	var listFlag=GetListFlag(peAdmType);
	//alert(listFlag);
    //return;
	
	if ((InvPrtId==""))
	{
		alert(t['NoPreInvInfo']);
		return;
	}
	
	if (-1==payedInfo) return;
	
	var encmeth=GetCtlValueById("GetRefund");
    var ret=cspRunServerMethod(encmeth,InvPrtId,userId,locId,"",payedInfo,newInvAmount,invNo,invId,peAdmType,peAdmId,1);
    
    var tmp=ret.split("^");
    if (tmp[0]=="")
    {	
    	alert(t['SuccessReprint']);
    	if (ret!="") PrintBill(tmp[1],listFlag);
    	//parent.frames["DHCPEInvList"].location.reload();
    	//
    	var PreInvPrtInfo=tmp[1]+"$"+payedInfo+"$"+newInvAmount;
    	var lnk=location.href;
    	var index=lnk.indexOf("&PreInvPrtInfo=");
    	if (index>-1)
    	{
    		tmp=lnk.substring(index,lnk.length);    	
    		lnk=lnk.substring(0,index);
    	}
    	lnk=lnk+"&PreInvPrtInfo="+PreInvPrtInfo;
    	location.href=lnk;
    	//location.reload();	
	}
	else
	{	alert(t['FailedReprint']+"  Err:"+tmp[0]);	}	
}

function SetNextPayModeValue()
{
	var Src=window.event.srcElement;
	var CurID=Src.id;
	var Sort=Src.id.split("AmountToPay")[1];
	if (Sort==""){
		Sort=1;
	}else{
		Sort=(+Sort)+1;
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
		Amt=(+Amt)+(+obj.value);
	}
	var obj=document.getElementById(NextID);
	//alert("TotalAmt"+TotalAmt)
	//alert("Amt  "+Amt)
	var objpluse=(+TotalAmt).toFixed(2)-(+Amt).toFixed(2);
	objpluse=objpluse.toFixed(2);
	//alert(objpluse)
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
	amount=GetCtlValueById("Amount");
	CashierMin=GetCtlValueById("CashierMin");
	remainfee=0;
	var i;
	var cashierfee=0;
	var changefee=0;
	var totalAmount=0;	
	var amount=GetCtlValueById("Amount");
	if ((amount=="")||(amount<=0))
	{
		return t['NoAmount'];
	}
	
	var counter=GetCtlValueById("Counter");
	
	if (counter=="0")
	{ 
		var AmountValue=GetCtlValueById("AmountToPay");
		if (AmountValue=="")
	   {
		var AmountValue=GetCtlValueById("Amount");
        SetCtlValueById("AmountToPay",AmountValue,0);
       }
	}
	counter=parseInt(counter);
	CardFlag="N"    //Add by zhouli
	CardFee=0       //Add by zhouli
	for (i=0;i<=counter;i++)
	{
		if (i==0)
		{ suffix="";}
		else
		{ suffix=i;}
		
		obj=document.getElementById("PayMode"+suffix)
		if (obj)
		{
			paymode=GetCtlValueById("PayMode"+suffix+"DR");
		    
			var AmountValue=GetCtlValueById("AmountToPay");
			if (AmountValue=="")
			{
				
			var amount=GetCtlValueById("Amount"); //GetCtlValueById("sswrAmount");
		
			SetCtlValueById("AmountToPay",amount,0);
			}
			
			tmppaymode=","+paymode+",";
			payamount=GetCtlValueById("AmountToPay"+suffix);  ////Add by zhouli
			paymodecode=GetCtlValueById("PayMode"+suffix+"Code"); //Add by zhouli
		
			if (paymodeids.indexOf(tmppaymode)>-1)
			{
				return t['RepeatPayMode'];
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
			
			payamount=GetCtlValueById("AmountToPay"+suffix);
			//payamount=GetCtlValueById("OldAmount");
			/*
			if (paymode=="15")
			{
				ybkFlag="1";
				ybkAmount=payamount;
			}*/
			no=GetCtlValueById("No"+suffix);
			if (paymode=="")
			{
				websys_setfocus("PayMode"+suffix)
				return t['NoPayMode'];
			}
			if (GetCtlValueById("PayMode"+suffix)=="")
			{
				websys_setfocus("PayMode"+suffix)
				return t['NoPayMode'];
			}
			if ((payamount=="")||(isNaN(payamount)==true)) 
			{
				websys_setfocus("AmountToPay"+suffix)
				SetCtlValueById("Change",0,0);
				return t['NoPayedAmount'];
			}		
			if (paymodecode=="CPP")      //add by zhouli
			{  
				CardFlag="Y"
				CardFee=payamount         //add by zhouli
			}		
			if (parseFloat(payamount)<=0)
			{
				websys_setfocus("AmountToPay"+suffix)
				SetCtlValueById("Change",0,0);
				return t['NoPayedAmount'];				
			}
			
			if (defaultpaymode==paymode)
			{
				cashierfee=parseFloat(payamount);				
				totalAmount=totalAmount+parseFloat(payamount);				
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
	
	//changefee=parseFloat(cashierfee)+parseFloat(totalAmount)-parseFloat(sswrAmount);
	
	sswrAmount=GetCtlValueById("sswrAmount");
	//totalAmount=GetCtlValueById("AmountToPay"+suffix)
	if (paymode=="1")
	{
		
	changefee=parseFloat(totalAmount)-parseFloat(amount); //parseFloat(sswrAmount);
	}
	else{
		changefee=parseFloat(totalAmount)-parseFloat(amount);
	}
	
	changefee=changefee.toFixed(2);
	//alert("changefee:"+changefee)
	SetCtlValueById("Change",changefee,0);
	//alert("ischeck  :"+ischeck)
	
	if (1==ischeck)
	{
		if (parseFloat(changefee)<0)
		{
			var Insurance=GetCtlValueById("GetInsurance");
			if (Insurance=="")
			{
				return t['Lower'];
			}
			else
			{
				if (Insurance!="Y")
				{
					if (!confirm("剩余金额"+(-changefee)+"使用保险支付?"))
					{
						return t['Lower'];
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
				{	return t['NoPayedAmount'];}
				cashierfee=parseFloat(cashierfee)-parseFloat(changefee);
				if (""!=payedInfo) payedInfo=payedInfo+"^";
				payedInfo=payedInfo+defaultpaymode+","+cashierfee+",";
			}
			else
			{
				if (hasSpecialPayMode==1)
				{
					var href="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPayMode&PayAmount="+changefee+"&CashierInfo="+defaultpaymode+"^"+CashierMin;
					var ret=showModalDialog(href,'','',"dialogHeight:200px;dialogWidth:300px;center:yes;help:no;resizable:no;status:no;")
					if (!ret||""==ret)
					{
						payedInfo=""; 
						return "";
					}
					if (""!=payedInfo) payedInfo=payedInfo+"^";
					payedInfo=payedInfo+ret;
				}
				else
				{
					return t['FailedAmount'];
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
		/*
		if (Insurance=="Y")
		{
			if (""!=payedInfo) payedInfo=payedInfo+"^";
			payedInfo=payedInfo+"13"+","+(-changefee)+",";
		}*/
		//alert(changefee)
		return "";
	}	
}

function GetListFlag(admtype)
{
	if (admtype!="I") return 0;
	var obj=document.getElementById("ListFlag");
	if (!obj)
	{
		obj= document.getElementById("HiddenListFlag");		
		if (!obj) return 0;
		if (obj.value=="1") return 1;
		return 0;
	}
	if (obj.checked==true) return 1;
	return 0;
}
//2009-07-24  汪庆权
//打印分类Checkbox的click事件 
function PrintCatFlag_Click()
{
   var	catFlag = document.getElementById("PrintCatFlag");
   var Instring = "";
   Instring = catFlag.checked.toString();
   var Ins = document.getElementById('ins');
   if (Ins)
   {
      var encmeth = Ins.value;
   }
   else
   {
      var encmeth = '';
   }
	var obj = document.getElementById('PAADM');
    if(obj){var PAADM=obj.value}
    
   cspRunServerMethod(encmeth, "", "", Instring,PAADM);
}



function BarCodePrint(InvPrtID)

{	  
   var peAdmType=GetCtlValueById("ADMType");
    var Char_2=String.fromCharCode(2);
    var obj=document.getElementById('GetIADMIDBox');
	if (obj) {var encmeth=obj.value; } else {var encmeth=''; }
	var Value=cspRunServerMethod(encmeth,InvPrtID,peAdmType); 
	if (Value==""){return;}
	var PAADMStr=Value.split("^")
	for (var i=0;i<PAADMStr.length;i++)
	{ var PAADM=PAADMStr[i]
    var Ins=document.getElementById("PatOrdItemInfo");
	if (Ins) {var encmeth1=Ins.value; } else {var encmeth1=''; };
	var flag=cspRunServerMethod(encmeth1,"BarPrint","",PAADM,"N","N");
    if (peAdmType=="G") {return;
	    //RisGInfoPrint(InvPrtID,PAADM)
	    }
	 else {RisInfoPrint(InvPrtID)}
	}
	/*
	//打印病人基本信息条码
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCPEPersonInfo");
	OnePersonInfoCodePrint(PAADM);
	*/
}

function BarPrint(value) {
 
    if (""==value) {

		return false;
	}
	if (value=="NoPayed")
	{
		alert(t["NoPayed"])
		return false;
	}
	var ArrStr=value.split("$$");
	var Num=0
	if (ArrStr.length>1) Num=ArrStr[1];
	value=ArrStr[0];
	PrintBarApp(value,"")
	return;
    
	}
	
function printBaseInfo(PAADM)
{   
 
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfoNew.xls';
	}else{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") ;
    var PatInfo=Patstr.split("^") 
    var Regno=PatInfo[0]
    var SexDesc=PatInfo[1]
    var Age=PatInfo[2]
    var Name=PatInfo[3]
	
       xlsheet.cells(1,1).Value=Regno;
	   xlsheet.cells(2,1).Value=Name+" "+SexDesc+" "+Age ; 
	   xlsheet.cells(3,1).Value="*"+Regno+"*";
	   xlsheet.Rows(2).Font.Size=12;
    xlApp.Visible = true;
    xlApp.UserControl = true;	
 
}
function RisInfoPrint(InvPrtID)

{  
  var peAdmType=GetCtlValueById("ADMType");
  
   var Char_2=String.fromCharCode(2);
   DHCP_GetXMLConfig("InvPrintEncrypt","PERisInfoPrint");

    var Ins=document.getElementById('GetRisItemInfo');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var InfoString=cspRunServerMethod(encmeth,InvPrtID,"N"); 
	var vals=InfoString.split("%");
    var InfoStr=vals[0]
    var PatInfo=vals[1]

    var TxtInfo=""
	 var ItemStr=InfoStr.split(";");  

	  if (ItemStr=="")
	   { 
	     return;}	
     for (var i=0;i<ItemStr.length;i++)
         
		   {   
		    var ItemDesc=ItemStr[i]
			TxtInfo=PatInfo+"^"+"ItemDesc"+Char_2+ItemDesc; 
			var myobj=document.getElementById("ClsBillPrint");
	        DHCP_PrintFun(myobj,TxtInfo,"");

		     }
	

}
function RisGInfoPrint(InvPrtID,PAADM)
{  
   var Char_2=String.fromCharCode(2);
   DHCP_GetXMLConfig("InvPrintEncrypt","PERisInfoPrint");

    var Ins=document.getElementById('GetGRisItemInfo');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,InvPrtID,PAADM);
	var StrInfo=value.split("%");
    var InfoStr=StrInfo[0]
    var PatInfo=StrInfo[1]
     var TxtInfo=""
	 var ItemStr=InfoStr.split(";");  
	 /*
	 if (ItemStr=="")
	 {	var myobj=document.getElementById("ClsBillPrint");
	    DHCP_PrintFun(myobj,PatInfo,"");
		 return;}*/
     for (var i=0;i<ItemStr.length;i++)
         
		   {   
		    var ItemDesc=ItemStr[i]
			TxtInfo=PatInfo+"^"+"ItemDesc"+Char_2+ItemDesc; 
			var myobj=document.getElementById("ClsBillPrint");
	        DHCP_PrintFun(myobj,TxtInfo,"");

		     }
		     /*
		var myobj=document.getElementById("ClsBillPrint");
	    DHCP_PrintFun(myobj,PatInfo,"");*/

}
function PrintInvByPreAudit()
{
	
	var IDs=GetSelectedIds();
	if (IDs=="") return false;
	var ListInfo=tkMakeServerCall("web.DHCPE.CashierEx","GetListInfo",IDs)
	
	var TxtInfo=tkMakeServerCall("web.DHCPE.CashierEx","GetTextInfo",IDs)
	PrintDetail(TxtInfo,ListInfo);
}
function PrintInvDetail(invid,listFlag)
{
	var peAdmType=GetCtlValueById("ADMType");
	var encmeth=GetCtlValueById("GetInvoiceInfo");
	var TxtInfo=cspRunServerMethod(encmeth,peAdmType,invid,"List");
	var encmeth=GetCtlValueById("GetInvoiceList");
	var ListInfo=cspRunServerMethod(encmeth,peAdmType,invid,listFlag,"1");
	PrintDetail(TxtInfo,ListInfo);
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}
function PrintDetail(TxtInfo,ListInfo)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function PrintTJYJJDetails(Amount,Type,PEAdmId)
{ 
   

    var obj=document.getElementById('GetPABalance');
	if (obj) {
   var encmeth=obj.value; } else { 
   var encmeth=''; }
   var PABalance=cspRunServerMethod(encmeth,Type,PEAdmId);

	try{
		var obj;
		obj=document.getElementById("prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPECashierTJYJJDetails.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		
		xlApp = new ActiveXObject("Excel.Application");  
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  
		xlsheet = xlBook.WorkSheets("Sheet1"); 
		var user=session['LOGON.USERCODE'] 
	    	var obj=document.getElementById('CurDate');
		if(obj){var CurDate=obj.value}
		 xlsheet.cells(1,2)=Amount+"元"
		 xlsheet.cells(2,2)=PABalance+"元"
		 xlsheet.cells(3,2)=CurDate
		
	
   		xlsheet.Print
   		xlApp.Visible = true;
   		xlApp.UserControl = true;  
   		window.close();
	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
  }
  
function commafy(num){

   if((num+"").Trim()==""){

      return"";

   }

   if(isNaN(num)){

      return"";

   }

   num = num+"";

   if(/^.*\..*$/.test(num)){

      var pointIndex =num.lastIndexOf(".");

      var intPart = num.substring(0,pointIndex);

      var pointPart =num.substring(pointIndex+1,num.length);

      intPart = intPart +"";

       var re =/(-?\d+)(\d{3})/

       while(re.test(intPart)){

          intPart =intPart.replace(re,"$1,$2")

       }

      num = intPart+"."+pointPart;

   }else{

      num = num +"";

       var re =/(-?\d+)(\d{3})/

       while(re.test(num)){

          num =num.replace(re,"$1,$2")

       }

   }

    return num;

}
/**

 * 去除千分位

 *@param{Object}num

 */
function delcommafy(num){

   if((num+"").Trim()==""){

      return"";

   }

   num=num.replace(/,/gi,'');

   returnnum;

}

function GetCardInfo(payedInfo) {
	var Balance="";
	var CardNo="";
	var CardInfo="";
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
			encmeth=GetCtlValueById("GetCardAmount");
			var Balance=cspRunServerMethod(encmeth,PayModeDR,ExpStr);
			var CardNo=ExpStr;
		}
	}
	CardInfo=CardNo+"^"+Balance;
	return CardInfo;
}

function PrintAccSheet(CardNo,Cost){
	if (CardNo=="") return;
	if (Cost=="") return;
	
	var PayModeDR=21;
	var CurrentBalance=tkMakeServerCall("web.DHCPE.AdvancePayment","GetAPAmount",PayModeDR,CardNo);
	var DateTime=tkMakeServerCall("web.DHCPE.Cashier","GetDateTimeStr");
	
	var Delim=String.fromCharCode(2);
	var TxtInfo="CardNo"+Delim+CardNo;
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+Cost;
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+CurrentBalance;
	
	PrintBalance(TxtInfo);
	
}


document.body.onload = BodyLoadHandler;

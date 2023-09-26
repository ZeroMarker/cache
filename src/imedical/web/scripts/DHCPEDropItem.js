var paymodecount=0;
var newInvAmount=0;
var OnePayMode=0;
var CardFlag="" 
//页面初始化
function BodyLoadHandler()
{
	//Test();
	var obj;
	obj=document.getElementById("SelectR");
	if (obj) {obj.onclick=Register_Select;}
	obj=document.getElementById("BRefund");
	if (obj) obj.onclick=BRefund_Click;
	obj=document.getElementById("BReprint");
	if (obj) obj.onclick=BReprint_Click;
	obj=document.getElementById("BAllRefund");
	if (obj) obj.onclick=BAllRefund_Click;
	obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	//是不退费申请??默认??sApply=1 表示退费
	var isApply=1
	obj=document.getElementById("isApply");
	if(obj){
		isApply=obj.value;
	}
	if(isApply==""){
		var objTemp =parent.frames["DHCPEInvList"].document.getElementById("isApplyTemp")
		if(objTemp){isApply=objTemp.value.split("$")[0]}
		
	}
	if(isApply==1){		//+ add by wangfujian 2009-04-16
		InButtonInfo();
		InitInvInfo();	
		InitListInfo();	
		GetBackAmount();
		InitApplyButton(isApply);
		InitBillInfo();
		InitChecked(isApply); //+ add by wangfujian 2009-04-16
	}else{
		InitInvInfo();		
		InitListInfo();		
		GetBackAmount();
		InitApplyButton(isApply);
		InitChecked(isApply);
		if (isApply==2) InitBillInfo();		 //add+
	}
	var lnk=location.href;                    //add by zhouli START
    var index=lnk.indexOf("&Balance");
    var BalanceValue="";
    	if (index>-1)
    	{
    	BalanceValue=lnk.substring(index,lnk.length);
    	BalanceValue=BalanceValue.split("=")[1];
	
    	}
    var obj=document.getElementById("Balance");
	if (obj)obj.value=BalanceValue;	                  //add by zhouli end
	//SetCtlValueById
	var BackAmount=GetCtlValueById('BackAmount');
	var NewAmount=GetCtlValueById('NewAmount');
	NewAmount=NewAmount-BackAmount;
	//SetCtlValueById("NewAmount",NewAmount,0)
	SetCtlValueById("NewAmount",NewAmount.toFixed(2),0)
	

}


function InButtonInfo()
{
	var invId=GetCtlValueById("InvPrtId");
	var flag=tkMakeServerCall("web.DHCPE.ItemFeeList","GetApplyRefundFlag",invId)
	if(flag=="1"){
		obj =document.getElementById("BAllRefund");
		if(obj){obj.style.display="none";}
	}
	if(flag=="0")
	{
		obj =document.getElementById("BRefund");
		if(obj){obj.style.display="none";}
	}
	
}

///creator:wangfujian
///creatdate:2009-04-19
///description:初始化退费申请按钮?隐藏?退费,重打发票,全退,当前发票号,退费金额
function InitApplyButton(flag){
	
	var paymodeinfos= GetCtlValueById("GetPayModeInfo");
	if (paymodeinfos=="") return;
	var paymodeinfoStr=paymodeinfos.split("%%");
	var paymodeinfo=paymodeinfoStr[0].split("&");
	var paymodecount = paymodeinfo.length;

	//退费金额
	if (flag==1)
	{
		obj =document.getElementById("BReprint");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
		obj=document.getElementById("BPrint");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
		return
	}
	if(paymodecount=="1"){
	var obj =document.getElementById("RefundAmount0");
	if(obj){
		obj.disabled=true;
		obj.style.display="none";
	}
	///退费金额标签
	obj =document.getElementById("cRefundAmount0");
	if(obj){
		obj.disabled=true;
		obj.style.display="none";
	}
	}
	if (flag==0)
	{
		//当前发票文本输入框
		
		obj =document.getElementById("CurNo");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
		///当前发票标签
		obj =document.getElementById("cCurNo");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
	}
	if (flag==0){
		///重打发票 按钮
		obj =document.getElementById("BReprint");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
	}
	///全退 按钮
	obj =document.getElementById("BAllRefund");
	if(obj){
		obj.disabled=true;
		obj.style.display="none";
	}
	if (flag==0){
		///把退费 按钮变成 退费申请
		obj =document.getElementById("BRefund");
		if(obj){
			//obj.innerText="全退申请";
			obj.innerHTML='<img SRC="../images/uiimages/backbill.png" BORDER="0"> 全退申请'
			obj.onclick=RefundApplyOnClick;
			//obj.style.display="none"
			
			
		}
	}
	else{
		obj =document.getElementById("BRefund");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
		obj=document.getElementById("BPrint");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
	}
	if(flag==2){

	var obj=document.getElementById("NoPrintInv");
		if(obj){ 
		if(obj.checked) { 
			obj =document.getElementById("BReprint");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		     }
		   }
		}

	var paymodeinfos= GetCtlValueById("GetPayModeInfo");
	if(paymodeinfos.indexOf("体检代金卡")>-1){
		obj =document.getElementById("BReprint");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
		}
	if(paymodeinfos.indexOf("体检预交金")>-1){
		obj =document.getElementById("BReprint");
		if(obj){
			obj.disabled=true;
			obj.style.display="none";
		}
		}
	}

}
///creator:wangfujian
///creatdate:2009-04-19
///description:退费申请 事件处理函数
function RefundApplyOnClick(){
	var obj =document.getElementById("BRefund");
	if(obj.disabled){
		return;
	}
	
	//取回发票号
	var invPrtId=""
	var objInvPrtId=document.getElementById("InvPrtId");
	if(objInvPrtId){
		 invPrtId=objInvPrtId.value;
	}
	
	//申请的记录写到globle当中
	var encache=document.getElementById("SetApplyRefund");
	if(encache){
		encache=encache.value;
	}
	var flag=cspRunServerMethod(encache,invPrtId,"AllRefund")
	
	var obj =document.getElementById("BRefund");
	if(flag==1){
		alert("全退申请成功!");
	}else{
		alert("全退申请失败!");
		obj.disabled=true;
	}
}
///creator:wangfujian
///creatdate:2009-04-19
///description:退费时?初始化选择框?和SelectIds 的值
function InitChecked(isApply){
	
	//取回发票号
	var invPrtId=""
	var SelectIds=""
	var objInvPrtId=document.getElementById("InvPrtId");
	if(objInvPrtId){
		 invPrtId=objInvPrtId.value;
	}

	var objTemp =parent.frames["DHCPEInvList"].document.getElementById("isApplyTemp")
	
	var flag=1
	if(objTemp){
		
		flag=objTemp.value.split("$")[1];
		if(objTemp.value.split("$")[0]==1) flag=0;
	}

	//先把globle的SelectIds值给取回来,falg=1,取临时globle的值
	var encache=document.getElementById("GetApplyRefund");
	if(encache){
		encache=encache.value;
		SelectIds=cspRunServerMethod(encache,invPrtId,flag);
	}
	//设置SelectIds中的值
	SetCtlValueById("SelectIds",SelectIds,0);
	
	var objTemp =parent.frames["DHCPEInvList"].document.getElementById("isApplyTemp")
		if(objTemp){objTemp.value=isApply+"$1"}
	var SelectArray="";
	
	//退费总金额
	var backAmount=0;
	
	///初始化选择框
	var objtbl=document.getElementById('tDHCPEDropItem');
	if (!objtbl) return;
	
	var rows=objtbl.rows.length; 
	
	for (i=1;i<=rows;i++)
	{
		
		var objType=document.getElementById('TFeeTypeDescz'+i);
		if (objType){var FeeTypeDesc=objType.innerText;}
		
		var objId=document.getElementById('TRowIdz'+i);
		if (objId){
			if(FeeTypeDesc=="项目"){SelectArray=SelectIds.split("1^"+objId.value);}
			if(FeeTypeDesc=="套餐"){SelectArray=SelectIds.split("2^"+objId.value);}
		  
		}
		
		var objChk=document.getElementById('TCheckedz'+i);
		//设置选择框是不是可以改变
		if (objChk)
		{
			if (SelectArray.length==2)
			{
				objChk.checked="checked";
			}		
			if(isApply!=0){
				objChk.disabled = true; 
			}else{
				var objStatus=document.getElementById('TOrdStatusz'+i);
				if (objStatus){
					 objStatus=objStatus.value;	 
				}
				if (objStatus==0)
				{
					objChk.disabled = false ; 
					objChk.onclick=Chk_Click;
				}
				else
				{
					objChk.disabled = true; 
				}
				if (SelectArray.length==2)
				{
					objChk.disabled = false ; 
					objChk.onclick=Chk_Click;
				}
			}
			//alert(objChk.disabled);
		}
		
	}
	
	var backAmount=0
	if(SelectIds!=""){	
		var backAmount=SelectIds.split(";")[1];
	}else{
		var obj=document.getElementById("NewAmount");
		if (obj) var backAmount=obj.value;
	}
	
	//alert(backAmount+"设置好初始退费金额")
	///设置好初始退费金额

	var objBackAmount=document.getElementById('BackAmount');
	if(objBackAmount){
		//objBackAmount.disabled=false;
		objBackAmount.value=backAmount;
		if (OnePayMode==1){
			var obj=document.getElementById('RefundAmount0');
			if (obj) obj.value=backAmount;
		}
	}
	
}

function InitBillInfo()
{
	///xml print requird
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
	obj=document.getElementById("CurNo");
	if (obj) obj.readOnly=true;
	SetInvNo();
}

function InitInvInfo()
{
	var paymodeinfos= GetCtlValueById("GetPayModeInfo");
	if (paymodeinfos=="") return;
	var paymodeinfoStr=paymodeinfos.split("%%");
	var paymodeinfo=paymodeinfoStr[0].split("&");
	//var paymodeinfo=paymodeinfos.split("&");
	paymodecount = paymodeinfo.length;
	for(var I = 0; I < paymodecount; I++)
	{
		var paymode=paymodeinfo[I].split("^");
		if (0!=I) AddNewRow(I);
		SetCtlValueById("PayModeDR"+I,paymode[0],0);
		SetCtlValueById("PayMode"+I,paymode[1],0);
		SetCtlValueById("PayedAmount"+I,paymode[2],0);
		SetCtlValueById("PayedAmount"+I,paymode[2],0);
		SetCtlValueById("No"+I,paymode[3],1);
		var CardNo=GetCtlValueById("No"+I);
		var obj=document.getElementById("No"+I);
		if(obj){
		  obj.onkeydown=No_onkeydown;
		}

		//SetCtlValueById("RefundAmount"+I,amount,0);
	}
	if (I==1) OnePayMode=1;
}

function No_onkeydown(e){
	if (window.event.keyCode==13) {
		obj=window.event.srcElement;
		 CardNo=obj.value;
		if(CardNo==""){
			alert("请输入卡号");
			return false;
		}
	Counter=obj.id.split("No")[1]; 
	obj=document.getElementById("NewPayMode"+Counter);
	if (obj) PayModeID=obj.value;
	if(PayModeID==""){
		     alert("请选择新支付方式");
			return false;
			}
	
	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","GetAPAmount",PayModeID,CardNo);
	obj=document.getElementById("Balance");
	if (obj) obj.value=ret;

	}
}


/*
function AddNewRow(index)
{
	var endrow=index+2;
	var tbl=GetParentTable("PayMode0");
	if (tbl)
	{		
		tbl.insertRow(endrow);
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].cells[0].innerHTML="<input id='PayMode"+index+"' name='PayMode"+index+"' disabled=true >";
		CloneStyle("PayMode0","PayMode"+index);
		tbl.rows[endrow].cells[1].innerHTML="<input id='PayedAmount"+index+"' name='PayedAmount"+index+"' disabled=true >";
		CloneStyle("PayedAmount0","PayedAmount"+index);
		tbl.rows[endrow].cells[2].innerHTML="<input id='RefundAmount"+index+"' name='RefundAmount"+index+"'>";
		CloneStyle("RefundAmount0","RefundAmount"+index);
		tbl.rows[endrow].cells[3].innerHTML="<input id='No"+index+"' name='No"+index+"' type='hidden'>";
		tbl.rows[endrow].cells[4].innerHTML="<input id='PayModeDR"+index+"' name='PayModeDR"+index+"' type='hidden'>";
	}	
}
*/
function AddNewRow(index)
{
	var endrow=index+1;
	var tbl=GetParentTable("PayMode0");
	if (tbl)
	{		
		tbl.insertRow(endrow);
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		tbl.rows[endrow].insertCell();
		
		tbl.rows[endrow].insertCell();
		
		tbl.rows[endrow].cells[0].innerHTML="<input id='PayMode"+index+"' name='PayMode"+index+"' disabled=true >";
		
		CloneStyle("PayMode0","PayMode"+index);
		tbl.rows[endrow].cells[1].innerHTML="<input id='PayedAmount"+index+"' name='PayedAmount"+index+"' disabled=true >";
		CloneStyle("PayedAmount0","PayedAmount"+index);
		tbl.rows[endrow].cells[2].innerHTML="<input id='RefundAmount"+index+"' name='RefundAmount"+index+"'>";
		CloneStyle("RefundAmount0","RefundAmount"+index);
		tbl.rows[endrow].cells[3].innerHTML="<input id='No"+index+"' name='No"+index+"'>";
		CloneStyle("No0","No"+index);
		var innerText=tbl.rows[1].cells[4].innerHTML;
		innerText=innerText.replace(/NewPayMode0/ig,'NewPayMode'+index);
		tbl.rows[endrow].cells[4].innerHTML=innerText;
		//CloneStyle("PayMode0","PayMode1"+index);
		
		
		tbl.rows[endrow].cells[5].innerHTML="<input id='PayModeDR"+index+"' name='PayModeDR"+index+"' type='hidden'>";
		CloneStyle("PayModeDR0","PayModeDR"+index);
		
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

function InitListInfo()
{
	var status,i,objChk;
	var readonly=GetCtlValueById("ReadOnly");
	if (readonly==1) return;
	var objtbl=document.getElementById('tDHCPEDropItem');
	if (!objtbl) return;
	
	var rows=objtbl.rows.length; 
	for (i=1;i<=rows;i++)
	{
		status=GetCtlValueById('TOrdStatusz'+i)
		if (status!=1)
		{
			objChk=document.getElementById('TCheckedz'+i);
			if (objChk)
			{
			objChk.disabled=false;
			objChk.onclick=Chk_Click;
			}
		}		
	}	
}

function Chk_Click()
{
	
	var eSrc = window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	var currAmount=0;
	var currAmountObj=document.getElementById('TFactAmountz'+selectrow)
	if(currAmountObj){
		currAmount=currAmountObj.innerText;
	}
	var addflag=eSrc.checked;
	var backAmount=0;
	
	var SelectIds=GetCtlValueById("SelectIds");

	if(SelectIds!=""){
		
		backAmount=SelectIds.split(";")[1];
		SelectIds=SelectIds.split(";")[0];
		
		
	}
	backAmount=Number(backAmount);
	currAmount=Number(currAmount);
	var invPrtId=GetCtlValueById("InvPrtId");
	var feeid=GetCtlValueById('TFeeTypez'+selectrow)+"^"+GetCtlValueById('TRowIdz'+selectrow);
	//药品权限控制 如果已退药不允许取消申请
	var enControl=document.getElementById("DrugPermControl");         //add by zl start
	if(enControl){
		var encmeth=enControl.value;
	}                                          
	var flag=cspRunServerMethod(encmeth,feeid,"0",invPrtId)
	if(flag=="2"){
		alert("发送退药申请失败");
	   return false;
	}

	if (flag=="1") 
	{alert(t['HadDropDrug']);
	 return false;}                                               //add by zl end
	if (addflag)
	{	if (SelectIds=="") SelectIds=SelectIds+","		
		SelectIds=SelectIds+feeid+",";
		//backAmount=backAmount+currAmount;
		backAmount=parseFloat(backAmount+currAmount).toFixed(2);
	}
	else
	{	SelectIds=SelectIds.replace(","+feeid+",",",");
		if (SelectIds==",") SelectIds="";
		backAmount=parseFloat(backAmount-currAmount).toFixed(2);
		if(GetCtlValueById('TOrdStatusz'+selectrow)=="1"){
		
			var obj=document.getElementById('TCheckedz'+selectrow)
			if(obj){
				obj.disabled=true
			}
			
		}

	}
	
	//将selectIds保存到临时的globle中
	var invPrtId=GetCtlValueById("InvPrtId");
	var encache=document.getElementById("SetApplyRefund");
	if(encache){
		encache=encache.value;
	}
	var flag=cspRunServerMethod(encache,invPrtId,SelectIds,"temp",backAmount)
	//alert("backAmount"+backAmount)
	SetCtlValueById("SelectIds",SelectIds+";"+backAmount,0);
	
	SelectIds=GetCtlValueById("SelectIds");
	var objTemp =parent.frames["DHCPEInvList"].document.getElementById("isApplyTemp")
		if(objTemp){
			isApply=objTemp.value.split("$")[0];
			objTemp.value=isApply+"$"+SelectIds;
		
		}
		
		
	var obj =document.getElementById("BackAmount");
	if(obj){obj.value=backAmount}

	var PayedAmount0=GetCtlValueById('PayedAmount0');
	NewAmount=PayedAmount0-backAmount;
	SetCtlValueById("NewAmount",NewAmount.toFixed(2),0)

	/*
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEDropItem&InvPrtId='+GetCtlValueById("InvPrtId");
	lnk=lnk+'&ADMType='+GetCtlValueById("ADMType")+'&GIADM='+GetCtlValueById("GIADM");
	lnk=lnk+"&SelectIds="+SelectIds;
	location.href=lnk;	
	*/
}

function GetBackAmount()
{
	var SelectIds=GetCtlValueById("SelectIds");
	var encmeth=GetCtlValueById("GetAmount");
    var amount=cspRunServerMethod(encmeth,SelectIds);
    SetCtlValueById("BackAmount",amount,0);
    
}

function BReprint_Click()
{
	/*
	var invId=GetCtlValueById("InvPrtId");
	alert(invId);
	PrintBill(invId);
	return;
	*/
	Refund(1,0);
}

function Refund(IsReprint,IsAllRefund)
{
	var frm=parent.frames[0]; 									//add by zhouli start ----取上界面的登记号
	var TopRow=frm.SelectedRow										
	if (TopRow=="-1") {var TopRow=1}
	var CurrRegNo=""
	var obj=frm.document.getElementById('TRegNo'+'z'+TopRow)
	if(obj){var CurrRegNo=obj.innerText}                             //add by zhouli end-------------------
	var userId=session['LOGON.USERID'];
	var locId=session['LOGON.CTLOCID'];
	var HospitalID=session['LOGON.HOSPID'];
	var invNo=GetCtlValueById("CurNo");
	//var invNo=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",invNo);
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId)
	var invNo=ret.split("^")[0];

	var InvName=GetCtlValueById("InvName");
	invNo=invNo+"^"+InvName;
	
	var NoPrintInv="0";
  	var obj=document.getElementById("NoPrintInv");
  	if (obj&&obj.checked) NoPrintInv="1";
  	invNo=invNo+"^"+NoPrintInv;
	
    	var invId=GetCtlValueById("InvID");
    	var peAdmType=GetCtlValueById("ADMType");
    	var peAdmId=GetCtlValueById("GIADM");
    
	var InvPrtId=GetCtlValueById("InvPrtId");
	var SelectIds=GetCtlValueById("SelectIds");

	if ((InvPrtId==""))
	{
		alert("请先选择发票");
		return;
	}

	if ((SelectIds=="")&&(IsReprint==0))
	{
		alert(t['NoSelect']);
		return;
	}
	if ((SelectIds!="")&&(IsReprint==1))
	{
		alert(t['Selected']);
		return;
	}
	//if (IsReprint=="1")
	if ((IsReprint=="1")&&(IsAllRefund=="0"))
	{
		SetCtlValueById("BackAmount",0,0);
		SetCtlValueById("RefundAmount0",0,0);
	}
	//药品权限控制 如果退费时，药品仍是发药状态，进行提示需先退药     //add by zl start
	var enControl=document.getElementById("DrugPermControl");
	if(enControl){
		var encmeth=enControl.value;
	}
	
	var flag=cspRunServerMethod(encmeth,InvPrtId,"1") //退费
	if (flag=="1") 
	{alert(t['HadDispensing']);
	 return false;}                                               //add by zl start
	var payedInfo=GetPayModeInfo(IsAllRefund);
	
	if (-1==payedInfo) return;
	
	var AccPayModeInfo=GetAccPayModeInfo(IsAllRefund);
	
	var InsuID="",InsuFlag=0;
	var InsuObj=document.getElementById("InsuID");
	if (InsuObj) InsuID=InsuObj.value;
	var AdmReason="";
	
	if (InsuID!=""){
		var obj=document.getElementById("AdmReason");
		if (obj) AdmReason=obj.value;
		if (AdmReason==""){
			alert("费别不能为空");
			return false;
		}
		invNo=invNo+"^"+AdmReason;
		
		var ExpStr="^N"
		try
		{
			var ret=InsuPEDivideStrik("0",InsuID,userId,ExpStr,"","N")
			if (ret!="0"){
				alert("医保退费失败,请和信息中心联系");
				return false;
			}
		}
		catch(e){
			alert("调用医保失败,请和信息中心联系^"+e.message)
			return false;
		}
		InsuFlag=1;
	}else{
		invNo=invNo+"^"+AdmReason;
	}


	
	var listFlag=GetListFlag(peAdmType);                                                      
	var AccID="";             // add by zhouli start  20120718-----------------
    if (CardFlag=="1")
    {
	 	//var obj=document.getElementById("GetDefaultTypeStr");   //得到卡消费卡类型
		//if (obj){myCardTypeValue=obj.value}
		
		var frm=parent.frames[0]; 
		myCardTypeValue=frm.combo_CardType.getSelectedValue()
		var CardTypeID=myCardTypeValue.split("^")[0];
		var myrtn=DHCACC_GetAccInfo(CardTypeID,myCardTypeValue);
      	var myary=myrtn.split("^");
		var rtn=myary[0];
		switch (rtn){
		case "0":
			AccID=myary[7];
			break;
		case "-200": 
			alert('卡无效');
			break;
		case "-201" :	
			break;
		default:
		}

    	if (AccID==""){alert("卡消费请读卡!");return false;}  
    	var obj=document.getElementById("CurrRegNo");
	   
	 	var obj=document.getElementById("CheckAccount");
	    if (obj)		
		{
		var encmeth=obj.value;
		var ReturnStr=cspRunServerMethod(encmeth,AccID,CurrRegNo);
	  	if (ReturnStr=="1"){alert("请用本人卡账户进行消费!");return false; }
		}  
    }                                                                             
    	var RefuntInfo=""+"^"+AccID+"^"+""  		// add by zhouli end -------------------
    	
    	var CardInfo=GetCardInfo(AccPayModeInfo);	
    	var CardInfoArr=CardInfo.split("^");
			var CardNo=CardInfoArr[0];
			var OriginBalance=CardInfoArr[1];
			
			//alert("008 payedInfo=="+payedInfo+"  AccPayModeInfo=="+AccPayModeInfo+"  CardInfo=="+CardInfo+"  RefuntInfo=="+RefuntInfo);
			//return;
    var TaxpayerNum="";
    var obj=document.getElementById("TaxpayerNum");
    if (obj) TaxpayerNum=obj.value;
    var invNo=invNo+"^"+TaxpayerNum;

	var encmeth=GetCtlValueById("GetRefund");
	var ret=cspRunServerMethod(encmeth,InvPrtId,userId,locId,SelectIds,payedInfo,newInvAmount,invNo,invId,peAdmType,peAdmId,IsReprint,listFlag,IsAllRefund,RefuntInfo,HospitalID);
   //alert("ret=="+ret);
   
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
	//alert("009 TxtInfo=="+TxtInfo);
   
    disabledButton();
    var tmp=ret.split("^");
    if (tmp[0]=="")
    {	
    	if (IsReprint==0) 
    	{
    		alert(t['Success']+t['InvInfo']);
    	}
    	else
    	{
	    	if (IsAllRefund=="0") alert(t['SuccessReprint']+t['InvInfo']);
    		if (IsAllRefund=="1") alert(t['Success']+t['InvInfo']);
    	}
    	 var Obj=document.getElementById("getCardAmountClass");                   // add by zhouli start------------  求卡余额
         if (Obj){
					var encmeth=Obj.value;
					var Balance=cspRunServerMethod(encmeth,AccID);
		   }
				var objBalance=document.getElementById("Balance");   
			       if (objBalance) {objBalance.value=Balance;} 
	if (AccID!=""){alert("卡账户余额:"+Balance)}		    
    	if (ret!=""&&IsAllRefund=="0"){
	    	
	    	
    		if (InsuFlag=="1")
    		{
    			var ExpStr="^^5^CHANGETOYB^";
	    		try
			{
				var ret=InsuPEDivide("0",tmp[1],userId,ExpStr,AdmReason,"N");
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
								alert("医保结算失败，重收不成功");return false ;}
							else {
								alert(Return);return false ;
							}
                    	}
	    			}
                    if (ret=="-1")
                    {
	                    alert("医保结算失败,本次重收费为全自费")
		    		}
	   
	    		
	    			else{
		    			alert("医保结算成功,病人自费金额为:"+InsuArr[2])
		    		
	    			}
			}
	    		catch(e)
	    		{
					alert("调用医保失败,本次收费为全自费^"+e.message)
			}
    		}
    	
    		PrintBill(tmp[1],tmp[2],tmp[3]);
    	}
    	
    	//alert("CardNo=="+CardNo+"  Cost=="+Cost);
    	if ((CardNo!="")&&(parseFloat(Cost)<-0.01)) {
    		PrintBalance(TxtInfo);
    	}
    	
    	//parent.frames["DHCPEInvList"].location.reload();
        var lnk=location.href;                                                                    
    	lnk=lnk+"&Balance="+objBalance.value;
    	window.location.href=lnk; 	    
    }
    else
    {
		if (InsuFlag=="1")
		{
			alert("医保已经退费成功,体检退费失败,请和信息中心联系")
		}
		else if (IsReprint==0) 
			{alert(t['Failed']+"  Err:"+tmp[0]);}
		else
			{alert(t['FailedReprint']+"  Err:"+tmp[0]);}
	}
}
function PrintInvDetail(invid,listFlag)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");
	var peAdmType=GetCtlValueById("ADMType");
	var encmeth=GetCtlValueById("GetInvoiceInfo");
	var TxtInfo=cspRunServerMethod(encmeth,peAdmType,invid,"List");
	var encmeth=GetCtlValueById("GetInvoiceList");
	var ListInfo=cspRunServerMethod(encmeth,peAdmType,invid,listFlag,"1");
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}
function BAllRefund_Click()
{
	Refund(1,1);
	return;
}
function BRefund_Click()
{
	
	Refund(0,0);
	return;
	var userId=session['LOGON.USERID'];
	var locId=session['LOGON.CTLOCID'];
	var invNo=GetCtlValueById("CurNo");
    var invId=GetCtlValueById("InvID");
    var peAdmType=GetCtlValueById("ADMType");
    var peAdmId=GetCtlValueById("GIADM");
    
	var InvPrtId=GetCtlValueById("InvPrtId");
	var SelectIds=GetCtlValueById("SelectIds");
	var payedInfo=GetPayModeInfo();
	if (-1==payedInfo) return;
	
	var encmeth=GetCtlValueById("GetRefund");
	return false
	var ret=cspRunServerMethod(encmeth,InvPrtId,userId,locId,SelectIds,payedInfo,newInvAmount,invNo,invId,peAdmType,peAdmId);
  
    var tmp=ret.split("^");
    if (tmp[0]=="")
    {	alert(t['Success']);
    	
    	if (ret!="") PrintBill(tmp[1]);
    	
    	parent.frames["DHCPEInvList"].location.reload();
    	location.reload();	    
	}
	else
	{	alert(t['Failed']+"  Err:"+tmp[0]);}
}

function GetPayModeInfo(IsAllRefund)
{
	var i,amount,backamount,backtotal,remainamount;
	var total;
	var paymodeinfos="";
	var CanChangePayModes=GetCtlValueById('CanChangePayModes');
	CanChangePayModes=","+CanChangePayModes+",";
	backtotal=0;
	newInvAmount=0
	var ErrInfo="";
	var peAdmId=GetCtlValueById("GIADM");

	//alert(paymodecount)
	for (i=0;i<paymodecount;i++)
	{
		amount=GetCtlValueById('PayedAmount'+i);
		backamount=GetCtlValueById('RefundAmount'+i);
		if (isNaN(backamount)==true) 
		{
			alert(t['ErrAmount']);
			return -1;
		}		
		if (backamount=="") backamount=0;
		remainamount=parseFloat(amount)-parseFloat(backamount);
		//alert(remainamount)
		if (remainamount<0)
		{
			var tmppaymodedr=GetCtlValueById('PayModeDR'+i);
			tmppaymodedr=","+tmppaymodedr+",";
			if (CanChangePayModes.indexOf(tmppaymodedr)==-1)
			{alert(t['ErrAmount']);
			return -1;}
		}		
		backtotal=parseFloat(backtotal)+parseFloat(backamount);
		newInvAmount=newInvAmount+remainamount;
		if (IsAllRefund=="1")	 //全退  20120718 需要修改支付方式ID
		{
			if ((GetCtlValueById('PayModeDR'+i)=="3"))  CardFlag="1"
		}                                         //如果有预交金支付
	    else
	   	{
			if ((GetCtlValueById('PayModeDR'+i)=="3")&&(parseFloat(backamount)!=""))  CardFlag="1"  
		}	
		if (remainamount!=0)
		{
			if (paymodeinfos!="") paymodeinfos=paymodeinfos+"^";
			paymodeinfos=paymodeinfos+GetCtlValueById('PayModeDR'+i);
			paymodeinfos=paymodeinfos+","+remainamount;
			paymodeinfos=paymodeinfos+","+GetCtlValueById('No'+i);
			//alert(GetCtlValueById('No'+i))
			paymodeinfos=paymodeinfos+","+parseFloat(backamount);
			paymodeinfos=paymodeinfos+","+GetCtlValueById('NewPayMode'+i);
		
			var OldPayMode=GetCtlValueById('PayModeDR'+i);
			var NewPayMode=GetCtlValueById('NewPayMode'+i);
			var No=GetCtlValueById('No'+i);
			var Info=tkMakeServerCall("web.DHCPE.CashierEx","JudgeTJKRemainAmount",peAdmId,remainamount,NewPayMode,No,OldPayMode);
			//if(Info!="") var ErrInfo=ErrInfo+","+Info;
			if(Info!="") var ErrInfo=Info;

			
		}
	}
	total=GetCtlValueById('BackAmount');
	//alert(backtotal)
	//alert(total)
	//alert("backtotal=="+backtotal+"   total=="+total);
	if (backtotal!=total)
	{ 	
		alert(t['ErrSum']);
		return -1;
		}
			
	if(ErrInfo!=""){
		alert(ErrInfo);
		return -1;
	}

	return paymodeinfos;
}

function SetInvNo()
{	
	var userId=session['LOGON.USERID'];
	var encmeth=GetCtlValueById("GetInvNo");
    ret=cspRunServerMethod(encmeth,userId)
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]==""))
    	{	alert(t['NoCorrectInv']);  		}
    
	if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    SetCtlValueById("CurNo",No,0);

    //SetCtlValueById("CurNo",invNo[0],0);
    SetCtlValueById("InvID",invNo[1],0);    
    return ;
}

function PrintBill(invprtid,relInvPrtID,PrintListFlag)
{
	var peAdmType=GetCtlValueById("ADMType");
	var listFlag=GetListFlag(peAdmType);
	if (invprtid=="")
	{
		//PrintInvDetail(relInvPrtID,listFlag);
		alert("退费成功")
		return false;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
	///var c=String.fromCharCode(2);
	var encmeth=GetCtlValueById("GetInvoiceInfo");
	var TxtInfo=cspRunServerMethod(encmeth,peAdmType,invprtid);
	
	var encmeth=GetCtlValueById("GetInvoiceList");
	var InvListFlag=listFlag;
	if (PrintListFlag==1) InvListFlag=0;
	var ListInfo=cspRunServerMethod(encmeth,peAdmType,invprtid,InvListFlag)
	//alert(ListInfo);
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	if (PrintListFlag==1){
	    		PrintInvDetail(invprtid,1);
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
function disabledButton()
{
	///重打发票 按钮
	obj =document.getElementById("BReprint");
	if(obj){
		obj.disabled=true;
	}
	///全退 按钮
	obj =document.getElementById("BAllRefund");
	if(obj){
		obj.disabled=true;
	}
	///退费按钮
	obj =document.getElementById("BRefund");
	if(obj){
		obj.disabled=true;
	}
}

function Register_Select()
{
var Src=window.event.srcElement;

var tbl=document.getElementById('tDHCPEDropItem');//取表格元素?名称
var row=tbl.rows.length;

for (var iLLoop=1;iLLoop<=row;iLLoop++)
 {
obj=document.getElementById('TChecked'+'z'+iLLoop);
if (obj) {
	if(obj.disabled==false)
	{
	obj.checked=!obj.checked;
	var currAmount=0;
	var currAmountObj=document.getElementById('TFactAmountz'+iLLoop)
	if(currAmountObj){
		currAmount=currAmountObj.innerText;
	}
	var addflag=obj.checked;
	var backAmount=0;
	
	var SelectIds=GetCtlValueById("SelectIds");

	if(SelectIds!=""){
		
		backAmount=SelectIds.split(";")[1];
		SelectIds=SelectIds.split(";")[0];
		
		
	}
	//alert(backAmount)
	backAmount=Number(backAmount);
	currAmount=Number(currAmount);
	
	var feeid=GetCtlValueById('TFeeTypez'+iLLoop)+"^"+GetCtlValueById('TRowIdz'+iLLoop);
	
	if (addflag)
	{	if (SelectIds=="") SelectIds=SelectIds+","		
		SelectIds=SelectIds+feeid+",";
		//backAmount=backAmount+currAmount;
		backAmount=parseFloat(backAmount+currAmount).toFixed(2);
	}
	else
	{	SelectIds=SelectIds.replace(","+feeid+",",",");
		if (SelectIds==",") SelectIds="";
		//backAmount=backAmount-currAmount;
		backAmount=parseFloat(backAmount-currAmount).toFixed(2);
		if(GetCtlValueById('TOrdStatusz'+iLLoop)=="1"){
		
			var obj=document.getElementById('TCheckedz'+iLLoop)
			if(obj){
				obj.disabled=true
			}
			
		}

	}
	
	//将selectIds保存到临时的globle中
	var invPrtId=GetCtlValueById("InvPrtId");
	var encache=document.getElementById("SetApplyRefund");
	if(encache){
		encache=encache.value;
	}
	
	var flag=cspRunServerMethod(encache,invPrtId,SelectIds,"temp",backAmount)
	//alert("backAmount"+backAmount)
	SetCtlValueById("SelectIds",SelectIds+";"+backAmount,0);
	
	SelectIds=GetCtlValueById("SelectIds");
	var objTemp =parent.frames["DHCPEInvList"].document.getElementById("isApplyTemp")
		if(objTemp){
			isApply=objTemp.value.split("$")[0];
			objTemp.value=isApply+"$"+SelectIds;
		
		}
		
		
	var obj =document.getElementById("BackAmount");
	if(obj){obj.value=backAmount}
	
	}}

 }
}
var idTmr="";
function BPrint_Click()
{
	var invPrtId=GetCtlValueById("InvPrtId");
	if (invPrtId==""){
		alert("没有退费发票");
		return false;
	}
	var info=tkMakeServerCall("web.DHCPE.ItemFeeList","GetRefundInfo",invPrtId)
	if (info==""){
		alert("还没有做退费申请，请选择退费项目或者点击全退申请");
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
	/*
	//打印导检单
	var peAdmType=GetCtlValueById("ADMType");
	if (peAdmType=="G") return;
	CRMId=GetCtlValueById("GIADM");
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Instring=CRMId+"^"+DietFlag+"^IADM";	
	var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);
	Print(value);
	*/
	
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}


function GetCardInfo(payedInfo) {
	//alert("0009 payedInfo=="+payedInfo);
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
		//alert("0009  PayModeArr=="+PayModeArr);
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

// 打印体检支付卡余额
function PrintBalance(TxtInfo)
{
	//alert("TxtInfo=="+TxtInfo);
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTBalance");
	var myobj=document.getElementById("ClsBillPrint");
	var Delim=String.fromCharCode(2);
	var TxtInfoHosp=TxtInfo+"^"+"BottomRemark"+Delim+"(持卡人存根)";
	DHCP_PrintFun(myobj,TxtInfoHosp,"");
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(商户存根)";
	DHCP_PrintFun(myobj,TxtInfoPat,"");
}

function GetAccPayModeInfo(IsAllRefund)
{
	var InvPrtId=GetCtlValueById("InvPrtId");
	var ssr=tkMakeServerCall("web.DHCPE.Cashier","GetssrAmountByInv",InvPrtId); //获取发票的舍入金额

	var i,amount,backamount,backtotal,remainamount;
	var total;
	var paymodeinfos="";
	var CanChangePayModes=GetCtlValueById('CanChangePayModes');
	CanChangePayModes=","+CanChangePayModes+",";
	backtotal=0;
	newInvAmount=0
	//alert(paymodecount)
	for (i=0;i<paymodecount;i++)
	{
		amount=GetCtlValueById('PayedAmount'+i);
		backamount=GetCtlValueById('RefundAmount'+i);
		if (isNaN(backamount)==true) 
		{
			alert(t['ErrAmount']);
			return -1;
		}		
		if (backamount=="") backamount=0;
		//remainamount=parseFloat(amount)-parseFloat(backamount);
		//remainamount=parseFloat(amount)-parseFloat(backamount)-ssr;
        if(i>=1){remainamount=parseFloat(amount)-parseFloat(backamount);}
	    else{remainamount=parseFloat(amount)-parseFloat(backamount)-ssr;}
        if(remainamount<0.01){remainamount=0}
		if (remainamount<0)
		{
			var tmppaymodedr=GetCtlValueById('PayModeDR'+i);
			tmppaymodedr=","+tmppaymodedr+",";
			if (CanChangePayModes.indexOf(tmppaymodedr)==-1)
			{alert(t['ErrAmount']);
			return -1;}
		}		
		backtotal=parseFloat(backtotal)+parseFloat(backamount);
		newInvAmount=newInvAmount+remainamount;
		if (IsAllRefund=="1")	 //全退  20120718 需要修改支付方式ID
		{
			if ((GetCtlValueById('PayModeDR'+i)=="3"))  CardFlag="1"
		}                                         //如果有预交金支付
	    else
	   	{
			if ((GetCtlValueById('PayModeDR'+i)=="3")&&(parseFloat(backamount)!=""))  CardFlag="1"  
		}	
		//if (remainamount!=0)
		if (1)
		{
			if (paymodeinfos!="") paymodeinfos=paymodeinfos+"^";
			paymodeinfos=paymodeinfos+GetCtlValueById('PayModeDR'+i);
			paymodeinfos=paymodeinfos+","+remainamount;
			paymodeinfos=paymodeinfos+","+GetCtlValueById('No'+i);
			paymodeinfos=paymodeinfos+","+parseFloat(backamount);
		}		
	}
	total=GetCtlValueById('BackAmount');
	//alert(backtotal)
	//alert(total)
	//alert("backtotal=="+backtotal+"   total=="+total);
	if (backtotal!=total)
	{ 	alert(t['ErrSum']);
		return -1;}
	return paymodeinfos;
}
function Test()
{
	var DateTime=tkMakeServerCall("web.DHCPE.Cashier","GetDateTimeStr");
	var Delim=String.fromCharCode(2);
	var TxtInfo="CardNo"+Delim+"CardNO";
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+"退的钱";
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+"现在卡余额";
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime;
	PrintBalance(TxtInfo);
}
document.body.onload = BodyLoadHandler;


var SelectedRow=-1
var PayModeLength=0;
function BodyLoadHandler()
{
	
	obj=document.getElementById('BPrintInv');
	if (obj) { obj.onclick = BPrintInv_click; }
	obj=document.getElementById('BPrintDetail');
	if (obj) { obj.onclick = BPrintDetail_click; }
	
	obj=document.getElementById("ReadYBCard");
	if (obj) obj.onclick=ReadYBCard_click;
	
	
	obj=document.getElementById("Find");
	if (obj) {obj.onclick=Find_Click;}

	obj=document.getElementById('RegNo');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	obj=document.getElementById('InvNo');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	obj=document.getElementById('PatName');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_keydown;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	obj=document.getElementById("BPrintProve");
	if (obj) {obj.onclick=BPrintProve_Click;}
	initialReadCardButton()
	document.onkeydown=ShortKeyDown;
	websys_setfocus("InvNo");
	SetInvNo();
}

function SetInvNo()
{ 
	var userId=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]==""))
    	{ alert(t['NoCorrectInv']); 
    	 		}
    	 		   
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    var obj=document.getElementById("CurInvNo");
    if(obj){obj.value=No;}
    
    return ;
}

function ReadYBCard_click()
{
	var INSUCHUANG=ReadINSUCardfrm("","ZY"); //读医保卡
}
function ShortKeyDown()
{
	if (event.keyCode==115)
	{
		obj=document.getElementById("BReadCard");
		if (obj) obj.click();
	}
}
function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}

function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","Find_Click()","","0");
}
function ReadCard_Click()
{
	ReadCardApp("RegNo","Find_Click()","CardNo");
	
}

function SelectRowHandler(){ 
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var rowid=""
	if (!selectrow) return;
	var obj=document.getElementById('InvID');
	if (obj) { obj.value = ""; }
	var obj=document.getElementById('InvName');
	if (obj) obj.value="";
	var obj=document.getElementById('AdmReason');
	if (obj) obj.value="";
	if (selectrow!=SelectedRow) {
		SelectedRow = selectrow;
		rowid=GetCtlValueById("TRowIdz"+selectrow);
		if (rowid=="") return false;
		var obj=document.getElementById('InvID');
		if (obj) { obj.value = rowid; }
		var encmeth=GetCtlValueById("GetInvName");
		var InvName=cspRunServerMethod(encmeth,rowid);
		var Arr=InvName.split("^");
		var obj=document.getElementById('InvName');
		if (obj) obj.value=Arr[0];
		var obj=document.getElementById('AdmReason');
		if (obj) obj.value=Arr[1];
		var obj=document.getElementById("TPayModez"+selectrow);
		if (obj){
			var PayModeStr=obj.innerText;
			PayModeStr=trim(PayModeStr);
			if (PayModeStr==""){
				PayModeLength=0;
			}else{
				PayModeLength=PayModeStr.split(":").length;
			}
		
		}
	}
	else{ SelectedRow=0; }
	
}

function BPrintDetail_click()
{
	PrintInvDetail();
	return false;
}
function RegNo_keydown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		Find_Click();
	}
}


function Find_Click()
{   
   var iRegNo="",iPatName="",iBeginDate="",iEndDate="",iInvNo="",iRPFlag="",iUser="",iEntryLoc="",iFocusPrint="0",iCardNo="",iInvType="0";
   var obj
    obj=document.getElementById("RegNo");
    if (obj) { iRegNo=obj.value};
	
	obj=document.getElementById("PatName");
    if (obj) { iPatName=obj.value};
    obj=document.getElementById("FocusPrint");
    if (obj) iFocusPrint=obj.value;
    
    obj=document.getElementById("BeginDate");
    if (obj) { iBeginDate=obj.value};
	
	obj=document.getElementById("EndDate");
    if (obj) { iEndDate=obj.value};
    
    obj=document.getElementById("InvNo");
    if (obj) { iInvNo=obj.value};

    
    obj=document.getElementById("RPFlag");
    if (obj) { iRPFlag=obj.value};
    
	obj=document.getElementById("User");
    if (obj) { iUser=obj.value};
    obj=document.getElementById("EntryLoc");
    if (obj) { iEntryLoc=obj.value};
    
	var isApply=""
  	obj=document.getElementById("isApply");
	if (obj) { isApply=obj.value};

	var SelfOnlyFlag=GetCtlValueById("SelfOnlyFlag"); 
     
    obj=document.getElementById("CardNo");
    if (obj) { iCardNo=obj.value;}
	
	obj=document.getElementById("InvType");
    if (obj) { iInvType=obj.value;}

  	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEINVFocusPrt"
			+"&RegNo="+iRegNo
			+"&PatName="+iPatName
			+"&BeginDate="+iBeginDate
			+"&EndDate="+iEndDate
			+"&InvNo="+iInvNo
			+"&RPFlag="+iRPFlag
			+"&isApply="+isApply
			+"&SelfOnlyFlag="+SelfOnlyFlag
            +"&User="+iUser
            +"&EntryLoc="+iEntryLoc
            +"&FocusPrint="+iFocusPrint
            +"&CardNo="+iCardNo
			+"&InvType="+iInvType
            ;
    location.href=lnk; 

}
function PrintInvDetail()
{
	var obj=document.getElementById('InvID');
	if (obj) InvID=obj.value;
	var temp=InvID.split("||");
	if ((temp.length)>1 ){ return false;}
	if (obj && ""!=obj.value) {
		var PEINVDR=obj.value;
		var obj=document.getElementById('GetAdmType');
		if (obj) 
		{
			encmeth=obj.value;
			var peAdmType=cspRunServerMethod(encmeth,PEINVDR);
		}
	}
    	else
    	{	
			 alert("请先选择待打印明细的发票记录");	
	    	return ;
	}
    
	var listFlag=GetListFlag(peAdmType);
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");
	var encmeth=GetCtlValueById("GetInvoiceInfo");
	var TxtInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,"List")
	var encmeth=GetCtlValueById("GetInvoiceList");
	var ListInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,1,"1")
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}
function BPrintInv_click()
{
	var encmeth="",InvID="",InvNo="",InvName="",UserID="";
	encmeth=GetCtlValueById("SaveClass");
	InvID=GetCtlValueById("InvID");
	InvNoZM=GetCtlValueById("CurInvNo");
	var InvNo=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvNoZM)
	InvName=GetCtlValueById("InvName");
	var AdmReason="";
	AdmReason=GetCtlValueById("AdmReason");
	if (InvID==""){
		alert("请选择需要打印发票的记录")
		return false;
	}
	if (InvNo==""){
		alert("没有发票号，不能打印发票")
		return false;
	}
	UserID=session['LOGON.USERID'];
	HospitalID=session['LOGON.HOSPID'];
	var InvInfo=InvNo+"^"+InvName+"^"+AdmReason;
	var Ret=cspRunServerMethod(encmeth,InvID,InvInfo,UserID,"1",HospitalID);
	var Arr=Ret.split("^");
	if (Arr[0]!=0){
		alert(Arr[1]);
		return false;	
	}
	
	//是否使用医保重新打印发票
	var InsuObj=document.getElementById("InsuPay");
	var InsuFlag="N";
	if (InsuObj&&InsuObj.checked)
	{
		InsuFlag="Y"
		if (PayModeLength>2){
			alert("医保结算只能是一种支付方式,此记录不允许医保结算。");
			return false;
		}
		if (AdmReason==""){
		  alert("请选择医保对应的费别");
		  return false;
	  	}
	  	
	  	var ExpStr="^^5^CHANGETOYB^";
	    try
		{
			var ret=InsuPEDivide("0",InvID,UserID,ExpStr,AdmReason,"N");
	    	var InsuArr=ret.split("^");
	    	var ret=InsuArr[0];
	    	if ((ret=="-3")||(ret=="-4"))
	    	{ 
	    		alert("医保结算失败，请联系信息中心，或者自费打印");
	        	return false;
	    	}
            if (ret=="-1")
            {
	        	alert("医保结算失败，请联系信息中心，或者自费打印");
	        	return false;
		    }
		    else{
		    	alert("医保结算成功,病人自费金额为:"+InsuArr[2])
		    
	    	}
		}
	    catch(e){
			alert("医保调用失败^"+e.message)
			return false;
		}	
	}
	var InvInfo=InvNo+"^"+InvName+"^"+AdmReason;
	var Ret=cspRunServerMethod(encmeth,InvID,InvInfo,UserID,"0",HospitalID);
	var Arr=Ret.split("^");
	if (Arr[0]!=0){
		var MessageStr=Arr[1];
		if (InsuFlag=="Y"){
			MessageStr=MessageStr+",医保已经结算，请联系信息中心。"
		}
		alert(MessageStr);
		return false;	
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	var obj=document.getElementById('InvID');
	if (obj) InvID=obj.value;
	var InvInfoZM=InvNoZM+"^"+InvName+"^"+AdmReason;
	var temp=InvID.split("||");
	if ((temp.length)>1 ){
		var encmeth=GetCtlValueById("GetAPInvoiceInfo")
		var TxtInfo=cspRunServerMethod(encmeth,InvID,InvInfoZM,"1")
		var ListInfo=cspRunServerMethod(encmeth,InvID,InvInfoZM,"2")
		if (TxtInfo=="") return;
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	}
	else {
		var PEINVDR=obj.value;
		var obj=document.getElementById('GetAdmType');
		if (obj) 
		{
			encmeth=obj.value;
			var peAdmType=cspRunServerMethod(encmeth,PEINVDR);
		}
    		else
    		{	
    			alert(t['NOADMTYPE']);
	    		return ;
	    	}
    
		var listFlag=GetListFlag(peAdmType);
		
		var encmeth=GetCtlValueById("GetInvoiceInfo");
		var TxtInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR)
	    var encmeth=GetCtlValueById("GetInvoiceList");
		var ListInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,listFlag)
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFun(myobj,TxtInfo,ListInfo);
		//location.reload();
	}
	Find_Click();
}

function GetListFlag(admtype)
{
	if (admtype!="I") return 0;
	obj= document.getElementById("HiddenListFlag");		
	if (!obj) return 0;
	if (obj.value=="1") return 1;
	return 0;
	
}

function trim(str)
{
	if(!str || typeof str != 'string') return null;
	return str.replace(/^[\s]+/,'').replace(/[\s]+$/,'').replace(/[\s]{2,}/,' ');
}
function BPrintProve_Click()
{
	var obj=document.getElementById('RPFRowId');
	if (obj && ""!=obj.value) {
		var PEINVDR=obj.value;
		var obj,encmeth;
		obj=document.getElementById("prnpath");
		if (obj&& ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEProvePrt.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		obj=document.getElementById("GetProveInfoClass");
		if (obj) encmeth=obj.value;
		var PrintData=cspRunServerMethod(encmeth,PEINVDR);
		xlApp= new ActiveXObject("Excel.Application"); //固定
		xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
		xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
		var Char_3=String.fromCharCode(3);
		var Char_2=String.fromCharCode(2);
		var DataArr=PrintData.split(Char_3);
		var BaseInfo=DataArr[0];
		var BaseArr=BaseInfo.split("^");
		xlsheet.cells(5,4)=BaseArr[0];
		xlsheet.cells(5,8)=BaseArr[1];
		xlsheet.cells(7,5)=BaseArr[2];
		var Rows=7;
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
		xlsheet.cells(Rows,6)=BaseArr[6];
		xlsheet.printout;
		//xlsheet.SaveAs("d:\\团体异常值汇总.xls");
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null;
	}
}

document.body.onload = BodyLoadHandler;
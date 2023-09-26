//名称	DHCPEInvList.js
//功能	收费收据查询
//组件	DHCPEInvList	
//创建	2018.08.10
//创建人  xy

function BodyLoadHandler()
{  

   var obj;
   
    obj=document.getElementById("Find");
	if (obj) {obj.onclick=Find_Click;}
	
	obj=document.getElementById('RegNo');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	 
	obj=document.getElementById('InvNo');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	obj=document.getElementById('PatName');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	
	 $("#CardNo").change(function(){
  			CardNo_Change();
		});
		
	$("#CardNo").keydown(function(e) {
			
			if(e.keyCode==13){
				CardNo_Change();
			}
			
        });
        

	
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCardClickHandler;}
	//if (obj) {obj.onclick=ReadCard_Click;}
	
	obj=document.getElementById('BGREPrint');
	if (obj) {obj.onclick=BGREPrint_Click; }
	
	obj=document.getElementById("BPrintProve");
	if (obj) {obj.onclick=BPrintProve_Click;}
	
	obj=document.getElementById('Print');
	if (obj) { obj.onclick = Print_click; }
	
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
}
function RegNo_keydown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		Find_Click();
	}
}

function CardNo_Change()
{

 	var obj=document.getElementById("CardNo"); 
	if (obj){ var myCardNo=obj.value;}
	
	if (myCardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","PatInfo",CardTypeCallBack);
		return false;
	//CardNoChangeApp("RegNo","CardNo","Find_Click()","Clear_click()","0");
}

//读卡
function ReadCardClickHandler(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			BFind_click();
			//LoadOutPatientDataGrid();
			event.keyCode=13; 
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			BFind_click();
			//LoadOutPatientDataGrid();
			event.keyCode=13;
			break;
		default:
	}
}
/*
function ReadCard_Click()
{
	ReadCardApp("RegNo","Find_Click()","CardNo");
	
}
*/

function Find_Click()
{   
   var iRegNo="",iPatName="",iBeginDate="",iEndDate="",iInvNo="",iRPFlag="",iUser="",iEntryLoc="",isApply="",SelfOnlyFlag="";
   var obj
    
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	
	iRegNo=getValueById("RegNo");
	if (iRegNo.length<RegNoLength&&iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	
    iPatName=getValueById("PatName");
     
    iBeginDate=getValueById("BeginDate");
    
    iEndDate=getValueById("EndDate");
    
	iInvNo=getValueById("InvNo");
     
    iRPFlag=getValueById("RPFlag");
    
    iUser=getValueById("User");
    
	iEntryLoc=getValueById("EntryLoc");
     
    isApply=getValueById("isApply");
    
    SelfOnlyFlag=getValueById("SelfOnlyFlag");
	
  var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEInvList"
			+"&RegNo="+iRegNo
			+"&PatName="+iPatName
			+"&BeginDate="+iBeginDate
			+"&EndDate="+iEndDate
			+"&InvNo="+iInvNo
			+"&RPFlag="+iRPFlag
			+"&isApply="+isApply
			+"&SelfOnlyFlag="+SelfOnlyFlag
            +"&User="+iUser
            +"&EntryLoc="+iEntryLoc;
            alert(lnk)
    location.href=lnk; 

}
function BGREPrint_Click()
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
	var PEINVDR=getValueById('RPFRowId');
	if (""!=PEINVDR) {
		var obj=document.getElementById('GetAdmType');
		if (obj) 
		{
			encmeth=obj.value;
			var peAdmType=cspRunServerMethod(encmeth,PEINVDR);
			
			var InvNo=getValueById("InvNo");
			if(""==InvNo){
		     alert("发票为退费的负记录,不能打印");
		     return ;
	     }

		}
	}else
    		{ 
    			
    			 alert("请选择要重打发票的记录");
	    		return ;
	    	}
    
		var listFlag=GetListFlag(peAdmType);
		
		var encmeth=GetCtlValueById("GetInvoiceInfo");
		var TxtInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR)
	    var encmeth=GetCtlValueById("GetInvoiceList");
		var ListInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,listFlag)
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}



function Print_click()
{

	PrintInvDetail();
	return false;
	
}
function PrintInvDetail()
{
	
	var PEINVDR=getValueById("RPFRowId");
	if ( ""!=PEINVDR) {
		var obj=document.getElementById('GetAdmType');
		if (obj) 
		{
			encmeth=obj.value;
			var peAdmType=cspRunServerMethod(encmeth,PEINVDR);
	
			var InvNo=getValueById("InvNo");
			if(""==InvNo){
		     alert("发票为退费的负记录,不能打印");
		     return ;
			}else if(obj && obj.value.indexOf("DHCPEYJS")>=0){
				alert("预结算记录,不能打印");
		     	return ;
			}

		}
	}else{	
    	    alert("请选择要打印清单的记录");
	    	return ;
	}
    
	var listFlag=GetListFlag(peAdmType);
	
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");
	var encmeth=GetCtlValueById("GetInvoiceInfo");
	var TxtInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,"List")

	var encmeth=GetCtlValueById("GetInvoiceList");
	var ListInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,1,"1")
	var myobj=document.getElementById("ClsBillPrint");
	alert(TxtInfo)
	alert("ListInfo:"+ListInfo)
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function GetListFlag(admtype)
{
	if (admtype!="I") return 0;
	obj= document.getElementById("HiddenListFlag");		
	if (!obj) return 0;
	if (obj.value=="1") return 1;
	return 0;
	
}
function BPrintProve_Click()
{

	var PEINVDR=getValueById('RPFRowId');
	if (""!=PEINVDR) {
		var obj,encmeth;
		var prnpath=getValueById("prnpath");
		if (""!=prnpath) {
			var Templatefilepath=prnpath+'DHCPEProvePrt.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		
		var InvNo=getValueById("InvNo");
	     if(""==InvNo){
		     alert("发票为退费的负记录,不能打印");
		     return ;
	     }

		obj=document.getElementById("GetProveInfoClass");
		if (obj) encmeth=obj.value;
		var PrintData=cspRunServerMethod(encmeth,PEINVDR);
		alert("PrintData:"+PrintData)
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
        //xlsheet.cells(7,5)=BaseArr[2];
        xlsheet.cells(7+m,5)=BaseArr[2];
		//var Rows=7;
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
		//xlsheet.SaveAs("d:\\团体异常值汇总.xls");
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null;
	}else{
		        alert("请选择要打印收据证明的记录");
	    		return ;
	}
	
}

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow=="-1") return;
	if(index==selectrow)
	{
		var rowid=rowdata.TRowId;
		var admtype=rowdata.TAdmType
		var giadm=rowdata.TGIAdm
		var InvNo=rowdata.TInvNo
		
	    setValueById("RPFRowId",rowid)
	    setValueById("InvNo",InvNo)
	   
		
	}else
	{
		selectrow=-1;
	
	}	

}


document.body.onload = BodyLoadHandler;
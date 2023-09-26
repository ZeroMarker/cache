////UDHCJFOP.Handin9.js
///BJJST Hosp 

var path
var Guser

function BodyLoadHandler()
{  
   Guser=session['LOGON.USERID'];
   var obj=document.getElementById("BClear");
   if (obj) obj.onclick=BClear_Click; 
   var obj=document.getElementById("BQuery");
   if (obj) obj.onclick=BQuery_Click; 
   var obj=document.getElementById("BHandin");
   DHCWeb_DisBtn(obj);
   var obj=document.getElementById("BDetail");
   if (obj) obj.onclick=ShowDetails; 
   
   var obj=document.getElementById("BPrintRep");
   if (obj) obj.onclick=BPrintRep_Click;

   var obj=document.getElementById("BPrint");
   ///if (obj) obj.onclick=BPrint_Click;
   DHCWeb_DisBtn(obj);
   
   var obj=document.getElementById("BillDetails");
   if (obj){
		obj.onclick=ShowINVDetails
   }
	var obj=document.getElementById("ParkDetail");
	if (obj){
		obj.onclick=ShowParkINVDetails;
	}
   	////
   	var obj=document.getElementById("PatCal");
   	if (obj){
	   	obj.onclick=PatCal_OnClick;
   	}
   	///if (obj) obj.onclick=BPrint_Click;
   	var obj=document.getElementById("Test");
   	if (obj){
	   	obj.onclick=ReLoadDD;
   	}
   	var obj=document.getElementById("PrePayDetail");
	if (obj){
		obj.onclick=PDFootDetail_Click;
	}
	//********

	var obj=document.getElementById("BInvGetDetail");
	if (obj){
		obj.onclick=ShowBInvGetDetail;
	}
	var obj=document.getElementById("BGetPrePayDetail");
	if (obj){
		obj.onclick=ShowBGetPrePayDetail;
	}
	var obj=document.getElementById("BCppGetDetail");
	if (obj){
		obj.onclick=ShowBCppGetDetail;
	}
			
	var obj=document.getElementById("BInvRefundDetail");
	if (obj){
		obj.onclick=ShowBInvRefundDetail;
	}
	
	var obj=document.getElementById("BAccFootDetail");
	if (obj){
		obj.onclick=ShowBAccFootDetail;
	}

	
	var obj=document.getElementById("BCppRefundDetail");
	if (obj){
		obj.onclick=ShowBCppRefundDetail;
	}
	
	//********

	var obj=document.getElementById("BNoteGatheringDetail");
	if (obj){
		obj.onclick=ShowNoteGatheringDetail;
	}
	var obj=document.getElementById("BRefundINVDetail");
	if (obj){
		obj.onclick=ShowBRefundINVDetail;
	}
	
	var obj=document.getElementById("BGetPrePay");
	if (obj){
		obj.onclick=ShowBGetPrePayDetail;
	}
	var obj=document.getElementById("BBackPrePay");
	if (obj){
		obj.onclick=ShowBBackPrePayDetail;
	}
	var obj=document.getElementById("bFinRepTotal");
	if (obj){
		obj.onclick=bFinRepTotal_OnClick;
	}
	DHCWeb_DisBtnA("bFinRepTotal");
}

function BPrintRep_Click(){
	PrintClickHandlerBJYKYZL();
}

function PrintClickHandlerBJYKYZL()
{

	try{
		var RepId=DHCWebD_GetObjValue("RepID");
		if(""==RepId){
			
			return;
		}
		var encmeth=""
		var obj=document.getElementById('GetRepPath');
		if (obj) encmeth=obj.value;
		if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
		
		var StDate="",EndDate="",StartTime="",EndTime="",CurDate="";
		var obj=document.getElementById("StDate");
		if (obj) StDate=obj.value;
		var obj=document.getElementById("EndDate");
		if (obj) EndDate=obj.value;
		var obj=document.getElementById("StartTime");
		if (obj) StartTime=obj.value;
		var obj=document.getElementById("EndTime");
		if (obj) EndTime=obj.value;
		var obj=document.getElementById("CurDate");
		if (obj) CurDate=obj.value;
		
		
		var ZBR=session['LOGON.USERNAME'];
		

		var Template=TemplatePath+"JFOP_BJYKYZLDailyRep.xls";
		
		encmeth=""
		var obj=document.getElementById("ReadPrtData");
		if (obj) encmeth=obj.value; 
		var str=cspRunServerMethod(encmeth,RepId);
		
		var FootInfo=str.split("$")[0];
		var INVInfo=str.split("$")[1];
		var PREInfo=str.split("$")[2];
		var CPPInfo=str.split("$")[3];
		var OtherInfo=str.split("$")[5];
		
		//alert("CPPInfo: "+CPPInfo)
		var InsTypeInfo=str.split("$")[4];
		
		//OutPutExel
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet;
		
		var xlsRow=0;
		var xlsCol=1;
		var i=2;
		//Data
		//FootInfo INVInfo  PREInfo  CPPInfo InsTypeInfo
		//print head
		var arytmp=FootInfo.split("^");
		xlsheet.cells(xlsRow+i,xlsCol+3)=arytmp[1];
		xlsheet.cells(xlsRow+i,xlsCol+5)=arytmp[0];
		xlsheet.cells(xlsRow+i,xlsCol+7)=arytmp[2]+""+arytmp[3]+""+arytmp[4]+arytmp[5];
		
		//print inv
		i+=2;
		var arytmpPM=INVInfo.split("@");
		for (var j=0; j<arytmpPM.length; j++){
			i++;
			var arytmp=arytmpPM[j].split("^");
			for (var k=0; k<arytmp.length; k++){
				xlsheet.cells(xlsRow+i,xlsCol+k+3)=arytmp[k];	
			}
		
		}
		
		//print byjz
		i+=3;
		//alert(InsTypeInfo)
		var aryIns=InsTypeInfo.split("%%%");
		var arytmpPM=aryIns[1].split("%");
		for (var j=0; j<arytmpPM.length; j++){
			i++;
			var arytmp=arytmpPM[j].split("^");
			for (var k=0; k<arytmp.length; k++){
				xlsheet.cells(xlsRow+i,xlsCol+k+3)=arytmp[k];	
			}
		
		}
	
		
		
		
		
		/*
		var arytmpInstype=InsTypeInfo.split("@");
		var arytmpGet=arytmpInstype[0].split("#");
		var arytmpRefund=arytmpInstype[0].split("#");
		var arytmpPark=arytmpInstype[0].split("#");
		va 
		
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+3)=arytmpGet[0].split("^")[2];
		xlsheet.cells(xlsRow+i,xlsCol+4)=arytmpGet[0].split("^")[0];
		xlsheet.cells(xlsRow+i,xlsCol+5)=arytmpRefund[0].split("^")[2];
		xlsheet.cells(xlsRow+i,xlsCol+6)=arytmpRefund[0].split("^")[0];
		xlsheet.cells(xlsRow+i,xlsCol+7)=arytmpPark[0].split("^")[2];
		xlsheet.cells(xlsRow+i,xlsCol+8)=arytmpPark[0].split("^")[0];
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+3)=arytmpGet[0].split("^")[3];
		xlsheet.cells(xlsRow+i,xlsCol+4)=arytmpGet[0].split("^")[0];
		xlsheet.cells(xlsRow+i,xlsCol+5)=arytmpRefund[0].split("^")[3];
		xlsheet.cells(xlsRow+i,xlsCol+6)=arytmpRefund[0].split("^")[0];
		xlsheet.cells(xlsRow+i,xlsCol+7)=arytmpPark[0].split("^")[3];
		xlsheet.cells(xlsRow+i,xlsCol+8)=arytmpPark[0].split("^")[0];
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+3)=arytmpGet[0].split("^")[3];
		xlsheet.cells(xlsRow+i,xlsCol+4)=arytmpGet[0].split("^")[0];
		xlsheet.cells(xlsRow+i,xlsCol+5)=arytmpRefund[0].split("^")[3];
		xlsheet.cells(xlsRow+i,xlsCol+6)=arytmpRefund[0].split("^")[0];
		xlsheet.cells(xlsRow+i,xlsCol+7)=arytmpPark[0].split("^")[3];
		xlsheet.cells(xlsRow+i,xlsCol+8)=arytmpPark[0].split("^")[0];
		*/
		//print prepay
		i+=3;
		var aryCpp=CPPInfo.split("^");
		var arytmpPM=PREInfo.split("@");
		//alert(aryCpp[0])
		xlsheet.cells(xlsRow+i+1,xlsCol+6+3)=aryCpp[0];	
		
		xlsheet.cells(xlsRow+i+1,xlsCol+7+3)=aryCpp[1];
			
		for (var j=0; j<arytmpPM.length; j++){
			i++;
			var arytmp=arytmpPM[j].split("^");
			for (var k=0; k<arytmp.length; k++){
				xlsheet.cells(xlsRow+i,xlsCol+k+3)=arytmp[k];	
			}
					
		}
	
		//cpp
			i++;i++;
			xlsheet.cells(xlsRow+i,xlsCol+1+2)=aryCpp[2];	
			xlsheet.cells(xlsRow+i,xlsCol+8)=aryCpp[3];
			i++;			
			xlsheet.cells(xlsRow+i,xlsCol+1+2)=aryCpp[4];	
			xlsheet.cells(xlsRow+i,xlsCol+8)=aryCpp[5];			

		//prt all
		var arytmp=FootInfo.split("^");
		//alert(FootInfo)

		i++;i++;i++;i++;i++;i++;
		xlsheet.cells(xlsRow+i,xlsCol+3)=arytmp[11];
		xlsheet.cells(xlsRow+i,xlsCol+4)=arytmp[12];
		xlsheet.cells(xlsRow+i,xlsCol+5)=arytmp[13];
		xlsheet.cells(xlsRow+i,xlsCol+6)=arytmp[14];
		xlsheet.cells(xlsRow+i,xlsCol+7)=arytmp[15];
		xlsheet.cells(xlsRow+i,xlsCol+8)=arytmp[16];
		xlsheet.cells(xlsRow+i,xlsCol+9)=parseFloat(arytmp[11])+parseFloat(arytmp[13])+parseFloat(arytmp[15]);
		xlsheet.cells(xlsRow+i,xlsCol+10)=parseFloat(arytmp[12])+parseFloat(arytmp[14]);
	
		i++;
		//UserCode_"^"_UserName_"^"_StDate_"^"_StTime_"^"_EndDate_"^"_EndTime_"^"_Amount_"^"_PatShare_"^"_InvSection_"^"_ParkInv_"^"_RefundInv
			xlsheet.cells(xlsRow+i,xlsCol+3)=arytmp[8];
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+3)=arytmp[10];
		i+=3;
		xlsheet.cells(xlsRow+i,xlsCol+3)=arytmp[9];
		i+=3;
		//prt other
		//OtherInfo=CashSumAll_"^"_CheckSumAll_"^"_BankSumAll_"^"_NBZZSumAll

		
		var arytmp=OtherInfo.split("^");
		//alert(i+"OtherInfo: "+OtherInfo)
		xlsheet.cells(xlsRow+i,xlsCol+5)=arytmp[4];
		xlsheet.cells(xlsRow+i,xlsCol+6)=arytmp[5];
		xlsheet.cells(xlsRow+i,xlsCol+9)=arytmp[6];
		xlsheet.cells(xlsRow+i,xlsCol+10)=arytmp[7];
	
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+4)=arytmp[0];
		xlsheet.cells(xlsRow+i,xlsCol+6)=arytmp[1];
		xlsheet.cells(xlsRow+i,xlsCol+8)=arytmp[2];
		xlsheet.cells(xlsRow+i,xlsCol+10)=arytmp[3];
		
		
		/*
		/
		//Other
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["ZBR"];
		xlsheet.cells(xlsRow+i,xlsCol+2)=ZBR;
		xlsheet.cells(xlsRow+i,xlsCol+3)=t["shr"];
		xlsheet.cells(xlsRow+i,xlsCol+5)=t["BT"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=CurDate;

		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["JKR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["QZ"];
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["SHR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["KJS"];
		*/
		//OutPutExcel
		xlsheet.printout; 
	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;

		
	} catch(e){
			alert(e.message);
		};
	
	
}



function PatCal_OnClick(){
	////Calculate the Payor
	////FootCalculate();
	FootExpCalculate();
	return;
}

function FootExpCalculate()	{
	var myTotSum="";
	var obj=document.getElementById("HandSum");
	if (obj){
		myTotSum=obj.value;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashExpCal&OperFootSum="+myTotSum;
	var NewWin=open(lnk,"udhcOPCashExpCal","scrollbars=no,resizable=no,top=100,left=100,width=800,height=460");
}


function BPrint_Click()
{
	PrintClickHandlerBJYKYZL();
}

function bFinRepTotal_OnClick(){
	var myTotSum="";
	var myHISRowID=DHCWebD_GetObjValue("RepID");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.Reps.BJJSTRepPrint&QueryMode=HISRep&HISRowID="+myHISRowID;
	//alert(lnk);
	var NewWin=open(lnk,"DHCOPFin_Reps_BJJSTRepPrint","scrollbars=yes,resizable=yes,top=100,left=100,width=800,height=460");
	
}

function ShowDetails()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	var uName=sUser.value
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;
	
	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.Details&hUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate+"&StartTime=" +StTime ;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails_Details","top=20,left=20,width=930,height=660,scrollbars=1");
}

function PDFootDetail_Click()
{
	var Guser=session['LOGON.USERID'];
	var myStartDate="StartDate"
	var myStartDate=DHCWebD_GetObjValue("StartDate");
	
	var myStartTime=DHCWebD_GetObjValue("StartTime");
	var myEndDate=DHCWebD_GetObjValue("EndDate");
	var myEndTime=DHCWebD_GetObjValue("EndTime");
	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccPDDetail&USERID='+Guser;
	str+="&StDate="+myStartDate+"&StTime="+myStartTime+"&EndDate="+myEndDate+"&EndTime="+myEndTime;
	
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
	//location.href='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccPDDetail&USERID='+Guser+'&FOOTID=0';
}

function ShowParkINVDetails(){
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	var uName=sUser.value
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.ParkINVDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandin_ParkINVDetail","top=20,left=20,width=930,height=660,scrollbars=1");

}

function ShowINVDetails()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	var uName=sUser.value
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}


function BHandin_Click()
{
	var handencobj=document.getElementById("HandinEncmeth");
	if (handencobj) {var encmeth=handencobj.value} else {var encmeth=''};
	
	///,myenddate,myendtime,mystdate,mysttime,myinvNote,myInvNum
	var myinfo=BuildFootInfo();
	//alert(myinfo);
	
	var myrtn=confirm(t['03']);
	if (myrtn==false){
		return;
	}
	//alert(Guser)
	if (encmeth!=""){
		var rtn=(cspRunServerMethod(encmeth,Guser,myinfo)) 
	}
	//alert(rtn);
	var mytmpary=rtn.split("^");
	if (mytmpary[0]=="0") {
		alert(t["01"]);
		var obj=document.getElementById("BHandin");
		DHCWeb_DisBtn(obj);
		var obj=document.getElementById("RepID");
		if (obj){
			obj.value=mytmpary[1];
			//alert(obj.value);
		}
		////enable Printer button
		////
   		var Pobj=document.getElementById("BPrint");
   		if (Pobj){ 
   			Pobj.disabled=false;
   			Pobj.onclick=BPrint_Click;
   		}
   		///
   		var Pobj=document.getElementById("bFinRepTotal");
   		if (Pobj){ 
   			Pobj.disabled=false;
   			Pobj.onclick=bFinRepTotal_OnClick;
   		}
		
	}else{
		alert(t["02"]);	  ///
	}
}

function BuildFootInfo(){
	var FootInfo="";
	var myList=new Array;
	
	///Build by Array Mode
	///OK   To PB
	////x HIS_Rowid                              DHC_INVPRTReports Row ID      1      xx
	
	////x HIS_Date                               His_date                      2      xx
	
	////x HIS_Time                               His_time                      3      xx
	////x HIS_StartDate                          His_startdate                 4      xx
	myList[4]=DHCWebD_GetObjValue("StartDate");
	////x HIS_StartTime                          His_starttime                 5      xx
	myList[5]=DHCWebD_GetObjValue("StartTime");
	////x HIS_EndDate                            His_enddate                   6      xx
	myList[6]=DHCWebD_GetObjValue("EndDate");
	////x HIS_EndTime                            His_endtime                   7      xx
	myList[7]=DHCWebD_GetObjValue("EndTime");
	////HIS_Amount                             His_amount                    8 
	myList[8]=DHCWebD_GetObjValue("TotalFee");
	////x HIS_User                               His_user                      9      xx
	myList[9]=session['LOGON.USERID'];		//////DHCWebD_GetObjValue("");
	////x His_Num                                His_Num                       10     xx
	var myNum=DHCWebD_GetObjValue("CashNUM");
	if (isNaN(myNum)){
		myNum=0;
	}
	if (isNaN(DHCWebD_GetObjValue("CheckNUM"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("CheckNUM"));
		var myNum=+myNum+mysnum;
	}
	if (isNaN(DHCWebD_GetObjValue("OtherNum"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("OtherNum"));
		var myNum=+myNum+mysnum;
	}
	if (isNaN(DHCWebD_GetObjValue("CardNum"))){
	}else{
		var mysnum=parseInt(DHCWebD_GetObjValue("CardNum"));
		var myNum=+myNum+mysnum;
	}
	
	myList[10]=myNum;				///DHCWebD_GetObjValue("");
	////x HIS_RcptNO                             HIS_RcptNO                    11     xx
	myList[11]=DHCWebD_GetObjValue("INVNOinfo");
	////x HIS_Confirm                            HIS_Confirm                   12     xx
	////x HIS_Collect                            HIS_Collect                   13     xx
	////x HIS_INSFootDate                        HIS_INSFootDate               14     xx
	////x HIS_INSFootTime                        HIS_INSFootTime               15     xx
	////x HIS_INSFootUser                        HIS_INSFootUser               16     xx
	
	////
	////x HIS_PatSum                             HIS_PatSum                    17     xx
	myList[17]=DHCWebD_GetObjValue("HandSum");
	////HIS_CashNum                            HIS_CashNum                   18   
	myList[18]=DHCWebD_GetObjValue("CashNUM");
	////HIS_CashSum                            HIS_CashSum                   19     x
	myList[19]=DHCWebD_GetObjValue("CashSUM");
	////x HIS_CheckNum                           HIS_CheckNum                  20     x
	myList[20]=DHCWebD_GetObjValue("CheckNUM");
	////x HIS_CheckSum                           HIS_CheckSum                  21     xk
	myList[21]=DHCWebD_GetObjValue("CheckSUM");
	////x HIS_RefundNum                          HIS_RefundNum                 22     xx
	myList[22]=DHCWebD_GetObjValue("RefundNUM");
	////x HIS_RefundSum                          HIS_RefundSum                 23     xx
	myList[23]=DHCWebD_GetObjValue("RefundSUM");
	////x HIS_ParkNum                            HIS_ParkNum                   24     xx
	myList[24]=DHCWebD_GetObjValue("CancelNUM");
	////x HIS_ParkSum                            HIS_ParkSum                   25     xx
	myList[25]=DHCWebD_GetObjValue("CancelSUM");
	////x HIS_ParkINVInfo                        HIS_ParkINVInfo               26     xx
	myList[26]=DHCWebD_GetObjValue("ParkINV");
	////x HIS_RefundINVInfo                      HIS_RefundINVInfo             27     xx
	myList[27]=DHCWebD_GetObjValue("RefundINV");

	///HIS_StartDate
	
	////;Add more
	////>27   Write
	////x HIS_OterPayNum                         HIS_OterPayNum                28     xx
	myList[28]=DHCWebD_GetObjValue("OtherNum");
	////x HIS_OterPaySum                         HIS_OterPaySum                29     xx
	myList[29]=DHCWebD_GetObjValue("OtherSum");
	////x HIS_INVPrtNote                         HIS_Note3                     30     xx
	myList[30]=""		////DHCWebD_GetObjValue("");
	////x HIS_YBSum                               HIS_YBSum  for DHC_INVPRT t  31    
	myList[31]=DHCWebD_GetObjValue("YBSum");
	///alert(myList[31]);
	////x HIS_CardNum                            HIS_CardNum                   32     xx
	myList[32]=DHCWebD_GetObjValue("CardNum");
	////x HIS_CardSum                            HIS_CardSum                   33     xx
	myList[33]=DHCWebD_GetObjValue("CardSum");
	////x HIS_CardYBSum                          HIS_CardYBSum                 34 	
	myList[34]=DHCWebD_GetObjValue("CardYBSum");
	////x HIS_CardRefNum                         HIS_CardRefNum                35     xx
	myList[35]=DHCWebD_GetObjValue("CardRefNum");
	////x HIS_CardRefSum                         HIS_CardRefSum                36     xx
	myList[36]=DHCWebD_GetObjValue("CardRefSum");
	////x HIS_CardYBRefSum                       HIS_CardYBRefSum              37     xx
	myList[37]=DHCWebD_GetObjValue("CardYBRefSum");
	////x HIS_CardCashRefSum                     HIS_CardCashRefSum            38     xk
	myList[38]=DHCWebD_GetObjValue("CardCashRefSum");
	////x HIS_CardParkNum                        HIS_CardParkNum               39     xx
	myList[39]=DHCWebD_GetObjValue("CardParkNum");
	////x HIS_CardParkSum                        HIS_CardParkSum               40     xx
	myList[40]=DHCWebD_GetObjValue("CardParkSum");
	////x HIS_CardYBParkSum                      HIS_CardYBParkSum             41     xx
	myList[41]=DHCWebD_GetObjValue("CardYBParkSum");
	////HIS_CardCashParkSum 					 HIS_CardCashParkSum           42     x
	myList[42]=DHCWebD_GetObjValue("CardCashParkSum");
	////x HIS_CardParkINVInfo                    HIS_CardParkINVInfo           43     xx
	myList[43]=DHCWebD_GetObjValue("CardParkINVInfo");
	////x HIS_CardRefundINVInfo                  HIS_CardRefundINVInfo         44     xx
	myList[44]=DHCWebD_GetObjValue("CardRefundINVInfo");
	////x HIS_PosNum --> HIS_CPPNum              HIS_PosNum                    45     
	myList[45]=DHCWebD_GetObjValue("CPPNum");
	////HIS_PosSum   HIS_PosSum -->HIS_CPPSum        HIS_PosSum                    46     xx
	myList[46]=DHCWebD_GetObjValue("CPPSum");
	////HIS_Note3     HIS_GetTotal                   HIS_Note3                     47     x
	myList[47]=DHCWebD_GetObjValue("GetTotal");
	////x HIS_Note4   HIS_GiveTotal                  HIS_Note4                     48     x
	myList[48]=DHCWebD_GetObjValue("GiveTotal");
	////x HIS_Note5   HIS_CashTotal                  HIS_Note5                     49     xk
	myList[49]=DHCWebD_GetObjValue("CashTotal");
	////x HIS_Note6   HIS_CheckTotal                 HIS_Note6                     50     xx
	myList[50]=DHCWebD_GetObjValue("CheckTotal");
	////x HIS_Note7   HIS_OtherTotal                 HIS_Note7                     51     xx
	myList[51]=DHCWebD_GetObjValue("OtherTotal");
	
	////x HIS_Note8     HIS_PRDGetNum                HIS_Note8                     52     xx
	myList[52]=DHCWebD_GetObjValue("PRDGetNum");
	////x HIS_Note9     HIS_PRDGetSum                HIS_Note9                     53     xx
	myList[53]=DHCWebD_GetObjValue("PRDGetSum");
	////x HIS_Note10    HIS_PRDParkNum               HIS_Note10                    54     xx
	myList[54]=DHCWebD_GetObjValue("PRDParkNum");
	////x HIS_Note11    HIS_PRDParkSum               HIS_Note11                    55     xx
	myList[55]=DHCWebD_GetObjValue("PRDParkSum");
	////x HIS_Note12    HIS_PRDCashSum               HIS_Note12                    56    	
	myList[56]=DHCWebD_GetObjValue("PRDCashSum");
	////x HIS_PRDCheckSum 							 HIS_PRDCheckSum	           57    	
	myList[57]=DHCWebD_GetObjValue("PRDCheckSum");
	////  HIS_PRDOtherPaySum						 HIS_PRDOtherPaySum					58
	myList[58]=DHCWebD_GetObjValue("PRDOtherPaySum");
	
	////HIS_AccPFoot_DR                              HIS_Note1                     59     x
	////x HIS_AccPaySum                              HIS_AccPaySum                     60     x
	myList[60]=DHCWebD_GetObjValue("CPPPRTINVSum");
	////x HIS_FootFlag  User   System                    HIS_Note3                     61     xk
	myList[61]="U";
	////x HIS_BankInsum                              HIS_Note4                     62     xx
	myList[62]=DHCWebD_GetObjValue("BankInSum");
	////x HIS_BankCardNum                              HIS_Note5                     63     xx
	myList[63]=DHCWebD_GetObjValue("BankCardNum");
	////x HIS_BankCardSum                              HIS_Note6                     64     xx
	myList[64]=DHCWebD_GetObjValue("BankCardSum");
	////x HIS_PRDBankCardSUm                              HIS_Note7                     65    	
	myList[65]=DHCWebD_GetObjValue("PRDBankCardSum");
	////x HIS_Note8                              HIS_Note8                     66    	
	
	FootInfo=myList.join("^")
	///alert(FootInfo);
	return FootInfo;
}

function BQuery_Click()
{
	///
   var obj=document.getElementById("BQuery");
	DHCWeb_DisBtn(obj);
	DHCWeb_DisBtnA("BPrint");
	DHCWeb_DisBtnA("bFinRepTotal");
	
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var encmeth=''
	var obj=document.getElementById("GetHandsum");
	if (obj) {
		encmeth=obj.value
	}
	if (encmeth!=""){
		////,Enddobj.value,Endtobj.value
		var rtn=(cspRunServerMethod(encmeth,'SetHandsum','',Guser)) 
		///
   		var obj=document.getElementById("BHandin");
		if (rtn==0){
   			if (obj){
	   			obj.disabled=false;
	   			obj.onclick=BHandin_Click;
	   			///
   				var Pobj=document.getElementById("BPrint");
   				if (Pobj){ 
   					//Pobj.disabled=false;
   					///Pobj.onclick=BPrint_Click;
   				}
	   		} 
		}else{
   			DHCWeb_DisBtn(obj);
   			var Pobj=document.getElementById("BPrint");
   			DHCWeb_DisBtn(Pobj);
		}
	}
   
   var obj=document.getElementById("BQuery");
   if (obj) {
	   obj.disabled=false;
	   obj.onclick=BQuery_Click; 
   }
   
}

function SetHandsum(value)
{
	//alert(value)	
	var myary=value.split(String.fromCharCode(3));
	///First  Main  myary[0]
	var myMInfo=myary[0].split("^");
	DHCWebD_SetObjValueB("INVNOinfo",myMInfo[0]);
	
	DHCWebD_SetObjValueB("TotalFee",myMInfo[5]);
	
	DHCWebD_SetObjValueB("HandSum",myMInfo[6]);
	////var HandSumobj=document.getElementById("");
	
	DHCWebD_SetObjValueB("GetTotal",myMInfo[7]);
	
	DHCWebD_SetObjValueB("GiveTotal",myMInfo[8]);
	
	DHCWebD_SetObjValueB("CashTotal",myMInfo[9]);

	DHCWebD_SetObjValueB("CheckTotal",myMInfo[10]);
	
	DHCWebD_SetObjValueB("OtherTotal",myMInfo[11]);
	
	DHCWebD_SetObjValueB("YBSum",myMInfo[12]);
	
	DHCWebD_SetObjValueB("BankInSum",myMInfo[13]);
	
	DHCWebD_SetObjValueB("NBZZTotal",myMInfo[14]);
	////Cash Invoice Info
	var Split_Value=myary[1].split("^");
	
	var stdateobj=document.getElementById("StartDate");
	var sttimeobj=document.getElementById("StartTime");
	var cashnumobj=document.getElementById("CashNUM");
	var cashsumobj=document.getElementById("CashSUM");
	var checknumobj=document.getElementById("CheckNUM");
	var checksumobj=document.getElementById("CheckSUM");
	var cancelnumobj=document.getElementById("CancelNUM");
	var cancelsumobj=document.getElementById("CancelSUM");
	var refundnumobj=document.getElementById("RefundNUM");
	var refundsumobj=document.getElementById("RefundSUM");
	var jybsobj=document.getElementById("ChargeNUM");
	stdateobj.value=Split_Value[0];
	sttimeobj.value=Split_Value[1];
	cashnumobj.value=Split_Value[3];
	cashsumobj.value=Split_Value[10]
	checknumobj.value=Split_Value[4];
	checksumobj.value=Split_Value[11];
	cancelnumobj.value=Split_Value[5];
	cancelsumobj.value=Split_Value[6];
	refundnumobj.value=Split_Value[7];
	refundsumobj.value=Split_Value[8];
	///
	jybsobj.value=Split_Value[14];
	///
	DHCWebD_SetObjValueB("EndDate",Split_Value[15])
	DHCWebD_SetObjValueB("EndTime",Split_Value[16])
	
	DHCWebD_SetObjValueB("EndDate",Split_Value[15])
	DHCWebD_SetObjValueB("EndTime",Split_Value[16])

	
	
	
	var obj=document.getElementById("PayorTotal");
	if (obj){
		obj.value=Split_Value[18];
	}
	DHCWebD_SetObjValueB("RefundINV",Split_Value[19]);
	
	DHCWebD_SetObjValueB("ParkINV",Split_Value[20]);
	
	///myCPPNum_"^"_$fn(myCPPSum,"",2)_"^"_myOtherNum_"^"_$fn(myOtherSum,"",2)  ;21--24
	DHCWebD_SetObjValueB("CPPNum",Split_Value[21]);
	DHCWebD_SetObjValueB("CPPSum",Split_Value[22]);
	DHCWebD_SetObjValueB("OtherNum",Split_Value[23]);
	DHCWebD_SetObjValueB("OtherSum",Split_Value[24]);
	DHCWebD_SetObjValueB("BankCardNum",Split_Value[25]);
	DHCWebD_SetObjValueB("BankCardSum",Split_Value[26]);
	
	var username=session['LOGON.USERNAME'];
	////sUser.value=username;
	DHCWebD_SetObjValueB("sUser",username);
	
	DHCWebD_SetObjValueB("SARSNum",Split_Value[32]);
	DHCWebD_SetObjValueB("SARSSum",Split_Value[33]);
	DHCWebD_SetObjValueB("SARSRefNum",Split_Value[34]);
	DHCWebD_SetObjValueB("SARSRefSum",Split_Value[35]);
	
	DHCWebD_SetObjValueB("BYJZCash",Split_Value[36]);
	DHCWebD_SetObjValueB("BYJZSum",Split_Value[37]);
	DHCWebD_SetObjValueB("BYJZNum",Split_Value[38]);
	DHCWebD_SetObjValueB("GGJZCash",Split_Value[39]);
	DHCWebD_SetObjValueB("GGJZSum",Split_Value[40]);
	DHCWebD_SetObjValueB("GGJZNum",Split_Value[41]);
	DHCWebD_SetObjValueB("NBZZNum",Split_Value[42]);
	DHCWebD_SetObjValueB("NBZZSum",Split_Value[43]);

	
	
	
	
	
	////Card Invoice Info   myary[2]
	////alert(myary[2]);
	///	s myNINfo=AccNTotSum_"^"_AccNNum_"^"_AccNINVInfo_"^"_AccNCardPaySum_"^"_AccNYBPaySum_"^"_AccNRefSum_"^"_AccNCashSum
	///
	
	
	var myAccAry=myary[2].split(String.fromCharCode(4))
	var myINVInfo=myAccAry[1].split("^");
	
	DHCWebD_SetObjValueB("CardSum",myINVInfo[0]);
	DHCWebD_SetObjValueB("CardNum",myINVInfo[1]);
	DHCWebD_SetObjValueB("CardNormalINVInfo",myINVInfo[2]);
	DHCWebD_SetObjValueB("CardPaySum",myINVInfo[3]);
	DHCWebD_SetObjValueB("CardYBSum",myINVInfo[4]);
	
	/// Refund Info
	////s myRefInfo=AccRefTotSum_"^"_AccRefundNum_"^"_AccRefundINVInfo_"^"_AccRefCardPaySum
	////s myRefInfo=myRefInfo_"^"_AccRefYBPaySum_"^"_AccRefRefSum_"^"_AccRefCashSum
	var myRefINVInfo=myAccAry[3].split("^");
	DHCWebD_SetObjValueB("CardRefSum",myRefINVInfo[0]);
	DHCWebD_SetObjValueB("CardRefNum",myRefINVInfo[1]);
	DHCWebD_SetObjValueB("CardRefundINVInfo",myRefINVInfo[2]);
	DHCWebD_SetObjValueB("CardYBRefSum",myRefINVInfo[4]);
	DHCWebD_SetObjValueB("CardCashRefSum",myRefINVInfo[6]);
	
	////Park Info
	////s myParkInfo=AccParkTotSum_"^"_AccParkNum_"^"_AccParkINVInfo_"^"_AccParkCardPaySum
	////s myParkInfo=myParkInfo_"^"_AccParkYBPaySum_"^"_AccParkRefSum_"^"_AccParkCashSum
	var myParkINVInfo=myAccAry[2].split("^");
	
	DHCWebD_SetObjValueB("CardParkSum",myParkINVInfo[0])
	DHCWebD_SetObjValueB("CardParkNum",myParkINVInfo[1])
	DHCWebD_SetObjValueB("CardParkINVInfo",myParkINVInfo[2])
	DHCWebD_SetObjValueB("CardYBParkSum",myParkINVInfo[4])
	DHCWebD_SetObjValueB("CardCashParkSum",myParkINVInfo[6])
	////DHCWebD_SetObjValueB("",myParkINVInfo[0])
	
	////;s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	////;s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum
	////Pre Deposit Info
	var myPRDINfo=myary[3].split("^");

	DHCWebD_SetObjValueB("PRDGetNum",myPRDINfo[0]);
	DHCWebD_SetObjValueB("PRDGetSum",myPRDINfo[1]);
	DHCWebD_SetObjValueB("PRDParkNum",myPRDINfo[2]);
	DHCWebD_SetObjValueB("PRDParkSum",myPRDINfo[3]);
	DHCWebD_SetObjValueB("PRDCashSum",myPRDINfo[4]);
	DHCWebD_SetObjValueB("PRDCheckSum",myPRDINfo[5]);
	DHCWebD_SetObjValueB("PRDOtherPaySum",myPRDINfo[6]);
	DHCWebD_SetObjValueB("PRDBankCardSum",myPRDINfo[7]); 
	DHCWebD_SetObjValueB("PRDNBZZSum",myPRDINfo[8]);
	
	///CPPPRTINVSum    CPP  PRT  INV  Sum
	var myCPPPRTINVSum=myary[5];
	DHCWebD_SetObjValueB("CPPPRTINVSum",myCPPPRTINVSum);
	
}

function BClear_Click(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOP.Handin9";
	window.location.href=lnk;
}

function transINVStr(myINVStr)
{
	alert(myINVStr);
	
}

function ReLoadDD()
{
	var lnk="udhcopbillif.csp?PatientIDNo=6&CardNo=00000006";
	var NewWin=open(lnk,"udhcopbillif","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
}


function UnloadHandler(){
	///
	var obj=document.getElementById("KillTmp");
	if (obj){
		var encmeth=obj.value;
		if (encmeth!=""){
			cspRunServerMethod(encmeth);
		}
	}
}
//*********


function ShowBInvGetDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTINVGatheringDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=0,width=1014,height=660,scrollbars=1");
}

function ShowBGetPrePayDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTCppGetPrePayDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}

function ShowBCppGetDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTCppGetDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}


function ShowBInvRefundDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTRefundINVDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}


function ShowBAccFootDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTBackPrePayDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}


function ShowBCppRefundDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTCppRefundDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}

//*********
/*
function ShowNoteGatheringDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTINVGatheringDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}

function ShowBGetPrePayDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTGetPrePayDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}


function ShowBBackPrePayDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTBackPrePayDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}


function ShowBRefundINVDetail()
{
	var Enddobj=document.getElementById("EndDate");
	var Endtobj=document.getElementById("EndTime");
	var stdateobj=document.getElementById("StartDate");
	var StartTime=document.getElementById("StartTime");
	var sUser=document.getElementById("sUser");
	
	//var uName=sUser.value
	var uName=escape(sUser.value);
	var Enddate=Enddobj.value;
	var EndTime=Endtobj.value;
	var StDate=stdateobj.value;
	var StTime=StartTime.value;

	var StTime="";
	var obj=document.getElementById("StartTime");
	if (obj){
		StTime=obj.value;
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTRefundINVDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPHandDetails","top=20,left=20,width=930,height=660,scrollbars=1");
}
*/

document.body.onload = BodyLoadHandler;

document.body.onunload =UnloadHandler;
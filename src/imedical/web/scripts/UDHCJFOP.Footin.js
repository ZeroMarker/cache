 function BodyLoadHandler() 
 {
	Initialpattype()
    var obj=document.getElementById("BPrint");
	if (obj)
	{
		obj.onclick=Print_Click;
	}
	var obj=document.getElementById("BPrintCate");
	if (obj)
	{
		obj.onclick=PrintCateFee_Click;
	}
	var obj=document.getElementById("BPrtCTDetail");
	if (obj)
	{
		obj.onclick=PrintCT_Click;
	}
	var obj=document.getElementById("BFind");
	if (obj)
	{
		obj.onclick=BFind_Click;
	}
	var obj=document.getElementById("FootStatus");
   	if (obj)
   	{
	   	obj.onclick=FootStatus_onclick;
   	}
   	var obj=document.getElementById("HandInCheck");
   	if (obj)
   	{
	   	obj.onclick=HandInCheck_onclick;
   	}
   	var obj=document.getElementById("BFoot");
   	if (obj)
   	{
	   	obj.onclick=BFoot_Click;
   	}
   	
   	var obj=document.getElementById("PrtPaymFoot");
   	if (obj)
   	{
	   	obj.onclick=BPrintPayMode_Click;
   	}
    var obj=document.getElementById("BtnPrtUserCate");
	if (obj)
	{
		obj.onclick=PrintUserCateFee_Click;
	}	
   	
  	
	InitDocument();
}
function Initialpattype()
{
	var catobj=document.getElementById("getpattype"); 
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var payminfo=cspRunServerMethod(encmeth);
	var objtbl=document.getElementById("tUDHCJFOP_Footin");
	var Rows=objtbl.rows.length;
	var firstRow=objtbl.rows[0];
	var RowItems=firstRow.all;
	var paymtmp =payminfo.split("^");
	var paymnum=paymtmp.length;
	for (var i=1;i<=paymnum-1;i++)
	{
		var ColName="TCatSum"+i;
		for (var j=0;j<RowItems.length;j++) 
		{
			if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH'))
			{
				RowItems[j].innerHTML=paymtmp[i];
			}
		}
	}
	for (var i=paymnum;i<=25;i++){
		HiddenTblColumn(objtbl,"TCatSum"+i,i);
	}
}
function HiddenTblColumn(tbl,ColName,ColIdx){
	///
	///
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	
	for (var j=0;j<RowItems.length;j++) {
		///alert(RowItems[j].childNodes.length);
		///if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
			RowItems[j].style.display="none";
		} else {
		}
	}

	row=row-1;
	for (var j=1;j<row+1;j++) {
		//var sLable=document.getElementById("TCatSum"+ColIdx+'z'+j);
		//var sTD=sLable.parentElement;
		//sTD.style.display="none";
	}
}
function FootStatus_onclick()
{
  	var obj=document.getElementById("FootStatus")
	if (obj.checked==true) 
	{
		//var obj=document.getElementById("HandInCheck")
		//obj.checked=true
		var obj=document.getElementById("BFoot");
		DHCWeb_DisBtn(obj);
		var obj=document.getElementById("LinkRec");
		if (obj)
		{	
			obj.disabled=false;
			obj.onclick=LinkRec_Click;
		}
		SetUnFootFlag();
		GetInitDate();
		BFind_Click();	
	}else{
		 document.getElementById("RecDr").value==""
		 var obj=document.getElementById("LinkRec");
		 DHCWeb_DisBtn(obj);
		 SetFootFlag();		
		 //var obj=document.getElementById("HandInCheck")   /////////////////////////
		 //if (obj.checked==true)
		 //{ 
		 	var rtn=GetFootDate();	
		 	if(rtn==1)
		 	{
				var obj=document.getElementById("BFoot");
				if (obj)
				{	
					obj.disabled=true;
					obj.onclick=BFoot_Click;
				}
		 	}	
		
		BFind_Click();
	}
}
function FootStatus_onchange()
{
  	SetFootStatus();
}
function BFoot_Click()
{	
	var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;
	var UnFootUser=""
	var obj=document.getElementById('GetUnFootUser');
	if (obj) var encmeth=obj.value;
	if (encmeth) var UnFootUser=cspRunServerMethod(encmeth,StDate,EndDate);
	if (""!=UnFootUser)
	{
		var ary = UnFootUser.split("^")
		var alertInfo=t['UFUser']
		for (var i=0;i<ary.length;i++)
		{
			alertInfo=alertInfo+"\n"+ary[i];
		}
		//alert(alertInfo);		
		var myrtn=confirm(alertInfo+"\n\n"+t['03']);
		if (myrtn==false)
		{
			var obj=document.getElementById("BFoot");
			DHCWeb_DisBtn(obj);
			return;
		}	
	}	
	var listobj=document.getElementById("RepIdz"+1);
	if (listobj)
	{
		var rtn=DHCWebD_GetCellValue(listobj);
		if(rtn=="") return;
	}	
	var obj=document.getElementById("TMPJID");
	if (obj) var TMPJID=obj.value;	
	var encmeth=""
	var obj=document.getElementById('FootHisId');
	if (obj) var encmeth=obj.value;
	if (encmeth) var myFootInfo=cspRunServerMethod(encmeth,TMPJID,session['LOGON.USERID']);
	var ary=myFootInfo.split("^");
	if(0==ary[0]){
		alert(t['FootOK']);
		var obj=document.getElementById("BFoot");
		DHCWeb_DisBtn(obj);
        var obj=document.getElementById("BPrint");
		if (obj)
		{	obj.disabled=false;
			obj.onclick=Print_Click;
		}
	}
	else{
		alert(t['FootFailure'])
		//var obj=document.getElementById("BFoot");
		//DHCWeb_DisBtn(obj);
		return; 
	}	
}
function BFind_Click()
{
	var StatFlag="N";
	var BFootFlag="N"
	var obj=document.getElementById("FootStatus")
	if (obj.checked==true){StatFlag="Y";}
	if(StatFlag=="N")
	{
		var rtn=GetFootDate();		
		if(rtn==1)
		{
			var obj=document.getElementById("BFoot");
			if (obj)
			{	
			    obj.disabled=true;
				obj.onclick=BFoot_Click;
			}	
			BFootFlag="Y"
		}
	}	
	var StDate="",StartTime="",EndDate="",EndTime="";
	var obj=document.getElementById("EndDate")
	if (obj){ var EndDate=obj.value; }
	var obj=document.getElementById("StDate")
	if (obj){ var StDate=obj.value; }
	var obj=document.getElementById("StartTime")
	if (obj){ var StartTime=obj.value; }
	var obj=document.getElementById("EndTime")
	if (obj){ var EndTime=obj.value; }
	var obj=document.getElementById("TMPJID")
	if (obj){ var TMPJID=obj.value; }
	var HandInCheck="" 
	var HandInCheckobj=document.getElementById("HandInCheck")
	if (HandInCheckobj){ 
	   if (HandInCheckobj.checked==true){
	      HandInCheck="on"	   
	   }else{
          HandInCheck=""
	   } 
	}
		
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOP.Footin&TMPJID="+TMPJID+"&StDate="+StDate+"&EndDate="+EndDate+"&StatFlag="+StatFlag+"&StartTime="+StartTime+"&EndTime="+EndTime+"&HandInCheck="+HandInCheck;
  	document.location.href=lnk;	
}
function InitDocument()
{	
	var obj=document.getElementById("StatFlag")
	if ("Y"==obj.value)
	{
		var obj=document.getElementById("FootStatus")
		obj.checked=true;
		var obj=document.getElementById("LinkRec");
			if (obj)
			{	obj.disabled=false;
				obj.onclick=LinkRec_Click;
			}
	}else{		
		var obj=document.getElementById("LinkRec");
		DHCWeb_DisBtn(obj);
		SetFootFlag();
		
	}	
	var obj=document.getElementById("BFootFlag");
	if (obj.value=="Y") 
	{
		var obj=document.getElementById("BFoot");
		if (obj)
		{	
		    obj.disabled=false;
			obj.onclick=BFoot_Click;
		}
	
		SetFootFlag();
		var obj=document.getElementById("BPrint");
		DHCWeb_DisBtn(obj);
	}else{	
		var objbf=document.getElementById("BFoot");
		var obj=document.getElementById("FootStatus")
		if (obj.checked==true){
		    DHCWeb_DisBtn(objbf);
		    var obj=document.getElementById("LinkRec");
			if (obj)
			{	obj.disabled=false;
				obj.onclick=LinkRec_Click;
			}
		}
		else{var obj=document.getElementById("LinkRec");
		DHCWeb_DisBtn(obj);}
        var obj=document.getElementById("BPrint");
		if (obj)
		{	obj.disabled=false;
			obj.onclick=Print_Click;
		}
	}
	var listobj=document.getElementById("TTMPJIDz"+1);
	if (listobj)
	{
		var myval=DHCWebD_GetCellValue(listobj);
		var obj=document.getElementById("TMPJID");
		if (obj) obj.value=myval; //alert(obj.value)
	}
}
function GetFootDate()
{
	//var obj=document.getElementById("HandInCheck")
	//if (obj.checked==true) 
	//{
	var Expr=""
	var obj=document.getElementById('getFootDate');
	if (obj) var encmeth=obj.value;
	if (encmeth) var rtn=cspRunServerMethod(encmeth,Expr);
	var ary = rtn.split("^")
	var obj=document.getElementById('StDate');
	if (obj) obj.value=ary[0];
	var obj=document.getElementById('StartTime');
	if (obj) obj.value=ary[1];

	return ary[2]
	//}
}
function GetInitDate()
{
	var Expr=""
	var obj=document.getElementById('getInitDate');
	if (obj) var encmeth=obj.value;
	if (encmeth) var rtn=cspRunServerMethod(encmeth);
	//if (getpath) {var encmeth=getpath.value} else {var encmeth=''};	
	//	path=cspRunServerMethd(encmeth,'','')
    var ary = rtn.split("^")
	var obj=document.getElementById('StDate');
	if (obj) obj.value=ary[0];
	var obj=document.getElementById('StartTime');
	if (obj) obj.value=ary[1];	
}
function SetFootFlag(){
	//SetImgStyle("StDate",true);
	//SetImgStyle("EndDate",true);
	SetItemStyle("StartTime",true);
	SetItemStyle("EndTime",true);
}
function SetUnFootFlag(){   
	SetImgStyle("StDate",false);
	//SetImgStyle("EndDate",false);
	SetItemStyle("StartTime",false);
	SetItemStyle("EndTime",false);
}
function SetImgStyle(ItemName,flag)
{
   var Myobj=document.getElementById('Myid');
   if (Myobj){
	    var ItemObj=document.getElementById(ItemName)
		var ImgObj=document.getElementById("ld"+Myobj.value+"i"+ItemName);
		if(flag==true)
		{
			GetFootDate()
			ImgObj.style.display="none";
			ItemObj.readOnly=true;	
			ItemObj.disabled=true;
		}else{
			 ImgObj.style.display="";
	 		 ItemObj.readOnly=false;
			 ItemObj.disabled = false;			
		}	
	}	
}
function SetItemStyle(ItemName,flag)
{
	var obj=document.getElementById(ItemName);
    if(obj)
    {
		 obj.disabled = flag;
    }
}
function SetFootStatus()
{
	var obj=document.getElementById("FootStatus")
	if (obj.checked==true) 
	{
		var obj=document.getElementById("BFoot");
		DHCWeb_DisBtn(obj);
		SetUnFootFlag();
	}else{
		SetFootFlag();
		BFind_Click();
	} 	
}
function GetUserInfoByUserCode(value)
{	
	var str=value.split("^");
	var obj=document.getElementById("OperName");
	if (obj) obj.value=str[0]
	var obj=document.getElementById("UserRowId");
	if (obj) obj.value=str[2]
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=str[3]	
}
function Print_Click()
{
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	var pagerows,pagenum,prtrow
	var encmeth=""
	var obj=document.getElementById('GetRepPath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"JF_OPFootHZ.xls" 
	//Template="d:\\JF_OPFootHZ.xls" 
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlApp.visible=true
	var GuserID=session['LOGON.USERID'] 
	var GetFootNum=document.getElementById('GetFootNum');
	if (GetFootNum) {var encmeth=GetFootNum.value} else {var encmeth=''};
	var FootNum=cspRunServerMethod(encmeth,GuserID)
	var i

	for (i=1;i<=FootNum;i++)
	{
		var GetFootData=document.getElementById('GetFootData');
		if (GetFootData) {var encmeth=GetFootData.value} else {var encmeth=''};
		var FootData=cspRunServerMethod(encmeth,GuserID,i)
		var FootDetail=FootData.split("^")
		xlsheet.cells(4+i,2).value=FootDetail[0]
		xlsheet.cells(4+i,3).value=FootDetail[1]
		xlsheet.cells(4+i,4).value=FootDetail[2]
		xlsheet.cells(4+i,5).value=FootDetail[3]
		xlsheet.cells(4+i,6).value=FootDetail[4]
		xlsheet.cells(4+i,7).value=FootDetail[5]
		xlsheet.cells(4+i,8).value=FootDetail[6]
		xlsheet.cells(4+i,9).value=FootDetail[7]
		xlsheet.cells(4+i,10).value=FootDetail[8]
	}
	AddGrid(xlsheet,5,2,3+i,10,5,2)
	
	var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	    StDate=StDate.split("/");
	    StDate=StDate[2]+"-"+StDate[1]+"-"+StDate[0]
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;   
	    EndDate=EndDate.split("/");
	    EndDate=EndDate[2]+"-"+EndDate[1]+"-"+EndDate[0]  
	var obj=document.getElementById("StartTime");
	if (obj) var StartTime=obj.value;
	var obj=document.getElementById("EndTime");
	if (obj) var EndTime=obj.value;      
	var date=new Date();
    var TodayDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
    var TodayTime=date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()
	xlsheet.cells(3,2).value="查询日期:"+StDate+" "+StartTime+"---"+EndDate+" "+EndTime
	xlsheet.cells(3,6).value="打印日期:"+TodayDate+" "+TodayTime+"  打印人:"+session['LOGON.USERNAME']
    
	
	xlsheet.PrintPreview();
	//xlsheet.printout
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
}
function AddGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{        
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}
function PrintClickHandler()
{
	try{
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
		encmeth=""
		var obj=document.getElementById("DateTrans");
		if (obj) encmeth=obj.value;		
		//if (""!=StDate) StDate=cspRunServerMethod(encmeth,StDate)
		//if (""!=EndDate) EndDate=cspRunServerMethod(encmeth,EndDate)
		var RepDate=StDate+" "+StartTime+t["zhi"]+EndDate+" "+EndTime
		//alert(StDate+"   "+EndDate+"   "+StartTime+"   "+EndTime+"   "+CurDate)
		var OperName=""
		var obj=document.getElementById("OperName");
		if (obj) OperName=obj.value;		
		var ZBR=session['LOGON.USERNAME'];	
		var Template=TemplatePath+"JFOP_BJZYYFootRep.xls";		
		encmeth=""
		var obj=document.getElementById('TMPJID')
		if (obj) var jid=obj.value; 
		var obj=document.getElementById("GetRowNum");
		if (obj) encmeth=obj.value; 
		var Rows=parseInt(cspRunServerMethod(encmeth,jid));
		//alert("Rows"+Rows)
		//OutPutExel
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet;
		//Title
		//var obj=document.getElementById('HeadTitle');
	  	//if (obj) xlsheet.cells(1,2)=obj.value;
		xlsheet.cells(2,8)=RepDate;		
		var xlsRow=4;
		var xlsCol=0;
		//Data
		//(TNo,TUserCode,TUserName,TGetNum,TGetSum,TRefundNum,TRefundSum,TAbortNum,TAbortSum,TAdmitNum,TCancelNum,TDischargeNum,TPrepayGetNum,TPrepayGetSum,TPrepayRefundNum,TPrepayRefundSum,TPrepayGiveNum,TPrepayGiveSum,JID)
		for (var i=1; i<=Rows; i++)
		{ 
			encmeth="";
			var obj=document.getElementById("ReadPrtData");
			if (obj) var encmeth=obj.value;			
			var RowStr=cspRunServerMethod(encmeth,jid,i-1);		
			var ary=RowStr.split("^");
			var Cols=ary.length; 
			/*
			xlsheet.cells(xlsRow+i,xlsCol+1)=ary[3];
			//xlsheet.cells(xlsRow+i,xlsCol+2)=ary[10];
			//xlsheet.cells(xlsRow+i,xlsCol+3)=ary[11];
			xlsheet.cells(xlsRow+i,xlsCol+2)=ary[13];
			xlsheet.cells(xlsRow+i,xlsCol+3)=ary[14];
			xlsheet.cells(xlsRow+i,xlsCol+4)=ary[17];
			xlsheet.cells(xlsRow+i,xlsCol+5)=ary[18];
			xlsheet.cells(xlsRow+i,xlsCol+6)=ary[6];
			xlsheet.cells(xlsRow+i,xlsCol+7)=ary[7];
			xlsheet.cells(xlsRow+i,xlsCol+8)=ary[8];
			xlsheet.cells(xlsRow+i,xlsCol+9)=ary[9];
			*/			
			for (var j=1; j<Cols; j++)
			{
				xlsheet.cells(xlsRow+i,xlsCol+j)=ary[j];
			}
		}		
		gridlist(xlsheet,xlsRow,xlsRow+i-1,1,Cols-1);		
		//Other
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["zbr"];
		xlsheet.cells(xlsRow+i,xlsCol+2)=ZBR;
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["shr"];
		xlsheet.cells(xlsRow+i,xlsCol+9)=t["bt"];
		xlsheet.cells(xlsRow+i,xlsCol+11)=CurDate+"    ";
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["JKR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["QZ"];
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["SHR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["KJS"];
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

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}
function UnloadHandler()
{	
	var myEncrypt=DHCWebD_GetObjValue("DELPRTTMPDATA");
	var myTMPGID=DHCWebD_GetObjValue("TMPJID");
	if (myEncrypt!="")
	{
		var mytmp=cspRunServerMethod(myEncrypt, myTMPGID);
	}
	
}
function LinkRec_Click(){
       var obj=document.getElementById("StDate");
	   if (obj) var StDate=obj.value;
	   var obj=document.getElementById("EndDate");
	   if (obj) var EndDate=obj.value;      
       var Guser=session['LOGON.USERID']
       var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillRecDetail&StDate='+StDate+'&EndDate='+EndDate+'&Guser='+Guser+"&Flag="+"Inv"
       window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')

}
function PrintCateFee_Click()
{
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	var pagerows,pagenum,prtrow
	var encmeth=""
	var obj=document.getElementById('GetRepPath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	Template=TemplatePath+"JF_OPFootHZCateDetail.xls" 
	//Template="d:\\JF_OPFootHZCateDetail.xls" 
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlApp.visible=true
	
	var GuserID=session['LOGON.USERID'] 
	var GetCateFee=document.getElementById('GetCateFee');
	if (GetCateFee) {var encmeth=GetCateFee.value} else {var encmeth=''};
	var CateFeeS=cspRunServerMethod(encmeth,GuserID)
	var CateFeeDetail=CateFeeS.split("&")
	
	var RowLength=CateFeeDetail.length;
	for(i=1;i<=RowLength;i++)
	{
		CateFeeColDetail=CateFeeDetail[i-1].split("^")
		ColLength=CateFeeColDetail.length;
		for(j=1;j<=ColLength;j++)
		{
			xlsheet.cells(5+i,j+1).value=CateFeeColDetail[j-1]
		}
	}
	AddGrid(xlsheet,5,1,4+i,ColLength,5,2)
	
	var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	    StDate=StDate.split("/");
	    StDate=StDate[2]+"-"+StDate[1]+"-"+StDate[0]
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;   
	    EndDate=EndDate.split("/");
	    EndDate=EndDate[2]+"-"+EndDate[1]+"-"+EndDate[0]   
	var obj=document.getElementById("StartTime");
	if (obj) var StartTime=obj.value;
	var obj=document.getElementById("EndTime");
	if (obj) var EndTime=obj.value;      
	
	var date=new Date();
    var TodayDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
    var TodayTime=date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()
    
    xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,6)).MergeCells=true
	xlsheet.cells(4,2).value="查询日期:"+StDate+" "+StartTime+"----"+EndDate+" "+EndTime
	
	xlsheet.cells(8+i,2).value="打印日期:"+TodayDate+" "+TodayTime
	xlsheet.cells(8+i,5).value="打印人:"+session['LOGON.USERNAME']
  
    //xlsheet.visable=true;
	xlsheet.PrintPreview();
	//xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
}


function PrintCT_Click()
{
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	var pagerows,pagenum,prtrow
	var encmeth=""
	var obj=document.getElementById('GetRepPath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"JF_OPFootCTDetail.xls" 
	//Template="d:\\JF_OPFootCTDetail.xls" 
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlApp.visible=true
	var GuserID=session['LOGON.USERID'] 
	var GetFootNum=document.getElementById('GetCTNum');
	if (GetFootNum) {var encmeth=GetFootNum.value} else {var encmeth=''};
	var FootNum=cspRunServerMethod(encmeth,GuserID)
	var i
	for (i=1;i<=FootNum;i++)
	{
		var GetFootData=document.getElementById('GetCTData');
		if (GetFootData) {var encmeth=GetFootData.value} else {var encmeth=''};
		var FootData=cspRunServerMethod(encmeth,GuserID,i)
		var FootDetail=FootData.split("^")
		xlsheet.cells(4+i,2).value=FootDetail[0]
		xlsheet.cells(4+i,3).value=FootDetail[1]
		xlsheet.cells(4+i,4).value=FootDetail[2]
		xlsheet.cells(4+i,5).value=FootDetail[3]
		xlsheet.cells(4+i,6).value=FootDetail[4]
	}
	AddGrid(xlsheet,5,2,3+i,6,5,2)
    //xlsheet.visable=true;
	xlsheet.PrintPreview();
	//xlsheet.printout
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
}
function HandInCheck_onclick()
{
	var obj=document.getElementById("HandInCheck")
	if (obj.checked==false) 
	{
		var obj=document.getElementById("FootStatus")
		obj.checked=false
	}
}
function PrtPaymFoot_Click(){
	
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	var pagerows,pagenum,prtrow
	
	var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;      
	
	var GetPayMAmt=document.getElementById('GetPayMAmt');
	if (GetPayMAmt) {var encmeth=GetPayMAmt.value} else {var encmeth=''};
	var DataStr=cspRunServerMethod(encmeth,StDate,EndDate)
    if (DataStr=="")  return;
    DataStr=DataStr.split(String.fromCharCode(2))

	var encmeth=""
	var obj=document.getElementById('GetRepPath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"JF_OPFootPayM.xls" 
	
	
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
    xlApp.Visible=true
     
	var UsrCode=session['LOGON.USERCODE'] 
	xlsheet.cells(2,3).value=StDate+"  --  "+EndDate
	xlsheet.cells(2,8).value=UsrCode
	var i
	for (i=0;i<=DataStr.length-1;i++)
	{
		var FootDetail=DataStr[i].split("^")
		xlsheet.cells(4+i,2).value=FootDetail[0]
		xlsheet.cells(4+i,3).value=FootDetail[1]
		xlsheet.cells(4+i,4).value=FootDetail[2]
		xlsheet.cells(4+i,5).value=FootDetail[3]
		xlsheet.cells(4+i,6).value=FootDetail[4]
		xlsheet.cells(4+i,7).value=FootDetail[5]
		xlsheet.cells(4+i,8).value=FootDetail[6]
	}
	AddGrid(xlsheet,4,2,3+i,8,4,2)
	
	xlsheet.PrintPreview();
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null	

	}

function BPrintPayMode_Click()
{
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	var pagerows,pagenum,prtrow
	var encmeth=""
	var obj=document.getElementById('GetRepPath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"JF_OPPayModeDetail.xls" 
	//var Template="d:\\JF_OPPayModeDetail.xls" 
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlApp.visible=true
	
	var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	    StDate=StDate.split("/");
	    StDate=StDate[2]+"-"+StDate[1]+"-"+StDate[0]
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;   
	    EndDate=EndDate.split("/");
	    EndDate=EndDate[2]+"-"+EndDate[1]+"-"+EndDate[0]
	var obj=document.getElementById("StartTime");
	if (obj) var StartTime=obj.value;
	var obj=document.getElementById("EndTime");
	if (obj) var EndTime=obj.value;      
	var date=new Date();
    var TodayDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
    var TodayTime=date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()
	xlsheet.cells(3,1).value="开始日期:"+StDate+" "+StartTime
	xlsheet.cells(4,1).value="结束日期:"+EndDate+" "+EndTime
	xlsheet.cells(3,10).value="打印日期:"+TodayDate+" "+TodayTime
	xlsheet.cells(4,10).value="打印人:"+session['LOGON.USERNAME']
	
	var job=document.getElementById('Tjobz'+1);
	var Tjob=job.innerText;
	
    var GetPayModeDetail=document.getElementById('GetPayModeDetail');
	if (GetPayModeDetail) {var encmeth=GetPayModeDetail.value} else {var encmeth=''};
	var PayModeDetail=cspRunServerMethod(encmeth)
	
	var PayModeDetail=PayModeDetail.split("^")
	var PayModeLength=PayModeDetail.length;
    for (j=2;j<PayModeLength;j++)
    {
		xlsheet.cells(5,j).value=PayModeDetail[j]
    }
    xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,PayModeLength-1)).MergeCells=true
	var GetDataNum=document.getElementById('GetDataNum');
	if (GetDataNum) {var encmeth=GetDataNum.value} else {var encmeth=''};
	var PayModeDataNum=cspRunServerMethod(encmeth,Tjob)
	
	var i
	for (i=1;i<=PayModeDataNum;i++)
	{
		var GetPayModeData=document.getElementById('GetPayModeData');
		if (GetPayModeData) {var encmeth=GetPayModeData.value} else {var encmeth=''};
		var PayData=cspRunServerMethod(encmeth,Tjob,i)
		var PayData=PayData.split("^")
		    DataLength=PayData.length;
		for (j=1;j<=DataLength;j++)
		{
			xlsheet.cells(5+i,j).value=PayData[j-1]
		}
	}
	AddGrid(xlsheet,5,2,4+i,j,5,1)
	
	//xlsheet.visable=true;
    xlsheet.PrintPreview();
    //xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

}
function PrintUserCateFee_Click()
{
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	var pagerows,pagenum,prtrow
	var encmeth=""
	var obj=document.getElementById('GetRepPath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	Template=TemplatePath+"JF_OPFootUserHZCateDetail.xls" 
	//Template="d:\\JF_OPFootHZCateDetail.xls" 
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	
	xlApp.visible=true
	var GuserID=session['LOGON.USERID'] 
	var job=document.getElementById('Tjobz'+1);
	var Tjob=job.innerText;
 
	var Num=tkMakeServerCall("web.UDHCJFOPHandin8","GetUserCateNum",Tjob)
  
	var i
	for (i=1;i<=Num;i++)
	{
		var PayData=tkMakeServerCall("web.UDHCJFOPHandin8","GetUserCateData",Tjob,i)
		var PayData=PayData.split("^")
		    DataLength=PayData.length;
		for (j=1;j<=DataLength;j++)
		{
			xlsheet.cells(3+i,j).value=PayData[j-1]
		}
	}
	AddGrid(xlsheet,5,2,3+i,j,4,1)
   var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	    StDate=StDate.split("/");
	    StDate=StDate[2]+"-"+StDate[1]+"-"+StDate[0]
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;   
	    EndDate=EndDate.split("/");
	    EndDate=EndDate[2]+"-"+EndDate[1]+"-"+EndDate[0]
	var obj=document.getElementById("StartTime");
	if (obj) var StartTime=obj.value;
	var obj=document.getElementById("EndTime");
	if (obj) var EndTime=obj.value;      
	var date=new Date();
    var TodayDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
    var TodayTime=date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()
    xlsheet.cells(3,3).value=StDate+" "+StartTime+"   "+EndDate+" "+EndTime
	xlsheet.cells(3,8).value="打印日期:"+TodayDate+" "+TodayTime
	xlsheet.cells(3,11).value="打印人:"+session['LOGON.USERNAME']
    //xlsheet.visable=true;
	xlsheet.PrintPreview();
	//xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
}	
document.body.onload = BodyLoadHandler;
document.body.onbeforeunload=UnloadHandler
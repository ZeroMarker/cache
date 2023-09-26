var prnpath;
var hospname;
var CurrRow=0;
function BodyLoadHandler()
{	
		var obj;
	
  obj=document.getElementById("Print");
	 if (obj) obj.onclick=PrintClick;
	 obj=document.getElementById("Find");
	 if (obj) obj.onclick=FindClick;
	 obj=document.getElementById("Acknowledge");
		if (obj) obj.onclick=AckClick;
	 obj=document.getElementById("Delete");
	 if (obj) obj.onclick=DeleteClick;
	 obj=document.getElementById("Clear");
		if (obj) obj.onclick=ClearClick;
	
	 var objward=document.getElementById("Ward"); //2005-05-26
	 if (objward) 
		{
			objward.onkeydown=popWard;
	 	objward.onblur=wardCheck;
		} 
		
		obj=document.getElementById("DispLoc");
		if (obj) 
		{obj.onkeydown=popDispLoc;
	 	obj.onblur=DispLocCheck;
		} 
		
		obj=document.getElementById("AckChoose");
	 if (obj) obj.onclick=MakeAcknowledge;
	 
		obj=document.getElementById("bodyloaded");
		if (obj.value!=1)
		{		
				SetDefaultValue();    
		}
	
		setBodyLoaded();
		
		SetAuthority();
		
		//select the first row as default when the page is opened 
	//selectRow(1)
		
		
}

function popWard()     
{
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
		}
}

function popDispLoc()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}
}

function wardCheck()
{
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("wardid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

}
	
function DispLocCheck()
{
	
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}
	
function FindClick()
{
		Find_click();
}

function SelectRowHandler()
{
	var ackflag="";
	var displocid="";
	var row=selectedRow(window);	
	CurrRow=row
	if (row<1) return ; //
 
	var dhcpcdr=GetColumnData("TMainId",row)

 /*
 var obj=document.getElementById("ackflag")
 if(obj)
 { ackflag=obj.value;}
 */
 /*
 var obj=document.getElementById("displocid")
 if(obj)
 { displocid=obj.value;}
 */
 displocid=GetColumnData("TDispLocRowid",row)
 ackuser=GetColumnData("TAckUser",row)
 
 ackflag="N"
 if ((ackuser!="")&&(ackuser!=" ")) ackflag="Y"
 
 var docu=parent.frames['dhcpha.callbackitm'].window.document	
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.callbackitm&dhcpcdr="+dhcpcdr+"&ackflag="+ackflag+"&displocid="+displocid;
	docu.location.href=lnk ;
}

function GetColumnData(ColName,Row)
{
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox")
			{return CellObj.checked;}
			else
			{return CellObj.value;}
		}
	}
	return "";
}

function PrintClick()
{
		Print();
	ReloadMainWindow()		
}

function Print()
{
		var row=CurrRow;
		if(row<1) return;
		
		GetPrnPath();
		GetHospname();
		
		var callbackno=GetColumnData("TCallbackNo",row);
		var ret=CheckPrint(callbackno);
		if (ret==1)
		{
				alert(t["CANNOT_PRINT"]);
				return ;		
		}
		else if(ret==0)
		{
				if(SetPrintFlag(callbackno)=="")
				{
						alert(t["SET_PRINT_FAIL"]);
						return ;	
				}
		}
		var ward=GetColumnData("TWard",row);
		var disploc=GetColumnData("TDispLoc",row);
		var createuser=GetColumnData("TCallbackUser",row);
		var createdate=GetColumnData("TCallbackDate",row);
		var ackuser=GetColumnData("TAckUser",row);
		
		var docu=parent.frames['dhcpha.callbackitm'].window.document	
		var objtbl=docu.getElementById("tdhcpha_callbackitm") ;
		if (objtbl) var Rows=objtbl.rows.length;
	//start printing ...
	if (prnpath=="") 
	{
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
	}
	var Template=prnpath+"STP_Callback.XLS";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
 var startNo=4 ;
 var row ;
 var totalamt=0;
 
	if (xlsheet==null) 
	{	
		alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;		
	}
	
	xlsheet.Cells(1, 1).Value = hospname;  
	xlsheet.Cells(2, 1).Value = t['CALLBACKNO']+callbackno+"     "+ t['WARD']+ward+"      "+t['DISPLOC']+disploc;
	xlsheet.Cells(3, 1).Value = t['CALLBACKDATE']	+ createdate+"       "+t['CREATEUSER']+createuser;   

	for(var i=1;i<Rows;i++)
	{
				var inci=GetColumnDataItm("TInci",i);
				var barcode=GetColumnDataItm("TBarCode",i);
				var form=GetColumnDataItm("TForm",i);
				var manf=GetColumnDataItm("TManf",i);
				var qty=GetColumnDataItm("TQty",i);
		  var uom=GetColumnDataItm("TUom",i);
		  var price=GetColumnDataItm("TPrice",i);
		  var amt=GetColumnDataItm("TAmt",i);
		  
		  	row=startNo+i ;     			
	    xlsheet.Cells(row, 1).Value =inci;
	    xlsheet.Cells(row, 2).Value=barcode;
	    xlsheet.Cells(row, 3).Value=form;
	    xlsheet.Cells(row, 4).Value=manf;
	    xlsheet.Cells(row, 5).Value=qty;
	    xlsheet.Cells(row, 6).Value=uom;
	    xlsheet.Cells(row, 7).Value=price;
	    xlsheet.Cells(row, 8).Value=amt; 
	    
	    setBottomLine(xlsheet,row,1,8);
	    cellEdgeRightLine(xlsheet,row,1,8);
	    totalamt=parseFloat(totalamt)+parseFloat(amt);
	}

 row=row+2;
 mergecell(xlsheet,row,row,1,8);
 xlsheet.Cells(row,1).value=t['OPERATOR']+session['LOGON.USERNAME']+"     "+t['ACKUSER']+ackuser+"   "+t['TOTAL']+totalamt ;
 
 xlsheet.printout();
 SetNothing(xlApp,xlBook,xlsheet);	
 
}
	
function DispLocLookUpSelect(str)
{
	var ss=str.split("^") ;
  if ( ss.length>0) 
  { 
   var obj=document.getElementById("displocid") ;
   if (obj) obj.value=ss[1] ; // rowid of the disp loc
  
  
    //set "displocrowid" of detail web page
  
			var docu=parent.frames['dhcpha.callbackitm'].window.document;
   var obj=docu.getElementById("displocid");
   if (obj) obj.value=ss[1] ;
   }
}

function WardLookUpSelect(str)
{
	var ward=str.split("^");
	var obj=document.getElementById("wardid");
	if (obj)
	{if (ward.length>0)   obj.value=ward[1] ;
		else  obj.value="" ;  
	 }	

}

function SetDefaultValue()
{
			var startdate=today();
			var enddate=today();
			var ackflag="N";
			
			var obj=document.getElementById("StartDate");
			if (obj)
			{ obj.value=startdate;}
			
			var obj=document.getElementById("EndDate");
			if (obj)
			{ obj.value=enddate;}
			
			var obj=document.getElementById("ackflag");
			if (obj)
			{ obj.value=ackflag;}
			
}

function setBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;
	if (obj) obj.value=1;
}

function MakeAcknowledge()
{
	var obj=document.getElementById("AckChoose")
	if(obj.checked==true)
	{
			var objack=document.getElementById("ackflag");
			if(objack) objack.value="Y";
	}
	else
	{ 
			var objack=document.getElementById("ackflag");
			if(objack) objack.value="N";
	}
}

function AckClick()
{
 var obj=document.getElementById("Acknowledge")
 if (obj.disabled==true)   return ;
 
	var row=CurrRow

	//alert(CurrRow)
	if(row<1) return;

	var dhcpcdr=GetColumnData("TMainId",row)
	if(dhcpcdr=="")
	{
			alert(t['NO_DATA']);
			return;
	}
	
	var ret=AckData(dhcpcdr);

	if(ret>0)
	{
		alert(t['ACK_SUCCESS']);
		//ReloadMainWindow()
		LoadDetailPageAfterAcked("")
	}
	else
	{
		if (ret<0)	alert(t['ACK_FAILURE']);
		else alert(t['ALREADY_ACKED']);
	}
	ReloadMainWindow()
	
}
function LoadDetailPageAfterAcked(dhcpcb)
{
	var docu=parent.frames['dhcpha.callbackitm'].window.document
 var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.callbackitm&dhcpcdr="+dhcpcb;
	docu.location.href=lnk
	}

function AckData(dhcpcdr)
{
	
 var userid=session['LOGON.USERID'];
	var obj=document.getElementById("mUpdateAck");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}	
 
	var ret=cspRunServerMethod(encmeth,dhcpcdr,userid) ;

	return ret
}

function ReloadMainWindow()
{
			/*var objward=document.getElementById("Ward")
			if(objward) var ward=objward.value;
	  var objward=document.getElementById("wardid")
			if(objward) var wardid=objward.value;
			var objdisloc=document.getElementById("DispLoc")
			if(objdisloc) var disploc=objdisloc.value; 
			var objdisloc=document.getElementById("displocid")
			if(objdisloc) var displocid=objdisloc.value; 
			var obj=document.getElementById("StartDate")
			if(obj) var startdate=obj.value; 
			var obj=document.getElementById("EndDate")
			if(obj) var enddate=obj.value; 
			var obj=document.getElementById("ackflag")
			if(obj) var ackflag=obj.value; 
			
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.callbackmain&DispLoc="+disploc+"&displocid="+displocid+"&Ward="+ward+"&wardid="+wardid+"&StartDate="+startdate+"&EndDate="+enddate+"&ackflag="+ackflag;
			docu.location.href=lnk ; */
			
			Find_click();
	
}

function DeleteClick()
{
	var obj=document.getElementById("Delete" )
	if (obj.disabled==true)   return ;

 var row=CurrRow;
	if(row<1) return;

	var dhcpcdr=GetColumnData("TMainId",row)
	if(dhcpcdr=="")
	{
			alert(t['NO_DATA']);
			return;
	}
	
	var answer=confirm(t['ASK_BEFORE_DELETE'])
	if (answer==false) return 
	
	var ret=DeleteData(dhcpcdr);

 if(ret=="0")
 {
	 	alert(t['CANNOTDELETE']);
	}else if(ret=="1")
	{
		alert(t['DELETE_SUCCESS']);
		
		ReloadMainWindow()
	}
	else
	{
		alert(t['DELETE_FAILURE']);
	}
	 
}

function DeleteData(dhcpcdr)
{
	
	var obj=document.getElementById("mDelete");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}	
 
	var ret=cspRunServerMethod(encmeth,dhcpcdr) ;

	return ret
}

function GetPrnPath()
{
			var obj=document.getElementById("mGetPrnPath") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			prnpath=cspRunServerMethod(encmeth,'','') ;	
}

function GetHospname()
{
		var obj=document.getElementById("mPrtHospName") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		hospname=cspRunServerMethod(encmeth,'','') ;
}

function GetColumnDataItm(ColName,Row)
{
		var docu=parent.frames['dhcpha.callbackitm'].window.document
		var CellObj=docu.getElementById(ColName+"z"+Row);
		
		if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox")
			{return CellObj.checked;}
			else
			{return CellObj.value;}
		}
	}
	return "";
}

function SetNothing(app,book,sheet)
{
	app=null;
	book.Close(savechanges=false);
	sheet=null;
}

function setBottomLine(objSheet,row,startcol,colnum)
{
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;

}

function mergecell(objSheet,row1,row2,c1,c2)
{
        objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).MergeCells =1;
}

function fontcell(objSheet,row,c1,c2,num)
{
	objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).Font.Size =num;
}

function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
}

function GetLocType(locid)
{
		if(locid=="") return;
		
		var obj=document.getElementById("mGetLocType");
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}	
 
		var ret=cspRunServerMethod(encmeth,'','',locid) ;

		return ret
}

function SetAuthority()
{
		var locid=session['LOGON.CTLOCID'];
		var ret=GetLocType(locid);
		var arr=ret.split("^");
		var loctype=arr[0];
		var locdesc=arr[1]
	
		if(loctype=="D")
		{
					var obj=document.getElementById("DispLoc");
					if (obj)
					{ obj.value=locdesc;}
					
					var obj=document.getElementById("displocid");
					if (obj)
					{ obj.value=locid;}
					
					var obj=document.getElementById("Ward");
					if (obj)
					{ 
							obj.disabled=false;
					}
					
					var obj=document.getElementById("Delete");
					if (obj)
					{ 
							obj.disabled=true;
					}
					
					var docu=parent.frames['dhcpha.callbackitm'].window.document;
					var obj=docu.getElementById("Add");
					if (obj)
					{ 
							obj.disabled=true;
					}
					
					var obj=docu.getElementById("Save");
					if (obj)
					{ 
							obj.disabled=true;
					}
					
					var obj=docu.getElementById("DeleteDetail");
					if (obj)
					{ 
							obj.disabled=true;
					}
		}
		else
		{
					var wardr=arr[2];
					var ward=arr[3];
					var obj=document.getElementById("Ward");
					if (obj)
					{ obj.value=ward;
							obj.disabled=true;
					}
					
					var obj=document.getElementById("wardid");
					if (obj)
					{ obj.value=wardr;}
					
					var obj=document.getElementById("Acknowledge");
					if (obj)
					{ 
							obj.disabled=true;
					}
		}
			
}

function GetPrintFlag(callbackno)
{
		if(callbackno=="") return;
		
		var obj=document.getElementById("mGetPrintFlag");
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}	
 
		var ret=cspRunServerMethod(encmeth,'','',callbackno) ;

		return ret
}

function CheckPrint(callbackno)
{
		if(callbackno=="") return;
			
		var locid=session['LOGON.CTLOCID'];
		var ret=GetLocType(locid);
		var arr=ret.split("^");
		var loctype=arr[0];
		var printflag=9;
		
		if(loctype=="W")
		{
				printflag=GetPrintFlag(callbackno);
		}
		
		return printflag;
}

function SetPrintFlag(callbackno)
{
		if(callbackno=="") return;
		
		var obj=document.getElementById("mSetPrintFlag");
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}	
 
		var ret=cspRunServerMethod(encmeth,'','',callbackno) ;
	
		return ret
}

function ClearClick()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.callbackmain" ;
	location.href=lnk;
	
	var docu=parent.frames['dhcpha.callbackitm'].window.document	
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.callbackitm";
	docu.location.href=lnk ;
}

document.body.onload=BodyLoadHandler;

var currentRow;
var prnpath;
var hospname;
function BodyLoadHandler()
{
	var obj=document.getElementById("RegNo")
	if (obj) obj.onblur=GetPaInfo;
	//var obj=document.getElementById("Print")
	//if (obj) obj.onclick=Print;
	var obj=document.getElementById("Print")
	if (obj) obj.onclick=printoutdrug;	
	var obj=document.getElementById("Exit")
	if (obj) obj.onclick=Exit;
	var obj=document.getElementById("Find")
	if (obj) obj.onclick=Find;	
	var obj=document.getElementById("Clear")
	if (obj) obj.onclick=Clear;	
	var obj=document.getElementById("DispLoc"); //2005-0606
	if (obj) 
	{obj.onkeydown=popDispLoc;
	 obj.onblur=DispLocCheck;
	} //2005-0606
	var obj=document.getElementById("Ward"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popWard;
	obj.onblur=WardCheck;
	} //2005-05-26
		
	
	//GetDefLoc();
	SetDefDate();
	//var obj=document.getElementById("RegNo")
	//if ((obj)&&(obj.value!="")) 
	//{GetPaInfo ;}
	GetPaInfo()
}
function Find()
{
	//validate the condition 
	
	var obj=document.getElementById("PaAdm")
	if ((obj)&&(obj.options.selectedIndex>=0) )
	{
		var obj2=document.getElementById("Adm")	
		if (obj2) obj2.value=obj.value
	}
	var obj2=document.getElementById("Adm")
	if (obj2.value=="")
	{
	  var obj1=document.getElementById("StartDate")
	  var obj2=document.getElementById("EndDate")
	  var obj3=document.getElementById("Ward") 
	  if ((obj1.value=="")||((obj2.value==""))||((obj3.value=="")))
	  {
	    	   alert("如果没有选择病人信息，起始日期、截至日期、病区为必填项！！")
		   return;	  
	  
	  }
	
	}
	
	
	
	Find_click()
}
function SetDefDate()
{
	}
function Clear()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintoutdrugpaX"
	parent.frames['dhcpha.dispprintoutdrugpaX'].location.href=lnk;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintoutdrugX"
	parent.frames['dhcpha.dispprintoutdrugX'].location.href=lnk;
	}
function DispLocCheck()
{
	// //2005-0606
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}// //2005-0606
	
function popDispLoc()
{ //2005-0606
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}//2005-0606
	}	
function popWard()     
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
		}
}//2006-05-26
	
function WardCheck()
{// 2006-05-26
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("wardrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

}// 2006-05-26

function GetDefLoc()
{	
	var userid=session['LOGON.USERID'] ;
	var obj=document.getElementById("mGetDefaultLoc") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
	
}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("DispLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("displocrowid") ;
	if (obj) obj.value=locdr
}
function SelectRowHandler() {
	currentRow=selectedRow(window);
	var obj=document.getElementById("tPCODRowid"+"z"+currentRow) ;
	if (obj)
	{
		var pcodrowid=obj.value
			
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintoutdrugX&PCODROWID="+pcodrowid	
		parent.frames['dhcpha.dispprintoutdrugX'].location.href=lnk;
	}
}
function GetPaInfo()
{
  	var regno;
 	//when RegNo lost focus then this event fires .
	var objregno=document.getElementById("RegNo") ;
	if (objregno) regno=objregno.value ;
	if (regno=="")
	{ 	ClearAdm();
		 return ;
	}
	else
	{ 
	  regno=getRegNo(regno) ;
	//  alert(regno);
	  objregno.value=regno
	}
 	
 	var obj=document.getElementById("mGetPa") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'SetPa','',regno) ;

	//set patient info

     var getadm=document.getElementById('mGetAdm');
	if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetAdm','',regno)=='0') {}  
}

function SetPa(value)
{
  //set patient info of compoment
	var painfo=value.split("^")	;
	var obj;
	obj=document.getElementById("PaInfo");
	if (obj)
	{if (painfo.length >0)
		obj.value=painfo[0]+" -- " +painfo[1] + " -- " +painfo[2] ;
	 else
	 	{alert(t['INVALID_REGNO']) ;
	 	 return ;
	 	}
	}
}
function SetAdm(value)
{ 
	var ss=value.split("^") ;
	if (ss.length<1) return ;
	var obj=document.getElementById("PaAdm") ;
	var i;
	var xx ;
	var info;
	for (i=0;i<ss.length;i++) 
	{
		xx=ss[i] ;
		info=xx.split("&") ;

		if (obj)
		{obj.options[i]=new Option (info[1],info[0]) ;
			}
		}
	if (obj.options.length>0)
	{obj.options.selectedIndex=0 ;
	 var objadm=document.getElementById("Adm") ;
	 if (objadm) objadm.value=obj.value;
	
	}
	
	}

function DispLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("displocrowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
}
function WardLookUpSelect(str)
{	var ss=str.split("^");
	var obj=document.getElementById("wardrowid");
	if (obj)
	{if (ss.length>0)   obj.value=ss[1] ;
		else	obj.value="" ;  
	}
}
	
function ClearAdm()
{ obj=document.getElementById("PaInfo") ;
	   if (obj) obj.value="" ;
	   obj=document.getElementById("PaAdm") ;
	   if (obj) obj.options.length=0 ;
	}
function Print()
{
	var cnt ;
	var PCOD ;
	
	//var objtbl=document.getElementById("t"+"dhcpha_dispprintoutdrugX")
	//if (objtbl) cnt=getRowcount(objtbl);
	//if (cnt<=0) return ;
	//alert(currentRow)
	//return ;
	if (currentRow<1) return ;
	
 	var obj=document.getElementById("tPCODRowid"+"z"+currentRow)
 	if (obj) PCOD=obj.value
 	if (PCOD=="" ) return ;
	var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	hospname=cspRunServerMethod(encmeth,'','') ;
	//alert("hospname:"+hospname);

	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}

	//retrieving primary dispensing infomation...
	var startNo=5;
	var DispUser=session['LOGON.USERNAME']
	//
	var Template=prnpath+"STP_DrugOut.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
    var startNo=7 ;
    var i ;
	if (xlsheet==null) 
	{alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;
	}

	var obj=document.getElementById("mGetOutCollect") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,PCOD) ;
	var ss=data.split("^");
	var pid=ss[1];
	cnt=ss[0];

	var i;
	var pano;
	var paname;
	var pasex;
	var paage;
	var disploc;
	
	var objList=document.getElementById("mListOutCollect") ;
	if (objList) {xxxx=objList.value;} else {xxxx='';}
	var data=cspRunServerMethod(xxxx,pid,1);
	var ss=data.split("^");
	//alert(ss)
	pano=ss[0];
	paname=ss[1];
	pasex=ss[2];
	paage=ss[3];
	disploc=ss[19];
	
	xlsheet.Cells(1, 1).Value = hospname;  //hospital description
	
	xlsheet.Cells(3, 1).Value=t['PA_NO']+pano;
	xlsheet.Cells(3, 2).Value=t['PA_NAME']+paname;
	xlsheet.Cells(3, 4).Value=t['PA_SEX']+pasex;
	xlsheet.Cells(3, 5).Value=t['PA_AGE']+paage;
		
	xlsheet.Cells(4, 1).Value=t['PHARMACY']+getDesc(disploc);
	xlsheet.Cells(4, 2).Value=t['PRINTDATE']+getPrintDateTime();

	for (i=1;i<=cnt;i++)  
	{
		var data=cspRunServerMethod(xxxx,pid,i) ;
		var ss=data.split("^")
		
  //info1=pano_"^"_paname_"^"_pasex_"^"_padob_"^"_admloc
  //info2=prescno_"^"_doctor_"^"_code_"^"_desc_"^"_orderstatus
  // info3=doseqty_"^"_freq_"^"_qty_"^"_uom_"^"_sp_"^"_amt
   // info4=instruction_"^"_duration_"^"_orditemremark_"^"_disploc
 
		//get the patient infomation
		//var bedcode=ss[7];
		//var name=ss[1];
		//var paregno= ss[0];
		
		var desc=ss[8];
		//var dosqty=ss[10];
		//var freq= ss[11];
	
		var qty= ss[12];
		var uom=ss[13];
		var saleprice=ss[14];
		var amt=ss[15];
		//var prescno= ss[5];  //prescript No
		//var ordstatus=ss[9] ;
		//var instruction=ss[16];
		//var duration= ss[17];
		//var admloc=ss[4] ;
		xlsheet.Cells(startNo+i, 1).Value =desc ; //desc
		xlsheet.Cells(startNo+i, 2).Value =qty // qty
		xlsheet.Cells(startNo+i, 3).Value =uom // unit 
		xlsheet.Cells(startNo+i, 4).Value =saleprice // sp
		xlsheet.Cells(startNo+i, 5).Value =amt // amount
		
	}
    row=startNo+i+2;
    //xlsheet.Cells(row,1).value= ;
    xlsheet.Cells(row,1).value=t['DISPEN_USER']+DispUser;
    xlsheet.Cells(row,4).value=t['REC_USER']
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
}

function Exit()	
{//window.close();	
//history.back();
 parent.close();
}
function printoutdrug()
{
	var pcod="";
    var n
    var tmprowid=""
    var AllWard=0
	if  (currentRow>0)
	{var obj=document.getElementById("tPCODRowid"+"z"+currentRow) ;
		if (obj) pcod=obj.value ;	
	}
	var objAllWard=document.getElementById("AllWard") ;
	if(objAllWard.checked==true) {AllWard=1}
    if (objAllWard.checked==true)
    {
	     var objtbl=document.getElementById("t"+"dhcpha_dispprintoutdrugpaX");
	     if (objtbl)	rowcnt=getRowcount(objtbl)
	     for(n=1;n<=rowcnt;n++)
	     {
		     var objrowid=document.getElementById("tPCODRowid"+"z"+n) ;
		     if ( tmprowid==""){tmprowid=objrowid.value}
		     else {tmprowid=tmprowid+"^"+objrowid.value}
	     }
	     
	     pcod=tmprowid
	 
   }
 
	
	if (pcod=="") return ;
	
	 
	/// -------如果按单个患者打印则注释
	var detailprn=0;totalprn=0;
	var objDetailPrn=document.getElementById("DetailPrn");
	var objTotalPrn=document.getElementById("TotalPrn");
    if (objDetailPrn.checked==true){var detailprn=1} 
	if (objTotalPrn.checked==true){var totalprn=1} // 获取打印方式
	if ((objDetailPrn.checked==false)&&(objTotalPrn.checked==false)) {
		alert("请选择打印方式 <打印汇总> <打印明细>")
		return;}
	
	
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintoutdrug&PCODROWID="+pcod+"&DetailPrn="+detailprn+"&TotalPrn="+totalprn+"&RePrintFlag="+1+"&AllWard="+AllWard;
	parent.frames['dhcpha.dispprintoutdrug'].window.document.location.href=lnk;
	//window.open(lnk)
}
	
document.body.onload=BodyLoadHandler;

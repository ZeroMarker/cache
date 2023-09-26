var ggroupid;

function BodyLoadHandler()
{ 
	ggroupid=session['LOGON.GROUPID'];
	var obj=document.getElementById("OK")
	if (obj) obj.onclick=SetAndQuit;
	var obj=document.getElementById("Cancel")
	if (obj) obj.onclick=QuitWin;
	var obj=document.getElementById("Add")
	if (obj) obj.onclick=AddDispLoc;
	var obj=document.getElementById("OpPrintFmtSet")
	if (obj) obj.ondblclick=delDispLoc;
	//
	setCatList();
	GetPara();
}

function AddDispLoc()
{
	var obj1=document.getElementById("displocrowid") ;
	if (obj1)	var locrowid=obj1.value;
	var obj2=document.getElementById("DispLoc") ;
	if (obj2) var locdesc=obj2.value;	
	var objLocList=document.getElementById("OpPrintFmtSet") ;
	if (objLocList)
		{
		if ((locdesc!="")&&(locrowid!=""))
		objLocList.options[objLocList.length]=new Option(locdesc,locrowid) ;
		obj1.value="";
		obj2.value="";
		}
}
function dispLocLookUpSelect(value)
{
	var obj=document.getElementById("displocrowid") ;
	if (obj)
	{	if (value=="") obj.value="";
		else
		{
			var loc=value.split("^");
			var locrowid=loc[1] ;
			obj.value=locrowid;
		}
	}
}
	
function delDispLoc()
{
	var obj=document.getElementById("OpPrintFmtSet")
	var ind=obj.options.selectedIndex;
	if (ind>=0)
	{
		obj.options.remove(ind)	;
		}	
}	
function SetAndQuit()
{
	SetPara()
	window.close();
}
function QuitWin()
{
	window.close() ;}

function SetPara()
{
		group=ggroupid;
		
		var CatList ;
		var defaultCats=""    //
		var prnTotal="" ;
		
		var obj=document.getElementById("DispCatList");
		if (obj) 
		{	var cats=obj.value;
			CatList=cats.split("^");}

		for (i=0;i<10;i++)
		{
			var obj=document.getElementById("cat"+i);
			if (obj) 
			{if (obj.checked==true) 
				{if (defaultCats=="") defaultCats=CatList[i];
				 else {defaultCats=defaultCats+"&"+CatList[i]; }
				}
			}
		}
		//alert(defaultCats);

		for (i=0;i<10;i++)
		{
			var obj=document.getElementById("printTotalCat"+i)
			if ((obj)&&(obj.checked==true))
			{
			   if (prnTotal=="") prnTotal=CatList[i];
			   else {prnTotal=prnTotal+"&"+CatList[i];}
			}
		}
			
		var disp_sd=document.getElementById("DispStartDate");
		var disp_ed=document.getElementById("DispEndDate");
		
		var stat_sd=document.getElementById("StatStartDate");
		var stat_ed=document.getElementById("StatEndDate");
		var stat_st=document.getElementById("StatStartTime");
		var stat_et=document.getElementById("StatEndTime");
		
		var dispdate=disp_sd.value+"&"+disp_ed.value
		var tjdispdatetime=stat_sd.value+"&"+stat_ed.value+"&"+stat_st.value+"&"+stat_et.value
		
		var s=defaultCats+"^"+dispdate+"^"+ tjdispdatetime+"^"+prnTotal
		
		var setpara=document.getElementById("mSetPara");
		if (setpara) {var encmeth=setpara.value;} else {var encmeth='';}
		var ss=cspRunServerMethod(encmeth,'','SetPara',ggroupid,s) ;
				
		SavePrintFormat();
	}

function SavePrintFormat()
{
	ClearPrintFmt();
	var setOpPrtFmt=document.getElementById("mSetOpPrintFmt") ;
	if (setOpPrtFmt) {var encmeth=setOpPrtFmt.value;} else {var encmeth='';}
	  
	var opprintloc=document.getElementById("OpPrintFmtSet") ;
	if (!opprintloc)
	{	alert(t['SAVE_OPPRTFMT_FAILED']) ;
		 return ;	}
	else
		var len1=opprintloc.options.length ;
	for (var i=0;i<len1;i++)
	{   
		var locdr=opprintloc.options[i].value;
		//   #server(web.DHCSTPCHCOLLS2.SetPrintFmt(locdr,"O"))#;
		var ss=cspRunServerMethod(encmeth,'','',locdr,"O") ;
	}		
}
function ClearPrintFmt()
{
	var par=document.getElementById("mClearPrintFmt") ;
	if (par) {var encmeth=par.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'','') ;
	
	}
function GetPara()
{	
	var par=document.getElementById("mGetPara") ;
	if (par) {var encmeth=par.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'','',ggroupid) ;
	LoadPara( ss);
	}
function LoadPara(ss)
{

	if  (ss=="") return ;
	var tmparr=ss.split("^");

	if (tmparr.length<=0) return ;
	var disptype=tmparr[0];
	if (disptype!="")
	{
		var disptypeArr=disptype.split("&");
		
		var len=disptypeArr.length ;
		var obj=document.getElementById("DispCatList") ;
		var sss=(obj.value) ;
		var catlist= sss.split("^");
		var lencatlist=catlist.length ;
		for (i=0;i<len;i++)
		{
			for (j=0;j<lencatlist;j++)
			{if (disptypeArr[i]==catlist[j]){
				var obj=document.getElementById("cat"+j) ;
				obj.checked=true; }
			}		
		}
	}
	var dispdate=tmparr[1];
	if (dispdate!="")
	{
		var dispdateArr=dispdate.split("&");
		var disp_sd=document.getElementById("DispStartDate")
		var disp_ed=document.getElementById("DispEndDate")
		
		if (dispdateArr.length>0){
			disp_sd.value=dispdateArr[0]
			disp_ed.value=dispdateArr[1]; }
	}
	var disptjdate=tmparr[2] ;
	if (disptjdate!="")
	{
		var disptjdatetimeArr=disptjdate.split("&");
		var stat_sd=document.getElementById("StatStartDate")
		var stat_ed=document.getElementById("StatEndDate")
		var stat_st=document.getElementById("StatStartTime")
		var stat_et=document.getElementById("StatEndTime")
		if (disptjdatetimeArr.length>0) {
			stat_sd.value=disptjdatetimeArr[0]
			stat_ed.value=disptjdatetimeArr[1];
			stat_st.value=disptjdatetimeArr[2]
			stat_et.value=disptjdatetimeArr[3]; }
	}
	var printsetup=tmparr[3] ;
	if (printsetup!="")
	{

		var printarr=printsetup.split("&") ;
		if (printarr.length>0) {

			var len=printarr.length ;
			var obj=document.getElementById("DispCatList") ;
			var sss=(obj.value) ;
			var catlist= sss.split("^");
			var lencatlist=catlist.length ;
			for (i=0;i<len;i++)
			{
				for (j=0;j<lencatlist;j++)
				{if (printarr[i]==catlist[j]){
					var obj=document.getElementById("printTotalCat"+j) 
					obj.checked=true; }	
				}	
			}
		}
	}
	var opprtfmtloc=getOpPrtFmt();
	var objOpPrtLoc=document.getElementById("OpPrintFmtSet")
	if (opprtfmtloc=="")
	{}
	else
	{
		tmparr=opprtfmtloc.split("^")
		for (i=0;i<tmparr.length;i++)
		{
			tmparr2=tmparr[i].split("&");
			if (tmparr2[1]=="O") 
				objOpPrtLoc.options[objOpPrtLoc.options.length]=new Option(tmparr2[2],tmparr2[0]);
		  }		
	}
}
function getOpPrtFmt()
{
	var opprtfmt=document.getElementById("mGetPrintFmtAll")
	if (opprtfmt) {var encmeth=opprtfmt.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'','') ;
	return ss
}
function setCatList()
{   //according to definition,display the dispensing category and description
	var obj=document.getElementById("mGetDrugType") ;
	if (obj) {var encmeth=obj.value}
	else {var encmeth=''};
	
	var result=cspRunServerMethod(encmeth)  ;
	var drugGrps=result.split("!")
	var cnt=drugGrps.length
	for (i=0;i<cnt;i++) {
		
		var drugGrpCode=drugGrps[i].split("^");
		var code=drugGrpCode[0];
		var desc=drugGrpCode[1];
		

		var obj=document.getElementById("c"+"cat"+i) ;
		if (obj) 
		{
			obj.innerText=desc;
		}

		var obj=document.getElementById("c"+"printTotalCat"+i) ;
		if (obj) 
		{
			obj.innerText=t['PRINT_TOTAL']+desc;
		}

		var obj=document.getElementById("DispCatList")
		if (obj)
		{  
			if (obj.value=="") obj.value=code ;
		    else
		    	 obj.value=obj.value+"^"+code ;
		}
	//		var obj=document.getElementById("cat"+i) ;
	//	if (obj) obj.=desc;
	}

	var xx=cnt
	var j;
	for (j=xx;j<=9;j++)
	{
		var obj=document.getElementById("c"+"cat"+j) ;
		if (obj) 
		{
		window.document.all("cat"+j).style.display='none'   
		window.document.all("c"+"cat"+j).style.display='none'   ;         //not display
		window.document.all("printTotalCat"+j).style.display='none'   
		window.document.all("c"+"printTotalCat"+j).style.display='none'   ;         //not display
		}
	}	
}

document.body.onload=BodyLoadHandler;

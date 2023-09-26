var timer;
function BodyLoadHandler()
{	
  	var obj=document.getElementById("StartTimer");
	if (obj) obj.onclick=TimerHandler; 
	//var obj=document.getElementById("ReturnSelected");
	//if (obj) obj.onclick=ReturnSelected; 
	//var obj=document.getElementById("Exit");
	//if (obj) obj.onclick=ExitClick; 
	var obj=document.getElementById("Limit");
	if (obj) obj.onclick=MakeLimit; 
	var obj=document.getElementById("LimitCats");
	if(obj) obj.onchange=LimitCatsClick;
	var obj=document.getElementById("DispLoc"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popDispLoc;
	 obj.onblur=DispLocCheck;
	} //
		
	if (getBodyLoaded()!="1")
	{	
//		GetDefLoc()	;
	 //	getDefDateScope();
		setBodyLoaded();
	  	setDefaultValByLoc();
	}
  
  	var obj=document.getElementById("t"+"dhcpha_phaward")
  	if (obj)
  	{ 
  	   var findseek;
  	   var cnt=getRowcount(obj);
  	   
  	   var objseek=document.getElementById("Seeked");
	   if (objseek) findseek=objseek.value;
  	   if ((cnt<0))  
  	   {
	  	   if (findseek!="1") {
				RefreshWin(1);	
	  	    }
		  	else
		  	{  var obj=document.getElementById("Seeked")
			   var xx=obj.value;
			  	if ((cnt<0)&&(xx=="1")) 
			  	{alert(t['NO_SETUP']) ; 	}	}
		}
   }
  	if (getTimerFlag()==1) 	{Start(); }  
  	
  	PopulateCats();
  	CheckLimit();
  	GetLimitCats();
  	//if (CheckConPriorRefresh()==false) return ;
}

function popDispLoc()
{ //
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}
}//

function DispLocCheck()
{
	//
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 
	

function RefreshWin(val)
{
	if ( CheckConPriorRefresh()==false ) return;
	SetSeeked(val);
	var findobj=document.getElementById("Find")
	if (findobj) { findobj.click();}
}
function CheckConPriorRefresh()
{
	var obj=document.getElementById("displocrowid")
	if (obj)
	{if (obj.value=="") 
	{alert(t['DISPLOC_NEEDED'])
	  return false 	}
	}
	var obj1=document.getElementById("StartDate")
	if (obj1)
	{if (obj1.value=="") 
	  {alert(t['INVALID_SD']) ;
	   return false;    } }
	var obj2=document.getElementById("EndDate")
	if (obj2)
	{if (obj2.value=="") 
	  {alert(t['INVALID_ED']) ;
	   return  false;    } }
	if (DateStringCompare(obj1.value,obj2.value )==1)
	{alert(t['INVALID_DATESCOPE']);
	 return false;}
	 
	return true ;
}

function SetSeeked(val)
{
   var obj=document.getElementById("Seeked")
   if (obj) obj.value =val
}
function BodyBeforeUnLoadHandler()
{Stop();	}
function ExitClick()
{
	window.close();	
	}
function TimerHandler()
{
	var obj=document.getElementById("StartTimer") ;
	if (obj)
	 {
		 if (obj.checked==true)
			 {Start(); }
		 else
			  {Stop(); }
	 }
}

function Start()
{
	setTimerFlag(1);
	timer=setInterval("OnTimer()",30000); 
}
function Stop()
{	
	clearInterval(timer);
	setTimerFlag(0);
}
	
function getDefDateScope()
{
	var obj=document.getElementById("StartDate");
	if (obj) obj.value=today()
	var obj=document.getElementById("EndDate");
	if (obj) obj.value=today()
	
}
function OnTimer(){ 

   if (getTimerFlag()!=1) return ;
   
   var obj=document.getElementById("displocrowid");
   if (obj) var xdisplocrowid=obj.value;
   var obj=document.getElementById("DispLoc");
   if (obj) var xDispLoc=obj.value;
   var obj=document.getElementById("StartDate");
   if (obj) var xStartDate=obj.value;
   var obj=document.getElementById("EndDate");
   if (obj) var xEndDate=obj.value;
   var obj=document.getElementById("timerflag");
   if (obj) var xtimerflag=obj.value;
  var obj=document.getElementById("bodyloaded");
   if (obj) var xbodyloaded=obj.value;
   var obj=document.getElementById("limitflag");
   if (obj) var xlimit=obj.value;
   
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phaward&DispLoc="+xDispLoc+"&displocrowid="+xdisplocrowid+"&StartDate="+xStartDate+"&EndDate="+xEndDate+"&timerflag="+xtimerflag+"&bodyloaded="+xbodyloaded+"&limitflag="+xlimit;
	document.location.href=lnk ;
  
}

function setBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;
	if (obj) obj.value="1"
	
}

function GetDefLoc()
{		
	//alert(BodyLoaded);
	var userid=session['LOGON.USERID'] ;
	var obj=document.getElementById("mGetDefaultLoc") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
}

function LimitCatsClick()
{		
	
	var obj2=document.getElementById("LimitCats");
	
 	var newstr=""
 	
  	  for (var j=0;j<=obj2.options.length-1;j++)
  	  { 
	  	  
		  	  if (obj2.options[j].selected==true)
				{
				  if(newstr==""){newstr=obj2.options[j].value;}
				  else {newstr=newstr+"^"+obj2.options[j].value;}
				  
				} 
	  	  
  	  }
     
   
	SetLimitCats(newstr);
}

function SetLimitCats(newLimitCats)
{		     
	var obj=document.getElementById("mSetLimitCats") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'LimitCats',newLimitCats) ;
	
}

function GetLimitCats()
{		     
	var obj=document.getElementById("mGetLimitCats") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'LimitCats') ;
	
	var obj2=document.getElementById("LimitCats")
	
	var arr=ss.split("^");
	
	for (var j=0;j<=arr.length-1;j++)
  	  { 
	  	  for(var i=0; i<=obj2.options.length-1;i++)
	  	  {		
	  	  		
		  	  if (obj2.options[i].value==arr[j])
				{
				  obj2.options[i].selected=true;
				  				  				  
				} 
	  	  }
	  	  
  	  }
	
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
function DispLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("displocrowid");
	if (obj)
//	alert(obj.value)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
	RefreshWin(0);
}
function setTimerFlag(b)
{
	var obj=document.getElementById("timerflag") ;
	if (obj) obj.value=b;
}
function getTimerFlag()
{
	var obj=document.getElementById("timerflag") ;
	if (obj) 
	{ 
	return obj.value}
}
function setBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;	
	if (obj) 
	{obj.value="1" ;

	}
}
function getBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;	
	if (obj) {
	return obj.value ; }
}
function ReturnSelected()
{   

	var docu=parent.frames['dhcpha.phadisp'].document	
	if (docu){
		var obj=docu.getElementById("Collect")
		if (obj)
		 {obj.click()  } }

	var row;
	var sd;
	var ed;
	var ward;
	var wardrowid;
	var disploc ;
	var displocrowid;
	
	var obj=document.getElementById("StartDate")
	if (obj) sd=obj.value;
	var obj=document.getElementById("EndDate")
	if (obj) ed=obj.value;
	var obj=document.getElementById("DispLoc")
	if (obj) disploc=obj.value;
	var obj=document.getElementById("displocrowid")
	if (obj) displocrowid=obj.value;
	var obj=document.getElementById("CurrentRow");
	if (obj) row=obj.value;
	
    if (row<1) return ;
    
	var obj=document.getElementById("TWard"+"z"+row)
	if (obj) ward=obj.innerText ;
	var obj=document.getElementById("TWardRowid"+"z"+row)
	if (obj) wardrowid=obj.value ;
//	alert(wardrowid)
	
	if (wardrowid=="") return ;
	
	var pardocu=window.opener.document;
	
	if (pardocu) {
		var obj=pardocu.getElementById("StartDate")
		if (obj) {obj.value=sd ;}
		var obj=pardocu.getElementById("EndDate")
		if (obj) {obj.value=ed ;}
		var obj=pardocu.getElementById("Ward")
		if (obj) {obj.value=ward ;}
		var obj=pardocu.getElementById("wardrowid")
		if (obj) {obj.value=wardrowid ;}
		var obj=pardocu.getElementById("DispLoc")
		if (obj) {obj.value=disploc ;}
		var obj=pardocu.getElementById("displocrowid")
		if (obj) {obj.value=displocrowid ;}
	}
	setOpenerDispCats(pardocu,row)
	//CollectClick();
}
function setOpenerDispCats(pardocu,row)
{
	var catval	;
	for (i=0;i<10;i++)
	{
	
		var obj=document.getElementById("TCat"+i+"z"+row)
		if (obj) catval=obj.innerText ;
		var obj2=pardocu.getElementById("cat"+i)

		if (catval=="Yes") {obj2.checked=true;		}
		else		{obj2.checked=false;}
	}
}
function SelectRowHandler()
 {
	var row=selectedRow(window);
	var obj=document.getElementById("CurrentRow") ;
	if (obj) obj.value=row
	
	//alert(row)
	if (row<1) return ; //
	var sd,ed,ward,wardid,disploc,displocrowid
	
	var obj=document.getElementById("displocrowid")
	if (obj) displocrowid=obj.value;
	
	var obj=document.getElementById("DispLoc")
	if (obj) disploc=obj.value;
	var obj=document.getElementById("StartDate")
	if (obj) sd=obj.value;
	var obj=document.getElementById("EndDate")
	if (obj) ed=obj.value;
	
	row++;
	var obj=document.getElementById("TWardRowid"+"z"+row)
	if (obj) wardid=obj.value;
	var obj=document.getElementById("TWard"+"z"+row)
	if (obj) ward=obj.innerText;
	
	//alert(wardid)
	//alert(ward)
	
	//pass the info into dispensing interface
	var docu=parent.frames['dhcpha.phadisp'].document	
	if (docu){

		var obj=docu.getElementById("StartDate")
		if (obj) obj.value=sd
		var obj=docu.getElementById("EndDate")
		if (obj) obj.value=ed
		var obj=docu.getElementById("Ward")
		if (obj) obj.value=ward
		var obj=docu.getElementById("wardrowid")
		if (obj) obj.value=wardid

		var obj=docu.getElementById("DispLoc")
		if (obj) obj.value=disploc

		var obj=docu.getElementById("displocrowid")
		if (obj) obj.value=displocrowid

	  
		var obj=docu.getElementById("Collect")
		if (obj)
		{obj.click() }
 	}
}

function getPhaLocation(loc)
{ 
    var exe
	var obj=document.getElementById("mGetPhaLocSet")
	if (obj) exe=obj.value;
	else exe='';
	
	var sss=cspRunServerMethod(exe,loc);
	
	return sss;
}

function setDefaultValByLoc()
{
	var loc
	var obj=document.getElementById("displocrowid")
	if ((obj)&&(obj.value!=""))
	{
		loc=obj.value ;
	 	var sets=getPhaLocation(loc)
	 	
     if (sets!="")
     {
    
     var ss=sets.split("^")
     var sd ;
     var ed;
     var notwardrequired ;
     var auditneed ;
         
     sd=ss[2];
     ed=ss[3] ;
     notwardrequired=ss[0];
	 auditneed=ss[10];
	 
	// alert(sd)
	// alert(ed)
	 var startdate=CalcuDate(sd)
	 var enddate=CalcuDate(ed)
	 var obj=document.getElementById("StartDate");
	 if (obj) obj.value=startdate;
	 var obj=document.getElementById("EndDate");
	 if (obj) obj.value=enddate;
     }
	}
}
function CalcuDate(ss)
{	var obj=document.getElementById("mGetDate");
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var date=cspRunServerMethod(encmeth,'','',ss) ;
	return date	
}
function MakeLimit()
{
  var obj=document.getElementById("Limit")
  var objcats=document.getElementById("LimitCats")
  var objlimit=document.getElementById("limitflag")
  
  if ( obj.checked==true)
  {
	   
	  if(objlimit) objlimit.value=1;
	  window.document.all('LimitCats').style.display="inline"
   }
 else
 {  window.document.all('LimitCats').style.display="none"
  	if(objlimit) objlimit.value=0;
  } 	
	//alert(objlimit.value);
}

function CheckLimit()
{
  var obj=document.getElementById("Limit")
  //var objcats=document.getElementById("LimitCats")
  var objlimit=document.getElementById("limitflag")
  //alert(objlimit);
  
  if ( objlimit.value==1)
  {
	  obj.checked=true;
	  window.document.all('LimitCats').style.display="inline"
   }
 else
 {  window.document.all('LimitCats').style.display="none"
  	obj.checked=false;
  } 	
	
}

function PopulateCats()
{  
    var exe;
	var obj=document.getElementById("mPopulateDispCats")
	if (obj) exe=obj.value;
	else exe=""
	
	var objcats=document.getElementById("LimitCats");
	
	var obj=document.getElementById("displocrowid")
	
	if (obj.value=="") return ;
	var result=cspRunServerMethod(exe,obj.value)
	
	var ss=result.split("!")
	var cnt=ss.length
	var i;
	for (i=0;i<=cnt-1;i++)
	{

		var cat=ss[i].split("^")
		var catcode=cat[0];
		var catdesc=cat[1] ;
		
		if (objcats) { objcats.options[objcats.options.length]=new Option (catdesc,catcode) ; }
	  }
}
document.body.onload=BodyLoadHandler;
document.body.onbeforeunload=BodyBeforeUnLoadHandler;

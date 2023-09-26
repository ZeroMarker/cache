/// dhcpha.phaward.js
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
	if (obj) {
		obj.onkeydown=popDispLoc;
		obj.onblur=DispLocCheck;
	}
	if (getBodyLoaded()!="1"){
		setBodyLoaded();
		setDefaultValByLoc();
	}
	var macs=parent.window.macstring
    var objmac=document.getElementById("MACAddr");
    if (objmac) {objmac.value=macs;}
	var obj=document.getElementById("t"+"dhcpha_phaward");
	if (obj){ 
		var findseek;
		var cnt=getRowcount(obj);
		    
		var objseek=document.getElementById("Seeked");
		if (objseek) findseek=objseek.value;
		if (cnt<0){
			if (findseek!="1"){
				RefreshWin(1);
			}
			else{ 
				var obj=document.getElementById("Seeked");
				var xx=obj.value;
				if ((cnt<0)&&(xx=="1")){
					alert(t['NO_SETUP']) ;
				}
			}
		}
	}
	
	if (getTimerFlag()==1){Start(); }  
 
	 // ------------以前的版本用 --------------------
	 //PopulateCats();
	 //CheckLimit();
	 //GetLimitCats();
	 //--------------------------------------
 
	var findobj=document.getElementById("Find")
	if (findobj){
		RefreshWin(1)
		findobj.onclick=Find_Click;
	}
	var obj=document.getElementById("Ward"); 
	if (obj){
		obj.onkeydown=popWard;
		obj.onblur=wardCheck;
	}	
	var obj=document.getElementById("Local");
	if (obj) {obj.onclick=GetInitWard; }
	//InitWindow();

	document.onkeydown=OnKeyDownHandler; 
}



function OnKeyDownHandler(e)
{
       var key=websys_getKey(e);
       if (key==115){ReadHFMagCard_Click();}	//F4 
}
 
function ReadHFMagCard_Click()
{
	 var docu=parent.frames['dhcpha.phadisp'].document
     if (docu){
	     var objBReadCard=docu.getElementById("BReadCard") ;
	     if (objBReadCard){
		     objBReadCard.click()
	     }
     }
}


function InitWindow(){
	objmac=document.getElementById("MACAddr");
    if (objmac) objmac.style.visibility="hidden";
}

function Find_Click()
{
	RefreshWin(1);
}

function popDispLoc(){ 
	if (window.event.keyCode==13) {
		window.event.keyCode=117;
		DispLoc_lookuphandler();
	}
}

function DispLocCheck()
{
 var obj=document.getElementById("DispLoc");
 var obj2=document.getElementById("displocrowid");
 if (obj) 
 {if (obj.value=="") obj2.value="" }
} 
function RefreshWin(val)
{
 if ( CheckConPriorRefresh()==false ) return;
 SetSeeked(val);
 var findobj=document.getElementById("Find")
 if (findobj) {
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
   var obj=document.getElementById("wardrowid");
   if (obj) var xwardrowid=obj.value;
   var obj=document.getElementById("StartTime");
   var xStartTime=""
   var xEndTime=""
   if (obj) var xStartTime=obj.value;
   var obj=document.getElementById("EndTime");
   if (obj) var xEndTime=obj.value;
    
   var pri=""
   var obj=document.getElementById("pri");
   if (obj) var pri=obj.value;
  
   var obj=document.getElementById("locgrpid");
   if (obj) var xlocgrpid=obj.value;
   var obj=document.getElementById("LocGrp");
   if (obj.value==""){xlocgrpid=""}
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phaward1&DispLoc="+xDispLoc+"&displocrowid="+xdisplocrowid+"&StartDate="+xStartDate+"&EndDate="+xEndDate+"&timerflag="+xtimerflag+"&bodyloaded="+xbodyloaded+"&limitflag="+xlimit+"&wardrowid="+xwardrowid+"&StartTime="+xStartTime+"&EndTime="+xEndTime+"&pri="+pri+"&locgrpid="+xlocgrpid;
   parent.frames['dhcpha.phaward1'].location.href=lnk;
   
 }
 
 
 
}
function CheckConPriorRefresh()
{
 var obj=document.getElementById("displocrowid")
 if (obj)
 {if (obj.value=="") 
 {alert(t['DISPLOC_NEEDED'])
   return false  }
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
{Stop(); }
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

//function getDefDateScope()
//{
//      var obj=document.getElementById("StartDate");
//      if (obj) obj.value=today()
//      var obj=document.getElementById("EndDate");
//      if (obj) obj.value=today()
//}

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
   
 //var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phaward1&DispLoc="+xDispLoc+"&displocrowid="+xdisplocrowid+"&StartDate="+xStartDate+"&EndDate="+xEndDate+"&timerflag="+xtimerflag+"&bodyloaded="+xbodyloaded+"&limitflag="+xlimit;
 //document.location.href=lnk ;
 
   RefreshWin(1)
  
}

function setBodyLoaded()
{
 var obj=document.getElementById("bodyloaded") ;
 if (obj) obj.value="1"
 
}

//function GetDefLoc()
//{      
//      //alert(BodyLoaded);
//      var userid=session['LOGON.USERID'] ;
 //var obj=document.getElementById("mGetDefaultLoc") ;
 //if (obj) {var encmeth=obj.value;} else {var encmeth='';}
 //var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
//}

function LimitCatsClick()
{ 
 var obj2=document.getElementById("LimitCats");
 
 var newstr=""
 
   for (var j=0;j<=obj2.options.length-1;j++)
   { 
    
     if (obj2.options[j].selected==true)
     
    {
      if(newstr==""){newstr=obj2.options[j].value;}
      else {newstr=newstr+"^"+obj2.options[j].value;
      //alert(newstr)
      }
      
    } 
    
   }
     
   
 SetLimitCats(newstr);
}

function SetLimitCats(newLimitCats)
{   
//alert("newLimitCats:"+newLimitCats)   
 var obj=document.getElementById("mSetLimitCats") ;
 if (obj) {var encmeth=obj.value;} else {var encmeth='';}
 var ss=cspRunServerMethod(encmeth,'LimitCats',newLimitCats) ;
  var docu=parent.frames['dhcpha.phadisp'].document
 var obj=docu.getElementById("DispCat")

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
 //alert(loc)
 if (obj)
 {if (loc.length>0)   obj.value=loc[1] ;
  else    obj.value="" ;  
 }
 if (obj.value!="") { setDefaultValByLoc()}
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
//      alert(wardrowid)
 
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
 var catval      ;
 for (i=0;i<10;i++)
 {
 
  var obj=document.getElementById("TCat"+i+"z"+row)
  if (obj) catval=obj.innerText ;
  alert("catval:"+catval)
  var obj2=pardocu.getElementById("cat"+i)
  alert(obj2)

  if (catval=="Yes") {obj2.checked=true;   }
  else     {obj2.checked=false;}
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
     var disptypelocalflag=ss[23];
     if (disptypelocalflag!="Y"){
	 	disptypelocalflag="";
	 }
     var startdate=CalcuDate(sd)
     var enddate=CalcuDate(ed)
     var obj=document.getElementById("StartDate");
     if (obj) obj.value=startdate;
     var obj=document.getElementById("EndDate");
     if (obj) obj.value=enddate;
     var obj=document.getElementById("Local");
     if (obj){
	     obj.checked=disptypelocalflag;
	     GetInitWard();
     }
     //zhouyg 20141222
     var objpara=document.getElementById("ParaStr");
     if (objpara)
     {
	     objpara.value=sets;
     }
   }
   //PopulateCats();
 }
}
function CalcuDate(ss)
{var obj=document.getElementById("mGetDate");
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
   //window.document.all('LimitCats').style.display="inline"
    window.document.all('LimitCats').style.display="inline"
   }
 else
 {  window.document.all('LimitCats').style.display="none"
 if(objlimit) objlimit.value=0;
  }     
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
 var obj=document.getElementById("displocrowid")
 if (obj.value=="")return ;
 var locrowid=obj.value;
 var result=cspRunServerMethod(exe,locrowid)
 var ss=result.split("!")
 var cnt=ss.length
 
 var objcats=document.getElementById("LimitCats");
 var i;
 for (i=0;i<=cnt-1;i++)
 {
	  var cat=ss[i].split("^")
	  var catcode=cat[0];
	  var catdesc=cat[1] ;
	 // var ret=GetInitLimitCats(catcode) //取本地设置
	 // if (ret==0){continue;}
	  if (objcats) { objcats.options[objcats.options.length]=new Option (catdesc,catcode) ; }
 }
}
 
function popWard()     
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
		}
} 
function wardCheck()
{
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("wardrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

}
function WardLookUpSelect(str)
{
	var ward=str.split("^");
	var obj=document.getElementById("wardrowid");
	if (obj)
	{	if (ward.length>0)   
			{obj.value=ward[1];}

	 	else { obj.value=""}   
	}	
}
function LocGrpLookUpSelect(str)
{
	var LocGrp=str.split("^");
	var obj=document.getElementById("locgrpid");
	if (obj)
	{	if (LocGrp.length>0)   
			{obj.value=LocGrp[1];}

	 	else { obj.value=""}   
	}	
}
function GetInitLimitCats(code)
{
	//return -1
	
	var arr=GetHeader("C:\\WINDOWS\\DHCSTPHASETUP.txt").split("\r\n");
	
	for(var i=1;i<arr.length-1;i++)
	{
		var tmpcode=arr[i]
		if (tmpcode.indexOf(code)!=-1)
		{
			return 1
		}
	  //alert("第"+(i+1)+"行数据为:"+arr[i]);
     }
     return 0
} 


//Description:取客户端功能设置
//Creator:LiangQiang 
function GetInitWard(){
	var obj=document.getElementById("Local");
	if (obj){
		var tmppri="";
		if (!(obj.checked)){
			 var obj=document.getElementById("pri");
             if (obj) obj.value="";
             return;
		}
		
		var mac=""
		var objmac=document.getElementById("MACAddr");
              if (objmac) {var mac=objmac.value;}
        //if (mac=="") return;
        var disploc=""
        var objdisploc=document.getElementById("displocrowid");
        if (objdisploc) {var disploc=objdisploc.value;}
        var userid=session['LOGON.USERID'];
        
        var obj=document.getElementById("mGetConfig");
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var retval=cspRunServerMethod(encmeth,disploc,mac,userid);
		var obj=document.getElementById("pri");
    	if (obj) obj.value=retval;
	}
    
}
document.body.onload=BodyLoadHandler;
document.body.onbeforeunload=BodyBeforeUnLoadHandler;

var prnpath;
var hospname;

function BodyLoadHandler()
{	
		var obj;
	
	 obj=document.getElementById("Find");
	 if (obj) obj.onclick=FindClick;

	 obj=document.getElementById("Exit");
	 if (obj) obj.onclick=ExitClick;
	 
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
				
		SetAuthority();   
		
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

function DispLocLookUpSelect(str)
{
	var ss=str.split("^") ;
  if ( ss.length>0) 
  { 
   var obj=document.getElementById("displocid") ;
   if (obj) obj.value=ss[1] ; // rowid of the disp loc
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

function ExitClick()
{history.back();}

function GetLocType(locid)
{
		if(locid=="") return;
		
		var obj=document.getElementById("mGetLocType");
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}	
 
		var ret=cspRunServerMethod(encmeth,'','',locid) ;

		return ret
}

function setBodyLoaded()
{
	var obj=document.getElementById("bodyloaded") ;
	if (obj) obj.value=1;
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
					
					
		}
			
}

document.body.onload=BodyLoadHandler;
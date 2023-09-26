var currow;
var rowcount
var firstbody;

function BodyLoadHandler()
{  

   //setdefaltdate();
   	var obj;
    //alert("dd")
    websys_setTitleBar(t["TITLE"]);
    obj=document.getElementById("RegNO");
	if (obj)
	{ obj.onblur=RegNoBlur; 
	  obj.onkeydown=ValidateRegNo ;
	}
    obj=document.getElementById("exit") ;
	if (obj) obj.onclick=EXITClick;
	obj=document.getElementById("find") ;
	if (obj) obj.onclick=FINDClick;
	obj=document.getElementById("Clear") ;
	if (obj) obj.onclick=ClearClick;
	
	var objPoison=document.getElementById("Poison");
	if (objPoison) 
	{	
		objPoison.onkeydown=popPoison;
	 	objPoison.onblur=PoisonCheck;
	} 
	
	var objDesc=document.getElementById("Desc") ;
	if (objDesc) 
	{	objDesc.onkeydown=popDesc;
		objDesc.onblur=DescCheck;
	} 
	
	obj=document.getElementById("DispLoc") ;//2005-06-06
	if (obj) 
	{	obj.onkeydown=popDispLoc;
		obj.onblur=DispLocCheck;
	} 
	
	obj=document.getElementById("ward") ;//2005-06-06
	if (obj) 
	{	obj.onkeydown=popward;
		
	} 
			
	var LogWard=getLogonWard();
	if (LogWard!="")
	{
		var obj=document.getElementById("ward");
		if (obj) 
		{
			obj.value=LogWard;
			if (obj) obj.readOnly=true;
		}
	}
	setCatList()
    setBodyLoaded();
}

function popDispLoc()
{ // //2005-06-06
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}//2005-06-06
}

function DispLocCheck()
{
	// 2007-08-3,zdm
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("locid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}

function popward()
{ // //2005-06-06
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ward_lookuphandler();
		}//2005-06-06
}

function popDesc()
{ // //2005-06-06
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Desc_lookuphandler();
		}//2005-06-06
}

function DescCheck()
{
	// 2007-08-4,zdm
	var obj=document.getElementById("Desc");
	var obj2=document.getElementById("INCI");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}

function popPoison()
{ 
	//2007-08-04,zdm
	if (window.event.keyCode==13) 
	{ 
		window.event.keyCode=117;
	  	Poison_lookuphandler();
	}
}

function PoisonCheck()
{
	// 2007-08-4,zdm
	var obj=document.getElementById("Poison");
	var obj2=document.getElementById("poisonrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}

function setCatList()
{
	
	var obj=document.getElementById("DispCatList");
	if (obj)
	{
	  //according to definition,display the dispensing category and description
		var obj=document.getElementById("mGetDrugType") ;
		if (obj) {var encmeth=obj.value}
		else {var encmeth=''};
		
		var result=cspRunServerMethod(encmeth)  ;
		var drugGrps=result.split("!")
		var cnt=drugGrps.length
		var objDispCat=document.getElementById("DispCatList") 
		objDispCat.options[0]=new Option ("","") ;
		for (i=0;i<cnt;i++) {
			
			var drugGrpCode=drugGrps[i].split("^");
			var code=drugGrpCode[0];
			var desc=drugGrpCode[1];
			objDispCat.options[objDispCat.options.length]=new Option (desc,code) ; 
		}
	}
}
function RegNoBlur()
{
	//when RegNo lost focus then this event fires .
	var obj;
	obj=document.getElementById("RegNO") ;
	if (obj) {var regno=obj.value ;}
	if (regno=="")
	{ 
		
		obj=document.getElementById("Name");
	    if (obj){
		    obj.value="";
	    }
		return ;
		}
	else
		{
		obj.value=getRegNo(regno)
		regno=obj.value ; 
	}
	//set patient info
    var getpa=document.getElementById('mGetPa');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPa','',regno)=='0') {}  
    else
	  {	
	      
	      
	    obj=document.getElementById("Name");
	    if (obj){
		    obj.value="";
	    }
	    
	    obj=document.getElementById("RegNo");
	    if (obj){
		    obj.value="";
	    }
	    
	 

	}	
 }	
function SetPa(value)
{
  //set patient info of compoment
	var painfo=value.split("^")	;
	var obj;
	obj=document.getElementById("Name");
	if (obj) obj.value=painfo[0];
}
function ValidateRegNo()
{
	if (window.event.keyCode==13) 
	{
		RegNoBlur(); }
}
function getRegNo(regno)
{
	var len=regno.length;
	var reglen=tkMakeServerCall("web.DHCOutPhAdd","GetPminoLen")
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{
		zero=zero+"0" ;
	}
	return zero+regno ;
	}	

function formatDate(dateobj)
{
	var sep="/";
	var day=dateobj.getDate();
	var mon=dateobj.getMonth()+1;
	if (mon<10) mon="0"+mon ;
	var year=dateobj.getFullYear();
	return day+sep+mon+sep+year

}
function ClearClick()
{
	var obj=document.getElementById("INCI")
	if (obj) obj.value="";
	var obj=document.getElementById("Desc")
	if (obj) obj.value="";
	//var obj=document.getElementById("DispLoc")
	//if (obj) obj.value="";
	//var obj=document.getElementById("locid")
	//if (obj) obj.value="";
	var obj=document.getElementById("RegNO")
	if (obj) obj.value="";
	var obj=document.getElementById("Name")
	if (obj) obj.value="";
	var obj=document.getElementById("Poison")
	if (obj) obj.value="";
	var obj=document.getElementById("poisonrowid")
	if (obj) obj.value="";
	var obj=document.getElementById("timef")
	if (obj) obj.value="";
	var obj=document.getElementById("timet")
	if (obj) obj.value="";
	var obj=document.getElementById("ward")
	if (obj) obj.value="";
	var objtbl=document.getElementById("t"+"dhcpha_wardquery")
	if (objtbl) DelAllRows(objtbl);
     location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.wardquery"	
}

function today()
{
	var xx=new Date();
	
	return formatDate(xx)
}


function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}	
function CheckQueryCondition()
{ 
	var obj1=document.getElementById("datef")
	if (obj1){
	  if (obj1.value=="")
	      {alert(t["NULL_DATE"]) ;
	     document.getElementById("datef").focus()
	  	return false;  } 
	  	}
	  	
	var obj1=document.getElementById("datet")
	if (obj1){
	  if (obj1.value=="")
	      {alert(t["NULL_DATE"]) ;
	     document.getElementById("datet").focus()
	  	return false;  } 
	  	}	
	  	
  	var obj2=document.getElementById("ward")
	if (obj2){
		 if (obj2.value==""){alert(t["NULL_WARD"]) ;
		 	document.getElementById("ward").focus()
		 	return  false;  } }


	//set cat
	var obj1=document.getElementById("DistCatCode")
	if (obj1)
		{
			var obj2=document.getElementById("DispCatList") ;
			obj1.value=obj2.value;
	}
}


function EXITClick()
{ 	
	history.back();
}
function countrow(js)
{ 	
   var eSrc=window.event.srcElement;
   Objtbl=document.getElementById(js);
   Rows=Objtbl.rows.length-1; 
   return Rows
}	


function FINDClick()
{ 	
   if (CheckQueryCondition()==false) return
   
	find_click();

}	
/*
function SelectRowHandler()	
{   
   
	var eSrc=window.event.srcElement;
	//Objtbl=document.getElementById('tjmpy_yplxsz'); //lq ×¢ÊÍ 20071011
	
	Objtbl=document.getElementById('tdhcpha_wardquery');  //lq add 20071011
	Rows=Objtbl.rows.length;
    rowcount=Rows
	var lastrowindex=Rows - 1;
	var RowObj=getRow(eSrc);
	var selectrow=RowObj.rowIndex;
	if (lastrowindex==selectrow){SelectedRow="-1";;return;}
	if (selectrow!=SelectedRow) {
	
	SelectedRow = selectrow;
	}
	else
	{
		SelectedRow="-1";
	}
    currow=SelectedRow;
}
*/
function getDefaultLoc()
{
	var obj=document.getElementById("locid");
	if (obj) var loc=obj.value;
	
	var xx=document.getElementById("mGetDefaultLoc");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var locdesc=cspRunServerMethod(encmeth,loc) ;
	
	return locdesc
	}
function AliasLookupSelect(str)
{	var inci=str.split("^");
	var obj=document.getElementById("INCI");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	 }
}

function PoisonLookUpSelect(str)
{	
	//2007-8-2,zdm
	var strpoison=str.split("^");
	var obj=document.getElementById("poisonrowid");
	if (obj)
	{if (strpoison.length>0)   obj.value=strpoison[1] ;
		else  obj.value="" ;  
	}
}
	
function getLogonWard()
{
	var obj=document.getElementById("locid")
	if (obj) var logonlocid=obj.value ;
	
	var xx=document.getElementById("mCheckLogonLoc");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var locdesc=cspRunServerMethod(encmeth,logonlocid) ;
	return locdesc
}
document.body.onload=BodyLoadHandler;

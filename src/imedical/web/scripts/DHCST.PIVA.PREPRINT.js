/// DHCST.PIVA.PREPRINT
var leftFrame;
var rightFrame;
var Currbat;
function BodyLoadHandler()
{
  	setDefaultValByLoc();
  	SetObjHandler();
  	GetLimitType();
  	/*if(parent.name=='TRAK_main') {
		leftFrame=parent.frames['work_left'];
		rightFrame=parent.frames['work_right'];
	} else {
		leftFrame=parent.frames['TRAK_main'].frames['work_left'];
		rightFrame=parent.frames['TRAK_main'].frames['work_right'];
	}*/
}
function setDefaultValByLoc()
{
	var locid = "";
	var objlocid = document.getElementById("tPLocID");
	if (objlocid) locid = objlocid.value;
	if (locid == "") return;
	var strsets = cspRunGetLocSet(locid);
	if (strsets != "")
	{
		var arrset = strsets.split("^")
		var sdate = arrset[6];
		var edate = arrset[7];
		var stdate = GetCalDate("mGetDate",sdate);
		var eddate = GetCalDate("mGetDate",edate);
		var objsd = document.getElementById("tStartDate");
		if (objsd){
			if (objsd.value=="") objsd.value = stdate;
		}
		var objed = document.getElementById("tEndDate");
		if (objed){
			if (objed.value=="") objed.value = eddate;
		}
	}
}
function SetObjHandler()
{
	var obj = document.getElementById("tBatNo");
	if (obj) {
		//obj.onblur = BatNoLostFocus;
		obj.onfocus = BatNoOnFocus;
		obj.onkeydown = BatNoKeyDown;
	}
	var obj = document.getElementById("tOecpr");
	if (obj) {
		obj.onblur = OecprLostFocus;
		obj.onfocus = OecprOnFocus;
		obj.onkeydown = OecprKeyDown;
	}
	var obj=document.getElementById("tPLoc");
	if (obj){
		obj.onkeydown=PLocKeyDown;
		obj.onfocus=PLocOnFocus;
	 	obj.onblur=PLocLostFocus;
	}
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PREPRINT");
	if (objtbl){
		objtbl.ondblclick=tbDbClick;
		///objtbl.onmouseup=tbMouseUp;
	}
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	
    var obj = document.getElementById("tLocGrp");
	if (obj) {
		 obj.onkeydown=popLocGrp;
	 	 obj.onblur=LocGrpCheck;
	}
    var obj = document.getElementById("tOecType");
	if (obj){
		setOecType();
		obj.onchange=LimitTypeClick;
	}
	

	
}
function cspRunGetLocSet(locid)
{
	var obj=document.getElementById("mGetLocSet");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	return result;
}



/// tLocGrp Handler
function LocGrpCheck()
{
	var obj=document.getElementById("tLocGrp");
	var obj2=document.getElementById("tWardID");
	if (obj) 
	{
		if (obj.value=="")
		{
			obj2.value="";
			//EnableFieldByID("mGetComponentID","tWard");
	    } 		
	}
}
function popLocGrp()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tLocGrp_lookuphandler();
	}
}


function LocGrpLookupSelect(str)
{	
	var loc=str.split("^");
	var obj=document.getElementById("tWardID");
	if (obj)
	{
		if (loc.length>0)   
		{
			obj.value=loc[1]+"G"
			//DisableFieldByID("mGetComponentID","tWard"); 
		}
		else  
		{
			obj.value=""
		} 
	}

}













/// tPLoc Handler
function PLocKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tPLoc_lookuphandler();
	}
}
function PLocOnFocus()
{
	var obj=document.getElementById("tPLoc");
	if (obj) obj.select();
}
function PLocLostFocus()
{
	var obj=document.getElementById("tPLoc");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tPLocID");
			if (obj) obj.value=""
		}
	}
}
function DispLocLookUpSelect(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("tPLocID");
	if (obj){
		if (loc.length>0) obj.value=loc[1];
		else obj.value="";
	}
}
/// tBatNo
function BatNoOnFocus()
{
	var obj=document.getElementById("tBatNo");
	if (obj) obj.select();
}
function BatNoKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tBatNo_lookuphandler();
	}
}
function BatNoLostFocus()
{

}
/// tOecpr
function OecprLostFocus()
{
	var obj = document.getElementById("tOecpr");
	if (obj.value=="") {
		var objid=document.getElementById("tOecprID");
		objid.value="";
	}
}
function OecprOnFocus()
{
	var obj = document.getElementById("tOecpr");
	obj.select();
}
function OecprKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		tOecpr_lookuphandler();
	}
}
function OecprLookupSelect(str)
{
	var cpr=str.split("^");
	var obj=document.getElementById("tOecprID");
	if (obj){
		if (cpr.length>0)   obj.value=cpr[2] ;
		else  obj.value="" ;
	}

}
///
function FindClick()
{
	if (ChkFindCondition()==false) return;
  	bFind_click();
}
 /// 检查查询条件
function ChkFindCondition()
{
	var obj;
	obj=document.getElementById("tPLocID") ;
	if (obj){
		if (obj.value==""){
		    alert(t["请选择科室"]);
	   	    return false;
	   	}
	}
	var obj1=document.getElementById("tStartDate") ;
	if (obj1.value=="" ){
		alert("请选择开始时间");
	  	return false;
	}
	var obj2=document.getElementById("tEndDate") ;
	if (obj2.value=="" ){
		alert("请选择结束时间") ;
	  	return false;
	}
    if (DateStringCompare(obj1.value,obj2.value )==1){
	    alert(t["日期范围不对"]);
     	return  false ;
	}
	return true ;
}
/// 双击
function tbDbClick()
{
	var cnt=0;
	var pogflag=0;
	var objtbl=document.getElementById("t"+"DHCST_PIVA_PREPRINT");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var wardid=document.getElementById("tbWardIDz"+row).value;
 	var ward=document.getElementById("tbWardz"+row).innerText;;
	var batno=document.getElementById("tBatNo").value; //document.getElementById("tbBatNoz"+row).innerText;
	var oecprid=document.getElementById("tOecprID").value;
	var oecpr=document.getElementById("tOecpr").value;
	var plocid=document.getElementById("tPLocID").value;
	var ploc=document.getElementById("tPLoc").value;
	var sd=document.getElementById("tStartDate").value;
	var ed=document.getElementById("tEndDate").value;
	var oectype=document.getElementById("tOecType").value;
	
	var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.PRINTLABEL&tWardID="+wardid+"&tWard="+ward+"&tBatNo="+batno+"&tOecprID="+oecprid+"&tOecpr="+oecpr+"&tPLocID="+plocid+"&tPLoc="+ploc+"&tStartDate="+sd+"&tEndDate="+ed+"&tpre=1"+"&tOecType="+oectype;
	parent.frames['DHCST.PIVA.PRINTLABEL'].location.href=link;
	//rightFrame.location.href=link;
	//window.location.href=link;
	//window.open(link,"_TARGET","height=170,width=450,menubar=no,status=yes,toolbar=no")
}


function setOecType()
{
	var obj=document.getElementById("tOecType");
	if (obj) PInitOecType(obj);
}
///初始化配液分类
function PInitOecType(listobj)
{
	var obj=document.getElementById("mGetPivaType");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth);
	if (result!="")
	{
		var tmparr=result.split("!!")
		var cnt=tmparr.length
		for (i=0;i<=cnt-1;i++)
		{ 
			var typestr=tmparr[i].split("^")
			var type=typestr[0];
			var typeindex=typestr[1];
			///初始化配液分类
			if (listobj)
			{
				
				//listobj.size=1; 
			 	//listobj.multiple=false;

			 	listobj.options[i+1]=new Option(type,typeindex);
		    }
			
		}
		
	}
	

}

function LimitTypeClick()
{ 
       var obj2=document.getElementById("tOecType");
       var newstr=""
	   for (var j=0;j<=obj2.options.length-1;j++)
	   { 
	    
		     if (obj2.options[j].selected==true)
		     
		      {
			      if(newstr==""){newstr=obj2.options[j].value;}
			      else 
			      {
				      newstr=newstr+"^"+obj2.options[j].value;
		          }
	      
	          } 
    
        }
		var objlist=document.getElementById("TypeList");	 
		if (objlist) objlist.value=newstr;

}

function GetLimitType()
{		     
    var objType=document.getElementById("tOecType")
    if (objType)
    {
	    var list=""
		var objlist=document.getElementById("TypeList")
		if (objlist) var list=objlist.value;
		if (list=="") return;
		var arr=list.split("^");
		
		for (var j=0;j<=arr.length-1;j++)
	  	  { 
		  	  for(var i=0; i<=objType.options.length-1;i++)
		  	  {		
		  	  		
			  	  if (objType.options[i].value==arr[j])
					{
					  objType.options[i].selected=true;
					  				  				  
					} 
		  	  }
		  	  
	  	  }
    }
	
}




document.body.onload=BodyLoadHandler;
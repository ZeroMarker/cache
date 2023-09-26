/// DHCST.PIVA.RECHECKWARD
var RowsCount;
function BodyLoadHandler()
{
  	InitForm();
  	SetObjHandler();
}

function InitForm()
{
	setDefaultValByLoc();
	GetRecord();
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
		var objsdo = document.getElementById("tOrdStDate");
		if (objsdo){
			if (objsdo.value=="") objsdo.value = stdate;
		}
		var objedo = document.getElementById("tOrdEndDate");
		if (objedo){
			if (objedo.value=="") objedo.value = eddate;
		}
	}
}

function GetRecord()
{
	if (!RowsCount) RowsCount="合计"
	else RowsCount="记录数:"+RowsCount
	var obj=document.getElementById("clCnt");
	if (obj){
		obj.innerText=RowsCount
	}
}

function SetObjHandler()
{
	var obj = document.getElementById("tBatNo");
	if (obj) {
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
	var obj=document.getElementById("tWard");
	if (obj){
		obj.onblur=WardLostFocus;
		obj.onfocus=WardOnFocus;
		obj.onkeydown=WardKeyDown;
	}
	
    var obj = document.getElementById("tLocGrp");
	if (obj) {
		 obj.onkeydown=popLocGrp;
	 	 obj.onblur=LocGrpCheck;
	}
	
	var obj = document.getElementById("tOecType");
	if (obj){
		setOecType();
		obj.onchange=OecTypeSelect;
	}
	var obj = document.getElementById("bFind");
	if (obj) obj.onclick = FindClick;
	
	var obj = document.getElementById("bClear");
	if (obj) obj.onclick = Clear;
	
	var objtbl=document.getElementById("t"+"DHCST_PIVA_RECHECKWARD");
	if (objtbl) objtbl.ondblclick = tbDbClick;

	
}
function cspRunGetLocSet(locid)
{
	var obj=document.getElementById("mGetLocSet");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,locid);
	return result;
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
/// tWard Handler
function WardOnFocus()
{
	var obj=document.getElementById("tWard");
	if (obj) obj.select();
}
function WardLostFocus()
{
	var obj=document.getElementById("tWard");
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("tWardID");
			if (obj) obj.value=""
		}
	}
}
function WardLookUpSelect(str)
{
	var ward=str.split("^");
	var obj=document.getElementById("tWardID");
	if (obj){
		if (ward.length>0)   obj.value=ward[1];
		else  obj.value="" ;
	 }
}
function WardKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
	  	tWard_lookuphandler();
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

///清除
function Clear()
{
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.RECHECKWARD";
   location.href=lnk;

}

function FindClick()
{
	if (ChkFindCondition()==false) return;
	ReFind();
}
function ReFind()
{

  	bFind_click();
}

 /// 检查查询条件
function ChkFindCondition()
{
	var obj;
	obj=document.getElementById("tPLocID") ;
	if (obj){
		if (obj.value==""){
		    alert(t["NO_DISPLOC"]);
	   	    return false;
	   	}
	}
	var obj1=document.getElementById("tStartDate") ;
	if (obj1.value=="" ){
		alert(t['NO_STARTDATE']);
	  	return false;
	}
	var obj2=document.getElementById("tEndDate") ;
	if (obj2.value=="" ){
		alert(t['NO_ENDDATE']) ;
	  	return false;
	}
    if (DateStringCompare(obj1.value,obj2.value )==1){
	    alert(t['INVALID_DATESCOPE']);
     	return  false ;
	}

	return true ;
}


/// 双击选择或者清除行
function tbDbClick()
{
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_RECHECKWARD");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var ward="";
 	var objWardDr=document.getElementById("tbWardDrz"+row);
 	if (objWardDr) { var ward=objWardDr.value ;}
 	
 	var ploc="";
 	var objploc=document.getElementById("tPLocID");
 	if (objploc) {ploc=objploc.value; }
 	var sdate="";
 	var objsdate=document.getElementById("tStartDate");
 	if (objsdate) {sdate=objsdate.value; }
 	var edate="";
 	var objedate=document.getElementById("tEndDate");
 	if (objedate) {edate=objedate.value; }
 	var batno="";
 	var objbatno=document.getElementById("tBatNo");
 	if (objbatno) {batno=objbatno.value; }
 	var pr=""
 	var objpr=document.getElementById("tOecprID");
 	if (objpr) {pr=objpr.value;}
 	var osdate=""
 	var objosdate=document.getElementById("tOrdStDate");
 	if (objosdate) {osdate=objosdate.value;}
 	var oedate=""
 	var objoedate=document.getElementById("tOrdEndDate");
 	if (objoedate) {oedate=objoedate.value;}
 	var type=""
 	var objtype=document.getElementById("tOecType");
 	if (objtype) {type=objtype.value;}

 	var docu=parent.frames['DHCST.PIVA.RECHECK'].document
    if (docu){

			 	var objploc=docu.getElementById("tPLocID");
			 	if (objploc) {objploc.value=ploc; }
			 	var objward=docu.getElementById("tWardID");
			 	if (objward) objward.value=ward;
			 	var objsdate=docu.getElementById("tStartDate");
			 	if (objsdate) {objsdate.value=sdate; }
			 	var objedate=docu.getElementById("tEndDate");
			 	if (objedate) {objedate.value=edate; }
			 	var objbatno=docu.getElementById("tBatNo");
			 	if (objbatno) {objbatno.value=batno; }
			 	var objpr=docu.getElementById("tOecprID");
			 	if (objpr) {objpr.value=pr;}
			 	var objosdate=docu.getElementById("tOrdStDate");
			 	if (objosdate) {objosdate.value=osdate;}
			 	var objoedate=docu.getElementById("tOrdEndDate");
			 	if (objoedate) {objoedate.value=oedate;}
			 	var objtype=docu.getElementById("tOecType");
			 	if (objtype) {objtype.value=type;}
			 	
			 	var obj=docu.getElementById("bFind")
	            if (obj) {obj.click()  }
	  
              }

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
			EnableFieldByID("mGetComponentID","tWard");
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
			DisableFieldByID("mGetComponentID","tWard"); 
		}
		else  
		{
			obj.value=""
		} 
	}

}

///配液分类索引
function setOecType()
{
	var obj=document.getElementById("tOecType");
	if (obj) PInitOecType(obj);
	var objindex=document.getElementById("OecTypeIndex");
	if (objindex) obj.selectedIndex=objindex.value;
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
				listobj.size=1; 
			 	listobj.multiple=false;

			 	listobj.options[i+1]=new Option(type,typeindex);
		    }
			
		}
		
	}
	

}
/// tOecType
function OecTypeSelect()
{
	var obj=document.getElementById("OecTypeIndex");
	if(obj){
		var objpass=document.getElementById("tOecType");
		obj.value=objpass.selectedIndex;
	}
}



document.body.onload=BodyLoadHandler;
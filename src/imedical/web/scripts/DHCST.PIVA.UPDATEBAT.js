//DHCST.PIVA.UPDATEBAT
var Currbat;
function BodyLoadHandler()
{
	var obj;
	
	obj=document.getElementById("bClear");
	if (obj)  obj.onclick=ClearClick;
	
	obj=document.getElementById("Adm") ;
	if (obj) obj.onchange=AdmClick; 
	
	obj=document.getElementById("DispLoc"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popDispLoc;
		obj.onblur=DispLocCheck;
	} //2005-05-26
	
	var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_UPDATEBAT");
    if (objtbl) cnt=getRowcount(objtbl);
   
	if (cnt>0) SetTblRowsColorNew(objtbl,2);
	
	var obj=document.getElementById("tWard");
	if (obj){
		obj.onkeydown=WardKeyDown;
		obj.onblur=WardLostFocus;
		obj.onfocus=WardOnFocus;
	}
	
	var obj = document.getElementById("tBatNo");
	if (obj) {
		//obj.onblur = BatNoLostFocus;
		obj.onfocus = BatNoOnFocus;
		obj.onkeydown = BatNoKeyDown;
	}
	var objtbl=document.getElementById("t"+"DHCST_PIVA_UPDATEBAT");
    if (objtbl){
    	objtbl.onkeydown=UpdBatno;
    	objtbl.onmousedown=GetBatno;
    }
    
	 var obj=document.getElementById("RegNo"); //2005-05-26
 	if (obj) 
 	{
 		if (obj.value!="")
		{
				 
		}
		else
		{
			obj.value=GetRegNoByEpisodeID()
		}
		RegNoBlur();
		obj.onkeydown=popRegNo;
		//obj.onblur=RegNoCheck;
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

function WardKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		tWard_lookuphandler();
	}
}
function WardLostFocus()
{
	var obj=document.getElementById("tWard");
	if (obj){
		if (obj.value == ""){
			var obj=document.getElementById("tWardID");
			if (obj) obj.value = ""
		}
	}
}
function WardOnFocus()
{
	var obj=document.getElementById("tWard");
	if (obj) obj.select();
}
function AdmClick()
{
	var obj=document.getElementById("Adm");
	if (obj.selectedIndex>=0){
		var xx=obj.value;
		var obj1=document.getElementById("tAdmID");
		if (xx!="") {
			obj1.value=xx;
	 	} 
	 }
}
function DispLocCheck()
{
	// 2006-05-26
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}// 2006-05-26

function popDispLoc()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}
}//2006-05-26
function popRegNo()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   var obj=document.getElementById("RegNo");
	   RegNo_lookuphandler();
		}
}
function RegNoLookUpSelect(str)
{	
	 var ss=str.split("^") ;	
	 if ( ss.length>0) 
	 { 
	    var obj=document.getElementById("RegNo") ;
	    if (obj) obj.value=ss[0] ; 
	    RegNoBlur(ss[0])
	 }
}
function SetAdm(value)
{ 
	var ss=value.split("^") ;
	if (ss.length<1) return ;
	var obj=document.getElementById("Adm") ;
	if (obj)  obj.options.length=0 ;

	var i;
	for (i=0;i<ss.length;i++) 
	{if (obj)
		{var admno=ss[i].split(" .. ")
			obj.options[i]=new Option (ss[i],admno[0]) ;}
	}
	if (obj.length>0) obj.options.selectedIndex=0 ;
}
function GetRegNoByEpisodeID()
{
	var objadm=document.getElementById("tAdmID")
	var adm=objadm.value
	var getpa=document.getElementById('mGetRegNoByEpisodeID');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	var regno=cspRunServerMethod(encmeth,adm)
	return regno
	
}
function ClearField(ss)
{	var obj; 
	obj = document.getElementById(ss) ;
	if (obj) obj.value="" ;
}
function RegNoBlur()
{
	//when RegNo lost focus then this event fires .
	var obj=document.getElementById("RegNo") ;
	var regno,displocrowid ;
	if (obj)
	{ 
	 regno=obj.value ;
	 if (regno=="")
	 {	
	 	ClearField("Name") ;
		ClearField("Sex") ;
		ClearField("Age") ;
		//ClearField("Adm") ;
		
	 	return ;}
	 else
	 {obj.value=getRegNo(regno) ;
	  regno=obj.value ; }
	}
	/*
	//set patient info
    var getpa=document.getElementById('mGetPa');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPa','',regno)=='0') {}  
	*/
	var obj=document.getElementById("Adm")
	if (obj)	obj.options.length=0 ;
	//
    var getadm=document.getElementById('mGetAdm');
	if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetAdm','',regno)=='0') {}  
		
 }	
 function ClearClick()
{
	var obj=document.getElementById("DispLoc")
	if (obj) var disploc=obj.value;
	
	var obj=document.getElementById("displocrowid")
	if (obj) var displocrowid=obj.value;
	
	var obj=document.getElementById("tEndDate")
	if (obj) var tEndDate=obj.value;
	
	var obj=document.getElementById("tStartDate")
	if (obj) var tStartDate=obj.value;

	parent.frames['x'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.UPDATEBAT&DispLoc="+disploc+"&displocrowid="+displocrowid+"&tEndDate="+tEndDate+"&tStartDate="+tStartDate
	
	
}

function UpdBatno(e)
{
  if (window.event.keyCode!=13) {return;}
  
  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")
  
  if (ss.length>0)	  
	   {	
		    if (ss[0]=="tbBatNo")
			 {
					var objtbl=document.getElementById("t"+"DHCST_PIVA_UPDATEBAT");
				    if (objtbl) cnt=getRowcount(objtbl);
					if (cnt<=0) return;
					var row=selectedRow(window);
				 	if (!row) return;
				 	if (row<1) return;
				 	//var moeori=document.getElementById("tbMOeoriz"+row).value;
				 	var moeori=document.getElementById("tbMdodisz"+row).value;
				 	var grp=document.getElementById("tbGrpNoz"+row).value;
				 	if((moeori=="")||(grp=="")) return;
				 	var ploc=document.getElementById("displocrowid").value
					var batno=document.getElementById("tbBatNoz"+row).value;
					//alert(Currbat+"="+batno)
					if(Currbat==batno){alert("批次没有发生变化"); return;}
					var dsp=document.getElementById("tbDSPz"+row).value;
					var PID=document.getElementById("tbPIDz"+row).value;
				 	obj=document.getElementById("mUpdBat");
					if (obj) {var encmeth=obj.value;}  else {var encmeth='';};
					if(encmeth=="") return;
					var ret=cspRunServerMethod(encmeth,moeori,grp,trim(batno),ploc,dsp,PID,1);
					//alert("ret"+ret)
					//恢复修改前的批次,此前不许有弹框
					if (ret<0) {document.getElementById("tbBatNoz"+row).value=Currbat;}
					if (ret==-6) {alert("更新失败,选择主医嘱后再重试...");document.getElementById("tbBatNoz"+row).select();return;}
					if (ret==-7) {alert("更新失败,该袋药水已打签,不允许修改批次");document.getElementById("tbBatNoz"+row).select();return;}
					if (ret==-10) {alert("更新失败,该病人当天"+batno+"批次已有3袋药水");document.getElementById("tbBatNoz"+row).select();return;}
					if (ret!=0) {alert("更新失败,错误代码:"+ret);document.getElementById("tbBatNoz"+row).select();return;}
					//
										
					for (i=row+1;i<=cnt;i++)
					 {
						//var rmoeori=document.getElementById("tbMOeoriz"+i).value;
						var rmoeori=document.getElementById("tbMdodisz"+i).value; 
						var rgrp=document.getElementById("tbGrpNoz"+i).value;
						
						if ((rmoeori==moeori)&&(rgrp==grp))
						{
							var rbatnoobj=document.getElementById("tbBatNoz"+i);
							if (rbatnoobj) rbatnoobj.value=trim(batno);
						}
						else
						{
							if(i<=cnt){document.getElementById("tbBatNoz"+i).select();}
							return;
						}
					 }
					 

			 }
	   }

}

function GetBatno(e)
{

  //if (window.event.keyCode!=13) {return;}
  
  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")

  if (ss.length>0)	  
	   {	
		    if (ss[0]=="tbBatNo")
			 { 

					var objtbl=document.getElementById("t"+"DHCST_PIVA_UPDATEBAT");
				    if (objtbl) cnt=getRowcount(objtbl);
					if (cnt<=0) return;
					var row=selectedRow(window);
				 	if (!row) return;
				 	if (row<1) return;
					var batno=document.getElementById("tbBatNoz"+row).value;

                    Currbat=batno;
                    //alert(Currbat)
			 }
	   }

}

function DispLocLookUpSelect(str){
	var inci=str.split("^");
	var obj=document.getElementById("displocrowid");
	if (obj){
		if (inci.length>0)   obj.value=inci[1] ;
		else  obj.value="" ;
	}
}
function WardLookUpSelect(str){
	var inci=str.split("^");
	var obj=document.getElementById("tWardID");
	if (obj){
		if (inci.length>0)   obj.value=inci[1] ;
		else  obj.value="" ;
	}
}

document.body.onload=BodyLoadHandler;
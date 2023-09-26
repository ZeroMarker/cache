function BodyLoadHandler()
{
	//add by wkz 071213 S
	var userId=session['LOGON.USERID'];
    var GetUserType=document.getElementById("GetUserType").value;
    var UserType=cspRunServerMethod(GetUserType,userId);
	var obj=document.getElementById("NurOrd");
	//if(UserType=="NURSE") obj.checked=true;
	//add by wkz 071213 E
	var obj=document.getElementById("OrdLong");
	if (obj) {obj.onclick=Long_click;}
	var obj=document.getElementById("RegNo");
	if (obj) {obj.onkeydown=RegNo_KeyDown;}
	obj=document.getElementById("OrdTemp");
	if (obj) {obj.onclick=Temp_click;}
	obj=document.getElementById("OEORDCZ");
	if (obj) {obj.onclick=OeordChZh_click;}
	combo("Adm");
	combo("OrdDep");
	obj=document.getElementById("StDate");
	obj.value=DateDemo();
	obj=document.getElementById("EndDate");
	obj.value=DateDemo();
	var Adm=document.getElementById("Adm1").value;
	if (Adm=="") return
	//+wxl090728 登陆用户为医生时 取病人所在病区的WardID
	//if(UserType=="DOCTOR"){					
		var objWardID=document.getElementById("WardID");
		var objGetPatWard=document.getElementById("GetPatWard");
		if (objGetPatWard){
			var retStr=cspRunServerMethod(objGetPatWard.value,Adm);
			var tempStr=retStr.split("^");
			if (tempStr[0]!="") objWardID.value=tempStr[0];
		}	
	//}
	//+wxl090728
	obj=document.getElementById("GetPNameRegNo").value;
    var retval=cspRunServerMethod(obj,Adm);  
	var s=retval.split("^")
	obj=document.getElementById("RegNo");
	if (obj){ 
		obj.value=s[1];
		//basinfo(obj.value);
		basinfo("^"+Adm);
	}
	inputadm("^"+Adm);
	var GetTranLoc=document.getElementById("GetTranLoc").value;
    var retloc=cspRunServerMethod(GetTranLoc,Adm);  
	var str=retloc.split("|");
	//alert(str);
	inputadmLoc(retloc);
    Long_click();
	 //obj.options[i]=new Option(myarray[1],myarray[0]);
}
function DateDemo(){
   var d, s="";           //
   d = new Date();                           // 
   s += d.getDate() + "/";                   //
   s += (d.getMonth() + 1) + "/";            //
   s += d.getYear();                         //
   return(s);                                //
}
function inputadm(admstr)
{
	var AdmStr=admstr.split("^");
	//alert(AdmStr);
	var AdmObj=document.getElementById("Adm");
	if (admstr=="") return;
	//for (var i=0;i<AdmObj.length;i++)
	//{
	//	AdmObj.remove(i);
	//}
	AdmObj.options.length=0;
 	for (var i=1;i<AdmStr.length;i++)
 	{
 		if (AdmStr[i]=="") continue;
 		var sel=new Option(AdmStr[i],AdmStr[i]);
		AdmObj.options[AdmObj.options.length]=sel;
		if (i==1)
		{
		//alert (ret);
		}
	}
	AdmObj.selectedIndex=AdmObj.options.length-1;
}
function inputadmLoc(loc)
{
	var admloc=loc.split("|");
	var OrdDep=document.getElementById("OrdDep");
 	 if (loc=="") return;
 	 
  	  for (var i=0;i<OrdDep.length;i++)
 	  {
 		OrdDep.remove(i);
	  }
	var index;
	index=0
	for (var i=0;i<admloc.length;i++)
 	{
 		if (admloc[i]=="") {}
 		else{
 		var locstr;
 		locstr=admloc[i].split("^");
 		if (locstr[2]=="Y")  index=i;
 		
 		var templocstr=locstr[0]+"|"+locstr[3]
 		//alert(templocstr)
 		var sel=new Option(locstr[3]+"|"+locstr[1]+"|"+locstr[0],locstr[3]);
 		//var sel=new Option(locstr[1]+"|"+templocstr);
		OrdDep.options[OrdDep.options.length]=sel;
		if (i==1)
		{
		}
 		}
	}
	OrdDep.selectedIndex=index;
}

function getadm(GetAdm,RegNo)
{
  	var ret=cspRunServerMethod(GetAdm,RegNo);
  	var AdmObj=document.getElementById("Adm");
    inputadm(ret);
   
 
}
function RegNo_KeyDown()
{
  
   var key=websys_getKey(e);
   var GetAdm=document.getElementById("GetAdm").value;
   var RegNo=document.getElementById("RegNo");
   var AdmObj=document.getElementById("Adm");
   if (key==13)
   {
	 getadm(GetAdm,RegNo.value);

	if (AdmObj.selectedIndex!=-1)
	{
	  var ind=AdmObj.selectedIndex;
	  var seltyp=AdmObj[ind].text;
      basinfo(seltyp);
	}
 
	//RegNo.value=AdmStr[0];
   }    //s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel

 
}
function basinfo(adm)
{     
	var baseinfo=document.getElementById("baseInfo").value;
	var rets=cspRunServerMethod(baseinfo,adm);
	var patinfo=document.getElementById("PatBasinfo");
	var pat=rets.split("^");
	if (pat[11]=="")
	alert(t['alert:noDocAssign'])
	//alert (adm)
	//patinfo.value=pat[12]+":"+pat[4]+" "+pat[3]+" "+pat[6];
	patinfo.value=pat[12]+pat[4]+" "+pat[3]+" "+pat[6];
}
function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
	//obj.options[1].selected=true;
}
function DateDemo(){
   var d, s="";           // 
   d = new Date();                           //
   s += d.getDate() + "/";                   //
   s += (d.getMonth() + 1) + "/";            //
   s += d.getYear();                         //
   return(s);                                //
}
function OeordChZh_click()
{
    var RegNo=document.getElementById("RegNo").value;
    var AdmCom=document.getElementById("Adm");
    var Index=AdmCom.selectedIndex;
    if (Index==-1) return; 
    var Adm=AdmCom.options[Index].text;
    var userid=session['LOGON.USERID'];
    var lnk;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORDCZ&RegNo="+RegNo+"&Adm="+Adm;
	   // alert (lnk);
    parent.frames['RPbottom'].location.href=lnk; 

//	window.open(lnk,"OrdExec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");

}
function hborsch()
{
	 var RegNo=document.getElementById("RegNo").value;
    var AdmCom=document.getElementById("Adm");
    var Index=AdmCom.selectedIndex;
    if (Index==-1) return; 
    var Adm=AdmCom.options[Index].text;
    var userid=session['LOGON.USERID'];
    var	StDate="";
	var EndDate="";
    var lnk;
    var Stopord;
    Stopord=2;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGBCORD&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&ChangeDate="+"1"+"&stop="+Stopord;
    parent.frames['RPbottom'].location.href=lnk; 

}
function CLONGSCH()
{
    var RegNo=document.getElementById("RegNo").value;
    var AdmCom=document.getElementById("Adm");
    var Index=AdmCom.selectedIndex;
    if (Index==-1) return; 
    var Adm=AdmCom.options[Index].text;
    var userid=session['LOGON.USERID'];
    var	StDate=document.getElementById("StDate").value;
	var EndDate=document.getElementById("EndDate").value;
    var Sel=document.getElementById("SelDate");
    var lnk;
    var	 Stopord=""

    if (Sel.checked==true)
    {
	   if ((StDate=="")||(EndDate==""))
	   {
		   alert(t['alert:startEndDateNull']);
		   return;
	   }
    }
    else
    {
	    StDate="";
	    EndDate="";
	}
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORD&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&ChangeDate="+"1"+"&stop="+Stopord;
    alert(lnk);
    parent.frames['RPbottom'].location.href=lnk; 

//	window.open(lnk,"OrdExec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");

}
function Long_click()
{
    var RegNo=document.getElementById("RegNo").value;
    var AdmCom=document.getElementById("Adm");
    var Index=AdmCom.selectedIndex;
    if (Index==-1) return; 
    var Adm=AdmCom.options[Index].text;
    var DepCom=document.getElementById("OrdDep");
    Index=DepCom.selectedIndex;
    if (Index==-1) return; 
    var Dep=DepCom.options[Index].value;
    //alert(Dep);
    var userid=session['LOGON.USERID'];
    var	StDate=document.getElementById("StDate").value;
	var EndDate=document.getElementById("EndDate").value;
    var Sel=document.getElementById("SelDate");
    var AllOrd=document.getElementById("AllOrd");
    var NurOrd=document.getElementById("NurOrd");
    var DocOrd=document.getElementById("DocOrd");
    var lnk;
	var clearaudit=document.getElementById("ClearAudit").value;
    var retval=cspRunServerMethod(clearaudit,Adm);  

	var Stopord=0;
	var NOrd=0;
	var DOrd=0
	if (DocOrd){
		if (DocOrd.checked==true){
			DOrd=1;
			}
		}
    if (NurOrd){
		if (NurOrd.checked==true){
			NOrd=1;
			}
		}
    if (AllOrd){
		if (AllOrd.checked==true){
			Stopord=1
			}
		}
	//+wxl090903 按医嘱开科室或接受科室查询
	var objDocDepId=document.getElementById("DocDepId");
	if (objDocDepId) var DocDepId=objDocDepId.value;
	else var DocDepId="";
	var objDocDep=document.getElementById("DocDep");
	if ((objDocDep)&&(objDocDep.value=="")) DocDepId="";
	var objRecDepId=document.getElementById("RecDepId");
	if (objRecDepId) var RecDepId=objRecDepId.value;
	else var RecDepId="";
	var objRecDep=document.getElementById("RecDep");
	if ((objRecDep)&&(objRecDep.value=="")) RecDepId="";
	var objSelDocDep=document.getElementById("SelDocDep");
	if ((objSelDocDep)&&(objSelDocDep.checked==true)) var SelDocDep="Y";
	else var SelDocDep="N";
	var objSelRecDep=document.getElementById("SelRecDep");
	if ((objSelRecDep)&&(objSelRecDep.checked==true)) var SelRecDep="Y";
	else var SelRecDep="N";
	//+wxl090903
    if (Sel.checked==true)
    {
	   if ((StDate=="")||(EndDate==""))
	   {
		   alert(t['alert:startEndDateNull']);
		   return;   //ssuser
	   }
	   lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORD&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&stop="+Stopord+"&ssuser="+userid+"&Dep="+Dep+"&NurOrd="+NOrd+"&DocOrd="+DOrd+"&SelDocDep="+SelDocDep+"&DocDepId="+DocDepId+"&SelRecDep="+SelRecDep+"&RecDepId="+RecDepId;
    }
    else  lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORD&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+""+"&EndDate="+""+"&stop="+Stopord+"&ssuser="+userid+"&Dep="+Dep+"&NurOrd="+NOrd+"&DocOrd="+DOrd+"&SelDocDep="+SelDocDep+"&DocDepId="+DocDepId+"&SelRecDep="+SelRecDep+"&RecDepId="+RecDepId;
	//alert (lnk);
    parent.frames['RPbottom'].location.href=lnk; 

//	window.open(lnk,"OrdExec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");

}
function CTEMPSCH()
{
    var RegNo=document.getElementById("RegNo").value;
    var AdmCom=document.getElementById("Adm");
    var Index=AdmCom.selectedIndex;
    if (Index==-1) return; 
    var Adm=AdmCom.options[Index].text;
    if ((Adm=="")) {alert(t['alert:EpisodeIDNull']);return false;};
    var userid=session['LOGON.USERID'];
    var	StDate=document.getElementById("StDate").value;
	var EndDate=document.getElementById("EndDate").value;
    var Sel=document.getElementById("SelDate");
    var AllOrd=document.getElementById("AllOrd");
    var lnk;
    var Stopord=0;
    var DOrd=0
	if (DocOrd){
		if (DocOrd.checked==true){
			DOrd=1;
			}
		}
	if (AllOrd){
		if (AllOrd.checked==true){
			Stopord=1
			}
		}

    if (Sel.checked==true)
    {
	   if ((StDate=="")||(EndDate==""))
	   {
		   alert(t['alert:startEndDateNull']);
		   return;
	   }
    }
    else
    {
	    StDate="";
	    EndDate="";
	}


    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCTEMPOERPRINT&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&ChangeDate="+"1"+"&stop="+Stopord;
    parent.frames['RPbottom'].location.href=lnk; 
    
//	window.open(lnk,"OrdExec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");

}
function Temp_click()
{
    var RegNo=document.getElementById("RegNo").value;
    var AdmCom=document.getElementById("Adm");
    var Index=AdmCom.selectedIndex;
    if (Index==-1) return; 
    var Adm=AdmCom.options[Index].text;
    
    var DepCom=document.getElementById("OrdDep");
    Index=DepCom.selectedIndex;
    if (Index==-1) return; 
    var Dep=DepCom.options[Index].value;
   // alert(Dep);
    if ((Adm=="")) {alert(t['alert:EpisodeIDNull']);return false;};
    var userid=session['LOGON.USERID'];
    var	StDate=document.getElementById("StDate").value;
	var EndDate=document.getElementById("EndDate").value;
    var Sel=document.getElementById("SelDate");
    var lnk;
    var clearaudit=document.getElementById("ClearAudit").value;
    var retval=cspRunServerMethod(clearaudit,Adm);  
    var AllOrd=document.getElementById("AllOrd");
    var NurOrd=document.getElementById("NurOrd");
    var DocOrd=document.getElementById("DocOrd");

    var Stopord=0;
    var NOrd=0;
    var DOrd=0
	if (DocOrd){
		if (DocOrd.checked==true){
			DOrd=1;
			}
		}
	if (NurOrd){
		if (NurOrd.checked==true){
			NOrd=1;
			}
		}

	if (AllOrd){
		if (AllOrd.checked==true){
			Stopord=1
			}
		}
	//+wxl090903 按医嘱开科室或接受科室查询
	var objDocDepId=document.getElementById("DocDepId");
	if (objDocDepId) var DocDepId=objDocDepId.value;
	else var DocDepId="";
	var objDocDep=document.getElementById("DocDep");
	if ((objDocDep)&&(objDocDep.value=="")) DocDepId="";
	var objRecDepId=document.getElementById("RecDepId");
	if (objRecDepId) var RecDepId=objRecDepId.value;
	else var RecDepId="";
	var objRecDep=document.getElementById("RecDep");
	if ((objRecDep)&&(objRecDep.value=="")) RecDepId="";
	var objSelDocDep=document.getElementById("SelDocDep");
	if ((objSelDocDep)&&(objSelDocDep.checked==true)) var SelDocDep="Y";
	else var SelDocDep="N";
	var objSelRecDep=document.getElementById("SelRecDep");
	if ((objSelRecDep)&&(objSelRecDep.checked==true)) var SelRecDep="Y";
	else var SelRecDep="N";
	//+wxl090903
    if (Sel.checked==true)
    {
	   if ((StDate=="")||(EndDate==""))
	   {
		   alert(t['alert:startEndDateNull']);
		   return;
	   }
    	lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCTEMPOERPRINT&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&ssuser="+userid+"&stop="+Stopord+"&Dep="+Dep+"&NurOrd="+NOrd+"&DocOrd="+DOrd+"&SelDocDep="+SelDocDep+"&DocDepId="+DocDepId+"&SelRecDep="+SelRecDep+"&RecDepId="+RecDepId;	 
    }
    else  lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCTEMPOERPRINT&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+""+"&EndDate="+""+"&ssuser="+userid+"&stop="+Stopord+"&Dep="+Dep+"&NurOrd="+NOrd+"&DocOrd="+DOrd+"&SelDocDep="+SelDocDep+"&DocDepId="+DocDepId+"&SelRecDep="+SelRecDep+"&RecDepId="+RecDepId;
     //alert (lnk);
    parent.frames['RPbottom'].location.href=lnk; 
    
//	window.open(lnk,"OrdExec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");

}
function GetRecDepId(str)
{
	var obj=document.getElementById('RecDepId');
	var tem=str.split("^");
	obj.value=tem[1];
}
function GetDocDepId(str)
{
	var obj=document.getElementById('DocDepId');
	var tem=str.split("^");
	obj.value=tem[1];
}
function GetPatRegNo(Str)
{
		var tempStr=Str.split("^");
		if (tempStr[0]=="") return;
   		var GetAdm=document.getElementById("GetAdm").value;
   		var RegNo=document.getElementById("RegNo");
   		RegNo.value=tempStr[0];
   		var AdmObj=document.getElementById("Adm");
	 	getadm(GetAdm,RegNo.value);
	 	var oldLen=RegNo.value.length;
   		for (i=0;i<10-oldLen;i++)
   		{
   			RegNo.value="0"+RegNo.value  
   		}
		if (AdmObj.selectedIndex!=-1)
		{
	  		var ind=AdmObj.selectedIndex;
	  		var seltyp=AdmObj[ind].text;
      		basinfo("^"+seltyp);
	  		var GetTranLoc=document.getElementById("GetTranLoc").value;
      		var retloc=cspRunServerMethod(GetTranLoc,seltyp);  
      		inputadmLoc(retloc);
		}
		Long_click();
}
document.body.onload = BodyLoadHandler;
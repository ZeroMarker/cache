var m_PatientNoLength=8;
if (document.getElementById("PatientNoLen")){
	m_PatientNoLength=document.getElementById("PatientNoLen").value;
}

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
	//obj.value=DateDemo();
	obj=document.getElementById("EndDate");
	//obj.value=DateDemo();
	var Adm=document.getElementById("Adm1").value;
	if (Adm=="") return
	
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
	inputadmLoc(retloc);
     
	Long_click();
	//obj.options[i]=new Option(myarray[1],myarray[0]);
	
	//床位列表
	var obj=document.getElementById("BedList");
	if(obj)
	{
		obj.size=1;
		obj.multiple=false;
		obj.onchange=BedList_changehandler;
	}
	InitBedList();
}
function InitBedList(){
	var obj=document.getElementById("GetBedListBroker");//------------------------------>FindLocDocCurrentAdmBroker
		if (obj) {var encmeth=obj.value} else {var encmeth=''};
	  if(encmeth!="")
	  {
	     var flag=cspRunServerMethod(encmeth,"AddDataToList",session['LOGON.CTLOCID'],session['LOGON.USERID'],"","on","","","","","","","");
	  	
	 	}
}
function AddDataToList(val){
	//alert("val=="+val)
	if(val=="") return;
  var Split_Value=val.split("^");
  //alert(Split_Value)
  if (Split_Value[15]!="") {
	  var IfNewOrdItem=""
	  var obj=document.getElementById("IfNewOrdItem");
		if (obj) {var encmeth=obj.value} else {var encmeth=''};//---------------------------------------------->IfNewOrdItem
	  if(encmeth!="")
	  {
		 IfNewOrdItem=cspRunServerMethod(encmeth,Split_Value[1]) 
	  }
  	var obj=document.getElementById("BedList");
  	if(obj)
  	 		{
  		  		var lstlen=obj.length;
  		  		obj.options[lstlen] = new Option(Split_Value[15],Split_Value[0]+"^"+Split_Value[1]+"^"+Split_Value[2]);
  		  		if (IfNewOrdItem=="1")obj.options[lstlen].style.cssText="font-weight:bold;COLOR: black;BACKGROUND-COLOR:green;"
  		  		var obj2=document.getElementById("Adm");
  		  		if ((obj2)&&(obj2.value==Split_Value[1]))  obj.options[lstlen].selected=true;
  		  }
  	}
  
}
function BedList_changehandler(){
	var obj=document.getElementById('BedList');
	if ((obj)&&(obj.selectedIndex!=-1))
	{
	 var selVal=obj.options[obj.selectedIndex].value;
	 //alert("selVal="+selVal)
	 var Arr=selVal.split("^");
	  var winf=EPR_getTopWindow();
	  if (!winf) return;
			if (typeof winf.SetEpisodeDetails == "function") {
	  		winf.SetEpisodeDetails(Arr[0],Arr[1],Arr[2],"","","","","","","","","","","","","","","","","","","","","","","","")
	  		var MenuPara="";
	  		var obj=document.getElementById('GetMenuPara');//---------------------------->getMenuPara()
	  		if(obj)  {MenuPara=obj.value;}else{MenuPara=""}
	  		//alert(MenuPara)
	  		var MenuParaStr=cspRunServerMethod(MenuPara)
	  		//var s="javascript:CheckLinkDetails('websys.csp?a=a&TMENU=52000&TPAGID=125431707&ChartBookID=6', '')";
	  		var s="javascript:CheckLinkDetails('"+MenuParaStr+"', '')";
	  		winf.eval(s);
			}
  }
}
function EPR_SelectEpisodeDetailsB(EpisodeID,PatientID) {
	//alert(EpisodeID+"||"+PatientID)
	var winf=EPR_getTopWindow();
	if (!winf) return;
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
	var AdmObj=document.getElementById("Adm");
 	if (admstr=="") return;
 	 AdmObj.length=0  //使用长度为0可以进行清除。
  	  for (var i=0;i<AdmObj.length;i++)
 	  {
 		AdmObj.remove(i);
	  }
 	for (var i=1;i<AdmStr.length;i++)
 	{
 		if (AdmStr[i]=="") return;
 		var sel=new Option(AdmStr[i],AdmStr[i]);
		AdmObj.options[AdmObj.options.length]=sel;
		if (i==1)
		{
		//alert (ret);
		}
	}
	AdmObj.selectedIndex=0;
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
	
	if (RegNo.value.length<m_PatientNoLength) {
			for (var i=(m_PatientNoLength-RegNo.value.length-1); i>=0; i--) {
				RegNo.value="0"+RegNo.value
			}
	}
	   
	getadm(GetAdm,RegNo.value);
	if (AdmObj.selectedIndex!=-1)
	{
	  var ind=AdmObj.selectedIndex;
	  var seltyp=AdmObj[ind].text;
      basinfo("^"+seltyp);
	}
 
	//RegNo.value=AdmStr[0];
   }    //s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel

 
}
function basinfo(adm)
{     
	   var baseinfo=document.getElementById("baseInfo").value;
	   var rets=cspRunServerMethod(baseinfo,adm);
	   if (rets==""){alert("无记录信息。");return;}
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
    ///lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORDCZ&RegNo="+RegNo+"&Adm="+Adm;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocNurAddOrderList&EpisodeID="+Adm;
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
    //lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGBCORD&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&ChangeDate="+"1"+"&stop="+Stopord;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocNurAddOrderList&EpisodeID="+Adm;
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
    ///lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORD&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&ChangeDate="+"1"+"&stop="+Stopord;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocNurAddOrderList&EpisodeID="+Adm;
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
		var SelVal=0;
		if (Sel.checked==true){
			var SelVal=1;
		}
		/*
    if (Sel.checked==true)
    {
	   if ((StDate=="")||(EndDate==""))
	   {
		   alert(t['alert:startEndDateNull']);
		   return;   //ssuser
	   }
	   ///lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORD&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&stop="+Stopord+"&ssuser="+userid+"&Dep="+Dep+"&NurOrd="+NOrd+"&DocOrd="+DOrd;
	   lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocNurAddOrderList&EpisodeID="+Adm;
    }
    */
    ///else  lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORD&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+""+"&EndDate="+""+"&stop="+Stopord+"&ssuser="+userid+"&Dep="+Dep+"&NurOrd="+NOrd+"&DocOrd="+DOrd;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocNurAddOrderList&EpisodeID="+Adm+"&PriorCode="+"Long"+"&AllOrd="+Stopord+"&SelDate="+SelVal+"&DocOrd="+DOrd+"&NurOrd="+NOrd+"&StDate="+StDate+"&EndDate="+EndDate;
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


    ///lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCTEMPOERPRINT&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&ChangeDate="+"1"+"&stop="+Stopord;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocNurAddOrderList&EpisodeID="+Adm;
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
		var SelVal=0;
		if (Sel.checked==true){
			var SelVal=1;
		}
		/*
    if (Sel.checked==true)
    {
	   if ((StDate=="")||(EndDate==""))
	   {
		   alert(t['alert:startEndDateNull']);
		   return;
	   }
    ///lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCTEMPOERPRINT&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+StDate+"&EndDate="+EndDate+"&ssuser="+userid+"&stop="+Stopord+"&Dep="+Dep+"&NurOrd="+NOrd+"&DocOrd="+DOrd;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocNurAddOrderList&EpisodeID="+Adm;
	   // alert (lnk);
    }
    */
    ///else  lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCTEMPOERPRINT&RegNo="+RegNo+"&Adm="+Adm+"&StartDate="+""+"&EndDate="+""+"&ssuser="+userid+"&stop="+Stopord+"&Dep="+Dep+"&NurOrd="+NOrd+"&DocOrd="+DOrd;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocNurAddOrderList&EpisodeID="+Adm+"&PriorCode="+"Temp"+"&AllOrd="+Stopord+"&SelDate="+SelVal+"&DocOrd="+DOrd+"&NurOrd="+NOrd+"&StDate="+StDate+"&EndDate="+EndDate;
   
    parent.frames['RPbottom'].location.href=lnk; 
    
//	window.open(lnk,"OrdExec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");

}
document.body.onload = BodyLoadHandler;
var preRowInd=0;
var preRegNo="";
var admType;
var TypeCodeStr="btnCRAMS^btnGLASG^btnRTS^btnGUSTL^btnISS^btnSOFA^btnMEDS^btnAPACHE^btnChildPugh";
var ComponentStr="DHCCLScoreCRAMS^DHCCLScoreGlasgow^DHCCLScoreRTS^DHCCLScoreGustilo^DHCCLScoreISS^DHCCLScoreSOFA^DHCCLScoreMEDS^DHCCLScoreAPACHE^DHCCLScoreChildPugh";
var ScoreTypeStr="CRAMS^GLASG^RTS^GUSTL^ISS^SOFA^MEDS^APACHE^CPugh";
var DefCom,DefScoreType;
function BodyLoadHandler()
{
	var objRegNo=document.getElementById("RegNo");
	//if (objRegNo) {objRegNo.onkeydown=RegNo_KeyDown;}
	//if (objRegNo) objRegNo.onblur=RegNoBlur;

	combo("EpisodeID");
	
	obj=document.getElementById("StDate");
	obj.value=DateDemo();
	obj=document.getElementById("EndDate");
	obj.value=DateDemo();	
	//var Adm=document.getElementById("Adm1").value;
	//if (Adm=="") return
	var EpisodeID=document.getElementById("EpisodeID").value;
	if (EpisodeID!="")
	{
		obj=document.getElementById("GetRegNo").value;
    	var retval=cspRunServerMethod(obj,EpisodeID);  
		if (retval!="")	{objRegNo.value=retval;preRegNo=retval;basinfo(retval);}
		else {document.getElementById("EpisodeID").value="";EpisodeID=""}
	}

	//obj=document.getElementById("GetRegNo").value;
    //var retval=cspRunServerMethod(obj,Adm);  
	//obj=document.getElementById("RegNo");
	//if (obj){
		
		//obj.value=retval;
		//preRegNo=retval;
		//basinfo(obj.value);
	//}
	//inputadm("^"+Adm);
	//admType=document.getElementById("admType").value;
	var obj=document.getElementById('Add')	
	if(obj) obj.onclick=AddScore_click;
	var obj=document.getElementById('Update')	
	if(obj) obj.onclick=UpdateScore_click;
	var obj=document.getElementById('Delete')	
	if(obj) obj.onclick=DeleteScore_click;
	var obj=document.getElementById('SearCH')	
	if(obj) obj.onclick=SearCH_click;
    //var ObjScoreFlag=document.getElementById("ScoreFlag")
    //if(ObjScoreFlag) ObjScoreFlag.options[0].selected=true;
    //if(ObjScoreFlag) ObjScoreFlag.onchange=Select_click;
    var clearScreenObj=document.getElementById("clearScreen");
	if (clearScreenObj) {clearScreenObj.onclick=ClearScreen;}
	var btnCRAMSObj=document.getElementById("btnCRAMS");
	if (btnCRAMSObj) {btnCRAMSObj.onclick=btnScore_Click;}
	var btnGLASGObj=document.getElementById("btnGLASG");
	if (btnGLASGObj) {btnGLASGObj.onclick=btnScore_Click;}
	var btnRTSObj=document.getElementById("btnRTS");
	if (btnRTSObj) {btnRTSObj.onclick=btnScore_Click;}
	var btnGUSTLObj=document.getElementById("btnGUSTL");
	if (btnGUSTLObj) {btnGUSTLObj.onclick=btnScore_Click;}
	var btnISSObj=document.getElementById("btnISS");
	if (btnISSObj) {btnISSObj.onclick=btnScore_Click;}
	var btnSOFAObj=document.getElementById("btnSOFA");
	if (btnSOFAObj) {btnSOFAObj.onclick=btnScore_Click;}
	var btnMEDSObj=document.getElementById("btnMEDS");
	if (btnMEDSObj) {btnMEDSObj.onclick=btnScore_Click;}
	var btnAPACHEObj=document.getElementById("btnAPACHE");
	if (btnAPACHEObj) {btnAPACHEObj.onclick=btnScore_Click;}
	var btnChildPughObj=document.getElementById("btnChildPugh");
	if (btnChildPughObj) {btnChildPughObj.onclick=btnScore_Click;}
	var btnType=TypeCodeStr.split("^");
    var ComponentType=ComponentStr.split("^");
    var ScoreTypeTemp=ScoreTypeStr.split("^");
    for (i=0;i<btnType.length;i++)
    {
		var Obj=document.getElementById(btnType[i]);
		if (Obj) 
		{   DefCom=ComponentType[i];
			DefScoreType=ScoreTypeTemp[i];
	        lnk="websys.default.csp?WEBSYS.TCOMPONENT="+DefCom;
			parent.frames['RPbottom'].location.href=lnk;
			return;
		}
	}

}

function btnScore_Click()
{
	var eSrc=window.event.srcElement;
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var ObjScoreType=document.getElementById("ScoreType");
	if(ObjScoreType) ObjScoreType.value=eSrc.name;	
	if(eSrc.name=="btnCRAMS") lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreCRAMS&SCORERowId="+SCORERowId+"&ScoreType="+"CRAMS"; 
    if(eSrc.name=="btnGLASG") lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreGlasgow&SCORERowId="+SCORERowId+"&ScoreType="+"GLASG";
    if(eSrc.name=="btnRTS") lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreRTS&SCORERowId="+SCORERowId+"&ScoreType="+"RTS"; 
    if(eSrc.name=="btnGUSTL") lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreGustilo&SCORERowId="+SCORERowId+"&ScoreType="+"GUSTL";
    if(eSrc.name=="btnISS") lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreISS&SCORERowId="+SCORERowId+"&ScoreType="+"ISS";
    if(eSrc.name=="btnSOFA") lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreSOFA&SCORERowId="+SCORERowId+"&ScoreType="+"SOFA";
    if(eSrc.name=="btnMEDS") lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreMEDS&SCORERowId="+SCORERowId+"&ScoreType="+"MEDS"; 
    if(eSrc.name=="btnAPACHE") lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreAPACHE&SCORERowId="+SCORERowId+"&ScoreType="+"APACHE"; 
    if(eSrc.name=="btnChildPugh") lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreChildPugh&SCORERowId="+SCORERowId+"&ScoreType="+"CPugh"; 
    parent.frames['RPbottom'].location.href=lnk;
}

function Select_click()
{
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var Obj=document.getElementById("ScoreFlag")
	if(Obj.options[0].selected==true) parent.frames['RPbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreCRAMS&SCORERowId="+SCORERowId+"&ScoreType="+"CRAMS"; 
    if(Obj.options[1].selected==true) parent.frames['RPbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreGlasgow&SCORERowId="+SCORERowId+"&ScoreType="+"GLASG";
    if(Obj.options[2].selected==true) parent.frames['RPbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreRTS&SCORERowId="+SCORERowId+"&ScoreType="+"RTS"; 
    if(Obj.options[3].selected==true) parent.frames['RPbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreGustilo&SCORERowId="+SCORERowId+"&ScoreType="+"GUSTL";
    if(Obj.options[4].selected==true) parent.frames['RPbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreISS&SCORERowId="+SCORERowId+"&ScoreType="+"ISS";
    if(Obj.options[5].selected==true) parent.frames['RPbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreSOFA&SCORERowId="+SCORERowId+"&ScoreType="+"SOFA";
    if(Obj.options[6].selected==true) parent.frames['RPbottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreMEDS&SCORERowId="+SCORERowId+"&ScoreType="+"MEDS"; 
}

function SearCH_click()
{	   
	var AdmCom=document.getElementById("EpisodeID");
    //var Index=AdmCom.selectedIndex;
    //if (Index==-1) return; 
    //var Adm=AdmCom.options[Index].text;
    var Adm=AdmCom.value;
    var objRegNo=document.getElementById("RegNo");
    var	StDate=document.getElementById("StDate").value;
	var EndDate=document.getElementById("EndDate").value;

	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScore&EpisodeID="+Adm+"&RegNo="+objRegNo.value+"&StartDate="+StDate+"&EndDate="+EndDate;
	    
}

function AddScore_click()
{
	var EpisodeID,Adm;
	var userId=session['LOGON.USERID'];
	var ObjAdm=document.getElementById("EpisodeID");
	if(ObjAdm) EpisodeID=ObjAdm.value;
	var objRegNo=document.getElementById("RegNo");
	//var ObjEpisodeID=document.getElementById("EpisodeID");
	//if(ObjEpisodeID) EpisodeID=ObjEpisodeID.value;	
	var obj=document.getElementById('AddScore')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,EpisodeID,userId)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
			location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScore&EpisodeID="+EpisodeID+"&RegNo="+objRegNo.value;
		}
	}
}

function UpdateScore_click()
{
	var SCORERowId;
	var userId=session['LOGON.USERID'];
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('UpdateScore')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId,userId)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
			location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScore&EpisodeID="+Adm+"&RegNo="+objRegNo.value;
		}
	}
}

function DeleteScore_click()
{
	var ObjSCORERowId=document.getElementById("SCORERowId");
	if(ObjSCORERowId) SCORERowId=ObjSCORERowId.value;
	var obj=document.getElementById('DeleteScore')
	if(obj) 
	{
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,SCORERowId)
	    if (resStr!='0'){
			alert(t['Error']);
			return;
		}	
		else  
		{
			alert(t['Success']);
			location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScore&EpisodeID="+Adm+"&RegNo="+objRegNo.value;
		}
	}
}
function RegNo_KeyDown()
{
  
   var key=websys_getKey(e);
   var GetAdm=document.getElementById("GetAdm").value;
   var RegNo=document.getElementById("RegNo");
   var AdmObj=document.getElementById("EpisodeID");
   if (key==13)
   {
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

function getadm(GetAdm,RegNo)
{
  	var ret=cspRunServerMethod(GetAdm,RegNo);
  	var AdmObj=document.getElementById("EpisodeID");
  	alert(ret)
    //inputadm(ret);
}
function inputadm(admstr)
{
	var AdmStr=admstr.split("^");
	var AdmObj=document.getElementById("EpisodeID");
 	 if (admstr=="") return;
 	 
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
function basinfo(adm)
{     
	   var baseinfo=document.getElementById("baseInfo").value;
	   var rets=cspRunServerMethod(baseinfo,adm);
	  var patinfo=document.getElementById("PatBasinfo");
	  var pat=rets.split("^");
	  if (pat[11]=="")
	  alert(t['alert:noDocAssign'])
	  //alert (adm)
	  patinfo.value=pat[4]+"   "+pat[3]+"   "+pat[6];

}
function RegNoBlur()
{
	var i;
    var obj=document.getElementById("PatBasinfo");
    obj.value=""
    var objRegNo=document.getElementById("RegNo");
    if (objRegNo.value==preRegNo) return;
	var isEmpty=(objRegNo.value=="");
    var oldLen=objRegNo.value.length;
	if (!isEmpty) {  //add 0 before regno
	    for (i=0;i<8-oldLen;i++)
	    {
	    	objRegNo.value="0"+objRegNo.value  
	    }
	}
    preRegNo=objRegNo.value;
   	basinfo(objRegNo.value);
    document.getElementById("EpisodeID").value="";EpisodeID="";
}

function GetEpisode(str)
{
	var obj=document.getElementById('EpisodeID');
	var tem=str.split("^");
	obj.value=tem[6];
	SearCH_click();
}

function ClearScreen()
{
	document.getElementById("RegNo").value="";
	document.getElementById("EpisodeID").value="";
	document.getElementById("PatBasinfo").value=""
	document.getElementById("StDate").value=""
	document.getElementById("EndDate").value=""
	SearCH_click();
}

function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCCLScore');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	var SelRowSCORERowId=document.getElementById('tSCORERowIdz'+selectrow);
	var ObjSCORERowId=document.getElementById("SCORERowId");
	ObjSCORERowId.value=SelRowSCORERowId.innerText;
	var SCORERowId=ObjSCORERowId.value;	
	var ObjScoreType=document.getElementById("ScoreType");
	if(ObjScoreType) ScoreType=ObjScoreType.value;
    switch(ScoreType)
        {
	        case "btnCRAMS":
	        	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreCRAMS&SCORERowId="+SCORERowId+"&ScoreType="+"CRAMS";
	        	break;
	        case "btnCRAMS":
	        	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreGlasgow&SCORERowId="+SCORERowId+"&ScoreType="+"GLASG";
	        	break;
	        case "btnRTS":
	        	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreRTS&SCORERowId="+SCORERowId+"&ScoreType="+"RTS";
	        	break;
	        case "btnGUSTL":
	        	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreGustilo&SCORERowId="+SCORERowId+"&ScoreType="+"GUSTL";
	        	break;
	        case "btnISS":
	        	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreISS&SCORERowId="+SCORERowId+"&ScoreType="+"ISS";
	        	break;
	        case "btnSOFA":
	            lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreSOFA&SCORERowId="+SCORERowId+"&ScoreType="+"SOFA";
        		break;
            case "btnSOFA":
	            lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreSOFA&SCORERowId="+SCORERowId+"&ScoreType="+"SOFA";
        		break;
 	        case "btnMEDS":
	            lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreMEDS&SCORERowId="+SCORERowId+"&ScoreType="+"MEDS";
        		break;
        	case "btnAPACHE":
	            lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreAPACHE&SCORERowId="+SCORERowId+"&ScoreType="+"APACHE";
        		break;
  	        case "btnChildPugh":
	            lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCCLScoreChildPugh&SCORERowId="+SCORERowId+"&ScoreType="+"CPugh";
        		break;
  	        default: 
	        	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+DefCom+"&SCORERowId="+SCORERowId+"&ScoreType="+DefScoreType;
	        	break;
        }	            	 		
    parent.frames['RPbottom'].location.href=lnk;
   	return;
}

document.body.onload = BodyLoadHandler;
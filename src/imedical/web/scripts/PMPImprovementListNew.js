//用户新建需求等业务处理js  PMPImprovementListNew.js
var dirc,LocalDirc;
var CurrentSel=0,TypeIndex,file,chushihuaStr,TYPRowidValue,XQStatusValue,selectrow
var userId=session['LOGON.USERID'];
var username=session['LOGON.USERNAME']
var locid=session['LOGON.CTLOCID']
var tables = document.getElementsByTagName("table");
var admdepobj=document.getElementById('CRgoutong');
if (admdepobj) admdepobj.onkeydown=getadmdep1;  
var admdepobj=document.getElementById('CRType');
if (admdepobj) admdepobj.onkeydown=getadmdep2;
var admdepobj=document.getElementById('CREmergency');
if (admdepobj) admdepobj.onkeydown=getadmdep3;
var admdepobj=document.getElementById('CRDegree');
if (admdepobj) admdepobj.onkeydown=getadmdep4;
var admdepobj=document.getElementById('CREngineer');
if (admdepobj) admdepobj.onkeydown=getadmdep5;
var admdepobj=document.getElementById('CRMenu');
if (admdepobj) admdepobj.onkeydown=getadmdep6;
var admdepobj=document.getElementById('XYSHR');
if (admdepobj) admdepobj.onkeydown=getadmdep7;
function BodyLoadHandler()
{	
    var obj=document.getElementById('XGtongyi');
	obj.style.display = 'none';
	if (obj){ obj.onclick=XGtongyi_click;}
	var obj=document.getElementById('XGbutongyi');
	obj.style.display = 'none';
	if (obj){ obj.onclick=XGbutongyi_click;}
    var obj=document.getElementById('XYSHRLB');
    obj.disabled=true;
    var obj=document.getElementById('CRSave');
	if (obj){ obj.onclick=CRSave_click;}
	var obj=document.getElementById('CRquxiao');
	if (obj){ obj.onclick=CRquxiao_click;}
	var obj=document.getElementById('CRNew');
	if (obj){ obj.onclick=CRNew_click;}
	var obj=document.getElementById('TJShow');
	obj.style.display = 'none';
	var obj=document.getElementById('TJShow');
	if (obj){ obj.onclick=TJShow_click;}
	var obj=document.getElementById('CRdelete');
	if (obj) { obj.onclick=CRdelete_click;}
	obj.style.display = 'none';
	trRep = tables[8];
	trRep.style.display = 'none';
	var obj=document.getElementById('YZceshitongguo');
	obj.style.display = 'none';
	if (obj) { obj.onclick=YZceshitongguo_click;}
	var obj=document.getElementById('Create');
	if (obj) { obj.onclick=Create_click;}
	var obj=document.getElementById('CRUpdate');
	if (obj) { obj.onclick=CRUpdate_click;}
    obj.style.display = 'none';
    var obj=document.getElementById('CRTijiaoshenqing');
    obj.style.display = 'none';
    if(obj) { obj.onclick=CRTijiaoshenqing_click;}
     var obj=document.getElementById('YZceshibutongguo');
    obj.style.display = 'none';
    if(obj) { obj.onclick=YZceshibutongguo_click;}
	var obj=document.getElementById("TJConcel");
	if (obj){ obj.onclick=TJConcel_click;}
	var obj=document.getElementById("CRAdjunctFlag");
	if (obj){ obj.onclick=CRAdjunctFlag_click;}
	InitStatus()
}
function SelectRowHandler()	
{
  var YZceshitongguo=document.getElementById('YZceshitongguo');
  var YZceshibutongguo=document.getElementById('YZceshibutongguo');
  var eSrc=window.event.srcElement;	
  var objtbl=document.getElementById('tPMPImprovementListNew');
  var rowObj=getRow(eSrc);
  selectrow=rowObj.rowIndex;
  if (!selectrow) return;
  var SelRowObj
  var obj	
  if (selectrow==CurrentSel){	
  CurrentSel=0;
  TYPStatusValue=""
  YZceshitongguo.style.display = 'none';
  YZceshibutongguo.style.display = 'none';
   var obj=document.getElementById('XGtongyi');
  obj.style.display = 'none';
  var obj=document.getElementById('XGbutongyi');
  obj.style.display = 'none';
  var obj=document.getElementById('CRName');
  obj.value="";
  var obj=document.getElementById('CRMenu');
  obj.value="";
  var obj=document.getElementById('CRType');
  obj.value="";
  var obj=document.getElementById('CREmergency');
  obj.value="";
  var obj=document.getElementById('CREngineer');
  obj.value="";
  var obj=document.getElementById('CRSituation');
  obj.value="";
  var obj=document.getElementById('CRDegree');
  obj.value="";
  var obj=document.getElementById('CRRepairType');
  obj.value="";
  var obj=document.getElementById('CRAdjunctFlagList');
  obj.value="";
  var obj=document.getElementById('CRtel');
  obj.value="";
  var obj=document.getElementById('CRgoutong');
  obj.value="";
  var obj=document.getElementById('CRgoutongjieguo');
  obj.value="";
  var obj=document.getElementById('CQStandby3');
  obj.value="";
  var obj=document.getElementById('CRCode');
  obj.value="";
  chushihuaStr="",TYPRowidValue=""
  lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand1";
  parent.frames[1].location.href=lnk;
  return;
	}		
  CurrentSel=selectrow;
  var row=selectrow;
  var TYPRowid=document.getElementById('XQRowidz'+row);
  TYPRowidValue=TYPRowid.value;
  //alert(TYPRowidValue)
  var obj=parent.frames[1].document.getElementById("str");
  obj.value=TYPRowidValue
  //alert(obj.value)
  var obj=document.getElementById('XGtongyi');
  obj.style.display = 'none';
  var obj=document.getElementById('XGbutongyi');
  obj.style.display = 'none';
  var XQxiangxi=document.getElementById('XQxiangxiz'+row);
  var XQxiangxiValue=XQxiangxi.innerText;
  var XQCode=document.getElementById('XQCodez'+row);
  var XQCodeValue=XQCode.innerText;
  var XQName=document.getElementById('XQNamez'+row);
  var XQNameValue=XQName.innerText;
  var XQStatus=document.getElementById('XQStatusz'+row);
  XQStatusValue=XQStatus.innerText;
  var XQEmergency=document.getElementById('XQEmergencyz'+row);
  var XQEmergencyValue=XQEmergency.innerText;
  var XQDegree=document.getElementById('XQDegreez'+row);
  var XQDegreeValue=XQDegree.innerText;
  var XQMenu=document.getElementById('XQMenuz'+row);
  var XQMenuValue=XQMenu.innerText;
  var XQIPMLEngineerDESC=document.getElementById('XQIPMLEngineerDESCz'+row);
  var XQIPMLEngineerDESCValue=XQIPMLEngineerDESC.value;
  // alert(XQIPMLEngineerDESCValue);
  //alert(XQMenuValue+"XQMenuValue");
  if(XQMenuValue!=""){
      var ListRowidd=tkMakeServerCall("web.PMP.PMPImprovementList","ListRowid",XQMenuValue);
      //alert(ListRowidd+"ListRowidd")
      if(ListRowidd!=""){
	      lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand1&str="+ListRowidd;
          parent.frames[1].location.href=lnk;
      }
      else{
	      lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand1&str="+TYPRowidValue;
          parent.frames[1].location.href=lnk;
	      }
  }
  else{
	  lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand1&str="+TYPRowidValue;
      parent.frames[1].location.href=lnk;
	  }
  var XQAssignEngineer=document.getElementById('XQAssignEngineerz'+row);
  var XQAssignEngineerValue=XQAssignEngineer.innerText;
  var XQAdjunctFlag=document.getElementById('XQAdjunctFlagz'+row);
  var XQAdjunctFlagValue=XQAdjunctFlag.innerText;
  if (XQAdjunctFlag){ XQAdjunctFlag.onclick=XQAdjunctFlag_click;}
  var XQSituation=document.getElementById('XQSituationz'+row);
  var XQSituationValue=XQSituation.value;
  //alert(XQSituationValue)
  var XQStandby3=document.getElementById('XQStandby3z'+row);
  var XQStandby3Value=XQStandby3.value;
  var XQGoutongjieguo=document.getElementById('XQGoutongjieguoz'+row);
  var XQGoutongjieguovalue=XQGoutongjieguo.value;
  var XQCreateTel=document.getElementById('XQCreateTelz'+row);
  var XQCreateTelvalue=XQCreateTel.value;
  var XQStandby2=document.getElementById('XQStandby2z'+row);
  var XQStandby2value=XQStandby2.value;
  var XQType=document.getElementById('XQTypez'+row);
  var XQTypevalue=XQType.value;
  
  var obj=document.getElementById('CRName');
  obj.value=XQNameValue;
  obj.disabled=true;
  
  var obj=document.getElementById('CREngineer');
  obj.value=XQIPMLEngineerDESCValue;
  var obj=document.getElementById('CRMenu');
  obj.value=XQMenuValue;
  obj.disabled=true;
  var CRType=document.getElementById('CRType');
  CRType.value=XQTypevalue;
  CRType.disabled=true;
  var obj=document.getElementById('CREmergency');
  obj.value=XQEmergencyValue;
  obj.disabled=true;
  var obj=document.getElementById('CREngineer');
  obj.value=XQIPMLEngineerDESCValue;
  obj.disabled=true;
  var obj=document.getElementById('CRSituation');
  obj.value=XQSituationValue;
  if((XQStatusValue!="保存")&&(XQStatusValue!="回执")&&(XQStatusValue!="审核不通过")){obj.disabled=true;}
  else{obj.disabled="";}
  //obj.disabled=true;
  var obj=document.getElementById('CRDegree');
  obj.value=XQDegreeValue;
  obj.disabled=true;
  var CRRepairType=document.getElementById('CRRepairType');
  CRRepairType.value="";
  if((XQStatusValue!="保存")&&(XQStatusValue!="回执")&&(XQStatusValue!="审核不通过")){obj.disabled=true;}
  else{obj.disabled="";}
  var VerStr=tkMakeServerCall("web.PMP.PMPImprovementListNew","selectPMPIImprovementAdjunctList",TYPRowidValue,"Improvement");
  //alert(VerStr)
  var obj=document.getElementById('CRAdjunctFlagList');
  obj.value=VerStr;
  obj.disabled=true;
  
  var usernamen=tkMakeServerCall("web.PMP.PMPImprovementListNew","shenheliebiao",TYPRowidValue);
  //alert(usernamen);
  if (usernamen!=""){
	   var CRtel=document.getElementById('XYSHRLB');
       CRtel.value=usernamen;
	  }
  var CRtel=document.getElementById('CRtel');
  CRtel.value=XQCreateTelvalue;
  if((XQStatusValue!="保存")&&(XQStatusValue!="回执")&&(XQStatusValue!="审核不通过")){obj.disabled=true;}
  else{obj.disabled="";}
  var obj=document.getElementById('CRgoutong');
  obj.value=XQStandby2value;
  if((XQStatusValue!="保存")&&(XQStatusValue!="回执")&&(XQStatusValue!="审核不通过")){obj.disabled=true;}
  else{obj.disabled="";}
  var obj=document.getElementById('CRgoutongjieguo');
  obj.value=XQGoutongjieguovalue;
  if((XQStatusValue!="保存")&&(XQStatusValue!="回执")&&(XQStatusValue!="审核不通过")){obj.disabled=true;}
  else{obj.disabled="";}
  var obj=document.getElementById('CQStandby3');
  obj.value=XQStandby3Value;
  if((XQStatusValue!="保存")&&(XQStatusValue!="回执")&&(XQStatusValue!="审核不通过")){obj.disabled=true;}
  else{obj.disabled="";}
  var obj=document.getElementById('CRCode');
  obj.value=XQCodeValue;
  obj.disabled=true;
  chushihuaStr=XQNameValue+"^"+XQMenuValue+"^"+CRType.value+"^"+XQEmergencyValue+"^"+XQAssignEngineerValue+"^"+XQSituationValue+"^"+XQDegreeValue+"^"+CRRepairType.value+"^"+VerStr+"^"+CRtel.value+"^"+XQGoutongjieguovalue+"^"+XQCodeValue+"^"+XQStandby3Value+"^"+XQStandby2value;
  //alert(chushihuaStr);
  var CRUpdate=document.getElementById('CRUpdate');
  var CRdelete=document.getElementById('CRdelete');
  var CRTijiaoshenqing=document.getElementById('CRTijiaoshenqing');
  YZceshitongguo.style.display = 'none';
  YZceshibutongguo.style.display = 'none';
  if(XQStatusValue=="保存"){
	  CRUpdate.style.display = '';
	  CRdelete.style.display = '';
	  CRTijiaoshenqing.style.display = '';
	  YZceshitongguo.style.display = 'none';
      YZceshibutongguo.style.display = 'none';
	  }
   else{
	   CRUpdate.style.display = 'none';
	   CRdelete.style.display = 'none';
	   CRTijiaoshenqing.style.display = 'none';
	   if(XQStatusValue=="测试"){
		   YZceshitongguo.style.display = '';
		   YZceshibutongguo.style.display = '';
		   }
		if(XQStatusValue=="回执"){
			CRUpdate.style.display = '';
	        //CRdelete.style.display = '';
	        CRTijiaoshenqing.style.display = '';
			}
		if(XQStatusValue=="审核不通过"){
			CRUpdate.style.display = '';
	        //CRdelete.style.display = '';
	        CRTijiaoshenqing.style.display = '';
			}
	   }
 if(XQStatusValue=="更改需求"){
	 var obj=document.getElementById('XGtongyi');
     obj.style.display = '';
     var obj=document.getElementById('XGbutongyi');
     obj.style.display = '';
	 }
}
function FrameEnterkeyCode()
{
	var e=window.event;
	switch (e.keyCode){
		//上下移动光标键
	case 38:
		var objtbl=window.document.getElementById('tPMPImprovementListNew');
		if (iSeldRow==1) {break;}
		var objrow=objtbl.rows[iSeldRow-1];
		objrow.click();
		break;
	case 40:
		var objtbl=window.document.getElementById('tPMPImprovementListNew');
		var rows=objtbl.rows.length-1;
		if (iSeldRow==rows) {break;}
		var objrow=objtbl.rows[iSeldRow+1];
		objrow.click();
		break;
	}
}
function BrowseFolder(name) {
	 
	 var fd = new ActiveXObject("MSComDlg.CommonDialog");
       fd.Filter = "所有类型(*)"; //過濾文件類型
       fd.filename=name
       fd.FilterIndex = 2;
       fd.MaxFileSize = 128;
       //fd.ShowOpen();//打开对话框
       fd.ShowSave();//保存对话框
       VerStrstr=fd.filename;//fd.filename路径
}
///JS生成bat文件
function Log(url){ 
	var fso=new	ActiveXObject("Scripting.FileSystemObject");
	var LogFolder="D:";
	if(!fso.FolderExists(LogFolder)){
		fso.CreateFolder(LogFolder);     	
	}
    ts=fso.OpenTextFile(LogFolder+"\\"+"cmd.bat",8,true);
	ts.WriteLine("@echo off");
	
    ts.WriteLine(url);
    ts.WriteLine("del d:\\cmd.bat");
	ts.Close();
	OpenWindow2()
}
function OpenWindow2() {
	 s=new  ActiveXObject("WScript.Shell"); 
	 //alert("执行")   
     s.Run("d:\cmd.bat",0,true);
    // alert(t["2"])
}
function TJConcel_click() {
	var obj=document.getElementById('TJShow');
	obj.style.display = '';
	var obj=document.getElementById('TJConcel');
	obj.style.display = 'none';
	trRep = tables[3];
	trRep.style.display = 'none';
}
function TJShow_click() {
	var obj=document.getElementById('TJShow');
	obj.style.display = 'none';
	var obj=document.getElementById('TJConcel');
	obj.style.display = '';
	trRep = tables[3];
	trRep.style.display = '';
}
function SelectCRgoutong(str){
	var inci=str.split("^");
	var obj=document.getElementById("CRgoutong");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("CRgoutongID");
	 if(obj){obj.value=inci[1]}
	}
function SelectCRType(str){
	var inci=str.split("^");
	var obj=document.getElementById("CRType");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("CRTypeID");
	 if(obj){obj.value=inci[1]}
	}
function getadmdep1()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  CRgoutong_lookuphandler();
		}
}
function getadmdep2()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  CRType_lookuphandler();
		}
}
function getadmdep3()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  CREmergency_lookuphandler();
		}
}
function getadmdep4()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   CRDegree_lookuphandler();
		}
}
function getadmdep5()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   CREngineer_lookuphandler();
		}
}
function getadmdep6()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   CRMenu_lookuphandler();
		}
}
function getadmdep7()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   XYSHR_lookuphandler();
		}
}
function CRAdjunctFlag_click(){
	BrowseFolder("")
	var obj=document.getElementById('CRAdjunctFlagList');
	obj.disabled=true;
	if(obj.value==""){
		obj.value=VerStrstr;
		
		}
	else{
		obj.value=obj.value+"||"+VerStrstr;
		}
	}
function CRUpdate_click(){
  var TJCreateDateStart=document.getElementById('TJCreateDateStart');
  var TJCreateDateEnd=document.getElementById('TJCreateDateEnd');
  var CRName=document.getElementById('CRName');
  var CRMenu=document.getElementById('CRMenu');
  var CRType=document.getElementById('CRType');
  var CREmergency=document.getElementById('CREmergency');
  var CREngineer=document.getElementById('CREngineer');
  var CRSituation=document.getElementById('CRSituation');
  var CRDegree=document.getElementById('CRDegree');
  var CRRepairType=document.getElementById('CRRepairType');
  var CRAdjunctFlagList=document.getElementById('CRAdjunctFlagList');
  var CRtel=document.getElementById('CRtel');
  var CRgoutong=document.getElementById('CRgoutongID');
  //alert(CRgoutong.innerText);
  //CRgoutong.value="111"
  //alert(CRgoutong.value);
  var CRgoutongjieguo=document.getElementById('CRgoutongjieguo');
  var CQStandby3=document.getElementById('CQStandby3');
  var CRCode=document.getElementById('CRCode');
  //alert(TYPRowidValue);
  var Str=CRName.value+"^"+CRMenu.value+"^"+CRType.value+"^"+CREmergency.value+"^"+CREngineer.value+"^"+CRSituation.value+"^"+CRDegree.value+"^"+CRRepairType.value+"^"+CRAdjunctFlagList.value+"^"+CRtel.value+"^"+CRgoutongjieguo.value+"^"+CRCode.value+"^"+CQStandby3.value+"^"+CRgoutong.value;
  //alert(Str);
  if(chushihuaStr==Str) {
	  alert(t["SamePrompt"]);
	  return;
	  }
  else {
	  //alert(Str);
	  var VerStr1=tkMakeServerCall("web.PMP.PMPImprovementListNew","UpdateImprovementList",Str,TYPRowidValue);
	  chushihuaStr=chushihuaStr.split("^");
	  //alert(chushihuaStr[8]);
	  if((CRAdjunctFlagList.value!="")&&(chushihuaStr[8]=="")){
	  //var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChangechang",CRAdjunctFlagList.value);
	  VerStr=CRAdjunctFlagList.value.split("||");
	  if(VerStr!="")
	  {	
	  //alert(VerStr);
		for(i=0;i<=VerStr.length-1;i++)
		{  
			  VerStrName=VerStr[i].split("\\");
			  name=VerStrName[VerStrName.length-1];
			  vers="D:\\dthealth\\app\\dthis\\fujian\\"
			  //vers="\\\\172.16.0.27\\dhccpmp\\"
			  var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChange",vers);
			  alert(VerStr[i]);
			  //added by dongzt ----------------去除路径空格-----------
			  dirc=handleSpace(VerStrName);
			  alert(dirc);
			  LocalDirc=dirc+"\\"+name;
			  aa="copy "+LocalDirc+" "+vers+name;
			//added by dongzt --------------------------------------
			 // aa="copy "+VerStr[i]+" "+vers+name;
			  alert(aa)
			  Log(aa)
			   
		}
	}
	}
	  alert(t[VerStr1]);
	  lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementListNew&TJCreateDateStart="+TJCreateDateStart.value+"&TJCreateDateEnd="+TJCreateDateEnd.value;
	  location.href=lnk;
	  }
	}
function CRdelete_click(){
	
	if(XQStatusValue!="保存"){
		alert(t["12"]);
		return;
		}
	else {
		var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementListNew","Delete",TYPRowidValue);
		alert(t[VerStrsinn]);
		}
	}
function Create_click(){
	trRep = tables[7];
	trRep.style.display = 'none';
	trRep = tables[8];
	trRep.style.display = '';
	trRep = tables[4];
	trRep.style.display = 'none';
	trRep = tables[5];
	trRep.style.display = 'none';
	TJConcel_click();
	trRep = tables[2];
	trRep.style.display = 'none';
	//trRep = tables[10];
	//trRep.style.display = 'none';
	//trRep = tables[11];
	//trRep.style.display = 'none';
	TYPStatusValue=""
    var obj=document.getElementById('CRName');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CRCode');
    obj.value=tkMakeServerCall("web.PMP.PMPImprovementListNew","CRCode");
    obj.disabled=true;
    var obj=document.getElementById('CRMenu');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CRType');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CREmergency');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CREngineer');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CRSituation');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CRDegree');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CRRepairType');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CRAdjunctFlagList');
    obj.value="";
    obj.disabled=true;
    var obj=document.getElementById('CRtel');
    obj.value="";
    var obj=document.getElementById('CRgoutong');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CRgoutongjieguo');
    obj.value="";
    obj.disabled="";
    var obj=document.getElementById('CQStandby3');
    obj.value="";
    obj.disabled="";
    chushihuaStr="",TYPRowidValue=""
	}
function CRSave_click(){
	
	var obj=document.getElementById('XYSHRID');
	var XYSHRIDvalue=obj.value;
	var obj=document.getElementById('CRName');
	var CRNamev=obj.value;
    if(obj.value==""){
	    alert(t["CRName"]);
	    return;
	    }
	var obj=document.getElementById('CRCode');
	var CRCodev=obj.value;
	var obj=document.getElementById('CRtel');
	var CRtelv=obj.value;
    if(obj.value==""){
	    alert(t["CRtel"]);
	    return;
	    }
	var obj=document.getElementById('CRTypeID');
	var CRTypeIDv=obj.value;
	if(obj.value==""){
	    alert(t["CRType"]);
	    return;
	    }
	if(obj.value=="已有菜单"){
	    alert(t["CRType1"]);
	    return;
	    }
	var obj=document.getElementById('CRgoutongID');
	var CRgoutongIDv=obj.value;
	var obj=document.getElementById('CRMenu');
	var CRMenuv=obj.value;
	var obj=document.getElementById('CRgoutongjieguo');
	var CRgoutongjieguov=obj.value;
	if((obj.value=="")&&(CRgoutongIDv!="")){
	    alert(t["CRgoutong"]);
	    return;
	    }
	var obj=document.getElementById('CRSituation');
	var CRSituationv=obj.value;
	if((obj.value=="")||(obj.value.length<10)){
	    alert(t["CRSituation"]);
	    return;
	    }
	var obj=document.getElementById('CREmergencyID');
	var CREmergencyv=obj.value;
	var obj=document.getElementById('CRDegreeID');
	var CRDegreev=obj.value;
	var obj=document.getElementById('CRRepairType');
	var CRRepairTypev=obj.value;
	var obj=document.getElementById('CRAdjunctFlagList');
	var CRAdjunctFlagListv=obj.value;
	var obj=document.getElementById('CREngineerID');
	var CREngineerIDv=obj.value;
	var obj=document.getElementById('CRSituation');
	var CRSituationv=obj.value;
	var obj=document.getElementById('CQStandby3');
	var CQStandby3v=obj.value;
	var str=CRNamev+"^"+CRCodev+"^"+CRtelv+"^"+CRTypeIDv+"^"+CRgoutongIDv+"^"+CRgoutongjieguov+"^"+CRSituationv+"^"+CREmergencyv+"^"+CRDegreev+"^"+CRRepairTypev+"^"+CRAdjunctFlagListv+"^"+CREngineerIDv+"^"+CRSituationv+"^"+CQStandby3v+"^"+userId+"^"+locid+"^"+CRMenuv+"^"+XYSHRIDvalue;
	//alert(str);
	var Menu=tkMakeServerCall("web.PMP.PMPImprovementList","Menu",CRMenuv);
	if(Menu!="bucunzai"){
		str=str+"^"+Menu;
		//alert("1");
		var JiHuo=window.confirm(t["cunzai"]);
		//alert("2");
		if(!JiHuo){
			return;
			}
		}
	else {
		str=str+"^"+"";
		}
		str=str+"@@"+"Save" //add by dongzt,增加保存save,提交申请标志Submit
	var VerStrsinnn=tkMakeServerCall("web.PMP.PMPImprovementListNew","InsertPMPImprovementList",str);
	if(VerStrsinnn=="0")
	{
	if (CRAdjunctFlagListv!="") {
		 VerStr=CRAdjunctFlagListv.split("||");
		 //alert(VerStr);
	  if(VerStr!="")
	  {	
		for(i=0;i<=VerStr.length-1;i++)
		{  
			  VerStrName=VerStr[i].split("\\");
			  
			  
			  name=VerStrName[VerStrName.length-1];
			  
			 vers="D:\\dthealth\\app\\dthis\\fujian\\"
			   //vers="\\\\172.16.0.27\\DHCCPMP\\"
			  var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChange",vers);
			  alert(VerStr[i]);
			  //aa="copy "+VerStr[i]+" "+vers+name;
			 // alert(LocalDirc);
			 //added by dongzt ----------------去除路径空格-----------
			  dirc=handleSpace(VerStrName);
			  alert(dirc);
			  LocalDirc=dirc+"\\"+name;
			  aa="copy "+LocalDirc+" "+vers+name;
			//added by dongzt --------------------------------------
			  //alert(aa);
			  Log(aa)	   
			  }
	      }
		}
	var myrtn=window.confirm(t[VerStrsinnn]+"您需要直接提交吗？");
    if (myrtn){
	    //alert(myrtn);
	    var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementListNew","SubmitApplication",CRCodev);
	    
	     ///edit by dongzt
	    if (VerStrsinn=="0")
	    {
		    alert(t[VerStrsinn]);
      		 
		}
		else
		{
			alert(VerStrsinn+"!!"+"数据插入失败，请联系项目实施人员！~");
		}
	  
	}
	
	}
	else
	{
		alert(VerStrsinn+"!!"+"数据插入失败，请联系项目实施人员！~");
	}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementListNew";
	location.href=lnk;
	/*
	if (!myrtn){
		
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementListNew";
	    location.href=lnk;
	    
		}
	*/
	
	}

function CRquxiao_click(){
	trRep = tables[7];
	trRep.style.display = '';
	trRep = tables[8];
	trRep.style.display = 'none';
	trRep = tables[4];
	trRep.style.display = '';
	trRep = tables[5];
	trRep.style.display = '';
	TJConcel_click();
	trRep = tables[2];
	trRep.style.display = '';
	/*
	var row=selectrow
	var XQxiangxi=document.getElementById('XQxiangxiz'+row);
    var XQxiangxiValue=XQxiangxi.innerText;
    var XQCode=document.getElementById('XQCodez'+row);
    var XQCodeValue=XQCode.innerText;
    var XQName=document.getElementById('XQNamez'+row);
    var XQNameValue=XQName.innerText;
    var XQStatus=document.getElementById('XQStatusz'+row);
    XQStatusValue=XQStatus.innerText;
    var XQEmergency=document.getElementById('XQEmergencyz'+row);
    var XQEmergencyValue=XQEmergency.innerText;
    var XQDegree=document.getElementById('XQDegreez'+row);
    var XQDegreeValue=XQDegree.innerText;
    var XQMenu=document.getElementById('XQMenuz'+row);
    var XQMenuValue=XQMenu.innerText;
    var XQAssignEngineer=document.getElementById('XQAssignEngineerz'+row);
    var XQAssignEngineerValue=XQAssignEngineer.innerText;
    var XQAdjunctFlag=document.getElementById('XQAdjunctFlagz'+row);
    var XQAdjunctFlagValue=XQAdjunctFlag.innerText;
    var XQSituation=document.getElementById('XQSituationz'+row);
    var XQSituationValue=XQSituation.value;
    //alert(XQSituationValue)
    var XQStandby3=document.getElementById('XQStandby3z'+row);
    var XQStandby3Value=XQStandby3.value;
    var XQGoutongjieguo=document.getElementById('XQGoutongjieguoz'+row);
    var XQGoutongjieguovalue=XQGoutongjieguo.value;
    var XQCreateTel=document.getElementById('XQCreateTelz'+row);
    var XQCreateTelvalue=XQCreateTel.value;
    var XQStandby2=document.getElementById('XQStandby2z'+row);
    var XQStandby2value=XQStandby2.value;
    var XQType=document.getElementById('XQTypez'+row);
    var XQTypevalue=XQType.value;
    var obj=document.getElementById('CRName');
    obj.value=XQNameValue;
    obj.disabled=true;
    var obj=document.getElementById('CRMenu');
    obj.value=XQMenuValue;
    obj.disabled=true;
    var CRType=document.getElementById('CRType');
    CRType.value=XQTypevalue;
    CRType.disabled=true;
    var obj=document.getElementById('CREmergency');
    obj.value=XQEmergencyValue;
    obj.disabled=true;
    var obj=document.getElementById('CREngineer');
    obj.value=XQAssignEngineerValue;
    obj.disabled=true;
    var obj=document.getElementById('CRSituation');
    obj.value=XQSituationValue;
    if(XQStatusValue!="保存"){obj.disabled=true;}
    //obj.disabled=true;
    var obj=document.getElementById('CRDegree');
    obj.value=XQDegreeValue;
    obj.disabled=true;
    var CRRepairType=document.getElementById('CRRepairType');
    CRRepairType.value="";
    if(XQStatusValue!="保存"){obj.disabled=true;}
    var VerStr=tkMakeServerCall("web.PMP.PMPImprovementListNew","selectPMPIImprovementAdjunctList",TYPRowidValue,"Improvement");
    //alert(VerStr)
    var obj=document.getElementById('CRAdjunctFlagList');
    obj.value=VerStr;
    obj.disabled=true;
    var CRtel=document.getElementById('CRtel');
    CRtel.value=XQCreateTelvalue;
    if(XQStatusValue!="保存"){obj.disabled=true;}
    var obj=document.getElementById('CRgoutong');
    obj.value=XQStandby2value;
    if(XQStatusValue!="保存"){obj.disabled=true;}
    var obj=document.getElementById('CRgoutongjieguo');
    obj.value=XQGoutongjieguovalue;
    if(XQStatusValue!="保存"){obj.disabled=true;}
    var obj=document.getElementById('CQStandby3');
    obj.value=XQStandby3Value;
    if(XQStatusValue!="保存"){obj.disabled=true;}
    var obj=document.getElementById('CRCode');
    obj.value=XQCodeValue;
    obj.disabled=true;
    chushihuaStr=XQNameValue+"^"+XQMenuValue+"^"+CRType.value+"^"+XQEmergencyValue+"^"+XQAssignEngineerValue+"^"+XQSituationValue+"^"+XQDegreeValue+"^"+CRRepairType.value+"^"+VerStr+"^"+CRtel.value+"^"+XQGoutongjieguovalue+"^"+XQCodeValue+"^"+XQStandby3Value+"^"+XQStandby2value;
    //alert(chushihuaStr);
    var CRUpdate=document.getElementById('CRUpdate');
    var CRdelete=document.getElementById('CRdelete');
    if(XQStatusValue=="保存"){
	   CRUpdate.style.display = '';
	   CRdelete.style.display = '';
	  }
	  */
	}
function SelectCREmergency(str) {
	var inci=str.split("^");
	var obj=document.getElementById("CREmergency");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("CREmergencyID");
	 if(obj){obj.value=inci[1]}
	}
function SelectCRDegree(str) {
	var inci=str.split("^");
	var obj=document.getElementById("CRDegree");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("CRDegreeID");
	 if(obj){obj.value=inci[1]}
	}
function SelectCREngineer(str) {
	var inci=str.split("^");
	var obj=document.getElementById("CREngineer");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("CREngineerID");
	 if(obj){obj.value=inci[1]}
	}
	
//提交申请 分为两个保存和提交，插入的表很多，需要用事务保持数据的一致性 dongzt
function CRNew_click(){
	var obj=document.getElementById('XYSHRID');
	var XYSHRIDvalue=obj.value;
	var obj=document.getElementById('CRName');
	var CRNamev=obj.value;
    if(obj.value==""){
	    alert(t["CRName"]);
	    return;
	    }
	var obj=document.getElementById('CRCode');
	var CRCodev=obj.value;
	var obj=document.getElementById('CRtel');
	var CRtelv=obj.value;
    if(obj.value==""){
	    alert(t["CRtel"]);
	    return;
	    }
	var obj=document.getElementById('CRTypeID');
	var CRTypeIDv=obj.value;
	if(obj.value==""){
	    alert(t["CRType"]);
	    return;
	    }
	if(obj.value=="已有菜单"){
	    alert(t["CRType1"]);
	    return;
	    }
	var obj=document.getElementById('CRgoutongID');
	var CRgoutongIDv=obj.value;
	var obj=document.getElementById('CRMenu');
	var CRMenuv=obj.value;
	var obj=document.getElementById('CRgoutongjieguo');
	var CRgoutongjieguov=obj.value;
	if((obj.value=="")&&(CRgoutongIDv!="")){
	    alert(t["CRgoutong"]);
	    return;
	    }
	var obj=document.getElementById('CRSituation');
	var CRSituationv=obj.value;
	if((obj.value=="")||(obj.value.length<10)){
	    alert(t["CRSituation"]);
	    return;
	    }
	var obj=document.getElementById('CREmergencyID');
	var CREmergencyv=obj.value;
	var obj=document.getElementById('CRDegreeID');
	var CRDegreev=obj.value;
	var obj=document.getElementById('CRRepairType');
	var CRRepairTypev=obj.value;
	var obj=document.getElementById('CRAdjunctFlagList');
	var CRAdjunctFlagListv=obj.value;
	var obj=document.getElementById('CREngineerID');
	var CREngineerIDv=obj.value;
	var obj=document.getElementById('CRSituation');
	var CRSituationv=obj.value;
	var obj=document.getElementById('CQStandby3');
	var CQStandby3v=obj.value;
	var str=CRNamev+"^"+CRCodev+"^"+CRtelv+"^"+CRTypeIDv+"^"+CRgoutongIDv+"^"+CRgoutongjieguov+"^"+CRSituationv+"^"+CREmergencyv+"^"+CRDegreev+"^"+CRRepairTypev+"^"+CRAdjunctFlagListv+"^"+CREngineerIDv+"^"+CRSituationv+"^"+CQStandby3v+"^"+userId+"^"+locid+"^"+CRMenuv+"^"+XYSHRIDvalue;
	//alert(str);
	var Menu=tkMakeServerCall("web.PMP.PMPImprovementList","Menu",CRMenuv);
	if(Menu!="bucunzai"){
		str=str+"^"+Menu;
		//alert("1");
		var JiHuo=window.confirm(t["cunzai"]);
		//alert("2");
		if(!JiHuo){
			return;
			}
		}
	else {
		str=str+"^"+"";
		}
	str=str+"@@"+"Submit" //add by dongzt,增加保存 Save,提交申请标志Submit
	var VerStrsinnn=tkMakeServerCall("web.PMP.PMPImprovementListNew","InsertPMPImprovementList",str);
	//alert("3");
	//alert(t[VerStrsinnn]);
	//alert("4");
	//dongzt 
	 if (VerStrsinnn=="0")
	 {
		if (CRAdjunctFlagListv!="") 
		{
		 	VerStr=CRAdjunctFlagListv.split("||");
			 //alert(VerStr);
	  		if(VerStr!="")
	 		{	
				for(i=0;i<=VerStr.length-1;i++)
				{  
				  VerStrName=VerStr[i].split("\\");
				 // var dirc=handleSpace(VerStrName);
				  name=VerStrName[VerStrName.length-1];
				  vers="D:\\dthealth\\app\\dthis\\fujian\\"
				  //vers="\\\\172.16.0.27\\DHCCPMP\\"
				  var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChange",vers);
				  alert(VerStr[i]);
				  var 
				  
				   //added by dongzt ----------------去除路径空格-----------
			 	 dirc=handleSpace(VerStrName);
			 	 alert(dirc);
			 	 LocalDirc=dirc+"\\"+name;
			 	 aa="copy "+LocalDirc+" "+vers+name;
				//added by dongzt --------------------------------------
			
			
				 // aa="copy "+VerStr[i]+" "+vers+name;
			 	 //alert(aa);
			 	 Log(aa)	   
				}
	    	}
		}
	   
		alert(t[VerStrsinn]);
      		
	}
	else
	{
		alert(VerStrsinn+"!!"+"数据插入失败，请联系项目实施人员！~");
	}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementListNew";
	location.href=lnk;
}
function CRTijiaoshenqing_click(){
	var obj=document.getElementById('CRCode');
	var CRCodev=obj.value;
	var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementListNew","SubmitApplication",CRCodev);
	//edit by dongzt
	if(VerStrsinn=="0")
	{
		alert(t[VerStrsinn]);

	}
	else
	{
		alert(VerStrsinn+"!!"+"数据保存失败！~");
	}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementListNew";
    location.href=lnk;
        window.opener.location.reload(); //刷新原页面  dongzt

	}
function YZceshitongguo_click(){
	//alert(TYPRowidValue);
	var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementListNew","CeShiTongGuo",TYPRowidValue,userId);
	alert(t[VerStrsinn]);
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementListNew";
    location.href=lnk;
	}
function YZceshibutongguo_click(){
	//alert(TYPRowidValue);
	var VerStrin=tkMakeServerCall("web.PMP.ImproventFindShenhe","cunID",TYPRowidValue,userId);
	if (VerStrin==""){
	     alert(t["kong"]);
		 return;
	      }
	window.open('websys.default.csp?WEBSYS.TCOMPONENT=PMPXQCESHIBUGUO', '测试不通过', 'resizable=yes,height=250,width=750');
	}
function InitStatus()
{
     var objtbl=document.getElementById('tPMPImprovementListNew');
     if (objtbl)
     {
          var rows = objtbl.rows;
          var ts;
          for(var i=1;i<rows.length;i++)
          {
               ts = document.getElementById("XQStatusz"+i);
               if (ts.innerText=="审核不通过")
               {
                   //alert(ts.value)
                   //rows[i].className='ScheduleStop';
                   rows[i].style.backgroundColor="red" 
                   //ts.style.Image="/webemr/download.gif"  
               }
                if (ts.innerText=="更改需求")
               {
                   //alert(ts.value)
                   //rows[i].className='ScheduleStop';
                   rows[i].style.backgroundColor="yellow" 
                   //ts.style.Image="/webemr/download.gif"  
               }
          }    
     }
}
function SelectXYSHR(str){
	var inci=str.split("^");
	var obj=document.getElementById("XYSHR");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("XYSHRLB");
	if (obj)
	{  
	   if(obj.value==""){
		   obj.value=inci[0];
		   }
		else{
			obj.value=obj.value+","+inci[0];
			}	
	 }
	 var obj=document.getElementById("XYSHRID");
	 if(obj){
		 if(obj.value==""){
			 obj.value=inci[2];
			 }
	     else{
		     obj.value=obj.value+","+inci[2];
		     }
	 }
	}
function XGtongyi_click(){
	//alert("确认");
	if(TYPRowidValue==""){
		alert(t["Check1"]);
		return;
		}
	else{
		//alert(TYPRowidValue);
		var VerStrsinnnn=tkMakeServerCall("web.PMP.PMPImprovementListNew","Confrm",TYPRowidValue);
		alert(t[VerStrsinnnn]);
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementListNew";
        location.href=lnk;
		}
	}
function XGbutongyi_click(){
	if(TYPRowidValue==""){
		alert(t["Check1"]);
		return;
		}
	else{
	alert("就这样");
	window.open('websys.default.csp?WEBSYS.TCOMPONENT=XGbutongyi&Rowid='+TYPRowidValue, '确认问题', 'resizable=yes,height=300,width=750,left=200,top=200');
	//var VerStrsinnnnn=tkMakeServerCall("web.PMP.PMPImprovementListNew","NoConfrm",TYPRowidValue);
	//alert(t[VerStrsinnnnn]);
	//lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementListNew";
    //location.href=lnk;
	}
	
	}
function XQAdjunctFlag_click(){
	if(TYPRowidValue==""){
		alert(t["Check"]);
	       return;}
	else{
		rowid=TYPRowidValue;
		var VerStr=tkMakeServerCall("web.PMP.PMPImprovementList","selectPMPIImprovementAdjunct",rowid,"Improvement");
		//alert(VerStr)
		if (VerStr=="") {
			alert(t["5"]);
			return;
			}
		VerStr=VerStr.split("^");
		var No=VerStr.length
		alert(t["3"]+No+t["4"])
		if(VerStr!="")
		{	
			for(i=0;i<=VerStr.length-1;i++)
			{  
			   VerStrName=VerStr[i].split(",");
			   name=VerStrName[1]
			   BrowseFolder(name)
			   vers="D:\\dthealth\\app\\dthis\\fujian\\"
			   //vers="\\\\172.16.0.27\\DHCCPMP\\"
			   //var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChange",VerStrstr);
			   
			  //added by dongzt ----------------去除路径空格-----------
			  dirc=handleSpace(VerStrName);
			  alert(dirc);
			  LocalDirc=dirc+"\\"+name;
			  aa="copy "+LocalDirc+" "+vers+name;
			//added by dongzt --------------------------------------
			   //aa="copy "+vers+name+" "+VerStrstr;
			   Log(aa);
			   alert(t["2"]);
			}
		}
    }
    }
document.body.onload = BodyLoadHandler;
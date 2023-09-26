//需求处理js
var CurrentSel=0,TypeIndex,file
var admdepobj=document.getElementById('XQmokuai');
if (admdepobj) admdepobj.onkeydown=getadmdep1  
var admdepobj=document.getElementById('PMPModule');
if (admdepobj) admdepobj.onkeydown=getadmdep2
var admdepobj=document.getElementById('User');
if (admdepobj) admdepobj.onkeydown=getadmdep3
var admdepobj=document.getElementById('PMPProduct');
if (admdepobj) admdepobj.onkeydown=getadmdep4
var admdepobj=document.getElementById('XQzhuangtai');
if (admdepobj) admdepobj.onkeydown=getadmdep5
var admdepobj=document.getElementById('COMMUuser');
if (admdepobj) admdepobj.onkeydown=getadmdep7
var admdepobj=document.getElementById('COMMClent1');
if (admdepobj) admdepobj.onkeydown=getadmdep6;
var admdepobj=document.getElementById('XCGCS');
if (admdepobj) admdepobj.onkeydown=getadmdep8;
var userId=session['LOGON.USERID'];
var username=session['LOGON.USERNAME']
var locid=session['LOGON.CTLOCID']
function BodyLoadHandler()
{
	var tables = document.getElementsByTagName("table");
	var obj=document.getElementById('XSTJ');
	obj.style.display = 'none';
	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click;}
	var obj=document.getElementById("YCTJ");
	if (obj){ obj.onclick=YCTJ_click;}
	var obj=document.getElementById("XSTJ");
	if (obj){ obj.onclick=SXTJ_click;}
	var obj=document.getElementById("Communication");
	if (obj){ obj.onclick=Communication_click;}
	var obj=document.getElementById("PMPModule");
	if (obj){ obj.onclick=PMPModule_click;}
	var obj=document.getElementById("PMPProduct");
	if (obj){ obj.onclick=PMPProduct_click;}
	var obj=document.getElementById("User");
	if (obj){ obj.onclick=User_click;}
	var obj=document.getElementById("COMMfujian");
	if (obj){ obj.onclick=COMMfujian_click;}
	var obj=document.getElementById("COMMfanhui");
	if (obj){ obj.onclick=COMMfanhui_click;}
	var obj=document.getElementById("COMMNew");
	if (obj){ obj.onclick=COMMNew_click;}
	//var obj=document.getElementById("COMMClent1");
	//if (obj){ obj.onchange=OnChange;}
	trRep = tables[9];
	trRep.style.display = 'none';
	//tables[1].style.display = 'none';
}
function SelectRowHandler()	
{
  var eSrc=window.event.srcElement;	
  var objtbl=document.getElementById('tPMPImprovementHand');
  var rowObj=getRow(eSrc);
  var selectrow=rowObj.rowIndex;
  if (!selectrow) return;
  var SelRowObj
	var obj	
	if (selectrow==CurrentSel){	
	CurrentSel=0;
	var obj=parent.frames[1].document.getElementById("str");
    obj.value=""	
    var obj=document.getElementById('PmpRowid');
    obj.innerText="";
    var obj=document.getElementById('XQcode');
    obj.value="";
    var obj=document.getElementById('XQname');
    obj.value="";
    var obj=document.getElementById('XQuser');
    obj.value="";
    //var obj=document.getElementById('XQcaidan');
    //obj.value="";
    var obj=document.getElementById('XQneirong');
    obj.value="";
    var obj=document.getElementById('XQyanzhongchengdu');
    obj.value="";
    var obj=document.getElementById('XQjingjichengdu');
    obj.value="";
    var obj=document.getElementById('XQneirong');
    obj.value="";
    var obj=document.getElementById('XQtel');
    obj.value="";
    var obj=document.getElementById('PredictTime');
    obj.value="";
    var obj=document.getElementById('XQzhuangtaiID');
    obj.value="";
    var obj=document.getElementById('XQzhuangtai');
    obj.value="";
    var obj=document.getElementById('XQchuliguocheng');
    obj.value="";
    var obj=document.getElementById('XQcaidan');
    obj.value="";
    var obj=document.getElementById('XQkaifa');
    obj.value="";
    var obj=document.getElementById('XQmokuai');
    obj.value="";
    var obj=document.getElementById("XQmokuaiID");
    obj.value="";
    var obj=document.getElementById("COMMUserList");
    obj.value="";
    var obj=document.getElementById("CRIPMLStandby3");
    obj.value="";
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand1";
	parent.frames[1].location.href=lnk;
	 return;
	}		
  CurrentSel=selectrow;
  var row=selectrow;
  var TYPRowid=document.getElementById('TYPRowidz'+row);
  var TYPRowidValue=TYPRowid.value;
  var TYPSituation=document.getElementById('TYPSituationz'+row);
  var TYPSituationValue=TYPSituation.value;
  var TYPCode=document.getElementById('TYPCodez'+row);
  var TYPCodeValue=TYPCode.innerText;
  var TYPName=document.getElementById('TYPNamez'+row);
  var TYPNameValue=TYPName.innerText;
  var TYPDegree=document.getElementById('TYPDegreez'+row);
  var TYPDegreeValue=TYPDegree.innerText;
  var TYPEmergency=document.getElementById('TYPEmergencyz'+row);
  var TYPEmergencyValue=TYPEmergency.innerText;
  var TYPCreateTel=document.getElementById('TYPCreateTelz'+row);
  var TYPCreateTelValue=TYPCreateTel.value;
  var TYPPredictTime=document.getElementById('TYPPredictTimez'+row);
  var TYPPredictTimeValue=TYPPredictTime.value;
  var IPMLModule=document.getElementById('IPMLModulez'+row);
  var IPMLModuleValue=IPMLModule.value;
  var IPMLStatusDR=document.getElementById('IPMLStatusDRz'+row);
  var IPMLStatusDRDValue=IPMLStatusDR.value;
  var IPMLMenu=document.getElementById('IPMLMenuz'+row);
  var IPMLMenuValue=IPMLMenu.value;
  var IPMLStandby3=document.getElementById('IPMLStandby3z'+row);
  var IPMLStandby3Value=IPMLStandby3.value;
  //alert(IPMLStandby3Value);
  var IPMLDevelopUser=document.getElementById('IPMLDevelopUserz'+row);
  var IPMLDevelopUserValue=IPMLDevelopUser.value;
  var TYPStatus=document.getElementById('TYPStatusz'+row);
  var TYPStatusValue=TYPStatus.innerText;
  var TYPCreatUser=document.getElementById('TYPCreatUserz'+row);
  var TYPCreatUserValue=TYPCreatUser.innerText;
  var obj=document.getElementById('PmpRowid');
  obj.innerText=TYPRowidValue;
  var obj=document.getElementById('XQcode');
  obj.innerText=TYPCodeValue;
  var obj=document.getElementById('XQname');
  obj.value=TYPNameValue;
  var obj=document.getElementById('XQuser');
  obj.value=TYPCreatUserValue;
  var obj=document.getElementById('XQyanzhongchengdu');
  obj.value=TYPDegreeValue;
  var obj=document.getElementById('XQjingjichengdu');
  obj.value=TYPEmergencyValue;
  var obj=document.getElementById('XQneirong');
  obj.value="需求内容："+TYPSituationValue;
  var obj=document.getElementById('XQtel');
  obj.value=TYPCreateTelValue;
  var obj=document.getElementById('CRIPMLStandby3');
  obj.value="要求达到效果："+IPMLStandby3Value;
  obj.disabled=true;
  var obj=document.getElementById('PredictTime');
  obj.value=TYPPredictTimeValue+"工作日";
  var obj=document.getElementById('XQmokuai');
  obj.value=IPMLModuleValue;
  var VerStrmokuai=tkMakeServerCall("web.PMP.PMPImprovementList","mokuai",IPMLModuleValue);
  var obj=document.getElementById('XQzhuangtaiID');
  obj.value=IPMLStatusDRDValue;
  var obj=document.getElementById('XQzhuangtai');
  obj.value=TYPStatusValue;
  if(TYPStatusValue=="完成"){
	  var obj=document.getElementById("Communication");
	  obj.style.display = 'none';
	  var obj=document.getElementById("Update");
	  obj.style.display = 'none';
	  }
  var obj=document.getElementById('XQchuliguocheng');
  obj.value=t["6"];
  var obj=document.getElementById('XQcaidan');
  obj.value=IPMLMenuValue;
  var obj=document.getElementById('XQkaifa');
  obj.value=IPMLDevelopUserValue;
  var obj=document.getElementById("XQmokuaiID");
  obj.value=VerStrmokuai;
  var obj=document.getElementById("COMMUserList");
  obj.value="";
  var obj=document.getElementById("XCGCSID");
  obj.value="";
  var strvalue=TYPRowidValue+"^"+IPMLModuleValue+"^"+TYPStatusValue+"^"+IPMLDevelopUserValue+"^"+TYPPredictTimeValue+"工作日"+"^"+t["6"]+"^"+IPMLStatusDRDValue+"^"+VerStrmokuai+"^"+userId+"^"+"";
  var obj=document.getElementById("lingshi");
  obj.value=strvalue;
  var obj=document.getElementById('TYPAccessoryz'+row);
  if (obj){ obj.onclick=TYPAccessory_click;}
  var obj=document.getElementById('CHECKz'+row);
  if (obj){ obj.onclick=CHECK_click;}
  var obj=parent.frames[1].document.getElementById("str");
  obj.value=TYPRowidValue
  if(IPMLMenuValue!=""){
      var ListRowidd=tkMakeServerCall("web.PMP.PMPImprovementList","ListRowid",IPMLMenuValue);
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
}
function FrameEnterkeyCode()
{
	var e=window.event;
	switch (e.keyCode){
		//上下移动光标键
	case 38:
		var objtbl=window.document.getElementById('tPMPImprovementHand');
		if (iSeldRow==1) {break;}
		var objrow=objtbl.rows[iSeldRow-1];
		objrow.click();
		break;
	case 40:
		var objtbl=window.document.getElementById('tPMPImprovementHand');
		var rows=objtbl.rows.length-1;
		if (iSeldRow==rows) {break;}
		var objrow=objtbl.rows[iSeldRow+1];
		objrow.click();
		break;
	}
}
function Update_click()
{
	var obj=document.getElementById('PmpRowid');
    PmpRowidValue=obj.value;
    if(PmpRowidValue==""){
	    alert(t["7"]);
	    return;
       }
    var obj=document.getElementById("XCGCSID");
    var XCGCSIDValue=obj.value;
    var obj=document.getElementById('XQmokuai');
    XQmokuaiValue=obj.value;
    var obj=document.getElementById("XQmokuaiID");
    XQmokuaiIDValue=obj.value;
    var obj=document.getElementById('XQzhuangtai');
    XQzhuangtaiValue=obj.value;
    var obj=document.getElementById('XQkaifa');
    XQkaifaValue=obj.value;
    var obj=document.getElementById('PredictTime');
    PredictTimeValue=obj.value;
    var obj=document.getElementById('XQchuliguocheng');
    XQchuliguochengValue=obj.value;
    var obj=document.getElementById('XQzhuangtaiID');
    XQzhuangtaiIDValue= obj.value;
    
    var str=PmpRowidValue+"^"+XQmokuaiValue+"^"+XQzhuangtaiValue+"^"+XQkaifaValue+"^"+PredictTimeValue+"^"+XQchuliguochengValue+"^"+XQzhuangtaiIDValue+"^"+XQmokuaiIDValue+"^"+userId+"^"+XCGCSIDValue;
    //alert(str);
    var obj=document.getElementById("lingshi");
    strvalue=obj.value;
    if(strvalue==str){
	    alert(t["8"]);
	    return;
	    }
	if(strvalue!=str){
		var updatestr=tkMakeServerCall("web.PMP.PMPImprovementList","update",str);
		if(updatestr!="9"){
			alert(t[updatestr]);
		    return;
		}
		if(updatestr=="9"){
			//alert(t[updatestr])
			VerStr=str.split("^");
			VerStrstr=strvalue.split("^");
			if(VerStr[2]!=VerStrstr[2]){
				insertstr=tkMakeServerCall("web.PMP.PMPImprovementList","insert",str,"XQzhuangtaiValue");
				alert(t[insertstr]);
			    lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand";
	            location.href=lnk;
				}
			else {
				alert(t[updatestr])
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand";
	            location.href=lnk;
				}
			}
		}
	}
function Communication_click()
{
	var obj=document.getElementById('PmpRowid');
    PmpRowidValue=obj.value;
    if(PmpRowidValue==""){
	    alert(t["7"]);
	    return;
       }
	var tables = document.getElementsByTagName("table");
	trRep = tables[7];
	trRep.style.display = 'none';
	trRep1 = tables[8];
	trRep1.style.display = 'none';
	trRep2 = tables[9];
	trRep2.style.display = '';
	var obj=document.getElementById('PmpRowid');
    PmpRowidValue=obj.value;
    if(PmpRowidValue==""){
	    alert(t["7"]);
	    return;
       }
	}
function PMPModule_click()
{
	}
function PMPProduct_click()
{
	}
function YCTJ_click()
{
	var tables = document.getElementsByTagName("table");
    trRep1 = tables[3];
	trRep1.style.display = 'none';
	var obj=document.getElementById('YCTJ');
	obj.style.display = 'none';
	var obj=document.getElementById('XSTJ');
	obj.style.display = '';
	}
function SXTJ_click()
{
	var tables = document.getElementsByTagName("table");
    trRep1 = tables[3];
	trRep1.style.display = '';
	var obj=document.getElementById('XSTJ');
	obj.style.display = 'none';
	var obj=document.getElementById('YCTJ');
	obj.style.display = '';
	}
function OnChange()
{
	alert("1111")
	}
function COMMfanhui_click()
{
	var tables = document.getElementsByTagName("table");
	trRep = tables[7];
	trRep.style.display = '';
	trRep = tables[8];
	trRep.style.display = '';
	trRep = tables[9];
	trRep.style.display = 'none';
	}
function User_click()
{
	}
function COMMfujian_click()
{
	BrowseFolder("")
	var obj=document.getElementById('COMMfujianList');
	if(obj.value==""){
		obj.value=VerStrstr;
		}
	else{
		obj.value=obj.value+"||"+VerStrstr;
		}
	}
function COMMNew_click()
{
	var obj=document.getElementById('PmpRowid');
	PmpRowidvalue=obj.value;  
	if(PmpRowidvalue==""){
		alert(t["7"]);
		return;}
	var obj=document.getElementById("COMMUserrowid");
	COMMUserrowidvalue=obj.value;
	if(COMMUserrowidvalue==""){
		alert(t["11"]);
		return;
		}
	var obj=document.getElementById("COMMUserListrowid");
	COMMUserListrowidvalue=obj.value;
	if(COMMUserListrowidvalue==""){
		alert(t["12"]);
		return;
		}
	var obj=document.getElementById("COMMTime");
	COMMTimevalue=obj.value;
	var obj=document.getElementById("COMMDate1");
	COMMDate1value=obj.value;
	var obj=document.getElementById("COMMUseTime");
	COMMUseTimevalue=obj.value;
	var obj=document.getElementById("COMMfujianList");
	COMMfujianListvalue=obj.value;
	var obj=document.getElementById("COMMdel");
	COMMdelvalue=obj.value;
	var obj=document.getElementById("COMMmenu");
	COMMmenuvalue=obj.value;
	if(COMMmenuvalue==""){
		alert(t["13"]);
		return;
		}
	var obj=document.getElementById("XQzhuangtaiID");
	XQzhuangtaiIDvalue=obj.value;
	//alert(XQzhuangtaiIDvalue)
    var str=PmpRowidvalue+"&"+COMMUserrowidvalue+"&"+COMMUserListrowidvalue+"&"+COMMTimevalue+"&"+COMMDate1value+"&"+COMMUseTimevalue+"&"+COMMfujianListvalue+"&"+COMMdelvalue+"&"+COMMmenuvalue+"&"+userId+"&"+XQzhuangtaiIDvalue;
	if(COMMfujianListvalue!=""){
	//var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChangechang",COMMfujianListvalue);
	VerStr=COMMfujianListvalue.split("||");
	if(VerStr!="")
	{	
		for(i=0;i<=VerStr.length-1;i++)
		{  
			  VerStrName=VerStr[i].split("\\");
			  name=VerStrName[VerStrName.length-1];
			  //vers="D:\\dthealth\\app\\dthis\\fujian\\"
			  vers="\\\\172.18.10.57\\dhccpmp\\"
			  
			  //var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChange",vers);
			  //added by dongzt ----------------去除路径空格-----------
			  dirc=handleSpace(VerStrName);
			  alert(dirc);
			  LocalDirc=dirc+"\\"+name;
			  aa="copy "+LocalDirc+" "+vers+name;
			  //alert(aa)
			//added by dongzt --------------------------------------
			 // aa="copy "+VerStr[i]+" "+VerStrsinn+name;
			  Log1(aa) 
		}
	}
	}
	var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","fujianUpdate",str);
	alert(t[VerStrsinn])
	var tables = document.getElementsByTagName("table");
	trRep = tables[7];
	trRep.style.display = '';
	trRep = tables[8];
	trRep.style.display = '';
	trRep = tables[9];
	trRep.style.display = 'none';
	}
function TYPAccessory_click()
{
	var obj=document.getElementById('PmpRowid');
	if(obj.value!="")
	{
		rowid=obj.value;
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
			  //var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","Clearkg",VerStrstr);
			   //alert(dirc)
			   //var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChange",VerStrstr);
				aa="copy "+VerStrName[0]+name+" "+'"'+VerStrstr+'"';
				Log(aa)
				alert(t["wanc"]);
			}
		}
    }
    else {alert(t["1"])}
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
	ts.WriteLine("net use \\\\172.18.10.57\\ipc$ "+'"'+"123456"+'"'+" /user:"+'"'+"administrator"+'"');
    ts.WriteLine(url);
    ts.WriteLine("net use \\\\172.18.10.57\\ipc$ /delete");
    ts.WriteLine("del d:\\cmd.bat");
	ts.Close();
	OpenWindow2()
}
function Log1(url){ 
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
	OpenWindow3()
}
function OpenWindow2() {
	 s=new  ActiveXObject("WScript.Shell");    
     s.Run("d:\cmd.bat",0,true);
     alert(t["2"])
}
function OpenWindow3() {
	 s=new  ActiveXObject("WScript.Shell");    
     s.Run("d:\cmd.bat",0,true);
     //alert(t["2"])
}
function CHECK_click(){
	var obj=document.getElementById('PmpRowid');
	if(obj){
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand2";
	window.open(lnk, '需求明细', 'resizable=yes');
	}
}
function getadmdep1()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  XQmokuai_lookuphandler();
		}
}
function getadmdep2()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  PMPModule_lookuphandler();	  
		}
}
function getadmdep3()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  User_lookuphandler();
		}
	}
function getadmdep4()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  PMPProduct_lookuphandler();
		}
	}
function getadmdep5()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  XQzhuangtai_lookuphandler();
		}
	}
function getadmdep6()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  COMMClent1_lookuphandler();
		}
	}
function getadmdep7()
{
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	 COMMUuser_lookuphandler();
		}
	}
function getadmdep8()
{
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  XCGCS_lookuphandler();
		}
	}
function XQzhuangtaiSelect(str)
{
	var inci=str.split("^");
	var obj=document.getElementById("XQzhuangtai");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("XQzhuangtaiID");
	 if(obj){obj.value=inci[1]}
	}
function SelectXCGCS(str)
{
	var inci=str.split("^");
	var obj=document.getElementById("XCGCS");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("XCGCSID");
	 if(obj){obj.value=inci[1];}
	 var obj=document.getElementById("XQkaifa");
	 if(obj){obj.value=inci[0]}
	}
function XQmokuaiSelect(str)
{
	var inci=str.split("^");
	var obj=document.getElementById("XQmokuai");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("XQmokuaiID");
	 if(obj){obj.value=inci[1]}
	}
function COMMUuserSelect(str)
{
	var inci=str.split("^");
	var obj=document.getElementById("COMMUuser");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("COMMUserList");
	 if(obj.value!=""){obj.value=obj.value+","+inci[0]}
	 if (obj.value==""){obj.value=inci[0]}
	 var obj=document.getElementById("COMMUserListrowid");
	 if(obj.value!=""){obj.value=obj.value+","+inci[1]}
	 if (obj.value==""){obj.value=inci[1]}
	}
function COMMClentSelect(str)
{
	var inci=str.split("^");
	var obj=document.getElementById("COMMClent1");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("COMMClentList");
	 if(obj.value!=""){obj.value=obj.value+","+inci[0]}
	 if (obj.value==""){obj.value=inci[0]}
	 var obj=document.getElementById("COMMUserrowid");
	 if(obj.value!=""){obj.value=obj.value+","+inci[2]}
	 if (obj.value==""){obj.value=inci[2]
	 }
	}
document.body.onload = BodyLoadHandler;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
//用户新建需求等业务处理js  PMPImprovementListNew.js
var CurrentSel=0,TypeIndex,file,chushihuaStr,TYPRowidValue,XQStatusValue,selectrow,UpdateStr
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
function BodyLoadHandler()
{	
	var obj=document.getElementById('XQUpdate');
	obj.style.display = 'none';
	if (obj){ obj.onclick=XQUpdate_click;}
	var obj=document.getElementById('TJShow');
	obj.style.display = 'none';
	if (obj){ obj.onclick=TJShow_click;}
	var obj=document.getElementById("TJConcel");
	if (obj){ obj.onclick=TJConcel_click;}
	var obj=document.getElementById("TONGYI");
	obj.style.display = 'none';
	if (obj){ obj.onclick=TONGYI_click;}
	var obj=document.getElementById("BUTONGYI");
	obj.style.display = 'none';
	if (obj){ obj.onclick=BUTONGYI_click;}
	var obj=document.getElementById("XQZhiPaiRenYuan");
	obj.style.display = 'none';
	if (obj){ obj.onclick=XQZhiPaiRenYuan_click;}
	InitStatus()
	
}
function SelectRowHandler()	
{
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
  var XQZhiPaiRenYuan=document.getElementById("XQZhiPaiRenYuan");
  var obj=document.getElementById("TONGYI");
  obj.style.display = 'none';
  XQZhiPaiRenYuan.style.display = 'none';
  var obj=document.getElementById("BUTONGYI");
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
  var obj=document.getElementById('XQCreat');
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
  UpdateStr=""
  chushihuaStr="",TYPRowidValue=""
  lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand1";
  parent.frames[1].location.href=lnk;
  return;
	}		
  CurrentSel=selectrow;
  var row=selectrow;
  var obj=document.getElementById('XQUpdate');
  obj.style.display = 'none';
 // objtbl.rows[row].style.backgroundColor="red"
  var TYPRowid=document.getElementById('XQRowidz'+row);
  TYPRowidValue=TYPRowid.value;
  //alert(TYPRowidValue)
  var obj=parent.frames[1].document.getElementById("str");
  obj.value=TYPRowidValue
  //alert(obj.value)
  //lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand1&str="+TYPRowidValue;
  // parent.frames[1].location.href=lnk;
  var obj=document.getElementById("TONGYI");
  obj.style.display = '';
  var obj=document.getElementById("BUTONGYI");
  obj.style.display = '';
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
  
  var XQAdjunctFlag=document.getElementById('XQAdjunctFlagz'+row);
  if (XQAdjunctFlag){ XQAdjunctFlag.onclick=XQAdjunctFlag_click;}
  var XQMenu=document.getElementById('XQMenuz'+row);
  var XQMenuValue=XQMenu.innerText;
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
  var Carter=tkMakeServerCall("web.PMP.PMPImprovementListNew","Careat",TYPRowidValue);
  var obj=document.getElementById('XQCreat');
  obj.value=Carter;
  obj.disabled=true;
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
  UpdateStr=XQSituationValue+"||"+XQStandby3Value
  chushihuaStr=XQNameValue+"^"+XQMenuValue+"^"+CRType.value+"^"+XQEmergencyValue+"^"+XQAssignEngineerValue+"^"+XQSituationValue+"^"+XQDegreeValue+"^"+CRRepairType.value+"^"+VerStr+"^"+CRtel.value+"^"+XQGoutongjieguovalue+"^"+XQCodeValue+"^"+XQStandby3Value+"^"+XQStandby2value;
  //alert(chushihuaStr);
  var CRUpdate=document.getElementById('CRUpdate');
  var CRdelete=document.getElementById('CRdelete');
  var XQZhiPaiRenYuan=document.getElementById("XQZhiPaiRenYuan");
  XQZhiPaiRenYuan.style.display ='none';
  if((XQStatusValue=="保存")||(XQStatusValue=="提交")){
	  var obj=document.getElementById('XQUpdate');
	  obj.style.display = '';
	  var obj=document.getElementById('CQStandby3');
      obj.disabled = false;
      var obj=document.getElementById('CRSituation');
      obj.disabled = false;
	  }
  if(XQStatusValue=="保存"){
	  CRUpdate.style.display = '';
	  CRdelete.style.display = '';
	  XQZhiPaiRenYuan.style.display = 'none';
	  }
  else if((XQStatusValue!="审核1")&&(XQStatusValue!="提交")&&(XQStatusValue!="审核不通过")){
	  XQZhiPaiRenYuan.style.display = '';
	  }
	  else{
		  CRUpdate.style.display = 'none';
	      CRdelete.style.display = 'none';
		  
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
	 //alert("11");   
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
function CRNew_click(){
	
	}
function TONGYI_click(){
	if(TYPRowidValue==""){
		alert(t["Check"]);
	       return;}
	var VerStrstr=tkMakeServerCall("web.PMP.ImproventFindShenhe","QuanXianGuanLi");
	if(VerStrstr=="8"){
		var VerStr=tkMakeServerCall("web.PMP.PMPImprovementListNew","SaveShenHe",TYPRowidValue,userId);
	    alert(t[VerStr]);
	    lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByHospital";
        location.href=lnk;
		}
	else if(VerStrstr=="10"){
		var VerStr=tkMakeServerCall("web.PMP.PMPImprovementListNew","SaveShenHe1",TYPRowidValue,userId);
		if(VerStr=="wancheng1"){
			var myrtn=window.confirm(t[VerStr]);
			if(myrtn){
				var VerStrin=tkMakeServerCall("web.PMP.ImproventFindShenhe","cunID",TYPRowidValue,userId);
	            if (VerStrin==""){
	        	alert(t["kong"]);
		        return;
		                 }
				window.open('websys.default.csp?WEBSYS.TCOMPONENT=PMPCheckUser', '分配工程师', 'resizable=yes,height=350,width=650,left=200,top=200');
				}
			}
	    //alert(t[VerStr]);
	    lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByHospital";
        location.href=lnk;
		}
	else{
		alert(t["Masge"]);
		return;
		}
	
	}
function BUTONGYI_click(){
	if(TYPRowidValue==""){
		alert(t["Check"]);
	       return;}
	//alert(t["tishi"]);
	var VerStrin=tkMakeServerCall("web.PMP.ImproventFindShenhe","SelectbutongguoID",TYPRowidValue,userId);
	window.open('websys.default.csp?WEBSYS.TCOMPONENT=butongyizj', '审核不通过', 'resizable=yes,height=300,width=650,left=200,top=200');
	}
function XQZhiPaiRenYuan_click(){
	if(TYPRowidValue==""){
		alert(t["Check"]);
	       return;}
	var VerStrin=tkMakeServerCall("web.PMP.ImproventFindShenhe","cunID",TYPRowidValue,userId);
	if (VerStrin==""){
		alert(t["kong"]);
		return;
		}
	window.open('websys.default.csp?WEBSYS.TCOMPONENT=PMPCheckUser', '分配工程师', 'resizable=yes,height=350,width=650,left=200,top=200');
	}
function InitStatus()
{
     var objtbl=document.getElementById('tPMPImprovementFindByHospital');
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
          }    
     }
}
function XQUpdate_click(){
	if(TYPRowidValue==""){
		alert(t["Check"]);
	       return;}
	 else{
		 var obj=document.getElementById('CQStandby3');
         XQStandby3Str=obj.value;
         var obj=document.getElementById('CRSituation');
         CRSituationStr=obj.value;
         var ValueStr=CRSituationStr+"||"+XQStandby3Str
         if(ValueStr==UpdateStr){
	         alert(t["520"]);
	         return;
	         }
	      else{
		      var VerStrin=tkMakeServerCall("web.PMP.ImproventFindShenhe","UpdateXQ",TYPRowidValue,ValueStr);
		      if(VerStrin=="ful"){
			      alert(t[VerStrin]);
			      lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByHospital";
                  location.href=lnk;
			      }
			  else{
				  alert(t["full"]);
				  return;
				  }
		      }
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
			   //var VerStrsinn=tkMakeServerCall("web.PMP.PMPImprovementList","EscapingChange",VerStrstr);
			   aa="copy "+VerStrName[0]+" "+VerStrstr;
			   Log(aa);
			   alert(t["wanc"]);
			}
		}
    }
    }

document.body.onload = BodyLoadHandler;
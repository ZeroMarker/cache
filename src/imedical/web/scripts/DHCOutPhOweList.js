//DHCOutPhOweList
//门诊药房-欠药单管理
var bottomFrame;
var topFrame;
var tbl=document.getElementById("tDHCOutPhOweList");
var f=document.getElementById("fDHCOutPhDispAudit");
var evtName;
var doneInit=0;
var focusat=null;
var GInf;
var HospitalCode;
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var GStrCode=String.fromCharCode(1);
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var fyflagobj;
var BResetobj,BDispobj,BPrintobj,BReprintobj;
var printobj,dispobj,reprintobj;
var returnphobj,returnphitmobj;
var GPhl,GPhw,GPydr,GPyName,GFydr,GFyName,GPhwPos,ChkAllOweFlag,ChkOweFlag;
   GPhl=document.getElementById("GPhl").value
   GPhw=document.getElementById("GPhw").value
   GPydr=document.getElementById("GPydr").value
   GFydr=document.getElementById("GFydr").value
   GPhwPos=document.getElementById("GPhwPos").value
   var ctloc=document.getElementById("ctloc").value

   var method=document.getElementById('mGetLocPhl');
   if (method) {var encmeth=method.value} else {var encmeth=''};
   GPhl=cspRunServerMethod(encmeth,ctloc)
   GPydr=session['LOGON.USERID']
  
   var method=document.getElementById('mGetPhPerson');
   if (method) {var encmeth=method.value} else {var encmeth=''};
   GPydr=cspRunServerMethod(encmeth,GPydr)
   
   document.getElementById("GPhl").value= GPhl
   document.getElementById("GPydr").value= GPydr
  
   var method=document.getElementById('checkloc');
   if (method) {var encmeth=method.value} else {var encmeth=''};
   if (cspRunServerMethod(encmeth,'checkcy','',ctloc)=='0') {}
   
   var The_Time;  
   var cdateobj;

if(parent.name=='TRAK_main') {
		topFrame=parent.frames['DHCOutPhOweList'];
		bottomFrame=parent.frames['DHCOutPhOweListSub'];
	} else {
		//topFrame=parent.frames['TRAK_main'].frames['DHCOutPhOweList'];
		//bottomFrame=parent.frames['TRAK_main'].frames['DHCOutPhOweListSub'];
		
		topFrame=parent.frames['DHCOutPhOweList'];
		bottomFrame=parent.frames['DHCOutPhOweListSub'];
	}
	
var subtblobj=bottomFrame.document.getElementById('tDHCOutPhOweListSub');
var objtbl=document.getElementById('tDHCOutPhOweList');
var SubDoc=parent.frames['DHCOutPhOweListSub']
var getdesc=document.getElementById('getdesc');
if (getdesc) {var encmeth=getdesc.value} else {var encmeth=''};
 //if (cspRunServerMethod(encmeth,'GDesc','',GPhl,GPhw,GPydr,GFydr,GPhwPos)=='0'){}

 BPrintobj=document.getElementById("BPrint");
 BReprintobj=document.getElementById("BReprint");
 BPrintobj.style.visibility = "hidden";
// BReprintobj.style.visibility = "hidden";
 function checkcy(value)
 {
   var sstr=value.split("^")
   var cyflag=document.getElementById("cyflag");
   if (sstr[1]=="1"){cyflag.value="1"}
   	 
 }
 function OnKeyDownHandler(e)
 {
  var rownum=tbl.rows.length-1
  var key=websys_getKey(e);
  if (key==119){Find_click();}
  if (key==123){BAllPrint_click();}
 if (key==35) {
	  KeyDisp(); 
  var eSrc=tbl.rows[SelectedRow];
  var RowObj=getRow(eSrc);
  RowObj.className="RedColor"; 
 }	
 if (key==40) {
	 if (rownum>SelectedRow){ 
	 var retrow=SelectedRow+1;
	 var  fyflag=document.getElementById("TFyFlagz"+retrow).value
     if (fyflag!='OK'){
	 var eSrc=tbl.rows[retrow];
     var RowObj=getRow(eSrc);
	 RowObj.className="RowSelColor";
     }
     var  fyflag=document.getElementById("TFyFlagz"+SelectedRow).value
     if (fyflag!='OK'){
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
     }
	 GetSelectRow(retrow);}}
 if (key==38) {
	 if (SelectedRow>1){ 
	 var retrow=SelectedRow-1;
	 var  fyflag=document.getElementById("TFyFlagz"+retrow).value
     if (fyflag!='OK'){
	 var eSrc=tbl.rows[retrow];
     var RowObj=getRow(eSrc);
	 RowObj.className="RowSelColor";
     }
     var  fyflag=document.getElementById("TFyFlagz"+SelectedRow).value
     if (fyflag!='OK'){
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
     }
	 GetSelectRow(retrow);}}
 }

function GDesc(value)
{
  var ctlocdescobj=document.getElementById("PLocDesc");
  var phwdescobj=document.getElementById("PWinDesc");
  var pynameobj=document.getElementById("PPyName");
  var fynameobj=document.getElementById("PFyName");
  var sstr=value.split("^")
  ctlocdescobj.innerText=sstr[0];
  phwdescobj.innerText=sstr[1];
  pynameobj.innerText=sstr[2];
  fynameobj.innerText=sstr[3];
  var winposdesc=document.getElementById("PhwPosDesc");
  winposdesc.innerText=sstr[4];
  document.getElementById("fycode").value=sstr[5];
  document.getElementById("pycode").value=sstr[6];
  
}
function BodyLoadHandler() {
  DHCMZYF_setfocus('CPmiNo');
  
  var obj = document.getElementById("Special");
	if (obj){
		InitSpecial();
		obj.onchange=SpecialSelect;
	}
	
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  
  BPyobj=document.getElementById("BPy");
  if (BPyobj) BPyobj.onclick=Bpy_click;  
  BDispobj=document.getElementById("BDisp");
  if (BDispobj) BDispobj.onclick=BDisp_click;
  
  BPrintobj=document.getElementById("BPrint");
  if (BPrintobj) BPrintobj.onclick=Print_click;
  BReprintobj=document.getElementById("BReprint");
  if (BReprintobj) BReprintobj.onclick=Function("RePrint_click('3')"); 
 
  var BAPrintobj=document.getElementById("BAPrint");
  if (BAPrintobj) BAPrintobj.onclick=BAllPrint_click;
  var BStopobj=document.getElementById("BStop");
  if (BStopobj) BStopobj.onclick=BStop_click;
  var BContobj=document.getElementById("BCont");
  if (BContobj) BContobj.onclick=BCont_click;
   var BContobj=document.getElementById("CPrint");
  if (BContobj) BContobj.onclick=Check_click;
  BFindobj=document.getElementById("BRetrieve");
  findobj=document.getElementById("find");
  var cyflag=document.getElementById("cyflag");
  var PPyName=document.getElementById("PPyName");
  var PFyName=document.getElementById("PFyName");
  var BStopobj=document.getElementById("return");
  if (BStopobj) BStopobj.onclick=Breturn_click;;
  var RePrtRetobj=document.getElementById("Reprintret");
  if (RePrtRetobj) RePrtRetobj.onclick=Function("RePrint_click('4')"); ;;
  
  var obj=document.getElementById("CDisped")
  if (obj) obj.onclick=setRet;
  var obj=document.getElementById("CRetruened")
  if (obj) obj.onclick=setDisp;
	
  
  //如果需要自动打印时要加BCont_click
 if (tbl.rows.length==1)
 {
  //BCont_click()
 }
   GPhwPos=document.getElementById("GPhwPos").value
 
  if (BFindobj){
	   BFindobj.onclick=Find_click;
	
	   if (tbl.rows.length>1)
	   {
		   RowClick();
	       DHCMZYF_setfocus('BDisp');
	   }
	   else
	   { 
	     //Find_click()
	     var prt=""
 	     var flag=""
 	     var presc=""
 	    
	     var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhOweListSub&rPHL="+GPhl+"&rPRT="+prt+"&rFLAG="+flag+"&rPrescNo="+presc;
       	 bottomFrame.location.href=lnk;
	   }
	   
	   
	  }
	  
   tbl.onclick=RollBackColor;
 	var GetHospital=document.getElementById("GetHospital");
	if (GetHospital) {var encmeth=GetHospital.value} else {var encmeth=''};
	if (encmeth!="") {
		var HospitalStr=cspRunServerMethod(encmeth,"CurrentHospital");
		var bstr=HospitalStr.split("^");
		HospitalCode=bstr[0];
	}

  pmiobj=document.getElementById("CPmiNo");
  if (pmiobj) pmiobj.onkeypress=GetPmino;
  //if (pmiobj) pmiobj.onblur=GPmino;
  var obj=document.getElementById("CardNo");
  if (obj) obj.onkeypress=GetPatNoFrCard;

  prescobj=document.getElementById("CPrescNo");
  if (prescobj) prescobj.onkeypress=GetPrescInfo;
 // 
  var obj=document.getElementById("CBAH");
  if (obj) obj.onkeypress=MediNoObj;
  
  var obj=document.getElementById("CPyUser");
  if (obj) obj.onkeypress=GetDispInf;
  
  pnameobj=document.getElementById("CPatName");
  ctlocobj=document.getElementById("ctloc");
  useridobj=document.getElementById("userid");
  document.onkeydown=OnKeyDownHandler;
  var  CardTypeobj=document.getElementById("CGetCardType");
  if (CardTypeobj)   CardTypeobj.style.visibility = "hidden";
    
  var ReadCardobj=document.getElementById("BReadCard");
  if (ReadCardobj) ReadCardobj.onclick=ReadHFMagCard_Click;
  var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
    loadCardType();
    CardTypeDefine_OnChange();
    
    
 // var obj=document.getElementById('ld50884iCGetCardType');
  //    obj.style.visibility = "hidden";
 /*
    if (HospitalCode=="SCDXHXYY"){
    // if (tbl.rows.length==1){ BCont_click();}
       }

 if (HospitalCode=="BJZLYY"){
    DHCP_GetXMLConfig("InvPrintEncrypt","BJZLYYPYD");	 
 }
 if (HospitalCode=="BJDTYY"){
    DHCP_GetXMLConfig("InvPrintEncrypt","BJDTYYPYD");	 
 }
 if (HospitalCode=="SCDXHXYY"){
	  
    DHCP_GetXMLConfig("InvPrintEncrypt","DHCHXXYPrescNoPYD");
    // if (tbl.rows.length==1){ BCont_click();}	 
 }
*/


 //var  obj=document.getElementById("CPyUser");
 //if (obj) DHCMZYF_setfocus('CPyUser');
 //else
 //{ DHCMZYF_setfocus('CPmiNo');}


}


function SpecialSelect()
{
	var objspecid=document.getElementById("SpecialID");
	if(objspecid){
		var objspec=document.getElementById("Special");
		objspecid.value=objspec.selectedIndex;
		
	}
}

function InitSpecial()
{

	var obj=document.getElementById("Special");
	if (obj){
		obj.size=1; 
	 	obj.multiple=false;
	 	i=0
	 	var Ins=document.getElementById('getSpecialMark');
     	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
     	var flag=cspRunServerMethod(encmeth)
     	var Temp1=flag.split("^")
     	for (var i=0;i<Temp1.length;i++){
	     	
			Temp2=Temp1[i].split(String.fromCharCode(1))
			obj.options[i+1]=new Option(Temp2[1],Temp2[0]);
		} 
	 	
	}
	
	var obj=document.getElementById("Special");
	var objindex=document.getElementById("SpecialID");
	if (objindex) obj.selectedIndex=objindex.value;

	
}


function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;
	var prt=document.getElementById("TPrtz"+selectrow).value
	var prescno=document.getElementById("TPrescNoz"+selectrow).innerText
	var flagobj=document.getElementById("TFyFlagz"+selectrow).value
	
	var selobj=document.getElementById("TSelectz"+selectrow)
	if (selobj)
	{
		selobj.checked=!(selobj.checked)
	
	}
	
	var owedr=""
    var owedrobj=document.getElementById("TOwedrz"+selectrow)
    if (owedrobj) owedr=owedrobj.value
	
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhOweListSub&GPhl="+GPhl+"&pho="+owedr;
 	bottomFrame.location.href=lnk;
    DHCMZYF_setfocus('CPmiNo')


}
function GetDispInf()
{
	var key=websys_getKey(e);
	if (key==13) 
	   {
		var ctloc=document.getElementById('ctloc').value; 
		var usercode=document.getElementById('CPyUser').value;  
		var getmethod=document.getElementById('checkpycode');
        if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
        var retval=cspRunServerMethod(encmeth,usercode,ctloc)
        if (retval=='') {alert(t['NotDisp']);document.getElementById('CPyUser').value="";  return ;}
         Find_click();
	   }
	
	
}
function MediNoObj(){
	var key=websys_getKey(e);
	if (key==13) {
		var obj=document.getElementById('CBAH');
		if (obj.value!='') {
			var p1=obj.value
			var retno=GetNObyMedicare(p1);
			var rettmp=retno.split("^")
			if (rettmp[0]=="0"){
				var obj=document.getElementById('CPmiNo');
				obj.value=rettmp[1];
				Find_click();
			}
			else{
				alert(t['MNOErr'])
				var obj=document.getElementById('CBAH');
				obj.value=""
				DHCMZYF_setfocus('CBAH');
				
			}
		
		}
	}
}

function GetNObyMedicare(strMedicare){
	var PatNO
	PatNO=""
	var GetNObyMNoobj=document.getElementById('GetNObyMNo');
	if (GetNObyMNoobj) {var encmeth=GetNObyMNoobj.value} else {var encmeth=''};
	if (encmeth){
	PatNo=cspRunServerMethod(encmeth,strMedicare)} 

	return PatNo
}

//card type add by tang 20071122
function loadCardType(){
	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=document.getElementById("ReadCardTypeEncrypt").value;
		
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
		
	}
}

function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		var obj=document.getElementById("BReadCard");
		if (obj){
			obj.disabled=true;
		}	
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("BReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCMZYF_setfocus("CardNo");
	}else{
		DHCMZYF_setfocus("BReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}





function GetSelectRow(row)	{
	
	var selectrow=row;
	isSelected=1;
	SelectedRow = selectrow;
	DHCMZYF_setfocus('CPmiNo')
	var prt=document.getElementById("TPrtz"+selectrow).value
	var prescno=document.getElementById("TPrescNoz"+selectrow).innerText
	var flagobj=document.getElementById("TFyFlagz"+selectrow).innerText
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhOweListSub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+prescno;
 	bottomFrame.location.href=lnk;

}
function RollBackColor()
{
    SelectRowHandler();
   var  fyflag=document.getElementById("TFyFlagz"+SelectedRow).value
   if (tbl.rows.length>1){
	  for (var i=1;i<=tbl.rows.length-1;i++)
	  {
		  var  fyflag=document.getElementById("TFyFlagz"+i).value
		  var eSrc=tbl.rows[i];
          var RowObj=getRow(eSrc);
          if (i==SelectedRow){ RowObj.className="RowSelColor"; }
          else {if (fyflag=="OK"){RowObj.className="RedColor"; }
          else  { RowObj.className="OldBackColor"; }
          
		  }   }    
      
  	  var eSrc=tbl.rows[SelectedRow];
      var RowObj=getRow(eSrc);
      RowObj.className="RowSelColor";
}

     
}



function KeyDisp()
{
	//BDisp_click();
	
}

function GetPmiLen()
{var getmethod=document.getElementById('getpmilen');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var pmilen=cspRunServerMethod(encmeth)
 return pmilen 
} 
function GetPmino() {
 var key=websys_getKey(event);
 if (key!=13) {return ;}
 //Find_click();
 //return;
 
 var pmilen=GetPmiLen()
 
 if (key==13) {	
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){
	     DHCMZYF_setfocus('find'); return ;}
 	//if (plen>8){alert(t['01']);return;}
 	if (plen<pmilen){
	 for (i=1;i<=pmilen-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	 
	 Find_click();}
	 else
	{pmiobj.value=""
		}

 }
}
function CGetCardType_lookuphandler(e) {
	
	if (evtName=='CGetCardType') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url='websys.lookup.csp';
		url += "?ID=d50884iCGetCardType";
		url += "&CONTEXT=Kweb.DHCPhQueryTotal:QueryCardType";
		url += "&TLUJSF=GetDropPmino";
		var obj=document.getElementById('CPmiNo');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		websys_lu(url,1,'top=300,left=500,width=100,height=100');
		return websys_cancel();
	}
}
	var obj=document.getElementById('CGetCardType');
	if (obj) obj.onkeydown=CGetCardType_lookuphandler;
	var obj=document.getElementById('ld50884iCGetCardType');
	if (obj) obj.onclick=CGetCardType_lookuphandler;

function GetDropPmino(value)
{
  var val=value.split("^") 
  var pmiobj=document.getElementById("CPmiNo");
  var winid=document.getElementById("CGetCardType");
  winid.value=val[0]
  var patno=pmiobj.value
  var getmethod=document.getElementById('getpmifrcardType');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,patno,val[1]);
  pmiobj.value=retval;
  
  
 // var  CardTypeobj=document.getElementById("CGetCardType");
 //      CardTypeobj.style.visibility = "hidden";
  //var obj=document.getElementById('ld50428iCGetCardType');
  //    obj.style.visibility = "hidden";
  Find_click();      	  
}

function Reset_click()
{
  var stdate="" //document.getElementById("CDateSt").value;
  var enddate="" //document.getElementById("CDateEnd").value;
  var GPhl=document.getElementById("GPhl").value;
  var GPhw=document.getElementById("GPhw").value;
  var settime=document.getElementById("GStepTime").value
  var CPmiNo="00000000";
  var flag="0";	
  var pyflagobj=document.getElementById("CPrint")
  if (pyflagobj){
	  if (pyflagobj.checked){
		  flag="1"
	  }
	  
  }
  
  var obj=document.getElementById("CScreenFlag")
  var PScreen
  if (obj) PScreen=obj.checked;
  var scflag="0";
  if (PScreen==true){scflag="1";}
  var CPatName=""
  var obj=document.getElementById("CPatName")
  if (obj) CPatName=obj.value;
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhOweList&CDateSt="+stdate+"&CDateEnd="+enddate+"&GPhl="+GPhl+"&GPhw="+GPhw+"&CPmiNo="+CPmiNo+"&CPatName="+CPatName+"&GPydr="+GPydr+"&GFydr="+GFydr+"&GPhwPos="+GPhwPos+"&CPrint="+flag+"&GStepTime="+settime+"&CScreenFlag="+scflag;
  topFrame.location.href=lnk;
	var prt=""
 	var presc=""
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhOweListSub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+presc;
 	bottomFrame.location.href=lnk;
	 }
	 

function SetReprint(value)
{
}

function RePrint_click(flag)
{   

    var reprintflag=0
   	subtblobj=bottomFrame.document.getElementById('tDHCOutPhOweListSub');
    if (objtbl.rows.length==1) {alert("没有欠药单记录,不能打印");return 0;}
	var row = SelectedRow;

	if (row<1){alert("没有选中欠药单,不能打印");return 0;}

	//退药
    if (flag=="2")
    {
	    var owestatus=""
	    var owrretdateobj=document.getElementById("TOweretdatez"+row)
	    if (owrretdateobj)
	    {
		    var owestatus= owrretdateobj.innerText;
	    }
	    
	    if (trim(owestatus)=="")
	    {
		    alert("该欠药单没有生成退药单,不能打印退药单")
		    return;
	    }
	    
    }
    
    //退药重打
    if (flag=="4")
    {
	    var owestatus=""
	    var owrretdateobj=document.getElementById("TOweretdatez"+row)
	    if (owrretdateobj)
	    {
		    var owestatus= owrretdateobj.innerText;
	    }
	    
	    if (trim(owestatus)=="")
	    {
		    alert("该欠药单没有生成退药单,不能打印退药单")
		    return;
	    }
	    
	    var reprintflag="1"
	    
    }
    
    //配药打印
    if (flag=="1")
    {
	    var owestatus=""
	    var owrretdateobj=document.getElementById("TOweretdatez"+row)
	    if (owrretdateobj)
	    {
		    var owestatus=owrretdateobj.innerText;
	    }
	    if (trim(owestatus)!="")
	    {
		    alert("该欠药单已生成退药单,不能打印欠药单")
		    return;
	    }
	    
    }
    
    //配药重打

    if (flag=="3")
    {
	    var owestatus=""
	    var owrretdateobj=document.getElementById("TOweretdatez"+row)
	    if (owrretdateobj)
	    {
		    var owestatus=owrretdateobj.innerText;
	    }
	    if (trim(owestatus)!="")
	    {
		    alert("该欠药单已生成退药单,不能打印欠药单")
		    return;
	    }
	    
	    var reprintflag="1"
	    
    }

    
    phdrowid=document.getElementById("Tphdrowidz"+row).value

    
	oweflag=1  //欠药单打印标志
	if (ChkAllOweFlag==1) oweflag=2
	if (flag==3) oweflag=2 //重打欠药

	owerowid="" ;
	if (flag!="1"){
		var owerowid=document.getElementById("TOwedrz"+row).value
		}
	
	if (flag=="1"){
			
    	if (ChkOweFlag!=1) {return;}  ///配药时判断是否要打印欠药单
	}
	
    
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrintCom"+"&phdrowid="+phdrowid+"&oweflag="+oweflag+"&owerowid="+owerowid+"&reprintflag="+reprintflag
	parent.frames['DHCOutPhPrintCom'].window.document.location.href=lnk;  
	   
   	
}

function pyd(value)
{
}

function GCheck(value)
{
  var val=value.split("^") 
  var shdr=document.getElementById("CSHDR");
  shdr.value=val[1];
}

function ChkIsDisped(prescno,owedr)
{
	 var getmethod=document.getElementById('ChkIsDisped');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     retval=cspRunServerMethod(encmeth,prescno,owedr)
     return retval 
}

function Bpy_clickXH()
 {
	 var num,i,j,prt
	 SubDoc=parent.frames['DHCOutPhOweListSub']
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhOweListSub');
	 if (objtbl.rows.length==1) {alert(t['notblrowdisp']);return 0;}
  	 if (SelectedRow<1) {alert(t['noselectrowdisp']);return 0;}

	 var prt=document.getElementById("TPrtz"+SelectedRow).value
	 var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText
	 var pmino=document.getElementById("TPmiNoz"+SelectedRow).innerText
	 var patname=document.getElementById("TPatNamez"+SelectedRow).innerText
	 var sfdate=document.getElementById("TPrtDatez"+SelectedRow).innerText
	 var ctloc=document.getElementById("ctloc").value
	 var owedr="" ;
     var owedrobj=document.getElementById("TOwedrz"+SelectedRow)
     if (owedrobj) owedr=owedrobj.value
     
     var ret=ChkIsDisped(prescno,owedr);
     if (ret==1){
	     alert("该处方有配药单未发药,请先发药后再来确认欠药单!")
	     return;
     }

     var ret=InsertPhdisp(); 
	 if (ret!=0) {return;}
	 
     
	 var cyflag=document.getElementById("cyflag").value
	 
	 var printobj=document.getElementById("TPrintFlagz"+SelectedRow)
	 if(printobj) printobj.innerText="OK"
	 pmiobj=document.getElementById("CPmiNo");
	 pmiobj.value=""
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
         RowObj.className="RedColor"; 
         
	 setFocusCardNo();
	 
	 RePrint_click("1")
	     
 }
 
 
 
function BDisp_clickXH()
 {
	 
	 var num,i,j,prt
	 SubDoc=parent.frames['DHCOutPhOweListSub']
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhOweListSub');
	 if (objtbl.rows.length==0) {alert(t['nopatient']);return 0;}	 
  	 if (SelectedRow<1) {alert(t['noselectpatient']);return 0;}
	 var row = SelectedRow;
	 
     var usercode="",shdr="",pwin="",newwin="" 
	 var usercodeobj=document.getElementById("CPyUserCode")
	 if (usercodeobj) 
	 { 
	   usercode=document.getElementById("CPyUserCode").value;
	   var ret=CheckPyCode(usercode) 
       if (ret!="0") {alert(t['codeerror']);return; }
	 }
	 var prt=document.getElementById("TPrtz"+SelectedRow).value
	 var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText

     var owedr=""
     var owedrobj=document.getElementById("TOwedrz"+SelectedRow)
     if (owedrobj) owedr=owedrobj.value
     
     var pharowid="";
     var phdobj=document.getElementById("Tphdrowidz"+SelectedRow)
     var pharowid=phdobj.value;
     
     if (pharowid==""){
	     alert("配药没完成?请确认");
	     return;
     }
     
     var retval=Dispensing(prt,GPhl,GPydr,GPydr,prescno,shdr,pwin,newwin,usercode,pharowid)
     if (retval<0) {return;}
     
	 fyobj=topFrame.document.getElementById("TFyFlagz"+row)
	 fyobj.innerText="OK"
	 pmiobj=document.getElementById("CPmiNo");
	 pmiobj.value=""
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
     RowObj.className="RedColor";
	 
}

///发药过程执行   
function DispensingXH(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode,owedr)
{

     var getmethod=document.getElementById('updatepyd');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     retval=cspRunServerMethod(encmeth,prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode,"0",owedr)
     
     var cardnoobj=document.getElementById("CardNo");
     if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
     else { DHCMZYF_setfocus('CPmiNo');}
     
     //alert(retval)
     
     if (retval==-5)
     {
	     alert("该欠药单状态已处理,不能重复发药")
	     return -5;
     }
     
     
     if (retval==-27)
     {
	     alert("该欠药单状态已处理,不能重复发药")
	     return -5;
     }
     
     if (retval==-1)
     {
	     alert("该处方已作废,不能发药")
	     return -1;
     }
     if (retval==-7)
     {
	     alert("库存不足,不能发药,请核实")
	     return -7;
     } 
     
     if (retval<0)
     {
	     alert("发药失败,"+"错误代码: "+retval)
	     return -100;
     } 
     

     if (!(retval>0))
     {
	     alert("发药失败,"+"错误代码: "+retval)
	     return -200;
	     
     }
     
     
     return retval;
     
}


function InsertIntoPhd(CurrRow)
{	

	 var rownum,Rrow,prt,name,pmino,printflag,inv;
	 var patprt=document.getElementById("TPrtz"+CurrRow).value
	 var name=document.getElementById("TPatNamez"+CurrRow).innerText
	 var pmino=document.getElementById("TPmiNoz"+CurrRow).innerText
	 var printflag=document.getElementById("TPrintFlagz"+CurrRow).innerText
	 var prescno=document.getElementById("TPrescNoz"+CurrRow).innerText
	 var inv=document.getElementById("TPrtInvz"+CurrRow).innerText
	 var shdr=document.getElementById("CSHDR").value
	 var newwin="";
	 var payflag=0 ;
	 var action="A";     
	 var getmethod=document.getElementById('savedata');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     GFydr=GPydr
     var retval=0
     retval=cspRunServerMethod(encmeth,patprt,GPhl,GPhw,GPydr,GFydr,prescno,GPhwPos,shdr,newwin,RealOrdStr)
	 return retval
	
}
 
 
function Bpy_click()
{
	 if (objtbl.rows.length-1==0) {alert("没有病人信息"); setFocusCardNo(); return }
	 var ret=Dispensing(SelectedRow)     
}
 
 
function Dispensing(crow)
{
	
	 var SelectedRow=crow
	 
	 if (objtbl.rows.length-1==0) {alert("没有病人信息"); setFocusCardNo(); return -300; }
	 
	 
	 if (CheckDispQty()<0){return -199;}
	 
	 RealOrdStr=GetDispQtyString();  //欠药单处理  协和
	 var tmpordstr=RealOrdStr.split("&&") 
	 var chkord=tmpordstr[0] ;
	 ChkAllOweFlag=tmpordstr[1] ;  //是否全部欠药
	 ChkOweFlag=chkord;
	 
	 if (chkord==1)
	 {
		 	if (confirm("是否需要生成欠药单? 点击[确定]生成点击[取消]退出")==false)  
			{return  -198 ; } 
	 }
	 var owedr=""
     var owedrobj=document.getElementById("TOwedrz"+SelectedRow)
     if (owedrobj) owedr=owedrobj.value
	 RealOrdStr=RealOrdStr+"&&"+owedr
	 var retval=InsertIntoPhd(SelectedRow)
     if (retval>0)
     {
	     var phdrowid=retval ;
	 	 prtobj=topFrame.document.getElementById("TPrintFlagz"+SelectedRow)
	 	 if (prtobj) prtobj.innerText="OK"
	     fyobj=topFrame.document.getElementById("TFyFlagz"+SelectedRow)
		 if (fyobj) fyobj.innerText="OK"
		 var eSrc=tbl.rows[SelectedRow];
	     var RowObj=getRow(eSrc);
	     RowObj.className="RedColor";
	    
     }
     var cardnoobj=document.getElementById("CardNo");
     if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
     else { DHCMZYF_setfocus('CPmiNo');}
     if (retval==-5)
     {
	     alert("该欠药单状态已处理,不能重复发药")
	     return -5;
     }
     
     
     if (retval==-27)
     {
	     alert("该欠药单状态已处理,不能重复发药")
	     return -5;
     }
     
     if (retval==-1)
     {
	     alert("该处方已作废,不能发药")
	     return -1;
     }
     if (retval==-7)
     {
	     alert("库存不足,不能发药,请核实")
	     return -7;
     } 
     if (retval==-24)
     {
	     alert("库存不足,不能发药,请核实")
	     return -24;
     } 
     
     if (retval<0)
     {
	     alert("发药失败,"+"错误代码: "+retval)
	     return -100;
     } 
     

     if (!(retval>0))
     {
	     alert("发药失败,"+"错误代码: "+retval)
	     return -200;
	     
     }
     
     
     return retval;
     
}

 
function MRViewer_AfterPrint(src){
  var objdbConn = new ActiveXObject("ADODB.Connection");
  var strdsn = "Driver={SQL Server};SERVER=192.168.0.111;UID=sa;PWD=;DATABASE=fasd";
  objdbConn.Open(strdsn);

  for(var i=0;i<src.length;i++){
     var sql = "update FA_EmpSalary set Status = 1 where ID="+src[i]+"";
     objdbConn.Execute(sql); 
  }
  objrs.Close();     
  objdbConn.Close(); 
}

//获售点
function setFocusCardNo()
{
	 pmiobj=document.getElementById("CPmiNo");
	 pmiobj.value=""
	 var cardnoobj=document.getElementById("CardNo");
     if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
     else { DHCMZYF_setfocus('CPmiNo');}
}

///执行配药  
function InsertPhdisp()
{
     if (objtbl.rows.length==0) {alert(t['notblrowprint']);return 0;}
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhOweListSub');
	 var rownum,Rrow,prt,name,pmino,printflag,inv;
	 rownum=subtblobj.rows.length
	 Rrow=SelectedRow;
	 if (Rrow<1){alert(t['noselectrowprint']);return 0;}
	 var patprt=document.getElementById("TPrtz"+Rrow).value
	 
	 var prescno="";
	 var prescnoobj=document.getElementById("TPrescNoz"+Rrow)
	 if (prescnoobj)prescno=prescnoobj.innerText
	 if (prescno==""){"没有处方号,请检查界面中是否显示处方号!";return;}
     var shdr=document.getElementById("CSHDR").value
     
     var owedr=""
     var owedrobj=document.getElementById("TOwedrz"+Rrow)
     if (owedrobj) owedr=owedrobj.value
     
     var ordstr=GetDispQtyString()  //欠药单处理  协和
	 var tmpordstr=ordstr.split("&&") 
	 var chkord=tmpordstr[0] ;
	 ChkAllOweFlag=tmpordstr[1] ;  //是否全部欠药
	 ChkOweFlag=chkord
   
     if (chkord==1)
	 {
		 	if (confirm("是否需要生成欠药单? 点击[确定]生成点击[取消]退出")==false)  
			{return ; } 
		 
	 }
	 
	 var ordstr=ordstr+"&&"+owedr
	 
	 var getmethod=document.getElementById('print');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,patprt,GPhl,GPhw,GPydr,GFydr,prescno,GPhwPos,GPydr,ordstr)
  
      
     var cardnoobj=document.getElementById("CardNo");
     if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
     else { DHCMZYF_setfocus('CPmiNo');}
 
  
     if (retval==-1)
     {
	     alert("该欠药单已作废,不能配药")
	     return -1;
     }
     
     if (retval==-5)
     {
	 
	     alert("该欠药单状态已处理,不能重复配药")
	     return -5;
     }
     
     
     
     if (retval<0)
     {
	     alert("配药失败,"+"错误代码: "+retval)
	     return retval;
     } 
     
     if (retval>0)
     {   
         phdobj=document.getElementById("Tphdrowidz"+Rrow)
	     if (phdobj) phdobj.value=retval
	     
	     if (ChkAllOweFlag!=1){
		     BDisp_click();
	     }
	     
	     return 0;
     }
     

     if (!(retval>0))
     {
	     alert("配药失败,"+"错误代码: "+retval)
	     return -100;
	     
     }
     

     
}


 function Print_click()
 
 {
	 if (objtbl.rows.length==0) {alert(t['notblrowprint']);return 0;}
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhOweListSub');
	 var rownum,Rrow,prt,name,pmino,printflag,inv;
	 rownum=subtblobj.rows.length
	 Rrow=SelectedRow;
	 if (Rrow<1){alert(t['noselectrowprint']);return 0;}
	 var patprt=document.getElementById("TPrtz"+Rrow).value
	 var  pyuser=document.getElementById("CPyUser")
	 if (pyuser) var CPyUser=pyuser.value
	 var patname=document.getElementById("TPatNamez"+Rrow).innerText
	 var patno=document.getElementById("TPmiNoz"+Rrow).innerText
	 printflag=document.getElementById("TPrintFlagz"+Rrow).innerText
	 var prescno=document.getElementById("TPrescNoz"+Rrow).innerText
	 var patinv=document.getElementById("TPrtInvz"+Rrow).innerText
	 var patage=document.getElementById("TPerAgez"+Rrow).innerText
	 var patsex=document.getElementById("TPerSexz"+Rrow).innerText
	 var paticd=document.getElementById("TMRz"+Rrow).innerText
	 var patloc=document.getElementById("TPerLocz"+Rrow).innerText
     var presctype=document.getElementById("TPrescTypez"+Rrow).innerText
     var sfdate=document.getElementById("TPrtDatez"+Rrow).innerText
     var windesc=document.getElementById("TWinDescz"+Rrow).innerText
	 var patid=document.getElementById("TPatIDz"+Rrow).value
	 var jytype=document.getElementById("TJYTypez"+Rrow).innerText
	 var callcode=document.getElementById("TCallCodez"+Rrow).innerText
	 var patadd=document.getElementById("TPatAddz"+Rrow).value
	 var presctitle=document.getElementById("TPrescTitlez"+Rrow).value
	
	 var reprintflag=""
	 var fs=document.getElementById("TJSz"+Rrow).innerText 
	 //var getmethod=document.getElementById('print');
     //if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     //var retval=cspRunServerMethod(encmeth,patprt,GPhl,GPhw,GPydr,GFydr,prescno,GPhwPos,CPyUser)
     //if (retval<0) {alert("配药失败,错误代码: "+retval); window.location.reload();return 0;}
     //if (!(retval>0)) {alert("配药失败,错误代码: "+retval); window.location.reload();return 0;}
 
     //if (retval=="-1"){alert(t['haduse']);window.location.reload();return 0;}
	 //if (retval=="-2"){alert(t['haddisp']);window.location.reload();return 0;}

      var getmethod=document.getElementById('getpatientinf');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var retval=cspRunServerMethod(encmeth,prescno,patprt,GPhl)
      var sstr1=retval.split("^")
      var patname=sstr1[0];
      var patno=sstr1[1]
      var patinv=sstr1[3]
      var patprt=sstr1[4]
      var patpresc=sstr1[5]
      var patsex=sstr1[6]
      var patage=sstr1[7]
      var patloc=sstr1[8]
      var paticd=sstr1[9]
      var presctype=sstr1[10]
      var windesc=sstr1[11]
      
      var sfdate=sstr1[2]
      var patid=sstr1[12]
      var fs=sstr1[13]
      var jytype=sstr1[14]
      var callcode=sstr1[15]
      var patadd=sstr1[16]
      var presctitle=sstr1[17]
     
     
      var childtype=""
      var lyear=patage.split(t['year'])
      var persui=lyear[0]
      // patienname_"^"_papmino_"^"_printdatetime_"^"_prtcode_"^"_prt_"^"_prescno_"^"_papsex_"^"_perold_"^"_deplocdesc_"^"_mricd_"^"_presctype_"^"_phwdesc_"^"_patid_"^"_cffs_"^"_jytype
          if (persui=='') persui=0
          if (persui<15) childtype="1"
      


   
	 var printobj=document.getElementById("TPrintFlagz"+Rrow)
	     printobj.innerText="OK"
	 cyflag=document.getElementById('cyflag').value
	     
	  if (cyflag=="1") {
	    var printval=CYFreePrintPerOrd(patname,patno,patprt,prescno,patsex,patage,patloc,paticd,childtype,presctype,sfdate,windesc,patid,patinv,fs,jytype,patinv,callcode,patadd,presctitle,reprintflag)
    }
    else
    {    
        //var printval=FreePrintPerOrd(patname,patno,patprt,prescno,patsex,patage,patloc,paticd,childtype,presctype,sfdate,windesc,patid,patinv,callcode,patadd,presctitle,reprintflag)
             PrintPrescXY(prescno)
      }     
	
  
  
} 
function ginf(value)
{
 GInf=value	;
}
var RowN,Icditm;
function gicdnum(value)
{
	RowN=value;
}

function gicditm(value)
{  Icditm=value;
}

function GetPos(str1)
{
  var len1=str1.length 
  var i,str2
  var f=1 
     for (i=1;i<=len1;i++)
     {
	  str2=str1.substring(i-1,i);
	  if (str2==";"){f=f+1;}
     }
  return f
     
	     
}
function GInci(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("inci")
     fydrobj.value=sstr[1]
}

function Find_click()
{
 var myrow=tbl.rows.length;
 var rr;
 var MyFlag="0";
   if (tbl.rows.length>1)
     { for (rr=1;rr<=myrow-1;rr++){
 	 var fyflag=document.getElementById("TFyFlagz"+rr).value  
	   if (fyflag!="OK"){MyFlag="1"}
 	   }
      }  
  var flag="0";	
  var pyflagobj=document.getElementById("CPrint");
  if (pyflagobj){
	    if (pyflagobj.checked){flag="1";}
  }
 
  var stdate=document.getElementById("CDateSt").value;
  var enddate=document.getElementById("CDateEnd").value;
  var GPhl=document.getElementById("GPhl").value;
  var GPhw=document.getElementById("GPhw").value;
  var CPyUser=""
  var pyuser=document.getElementById("CPyUser")
  if (pyuser){ CPyUser=pyuser.value;  
  	if (CPyUser=='') {
	  	alert(t['nopyusercode']);
	  	return; 
	  }
  }
  var bahobj=document.getElementById("CBAH");
  var bah=""
  if (bahobj)  bah=bahobj.value
  
  var CPmiNo=document.getElementById("CPmiNo").value;
  /*
  if (CPmiNo=="")
     { if (bah!="") {MediNoObj();}  }
  
  var CPmiNo=document.getElementById("CPmiNo").value;   
   if (HospitalCode=="BJZLYY" && flag!="1")
      {	 
        if (CPmiNo==""){alert(t['NoPatNo']); return 0;}

	    var plen=CPmiNo.length
        var i
        var lszero=""
 	if (plen<8){ for (i=1;i<=8-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
    	 CPmiNo=lszero+CPmiNo
 	 }
      }
      */
  var settime=document.getElementById("GStepTime").value
  var CPatName=""
  var obj=document.getElementById("CPatName")
  if (obj) CPatName=obj.value
  var obj=document.getElementById("CScreenFlag")
  if (obj) var PScreen=obj.checked;
  var scflag="0";
  if (PScreen==true){scflag="1";}
  
  var obj=document.getElementById("SpecialID")
  if (obj) var SpecialID=obj.value;
  
  var CDisped=0
  var objCDisped=document.getElementById("CDisped")
  if (objCDisped) 
  {
	  if(objCDisped.checked==true)
	  { CDisped=1 }
	  
  }
  returnflag=0
  var objCRetruened=document.getElementById("CRetruened")
  if (objCRetruened) 
  {
	  if(objCRetruened.checked==true)
	  { returnflag=1 }
	  
  }
  
  var prescno="";
  prescobj=document.getElementById("CPrescNo");
  if (prescobj){
	 prescno= prescobj.value;
  }
  var inci=""
  var inci=document.getElementById("inci").value           //zhaozhiduan20130123  药品名
  var phdesc=document.getElementById("CPhDesc").value
 if (phdesc=="")
 {  
	  inci=""
 }

  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhOweList&CDateSt="+stdate+"&CDateEnd="+enddate+"&GPhl="+GPhl+"&GPhw="+GPhw+"&CPmiNo="+CPmiNo+"&CPatName="+CPatName+"&GPydr="+GPydr+"&GFydr="+GFydr+"&GPhwPos="+GPhwPos+"&CPrint="+flag+"&GStepTime="+settime+"&CScreenFlag="+scflag+"&CPyUser="+CPyUser+"&CDisped="+CDisped+"&ctloc="+ctloc+"&CRetruened="+returnflag+"&CPrescNo="+prescno+"&inci="+inci;
  topFrame.location.href=lnk;
  
  
  //if (tbl.rows.length>1) { clearTimeout(The_Time);}
}

function shdr_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50082iCSHName';
		url += '&CONTEXT=Kweb.DHCPhQueryTotal:QueryChFy';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=GCheck';
		var obj=document.getElementById('ctloc');
		if (obj) url += '&P1=' + websys_escape(obj.value);
		var obj=document.getElementById('userid');
		if (obj) url += '&P2=' + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('CSHName');
	if (obj) obj.onkeydown=shdr_lookuphandler;


 function RowClick()
 {
   	var prt=document.getElementById("TPrtz"+1).value
   	var prescno=document.getElementById("TPrescNoz"+1).innerText
   	var fyflag=document.getElementById("TFyFlagz"+1).value
   	var flag;
       if (fyflag=="OK"){flag="1";}
       else
        flag=""
 
 	var owedr=""
    var owedrobj=document.getElementById("TOwedrz"+1)
    if (owedrobj) owedr=owedrobj.value
	
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhOweListSub&GPhl="+GPhl+"&pho="+owedr;
 	
 	bottomFrame.location.href=lnk;
	SelectedRow = 1; 
 }


function BCont_click()
{

  cyflag=document.getElementById("cyflag").value
  var stdate=document.getElementById("CDateSt").value;
  var enddate=document.getElementById("CDateEnd").value;
  GPhl=document.getElementById("GPhl").value;
  GPhw=document.getElementById("GPhw").value;
   
  var getmethod=document.getElementById('GetAutoDispInfo');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  var retval=cspRunServerMethod(encmeth,stdate,enddate,GPhl,GPhw)

  var retarr=retval.split("^")
  var retnum=retarr[0]
  var retpid=retarr[1]
  if  (retnum==0) {return ;}
   
  var getmethod=document.getElementById('InsertPHDispAuto');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''}; 
  var retval=cspRunServerMethod(encmeth,cyflag,retpid,GPhl,GPhw,GPydr,GFydr)
  
  
  if (retval==""){return ; }
  
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrintCom"+"&phdrowid="+retval+"&cyflag="+cyflag
  parent.frames['DHCOutPhPrintCom'].window.document.location.href=lnk; 
  
  return;  

}
function BStop_click()
{
 clearTimeout(The_Time);

}

function FreePrintPat(tt,proc)
{
  var i;
  var tm=parseFloat(tt)+1;

  for (i=1;i<tm;i++){
      var getmethod=document.getElementById('getpatrow');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var retval=cspRunServerMethod(encmeth,proc,i)
      var sstr1=retval.split("^")
      var patname=sstr1[0];
      var patno=sstr1[1]
      var patinv=sstr1[3]
      var patprt=sstr1[4]
      var patpresc=sstr1[5]
      var patsex=sstr1[6]
      var patage=sstr1[7]
      var patloc=sstr1[8]
      var paticd=sstr1[9]
      var presctype=sstr1[10]
      var windesc=sstr1[11]
      
      var sfdate=sstr1[2]
      var patid=sstr1[12]
      var fs=sstr1[13]
      var jytype=sstr1[14]
      var callcode=sstr1[15]
      var patadd=sstr1[16]
      var presctitle=sstr1[17]
     
     
      var childtype=""
      var lyear=patage.split(t['year'])
      var persui=lyear[0]
      // patienname_"^"_papmino_"^"_printdatetime_"^"_prtcode_"^"_prt_"^"_prescno_"^"_papsex_"^"_perold_"^"_deplocdesc_"^"_mricd_"^"_presctype_"^"_phwdesc_"^"_patid_"^"_cffs_"^"_jytype
          if (persui=='') persui=0
          if (persui<15) childtype="1"
      
   cyflag=document.getElementById("cyflag").value
  
    if (cyflag=="1") {
	    var printval=CYFreePrintPerOrd(patname,patno,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,sfdate,windesc,patid,fs,jytype,patinv,callcode,patadd,presctitle,"")
    }
    else
    {    
      var printval=FreePrintPerOrd(patname,patpmi,patno,patpresc,patsex,patage,patloc,paticd,childtype,presctype,sfdate,windesc,patid,patinv,callcode,patadd,presctitle,"")
   
      }
    if (printval==0)
    {   
	    var getmethod=document.getElementById('print');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var retval=cspRunServerMethod(encmeth,prt,GPhl,GPhw,GPydr,GFydr,presc,GPhwPos)
    }
   }	
}

function Check_click()
{ 
 if (document.getElementById("CPrint").checked==true){clearTimeout(The_Time);}	

}

	   	   
function DHCMZYF_setfocus(objName) {
	window.setTimeout('DHCMZYF_setfocus2(\''+objName+'\')',300);
}

function DHCMZYF_setfocus2(objName) {
	var obj=document.getElementById(objName);
	if (obj) {
		try {obj.focus();obj.select();	} catch(e) {}  }
    }
function ReadHFMagCard_Click()
{
	
	var myCardTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	if (m_SelectCardTypeDR==""){
		var myrtn=DHCACC_GetAccInfo();
	}else{
		//var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR);
	}
	if (myrtn==-200) { alert("读卡失败,返回值:"+myrtn) ;return}
	var myary=myrtn.split("^");
	var rtn=myary[0];
   // alert("卡号?"+myary[1]);
	//alert(myary[5]);
	if (rtn=="-1") {alert(t['noreadcard']);return ;}
	else
	{	var obj=document.getElementById("CPmiNo");
			if (obj) obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			if (obj) obj.value=myary[1];
			
			Find_click();
	}
	/*
	switch (rtn){
		case "-1":
		  alert(t['22']);
		   break;
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			
			var obj=document.getElementById("CPmiNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			//ReLoadOPFoot();
			//Find_click();
			break;
		case "-200":
			alert(t['20']);
			break;
		case "-201":
			alert(t['21'])
			break;
		default:
			///alert("");
			Find_click();
	}*/
	

}

///打印程序专区


function FreePrintPerOrd(patname,patpmi,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,kjdate,windesc,patid,prtinv,callcode,patadd,presctitle,reprintflag)
{ 
    boxnum=0
	if (patprt!="")
	{
		var getmethod=document.getElementById('getbox');
	    if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	    var boxnum=cspRunServerMethod(encmeth,GPhl,patprt,patpresc)
	}
    var getmethod=document.getElementById('getperordrows');
    if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
   
   var pyname=document.getElementById('PPyName').innerText
    var retval=cspRunServerMethod(encmeth,GPhl,patprt,patpresc)
    
    
    var LStr=retval.split(GStrCode)
    var OrdRows=LStr.length
    var pagerow
    var page
    var crow
    var prow
    var ordrow
    var i
    var p
    var m
    var PrescBottomTxt="处方正文请勿写过此线"
    var PrescBottomLine="-----------------------"
    var PrescBottom=PrescBottomLine+PrescBottomTxt+PrescBottomLine
    var doctname=""
    var doctcode=""
    var jrflag=""
    var pc= new Array(new Array(),new Array());
   var totalmoney=0
 
       var lmseq=0
     var newseqno=""
     var SeqArray=new Array()
       
    	for (m=1;m<OrdRows+1;m++)
    	{
    	
    		var SOrd=LStr[m-1];
    	
       	var SStr=SOrd.split("^")
       	
       	pc[m]=new Array();
        pc[m][1]=m;
      // ypmc_"^"_phuomdesc_"^"_getnum_"^"_jlflag_"^"_instrdesc_"^"_phfragdesc_"^"_newprice_"^"_dispmoney_"^"_jrflag_"^"_notes
       	pc[m][2]=SStr[0];//药品名称
       	pc[m][3]=SStr[2]+SStr[1];//药品数量单位
       	pc[m][4]=SStr[7];//金额
       	pc[m][5]="用法: "+SStr[3]+" "+SStr[5]+" "+SStr[4]+" "+SStr[11]
       	pc[m][6]=""
       	//SStr[3];//用量
       	//pc[m][7]=SStr[4];//用法
       	//pc[m][8]=SStr[5];//频次
       	//pc[m][4]=SStr[6];//单价
       	//pc[m][5]=SStr[7];//金额
       
       	totalmoney=totalmoney+parseFloat(SStr[7]);//金额
       	jrflag=SStr[9]; //毒麻分类
       	doctname=SStr[9];
       	var seqno=SStr[10]   //seqno
       	
       	var seqstr=seqno.split(".")
        var seqint=seqstr[0]
        var seq=seqstr[1]
        var seqlength=seqstr.length
        if (seqlength<2)
         {
	         lmseq=lmseq+1;
	         newseqno=lmseq;
	         SeqArray[seqint]=lmseq;
	         }
	    else
	    {
		   newseqno=SeqArray[seqint]+"."+seq
 
	    }
 
       	
       	
       	pc[m][1]=newseqno;
       	
       	
   		totalmoney=totalmoney.toFixed(2);
   		
   		
    		
      }	
      	
   		if (childtype=="1")  
   		{
	   		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOutPrescXYChild"); 
   		}
   		else
   		{
	   		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOutPrescXY"); 
   		}
    
         var MyPara="";
      var MyList=""  
	    MyPara=MyPara+"PrescNo"+String.fromCharCode(2)+patpresc;
	    MyPara=MyPara+"^PatNo"+String.fromCharCode(2)+patpmi;
	    MyPara=MyPara+"^PatLoc"+String.fromCharCode(2)+patloc;
	    MyPara=MyPara+"^PrtInv"+String.fromCharCode(2)+prtinv;
	    MyPara=MyPara+"^fb"+String.fromCharCode(2)+presctype;
	    
	     MyPara=MyPara+"^PrescTitle"+String.fromCharCode(2)+presctitle;
	    	
	    MyPara=MyPara+"^PatName"+String.fromCharCode(2)+patname;
	    MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+patsex;
	    MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+patage;
	    MyPara=MyPara+"^PrescDate"+String.fromCharCode(2)+kjdate;
	    MyPara=MyPara+"^PyName"+String.fromCharCode(2)+pyname;
	    //if (jrflag=="1")  MyPara=MyPara+"^PatID"+String.fromCharCode(2)+patid;
	    MyPara=MyPara+"^PatICD"+String.fromCharCode(2)+paticd;
	    // MyPara=MyPara+"^windesc"+String.fromCharCode(2)+windesc+" "+boxnum;
	    MyPara=MyPara+"^DoctName"+String.fromCharCode(2)+doctname;
	    MyPara=MyPara+"^PatCall"+String.fromCharCode(2)+callcode;
	    MyPara=MyPara+"^PatAdd"+String.fromCharCode(2)+patadd;

	    //MyPara=MyPara+"^DoctCode"+String.fromCharCode(2)+doctcode;
	    
	    MyPara=MyPara+"^PrescMoney"+String.fromCharCode(2)+totalmoney.toFixed(2)+t['yuan'];
	    
	   var k=0;
	  
	      for (k=1;k<OrdRows+1;k++)
	      {
		     var l=0;
		     for (l=1;l<9;l++)
		      {
		        MyPara=MyPara+"^txt"+k+l+String.fromCharCode(2)+pc[k][l]; 
		      }
	      }
	      var titlerow=OrdRows+1
	             MyPara=MyPara+"^txt"+titlerow+1+String.fromCharCode(2)+PrescBottom

   
	  var myobj=document.getElementById("ClsBillPrint");
	    DHCP_PrintFun(myobj,MyPara,MyList);	
  	
    	
    

	    return 0;
    
	
}	 
	
function CYFreePrintPerOrd(patname,patpmi,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,kjdate,windesc,patid,fs,jytype,prtinv,callcode,patadd,presctitle,reprintflag)
{
  		
	//var getmethod=document.getElementById('getbox');
    //if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
   // var boxnum=cspRunServerMethod(encmeth,GPhl,patprt,patpresc)
    var getmethod=document.getElementById('getperordrows');
    if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,GPhl,patprt,patpresc)
    var LStr=retval.split(GStrCode)
    var OrdRows=LStr.length
    var i
    var totalmoney=0
    var doctname=""
    var doctcode=""
    var PrescYF=""
    var PrescPC=""
    
    var jrflag=""
    var pc= new Array(new Array(),new Array());
       for (i=0;i<OrdRows;i++)
       {
       	var SOrd=LStr[i];
       	var SStr=SOrd.split("^")
       	pc[i]=new Array();
       	/*pc[i][1]=SStr[0];//药品名称
       	pc[i][2]=SStr[1];//药品单位
       	pc[i][3]=SStr[2];//药品数量
       	pc[i][4]=SStr[3];//用量
       	pc[i][5]=SStr[4];//用法
       	pc[i][6]=SStr[5];//频次
       	pc[i][7]=SStr[6]//单价
       	pc[i][8]=SStr[7]//金额
       	*/
        pc[i][1]=SStr[0];
        var mfsl=parseFloat(SStr[2])/parseFloat(fs)
       	pc[i][2]=mfsl.toString()+SStr[1]
       	//parseFloat(SStr[2])/parseFloat(fs)+SStr[1];
       	pc[i][3]=SStr[9];

       	PrescYF=SStr[4]
       	PrescPC=SStr[5]
       	totalmoney=totalmoney+parseFloat(SStr[7]);//金额
       	//jrflag=SStr[8]; //毒麻分类
       	doctname=SStr[10];
       	
      }
      
        var yfpc="共"+fs+"剂"+" "+PrescYF+" "+PrescPC
  
      totalmoney=totalmoney.toFixed(2);
        var MyPara="";
      var MyList=""  
	    MyPara=MyPara+"PrescNo"+String.fromCharCode(2)+patpresc;
	    MyPara=MyPara+"^PatNo"+String.fromCharCode(2)+"*"+patpmi+"*";
	    MyPara=MyPara+"^PatLoc"+String.fromCharCode(2)+patloc;
    	MyPara=MyPara+"^PyName"+String.fromCharCode(2)+GUserCode;  		    	
	    MyPara=MyPara+"^PatName"+String.fromCharCode(2)+patname;
	    MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+patsex;
	    MyPara=MyPara+"^Doctor"+String.fromCharCode(2)+doctname;
	    MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+patage;
	    MyPara=MyPara+"^jytype"+String.fromCharCode(2)+jytype;
	    MyPara=MyPara+"^AdmDate"+String.fromCharCode(2)+kjdate;
	    MyPara=MyPara+"^PatICD"+String.fromCharCode(2)+paticd;
	    MyPara=MyPara+"^TotalMoney"+String.fromCharCode(2)+totalmoney.toFixed(2)+t['yuan'];
	    MyPara=MyPara+"^YFSM"+String.fromCharCode(2)+yfpc;
	    MyPara=MyPara+"^PatCall"+String.fromCharCode(2)+callcode;
	    MyPara=MyPara+"^PatAdd"+String.fromCharCode(2)+patadd;

	   var k=0;
	   
	      for (k=1;k<OrdRows+1;k++)
	      {
		    
		     var l=0;
		     for (l=1;l<4;l++)
		      {
		        MyPara=MyPara+"^txt"+k+l+String.fromCharCode(2)+pc[k-1][l]; 
		      }
	      }
	 	if (childtype=="1")  
   		{
	   		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOutPrescCYChild"); 
   		}
   		else
   		{
	   		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOutPrescCY"); 
   		}     
	     
	 var myobj=document.getElementById("ClsBillPrint");
	    DHCP_PrintFun(myobj,MyPara,MyList);	
	return 0;
    

}







function PrintPrescXY(prescno)
{
	    
	    var zf='[正方]'
	    var MyList="" ;
        var method=document.getElementById('getprintinfo');
	    if (method) {var encmeth=method.value} else {var encmeth=''};
	    var retval=cspRunServerMethod(encmeth,prescno)
	    var tmparr=retval.split("!!")
	    var patinfo=tmparr[0]
	    var patarr=tmparr[0].split("^")
	    //
	    var PatNo=patarr[0];
	    var PatientName=patarr[1];
	    var PatientSex=patarr[2];
	    var PatientAge=patarr[3];
        var ReclocDesc=patarr[11];
        var AdmDate=patarr[13] //就诊日期
        var PatH=patarr[5];
        var PyName=patarr[6];
        var FyName=patarr[7];
        var PatientCompany=patarr[12];  //工作单位
        var PatientMedicareNo=patarr[14]; //医保编号
        var PrescNo=patarr[15] 
        //
	    var diag=patarr[4];
	    alert(patarr)
	    var DiagnoseArray=diag.split(",")
	    var DiagnoseArrayLen=DiagnoseArray.length
	    var m=0;

	    var PrescTitle=""
	    var BillType=""
        var PoisonClass="";
        var MRNo="" 
        var TotalSum=0
                    
		var MyPara='PrescTitle'+String.fromCharCode(2)+PrescTitle;
	    MyPara=MyPara+'^zf'+String.fromCharCode(2)+zf;
	    MyPara=MyPara+'^PresType'+String.fromCharCode(2)+'处方笺';
	    MyPara=MyPara+'^PatientMedicareNo'+String.fromCharCode(2)+PatientMedicareNo;
	    MyPara=MyPara+'^PrescNo'+String.fromCharCode(2)+PrescNo;
	    MyPara=MyPara+'^MRNo'+String.fromCharCode(2)+MRNo;
	    MyPara=MyPara+'^PANo'+String.fromCharCode(2)+PatNo;
	    MyPara=MyPara+'^RecLoc'+String.fromCharCode(2)+ReclocDesc;
	    MyPara=MyPara+'^Name'+String.fromCharCode(2)+PatientName;
	    MyPara=MyPara+'^Sex'+String.fromCharCode(2)+PatientSex;
	    MyPara=MyPara+'^Age'+String.fromCharCode(2)+PatientAge;
	    MyPara=MyPara+'^Company'+String.fromCharCode(2)+PatientCompany;
	    MyPara=MyPara+'^AdmDate'+String.fromCharCode(2)+AdmDate;
	    MyPara=MyPara+'^PatH'+String.fromCharCode(2)+PatH;
	    MyPara=MyPara+'^PyName'+String.fromCharCode(2)+PyName;
	    MyPara=MyPara+'^FyName'+String.fromCharCode(2)+FyName;
	    

	   	for (var i=0;i<DiagnoseArrayLen;i++) {
			var m=m+1;
			MyPara=MyPara+'^Diagnose'+m+String.fromCharCode(2)+DiagnoseArray[i];
		}
	    
	    ////////////////////////////////////////////
	    var sum=0;
	    var medinfo=tmparr[1]
	    var medarr=medinfo.split("@")
	    var mlength=medarr.length
	    for (h=0;h<mlength;h++)
	     {
		       var medrow=medarr[h]
		       var rowarr=medrow.split("^")
		       var OrderName=rowarr[0]
		       var PackQty=rowarr[1]+rowarr[2]
		       var DoseQty=rowarr[3]
		       var Inst=rowarr[4]
		       var Freq=rowarr[5]
		       var Lc=rowarr[6]
		       var totalprice=rowarr[8]
		       var AdmDepDesc=rowarr[10]
		       var Ordremark=rowarr[11]
		       var Doctor=rowarr[12]
		       
		       var firstdesc=OrderName+' X '+" / "+PackQty +" 每次"+DoseQty+" "+Inst+" "+Freq+" "+Lc+" "+Ordremark;
		     
		       if (MyList=='') {
		         MyList = firstdesc;
	           }else{
    	        MyList = MyList + String.fromCharCode(2)+firstdesc;
			    }            

		   var sum=parseFloat(sum)+parseFloat(totalprice);  
	     }
	     
	     
	     var TotalSum=sum.toFixed(2)
	     MyPara=MyPara+'^Sum'+String.fromCharCode(2)+TotalSum+'元';
	     MyPara=MyPara+'^AdmDep'+String.fromCharCode(2)+AdmDepDesc;
	     MyPara=MyPara+'^UserAddName'+String.fromCharCode(2)+Doctor;
	     
	     
	     DHCP_GetXMLConfig("InvPrintEncrypt","DHCOutPrescXYPrt");
	     var myobj=document.getElementById("ClsBillPrint"); 
         DHCP_PrintFun(myobj,MyPara,MyList);
	   
   	
}

///打印程序专区

///检验配药数量是否合法
function CheckDispQty()
{
	var warnflag="";
	var retValue=0
	subtblobj=bottomFrame.document.getElementById('tDHCOutPhOweListSub');
	if (subtblobj.rows.length==1) {return 0;}
    for (var i=1;i<=subtblobj.rows.length-1;i++)
    { 
         var realqty=0      
         
         var  realqtyobj=bottomFrame.document.getElementById("TRealQtyz"+i)
         if (realqtyobj)
         {
	         realqty=trim(realqtyobj.value);
         }
         
         else 
         {
	         retValue=-1
	         alert("请将TRealQty列隐藏去掉");
	         break;
         }
         
         if (realqty!=0) {
         
		         if (!(realqty>0))
		         {   
			         retValue=-1
			         alert("第"+i+"行数量填写有误先更正")
			         break;
			         
		         }
         }
         
         if (realqty!=parseInt(realqty))
         {
	         retValue=-1
	         alert("第"+i+"行数量填写有误先更正")
	         break;
         }
         
         
         var  qtyobj=bottomFrame.document.getElementById("TPhQtyz"+i)
         if (qtyobj) 
         {
	         qty=qtyobj.innerText;
         }
         else
         {
	          retValue=-1;
	          alert("请将TPhQty列隐藏去掉");
	          break;
         }
         if (realqty>parseInt(qty)){
	          retValue=-1;
	          alert("实配数量>医嘱数量 先更正");
	          break;
         }
	     //发药前添加提示yunhaibao20160301
	     var  orditmobj=bottomFrame.document.getElementById("TOrditmz"+i);
	     if(orditmobj){
		     var oeori= orditmobj.value
		     var ifstop=tkMakeServerCall("web.DHCOutPhOweList","IfDispWarn",oeori,realqty)
		     if ((warnflag=="")&&(ifstop=="-1")){
			 	if (confirm("本次发药存在已停医嘱,是否继续?")){
				 	
				}
				else{
					retValue=-1;
					break;				
				}
				warnflag="1"
			 }
	     }


    }
    
   
    return retValue; 
    
    
}


///获取医嘱实发数量字符串
///Output:是否需要欠药+"&&"+是否全部欠药+"&&"+获到每个医嘱ID+"^"+实发数量
///
function GetDispQtyString()
{
	var chkflag=0,allowe=1
	var retString=0
	subtblobj=bottomFrame.document.getElementById('tDHCOutPhOweListSub');
	if (subtblobj.rows.length==1) {return 0;}
    for (var i=1;i<=subtblobj.rows.length-1;i++)
    { 
         var realqty=0;         
         var  qtyobj=bottomFrame.document.getElementById("TPhQtyz"+i)
         if (qtyobj) 
         {
	         qty=qtyobj.innerText;
	         realqty=qty;
         }
         
         var  realqtyobj=bottomFrame.document.getElementById("TRealQtyz"+i)
         if (realqtyobj)
         {
	         realqty=realqtyobj.value;
         }
         unit=""
         var  unitobj=bottomFrame.document.getElementById("TUnitz"+i)
         if (unitobj)
         {
	         unit=unitobj.value
         }
         
         if (realqty!=qty) {var chkflag=1}
         if (realqty!=0) {allowe=0 }         
	     var  itmobj=bottomFrame.document.getElementById("TOrditmz"+i)
	     if (itmobj)
	     {
		     oeori=itmobj.value;

		     var tmpstr=oeori+"^"+realqty+"^"+qty+"^"+unit
		     if (retString==0)
		     {
			     retString=tmpstr ;
		     }
		     else
		     {
			     retString=retString+"!!"+tmpstr ;
		     }
	 
	     }


    }
    retString=chkflag+"&&"+allowe+"&&"+retString ;
    
    return retString; 
    
    
}

function Breturn_click()
{
	 var num,i,j,prt
	 SubDoc=parent.frames['DHCOutPhOweListSub']
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhOweListSub');
	 if (objtbl.rows.length-1==0) {alert("没有病人信息!");return 0;}	 
  	 if (SelectedRow<1) {alert("没有选中数据!");return 0;}
	 var row = SelectedRow;
	 
     var usercode="",shdr="",pwin="",newwin="" 
	 var usercodeobj=document.getElementById("CPyUserCode")
	 if (usercodeobj) 
	 { 
	   usercode=document.getElementById("CPyUserCode").value;
	   var ret=CheckPyCode(usercode) 
       if (ret!="0") {alert(t['codeerror']);return; }
	 }
	 
	 var prt=document.getElementById("TPrtz"+SelectedRow).value
	 var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText
     var owedr=""
     var owedrobj=document.getElementById("TOwedrz"+SelectedRow)
     if (owedrobj) owedr=owedrobj.value     
     var retval=ExcReturn(GPydr,prescno,owedr)   
     if (retval<0) {return;}     
	 fyobj=topFrame.document.getElementById("TFyFlagz"+row)
	 fyobj.innerText="OK"
	 pmiobj=document.getElementById("CPmiNo");
	 pmiobj.value=""
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
     RowObj.className="RedColor";
     alert("退药成功,请到收费处退费!");     
     WriteDate(row);
     RePrint_click('2');
     
 
     	
}

function ExcReturn(GPydr,prescno,owedr)
{
	 var getmethod=document.getElementById('excret');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     retval=cspRunServerMethod(encmeth,GPydr,prescno,owedr)
     
     
     var cardnoobj=document.getElementById("CardNo");
     if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
     else { DHCMZYF_setfocus('CPmiNo');}
     
     //alert(retval)
     
     


     if (retval==-1)
     {
	    
	     alert("该欠药单状态已处理,不能退药")
	     return -1;
     }
     
     if (retval==-2)
     {
	     alert("该欠药单状态已处理,不能重复退药")
	     return -2;
     }
     if (retval==-4){
	     alert("该处方还未发药,请取消配药单,不能执行退药")
	     return -4;
     }
     
     if (retval<0)
     {
	     alert("退药失败:"+retval)
	     return retval;
     }
     
     return 0
	
	
}


function WriteDate(row)
{
	 var dateobj=new Date();
	 var sep="-";
	 var day=dateobj.getDate();
	 var mon=dateobj.getMonth()+1;
	 if (mon<10) mon="0"+mon ;
	 var year=dateobj.getFullYear();
     dateobj=topFrame.document.getElementById("TOweretdatez"+row)
     dateobj.innerText=year+sep+mon+sep+day;
     dateobj=topFrame.document.getElementById("TOweretuserz"+row)
     dateobj.innerText=session['LOGON.USERNAME']
}


 ///回车处方号
function GetPrescInfo()
{
  var key=websys_getKey(e);
  if (key!=13) {return;}
  var prescno=""
  prescobj=document.getElementById("CPrescNo");
  if (prescobj)
  {
	 prescno= prescobj.value;
  }
  
   Find_click();
   prescobj.value="";
}

///回车卡号
function GetPatNoFrCard()
{
	  var key=websys_getKey(event);
	  if (key!=13) {return;}
	  var prescno=""
	  var card=""
	  cardobj=document.getElementById("CardNo");
	  if (cardobj)
	  {
		 card= cardobj.value;
	  }
	  
	  lscard=card;
	  cardlen=card.length
      if (m_CardNoLength>cardlen){
	      var lszero="";
		  for (i=1;i<=m_CardNoLength-cardlen;i++)
	  	  {
		 	 lszero=lszero+"0"  
	      }
	      var lscard=lszero+card;
      }
      
	  var getmethod=document.getElementById('getpatnofrcard');
      if (getmethod) {var encmeth=getmethod.value;} else {var encmeth=''};
      var patno=cspRunServerMethod(encmeth,lscard)
      var patnoobj=document.getElementById('CPmiNo');
      if (patnoobj)
      {
	      patnoobj.value=patno;
      }
    
	  Find_click();
	 // patnoobj.value="";
	  cardobj.value="";

}

////该配药界面统一用这个设置默认焦点不要乱写了将来要做配置
////Liang Qiang
function setDefaultfocus()
{
	 DHCMZYF_setfocus('CReadCard')
}


//互斥check 20141219 liangqiang
function setRet()
{
	var obj=document.getElementById("CRetruened");
	if (obj.checked) {
		   obj.checked=false;
		}
}
//互斥check 20141219 liangqiang
function setDisp()
{
	var obj=document.getElementById("CDisped");
	if (obj.checked) {
		   obj.checked=false;
		}
}


document.body.onload = BodyLoadHandler;


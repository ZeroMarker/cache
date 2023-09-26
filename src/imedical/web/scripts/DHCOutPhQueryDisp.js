//DHCOutPhQueryDisp
//门诊药房-发药查询
var bottomFrame;
var topFrame;
var tblobj=document.getElementById("tDHCOutPhQueryDisp");
var f=document.getElementById("fDHCOutPhQueryDisp");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj,useridobj;
var BResetobj,BDispobj,BPrintobj,BReprintobj;
var printobj,dispobj,reprintobj;
var returnphobj,returnphitmobj;
var fy=document.getElementById("DispFlag");
var cy1,cy2,cy3,cy4,cy5,cy6,cy7,cy8,cy9,cy10,cy11,cy12,cy13,cy14,cy15,cy16,cy17,cy18,cy19,cy20,cy21,cy22,cy23,cy24,cy25,cy26,cy27,cy28=""
var cy = new Array();
var cy1= new Array();
var cy2= new Array();
var bz= new Array();
var zd= new Array();
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var DiagnoseArray=new Array();
var cjg=new Array();
var ctloc=document.getElementById("ctloc").value
var method=document.getElementById('checkloc');
    if (method) {var encmeth=method.value} else {var encmeth=''};
    if (cspRunServerMethod(encmeth,'checkcy','',ctloc)=='0') {}
var FYCheck
var GLCheck
var WFYCheck
var disp=document.getElementById("DispFlag")
var undisp=document.getElementById("UnDispFlag")
var ypwf=document.getElementById("CYPWF")

    FYCheck=disp.value;
 // fy.checked=true
var GFyFlag;
var flag=document.getElementById("FyFlag")
    if (flag.value=="1"){disp.checked=true;GFyFlag="1";}
    if (flag.value=="2"){undisp.checked=true;GFyFlag="2";}
    if (flag.value==""){disp.checked=true;GFyFlag="1";}
    if (flag.value=="0"){if (ypwf) ypwf.checked=true;GFyFlag="0";}
var flag=document.getElementById("glflag")
var man=document.getElementById("ChMan")
 if (flag.value==1){man.checked=true}
   else
   {man.checked=false;}
   
  // GFyFlag="1"
 	if(parent.name=='TRAK_main') {
		topFrame=parent.frames['DHCOutPatienQueryDisp'];
		bottomFrame=parent.frames['DHCOutPatienQueryDispSub'];
	} else {
		topFrame=parent.frames['TRAK_main'].frames['DHCOutPatienQueryDisp'];
		bottomFrame=parent.frames['TRAK_main'].frames['DHCOutPatienQueryDispSub'];
	}
	
var subtblobj=bottomFrame.document.getElementById('tDHCOutPhQueryDispSub');
function checkcy(value)
 {
   var sstr=value.split("^")
   var cyflag=document.getElementById("cyflag");
   if (sstr[1]=="1"){cyflag.value="1"}
   	 
 }


function BodyLoadHandler() {
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  BRetrieveobj=document.getElementById("BRetrieve");
   if (BRetrieveobj) BRetrieveobj.onclick=Retrieve_click;
  var bexport=document.getElementById("BExport");
  if (bexport) bexport.onclick=Export_click;
   var pmino=document.getElementById("CPmiNo");
   if (pmino) pmino.onkeydown=GetPmino;
    var obj=document.getElementById("DispFlag");
	if (obj) obj.onclick=GetChFy;
	var obj=document.getElementById("UnDispFlag");
	if (obj) obj.onclick=GetChRet; 
	var obj=document.getElementById("CYPWF");
	if (obj) obj.onclick=GetChYPWF; 
	var obj=document.getElementById("BPrescPrint");
	if (obj) obj.onclick=PrintPresc; 
	var obj=document.getElementById("CPhDesc");
	if (obj) obj.onkeydown=popCPhDesc; 
  ctlocobj=document.getElementById("ctloc");
 
   if (BRetrieveobj){
	   
	   BRetrieveobj.onclick=Retrieve_click;
	   if (tbl.rows.length>1){RowClick();}
	   else
	   { var phd=""
 	     var flag=""
 	     var ctloc=ctlocobj.value;
 	     var prescno=""
 	     var PrtID=""
	     var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispSub&rPhd="+phd+"&FyFlag="+GFyFlag+"&rCtloc="+ctloc+"&rPrescNo="+prescno+"&rPrt="+PrtID;
         bottomFrame.location.href=lnk;
	   }
	  }
  var ReadCardobj=document.getElementById("CReadCard");
  if (ReadCardobj) ReadCardobj.onclick= ReadHFMagCard_Click;
 var cyflag=document.getElementById("cyflag");
  useridobj=document.getElementById("userid");

 	var ctloc=document.getElementById("ctloc").value;
 	var userid=document.getElementById("userid").value;
 	var tmpPydr=document.getElementById("CPydr").value;
 	var tmpFydr=document.getElementById("CFydr").value;
 	combo_FyDR=dhtmlXComboFromStr("CFyName","");
 	combo_PyDR=dhtmlXComboFromStr("CPyName","");
	combo_FyDR.enableFilteringMode(true);
	combo_PyDR.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getry');
	var DeptStr=cspRunServerMethod(encmeth,ctloc,userid)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_PyDR.addOption(Arr);
	combo_PyDR.setComboValue(tmpPydr)
	combo_FyDR.addOption(Arr);
	combo_FyDR.setComboValue(tmpFydr)
 var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	
    loadCardType();
    CardTypeDefine_OnChange();
    }
var ReadCardobj=document.getElementById("CReadCard");
if (ReadCardobj) {DHCMZYF_setfocus('CReadCard');}
else {
 DHCMZYF_setfocus('CPmiNo');}

 var obj=document.getElementById("BPrint");
 if (obj) obj.onclick=PrintPYD;
 var obj=document.getElementById("BSelect");
 if (obj) obj.onclick=SelectAll;
 
 document.onkeydown=OnKeyDownHandler;

}
function OnKeyDownHandler(e){
  var key=websys_getKey(e);
  if (key==115){ReadHFMagCard_Click();}	//F4 
}
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
		var obj=document.getElementById("CReadCard");
		if (obj){
			obj.disabled=true;
		}	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("CReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
	//Set Focus
	
		DHCMZYF_setfocus("CReadCard");

	
	m_CardNoLength=myary[17];
	
}



function GetChFy()
{
   var fy=document.getElementById("DispFlag");
   var ret=document.getElementById("UnDispFlag");
   var yp=document.getElementById("CYPWF");
   if (fy.checked==true){ret.checked=false;}
    if (fy.checked==true){yp.checked=false;}
   if (fy.checked==true) GFyFlag="1"
}
function GetChRet()
{
   var fy=document.getElementById("DispFlag");
   var ret=document.getElementById("UnDispFlag");
   var yp=document.getElementById("CYPWF");
   if (ret.checked==true){fy.checked=false;}
   if (ret.checked==true){yp.checked=false;}
   if (ret.checked==true) GFyFlag="2" 
}
function GetChYPWF()
{
   var fy=document.getElementById("DispFlag");
   var ret=document.getElementById("UnDispFlag");
   var yp=document.getElementById("CYPWF");
   if (yp.checked==true){fy.checked=false;}
   if (yp.checked==true){ret.checked=false;}
   if (yp.checked==true) GFyFlag="0" 
}

function PrintPresc()
{
 var cyflag=document.getElementById("cyflag");
 var glflag=document.getElementById("ChMan");
 var dispflag=document.getElementById("DispFlag");
 if (cyflag.value==1&glflag.checked==true&dispflag.checked==true&SelectedRow>0)
   {
	 	   var adm=document.getElementById("TAdmz"+SelectedRow).value
	   var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText 
	   if (adm==""){ return;}
	  var MRDiagnos=document.getElementById("TMRz"+SelectedRow).value
     // alert(MRDiagnos);return;
      var method=document.getElementById('getinfo');
      if (method) {var encmeth=method.value} else {var encmeth=''};
      var retval=cspRunServerMethod(encmeth,adm,prescno)
      var str1=retval.split("^");
	       hospitalcode=str1[0];
				     PapmiNo=str1[1]
			    	 presc=str1[2]
				     pname=str1[3]
			    	 sex=str1[4]
				     age=str1[5]
			    	 GovernCardNo=str1[6]
			    	 OEORIOrdDept=str1[7]
				     PatientComAdd=str1[8]
				     PatientName=str1[9]
				     DurationDesc=str1[10]
				     PHCINDesc=str1[11]
				     OEORIDoctor=str1[12]
				     je5=str1[13]
				     info1=str1[14]
				     cydate=str1[15]
				     qyks=str1[16]
				     lyq=str1[17]
				     DurationFactor=str1[18]
				     je6=str1[19]
				     lyqk=str1[20]
				     cydate1=cydate.split("-")
				     cydate2=cydate1[0]+"年"+cydate1[1]+"月"+cydate1[2]+"日"
				     str2=info1.split("|")
				     MRD=MRDiagnos.split(";")
				     lyqk=lyq
				     je5="药费 "+je5+" 元"
				     je6=je6+"/剂"		     
				     for (k=0;k<32;k++)
				     {
				     	cy2[k]=""
				     	bz[k]=""
				     	zd[k]=""
				      cjg[k]=""
				     	}
				     
				      for (k = 0; k < str2.length-1; k++)
                     {
                     	 cy[k]=str2[k]
                     	 cy1[k]=cy[k].split("%")
                     	 cjg[k]=cy1[k][1]
                     	 cy2[k]=cy1[k][0]
                     	 bz[k]=cy1[k][2]
                     	
                     }
             var j=0
              for (k = 0; k < MRD.length; k++)
                     {
	                     j=j+1;
                      	var len=MRD[k].length
                     	if (len>7){
	                     	zd[j]=MRD[k].substring(0,7)
	                     	j=j+1;
	                     	zd[j]=MRD[k].substring(7,len)	                     	
                     	}
                     	else
                     	{
	                     zd[j]=MRD[k]
                     	}
                     	
                     }
               var zf="(正方)"
             
                     var myobj=document.getElementById("ClsBillPrint");
                     var MyList=""
          var MyPara="";
			    MyPara=MyPara+"hospitalcode"+String.fromCharCode(2)+hospitalcode;
			    MyPara=MyPara+"^zf"+String.fromCharCode(2)+zf;
			    MyPara=MyPara+"^PapmiNo"+String.fromCharCode(2)+PapmiNo;
			    MyPara=MyPara+"^presc"+String.fromCharCode(2)+presc;
			    MyPara=MyPara+"^PatientName"+String.fromCharCode(2)+PatientName;
			    MyPara=MyPara+"^pname"+String.fromCharCode(2)+pname;
			    MyPara=MyPara+"^sex"+String.fromCharCode(2)+sex;
			    MyPara=MyPara+"^age"+String.fromCharCode(2)+age;
			    MyPara=MyPara+"^GovernCardNo"+String.fromCharCode(2)+GovernCardNo;
			    MyPara=MyPara+"^OEORIOrdDept"+String.fromCharCode(2)+OEORIOrdDept;
			    MyPara=MyPara+"^PatientComAdd"+String.fromCharCode(2)+PatientComAdd;
			    MyPara=MyPara+"^PatientName"+String.fromCharCode(2)+PatientName;
			    MyPara=MyPara+"^DurationDesc"+String.fromCharCode(2)+DurationDesc;
			    MyPara=MyPara+"^PHCINDesc"+String.fromCharCode(2)+PHCINDesc;
			    MyPara=MyPara+"^OEORIDoctor"+String.fromCharCode(2)+OEORIDoctor;
			    MyPara=MyPara+"^cydate2"+String.fromCharCode(2)+cydate2;
			    MyPara=MyPara+"^qyks"+String.fromCharCode(2)+qyks;
			    MyPara=MyPara+"^cy1"+String.fromCharCode(2)+cy2[0];
			    MyPara=MyPara+"^cy2"+String.fromCharCode(2)+cy2[1];
			    MyPara=MyPara+"^cy3"+String.fromCharCode(2)+cy2[2];
			    MyPara=MyPara+"^cy4"+String.fromCharCode(2)+cy2[3];
			    MyPara=MyPara+"^cy5"+String.fromCharCode(2)+cy2[4];
			    MyPara=MyPara+"^cy6"+String.fromCharCode(2)+cy2[5];
			    MyPara=MyPara+"^cy7"+String.fromCharCode(2)+cy2[6];
			    MyPara=MyPara+"^cy8"+String.fromCharCode(2)+cy2[7];
			    MyPara=MyPara+"^cy9"+String.fromCharCode(2)+cy2[8];
			    MyPara=MyPara+"^cy10"+String.fromCharCode(2)+cy2[9];
			    MyPara=MyPara+"^cy11"+String.fromCharCode(2)+cy2[10];
			    MyPara=MyPara+"^cy12"+String.fromCharCode(2)+cy2[11];
			    MyPara=MyPara+"^cy13"+String.fromCharCode(2)+cy2[12];
			    MyPara=MyPara+"^cy14"+String.fromCharCode(2)+cy2[13];
			    MyPara=MyPara+"^cy15"+String.fromCharCode(2)+cy2[14];
			    MyPara=MyPara+"^cy16"+String.fromCharCode(2)+cy2[15];
			    MyPara=MyPara+"^cy17"+String.fromCharCode(2)+cy2[16];
			    MyPara=MyPara+"^cy18"+String.fromCharCode(2)+cy2[17];
			    MyPara=MyPara+"^cy19"+String.fromCharCode(2)+cy2[18];
			    MyPara=MyPara+"^cy20"+String.fromCharCode(2)+cy2[19];
			    MyPara=MyPara+"^cy21"+String.fromCharCode(2)+cy2[20];
			    MyPara=MyPara+"^cy22"+String.fromCharCode(2)+cy2[21];
			    MyPara=MyPara+"^cy23"+String.fromCharCode(2)+cy2[22];
			    MyPara=MyPara+"^cy24"+String.fromCharCode(2)+cy2[23];
			    MyPara=MyPara+"^cy25"+String.fromCharCode(2)+cy2[24];
			    MyPara=MyPara+"^cy26"+String.fromCharCode(2)+cy2[25];
			    MyPara=MyPara+"^cy27"+String.fromCharCode(2)+cy2[26];
			    MyPara=MyPara+"^cy28"+String.fromCharCode(2)+cy2[27];
			    MyPara=MyPara+"^cy29"+String.fromCharCode(2)+cy2[28];
			    MyPara=MyPara+"^cy30"+String.fromCharCode(2)+cy2[29];
			    MyPara=MyPara+"^cy31"+String.fromCharCode(2)+cy2[30];
			    MyPara=MyPara+"^cy32"+String.fromCharCode(2)+cy2[31];
			    MyPara=MyPara+"^bz1"+String.fromCharCode(2)+bz[0];
			    MyPara=MyPara+"^bz2"+String.fromCharCode(2)+bz[1];
			    MyPara=MyPara+"^bz3"+String.fromCharCode(2)+bz[2];
			    MyPara=MyPara+"^bz4"+String.fromCharCode(2)+bz[3];
			    MyPara=MyPara+"^bz5"+String.fromCharCode(2)+bz[4];
			    MyPara=MyPara+"^bz6"+String.fromCharCode(2)+bz[5];
			    MyPara=MyPara+"^bz7"+String.fromCharCode(2)+bz[6];
			    MyPara=MyPara+"^bz8"+String.fromCharCode(2)+bz[7];
			    MyPara=MyPara+"^bz9"+String.fromCharCode(2)+bz[8];
			    MyPara=MyPara+"^bz10"+String.fromCharCode(2)+bz[9];
			    MyPara=MyPara+"^bz11"+String.fromCharCode(2)+bz[10];
			    MyPara=MyPara+"^bz12"+String.fromCharCode(2)+bz[11];
			    MyPara=MyPara+"^bz13"+String.fromCharCode(2)+bz[12];
			    MyPara=MyPara+"^bz14"+String.fromCharCode(2)+bz[13];
			    MyPara=MyPara+"^bz15"+String.fromCharCode(2)+bz[14];
			    MyPara=MyPara+"^bz16"+String.fromCharCode(2)+bz[15];
			    MyPara=MyPara+"^bz17"+String.fromCharCode(2)+bz[16];
			    MyPara=MyPara+"^bz18"+String.fromCharCode(2)+bz[17];
			    MyPara=MyPara+"^bz19"+String.fromCharCode(2)+bz[18];
			    MyPara=MyPara+"^bz20"+String.fromCharCode(2)+bz[19];
			    MyPara=MyPara+"^bz21"+String.fromCharCode(2)+bz[20];
			    MyPara=MyPara+"^bz22"+String.fromCharCode(2)+bz[21];
			    MyPara=MyPara+"^bz23"+String.fromCharCode(2)+bz[22];
			    MyPara=MyPara+"^bz24"+String.fromCharCode(2)+bz[23];
			    MyPara=MyPara+"^bz25"+String.fromCharCode(2)+bz[24];
			    MyPara=MyPara+"^bz26"+String.fromCharCode(2)+bz[25];
			    MyPara=MyPara+"^bz27"+String.fromCharCode(2)+bz[26];
			    MyPara=MyPara+"^bz28"+String.fromCharCode(2)+bz[27];
			    MyPara=MyPara+"^bz29"+String.fromCharCode(2)+bz[28];
			    MyPara=MyPara+"^bz30"+String.fromCharCode(2)+bz[29];
			    MyPara=MyPara+"^bz31"+String.fromCharCode(2)+bz[30];
			    MyPara=MyPara+"^bz32"+String.fromCharCode(2)+bz[31];
			    MyPara=MyPara+"^zd1"+String.fromCharCode(2)+zd[0];
			    MyPara=MyPara+"^zd2"+String.fromCharCode(2)+zd[1];
			    MyPara=MyPara+"^zd3"+String.fromCharCode(2)+zd[2];
			    MyPara=MyPara+"^zd4"+String.fromCharCode(2)+zd[3];
			    MyPara=MyPara+"^zd5"+String.fromCharCode(2)+zd[4];
			    MyPara=MyPara+"^zd6"+String.fromCharCode(2)+zd[5];
			    MyPara=MyPara+"^lyq"+String.fromCharCode(2)+lyqk;
			    MyPara=MyPara+"^yf"+String.fromCharCode(2)+je5;
			    
			    var DiagnoseArrayLen=DiagnoseArray.length;
				for (var k=0;k<zd.length;k++) {
					var j=k+1;
					MyPara=MyPara+"^Diagnose"+j+String.fromCharCode(2)+zd[k];
				}
			    DHCP_PrintFun(myobj,MyPara,MyList);
	}
}

function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;
	if (SelectedRow==1)
	{
		tblobj.rows[1].className="clsRowSelected"
	}
	else
	{
		tblobj.rows[1].className="RowEven"
	}
	var prescno=document.getElementById("TPrescNoz"+selectrow).innerText
	var phd=document.getElementById("tphdz"+selectrow).value
	var ctlocobj=document.getElementById("ctloc");
	var fy=document.getElementById("TPyNamez"+selectrow).innerText
	if (fy=="W"){GFyFlag="2";}
	if (GFyFlag==""){GFyFlag="1";}
	var ctlocobj=document.getElementById("ctloc")
	var ctloc=ctlocobj.value;
	var PrtID=document.getElementById("TPrtIDz"+selectrow).value
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispSub&rPhd="+phd+"&FyFlag="+GFyFlag+"&rCtloc="+ctloc+"&rPrescNo="+prescno+"&rPrt="+PrtID;
 	bottomFrame.location.href=lnk;
 	DHCMZYF_setfocus('CPmiNo');
}

function RowClick()
{
  var objfirstrow=tblobj.rows[1];
  objfirstrow.className="clsRowSelected"
  var prescno=document.getElementById("TPrescNoz"+1).innerText
  var phd=document.getElementById("tphdz"+1).value
  var ctlocobj=document.getElementById("ctloc");
  var ctloc=ctlocobj.value;
  	//var fy=document.getElementById("tPyNamez"+1).innerText
	//if (fy=="W"){GFyFlag="2";}
	//if (GFyFlag==""){GFyFlag="1";}
	
	var PrtID=document.getElementById("TPrtIDz"+1).value
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispSub&rPhd="+phd+"&FyFlag="+GFyFlag+"&rCtloc="+ctloc+"&rPrescNo="+prescno+"&rPrt="+PrtID;
 	bottomFrame.location.href=lnk;
 	DHCMZYF_setfocus('CPmiNo');

}
function ReadHFMagCard_Click()
{
	var myCardTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine");
	m_SelectCardTypeDR=GetCardEqRowId();
	
	if (m_SelectCardTypeDR==""){
		var myrtn=DHCACC_GetAccInfo();
	}else{
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
	}
	
	if (myrtn==-200){ //卡无效
	       
			alert("此卡无效");
			websys_setfocus('CPmiNo');
			return;
	}
    
	var myary=myrtn.split("^");
	var rtn=myary[0];
	
	if (rtn=="-1") {alert(t['32']);return ;}
	else
	{	var obj=document.getElementById("CPmiNo");
			if (obj) obj.value=myary[5];
			//DHCMZYF_setfocus('BRetrieve');
			Retrieve_click();
			DHCMZYF_setfocus('CPmiNo');
	}
}


function GetCardEqRowId(){
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	
	return m_SelectCardTypeDR;
}


function GetPhDescKeyDown()
{
var key=websys_getKey(e);
 if (key==13)
  {	
    
  var ctloc=document.getElementById("ctloc").value;
  var input=document.getElementById("CPhDesc").value;
  if (input=="") return ;
	combo_InputPh=dhtmlXComboFromStr("CPhDesc","");
	combo_InputPh.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getph');
	var DeptStr=cspRunServerMethod(encmeth,ctloc,input)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_InputPh.addOption(Arr);
  	
 }
}
function GetPmiLen()
{var getmethod=document.getElementById('getpmilen');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var pmilen=cspRunServerMethod(encmeth)
 return pmilen 
} 
function GetPmino() {
 var key=websys_getKey(event);
 var patlen=GetPmiLen()

 var pmiobj=document.getElementById("CPmiNo");
 if (key==13) {	
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){ DHCMZYF_setfocus('CPerName'); return ;}
 	//if (plen>patlen){alert(t['01']);return;}
	 for (i=1;i<=patlen-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	 /*  登记号回车,带出姓名
	 var patnamestr=tkMakeServerCall("web.DHCOutPhReturn","GPatName","","",lspmino)
	 if (patnamestr!="")
	 {
	 	document.getElementById("CPerName").value=patnamestr.split("^")[0];
	 }
	 else
	 {
	 	document.getElementById("CPerName").value=""
	 }*/
	 Retrieve_click();
	 pmiobj.value=""
	 DHCMZYF_setfocus('CPmiNo');
 }
}
function GPmino()
{
 if (pmiobj.value=="") return ;
  var patlen=GetPmiLen()
  var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0)  {  DHCMZYF_setfocus('CPerName'); return ;}
 	//if (plen>patlen){alert(t['01']);return;}
	 for (i=1;i<=patlen-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	 Retrieve_click();
   //DHCMZYF_setfocus('CPerName');

}
function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDisp";
 	var prt=""
 	var phd=""
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispSub&rPhd="+phd;
 	bottomFrame.location.href=lnk;
	 }
 
function GFydr(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CFyDr")
     fydrobj.value=sstr[1]
}
function GPydr(value)
{
  var sstr=value.split("^")
  var pydrobj=document.getElementById("CPyDr")
     pydrobj.value=sstr[1]
}
function GInci(value)
{
  var sstr=value.split("^")
  	var fydrobj=document.getElementById("inci")
     fydrobj.value=sstr[1]
}
function popCPhDesc()
{ 
	if (window.event.keyCode==13) 
	{ 
	   window.event.keyCode=117;
	   window.event.isLookup=true
	   CPhDesc_lookuphandler(window.event);
	}
}


function Retrieve_click()
{
  stdateobj=document.getElementById("CDateSt")
  enddateobj=document.getElementById("CDateEnd")
  pmiobj=document.getElementById("CPmiNo")
  pnameobj=document.getElementById("CPerName")
  var ctlocobj=document.getElementById("ctloc")
  var ctloc=ctlocobj.value;
   
  var stdate=stdateobj.value
  var enddate=enddateobj.value
  var sttime=document.getElementById("sttime").value
  var endtime=document.getElementById("endtime").value
  var pmino=pmiobj.value

  var plen=pmiobj.value.length
  var i;
  var lszero=""
   
  var pname=pnameobj.value
   
  var prtinv=document.getElementById("CPrtInv").value
  var inci=document.getElementById("inci").value
  var pydr=combo_PyDR.getSelectedValue()
  var fydr=combo_FyDR.getSelectedValue()
   fy=document.getElementById("DispFlag");
  var wfy=document.getElementById("UnDispFlag");
   var ypwf=document.getElementById("CYPWF");
   var yp=ypwf.checked
  if( wfy.checked==true) {GFyFlag="2";}
  else if (ypwf.checked==true){GFyFlag="0";}
  
  else {GFyFlag="1";}
 
  var manflag=document.getElementById("ChMan");
  var gl
  if (manflag.checked==true){gl="1";}
    else
     {gl="0";}
  var pyname=document.getElementById("CPyName").value
  var fyname=document.getElementById("CFyName").value
  var phdesc=document.getElementById("CPhDesc").value
  if (pyname=="") pydr=""
  if (fyname=="") fydr=""
  if (phdesc=="") inci=""
   var CDoctor=document.getElementById("CDoctor").value
   var CDepCode=document.getElementById("CDepCode").value
   var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDisp&CDateSt="+stdate+"&CDateEnd="+enddate+"&ctloc="+ctloc+"&CPmiNo="+pmino+"&CPerName="+pname+"&CPrtInv="+prtinv+"&inci="+inci+"&CPydr="+pydr+"&CFydr="+fydr+"&FyFlag="+GFyFlag+"&sttime="+sttime+"&endtime="+endtime+"&glflag="+gl+"&CPyName="+pyname+"&CFyName="+fyname+"&CPhDesc="+phdesc+"&CDoctor="+CDoctor+"&CDepCode="+CDepCode
   topFrame.location.href=lnk;  
   DHCMZYF_setfocus('CPmiNo');


}

function Export_click() 
{
	var subtblobj=bottomFrame.document.getElementById('tDHCOutPhQueryDispSub');
	var tblobj=document.getElementById("tDHCOutPhQueryDisp");
	var oXL = new ActiveXObject("Excel.Application"); 
	var oWB = oXL.Workbooks.Add(); 
	var oSheet = oWB.ActiveSheet; 
	var rows = subtblobj.rows.length; 
	var mainrows=tblobj.rows.length;
	var RowSel=SelectedRow 
	var lie = subtblobj.rows(0).cells.length; 
	var mainlie = tblobj.rows(0).cells.length; 
	if (mainrows==1) {return ;}
	if (SelectedRow==0) {RowSel=1;}
	var ii;
	for (ii=0;ii<mainlie;ii++)
	{
		//标题
		var cellTitle= tblobj.rows(0).cells(ii).innerText;
		oSheet.Cells(1,ii+1).value=cellTitle;
		var cellValue= tblobj.rows(RowSel).cells(ii).innerText;
		var regExpPattern=/^(-?\d*)(.?\d*)$/;  
		if(cellValue!="" && regExpPattern.test(cellValue)){
			oSheet.Cells(2,ii+1).value="\'"+cellValue;	//全数字转换成字符串
		}
		else{
			oSheet.Cells(2,ii+1).value=cellValue;
		}
	
	}
	var i,j;
	for (i=0;i<rows;i++){ 
	    for (j=0;j<lie;j++){ 
	        oSheet.Cells(i+3,j+1).value = subtblobj.rows(i).cells(j).innerText; } ;
	   } 
	oXL.Visible = true; 
	oXL.UserControl = true; 

} 
function DHCMZYF_setfocus(objName) {
	window.setTimeout('DHCMZYF_setfocus2(\''+objName+'\')',300);
}

function DHCMZYF_setfocus2(objName) {
	var obj=document.getElementById(objName);
	if (obj) {
		try {obj.focus();obj.select();	} catch(e) {}  }
    }


//打印西药处方 liangqiang
function PrintPYD()
{
	   var zf='[正方]'
	   var MyList="" ;
	   var selectflag=0
	   var objtbl=document.getElementById("t"+"DHCOutPhQueryDisp")
	   var rows=objtbl.rows.length
	   
       var phdrowStirng="";
	   
	   for (j=1;j<rows;j++)
	   {
		    var selobj=document.getElementById("Tselectz"+j)
		    if (selobj)
		    {
			    var prescno=""
			    if (selobj.checked==true)
			    {  
			        var selectflag=1
				    var prescobj=document.getElementById("TPrescNoz"+j)
				    var prescno=prescobj.innerText 
				    if (prescno=="") continue;
				    
				    var Phdrowobj=document.getElementById("tphdz"+j)
				    var phdrow=Phdrowobj.value
				    
				    if (phdrowStirng=="")
				    {
					    phdrowStirng=phdrow
				    }
				    else
				    {
					    phdrowStirng=phdrowStirng+"^"+phdrow
				    }
					
			    }
		    
		    }
	   }
	   
	  
	  if (selectflag==0){alert("请选中记录后重试!");return }
	  
	  if (phdrowStirng=="") {alert("未配药不能打印处方!");return }

	  PrintPresc(phdrowStirng) ;
	   
   	
}

///打印程序专区 
function PrintPresc(phdrowid)
{
	
	cyflag=document.getElementById("cyflag").value
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrintCom"+"&phdrowid="+phdrowid+"&cyflag="+cyflag
	parent.frames['DHCOutPhPrintCom'].window.document.location.href=lnk;

}

function GetDropDept(value)
{
  var val=value.split("^") 
  var shdr=document.getElementById("CDepCode");
  shdr.value=val[1];
}

function GetDropDoctor(value)
{
  var val=value.split("^") 
  var shdr=document.getElementById("CDoctor");
  shdr.value=val[1];
}

function SelectAll()
{
	   var objtbl=document.getElementById("t"+"DHCOutPhQueryDisp")
	   var rows=objtbl.rows.length
	   for (j=1;j<rows;j++)
	   {
		    var selobj=document.getElementById("Tselectz"+j)
		    if (selobj)
		    {
			    selobj.checked=!( selobj.checked)
		    }
	   }
	
}
function GPrtID(value)
{
	var vstr=value
	var sstr=vstr.split("^")
	var yprtobj=document.getElementById('CPrtinv')
	if (yprtobj)
	{
		yprtobj.value=sstr[6];
	} 
}
document.body.onload = BodyLoadHandler;

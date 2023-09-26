// DHCOutPhDisp.js
// 门诊药房-直接发药
var noconfirm=0;
var AllPresc;
var OldPresc;
var OldPatprt;
var gPrnpath; //打印路径
var SpecialID;
var ChkAllOweFlag,ChkOweFlag,RealOrdStr;
var bottomFrame;
var topFrame;
var tbl=document.getElementById("tDHCOutPhDisp");
var f=document.getElementById("fDHCOutPhDisp");
var usercode=document.getElementById("userid").value;
var evtName;
var doneInit=0;
var focusat=null;
var GInf;
var SelectedRow = 0;
var pmiobj,pnameobj;
var HospitalCode;
var Tel="";
var CYMB=""
var CY="";
var cy1,cy2,cy3,cy4,cy5,cy6,cy7,cy8,cy9,cy10,cy11,cy12,cy13,cy14,cy15,cy16,cy17,cy18,cy19,cy20,cy21,cy22,cy23,cy24,cy25,cy26,cy27,cy28=""
var cy = new Array();
var cy1= new Array();
var cy2= new Array();
var bz= new Array();
var zd= new Array();
var DiagnoseArray=new Array();
var cjg=new Array();
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var stdateobj,enddateobj;
var GStrCode=String.fromCharCode(1);
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var fyflagobj;
var BResetobj,BDispobj,BPrintobj,BReprintobj;
var printobj,dispobj,reprintobj;
var returnphobj,returnphitmobj;
var GPhl,GPhw,GPydr,GPyName,GFydr,GFyName,GPhwPos;
GPhl=document.getElementById("GPhl").value
GPhw=document.getElementById("GPhw").value
GPydr=document.getElementById("GPydr").value
GFydr=document.getElementById("GFydr").value
GPhwPos=document.getElementById("GPhwPos").value
var ctloc=document.getElementById("ctloc").value
var method=document.getElementById('checkloc');
if (method) {var encmeth=method.value} else {var encmeth=''};
if (cspRunServerMethod(encmeth,'checkcy','',ctloc)=='0') {}
var cdateobj;
if(parent.name=='TRAK_main') {
	topFrame=parent.frames['DHCOutPatienDisp'];
	bottomFrame=parent.frames['DHCOutPatienDispSub'];
} else {
	topFrame=parent.frames['TRAK_main'].frames['DHCOutPatienDisp'];
	bottomFrame=parent.frames['TRAK_main'].frames['DHCOutPatienDispSub'];
}
var subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispSub');
var objtbl=document.getElementById('tDHCOutPhDisp');
var SubDoc=parent.frames['DHCOutPhDispSub']
var getdesc=document.getElementById('getdesc');
if (getdesc) {var encmeth=getdesc.value} else {var encmeth=''};
if (cspRunServerMethod(encmeth,'GDesc','',GPhl,GPhw,GPydr,GFydr,GPhwPos)=='0'){}
BPrintobj=document.getElementById("BPrint");
BReprintobj=document.getElementById("BReprint");
BPrintobj.style.visibility = "hidden";
var OutPhaWay=tkMakeServerCall("web.DHCSTCNTSCOMMON","GetWayIdByCode","OA")
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
	if (key==118){Find_click();}  //F7
	if (key==121){BAllDisp_click();}  //F10
	if (key==119) {  //F8
		KeyDisp(); 
		//var eSrc=tbl.rows[SelectedRow];
		//var RowObj=getRow(eSrc);
		//RowObj.className="RedColor"; 
	}
	if (key==120){
		RePrint_click();
	}	
	if (key==115){ReadHFMagCard_Click();}	//F4 
	if (key==40) {  //liangqiang
		if (rownum>SelectedRow){ 
			var retrow=SelectedRow+1;
			var eSrc=tbl.rows[retrow];
			var RowObj=getRow(eSrc);
			RowObj.className="RowSelColor";
			var eSrc=tbl.rows[SelectedRow];
			var RowObj=getRow(eSrc);
			var  fyflag=document.getElementById("TFyFlagz"+SelectedRow).innerText
			if (fyflag=='OK'){
				RowObj.className="RedColor";
			}
			else{
				RowObj.className="OldBackColor"
			}
			GetSelectRow(retrow);
		}
	}
	if (key==38) {
		if (SelectedRow>1){ 
			var retrow=SelectedRow-1;
			var eSrc=tbl.rows[retrow];
			var RowObj=getRow(eSrc);
			RowObj.className="RowSelColor";
			var eSrc=tbl.rows[SelectedRow];
			var RowObj=getRow(eSrc);
			var  fyflag=document.getElementById("TFyFlagz"+SelectedRow).innerText
			if (fyflag=='OK'){
				RowObj.className="RedColor";
			}
			else{
				RowObj.className="OldBackColor"
			}
			GetSelectRow(retrow);
		}
	}
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
}
function BodyLoadHandler() {
  var obj=document.getElementById("mGetPrnPath") ;
  if (obj) {var encmeth=obj.value;} else {var encmeth='';}
  gPrnpath=cspRunServerMethod(encmeth,'','') ;	
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  BDispobj=document.getElementById("BDisp");
  if (BDispobj) BDispobj.onclick=BDisp_click;
  BRefuseDispobj=document.getElementById("BRefuseDisp");
  if (BRefuseDispobj) BRefuseDispobj.onclick=BRefuseDisp_click; //拒绝发药功能与处方审核功能是一样的
  var BCancelRefuseobj=document.getElementById("BCancelRefuse");
  if (BCancelRefuseobj) BCancelRefuseobj.onclick=BCancelRefuse_click;  //撤销拒绝
  BPrintobj=document.getElementById("BPrint");
  var  PrePrintobj=document.getElementById("PrePrint");
  if (PrePrintobj) PrePrintobj.onclick=PrePrint_click;  //lq 放开报错郁闷
  var obj=document.getElementById("CardNo");
  if (obj) obj.onkeypress=GetCardInf;
  BReprintobj=document.getElementById("BReprint");
  if (BReprintobj) BReprintobj.onclick=RePrint_click;  
  BAllDispobj=document.getElementById("BAllDisp");
  if (BAllDispobj) BAllDispobj.onclick=BAllDisp_click;
  var BGetWinobj=document.getElementById("BGetWin");
  if (BGetWinobj) BGetWinobj.onclick=GetWin_click;
  BFindobj=document.getElementById("BRetrieve");
  findobj=document.getElementById("find");
  var cyflag=document.getElementById("cyflag");
  var PPyName=document.getElementById("cPPyName");
  var PFyName=document.getElementById("cPFyName");
  var CSHName=document.getElementById("cCSHName"); GPhwPos=document.getElementById("GPhwPos").value
	var GetHospital=document.getElementById("GetHospital");
	if (GetHospital) {var encmeth=GetHospital.value} else {var encmeth=''};
	if (encmeth!="") {
	var HospitalStr=cspRunServerMethod(encmeth,"CurrentHospital");
	var HStr=HospitalStr.split("^")
	HospitalCode=HStr[0];
	}
  if (cyflag.value=="1")
     { CY="1";
	 if (HospitalCode=="BJZYY")
	  {
	 
	  PPyName.innerText=t['pyuser'];
      PFyName.innerText=t['shuser'];
    
     if (CSHName)  CSHName.innerText=t['60'];
      GPhl=document.getElementById("GPhl").value
      var getmethod=document.getElementById('gettelmb');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var retval=cspRunServerMethod(encmeth,GPhl)
      var sstr=retval.split("^")
      Tel=sstr[0];
      CYMB=sstr[1];
      if (CYMB=="1"){DHCP_GetXMLConfig("InvPrintEncrypt","DHCWINFP01");}
      if (CYMB=="2"){DHCP_GetXMLConfig("InvPrintEncrypt","DHCWINFP02");BGetWinobj.style.visibility = "hidden";}
      if (CYMB=="3"){DHCP_GetXMLConfig("InvPrintEncrypt","DHCWINFP03");BGetWinobj.style.visibility = "hidden";}
      if (CYMB=="4"){DHCP_GetXMLConfig("InvPrintEncrypt","DHCWINFP04");BGetWinobj.style.visibility = "hidden";}
	  }
	 else if(HospitalCode=="BJDTYY")
	 {
	   DHCP_GetXMLConfig("InvPrintEncrypt","BJDTYYCYPYD");BGetWinobj.style.visibility = "hidden";	 
	 }
	 else if(HospitalCode=="FJXMXL")
	 {
	   DHCP_GetXMLConfig("InvPrintEncrypt","FJXMXLCYPrescriptPrint");BGetWinobj.style.visibility = "hidden";	 
	 }
	 else if (HospitalCode=="SCDXHXYY")
	 	{
	 		DHCP_GetXMLConfig("InvPrintEncrypt","DHCHXCYPrescNoPYD");
	 		BGetWinobj.style.visibility = "hidden";	 
	 		
	 	}
        
     }
     else
      {
	      
    	    BGetWinobj.style.visibility = "hidden";
    	    
       if(HospitalCode=="FJXMXL")
	    {
	      DHCP_GetXMLConfig("InvPrintEncrypt","FJXMXLXYPrescriptPrint");	 
	     }
        else if (HospitalCode=="YKYZLYY"){
	        
          DHCP_GetXMLConfig("InvPrintEncrypt","YKYZLYYPYD");	 
        }
        else if (HospitalCode=="ZGYDYY"){ 
 
       DHCP_GetXMLConfig("InvPrintEncrypt","ZGYDYYXYPYD");	 
     }
     else if (HospitalCode=="BJDTYY"){
	     
	     if (CY=="1") { 
	     
	     DHCP_GetXMLConfig("InvPrintEncrypt","BJDTYYCYPYD");}
	     else
	     { DHCP_GetXMLConfig("InvPrintEncrypt","BJDTYYPYD");}	 
      }
      else if (HospitalCode=="ZGYDYY")
      	{
      		DHCP_GetXMLConfig("InvPrintEncrypt","DHCHXXYPrescNoPYD");	
      	}
      }
  BGetWinobj.style.visibility = "hidden";
  if (BFindobj){
	   	
	   BFindobj.onclick=Find_click;
	   if (tbl.rows.length>1)
	   {RowClick();
	   DHCMZYF_setfocus('BDisp');
	   //PassDaTong();  //大通
	   }
	   else
	   { var prt=""
 	     var flag=""
 	     var presc=""
	     var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispsub&rPHL="+GPhl+"&rPRT="+prt+"&rFLAG="+flag+"&rPrescNo="+presc;
       	    bottomFrame.location.href=lnk;
	   }
	  }
   tbl.onclick=RollBackColor;
 
  pmiobj=document.getElementById("CPmiNo");
  if (pmiobj) pmiobj.onkeypress=GetPmino;
  //alert(pmiobj.value)
  //if (pmiobj) pmiobj.onblur=GPmino;
  
    var obj=document.getElementById("CardNo");
  if (obj) obj.onkeypress=GetPatNoFrCard;
  
  var ReadCardobj=document.getElementById("CReadCard");
  if (ReadCardobj) ReadCardobj.onclick= ReadHFMagCard_Click;
  
    var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
    loadCardType();
    CardTypeDefine_OnChange();
  var putobj=document.getElementById("BPutOut");
  if (putobj) putobj.onclick= ReadHFMagCard_ClickNew;
  pnameobj=document.getElementById("CPatName");
  ctlocobj=document.getElementById("ctloc");
  useridobj=document.getElementById("userid");
  document.onkeydown=OnKeyDownHandler;
 //document.onkeydown=DHCOutPhWeb_DocumentOnKeydownDSP;
 if (PrePrintobj)
 {
  	if (CY!="1") PrePrintobj.style.visibility = "hidden";
 }
    
	

	StartDaTongDll();
	//没有刷出数据时检查其他科室用药
	var TblRow=objtbl.rows.length-1
	if (TblRow==0){
		var pmi=document.getElementById("CPatNo").value; //新建的隐藏元素
		if((pmi!="")&&(pmi!=null)){
			ChkUnFyOtherLoc();
		}
		
	}
	
	InitSpecial();
	var cardnoobj=document.getElementById("CardNo");
	if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
	else { DHCMZYF_setfocus('CPmiNo');}
 
}

function InitSpecial()
{
	var obj=document.getElementById("SpeLoc");  //基数科室 
	if (obj){	
		obj.onkeydown=popSpeLoc;
		obj.onblur=SpeLocCheck;		
	}
	
	
	specobj=document.getElementById("Special");  //特殊(留观...)
    if (specobj) { 
    	specobj.onkeydown=popSpecial;
		specobj.onblur=SpecialCheck;    
    }
   
	
	
}


function combo_SpecialListKeydownhandler()
{
	var obj=combo_SpecialList;
	strid=obj.getActualValue();
	strDesc=obj.getSelectedText();
	var ObjSpecialID=document.getElementById("SpecialID") ;
	if (ObjSpecialID) ObjSpecialID.value=strid ;
	 
	 
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
	var flagobj=document.getElementById("TFyFlagz"+selectrow).innerText
	var phdrow=document.getElementById("Tphdz"+selectrow).value
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispsub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+prescno+"&rPhdrow="+phdrow;
 	bottomFrame.location.href=lnk;
    DHCMZYF_setfocus('CPmiNo')
    var cardnoobj=document.getElementById("CardNo");
    if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
    else { DHCMZYF_setfocus('CPmiNo');}
    //PassDaTong(selectrow);  //大通

}

function GetSelectRow(row)	{
	var selectrow=row;
	isSelected=1;
	SelectedRow = selectrow;
	DHCMZYF_setfocus('CPmiNo')
	var prt=document.getElementById("TPrtz"+selectrow).value
	var prescno=document.getElementById("TPrescNoz"+selectrow).innerText
	var flagobj=document.getElementById("TFyFlagz"+selectrow).innerText
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispsub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+prescno;
 	bottomFrame.location.href=lnk;
     


}
function RollBackColor()
{
    SelectRowHandler();
    if (SelectedRow==0) return;
   var  fyflag=document.getElementById("TFyFlagz"+SelectedRow).innerText
   if (tbl.rows.length>1){
	  for (var i=1;i<=tbl.rows.length-1;i++)
	  {
		  var  fyflag=document.getElementById("TFyFlagz"+i).innerText
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
	var plen=strMedicare.length
    var i
    var lszero=""
    if (plen==0){ return ;}
	 for (i=1;i<=6-plen;i++)
  	  {  lszero=lszero+"0"    	 }
    strMedicare=lszero+strMedicare	 
	var GetNObyMNoobj=document.getElementById('GetNObyMNo');
	if (GetNObyMNoobj) {var encmeth=GetNObyMNoobj.value} else {var encmeth=''};
	if (encmeth){
	PatNo=cspRunServerMethod(encmeth,strMedicare)} 
	return PatNo
}

function KeyDisp()
{
	BDisp_click();
}
function GetPmiLen()
{var getmethod=document.getElementById('getpmilen');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var pmilen=cspRunServerMethod(encmeth)
 return pmilen 
} 
function GetPmino() {
 var key=websys_getKey(event);
 var PmiLength=GetPmiLen();
 if (key==13) {	
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){
	DHCMZYF_setfocus('find'); return ;}
 	if (plen>PmiLength){alert(t['patnoiserr']);return;}
	for (i=1;i<=PmiLength-plen;i++)
  	{
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	 Find_click();
 }
}
function GPmino()
{
 if (pmiobj.value=="") return ;
  var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0)  {  DHCMZYF_setfocus('find'); return ;}
 	if (plen>8){alert(t['patnoiserr']);return;}
	 for (i=1;i<=8-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
  Find_click();

}
function Reset_click()
{
  var stdate="" //document.getElementById("CDateSt").value;
  var enddate="" //document.getElementById("CDateEnd").value;
  var GPhl=document.getElementById("GPhl").value;
  var GPhw=document.getElementById("GPhw").value;
  var CPmiNo="00000000";
  var obj=document.getElementById("CPatName")
  var CPatName=""
  if (obj)  CPatName=obj.value;
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDisp&CDateSt="+stdate+"&CDateEnd="+enddate+"&GPhl="+GPhl+"&GPhw="+GPhw+"&CPmiNo="+CPmiNo+"&CPatName="+CPatName+"&GPydr="+GPydr+"&GFydr="+GFydr+"&GPhwPos="+GPhwPos;
  topFrame.location.href=lnk;
	var prt=""
 	var presc=""
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispsub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+presc;
 	bottomFrame.location.href=lnk;
	 }
	 
function Exit_click()
{var getmethod=document.getElementById('exit');
 
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     if (cspRunServerMethod(encmeth,'','',GPhl,GPhw)=='0'){}
    location.href="websys.default.csp"
    bottomFrame.location.href="websys.default.csp"
}
function SetReprint(value)
{
}

function RePrint_click()
{   

     if (objtbl.rows.length==0) {alert(t['nopatientprint']);return 0;}
   	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispSub');
	 if (subtblobj.rows.length==0){alert(t['nopatordprint']);return 0;}
	 var row = SelectedRow;
	 if (row<1){alert(t['noselectpat']);return 0;}
	 if (document.getElementById("TPrintFlagz"+row).innerText!='OK')
	 {alert(t['noprint']);return 0;}
	 
	 
	 var phdobj= document.getElementById("Tphdz"+row)
	 if (phdobj) {phdrowid=phdobj.value}
	 
	 
	 PrintPresc(phdrowid)

	 return;  

	 
	 
 
     var patpresc=document.getElementById("TPrescNoz"+SelectedRow).innerText
     var patname=document.getElementById("TPatNamez"+SelectedRow).innerText
     var patpmi=document.getElementById("TPmiNoz"+SelectedRow).innerText
     var patprt=document.getElementById("TPrtz"+SelectedRow).value
     var patsex=document.getElementById("TPatSexz"+SelectedRow).innerText  
     var patage=document.getElementById("TPatAgez"+SelectedRow).innerText
     var patloc=document.getElementById("TPatLocz"+SelectedRow).innerText
     var paticd=document.getElementById("TMRz"+SelectedRow).innerText
     var presctype=document.getElementById("TPrescTypez"+SelectedRow).innerText
     var kjdate=document.getElementById("TPrtDatez"+SelectedRow).innerText
     var windesc=document.getElementById("TWinDescz"+SelectedRow).innerText
     var patid=document.getElementById("TPatIDz"+SelectedRow).innerText
     var fs=document.getElementById("TJSz"+SelectedRow).innerText
     var jytype=""//document.getElementById("TJYTypez"+SelectedRow).innerText
     
     var prtinv="" //document.getElementById("TPrtInvz"+SelectedRow).innerText
     
     //var callcode=document.getElementById("TCallCodez"+SelectedRow).innerText
     var callcode=""
     var patadd=""//document.getElementById("TPatAddz"+SelectedRow).value
     //var presctitle=document.getElementById("TPrescTitlez"+SelectedRow).value
    prescno=patpresc
     var presctitle=""
     var reprintflag="1"
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
      
      var pydate=sstr1[21]
     
     
      var childtype=""
      var lyear=patage.split(t['year'])
      var persui=lyear[0]
      // patienname_"^"_papmino_"^"_printdatetime_"^"_prtcode_"^"_prt_"^"_prescno_"^"_papsex_"^"_perold_"^"_deplocdesc_"^"_mricd_"^"_presctype_"^"_phwdesc_"^"_patid_"^"_cffs_"^"_jytype
          if (persui=='') persui=0
          if (persui<15) childtype="1"
      
    
     
      //reprintflag
     
       cyflag=document.getElementById("cyflag").value
   	    if (cyflag=="1"){CYFreePrintPerOrd(patname,patpmi,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,kjdate,windesc,patid,fs,jytype,prtinv,callcode,patadd,presctitle,pydate)}
	    else {
		  AllPresc=patprt+"&"+patpresc
		  PrintPYD();   
	      //FreePrintPerOrd(patname,patpmi,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,kjdate,windesc,patid,prtinv,callcode,patadd,presctitle,reprintflag);
	    }

    
    
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

function ReadHFMagCard_Clickold()
{
	var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	if (rtn!="-1")
	  {
	  	var obj=document.getElementById("CPmiNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			//ReLoadOPFoot();
			Find_click();
		}

}
function ReLoadOPFoot(){
	var group=document.getElementById("groupid").value;
	var ctloc=document.getElementById("ctloc").value;
	var stdate=document.getElementById("CDateSt").value;
	var enddate=document.getElementById("CDateEnd").value;
	var pmi=document.getElementById("CPmiNo").value;
	var card=document.getElementById("CardNo").value;
	var getmethod=document.getElementById('readcard');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,stdate,enddate,pmi,group,ctloc)
    if (retval=="0"){Find_click(); return;}
	var lnk="udhcopbillif.csp?PatientIDNo="+pmi+"&CardNo="+card;
	var NewWin=open(lnk,"udhcopbillif","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");

}

function ReadHFMagCard_ClickNew()
{
	var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "-1":
		  alert(t['82']);
		   break;
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj=document.getElementById("CPmiNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			ReLoadOPFootNew();
			//Find_click();
			break;
		case "-200":
			alert(t['80']);
			break;
		case "-201":
			alert(t['81'])
			break;
		default:
			///alert("");
			Find_click();
	}
	

}


function ReLoadOPFootNew(){
	var group=document.getElementById("groupid").value;
	var ctloc=document.getElementById("ctloc").value;
	var stdate=document.getElementById("CDateSt").value;
	var enddate=document.getElementById("CDateEnd").value;
	var pmi=document.getElementById("CPmiNo").value;
	var card=document.getElementById("CardNo").value;
	var lnk="udhcopbillif.csp?PatientIDNo="+pmi+"&CardNo="+card;
	var NewWin=open(lnk,"udhcopbillif","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");

}



function transINVStr(InvStr){
	var myary=InvStr.split("^");
	Find_click();
}

function GetWin_click()
{
  if (SelectedRow>0)
  { 
    var presc=document.getElementById("TPrescNoz"+SelectedRow).innerText;
    var pmino=document.getElementById("TPmiNoz"+SelectedRow).innerText;
    var patname=document.getElementById("TPatNamez"+SelectedRow).innerText;
    var prescfs=document.getElementById("TJSz"+SelectedRow).innerText;
    var ctloc=document.getElementById("ctloc").value
  
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhModifyWin&CPrescNo="+presc+"&CPrescFS="+prescfs+"&CPmiNo="+pmino+"&CPatName="+patname+"&ctloc="+ctloc;
     window.open(lnk,"_target","height=500,width=800,menubar=no,status=no,toolbar=no") ;
  
	  } 	
}

function ModifyCurrWin(windesc,winid)
  { 
  DHCMZYF_setfocus('CPmiNo')
 
   if (SelectedRow>0)
   {
    document.getElementById("TWinDescz"+SelectedRow).innerText=windesc;
    document.getElementById("TNewWinIDz"+SelectedRow).value=winid;
   }
  }
  
  
function setFocusCardNo()
{
	 pmiobj=document.getElementById("CPmiNo");
	 pmiobj.value=""
	 var cardnoobj=document.getElementById("CardNo");
     if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
     else { DHCMZYF_setfocus('CPmiNo');}
}


function Dispensing(crow,updflag)
{
	
	 var SelectedRow=crow
	 if (objtbl.rows.length-1==0) {alert("没有病人信息"); setFocusCardNo(); return -300 }
    fyobj=topFrame.document.getElementById("TFyFlagz"+SelectedRow)
    pyobj=topFrame.document.getElementById("TPrintFlagz"+SelectedRow)
	if (fyobj.innerText!="OK")
	{
		 if (updflag==""){
	 
		 if (CheckDispQty()<0){return -198;}
	 
		 RealOrdStr=GetDispQtyString();  //欠药单处理  协和
		 var tmpordstr=RealOrdStr.split("&&") 
		 var chkord=tmpordstr[0] ;
		 ChkAllOweFlag=tmpordstr[1] ;  //是否全部欠药
		 ChkOweFlag=chkord;
	    

		 if (chkord==1)
		 {
			 if (pyobj.innerText=="OK"){alert("此处方已经配药，不能欠药！");return;}
			 
			 	if (confirm("是否需要生成欠药单? 点击[确定]生成点击[取消]退出")==false)  
				{return  -197; } 
		 
		 }
	 
	 }
	}
	 
	 var InsertPhdisp=InsertIntoPhd(SelectedRow,updflag)     
     if (InsertPhdisp>0)
     {
	     var phdrowid=InsertPhdisp ;
	 	 prtobj=topFrame.document.getElementById("TPrintFlagz"+SelectedRow)
	 	 if (prtobj) prtobj.innerText="OK"
	     fyobj=topFrame.document.getElementById("TFyFlagz"+SelectedRow)
		 if (fyobj) fyobj.innerText="OK"
		 var eSrc=tbl.rows[SelectedRow];
	     var RowObj=getRow(eSrc);
	         RowObj.className="RedColor";
	     var phdobj= document.getElementById("Tphdz"+SelectedRow)
	     if (phdobj) {phdobj.value=phdrowid}
     }
     
     
     setFocusCardNo();
     
     var tmpprescno=document.getElementById("TPrescNoz"+SelectedRow).innerText;
     var tmppatname=document.getElementById("TPatNamez"+SelectedRow).innerText;
     var tmpwrongstr="病人姓名:"+tmppatname+"\t"+"处方号:"+tmpprescno
     if (InsertPhdisp==-1)
     {
	     alert(tmpwrongstr+"\n\n"+"提示信息:该处方已作废,不能发药")
	     return -1;
     }
     
     if (InsertPhdisp==-2)
     {
	     alert(tmpwrongstr+"\n\n"+"提示信息:该处方药品已配,不能重复配药")
	     return -2;
     }
     
     if (InsertPhdisp==-3)
     {
	     alert(tmpwrongstr+"\n\n"+"提示信息:该处方药品已发,不能重复发药")
	     return -3;
     }
     
     
     if (InsertPhdisp==-4)
     {
	     alert(tmpwrongstr+"\n\n"+"提示信息:该处方医嘱已停,不能发药")
	     return -4;
     }
     
     if (InsertPhdisp==-7)
     {
	     alert(tmpwrongstr+"\n\n"+"提示信息:库存不足,请核查")
	     return -7;
     }
     if (InsertPhdisp==-9)
     {
	     alert(tmpwrongstr+"\n\n"+"提示信息:押金不足，不允许发药")
	     return -9;
     }
     
     if (InsertPhdisp==-24)
     {
	     alert(tmpwrongstr+"\n\n"+"提示信息: 库存不足,请核查")
	     return -24;
     }
     if (InsertPhdisp==-111)
     {
	     alert(tmpwrongstr+"\n\n"+"提示信息：该处方已被拒绝,不能发药!")
	     return -111;
     }
     if (InsertPhdisp==-123)
     {
	     alert(tmpwrongstr+"\n\n"+"提示信息：该处方未做皮试或皮试结果阳性!")
	     return -111;
     }
     if (InsertPhdisp<0)
     {
	     alert(tmpwrongstr+"\n\n"+"错误代码: "+InsertPhdisp)
	     return -100;
     } 
     

     if (!(InsertPhdisp>0))
     {
	     alert(tmpwrongstr+"\n\n"+"错误代码: "+InsertPhdisp)
	     return -200;
	     
     }
     
     return phdrowid
     
}



function BRefuseDisp_click()
{
		var fyflag=document.getElementById("TFyFlagz"+SelectedRow).innerText
       if(fyflag=="OK"){
	       alert("处方已发药，不能拒绝")
	       return;
	       }
	       
    
	 var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText
	 if(prescno=="")
	 {alert("请选择要拒绝的处方");return;}
	 
	 
	   var ref = GetPrescNoRefRet(prescno);　　 //LiangQiang 2014-12-22  处方拒绝

       if (ref=="N"){
	     alert("提示：该处方已被拒绝,不能重复操作!")
	     return;
     　} 
     
       if (ref=="A"){
	     lert("提示：该处方已被拒绝,不能重复操作!")
	     return;
     　} 
	   
	   
	   var adtresult=ChkAdtResult(prescno) ;
	   if (adtresult==""){
	     alert("提示：该处方未审核,禁止操作!")
	     return;
     　}
       if (adtresult!="Y"){
	     alert("提示：该处方审核不通过,禁止操作!")
	     return;
     　} 
       var waycode =OutPhaWay;
  
       var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+prescno+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
        
 
       if (!(retstr)){
          return;
        }
        
        if (retstr==""){
          return;
        }
        
        retarr=retstr.split("@");

        var ret="N";
		var reasondr=retarr[0];
		var advicetxt=retarr[2];
		var factxt=retarr[1];
		var phnote=retarr[3];
		var User=session['LOGON.USERID'] ;
		var grpdr=session['LOGON.GROUPID'] ;
		
		
		var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+prescno+"^OR" ;  //orditm;
		
		if (reasondr.indexOf("$$$")=="-1")
		{
			reasondr=reasondr+"$$$"+prescno ;
		}
		
		 var getmethod=document.getElementById('mrefDisp');
	     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	     var retval=cspRunServerMethod(encmeth,reasondr,input)
	     if(retval==0)
	     {
		     alert("拒绝成功")
	      	 noconfirm=1;
	     }
	     else
	     {alert("拒绝失败")}
	     var PmiNo=document.getElementById("TPmiNoz"+SelectedRow).innerText
         var pminoObj=document.getElementById('CPmiNo');
         if(pminoObj)pminoObj.value=PmiNo
         Find_click();
       

}
function BDisp_click()
{
	   
	   
	 if (objtbl.rows.length-1==0) {alert("没有病人信息"); setFocusCardNo(); return }
	 var SpeLocID=document.getElementById("SpeLocID").value;
	 if ((SpeLocID!="")&&(SpeLocID!="undefined")){
		 alert("您选择的记录为基数药,请使用全发功能生成补货单!")
		 return ;
	 }
	 var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText
	 var adtresult=ChkAdtResult(prescno) ;   //LiangQiang 2014-12-22  处方审核
	 
     if (adtresult==""){
	     alert("请先审核!")
	     return;
     }

     if (adtresult=="N"){
	     alert("提示：该处方审核不通过,禁止发药!")
	     return;
     } 
     
     if (adtresult=="S"){

       if(!confirm("提示：该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。"))
       {return;}
	 
     }

       var ref = GetPrescNoRefRet(prescno);　　 //LiangQiang 2014-12-22  处方拒绝

       if (ref=="N"){
	     alert("提示：该处方已被拒绝,禁止发药!")
	     return;
     　} 
     
       if (ref=="A"){
	     alert("提示：该处方已被拒绝,禁止发药!")
	     return;
     　} 
     
       if (ref=="S"){

       if(!confirm("提示：该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。"))
       {return;}
	 
       }
         

	//调用大通合理用药接口start
		

	// 调用大通合理用药接口end
     
	 
	 var ret=Dispensing(SelectedRow,"")
	 
	 if (ret>0)
	 {
		 PrintPresc(ret);
	 } 
	 ChkUnFyOtherLoc(); //检测其他科室
   }
   
   //updflag: 非空表示为直接发药
function InsertIntoPhd(CurrRow,updflag)
{
	
	 var rownum,Rrow,prt,name,pmino,printflag,inv;
	 var patprt=document.getElementById("TPrtz"+CurrRow).value
	 var name=document.getElementById("TPatNamez"+CurrRow).innerText
	 var pmino=document.getElementById("TPmiNoz"+CurrRow).innerText
	 var printflag=document.getElementById("TPrintFlagz"+CurrRow).innerText
	 var prescno=document.getElementById("TPrescNoz"+CurrRow).innerText
	 var inv=document.getElementById("TPrtInvz"+CurrRow).innerText
	 var shdr=document.getElementById("CSHDR").value
	 var newwin=""
	 var payflag=0 ;
	 var action="A"
	 //var getmethod=document.getElementById('print');
	 var getmethod=document.getElementById('savedata');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};

     
     var retval=0
     
    
     retval=cspRunServerMethod(encmeth,patprt,GPhl,GPhw,GPydr,GFydr,prescno,GPhwPos,shdr,newwin,RealOrdStr,updflag)
     
	 return retval
	
}


function BAllDisp_click()
{
	 
	 var TblRow=objtbl.rows.length-1

	 if (TblRow==0) {alert(t['nopatientdisp']);return ;}
     fyobj=topFrame.document.getElementById("TFyFlagz"+1)
	 if (fyobj.innerText=="OK"){
		 alert("当前为已发药状态!")
		 return;
	 }	 
	 //发放基数药品,产生基数药补货清单
	 var uselocdr=document.getElementById("TUseLocdrz"+1).value;
	 if (uselocdr!=""){
		 var confirmtext=confirm("确认全发吗?系统将全部发放查询出的所有处方并汇总生成补货单!")
		 if (confirmtext==false) return ;
		 var pid=document.getElementById("TPidz"+1).value;
		 DispAllBaseMed(pid);
		 return;
	 }
	 
	 
	 var confirmtext=confirm("确认全发吗?系统将全部发放查询出的所有处方!")
	 if (confirmtext==false) return ;
	 
     var shdr=""
     AllPresc="";
	 shdr=document.getElementById("CSHDR").value

	 for (var lp=1;lp<TblRow+1;lp++)
	 {
	 	  /// 检查处方审核结果;
		  var prescno=document.getElementById("TPrescNoz"+lp).innerText;
		  if(!checkPrescMonitorRes(prescno)){
			 continue;}
	
		  var ret=Dispensing(lp,"U")
	
		  if (ret>0)
		  {
			  if (AllPresc=="")
			  {
				  AllPresc=ret
			  }
			  else
			  {
				  AllPresc=AllPresc+"^"+ret
			  }
		  }
		 
	 }

	 if (AllPresc==""){return;}

	 PrintPresc(AllPresc);
	 ChkUnFyOtherLoc(); //检测其他科室
	 
	 
}

function PrintAll_click(Rrow)
  {
	 
	 var rownum,Rrow,prt,name,pmino,printflag,inv;
	 var patprt=document.getElementById("TPrtz"+Rrow).value
	 name==document.getElementById("TPatNamez"+Rrow).innerText
	 pmino=document.getElementById("TPmiNoz"+Rrow).innerText
	 printflag=document.getElementById("TPrintFlagz"+Rrow).innerText
	 var prescno=document.getElementById("TPrescNoz"+Rrow).innerText
	 inv=document.getElementById("TPrtInvz"+Rrow).innerText
	 var ctloc=document.getElementById('ctloc').value;
	 
	 var getmethod=document.getElementById('chkc');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     if (cspRunServerMethod(encmeth,ctloc,patprt,prescno)=='1'){
	 alert(t['medisless']);return -1;}

	
	 var getmethod=document.getElementById('print');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,patprt,GPhl,GPhw,GPydr,GFydr,prescno,GPhwPos)

    
     if (retval=="-1"){alert(t['haduse']);window.location.reload();return -1 ;}
	 if (retval=="-2"){alert(t['haddisp']);window.location.reload();return -1 ;}

	 var printobj=document.getElementById("TPrintFlagz"+Rrow)
	     printobj.innerText="OK"
	     
	 
	 if (OldPresc!=prescno)
     {
			 if (AllPresc!="")
		     {	
		          if (OldPatprt==patprt)
	               {
		          
		             AllPresc=AllPresc+"^"+prescno
	               }

	               if (OldPatprt!=patprt)
	               {
		             AllPresc=AllPresc+"||"+patprt+"&"+prescno  
	               }
		     }
		     
		     if (AllPresc=="")
		     {
			     AllPresc=patprt+"&"+prescno
			       
		     }
	     
	     
     }
     
	 
     OldPresc=prescno
     OldPatprt=patprt 
     
     return 0;   
 
}

function PrintPYD()
{
          
          
          if (AllPresc=="") {return;}
          
          //alert(AllPresc)
          
          
          //-------自定义纸张 lq
          var papersize=0 ;
          //var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
          //var papersize=paperset.GetPaperInfo("mzpyd");
          //alert(papersize);

          //-------
          
          cyflag=document.getElementById("cyflag").value
          var pyname=document.getElementById('PPyName').innerText
          var fyname=document.getElementById('PFyName').innerText
          
	      var tmparr=AllPresc.split("||")
	     
	       ///每个发票
	      for (tmpi=0;tmpi<=tmparr.length-1;tmpi++)
	       {
		       
		       var Template=gPrnpath+"DHCOutPydItm_QHD.xls";
		       var xlApp = new ActiveXObject("Excel.Application");
		       var xlBook = xlApp.Workbooks.Add(Template);
		       var xlsheet = xlBook.ActiveSheet ;
		       var Startrow=3;
		       var Printrow=3;
		       var descnum=0;
		       var totalsum=0;

		       var tmpstr=tmparr[tmpi]
	
		       var tmparr1=tmpstr.split("&")
		       
		       var tmpstr1=tmparr1[0] //发票
		       var tmpstr2=tmparr1[1] //处方号串
		       
		       var tmparr2=tmpstr2.split("^")
		       
		       var pydate;
		       
		       ///每个方号
		       for (tmpj=0;tmpj<=tmparr2.length-1;tmpj++)
		        {

			          var tmpstr3=tmparr2[tmpj] //单个处方号
			         
			          var prescno=tmpstr3
			          
			         // alert(prescno)
			          
			          var patprt=tmpstr1
			        
			          var getmethod=document.getElementById('getpatientinf');
	                  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	                  var retval=cspRunServerMethod(encmeth,prescno,patprt,GPhl)
	                  
	                 // alert(retval)
	                
	             	  var sstr1=retval.split("^")

				      var patname=sstr1[0]
				      var patno=sstr1[1]
				      var prtinv=sstr1[3]
				      var kfdate=sstr1[2]
				      var patprt=sstr1[4]
				      var patpresc=sstr1[5]
				      var patsex=sstr1[6]
				      var patage=sstr1[7]
				      var patloc=sstr1[8]
				      var paticd=sstr1[9]
				      var presctype=sstr1[10]
				      var windesc=sstr1[11]
				      var kjdate=sstr1[2]
				      var patid=sstr1[12]
				      var fs=sstr1[13]
				      var jytype=sstr1[14]
				      var callcode=sstr1[15]
				      var patadd=sstr1[16]
				      var presctitle=sstr1[17]
				      var pydate=sstr1[21]
				      var doctor=sstr1[24]
		
				      var childtype=""
                      var lyear=patage.split(t['year'])
                      var persui=lyear[0]
                      if (persui=='') persui=0
                      if (persui<15) childtype="1"

		          
		          //}
		          
		           xlsheet.Cells(2, 1).Value ="姓名:"+patname+" 性别:"+patsex+" 年龄:"+patage+" 登记号:"+patno+" 发票号:"+prtinv
		           //草药处方
   	      		   if (cyflag=="1"){CYFreePrintPerOrd(patname,patno,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,kjdate,windesc,patid,fs,jytype,prtinv,callcode,patadd,presctitle,pydate)}
   	      		   
   	      		   //西药摆药单
	               if (cyflag!="1") 
	                     { 
	               
								
								var getmethod=document.getElementById('getperordrows');
							    if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
							    var retval=cspRunServerMethod(encmeth,GPhl,patprt,patpresc)
							    
							    //alert(prescno)
							    //alert(patprt)
							    //alert(patpresc)
							    //alert(retval)
							    
							    var LStr=retval.split(GStrCode)
							    var OrdRows=LStr.length
							    
							    for (m=1;m<OrdRows+1;m++)
							    {
							             
							            var descnum=descnum+1
							            
							    		var SOrd=LStr[m-1];
							    		
							    		
							    	  
							       	    var SStr=SOrd.split("^")
							       	    
							       	    meddesc=SStr[0]
							       	    spec=""
							       	    
							       	    if(meddesc.indexOf("(")!=-1)
							       	    {
									       	var medarr=SStr[0].split("(")
								       	    var meddesc=medarr[0] //药名
								       	    var specstr=medarr[1]
								       	    var specarr=specstr.split(")")
								       	    var spec=specarr[0] //规格
							       	    }

			                            
										xlsheet.Cells(Printrow+m, 1).Value = descnum ;
										xlsheet.Cells(Printrow+m, 2).Value = meddesc ;
										xlsheet.Cells(Printrow+m, 3).Value =spec
										xlsheet.Cells(Printrow+m, 4).Value =SStr[2];
										xlsheet.Cells(Printrow+m, 5).Value =SStr[1];
										xlsheet.Cells(Printrow+m, 6).Value =SStr[6];
										xlsheet.Cells(Printrow+m, 7).Value =SStr[7];
										xlsheet.Cells(Printrow+m, 8).Value =SStr[23];
										
										Printrow=Printrow+1
														
										var descstr="用法用量:每次"+SStr[3]+" "+SStr[5]+" "+SStr[4] ;
										
										xlsheet.Cells(Printrow+m, 3).Value =descstr;
										
										setBottomLine(xlsheet,Printrow+m,1,8);

										totalsum=totalsum+parseFloat(SStr[7])
				                         
				                        //Printrow = Printrow+1 
				                       
							       	    
							    } 
							    
						                
	               
	                    } // (cyflag!="1")到此结束
	                    
	                    
	                  if (cyflag!="1") Printrow = Printrow +m-1   // 不同处方 
	              }
	              
	               
	               if (cyflag!="1")
	               {
		               xlsheet.Cells(Printrow+1, 1).Value ="配药人:"+pyname+"  发药人:"+fyname+"  医生:"+doctor
		               
		               xlsheet.Cells(Printrow+2, 1).Value ="总金额合计:"+totalsum.toFixed(2) +"  "
		               
		               xlsheet.Cells(Printrow+2, 4).Value ="发药时间:"+pydate 
		               
		               
		               if (papersize!=0){
	                   xlsheet.PageSetup.PaperSize = papersize;}
		               
		               xlsheet.printout();
		               
		               SetNothing(xlApp,xlBook,xlsheet)
	               
	               }
                   
		       
	       }
	       
	   
	       
     
	       
}
function setBottomLine(objSheet,row,startcol,colnum)
{
	
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
    
}


function SetNothing(app,book,sheet)
{
        app=null;
        book.Close(savechanges=false);
        sheet=null;
}


 function Print_click(Rrow)
  {
	  
	 var rownum,Rrow,prt,name,pmino,printflag,inv;
	 var patprt=document.getElementById("TPrtz"+Rrow).value
	 name==document.getElementById("TPatNamez"+Rrow).innerText
	 pmino=document.getElementById("TPmiNoz"+Rrow).innerText
	 printflag=document.getElementById("TPrintFlagz"+Rrow).innerText
	 var prescno=document.getElementById("TPrescNoz"+Rrow).innerText
	 inv=document.getElementById("TPrtInvz"+Rrow).innerText
	 var ctloc=document.getElementById('ctloc').value;
	 
     /*
	 var getmethod=document.getElementById('chkc');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     if (cspRunServerMethod(encmeth,ctloc,patprt,prescno)=='1'){
	 alert(t['medisless']);return ;}
	   */

	 var getmethod=document.getElementById('print');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,patprt,GPhl,GPhw,GPydr,GFydr,prescno,GPhwPos)

    
     if (retval=="-1"){alert(t['haduse']);window.location.reload();return ;}
	 if (retval=="-2"){alert(t['haddisp']);window.location.reload();return ;}
	  
	 var printobj=document.getElementById("TPrintFlagz"+Rrow)
	     printobj.innerText="OK"
     var reprintflag=""
     var getmethod=document.getElementById('getpatientinf');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var retval=cspRunServerMethod(encmeth,prescno,patprt,GPhl)
      var sstr1=retval.split("^")
      var patname=sstr1[0];
      var patno=sstr1[1]
      var prtinv=sstr1[3]
      var patprt=sstr1[4]
      var patpresc=sstr1[5]
      var patsex=sstr1[6]
      var patage=sstr1[7]
      var patloc=sstr1[8]
      var paticd=sstr1[9]
      var presctype=sstr1[10]
      var windesc=sstr1[11]
      var kjdate=sstr1[2]
      var patid=sstr1[12]
      var fs=sstr1[13]
      var jytype=sstr1[14]
      var callcode=sstr1[15]
      var patadd=sstr1[16]
      var presctitle=sstr1[17]
      var pydate=sstr1[21]
     
     
      var childtype=""
     
      var lyear=patage.split(t['year'])
      var persui=lyear[0]
      // patienname_"^"_papmino_"^"_printdatetime_"^"_prtcode_"^"_prt_"^"_prescno_"^"_papsex_"^"_perold_"^"_deplocdesc_"^"_mricd_"^"_presctype_"^"_phwdesc_"^"_patid_"^"_cffs_"^"_jytype
      if (persui=='') persui=0
      if (persui<15) childtype="1"
          
	  cyflag=document.getElementById("cyflag").value
   	  if (cyflag=="1"){CYFreePrintPerOrd(patname,patno,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,kjdate,windesc,patid,fs,jytype,prtinv,callcode,patadd,presctitle,pydate)}
	  else {
		  
		  AllPresc=patprt+"&"+patpresc
		  PrintPYD();
	     // FreePrintPerOrd(patname,patno,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,kjdate,windesc,patid,prtinv,callcode,patadd,presctitle,reprintflag);
	   }
	   
	   

} 

function ginf(value)
{
	alert(value)
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


function Find_click()
{
 var myrow=tbl.rows.length;
 var rr;
 var fy;
 var checkfy=document.getElementById("CFyFin").checked
 if (checkfy==true){ fy="1";}
 else {fy="0";}
 var MyFlag="0";
 if (tbl.rows.length>1)
   { for (rr=1;rr<=myrow-1;rr++){
	 	var fyflag=document.getElementById("TFyFlagz"+rr).innerText  
        var prescno=document.getElementById("TPrescNoz"+rr).innerText
	  	var ref = GetPrescNoRefRet(prescno);　　 //LiangQiang 2014-12-22  处方拒绝
	   	if ((fyflag!="OK")&(ref!="N")&(ref!="A")){MyFlag="1"}
	   }
   }
  if (noconfirm==1){
		MyFlag="0"
	}
		
  if (MyFlag=="1"){ var ret=confirm(t['hadundisppat'])
  if (ret==true){return 0;}}
  noconfirm=0;
  var stdate=document.getElementById("CDateSt").value;
  var enddate=document.getElementById("CDateEnd").value;
  var GPhl=document.getElementById("GPhl").value;
  var GPhw=document.getElementById("GPhw").value;
  var CPmiNo=document.getElementById("CPmiNo").value;   

  var obj=document.getElementById("CPatName")
  var CPatName=""
  if (obj)  CPatName=obj.value;
  
  
   var objspec=document.getElementById("SpecialID")
  if (objspec) spec=objspec.value;
  
  var objspeclocid=document.getElementById("SpeLocID")
  if (objspeclocid) speclocid=objspeclocid.value;
  
  var specString=spec+"^"+speclocid ;

  var SpeLocTxt="";
  var objspec=document.getElementById("SpeLoc")	
  if (objspec)SpeLocTxt=objspec.value;
  
  var SpecialTxt="";
  var objSpecial=document.getElementById("Special")	
  if (objSpecial)SpecialTxt=objSpecial.value;
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDisp&CDateSt="+stdate+"&CDateEnd="+enddate+"&GPhl="+GPhl+"&GPhw="+GPhw+"&CPmiNo="+CPmiNo+"&CPatName="+CPatName+"&GPydr="+GPydr+"&GFydr="+GFydr+"&GPhwPos="+GPhwPos+"&Fin="+fy+"&specString="+specString+"&CFyFin="+fy+"&SpeLoc="+SpeLocTxt+"&SpeLocID="+speclocid+"&Special="+SpecialTxt+"&SpecialID="+spec+"&CPatNo="+CPmiNo;
  topFrame.location.href=lnk;

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


function GetCardInf()
{
 var key=websys_getKey(e);
 if (key==13) {	 
	var cardno=document.getElementById('CardNo').value
	var getmethod=document.getElementById('getpmifrcard');
	if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	var retval=cspRunServerMethod(encmeth,cardno);
	document.getElementById('CPmiNo').value=retval
	Find_click()
 }	
}
 function RowClick()
 {
   	var prt=document.getElementById("TPrtz"+1).value
   	var prescno=document.getElementById("TPrescNoz"+1).innerText
   	var fyflag=document.getElementById("TFyFlagz"+1).innerText
   	var phdrowid=document.getElementById("Tphdz"+1).value
   	var flag;
	if (fyflag=="OK"){flag="1";}
	else
	flag=""
 	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispsub&rPHL="+GPhl+"&rPRT="+prt+"&rFLAG="+flag+"&rPrescNo="+prescno+"&rPhdrow="+phdrowid;
 	bottomFrame.location.href=lnk;
	SelectedRow = 1;
	SetColorAfterFind();
    PassDaTong(1);  //大通
    var cardnoobj=document.getElementById("CardNo");
	if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
	else { DHCMZYF_setfocus('CPmiNo');}

 }
function DHCMZYF_setfocus(objName) {
	window.setTimeout('DHCMZYF_setfocus2(\''+objName+'\')',300);
}

function DHCMZYF_setfocus2(objName) {
	var obj=document.getElementById(objName);
	if (obj) {
		try {obj.focus();obj.select();	} catch(e) {}  }
    }




function CheckChinese(char1){
	if(escape(char1).indexOf("%u")!=-1) return true;
	return false;
}

function GetStrLength(str){
	var len=str.length;
	var len1=0;
	for (var j=0;j<len;j++) {
		var char1=str.substring(j,j+1);
		if (CheckChinese(char1)) {len1=len1+2}else{len1=len1+1	}
	return len1;
	}
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
		//DHCWeb_DisBtnA("CReadCard");
		var obj=document.getElementById("CReadCard");
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
		var obj=document.getElementById("CReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCMZYF_setfocus("CardNo");
	}else{
		DHCMZYF_setfocus("CReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}


function ReadHFMagCard_ClickOld()
{
	
	var myCardTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	if (m_SelectCardTypeDR==""){
		var myrtn=DHCACC_GetAccInfo();
	}else{
		var myrtn=DHCACC_GetAccInfo5(m_SelectCardTypeDR,myCardTypeValue);
	}
    alert(myary)
	var myary=myrtn.split("^");
	var rtn=myary[0];
   // alert("卡号?"+myary[1]);
	//alert(myary[5]);
	if (rtn=="-1") {alert(t['72']);return ;}
	else
	{	var obj=document.getElementById("CPmiNo");
			if (obj) obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			if (obj) obj.value=myary[1];
			
			Find_click();
	}

}



function GetCardEqRowId(){
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	
	return m_SelectCardTypeDR;
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
			alert(t['35']);
			websys_setfocus('CPmiNo');
			return;
	}
	
	
	var myary=myrtn.split("^");
	var rtn=myary[0];
	
	switch (rtn){
		case "0": //卡有效
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				var obj=document.getElementById("CPmiNo");
				if (obj) obj.value=myary[5];
				var obj=document.getElementById("CardNo");
				if (obj) obj.value=myary[1];
			
				Find_click();
			break;
		case "-200": //卡无效
			alert(t['35']);
			websys_setfocus('CPmiNo');
			break;
		case "-201": //现金
			//alert(t['21']);
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var obj=document.getElementById("CPmiNo");
				if (obj) obj.value=myary[5];
				var obj=document.getElementById("CardNo");
				if (obj) obj.value=myary[1];
			
				Find_click();
				
			break;
		default:
	}
	
	if (rtn=="-1") {alert("卡错误");return ;}
	else
	{	
	}
	
	

}



///回车卡号  LiangQiang
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
      if (patno=="-1"){
	  	alert("此卡无效!");
	  	cardobj.value=""
	  	return;
	  }
      var patnoobj=document.getElementById('CPmiNo');
      if (patnoobj)
      {
	      patnoobj.value=patno;
      }

	  Find_click();
	  cardobj.value="";

}


///在查找以后自动选中首行,改变背景色 LiangQiang
function SetColorAfterFind()
{
   var  fyflag=document.getElementById("TFyFlagz"+SelectedRow).innerText
   if (tbl.rows.length>1){
	  for (var i=1;i<=tbl.rows.length-1;i++)
	  {
		  var  fyflag=document.getElementById("TFyFlagz"+i).innerText
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

///检验配药数量是否合法
///
///
function CheckDispQty()
{
	
	var retValue=0
	subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispSub');
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


    }
    
   
    return retValue; 
    
    
}


///获取医嘱实发数量字符串
///Output:是否需要欠药+"&&"+是否全部欠药+"&&"+获到每个医嘱ID+"^"+实发数量+"^"+医嘱数量+"^"+单位ID
///
function GetDispQtyString()
{
	var chkflag=0,allowe=1
	var retString=0
	subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispSub');
	if (subtblobj.rows.length==1) {return 0;}
    for (var i=1;i<=subtblobj.rows.length-1;i++)
    { 

         var realqty=0
         
         var  qtyobj=bottomFrame.document.getElementById("TPhQtyz"+i)
         if (qtyobj) 
         {
	         qty=qtyobj.innerText;
	         realqty=qty;
         }
         
         var  realqtyobj=bottomFrame.document.getElementById("TRealQtyz"+i)
         if (realqtyobj)
         {
	         realqty=trim(realqtyobj.value);
         }
         
         if (realqty!=qty) {var chkflag=1}
         if (realqty!=0) {allowe=0 }         
	     var  itmobj=bottomFrame.document.getElementById("TOrditmz"+i)
	     if (itmobj)
	     {
		     
		     oeori=itmobj.value
		     var unit=""
		     var  unitobj=bottomFrame.document.getElementById("TUnitz"+i)
		     if (unitobj) unit=unitobj.value;
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

//发全部基数药品
function DispAllBaseMed(pid)
{
	    var getmethod=document.getElementById('mDispAllBaseMed'); //发药
        if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
        var retval=cspRunServerMethod(encmeth,pid,GFydr,GPhl)
        if (retval>0){
	        PrtSupplyList(retval);
	        ReloadAfterDisp();
        }
        
}


function PrtSupplyList(rowid)
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrintCom"+"&supp="+rowid
	parent.frames['DHCOutPhPrintCom'].window.document.location.href=lnk;	
}



///发药后刷新
function ReloadAfterDisp()
{
  var myrow=tbl.rows.length;
  var rr;
  var fy;
  var checkfy=document.getElementById("CFyFin").checked
  if (checkfy==true){ fy="1";}
  else {fy="0";}
     
  var MyFlag="0";

  var stdate=document.getElementById("CDateSt").value;
  var enddate=document.getElementById("CDateEnd").value;
  var GPhl=document.getElementById("GPhl").value;
  var GPhw=document.getElementById("GPhw").value;

  var CPmiNo=document.getElementById("CPmiNo").value;   

  var obj=document.getElementById("CPatName")
  var CPatName=""
  if (obj)  CPatName=obj.value;
  
  
  var objspec=document.getElementById("SpecialID")
  if (objspec) spec=objspec.value;
  
  var objspeclocid=document.getElementById("SpeLocID")
  if (objspeclocid) speclocid=objspeclocid.value;
  
  var specString=spec+"^"+speclocid ;

  var SpeLocTxt="";
  var objspec=document.getElementById("SpeLoc")	
  if (objspec)SpeLocTxt=objspec.value;
  
  var SpecialTxt="";
  var objSpecial=document.getElementById("Special")	
  if (objSpecial)SpecialTxt=objSpecial.value;
  
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDisp&CDateSt="+stdate+"&CDateEnd="+enddate+"&GPhl="+GPhl+"&GPhw="+GPhw+"&CPmiNo="+CPmiNo+"&CPatName="+CPatName+"&GPydr="+GPydr+"&GFydr="+GFydr+"&GPhwPos="+GPhwPos+"&Fin="+fy+"&specString="+specString+"&CFyFin="+fy+"&SpeLoc="+SpeLocTxt+"&SpeLocID="+speclocid+"&Special="+SpecialTxt+"&SpecialID="+spec;
  topFrame.location.href=lnk;
  
}



function popSpeLoc()
{ 
    
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  SpeLoc_lookuphandler();
	}
}

function SpeLocLookupSelect(str)
{	
    
	var tmp=str.split("^");
	var obj=document.getElementById("SpeLocID");
	if (obj)
	{
		if (tmp.length>0)   obj.value=tmp[1] ;
		else  obj.value="" ; 
	}

}

function SpeLocCheck()
{
 var obj=document.getElementById("SpeLoc");
 var obj2=document.getElementById("SpeLocID");
 if (obj) 
 {
	 if (obj.value=="") {
		 obj2.value="" ;
       
	 }
  }
}


function popSpecial()
{ 
    
	if (window.event.keyCode==13) 
	{ 
	  window.event.keyCode=117;
	  Special_lookuphandler();
	}
}


function SpecialLookupSelect(str)
{
	var tmp=str.split("^");
	var obj=document.getElementById("SpecialID");
	if (obj)
	{
		if (tmp.length>0)   obj.value=tmp[1] ;
		else  obj.value="" ; 
	}
}

function SpecialCheck()
{
 var obj=document.getElementById("Special");
 var obj2=document.getElementById("SpecialID");
 if (obj) 
 {
	 if (obj.value=="") {
		 obj2.value="" ;
	 }
  }
}






///打印程序专区 新的用 PrintPresc ,其余的做参考

function PrintPresc(phdrowid)
{
	
	cyflag=document.getElementById("cyflag").value
   	//if (cyflag=="1") {PrintPrescCY(phdrowid);}
	//else {PrintPrescXY(phdrowid);}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrintCom"+"&phdrowid="+phdrowid+"&cyflag="+cyflag
	parent.frames['DHCOutPhPrintCom'].window.document.location.href=lnk;

}







function FreePrintPerOrd(patname,patpmi,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,kjdate,windesc,patid,prtinv,callcode,patadd,presctitle,reprintflag)
{
	 var pyname=document.getElementById('PPyName').innerText
	   var getmethod=document.getElementById('getperordrows');
    if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
   
 
  
    var retval=cspRunServerMethod(encmeth,GPhl,patprt,patpresc)
    alert(retval)
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
     var lmseq=0
     var totalmoney=0
  
     var SeqArray= new Array()
    	
    	for (m=1;m<OrdRows+1;m++)
    	{
    		
    		
    		var SOrd=LStr[m-1];
    	
       	var SStr=SOrd.split("^")
       	
       	pc[m]=new Array();
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
   		totalmoney=totalmoney.toFixed(2);
   		   
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
	    MyPara=MyPara+"PrescNo"+String.fromCharCode(2)+"*"+patpresc+"*";
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
	    //MyPara=MyPara+"^DoctCode"+String.fromCharCode(2)+doctcode;
	   MyPara=MyPara+"^PatCall"+String.fromCharCode(2)+callcode;
	    MyPara=MyPara+"^PatAdd"+String.fromCharCode(2)+patadd;

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
	 //	alert(MyPara)
   
	  var myobj=document.getElementById("ClsBillPrint");
	    DHCP_PrintFun(myobj,MyPara,MyList);	
  	
    	
    

	    return 0;
    
	
}	 
	
function CYFreePrintPerOrd(patname,patpmi,patprt,patpresc,patsex,patage,patloc,paticd,childtype,presctype,kjdate,windesc,patid,fs,jytype,prtinv,callcode,patadd,presctitle,pydate)
{
	   
	   GUserCode=document.getElementById('PPyName').innerText
	   fyname=document.getElementById('PFyName').innerText	
	   //var getmethod=document.getElementById('getbox');
	   //if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	   //var boxnum=cspRunServerMethod(encmeth,GPhl,patprt,patpresc)
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
       	
       	//alert(SOrd)
       	
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
        var mfsl=parseFloat(SStr[2])/parseFloat(fs)
        
        
        pc[i][1]=SStr[0]+""+SStr[12]+""+mfsl.toString()+SStr[1]+" "+SStr[6]
        
        
        //pc[i][2]=SStr[12]; //备注
        
       	//pc[i][3]=mfsl.toString()+SStr[1]+" "+SStr[6] //数量
       	//parseFloat(SStr[2])/parseFloat(fs)+SStr[1];
       	
       	
       	
       	//pc[i][4]=SStr[6] //单价

       	PrescYF=SStr[4]
       	
       	PrescPC=SStr[5]
       	totalmoney=totalmoney+parseFloat(SStr[7]);//金额
       	//jrflag=SStr[8]; //毒麻分类
       	doctname=SStr[10];
       	
       	PrescYL=SStr[13]
       	
        }
      
        var yfpc="共"+fs+"剂"+" "+"用法:"+PrescYF+"  一次用量:"+PrescYL+" "+PrescPC
       
        var singlemoney=(totalmoney/parseFloat(fs)).toFixed(2)
        
        totalmoney=totalmoney.toFixed(2);
        
        totalmoney="一付金额:"+singlemoney+"  合计金额:"+totalmoney+"   "
        
        var yfpc=yfpc+"  "+totalmoney
        
        GUserCode=document.getElementById('PPyName').innerText
	    fyname=document.getElementById('PFyName').innerText	
	    
	    var lastrow="配药人:"+GUserCode+"     发药人:"+fyname+"     发药时间:"+pydate
        
        var MyPara="";
        var MyList=""  
	    MyPara=MyPara+"PrescNo"+String.fromCharCode(2)+patpresc//"*"+patpresc+"*";
	    MyPara=MyPara+"^PatNo"+String.fromCharCode(2)+patpmi//"*"+patpmi+"*";
	    MyPara=MyPara+"^PatLoc"+String.fromCharCode(2)+patloc;
    	MyPara=MyPara+"^PyName"+String.fromCharCode(2)+GUserCode;  		    	
	    MyPara=MyPara+"^PatName"+String.fromCharCode(2)+patname;
	    MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+patsex;
	    MyPara=MyPara+"^Doctor"+String.fromCharCode(2)+doctname;
	    MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+patage;
	    MyPara=MyPara+"^jytype"+String.fromCharCode(2)+jytype;
	    MyPara=MyPara+"^AdmDate"+String.fromCharCode(2)+kjdate;
	    MyPara=MyPara+"^PatICD"+String.fromCharCode(2)+paticd;
	    MyPara=MyPara+"^PatCall"+String.fromCharCode(2)+callcode;
	    MyPara=MyPara+"^PatAdd"+String.fromCharCode(2)+patadd;

	    MyPara=MyPara+"^TotalMoney"+String.fromCharCode(2)+lastrow;
	    MyPara=MyPara+"^YFSM"+String.fromCharCode(2)+yfpc;
	  
	    var k=0;
	   
	    for (k=1;k<OrdRows+1;k++)
	      {
		    
		     var l=0;
		     for (l=1;l<2;l++)
		      {
			    //alert(pc[k-1][l])
		        MyPara=MyPara+"^txt"+k+l+String.fromCharCode(2)+pc[k-1][l]; 
		      }
	      }
	      
	    childtype=""
	      
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
function PrintTitle(row)
 {
  ctloc=document.getElementById('ctloc').value
  var patname=document.getElementById('TPatNamez'+row).innerText
  var patsex=document.getElementById('TPatSexz'+row).innerText
  var patage=document.getElementById('TPatAgez'+row).innerText
  var prt=document.getElementById('TPrtz'+row).value
  var prescno=document.getElementById('TPrescNoz'+row).innerText
  var windesc=""
  //document.getElementById('PWinDesc').innerText;
  //var prtdatetime=prtdate+" "+prttime
   var getmethod=document.getElementById('getsysdate');
       if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
       var sysdate=cspRunServerMethod(encmeth)
 
 
    var getmethod=document.getElementById('getperordrows');
    if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,GPhl,prt,prescno)
    var LStr=retval.split(GStrCode)
    var OrdRows=LStr.length
	 for (var li=1;li<OrdRows+1;li++)
	 { 
	   		var SOrd=LStr[li-1];
    	
       	var SStr=SOrd.split("^")

	  var yfdesc=SStr[4]
	 	 if (yfdesc!=''){
		 	 
	   var getmethod=document.getElementById('checkprinttitle');
       if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
       var retval=cspRunServerMethod(encmeth,ctloc,yfdesc)
      }
       if (retval=="1") {
           var phdesc=SStr[0]
	       var pc=SStr[5]
	       var jl=SStr[3]
           var qty=SStr[2]
           var uom=SStr[1]
           var qtyuom=qty+uom
 	       var xh=li+"/"+OrdRows
 	      
	      PrintTitleXML(xh,patname,patsex,patage,sysdate,windesc,phdesc,qtyuom,yfdesc,pc,jl); 
       }
       
       
	 }
   	 
 }


 function  PrintTitleXML(xh,patname,patsex,patage,prtdatetime,windesc,phdesc,qtyuom,yfdesc,pc,jl)
 {
 	
	  var MyPara="";
      var MyList=""  
      var allyf=yfdesc+" "+pc+" 每次"+jl
     var allphdesc=""
     var allphdesc=phdesc
     //+"/"+qtyuom
 	  DHCP_GetXMLConfig("InvPrintEncrypt","DHCOutPharmacyKFBQ")

	    MyPara=MyPara+"PatName"+String.fromCharCode(2)+patname;
	    MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+patsex;
	    MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+patage;
	    MyPara=MyPara+"^RQ"+String.fromCharCode(2)+prtdatetime;
       // MyPara=MyPara+"^XH"+String.fromCharCode(2)+xh;
       // MyPara=MyPara+"^win"+String.fromCharCode(2)+windesc;
        MyPara=MyPara+"^PhDesc"+String.fromCharCode(2)+allphdesc;
      MyPara=MyPara+"^PhQtyUom"+String.fromCharCode(2)+qtyuom;
        MyPara=MyPara+"^ALLYF"+String.fromCharCode(2)+allyf;
       // MyPara=MyPara+"^PINC"+String.fromCharCode(2)+pc;
       // MyPara=MyPara+"^JL"+String.fromCharCode(2)+jl;
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFun(myobj,MyPara,MyList);	
    
	 
	 
 }
 
 //检查审核结果
function ChkAdtResult(prescno)
{
      	var getmethod=document.getElementById('mChkAdtResult');
        if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
        var retval=cspRunServerMethod(encmeth,prescno)
        return retval ;
      
}

 
function GetDaTong()
{

    if (GetGetDaTongConfig()!="Y") return;
    
    var cnt=0
	var objtbl=document.getElementById("t"+"DHCST_PIVA_CHEMAUDIT");
    if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return;
    
    //dtywzxUI(0,0,"");
    dtywzxUI(3,0,"");
    var oeori="" ;
    var seqno=""
    var passordstr="" ;
    
    var objPid=document.getElementById("tPid"+"z"+1);
    var pid=objPid.value;
  
    var objtmp=document.getElementById("mListPassOrd");
    if (objtmp) {var encmeth=objtmp.value;} else {var encmeth='';}
    
    do 
       {
          var myrtn=""
	      //var passordstr=cspRunServerMethod(encmeth,pid,oeori);
	      var passordstr=cspRunServerMethod(encmeth,pid,seqno);
	      if (passordstr!="")
	      {
		      if (passordstr.indexOf("#")>-1)
		      {
			          dtywzxUI(3,0,"");
				      var  tmpstr=passordstr.split("#")
				      var  passrow=tmpstr[0];
				      var  ordstr=tmpstr[1];
				      var  seqno=passrow;
				      var objDaTongPresc=document.getElementById("mDaTongPresc");
					  if (objDaTongPresc) {var encmeth1=objDaTongPresc.value;} else {var encmeth1='';}
					  var myPrescXML=cspRunServerMethod(encmeth1,ordstr);
					  
					  //if (ordstr=="1088230||417"){ alert(ordstr)}
					  
					  myrtn=dtywzxUI(28676,1,myPrescXML);
					  
					  //if (ordstr=="1088230||417"){ alert(myrtn)}
					  
					  var ret=""
					  if (myrtn==0) {ret="正常"}
					  if (myrtn==1) {ret="一般问题"}
					  if (myrtn==2) {ret="严重问题"}
					  
					  
					  var obj=document.getElementById("tPassCheck"+"z"+passrow)
					  obj.innerText=ret
					  
			      	  var tmpordstr=ordstr.split("^")
		              var oeori=tmpordstr[0]
		              
		      }
		      
	      }
	      else
	      
	      { oeori="" } ;
		  

       }while (oeori!="")
	   killTMPafterGetGetDaTong(pid)
     //dtywzxUI(1,0,"");
}

function GetDaTongYDTS()
{
 	var row=selectedRow(window);
 	if (!row) return;
 	if (row<1) return;
 	var objx=document.getElementById("oeori"+"z"+row);
	var oeori=objx.value;
	if (oeori==""){return;}
	//dtywzxUI(0,0,"");
  dtywzxUI(3,0,"");
  var objDaTongPresc=document.getElementById("mDaTongYDTS");
  if (objDaTongPresc) {var encmeth1=objDaTongPresc.value;} else {var encmeth1='';}
	var myPrescXML=cspRunServerMethod(encmeth1,oeori);
	//myrtn=dtywzxUI(4108,0,myPrescXML);
  myrtn=dtywzxUI(12,0,myPrescXML);
  //dtywzxUI(1,0,"");
}

function killTMPafterGetGetDaTong(pid)
{
	var objClearDaTong=document.getElementById("mClearDaTongTmp");
	if (objClearDaTong) {var encmeth1=objClearDaTong.value;} else {var encmeth1='';}
	var ret=cspRunServerMethod(encmeth1,pid);
	
}
function StartDaTongDll()
{
	if (GetGetDaTongConfig()=="Y"){
		
		dtywzxUI(0,0,"");
	}
	
}

function dtywzxUI(nCode,lParam,sXML){
   var result;
   result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);
   return result;
}


/*
获取处方拒绝结果 LiangQiang 2014-12-22
*/
function GetPrescNoRefRet(prescno)
{
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc",prescno);
	return ref;
}



/*
获取大通配置 LiangQiang 2014-12-22
*/
function GetGetDaTongConfig()
{
	var locdr=session['LOGON.CTLOCID'];
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetDaTongConfig",locdr);
	return ref;
}

/*
大通合理用药
*/

function PassDaTong(row)
{
     
         if (GetGetDaTongConfig()!="Y") {return;}
		 var ordstr=""
		 //for (i=1;i<rownum;i++)
		 //{  
		    //var prescno=document.getElementById("TPrescNoz"+row).value;
		    var prescno=document.getElementById("TPrescNoz"+row).innerText
		    dtywzxUI(3,0,"");
                 
	        var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongByOrd", prescno);
	        myrtn=dtywzxUI(28676,1,myPrescXML);
	        if (myrtn==0) {var imgname="greenlight.gif";}
			if (myrtn==1) {var imgname="yellowlight.gif";}
		    if (myrtn==2) {var imgname="blacklight.gif";}
		    
            //var str="<img id='DrugUseImg"+i +"'"+" src='../scripts/dhcpha/img/"+imgname+"'>";
            
            var obj=document.getElementById("TPassCheck"+"z"+row)
	
			 var imgobj= document.createElement("img");
			 imgobj.id="DrugUseImg"+row;
			 imgobj.src="../scripts/dhcpha/img/"+imgname;
			 //imgobj.onclick=tbClick;
			 obj.appendChild(imgobj);
						 
						 

	  
		 //}
	 	 
	 	 
}

/**
*  bianshuai 2015-12-01
*  检查处方的审核状态
*/
function checkPrescMonitorRes(prescno){
	
	var adtresult=ChkAdtResult(prescno) ;   //LiangQiang 2014-12-22  处方审核
	if (adtresult==""){
		alert("提示：处方"+prescno+",未审核,请先审核!");
		return false;
	}

	if (adtresult=="N"){
		alert("提示：处方"+prescno+",该处方审核不通过,禁止发药!");
		return false;
	}

	if (adtresult=="S"){
		if(!confirm("提示：处方"+prescno+",该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。")){
			return false;
		}
	}

	var ref = GetPrescNoRefRet(prescno);　　 //LiangQiang 2014-12-22  处方拒绝

	if (ref=="N"){
		alert("提示：处方"+prescno+",该处方已被拒绝,禁止发药!");
		return false;;
	} 

	if (ref=="A"){
		alert("提示：处方"+prescno+",该处方已被拒绝,禁止发药!");
		return false;
	}

	if (ref=="S"){
		if(!confirm("提示：处方"+prescno+",该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。")){
			return false;
		}
	}
	return true;
}
//检查其他未发药科室
function ChkUnFyOtherLoc()
{
	var stdate=document.getElementById("CDateSt").value;
	var enddate=document.getElementById("CDateEnd").value;
	var pmi=document.getElementById("CPatNo").value; //新建的隐藏元素,读卡时给予提示
	if((pmi=="")||(pmi==null)){
		if(SelectedRow>0){ 
			pmi=document.getElementById("TPmiNoz"+SelectedRow).innerText;
		} 		
	}
	GPhl=document.getElementById("GPhl").value
	//alert(stdate+","+enddate+","+pmi+","+GPhl)
	var ret=tkMakeServerCall("web.DHCOutPhAdd","ChkUnFyOtherLoc",stdate,enddate,pmi,GPhl)
	if(ret==-1){
		//alert("病人为空,请读卡")
	}
	else if(ret==-2)
	{
		alert("没找到登记号为"+pmi+"的病人");
		return;
		
	}
	else if((ret!="")&&(ret!=null))
	{
		alert("该病人在 "+ret+" 有药没取~！")
	}
}
function checkPrescMonitorRes(prescno){
	
	var adtresult=ChkAdtResult(prescno) ;   //LiangQiang 2014-12-22  处方审核
	if (adtresult==""){
		alert("提示：处方"+prescno+",未审核,请先审核!");
		return false;
	}

	if (adtresult=="N"){
		alert("提示：处方"+prescno+",该处方审核不通过,禁止发药!");
		return false;
	}

	if (adtresult=="S"){
		if(!confirm("提示：处方"+prescno+",该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。")){
			return false;
		}
	}

	var ref = GetPrescNoRefRet(prescno);　　 //LiangQiang 2014-12-22  处方拒绝

	if (ref=="N"){
		alert("提示：处方"+prescno+",该处方已被拒绝,禁止发药!");
		return false;;
	} 

	if (ref=="A"){
		alert("提示：处方"+prescno+",该处方已被拒绝,禁止发药!");
		return false;
	}

	if (ref=="S"){
		if(!confirm("提示：处方"+prescno+",该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。")){
			return false;
		}
	}
	return true;
}

///检查是否有拒绝发药权限
function CheckFyUserAuthority(){
    var retval=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CheckFyUserAuthority",GPhl,GFydr);
    return retval;
}
/// 撤销拒绝
function BCancelRefuse_click(){
	
	if(CheckFyUserAuthority() == "0"){
		  alert("提示：该用户没有操作权限,请以上级用户身份撤销!");
		  return;
	}
	
	var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText
	if(prescno==""){
		  alert("请选择要拒绝的处方");
		  return;
	}
	       
    var ref = GetPrescNoRefRet(prescno);　　 //LiangQiang 2014-12-22  处方拒绝

	if ((ref!="N")&&(ref!="A")){
		if (ref=="S"){
			alert("提示:该处方医生已提交申诉,不需要撤销!")
			return;
		}
		alert("提示：该处方未被拒绝,不能撤销操作!")
		return;
	}
	var userid = session['LOGON.USERID'];
	var retval=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","CancelRefuse",userid,prescno,"OR");
	
	if (retval == "-2"){
		alert("提示：该处方未被拒绝,不能撤销操作!");
		return;
	}
	
	if (retval == "-3"){
		alert("提示：该处方已撤销,不能再次撤销!");
		return;
	}
	
	if (retval == "0"){
		alert("提示：撤销成功！");
		noconfirm=1;
		var PmiNo=document.getElementById("TPmiNoz"+SelectedRow).innerText;
		var pminoObj=document.getElementById('CPmiNo');
		if(pminoObj)pminoObj.value=PmiNo;
		Find_click();
	}else{
		alert("提示：撤销失败！");
	}
 }


document.body.onload = BodyLoadHandler;


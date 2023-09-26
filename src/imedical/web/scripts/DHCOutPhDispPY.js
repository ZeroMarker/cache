//DHCOutPhDispPY
//门诊药房-配药
var bottomFrame;
var topFrame;
var tbl=document.getElementById("tDHCOutPhDispPY");
var f=document.getElementById("fDHCOutPhDispPY");
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
var The_Time;  
var cdateobj;
if(parent.name=='TRAK_main') {
		topFrame=parent.frames['DHCOutPatienDispPY'];
		bottomFrame=parent.frames['DHCOutPatienDispPYSub'];
	} else {
		topFrame=parent.frames['TRAK_main'].frames['DHCOutPatienDispPY'];
		bottomFrame=parent.frames['TRAK_main'].frames['DHCOutPatienDispPYSub'];
	}
	
var subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispPYSub');
var objtbl=document.getElementById('tDHCOutPhDispPY');
var SubDoc=parent.frames['DHCOutPhDispPYSub']
var getdesc=document.getElementById('getdesc');
if (getdesc) {var encmeth=getdesc.value} else {var encmeth=''};
 if (cspRunServerMethod(encmeth,'GDesc','',GPhl,GPhw,GPydr,GFydr,GPhwPos)=='0'){}

 BPrintobj=document.getElementById("BPrint");
 BReprintobj=document.getElementById("BReprint");
 BPrintobj.style.visibility = "hidden";
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
  if (key==123){BAllPrint_click();}  //F12
  if (key==119) {  //F8
	  KeyDisp(); 
  var eSrc=tbl.rows[SelectedRow];
  var RowObj=getRow(eSrc);
  RowObj.className="RedColor"; 
 }	
 if (key==120){RePrint_click();}	//F9 
 if (key==115){ReadHFMagCard_Click();}	//F4  
 
 if (key==40) {  //liangqiang
	 if (rownum>SelectedRow){ 
	 var retrow=SelectedRow+1;	 
	 var eSrc=tbl.rows[retrow];
     var RowObj=getRow(eSrc);
     RowObj.className="RowSelColor";
     var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
     var  fyflag=document.getElementById("TPrintFlagz"+SelectedRow).innerText
     if (fyflag=='OK'){
       RowObj.className="RedColor";
     }
     else{
	     RowObj.className="OldBackColor"
     }
	 
    
	 GetSelectRow(retrow);}
	 }
 if (key==38) {
	 if (SelectedRow>1){ 
	 var retrow=SelectedRow-1;
     var eSrc=tbl.rows[retrow];
     var RowObj=getRow(eSrc);
     RowObj.className="RowSelColor";
     
     var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
     var  fyflag=document.getElementById("TPrintFlagz"+SelectedRow).innerText
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
  BDispobj=document.getElementById("BDisp");
  if (BDispobj) BDispobj.onclick=BDisp_click;
  BPrintobj=document.getElementById("BPrint");
  if (BPrintobj) BPrintobj.onclick=Print_click;
  BReprintobj=document.getElementById("BReprint");
  if (BReprintobj) BReprintobj.onclick=RePrint_click;
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
  //如果需要自动打印时要加BCont_click
 if (tbl.rows.length==1)
 {
    BCont_click()
 }
   GPhwPos=document.getElementById("GPhwPos").value
  if (BFindobj){
	   BFindobj.onclick=Find_click;
	   if (tbl.rows.length>1)
	   {RowClick();
	   DHCMZYF_setfocus('BDisp');
	   }
	   else
	   { var prt=""
 	     var flag=""
 	     var presc=""
	     var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispPYsub&rPHL="+GPhl+"&rPRT="+prt+"&rFLAG="+flag+"&rPrescNo="+presc;
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

 if (HospitalCode=="BJZLYY"){
    DHCP_GetXMLConfig("InvPrintEncrypt","BJZLYYPYD");	 
 }
 if (HospitalCode=="BJDTYY"){
    DHCP_GetXMLConfig("InvPrintEncrypt","BJDTYYPYD");	 
 }
 prescobj=document.getElementById("CardNo");
 if (prescobj) prescobj.onkeypress=GetPatNoFrCard;
  

 var  obj=document.getElementById("CPyUser");
 if (obj) DHCMZYF_setfocus('CPyUser');
 else
 { DHCMZYF_setfocus('CPmiNo');}


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
	
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispPYsub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+prescno;
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
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispPYsub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+prescno;
 	bottomFrame.location.href=lnk;

}
function RollBackColor()
{
    SelectRowHandler();
   var  fyflag=document.getElementById("TPrintFlagz"+SelectedRow).innerText
   if (tbl.rows.length>1){
	  for (var i=1;i<=tbl.rows.length-1;i++)
	  {
		  var  fyflag=document.getElementById("TPrintFlagz"+i).innerText
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
 var pmilen=GetPmiLen()
 if (key==13) {	
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){
	     DHCMZYF_setfocus('find'); return ;}
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
  Find_click();      	  
}

function Reset_click(){
	var stdate="" //document.getElementById("CDateSt").value;
	var enddate="" //document.getElementById("CDateEnd").value;
	var GPhl=document.getElementById("GPhl").value;
	var GPhw=document.getElementById("GPhw").value;
	var settime=document.getElementById("GStepTime").value
	var CPmiNo="00000000";
	var flag="";	
	var obj=document.getElementById("CScreenFlag")
	var PScreen
	if (obj) PScreen=obj.checked;
	var scflag="0";
	if (PScreen==true){scflag="1";}
	var CPatName=""
	var obj=document.getElementById("CPatName")
	if (obj) CPatName=obj.value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispPY&CDateSt="+stdate+"&CDateEnd="+enddate+"&GPhl="+GPhl+"&GPhw="+GPhw+"&CPmiNo="+CPmiNo+"&CPatName="+CPatName+"&GPydr="+GPydr+"&GFydr="+GFydr+"&GPhwPos="+GPhwPos+"&CPrint="+flag+"&GStepTime="+settime+"&CScreenFlag="+scflag;
	topFrame.location.href=lnk;
	var prt=""
	var presc=""
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispPYsub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+presc;
	bottomFrame.location.href=lnk;
}
	 

function SetReprint(value)
{
}

function RePrint_click()
{   
   	subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispPYSub');
    if (objtbl.rows.length==1) {alert("没有处方记录,不能打印");return 0;}
	var row = SelectedRow;

	if (row<1){alert("没有选中处方,不能打印");return 0;}
	var prtflag=""
	var prtflagobj=document.getElementById("TPrintFlagz"+row)
	if (prtflagobj) prtflag=prtflagobj.innerText
	
	if (prtflag!="OK") 
	{alert("此处方记录没有配药,不能重打,请核实界面上的 打印状态");return 0;}
	   
	cyflag=document.getElementById("cyflag").value
	phdrowid=document.getElementById("Tphdrowidz"+row).value
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrintCom"+"&phdrowid="+phdrowid+"&cyflag="+cyflag+"&PrintType=PYD";
	parent.frames['DHCOutPhPrintCom'].window.document.location.href=lnk;  
	return ;    
	   
   	
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


function BDisp_click()
 {
	 var num,i,j,prt
	 SubDoc=parent.frames['DHCOutPhDispPYSub']
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispPYSub');
	 if (objtbl.rows.length==1) {alert(t['notblrowdisp']);return 0;}
	 
  	 if (SelectedRow<1) {alert(t['noselectrowdisp']);return 0;}
	 var shdr=""
	// shdr=document.getElementById("CSHDR").value
	 var prt=document.getElementById("TPrtz"+SelectedRow).value
	 var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText
	 var pmino=document.getElementById("TPmiNoz"+SelectedRow).innerText
	 var patname=document.getElementById("TPatNamez"+SelectedRow).innerText
	 var sfdate=document.getElementById("TPrtDatez"+SelectedRow).innerText
	 var windesc=document.getElementById("TWinDescz"+SelectedRow).innerText
	 var ctloc=document.getElementById("ctloc").value      
     var adtresult=ChkAdtResult(prescno) ;
     if (adtresult==""){
	     alert("请先审核!")
	     return;
     }
     
     if (adtresult=="N"){
	     alert("审核不通过,不允许配药!")
	     return;
     }

     var ret=InsertPhdisp(); 
	 if (ret!=0) {return;}
	 
	 
    
     if (HospitalCode=="BJDTYY")
     {
		     var getmethod=document.getElementById('getscpath');
		     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
		     var scpath=cspRunServerMethod(encmeth,GPhl)
		     if (scpath!="-1")
		     {
				   var notcode=document.getElementById("TNoteFlagz"+SelectedRow).innerText
				   //if notcode=='' Insert Glob ^DHCDateUnNoteDT(date,loc,pmi)
				   var PatString='0,'+patname+','+windesc+','+pmino+','+prescno;
			       var fso = new ActiveXObject("WScript.NetWork");
			       var fs = new ActiveXObject("Scripting.FileSystemObject");
			       var FileStr=scpath+'\\MZYFScreen.txt';
			       if (fs.FileExists(FileStr)==false)
					      {
							 var fw=fs.CreateTextFile(FileStr,true);
							     fw.WriteLine(PatString);
							     fw.Close();
							 var getmethod=document.getElementById('insnote');
							 if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
							 var retval=cspRunServerMethod(encmeth,GPhl,pmino)
				  
				          }
		           else
					      {
						      alert(t['pleaswait']);return;
					      }
					       
      		}
      		
     }
     
     
	 var cyflag=document.getElementById("cyflag").value
	 
	 var printobj=document.getElementById("TPrintFlagz"+SelectedRow)
	 if(printobj) printobj.innerText="OK"
	 fyobj=topFrame.document.getElementById("TFyFlagz"+SelectedRow)
	 if (fyobj) fyobj.value="OK"
	 pmiobj=document.getElementById("CPmiNo");
	 pmiobj.value=""

	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
         RowObj.className="RedColor"; 
         
	 setFocusCardNo();

	 BPrintobj=document.getElementById("BPrint");
     if(BPrintobj.style.visibility == "hidden"){RePrint_click();} //Print_click()
       
       
                                                                 
	 var row = SelectedRow;
	 /*var pyobj=topFrame.document.getElementById("TPrintFlagz"+row)
	 var py=pyobj.innerText;
	 if (py=="OK"){}
	 else
	 {alert(t['noprint']);return;}
    */
    
    
    ///--------------以下可能接口只对齐了大括号的位置内容没改将来接口时统一规范接口  Liangqiang -------------------
    ///
	prt=document.getElementById("TPrtz"+row).value
	var prescno=document.getElementById("TPrescNoz"+row).innerText
	//if (document.getElementById("TFyFlagz"+row).value=="OK"){alert(t['haddisp']);return 0;} 

	var rownum=subtblobj.rows.length;
	var strxml=""
	var strxml1=""
	var strxml2=""
	var lm=0
	//pmino_"^"_phl_"^"_prescno_"^"_phwin_$c(2)_orditm1_"^"_qty1_$c(1)__orditm2_"^"_qty2
    if (HospitalCode=="BJDTYY")
    {
	 
	   var machineflag=document.getElementById("TDispMachinez"+SelectedRow).value
	   // alert(machineflag)
		// if (machineflag=="yes") {
	   strxml1=pmino+"^"+GPhl+"^"+prescno+"^"+GPhw
	   for (var i=1;i<rownum;i++)
	   {
		
		    var orditm=bottomFrame.document.getElementById("TOrditmz"+i).value
		    var qty=bottomFrame.document.getElementById("TPhQtyz"+i).innerText
			if (bottomFrame.document.getElementById("TDispMachinez"+i).innerText==t['dispmachine'])
			{
				lm=lm+1;
				if (strxml2==''){strxml2=orditm+"^"+qty}
				else 
				{
					strxml2=strxml2+String.fromCharCode(1)+orditm+"^"+qty
					
				}
			}  
	   }
	   strxml=strxml1+String.fromCharCode(2)+strxml2
	   
	   var getmethod=document.getElementById('putmsgtomachine');
	   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	   var retval=cspRunServerMethod(encmeth,strxml)
	
      }
 
	  if (HospitalCode=="ZJNBMZ"){
			var obj=document.getElementById("CScreenFlag")
			if (obj){ 
		    var PScreen=document.getElementById("CScreenFlag").checked;
		 
		    if (PScreen!=true){
		        var roomtype
		        if (ctloc==1122) {roomtype="1";}
		        else {roomtype="2";}
		        var getmethod=document.getElementById('insertpyscreen');
		        if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
		        var retval=cspRunServerMethod(encmeth,ctloc,pmino,patname,prt,prescno,windesc,roomtype)
		        if (retval!=0){alert("Inert error");}
		      }
	        }
	     }	     
	     
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
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispPYSub');
	 var rownum,Rrow,prt,name,pmino,printflag,inv;
	 rownum=subtblobj.rows.length
	 Rrow=SelectedRow;
	 if (Rrow<1){alert(t['noselectrowprint']);return 0;}
	 var patprt=document.getElementById("TPrtz"+Rrow).value
	 var  pyuser=document.getElementById("CPyUser")
	 if (pyuser) var CPyUser=pyuser.value
	 var prescno="";
	 var prescnoobj=document.getElementById("TPrescNoz"+Rrow)
	 if (prescnoobj)prescno=prescnoobj.innerText
	 if (prescno==""){"没有处方号,请检查界面中是否显示处方号!";return;}
	 
	 var getmethod=document.getElementById('print');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,patprt,GPhl,GPhw,GPydr,GFydr,prescno,GPhwPos,CPyUser)
     

     if (retval==-1)
     {
	     alert("该处方已作废,不能配药")
	     return -1;
     }
     
     if (retval==-2)
     {
	 
	     alert("该处方药品已配,不能重复配药")
	     return -2;
     }
     
     if (retval==-3)
     {  
	     alert("该处方药品配药,不能重复配药")
	     return -3;
     }
     
     
     if (retval==-4)
     {
	     alert("该处方医嘱已停,不能配药")
	     return -4;
     }
     
     if (retval==-7)
     {
	     alert("配药失败,"+"失败原因: 库存不足,请核查")
	     return -7;
     }
     
     if (retval==-10)
     {   
         alert("已配药,不能重复配药")
	     return -10;
     }
     
     if (retval==-24)
     {
	     alert("配药失败,"+"失败原因: 库存不足,请核查")
	     return -24;
     }
     if (retval==-123)
     {
	     alert("该处方未做皮试或皮试结果阳性!")
	     return -123;
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
	     return 0;
     }


     if (!(retval>0))
     {
	     alert("发药失败,"+"错误代码: "+retval)
	     return -100;
	     
     }
     
     
     
     
}

 function Print_click()
 
 {
	 if (objtbl.rows.length==0) {alert(t['notblrowprint']);return 0;}
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispPYSub');
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
  var pyflag=document.getElementById("CPrint").checked;
  if (pyflag==true){flag="1";}
  var stdate=document.getElementById("CDateSt").value;
  var enddate=document.getElementById("CDateEnd").value;
  var GPhl=document.getElementById("GPhl").value;
  var GPhw=document.getElementById("GPhw").value;
  var CPyUser=""
  var pyuser=document.getElementById("CPyUser")
  if (pyuser){ 
  	CPyUser=pyuser.value;  
  	if (CPyUser=='') {
	  	alert(t['nopyusercode']);
	  	return; 
	}
  }
  var bahobj=document.getElementById("CBAH");
  var bah=""
  if (bahobj)  bah=bahobj.value
  
  var CPmiNo=document.getElementById("CPmiNo").value;
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
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispPY&CDateSt="+stdate+"&CDateEnd="+enddate+"&GPhl="+GPhl+"&GPhw="+GPhw+"&CPmiNo="+CPmiNo+"&CPatName="+CPatName+"&GPydr="+GPydr+"&GFydr="+GFydr+"&GPhwPos="+GPhwPos+"&CPrint="+flag+"&GStepTime="+settime+"&CScreenFlag="+scflag+"&CPyUser="+CPyUser+"&SpecialID="+SpecialID;
  topFrame.location.href=lnk;
}
function shdr_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url= 'websys.lookup.csp';
		url += '?ID=ld50082iCSHName';
		url += '&CONTEXT=Kweb.DHCPhQueryTotal:QueryChFy';
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
 	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispPYsub&rPHL="+GPhl+"&rPRT="+prt+"&rFLAG="+flag+"&rPrescNo="+prescno;
 	bottomFrame.location.href=lnk;
	SelectedRow = 1;
	SetColorAfterFind(); 
 }


function BCont_click()
{

  cyflag=document.getElementById("cyflag").value
  var stdate=document.getElementById("CDateSt").value;
  var enddate=document.getElementById("CDateEnd").value;
  GPhl=document.getElementById("GPhl").value;
  GPhw=document.getElementById("GPhw").value;
  
  var getmethod=document.getElementById('GetPhlAutoPyFlag');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''}; 
  var autopy=cspRunServerMethod(encmeth,GPhl)
  
  if (autopy!=1) return ;
  
  var settime=document.getElementById("GStepTime").value
  var step=settime*1000
  The_Time = setTimeout("BCont_click();", step);
   
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
  
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrintCom"+"&phdrowid="+retval+"&cyflag="+cyflag+"&PrintType=PYD";
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
	
	//alert(myrtn);
	
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
			     //alert(myary[5])
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

 
///回车卡号   LiangQiang
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

///在查找以后自动选中首行,改变背景色 LiangQiang
function SetColorAfterFind()
{
	
   var  fyflag=document.getElementById("TPrintFlagz"+SelectedRow).innerText
   if (tbl.rows.length>1){
	  for (var i=1;i<=tbl.rows.length-1;i++)
	  {
		  var  fyflag=document.getElementById("TPrintFlagz"+i).innerText
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
	    var diag=patarr[4];
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

//检查审核结果
function ChkAdtResult(prescno)
{
      	var getmethod=document.getElementById('mChkAdtResult');
        if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
        var retval=cspRunServerMethod(encmeth,prescno)
        return retval ;
      
}

///打印程序专区

document.body.onload = BodyLoadHandler;


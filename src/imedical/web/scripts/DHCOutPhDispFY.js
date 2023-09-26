//DHCOutPhDispFY
//门诊药房-发药
var noconfirm=0;
var bottomFrame;
var topFrame;
var tbl=document.getElementById("tDHCOutPhDispFY");
var f=document.getElementById("fDHCOutPhDispFY");
var evtName;
var doneInit=0;
var focusat=null;
var HospitalCode;
var SelectedRow = 0;
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var fyflagobj;
var BResetobj,BDispobj,BPrintobj,BReprintobj;
var printobj,dispobj,reprintobj;
var returnphobj,returnphitmobj;
var GStrCode=String.fromCharCode(1);

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
var fyflag= document.getElementById("fyflag").value 
if (fyflag=="1")
   {
	   document.getElementById("CFyFin").checked=true 
   }
   else
   {
	    document.getElementById("CFyFin").checked=false 
   }
var cdateobj;
if(parent.name=='TRAK_main') {
	topFrame=parent.frames['DHCOutPatienDispFY'];
	bottomFrame=parent.frames['DHCOutPatienDispFYSub'];
} else {
	topFrame=parent.frames['TRAK_main'].frames['DHCOutPatienDispFY'];
	bottomFrame=parent.frames['TRAK_main'].frames['DHCOutPatienDispFYSub'];
}
	
var subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispFYSub');
var objtbl=document.getElementById('tDHCOutPhDispFY');
var SubDoc=parent.frames['DHCOutPhDispFYSub']
var getdesc=document.getElementById('getdesc');
if (getdesc) {var encmeth=getdesc.value} else {var encmeth=''};
 if (cspRunServerMethod(encmeth,'GDesc','',GPhl,GPhw,GPydr,GFydr,GPhwPos)=='0'){}

 BPrintobj=document.getElementById("BPrint");
 BReprintobj=document.getElementById("BReprint");
if (BPrintobj) BPrintobj.style.visibility = "hidden";
if (BReprintobj) BReprintobj.style.visibility = "hidden";
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
   if (key==118) {Find_click();}  //F7
   
   
 if (key==119) { //F8
	  KeyDisp(); 
  var eSrc=tbl.rows[SelectedRow];
  var RowObj=getRow(eSrc);
  RowObj.className="RedColor"; 
 }
 	
 if (key==115){ReadHFMagCard_Click();}	//F4 
 if (key==120){RePrintTitle_click();}	//F9 
 if (key==121){BAllDisp_click();}	//F10
 
 
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
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  BDispobj=document.getElementById("BDisp");
  if (BDispobj) BDispobj.onclick=BDisp_click;
   BAllDispobj=document.getElementById("BAllDisp");
  if (BAllDispobj) BAllDispobj.onclick=BAllDisp_click;

  BRefuseDispobj=document.getElementById("BRefuseDisp");
  if (BRefuseDispobj) BRefuseDispobj.onclick=BRefuseDisp_click; //拒绝发药功能与处方审核功能是一样的

  var BCancelRefuseobj=document.getElementById("BCancelRefuse");
  if (BCancelRefuseobj) BCancelRefuseobj.onclick=BCancelRefuse_click;  //撤销拒绝
  
  var RePrintTitleobj=document.getElementById("BRePrintTitle");
  if (RePrintTitleobj) RePrintTitleobj.onclick=RePrintTitle_click;

   var passobj=document.getElementById("BPassCode");
  if (passobj) passobj.onclick=PassCode_click;
  BExitobj=document.getElementById("BExit");
  if (BExitobj) BExitobj.onclick=Exit_click;
  BFindobj=document.getElementById("BRetrieve");
  findobj=document.getElementById("find");
  var cyflag=document.getElementById("cyflag");
  var PPyName=document.getElementById("cPPyName");
  var PFyName=document.getElementById("cPFyName");
   GPhwPos=document.getElementById("GPhwPos").value
   //alert(GPhwPos);
  if (cyflag.value=="1")
     {PPyName.innerText=t['shuser'];
      PFyName.innerText=t['fyuser'];
     }
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
	     var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispFYsub&rPHL="+GPhl+"&rPRT="+prt+"&rFLAG="+flag+"&rPrescNo="+presc;
       	    bottomFrame.location.href=lnk;
	   }
	  }
   tbl.onclick=RollBackColor;
  var obj=document.getElementById("CBAH");
  if (obj) obj.onkeypress=MediNoObj;
  pmiobj=document.getElementById("CPmiNo");
  if (pmiobj) pmiobj.onkeypress=GetPmino;
   var obj=document.getElementById("CardNo");
  //if (obj) obj.onkeypress=GetCardInf;
  if (obj) obj.onkeypress=GetPatNoFrCard;
  var obj=document.getElementById("CPyUserCode");
  if (obj) obj.onkeypress=GetKeyEnterUser;
  var obj=document.getElementById("BCancelNote");
  if (obj) obj.onclick=CancelNote;
 
  //if (pmiobj) pmiobj.onblur=GPmino;
  var  ReadCardobj=document.getElementById("CReadCard");
  if (ReadCardobj) ReadCardobj.onclick= ReadHFMagCard_Click;
  //ReadHFMagCard_Click;

    var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
    loadCardType();
    CardTypeDefine_OnChange();
    
  pnameobj=document.getElementById("CPatName");
  ctlocobj=document.getElementById("ctloc");
  useridobj=document.getElementById("userid");
   var loc=ctlocobj.value
 var user=useridobj.value
 var getmethod=document.getElementById('updatephwin');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var retval=cspRunServerMethod(encmeth,loc,user,GPhw)

  document.onkeydown=OnKeyDownHandler;
   var  CardTypeobj=document.getElementById("CGetCardType");
      if (CardTypeobj) CardTypeobj.style.visibility = "hidden";
   	var GetHospital=document.getElementById("GetHospital");
	if (GetHospital) {var encmeth=GetHospital.value} else {var encmeth=''};
	if (encmeth!="") {
		var HospitalStr=cspRunServerMethod(encmeth,"CurrentHospital");
		var bstr=HospitalStr.split("^");
		HospitalCode=bstr[0];
	}

if (HospitalCode=="AHHF")
  {DHCP_GetXMLConfig("InvPrintEncrypt","AHHFPrescriptPrint");
 }
 
   var obj = document.getElementById("Special");
	if (obj){
		InitSpecial();
		obj.onchange=SpecialSelect;
	}
 
 var cardnoobj=document.getElementById("CardNo");
 if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
 else { DHCMZYF_setfocus('CPmiNo');}
 
 StartDaTongDll();



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
				GetPmino();
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
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispFYsub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+prescno;
 	bottomFrame.location.href=lnk;
     DHCMZYF_setfocus('CPmiNo')
   PassDaTong(selectrow);  //大通
  
}
function CancelNote()
{
 
  if (SelectedRow<1){ SelectedRow=1;}
  var notrow=document.getElementById("TNoteRowz"+SelectedRow).value	
  if (notrow=='') return;
  var method=document.getElementById('upnote');
	if (method) {var encmeth=method.value} else {var encmeth=''};
	if (encmeth){
  var retval=cspRunServerMethod(encmeth,notrow)} 
  if (retval=="0"){ alert(t['cancelsuess']);Find_click();}
}
function GetSelectRow(row)	{
	
	var selectrow=row;
	isSelected=1;
	SelectedRow = selectrow;

	var prt=document.getElementById("TPrtz"+selectrow).value

	var prescno=document.getElementById("TPrescNoz"+selectrow).innerText
	var flagobj=document.getElementById("TFyFlagz"+selectrow).innerText
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispFYsub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+prescno;
 	bottomFrame.location.href=lnk;
  	DHCMZYF_setfocus('CPmiNo')

}
function RollBackColor()
{
    SelectRowHandler();
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



function KeyDisp()
{
	
	BDisp_click();
}
function GetCardNo()
{
	var myobj=document.getElementById("HXSpecialCard");
if (myobj)
			{
var myrtn=ReadCard(myobj,2);
//myrtn: 返回值格式成功标记^2

}
	
    var myary=myrtn.split("^");

  if (myary[0]!="0") {alert(t['22']);return ;}
  if (myary[1]=="") {alert(t['22']);return ;}
 document.getElementById("CardNo").value=myary[1];
 ReadHFMagCard_Click();
 
}

function PutCardLength(card)
{
	 var plen=card.length
    var i
    var lszero=""

 
 	if (plen<=12){
	 for (i=1;i<=12-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
    	}
    	card=lszero+card 
  return card
}
function ReadHFMagCard_Clickold()
{
	var cardno=document.getElementById("CardNo").value;
	cardno=PutCardLength(cardno);
	var myrtn=DHCACC_GetAccInfo("",cardno,"","PatInfo")
	var myary=myrtn.split("^");
	var rtn=myary[0];
	if (myary[0]=="-200"){alert(t['35']);document.getElementById("CardNo").value="";return;}
	var obj=document.getElementById("CPmiNo");
	obj.value=myary[5];
	Find_click();
}
function ReLoadOPFoot(){
	var group=document.getElementById("groupid").value;
	var ctloc=document.getElementById("ctloc").value;
	var stdate=document.getElementById("CDateSt").value;
	var enddate=document.getElementById("CDateEnd").value;
	var pmi=document.getElementById("CPmiNo").value;
	var card=document.getElementById("CardNo").value;
    Find_click()
}

function transINVStr(InvStr){
	var myary=InvStr.split("^");
	Find_click();
}

function GetPmiLen()
{var getmethod=document.getElementById('getpmilen');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var pmilen=cspRunServerMethod(encmeth)
 return pmilen 
} 
function GetCardInf()
{
	 var key=websys_getKey(event);
	 if (key==13) {	
		var cardno=document.getElementById('CardNo').value
		var getmethod=document.getElementById('getpmifrcard');
		if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
		var retval=cspRunServerMethod(encmeth,cardno);
		document.getElementById('CPmiNo').value=retval
		Find_click()
	 }	
}

function GetPmino() {
 var key=websys_getKey(event);
 var patlen=GetPmiLen()
 if (key==13) {	
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){
	     DHCMZYF_setfocus('find'); return ;}
 	if (plen<=patlen){
	 for (i=1;i<=patlen-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	 Find_click();}
	else
	{
	 var patno=pmiobj.value
	 var getmethod=document.getElementById('chpatienno');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,patno)
     if (retval==0){alert(t['35']);pmiobj.value="";return;}
     else if (retval==1){
	     var patno=pmiobj.value
	     var getmethod=document.getElementById('getpmifrcard');
         if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
         var retval=cspRunServerMethod(encmeth,patno);
         pmiobj.value=retval ;
          Find_click();
         }
     else
     {
     var  CardTypeobj=document.getElementById("CGetCardType");
     if (CardTypeobj)  CardTypeobj.style.visibility = "visible";
     }
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
		url += "?ID=d506251iCGetCardType";
		url += "&CONTEXT=Kweb.DHCPhQueryTotal:QueryCardType";
		url += "&TLUJSF=GetDropPmino";
		var obj=document.getElementById('CPmiNo');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		websys_lu(url,1,'top=300,left=500,width=100,height=100');
		return websys_cancel();
	}
}

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
  
  
  var  CardTypeobj=document.getElementById("CGetCardType");
   if (CardTypeobj)  CardTypeobj.style.visibility = "hidden";
  Find_click();      	  
}

function Reset_click(){
	var stdate="" //document.getElementById("CDateSt").value;
	var enddate="" //document.getElementById("CDateEnd").value;
	var GPhl=document.getElementById("GPhl").value;
	var GPhw=document.getElementById("GPhw").value;
	var CPmiNo="00000000";
	var CPatName=""
	var obj=document.getElementById("CPatName")
	if (obj) CPatName=obj.value;
	var PScreen
	var obj=document.getElementById("CScreenFlag")
	if (obj) PScreen=obj.checked;
	var scflag="0";
	if (PScreen==true){scflag="1";}
	var fyflag=""
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispFY&CDateSt="+stdate+"&CDateEnd="+enddate+"&GPhl="+GPhl+"&GPhw="+GPhw+"&CPmiNo="+CPmiNo+"&CPatName="+CPatName+"&GPydr="+GPydr+"&GFydr="+GFydr+"&GPhwPos="+GPhwPos+"&CScreenFlag="+scflag+"&fyflag="+fyflag;
	topFrame.location.href=lnk;
	var prt=""
	var presc=""
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispFYsub&rPHL="+GPhl+"&rPRT="+prt+"&rPrescNo="+presc;
	bottomFrame.location.href=lnk;
}
	 
function Exit_click()
{var getmethod=document.getElementById('exit');
 
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     if (cspRunServerMethod(encmeth,'','',GPhl,GPhw)=='0'){}
    location.href="websys.default.csp"
    bottomFrame.location.href="websys.default.csp"
}


function pyd(value)
{
}
function GetKeyEnterUser()
{
 var key=websys_getKey(e);
 if (key==13) {	
 	   var usercode=document.getElementById("CPyUserCode").value;
 	  var ret=CheckPyCode(usercode) 
     if (ret!="0")
     {alert(t['codeerror']);document.getElementById("CPyUserCode").value="";return;   }
     else
     	{
     		BDisp_click();
     	}
 	
  }
}

function CheckPyCode(code)
{
	   ctloc=document.getElementById("ctloc").value;
    	var getmethod=document.getElementById('checkpyuser');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,code,ctloc)
     return retval;
}

function BAllDisp_click()
{
	 var TblRow=tbl.rows.length-1;
	 if (TblRow==0) {alert(t['nopatient']);return ;}
	 var confirmtext=confirm("确认全发吗?系统将全部发放查询出的所有处方!")
	 if (confirmtext==false) return; 
	 var usercodeobj=document.getElementById("CPyUserCode")
	 var usercode=""
	 if (usercodeobj) 
	 { 
	   usercode=document.getElementById("CPyUserCode").value;
	   var ret=CheckPyCode(usercode) 
       if (ret!="0") {alert(t['codeerror']);return; }
	 }
	 
	 for (var i=1;i<TblRow+1;i++)
	 {
		  var prt=document.getElementById("TPrtz"+i).value
	      var prescno=document.getElementById("TPrescNoz"+i).innerText
	      /// 检查处方审核结果;
		  if(!checkPrescMonitorRes(prescno)){
			  continue;}
			
	       GPydr="",shdr="",pwin="",newwin="" 
		   var retval=Dispensing(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode)
		   if (retval<0) {continue;}

           topFrame.document.getElementById("TFyFlagz"+i).innerText="OK"
	       var eSrc=tbl.rows[i];
           var RowObj=getRow(eSrc);
           RowObj.className="RedColor"; 
  
	 }
	  
	 DHCMZYF_setfocus('CPmiNo');
	 
	  
}


 //检查是否拒绝发药
function ChkAdtResult(prescno)
{
      	var getmethod=document.getElementById('mChkAdtResult');
        if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
        var retval=cspRunServerMethod(encmeth,prescno)
        return retval ;
      
}

//拒绝操作ws 2014-12-20
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
		
		
		var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+prescno+"^OR"  //orditm;
		
		if (reasondr.indexOf("$$$")=="-1")
		{
			reasondr=reasondr+"$$$"+prescno ;
		}
		
		var getmethod=document.getElementById('mrefDisp');
       if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
       var retval=cspRunServerMethod(encmeth,reasondr,input)
       if(retval==0)
	   {alert("拒绝成功");
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
	 
	 var num,i,j,prt
	 SubDoc=parent.frames['DHCOutPhDispFYSub']
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhDispFYSub');
	 if (objtbl.rows.length==0) {alert(t['nopatient']);return 0;}	 
  	 if (SelectedRow<1) {alert(t['noselectpatient']);return 0;}
	 var row = SelectedRow;
	 
     var usercode=""
	 var usercodeobj=document.getElementById("CPyUserCode")
	 if (usercodeobj) 
	 { 
	   usercode=document.getElementById("CPyUserCode").value;
	   var ret=CheckPyCode(usercode) 
       if (ret!="0") {alert(t['codeerror']);return; }
	 }
	 
	//调用大通合理用药接口start
	
	

	 // 调用大通合理用药接口end
	 
	 
	 
	 /////////////
	 ///////发药前判断是否拒绝发药
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
       
       
	 ///////////////
	 var prt=document.getElementById("TPrtz"+SelectedRow).value
	 var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText
	 
     GPydr="",shdr="",pwin="",newwin="" 
     var retval=Dispensing(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode)
     if (retval<0) {return;}
     
	 fyobj=topFrame.document.getElementById("TFyFlagz"+row)
	 fyobj.innerText="OK"
	 pmiobj=document.getElementById("CPmiNo");
	 pmiobj.value=""
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
     RowObj.className="RedColor";
      
     //PrintTitle(SelectedRow)  不知是打印什么先注释留以后参考 Liangqiang
	 
	 
	 
}

///发药过程执行   
function Dispensing(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode)
{
	
     var getmethod=document.getElementById('updatepyd');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     retval=cspRunServerMethod(encmeth,prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode,"0")
     
     var cardnoobj=document.getElementById("CardNo");
     if (cardnoobj) {DHCMZYF_setfocus('CardNo');}
     else { DHCMZYF_setfocus('CPmiNo');}

     if (retval==-20)
     {
	     alert("该处方已作废,不能发药")
	     return -20;
     }
     
     if (retval==-21)
     {
	     alert("该处方药品已发,不能重复发药")
	     return -21;
     }
     
     
     if (retval==-4)
     {
	     alert("该处方医嘱已停,不能发药")
	     return -4;
     }
     
     if (retval==-7)
     {
	     alert("发药失败,"+"失败原因: 库存不足,请核查")
	     return -7;
     }
     
     if (retval==-24)
     {
	     alert("发药失败,"+"失败原因: 库存不足,请核查")
	     return -24;
     }
	 if (retval==-123)
     {
	     alert("该处方未做皮试或皮试结果阳性!")
	     return -123;
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

function Find_click()
{
 var myrow=tbl.rows.length;
 var rr;
  
 var MyFlag="0";
 if (tbl.rows.length>1)
   { 
	   for (rr=1;rr<=myrow-1;rr++){
		   var fyflag=document.getElementById("TFyFlagz"+rr).innerText;
		   var refuseflag=document.getElementById("TDocSSz"+rr).innerText;
		   if ((fyflag!="OK")&&(refuseflag!="拒绝发药")){MyFlag="1"}
		}
   }
  if (noconfirm==1){  //拒绝后的刷新，不要此提示了,liangqiang 2014-12-20
		MyFlag="0"
  }
  if (MyFlag=="1"){ var ret=confirm(t['hadnodisp'])
  if (ret==true){return 0;}}
		   
  noconfirm=0;  //刷新时初始化
  var stdate=document.getElementById("CDateSt").value;
  var enddate=document.getElementById("CDateEnd").value;
  var GPhl=document.getElementById("GPhl").value;
  var GPhw=document.getElementById("GPhw").value;
  var CPmiNo=document.getElementById("CPmiNo").value;
 var fyflag=""
  var fycheck=document.getElementById("CFyFin").checked;
  if (fycheck==true)
  {
	  fyflag="1"
	  
  }
  var CPatName=""
  var obj=document.getElementById("CPatName")
  if (obj) CPatName=obj.value;
   var bahobj=document.getElementById("CBAH");
  var bah=""
  if (bahobj)  bah=bahobj.value
  
  var CPmiNo=document.getElementById("CPmiNo").value;
  if (CPmiNo=="")
     { if (bah!="") {MediNoObj();}  }
  var CPmiNo=document.getElementById("CPmiNo").value;   

  if (HospitalCode=="SCDXHXYY")
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
  var obj=document.getElementById("CScreenFlag")
  var PScreen
  if (obj){  PScreen=obj.checked;}
  var scflag="0";
  if (PScreen==true){scflag="1";}
  
  var obj=document.getElementById("SpecialID")
  if (obj) var SpecialID=obj.value;
  
  
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispFY&CDateSt="+stdate+"&CDateEnd="+enddate+"&GPhl="+GPhl+"&GPhw="+GPhw+"&CPmiNo="+CPmiNo+"&CPatName="+CPatName+"&GPydr="+GPydr+"&GFydr="+GFydr+"&GPhwPos="+GPhwPos+"&CScreenFlag="+scflag+"&fyflag="+fyflag+"&SpecialID="+SpecialID;
  topFrame.location.href=lnk;

}


 function RowClick()
 {
   	var prt=document.getElementById("TPrtz"+1).value
   	var prescno=document.getElementById("TPrescNoz"+1).innerText
   	var fyflag=document.getElementById("TFyFlagz"+1).innerText
   	var flag;
       if (fyflag=="OK"){flag="1";}
       else
        flag=""
 	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhDispFYsub&rPHL="+GPhl+"&rPRT="+prt+"&rFLAG="+flag+"&rPrescNo="+prescno;
 	bottomFrame.location.href=lnk;
	SelectedRow = 1; 
	SetColorAfterFind();
	PassDaTong(1);  //大通 
 }
function DHCMZYF_setfocus(objName) {
	window.setTimeout('DHCMZYF_setfocus2(\''+objName+'\')',300);
}

function DHCMZYF_setfocus2(objName) {
	var obj=document.getElementById(objName);
	if (obj) {
		try {obj.focus();obj.select();	} catch(e) {}  }
    }
//card type add by tang 20071122
function loadCardType(){
	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=document.getElementById("ReadCardTypeEncrypt").value;
		
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
		
	}
}
function PassCode_click()
{
 var currow=SelectedRow
  var pmino=document.getElementById("TPmiNoz"+SelectedRow).innerText
	 var patname=document.getElementById("TPatNamez"+SelectedRow).innerText
	 var sfdate=document.getElementById("TPrtDatez"+SelectedRow).innerText
	 var prt=document.getElementById("TPrtz"+SelectedRow).value
	 var prescno=document.getElementById("TPrescNoz"+SelectedRow).innerText
	 var windesc=document.getElementById("PWinDesc").innerText
 
	 alert("需和叫号系统联接,暂未开放")
	 return;
   if (HospitalCode=="BJDTYY"){
	 var getmethod=document.getElementById('getscpath');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var scpath=cspRunServerMethod(encmeth,GPhl)
     if (scpath!="-1")
      {
	  var PatString='2,'+patname+','+windesc+','+pmino+','+prescno;
      var fso = new ActiveXObject("WScript.NetWork");
      var fs = new ActiveXObject("Scripting.FileSystemObject");
      var FileStr=scpath+'\\MZYFScreen.txt';
      if (fs.FileExists(FileStr)==false){
        var fw=fs.CreateTextFile(FileStr,true);
    	  fw.WriteLine(PatString);
    	  fw.Close();
      }
      else
      {
	      alert(t['pleaswait']);return;
      }
      }
    }

 
 var notrow=document.getElementById("TNoteRowz"+currow).value
 var getmethod=document.getElementById('uppass');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,noterow)
    if (retval==0) {Find_click();}
	
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
			obj.disabled=true;}
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

///回车卡号 GetPatNoFrCard
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


function RePrintTitle_click()
{
	
	if (SelectedRow<1) return 
	PrintTitle(SelectedRow)
}

function PrintTitle(row)
 {
  ctloc=document.getElementById('ctloc').value
  var patname=document.getElementById('TPatNamez'+row).innerText
  var patsex=document.getElementById('TPerSexz'+row).innerText
  var patage=document.getElementById('TPerAgez'+row).innerText
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
	 var pmino=document.getElementById('TPmiNoz'+row).innerText
   	 var content=patname+"^"+prescno
	var logret=tkMakeServerCall("web.DHCOutPhAdd","CreatePrtLabelLog",pmino,content);   //写打印日志
   	 
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
 
function GetDaTong()
{

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

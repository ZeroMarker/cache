// DHCOutPhQueryLocPresc
var bottomFrame;
var topFrame;
var tblobj=document.getElementById("tDHCOutPhQueryLocPresc");
var f=document.getElementById("fDHCOutPhQueryLocPresc");
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
var GStrCode=String.fromCharCode(1);

var DiagnoseArray=new Array();
var cjg=new Array();
var ctloc=document.getElementById("ctloc").value
var method=document.getElementById('checkloc');
    if (method) {var encmeth=method.value} else {var encmeth=''};
    if (cspRunServerMethod(encmeth,'checkcy','',ctloc)=='0') {}
var FYCheck
var GLCheck
var WFYCheck
var GFyFlag;
   
  // GFyFlag="1"
if(parent.name=='TRAK_main') {
		topFrame=parent.frames['DHCOutPatLocPresc'];
		bottomFrame=parent.frames['DHCOutPatLocPrescSub'];
	} else {
		topFrame=parent.frames['TRAK_main'].frames['DHCOutPatLocPresc'];
		bottomFrame=parent.frames['TRAK_main'].frames['DHCOutPatLocPrescSub'];
	}

		/*
	 if(parent.name=='TRAK_main') {
		topFrame=parent.frames['work_top'];
		bottomFrame=parent.frames['work_bottom'];
	} else {
		topFrame=parent.frames['TRAK_main'].frames['work_top'];
		bottomFrame=parent.frames['TRAK_main'].frames['work_bottom'];
	}
	*/
	
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
	
	var obj=document.getElementById("BAllPrintPresc");
	if (obj) obj.onclick=AllPrintPresc; 
	var obj = document.getElementById("BSelPrintPresc");    //打印选中处方  add by caoting
	if (obj) obj.onclick = SelPrintPresc;
	
	   var obj=document.getElementById("CardNo");
  if (obj) obj.onkeypress=GetPatNoFrCard;
  
  

	
	//var obj=document.getElementById("CPhDesc");
	//if (obj) obj.onkeydown=GetPhDescKeyDown; 
	
  // document.onkeydown=OnKeyDownHandler;
  ctlocobj=document.getElementById("ctloc");

   if (BRetrieveobj){
	   BRetrieveobj.onclick=Retrieve_click;
	   if (tbl.rows.length>1){
		   RowClick();
		   }
	   else
	   { var phd=""
 	     var flag=""
 	     var ctloc=ctlocobj.value;
 	     var prescno=""
 	     var PrtID="";
	  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispSub&rPhd="+phd+"&FyFlag="+flag+"&rCtloc="+ctloc+"&rPrescNo="+prescno+"&rPrt="+PrtID;
       	   bottomFrame.location.href=lnk;
	   }
	  }
	var obj=document.getElementById("selectAll");      
	if (obj) obj.onclick=SetSelectAll; 
	var objcancel=document.getElementById("cancelAll"); 
	if (objcancel) objcancel.onclick=CancelSelectAll;	  

	var cyflag=document.getElementById("cyflag");
	//if (cyflag.value==1) {DHCP_GetXMLConfig("InvPrintEncrypt","BJZYYCYPrescriptPrint");}
	useridobj=document.getElementById("userid");

	var ctloc=document.getElementById("ctloc").value;
	var userid=document.getElementById("userid").value
	combo_PrescType=dhtmlXComboFromStr("CPrescType","");
	combo_PrescType.enableFilteringMode(true);
	var encmeth=document.getElementById("getpresctype").value;
	var DeptStr=cspRunServerMethod(encmeth)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_PrescType.addOption(Arr);
	//var myobj=document.getElementById("CardTypeDefine");

	DHCMZYF_setfocus('CPmiNo');

}

function GetPatNoFrCard()
{
 var key=websys_getKey(e);
 if (key==13) {
	 
  var cardcode=document.getElementById("CardNo").value;
   var getmethod=document.getElementById('getpatnofrcard');
  if (getmethod) {var encmeth=getmethod.value;} else {var encmeth=''};
  var patno=cspRunServerMethod(encmeth,cardcode)
  
  document.getElementById("CPmiNo").value=patno
  
  DHCMZYF_setfocus("CPmiNo")
 }
}

function OnKeyDownHandler(e){
  var key=websys_getKey(e);
 // var patname=document.getElementById('CPatName');
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
		DHCWeb_DisBtnA("CReadCard");
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

function PrintPhdRow(phdrow)
{
	
  var cyflag=document.getElementById("cyflag").value;	
	
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrintCom"+"&phdrowid="+phdrow+"&cyflag="+cyflag
  parent.frames['DHCOutPhPrintCom'].window.document.location.href=lnk; 
  
  return;
  
	
 var getmethod=document.getElementById('getsysdate');
  if (getmethod) {var encmeth=getmethod.value;} else {var encmeth=''};
  var sysdate=cspRunServerMethod(encmeth)


 var getmethod=document.getElementById('getpatprintpresc');   //web.DHCOutPhNewAddCommit.GetPhdPatient
  if (getmethod) {var encmeth=getmethod.value;} else {var encmeth=''};
  var retval=cspRunServerMethod(encmeth,phdrow)
  //  	s retval=patname_"^"_patno_"^"_patsex_"^"_patage_"^"_prescno_"^"_prescmoney_"^"_patlocdesc_"^"_presctype_"^"_zhb_"^"_orddoctname_"^"_paticd_"^"_pyname_"^"_fyname
var VStr=retval.split("^")
var patname=VStr[0]
var patno=VStr[1]
var patsex=VStr[2]
var patage=VStr[3]
var prescno=VStr[4]
var prescmoney=VStr[5]
var patloc=VStr[6]
var presctype=VStr[7]
var zhb=VStr[8]    //诊别
var doctname=VStr[9]
var paticd=VStr[10]
var pyname=VStr[11]
var fyname=VStr[12]
var presctitle=VStr[13]
//add by gwj 2011-06-07  发药日期
var phdDate=VStr[14]
var patweight=VStr[15]    //体重
var notes=VStr[16]
//*************
 var getmethod=document.getElementById('getlocpatprescinf');               //web.DHCOutPhRetrieve.GetPrescOrd
  if (getmethod) {var encmeth=getmethod.value;} else {var encmeth=''};
  var retval=cspRunServerMethod(encmeth,phdrow)
  
    var LStr=retval.split(GStrCode)
    var OrdRows=LStr.length

   var pc= new Array(new Array(),new Array());
 
     	
    	for (m=1;m<OrdRows+1;m++)
    	{
    		
    	
    		var SOrd=LStr[m-1];
    	
       	var SStr=SOrd.split("^")
       	
       	pc[m]=new Array();
 //	s ret=orditem_"^"_incTYdesc_"^"_basuomdesc_"^"_price_"^"_dispqty_"^"_totprice_"^"_oeflag_"^"_pc_"^"_phfragdesc_"^"_instrdesc_"^"_duratdesc_"^"_username_"^"_yppc_"^"_yphw_"^"_newretqty_"^"_phgg
        var descstr=SStr[1].split("&")
       	pc[m][1]=descstr[0]+"    "+descstr[1];  //药品名称
       	
       	//add by gwj 2011-06-08  名称如果太长的话换行
       	pc[m][5]=""
       var strl=0
       k1=SStr[1].length;
       for (i = 1; i <= SStr[1].length; i++) {
					
       		var ascstr=SStr[1].charCodeAt(i)
       		if ((ascstr >= 0) && (ascstr <= 255 ))
       		{
       			strl=strl+1;
       		}
       	else
       		{
       			strl=strl+2;
       		}
       		if (strl>=24)
       		{
       			pc[m][1]=SStr[1].substr(0,i);
       			pc[m][5]=SStr[1].substr(i,k1-i);
       			break;
       		}
       	
      }
      //***************
        pc[m][2]=SStr[15];	//guige
       	pc[m][3]=SStr[4]+SStr[2]
       	
       	pc[m][4]=SStr[7]+" "+SStr[9]+" "+SStr[8];//?用法?剂量  频次

      	}
      	 var xmlMB=""
      	if (presctitle.indexOf("儿")!="-1")
      	{
	      	xmlMB="DHCOutPrescXYChild"	
      	}
      	else if (presctitle.indexOf("急")!="-1")
      	{
	      	xmlMB="DHCOutPrescXYJZ"
	      
      	}
      	else if (presctitle.indexOf("普")!="-1")
      	{
	      	 xmlMB="DHCOutPrescXYPT"
      	}
      	else
      	{
	      	 xmlMB="DHCOutPrescXYPT"
      	}
   DHCP_GetXMLConfig("InvPrintEncrypt",xmlMB)
      	             
   var MyList=""
   var MyPara="";
 
			    MyPara=MyPara+"PrescNo"+String.fromCharCode(2)+"*"+prescno+"*";
			    MyPara=MyPara+"^PrescTitle"+String.fromCharCode(2)+presctitle;
			    MyPara=MyPara+"^PatNo"+String.fromCharCode(2)+patno;
			    MyPara=MyPara+"^PatSex"+String.fromCharCode(2)+patsex;
			    MyPara=MyPara+"^PatName"+String.fromCharCode(2)+patname;
			    MyPara=MyPara+"^PatAge"+String.fromCharCode(2)+patage;
			    MyPara=MyPara+"^PatICD"+String.fromCharCode(2)+paticd;
			    MyPara=MyPara+"^fb"+String.fromCharCode(2)+presctype;
			    MyPara=MyPara+"^PatWeight"+String.fromCharCode(2)+patweight;
                MyPara=MyPara+"^ZB"+String.fromCharCode(2)+zhb;
                MyPara=MyPara+"^PrescDate"+String.fromCharCode(2)+phdDate;
                MyPara=MyPara+"^PatLoc"+String.fromCharCode(2)+patloc;

                MyPara=MyPara+"^DoctName"+String.fromCharCode(2)+doctname;
                MyPara=MyPara+"^PyName"+String.fromCharCode(2)+pyname;
                MyPara=MyPara+"^FyName"+String.fromCharCode(2)+fyname;
                MyPara=MyPara+"^PrescMoney"+String.fromCharCode(2)+prescmoney;
                MyPara=MyPara+"^Notes"+String.fromCharCode(2)+notes;
      
      	 for (k=1;k<OrdRows+1;k++)
	      {
		     var l=0;
		     for (l=1;l<6;l++)
		      {
		        MyPara=MyPara+"^txt"+k+l+String.fromCharCode(2)+pc[k][l]; 
		      }
	      }
    //add by gwj 2011-06-08 处方结束后打一虚线
    var PrescBottomLine="----------------------------------------------"
    //if (OrdRows<5)
    //{
    	var titlerow=OrdRows+1
	    MyPara=MyPara+"^txt"+titlerow+1+String.fromCharCode(2)+PrescBottomLine
	  // }
    //*************   
	  var myobj=document.getElementById("ClsBillPrint");
	    DHCP_PrintFun(myobj,MyPara,MyList);	
  	return 0 
}
function PrintPresc()
{
	
    var cyflag=document.getElementById("cyflag");
    if (SelectedRow==-1){alert("请选中处方"); return;}
    if (SelectedRow==0) {alert("请选中处方"); return;}
    var phdrow=document.getElementById("tphdz"+SelectedRow).value
	var ret=PrintPhdRow(phdrow)		    
	 
 
}
function AllPrintPresc()
{
	var tblobj=document.getElementById("t"+"DHCOutPhQueryLocPresc");
	
	if (tblobj.rows.length==1) {alert("没有数据,不能打印");return;}
  var getmethod=document.getElementById('getlocpatnum');
  if (getmethod) {var encmeth=getmethod.value;} else {var encmeth=''};
  var PrintRow=cspRunServerMethod(encmeth)
  if (PrintRow==0) {alert("没有数据,不能打印");return;}
  var i=0
     for (i=1;i<=PrintRow;i++)
     {
	     var getmethod=document.getElementById('getlocpatinf');
         if (getmethod) {var encmeth=getmethod.value;} else {var encmeth=''};
         var PrintInf=cspRunServerMethod(encmeth,i)
         var phdrow=PrintInf.split("^")[16]
         
         //var ret=PrintPhdRow(phdrow)
         var v_Obj=window.parent.frames["DHCOutPhPrintCom"];
         var cyflag=document.getElementById("cyflag").value;
         if (cyflag==1){
	         v_Obj.PrintPrescCY(phdrow);
         }else{
	         v_Obj.PrintPrescXY(phdrow);
         }
         


         	
     }
  
	 
 
}
function SelPrintPresc() {
	var n=0;
	var objtbl=document.getElementById("t"+"DHCOutPhQueryLocPresc");
	if (objtbl)	rowcnt=getRowcount(objtbl)
	

	if (rowcnt<1){	return;  }

	var i = 0
	for (i = 1; i <= rowcnt; i++) {
		var objCheck=document.getElementById("Tselect"+"z"+i);
		if (objCheck)
		{	
				   
			if(objCheck.checked==true)
			{

		var phdrow = document.getElementById("tphdz" + i).value
		if(phdrow==""){
			continue;}
		var v_Obj = window.parent.frames["DHCOutPhPrintCom"];
		var cyflag = document.getElementById("cyflag").value;
		if (cyflag == 1) {
			v_Obj.PrintPrescCY(phdrow);
		} else {
			v_Obj.PrintPrescXY(phdrow);
		}
		n=n+1;
			}
		}
	}
	if(n==0){alert("没有选中处方")}
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;
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
 	if (SelectedRow>1){
		var eSrc=tblobj.rows[1];
		var RowObj=getRow(eSrc);
		RowObj.className="RowOdd"; 
	}else if (SelectedRow==1){
		var eSrc=tblobj.rows[1];
		var RowObj=getRow(eSrc);
		RowObj.className="clsRowSelected"; 
	}



}

function RowClick()
{
	var prescno=document.getElementById("TPrescNoz"+1).innerText
	var phd=document.getElementById("tphdz"+1).value
	var ctlocobj=document.getElementById("ctloc");
	var ctloc=ctlocobj.value;
	var fy=document.getElementById("TPyNamez"+1).innerText
	if (fy=="W"){GFyFlag="2";}
	if (GFyFlag==""){GFyFlag="1";}
	var PrtID=document.getElementById("TPrtIDz"+1).value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryDispSub&rPhd="+phd+"&FyFlag="+GFyFlag+"&rCtloc="+ctloc+"&rPrescNo="+prescno+"&rPrt="+PrtID;
	bottomFrame.location.href=lnk;
	DHCMZYF_setfocus('CPmiNo');
	SelectedRow = 1;
	var eSrc=tblobj.rows[SelectedRow];
	var RowObj=getRow(eSrc);
	RowObj.className="clsRowSelected"; 
}

function ReadHFMagCard_Click()
{
		var myCardTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine");
  	if (m_SelectCardTypeDR==""){
		var myrtn=DHCACC_GetAccInfo();
	}else{
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
		//var myrtn=DHCACC_GetAccInfo("1","1");
		
	}
	

	var myary=myrtn.split("^");
	var rtn=myary[0];
	
	if (rtn=="-1") {alert(t['32']);return ;}
	else
	{	var obj=document.getElementById("CPmiNo");
			if (obj) obj.value=myary[5];
			DHCMZYF_setfocus('BRetrieve');
	}
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
    if (plen==0){ DHCMZYF_setfocus('BRetrieve'); return ;}
 	//if (plen>patlen){alert(t['01']);return;}
	 for (i=1;i<=patlen-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
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
    if (plen==0)  {  DHCMZYF_setfocus('BRetrieve'); return ;}
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
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryLocPresc";
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

function Retrieve_click()
{
  stdateobj=document.getElementById("CDateSt")
  enddateobj=document.getElementById("CDateEnd")
  pmiobj=document.getElementById("CPmiNo")
  //pnameobj=document.getElementById("CPerName")
 var ctlocobj=document.getElementById("ctloc")
   var ctloc=ctlocobj.value;
  var stdate=stdateobj.value
  var enddate=enddateobj.value
  var sttime=document.getElementById("sttime").value
  var endtime=document.getElementById("endtime").value
  
    var admlocdesc=document.getElementById("CAdmLocDesc").value
    var admloc=document.getElementById("CAdmLoc").value
if (admlocdesc==""){ admloc="";document.getElementById("CAdmLoc").value="";}
  
  var pmino=pmiobj.value
  var plen=pmiobj.value.length
  var i;
  var lszero=""
   var presctype= combo_PrescType.getSelectedValue()
  var pname=""
  //pnameobj.value
   
 
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryLocPresc&CDateSt="+stdate+"&CDateEnd="+enddate+"&ctloc="+ctloc+"&CPmiNo="+pmino+"&sttime="+sttime+"&endtime="+endtime+"&CAdmLocDesc="+admlocdesc+"&CAdmLoc="+admloc+"&CPrescType="+presctype
  location.href=lnk;
  
   DHCMZYF_setfocus('CPmiNo');


}
function GetDropDep(value)
{
  var val=value.split("^") 
  var shdr=document.getElementById("CAdmLoc");
  shdr.value=val[1];
}
function Export_click() 
{
	//var subtblobj=bottomFrame.document.getElementById('tDHCOutPhQueryDispSub');
	var tblobj=document.getElementById("tDHCOutPhQueryLocPresc");
	var oXL = new ActiveXObject("Excel.Application"); 
	var oWB = oXL.Workbooks.Add(); 
	var oSheet = oWB.ActiveSheet;
	//var rows = subtblobj.rows.length; 
	var mainrows=tblobj.rows.length;
	var RowSel=SelectedRow 
	//var lie = subtblobj.rows(0).cells.length; 
	var mainlie = tblobj.rows(0).cells.length-1; 
    if (mainrows==1) {return ;}
    if (SelectedRow==0) {RowSel=1;}
    var ii;
    /*
    for (iii=0;iii<mainlie;iii++)
    {
	   
	   oSheet.Cells(1,iii+1).value= tblobj.rows(0).cells(iii+1).innerText;  
 	}
	*/
	var getmethod=document.getElementById('getlocpatnum');
   	if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	var retval=cspRunServerMethod(encmeth)
 	var strlen=retval

 
 	var i
	for (i=0;i<=strlen;i++)
	{
		var getmethod=document.getElementById('getlocpatinf');
		if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
		var locpatinf=cspRunServerMethod(encmeth,i)
   	
   		var phstr=locpatinf.split("^")
   		for (j=0;j<mainlie;j++)
   		{
   			
   			if (phstr[j].substr(0,1)==0){
	   			oSheet.Cells( 1+i,j+1).NumberFormatLocal="@"
   			}
   			oSheet.Cells( 1+i,j+1).value = phstr[j];
   			oSheet.Columns(j+1).EntireColumn.AutoFit
   		}
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
//全选
function SetSelectAll(){
  var rowcnt;
  var objtbl=document.getElementById("t"+"DHCOutPhQueryLocPresc")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
    }
  if (rowcnt>0)
  {
	  	for (i=1;i<=rowcnt;i++)
	  	{
		 	 var obj=document.getElementById("Tselect"+"z"+i)
		  	 if (obj) obj.checked=true ;
	 	 }	  	
  }
}
//取消全选
function CancelSelectAll(){
  var rowcnt;
  var objtbl=document.getElementById("t"+"DHCOutPhQueryLocPresc")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
    }
  if (rowcnt>0)
  {
	  	for (i=1;i<=rowcnt;i++)
	  	{
		 	 var obj=document.getElementById("Tselect"+"z"+i)
		  	 if (obj) obj.checked=false ;
	 	 }	  	
  }
}
function getRowcount(obj)
{ if (obj)
	{return  obj.rows.length-1 ;}
	return 0	
	}
document.body.onload = BodyLoadHandler;

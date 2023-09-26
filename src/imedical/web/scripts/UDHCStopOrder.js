///UDHCStopOrder.js
function BodyLoadHandler() {
	var obj=document.getElementById("StopOrd");
	if (obj) obj.onclick=Stop_Click;

	obj=document.getElementById("adm");
	obj.readOnly=true;
	var admdr=obj.value;
	if(admdr=="") {
		alert("没有得到病人就诊记录,不能操作此页面.");
		var obj=document.getElementById("StopOrd");
		if (obj) obj.disabled=true;obj.onclick="";
		var obj=document.getElementById("LookUp");
		if (obj) obj.disabled=true;obj.onclick="";
		var obj=document.getElementById("RevokeItem");
		if (obj) obj.disabled=true;obj.onclick="";
		return;
	}else{
		var obj=document.getElementById("StopOrd");
		if (obj) obj.onclick=Stop_Click;
		var obj=document.getElementById("LookUp");
		if (obj) obj.onclick=LookUp_click;
		var obj=document.getElementById("RevokeItem");
		if (obj) obj.onclick=RevokeItem_Click;
		var AdmType="";
		var AdmTypeobj=document.getElementById("AdmType");
		if (AdmTypeobj) AdmType=AdmTypeobj.value;
		if (AdmType=="I") {
			alert(t['201']);
			DHCWeb_DisBtnA("StopOrd");
			DHCWeb_DisBtnA("RevokeItem");
		}
	}
	obj=document.getElementById("getname");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,"","",admdr);  
	//alert(retval);
	var s=retval.split("^")
	obj=document.getElementById("patientname");
	if (obj){ obj.value=s[1];
	   obj.readOnly=true;
	}
	
	regobj=document.getElementById("RegistrationNo");
	if (regobj){
		regobj.value=s[0];
		regobj.readOnly=true;
	}
	var PatientID=document.getElementById("PatientID").value;
	var PatEncryptLevel=tkMakeServerCall("web.DHCBL.CARD.UCardPaPatMasInfo","GetPatEncryptLevel",PatientID,"")
	if (PatEncryptLevel!="") {
		var PatEncryptLevelArr=PatEncryptLevel.split("^");
		var obj1=document.getElementById("PoliticalLevel");
		if(obj1) obj1.value=PatEncryptLevelArr[1];
		var obj1=document.getElementById("SecretLevel");
		if(obj1) obj1.value=PatEncryptLevelArr[0];
	}
	var regnoobj=document.getElementById("regno");
	var admobj=document.getElementById("adm");
	var Epsobj=document.getElementById("EpisodeID");
	if (regnoobj){regnoobj.value=regobj.value;}
	obj=document.getElementById("OrdDesc");
	if (obj){obj.onkeydown=OrdDesc_keyDown;}  
	obj=document.getElementById("SelectAll");
	if (obj){obj.onclick=SelectAll_Click;} 
	obj=document.getElementById("lulocdes");
	if (obj){obj.onkeydown=lulocdes_keydown;}
	Objtbl=document.getElementById('tUDHCStopOrder');
	Rows=Objtbl.rows.length;
	var ComponentId='';
	var obj=document.getElementById('ComponentId');
	if (obj) ComponentId=obj.value;
	for (var i=1;i<Rows;i++){
		//var tadmobj=document.getElementById('Tadmz'+i);  
		//tadmobj.value=Epsobj.value;
		var STDObj=document.getElementById('lt'+ComponentId+'iEndDatez'+i);
		if (STDObj) STDObj.onclick=OEORISttDat_lookuphandler;
		var STDObj=document.getElementById('EndDatez'+i);
		if (STDObj) STDObj.onchange=OEORISttDat_changehandler;
		
		var STTObj=document.getElementById('EndTimez'+i);
		if (STTObj){STTObj.onchange=OEORISttTim_changehandler}; 
	}
}

function LflagChange(){
  var obj=document.getElementById("Lflag");
  if (obj.checked==true) 
    {alert("checked");}
  else
    {alert("unchecked");}  	
} 


function SelectAll_Click()
{
 // alert("ss");
  var obj=document.getElementById("SelectAll");
  var Objtbl=document.getElementById('tUDHCStopOrder');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('selectIDz'+i);  
	selobj.checked=obj.checked;  
	}
}


function LflagChange()
{
  var obj=document.getElementById("Lflag");
  if (obj.checked==true) 
    {alert("checked");}
  else
    {alert("unchecked");}  	
}

 
function SelectRowHandler()	
{  	
 	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCStopOrder');
	Rows=Objtbl.rows.length;
	var rowObj=getRow(eSrc);           //
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	obj=document.getElementById('selectIDz');
	SelRowObj=document.getElementById('selectIDz'+selectrow);
  var stat=SelRowObj.checked;          //the status of the row you selected
  
	//var admobj=document.getElementById('Tadmz'+selectrow);
	var admobj=document.getElementById('EpisodeID');
	//var win=top.frames['eprmenu'];
	//if (win){
		//var frm=win.document.forms['fEPRMENU'];
		//modify by zhouzq 2010.09.14
		var frm=dhcsys_getmenuform();
		frm.EpisodeID.value=admobj.value
	//}

  /*这两个判断写的有问题，要改进，来不及，还缺少 message
	if (stat){
		var selectname=document.getElementById('exflagz'+selectrow);	
		var nurseexec=selectname.innerText
		if (nurseexec ==t["Executed"]){
			alert (t["NoPermission"]);
			var selectname=document.getElementById('selectIDz'+selectrow);
			selectname.checked=false;
			return;
		}
	}

	var selectname=document.getElementById('selectIDz'+selectrow); //cwg060408
	if (selectname.checked==true){
		var selectname=document.getElementById('xuseridz'+selectrow);	
		var orderuser=selectname.innerText
	  //if (userinitials != orderuser)  {alert (t["OtherPerson"])}
	}
	*/
	var selRowid=GetColumnData('ordch',selectrow);;  //rowid of the row you selected
	var stopdate=GetColumnData('EndDate',selectrow);
  var stoptime=GetColumnData('EndTime',selectrow);
  var Configobj=document.getElementById("StopGroupOrder");
  if (Configobj&&(Configobj.value==1)){
	  //如果选择的是子医嘱则选择所有医嘱 2008-06-08 guorongyong
	  var SonSelRowid=GetColumnData('ordlink',selectrow);
	  if(Trim(SonSelRowid)!=""){
	  var Sonobj;
		for (var i=1;i<Rows;i++){
			SonRowid="",SonLinkRowid="";
			SonRowid=GetColumnData('ordch',i);
			SonLinkRowid=GetColumnData('ordlink',i);
			if ((SonRowid==SonSelRowid)||(SonLinkRowid==SonSelRowid)) {
				//如果选种，需要全部关联医嘱的停止时间设相同的直
				Sonobj=document.getElementById('selectIDz'+i);
				Sonobj.checked=stat
				if (stat){
					SetColumnData("EndDate",i,stopdate)
					SetColumnData("EndTime",i,stoptime)
				}else{
					//SetColumnData("EndDate",selectrow,"")
					//SetColumnData("EndTime",selectrow,"")
					
				}
			}
		}
  }
  }
  //end
  if (!(stat)) {
		//SetColumnData("EndDate",selectrow,"")
		//SetColumnData("EndTime",selectrow,"")
  }
  var tmpobj;
	for (var i=1;i<Rows;i++){
		LinkRowid="";
		LinkRowid=GetColumnData('ordlink',i);
		if (LinkRowid==selRowid) {
			//如果选种，需要全部关联医嘱的停止时间设相同的直
			tmpobj=document.getElementById('selectIDz'+i);
			tmpobj.checked=stat
			if (stat){
				SetColumnData("EndDate",i,stopdate)
				SetColumnData("EndTime",i,stoptime)
			}else{
				//SetColumnData("EndDate",selectrow,"")
				//SetColumnData("EndTime",selectrow,"")
				
			}
		}
  }
}
function Trim(str)
{
	return str.replace(/[\s\t\n\r ]/g, "");
}
function SetCellStyle(ColName,Row,val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
		CellObj.style.visibility=val;
	}	
}
function GetColumnData(ColName,Row){
	
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
		//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){
				return CellObj.checked;
			}else{
				return CellObj.value;
			}
		}
	}
	return "";
}

function SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				CellObj.checked=Val;
			}else{
				CellObj.value=Val;
			}
		}
	}
}

function Stop_Click()
{
	var OrdList=GetStopOrdID();
	if (OrdList==-1) return 0
	if (OrdList!=""&&OrdList!=-1) {
		var obj=document.getElementById("stop");
		if (obj) {var encmeth=obj.value} else {var encmeth=''};
	 
		obj=document.getElementById("User");
		if (obj) {var UserID=obj.value} else {return 0};
	 
		var PinNum="",PWFlag="Y";
		obj=document.getElementById("PinNum");
		if (obj) {var PinNum=obj.value} else {PWFlag="N"}  
		if ((PinNum=='')&&(PWFlag=='Y')){
			alert(t["06"])
			return 0;
		}
		//电子签名
		var ContainerName="";
		var caIsPass=0;
		var CAInit=tkMakeServerCall("web.DHCDocSignVerify","GetCAServiceStatus",session['LOGON.CTLOCID'],session['LOGON.USERID']);
		if (CAInit==1) 
		{  
				  if (IsCAWin=="") 
					{
						alert("请先插入KEY");
						return false;
					}
				  var result = window.showModalDialog("../csp/oeorder.oplistcustom.caaudit.csp", window, "dialogWidth:300px;dialogHeight:250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;");
					if ((result=="")||(result=="undefined")||(result==null)) 
		      {
		      	return false;
		      }
		      ContainerName=result;
		      caIsPass=1;
		}

		//// var flag=cspRunServerMethod(encmeth,'RetValue1','RetValue2',OrdList,UserID,PinNum);
		var flag=cspRunServerMethod(encmeth,"","",OrdList,UserID,PinNum,PWFlag);
		switch(flag)
		{
		case "0" :
			if (caIsPass==1)var ret=SaveCASign(ContainerName,OrdList,"S");
			alert("OK");
			break;
		case "-1" :
	     	alert(t["01"]);
	     	break;
	    case "-2" :
	     	alert(t["02"]);
	     	break;
		case "-4" :
	     	alert(t["03"]);
	     	break;
		case "-5" :
	     	alert(t["04"]);
	     	break;
	  case "-300":
	    	alert(t['300']);
			break;
		case "-200":
	    	alert(t['200']);
			break;
	    default:
	     	alert(t["05"])  
		}
	}else{
		 alert(t["07"]);
	}
	var OrdDescobj=document.getElementById("OrdDesc");
	var EpisodeIDobj=document.getElementById("EpisodeID");
	var CurDataFlagobj=document.getElementById("CurDataFlag");
	var Lflagobj=document.getElementById("Lflag");
	var Sflagobj=document.getElementById("Sflag");
	var patientnameobj=document.getElementById("patientname");
	var RegistrationNoobj=document.getElementById("RegistrationNo");
	var lulocdesobj=document.getElementById("lulocdes");
	var admobj=document.getElementById("adm");
	var Userobj=document.getElementById("User");
	var QueryEndDate=document.getElementById("QueryEndDate");
	var QueryStartDate=document.getElementById("QueryStartDate");
	var cur=0;
	var sfl=0;
	var lfl=0;
	if (Lflagobj&&(Lflagobj.checked)){lfl="on"}
	if (Sflagobj&&(Sflagobj.checked)){sfl="on"}
	if (CurDataFlagobj&&(CurDataFlagobj.checked)){cur="on";}
	var tmpstr="";
	tmpstr+='websys.default.csp?TDIRECTPAGE=dhcdoc.stopordercaaudit.csp';
	tmpstr+='&OrdDesc='+OrdDescobj.value;
	tmpstr+='&EpisodeID='+EpisodeIDobj.value;
	tmpstr+='&CurDataFlag='+cur;
	tmpstr+='&Sflag='+sfl;
	tmpstr+='&Lflag='+lfl;
	tmpstr+='&patientname='+patientnameobj.value;
	tmpstr+='&RegistrationNo='+RegistrationNoobj.value;
  tmpstr+='&lulocdes='+lulocdesobj.value;
  tmpstr+='&adm='+admobj.value;
  tmpstr+='&User='+Userobj.value;
  tmpstr+='&QueryEndDate='+QueryEndDate.value;
  tmpstr+='&QueryStartDate='+QueryStartDate.value;
    //alert(tmpstr);
    //window.location.href=tmpstr;   
  //window.location.reload(); 	
  LookUp_click();
}
function RetValue1(value){
	alert(value);
	}
function RetValue2(value){
	alert(value);
	}	
function GetStopOrdID() 
{
  var objtbl=document.getElementById('tUDHCStopOrder');	
  var rows=objtbl.rows.length;
  var i=0;
  var SColObj,RColObj;
  var OrdList=""
  
  for (i=1;i<rows;i++)
  {
		SColObj=document.getElementById('selectIDz'+i);  
		if (SColObj)
		{
		  if (SColObj.checked){
				Rowid=GetColumnData('ordch',i);
				var STTDate=GetColumnData('sttd',i);
				STDate=GetColumnData('EndDate',i);
				STTime=GetColumnData('EndTime',i);
				priorty=GetColumnData('ordtype',i);
				ordlink=GetColumnData('ordlink',i);
				Lstr=t["LPriorty"];

				STDate=Trim(STDate);
				STTime=Trim(STTime);
				debugger;
				var notLimited=DateTimeLimited(priorty,Lstr,STDate,STTime); 
		        if (notLimited=="N"){
		          alert(t["DateTimeExt"]);
		          return -1;
			   }
				
				if (!CheckOrderStartDate(STDate,STTDate)){
					alert(t['EndDatLessStartDate']);
					return -1;
				}
	    	STString=Rowid + "&" + STDate + "&" + STTime+"&"+ordlink;
				if (OrdList==""){OrdList=STString;}else{OrdList=OrdList + "^" + STString; } 
			} 
	  }   
	}
	return OrdList; 	
}  	
function CheckOrderStartDate(OrderStartDate,CurrDate){
	if (CurrDate=="") return true;
	if (OrderStartDate=="") return true;
	
	var dt=OrderStartDate;
	dt=ConvertNoDelimDate(dt);
	//if ((dt.indexOf('/')==-1)&&(dt.indexOf('-')==-1)&&(dt.length>2)) dt=ConvertNoDelimDate(dt);
	if (dtformat=="DMY") var dtArr=dt.split('/');
    if (dtformat=="YMD") var dtArr=dt.split('-');
	var len=dtArr.length;
	if (len>3) return false;
	for (i=0; i<len; i++) {
	if (dtArr[i]=='') return false;
	}
    if (dtformat=="DMY"){
	    var OrderStartDateArr=OrderStartDate.split("/");
		var OrderStartDateYear=OrderStartDateArr[2];
		var OrderStartDateMonth=OrderStartDateArr[1];
		var OrderStartDateDay=OrderStartDateArr[0];
		
		var CurrDateArr=CurrDate.split("/");
		var CurrDateYear=CurrDateArr[2];
		var CurrDateMonth=CurrDateArr[1];
		var CurrDateDay=CurrDateArr[0];
	}
	if (dtformat=="YMD"){
		var OrderStartDateArr=OrderStartDate.split("-");
		var OrderStartDateYear=OrderStartDateArr[0];
		var OrderStartDateMonth=OrderStartDateArr[1];
		var OrderStartDateDay=OrderStartDateArr[2];
		
		var CurrDateArr=CurrDate.split("-");
		var CurrDateYear=CurrDateArr[0];
		var CurrDateMonth=CurrDateArr[1];
		var CurrDateDay=CurrDateArr[2];
	}
 	
	
	var objDate = new Date(OrderStartDateYear,OrderStartDateMonth,OrderStartDateDay,0,0,0);
	var minDate = new Date(CurrDateYear,CurrDateMonth,CurrDateDay,0,0,0);
	//alert(minDate.getTime()+"^"+objDate.getTime());
	if (minDate.getTime() > objDate.getTime()) return false;
	return true;
}

function DateTimeLimited(priorty,Lstr,d,t){

	if (d=="" && t=="") {return "Y";}

	var nowdt=new Date();
	var yy=nowdt.getYear();
	var mm=nowdt.getMonth();
	var dd=nowdt.getDate();
	var H=nowdt.getHours();
	var M=nowdt.getMinutes();
	var S=nowdt.getSeconds();
	
	if (d==""){
	  var tyy=yy;	
	  var tmm=mm;
	  var tdd=dd;
	}else{
	   tmp=d.split("/");
	   var tyy=tmp[2];	
	   var tmm=tmp[1]-1;
	   var tdd=tmp[0];
	}
	if (t==""){
	   var tH=H;
	   var tM=M;
	   var tS=S;	
	}else {
	   tmp1=t.split(":");
	   var tH=tmp1[0];
	   var tM=tmp1[1];
	   var tS=0;  	
	}
 var stopdtstr=new Date(tyy,tmm,tdd,tH,tM,tS);
 var stopdt=stopdtstr.getTime();           
 //var limdtL=nowdt.getTime()-(5*60*1000);         
 var LimdtLstr=new Date(yy,mm,dd,0,0,1);      
 var limdtL=LimdtLstr.getTime();
 //var limdt2=nowdt.getTime()+(24*60*60*1000);     
 var limdt3=new Date();
 //    limdt3.setTime(limdt2);
 var limY=limdt3.getYear();
 var limM=limdt3.getMonth();
 var limD=limdt3.getDate();
 var limdtstr=new Date(limY,limM,limD,23,59,59);  
 var limdtU=limdtstr.getTime();
	var pos=priorty.indexOf(Lstr);
	if (pos>-1) {                         //long priorty
   	if (stopdt>=limdtL){return "Y"}else {return "N"}
	}else {
		if (stopdt>=limdtL&&stopdt<=limdtU){return "Y"}else{return "N"}
	}
}


function TrimOrdDesc(value) {
	var objtbl=document.getElementById('OrdDesc'); 
	var s=value;
	var temp=s.split("^");
	s=temp[0];
	objtbl.value=s
	//var temp1=s.split("-");
	//if (temp1.length==1){objtbl.value=s;}else{objtbl.value=temp1[1];}
}

function OrdDesc_keyDown(){
	if (event.keyCode==13){OrdDesc_lookuphandler();}
}

function OrdDesc_lookuphandler() {
	if (evtName=='OrdDesc') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
		var url='websys.lookup.csp';
		url += "?ID=d50133iOrdDesc";
		url += "&CONTEXT=Kweb.UDHCStopOrder:orderlookup";
		url += "&TLUJSF=TrimOrdDesc";
		var obj=document.getElementById('OrdDesc');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('EpisodeID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		var obj=document.getElementById('""');
		if (obj) url += "&P5=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
}
function lulocdes_keydown(){
	if (event.keyCode==13){
        lulocdes_lookuphandler();
	}
}

function lulocdes_lookuphandler() {
		var url='websys.lookup.csp';
		url += "?ID=d50133ilulocdes";
		url += "&CONTEXT=Kweb.DHCDocOrderCommon:ctloclookup";
		//url += "&CONTEXT=Kweb.UDHCANOPSET:ctloclookup";
		url += "&TLUJSF=getloc";
		var obj=document.getElementById('lulocdes');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	
}



function getloc(str)
{ 
		var loc=str.split("^");
		var locdes=document.getElementById("lulocdes")
		locdes.value=loc[1];
		var obj=document.getElementById("luloc")
		obj.value=loc[0];
		//alert(loc[1]);
	
}


//////////////////////////////////////////////////////////////////
function OEORISttDat_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var Row=GetEventRow(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var objid='EndDatez'+Row;
		var obj=document.getElementById(objid);
		if (!IsValidDate(obj)) return;
		//因为弹出的时间选择窗口会调用与传入的ID_lookupSelect的方法?所以如果这时不能传入当前对象的的ID?否则会找不到相应的方法
		var url='websys.lookupdate.csp?ID=OEORISttDat&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}

function GetEventRow(e)
{
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1];
	var TDSrc=websys_getParentElement(obj);
	var TRSrc=websys_getParentElement(TDSrc);
	FocusRowIndex=TRSrc.rowIndex;
	return Row
}


function OEORISttDat_lookupSelect(dateval) {
	//alert(FocusRowIndex);
	//var Row=GetRow(FocusRowIndex);
	//alert(Row);
	//var obj=document.getElementById('EndDatez'+Row);
	var obj=document.getElementById('EndDatez'+FocusRowIndex);
	obj.value=dateval;
	SetFocusColumn("EndTimez",FocusRowIndex);
	//websys_nexttab('4',obj.form);
}
function OEORISttDat_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return  websys_cancel();
	} else {
		eSrc.className='';
		//SetFocusColumn("OrderStartTime",Row);
	}
}

function OEORISttTim_changehandler(e) {
	var Row=GetEventRow(e);
	var eSrc=websys_getSrcElement(e);
	if (!IsValidTime(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	} else {
		//SetFocusColumn("OrderName",Row);
		eSrc.className='';
	}
}

//var dtseparator='/';
//var dtformat='DMY';
function DateMsg(itemname) {
  var msg='';
  try {
	if (!IsValidDate(document.getElementById(itemname))) {
		msg+="\'" + t[itemname] + "\' " + t['XDATE'] + "\n";
		if (focusat==null) focusat=document.getElementById(itemname);
	}
	return msg;
  } catch(e) {return msg;};
}
function isLeapYear(y) {
 return ((y%4)==0)&&(!(((y%100)==0)&&((y%400)!=0)));
}function ReWriteDate(d,m,y) {
 y=parseInt(y,10);
 if (y<15) y+=2000; else if (y<100) y+=1900;
 if ((y>99)&&(y<1000)) y+=1900;
 if ((d<10)&&(String(d).length<2)) d='0'+d;
 if ((m<10)&&(String(m).length<2)) m='0'+m;
 var newdate='';
 if (dtformat=="DMY") newdate=d+'/'+m+'/'+y;
 if (dtformat=="YMD") newdate=y+"-"+m+"-"+d;
 
 return newdate;
}
/*function IsValidDate(fld) {
 var dt=fld.value;
 var re = /^(\s)+/ ; dt=dt.replace(re,'');
 var re = /(\s)+$/ ; dt=dt.replace(re,'');
 var re = /(\s){2,}/g ; dt=dt.replace(re,' ');
 if (dt=='') {fld.value=''; return 1;}
 re = /[^0-9A-Za-z]/g ;
 dt=dt.replace(re,'/');
 for (var i=0;i<dt.length;i++) {
    var type=dt.substring(i,i+1).toUpperCase();
    if (type=='T'||type=='W'||type=='M'||type=='Y') {
       if (type=='T') {return ConvertTDate(fld);} else {return ConvertWMYDate(fld,i,type);}
       break;
    }
 }
 //if ((dt.indexOf('/')==-1)&&(dt.indexOf('-')==-1)&&(dt.length>2)) dt=ConvertNoDelimDate(dt);
 dt=ConvertNoDelimDate(dt);
 //var dtArr=dt.split('/');
 if (dtformat=="DMY") var dtArr=dt.split('/');
 if (dtformat=="YMD") var dtArr=dt.split('-');
 var len=dtArr.length;
 if (len>3) return 0;
 for (i=0; i<len; i++) {
  if (dtArr[i]=='') return 0;
 }
 var dy,mo,yr;
 for (i=len; i<3; i++) dtArr[i]='';
 if (dtformat=="DMY") dy=dtArr[0];mo=dtArr[1];yr=dtArr[2];
 if (dtformat=="YMD") dy=dtArr[2];mo=dtArr[1];yr=dtArr[0];
 if ((String(yr).length!=2)&&(String(yr).length!=4)&&(String(yr).length!=0)) return 0;
 if ((String(yr).length==4)&&(yr<1840)) return 0;
 
 var today=new Date();
 if (yr=='') {
  yr=today.getYear();
  if (mo=='') mo=today.getMonth()+1;
 }
 
 if ((isNaN(dy))||(isNaN(mo))||(isNaN(yr))) return 0;
 if ((dy<1)||(dy>31)||(mo<1)||(mo>12)||(yr<0)) return 0;
 if (mo==2) {
  if (dy>29) return 0;
  if ((!isLeapYear(yr))&&(dy>28)) return 0;
 }
 if (((mo==4)||(mo==6)||(mo==9)||(mo==11))&&(dy>30)) return 0;
 if (isMaxedDate(dy,mo,yr)) return 0;
 
 fld.value=ReWriteDate(dy,mo,yr);
 websys_returnEvent();
 return 1;
}*/
function isMaxedDate(dy,mo,yr) {
 var maxDate = new Date();
 maxDate.setTime(maxDate.getTime() + (1000*24*60*60*1000));
 yr = parseInt(yr,10); if (yr<15) yr+=2000; else if (yr<100) yr+=1900;
 if ((yr>99)&&(yr<1000)) yr+=1900;
 var objDate = new Date(yr,mo-1,dy,0,0,0);
 if (maxDate.getTime() < objDate.getTime()) return 1;
 return 0;
}
function ConvertTDate(fld) {
 var today=new Date();
 var dt=fld.value;
 var re = /(\s)+/g ;
 dt=dt.replace(re,'');
 if (dt.charAt(0).toUpperCase()=='T') {
  xdays = dt.slice(2);
  if (xdays=='') xdays=0;
  if (isNaN(xdays)) return 0;
  if ((dt.charAt(1)=='+')&&(xdays>1000)) return 0;
  xdays_ms = xdays * 24 * 60 * 60 * 1000;
  if (dt.charAt(1) == '+') today.setTime(today.getTime() + xdays_ms);
  else if (dt.charAt(1) == '-') today.setTime(today.getTime() - xdays_ms);
  else if (dt.length>1) return 0;
  fld.value=ReWriteDate(today.getDate(),today.getMonth()+1,today.getFullYear());
  websys_returnEvent();
  return 1;
 }
 return 0;
}
function ConvertWMYDate(fld,pos,type) {
 var today=new Date();
 var dt=fld.value;
 var re = /(\s)+/g ;
 dt=dt.replace(re,'');
 var x = dt.substring(0,pos);xmn=0;xyr=0;
 if (x=='') x=1;
 if (isNaN(x)) return 0;
 if (dt.substring(pos+1,dt.length)!='') return 0;
 if (type=='M') {
 while (x>11) {xyr++;x=x-12}
 xmn=today.getMonth()+eval(x);
 if (xmn>=11) {xyr++;today.setMonth(eval(xmn-12));} else {today.setMonth(xmn);}
 } else if (type=='Y') {xyr=x;
 } else {today.setTime(today.getTime() + (x * 7 * 24 * 60 * 60 * 1000));}
 if (isMaxedDate(today.getDate(),today.getMonth()+1,today.getFullYear()+eval(xyr))) return 0;
 fld.value=ReWriteDate(today.getDate(),today.getMonth()+1,today.getFullYear()+eval(xyr));
 websys_returnEvent();
 return 1;
 }
function ConvertNoDelimDate(dt)  {
 /*var len = dt.length;
 if (len%2) return dt;
 if (len>8) return dt;
 var dy=dt.slice(0,2); var mn=dt.slice(2,4); var yr=dt.slice(4);
 if (yr=='') {
  var today = new Date();
  yr=today.getYear();
 }*/
 var today = new Date();
 var yr=today.getYear();
 if (dtformat=="DMY"){
	 var dy=dt.split("/")[0];
	 var mn=dt.split("/")[1];
	 var dtconv=dy+'/'+mn+'/'+yr;
 }
 if (dtformat=="YMD"){
	 var dy=dt.split("/")[2];
	 var mn=dt.split("/")[1];
	 var dtconv=yr+"-"+mn+"-"+dy;
 }
 return dtconv
}
function TimeMsg(itemname) {
  var msg='';
  try {
	if (!IsValidTime(document.getElementById(itemname))) {
		msg+="\'" + t[itemname] + "\' " + t['XTIME'] + "\n";
		if (focusat==null) focusat=document.getElementById(itemname);
	}
	return msg;
  } catch(e) {return msg;};
}
var tmseparator=':';
function ReWriteTime(h,m,s) {
 var newtime='';
 if (h<10) h='0'+h;
 if (m<10) m='0'+m;
 if (s<10) s='0'+s;
 newtime=h+':'+m ;
 return newtime;
}
function IsValidTime(fld) {
 var TIMER=0;
 var tm=fld.value;
 var re = /^(\s)+/ ; tm=tm.replace(re,'');
 var re = /(\s)+$/ ; tm=tm.replace(re,'');
 var re = /(\s){2,}/g ; tm=tm.replace(re,' ');
 tm=tm.toUpperCase();
 var x=tm.indexOf(' AM');
 if (x==-1) x=tm.indexOf(' PM');
 if (x!=-1) tm=tm.substring(0,x)+tm.substr(x+1);
 if (tm=='') {fld.value=''; return 1;}
 re = /[^0-9A-Za-z]/g ;
 tm=tm.replace(re,':');
 if (isNaN(tm.charAt(0))) return ConvNTime(fld);
 if ((tm.indexOf(':')==-1)&&(tm.length>2)) tm=ConvertNoDelimTime(tm);
 symIdx=tm.indexOf('PM');
 if (symIdx==-1) {
  symIdx=tm.indexOf('AM');
  if (symIdx!=-1) {
   if (tm.slice(symIdx)!='AM') return 0;
   else {
    tm=tm.slice(0,symIdx);
    TIMER=1;
  }}
 } else {
  if (tm.slice(symIdx)!='PM') return 0;
  else {
   tm=tm.slice(0,symIdx);
   TIMER=2;
  }
 }
 if (tm=='') return 0;
 var tmArr=tm.split(':');
 var len=tmArr.length;
 if (len>3) return 0;
 for (i=0; i<len; i++) {
  if (tmArr[i]=='') return 0;
 }
 var hr=tmArr[0];
 var mn=tmArr[1];
 var sc=tmArr[2];
 if (len==1) {
  mn=0;
  sc=0;
 } else if (len==2) {
  if (mn.length!=2) return 0;
  sc=0;
 } else if (len==3) {
  if (mn.length!=2) return 0;
  if (sc.length!=2) return 0;
 }
 if ((hr>12)&&(TIMER==1)) return 0;
 if ((hr==12)&&(TIMER==1)) hr=0;
 if ( isNaN(hr)||isNaN(mn)||isNaN(sc) ) return 0;
 hr=parseInt(hr,10);
 mn=parseInt(mn,10);
 sc=parseInt(sc,10);
 if ((hr>23)||(hr<0)||(mn>59)||(mn<0)||(sc>59)||(sc<0)) return 0;
 if ((hr<12)&&(TIMER==2)) hr+=12;
 fld.value=ReWriteTime(hr,mn,sc);
 websys_returnEvent();
 return 1;
}
function ConvNTime(fld) {
 var now=new Date();
 var tm=fld.value;
 var re = /(\s)+/g ;
 tm=tm.replace(re,'');
 if (tm.charAt(0).toUpperCase()=='N') {
  xmin = tm.slice(2);
  if (xmin=='') xmin=0;
  if (isNaN(xmin)) return 0;
  xmin_ms = xmin * 60 * 1000;
  if (tm.charAt(1) == '+') now.setTime(now.getTime() + xmin_ms);
  else if (tm.charAt(1) == '-') now.setTime(now.getTime() - xmin_ms);
  else if (tm.length>1) return 0;
  fld.value=ReWriteTime(now.getHours(),now.getMinutes(),now.getSeconds());
  websys_returnEvent();
  return 1;
 }
 return 0;
}
function ConvertNoDelimTime(tm)  {
 if (isNaN(tm)) return tm;
 var hr=tm.slice(0,2);
 var mn=tm.slice(2);
 var tmconv=hr+':'+mn;
 return tmconv
}
var curydecimalsym='.';
var curygroupsym=',';
function IsValidCurrency(p)  {
	var CurrencyEntered=p.value;
	// js doesn't recognise grouping symbols when doing isNaN, remove grouping symbols
	// for check. These will be reset in CurrencyRound
	var strCheckNum=CurrencyEntered.replace(/\,/g, '');
	var CurrNoGrpSym=CurrencyEntered.replace(/\,/g, '');
	if (('.'==',')&&(strCheckNum.indexOf('.')!=-1)) {
		//js doesn't recognise dec. comma, only dec. point.
		strCheckNum=strCheckNum.replace(/\,/g, '.');
	}
	if (isNaN(strCheckNum)) return false;
	var IntegerPart='';
	// Ignore any spaces passed
	CurrencyEntered=CurrencyEntered.replace(/\ /g, '');
	if ((CurrencyEntered.indexOf('.'))!=-1) {
		var AryCurrencyEntered=CurrencyEntered.split('.');
		if (AryCurrencyEntered.length>2) {
			return false;
		} else if (AryCurrencyEntered.length==2) {
			//If decimal symbol is entered and decimal part is blank, number is invalid
			if (AryCurrencyEntered[1] == '') return false;
			//If a grouping symbol appears in the decimal part, number is invalid
			if (AryCurrencyEntered[1].indexOf(',')!=-1) return false;
			IntegerPart=AryCurrencyEntered[0];
		} else {
			if (AryCurrencyEntered[0]) IntegerPart=AryCurrencyEntered[0];
		}
	} else {
		IntegerPart=CurrencyEntered;
	}
	if ((IntegerPart!='')&&((IntegerPart.indexOf(','))!=-1)) {
		var ArrIntegerPart=IntegerPart.split(',');
		//If first element of array is blank then a leading grouping symbol has been passed
		if (ArrIntegerPart[0] == '') return false;
		// j set to 1 since 1st element [0] can be shorter than 3, all other groups must be 3.
		for (var j=1; j<ArrIntegerPart.length; j++) {
			if (ArrIntegerPart[j].length != 3) return false
		}
	}
	p.value=CurrencyRound(MedtrakCurrToJSMath(CurrNoGrpSym));
	websys_returnEvent();
	return true;
}

///////////////////////////////////////////////////////////////////////////
//document.body.onload = BodyLoadHandler;
if(window.addEventListener){
	addHand(window,"load",BodyLoadHandler);   //IE11里的addEventListener参数不带"on"
}else{
	addHand(window,"onload",BodyLoadHandler);
}

var obj=document.getElementById("RevokeItem");
if (obj){obj.onclick=RevokeItem_Click;}

function RevokeItem_Click()
{
	var OrdList=GetStopOrdID();
	if(OrdList=="") {
	alert(t['selectRemoveOrder'])
	return;
	}
  if (OrdList==-1) return 0;
  if (OrdList!="")
  {
  	var UserID=session['LOGON.USERID']
  	var obj=document.getElementById("RevokeMethod");
  	var encmeth="";
  	if(obj)encmeth=obj.value;
  	if (encmeth!=""){
  		var myrtn=cspRunServerMethod(encmeth,OrdList,UserID);
  		if (myrtn=="0"){
  			alert("作废成功");
  			var OrdDescobj=document.getElementById("OrdDesc");
				var EpisodeIDobj=document.getElementById("EpisodeID");
				var CurDataFlagobj=document.getElementById("CurDataFlag");
				var Lflagobj=document.getElementById("Lflag");
				var Sflagobj=document.getElementById("Sflag");
				var patientnameobj=document.getElementById("patientname");
				var RegistrationNoobj=document.getElementById("RegistrationNo");
				var lulocdesobj=document.getElementById("lulocdes");
				var admobj=document.getElementById("adm");
				var Userobj=document.getElementById("User");
				var cur=0;
				var sfl=0;
				var lfl=0;
				if (Lflagobj.checked){lfl="on"}
				if (Sflagobj.checked){sfl="on"}
				if (CurDataFlagobj.checked){cur="on";}
				var tmpstr="";
				tmpstr+='websys.default.csp?WEBSYS.TCOMPONENT=UDHCStopOrder';
				tmpstr+='&OrdDesc='+OrdDescobj.value;
				tmpstr+='&EpisodeID='+EpisodeIDobj.value;
				tmpstr+='&CurDataFlag='+cur;
				tmpstr+='&Sflag='+sfl;
				tmpstr+='&Lflag='+lfl;
				tmpstr+='&patientname='+patientnameobj.value;
				tmpstr+='&RegistrationNo='+RegistrationNoobj.value;
		    tmpstr+='&lulocdes='+lulocdesobj.value;
		    tmpstr+='&adm='+admobj.value;
		    tmpstr+='&User='+Userobj.value;
		    window.location.href=tmpstr; 
  		}
      else if(myrtn=="-100")alert("没有找到");
  		else if(myrtn=="-102")alert("已经收费");
  		else if(myrtn=="-103")alert("作废医嘱要和下医嘱人一致");
  		else if(myrtn=="-104")alert("非核实状态的医嘱不能作废");
  		else if(myrtn=="-105")alert("已经执行的医嘱不能作废");
  		else if(myrtn=="-106")alert("滚出来的核实医嘱不能作废");
  		else if(myrtn=="-200")alert(t['200']);
  		else{;}
  	}
  }
}   
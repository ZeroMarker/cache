//DHCOPAdm.js
//IF ADD DATA TO "tDHCOPAdm" SET "Disstatus"=1

var Disstatus=0
var ynadd
var zRowyn
var PatNo=""
var leftmon
var KeyDownSeqNo=0
var PartMatchQuery=0  
var ycard=0                                                    
var regfullflag=true;                                                   
//document.write("<object ID='ClsDHCPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:2759E092-B26D-4A60-B353-4F7402A4BC95' CODEBASE='../addins/client/DHCRegPring.CAB#version=1,0,0,0' VIEWASTEXT>");
//document.write("</object>");
function BodyLoadHandler() {
	//lgl+ 自动判断节假日打勾
	var getholiflag=document.getElementById('holiflag');
	if (getholiflag) {var encmeth=getholiflag.value} else {var encmeth=''};
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth);
			var obj=document.getElementById("holiday");
			obj.checked=(rtn=="1");
	  //}
	}
	
	////websys_setTitleBar("OutPatient  Registeration");
	DHCP_GetXMLConfig("InvPrintEncrypt","AppointPrint");
	var obj=document.getElementById('ReadPCSCard');
	if (obj) obj.onclick=ReadPCSCard_Click;
	var obj=document.getElementById('Fgroup');
	if (obj) obj.onclick=Fgroupt_Click;
	var obj=document.getElementById('NappSelect');
	if (obj) obj.onclick=NappSelect_Click;	
	var RegNoObj=document.getElementById('RegNo');
	if (RegNoObj) RegNoObj.onkeydown = RegNoObj_keydown;
	if (RegNoObj) RegNoObj.onchange = RegNoObj_change;
	
	var	DeptListObj=document.getElementById('DeptList');
	if (DeptListObj) DeptListObj.ondblclick = DeptListObj_click;
	if (DeptListObj) DeptListObj.onclick = DeptListObj_click1;

	var obj=document.getElementById('DocCode');
	if (obj) obj.onkeyup = DocCode_keydown;
	var obj=document.getElementById('DoctList');
	if (obj) obj.ondblclick = DoctList_DblClick;
	if (obj) obj.onkeydown = DoctList_KeyDown;
	if (obj) obj.onclick = DoctList_click;
	var obj=document.getElementById('Sex');
	if (obj) obj.onkeydown = nextfoucs;
	var obj=document.getElementById('Age');
	if (obj) obj.onkeydown = nextfoucs;
	var obj=document.getElementById('Name');
	if (obj) obj.onkeydown = nextfoucs;
	//
	var obj=document.getElementById("PayQty");
	if (obj) obj.onkeydown = PayQty_Change;
	//
	var obj=document.getElementById('tDHCOPAdm');
	if (obj) obj.ondblclick = tDHCOPAdm_DblClick;
	//
	var obj=document.getElementById('Add');
	if (obj) obj.onclick = TblRows_Add;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick=Update_Click;
	var obj=document.getElementById('Update2');
	if (obj) obj.onclick=Update2_Click;
	var obj=document.getElementById('Clear');
	if (obj) obj.onclick=Clear_Click;
	var obj=document.getElementById('Search');
	if (obj) obj.onclick=Search_Click;
	var obj=document.getElementById('ChgPasswd');
	if (obj) obj.onclick=ChgPasswd_Click;
	var obj=document.getElementById('FindPat');
	if (obj) obj.onclick=FindPat_Click;
	var obj=document.getElementById('Quit');
	if (obj) obj.onclick=Quit_Click;
	var obj=document.getElementById('CallDoc');
	if (obj) obj.onclick=CallDoc_Click;
	var obj=document.getElementById('CallNurse');
	if (obj) obj.onclick=CallNurse_Click;
	var obj=document.getElementById('DailyReport');
	if (obj) obj.onclick=DailyReport_Click;
	var obj=document.getElementById('PRINT');
	if (obj) obj.onclick=PRINT_Click;
	var obj=document.getElementById('CacelReg');
	if (obj) obj.onclick=CacelReg_Click;
	var obj=document.getElementById('SwitchReg');
	if (obj) obj.onclick=SwitchReg_Click;
	var obj=document.getElementById('PatInfoQuery');
	if (obj) obj.onclick=QueryReg_Click;
	var obj=document.getElementById('AppSelect');
	if (obj) obj.onclick=AppSelect_Click;
	var RegNoReturn=document.getElementById('RegNoReturn');
	var FeeReturn=document.getElementById('FeeReturn');
	var RegNo=document.getElementById('RegNo');
	var ColQty=document.getElementById('ColQty');
	
	var obj=document.getElementById('Cquery');
	if (obj) obj.onclick=Cquery_Click;
	//add by gwj 
    var objgetmoney=document.getElementById("GetMoney");
	var objgivemoney=document.getElementById("GiveMoney");
	var cGetmoney=document.getElementById("cGetMoney");
	var cGivemoney=document.getElementById("cGiveMoney");
	if (objgetmoney){
		objgetmoney.style.visibility="hidden";
	}
	if (objgivemoney){
		objgivemoney.style.visibility="hidden";
	}  
	if (cGetmoney){
		cGetmoney.style.visibility="hidden";
	}
	if (cGivemoney){
		cGivemoney.style.visibility="hidden";
	} //******
	RegNo.value=RegNoReturn.value;
	ColQty.value=ColQty.value-FeeReturn.value;
	websys_setfocus('RegNo');
	var obj=document.getElementById('PayMode');
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	var obj=document.getElementById("RePrint");
	if (obj){
		obj.onclick=RePrint_OnClick;
	}
	ReadPayMode();
	
	//GetReceiptNo();
}

function ReadPayMode(){
	DHCWebD_ClearAllListA("PayMode");
	var encmeth=DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode",mygLoc);
	}
}

function GetReceiptNo(){
	var receipNOobj=document.getElementById('GetreceipNO');
	if (receipNOobj) {var encmeth=receipNOobj.value} else {var encmeth=''};
	var Guser=session['LOGON.USERID'];
	if (cspRunServerMethod(encmeth,'SetReceipNO','',Guser)!='0') {
		alert(t['17'])
		return
	}	
}

function SetReceipNO(value) {
	var ls_ReceipNo=value;
	var obj=document.getElementById("ReceiptNO");
	if (obj){
		obj.value=ls_ReceipNo;
	}
}

function RePrint_OnClick(){
	try {
		////zhao  add 2006-06-21
		var objtbl=document.getElementById('tDHCOPAdm');
		var myRow=0;
		var rows=objtbl.rows.length;
		if (rows<3) {return false;}
		
		for (var j=1;j<rows-1;j++) {
			var eSrc=objtbl.rows[j];
			var RowObj=getRow(eSrc);
			var rowitems=RowObj.all;
			if (!rowitems) rowitems=RowObj.getElementsByTagName("label");		
			for (var i=0;i<rowitems.length;i++) {
				if (rowitems[i].id) {
					var Id=rowitems[i].id;
					var arrId=Id.split("z");
				    myRow=arrId[arrId.length-1];
				}
			}
			
			var value="";
			var myobj=document.getElementById('TPrtRegInfoz'+myRow);
			if (myobj){value=myobj.value;}
			
			var n=value.split("@");
			var n1=n[0];
			var n2=n[1]+ " "+n[2];
			
			var PatCategory=document.getElementById('PatCategoryz'+myRow); //yn
			var PrintPrice=document.getElementById('Pricez'+myRow); //lgl+否则挂多个号金额打出不对?
	        //alert(PrintPrice.innerText);
			var Addr=document.getElementById('Addrz'+myRow); //yn
		  	var pno=document.getElementById('RegNo').value;	
			var pname=document.getElementById('Name').value;
			var pdepdoc=PatCategory.innerText;
			var yntemp=pdepdoc.split("  ");	
			var sdep=yntemp[0];
			var sdoc=yntemp[1];
			var d=Addr.value.split("@");	
			var sadd=d[0];
			sdoc=sdoc+"("+d[1]+")";
			var newno  
			var ipno=document.getElementById('IPMRN').value; 
			var opno=document.getElementById('OPMRN').value; 
	        //ColQty;
			//ClsDHCPrint.push_out(pno,pname,sdep,sdoc,value,sadd,ipno,opno);
			var amtabs=PrintPrice.innerText; //lgl xiugai document.getElementById('ColQty').value; 	
			var txtinfo=pno+"^"+pname+"^"+sdep+"^"+sdoc+"^"+value+"^"+sadd+"^"+ipno+"^"+opno	
			var txtinfo="PatNo"+String.fromCharCode(2)+pno+"^"+"PatName"+String.fromCharCode(2)+pname+"^"+"RegDep"+String.fromCharCode(2)+sdep+"^"+"RegType"+String.fromCharCode(2)+sdoc+"^"+"PH"+String.fromCharCode(2)+n1+"^"+"IPNO"+String.fromCharCode(2)+ipno+"^"+"OPNO"+String.fromCharCode(2)+opno+"^"+"ADD"+String.fromCharCode(2)+sadd+"^"+"JE"+String.fromCharCode(2)+amtabs+"^"+"Tim"+String.fromCharCode(2)+n
	        InvPrintNew(txtinfo,"")
		}
			//print over bill
	} catch(e) {};
	
}

function ReadHFMagCard_Click()
{
	var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	leftmon=myary[3];
	var obj1=document.getElementById("PayMode");
	var RegNoObj=document.getElementById('RegNo');
	switch (rtn){
		case "0": //卡有效
			var obj=document.getElementById("RegNo");
			obj.value=myary[5];
			event.keyCode=13;
    		RegNoObj_keydown(event);
		    for (var i=0;i<obj1.length;i++) {
			    var scode=obj1.options[i].value;
			    var pmod=scode.split("^");	
	            if (pmod[2]=="CPP") {
		            obj1.options[i].selected=true;
	            }
		    }	
			break;
		case "-200": //卡无效
			alert(t['18']);
            websys_setfocus('RegNo');
			break;
		case "-201": //现金
			alert(t['21']);
            for (var i=0;i<obj1.length;i++) {
			    var scode=obj1.options[i].value;
			    var pmod=scode.split("^");	
	            if (pmod[2]=="CASH") {
		            obj1.options[i].selected=true;
	            }
		    }
			break;
		default:
	}
}
function ReadPCSCard_Click()
{
	ReadHFMagCard_Click();
	ycard=1;

//	var obj=document.getElementById("ClsPCSCard");
//	if (obj){
//		var PCSNo=obj.ReadPCSVS();
//	}

//	if (PCSNo!=""){
//		var encmeth=document.getElementById("ReadPatNo");
//		var PatInfoStr=cspRunServerMethod(encmeth.value,PCSNo);
//		var obj=document.getElementById("RegNo");
//		obj.value=PatInfoStr;
//		event.keyCode=13;
//		RegNoObj_keydown(event);
//	}else{
		
//	}
}

function Cquery_Click()
{
 Clear_Click()
 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDro";
			win=open(lnk,"Cquery","top=10,left=50,width=900,height=680");
}
function CallDoc_Click()
{
 //var lnk = "websys.default.csp?WEBSYS.TCOMPONDHCSSuserChangeUsrPin";
 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCTEST";
 win=open(lnk,"CallDoc","scrollbars=1,status=1,top=50,left=10,width=800,height=630");	
 
}
function Fgroupt_Click()
{
 //var lnk = "websys.default.csp?WEBSYS.TCOMPONDHCSSuserChangeUsrPin";
 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPF";
 win=open(lnk,"CallDoc","scrollbars=1,status=1,top=50,left=100,width=800,height=630");	
 
}
function CallNurse_Click()
{
 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDepMark";
 win=open(lnk,"CallNurse","scrollbars=1,status=1,top=1,left=1,width=1000,height=700");	
 
}


function Quit_Click()
{
  window.close();
  
}

function NappSelect_Click()
{
 var NappSelectobj=document.getElementById('NappSelect');
 var status=NappSelectobj.checked
 Clear_Click();
 NappSelectobj.checked=status;
}
function AppSelect_Click()
{
 var AppSelectobj=document.getElementById('AppSelect');
 var status=AppSelectobj.checked
 Clear_Click();
 AppSelectobj.checked=status;
}
function PRINT_Click()
{
 var rno=document.getElementById('RegNo').value;
 var name=document.getElementById('Name').value;
 if (rno==""){
	 alert(t['14']);
	 websys_setfocus('RegNo');
 }
  if ((rno!="")&&(name=="")){
	 alert(t['15']);
	 websys_setfocus('RegNo');
 }
 if ((rno!="")&&(name!="")) {
 ClsDHCPrint.push_tm(rno);  }
}
function Clear_Click()	{
		//var objtbl=document.getElementById('tDHCOPAdm');
		//var rows=objtbl.rows.length;
		//alert(rows);

		ClearRegInfo();
		ClearPatInfo();
		CleartAppoint();
		var obj=document.getElementById('DoctList');
	  	ClearAllList(obj);
	  	CleartDHCOPAdm()
	  	websys_setfocus('RegNo');
	  	PatNo=""
}


function RegNoObj_change(){
	var objtbl=document.getElementById('tDHCOPAdm');
		var rows=objtbl.rows.length;

		if (rows>2){
			alert(t["07"])
			var obj=document.getElementById('RegNo');
			if (obj) obj.value=PatNo
			return
		}
}
function RegNoObj_keydown(e) {
	//
	if (evtName=='RegNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	// 
	var key=websys_getKey(e);

	
	if (key==13) {
		//
		if (ycard==0) {
		var obj1=document.getElementById("PayMode");
        //obj1.enabled=false; 
		for (var i=0;i<obj1.length;i++) {
			    var scode=obj1.options[i].value;
			    var pmod=scode.split("^");	
	            if (pmod[2]=="CPP") {
		            obj1.options[i].selected=true;
	            }
		    }}
		var objtbl=document.getElementById('tDHCOPAdm');
		var rows=objtbl.rows.length;

		if (rows>2){
			alert(t["07"])
			var obj=document.getElementById('RegNo');
			if (obj) obj.value=PatNo
			return
		}
		
		var obj=document.getElementById('RegNo');
		if (obj.value.length<8) {
			for (var i=(8-obj.value.length-1); i>=0; i--) {
				obj.value="0"+obj.value
		}}
		
		
		if (obj.value!='') {
			var tmp=document.getElementById('RegNo');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			ClearPatInfo()
			tmp.value=p1
			
			var GetDetail=document.getElementById('GetDetail');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('RegNo');
			return websys_cancel();
			}
		} else {
			websys_setfocus('RegNo');
			return websys_cancel();
		}
		obj.className='';
		websys_nexttab(obj.tabIndex);
	}
}
function SetPatient_Sel(value) {
	try {
		var Patdetail=value.split("^");		
		var obj=document.getElementById('Name');
		if (obj) obj.value=Patdetail[0];
		var obj=document.getElementById('Age');
		if (obj) obj.value=Patdetail[1];
		var obj=document.getElementById('Sex');
		if (obj) obj.value=Patdetail[2];
		var obj=document.getElementById('OPMRN');
		if (obj) obj.value=Patdetail[3];
		var obj=document.getElementById('IPMRN');
		if (obj) obj.value=Patdetail[4];
		var obj=document.getElementById('PatCate');
		if (obj) obj.value=Patdetail[5]
		if (Patdetail[5]=="")
		{
			alert(t["12"])
			ClearPatInfo()
			return
		}
		var obj=document.getElementById('PatientID');
		if (obj) obj.value=Patdetail[6];
		var obj=document.getElementById('PatID');
		////not show Patient ID
		////zhaocz  20060711
		////if (obj) obj.value=Patdetail[7];
		var obj=document.getElementById('PatDepartment');
		if (obj) obj.value=Patdetail[8];
		
		if (PatNo==""){
			var obj=document.getElementById('RegNo');
			if (obj) PatNo=obj.value
		}
		//websys_nexttab('6');
		} catch(e) {};
}


function DeptListObj_click1() {
	//alert("dds")
	ClearRegInfo()
	var obj=document.getElementById('DoctList');
	ClearAllList(obj);

}
function DeptListObj_click(e) {
	/////////////////////------------------------
	var obj=document.getElementById('PatientID');
	var nid=obj.value;
	if (nid=="") {
	alert(t[20]);	
	return;
	}
	ClearRegInfo()
	if (evtName=='DeptList') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var tmp=document.getElementById('DeptList');
	var selItem=tmp.options[tmp.selectedIndex];	 //yn 2006-3-10                
	if (selItem) {var p1=selItem.text+"^"+session['LOGON.USERID']+"^"+""+"^"+"0"+"^"+nid} else {var p1=''};
	var GetDocMethod=document.getElementById('GetDocMethod');
	if (GetDocMethod) {var encmeth=GetDocMethod.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'AddDocToList','',p1)=='0') {
		obj.className='clsInvalid';
		//websys_setfocus('RegNo');
		return websys_cancel();
	}
	obj.className='';	
}

function AddDocToList(value) {
	try {
		//alert(value);
		var obj=document.getElementById('DoctList');
		//ClearAllList(obj);
		var DocCodeobj=document.getElementById('DocCode');
		if (DocCodeobj) var UnitPrice=parseInt(DocCodeobj.value.substring(2,DocCodeobj.value.length),10)

		var valueAry=value.split("^");
		var arytxt=new Array();
		var aryval=new Array();
		if (valueAry.length>0) {
			var j=0
			for (var i=0;i<valueAry.length;i++) {
				//alert(valueAry[i]);
				var arytmp=valueAry[i].split("\001");
				var SelectPrice=arytmp[0].split("&");
				var SelectPriceArry=SelectPrice[2]
				
				if (!isNaN(UnitPrice) && (SelectPriceArry!=UnitPrice)) continue
				
				arytxt[j]=arytmp[1]
				aryval[j]=arytmp[0];
				j++
			}	
		}
		if (obj) {
  		AddItemToList(obj,arytxt,aryval)
  		//obj.selectedIndex=0;
  		
		//	obj.className='';
		//websys_nexttab('6');
		}
	} catch(e) {};
}

function ClearAllList(obj) {
	if (obj.options.length>0) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}

function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); lstlen++;}
		}
	}
}

function ListBoxSelected(ListBoxId)	{
var row=false;
for (var i=0;i<ListBoxId.length;i++) {
	if (ListBoxId.options[i].selected) {
		row=true;
		break;
	}
}
return row;
}
function DocCode_keydown() {
	var eSrc=window.event.srcElement;
	var obj=document.getElementById('DocCode');
	var UnitPriceStatus=-1
    var UnitPrice=parseInt(obj.value.substring(2,obj.value.length),10)
    //alert(UnitPrice);
    var key=websys_getKey(e);
    if (key==8){return}
    	
	if (obj.value.length>=3) {
	  if (isNaN(UnitPrice))
	  {
		UnitPriceStatus=0
      }else{  //lgl xiugai 0613
		UnitPriceStatus=0
	    }
	 }
    
    //alert(UnitPriceStatus)

	if ((obj.value.length==2)||(UnitPriceStatus==1)){	
		var DocCode=obj.value;
		DocCode=DocCode.toUpperCase()
		DocCode=DocCode.substring(0,2)
		var DeptListObj=document.getElementById('DeptList');
		var DocListObj=document.getElementById('DoctList');
		ClearAllList(DocListObj);
		selectOptions(DeptListObj,DocCode);
		var SelectRow=ListBoxSelected(DeptListObj);
		
		if (SelectRow) {DeptListObj_click();};		
		}
	if ((obj.value.length>=3)&&(UnitPriceStatus==0)&&(key!=13)) {
		var DocCode=obj.value;
		DocCode=DocCode.toUpperCase()
		var DocListObj=document.getElementById('DoctList');
		selectOptions(DocListObj,DocCode);
		Disstatus=0
		var Docobj=document.getElementById('DoctList');
		var selectedflag=false;
		for (var i=(Docobj.length-1); i>=0; i--) {
			if (Docobj.options[i].selected) selectedflag=true;
		}
		if (selectedflag) {
			AddDataToTbl();}
		}
		
	if (key==13) {
		var Nameobj=document.getElementById('Name');
		if (Nameobj.value=="") {
	  	alert(t["08"]);
	  	return;
		}
        
        if (PartMatchQuery==1){
        	var DocCode=obj.value;
			DocCode=DocCode.toUpperCase()
			DocCode=DocCode.substring(0,2)
			var DeptListObj=document.getElementById('DeptList');
			var DocListObj=document.getElementById('DoctList');
			ClearAllList(DocListObj);
			selectOptions(DeptListObj,DocCode);
			var SelectRow=ListBoxSelected(DeptListObj);
			if (SelectRow) {DeptListObj_click();};
			
			var DocCode=obj.value;
			DocCode=DocCode.toUpperCase()
			var DocListObj=document.getElementById('DoctList');
			selectOptions(DocListObj,DocCode);
			Disstatus=0
			var obj=document.getElementById('DoctList');
			var selectedflag=false;
			for (var i=(obj.length-1); i>=0; i--) {
				if (obj.options[i].selected) selectedflag=true;
			}
			if (selectedflag) {
				AddDataToTbl();}
			else{
			    alert(t["09"])
			    var obj=document.getElementById('DocCode');
			    if (obj) obj.value=""
			    PartMatchQuery=0
			    KeyDownSeqNo=0
			    return
			}
			
			PartMatchQuery=0
        }
        
        var DocCodeobj=document.getElementById('DocCode');		
	    //DocCodeFind=DocCodeobj.value;
   	    if ((DocCodeobj.value.substring(0,1)=="?")&& (DocCodeobj.value.length>=2)){
	   	    Aliaspar=DocCodeobj.value.substring(1,DocCodeobj.value.length);
    		Aliaspar=Aliaspar.toUpperCase()
    		var lnk = "websys.defaultold.csp?WEBSYS.TCOMPONENT=DHCOPDocAliasFind&kindno="+Aliaspar;
			win=open(lnk,"DocAlias","top=240,left=400,width=360,height=258");
			PartMatchQuery=1
			return;
   		 }
	  
	
		if (KeyDownSeqNo==1)
		{
			Update_Click();
			
	        KeyDownSeqNo=0
	        return;
		}
		KeyDownSeqNo=1
		
		var obj=document.getElementById('DoctList');
		var selectedflag=false;
		for (var i=(obj.length-1); i>=0; i--) {
			if (obj.options[i].selected) selectedflag=true;
		}
		if (selectedflag) {
			var objtbl=document.getElementById('tDHCOPAdm');
			Disstatus=1
			AddDataToTbl();
			//AddRowToList(objtbl);
			//ClearLastRowFromTbl();
			//nextfoucs();
			//websys_setfocus('DoctList');
		}
	}else KeyDownSeqNo=0
}
function nextfoucs() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

function selectOptions(obj,value) {
	
	ClearRegInfo()
	for (var i=0;i<obj.length;i++) {
	    if (obj.name=="DoctList"){
   	  
	    DocCodePar=obj.options[i].value;
	    DocCodeParArry=DocCodePar.split("&");
	    Par=DocCodeParArry[1]
	    } else{
		Par=obj.options[i].value
		//alert(Par)
	    }
	    
	    if (Par==value) {
			obj.options[i].selected=true;
		} else {
			obj.options[i].selected=false;
		}	
	}
}

function unselectOptions(obj) {
	for (var i=0;i<obj.length;i++) {
		obj.options[i].selected=false;
	}
}

function TblRows_Add() {
	var objtbl=document.getElementById('tDHCOPAdm');
	AddRow(objtbl);
	return false;	
}
function DoctList_DblClick()	{
	var objtbl=document.getElementById('tDHCOPAdm');
	var obj=document.getElementById('Name');
	if (obj.value=="") {
	  alert(t[10]);
	  return;
	}

	Disstatus=1

	AddDataToTbl();
	//AddRowToList(objtbl);
	//ClearLastRowFromTbl();	
}
function DoctList_KeyDown()	{
	var key=websys_getKey(e);
	if (key==13) {
	var objtbl=document.getElementById('tDHCOPAdm');
	
	Disstatus=1
	AddDataToTbl();
	//AddRowToList(objtbl);
	//ClearLastRowFromTbl();
	
	nextfoucs();
	}	
}
//**************************************
function AddDataToTbl()	{
	var obj=document.getElementById('PatientID');
	var nid=obj.value;
	if (nid=="") {
	alert(t[20]);	
	return;
	}
	if (evtName=='DoctList') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	
	var DocList=document.getElementById('DoctList');
    var DocItem=DocList.options[DocList.selectedIndex];
    
	var LocList=document.getElementById('DeptList');
	var LocItem=LocList.options[LocList.selectedIndex];
    
	if (DocItem) {var p1Par=DocItem.value;p1ParAry=p1Par.split("&");p1=p1ParAry[0]} else {var p1=''};
	if (LocItem) {var p2=LocItem.text} else {var p2=''};
    
    var p3="F"
    var AppSelectobj=document.getElementById('AppSelect');
	if (AppSelectobj.checked==true) {
		var PatID=document.getElementById('RegNo');
		if (PatID) p3=PatID.value.toUpperCase()
	}
	
	var GetDocMethod=document.getElementById('GetDocDetail');
	if (GetDocMethod) {var encmeth=GetDocMethod.value} else {var encmeth=''};

	if (cspRunServerMethod(encmeth,'AddDocDetails','',p1,p2,p3,nid)=='0') {
		obj.className='clsInvalid';
		//websys_setfocus('RegNo');
		return websys_cancel();
	}
	obj.className='';	
}
function fadd(value) //yn
{
    ynadd="";
    ynadd=value;
}
function GetAdmQty(p1,p2){
	var obj=document.getElementById('PatientID');
	var nid=obj.value;
	if (nid=="") {
	alert(t[20]);	
	return;
	}
	/*if (evtName=='DoctList') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}    

	*/
	var p3="F"
    var AppSelectobj=document.getElementById('AppSelect');
	if (AppSelectobj.checked==true) {
		var PatID=document.getElementById('RegNo');
		if (PatID) p3=PatID.value.toUpperCase()
	}
	var GetDocMethod=document.getElementById('GetDocDetail');
	if (GetDocMethod) {var encmeth=GetDocMethod.value} else {var encmeth=''};
    //alert(p1+","+p2+","+p3+","+nid);
	if (cspRunServerMethod(encmeth,'JudgeAdmQty','',p1,p2,p3,nid)=='0') {
		obj.className='clsInvalid';
		//websys_setfocus('RegNo');
		return websys_cancel();
	}
   //return true;
}
function JudgeAdmQty(value){  //lgl
//alert(value);
var valueAry=value.split("^");
	var appSelectobj=document.getElementById('appSelect');
	var NappSelectobj=document.getElementById('NappSelect');
	var TolQty=valueAry[0];
	var AppQty=valueAry[6];
	var AdmQty=valueAry[1];
//alert(TolQty+","+AdmQty+","+AppQty);
regfullflag=true;
if(((TolQty-AdmQty-AppQty)<=0)  && (!NappSelectobj.checked) && (!appSelectobj.checked)) {
regfullflag=false;

//ClearCurrRowFromTbl()
return websys_cancel();
}
}

function AddDocDetails(value)	{

	var valueAry=value.split("^");
	//alert(valueAry)

	var DocList=document.getElementById('DoctList');
	var DocItem=DocList.options[DocList.selectedIndex];
	if (DocItem) {  //lgl+
		var p1Par=DocItem.value;p1ParAry=p1Par.split("&");DocCodeItem=p1ParAry[0]
		} 
		else {
			var DocCodeItem=''
			};
    
	var DocItemArray=DocItem.text.split(" ")
	var LocList=document.getElementById('DeptList');
	var LocItem=LocList.options[LocList.selectedIndex];
	var LocItemArray=LocItem.text.split("-")
	if (LocItemArray.length>1) { var AdmType=LocItemArray[1]+"  " +DocItemArray[0];}
	else {var AdmType=LocItemArray[0]+"  " +DocItemArray[0];}

	var Result=DuplReg(AdmType)
	if (Result==1) {
		KeyDownSeqNo=1
 		obj=document.getElementById('DocCode');
		if(obj) obj.value=""
		return
	}
	var holiprice=0;
	var UnitPrice=valueAry[5];
	var ColQty=document.getElementById("ColQty");
	/////////////////2006-3-9 判断余额够不够
	var cln=document.getElementById("Ln");
	var holiday=document.getElementById("holiday");
	if (cln.checked==true){
		UnitPrice=UnitPrice-1;
	}
	if (holiday.checked==true){
	  if(valueAry[9]=="") {   //lgl+ 防止报错
			alert("该号别没有设置节假日费");
			//return false;
		}
	  else
	  {
		holiprice=valueAry[9];
		UnitPrice=eval(UnitPrice)+eval(valueAry[9]);
	  }
		}

	var obj1=document.getElementById("PayMode");
    var pmod=obj1.value.split("^");	

	if ((pmod[2]=="CPP")&&(ycard==1)) {
   		var mon
   		mon=eval(+ColQty.value)+eval(UnitPrice);

   		if (mon>leftmon) {
	   		alert(t[19]);
	   		return;
   		}}
    if ((pmod[2]=="CPP")&&(ycard==0)) {
	    	alert(t[19]+"No Card!");
	   		return;
	    }		
   	///////////////////////////////	//////
	var ExamPrice=valueAry[8];
	var Seqno=valueAry[3]
	
	var PatCate=document.getElementById('PatCate');
    if (PatCate) PatType=PatCate.value
    if ((PatType.substring(0,1)=="5")&& (UnitPrice<=5)){
    	UnitPrice=UnitPrice - ExamPrice
    }
    if ((PatType.substring(0,1)=="4") && (UnitPrice<=9)) {
    	UnitPrice=UnitPrice-ExamPrice
    	ExamPrice=0
    }
	var TolQty=valueAry[0];
	var AppQty=valueAry[6];
	var AdmQty=valueAry[1];
	//alert(AdmQty)
	var DeptRowId=valueAry[11];//10
	var DocRowId=valueAry[12];//11
	
	ynadd="";
	var Address=document.getElementById('Address');
	if (Address) {var encmeth=Address.value} else {var encmeth=''};

	if (cspRunServerMethod(encmeth,'fadd','',DocRowId)=='0') {
			}
			
	var PatientId=document.getElementById('PatientID');
	var obj=document.getElementById('AdmType');
	if (obj) obj.value=valueAry[4];

	var obj=document.getElementById('ExamFee');
	if (obj) obj.value=valueAry[8];  //ExamPrice;
	var obj=document.getElementById('RegFee');
	if (obj) obj.value=UnitPrice-valueAry[8];  //UnitPrice-ExamPrice;   //lgl xiugai 临时如此
	var obj=document.getElementById('TotalQty');
	if (obj) obj.value=TolQty;
	var obj=document.getElementById('ApptQty');
	if (obj) obj.value=AppQty;
	var obj=document.getElementById('AvailQty');
	if (obj) obj.value=TolQty-AdmQty-AppQty;
	
	if (Disstatus==1)
	{
		if (Seqno==0){
	 		alert(t["11"])
		 return
		}

		var objtbl=document.getElementById('tDHCOPAdm');
		tk_ResetRowItemst(objtbl);
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
        var objyn=document.getElementById('NappSelect');
        
        if ((objyn.checked==true) && (rows>2)) 
        {return;}
		var eSrc=objtbl.rows[LastRow];
		var RowObj=getRow(eSrc);
		var rowitems=RowObj.all;
		if (!rowitems) rowitems=RowObj.getElementsByTagName("label");
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split("z");
				var Row=arrId[arrId.length-1];
			}
		}	
	//
		var PatCategory=document.getElementById("PatCategoryz"+Row);
		var Price=document.getElementById("Pricez"+Row);

		var SeqNo=document.getElementById("SeqNoz"+Row);
		var PAPER=document.getElementById("PAPERz"+Row);
		var DeptDr=document.getElementById("DeptDrz"+Row);
		var DocDr=document.getElementById("DocDrz"+Row);
		var ExamFee=document.getElementById("ExamFeez"+Row);
		var RegType=document.getElementById("RegTypez"+Row);
		var Addr=document.getElementById("Addrz"+Row);
		var holi=document.getElementById('holiz'+Row);
		var DocCI=document.getElementById('DocCodeItemz'+Row);
        var DocLocDesc=document.getElementById('DocLocDescz'+Row);
		Addr.innerText=ynadd; /////////////////////////////////////////////////////////
		PatCategory.innerText=AdmType;
		Price.innerText=UnitPrice;
		ExamFee.value=ExamPrice;
		holi.value=holiprice;
		//alert(holi.value);
		//yn
        var obj1=document.getElementById('NappSelect');
		if (obj1.checked==true) {
	
		   SeqNo.innerText="";
		   DeptDr.value=DeptRowId;
		   DocDr.value=DocRowId;
		   var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBef";
			win=open(lnk,"Cquery","top=300,left=500,width=200,height=200");
	     }
	    else{ 
		SeqNo.innerText=Seqno;
	    }
		DeptDr.value=DeptRowId;
		DocDr.value=DocRowId;
		PAPER.value=PatientId.value;
		RegType.value=valueAry[4];
		
		var obj=document.getElementById('DocCode');
		obj.value=""
		
		var LocList=document.getElementById('DeptList');
	    var LocItem=LocList.options[LocList.selectedIndex];	
		DocCI.value=DocCodeItem;   //lgl+
		DocLocDesc.value=LocItem.text;
		AddRowToList(objtbl);
		var appSelectobj=document.getElementById('appSelect');
		var NappSelectobj=document.getElementById('NappSelect');
		
		if(((TolQty-AdmQty-AppQty)<=0)  && (!NappSelectobj.checked) && (!appSelectobj.checked)) {
			
			// var status=NappSelectobj.checked
		////	if (!confirm(t['16'])){
			//alert(Row+"-"+Row.length)
		////	objtbl.deleteRow(rows-1);
      		//var obj=document.getElementById('DocCode');
			//obj.value=""
      		//AddRowToList(objtbl)
		////	return
   		  //// }   ////lgl xiugai 不让确认 不再挂号
   		  alert(t['30']);
   		   ClearLastRowFromTbl()
   		  return false;
   		 }

		ColQty.value=eval(+ColQty.value)+eval(UnitPrice);
	//add by gwj 
	var Getmoneyobj=document.getElementById('GetMoney');
	if (Getmoneyobj) var getmoney=Getmoneyobj.value;
	else var getmoney=""
	if (getmoney!=""){
		//alert(ColQty.value);
		//alert(getmoney);
		givemoney=eval(+ColQty.value)-eval(getmoney);
		var Givemoneyobj=document.getElementById('GiveMoney');
		Givemoneyobj.value=givemoney;
		var cGivemoney=document.getElementById("cGiveMoney");
		if (givemoney>=0){
			
			cGivemoney.innertext="应收";
		
		}
		else{cGivemoney.innertext="找零";}
	}

	//******
	    getolddoc();  //lgl+ 判断当日已挂号
		}
	}
function getolddoc() //lgl  获得该患者当天已挂号
{
	var obj=document.getElementById('RegNo');
	var nid=obj.value;
	if (nid=="") {
	alert(t[20]);	
	return;
	}
	var GetDocMethod=document.getElementById('GetOldDoc');
	if (GetDocMethod) {var encmeth=GetDocMethod.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'esmteOldDoc',"",nid,'0')=='0') {
		//obj.className='clsInvalid';
		websys_setfocus('RegNo');
		return websys_cancel();
	}
	obj.className='';	
	
}
function esmteOldDoc(value){
	if (value==0) return;
	var valueary1=value.split("!");
	var values="该患者本日已经挂科室为:\n"
	for (i=0;i<valueary1.length;i++){
		var valueary2=valueary1[i].split("^");
		values=values+valueary2[1]+"的"+valueary2[3]+";\n"+"挂号时间为:"+valueary2[4]+"挂号人为:"+valueary2[5]+"\n";
	}
    values=values+"        您是否要继续?\n"
		var ContiuCheck=confirm((values),false);
        if (ContiuCheck==false) {
	        ClearLastRowFromTbl();
	        return false;
        }
        return true;
	
}
function ClearLastRowFromTbl()	{
	var objtbl=document.getElementById('tDHCOPAdm');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-2;
		objtbl.deleteRow(lastrowindex);
tk_ResetRowItemst(objtbl)	

}

function tDHCOPAdm_DblClick()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOPAdm');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (lastrowindex==selectrow) return;
	if (selectrow !=0) {
		
		var eSrc1=objtbl.rows[selectrow];
		var RowObj1=getRow(eSrc1);
		var rowitems1=RowObj1.all;
		if (!rowitems1) rowitems1=RowObj1.getElementsByTagName("label");
		for (var j=0;j<rowitems1.length;j++) {
			if (rowitems1[j].id) {
			var Id=rowitems1[j].id;
			var arrId1=Id.split("z");
			var Row1=arrId1[arrId1.length-1];
			}
		}
		var Price=document.getElementById("Pricez"+Row1);
		var ColQty=document.getElementById("ColQty");
		ColQty.value=eval(+ColQty.value)-eval(Price.innerText);
		objtbl.deleteRow(selectrow);
		tk_ResetRowItemst(objtbl);
	}
}

function AddRowToList(objtbl) {
	
	var row=objtbl.rows.length;
	//alert(row);
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6

	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=arrId[arrId.length-1]+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
			rowitems[j].innerText="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
    //alert(objtbl.rows.length);
}

function PayQty_Change()	{

	if (evtName=='PayQty') {
	window.clearTimeout(evtTimer);
	evtTimer='';
	evtName='';
	}
	// 
	var key=websys_getKey(e);
	if (key==13) {
	var ColQty=document.getElementById("ColQty");
	var PayQty=document.getElementById("PayQty");
	var TrailQty=document.getElementById("Trail");
	TrailQty.value=ColQty.value-PayQty.value;
	nextfoucs();
	}	
}

function Update_Click()	{
	var objtbl=document.getElementById('tDHCOPAdm');
	
	var p9="F"
	var p10="F"
	var AppSelectobj=document.getElementById('AppSelect');
	var AppSelectobj1=document.getElementById('NappSelect');
	if (AppSelectobj.checked==true) {
		var p9="T"
	}
	if (AppSelectobj1.checked==true) {
		var p10="T"
	}
	var rows=objtbl.rows.length;
	if (rows<3) {alert(t["13"]);	return false;}
	//
		var amtabs=document.getElementById('ColQty').value; 
		var pno=document.getElementById('RegNo').value;	
        var zid=""; 
		if (ycard==1){
			var ren=DHCACC_CheckMCFPay(amtabs,pno);
		  	var myary=ren.split("^");
		  	
				if (myary[0]!='0')
				{
					//alert(myary);
					return;
				}
				
				if (myary[0]=='-204')
				{
					alert(t[2042]);
					return;
				}
				if (myary[0]=='-205')
				{
					alert(t[2043]);
					return;
				}
				if (myary[0]=='-206')
				{
					alert(t[2044]);
					return;
				}
				if (myary[0]!='0' && myary[0]!='-208'){ 
					return;
				}
			    if (myary[0]=='0'){ 
					var zid=myary[1];
				}
		}

	for (var j=1;j<rows-1;j++) {
		var eSrc=objtbl.rows[j];
		var RowObj=getRow(eSrc);
		var rowitems=RowObj.all;
		if (!rowitems) rowitems=RowObj.getElementsByTagName("label");		
		for (var i=0;i<rowitems.length;i++) {
			if (rowitems[i].id) {
				var Id=rowitems[i].id;
				var arrId=Id.split("z");
			    zRowyn=arrId[arrId.length-1];
			}
		}
		var pat=document.getElementById('PAPERz'+zRowyn);
		var loc=document.getElementById('DeptDrz'+zRowyn);
		var doc=document.getElementById('DocDrz'+zRowyn);
		var price=document.getElementById('Pricez'+zRowyn);	
		var seqno=document.getElementById('SeqNoz'+zRowyn);
		if ((AppSelectobj1.checked==true)&&(seqno.innerText=="")){
			alert(t['06']);
			return;
			}
		//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&	 
		var objfs=document.getElementById("PayMode");
        var pmod=objfs.value.split("^");

        var fs=pmod[2];
		var examfee=document.getElementById('ExamFeez'+zRowyn);
		var hoprice=document.getElementById('holiz'+zRowyn);
		var RegType=document.getElementById('RegTypez'+zRowyn);
		var DocCodeItem=document.getElementById('DocCodeItemz'+zRowyn);
		var DocLocDesc=document.getElementById('DocLocDescz'+zRowyn);  //lgl+
		var PatCategory=document.getElementById('PatCategoryz'+zRowyn)
		if (hoprice) {var p11=hoprice.value} else {var p11=""};
		if (pat) {var p1=pat.value} else {var p1=""};
		if (loc) {var p2=loc.value} else {var p2=""};
		if (doc) {var p3=doc.value} else {var p3=""};
		if (seqno) {var p4=seqno.innerText} else {var p4="";};

		if (examfee) {var p5=examfee.value} else {var p5="";};
		if (price) {var p6=price.innerText} else {var p6="";};
		//alert(price.innerText);
		if (RegType) {var p8=RegType.value} else {var p8="";};
		var p7=session['LOGON.USERID'];
		var Grp=session['LOGON.GROUPID'];

        //var holi="0"; 
        //var hol=document.getElementById("holiday");
	    //if (hol.checked==true){

		//      holi="1"; 

	    // }
         
		var PAADMMethod=document.getElementById('PAADM');
		GetAdmQty(DocCodeItem.value,DocLocDesc.value);   //lgl+
		if (!regfullflag){
			alert(t['30']+":"+PatCategory.innerText);
			return false;
		}

		if (PAADMMethod) {var encmeth=PAADMMethod.value;} else {var encmeth=''};
		var myrtn =(cspRunServerMethod(encmeth,'paadm_check','',p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,fs,Grp,zid,p11))

		if (myrtn=='0') {
			obj.className='clsInvalid';
			return websys_cancel();
			}
		}

		if (myrtn!="0"){
			var myrtn=confirm(t["RegOK"]);
			if (!myrtn){
				return;
			}
				ClearRegInfo();
				ClearPatInfo();
				var obj=document.getElementById('DoctList');
		  		ClearAllList(obj);
		  		CleartDHCOPAdm()
		  		websys_setfocus('RegNo');
			obj.className='';
		}else{
			alert(t['RegFail']);
		}
		//return false;
		//websys_setfocus('Clear');
}

function paadm_check(value) {
	try {
		var n=value.split("@");
		var n1=n[0];
		var n2=n[1]+ " "+n[2];
		if (n1=="error"){
		  alert(t['05'])
		  return
		}
		////zhao  add 2006-06-21
		var obj=document.getElementById("PrtRegInfo");
		if (obj){obj.value=value;}
		////alert(value);
		
		var myobj=document.getElementById('TPrtRegInfoz'+zRowyn);
		if (myobj){myobj.value=value;}
		
		
		var objtbl=document.getElementById('tDHCOPAdm');
		var PatCategory=document.getElementById('PatCategoryz'+zRowyn); //yn
		var PrintPrice=document.getElementById('Pricez'+zRowyn); //lgl+否则挂多个号金额打出不对?
        //alert(PrintPrice.innerText);
		var Addr=document.getElementById('Addrz'+zRowyn); //yn
	  	var pno=document.getElementById('RegNo').value;	
		var pname=document.getElementById('Name').value;
		var pdepdoc=PatCategory.innerText;
		var yntemp=pdepdoc.split("  ");	
		var sdep=yntemp[0];
		var sdoc=yntemp[1];
		var d=Addr.value.split("@");
		//alert(String.fromCharCode(2))	
		var sadd=d[0];
		sdoc=sdoc+"("+d[1]+")";
		var newno  
		var ipno=document.getElementById('IPMRN').value; 
		var opno=document.getElementById('OPMRN').value; 
        //ColQty;
		//ClsDHCPrint.push_out(pno,pname,sdep,sdoc,value,sadd,ipno,opno);
		//cjb 2006-12-24
		
		var PatAccBalance=""
		var obj=document.getElementById("RegNo");
		if (obj)
		{ 
			var TMPRegNo=obj.value;	
			var obj=document.getElementById("GetAccLeftByRegNo");	
			if (obj){ var encmeth=obj.value;	}	
			if (encmeth!="")
			{
				var myrtn=cspRunServerMethod(encmeth,TMPRegNo,0, "")
				var PatAccBalance=myrtn.split("^")[1];
			}
			
		}
		//cjb 2006-12-24
		
		//alert("PatAccBalance"+PatAccBalance)
		var amtabs=PrintPrice.innerText; //lgl xiugai document.getElementById('ColQty').value; 	
		var txtinfo=pno+"^"+pname+"^"+sdep+"^"+sdoc+"^"+value+"^"+sadd+"^"+ipno+"^"+opno	
		var txtinfo="PatNo"+String.fromCharCode(2)+pno+"^"+"PatName"+String.fromCharCode(2)+pname+"^"+"RegDep"+String.fromCharCode(2)+sdep+"^"+"RegType"+String.fromCharCode(2)+sdoc+"^"+"PH"+String.fromCharCode(2)+n1+"^"+"IPNO"+String.fromCharCode(2)+ipno+"^"+"OPNO"+String.fromCharCode(2)+opno+"^"+"ADD"+String.fromCharCode(2)+sadd+"^"+"RegCosts"+String.fromCharCode(2)+amtabs+"^"+"RegDate"+String.fromCharCode(2)+n2+"^"+"PatAccBalance"+String.fromCharCode(2)+PatAccBalance
        txtinfo+="^RpFlag"+String.fromCharCode(2)
        //alert(txtinfo);
        InvPrintNew(txtinfo,"")
		//print over bill
		


	} catch(e) {};
}
function Update2_Click()	{  //lgl xiugai  只挂号 不打印 临时如此;回头用flag标志区分
	var objtbl=document.getElementById('tDHCOPAdm');
	
	var p9="F"
	var p10="F"
	var AppSelectobj=document.getElementById('AppSelect');
	var AppSelectobj1=document.getElementById('NappSelect');
	if (AppSelectobj.checked==true) {
		var p9="T"
	}
	if (AppSelectobj1.checked==true) {
		var p10="T"
	}
	var rows=objtbl.rows.length;
	if (rows<3) {alert(t["13"]);	return false;}
	//
		var amtabs=document.getElementById('ColQty').value; 
		var pno=document.getElementById('RegNo').value;	
        var zid=""; 
		if (ycard==1){
			var ren=DHCACC_CheckMCFPay(amtabs,pno);
		  	var myary=ren.split("^");
		  	
				if (myary[0]!='0')
				{
					//alert(myary);
					return;
				}
				
				if (myary[0]=='-204')
				{
					alert(t[2042]);
					return;
				}
				if (myary[0]=='-205')
				{
					alert(t[2043]);
					return;
				}
				if (myary[0]=='-206')
				{
					alert(t[2044]);
					return;
				}
				if (myary[0]!='0' && myary[0]!='-208'){ 
					return;
				}
			    if (myary[0]=='0'){ 
					var zid=myary[1];
				}
		}
	for (var j=1;j<rows-1;j++) {
		var eSrc=objtbl.rows[j];
		var RowObj=getRow(eSrc);
		var rowitems=RowObj.all;
		if (!rowitems) rowitems=RowObj.getElementsByTagName("label");		
		for (var i=0;i<rowitems.length;i++) {
			if (rowitems[i].id) {
				var Id=rowitems[i].id;
				var arrId=Id.split("z");
			    zRowyn=arrId[arrId.length-1];
			}
		}
		var pat=document.getElementById('PAPERz'+zRowyn);
		var loc=document.getElementById('DeptDrz'+zRowyn);
		var doc=document.getElementById('DocDrz'+zRowyn);
		var price=document.getElementById('Pricez'+zRowyn);	
		var seqno=document.getElementById('SeqNoz'+zRowyn);
		if ((AppSelectobj1.checked==true)&&(seqno.innerText=="")){
			alert(t['06']);
			return;
			}
		//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&	 
		var objfs=document.getElementById("PayMode");
        var pmod=objfs.value.split("^");

        var fs=pmod[2];
		var examfee=document.getElementById('ExamFeez'+zRowyn);
		var hoprice=document.getElementById('holiz'+zRowyn);
		var RegType=document.getElementById('RegTypez'+zRowyn);
		if (hoprice) {var p11=hoprice.value} else {var p11=""};
		if (pat) {var p1=pat.value} else {var p1=""};
		if (loc) {var p2=loc.value} else {var p2=""};
		if (doc) {var p3=doc.value} else {var p3=""};
		if (seqno) {var p4=seqno.innerText} else {var p4="";};

		if (examfee) {var p5=examfee.value} else {var p5="";};
		if (price) {var p6=price.innerText} else {var p6="";};
		//alert(price.innerText);
		if (RegType) {var p8=RegType.value} else {var p8="";};
		var p7=session['LOGON.USERID'];
		var Grp=session['LOGON.GROUPID'];

        //var holi="0"; 
        //var hol=document.getElementById("holiday");
	    //if (hol.checked==true){

		//      holi="1"; 

	    // }

		var PAADMMethod=document.getElementById('PAADM');
		
		if (PAADMMethod) {var encmeth=PAADMMethod.value;} else {var encmeth=''};

		if (cspRunServerMethod(encmeth,'paadm_check2','',p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,fs,Grp,zid,p11)=='0') {
			obj.className='clsInvalid';
			return websys_cancel();
			}
		}
		
		var myrtn=confirm(t["RegOK"]);
		if (!myrtn){
			return;
		}
			ClearRegInfo();
			ClearPatInfo();
			var obj=document.getElementById('DoctList');
	  		ClearAllList(obj);
	  		CleartDHCOPAdm()
	  		websys_setfocus('RegNo');
		obj.className='';
		//return false;
		//websys_setfocus('Clear');
}
function paadm_check2(value) {  //lgl xiugai

	try {
		var n=value.split("@");
		var n1=n[0];
		var n2=n[1]+ " "+n[2];
		if (n1=="error"){
		  alert(t['05'])
		  return
		}
		////zhao  add 2006-06-21
		var obj=document.getElementById("PrtRegInfo");
		if (obj){obj.value=value;}
		////alert(value);
		
		var myobj=document.getElementById('TPrtRegInfoz'+zRowyn);
		if (myobj){myobj.value=value;}
		
		
		var objtbl=document.getElementById('tDHCOPAdm');
		var PatCategory=document.getElementById('PatCategoryz'+zRowyn); //yn
		var PrintPrice=document.getElementById('Pricez'+zRowyn); //lgl+否则挂多个号金额打出不对?
        //alert(PrintPrice.innerText);
		var Addr=document.getElementById('Addrz'+zRowyn); //yn
	  	var pno=document.getElementById('RegNo').value;	
		var pname=document.getElementById('Name').value;
		var pdepdoc=PatCategory.innerText;
		var yntemp=pdepdoc.split("  ");	
		var sdep=yntemp[0];
		var sdoc=yntemp[1];
		var d=Addr.value.split("@");	
		var sadd=d[0];
		sdoc=sdoc+"("+d[1]+")";
		var newno  
		var ipno=document.getElementById('IPMRN').value; 
		var opno=document.getElementById('OPMRN').value; 
        //ColQty;
		//ClsDHCPrint.push_out(pno,pname,sdep,sdoc,value,sadd,ipno,opno);
		var amtabs=PrintPrice.innerText; //lgl xiugai document.getElementById('ColQty').value; 	
		var txtinfo=pno+"^"+pname+"^"+sdep+"^"+sdoc+"^"+value+"^"+sadd+"^"+ipno+"^"+opno	
		var txtinfo="PatNo"+String.fromCharCode(2)+pno+"^"+"NAME"+String.fromCharCode(2)+pname+"^"+"DEP"+String.fromCharCode(2)+sdep+"^"+"HB"+String.fromCharCode(2)+sdoc+"^"+"PH"+String.fromCharCode(2)+n1+"^"+"IPNO"+String.fromCharCode(2)+ipno+"^"+"OPNO"+String.fromCharCode(2)+opno+"^"+"ADD"+String.fromCharCode(2)+sadd+"^"+"JE"+String.fromCharCode(2)+amtabs+"^"+"Tim"+String.fromCharCode(2)+n2
        txtinfo+="^RpFlag"+String.fromCharCode(2)+" "
        //alert(txtinfo);
        //InvPrintNew(txtinfo,"")
		//print over bill
		


	} catch(e) {};
}
function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}
function DoctList_click()	{
		//alert("dsds");
	
	Disstatus=0
	var obj=document.getElementById('DoctList');
		var selectedflag=false;
		for (var i=(obj.length-1); i>=0; i--) {
			if (obj.options[i].selected) selectedflag=true;
		}
		if (selectedflag) {
			AddDataToTbl();}
}

function DuplReg(DeptDocPar)	{
	var objtbl=document.getElementById('tDHCOPAdm');
	var rows=objtbl.rows.length;
	//
	for (var j=1;j<rows-1;j++) {
		var eSrc=objtbl.rows[j];
		var RowObj=getRow(eSrc);
		var rowitems=RowObj.all;
		if (!rowitems) rowitems=RowObj.getElementsByTagName("label");		
		for (var i=0;i<rowitems.length;i++) {
			if (rowitems[i].id) {
				var Id=rowitems[i].id;
				var arrId=Id.split("z");
				var zRow=arrId[arrId.length-1];
			}
		}
		var pat=document.getElementById('PatCategoryz'+zRow);
	    if (DeptDocPar==pat.innerText)	return 1;
	}
	return 0;
}

function ClearRegInfo(){
	var obj=document.getElementById('AdmType');
	if (obj) obj.value="" 
	var obj=document.getElementById('RegFee');
	if (obj) obj.value="" 
	var obj=document.getElementById('ExamFee');
	if (obj) obj.value="";
	var obj=document.getElementById('TotalQty');
	if (obj) obj.value="" 
	var obj=document.getElementById('ApptQty');
	if (obj) obj.value="" 
	var obj=document.getElementById('AvailQty');
	if (obj) obj.value="" 
}

function ClearPatInfo(){
	ycard=0;
	var obj=document.getElementById('PatientID');
	if (obj) obj.value="" 
	var obj=document.getElementById('RegNo');
	if (obj) obj.value="" 
	var obj=document.getElementById('DocCode');
	if (obj) obj.value="" 
	var obj=document.getElementById('Sex');
	if (obj) obj.value="" 
	var obj=document.getElementById('PatID');
	if (obj) obj.value="" 
	var obj=document.getElementById('Age');
	if (obj) obj.value="" 
	var obj=document.getElementById('IPMRN');
	if (obj) obj.value="" 
	var obj=document.getElementById('Name');
	if (obj) obj.value="" 
	var obj=document.getElementById('OPMRN');
	if (obj) obj.value="" 
	var obj=document.getElementById('PatCate');
	if (obj) obj.value="" 
	var obj=document.getElementById('PatDept');
	if (obj) obj.value="" 
	var obj=document.getElementById('ColQty');
	if (obj) obj.value="" 
	var obj=document.getElementById('PatDepartment');
	if (obj) obj.value="" 
	 
	
}

function CleartAppoint()
{
	var obj=document.getElementById('AppSelect');
	if (obj) obj.checked=false 
	var obj=document.getElementById('NappSelect');
	if (obj) obj.checked=false
	//add by gwj 
	var objgetmoney=document.getElementById("GetMoney");
	var objgivemoney=document.getElementById("GiveMoney");
	var cGetmoney=document.getElementById("cGetMoney");
	var cGivemoney=document.getElementById("cGiveMoney");
	if (objgetmoney){
		objgetmoney.value="";
	}
	if (objgivemoney){
    	objgivemoney.value="";
	}
	if (objgetmoney){
		objgetmoney.style.visibility="hidden";
	}
	if (objgivemoney){
		objgivemoney.style.visibility="hidden";
	}  
	if (cGetmoney){
		cGetmoney.style.visibility="hidden";
	}
	if (cGivemoney){
		cGivemoney.style.visibility="hidden";
	} //******
	//******
}

function CleartDHCOPAdm()
{
	var objtbl=document.getElementById('tDHCOPAdm');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex;j++) {
		objtbl.deleteRow(1);
	}
tk_ResetRowItemst(objtbl)	
}

function Search_Click()
{
	var RegNoObj=document.getElementById('RegNo');
	if (RegNoObj) {
		RegNoObj.value="MR000100";
			p1=RegNoObj.value
			var GetDetail=document.getElementById('GetDetail');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',p1)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('RegNo');
			return websys_cancel();
			}
	}
}

function ChgPasswd_Click()
{
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPReg";
  win=open(lnk,"BaseInfo","top=100,left=100,width=800,height=400");	
}

function FindPat_Click()
{
 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind";
			win=open(lnk,"FindPatReg","top=150,left=150,width=760,height=400")
	
}

function DailyReport_Click()
{
 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPJZ";
			win=open(lnk,"DHCOPJZAdm","top=20,left=150,width=800,height=1200")
}

function CacelReg_Click()
{
 Clear_Click();
 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPReturn";
			win=open(lnk,"CacelReg","top=150,left=150,width=700,height=400")
}
function QueryReg_Click()
{
 Clear_Click();
 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPReg";
			win=open(lnk,"QueryReg","status=1,top=150,left=150,width=700,height=400")//,"top=150,left=150,width=700,height=400"
}

function SwitchReg_Click()
{
 Clear_Click();
 var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPReturn";
			win=open(lnk,"SwitchReg","top=150,left=150,width=700,height=400")
}
function tk_ResetRowItemst(objtbl) {
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+":"+j+":"+rowitems[j].id);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split("z");
				//if (arrId[arrId.length-1]==i+1) break; //break out of j loop
				arrId[arrId.length-1]=i+1;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			}
		}
	}
}
document.body.onload = BodyLoadHandler;
//document.body.onunload = BodyUnLoadHandler;

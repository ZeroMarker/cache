var LoopCount=1;
var TemplatePath;
var MRDiagnos;
var PrintArray=new Array();
var DiagnoseArray=new Array(); 
var HospitalCode;
var CNMedItemCat;
var dsy='';
var YBFL='',firstdesc='',PatientMedicareNo='';
var OnlyZF='';

var EncryptObj=new Object();
function BodyLoadHandler() {
    EncryptObj=new DHCBodyLoadInitEncrypt();
	EncryptObj.GetAllEncrypt("web.DHCBodyLoadInitEncrypt.GetAllEncryptStr");
	var GetHospital=document.getElementById('GetHospital');
	if (GetHospital) {var encmeth=GetHospital.value} else {var encmeth=''};
	if (encmeth!='') {
		var HospitalStr=cspRunServerMethod(encmeth,'CurrentHospital');
		HospitalCode=mPiece(HospitalStr,'^',0);
	}
	
	var obj=document.getElementById('Print');
	if (obj) obj.onclick=PrintByDll;
	var obj=document.getElementById('PrintAll');
	if (obj) obj.onclick=PrintAllByDll;
	var obj=document.getElementById('PrintAnest');
	if (obj) obj.onclick=PrintAnestByDll;
  	var obj=document.getElementById('PrintAllAnest');
	//if (obj) obj.onclick=PrintAnestByDll1;
	if (obj) obj.onclick=PrintAllJsByDll;
	var obj=document.getElementById('UpdPerInfo')
    if (obj) obj.onclick=UpdPerInfoClickHandler;
	
	var obj=document.getElementById('EpisodeID');
	if (obj) var EpisodeID=obj.value;
	///就诊列表
	var obj=document.getElementById("PAADmList");
    if (obj){
	    obj.size=1;
		obj.multiple=false;
		obj.onchange=PAADmList_Change;
	}
	var GetPAADmList=document.getElementById('GetPAADmList')
	if (GetPAADmList) {var encmeth=GetPAADmList.value} else {var encmeth=''};
	if (encmeth!='') {
		if (cspRunServerMethod(encmeth,'SetPAADmList',EpisodeID)!='0') {
			obj.className='clsInvalid';
		    websys_setfocus('PatientNo');
			return websys_cancel();
		}
	}	
	for (var i=0;i<obj.length;i++) {
		//alert(obj.options[i].value+"=="+EpisodeID)
		if(obj.options[i].value==EpisodeID){
			obj.selectedIndex=i;
		}
	}
	///处方列表框
	var obj=document.getElementById('PrescList');
	if (obj) {
		obj.size=1;
		obj.multiple=false;
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option('','');
		obj.onchange=PrescList_Change;
	}
	var GetPrescList=document.getElementById('GetPrescList')
	if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
	if (encmeth!='') {
		if (cspRunServerMethod(encmeth,'SetPrescList',EpisodeID)!='0') {
			obj.className='clsInvalid';
		    websys_setfocus('PatientNo');
			return websys_cancel();
		}
	}
	var GetPrescPath=document.getElementById('GetPrescPath');
	if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
	if (encmeth!='') {
		TemplatePath=cspRunServerMethod(encmeth);
	}

	var obj=document.getElementById('MRADMID');
	if (obj) var MRADMID=obj.value;
	var obj=document.getElementById('AdmDep');
	if (obj) {
		var AdmDep=obj.value;
		var obj=document.getElementById('PrintCount');
		if (obj) {
			 obj.onkeydown=PrintKeydownClickHandler;
			 obj.onclick='';
			 if (HospitalCode=='HF'){
				obj.value=1;
			 }else{
				obj.value=2; 
			 }
		}
	}
	
	var GetCNMedItemCat=document.getElementById('GetCNMedItemCat');
	if (GetCNMedItemCat) {var encmeth=GetCNMedItemCat.value} else {var encmeth=''};
	if (encmeth!='') {
		CNMedItemCat=cspRunServerMethod(encmeth,'CNMedItemCat');
		if (CNMedItemCat!='') CNMedItemCat='^'+CNMedItemCat+'^';
	}
	//alert(CNMedItemCat);
	
	if (HospitalCode=='HF'){
		DHCP_GetXMLConfig('XMLObject','AHHFPrescriptPrint');
	}else if (HospitalCode=='YKYZLYY'){
		DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
	}else{
		DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
	}
	
}
function PrintKeydownClickHandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13) return false;
	
}
function getRow(eSrc) {
	while(eSrc.tagName != 'TR') {if (eSrc.tagName == 'TH') break;eSrc=websys_getParentElement(eSrc);}
	if (eSrc.tagName=='TR') {
		var gotheader=0;
		var tbl=getTable(eSrc);
		// 38689 if there are no column headings set TRAKListIndex = rowIndex+1
		if (tbl.tHead) eSrc.TRAKListIndex=eSrc.rowIndex;
		else eSrc.TRAKListIndex=eSrc.rowIndex+1;
	}
	return eSrc;
}
function getTable(eSrc) {
	if ((eSrc)&&(eSrc.tagName)) while(eSrc.tagName != 'TABLE') {eSrc=websys_getParentElement(eSrc);}
	return eSrc;
}

function UpdPerInfoClickHandler(){  //lgl+更新患者信息
    var obj=document.getElementById('PatientID');
	if (obj) var p0=obj.value;
    var obj=document.getElementById('RealName');
    if (obj) var p1=obj.value;
    var obj=document.getElementById('RealPerCard');
    if (obj) var p2=obj.value;
    var obj=document.getElementById('PerSupply');
    if (obj) var p3=obj.value;
    var obj=document.getElementById('PerSupplyCard');
    if (obj) var p4=obj.value;

	var GetPatient=document.getElementById('UpdRealInfo');
	if (GetPatient) {var encmeth=GetPatient.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,p0,p1,p2,p3,p4)=='0'){
			//obj.className='clsInvalid';
		    //websys_setfocus('PatientNo');
			alert(t['1']);
			return websys_cancel();
	}
}
function SetPAADmList(text,value) {
	var obj=document.getElementById('PAADmList');
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}

function PAADmList_Change() {
	var PAADmList=document.getElementById('PAADmList');
	var selIndex=PAADmList.selectedIndex;
	if (selIndex==-1) return;
	var PaadmID=PAADmList.options[selIndex].value;
	if (PaadmID=='') return;
	var obj=document.getElementById('EpisodeID');
	if (obj)obj.value=PaadmID;
    var obj=document.getElementById('PrescList');
    if (obj.options.length>0) {
		for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
	obj.options[0] = new Option("","");
    var GetPrescList=document.getElementById('GetPrescList')
	if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
	if (encmeth!='') {
		if (cspRunServerMethod(encmeth,'SetPrescList',PaadmID)!='0') {
			obj.className='clsInvalid';
		    websys_setfocus('PatientNo');
			return websys_cancel();
		}
	}     
    //window.location.reload();
}
function SetPrescList(text,value) {
	var obj=document.getElementById('PrescList');
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}

function PrescList_Change() {
	var PrescList=document.getElementById('PrescList');
	var selIndex=PrescList.selectedIndex;
	if (selIndex==-1) return;
	var PrescNo=PrescList.options[selIndex].value;
	if (PrescNo=='') return;
	var obj=document.getElementById('EpisodeID');
	if (obj) var EpisodeID=obj.value;
    FindPrescItems(EpisodeID,PrescNo);
    
}
function CleartTbl()
{
	var objtbl=document.getElementById('tUDHCPrescript_Print');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex;j++) {
		objtbl.deleteRow(1);
	}
	var objlastrow=objtbl.rows[1];
	var rowitems=objlastrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName('*'); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split('z');
			arrId[arrId.length-1]='1';
			rowitems[j].id=arrId.join('z');
			rowitems[j].name=arrId.join('z');
			rowitems[j].innerText='';
		}
	}
	LoopCount=1
}
function FindPrescItems(EpisodeID,PrescNo) {
	CleartTbl()
	//alert(EpisodeID+'^'+PrescNo);
	var GetPrescItems=document.getElementById('GetPrescItems');
		if (GetPrescItems) {var encmeth=GetPrescItems.value;} else {var encmeth=''};
  
	if (encmeth!='') {
		if (cspRunServerMethod(encmeth,'QueryDetail',EpisodeID,PrescNo)=='0') {
			obj.className='';
			
		}
		LoopCount=1;
	}
}

function QueryDetail(value) {
	try {
	    //alert(value);
		if (value!=''){	
			var objtbl=document.getElementById('tUDHCPrescript_Print');
		
	        if (LoopCount!=1) AddRowToList(objtbl);
	        LoopCount=LoopCount+1;
			var rows=objtbl.rows.length;
			var LastRow=rows - 1;
			var eSrc=objtbl.rows[LastRow];
			var RowObj=getRow(eSrc);
			var rowitems=RowObj.all;
			if (!rowitems) rowitems=RowObj.getElementsByTagName('label');
			//alert(rowitems.length);
			for (var j=0;j<rowitems.length;j++) {
				if (rowitems[j].id) {
					var Id=rowitems[j].id;
					var arrId=Id.split('z');
					var Row=arrId[arrId.length-1];
				}
			}
			//DHCWebD_AddTabRow(objtbl);
			var Split_Value=value.split('^')
			//Rowid:OrderName:StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:
			//Frequence:Instruction:Duration:PackQty:RecDep:Billed'
			var Tbl_Rowid=document.getElementById('Rowidz'+Row);
			var Tbl_OrderName=document.getElementById('OrderNamez'+Row);
			var Tbl_StartDat=document.getElementById('StartDatez'+Row);
			var Tbl_SeqNo=document.getElementById('SeqNoz'+Row);
			var Tbl_DoseQty=document.getElementById('DoseQtyz'+Row);
			var Tbl_DoseUOM=document.getElementById('DoseUOMz'+Row);
			var Tbl_Priority=document.getElementById('Priorityz'+Row);
			var Tbl_Status=document.getElementById('Statusz'+Row);
			var Tbl_Frequence=document.getElementById('Frequencez'+Row);
			var Tbl_Instruction=document.getElementById('Instructionz'+Row);
			var Tbl_Duration=document.getElementById('Durationz'+Row);
			var Tbl_PackQty=document.getElementById('PackQtyz'+Row);
			var Tbl_PackUOM=document.getElementById('PackUOMz'+Row);
			var Tbl_RecDep=document.getElementById('RecDepz'+Row);
			var Tbl_Price=document.getElementById('Pricez'+Row);
			var Tbl_Sum=document.getElementById('Sumz'+Row);
			var Tbl_Billed=document.getElementById('Billedz'+Row);
	        var Tbl_Select=document.getElementById('Selectz'+Row);
	        var Tbl_BillType=document.getElementById('BillTypez'+Row);
	        var Tbl_BillClass=document.getElementById('BillClassz'+Row);
	        var Tbl_UserAddCode=document.getElementById('UserAddCodez'+Row);
	        var Tbl_UserAddName=document.getElementById('UserAddNamez'+Row);
	        var Tbl_PoisonClass=document.getElementById('PoisonClassz'+Row);
	        var Tbl_ItemCat=document.getElementById('ItemCatz'+Row);
	        //alert(Split_Value);
	   	 	Tbl_Rowid.innerText=unescape(Split_Value[0]);
	    	Tbl_OrderName.innerText=Split_Value[1];
	    	Tbl_StartDat.innerText=unescape(Split_Value[2]);
	    	Tbl_SeqNo.innerText=unescape(Split_Value[3]);
	    	Tbl_DoseQty.innerText=unescape(Split_Value[4]);
	    	Tbl_DoseUOM.innerText=unescape(Split_Value[5]);
	    	Tbl_Priority.innerText=unescape(Split_Value[6]);
	    	Tbl_Status.innerText=unescape(Split_Value[7]);
	   		Tbl_Frequence.innerText=unescape(Split_Value[8]);
	   		Tbl_Instruction.innerText=unescape(Split_Value[9]);
	   		Tbl_Duration.innerText=unescape(Split_Value[10]);
	   		Tbl_PackQty.innerText=unescape(Split_Value[11]);
	   		Tbl_PackUOM.innerText=unescape(Split_Value[12]);
	   		Tbl_Price.innerText=unescape(Split_Value[13]);
	   		Tbl_Sum.innerText=unescape(Split_Value[14]);
	   		Tbl_RecDep.innerText=unescape(Split_Value[15]);
	   		Tbl_Billed.innerText=unescape(Split_Value[16]);
	   		Tbl_BillType.innerText=unescape(Split_Value[17]);
	        Tbl_BillClass.innerText=unescape(Split_Value[18]);
	        Tbl_UserAddCode.innerText=unescape(Split_Value[19]);
	        Tbl_UserAddName.innerText=unescape(Split_Value[20]);
	        Tbl_PoisonClass.innerText=unescape(Split_Value[21]);
	        Tbl_ItemCat.value=unescape(Split_Value[22]);
	        Tbl_Select.checked=true;
			//AddRowToList(objtbl);
		}
	} catch(e) {};
}
function GetStrLength(str){
	var len=str.length;
	var len1=0;
	for (var j=0;j<len;j++) {
		var char1=str.substring(j,j+1);
		if (CheckChinese(char1)) {len1=len1+2}else{len1=len1+1	}
	}
	//alert(len1);
	return len1;
}
function CheckChinese(char1){
	if(escape(char1).indexOf('%u')!=-1) return true;
	return false;
}
function isNumber(objStr){
 	strRef = "-1234567890.";
 	for (i=0;i<objStr.length;i++) {
  		tempChar= objStr.substring(i,i+1);
  		if (strRef.indexOf(tempChar,0)==-1) {return false;}
 	}
 	return true;
}

function AddRowToList(objtbl) {
	
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	//objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName('*'); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split('z');
			//arrId[arrId.length-1]=arrId[arrId.length-1]+1;
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1
			rowitems[j].id=arrId.join('z');
			rowitems[j].name=arrId.join('z');
			rowitems[j].value='';
			//rowitems[j].innerText='';
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className='RowEven';} else {objnewrow.className='RowOdd';}}
}

function DHCWebD_AddTabRow(objtbl)
{
	DHCWebD_ResetRowItems(objtbl);
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName('*'); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split('z');
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join('z');
			rowitems[j].name=arrId.join('z');
			rowitems[j].value='';
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className='RowEven';} else {objnewrow.className='RowOdd';}}	
	//DHCWebD_ResetRowItems(objtbl);
}
function DHCWebD_ResetRowItems(objtbl) {
	//alert(objtbl.rows.length);
	//check the header by z; zhaocz;
	var firstrow=objtbl.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=objrow.getElementsByTagName('*'); //N6
	var myaryid=firstitems[1].id.split('z');
	if (myaryid.length==2){
		//no header
			fIdx=0
		}else{
			fIdx=1
		}
	for (var i=fIdx;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className='RowEven';} else {objrow.className='RowOdd';}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName('*'); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+':'+j+':'+rowitems[j].type);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split('z');
				arrId[arrId.length-1]=i;
				rowitems[j].id=arrId.join('z');
				rowitems[j].name=arrId.join('z');
			}
		}
	}
}
function PrintClickHandler(){
	var PrescList=document.getElementById('PrescList');
	var selIndex=PrescList.selectedIndex;
	if (selIndex==0) {
		alert(t['No_Prescript']);
		return;
	}
	var PrintCount=1;
	var obj=document.getElementById('PrintCount');
	if (obj) PrintCount=obj.value;
	var TotalSum=0;
	
	try {
		var objtbl=document.getElementById('tUDHCPrescript_Print');
		var rows=objtbl.rows.length;
		var Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status;
		var Frequence,Instruction,Duration,PackQty,RecDep,Billed,Price,Sum,BillType,BillClass;
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+'DHCPrescription.xls';
	    //var Template='d:\\DHCPrescription.xls';
	    //alert(Template);
	    var obj=document.getElementById('PatientNo');
	    if (obj) var PatientNo=obj.value;
	    var obj=document.getElementById('PatientName');
	    if (obj) var PatientName=obj.value;
	    var obj=document.getElementById('PatientAge');
	    if (obj) var PatientAge=obj.value;
	    var obj=document.getElementById('PatientSex');
	    if (obj) var PatientSex=obj.value;
	    var obj=document.getElementById('PatientCompany');
	    if (obj) var PatientCompany=obj.value;
	    var obj=document.getElementById('AdmDep');
	    if (obj) var AdmDep=obj.value;
	    var AdmDepDesc=mPiece(AdmDep,'-',1);
	    if (!AdmDepDesc) AdmDepDesc=AdmDep;
	    var obj=document.getElementById('AdmDate');
	    if (obj) var AdmDate=obj.value;
		var obj=document.getElementById('GovernCardNo');
	    if (obj) var PatientGovernCardNo=obj.value;
	    
	    var obj=document.getElementById('PrescList');
	    if (obj) {
		    var PrescDesc=obj.options[obj.selectedIndex].text;
		    var Split_Value=PrescDesc.split('   ')
		    var ReclocDesc=Split_Value[2];
	  		var ReclocDesc1=mPiece(ReclocDesc,'-',1);
	        if (!ReclocDesc1) ReclocDesc1=ReclocDesc;
   		}
	    xlApp = new ActiveXObject('Excel.Application');
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.cells(7,1)=MRDiagnos;
	    var DiagnoseArrayLen=DiagnoseArray.length;
		for (var i=0;i<DiagnoseArrayLen;i++) {
			xlsheet.cells(7+i,1)=DiagnoseArray[i];
		}
	    xlsheet.cells(4,2)=PatientName;
	    xlsheet.cells(4,4)=PatientSex;
	    xlsheet.cells(4,6)=PatientAge;
	    xlsheet.cells(4,8)=PatientCompany;
	    var mystr='00000000';
	    mystr=mystr.substring(0,8-PatientNo.length);
	    PatientNo=mystr+PatientNo;
	    xlsheet.cells(2,9)=PatientNo;
	    //alert(PatientGovernCardNo);
	    xlsheet.cells(2,3)=PatientGovernCardNo;
	    xlsheet.cells(3,5)=AdmDepDesc;
	    xlsheet.cells(3,9)=ReclocDesc1;
	    ////xlsheet.cells(15,6)=session['LOGON.USERNAME'];
	    xlsheet.cells(15,9)=AdmDate;
	    var TotalSum=0;
	    var Row='1';
	    var PrintRow=0;
		for (var j=1;j<rows;j++) {
			//rowid='1111..'
			//if (j!=1) Row=Row+1;
			Row=j
			//Rowid:OrderName:StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:
			//Frequence:Instruction:Duration:PackQty:RecDep:Billed'
			var Tbl_Rowid=document.getElementById('Rowidz'+Row);
			var Tbl_OrderName=document.getElementById('OrderNamez'+Row);
			var Tbl_StartDat=document.getElementById('StartDatez'+Row);
			var Tbl_SeqNo=document.getElementById('SeqNoz'+Row);
			var Tbl_DoseQty=document.getElementById('DoseQtyz'+Row);
			var Tbl_DoseUOM=document.getElementById('DoseUOMz'+Row);
			var Tbl_Priority=document.getElementById('Priorityz'+Row);
			var Tbl_Status=document.getElementById('Statusz'+Row);
			var Tbl_Frequence=document.getElementById('Frequencez'+Row);
			var Tbl_Instruction=document.getElementById('Instructionz'+Row);
			var Tbl_Duration=document.getElementById('Durationz'+Row);
			var Tbl_PackQty=document.getElementById('PackQtyz'+Row);
			var Tbl_PackUOM=document.getElementById('PackUOMz'+Row);
			var Tbl_RecDep=document.getElementById('RecDepz'+Row);
			var Tbl_Price=document.getElementById('Pricez'+Row);
			var Tbl_Sum=document.getElementById('Sumz'+Row);
			var Tbl_Billed=document.getElementById('Billedz'+Row);
			var Tbl_BillType=document.getElementById('BillTypez'+Row);
			var Tbl_BillClass=document.getElementById('BillClassz'+Row);
	        //var Tbl_Select=document.getElementById('Selectz'+Row);

	   	 	Rowid=Tbl_Rowid.innerText;
	    	OrderName=Tbl_OrderName.innerText;
	    	StartDat=Tbl_StartDat.innerText;
	    	SeqNo=Tbl_SeqNo.innerText;
	    	DoseQty=Tbl_DoseQty.innerText;
	    	DoseUOM=Tbl_DoseUOM.innerText;
	    	Priority=Tbl_Priority.innerText;
	    	Status=Tbl_Status.innerText;
	   		Frequence=Tbl_Frequence.innerText;
	   		Instruction=Tbl_Instruction.innerText;
	   		Duration=Tbl_Duration.innerText;
	   		PackQty=Tbl_PackQty.innerText;
	   		PackUOM=Tbl_PackUOM.innerText;
	   		Price=Tbl_Price.innerText;
	   		Price=Price.substr(0,Price.length-2);
	   		Sum=Tbl_Sum.innerText;
	   		RecDep=Tbl_RecDep.innerText;
	   		Billed=Tbl_Billed.innerText;
	   		BillType=Tbl_BillType.innerText;
	   		BillClass=Tbl_BillClass.innerText;
	   		if (isNaN(Sum)){Sum=0;} 
	   		TotalSum=TotalSum+parseFloat(Sum);
	        //Select=Tbl_Select.checked;
	        var firstdesc=OrderName+' X '+PackQty +PackUOM;
	        var lastdesc=DoseQty+DoseUOM+' '+Frequence+' '+Instruction+ ' '+BillClass ;
	        var singledesc=firstdesc+' /'+lastdesc;
	        var len1=GetStrLength(singledesc);
	        if (len1>60){
		        PrintRow=PrintRow+1;
	        	xlsheet.cells(PrintRow+5,3)=firstdesc;
		        PrintRow=PrintRow+1;
	        	xlsheet.cells(PrintRow+5,8)='          Sig: '+lastdesc;
	        }else{
		        PrintRow=PrintRow+1;
	        	xlsheet.cells(PrintRow+5,3)=singledesc;
			}
            
		}
		var PrescType=BillType.substring(0,2)
		var PrescTitle=t['PrescTitle'];
		if (PrescType==t['BillType_YB']) PrescTitle=t['PrescTitle_YB'];
		if (PrescType==t['BillType_GF']) PrescTitle=t['PrescTitle_GF'];
	    if ((PrescType==t['BillType_YB'])||(PrescType==t['BillType_GF'])) {
		    xlsheet.cells(1,4)=PrescTitle;
	    }else{
		    xlsheet.cells(1,5)=PrescTitle;
	    }
		//xlsheet.cells(1,2)='('+PrescType+')';
	    TotalSum=TotalSum.toFixed(2);
	    xlsheet.cells(18,2)=TotalSum;
		for (var i=1;i<=PrintCount; i++) {
		    xlsheet.printout;
		}
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	} catch(e) {
		alert(e.message);
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
	};
}
function PrintAllClickHandler(){
	var PrintCount=1;
	var obj=document.getElementById('PrintCount');
	if (obj) PrintCount=obj.value;
	
	try {
		var Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status;
		var Frequence,Instruction,Duration,PackQty,RecDep,Billed,Price,Sum,BillType,BillClass;
		var BillType='';
		var TotalSum
        var xlApp,xlsheet,xlBook
        
	    var Template=TemplatePath+'DHCPrescription.xls';
	    var obj=document.getElementById('PatientNo');
	    if (obj) var PatientNo=obj.value;
	    var obj=document.getElementById('EpisodeID');
	    if (obj) var EpisodeID=obj.value;
	    var obj=document.getElementById('PatientName');
	    if (obj) var PatientName=obj.value;
	    var obj=document.getElementById('PatientAge');
	    if (obj) var PatientAge=obj.value;
	    var obj=document.getElementById('PatientSex');
	    if (obj) var PatientSex=obj.value;
	    var obj=document.getElementById('PatientCompany');
	    if (obj) var PatientCompany=obj.value;
	    var obj=document.getElementById('AdmDep');
	    if (obj) var AdmDep=obj.value;
	    var AdmDepDesc=mPiece(AdmDep,'-',1);
	    if (!AdmDepDesc) AdmDepDesc=AdmDep;
	    var obj=document.getElementById('AdmDate');
	    if (obj) var AdmDate=obj.value;
		var obj=document.getElementById('GovernCardNo');
	    if (obj) var PatientGovernCardNo=obj.value;
	    
	    var obj=document.getElementById('PrescList');
	    if (obj) {
			for (var i=1;i<obj.length;i++) {
				PrescDesc=obj.options[i].text;
		    	var Split_Value=PrescDesc.split('   ');
			    var ReclocDesc=Split_Value[2];
		  		var ReclocDesc1=mPiece(ReclocDesc,'-',1);
		        if (!ReclocDesc1) ReclocDesc1=ReclocDesc;
		    	var PrescNo=Split_Value[0];
				var GetPrescItems=document.getElementById('GetPrescItems');
				if (GetPrescItems) {var encmeth=GetPrescItems.value;} else {var encmeth=''};
			    PrintArray.length=0;
				if (encmeth!='') {
					if (cspRunServerMethod(encmeth,'FetchDetail',EpisodeID,PrescNo)=='0') {
					}
				}
				//alert(PrintArray.length);
				//continue;
			    xlApp = new ActiveXObject('Excel.Application');
			    xlBook = xlApp.Workbooks.Add(Template);
			    xlsheet = xlBook.ActiveSheet;
			    //xlsheet.cells(7,1)=MRDiagnos;
			    var DiagnoseArrayLen=DiagnoseArray.length;
				for (var k=0;k<DiagnoseArrayLen;k++) {
					xlsheet.cells(7+k,1)=DiagnoseArray[k];
				}
			    xlsheet.cells(4,2)=PatientName;
			    xlsheet.cells(4,4)=PatientSex;
			    xlsheet.cells(4,6)=PatientAge;
			    xlsheet.cells(4,8)=PatientCompany;
			    var mystr='00000000';
			    mystr=mystr.substring(0,8-PatientNo.length);
		    	PatientNo=mystr+PatientNo;
			    xlsheet.cells(2,9)=PatientNo;
	   			xlsheet.cells(2,3)=PatientGovernCardNo;
			    xlsheet.cells(3,5)=AdmDepDesc;
			    xlsheet.cells(3,9)=ReclocDesc1;
			    ///xlsheet.cells(15,6)=session['LOGON.USERNAME'];
			    xlsheet.cells(15,9)=AdmDate;
			    TotalSum=0;
			    //alert(PrintArray.length);
			    var PrintRow=0;
			    for (var j=0;j<PrintArray.length;j++) {
				    //alert(PrintArray[j]);
				    
				    var Split_Value=PrintArray[j].split('^');
			   	 	Rowid=unescape(Split_Value[0]);
			    	OrderName=unescape(Split_Value[1]);
			    	StartDat=unescape(Split_Value[2]);
			    	SeqNo=unescape(Split_Value[3]);
			    	DoseQty=unescape(Split_Value[4]);
			    	DoseUOM=unescape(Split_Value[5]);
			    	Priority=unescape(Split_Value[6]);
			    	Status=unescape(Split_Value[7]);
			   		Frequence=unescape(Split_Value[8]);
			   		Instruction=unescape(Split_Value[9]);
			   		Duration=unescape(Split_Value[10]);
			   		PackQty=unescape(Split_Value[11]);
			   		PackUOM=unescape(Split_Value[12]);
			   		Price=unescape(Split_Value[13]);
			   		Sum=unescape(Split_Value[14]);
			   		RecDep=unescape(Split_Value[15]);
			   		Billed=unescape(Split_Value[16]);
			   		BillType=unescape(Split_Value[17]);
			   		BillClass=unescape(Split_Value[18]);
	   				if (isNaN(Sum)){Sum=0;} 
	   				TotalSum=TotalSum+parseFloat(Sum);
			        var firstdesc=OrderName+' X '+PackQty +PackUOM;
			        var lastdesc=DoseQty+DoseUOM+' '+Frequence+' '+Instruction+ ' '+BillClass ;
			        var singledesc=firstdesc+' /'+lastdesc;
			        var len1=GetStrLength(singledesc);
			        if (len1>60){
				        PrintRow=PrintRow+1;
			        	xlsheet.cells(PrintRow+5,3)=firstdesc;
				        PrintRow=PrintRow+1;
			        	xlsheet.cells(PrintRow+5,8)='          Sig: '+lastdesc;
			        }else{
				        PrintRow=PrintRow+1;
			        	xlsheet.cells(PrintRow+5,3)=singledesc;
					}
		   		///TotalSum=TotalSum+Sum;
			        //xlsheet.cells(j+6,3)=OrderName+' X '+PackQty +PackUOM+' /'+DoseQty+DoseUOM+' '+Instruction+' '+Frequence+ ' '+BillClass ;
			    }
				var PrescType='';
				///alert(BillType);
				if (BillType!=''){
					PrescType=BillType.substring(0,2)
				}
				var PrescTitle=t['PrescTitle'];
				if (PrescType==t['BillType_YB']) PrescTitle=t['PrescTitle_YB'];
				if (PrescType==t['BillType_GF']) PrescTitle=t['PrescTitle_GF'];
			    if ((PrescType==t['BillType_YB'])||(PrescType==t['BillType_GF'])) {
				    xlsheet.cells(1,4)=PrescTitle;
			    }else{
				    xlsheet.cells(1,5)=PrescTitle;
			    }
	    		TotalSum=TotalSum.toFixed(2);
			    xlsheet.cells(18,2)=TotalSum;
				for (var k=1;k<=PrintCount; k++) {
				    xlsheet.printout
				}
			    xlBook.Close (savechanges=false);
			    xlApp=null;
			    xlsheet=null
			}
   		}
	} catch(e) {
		alert(e.message);
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null
	}
}

function FetchDetail(value) {
	try {
  		PrintArray[PrintArray.length]=value;
	} catch(e) {};
}
	
function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr='';
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject('MSXML2.DOMDocument.4.0');
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}


document.body.onload = BodyLoadHandler;
//document.body.onunload = BodyUnLoadHandler;

////////////////////////////////////////////////////////////////////////
/// 打印单处方
function PrintByDll(){
	alert("补打处方请注意回收原处方！")
	var obj=document.getElementById('PrescList');
	var selIndex=obj.selectedIndex;
	if (selIndex==0) {
		alert(t['No_Prescript']);
		return;
	}
	var PrescDesc=obj.options[obj.selectedIndex].text;
	var Split_Value=PrescDesc.split('   ')
	var PrescNo=Split_Value[0];
	//var PrescSerialNo=PrescNo.substring(1,12);
	var ReclocDesc=Split_Value[2];
	if (ReclocDesc.indexOf("-")!=-1)ReclocDesc=ReclocDesc.split("-")[1];
	
	var obj=document.getElementById('PatientID');
	if (obj) var PatientID=obj.value;
	var obj=document.getElementById('EpisodeID');
	if (obj) var EpisodeID=obj.value;
	var obj=document.getElementById('MRADMID');
	if (obj) var MRADMID=obj.value;
	var ret=cspRunServerMethod(EncryptObj.GetOutpatEPRStatus,EpisodeID);
	var rettemp=ret.split("^")
	if (rettemp[0]=="N"){
		alert(rettemp[1]);
		return;
	}
	var PrintCount=1;
	var obj=document.getElementById('PrintCount');
	if (obj) PrintCount=obj.value;
	var FrontFlag="N",BackFlag="N";
	var fobj=document.getElementById('FrontFlag');
	if (fobj) {if(fobj.checked)FrontFlag="Y";}
	var bobj=document.getElementById('BackFlag');
	if (bobj) {if(bobj.checked)BackFlag="Y";}
	if((FrontFlag=="Y")&&(BackFlag=="Y"))PrintCount=2;
	
	try {
		//获取病人的基本信息
		var PatientInfo=GetPatientInfo(PatientID,EpisodeID);
		if(PatientInfo=="")return;
		//获取病人本次就诊的诊断信息
		var PatMradmInfo=GetPatMradmInfo(MRADMID);
		//获取病人本次就诊的处方信息
		var PrescType="";
		var PrescType=tkMakeServerCall("web.UDHCPrescript","GetBillTypeByPrescNo",EpisodeID,PrescNo);
		if(PrescType=="")PrescType="[自费]";
		var PatPrescInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdItemByPrescNo",EpisodeID,PrescNo);
		//alert(PatPrescInfo)
		if (PatPrescInfo=="") return;
		var MyPara="",MyList="";
		var PrescInfoArr=PatPrescInfo.split(String.fromCharCode(1));
		var BilledTxt=PrescInfoArr[2];
		var PrescInfoArr1=PrescInfoArr[0].split("^");
		var Sum=PrescInfoArr1[0],PoisonClass=PrescInfoArr1[1];
		var OrdDate=PrescInfoArr1[2],OrdTime=PrescInfoArr1[3];
		if((PoisonClass=='DM')||(PoisonClass=='J1')){
			//if(!confirm("毒麻处方需要红纸打印，请放入"+PrintCount+"张红色处方纸。")){return;}
		}
		if((PoisonClass!='J1')&&(PoisonClass!='J2')&&(PoisonClass!='MZ'))PoisonClass="";
		if ((PoisonClass=='MZ')||(PoisonClass=='J1'))PoisonClass='[麻 精一]';
		if (PoisonClass=='J2')PoisonClass='[精二]';
			
		var MyPara='^Sum'+String.fromCharCode(2)+'药费 '+Sum+'元';
		var dt=new Date();
		var PrintDate=dt.getFullYear()+"-"+(dt.getMonth()+1)+"-"+dt.getDate();
		var PrintTime=dt.getHours()+":"+dt.getMinutes();
		MyPara=MyPara+'^OrdDate'+String.fromCharCode(2)+OrdDate;
		MyPara=MyPara+'^OrdTime'+String.fromCharCode(2)+OrdTime;var OrdDate=PrescInfoArr1[2],OrdTime=PrescInfoArr1[3];
		MyPara=MyPara+'^PrintDateTime'+String.fromCharCode(2)+PrintDate+"  "+PrintTime;
		MyPara=MyPara+'^BilledTxt'+String.fromCharCode(2)+BilledTxt;
		MyPara=MyPara+'^PoisonClass'+String.fromCharCode(2)+PoisonClass;
		MyPara=MyPara+'^PrescNo'+String.fromCharCode(2)+PrescNo;
		MyPara=MyPara+'^RecLoc'+String.fromCharCode(2)+ReclocDesc;
		MyPara=MyPara+'^PrescType'+String.fromCharCode(2)+PrescType;
		MyPara=MyPara+'^PrescSerialNo'+String.fromCharCode(2)+"*"+PrescNo+"*";
		if ((PoisonClass=='[麻 精一]')){
			DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
			if (HospitalCode=="BJTRYY"){
				var AgentInfo=tkMakeServerCall("web.TRYYDocCommon","GetAgentInfo",PatientID,EpisodeID);
				if(AgentInfo!=""){
					var AgentArr=AgentInfo.split("^");
					MyPara=MyPara+'^Agent'+String.fromCharCode(2)+AgentArr[0];
					MyPara=MyPara+'^AgentIDNo'+String.fromCharCode(2)+AgentArr[1];
				}
			}else if(HospitalCode=="BJHLGYY"){
				var SupplyCardNo="";
				var obj=document.getElementById('RealPerCard');
				if (obj) SupplyCardNo=obj.value;
				MyPara=MyPara+'^SupplyCard'+String.fromCharCode(2)+SupplyCardNo;
				MyPara=MyPara+'^SupplyNameCaption'+String.fromCharCode(2)+"";
				MyPara=MyPara+'^SupplyCardCaption'+String.fromCharCode(2)+"";
			}
		}else{
			DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
		}
		var PrescInfoArr2=PrescInfoArr[1].split(String.fromCharCode(2));
		for (var i=0;i<PrescInfoArr2.length;i++){
			if(PrescInfoArr2[i].length>60){
				var PrescInfoArr3=PrescInfoArr2[i].split("X");
				if (MyList=="") {
					MyList=PrescInfoArr3[0];
					MyList= MyList+String.fromCharCode(2)+PrescInfoArr3[1];
				}else{
					MyList=MyList+String.fromCharCode(2)+PrescInfoArr3[0];
					MyList=MyList+String.fromCharCode(2)+PrescInfoArr3[1];
				}
			}else{
				if (MyList=="") {
					MyList=PrescInfoArr2[i];
				}else{
					MyList=MyList+String.fromCharCode(2)+PrescInfoArr2[i];
				}
			}
		}
		
		MyPara=PatientInfo+PatMradmInfo+MyPara;
		//alert(MyPara);
		var myobj=document.getElementById('ClsBillPrint');
		if (FrontFlag=="Y") {
			var zf="[正方]";
			var MyPara1=MyPara+'^zf'+String.fromCharCode(2)+zf;
			PrintFun(myobj,MyPara1,MyList);
		}
		if (BackFlag=="Y") {
			var zf="[底方]";
			var MyPara1=MyPara+'^zf'+String.fromCharCode(2)+zf;
			PrintFun(myobj,MyPara1,MyList);
		}
	} catch(e) {
		alert(e.message);
	}
}
/// 打印毒麻处方
function PrintAnestByDll(){	
	var obj=document.getElementById('PatientID');
	if (obj) var PatientID=obj.value;
	var obj=document.getElementById('EpisodeID');
	if (obj) var EpisodeID=obj.value;
	var obj=document.getElementById('MRADMID');
	if (obj) var MRADMID=obj.value;
	var ret=cspRunServerMethod(EncryptObj.GetOutpatEPRStatus,EpisodeID);
	var rettemp=ret.split("^")
	if (rettemp[0]=="N"){
		alert(rettemp[1]);
		return;
	}
	var PrintCount=1;
	var obj=document.getElementById('PrintCount');
	if (obj) PrintCount=obj.value;
	var FrontFlag="N",BackFlag="N";
	var fobj=document.getElementById('FrontFlag');
	if (fobj) {if(fobj.checked)FrontFlag="Y";}
	var bobj=document.getElementById('BackFlag');
	if (bobj) {if(bobj.checked)BackFlag="Y";}
	if((FrontFlag=="Y")&&(BackFlag=="Y"))PrintCount=2;
	
	try {
		//获取病人的基本信息
		var PatientInfo=GetPatientInfo(PatientID,EpisodeID);
		if(PatientInfo=="")return;
		//获取病人本次就诊的诊断信息
		var PatMradmInfo=GetPatMradmInfo(MRADMID);
		//获取病人本次就诊的处方信息		
		var PrescNoStr=tkMakeServerCall("web.UDHCPrescript","GetPrescNoStr",EpisodeID);
		var PrescNoArr=PrescNoStr.split("^");
		if(PrescNoArr[0].split('   ')[0].indexOf("!")>0){
			//if(PrintCount==1){var PrescDMnum=PrescNoArr[0].split('   ')[0].split("!")[1];}
			//else{var PrescDMnum=2*PrescNoArr[0].split('   ')[0].split("!")[1];}
			//if(!confirm("毒麻处方需要红纸打印，请放入"+PrescDMnum+"张红色处方纸。")){return;}
		}else{alert("该患者没有毒麻处方!");return;}
		for (var j=0;j<PrescNoArr.length;j++){
			var PrescDesc=PrescNoArr[j];
			var PrescNo=PrescDesc.split('   ')[0];//alert(PrescNo)
			//var PrescSerialNo=PrescNo.substring(1,12);
			if(PrescNo.indexOf("!")>0)PrescNo=PrescNo.split("!")[0];
			var ReclocDesc=PrescDesc.split('   ')[2];
			if (ReclocDesc.indexOf("-")!=-1)ReclocDesc=ReclocDesc.split("-")[1];
			
			var MyPara="",MyList="",PrescType="";
			var PatPrescInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdItemByPrescNo",EpisodeID,PrescNo);
			if (PatPrescInfo=="") continue;
			var PrescInfoArr=PatPrescInfo.split(String.fromCharCode(1));
			var BilledTxt=PrescInfoArr[2];
			var PrescInfoArr1=PrescInfoArr[0].split("^");
			var Sum=PrescInfoArr1[0],PoisonClass=PrescInfoArr1[1];
			var OrdDate=PrescInfoArr1[2],OrdTime=PrescInfoArr1[3];
			if ((PoisonClass!='J1')&&(PoisonClass!='J2')&&(PoisonClass!='DM'))continue;
			if ((PoisonClass=='DM')||(PoisonClass=='J1'))PoisonClass='[麻 精一]';
			if (PoisonClass=='J2')PoisonClass='[精二]';
			
			var PrescType=tkMakeServerCall("web.UDHCPrescript","GetBillTypeByPrescNo",EpisodeID,PrescNo);
			if(PrescType=="")PrescType="[自费]";
			
			var MyPara='^Sum'+String.fromCharCode(2)+'药费 '+Sum+'元';
			var dt=new Date();
			var PrintDate=dt.getFullYear()+"-"+(dt.getMonth()+1)+"-"+dt.getDate();
			var PrintTime=dt.getHours()+":"+dt.getMinutes();
			MyPara=MyPara+'^OrdDate'+String.fromCharCode(2)+OrdDate;
			MyPara=MyPara+'^OrdTime'+String.fromCharCode(2)+OrdTime;
			MyPara=MyPara+'^PrintDateTime'+String.fromCharCode(2)+PrintDate+"  "+PrintTime;
			MyPara=MyPara+'^PoisonClass'+String.fromCharCode(2)+PoisonClass;
			MyPara=MyPara+'^BilledTxt'+String.fromCharCode(2)+BilledTxt;
			MyPara=MyPara+'^PrescNo'+String.fromCharCode(2)+PrescNo;
			MyPara=MyPara+'^RecLoc'+String.fromCharCode(2)+ReclocDesc;
			MyPara=MyPara+'^PrescType'+String.fromCharCode(2)+PrescType;
			MyPara=MyPara+'^PrescSerialNo'+String.fromCharCode(2)+"*"+PrescNo+"*";
			if ((PoisonClass=='[麻 精一]')){
				DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
				if (HospitalCode=="BJTRYY"){
					var AgentInfo=tkMakeServerCall("web.TRYYDocCommon","GetAgentInfo",PatientID,EpisodeID);
					if(AgentInfo!=""){
						var AgentArr=AgentInfo.split("^");
						MyPara=MyPara+'^Agent'+String.fromCharCode(2)+AgentArr[0];
						MyPara=MyPara+'^AgentIDNo'+String.fromCharCode(2)+AgentArr[1];
					}
				}else if(HospitalCode=="BJHLGYY"){
					var SupplyCardNo="";
					var obj=document.getElementById('RealPerCard');
					if (obj) SupplyCardNo=obj.value;
					MyPara=MyPara+'^SupplyCard'+String.fromCharCode(2)+SupplyCardNo;
					MyPara=MyPara+'^SupplyNameCaption'+String.fromCharCode(2)+"";
					MyPara=MyPara+'^SupplyCardCaption'+String.fromCharCode(2)+"";
				}
			}else{
				DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
			}
			var PrescInfoArr2=PrescInfoArr[1].split(String.fromCharCode(2));
			for (var i=0;i<PrescInfoArr2.length;i++){
				if(PrescInfoArr2[i].length>60){
					var PrescInfoArr3=PrescInfoArr2[i].split("X");
					if (MyList=="") {
						MyList=PrescInfoArr3[0];
						MyList= MyList+String.fromCharCode(2)+PrescInfoArr3[1];
					}else{
						MyList=MyList+String.fromCharCode(2)+PrescInfoArr3[0];
						MyList=MyList+String.fromCharCode(2)+PrescInfoArr3[1];
					}
				}else{
					if (MyList=="") {
						MyList=PrescInfoArr2[i];
					}else{
						MyList=MyList+String.fromCharCode(2)+PrescInfoArr2[i];
					}
				}
			}
			//alert(MyList)
			MyPara=PatientInfo+PatMradmInfo+MyPara;
			var myobj=document.getElementById('ClsBillPrint');
			if (FrontFlag=="Y") {
				var zf="[正方]";
				var MyPara1=MyPara+'^zf'+String.fromCharCode(2)+zf;
				PrintFun(myobj,MyPara1,MyList);
			}
			if (BackFlag=="Y") {
				var zf="[底方]";
				var MyPara1=MyPara+'^zf'+String.fromCharCode(2)+zf;
				PrintFun(myobj,MyPara1,MyList);
			}
			if(MyPara==""){alert("该患者没有毒麻处方!");}
		}
			
	} catch(e) {
		alert(e.message);
	}
}
/// 打印全部处方
function PrintAllByDll(){
	alert("补打处方请注意回收原处方！")
	var obj=document.getElementById('PatientID');
	if (obj) var PatientID=obj.value;
	var obj=document.getElementById('EpisodeID');
	if (obj) var EpisodeID=obj.value;
	var obj=document.getElementById('MRADMID');
	if (obj) var MRADMID=obj.value;
	var ret=cspRunServerMethod(EncryptObj.GetOutpatEPRStatus,EpisodeID);
	var rettemp=ret.split("^")
	if (rettemp[0]=="N"){
		alert(rettemp[1]);
		return;
	}
	var PrintCount=1;
	var obj=document.getElementById('PrintCount');
	if (obj) PrintCount=obj.value;
	var FrontFlag="N",BackFlag="N";
	var fobj=document.getElementById('FrontFlag');
	if (fobj) {if(fobj.checked)FrontFlag="Y";}
	var bobj=document.getElementById('BackFlag');
	if (bobj) {if(bobj.checked)BackFlag="Y";}
	if((FrontFlag=="Y")&&(BackFlag=="Y"))PrintCount=2;
	
	try {
		//获取病人的基本信息
		var PatientInfo=GetPatientInfo(PatientID,EpisodeID);
		if(PatientInfo=="")return;
		//获取病人本次就诊的诊断信息
		var PatMradmInfo=GetPatMradmInfo(MRADMID);
		//获取病人本次就诊的处方信息		
		var PrescNoStr=tkMakeServerCall("web.UDHCPrescript","GetPrescNoStr",EpisodeID);
		var PrescNoArr=PrescNoStr.split("^"); //alert(PrescNoArr.length)
		if(PrescNoArr[0].split('   ')[0].indexOf("!")>0){
			//if(PrintCount==1){var PrescDMnum=PrescNoArr[0].split('   ')[0].split("!")[1];}
			//else{var PrescDMnum=2*PrescNoArr[0].split('   ')[0].split("!")[1];}
			//if(!confirm("毒麻处方需要红纸打印，请放入"+PrescDMnum+"张红色处方纸。")){return;}
		}
		for (var j=0;j<PrescNoArr.length;j++){
			var PrescDesc=PrescNoArr[j];
			var PrescNo=PrescDesc.split('   ')[0];//alert(PrescNo)
			//var PrescSerialNo=PrescNo.substring(1,12);
			if(PrescNo.indexOf("!")>0)PrescNo=PrescNo.split("!")[0];
			var ReclocDesc=PrescDesc.split('   ')[2];
			if (ReclocDesc.indexOf("-")!=-1)ReclocDesc=ReclocDesc.split("-")[1];
			
			var PrescType="";
			var PrescType=tkMakeServerCall("web.UDHCPrescript","GetBillTypeByPrescNo",EpisodeID,PrescNo);
			if(PrescType=="")PrescType="[自费]";
			var PatPrescInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdItemByPrescNo",EpisodeID,PrescNo);
			if (PatPrescInfo=="") return;
			var MyPara="",MyList="";
			var PrescInfoArr=PatPrescInfo.split(String.fromCharCode(1));
			var BilledTxt=PrescInfoArr[2];
			var PrescInfoArr1=PrescInfoArr[0].split("^");
			var Sum=PrescInfoArr1[0],PoisonClass=PrescInfoArr1[1];
			var OrdDate=PrescInfoArr1[2],OrdTime=PrescInfoArr1[3];
			if((PoisonClass!='J1')&&(PoisonClass!='J2')&&(PoisonClass!='DM'))PoisonClass="";
			if ((PoisonClass=='DM')||(PoisonClass=='J1'))PoisonClass='[麻 精一]';
			if (PoisonClass=='J2')PoisonClass='[精二]';
			var MyPara='^Sum'+String.fromCharCode(2)+'药费 '+Sum+'元';
			var dt=new Date();
			var PrintDate=dt.getFullYear()+"-"+(dt.getMonth()+1)+"-"+dt.getDate();
			var PrintTime=dt.getHours()+":"+dt.getMinutes();
			MyPara=MyPara+'^OrdDate'+String.fromCharCode(2)+OrdDate;
			MyPara=MyPara+'^OrdTime'+String.fromCharCode(2)+OrdTime;
			MyPara=MyPara+'^PrintDateTime'+String.fromCharCode(2)+PrintDate+"  "+PrintTime;
			MyPara=MyPara+'^PoisonClass'+String.fromCharCode(2)+PoisonClass;
			MyPara=MyPara+'^BilledTxt'+String.fromCharCode(2)+BilledTxt;
			MyPara=MyPara+'^PrescNo'+String.fromCharCode(2)+PrescNo;
			MyPara=MyPara+'^RecLoc'+String.fromCharCode(2)+ReclocDesc;
			MyPara=MyPara+'^PrescType'+String.fromCharCode(2)+PrescType;
			MyPara=MyPara+'^PrescSerialNo'+String.fromCharCode(2)+"*"+PrescNo+"*";
			if ((PoisonClass=='[麻 精一]')){
				DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
				if (HospitalCode=="BJTRYY"){
					var AgentInfo=tkMakeServerCall("web.TRYYDocCommon","GetAgentInfo",PatientID,EpisodeID);
					if(AgentInfo!=""){
						var AgentArr=AgentInfo.split("^");
						MyPara=MyPara+'^Agent'+String.fromCharCode(2)+AgentArr[0];
						MyPara=MyPara+'^AgentIDNo'+String.fromCharCode(2)+AgentArr[1];
					}
				}else if(HospitalCode=="BJHLGYY"){
					var SupplyCardNo="";
					var obj=document.getElementById('RealPerCard');
					if (obj) SupplyCardNo=obj.value;
					MyPara=MyPara+'^SupplyCard'+String.fromCharCode(2)+SupplyCardNo;
					MyPara=MyPara+'^SupplyNameCaption'+String.fromCharCode(2)+"";
					MyPara=MyPara+'^SupplyCardCaption'+String.fromCharCode(2)+"";
				}
			}else{
				DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
			}
			var PrescInfoArr2=PrescInfoArr[1].split(String.fromCharCode(2));
			for (var i=0;i<PrescInfoArr2.length;i++){
				if(PrescInfoArr2[i].length>60){
					var PrescInfoArr3=PrescInfoArr2[i].split("X");
					if (MyList=="") {
						MyList=PrescInfoArr3[0];
						MyList= MyList+String.fromCharCode(2)+PrescInfoArr3[1];
					}else{
						MyList=MyList+String.fromCharCode(2)+PrescInfoArr3[0];
						MyList=MyList+String.fromCharCode(2)+PrescInfoArr3[1];
					}
				}else{
					if (MyList=="") {
						MyList=PrescInfoArr2[i];
					}else{
						MyList=MyList+String.fromCharCode(2)+PrescInfoArr2[i];
					}
				}
			}
			//alert(MyList)
			MyPara=PatientInfo+PatMradmInfo+MyPara;
			var myobj=document.getElementById('ClsBillPrint');
			if (FrontFlag=="Y") {
				var zf="[正方]";
				var MyPara1=MyPara+'^zf'+String.fromCharCode(2)+zf;
				PrintFun(myobj,MyPara1,MyList);
			}
			if (BackFlag=="Y") {
				var zf="[底方]";
				var MyPara1=MyPara+'^zf'+String.fromCharCode(2)+zf;
				PrintFun(myobj,MyPara1,MyList);
			}
		}	
	} catch(e) {
		alert(e.message);
	}
}
function CheckPrescPrint(){	
	var PrescList=document.getElementById('PrescList');
	var selIndex=PrescList.selectedIndex;
	var MyList1='';MyList2='';
	if (selIndex==0) {
		alert(t['No_Prescript']);
		return false;
	}
	var obj=document.getElementById('EpisodeID');
	if (obj) var EpisodeID=obj.value;
	var ret=cspRunServerMethod(EncryptObj.GetOutpatEPRStatus,EpisodeID);
	var rettemp=ret.split("^")
	if (rettemp[0]=="N"){
		alert(rettemp[1]);
		return false;
	}
}
function GetPatientInfo(PatientID,EpisodeID){
	var GetPatient=document.getElementById('GetPatient');
	if (GetPatient) {var encmeth=GetPatient.value} else {var encmeth=''};
	if (encmeth!='') {
		var GetPatientInfo=cspRunServerMethod(encmeth,PatientID);
		var PatientInfoArr=GetPatientInfo.split("^");
		var PatientNo=PatientInfoArr[1],PatientName=PatientInfoArr[2];
 		var PatientSex=PatientInfoArr[3],PatientAge=PatientInfoArr[4];
 		var PatBirthday=PatientInfoArr[5],PatCompany=PatientInfoArr[10];
 		var MRNo=PatientInfoArr[18],PatientTel=PatientInfoArr[24];
 		var Pattype=PatientInfoArr[6],InsuNo=PatientInfoArr[28];
 		var CardNo=PatientInfoArr[29],PersonIDNo=PatientInfoArr[30];
	}
	
	var obj=document.getElementById('RealPerCard');
	if (obj) obj.value=PersonIDNo;
	
	var PAAdmInfo=tkMakeServerCall("web.UDHCPrescript","GetPatInform",EpisodeID);
 	var PAAdmInfoArr=PAAdmInfo.split("^");
	var AdmDep=PAAdmInfoArr[2],AdmDate=PAAdmInfoArr[3];
	var PrescTitle="",Childweight="";
	if (AdmDep.indexOf("儿科")!=-1) {
		var obj=document.getElementById('ChildWeightEncrype');
    	if (obj) {var encmeth=obj.value} else {var encmeth=''};
		if (encmeth!='') {
			var rtn=cspRunServerMethod(encmeth,EpisodeID,"");
	        var str=rtn.split("^");
	        if((str[0]=="1")&&(str[1]=="")){
		         alert("儿科必须填写体重!");
		         return "";
		    }
		    Childweight="体重:"+str[1];
		}
		PrescTitle="[儿科]";
	}else if (AdmDep.indexOf("急")!=-1) {PrescTitle="[急]";}
	
	var gmsy="",PrintFormat="",BillType="";
	var SupplyCardNo="",Duration="";
	var UserAddName=session['LOGON.USERNAME'];
	var MyPara='PrescTitle'+String.fromCharCode(2)+PrescTitle;	    
	MyPara=MyPara+'^PresType'+String.fromCharCode(2)+'处方笺';
	MyPara=MyPara+'^PatientMedicareNo'+String.fromCharCode(2)+InsuNo;
	MyPara=MyPara+'^MRNo'+String.fromCharCode(2)+MRNo;
	MyPara=MyPara+'^CardNo'+String.fromCharCode(2)+CardNo;
	MyPara=MyPara+'^PANo'+String.fromCharCode(2)+PatientNo;
	MyPara=MyPara+'^AdmDep'+String.fromCharCode(2)+AdmDep;
	MyPara=MyPara+'^Name'+String.fromCharCode(2)+PatientName;
	MyPara=MyPara+'^Sex'+String.fromCharCode(2)+PatientSex;
	MyPara=MyPara+'^Age'+String.fromCharCode(2)+PatientAge;
	MyPara=MyPara+'^gmsy'+String.fromCharCode(2)+gmsy;
	MyPara=MyPara+'^Company'+String.fromCharCode(2)+PatCompany;
	MyPara=MyPara+'^AdmDate'+String.fromCharCode(2)+AdmDate;
	MyPara=MyPara+'^UserAddName'+String.fromCharCode(2)+UserAddName;
	MyPara=MyPara+'^BillType'+String.fromCharCode(2)+BillType;
	MyPara=MyPara+'^PrintFormat'+String.fromCharCode(2)+PrintFormat;
	MyPara=MyPara+'^Childweight'+String.fromCharCode(2)+Childweight;
	//MyPara=MyPara+'^SupplyCard'+String.fromCharCode(2)+SupplyCardNo;
	MyPara=MyPara+'^Duration'+String.fromCharCode(2)+Duration;
	MyPara=MyPara+'^PatientTel'+String.fromCharCode(2)+PatientTel;
	MyPara=MyPara+'^IDCardNo'+String.fromCharCode(2)+PersonIDNo;
	//alert(MyPara)
	return MyPara;
}

function GetPatMradmInfo(MRADMID){
	var GetMRDiagnosDesc=document.getElementById('GetMRDiagnos');
	if (GetMRDiagnosDesc) {var encmeth=GetMRDiagnosDesc.value} else {var encmeth=''};
	if (encmeth!='') {
		var j=1;
		var rowlen=8; //一行诊断显示的字符长度
		var MyPara="";
		var delim=';';//+String.fromCharCode(13)+String.fromCharCode(10)
		var PatMradmInfo=cspRunServerMethod(encmeth,MRADMID,delim);
		var len=PatMradmInfo.length;
		var MradmInfoArr=PatMradmInfo.split(delim);
		for (var i=0;i<MradmInfoArr.length;i++) {
			var MradmInfo=MradmInfoArr[i];
			var dialen=Math.ceil(MradmInfo.length/rowlen);
			if (MyPara=="") {
				for (var k=0;k<dialen;k++) {
					var fr=k*rowlen,to=(k+1)*rowlen;
					var MradmInfo1=MradmInfo.substring(fr,to);
					if (k==0) {MyPara='^Diagnose'+j+String.fromCharCode(2)+MradmInfo1;}
					else{MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo1;}
					j=j+1;
				}
			}else{
				for (var k=0;k<dialen;k++) {
					var fr=k*rowlen,to=(k+1)*rowlen;
					var MradmInfo1=MradmInfo.substring(fr,to);
					MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo1;
					j=j+1;
				}
			}
		}
	}
	
	return MyPara;
}


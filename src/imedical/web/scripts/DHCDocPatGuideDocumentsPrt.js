document.body.onload = BodyLoadHandler;
var LoopCount=1;
var TemplatePath;
var MRDiagnos;
var InMedicare;
var DiagnoseArray=new Array();
var HospitalCode; var HospitalCode="SHSDFYY";
var RePrintFlag=0  
//document.body.onunload = BodyUnLoadHandler;
function BodyLoadHandler() {
	var PateintID=""; var MRADMID="";
	var obj=document.getElementById("PatientID");
    if (obj) var PateintID=obj.value;
    var obj=document.getElementById("EpisodeID");
    if (obj) var EpisodeID=obj.value;
    var Obj=document.getElementById("MRADMID");
    if(Obj) var MRADMID=Obj.value;
	if ((PateintID=="")||(MRADMID=="")){
  		encmeth=document.getElementById("GetPateintIDMethod").value
  		var Str=cspRunServerMethod(encmeth,EpisodeID)
  		document.getElementById("PatientID").value=Str.split('^')[0];
  		var obj=document.getElementById("PatientID");
	  	if (obj) var PateintID=obj.value;
	  	document.getElementById("MRADMID").value=Str.split('^')[1];
  	}

	var obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;
	var obj=document.getElementById("Print");
	if (obj) obj.onclick=PrintClickHandler;
	var obj=document.getElementById("Printjc");
	if (obj) obj.onclick=PrintjcClickHandler;
	var obj=document.getElementById("Printzl");
	if (obj) obj.onclick=PrintzlClickHandler;
	var obj=document.getElementById("MRADMID");
	if (obj) var MRADMID=obj.value;
	//var obj=document.getElementById("LabEpisodeNo");
	//if (obj) obj.onclick=LabEpisodeNoClick;

	var GetPrescPath=document.getElementById("GetPrescPath");
	if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
	if (encmeth!="") {
		TemplatePath=cspRunServerMethod(encmeth);
	}

	var GetMRDiagnosDesc=document.getElementById("GetMRDiagnos");
	if (GetMRDiagnosDesc) {var encmeth=GetMRDiagnosDesc.value} else {var encmeth=''};
	if (encmeth!="") {
		MRDiagnos=cspRunServerMethod(encmeth,MRADMID,",");
	}
	
	var obj=document.getElementById("CheckAll");
	if (obj){
		obj.onclick=AllSelect_OnClick;
	}
		
	var obj=document.getElementById("PatientID");
	if (obj) var PatientID=obj.value;
	var GetPatient=document.getElementById("GetPatient");
	if (GetPatient) {var encmeth=GetPatient.value} else {var encmeth=''};
	if (encmeth!="") {
		var Patient=cspRunServerMethod(encmeth,PatientID);

		var PatientName=mPiece(Patient,"^",2)
		var PatientSex=mPiece(Patient,"^",3)
		var PatientNo=mPiece(Patient,"^",1)
		var obj=document.getElementById("PatientName");
		if (obj) obj.value=PatientName;


		var obj=document.getElementById("PatientSex");
		if (obj) obj.value=PatientSex;
		var obj=document.getElementById("PatientNo");
		if (obj) obj.value=PatientNo;
	}
	


    if (HospitalCode=="YKYZLYY"){
		DHCP_GetXMLConfig("XMLObject","YKYZLYYOrderItemLabPrint");

	} else if (HospitalCode=="HF"){
		DHCP_GetXMLConfig("XMLObject","AHHFOrderItemLabPrint");
	}else if (HospitalCode=="ZGYDYY"){
		DHCP_GetXMLConfig("XMLObject","ZGYDYYOrderItemLabPrint");
	}
	else if (HospitalCode=="JST"){
		 InitalJST();
		DHCP_GetXMLConfig("XMLObject","OrderItemLabPrint");
	} else if (HospitalCode=="SCSFY"){
		DHCP_GetXMLConfig("XMLObject","ZGYDYYOrderItemLabPrint");
	}else{
		DHCP_GetXMLConfig("XMLObject","DHCDocGuidePatDocuments");
		
	}
	
	document.onclick=OrderDetails;
	var WindowName=window.name;
	if (WindowName=="DHCDocPatGuideDocumentsPrtPrintAll"){		
		SelectAll(true);		
		PrintClickHandler();
		window.close();
	}
	
}

function OrderDetails(e){
   
	var src=websys_getSrcElement(e);
	if (src.tagName == "A") return;
	if (src.id.substring(0,7)=="Selectz")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj=document.getElementById("Selectz"+rowsel);
		
	if (obj) {
			var LabEpisodeNo=GetColumnData("LabEpisodeNo",rowsel)
			//alert(LabEpisodeNo);
			ChangelLinkItemSelect(LabEpisodeNo,obj.checked);
		}
	}
}
function ChangelLinkItemSelect(SelectLabEpisodeNo,checked){

    try{
		var eTABLE=document.getElementById("tDHCDocPatGuideDocumentsPrt");
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("Selectz"+i);
			var LabNo=GetColumnData("LabEpisodeNo",i)
			//remove space char
			var LabEpisodeNo= LabNo.replace(/[\t\n\r ]/g, "");
			if (LabEpisodeNo=="") continue;
			if (LabEpisodeNo!=SelectLabEpisodeNo) continue;
			SetColumnData("Select",i,checked);
			
		}
    }catch(e){alert(e.message)}
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

function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj.tagName=='LABEL'){
		return CellObj.innerText;
	}else{
		if (CellObj.type=="checkbox"){
			return CellObj.checked;
		}else{
			return CellObj.value;}
		}
	return "";
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
	if(escape(char1).indexOf("%u")!=-1) return true;
	return false;
}
	
function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
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

function ISPhamacyChangeHandler()
{
	var obj=document.getElementById("IsPhamacy");
	if (obj) {
		var IsPhamacy=obj.checked;
		var objtbl=document.getElementById('tUDHCOrderItem_Print');
		var rows=objtbl.rows.length;
		var Row="1";
		for (var j=1;j<rows;j++) {
			//because come for query,rowid is show as "1,2,3.."
			//if (j!=1) Row=Row+1;
			Row=j
			//Rowid:OrderName:StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:
			//Frequence:Instruction:Duration:PackQty:RecDep:Billed"
	        var Tbl_Select=document.getElementById("Selectz"+Row);
	        var Tbl_OrderType=document.getElementById("OrderTypez"+Row);
	        if ((Tbl_Select)&&(Tbl_OrderType)){
		        if (IsPhamacy) {
			        if (Tbl_OrderType.value=="R") {
		        		Tbl_Select.checked=true;
			        }else{
				        Tbl_Select.checked=false;
		        	}
		        }else{
		           Tbl_Select.checked=true;
		        }
	        }
		}
	}
}

function CleartTbl()
{
	var objtbl=document.getElementById('tUDHCOrderItem_Print');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex;j++) {
		objtbl.deleteRow(1);
		//alert(j)
	}
}


function QueryDetail(value) {
	try {

		if (value!=""){	
		var objtbl=document.getElementById('tUDHCOrderItem_Print');
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
		
        if (LoopCount!=1) AddRowToList(objtbl);
        LoopCount=LoopCount+1;
        
		var eSrc=objtbl.rows[LastRow];
		var RowObj=getRow(eSrc);
		var rowitems=RowObj.all;
		if (!rowitems) rowitems=RowObj.getElementsByTagName("label");
		//alert(rowitems.length);
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split("z");
				var Row=arrId[arrId.length-1];
			}
		}
		//DHCWebD_AddTabRow(objtbl);

		//alert(Row);
		var Split_Value=value.split("^")
		//Rowid:OrderName:StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:
		//Frequence:Instruction:Duration:PackQty:RecDep:Billed"
		var Tbl_Rowid=document.getElementById("Rowidz"+Row);
		var Tbl_OrderName=document.getElementById("OrderNamez"+Row);
		var Tbl_StartDat=document.getElementById("StartDatez"+Row);
		var Tbl_SeqNo=document.getElementById("SeqNoz"+Row);
		var Tbl_DoseQty=document.getElementById("DoseQtyz"+Row);
		var Tbl_DoseUOM=document.getElementById("DoseUOMz"+Row);
		var Tbl_Priority=document.getElementById("Priorityz"+Row);
		var Tbl_Status=document.getElementById("Statusz"+Row);
		var Tbl_Frequence=document.getElementById("Frequencez"+Row);
		var Tbl_Instruction=document.getElementById("Instructionz"+Row);
		var Tbl_Duration=document.getElementById("Durationz"+Row);
		var Tbl_PackQty=document.getElementById("PackQtyz"+Row);
		var Tbl_PackUOM=document.getElementById("PackUOMz"+Row);
		var Tbl_RecDep=document.getElementById("RecDepz"+Row);
		var Tbl_Price=document.getElementById("Pricez"+Row);
		var Tbl_Sum=document.getElementById("Sumz"+Row);
		var Tbl_Billed=document.getElementById("Billedz"+Row);
        var Tbl_Select=document.getElementById("Selectz"+Row);
        var Tbl_BillType=document.getElementById("BillTypez"+Row);
        var Tbl_OrderType=document.getElementById("OrderTypez"+Row);

   	 	Tbl_Rowid.innerText=unescape(Split_Value[0]);
    	Tbl_OrderName.innerText=unescape(Split_Value[1]);
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
   		Tbl_OrderType.innerText=unescape(Split_Value[17]);
        Tbl_Select.checked=true;
		//AddRowToList(objtbl);
		}
	} catch(e) {};
}

function AddRowToList(objtbl) {
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	//objtbl=websys_getParentElement(objlastrow);
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
			//rowitems[j].innerText="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
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
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}	
	//DHCWebD_ResetRowItems(objtbl);
}

function DHCWebD_ResetRowItems(objtbl) {
	//alert(objtbl.rows.length);
	//check the header by z; zhaocz;
	var firstrow=objtbl.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=objrow.getElementsByTagName("*"); //N6
	var myaryid=firstitems[1].id.split("z");
	if (myaryid.length==2){
		//no header
			fIdx=0
		}else{
			fIdx=1
		}
	for (var i=fIdx;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+":"+j+":"+rowitems[j].type);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split("z");
				arrId[arrId.length-1]=i;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			}
		}
	}
}

function PrintClickHandler(){
	try {
	
     PrintNew();
	} catch(e) {};
}
function RePrintClickHandler(){
	try{
		RePrintFlag=1
		PrintNew();
		} catch(e) {};
	
}
function PrintjcClickHandler(){
	try {
        if (HospitalCode=="HF"){
	        PrintAHHFjc();
	        //PrintAHHF();
	        return;
         }

	} catch(e) {};
}
function PrintzlClickHandler(){
	try {
        if (HospitalCode=="HF"){
	        PrintAHHFzl();
	        //PrintAHHF();
	        return;
         }

	} catch(e) {};
}

function InitalJST(){
	try {
		var objtbl=document.getElementById('tDHCDocPatGuideDocumentsPrt');
		var rows=objtbl.rows.length;
		var Rowid,OrderName,StartDate,StatusCode,Spec,UserAddName;

	    var MyList="";
	    var Row="1";

		for (var j=1;j<rows;j++) {
            StatusCode=GetColumnData("StatusCode",j);
            if (StatusCode=="E"){
	            SetColumnData("Select",j,false);
            }
		}
	} catch(e) {alert(e.message)};	
}	

function GetTrimStr(Str,maxlen)
{
		var len=Str.length;
		var len1=0;
		for (var j=0;j<len;j++) {
			var char1=Str.substring(j,j+1);
			if (CheckChinese(char1)) {len1=len1+2}else{len1=len1+1	}
			if (len1>maxlen) {
				return Str.substring(0,j);
			}
		}
		return Str;

}

function ReLoccount(Loccount){
	  var LocArray="";
    var objtbl=document.getElementById('tDHCDocPatGuideDocumentsPrt');
		var rows=objtbl.rows.length;
	  for (var j=1;j<rows;j++) {
	  	   var reloc=document.getElementById('LabEpisodeNoz'+j).innerText;
	  	   var selectflag=document.getElementById('Selectz'+j).checked;
	       if ((LocArray=="")&(selectflag==true))  { LocArray=reloc
	                          }else{  var LocFlag="Y";
	                          	      for (j1=0;j1<LocArray.split("^").length;j1++){
	                          	      	                 if ((reloc==LocArray.split("^")[j1])&&(selectflag==true)){LocFlag="N"}
	                          	      	                 }
	                          	      if ((LocFlag=="Y")&&(selectflag==true)){LocArray=LocArray+"^"+reloc;}
	          	                             	                	                  
	          	                   }
	          	      
	          	               } 	
	          	              
	     return(LocArray);   

}
function  SelectRowHandler()	{
  var eSrc=window.event.srcElement;
  var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
if (selectrow !=0) {
	
	var LabEpisodeNoLink='LabEpisodeNoz'+selectrow;
	var RowidLink='Rowidz'+selectrow;
		if (eSrc.id==LabEpisodeNoLink)	{
			var LabEpisodeNo=document.getElementById('LabEpisodeNoz'+selectrow).innerText
			var Str="http://173.116.11.32/hh_lis_new/Query/zl_query_record.aspx?t=4&p="+LabEpisodeNo
			newWindow=window.open(Str,"LabReports","top=100,right=100,height=600,width=1000")

			return false;
		}
		if (eSrc.id==RowidLink)	{
			//alert(document.getElementById('Rowidz'+selectrow).innerText);
			return false;
		}
		
	}

	}

//+ by rp
function AllSelect_OnClick(){
	var mycheck=DHCWebD_GetObjValue("CheckAll");
	SelectAll(mycheck);
}

function SelectAll(myCheck){
	///var myRLStr="";
	var myRows=DHCWeb_GetTBRows("tDHCDocPatGuideDocumentsPrt");
	for (var i=1;i<=myRows;i++){
    
		var sSelect=document.getElementById('Selectz'+i);
		if (!sSelect.disabled){
			DHCWebD_SetListValueA(sSelect,myCheck);
		}
	}
}
function DHCWeb_GetTBRows(TbName)
{
	try{
		var myrows=0;
		var tabObj=document.getElementById(TbName);
		if (tabObj){
			var myrows=tabObj.rows.length-1;
		}
		return myrows;
	}catch(e){
		alert(e.toString);
		return 0;
	}
}

function PrintNew(){
	try{	
	var obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;	
	var obj=document.getElementById("AdmDep");
	if (obj) var AdmDep=obj.value;
	var AdmDepDesc=mPiece(AdmDep,"-",1);
	if (!AdmDepDesc) AdmDepDesc=AdmDep;
	var obj=document.getElementById("AdmDate");
	if (obj) var AdmDate=obj.value;
	var obj=document.getElementById('PrintDate');
	if (obj) var PrintDate=obj.value;	
	
	var CTLOCID=session['LOGON.CTLOCID']
	var GetPatientInfoAc=document.getElementById("GetNowTime");
	if (GetPatientInfoAc){
		var encmeth=GetPatientInfoAc.value;
	}
	if (encmeth!=""){
		PatientInfo=cspRunServerMethod(encmeth,EpisodeID,CTLOCID);
		//alert(PatientInfo);		
		if (PatientInfo!=""){
			PatientNo=PatientInfo.split("^")[1];
			PatientName=PatientInfo.split("^")[2];
			PatientSex=PatientInfo.split("^")[3];
			Age=PatientInfo.split("^")[4];
			InMedicare=PatientInfo.split("^")[18];
			MedicareType=PatientInfo.split("^")[6];
			PatientCompany=PatientInfo.split("^")[14];
			CTLOCName=PatientInfo.split("^")[24];
			PrintTime=PatientInfo.split("^")[25];
			PAAdmNo=PatientInfo.split("^")[35];
			CardNo=PatientInfo.split("^")[29];			
			PatType=PatientInfo.split("^")[6];				
		}
	}
	var PatGuideInfo=""
	var objtbl=document.getElementById('tDHCDocPatGuideDocumentsPrt');
	var rows=objtbl.rows.length;
	for(var i=1;i<rows;i++){
		var row=i;
		var SelectFlag=GetColumnData("Select",row);		
		if (SelectFlag==true){
			var Rowid=GetColumnData("Rowid",row);
			var OrderName=GetColumnData("OrderName",row);
			var Billed=GetColumnData("Billed",row);
			var BillType=GetColumnData("BillType",row);
			var UserAddName=GetColumnData("UserAddName",row);
			var Spec=GetColumnData("Spec",row);
			var PackQty=GetColumnData("PackQty",row);
			var PackUOM=GetColumnData("PackUOM",row);
			var Price=GetColumnData("Price",row);
			var Sum=GetColumnData("Sum",row);
			var OrderNotes=GetColumnData("OrderNotes",row);
			var ProcessingNotes=GetColumnData("ProcessingNotes",row);			
			var length=ProcessingNotes.length;
			if ((length==0)||(length==1)){
				ProcessingNotes=""
			}			
			var SkinTest=GetColumnData("SkinTest",row);
			var RecDepDesc=GetColumnData("LabEpisodeNo",row);
			if (RecDepDesc==""){RecDepDesc=AdmDepDesc;}
			var LabEpisodeNo=document.getElementById('LabEpisodeNoz'+row).innerText;
            var RecDepLabEpisodeNo=RecDepDesc+"^"+LabEpisodeNo;
			var RecDep=GetColumnData("RecDep",row);
			var Location=GetColumnData("Location",row);
			var OecCat=GetColumnData("OecCat",row);
			var OecCatDesc=GetColumnData("OecCatDesc",row);
			var StartDate=GetColumnData("StartDate",row);   
			var OrdInfo=Rowid+"^"+OrderName+"^"+Billed+"^"+BillType+"^"+UserAddName+"^"+Spec+"^"+PackQty+"^"+PackUOM+"^"+Price+"^"+Sum+"^"+OrderNotes+"^"+ProcessingNotes+"^"+SkinTest+"^"+RecDepDesc+"^"+LabEpisodeNo+"^"+RecDep+"^"+Location+"^"+OecCat+"^"+OecCatDesc+"^"+EpisodeID		
			if (PatGuideInfo=="") {
				PatGuideInfo=OrdInfo;
			}else{
				PatGuideInfo=PatGuideInfo+String.fromCharCode(2)+OrdInfo;
			}
		}
		
	}	
	var MyList=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetPatGuideList",PatGuideInfo,RePrintFlag);	
	//alert(MyList);
	if (MyList==""){
		alert(t['NoPrintOrder']+",请点击取消，手动打印导诊单");
		return;
	}
	
 	var myobj=document.getElementById("ClsBillPrint");
 	var MyListArr=MyList.split("||"); 	
 	for(var i=0;i<MyListArr.length;i++){
	 	var rowid=i+1;
	 	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetPatGuideSum",rowid);
	    //alert(ret);
	    var SumArr=ret.split("^");
	    var total=SumArr[0]
	    var PaidSum=SumArr[1]	
	    var ToPaidSum=SumArr[2]	
	    var MyPara="";
  	    MyPara=MyPara+"PrescTitle"+String.fromCharCode(2)+"";
        MyPara=MyPara+"^PANo"+String.fromCharCode(2)+PatientNo;
        MyPara=MyPara+"^AdmDep"+String.fromCharCode(2)+AdmDepDesc;
        MyPara=MyPara+"^AdmDate"+String.fromCharCode(2)+AdmDate;
        MyPara=MyPara+"^Name"+String.fromCharCode(2)+PatientName;
        MyPara=MyPara+"^Sex"+String.fromCharCode(2)+PatientSex;
        MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
        MyPara=MyPara+"^AdmDep"+String.fromCharCode(2)+AdmDepDesc;
        MyPara=MyPara+"^AdmDoc"+String.fromCharCode(2)+UserAddName;
        MyPara=MyPara+"^InMedicare"+String.fromCharCode(2)+InMedicare;
        MyPara=MyPara+"^PatType"+String.fromCharCode(2)+PatType
        MyPara=MyPara+"^PrintDate"+String.fromCharCode(2)+StartDate; 
        MyPara=MyPara+"^MRDiagnos"+String.fromCharCode(2)+MRDiagnos; 
        //MyPara=MyPara+"^total"+String.fromCharCode(2)+'金额:'+total+'元'; 
        MyPara=MyPara+"^total"+String.fromCharCode(2)+total; 
        MyPara=MyPara+"^RecLoc"+String.fromCharCode(2)+"["+RecDepDesc+"]";
        MyPara=MyPara+"^PANoBarCord"+String.fromCharCode(2)+"*"+PatientNo+"*";	 	
	 	PrintFun(myobj,MyPara,MyListArr[i]);
 	} 	
 	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SetOrdPrtFlag");  //置打印标记
 	} catch(e) {alert(e.message)};

}
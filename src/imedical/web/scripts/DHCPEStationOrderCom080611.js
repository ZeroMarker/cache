/// DHCPEStationOrderCom.js
/// ����ʱ��		2006.03.16
/// ������		xuwm
/// ��Ҫ����		վ���������(ҽ��)���ձ�
/// ��Ӧ��		DHC_PE_StationOrder
/// ����޸�ʱ��	
/// ����޸���	

var CurrentSel=0;

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click }
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }

	//�Ͳ�����
	obj=document.getElementById("Preprandial");
	if (obj){ obj.onclick=Diet_click; }
	obj=document.getElementById("Postprandial");
	if (obj){ obj.onclick=Diet_click; }	
	 obj=document.getElementById("NoLimited");
	if (obj){ obj.onclick=Diet_click; }
	
	obj=document.getElementById("BFind")
	if (obj){obj.onclick=Find_click;}
		
	iniForm();
	
}  
function Find_click()
{
	var obj,ParRef="",ParRefName="",ARCIMDesc="";
	obj=document.getElementById("ParRefBox");
	if (obj) ParRef=obj.value;
	obj=document.getElementById("ParRefNameBox");
	if (obj) ParRefName=obj.value;
	obj=document.getElementById("ARCIMDesc");
	if (obj) ARCIMDesc=obj.value;
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEStationOrderCom"
			+"&ParRef="+ParRef+"&ParRefName="+ParRefName+"&ARCIMDesc="+ARCIMDesc;

	window.location.href=lnk; 
}
function iniForm(){	

	var SelRowObj;
	var obj;
	
	SelRowObj=document.getElementById('ParRefBox');	
	obj=document.getElementById('ParRef');
	if (SelRowObj && obj) {obj.value=SelRowObj.value; }

	if (obj && ""==obj.value)
	{
		obj=document.getElementById("ParRef_Name");
	    if (obj) { obj.value="δѡ��վ��"; }
	}
	else
	{
		SelRowObj=document.getElementById('ParRefNameBox');	
		obj=document.getElementById('ParRef_Name');
		if (SelRowObj && obj) {obj.value=SelRowObj.value; }
		
		ShowCurRecord(1);
	}

}

 function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
 }	

function Clear_click(){
	    
	//ҽ������
	obj=document.getElementById("ARCIMCode");
	if (obj) { obj.value=""; }

	//ҽ������
	obj=document.getElementById("ARCIMDesc");
	if (obj) { obj.value=""; }
	    
	//ҽ����¼��
	obj=document.getElementById("ARCIMDR");
	if (obj) { obj.value=""; }
	    
	//��¼���� 
	obj=document.getElementById("Childsub");
	if (obj) { obj.value=""; }
	
	//��¼���
	obj=document.getElementById("Rowid");
	if (obj) { obj.value=""; }
	
	//�Ͳͱ�־
	obj=document.getElementById("Diet");
	if (obj){ obj.checked=false; }

	//�Ͳͱ�־
	obj=document.getElementById("IsHaveChilud");
	if (obj) { obj.value=""; }
	
	// ҽ��������
	obj=document.getElementById("ARCOS_DR_Name");
	if (obj) { obj.value=""; }
	
	// ҽ���ױ���
	obj=document.getElementById("ARCOS_DR");
	if (obj) { obj.value=""; }
	
	// �����ʽ
	obj=document.getElementById("ReportFormat");
	if (obj) { obj.value=""; }
	
	// STORD_Notice	ע������ 
	obj=document.getElementById("Notice");
	if (obj) { obj.value=""; }
	// STORD_Notice	�Զ��ش� 
	obj=document.getElementById("AutoReturn");
	if (obj) { obj.checked=true; }
} 

function Update_click(){

	var iParRef="", iRowId="", iChildSub="",iAutoReturn="N";
	var iARCIMDR="",iDiet="N",iARCOSDR="",iReportFormat="",iNotice="";
	var obj;
	
	//���� վ����	
	obj=document.getElementById("ParRef");  
	if (obj) { iParRef=obj.value; }
	
	iRowid=""
	
	//��¼����
	obj=document.getElementById("ChildSub");  
	if (obj) { iChildSub=obj.value; }
	
	//ҽ�����
	obj=document.getElementById("ARCIMDR");  
	if (obj){iARCIMDR=obj.value; }

	//�����ʽ
	obj=document.getElementById("ARCOS_DR");  
	if (obj){
		iARCOSDR=trim(obj.value);
		obj=document.getElementById("ARCOS_DR_Name");
		if (obj && ""==obj.value) { iARCOSDR="" }
	}
	
	//�����ʽ
	obj=document.getElementById("ReportFormat");  
	if (obj){
		iReportFormat=trim(obj.value);
		iReportFormat=iReportFormat.toUpperCase();
	}
	
	//�Ͳͱ�־
	iDiet=GetDiet();

	// STORD_Notice	ע������ 
	obj=document.getElementById("Notice");
	if (obj) { iNotice=obj.value }


	//����������֤
	if ((""==iARCIMDR)||(""==iParRef)){
		//alert("Please entry all information.");
		alert(t['XMISSING']);
		return false;
	}  
	
	obj=document.getElementById("AutoReturn");
	if (obj&&obj.checked) iAutoReturn="Y"
	var Instring=trim(iParRef)			// 1 
				+"^"+trim(iRowId)		// 2 
				+"^"+trim(iChildSub)	// 3 
				+"^"+trim(iARCIMDR)		// 4 
				+"^"+trim(iDiet)		// 5 
				+"^"+trim(iARCOSDR)		// 6 
				+"^"+trim(iReportFormat)	// 7 
				+"^"+trim(iNotice)		// 8
				+"^"+trim(iAutoReturn)		// 9
				;

	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } 
	else { var encmeth=''; };
	
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	if ('0'==flag) {
		location.reload();
	}else if ('-119'==flag) {
		//alert("����Ŀ�ѱ�ʹ��!!!");
		alert(t['-119']);
	}else{
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
	}
}

function Delete_click(){

	var iParRef="", iChildSub="";
	
	var obj;

	//վ����
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	//��ǰ��¼���
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
    
	if ((iParRef=="")||(iChildSub=="")){
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false
	} 
	else{ 
		//var iIsHaveChilud="",strShowAlert="";
		//obj=document.getElementById("IsHaveChilud");
		//if (obj) { var IsHaveChilud=obj.value; }
		//if ("Y"==iIsHaveChilud) { strShowAlert=t['04']; } //if (confirm("Are you sure delete it?")) {
		//else { strShowAlert=t['05']; } //
		
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''};
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub);
			if ('0'==flag) {}
			else{ 
				//alert("Delete error.ErrNo="+flag); 
				alert(t['05']+flag);
			}
			location.reload(); 
		}
	}

}
function FromTableToItem(Dobj,Sobj,selectrow) {

	var SelRowObj;
	var obj;
	var LabelValue="";

	SelRowObj=document.getElementById(Sobj+'z'+selectrow);
	if (!(SelRowObj)) { return null; }
	LabelValue=SelRowObj.tagName.toUpperCase();
   	obj=document.getElementById(Dobj);
   	if (!(obj)) { return null; }
   	
   	if ("LABEL"==LabelValue) {		
		obj.value=trim(SelRowObj.innerText);
		return obj;
	}
	
	if ("INPUT"==LabelValue) {
		LabelValue=SelRowObj.type.toUpperCase();
		
		if ("CHECKBOX"==LabelValue) {
			obj.checked=SelRowObj.checked;
			return obj;
		}
		
		if ("HIDDEN"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}
		
		if ("TEXT"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}

		obj.value=SelRowObj.type+trim(SelRowObj.value);
		return obj;
	}

}

//��ʾ��ǰ��¼
function ShowCurRecord(CurRecord){
	
	var selectrow=CurRecord;
	var SelRowObj;
	var obj;
		
	//����� ��Ŀ���� ��ʾ
	SelRowObj=document.getElementById('STORD_ARCIM_Code'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ARCIMCode");
    	obj.value=trim(SelRowObj.innerText);
	}
	//����� ��Ŀ���� ��ʾ
	SelRowObj=document.getElementById('STORD_ARCIM_Desc'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ARCIMDesc");
		obj.value=trim(SelRowObj.innerText);
	}
	
		//����� ��Ŀ��� ��ʾ
		//SelRowObj=document.getElementById('STORD_ParRef_Name'+'z'+selectrow);
		//obj=document.getElementById("ParRef_Name");
		//obj.value=trim(SelRowObj.value);

		//��Ҫ�ӵ�ǰ��¼ȡ�õ�ǰҳ�游�ڵ�
		//SelRowObj=document.getElementById('STORD_ParRef'+'z'+selectrow);
		//obj=document.getElementById("ParRef");	
		//obj.value=trim(SelRowObj.value);

	//ParRef �������� ʹ��ҳ�洫����� 
	SelRowObj=document.getElementById('STORD_Childsub'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Childsub");
		obj.value=SelRowObj.value;
	}
	
	//ҽ�����
	SelRowObj=document.getElementById('STORD_ARCIM_DR'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ARCIMDR");
		obj.value=SelRowObj.value;
	}
	
	//�Ͳͱ�־	STORD_Diet
	SelRowObj=document.getElementById('STORD_Diet1'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Diet");
		SetDiet(trim(SelRowObj.innerText));	
	}
	
	//�Ƿ�������	STORD_IsHaveChilud
	SelRowObj=document.getElementById('STORD_IsHaveChilud'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("IsHaveChilud");
		obj.value=SelRowObj.value;
	}
	
	// STORD_ARCOS_DR
	SelRowObj=document.getElementById('STORD_ARCOS_DR_Name'+'z'+selectrow);
	obj=document.getElementById("ARCOS_DR_Name");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	
	// STORD_ARCOS_DR


	SelRowObj=document.getElementById('STORD_ARCOS_DR'+'z'+selectrow);
	obj=document.getElementById("ARCOS_DR");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }	
	
	// STORD_ReportFormat
	SelRowObj=document.getElementById('STORD_ReportFormat'+'z'+selectrow);
	obj=document.getElementById("ReportFormat");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	
	//STORD_Notice	ע������
	SelRowObj=document.getElementById('STORD_Notice'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Notice");
		obj.value=SelRowObj.value;
	}
	//STORD_Notice	ע������
	SelRowObj=document.getElementById('TAutoReturn'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("AutoReturn");
		obj.checked=SelRowObj.checked;
	}	
}		
	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);		
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	if (selectrow==CurrentSel){

		Clear_click();
		CurrentSel=0
		return;
	}

	CurrentSel=selectrow;

	ShowCurRecord(selectrow); 
}

document.body.onload = BodyLoadHandler;
// //////////////////////////////////////////////////////////////
function Diet_click() {
	var eSrc=window.event.srcElement;
	SetDiet(eSrc.name);
}

function SetDiet(value) {
	var obj;
	
	obj=document.getElementById("Preprandial");
	if (obj){ obj.checked=false; }

	obj=document.getElementById("Postprandial");
	if (obj){ obj.checked=false; }
	
	obj=document.getElementById("NoLimited");
	if (obj){ obj.checked=false; }
		
	if ("Preprandial"==value || "PRE"==value) {
		obj=document.getElementById("Preprandial");
		if (obj){ obj.checked=true; }
		return obj;
	}
	
	if ("Postprandial"==value || "POST"==value) {
		obj=document.getElementById("Postprandial");
		if (obj){ obj.checked=true; }
		return obj;
	}
		
	if ("NoLimited"==value || "N"==value) {
		obj=document.getElementById("NoLimited");
		if (obj){ obj.checked=true; }
		return obj;
	}
	
	if (""==value) {
		obj=document.getElementById("NoLimited");
		if (obj){ obj.checked=true; }
		return obj;
	}	
	
}

function GetDiet() {
	var obj;
	
	obj=document.getElementById("Preprandial");
	if (obj && obj.checked){ return "PRE"; }

	obj=document.getElementById("Postprandial");
	if (obj && obj.checked){ return "POST"; }
	
	obj=document.getElementById("NoLimited");
	if (obj && obj.checked){ return "N"; }
	
	return "N";

}
// ////////////////////////////////////////////////////////////////////
//����ҽ�� ����ѡ��Ľ��
function SearchArcItmmast(value){
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		
		//Ĭ��ѡ���µ���Ŀ��Ҫ����
		Clear_click();

		//ҽ������
		obj=document.getElementById("ARCIMCode");
		obj.value=aiList[0];

		//ҽ������
		obj=document.getElementById("ARCIMDesc");
		obj.value=aiList[1];

		//ҽ�����
		obj=document.getElementById("ARCIMDR");
		obj.value=aiList[2];
		
	}
}

// ////////////////////////////////////////////////////////////////////
//ѡ��ҽ����
function SearchARCOrdSet(value){
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		//ҽ������
		obj=document.getElementById("ARCOS_DR_Name");
		if (obj) { obj.value=aiList[1]; }

		//ҽ�����
		obj=document.getElementById("ARCOS_DR");
		if (obj) { obj.value=aiList[2]; }
		
	}
}


/*
//����վ�� ����ѡ��Ľ��
function SearchStation(value){
	
		//����ı䵱ǰվ��
		var aiList=value.split("^");
		if (""==value){return false}
		else {
			var obj;
			
			Clear_click();
			
			//���� վ����
			obj=document.getElementById("ParRef");
			obj.value=aiList[2];

			//վ������
			obj=document.getElementById("ParRef_Name");
			obj.value=aiList[0];

		}

}
*/
// ////////////////////////////////////////////////////////////////////
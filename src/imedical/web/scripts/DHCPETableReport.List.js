/// DHCPETableReport.List.js
/// ����ʱ��		2008.04.03
/// ������		xuwm
/// ��Ҫ����		�״򱨸�ά��
/// ��Ӧ��		
/// ����޸�ʱ��	
/// ����޸���	
/// ���


var CurrentSel=0;

function BodyLoadHandler() {
	var obj;
	
	/*
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("DeleteReportItem");
	if (obj){ obj.onclick=DeleteReportItem_click; }	
	*/
	
	obj=document.getElementById("DeleteReport");
	if (obj){ obj.onclick=DeleteReport_click; }
	
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	
	// �������õ�ǰ��ѡ�ļ�¼��վ��
	obj=document.getElementById('BSetStation');
	if (obj){ obj.onclick=BSetStation_click; }
	
	obj=document.getElementById("STDesc");
	if (obj){ obj.onchange=STDesc_change; }
	
	iniForm();
}

function iniForm(){

}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//����Ϊ��
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

// ��ѯ
function BFind_click() {
	var obj;
	var iReportName='',iSTDR='';
	obj=document.getElementById('STDR');
	if (obj) { iSTDR=obj.value; }
	obj=document.getElementById('ReportName');
	if(obj) { iReportName=obj.value; }
	
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPETableReport.List'
			+'&ReportName='+iReportName
			+'&STDR='+iSTDR
			;
	location.href=lnk
	
}
function BSetStation_click() {
	var obj,Selobj;
	var iStation='';
	var rowcount=0;
	obj=document.getElementById('STDR');
	if (obj && -1!=obj.value) { iStation=obj.value; }
	else { return false; }

	var tlb=document.getElementById('tDHCPETableReport_List');
	if (tlb) { rowcount=tlb.rows.length; }
	else { return false;}

	for (i=1;i<rowcount;i++){
		Selobj=document.getElementById('TR_ST_Activez'+i);
		if (Selobj && Selobj.checked) {
			
			Selobj=document.getElementById('TR_ST_Descz'+i);
			if (Selobj) { Selobj.value=obj.value; }
			Tabel_STDesc_click(obj,i);
		}
	}

}



// ���±���ϵ�ǰ�޸ĵļ�¼
function Table_Update(CurrentRow){
	var iReportName="",iRowId="";
	var iODDR="";
	var obj;
	// ��������  
	obj=document.getElementById("TR_TableReport"+'z'+CurrentRow);
	if (obj){ iReportName=obj.innerText; } 
	
	//   
	obj=document.getElementById("TR_RowID"+'z'+CurrentRow);
	if (obj) { iRowId=obj.value; } 
	
	// ��Ŀ����
	obj=document.getElementById("TR_OD_DR"+'z'+CurrentRow);
	if (obj){ 
		iODDR=obj.value;
		if (''==iODDR) { iODDR='-1||'+iRowId; } // �հ�վ��
	} 

	var Instring=trim(iReportName)		// Report
				+"^"+trim(iRowId)		// RowId
				+"^"+trim(iODDR)		// OODR
				+"^"+''					// Label
				+"^"+''					// Coordinate
				+";"
				;
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if (flag.indexOf('����')>-1) {
		alert(flag);
		return false;
	}else{
		SelRowObj=document.getElementById("TR_IsUpdatez"+CurrentRow);
		if (SelRowObj) { SelRowObj.innerText='      '; }
	}
	return true;
	
	//ˢ��ҳ��
	//location.reload(); 
}

function DeleteReport_click() {
	var iReportName='';
	var obj;
	// ��������  
	obj=document.getElementById("ReportName");
	if (obj){ iReportName=obj.value; } 
	
	if (iReportName=="")	{
		//alert("Please select the row to be deleted.");
		//alert(t['03']);
		return false
	} 
	else{ 
		var InString="R"
					+"^"+iReportName
					+"^"+""
					+"^"+""
					;
		//if (confirm("Are you sure delete it?")){
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };

			var flag=cspRunServerMethod(encmeth,'','',InString)
			if (flag=='') {}
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag)
			}
		location.reload();
		}
	}
}


// ////////////////////////////////////////////////////////////////////////////////

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
	
	if ("SELECT"==LabelValue) {
		obj.value=trim(SelRowObj.value);
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

function ShowCurRecord(CurRecord) {
	
	var selectrow=CurRecord;

	// ��������
	FromTableToItem("ReportName", "TR_TableReport", selectrow);  
	
	FromTableToItem("RowID", "TR_RowID", selectrow);  
	
	// վ�����
	//FromTableToItem("STDR", "TR_ST_DR", selectrow);  
	
	// վ������
	//FromTableToItem("STDesc", "TR_ST_DR", selectrow);
	
	// ��Ŀ����
	//FromTableToItem("ODDR", "TR_OD_DR", selectrow); 
	
	// ��Ŀ����
	//FromTableToItem("ODDesc", "TR_OD_Desc", selectrow);  
	
	// ��Ŀ��ǩ
	//FromTableToItem("ODLabe", "TR_Label", selectrow);

	// λ��(����)
	//FromTableToItem("ODCoordinate", "TR_Coordinate", selectrow);
}


function SelectRowHandler() {

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
	    
	if (selectrow==CurrentSel)
	{	    
	    Clear_click();
	    CurrentSel=0;
	    return;
	}
	
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}
// ////////////////////////////////////////////////////////////////////////////////

// �޸ĵ�ǰ��¼��վ��
function Tabel_STDesc_click(e,Row) {
	var obj;
	obj=document.getElementById('TR_ST_DR'+'z'+Row);
	if (obj && e.value==obj.value){ return false; }
	
	obj=document.getElementById('TR_OD_DR'+'z'+Row);
	if (obj){ obj.value=''; }
	
	obj=document.getElementById('TR_OD_Desc'+'z'+Row);
	if (obj){ obj.innerText=''; }
	
}

// ��ʾ��ǰ��¼��վ�����Ե���Ŀ
function TableODDesc_lookuphandler(Row) {
	CurrentSel=Row;
	var url='websys.lookup.csp';
		url += "?ID="+'TR_OD_Descz'+CurrentSel;
		url += "&CONTEXT=Kweb.DHCPE.TableReport:QueryOrderDetail";
		url += "&TLUJSF=GetTableOrderDeatil";
	var obj=document.getElementById('TR_ST_Descz'+CurrentSel);
	if (obj) url += "&P1=" + websys_escape(obj.value);
	websys_lu(url,1,'');
	return websys_cancel();
}

// ���ص�ǰ��¼����Ŀ
function GetTableOrderDeatil(value) {

	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var SelRowObj;
		
		SelRowObj=document.getElementById("TR_OD_DRz"+CurrentSel);
		if (SelRowObj) { SelRowObj.value=aiList[2]; }
		
		SelRowObj=document.getElementById("TR_OD_Descz"+CurrentSel);
		if (SelRowObj) { SelRowObj.innerText=aiList[3]; }
		
		// �����޸ı�־ ***
		SelRowObj=document.getElementById("TR_IsUpdatez"+CurrentSel);
		if (SelRowObj) { SelRowObj.innerText='***'; }
			
	}
}

// ////////////////////////////////////////////////////////////////////////////////

// �ı�վ��
function STDesc_change() {
	var obj;
	
	obj=document.getElementById("STDesc");
	if (obj) { 
		var value=obj.value;
		obj=document.getElementById("STDR");
		if (obj) { obj.value=value; }
	}
	
	// �հ�վ��
	if ('-1'==value) {
		obj=document.getElementById("ODDR");
		if (obj) { obj.value=''; }
		obj=document.getElementById("ODDesc");
		if (obj) { obj.value=''; }
	}
	
}

// ��Ŀ���� 
function GetOrderDeatil(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("ODDR");
		if (obj) { obj.value=aiList[2]; }


		obj=document.getElementById("ODDesc");
		if (obj) { obj.value=aiList[3]; }

	}
}

document.body.onload = BodyLoadHandler;


/*
function Update_click() {
	var iReportName="",iRowId="";
	var iSRDR="", iODDR="", iLabel="", iCoordinate="";
	var iODDesc='',iSRDesc='';
	var obj;
	// ��������  
	obj=document.getElementById("ReportName");
	if (obj){ iReportName=obj.value; } 
	
	//   
	obj=document.getElementById("RowID");
	if (obj) { iRowId=obj.value; } 
	
	// վ�����
	obj=document.getElementById("STDesc");
	if (obj){
		iSRDR=obj.value;
		iSRDesc=obj.options[obj.selectedIndex].text;
	} 

	// ��Ŀ����
	obj=document.getElementById("ODDR");
	if (obj){ 
		iODDR=obj.value;
		if (''==iODDR) { iODDR='-1||'+iRowId; } // �հ�վ��
	} 
	
	// ��Ŀ����
	obj=document.getElementById("ODDesc");
	if (obj){ iODDesc=obj.value; } 
	
	// ��Ŀ����
	obj=document.getElementById("ODLabe");
	if (obj){ iLabel=obj.value; } 

	// λ��
	obj=document.getElementById("ODCoordinate");
	if (obj){ iCoordinate=obj.value; }
	
	//����������֤
	if ((iReportName=="")||(iLabel=="")) {
		//alert("Please entry all information.");
		alert(t['ReportName']+"or"+t['ODLabe']+t['XMISSING']);
		if (""==iReportName) { websys_setfocus("ReportName"); }
		if (""==iLabel) { websys_setfocus("ODLabe"); }
		return false;
	}  
	
	var Instring=trim(iReportName)		// Report
				+"^"+trim(iRowId)		// RowId
				+"^"+trim(iODDR)		// OODR
				+"^"+trim(iLabel)		// Label
				+"^"+trim(iCoordinate)	// Coordinate
				+";"
				;
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)

	if (flag.indexOf('����')>-1) {
		alert(flag);
		return false;
	}else{
		
		obj=document.getElementById('TR_ST_DR'+'z'+CurrentSel);
		if (obj){ obj.value=iSRDR; } 

		obj=document.getElementById('TR_ST_Desc'+'z'+CurrentSel);
		if (obj){ obj.innerText=iSRDesc; }  

		obj=document.getElementById('TR_OD_DR'+'z'+CurrentSel);
		if (obj){ obj.value=iODDR; } 
	
		obj=document.getElementById('TR_OD_Desc'+'z'+CurrentSel);
		if (obj){ obj.innerText=iODDesc; }  
	}
	return true;
	
	//ˢ��ҳ��
	//location.reload(); 
}
function Save() {
}
*/


/*
function DeleteReportItem_click() {
	var iReportName
	// ��������  
	obj=document.getElementById("ReportName");
	if (obj){ iReportName=obj.value; } 

	var obj=document.getElementById("RowID");
	if (obj){ iRowId=obj.value; }

	if (iRowId=="")	{
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false
	} 
	else{ 
		//if (confirm("Are you sure delete it?")){
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };

			var flag=cspRunServerMethod(encmeth,'','',iRowId)
			if (flag=='0') {}
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag)
			}
		location.reload();
		}
	}
}
*/

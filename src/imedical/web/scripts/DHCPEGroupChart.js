//DHCPEGroupChart.JS
var CurrentSel=0;

function BodyLoadHandler() {
	var obj;
	
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
			
	iniForm();
	
	ShowCurRecord(1);
	
}

function iniForm() {
	
	//��ȡ��ҳ
	var lParRef=document.getElementById('ParRefBox');	
	var lParRefName=document.getElementById('ParRefNameBox');
	
	if (""==lParRef.value) {
		obj=document.getElementById("SSGRP_DR_Name");
	    obj.value="δѡ��ȫ��";
	}
	else {
		obj=document.getElementById("SSGRP_DR");
		obj.value=lParRef.value;
		
		obj=document.getElementById("SSGRP_DR_Name");
	    if (obj) { obj.value=lParRefName.value; }
	}
}
function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

function GetChartID(value)	{	
	
	var val=value.split("^");
	var obj;
	
	//Ĭ�� ѡ��һ����ȫ����Ҫ����
	Clear_click();	
	
	//ͼ�����	
	obj=document.getElementById('Chart_DR');
	obj.value=val[1];
	
	//ͼ������
	obj=document.getElementById("Chart_DR_Name");
	obj.value=val[0];
	
}	


function Update_click(){
	
	var iRowID="",iSSGRPDR="",iChrtDR="",iRead="",iWrite="";
	var obj;

	obj=document.getElementById("RowId");
	if (obj) { iRowID=obj.value; }

	obj=document.getElementById("SSGRP_DR");
	if (obj) { iSSGRPDR=obj.value; }
	
	obj=document.getElementById("Chart_DR");
	if (obj) { iChrtDR=obj.value; }
	
	obj=document.getElementById("Read");  
	if (obj) { 
		if (true==obj.checked){ iRead="Y"; }
		else{ iRead="N"; } 
	}
	
	var obj=document.getElementById("Write");  
	if (obj) {
		if (true==obj.checked){ iWrite="Y"; }
		else{ iWrite="N"; } 
	}

	if ((""==iSSGRPDR)||(""==iChrtDR)){
		//alert("Please entry all information.");
		alert(t['01']);
		return false;
	}
	var Instring=trim(iRowID)+"^"+trim(iSSGRPDR)+"^"+trim(iChrtDR)+"^"+trim(iRead)+"^"+trim(iWrite);

	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } 
	else { var encmeth=''; };
	
    var flag=cspRunServerMethod(encmeth,'','',Instring);

	if ('0'==flag) {}
	else if ('Err 01'==flag){
		//alert("��ȫ��������");
		alert(t['Err 01']);
	}else{
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
	}
	
	location.reload();
	
}
function Delete_click(){

	var iRowID="";
	var obj;

	obj=document.getElementById("RowId");
	if (obj) { iRowID=obj.value; }
		//if (confirm("Are you sure delete it?")){
		if (confirm(t['04'])){
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else { var encmeth=''; }
			
			var flag=cspRunServerMethod(encmeth,iRowID)
			
			if ('0'==flag) {}
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag)
			}
			location.reload();

	}
}

//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
function Clear_click() {

	var SelRowObj;
	var obj;
	
	obj=document.getElementById("RowId");
	obj.value="";
		
	//��ȫ�����
	//obj=document.getElementById("SSGRP_DR");
	//obj.value="";
	
	//��ȫ������
	//obj=document.getElementById("SSGRP_DR_Name");
	//obj.value="";
	
	//ͼ�����
	obj=document.getElementById("Chart_DR");
	obj.value="";
	
	//ͼ������
	obj=document.getElementById("Chart_DR_Name");
	obj.value="";
	
	//ͼ��Ȩ�� �ɶ�
	obj=document.getElementById("Read");
	obj.checked=false;
	
	//ͼ��Ȩ�� ��д
	obj=document.getElementById("Write");
	obj.checked=false;
}

//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById("GC_RowId"+'z'+selectrow);
	obj=document.getElementById("RowId");
	if ((SelRowObj)&&(obj)) { obj.value=SelRowObj.value; }

	//��ȫ�����
	SelRowObj=document.getElementById('GC_SSGRP_DR'+'z'+selectrow);
	obj=document.getElementById("SSGRP_DR");
	if ((SelRowObj)&&(obj)) { obj.value=trim(SelRowObj.value); }
	
	//��ȫ������
	SelRowObj=document.getElementById('GC_SSGRP_DR_Name'+'z'+selectrow);
	obj=document.getElementById("SSGRP_DR_Name");
	if ((SelRowObj)&&(obj)) { obj.value=SelRowObj.innerText; }
	
	//ͼ�����
	SelRowObj=document.getElementById('GC_Chart_DR'+'z'+selectrow);
	obj=document.getElementById("Chart_DR");
	if ((SelRowObj)&&(obj)) { obj.value=trim(SelRowObj.value);	}
	
	//ͼ������
	SelRowObj=document.getElementById('GC_Chart_DR_Name'+'z'+selectrow);
	obj=document.getElementById("Chart_DR_Name");
	if ((SelRowObj)&&(obj)) { obj.value=SelRowObj.innerText; }
	
	//ͼ��Ȩ�� �ɶ�
	SelRowObj=document.getElementById('GC_Read'+'z'+selectrow);
	obj=document.getElementById("Read");
	if ((SelRowObj)&&(obj)) { obj.checked=SelRowObj.checked; }
	
	//ͼ��Ȩ�� ��д
	SelRowObj=document.getElementById('GC_Write'+'z'+selectrow);
	obj=document.getElementById("Write");
	if ((SelRowObj)&&(obj)) { obj.checked=SelRowObj.checked; }

}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var objtbl=document.getElementById('tDHCPEGroupChart');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;




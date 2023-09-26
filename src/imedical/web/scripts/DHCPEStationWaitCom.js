/// DHCPEStationWaitCom.js
/// ����ʱ��		2006.03.22
/// ������		xuwm 
/// ��Ҫ����		վ��Ⱥ�ͻ��Ŷӱ�(DHC_PE_Station���ӱ�)
/// ��Ӧ��		DHC_PE_StationWait
/// ����޸�ʱ��	
/// ����޸���	

var CurrentSel=0
var StationWaitADMCount=0;  //վ��Ⱥ�����
function BodyLoadHandler() {

	var obj=document.getElementById("Update");
	if (obj) { obj.onclick=Update_click; }
	
	var obj=document.getElementById("Delete");
	if (obj) { obj.onclick=Delete_click; }
	
	var obj=document.getElementById("Clear");
	if (obj) { obj.onclick=Clear_click; }		

	iniForm();
}  

function iniForm(){

	var SelRowObj;
	var obj;
	ShowStationWaitADMCount();
	
	SelRowObj=document.getElementById('ParRefBox');
	if (SelRowObj) {
		obj=document.getElementById("ParRef");
		if (obj) { obj.value=SelRowObj.value; }
	}
	// ����վ��
	if (""==obj.value) { obj.value="16"; }
	
	if (''==SelRowObj.value) {
		obj=document.getElementById("ParRef_Name");
		//if (obj) { obj.value="δѡ��վ��"; }
		if (obj) { obj.value=t["06"]; }
	}else{ 
	    obj=document.getElementById("ParRef_Name");
	    //if (obj) { obj.value="��ǰվ��û�еȺ���Ա"; }
	    if (obj) { obj.value=t["07"]; 
	    }
	    
		ShowCurRecord(1); 
	}
	
}

function Clear_click()
{       
	var obj;

	//�Ⱥ���Ա����
	obj=document.getElementById("IADM_DR");
	obj.value="";
	    
	//�Ⱥ���Ա����
	obj=document.getElementById("IADM_DR_Name");
	obj.value="";

	/*
	//��ǰվ�����
	obj=document.getElementById("ParRef");
	obj.value="";	 
	       
	//��ǰվ������	    
	obj=document.getElementById("ParRef_Name");
	obj.value="";
	*/
	    
	//��ǰ��¼����
	obj=document.getElementById("ChildSub");
	obj.value="";
}
	
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (null == m) ? "" : m[1];
}	
// *******************************************************
function Update_click() {
	
	var iParRef="", iRowId="", iChildSub="";
	var iIADMDR="";
	var obj;

	//�Ⱥ���Ա����
	obj=document.getElementById("IADM_DR");
	if (obj){iIADMDR=obj.value; } 
 
  	//��ǰվ�����
	obj=document.getElementById("ParRef");  
	if (obj){iParRef=obj.value; }
  
	//RowId�����޷����� ������ λ��Ԥ��
	//var obj=document.getElementById("Rowid");  
	//if (obj){iRowid=obj.value; }
	iRowid=""
   
	obj=document.getElementById("ChildSub");  
	if (obj){iChildSub=obj.value; }

	if (""==iIADMDR){
		alert("Please entry all information.");
		//alert(t['01']);
		return false;
	}  
  
	if (""==iParRef){ alert("��Чվ��"); }

	if (""!=iChildSub){
		//alert("�Բ���,�����޸ĵȺ���Ա�б�");
		alert(t["Err 06"]);
		return false;
	}
	
	var Instring=trim(iParRef)+"^"+trim(iRowId)+"^"+trim(iChildSub)+"^"+trim(iIADMDR);
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else{ var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if ('0'==flag) {
		location.reload();
	}
	else if ('-104'==flag) {
		//alert('�����õĸ����¼������');
		alert(t["Err 07"]);
	}
	else if ('Err 05'==flag) {
		//alert('�ܼ������ڵ�ǰվ��Ⱥ�');
		alert(t["Err 05"]);
	}		
	else{
		//alert("Insert error.ErrNo="+flag)
		alert(t['02']+flag);
	}

	
}

function Delete_click(){

	var iParRef="", iChildSub=""
	var obj;

	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }

	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value }

	if ((""==iParRef)||(""==iChildSub)){
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false;
	} 
	else{ 
		//if (confirm("Are you sure delete it?")) {
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else { var encmeth=''; }
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub)
			if ('0'==flag) {}
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag);
			}
			location.reload();
		}
	}
}

function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;	

	//�Ⱥ���Ա����	 
	SelRowObj=document.getElementById('STW_IADM_DR'+'z'+selectrow);	
	obj=document.getElementById("IADM_DR");
	obj.value=SelRowObj.value;

	//�Ⱥ���Ա����
	SelRowObj=document.getElementById('STW_IADM_DR_Name'+'z'+selectrow);
	obj=document.getElementById("IADM_DR_Name");
	obj.value=trim(SelRowObj.innerText);
	
	//��ǰվ�����
	SelRowObj=document.getElementById('STW_ParRef'+'z'+selectrow);	
	obj=document.getElementById("ParRef");
	obj.value=trim(SelRowObj.value);

	//��ǰվ������	 
	SelRowObj=document.getElementById('STW_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	obj.value=trim(SelRowObj.value);	
	
   
	//RowId ������ʽ�� OD_ParRef||OD_ChildSub ��˫�����޷�?�˲����޷��� 
	//SelRowObj=document.getElementById('OD_RowId'+'z'+selectrow);
	//obj=document.getElementById("RowId");
	//obj.value=SelRowObj.value;

	SelRowObj=document.getElementById('STW_Childsub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	obj.value=SelRowObj.value;	
}
	
// ��ʾ��ǰվ��ĵȺ�����
function ShowStationWaitADMCount() {

	var obj=document.getElementById("TFORM");
	if (obj){ tForm="t"+obj.value; }

	var objtbl=document.getElementById(tForm);

	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;

	StationWaitADMCount=lastrowindex;

	var obj=document.getElementById("cStationWaitConut");
	if (obj){ obj.innerText=StationWaitADMCount; }
	
}
	
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm="t"+obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;

		
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	if (selectrow==CurrentSel){

	    Clear_click()  
	    CurrentSel=0
	    return;
	}
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;
// /////////////////////////////////////////////////////////////////////////////
//�������Ҫ����?����?��վ�� 
function SearchStation(value){
	
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		
		Clear_click();
		
		//��ǰվ�����
		obj=document.getElementById("ParRef");
		obj.value=aiList[2];

		//��ǰվ������	    
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[0];
	}
}

// ***************************************************
//��ȡ�����Ա
function SearchIADM(value){

	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		Clear_click();
	
		//����������
		obj=document.getElementById("IADM_DR");
		if (obj) { obj.value=aiList[2]; }

		//��������	    
		obj=document.getElementById("IADM_DR_Name");
		if (obj) { obj.value=aiList[0]; }
		
		//�ǼǺ�    
		obj=document.getElementById("RegNo");
		if (obj) { obj.value=aiList[1]; }
		
		//�ǼǺ�    
		obj=document.getElementById("PatName");
		if (obj) { obj.value=aiList[0]; }		
		
	}
}



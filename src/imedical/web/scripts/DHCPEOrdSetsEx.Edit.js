/// DHCPEPreGBaseInfo.Edit.js
/// ����ʱ��		2006.06.07
/// ������		xuwm
/// ��Ҫ����		ҽ���׹�����չ��
/// ��Ӧ��		DHC_PE_OrdSetsEx
/// ����޸�ʱ��	
/// ����޸���	
/// ���
var TFORM="";
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("OrdSets_DR_Name");
	//if (obj){obj.onfocus=txtfocus;}

	//����
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	//���
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }

	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	iniForm();


}
function txtfocus()
{
    var obj;
	obj=document.getElementById("OrdSets_DR_Name");
	/*active �������뷨Ϊ����
	inactive �������뷨ΪӢ��
	auto ��������뷨 (Ĭ��)
	disable ����ر����뷨
	*/
if(obj.style.imeMode ==  "disabled")
{                       
	//obj.style.imeMode   =   "active"; 
//	alert(1);
//	obj.value   =   "";                      
 }
else
{                      
	//alert(2);
	obj.style.imeMode   =   "disabled";    
	//obj.value   =   "";             
}      
   alert(obj.style.imeMode);


}
function iniForm(){
	var ID=""
	var obj;
	obj=document.getElementById('TFORM');
	if (obj) { TFORM=obj.value; }
	obj=document.getElementById('ID');
	
	if (obj && ""!=obj.value) { 
		ID=obj.value;
		FindPatDetail(ID);
				
	}	

}
function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

function FindPatDetail(ID){
	var Instring=ID;
	var Ins=document.getElementById('GetDetail');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);
	if (flag=='0') {
		return websys_cancel();
	}

}

//
function SetPatient_Sel(value) {
	var obj;
	Clear_click();
  
	var Data=value.split("^");
	var iLLoop=0;
	
	var iRowId=Data[iLLoop];	

	obj=document.getElementById('RowId');
	if (obj) { obj.value=iRowId; }		

	iLLoop=iLLoop+1;
	//OSE_OrdSets_DR	ҽ����
	obj=document.getElementById('OrdSets_DR');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//
	obj=document.getElementById('OrdSets_DR_Name');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//OSE_Break	�ɷ���
	obj=document.getElementById('Break');
	if (obj && "Y"==Data[iLLoop]) { obj.checked=true; }
	else { obj.checked=false; }
	iLLoop=iLLoop+1;
   	obj=document.getElementById('ShowOEItemName');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById('ShowBarName');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById('PrintOrdSets');
	if (obj && "Y"==Data[iLLoop]) { obj.checked=true; }
	else { obj.checked=false; }
	
	iLLoop=iLLoop+1;
	
	obj=document.getElementById('PatFeeType_DR_Name');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	obj=document.getElementById('Sex_DR_Name');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	
	 obj=document.getElementById('IFOLD');
	//obj=document.getElementById('IfOLD');
	if (obj && "Y"==Data[iLLoop]) { obj.checked=true; }
	else { obj.checked=false; }
			iLLoop=iLLoop+1;

	obj=document.getElementById('TarItemId');
	if (obj) { obj.value=Data[iLLoop]; }
		iLLoop=iLLoop+1;
	obj=document.getElementById('TarItem');
	if (obj) { obj.value=Data[iLLoop]; }

	return true;
}

function Update_click() {
	var iRowId="";
	var iOrdSetsDR="", iBreak="",iOEItemName="",iBarPrintName="",iPrintOrdSets="",iSex="";
	var obj;
    var TarItem="";

	//OSE_RowId
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }

	//OSE_OrdSets_DR	ҽ����
	obj=document.getElementById("OrdSets_DR");
	if (obj) { iOrdSetsDR=obj.value; }

	//OSE_Break	�ɷ���
	obj=document.getElementById("Break");
	if (obj && obj.checked) { iBreak="Y"; }
	else { iBreak="N"; }
	
	//�Ƿ������ײ�
	obj=document.getElementById("IFOLD");
	if (obj && obj.checked) { iIFOLD="Y"; }
	else { iIFOLD="N"; }
	
	obj=document.getElementById("PrintOrdSets");
	if (obj && obj.checked) { iPrintOrdSets="Y"; }
	else { iPrintOrdSets="N"; }
      
    obj=document.getElementById("ShowOEItemName");
	if (obj) { iOEItemName=obj.value; }
	 
	obj=document.getElementById("ShowBarName");
	if (obj) { iBarPrintName=obj.value; }

 	var SpecialItem="";
 	obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { SpecialItem=obj.value; }
 	obj=document.getElementById("Sex_DR_Name");
	if (obj) { iSex=obj.value; }
	//����������֤
	if (""==iOrdSetsDR) {
		//alert("Please entry all information.");
		alert(t['XMISSING']);
		return false;
	}  
	obj=document.getElementById("TarItemId");
	if (obj) { TarItem=obj.value; }
 
	var Instring=trim(iRowId)
				+"^"+trim(iOrdSetsDR)	//ҽ����
				+"^"+trim(iBreak)		//�ɷ���
				+"^"+trim(iPrintOrdSets)
				+"^"+trim(iOEItemName)	//���쵥����ʾ
				+"^"+trim(iBarPrintName)		//�����ӡ��ʾ
				+"^"+SpecialItem
				+"^"+iSex
				+"^"+trim(iIFOLD)
				+"^"+trim(TarItem)
				
				;
	//alert(Instring);
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if (flag=='0') {
		if (""==iRowId) { iRowId="-1"; }
		
		/*var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TFORM
				+"&ID="+iRowId
				;*/
        var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOrdSetsEx.Edit"
				+"&ID="+iRowId
				; 

		location.href=lnk;
	}
	else if ('-119'==flag) {
		//alert("ҽ����������");
		alert(t['Err 01']);
		return false;	}
	else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']);
		return false;
	}
	
	//location.reload();
	
	return true;
}
function Delete_click() {

	var iRowID="";

	var obj=document.getElementById("RowId");
	if (obj && ""!=obj.value){ iRowID=obj.value; } else { return false;}

	if (iRowID=="")	{
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

			var flag=cspRunServerMethod(encmeth,'','',iRowID)
			/*if (flag=='0') {
				var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TFORM
					;
				location.href=lnk;
			}*/
			if (flag=='0') {
				var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOrdSetsEx.Edit"
					;
				location.href=lnk;
			}

			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag)
			}
		}
	}
}
//����������Ϣ
function Clear_click() {
	var obj;	
	    
	//OSE_RowId
	obj=document.getElementById("RowId");
	if (obj) {obj.value=""; }

	//OSE_OrdSets_DR	ҽ����
	obj=document.getElementById('OrdSets_DR');
	if (obj) { obj.value=''; }

	//
	obj=document.getElementById('OrdSets_DR_Name');
	if (obj) { obj.value=''; }

	//OSE_Break	�ɷ���
	obj=document.getElementById('Break');
	if (obj) { obj.checked=false; }
	//OSE_Break	�ɷ���
	obj=document.getElementById('SpecialItem');
	if (obj) { obj.checked=false; }
	
	//���쵥����ʾ
	obj=document.getElementById('ShowOEItemName');
	if (obj) { obj.value=''; }
	//��������ʾ
	obj=document.getElementById('ShowBarName');
	if (obj) { obj.value=''; }
	//�Ƿ��ӡҽ����
	obj=document.getElementById('PrintOrdSets');
	if (obj) { obj.checked=false; }
	//�Ƿ������ײ�
	obj=document.getElementById('IFOLD');
	if (obj) { obj.checked=false; }
	//�շ���
	obj=document.getElementById('TarItem');
	if (obj) { obj.value=''; }
	//��������
	obj=document.getElementById('PatFeeType_DR_Name');
	if (obj) { obj.value=""; }
	//�Ա�
	obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.value=""; }

	
}

//ҽ����
function ARCOrdSetsList(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("OrdSets_DR_Name");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("OrdSets_DR");
		if (obj) { obj.value=aiList[2]; }

	}
}
function clickTaritem(value)
{
 	var aiList=value.split("^");
 	//alert(aiList);
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("TarItem");
		if (obj) { obj.value=aiList[2]; }


		obj=document.getElementById("TarItemId");
		if (obj) { obj.value=aiList[0]; }

	} 
}
document.body.onload = BodyLoadHandler;
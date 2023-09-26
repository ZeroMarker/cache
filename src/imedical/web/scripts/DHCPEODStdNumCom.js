/// DHCPEODStdNumCom.js
/// ����ʱ��		2006.03.21
/// ������		xuwm 
/// ��Ҫ����		����׼?��ֵ? DHC_PE_ OrderDetail���ӱ�
/// ��Ӧ��		DHC_PE_ODStdNum
/// ����޸�ʱ��	
/// ����޸���	

var CurrentSel=0
function BodyLoadHandler() {

	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click;}
	
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}
	
	var obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click;}

	//�����Ա� 
	var obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }
	var obj=document.getElementById("Sex_M");
	if (obj){ obj.onclick=Sex_click; }	
	var obj=document.getElementById("Sex_F");
	if (obj){ obj.onclick=Sex_click; }	
	
	iniForm();

	}

function iniForm() {	
	var SelRowObj;
	var obj;
	
	Clear_click();
	
	//��ȡҳ�游��Ŀ����
	SelRowObj=document.getElementById('ParRefBox');
	obj=document.getElementById("ParRef");
	obj.value=SelRowObj.value;
	
	if (''==SelRowObj.value){
	    obj=document.getElementById("ParRef_Name");
	    obj.value="δѡ��վ��";  	    		
	}else{		
	    //��ʾĬ��(��һ��)��¼
		ShowCurRecord(1);
	}		
}

function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}
 
//��ȡϸ���
function SearchDetailList(value){
	//��ѡ��һ����Ŀʱ Ĭ��Ҫ����һ���µĲο�
	
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		
		Clear_click();	
		
		//��ȡ�µ���Ŀ���
		obj=document.getElementById("ParRef");
		obj.value=aiList[0];
		
		//��ȡ�µ���Ŀ����
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[1];

	}
}

function Update_click(){
	 
	var iParRef="", iRowId="", iChildSub="";
	var iMin="",iMax="", iValue="", iNaturalValue="", iSex="", iUnitDR="";
  
	var obj;
	
	obj=document.getElementById("ParRef");  
	if (obj) { iParRef=obj.value; }

	//RowId�����޷����� ������ λ��Ԥ��
	//var obj=document.getElementById("Rowid");  
	//if (obj){ iRowid=obj.value; }
	iRowid="";  
  
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; } 
	
	//�ж�����
	obj=document.getElementById("Min");
	if (obj) { iMin=obj.value; } 
	
	//�ж�����
	obj=document.getElementById("Max");
	if (obj) { iMax=obj.value; } 
	
	//�жϽ��(����)
	obj=document.getElementById("Value");
	if (obj) { iValue=obj.value; }  
	
	//�Ƿ�����ֵ 1 ������(��һ����Ŀ��˵ ֻ��һ�������ο�)
	obj=document.getElementById("NaturalValue");
	if (obj) {
		if (true==obj.checked){ iNaturalValue="1"; }
		else{ iNaturalValue="0"; }
	}   
	
	//�����Ա�
	//obj=document.getElementById("Sex");  
	//if (obj){ iSex=obj.value; }
		iSex=GetSex(); 
	
	//��λ����
	obj=document.getElementById("Unit_DR_Name"); 
	//obj=document.getElementById("Unit_DR");
	if (obj){ iUnitDR=obj.value; } 
  
	//������֤
	if (""==iParRef) {
		alert("Please entry all information.");
		//alert(t['01']);
		return false;
	}  

	var Instring=trim(iParRef)+"^"+trim(iRowId)+"^"+trim(iChildSub)+"^"+trim(iMin)+"^"+trim(iMax)+"^"+trim(iValue)+"^"+trim(iNaturalValue)+"^"+trim(iSex)+"^"+trim(iUnitDR);

	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	
	if ('0'==flag) {}
	else{
		alert("Insert error.ErrNo="+flag)
		//alert(t['02']+flag);
	}
	
	location.reload(); 
}

function Delete_click() {
	
	var iParRef="", iChildSub="";
	var obj;
	
	//��Ŀ����
	obj=document.getElementById("ParRef");
	if (obj){ iParRef=obj.value; }
	
	//��ǰ��¼����
	obj=document.getElementById("ChildSub");
	if (obj){ iChildSub=obj.value; }

	if ((""==iParRef)||(""==iChildSub)){
		alert("Please select the row to be deleted.");
		return false
	}
	else { 
		if (confirm("Are you sure delete it?")){
			var Ins=document.getElementById('DeleteBox');
			
			if (Ins) {var encmeth=Ins.value} 
			else { var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub);
			
			if (flag=='0') {}
			else{
				alert("Delete error.ErrNo="+flag)
			}
			
			location.reload();
		}
	}
   
}

//��ʾ��ǰ��¼����
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	
	// --------------------------------------------------------------
	
	//��Ŀ����
	SelRowObj=document.getElementById('ODSN_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	obj.value=SelRowObj.value;   
	 
	//��Ŀ����
	SelRowObj=document.getElementById('ODSN_ParRef'+'z'+selectrow);
	obj=document.getElementById("ParRef");
	obj.value=SelRowObj.value;
	
	// --------------------------------------------------------------
		
	//�������
	SelRowObj=document.getElementById('ODSN_Min'+'z'+selectrow);
	obj=document.getElementById("Min");
	obj.value=trim(SelRowObj.innerText);
	
	//�������
	SelRowObj=document.getElementById('ODSN_Max'+'z'+selectrow);
	obj=document.getElementById("Max");
	obj.value=trim(SelRowObj.innerText);

	//�жϽ��(����)
	SelRowObj=document.getElementById('ODSN_Value'+'z'+selectrow);
	obj=document.getElementById("Value");
	obj.value=trim(SelRowObj.innerText);

	//�Ƿ�����ֵ
	SelRowObj=document.getElementById('ODSN_NaturalValue'+'z'+selectrow);
	obj=document.getElementById("NaturalValue");
	obj.checked=SelRowObj.checked;

	//�����Ա�
	SelRowObj=document.getElementById('ODSN_Sex'+'z'+selectrow);
	obj=document.getElementById("Sex");
	obj.value=trim(SelRowObj.innerText);
		SetSex("");	
		SetSex(trim(SelRowObj.innerText));
			
	//��λ����
	SelRowObj=document.getElementById('ODSN_Unit_DR'+'z'+selectrow);
	obj=document.getElementById("Unit_DR");
	obj.value=trim(SelRowObj.innerText);
	
	//��λ����
	SelRowObj=document.getElementById('ODSN_Unit_DR_Name'+'z'+selectrow);
	obj=document.getElementById("Unit_DR_Name");
	obj.value=trim(SelRowObj.innerText);

	//��¼����
	SelRowObj=document.getElementById('ODSN_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=SelRowObj.value;

	//��¼���
	SelRowObj=document.getElementById('ODSN_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	obj.value=SelRowObj.value;

}
			

function Clear_click() {
	var obj="";
	
	/*
	//��Ŀ����
	obj=document.getElementById("ParRef");
	obj.value="";
	
	//��Ŀ����
	obj=document.getElementById("ParRef_Name");
	obj.value="";
	*/
	
	//��¼����
	obj=document.getElementById("Rowid");
	obj.value="";

	//��¼���
	obj=document.getElementById("ChildSub");
	obj.value="";

	//�������	
	obj=document.getElementById("Min");
	obj.value="";
	
	//�������
	obj=document.getElementById("Max");
	obj.value="";	
	
	//�жϽ��(����)	    
	obj=document.getElementById("Value");
	obj.value="";	   
	
	//�Ƿ�����ֵ
	obj=document.getElementById("NaturalValue");
	obj.checked=false;
	
	//�����Ա�
	//obj=document.getElementById("Sex");
	//obj.value="N";	
		SetSex("");
		SetSex("N");	
	
	//��λ����	
	obj=document.getElementById("Unit_DR");
	obj.value="";
	
	//��λ����	
	obj=document.getElementById("Unit_DR_Name");
	obj.value="";	    
	    
}
function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	//var objtbl=document.getElementById('tDHCPEODStdNumCom');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	if (selectrow==CurrentSel) {	    

	    Clear_click();     
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;
	
	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;

// **************  ���Ա����⴦��   ********************
function GetSex() {	
	var obj;

	obj=document.getElementById("Sex_M");
	if (obj){ if (obj.checked) { return "M"; } }
	
	obj=document.getElementById("Sex_F");
	if (obj){ if (obj.checked) { return "F"; } }
	
	obj=document.getElementById("Sex_N");
	if (obj){ if (obj.checked) { return "N"; } }
	
}

function SetSex(value) {
	
	var obj;
	
	if (""==value) {		 		
		obj=document.getElementById("Sex_N");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Sex_M");
		if (obj){ obj.checked=false; } 
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=false; } 
		return false;				
	}	
	if ("M"==value) {
		
		obj=document.getElementById("Sex_M");
		if (obj){ obj.checked=true; }  
	}
	else {
		if ("F"==value) {
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=true; }  
		}
		else {
			if ("N"==value) {
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; } 
			}
			else{
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; }  			
			}
		}
	}  
}
function Sex_click() {
	var obj;

	srcElement = window.event.srcElement;
	
	SetSex("");
	
	obj=srcElement;
	obj.checked=true;
}

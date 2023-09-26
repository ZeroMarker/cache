/// DHCPEODAdviceCom.js
/// ����ʱ��		2006.03.20
/// ������		xuwm
/// ��Ҫ����		�༭��콨��
/// ��Ӧ��		DHC_PE_ODAdvice
/// ����޸�ʱ��	
/// ����޸���	


var CurrentSel=0;

function BodyLoadHandler() {

	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	var obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }	

	iniForm();

	}
function iniForm() {	

	var SelRowObj;
	var obj;
	var iParRef="";
	
	//��ǰ��վ��	
	SelRowObj=document.getElementById('ParRefBox');
	obj=document.getElementById("ParRef");
	if (obj) { 
		obj.value=SelRowObj.value; 
		iParRef=SelRowObj.value;
	}

	if (''==iParRef) {
	    obj=document.getElementById("ParRef_Name");
	    if (obj) { obj.value="δѡ����Ŀ";}
	}
	else{ 
		SelRowObj=document.getElementById('ParRefNameBox');
	    obj=document.getElementById("ParRef_Name");
	    if (SelRowObj) { obj.value=SelRowObj.value; }
	    else { obj.value="��ǰ��Ŀ��û��¼�뽨��"; }
	    ShowCurRecord(1); 
	}
	
	
	SelRowObj=document.getElementById('ODSDRBox');
	obj=document.getElementById("ODS_DR");
	if (SelRowObj) { obj.value=SelRowObj.value; }
}
	

function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

function Update_click() {
	
	var iParRef="", iRowI="", iChildSub="";
	var iODS_DR,iDiagnoseConclusion="", iAdviceDetail="", iUserUpdate_DR="", iDateUpdate="", iIllness="", iCommonIllness="";
    
  
	//վ����� ��Ϊ��
	var obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; } 

	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; } 

	var obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; } 
	
	//��Ӧ��׼
	var obj=document.getElementById("ODS_DR");
	if (obj) { iODS_DR=obj.value; }

	//��Ͻ��� ��Ϊ��
	var obj=document.getElementById("DiagnoseConclusion");
	if (obj) { iDiagnoseConclusion=trim(obj.value); } 
  
	//��������
	var obj=document.getElementById("AdviceDetail");
	if (obj) { iAdviceDetail=obj.value; } 
  
	//����޸��û����� ȡҳ��Ự����
	//var obj=document.getElementById("UserUpdate_DR");
	//if (obj) { iUserUpdate_DR=obj.value; } 
	iUserUpdate_DR=session['LOGON.USERID'];
  
	//���� ȡ������ʱ��
	//var obj=document.getElementById("DateUpdate");
	//if (obj){ iDateUpdate=obj.value; } 
	iDateUpdate="";
  
	//�Ƿ񼲲�
	var obj=document.getElementById("Illness");
	if (obj){
		if (true==obj.checked) { iIllness="1"; }
		else { iIllness="0"; }
	}  
	
	//�Ƿ񳣼���
	var obj=document.getElementById("CommonIllness");
	if (obj){
		if (true==obj.checked) { iCommonIllness="1"; }
		else{ iCommonIllness="0"; }
	}
	
	//����������֤
	if ((""==iParRef)||(""==iAdviceDetail)){
		alert("Please entry all information.");
		//alert(t['01']);
		return false;
	}  

	var Instring=trim(iParRef)+"^"+trim(iRowId)+"^"+trim(iChildSub)
				+"^"+trim(iODS_DR)+"^"+trim(iDiagnoseConclusion)+"^"+trim(iAdviceDetail)+"^"+trim(iUserUpdate_DR)+"^"+trim(iDateUpdate)+"^"+trim(iIllness)+"^"+trim(iCommonIllness);
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if ('0'==flag) {}
	else{
		alert("Insert error.ErrNo="+flag)
		//alert(t['02']+flag);
	}
	
	location.reload(); 
}

function Delete_click() {

	var iParRef="",iChildSub="";
	var obj;
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
	
	if ((""==iParRef)||(""==iChildSub)) {
		alert("Please select the row to be deleted.");
		return false;
	} 
	else{ 
		if (confirm("Are you sure delete it?")) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) { var encmeth=Ins.value; } 
			else {var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub)
			if (flag=='0') {}
			else{ 
				alert("Delete error.ErrNo="+flag); 
			}
			
			location.reload();
		}
	}

}

//��ȡ��Ŀ�б�
function SearchOrderDetail(value) {

	var aiList=value.split("^");
	if (""==value) { return false; }
	else{
		var obj;
		Clear_click;
		//��Ŀ���� ��Ϊ��
		obj=document.getElementById("ParRef");
		obj.value=aiList[2];

		//��Ŀ���� ��Ϊ��
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[0];
	}
}


function Clear_click() {
	
	var obj;
	
	/*    
	
		//���� ��Ŀ���
		obj=document.getElementById("ParRef");
		obj.value="";
		
		//���� ��Ŀ����
		obj=document.getElementById("ParRef_Name");
		obj.value="";	 
	*/
	
	
	//��¼���
	//obj=document.getElementById("Rowid");
	//obj.value="";	
	
	//��¼���� 
	//obj=document.getElementById("Childsub");
	//obj.value="";  
 	
 	/*
 	
	//��Ӧ��׼	
	obj=document.getElementById("ODS_DR");
	obj.value="";	
		
	*/

	//��Ͻ��� 	
	obj=document.getElementById("DiagnoseConclusion");
	obj.value="";
	
	//��������	
	obj=document.getElementById("AdviceDetail");
	obj.value="";		

	//����޸��û�����	
	obj=document.getElementById("UserUpdate_DR");
	obj.value="";	
	
	//����޸��û�����	
	obj=document.getElementById("UserUpdate_DR_Name");
	obj.value="";		

	//����޸�����    
	obj=document.getElementById("DateUpdate");
	obj.value="";	
	
	//�Ƿ񼲲� 
	obj=document.getElementById("Illness");
	obj.checked=false;		
	    
	//�Ƿ񳣼��� 
	obj=document.getElementById("CommonIllness");
	obj.checked=false;	
}	


function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	
	
	//��Ŀ���
	SelRowObj=document.getElementById('ODA_ParRef'+'z'+selectrow);
	if (SelRowObj) {
		//obj=document.getElementById("ParRef");
		//obj.value=SelRowObj.value;	
	}
	else{
		//��ǰ��Ŀ�޽���
		return false;
	}
	
	//��Ŀ����
	SelRowObj=document.getElementById('ODA_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	obj.value=trim(SelRowObj.innerText);

	
	//RowId�����޷����� ������ λ��Ԥ��
	//var obj=document.getElementById("Rowid");  
	//if (obj) { iRowid=obj.value; }
	iRowid=""
	
	//��¼����
	SelRowObj=document.getElementById('ODA_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");  
	obj.value=SelRowObj.value;
	
	//��Ӧ��׼
	SelRowObj=document.getElementById('ODA_ODS_DR'+'z'+selectrow);
	obj=document.getElementById("ODS_DR");
	obj.value=trim(SelRowObj.value);
         
	//��Ͻ��� 
	SelRowObj=document.getElementById('ODA_DiagnoseConclusion'+'z'+selectrow);
	obj=document.getElementById("DiagnoseConclusion");
	obj.value=trim(SelRowObj.innerText);
    
	//��������
	SelRowObj=document.getElementById('ODA_AdviceDetail'+'z'+selectrow);
	obj=document.getElementById("AdviceDetail");
	obj.value=trim(SelRowObj.innerText);
    
	//����޸��û�����  
	SelRowObj=document.getElementById('ODA_UserUpdate_DR'+'z'+selectrow);
	obj=document.getElementById("UserUpdate_DR");
	obj.value=SelRowObj.value;

	//����޸��û�����
	SelRowObj=document.getElementById('ODA_UserUpdate_DR_Name'+'z'+selectrow);
	obj=document.getElementById("UserUpdate_DR_Name");
	obj.value=trim(SelRowObj.value);

	//����޸ĸ�������
	SelRowObj=document.getElementById('ODA_DateUpdate'+'z'+selectrow);
	obj=document.getElementById("DateUpdate");
	obj.value=trim(SelRowObj.innerText);

	//�Ƿ񼲲� 
	SelRowObj=document.getElementById('ODA_Illness'+'z'+selectrow);
	obj=document.getElementById("Illness");
	obj.checked=SelRowObj.checked;

	//�Ƿ񳣼���
	SelRowObj=document.getElementById('ODA_CommonIllness'+'z'+selectrow);
	obj=document.getElementById("CommonIllness");
	obj.checked=SelRowObj.checked;
 
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	//var objtbl=document.getElementById('tDHCPEODAdviceCom');
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;

	//if (selectrow==CurrentSel)
	//{	    
	//	Clear_click()
	//	CurrentSel=0
	//	return;
	//}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);
}

document.body.onload = BodyLoadHandler;


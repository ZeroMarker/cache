/// DHCPEODDDCom.js
/// ����ʱ��		2006.03.21
/// ������		xuwm 
/// ��Ҫ����		ϸ�������ֵ�(ϸ����ӱ�)
/// ��Ӧ��		DHC_PE_ODDD
/// ����޸�ʱ��	
/// ����޸���	

var CurrentSel=0
var IsChangeParRef="1";  //�Ƿ���ĵ�ǰ��Ŀ
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
	
	ShowCurRecord(1);
	
	}
function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

//��ȡϸ���
function SearchOrderDetail(value) {

	if ("1"==IsChangeParRef) {	 
		//����ı䵱ǰ��Ŀ
		var aiList=value.split("^");
		if (""==value){ return false; }
		else{
			var obj;
		
			Clear_click();
		
			//��Ŀ(ϸ)����
			obj=document.getElementById("ParRef");
			obj.value=aiList[1];
		
			//��Ŀ(ϸ)����
			obj=document.getElementById("ParRef_Name");
			obj.value=aiList[0];
  		}
	}
	else {
		//������ı䵱ǰ��Ŀ
		//do nothing
	}

}

function Update_click(){
	 
	var iParRef="", iRowId="", iChildSub="";
	var iDesc="", iUserUpdateDR="", iDateUpdate="";

	//��Ŀ(ϸ)����
	var obj=document.getElementById("ParRef");  
	if (obj) { iParRef=obj.value; }

	//RowId�����޷����� ������ λ��Ԥ��
	//var obj=document.getElementById("Rowid");  
	//if (obj){iRowid=obj.value}
	iRowid="";
  
	//ϸ�������ֵ����  
	var obj=document.getElementById("ChildSub");  
	if (obj) { iChildSub=obj.value; }
  
	//�����ֵ�����
	var obj=document.getElementById("Desc");
	if (obj) { iDesc=obj.value; } 

	//����޸��û�����	ȡ��ҳ�ϵ�(�Ự session )�û����� 
	//var obj=document.getElementById("UserUpdateDR");
	//if (obj){iUserUpdateDR=obj.value} 
	iUserUpdateDR=session['LOGON.USERID'];
  
	//����޸�����	ȡ����������
	//var obj=document.getElementById("DateUpdate");
	//if (obj){iDateUpdate=obj.value} 
	iDateUpdate='';
  
	//����������֤
 	if (""==iDesc){
		alert("Please entry all information.");
		//alert(t['01']);
		return false
	}  

	var Instring=trim(iParRef)+"^"+trim(iRowId)+"^"+trim(iChildSub)+"^"+trim(iDesc)+"^"+trim(iUserUpdateDR)+"^"+trim(iDateUpdate);
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);

 	if ('0'==flag) {}
	else{
		alert("Insert error.ErrNo="+flag)
		//alert(t['02']+flag);
	}
	
	location.reload(); 
}

function Delete_click(){

	var iParRef="", iChildSub="";
	var obj;
	
	//��Ŀ(ϸ)����
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	//ϸ�������ֵ����  
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
	if ((""==iParRef)||(""==iChildSub)) {
		alert("Please select the row to be deleted.");
		return false;
	}
	else { 
		if (confirm("Are you sure delete it?")){
			var Ins=document.getElementById('DeleteBox');
			if (Ins) { var encmeth=Ins.value; } 
			else { var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub)
			if ('0'==flag) {}
			else{ alert("Delete error.ErrNo="+flag); }
			location.reload();
		}
	}
   
}


function ShowCurRecord(CurRecord) {

	var selectrow=CurRecord;
	
	var SelRowObj;
	var obj;

	//�����ֵ�����
	SelRowObj=document.getElementById('DD_Desc'+'z'+selectrow);
	obj=document.getElementById("Desc");
	obj.value=trim(SelRowObj.innerText);
	

	//����޸��û�����
	SelRowObj=document.getElementById('DD_UserUpdate_DR_Name'+'z'+selectrow);
	obj=document.getElementById("UserUpdate_DR_Name");
	obj.value=trim(SelRowObj.Value);		
  
	//����޸��û�����
	SelRowObj=document.getElementById('DD_UserUpdate_DR'+'z'+selectrow);	
	obj=document.getElementById("UserUpdate_DR");	
	obj.value=SelRowObj.Value;
	
		
	//��Ŀ����	
	SelRowObj=document.getElementById('DD_ParRef'+'z'+selectrow);
	obj=document.getElementById("ParRef");
	obj.value=SelRowObj.value;  

	//��Ŀ����
	SelRowObj=document.getElementById('DD_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	obj.value=trim(SelRowObj.innerText);		


	//����޸�����
	SelRowObj=document.getElementById('DD_DateUpdate'+'z'+selectrow);
	obj=document.getElementById("DateUpdate");
	obj.value=SelRowObj.value;

	//�ֵ���
	SelRowObj=document.getElementById('DD_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=SelRowObj.value;

	//�ֵ����
	SelRowObj=document.getElementById('DD_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	obj.value=SelRowObj.value;
	
	SearchOrderDetailCom_click();
}
			
function Clear_click() {
		
	var obj;
	
	obj=document.getElementById("Rowid");
	obj.value="";

	//��Ŀ����	
	obj=document.getElementById("ParRef");
	obj.value="";

	//��Ŀ����	    			    
	obj=document.getElementById("ParRef_Name");
	obj.value="";	
	
	//�ֵ���
	obj=document.getElementById("ChildSub");
	obj.value="";

	//�����ֵ�����
	obj=document.getElementById("Desc");
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
	 	
	    
}


function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	//var objtbl=document.getElementById('tDHCPEODDDCom');
	
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

document.body.onload = BodyLoadHandler;

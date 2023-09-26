/// DHCPEOrderDetailCom.js
/// ����ʱ��	2006.03.20
/// ������	xuwm 
/// ��Ҫ����	ϸ�����Ϣ�༭
/// ��Ӧ��	DHC_PE_OrderDetail
/// ����޸�ʱ��	
/// ����޸���	

var CurrentSel=0;
var FIsValidCode=false;
var FOrderdetaiName="";

function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }		

	obj=document.getElementById("btnEditExpression");
	if (obj){ obj.onclick=EditExpression_click; }
	
	//��Ŀ����
	obj=document.getElementById("Type_T");
	if (obj){ obj.onclick=Type_click; }
	obj=document.getElementById("Type_N");
	if (obj){ obj.onclick=Type_click; }
	obj=document.getElementById("Type_C");
	if (obj){ obj.onclick=Type_click; }
	obj=document.getElementById("Type_S");
	if (obj){ obj.onclick=Type_click; }	
	obj=document.getElementById("Type_A");
	if (obj){ obj.onclick=Type_click; }	
	//�Ա�����
	obj=document.getElementById("Sex_F");
	if (obj){ obj.onclick=Sex_click; }
	obj=document.getElementById("Sex_M");
	if (obj){ obj.onclick=Sex_click; }
	obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }	
	
	obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }		

	obj=document.getElementById('Code');
	if (obj) {obj.onkeydown = Code_keydown;}
	
	obj=document.getElementById('Sequence');
	if (obj) {obj.onkeydown = Sequence_keydown;}
		
	iniForm();

	var obj=document.getElementById("OD_Descz1");
	if (obj) {obj.click();}	
}  

// **************  ---------------   ********************
 
function iniForm() {	

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('ParRefBox');
	obj=document.getElementById("ParRef");
	obj.value=SelRowObj.value;

	if (''==SelRowObj.value){
	    obj=document.getElementById("ParRefName");
	    //obj.value="δѡ��վ��";
	    obj.value=t["Inf 01"];
	}
	else{
		
		SelRowObj=document.getElementById('ParRefNameBox');
	    obj=document.getElementById("ParRefName");
	    obj.value=SelRowObj.value; 		
		ShowCurRecord(1);
	}
	
	obj=document.getElementById("LabtrakCode");
	if (obj) { obj.disabled=true; }

}
	
function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (null == m) ? "" : m[1];
}

function IsInt(IntValue) 
{ 
	var m,r;     

	IntValue=IntValue.toString();
	if(""==trim(IntValue)) { return false; } 

	//������ 
    var r=IntValue.match(/^\+?[0-9]*[1-9][0-9]*$/); 
    if(r==null) { return false; } 
    else { return true; } 
} 

function Clear_click() {     
  
	var obj;
	
	//��Ŀ����
	obj=document.getElementById("Code");
	if (obj) { obj.value=""; }
	if (obj) {obj.className=''; }	
			
	//��Ŀ����
	obj=document.getElementById("Desc");
	if (obj) { obj.value=""; }
		
	//��Ŀ���� 1˵���� 2��ֵ�� 3������
	obj=document.getElementById("Type");
	if (obj) { obj.value="T"; }
		SetType("");
		SetType("T");	
		
	//���ʽ
	obj=document.getElementById("Expression");
	if (obj) { obj.value=""; }	
	obj=document.getElementById("EditExpression");
	if (obj) { obj.value=""; }	
	
	//��λ
	obj=document.getElementById("Unit");
	if (obj) { obj.value=""; }
			
	//�Ƿ����С�� ���� 1
	obj=document.getElementById("Summary");
	if (obj) { obj.checked="Y"; }
	  	//SetSummary("");
		//SetSummary("Y");
		
	//�Ƿ��н����� ���� 1
	obj=document.getElementById("Advice");
	if (obj) { obj.checked=false; }
		
	//˵��
	obj=document.getElementById("Explain");
	if (obj) { obj.value=""; }
		
	//˳��� ����
	//obj=document.getElementById("Sequence");
	//if (obj) { obj.value="0"; }	
	//obj.className="";
	
	//�����Ա� M-��,F-Ů,N-����
	obj=document.getElementById("Sex");
	if (obj) { obj.value="N"; }
		SetSex("");
		SetSex("N");

	//������� 
	obj=document.getElementById("LabtrakCode");
	if (obj) { obj.value=""; }
	
		
	//Ӣ�Ķ���
	obj=document.getElementById("ZhToEng");
	if (obj) { obj.value=""; }

	//��¼���
	obj=document.getElementById("ChildSub");
	if (obj) { obj.value=""; }

	/*
		//����ı䵱ǰ��վ��
		
		//վ����		    
		obj=document.getElementById("ParRef");
		if (obj) { obj.value=""; }
		
		//վ������
		obj=document.getElementById("ParRefName");
		if (obj) { obj.value=""; }
	*/
		
	obj=document.getElementById("Delete");
	if (obj){ obj.disabled=false; }
		
	obj=document.getElementById("Update");
	if (obj){ obj.disabled=false; }

}


// *****************************************************************************

function EditExpression_click() {
	var obj;
	var Expression="";
	//���ʽ
	obj=document.getElementById("EditExpression");
	if (obj){ iExpression=obj.value; }  
	Expression=IsValidExpression(iExpression);
	if (""==Expression) {
		//alert("��Ч��ʽ");
		alert(t["Err 02"]);
	}else{
		//alert("���㹫ʽ��֤�ɹ�");
		alert(t["Inf 02"]);	
	}
}

function Update_click() {
	
	var eSrc=window.event.srcElement;
	if (eSrc && eSrc.disabled) { return false; }	
	
	var iParRef="", iRowId="", iChildSub="";
	var iCode="", iDesc="", iType="", iExpression="", iUnit="", iSummary="", iAdvice="", iExplain="", iSequence="", iSex="",iZhToEng=""
	var iSpecialNature="";
	var obj;
	
	//��Ŀ����
	obj=document.getElementById("Code");
	if (obj){ iCode=obj.value; }	
	
	//��Ŀ����
	obj=document.getElementById("Desc");
	if (obj){ iDesc=obj.value; }  
  
	//��Ŀ���� 1˵���� 2��ֵ�� 3������
	//obj=document.getElementById("Type");
	//if (obj){ iType=obj.value; }  
	iType = GetType();

	//���ʽ
	obj=document.getElementById("EditExpression");
	if (obj){ iExpression=IsValidExpression(obj.value); }  

	//��λ
	obj=document.getElementById("Unit");
	if (obj){ iUnit=obj.value; }  
	
	//�Ƿ����С�� ���� 1
	obj=document.getElementById("Summary");
	if (obj){
		if (obj.checked==true){ iSummary="Y"; }
		else{ iSummary="N"; }
	}
    
	//�Ƿ��н����� ���� 1
	obj=document.getElementById("Advice");
	if (obj) {
		if (obj.checked==true) { iAdvice="Y"; }
		else{ iAdvice="N"; }
	}

	//˵��
	obj=document.getElementById("Explain");
	if (obj){ iExplain=obj.value; }  
	
	//˳��� ����
	obj=document.getElementById("Sequence");  
	if (obj){ iSequence=obj.value; }  
	if (!(IsSequence(iSequence))) { return false; }

	//�����Ա� M-��,F-Ů,N-���� 
	//obj=document.getElementById("Sex");  
	//if (obj){ iSex=obj.value; }
		iSex=GetSex(); 
    obj=document.getElementById("NoPrint");    //add by zl 20100120 start
     if (obj){
		if (obj.checked==true){ iNoPrint="Y"; }
		else{ iNoPrint="N"; }
	} 
	// Ӣ�Ķ��� 
	obj=document.getElementById("ZhToEng");
	if (obj){ iZhToEng=obj.value; }
	
	//վ����
	obj=document.getElementById("ParRef");  
	if (obj){ iParRef=obj.value; }
  	
  	//��¼���
	//obj=document.getElementById("Rowid");  
	//if (obj){iRowid=obj.value}
	iRowid=""
	
	//վ����
	obj=document.getElementById("ChildSub");  
	if (obj){ iChildSub=obj.value; }
	
	//��֤?�����Ƿ���Ч
	//if (!(IsValidCode())) { return false };	
	
	//��Ŀ���ơ�ϸ����벻Ϊ��
	if ((""==iDesc)||(""==iCode)){
		alert(t['01']);
		//websys_setfoucs(Desc);
		return false;
	} 

	/*//���Ʋ�Ϊ��
	if (""==iDesc){
		//alert("Please entry all information.");
		alert(t['01']);
		websys_setfoucs(Desc);
		return false;
	}  */
	
	//�������Ǽ���ʱ?Ҫ�й�ʽ
	if ("C"==iType) {
		if (";"==iExpression) { 
			//alert("��Ч��ʽ");
			alert(t["Err 02"]);
			return false; 
		}
	}
  
	if (""==iParRef){ 
		//alert("��Чվ��");
		//alert(t['Err 01']);
		return false;
	}
	
	obj=document.getElementById("SpecialNature");
	if (obj) {
		iSpecialNature=obj.value;	
	}
	
	var Instring = trim(iParRef)
				+"^"+trim(iRowId)
				+"^"+trim(iChildSub)
				+"^"+trim(iCode)
				+"^"+trim(iDesc)
				+"^"+trim(iType)
				+"^"+trim(iExpression)
				+"^"+trim(iUnit)
				+"^"+trim(iSummary)
				+"^"+trim(iAdvice)
				+"^"+trim(iExplain)
				+"^"+trim(iSequence)
				+"^"+trim(iSex)
				+"^"+trim(iNoPrint)  
				+"^"+trim(iZhToEng) 
				+"^"+trim(iSpecialNature)
				;
	//alert(Instring)
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);

		if ('0'==flag) { location.reload(); }
		else if ('Err 03'==flag) {
			// �����ѱ�������Ŀʹ��
			alert(t['Err 03']);
		}		
		else{
			//alert("Insert error.ErrNo="+flag)
			alert(t['02']+flag);
		}	

}

function Delete_click() {
	
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }	
		
	var iParRef="", iChildSub="";
	var obj;
	
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
	
	if ((""==iParRef)||(""==iChildSub)) {
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false
	} 
	else{
		//if (confirm("Are you sure delete it?")) {
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) { var encmeth=Ins.value; } 
			else { var encmeth=''; };
			
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub)
			
			if ('0'==flag) {}
			else if ('Err 07'==flag){ 
				alert("ҽ����ϸ���ж��չ�ϵ,����ɾ�����չ�ϵ"); 
				//alert(t['Err 07']);
			}
			else { 
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

			obj.value=trim(SelRowObj.value);
			return obj;
	}

}

function ShowCurRecord(CurRecord) {

	var selectrow=CurRecord;
	var obj;

	//ϸ����� Ψһ
	FromTableToItem("Code","OD_Code",selectrow);  

	//��Ŀ����	
	FromTableToItem("Desc","OD_Desc",selectrow); 

    //�Ƿ��ӡ
	FromTableToItem("NoPrint","OD_NoPrint",selectrow);      //add by zl 20100120
	FromTableToItem("ZhToEng","OD_ZhToEn",selectrow); 

	//��Ŀ���� 1˵����?2��ֵ��?3������
	obj=FromTableToItem("Type","OD_Type",selectrow); 
	SetType("");		
	if (obj) { SetType(obj.value); }
		
	//���ʽ
	obj=FromTableToItem("EditExpression","OD_Expression",selectrow);
	if (obj) { 
		//var aiList=obj.value.split(";");
		//obj.value=trim(aiList[0]); 
		
		var strtmp=obj.value;
		//strtmp=strtmp.replace(/\[/g,"");
		//strtmp=strtmp.replace(/\]/g,"");
		obj.value=strtmp;		
	}

	//��λ
	FromTableToItem("Unit","OD_Unit",selectrow); 
 
	//�Ƿ����С�� ���� 1
	FromTableToItem("Summary","OD_Summary",selectrow); 

	//�Ƿ��н����� ���� 1
	FromTableToItem("Advice","OD_Advice",selectrow);

	//˵��
	FromTableToItem("Explain","OD_Explain",selectrow);

	//˳��� ����
	//obj=FromTableToItem("Sequence","OD_Sequence",selectrow);
	//if (obj) { obj.className=""; }

	//��¼���
	obj=FromTableToItem("LabtrakCode","OD_LabtrakCode",selectrow);
	if (obj) {
		if (""==obj.value) {
			obj=document.getElementById("Delete");
			if (obj){ obj.disabled=false; }
		
			obj=document.getElementById("Update");
			if (obj){ obj.disabled=false; }
		}else {
			obj=document.getElementById("Delete");
			if (obj){ obj.disabled=true; }
		
			obj=document.getElementById("Update");
			//if (obj){ obj.disabled=true; }
		}
	}
	
	//�����Ա� M-��,F-Ů,N-����
	obj=FromTableToItem("Sex","OD_Sex",selectrow);
	SetSex("");	
	if (obj) { SetSex(trim(obj.value)); }

	//վ����
	FromTableToItem("ParRef","OD_ParRef",selectrow);
  
	//վ������
	FromTableToItem("ParRefName","OD_ParRef_Name",selectrow);


	//RowId ������ʽ�� OD_ParRef||OD_ChildSub ��˫�����޷�?�˲����޷��� 
	//FromTableToItem("RowId","OD_RowId",selectrow);

	//��¼���
	FromTableToItem("ChildSub","OD_ChildSub",selectrow);
	
	//����ӡ
    FromTableToItem("NoPrint","TNoPrint",selectrow);
    
	//���ⷶΧ
	FromTableToItem("SpecialNature","TSpecialNature",selectrow);

}	

/*
function ShowCurRecord(selectrow) {
	
	var SelRowObj;
	var obj;
	
	//ϸ����� Ψһ
	SelRowObj=document.getElementById('OD_Code'+'z'+selectrow);
	obj=document.getElementById("Code");
	obj.value=trim(SelRowObj.innerText);
	obj.className='';
	
	
	//��Ŀ����	 
	SelRowObj=document.getElementById('OD_Desc'+'z'+selectrow);	
	obj=document.getElementById("Desc");
	obj.value=trim(SelRowObj.innerText);

	//��Ŀ���� 1˵����?2��ֵ��?3������
	SelRowObj=document.getElementById('OD_Type'+'z'+selectrow);
	obj=document.getElementById("Type");
	obj.value=trim(SelRowObj.innerText);
	
		SetType("");		
		SetType(trim(SelRowObj.innerText));
		
	//���ʽ
	SelRowObj=document.getElementById('OD_Expression'+'z'+selectrow);
	var aiList=SelRowObj.value.split(";");
	obj=document.getElementById("EditExpression");
	obj.value=trim(aiList[0]);

	//��λ
	SelRowObj=document.getElementById('OD_Unit'+'z'+selectrow);
	obj=document.getElementById("Unit");
	obj.value=trim(SelRowObj.innerText);	
		   
	//�Ƿ����С�� ���� 1
	SelRowObj=document.getElementById('OD_Summary'+'z'+selectrow);
	obj=document.getElementById("Summary");
	obj.checked=SelRowObj.checked;
    
	//�Ƿ��н����� ���� 1
	SelRowObj=document.getElementById('OD_Advice'+'z'+selectrow);
	obj=document.getElementById("Advice");
	obj.checked=SelRowObj.checked;

	//˵��
	SelRowObj=document.getElementById('OD_Explain'+'z'+selectrow);
	obj=document.getElementById("Explain");
	obj.value=trim(SelRowObj.innerText);

	//˳��� ����
	SelRowObj=document.getElementById('OD_Sequence'+'z'+selectrow);
	obj=document.getElementById("Sequence");
	obj.value=trim(SelRowObj.innerText);
	obj.className="";
	
	//�����Ա� M-��,F-Ů,N-����
	SelRowObj=document.getElementById('OD_Sex'+'z'+selectrow);
	obj=document.getElementById("Sex");
	obj.value=trim(SelRowObj.innerText);
		SetSex("");	
		SetSex(trim(SelRowObj.innerText));

		//վ����
		SelRowObj=document.getElementById('OD_ParRef'+'z'+selectrow);
		obj=document.getElementById("ParRef");
		obj.value=SelRowObj.value;
  
		//վ������
		SelRowObj=document.getElementById('OD_ParRef_Name'+'z'+selectrow);
		obj=document.getElementById("ParRefName");
		obj.value=trim(SelRowObj.value);  

	//RowId ������ʽ�� OD_ParRef||OD_ChildSub ��˫�����޷�?�˲����޷��� 
	//SelRowObj=document.getElementById('OD_RowId'+'z'+selectrow);
	//obj=document.getElementById("RowId");
	//obj.value=SelRowObj.value;

	//��¼���
	SelRowObj=document.getElementById('OD_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	obj.value=SelRowObj.value;	

}	

*/

function Sequence_keydown(e) {
	var key;
	key=websys_getKey(e);
	if ((key==13)||(key==9)) {
		IsSequence()
	}else{
	obj=document.getElementById('Sequence');
	if (obj) { obj.className=''; }
	}

}

function Code_keydown(e) {
	var key;
	key=websys_getKey(e);
	
	if ((key==13)||(key==9)) {
		IsValidCode()
	}else{
		obj=document.getElementById('Code');
		if (obj) { obj.className=''; }
	}

}
// **********************************************************
//��֤˳����Ƿ���ȷ 
function IsSequence(Sequence) {
	if ((""==Sequence)||("0"==Sequence)) { return true; }
	if (IsInt(Sequence)) { return true; }
	else{		
		obj=document.getElementById("Sequence");
		obj.className='clsInvalid';
		websys_setfocus('Sequence');
		//alert("��Ч˳���");
		alert(t["Err 06"]);
		return false;
	}

}
/*
// Code�Ƿ���Ч?δʹ��?
function IsValidCode() {
	
	var iParRef,iCode,iChildSub;
	var obj;

	obj=document.getElementById('ChildSub');
	if (obj) { iChildSub=obj.value; } else { return false }
			
	obj=document.getElementById('ParRef');
	if (obj) { iParRef=obj.value; } else { return false};
		
	obj=document.getElementById('Code');
	if (obj) { iCode=obj.value } 
	
	if (iCode!='') {		
		var Ins=document.getElementById('IsValidCode');
		if (Ins) {var encmeth=Ins.value} else {var encmeth=''};			
		var flag=cspRunServerMethod(encmeth,'','',iParRef,iCode);

		
		//����δʹ�� ��Ч
		if (''==flag) { 
			FIsValidCode=true;
			return true;
		}

		if (iChildSub!=flag) {
			FIsValidCode=false;
			obj.className='clsInvalid';	
			//alert("��Ŀ������ʹ��");
			alert(t["Err 03"]);
			websys_setfocus('Code');
			return false;
		}else{
			FIsValidCode=true;
			return true;
		}

	}
	else {
		obj.className='clsInvalid';
		FIsValidCode=true;
		//alert("��Ŀ���벻����Ϊ��");
		alert(t["Err 04"]);
		websys_setfocus('Code');
		return false;
	}
}
*/
// ********************************************************************
function IsValidExpression(aExpression) {
	return aExpression;
	var strExpression="";
	var strLine="";
	var iLoop=0;
	
	var iValue="",iOperator="",iCode="";	
	
	var ReadStatus=""; //��ȡ����   V ��ǰ��ȡ���� O ��ǰ��ȡ�������� P ��ǰ��ȡ������
	var obj;
	
	strExpression=aExpression+';';

	for (iLoop=0;iLoop<strExpression.length;iLoop++) {
		switch (strExpression.charAt(iLoop)){
			case "+":{
				Operator="+";
				ReadStatus="O";	
				break;				
			}
			case "-":{
				Operator="-";
				ReadStatus="O";	
				break;				
			}
			case "*":{
				Operator="*"
				ReadStatus="O";	
				break;			
			}
			case "/":{
				Operator="/";
				ReadStatus="O";			
				break;
			}
			case "(":{
				Operator="(";
				ReadStatus="PB";			
				break;
			}
			case ")":{
				Operator=")";
				ReadStatus="PE";			
				break;
			}
			
			case ";":{
				ReadStatus="F";
				break;
			}
			
			default: {
				ReadStatus="V";		 
				iValue=iValue+strExpression.charAt(iLoop);
				break;
			}

		}
		//��ǰ�ַ�Ϊ������
		if ("O"==ReadStatus) {				
			iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode+Operator;
			iValue="";	
			Operator="";	
		}
		
		//
		if ("PB"==ReadStatus) {
			strLine=strLine+Operator;
			iValue="";
			Operator="";
		}
		
		//
		if ("PE"==ReadStatus) {

			iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode+Operator;
			iValue="";
			Operator="";
		}
		//������		
		if ("F"==ReadStatus) {

			iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode;
			
			if (""==strLine) { return ""; }			
			//strLine=strExpression+strLine
		}
	}

	obj=document.getElementById("Expression");
	if (obj){ obj.value=strLine; }

	return strLine;
}

// ******************************************************************
function GetOrderdetailCode(aValue) {
	
 	if (""==aValue) { return aValue;}

	var objtbl;
	var SelRowObj;
	var obj;
	var iCode="";
	var iDesc=""

	objtbl=document.getElementById('tDHCPEOrderDetailCom');
	if (objtbl) { var rows=objtbl.rows.length; }

	for (var iLoop=1;iLoop<rows;iLoop++) {
		iCode="";
		iDesc="";
		FOrderdetaiName="";
		SelRowObj=document.getElementById('OD_Code'+'z'+iLoop);		
		if (SelRowObj && ""!=SelRowObj.value) { iCode=SelRowObj.innerText; }
		else { continue; }

		SelRowObj=document.getElementById('OD_Desc'+'z'+iLoop);		
		if (SelRowObj && ""!=SelRowObj.value) { iDesc=SelRowObj.innerText; }

		if (iCode==aValue) {
			iCode="["+iCode+"]";
			FOrderdetaiName=iDesc;
			return iCode;
		}
	}

	//δ�ҵ�����?���˳�
	return aValue;		

}

// ***********************************************************************
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

	if (selectrow==CurrentSel){
		
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
	var iSex="";
	obj=document.getElementById('Sex_M');
	if (obj){ if (obj.checked) { iSex='M'; } }
	
	obj=document.getElementById('Sex_F');
	if (obj){ if (obj.checked) { iSex='F'; } }
	
	obj=document.getElementById('Sex_N');
	if (obj){ if (obj.checked) { iSex='N'; } }
	
	if (''==iSex) { iSex='N'; }
	
	return iSex;
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

// **************  ���������⴦��   ********************
function GetType() {	
	var obj;
	
	//T˵���� 
	obj=document.getElementById("Type_T"); 
	if (obj){ if (obj.checked) { return "T"; } }
	
	//N��ֵ��
	obj=document.getElementById("Type_N");
	if (obj){ if (obj.checked) { return "N"; } }
	
	//C������
	obj=document.getElementById("Type_C");
	if (obj){ if (obj.checked) { return "C"; } }
	
	//Sѡ����
	obj=document.getElementById("Type_S");
	if (obj){ if (obj.checked) { return "S"; } }	
	
	//A����
	obj=document.getElementById("Type_A");
	if (obj){ if (obj.checked) { return "A"; } }
	
	return "T"; // Ĭ������
}

function SetType(value) {
	
	var obj;
	
	//���ر��ʽ�����
	document.all["EditExpression"].disabled=true; 
	document.all["cEditExpression"].disabled=true; 
	document.all["btnEditExpression"].disabled=true; 			
	
	if(document.all["EditExpression"].disabled){
	    document.getElementById("cEditExpression").style.color = "gray";
		document.getElementById("btnEditExpression").style.color = "gray";
	}

	
	if (""==value) {
		// 1 ˵����
		obj=document.getElementById("Type_T");
		if (obj){ obj.checked=false; }
		// 2 ��ֵ��
		obj=document.getElementById("Type_N");
		if (obj){ obj.checked=false; } 
		// 3 ������
		obj=document.getElementById("Type_C");
		if (obj){ obj.checked=false; } 
		// 4 ѡ����
		obj=document.getElementById("Type_S");
		if (obj){ obj.checked=false; } 
		// 4 ����
		obj=document.getElementById("Type_A");
		if (obj){ obj.checked=false; } 
		return false;				
	}
	
	//2��ֵ�� 
	obj=document.getElementById("Type_N");	
	if ("N"==value && obj) {		
		obj.checked=true;
		return true;
	}

	//4ѡ����
	obj=document.getElementById("Type_S");
	if ("S"==value && obj) {
		obj.checked=true; 
		return true;
	}
	//4����
	obj=document.getElementById("Type_A");
	if ("A"==value && obj) {
		obj.checked=true; 
		return true;
	}
	//1˵����	Ĭ������
	obj=document.getElementById("Type_T");
	if ("T"==value && obj) {
		obj.checked=true; 
		return true;
	} 
	
	//3������
	obj=document.getElementById("Type_C");	
	if ("C"==value && obj) {
		document.all["EditExpression"].disabled=false;
		document.all["cEditExpression"].disabled=false;
		document.all["btnEditExpression"].disabled=false;
		obj.checked=true;
		if(!(document.all["EditExpression"].disabled)){
		document.getElementById("cEditExpression").style.color = "black";
		document.getElementById("btnEditExpression").style.color = "blue";
		}

		
		return true;
	}		
}

function Type_click() {
	var obj;

	srcElement = window.event.srcElement;
	SetType("");
	obj=srcElement;
	obj.checked=true;

	obj=document.getElementById("Type_C");
	if (obj.checked){ 
		SetType("C");
	}	
	
	
}


// *******************   ������ ��δʹ�õĺ���   ***********************************
/*
//����վ��
function SearchStation(value) {
 
		//����ı䵱ǰ��վ��	
		var aiList=value.split("^");
		if (""==value){ return false; }
		else{	
			var obj;
			
			Clear_click();
			
			//վ����
			obj=document.getElementById("ParRef");
			obj.value=aiList[2];
			
			//վ������
			obj=document.getElementById("ParRefName");
			obj.value=aiList[0];
		}
	
}
// ��ȡ��λ
function SearchUOM(value) {
		
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
	
		//��Ŀ
		obj=document.getElementById("Unit_DR_Name");
		obj.value=aiList[0];
		
		//��Ŀ
		obj=document.getElementById("Unit_DR");
		obj.value=aiList[2];
		
	}
}
*/
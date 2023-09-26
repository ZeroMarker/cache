/// DHCPEODStandardCom.js
/// ����ʱ��		2006.03.21
/// ������		xuwm 
/// ��Ҫ����		����׼(DHC_PE_ OrderDetail���ӱ�)
/// ��Ӧ��		DHC_PE_ODStandard
/// ����޸�ʱ��	
/// ����޸���	

var CurrentSel=0
var FOrderDetailType=""	//��ǰ��Ŀ����

function BodyLoadHandler() {
   
	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click;}

	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click;}
	
    obj=document.getElementById("TemplateSet");
	if (obj){ obj.onclick=TemplateSet_click;}
	
	  
	
	//�����Ա� 
	obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }
	obj=document.getElementById("Sex_M");
	if (obj){ obj.onclick=Sex_click; }	
	obj=document.getElementById("Sex_F");
	if (obj){ obj.onclick=Sex_click; }	

	obj=document.getElementById('AgeMin');
	if (obj) {obj.onkeydown = keydown;}

	obj=document.getElementById('AgeMax');
	if (obj) {obj.onkeydown = keydown;}
	
	obj=document.getElementById('Min');
	if (obj) {obj.onkeydown = keydown;}	
	
	obj=document.getElementById('Max');
	if (obj) {obj.onkeydown = keydown;}
	iniForm();
}

function iniForm() {
		
	var SelRowObj;
	var obj;
	
	//��Ŀ����
	SelRowObj=document.getElementById('OrderDetailTypeBox');
	if (SelRowObj) { 
		FOrderDetailType=SelRowObj.value; 
		SetOrderDetailType(FOrderDetailType);
	}

	Clear_click();

	//��ȡ��ǰҳ�游��Ŀ���
	//SelRowObj=document.getElementById('ParRefBox');
	//obj=document.getElementById("ParRef");
	//if (SelRowObj && obj) {
	//	obj.value=SelRowObj.value;
	//}

	//if (''==SelRowObj.value){
	//    obj=document.getElementById("ParRef_Name");
	//    obj.value="��ǰվ��û����Ŀ";  	    		
	//}
	//else{

		//SelRowObj=document.getElementById('ParRefNameBox');
	    //obj=document.getElementById("ParRef_Name");
	    //if (SelRowObj && obj) {
		//    obj.value=SelRowObj.value; 
	    //}

		//��ʾ��һ����¼	
		//ShowCurRecord(1);
		
	//}

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

//��֤�Ƿ�Ϊ��ȷ����
function IsValidAge(Value) {
	
	if(""==trim(Value) || "0"==Value) { 
		//����Ϊ��
		return true; 	
	}
	if (!(IsFloat(Value))) { return false; }
	
	if ((Value>0)&&(Value<120)) {
		return true; 
	}
}

// ************************************************************************

function keydown(e) {	

	var key;
	key=websys_getKey(e);
	
	if ((key==13)||(key==9)) {
	}else{
		var eSrc=window.event.srcElement;
		if (eSrc) { eSrc.className=''; }	
	}

}

function TemplateSet_click(){
	var obj;
   obj=document.getElementById("RowId");
	if (obj){var ID=obj.value; }
	else{return false;}
	if (ID=="") 
	{
		alert("����ѡ��Ҫά��ģ���ϸ��ѡ���¼");
		return false;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPETemplateSet&TextValID="+ID;
	var wwidth=300;
	var wheight=700;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	return false;    //LIKE��ʽ�ķ���ֵΪfalse
	                 //�˵�������ʽ�ķ���ֵΪTRUE        
}
	
	
	
function Update_click() { 
         
	var iParRef="", iRowId="", iChildSub="";
	var iSex="", iAgeMin="", iAgeMax="", iTextVal="",iUnit="",iMin="",iMax="",iNaturalValue=""
		iTemplate="" 
	var iSummary="",iEyeSee=""
	var iHDValue="N";	
	var iNoPrint="N";
	var obj;
	
	obj=document.getElementById("ParRef");  
	if (obj) { iParRef=obj.value; }

	//RowId�����޷����� ������ λ��Ԥ��
	//var obj=document.getElementById("Rowid");  
	//if (obj) { iRowid=obj.value; }
	iRowid="";
	  
	//��׼���
	obj=document.getElementById("ChildSub");  
	if (obj) { iChildSub=obj.value; }
			
	//�Ա�
	//obj=document.getElementById("Sex");  
	//if (obj){ iSex=obj.value; }
	iSex=GetSex(); 
	
	//��������
	obj=document.getElementById("AgeMin");  
	if (obj){ 
		iAgeMin=obj.value; 
		if (IsValidAge(iAgeMin)){}
		else { 
			obj.className='clsInvalid';			
			//alert("�������޴���!!!"); 
			alert(t['Err 03']);
			return false;
		}
	}		

	//��������
	obj=document.getElementById("AgeMax");  
	if (obj){ 
		iAgeMax=obj.value; 
		if (IsValidAge(iAgeMax)){}
		else {
			obj.className='clsInvalid'; 			
			//alert("�������޴���!!!"); 
			alert(t['Err 04']);
			return false;
		}
	}
		
	//�ı�ֵ
	obj=document.getElementById("TextVal");  
	if (obj){ iTextVal=obj.value; }	

	//��λ����
	obj=document.getElementById("Unit");
	if (obj) { iUnit=obj.value; } 

	//�ж�����
	obj=document.getElementById("Min");
	if (obj) { iMin=obj.value; } 

	if (!(IsFloat(iMin))) {
		obj.className='clsInvalid'; 
		//alert("�ο�ֵ����ֵ�������");
		alert(t['Err 01']);
		return false;
	}

	//�ж�����
	obj=document.getElementById("Max");
	if (obj) { iMax=obj.value; }
	if (!(IsFloat(iMax))) {
		obj.className='clsInvalid';
		//alert("�ο�ֵ����ֵ�������");
		alert(t['Err 02']);
		return false;
	}

	//�Ƿ�����ֵ 1 ������(��һ����Ŀ��˵ ֻ��һ�������ο�)
	obj=document.getElementById("NatureValue");
	if (obj) {
		if (true==obj.checked){ iNaturalValue="Y"; }
		else{ iNaturalValue="N"; }	
	}  

	// ODS_Template	ģ��
	obj=document.getElementById("Template");  
	if (obj){ iTemplate=obj.value; }	
	
	
	//�Ƿ����С�� 
	
	obj=document.getElementById("Summary");
	if (obj) {
		if (true==obj.checked){ iSummary="Y"; }
		else{ iSummary="N"; }	
	}  
 
	
	if ("T"==FOrderDetailType || "S"==FOrderDetailType) {
	    //����������֤
		if (""==iTextVal) {
		obj=document.getElementById("TextVal")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("�ı�ֵ����Ϊ��");
		return false;
	 }

		
		/*if (""==iTextVal) {
			//alert("Please entry all information.");
			alert(t['01']);
			return false;
		
		}*/
	}
	else{
		
		if ((""==iMax)&&(""==iMin)&&(""==iUnit)) {
			//alert("Please entry all information.");
			//alert(t['01']);
			alert("�ο���Χһ������Ϊ��");
			return false;
		}	
	}


  
    	//�Ƿ�Ϊ��Σ����
	var iHighRiskFlag=""
	obj=document.getElementById("HighRiskFlag");
	if (obj) {
		if (true==obj.checked){ iHighRiskFlag="Y"; }
		else{ iHighRiskFlag="N"; }	
	} 
	obj=document.getElementById("EyeSee");
	if (obj) iEyeSee=obj.value;
	
	obj=document.getElementById("HDValue");
	if (obj&&obj.checked) {
		iHDValue="Y";	
	}
	
	obj=document.getElementById("NoPrint");
	if (obj&&obj.checked) {
		iNoPrint="Y";	
	}

	var Instring = trim(iParRef)		// 1	
				+"^"+trim(iRowId)		// 2
				+"^"+trim(iChildSub)	// 3 
				+"^"+trim(iTextVal)		// 4 
				+"^"+trim(iUnit)		// 5
				+"^"+trim(iSex)			// 6 
				+"^"+trim(iMin)			// 7 
				+"^"+trim(iMax)			// 8 				
				+"^"+""					// 9 
				+"^"+trim(iNaturalValue)// 10
				+"^"+trim(iAgeMin)		// 11 
				+"^"+trim(iAgeMax)		// 12 
				+"^"+trim(iTemplate)	// 13 
	      		+"^"+trim(iSummary)
				+"^"+trim(iNoPrint)
	      		+"^"+""
	      		+"^"+trim(iHighRiskFlag)    //add
	      		+"^"+trim(iEyeSee)
	      		+"^"+trim(iHDValue)
		;
    
	var obj=document.getElementById("ODS_NatureValuez"+CurrentSel);
	if (obj&&obj.checked){var ODSNatureValue="Y"; } 
	else{var ODSNatureValue="N"; }
	
	var ret=tkMakeServerCall("web.DHCPE.ODStandard","GetODSNatureValue",iParRef,iRowId);
	if((ODSNatureValue=="N")&&(iNaturalValue=="Y")&&(ret=="1"))
	 {
	   alert("����ֵ������,�����ظ�����");
	    return false;
    
	}

	var Ins=document.getElementById('ClassBox');
	
	if (Ins) { var encmeth=Ins.value; } 
	else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	
	if ('0'==flag) {}
	else{
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
	}
	
	location.reload(); 

}

function Delete_click() {

	var iParRef="", iChildSub="";

	var obj;
	
	//��Ŀ����
	obj=document.getElementById("ParRef");
	if (obj){ iParRef=obj.value; }
	
	//��ǰ��׼����
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
	
	if ((""==iParRef)||(""==iChildSub)){
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false;
	}
	else{ 
		//if (confirm("Are you sure delete it?")) {
		if (confirm(t['04'])) {	
			var Ins=document.getElementById('DeleteBox');
			if (Ins) { var encmeth=Ins.value; } 
			else { var encmeth=''; }
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub);
			
			if (flag=='0') {}
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
	
	//ȡҳ�����
	SelRowObj=document.getElementById('ODS_ParRef'+'z'+selectrow);
	obj=document.getElementById("ParRef");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	//��Ŀ����
	SelRowObj=document.getElementById('ODS_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }

	//��ǰ��¼���
	SelRowObj=document.getElementById('ODS_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	//��ǰ��¼����
	SelRowObj=document.getElementById('ODS_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	// ----------------------------------------------------------------
	
	//�����Ա� M-��,F-Ů,N-����
	SelRowObj=document.getElementById('ODS_Sex'+'z'+selectrow);
	obj=document.getElementById("Sex");
	if (SelRowObj && obj) { 
		SetSex("");	
		SetSex(trim(SelRowObj.innerText));	
	}
	
	//��������
	SelRowObj=document.getElementById('ODS_AgeMin'+'z'+selectrow);
	obj=document.getElementById("AgeMin");
	if (SelRowObj && obj) { 
		obj.value=trim(SelRowObj.innerText);	
		obj.className=''; 
	}
	
	//��������
	SelRowObj=document.getElementById('ODS_AgeMax'+'z'+selectrow);
	obj=document.getElementById("AgeMax");
	if (SelRowObj && obj) { 
		obj.value=trim(SelRowObj.innerText);
		obj.className=''; 
	}
	
	//�жϽ��(����)
	SelRowObj=document.getElementById('ODS_TextVal'+'z'+selectrow);
	obj=document.getElementById("TextVal");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }

	//��λ
	SelRowObj=document.getElementById('ODS_Unit'+'z'+selectrow);
	obj=document.getElementById("Unit");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }

	//�������
	SelRowObj=document.getElementById('ODS_Min'+'z'+selectrow);
	obj=document.getElementById("Min");
	if (SelRowObj && obj) { 
		obj.value=trim(SelRowObj.innerText);
		obj.className=''; 
	}

	//�������
	SelRowObj=document.getElementById('ODS_Max'+'z'+selectrow);
	obj=document.getElementById("Max");
	if (SelRowObj && obj) {		
		obj.value=trim(SelRowObj.innerText);
		obj.className='';
	}
	
	//�Ƿ�����ֵ
	SelRowObj=document.getElementById('ODS_NatureValue'+'z'+selectrow);
	if (SelRowObj && obj) { 
		obj=document.getElementById("NatureValue");
		obj.checked=SelRowObj.checked;	
	}
	
	// ODS_Template	ģ��
	SelRowObj=document.getElementById('ODS_Template'+'z'+selectrow);
	obj=document.getElementById("Template");
	if (SelRowObj && obj) {		
		obj.value=trim(SelRowObj.innerText);
		obj.className='';
	}	
	// ODS_Summary �Ƿ����С��
	SelRowObj=document.getElementById('ODS_Summary'+'z'+selectrow);
	if (SelRowObj && obj) {	
	  obj=document.getElementById("Summary");	
		obj.checked=SelRowObj.checked;
	}	
		//HighRiskFlag	
	SelRowObj=document.getElementById('ODS_HighRiskFlag'+'z'+selectrow);
	obj=document.getElementById("HighRiskFlag");
	if (SelRowObj && obj) {		
	  obj.checked=SelRowObj.checked;
	}
	
	//��λ
	SelRowObj=document.getElementById('TEyeSee'+'z'+selectrow);
	obj=document.getElementById("EyeSee");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }
	
	SelRowObj=document.getElementById('THDValue'+'z'+selectrow);
	obj=document.getElementById("HDValue");
	if (SelRowObj && obj) {		
	  obj.checked=SelRowObj.checked;
	}
	
	SelRowObj=document.getElementById('TNoPrint'+'z'+selectrow);
	obj=document.getElementById("NoPrint");
	if (SelRowObj && obj) {		
	  obj.checked=SelRowObj.checked;
	}

	
}
	
	
			

function Clear_click() {
	
	var obj;
	
	/*
	obj=document.getElementById("ParRef");
	obj.value="";
	
	obj=document.getElementById("ParRef_Name");
	obj.value="";	
	*/


	obj=document.getElementById("Rowid");
	if (obj) { obj.value=""; }

	obj=document.getElementById("ChildSub");
	if (obj) { obj.value=""; }
	
	//�����Ա�
	//obj=document.getElementById("Sex");
	//obj.value="N";	
		SetSex("");
		SetSex("N");

	//�������� 
	obj=document.getElementById("AgeMin");
	if (obj) { 
		obj.value=""; 
		obj.className=''; 
	}

	//��������   
	obj=document.getElementById("AgeMax");
	if (
		obj) { obj.value=""; 
		obj.className=''; 
	}

	//�ı�ֵ   
	obj=document.getElementById("TextVal");
	if (obj) { obj.value=""; }
	
	//��λ	
	obj=document.getElementById("Unit");
	if (obj) { obj.value=""; }
	
	//�������	
	obj=document.getElementById("Min");
	if (obj) { 
		obj.value=""; 
		obj.className=''; 
	}
	
	//�������
	obj=document.getElementById("Max");
	if (obj) { 
		obj.value=""; 
		obj.className=''; 
	}
	
	//�Ƿ�����ֵ                   
	obj=document.getElementById("NatureValue");
	if (obj) { obj.checked=false; }
	
	
	// ODS_Template	ģ��
	obj=document.getElementById("Template");
	if (obj) { 
		obj.value=""; 
		obj.className=''; 
	}
	obj=document.getElementById("EyeSee");
	if (obj) obj.value="";
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
	    
	if (selectrow==CurrentSel) {	    

		Clear_click();     
		CurrentSel=0;
		return;
	}
	
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;

// ***********************************************************
//������Ŀ���� ������ʾԪ��
function SetOrderDetailType(OrderDetailType) {

	//������� ˵����
	if ('T'==OrderDetailType) {
/*		
		document.all["Max"].disabled=true;
		//document.all["cMax"].disabled=true; 
		document.all["Min"].disabled=true; 
		//document.all["CMin"].disabled=true; 
		document.all["Unit"].disabled=true; 		
		//document.all["cUnit"].disabled=true; 
		document.all["cLabel_2"].disabled=true; 
		document.all["cLabel_3"].disabled=true; 
*/
		//�������
		obj=document.getElementById("Max");
		if (obj) { obj.style.display = "none"; }
		obj=document.getElementById("cMax");
		if (obj) { obj.style.display = "none"; }
		
		//�������
		obj=document.getElementById("Min");
		if (obj) { obj.style.display = "none"; }
		obj=document.getElementById("cMin");
		if (obj) { obj.style.display = "none"; }
		
		//��λ
		obj=document.getElementById("Unit");
		if (obj) { obj.style.display = "none"; }
		obj=document.getElementById("cUnit");
		if (obj) { obj.style.display = "none"; }

		//obj=document.getElementById("cLabel_1");
		//if (obj) { obj.style.display = "none"; }

		obj=document.getElementById("cLabel_2");
		if (obj) { obj.style.display = "none"; }
		
		obj=document.getElementById("cLabel_3");
		if (obj) { obj.style.display = "none"; }

	}
	
	else{//������� ��ֵ��
	
/*
		document.all["Max"].disabled=false; 
		//document.all["cMax"].disabled=false; 
		document.all["Min"].disabled=false; 
		//document.all["CMin"].disabled=false; 
		document.all["Unit"].disabled=false; 
		//document.all["cUnit"].disabled=false; 
		document.all["cLabel_2"].disabled=false; 
		document.all["cLabel_3"].disabled=false; 


*/
		//�������
		obj=document.getElementById("Max");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("cMax");
		if (obj) { obj.style.display = "inline"; }
		
		//�������
		obj=document.getElementById("Min");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("cMin");
		if (obj) { obj.style.display = "inline"; }
		
		//��λ
		obj=document.getElementById("Unit");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("cUnit");
		if (obj) { obj.style.display = "inline"; }

		//obj=document.getElementById("cLabel_1");
		//if (obj) { obj.style.display = "inline"; }
		
		obj=document.getElementById("cLabel_2");
		if (obj) { obj.style.display = "inline"; }
		
		obj=document.getElementById("cLabel_3");
		if (obj) { obj.style.display = "inline"; }	

	}
}

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
/*
// ********************************************************************
// �༭ �걾�Ľ���
function AdviceEdit_click() { 
	var lnk="";
	var iParRef="";
	var iODSDR="";	
	var iODSDRName="";
	var obj;
	
	obj=document.getElementById("ParRef");
	iParRef=obj.value;
	
	obj=document.getElementById("Rowid");
	iODSDR=obj.value;
	
	obj=document.getElementById("ParRef_Name");
	iODSDRName=obj.value;
	    	
	lnk = "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEODAdviceCom"
			+"&ParRef="+iParRef
			+"&ODSDR="+iODSDR
			+"&ParRefName="+iODSDRName					
			;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';

	window.open(lnk,"_blank",nwin)

}

*/


/*
// ***********************************************************************
// ��ȡ��λ
function SearchUOM(value) {
		
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
	
		//��Ŀ����
		obj=document.getElementById("Unit_DR_Name");
		obj.value=aiList[0];
		
		//��Ŀ����
		obj=document.getElementById("Unit_DR");
		obj.value=aiList[2];

	}
}
*/


/*
//��ȡϸ���
function SearchOrderDetail(value) {

	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		//��ѡ��һ����Ŀʱ?Ĭ����Ҫ����һ���µĲο�
		Clear_click();	
		//��Ŀ����
		obj=document.getElementById("ParRef");
		obj.value=aiList[1];
		
		//��Ŀ����
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[0];

	}
}

//��ȡϸ���
function SearchDetailList(value) {
	
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		//��ѡ��һ����Ŀʱ?Ĭ����Ҫ����һ���µĲο�
		Clear_click();	
		//��Ŀ����
		obj=document.getElementById("ParRef");
		obj.value=aiList[0];
		
		//��Ŀ����
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[1];

	}

}
*/
/// DHCPEOrderDetailRelateCom.js
/// ����ʱ��		2006.03.20
/// ������		xuwm 
/// ��Ҫ����		�༭�����ϸ����Ϲ�ϵ����
/// ��Ӧ��		DHC_PE_OrderDetailRelate
/// ����޸�ʱ��	
/// ����޸���	

var CurrentSel=0;

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	 
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	// ������ʱ?�ж��Ƿ��Ƕ���
	//obj=document.getElementById("Cascade");
	//if (obj){ obj.onchange=Cascade_change; }
	
	// ����LIS��Ŀ
	obj=document.getElementById("ImportLabItems");
	if (obj){
		obj.onclick=ImportLabItems_click;
		stObj=document.getElementById("StationTypeBox");
		//if (stObj && "Lab"==stObj.value) { obj.style.display="inline"; }
		var flag=tkMakeServerCall("web.DHCPE.TransOrderDetail","GetLisInterface")
		if (stObj && "Lab"==stObj.value&& "N"==flag) { obj.style.display="inline"; }

	}

	iniForm();
	ShowCurRecord(1);

	}  

function iniForm(){

	var SelRowObj;
	var obj;

	//��ǰҳ��ĸ��� �����Ŀ����
	SelRowObj=document.getElementById('ParARCIMDR');
	obj=document.getElementById("ARCIM_DR");	
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	if (''==SelRowObj.value) {
	    obj=document.getElementById("ARCIM_DR_Name");
	    if (obj) { obj.value="��ǰվ��û��ҽ����Ŀ"; }
	}
	else{
	    obj=document.getElementById("ARCIM_DR_Name");
	    if (obj) { obj.value="��ǰҽ����Ŀû������"; }
		ShowCurRecord(1); 
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}	
 
//���������Ŀ(ҽ��)  
function SearchArcItmmast(value){

	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		//�����Ŀ����
		obj=document.getElementById("ARCIM_DR");
		obj.value=aiList[2];
		//�����Ŀ����
		obj=document.getElementById("ARCIM_DR_Name");
		obj.value=aiList[1];
  	}
}


function SearchParentOrderDetailRelate(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;

		obj=document.getElementById("Parent_DR");
		obj.value=aiList[1];

		obj=document.getElementById("Parent_DR_Name");
		obj.value=aiList[0];
  	}	
}
function ImportLabItems_click(){
	var obj=document.getElementById('ImportLabItemsBox');
	ARCIMDr=GetCtlValueById("ARCIM_DR", true);
	
	if (obj) {var encmeth=obj.value; } 
	else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,ARCIMDr);
	
	location.reload();
}
// ������ʱ?�ж��Ƿ��Ƕ���,���򽫸����Ϊ��ʹ��
function Cascade_change () {
	var Src=window.event.srcElement;
	
	obj=document.getElementById("Parent_DR_Name");
	if ("1"==Src.value) { if (obj) { obj.disabled=false; } }
	else{if (obj) { obj.disabled=true; } } 
}

//��������
function SearchDetailList(value){
	
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		Clear_click();
		//�������
		obj=document.getElementById("OD_DR");
		obj.value=aiList[2];

		//��������
		obj=document.getElementById("OD_DR_Name");
		obj.value=aiList[0];

	}
}
 
function Update_click() {

	var iRowId="";
	var iARCIMDR="", iODDR="", iSequence="", iRequired="",iParentDR="", iCascade="",iHistory="0";
	var obj;
	// 0 
	obj=document.getElementById("RowId");  
	if (obj){ iRowId=obj.value; }  

	// 1 �����Ŀ����
	obj=document.getElementById("ARCIM_DR");
	if (obj){ iARCIMDR=obj.value; }  

	// 2 �������
	obj=document.getElementById("OD_DR");
	if (obj){ iODDR=obj.value; }  

	// 3 ˳��� ODR_Sequence
	obj=document.getElementById("Sequence");
	if (obj){ iSequence=obj.value; }
	
     if (""==iODDR) {
		obj=document.getElementById("OD_DR")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("�������Ʋ���Ϊ��");
		return false;
	}

	if (""==iSequence) {
		obj=document.getElementById("Sequence")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("˳��Ų���Ϊ��");
		return false;
	}

	// 4 �Ƿ������ ODR_Required
	obj=document.getElementById("Required");
	if (obj){
		if (obj.checked==true){ iRequired="Y"; }
		else{ iRequired="N"; }
	}
	
	// 5 ����ָ�� ODR_Parent_DR
	obj=document.getElementById("Parent_DR");  
	if (obj){ 
		iParentDR=obj.value;
		if (""!=iParentDR) {
			obj=document.getElementById("Parent_DR_Name");
			if (obj && ""==obj.value) { iParentDR=""; }
		}
	}
	
	// 6 ��� ODR_Cascade
	obj=document.getElementById("Cascade");  
	if (obj){ 
		iCascade=obj.value;
		if ("1"==iCascade) { iParentDR=""; }
	}  
	// 6 ��� HistoryFlag
	obj=document.getElementById("HistoryFlag");  
	if (obj){ 
		if (obj.checked) { iHistory="1"; }
	}  
	
	/*
	//����������֤
	if ((""==iARCIMDR)||(""==iODDR)){
		//alert("Please entry all information.");
		alert(t['01']);
		return false;
	}
*/
	var Instring=trim(iRowId)			// 0
				+"^"+trim(iARCIMDR)		// 1 �����Ŀ����
				+"^"+trim(iODDR)		// 2 �������
				+"^"+trim(iSequence)	// 3 ˳��� ODR_Sequence
				+"^"+trim(iRequired)	// 4 �Ƿ������ ODR_Required
				+"^"+trim(iParentDR)	// 5 ����ָ�� ODR_Parent_DR
				+"^"+trim(iCascade)		// 6 ��� ODR_Cascade
				+"^"+trim(iHistory)		// 6 �����бȶ�
				;
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	if (flag=='-104') {
		alert('�����õĸ����¼������');}
	else{
		if (flag=='0') {
		}else if (flag=='Err 01') {
			alert(t['Err 01']);
		}else{
			//alert("Insert error.ErrNo="+flag)
			alert(t['02']+flag);
		}
	} 
	//ˢ�µ�ǰҳ��
	location.reload();

}

function Delete_click() {

	var iRowId="";
	var obj;

	//��¼���
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }

	//�����Ŀ����
	obj=document.getElementById("ARCIM_DR");
	if (obj){ iARCIM_DR=obj.value; }

	//�������
	obj=document.getElementById("OD_DR");
	if (obj){ iOD_DR=obj.value; }
	  
	if ((""==iARCIM_DR)||(""==iOD_DR)){
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false;
	} 
	else{ 
		//if (confirm("Are you sure delete it?")){
		if (confirm(t['04'])){
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value} 
			else {var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iRowId)
			if (flag=='0') {}
			else{ 
				//alert("Delete error.ErrNo="+flag);
				alert(t['05']+flag);
			}
	     
			location.reload();
		}
	}

}
//���
function Clear_click() {
	var obj;
	
	//��������ڵ�
	/*	
	//�����Ŀ����
	obj=document.getElementById("ARCIM_DR");
	obj.value="";

	//�����Ŀ����
	obj=document.getElementById("ARCIM_DR_Name");
	obj.value="";
	*/
	

	// �������
	obj=document.getElementById("OD_DR");
	if (obj) { obj.value=""; }

	// ��������
	obj=document.getElementById("OD_DR_Name");
	if (obj) { obj.value=""; }


	// 3 ˳��� ODR_Sequence
	var obj=document.getElementById("Sequence");
	if (obj) { obj.value=""; }

	// 4 �Ƿ������ ODR_Required
	var obj=document.getElementById("Required");
	if (obj){ obj.checked=false; }
	
	// 5.1 ����ָ�� ODR_Parent_DR
	var obj=document.getElementById("Parent_DR");  
	if (obj) { obj.value=""; }
	
	// 5 ����ָ�� ODR_Parent_DR
	var obj=document.getElementById("Parent_DR_Name");  
	if (obj) { obj.value=""; }
	
	// 6 ��� ODR_Cascade
	var obj=document.getElementById("Cascade");  
	if (obj) { obj.value=""; }

   
	//��¼���
	obj=document.getElementById("RowId");
	if (obj) { obj.value=""; }
	//��¼���
	obj=document.getElementById("HistoryFlag");
	if (obj) { obj.checked=false; }
}

//��ʾ��ǰ��¼
function ShowCurRecord(CurRecord) {
	var selectrow=CurRecord;
	
	var SelRowObj;
	var obj;
	
	//�����Ŀ����
	SelRowObj=document.getElementById('ODR_ARCIM_DR'+'z'+selectrow);
	obj=document.getElementById("ARCIM_DR");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }

	//�����Ŀ����
	SelRowObj=document.getElementById('ODR_ARCIM_DR_Name'+'z'+selectrow);
	obj=document.getElementById("ARCIM_DR_Name");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }


	// 3 ˳��� ODR_Sequence
	SelRowObj=document.getElementById('ODR_Sequence'+'z'+selectrow);
	obj=document.getElementById("Sequence");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }

	
	// 5 ����ָ�� ODR_Parent_DR
	SelRowObj=document.getElementById('ODR_Parent_DR'+'z'+selectrow);
	obj=document.getElementById("Parent_DR");  
	if (SelRowObj && obj) { obj.value=SelRowObj.value; } 
	
	// 5.1 ����ָ�� ODR_Parent_DR
	SelRowObj=document.getElementById('ODR_Parent_DR_Name'+'z'+selectrow);
	obj=document.getElementById("Parent_DR_Name");  
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); } 
	
	// 6 ��� ODR_Cascade
	SelRowObj=document.getElementById('ODR_Cascade'+'z'+selectrow);
	obj=document.getElementById("Cascade");  
	if (SelRowObj && obj) {
		var iCascade=trim(SelRowObj.innerText);
		obj.value=iCascade;
		
		//obj=document.getElementById("Parent_DR_Name");
		//if ("1"==iCascade) { if (obj) { obj.disabled=false; } }
		//else{if (obj) { obj.disabled=true; } } 
	} 

	// 4 �Ƿ������ ODR_Required
	SelRowObj=document.getElementById('ODR_Required'+'z'+selectrow);
	obj=document.getElementById("Required");
	if (SelRowObj && obj) { obj.checked=SelRowObj.checked; }

	//�������
	SelRowObj=document.getElementById('ODR_OD_DR'+'z'+selectrow);
	obj=document.getElementById("OD_DR");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	//��������
	SelRowObj=document.getElementById('ODR_OD_DR_Name'+'z'+selectrow);
	obj=document.getElementById("OD_DR_Name");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
    
	//��¼����
	SelRowObj=document.getElementById('ODR_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }
	//��ʷ�ȶ�
	SelRowObj=document.getElementById('HistoryFlag'+'z'+selectrow);
	obj=document.getElementById("HistoryFlag");
	if (SelRowObj && obj) { obj.checked=SelRowObj.checked; }
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
	
	if (selectrow==CurrentSel){
	    
	    Clear_click(); 	    
	    CurrentSel=0
	    return;
	}

	CurrentSel=selectrow;
	ShowCurRecord(CurrentSel);
    
}

// **********************************************************
////////                ����δ������           ///////////
//��ʾ�����Ŀ������ ������ DHCPEOrderDetailRelateShowOrderDetail �����
function ShowArcItmmastDetailList(ARCIMDR){
    return false;
    var GetCodeVar=document.getElementById("OrderDetailAllBox").value;

    var str=cspRunServerMethod(GetCodeVar,"");

    var selbox=parent.parent.frames['DHCPEOrderDetailRelateShowOrderDetail'].document.getElementById("DisplayItem");

    addlistoption(selbox,str);


}

function addlistoption(selobj,resStr) {
	var resList=new Array();
	var tmpList=new Array();
	selobj.options.length=0;
	resList=resStr.split("!")
//	alert (selobj.length);
	for (i=1;i<resList.length;i++) {
		tmpList=resList[i].split("^")
		selobj.add(new Option(tmpList[1],tmpList[0]));
	}
}
function moveout_Click() {
	var surlist=document.getElementById("DisplayItem");
	var dlist=document.getElementById("DisplayAll");
	moveout(surlist,dlist);
	savevar(surlist);
}

function movein_Click() {
	var surlist=document.getElementById("AisplayAll");
	var dlist=document.getElementById("DisplayItem");
	movein(surlist,dlist);
	savevar(dlist);
	
}

document.body.onload = BodyLoadHandler;
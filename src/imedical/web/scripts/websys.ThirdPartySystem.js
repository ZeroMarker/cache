var idobj,codeobj,descobj,companyobj,datefobj,datetobj,aes7PaddingKeyObj,GenAES7KeyObj;
var addobj,updateobj,deleteobj,clearobj;
document.body.onload=function(){
	idobj=document.getElementById("Id");
	codeobj=document.getElementById("SysCode");
	descobj=document.getElementById("SysDesc");
	companyobj=document.getElementById("SysCompany");
	datefobj=document.getElementById("SysDateFrom");
	datetobj=document.getElementById("SysDateTo");
	aes7PaddingKeyObj = document.getElementById("SysAES7PaddingKey");
	addobj=document.getElementById("Add");
	updateobj=document.getElementById("Update");
	deleteobj=document.getElementById("Delete");
	viewmgrobj=document.getElementById("ViewMgr");
	clearobj=document.getElementById("Clear");
	GenAES7KeyObj =document.getElementById("GenAES7Key");
	if (addobj) addobj.onclick=add_click;
	if (updateobj) updateobj.onclick=update_click;
	if (deleteobj) deleteobj.onclick=delete_click;
	if (clearobj) clearobj.onclick=clear_click;
	if (GenAES7KeyObj) GenAES7KeyObj.onclick = GenAES7KeyObj_click;
	
}
function GenAES7KeyObj_click(){
	aes7PaddingKeyObj.value = md5(new Date().toUTCString()).slice(0,16);
}
function check(){
	if(codeobj.value=="") {alert("���������");return false;}
	if(descobj.value=="") {alert("����������");return false;}
	if(companyobj.value=="") {alert("�����빫˾");return false;}
	/*if(!checkdate(datefobj.value.trim())){
		return false;
	}
	if(!checkdate(datetobj.value.trim())){
		return false;
	}*/
	return true;
}

function checkdate(str){
	if(str!=""){
		var DATE_FORMAT = /^[0-3]{1}[0-9]{1}\/[0-1]{1}[0-9]{1}\/[0-9]{4}$/;  
		if(!DATE_FORMAT.test(str)){  
			alert("���ڸ�ʽ����\r\n��ʹ���Ҳ��������������ڣ����߰���22/08/2016�ĸ�ʽ����");  
			return false;
		}
	}
	return true;
	
}

//ClassMethod Save(Id, SysCode, SysDesc, SysDateFrom, SysDateTo, SysCompany)
function add_click(){
	var id="";
	var code=codeobj.value;
	var desc=descobj.value;
	var company=companyobj.value;
	var datef=datefobj.value;
	var datet=datetobj.value;
	var aes7PaddingKey = aes7PaddingKeyObj.value;
	if(!check()){return false;}
	var encobj=document.getElementById("enc");
	var enc=encobj.value;
	//alert(scid+"___"+score)
	var rtn = cspHttpServerMethod(enc,id,code,desc,datef,datet,company,aes7PaddingKey);
	//var rtn = tkMakeServerCall("web.DHCTest2016","UpdateSTSRByObj",srRowid,score);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("���ӳɹ�");
		
		Find_click();
	}else if(rtn=-100){
		alert("���ڸ�ʽ����");
	}else if(rtn=-101){
		alert("��ʼ���ڲ��ܴ��ڽ�������");
	}else{
		alert("ʧ��");
	}
}
function update_click(){
	var id=idobj.value;
	var code=codeobj.value;
	var desc=descobj.value;
	var company=companyobj.value;
	var datef=datefobj.value;
	var datet=datetobj.value;
	var aes7PaddingKey = aes7PaddingKeyObj.value;
	if(id=="") {alert("��ѡ��Ҫ�޸ĵ���");return false;}
	if(!check()){return false;}
	var encobj=document.getElementById("enc");
	var enc=encobj.value;
	//alert(scid+"___"+score)
	
	var rtn = cspHttpServerMethod(enc,id,code,desc,datef,datet,company,aes7PaddingKey);
	//var rtn = tkMakeServerCall("web.DHCTest2016","UpdateSTSRByObj",srRowid,score);
	
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("�޸ĳɹ�");
		clear_click();
	}else if(rtn=-100){
		alert("���ڸ�ʽ����");
	}else if(rtn=-101){
		alert("��ʼ���ڲ��ܴ��ڽ�������");
	}else{
		alert("ʧ��");
	}
}
function clear_click(){
	codeobj.value="";
	descobj.value="";
	companyobj.value="";
	datefobj.value="";
	datetobj.value="";
	idobj.value="";
	Find_click();
}
function delete_click(){
	var id=idobj.value;
	if(id=="") {alert("��ѡ��Ҫɾ������");return false;}
	var encobj=document.getElementById("del");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,id);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("ɾ���ɹ�");
		clear_click();
	}else{
		alert("ʧ��");
	}
}

var SelectRowHandler = function(){
	if(selectedRowObj.rowIndex>0){
		var code = document.getElementById("SysCodez"+selectedRowObj.rowIndex).innerText;
		var desc = document.getElementById("SysDescz"+selectedRowObj.rowIndex).innerText;
		var company = document.getElementById("SysCompanyz"+selectedRowObj.rowIndex).innerText;
		var datef = document.getElementById("SysDateFromz"+selectedRowObj.rowIndex).innerText;
		var datet = document.getElementById("SysDateToz"+selectedRowObj.rowIndex).innerText;
		var id = document.getElementById("Idz"+selectedRowObj.rowIndex).value;
		var aes7PaddingKey = document.getElementById("SysAES7PaddingKeyz"+selectedRowObj.rowIndex).innerText;
		
		codeobj.value=code.trim();
		descobj.value=desc.trim();
		companyobj.value=company.trim();
		datefobj.value=datef.trim();
		datetobj.value=datet.trim();
		idobj.value=id;
		aes7PaddingKeyObj.value = aes7PaddingKey.trim();
	}else{
		codeobj.value="";
		descobj.value="";
		companyobj.value="";
		datefobj.value="";
		datetobj.value="";
		idobj.value="";
		aes7PaddingKeyObj.value="";
	}
	
}
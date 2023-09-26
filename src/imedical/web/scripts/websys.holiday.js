var idobj,codeobj,descobj,imgobj,daysobj,lunarobj,activeobj;
var addobj,updateobj,deleteobj,clearobj;
var lunar,act;
document.body.onload=function(){
	idobj=document.getElementById("hldRowId");
	codeobj=document.getElementById("hldCode");
	descobj=document.getElementById("hldDesc");
	imgobj=document.getElementById("hldimgname");
	daysobj=document.getElementById("hldDays");
	lunarobj=document.getElementById("hldIsLunar");
	lunarobj.checked=true;
	activeobj=document.getElementById("hldActive");
	activeobj.checked=true;
	
	addobj=document.getElementById("Add");
	updateobj=document.getElementById("Update");
	deleteobj=document.getElementById("Delete");
	clearobj=document.getElementById("Clear");
	if (codeobj) codeobj.onblur = codeblur;
	if (addobj) addobj.onclick=add_click;
	if (updateobj) updateobj.onclick=update_click;
	if (deleteobj) deleteobj.onclick=delete_click;
	if (clearobj) clearobj.onclick=clear_click;
	
}
function check(){
	if(codeobj.value=="") {alert("��������մ���");return false;}
	if(descobj.value=="") {alert("�����������");return false;}
	if(imgobj.value=="") {alert("���������ͼƬ");return false;}
    if(daysobj.value=="") {alert("�������������");return false;}
	return true;
}



//   Save(Id, Code, Desc, hldimgname, hldIsLunar, hldDays, hldActive)
function add_click(){
	if(!check()){return false;}
	var id="";
	var code=codeobj.value;
	var desc=descobj.value;
	var imgname=imgobj.value;
	var days=daysobj.value;
	if(lunarobj.checked){
		lunar="Y";
	}else{
		lunar="N";
	}
	
	if(activeobj.checked){
		act="Y";
	}else{
		act="N";
	}
	
	var encobj=document.getElementById("save");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,id,code,desc,imgname,lunar,days,act);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("���ӳɹ�");
		Find_click();
	}else{
		alert("ʧ��");
	}
}
function update_click(){
	var id=idobj.value;
	if(id=="") {alert("��ѡ��Ҫ�޸ĵ���");return false;}
	if(!check()){return false;}
	var code=codeobj.value;
	var desc=descobj.value;
	var imgname=imgobj.value;
	var days=daysobj.value;
	if(lunarobj.checked){
		lunar="Y";
	}else{
		lunar="N";
	}
	
	if(activeobj.checked){
		act="Y";
	}else{
		act="N";
	}

	var encobj=document.getElementById("save");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,id,code,desc,imgname,lunar,days,act);
	//var rtn = tkMakeServerCall("web.DHCTest2016","UpdateSTSRByObj",srRowid,score);
	
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("�޸ĳɹ�");
		Find_click();
	}else{
		alert("ʧ��");
	}
}
function clear_click(){
	codeobj.value="";
	descobj.value="";
	imgobj.value="";
	daysobj.value="";
	lunarobj.checked=true;
	activeobj.checked=true;
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
function codeblur(){
	if ((imgobj.value=="")&&(codeobj.value!="")){imgobj.value = codeobj.value+".jpg"}
	if (codeobj.value==""){imgobj.value = ""}
}
var SelectRowHandler = function(){
	if(selectedRowObj.rowIndex>0){
		var code = document.getElementById("hldCodez"+selectedRowObj.rowIndex).innerText;
		var desc = document.getElementById("hldDescz"+selectedRowObj.rowIndex).innerText;
		var days = document.getElementById("hldDaysz"+selectedRowObj.rowIndex).innerText;
		var imgname = document.getElementById("hldimgnamez"+selectedRowObj.rowIndex).innerText;
		var lunarz = document.getElementById("hldIsLunarz"+selectedRowObj.rowIndex).innerText;
		var actz = document.getElementById("hldActivez"+selectedRowObj.rowIndex).innerText;
		var id = document.getElementById("hldRowIdz"+selectedRowObj.rowIndex).value;
		
		codeobj.value=code;
		descobj.value=desc;
		daysobj.value=days;
		imgobj.value=imgname;
		if(lunarz=="Y"){
			lunarobj.checked=true;
		}else{
			lunarobj.checked=false;
		}
		if(actz=="Y"){
			activeobj.checked=true;
		}else{
			activeobj.checked=false;
		}		
		idobj.value=id;
	}else{
		codeobj.value="";
		descobj.value="";
		daysobj.value="";
		imgobj.value="";
		lunarobj.checked=true;
		activeobj.checked=true;	
		idobj.value="";
	}
	
}
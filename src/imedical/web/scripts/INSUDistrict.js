var CurrentSel=0
function BodyLoadHandler() 
{
	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update;}
}
function Update()
{
	var Code=document.getElementById("Code").value;
	var Desc=document.getElementById("Desc").value;
	var Demo=document.getElementById("Demo").value;
	var Rowid=document.getElementById("Rowid").value;
	if (Rowid==""){alert("请选择要修改的数据!!"); return}
	var UpdateDistrictobj=document.getElementById('UpdateDistrict');
	if (UpdateDistrictobj) {var encmeth=UpdateDistrictobj.value} else {var encmeth=''};
	var UpdateDistrict=cspRunServerMethod(encmeth,Code,Desc,Demo,Rowid);
	if (UpdateDistrict=="0"){alert("修改成功!");}
	else {alert("修改失败!错误代码："+UpdateDistrict);}
	location.reload();
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUDistrict');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    
	if (!selectrow) return;
	var SelRowObj
	var obj	
	if (selectrow==CurrentSel){		
        obj=document.getElementById("Code");
        if (obj){obj.value=""}        
        obj=document.getElementById("Desc");
        if (obj){obj.value=""}
        obj=document.getElementById("Demo");
        if (obj){obj.value=""}
        obj=document.getElementById("Rowid");
        if (obj){obj.value=""}
	    CurrentSel=0;
	    return;
	}			
	CurrentSel=selectrow;		

	/*for (var i=0;i<obj.options.length;i++){
		if (SelRowObj.innerText==obj.options[i].value){
		   obj.selectedIndex=i;
		}
	}*/
	SelRowObj=document.getElementById('TDistrictCodez'+selectrow);
	obj=document.getElementById("Code");
	if (SelRowObj.innerText==" "){SelRowObj.innerText=""}
	obj.value=SelRowObj.innerText;
	
	SelRowObj=document.getElementById('TDistrictDescz'+selectrow);
	obj=document.getElementById("Desc");
	if (SelRowObj.innerText==" "){SelRowObj.innerText=""}
	obj.value=SelRowObj.innerText;
	
	SelRowObj=document.getElementById('TDemo1z'+selectrow);
	obj=document.getElementById("Demo");
	if (SelRowObj.innerText==" "){SelRowObj.innerText=""}
	obj.value=SelRowObj.innerText;
	
	SelRowObj=document.getElementById('TRowidz'+selectrow);
	obj=document.getElementById("Rowid");
	if (SelRowObj.innerText==" "){SelRowObj.innerText=""}
	obj.value=SelRowObj.innerText;
}
document.body.onload = BodyLoadHandler;
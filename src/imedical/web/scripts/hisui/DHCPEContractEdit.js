
//名称	DHCPEContractEdit .js
//功能	团体合同维护
//组件	DHCPEContractEdit 	
//创建	2018.11.8
//创建人  xy

function BodyLoadHandler()
{
	var obj;
	
	//更新 
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	
	//清屏
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	
	init();
}
function init()
{
	var ID=getValueById("ID");
	if(ID!=""){
		var Str=tkMakeServerCall("web.DHCPE.Contract","GetInfoByID",ID)
		var DataArr=Str.split("^"); 
		setValueById("ID",DataArr[0]);
		setValueById("No",DataArr[1]);
		setValueById("Name",DataArr[2]);
		setValueById("SignDate",DataArr[3]);
		setValueById("Remark",DataArr[4]);
	}
}
function BUpdate_click()
{
	var obj,No,Name,Remark,SignDate,ID,encmeth,Str;
	var No=getValueById("No");
	if (""==No) {
            obj=document.getElementById("No")
		if (obj) {
			//websys_setfocus(obj.id);
			//obj.className='clsInvalid';
		}
		$.messager.alert("提示","编号不能为空","info");
		return false;

	}
	

	var Name=getValueById("Name");
	if (""==Name) {
            obj=document.getElementById("Name")
		if (obj) {
			//websys_setfocus(obj.id);
			//obj.className='clsInvalid';
		}
		$.messager.alert("提示","名字不能为空","info");
		return false;

	}
	var Remark=getValueById("Remark");
	var SignDate=getValueById("SignDate");
	var ID=getValueById("ID");
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var UserID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	Str=No+"^"+Name+"^"+SignDate+"^"+Remark+"^"+UserID+"^"+LocID;
	
	if (ID==""){
			var ret=cspRunServerMethod(encmeth,"",Str);
	}else{
			var ret=cspRunServerMethod(encmeth,ID,Str);

	}
	
	var retData=ret.split("^");
	
	if(retData[0]!=-1){
		alert("更新成功");
		opener.location.reload(); 
		//websys_showModal("close"); 
		window.close();
          

	}
	else {
		alert("更新失败,相同编码已经存在");
		}
}

function BClear_click()
{
	setValueById("ID","");
	setValueById("No","");
	setValueById("Name","");
	setValueById("SignDate","");
	setValueById("Remark","");
}


document.body.onload = BodyLoadHandler;
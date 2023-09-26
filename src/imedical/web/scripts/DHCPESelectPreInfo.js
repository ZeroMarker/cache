document.body.onload=LoadHandler;
var SelRow="";
function LoadHandler()
{
	var obj=GetObj("BFind");
	if(obj) obj.onclick=BFind_click;
	var obj=GetObj("BUpdate");
	if(obj) obj.onclick=BUpdate_click;
}
function BUpdate_click()
{
	if (SelRow==""){
		alert("请先选择待操作的数据");
		return false;
	}
	var PreIADM=GetValue("TPIADMz"+SelRow,"");
	var TeamID=GetValue("TeamID","");
	if (TeamID==""){
		alert("请选择合并到的分组");
		return false;
	}
	var RegNo=GetValue("TRegNoz"+SelRow,"2");
	var flag=tkMakeServerCall("web.DHCPE.SelectPreInfo","GetRegNoByTeamID",TeamID,RegNo);
	if(flag==1){
		 alert("分组里已经存在该人员,不能重复添加");
		 return false;
	 }
	var encmeth=GetValue("UpdateClass","");
	var ret=cspRunServerMethod(encmeth,TeamID,PreIADM)
	var Arr=ret.split("^");
	if (Arr[0]==0){
		alert("合并成功");
		window.location.reload();
	}else{
		alert(Arr[1])
	}
}
function BFind_click()
{
	var RegNo=GetValue("RegNo","");
	var Name=GetValue("Name","");
	var TeamID=GetValue("TeamID","");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESelectPreInfo&RegNo="+RegNo+"&Name="+Name+"&TeamID="+TeamID;
	window.location.href=lnk;
}
function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}
function GetValue(Name,Type)
{
	var Value="";
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			Value=obj.innerText;
		}else{
			Value=obj.value;
		}
	}
	return Value;
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if (SelRow==selectrow){
		SelRow="";
	}else{
		SelRow=selectrow;
	}
}	
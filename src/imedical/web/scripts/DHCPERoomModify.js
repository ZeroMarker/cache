var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BModify");
	if (obj) obj.onclick=BModify_click;
}
function BModify_click()
{
	var RoomID=GetValue("RoomID",1);
	var RMinute=GetValue("RMinute",1);
	var Sex=GetValue("Sex",1);
	var RActiveFlag="Y";
	var obj=GetObj("RActiveFlag");
	if (obj&&!obj.checked) RActiveFlag="N";
	var encmeth=GetValue("ModifyClass",1);
	
	var Str=Sex+"^"+RMinute+"^"+RActiveFlag;
	var rtn=cspRunServerMethod(encmeth,RoomID,Str);
	if (rtn.split("^")[0]=="-1"){
		alert("¸üÐÂÊ§°Ü"+rtn.split("^")[1])
	}else{
		window.close();
	}
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
function SetValue(Name,Value,Type)
{
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			obj.innerText=Value;
		}else{
			obj.value=Value;
		}
	}
}
document.body.onload = BodyLoadHandler;
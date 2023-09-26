var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	obj=document.getElementById("DoctorDesc");
	if (obj) obj.onchange=DoctorDesc_change;

}
function DoctorDesc_change()
{
	
	var obj;
	obj=document.getElementById("DoctorDesc");
	if(obj){obj.value="";}
	obj=document.getElementById("DoctorDR");
	if(obj){obj.value="";}

	
}

function BUpdate_click()
{
	var Code=GetValue("Code",1);
	var Desc=GetValue("Desc",1);
	var Sort=GetValue("Sort",1);
	
	if (""==Code) {
		obj=document.getElementById("Code")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("代码不能为空");
		return false;
	}
   if (""==Desc) {
		obj=document.getElementById("Desc")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("描述不能为空");
		return false;
	}
 if (""==Sort) {
		obj=document.getElementById("Sort")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("序号不能为空");
		return false;
	}

	var Sex=GetValue("Sex",1);
	var Diet=GetValue("Diet",1);
	var Emiction=GetValue("Emiction",1);
	var Station=GetValue("Station",1);
	var Remark=GetValue("Remark",1);
	var Minute=GetValue("Minute",1);
	var ID=GetValue("ID",1);
	var Parref=GetValue("Parref",1);
	var DoctorDR=GetValue("DoctorDR",1);
	var ActiveFlag="Y";
	var obj=GetObj("ActiveFlag");
	if (obj&&!obj.checked) ActiveFlag="N";
	var ShowNum=GetValue("ShowNum",1);
	var encmeth=GetValue("UpdateMethod",1);
	
	var BangdingFlag="N";
	var obj=GetObj("IFBangding");
	if (obj&&obj.checked) BangdingFlag="Y";
	
	var VIPLevel=GetValue("VIPLevel",1);

	var Str=Parref+"^"+Code+"^"+Desc+"^"+Sort+"^"+Sex+"^"+Diet+"^"+Emiction+"^"+Station+"^"+Remark+"^"+Minute+"^"+DoctorDR+"^"+ActiveFlag+"^"+ShowNum+"^"+BangdingFlag+"^"+VIPLevel;
	var rtn=cspRunServerMethod(encmeth,ID,Str);
	if (rtn.split("^")[0]=="-1"){
		alert("更新失败"+rtn.split("^")[1])
	}else{
		window.location.reload();
	}
}
function BClear_click()
{
	SetValue("ID","",1);
	SetValue("Code","",1);
	SetValue("Desc","",1);
	SetValue("Sort","",1);
	SetValue("Sex","N",1);
	SetValue("Diet","N",1);
	SetValue("Emiction","N",1);
	SetValue("Station","",1);
	SetValue("Remark","",1);
	SetValue("Minute","",1);
	SetValue("DoctorDR","",1);
	SetValue("DoctorDesc","",1);
	var obj=GetObj("ActiveFlag");
	if (obj) obj.checked=true;
	SetValue("ShowNum","",1);
	SetValue("VIPLevel","",1);
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
//以便本页面的子页面有正确的传入参数
function ShowCurRecord(selectrow) {
	var ID=GetValue('TID'+'z'+selectrow,1);
	SetValue("ID",ID,1);
	var encmeth=GetValue("GetOneMethod",1);
	var OneStr=cspRunServerMethod(encmeth,ID);
	//Code_"^"_Desc_"^"_Sort_"^"_Sex_"^"_SexDesc_"^"_DietFlag_"^"_DietDesc_"^"_EmictionFlag_"^"_EmictionDesc_"^"_StationDR_"^"_StationDesc_"^"_Remark
	var StrArr=OneStr.split("^");
	SetValue("Code",StrArr[0],1);
	SetValue("Desc",StrArr[1],1);
	SetValue("Sort",StrArr[2],1);
	SetValue("Sex",StrArr[3],1);
	SetValue("Diet",StrArr[5],1);
	SetValue("Emiction",StrArr[7],1);
	SetValue("Station",StrArr[9],1);
	SetValue("Remark",StrArr[11],1);
	SetValue("Minute",StrArr[12],1);
	SetValue("DoctorDR",StrArr[13],1);
	SetValue("DoctorDesc",StrArr[14],1);
	var obj=GetObj("ActiveFlag");
	if (obj){
		if (StrArr[15]=="Y"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
	var obj=GetObj("IFBangding");
	//alert(StrArr[17]);
	if (obj){
		if (StrArr[17]=="Y"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
	//alert("aaa")
	SetValue("ShowNum",StrArr[16],1);
	SetValue("VIPLevel",StrArr[18],1);
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERoomSpecimen&Parref="+ID;
	parent.frames["DHCPERoomSpecimen"].location.href=lnk+"&Type=SP"; 
	parent.frames["DHCPERoomIP"].location.href=lnk+"&Type=IP"; 
	parent.frames["DHCPERoomSR"].location.href=lnk+"&Type=SR";
	parent.frames["DHCPERoomRP"].location.href=lnk+"&Type=RP";
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPEArea');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}
function DoctorFind(value)
{
	if (value=="") return flase;
	var StrArr=value.split("^");
	SetValue("DoctorDR",StrArr[0],1);
	SetValue("DoctorDesc",StrArr[1],1);
}
document.body.onload = BodyLoadHandler;
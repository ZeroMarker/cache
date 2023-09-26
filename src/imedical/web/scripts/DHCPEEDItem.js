///DHCPEEDItem.js
///危害因素检查项目维护

var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	obj=document.getElementById("ArcimDesc");
	if (obj) obj.onchange=ArcimDesc_change;
	obj=document.getElementById("SetsDesc");
	if (obj) obj.onchange=SetsDesc_change;
	obj=document.getElementById("SetOrder");
	if (obj) obj.onclick=SetOrder_click;
	obj=document.getElementById("OMETypeDR");
	if (obj) obj.onchange=OMEType_change;
	
}
function OMEType_change()
{
	SetValue("OMETypeID","",1);
}

function BUpdate_click()
{
    var encmeth=GetValue("SaveClass",1);
    var ID=GetValue("ID",1);
	var Parref=GetValue("Parref",1);
	var ArcimID=GetValue("ArcimID",1);
	var SetsID=GetValue("SetsID",1);
	var OMEType=GetValue("OMETypeID",1);
	var ExpInfo=GetValue("ExpInfo",1);
	var Remark=GetValue("Remark",1);
	var SetsFlag="N";
	var NeedFlag="N";
	var obj=document.getElementById("NeedFlag");
	if (obj&&obj.checked) NeedFlag="Y";
	var Active="N";
	var obj=document.getElementById("Active");
	if (obj&&obj.checked) Active="Y";
	if ((ArcimID=="")&&(SetsID=="")){
			alert("项目或套餐不能为空");
			return false;
		}
		if (ArcimID==""){
			SetsFlag="Y";
			ArcimID=SetsID;
		}
	
	var Str=Parref+"^"+ArcimID+"^"+NeedFlag+"^"+OMEType+"^"+SetsFlag+"^"+Active+"^"+ExpInfo+"^"+Remark;
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
	SetValue("ArcimID","",1);
	SetValue("SetsID","",1);
	SetValue("ArcimDesc","",1);
	SetValue("SetsDesc","",1);
	SetValue("OMETypeDR","",1);
	SetValue("ExpInfo","",1);
	SetValue("Remark","",1);
	var obj=document.getElementById("Active");
	if (obj) obj.checked=false;
	var obj=document.getElementById("NeedFlag");
	if (obj) obj.checked=false;
}
function BDelete_click()
{
	var ID=GetValue("ID",1);
	if (ID=="")
	{
		alert("请先选择要删除的记录");
		return false;
	}
	var encmeth=GetValue("DeleteClass",1);
	var rtn=cspRunServerMethod(encmeth,ID);
	if (rtn.split("^")[0]=="-1"){
		alert("删除失败"+rtn.split("^")[1])
	}else{
		window.location.reload();
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
function OMETypeAfter(value)
{
	if (value=="") return flase;
	var StrArr=value.split("^");
	SetValue("OMETypeID",StrArr[0],1);
	SetValue("OMETypeDR",StrArr[2],1);
}	
function ArcimAfter(value)
{
	if (value=="") return false;
	var StrArr=value.split("^");
	SetValue("ArcimID",StrArr[2],1);
	SetValue("ArcimDesc",StrArr[1],1);
	SetValue("SetsID","",1);
	SetValue("SetsDesc","",1);
}
function SetsAfter(value)
{
	if (value=="") return false;
	var StrArr=value.split("^");
	SetValue("SetsID",StrArr[0],1);
	SetValue("SetsDesc",StrArr[1],1);
	SetValue("ArcimID","",1);
	SetValue("ArcimDesc","",1);
}		

function ShowCurRecord(selectrow) {
	var ID=GetValue('TID'+'z'+selectrow,1);
	SetValue("ID",ID,1);
	var encmeth=GetValue("GetOneMethod",1);
	var OneStr=cspRunServerMethod(encmeth,ID);
	var StrArr=OneStr.split("^");
	SetValue("OMETypeDR",StrArr[2],1);
	SetValue("ExpInfo",StrArr[5],1);
	SetValue("Remark",StrArr[6],1);
	SetValue("OMETypeID",StrArr[9],1);
	var NeedFlag=StrArr[1];
	var obj=document.getElementById("NeedFlag");
	if (obj){
		if (NeedFlag=="Y"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
	var SetsFlag=StrArr[3];
	var obj=document.getElementById("SetsFlag");
	
	if (obj){
		if (SetsFlag=="Y"){
		    SetValue("ArcimDesc","",1);
			SetValue("SetsDesc",StrArr[0],1);
			obj=document.getElementById("SetOrder");
	        if (obj){
		        obj.setAttribute("SetOrder","disabled")
		        obj.disabled=true;
	        }
	        
	        
		}else{
			SetValue("ArcimDesc",StrArr[0],1);
			SetValue("SetsDesc","",1);
			obj=document.getElementById("SetOrder");
	        if (obj){
		        obj.disabled=false;
	        }
		}
	}
	var Active=StrArr[4];
	var obj=document.getElementById("Active");
	if (obj){
		if (Active=="Y"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
	//var ArcimID=StrArr[7];
	//alert(StrArr[7])
	SetValue("ArcimID",StrArr[7],1);
	//lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEEDItemDetail&ParRef="+ID+"&ParARCIMDR="+ArcimID;
	//parent.frames["DHCPEEDItemDetail"].location.href=lnk; 
}
function SetOrder_click(){
	var ID=GetValue("ID",1);
    if(ID==""){
	    alert("请选择要维护细项的记录");
	    return false;
    }
	var ArcimID=GetValue("ArcimID",1);
	var NeedFlag=GetValue("NeedFlag",1);
	if (ID=="") return false;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEEDItemDetail&ParRef="+ID+"&ParARCIMDR="+ArcimID;
	var wwidth=700;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	return false;    //LIKE褰㈠紡鐨勮繑鍥炲?间负false
	                 //鑿滃崟杩炴帴褰㈠紡鐨勮繑鍥炲?间负TRUE        
}			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPEEndanger');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}
function ArcimDesc_change()
{
    SetValue("ArcimID","",1);
}
function SetsDesc_change()
{
    SetValue("SetsID","",1);
}

document.body.onload = BodyLoadHandler;
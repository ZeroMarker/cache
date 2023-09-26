//DHCRegConDisCountSet.js

function DocumentLoadHandler() {
	var myobj=document.getElementById('Sex');
	if (myobj){
		myobj.onchange=Sex_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
	var myobj=document.getElementById('AgeCompare');
	if (myobj){
		myobj.onchange=AgeCompare_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
	var myobj=document.getElementById('FeeCate');
	if (myobj){
		myobj.onchange=FeeCate_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
	var myobj=document.getElementById('PatType');
	if (myobj){
		myobj.onchange=PatType_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
	var obj=document.getElementById("Update")
	if(obj){obj.onclick=Update_click;}
	var obj=document.getElementById("Dept")
	if(obj){obj.onchange=Dept_Onkeydown;}
	var obj=document.getElementById("Mark")
	if(obj){obj.onchange=Mark_Onkeydown;}
	
	loadSex()
	loadAgeCompare()
	loadFeeCate()
	loadPatType()
	init()
}
function Mark_Onkeydown(e)
{
	var MarkDesc=document.getElementById("Mark").value;
	if (MarkDesc==""){
		var obj=document.getElementById("MarkDr");
 		obj.value=""
		}
}
function Dept_Onkeydown(e)
{	var DeptDesc=document.getElementById("Dept").value;
	if (DeptDesc==""){
		var obj=document.getElementById("DeptDr");
		obj.value=""
		var obj=document.getElementById("Mark");
		obj.value=""
		var obj=document.getElementById("MarkDr");
 		obj.value=""
	}
}

function init(){
	var RCDRowid=DHCC_GetElementData("RCDRowid")
	var encmeth=DHCWebD_GetObjValue("GetDHCRegConDisCountById");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,RCDRowid);
	}
	if (rtn=="") return;
	var arr=rtn.split("^")
	DHCC_SetElementData("Age",arr[9])
	DHCC_SetElementData("AgeCompareDr",arr[10])
	//DHCC_SetElementData("AgeCompare",arr[11])
	DHCC_SetElementData("SexDr",arr[12])
	//DHCC_SetElementData("Sex",arr[13])
	DHCC_SetElementData("DeptDr",arr[14])
    DHCC_SetElementData("Dept",arr[15])
	DHCC_SetElementData("MarkDr",arr[16])
	DHCC_SetElementData("Mark",arr[17])
	DHCC_SetElementData("FeeCateDr",arr[18])
	//DHCC_SetElementData("FeeCate",arr[19])
	DHCC_SetElementData("PatTypeDr",arr[20])
	//DHCC_SetElementData("PatType",arr[21])
	if(arr[22]==1) DHCC_SetElementData("OldCard",1)
	else DHCC_SetElementData("OldCard","")
}
function Sex_OnChange(){
	var myoptval=DHCWeb_GetListBoxValue("Sex");
	var myary=myoptval.split("^");
	var SexDr=myary[0];
	var myobj=document.getElementById('SexDr');
	myobj.value=SexDr
}
function loadSex(){
	var RCDRowid=DHCC_GetElementData("RCDRowid")
	DHCWebD_ClearAllListA("Sex");
	var encmeth=DHCWebD_GetObjValue("SexEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","Sex",RCDRowid);
	}
}
function AgeCompare_OnChange(){
	var RCDRowid=DHCC_GetElementData("RCDRowid")
	var myoptval=DHCWeb_GetListBoxValue("AgeCompare");
	var myary=myoptval.split("^");
	var AgeCompareDr=myary[0];
	var myobj=document.getElementById('AgeCompareDr');
	myobj.value=AgeCompareDr
}
function loadAgeCompare(){
	var RCDRowid=DHCC_GetElementData("RCDRowid")
	DHCWebD_ClearAllListA("AgeCompare");
	var encmeth=DHCWebD_GetObjValue("ReadCompare");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","AgeCompare",RCDRowid);
	}
}
function FeeCate_OnChange(){
	var myoptval=DHCWeb_GetListBoxValue("FeeCate");
	var myary=myoptval.split("^");
	var FeeCateDr=myary[0];
	var myobj=document.getElementById('FeeCateDr');
	myobj.value=FeeCateDr
	
}
function loadFeeCate(){
	var RCDRowid=DHCC_GetElementData("RCDRowid")
	DHCWebD_ClearAllListA("FeeCate");
	var encmeth=DHCWebD_GetObjValue("ReadPatTypeAdm");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","FeeCate",RCDRowid);
	}
}
function PatType_OnChange(){
	var myoptval=DHCWeb_GetListBoxValue("PatType");
	var myary=myoptval.split("^");
	var PatTypeDr=myary[0];
	var myobj=document.getElementById('PatTypeDr');
	myobj.value=PatTypeDr
}
function loadPatType(){
	var RCDRowid=DHCC_GetElementData("RCDRowid")
	DHCWebD_ClearAllListA("PatType");
	var encmeth=DHCWebD_GetObjValue("ReadPatType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PatType",RCDRowid);
	}
}
function LoclookupSelect(value){
	 var Str=value.split("^");
  var obj=document.getElementById("DeptDr");
  obj.value=Str[1]
	if (document.getElementById("MarkDr")) document.getElementById("MarkDr").value="";
	if (document.getElementById("Mark")) document.getElementById("Mark").value="";
}
function DoclookupSelect(value){
	 var Str=value.split("^");
  var obj=document.getElementById("MarkDr");
  obj.value=Str[1]
}

function Update_click(){
	var RCDRowid=DHCC_GetElementData("RCDRowid")
	var Age=DHCC_GetElementData("Age")
	var AgeCompare=DHCC_GetElementData("AgeCompareDr")
	var SexDr=DHCC_GetElementData("SexDr")
	var DeptDr=DHCC_GetElementData("DeptDr")
	var Dept=DHCC_GetElementData("Dept")
	if(Dept=="") DeptDr=""
	var MarkDr=DHCC_GetElementData("MarkDr")
	var Mark=DHCC_GetElementData("Mark")
	if(Mark=="") MarkDr=""
	var FeeCateDr=DHCC_GetElementData("FeeCateDr")
	var PatTypeDr=DHCC_GetElementData("PatTypeDr")
	var OldCard=DHCC_GetElementData("OldCard")
   var BtnUpdateClass=document.getElementById("UpdateMethod")
   if (BtnUpdateClass) {var encmeth=BtnUpdateClass.value} else {var encmeth=''};
   var returnvalue=cspRunServerMethod(encmeth,RCDRowid,Age,AgeCompare,SexDr,DeptDr,MarkDr,FeeCateDr,PatTypeDr,OldCard);
 if(returnvalue==0) {
	 alert("保存成功");
	 location.reload();
 }
   else alert("添加失败")
	
}
document.body.onload = DocumentLoadHandler;
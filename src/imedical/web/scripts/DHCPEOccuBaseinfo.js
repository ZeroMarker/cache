//DHCPEOccuBaseinfo.js

function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("HarmInfo");
	if (obj) {obj.ondblclick=HarmInfo_Click;}
	obj=document.getElementById("BSave");
	if (obj) {obj.onclick=BSave_Click;}
	GetData();
	
}
function GetData()
{
	obj=document.getElementById("PreIADM");
	if (obj) {PreIADM=obj.value;}  //1
	var Data=tkMakeServerCall("web.DHCPE.DHCPEOccuBaseEx","GetData",PreIADM);
	if (Data=="") return;
	//alert("PreIADM"+PreIADM)
	var Datas=Data.split("^");
	obj=document.getElementById("category");
	if (obj) {obj.value=Datas[3];} //2
	
	
	obj=document.getElementById("WorkNo"); //3
	if (obj) {obj.value=Datas[2];}
	
	obj=document.getElementById("AllWorkYear"); //4
	if (obj) {obj.value=Datas[6];}
	
	obj=document.getElementById("HarmWorkYear"); //5
	if (obj) {obj.value=Datas[0];}
	
	obj=document.getElementById("Industry");//6
	if (obj) {obj.value=Datas[1];}
	
	obj=document.getElementById("Typeofwork");//7
	if (obj) {obj.value=Datas[7];}
	obj=document.getElementById("HarmInfo");//7
	if (obj) {obj.value=Datas[8];}
	
	
	
	
	}
function BSave_Click()
{
	//alert(1)
	var obj;
	var PreIADM="",category="",WorkNo="",AllWorkYear="",HarmWorkYear="",Industry="",Typeofwork="",Industry="";
	var Strings=""
	obj=document.getElementById("PreIADM");
	if (obj) {PreIADM=obj.value;}  //1
	var Strings=PreIADM
	obj=document.getElementById("category");
	if (obj) {var category=obj.value;} //2
	var Strings=Strings+"^"+category
	//alert("temYPP"+temYPP)
	obj=document.getElementById("WorkNo"); //3
	if (obj) {var WorkNo=obj.value;}
	var Strings=Strings+"^"+WorkNo
	obj=document.getElementById("AllWorkYear"); //4
	if (obj) {var AllWorkYear=obj.value;}
	if((!(/^\d+$/.test(AllWorkYear)))&&(AllWorkYear!="")) 
	{
		alert("总工龄不是数字格式");
		return false;
	}
	var Strings=Strings+"^"+AllWorkYear
	obj=document.getElementById("HarmWorkYear"); //5
	if (obj) {var HarmWorkYear=obj.value;}
	if((!(/^\d+$/.test(HarmWorkYear)))&&(HarmWorkYear!="")) 
	{
		alert("接害工龄不是数字格式");
		return false;
	}
	var Strings=Strings+"^"+HarmWorkYear
	obj=document.getElementById("Industry");//6
	if (obj) {var Industry=obj.value;}
	var Strings=Strings+"^"+Industry
	obj=document.getElementById("Typeofwork");//7
	if (obj) {var Typeofwork=obj.value;}
	var Strings=Strings+"^"+Typeofwork
	
	var InsertFlag=tkMakeServerCall("web.DHCPE.DHCPEOccuBaseEx","Insert",Strings);
	//alert("aaaStrings"+Strings)
	//alert("InsertFlag"+InsertFlag)
	if (InsertFlag==0)
	{alert("更新成功");}
	else 
	{alert(InsertFlag);}
	
	
	
	
	
	}

function HarmInfo_Click()
{
	var PreIADM=""
	obj=document.getElementById("PreIADM");
	if (obj) {PreIADM=obj.value;}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOccuBaseinfo.Endanger"
			+"&PreIADM="+PreIADM
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=680,height=400,left=150,top=150';
	window.open(lnk,"_blank",nwin)
}
document.body.onload = BodyLoadHandler;
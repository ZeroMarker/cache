//检验条码打印
//
function BarCodePrintByCrm(crmid)
{
	if (""==crmid) {
		return ;
	}
	var encmeth=GetCtlValueById("GetAdmID");
	if (""==encmeth) return;
	
	var admid=cspRunServerMethod(encmeth,crmid);
	var info=admid.split("^");
	admid=info[1];
	BarCodePrint(admid);
}

function BarCodePrint(paadmid) 
{
	var encmeth="";
	var result="";
	
	if (""==paadmid) {
		return ;
	}
	
	//获取信息
	var Ins=document.getElementById("PatOrdItemInfo");
	if (Ins) {var encmeth=Ins.value; }
	if (""!=encmeth) result=cspRunServerMethod(encmeth,"BarPrint","",paadmid+"^");
}

function BarPrint(value) {
		
	if (""==value) {
		alert("未找到检验项目");
		return false;
	}
	var Ords=value.split(";");
	var iLLoop=1;
	for (var iLLoop=1;iLLoop<Ords.length;iLLoop++) 
	{

		OrdItems=Ords[iLLoop].split("^");
		
		var Bar;  
		Bar= new ActiveXObject("PrintBar.PrnBar");
		Bar.PrintName="tm";//打印机名称
        Bar.SetPrint()
		// 登记号
		Bar.RegNo=OrdItems[0]; 	
		// 姓名
		Bar.PatName=OrdItems[1];
		// 年龄
		Bar.Age=OrdItems[2];
		// 性别
		Bar.Sex=OrdItems[3];
		// 部门
		Bar.PatLoc=OrdItems[4];	
		// 标本号
		Bar.SpecNo=OrdItems[6];	
		// 项目名称
		var OrdNameArray=Ords[iLLoop].split("\!");
		Bar.OrdName=OrdNameArray[1];	
		Bar.RecLoc=OrdNameArray[2];
        Bar.BedCode="";  
		Bar.PrintZebraBar();
	}

}
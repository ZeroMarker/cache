var CurrentSel=0;
//var CurFindType="Detail";
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BGetLisResult");
	if (obj) obj.onclick=BGetLisResult_click;
	
	var obj=document.getElementById("BPrintASpecimen");
	if (obj) {obj.onclick=BPrintASpecimenList_Click;} 
	
	var obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_click;}
	SetTitleName();
}
function SetTitleName()
{
	var FindType="Detail",obj;
	obj=document.getElementById("FindType");
	if (obj) {FindType=obj.value;}
	
	if (FindType=="Item"){
		obj=document.getElementById("1");
		if (obj) obj.innerText="数量";
		obj=document.getElementById("2");
		if (obj) obj.innerText="项目";
		obj=document.getElementById("3");
		if (obj) obj.style.display="none";
		obj=document.getElementById("4");
		if (obj) obj.style.display="none";
		obj=document.getElementById("7");
		if (obj) obj.style.display="none";
		var obj=GetObj("ShowTotal")
		if (obj&&obj.checked){
			obj=document.getElementById("4");
			if (obj) obj.style.display="none";
			obj=document.getElementById("6");
			if (obj) obj.style.display="none";
		}
		var tb1 = document.getElementById('tDHCPESpecDetail'); 
    	var trs = tb1.getElementsByTagName('tr');
    	for(var i=1; i<trs.length; i++) { 
        	var tds = trs[i].getElementsByTagName('td'); 
        	var obj=tds[4]; //第二列
        	obj.style.display="none";
        	var obj=tds[5]; //第二列
        	obj.style.display="none";
			var obj=tds[6]; //第二列
        	obj.style.display="none";
			var obj=GetObj("ShowTotal")
			if (obj&&obj.checked){
				var obj=tds[1]; //第二列
				//obj.style.display="none";
			}
    	}
	}else if(FindType=="Person"){
		
		obj=document.getElementById("1");
		if (obj) obj.innerText="数量";
		obj=document.getElementById("2");
		if (obj) obj.style.display="none";
		obj=document.getElementById("3");
		if (obj) obj.style.display="none";
		obj=document.getElementById("4");
		if (obj) obj.style.display="none";
		obj=document.getElementById("7");
		if (obj) obj.style.display="none";
		var tb1 = document.getElementById('tDHCPESpecDetail'); 
    	var trs = tb1.getElementsByTagName('tr');
    	for(var i=1; i<trs.length; i++) { 
        	var tds = trs[i].getElementsByTagName('td');
        	var obj=tds[2]; //第二列
        	obj.style.display="none";
        	var obj=tds[4]; //第二列
        	obj.style.display="none";
        	var obj=tds[5]; //第二列
        	obj.style.display="none";
			var obj=tds[6]; //第二列
        	obj.style.display="none";
    	}
	}else{
		var obj=GetObj("ShowTotal")
		if (obj&&obj.checked){
			obj=document.getElementById("7");
			if (obj) obj.style.display="none";
			var tb1 = document.getElementById('tDHCPESpecDetail'); 
			var trs = tb1.getElementsByTagName('tr');
			for(var i=1; i<trs.length; i++) { 
				var tds = trs[i].getElementsByTagName('td');
				var obj=tds[6]; //第二列
				obj.style.display="none";
			}
		}
	}
	
}
function BFind_click()
{
	var FindType=GetValue("FindType");
	//CurFindType=FindType;
	var BeginDate=GetValue("BeginDate");
	var EndDate=GetValue("EndDate");
	var VIPLevel=GetValue("VIPLevel");
	var ShowTotal="0";
	var obj=GetObj("ShowTotal")
	if (obj&&obj.checked) ShowTotal="1";
	var Name=GetValue("Name");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESpecDetail";
	lnk=lnk+"&FindType="+FindType+"&BeginDate="+BeginDate+"&EndDate="+EndDate+"&VIPLevel="+VIPLevel+"&ShowTotal="+ShowTotal+"&VName="+Name;
	window.location.href=lnk;
}
function FindType_onchange()
{
	var FindType=GetValue("FindType");
	var BeginDate=GetValue("BeginDate");
	var EndDate=GetValue("EndDate");
	var VIPLevel=GetValue("VIPLevel");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESpecDetail&FindType="+FindType+"&BeginDate="+BeginDate+"&EndDate="+EndDate+"&VIPLevel="+VIPLevel;
	window.location.href=lnk;
}
function BGetLisResult_click()
{
	var DateStr=GetValue("DateStr",1);
	var encmeth=GetValue("GetLisResult",1);
	var UserID=session['LOGON.USERID'];
	var BeginDate=GetValue("BeginDate");
	var EndDate=GetValue("EndDate");
	var rtn=cspRunServerMethod(encmeth,BeginDate+"^"+EndDate,UserID);
	//window.location.reload();
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
function BExport_click()
{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj&& ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	var ExportName="DHCPESpecDetail"
	var obj=document.getElementById("GetExportInfo");
	if (obj) {var encmeth=obj.value} else{var encmeth=""}
	xlApp= new ActiveXObject("Excel.Application"); //固定
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
	var CurFindType=GetValue("FindType");
	var Info=cspRunServerMethod(encmeth,"",ExportName,CurFindType);
	
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			xlsheet.cells(Row,i).value=DataArr[i];
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		Info=cspRunServerMethod(encmeth,Sort,ExportName);
	}
	xlsheet.SaveAs("d:\\"+ExportName+".xls");
		
	xlApp.Visible= true;
	xlApp.UserControl= true;
}
function BPrintASpecimenList_Click()
{
	BExport_click();
	return false;
    try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintASpecimenList.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称

	var UserName=session['LOGON.USERNAME'];
	var obj=document.getElementById("PrintTimeBox");
	if (obj) var PrintTime=obj.value;

	
	xlsheet.cells(3,1)="打印者:";
	xlsheet.cells(3,2)=UserName;
	xlsheet.cells(3,3)="打印时间:";
	xlsheet.cells(3,4)=PrintTime;
	
	var obj=document.getElementById("SpeciBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
    
    var obj=document.getElementById("DateStr");
    if(obj)  {var Instring=obj.value;} 
    
    var str=cspRunServerMethod(encmeth,Instring);
   	var temprow=str.split("^");
	var obj=document.getElementById("OrdInfoBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""} 
	var k=5;
	for(i=0;i<=(temprow.length-1);i++)
	{
		var row=cspRunServerMethod(encmeth,temprow[i]);
		//alert(row)
		xlsheet.Rows(i+k+1).insert();
		var tempcol=row.split("^");	
		xlsheet.cells(i+k,1).value=i+1;
		xlsheet.cells(i+k,2).value=tempcol[0];
		xlsheet.cells(i+k,3).value=tempcol[1]; 
		xlsheet.cells(i+k,4).value=tempcol[2];
		xlsheet.cells(i+k,5).value=tempcol[3];
		xlsheet.cells(i+k,6).value=tempcol[4];
		xlsheet.cells(i+k,7).value=tempcol[5];
	}
	
	///删除最后的空行
	//xlsheet.Rows(i+k+1).Delete;
	///删除最后的空行
	xlsheet.Rows(i+k).Delete;
    	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
	idTmr   =   window.setInterval("Cleanup();",1); 
}

catch(e)
	{
		alert(e+"^"+e.message);
	}
	
}
document.body.onload = BodyLoadHandler;
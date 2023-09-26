//alert(2);
document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");
DHCCNursePrintComm = document.getElementById("DHCCNursePrintComm")
function BodyLoadHandler()
{
	var print=document.getElementById("print");
	if(print) print.onclick=printClickByXML ;//printClick;
	var printPat=document.getElementById("printPat");
	if(printPat) printPat.onclick=PrintPatInfo;
	var AllergyPat=document.getElementById("AllergyPat");
	if (AllergyPat) AllergyPat.onclick=AllergyPatClick;
	var SelectAll=document.getElementById("SelectAll");
	if(SelectAll) SelectAll.onclick=SelectAll_Click;
	
}
function saveWardID(str)
{
	var WardID=document.getElementById("WardID");
	WardID.value=(str.split("^"))[1];
}
function SelectAll_Click()
{
	var Selectz;
	var tblData=document.getElementById("tDHCNurIpPrintInfo");
	var SelectAll=document.getElementById("SelectAll");
	for(var i=1;i<tblData.rows.length;++i)
	{
		Selectz=document.getElementById("Selectz"+i);
		if(SelectAll.checked==false)
		{
			Selectz.checked=false;
		}
		else
		{
			Selectz.checked=true;
		}

		
	}
}
function printClick()
{
	var tableData=document.getElementById("tDHCNurIpPrintInfo");
	var selectFlag=0
	for(var i=1;i<tableData.rows.length;i++)
	{
		if(document.getElementById("Selectz"+i).checked==true)
		{
			selectFlag=1
		}
	}
	if(selectFlag==0){
		alert("请选中病人")
		return;
	}
	var xlsExcel,xlsBook,xlsSheet;
	var bedCode,patName,Medicare,patAge,patSex,AdmDate,food,other;
	var printLocation=0;
	var GetPath=document.getElementById("GetPath").value;
	var Path=cspRunServerMethod(GetPath);
	Path=Path+"PatInfo.xls";
	//alert(Path);
	xlsExcel=new ActiveXObject("Excel.application");
	xlsBook=xlsExcel.WorkBooks.Add(Path);
	xlsSheet=xlsBook.ActiveSheet;
	SavePrintRecord();  ///输出前调用
	
	for(var i=1;i<tableData.rows.length;i++)
	{
		if(document.getElementById("Selectz"+i).checked==true)
		{
			//科别,入院时间,住院号,床号,姓名,性别,年龄,诊断,单位
			patName=document.getElementById("patNamez"+i).innerText;
			patSex=document.getElementById("patSexz"+i).innerText;
			bedCode=document.getElementById("bedCodez"+i).innerText;
			patAge=document.getElementById("patAgez"+i).innerText;
			regNo=document.getElementById("RegNoz"+i).innerText;		
		    Medicare=document.getElementById("Medicarez"+i).innerText;
			AdmDate=document.getElementById("AdmDatez"+i).innerText;
			MainDoc=document.getElementById("MainDocz"+i).innerText;
			MainNurse=document.getElementById("MainNursez"+i).innerText;
			
			
			//printLocation++;
			//AddPatInfoOld(xlsSheet,printLocation,bedCode,patName,patAge,patSex,AdmDate,food,other)		
			AddPatInfo(xlsSheet,patName,patSex+"   "+bedCode,patAge,Medicare,AdmDate,MainDoc,MainNurse,regNo)
			xlsSheet.PrintOut(1, 1, 1, false, "ZHIXINGDAN", false, false)
			ClearInfo(xlsSheet);
		}		
	}
	xlsSheet = null;
	xlsBook.Close(savechanges=false);
	xlsBook = null;
	xlsExcel.Visible =false
	xlsExcel.Application.Quit();
	xlsExcel=null;
}

function printClickByXML()
{
	var tableData=document.getElementById("tDHCNurIpPrintInfo");
	var selectFlag=0
	for(var i=1;i<tableData.rows.length;i++)
	{
		if(document.getElementById("Selectz"+i).checked==true)
		{
			selectFlag=1
		}
	}
	if(selectFlag==0){
		alert("请选中病人")
		return;
	}
	var bedCode,patName,Medicare,patAge,patSex,AdmDate,food,other;

	
	SavePrintRecord();  ///输出前调用
	
	for(var i=1;i<tableData.rows.length;i++)
	{
		if(document.getElementById("Selectz"+i).checked==true)
		{
			//科别,入院时间,住院号,床号,姓名,性别,年龄,诊断,单位
			patName=document.getElementById("patNamez"+i).innerText;
			patSex=document.getElementById("patSexz"+i).innerText;
			bedCode=document.getElementById("bedCodez"+i).innerText;
			patAge=document.getElementById("patAgez"+i).innerText;
			regNo=document.getElementById("RegNoz"+i).innerText;		
		    Medicare=document.getElementById("Medicarez"+i).innerText;
			AdmDate=document.getElementById("AdmDatez"+i).innerText;
			MainDoc=document.getElementById("MainDocz"+i).innerText;
			MainNurse=document.getElementById("MainNursez"+i).innerText;
			
			var params = patName+"$"+patSex+"$"+bedCode+"$"+patAge+"$"+regNo+"$"+Medicare+"$"+AdmDate+"$"+MainDoc+"$"+MainNurse
			

			//DHCCNursePrintComm.
			showOtherSingleSheet(params, "BedCard", session['WebIP'], "NurseBedCard.xml");
	
		
		}		
	}
}
function ClearInfo(xlsSheet)
{
	AddPatInfo(xlsSheet,"","","","","","","","",""); //by pan

}
function ClearInfo1(xlsSheet)
{
	AddPatInfo1(xlsSheet,"","");

}
function AddPatInfoOld(xlsSheet,printLocation,bedCode,patName,Medicare,patAge,patSex,AdmDate,food,other)
{
	xlsSheet.Cells(printLocation*4-2,2)=bedCode;
	xlsSheet.Cells(printLocation*4-2,4)=patName;
	xlsSheet.Cells(printLocation*4-2,6)=Medicare;
	xlsSheet.Cells(printLocation*4-1,2)=patAge;
	xlsSheet.Cells(printLocation*4-1,4)=patSex;
	xlsSheet.Cells(printLocation*4-1,6)=AdmDate;
	xlsSheet.Cells(printLocation*4,2)=food;
	xlsSheet.Cells(printLocation*4,6)=other;
	
}
function AddPatInfo(xlsSheet,patName,patSex,patAge,regNo,AdmDate,MainDoc,MainNurse,BarregNo)
{
	//xlsSheet.Cells(2,1)="姓名:";
	//xlsSheet.Cells(3,1)="性别:";
	//xlsSheet.Cells(4,1)="年龄:";
	//xlsSheet.Cells(5,1)="病人ID:";
	//xlsSheet.Cells(6,1)="病案号:";
	//xlsSheet.Cells(6,1)="入院日期:";
	//xlsSheet.Cells(7,1)="主管医生:";
	//xlsSheet.Cells(8,1)="主管护士:";
	
	xlsSheet.Cells(2,2)=patName;
	xlsSheet.Cells(3,2)=patSex;
	xlsSheet.Cells(4,2)=patAge;
	xlsSheet.Cells(5,2)=regNo;
	//xlsSheet.Cells(6,2)=Medicare;
	xlsSheet.Cells(6,2)=AdmDate;
	xlsSheet.Cells(8,2)=MainDoc;
	xlsSheet.Cells(7,2)=MainNurse;
	//xlsSheet.Cells(5,3)="REG"+BarregNo; //by pan 
	
	
}
function PrintPatInfo()
{
	//alert(1);
	var xlsExcel,xlsBook,xlsSheet;
	var patName,Medicare;
	var printLocation=0;
	var GetPath=document.getElementById("GetPath").value;
	var Path=cspRunServerMethod(GetPath);
	Path=Path+"PatInfo1.xls";
	xlsExcel=new ActiveXObject("Excel.application");
	xlsBook=xlsExcel.WorkBooks.Add(Path);
	xlsSheet=xlsBook.ActiveSheet;
	var tableData=document.getElementById("tDHCNurIpPrintInfo");
	for(var i=1;i<tableData.rows.length;i++)
	{
		if(document.getElementById("Selectz"+i).checked==true)
		{
			//科别,入院时间,住院号,床号,姓名,性别,年龄,诊断,单位
			patName=document.getElementById("patNamez"+i).innerText;
			Medicare=document.getElementById("Medicarez"+i).innerText;
			patSex=document.getElementById("patSexz"+i).innerText;
			patAge=document.getElementById("patAgez"+i).innerText;
			AdmDate=document.getElementById("AdmDatez"+i).innerText;
			
			//printLocation++;
			//AddPatInfoOld(xlsSheet,printLocation,bedCode,patName,Medicare,patAge,patSex,AdmDate,food,other)		
			AddPatInfo1(xlsSheet,patName,Medicare,patSex,patAge,AdmDate)
			xlsSheet.PrintOut(1, 1, 1, false, "ZHIXINGDAN", false, false)
			ClearInfo1(xlsSheet);
		}		
	}
	xlsSheet = null;
	xlsBook.Close(savechanges=false);
	xlsBook = null;
	xlsExcel.Visible =false
	xlsExcel.Application.Quit();
	xlsExcel=null;
}
function AddPatInfo1(xlsSheet,patName,Medicare,patSex,patAge,AdmDate)
{
	//xlsSheet.Cells(2,1)="姓名:";
	//xlsSheet.Cells(3,1)="病案号:";
	
	xlsSheet.Cells(2,2)=patName;
	xlsSheet.Cells(3,2)=Medicare;
    xlsSheet.Cells(4,2)=patSex+" "+patAge;
	xlsSheet.Cells(5,2)=AdmDate;
	
}
function AllergyPatClick()
{
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCNurIPAllergyPat";
   	window.open(lnk,'_blank',"scrollbars=yes,top=0,left=0,width=700,height=600");	
}
function SavePrintRecord()
{
	var tableData=document.getElementById("tDHCNurIpPrintInfo");
	for(var i=1;i<tableData.rows.length;i++)
	{
		if(document.getElementById("Selectz"+i).checked==true)
		{
			patName=document.getElementById("patNamez"+i).innerText;
			patSex=document.getElementById("patSexz"+i).innerText;
			bedCode=document.getElementById("bedCodez"+i).innerText;
			patAge=document.getElementById("patAgez"+i).innerText;
			regNo=document.getElementById("RegNoz"+i).innerText;		
		    Medicare=document.getElementById("Medicarez"+i).innerText;
			AdmDate=document.getElementById("AdmDatez"+i).innerText;
			MainDoc=document.getElementById("MainDocz"+i).innerText;
			MainNurse=document.getElementById("MainNursez"+i).innerText;
			EpisodeID=document.getElementById("EpisodeIDz"+i).value;
			PatientID=document.getElementById("PatientIDz"+i).value;
			SecretCode=document.getElementById("SecretCodez"+i).value;
			var ModelName="DHCNurBedCard"; ///代码demo->系统配置->日志审核及配置
			var ItemNameArr="UserId^PatientID^EpisodeID";
			var ItemValueArr=session['LOGON.USERID']+"^"+PatientID+"^"+EpisodeID;
			var Condition=tkMakeServerCall("web.DHCCLCom","GenToJoson",ItemNameArr,ItemValueArr); ///条件
			ItemNameArr="patName^patSex^bedCode^patAge^regNo^Medicare^AdmDate^MainDoc^MainNurse";
			ItemValueArr=patName+"^"+patSex+"^"+bedCode+"^"+patAge+"^"+regNo+"^"+Medicare+"^"+AdmDate+"^"+MainDoc+"^"+MainNurse;
			var Content=tkMakeServerCall("web.DHCCLCom","GenToJoson",ItemNameArr,ItemValueArr); ///内容
			//alert(Content+"#"+SecretCode)
			//tkMakeServerCall("web.DHCEventLog","EventLog",ModelName, Condition, Content,SecretCode); ///存打印记录
			websys_EventLog(ModelName, Condition, Content,SecretCode); //websys.js存打印记录
		}
	}
	}
	


document.body.onload = BodyLoadHandler;
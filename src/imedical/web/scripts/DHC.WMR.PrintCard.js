
/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.PrintCard.JS

AUTHOR: LiYang , Microsoft
DATE  : 2007-6-8

COMMENT: print patient master index card

========================================================================= */
//var objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter");

var objChineseDic = GetChineseDic("MethodGetChineseDic", "DHC.WMR.PrintCard");





//var objPatient = new Object();

//PrintBlankCard(objPrinter);
//PrintCardContents(objPrinter, DHCWMRHistory());


//print patient master index card
//objPrinter  Printer object
//objPatient paitient base info
function PrintCard(objPrinter, objPatient, objMain)
{
	PrintBlankCard(objPrinter);
	PrintCardContents(objPrinter, objPatient, objMain);
	objPrinter.EndDoc();
}

function GetSpell(PatientName)
{
	var strTmp = "";
	for(var i = 0; i < PatientName.length; i ++)
	{
		strTmp += GetPinYin(PatientName.substr(i, 1)) + "  ";
	}
	return strTmp;
}

//Print Card Contents
function PrintCardContents(objPrinter, objPatient, objMain)
{
	var TopMarge = 1.5;
    var LeftMarge = -1;
    var TopMarge = 1.5;

	var sngTmpPos = 0;
	var strTmp = ""
	
	var intPos = 0;
	var tmpD = ""
	
	objPrinter.Font = objChineseDic.Item("HeiTi");
	objPrinter.FontSize = 18;
	objPrinter.FontBold = true;

    for(var i = 0; i < objPatient.PatientName.length; i ++)
   {
       strTmp +=  objPatient.PatientName.substr(i, 1) + "  ";
  }  

    objPrinter.PrintContents(LeftMarge +1.8 , 1.2, strTmp);		
   
  	objPrinter.FontSize = 32;  
    objPrinter.PrintContents( LeftMarge + 9, 0.95, objMain.MRNO);
  
    
    objPrinter.Font = objChineseDic.Item("SongTi");
   objPrinter.FontSize = 10;
   objPrinter.FontBold  = true;
  
   
    
	objPrinter.PrintContents(LeftMarge + 1.8, 0.6, GetSpell(objPatient.PatientName));
	objPrinter.PrintContents( LeftMarge +1.9, TopMarge  + 0.75, objPatient.Sex);
	objPrinter.PrintContents( LeftMarge + 4, TopMarge  + 0.75, objPatient.Age);	
	objPrinter.PrintContents( LeftMarge + 6.3, TopMarge  + 0.75, objPatient.City);	
	objPrinter.PrintContents(LeftMarge + 1.9, TopMarge  + 1.5, objPatient.Company);
	objPrinter.PrintContents( LeftMarge +  9.5, TopMarge  + 1.5, objPatient.CompanyZip);
	objPrinter.PrintContents( LeftMarge + 1.9, TopMarge  + 2.25, objPatient.HomeAddress);
	objPrinter.PrintContents( LeftMarge +  9.5, TopMarge + 2.25, objPatient.HomeZip);	
	objPrinter.PrintContents( LeftMarge + 7.5, 0.6, objChineseDic.Item("PID")  + objPatient.IdentityCode);
	
	objPrinter.PrintContents( LeftMarge +  2.5, TopMarge + 3, objPatient.Volume.AdmitDate);	
	objPrinter.PrintContents( LeftMarge +  8.5, TopMarge + 0.75, objPatient.Volume.Dep);	
	
}

//´òÓ¡¿Õ°×¿¨Æ¬
function PrintBlankCard(objPrinter)
{
var TopMarge = 1.5;
var LeftMarge = 0;
	objPrinter.PrintContents( LeftMarge + 0, TopMarge + 0, objChineseDic.Item("Name"));
	objPrinter.PrintContents( LeftMarge + 6.5, TopMarge + 0, objChineseDic.Item("MrNo"));

	objPrinter.PrintContents( LeftMarge + 0, TopMarge + 0.8, objChineseDic.Item("Sex"));
	objPrinter.PrintContents( LeftMarge + 2.2, TopMarge + 0.8, objChineseDic.Item("Age"));
	objPrinter.PrintContents( LeftMarge + 4.5, TopMarge + 0.8, objChineseDic.Item("NativePlace"));
	objPrinter.PrintContents( LeftMarge + 6.7, TopMarge + 0.8, objChineseDic.Item("Dep"));

	objPrinter.PrintContents( LeftMarge + 0, TopMarge + 1.5, objChineseDic.Item("Company"));
	objPrinter.PrintContents( LeftMarge + 7, TopMarge + 1.5, objChineseDic.Item("CompanyZip"));

	objPrinter.PrintContents( LeftMarge + 0, TopMarge + 2.3, objChineseDic.Item("Address"));
	objPrinter.PrintContents( LeftMarge + 7, TopMarge + 2.3, objChineseDic.Item("AddressZip"));

	objPrinter.PrintContents( LeftMarge + 0, TopMarge + 3, objChineseDic.Item("AdmitDate"));
	objPrinter.PrintContents( LeftMarge + 6, TopMarge + 3, objChineseDic.Item("DischargeDate"));

	objPrinter.PrintContents( LeftMarge + 0, TopMarge + 3.6, objChineseDic.Item("Diagnose"));



	objPrinter.Line(LeftMarge + 0.8, TopMarge + 0.4, LeftMarge + 6.4, TopMarge + 0.4);
	objPrinter.Line(LeftMarge + 8, TopMarge + 0.4, LeftMarge + 11.5, TopMarge + 0.4);

	objPrinter.Line(LeftMarge + 0.8, TopMarge + 1.15, LeftMarge + 2.2, TopMarge + 1.15);
	objPrinter.Line(LeftMarge + 3, TopMarge + 1.15, LeftMarge + 4.5, TopMarge + 1.15);
	objPrinter.Line( LeftMarge + 5.2, TopMarge + 1.15, LeftMarge + 6.7, TopMarge + 1.15);
	objPrinter.Line( LeftMarge + 7.5, TopMarge + 1.15, LeftMarge + 11.5, TopMarge + 1.15);

	objPrinter.Line( LeftMarge + 0.8, TopMarge + 1.9, LeftMarge + 6.9, TopMarge + 1.9);
	objPrinter.Line( LeftMarge + 8.5, TopMarge + 1.9, LeftMarge + 11.5, TopMarge + 1.9);

	objPrinter.Line( LeftMarge + 0.8, TopMarge + 2.65, LeftMarge + 6.9, TopMarge + 2.65);
	objPrinter.Line( LeftMarge + 8.5, TopMarge + 2.65, LeftMarge + 11.5, TopMarge + 2.65);

	objPrinter.Line( LeftMarge + 1.5, TopMarge + 3.4, LeftMarge + 5.9, TopMarge + 3.4);
	objPrinter.Line( LeftMarge + 7.5, TopMarge + 3.4, LeftMarge + 11.5, TopMarge + 3.4);

	objPrinter.Line( LeftMarge + 1.5, TopMarge + 4.05, LeftMarge + 11.5, TopMarge + 4.05);
	objPrinter.Line( LeftMarge + 1.5, TopMarge + 4.8, LeftMarge + 11.5, TopMarge + 4.8);
}

function ConvertAdm(objAdm)
{
    var obj = new Object();
    if(objAdm != null)
    {
   	obj. AdmitDate = objAdm.AdmDate;
   	obj.Dep= (objAdm.LocDesc.indexOf("/") > -1 ? GetDesc(objAdm.LocDesc, "/") : objAdm.LocDesc);
    }
    else
    {
   	obj. AdmitDate = "";
   	obj.Dep= "";
     }
    return obj;    
}

function ConvertHisAdm(objAdm)
{
    var obj = new Object();
    if(objAdm != null)
    {
   	obj. AdmitDate = objAdm.AdmitDate;
   	obj.Dep= objAdm.AdmitDep;
    }
    else
    {
   	obj. AdmitDate = "";
   	obj.Dep= "";
     }
    return obj;    
}
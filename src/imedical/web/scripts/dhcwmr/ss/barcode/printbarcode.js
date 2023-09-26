
function PrintMrBarCode(MainRowID, VolumeRowID, MrNO, MrType, PatientName, Age, Sex, Birthday, DischDate, PrinterName, BarCodeType)
{
	try
	{
		if(MainRowID != "")
		{
			while(MainRowID.length < 11)
				MainRowID = "0" + MainRowID;
			
			var Bar;
			Bar = new ActiveXObject("DHCMedBarCode.PrintBarMR");
			Bar.PrinterName = PrinterName; //打印机名称
			Bar.PrinterPort = "";       //打印机端口号
			Bar.BarFormat   = BarCodeType;      //设置条码样式编号
			Bar.SetPrinter();           //设置打印机
			
			Bar.vMrType      = MrType;
			Bar.vMrNo        = MrNO;
			Bar.vPatientName = PatientName;
			Bar.vAge         = Age;
			Bar.vSex         = Sex;
			Bar.vBirthday    = Birthday;
			Bar.vDischDate   = '';
			Bar.vBarCode     = "01" + MainRowID;
			Bar.PrintOut();
		}
		
		if(VolumeRowID != "")
		{

			while(VolumeRowID.length < 11)
				VolumeRowID = "0" + VolumeRowID;
				
			var Bar;
			Bar = new ActiveXObject("DHCMedBarCode.PrintBarMR");
			Bar.PrinterName = PrinterName; //打印机名称
			Bar.PrinterPort = "";       //打印机端口号
			Bar.BarFormat   = BarCodeType;      //设置条码样式编号
			Bar.SetPrinter();           //设置打印机
			
			
			Bar.vMrType      = MrType + " 卷";
			Bar.vMrNo        = MrNO;
			Bar.vPatientName = PatientName;
			Bar.vAge         = Age;
			Bar.vSex         = Sex;
			Bar.vBirthday    = Birthday;
			Bar.vDischDate   = DischDate;
			Bar.vBarCode     = "02" + VolumeRowID;
			Bar.PrintOut();
		}
	}catch(err)
	{
	
		if(err.message.indexOf("请确认正确安装") == 0){
			window.alert(err.message);
		}
		
		if(err.message.indexOf("ActiveX") > -1){
			window.alert(err.message + "，没有正确安装条码打印组件，请正确安装！");
		}		
	
		
	}
}
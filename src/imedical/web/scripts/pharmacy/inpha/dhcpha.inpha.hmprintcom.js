/*
模块:		住院草药房
子模块:		住院草药房-住院草药房各种打印相关
Creator:	hulihua
CreateDate:	2017-12-01
*/

var INPHA_PRINTCOM={
		// 处方
		Presc:function(prescNo,zfFlag,prtType){
			if((zfFlag=="")||(zfFlag==null)){
				zfFlag="正方";	
			}
			var prtData=tkMakeServerCall("web.DHCINPHA.Common.Print","PrescPrintData",prescNo,zfFlag,prtType);
			if (prtData=="{}"){
				return;
			}
			var prtJson=JSON.parse(prtData);
			var xmlTrmplate = prtJson.Templet;
			if(!xmlTrmplate){ return; }
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: xmlTrmplate,
				data: prtJson
			});
		}	
}

/**打印公共方法**/
function PrintInphaCom(PrescNo,PhacRowid){
	var prescConfigStr=tkMakeServerCall("web.DHCPHACOM.ComPubClass.HMPrescMethod","GetHMPrescConfig",PrescNo);
	var prescConfigArr=prescConfigStr.split("^");
	//打印处方
	var printPresFlag=prescConfigArr[3];
	if(printPresFlag=="Y"){
		INPHA_PRINTCOM.Presc(PrescNo,"正方","");	
	}
	//打印用药标签
	var printDispSheet=prescConfigArr[4];
	if(printDispSheet=="2"){
		PrintDispSheet(PhacRowid);	
	}
}

//打印中药调剂单，hulihua，2017-12-1	
function PrintDispSheet (phac,ReprintFlag)
{
	if(typeof(ReprintFlag) == "undefined"){
		var ReprintFlag="";
	}else{
		ReprintFlag="【补】";
	}
	var PrintInfoStr=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicPrintMethod","GetPrtDispSheetInfo",phac);
	var PrintArr=PrintInfoStr.split("!!");
	//处方信息
	var PrescInfoStr=PrintArr[0];
	var PatArr=PrescInfoStr.split("^")
	var PhaLocDesc=PatArr[0];
	var PatNo=PatArr[1];
	var PatName=PatArr[2];
	var PadiagNose=PatArr[3];
	var LabelType=PatArr[4];
	var Instruc=PatArr[5];
	var Factor=PatArr[6]+"付";
	var StDate=PatArr[7];
	var PreConfig=PatArr[8];
	var PrescName=PatArr[9];
	var DocLoc=PatArr[10];
	var Doctor=PatArr[11];
	var PrescCount=PatArr[12]+"味";
	var PrescMoney=PatArr[13];
	var PrescNo=PatArr[14];
	var FreqDesc=PatArr[15];
	var DrugInfo=PatArr[16];	//功效（解表类 一般类 滋补类）
	var PrescForm=PatArr[17];  //剂型
	var ChkUser=PatArr[18];  //审核人
	var Ward=PatArr[19];
	var CurBedcode=PatArr[20];
	var PameNo=PatArr[21];
	var CoookType=PatArr[22];
	var OrderQtyDesc=PatArr[23];
	var Title="中药调剂单";		//+ReprintFlag;
	var BarCode= PrescNo	; // "*"+PrescNo+"*"; 
	var OrdInfo=Factor+Instruc+FreqDesc+OrderQtyDesc;
	var Label=LabelType+"【"+CoookType+"】"+PrescForm ;
	var Presc=Factor+PrescCount+" "+Instruc;
	var PrescNameConfig=PrescName+" "+PreConfig ;
	var DottedLine="- —— - —— - —— - —— - —— - —— - —— - —— - —— "
	var Line="——————————————————————————————————————————————————"
	var prtJson={}
	prtJson.Para = {
		"OrdInfo":OrdInfo,
		"Title":Title,
		"ReprintFlag":ReprintFlag,
		"BarCode":BarCode,
		"LabelType":LabelType,
		"PhaLocDesc":PhaLocDesc, 
		"StDate":StDate,
		"PatNo":PatNo,
		"DocLoc":DocLoc,
		"PatName":PatName,
		"PadiagNose":PadiagNose,
		"Factor":Factor,
		"PrescCount":PrescCount,
		"Instruc":Instruc,
		"PreConfig":PreConfig,
		"PrescName":PrescName,
		"PrescForm":PrescForm,
		"DrugInfo":DrugInfo,
		"Doctor":Doctor,
		"PrescNo":PrescNo,
		"ChkUser":ChkUser,
		"Ward":Ward,
		"PameNo":PameNo,
		"CurBedcode":CurBedcode, 
		"DottedLine":DottedLine, 
		"CoookType":CoookType, 
		"Label":Label, 
		"Line":Line, 
		"Presc":Presc, 
		"PrescNameConfig":PrescNameConfig  
	}
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "DHCInPhaDispSheetLabel",
		data: prtJson
	});
}

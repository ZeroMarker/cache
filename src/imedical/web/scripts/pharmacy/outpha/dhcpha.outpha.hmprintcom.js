/*
ģ��:		�����ҩ��
��ģ��:		�����ҩ��-�����ҩ�����ִ�ӡ���
Creator:	MaYuqiang
CreateDate:	2020-06-30
*/


var HMOUTPHA_PRINTCOM = {
	// ����
	Presc: function (prescNo, zfFlag, prtType) {
		if ((zfFlag == "") || (zfFlag == null)) {
			zfFlag = "����";
		}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "PrescPrintData", prescNo, zfFlag, prtType,"5");
		if (prtData == "{}") {
			return;
		} else if (prtData == "-1") {
			dhcphaMsgBox.alert(prescNo + "Ϊȫ�˴����������ӡ!");
		} else {
			var xmlTrmplate=tkMakeServerCall("PHA.OP.COM.Print", "GetPrintTemplate", prescNo, 2);
			if (xmlTrmplate == "") {
				return;
			}
			var prtJson = JSON.parse(prtData);
			
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: xmlTrmplate,
				data: prtJson
			});

		}

	}
}

/**��ӡ��������**/
function PrintOutphaCom(PrescNo,Phd){
	var prescConfigStr=tkMakeServerCall("web.DHCPHACOM.ComPubClass.HMPrescMethod","GetHMPrescConfig",PrescNo);
	var prescConfigArr=prescConfigStr.split("^");
	//��ӡ����
	var printPresFlag=prescConfigArr[3];
	if(printPresFlag=="Y"){
		HMOUTPHA_PRINTCOM.Presc(PrescNo,"����","");	
	}
	//��ӡ��ҩ��ǩ
	var printDispSheet=prescConfigArr[4];
	if(printDispSheet=="2"){
		PrintDispSheet(Phd);	
	}
}

//��ӡ��ҩ������	
function PrintDispSheet (phd,ReprintFlag)
{
	if(typeof(ReprintFlag) == "undefined"){
		var ReprintFlag="";
	}else{
		ReprintFlag="������";
	}
	var PrintInfoStr=tkMakeServerCall("web.DHCOUTPHA.Common.Print","GetPrtDispSheetInfo",phd);
	var PrintArr=PrintInfoStr.split("!!");
	//������Ϣ
	var PrescInfoStr=PrintArr[0];
	var PatArr=PrescInfoStr.split("^")
	var PhaLocDesc=PatArr[0];
	var PatNo=PatArr[1];
	var PatName=PatArr[2];
	var PadiagNose=PatArr[3];
	var LabelType=PatArr[4];
	var Instruc=PatArr[5];
	var Factor=PatArr[6]+"��";
	var StDate=PatArr[7];
	var PreConfig=PatArr[8];
	var PrescName=PatArr[9];
	var DocLoc=PatArr[10];
	var Doctor=PatArr[11];
	var PrescCount=PatArr[12]+"ζ";
	var PrescMoney=PatArr[13];
	var PrescNo=PatArr[14];
	var FreqDesc=PatArr[15];
	var DrugInfo=PatArr[16];	//��Ч������� һ���� �̲��ࣩ
	var PrescForm=PatArr[17];  //����
	var ChkUser=PatArr[18];  //�����
	var Ward=PatArr[19];
	var CurBedcode=PatArr[20];
	var PameNo=PatArr[21];
	var CoookType=PatArr[22];
	var OrderQtyDesc=PatArr[23];
	var Title="��ҩ������";		//+ReprintFlag;
	var BarCode=PrescNo	;	//"*"+PrescNo+"*";
	var OrdInfo=Factor+Instruc+FreqDesc+OrderQtyDesc;
	var Label=LabelType+"��"+CoookType+"��"+PrescForm
	var Presc=Factor+PrescCount+" "+Instruc;
	var PrescNameConfig=PrescName+" "+PreConfig
	var DottedLine="- ���� - ���� - ���� - ���� - ���� - ���� - ���� - ���� - ���� "
	var Line="����������������������������������������������"
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
		XMLTemplate: "DHCOutDispSheetLabel",
		data: prtJson
	});
}

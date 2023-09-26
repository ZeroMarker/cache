/*
模块:		移动药房
子模块:		移动药房-移动药房各种打印相关
Creator:	hulihua
CreateDate:	2017-03-21
*/

//打印请领单固化时的标签，hulihua，2017-03-21
function PrintInPhLabel(PrintInfoStr,InPhReqConNo)
{
	var MyPara="";
	var MyList="";
	//
	var printarr=PrintInfoStr.split("^");
	var phreqtype=printarr[0];
	var wardloc=printarr[1];
	var connodate=printarr[2];
	var disploc=printarr[3];
	var printtime=getPrintDateTime();
	var title=disploc+"请领单标签";
	var barcode="*"+InPhReqConNo+"*";
	//
	MyPara=MyPara+"Title"+String.fromCharCode(2)+title;
	MyPara=MyPara+"^BarCode"+String.fromCharCode(2)+barcode;
	MyPara=MyPara+"^PhReqType"+String.fromCharCode(2)+phreqtype;
	MyPara=MyPara+"^PhReqConNo"+String.fromCharCode(2)+InPhReqConNo;
	MyPara=MyPara+"^DispLoc"+String.fromCharCode(2)+disploc; 
	MyPara=MyPara+"^WardLoc"+String.fromCharCode(2)+wardloc;
	MyPara=MyPara+"^ConNoDate"+String.fromCharCode(2)+connodate;
	MyPara=MyPara+"^PrintTime"+String.fromCharCode(2)+printtime;
	//			
	DHCSTGetXMLConfig("DHCInPhaReqLabel");      
	DHCSTPrintFun(MyPara,MyList);
}

//打印封箱标签XML版本，hulihua，2017-04-26
function PrintPhBoxLabelXML(PrintLabelInfo)
{
	var printarr=PrintLabelInfo.split("^");
	var PhbNum=printarr[1];
	for (i=1;i<=PhbNum;i++)
	{
		var MyPara="";
		var MyList="";
		//
		var PhbNo=printarr[0];
		var PhbNum=printarr[1];
		var WardLoc=printarr[2];
		var CreateDate=printarr[3];
		var InciNum=printarr[4]+"笔";
		var PbBoxNum=printarr[5];
		var BarCode="*"+PhbNo+"*";
		var Title="";
		var PbBoxInfo=i+"/"+PhbNum+"箱--"+PbBoxNum+"批";
		//
		MyPara=MyPara+"Title"+String.fromCharCode(2)+Title;
		MyPara=MyPara+"^BarCode"+String.fromCharCode(2)+BarCode;
		MyPara=MyPara+"^CreateDate"+String.fromCharCode(2)+CreateDate;
		MyPara=MyPara+"^WardLoc"+String.fromCharCode(2)+WardLoc;
		MyPara=MyPara+"^PbBoxInfo"+String.fromCharCode(2)+PbBoxInfo; 
		MyPara=MyPara+"^InciNum"+String.fromCharCode(2)+InciNum;
		//			
		DHCSTGetXMLConfig("DHCInPhBoxLabel");      
		DHCSTPrintFun(MyPara,MyList);
	}
	return;
}

//打印揭药室封箱标签LODOP
function PrintHmPhBoxLabelL(phboxid,RePrintFlag) 
{
	var PhbNum=tkMakeServerCall("web.DHCINPHA.MTBinBox.BinBoxQuery","GetPhBoxNum",phboxid);
	if(PhbNum==0){
		return;
	}
	var LabNum=parseInt(PhbNum)*2;		//签数
	var LabData=tkMakeServerCall("web.DHCINPHA.MTBinBox.BinBoxQuery","GetPrintHMPhBoxInfoL",phboxid);
	if(LabData==""){
		return;
	}
	var LabelArr=LabData.split("^");
	var PbBoxInfo=LabelArr[0];
	var WardLoc=LabelArr[1];
	if(RePrintFlag=="1"){
		WardLoc=WardLoc+"  [补]";
	}
	var CreateDate=LabelArr[2];
	var InciNum=LabelArr[3];
	var LODOP=getLodop();       
	for (i=1;i<=LabNum;i++)
	{
		var params=phboxid+"^"+i;
		var LabInfoData=tkMakeServerCall("web.DHCINPHA.MTBinBox.BinBoxQuery","GetPrintHMNumberAndNo",params);
		var LabInfoArr=LabInfoData.split("^");
		var BarCode=LabInfoArr[0];
		var PhBoxNumber=LabInfoArr[1];
		var LabPbBoxInfo=PhBoxNumber+PbBoxInfo;
		LODOP.PRINT_INIT("揭药封箱签");               
		LODOP.SET_PRINT_STYLE("FontSize",11);
		LODOP.ADD_PRINT_BARCODE(8,20,50,166,"93Extended",BarCode);
		LODOP.SET_PRINT_STYLEA(0,"Angle",-90);       
		LODOP.ADD_PRINT_TEXT(10,80,"100%",25,CreateDate);       
		LODOP.SET_PRINT_STYLEA(2,"FontName","隶书");       
		LODOP.SET_PRINT_STYLEA(2,"FontSize",15);		       
		LODOP.ADD_PRINT_TEXT(60,80,"100%",20,WardLoc);         
		LODOP.ADD_PRINT_TEXT(110,80,"100%",20,LabPbBoxInfo);
		LODOP.ADD_PRINT_TEXT(160,80,"100%",20,InciNum);
		LODOP.ADD_PRINT_BARCODE(8,190,50,166,"93Extended",BarCode);
		LODOP.SET_PRINT_STYLEA(0,"Angle",90);
		LODOP.PRINT();
		//LODOP.PREVIEW();
	}
	return;
}

//DHCOPPrtCommon.js
var OrderPrescInfo = new Array();
var OrderPriceInfo = new Array();
//打印处方草药 
function PrintPrescCY(prescno, PreFlag,ReportData) {
   
        var totalmoney = 0;
        var phl = ""
        var prt = ""
        var zf = ''
        var MyList = "";
        var tmparr = ReportData.split("!!")
        var patinfo = tmparr[0]
        var ordinfo = tmparr[1]
        var patarr = patinfo.split("^")
        var Quefac = patarr[26]
        var Queinst = patarr[25]
        var AdmDepDesc = patarr[23]
        var Queqty = patarr[27]
        var PatH = patarr[5];
        var ReclocDesc = patarr[11];
        var PyName = patarr[6];
        var FyName = patarr[7];
        var FyDate = patarr[8];
        var NewPrescNo = patarr[15];
        var PatNo = patarr[0];
        var Patloc = patarr[16];
        var PatientName = patarr[1];
        var PatientSex = patarr[2];
        var Doctor = patarr[24];
        var PatientAge = patarr[3];
        var Patcall = patarr[18];
        var Pataddress = patarr[19];
        var OrdDate = patarr[31];
        var Quecook = patarr[20];
        var Diag = patarr[4];
        var PayDate = patarr[32]
        var PrtDate = patarr[10]
        var barcode = "" //"*"+PrescNo+"*"
        var DMFlag = patarr[22]
        if (DMFlag != "") var DMFlag = '[' + DMFlag + ']'
        var BillFlag = patarr[33]
        var BillFlag = '[' + BillFlag + ']'
        var TelNo = patarr[18]
        var BillAuditFlag = patarr[34]
		var AdmDate=patarr[13]
 		var PoliticalLevel = patarr[36]
 		var HosName=patarr[38]+"处方笺" 
 		var PAAdmBed=patarr[42]	
        var ordarr = ordinfo.split("@")
        var OrdRows = ordarr.length
        var pc = new Array(new Array(), new Array());
        var priceArr = new Array(new Array(), new Array());
        for (i = 0; i < OrdRows; i++) {

            var ordstr = ordarr[i];
            var SStr = ordstr.split("^")
            pc[i] = new Array();
            priceArr[i]=new Array();
            var OrderName = SStr[0]
            var Quenote = SStr[12]
            var Queuom = SStr[2]
            var Oneqty = parseFloat(SStr[3]) //parseFloat(SStr[1]) / parseFloat(Quefac)
            var Price = parseFloat(SStr[7])
            var money = SStr[8]
            var OverQtyInfo = SStr[15]
            totalmoney = totalmoney + parseFloat(money); //金额

            pc[i][1] = OrderName + "" + Oneqty.toString() + Queuom + " " + Quenote //+" "+Price
            priceArr[i][1] = Price
            pc[i][2] = OverQtyInfo
        }
        
        var singlemoney = (totalmoney / parseFloat(Quefac)).toFixed(2)
        var totalmoney = totalmoney.toFixed(2);

        var FacInfo = "共" + Quefac + "剂" + " " + "用法:" + Queinst + "  一次用量:" + Queqty
        var MoneyInfo = "一付金额:" + singlemoney + "  合计金额:" + totalmoney

        var MyPara = "";
        var MyList = ""

        var m = 0;
        var PrescTitle = ""
        var PatientMedicareNo = ""
        var BillType = ""
        var PoisonClass = ""
        var MRNo = ""
        OrderPrescInfo = []; 
        OrderPriceInfo =[];
        OrderPrescInfo['PatLoc'] = Patloc;
        OrderPrescInfo['PatNo'] = PatNo;
        OrderPrescInfo['AdmDate'] = AdmDate;
        OrderPrescInfo['PatName'] = PatientName;
        OrderPrescInfo['PatSex'] = PatientSex;
        OrderPrescInfo['PatAge'] = PatientAge;
        OrderPrescInfo['PatICD'] = Diag;
        OrderPrescInfo['YFSM'] = FacInfo;
        OrderPrescInfo['TotalMoney'] = MoneyInfo;
        OrderPrescInfo['PrescType'] = BillFlag;
 		OrderPrescInfo['PoliticalLevel'] = PoliticalLevel;
        if (PAAdmBed!="") OrderPrescInfo['PAAdmBed'] = "床号:"+PAAdmBed;
        OrderPrescInfo['PrescTitle'] = PrescTitle;
        //MyPara = MyPara + '^zf' + String.fromCharCode(2) + zf;
        OrderPrescInfo['zf'] = zf;
        //MyPara = MyPara + '^PresType' + String.fromCharCode(2) + '处方笺';
        OrderPrescInfo['PresType'] = '处方笺';
        //MyPara = MyPara + '^PatientMedicareNo' + String.fromCharCode(2) + PatientMedicareNo;
        OrderPrescInfo['PatientMedicareNo'] = PatientMedicareNo;
        //MyPara = MyPara + '^PrescNo' + String.fromCharCode(2) + PrescNo;
        OrderPrescInfo['PrescNo'] = "*"+NewPrescNo+"*";
        OrderPrescInfo['CPrescNo'] = NewPrescNo
        //MyPara = MyPara + '^MRNo' + String.fromCharCode(2) + MRNo;
        OrderPrescInfo['MRNo'] = MRNo;
        //MyPara = MyPara + '^PANo' + String.fromCharCode(2) + PatNo;
        OrderPrescInfo['PANo'] = PatNo;
        //MyPara = MyPara + '^RecLoc' + String.fromCharCode(2) + ReclocDesc;
        OrderPrescInfo['RecLoc'] = ReclocDesc;
        //MyPara = MyPara + '^Name' + String.fromCharCode(2) + PatientName;
        OrderPrescInfo['PatName'] = PatientName;
        //MyPara = MyPara + '^Sex' + String.fromCharCode(2) + PatientSex;
        OrderPrescInfo['Sex'] = PatientSex;
        //MyPara = MyPara + '^Age' + String.fromCharCode(2) + PatientAge;
        OrderPrescInfo['Age'] = PatientAge;
        //MyPara = MyPara + '^Address' + String.fromCharCode(2) + Pataddress;
        OrderPrescInfo['Address'] = Pataddress;
        //MyPara = MyPara + '^AdmDep' + String.fromCharCode(2) + AdmDepDesc;
        OrderPrescInfo['AdmDep'] = AdmDepDesc;
        //MyPara = MyPara + '^PatH' + String.fromCharCode(2) + PatH;
        OrderPrescInfo['PatH'] = PatH;
        //MyPara = MyPara + '^PyName' + String.fromCharCode(2) + PyName;
        OrderPrescInfo['PyName'] = PyName;
        //MyPara = MyPara + '^FyName' + String.fromCharCode(2) + FyName;
        OrderPrescInfo['FyName'] = FyName;
        //MyPara = MyPara + '^Barcode' + String.fromCharCode(2) + barcode;
        OrderPrescInfo['Barcode'] = barcode;
        //MyPara = MyPara + '^OrdDate' + String.fromCharCode(2) + OrdDate;
        OrderPrescInfo['OrdDate'] = OrdDate;
        //MyPara = MyPara + '^PayDate' + String.fromCharCode(2) + PayDate;
        OrderPrescInfo['PayDate'] = PayDate;
        //MyPara = MyPara + '^PrtDate' + String.fromCharCode(2) + PrtDate;
        OrderPrescInfo['PrtDate'] = PrtDate;
        //MyPara = MyPara + '^DMFlag' + String.fromCharCode(2) + DMFlag;
        OrderPrescInfo['DMFlag'] = DMFlag;
        //MyPara = MyPara + '^BillFlag' + String.fromCharCode(2) + BillFlag;
        OrderPrescInfo['BillFlag'] = BillFlag;
        //MyPara = MyPara + '^TelNo' + String.fromCharCode(2) + TelNo;
        OrderPrescInfo['TelNo'] = TelNo;
        //MyPara = MyPara + '^PrtRemark' + String.fromCharCode(2) + "说明:药品名称前有";
        OrderPrescInfo['PrtRemark'] = "说明:药品名称前有";
        //MyPara = MyPara + '^PrtRemark1' + String.fromCharCode(2) + String.fromCharCode(9650) + "表示需皮试药品";
        OrderPrescInfo['PrtRemark1'] = String.fromCharCode(9650) + "表示需皮试药品";
        //MyPara = MyPara + '^BillAuditFlag' + String.fromCharCode(2) + BillAuditFlag
        OrderPrescInfo['BillAuditFlag'] = BillAuditFlag;
        //MyPara = MyPara + '^Sum' + String.fromCharCode(2) + totalmoney + '元';
        OrderPrescInfo['Sum'] =  totalmoney + '元';
        //MyPara = MyPara + '^UserAddName' + String.fromCharCode(2) + Doctor;
        OrderPrescInfo['UserAddName'] = Doctor;
        //MyPara = MyPara + "^FacInfo" + String.fromCharCode(2) + FacInfo;
        OrderPrescInfo['FacInfo'] = FacInfo;
        //MyPara = MyPara + "^MoneyInfo" + String.fromCharCode(2) + MoneyInfo;
        OrderPrescInfo['MoneyInfo'] = MoneyInfo;
  		OrderPrescInfo['BillType'] = BillFlag;
  		OrderPrescInfo['HosName']=HosName
  		var SerialNo=tkMakeServerCall("User.PAQue1PrtSerial","GetPrtSerial",NewPrescNo,"");
        if (SerialNo!=""){
	    	OrderPrescInfo['PrescSerialNo']=SerialNo;   
	    }
        var DiagnoseArray = Diag.split(",")
        var DiagnoseArrayLen = DiagnoseArray.length
        var intLen = 8
        for (var i = 0; i < DiagnoseArrayLen; i++) {

            ss = DiagnoseArray[i]
            strContent = DiagnoseArray[i]

            var m = m + 1;
            var diaglen = DiagnoseArray[i].length

            if (diaglen > 8) {

                while (strContent.length > intLen) {

                    strTemp = strContent.substr(0, intLen);
                    //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + strTemp;
                    OrderPrescInfo['Diagnose' + m] = strTemp;
                    m = m + 1
                    strContent = strContent.substr(intLen, strContent.length);

                }

                //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + strContent;
                OrderPrescInfo['Diagnose' + m] = strContent;

            }
            else {
                //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + ss;
                OrderPrescInfo['Diagnose' + m] = ss;
            }

        }


        var k = 0;

        for (k = 1; k < OrdRows + 1; k++) {
            var l = 0;
            for (l = 1; l < 2; l++) {

                //MyPara = MyPara + "^txt" + k + l + String.fromCharCode(2) + pc[k - 1][l];
                OrderPrescInfo['txt' + k + l] = pc[k - 1][l];
                OrderPriceInfo['txt' + k + 3]=priceArr[k-1][1] 
                OrderPrescInfo['txt' + k + 4]=pc[k - 1][2]
            }
        }


        //DHCP_GetXMLConfig(XMLElementName, "DHCOutPrescCY");


        //var myobj = document.getElementById("ClsBillPrint");
        //DHCP_PrintFun(myobj, MyPara, MyList);
    
    return 0;
}

//读取报表模板
function OpenReport(ReportId,callBack) {
    if(ReportId == ""){
		return;
    }
    var param = [{ name: 'ExcuteAction', value: 'ReadOne' }, { name: 'reportID', value: ReportId}];
    //读取报表
    jQuery.ajax({
        type: 'POST',
        url: accessURL,
        data: param,
        dataType: 'text',
        success: function(data) {
	        if (typeof callBack=="function"){
		    	callBack(data);
		    }
            //showDesinerFromXml(data);
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert("获取报表失败!");
        }
    });
}

function PrintOnePrescCY(PrescNo,para2,flag1,flag2){
	var MyParaStr="";
	var MyListStr="";
	var PrescNo=OrderPrescInfo['CPrescNo'];
    if (OrderPrescInfo.hasOwnProperty("PrescSerialNo")){
		var SerialNo=OrderPrescInfo['PrescSerialNo'];
	}else{
	    var SerialNo=tkMakeServerCall("User.PAQue1PrtSerial","GetPrtSerial",PrescNo,"");
		if (SerialNo==""){
			SerialNo=tkMakeServerCall("User.PAQue1PrtSerial","InsertPrtSerial",PrescNo,"",session['LOGON.USERID']);
		}
		OrderPrescInfo['PrescSerialNo']=SerialNo;
	}
	
	
	for (x in OrderPrescInfo) {
		if (x=="indexOf") continue;
		if (typeof(x)=="function") continue;
		if (MyParaStr=="") {
			MyParaStr = x + String.fromCharCode(2) + OrderPrescInfo[x];
		}else{
			MyParaStr = MyParaStr + '^' + x + String.fromCharCode(2) + OrderPrescInfo[x];
		}
	}
	var NewPrescNo=OrderPrescInfo["PrescNo"];
	//DHCP_GetXMLConfig("XMLObject","DHCOutPrescCY");
	var myobj = document.getElementById("ClsBillPrint");
	if(flag1=="Y"){
		//var MyParaStr=MyParaStr+"^"+"ZDF"+String.fromCharCode(2)+"[正方]"
		DHCP_PrintFun(myobj, MyParaStr+"^"+"ZDF"+String.fromCharCode(2)+"[正方]", MyListStr);
	}
	if(flag2=="Y"){
		for (x in OrderPriceInfo) {
			if (x=="indexOf") continue;
			if (typeof(x)=="function") continue;
			if (MyParaStr=="") {
				MyParaStr = x + String.fromCharCode(2) + OrderPriceInfo[x];
			}else{
				MyParaStr = MyParaStr + '^' + x + String.fromCharCode(2) + OrderPriceInfo[x];
			}
		}
		
		//var MyParaStr=MyParaStr+"^"+"ZDF"+String.fromCharCode(2)+"[底方]"
		DHCP_PrintFun(myobj, MyParaStr+"^"+"ZDF"+String.fromCharCode(2)+"[底方]", MyListStr);
	}
	
	
}
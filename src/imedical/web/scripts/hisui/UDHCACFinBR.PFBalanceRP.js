/// UDHCACFinBR.PFBalanceRP.js

$(function () {
	initStyle();
    
    $HUI.linkbutton("#Print", {
		onClick: function () {
			PrintClick();
		}
	});
	
    ReadData();
});

function ReadData() {
	$.m({
		ClassName: "web.UDHCACFinBRRSQuery",
		MethodName: "ReadACDFootData",
		PFRowID: getValueById("PFRowID")
	}, function(rtn) {
		var myAry = rtn.split(String.fromCharCode(3));
		var myAccAry = myAry[1].split("^");
		setValueById("PFBLastDate", myAccAry[0]);
        setValueById("PFBLastTime", myAccAry[1]);
        setValueById("PFBCurrentDate", myAccAry[2]);
        setValueById("PFBCurrentTime", myAccAry[3]);
        setValueById("LastPDLeft", myAccAry[4]);
        setValueById("PDIncomeSum", myAccAry[5]);
        setValueById("PDReturnSum", myAccAry[6]);
        setValueById("AccPaySum", myAccAry[7]);
        setValueById("PDLeft", myAccAry[8]);
        setValueById("RoundSum", myAccAry[9]);
        //setValueById("PrtAccPaySum", myAccAry[9]);
        //setValueById("NOPrtAccPaySum", myAccAry[10]);
	});
}

function PrintClick() {
    var APFRowID = getValueById("PFRowID");
    var myPFBLastDate = getValueById("PFBLastDate") + " " + getValueById("PFBLastTime");
    var myPFBCurrentDate = getValueById("PFBCurrentDate") + " " + getValueById("PFBCurrentTime");
    var fileName = "DHCBILL-OPBILL-YJJSRHZ.rpx&APFRowID=" + APFRowID + "&myPFBLastDate=" + myPFBLastDate;
    fileName += "&myPFBCurrentDate=" + myPFBCurrentDate;
    var width = window.screen.width * 0.6;
    var height = window.screen.height * 0.5;
    DHCCPM_RQPrint(fileName, width, height);
}

function initStyle() {
	$(document.body).css("padding", "0");
	$('label').css({"margin-right": "8px"});
	$('td.CellData').css("padding", "0px");
	$('td.CellData>table').css("border-spacing", "0px 7px");
}
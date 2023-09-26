/**
 *  读卡公共 JS bianshuai 2020-03-20
 */

var PatObj = {
	'PatientID': '',
	'PatNo': '',
	'CardNo': '',
}
function Inv_ReadCardCom( fn ){
	
    DHCACC_GetAccInfo7(CardTypeCallBack);
	typeof fn === "function" ? fn( PatObj ) : ""; 	/// 回调函数
}

/**
 *  读卡回调函数
 */
function CardTypeCallBack(rtn) {
	
    var readRetArr = rtn.split("^");
    var readRtn = readRetArr[0];
    switch (readRtn) {
        case "0":
            //卡有效
            PatObj.PatientID = readRetArr[4];
            PatObj.PatNo = readRetArr[5];
            PatObj.CardNo = readRetArr[1];
            break;
        case "-200":
            $.messager.alert('错误提示',"卡无效!","warning");
            break;
        case "-201":
            //现金
            PatObj.PatientID = readRetArr[4];
            PatObj.PatNo = readRetArr[5];
            PatObj.CardNo = readRetArr[1];
            break;
        default:
    }
}
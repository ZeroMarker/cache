/**
 *  �������� JS bianshuai 2020-03-20
 */

var PatObj = {
	'PatientID': '',
	'PatNo': '',
	'CardNo': '',
}
function Inv_ReadCardCom( fn ){
	
    DHCACC_GetAccInfo7(CardTypeCallBack);
	typeof fn === "function" ? fn( PatObj ) : ""; 	/// �ص�����
}

/**
 *  �����ص�����
 */
function CardTypeCallBack(rtn) {
	
    var readRetArr = rtn.split("^");
    var readRtn = readRetArr[0];
    switch (readRtn) {
        case "0":
            //����Ч
            PatObj.PatientID = readRetArr[4];
            PatObj.PatNo = readRetArr[5];
            PatObj.CardNo = readRetArr[1];
            break;
        case "-200":
            $.messager.alert('������ʾ',"����Ч!","warning");
            break;
        case "-201":
            //�ֽ�
            PatObj.PatientID = readRetArr[4];
            PatObj.PatNo = readRetArr[5];
            PatObj.CardNo = readRetArr[1];
            break;
        default:
    }
}
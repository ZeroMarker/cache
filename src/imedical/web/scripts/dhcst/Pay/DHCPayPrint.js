// /����: �����ӡ
// /����: �����ӡ
// /��д�ߣ�zhangxiao
// /��д����: 2013.6.15

/*
 * creator:zhangxiao,2013-06-15
 * description:��ӡ�����������Ǭ��
 * params: ingr:�������id
 * return:*/

 
function PrintPay(pay){
	if(pay==null||pay==''){
		return;
		}
	var mainData=GetMainData(pay);	
	if(mainData==null || mainData==""){
		return;
	}	
	var mainArr=mainData.split("^");
	var Vendor=mainArr[1]
    var payNo=mainArr[0]
    var payDate=mainArr[4]
    var payTime=mainArr[5]
    var payLoc=mainArr[2]
    var userName=mainArr[3]
    var ack1UserName=mainArr[14]  //�ɹ�ȷ��
    var ack2UserName=mainArr[15]   //���ȷ��
    //ֱ�Ӵ�ӡ
    var RQDTFormat=App_StkRQDateFormat;  //+" "+App_StkRQTimeFormat;
    //fileName="{DHCST_Pay_Common.raq(pay="+pay+";Vendor="+Vendor+";payNo="+payNo+";payDate="+payDate+";payTime="+payTime+";payLoc="+payLoc+";userName="+userName+";ack1UserName="+ack1UserName+";ack2UserName="+ack2UserName+";HospDesc="+App_LogonHospDesc+";RQDTFormat="+RQDTFormat+")}";
	fileName="{DHCST_Pay_Common.raq(pay="+pay+";RQDTFormat="+RQDTFormat+")}";  //";Vendor="+Vendor+";payNo="+payNo+";payDate="+payDate+";payTime="+payTime+";payLoc="+payLoc+";userName="+userName+";ack1UserName="+ack1UserName+";ack2UserName="+ack2UserName+";HospDesc="+App_LogonHospDesc+";RQDTFormat="+RQDTFormat+")}";

	
	DHCCPM_RQDirectPrint(fileName);
	//Ԥ����ӡ
	//fileName="DHCST_Pay_Common.raq&pay="+pay+"&Vendor="+Vendor+"&payNo="+payNo+"&payDate="+payDate+"&payTime="+payTime+"&payLoc="+payLoc+"&userName="+userName+"&ack1UserName="+ack1UserName+"&ack2UserName="+ack2UserName+"&HospDesc="+App_LogonHospDesc+"&RQDTFormat="+RQDTFormat;
	//DHCCPM_RQPrint(fileName)
	
	}
	
	/*
 * creator:zhangxiao,2013-06-15
 * description:ȡ����������Ϣ
 * params: ingr:��������id
 * return:
 * */
function GetMainData(pay){
	var mainData="";
	if(pay==null || pay==''){
		return;
	}

	var url='dhcst.payaction.csp?actiontype=Select&pay='+pay;
	
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	//alert(mainData)
	return mainData;
}

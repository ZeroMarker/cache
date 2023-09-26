///DHCOPBillStayDepList.js
///Lid
///2012-06-18
///急诊留观押金列表
var m_DELIMITER={	//定义分割符
	CH2:String.fromCharCode(2),
	CH3:String.fromCharCode(3),
	CH4:String.fromCharCode(4)
};
function BodyLoadHandler(){
	IntDocument();
	InitDepositPayMode();
}
function IntDocument(){
	
}
///获取留观押金支付方式汇总信息
function InitDepositPayMode(){
	var depositInfo=tkMakeServerCall("web.DHCOPBillStayCharge","GetDepositPayM",document.getElementById("Adm").value,"");
	var depositInfo=depositInfo.split(m_DELIMITER.CH2)[1];
	var tmp=depositInfo.replace(/\^/g,":");
	var tmp=tmp.replace(/!/g," ");
	//document.getElementById('DepositInfo').innerText="留观押金合计: " +tmp;
}
document.body.onload = BodyLoadHandler;
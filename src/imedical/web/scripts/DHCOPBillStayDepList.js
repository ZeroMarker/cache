///DHCOPBillStayDepList.js
///Lid
///2012-06-18
///��������Ѻ���б�
var m_DELIMITER={	//����ָ��
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
///��ȡ����Ѻ��֧����ʽ������Ϣ
function InitDepositPayMode(){
	var depositInfo=tkMakeServerCall("web.DHCOPBillStayCharge","GetDepositPayM",document.getElementById("Adm").value,"");
	var depositInfo=depositInfo.split(m_DELIMITER.CH2)[1];
	var tmp=depositInfo.replace(/\^/g,":");
	var tmp=tmp.replace(/!/g," ");
	//document.getElementById('DepositInfo').innerText="����Ѻ��ϼ�: " +tmp;
}
document.body.onload = BodyLoadHandler;

// var logid = "";

/// ҳ���ʼ������
function initPageDefault(){
	
	/// �������ӿ�
	var pdss = new PDSS({"WinType":"OPENWIN"});
	var PdssObj = {};
	PdssObj.MsgID = logid;
	pdss.refresh(PdssObj, null, 1);
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
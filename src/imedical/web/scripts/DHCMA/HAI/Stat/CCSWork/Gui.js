//ҳ��Gui
function InitCCSWorkWin(){
	var obj = new Object();
   	//ҽԺ
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	//���ÿ�ʼ����Ϊ����1��
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',DateTo);
    
	InitCCSWorkWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitCCSWorkWin();
});
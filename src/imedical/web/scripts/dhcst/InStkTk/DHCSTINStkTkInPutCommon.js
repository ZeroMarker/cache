// /����: �̵�ʵ����ع�������������
// /����: �̵�ʵ����ع�������������
// /��д�ߣ�wyx
// /��д����: 2013.11.13
// DHCSTINStkTkInPutCommon.js

/*��������������ԣ�
 ¼����
*/
var gParam=[]; 

/*
 * creator:wyx,2013-11-13
 * description:ȡ�̵�ʵ����ؽ����漰�Ĳ������ñ��浽ȫ�ֱ���gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcst.instktkaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gParam=info.split('^');
		}
	}

	return;
}
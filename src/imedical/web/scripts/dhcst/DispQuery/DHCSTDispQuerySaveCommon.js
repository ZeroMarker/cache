// /����: �ۺϲ�ѯͳ����ع�������������
// /����: �ۺϲ�ѯͳ����ع�������������
// /��д�ߣ�wyx
// /��д����: 2014.05.26
// DHCSTDispQuerySaveCommon.js

/*��������������ԣ�
 
*/
var gParam=[]; 

/*
 * creator:wyx,2014-05-26
 * description:ȡ�ۺϲ�ѯͳ����ؽ����漰�Ĳ������ñ��浽ȫ�ֱ���gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcst.dispqueryaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
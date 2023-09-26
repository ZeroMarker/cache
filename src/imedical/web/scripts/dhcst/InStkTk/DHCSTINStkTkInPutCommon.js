// /名称: 盘点实盘相关公共方法及变量
// /描述: 盘点实盘相关公共方法及变量
// /编写者：wyx
// /编写日期: 2013.11.13
// DHCSTINStkTkInPutCommon.js

/*保存参数配置属性：
 录入项
*/
var gParam=[]; 

/*
 * creator:wyx,2013-11-13
 * description:取盘点实盘相关界面涉及的参数配置保存到全局变量gParam
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
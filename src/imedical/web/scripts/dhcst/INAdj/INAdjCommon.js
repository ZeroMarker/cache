// /名称:库存调整相关公共方法及变量
// /描述:库存调整相关公共方法及变量
// /编写者：yangsj
// /编写日期: 2020.02.20

/*保存参数配置属性：
小数位数
*/
var gParam=[]; 

/*
 * creator:yangsj,2020-02-20
 * description:取库存调整相关界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return: 
 * */
function GetParam(ProLocId){
	if ((ProLocId==null)||(ProLocId==undefined)||(ProLocId=="")) {var locId=session['LOGON.CTLOCID'];}
	else {var locId=ProLocId;}
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var url='dhcst.inadjaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
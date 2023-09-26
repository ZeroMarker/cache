// /名称: 库存查询相关公共方法及变量
// /描述: 库存查询相关公共方法及变量
// /编写者：wyx
// /编写日期: 2013.11.13
// DHCSTLocItmStkCommon.js

/*保存参数配置属性：
 台帐信息^全院在途数清除^科室在途数清除^科室单品在途数清除^科室库存同步^科室单品库存同步
*/
var gParam=[]; 

/*
 * creator:wyx,2013-11-13
 * description:取库存查询相关界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcst.locitmstkaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
// /名称: 库存转移请求相关公共方法及变量
// /描述: 库存转移请求相关公共方法及变量
// /编写者：wyx
// /编写日期: 2014.01.22
// DHCSTINRequestCommon.js

/*保存参数配置属性：
 请求数量是否可以大于供应方库存
*/
var gParam=[]; 

/*
 * creator:wyx,2013-11-13
 * description:取库存转移请求相关界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return: 
 * */
function GetParam(ProLocId){
	if ((ProLocId==null)||(ProLocId==undefined)||(ProLocId=="")) {var locId=session['LOGON.CTLOCID'];}
	else {var locId=ProLocId;}
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	//var locId=session['LOGON.CTLOCID'];
	var url='dhcst.inrequestaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
/*
 * creator:zhangdongmei,2012-09-27
 * description:取默认的起始日期
 * params: 
 * return:起始日期
 * */
function DefaultStDate(){
	var today=new Date();
	if(gParam.length<3){
		return today;
	}
	
	var defaStDate=gParam[2];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-09-27
 * description:取默认的截止日期
 * params: 
 * return:截止日期
 * */
function DefaultEdDate(){
	var today=new Date();
	if(gParam.length<4){
		return today;
	}

	var defaEdDate=gParam[3];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}
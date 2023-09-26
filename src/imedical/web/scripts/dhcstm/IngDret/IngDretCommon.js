// /名称: 退货相关公共方法及变量
// /描述: 退货相关公共方法及变量
// /编写者：zhangdongmei
// /编写日期: 2012.11.02

//保存参数值的object
var IngrtParamObj = GetAppPropValue('DHCSTRETURNM');

/*保存参数配置属性：
 * 默认查找起始日期^默认查找截止日期
*/
var gParam=[]; 

/*
 * creator:zhangdongmei,2012-09-26
 * description:取入库相关界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.ingdretaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
 * creator:zhangdongmei,2012-09-26
 * description:取默认的起始日期
 * params: 
 * return:起始日期
 * */
function DefaultStDate(){
	if(gParam.length<1){
		GetParam();	
	}
	
	var today=new Date();
	if(gParam.length<1){
		return today;
	}
	
	var defaStDate=gParam[0];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:取默认的截止日期
 * params: 
 * return:截止日期
 * */
function DefaultEdDate(){
	if(gParam.length<1){
		GetParam();	
	}
	var today=new Date();
	if(gParam.length<2){
		return today;
	}

	var defaEdDate=gParam[1];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}
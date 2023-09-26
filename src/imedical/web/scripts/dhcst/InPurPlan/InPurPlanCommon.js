// /名称: 采购计划相关公共方法及变量
// /描述: 采购计划相关公共方法及变量
// /编写者：zhangdongmei
// /编写日期: 2012.09.27

/*保存参数配置属性：
 * 进价是否可以为空^是否自动审批^默认查找起始日期^默认查找截止日期
*/
var gParam=[]; 

/*
 * creator:zhangdongmei,2012-09-27
 * description:取采购计划相关界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcst.inpurplanaction.csp?actiontype=GetParamProp&groupId='+groupId+'&locId='+locId+'&userId='+userId;
	var response=ExecuteDBSynAccess(url);
	if(response!=null || response!=''){
		gParam=response.split('^');
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
	GetParam();
	var today=new Date();
	if(gParam.length<3){
		return today;
	}
	
	var defaStDate=gParam[2];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	StDate=StDate.format(App_StkDateFormat);
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-09-27
 * description:取默认的截止日期
 * params: 
 * return:截止日期
 * */
function DefaultEdDate(){
	GetParam();
	var today=new Date();
	if(gParam.length<4){
		return today;
	}

	var defaEdDate=gParam[3];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	EdDate=EdDate.format(App_StkDateFormat);
	return EdDate;
}
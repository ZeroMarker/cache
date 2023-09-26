// /名称: 库存转移相关公共方法及变量
// /描述:库存转移相关公共方法及变量
// /编写者：zhangdongmei
// /编写日期: 2012.10.17

/*保存参数配置属性：
出库审核默认天数^默认查找起始日期^默认查找截止日期^保存后自动打印出库单^出库审核后自动打印出库单
^入库审核后自动打印出库单^启动制单时自动调出请求单^库存转移是否必须依据请求单^打印类型^批量作废请求明细^过期药品限制出库
*/
var gParam=[]; 

/*
 * creator:zhangdongmei,2012-10-17
 * description:取库存转移相关界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return: 
 * */
function GetParam(ProLocId){
	if ((ProLocId==null)||(ProLocId==undefined)||(ProLocId=="")) {var locId=session['LOGON.CTLOCID'];}
	else {var locId=ProLocId;}
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var url='dhcst.dhcinistrfaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
 * creator:zhangdongmei,2012-10-17
 * description:取默认的起始日期
 * params: 
 * return:起始日期
 * */
function DefaultStDate(){
	GetParam();
	var today=new Date();
	if(gParam.length<2){
		return today;
	}
	
	var defaStDate=gParam[1];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	StDate=StDate.format(App_StkDateFormat);
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-10-17
 * description:取默认的截止日期
 * params: 
 * return:截止日期
 * */
function DefaultEdDate(){
	GetParam();
	var today=new Date();
	if(gParam.length<3){
		return today;
	}

	var defaEdDate=gParam[2];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	EdDate=EdDate.format(App_StkDateFormat);
	return EdDate;
}

/*
 * creator:zhangdongmei,2012-10-17
 * description:取默认出库审核开始日期
 * params: 
 * return:截止日期
 * */
function AuditStDate(){
	var today=new Date();
	if(gParam.length<1){
		return today;
	}

	var AuditDays=gParam[0];	
	var StDate=today.add(Date.DAY, parseInt(AuditDays));
	return StDate;
}
//R:上下级,T:平级
//菜单表达式维护为:"&TransFlag=TRA" 等情况,默认为空
//1:TransFlag=="REA"	在转移退库接收中的供给科室中有使用，即取到的供给部门为请求部门的下级
//2:TransFlag=="EJT"  	在调拨申领制单、调拨接收、调拨出库中使用(同级之间的操作)
//3:TransFlag=="REQ"	在申领单制单界面、申领接收界面使用(下级向上级申领)/
//4:TransFlag=="RET"	在药品退库制单中使用，请求部门为供给部门上级科室
//5:TransFlag=="TRA"	出库确认中使用，请求部门为供给部门下级
//6:TransFlag=="KSL"	科室请领??
//默认菜单
function GetProTransType(){
	if(TransFlag=="REA"){
	   return "R";
	}else if(TransFlag=="EJT"){
		return "T"
	}else if(TransFlag=="RET"){
		return "RF"
	}else if(TransFlag=="REQ"){
		return "RF"
	}else{
		return "T";
		}
	}
function GetRecTransType(){
	if((TransFlag=="TRA")||(TransFlag=="KSL")){
	   return "R";
	}else if(TransFlag=="EJT"){
		return "T"
	}else if(TransFlag=="RET"){
		return "RF"
	}else{
		return "T";
	}
}
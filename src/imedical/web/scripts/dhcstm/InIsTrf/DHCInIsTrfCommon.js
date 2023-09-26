// /名称: 库存转移相关公共方法及变量
// /描述:库存转移相关公共方法及变量
// /编写者：zhangdongmei
// /编写日期: 2012.10.17

//保存参数值的object
var InitParamObj = GetAppPropValue('DHCSTTRANSFERM');

/*保存参数配置属性：
出库审核默认天数^默认查找起始日期^默认查找截止日期^保存后自动打印出库单^出库审核后自动打印出库单
^入库审核后自动打印出库单^启动制单时自动调出请求单^库存转移是否必须依据请求单
*/
var gParam=[]; 

/*
 * creator:zhangdongmei,2012-10-17
 * description:取库存转移相关界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.dhcinistrfaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
	var today = new Date();
	var defaStDate = InitParamObj.DefaStartDate;
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-10-17
 * description:取默认的截止日期
 * params: 
 * return:截止日期
 * */
function DefaultEdDate(){
	var today = new Date();
	var defaEdDate = InitParamObj.DefaEndDate;
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}

/*
 * creator:zhangdongmei,2012-10-17
 * description:取默认出库审核开始日期
 * params: 
 * return:截止日期
 * */
function AuditStDate(){
	var today = new Date();
	var AuditDays = InitParamObj.DefaDaysAudit;
	if(Ext.isEmpty(AuditDays)){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(AuditDays));
	return StDate;
}

function ProvLocAuditRequired()
{
	var result="";
	if (gParam.length>8) result=gParam[8];
	return	result;
}
function IsSplit()
{
	var result="";
	if (gParam.length>=10) result=gParam[10];
	return	result;
}

function OutType()
{
	// 出库方式，参数定义(1 ,2 ...)
	var result="";
	//alert(gParam);
	if (gParam.length>=11) result=gParam[11];
	return	result;
	
}

/**
 * 判断两科室之间是否存在支配关系
 * @param {} provLoc	:供应科室
 * @param {} requestLoc	:请求科室
 * @return {Boolean}	:true-ok false-错误
 */
function CheckMainLoc(provLoc, requestLoc){
	if(ItmTrackParamObj.UseItmTrack == 'Y' && !Ext.isEmpty(provLoc) && !Ext.isEmpty(requestLoc)){
		if(provLoc == requestLoc){
			//科室相同的,按存在关联处理
			return false;
		}
		var MainLocInfo = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'GetMainLocInfo', requestLoc);
		var MainLoc = MainLocInfo.split('^')[0];
		var MainLocInfo2 = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'GetMainLocInfo', provLoc);
		var MainLoc2 = MainLocInfo2.split('^')[0];
		if(MainLoc == provLoc || MainLoc2 == requestLoc){
			Msg.info('warning', '供给部门与请求部门存在支配关系!');
			return false;
		}
	}
	return true;
}

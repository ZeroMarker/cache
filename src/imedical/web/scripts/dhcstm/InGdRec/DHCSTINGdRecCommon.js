// /名称: 入库相关公共方法及变量
// /描述: 入库相关公共方法及变量
// /编写者：zhangdongmei
// /编写日期: 2012.09.26

//保存参数值的object
var IngrParamObj = GetAppPropValue('DHCSTIMPORTM');

/*保存参数配置属性：
 * 默认批价等于进价^检测发票号^效期提示天数^保存后自动打印^审核后自动打印
^加成率超限提示^允许录入进价金额^采购员不能为空^入库类型不能为空^验证最高售价^默认查找起始日期^默认查找截止日期
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
	var url='dhcstm.ingdrecaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
 * description:验证发票号是否存在于别的入库单
 * params: invNo:发票号,ingr:入库主表id
 * return: true:不存在,发票号有效；false:存在,发票号无效
 * */
function InvNoValidator(invNo,ingr){
	if(gParam.length<1){
		GetParam();
	}
	if(gParam.length<2){
		return true;
	}
	if(invNo==null || invNo==''){
		return true;
	}
	if(gParam[1]!='Y'){
		return true;      //不需要验证
	}
	
	var Flag=true;
	var url='dhcstm.ingdrecaction.csp?actiontype=CheckInvnoExist&Ingr='+ingr+'&InvNo='+invNo;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info==1){
			Flag=false;   //该发票号已存在于别的入库单		
		}
	}
	return Flag;
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:验证效期是否需要提示
 * params: expDate:效期，ARG_DATEFORMAT
 * return: true:效期合理，不需要提示；false:效期不合理，需要提示
 * */
function ExpDateValidator(expDate, Inci){
	if (Ext.isEmpty(expDate)) {
		return true;
	}
	var ExpChcekInfo = tkMakeServerCall('web.DHCSTM.DHCINGdRecItm', 'CheckExpDate', Inci, expDate);
	if(ExpChcekInfo != ''){
		Msg.info('warning', ExpChcekInfo);
		return false;
	}
	return true;
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
	if(gParam.length<11){
		return today;
	}
	
	var defaStDate=gParam[10];
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
	if(gParam.length<12){
		return today;
	}

	var defaEdDate=gParam[11];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}
//渲染资金来源
function SourceOfFundRender(v){
	var SourceOfFund = v;
	switch (v){
		case 'KS':
			SourceOfFund = '科室领用';
			break;
		case 'CZ':
			SourceOfFund = '财政资金';
			break;
		case 'KT':
			SourceOfFund = '课题经费';
			break;
		case 'KY':
		    SourceOfFund = '科研基金';	
		    break;
		default :
			break
	}
	return SourceOfFund;
}
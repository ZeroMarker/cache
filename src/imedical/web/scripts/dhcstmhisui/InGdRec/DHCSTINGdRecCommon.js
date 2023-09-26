// /名称: 入库相关公共方法及变量
// /描述: 入库相关公共方法及变量
// /编写者：lihui
// /编写日期: 20180521

//保存参数值的object
var IngrParamObj = GetAppPropValue('DHCSTIMPORTM');
var SessionParams=gGroupId+"^"+gLocId+"^"+gUserId+"^"+gHospId;
var ItmTrackParamObj = GetAppPropValue('DHCITMTRACKM');
/*
 * creator:zhangdongmei,2012-09-26
 * description:验证发票号是否存在于别的入库单
 * params: invNo:发票号,ingr:入库主表id
 * return: true:不存在,发票号有效；false:存在,发票号无效
 * */
function InvNoValidator(invNo,ingr){
	if(isEmpty(IngrParamObj)){
		return true;
	}
	if(isEmpty(invNo)){
		return true;
	}
	if(IngrParamObj.CheckInvNo!='Y'){
		return true;      //不需要验证
	}
	var Flag=true;
	var InvnoExistFlag=tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckInvnoExist', ingr,invNo);
	
	if(InvnoExistFlag==1){
			Flag=false;   //该发票号已存在于别的入库单		
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
	if (isEmpty(expDate)) {
		return '';
	}
	var ExpChcekInfo = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', Inci, expDate);
	if(ExpChcekInfo != ''){
		return ExpChcekInfo;
	}
	return '';
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:取默认的起始日期
 * params: 
 * return:起始日期
 * */
function DefaultStDate(){
	var Today = new Date();
	var DefaStartDate = IngrParamObj.DefaStartDate;
	if(isEmpty(DefaStartDate)){
		return Today;
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(EdDate);		
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:取默认的截止日期
 * params: 
 * return:截止日期
 * */
function DefaultEdDate(){
	var Today = new Date();
	var DefaEndDate = IngrParamObj.DefaEndDate;
	if(isEmpty(DefaEndDate)){
		return Today;
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
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
//入库类型默认值
function GetIngrtypeDefa(){
	var TYPE="IM";
	var IngrtypeId=tkMakeServerCall("web.DHCSTMHUI.Common.Dicts","GetDefaOPtype",TYPE,gHospId);
	return IngrtypeId;
}
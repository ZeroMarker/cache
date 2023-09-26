///名称:订单相关公共方法及变量
///描述:订单相关公共方法及变量
///编写者:lxt
///编写日期:2018-7-19

//保存参数值的object
var InPoParamObj = GetAppPropValue('DHCSTPOM');
//科室类型全局变量
var INPO_LOCTYPE = 'All';
//下拉框参数
var PoLocParams=JSON.stringify(addSessionParams({Type:INPO_LOCTYPE}));
var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
///return:到货时间
function NeedDate(){
	var Today = new Date();
	var Days = InPoParamObj.NeedDays
	if(isEmpty(Days)){
		return Today;
	}
	var NeedDate = DateAdd(Today, 'd', parseInt(Days));
	return DateFormatter(NeedDate);
}
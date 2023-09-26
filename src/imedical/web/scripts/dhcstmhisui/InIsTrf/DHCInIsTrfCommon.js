
//保存参数值的object
var InitParamObj = GetAppPropValue('DHCSTTRANSFERM');

function DefaultStDate(){
	var Today = new Date();
	var DefaStartDate = InitParamObj.DefaStartDate;
	if(isEmpty(DefaStartDate)){
		return Today;
	}
	var StDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(StDate);
}

function DefaultEdDate(){
	var Today = new Date();
	var DefaEndDate = InitParamObj.DefaEndDate;
	if(isEmpty(DefaEndDate)){
		return Today;
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}

function AuditStDate(){
	var Today = new Date();
	var DefaDaysAudit = InitParamObj.DefaDaysAudit;
	if(isEmpty(DefaDaysAudit)){
		return Today;
	}
	var Date = DateAdd(Today, 'd', parseInt(DefaDaysAudit));
	return Date;
}

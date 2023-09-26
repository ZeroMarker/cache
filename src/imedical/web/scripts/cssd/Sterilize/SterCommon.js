var ParamObj = GetAppPropValue('CSSDSTERILIZE');
function IfSterFinish(){
	var IsSterFinish = ParamObj.IsSterFinish;
	return IsSterFinish;
}
function IfMachineBindCar(){
	var IsMachineBindCar = ParamObj.IsMachineBindCar;
	return IsMachineBindCar;
}
///return:起始日期
function DefaultStDate(){
	var Today = new Date();
	var DefStartDate = ParamObj.DefStartDate;
	if(isEmpty(DefStartDate)){
		return Today;
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefStartDate));
	return DateFormatter(EdDate);	
		
}
function DefaultEdDate(){
	var Today = new Date();
	var DefEndDate = ParamObj.DefEndDate;
	if(isEmpty(DefEndDate)){
		return Today;
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefEndDate));
	return DateFormatter(EdDate);
}
function RequiredDelete(){
	var RequiredDelete = ParamObj.RequiredDelete;
	return RequiredDelete;
}
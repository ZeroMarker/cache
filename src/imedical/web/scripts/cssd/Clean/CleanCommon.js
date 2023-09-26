var ParamObj = GetAppPropValue('CSSDCLEAN');
function IfcleanRack(){
	var IfCleanRack = ParamObj.IfCleanRack;
	return IfCleanRack;
}
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

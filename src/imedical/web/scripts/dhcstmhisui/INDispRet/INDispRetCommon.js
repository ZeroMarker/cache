var INDispRetParamObj = GetAppPropValue('DHCSTINDISPRETM');

function DefaultStDate(){
	var Today = new Date();
	var DefaStartDate = INDispRetParamObj.DefaStartDate;
	if(isEmpty(DefaStartDate)){
		return DateFormatter(Today);
	}
	var StDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(StDate);
}

function DefaultEdDate(){
	var Today = new Date();
	var DefaEndDate = INDispRetParamObj.DefaEndDate;
	if(isEmpty(DefaEndDate)){
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}

function SetDefaValues() {
	$('#LocId').combobox('setValue', gLocId);
	$('#StartDate').datebox('setValue', DefaultStDate());
	$('#EndDate').datebox('setValue', DefaultEdDate());
}
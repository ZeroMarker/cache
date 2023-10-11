var INDispParamObj = GetAppPropValue('DHCSTINDISPM');

function DefaultStDate() {
	var Today = new Date();
	var DefaStartDate = INDispParamObj.DefaStartDate;
	if (isEmpty(DefaStartDate)) {
		return DateFormatter(Today);
	}
	var StDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(StDate);
}

function DefaultEdDate() {
	var Today = new Date();
	var DefaEndDate = INDispParamObj.DefaEndDate;
	if (isEmpty(DefaEndDate)) {
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
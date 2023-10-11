var PayCoverParamObj = GetAppPropValue('DHCSTMRECCOVERM');

function DefaultStDate() {
	var Today = new Date();
	var DefaStartDate = PayCoverParamObj.DefaStartDate;
	if (isEmpty(DefaStartDate)) {
		return DateFormatter(Today);
	}
	var StDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(StDate);
}

function DefaultEdDate() {
	var Today = new Date();
	var DefaEndDate = PayCoverParamObj.DefaEndDate;
	if (isEmpty(DefaEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}

function SetDefaValues() {
	$('#IngrLoc').combobox('setValue', gLocId);
	$('#StartDate').datebox('setValue', DefaultStDate());
	$('#EndDate').datebox('setValue', DefaultEdDate());
}
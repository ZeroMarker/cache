function dateFormat(date){
	var fmatdate = date;
	if (date == "" || date == undefined) return fmatdate;
	if (dtformat == "DMY")
	{
		var tmparr = date.split("/");
		fmatdate = tmparr[2]+"-"+tmparr[1]+"-"+tmparr[0];
	}
	else if (dtformat == "MDY")
	{
		var tmparr = date.split("/");
		fmatdate = tmparr[2]+"-"+tmparr[0]+"-"+tmparr[1];
	}
	return fmatdate
}
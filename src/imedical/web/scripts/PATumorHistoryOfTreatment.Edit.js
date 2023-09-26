// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function Init() {

	obj=document.getElementById('HISStartDate');
	if (obj) obj.onchange=CodeTableValidationDate;

	obj=document.getElementById('HISEndDate');
	if (obj) obj.onchange=CodeTableValidationDate;

}


function CodeTableValidationDate(e) {
	
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="HISStartDate") {HISStartDate_changehandler(e);}
	if (eSrc.id=="HISEndDate") {HISEndDate_changehandler(e);}
	
	var HISStartDate;
	var HISEndDate;
	var obj;
	
	obj=document.getElementById('HISStartDate');
	if ((obj)&&(obj.value!="")) {
		var HISStartDate=DateStringTo$H(obj.value);
	}
	obj=document.getElementById('HISEndDate');
	if ((obj)&&(obj.value!="")) {
		var HISEndDate=DateStringTo$H(obj.value);
	}
	
	obj=document.getElementById('CodeTableValidationDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((HISStartDate)&&(HISStartDate.value!="")) {
			obj.value=HISStartDate;
		}
		if ((HISEndDate)&&(HISEndDate.value!="")) {
			obj.value=HISEndDate;
		}
		
	}
	/*
	obj=document.getElementById('HOTDesc')
	if (obj) obj.onchange();
	*/
}



document.body.onload=Init;

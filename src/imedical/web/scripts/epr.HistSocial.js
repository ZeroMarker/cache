// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));

function DocumentLoadHandler() {
	assignClickHandler();

	for (var curr_row=1; curr_row<ltbl.rows.length; curr_row++)	{
		var onsetDate=document.getElementById('OnsetDatez'+curr_row);
		var approxOnset=document.getElementById('ApproxOnsetDatez'+curr_row);
		if ( approxOnset && approxOnset.value=="Y" ) {
			if (onsetDate) onsetDate.className="EstOnsetDate";
		}
	}

	var obj=document.getElementById("new1")
	if (obj) obj.onclick=ClearFields;

	var obj=document.getElementById("update1");
	if (obj) {
		obj.onclick=UpdateHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	}

	var field=document.getElementById("PADurationDesc")
	if (field) field.multiple=false;
}

function ClearFields() {
	var field=document.getElementById("HistoryID")
	if (field) field.value="";

	field=document.getElementById("PAHabit")
	var objImg=document.getElementById("ld2142iPAHabit");
	if (field) {
		EnableLookup(field,objImg);
		field.value="";
	}

	field=document.getElementById("PAHabitQuantity")
	objImg=document.getElementById("ld2142iPAHabitQuantity");
	if (field) {
		EnableLookup(field,objImg);
		field.value="";
	}

	field=document.getElementById("PAOnsetDate")
	if (field) field.value="";

	field=document.getElementById("ApproxOnset")
	if (field) field.value="";

	field=document.getElementById("PADuration")
	if (field) field.value="";

	field=document.getElementById("PADurationDesc")
	if (field) field.value="";

	field=document.getElementById("PAComments")
	if (field) field.value="";

	// Log 58610 - GC - 26-04-2006
	field=document.getElementById("SCHDSReportFlag")
	if (field) field.checked=false;
	// End Log 58610

	field=document.getElementById("SocialHistList")
	if (field){
		//ClearSelectedList(field);
		field.value="";
		field.disabled = false;
	}

	field=document.getElementById("MultiHabit")
	if (field) field.value="";

	field=document.getElementById("ApproxOnset")
	if (field) field.checked=false;

	setApproxOnsetDateFontColour();

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_HistSocial");
	for (var i=1;i<tbl.rows.length;i++) {
		var objEdit=document.getElementById("Amend1z"+i)
		if (objEdit) objEdit.onclick=ClickHandler;
	}

	var habitListObj=document.getElementById("SocialHistList");
	if (habitListObj) habitListObj.onchange=DisableLookUpHandler;

	var habitObj=document.getElementById("PAHabit");
	if (habitObj) habitObj.onblur=DisableListHandler;

	var qtyObj=document.getElementById("PAHabitQuantity");
	if (qtyObj) qtyObj.onblur=DisableListHandler;

	var approxOnset=document.getElementById("ApproxOnset")
	if (approxOnset) approxOnset.onclick=setApproxOnsetDateFontColour;

	return;
}

function DisableLookUpHandler(){
	var habitListObj=document.getElementById("SocialHistList");
	var habitObj=document.getElementById("PAHabit");
	var habitImg=document.getElementById("ld2142iPAHabit");
	var qtyObj=document.getElementById("PAHabitQuantity");
	var qtyImg=document.getElementById("ld2142iPAHabitQuantity");

	if (habitListObj && habitListObj.value!=""){
		if (habitObj) DisableLookup(habitObj,habitImg);
		if (qtyObj) DisableLookup(qtyObj,qtyImg);
	}
	else {
		if (habitObj) EnableLookup(habitObj,habitImg);
		if (qtyObj) EnableLookup(qtyObj,qtyImg);
	}
}

function DisableListHandler(){
	var habitObj=document.getElementById("PAHabit");
	var qtyObj=document.getElementById("PAHabitQuantity");
	var habitImg=document.getElementById("ld2142iPAHabit");
	var qtyImg=document.getElementById("ld2142iPAHabitQuantity");
	var habitListObj=document.getElementById("SocialHistList");

	if ( (habitObj && habitObj.value=="") && (qtyObj && qtyObj.value=="") ) {
		if (habitListObj) habitListObj.disabled = false;
	}else{
		if (habitListObj) habitListObj.disabled = true;
		if (habitObj) EnableLookup(habitObj,habitImg);
		if (qtyObj) EnableLookup(qtyObj,qtyImg);

	}
}

function DisableLookup( objLookUp, imgLookup )
{
	objLookUp.disabled = true;
	objLookUp.value="";
	imgLookup.disabled = true;
}  // DisableLookup

function EnableLookup( objLookUp, imgLookup )
{
	objLookUp.disabled = false;
	imgLookup.disabled = false;
}  // EnableLookup


function ClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		var HIDDEN=document.getElementById("HIDDENz"+rowAry[1]).value;
		var temp=HIDDEN.split("^");

		var field=document.getElementById("HistoryID")
		if (field) field.value=temp[0];

		field=document.getElementById("PAHabit")
		if (field) field.value=temp[1];

		field=document.getElementById("PAHabitQuantity")
		if (field) field.value=temp[2];

		field=document.getElementById("SocialHistList")
		if (field) field.value="";

		DisableListHandler();

		field=document.getElementById("PAOnsetDate")
		if (field) field.value=temp[3];

		field=document.getElementById("PAComments")
		if (field) field.value=temp[4];

		// Log 58610 - GC - 26-04-2006 : New field DS Report Flag
		field=document.getElementById("SCHDSReportFlag")
		if (field) {
			field.checked=false;
			if (temp[5]=="Y") field.checked=true
		}
		// end Log 58610

		field=document.getElementById("PADuration")
		if (field) field.value=temp[6];

		field=document.getElementById("PADurationDesc")
		if (field) field.value=temp[7];

		field=document.getElementById("ApproxOnset")
		if (field) {
			field.checked=false;
			if (temp[8]=="Y")
			{
				field.checked=true;
			}
		}
		setApproxOnsetDateFontColour();
	}

	return false;
}

function SetMultiHabit() {
	var HabitString="";

	var objHabitList = document.getElementById("SocialHistList");
	if (objHabitList) {
		for (var i=0; i<objHabitList.length; i++) {
			if (objHabitList.options[i].selected==true) {
				if (HabitString!="") HabitString=HabitString+"^";
				HabitString=HabitString+objHabitList.options[i].value;
			}
		}
	}

	var obj=document.getElementById("MultiHabit");
	if (obj) obj.value=HabitString;
}

function UpdateHandler() {
	SetMultiHabit();
	return update1_click();
}

function QuantityLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('PAHabitQuantity');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('PAHabit');
	if (obj) obj.value=lu[1];

	DisableListHandler();
}

function setApproxOnsetDateFontColour() {
	var approxDate=document.getElementById('ApproxOnset');
	var onsetDate=document.getElementById('PAOnsetDate');
	if ((onsetDate)&&(approxDate)) {
		if (approxDate.checked) {
			onsetDate.className="EstOnsetDate";
		} else {
			onsetDate.className="";
		}
	}
}

document.body.onload = DocumentLoadHandler;



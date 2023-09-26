// Copyright (c) 2005 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 50669 YC - Timeline as chart

var f=document.fOEOrder_Edit_TimeLineProfile;
var frm=document.forms['fOEOrder_Edit_TimeLineProfile'];

function UpdateClickHandler(e) {
	
	if(f.DateFrom) DateFrom=f.DateFrom.value; else DateFrom="";
	if(f.DateFromOffset) DateFromOffset=f.DateFromOffset.value; else DateFromOffset="";
	if(f.DateTo) DateTo=f.DateTo.value; else DateTo="";
	if(f.DateToOffset) DateToOffset=f.DateToOffset.value; else DateToOffset="";
	if(f.TimeFrom) TimeFrom=f.TimeFrom.value; else TimeFrom="";
	if(f.TimeTo) TimeTo=f.TimeTo.value; else TimeTo="";
	if(f.SlotType) SlotType=f.SlotType.value; else SlotType="";
	
	// one of the following must be entered
	if((!f.DateFrom.value&&!f.DateFromOffset.value)||(!f.DateTo.value&&!f.DateToOffset.value)||
	(f.DateFrom.value&&f.DateFromOffset.value)||(f.DateTo.value&&f.DateToOffset.value)||
	(f.DateFrom.value&&!f.DateTo.value)||(f.DateFromOffset.value&&!f.DateToOffset.value))
	{
		alert(t['DateRules']);
		return false;
	}

	// check if the "from" dates/times are before the "to" dates/times
	if(DateFrom && DateStringCompare(DateTo,DateFrom)!=1) // if DateFrom is entered
	{
  	if(DateStringCompare(DateTo,DateFrom)==0)	
	 	{
	 		if (TimeTo&&TimeFrom&&(TimeStringCompare(TimeTo,TimeFrom)!=1)) //time to not before time to but is on the same day
	 		{
	 			alert(t['TimeSequence']);
	 			return false;
	 		}	
	 	}
	 	else
	 	{
	 		alert(t['DateSequence']);
	 		return false;
	 	}
	}
	else if (DateFromOffset) // if offsets are entered
	{
		if((DateToOffset-DateFromOffset)<0)
		{
	  	alert(t['DateOffsetSequence']);
	  	return false;
	  }
	  if((DateToOffset-DateFromOffset)==0)	
	  {
	  	if (TimeTo&&TimeFrom&&(TimeStringCompare(TimeTo,TimeFrom)!=1)) //time to not before time to but is on the same day
	  	{
	  		alert(t['TimeSequence']);
	  		return false;
	  	}
	  }
	}

	f.PPParameters.value=DateFrom+"|"+DateFromOffset+"|"+DateTo+"|"+DateToOffset+"|"+TimeFrom+"|"+TimeTo+"|"+SlotType;
	return update1_click();
}

function LookUpTimeLineProfileName(val) {
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	var evt = document.createEventObject();
	frm.elements['xfetchparams'].fireEvent("onchange",evt);
}

//wrapper to call broker on hidden field to fetch params
function xfetchparams_changehandler(encmeth) {
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value)) {
	}
}

function AddParams(str) {
	var arr=str.split('|');
	if (f.DateFrom)
		if(arr[0]&&arr[0]!=0) 
			f.DateFrom.value=arr[0];
		else
			f.DateFrom.value="";
	if (f.DateFromOffset)
		if(arr[1]&&arr[1]!="") 
			f.DateFromOffset.value=arr[1];
		else
			f.DateFromOffset.value="";
	if (f.DateTo)
		if(arr[2]&&arr[2]!=0)
			f.DateTo.value=arr[2];
		else
			f.DateTo.value="";
	if (f.DateToOffset)
		if(arr[3]&&arr[3]!="") 
			f.DateToOffset.value=arr[3];
		else
			f.DateToOffset.value="";
	if (f.TimeFrom)
		if(arr[4]&&arr[4]!=0) 
			f.TimeFrom.value=arr[4];
		else
			f.TimeFrom.value="";
	if (f.TimeTo)
		if(arr[5]&&arr[5]!=0) 
			f.TimeTo.value=arr[5];
		else
			f.TimeTo.value="";
	if (f.SlotType)
		if(arr[6]&&arr[6]!=0) 
			f.SlotType.value=arr[6];
		else
			f.SlotType.value="";
}

function completeForm(str,graph) {
	AddParams(str.join('|'));
}

function RecipientLookUp(str) {
	var lu = str.split("^");
	var objPrinter=document.getElementById('Printer');
	if (objPrinter) {
		objPrinter.value = "";
	}

	var objRecipient=document.getElementById('Recipient');
	if (objRecipient) {
		var tmp = ""
		if (lu[0] !="" ) tmp += lu[0] + " ";
		if (lu[2] !="" ) tmp += lu[2] + " ";
		tmp += lu[1] + " (" + lu[5] + ")";
		objRecipient.value = tmp;
	}

	var clinDR=lu[8];
	var refDR = lu[4];
	var objRecipientID = document.getElementById("RecipientID");
	if (objRecipientID) {
		if (clinDR !="") {
			var pce = clinDR.split("||");
			objRecipientID.value = pce[0] + "^" + pce[1];
		} else {
			objRecipientID.value = refDR;
		}
	}
}

function PrinterLookUp(str) {
	var lu = str.split("^");
	var objPrinter=document.getElementById('Printer');
	if (objPrinter) {
		objPrinter.value = lu[0];
	}

// Log 53052 - AI - 28-07-2005 : Commented out, as Recipient is now a hidden field.
/*
	var objRecipient=document.getElementById('Recipient');
	if (objRecipient) {
		objRecipient.value= "";
	}
*/

}

function RecipientChangeHandler() {
	var objRecipient=document.getElementById('Recipient');
	var objPrinter=document.getElementById('Printer');
	if ((objPrinter) && (objRecipient) && (objRecipient.value!="")) {
		objPrinter.value="";
	}
}
function PrinterChangeHandler() {

// Log 53052 - AI - 28-07-2005 : Commented out, as Recipient is now a hidden field.
/*
	var objRecipient=document.getElementById('Recipient');
	var objPrinter=document.getElementById('Printer');
	if ((objPrinter) && (objRecipient) && (objPrinter.value!="")) {
		objRecipient.value="";
	}
*/

}

// Log 53052 - AI - 27-07-2005 : The blur handler for the new "Number of Copies" field.
function NoCopiesBlurHandler() {
	// function only called when object exists and the field is left.
	var val="";
	var objCopies = document.getElementById('NoCopies');
	if (objCopies) {
		val=objCopies.value;
		if (!(isNaN(val))) {
			objCopies.className="";
		}
		val=parseInt(val);
		if ((val=="")||(isNaN(val))) val=1;
		objCopies.value=val;
	}
}
// end Log 53052

function DocumentLoadHandler() {
	//var objPrinter=document.getElementById('Printer');
	//if (objPrinter) {objPrinter.onkeydown = PrinterChangeHandler;}
	
	// Log 53052 - AI - 27-07-2005 : Make the "Printer" field appear mandatory.
	var objLabelPrinter=document.getElementById('cPrinter');
	if (objLabelPrinter) {objLabelPrinter.className="clsRequired";}
	// end Log 53052
	
	//var objRecipient=document.getElementById('Recipient');
	//if (objRecipient) {objRecipient.onkeydown = RecipientChangeHandler;}
	
	var objPrint=document.getElementById('print');
	if (objPrint) {objPrint.onclick = PrintClickHandler;}
	
	// Log 53052 - AI - 27-07-2005 : Define the blur handler for the new "Number of Copies" field.
	var objCopies=document.getElementById('NoCopies');
	if (objCopies) {objCopies.onblur = NoCopiesBlurHandler;}
	
	// Log 53052 - AI - 27-07-2005 : Make the "No of Copies" field appear mandatory.
	var objLabelCopies=document.getElementById('cNoCopies');
	if (objLabelCopies) {objLabelCopies.className="clsRequired";}
	
	// Log 53052 - AI - 27-07-2005 : Define the click handler for the "Print" button.
	var objPrint=document.getElementById('print');
	if (objPrint) {objPrint.onclick = PrintClickHandler;}
	// end Log 53052
}

// Log 53052 - AI - 27-07-2005 : Define the click handler for the "Update" button.
function PrintClickHandler() {

// Log 53052 - AI - 28-07-2005 : Commented out, as Recipient is now a hidden field.
/*
	var objRecipient=document.getElementById('Recipient');
	var objPrinter=document.getElementById('Printer');
	if ((objPrinter) && (objRecipient) && (objPrinter.value!="") && (objRecipient.value!="")) {
		alert(t['PRINTRECIP']);
	} else {
		print_click();
	}
*/


	var msg="";
	var field="";
	
	var obj=document.getElementById('Printer');
	if ((obj.value=="")||(obj.className=="clsInvalid")) {
		if (msg!="") msg=msg + String.fromCharCode(13,10) + t['PrinterRequired'];
		if (msg=="") msg=t['PrinterRequired'];
		if (!field) field="Printer";
	}
	
	var obj=document.getElementById('NoCopies');
	if ((obj.value=="")||(obj.className=="clsInvalid")) {
		if (msg!="") msg=msg + String.fromCharCode(13,10) + t['NoCopiesRequired'];
		if (msg=="") msg=t['NoCopiesRequired'];
		if (!field) field="NoCopies";
	}
	
	if (msg!="") {
		alert(msg);
		if (field!="") {
			var obj=document.getElementById(field);
			if (obj) obj.focus();
		}
		return false;
	}


	return print_click();
}
// end Log 53052

document.body.onload = DocumentLoadHandler;

// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var startDelim;
var endDelim;
//var startDelim="\\";
//var endDelim=" ";
//override component specific start and end delimiter if it exists otherwise leave the defaults
try {startDelim=COMPstartDelim; } catch(err) { startDelim="\\"; }
try {endDelim=COMPendDelim; } catch(err) { endDelim=" "; }

var startAscii=startDelim.charCodeAt();
var endAscii=endDelim.charCodeAt();
var enteredField=null;

function GetCode(fld)
{
	var code="";

	enteredField = null;
	startIndex = fld.value.lastIndexOf(startDelim);
	if (startIndex != -1) {
		if (fld.createTextRange) {
		    	fld.cursorPos = document.selection.createRange().duplicate();
			do {
				currentTxt=fld.cursorPos.text;
				pos=fld.cursorPos.moveStart("character",-1);
			//don't know when pos actually equals 0 - it manages to keep moving back in the document html
			//} while ((fld.cursorPos.text.charAt(0)!=startDelim)||(pos==0));
			//now need to check the currentTxt==fld.cursorPos.text before the moveStart
			//when it reaches the end of textarea textvalue - fld.cursorPos.text is repeated
			} while ((fld.cursorPos.text.charAt(0)!=startDelim)&&(currentTxt!=fld.cursorPos.text));

			if (fld.cursorPos.text.charAt(0)==startDelim) {
				code=fld.cursorPos.text;
				enteredField = fld;
			}
		}
	}
	return code;
}
function LocateCode(fld,encmeth,isrtf,lookupqry,execjs) {
	//var code="";
	//alert('window.event is: ' + window.event);
	//alert('event.which is: ' + window.event.which);

 	var code="";
	//alert("Locate "+keycode);
 	if (isrtf) {
 		keychar = keycode;  //window.event.keyCode;
 	} else {
 		keychar = websys_getKey(event);
 	}

	//alert('Fld: ' + fld + '\nkeychar: ' + keychar);
	//alert(keychar +":"+endAscii);
	if (keychar == endAscii) {
 		if (isrtf) {
			//alert('Fld: ' + fld + '\nkeychar: ' + keychar);
			code = fld.GetCode(startDelim);
			enteredField = fld;

  		} else {
			code = GetCode(fld);
		}
		if (enteredField) {
			//alert("code is: " + code + "\nmeth is: " + encmeth);
			if (isrtf) {
				cspRunServerMethod(encmeth,code,isrtf);
			} else {
				cspRunServerMethod(encmeth,code);
			}

		}
	}

	if (keychar == 117) {
		if (!lookupqry) return websys_cancel();
		//F6 key for lookup
		if (isrtf) {
			code = fld.GetCode(startDelim);
			enteredField = fld;
			if (code!="") {
				var url = "websys.lookup.csp";
				url += "?ID=i"+fld.name;
				if (lookupqry) url += "&CONTEXT="+lookupqry;
				if (execjs) url += "&TLUJSF="+execjs;
				url += "&P1=" + code;
				var tmp=url.split('%');
				url=tmp.join('%25');
				websys_lu(url,1,'');
			}
		} else {
			code = GetCode(fld);
			if (enteredField) {
				var url = "websys.lookup.csp";
				//url += "?ID=dXXXiYYY";  XXX=compID,YYY=fieldname
				//url += "?TFORM=" + fld.form.TFORM.value + "^" + fld.name;
				url += "?ID=i"+fld.name;
				if (lookupqry) url += "&CONTEXT="+lookupqry;
				if (execjs) url += "&TLUJSF="+execjs;
				url += "&P1=" + code;
				var tmp=url.split('%');
				url=tmp.join('%25');
				websys_lu(url,1,'');
			}
		}
		return websys_cancel();
	}
}
function COMPLocateCode(fld,encmeth,arrParams,SimpleDSS) {
	var code="";
	var keychar = websys_getKey(event);
	if (keychar == endAscii) {
		code = GetCode(fld);
		if (enteredField) {
			var params=arrParams.join(",");
			if (params!="") params+=","
			eval("cspRunServerMethod(encmeth,"+params+"code);");
		}
	} else if (keychar == 117) { //F6 key for lookup

		code = GetCode(fld);

		if (enteredField) {
			//if (objClassName) ClassName=objClassName.value;
			//if (objCP) ClassProperty=objCP.value;

			// 59799
			//var url='websys.dssrule.lookup.csp?classname=' + arrParams + '&sqlfieldname=';
			var url='websys.dssrule.lookup.csp?classname=' + arrParams + '&sqlfieldname=&SimpleDSS='+SimpleDSS;
			//var url='websys.dssrule.lookup.csp?classname=' + ClassName + '&sqlfieldname=' + ClassProperty;
			websys_lu(url,true,'');

		}
		return websys_cancel();
	}
}

function LookupCode_replace(newval,isrtf) {
	if (isrtf) {
		enteredField.Replace(newval);
		var objRTF=document.getElementById("NOTRTFNotes");
		var objDesc=document.getElementById("NOTDesc");
		if (objRTF && objDesc) {
			objDesc.value = objRTF.Text;
		}
	} else {
		if (enteredField) {
			//alert('back with: ' + newval + '\nentered: ' + enteredField
			//+ '\nenteredtextrange: ' + enteredField.createTextRange
			//+ '\nenteredcursor: ' + enteredField.cursorPos);

			var origtxt = enteredField.value;
			if (enteredField.createTextRange && enteredField.cursorPos) {enteredField.cursorPos.text=newval;}
			enteredField.focus();
			enteredField = null;
		}
	}
}
function LookupCode_replace_withToken(newval) {
	if (enteredField) {
		var origtxt = enteredField.value;
		if (enteredField.createTextRange && enteredField.cursorPos) {enteredField.cursorPos.text=startDelim+newval+endDelim;}
		enteredField.focus();
		enteredField = null;
	}
}

function ResultCode_lookupSelect(str) {
	var arrtxt=str.split(" | ");
	txt=arrtxt.join("\n");
	LookupCode_replace(txt);
}

function MRCWordResultCode_lookupSelect(str) {
	var arrtxt=str.split("^");
	ResultCode_lookupSelect(arrtxt[1])
}

function RTFNursingNoteCodes_lookupSelect(str) {
	//var lu=str.split("^");
	//var str=lu[1];
	var lu=str.split("^");
	var txt=lu[1];
	if (!txt) txt=lu[0];
	var arrtxt=txt.split(" | ");
	txt=arrtxt.join("\n");
	LookupCode_replace(txt,true);
}

function NursingNoteCodes_lookupSelect(str) {
	//alert();
	var lu=str.split("^");
	var txt=lu[1];
	if (!txt) txt=lu[0];
	var arrtxt=txt.split(" | ");
	txt=arrtxt.join("\n");
	LookupCode_replace(txt,false);
}
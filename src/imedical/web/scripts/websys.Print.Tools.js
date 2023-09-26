// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 52857 - AI - 04-05-2006 : * NOTE * 'newwin' is overwritten in this function, regardless of its value.
//                             : Could have been set in Menu Manager, "Show In New Window" field.
function PassReportParametersForPreview(path,newwin,p0,p1,p2,p3,p4,p5,p6,p7,p8) {
	// this function automatically builds the prompt(n) variables which are required for previewing a crystal report.
	// parameter values will either be passed in via p0-p8 or via the original link (path)
	var temp=""
	var arrParam=path.split("&prompt");
	var newpath=arrParam[0];
	for (var i=0; i<9; i++) {
		newpath+="&prompt"+i+"=";
		//if parameter defined, pass along to report. these parameters are usually the specific values of the selected row
		if (eval("p"+i)) {
			newpath+=eval("p"+i);
		} else { // take value from original link
			temp=mPiece(path,"prompt"+i+"=",1);
			newpath+=mPiece(temp,"&",0);
		}
	}

	// Log 56249 - AI - 26-10-2005 : Also pass in the reportmanagerdsn and configmanagerdsn parameters to crystalpreview.asp.
	var str=path.split("&reportmanagerdsn=");
	var dsnstr=str[1].split("&configmanagerdsn=");
	newpath=newpath+"&reportmanagerdsn="+dsnstr[0]+"&configmanagerdsn="+dsnstr[1];
	// end Log 56249

	//alert(path+'\n'+newpath);

	// Log 52857 - AI - 04-05-2006 : Overwrite 'newwin' value (passed in var) and use it to set up the window size as "max screen".
	//                             : Original logic commented out - passed through "" only.
	newwin="top=0,left=0,width="+screen.availWidth+",height="+screen.availHeight;
	//websys_lu(newpath,false,"");
	websys_lu(newpath,false,newwin);
	// end Log 52857
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    } else {
	  return "";
    }
}

function CompleteReportLoading() {
	//for wasting time to allow report.auto to load in same frame
	var arrTemp=new Array();
	for (var i=0; i<9; i++) {
		if (eval("arrTemp["+i+"]")) {
		}
	}
}

function PassReportParameters(path,newwin,p0,p1,p2,p3,p4,p5,p6,p7,p8) {
	// TP: this is old code and should not be called anywhere - it remains here for reference only while testing
	var arrParam=path.split("&prompt");
	var newpath=arrParam[0];
	for (var i=0; i<9; i++) {
		newpath+="&prompt"+i+"=";
		//if parameter defined, pass along to report
		if (eval("p"+i)) {
			newpath+=eval("p"+i);
		}
	}
	//alert(newpath);
	if (newwin=="TRAK_hidden") {
		//window.top.frames["TRAK_hidden"].location = newpath;
		websys_createWindow(newpath,"TRAK_hidden");
	} else {
		websys_lu(newpath,false,"");
	}
}
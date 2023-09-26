// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// KK 19-Feb-2002 Log-22795

var fname=VoiceFilePathAndName();
//var objFileSys = new ActiveXObject("Scripting.FileSystemObject");
function DisableField(fld,objIcon) {

	//var fld = document.getElementById(fldName);
	if (fld) {
		//alert("fld "+fld);
		fld.disabled = true;
	}
	if (objIcon) {
		//var objIcon=document.getElementById(icN);
		//alert("in here"+objIcon);
		if (objIcon) objIcon.style.visibility = "hidden";
	}
}
function VoiceLoadHandler(PlayMode,UseFootPedal) {
	var VOICEform=document.forms["fVoice_Link"];
	//if (VOICEform) alert(" VOICEform  "+VOICEform);
	if (VOICEform) {
		var DFobj=VOICEform.elements["DisableFlag"];
		//alert(DFobj+" val "+DFobj.value);
		if ((DFobj)&&(DFobj.value==1)){
			var RBobj=VOICEform.elements["UserCode"];
			if (RBobj) DisableField(RBobj,"");
			var objUpdate=document.getElementById("update1");
			if (objUpdate) DisableField(objUpdate,"");
			var OBobj=VOICEform.elements["Radiologist"];
			var COBobj=VOICEform.elements["ld1279iRadiologist"];
			//alert(OBobj+" OBobj "+COBobj+" COBobj ");
			if (OBobj) DisableField(OBobj,COBobj);
			var ABobj=VOICEform.elements["AbnormalRes"];
			if (ABobj) DisableField(ABobj,"");
			var TBobj=VOICEform.elements["TranscribedBy"];
			var CTBobj=VOICEform.elements["ld1279iTranscribedBy"];
			if (TBobj) DisableField(TBobj,CTBobj);
		}
	}
	objUpdate=document.getElementById('update1')
	if (objUpdate) objUpdate.onclick = UpdateAllDelay;
	if (tsc['update1']) {
		websys_sckeys[tsc['update1']]=UpdateAllDelay;
	}
	AbnormalRes_changehandler;
	var obj=document.getElementById('AbnormalRes')
	if (obj) obj.onclick=AbnormalRes_changehandler;

	//log 62487 TedT
	if (document.getElementById('CompDisabled').value==1) {
		var obj=document.getElementById("update1")
		if (obj) {obj.disabled=true; obj.onclick=""}
		PlayMode="True";
	}

	var trakSound=document.getElementById('trakSound');
	//var trakSound=new self.ActiveXObject("tkwebSound.clsSoundControl");
	//trakSound=null;
	//var trakSound=new self.ActiveXObject("tkSoundexe.clsSoundControl");
	if (trakSound) {
		trakSound.TempDirectory = "C:"
		//if (trakSound) alert("TrakSound Exists,filename = " + fname + "playmode="+PlayMode);
		trakSound.FileName=fname;
		//alert("Sending in to control: " + fname);
		//alert(trakSound.FileName);
		trakSound.PlayMode=PlayMode;
		trakSound.UseFootPedal=UseFootPedal;
		//trakSound.Start();
		trakSound.initialise();
		//delete trakSound;
		//trakSOund=null;
	}
}

function UserCode_changehandler(encmeth) {
	var obj=document.getElementById('UserCode');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('UserCode');
	//log 57085 BoC
	if (cspRunServerMethod(encmeth,'','LookUpUserSelect',p1,'','','Y')=='0') {
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

function AbnormalRes_changehandler() {
	var obj=document.getElementById('AbnormalRes')
	var objflag=document.getElementById('AbnormalFlag')
	if ((obj)&&(objflag)) {
		if (obj.checked==true) { objflag.value="on" }
		else if (obj.checked==false) { objflag.value="off" }
	}
}


function UpdateAll() {
	////Save the file and then call the update method
	//trakSound.Save(fname);
	var VOICEform=document.forms["fVoice_Link"];
	//if (VOICEform) alert(" VOICEform  "+VOICEform);

	//Log 61271 PeterC 21/12/06
	var obj=document.getElementById('TranscribedBy');
	if((obj)&&(obj.className=='clsInvalid')) {
		alert(t['TranscribedBy']+ " " +t['XINVALID']);
		return false;
	}

	var obj=document.getElementById('UserCode');
	if((obj)&&(obj.className=='clsInvalid')) {
		alert(t['UserCode']+ " " +t['XINVALID']);
		return false;
	}

	var obj=document.getElementById('Radiologist');
	if((obj)&&(obj.className=='clsInvalid')) {
		alert(t['Radiologist']+ " " +t['XINVALID']);
		return false;
	}

	var obj=document.getElementById('Description');
	if((obj)&&(obj.className=='clsInvalid')) {
		alert(t['Description']+ " " +t['XINVALID']);
		return false;
	}

	if (VOICEform) {
		// Log 62067 - AI - 28-12-2006 : Retrieve the length of the voice file for saving.
		//alert(document.getElementById("trakSound").object.WaveLength);
		var objlength=document.getElementById('VoiceFileLength');
		var objvoice=document.getElementById("trakSound")
		if (objvoice && objvoice.object) {
			if(objlength) objlength.value=objvoice.object.WaveLength;
			//log 62575 TedT added Dirty flag
			if(objvoice.object.Dirty && !confirm(t['NOTSAVED']))
				return false;
		}

		// Log 33358 - AI - 23-04-2003 : Set whether the Description Field exists On the Layout of the component. Used in web.OEOrdResult SaveVoiceFile.
		var objDesc=document.getElementById('Description');
		var objFlag=VOICEform.elements["DescriptionFieldOnLayout"];
		if (objDesc){
			if (objFlag) objFlag.value="Y";
		} else {
			if (objFlag) objFlag.value="N";
		}
		// end Log 33358
		var objFileSys = new ActiveXObject("Scripting.FileSystemObject");
		var fil=objFileSys.FileExists(fname);
		if (fil==false) document.getElementById('FilePathAndName').value="";
		var DFobj=VOICEform.elements["DisableFlag"];
		if ((DFobj)&&(DFobj.value==0)){
			update1_click();
		} else if ((DFobj)&&(DFobj.value==1)){
			return false;
		}
	}
	if ((window.opener)&&(window.opener.parent[1])){
		var winp=window.opener.parent[1];
		window.close();
		winp.treload('websys.csp');
	}
}

function VoiceFilePathAndName() {

	//SA: VoiceSaveFilePath is an delimited string of Paths separated by a semicolon (;)
	//The first path is the primary which will be saved via the code here
	//(in function "OpenWordDoc"). All other paths will be passed to the document
	//template to be saved on the Document_Close event.

	obj=document.getElementById('VoiceSaveFilePath');
	if (obj) var strVoiceSaveFilePathArray=obj.value

	obj=document.getElementById('VoiceSaveFileSubDir');
	if (obj) var strVoiceSaveFileSubDir=obj.value

	obj=document.getElementById('VoiceSaveFileName');
	if (obj) var strVoiceSaveFileName=obj.value


	//alert("VoiceSaveFilePathArray:" + strVoiceSaveFilePathArray);
	//alert("VoiceSaveFileSubDir:" + strVoiceSaveFileSubDir);
	//alert("VoiceSaveFileName:" + strVoiceSaveFileName);

	//not actually an array, but delimited string of paths separated by ";"
	//just easier to name this way to distinguish from single path.
	var FileSavePathsArray=""
	var i=0
	while (mPiece(strVoiceSaveFilePathArray,";",i)!="") {
		var strVoiceSaveFilePath = mPiece(strVoiceSaveFilePathArray,";",i)

		if ((strVoiceSaveFilePath!="") && (strVoiceSaveFileSubDir!="") && (strVoiceSaveFileName!="")) {
			// .wav extension hardcoded to be saved for voice files only
			strFilePathAndName = strVoiceSaveFilePath+strVoiceSaveFileSubDir+strVoiceSaveFileName+".wav"
			strFilePath = strVoiceSaveFilePath+strVoiceSaveFileSubDir
		}
		CreateVoiceFilePath(strFilePath)
		//FileSavePathsArray=FileSavePathsArray+strFilePathAndName+";"
		FileSavePathsArray=FileSavePathsArray+strFilePathAndName
		i=i+1
	}

	//setting the hidden field in the form that will save the file name
	//(eg. "\20010327\.wav") to OEORDResult.RESFileName
	var objFileName=document.getElementById('FilePathAndName');
	if (objFileName) {
		objFileName.value=strVoiceSaveFileSubDir+strVoiceSaveFileName+".wav";
		//alert("FileName:" + objFileName.value);
	}
	// if already a voice file is created then open that file
	var objSavedVoiceFileName=document.getElementById('SavedVoiceFileName');
	if ((objSavedVoiceFileName) && (objSavedVoiceFileName.value!="")){
		strSavedVoiceFileName=objSavedVoiceFileName.value;
		//alert(strSavedVoiceFileName);
		var objVoiceSaveFilePath=document.getElementById('VoiceSaveFilePath');
		if (objVoiceSaveFilePath) var strVoiceSaveFilePathArray=objVoiceSaveFilePath.value;
		var strVoiceSaveFilePath = mPiece(strVoiceSaveFilePathArray,";",0);
		if(strVoiceSaveFilePath==""){strVoiceSaveFilePath=strVoiceSaveFilePathArray;}
		FileSavePathsArray = strVoiceSaveFilePath+strSavedVoiceFileName;
		//alert(FileSavePathsArray);
	}
	return FileSavePathsArray
}

function CreateVoiceFilePath(FilePath) {
	var objFileSys = new ActiveXObject("Scripting.FileSystemObject");

	// SA: Check if directory for document to be saved exists. If not,create it.
	// A single backslash is a specific character in JS, so directory path must
	// have a second backslash for each backslash. Comparison also requires "\\"
	// when comparing "\"

	for (var i=0; i<FilePath.length; i++) {
	strFilePath+=FilePath.charAt(i);
	if (FilePath.charAt(i)=="\\") strFilePath+="\\";
	}

	//alert("FilePath:" + FilePath);

	if (!objFileSys.FolderExists(FilePath)) {
		objFileSys.CreateFolder(FilePath);
	}
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
      delimArray = s1.split(sep);

	//If out of range, return a blank string
      if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
      }
}

function LookUpUserSelect(txt) {
	var adata=txt.split("^")
	var repby=document.getElementById("UserCode")
	if (repby) {
		repby.value=adata[0];
	}
}

//Log 61271 PeterC 21/12/06
function UserOnBlurHandler() {
	var repby=document.getElementById("UserCode")
	if (repby) {
		if((repby)&&(repby.value=="")) repby.className="";
	}
}

function UpdateAllDelay() {
	window.setTimeout("UpdateAll()",200)
}

var obj=document.getElementById('UserCode');
if(obj) obj.onblur=UserOnBlurHandler;


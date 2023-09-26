// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// LOG 34033 RC 17/04/03

var doc="";
var objWrdApp = new ActiveXObject("Word.Application");

function CloseWordDoc() {
	document.wordDocObj.Close();
	objWrdApp.Quit();
}

function SaveWordDoc() {
	var objSaveFilePath=document.getElementById('SaveFilePath');
	if (objSaveFilePath) var strSaveFilePathArray=objSaveFilePath.value;
	var strSaveFilePath = mPiece(strSaveFilePathArray,";",0);
	if(strSaveFilePath==""){strSaveFilePath=strSaveFilePathArray;}
	var objSaveFileSubDir=document.getElementById('SaveFileSubDir');
	if (objSaveFileSubDir) strSaveFileSubDir=objSaveFileSubDir.value;
	var objSaveFileName=document.getElementById('SaveFileName');
	if (objSaveFilePath) var strSaveFileName=objSaveFileName.value;
	var objTXTSaveFileName=document.getElementById('TXTSaveFileName');
	if (objTXTSaveFileName) var strTXTSaveFileName=objTXTSaveFileName.value

	// Save the TXT file
	var savedir=strSaveFileSubDir+strTXTSaveFileName+".txt";
	var filepath=strSaveFilePath+savedir;
	document.wordDocObj.Save(filepath,true);
	if (document.getElementById('TXTPath')) document.getElementById('TXTPath').value=savedir;

	// Save the RTF file
	var savedir=strSaveFileSubDir+strSaveFileName+".rtf";
	// RC 17/04/03 Make sure it saves to the right path and not continually creating a new document.
	var objSavedFileName=document.getElementById('SavedFileName');
	if (objSavedFileName&&objSavedFileName.value!="") savedir=objSavedFileName.value
	// Continue Saving
	var filepath=strSaveFilePath+savedir;
	document.wordDocObj.Save(filepath,true);
	if (document.getElementById('DocPath')) document.getElementById('DocPath').innerHTML=savedir;
	if (document.getElementById('RTFPath')) document.getElementById('RTFPath').value=savedir;
}

function OpenWordDoc() {
	//var objWrdApp = new ActiveXObject("Word.Application");
	var objTemplatePath=document.getElementById('TemplatePath');
	if (objTemplatePath) {
		var strTemplatePath = objTemplatePath.value+"/"
		//if there is a word document already saved for this order item then show that document otherwise show template
		var objSavedFileName=document.getElementById('SavedFileName');
		var objOEStat=document.getElementById('OEItemStatus');
		if (objOEStat) strStatus=objOEStat.value;
		if ((objSavedFileName) && (objSavedFileName.value!="")){
			strSavedFileName=objSavedFileName.value;
			var objSaveFilePath=document.getElementById('SaveFilePath');
			if (objSaveFilePath) var strSaveFilePathArray=objSaveFilePath.value;
			var strSaveFilePath = mPiece(strSaveFilePathArray,";",0);
			if(strSaveFilePath=="") strSaveFilePath=strSaveFilePathArray;
			document.wordDocObj.Open(strSaveFilePath+strSavedFileName);
			try {
				objWrdApp.Run("OpenDocument");
				objWrdApp.Quit();
			} catch(e) {
				//alert("Error Medtrak"+e);
			}
			document.wordDocObj.Activate();
			if (document.getElementById('DocPath')) document.getElementById('DocPath').innerHTML=strSavedFileName;
		} else {
			var objTemplateName=document.getElementById('TemplateName');
			if (objTemplateName) {
				var strTemplateName=objTemplateName.value;
				if (strTemplateName==""){
					alert("No Template");
				}
			}
			document.wordDocObj.Open(strTemplatePath+strTemplateName);
			//if (objWrdDoc) AddVariables(objWrdDoc);
			//AddVariables();
			//objWrdDoc.Variables.Add("PatientID","26517");
			//var objWrdDoc=document.wordDocObj.ActiveDocument;
			//var objPatientID=document.getElementById('PatientID');
			//var strPatientID=objPatientID.value
			//objWrdDoc.Document.Variables.Add("PatientID","26517");
			try {
				objWrdApp.Run("MedTrak");
				objWrdApp.Quit();
			} catch(e) {
				//alert("Error Medtrak"+e);
			}
			//objWrdDoc.ActiveWindow.Selection.InsertAfter("*** testing here ***");
			//var objWrdDoc=document.wordDocObj.ActiveDocument;
			//objWrdDoc.Variables.Add("PatientID","26517");
			document.wordDocObj.Activate();
			if (document.getElementById('DocPath')) document.getElementById('DocPath').innerHTML="New Document";
		}
	}
}

function AddVariables() {
	var objWrdDoc=document.wordDocObj.ActiveDocument;
	//var objWrdDoc = objWrdApp.Documents.Add(path);
	var objEpisodeID=document.getElementById('EpisodeID');
	if ((objEpisodeID&&objWrdDoc)&&(objEpisodeID.value!="")) {
		var strEpisodeID=objEpisodeID.value;
		//alert(objEpisodeID.value)
		var objOEOrdItemID=document.getElementById('OEOrdItemID');
		var strOEOrdItemID=objOEOrdItemID.value
		var objPatientID=document.getElementById('PatientID');
		var strPatientID=objPatientID.value
		var objCacheDateNow=document.getElementById('CacheDateNow');
		var strCacheDateNow=objCacheDateNow.value
		var objCacheTimeNow=document.getElementById('CacheTimeNow');
		var strCacheTimeNow=objCacheTimeNow.value
		//var objDischLetterRowId=document.getElementById('DischLetterRowId');
		//var strDischLetterRowId=objDischLetterRowId.value
		var objVerifiedRowId=document.getElementById('VerifiedRowId');
		var strVerifiedRowId=objVerifiedRowId.value
		var objEnteredRowId=document.getElementById('EnteredRowId');
		var strEnteredRowId=objEnteredRowId.value
		var objOrderHeaderRowId=document.getElementById('OrderHeaderRowId');
		var strOrderHeaderRowId=objOrderHeaderRowId.value
		var objOrderSequenceRowId=document.getElementById('OrderSequenceRowId');
		var strOrderSequenceRowId=objOrderSequenceRowId.value
		var objVoiceFile=document.getElementById('VoiceFile');
		var strVoiceFile="";
		if (objVoiceFile) strVoiceFile=objVoiceFile.value

		var user=session['LOGON.USERID'];

		objSaveFileSubDir=document.getElementById('SaveFileSubDir');
		if (objSaveFileSubDir) var strSaveFileSubDir1=objSaveFileSubDir.value;
		objSaveFileName=document.getElementById('SaveFileName');
		if (objSaveFileName) var strSaveFileName1=objSaveFileName.value;
		var strSubDirAndName=strSaveFileSubDir1+strSaveFileName1+".rtf";
		//var strSubDirAndName=strSaveFileSubDir1+strSaveFileName1+".doc";
		//
		objTXTSaveFileName=document.getElementById('TXTSaveFileName');
		if (objSaveFileName) var strTXTSaveFileName1=objTXTSaveFileName.value;
		var strTXTSubDirAndName=strSaveFileSubDir1+strTXTSaveFileName1+".txt";
		//alert(objWrdDoc+"  "+strEpisodeID)

		//alert("done here");
		objWrdDoc.Variables.Add("OEOrdItemIDs",strOEOrdItemID);
		objWrdDoc.Variables.Add("OEItemStatus",strStatus);
		objWrdDoc.Variables.Add("PatientID",strPatientID);
		objWrdDoc.Variables.Add("CacheDateNow",strCacheDateNow);
		objWrdDoc.Variables.Add("CacheTimeNow",strCacheTimeNow);
		//objWrdDoc.Variables.Add("DischLetterRowId",strDischLetterRowId);
		objWrdDoc.Variables.Add("VerifiedRowId",strVerifiedRowId);
		objWrdDoc.Variables.Add("EnteredRowId",strEnteredRowId);
		objWrdDoc.Variables.Add("OrderHeaderRowId",strOrderHeaderRowId);
		objWrdDoc.Variables.Add("OrderSequenceRowId",strOrderSequenceRowId);
		objWrdDoc.Variables.Add("UserRowId",user);
		objWrdDoc.Variables.Add("SubDirAndName",strSubDirAndName);
		//alert("strTXTSubDirAndName "+strTXTSubDirAndName)
		objWrdDoc.Variables.Add("TXTSubDirAndName",strTXTSubDirAndName);
		objWrdDoc.Variables.Add("VoiceFileName",strVoiceFile);
		/*if (FileSavePaths==""){
			var FileSavePaths=FilePathAndName()
			objWrdDoc.Variables.Add("ShadowFileSavePaths",FileSavePaths);
			//alert("file pths "+FileSavePaths)
			//When the word document is created for the first time the "MedTrak" macro should be run
			//When the same document is opened again for viewing then "OpenDocument" macro should be run
			try {
				objWrdApp.Run("MedTrak");
			}
			catch(e){
				//alert("Error Medtrak"+e);
			}
		}*/
	}
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
    var delimArray ="";
	delimArray = s1.split(sep);
	  //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
    }
}

var save=document.getElementById('SaveDoc');
if (save) save.onclick=SaveWordDoc;

/*var readonly=1

if (readonly==1) {
	alert("This Document has been opened in Read-Only mode.");
	document.wordDocObj.Toolbars=0;
	document.wordDocObj.Open("//Porker/Developers/Medtrak/m6.21/Results/20030414/622.rtf",true);
	save.disabled=true;
} else {
	document.wordDocObj.Open("//Porker/Developers/Medtrak/m6.21/Results/Template/AARad1.dot");
}*/
// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function Init() {
	var obj=document.getElementById('OpenWordDoc');
	if (obj) obj.onclick=OpenWordDoc;

	OpenWordDoc();
	OpenWordDoc_click();
}

function OpenWordDoc() {
	var objWrdApp = new ActiveXObject("Word.Application");
	//var objWrdDoc = new ActiveXObject("Word.Document");
	objWrdApp.visible=true;

	if (objWrdApp) {
		//var wrdDoc=wrdApp.documents.Add();
		var objTemplatePath=document.getElementById('TemplatePath');
		var objTemplateName=document.getElementById('TemplateName')
		if (objTemplateName.value=="") objTemplateName.value="webDischarge.dot"
		if (objTemplatePath) {
			var strTemplatePath = objTemplatePath.value+"/"+objTemplateName.value
			//var objWrdDoc = objWrdApp.Documents.Add(strTemplatePath+"webDischarge.dot");
			var objWrdDoc = objWrdApp.Documents.Add(strTemplatePath);
			if (objWrdDoc) {
				var objEpisodeID=document.getElementById('EpisodeID');
				if (objEpisodeID) {
					var strEpisodeID=objEpisodeID.value
					var objDSN=document.getElementById('DSN');
					if (objDSN) var strDSN=objDSN.value
					var objCacheDateNow=document.getElementById('CacheDateNow');
					var strCacheDateNow=objCacheDateNow.value
					var objCacheTimeNow=document.getElementById('CacheTimeNow');
					var strCacheTimeNow=objCacheTimeNow.value
					var objDischLetterRowId=document.getElementById('DischLetterRowId');
					var strDischLetterRowId=objDischLetterRowId.value
					var objVerifiedRowId=document.getElementById('VerifiedRowId');
					var strVerifiedRowId=objVerifiedRowId.value
					var objOrderVerifiedRowId=document.getElementById('OrderVerifiedRowId');
					var strOrderVerifiedRowId=objOrderVerifiedRowId.value
					var objOrderHeaderRowId=document.getElementById('OrderHeaderRowId');
					var strOrderHeaderRowId=objOrderHeaderRowId.value
					var objOrderSequenceRowId=document.getElementById('OrderSequenceRowId');
					var strOrderSequenceRowId=objOrderSequenceRowId.value
					//var objPrinterPath=document.getElementById('PrinterPath');
					//var strPrinterPath=objPrinterPath.value
					var user=session['LOGON.USERID'];

					objSaveFileSubDir=document.getElementById('SaveFileSubDir');
					if (objSaveFileSubDir) var strSaveFileSubDir1=objSaveFileSubDir.value;
					objSaveFileName=document.getElementById('SaveFileName');
					if (objSaveFileName) var strSaveFileName1=objSaveFileName.value;
					var strSubDirAndName=strSaveFileSubDir1+strSaveFileName1+".rtf";
					//alert(strSubDirAndName);

					objWrdDoc.Variables.Add("EpisodeID",strEpisodeID);
					objWrdDoc.Variables.Add("CacheDateNow",strCacheDateNow);
					objWrdDoc.Variables.Add("CacheTimeNow",strCacheTimeNow);
					objWrdDoc.Variables.Add("DischLetterRowId",strDischLetterRowId);
					objWrdDoc.Variables.Add("VerifiedRowId",strVerifiedRowId);
					objWrdDoc.Variables.Add("OrderVerifiedRowId",strOrderVerifiedRowId);
					objWrdDoc.Variables.Add("OrderHeaderRowId",strOrderHeaderRowId);
					objWrdDoc.Variables.Add("OrderSequenceRowId",strOrderSequenceRowId);
					objWrdDoc.Variables.Add("UserRowId",user);
					objWrdDoc.Variables.Add("SubDirAndName",strSubDirAndName);
					objWrdDoc.Variables.Add("DSN",strDSN);
					//objWrdDoc.Variables.Add("PrinterPath",strPrinterPath);

					var FileSavePaths=FilePathAndName()
					objWrdDoc.Variables.Add("ShadowFileSavePaths",FileSavePaths);

					//alert(FileSavePaths)
					//Run Word Macro sub name "Medtrak"
					objWrdApp.Run("Medtrak");

					//Initial save against primary path
					//SA 9.4.01: Save commented out. File will be saved
					//to all paths via template macro.
					//var FileSavePath1=mPiece(FileSavePaths,";",0)
					//if (FileSavePath1!="") {
					//	objWrdDoc.SaveAs(FileSavePath1);
					//}
				}
			}
		}
	}

	//Close word with the Quit method on the Application object.
	//objWrdApp.Application.Quit();

}

function FilePathAndName() {

	//SA: SaveFilePath is an delimited string of Paths separated by a semicolon (;)
	//The first path is the primary which will be saved via the code here
	//(in function "OpenWordDoc"). All other paths will be passed to the document
	//template to be saved on the Document_Close event.

	obj=document.getElementById('SaveFilePath');
	if (obj) var strSaveFilePathArray=obj.value

	obj=document.getElementById('SaveFileSubDir');
	if (obj) var strSaveFileSubDir=obj.value

	obj=document.getElementById('SaveFileName');
	if (obj) var strSaveFileName=obj.value

	//not actually an array, but delimited string of paths separated by ";"
	//just easier to name this way to distinguish from single path.
	var FileSavePathsArray=""
	var i=0
	while (mPiece(strSaveFilePathArray,";",i)!="") {
		var strSaveFilePath = mPiece(strSaveFilePathArray,";",i)

		if ((strSaveFilePath!="") && (strSaveFileSubDir!="") && (strSaveFileName!="")) {
			// .doc/.rtf extension hardcoded to be saved for word documents only
			strFilePathAndName = strSaveFilePath+strSaveFileSubDir+strSaveFileName+".rtf"
			strFilePath = strSaveFilePath+strSaveFileSubDir
		}

		CreateFilePath(strFilePath)
		FileSavePathsArray=FileSavePathsArray+strFilePathAndName+";"
		i=i+1
	}

	//setting the hidden field in the form that will save the file name
	//(eg. "\20010327\1201.rtf") to OEORDResult.RESFileName
	var objFileName=document.getElementById('FilePathAndName');
	if (objFileName) {
		objFileName.value=strSaveFileSubDir+strSaveFileName+".rtf"
		//alert(objFileName.value)
	}

	return FileSavePathsArray
}

function CreateFilePath(FilePath) {
	var objFileSys = new ActiveXObject("Scripting.FileSystemObject");

	// SA: Check if directory for document to be saved exists. If not,create it.
	// A single backslash is a specific character in JS, so directory path must
	// have a second backslash for each backslash. Comparison also requires "\\"
	// when comparing "\"

	for (var i=0; i<FilePath.length; i++) {
	strFilePath+=FilePath.charAt(i);
	if (FilePath.charAt(i)=="\\") strFilePath+="\\";
	}

	//alert(strFilePath)

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

document.body.onload=Init;

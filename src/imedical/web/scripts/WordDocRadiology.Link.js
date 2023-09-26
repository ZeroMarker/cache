// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// KK 19-Feb-2002 Log-22796
// f NortonAntiVirus is installed
// Error Opeing Word application - Error:"Call was rejected by callee" then
// we need to restart the machine after unregistering  "OfficeAV.dll" in the "NortonAntiVirus" folder
var customWindowState=0
var updated=false; //log59575 TedT

function WordDocLoadHandler() {
	if (document.getElementById('CompDisabled').value!=1) {
		OpenWordDoc();
		var obj=document.getElementById('OpenWordDoc');
		if (obj) obj.onclick=OpenWordDoc;
		//Log 59504 PeterC 12/08/06
		var sfnobj=document.getElementById('SaveFileName');
		if((sfnobj)&&(sfnobj.value!="")) {
			var owdobj=document.getElementById('OpenWordDoc');
			if(owdobj) {
				owdobj.disabled=true;
				owdobj.onclick="";
			}
		}
	}
	if (document.getElementById('CompDisabled').value==1) {
		var obj=document.getElementById("OpenWordDoc")
		if (obj) {obj.disabled=true; obj.onclick=""}
		var obj=document.getElementById("Update")
		if (obj) {obj.disabled=true; obj.onclick=""}
	}
	AbnormalRes_changehandler;
	var obj=document.getElementById('AbnormalRes')
	if (obj) obj.onclick=AbnormalRes_changehandler;
	
	//log59575 TedT
	obj=document.getElementById('Cancel')
	if (obj) obj.onclick=CancelClickHandler;
}

function AbnormalRes_changehandler() {
	var obj=document.getElementById('AbnormalRes')
	var objflag=document.getElementById('AbnormalFlag')
	if ((obj)&&(objflag)) {
		if (obj.checked==true) { objflag.value="on" }
		else if (obj.checked==false) { objflag.value="off" }
	}
}

function OpenWordDoc() {
	//LOG 40023 RC 4/11/03 This 'GetObject' function will try to open an already existing instance of Word to use for
	//the template. If it can't find one, then it will just create a new instance of Word.
	//LOG 55488 JH 7/10/05 Now with new versions of word we can use the create object always without any performance issues -
	//and it fixes the problem that if the user has word open and minimised, the radiology report opens minimised too.
	//try {
	//	var objWrdApp = GetObject("","Word.Application");
	//} catch(e) {
	var objWrdApp = new ActiveXObject("Word.Application");
	//}
	var strStatus="";
	var FileSavePaths="";
	if (objWrdApp) {
		var objTemplatePath=document.getElementById('TemplatePath');
		if (objTemplatePath) {
			var strTemplatePath = objTemplatePath.value+"/"
			//if there is a word document already saved for this order item then show that document otherwise show template
			var objSavedFileName=document.getElementById('SavedFileName');
			var objRESId=document.getElementById('RESRowId');
			var objOEStat=document.getElementById('OEItemStatus');
			if (objOEStat) strStatus=objOEStat.value;
			if ((objSavedFileName) && (objSavedFileName.value!="")){
				strSavedFileName=objSavedFileName.value;
				var objSaveFilePath=document.getElementById('SaveFilePath');
				if (objSaveFilePath) var strSaveFilePathArray=objSaveFilePath.value;
				var strSaveFilePath = mPiece(strSaveFilePathArray,";",0);
				if(strSaveFilePath==""){strSaveFilePath=strSaveFilePathArray;}
				//alert(strSaveFilePath+strSavedFileName);
				var tmpfile=strSaveFilePath+"\\"+mPiece(strSavedFileName,"\\",1)+"\\"+"~$"+mPiece(strSavedFileName,"\\",2)
				if (CheckFileExists(tmpfile)==true) {
					var obj=document.getElementById("OpenWordDoc")
					if (obj) {obj.disabled=true; obj.onclick=""}
					var obj=document.getElementById("Update")
					if (obj) {obj.disabled=true; obj.onclick=""}
					return false;
				}
				var objWrdDoc = objWrdApp.Documents.Add(strSaveFilePath+strSavedFileName);
				if (objWrdDoc) {
					var FileSavePaths=FilePathAndName();
					if (FileSavePaths!=objWrdDoc.Variables.Item("ShadowFileSavePaths").Value) {
						try{
							objWrdDoc.Variables.Item("ShadowFileSavePaths").Value=FileSavePaths;
						}catch(e){}
					}
					//SB 26/02/03 (33236): When the order is Transcribed first, and then Reported later
					// the voice file doesn't exist as an ActiveDocument variable.
					var objVoiceFile=document.getElementById('VoiceFile'); var strVoiceFile="";
					if (objVoiceFile) strVoiceFile=objVoiceFile.value
					try{
						objWrdDoc.Variables.Add("VoiceFileName",strVoiceFile);
					}catch(e){}
					//SB 05/02/03 (31398): We now allow users to bounce between transcribed and reported status'.
					// The following line ensures that if the status is reported and the order has previous typed
					// results that we will create a supplimentary report.
					if (strStatus=="REP" && objWrdDoc.Variables("Status").Value=="Viewing") {
						try{
							objWrdDoc.Variables("ShadowFileSavePaths").Value=FileSavePaths;
						}catch(e){}
					}
				}
				try {
					//objWrdApp.Run("OpenDocument");
					//BR 20/01/06 58024 for word 2000 is necessary to set the window to visible before setting the window start.
					//Otherwise the screen opens with no menu and toolbars
					objWrdApp.visible=true;
					objWrdApp.WindowState = 2;
					objWrdApp.WindowState = customWindowState;
					objWrdApp.Run("OpenDocument");
				}catch(e){alert(e.description)}
				return false;
			}
			else {
				var objTemplateName=document.getElementById('TemplateName');
				if (objTemplateName) {
					var strTemplateName=objTemplateName.value;
					if (strTemplateName==""){
						return false;
					}
				}
				var objWrdDoc = objWrdApp.Documents.Add(strTemplatePath+strTemplateName);
			}
			if (objWrdDoc) {
				var objEpisodeID=document.getElementById('EpisodeID');
				if ((objEpisodeID)&&(objEpisodeID.value!="")) {
					var strEpisodeID=objEpisodeID.value;
					var objDSN=document.getElementById('DSN');
					if (objDSN) var strDSN=objDSN.value
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

					/* LOG 39393 RC 03/10/03
					This code replaces the work done for LOG 36629. What it now does is the component checks the 'SaveFileName' to see
					if there is a 'SavedFileName' against the OrderID/ResultID. If there is, the SaveFileName is set to blank (""). What
					then needs to happen if that does occur, is that the counter from the SavedFileName needs to be grabbed and that
					used to create the FileSavePathsArray that is returned by this function.
					*/
					objSaveFileName=document.getElementById('SaveFileName');
					if (objSaveFileName) var strSaveFileName1=objSaveFileName.value;
					//var strSaveFileName1=parseInt(strSaveFileName1)
					//strSaveFileName1=strSaveFileName1+1
					var strSubDirAndName=strSaveFileSubDir1+strSaveFileName1+".rtf";
						// .doc extension not used anymore.
						//var strSubDirAndName=strSaveFileSubDir1+strSaveFileName1+".doc";
					// LOG 36629 RC 11/07/03 Needs to be done with the text file as well.
					objTXTSaveFileName=document.getElementById('TXTSaveFileName');
					if (objSaveFileName) var strTXTSaveFileName1=objTXTSaveFileName.value;
					//strTXTSaveFileName1=parseInt(strTXTSaveFileName1);
					//strTXTSaveFileName1=strTXTSaveFileName1+1
					var strTXTSubDirAndName=strSaveFileSubDir1+strTXTSaveFileName1+".txt";

					//RC This is just to tidy up the code a bit and try and make it more efficient.
					var VariableAdd=objWrdDoc.Variables
					VariableAdd.Add("EpisodeID",strEpisodeID);
					VariableAdd.Add("OEOrdItemIDs",strOEOrdItemID);
					VariableAdd.Add("OEItemStatus",strStatus);
					VariableAdd.Add("PatientID",strPatientID);
					VariableAdd.Add("CacheDateNow",strCacheDateNow);
					VariableAdd.Add("CacheTimeNow",strCacheTimeNow);
					//objWrdDoc.Variables.Add("DischLetterRowId",strDischLetterRowId);
					VariableAdd.Add("VerifiedRowId",strVerifiedRowId);
					VariableAdd.Add("EnteredRowId",strEnteredRowId);
					VariableAdd.Add("OrderHeaderRowId",strOrderHeaderRowId);
					VariableAdd.Add("OrderSequenceRowId",strOrderSequenceRowId);
					VariableAdd.Add("UserRowId",user);
					VariableAdd.Add("SubDirAndName",strSubDirAndName);
					VariableAdd.Add("TXTSubDirAndName",strTXTSubDirAndName);
					VariableAdd.Add("VoiceFileName",strVoiceFile);
					//objWrdDoc.Variables.Add("UpdateCounter","True");
					VariableAdd.Add("DSN",strDSN);
					/*var objSavedFileName=document.getElementById('SavedFileName');
					if ((objSavedFileName) && (objSavedFileName.value!="")){
						strSavedFileName=objSavedFileName.value;
						var objSaveFilePath=document.getElementById('SaveFilePath');
						if (objSaveFilePath) var strSaveFilePathArray=objSaveFilePath.value;
						var strSaveFilePath = mPiece(strSaveFilePathArray,";",0);
						if(strSaveFilePath==""){strSaveFilePath=strSaveFilePathArray;}
						VariableAdd.Add("SaveFilePathandName",strSaveFilePath+strSavedFileName);
					}*/
					if (FileSavePaths==""){
						var FileSavePaths=FilePathAndName()
						objWrdDoc.Variables.Add("ShadowFileSavePaths",FileSavePaths);
						//When the word document is created for the first time the "MedTrak" macro should be run
						//When the same document is opened again for viewing then "OpenDocument" macro should be run
						try {
							//objWrdApp.Run("MedTrak");
							//objWrdApp.Run("TemplateStart");
							//BR 20/01/06 58024 for word 2000 is necessary to set the window to visible before setting the window start.
							//Otherwise the screen opens with no menu and toolbars
							objWrdApp.visible=true;
							objWrdApp.WindowState = 2;
							objWrdApp.WindowState = customWindowState;
							objWrdApp.Run("MedTrak");
						}
						catch(e){}
					}
				}
			}
		}
	}
}


function FilePathAndName() {
	/*
	SA: SaveFilePath is an delimited string of Paths separated by a semicolon (;)
	The first path is the primary which will be saved via the code here
	(in function "OpenWordDoc"). All other paths will be passed to the document
	template to be saved on the Document_Close event.
	*/
	var obj=document.getElementById('OEItemStatus');
	if (obj) var stat=obj.value;
	var obj=document.getElementById('CurWordResStat');
	if (obj) var curresstat=obj.value;
	var obj=document.getElementById('VerifiedRowId');
	if (obj) var verstat=obj.value;

	obj=document.getElementById('SaveFilePath');
	if (obj) var strSaveFilePathArray=obj.value;
	obj=document.getElementById('SaveFileSubDir');
	if (obj) var strSaveFileSubDir=obj.value;
	obj=document.getElementById('SavedFileName');
	if (obj) var strSavedFileName=obj.value;
	obj=document.getElementById('SaveFileName');
	if ((obj)&&(obj.value!="")) var strSaveFileName=obj.value;

	/* LOG 39393 RC 03/10/03
	This code replaces the work done for LOG 36629. What it now does is the component checks the 'SaveFileName' to see
	if there is a 'SavedFileName' against the OrderID/ResultID. If there is, the SaveFileName is set to blank (""). What
	then needs to happen if that does occur, is that the counter from the SavedFileName needs to be grabbed and that
	used to create the FileSavePathsArray that is returned by this function.
	*/
	/* 58600 RC 16/03/06
	Change made to file path array. If there is a save file already, it will use the old directory
	and save file name of that file, instead of just the file. That way it will only be saved in one spot, instead of
	continually saved into a new directory every time it's modified on a different day.
	*/

	//not actually an array, but delimited string of paths separated by ";"
	//just easier to name this way to distinguish from single path.
	var FileSavePathsArray=""
	var i=0
	while (mPiece(strSaveFilePathArray,";",i)!="") {
		var strSaveFilePath = mPiece(strSaveFilePathArray,";",i)

		if (strSaveFilePath!="") {
			if ((strSavedFileName!="")&&(curresstat!=verstat)) {
				//log 59575
				strFilePathAndName = strSaveFilePath+strSavedFileName;
				strFilePath = strSaveFilePath+"\\"+mPiece(strSavedFileName,"\\",1)+"\\";
			} else if ((strSaveFileSubDir!="") && (strSaveFileName!="")) {
				// .doc/.rtf extension hardcoded to be saved for word documents only //log61816 TedT need to include extension here
				strFilePathAndName = strSaveFilePath+strSaveFileSubDir+strSaveFileName+".rtf";
				strFilePath = strSaveFilePath+strSaveFileSubDir;
			}
		}
		CreateFilePath(strFilePath)
		FileSavePathsArray=FileSavePathsArray+strFilePathAndName+";"
		i=i+1
	}

	//Save as Text as well.
	obj=document.getElementById('TXTSaveFilePath');
	if (obj) var strTXTSaveFilePathArray=obj.value;
	obj=document.getElementById('SaveFileSubDir');
	if (obj) var strTXTSaveFileSubDir=obj.value;
	obj=document.getElementById('SavedTXTFileName');
	if (obj) var strSavedTXTFileName=obj.value;
	// LOG 36629 RC 11/07/03 Needs to be done with the text file as well.
	// LOG 39393 RC 03/10/03 This code replaces the work done for LOG 36629.
	obj=document.getElementById('TXTSaveFileName');
	if ((obj)&&(obj.value!="")) var strTXTSaveFileName=obj.value;

	i=0;
	while (mPiece(strTXTSaveFilePathArray,";",i)!="") {
		var strTXTSaveFilePath = mPiece(strTXTSaveFilePathArray,";",i)
		if (strTXTSaveFilePath!="") {
			if ((strSavedTXTFileName!="")&&(curresstat!=verstat)) {
				//log 59575
				strTXTFilePathAndName = strTXTSaveFilePath+strSavedTXTFileName;
				strTXTFilePath = strTXTSaveFilePath+"\\"+mPiece(strSavedTXTFileName,"\\",1)+"\\";
			} else if ((strTXTSaveFileSubDir!="") && (strTXTSaveFileName!="")) {
				// .doc/.rtf extension hardcoded to be saved for word documents only //log61816 TedT need to include extension here
				strTXTFilePathAndName = strTXTSaveFilePath+strTXTSaveFileSubDir+strTXTSaveFileName+".txt";
				strTXTFilePath = strTXTSaveFilePath+strTXTSaveFileSubDir;
			}
		}
		CreateFilePath(strTXTFilePath)
		FileSavePathsArray=FileSavePathsArray+strTXTFilePathAndName+";"
		i=i+1
	}
	//setting the hidden field in the form that will save the file name
	//(eg. "\20010327\1201.rtf") to OEORDResult.RESFileName
	var objFileName=document.getElementById('FilePathAndName');
	if (objFileName) {
		// 58600 RC 16/03/06 use old directory if exists, otherwise use new one.
		if ((strSavedFileName!="")&&(stat!="RESV")) {
			objFileName.value = strSavedFileName;
		} else {
			objFileName.value = strSaveFileSubDir+strSaveFileName+".rtf"
		}
	}
	return FileSavePathsArray	
}

function CreateFilePath(FilePath) {
	var objFileSys = new ActiveXObject("Scripting.FileSystemObject");

	// SA: Check if directory for document to be saved exists. If not,create it.
	// A single backslash is a specific character in JS, so directory path must
	// have a second backslash for each backslash. Comparison also requires "\\"
	// when comparing "\"
	try {
		for (var i=0; i<FilePath.length; i++) {
			strFilePath+=FilePath.charAt(i);
			if (FilePath.charAt(i)=="\\") strFilePath+="\\";
		}
		if (!objFileSys.FolderExists(FilePath)) {
			objFileSys.CreateFolder(FilePath);
		}
	} catch(e) {
		alert("You do not have permission to create Folder "+e);
	}

}

function CheckFileExists(File) {
	var objFileSys = new ActiveXObject("Scripting.FileSystemObject");

	try {
		if (objFileSys.FileExists(File) == true) {
			var ts=objFileSys.OpenTextFile(File, 1)
			s=ts.ReadLine()
			ts.Close()
			var delim=s.charCodeAt(0);
			alert(t['CannotEditFile']+" "+mPiece(s,String.fromCharCode(delim),1));
			return true
		}
	} catch(e) {alert(e.description); return true}

	return false
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

function CloseDocs() {
	CloseWordDoc();
}

function UpdateClickHandler() {
	updated=true;

	// Log 33358 - AI - 23-04-2003 : Set whether the Description Field exists On the Layout of the component. Used in web.OEOrdItem websysSaveTranscribe.
	var WORDDOCform=document.forms["fWordDocRadiology_Link"];
	if (WORDDOCform) {
		var objDesc=document.getElementById('WDRDescription');
		var objFlag=WORDDOCform.elements["WDRDescriptionFieldOnLayout"];
		if (objDesc){
			if (objFlag) objFlag.value="Y";
		} else {
			if (objFlag) objFlag.value="N";
		}
	}
	//Log 59575
	/*
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var FilePath=FilePathAndName();
	FilePath=FilePath.split(";");
	try {
		for (i=0;i<FilePath.length;i++) {
			//alert (FilePath[i]+"\n"+mPiece(FilePath[i],"tmp",0));
			fso.CopyFile(FilePath[i],mPiece(FilePath[i],"tmp",0),true);
			fso.DeleteFile(FilePath[i], true);
		}
	} catch(e){}*/
 
	// end Log 33358
	//SaveWordDoc();
	Update_click();
	if ((window.opener)&&(window.opener.parent[1])){
			var winp=window.opener.parent[1];
			winp.treload('websys.csp');
	}
	return;
}

function LookUpUserSelect(txt) {
	var adata=txt.split("^")
	var repby=document.getElementById("Usercode")
	if (repby) {
		repby.value=adata[0];
	}
}

//log59575 TedT remove OEOrdResult entry if update not clicked
function UnloadHandler() {
	if(updated) return;
	updated=true;
	CancelClickHandler();
}

function CancelClickHandler() {
	var name=document.getElementById("SaveFileName");
	var subdir=document.getElementById("SaveFileSubDir");
	var txtname=document.getElementById("TXTSaveFileName");
	var filename="";
	var txtFilename="";
	if(name && subdir && txtname) {
		filename=subdir.value+name.value+".rtf";
		txtFilename=subdir.value+txtname.value+".txt";
	}
	if(filename!="" && txtFilename!="") 
		var save=tkMakeServerCall("web.OEOrdResult","RemoveResult",filename,txtFilename);
	
	if(updated) return;
	
	updated=true;
	Cancel_click();
}

var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=UpdateClickHandler;

document.body.onload=WordDocLoadHandler;
document.body.onunload=UnloadHandler;

//OpenWordDoc();
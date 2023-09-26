// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// KK 19-Feb-2002 Log-22796
// if NortonAntiVirus is installed the following error may occur
// Error Opeing Word application - Error:"Call was rejected by callee"
// we need to restart the machine after unregistering  "OfficeAV.dll" in the "NortonAntiVirus" folder
var customWindowState=0
//log62285 TedT make strSaveFilePath globle
var strSaveFilePath=""
var copied=false;

function WordDocLoadHandler() {
	if (document.getElementById('CompDisabled').value!=1) {
		OpenWordDoc();
		var obj=document.getElementById('OpenWordDoc');
		if (obj) obj.onclick=OpenWordDoc;
	}
	if (document.getElementById('CompDisabled').value==1) {
		var obj=document.getElementById("OpenWordDoc")
		if (obj) {obj.disabled=true; obj.onclick=""}
		var obj=document.getElementById("Update")
		if (obj) {obj.disabled=true; obj.onclick=""}
	}

	var obj=document.getElementById('Cancel');
	if (obj) obj.onclick=CancelClickHandler;

	var obj=document.getElementById('Next');
	if (obj) obj.onclick=NextClickHandler;

	//SB 03/03/03 (32836): Disable Next link if no multiple patient OE Id's
	var OEobj = document.getElementById('OEOrdItemID');
	var obj = document.getElementById('multipatOEIDs');
	if (obj && obj.value=="") {
		var obj = document.getElementById('Next');
		if (obj) {obj.disabled=true; obj.className = "disabledField";}
	}

	var obj=document.getElementById('Update');
	if (obj) obj.onclick=UpdateClickHandler;
	AbnormalRes_changehandler;
	var obj=document.getElementById('AbnormalRes')
	if (obj) obj.onclick=AbnormalRes_changehandler;
}

function AbnormalRes_changehandler() {
	var obj=document.getElementById('AbnormalRes')
	var objflag=document.getElementById('AbnormalFlag')
	if ((obj)&&(objflag)) {
		if (obj.checked==true) { objflag.value="on" }
		else if (obj.checked==false) { objflag.value="off" }
	}
}

function WordDocUnloadHandler() {
	//SB 03/03/03 (32836): If multiple patient OE Ids exist then loop around and precess next one.
 	var TWKFL=""
	var TWKFLI=""
	var TWKFLL=""
	var TWKFLJ=""
	var CONTEXT=""
	var multipatOEIDs=""

	//SaveWordDoc();

	var obj = document.getElementById('multipatOEIDs'); if (obj) multipatOEIDs=obj.value;
	var obj = document.getElementById('TWKFL'); if (obj) TWKFL=obj.value;
	var obj = document.getElementById('TWKFLI'); if (obj) TWKFLI=obj.value;
	var obj = document.getElementById('TWKFLL'); if (obj) TWKFLL=obj.value;
	var obj = document.getElementById('TWKFLJ'); if (obj) TWKFLJ=obj.value;
	var CONTEXT = session['CONTEXT']
	
	//log 57642 TedT added episodeid, patient id to the link
	if (multipatOEIDs!="") {
		var FormStr="worddoc.multiverify.csp?";
		var InitStr="CONTEXT="+CONTEXT+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&TWKFLL="+TWKFLL+"&TWKFLJ="+TWKFLJ
		var lnk=FormStr + InitStr + "&multipatOEIDs="+multipatOEIDs;
		document.location=lnk;
	}
	return true;
}

function OpenWordDoc() {
	//LOG 40023 RC 4/11/03 This 'GetObject' function will try to open an already existing instance of Word to use for
	//the template. If it can't find one, then it will just create a new instance of Word.
	//LOG 55488 JH 7/10/05 Now with new versions of word we can use the create object always without any performance issues -
	//and it fixes the problem that if the user has word open and minimised, the radiology report opens minimised too.
	DeleteErrorFile();
	var objWrdApp = new ActiveXObject("Word.Application");
	if (objWrdApp) {
		var objTemplatePath=document.getElementById('TemplatePath');
		//alert("objTemplatePath.value "+objTemplatePath.value)
		if (objTemplatePath) {
			var strTemplatePath = objTemplatePath.value+"/"
			//if there is a word document already saved for this order item then show that document otherwise show template
			var objSavedFileName=document.getElementById('SavedFileName');
			//alert("objSavedFileName.value "+objSavedFileName.value)
			if ((objSavedFileName) && (objSavedFileName.value!="")){
				strSavedFileName=objSavedFileName.value;
				var objSaveFilePath=document.getElementById('SaveFilePath');
				if (objSaveFilePath) var strSaveFilePathArray=objSaveFilePath.value;
				//alert("strSaveFilePathArray "+strSaveFilePathArray);
				strSaveFilePath = mPiece(strSaveFilePathArray,";",0);
				if(strSaveFilePath==""){strSaveFilePath=strSaveFilePathArray;}
				var tmpfile=strSaveFilePath+"\\"+mPiece(strSavedFileName,"\\",1)+"\\"+"~$"+mPiece(strSavedFileName,"\\",2)
				if (CheckFileExists(tmpfile)==true) {
					var obj=document.getElementById("OpenWordDoc")
					if (obj) {obj.disabled=true; obj.onclick="";}
					var obj=document.getElementById("Update")
					if (obj) {obj.disabled=true; obj.onclick="";}
					return false;
				}
				try {
					//log 62285 TedT make a copy of file
					if(!copied) CopyFile(strSavedFileName,strSavedFileName+"temp.rtf");
					//alert(strSaveFilePath+strSavedFileName);
					var objWrdDoc = objWrdApp.Documents.Add(strSaveFilePath+strSavedFileName);
					//alert(objWrdDoc)
					if (objWrdDoc) {
						try {
							var user=session['LOGON.USERID'];
							//Gives error msg 'Variable already exists' if UserRowId used
							objWrdDoc.Variables.Add("VUserRowId",user);
						} catch(e) {}
						var FileSavePaths=FilePathAndName()
						if (FileSavePaths!=objWrdDoc.Variables.Item("ShadowFileSavePaths").Value) {
							try {
								objWrdDoc.Variables.Item("ShadowFileSavePaths").Value=FileSavePaths;
							}catch(e){}
						}
						//objWrdApp.Run("VerifyDocument");
						//BR 20/01/06 58024 for word 2000 is necessary to set the window to visible before setting the window start.
						//Otherwise the screen opens with no menu and toolbars
						objWrdApp.visible=true;
						objWrdApp.WindowState = 2;
						objWrdApp.WindowState = customWindowState;
						objWrdApp.Run("VerifyDocument");
					}
				}
				catch(e){}
				return false;
			} else {
				//alert("else");
				var objTemplateName=document.getElementById('TemplateName');
				if (objTemplateName) {
					var strTemplateName=objTemplateName.value;
					//alert("TemplateName="+strTemplateName);
					if (strTemplateName==""){
						//alert("No matching word template found!");
						return false;
					}
				}
				//alert(strTemplatePath+strTemplateName);
				var objWrdDoc = objWrdApp.Documents.Add(strTemplatePath+strTemplateName);
				//alert(strTemplatePath);
				//var objWrdDoc = objWrdApp.Documents.Add(strTemplatePath+"webExample.dot");
			}
			if (objWrdDoc) {
				var objEpisodeID=document.getElementById('EpisodeID');
				if (objEpisodeID) {
					var strEpisodeID=objEpisodeID.value
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
					var strVoiceFile=objVoiceFile.value

					var user=session['LOGON.USERID'];

					objSaveFileSubDir=document.getElementById('SaveFileSubDir');
					if (objSaveFileSubDir) var strSaveFileSubDir1=objSaveFileSubDir.value;
					objSaveFileName=document.getElementById('SaveFileName');
					if (objSaveFileName) var strSaveFileName1=objSaveFileName.value;
					var strSubDirAndName=strSaveFileSubDir1+strSaveFileName1+".rtf";
					//
					objTXTSaveFileName=document.getElementById('TXTSaveFileName');
					if (objSaveFileName) var strTXTSaveFileName1=objTXTSaveFileName.value;
					var strTXTSubDirAndName=strSaveFileSubDir1+strTXTSaveFileName1+".txt";
					objWrdDoc.Variables.Add("EpisodeID",strEpisodeID);
					objWrdDoc.Variables.Add("OEOrdItemIDs",strOEOrdItemID);
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
					objWrdDoc.Variables.Add("UpdateCounter","False");
					objWrdDoc.Variables.Add("DSN",strDSN);

					var FileSavePaths=FilePathAndName()
					objWrdDoc.Variables.Add("ShadowFileSavePaths",FileSavePaths);
					//alert("file pths "+FileSavePaths)
					//When the word document is created for the first time the "MedTrak" macro should be run
					//When the same document is opened again for viewing then "OpenDocument" macro should be run
					try {
						//objWrdApp.Run("MedTrak");
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


function FilePathAndName() {
	/*
	SA: SaveFilePath is an delimited string of Paths separated by a semicolon (;)
	The first path is the primary which will be saved via the code here
	(in function "OpenWordDoc"). All other paths will be passed to the document
	template to be saved on the Document_Close event.
	*/
	var obj=document.getElementById('OEItemStatus');
	if (obj) var stat=obj.value;

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
			if ((strSavedFileName!="")&&(stat!="RESV")) {
				strFilePathAndName = strSaveFilePath+strSavedFileName;
				strFilePath = strSaveFilePath+"\\"+mPiece(strSavedFileName,"\\",1)+"\\";
			} else if ((strSaveFileSubDir!="") && (strSaveFileName!="")) {
				// .doc/.rtf extension hardcoded to be saved for word documents only
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
			if ((strSavedTXTFileName!="")&&(stat!="RESV")) {
				strTXTFilePathAndName = strTXTSaveFilePath+strSavedTXTFileName;
				strTXTFilePath = strTXTSaveFilePath+"\\"+mPiece(strSavedTXTFileName,"\\",1)+"\\";
			} else if ((strTXTSaveFileSubDir!="") && (strTXTSaveFileName!="")) {
				// .doc/.rtf extension hardcoded to be saved for word documents only
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
      delimArray = s1.split(sep);

	//If out of range, return a blank string
      if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
      }
}

function DeleteErrorFile() {
	var objFileSys = new ActiveXObject("Scripting.FileSystemObject");
	var obj=document.getElementById('SaveFilePath')
	if (obj) {var savepath=mPiece(document.getElementById('SaveFilePath').value,";",0)}
	var obj=document.getElementById('SavedFileName')
	if (obj) {var errorpath=mPiece(document.getElementById('SavedFileName').value,".",0)+".err"}

	try {
		if (objFileSys.FileExists(savepath+errorpath)==true) {
			var ef=objFileSys.GetFile(savepath+errorpath)
			ef.Delete();
		}
	} catch(e) {}
}

function UpdateClickHandler() {
	// Log 33358 - AI - 23-04-2003 : Set whether the Description Field exists On the Layout of the component. Used in web.OEOrdItem websysSaveVerify.
	var WORDDOCform=document.forms["fWordDocVerify_Link"];
	if (WORDDOCform) {
		var objDesc=document.getElementById('Description');
		var objFlag=WORDDOCform.elements["DescriptionFieldOnLayout"];
		if (objDesc){
			if (objFlag) objFlag.value="Y";
		} else {
			if (objFlag) objFlag.value="N";
		}
	}
	// end Log 33358

	//LOG 60867 RC 11/09/06 Display error if error file exists
	var objFileSys = new ActiveXObject("Scripting.FileSystemObject");
	var obj=document.getElementById('SaveFilePath')
	if (obj) {var savepath=mPiece(document.getElementById('SaveFilePath').value,";",0)}
	var obj=document.getElementById('SavedFileName')
	if (obj) {var errorpath=mPiece(document.getElementById('SavedFileName').value,".",0)+".err"}
	try {
		if (objFileSys.FileExists(savepath+errorpath)==true) {
			var errorfile=objFileSys.OpenTextFile(savepath+errorpath, 1)
			var ef=errorfile.ReadLine()
			if (ef=="error") ef="There has been an unspecified error."
			errorfile.Close();
			alert(t['SaveError']+"\n\n"+ef);
			return false
		}
	} catch(e) {}
	
	//log62285 TedT
	var objSavedFileName=document.getElementById('SavedFileName');
	if(objSavedFileName) DeleteFile(objSavedFileName.value+"temp.rtf");
	
	return Update_click();
}

function NextClickHandler() {
	var obj = document.getElementById('Next');
	if (obj && obj.disabled==true) return false;
	var mobj = document.getElementById('multipatOEIDs');
	var obj = document.getElementById('OEOrdItemID');

	// LOG 35572 RC 12/05/03 These loops are needed if all the items in a multiple order item set are selected for
	// verification to make sure that when 'next' is selected, it doesn't cycle through the entire collection. If the first
	// item of a collection is only selected, this isn't needed.
	for(var i=0;mPiece(obj.value,"^",i)!="";i++) {
		var val=mPiece(obj.value,"^",i);
		if (val==mPiece(mobj.value,"^",0)) {
			var test="";
			for (var j=1;mPiece(mobj.value,"^",j)!="";j++) {
				test=test+mPiece(mobj.value,"^",j)+"^"
			}
			mobj.value=test;
		}
	}
	DeleteErrorFile();
	//log62285 TedT
	var objSavedFileName=document.getElementById('SavedFileName');
	if(objSavedFileName) DeleteFile(objSavedFileName.value+"temp.rtf");
}

function CancelClickHandler() {
	// SB 03/03/03 (32836): Clear out all ID's to kill looping and drop back to Rad workbench.
	var obj = document.getElementById('multipatOEIDs');
	if (obj) obj.value=""
	DeleteErrorFile();
	//log62285 TedT revert the changes made
	var objSavedFileName=document.getElementById('SavedFileName');
	if ((objSavedFileName) && (objSavedFileName.value!="")){
		strSavedFileName=objSavedFileName.value;
		CopyFile(strSavedFileName+"temp.rtf",strSavedFileName);
		DeleteFile(strSavedFileName+"temp.rtf");
	}
	return Cancel_click();
}

function LookUpUserSelect(txt) {
	var adata=txt.split("^")
	var repby=document.getElementById("Usercode")
	if (repby) {
		repby.value=adata[0];
	}
}
function LookUpVerifyUserSelect(txt) {
	var adata=txt.split("^")
	var verby=document.getElementById("VerifiedBy")
	if (verby) {
		verby.value=adata[0];
	}
}

//log 62285 TedT copy file
function CopyFile(from, to) {
	myActiveXObject = new ActiveXObject("Scripting.FileSystemObject");
	
	try {
		file = myActiveXObject.GetFile(strSaveFilePath+from);
		file.copy(strSaveFilePath+to, true);
	} catch (e) {}

	copied=true;
}
//log 62285 TedT delete file
function DeleteFile(file) {
	myActiveXObject = new ActiveXObject("Scripting.FileSystemObject");
	
	try {
		f = myActiveXObject.GetFile(strSaveFilePath+file);
		f.Delete();
	} catch (e) {}
}

document.body.onload=WordDocLoadHandler;
document.body.onunload=WordDocUnloadHandler;
// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl=document.getElementById("tOEOrdItem_PreviousRadiologyResult");
var frm=document.getElementById("fOEOrdItem_PreviousRadiologyResult");

if ((frm)&&(tbl)) {
	for (var i=1;i<tbl.rows.length;i++) {
		var ObjRes=document.getElementById("RESFileNamez"+i);
		if (ObjRes){
			ObjRes.onclick=ResultsLinkHander;
		}
	}
}

function ResultsLinkHander(e) {

	var EpisodeID="";
	var PatientID="";
	var RESRowId="";
	var OEId="";

	var eSrc=websys_getSrcElement(e);
	var eSrcAry=eSrc.id.split("z");
	var row=eSrcAry[eSrcAry.length-1];

	var eObj=document.getElementById('EpisodeID');
	if((eObj) && (eObj.value!="")) EpisodeID=eObj.value;

	var pObj=document.getElementById('PatientID');
	if((pObj) && (pObj.value!="")) PatientID=pObj.value;

	var rObj=document.getElementById('RESRowIdz'+row);
	if((rObj) && (rObj.value!="")) RESRowId=rObj.value;

	var oObj=document.getElementById('OEId');
	if((oObj) && (oObj.value!="")) OEId=oObj.value;

  var NSRobj=document.getElementById("RESNSRDRz"+row);

	var FilePath=document.getElementById('TXTSaveFilePathz'+row).value;
	var FileName=document.getElementById('RESFileNamez'+row).innerText;
	FilePath=FilePath.replace(";","");

	//log 59568 TedT open word doc in all cases
	//if ((NSRobj) && (NSRobj.value=="")) {
	OpenWordDoc(row);
	return false;
	//}

	//This was the old way of opening the document...better keep this in here just in case...

	/*var NSRobj=document.getElementById("RESNSRDRz"+row);
	if ((NSRobj) && (NSRobj.value=="")){

		var path="websys.default.csp?WEBSYS.TCOMPONENT=WordDocRadiology.Link&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&RESRowId="+RESRowId+"&OEOrdItemID="+OEId+"&PatientBanner=1&ReadOnly=1"
                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
		websys_createWindow(path,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
		return false;
	}
	else
	if ((NSRobj) && (NSRobj.value!="")){
		var IDObj=document.getElementById("RESRowIdz"+row);
		if(IDObj && IDObj.value!="")
		{
			var ID=IDObj.value;
			var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.NSRTxtResult&ID="+ID;
                        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(path,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
		}

	}*/
	return false;
}

function OpenWordDoc(row) {
	var EpisodeID="";
	var PatientID="";
	var OEId="";
	var eObj=document.getElementById('EpisodeID');
	if((eObj) && (eObj.value!="")) EpisodeID=eObj.value;
	var pObj=document.getElementById('PatientID');
	if((pObj) && (pObj.value!="")) PatientID=pObj.value;
	var oObj=document.getElementById('OEId');
	if((oObj) && (oObj.value!="")) OEId=oObj.value;

	var objSavedFileName=document.getElementById('SavedFileNamez'+row);
	var linkFileName=document.getElementById('RESFileNamez'+row);
	if (linkFileName) var link=linkFileName.innerHTML;
	var re=/(\.rtf)/gi;
	// LOG 34251 RC 31/03/03 needed to put this search in to make sure it only changes the path if it is a .rtf file
	// link. For the Non-Standard Reports I'll have to do something else.
	if (link.search(re) != -1) {
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
		objWrdApp.visible=true;
		if (objWrdApp) {
			var objTemplatePath=frm.elements('TemplatePathz'+row);
			if (objTemplatePath) {
				var strTemplatePath = objTemplatePath.value+"/"
				//if there is a word document already saved for this order item then show that document otherwise show template
				var objSavedFileName=document.getElementById('SavedFileNamez'+row);
				var linkFileName=document.getElementById('RESFileNamez'+row);
				if (linkFileName) var link=linkFileName.innerHTML;

				if (objSavedFileName) {
						// LOG 34112 RC 28/03/03 had to slip in this 'IF' statement to make sure the saved file name is the same file
						// name as the one that the link was showing.
						if (objSavedFileName.value!=linkFileName.innerHTML) objSavedFileName.value=linkFileName.innerHTML

						var objOEStat=document.getElementById('OEItemStatusz'+row);
						if (objOEStat) strStatus=objOEStat.value;
						if ((objSavedFileName) && (objSavedFileName.value!="")){
							strSavedFileName=objSavedFileName.value;
							var objSaveFilePath=document.getElementById('SaveFilePathz'+row);
							if (objSaveFilePath) var strSaveFilePathArray=objSaveFilePath.value;
							var strSaveFilePath = mPiece(strSaveFilePathArray,";",0);
							if(strSaveFilePath==""){strSaveFilePath=strSaveFilePathArray;}

							var objWrdDoc = objWrdApp.Documents.Add(strSaveFilePath+strSavedFileName);
							if (objWrdDoc) {
								var FileSavePaths=FilePathAndName(row)
								objWrdDoc.Variables("OEItemStatus").Value=strStatus;
								//SB 03/01/03 (28871): The following line had only 1 equal sign, setting strStatus="RESV"
								if (strStatus=="RESV")
								{
									try{
										//alert("Try Delete");
										objWrdDoc.Variables.Delete("ShadowFileSavePaths");
									}catch(e){}
									try{
										objWrdDoc.Variables.Add("ShadowFileSavePaths",FileSavePaths);
									}catch(e){}
								}
								//SB 26/02/03 (33236): When the order is Transcribed first, and then Reported later
								// the voice file doesn't exist as an ActiveDocument variable.
								var objVoiceFile=document.getElementById('VoiceFilez'+row); var strVoiceFile="";
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
								objWrdApp.Run("OpenDocument");
								//alert("2222 "+strSaveFilePath+strSavedFileName);
							}catch(e){
								//alert("catch error open document "+e);
							}
							return false;
						} else {
							var objTemplateName=document.getElementById('TemplateNamez'+row);
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
							//var objEpisodeID=document.getElementById('EpisodeID');
							if (EpisodeID!="") {
								//var strEpisodeID=objEpisodeID.value;
								//alert(objEpisodeID.value)
								//var objOEOrdItemID=document.getElementById('OEOrdItemID');
								//var strOEOrdItemID=objOEOrdItemID.value
								//var objPatientID=document.getElementById('PatientID');
								//var strPatientID=objPatientID.value
								var objCacheDateNow=document.getElementById('CacheDateNowz'+row);
								var strCacheDateNow=objCacheDateNow.value
								var objCacheTimeNow=document.getElementById('CacheTimeNowz'+row);
								var strCacheTimeNow=objCacheTimeNow.value
								//var objDischLetterRowId=document.getElementById('DischLetterRowId');
								//var strDischLetterRowId=objDischLetterRowId.value
								var objVerifiedRowId=document.getElementById('VerifiedRowIdz'+row);
								var strVerifiedRowId=objVerifiedRowId.value
								var objEnteredRowId=document.getElementById('EnteredRowIdz'+row);
								var strEnteredRowId=objEnteredRowId.value
								var objOrderHeaderRowId=document.getElementById('OrderHeaderRowIdz'+row);
								var strOrderHeaderRowId=objOrderHeaderRowId.value
								var objOrderSequenceRowId=document.getElementById('OrderSequenceRowIdz'+row);
								var strOrderSequenceRowId=objOrderSequenceRowId.value
								var objVoiceFile=document.getElementById('VoiceFilez'+row);
								var strVoiceFile="";
								if (objVoiceFile) strVoiceFile=objVoiceFile.value

								var user=session['LOGON.USERID'];

								objSaveFileSubDir=document.getElementById('SaveFileSubDirz'+row);
								if (objSaveFileSubDir) var strSaveFileSubDir1=objSaveFileSubDir.value;
								objSaveFileName=document.getElementById('SaveFileNamez'+row);
								if (objSaveFileName) var strSaveFileName1=objSaveFileName.value;
								var strSubDirAndName=strSaveFileSubDir1+strSaveFileName1+".rtf";
								//var strSubDirAndName=strSaveFileSubDir1+strSaveFileName1+".doc";
								//
								objTXTSaveFileName=document.getElementById('TXTSaveFileNamez'+row);
								if (objSaveFileName) var strTXTSaveFileName1=objTXTSaveFileName.value;
								var strTXTSubDirAndName=strSaveFileSubDir1+strTXTSaveFileName1+".txt";
								//alert(objWrdDoc+"  "+strEpisodeID)
								objWrdDoc.Variables.Add("EpisodeID",EpisodeID);
								objWrdDoc.Variables.Add("OEOrdItemIDs",OEId);
								objWrdDoc.Variables.Add("OEItemStatus",strStatus);
								objWrdDoc.Variables.Add("PatientID",PatientID);
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
								if (FileSavePaths==""){
									var FileSavePaths=FilePathAndName(row)
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
								}
							}
						}
					}
				}
			}
		} else {
			var IDObj=document.getElementById("RESRowIdz"+row);
			if(IDObj && IDObj.value!="") {
				var ID=IDObj.value;
				var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.NSRTxtResult&ID="+ID;
                                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
				websys_createWindow(path,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
			}
		}
}


function FilePathAndName(row) {

	//SA: SaveFilePath is an delimited string of Paths separated by a semicolon (;)
	//The first path is the primary which will be saved via the code here
	//(in function "OpenWordDoc"). All other paths will be passed to the document
	//template to be saved on the Document_Close event.

	obj=document.getElementById('SaveFilePathz'+row);
	if (obj) var strSaveFilePathArray=obj.value

	obj=document.getElementById('SaveFileSubDirz'+row);
	if (obj) var strSaveFileSubDir=obj.value

	obj=document.getElementById('SaveFileNamez'+row);
	if (obj) var strSaveFileName=obj.value

	//alert("SaveFilePathArray:" + strSaveFilePathArray);
	//alert("SaveFileSubDir:" + strSaveFileSubDir);
	//alert("SaveFileName:" + strSaveFileName);

	//not actually an array, but delimited string of paths separated by ";"
	//just easier to name this way to distinguish from single path.
	var FileSavePathsArray=""
	var i=0
	while (mPiece(strSaveFilePathArray,";",i)!="") {
		var strSaveFilePath = mPiece(strSaveFilePathArray,";",i)

		if ((strSaveFilePath!="") && (strSaveFileSubDir!="") && (strSaveFileName!="")) {
			// .doc/.rtf extension hardcoded to be saved for word documents only
			strFilePathAndName = strSaveFilePath+strSaveFileSubDir+strSaveFileName+".rtf";
			//strFilePathAndName = strSaveFilePath+strSaveFileSubDir+strSaveFileName+".doc";
			strFilePath = strSaveFilePath+strSaveFileSubDir;
		}
		CreateFilePath(strFilePath)
		FileSavePathsArray=FileSavePathsArray+strFilePathAndName+";"
		i=i+1
	}
	//Save as Text as well.
	obj=document.getElementById('TXTSaveFilePathz'+row);
	if (obj) var strTXTSaveFilePathArray=obj.value;

	obj=document.getElementById('SaveFileSubDirz'+row);
	if (obj) var strTXTSaveFileSubDir=obj.value

	obj=document.getElementById('TXTSaveFileNamez'+row);
	if (obj) var strTXTSaveFileName=obj.value
	//alert("strTXTSaveFilePathArray: " + strTXTSaveFilePathArray);
	//alert("strTXTSaveFileSubDir: " + strTXTSaveFileSubDir);
	//alert("strTXTSaveFileName: " + strTXTSaveFileName);
	i=0;
	while (mPiece(strTXTSaveFilePathArray,";",i)!="") {
		var strTXTSaveFilePath = mPiece(strTXTSaveFilePathArray,";",i)

		if ((strTXTSaveFilePath!="") && (strTXTSaveFileSubDir!="") && (strTXTSaveFileName!="")) {
			// .doc/.rtf extension hardcoded to be saved for word documents only
			strTXTFilePathAndName = strTXTSaveFilePath+strTXTSaveFileSubDir+strTXTSaveFileName+".txt";
			strTXTFilePath = strTXTSaveFilePath+strTXTSaveFileSubDir;
		}
		CreateFilePath(strTXTFilePath)
		FileSavePathsArray=FileSavePathsArray+strTXTFilePathAndName+";"
		i=i+1
	}
	//setting the hidden field in the form that will save the file name
	//(eg. "\20010327\1201.rtf") to OEORDResult.RESFileName
	var objFileName=document.getElementById('FilePathAndNamez'+row);
	if (objFileName) {
		objFileName.value=strSaveFileSubDir+strSaveFileName+".rtf"
		//objFileName.value=strSaveFileSubDir+strSaveFileName+".doc"
		//alert("FileName:" + objFileName.value);
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

	//alert("FilePath:" + FilePath);
		if (!objFileSys.FolderExists(FilePath)) {
			objFileSys.CreateFolder(FilePath);
		}
	} catch(e) {
		alert("You do not have permission to create Folder "+e);
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
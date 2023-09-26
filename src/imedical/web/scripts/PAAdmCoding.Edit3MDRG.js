// Copyright (c) 2000 TRAK Systems Pty. ALL RIGHTS RESERVED. 

// DECLARATION OF FORM LEVEL VARIABLES

// RQG - 08.11.02 Log28510: This js was overhauled to handle VICDRG4 code. All input/output files
// are now handled in Cache. For Inquiry - Output line string is passed here to populate the 
// PAAdm.DRGCoding screen.

var objEpisodeID=document.getElementById("EpisodeID");
var objDRGPath=document.getElementById("DRGPath");
var objInputLines=document.getElementById("InputLines");
var objILError=document.getElementById("InputLinesErrorCode");
var objOutputLines=document.getElementById("OutputLines");
var objUpdate=document.getElementById("update1");
var objCacheInitError=document.getElementById("CacheInitError");
var objBatchEpisodesCount=document.getElementById("BatchEpisodesCount");
var objBatchFailCount=document.getElementById("BatchFailCount");
var objMode=document.getElementById("Mode");

// Form level variable to distinguish between BATCH grouping
// and single episode grouping.
var bBatch=false;
var bBatchComplete=false;
var bInquiry=false;
function DocumentLoadHandler(e) {
	if (objMode) {
		if (objMode.value=="BATCH") bBatch=true;
		if (objMode.value=="INQUIRY") bInquiry=true;		
	}
	if (!bBatch) { PopulateParentFrameFields(); }
		if (!bInquiry) {
			update1_click();
			// RQG 08.11.02 - Need to reload the page to display the mapped ICD and Procedure codes
			var objParFrmTrakMain=parent.frames["TRAK_main"];	
			if (objParFrmTrakMain) {
				objParFrmTrakMain.treload('websys.csp');
			}
		} else {
			GetTariffs();
		}
		if (bBatch) { bBatchComplete=true; }
}

function PopulateParentFrameFields() {
	if ((objOutputLines)&&(objOutputLines.value!="")) {
		var frmTrakmain = window.parent.frames["TRAK_main"];
		if (frmTrakmain) {
			var frmDRGCodingDisplay = frmTrakmain.frames["PAAdmDRGCodingDisplay"];
			var frmDrgcoding = frmTrakmain.frames["PAAdmDRGCoding"];
			var frmMRDiagnosEditDRG = frmTrakmain.frames["MRDiagnosEditDRG"];
			var frmMRProceduresEditDRG = frmTrakmain.frames["MRProceduresEditDRG"];
			if (!frmDrgcoding) return true;
		}
		if (frmDrgcoding) {
			if (frmDRGCodingDisplay){
				var objParDRGCodeDisplay=frmDRGCodingDisplay.document.getElementById("TDRGCode");
				var objParDRGDescDisplay=frmDRGCodingDisplay.document.getElementById("TDRGDesc");
			}	
			var objParDRGOutput=frmDrgcoding.document.getElementById("3MDRGoutput");
			if (objParDRGOutput) objParDRGOutput.value=objOutputLines.value;

			var objParDRGCode=frmDrgcoding.document.getElementById("DRGCode");
			var objParDRGDesc=frmDrgcoding.document.getElementById("DRGDesc");
			var OutputStr=objOutputLines.value;

			if (objParDRGCode) {
				var DRGCodeStr=OutputStr.substr(10, 4);				
				objParDRGCode.innerText=DRGCodeStr;
				if (objParDRGCodeDisplay) objParDRGCodeDisplay.innerText=DRGCodeStr;
				// SA / RG 26.7.02 - log 25417: Message to display for DRG codes
				// 960Z,961Z and 962Z
				if ((DRGCodeStr=="960Z")||(DRGCodeStr=="961Z")||(DRGCodeStr=="962Z")) {
					alert(t['DRG_ZERO_WEIGHT']);
				}
			}
			if (objParDRGDesc) {
				var DRGDescStr=OutputStr.substr(14, 72);				
				objParDRGDesc.innerText=DRGDescStr;
				if (objParDRGDescDisplay) objParDRGDescDisplay.innerText=DRGDescStr;
			}
			
			// Populate Mapped ICD codes on MRDiagnos.EditDRG screen
			var tbl=frmMRDiagnosEditDRG.document.getElementById("tMRDiagnos_EditDRG");
			var pos=607;
			var firstpos=0; var start=""; var diagcode="";
			if (tbl) {
				var row=(tbl.rows.length);
				for (var i=1; i<row; i++) {
					var objCode=frmMRDiagnosEditDRG.document.getElementById("MappedICDz"+i);
					var objOrigCode=frmMRDiagnosEditDRG.document.getElementById("MRDIAICDCodeDRCodez"+i);
					// Extract the mapped icd code from output string
					start=pos + ( firstpos * 5);
					var diagcode=OutputStr.substr(start,5)
					var diagorigcode=objOrigCode.value;
					//KK L:50208 - Ignore M codes
					if (diagorigcode.substr(0,1)=="M"){
						if (objCode) objCode.value="";
					}else{
						if (objCode) objCode.value=diagcode;
						firstpos++;
					}
				}
			}
			// Populate Procedure codes in MRProcedure.EditDRG screen
			var tbl=frmMRProceduresEditDRG.document.getElementById("tMRProcedures_EditDRG");
			//pos=484; 
			pos=807;
			firstpos=0; start=""; var proccode="";
			if (tbl) {
				var row=(tbl.rows.length);
				for (var i=1; i<row; i++) {
					var objCode=frmMRProceduresEditDRG.document.getElementById("PROCOperMappedDRCodez"+i);
					// Extract the mapped procedure code from output string
					start=pos + ( firstpos * 7);
					proccode=OutputStr.substr(start,7)
					if (objCode) objCode.value=proccode;
					firstpos++;
				}
			}
		}
	}
}

function GetTariffs() {

	// SA 10.07.02 - log 24621: Code here will call a new component via the hidden frame
	// which will retrieve the relevant tariff details for the DRG code returned.
	// When retrieved into the hidden component, they will then be copied to PAAdm.DRGCoding
	// component in the visible frame (trak_main).

	if ((objOutputLines)&&(objOutputLines.value!="")) {
		
		var OutputStr=objOutputLines.value
		//alert("OutputStr="+OutputStr);
		var DRGCode=OutputStr.substr(10, 4);				
		//alert("DRGCode="+DRGCode);

		var objParent=parent.frames[1];
		var DischDate="";
		var objParDischDate=objParent.document.getElementById("INQDischargeDate");
		if (objParDischDate) DischDate=objParDischDate.value;

		//KK L:41627 - passing discharge date also in the url to filter drg on version	
		if (DRGCode!="") {
			var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.DRGCodingGetTariff&DRGCode="+DRGCode+"^"+DischDate;
			//alert("url="+url);
			websys_createWindow(url,"TRAK_hidden");
		}
	}
}

function DocumentUnloadHandler() {

	if (bBatchComplete) { 
		
		var BatchMessage="";
		
		BatchMessage=t['BATCH_COMPLETE']+"\n";
		
		if ((objBatchEpisodesCount)&&(objBatchEpisodesCount.value!="")) {
			BatchMessage+=t['EPISODES_BATCHED']+" "+objBatchEpisodesCount.value+"\n";
		}

		if ((objBatchFailCount)&&(objBatchFailCount.value!="")) {
			BatchMessage+=t['EPISODES_FAILED']+" "+objBatchFailCount.value+"\n";	
		}

		alert(BatchMessage);

	}
}

document.body.onload=DocumentLoadHandler;
document.body.onunload=DocumentUnloadHandler;

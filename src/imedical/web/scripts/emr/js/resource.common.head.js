var invoker = parent;
var isModelDlg = false;

var patientID;
var episodeID;
var userID;
var ssgroupID;
var userLocID;
var admType;

try{
	// todo
	if (parent.emrEditor) {
		invoker = parent;
		patientID = invoker.patInfo.PatientID;
		episodeID = invoker.patInfo.EpisodeID;
		userID = invoker.patInfo.UserID;
		ssgroupID = invoker.patInfo.SsgroupID;
		userLocID = invoker.patInfo.UserLocID;	
        admType = invoker.patInfo.admType;
	} else if (parent.invoker) {
		isModelDlg = true;
		invoker = parent.invoker;
		patientID = invoker.patInfo.PatientID;
		episodeID = invoker.patInfo.EpisodeID;
		userID = invoker.patInfo.UserID;
		ssgroupID = invoker.patInfo.SsgroupID;
		userLocID = invoker.patInfo.UserLocID;	
        admType = invoker.patInfo.admType;
	}else {
		invoker = parent;
		patientID = invoker.patientID;
		episodeID = invoker.episodeID;
		userID = invoker.userID;
		ssgroupID = invoker.ssgroupID;
		userLocID = invoker.userLocID;	
        admType = invoker.admType;
	}
}
catch (e) {
	alert(e.message || e);
}	

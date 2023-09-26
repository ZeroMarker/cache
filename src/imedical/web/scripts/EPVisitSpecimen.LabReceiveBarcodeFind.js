// Log 57558 YC - Created js for this log

function ReceiveClickHandler() {
	var AutoRecObj = document.getElementById('AutoReceive');
	if(AutoRecObj) {
		if (AutoRecObj.checked == true) {
			var EncmethObj = document.getElementById('Encmeth');
			if (EncmethObj) {
				if (EncmethObj.value!="") {
					var AutoReceive = "";
					var AutoCollect = "";
					var LabEpisodeID = "";
					
					var LabEpObj = document.getElementById('LabEpisodeID');
					if (LabEpObj) {
						LabEpisodeID = LabEpObj.value;
						LabEpObj.readOnly = true;
						LabEpObj.style.backgroundColor="#CCCCCC";
					}
					
					var AutoRecObj = document.getElementById('AutoReceive');
					if (AutoRecObj) {
						if (AutoRecObj.checked)	AutoReceive = AutoRecObj.value; 
					}
						
					var AutoCollObj = document.getElementById('AutoCollect');
					if (AutoCollObj) {
						if (AutoCollObj.checked) AutoCollect = AutoCollObj.value;
					}
					
					cspRunServerMethod(EncmethObj.value,LabEpisodeID,AutoReceive,AutoCollect);
					return false;
				}
			}
		}
	}
	return Receive_click();
}

function SpecReceivedHandler(message) {
	var LabEpObj = document.getElementById('LabEpisodeID');
	var MsgObj = document.getElementById('ProcessedMessage');
	if (LabEpObj) {
		if(MsgObj) MsgObj.value=message;
		LabEpObj.value = "";
		LabEpObj.readOnly = false;
		LabEpObj.style.backgroundColor="";
	}
}

function BodyLoadHandler() {
	var RecObj=document.getElementById("Receive");
	var AutoRecObj=document.getElementById("AutoReceive");
	if(RecObj&&AutoRecObj) {
		RecObj.onclick=ReceiveClickHandler;
	}
	var MsgObj = document.getElementById('ProcessedMessage');
	if(MsgObj) {
		MsgObj.readOnly = true;
		MsgObj.style.backgroundColor="#CCCCCC";
	}
}

document.body.onload=BodyLoadHandler;
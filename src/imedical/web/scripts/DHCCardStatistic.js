document.body.onload = DocumentLoadHandler;

function DocumentLoadHandler()
{
	var Obj=document.getElementById('ChangeCardFlag');
	if (Obj) Obj.onclick = ChangeCardFlagclick;
	var Obj=document.getElementById('CreatCardFlag');
	if (Obj) Obj.onclick = CreatCardFlagclick;
	
	
	var Obj=document.getElementById('Own');
	if (Obj) Obj.onclick = Own_Click;
	var obj=document.getElementById("CardOperUser");
	if (obj){obj.onpropertychange=CardOperUserchange};
}
function CardOperUserchange()
{
	var obj=document.getElementById("CardOperUser");
	if (obj.value==""){
	var objUserDr=document.getElementById("CardOperUserDr");
	if (objUserDr){objUserDr.value=""}
	var Obj=document.getElementById('Own');
	if(Obj){Obj.checked=false}
	}
}
function Own_Click()
{
	var Obj=document.getElementById('Own');
	if(Obj.checked){
		var obj=document.getElementById("CardOperUser");
		if (obj){obj.value=session['LOGON.USERNAME']}
		var objUserDr=document.getElementById("CardOperUserDr");
		if (objUserDr){objUserDr.value=session['LOGON.USERID']}
	}else{
		var obj=document.getElementById("CardOperUser");
		if (obj){obj.value=""}
		var objUserDr=document.getElementById("CardOperUserDr");
		if (objUserDr){objUserDr.value=""}
	}
			
}

function ChangeCardFlagclick() {
	var ChangeCardFlagObj=document.getElementById('ChangeCardFlag');
	var CreatCardFlagObj=document.getElementById('CreatCardFlag');
	
    if (ChangeCardFlagObj.checked){
    	if (CreatCardFlagObj) CreatCardFlagObj.checked=false;
		
    }
}
function CreatCardFlagclick() {
	var ChangeCardFlagObj=document.getElementById('ChangeCardFlag');
	var CreatCardFlagObj=document.getElementById('CreatCardFlag');
	
    if (CreatCardFlagObj.checked){
    	if (ChangeCardFlagObj) ChangeCardFlagObj.checked=false;
		
    }
}
function setTypeID(value)
{	
	var str=value.split("^");
	var typeID=str[1];
	var obj=document.getElementById("CardOperUserDr");
	if (obj) obj.value=typeID;
	else obj.value="";
}





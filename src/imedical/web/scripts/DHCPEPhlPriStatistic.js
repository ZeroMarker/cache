/// ����	DHCPEPhlPriStatistic.js
/// ��Ѫ�뱨���ӡ������ͳ��
 



function BodyLoadHandler() 
{
	var obj;
	obj=document.getElementById("User");
	if (obj) {
		obj.onchange=User_change;
	}
	
}



function User_change() {
		var obj;
		obj=document.getElementById('UserId');
		if (obj) { obj.value=""; }
}



function GetUser(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("User");
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById("UserId");
	if (obj) { obj.value=aiList[2]; }
}


document.body.onload = BodyLoadHandler;
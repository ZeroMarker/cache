////UDHCAccCallBack.js

////1.Get Foot Account Info 	.Check Account Static
////2.Get CardNo 				.check CardNo
////3.

function BodyLoadHandler(){
	
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
	DHCWebD_ClearAllListA("RLCredTypeList");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","RLCredTypeList");
	}
}

function ReadMagCard_Click(){
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		///window.status=t[2007]
		var rtn=obj.ReadMagCard("23");
		var myary=rtn.split("^");
		if (myary[0]=='-5') {window.status=t[2008];return;}
		window.status=""
		if (myary[0]=="0"){
			//Add Check Card No DHCACC_GetPAPMINo
			var myVersion=DHCWebD_GetObjValue("DHCVersion");
			if (myVersion=="0"){
				var myCardStat=DHCACC_GetAccInfoFNoCard(myary[1],myary[2]);
				var myStatAry=myCardStat.split("^");
				if (myStatAry[0]=="0"){
					alert(t["EntCardtip"]);
					DHCWeb_DisBtnA("BtnCallBack");
					return;
				}else{
					if (Exchangeobj){
						Exchangeobj.disabled=false;
						Exchangeobj.onclick = Exchange_Click;
					}
				}
			}
			
			if (ExchangeCardobj.checked==true){
			    ExchangeCardNoobj.value=myary[1];
			    ExchCardVerify=myary[2];	
			}
			else{
				//CardNo=myary[1];
				CardNoobj.value=myary[1];
				CardVerify=myary[2];
				
				getpatbycard();}
		}
	}	
}



document.body.onload = BodyLoadHandler;

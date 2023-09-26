//Add JS To Component(UDHCJFIPReg)
//DHC.WMR.Pinyin.JS
//DHC.WMR.BuildCase.Interface.JS

//Add Item To Component(UDHCJFIPReg)
//btnReceipt    Button
//btnUnReceipt     Button

//Add Hidden Item To Component(UDHCJFIPReg)
//MrType  s val=%request.Get("MrType")   //Menu Add &MrType=7
//MethodGetMrNoByPaadm  s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRReceipt.GetMrNoByPaadm"))
//MethodReceiptByReg  s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRReceipt.ReceiptByReg"))
//MethodUnReceiptByReg  s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRReceipt.UnReceiptByReg"))

//Add Message To Component(UDHCJFIPReg)
//ReceiptErr  "Receipt Error!ErrCode="
//UnReceiptErr  "UnReceipt Error!ErrCode="
//ReceiptSucc  "Receipt Success!"
//UnReceiptSucc  "UnReceipt Success!"

// Add Code To JS(UDHCJFIPReg.js)
// if (document.getElementById("btnReceipt")) {InitReceipt();}       //BodyLoadHandler()
// if (document.getElementById("btnReceipt")) {btnReceipt_onclick();}       //admcancel_click()
// if (document.getElementById("btnUnReceipt")) {btnUnReceipt_onclick();}      //regsave_click()

function InitReceipt()
{
	if (!document.getElementById("MrType")) return;
	if (document.getElementById("MrType").value=="") return;
	if (!document.getElementById("btnReceipt")) return;
	if (!document.getElementById("btnUnReceipt")) return;
	if (!document.getElementById("MethodGetMrNoByPaadm")) return;
	if (!document.getElementById("MethodReceiptByReg")) return;
	if (!document.getElementById("MethodUnReceiptByReg")) return;
	
	var obj=document.getElementById("btnReceipt");
	if (obj){obj.onclick=btnReceipt_onclick;}
	var obj=document.getElementById("btnUnReceipt");
	if (obj){obj.onclick=btnUnReceipt_onclick;}
}

function btnReceipt_onclick()
{
	var MrType=document.getElementById("MrType").value;
	//***********
	MrType=7;
	//***********
	if ((!admidobj.value)||(admidobj.value=="")) return;
	if ((!Guser)||(Guser=="")) return;
	if ((!MrType)||(MrType=="")) return;
	//var flg=ReceiptByReg(MrType,admidobj.value,Guser);
	var flg=ReceiptByReg(MrType,admidobj.value,session['LOGON.USERID']);
	if (flg<0){
		if (!t["ReceiptErr"]){
			alert("Receipt Error!ErrCode="+flg);
		}else{
			alert(t["ReceiptErr"]+flg);
		}
	}else{
		/*
		if (!t["ReceiptSucc"]){
			alert("Receipt Success!");
		}else{
			alert(t["ReceiptSucc"]);
		}
		*/
	}
}

function btnUnReceipt_onclick()
{
	if ((!admidobj.value)||(admidobj.value=="")) return;
	if ((!Guser)||(Guser=="")) return;
	var flg=UnReceiptByReg(admidobj.value,Guser);
	if (flg<0){
		if (!t["UnReceiptErr"]){
			alert("UnReceipt Error!ErrCode="+flg);
		}else{
			alert(t["UnReceiptErr"]+flg);
		}
	}else{
		/*
		if (!t["UnReceiptSucc"]){
			alert("UnReceipt Success!");
		}else{
			alert(t["UnReceiptSucc"]);
		}
		*/
	}
}

function ReceiptByReg(MrType, Paadm, UserId)
{
	var ret=-100.1;
	if ((!MrType)||(!Paadm)||(!UserId)) return ret;
	if ((MrType=="")||(Paadm=="")||(UserId=="")) return ret;
	
	ret=-100.2;
	var strMethod = document.getElementById("MethodGetMrNoByPaadm").value;
	var flg = cspRunServerMethod(strMethod, MrType,Paadm);
	if ((!flg)||(flg=="")) return ret;
	
	ret=-100.3;
	var tmpList=flg.split("^");
	Paadm=tmpList[0];
	var MrNo=tmpList[1];
	var PatName=tmpList[2];
	if ((!MrType)||(!Paadm)||(!MrNo)||(!PatName)||(!UserId)) return ret;
	if ((MrType=="")||(Paadm=="")||(MrNo=="")||(PatName=="")||(UserId=="")) return ret;
	var NameSpell=GetPinYin(PatName);
	if ((!NameSpell)||(NameSpell=="")) NameSpell=PatName;
	
	ret=-100.4;
	var strMethod = document.getElementById("MethodReceiptByReg").value;
	var flg = cspRunServerMethod(strMethod, MrType,Paadm,NameSpell,MrNo,UserId);
	if ((!flg)||(flg<0)) return ret;
	
	return flg;
}

function UnReceiptByReg(Paadm, UserId)
{
	var ret=-100.1;
	if ((!Paadm)||(!UserId)) return ret;
	if ((Paadm=="")||(UserId=="")) return ret;
	
	ret=-100.2;
	var strMethod = document.getElementById("MethodUnReceiptByReg").value;
	var flg = cspRunServerMethod(strMethod, Paadm,UserId);
	if ((!flg)||(flg<0)) return ret;
	
	ret=100.0;
	return ret;
}
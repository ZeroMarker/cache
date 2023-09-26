/////UDHCACParaSet.js

function BodyLoadHandler(){
	if(!window.opener){
	  var obj = document.getElementById("Exit");
	  if(obj){
		DHCWeb_DisBtn(obj);
	  } 
	 }
	var encmeth=DHCWebD_GetObjValue("ReadParaEncrypt");
	if (encmeth!=""){
		var rtnvalue=(cspRunServerMethod(encmeth));
		////alert(rtnvalue);
		///CreatePWD_"^"_UsePWD_"^"_CardNoEffect_"^"_AccLeftPrint_"^"_
		///PWDCount_"^"_EffectPaper_"^"_EffectBill_"^"_SQueryPWD
		var myary=rtnvalue.split("^");
		DHCWebD_SetObjValueA("CreatePWD",parseInt(myary[0]));
		DHCWebD_SetObjValueA("UsePWD",parseInt(myary[1]));
		DHCWebD_SetObjValueA("CardNoEffect",parseInt(myary[2]));
		DHCWebD_SetObjValueA("AccLeftPrint",parseInt(myary[3]));
		DHCWebD_SetObjValueA("PWDCount",parseInt(myary[4]));
		DHCWebD_SetObjValueA("EffectPaper",parseInt(myary[5]));
		DHCWebD_SetObjValueA("EffectBill",parseInt(myary[6]));
		DHCWebD_SetObjValueB("SQueryPWD",parseInt(myary[7]));
		
		DHCWebD_SetObjValueB("SDateDiff",parseInt(myary[8]));
		DHCWebD_SetObjValueA("PWDDateDiff",parseInt(myary[9]));
		DHCWebD_SetObjValueA("CardReqSuspend",parseInt(myary[10]));
		DHCWebD_SetObjValueA("PWDEditReq",parseInt(myary[11]));
		DHCWebD_SetObjValueA("PDAutoNo",parseInt(myary[12]));
		DHCWebD_SetObjValueB("AccReCard",parseInt(myary[13]));
		DHCWebD_SetObjValueB("DepPrice",parseFloat(myary[14]));
	}
	var obj=document.getElementById("Save");
	if (obj){
		obj.onclick=Save_Click;
	}
	
	///var mystr=BuildStr();
	///alert(mystr);
}

function Save_Click(){
	var mystr=BuildStr();
	var encmeth=DHCWebD_GetObjValue("SaveParaEncrypt");
	if (encmeth!=""){
		var rtnvalue=(cspRunServerMethod(encmeth,mystr));
		if(rtnvalue==0){
			alert("±£´æ³É¹¦£¡");
		}
		
	}
}

function BuildStr(){
	
	var myary=new Array();
	
	myary[0]=DHCWebD_GetObjValue("CreatePWD");
	myary[1]=DHCWebD_GetObjValue("UsePWD");
	myary[2]=DHCWebD_GetObjValue("CardNoEffect");
	myary[3]=DHCWebD_GetObjValue("AccLeftPrint");
	myary[4]=DHCWebD_GetObjValue("PWDCount");
	myary[5]=DHCWebD_GetObjValue("EffectPaper");
	myary[6]=DHCWebD_GetObjValue("EffectBill");
	myary[7]=DHCWebD_GetObjValue("SQueryPWD");
	myary[8]=DHCWebD_GetObjValue("SDateDiff");
	myary[9]=DHCWebD_GetObjValue("PWDDateDiff");
	myary[10]=DHCWebD_GetObjValue("CardReqSuspend");
	myary[11]=DHCWebD_GetObjValue("PWDEditReq");
	myary[12]=DHCWebD_GetObjValue("PDAutoNo");
	myary[13]=DHCWebD_GetObjValue("AccReCard");
	for (var i=0;i<myary.length;i++){
		if ((myary[i]==true)&&(i!=4)){
			myary[i]=1;
		}else if ((myary[i]==false)&&(i!=4)&&(i!=8)&&(i!=9)){
			myary[i]=0;
		} 
	}
	myary[14]=DHCWebD_GetObjValue("DepPrice");
	var myInfo=myary.join("!");
	return myInfo;
	
}

function BodyUnLoadHandler(){
	
}

document.body.onload = BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;

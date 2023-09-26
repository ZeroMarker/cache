
$(document).ready(function(){	
	InitParams();
	PageSetup_Null() //IE 隐藏打印时文件路径和日期
	PrintCons();
})

function InitParams(){
	pageMargin={};
	pageMargin.left=0/25.4;  //第一个除数为设置的边距(mm)
	pageMargin.right=0/25.4;
	pageMargin.top=0/25.4;
	pageMargin.bottom=0/25.4;
	pageMargin.shrink="no";
}

function PrintCons(){
	try{
		runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintCon",{"CstID":CstID},function(jsonString){		
			var jsonObjArr = jsonString;
			PrintCst(jsonObjArr);
			UlcerPrint();
		},'json',true)	
	}catch(e){alert(e.message)}

	$('input,textarea').not("#print").attr("readonly","readonly");
}

//打印
function UlcerPrint(){
	if(!!window.ActiveXObject||"ActiveXObject"in window){ //判断是否是IE浏览器
		document.getElementById('WebBrowser').ExecWB(6,2);
		InsCsMasPrintFlag(CstID,"Y");  /// 修改会诊打印标志
		window.close();	 
	}else{
		if(document.execCommand("print")){
			//window.close();	
		}	
	}	
 }
 
 /// 修改会诊打印标志
function InsCsMasPrintFlag(mdtID,printFlag){
	runClassMethod("web.DHCMDTConsult","InsCsMasPrintFlag",{"CstID":mdtID,"PrintFlag":printFlag},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("提示:","更新会诊打印状态失败，失败原因:"+jsonString);
		}
	},'',false)
}

 
function PageSetup_Null() {
	var HKEY_Root,HKEY_Path,HKEY_Key;
	HKEY_Root="HKEY_CURRENT_USER"
	HKEY_Path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
    try {
        var Wsh = new ActiveXObject("WScript.Shell");
        HKEY_Key = "header";
        //设置页眉（为空）   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, "");
        HKEY_Key = "footer";
        //设置页脚（为空）   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, "");
        HKEY_Key = "margin_bottom";
        //设置下页边距（0）   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.bottom);
        HKEY_Key = "margin_left";
        //设置左页边距（0）   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.left);
        HKEY_Key = "margin_right";
        //设置右页边距（0）   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.right);
        HKEY_Key = "margin_top";
        //设置上页边距（8）   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.top);
		
		HKEY_Key = "Shrink_To_Fit";  
		//设置上页边距（8）   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.shrink);
		
    } catch(e) {
        alert("不允许ActiveX控件");
    }
}

function PrintCst(jsonObj){
	$("#patName").html(jsonObj.PatName);
	$("#patAge").html(jsonObj.PatSex);
	$("#patInLoc").html(jsonObj.PatLoc);
	$("#inHospNo").html(jsonObj.MedicareNo);
	$("#patSeatNo").html(jsonObj.PatBed);
	$("#MedcalTangle").html(jsonObj.MedcalTangle);
	$("#CstNPlace").html(jsonObj.CstNPlace);
	$("#CstRDateTime").html(jsonObj.CstRDate+"    "+jsonObj.CstRTime);
	$("#CsLocDescS").html(jsonObj.CsLocDescS);
	$("#CstTrePro").html(jsonObj.CstTrePro.replace(/\r/g,"<br/>"));
	$("#PatDiag").html(jsonObj.PatDiag);
	$("#CurQuestion").html(jsonObj.CurQuestion.replace(/\r/g,"<br/>"));  
	$("#CstPurpose").html(jsonObj.CstPurpose.replace(/\r/g,"<br/>"));  
	
	$("#CstRUser").html(jsonObj.CstRUser);  
	$("#CstPhone").html(jsonObj.CstPhone); 
	$("#CstRUser").html(jsonObj.CstRUser); 
	$("#DisGroup").html(jsonObj.DisGroup); 
	$("#CstCare").html(jsonObj.PrvLoc+""+jsonObj.PrvDesc);
	$("#CstNDateTime").html(jsonObj.PreTime);
	$("#CstRLoc").html(jsonObj.CstRLoc);
}

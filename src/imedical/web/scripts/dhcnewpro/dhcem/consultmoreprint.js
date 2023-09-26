
$(document).ready(function(){	
  HiddenPathDate() //IE 隐藏打印时文件路径和日期
try{
    
    runClassMethod("web.DHCEMConsultQuery","GetPisPrintCon",{"CstID":CstID},function(jsonString){	
		var jsonObjArr = jsonString;
		PrintCst(jsonObjArr[0]);
		UlcerPrint();
	},'json',true)	
}catch(e){alert(e.message)}
	
  $('input,textarea').not("#print").attr("readonly","readonly");

})

//打印
function UlcerPrint(){
	
	if(!!window.ActiveXObject||"ActiveXObject"in window){ //判断是否是IE浏览器
		document.getElementById('WebBrowser').ExecWB(6,2)	
	}else{
		 window.print();	
	}
	
 }
//IE 隐藏打印时文件路径和日期
function HiddenPathDate(){     		   
	var hkey_root,hkey_path,hkey_key;
	hkey_root="HKEY_CURRENT_USER"
	hkey_path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
	try{
 	 	var RegWsh = new ActiveXObject("WScript.Shell");
 		hkey_key="header";
		RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"");
		hkey_key="footer";
		RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"&b第&p页/共&P页"); //&w&b页码,&p/&P

		}catch(e){}

}

function PrintCst(jsonObj){
	$("#patName").html(jsonObj.PatName);
	$("#patAge").html(jsonObj.PatSex);
	$("#patInLoc").html(jsonObj.PatLoc);
	$("#inHospNo").html(jsonObj.MedicareNo);
	$("#patSeatNo").html(jsonObj.PatBed);
	$("#consultTime").html(jsonObj.CstNDate+"    "+jsonObj.CstNTime);
	$("#consultAddress").html(jsonObj.CstNPlace);
	$("#consultLoc").html(jsonObj.CsLocDescS);
	$("#moreDepTalk").html(jsonObj.CsOpinion.replace(/\r/g,"<br/>"));
}
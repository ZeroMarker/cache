
$(document).ready(function(){	
	InitParams();
	PageSetup_Null() //IE ���ش�ӡʱ�ļ�·��������
	PrintCons();
})

function InitParams(){
	pageMargin={};
	pageMargin.left=0/25.4;  //��һ������Ϊ���õı߾�(mm)
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

//��ӡ
function UlcerPrint(){
	if(!!window.ActiveXObject||"ActiveXObject"in window){ //�ж��Ƿ���IE�����
		document.getElementById('WebBrowser').ExecWB(6,2);
		InsCsMasPrintFlag(CstID,"Y");  /// �޸Ļ����ӡ��־
		window.close();	 
	}else{
		if(document.execCommand("print")){
			//window.close();	
		}	
	}	
 }
 
 /// �޸Ļ����ӡ��־
function InsCsMasPrintFlag(mdtID,printFlag){
	runClassMethod("web.DHCMDTConsult","InsCsMasPrintFlag",{"CstID":mdtID,"PrintFlag":printFlag},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("��ʾ:","���»����ӡ״̬ʧ�ܣ�ʧ��ԭ��:"+jsonString);
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
        //����ҳü��Ϊ�գ�   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, "");
        HKEY_Key = "footer";
        //����ҳ�ţ�Ϊ�գ�   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, "");
        HKEY_Key = "margin_bottom";
        //������ҳ�߾ࣨ0��   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.bottom);
        HKEY_Key = "margin_left";
        //������ҳ�߾ࣨ0��   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.left);
        HKEY_Key = "margin_right";
        //������ҳ�߾ࣨ0��   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.right);
        HKEY_Key = "margin_top";
        //������ҳ�߾ࣨ8��   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.top);
		
		HKEY_Key = "Shrink_To_Fit";  
		//������ҳ�߾ࣨ8��   
        Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, pageMargin.shrink);
		
    } catch(e) {
        alert("������ActiveX�ؼ�");
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

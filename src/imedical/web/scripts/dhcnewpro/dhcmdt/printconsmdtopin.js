
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
        //alert("������ActiveX�ؼ�");
    }
}

function PrintCst(jsonObj){
	$("#PatName").html(jsonObj.PatName); /// ����
	$("#PatSex").html(jsonObj.PatSex);   /// �Ա�
	$("#PatAge").html(jsonObj.PatAge);   /// ����
	$("#PatTelH").html(jsonObj.PatTelH);   /// ��ϵ�绰
	$("#PatCardNo").html(jsonObj.PatNo);   /// �ǼǺ�
	$("#MedicareNo").html(jsonObj.MedicareNo); /// ������
	$("#CstNDate").html(jsonObj.CstNDate);     /// ����ʱ��
	$("#CstNPlace").html(jsonObj.CstNPlace);   /// ����ص�
	$("#CstTrePro").html(jsonObj.CstTrePro);   /// ����ժҪ
	$("#PatDiag").html(jsonObj.PatDiag);       /// �������
	$("#CstPurpose").html(jsonObj.CstPurpose); /// ����Ŀ��
	$("#CstOpinion").html(jsonObj.CstOpinion); /// �������
	
	var itemhtmlArr = []; itemhtmlstr = "";
	var mdtCsLocs = jsonObj.mdtCsLocs;  /// ��������б�
	if (mdtCsLocs != ""){
		var mdtCsLocArr = mdtCsLocs.split("#");
		for (var i=1; i <= mdtCsLocArr.length; i++){
			var itemArr = mdtCsLocArr[i-1].split("@");
			itemhtmlArr.push('<td colspan="2"><label>'+ itemArr[0] +'</label></td><td colspan="2"><label>'+ itemArr[1] +'</label></td>');
			if (i % 2 == 0){
				itemhtmlstr = itemhtmlstr + '<tr height="35px">' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((i-1) % 2 != 0){
			var html = '<td colspan="2"><label></label></td><td colspan="2"><label></label></td>';
			itemhtmlstr = itemhtmlstr + '<tr height="35px">' + itemhtmlArr.join("") + html +'</tr>';
			itemhtmlArr = [];
		}
		/// ������ϲ�����
		var rowpan = 0;
		if (mdtCsLocArr.length % 2 == 0){
			rowpan = parseInt(mdtCsLocArr.length / 2);
		}else{
			rowpan = parseInt(mdtCsLocArr.length / 2) + 1;
		}
		$("#user").attr("rowspan",rowpan + 1); /// �ϲ���
		$(".form-table tr:eq(9)").after(itemhtmlstr);
	}
	
	return;
}

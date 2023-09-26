
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
        //alert("不允许ActiveX控件");
    }
}

function PrintCst(jsonObj){
	$("#PatName").html(jsonObj.PatName); /// 姓名
	$("#PatSex").html(jsonObj.PatSex);   /// 性别
	$("#PatAge").html(jsonObj.PatAge);   /// 年龄
	$("#PatTelH").html(jsonObj.PatTelH);   /// 联系电话
	$("#PatCardNo").html(jsonObj.PatNo);   /// 登记号
	$("#MedicareNo").html(jsonObj.MedicareNo); /// 病案号
	$("#CstNDate").html(jsonObj.CstNDate);     /// 会诊时间
	$("#CstNPlace").html(jsonObj.CstNPlace);   /// 会诊地点
	$("#CstTrePro").html(jsonObj.CstTrePro);   /// 病情摘要
	$("#PatDiag").html(jsonObj.PatDiag);       /// 初步诊断
	$("#CstPurpose").html(jsonObj.CstPurpose); /// 会诊目的
	$("#CstOpinion").html(jsonObj.CstOpinion); /// 会诊意见
	
	var itemhtmlArr = []; itemhtmlstr = "";
	var mdtCsLocs = jsonObj.mdtCsLocs;  /// 会诊科室列表
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
		/// 计算需合并行数
		var rowpan = 0;
		if (mdtCsLocArr.length % 2 == 0){
			rowpan = parseInt(mdtCsLocArr.length / 2);
		}else{
			rowpan = parseInt(mdtCsLocArr.length / 2) + 1;
		}
		$("#user").attr("rowspan",rowpan + 1); /// 合并行
		$(".form-table tr:eq(9)").after(itemhtmlstr);
	}
	
	return;
}

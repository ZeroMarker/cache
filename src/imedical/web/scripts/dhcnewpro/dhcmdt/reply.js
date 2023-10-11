//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-03-10
// 描述:	   意见记录
//===========================================================================================
var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var McID = "";      	/// 随访ID
var CstID = "";         /// 会诊ID
var mcType="R"
var ParentDr=""
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgUserID+"^"+LgLocID+"^"+LgGroupID+"^"+LgHospID
var del = String.fromCharCode(2);
/// 页面初始化函数
function initPageDefault(){
	
   	InitPatEpisodeID();       /// 初始化加载病人就诊ID

	InitMoreScreen();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   	/// 病人ID
	EpisodeID = getParam("EpisodeID");   	/// 就诊ID
	mradm = getParam("mradm");           	/// 就诊诊断ID
	CstID = getParam("CstID");              /// 会诊ID
	ParentDr = getParam("McID");            /// 随访ID
	if(ParentDr==""){
		ParentDr=$.cm({ 
			ClassName:"web.DHCMDTFolUpVis",
			MethodName:"GetLastMcID",
			ID:CstID,
			dataType:"text"
		}, false);
	}
	if(ParentDr==""){
		$.messager.alert("提示", "没有监测到反馈信息,禁止回复!","warning");
		$("#submitBut").linkbutton('disable');
		$("#mdtSignCsBut").linkbutton('disable');
		return;	
	}
	LoadContent(CstID)
}


/// 加载随访内容
function LoadContent(CstID,Type){
	runClassMethod("web.DHCMDTFolUpVis","JsFloUpVis",{"CstID":CstID,"McID":ParentDr,"Type":"","LgParam":LgParam},function(jsonString){
		if (jsonString != null){
			InsMcPanel(jsonString);
		}
	},'json',false)
}

/// 更新页面意见内容
function InsMcPanel(itemArr){
	var htmlstr = "";
	var McType=""
	for (var i=0; i<itemArr.length; i++){
		htmlstr = htmlstr + '<div style="margin-top:10px;" id="'+ itemArr[i].McID +'">';
		if(itemArr[i].McType=="F"){
		  McType=$g("反馈");
		  htmlstr = htmlstr + '	<span class="fuvis">'+ McType +'</span >'; 	/// 随访(回复)科室
		}else{
		  McType=$g("意见");
		  htmlstr = htmlstr + '	<span class="reply">'+ McType +'</span >'; 	/// 随访(回复)科室
	    }
		htmlstr = htmlstr + '	<span class="container">'+ itemArr[i].McLoc +'</span >'; 	/// 随访(回复)科室
		htmlstr = htmlstr + '	<span  class="container">'+ itemArr[i].McUser +'</span>'; 	/// 随访医师/回复专家
		htmlstr = htmlstr + '	<span  class="container">'+ itemArr[i].McDate +'</span>'; 	/// 随访(回复)日期
		if(itemArr[i].McType=="R"){
		  htmlstr = htmlstr + '	<a class="container"  href="#" id="'+ itemArr[i].McID +'" onclick="ReplyEdit(this.id)">'+$g("编辑")+'</a>'; 	/// 专家建议
		}
		htmlstr = htmlstr + '</div>';
		var McContent = "";
		if ((itemArr[i].McContent != "")&(typeof itemArr[i].McContent != "undefined")){
			//McContent = itemArr[i].McContent.replace(new RegExp("<br>","g"),"\r\n")
		    McContent = itemArr[i].McContent.replace(new RegExp("\n","g"),"<br>") //\r

		}
		McContent=$_TrsTxtToSymbol(McContent) 
		htmlstr = htmlstr + '<div  class="textarea">'+ McContent +'</div>';  	/// 随访信息
	    $("#Opinion").html(itemArr[i].TreMeasures)  //会诊意见

	}
	$("#Reply").html(htmlstr);
	 	
}

///  随访编辑
function ReplyEdit(McID){
	runClassMethod("web.DHCMDTFolUpVis","GetMcContent",{"McID":McID},function(jsonString){
		
		if (jsonString != null){
			getContent(jsonString);
		}
	},'json',false)
}


/// 获取随访内容
function getContent (itemObj){
	McID = itemObj.McID;
	$("#mcContent").val(itemObj.McContent);
	
}

/// 提交随访记录
function SubmitBut(){
	
	//专家是否已经签过名了
	if(McID!=""){
		var IsCASign=IsgetsignmdtSIGNID(McID)
		if(IsCASign!=1){
			//$.messager.alert("提示", "会诊专家已经签名,不能修改本次建议！","warning")	
		    //return;
		}
	}
	
	var mcContent = $("#mcContent").val();     /// 本次随访
	if (mcContent.replace(/\s/g,'') == ""){
		$.messager.alert("提示:","本次建议不能为空！","warning");
		return;
	}
	mcContent = $_TrsSymbolToTxt(mcContent);        /// 处理特殊符号
	
	var mListData=CstID +"@!@"+ LgLocID +"@!@"+ LgUserID +"@!@"+ mcContent +"@!@"+ mcType
	/// 保存
	runClassMethod("web.DHCMDTFolUpVis","Insert",{"McID":McID, "mListData":mListData,"ParentDr":ParentDr},function(jsonString){
		if(jsonString=="-1"){
			$.messager.alert("提示:","请修改专家建议信息！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","本次建议提交失败，失败原因:"+jsonString,"warning");
		}else{
			McID = jsonString;
			$.messager.alert("提示:","提交成功！")
			LoadContent(CstID);
			$("#mcContent").val("");
		}
	},'',false)
}

/// 引用
function OpenEmr(flag){
	
	var url = "dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&Type=2"+"&MWToken="+websys_getMWToken(); //+obj.text;
	//"dhcem.quote.csp?PatientID=61&amp;EpisodeID=73&amp;Type=2"
	websys_showModal({
		url: url,
		iconCls:"icon-w-paper",
		title: "引用",
		closed: true,
		//width:parseInt($(window.parent).width())-100,height:parseInt($(window.parent).height())-50,
		width:1280,
		height:600,
		InsQuote:function(resQuote ,Flag){
			if ($("#mcContent").val() == ""){
				$("#mcContent").val(resQuote);  		/// 内容
			}else{
				$("#mcContent").val($("#mcContent").val()  +"\r\n"+ resQuote);
			}
		},
		onClose:function(){}
	});
	return;

	//var url="dhcmdt.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	var url = "dhcem.consultpatemr.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&targetName=Attitude"+"&TextValue="+"&MWToken="+websys_getMWToken(); //+obj.text;
	var result = window.showModalDialog(url,"_blank",'dialogWidth:1280px;DialogHeight=600px;center=1'); 
	try{
		if (result){
			if ($("#MCContent").val() == ""){
				$("#MCContent").val(result.innertTexts);  		/// 内容
			}else{
				$("#MCContent").val($("#MCContent").val()  +"\r\n"+ result.innertTexts);  		/// 简要病历
			}
		}
	}catch(ex){}
}

/// 弹出医嘱录入窗口
function OpenCsOrderWin(){
	
	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择会诊记录后重试！","warning");
		return;
	}
	var lnk = "dhcem.consultorder.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	websys_showModal({
		url:lnk,
		title:'医嘱录入',
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
		}
	});
}

/// 签名
function mdtSignCs(){
	
	if (McID == ""){
		$.messager.alert("提示:","mdt会诊专家不能为空！","warning");
		return;
	}
	
	//专家是否已经签过名了
	var IsCASign=IsgetsignmdtSIGNID(McID)
	if(IsCASign!=1){
		$.messager.alert("提示", "会诊专家已经签名,不能重复签名！","warning")	
	    return;
	}
	
	InvDigSign(CstID,McID); /// 调用数字签名
}



function InitMoreScreen(){
	if(!IsOpenMoreScreen) return;
	
	ShowEmrScr();
	
	ListenRetValue();
}
function ListenRetValue(){
	websys_on("onMdtRefData",function(res){
		if(res.flag===''){
			var nowValue = $("#mcContent").val();
			$("#mcContent").val( nowValue+(nowValue?'\r\n':'')+res.text);
		}
	});
}


/// 病历查看:超融合
function ShowEmrScr(){
	if(!IsOpenMoreScreen) return;

	var Obj={
		PatientID:PatientID,
		EpisodeID:EpisodeID,
		Type:2,
		EpisodeLocID:session['LOGON.CTLOCID'],
		Action:"externalapp"
	}
	
	websys_emit("onMdtConsWriteOpen",Obj);
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
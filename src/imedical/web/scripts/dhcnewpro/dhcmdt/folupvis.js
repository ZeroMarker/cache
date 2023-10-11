//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-03-06
// 描述:	   随访记录
//===========================================================================================
var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var CstID = "";         /// 会诊申请ID
var McID = "";      	/// 随访ID
var mcType="F"
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgUserID+"^"+LgLocID+"^"+LgGroupID+"^"+LgHospID
/// 页面初始化函数
function initPageDefault(){
	
   InitPatEpisodeID();       /// 初始化加载病人就诊ID
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   	/// 病人ID
	EpisodeID = getParam("EpisodeID");   	/// 就诊ID
	mradm = getParam("mradm");           	/// 就诊诊断ID
	CstID = getParam("CstID");              /// 会诊ID
	McID = getParam("McID");             	/// 随访ID
	LoadContent(CstID)
	InitMoreScreen();
}


/// 加载随访内容
function LoadContent(CstID,Type){
	runClassMethod("web.DHCMDTFolUpVis","JsFloUpLastVis",{"CstID":CstID,"McID":McID,"Type":"","LgParam":LgParam},function(jsonString){
		if (jsonString != null){
			InsMcPanel(jsonString);
		}
	},'json',false)
}

/// 更新页面随访内容
function InsMcPanel(itemArr){
	var htmlstr = "";
	var McType=""
	for (var i=0; i<itemArr.length; i++){
		htmlstr = htmlstr + '<div style="margin-top:10px;" ids="'+ itemArr[i].McID +'">';
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
		if(itemArr[i].McType=="F"){
		  htmlstr = htmlstr + '	<a class="container"  href="#" id="'+ itemArr[i].McID +'" onclick="FolEdit(this.id)">'+$g("编辑")+'</a>'; 	/// 主管医生随访
		}
		htmlstr = htmlstr + '</div>';
		var McContent = "";
		if ((itemArr[i].McContent != "")&(typeof itemArr[i].McContent != "undefined")){
			//McContent = itemArr[i].McContent.replace(new RegExp("<br>","g"),"\r\n")
			McContent = itemArr[i].McContent.replace(new RegExp("\n","g"),"<br>") //\r

		}
		McContent=$_TrsTxtToSymbol(McContent)       							/// 随访信息
		htmlstr = htmlstr + '<div  class="textarea">'+ McContent +'</div>';  	/// 随访信息
	}
	$("#feedback").html(htmlstr);
	 	
}

///  随访编辑
function FolEdit(McID){
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
    
	var mcContent = $("#mcContent").val();     /// 本次随访
	if (mcContent.replace(/\s/g,'') == ""){
		$.messager.alert("提示:","本次随访不能为空！","warning");
		return;
	}
/* 	if ((mcContent != "")&(typeof mcContent != "undefined")){
		mcContent = mcContent.replace(new RegExp("<br>","g"),"\r\n")
	} */
	mcContent = $_TrsSymbolToTxt(mcContent);        /// 处理特殊符号
	
	var mListData=CstID +"@!@"+ LgLocID +"@!@"+ LgUserID +"@!@"+ mcContent +"@!@"+ mcType
	/// 保存
	runClassMethod("web.DHCMDTFolUpVis","Insert",{"McID":McID, "mListData":mListData},function(jsonString){
		if(jsonString=="-1"){
			$.messager.alert("提示:","请修改上次反馈信息！","warning");
			return;
		}
		if(jsonString=="-104"){
			$.messager.alert("提示:","内容过多,字数限制1000字以内！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","本次随访提交失败，失败原因:"+jsonString,"warning");
		}else{
			McID = jsonString;
			$.messager.alert("提示:","提交成功！")
			LoadContent(CstID)
			McID="";
			$("#mcContent").val("");
			
			if(window.parent.frames.length){
				window.parent.frames[1].$("#tag_id").tabs("getTab","随访记录").find("iframe")[0].contentWindow.InitlogDetailsList();
			}
			//$("#TimeAxis").location.reload()

		}
	},'',false)
}

/// 引用
function OpenEmr(flag){

	//var url="dhcmdt.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	//dhcem.patemrque.csp?EpisodeID=1624&PatientID=671
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
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	
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
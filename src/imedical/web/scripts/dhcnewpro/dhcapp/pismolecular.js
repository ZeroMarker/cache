//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-04
// 描述:	   分子病理申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var editSelRow = -1;    /// 当前编辑行
var PisID = "";         /// 病理申请ID
var TakOrdMsg = "";
var pid = "";  			 /// 唯一标识
var mListDataDoc = "";   /// 医生站界面参数内容
var DocMainFlag = "";    /// 医生站界面弹出标示
var LgUserID = session['LOGON.USERID'];   /// 用户ID
var LgCtLocID = session['LOGON.CTLOCID']; /// 科室ID
var LgGroupID = session['LOGON.GROUPID']; /// 安全组ID
var LgHospID=session['LOGON.HOSPID'];

/// 页面初始化函数
function initPageDefault(){

	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	LoadTestItemList();       /// 加载HPV病人病历内容
	//LoadCheckItemList();      /// 加载病理检查项目
	LoadCutBaseList();        /// 加载取材分类内容
	InitPageCheckBox();       /// 页面CheckBox控制
	GetPatBaseInfo();         /// 加载病人信息
	LoadPatClinicalRec();	  /// 加载临床病历
	GetIsWritePisFlag();      /// 是否可填写判断
	InitVersionMain();        /// 页面兼容配置
}

/// 页面兼容配置
function InitVersionMain(){
	
	/// 弹出界面时,检查申请采用新版录入界面
	if (DocMainFlag == 1){
		$('#tPanel').panel({closed:true});        /// 隐藏【申请信息】
		$('#mainPanel').layout("remove","south"); /// 隐藏【按钮栏】
		$('a:contains("取消申请")').hide();
		$('a:contains("发送")').hide();
		$('a:contains("打印")').hide();
		LoadCheckItemListDoc();      /// 加载病理检查项目
		var PanelWidth = window.parent.frames.GetPanelWidth();
		/// 面板【申请信息】大小调整 
		$('#mPanel').panel('resize',{width: PanelWidth ,height: 100});
		/// 面板【综合信息】大小调整
		$('#cPanel').panel('resize',{width: PanelWidth ,height: 540});
	}else{
		LoadCheckItemList();         /// 加载病理检查项目
	}
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	PisID = getParam("itemReqID");  /// 申请单ID
			
	/// 以下为医生站弹出参数 内容
	pid = getParam("pid");          /// 唯一标识
	mListDataDoc = getParam("ARCIMStr");
	if (mListDataDoc != ""){
		DocMainFlag = 1;
		var mParam = mListDataDoc.split("!")[0];
		if (mParam != ""){
			EpisodeID = mParam.split("^")[0];
		}
	}
}

/// 初始化界面控件内容
function InitPageComponent(){
	
	/// 接收科室
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
		},
		onShowPanel:function(){
			var itmmastid = $("#TesItemID").val();
			if (itmmastid != ""){
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+itmmastid;
				$("#recLoc").combobox('reload',unitUrl);
			}
		}
	}
	new ListCombobox("recLoc",'','',option).init();
	
	/// 病理检查项目选中事件
	$("#itemList").on("click","[name='item']",TesItm_onClick);
	
	/// 申请科室 
	$('#ApplyLoc').combobox({	//申请科室和申请医生可以选择(默认就诊医生和科室) 2018/2/5 qunianpeng 
		mode:'remote',  
		onShowPanel:function(){
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&hospId="+LgHospID;
			$("#ApplyLoc").combobox('reload',unitUrl);
		},
		onSelect:function(){	//设置级联 选择科室后，加载可以登录该科室的医生 qunianpeng 2018/2/7
			$("#ApplyDocUser").combobox("setValue","");
			$("#ApplyDocUser").combobox('reload');
		}
	});
	
	/// 申请医生  
	$('#ApplyDocUser').combobox({
		//mode:'remote',  
		onShowPanel:function(){
			var appLocID=$('#ApplyLoc').combobox('getValue');
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+appLocID;
			$("#ApplyDocUser").combobox('reload',unitUrl);
		}
	});	
	
	/// 界面按钮状态
	$('a:contains("取消申请")').linkbutton('disable');
	$('a:contains("取消申请")').removeClass('btn-lightred');
	$('a:contains("发送")').linkbutton('disable');
	$('a:contains("发送")').removeClass('btn-lightgreen');
	$('a:contains("打印")').linkbutton('disable');
}

/// 选中检查项目
function TesItm_onClick(){
	
	if ($(this).is(':checked')){
		
		if (TakOrdMsg != ""){
			$.messager.alert("提示:",TakOrdMsg);
			return;	
		}
		
		/// 诊断判断
		if (window.parent.frames.GetMRDiagnoseCount() == 0){
			$.messager.alert("提示:","病人没有诊断,请先录入！","",function(){window.parent.frames.DiagPopWin()});
			$(this).attr("checked",false);
			return;	
		}
		
		/// 检查方法【医嘱项ID、医嘱项名称】
		var TesItemID = this.id;    /// 检查方法ID
		var TesItemDesc = $(this).parent().next().text(); /// 检查方法
		var itmmastid = TesItemID.replace("_","||");
		$("#TesItemID").val(itmmastid);
		$("#TesItemDesc").val(TesItemDesc);

		/// 医嘱的性别/年龄限制
		var LimitMsg = window.parent.frames.GetItmLimitMsg(itmmastid)
		if (LimitMsg != ""){
			$.messager.alert("提示:","项目【" +TesItemDesc+ "】被限制使用：" + LimitMsg);
			return;	
		}
		
		/// 接收科室
		var LocID = ""; var LocDesc = "";
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmastid},function(jsonString){
			
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				LocID = jsonObjArr[0].value;
				LocDesc = jsonObjArr[0].text;
			}
		},'json',false)

		$("#recLoc").combobox("setValue",LocID);
		$("#recLoc").combobox("setText",LocDesc);
	}
}

/// 页面CheckBox控制
function InitPageCheckBox(){
	
	$("input[name=CutBas]").click(function(){
		
		if($("[value='"+this.id+"'][name=CutBas]").is(':checked')){
			$("input[name=CutBas]:not([value='"+this.id+"'])").removeAttr("checked");
		}
	});
	
	/// 检测项目
	$("input[name=TestItem]").click(function(){
		
		if($("[value='"+this.id+"'][name=TestItem]").is(':checked')){
			$("input[name=TestItem]:not([value='"+this.id+"'])").removeAttr("checked");
		}
	});	
	
	///控制医嘱项单选  sufan 2018-01-30
	var tempckid="";
	//$("#itemList input[type='checkbox'][name='item']").click(function(){
	$("#itemList").on("click","[name='item']",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("#itemList input[type='checkbox'][name="+this.name+"]").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					}
				})
			
			}else{
					$("#TesItemID").val("");
					$("#TesItemDesc").val("");
					$("#recLoc").combobox("setValue","");
					$("#recLoc").combobox("setText","");
				}
		})
}

/// 病人就诊信息
function GetPatBaseInfo(){
	runClassMethod("web.DHCAppPisMasterQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "LocID":session['LOGON.CTLOCID'], "UserID":session['LOGON.USERID'] },function(jsonString){
		var jsonObject = jsonString;		
		if (PisID == ""){
		
			/// 申请医生	
			$('#ApplyDocUser').combobox("setValue",session['LOGON.USERID']);
			$('#ApplyDocUser').combobox("setText",session['LOGON.USERNAME']);	
			
			/// 申请科室
			$('#ApplyLoc').combobox("setValue",session['LOGON.CTLOCID']); 
			$('#ApplyLoc').combobox("setText",jsonObject.LgLocDesc);		
		}		
	},'json',false)
}

/// 加载检查方法列表
function LoadCheckItemList(){
	
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCode",{"Code":"MOL"},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="item" type="checkbox"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(htmlstr+itemhtmlstr)
}

/// 加载取材分类内容
function LoadCutBaseList(){
	
	/// 初始化取材分类区域
	$("#CutBas").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","JsonGetPisCutBasList",{"HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsCutBaseRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检测取材分类内容
function InsCutBaseRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 4 == 0){
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 4 != 0){
		itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#CutBas").append(htmlstr+itemhtmlstr)
}

/// 加载检测项目内容
function LoadTestItemList(){
	
	/// 初始化检查方法区域
	$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","JsonTestItemList",{"HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsTesItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检测项目内容
function InsTesItemRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		htmlstr = '<tr style="height:30px"><td colspan="7" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 3 == 0){
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 3 != 0){
		itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#TesItem").append(htmlstr+itemhtmlstr)
}

/// 保存病理申请
function SavePisNo(){
	
	/*
	/// 医生站弹出界面时调用
	if (DocMainFlag == 1){
		InsertDoc();
		return;
	}
	*/
	
	var itmmastid = $("#TesItemID").val();  			   /// 医嘱项ID
	if (itmmastid == ""){
		$.messager.alert("提示:","请先选择病理检查项目！");
		return;
	}
	var recLocID = $HUI.combobox("#recLoc").getValue();    /// 接收科室ID
	var ApplyDocUser = $HUI.combobox("#ApplyDocUser").getValue();    /// 申请医生  qunianpeng 2018/2/5
	var ApplyLoc = $HUI.combobox("#ApplyLoc").getValue(); 			 /// 申请科室
	if(ApplyLoc==""){
		$.messager.alert("提示:","请先选择申请科室！");
		return;
	}
	if(ApplyDocUser==""){
		$.messager.alert("提示:","请先选择申请医生！");
		return;
	}
	var EmgFlag = ""; //$HUI.checkbox("#EmgFlag").getValue() ? "Y":"N";     /// 加急
	var FrostFlag = ""; //$HUI.checkbox("#FrostFlag").getValue() ? "Y":"N"; /// 冰冻
	var MedRecord =  $("#MedRecord").val(); 			   /// 病人病历
	var MedDiag =  $("#MedDiag").val(); 			       /// 临床诊断
	var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ "" +"^"+ MedRecord +"^"+ MedDiag +"^^^MOL" +"^";

	/// 取材信息 
	var Position =  $("#Position").val(); 		     	   /// 取材部位
	if (Position == ""){
		$.messager.alert("提示:","取材部位不能为空！");
		return;
	}
	var mType="";										   /// 取材类型
    var mTypeArr = $("input[name=CutBas]");
    for (var j=0; j < mTypeArr.length; j++){
	    if($("[value='"+mTypeArr[j].value+"'][name=CutBas]").is(':checked')){
			mType = mTypeArr[j].value;
	    }
	}
	if (mType == ""){
		$.messager.alert("提示:","取材类型不能为空！");
		return;
	}
	var mPisPatSpec = "1^^"+ Position +"^^^^^^"+ mType;

	/// 检测项目
	var mPisTestItem=""; mPisTestItemArr = [];
    var TestItemArr = $("input[name=TestItem]");
    for (var j=0; j < TestItemArr.length; j++){
	    if($("[value='"+TestItemArr[j].value+"'][name=TestItem]").is(':checked')){
			mPisTestItemArr.push(TestItemArr[j].value);
	    }
	}
	var mPisTestItem = mPisTestItemArr.join("@");
	
	///             主信息  +"&"+  病理标本  +"&"+   检测项目
	var mListData = mListData +"&"+ mPisPatSpec +"&"+ mPisTestItem;

	/// 保存
	runClassMethod("web.DHCAppPisMaster","Insert",{"PisType":"MOL", "PisID":PisID, "mListData":mListData},function(jsonString){

		if (jsonString < 0){
			$.messager.alert("提示:","病理申请单保存失败，失败原因:"+jsonString);
		}else{
			PisID = jsonString;
			GetPisNoObj(PisID);
			$.messager.alert("提示:","保存成功！");
		    /// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		}
	},'',false)
}

/// 发送病理申请
function SendPisNo(){

	/// 住院急诊留观押金控制
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$.messager.alert("提示:",PatArrManMsg);
		return;	
	}
	
	/// 保存
	runClassMethod("web.DHCAppPisMaster","InsSendFlag",{"PisID":PisID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","病理申请单已发送无需再次发送!");
		}else if (jsonString < 0){
			$.messager.alert("提示:","病理申请单发送失败，失败原因:"+jsonString);
		}else{
			GetPisNoObj(PisID);
			$.messager.alert("提示:","发送成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
			/// 电子病历框架函数
			window.parent.frames.InvEmrFrameFun();
		}
	},'',false)
}

/// 临时存储数据
function InsertDoc(){
	
	/// 医嘱项串
	var mItemParam = mListDataDoc.split("!")[1];
	if (mItemParam == "") return false;

	var ApplyDocUser = session['LOGON.USERID'];    /// 申请医生
	var ApplyLoc = session['LOGON.CTLOCID']; 	   /// 申请科室
	var EmgFlag = ""; 
	var FrostFlag = "";
	var MedRecord =  $("#MedRecord").val(); 			   /// 病人病历
	var MedDiag =  $("#MedDiag").val(); 			       /// 临床诊断
	var mListData = "^^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ "" +"^"+ MedRecord +"^"+ MedDiag +"^^^MOL" +"^";

	/// 取材信息 
	var Position =  $("#Position").val(); 		     	   /// 取材部位
	if (Position == ""){
		window.parent.frames.InvErrMsg("【分子病理申请】取材部位不能为空！");
		return false;
	}
	var mType="";										   /// 取材类型
    var mTypeArr = $("input[name=CutBas]");
    for (var j=0; j < mTypeArr.length; j++){
	    if($("[value='"+mTypeArr[j].value+"'][name=CutBas]").is(':checked')){
			mType = mTypeArr[j].value;
	    }
	}
	if (mType == ""){
		window.parent.frames.InvErrMsg("【分子病理申请】取材类型不能为空！");
		return false;
	}
	var mPisPatSpec = "1^^"+ Position +"^^^^^^"+ mType;

	/// 检测项目
	var mPisTestItem=""; mPisTestItemArr = [];
    var TestItemArr = $("input[name=TestItem]");
    for (var j=0; j < TestItemArr.length; j++){
	    if($("[value='"+TestItemArr[j].value+"'][name=TestItem]").is(':checked')){
			mPisTestItemArr.push(TestItemArr[j].value);
	    }
	}
	var mPisTestItem = mPisTestItemArr.join("@");
	
	///             主信息  +"&"+  病理标本  +"&"+   检测项目
	var mListData = mListData +"&"+ mPisPatSpec +"&"+ mPisTestItem;

	/// 保存
	runClassMethod("web.DHCAppPisMaster","InsertTempDoc",{"Pid":pid, "mListData":mListData, "mItemParam":mItemParam},function(jsonString){
		if (jsonString < 0){
			window.parent.frames.InvErrMsg("【分子病理申请】保存失败，失败原因:"+jsonString);
			return false;
		}
	},'',false)
	
	return true;
}

/// 加载病理申请主信息内容
function GetPisNoObj(PisID){
	
	runClassMethod("web.DHCAppPisMaster","JsGetPisNoObj",{"PisID":PisID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsPisNoObj(jsonObjArr);
		}
	},'json',false)
}

/// 加载病理申请病人病历内容
function GetPisItemList(){

	runClassMethod("web.DHCAppPisMasterQuery","JsonPisItemList",{"PisID":PisID, "Type":"MOL"},function(jsonString){

		if (jsonString != ""){
			var itemArr = jsonString;
			for (var j=0; j<itemArr.length; j++){
				$("[name="+ itemArr[j].name +"][value="+ itemArr[j].value +"]").attr("checked",'true'); 
			}
			$("input[name='TestItem']").each(function(){
				if(!$(this).attr("checked")){
					$(this).parent().hide();
					$(this).parent().next().hide();
				}
			})
		}

	},'json',false)
}

/// 设置病历申请单内容
function InsPisNoObj(itemobj){
	
	$("#TesItemID").val(itemobj.arcimid);
	$("#TesItemDesc").val(itemobj.ItemDesc);          /// 医嘱名称
	$("#recLoc").combobox("setValue",itemobj.LocID);  /// 接收科室
	$("#recLoc").combobox("setText",itemobj.LocDesc); /// 接收科室
	$HUI.combobox("#ApplyDocUser").setValue(itemobj.ApplyDocId);  /// 申请科室和申请医生 qunianpeng 2018/2/5
	$HUI.combobox("#ApplyDocUser").setText(itemobj.ApplyDocDesc);	
	$HUI.combobox("#ApplyLoc").setValue(itemobj.ApplyLocId);	
	$HUI.combobox("#ApplyLoc").setText(itemobj.ApplyLocDesc);

	$HUI.checkbox("#EmgFlag").setValue(itemobj.EmgFlag == "Y"? true:false);      /// 加急
	$HUI.checkbox("#FrostFlag").setValue(itemobj.FrostFlag == "Y"? true:false);  /// 冰冻
	$("#MedRecord").val(itemobj.MedRecord); 	   		       /// 病人病历
	$("#MedDiag").val(itemobj.MedDiag); 	   	     	       /// 临床诊断
	$("#Position").val(itemobj.Position); 	   		           /// 取材部位
	$("[name=CutBas][value="+ itemobj.Type +"]").attr("checked",'true');
	
	var SendPisFlag = itemobj.SendPisFlag;  /// 是否允许再次发送
	if (SendPisFlag == 1){
		$('a:contains("取消申请")').linkbutton('disable');
		$('a:contains("取消申请")').removeClass('btn-lightred');
		$('a:contains("发送")').linkbutton('disable');
		$('a:contains("发送")').removeClass('btn-lightgreen');
		$('a:contains("保存")').linkbutton('disable');
		$('a:contains("保存")').removeClass('btn-lightgreen');
		$('a:contains("打印")').linkbutton('disable');
		PageEditFlag(1);  /// 设置界面编辑状态
	}else if (SendPisFlag == 2){
		$('a:contains("发送")').linkbutton('disable');
		$('a:contains("发送")').removeClass('btn-lightgreen');
		$('a:contains("取消申请")').linkbutton('enable');
		$('a:contains("取消申请")').addClass('btn-lightred');
		$('a:contains("打印")').linkbutton('enable');
		PageEditFlag(2);  /// 设置界面编辑状态
	}else{
		$('a:contains("取消申请")').linkbutton('enable');
		$('a:contains("取消申请")').addClass('btn-lightred');
		$('a:contains("发送")').linkbutton('enable');
		$('a:contains("发送")').addClass('btn-lightgreen');
		$('a:contains("保存")').linkbutton('enable');
		$('a:contains("打印")').linkbutton('disable');
	}
	$("#Oeori").text(itemobj.Oeori);  /// 医嘱号
	$("#PisNo").text(itemobj.No);     /// 申请单号
}

/// 设置界面编辑状态
function PageEditFlag(Flag){
	
	$("#TesItemDesc").attr("disabled",true);   /// 医嘱描述
	$HUI.combobox("#recLoc").disable();        /// 接收科室不可用
	$HUI.combobox("#ApplyLoc").disable();      /// 申请科室不可用
	$HUI.combobox("#ApplyDocUser").disable();  /// 申请医生不可用
	$('input[type="checkbox"]').attr("disabled",true);
	$('textarea').attr("disabled", true);  /// 文本框
	$('.validatebox-text').attr("disabled", true); /// hisui 文本
	$('input[type="text"]').attr("disabled", true);
}

/// 是否允许填写申请单
function GetIsWritePisFlag(){
	
	runClassMethod("web.DHCAppPisMasterQuery","GetIsWritePisFlag",{"LgGroupID":session['LOGON.GROUPID'],"LgUserID":session['LOGON.USERID'],"LgLocID":session['LOGON.CTLOCID'],"EpisodeID":EpisodeID},function(jsonString){
		TakOrdMsg = jsonString;
		if(TakOrdMsg != ""){
			$.messager.alert("提示:",TakOrdMsg);
		}
	},'',false)
}

/// 加急
function EmgFlag_onClick(event, value){
	
	if (value == true){
		$HUI.checkbox("#FrostFlag").setValue(false);  /// 冰冻
	}
}

/// 冰冻
function FrostFlag_onClick(event, value){
	
	if (value == true){
		$HUI.checkbox("#EmgFlag").setValue(false);   /// 加急
	}
}

/// 加载检查方法列表
function LoadCheckItemListDoc(){
	
	var arcItemList=mListDataDoc.split("!")[1];

	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td></td><td style="width:20px;"></td><td></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","jsonExaItemListDoc",{"arcItemList":arcItemList},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString
			InitCheckItemRegionDoc(jsonObjArr);
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegionDoc(itemArr){

	var itemhtmlArr = []; itemhtmlstr = "";
	for (var i=1; i<=itemArr.length; i++){
		itemhtmlArr.push('<td style="width:30px;">'+ i +'</td><td>'+ itemArr[i-1].text +'</td><td>'+ itemArr[i-1].desc +'</td>');
		if (i % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
 	if ((i-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(itemhtmlstr);

}

/// 打印病理申请单
function PrintPisNo(){

	PrintPis_REQ(PisID);
	return;
		
//	if (PisID == ""){
//		$.messager.alert("提示:","当前无可打印的病理申请单！");
//		return;
//	}
//	
//	runClassMethod("web.DHCAPPPrintCom","GetPisPrintCon",{"PisID":PisID},function(jsonString){
//		
//		if (jsonString == null){
//			$.messager.alert("提示:","打印异常！");
//		}else{
//			var jsonObj = jsonString;
//			Print_Xml(jsonObj);
//		}
//	},'json',false)	
}

/// 分子申请单打印
function Print_Xml(jsonObj){
	var MyPara = "";
	/// 申请单申请内容
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// 登记号-条码
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;         /// 登记号-条码
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^MedicareNo"+String.fromCharCode(2)+jsonObj.MedicareNo; /// 病案号
	MyPara = MyPara+"^PatBod"+String.fromCharCode(2)+jsonObj.PatBod;         /// 出生日期
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;     /// 费别
	MyPara = MyPara+"^PatBed"+String.fromCharCode(2)+jsonObj.PatBed;         /// 床号
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+jsonObj.PatAddr;       /// 家庭住址
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+jsonObj.PatTelH;       /// 电话
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         /// 年龄
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       /// 病区
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;     /// 申请人
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	 /// 申请科室
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;   /// 创建日期
	
	/// 申请单明细内容
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       /// 加急
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);   /// 冰冻
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// 病理号
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// 申请单号
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// 检测项目
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisReqSpec,60)); /// 病理标本
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.MedRecord,60));   /// 临床病历
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisTesDiag,60)); /// 临床诊断
	MyPara = MyPara+"^Position"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqSpec);   /// 取材部位
	MyPara = MyPara+"^PisCutBasType"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisCutBasType,60)); ///分子病理取材类型 qunianpeng 2018/2/7
	MyPara = MyPara+"^PisTesItmMol"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisTesItmMol,60));  ///分子病理检测项目 qunianpeng 2018/2/7
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisMol");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
	
}

/// 撤销病理申请单
function RevPisNo(){
	
	runClassMethod("web.DHCAppPisMaster","revPisMain",{"PisID":PisID, "UserID":session['LOGON.USERID']},function(jsonString){

		if (jsonString == 0){
			GetPisNoObj(PisID);
			$.messager.alert("提示:","取消成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		}else if(jsonString == "-12"){   //sufan 2018-03-12
			$.messager.alert("提示:","已执行，不能取消申请！");
			}else{
			$.messager.alert("提示:","取消异常！");
		}
	},'',false)
}

/// 打印条码
function PrintPisBar(flag){
	
	window.parent.frames.PrintBar(PisID,flag)
	/*runClassMethod("web.DHCAPPPrintCom","GetPisPrintCon",{"PisID":PisID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var jsonObj = jsonString;
			Print_BarCode(jsonObj);
		}
	},'json',false)*/
}

/// 条码打印
function Print_BarCode(jsonObj){

	var MyPara = "";
	/// 申请单申请内容
	MyPara = "RegNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^lbbarcode"+String.fromCharCode(2)+"*"+jsonObj.PatNo+"*";  /// 登记号-条码
	MyPara = MyPara+"^lbpatname"+String.fromCharCode(2)+jsonObj.PatName;		/// 姓名
	MyPara = MyPara+"^lbpatsex"+String.fromCharCode(2)+jsonObj.PatSex;		    /// 性别
	MyPara = MyPara+"^lbpatage"+String.fromCharCode(2)+jsonObj.PatAge;          /// 年龄
	MyPara = MyPara+"^lblesion"+String.fromCharCode(2)+jsonObj.PatWard;       	/// 病区
	MyPara = MyPara+"^lbapplydoc"+String.fromCharCode(2)+jsonObj.UserName;    	/// 申请人
	MyPara = MyPara+"^lbapllyloc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	/// 申请科室
	MyPara = MyPara+"^lbrecloc"+String.fromCharCode(2)+txtUtil(jsonObj.RecLoc); /// 接收科室
	MyPara = MyPara+"^lbapplydate"+String.fromCharCode(2)+jsonObj.CreatDate;  	/// 创建日期
	MyPara = MyPara+"^CreatTime"+String.fromCharCode(2)+jsonObj.CreatTime;    	/// 创建时间
	MyPara = MyPara+"^lbspecinfo"+String.fromCharCode(2)+txtUtil(jsonObj.SpecName);     	/// 标本
	MyPara = MyPara+"^lbapplycheckpro"+String.fromCharCode(2)+txtUtil(jsonObj.PisItem);     /// 检查项目

	//DHCP_GetXMLConfig("DHCAPP_PisBarCode");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisBarCode");
	//调用具体打印方法
	//DHCP_PrintFun(MyPara, "");
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"");
}

/// 内容为 undefined 显示空
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}
/// 加载临床病历  sufan 2018-02-01
function LoadPatClinicalRec(){
	runClassMethod("web.DHCAppPisMasterQuery","GetPatClinicalRec",{"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
		
			$("#MedRecord").val( jsonObjArr.arExaReqSym +""+ jsonObjArr.arExaReqHis +""+ jsonObjArr.arExaReqSig);  /// 主诉+现病史+体征
			
		}
	},'json',false)
}

/// 申请单是否允许编辑
function InitReqEditFlag(ID){

	var LgParams = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","JsGetReqEditFlag",{"ID":ID, "Type":"P", "LgParams":LgParams},function(jsonString){
		if (jsonString != ""){
			PageBtEditFlag(jsonString);
		}
	},'',false)
}

/// 设置界面编辑状态
function PageBtEditFlag(Flag){
	
	if (Flag == 0){
		$('a:contains("取消申请")').linkbutton('disable');
		$('a:contains("取消申请")').removeClass('btn-lightred');
		$('a:contains("保存")').linkbutton('disable');
		$('a:contains("保存")').removeClass('btn-lightgreen');
	}
}

/// 加载申请单内容
function LoadReqFrame(PisID, repEmgFlag){

	GetPisNoObj(PisID);   /// 加载病理申请
	GetPisItemList();     /// 加载病理申请病人病历内容
	InitReqEditFlag(PisID);  /// 申请单是否允许编辑
}

/// 验证病人是否允许开医嘱 住院急诊留观押金控制
function GetPatArrManage(){

	var PatArrManMsg = "";
	var amount = $("#arExaReqCost").text(); /// 金额
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetArrearsManage",{"EpisodeID":EpisodeID,"LgGroupID":LgGroupID,"LgLocID":LgCtLocID,"amount":amount},function(jsonString){

		if (jsonString != ""){
			PatArrManMsg = jsonString;
		}
	},'',false)

	return PatArrManMsg;
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	if (PisID != ""){
		LoadReqFrame(PisID, "");    /// 加载病理申请
		$("#itemList").hide();
	}
}

window.onload = onload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

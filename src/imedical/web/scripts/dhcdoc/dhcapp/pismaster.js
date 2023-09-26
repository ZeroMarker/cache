//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-04
// 描述:	   HPV病理申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var editSelRow = -1;    /// 当前编辑行
var PisID = "";         /// 病理申请ID
var Oeori = "";         /// 医嘱ID
var isWriteFlagTCT = "-1";
var TakOrdMsg = "";
var pid = "";  			 /// 唯一标识
var mListDataDoc = "";   /// 医生站界面参数内容
var DocMainFlag = "";    /// 医生站界面弹出标示
var LgUserID = session['LOGON.USERID'];   /// 用户ID
var LgCtLocID = session['LOGON.CTLOCID']; /// 科室ID
var LgGroupID = session['LOGON.GROUPID']; /// 安全组ID
var LgHospID=session['LOGON.HOSPID'];
var isPageEditFlag = ""; /// 页面是否允许编辑
var asStaus="";
/// 页面初始化函数
function initPageDefault(){

	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	LoadTestItemList();       /// 加载HPV病人病历内容
	//LoadCheckItemList();      /// 加载病理检查项目
	LoadSpecItemList();       /// 加载标本内容
	InitPageCheckBox();       /// 页面CheckBox控制
	GetPatBaseInfo();         /// 加载病人信息
	//GetIsWriteFlagTCT();      /// 是否可填写判断
	GetIsWritePisFlag();      /// 是否可填写判断
	LoadPisNoByOeori();       /// 加载病理申请单信息
	InitVersionMain();        /// 页面兼容配置
}

/// 页面兼容配置
function InitVersionMain(){
	
	/// 弹出界面时,检查申请采用新版录入界面
	if (DocMainFlag == 1){
		$('#tPanel').panel({closed:true});  	  /// 隐藏【申请信息】
		$('#mainPanel').layout("remove","south"); /// 隐藏【按钮栏】
		$('a:contains("取消申请")').hide();
		$('a:contains("发送")').hide();
		$('a:contains("打印")').hide();
		LoadCheckItemListDoc();      /// 加载病理检查项目
		var PanelWidth = window.parent.frames.GetPanelWidth();
		/// 面板【申请信息】大小调整 
		$('#mPanel').panel('resize',{width: PanelWidth ,height: 100});
		/// 面板【送检标本】大小调整
		$('#sPanel').panel('resize',{width: PanelWidth ,height: 200});
		/// 面板【病人病历】大小调整
		$('#pPanel').panel('resize',{width: PanelWidth ,height: 330});
	}else{
		LoadCheckItemList();         /// 加载病理检查项目
	}
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	PisID = getParam("itemReqID");     /// 申请单ID
	Oeori = getParam("Oeori");         /// 医嘱ID
	if (Oeori != ""){
		$('#mPanel').panel({closed:true}); /// 隐藏【HPV申请信息】
		$('a:contains("发送")').hide();
	}
		
	/// 以下为医生站弹出参数 内容
	pid = getParam("pid");            /// 唯一标识
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
				var OpenForAllHosp=0,LogLoc="";
				var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
				var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
				if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
				if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+itmmastid+"&OrderDepRowId="+LogLoc+"&OpenForAllHosp="+OpenForAllHosp;
				$("#recLoc").combobox('reload',unitUrl);
			}
		}
	}
	new ListCombobox("recLoc",'','',option).init();
	
	/// 病理检查项目选中事件
	$("#itemList").on("click","[name='item']",TesItm_onClick);
	
	/// 首次发现人乳头瘤病毒时间
	$('#FoundDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
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
	
	// 既往手术史增加无选项及切换效果 qunianpeng 2018/8/28
	$("#PrevHisFlag1").on('click',function(){			
		if($("#"+this.id).is(':checked')){
			$("#PrevHisFlag2").removeAttr("checked");
			$("#PrevContent").css('display','block');
		};			
	})
	$("#PrevHisFlag2").on('click',function(){			
		if($("#"+this.id).is(':checked')){
			$("#PrevHisFlag1").removeAttr("checked");
			$("#PrevContent").css('display','none');
		};			
	})
	
	/// 界面按钮状态
	$('a:contains("取消申请")').linkbutton('disable');
	$('a:contains("取消申请")').removeClass('btn-lightred');
	$('a:contains("发送")').linkbutton('disable');
	$('a:contains("发送")').removeClass('btn-lightgreen');
	$('a:contains("打印")').linkbutton('disable');
}
/* ------选中病理项目到已选列表,支持chrome start-------*/
function TesItm_onClick(e){
	if ($(this).is(':checked')){
		ChkBeforeSelectTesItm(e,selectTesItmData)
	}
}
function ChkBeforeSelectTesItm(e,ExcFunc){
	var CallBackFuncList=new Array();
	var CallBackRet=true;
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg);
		return;	
	}
	/// 检查方法【医嘱项ID、医嘱项名称】
	var TesItemID = e.target.id;    /// 检查方法ID
	var TesItemDesc = $(e.target).parent().next().text(); /// 检查方法
	var itmmastid = TesItemID.replace("_","||");
	/// 医嘱的性别/年龄限制
	var LimitMsg = window.parent.frames.GetItmLimitMsg(itmmastid)
	if (LimitMsg != ""){
		$.messager.alert("提示:","项目【" +TesItemDesc+ "】被限制使用：" + LimitMsg);
		return;	
	}
	/// 诊断判断
	if (window.parent.frames.GetMRDiagnoseCount() == 0){
		$.messager.alert("提示:","患者没有诊断,请先录入！","",function(){
			CallBackFuncList.push(
				DiagPopWinNew(function(){
					if (window.parent.frames.GetMRDiagnoseCount()>0) {
						ExecCallBackFuncList();
					}else{
						$(e.target).attr("checked",false);
						return;
					}
				})
			);
			ExecCallBackFuncList();
		})
	}else{
		ExecCallBackFuncList();
	}
	function ExecCallBackFuncList(){
		if (CallBackFuncList.length==0) {
			if (CallBackRet==true) {
				ExcFunc(e);
			}
			return;
		}
		CallBackFuncList[0];
		CallBackFuncList.splice(0,1);
	}
}
function selectTesItmData(e){	
	/// 检查方法【医嘱项ID、医嘱项名称】
	var TesItemID = e.target.id;    /// 检查方法ID
	var TesItemDesc = $(e.target).parent().next().text(); /// 检查方法
	var itmmastid = TesItemID.replace("_","||");
	$("#TesItemID").val(itmmastid);
	$("#TesItemDesc").val(TesItemDesc);
	/// 接收科室
	var LocID = ""; var LocDesc = "";
	var OpenForAllHosp=0,LogLoc="";
	var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
	var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
	if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
	if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmastid,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			LocID = jsonObjArr[0].value;
			LocDesc = jsonObjArr[0].text;
		}
	},'json',false)

	$("#recLoc").combobox("setValue",LocID);
	$("#recLoc").combobox("setText",LocDesc);
}
function DiagPopWinNew(callback){
	var PatientID = $("#PatientID").text();  /// 病人ID
	var mradm = $("#mradm").text();			 /// 就诊诊断ID
	websys_showModal({
		url:"diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm,
		title:'诊断录入',
		width:screen.availWidth-100,height:screen.availHeight-200,
		onClose:function(){
			window.parent.frames.GetPatBaseInfo();  ///  加载病人信息
			if (callback) callback();
		}
	})
}
/* ------选中病理项目到已选列表,支持chrome start-------*/
/// 选中检查项目
/*function TesItm_onClick(){
	
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
		var OpenForAllHosp=0,LogLoc="";
		var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
		var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
		if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
		if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmastid,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
			
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				LocID = jsonObjArr[0].value;
				LocDesc = jsonObjArr[0].text;
			}
		},'json',false)

		$("#recLoc").combobox("setValue",LocID);
		$("#recLoc").combobox("setText",LocDesc);
	}
}*/

/// 加载检查方法列表
function LoadCheckItemList(){
	
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCode",{"Code":"HPV"},function(jsonString){

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

/// 加载HPV病人病历内容
function LoadTestItemList(){
	
	/// 初始化检查方法区域
	$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","JsonItemList",{"HospID": LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsTesItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// HPV病人病历内容
function InsTesItemRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

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
	$("#TesItem").append(htmlstr+itemhtmlstr)
}

/// 加载标本内容
function LoadSpecItemList(){
	
	/// 初始化标本内容区域
	$("#itemPisSpec").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","JsonGetPisSpecList",{"HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitSpecItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 标本内容
function InitSpecItemRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		var MulFlag = itemArr[j-1].name.indexOf("Y") != "-1"?"Y":"N";
		var InputHtml = '<input type="text" class="name-input" id="Spec'+ itemArr[j-1].value +'" value="1" name="'+ MulFlag +'"></input>';
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text + InputHtml +'</td>');
		if (j % 4 == 0){
			itemhtmlstr = itemhtmlstr + '<tr style="height:40px;">' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 4 != 0){
		itemhtmlstr = itemhtmlstr + '<tr style="height:40px;">' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemPisSpec").append(htmlstr+itemhtmlstr)
}

/// 页面CheckBox控制
function InitPageCheckBox(){

	$("input[name^=PisSpec]").click(function(){
		
		if($("[value='"+this.id+"'][name^=PisSpec]").is(':checked')){
			/// 选中
			$("#Spec"+ this.id).show();
			//$("input[name=PisSpec]:not([value='"+this.id+"'])").removeAttr("checked");
			//$("[id^=Spec][id!='Spec"+this.id+"']").hide();
			if (this.name.indexOf("Y") == "-1"){
				$("input[name^=PisSpec]:not([value='"+this.value+"'])").removeAttr("checked");
				$("[id^=Spec][id!='Spec"+this.value+"']").hide();
			}else{
				$("input[name^=PisSpec]:not([value='"+this.value+"']):not([name$=Y])").removeAttr("checked");
				$("[id^=Spec][id!='Spec"+this.value+"']:not([name$='Y'])").hide();
			}
		}else{
			/// 取消
			$("#Spec"+ this.id).hide();
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
	var ApplyDocUser = $HUI.combobox("#ApplyDocUser").getValue();  /// 申请医生  qunianpeng 2018/2/5
	if ((asStaus=="I")&&(ApplyDocUser!=LgUserID)){ApplyDocUser=LgUserID}
	var ApplyLoc = $HUI.combobox("#ApplyLoc").getValue(); 		   /// 申请科室
	if(ApplyLoc==""){
		$.messager.alert("提示:","请先选择申请科室！");
		return;
	}
	if(ApplyDocUser==""){
		$.messager.alert("提示:","请先选择申请医生！");
		return;
	}
	
	var recLocID = $HUI.combobox("#recLoc").getValue();    /// 接收科室ID
	var EmgFlag = ""; //$HUI.checkbox("#EmgFlag").getValue() ? "Y":"N";     /// 加急
	var FrostFlag = ""; //$HUI.checkbox("#FrostFlag").getValue() ? "Y":"N"; /// 冰冻
	var FoundDate = $HUI.datebox("#FoundDate").getValue(); /// 首次发现人乳头瘤病毒时间
	if (FoundDate == ""){
		$.messager.alert("提示:","请填写首次发现人乳头瘤病毒时间！");
		return;
	}
	
	var TmpDateTime = $HUI.datetimebox("#SepDate").getValue(); /// 标本离体时间
	if (TmpDateTime == ""){
		$.messager.alert("提示:","请填写标本离体时间！");
		return;
	}
	if (TmpDateTime != ""){
		TmpSepDate=TmpDateTime.split(" ")[0]; TmpSepTime=TmpDateTime.split(" ")[1];
	}
	var mPisCutBas = TmpSepDate +"^"+ TmpSepTime + "^^^^";
	
	var PrevHis=$("#PrevHis").val();					   /// 既往手术史信息 add 18-7-3
	PrevHis =PrevHis.replace(/\&/g,"￠");				   /// 替换字符&  add 18-7-3  15位置
	if(($("#PrevHisFlag1").is(":checked")==false)&&($("#PrevHisFlag2").is(":checked")==false)){
		$.messager.alert("提示:","请勾选既往手术史信息！");
		return;	
	}
	if($("#PrevHisFlag1").is(":checked")){
		if(PrevHis==""){
			$.messager.alert("提示:","请填写既往手术史信息！");
			return;		
		}	
	}else{
		PrevHis="";
	}
	
	//var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ session['LOGON.USERID'] +"^"+ session['LOGON.CTLOCID'] +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ FoundDate +"^^^^^HPV";
	var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ FoundDate +"^^^^^HPV" +"^"+ Oeori+"^"+PrevHis;
	
	/// 检测方法
	var mPisTesItmMetArr=[]; var mPisTesItmMet="";
	var TesItmMetArr = $("input[name=TesItmMet]");
	for (var i=0; i < TesItmMetArr.length; i++){
	    if($("[value='"+TesItmMetArr[i].value+"'][name=TesItmMet]").is(':checked')){
			mPisTesItmMetArr.push(TesItmMetArr[i].value);
	    }
	}
	var mPisTesItmMet = mPisTesItmMetArr.join("@");

	/// 临床诊断
	var mPisTesDiagArr=[]; var mPisTesDiag="";
	var TesDiagArr = $("input[name=TesDiag]");
	for (var j=0; j < TesDiagArr.length; j++){
	    if($("[value='"+TesDiagArr[j].value+"'][name=TesDiag]").is(':checked')){
			mPisTesDiagArr.push(TesDiagArr[j].value);
	    }
	}
	var mPisTesDiag = mPisTesDiagArr.join("@");

	/// 治疗方式
	var mPisTreMetArr=[]; var mPisTreMet="";
	var TreMetArr = $("input[name=TreMet]");
	for (var n=0; n < TreMetArr.length; n++){
	    if($("[value='"+TreMetArr[n].value+"'][name=TreMet]").is(':checked')){
			mPisTreMetArr.push(TreMetArr[n].value);
	    }
	}
	var mPisTreMet = mPisTreMetArr.join("@");

	/// 病理标本
	var mPisPatSpec=""; PisPatSpecArr = [];
    var PatSpecArr = $("input[name^=PisSpec]");
    var i = 1;
    for (var j=0; j < PatSpecArr.length; j++){
	    if($("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").is(':checked')){
		    /// 标本名称
		    var PisSpecDesc = $("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").parent().next().text();
			var Qty = $("#Spec"+ PatSpecArr[j].value).val();
			PisPatSpecArr.push((i++) +"^"+ PatSpecArr[j].value +"^"+ PisSpecDesc +"^^"+ Qty);
	    }
	}
	var mPisPatSpec = PisPatSpecArr.join("@");
	if (mPisPatSpec == ""){
		$.messager.alert("提示:","标本内容不能为空！");
		return;
	}
	
	///             主信息  +"&"+  检测方法  +"&"+   临床诊断  +"&"+  治疗方式  +"&"+  病理标本 +"&"+  取材信息
	var mListData = mListData +"&"+ mPisTesItmMet +"&"+ mPisTesDiag +"&"+ mPisTreMet +"&"+ mPisPatSpec+"&"+ mPisCutBas;

	/// 保存
	runClassMethod("web.DHCAppPisMaster","Insert",{"PisType":"HPV", "PisID":PisID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","病理申请单保存失败，失败原因:"+jsonString);
		}else{
			PisID = jsonString;
			GetPisNoObj(PisID)
			$.messager.alert("提示:","保存成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		}
	},'json',false)
}

/// 发送病理申请
function SendPisNo(){
	
	var FoundDate = $HUI.datebox("#FoundDate").getValue(); /// 首次发现人乳头瘤病毒时间
	if (FoundDate == ""){
		$.messager.alert("提示:","请填写首次发现人乳头瘤病毒时间！");
		return;
	}
	
	/// 住院急诊留观押金控制
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$.messager.alert("提示:",PatArrManMsg);
		return;	
	}
	var BillTypeID = "";
	if (typeof window.parent.frames.BillTypeID != "undefined"){
		BillTypeID = window.parent.frames.BillTypeID;  ///费别ID
	}
	var InsurFlag=parent.$HUI.checkbox("#InsurFlag").getValue()?"Y":"N";
	/// 保存
	runClassMethod("web.DHCAppPisMaster","InsSendFlag",{"PisID":PisID,"UserID":session['LOGON.USERID'],"BillTypeID":BillTypeID,"InsurFlag":InsurFlag},function(jsonString){
		
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
	},'json',false)
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
	var FoundDate = $HUI.datebox("#FoundDate").getValue(); /// 首次发现人乳头瘤病毒时间
	if (FoundDate == ""){
		window.parent.frames.InvErrMsg("请填写【HPV病理申请】首次发现人乳头瘤病毒时间！");
		return false;
	}
	
	var TmpDateTime = $HUI.datetimebox("#SepDate").getValue(); /// 标本离体时间
	if (TmpDateTime == ""){
		$.messager.alert("提示:","请填写标本离体时间！");
		return;
	}
	if (TmpDateTime != ""){
		TmpSepDate=TmpDateTime.split(" ")[0]; TmpSepTime=TmpDateTime.split(" ")[1];
	}
	var mPisCutBas = TmpSepDate +"^"+ TmpSepTime + "^^^^";
	
	var PrevHis=$("#PrevHis").val();					   /// 既往手术史信息 add 18-7-3
	PrevHis =PrevHis.replace(/\&/g,"￠");				   /// 替换字符&  add 18-7-3  15位置
	if(($("#PrevHisFlag1").is(":checked")==false)&&($("#PrevHisFlag2").is(":checked")==false)){
		$.messager.alert("提示:","请勾选既往手术史信息！");
		return;	
	}
	if($("#PrevHisFlag1").is(":checked")){
		if(PrevHis==""){
			$.messager.alert("提示:","请填写既往手术史信息！");
			return;		
		}	
	}else{
		PrevHis="";
	}
	var mListData = "^^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ FoundDate +"^^^^^HPV" +"^"+ Oeori+"^"+PrevHis;
	
	/// 检测方法
	var mPisTesItmMetArr=[]; var mPisTesItmMet="";
	var TesItmMetArr = $("input[name=TesItmMet]");
	for (var i=0; i < TesItmMetArr.length; i++){
	    if($("[value='"+TesItmMetArr[i].value+"'][name=TesItmMet]").is(':checked')){
			mPisTesItmMetArr.push(TesItmMetArr[i].value);
	    }
	}
	var mPisTesItmMet = mPisTesItmMetArr.join("@");

	/// 临床诊断
	var mPisTesDiagArr=[]; var mPisTesDiag="";
	var TesDiagArr = $("input[name=TesDiag]");
	for (var j=0; j < TesDiagArr.length; j++){
	    if($("[value='"+TesDiagArr[j].value+"'][name=TesDiag]").is(':checked')){
			mPisTesDiagArr.push(TesDiagArr[j].value);
	    }
	}
	var mPisTesDiag = mPisTesDiagArr.join("@");

	/// 治疗方式
	var mPisTreMetArr=[]; var mPisTreMet="";
	var TreMetArr = $("input[name=TreMet]");
	for (var n=0; n < TreMetArr.length; n++){
	    if($("[value='"+TreMetArr[n].value+"'][name=TreMet]").is(':checked')){
			mPisTreMetArr.push(TreMetArr[n].value);
	    }
	}
	var mPisTreMet = mPisTreMetArr.join("@");

	/// 病理标本
	var mPisPatSpec=""; PisPatSpecArr = [];
    var PatSpecArr = $("input[name^=PisSpec]");
    var i = 1;
    for (var j=0; j < PatSpecArr.length; j++){
	    if($("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").is(':checked')){
		    /// 标本名称
		    var PisSpecDesc = $("[value='"+PatSpecArr[j].value+"'][name^=PisSpec]").parent().next().text();
			var Qty = $("#Spec"+ PatSpecArr[j].value).val();
			PisPatSpecArr.push((i++) +"^"+ PatSpecArr[j].value +"^"+ PisSpecDesc +"^^"+ Qty);
	    }
	}
	var mPisPatSpec = PisPatSpecArr.join("@");
	if (mPisPatSpec == ""){
		window.parent.frames.InvErrMsg("【HPV病理申请】标本内容不能为空！");
		return false;
	}
	
	///             主信息  +"&"+  检测方法  +"&"+   临床诊断  +"&"+  治疗方式  +"&"+  病理标本+"&"+  取材信息
	var mListData = mListData +"&"+ mPisTesItmMet +"&"+ mPisTesDiag +"&"+ mPisTreMet +"&"+ mPisPatSpec+"&"+ mPisCutBas;

	/// 保存
	runClassMethod("web.DHCAppPisMaster","InsertTempDoc",{"Pid":pid, "mListData":mListData, "mItemParam":mItemParam},function(jsonString){
		if (jsonString < 0){
			window.parent.frames.InvErrMsg("【HPV病理申请】保存失败，失败原因:"+jsonString);
			return false;
		}
	},'json',false)
		
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

	runClassMethod("web.DHCAppPisMasterQuery","JsonPisItemList",{"PisID":PisID, "Type":"HPV"},function(jsonString){

		if (jsonString != ""){
			var itemArr = jsonString;
			for (var j=0; j<itemArr.length; j++){
				if(itemArr[j].value!=""){
					$("[name^="+ itemArr[j].name +"][value="+ itemArr[j].value +"]").attr("checked",'true'); 
					if (itemArr[j].name == "PisSpec"){
						$("#Spec"+ itemArr[j].value).show().val(itemArr[j].Qty);
					}
				}
			}
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
	
	//$HUI.checkbox("#EmgFlag").setValue(itemobj.EmgFlag == "Y"? true:false);      /// 加急
	//$HUI.checkbox("#FrostFlag").setValue(itemobj.FrostFlag == "Y"? true:false);  /// 冰冻
	$HUI.datebox("#FoundDate").setValue(itemobj.FoundDate); /// 首次发现人乳头瘤病毒时间
	$HUI.datetimebox("#SepDate").setValue(itemobj.SepDate);        /// 取材日期
	
	$("#PrevHis").val(itemobj.PrevHis.replace(/\￠/g,"&")); 	/// 既往手术史 18-7-3
	if ((itemobj.PrevHis != "")){ 
		$("#PrevHisFlag1").prop("checked", true);
		$("#PrevContent").css("display","block");
	}	
	else{														/// qunianpeng 2018/8/28
		$("#PrevHisFlag2").prop("checked", true);
	}
	
	var SendPisFlag = itemobj.SendPisFlag;  /// 是否允许再次发送
	asStaus="";
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
	}else if (SendPisFlag == 3){
		$('a:contains("发送")').linkbutton('disable');
		$('a:contains("发送")').removeClass('btn-lightgreen');
		$('a:contains("取消申请")').linkbutton('enable');
		$('a:contains("取消申请")').addClass('btn-lightred');
		$('a:contains("保存")').linkbutton('enable');
		$('a:contains("打印")').linkbutton('disable');
		asStaus="I";
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
	$HUI.datebox("#FoundDate").disable();
	$('input[type="text"]').attr("disabled", true);
}

/// 是否允许填写申请单
function GetIsWritePisFlag(){
	
	runClassMethod("web.DHCAppPisMasterQuery","GetIsWritePisFlag",{"LgGroupID":session['LOGON.GROUPID'],"LgUserID":session['LOGON.USERID'],"LgLocID":session['LOGON.CTLOCID'],"EpisodeID":EpisodeID},function(jsonString){
		TakOrdMsg = jsonString;
		if(TakOrdMsg != ""){
			$.messager.alert("提示:",TakOrdMsg);
		}
	},'text',false)
}

/// 是否允许填写妇科TCT
function GetIsWriteFlagTCT(){
	
	runClassMethod("web.DHCAppPisMasterQuery","GetIsWriteFlagTCT",{"EpisodeID":EpisodeID},function(jsonString){
		isWriteFlagTCT = jsonString;
		if(isWriteFlagTCT != 0){
			$.messager.alert("提示:","只有成年女性才可填写HPV检查申请！");
		}
	},'json',false)
}


/// 医嘱ID部位空，根据医嘱ID加载申请单内容
function LoadPisNoByOeori(){
	
	if (Oeori == "") return;

	runClassMethod("web.DHCAPPPisInterface","GetPisNoByOeori",{"Oeori":Oeori},function(jsonObj){

		if (jsonObj != null){
			if (jsonObj.PisID != ""){
				PisID = jsonObj.PisID;  /// 加载申请单内容
			}else{
				$("#TesItemID").val(jsonObj.arcimid);            /// 项目ID
				$("#TesItemDesc").val(jsonObj.arcimDesc);        /// 项目描述
				$("#recLoc").combobox("setValue",jsonObj.rLocID);   /// 接收科室ID
				$("#recLoc").combobox("setText",jsonObj.rLocDesc);  /// 接收科室
			}
		}
	},'json',false)
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

/// HPV申请单打印
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
	MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+txtUtil(jsonObj.EmgFlag);       	/// 加急
	MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+txtUtil(jsonObj.FrostFlag);     /// 冰冻
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);  			/// 病理号
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);  		/// 申请单号
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);  		/// 检测项目
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisReqSpec,60));   /// 病理标本
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.MedRecord,60));     /// 临床病历
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisTesDiag,60));   /// 临床诊断
	MyPara = MyPara+"^FoundDate"+String.fromCharCode(2)+txtUtil(jsonObj.FoundDate);  	/// 首次发现人乳头瘤病毒时间
	MyPara = MyPara+"^PisTesItmMet"+String.fromCharCode(2)+txtUtil(jsonObj.PisTesItmMet);  /// 检测方法
	MyPara = MyPara+"^PisTreMet"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisTreMet,60));     /// 治疗方法
	MyPara = MyPara+"^SepDate"+String.fromCharCode(2)+txtUtil(jsonObj.SepDate);            /// 取材离体日期
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisHPV");
	
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
	},'json',false)
}

/// 打印条码
function PrintPisBar(flag){
	
	//window.parent.frames.PrintBar(PisID,flag);
	PrintBar(PisID,flag);
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

/// 申请单是否允许编辑
function InitReqEditFlag(ID){

	var LgParams = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","JsGetReqEditFlag",{"ID":ID, "Type":"P", "LgParams":LgParams},function(jsonString){
		if (jsonString != ""){
			PageBtEditFlag(jsonString);
		}
	},'json',false)
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
	},'text',false)

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
window.onbeforeunload = function(event) { 
	if (PisID != ""){
		var RtnFlag="1"
		runClassMethod("web.DHCAppPisMaster","InsCheckSend",{"Pid":PisID},function(jsonString){
			RtnFlag=jsonString;
		},'text',false)
		if (RtnFlag == "0"){
				return "还未发送申请单，是否离开此界面"
			}else{
				return;	
		}
	}else{ return;}
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })

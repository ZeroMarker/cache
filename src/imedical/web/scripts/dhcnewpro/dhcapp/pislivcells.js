//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-04
// 描述:	   活体组织病理申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var editSelRow = -1;    /// 当前编辑行
var PisID = "";         /// 病理申请ID
var Oeori = "";         /// 医嘱ID
var FixFlag = 0;
var TakOrdMsg = "";
var rowNo = 4; 			/// 标本序号
var pid = "";  			/// 唯一标识
var mListDataDoc = "";  /// 医生站界面参数内容
var DocMainFlag = "";   /// 医生站界面弹出标示
var OperFlag = 1;       /// 手术显示状态
var arEmgFlag = "";
var arFrostFlag = "";
var LgUserID = session['LOGON.USERID'];   /// 用户ID
var LgCtLocID = session['LOGON.CTLOCID']; /// 科室ID
var LgGroupID = session['LOGON.GROUPID']; /// 安全组ID
var LgHospID=session['LOGON.HOSPID'];
var isPageEditFlag = 1; /// 页面是否允许编辑

/// 页面初始化函数
function initPageDefault(){

	InitPageDataGrid();		  /// 初始化页面datagrid
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	LoadTestItemList();       /// 加载HPV病人病历内容
	//LoadCheckItemList();      /// 加载病理检查项目
	GetIsWritePisFlag();      /// 是否可填写判断
	GetPatBaseInfo();         /// 加载病人信息
	LoadPatClinicalRec();	  /// 加载临床病历
	InitPageCheckBox();       /// 页面CheckBox控制
	LoadPisNoByOeori();       /// 加载病理申请单信息
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
		LoadPisNoFlag();             /// 设置活体组织申请单加急或冰冻标志
		var PanelWidth = window.parent.frames.GetPanelWidth();
		/// 面板【申请信息】大小调整 
		$('#mPanel').panel('resize',{width: PanelWidth ,height: 100});
		/// 面板【综合信息】大小调整
		$('#sPanel').panel('resize',{width: PanelWidth ,height: 210});
		/// 面板【病人病历】大小调整
		$('#cPanel').panel('resize',{width: PanelWidth ,height: 520});
	}else{
		LoadCheckItemList();         /// 加载病理检查项目
	}
}

/// 重新设置datagrid大小
function resize(){

	$('#PisSpecList').datagrid('resize',{width: 800,height: 200 });
	//$('#PisSpecList').datagrid('resize',{ });
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	PisID = getParam("itemReqID");  /// 申请单ID
	Oeori = getParam("Oeori");         /// 医嘱ID
	if (Oeori != ""){
		$('#mPanel').panel({closed:true}); /// 隐藏【妇科TCT申请信息】
		$('a:contains("发送")').hide();
	}
	
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
	
		/// 手术医生	// add 2018/8/29 qunianpeng

	$('#OperUser').combobox({
		//mode:'remote',
		blurValidValue:true,		
		onShowPanel:function(){		
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+'';
			$("#OperUser").combobox('reload',unitUrl);
		}
	});
	
	/// 接收科室
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
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
	
	/// 肿瘤发现日期
	$('#FoundDate').datebox({
		onSelect:function(date){
			var PisDate = "";
			if (PisID != ""){
				PisDate = GetPisNoSysTime();
			}
			PisDate = new Date(PisDate.replace(/\-/g, "\/"));  
			if (date > PisDate){
				$.messager.alert("提示:","肿瘤发现不能晚于申请日期！");
				$('#FoundDate').datebox('setValue',"");
				return;
			}
		}
	})
	
	/// 肿瘤发现日期控制
	$('#FoundDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// 上次月经日期控制
	$('#LastMensDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// 末次月经日期控制
	$('#MensDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// 上次月经日期控制
	$('#LastMensDate').datebox({
		onSelect: function(date){
			var MensDate = $HUI.datebox("#MensDate").getValue(); /// 末次月经
			if (MensDate != ""){
				var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// 上次月经
				if (isCompare(LastMensDate, MensDate) == 1){
					$.messager.alert("提示:","【上次月经日期】不能大于等于【末次月经日期】！");
					$('#LastMensDate').datebox('setValue',"");
					return;
				}
			}else{
				$HUI.checkbox("#PauFlag").setValue(false);  /// 绝经
			}
			return true;
		}
	});
	
	/// 末次月经日期控制
	$('#MensDate').datebox({
		onSelect: function(date){
			var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// 上次月经
			if (LastMensDate != ""){
				//var LastMensDate = new Date(LastMensDate.replace(/\-/g, "\/"));
				var MensDate = $HUI.datebox("#MensDate").getValue(); /// 末次月经
				if (isCompare(LastMensDate, MensDate) != 0){
					$.messager.alert("提示:","【末次月经日期】不能小于等于【上次月经日期】！");
					$('#MensDate').datebox('setValue',"");
					return;
				}
			}else{
				$HUI.checkbox("#PauFlag").setValue(false);  /// 绝经
			}
			return true;
		}
	});
		
	/// 胎数
	$("#PreTimes").keyup(function(){
	    var PreTimes = $("#PreTimes").val();  /// 胎数
	    var LyTimes = $("#LyTimes").val();    /// 产数
	    if ((LyTimes != "")&(PreTimes < LyTimes)){
		    $.messager.alert("提示:","胎数必须大于等于产数！");
			$("#PreTimes").val("");
		}
	});
	
	/// 产数
	$("#LyTimes").keyup(function(){
	    var PreTimes = $("#PreTimes").val();  /// 胎数
	    var LyTimes = $("#LyTimes").val();    /// 产数
	    if ((LyTimes != "")&(PreTimes < LyTimes)){
		    $.messager.alert("提示:","胎数必须大于等于产数！");
			$("#LyTimes").val("");
		}
	});
	
	/// 标本离体时间控制
	$('#SepDate').datetimebox({
		onHidePanel:function (){
			var SepDate = $HUI.datetimebox("#SepDate").getValue(); /// 离体时间
			var FixDate = $HUI.datetimebox("#FixDate").getValue(); /// 固定时间
			if(SepDate!=""){
				var SepDate=parseDateTime(SepDate);
				$HUI.datetimebox("#SepDate").setValue(SepDate.Format("yyyy-MM-dd hh:mm"))
			}
			if (FixDate != ""){
				var FixDate=parseDateTime(FixDate)
				//var FixDate = new Date(FixDate.replace(/\-/g, "\/"));
				//var SepDate = new Date(SepDate.replace(/\-/g, "\/"));
				if (SepDate >= FixDate){
					$.messager.alert("提示:","标本固定时间不能早于标本离体时间！");
					$('#SepDate').datetimebox('setValue',"");
					return;
				}
			}
			return true;    
		}
	});
	
	/// 标本固定时间控制
	$('#FixDate').datetimebox({
		onHidePanel:function (){
			var SepDate = $HUI.datetimebox("#SepDate").getValue(); /// 离体时间
			var FixDate = $HUI.datetimebox("#FixDate").getValue(); /// 固定时间
			if(FixDate!=""){
				var FixDate=parseDateTime(FixDate);
				$HUI.datetimebox("#FixDate").setValue(FixDate.Format("yyyy-MM-dd hh:mm"))
			}
			if (SepDate != ""){
				var SepDate=parseDateTime(SepDate)
				//var SepDate = new Date(SepDate.replace(/\-/g, "\/"));
				//var FixDate = new Date(FixDate.replace(/\-/g, "\/"));
				if (FixDate < SepDate){
					$.messager.alert("提示:","标本固定时间不能早于标本离体时间！");
					$HUI.datetimebox("#FixDate").setValue("");
					return;
				}
			}
			return true;
		}
	});
	
	/// 标本离体时间控制
	$('#SepDate').datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// 标本固定时间控制
	$('#FixDate').datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	/// 妇科信息
	$("#WomenCk").bind("click", WomenCk_OnClick);
	
	/// 肿瘤信息
	$("#TumorCk").bind("click", TumorCk_OnClick);
	
	/// 取材科室 
	$('#LocID').combobox({	//取材科室和取材医生可以选择 2018/2/2 qunianpeng 
		mode:'remote',  
		url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID,
		blurValidValue:true,
		onShowPanel:function(){
			// var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID;
			// $("#LocID").combobox('reload',unitUrl);
		},
		onSelect:function(){	//设置级联 选择科室后，加载可以登录该科室的医生 qunianpeng 2018/2/7
			$("#DocDr").combobox("setValue","");
			$("#DocDr").combobox('reload');
		}
	});
	/// 取材医生 
	$('#DocDr').combobox({
		//mode:'remote',
		blurValidValue:true,		
		onShowPanel:function(){
			var bLocID=$('#LocID').combobox('getValue');			
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+bLocID;
			$("#DocDr").combobox('reload',unitUrl);
		}
	});	
			
	/// 申请科室 
	$('#ApplyLoc').combobox({	//申请科室和申请医生可以选择(默认就诊医生和科室) 2018/2/5 qunianpeng
		url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID,
		mode:'remote',	
		//blurValidValue:true,		
		onShowPanel:function(){
			//var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&hospId="+LgHospID;
			//$("#ApplyLoc").combobox('reload',unitUrl);
		},
		onSelect:function(){	//设置级联 选择科室后，加载可以登录该科室的医生 qunianpeng 2018/2/7
			$("#ApplyDocUser").combobox("setValue","");
			$("#ApplyDocUser").combobox('reload');
		}
	});
	
	/// 申请医生  
	$('#ApplyDocUser').combobox({
		//mode:'remote', 
		blurValidValue:true,		
		onShowPanel:function(){
			var appLocID=$('#ApplyLoc').combobox('getValue');
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+appLocID;
			$("#ApplyDocUser").combobox('reload',unitUrl);
		}
	});	
	
	if (OperFlag == 1){
		$("#OperCon").hide();   /// 隐藏手术信息
	}
	/// 界面按钮状态
	$('a:contains("取消申请")').linkbutton('disable');
	$('a:contains("取消申请")').removeClass('btn-lightred');
	$('a:contains("发送")').linkbutton('disable');
	$('a:contains("发送")').removeClass('btn-lightgreen');
	$('a:contains("打印")').linkbutton('disable');
}
function parseDateTime(dateStr){
	var regexDT = /(\d{4})-?(\d{2})?-?(\d{2})?\s?(\d{2})?:?(\d{2})?:?(\d{2})?/g;
    var matchs = regexDT.exec(dateStr);
    if(matchs==null){
		return new Date();    
	}
    var date = new Array();
    for (var i = 1; i < matchs.length; i++) {
        if (matchs[i]!=undefined) {
            date[i] = matchs[i];
        } else {
            if (i<=3) {
                date[i] = '01';
            } else {
                date[i] = '00';
            }
        }
    }
	return new Date(date[1], date[2]-1, date[3], date[4], date[5],date[6]);

    
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
		
		SetPisEmgflag(itmmastid);  /// 设置加急标志
		SetPisFrostflag(itmmastid);  /// 设置冰冻标志
	}
}

/// 加载检查方法列表
function LoadCheckItemList(){
	
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCode",{"Code":"LIV"},function(jsonString){

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

/// 加载病人传染病史内容
function LoadTestItemList(){
	
	/// 初始化检查方法区域
	$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","JsonPatInfDisList",{"HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsTesItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 病人传染病史内容
function InsTesItemRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		var InputHtml = "";
		if (itemArr[j-1].text == "其他"){
		   InputHtml = '<input type="text" class="name-input-80" id="Test'+ itemArr[j-1].value +'"></input>';
		}
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text + InputHtml +'</td>');
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

/// 页面DataGrid初始定义已选列表
function InitPageDataGrid(){
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	/// 数字编辑格
	var numberboxeditor={
		type: 'numberbox',//设置编辑格式
		options: {
			//required: true //设置编辑规则属性
		}
	}
	
	var TitLnk = '<a href="#" onclick="insRow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';
	///  定义columns
	var columns=[[
		{field:'No',title:'标本序号',width:120,align:'center'},
		//{field:'ID',title:'标本标识',width:120,editor:texteditor},
		{field:'Name',title:'标本名称',width:300,editor:texteditor},
		//{field:'Part',title:'标本部位',width:200,editor:texteditor},
		{field:'Qty',title:'标本数量',width:100,editor:numberboxeditor},
		{field:'Remark',title:'取材部位',width:280,editor:texteditor},
		{field:'operation',title:TitLnk,width:40,align:'center',
			formatter:SetCellUrl}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumn:false,
		headerCls:'panel-header-gray',
		rownumbers : false,
		singleSelect : true,
		pagination: false,		
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (isPageEditFlag == 0) return;
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#PisSpecList").datagrid('endEdit', editSelRow); 
            } 
            $("#PisSpecList").datagrid('beginEdit', rowIndex); 

            editSelRow = rowIndex; 
        }
	};
	/// 就诊类型
	var uniturl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=JsonQryPisSpec&PisID="+PisID;
	new ListComponent('PisSpecList', columns, uniturl, option).Init();
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	return "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

/// 删除行
function delRow(rowIndex){
	
	if (isPageEditFlag == 0) return;
	var rows = $('#PisSpecList').datagrid('getRows');
	//删除前结束所有的编辑行
	$.each(rows,function(index,data){
		 if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#PisSpecList").datagrid('endEdit', editSelRow); 
            }
	});

	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
		
	if(rows.length>4){
		 $('#PisSpecList').datagrid('deleteRow',rowIndex);
		 rowNo -= 1;
	}else{
		$('#PisSpecList').datagrid('deleteRow',rowIndex);  //小于4时,删除该行后,在新增一个空行 qunianepng 2018/1/29
		 rowNo -= 1;
		 /// 行对象
		 var rowObj = {"No":rowNo+1,"Name":"","Explain":"","Part":"","Qty":"","Remark":"","SliType":"","PisNo":""};
		$("#PisSpecList").datagrid('appendRow',rowObj);
		//$('#PisSpecList').datagrid('updateRow',{index:rowNo, row:rowObj});		
	}
	
	// 删除后,重新排序
	//$('#PisSpecList').datagrid('sort', {sortName: 'No',sortOrder: 'asc'});
	//删除后,根据标本序号重新排序,并重新编号
	sortTable();
}

/// 插入空行
function insRow(){
	
	if (isPageEditFlag == 0) return;
	//var rowObj={No:rowNo, ID:'', Name:'', Part:'', Qty:''};
	rowNo += 1;
	var rowObj = {"No":rowNo,"Name":"","Explain":"","Part":"","Qty":"","Remark":"","SliType":"","PisNo":""};
	$("#PisSpecList").datagrid('appendRow',rowObj);
	
}

/// 页面CheckBox控制
function InitPageCheckBox(){
	
	$("input[name=TestItem]").click(function(){
		if ($(this).parent().next().text() == "其他"){
			if($("[value='"+this.id+"'][name=TestItem]").is(':checked')){
				/// 选中
				$("#Test"+ this.id).show();
			}else{
				/// 取消
				$("#Test"+ this.id).hide();
			}
		}
	
		/// 选择无时，进行设置
		if ($(this).parent().next().text() == "无"){
			if($("[value='"+this.id+"'][name=TestItem]").is(':checked')){
				$("input[name=TestItem][value!='"+this.id+"']").removeAttr("checked");
				/// 取消
				$("[id^='Test']").hide();
			}
		}else{
			$("input[name=TestItem]").each(function(){
				if ($(this).parent().next().text() == "无"){
					$("input[name=TestItem][value='"+this.id+"']").removeAttr("checked");
				}
			});
		}
	});
	
	//肿瘤信息选择后在显示详细信息 qunianpeng 2018/1/19	
	$("#TumorCk").nextAll().css("display","none");	
	$("#TumorCk").click(function(){
		if($("#TumorCk").is(':checked')){
			$("#TumorCk").nextAll().css("display","block");
		}else{
			$("#TumorCk").nextAll().css("display","none");
		}
	});
	///控制医嘱项单选  sufan 2018-01-30
	var tempckid="";
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
function checkCombox(){
        var ven=$('#ApplyLoc').combobox('getValue');
		var _data = $('#ApplyLoc').combobox('getData');/* 下拉框所有选项 */
		var _b = false;/* 标识是否在下拉列表中找到了用户输入的字符 */
		for (var i = 0; i < _data.length; i++) {
			
			if (_data[i].value == ven) {
				_b=true;
				break;
			}
		}
		if(!_b){
            $.messager.alert("提示:","申请科室选择错误！");
		}
		return _b;
		
}
/// 保存病理申请
function SavePisNo(){
	
    if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#PisSpecList").datagrid('endEdit', editSelRow); 
    }
    
    /*
    /// 医生站弹出界面时调用
	if (DocMainFlag == 1){
		InsertDoc();
		return;
	}
	*/
	if(!checkCombox()){return;}
	var itmmastid = $("#TesItemID").val();  			   /// 医嘱项ID
	if (itmmastid == ""){
		$.messager.alert("提示:","请先选择病理检查项目！");
		return;
	}
	var recLocID = $HUI.combobox("#recLoc").getValue();    /// 接收科室ID
	var ApplyDocUser = $HUI.combobox("#ApplyDocUser").getValue();    /// 申请医生  qunianpeng 2018/2/5
	var ApplyLoc = $HUI.combobox("#ApplyLoc").getValue(); 			 /// 申请科室
	var EmgFlag= $HUI.checkbox("#EmgFlag").getValue() ? "Y":"N";     /// 加急
	var FrostFlag= $HUI.checkbox("#FrostFlag").getValue() ? "Y":"N"; /// 冰冻
	var MedRecord =  $("#MedRecord").val(); 			   /// 病人病历
	MedRecord = MedRecord.replace(/\&/g,"￠");			   /// 替换字符&  qunianpeng 2018/3/13
	var OperRes =  $("#OperRes").val(); 			       /// 手术所见
	OperRes = OperRes.replace(/\&/g,"￠");				   /// 替换字符&  qunianpeng 2018/3/13
	var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ "" +"^"+ MedRecord +"^^^"+ OperRes +"^LIV" +"^"+ Oeori;
	
	/// 妇科信息
	var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// 上次月经
	var MensDate = $HUI.datebox("#MensDate").getValue();   		 /// 末次月经
	var PreTimes =  $("#PreTimes").val(); 			       		 /// 胎
	var LyTimes =  $("#LyTimes").val(); 			       		 /// 产
	var PauFlag= $HUI.checkbox("#PauFlag").getValue() ? "Y":"N"; /// 绝经
	var mPisGynWon = LastMensDate +"^"+ MensDate +"^"+ PreTimes +"^"+ LyTimes +"^"+ PauFlag;
	if ($("#WomenCk").is(":checked")){
		if ((LastMensDate == "")&(PauFlag == "N")){
			$.messager.alert("提示:","请填写上次月经日期！");
			return;		
		}
		if ((MensDate == "")&(PauFlag == "N")){
			$.messager.alert("提示:","请填写末次月经日期！");
			return;		
		}
	}
	
	/// 取材信息
	var TmpSepDate=""; var TmpSepTime=""; 
	var TmpDateTime = $HUI.datebox("#SepDate").getValue();   /// 标本离体日期

	
	if (TmpDateTime != ""){
		TmpSepDate=TmpDateTime.split(" ")[0]; TmpSepTime=TmpDateTime.split(" ")[1];
	}
	
	var TmpFixDate=""; var TmpFixTime=""; 
	var TmpFixTime = $HUI.datebox("#FixDate").getValue();   /// 标本固定日期

	if (TmpFixTime != ""){
		TmpFixDate=TmpFixTime.split(" ")[0]; TmpFixTime=TmpFixTime.split(" ")[1];
	}

	
	var CbLocDesc =  $HUI.combobox("#LocID").getValue(); 	   /// 取材科室  qunianpeng 2018/2/2
	var CbDocName =  $HUI.combobox("#DocDr").getValue(); 	   /// 取材医生
	var mPisCutBas = TmpSepDate +"^"+ TmpSepTime + "^" + TmpFixDate +"^"+ TmpFixTime +"^"+ CbLocDesc +"^"+ CbDocName;
	
	/// 手术信息
	var arOperDate=""; var arOperTime=""; 
	var TmpOperTime = $HUI.datebox("#OperTime").getValue(); /// 手术时间
	if (TmpOperTime != ""){
		arOperDate=TmpOperTime.split(" ")[0]; arOperTime=TmpOperTime.split(" ")[1];
	}
	var arOperName =  $("#OperName").val(); 	/// 手术名称
	var arOperPart =  $("#OperPart").val(); 	/// 手术部位
	//var arOperUser =  $("#OperUser").val(); 	/// 手术医生
	var arOperUser =  $HUI.combobox("#OperUser").getValue(); 	/// 手术医生 qunianpeng 2018/8/29
	var arOperUTel =  $("#OperTele").val(); 	/// 联系电话
	var arOperRoom =  $("#OperRoom").val(); 	/// 手术室/间
	var arOperAim = $("#OperAim").val();		/// 送检目的	/// qunianpeng 2018/9/3
	var arOperWay = $("#OperWay").val();		/// 手术方式    /// qunianpeng 2018/9/3
	mPisCutBas = mPisCutBas +"^^^"+ arOperName +"^"+ arOperPart +"^"+ arOperDate +"^"+ arOperTime +"^"+ arOperUser +"^"+ arOperUTel +"^"+ arOperRoom+"^"+arOperAim +"^"+arOperWay;

	/// 肿瘤信息
	var FoundDate = $HUI.datebox("#FoundDate").getValue(); /// 发现日期
	var TumPart =  $("#TumPart").val(); 			       /// 原发部位
	var TumSize =  $("#TumSize").val(); 			       /// 肿瘤大小
	var TransPos =  $("#TransPos").val(); 			       /// 转移部位
	var Remark =  $("#Remark").val(); 			           /// 备注
	var TransFlag = $HUI.checkbox("#TransFlag").getValue() ? "Y":"N";     /// 转移
	var RadCureFlag = $HUI.checkbox("#RadCureFlag").getValue() ? "Y":"N"; /// 放疗
	var CheCureFlag = $HUI.checkbox("#CheCureFlag").getValue() ? "Y":"N"; /// 化疗
	var mPisTumour = FoundDate +"^"+ TumPart +"^"+ TumSize +"^"+ TransFlag +"^"+ TransPos +"^"+ RadCureFlag +"^"+ CheCureFlag +"^"+ Remark;
	if ($("#TumorCk").is(":checked")){
		if (FoundDate == ""){
			$.messager.alert("提示:","请填写肿瘤发现日期！");
			return;		
		}
		if (TumPart == ""){
			$.messager.alert("提示:","请填写原发部位！");
			return;		
		}
		if (TumSize == ""){
			$.messager.alert("提示:","请填写肿瘤大小！");
			return;		
		}
		if ((TransFlag == "Y")&(TransPos == "")){
			$.messager.alert("提示:","请填写转移部位！");
			return;		
		}
	}
	
	/// 传染病史
	var mPisTestItem=""; mPisTesItmArr = []; mPisTesFlag = 0;
    var PisTesItmArr = $("input[name=TestItem]");
    for (var j=0; j < PisTesItmArr.length; j++){
	    if($('#'+PisTesItmArr[j].id).is(':checked')){
		    /// 其他项目判断
		    var TestItem = "";
		    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
				TestItem = $("#Test"+ PisTesItmArr[j].id).val();
				if (TestItem == "") {mPisTesFlag=1; break;}
			}
			
			mPisTesItmArr.push(PisTesItmArr[j].value +"^"+ TestItem);
	    }
	}
	if (mPisTesFlag == 1){
		$.messager.alert("提示:","传染病信息，勾选其他后必须填写其他内容！");
		return;	
	}
	var mPisTestItem = mPisTesItmArr.join("@");
	if (mPisTestItem == ""){
		$.messager.alert("提示:","传染病信息，可选择无但不能为空！");
		return;	
	}

	/// 病理标本
	var PisSpecArr=[];
	var rowDatas = $('#PisSpecList').datagrid('getRows');
	$.each(rowDatas, function(index, item){
		if(trim(item.Name) != ""){
		    var TmpData = item.No +"^"+ item.ID +"^"+ item.Name +"^"+ item.Part +"^"+ item.Qty +"^^^"+ item.Remark;
		    PisSpecArr.push(TmpData);
		}
	})	
	var PisSpecList = PisSpecArr.join("@");
	if (PisSpecList == ""){
		$.messager.alert("提示:","标本内容不能为空！");
		return;	
	}
	
	if (FrostFlag == "N"){	/// 冰冻未勾选时,标本时间不能空 qunianpeng 2018/9/3
		if (TmpSepTime=="") 
		{
			$.messager.alert("提示:","请填写标本离体日期！");
			$("#SepDate").val("");
			return false;    ////最好加光标定位;
			}
			
		if (TmpFixTime=="") 
		{
			$.messager.alert("提示:","请填写标本固定日期！");
			$("#FixDate").val("");
			return false;
		}
	}
	///             主信息  +"&"+  妇科信息  +"&"+   取材信息  +"&"+  传染病史  +"&"+  肿瘤信息  +"&"+  病理标本
	var mListData = mListData +"&"+ mPisGynWon +"&"+ mPisCutBas +"&"+ mPisTestItem +"&"+ mPisTumour +"&"+ PisSpecList;
	
	/// 保存
	runClassMethod("web.DHCAppPisMaster","Insert",{"PisType":"LIV", "PisID":PisID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","病理申请单保存失败，失败原因:"+jsonString);
		}else{
			PisID = jsonString;
			GetPisNoObj(PisID)
			$.messager.alert("提示:","保存成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		}
	},'',false)
}

/// 发送病理申请
function SendPisNo(){
	
	var TmpFixTime = $HUI.datebox("#FixDate").getValue();   /// 标本固定日期
	if(TmpFixTime==""){
			$.messager.alert("提示:","请填写标本固定日期！");
			return;	
	}
	
	var TmpDateTime = $HUI.datebox("#SepDate").getValue();   /// 标本离体日期
	if(TmpDateTime==""){
			$.messager.alert("提示:","请填写标本离体日期！");
			return;	
	}
	
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
	
	if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#PisSpecList").datagrid('endEdit', editSelRow); 
    }
    
	/// 医嘱项串
	var mItemParam = mListDataDoc.split("!")[1];
	if (mItemParam == "") return false;

	var ApplyDocUser = session['LOGON.USERID'];    /// 申请医生
	var ApplyLoc = session['LOGON.CTLOCID']; 	   /// 申请科室
	var EmgFlag= arEmgFlag;     /// 加急
	var FrostFlag= arFrostFlag; /// 冰冻
	var MedRecord =  $("#MedRecord").val(); 			   /// 病人病历
	MedRecord = MedRecord.replace(/\&/g,"￠");			   /// 替换字符&  qunianpeng 2018/3/13
	var OperRes =  $("#OperRes").val(); 			       /// 手术所见
	OperRes = OperRes.replace(/\&/g,"￠");				   /// 替换字符&  qunianpeng 2018/3/13
	var mListData = "^^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^"+ "" +"^"+ MedRecord +"^^^"+ OperRes +"^LIV" +"^";
	
	/// 妇科信息
	var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// 上次月经
	var MensDate = $HUI.datebox("#MensDate").getValue();   		 /// 末次月经
	var PreTimes =  $("#PreTimes").val(); 			       		 /// 胎
	var LyTimes =  $("#LyTimes").val(); 			       		 /// 产
	var PauFlag= $HUI.checkbox("#PauFlag").getValue() ? "Y":"N"; /// 绝经
	var mPisGynWon = LastMensDate +"^"+ MensDate +"^"+ PreTimes +"^"+ LyTimes +"^"+ PauFlag;
	if ($("#WomenCk").is(":checked")){
		if ((LastMensDate == "")&(PauFlag == "N")){
			window.parent.frames.InvErrMsg("【活体组织申请】请填写上次月经日期！");
			return false;		
		}
		if ((MensDate == "")&(PauFlag == "N")){
			window.parent.frames.InvErrMsg("【活体组织申请】请填写末次月经日期！");
			return false;		
		}
	}
	
	/// 取材信息
	var TmpSepDate=""; var TmpSepTime=""; 
	var TmpDateTime = $HUI.datebox("#SepDate").getValue();   /// 标本离体日期

	if (TmpDateTime != ""){
		TmpSepDate=TmpDateTime.split(" ")[0]; TmpSepTime=TmpDateTime.split(" ")[1];
	}
	var TmpFixDate=""; var TmpFixTime=""; 
	var TmpFixTime = $HUI.datebox("#FixDate").getValue();   /// 标本固定日期

	if (TmpFixTime != ""){
		TmpFixDate=TmpFixTime.split(" ")[0]; TmpFixTime=TmpFixTime.split(" ")[1];
	}

	var CbLocDesc =  $HUI.combobox("#LocID").getValue(); 	   /// 取材科室  qunianpeng 2018/2/2
	var CbDocName =  $HUI.combobox("#DocDr").getValue(); 	   /// 取材医生
	var mPisCutBas = TmpSepDate +"^"+ TmpSepTime + "^" + TmpFixDate +"^"+ TmpFixTime +"^"+ CbLocDesc +"^"+ CbDocName;
	
	/// 手术信息
	var arOperDate=""; var arOperTime=""; 
	var TmpOperTime = $HUI.datebox("#OperTime").getValue(); /// 手术时间
	if (TmpOperTime != ""){
		arOperDate=TmpOperTime.split(" ")[0]; arOperTime=TmpOperTime.split(" ")[1];
	}
	var arOperName =  $("#OperName").val(); 	/// 手术名称
	var arOperPart =  $("#OperPart").val(); 	/// 手术部位
	//var arOperUser =  $("#OperUser").val(); 	/// 手术医生
	var arOperUser =  $HUI.combobox("#OperUser").getValue(); 	/// 手术医生 qunianpeng 2018/8/29
	var arOperUTel =  $("#OperTele").val(); 	/// 联系电话
	var arOperRoom =  $("#OperRoom").val(); 	/// 手术室/间
	var arOperAim = $("#OperAim").val();		/// 送检目的	/// qunianpeng 2018/9/3
	var arOperWay = $("#OperWay").val();		/// 手术方式    /// qunianpeng 2018/9/3
	
	mPisCutBas = mPisCutBas +"^^^"+ arOperName +"^"+ arOperPart +"^"+ arOperDate +"^"+ arOperTime +"^"+ arOperUser +"^"+ arOperUTel +"^"+ arOperRoom+"^"+arOperAim +"^"+arOperWay;

	/// 肿瘤信息
	var FoundDate = $HUI.datebox("#FoundDate").getValue(); /// 发现日期
	var TumPart =  $("#TumPart").val(); 			       /// 原发部位
	var TumSize =  $("#TumSize").val(); 			       /// 肿瘤大小
	var TransPos =  $("#TransPos").val(); 			       /// 转移部位
	var Remark =  $("#Remark").val(); 			           /// 备注
	var TransFlag = $HUI.checkbox("#TransFlag").getValue() ? "Y":"N";     /// 转移
	var RadCureFlag = $HUI.checkbox("#RadCureFlag").getValue() ? "Y":"N"; /// 放疗
	var CheCureFlag = $HUI.checkbox("#CheCureFlag").getValue() ? "Y":"N"; /// 化疗
	var mPisTumour = FoundDate +"^"+ TumPart +"^"+ TumSize +"^"+ TransFlag +"^"+ TransPos +"^"+ RadCureFlag +"^"+ CheCureFlag +"^"+ Remark;
	if ($("#TumorCk").is(":checked")){
		if (FoundDate == ""){
			window.parent.frames.InvErrMsg("【活体组织申请】请填写肿瘤发现日期！");
			return false;		
		}
		if (TumPart == ""){
			window.parent.frames.InvErrMsg("【活体组织申请】请填写原发部位！");
			return false;		
		}
		if (TumSize == ""){
			window.parent.frames.InvErrMsg("【活体组织申请】请填写肿瘤大小！");
			return false;		
		}
		if ((TransFlag == "Y")&(TransPos == "")){
			window.parent.frames.InvErrMsg("【活体组织申请】请填写转移部位！");
			return false;		
		}
	}
	
	/// 传染病史
	var mPisTestItem=""; mPisTesItmArr = []; mPisTesFlag = 0;
    var PisTesItmArr = $("input[name=TestItem]");
    for (var j=0; j < PisTesItmArr.length; j++){
	    if($('#'+PisTesItmArr[j].id).is(':checked')){
		    /// 其他项目判断
		    var TestItem = "";
		    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
				TestItem = $("#Test"+ PisTesItmArr[j].id).val();
				if (TestItem == "") {mPisTesFlag=1; break;}
			}
			
			mPisTesItmArr.push(PisTesItmArr[j].value +"^"+ TestItem);
	    }
	}
	if (mPisTesFlag == 1){
		window.parent.frames.InvErrMsg("【活体组织申请】传染病信息，勾选其他后必须填写其他内容！");
		return false;	
	}
	var mPisTestItem = mPisTesItmArr.join("@");
	if (mPisTestItem == ""){
		window.parent.frames.InvErrMsg("【活体组织申请】传染病信息，可选择无但不能为空！");
		return false;	
	}

	/// 病理标本
	var PisSpecArr=[];
	var rowDatas = $('#PisSpecList').datagrid('getRows');
	$.each(rowDatas, function(index, item){
		if(trim(item.Name) != ""){
		    var TmpData = item.No +"^"+ item.ID +"^"+ item.Name +"^"+ item.Part +"^"+ item.Qty +"^^^"+ item.Remark;
		    PisSpecArr.push(TmpData);
		}
	})	
	var PisSpecList = PisSpecArr.join("@");
	if (PisSpecList == ""){
		window.parent.frames.InvErrMsg("【活体组织申请】标本内容不能为空！");
		return false;	
	}
	if (FrostFlag == "N"){	/// 冰冻未勾选时,标本时间不能空 qunianpeng 2018/9/3
		if (TmpSepTime=="") 
		{
			$.messager.alert("提示:","请填写标本离体日期！");
			$("#SepDate").val("");
			return false;    ////最好加光标定位;
			}
			
		if (TmpFixTime=="") 
		{
			$.messager.alert("提示:","请填写标本固定日期！");
			$("#FixDate").val("");
			return false;
		}
	}
	///             主信息  +"&"+  妇科信息  +"&"+   取材信息  +"&"+  传染病史  +"&"+  肿瘤信息  +"&"+  病理标本
	var mListData = mListData +"&"+ mPisGynWon +"&"+ mPisCutBas +"&"+ mPisTestItem +"&"+ mPisTumour +"&"+ PisSpecList;
	/// 保存
	runClassMethod("web.DHCAppPisMaster","InsertTempDoc",{"Pid":pid, "mListData":mListData, "mItemParam":mItemParam},function(jsonString){
		if (jsonString < 0){
			window.parent.frames.InvErrMsg("【活体组织申请】保存失败，失败原因:"+jsonString);
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

	runClassMethod("web.DHCAppPisMasterQuery","JsonPisItemList",{"PisID":PisID, "Type":"LIV"},function(jsonString){

		if (jsonString != ""){
			var itemArr = jsonString;
			for (var j=0; j<itemArr.length; j++){
				$("[name="+ itemArr[j].name +"][value="+ itemArr[j].value +"]").attr("checked",'true'); 
				if (itemArr[j].text != ""){
					$("#Test"+ itemArr[j].value).show().val(itemArr[j].text);
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
	$HUI.checkbox("#EmgFlag").setValue(itemobj.EmgFlag == "Y"? true:false);      /// 加急
	$HUI.checkbox("#FrostFlag").setValue(itemobj.FrostFlag == "Y"? true:false);  /// 冰冻
	$("#MedRecord").val(itemobj.MedRecord); 	   		       /// 病人病历
	$("#OperRes").val(itemobj.OperRes); 	   	     	       /// 手术所见
	$("#MedRecord").val(itemobj.MedRecord.replace(/\￠/g,"&")); /// 病人病历（存储前将&替换，加载时替换回来  qunianpeng 2018/3/13）
	$("#OperRes").val(itemobj.OperRes.replace(/\￠/g,"&")); 	/// 手术所见	
	$HUI.datebox("#LastMensDate").setValue(itemobj.LastMensDate); /// 上次月经
	$HUI.datebox("#MensDate").setValue(itemobj.MensDate);      /// 末次月经
	$("#PreTimes").val(itemobj.PreTimes); 	   		           /// 胎
	$("#LyTimes").val(itemobj.LyTimes); 	   		           /// 产
	$HUI.checkbox("#PauFlag").setValue(itemobj.PauFlag == "Y"? true:false);  /// 绝经
	$HUI.datetimebox("#SepDate").setValue(itemobj.SepDate);        /// 标本离体
	$HUI.datetimebox("#FixDate").setValue(itemobj.FixDate);        /// 标本固定	
	//$("#LocID").val(itemobj.BLocDesc); 	   		               /// 取材科室
	//$("#DocDr").val(itemobj.DocName); 	   		               /// 取材医生
	$HUI.combobox("#LocID").setValue(itemobj.BLocID);			   /// 取材科室和医生改为下拉框 qunianpeng 2018/2/2
	$HUI.combobox("#LocID").setText(itemobj.BLocDesc);	
	$HUI.combobox("#DocDr").setValue(itemobj.BDocID);	
	$HUI.combobox("#DocDr").setText(itemobj.DocName);
	
	$HUI.datetimebox("#OperTime").setValue(itemobj.OperDate);        /// 手术时间
	$("#OperName").val(itemobj.OperName); 	/// 手术名称
	$("#OperPart").val(itemobj.OperPart); 	/// 手术部位
	//$("#OperUser").val(itemobj.OperUser); 	/// 手术医生
	$HUI.combobox("#OperUser").setValue(itemobj.arOperUser);			/// qunianpeng  2018/8/29
	$HUI.combobox("#OperUser").setText(itemobj.arOperUserName);
	$("#OperTele").val(itemobj.OperUTel); 	/// 联系电话
	$("#OperRoom").val(itemobj.OperRoom); 	/// 手术室/间
	$("#OperAim").val(itemobj.OperAim); 	/// 送检目的		  /// qunianpeng 2018/9/3
	$("#OperWay").val(itemobj.OperWay); 	/// 手术方式
	
	$HUI.combobox("#ApplyDocUser").setValue(itemobj.ApplyDocId);  /// 申请科室和申请医生 qunianpeng 2018/2/5
	$HUI.combobox("#ApplyDocUser").setText(itemobj.ApplyDocDesc);	
	$HUI.combobox("#ApplyLoc").setValue(itemobj.ApplyLocId);	
	$HUI.combobox("#ApplyLoc").setText(itemobj.ApplyLocDesc);

	$HUI.datebox("#FoundDate").setValue(itemobj.TFoundDate);   /// 发现日期
	$("#TumPart").val(itemobj.TumPart); 	   		           /// 原发部位
	$("#TumSize").val(itemobj.TumSize); 	   		           /// 肿瘤大小
	$("#TransPos").val(itemobj.TransPos); 	   		           /// 转移部位
	$("#Remark").val(itemobj.Remark); 	   		               /// 备注
	$HUI.checkbox("#TransFlag").setValue(itemobj.TransFlag == "Y"? true:false);      /// 转移
	$HUI.checkbox("#RadCureFlag").setValue(itemobj.RadCureFlag == "Y"? true:false);  /// 放疗
	$HUI.checkbox("#CheCureFlag").setValue(itemobj.CheCureFlag == "Y"? true:false);  /// 化疗
	if ((itemobj.TFoundDate != "")||(itemobj.TumPart !="")||(itemobj.TumSize !="")||(itemobj.TransPos !="")){ 
		$("#TumorCk").prop("checked", true);
		$("#TumorCk").nextAll().css("display","block");		   /// 发送后加载时，展开肿瘤详情  qunianpeng  2018/3/7
	}
	if ((itemobj.LastMensDate != "")||(itemobj.PauFlag == "Y")){
		$("#WomenCk").prop("checked", true);
	}
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
	$HUI.datebox("#LastMensDate").disable(); /// 上次月经
	$HUI.datebox("#MensDate").disable();     /// 末次月经
	$HUI.datetimebox("#SepDate").disable(); /// 标本离体时间
	$HUI.datetimebox("#FixDate").disable(); /// 标本固定时间
	$HUI.combobox("#LocID").disable();  /// 取材科室不可用
	$HUI.combobox("#DocDr").disable();  /// 取材医生不可用
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

/// 病人就诊信息
function GetPatBaseInfo(){
	runClassMethod("web.DHCAppPisMasterQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "LocID":session['LOGON.CTLOCID'], "UserID":session['LOGON.USERID'] },function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject.PatSex == "男"){
			$("label:contains('妇科信息')").parent().hide();
		}
		if (PisID == ""){

			/// 取材医生				
			$('#DocDr').combobox("setValue",session['LOGON.USERID']);
			$('#DocDr').combobox("setText",session['LOGON.USERNAME']);
			
			/// 取材科室
			$('#LocID').combobox("setValue",session['LOGON.CTLOCID']);
			$('#LocID').combobox("setText",jsonObject.LgLocDesc);		
			
			/// 申请医生	
			$('#ApplyDocUser').combobox("setValue",session['LOGON.USERID']);
			$('#ApplyDocUser').combobox("setText",session['LOGON.USERNAME']);	
			
			/// 申请科室
			$('#ApplyLoc').combobox("setValue",session['LOGON.CTLOCID']); 
			$('#ApplyLoc').combobox("setText",jsonObject.LgLocDesc);		
		}
		
		//$HUI.combobox("#LocID").setValue(itemobj.LocID);			   /// 取材科室和医生改为下拉框 qunianpeng 2018/2/2
		//$HUI.combobox("#LocID").setText(itemobj.BLocDesc);	
		//$HUI.combobox("#DocDr").setValue(itemobj.DocID);	
		//$HUI.combobox("#DocDr").setText(itemobj.DocName);
	},'json',false)
}

/// 获取申请单日期
function GetPisNoSysTime(){
	
	var PisDate = "";
	runClassMethod("web.DHCAppPisMasterQuery","GetPisNoSysTime",{"PisID":PisID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","取申请单日期异常！");
		}else{
			PisDate = jsonString;
		}
	},'',false)
	return PisDate;
}

/// 绝经
function PauFlag_onClick(event, value){
	
	if (value == true){
		$('#MensDate').datebox('setValue',"");
		$('#LastMensDate').datebox('setValue',"");
	}
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
		$("#OperCon").show();   					 /// 隐藏手术信息 qunianpeng 2018/9/3
	}else{
		$("#OperCon").hide();   
	}
}

/// 妇科信息
function WomenCk_OnClick(){
	
	if (!$("#WomenCk").is(":checked")){
		$HUI.datebox("#LastMensDate").setValue("");  /// 上次月经
		$HUI.datebox("#MensDate").setValue("");      /// 末次月经
		$("#PreTimes").val(""); 	   		         /// 胎
		$("#LyTimes").val(""); 	   		             /// 产
		$HUI.checkbox("#PauFlag").setValue(false);   /// 绝经
	}
}

/// 肿瘤信息
function TumorCk_OnClick(){

	if (!$("#TumorCk").is(":checked")){
		$HUI.datebox("#FoundDate").setValue("");   /// 发现日期
		$("#TumPart").val(""); 	   		           /// 原发部位
		$("#TumSize").val(""); 	   		           /// 肿瘤大小
		$("#TransPos").val(""); 	   		           /// 转移部位
		$("#Remark").val(""); 	   		               /// 备注
		$HUI.checkbox("#TransFlag").setValue(false);   /// 转移
		$HUI.checkbox("#RadCureFlag").setValue(false); /// 放疗
		$HUI.checkbox("#CheCureFlag").setValue(false); /// 化疗
	}
}

/// 设置活体组织申请单加急或冰冻标志
function LoadPisNoFlag(){
	
	var arcItemList=mListDataDoc.split("!")[1];
	if (arcItemList == "") return;

	runClassMethod("web.DHCAppPisMasterQuery","GetPisNoFlag",{"arcItemList":arcItemList},function(json){
		
		arEmgFlag = json.EmgFlag;
		arFrostFlag = json.FrostFlag;
		/*
		/// 设置加急标志
		if (json.EmgFlag == "Y"){
			$HUI.checkbox("#EmgFlag").setValue(true);    /// 加急
		}else{
			$HUI.checkbox("#EmgFlag").setValue(false);   /// 加急
		}
		/// 设置冰冻标志
		if (json.FrostFlag == "Y"){
			$HUI.checkbox("#FrostFlag").setValue(true);    /// 冰冻
		}else{
			$HUI.checkbox("#FrostFlag").setValue(false);   /// 冰冻
		}
		*/
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
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td><td></td><td></td></tr>';
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

/// 活体申请单打印
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
	if (txtUtil(jsonObj.EmgFlag) == "Y"){
		MyPara = MyPara+"^EmgFlag"+String.fromCharCode(2)+"√";       /// 加急
	}
	if (txtUtil(jsonObj.FrostFlag) == "Y"){
		MyPara = MyPara+"^FrostFlag"+String.fromCharCode(2)+"√";   /// 冰冻
	}
	
	MyPara = MyPara+"^PisNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisNo);           /// 病理号
	MyPara = MyPara+"^ItemDesc"+String.fromCharCode(2)+txtUtil(jsonObj.ItemDesc);     /// 检测项目
	MyPara = MyPara+"^PisReqSpec"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisReqSpec,60)); /// 病理标本
	MyPara = MyPara+"^MedRecord"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.MedRecord,60));   /// 临床病历
	MyPara = MyPara+"^PisTesDiag"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisTesDiag,60)); /// 临床诊断
	MyPara = MyPara+"^OperRes"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.OperRes,60));       /// 手术所见
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);     /// 申请单号
	MyPara = MyPara+"^TFoundDate"+String.fromCharCode(2)+txtUtil(jsonObj.TFoundDate); /// 肿瘤发现日期
	MyPara = MyPara+"^TumPart"+String.fromCharCode(2)+txtUtil(jsonObj.TumPart);		  /// 肿瘤部位
	MyPara = MyPara+"^TumSize"+String.fromCharCode(2)+txtUtil(jsonObj.TumSize);       /// 肿瘤大小
	MyPara = MyPara+"^TransFlag"+String.fromCharCode(2)+txtUtil(jsonObj.TransFlag);   /// 是否转移
	MyPara = MyPara+"^TransPos"+String.fromCharCode(2)+txtUtil(jsonObj.TransPos);     /// 转移部位
	MyPara = MyPara+"^RadCureFlag"+String.fromCharCode(2)+txtUtil(jsonObj.RadCureFlag); /// 是否放疗
	MyPara = MyPara+"^CheCureFlag"+String.fromCharCode(2)+txtUtil(jsonObj.CheCureFlag); /// 是否化疗
	MyPara = MyPara+"^Remark"+String.fromCharCode(2)+txtUtil(jsonObj.Remark);           /// 其他信息
	
	MyPara = MyPara+"^LastMensDate"+String.fromCharCode(2)+txtUtil(jsonObj.LastMensDate);  /// 上次月经日期
	MyPara = MyPara+"^MensDate"+String.fromCharCode(2)+txtUtil(jsonObj.MensDate);          /// 末次月经日期
	MyPara = MyPara+"^PauFlag"+String.fromCharCode(2)+txtUtil(jsonObj.PauFlag);            /// 是否绝经
	MyPara = MyPara+"^PreTimes"+String.fromCharCode(2)+txtUtil(jsonObj.PreTimes);          /// 怀孕次数
	MyPara = MyPara+"^LyTimes"+String.fromCharCode(2)+txtUtil(jsonObj.LyTimes);            /// 生产次数
	
	MyPara = MyPara+"^SepDate"+String.fromCharCode(2)+txtUtil(jsonObj.SepDate);            /// 取材离体日期
	MyPara = MyPara+"^FixDate"+String.fromCharCode(2)+txtUtil(jsonObj.FixDate);            /// 开始固定日期
	MyPara = MyPara+"^BLocDesc"+String.fromCharCode(2)+txtUtil(jsonObj.BLocDesc);          /// 取材科室
	MyPara = MyPara+"^DocName"+String.fromCharCode(2)+txtUtil(jsonObj.DocName);            /// 取材医生
	MyPara = MyPara+"^PisPatInfDis"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisPatInfDis,60));  /// 传染病史
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22

	if (txtUtil(jsonObj.PatSex) == "女"){
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisLivCell");
	}else{
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisLivCell_M");
	}
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

/// 申请单是否允许编辑
function InitReqEditFlag(ID){

	var LgParams = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","JsGetReqEditFlag",{"ID":ID, "Type":"P", "LgParams":LgParams},function(jsonString){
		if (jsonString != ""){
			isPageEditFlag = jsonString;
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
    $("#PisSpecList").datagrid("load",{"PisID":PisID});  /// 标本列表
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
// 表格删除行后重新排序 qunianpeng  2018/1/29 
// 没有考虑完全 rowNo默认是4,若从加载过来标本后，则可不是4行
function sortTable(){
	var tmpNum = 1;
	var arr = [];
	var selItems = $('#PisSpecList').datagrid('getRows');
	$.each(selItems, function(index, item){
		var tepObj = {"No":tmpNum ,"Name": item.Name,"Explain":item.Explain,"Part":item.Part,"Qty":item.Qty,"Remark":item.Remark,"SliType":item.SliType,"PisNo":item.PisNo};
		tmpNum += 1;
		arr.push(tepObj);
	});
	for (var i=0; i<arr.length; i++){	
		$('#PisSpecList').datagrid('updateRow',{index:i, row:arr[i]});		
	}
	rowNo = tmpNum-1; 	//记录最大的行号
  
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

/// 日期大小判断
function isCompare(FriDate, SecDate){
	
	var isCompareFlag = 0;
	runClassMethod("web.DHCAppPisMasterQuery","isCompare",{"FriDate":FriDate, "SecDate":SecDate},function(jsonString){

		if (jsonString != null){
			isCompareFlag = jsonString;			
		}
	},'',false)
	return isCompareFlag;
}

/// 取医嘱的加急标志
function SetPisEmgflag(arcimid){
	
	runClassMethod("web.DHCAPPExaReportQuery","GetItmEmFlag",{"arcimid":arcimid},function(jsonString){
		
		if (jsonString == "Y"){
			$HUI.checkbox("#EmgFlag").setValue(true);    /// 加急
		}else{
			$HUI.checkbox("#EmgFlag").setValue(false);   /// 加急
		}
	},'text',false)
	
}

/// 取医嘱的冰冻标志
function SetPisFrostflag(arcimid){
	
	runClassMethod("web.DHCAppPisMasterQuery","GetItmFrostFlag",{"arcimid":arcimid},function(jsonString){
		
		if (jsonString == "Y"){
			$HUI.checkbox("#FrostFlag").setValue(true);    /// 冰冻
		}else{
			$HUI.checkbox("#FrostFlag").setValue(false);   /// 冰冻
		}
	},'text',false)
	
}

window.onload = onload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

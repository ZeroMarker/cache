//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-09
// 描述:	   新版检验
//===========================================================================================

var EpisodeID = "";      /// 病人就诊ID
var itemCatID = "";      /// 检查分类ID
var itemReqID = "";      /// 申请单ID
var itemSelFlag = "";    /// 已选列表当前状态值
var arExaReqIdList = "";
var editRow = ""; var editSelRow = -1;
var LgUserID = session['LOGON.USERID'];   /// 用户ID
var LgCtLocID = session['LOGON.CTLOCID']; /// 科室ID
var LgGroupID = session['LOGON.GROUPID']; /// 安全组ID
var LgHospID = session['LOGON.HOSPID'];   /// 医院ID
var isPageEditFlag = 1;  /// 页面是否允许编辑

/// 1、关闭当前弹窗并刷新医嘱页面(医生站)
/// 2、关闭当前弹窗(电子病历)
var CloseFlag = "";      /// 关闭标志
var DocMainFlag = "";    /// 医生站界面弹出标示
var mListDataDoc = "";
var mItmMastStr = "";    /// 临时存储项目串
var TakOrdMsg = "";
var mItmMastLen = "";    /// 检查项目总个数
var mItmMastDocArr = []; /// 检查项目
var pid = "";
var repEmgFlag = "";     /// 申请单加急标志  sfuan 2018-02-01
var PatType="";          /// 就诊类型
if (websys_isIE==true) {
     var script = document.createElement('script');
     script.type = 'text/javaScript';
     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
     document.getElementsByTagName('head')[0].appendChild(script);
}
/// 页面初始化函数
function initPageDefault(){
		
	InitPatEpisodeID();   /// 初始化加载病人就诊ID
	
	initVersionMain();    ///  页面兼容配置
	initItemSelList();    ///  页面DataGrid初始定义
	initCombobox();       ///  页面Combobox初始定义
	initBlButton();       ///  页面Button绑定事件

	LoadPageBaseInfo();   ///  初始化加载基本数据
	
	initPatNotTakOrdMsg(); /// 验证病人是否允许开医嘱
	initItemInstrDiv();    /// 检查项目说明书
}

/// 页面兼容配置
function initVersionMain(){

	/// 医生界面调用时,初始化内容
	if (DocMainFlag == 1){
		/// 设置界面按钮内容
		//$('button:contains("发送")').text("确认");
		$('button:contains("打印")').text("关闭");
		//$('#arEmgFlag').parent().parent().hide(); /// 加急标志隐藏 qunianpeng 2018/3/20
	}
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
	CloseFlag = getParam("CloseFlag");
	itemCatID = getParam("itemCatID");
	itemReqID = getParam("itemReqID");  /// 申请单ID
	repEmgFlag = getParam("repEmgFlag");
	PatType = getParam("PatType");       /// 就诊类型
	
	/// 以下为医生站弹出参数 内容
	mListDataDoc = getParam("ARCIMStr");
	//DocMainFlag = getParam("DocMainFlag");  /// 医生界面判断
	if (mListDataDoc != ""){
		DocMainFlag = 1;
		var mParam = mListDataDoc.split("!")[0];
		if (mParam != ""){
			EpisodeID = mParam.split("^")[0];
		}
	}
	
	if (itemCatID != ""){
		LoadCheckItemList(itemCatID);
	}
}

///  初始化加载基本数据
function LoadPageBaseInfo(){
	
	/// 已选项目列表
	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqDetList";
	$('#ItemSelList').datagrid({url:uniturl});
	
	/// 医生界面调用时,初始化内容
	if (DocMainFlag == 1){
		LoadCheckItemByDoc();   /// 初始化检查方法内容
	}
}

/// 页面DataGrid初始定义已选列表
function initItemSelList(){
	
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}

	// 接收科室编辑格
	var rLocEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: '', //$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID=11207||1",
			valueField: "value", 
			textField: "text",
			onSelect:function(option){
				///设置类型值
				var ed=$("#ItemSelList").datagrid('getEditor',{index:editSelRow,field:'ItemLocID'});
				$(ed.target).val(option.value);
				var ed=$("#ItemSelList").datagrid('getEditor',{index:editSelRow,field:'ItemLoc'});
				$(ed.target).combobox('setValue', option.text);
			} 
		}

	}
	
	// 标本编辑格
	var SpeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url:'',//$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=GetSpeJsonData&HospID="+ LgHospID,
			valueField: "value", 
			textField: "text",
			onSelect:function(option){
				///设置类型值
				var ed=$("#ItemSelList").datagrid('getEditor',{index:editSelRow,field:'ItemSpecCode'});
				$(ed.target).val(option.value);
				var ed=$("#ItemSelList").datagrid('getEditor',{index:editSelRow,field:'ItemSpec'});
				$(ed.target).combobox('setValue', option.text);
			},
			onChange:function(newValue,oldValue){
				if (newValue=="") {
					var ed=$("#ItemSelList").datagrid('getEditor',{index:editSelRow,field:'ItemSpecCode'});
					$(ed.target).val("");
					var rows=$("#ItemSelList").datagrid("selectRow",editSelRow).datagrid("getSelected");
	                rows.ItemSpecCode="";
				}
			}
		}

	}
	
	///  定义columns
	var columns=[[
		{field:'ItemOpt',title:'操作',width:60,align:'center',formatter:SetCellOpUrl},
		
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'ItemArcID',title:'ItemArcID',width:100,hidden:true},
		{field:'ItemLabel',title:'项目名称',width:280,align:'center'},
		{field:'ItemLoc',title:'接收科室',width:150,align:'center',editor:rLocEditor},
		{field:'ItemLocID',title:'接收科室ID',width:100,hidden:true,editor:texteditor},
		{field:'ItemExaID',title:'项目ID',width:100,hidden:true},
		{field:'ItemExaPosiID',title:'体位ID',width:100,hidden:true},
		{field:'ItemExaPartID',title:'部位ID',width:100,hidden:true},
		{field:'ItemExaDispID',title:'后处理ID',width:100,hidden:true},
		{field:'ItemExaPurp',title:'检查目的',width:100,hidden:true},		
		{field:'ItemSpecCode',title:'标本Code',width:100,hidden:true,editor:texteditor},
		{field:'ItemSpec',title:'标本',width:100,editor:SpeEditor},
		{field:'ItemRemark',title:'备注',width:100,editor:texteditor},
		{field:'ItemStat',title:'当前状态',width:100,align:'center'},
		{field:'ItemBilled',title:'计费状态',width:100,hidden:true},
		{field:'ItemReqDate',title:'医嘱日期',width:100,hidden:true},
		{field:'ItemUniqueID',title:'唯一标示',width:100,hidden:true},
		{field:'ItemEmgFlag',title:'加急',width:40,hidden:false,align:'center',formatter:emgFlagControl}, // 加急标志 qunianpneg 2018/3/20
		{field:'ItemPrice',title:'价格',width:100},
		{field:'ItemTarItm',title:'收费项目',width:100,align:'center',formatter:SetCellTarUrl},
		{field:'ItemXUser',title:'撤销人',width:100,align:'center'},
		{field:'ItemXDate',title:'撤销日期',width:100,align:'center'},
		{field:'ItemXTime',title:'撤销时间',width:100,align:'center'},
		{field:'ItemBillTypeID',title:'费别ID',width:100,align:'center',hidden:true},
		{field:'ItemBillType',title:'费别',width:100,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
		onClickRow:function(rowIndex, rowData){
	        
	        /// 加载注意事项
	        LoadItemTemp(rowData.ItemExaID);
	    },
		onLoadSuccess:function(data){
			CheckForHidePrintClick();
			//itemSelFlag = 1;    /// 已选列表当前状态值
			GetExaReqItmCost();   /// 计算检查申请总金额

		},
		rowStyler:function(index,rowData){   
	        if (rowData.ItemStat == "停止"){
	            return 'background-color:Pink;'; 
	        }
	        if (rowData.ItemStat == "执行"){
	            return 'background-color:#99FFFF;'; 
	        } 
	    },
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑

	    	if (rowData.ItemID != "") return;
            if (editSelRow != ""||editSelRow == 0) { 
                $("#ItemSelList").datagrid('endEdit', editSelRow); 
            } 
            $("#ItemSelList").datagrid('beginEdit', rowIndex); 
            
            editSelRow = rowIndex; 
            
			///设置级联指针
			var ed=$("#ItemSelList").datagrid('getEditor',{index:rowIndex,field:'ItemLoc'});
			var OpenForAllHosp=0,LogLoc="";
			var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
			var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
			if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
			if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
		
			var unitUrl=$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+rowData.ItemExaID+"&OrderDepRowId="+LogLoc+"&OpenForAllHosp="+OpenForAllHosp;
			$(ed.target).combobox('reload',unitUrl);
			
			///设置级联指针 标本  sufan 2018-02-02
			///设置标本
			var ed=$("#ItemSelList").datagrid('getEditor',{index:rowIndex,field:'ItemSpec'});
			var unitUrl=$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonArcItemSpec&itmmastid="+rowData.ItemExaID;
			$(ed.target).combobox('reload',unitUrl);
        }
	};

	var uniturl = ""; //$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqDetList";
	new ListComponent('ItemSelList', columns, '', option).Init(); 
}

/// 操作
function SetCellOpUrl(value, rowData, rowIndex){
	
	/*
	if ((rowData.ItemStat == "停止")||(rowData.ItemStat == "执行")||(rowData.OpCellFlag == "1")){
		 return "";
	}*/
	/// 医生站弹出界面，无部位时不显示操作内容
	if ((rowData.ItemExaPartID == "")&(DocMainFlag == 1)){
		 return "";
	}
	if ((rowData.ItemStat == "停止")||(rowData.ItemStat == "执行")){
		 return "";
	}
	if (rowData.ItemID == ""){
		var html = "<a href='#' onclick='delItmSelRow("+rowIndex+")'>删除</a>";
	}else{
		if (rowData.oeori == ""){
			var html = "<a href='#' onclick='revItmSelRow("+rowIndex+")'>删除</a>";
		}else{
			var html = "<a href='#' onclick='revItmSelRow("+rowIndex+")'>撤销</a>";	
		}
	}
    return html;
}

/// 删除行
function delItmSelRow(rowIndex){
	
	$.messager.confirm('确认对话框','确定要删除该项吗？', function(r){
		if (r){
			/// 结束编辑行
			if (editSelRow != -1||editSelRow == 0) {
				$("#ItemSelList").datagrid('endEdit', editSelRow); 
			}
			/// 删除检查项目
			var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
			/// 删除行
			$("#ItemSelList").datagrid('deleteRow',rowIndex);
			var arExaItmID = rowData.ItemExaID.replace("||","_"); /// 检查项目
			/// 取消检查项目复选框
			if ($("#"+arExaItmID).is(":checked")){
				$("#"+arExaItmID).attr("checked",false);
			}
			GetExaReqItmCost();   ///  计算检查申请总金额
			$("#noteContent").html(""); /// 项目删除时，同时清空注意事项栏
		}
	});
}

/// 撤销
function revItmSelRow(rowIndex){
	
	var revTipMessage = "确定要撤销该项吗？";
	if (GetPartTarFlag(rowIndex) == "Y"){
		revTipMessage = "此医嘱不按部位累加收费且已计费，撤销只能撤销所有部位，是否继续？";
	}
	$.messager.confirm('确认对话框',revTipMessage, function(r){
		if (r){
			/// 删除检查项目
			var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
			/*if (rowData.ItemBilled == "P"){
				$.messager.alert("提示:","项目已收费，不允许撤销！");
				return;
			}*/
			if (rowData.ItemStat == "停止"){
				$.messager.alert("提示:","当前记录已停止，不能再次撤销！");
				return;
			}
			if (rowData.ItemStat == "执行"){
				$.messager.alert("提示:","当前记录已执行，不能撤销！");
				return;
			}
			revExaReqItm(rowData.ItemArcID,rowData.ItemExaID,rowData.ItemExaPartID);
			GetExaReqItmCost();   ///  计算检查申请总金额
			//$("#dgEmPatList").datagrid("reload");   /// 刷新页面数据
			/// 调用父框架函数
			window.parent.frames.reLoadEmPatList();
			/// 数字签名调用
			window.parent.frames.TakeDigSignRev(rowData.ItemExaID, "E");
		}
	});
}

/// 撤销执行选中项目
function revExaReqItm(arReqItmID,itmmastid,PartID){
	
	if (arReqItmID == "") return;
	runClassMethod("web.DHCAPPExaReport","revExaReqItm",{"arRepItmID":arReqItmID, "PartID":PartID, "LgParam":LgUserID+"^"+LgCtLocID+"^"+LgGroupID},function(jsonString){
		
		if (jsonString == 1){
			$.messager.alert("提示:","项目已执行，不允许撤销！");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("提示:","项目已收费，不允许撤销！");
			return;
		}
		if (jsonString == -3){
			$.messager.alert("提示:","执行记录已结算或完成，不能执行该操作！");
			return;
		}
		if ((jsonString == -4)||(jsonString == -302)){
			$.messager.alert("提示:","护士已执行，不能撤销！");
			return;
		}
		if (jsonString == -5){
			$.messager.alert("提示:","用户无权限撤销医嘱！");
			return;
		}
	    if (jsonString < 0){
			$.messager.alert("提示:","删除错误,错误信息:"+jsonString);
			return;
		}
		if (jsonString == "PS"){
			$.messager.alert("提示:","请主管老师审核该医嘱，进行撤销！");
			return;
		}
		if (jsonString == 0){
			$("#ItemSelList").datagrid("reload");   /// 刷新页面数据
		}
	
	},'',false)
}

/// 收费项目明细
function SetCellTarUrl(value, rowData, rowIndex){
	
	if (rowData.ItemStat == "停止") return "";
	var params = rowData.ItemExaID +"^"+ rowData.ItemExaPartID +"^"+ pid;
	var html = "<a href='#' onclick='showTarItmWin(\""+ params +"\")'>明细</a>";
    return html;
}

/// 加载检查方法列表
function LoadCheckItemList(itemCatID){
	
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaItemList",{"TraID":itemCatID},function(jsonString){

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
		htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:0px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px"><input id="'+ itemArr[j-1].value +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itemobj.id +'"  data-emtype="'+ itemArr[j-1].title +'"  data-defsensitive="'+ itemArr[j-1].defSensitive +'"></input></td><td>'+ itemArr[j-1].text +'</td>'); // qunianpeng 2018/3/20 增加title
		if (j % 3 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
		/// 医生界面调用时,初始化内容
		if (DocMainFlag == 1){
			/// 用于发送时，判断发送项目是否与开立项目一直
			mItmMastDocArr.push(itemArr[j-1].value +"*"+ itemArr[j-1].text);
		}
	}
	if ((j-1) % 3 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(htmlstr+itemhtmlstr)
}

/// 页面Combobox初始定义
function initCombobox(){

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";

	/// 接收科室
	var option = {
	    onLoadSuccess: function () {
		    //数据加载完毕事件
	        var data = $("#ExaRecloc").combobox('getData');
	        if (data.length > 0) {
	            //$("#ExaRecloc").combobox('select', data[0].value);
	        }
	    }
	}
	new ListCombobox("ExaRecloc",'','',option).init();
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	$("#itemList").on("click",".checkbox",selectExaItem);
	
	///  确认
	$('a:contains("确认")').bind("click",addItmToItmSelListNew);
	
	///  取消
	$('a:contains("取消")').bind("click",closeWin);
	
	///  检验项目 
	$("#item").bind("keyup",searchItem);
	
}

/// 其他项目
function LoadItmOtherOpt(itmmastid){

	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqOtherOpt",{"pid":pid, "itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			pid = jsonString;
			//showItemOtherOpt();  /// 注释 bianshuai 2016-08-09 
		}
	},'',false)
}

/// 发送检查申请
function sendExaReq(){
	/// 医疗结算判断
	if (GetIsMidDischarged() == 1){
		$.messager.alert("提示:","此病人已做医疗结算,不允许医生再开医嘱！");
		return;	
	}
	//医嘱与特慢病是否匹配
	var NotChronicMatchMsg=ChkChronicOrdItm();
	if (NotChronicMatchMsg!="") {
		$.messager.alert("提示",NotChronicMatchMsg);
		return;	
	}
	/// 验证病人是否允许开医嘱
	var TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg,"warning");
		return;	
	}
	/// 数字签名调用
	if (!window.parent.frames.isTakeDigSign()) return;
	
	/// 发送前调用知识库
	//if (InvokItmLib() != true) return;
	var selItems=$("#ItemSelList").datagrid('getRows');
	var ItemID = selItems[0].ItemID;
	if (ItemID==""){
		/// 住院急诊留观押金控制
		var PatArrManMsg = GetPatArrManage();
		if (PatArrManMsg != ""){
			$.messager.alert("提示:",PatArrManMsg);
			return;	
		}
	}
	
	/// 发送检查申请
	sendExaReqDetail(); 
}

/// 发送检查申请
function sendExaReqDetail(){
	
	/// 医生界面调用时，执行下面还是
	if (DocMainFlag == 1){
		sureExaReq();
		return;
	}

	if (editSelRow != -1||editSelRow == 0) {
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	}
	var ChronicDiagCode=window.parent.frames.GetChronicDiagCode();
	var itemLocFlag = 0; itemSpecFlag = 0;
	var ErrMsg="";
	//var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// 加急 qunianpeng 2018/3/20 移到项目列表
	var mItmListData = [];
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		
		var ItemID = selItem.ItemID;               /// 项目ID
		var itmmmastid = selItem.ItemExaID;        /// 医嘱项ID
		var ErrObject = GetPatNotTakOrdMsgArc(itmmmastid);
		if (ErrObject.ErrMsg != ""){
			if (ErrObject.ErrCode != 0){
				ErrMsg=ErrObject.ErrMsg;
				$.messager.alert("提示",ErrObject.ErrMsg);
				return;
			}
		}
		var itemLocID = selItem.ItemLocID;         /// 接收科室ID
		var itemLoc = selItem.ItemLoc;             /// 接收科室
		if ((itemLocID == "")||((itemLoc == "")||(typeof itemLoc == "undefined"))){
			itemLocFlag = 1;
			return false;
		}

		var itemExaPurp = selItem.ItemLabel;	   /// 检查目的
		var itemRemark = selItem.ItemRemark;	   /// 备注
		var itemSpecCode = selItem.ItemSpecCode;   /// 标本
		if (itemSpecCode == ""){
			itemSpecFlag = 1;
			return false;
		}
		var itemarEmgFlag = $("#CK_EmFlag"+index).is(":checked")? "Y":"N";   /// 加急 拼到医嘱项信息串中 qunianpeng 2018/3/20
		if (selItems.length>1) {
			var arEmgFlag="N";
		}else{
			var arEmgFlag=itemarEmgFlag;
		}
		var CoverMainIns=0
		var itemBillTypeID = selItem.ItemBillTypeID; /// 费别
		var InsurFlag=parent.$HUI.checkbox("#InsurFlag").getValue();
		if (InsurFlag==true){CoverMainIns=1}
		var ListData = ItemID +String.fromCharCode(2)+ EpisodeID +"^"+ itemLocID +"^"+ "" +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ "" +"^"+ "" +"^"+ LgCtLocID +"^"+ "" +"^"+ "Y"+"^"+ ""+"^"+parent.PPRowId+"^"+ChronicDiagCode;
			ListData = ListData +String.fromCharCode(2)+ itmmmastid +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ itemRemark +"^"+ itemSpecCode +"^^"+ itemBillTypeID+"^"+itemarEmgFlag+"^"+CoverMainIns;

		mItmListData.push(ListData);
	})
	if (ErrMsg!="") return false;
	if (itemLocFlag == 1){
		$.messager.alert("提示:","接收科室不能为空！");
		return;
	}
	if (itemSpecFlag == 1){
		$.messager.alert("提示:","检验项目标本不能为空！");
		return;
	}
	
	mItmListData = mItmListData.join(String.fromCharCode(1));
	if (mItmListData == ""){
		$.messager.alert("提示:","没有待发送项目,请选择检查项目后重试！");
		return;
	}

	/// 保存模板数据
	runClassMethod("web.DHCAPPExaReport","save",{"pid":pid, "ListData":mItmListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","检查申请单发送失败，失败原因:"+jsonString);
		}else{
			if (CloseFlag != ""){
				window.parent.frames.InvMainFrame(); /// 调用父框架函数
			}else{
				arExaReqIdList = jsonString;
				//printCom(arExaReqIdList);
				$.messager.alert("提示:","发送成功");
				$("#ItemSelList").datagrid("load",{"params":arExaReqIdList});
				/// 调用父框架函数
				window.parent.frames.reLoadEmPatList();
				/// 数字签名调用
				window.parent.frames.TakeDigSign(arExaReqIdList, "E");
				/// 电子病历框架函数
				window.parent.frames.InvEmrFrameFun();
				///刷新医嘱录入
				if (websys_getMenuWin().frames['TRAK_main'].ReshOrder){
					websys_getMenuWin().frames['TRAK_main'].ReshOrder();
				}
			}
		}
	},'',false)
}

/// 插入项目
function insHtmlTable(itemobj){

	/// 获取最后table最后一行td个数
	var tdnum = $("#TmpOtherOpt tr:last td").length;
	
	var htmlstr = '<td align="right">'+ itemobj.itemdesc +'</td>';
	if (itemobj.itemtype == "Check"){
		htmlstr = htmlstr + '<td style="width:120px"><input id="'+ itemobj.itemid +'" name="'+ itemobj.itemtype +'" type="checkbox" value="Y"/></td>';
	}else{
		htmlstr = htmlstr + '<td style="width:120px"><input id="'+ itemobj.itemid +'" name="'+ itemobj.itemtype +'" style="width:120px;"/></td>';
	}

	/// 插入位置
	if ((tdnum == 0)||(tdnum == 4)){
		htmlstr = '<tr>' + htmlstr + '</tr>';
		$("#TmpOtherOpt").append(htmlstr);
	}else{
		$("#TmpOtherOpt tr:last").append(htmlstr);
	}
	
	/// 处理 Combox
	if (itemobj.itemtype == "Combox"){
		var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonOtherOptSubItm&itemid="+ itemobj.itemid;
		var option = {
			panelHeight:"auto",
	        onSelect:function(option){

	        	/// 保存临时数据
				runClassMethod("web.DHCAPPExaReportQuery","setExaOtherOpt",{"pid":pid, "id":this.id, "type":"Combox", "val":option.value},function(jsonString){})
		    }
		};
		new ListCombobox(itemobj.itemid,uniturl,'',option).init();
	}
	
	/// 加载成功后,设置临时数据
	if (itemobj.itemtype == "Check"){
		$("#"+ itemobj.itemid).attr("checked",itemobj.itemval=="Y"?true:false);
	}
	if (itemobj.itemtype == "Combox"){
		$("#"+ itemobj.itemid).combobox("setValue",itemobj.itemval);;
	}
	if (itemobj.itemtype == "Input"){
		$("#"+ itemobj.itemid).val(itemobj.itemval);
	}
}

///  其他项目赋值
function setOtherOpt(){
	
	var val = "";
	if (this.name == "Check"){
		val = $(this).is(':checked')?"Y":"N";
	}

	if (this.name == "Input"){
		val = $(this).val();
	}

	/// 保存临时数据
	runClassMethod("web.DHCAPPExaReportQuery","setExaOtherOpt",{"pid":pid, "id":this.id, "type":this.name, "val":val},function(jsonString){})
}

/// 加载接收科室
function LoadArcItemRecLoc(arItemID){

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";
    /// 加载接收科室
    var url = uniturl+"jsonExaCatRecLoc&EpisodeID="+ EpisodeID +"&arItmmastID="+ arItemID;
    $("#ExaRecloc").combobox('reload', url);
}

/// 加载接收科室
function LoadArcItemRecLocNew(arItemID){

	runClassMethod("web.DHCAPPExaReportQuery","jsonExaCatRecLoc",{"EpisodeID":EpisodeID,"arItmmastID":arItemID},function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			$("#ExaRecloc").combobox('loadData',jsonString); 
			for(var i=0;i<jsonObjArr.length;i++){
				if (jsonObjArr[i].deftyle == "Y"){
					$("#ExaRecloc").combobox('select', jsonObjArr[i].value);
				}
			}     
		}
	},'json',false)
}

/// 查询检查项目
function findExaItemList(event){
	
	if(event.keyCode == "13"){
		var ExaItmCode=$.trim($("#ExaItmCode").val());
		var node = $("#CheckPart").tree('getSelected');
		var isLeaf = $("CheckPart").tree('isLeaf',node.target);   /// 是否是叶子节点
        if (isLeaf){
	        var params = node.id +"^"+ "" +"^"+ ExaItmCode;
			$("#ItemList").datagrid("load",{"params":params});
        }
        /*
		var node = $("#CheckPart").tree('getSelected');
        if (node.id.indexOf("^") != "-1"){
			var params = node.id +"^"+ ExaItmCode;
			$("#ItemList").datagrid("load",{"params":params});
        }
        */
	}
}

/// 检查是否已添加相同项目
function isExistItem(ItemLabel){
	
	var isExistItem = false;
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if (selItem.ItemLabel == ItemLabel){
			isExistItem = true;
			return false;
		}
	})
	return isExistItem;
}

/// 打印申请单
function printExaReq(flag){
	
	/*var arReqArr=arExaReqIdList.split("^");
	for (var i=0;i<arReqArr.length;i++){
		window.parent.frames.PrintBar(arReqArr[i],flag)
	}*/
	
	//window.parent.frames.PrintBar(arExaReqIdList,flag);
	var arReqArr=arExaReqIdList.split("^");
	for (var i=0;i<arReqArr.length;i++){
		runClassMethod("web.DHCAPPExaReport","GetExaRepSendFlag",{"arReqID":arReqArr[i]},function(arSendFlag){
			if (arSendFlag=="I"){
				$.messager.alert("提示","待审核医嘱不能打印!")
				return;
			}
		},'',false)
	}
	///打印检验告知单
	printReqLab(arExaReqIdList);   /// 调用打印函数
}

/// 获取申请单总费用
function GetExaReqItmCost(){

	var mItmListData=[];
	var arRepID = "";
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#ItemSelList').datagrid('refreshRow', index); /// 刷新当行
		
		arRepID = selItem.ItemID;                  /// 项目ID
		var itmmmastid = selItem.ItemExaID;        /// 医嘱项ID
		var itemExaPosiID = selItem.ItemExaPosiID; /// 体位ID
		var itemExaPartID = selItem.ItemExaPartID; /// 部位ID
		var itemExaDispID = selItem.ItemExaDispID; /// 后处理ID
		
		if (selItem.ItemStat == "停止") return;
		
		mItmListData.push(itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID);
	})

	mItmListData = mItmListData.join("&&");

	if (mItmListData == ""){
		$("#arExaReqCost").text(0 +"元");
		return;
	}

	var ListData = arRepID +"^"+ EpisodeID +"^"+ pid +"#"+ mItmListData;

	/// 保存模板数据
	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqItmCost",{"ListData":ListData},function(jsonString){
		if (jsonString > 0){
			var arExaReqCost = jsonString;
			$("#arExaReqCost").text(arExaReqCost +"元");
		}
	},'',false)
}

/// 检查申请单是否还有可预约项目
function isExistNeedAppItm(arReqID){
	
	var AppFlag = false;
	runClassMethod("web.DHCAPPInterface","GetExaReqAppFlag",{"arReqID":arReqID},function(jsonString){
		if (jsonString == "Y"){
			AppFlag = true;
		}
	},'',false)
	
	return AppFlag;
}

///  添加项目到已选列表
function addItmToItmSelList(rowIndex){
	
	/// 已选列表当前状态值
	if (itemSelFlag == "1"){
		itemSelFlag = "";
		$("#ItemSelList").datagrid('loadData',{total:0,rows:[]});
	}
	
	/// 诊断判断
	if (GetMRDiagnoseCount() == 0){
		$.messager.alert("提示:","病人没有诊断,请先录入！","",function(){DiagPopWin()});
		return;	
	}

	/// 医疗结算判断
	if (GetIsMidDischarged() == 1){
		$.messager.alert("提示:","此病人已做医疗结算,不允许医生再开医嘱！");
		return;	
	}

	/// 验证病人是否允许开医嘱
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg);
		return;	
	}
		
	/// 检查方法
	var rowData=$("#itemList").datagrid('getData').rows[rowIndex];
		
	var itmmmastid = rowData.ItemID;         /// ID
	var itmmmastdesc = rowData.ItemDesc;     /// 描述
	var itmmmastprice = rowData.ItemPrice;   /// 价格
	var arExaPartID = rowData.ItemPartID;    /// 部位ID
	var arExaPartDesc = rowData.ItemPart;    /// 部位描述

	/// 医嘱的性别/年龄限制
	var LimitMsg = GetItmLimitMsg(itmmmastid)
	if (LimitMsg != ""){
		$.messager.alert("提示:","项目【" +itmmmastdesc+ "】被限制使用：" + LimitMsg);
		return;	
	}
		
	/// 接收科室
	var ExaReclocID = ""; var ExaRecloc = "";
	var OpenForAllHosp=0,LogLoc="";
	var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
	var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
	if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
	if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmmastid,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			ExaReclocID = jsonObjArr[0].value;
			ExaRecloc = jsonObjArr[0].text;
		}
	},'json',false)
	
	var ItemLabel = itmmmastdesc;

	var ItemLabelArr = [];
	if (arExaPartDesc !="" ){
		ItemLabelArr.push(arExaPartDesc);
	}
	if (ItemLabelArr.join("，") != ""){
		ItemLabel = ItemLabel + "[" + ItemLabelArr.join("，") + "]";
	}

	if (isExistItem(ItemLabel)){
		$.messager.alert("提示:","已存在相同项目,请核实后再试！");
		return false;
	}

	/// 加入已选列表
	var rowobj={ItemID:"", ItemArcID:"", ItemLabel:ItemLabel, ItemExaID:itmmmastid, ItemPrice:itmmmastprice, ItemLocID:ExaReclocID, ItemLoc:ExaRecloc,
	ItemExaPartID:arExaPartID, ItemExaDispID:'', ItemExaPosiID:'',ItemExaPurp:ItemLabel, ItemOpt:'', ItemRemark:'', ItemStat:"核实"}
	$("#ItemSelList").datagrid('appendRow',rowobj);
	CheckForHidePrintClick();

	/// 其他项目
    LoadItmOtherOpt(itmmmastid);
    
	GetExaReqItmCost();   ///  计算检查申请总金额
}

/// 删除项目
function delItmFromItmSelList(rowIndex){
	
	var rowData=$("#itemList").datagrid('getData').rows[rowIndex];
		
	var itmmmastid = rowData.ItemID;         /// ID
	var arExaPartID = rowData.ItemPartID;    /// 部位ID
	
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if ((selItem.ItemExaID == itmmmastid)&(selItem.ItemExaPartID == arExaPartID)){
			/// 删除行
			$("#ItemSelList").datagrid('deleteRow',index);
			GetExaReqItmCost();   ///  计算检查申请总金额
			return false;
		}
	})
}

/// 当前项目是否已经添加单项目列表
function GetCurItmIsSelect(itmmmastid, arExaPartID){
	
	var IsSelect = false;
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if ((selItem.ItemExaID == itmmmastid)&(selItem.ItemExaPartID == arExaPartID)){
			IsSelect = true;
			return false;
		}
	})
	return IsSelect;
}
/* ------选中检查项目到已选列表,支持chrome start-------*/
function selectExaItem(e){
	if ($(this).is(':checked')){
		new Promise(function(resolve,rejected){
			ChkBeforeSelectExaItem(e,"checkbox",resolve);
		}).then(function(){
			selectExaItemData(e);
		})
		//ChkBeforeSelectExaItem(e,selectExaItemData,"checkbox")
	}else{
		delSelectExaItem(e);
	}
}
function ChkBeforeSelectExaItem(e,type,ExcFunc){
	new Promise(function(resolve,rejected){
		/// 医疗结算判断
		if (GetIsMidDischarged() == 1){
			$.messager.alert("提示","此病人已做医疗结算,不允许医生再开医嘱！","",function(){
				if (type=="label"){
					$("#itemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
				}else{
					$(e.target).attr("checked",false);
				}
			});
			return;
		}
		resolve();
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			/// 验证医嘱与特慢病是否匹配
			var arExaItmID = e.target.id;    /// 检查方法ID
			if (DocMainFlag == 1){
				arExaItmID = arExaItmID.split("*")[3]; /// 医嘱项ID
			}
			var NotChronicMatchMsg=ChkChronicOrdItm(arExaItmID.replace("_","||"));
			if (NotChronicMatchMsg!="") {
				$.messager.alert("提示",NotChronicMatchMsg,"info",function(){
					if (type=="label"){
						$("#ItemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
					}else{
						$(e.target).attr("checked",false);
					}
				});
				return;	
			} 
			resolve();
		})
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			/// 验证病人是否允许开医嘱
			TakOrdMsg = GetPatNotTakOrdMsg();
			if (TakOrdMsg != ""){
				$.messager.alert("提示",TakOrdMsg,"warning",function(){
					if (type=="label"){
						$("#itemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
					}else{
						$(e.target).attr("checked",false);
					}
				});
				return;
			}
			resolve();
		})
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			/// 检查方法【医嘱项ID、医嘱项名称】
			var arExaItmID = e.target.id;    /// 检查方法ID
			/// 获取医生录医嘱权限
			if (GetDocPermission(arExaItmID) == 1){
				$.messager.alert("提示","您没有权限录入该医嘱！","warning",function(){
					if (type=="label"){
						$("#itemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
					}else{
						$(e.target).attr("checked",false);
					}
				});
				return;	
			}
			resolve();
		})
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			var arExaItmID = e.target.id;    /// 检查方法ID
			/// 验证病人是否允许开医嘱
			var ErrObject = GetPatNotTakOrdMsgArc(arExaItmID.replace("_","||"));
			if (ErrObject.ErrMsg != ""){
				$.messager.alert("提示",ErrObject.ErrMsg,"warning",function(){
					if (ErrObject.ErrCode != 0){
						if (type=="label"){
							$("#itemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
							}else{
						$(e.target).attr("checked",false);}
					}else{
						resolve();
					}
				});
			}else{
				resolve();
			}
		})
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			/// 医嘱的性别/年龄限制
			var arExaItmID = e.target.id;    /// 检查方法ID
			var LimitMsg = GetItmLimitMsg(arExaItmID)
			if (LimitMsg != ""){
				$.messager.alert("提示","项目【" +arExaItmDesc+ "】被限制使用：" + LimitMsg,"warning","info",function(){
					if (type=="label"){
							$("#itemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
					}else{
						$(e.target).attr("checked",false);
					}
				});
				return;	
			}
			resolve();
		})
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			/// 诊断判断
			if (GetMRDiagnoseCount() == 0){
				$.messager.alert("提示","病人没有诊断,请先录入！","",function(){
					(function(callBackFun){
						new Promise(function(resolve,rejected){
							DiagPopWinNew(resolve);
						}).then(function(){
							if (GetMRDiagnoseCount()>0) {
								callBackFun();
							}else{
								if (type=="label"){
									$("#itemList").find(".checkbox").find("#"+e.target.id).attr("checked",false);
								}else{
									$(e.target).attr("checked",false);
								}
								return;
							}
						})
					})(resolve);
				})
			}else{
				resolve();
			}
		})
	}).then(function(){
		ExcFunc();
	})
}
function selectExaItemData(e){	
	/// 检查方法【医嘱项ID、医嘱项名称】
	var arExaItmID = e.target.id;    /// 检查方法ID
	var arExaItmDesc = $(e.target).parent().next().text(); /// 检查方法
	var arExaCatID = e.target.value; /// 检查分类ID
	var arEmgFlag = $(e.target).attr("data-emtype");	 /// 增加加急标志  qunianpeng 2018/3/20		
	var arDefEmg= $(e.target).attr("data-defsensitive");	 /// 是否默认加急
	if (arDefEmg=="Y") arEmgFlag="C"; //
	if (arExaReqIdList != ""){
		$.messager.confirm('提示','申请单已发送不能新增项目，是否新增申请单？', function(b){
			if (b){
				PageEditFlag(1);  /// 重新设置界面编辑状态
				/// 准备添加检查项目
				attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag); ///增加加急标志  qunianpeng 2018/3/20
			}else{
				/// 取消项目选中状态
				$("#"+arExaItmID).attr("checked",false);
			}
		})
	}else{
		/// 准备添加检查项目
		attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag);  ///增加加急标志  qunianpeng 2018/3/20
	}
	DHCDocUseCount(arExaItmID.replace(/_/g,"||"), "User.ARCItmMast");
}
function delSelectExaItem(e){
	var arExaItmID = $(e.target)[0].id;    /// 检查方法ID
	var arExaItmID = arExaItmID.replace("_","||");
	/// 删除行
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(rowIndex, selItem){
		if ((selItem.ItemExaID == arExaItmID)&(selItem.ItemExaPartID == "")){
			/// 删除行
			$("#ItemSelList").datagrid('deleteRow',rowIndex);			
			$("#noteContent").html(""); /// 项目删除时，同时清空注意事项栏			
		}
	})
	GetExaReqItmCost();   ///  计算检查申请总金额
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
/* ------选中检查项目到已选列表,支持chrome end-------*/
/// 选中检查项目
/*function selectExaItem(){
	
	if ($(this).is(':checked')){
		
		/// 诊断判断
		if (GetMRDiagnoseCount() == 0){
			$.messager.alert("提示:","病人没有诊断,请先录入！","",function(){DiagPopWin()});
			$(this).attr("checked",false);
			return;	
		}
		
		/// 医疗结算判断
		if (GetIsMidDischarged() == 1){
			$.messager.alert("提示:","此病人已做医疗结算,不允许医生再开医嘱！");
			$(this).attr("checked",false);
			return;	
		}
		
		/// 验证病人是否允许开医嘱
		if (TakOrdMsg != ""){
			$.messager.alert("提示:",TakOrdMsg);
			$(this).attr("checked",false);
			return;	
		}
		
		/// 检查方法【医嘱项ID、医嘱项名称】
		var arExaItmID = this.id;    /// 检查方法ID
		var arExaItmDesc = $(this).parent().next().text(); /// 检查方法
		var arExaCatID = this.value; /// 检查分类ID
		var arEmgFlag = $(this).attr("data-emtype");	 /// 增加加急标志  qunianpeng 2018/3/20		
		var arDefEmg= $(this).attr("data-defsensitive");	 /// 是否默认加急
		if (arDefEmg=="Y") arEmgFlag="C"; //
		/// 获取医生录医嘱权限
		if (GetDocPermission(arExaItmID) == 1){
			$.messager.alert("提示:","您没有权限录入该医嘱！");
			$(this).attr("checked",false);
			return;	
		}
				
		/// 验证病人是否允许开医嘱
		var ErrObject = GetPatNotTakOrdMsgArc(arExaItmID);
		if (ErrObject.ErrMsg != ""){
			$.messager.alert("提示:",ErrObject.ErrMsg,"info");
			if (ErrObject.ErrCode != 0){
				$(this).attr("checked",false);
			}
			return;
		}
		
		/// 医嘱的性别/年龄限制
		var LimitMsg = GetItmLimitMsg(arExaItmID)
		if (LimitMsg != ""){
			$.messager.alert("提示:","项目【" +arExaItmDesc+ "】被限制使用：" + LimitMsg);
			$(this).attr("checked",false);
			return;	
		}
		
		if (arExaReqIdList != ""){
			$.messager.confirm('提示','申请单已发送不能新增项目，是否新增申请单？', function(b){
				if (b){
					PageEditFlag(1);  /// 重新设置界面编辑状态
					/// 准备添加检查项目
					attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag); ///增加加急标志  qunianpeng 2018/3/20
				}else{
					/// 取消项目选中状态
					$("#"+arExaItmID).attr("checked",false);
				}
			})
		}else{
			/// 准备添加检查项目
			attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag);  ///增加加急标志  qunianpeng 2018/3/20
		}
	}else{
		
		var arExaItmID = this.id;    /// 检查方法ID
		var arExaItmID = arExaItmID.replace("_","||");
	
		/// 删除行
		var selItems=$("#ItemSelList").datagrid('getRows');
		$.each(selItems, function(rowIndex, selItem){
			if ((selItem.ItemExaID == arExaItmID)&(selItem.ItemExaPartID == "")){
				/// 删除行
				$("#ItemSelList").datagrid('deleteRow',rowIndex);			
				$("#noteContent").html(""); /// 项目删除时，同时清空注意事项栏			
			}
		})
		GetExaReqItmCost();   ///  计算检查申请总金额
	}
	
}*/

/// 准备添加检查项目
function attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID,arEmgFlag){ /// 增加加急标志  qunianpeng 2018/3/20
	
		/// 清空已选项目列表
		if (arExaReqIdList != ""){
			$("#ItemSelList").datagrid('loadData',{total:0,rows:[]});
			arExaReqIdList = "";
		}
		
		/// 医生界面调用时,取值格式
		if (DocMainFlag == 1){
			mItmMastStr = arExaItmID;      /// 临时存储检查方法
			arExaItmID = arExaItmID.split("*")[3];
		}
		
		runClassMethod("web.DHCAPPExaReportQuery","isExistLinkPart",{"itmmastid":arExaItmID,"TraID":arExaCatID,"HospID":LgHospID},function(isLinkPart){
		
			if (isLinkPart != ""){
				if (isLinkPart == 1){
					//createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc);  /// 项目需选择部位，弹出部位窗口
				}else{
					if (IsRepeatOneday(arExaItmID,"") == 1){
						if (PatType == "O"){
							$.messager.alert("提示", "当天已有相同医嘱,不允许继续添加!","warning",function(){
								/// 取消检查项目复选框
								if ($("#"+arExaItmID).is(":checked")){
									$("#"+arExaItmID).attr("checked",false);
								}
							});
							return;
						}
						$.messager.confirm('确认对话框','当天已有相同医嘱是否继续添加？', function(r){
							if (r){
								if (IsRepeatLabSpec(arExaItmID) == 1) {
									$.messager.confirm('确认对话框',arExaItmDesc+' 包含的检验项目与前面已开医嘱的检验项目重复,是否继续开出？', function(r){
										if (r){
											addExaItem(arExaItmID,arExaItmDesc,arEmgFlag);        
										}else{
											/// 取消检查项目复选框
											if ($("#"+arExaItmID).is(":checked")){
												$("#"+arExaItmID).attr("checked",false);
											}
										}
									});
								}else{
									addExaItem(arExaItmID,arExaItmDesc,arEmgFlag);          /// 添加检查项目    增加加急标志  qunianpeng 2018/3/20
								}
							}else{
								/// 取消检查项目复选框
								if ($("#"+arExaItmID).is(":checked")){
									$("#"+arExaItmID).attr("checked",false);
								}
							}
						});
					}else{
						if (IsRepeatLabSpec(arExaItmID) == 1) {
							$.messager.confirm('确认对话框',arExaItmDesc+' 包含的检验项目与前面已开医嘱的检验项目重复,是否继续开出？', function(r){
								if (r){
									addExaItem(arExaItmID,arExaItmDesc,arEmgFlag);        
								}else{
									/// 取消检查项目复选框
									if ($("#"+arExaItmID).is(":checked")){
										$("#"+arExaItmID).attr("checked",false);
									}
								}
							});
						}else{
							addExaItem(arExaItmID,arExaItmDesc,arEmgFlag);          /// 添加检查项目    增加加急标志  qunianpeng 2018/3/20
						}
					}
				}
			}
		},'',false)
}

/// 添加检查项目
function addExaItem(arExaItmID,arExaItmDesc,arEmgFlag){ /// 增加加急标志  qunianpeng 2018/3/20
    var arExaItmID = arExaItmID.replace("_","||");
	/// 接收科室
	var ItemLocID = ""; var ItemLoc = "";
	/// 医生界面调用时,取值格式
	if (DocMainFlag == 1){
		var LocID = mItmMastStr.split("*")[1];
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmRecLoc",{"LocID":LocID},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}else{
		var OpenForAllHosp=0,LogLoc="";
		var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
		var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
		if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
		if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}
	
	/// 标本
	var ItemSpecCode = ""; var ItemSpec = ""; var HavFlag = "";
	runClassMethod("web.DHCAPPExaReportQuery","jsonGetArcItmSpec",{"itmmastid":arExaItmID, "isDefFlag":"Y"},function(jsonString){
	
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			ItemSpecCode = jsonObjArr[0].value;
			ItemSpec = jsonObjArr[0].text;
		}
	},'json',false)
	if (ItemSpecCode == "-1"){
		$.messager.alert("提示:", "检验标本没有维护正确！");
		return false;	
	}
	
	if (isExistItem(arExaItmDesc)){
		$.messager.alert("提示:","已存在相同项目,请核实后再试！");
		return false;
	}

	var arReqDate  = "", uniqueID = ""; //arEmgFlag = ""; 注释arEmgFlag qunianpeng 2018/3/20
	/// 医生界面调用时,取值格式
	if (DocMainFlag == 1){
		arEmgFlag = mItmMastStr.split("*")[0];  /// 加急标志
		arReqDate = mItmMastStr.split("*")[2];  /// 医嘱日期
		uniqueID = mItmMastStr.split("*")[4];   /// 唯一标示
	}
	
	/// 费别
	var BillTypeID = "", BillType = "";
	if (typeof window.parent.frames.BillTypeID != "undefined"){
		BillTypeID = window.parent.frames.BillTypeID;  ///费别ID
		BillType = window.parent.frames.BillType;      ///费别
	}
	// 价格
	var itemprice=""
	runClassMethod("web.DHCAPPInterface","GetExaReqCost",{"itmmastid":arExaItmID, "mPartList":"","EpisodeID":EpisodeID,"mDispID":"",IPid:""},function(jsonString){
		
			if (jsonString != ""){
				itemprice=jsonString
			}
		},'json',false)
	/// 加入已选列表
	var rowobj={ItemID:"", ItemArcID:"", ItemLabel:arExaItmDesc, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:'', 
	ItemExaDispID:'', ItemExaPosiID:'',ItemExaPurp:arExaItmDesc, ItemOpt:'', ItemStat:"核实", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, 
	ItemEmgFlag:arEmgFlag, ItemRemark:'', ItemSpecCode:ItemSpecCode, ItemSpec:ItemSpec, ItemBillTypeID:BillTypeID,ItemBillType:BillType,ItemPrice:itemprice}
	$("#ItemSelList").datagrid('appendRow',rowobj);
	CheckForHidePrintClick();
    
    /// 其他项目
    LoadItmOtherOpt(arExaItmID);
    
	GetExaReqItmCost();   ///  计算检查申请总金额
}

/// 加入项目列表
function addItmSelList(id, text){

	var rowobj={ItemID:id, ItemPart:text, ItemPosiID:'', ItemPosi:'', ItemOpt:''}
	$("#dmPartList").datagrid('appendRow',rowobj);
	CheckForHidePrintClick();
	
	/// 开启行编辑     /// 2016-12-14 bianshuai 开启多行编辑
	var rowsData=$("#dmPartList").datagrid('getRows');
	$("#dmPartList").datagrid('beginEdit', rowsData.length - 1);
}

///  添加项目到已选列表
function addItmToItmSelListNew(){

//	/// 结束编辑
//    if (editRow != ""||editRow == 0) { 
//        $("#dmPartList").datagrid('endEdit', editRow); 
//    }

//	/// 检查方法【医嘱项ID、医嘱项名称】
//	var arExaItmID = "",arExaItmDesc = "";
//	if ($('input[name="ExaItem"]:checked').length){
//		arExaItmID = $('input[name="ExaItem"]:checked').val();                     /// 检查方法ID
//		arExaItmDesc = $('input[name="ExaItem"]:checked').parent().next().text();  /// 检查方法
//	}
	var arExaItmID = $("#arExaItmID").text();     /// 临时存储检查方法ID
	var arExaItmDesc = $("#arExaItmDesc").text(); /// 临时存储检查方法
	var arExaItmID = arExaItmID.replace("_","||");
	
	/// 接收科室
	var ItemLocID = ""; var ItemLoc = "";
	/// 医生界面调用时,取值格式
	if (DocMainFlag == 1){
		var LocID = mItmMastStr.split("*")[1];
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmRecLoc",{"LocID":LocID},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}else{
		var OpenForAllHosp=0,LogLoc="";
		var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
		var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
		if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
		if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID,"OrderDepRowId":LogLoc,"OpenForAllHosp":OpenForAllHosp},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}
	
	/// 检查附加信息
	var rows=$("#dmPartList").datagrid('getRows');
	if (rows.length == 0){
		$.messager.alert("提示:","请先选择部位！");
		return;
	}
	
	$.each(rows, function(index, rowData){
		
		/// 结束编辑
		$("#dmPartList").datagrid('endEdit', index); 
		
		var arExaPartID = rowData.ItemID;         /// 部位ID
		var arExaPartDesc = rowData.ItemPart;     /// 部位
		var arExaPosiID = rowData.ItemPosiID;     /// 体位ID
		var arExaPosiDesc = rowData.ItemPosi;     /// 体位
		var arExaRemark = rowData.ItemRemark;     /// 备注

		var ItemLabel = arExaItmDesc;  /// 检查项目描述
		
		/// 后处理方法
		var arExaDispID = [],arExaDispDesc = [];
		$('input[name="ExaDisp"]:checked').each(function(){
			arExaDispID.push(this.value);
			arExaDispDesc.push($.trim($(this).parent().next().text()));
		})
		arExaDispID = arExaDispID.join("@");
		arExaDispDesc = arExaDispDesc.join("、");
	
		var ItemLabelArr = [];
		
		if (arExaDispDesc != "" ){
			ItemLabel = ItemLabel +" + "+ $.trim(arExaDispDesc);
		}
		if (arExaPartDesc !="" ){
			if (arExaPosiDesc != ""){
				arExaPartDesc = arExaPartDesc +"("+ arExaPosiDesc +")";
			}
			ItemLabelArr.push(arExaPartDesc);
		}
		if (ItemLabelArr.join("、") != ""){
			ItemLabel = ItemLabel + "[" + ItemLabelArr.join("，") + "]";
		}

		if (isExistItem(ItemLabel)){
			$.messager.alert("提示:","已存在相同项目,请核实后再试！");
			return false;
		}
		
		var arReqDate  = "", uniqueID = "", arEmgFlag = "";
		/// 医生界面调用时,取值格式
		if (DocMainFlag == 1){
			arEmgFlag = mItmMastStr.split("*")[0];  /// 加急标志
			arReqDate = mItmMastStr.split("*")[2];  /// 医嘱日期
			uniqueID = mItmMastStr.split("*")[4];   /// 唯一标示
		}
		
		/// 加入已选列表
		var rowobj={ItemID:"", ItemArcID:"", ItemLabel:ItemLabel, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:arExaPartID, ItemExaDispID:arExaDispID, 
		ItemExaPosiID:arExaPosiID,ItemExaPurp:ItemLabel, ItemOpt:'', ItemStat:"核实", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, ItemEmgFlag:arEmgFlag, ItemRemark:arExaRemark}
		$("#ItemSelList").datagrid('appendRow',rowobj);
		CheckForHidePrintClick();
		
	})
	
	clrItmChkFlag();   	  ///  取消检查项目选中状态
	
	$("#dmPartList").datagrid('loadData',{total:0,rows:[]}); /// 清空datagrid
	$('#PopUpWin').window("close");
    
	GetExaReqItmCost();   ///  计算检查申请总金额
	
	/// 确定完成之后,焦点默认到主诉框
	$('#arPatSym').focus();    /// 设置焦点
}

/// 关闭弹出窗口
function closeWin(){
	
	var arExaItmID = $("#arExaItmID").text();
	/// 取消检查项目选中效果 
	$('#'+ arExaItmID).attr("checked",false);
	
	$("#arExaItmID").text("");     /// 临时存储检查方法ID
	$("#arExaItmDesc").text("");   /// 临时存储检查方法
	
	$('#PopUpWin').window("close");
}

/// 其他项目处理
function LoadItmOtherOpot(arReqID, itmmastid){

	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqOthOpt",{"pid":pid, "arReqID":arReqID, "itmmastid":itmmastid},function(jsonString){

		if (jsonString != ""){
			pid = jsonString;
			//showItemOtherOpt();
		}
	},'',false)
	
}

/// 加载注意事项
function LoadItemTemp(itmmastid){

	$("#noteContent").html("");
	runClassMethod("web.DHCAPPExaReportQuery","jsonItemTemp",{"itmmastid" : itmmastid, "HospID" : LgHospID},function(jsonString){
		var jsonObjArr = jsonString;
		for (var i=0; i<jsonObjArr.length; i++){
			showItemTemp(jsonObjArr[i]);
		}
	},'json',false)
}

/// 设置注意事项显示格式
function showItemTemp(itemobj){
	
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="table_title">'+ itemobj.ItemTemp +'</div>';
		htmlstr = htmlstr + '<div style="border-bottom: 1px solid #40a2de;"></div>';
		htmlstr = htmlstr + '<table border="1" cellspacing="0" cellpadding="1" class="report_table">';
		htmlstr = htmlstr + '	<tr>';
		htmlstr = htmlstr + '		<td>';
		htmlstr = htmlstr + '			<div style="margin:10px 5px;font-size:15px;line-height:150%;">';
		htmlstr = htmlstr + '				<p>'+ itemobj.TempText.replace(/<br>/g,'</p><p>') +'</p>';
		htmlstr = htmlstr + '			</div>';
		htmlstr = htmlstr + '		</td>';
		htmlstr = htmlstr + '	</tr>';
		htmlstr = htmlstr + '</table>';
		
	$("#noteContent").append(htmlstr);
}

/// 获取病人的诊断记录数
function GetMRDiagnoseCount(){

	var Count = 0;
	/// 调用医生站的判断
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}

/// 获取医疗结算标志
function GetIsMidDischarged(){

	var MidDischargedFlag = 0;
	/// 调用医生站的判断
	runClassMethod("web.DHCAPPExaReport","GetIsMidDischarged",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			MidDischargedFlag = jsonString;
		}
	},'',false)

	return MidDischargedFlag;
}

/// 获取医生录医嘱权限
function GetDocPermission(arExaItmID){

	var arcitemId = arExaItmID.replace("_","||");
	var DocPerFlag = 0;
	/// 调用医生录医嘱权限
	runClassMethod("web.DHCAPPExaReport","GetDocPermission",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID,"arcitemId":arcitemId},function(jsonString){

		if (jsonString == 1){
			DocPerFlag = jsonString;
		}
	},'',false)

	return DocPerFlag;
}

/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsg(){

	var NotTakOrdMsg = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}else if((parent)&&(parent.IsPatDead=="Y")){
			NotTakOrdMsg="患者已故!";
		}
	},'',false)

	return NotTakOrdMsg;
}

/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsgArc(arExaItmID){

	var arcitemId = arExaItmID.replace("_","||");
	var ErrObject = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsgArc",{"EpisodeID":EpisodeID,"arcitemId":arcitemId,"PPRowId":parent.PPRowId,"AdmReason":window.parent.frames.BillTypeID},function(jsonString){

		if (jsonString != ""){
			ErrObject = jsonString;
		}
	},'json',false)

	return ErrObject;
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
//验证医嘱与慢特病是否匹配
function ChkChronicOrdItm(arExaItmID){
	if (typeof arExaItmID == "undefined"){
		arExaItmID="";
	}
	if (typeof(window.parent.frames.GetChronicDiagCode) === 'function') {
		var ChronicDiagCode=window.parent.frames.GetChronicDiagCode();
		if (ChronicDiagCode!="") {
			var sendArcimStr="";
			if (arExaItmID=="") {
				var selItems=$("#ItemSelList").datagrid('getRows');
				$.each(selItems, function(index, selItem){
					var itmmmastid = selItem.ItemExaID;        /// 医嘱项ID
					if (sendArcimStr=="") sendArcimStr=itmmmastid;
					else  sendArcimStr=sendArcimStr+"^"+itmmmastid;
				})
			}else{
				sendArcimStr=arExaItmID;
			}
			if (sendArcimStr=="") return "";
			var NotMatchMsg=$.cm({
				ClassName:"web.DHCAPPExaReport",
				MethodName:"ISChronicOrdItm",
				dataType:"text",
				AdmDr:EpisodeID,
				ChronicCode:ChronicDiagCode,
				sendArcimStr:sendArcimStr
			},false);
			return NotMatchMsg;
		}
	}
	return "";
}
/// 初始化检查方法内容
function LoadCheckItemByDoc(){

	var arcItemList=mListDataDoc.split("!")[1];
	mItmMastLen = arcItemList.split("@").length; /// 项目
	/// 初始化检查方法区域 包含部位
	$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaItemListDoc",{"arcItemList":arcItemList,"LinkFlag":"1","HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
	
	/// 初始化检查方法区域 不包含部位
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaItemListDoc",{"arcItemList":arcItemList,"LinkFlag":"0","HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			var itemArr = jsonObjArr[0].items;
			for (var i=0; i<itemArr.length; i++){
				//InitInsSelItem(itemArr[i]);  /// 插入已选项目列表
			}
		}
	},'json',false)
	
}

/// 检查申请确认
function sureExaReq(){
	
	if (editSelRow != -1||editSelRow == 0) { 
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	}

	var itemLocFlag = 0; var mItmMastArr = [];
	//var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// 加急 qunianpeng 2018/3/20
	var mItmListData = [];
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		
		var ItemID = selItem.ItemID;               /// 项目ID
		var itmmmastid = selItem.ItemExaID;        /// 医嘱项ID
		var itemLocID = selItem.ItemLocID;         /// 接收科室ID
		var itemLoc = selItem.ItemLoc;             /// 接收科室
		if ((itemLocID == "")||((itemLoc == "")||(typeof itemLoc == "undefined"))){
			itemLocFlag = 1;
			return false;
		}
		var itemExaPosiID = selItem.ItemExaPosiID; /// 体位ID
		var itemExaPartID = selItem.ItemExaPartID; /// 部位ID
		var itemExaDispID = selItem.ItemExaDispID; /// 后处理ID

		///var itemExaPurp = selItem.ItemExaPurp;  /// 检查目的
		var itemExaPurp = selItem.ItemLabel;	   /// 检查目的
		var arReqDate = selItem.ItemReqDate;	   /// 医嘱日期
		var uniqueID = selItem.ItemUniqueID;	   /// 唯一标示
		var arEmgFlag = selItem.ItemEmgFlag;	   /// 加急标志
		
		var itemRemark = selItem.ItemRemark;	   /// 备注

		if ($.inArray(itmmmastid+"^"+uniqueID,mItmMastArr) == "-1"){
			mItmMastArr.push(itmmmastid+"^"+uniqueID);
		}
		
		var ListData = EpisodeID +"^"+ itemLocID +"^"+ arEmgFlag +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ "" +"^"+ "" +"^"+ LgCtLocID +"^"+ "" +"^"+ "N" ;
			ListData = ListData +String.fromCharCode(2)+ itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID +"^"+ arReqDate +"^"+ uniqueID +"^"+ arEmgFlag +"^"+ itemRemark;

		mItmListData.push(ListData);
	})
	
	/// 项目不一致时，进行提示
	if (mItmMastArr.length != mItmMastLen){
		GetTmpItmMastTip(mItmMastArr);
		return;
	}
	
	if (itemLocFlag == 1){
		$.messager.alert("提示:","接收科室不能为空！");
		return;
	}
	
	mItmListData = mItmListData.join(String.fromCharCode(1));

	if (mItmListData == ""){
		$.messager.alert("提示:","没有待发送项目,请选择检查项目后重试！");
		return;
	}
	
	/// 保存模板数据
	runClassMethod("web.DHCAPPExaReport","saveDoc",{"pid":pid, "ListData":mItmListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","检验申请单发送失败，失败原因:"+jsonString);
		}else{
			window.returnValue = jsonString;
			window.close();
		}
	},'',false)
	

}

/// 取消检查项目选中状态
function clrItmChkFlag(){
	
	var arExaItmID = $("#arExaItmID").text();
	/// 取消检查项目选中效果 
	$('#'+ arExaItmID).attr("checked",false);
	
	$("#arExaItmID").text("");     /// 临时存储检查方法ID
	$("#arExaItmDesc").text("");   /// 临时存储检查方法
}

/// 验证病人是否允许开医嘱
function initPatNotTakOrdMsg(){
	
	TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg);
		return;	
	}
}

/// 一天内是否重复开设过此项目
function IsRepeatOneday(arExaItmID, PartID){

	var arcitemId = arExaItmID.replace("_","||");
	var isRepFlag = 0;
	/// 调用医生录医嘱权限
	runClassMethod("web.DHCAPPExaReport","IsRepeatOneday",{"EpisodeID":EpisodeID,"Inarcimid":arcitemId,"InPartID":PartID},function(jsonString){

		if (jsonString == 1){
			isRepFlag = jsonString;
		}
	},'',false)

	return isRepFlag;
}
/// 判断检验项目是否重复
function IsRepeatLabSpec(arExaItmID) {
	var isRepFlag=0;
	var arcitemId = arExaItmID.replace("_","||");
	var ArcimInfo="";
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		var ItemID = selItem.ItemID;               /// 项目ID
		var itmmmastid = selItem.ItemExaID;        /// 医嘱项ID
		var itemSpecCode = selItem.ItemSpecCode;   /// 标本
		if ((ItemID=="")&&(itmmmastid!="")){
			if (ArcimInfo=="") {
				ArcimInfo=itmmmastid+String.fromCharCode(1)+itemSpecCode;
			}else{
				ArcimInfo=ArcimInfo+"^"+itmmmastid+String.fromCharCode(1)+itemSpecCode;
			}
		}
	})
	if (ArcimInfo=="") return isRepFlag;
	isRepFlag=$.cm({
		ClassName:"web.DHCAPPExaReport",
		MethodName:"IsRepeatLabSpec",
		Inarcimid:arcitemId,
		ArcimInfo:ArcimInfo,
	},false);
	return isRepFlag;
}
/// 调用知识库检查项目
function InvokItmLib(){

	var del= String.fromCharCode(2);
	var mListData = [];
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		
		var itmmmastid = selItem.ItemExaID;        /// 医嘱项ID
		var itemLocID = selItem.ItemLocID;         /// 接收科室ID
		var itemExaPosiID = selItem.ItemExaPosiID; /// 体位ID
		var itemExaPartID = selItem.ItemExaPartID; /// 部位ID
		var itemExaDispID = selItem.ItemExaDispID; /// 后处理ID

		var ListData =itmmmastid +"^"+ itemExaPartID;

		mListData.push(ListData);
	})
	mListData = mListData.join(del);

	if (mListData == ""){
		return;
	}

	var retFlag = false;
	/// 用户信息
	var userInfo = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","InvokItemLibrary",{"EpisodeID":EpisodeID, "mListData":mListData, "userInfo":userInfo},function(jsonObj){
		if (jsonObj != null){
			if (jsonObj[0].passFlag == 1){
				retFlag = true;
			}else{
				retFlag = false;
				FunUpWin(jsonObj[0]);
			}
		}
	},'json',false)
	
	return retFlag;
}

/// 知识库内容弹窗
function FunUpWin(jsonObj){

	/// 调用医嘱项列表窗口
	var option = {
		buttons:[{
				text:'确认',
				iconCls:'icon-edit',
				handler:function(){
					if (jsonObj.manLevel == "W"){
						$('#FunUpWin').dialog('close');
						/// 发送检查申请
						sendExaReqDetail(); 
					}else{
						$.messager.alert("提示:","申请包含管控项目，不允许发送！");
						return;
					}
				}
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function(){
					$('#FunUpWin').dialog('close');
				}
			}]
	};
	//new WindowUX("知识库检测信息", "FunUpWin", "760", "360" , option).Init();
	new DialogUX("知识库检测信息", "FunUpWin", "760", "360" , option).Init();
	
	/// 初始化知识库信息描述
	initMedLibTip(jsonObj); 
}

/// 初始化知识库信息描述
function initMedLibTip(jsonObj){
	
	$("#TmpFunLib").html("");
	var htmlstr = '';
	var itmArr = jsonObj.retMsg;
	    htmlstr = "<div class='libtitle' style='border-bottom: 1px solid #ccc;padding-top: 3px;'>共["+itmArr.length+"]条</div>";
	for(var i=0; i<itmArr.length; i++){
		var bkcolor = "#DDDDDD";
		if (itmArr[i].level == "C"){
			bkcolor = "red";
		}
		htmlstr = htmlstr + "<div class='table_title' style='margin:5px 0 0 7px;border-bottom: 1px solid #ccc;	font-weight:bold;padding: 3px 0 0 5px;background-color:"+ bkcolor +"'>第"+(i+1)+"条</div>";
		htmlstr = htmlstr + "<table  cellpadding='0' cellspacing='0' class='medicontTb'><tr><td style='background-color:#F6F6F6;width:120px' >〖检查项目〗</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+itmArr[i].geneDesc+"["+itmArr[i].pointer+"]</td></tr>";
		var itmSubArr = itmArr[i].chlidren;
		for(var j=0; j<itmSubArr.length; j++){
			htmlstr = htmlstr + "<tr><td style='background-color:#F6F6F6;width:120px;' >〖"+itmSubArr[j].labelDesc+"〗</td><td style='border-right:solid #E3E3E3 1px' colspan='2' >"+itmSubArr[j].alertMsg+"</td></tr>";
		}
		htmlstr = htmlstr + "</table>";
	}
    $("#TmpFunLib").append(htmlstr);
}

/// 弹出诊断窗口
function DiagPopWin(){
	
	var PatientID = $("#PatientID").text();  /// 病人ID
	var mradm = $("#mradm").text();			 /// 就诊诊断ID

	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	//window.open(lnk,"_blank","top=100,left=100,width=700,height=350,menubar=yes,scrollbars=no,toolbar=no,status=no");
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

/// 判断发送项目是否与开立项目一致时的提示内容
function GetTmpItmMastTip(mItmMastArr){
	
	var TmpItmMastTipArr = [];
	for(var x=0;x<mItmMastLen;x++){
		var itmmmastid = mItmMastDocArr[x].split("*")[3]; /// 医嘱项ID
		var itmmmastid = itmmmastid.replace("_","||");
		var uniqueID = mItmMastDocArr[x].split("*")[4];	  /// 唯一标示
		var itmmmast = mItmMastDocArr[x].split("*")[5];   /// 项目名称
		if ($.inArray(itmmmastid+"^"+uniqueID,mItmMastArr) == "-1"){
			TmpItmMastTipArr.push(itmmmast);
		}
	}
	$.messager.alert("提示:","项目："+TmpItmMastTipArr.join("、")+"未选择部位，请点击选择部位！");
	return;
}

/// 取检查申请是否可以单部位撤销标志
function GetPartTarFlag(rowIndex){
	
	var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
	rowData.ItemArcID
	var PartTarFlag = 0;
	/// 调用医生录医嘱权限
	runClassMethod("web.DHCAPPExaReport","GetPartTarFlag",{"arPartID":rowData.ItemArcID},function(jsonString){

		PartTarFlag = jsonString;
	},'',false)

	return PartTarFlag;
}

/// 医嘱的性别/年龄限制
function GetItmLimitMsg(arExaItmID){
	
	var LimitMsg = 0;
	var itmmastid = arExaItmID.replace("_","||");
	/// 医嘱的性别/年龄限制
	runClassMethod("web.DHCAPPExaReport","GetItmLimitMsg",{"EpisodeID":EpisodeID, "itmmastid":itmmastid},function(jsonString){

		LimitMsg = jsonString;
	},'',false)
	
	return LimitMsg;
}

/// 初始化添加 div格式
function initDivHtml(){
	
	var html  = "<div id='itro_win'  class='div-notes' style='border-radius:3px; display:none; border:2px solid #20A0FF; background:#FFF; position:absolute; width:700px; height:300px;'>";
	    /// 标题栏
		html += "	<div id='itro_title_bar' style='width:100%; height:35px; background:#20A0FF;color:#fff;font-weight:bold;'>";
		html += "		<div id='itro_title' style='padding:8px;text-align:center'></span></div>";
		html += "	</div>"
		/// 内容区
		html += "	<div id='itro_content' style='width:100%; height:260px; overflow:auto;'>";
		html += "	</div>"
		html += "</div>"
	$('body').append(html);
}

/// 检查项目说明书
function initItemInstrDiv(){

	var TarEl = 'td[field="ItemLabel"]';   /// 目标元素
	initDivHtml();   					   /// 初始化添加 div格式
	//$("#itro_title").text(itro_title);     /// div层 标题
	//$("#itro_content").text(itro_content); /// div层 内容
	
	/// 鼠标滑动事件
	//$(TarEl).on('mousemove',function(){//对按钮的处理
	$(".datagrid-body").on('mousemove','td[field="ItemLabel"]',function(){//对按钮的处理 
		$(this).removeClass("hover1");
		
		/// 行索引
		var rowIndex = $(this).parent().attr("datagrid-row-index");
		var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
		$("#itro_title").text(rowData.ItemLabel +" - "+ "说明书");  /// div层 标题
		var itmmmastid = rowData.ItemExaID;        /// 医嘱项ID
		var itemPartID = rowData.ItemExaPartID;    /// 部位ID
		var ed=$("#ItemSelList").datagrid('getEditor',{index:rowIndex,field:'ItemSpecCode'});
		if (ed)	{
			var OrderLabSpecRowid=$(ed.target).val();
		}else{
			var OrderLabSpecRowid=rowData.ItemSpecCode;
		}
		var itemHtml = GetItemInstr(itmmmastid, itemPartID, OrderLabSpecRowid);
		if (itemHtml == "") return;
		$("#itro_content").html(itemHtml); 		   /// div层 内容
		
		$(".div-notes").css({
			top : ($(this).parent().offset().top + $(this).outerHeight() - 10) + 'px',
			left : (event.clientX + 10) + 'px',
			'z-index' : 9999
		}).show();
	})
	
	/// 鼠标滑动离开事件
	//$(TarEl).on('mouseleave',function(){//对按钮的处理
	$(".datagrid-body").on('mouseleave','td[field="ItemLabel"]',function(){
		var divThis = $(".div-notes"); 
		setTimeout(function(){ 
			if (divThis.hasClass("hover0")) {//说明没有从按钮进入div
				divThis.hide(); 
			}
	     }, 100); 
		$(this).addClass("hover1");	
	});
	
	/// div 变量样式添加
	$(".div-notes").hover(function(){//div
		$(this).removeClass("hover0");
	},function(){
		$(this).addClass("hover0"); 
		var anniu = $('td[field="ItemLabel"]'); 
		var tthis = $(this); 
		setTimeout(function(){ 
			if(anniu.hasClass("hover1")){//说明没有从div回到按钮
				tthis.hide(); 
			}
		},100); 
	})
}
/// 提取检查项目说明书
function GetItemInstr(itmmastid, itemPartID, OrderLabSpecRowid){
	var html = '';
	// 获取显示数据
	runClassMethod("web.DHCAPPExaReportQuery","GetItemInstr",{"itmmastid":itmmastid, "itemPartID":itemPartID, "OrderLabSpecRowid":OrderLabSpecRowid},function(jsonString){

		if (jsonString != ""){
			var jsonObject = jsonString;
			html = initMedIntrTip(jsonObject);
		}else{
			html = "";
		}
	},'json',false)
	return html;
}

/// 初始化知识库信息描述
function initMedIntrTip(itmArr){
	
	var htmlstr = '';
	for(var i=0; i<itmArr.length; i++){
		
		htmlstr = htmlstr + "<table  cellpadding='0' cellspacing='0' class='itro_content'>" //<tr><td style='background-color:#F6F6F6;width:120px' >〖检查项目〗</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+itmArr[i].geneDesc+"["+itmArr[i].pointer+"]</td></tr>";
		htmlstr = htmlstr + "<tr><td style='background-color:#F6F6F6;font-weight:bold; font-size:14px;'>"+itmArr[i].itemTile+"</td></tr>";
		htmlstr = htmlstr + "<tr><td style='border-right:solid #E3E3E3 1px; font-size:14px; padding-left: 10px;'>"+itmArr[i].itemContent+"</td></tr>";
		htmlstr = htmlstr + "</table>";
	}

   return htmlstr;
}

/// 加载申请单内容
function LoadReqFrame(arRepID, repEmgFlag){
	
	$('#arEmgFlag').prop("checked",repEmgFlag=="是"?true:false);   ///sufan 2018-01-30
	$("#ItemSelList").datagrid("load",{"params":arRepID});
	LoadItmOtherOpot(arRepID, arRepID); /// 加载其他项目
	arExaReqIdList = arRepID;
	InitGetReqEditFlag(arRepID);  /// 申请单是否允许编辑
	LoadInsurFlag(arRepID); //初始化医保标识
}
function LoadInsurFlag(arRepID){
	runClassMethod("web.DHCAPPExaReport","GetExaInsuFlag",{"arRepID":arRepID},function(data){
		var value=data==1?true:false;
		parent.$HUI.checkbox("#InsurFlag").setValue(value);
	},'',false)
}
/// 申请单是否允许编辑
function InitGetReqEditFlag(ID){

	var LgParams = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","JsGetReqEditFlag",{"ID":ID, "Type":"", "LgParams":LgParams},function(jsonString){
		if (jsonString != ""){
			isPageEditFlag = jsonString;
			PageEditFlag(jsonString);
		}
	},'',false)
}

/// 设置界面编辑状态
function PageEditFlag(Flag){
	
	if (Flag == 0){
		$('#bt_sendreq').linkbutton('disable');   /// 发送按钮隐藏
		$('#bt_sendreq').removeClass('btn-lightgreen');
	}else{
		$('#bt_sendreq').linkbutton('enable');      /// 发送按钮隐藏
		$('#bt_sendreq').addClass('btn-lightgreen');
	}
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	window.parent.mMainSrc="L";
	if (itemReqID != ""){
		LoadReqFrame(itemReqID, repEmgFlag);
	}
}

/// 加急标志控制 qunianpeng 2018/3/20 
function emgFlagControl(value,row,index){	
	switch(value){	// Y/N 控制能不能勾选(医嘱项标识)   1/0 控制是否已经勾选（医嘱表加急标志）
		case "Y":
			return '<input type=\'checkbox\' id=\'CK_EmFlag'+index+'\' onclick=\'setCheckFlag('+index+')\'/>';
		case "N":
			return '<input type=\'checkbox\' disabled  id=\'CK_EmFlag'+index+'\'/>';
		case "1":
			return '<input type=\'checkbox\' disabled  id=\'CK_EmFlag'+index+'\' checked=\'checked\' />';
		case "0":
			return '<input type=\'checkbox\' disabled  id=\'CK_EmFlag'+index+'\' />';
		case "C":
			return '<input type=\'checkbox\' id=\'CK_EmFlag'+index+'\' checked=\'checked\' onclick=\'setCheckFlag('+index+')\'/>';				
	}	
}				

/// 设置rowsData值
function setCheckFlag(index){
	
	var rowsData = $("#ItemSelList").datagrid('getRows');
	rowsData[index].ItemEmgFlag = ($("#CK_EmFlag"+index).is(":checked")?"C":"Y");
}
function CheckForHidePrintClick(){
	var PrintFlag=0
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		var itmmmastid = selItem.ItemExaID;           /// 医嘱项ID
		var ItemArcID = selItem.ItemArcID; 
		var PrintFlagRtn=$.cm({
			ClassName:"web.DHCAPPPrintCom",
			MethodName:"GetAllPrinttemp",
			dataType:"text",
			itmArcCatID:ItemArcID,
			ItemExaID:itmmmastid,
		},false);
		if (PrintFlagRtn!=""){PrintFlag=1}
	
	})
	if (PrintFlag==0){
	$("#bt_printreq").hide();//linkbutton("disable");
	}else{$('#bt_printreq').show();  }
	}
window.onload = onload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

/// 查找检查方法
function searchItem(event){
	
	var item=$.trim($("#item").val());
	if (item != ""){
		LoadItemList(item);
	}
}
/// 加载检查方法列表
function LoadItemList(item){
	
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');

	runClassMethod("web.DHCAPPExaReportQuery","jsonLabItemList",{"item":item,"HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}
//记录基础代码数据使用次数
function DHCDocUseCount(ValueId, TableName) {
    var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
}
window.onbeforeunload = function(event) { 
	 var RtnFlag=""
    var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		
		var ItemID = selItem.ItemID;               /// 项目ID
		var itmmmastid = selItem.ItemExaID;        /// 医嘱项ID
		var oeori = selItem.oeori; 
		if ((itmmmastid!="")&&(ItemID=="")){
			RtnFlag=1
		}
	})
	if (itemReqID ==""){
		if (RtnFlag == "1"){
			return "还未保存的医嘱，是否离开此界面"
		}else{
			return;	
		}
	}else{ 
		return ;
	}
}

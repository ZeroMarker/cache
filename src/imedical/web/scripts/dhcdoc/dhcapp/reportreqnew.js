//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2016-07-05
// 描述:	   新版检查申请
//===========================================================================================

var EpisodeID = "";      /// 病人就诊ID
var arItemCatID = "";    /// 检查分类ID
var itemSelFlag = "";    /// 已选列表当前状态值
var arExaReqIdList = "";
var editRow = ""; var editSelRow="";
var repStatusArr = [{"value":"V","text":'核实'}, {"value":"D","text":'停止'}];

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
/// 页面初始化函数
function initPageDefault(){
		
	InitPatEpisodeID();   /// 初始化加载病人就诊ID
	
	initVersionMain();    ///  页面兼容配置
	
	initDataGrid();  	  ///  页面DataGrid初始定义
	initItemSelList();    ///  页面DataGrid初始定义
	//initCheckPartTree();  ///  初始化检查部位树
	initCombobox();       ///  页面Combobox初始定义
	initBlButton();       ///  页面Button绑定事件
	initCheckBoxEvent();  ///  页面CheckBox事件
	initCombogrid();      ///  页面Combogrid事件
	
	GetPatBaseInfo();     ///  加载病人信息
	LoadExaReqHisSign();  ///  加载病人现病史和体征
		
	LoadPageBaseInfo();   ///  初始化加载基本数据
	
	initPatNotTakOrdMsg(); /// 验证病人是否允许开医嘱
	initItemInstrDiv();    /// 检查项目说明书
}

/// 页面兼容配置
function initVersionMain(){

	/// 弹出界面为旧版时,检查申请采用新版录入界面
	if (DocMainFlag == 1){
		version = 1;
	}
	
    <!-- 新旧版本兼容配置 -->
    if (version == 1){
	    
	    /// 新版时,隐藏检索区域
		//$("#ItemPanel").layout('remove','north');
		initCheckPartTreeNew();  ///  初始化检查部位树
	}else{
		initItemListOLD();       ///  页面DataGrid检查分类列表
		initCheckPartTree();     ///  初始化检查部位树
	}
	
	/// 医生界面调用时,初始化内容
	if (DocMainFlag == 1){
		/// 设置界面按钮内容
		//$('button:contains("发送")').text("确认");
		$('button:contains("打印")').text("关闭");
		/// 隐藏【本次就诊申请单列表】、【检查项目】
		$('#MainPanel').layout('hidden','west');  /// 【本次就诊申请单列表】
		$('#CenPanel').layout('hidden','west');   /// 【检查项目】
		$('#arPatSym').focus();    /// 设置焦点
		$('#arEmgFlag').parent().parent().hide(); /// 加急标志隐藏
	}else{
		$('#ExaCatCode').focus();  /// 设置焦点
	}
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
	CloseFlag = getParam("CloseFlag");
	
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
}

///  初始化加载基本数据
function LoadPageBaseInfo(){
	
	/// 初始化加载数
	<!-- 新旧版本兼容配置 -->
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+LgHospID;
	if (version == 1){
		uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+LgHospID;
	}
	if ((version == 1)&(expFlag == 1)){
		uniturl = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID;
	}

	$('#CheckPart').tree('options').url = uniturl;
	$('#CheckPart').tree('reload');
	
	/// 历史申请单数据
	//var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqHisList&params="+EpisodeID;
	//$('#dgEmPatList').datagrid({url:uniturl});
	
	/// 检查分类列表
	if (version != 1){
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckItemList";
		$('#itemList').datagrid({url:uniturl});
	}
	
	/// 已选项目列表
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqDetList";
	$('#ItemSelList').datagrid({url:uniturl});
	
	/// 医生界面调用时,初始化内容
	if (DocMainFlag == 1){
		LoadCheckItemByDoc();   /// 初始化检查方法内容
	}
	
}

/// 病人就诊信息
function GetPatBaseInfo(){
	runClassMethod("web.DHCAPPExaReportQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
		})
	},'json',false)
}

/// 页面DataGrid初始定义
function initDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'PatLabel',title:'申请单',width:180,formatter:setCellLabel,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	        itemSelFlag = 1;  /// 已选列表当前状态值
	        /// 申请单已选列表
	        var params = rowData.arRepID;
			$("#ItemSelList").datagrid("load",{"params":params});
			
			$('#arEmgFlag').attr("checked",rowData.repEmgFlag=="是"? true:false);
			
			/// 加载其他项目
			LoadItmOtherOpot(rowData.arRepID,rowData.arRepID);
			
			arExaReqIdList = rowData.arRepID;
	    },
		onLoadSuccess:function(data){
			///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            BindTips(); /// 绑定提示消息
		},
		rowStyler:function(index,rowData){   
	        if (rowData.repStatCode == "停止"){
	            return 'background-color:Pink;'; 
	        }
	    }
	};

	var params = EpisodeID +"^^^"+ LgHospID;
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqHisList&params="+params;
	new ListComponent('dgEmPatList', columns, uniturl, option).Init();
	
	///  隐藏刷新按钮
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false}); 
	
	///  隐藏分页图标
    var panel = $("#dgEmPatList").datagrid('getPanel').panel('panel');  
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide()
}

/// 申请列表 卡片样式
function setCellLabel(value, rowData, rowIndex){
	
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.arExaReqCode +'</h3><h4 style="float:left;padding-left:10px;background-color:transparent;">'+ rowData.arReqData+'</h4><h3 style="float:right;color:red;background-color:transparent;"><span>'+ rowData.repStatCode +'</span></h3><br>';
		/*
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.arReqData +'</h4>';
		
		if (rowData.repStatCode != "停止"){
		    htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px"><a href="#" onclick="showItmDetWin('+rowData.arRepID+')">预约</a>&nbsp;&nbsp;&nbsp;<a href="#" onclick="showItmRetWin('+rowData.Oeori+')">结果</a></span></h4>';
		}
		*/
		/// 循环拆分检查项目
		var TempList = rowData.arcListData;
		var TempArr = TempList.split("#");
		for (var k=0; k < TempArr.length; k++){
			var TempCArr = TempArr[k].split("&&");
			var TempCText=""; /// 项目全称
			if (TempCArr[1].length > 7){
				TempCText = TempCArr[1];					   /// 检查项目全称 用于提示
				TempCArr[1]=TempCArr[1].substring(0,6)+"...";  /// 检查项目仅显示7个字符
			}
			var FontColor = "";
			if (TempCArr[2] == "IM"){ 
				FontColor="#FF69B4";    /// 检查项目有报告返回,显示红色字体
			}

			htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px;color:'+FontColor+'" name="'+TempCText+'">'+ TempCArr[1] +'</span></h4>';
			htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px">';
			/// 是否需要预约
			if (TempCArr[3] == "Y"){
				htmlstr = htmlstr + '<a href="#" onclick="showItmDetWin('+rowData.arRepID+')">预约</a>';
			}
			htmlstr = htmlstr + '&nbsp;&nbsp;&nbsp;<a href="#" onclick="showItmRetWin(\''+TempCArr[0]+'\')">结果</a></span></h4><br>';
		}
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// 检查项目绑定提示栏
function BindTips(){
	var html='<div id="tip" style="border-radius:3px; display:none; border:1px solid #000; padding:10px;position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	/// 鼠标离开
	$('h4 span').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('h4 span').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			if ($(this).attr("name").length <= 7){  //.text()
				return;
			}
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.7
			}).text($(this).attr("name"));    // .text()
		}
	})
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
			url: '', //LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID=11207||1",
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
		{field:'ItemRemark',title:'备注',width:100,editor:texteditor},
		{field:'ItemStat',title:'当前状态',width:100,align:'center'},
		{field:'ItemBilled',title:'计费状态',width:100,hidden:true},
		{field:'ItemReqDate',title:'医嘱日期',width:100,hidden:true},
		{field:'ItemUniqueID',title:'唯一标示',width:100,hidden:true},
		{field:'ItemEmgFlag',title:'加急标志',width:100,hidden:true},
		{field:'ItemTarItm',title:'收费项目',width:100,align:'center',formatter:SetCellTarUrl},
		{field:'ItemXUser',title:'撤销人',width:100,align:'center'},
		{field:'ItemXDate',title:'撤销日期',width:100,align:'center'},
		{field:'ItemXTime',title:'撤销时间',width:100,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: false,
		onClickRow:function(rowIndex, rowData){

			/// 检查目的
	        LoadArcItemPurp(rowData.ItemExaPurp);
	        
	        /// 加载注意事项
	        LoadItemTemp(rowData.ItemExaID);
	    },
		onLoadSuccess:function(data){

			//itemSelFlag = 1;    /// 已选列表当前状态值
			GetExaReqItmCost();   /// 计算检查申请总金额
			var selItems=$("#ItemSelList").datagrid('getRows');
			if (selItems != ""){
				LoadArcItemPurp(selItems[0].ItemExaPurp);
			}

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
			var unitUrl=LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+rowData.ItemExaID;
			$(ed.target).combobox('reload',unitUrl);
        }
	};

	var uniturl = ""; //LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqDetList";
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
		var html = "<a href='#' onclick='revItmSelRow("+rowIndex+")'>撤销</a>";
	}
    return html;
}

/// 删除行
function delItmSelRow(rowIndex){
	
	$.messager.confirm('确认对话框','确定要删除该项吗？', function(r){
		if (r){
			/// 删除检查项目
			var rowData=$("#ItemSelList").datagrid('getData').rows[rowIndex];
			delExaReqItm(rowData.ItemArcID,rowData.ItemExaID,rowData.ItemExaPartID);
			/// 删除行
			$("#ItemSelList").datagrid('deleteRow',rowIndex);
			var arExaItmID = rowData.ItemExaID.replace("||","_"); /// 检查项目
			/// 取消检查项目复选框
			if ($("#"+arExaItmID).is(":checked")){
				$("#"+arExaItmID).attr("checked",false);
			}
			//CalExaReqCost();    ///  计算检查申请总金额
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
			if (rowData.ItemBilled == "P"){
				$.messager.alert("提示:","项目已收费，不允许撤销！");
				return;
			}
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
			$("#dgEmPatList").datagrid("reload");   /// 刷新页面数据
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
			$.messager.alert("提示:","您无权执行该操作！");
			return;
		}
	    if (jsonString < 0){
			$.messager.alert("提示:","删除错误,错误信息:"+jsonString);
			return;
		}
	    if (jsonString == 0){
			delExaReqOthOpt(itmmastid);
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

/// 页面DataGrid初始定义检查分类列表
function initItemListOLD(){
	
	///  定义columns
	var columns=[[
		{field:'Select',title:'选择',width:40,formatter:SetCellCheckBox},
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'ItemCode',title:'ItemCode',width:100,hidden:true},
		{field:'ItemDesc',title:'项目名称',width:450},
		{field:'ItemPartID',title:'部位ID',width:100,hidden:true},
		{field:'ItemPart',title:'部位',width:100,hidden:true},
		{field:'ItemPrice',title:'单部位价格',width:100,hidden:true}
	]];

	///  定义datagrid
	var option = {
		rownumbers : false,
		singleSelect : false,
		onClickRow:function(rowIndex, rowData){
			
			/// 当前行选中/取消状态
			var selectflag=$("#itemList").datagrid('getPanel').find('[datagrid-row-index='+rowIndex+']').hasClass("datagrid-row-selected");
			if (selectflag){
				addItmToItmSelList(rowIndex);
				$("[name='ItmCheckBox'][value='"+ rowIndex+"']").attr("checked",true);
			}else{
				delItmFromItmSelList(rowIndex);
				$("[name='ItmCheckBox'][value='"+ rowIndex+"']").attr("checked",false);
			}
	    },
		onLoadSuccess:function(data){
			/// 加载完成后如果仅有一项,直接选中
			var rows = $("#itemList").datagrid('getRows');
			if (rows.length > 0){
				//$('#ItemList').datagrid('selectRow',0);
				//LoadArcItemRecLoc(rows[0].ItemID);
			}
			/// 已添加到已选列表的项目，动态设置选中状态
			$.each(rows, function(index, selItem){
				if (GetCurItmIsSelect(selItem.ItemID, selItem.ItemPartID)){
					$('#itemList').datagrid('selectRow',index);
					$("[name='ItmCheckBox'][value='"+ index+"']").attr("checked",true);
				}
			})
		}
	};

	var params = "";
	var uniturl = ""; //LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryCheckItemList&params"+ params;
	new ListComponent('itemList', columns, uniturl, option).Init(); 

}

/// 复选框
function SetCellCheckBox(value, rowData, rowIndex){

	var html = '<input name="ItmCheckBox" type="checkbox" value='+rowIndex+'></input>';
    return html;
}

/// 初始化检查部位树
function initCheckPartTree(){

	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	        var isLeaf = $("#CheckPart").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        var itemCatID = node.id; 		/// 检查分类ID
				var params = itemCatID;
				$("#itemList").datagrid("load",{"params":params});
	        }else{
		    	$("#CheckPart").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    }
	    }
	};
	new CusTreeUX("CheckPart", '', option).Init();
}

/// 初始化检查部位树
function initCheckPartTreeNew(){

	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	       
	        var isLeaf = $("#CheckPart").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        var itemCatID = node.id;       /// 检查分类ID
				LoadCheckItemList(itemCatID);  /// 加载检查方法列表
	        }else{
		    	$("#CheckPart").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    }
	    },
	    onExpand:function(node, checked){
			var childNode = $("#CheckPart").tree('getChildren',node.target)[0];  /// 当前节点的子节点
	        var isLeaf = $("#CheckPart").tree('isLeaf',childNode.target);        /// 是否是叶子节点
	        if (isLeaf){
		        var itemCatID = node.id;       /// 检查分类ID
				LoadCheckItemList(itemCatID);  /// 加载检查方法列表
	        }
		}
	};
	new CusTreeUX("CheckPart", '', option).Init();
}

/// 加载检查方法列表
function LoadCheckItemList(itemCatID){
	
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
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
		htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px"><input id="'+ itemArr[j-1].value +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itemobj.id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
		/// 医生界面调用时,初始化内容
		if (DocMainFlag == 1){
			/// 用于发送时，判断发送项目是否与开立项目一直
			mItmMastDocArr.push(itemArr[j-1].value +"*"+ itemArr[j-1].text);
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(htmlstr+itemhtmlstr)
}

/// 页面Combobox初始定义
function initCombobox(){

	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";

	/// 检查分类
	var option = {
        onSelect:function(option){

	        var arItemCatID = option.value; /// 检查分类ID
			
	        var repStatusID = $("#repStatus").combobox('getValue'); /// 报告状态
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var tmpEpisodeID = $('#AdmHis').combogrid('getValue');  /// 就诊ID
	        if (tmpEpisodeID == ""){
		    	tmpEpisodeID = EpisodeID;   
		    }
			var params = tmpEpisodeID +"^"+ arItemCatID +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue != ""){
		    	return;
		    }
		    var repStatusID = $("#repStatus").combobox('getValue'); /// 报告状态
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var tmpEpisodeID = $('#AdmHis').combogrid('getValue');  /// 就诊ID
	        if (tmpEpisodeID == ""){
		    	tmpEpisodeID = EpisodeID;   
		    }
			var params = tmpEpisodeID +"^"+ "" +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    }
	};
	var url = uniturl+"jsonExaCat&HospID="+LgHospID;
	new ListCombobox("itemCatID",url,'',option).init();

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
	
	/// 报告状态
	var option = {
		panelHeight:"auto",
        onSelect:function(option){

	        var repStatusID = option.value; /// 报告状态Code
			var itemCatID = $("#itemCatID").combobox('getValue'); /// 检查分类ID
			if (typeof itemCatID == "undefined"){
		    	itemCatID = "";
		    }
			var tmpEpisodeID = $('#AdmHis').combogrid('getValue');
			if (tmpEpisodeID == ""){
		    	tmpEpisodeID = EpisodeID;
		    }
	        /// 检查方法
			var params = tmpEpisodeID +"^"+ itemCatID +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue != ""){
		    	return;
		    }
			var itemCatID = $("#itemCatID").combobox('getValue'); /// 检查分类ID
			if (typeof itemCatID == "undefined"){
		    	itemCatID = "";
		    }
			var tmpEpisodeID = $('#AdmHis').combogrid('getValue');
			if (tmpEpisodeID == ""){
		    	tmpEpisodeID = EpisodeID;
		    }
	        /// 检查方法
			var params = tmpEpisodeID +"^"+ itemCatID +"^"+ "" +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    }
	};
	new ListCombobox("repStatus",'',repStatusArr,option).init();
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	///  加入
	//$('button:contains("确认")').bind("click",addItemSelList);
	//$('a:contains("确认")').bind("click",addItemSelList);
	
	///  发送
	$('button:contains("发送")').bind("click",sendExaReq);
	
	///  打印
	$('button:contains("打印")').bind("click",printExaReq);
	
	///  拼音码
	$("#ExaItmCode").bind("keypress",findExaItemList);
	
	///  拼音码
	$("#ExaCatCode").bind("keyup",findExaItmTree);
	
	///  其他项目 checkbox
	//$("#TmpOtherOpt input[type='checkbox']").live("click",setOtherOpt);
	$("#TmpOtherOpt").on("click","input[type='checkbox']",setOtherOpt); /// JQuery 2.2.4
	
	///  其他项目 text
	//$("#TmpOtherOpt input[name='Input']").live('change',setOtherOpt);
	$("#TmpOtherOpt").on("change","input[name='Input']",setOtherOpt); /// JQuery 2.2.4
	
	//$("#itemList .checkbox").live("click",selectExaItem);
	$("#itemList").on("click",".checkbox",selectExaItem); /// JQuery 2.2.4
	
	///  确认
	$('a:contains("确认")').bind("click",addItmToItmSelListNew);
	
	///  取消
	$('a:contains("取消")').bind("click",closeWin);
	
	///  确认
	$('button:contains("确认")').bind("click",sureExaReq);
	
	///  关闭
	$('button:contains("关闭")').bind("click",closePopWin);
}

/// 初始化页面CheckBox事件
function initCheckBoxEvent(){

	//$("input[type=checkbox]").live('click',function(){
	$("body").on('click',"input[type=checkbox]",function(){
		
		///  后处理方法
		if (this.name == "ExaDisp") {
			return;
		}
		
		$("input[name="+this.name+"]:not([value="+this.value+"])").each(function(){
			$(this).removeAttr("checked");
		})
	});
}

/// 初始化病人历史就诊记录
function initCombogrid(){
	
	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPatAdmHisList&EpisodeID='+EpisodeID;
	
	///  定义columns
	var columns=[[
		{field:'EpisodeID',title:'EpisodeID',width:100},
		{field:'itmLabel',title:'就诊内容',width:100,hidden:true},
		{field:'AdmDate',title:'就诊日期',width:100},
		{field:'AdmLoc',title:'接收科室',width:100},
		{field:'AdmDoc',title:'医生',width:100},
		{field:'PatDiag',title:'诊断',width:100}
	]];
	
	$('#AdmHis').combogrid({
		url:url,
		editable:false,    
	    panelWidth:550,
	    idField:'EpisodeID',
	    textField:'itmLabel',
	    columns:columns,
	    pagination:true,
        onSelect: function (rowIndex, rowData) {
	        
	        var repStatusID = $("#repStatus").combobox('getValue'); /// 报告状态
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var itemCatID = $("#itemCatID").combobox('getValue');   /// 检查分类ID
	        if (typeof itemCatID == "undefined"){
		    	itemCatID = "";
		    }
	        /// 检查方法
			var params = rowData.EpisodeID +"^"+ itemCatID +"^"+ repStatusID +"^"+ LgHospID;
            $("#dgEmPatList").datagrid("reload",{"params":params});   /// 刷新页面数据
        }
	});
}

/// 体位
function LoadItmPosition(itmmastid){
	
	$("#ItmPosi").html("");
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaPosition",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				//if ($('input[name="ExaPosi"][value="'+jsonObjArr[i].value+'"]').length == 0){
					var html = '<span><input class="checkbox" type="checkbox" name="ExaPosi" value="'+ jsonObjArr[i].value +'">'+ jsonObjArr[i].text +'</input>&nbsp;&nbsp;</span>';
					$("#ItmPosi").append(html);
				//}
			}
		}
	},'json',false)
}

/// 后处理方法
function LoadItmDispMethod(itmmastid){
	
	$("#ItmDisp").html("");
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaDisp",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				//if ($('input[name="ExaDisp"][value="'+jsonObjArr[i].value+'"]').length == 0){
					var html = '<span><input class="checkbox" type="checkbox" name="ExaDisp" value="'+ jsonObjArr[i].value +'">'+ jsonObjArr[i].text +'</input>&nbsp;&nbsp;</span>';
					$("#ItmDisp").append(html);
				//}
			}
		}
	},'json',false)
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

/// 显示其他项目
function showItemOtherOpt(){

	/// 初始化为空行
	$("#TmpOtherOpt").html('');
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaReqTmpOtherOpt",{"pid":pid},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			//$(".form-table").html("");
			for (var i=1; i<=jsonObjArr.length; i++){
				insHtmlTable(jsonObjArr[i-1]);
			}
			/// 数据为奇数时，增加两列；
			if ((i-1) % 2 != 0){
				$("#TmpOtherOpt tr:last").append('<td align="right"></td><td style="width:120px"></td>');
			}
		}
	},'json',false)
}

/// 加入项目列表
function addItemSelList(){
	
	/// 已选列表当前状态值
	if (itemSelFlag == "1"){
		itemSelFlag = "";
		$("#ItemSelList").datagrid('loadData',{total:0,rows:[]});
	}
	/// 体位
	var arExaPosiID = "",arExaPosiDesc = "";
	if ($('input[name="ExaPosi"]:checked').length){
		arExaPosiID = $('input[name="ExaPosi"]:checked').val();
		arExaPosiDesc = $('input[name="ExaPosi"]:checked').parent().text();
	}
	
	/// 后处理方法
	var arExaDispID = [],arExaDispDesc = [];
	$('input[name="ExaDisp"]:checked').each(function(){
		arExaDispID.push(this.value);
		arExaDispDesc.push($.trim($(this).parent().text()));
	})
	arExaDispID = arExaDispID.join("@");
	arExaDispDesc = arExaDispDesc.join("、");
	
	/// 接收科室
	var ExaReclocID = $("#ExaRecloc").combobox("getValue");    	 /// 接收科室ID
	var ExaRecloc = $("#ExaRecloc").combobox("getText");    	 /// 接收科室
	if (ExaRecloc == ""){
		$.messager.alert("提示:","接收科室不能为空！");
		return;
	}

	/// 检查方法
	var selItems=$("#ItemList").datagrid('getSelections');
	$.each(selItems, function(index, selItem){
		
		var itmmmastid = selItem.ItemID;         /// ID
		var itmmmastdesc = selItem.ItemDesc;     /// 描述
		var itmmmastprice = selItem.ItemPrice;   /// 价格
		var arExaPartID = selItem.ItemPartID;    /// 部位ID
		var arExaPartDesc = selItem.ItemPart;    /// 部位描述

		var ItemLabel = itmmmastdesc; // +" + "+ arExaPosiDesc +"["+ arExaPartDesc +"，"+ arExaDispDesc +"]";
		if (arExaPosiDesc !="" ){
			ItemLabel = ItemLabel +" + "+ $.trim(arExaPosiDesc);
		}
		
		var ItemLabelArr = [];
		if (arExaPartDesc !="" ){
			ItemLabelArr.push(arExaPartDesc);
		}
		if (arExaDispDesc !="" ){
			ItemLabelArr.push(arExaDispDesc);
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
		ItemExaPartID:arExaPartID, ItemExaDispID:arExaDispID, ItemExaPosiID:arExaPosiID,ItemExaPurp:ItemLabel, ItemOpt:'', ItemStat:"核实", ItemRemark:''}
		$("#ItemSelList").datagrid('appendRow',rowobj);
		
		/// 其他项目
        LoadItmOtherOpt(itmmmastid);
        
        /// 体位
        $('input[name="ExaPosi"]:checked').attr("checked",false);
        /// 后处理
        $('input[name="ExaDisp"]:checked').attr("checked",false);
	})
	
	showItemOtherOpt();  /// 确认加入后一次性加载其他项目 bianshuai 2016-08-09 
	
	//CalExaReqCost();  ///  计算检查申请总金额
	GetExaReqItmCost();   ///  计算检查申请总金额
}

/// 发送检查申请
function sendExaReq(){
	
	/// 发送前调用知识库
	if (InvokItmLib() != true) return;
	
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

	if (editSelRow != ""||editSelRow == 0) { 
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	} 
    
	var itemExaDisHis = $("#arDisHis").val();  /// 现病史
	if (itemExaDisHis == "请输入现病史描述！"){
		itemExaDisHis = "";
	}
	
	var itemExaPhySig = $("#arPhySig").val();  /// 体征
	if (itemExaPhySig == "请输入体征！"){
		itemExaPhySig = "";
	}
		
	var itemExaSym = $("#arPatSym").val();     /// 主诉
	if (itemExaSym == "请输入主诉！"){
		itemExaSym = "";
	}
	if (itemExaSym == ""){
		$.messager.alert("提示:","患者主诉不能为空！","info",function(){
			$('#arPatSym').focus();    /// 设置焦点
		});
		return;
	}

	var tips = itmIsRequired();   /// 其他项目是否为必填
	if (tips != ""){
		$.messager.alert("提示:","其他项目:" + tips +"不能为空！");
		return;
	}

	var itemLocFlag = 0;
	var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// 加急
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
		var itemRemark = selItem.ItemRemark;	   /// 备注
		
		
		var ListData = ItemID +"#"+ EpisodeID +"^"+ itemLocID +"^"+ arEmgFlag +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ itemExaDisHis +"^"+ itemExaPhySig +"^"+ LgCtLocID +"^"+ itemExaSym +"^"+ "Y" ;
			ListData = ListData +"#"+ itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID +"^"+ itemRemark;

		mItmListData.push(ListData);
	})
	
	if (itemLocFlag == 1){
		$.messager.alert("提示:","接收科室不能为空！");
		return;
	}
	
	mItmListData = mItmListData.join("!!");

	if (mItmListData == ""){
		$.messager.alert("提示:","没有待发送项目,请选择检查项目后重试！");
		return;
	}
	/// 保存模板数据
	runClassMethod("web.DHCAPPExaReport","save",{"pid":pid, "ListData":mItmListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","检查申请单发送失败，失败原因:"+jsonString);
		}else{
			/*
			var PatType = $('#PatType').text();   /// 就诊类型
			if (PatType == "I"){
				print(jsonString);                /// 调用打印函数
				return;
			}
			*/
			if (CloseFlag == 1){
				window.opener.ReloadGrid("ExaReport");  /// 刷新医嘱界面 
				window.parent.close();        /// 关闭弹出窗口
			}
			else if (CloseFlag == 2){
				window.parent.close();        /// 关闭弹出窗口
			}else{
				arExaReqIdList = jsonString;
				print(arExaReqIdList);
				//$("#ItemSelList").datagrid("reload"); /// 刷新页面数据
				$("#ItemSelList").datagrid("load",{"params":arExaReqIdList});
				$("#dgEmPatList").datagrid("reload");   /// 刷新页面数据
			
				isNeedAppExaReqNo(arExaReqIdList);      /// 判断检查申请是否还有可预约项目 bianshuai 2016-08-09
			}
		}
	},'',false)
}

/// 其他项目处理
function LoadItmOtherOpot(arReqID, itmmastid){

	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqOthOpt",{"pid":pid, "arReqID":arReqID, "itmmastid":itmmastid},function(jsonString){

		if (jsonString != ""){
			pid = jsonString;
			showItemOtherOpt();
		}
	},'',false)
	
}

/// 删除其他项目
function delExaReqItm(arReqItmID,itmmastid,PartID){

	if (arReqItmID != ""){
		/*
		runClassMethod("web.DHCAPPExaReport","delExaReqItm",{"arReqItmID":arReqItmID, "inPartID":PartID},function(jsonString){
			
			if (jsonString == 1){
				$.messager.alert("提示:","报告已执行不能进行此操作！");
				return;
			}
		    if (jsonString < 0){
				$.messager.alert("提示:","删除错误,错误信息:"+jsonString);
				return;
			}
		    if (jsonString == 0){
				delExaReqOthOpt(itmmastid);
				$("#dgEmPatList").datagrid("reload");   /// 刷新页面数据
			}
		
		},'',false)
		*/
	}else{
		delExaReqOthOpt(itmmastid);
	}

}

/// 删除其他项目
function delExaReqOthOpt(itmmastid){

	runClassMethod("web.DHCAPPExaReportQuery","DelExaReqOthOpt",{"pid":pid, "itmmastid":itmmastid},function(jsonString){

		if (jsonString != ""){
			showItemOtherOpt();
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
		var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonOtherOptSubItm&itemid="+ itemobj.itemid;
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

/// 项目明细
function showItmDetWin(arRepID){
	
	showItmAppDetWin(arRepID);  /// 预约详情窗口
}

/// 检查结果
function showItmRetWin(Oeori){

	showItmAppRetWin(Oeori);        /// 检查结果
}

/// 加载接收科室
function LoadArcItemRecLoc(arItemID){

	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";
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

/// 查找检查项目树
function findExaItmTree(event){
	
	var PyCode=$.trim($("#ExaCatCode").val());
	if (PyCode == ""){
		<!-- 新旧版本兼容配置 -->
	    if (version != 1){
			/// 旧版
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+LgHospID;
		}else{
			/// 新版
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+LgHospID;
		}
	}else{
		<!-- 新旧版本兼容配置 -->
	    if (version != 1){
		    /// 旧版
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCode&PyCode='+PyCode+'&HospID='+LgHospID;
		}else{
			/// 新版
			var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCodeNew&PyCode='+PyCode+'&HospID='+LgHospID;
		}
	}
	
	$('#CheckPart').tree('options').url =encodeURI(url);
	$('#CheckPart').tree('reload');
}

/// 设置检查目的
function LoadArcItemPurp(ExaReqItmPurp){
	
	if (ExaReqItmPurp != ""){
		$("#ExaPurp").css({"color":""});
		$("#ExaPurp").val(ExaReqItmPurp);
	}
}

/// 设置体征、现病史
function LoadExaReqHisSign(){
	
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaReqHisSign",{"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			$("#arDisHis").css({"color":""});
			$("#arDisHis").val(jsonObjArr.arExaReqHis);  /// 现病史
			$("#arPhySig").css({"color":""});
			$("#arPhySig").val(jsonObjArr.arExaReqSig);  /// 体征
			$("#arPatSym").css({"color":""});
			$("#arPatSym").val(jsonObjArr.arExaReqSym);  /// 主诉
		}
	},'json',false)
}

/// 检查申请总金额
function CalExaReqCost(){
	
	var arExaReqCost = 0;
	var selItems=$("#ItemSelList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#ItemSelList').datagrid('refreshRow', index); /// 刷新当行
		var ItemPrice = selItem.ItemPrice;   /// 单价
		arExaReqCost = parseFloat(arExaReqCost) + parseFloat(ItemPrice);
	})
	$("#arExaReqCost").text(arExaReqCost +"元");
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
function printExaReq(){

	printReq(arExaReqIdList);   /// 调用打印函数
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
		$("#arExaReqCost").text("总费用:"+0 +"元");
		return;
	}

	var ListData = arRepID +"^"+ EpisodeID +"^"+ pid +"#"+ mItmListData;

	/// 保存模板数据
	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqItmCost",{"ListData":ListData},function(jsonString){
		if (jsonString > 0){
			var arExaReqCost = jsonString;
			$("#arExaReqCost").text("总费用:"+arExaReqCost +"元");
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

///  检查申请单是否需要预约
function isNeedAppExaReqNo(arExaReqID){

	var arExaReqIDArr = arExaReqID.split("^");
	for (var m=0;m<arExaReqIDArr.length; m++){
		arReqID = arExaReqIDArr[m];
		if (isExistNeedAppItm(arReqID)){     /// 还有预约项目时,弹出预约界面
			showItmAppDetWin(arReqID);  	 /// 预约详情窗口
			break;
		}
	}
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
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmmastid},function(jsonString){
		
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

	/// 其他项目
    LoadItmOtherOpt(itmmmastid);

	showItemOtherOpt();   ///  确认加入后一次性加载其他项目 bianshuai 2016-08-09
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

/// 选中检查项目
function selectExaItem(){
	
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
		
		/// 获取医生录医嘱权限
		if (GetDocPermission(arExaItmID) == 1){
			$.messager.alert("提示:","您没有权限录入该医嘱！");
			$(this).attr("checked",false);
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
					/// 准备添加检查项目
					attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID);
				}else{
					/// 取消项目选中状态
					$("#"+arExaItmID).attr("checked",false);
				}
			})
		}else{
			/// 准备添加检查项目
			attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID);
		}

	//	if ($('input[name="ExaItem"]:checked').length){
	//		arExaItmID = $('input[name="ExaItem"]:checked').attr("id"); /// 检查方法ID
	//		arExaCatID = $('input[name="ExaItem"]:checked').val();      /// 检查分类ID
	//	}
		/*
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
		
		runClassMethod("web.DHCAPPExaReportQuery","isExistLinkPart",{"itmmastid":arExaItmID,"TraID":arExaCatID},function(isLinkPart){
		
			if (isLinkPart != ""){
				if (isLinkPart == 1){
					createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc);  /// 项目需选择部位，弹出部位窗口
				}else{
					addExaItem(arExaItmID,arExaItmDesc);          /// 添加检查项目
				}
			}
		},'',false)*/
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
	}
	
}

/// 准备添加检查项目
function attendExaReqItm(arExaItmID, arExaItmDesc, arExaCatID){
	
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
					createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc);  /// 项目需选择部位，弹出部位窗口
				}else{
					if (IsRepeatOneday(arExaItmID,"") == 1){
						$.messager.confirm('确认对话框','当天已经已有相同医嘱是否继续添加？', function(r){
							if (r){
								addExaItem(arExaItmID,arExaItmDesc);          /// 添加检查项目
							}else{
								/// 取消检查项目复选框
								if ($("#"+arExaItmID).is(":checked")){
									$("#"+arExaItmID).attr("checked",false);
								}
							}
						});
					}else{
						addExaItem(arExaItmID,arExaItmDesc);          /// 添加检查项目
					}
				}
			}
		},'',false)
}

/// 添加检查项目
function addExaItem(arExaItmID,arExaItmDesc){
	
//	/// 检查方法【医嘱项ID、医嘱项名称】
//	var arExaItmID = "",arExaItmDesc = "";
//	if ($('input[name="ExaItem"]:checked').length){
//		arExaItmID = $('input[name="ExaItem"]:checked').val();                     /// 检查方法ID
//		arExaItmDesc = $('input[name="ExaItem"]:checked').parent().next().text();  /// 检查方法
//	}
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
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID},function(jsonString){
		
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].value;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)
	}
	
	if (isExistItem(arExaItmDesc)){
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
	var rowobj={ItemID:"", ItemArcID:"", ItemLabel:arExaItmDesc, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:'', 
	ItemExaDispID:'', ItemExaPosiID:'',ItemExaPurp:arExaItmDesc, ItemOpt:'', ItemStat:"核实", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, ItemEmgFlag:arEmgFlag, ItemRemark:''}
	$("#ItemSelList").datagrid('appendRow',rowobj);
	
	/// 其他项目
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  确认加入后一次性加载其他项目 bianshuai 2016-08-09
	GetExaReqItmCost();   ///  计算检查申请总金额
	
}

/// 创建部位弹出窗口
function createPartPopUpWin(arExaCatID,arExaItmID,arExaItmDesc){
	
	/// 调用医嘱项列表窗口
	//new PopUpWin($(this), "760", "360" , "", "").init();
	$('#PopUpWin').window({
		title:'附加信息',   
	    width:950,    
	    height:450,    
	    modal:true,
	    collapsible:false,
	    minimizable:false,
	    maximizable:false,
	    onBeforeClose:function(){
			$("#dmPartList").datagrid('loadData',{total:0,rows:[]}); /// 清空datagrid
			clrItmChkFlag();   	  ///  取消检查项目选中状态
		}
	}); 
	
	$("#arExaItmID").text(arExaItmID);     /// 临时存储检查方法ID
	$("#arExaItmDesc").text(arExaItmDesc); /// 临时存储检查方法
	initPartTree(arExaCatID,arExaItmID);
	initItemList(arExaItmID); /// 页面DataGrid初始定义检查分类列表
	initItemDisp(arExaItmID); /// 后处理方法
	isShowPosi(arExaItmID);   /// 是否显示体位列
}

/// 初始化检查部位树
function initPartTree(arExaCatID,arExaItmID){

	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+arExaItmID+'&PyCode=&TraID='+arExaCatID+'&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
		checkbox:true,
        onCheck:function(node, checked){
	        var isLeaf = $("#EnPart").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        if (checked){
			        /// 添加项目时,判断当天是否已有相同项目
			        if (IsRepeatOneday(arExaItmID,node.id) == 1){
				        var nodeid = node.id;
				        var nodetext = node.text;
						$.messager.confirm('确认对话框','当天已经已有相同部位医嘱是否继续添加？', function(r){
							if (r){
								addItmSelList(nodeid, nodetext);
							}else{
								/// 取消选中节点
								var node = $("#EnPart").tree('find',nodeid);
								$("#EnPart").tree('uncheck',node.target);
							}
						});
					}else{
						addItmSelList(node.id, node.text);
					}
		        	//addItmSelList(node.id, node.text);
		        }else{
			    	delItmSelList(node.id);
			    }
	        }   
	    },
	    onLoadSuccess:function(node, data){
	    	//initPageBaseInfo(); /// 初始化加载页面基础数据
	    	$("span:contains('可选部位')").parent().find("span.tree-checkbox").remove();
	    },
	    onClick:function(node){
			if (node.checked){
				$("#EnPart").tree('uncheck',node.target);
			}else{
				$("#EnPart").tree('check',node.target);
			}
		}
	};
	new CusTreeUX("EnPart", url, option).Init();
}

/// 页面DataGrid初始定义检查分类列表
function initItemList(arExaItmID){
	
	var arExaItmID = arExaItmID.replace("_","||");
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}

	// 体位编辑格
	var PosiEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url: LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaPosition&itmmastid="+arExaItmID+"&HospID="+LgHospID,
			valueField: "value", 
			textField: "text",
			multiple:true,
			editable:false,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///设置类型值
				var PosiED=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiDesc'});
				var tempPosiID = $(PosiED.target).combobox('getValues');
				var tempPosi = $(PosiED.target).combobox('getText');
				/// 暂存体位ID
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiID'});
				$(ed.target).val(tempPosiID);
				/// 暂存体位
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosi'});
				$(ed.target).val(tempPosi);
				/// 可选项目为1条时,选中后直接关闭
				var rowData = $(PosiED.target).combobox('getData');
				if (rowData.length == 1){
					$(PosiED.target).combobox('hidePanel');
				}
			},
			onUnselect:function(option){
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				///设置类型值
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiDesc'});
				var tempPosiID = $(ed.target).combobox('getValues');
				var tempPosi = $(ed.target).combobox('getText');
				/// 暂存体位ID
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiID'});
				$(ed.target).val(tempPosiID);
				/// 暂存体位
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosi'});
				$(ed.target).val(tempPosi);
			}
		}

	}
	
	///  定义columns
	var columns=[[
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'ItemPart',title:'部位',width:140},
		{field:'ItemPosiID',title:'ItemPosiID',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosi',title:'ItemPosi',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosiDesc',title:'体位',width:140,editor:PosiEditor},
		{field:'ItemRemark',title:'备注',width:100,editor:texteditor},
		{field:'ItemOpt',title:'操作',width:100,align:'center',formatter:SetCellDelUrl}
	]];
	
	///  定义datagrid
	var option = {
		border : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                //$("#dmPartList").datagrid('endEdit', editRow); 
            }
            //$("#dmPartList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	
	var params = "";
	var uniturl = "";
	new ListComponent('dmPartList', columns, uniturl, option).Init(); 
}

/// 操作
function SetCellDelUrl(value, rowData, rowIndex){
	var html = "<a href='#' onclick='delItmRow("+rowData.ItemID+")'>删除</a>";
    return html;
}

/// 删除行
function delItmRow(PartID){
	
	/// 取消选中节点
	var node = $("#EnPart").tree('find',PartID);
	$("#EnPart").tree('uncheck',node.target);
	
	/// 删除选中行
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(rowIndex, selItem){
		if (selItem.ItemID == PartID){
			/// 删除行
			$("#dmPartList").datagrid('deleteRow',rowIndex);			
		}
	})
	
	/*
	/// 删除行
	$("#dmPartList").datagrid('deleteRow',rowIndex);
	
	/// 刷新列表数据
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#dmPartList').datagrid('refreshRow', index);
	})
	*/
}

/// 加入项目列表
function addItmSelList(id, text){

	var rowobj={ItemID:id, ItemPart:text, ItemPosiID:'', ItemPosi:'', ItemOpt:''}
	$("#dmPartList").datagrid('appendRow',rowobj);
	
	/// 开启行编辑     /// 2016-12-14 bianshuai 开启多行编辑
	var rowsData=$("#dmPartList").datagrid('getRows');
	$("#dmPartList").datagrid('beginEdit', rowsData.length - 1);
}

/// 删除列表数据
function delItmSelList(PartID){
	
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(rowIndex, selItem){
		if (selItem.ItemID == PartID){
			/// 删除行
			$("#dmPartList").datagrid('deleteRow',rowIndex);			
		}
	})
	/*
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if (selItem.ItemID == id){
			delItmRow(index);  /// 删除对应行
			return false;
		}
	})
	*/
}

/// 后处理方法
function initItemDisp(arExaItmID){
	
	var arExaItmID = arExaItmID.replace("_","||");
	$("#ItmExaDisp").html("");
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaDisp",{"itmmastid":arExaItmID, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				var html = '';
					html = html + '<tr style="height:30px">';
					html = html + '<td style="width:20px"><input name="ExaDisp" type="checkbox" value="'+ jsonObjArr[i].value +'"></input></td>';
					html = html + '<td>'+ jsonObjArr[i].text +'</td>';
					html = html + '</tr>';
				$("#ItmExaDisp").append(html);
			}
			/// 后处理内容为空，展开面板
			//$('#PopPanel').layout('expand','east');
			$('#PopPanel').layout('show','east'); 
		}else{
			/// 后处理内容为空，折叠面板
			//$('#PopPanel').layout('collapse','east');
			$('#PopPanel').layout('hidden','east'); 
		}
	},'json',false)
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
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":arExaItmID},function(jsonString){
		
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
		
	})
	
	clrItmChkFlag();   	  ///  取消检查项目选中状态
	
	$("#dmPartList").datagrid('loadData',{total:0,rows:[]}); /// 清空datagrid
	$('#PopUpWin').window("close");
	
	/// 其他项目
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  确认加入后一次性加载其他项目 bianshuai 2016-08-09
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

/// 检查项目是否显示体位列
function isShowPosi(arExaItmID){
	
	var arExaItmID = arExaItmID.replace("_","||");
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaPosition",{"itmmastid":arExaItmID, "HospID":LgHospID},function(jsonPosi){
		if (jsonPosi == ""){
			/// 检查项目无对应体位时，隐藏体位列
			$("#dmPartList").datagrid('hideColumn','ItemPosiDesc');
		}
	},'json',false)
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

/// 其他项目是否为必填
function itmIsRequired(){
	
	var resval = "";
	runClassMethod("web.DHCAPPExaReport","ItmIsRequired",{"pid":pid},function(jsonString){

		if (jsonString != ""){
			resval = jsonString;
		}
	},'',false)

	return resval;
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
		}
	},'',false)

	return NotTakOrdMsg;
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
				InitInsSelItem(itemArr[i]);  /// 插入已选项目列表
			}
		}
	},'json',false)
	
}

/// 检查申请确认
function sureExaReq(){
	
	if (editSelRow != ""||editSelRow == 0) { 
		$("#ItemSelList").datagrid('endEdit', editSelRow); 
	} 
    
	var itemExaDisHis = $("#arDisHis").val();  /// 现病史
	if (itemExaDisHis == "请输入现病史描述！"){
		itemExaDisHis = "";
	}
	
	var itemExaPhySig = $("#arPhySig").val();  /// 体征
	if (itemExaPhySig == "请输入体征！"){
		itemExaPhySig = "";
	}
		
	var itemExaSym = $("#arPatSym").val();     /// 主诉
	if (itemExaSym == "请输入主诉！"){
		itemExaSym = "";
	}
	if (itemExaSym == ""){
		$.messager.alert("提示:","患者主诉不能为空！","info",function(){
			$('#arPatSym').focus();    /// 设置焦点
		});
		return;
	}

	var tips = itmIsRequired();   /// 其他项目是否为必填
	if (tips != ""){
		$.messager.alert("提示:","其他项目:" + tips +"不能为空！");
		return;
	}

	var itemLocFlag = 0; var mItmMastArr = [];
	var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";   /// 加急
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
		
		var ListData = EpisodeID +"^"+ itemLocID +"^"+ arEmgFlag +"^"+ itemExaPurp +"^"+ LgUserID +"^"+ itemExaDisHis +"^"+ itemExaPhySig +"^"+ LgCtLocID +"^"+ itemExaSym +"^"+ "N" ;
			ListData = ListData +"#"+ itmmmastid +"^"+ itemExaPosiID +"^"+ itemExaPartID +"^"+ itemExaDispID +"^"+ arReqDate +"^"+ uniqueID +"^"+ arEmgFlag +"^"+ itemRemark;

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
	
	mItmListData = mItmListData.join("!!");

	if (mItmListData == ""){
		$.messager.alert("提示:","没有待发送项目,请选择检查项目后重试！");
		return;
	}
	
	/// 保存模板数据
	runClassMethod("web.DHCAPPExaReport","saveDoc",{"pid":pid, "ListData":mItmListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","检查申请单发送失败，失败原因:"+jsonString);
		}else{
			window.returnValue = jsonString;
			window.close();
		}
	},'',false)
	

}

/// 关闭弹出窗口
function closePopWin(){
	
	window.close();        /// 关闭弹出窗口
}

/// 取消检查项目选中状态
function clrItmChkFlag(){
	
	var arExaItmID = $("#arExaItmID").text();
	/// 取消检查项目选中效果 
	$('#'+ arExaItmID).attr("checked",false);
	
	$("#arExaItmID").text("");     /// 临时存储检查方法ID
	$("#arExaItmDesc").text("");   /// 临时存储检查方法
}

/// 插入已选项目列表
function InitInsSelItem(itemobj){
	
	var mItmMastStr = itemobj.value;  /// 医嘱项目串
	var arExaItmDesc = itemobj.text;  /// 医嘱项描述
	var arExaItmID = mItmMastStr.split("*")[3]; /// 医嘱项ID
	var arExaItmID = arExaItmID.replace("_","||");
	/// 接收科室
	var ItemLocID = ""; var ItemLoc = "";
	/// 医生界面调用时,取值格式
	var LocID = mItmMastStr.split("*")[1];
	runClassMethod("web.DHCAPPExaReportQuery","jsonItmRecLoc",{"LocID":LocID},function(jsonString){
	
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			ItemLocID = jsonObjArr[0].value;
			ItemLoc = jsonObjArr[0].text;
		}
	},'json',false)

	var arReqDate  = "", uniqueID = "", arEmgFlag = "";
	/// 医生界面调用时,取值格式
	arEmgFlag = mItmMastStr.split("*")[0];  /// 加急标志
	arReqDate = mItmMastStr.split("*")[2];  /// 医嘱日期
	uniqueID = mItmMastStr.split("*")[4];   /// 唯一标示
	
	/// 用于发送时，判断发送项目是否与开立项目一直
	mItmMastDocArr.push(mItmMastStr +"*"+ arExaItmDesc);
	
	/// 加入已选列表
	var rowobj={ItemID:"", ItemArcID:"", ItemLabel:arExaItmDesc, ItemExaID:arExaItmID, ItemLocID:ItemLocID, ItemLoc:ItemLoc, ItemExaPartID:'', 
	ItemExaDispID:'', ItemExaPosiID:'',ItemExaPurp:arExaItmDesc, ItemOpt:'', ItemStat:"核实", ItemReqDate:arReqDate, ItemUniqueID:uniqueID, ItemEmgFlag:arEmgFlag, ItemRemark:''}
	$("#ItemSelList").datagrid('appendRow',rowobj);
	
	/// 其他项目
    LoadItmOtherOpt(arExaItmID);
    
	showItemOtherOpt();   ///  确认加入后一次性加载其他项目 bianshuai 2016-08-09
	GetExaReqItmCost();   ///  计算检查申请总金额
	
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

///保存时弹出提示窗口  sufan  2016/12/20
function savesymmodel()
{
	var patsymtom=$("#arPatSym").val();
	if ((patsymtom=="病人主诉！")||patsymtom=="")
	{
		$.messager.alert("提示:","没有待保存数据！");
		return;
		}
	createsymPointWin();    ///打开提示窗口
}

/// 保存主诉科室模板
function saveSymLoc()
{
	var patsymtom=$("#arPatSym").val();  // 主诉信息
	var amSaveas="";					 // 保存对象
	var params=EpisodeID+"^"+patsymtom+"^"+amSaveas+"^"+LgCtLocID+"^"+LgUserID;
	SaveSym(params);   // 调用保存函数
}

/// 保存主诉个人模板
function saveSymUser()
{
	var patsymtom=$("#arPatSym").val();	// 主诉信息
	var amSaveas=LgUserName;			// 保存对象
	var params=EpisodeID+"^"+patsymtom+"^"+amSaveas+"^"+LgUserID+"^"+LgUserID;
	SaveSym(params);	// 调用保存函数
}

/// 保存函数
function SaveSym(params)
{
	runClassMethod("web.DHCAPPExaReport","SavePatSymModel",{"params":params},function(jsonString){
		if (jsonString==0)
		{
			$('#symwin').window('close');
			$.messager.alert("提示:","保存成功！");
			}
		if (jsonString=="-1")
		{	$('#symwin').window('close');
			$.messager.alert("提示:","数据已存在！");
			}
	},'',false)
}
///保存时弹出提示窗口  sufan  2016/12/20
function saveprehismodel()
{	
	var patprehis=$("#arDisHis").val();
	if ((patprehis=="病人主诉！")||patprehis=="")
	{
		$.messager.alert("提示:","没有待保存数据！");
		return;
		}
	createPrehisPointWin();		 ///打开提示窗口
}

/// 保存现病史科室模板
function savePrehisLoc()
{
	var patprehis=$("#arDisHis").val();		// 现病史信息
	var apSaveas=""							// 保存对象
	var params=EpisodeID+"^"+patprehis+"^"+apSaveas+"^"+LgCtLocID+"^"+LgUserID;
	SavePrehis(params);		// 调用保存函数
}

/// 保存现病史个人模板
function savePrehisUser()
{
	var patprehis=$("#arDisHis").val();		// 现病史信息
	var apSaveas=LgUserName;				// 保存对象
	var params=EpisodeID+"^"+patprehis+"^"+apSaveas+"^"+LgUserID+"^"+LgUserID;
	SavePrehis(params);		// 调用保存函数
}
/// 保存函数
function SavePrehis(params)
{
	runClassMethod("web.DHCAPPExaReport","SavePreHis",{"params":params},function(jsonString){
		if (jsonString==0)
		{
			$('#prehis').window('close');
			$.messager.alert("提示:","保存成功！");
			}
		if (jsonString=="-1")
		{
			$('#prehis').window('close');
			$.messager.alert("提示:","数据已存在！");
			}
	},'',false)
}

///保存时弹出提示窗口  sufan  2016/12/20
function savesignmodel()
{
	var patsign=$("#arPhySig").val();
	if ((patsign=="请输入现病史描述！")||patsign=="")
	{
		$.messager.alert("提示:","没有待保存数据！");
		return;
		}
	createPatsignPointWin();		///打开提示窗口
}

/// 保存体征科室模板
function savePatsignLoc()
{
	var patsign=$("#arPhySig").val();
	var aptSaveas=""
	var params=EpisodeID+"^"+patsign+"^"+aptSaveas+"^"+LgCtLocID+"^"+LgUserID;
	SavePatsign(params);		// 调用保存函数
}
/// 保存体征个人模板
function savePatsignUser()
{
	var patsign=$("#arPhySig").val();
	var aptSaveas=LgUserName
	var params=EpisodeID+"^"+patsign+"^"+aptSaveas+"^"+LgUserID+"^"+LgUserID;
	SavePatsign(params);		// 调用保存函数
}
/// 保存函数
function SavePatsign(params)
{
	runClassMethod("web.DHCAPPExaReport","SaveSignModel",{"params":params},function(jsonString){
		if (jsonString==0)
		{
			$('#patsign').window('close');
			$.messager.alert("提示:","保存成功！");
			}
		if (jsonString=="-1")
		{
			$('#patsign').window('close');
			$.messager.alert("提示:","数据已存在！");
			}
	},'',false)
}

///保存检查目的模板  sufan  2016/12/20
function showmodel(flag)
{	
	if($('#winonline').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:'模板列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:550,
		height:450
	});
	var iframepatsym = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.patsymtemp.csp"></iframe>';
	var iframeprehis = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.prehistmp.csp"></iframe>';
	var iframesign = '<iframe   scrolling="yes" width=100% height=100%  frameborder="0" src="dhcapp.resultwindow.csp"></iframe>';
	if (flag==1)
	{
		$('#winonline').html(iframepatsym);
	 }
	if (flag==2)
	{
		$('#winonline').html(iframeprehis);
	 }
	if (flag==3)
	{
		$('#winonline').html(iframesign);
	 }
		$('#winonline').window('open');
}
/// 提示窗口
function createsymPointWin(){	
	if($('symwin').is(":hidden")){
	   $('symwin').window('open');
		return;
		}           ///窗体处在打开状态,退出	
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('选择', 'symwin', '260', '130', option).Init();
}
/// 提示窗口
function createPrehisPointWin(){	
	if($('prehis').is(":hidden")){
	   $('prehis').window('open');
		return;
		}           ///窗体处在打开状态,退出	
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('选择', 'prehis', '260', '130', option).Init();
}
/// 提示窗口
function createPatsignPointWin(){	
	if($('patsign').is(":hidden")){
	   $('patsign').window('open');
		return;
		}           ///窗体处在打开状态,退出	
	/// 查询窗口
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('选择', 'patsign', '260', '130', option).Init();
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

	$("#TmpFunLib").html(htmlstr);
	//$('#FunUpWin').html(htmlstr);
}

/// 弹出诊断窗口
function DiagPopWin(){
	
	var PatientID = $("#PatientID").text();  /// 病人ID
	var mradm = $("#mradm").text();			 /// 就诊诊断ID

	var lnk = "diagnosentry.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
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
		var itemHtml = GetItemInstr(itmmmastid, itemPartID);
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
function GetItemInstr(itmmastid, itemPartID){
	var html = '';
	// 获取显示数据
	runClassMethod("web.DHCAPPExaReportQuery","GetItemInstr",{"itmmastid":itmmastid, "itemPartID":itemPartID},function(jsonString){

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

/// 删除临时global
function killTmpGlobal(){

	runClassMethod("web.DHCAPPExaReportQuery","killTmpGlobal",{"pid":pid},function(jsonString){
	},'',false)
}

/// 页面关闭之前调用
function onbeforeunload_handler() {
    killTmpGlobal();  /// 清除临时global
}

window.onbeforeunload = onbeforeunload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

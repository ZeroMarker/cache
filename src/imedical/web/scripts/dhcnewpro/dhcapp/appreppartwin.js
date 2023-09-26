//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2016-07-23
// 描述:	   检查申请部位选择界面
//===========================================================================================

var itmmastid = "";  /// 医嘱项ID
var TraID = "";      /// 分类树ID
var InvFlag = 0 ;    /// 调用标识: 1-申请界面调用，0-医嘱模板调用
var mListData = "";
var LgHospID = session['LOGON.HOSPID'];   /// 医院ID
var selOrdBodyPartStr="";  /// 已选列表串
var selOrdBodyPartDescStr="";
/// 页面初始化函数
function initPageDefault(){
	
	initParam();     ///  初始化参数信息
	initItemList();  ///  页面DataGrid检查分类列表
	initBlButton();  ///  页面Button绑定事件
	//LoadPartTree(); /// 部位树
	initItemDisp();  ///  后处理方法
	initHideCol();   ///  隐藏列控制
	initExaPart();   ///  部位列表
	if (InvFlag != 1){
		initSelExaPart(); /// 已选列表
	}
}
function initSelExaPart(){
	//38B1A29B2*
	//addItmSelList
	var arExaDispID=selOrdBodyPartStr.split("*")[1]; //后处理选择 串
	selOrdBodyPartStr=selOrdBodyPartStr.split("*")[0];
	if (selOrdBodyPartStr!=""){
		runClassMethod("web.DHCAPPExaReportQuery","jsonExaPosition",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
			for (var i=0;i<selOrdBodyPartStr.split("A").length;i++){
				var id=selOrdBodyPartStr.split("A")[i].split("B")[0];
				var ItemPosiIDStr=selOrdBodyPartStr.split("A")[i].split("B")[1];
				var text=$("#Part_"+id).parent().next().text();
				var rowobj={ItemID:id, ItemPart:text, ItemPosiID:'', ItemPosi:'', ItemOpt:''}
				$("#dmPartList").datagrid('appendRow',rowobj);
				var rowsData=$("#dmPartList").datagrid('getRows');
				$("#dmPartList").datagrid('beginEdit', rowsData.length - 1);
				var ed=$("#dmPartList").datagrid('getEditor',{index:rowsData.length - 1,field:'ItemPosiDesc'});
				if (ItemPosiIDStr!=""){
					var ItemPosiIDArr=new Array();
					var ItemPosiArr=new Array();
					for (var k=0;k<ItemPosiIDStr.split(",").length;k++){
						ItemPosiIDArr.push(ItemPosiIDStr.split(",")[k]);
						for (var m=0;m<jsonString.length;m++){
							if(ItemPosiIDStr.split(",")[k]==jsonString[m].value){
								ItemPosiArr.push(jsonString[m].text);
								break;
							}
						}
					}
					$(ed.target).combobox('setValues',ItemPosiIDArr);
					var ed=$("#dmPartList").datagrid('getEditor',{index:rowsData.length - 1,field:'ItemPosiID'});
					$(ed.target).val(ItemPosiIDStr);
					var ed=$("#dmPartList").datagrid('getEditor',{index:rowsData.length - 1,field:'ItemPosi'});
					$(ed.target).val(ItemPosiArr.join(","));
				}
			}
		},'json',false)
		
	}
	if (arExaDispID!=""){
		for (var k=0;k<arExaDispID.split("@").length;k++){
			$("#ExaDisp_"+arExaDispID.split("@")[k]).prop('checked', true);
		}
	}
}
/// 初始化加载病人就诊ID
function initParam(){
	
	itmmastid = getParam("itmmastid");   /// 医嘱项ID 
	TraID = getParam("arExaCatID"); /// 分类树ID 
	InvFlag = getParam("InvFlag");  /// 调用标识 
	selOrdBodyPartStr = getParam("selOrdBodyPartStr");  /// 已选列表串
	selOrdBodyPartDescStr = getParam("selOrdBodyPartDescStr");  /// 已选列表串描述
}

/// 页面 Button 绑定事件
function initBlButton(){
		
	///  拼音码
	$("#PartCode").bind("keyup",findPartTree);
	
	/// 部位选择
	$("#ItmExaPart").on("click","[id^=Part]",selectItem);
}

/// 查找检查部位树
function findPartTree(){
	
	var PyCode=$.trim($("#PartCode").val());
	
	var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid+'&PyCode='+ PyCode +'&TraID=&HospID='+LgHospID;

	$('#EnPart').tree('options').url =encodeURI(url);
	$('#EnPart').tree('reload');
}

/// 初始化检查部位树
function LoadPartTree(){

	var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid+'&PyCode=&TraID=&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
		checkbox:true,
        onCheck:function(node, checked){
	        var isLeaf = $("#EnPart").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        if (checked){
					addItmSelList(node.id, node.text);
		        }else{
			    	delItmSelList(node.id);
			    }
	        }   
	    },
	    onLoadSuccess:function(node, data){
	    	//$("span:contains('可选部位')").parent().find("span.tree-checkbox").remove();
			$("ul#EnPart>li>div").find("span.tree-checkbox").remove();
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
function initItemList(){
	
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
			url: "", //$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaPosition&itmmastid="+itmmastid+"&HospID="+LgHospID,
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
			onShowPanel:function(){
				
				var tr = $(this).closest("tr.datagrid-row");
				var modRowIndex = tr.attr("datagrid-row-index");
				
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemID'});
				var PartID=$(ed.target).val();  /// 部位ID
				var ed=$("#dmPartList").datagrid('getEditor',{index:modRowIndex,field:'ItemPosiDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaPosition&itmmastid="+itmmastid+"&HospID="+LgHospID+"&PartID="+PartID;
				$(ed.target).combobox('reload',unitUrl);
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
		{field:'ItemID',title:'ItemID',width:100,hidden:true,editor:texteditor},
		{field:'ItemPart',title:'部位',width:200},
		{field:'ItemPosiID',title:'ItemPosiID',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosi',title:'ItemPosi',width:100,editor:texteditor,hidden:true},
		{field:'ItemPosiDesc',title:'体位',width:160,editor:PosiEditor},
		{field:'ItemRemark',title:'备注',width:200,editor:texteditor},
		{field:'ItemOpt',title:'操作',width:100,align:'center',formatter:SetCellDelUrl}
	]];
	
	///  定义datagrid
	var option = {
		border : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != -1||editRow == 0) { 
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
	//var node = $("#EnPart").tree('find',PartID);
	//$("#EnPart").tree('uncheck',node.target);
	
	/// 取消检查项目复选框
	if ($("#Part_"+PartID).is(":checked")){
		$("#Part_"+PartID).attr("checked",false);
	}
	
	/// 删除选中行
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(rowIndex, selItem){
		if (selItem.ItemID == PartID){
			/// 删除行
			$("#dmPartList").datagrid('deleteRow',rowIndex);
			return false;			
		}
	})
}

/// 选中事件
function selectItem(){
	
	if ($(this).is(':checked')){
		
		/// 部位
		var PartID = this.value;    /// 部位ID
		var PartDesc = $(this).parent().next().text(); /// 部位描述
		addItmSelList(PartID, PartDesc);
	}else{
		
		var PartID = this.value;    /// 部位ID
		delItmSelList(PartID);
	}
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
function initItemDisp(){
	
	$("#ItmExaDisp").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonExaDisp",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				var html = '';
					html = html + '<tr style="height:30px">';
					html = html + '<td style="width:20px"><input id="ExaDisp_'+jsonObjArr[i].value+'" name="ExaDisp" type="checkbox" value="'+ jsonObjArr[i].value +'"></input></td>';
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

/// 隐藏列控制
function initHideCol(){
	
	runClassMethod("web.DHCAPPExaReportQuery","isExistPos",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonPosi){
		if (jsonPosi == ""){
			/// 检查项目无对应体位时，隐藏体位列
			$("#dmPartList").datagrid('hideColumn','ItemPosiDesc');
		}
	},'json',false)
	
	if (InvFlag != 1){
		/// 医生站弹出时，隐藏备注列
		$("#dmPartList").datagrid('hideColumn','ItemRemark');
	}
}

/// 确定
function sure(){
	
	/// 窗口调用标识
	if (InvFlag == 1){ 
		InsPart();     /// 检查申请界面
	}else{
		InsPartDoc();  /// 医生模板界面
	}
}

/// 检查申请界面
function InsPart(resItemPart){
	
	/// 检查附加信息
	var rows=$("#dmPartList").datagrid('getRows');
	if (rows.length == 0){
		$.messager.alert("提示:","请先选择部位！");
		return;
	}
	
	for(var index=0; index < rows.length; index++){
		
		/// 结束编辑
		$("#dmPartList").datagrid('endEdit', index); 
	}
	
	/// 后处理方法
	var arExaDispID = [],arExaDispDesc = [];
	$('input[name="ExaDisp"]:checked').each(function(){
		arExaDispID.push(this.value);
		arExaDispDesc.push($.trim($(this).parent().next().text()));
	})
	arExaDispID = arExaDispID.join("@");
	arExaDispDesc = arExaDispDesc.join("、");
	
	window.parent.frames.InsItemSelList(rows, arExaDispID, arExaDispDesc);
}

/// 医生模板界面
function InsPartDoc(){
	
	/// 检查附加信息
	var rows=$("#dmPartList").datagrid('getRows');
	if (rows.length == 0){
		$.messager.alert("提示:","请先选择部位！");
		return;
	}
	
	var itmLabelID = "";     /// 项目ID串
	var itmLabel = "";       /// 项目描述
	/// 后处理方法
	var arExaDispID = [],arExaDispDesc = [];
	$('input[name="ExaDisp"]:checked').each(function(){
		arExaDispID.push(this.value);
		arExaDispDesc.push($.trim($(this).parent().next().text()));
	})
	arExaDispID = arExaDispID.join("@");
	arExaDispDesc = arExaDispDesc.join("、");

	/// 后处理	
	if (arExaDispDesc != ""){
		itmLabel = $.trim(arExaDispDesc);
	}
	
	var itmArr = [];         /// 项目ID串
	var itmPartArr = [];     /// 部位描述
	$.each(rows, function(index, rowData){
		
		/// 结束编辑
		$("#dmPartList").datagrid('endEdit', index); 
		
		var arExaPartID = rowData.ItemID;         /// 部位ID
		var arExaPartDesc = rowData.ItemPart;     /// 部位
		var arExaPosiID = rowData.ItemPosiID;     /// 体位ID
		var arExaPosiDesc = rowData.ItemPosi;     /// 体位
		
		/// 部位 (体位)
		if (arExaPosiDesc != ""){
			arExaPartDesc = arExaPartDesc +"("+ arExaPosiDesc +")";
		}
		itmPartArr.push(arExaPartDesc);
		itmArr.push(arExaPartID +"B"+ arExaPosiID);
	})
	
	if (itmPartArr.join("、") != ""){
		itmLabel = itmLabel + "[" + itmPartArr.join("，") + "]";
	}
	itmLabelID = itmArr.join("A");
	
	/// 返回内容
	var mListData = itmLabel +"^"+ itmLabelID +"^"+ arExaDispID;

	$("#dmPartList").datagrid('loadData',{total:0,rows:[]}); /// 清空datagrid
	window.returnValue=mListData;
	window.close();
}

/// 关闭窗体
function cancel(){
	
	if (InvFlag == 1){
		window.parent.frames.closeWin();
	}else{
		window.close();
	}
}

/// 查找检查项目树
function findExaItmTree(event){
	
	var PyCode=$.trim($("#ExaCatCode").val());
	var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid+"&PyCode="+PyCode;
	
	$('#CheckPart').tree('options').url =encodeURI(url);
	$('#CheckPart').tree('reload');
}


/// 检查部位列表
function initExaPart(){
	
	/// 初始化检查方法区域
	$("#ItmExaPart").html('<tr style="height:0px;" ><td style="width:80px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","jsonGetPartTreeByArc",{"itmmastid": itmmastid, "PyCode":"", "TraID":TraID, "HospID": LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InsPartRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检查部位内容
function InsPartRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		// htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var column = 5;  /// 列数
	var itemArr = itemobj.children;
	var itemhtmlArr = []; itemhtmlstr = "";
	var merRow = Math.ceil(itemArr.length / column);  /// 行数
	for (var j=1; j<=itemArr.length; j++){
		
		if (j == 1){
			itemhtmlArr.push('<td rowspan="'+ merRow +'" align="center">'+ itemobj.text +'</td>');
		}
		itemhtmlArr.push('<td><input id="Part_'+ itemArr[j-1].id +'" type="checkbox" value="'+ itemArr[j-1].id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		
		if (j % column == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % column != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + GetEmptyLabel(column - (itemArr.length % column)) +'</tr>';
		itemhtmlArr = [];
	}

	$("#ItmExaPart").append(htmlstr+itemhtmlstr)
}

/// 获取空tb内容
function GetEmptyLabel(number){
	
	var tempHtmlArr = [];
	for (var m=0; m < number; m++){
		tempHtmlArr.push('<td></td><td></td>');
	}
	return tempHtmlArr.join("");
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
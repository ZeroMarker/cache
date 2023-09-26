//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2016-07-23
// 描述:	   检查申请部位选择界面
//===========================================================================================

var itmmastid = "";
var mListData = "";

/// 页面初始化函数
function initPageDefault(){
	
	InitParam();     ///  初始化参数信息
	initItemList();  ///  页面DataGrid检查分类列表
	initBlButton();  ///  页面Button绑定事件
	
	LoadPartTree();  /// 部位树
    LoadItemPosi();  /// 体位
    LoadItemDisp();  /// 后处理
    initCheckBoxEvent();  ///  页面CheckBox事件
}

/// 初始化加载病人就诊ID
function InitParam(){
	itmmastid = getParam("itmmastid");
	mListData = getParam("mListData");
}

/// 页面DataGrid初始定义检查分类列表
function initItemList(){
	
	///  定义columns
	var columns=[[
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'ItemPart',title:'部位',width:300},
		{field:'ItemOpt',title:'操作',width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	///  定义datagrid
	var option = {
		title : '已选部位',
		border : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false
	};
	
	var params = "";
	var uniturl = "";
	new ListComponent('dmPartList', columns, uniturl, option).Init(); 
}

/// 操作
function SetCellOpUrl(value, rowData, rowIndex){
	var html = "<a href='#' onclick='delItmSelRow("+rowIndex+")'>删除</a>";
    return html;
}

/// 删除行
function delItmSelRow(rowIndex){
	
	/// 删除行
	$("#dmPartList").datagrid('deleteRow',rowIndex);
	/// 刷新列表数据
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		$('#dmPartList').datagrid('refreshRow', index);
	})
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	///  取消
	$('a:contains("取消")').bind("click",cancel);
	
	///  确定
	$('a:contains("确定")').bind("click",sure);
	
	///  拼音码
	$("#ExaCatCode").bind("keyup",findExaItmTree);
}

/// 初始化检查部位树
function LoadPartTree(){

	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
		checkbox:true,
        onCheck:function(node, checked){
	        var isLeaf = $("#CheckPart").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        if (checked){
		        	addItmSelList(node.id, node.text);
		        }else{
			    	delItmSelList(node.id);
			    }
	        }   
	    },
	    onLoadSuccess:function(node, data){
	    	initPageBaseInfo(); /// 初始化加载页面基础数据
	    },
	    onClick:function(node){
			if (node.checked){
				$("#CheckPart").tree('uncheck',node.target);
			}else{
				$("#CheckPart").tree('check',node.target);
			}
		}
	};
	new CusTreeUX("CheckPart", url, option).Init();
}

/// 体位
function LoadItemPosi(){

	runClassMethod("web.DHCAPPExaReportQuery","jsonExaPosition",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				if ($('input[name="ExaPosi"][value="'+jsonObjArr[i].value+'"]').length == 0){
					var html = '<span><input class="checkbox" type="checkbox" name="ExaPosi" value="'+ jsonObjArr[i].value +'">'+ jsonObjArr[i].text +'</input>&nbsp;&nbsp;</span>';
					$("#ItmPosi").append(html);
				}
			}
		}
	},'json',false)
}

/// 后处理方法
function LoadItemDisp(){

	runClassMethod("web.DHCAPPExaReportQuery","jsonExaDisp",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				if ($('input[name="ExaDisp"][value="'+jsonObjArr[i].value+'"]').length == 0){
					var html = '<span><input class="checkbox" type="checkbox" name="ExaDisp" value="'+ jsonObjArr[i].value +'">'+ jsonObjArr[i].text +'</input>&nbsp;&nbsp;</span>';
					$("#ItmDisp").append(html);
				}
			}
		}
	},'json',false)
}

/// 初始化页面CheckBox事件
function initCheckBoxEvent(){

	$("input[type=checkbox]").live('click',function(){
		
		///  后处理方法
		if (this.name == "ExaDisp") {
			return;
		}
		
		$("input[name="+this.name+"]:not([value="+this.value+"])").each(function(){
			$(this).removeAttr("checked");
		})
	});
}

/// 加入项目列表
function addItmSelList(id, text){

	var rowobj={ItemID:id, ItemPart:text, ItemOpt:''}
	$("#dmPartList").datagrid('appendRow',rowobj);
}

/// 删除列表数据
function delItmSelList(id){
	
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		if (selItem.ItemID == id){
			delItmSelRow(index);  /// 删除对应行
			return false;
		}
	})
}

/// 确定
function sure(){

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
	arExaDispDesc = arExaDispDesc.join("@");
	
	/// 部位
	var arExaPartID = [],arExaPartDesc = [];
	var selItems=$("#dmPartList").datagrid('getRows');
	$.each(selItems, function(index, selItem){
		arExaPartID.push(selItem.ItemID);
		arExaPartDesc.push(selItem.ItemPart);
	})
	arExaPartID=arExaPartID.join("@");
	arExaPartDesc=arExaPartDesc.join("@");
	//控制部位不能为空   22222
    if (arExaPartID==""){
	   alert("部位不能为空，请先选择！");
	   return false;
		
	}
	
	var mListData = arExaPartID +"^"+ arExaPartDesc +"^"+ arExaPosiID +"^"+ arExaPosiDesc +"^"+ arExaDispID +"^"+ arExaDispDesc

	window.returnValue=mListData;
	window.close();
}

/// 关闭窗体
function cancel(){
	
	window.close();
}

/// 初始化加载页面基础数据
function initPageBaseInfo(){
	
	if (mListData == "") return;
	var ExaReqArr = mListData.split("||");
	/// 部位
	if (ExaReqArr[0] != ""){
		var ExaReqPartArr = ExaReqArr[0].split("@");  /// 部位
		var tempArr=[];
		for (var i=0; i<ExaReqPartArr.length; i++){
			var PartID = ExaReqPartArr[i].split("^")[0];   /// 部位ID
			var PartDesc = ExaReqPartArr[i].split("^")[1]; /// 部位描述
		
			var node = $('#CheckPart').tree('find', PartID); /// 获取节点对象
			$('#CheckPart').tree('check', node.target);      /// 选中节点

			tempArr.push("{\"ItemID\":\""+PartID+"\",\"ItemPart\":\""+PartDesc+"\",\"ItemOpt\":\""+""+"\"}");
		}
		var jsdata = '{"total":'+ExaReqPartArr.length+',"rows":['+tempArr.join(",")+']}';
		var data = $.parseJSON(jsdata);
		$('#dmPartList').datagrid("loadData",data);       /// 将数据绑定到DataGrid中
	}
	/// 体位
	if (ExaReqArr[1] != ""){
		var ExaReqPosiArr = ExaReqArr[1].split("^");      /// 体位
		$("[name='ExaPosi'][value='"+ ExaReqPosiArr[0]+"']").attr("checked",true);
	}
	/// 后处理
	if (ExaReqArr[2] != ""){
		var ExaReqDispArr = ExaReqArr[2].split("@");      /// 后处理
		for (var j=0; j<ExaReqDispArr.length; j++){
			var DispID = ExaReqDispArr[j].split("^")[0];  /// 部位ID
			$("[name='ExaDisp'][value='"+ DispID+"']").attr("checked",true);
		}
	}
}

/// 查找检查项目树
function findExaItmTree(event){
	
	var PyCode=$.trim($("#ExaCatCode").val());
	var url = LINK_CSP+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonGetPartTreeByArc&itmmastid='+itmmastid+"&PyCode="+PyCode;
	
	$('#CheckPart').tree('options').url =encodeURI(url);
	$('#CheckPart').tree('reload');
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
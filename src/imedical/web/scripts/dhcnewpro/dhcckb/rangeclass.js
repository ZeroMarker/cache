/**
  *sufan 
  *2019-06-18
  *值域分类维护
  *
 **/
var editRow = ""; 
var CatId = getParam("parref");    //实体ID
var RangeId=CatId;
/// 页面初始化函数
function initPageDefault(){

	initRangeTree();     /// 初始值域分类树
	initDataGrid();      /// 页面DataGrid初始定义
	initBlButton();      /// 页面 Button 绑定事件
}

/// 值域分类树
function initRangeTree(){
	
	var params = "^"+CatId
	var uniturl = LINK_CSP+'?ClassName=web.DHCCKBRangeCat&MethodName=QueryRangeCatTree&params='+params;
	var option = {
		multiple:true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	        var RangeCatID = node.id; 	
	        CatId=RangeCatID;
			$("#Rangelist").datagrid("load",{"CatId":RangeCatID});
	    }, 
		onLoadSuccess: function(node, data){
			
		}
	};
	new CusTreeUX("RangeCat", uniturl, option).Init();
}

/// 页面DataGrid初始定义
function initDataGrid(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'ID',title:'ID',width:100,editor:textEditor},
		{field:'CDCode',title:'分类代码',width:200,editor:textEditor},
		{field:'CDDesc',title:'分类描述',width:200,editor:textEditor},
		{field:'CDType',title:'CDType',width:100,editor:textEditor},
		{field:'oper',title:'操作',width:150,formatter:SetCellOperation},
	]];
	
	///  定义datagrid
	var option = {
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
           CommonRowClick(rowIndex,rowData,"#Rangelist");
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryRangeCat&CatId"+CatId;
	new ListComponent('Rangelist', columns, uniturl, option).Init();
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	///  增加
	$('#insert').bind("click",insertRow);
	
	///  保存
	$('#save').bind("click",saveRow);
	
	///  删除
	$('#delete').bind("click",deleteRow);
	
	///  拼音码
	$('#RangeCatCode').searchbox({
		searcher : function (value, name) {
			var PyCode=$.trim(value);
			findRangeTree(PyCode);
		}
	});	
	
}

/// 查找检查项目树
function findRangeTree(PyCode){
	
	var params = PyCode +"^"+ CatId;
	var url = LINK_CSP+'?ClassName=web.DHCCKBRangeCat&MethodName=QueryRangeCatTree&params='+params;
	$("#RangeCat").tree('options').url =encodeURI(url);
	$("#RangeCat").tree('reload');
}

/// 插入
function insertRow(){
	
	/*var node = $("#itemCat").tree('getSelected');
	if (!node){
		$.messager.alert("提示","请选定具体项目后进行增加操作!"); 
        return;
    }
	var isLeaf = $("#itemCat").tree('isLeaf',node.target);   /// 是否是叶子节点
    if (!isLeaf){
		$.messager.alert("提示","请选定具体项目后进行增加操作!"); 
        return;
    }
    if (node.id.indexOf("^") != "-1"){
    	var TraID = node.id.split("^")[0];
    	var PartID = node.id.split("^")[1];
    }else{
		var TraID = node.id;
		var PartID = "";
	}*/
	commonAddRow({'datagrid':'#Rangelist',value:{ID:'', CDCode:'', CDDesc:'',CDType:CatId}});
	
}

///保存
function saveRow()
{
	// 使用此方法保存时，需要datagrid的列名和表字段名称相同，修改时ID默认固定
	comSaveByDataGrid("User.DHCCKBCommonDiction","#Rangelist",function(ret){
			if(ret=="0")
			{
				$("#Rangelist").datagrid('reload');
				var params="^"+CatId
				//var url = LINK_CSP+'?ClassName=web.DHCCKBDiction&MethodName=QueryAttrTreeList&params='+params;
				//$("#RangeCat").tree('options').url =encodeURI(url);
				$("#RangeCat").tree('reload');
			}
					
		}
	)
	
}

/// 删除检查项目,部位选中行
function deleteRow(){

	removeCom("User.DHCCKBCommonDiction","#Rangelist")
}
///设置操作明细连接
function SetCellOperation(value, rowData, rowIndex){

	var btnGroup = "<a style='margin-right:10px;' href='#' onclick=\"OpenWin('"+rowData.ID+"','prop')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>属性</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"OpenWin('"+rowData.ID+"','linkprop')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>附加属性</a>";
	
	return btnGroup;
}
function OpenWin(ID,model){

	var url="",titleName=""
	
	if (model =="prop"){
		
		url = "dhcckb.addattr.csp";
		titleName = "属性维护";
		
	}else if (model == "linkprop"){
		
		url = "dhcckb.addlinkattr.csp";
		titleName ="附加属性维护";
		
	}

	if($('#winmodel').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:titleName,
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:500
	});
	
	var cot = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+url+"?type="+ID+'"></iframe>';

	$('#winmodel').html(cot);
	$('#winmodel').window('open');

}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
/**
  *qunianpeng 
  *2019-06-18
  *属性维护
  *
 **/
var editRow = ""; 
var CatId = getParam("type");    //实体ID
var RangeId=CatId;
/// 页面初始化函数
function initPageDefault(){

	initDataGrid();      /// 页面DataGrid初始定义
	initBlButton();      /// 页面 Button 绑定事件
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
	
	var Attreditor={  
		type: 'combobox',	//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'AttrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDr'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrCode'});
				var AddAttrID = $(ed.target).val();
				///设置级联指针
				var ed=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'AttrDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAttrValue&AddAttrID="+ AddAttrID;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}

	///  定义columns
	var columns=[[
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'实体ID',width:100,editor:textEditor,hidden:true},
		{field:'CDDesc',title:'属性描述',width:200,editor:textEditor},
		{field:'DLAAttrCode',title:'属性代码',width:150,editor:textEditor,hidden:true},
		{field:'AttrDesc',title:'属性值描述',width:200,editor:textEditor},
		{field:'DLAAttrDr',title:'属性值',width:80,editor:textEditor,hidden:true},
		{field:'DLAResult',title:'备注',width:200,editor:textEditor}
	]];
	
	///  定义datagrid
	var option = {
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
           CommonRowClick(rowIndex,rowData,"#addattrlist");
            dataGridBindEnterEvent(rowIndex);
           editRow=rowIndex
        }
	};
	
	var params="LinkTemp^"+CatId;
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAddAttr&params="+params;
	new ListComponent('addattrlist', columns, uniturl, option).Init();
}

/// 页面 Button 绑定事件
function initBlButton(){	
	
	///  保存
	$('#save').bind("click",saveRow);
	
	/// 
	$('#link').bind("click",AddAttr);
}

///保存
function saveRow()
{
	// 使用此方法保存时，需要datagrid的列名和表字段名称相同，修改时ID默认固定
	comSaveByDataGrid("User.DHCCKBDicLinkAttr","#addattrlist",function(ret){
			if(ret=="0")
			{
				$("#addattrlist").datagrid('reload');
			}
					
		}
	)	
}

function AddAttr(){
	
	var linkUrl = "dhcckb.property.csp";
	linkUrl += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
	///window.location.href="dhcckb.property.csp";
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';

	if($('#editProp').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="editProp"></div>');
	$('#editProp').window({
		title:"添加属性",
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		//maximizable:true,
		width:800,
		height:500
	});	

	$('#editProp').html(openUrl);
	$('#editProp').window('open');
	
}

/// 
function dataGridBindEnterEvent(index){
	
	editRow=index;
	var editors = $('#addattrlist').datagrid('getEditors', index);

	for(var i=0;i<editors.length;i++){
		var workRateEditor = editors[i];
		
		//属性值描述  AttrDesc
		if(workRateEditor.field=="AttrDesc"){
			workRateEditor.target.mousedown(function(e){
				var ed=$("#addattrlist").datagrid('getEditor',{index:index, field:'AttrDesc'});		
				var input = $(ed.target).val();
				divComponent({tarobj:$(ed.target),htmlType:"tree",width: 400,height: 260},function(obj){
					var ed=$("#addattrlist").datagrid('getEditor',{index:index, field:'DLAAttrDr'});		
					$(ed.target).val(obj.id);				
				})				
			});			
		
		}
		else{
			workRateEditor.target.mousedown(function(e){
					$("#win").remove();;
			});
			workRateEditor.target.focus(function(e){
					$("#win").remove();;
			});
		}
	}
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
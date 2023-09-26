var TYPE="";
var POINTER="";

function onClickRowTar(index,row){
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarDesc');
	e.editor = {};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarStart');
	e.editor = {};
	CommonRowClick(index,row,"#tardatagrid");
}

function addRow(){
	if((TYPE=="")||(POINTER=="")){
		$.messager.alert('提示','请先选择')
		return
	}
	// sufan 由于双击时，关闭，再点增加，不可编辑
	var e = $("#tardatagrid").datagrid('getColumnOption', 'PartNum');
	e.editor = {type:'numberbox',options:{required:true}};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarStart');
	e.editor = {type:'datebox',options:{required:true}};
	var e = $("#tardatagrid").datagrid('getColumnOption', 'TarDesc');
	e.editor = {type:'combogrid',options:{
										required : true,
										id:'AORowId',
										fitColumns:true,
										fit: true,//自动大小
										pagination : true,
										panelWidth:600,
										textField:'desc', 
										mode:'remote',
										url:'dhcapp.broker.csp?ClassName=web.DHCAPPPosLinkTar&MethodName=QueryTar',
										columns:[[
												{field:'tarId',hidden:true},
												{field:'code',title:'代码',width:60},
												{field:'desc',title:'名称',width:100},
												{field:'price',title:'收费项价格',width:40}
												]],
												onSelect:function(rowIndex, rowData) {
			                   					fillValue(rowIndex, rowData);
			                				}	
										}
									};
	commonAddRow({'datagrid':'#tardatagrid',value:{'Pointer':POINTER,'Type':TYPE,'PartNum':1,'TarStart':new Date().Format("yyyy-MM-dd")}})
}

function save(){
	saveByDataGrid("web.DHCAPPPosLinkTar","save","#tardatagrid",function(data){
		if(data==0){
			$.messager.alert('提示','保存成功')
			$('#tardatagrid').datagrid('reload')
		}else if(data==-10){//修改
			$.messager.alert('提示','该收费项已存在')
			$('#tardatagrid').datagrid('reload'); //重新加载
		}else if(data==-11){//修改
			$.messager.alert('提示','开始时间大于结束时间')
			$('#tardatagrid').datagrid('reload'); //重新加载
		}else if(data==-12){
			$.messager.alert('提示','结束日期早于今天')
			$('#tardatagrid').datagrid('reload'); //重新加载
		}else{
			$.messager.alert('提示','保存失败:'+data)
		}
	})
}
function fillValue(rowIndex, rowData){
	$('#tardatagrid').datagrid('getRows')[editIndex]['APLTarDr']=rowData.tarId
	$('#tardatagrid').datagrid('getRows')[editIndex]['TarCode']=rowData.code
	$('#tardatagrid').datagrid('getRows')[editIndex]['TarPrice']=rowData.price
}
function onClickRowPos(index,row){
	TYPE="POS";
	POINTER=row.aprowid
	$('#tardatagrid').datagrid('load',{type:TYPE,pointer:POINTER});
}

function onClickRowMed(index,row){
	TYPE="MED";
	POINTER=row.adrowid
	$('#tardatagrid').datagrid('load',{type:TYPE,pointer:POINTER});
}

$(function(){

	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
})
$(function(){
	$('#druggridss').datagrid({
		width:300,
		url:'',
		title:'aa',
		iconCls:'icon-add',
		singleSelect:true,
		toolbar:'#tb',
		columnss:[
			{field:'inciRowid',title:'Rowid',width:50},
			{field:'inciDesc',title:'Rowid',width:100},
			{field:'inciRowid',title:'Rowid',width:100}
		]
	});
})
//examinecenter.js
//问题中心
$(function(){
	initDatagrid();
	initBtn();
})

//初始化表格
function initDatagrid(){
	$("#datagrid").datagrid({
		nowrap:false,
		border:true,
		rownumbers:true,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		data:{
			rows:[
			{id:'1',RowID:'5254810',CMParrfDr:'1',CMItemDr:'注射用英夫利西单抗100mg（Cilag AG）',CMProDr:'用法',CMFunDr:'用药频率',CMTipsMsg:'',CMManLevDr:'提示',CMOrderDr:''},
			{id:'2',RowID:'5254811',CMParrfDr:'2',CMItemDr:'艾司奥美拉唑镁肠溶片40mg(阿斯利康制药有限公司)',CMProDr:'用法',CMFunDr:'用药频率',CMTipsMsg:'',CMManLevDr:'提示',CMOrderDr:''},
			{id:'3',RowID:'5254812',CMParrfDr:'2',CMItemDr:'艾司奥美拉唑镁肠溶片40mg(阿斯利康制药有限公司)',CMProDr:'用法',CMFunDr:'用药频率',CMTipsMsg:'',CMManLevDr:'提示',CMOrderDr:''},
			{id:'4',RowID:'5254813',CMParrfDr:'3',CMItemDr:'艾司奥美拉唑镁肠溶片40mg(阿斯利康制药有限公司)',CMProDr:'用法用量',CMFunDr:'每日用药量',CMTipsMsg:'',CMManLevDr:'提示',CMOrderDr:''},
			{id:'5',RowID:'5254814',CMParrfDr:'3',CMItemDr:'碘化钾片',CMProDr:'禁忌症',CMFunDr:'特殊人群',CMTipsMsg:'',CMManLevDr:'禁止',CMOrderDr:''},
			{id:'6',RowID:'5254815',CMParrfDr:'4',CMItemDr:'碘化钾片',CMProDr:'管饲、鼻饲给药途径',CMFunDr:'剂型',CMTipsMsg:'',CMManLevDr:'提示',CMOrderDr:''},
			{id:'7',RowID:'5254816',CMParrfDr:'5',CMItemDr:'维生素E烟酸酯胶囊',CMProDr:'注意事项',CMFunDr:'特殊人群',CMTipsMsg:'',CMManLevDr:'提示',CMOrderDr:''},
			],
			total:10
		},
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		fitColumns:true,
		idField:'id',
		singleSelect:false,
		pagination:true,
		pageSize:10,
		pageList:[10,20,40,100]
	})
}

//初始化按钮
function initBtn(){
	$("#searchBTN").click(function(){
		search();	
	});
}

//表格查询
function search(){
	var stdate = $("#stdate").datebox("getValue");
	var eddate = $("#eddate").datebox("getValue");
	$('#datagrid').datagrid('load',{
		'stdate':stdate,
		'eddate':eddate,
	});
}
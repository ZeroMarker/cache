//examinecenter.js
//��������
$(function(){
	initDatagrid();
	initBtn();
})

//��ʼ�����
function initDatagrid(){
	$("#datagrid").datagrid({
		nowrap:false,
		border:true,
		rownumbers:true,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		data:{
			rows:[
			{id:'1',RowID:'5254810',CMParrfDr:'1',CMItemDr:'ע����Ӣ����������100mg��Cilag AG��',CMProDr:'�÷�',CMFunDr:'��ҩƵ��',CMTipsMsg:'',CMManLevDr:'��ʾ',CMOrderDr:''},
			{id:'2',RowID:'5254811',CMParrfDr:'2',CMItemDr:'��˾��������þ����Ƭ40mg(��˹������ҩ���޹�˾)',CMProDr:'�÷�',CMFunDr:'��ҩƵ��',CMTipsMsg:'',CMManLevDr:'��ʾ',CMOrderDr:''},
			{id:'3',RowID:'5254812',CMParrfDr:'2',CMItemDr:'��˾��������þ����Ƭ40mg(��˹������ҩ���޹�˾)',CMProDr:'�÷�',CMFunDr:'��ҩƵ��',CMTipsMsg:'',CMManLevDr:'��ʾ',CMOrderDr:''},
			{id:'4',RowID:'5254813',CMParrfDr:'3',CMItemDr:'��˾��������þ����Ƭ40mg(��˹������ҩ���޹�˾)',CMProDr:'�÷�����',CMFunDr:'ÿ����ҩ��',CMTipsMsg:'',CMManLevDr:'��ʾ',CMOrderDr:''},
			{id:'5',RowID:'5254814',CMParrfDr:'3',CMItemDr:'�⻯��Ƭ',CMProDr:'����֢',CMFunDr:'������Ⱥ',CMTipsMsg:'',CMManLevDr:'��ֹ',CMOrderDr:''},
			{id:'6',RowID:'5254815',CMParrfDr:'4',CMItemDr:'�⻯��Ƭ',CMProDr:'���ǡ����Ǹ�ҩ;��',CMFunDr:'����',CMTipsMsg:'',CMManLevDr:'��ʾ',CMOrderDr:''},
			{id:'7',RowID:'5254816',CMParrfDr:'5',CMItemDr:'ά����E����������',CMProDr:'ע������',CMFunDr:'������Ⱥ',CMTipsMsg:'',CMManLevDr:'��ʾ',CMOrderDr:''},
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

//��ʼ����ť
function initBtn(){
	$("#searchBTN").click(function(){
		search();	
	});
}

//����ѯ
function search(){
	var stdate = $("#stdate").datebox("getValue");
	var eddate = $("#eddate").datebox("getValue");
	$('#datagrid').datagrid('load',{
		'stdate':stdate,
		'eddate':eddate,
	});
}
/**
 * bjyy.cqmx.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-12-13
 * 
 * 
 */
var PageLogicObj = {
	
}

$(function() {
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	//PageHandle();
})


function Init(){
	
	PageLogicObj.m_DrugEfficacy = $HUI.combobox("#DrugEfficacy",{
		valueField:'id', 
		textField:'text', 
		//multiple:true,
		//selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
		data:[
			{id:'1',text:'��ת'},{id:'2',text:'��'}
			,{id:'3',text:'����'},{id:'4',text:'�ޱ仯'}
			,{id:'5',text:'��Ժ'}
		]
	});
	
	PageLogicObj.m_StopReason = $HUI.combobox("#StopReason",{
		valueField:'id', 
		textField:'text', 
		//multiple:true,
		//selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
		data:[
			{id:'1',text:'�����ݻ�ҩ'},{id:'2',text:'��ҩ'}
			,{id:'3',text:'������ҩ'},{id:'4',text:'ͣҩ'}
			,{id:'5',text:'����'}
		]
	});
	
	
	PageLogicObj.m_SideEffect = $HUI.combobox("#SideEffect",{
		valueField:'id', 
		textField:'text', 
		//multiple:true,
		//selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
		data:[
			{id:'1',text:'��'},{id:'2',text:'�����Ⱦ'}
			,{id:'3',text:'��к'},{id:'4',text:'̼��ùϩ��ҩ���˾�'}
			,{id:'5',text:'̼��ùϩ��ҩ�����˾�'}
			,{id:'6',text:'̼��ùϩ��ҩͭ�̼ٵ�����'}
			,{id:'7',text:'����'}
		]
	});
	
	
}

function InitEvent () {
	$("#i-save").click(function () {
		
		alert(111)
		
		
		
	})
}


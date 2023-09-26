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
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
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
			{id:'1',text:'好转'},{id:'2',text:'恶化'}
			,{id:'3',text:'死亡'},{id:'4',text:'无变化'}
			,{id:'5',text:'出院'}
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
			{id:'1',text:'降阶梯换药'},{id:'2',text:'换药'}
			,{id:'3',text:'加量用药'},{id:'4',text:'停药'}
			,{id:'5',text:'其他'}
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
			{id:'1',text:'无'},{id:'2',text:'真菌感染'}
			,{id:'3',text:'腹泻'},{id:'4',text:'碳青霉烯耐药肠杆菌'}
			,{id:'5',text:'碳青霉烯耐药不动杆菌'}
			,{id:'6',text:'碳青霉烯耐药铜绿假单胞菌'}
			,{id:'7',text:'其他'}
		]
	});
	
	
}

function InitEvent () {
	$("#i-save").click(function () {
		
		alert(111)
		
		
		
	})
}


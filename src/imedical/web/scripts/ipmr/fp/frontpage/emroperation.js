/**
 * 首页诊断信息
 * 
 * Copyright (c) 2018-2022 LIYI. All rights reserved.
 * 
 * CREATED BY LIYI 2022-02-17
 * 
 * 注解说明
 * TABLE: 
 */
// 页面全局变量对象
var globalObj = {
}

// 页面入口
$(function(){
	$cm({
		ClassName:"MA.IPMR.FPS.CodeOperSrv",
		QueryName:"QryOper",
		aVolumeID:ServerObj.VolumeID,
		aFPConfig:ServerObj.DefaultFPConfig,
		aEmrFlag:1,
    	page:1,
    	rows:10000
    },function(rs){
    	var json = rs;
    	initEmrOper(json.rows);
    });
})

/**
 * 首页诊断列表
 */
function initEmrOper(array){
	var columns = [[
		{field:'Index',title:'序号',width:50,align:'left'},
		{field:'TypeDesc',title:'手术类型',width:100,align:'left'},
		{field:'ICD10',title:'手术编码',width:120,align:'left'},		
		{field:'ICDDesc',title:'手术名称',width:200,align:'left'},			
		{field:'SttDate',title:'手术日期',width:100,align:'left'},	
		{field:'SttTime',title:'开始时间',width:100,align:'left',hidden:ServerObj.CodeShowOperSttTime=='1'?false:true},
		{field:'EndDate',title:'结束日期',width:100,align:'left',hidden:ServerObj.CodeShowOperEndDate=='1'?false:true},			
		{field:'EndTime',title:'结束时间',width:100,align:'left',hidden:ServerObj.CodeShowOperEndTime=='1'?false:true},
		{field:'DurationTime',title:'手术持续时间',width:100,align:'left',editor:'text',hidden:ServerObj.CodeShowOperDurationTime=='1'?false:true},
		{field:'OperSiteDesc',title:'手术部位',width:100,align:'left',hidden:ServerObj.CodeShowOperSite=='1'?false:true},
		{field:'Operator',title:'术者',width:90,align:'left'},
		{field:'OperLocDesc',title:'术者所在科室',width:120,align:'left',hidden:ServerObj.CodeShowOperLoc=='1'?false:true},
		{field:'Assistant1',title:'Ⅰ助',width:90,align:'left'},
		{field:'Assistant2',title:'Ⅱ助',width:90,align:'left'},
		{field:'NarcosisTypeDesc',title:'麻醉方式',width:120,align:'left'},
		{field:'NarcosisSttDate',title:'麻醉开始日期',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisSttDate=='1'?false:true},	
		{field:'NarcosisSttTime',title:'麻醉开始时间',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisSttTime=='1'?false:true},
		{field:'NarcosisEndDate',title:'麻醉结束日期',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisEndDate=='1'?false:true},			
		{field:'NarcosisEndTime',title:'麻醉结束时间',width:100,align:'left',hidden:ServerObj.CodeShowNarcosisEndTime=='1'?false:true},
		{field:'NarcosisLevelDesc',title:'麻醉分级',width:80,align:'left',hidden:ServerObj.CodeShowNarcosisLevel=='1'?false:true},
		{field:'NarcosisDoc',title:'麻醉医师',width:90,align:'left'},
		{field:'CutTypeDesc',title:'切口类型',width:80,align:'left'},
		{field:'HealingDesc',title:'愈合情况',width:80,align:'left'},
		{field:'OperLevelDesc',title:'手术级别',width:80,align:'left'},
		{field:'BackOperDesc',title:'非计划重返',width:90,align:'left',hidden:ServerObj.CodeShowBackOper=='1'?false:true},
		{field:'NNISLevelDesc',title:'手术风险等级',width:100,align:'left',hidden:ServerObj.CodeShowNNISLevel=='1'?false:true},
		{field:'OperCatDesc',title:'手术类别',width:80,align:'left',hidden:ServerObj.CodeShowOperCat=='1'?false:true},
		{field:'IsEmergencyDesc',title:'是否急诊',width:80,align:'left',hidden:ServerObj.CodeShowIsEmergency=='1'?false:true},
		{field:'IsMiniInvaDesc',title:'是否微创',width:80,align:'left',hidden:ServerObj.CodeShowIsMiniInva=='1'?false:true},
		{field:'IsChooseDateDesc',title:'是否择期',width:80,align:'left',hidden:ServerObj.CodeShowIsChooseDate=='1'?false:true},
		{field:'AisOperID',title:'临床手术ID',width:80,align:'left',hidden:ServerObj.CodeShowAisOperID=='1'?false:true},
		{field:'MainOperDesc',title:'主手术',width:80,align:'left',hidden:ServerObj.CodeShowMainOper=='1'?false:true}
    ]];
    var gridEmrOper = $('#gridEmrOper').datagrid({
		fit: true,
		iconCls : 'icon-write-order',
		singleSelect : true,
		pagination : false, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10000,
		fitColumns : false,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    columns : columns,
	    data: array,
	    onDblClickRow: function(index,row) {
	    	var frames = window.parent.frames;
			for (i=0;i<frames.length;i++) {
				var frame = frames[i];
				if (frame.location.pathname=="/imedical/web/csp/ma.ipmr.fp.frontpage.main.csp") {
					frame.addOperFromEmr(row)
				}
			}
	    }
	});
}

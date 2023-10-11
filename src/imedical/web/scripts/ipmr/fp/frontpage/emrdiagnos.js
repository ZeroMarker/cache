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
    	ClassName:"MA.IPMR.FPS.CodeDiagSrv",
		QueryName:"QryDiag",
		aVolumeID:ServerObj.VolumeID,
		aFPConfig:ServerObj.DefaultFPConfig,
		aEmrFlag:1,
    	page:1,
    	rows:10000
    },function(rs){
    	var json = rs;
    	initEmrDiag(json.rows);
    });
})

/**
 * 首页诊断列表
 */
function initEmrDiag(array){
	var columns = [[
		{field:'Index',title:'序号',width:50,align:'left'},
		{field:'TypeDesc',title:'诊断类型',width:120,align:'left'},
		{field:'ICD10',title:'疾病编码',width:160,align:'left'},		
		{field:'ICDDesc',title:'疾病名称',width:250,align:'left'},	
		{field:'InjuryICDDesc',title:'损伤中毒外部原因',width:250,align:'left',hidden:ServerObj.CodeShowInjuryICD=='1'?false:true,},
		{field:'TumICDDesc',title:'肿瘤形态学',width:250,align:'left',hidden:ServerObj.CodeShowTumICD=='1'?false:true,},
		{field:'TumDifferDesc',title:'分化程度',width:100,align:'left',hidden:ServerObj.CodeShowTumDiffer=='1'?false:true,},
		{field:'TumStagesDesc',title:'肿瘤分期',width:100,align:'left',hidden:ServerObj.CodeShowTumStages=='1'?false:true,},
		{field:'AdmitCondDesc',title:'入院病情',width:100,align:'left',},
		{field:'DischCondDesc',title:'出院情况',width:100,align:'left',hidden:ServerObj.CodeShowDischCond=='1'?false:true,}
    ]];
    var gridEmrDiag = $('#gridEmrDiag').datagrid({
		fit: true,
		iconCls : 'icon-write-order',
		singleSelect : true,
		pagination : false, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10000,
		fitColumns : true,
		checkOnSelect:true,		//true,击某一行时，选中/取消选中复选框
		selectOnCheck:true,		//true,点击复选框将会选中该行
	    columns : columns,
	    data: array,
	    onDblClickRow: function(index,row) {
	    	var frames = window.parent.frames;
			for (i=0;i<frames.length;i++) {
				var frame = frames[i];
				if (frame.location.pathname=="/imedical/web/csp/ma.ipmr.fp.frontpage.main.csp") {
					frame.addDiagFromEmr(row)
				}
			}
	    }
	});
}

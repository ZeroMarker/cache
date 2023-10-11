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
main_url='/imedical/web/csp/ma.ipmr.fp.frontpage.main.csp';
// 页面全局变量对象
var globalObj = {
}

// 页面入口
$(function(){
	initgridICD();
    $('#searchICD').searchbox({
		searcher:function (value,name) {
			serchICDDx(value);
        }
    });
})

/**
 * 首页诊断列表
 */
function initgridICD(array){
	var columns = [[
		{field:'OperTypeDesc',title:'手术类型',width:80,align:'left',hidden:ServerObj.icdType=='D'?true:false},
		{field:'ICD10',title:ServerObj.icdType=='D'?'诊断编码':'手术编码',width:120,align:'left'},
		{field:'Desc',title:ServerObj.icdType=='D'?'诊断名称':'手术名称',width:160,align:'left'},
		{field:'OperLevelDesc',title:'手术级别',width:80,align:'left',hidden:ServerObj.icdType=='D'?true:false},
		{field:'replace',title:ServerObj.icdType=='D'?'替换诊断':'替换手术',width:50,align:'left',hidden:ServerObj.selectTypeID==''?true:false,
			formatter:function(value,rowData,rowIndex){
				return "<a style='white-space:normal;color:#229A06' onclick='replaceFromSearch(\"" + rowData.ID + "\""+",\"" +rowData.ICD10 + "\""+",\"" +rowData.Desc + "\""+",\"" +rowData.OperTypeID + "\""+",\"" +rowData.OperTypeDesc + "\""+",\"" +rowData.OperLevelID + "\""+",\"" +rowData.OperLevelDesc + "\");'>" + $g("替换") + "</a>"; 
			}  
      	}
    ]];
    var gridICD = $('#gridICD').datagrid({
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
	    url:$URL,
	    queryParams:{
		    ClassName : "CT.IPMR.FPS.ICDDxSrv",
			QueryName : "QryICDDx",
			aVerID :'',
			aTypeID:'',
			aAlias : $('#searchICD').searchbox('getValue'),
			aIsActive:1,
			aICDDxID:''
		}
	});
}

/**
 * 检索icd
 * @param {aliasICD}检索条件
 * @return {void}
 */
function serchICDDx(aliasICD) {
	if (aliasICD == "") {
		$.messager.popover({msg: '请输入别名...',type:'alert'});
		return false;
	}
	$("#gridICD").datagrid("reload", {
		ClassName : "CT.IPMR.FPS.ICDDxSrv",
		QueryName : "QryICDDx",
		aVerID :ServerObj.icdVerID,
		aTypeID:ServerObj.icdType=='D'?ServerObj.selectTypeID:'',
		aAlias : aliasICD,
		aIsActive:1,
		aICDDxID:''
	});
	return ;
}
 /**
 * 检索icd替换选中的诊断编码
 * @param {id}替换的id
 * @return {void}
 */
function replaceFromSearch(id,icd10,icddesc,operTypeID,operTypeDesc,operLevelID,operLevelDesc){
	var frames = window.parent.frames;
	if (ServerObj.icdType=='D'){
		for (i=0;i<frames.length;i++) {
			var frame = frames[i];
			if (frame.location.pathname==main_url) {
				frame.replaceDiagFromSearch(id,icd10,icddesc)
				$.messager.popover({msg: '替换成功...',type:'success'});
			}
		}
	}else{
		for (i=0;i<frames.length;i++) {
			var frame = frames[i];
			if (frame.location.pathname==main_url) {
				frame.replaceOperFromSearch(id,icd10,icddesc,operTypeID,operTypeDesc,operLevelID,operLevelDesc)
				$.messager.popover({msg: '替换成功...',type:'success'});
			}
		}
	}
}

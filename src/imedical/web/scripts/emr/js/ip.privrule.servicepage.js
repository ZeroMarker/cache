$(function(){
	initHospGroup();
	
	initPrivRuleType();
	loadPrivRuleType();
	
	initPrivRule();
	initUserInfo()
	
	initPrivDbgResult()
	
	initEMRDocument()
	initEMRDocumentData()
	
})

//初始化医院名称
function initHospGroup(){
	$('#txtHospName').triggerbox('disable');
	$("#txtHospName").triggerbox('setValue', setting.hospDesc);
}

//加载权限类型
function initPrivRuleType()
{
	$HUI.combogrid('#cbxdgPrivType',{
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		singleSelect:true,
		panelWidth: 300,
		blurValidValue:true,
		idField: 'name',
        textField: 'description',
		autoSizeColumn:false,
		fitColumns:true,
		columns:[[
			{field:'id',title:'ID',width:30},
			{field:'name',title:'代码',width:80},
			{field:'description',title:'名称',width:90}
		]],
		onSelect:function(i,row){
			//权限加载

			setting.privRuleType = row.name;
			setting.privRuleTypeDesc = row.description;
			
			loadPrivRule();
			
			loadPrivRuleConfig();
			
		}
	})
	
}

function loadPrivRuleConfig()
{
	
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetPrivRuleConfig",
			"p1":setting.hospGroupId,
			"p2":setting.privRuleType
		},
		success : function(d) {
			
	    	$("#curPrivRuleType").text(setting.privRuleType);
			
			$("#switchPrivRuleType").switchbox("setValue",d.data=="true"?true:false);
			
		},
		error : function(d) { 
			$.messager.popover({msg: "GetPrivRuleConfig："+d ,type:'alert'});
		}
	});
	
	return;
	

}
function loadPrivRuleType()
{
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetPrivRuleType"
		},
		success : function(d) {
	    	loadComboGridData("cbxdgPrivType",d);
		},
		error : function(d) { 
			$.messager.popover({msg: "cbxPrivType:"+d ,type:'alert'});
		}
	});
	return;
}

//初始化脚本列表
function initPrivRule()
{
	$HUI.datagrid('#dgPrivRule',{
		idField:'id',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		singleSelect:true,
		title:'权限仓库明细',
		autoSizeColumn:false,
		fitColumns:true,
		onClickRow: onClickRow,
		fit:true,

		columns:[[
			{field:'ck',title:'ckbox',checkbox:true},
			{field:'changeflag',title:' ',align:'center', width:10},
			{field:'id',title:'代码',width:40},
			{field:'storename',title:'描述',width:160},
			{field:'isactive',title:'是否启用',width:80,
				editor:{
					type:'switchbox',
					options:{onClass:'primary',offClass:'gray',onText:'启用',offText:'停用'}
				}
			},
			{field:'storeid',title:'脚本库ID',width:200,showTip:true,tipWidth:450,hidden:true},
			{field:'storecode',title:'脚本编码',width:160,tipWidth:450,hidden:true},
			{field:'ruletypeid',title:'规则类型ID',width:40,hidden:true},
			{field:'sequece',title:'执行顺序',width:40,hidden:true},
			{field:'privruleid',title:'关联权限ID',width:40,hidden:true},
			{field:'befocus',title:'定位脚本',width:40,hidden:true},
			{field:'haschanged',title:'变更',width:20, hidden:true}
			
		]],
		rowStyler:function(index,row)
		{
			if (row.befocus==true)
			{
				return 'background-color:#6293BB;color:#fff;font-weight:bold;';
			}
			if (row.haschanged==true)
			{
				setting.privrulechanged = true;
				return row.changeflag = "<span style='color:red'>*</span>";
			}
		}

	})
}
function loadPrivRule()
{
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetPrivRule",
			"p1":setting.hospId,
			"p2":setting.privRuleType
		},
		success : function(d) {
	    	loadDgData("dgPrivRule",d);
		},
		error : function(d) { 
			$.messager.popover({msg: "dgPrivRule:"+d ,type:'alert'});
		}
	});
	return result;
}

function loadDgData(id,data)
{
	$("#"+id).datagrid("loadData",data)

}

function loadComboGridData(id,data)
{
	$HUI.combogrid("#"+id).grid().datagrid("loadData",data)

}

function upRow(rowindex){
	
   	var row = $('#dgPrivRule').datagrid('getSelected');
   	
   	if (row==null) 
	{
		$.messager.popover({msg: "请勾选要向上移动的权限条目" ,type:'alert'});
		return;
	};
   	
    var rowindex = $('#dgPrivRule').datagrid('getRowIndex',row);
    
    if(rowindex === 0) 
    { 
    	$.messager.popover({msg: "已经移动至第一条" ,type:'alert'});
    	return;
    }
	
	$('#dgPrivRule').datagrid('insertRow',{index:rowindex-1,row:row});
	
	$('#dgPrivRule').datagrid('deleteRow',rowindex+1);
	
	$('#dgPrivRule').datagrid('selectRow',rowindex-1);
	
	$('#dgPrivRule').datagrid('getRows')[rowindex-1].haschanged = true;
	$('#dgPrivRule').datagrid('refreshRow',rowindex-1)
 }
 
function downRow(){
	 
	var row = $('#dgPrivRule').datagrid('getSelected');
	if (row==null) 
	{
		$.messager.popover({msg: "请勾选要向下移动的权限条目" ,type:'alert'});
		return;
	};
    var rowindex = $('#dgPrivRule').datagrid('getRowIndex',row);        
	
	if(rowindex === $('#dgPrivRule').datagrid('getRows').length-1) 
	{ 
		$.messager.popover({msg: "已经移动至最后一条" ,type:'alert'});
		return;
	}
	
	$('#dgPrivRule').datagrid('insertRow',{index:rowindex+2,row:row});
	
	$('#dgPrivRule').datagrid('deleteRow',rowindex);
	
	$('#dgPrivRule').datagrid('selectRow',rowindex+1);
	
	$('#dgPrivRule').datagrid('getRows')[rowindex+1].haschanged = true;
	$('#dgPrivRule').datagrid('refreshRow',rowindex+1)

}

function savePrivRule()
{

	endEditing();
	
	$('#dgPrivRule').datagrid('getRows').forEach(function(row,index)
	{
		if (row.changeflag != undefined)
		{
				row.changeflag = "";
		}
				
	})
	
	
	var privRuleDetailString=JSON.stringify($('#dgPrivRule').datagrid('getData'));
	//处理前后台交互时，因为delete字符被异常解析，p3参数值被清空，导致保存异常。用delte代替delete，后台还原为delete。
	privRuleDetailString = privRuleDetailString.split("delete").join("delte");
	
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"SavePrivRule",
			"p1":setting.hospGroupId,
			"p2":setting.privRuleType,
			"p3":privRuleDetailString
		},
		success : function(d) {
			if (d.status=='suc')
			{
				loadPrivRule();
				$.messager.popover({msg: "脚本生成成功!" ,type:'alert'});
				setting.privrulechanged = false;
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "savePrivRule:"+d ,type:'alert'});
		}
	});
	
	return;
}

///测试页面
$HUI.combogrid('#cbgDbgUser',{
	headerCls:'panel-header-gray',
	iconCls:'icon-paper',
	singleSelect:true,
	panelWidth: 500,
    blurValidValue:true,
    idField: 'userid',
    textField: 'username',
   	autoSizeColumn:false,
    fitColumns: true,
    columns: [[
    	{field:'userid',title:'用户ID',width:80,hidden:true},
        {field:'usercode',title:'账号',width:80},
        {field:'username',title:'用户名',width:120}
    ]],
	onSelect:function(i,row){
		
		//权限加载
		setting.userid = row.userid;
		setting.usercode = row.usercode;
			
		loadUserLogonInfo();
			
	}
})

$HUI.combogrid('#cbgDbgLogon',{
	headerCls:'panel-header-gray',
	iconCls:'icon-paper',
	singleSelect:true,
	panelWidth: 500,
    blurValidValue:true,
    idField: 'id',
    textField: 'ctlocdesc',
   	autoSizeColumn:false,
    fitColumns: true,
    columns: [[
    	{field:'id',title:'ID',width:80,hidden:true},
        {field:'ctlocid',title:'科室ID',width:80,hidden:true},
        {field:'ctlocdesc',title:'科室名称',width:120},
        {field:'ssgroupid',title:'安全组ID',width:80,hidden:true},
        {field:'ssgroupdesc',title:'安全组',width:120},
        {field:'hospid',title:'院区ID',width:80,hidden:true},
        {field:'hospdesc',title:'院区名称',width:120}
    ]],
	onSelect:function(i,row){
		
		//权限加载
		setting.userloc = row.ctlocid;
		setting.ssgroupid = row.ssgroupid;
		initComboGridEpisode()
			
	}
})


$HUI.combogrid('#cbgDbgEpisode',{
	headerCls:'panel-header-gray',
	iconCls:'icon-paper',
	singleSelect:true,
	panelWidth: 500,
    blurValidValue:true,
    idField: 'episodeid',
    textField: 'name',
   	autoSizeColumn:false,
    fitColumns: true,
    columns: [[
    	{field:'bedno',title:'床号',width:80},
    	{field:'episodeid',title:'就诊号',width:80},
        {field:'name',title:'姓名',width:80},
        {field:'ctlocdesc',title:'科室',width:80},
        {field:'admdatetime',title:'入院时间',width:120}
    ]],
	onSelect:function(i,row){
		
		setting.admid = row.episodeid;
			
	}
})

function initComboGridEpisode()
{

	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetUserLocEpisode",
			"p1":setting.userloc
		},
		success : function(d) {
			if (d.status=='suc')
			{
				loadComboGridData("cbgDbgEpisode",d.data);
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "cbgDbgEpisode："+d ,type:'alert'});
		}
	});

}
//初始化脚本列表
function initEMRDocument()
{
	$HUI.treegrid('#tgdDbgEMRDocument',{
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		idField:'id',
		treeField:'templatename',
		rownumbers:true,
		autoSizeColumn:false,
		//checkbox:true,
		fit:true,
	    columns:[[
	    	{field:'id',title:'ID',width:80,hidden:true},
	    	{field:'docid',title:'模板ID',width:80,hidden:true},
	        {field:'templatename',title:'文档名称',width:320},
	        {field:'instanceid',title:'实例ID',width:120},
	        {field:'templateid',title:'模板ID',width:80,hidden:true},
	        {field:'categoryid',title:'模板目录ID',width:120,hidden:true}
	    ]],
		onSelect:function(i,row){
			
			//权限加载
			setting.docid = row.docid;
			setting.instanceid = row.instanceid;
			setting.templateid = row.templateid;
			setting.categoryid = row.categoryid;
				
		}
	})
}
function initUserInfo()
{
	var filterText= "" //$("cbgDbgUser").combogrid('getValue');
	
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetUserInfo",
			"p1":filterText
		},
		success : function(d) {
			if (d.status=='suc')
			{
				loadComboGridData("cbgDbgUser",d.data);
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "cbgDbgUser："+d ,type:'alert'});
		}
	});	
}
function loadUserLogonInfo()
{
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetUserLogonInfo",
			"p1":setting.userid
		},
		success : function(d) {
			if (d.status=='suc')
			{
				loadComboGridData("cbgDbgLogon",d.data);
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "cbgDbgLogon："+d ,type:'alert'});
		}
	});	
	
}

function initEMRDocumentData()
{
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetEMRDocument",
			"p1":setting.hospId,
			"p2":setting.userloc,
			"p3":setting.episodeid
		},
		success : function(d) {
			if (d.status=='suc')
			{
				$("#tgdDbgEMRDocument").treegrid("loadData",d.data)
			}
			else if (d.status=="err")
			{
				$.messager.popover({msg: "初始化模板目录异常："+d.message ,type:'alert'});
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "初始化模板目录："+d ,type:'alert'});
		}
	});	
	
}


//初始化脚本列表
function initPrivDbgResult()
{
	$HUI.datagrid('#dgDbgResult',{
		idField:'code',
		rownumbers:true,
		singleSelect:true,
		title:'测试结果',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		autoSizeColumn:false,
		fitColumns:true,
		toolbar:[{iconCls: 'icon-eye',
			text:'追踪',
			handler: function(){
				focusStore();
			}
		},"-","-"],
		columns:[[
			{field:'ck',title:'ckbox',checkbox:true},
			{field:'code',title:'代码',width:40},
			{field:'value',title:'结果',width:80}
		]]

	})
}

function focusStore()
{
	var objselected= $("#dgDbgResult").datagrid('getSelected');
	
	$('#dgPrivRule').datagrid('getRows').forEach(function(row,index)
	{	
		if (row.storecode.split(objselected.code + "="+ objselected.value).length > 1)
		{
			row.befocus = true;
		}
		else
		{
			row.befocus = "";
		}
						
	})
	
	$("#dgPrivRule").datagrid("loadData",$('#dgPrivRule').datagrid('getRows'))
	
	$.messager.popover({msg: "同步仓库脚本完成，下一步'生成脚本'" ,type:'alert'});
		
}


$("#btnTest").on("click",function(){
	
	//初始化参数
	enviromentInfo = getdbgparameter()
	//序列化为标准数据
	
	privRuleScriptCheck(enviromentInfo);
		
})
function getdbgparameter()
{
	var result="";
	//var enviromentInfo ="userid^3928!admid^201871!patientid^1!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67!isnewframework^1!eprnum^1"
	
	//设置默认值
	var enviromentInfo = {}
	enviromentInfo.userid = setting.userid==""?3928:setting.userid
	enviromentInfo.admid = setting.admid==""?11:setting.admid
	enviromentInfo.patientid = setting.patientid==""?1:setting.patientid
	enviromentInfo.userloc = setting.userloc==""?34:setting.userloc
	enviromentInfo.templateid = setting.templateid==""?822:setting.templateid
	enviromentInfo.ssgroupid = setting.ssgroupid==""?576:setting.ssgroupid
	enviromentInfo.categoryid=setting.categoryid==""?642:setting.categoryid
	enviromentInfo.docid = setting.docid==""?67:setting.docid
	enviromentInfo.isnewframework=setting.isnewframework==""?1:setting.isnewframework
	enviromentInfo.eprnum =setting.eprnum==""?1:setting.eprnum
	
	//前后台交互完成数据动态填充
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetEnvParameter",
			"p1":JSON.stringify(enviromentInfo)
		},
		success : function(d) {
			if (d.status=='suc')
			{
				result = d.data;
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "脚本验证："+d ,type:'alert'});
		}
	});	
	return result;
}
function privRuleScriptCheck(enviromentInfo)
{
	var resultInfo="";
	var curprivRuleDetailString = "";
	
	if (setting.privrulechanged == true)
	{
		endEditing();
		curprivRuleDetailString=JSON.stringify($('#dgPrivRule').datagrid('getData'));
		//处理前后台交互时，因为delete字符被异常解析，p3参数值被清空，导致保存异常。用delte代替delete，后台还原为delete。
		curprivRuleDetailString = curprivRuleDetailString.split("delete").join("delte");
	}
		
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"Test",
			"p1":setting.hospId,
			"p2":setting.privRuleType,
			"p3":JSON.stringify(enviromentInfo),
			"p4":curprivRuleDetailString
		},
		success : function(d) {
			if (d.status=='suc')
			{
				loadDgData("dgDbgResult",d.data)
			}
			else if (d.status=="err")
			{
				$.messager.popover({msg: "脚本验证："+d.message ,type:'alert'});
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "脚本验证："+d ,type:'alert'});
		}
	});	
}

        
$("btnClean").on("click",function(){
	
	setting.userid = "";
	setting.usercode = "";
	setting.ctlocid = "";
	setting.ssgroupid = "";
	setting.episodeId = "";
	setting.docid = "";
	setting.instanceid = "";
	setting.templateid = "";
	setting.categoryid = "";
	
	
	//loadComboGridData("cbgDbgUser","");
	loadComboGridData("cbgDbgLogon","");
	loadComboGridData("cbgDbgEpisodeID","");
	loadComboGridData("cbgDbgEMRDocument","");

	
	$.messager.popover({msg: "已重置测试参数", type:'alert'});	
})


var editIndex=undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};

function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#dgPrivRule').datagrid('validateRow', editIndex)){
			var ed = $('#dgPrivRule').datagrid('getEditor', {index:editIndex,field:'isactive'});
			
			$('#dgPrivRule').datagrid('endEdit', editIndex);
			modifyAfterRow = $('#dgPrivRule').datagrid('getRows')[editIndex];
			//标注修改前后发生变化
			if ( modifyAfterRow.isactive!=modifyBeforeRow.isactive)
			{
				$('#dgPrivRule').datagrid('getRows')[editIndex].haschanged = true;
				$('#dgPrivRule').datagrid('refreshRow',editIndex)
			}
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
function onClickRow(index){
	
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#dgPrivRule').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#dgPrivRule').datagrid('getRows')[editIndex]);
		} else {
			$('#dgPrivRule').datagrid('selectRow', editIndex);
		}
	}
}
var TempData = "";
var GridData = "";
$(function(){
	TemplateList();
	ListInstance();
	init();
});

//模板跨科检索
var searchAcrossDepartDocID = getSearchAcrossDepartDocID();

//表格视图显示
function init()
{
	var flag = checkCategoryIdInLocId(gl.episodeId,gl.userLocId,gl.categoryId,gl.groupId);
	if (flag == 1) getListTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",gl.categoryId,gl.episodeId,false,"List");
   	getListRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",gl.categoryId,gl.episodeId,false,"List",gl.sequence);
   	TempData = $("#listtemplate").treegrid("getData");
	GridData = $("#gridshow").datagrid("getData").rows;
}
//加载新建模板列表
function getListTemplate(className,methodName,parentID,episodeID,async,displaytype)
{
	jQuery.ajax({
		type: "Get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":parentID,
			"p2":episodeID,
			"p3":userID,
			"p4":displaytype,
			"p5":"",
			"p6":"",
			"p7":"",
			"p8":gl.docID,
		},
		success: function(d) {
			var data = eval("["+d+"]");
			$('#listtemplate').treegrid('loadData',data);
		},
		error : function(d) { 
			alert("getListTemplate error");
		}
	});
}
//加载模板表格视图列表
function TemplateList()
{
	$('#listtemplate').treegrid({
		iconCls:'icon-paper',
	    fitColumns:true, 
	    title:"新建模板列表",
	    headerCls:'panel-header-gray',
	    loadMsg:'数据装载中......',
	    autoRowHeight:true,
	    nowrap:true,
		url:"../EMRservice.Ajax.common.cls",
	    singleSelect:true,
	    fit:true,
	    idField:'id',
   		treeField:'text',
	    columns:[[
	    	{field:'id',title:'emrDocId',hidden:true},
	    	{field:'operate',title:'操作',width:56,formatter:operateContent},
			//2020-6-19 by yejian 名称显示修改docidtext
		    {field:'text',title:'名称',width:300,sortable:true,hidden:true},
	        {field:'DocIDText',title:'名称',width:300,sortable:true,formatter:show},
			{field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
			{field:'categoryId',hidden:true},{field:'templateId',hidden:true},
			{field:'isLeadframe',hidden:true},{field:'isMutex',hidden:true},
			{field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true}
		]],
		onBeforeCollapse:function(){
			$("#layout").layout("panel","north").panel("resize",{height:50});
			$("#layout").layout("resize");
		},
		onBeforeExpand:function(){
			$("#layout").layout("panel","north").panel("resize",{height:180});
			$("#layout").layout("resize");			
		},
		onDblClickRow:function(rowIndex, rowData){
			if (rowData.type == "flod")
			{
				if (rowData.state == "closed")
				{
					$('#listtemplate').treegrid('expand', rowData.id);
				}
				else
				{
					$('#listtemplate').treegrid('collapse', rowData.id);
				}
			}
			else if (rowData.type == "TempCate")
			{
				CreateClick(rowData.id);
			}			
		}
	});
}

//鼠标放在上面显示全名
function show(val,row){
	if (val){        
		return '<span title="' + val + '">' + val + '</span>';    
	} else {        
		return val;    
	}}

//搜索知情同意书新建模板列表
function searchListTemplate(className,methodName,searchValue,parentID,episodeID,async,displaytype)
{
	jQuery.ajax({
		type: "Get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":searchValue,
			"p2":parentID,
			"p3":episodeID,
			"p4":userID,
			"p5":displaytype
		},
		success: function(d) {
			var data = eval("["+d+"]");
			$('#listtemplate').treegrid('loadData',data);
		},
		error : function(d) { 
			alert("searchListTemplate error");
		}
	});
}
function operateContent(val,row,index)
{
	var span = ''
	if (row.type != 'TempCate') return;
	span = '<img title="新建" align="center" src="../scripts/emr/image/icon/add.png" style="margin-left:5px;" onclick="CreateClick('+"'"+row.id+"'"+')"/>'
	if(row.quotation == "1")
	{
		span += '<img title="引用" align="center" src="../scripts/emr/image/icon/quoate.png" style="margin-left:10px;"  onclick="QuoteClick('+"'"+row.id+"'"+')"/>'; 
		
	}
	return span;	
}

//从模板新建
function CreateClick(id)
{
	$('#listtemplate').treegrid('select',id);
	var row = $('#listtemplate').treegrid('getSelected');
	if (row)
	{
		var tabParam ={
			"id":"",
			"text":row.text,
			"pluginType":row.documentType,
			"chartItemType":row.chartItemType,
			"emrDocId":row.id,
			"templateId":row.templateId,
			"isLeadframe":row.isLeadframe,
			"isMutex":row.isMutex,
			"categoryId":row.categoryId,
			"actionType":"CREATE",
			"status":"NORMAL",
			"closable":true,
			"flag":"List"
		};
		
		tabParam = getParamByUserTemplate(tabParam);
		if (tabParam == "") return;
		/*operateRecord(tabParam);
	    //自动记录病例操作日志
	    CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");*/
	}
}

//从既往病历新建
function QuoteClick(id)
{
	$('#listtemplate').treegrid('selectRecord',id);
	var row = $('#listtemplate').treegrid('getSelected');
	if (row)
	{
		var docId = row.id;
		//showQuotationDialog("病历引用","<iframe id='iframeQuotation' scrolling='auto' frameborder='0' src='emr.ip.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+docId+"' style='width:100%; height:100%; display:block;overflow:hidden'></iframe>","quotationListCallBack()");
		var iframeContent = "<iframe id='iframeQuotation' scrolling='auto' frameborder='0' src='emr.ip.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+docId+"' style='width:100%; height:100%; display:block;overflow:hidden'></iframe>"
		parent.createModalDialog("quotationDialog","病历引用",window.screen.width-300,window.screen.height-300,"iframeQuotation",iframeContent,quotationListCallBack(),'',true,false)
	}
}


function quotationListCallBack(returnValue,arr)
{
	if ((!returnValue)||(returnValue == "")) return;
	var tabParam ={
		"id":"",
		"text":row.text,
		"pluginType":row.documentType,
		"chartItemType":row.chartItemType,
		"emrDocId":row.id,
		"templateId":row.templateId,
		"isLeadframe":row.isLeadframe,
		"isMutex":row.isMutex,
		"categoryId":row.categoryId,
		"actionType":"QUOTATION",
		"status":"NORMAL",
		"closable":true,
		"pInstanceId":ifrParam.returnValue,
		"flag":"List"
	};
	operateRecord(tabParam);
	
    //自动记录病例操作日志
    CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.CreateInOld");
}



//加载表格病历实例
function getListRecord(className,methodName,parentID,episodeID,async,displaytype,sequence)
{
	jQuery.ajax({
		type: "Get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":parentID,
			"p2":episodeID,
			"p3":displaytype,
			"p4":sequence,
			"p5":gl.docID
		},
		success: function(d)
		{
			var data = eval("["+d+"]");
			$('#gridshow').datagrid('loadData',data);
		},
		error: function(d){alert("getListRecord error");}
	});
}
//表格视图列表
function ListInstance()
{
	$('#gridshow').datagrid({
		iconCls:'icon-paper',
	    headerCls:'panel-header-gray',
	    loadMsg:'数据装载中......',
	    autoRowHeight:true,
	    singleSelect:true,
	    idField:'id',
	    sortOrder:'desc',
	    remoteSort:false,
	    nowrap:true,
	    striped:true,
	    fit:true,
	    columns:[[
	    	{field:'id',title:'id',hidden:true},
			{field:'status',title:'医生签名状态',width:160,formatter:StatusOperate,styler:formatColor,sortable:true},
	        {field:'text',title:'名称',width:150,sortable:true},
	        {field:'createdate',title:'创建日期',width:100,sortable:true},
			{field:'createtime',title:'创建时间',width:90,sortable:true},
			{field:'happendate',title:'发生日期',width:100,sortable:true,hidden:true},
			{field:'happentime',title:'发生时间',width:80,sortable:true,hidden:true},
			{field:'creator',title:'创建人',width:100},
			{field:'operator',title:'最后修改人',width:100},
			{field:'summary',title:'备注',width:442,formatter: function(value,row,index){return '<span style="display:block;width:100%;min-height:34px;line-height:34px;" onclick="updateMemo('+index+')" title='+value+'>'+value+'</span>'}},
			{field:'documentType',hidden:true},
			{field:'chartItemType',hidden:true},
			{field:'emrDocId',hidden:true},{field:'emrNum',hidden:true},
			{field:'templateId',hidden:true},{field:'isLeadframe',hidden:true},
			{field:'isMutex',hidden:true},{field:'categoryId',hidden:true},
			{field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true},
			{field:'patientsign',title:'患者待签',width:130,formatter: PatientStatusOperate,sortable:true}
			
		]],
		//点击表格病历打开
		onDblClickRow:function(index,row)
		{
			var tabParam ={
				"id":row.id,
				"text":row.text,
				"pluginType":row.documentType,
				"chartItemType":row.chartItemType,
				"characteristic":row.characteristic,
				"emrDocId":row.emrDocId,
				"templateId":row.templateId,
				"isLeadframe":row.isLeadframe,
				"isMutex":row.isMutex,
				"categoryId":row.categoryId,
				"actionType":"LOAD",
				"status":"NORMAL",
		    	"closable":true,
		    	"flag":"List"
			};
			parent.parent.changeCurrentTitle(tabParam.text,tabParam.categoryId);
			operateRecord(tabParam);
			
			//自动记录病例操作日志
			openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
		}
	});
}
//签名状态设置
function StatusOperate(val,row,index)
{
	if(row.doctorwait == "1")
	{
		var span = '<a>'+emrTrans("待签")+'</a>';  
		return span;
	}else{
		var span = '<a>'+row.status+'</a>';  
		return span;
	}
}
//设置病历状态颜色
function formatColor(val,row)
{
	if (row.doctorwait == "1")
	{
		return 'color:#FFFFFF;background-color:#FB9A42;';
	}	
}


function searchSelect(value)
{
	var categoryId = parent.parent.$("#sortName").attr("categoryId")
	if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
		 value = value.toUpperCase();
	}
	if ($.inArray(gl.categoryId,searchAcrossDepartDocID)>-1)
	{
		searchListTemplate("EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,gl.categoryId,gl.episodeId,false,"List");
	}else{
		var tmpTemplateData = findTemplate(TempData,value);
		$('#listtemplate').treegrid('loadData',tmpTemplateData);
	}
	
	var tmpRecordData = findRecord(GridData,value);
	$('#gridshow').datagrid('loadData',tmpRecordData);
	
}

///查询模板节点
function findTemplate(data,value)
{
	var result = new Array();
	for (var i = 0; i < data.length; i++) 
	{ 
		if (data[i].children)
		{
			var child = findTemplate(data[i].children,value)
			if ((child != "")&&(child.length >0))
			{
				var tmp = data[i];
				tmp.children = child;
				result.push(tmp);
			}
		}
		else
		{
			if (data[i].text.indexOf(value)!=-1) result.push(data[i]);
		}
	}
	return result;
}

///查询实例
function findRecord(data,value)
{
	var result = new Array();
	for (var i = 0; i < data.length; i++) 
	{
		if (data[i].text.indexOf(value)!=-1) result.push(data[i]);
	}
	return result;
}

function PatientStatusOperate(val,row,index)
{
	if(row.patientwait == "1")
	{
		var span = '<a>'+emrTrans("待签")+'</a>';  
		return span;
	}
}
///编辑备注///////////////////////////////////////////////////////////////////////////////////////////////////////////
var instanceId = "";
var recordIndex = "";
var oldTime = 0; 
var clickFunction = "";
$(function(){
	//编辑备注
	
	$('#memo').css("display","block");
	$('#memo').window('close');
	//保存备注信息
	$('#memoSure').click(function(){
		var memoText = $('#memoText').val();
		if (memoText.length > 1000)
		{
			alert("备注内容超出1000字数限制");
		}else{
			save(instanceId,memoText);
		}
	});

	//取消或关闭编辑备注
	$("#memoCancel").click(function(){
		$('#memo').window('close');
	});
});

//保存备注信息
function save(id,memoText){
	$.ajax({
		type: "post",
		url: "../EMRservice.Ajax.common.cls",
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLInstanceData",
			"Method":"SetDocumentMemo",
			"p1":id,
			"p2":stringTJson(memoText)
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			alert(textStatus);
		},
		success: function (data) {
			if (data == "1")
			{
				$('#memo').window('close');
				$('#gridshow').datagrid('updateRow',{
					index: recordIndex,
					row: {
						summary:memoText
					}
				});
				
			}
			else
			{
				alert("备注修改失败!");
			}
		}
	});
}

function updateMemo(index){
	var time = new Date();
	if(time-oldTime<500){
		clearTimeout(clickFunction);
		return
	}
	oldTime = time;
	 clickFunction = setTimeout(function(){
		recordIndex = index;
		var rows = $('#gridshow').datagrid('getRows');//获得所有行
    	var row = rows[index];
		instanceId =row.id;
		var value = row.summary;
		var memo = $(this).next().children().html();
		$('#memo').window('open');
		$('#memoText').text(value);
	},500)
};
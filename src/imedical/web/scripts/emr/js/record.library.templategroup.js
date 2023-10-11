var TempData = "";
var GridData = "";
$(function(){
	if (cardClassificationDisplay == "R"){
		$('#listdisplay').layout('remove','north');
		$('#listdisplay').layout('panel','west').panel('resize',{width:layoutWidth});
		$('#listdisplay').layout('resize');
	}else{
		$('#listdisplay').layout('remove','west');
	}
	//liuzhongwan 交换顺序,先定义gridshow控件然后再加载数据
	setListRecord();
	initCombobox();
});

function initCombobox()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetEMRTemplateGroup",
			"p1":userLocID
		},
		success: function(d) {
			if(d != "") setEMRTemplateGroup(eval("["+d+"]"));
		},
		error : function(d) { 
			alert("GetTemplateSet error");
		}
	});
}

function setEMRTemplateGroup(data)
{
	$('#templateRecord').combobox({
		valueField:'TemplateGroupCode',                        
		textField:'TemplateGroupName',
		width:200,
		height:22,
		panelHeight:'auto',
		data:data,
		onLoadSuccess:function()
		{
			if ($('#templateRecord').combobox('getValue') === "")
			{
				$('#templateRecord').combobox('select',data[0]["TemplateGroupCode"]);
			}
		},
		onSelect:function(record)
		{
			//显示视图样式
			var viewDisplayConfig = parent.parent.$('#ChangeShowMethod').combobox('getValue');
			loadTemplate(viewDisplayConfig,record.TemplateGroupCode);
		}
	});
}

function loadRecord(categoryId)
{
	//视图显示方式
	var viewDisplayConfig = parent.parent.$('#ChangeShowMethod').combobox('getValue');
	var groupCode = $('#templateRecord').combobox('getValue');
	loadTemplate(viewDisplayConfig,groupCode);
}

function loadTemplate(viewDisplayConfig,groupCode)
{
	var templateData = getTemplateData(groupCode);
	var recordData = getRecordData(groupCode);
	if(viewDisplayConfig == "ListShow")
	{
		//显示表格视图
		$(".display").hide();
		$('#listdisplay').show();
		temparam = [];
		if (templateData != "") setListTemplate(templateData);
		if (recordData != "")
		{
			//liuzhongwan option改为loadData
			$('#gridshow').datagrid('loadData',recordData);
		}
		else
		{
			//liuzhongwan option改为loadData，同时改变参数
			$('#gridshow').datagrid('loadData',eval({"total":0,"rows":[]}));
		}
		TempData = $('#listtemplate').datagrid('getData').rows;
		GridData = $('#gridshow').datagrid('getData').rows;
	}
	else
	{
		if(viewDisplayConfig == "MedPicShow")
		{
			$('#selectcss').attr("href","../scripts/emr/css/templaterecord-Med.css");
		}
		else if(viewDisplayConfig == "SmallPicShow")
		{
			$('#selectcss').attr("href","../scripts/emr/css/templaterecord-Small.css");
		}
		else
		{
			$('#selectcss').attr("href","../scripts/emr/css/templaterecord.css");
		}
		//显示卡片视图
		$('#listdisplay').hide();
		$(".display").show();
		$('.display').empty();
		temparam = [];
		if (templateData != "") setTemplate(templateData);
		if (recordData != "") setRecord(recordData);
	}
}
//获得模板
function getTemplateData(groupCode)
{
	var data = "";
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetTempCateJsonByGroupCode",
			"p1":episodeID,
			"p2":groupCode
		},
		success: function(d) {
			if(d != "") data = eval("["+d+"]");
		},
		error : function(d) { 
			alert("GetTempCateJsonByGroupCode error");
		}
	});
	return data;
}

//获得实例数据
function getRecordData(groupCode)
{
	var data = "";
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetInstanceJsonByGroupCode",
			"p1":episodeID,
			"p2":groupCode,
			"p3":"Save"
		},
		success: function(d) {
			if(d != ""){
				data = eval("["+d+"]");
			}
		},
		error : function(d) { 
			alert("GetInstanceJsonByGroupCode error");
		}
	});
	return data;
}
//加载列表模板数据
function setListTemplate(data)
{
	$('#listtemplate').datagrid({
	    fitColumns:true, 
	    loadMsg:'数据装载中......',
	    autoRowHeight:true,
	    data:data,
	    singleSelect:true,
	    idField:'id',
	    remoteSort:false,
	    nowrap:true,
	    striped:true,
	    fit:true,
	    overflow:'auto',
	    columns:[[
	    	{field:'id',title:'id',hidden:true},
	        {field:'text',title:'名称',width:200,sortable:true},
			{field:'quotation',hidden:true},
			{field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
			{field:'categoryId',hidden:true},{field:'templateId',hidden:true},
			{field:'isLeadframe',hidden:true},{field:'isMutex',hidden:true},
			{field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true},
			{field:'groupCode',hidden:true}
		]],
		onLoadSuccess:function(data){
			$.each(data.rows,function(idx,val){
				temparam[idx] ={
					"id":"",
					"text":val.text,
					"pluginType":val.documentType,
					"chartItemType":val.chartItemType,
					"emrDocId":val.id,
					"templateId":val.templateId,
					"isLeadframe":val.isLeadframe,
					"isMutex":val.isMutex,
					"categoryId":val.categoryId,
					"actionType":"CREATE",
					"status":"NORMAL",
					"closable":true,
					"flag":"List",
					"args":{
						"spreading":{"action":"GroupCreation","groupCode":val.groupCode}
					}					
			 	};
			});
		}
	});
}
//新建操作
function CreateOperate(val,row,index)
{
	var span = '<a id="createoperate" onclick="createDocument('+"'"+row+"'"+')">新建</a>';  
	return span;
}
//加载列表实例数据
function setListRecord()
{
	$('#gridshow').datagrid({
	    fitColumns:true, 
	    loadMsg:'数据装载中......',
	    autoRowHeight:true,
	    singleSelect:true,
	    idField:'id',
	    sortName:['text','happendate','happentime'],
	    sortOrder:'desc',
	    remoteSort:false,
	    nowrap:true,
	    striped:true,
	    fit:true,
	    overflow:'auto',
	    columns:[[
	    	{field:'id',title:'id',hidden:true},
			{field:'status',title:'签名状态',width:200,formatter: StatusOperate},
	        {field:'text',title:'名称',width:200,sortable:true},
			{field:'happendate',title:'发生日期',width:200,sortable:true},
			{field:'happentime',title:'发生时间',width:200,sortable:true},
			{field:'summary',title:'备注',width:642,resizable:true},
			{field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
			{field:'emrDocId',hidden:true},{field:'emrNum',hidden:true},
			{field:'templateId',hidden:true},{field:'isLeadframe',hidden:true},
			{field:'isMutex',hidden:true},{field:'categoryId',hidden:true},
			{field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true}
		]],
		//点击表格病历打开
		onClickRow:function(index,row)
		{
			var groupCode = $('#templateRecord').combobox('getValue'); 
			var tabParam ={
				"id":row.id,
				"text":row.text,
				"pluginType":row.documentType,
				"chartItemType":row.chartItemType,
				"emrDocId":row.emrDocId,
				"templateId":row.templateId,
				"isLeadframe":row.isLeadframe,
				"isMutex":row.isMutex,
				"categoryId":row.categoryId,
				"actionType":"LOAD",
				"status":"NORMAL",
		    	"closable":true,
		    	"flag":"List",
		    	"args":{
				"spreading":{"action":"GroupCreation","groupCode":groupCode}
			}

			};
			parent.parent.parent.openGroupRecord([tabParam]);
			//自动记录病例操作日志
			openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
		}
	});
}
//签名状态设置
function StatusOperate(val,row,index)
{
	if(row.hasSign == "0")
	{
		var span = '<a>待签</a>';  
		return span;
	}else{
		var span = '<a>'+row.status+'</a>';  
		return span;
	}
}

//加载卡片模板数据
function setTemplate(data)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});
		$(link).attr({"isMutex":data[i].isMutex,"categoryId":data[i].categoryId,"groupCode":data[i].groupCode});
		$(link).attr({"templateId":data[i].templateId});
		
		var div = $('<div class="template"></div>');
		$(div).append('<a href="#"><div class="title">' +data[i].text+ '</div></a>');
		$(div).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(div).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		$(link).append(div);
		
		$('.display').append(link);
		temparam[i] ={
			"id":"",
			"text":data[i].text,
			"pluginType":data[i].documentType,
			"chartItemType":data[i].chartItemType,
			"emrDocId":data[i].id,
			"templateId":data[i].templateId,
			"isLeadframe":data[i].isLeadframe,
			"isMutex":data[i].isMutex,
			"categoryId":data[i].categoryId,
			"actionType":"CREATE",
			"status":"NORMAL",
			"closable":true,
			"args":{
				"spreading":{"action":"GroupCreation","groupCode":data[i].groupCode}
			}
	 	};		
	}
}
//加载卡片实例数据
function setRecord(data)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onClick="openDocument(this)"></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});		
		$(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});
		$(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic,"groupCode":data[i].groupCode});
		
		var div = $('<div class="instance"></div>');
		if (data[i].hasSign == "0")
		{
			if($.browser.version == '11.0')
			{
				$(div).append('<div class="pic" style="width:26px">待签</div>');
			}else{
				$(div).append('<div class="pic">待签</div>');
			}
		}
		$(div).append('<a href="#"> <div class="content">' +data[i].summary+ '</div></a>');
		var tag = $('<div class="tag"></div>');
		$(tag).append('<div class="title">' +data[i].text+ '</div>');
		if(data[i].summary!="")
		{
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/emr/image/icon/happendtime.png"/>'+" "+'<span onmouseover="tip.show(this)" onmouseout="tip.hide()">'+"详细"+'<span class="description" style="display:none">'+data[i].summary+'</span>'+'</span>'+'</div>');
		}
		else
		{
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/emr/image/icon/happendtime.png"/></div>');
		}
		$(tag).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(tag).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		$('.display').append($(link).append($(div).append(tag)));
	}
}

///过滤页面卡片
function selectRecord(value)
{
	if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
		 value = value.toUpperCase();
	}
	if(parent.parent.$('#ChangeShowMethod').combobox('getValue') == "ListShow")
	{
		$('#listtemplate').hide();
		$('#gridshow').hide();
		var newTemp = [];
		for(var i=0;i<TempData.length;i++){
			if(value != ""){
				if((TempData[i].text.indexOf(value)!=-1)||(TempData[i].JaneSpell.indexOf(value)!=-1)||(TempData[i].FullFight.indexOf(value)!=-1))
				{
					newTemp.push(TempData[i]);
				}
			}else if(value == ""){
				newTemp.push(TempData[i]);
			}
		}
		$('#listtemplate').datagrid("loadData",newTemp).show();
		var newGrid = [];
		for(var i=0;i<GridData.length;i++){
			if(value != ""){
				if((GridData[i].text.indexOf(value)!=-1)||(GridData[i].JaneSpell.indexOf(value)!=-1)||(GridData[i].FullFight.indexOf(value)!=-1))
				{
					newGrid.push(GridData[i]);
				}
			}else if(value == ""){
				newGrid.push(GridData[i]);
			}
		}
		$('#gridshow').datagrid("loadData",newGrid).show();
	}else{
		$('#corddisplay .display li').hide();
		var $instance = $('#corddisplay .display li .instance .tag').filter(":contains('"+$.trim(value)+"')");
		$instance.parent().parent().show();
		var $template = $('#corddisplay .display li .template').filter(":contains('"+$.trim(value)+"')");
		$template.parent().show();
	}
}

///鼠标动作
var objA = null,intrval = null;
var tip =
{
	mousePos:function(e)
	{
		var x,y;
		var e = e||window.event;
		return{x:e.clientX+document.body.scrollLeft+document.documentElement.scrollLeft,y:e.clientY+document.body.scrollTop+document.documentElement.scrollTop};
	},
	show:function(obj)
	{
		if(!obj)obj = objA;
   		else objA = obj;
   		if(intrval)
   		{
	   		window.clearTimeout(intrval);
    		intrval = null;
   		} 
   		var self = this; 
   		var t = document.getElementById("messagetip"); 
   		obj.onmousemove = function(e)
   		{ 
   			var mouse = self.mousePos(e);
   			t.style.left = mouse.x - 150 + 'px';
   			t.style.top = mouse.y - 220 + 'px';
   			var str = obj.innerText;
   			str = str.substr(2);
   			t.innerHTML = str;
  	 		t.style.overflow = "auto";
   			t.style.backgroundColor = '#EFF8FE';
   			t.style.display = "block";
  		}
  	},
	hide:function()
	{	
		intrval = window.setTimeout(function(){document.getElementById("messagetip").style.display="none";},80);
   	}
}

//从模板组新建
function createTemplateGroup()
{
	if (temparam.length == 0) alert("请配置模板组数据");
	//创建病历
	parent.parent.parent.openGroupRecord(temparam);
	CreateGroupDocumentLog(temparam,"EMR.Nav.RecordNav.CreateGroup");

}

//从模板新建
function createDocument(obj)
{
	var obj = $(obj).closest("li");
    var tabParam = {
	    "id":"",
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("id"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"actionType":"CREATE",
		"status":"NORMAL",
		"closable":true
	};
	var viewDisplayConfig = parent.parent.$("#ChangeShowMethod").combobox('getValue');
	if(viewDisplayConfig == "ListShow") tabParam["flag"] = "List"; 
	///创建病历 	
	parent.parent.parent.operateRecord([tabParam]);	
	
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
}

//打开文档
function openDocument(obj)
{
	var groupCode = $('#templateRecord').combobox('getValue'); 
	var obj = $(obj).closest("li");
    var tabParam ={
		"id":obj.attr("id"),
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("emrDocId"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"characteristic":obj.attr("characteristic"),
		"actionType":"LOAD",
		"status":"NORMAL",
		"args":{
			"spreading":{"action":"GroupCreation","groupCode":groupCode}
		}
	}; 	
	parent.parent.parent.openGroupRecord([tabParam]);
	
	//自动记录病例操作日志
	openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
}

//刷新
function refresh()
{
    window.location.reload();
}

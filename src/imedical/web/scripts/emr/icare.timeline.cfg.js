// icare.timeline.cfg.js
var restArr = {
	timeLineReq:{ClassName: "icare.TimeLineConfig",QueryName: "GetTimeLineList"},/*查询视图*/
	getTimeLineItemReq:{ClassName:"icare.TimeLineConfig",QueryName:"GetTimeLineItems"},/*查询视图中大项*/
	updTimeLineReq:{ClassName:"icare.TimeLineConfig",MethodName:"UpdateTimeLine"}, /*更新视图*/
	insTimeLineReq:{ClassName:"icare.TimeLineConfig",MethodName:"AddTimeLine"}, /*更新视图*/
	delTimeLineReq:{ClassName: "icare.TimeLineConfig",MethodName: "DeleteTimeLine"}, /*删除视图*/
	getDiagTypeReq:{QueryName:"GetDiagnoseType",ClassName: "icare.DiagnoseSetting"}/*获得诊断类型*/
};

var selectedTimeLineInd = 0;
var timeLineArr = [{Code:"AdmView",Description:"住院集成视图"}];
var genWinHtml = function(itemsCfg){
	var html = '<div class="winform">';
	var items = itemsCfg.items;
	for(var i=0; i<items.length; i++){
		html += '<div>'
		if (items[i].label){
			html+='<label class="r-label">'+items[i].label+'</label>';
		}
		if (items[i].id){
			if (items[i].type=='textarea'){
				html+='<textarea id="'+items[i].id+'" type="textarea" class="textbox" rows="3">'+items[i].value+'</textarea>'
			}else if (items[i].type=='hidden'){
				html+='<input id="'+items[i].id+'" type="hidden" value="'+items[i].value+'"/>'
			}else if (items[i].type=='lookup'){
				html+='<input id="'+items[i].id+'" value="'+items[i].value+'" class="textbox hisui-lookup" />'
			} else{
				html+='<input id="'+items[i].id+'" value="'+items[i].value+'" class="textbox"/>'
			}
		}
		html+='</div>';
	}	
	html +='</div>';
	html += '<div style="bottom: 10px;position: absolute;left: 40%;">'+
		'<a class="hisui-linkbutton" onclick="'+itemsCfg.hander+'();">确定</a>'+
		'</div>'
	return html;
}
var saveTimeLineView = function(){
	var i = $('#tlid').val();
	var c = $('#tlcode').val();
	var d = $('#tldesc').val();
	var n = $('#tlnote').val();
	if (i==""&&c==""){
		$.messager.alert("提示","请填写代码","info");
		return;
	}
	var param = {};
	if (i==""){
		$.extend(param, restArr.insTimeLineReq, {code:c,desc:d,note:n});
	}else{
		$.extend(param, restArr.updTimeLineReq, {oldcode:i,newcode:c,desc:d,note:n});
	}
	$m(param,function(rtn){
		if (rtn==1){
			// websys_showModal('close'); 
			$("#tmpwin").window('close');
			if (i==""){
				selectedTimeLineInd = $('.tl-panel').length;
			}
			renderTimeLineView();
			$.messager.popover({msg:'保存成功',type:'success'});
		}else{
			$.messager.popover({msg:'保存失败',type:'error'});
		}
	});
}
var delTimeLineView = function(code){
	$m($.extend(restArr.delTimeLineReq,{code:code}),function(rtn){
		if (rtn==1){
			if (selectedTimeLineInd>0) selectedTimeLineInd = selectedTimeLineInd-1;
			renderTimeLineView();
			$.messager.popover({msg:'删除成功',type:'success'});
		}else{
			$.messager.popover({msg:'删除失败',type:'error'});
		}
	});
}
var showTimeLineWin = function(tlItemObj){
	var itemsCfg = {
		items:[{id:'tlcode',label:'代码',value:tlItemObj.Code},{id:'tldesc',label:'描述',value:tlItemObj.Description},
		{id:'tlnote',label:'说明',type:'textarea',value:tlItemObj.Notes},{id:'tlid',type:'hidden',value:tlItemObj.ID}],
		hander:'saveTimeLineView'
	};
	var winJObj = $('#tmpwin');
	if (winJObj.length==0){
		$('<div id="tmpwin"></div>').appendTo('body');
	}
	var title = "新增视图";
	if (tlItemObj.Code!=""){
		title = "修改视图";
	}
	winJObj.window({
		iconCls:'icon-w-edit',
		title:title,
		content:genWinHtml(itemsCfg),
		modal:true,width:260,height:260,
		resizable:false,collapsible:false,minimizable:false,maximizable:false
	});
};

/**
* render 左边视图列表
*/
var renderTimeLineView = function(){
	$cm(restArr.timeLineReq,function(rtn){
		timeLineArr = rtn.rows;
		$("#timelinewest").html("");
		if (rtn.rows.length>0){
			for (var i=0;i<rtn.rows.length;i++){
				var item = rtn.rows[i];
				var selected = "";
				if (i==selectedTimeLineInd){selected=" selected";}
				$('<div class="tl-panel'+selected+'" data-ind="'+i+'"><div id="panel11"></div></div>').appendTo("#timelinewest")
				.click(function(){
					var _t = $(this);
					if (!_t.hasClass('selected')){
						$(".tl-panel").removeClass('selected');
						_t.addClass('selected');
						selectedTimeLineInd = _t.data("ind");
						$("#itemsGrid").datagrid("load");
						//_t.find('.panel .panel-header').addClass("panel-header-blue");
					}else{
						//_t.find('.panel .panel-header').addClass("panel-header-gray");
					}
				}).children("div").panel({  
					width:230,  
					height:100,
					title: item.Description,
					tlItem :item,
					headerCls:'panel-header-gray',
					content:"<div style=\"margin:10px;\">"+item.Notes+"</div>",
					tools: [{  
						iconCls:'icon-write-order',  
						handler:function(){
							$(this).closest('.tl-panel').trigger('click');
							var tlItemObj = $(this).closest('.panel').children('.panel-body').panel("options").tlItem;
							tlItemObj.ID = tlItemObj.Code;
							showTimeLineWin(tlItemObj);
						}
					},{  
						iconCls:'icon-cancel',  
						handler:function(){
							$(this).closest('.tl-panel').trigger('click');
							var tlItemObj = $(this).closest('.panel').children('.panel-body').panel("options").tlItem;
							$.messager.confirm("删除", "确定删除【"+tlItemObj.Description+"】视图配置?", function (r) {
								if (r) {
									delTimeLineView(tlItemObj.Code);
								}
							});
						}  
					}]  
				});   
			}
			//$('<div class="timeLineAddBtn"><a class="icon icon-add iconadd" href="#" onclick=\'showTimeLineWin({ID:"",Code:"",Description:"",Notes:""});\'>新增</a></div>').appendTo("#timelinewest");
			$("#itemsGrid").datagrid("load");
		}
	});
}
$(function(){	
	renderTimeLineView();
});
var viewTypeData = [{val:'T',txt:'表格'}, {val:'A',txt:'链接'}, {val:'I',txt:'图标'}, {val:'L',txt:'文本'}, {val:'C',txt:'趋势图'},{val:'N',txt:'线'}];

var createtab2 = function(){
	/*显示项维护*/
	$('#cateGrid').mgrid({
		className:'icare.dto.CateDto',
		key:'cate',pagination:false,editGrid:true,
		title:'显示项列表',addBtnText:"&nbsp;",editBtnText:"&nbsp;",saveBtnText:"&nbsp;",delBtnText:"&nbsp;",cancelBtnText:"&nbsp;",
		columns:[[
			{field:'Code',title:'项目代码',editor:{type:'text'}},
			{field:'Description',title:'项目描述',width:100,editor:{type:'text'}}
		]],
		onLoadSuccess:function(data){
			if (data && data.rows && data.rows.length>0){
				$(this).datagrid("selectRow",0);
				var c = $("#itemsGrid").datagrid('getColumnOption', 'Code');    
				c.editor = {
					type:'combogrid',
						options:{
							blurValidValue:true,
							panelWidth: 300,
							idField:'Code',
							textField:'Code',
							columns:[[
								{field:'Description',title:'描述'},
								{field:'Code',title:'代码'}
							]],
							data:data.rows
						}
					};
			}
		},
		onSelect:function(rowIndex,rowData){
			$("#typeGrid").datagrid('load');
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"子项代码不能为空！",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.cate.Code":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.cate.id":row.Code});
			}
			$.extend(param,{"dto.cate.Description":row.Description});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {ID:"",Code:"",Description:""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "该操作会级联删除,确定删除【"+row.Description+"】显示项?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.cate.Code":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	/*子项维护*/
	$('#typeGrid').mgrid({
		className:'icare.dto.DataTypeDto',
		key:'type',editGrid:true,
		title:'子项列表',pagination:false,
		columns:[[
			{field:'Code',title:'项目代码',editor:{type:'text'}},
			{field:'Description',title:'项目描述',width:100,editor:{type:'text'}},
			{field:'ShowType',title:'显示联系',formatter:function(v){if (v=="N"){ return "仅显示状态"}return "显示数据"; },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}
		]],
		onBeforeLoad:function(param){
			if ($('#cateGrid').datagrid('getSelected')){
				param.categroyCode = $('#cateGrid').datagrid('getSelected').Code;
			}else{
				param.categroyCode = "";
				return false;
			}
		},
		onLoadSuccess:function(data){
			if (data && data.rows && data.rows.length>0){
				$(this).datagrid("selectRow",0);
			}
		},
		onSelect:function(rowIndex,rowData){
			$("#actGrid").datagrid('load');
			$("#typeBtnGrid").datagrid('load');
			$("#typeChartGrid").datagrid('load');
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"子项代码不能为空！",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.type.Code":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.type.id":row.Code});
			}
			var cateCode = $('#cateGrid').datagrid('getSelected').Code;
			$.extend(param,{"dto.cateCode":cateCode,"dto.type.Description":row.Description,"dto.type.ShowType":row.ShowType});
			//$('#actGrid').datagrid('acceptChanges'); //前端提交getChanges方法
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {ID:"",Code:"",Description:"",ShowType:""};
		},
		delHandler:function(row){
			var _t = this;
			var cateCode = $('#cateGrid').datagrid('getSelected').Code;
			$.messager.confirm("删除", "该操作会级联删除行为项,确定删除【"+row.Description+"】子项?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.cateCode":cateCode,"dto.type.Code":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	/*子项--按钮维护*/
	$('#typeBtnGrid').mgrid({
		className:'websys.dto.TypeMenuTool',
		key:'typeBtn',editGrid:true,addBtnText:"&nbsp;",editBtnText:"&nbsp;",saveBtnText:"&nbsp;",delBtnText:"&nbsp;",cancelBtnText:"&nbsp;",
		title:'子项-按钮列表',pagination:false,updReq:{hidden:true},
		columns:[[
			{field:'Code',title:'菜单代码',width:150,
				editor:{
					type:'lookup',
					options:{
						url:$URL+"?ClassName=websys.Menu&QueryName=FindMenu",
						mode:'remote',
						panelWidth:500,
						panelHeight:300,
						idField:'HIDDEN',
						textField:'Code',
						isCombo:true,
						onBeforeLoad : function(param){
							param.desc = param.q;
						},
						pagination:true,
						columns:[[  
							{field:'Code',title:'菜单名',width:200},  
							{field:'Description',title:'菜单描述',width:200} 
						]]
					}
				}
			},
			{field:'Description',title:'菜单描述',width:150}
		]],
		onBeforeLoad:function(param){
				if ($('#typeGrid').datagrid('getSelected')){
					param.Tool = "ClinicalDataTypeBtn";
					param.Type = $('#typeGrid').datagrid('getSelected').Code;
				}else{
					param.Type = "";
					param.Tool = "ClinicalDataTypeBtn";
					return false;
				}
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"代码不能为空！",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.tool.MenuCode":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.tool.id":row.ID});
			}
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			$.extend(param,{
				"dto.tool.MenuCode":row.Code,
				"dto.tool.TypeCode":dataTypeRow.Code,
				"dto.tool.ToolType":"ClinicalDataTypeBtn"
			});
			//$('#actGrid').datagrid('acceptChanges'); //前端提交getChanges方法
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			if (dataTypeRow){
				return {ToolType:"ClinicalDataTypeBtn",TypeCode:dataTypeRow.Code,MenuCode:"",ID:""};
			}else{
				$.messager.popover({msg:"选中子项后再新增加！",type:'info'});
				return false;
			}
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "确定删除【"+row.Description+"】子项-按钮?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.tool.id":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	/*子项--图表维护*/
	$('#typeChartGrid').mgrid({
		className:'websys.dto.TypeMenuTool',
		key:'typeChart',editGrid:true,addBtnText:"&nbsp;",editBtnText:"&nbsp;",saveBtnText:"&nbsp;",delBtnText:"&nbsp;",cancelBtnText:"&nbsp;",
		title:'子项-图表列表',pagination:false,updReq:{hidden:true},
		columns:[[
			{field:'Code',title:'菜单代码',width:150,
				editor:{
					type:'lookup',
					options:{
						url:$URL+"?ClassName=websys.Menu&QueryName=FindMenu",
						mode:'remote',
						panelWidth:500,
						panelHeight:300,
						idField:'HIDDEN',
						textField:'Code',
						isCombo:true,
						onBeforeLoad : function(param){
							param.desc = param.q;
						},
						pagination:true,
						columns:[[  
							{field:'Code',title:'菜单名',width:200},  
							{field:'Description',title:'菜单描述',width:200} 
						]]
					}
				}
			},
			{field:'Description',title:'菜单描述',width:150}
		]],
		onBeforeLoad:function(param){
				if ($('#typeGrid').datagrid('getSelected')){
					param.Tool = "ClinicalDataTypeChartBook";
					param.Type = $('#typeGrid').datagrid('getSelected').Code;
				}else{
					param.Type = "";
					param.Tool = "ClinicalDataTypeChartBook";
					return false;
				}
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"代码不能为空！",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.tool.MenuCode":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.tool.id":row.ID});
			}
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			$.extend(param,{
				"dto.tool.MenuCode":row.Code,
				"dto.tool.TypeCode":dataTypeRow.Code,
				"dto.tool.ToolType":"ClinicalDataTypeChartBook"
			});
			//$('#actGrid').datagrid('acceptChanges'); //前端提交getChanges方法
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			if (dataTypeRow){
				return {ToolType:"ClinicalDataTypeChartBook",TypeCode:dataTypeRow.Code,MenuCode:"",ID:""};
			}else{
				$.messager.popover({msg:"选中子项后再新增加！",type:'info'});
				return false;
			}
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "确定删除【"+row.Description+"】子项-按钮?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.tool.id":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	/*行为项维护*/
	$('#actGrid').mgrid({
		className:'icare.dto.DataActDto',
		key:'act',editGrid:true,
		title:'行为列表',
		columns:[[
			{field:'Code',title:'项目代码',editor:{type:'text'}},
			{field:'Description',title:'项目描述',width:100,editor:{type:'text'}},
			{field:'HisCode',title:'HIS码',width:100,editor:{type:'text'}},
			{field:'ActSort',title:'顺序',width:50,editor:{type:'text'}},
			{field:'GroupName',title:'分组名',width:60,editor:{type:'text'}},
			{field:'Mth',title:'方法名',width:100,editor:{type:'text'}},
			{field:'ParentCode',title:"父行为",width:120,editor:{type:'text'}},
			{field:'Active',title:"激活状态",width:100,formatter:function(v){if (v=="N"){ return "禁用"}return "启用"; },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}
		]],
		rowStyler: function(index,row){
			if (row.ActSort<0){
				return 'color:#FF9797;'; //background-color:#6293BB;
			}
		},
		onBeforeLoad:function(param){
				if ($('#typeGrid').datagrid('getSelected')){
					param.dataTypeCode = $('#typeGrid').datagrid('getSelected').Code;
				}else{
					param.dataTypeCode = "";
					return false;
				}
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"动作代码不能为空！",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.act.Code":row.Code});
			}else{
				param = $.extend(this.updReq,{"dto.act.id":row.Code});
			}
			$.extend(param,{
				"dto.act.Description":row.Description,
				"dto.act.ActSort":row.ActSort,
				"dto.act.HisCode":row.HisCode,
				"dto.act.Active":row.Active,
				"dto.act.Mth":row.Mth,
				"dto.act.GroupName":row.GroupName,
				"dto.act.ParentCode":row.ParentCode,
				"dto.act.DataTypeCode":row.DataType
			});
			//$('#actGrid').datagrid('acceptChanges'); //前端提交getChanges方法
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			var dataTypeRow = $('#typeGrid').datagrid("getSelected");
			return {DataType:dataTypeRow.Code,ID:"",Code:"",Description:"",HisCode:"",ActSort:"",Active:"Y",Mth:"",GroupName:"",ParentCode:""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "确定删除【"+row.Description+"】行为项?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.act.Code":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
}
var createtab3 = function(){
		$('#linkcfgGrid').mgrid({
			className:'icare.dto.ViewTypeConfig',
			editGrid:true,
			key:'linkcfg',border:false,
			title:'',
			columns:[[
				{field:'ID',hidden:true},
				{field:'Description',title:'描述',width:100,editor:{type:'text'}},
				{field:'Parameters',title:'链接',width:100,editor:{type:'text'}}
			]],
			onLoadSuccess:function(data){
				var c = $("#itemsGrid").datagrid('getColumnOption', 'ViewConfigId');    
				c.editor = {
					type:'combogrid',
						options:{
							panelWidth: 350,
							idField:'ID',
							textField:'Parameters',
							columns:[[
								{field:'Description',title:'描述'},
								{field:'Parameters',title:'路径'}
							]],
							data:data.rows
						}
					};
				c.formatter = function(v){
					for (var i=0; i<data.rows.length;i++){
						if (data.rows[i].ID==v) return data.rows[i].Parameters;
					}
				}
			},
			insOrUpdHandler:function(row){
				var param ;
				if (row.ID==""){
					if (!row.Description){
						$.messager.popover({msg:'描述不能为空！',type:'info'});
						return ;
					}
					param = this.insReq;
				}else{
					param = $.extend(this.updReq,{
						"dto.linkcfg.id":row.ID
					});
				}
				$.extend(param,{
					"dto.linkcfg.Description":row.Description,
					"dto.linkcfg.Parameters":row.Parameters
				});
				$cm(param,defaultCallBack);
			},
			getNewRecord:function(){
				return {ID:"",Description:"",Parameters:""};
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("删除", "该操作不同恢复,确定删除【"+row.Description+"】配置?", function (r) {
					if (r) {
						$.extend(_t.delReq,{"dto.linkcfg.id":row.ID});
						$cm(_t.delReq,defaultCallBack);
					}
				});
			}
		});
}
function tabSelect(title){
	if (title=='链接项管理'){
		createtab3();
	}
	if (title=='显示项管理'){
		createtab2();
	}
}
$(function(){
	//createtab2();
	/*视图管理界面用到了链接数据*/
	createtab3(); 
	/*时间线对应的显示项维护*/
	createDatagridEdit({
		className:'icare.dto.TimeLineItems',
		key:'items',
		title:'显示项目',
		columns:[[
			{field:'ID',hidden:true},
			{field:'Code',title:'项目代码',width:100}, /*为了编辑时禁用--对应后台的CategoryCode*/
			{field:'CategoryDesc',title:'项目描述',width:100},
			{field:'ViewType',title:'展示类型',width:200,
				editor:{
					blurValidValue:true,
					type:'combobox',
					options:{
						valueField:'val',
						textField:'txt',
						data:viewTypeData
					}
				},formatter:function(v){
					for (var i=0; i<viewTypeData.length;i++){
						if (viewTypeData[i].val==v) return viewTypeData[i].txt;
					}
				}
			},
			{field:'ViewConfigId',title:'链接',width:200
			},
			{field:'Sequence',title:'显示顺序',width:200,editor:{type:"text"}}
		]],
		onBeforeLoad:function(param){
			if ($('div.tl-panel[data-ind='+selectedTimeLineInd+']').hasClass('selected')){
				param.timeLineId = timeLineArr[selectedTimeLineInd].Code;
			}else{
				return false;
			}
		},
		onLoadSuccess:function(data){
			$(this).datagrid("getPanel").panel("setTitle",timeLineArr[selectedTimeLineInd].Description+"的显示项目");
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.ID==""){
				if (!row.Code){
					$.messager.popover({msg:"显示项代码不能为空！",type:'info'});
					return false;
				}
				param = $.extend(this.insReq,{
					"dto.items.TimeLine":timeLineArr[selectedTimeLineInd].Code,
					"dto.items.CategoryCode":row.Code
				});
			}else{
				param = $.extend(this.updReq,{
					"dto.items.id":row.ID
				});
			}
			if (""==row.ViewType || undefined==row.ViewType){
				$.messager.popover({msg:"展示类型不能为空！",type:'info'});
				return false;
			}

			$.extend(param,{
				"dto.items.Sequence":row.Sequence,
				"dto.items.ViewType":row.ViewType,
				"dto.items.ViewConfig":row.ViewConfigId||"",
				"dto.items.DisplayExpression":row.DisplayExpression
			});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {ID:"",CategoryCode:"",CategoryDesc:"",ViewTypeDesc:"",ViewConfigParam:"",Sequence:""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "该操作会级联删除,确定删除【"+row.CategoryDesc+"】显示项?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.items.id":row.ID}); //timeLineArr[selectedTimeLineInd].Code+"||"
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	
	//视图管理的显示项目的代码列编辑器
	$.q({ClassName:'icare.dto.CateDto',QueryName:'Find'},function(data){ 
		if (data && data.rows && data.rows.length>0){
			var c = $("#itemsGrid").datagrid('getColumnOption', 'Code');    
			c.editor = {
				type:'combogrid',
					options:{
						blurValidValue:true,
						panelWidth: 300,
						idField:'Code',
						textField:'Code',
						columns:[[
							{field:'Description',title:'描述'},
							{field:'Code',title:'代码'}
						]],
						data:data.rows
					}
				};
		}	
	})
	
	
	
});
/*
	editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'Y',offText:'N',onSwitchChange:function(){
						var _t = $(this);
						var flag = _t.switchbox('getValue');
						var rowIndex = _t.closest('.datagrid-row.datagrid-row-over').attr('datagrid-row-index');
						var row = $('#actGrid').datagrid("getRows")[rowIndex];
						var active = "N";
						if (flag) active = "Y";
						$cm($.extend(restArr.saveActReq,{"dto.act.id":row.Code,"dto.act.Active":active}),function(rtn){
							if (rtn.success==1){
								$.messager.popover({msg:rtn.msg,type:'success'});
							}else{
								$.messager.popover({msg:rtn.msg,type:'error'});
							}
						});
					}}}*/
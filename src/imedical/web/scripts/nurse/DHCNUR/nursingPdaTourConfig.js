/*
 * @author: LMS
 * @discription: 移动护理配置
 * @date: 2021-04-05
 */
GV._CLASSNAME = 'Nur.HISUI.MNISConfig';
$(function () {
	
	/**
    * @description: 初始化界面
    */
	function initUI() {
		initPageDom();
	
	}
function initPageDom() {
	/// 院区
	$('#hospBox').combobox({
	    url: $URL + '?1=1&ClassName=' + GV._CLASSNAME + '&QueryName=FindHosps' + '&ResultSetType=array',
	    valueField: 'hospID',
	    textField: 'hospDesc',
	    defaultFilter:4,
		onLoadSuccess: function() {
			$('#hospBox').combobox('setValue',session['LOGON.HOSPID']);
			initTourType();
			initTemplateTour();
		},
		onSelect: function() {
			//setTimeout('locGridOnFindClick();', 100);
			
			initTourType();
			initTemplateTour();
		}
	});
	}
	/**
    * @description: 初始化所有模板表格
    */ 
    function initTourType() {
		$HUI.datagrid('#tourType',{
			url: $URL,
			queryParams: {
				ClassName: "CF.NUR.MNIS.TourModel",
				QueryName: "getModelJson",
				hospId:$('#hospBox').combobox('getValue')
			},
			columns:[[
				{field:'modelName',title:'页签名称',width:80},
				{field:'modelSort',title:'页签顺序',width:80},
				{field:'canFlag',title:'是否启用',width:80},
				{field:'modelId',title:'页签Id',width:80}
			]],
			pagination: true,
			pageSize: 15,
			pageList: [15, 30, 50],
			rownumbers:true,
			singleSelect:true,
			width:320,
			toolbar: [{
				id: 'btnSave',
				iconCls: 'icon-save',
				text:'增加',
				handler: saveModel
			},{
				id: 'btnUpdate',
				iconCls: 'icon-edit',
				text:'修改',
				handler: modifyModel
			},{
				id: 'btnUpdate',
				iconCls: 'icon-remove',
				text:'删除',
				handler: deleteModel
			}],
			onClickRow: getModelData
		});	
	}
	 function initTemplateTour(id) {
		$HUI.datagrid('#templateTour',{
			url: $URL,
			queryParams: {
				ClassName: "CF.NUR.MNIS.TourModelItemSet",
				QueryName: "getTourJson",
				id:id
			},
			columns:[[
				{field:'operationType',title:'操作类型',width:80},
				{field:'operationName',title:'操作名称',width:80},
				{field:'operationCode',title:'操作Code',width:80},
				{field:'operationContent',title:'下拉框内容',width:80},
				{field:'operationCanOrNo',title:'是否可编辑',width:80},
				{field:'operationSort',title:'显示顺序',width:80},
				{field:'operationDefault',title:'默认值',width:80},
				{field:'operModelId',title:'元素Id',width:80}
			]],
			pagination: true,
			pageSize: 15,
			pageList: [15, 30, 50],
			rownumbers:true,
			singleSelect:true,
			width:320,
			toolbar: [{
				id: 'btnSave',
				iconCls: 'icon-save',
				text:'增加',
				handler: saveTourModel
			},{
				id: 'btnUpdate',
				iconCls: 'icon-edit',
				text:'修改',
				handler: modifyTourModel
			},{
				id: 'btnDelete',
				iconCls: 'icon-remove',
				text:'删除',
				handler: deleteTourModel
			}]
			//onClickRow: getModelData
		});	
	}
	//增加页签
	function saveModel() {
		var row = $('#tourType').datagrid('getSelections')[0];  //去掉该行，下面的不可编辑就有问题
		$HUI.dialog('#MoDialog',{
			title: '页签增加',
			width:400,
			height:340,
			iconCls:'icon-save',
			resizable:false,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					save();
				}
				},{
					text:'取消',
					handler:function(){
						$HUI.dialog('#MoDialog').close();
					}
				}
			]
		});
		//给模态框里的元素赋选中行的值，
		$.each(row,function(key,value){  
			var domID = key.replace(key[0],key[0].toLowerCase());
			if ($('#' + domID).length) {
				var domType = $('#' + domID).attr('class');
		        if (!!domType) {
		        	if (domType.indexOf('combobox') > -1) {
			        	$('#' + domID).combobox('setText', value);
			        } else if (domType.indexOf('textbox') > -1){
			        	$('#' + domID).val(value);
			        } else {}
				}
			}
		});
		$('#ModelId').attr('disabled',true);
	}
	function modifyModel(){
		
		var row = $('#tourType').datagrid('getSelections')[0];  //去掉该行，下面的不可编辑就有问题
		$HUI.dialog('#MoDialog',{
			title: '页签修改',
			width:400,
			height:340,
			iconCls:'icon-save',
			resizable:false,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					modify(row.modelId);
				}
				},{
					text:'取消',
					handler:function(){
						$HUI.dialog('#MoDialog').close();
					}
				}
			]
		});
		//toUpperCase   toLowerCase
		//给模态框里的元素赋选中行的值，列的字段和模态框的字段要一样
		$.each(row,function(key,value){  
			var domID = key.replace(key[0],key[0].toUpperCase());
			if ($('#' + domID).length) {
				var domType = $('#' + domID).attr('class');
		        if (!!domType) {
		        	if (domType.indexOf('combobox') > -1) {
			        	$('#' + domID).combobox('setText', value);
			        } else if (domType.indexOf('textbox') > -1){
			        	$('#' + domID).val(value);
			        } else {}
				}
			}
		});
		$('#ModelId').attr('disabled',true);
		
		}
	
	function modify(id) {
		$cm({
			ClassName: "CF.NUR.MNIS.TourModel",
			MethodName: "Save",
			ModelName:$('#ModelName').val(),
			ModelSort:$('#ModelSort').val(),
			CanFlag:$('#CanFlag').val(),
			ModelId:id
		}, function(ret) {
			if (ret == '0') {
			$HUI.dialog('#MoDialog').close();	
			alert("修改成功")
			initTourType();
			}
		});
		}	
	function save() {
		$cm({
			ClassName: "CF.NUR.MNIS.TourModel",
			MethodName: "Save",
			ModelName:$('#ModelName').val(),
			ModelSort:$('#ModelSort').val(),
			CanFlag:$('#CanFlag').val(),
			ModelId:$('#ModelId').val(),
			HospId:$('#hospBox').combobox('getValue')
		}, function(ret) {
			if (ret == '0') {
			$HUI.dialog('#MoDialog').close();	
			alert("添加成功")
			initTourType();
			}
		});
		}
		function deleteModel() {
			var row = $('#tourType').datagrid('getSelections')[0];
			$cm({
			ClassName: "CF.NUR.MNIS.TourModel",
			MethodName: "Delete",
			modelId:row.modelId
		}, function(ret) {
			if (ret == '0') {
			alert("删除成功")
			initTourType();
			}
		});
		}
	
	function getModelData(){
		var row=$('#tourType').datagrid('getSelections')[0];   //取到点击行的ID
		initTemplateTour(row.modelId);      
		}
	function saveTourModel(){
		var row = $('#templateTour').datagrid('getSelections')[0];  //去掉该行，选中的行下面的不可编辑就有问题
		//alert(row.modelId)  主表的ID   必选的
		$HUI.dialog('#TourMoDialog',{
			title: '模板元素增加',
			width:400,
			height:340,
			iconCls:'icon-save',
			resizable:false,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					saveModelConfig();
				}
				},{
					text:'取消',
					handler:function(){
						$HUI.dialog('#TourMoDialog').close();
					}
				}
			]
		});
		//给模态框里的元素赋选中行的值，列的字段的key必须小写，不晓得为啥
		$.each(row,function(key,value){  
			var domID = key.replace(key[0],key[0].toLowerCase());
			if ($('#' + domID).length) {
				var domType = $('#' + domID).attr('class');
		        if (!!domType) {
		        	if (domType.indexOf('combobox') > -1) {
			        	$('#' + domID).combobox('setText', value);
			        } else if (domType.indexOf('textbox') > -1){
			        	$('#' + domID).val(value);
			        } else {}
				}
			}
		});
		$('#OperModelId').attr('disabled',true);
		}
	function modifyTourModel(){
		var row = $('#templateTour').datagrid('getSelections')[0];  //去掉该行，选中的行下面的不可编辑就有问题
		$HUI.dialog('#TourMoDialog',{
			title: '模板元素修改',
			width:400,
			height:340,
			iconCls:'icon-save',
			resizable:false,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					modifyTourConfig();
				}
				},{
					text:'取消',
					handler:function(){
						$HUI.dialog('#TourMoDialog').close();
					}
				}
			]
		});
		//给模态框里的元素赋选中行的值，列的字段的key必须小写，不晓得为啥
		$.each(row,function(key,value){  
			var domID = key.replace(key[0],key[0].toUpperCase());
			if ($('#' + domID).length) {
				var domType = $('#' + domID).attr('class');
		        if (!!domType) {
		        	if (domType.indexOf('combobox') > -1) {
			        	$('#' + domID).combobox('setText', value);
			        } else if (domType.indexOf('textbox') > -1){
			        	$('#' + domID).val(value);
			        } else {}
				}
			}
		});
		$('#OperModelId').attr('disabled',true);
		
		}
	function modifyTourConfig(){
		var row = $('#tourType').datagrid('getSelections')[0];

		var childRow=$('#templateTour').datagrid('getSelections')[0];
			$cm({
			ClassName: "CF.NUR.MNIS.TourModelItemSet",
			MethodName: "Save",
			OperationType:$('#OperationType').val(),
			OperationName:$('#OperationName').val(),
			OperationCode:$('#OperationCode').val(),
			OperationContent:$('#OperationContent').val(),
			OperationCanOrNo:$('#OperationCanOrNo').val(),
			OperationSort:$('#OperationSort').val(),
			OperationDefault:$('#OperationDefault').val(),
			OperationId:childRow.operModelId,    //子表的ID
			TemplateId:row.modelId                //主表的ID
		}, function(ret) {
			$HUI.dialog('#TourMoDialog').close();	
			alert("修改成功")
			initTemplateTour(row.modelId);
			
		});
		
		}
	function saveModelConfig(){
		var row = $('#tourType').datagrid('getSelections')[0];
			$cm({
			ClassName: "CF.NUR.MNIS.TourModelItemSet",
			MethodName: "Save",
			OperationType:$('#OperationType').val(),
			OperationName:$('#OperationName').val(),
			OperationCode:$('#OperationCode').val(),
			OperationContent:$('#OperationContent').val(),
			OperationCanOrNo:$('#OperationCanOrNo').val(),
			OperationSort:$('#OperationSort').val(),
			OperationDefault:$('#OperationDefault').val(),
			OperationId:"",
			TemplateId:row.modelId                //主表的ID
		}, function(ret) {
			$HUI.dialog('#TourMoDialog').close();	
			alert("添加成功")
			initTemplateTour(row.modelId);
		});
		}
	function deleteTourModel(){
		var row = $('#tourType').datagrid('getSelections')[0];
		var childRow=$('#templateTour').datagrid('getSelections')[0];
			$cm({
			ClassName: "CF.NUR.MNIS.TourModelItemSet",
			MethodName: "Delete",
			OperationId:childRow.operModelId,    //子表的ID
			TemplateId:row.modelId                //主表的ID
		}, function(ret) {
			alert("删除成功")
			initTemplateTour(row.modelId);
			
		});
		
		}
	initUI();
	
});
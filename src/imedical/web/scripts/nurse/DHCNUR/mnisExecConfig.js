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
			locGridOnFindClick();
		},
		onSelect: function() {
			locGridOnFindClick();
		}
	});
		$HUI.datagrid('#locGrid', {
		url: '',
		columns: [[
			{ field: 'locDesc', title: '科室名称', width: 200 },
			{ field: 'commonFlag', title: '是否使用通用配置', width: 140, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
			{ field: 'locID', title: 'LocID', width: 50, hidden: true }
		]],
		fitColumns: false,
		idField: 'locID',
		singleSelect: true,
				onDblClickRow: gridOnDblClickRow('locGrid', function(index, row) {
			if (index == 0) { return false; }
		}),
		onClickCell: function(index, field, value) {
			return gridOnClickRow('locGrid', function() {
				locGridOnClickRow();
			})(index, field, value);
		}
	});
	}
	//加载科室
	function locGridOnFindClick() {
	//alert('inputHospID')
	return gridOnFindClick('locGrid', null, function() {
		return getParams(['inputHospID'], 'FindLocs', null, {
			inputLocType: 'W'
		});
	}, function() {
		locGridOnClickRow();
	})();
	}
/// 1.科室列表
function locGridOnClickRow() {
	
	initExecModel();
}
	/**
    * @description: 初始化所有模板表格 alert($('#hospBox').combobox('getValue'));
    */
    function initExecModel() {
		$HUI.datagrid('#templateExec',{
			url: $URL,
			queryParams: {
				ClassName: "CF.NUR.MNIS.ExecConfig",
				QueryName: "getModelJson",
				hospId:$('#hospBox').combobox('getValue'),
				wardId:$('#locGrid').datagrid('getSelections')[0].locID
			},
			columns:[[
				
				{field:'filterType',title:'筛选类型',width:200},
				{field:'filterDocm',title:'筛选单据',width:200},
				{field:'filterGroup',title:'筛选组别',width:200},
				{field:'filterSelect',title:'单选或多选',width:200},
				{field:'filterMark',title:'筛选标识',width:200},
				{field:'filterId',title:'筛选ID',width:200}
			]],
			pagination: true,
			pageSize: 15,
			pageList: [15, 30, 50],
			rownumbers:true,
			singleSelect:true,
			width:100,
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
			}]
		});	
	}
	//增加页签
	function saveModel() {
		
		var row = $('#locGrid').datagrid('getSelections')[0];  //去掉该行，下面的不可编辑就有问题
		
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
					save(row.locID);
				}
				},{
					text:'取消',
					handler:function(){
						$HUI.dialog('#MoDialog').close();
					}
				}
			]
		});
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
	//$('#filterdocm').attr('disabled',true);
	}
	function modifyModel(){
		
		var row = $('#templateExec').datagrid('getSelections')[0];  
		
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
					modify();
				}
				},{
					text:'取消',
					handler:function(){
						$HUI.dialog('#MoDialog').close();
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
		//$('#ModelId').attr('disabled',true);
		
		}
	function deleteModel() {
			var row = $('#templateExec').datagrid('getSelections')[0];
			$cm({
			ClassName: "CF.NUR.MNIS.ExecConfig",
			MethodName: "Delete",
			modelId:row.filterId
		}, function(ret) {
			if (ret == '0') {
			alert("删除成功")
			initExecModel();
			}
		});
		}
	function modify() {
		$cm({
			ClassName: "CF.NUR.MNIS.ExecConfig",
			MethodName: "Save",
			FilterType:$('#filterType').val(),
			FilterDocm:$('#filterDocm').val(),
			FilterGroup:$('#filterGroup').val(),
			FilterSelect:$('#filterSelect').val(),
			FilterMark:$('#filterMark').val(),
			HospId:$('#hospBox').combobox('getValue'),
			WardId:$('#locGrid').datagrid('getSelections')[0].locID,
			ModelId:$('#templateExec').datagrid('getSelections')[0].filterId
		}, function(ret) {
			
			if (ret == '0') {
			$HUI.dialog('#MoDialog').close();	
			alert("修改成功")
			initExecModel();
			}
		});
		}	
	function save(id) {
		$cm({
			ClassName: "CF.NUR.MNIS.ExecConfig",
			MethodName: "Save",
			FilterType:$('#filterType').val(),
			FilterDocm:$('#filterDocm').val(),
			FilterGroup:$('#filterGroup').val(),
			FilterSelect:$('#filterSelect').val(),
			FilterMark:$('#filterMark').val(),
			HospId:$('#hospBox').combobox('getValue'),
			WardId:id,
			ModelId:""
		}, function(ret) {
			if (ret == '0') {
			$HUI.dialog('#MoDialog').close();	
			alert("添加成功")
			initExecModel();
			}
		});
		}
	initUI();
	
});
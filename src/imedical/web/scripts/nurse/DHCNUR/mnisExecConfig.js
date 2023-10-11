/*
 * @author: LMS
 * @discription: �ƶ���������
 * @date: 2021-04-05
 */
GV._CLASSNAME = 'Nur.HISUI.MNISConfig';
$(function () {
	
	/**
    * @description: ��ʼ������
    */
	function initUI() {
		initPageDom();
	
	}
function initPageDom() {
	/// Ժ��
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
			{ field: 'locDesc', title: '��������', width: 200 },
			{ field: 'commonFlag', title: '�Ƿ�ʹ��ͨ������', width: 140, formatter: getBoxFormatter('flag'),
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
	//���ؿ���
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
/// 1.�����б�
function locGridOnClickRow() {
	
	initExecModel();
}
	/**
    * @description: ��ʼ������ģ���� alert($('#hospBox').combobox('getValue'));
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
				
				{field:'filterType',title:'ɸѡ����',width:200},
				{field:'filterDocm',title:'ɸѡ����',width:200},
				{field:'filterGroup',title:'ɸѡ���',width:200},
				{field:'filterSelect',title:'��ѡ���ѡ',width:200},
				{field:'filterMark',title:'ɸѡ��ʶ',width:200},
				{field:'filterId',title:'ɸѡID',width:200}
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
				text:'����',
				handler: saveModel
			},{
				id: 'btnUpdate',
				iconCls: 'icon-edit',
				text:'�޸�',
				handler: modifyModel
			},{
				id: 'btnUpdate',
				iconCls: 'icon-remove',
				text:'ɾ��',
				handler: deleteModel
			}]
		});	
	}
	//����ҳǩ
	function saveModel() {
		
		var row = $('#locGrid').datagrid('getSelections')[0];  //ȥ�����У�����Ĳ��ɱ༭��������
		
		$HUI.dialog('#MoDialog',{
			title: 'ҳǩ����',
			width:400,
			height:340,
			iconCls:'icon-save',
			resizable:false,
			modal:true,
			buttons:[{
				text:'����',
				handler:function(){
					save(row.locID);
				}
				},{
					text:'ȡ��',
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
			title: 'ҳǩ�޸�',
			width:400,
			height:340,
			iconCls:'icon-save',
			resizable:false,
			modal:true,
			buttons:[{
				text:'����',
				handler:function(){
					modify();
				}
				},{
					text:'ȡ��',
					handler:function(){
						$HUI.dialog('#MoDialog').close();
					}
				}
			]
		});
		//��ģ̬�����Ԫ�ظ�ѡ���е�ֵ���е��ֶε�key����Сд��������Ϊɶ
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
			alert("ɾ���ɹ�")
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
			alert("�޸ĳɹ�")
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
			alert("��ӳɹ�")
			initExecModel();
			}
		});
		}
	initUI();
	
});
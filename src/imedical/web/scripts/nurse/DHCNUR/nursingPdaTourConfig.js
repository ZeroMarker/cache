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
    * @description: ��ʼ������ģ����
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
				{field:'modelName',title:'ҳǩ����',width:80},
				{field:'modelSort',title:'ҳǩ˳��',width:80},
				{field:'canFlag',title:'�Ƿ�����',width:80},
				{field:'modelId',title:'ҳǩId',width:80}
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
				{field:'operationType',title:'��������',width:80},
				{field:'operationName',title:'��������',width:80},
				{field:'operationCode',title:'����Code',width:80},
				{field:'operationContent',title:'����������',width:80},
				{field:'operationCanOrNo',title:'�Ƿ�ɱ༭',width:80},
				{field:'operationSort',title:'��ʾ˳��',width:80},
				{field:'operationDefault',title:'Ĭ��ֵ',width:80},
				{field:'operModelId',title:'Ԫ��Id',width:80}
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
				text:'����',
				handler: saveTourModel
			},{
				id: 'btnUpdate',
				iconCls: 'icon-edit',
				text:'�޸�',
				handler: modifyTourModel
			},{
				id: 'btnDelete',
				iconCls: 'icon-remove',
				text:'ɾ��',
				handler: deleteTourModel
			}]
			//onClickRow: getModelData
		});	
	}
	//����ҳǩ
	function saveModel() {
		var row = $('#tourType').datagrid('getSelections')[0];  //ȥ�����У�����Ĳ��ɱ༭��������
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
					save();
				}
				},{
					text:'ȡ��',
					handler:function(){
						$HUI.dialog('#MoDialog').close();
					}
				}
			]
		});
		//��ģ̬�����Ԫ�ظ�ѡ���е�ֵ��
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
		
		var row = $('#tourType').datagrid('getSelections')[0];  //ȥ�����У�����Ĳ��ɱ༭��������
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
					modify(row.modelId);
				}
				},{
					text:'ȡ��',
					handler:function(){
						$HUI.dialog('#MoDialog').close();
					}
				}
			]
		});
		//toUpperCase   toLowerCase
		//��ģ̬�����Ԫ�ظ�ѡ���е�ֵ���е��ֶκ�ģ̬����ֶ�Ҫһ��
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
			alert("�޸ĳɹ�")
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
			alert("��ӳɹ�")
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
			alert("ɾ���ɹ�")
			initTourType();
			}
		});
		}
	
	function getModelData(){
		var row=$('#tourType').datagrid('getSelections')[0];   //ȡ������е�ID
		initTemplateTour(row.modelId);      
		}
	function saveTourModel(){
		var row = $('#templateTour').datagrid('getSelections')[0];  //ȥ�����У�ѡ�е�������Ĳ��ɱ༭��������
		//alert(row.modelId)  �����ID   ��ѡ��
		$HUI.dialog('#TourMoDialog',{
			title: 'ģ��Ԫ������',
			width:400,
			height:340,
			iconCls:'icon-save',
			resizable:false,
			modal:true,
			buttons:[{
				text:'����',
				handler:function(){
					saveModelConfig();
				}
				},{
					text:'ȡ��',
					handler:function(){
						$HUI.dialog('#TourMoDialog').close();
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
		$('#OperModelId').attr('disabled',true);
		}
	function modifyTourModel(){
		var row = $('#templateTour').datagrid('getSelections')[0];  //ȥ�����У�ѡ�е�������Ĳ��ɱ༭��������
		$HUI.dialog('#TourMoDialog',{
			title: 'ģ��Ԫ���޸�',
			width:400,
			height:340,
			iconCls:'icon-save',
			resizable:false,
			modal:true,
			buttons:[{
				text:'����',
				handler:function(){
					modifyTourConfig();
				}
				},{
					text:'ȡ��',
					handler:function(){
						$HUI.dialog('#TourMoDialog').close();
					}
				}
			]
		});
		//��ģ̬�����Ԫ�ظ�ѡ���е�ֵ���е��ֶε�key����Сд��������Ϊɶ
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
			OperationId:childRow.operModelId,    //�ӱ��ID
			TemplateId:row.modelId                //�����ID
		}, function(ret) {
			$HUI.dialog('#TourMoDialog').close();	
			alert("�޸ĳɹ�")
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
			TemplateId:row.modelId                //�����ID
		}, function(ret) {
			$HUI.dialog('#TourMoDialog').close();	
			alert("��ӳɹ�")
			initTemplateTour(row.modelId);
		});
		}
	function deleteTourModel(){
		var row = $('#tourType').datagrid('getSelections')[0];
		var childRow=$('#templateTour').datagrid('getSelections')[0];
			$cm({
			ClassName: "CF.NUR.MNIS.TourModelItemSet",
			MethodName: "Delete",
			OperationId:childRow.operModelId,    //�ӱ��ID
			TemplateId:row.modelId                //�����ID
		}, function(ret) {
			alert("ɾ���ɹ�")
			initTemplateTour(row.modelId);
			
		});
		
		}
	initUI();
	
});
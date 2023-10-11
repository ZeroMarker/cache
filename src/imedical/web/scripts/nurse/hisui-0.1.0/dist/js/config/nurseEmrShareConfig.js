var hospId=session['LOGON.HOSPID']
var HospEnvironment=true;
$(function() {
	function initUI() {
		if (typeof GenHospComp == "undefined") {
			HospEnvironment=false;
		}
		if(HospEnvironment){
			initHosp();
		}else{
			var hospDesc=tkMakeServerCall("NurMp.DHCNURTemPrintLInk","GetHospDesc",session['LOGON.HOSPID'])
			$("#_HospList").val(hospDesc)
			$('#_HospList').attr('disabled',true);
		}
		
		initCondition();
		initEvent();
		findshareDoc();
		initSubGrid();
		initTemplatesTree("");
		initChlGrid("");
		
	}
	function initHosp(){
	
		var hospComp = GenHospComp("Nur_IP_NurseEmrShareConfig",session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']);  
		hospComp.options().onSelect = function(){
			if(HospEnvironment) hospId=$HUI.combogrid('#_HospList').getValue()
			findshareDoc();
			initSubGrid();
			initTemplatesTree("");
			initChlGrid("");
		} 
		hospId = hospComp.options().value;
	}
	
	
	function initCondition() {
		$HUI.combobox('#category', {
			valueField: 'value',
			textField: 'value',
			editable:false,
			panelHeight:"auto",
            enterNullValueClear:false,
            data: [
                { value: "������"},
                { value: "���µ�"}
            ]
		});
		
	}
	function initTemplatesTree(searchCode) {
		$HUI.tree('#TemplateTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "NurMp.NurseEmrShareConfigSub",
					MethodName: "GetTempleteTree",
					Parr: "^"+searchCode
				}, function(data) {
					success(data);
				});
			},
			autoNodeHeight: false,
			onClick: function (node) {
				treeNodeClick(node)
			},
		    onContextMenu : function(e,node){
		    }
		});
		
	}
	function initElementTree(guid,desc){
		//alert(guid)
		$HUI.tree('#elementTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "NurMp.NurseEmrShareConfigSub",
					MethodName: "GetEmrElement",
					code: guid,
					desc:desc
				}, function(data) {
					success(data);
				});
			},
			onClick: function (node) {
				
			},
		    onContextMenu : function(e,node){
		    }
		});
	}
	function treeNodeClick(node){
		//var aaa=$HUI.tree('#leftTemplateTree').getSelected()
		//var aaa=$('#leftTemplateTree').tree('getSelected')  
		if(node.isLeaf!=0){
			initElementTree(node.guid,node.text)
		}else{
			initElementTree("")
		}
	}
	function initEvent() {
		$('#addDoc').bind('click', addDoc);
		$('#editDoc').bind('click', editDoc);
		$('#deleteDoc').bind('click', deleteDoc);
		$('#search').searchbox({
			searcher: function(value) {
				initTemplatesTree(value)
			},
			prompt: 'ģ����,EmrCode'
		});
	}
	
	function addDoc() {
		var code = $('#code').val();
		var desc = $('#desc').val();
		var notes = $('#notes').val();
		var category = $('#category').combobox('getText');
		if(code==""){ $.messager.popover({msg:'���벻��Ϊ��!',type:'error'}); return; }
		if(desc==""){ $.messager.popover({msg:'���Ʋ���Ϊ��!',type:'error'}); return; }
		if(category==""){ $.messager.popover({msg:'��𲻿�Ϊ��!',type:'error'}); return; }
		
		$m({
			ClassName: "NurMp.NurseEmrShareConfig",
			MethodName: "Save",
			ID:"",
			Code:code, 
			Desc:desc, 
			Type:category, 
			Notes:notes,
			hospId:hospId
		},function(txtData){
			
			if(txtData == 0) {
				$.messager.popover({msg:'��ӳɹ���',type:'success'});
				clearDocItem()
				$('#shareDocGrid').datagrid('reload');
			}else{
				$.messager.popover({msg:txtData,type:'error'});
			}
		});
	}
	function editDoc() {
		var dataSourceRow = $('#shareDocGrid').datagrid('getSelected');
		if (!dataSourceRow) { $.messager.popover({msg:'����ѡ��һ������!',type:'error'}); return; }
		var code = $('#code').val();
		var desc = $('#desc').val();
		var notes = $('#notes').val();
		var category = $('#category').combobox('getText');
		if(code==""){ $.messager.popover({msg:'���벻��Ϊ��!',type:'error'}); return; }
		if(desc==""){ $.messager.popover({msg:'���Ʋ���Ϊ��!',type:'error'}); return; }
		if(category==""){ $.messager.popover({msg:'��𲻿�Ϊ��!',type:'error'}); return; }
		
		$m({
			ClassName: "NurMp.NurseEmrShareConfig",
			MethodName: "Save",
			ID:dataSourceRow.id,
			Code:code, 
			Desc:desc, 
			Type:category, 
			Notes:notes,
			hospId:hospId
		},function(txtData){
			
			if(txtData == 0) {
				$.messager.popover({msg:'�޸ĳɹ���',type:'success'});
				clearDocItem()
				$('#shareDocGrid').datagrid('reload');
			}else{
				$.messager.popover({msg:txtData,type:'error'});
			}
		});
	}
	function clearDocItem(){
		$('#code').val("");
		$('#desc').val("");
		$('#notes').val("");
		$('#category').combobox('setValue',"");
	}
	function deleteDoc() {
		var dataSourceRow = $('#shareDocGrid').datagrid('getSelected');
		if (!dataSourceRow) { $.messager.popover({msg:'����ѡ��һ������!',type:'error'}); return; }
		$m({
			ClassName: "NurMp.NurseEmrShareConfig",
			MethodName: "Delete",
			ID:dataSourceRow.id,
			hospId:hospId
		},function(txtData){
			
			if(txtData == 0) {
				$.messager.popover({msg:'ɾ���ɹ���',type:'success'});
				$('#shareDocGrid').datagrid('reload');
				clearDocItem();
				clearSubItem();
				
				initChlGrid();
				initSubGrid();
				clearChlItem();
				
			}else{
				$.messager.popover({msg:txtData,type:'error'});
			}
		});
	}
	function findshareDoc() {
		$('#shareDocGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.NurseEmrShareConfig',
				QueryName: 'FindDoc',
				hospId:hospId
			},
			nowrap: false,
			toolbar: '#shareDocGrid_toolbar',
			rownumbers: true,
			singleSelect: true,
			pagination: false,
			//pageSize: 20,
			//pageList: [20,30,40,50,60],
			onClickRow: shareDocGridClickRow
		});
	}
	
	function initSubGrid() {
		
		$('#subGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.NurseEmrShareConfigSub',
				QueryName: 'FindSub',
				ParId: ''
			},
			toolbar: [{
					iconCls: 'icon-add',
					text: '����',
					handler: function() {
						addSubItem();
					}
				}, {
					iconCls: 'icon-edit',
					text: '�޸�',
					handler: function() {
						editSubItem();
					}
				}, {
					iconCls: 'icon-remove',
					text: 'ɾ��',
					handler: function() {
						deleteSubItem();
					}
				}
			],
			nowrap: false,
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: 60,
			pageList: [60,120,180,240],
			onClickRow: subGridClickRow
		});
	}
	function initChlGrid(ParId) {
		$('#chlGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.NurseEmrShareConfigChl',
				QueryName: 'FindChl',
				ParId: ParId
			},
			toolbar: [{
					iconCls: 'icon-add',
					text: '����',
					handler: function() {
						addChlItem();
					}
				}, {
					iconCls: 'icon-edit',
					text: '�޸�',
					handler: function() {
						editChlItem();
					}
				}, {
					iconCls: 'icon-remove',
					text: 'ɾ��',
					handler: function() {
						deleteChlItem();
					}
				}
			],
			nowrap: false,
			rownumbers: true,
			singleSelect: true,
			pagination: false,
			//pageSize: 30,
			//pageList: [30,60,90,120,150],
			onClickRow: chlGridClickRow
		});
	}
	function chlGridClickRow(rowIndex, rowData){
		for (var item in rowData) {
	        var domID = "#" + item;
			if (domID === '#TempleteId') {
		        var n = $('#TemplateTree').tree('find', rowData[item]);
		        $("#TemplateTree").tree('select', n.target);
		        
		        $HUI.tree('#elementTree', {
					loader: function(param, success, error) {
						$cm({
							ClassName: "NurMp.NurseEmrShareConfigSub",
							MethodName: "GetEmrElement",
							code: rowData["guid"],
							desc:rowData["Templete"]
						}, function(data) {
							success(data);
							var nsub = $('#elementTree').tree('find', rowData["Element"]);
		        			$("#elementTree").tree('select', nsub.target);
							
						});
					}
				});
		        
		        
		        
	        }else if(domID === '#Format'){
		        $(domID).val(rowData[item]);
	        }
	    }
	}
	function clearChlItem(){
		$('#Format').val("");
		$("#elementTree").tree('select', null);
	}
	function addChlItem(){
		var dataRow = $('#subGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'�������ѡ��һ������!',type:'info'});
			return;
		}
		var Format = $('#Format').val();
		var TemplateTree=$HUI.tree('#TemplateTree').getSelected()
		var elementTree=$HUI.tree('#elementTree').getSelected()
		if(!TemplateTree){
			$.messager.popover({msg:"��ѡ��ģ��!",type:'info'});
			return ;
		}
		if(!elementTree){
			$.messager.popover({msg:"��ѡ��Ԫ��!",type:'info'});
			return ;
		}
		
		$m({
			ClassName: "NurMp.NurseEmrShareConfigChl",
			MethodName: "Save",
			ParId:dataRow.subId,
			ID:"", 
			Templete:TemplateTree.guid, 
			Element:elementTree.id, 
			Format:Format
		},function(result){
			
			if(result == 0) {
				
				$.messager.popover({msg:'��ӳɹ���',type:'success'});
				$('#chlGrid').datagrid({
					url: $URL,
					queryParams: {
						ClassName: 'NurMp.NurseEmrShareConfigChl',
						QueryName: 'FindChl',
						ParId: dataRow.subId
					}
				});
				clearChlItem()
			}else{
				$.messager.popover({msg:result,type:'success'});
			}
		});
	}
	function editChlItem(){
		var dataRow = $('#subGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'�������ѡ��һ������!',type:'info'});
			return;
		}
		var subRow = $('#chlGrid').datagrid('getSelected');
		if (!subRow) {
			$.messager.popover({msg:'��ѡ��һ������!',type:'info'});
			return;
		}
		var Format = $('#Format').val();
		var TemplateTree=$HUI.tree('#TemplateTree').getSelected()
		var elementTree=$HUI.tree('#elementTree').getSelected()
		if(!TemplateTree){
			$.messager.popover({msg:"��ѡ��ģ��!",type:'info'});
			return ;
		}
		if(!elementTree){
			$.messager.popover({msg:"��ѡ��Ԫ��!",type:'info'});
			return ;
		}
		
		$m({
			ClassName: "NurMp.NurseEmrShareConfigChl",
			MethodName: "Save",
			ParId:dataRow.subId,
			ID:subRow.chlId, 
			Templete:TemplateTree.guid, 
			Element:elementTree.id, 
			Format:Format
		},function(result){
			
			if(result == 0) {
				$.messager.popover({msg:'�޸ĳɹ���',type:'success'});
				$('#chlGrid').datagrid({
					url: $URL,
					queryParams: {
						ClassName: 'NurMp.NurseEmrShareConfigChl',
						QueryName: 'FindChl',
						ParId: dataRow.subId
					}
				});
				clearChlItem()
			}else{
				$.messager.popover({msg:result,type:'success'});
			}
		});
	}
	function deleteChlItem(){
		var dataRow = $('#subGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'��������б�ѡ��һ������!',type:'info'});
			return;
		}
		var subRow = $('#chlGrid').datagrid('getSelected');
		if (!subRow) {
			$.messager.popover({msg:'��ѡ��һ������!',type:'info'});
			return;
		}
		$m({
			ClassName: "NurMp.NurseEmrShareConfigChl",
			MethodName: "Delete",
			ID: subRow.chlId
		},function(result){
			
			if(result == 0) {
				$.messager.popover({msg:'ɾ���ɹ���',type:'success'});
				$('#chlGrid').datagrid({
					url: $URL,
					queryParams: {
						ClassName: 'NurMp.NurseEmrShareConfigChl',
						QueryName: 'FindChl',
						ParId: dataRow.subId
					}
				});
				clearChlItem()
			}
		});
	}
	function shareDocGridClickRow(rowIndex, rowData) {
		setCommonInfo(rowData);
		
		
		if(rowData.category=="������"){
			$("#defaultLab").text("Ĭ��ֵ")
			$("#splitLab").html("���ӷ�")
			$('#subGrid').datagrid('getColumnOption','defaultVal').title="Ĭ��ֵ";  
			$('#subGrid').datagrid('getColumnOption','splitChar').title="���ӷ�"; 
		}else{
			$("#defaultLab").text("��ʽ��")
			$("#splitLab").html("������")
			$('#subGrid').datagrid('getColumnOption','defaultVal').title="��ʽ��";  
			$('#subGrid').datagrid('getColumnOption','splitChar').title="������"; 
		}
		//$('#subGrid').datagrid()
		
		
		
		$('#subGrid').datagrid({
			queryParams: {
				ClassName: 'NurMp.NurseEmrShareConfigSub',
				QueryName: 'FindSub',
				ParId: rowData.id
			}
		});
	}
	function setCommonInfo(rowData) {
		for (var item in rowData) {
	        var domID = "#" + item;
			
	        if (domID === '#category') {
	        	$(domID).combobox('setValue', rowData[item]);
	        } else {
	        	$(domID).val(rowData[item]);
	        }
	    }
	}
	
	
	function subGridClickRow(rowIndex, rowData) {
		setCommonInfo(rowData);
		
		$('#chlGrid').datagrid('reload', {
			ClassName: 'NurMp.NurseEmrShareConfigChl',
			QueryName: 'FindChl',
			ParId: rowData.subId
		});
	}
	
	function addSubItem() {
		var dataRow = $('#shareDocGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'�������ѡ��һ������!',type:'info'});
			return;
		}
		
		var itemName = $('#itemName').val();
		var itemCode = $('#itemCode').val();
		var defaultVal = $('#defaultVal').val();
		var splitChar = $('#splitChar').val();
		
		if(itemName==""){
			$.messager.popover({msg:"��������Ϊ��",type:'info'});
			return ;
		}
		if(itemCode==""){
			$.messager.popover({msg:"���벻��Ϊ��",type:'info'});
			return ;
		}
		
		
		$m({
			ClassName: "NurMp.NurseEmrShareConfigSub",
			MethodName: "Save",
			ParId:dataRow.id,
			ID:"", 
			ItemName:itemName, 
			ItemCode:itemCode, 
			SplitChar:splitChar, 
			DefaultValue:defaultVal
		},function(result){
			
			if(result == 0) {
				$.messager.popover({msg:'��ӳɹ���',type:'success'});
				clearSubItem();
				$('#subGrid').datagrid('reload');
			}else{
				$.messager.popover({msg:result,type:'success'});
			}
		});
	}
	function clearSubItem(){
		$('#itemName').val("");
		$('#itemCode').val("");
		$('#defaultVal').val("");
		$('#splitChar').val("");
		
	}
	function editSubItem() {
		var dataRow = $('#shareDocGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'�������ѡ��һ������!',type:'info'});
			return;
		}
		var subRow = $('#subGrid').datagrid('getSelected');
		if (!subRow) {
			$.messager.popover({msg:'��ѡ��һ������!',type:'info'});
			return;
		}
		var itemName = $('#itemName').val();
		var itemCode = $('#itemCode').val();
		var defaultVal = $('#defaultVal').val();
		var splitChar = $('#splitChar').val();
		
		if(itemName==""){
			$.messager.popover({msg:"��������Ϊ��",type:'info'});
			return ;
		}
		if(itemCode==""){
			$.messager.popover({msg:"���벻��Ϊ��",type:'info'});
			return ;
		}
		
		
		$m({
			ClassName: "NurMp.NurseEmrShareConfigSub",
			MethodName: "Save",
			ParId:dataRow.id,
			ID:subRow.subId, 
			ItemName:itemName, 
			ItemCode:itemCode, 
			SplitChar:splitChar, 
			DefaultValue:defaultVal
		},function(result){
			
			if(result == 0) {
				$.messager.popover({msg:'�޸ĳɹ���',type:'success'});
				clearSubItem();
				$('#subGrid').datagrid('reload');
			}else{
				$.messager.popover({msg:result,type:'success'});
			}
		});
	}
	/**
	 * @description ɾ���ֶ���Ŀ
	 */
	function deleteSubItem() {
		var dataRow = $('#shareDocGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'��������б�ѡ��һ������!',type:'info'});
			return;
		}
		var subRow = $('#subGrid').datagrid('getSelected');
		if (!subRow) {
			$.messager.popover({msg:'��ѡ��һ������!',type:'info'});
			return;
		}
		$m({
			ClassName: "NurMp.NurseEmrShareConfigSub",
			MethodName: "Delete",
			ID: subRow.subId
		},function(result){
			
			if(result == 0) {
				$.messager.popover({msg:'ɾ���ɹ���',type:'success'});
				$('#subGrid').datagrid('reload');
				clearSubItem();
				
				initChlGrid();
				clearChlItem();
			}
		});
	}
	
	
	initUI();
});
var hospId=session['LOGON.HOSPID'];
var HospEnvironment=true;
$(function() { 
	/**
	 * @description 初始化界面
	 */
	 var treeSelect=""
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
			//$("#_HospListLabel").css("display","none")
	    	//$("#_HospList").css("display","none")
		}
		initCondition();
		initEvent();
		initLocGrid("");
		initTemplatesTree("");
		initBlankGrid();
		
	}
	
	function initHosp(){
		var hospComp = GenHospComp("Nur_IP_DHCNurChangeLableRec",session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']);  
		hospComp.options().onSelect = function(){
			if(HospEnvironment) hospId=$HUI.combogrid('#_HospList').getValue()
			var searchCode=$HUI.searchbox('#searchLoc').getValue()
			initLocGrid(searchCode)	
			initTemplatesTree("");
			initBlankGrid();
		}  ///选中事件
		hospId = hospComp.options().value;
	}
	
	function initBlankGrid() {
		$('#blankGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.DHCNurChangeLableRec',
				QueryName: 'GetLocBlankLable',
				locs: '',
				code:'',
				hospId:hospId
			},
			nowrap: false,
			toolbar: [{
					iconCls: 'icon-add',
					text: '增加',
					handler: function() {
						addItem();
					}
				}, {
					iconCls: 'icon-edit',
					text: '修改',
					handler: function() {
						editItem();
					}
				}, {
					iconCls: 'icon-remove',
					text: '删除',
					handler: function() {
						deleteItem();
					}
				}
			],
			rownumbers: false,
			singleSelect: true,
			
			onClickRow: blankGridClickRow
		});
	}
	/**
	 * @description 字段表格点击事件
	 */
	function blankGridClickRow(rowIndex, rowData) {
		$('#blankElement').combobox({url: $URL + '?ClassName=NurMp.DHCNurChangeLableRec&QueryName=GetEmrElement&ResultSetType=array&code='+rowData.guid });
		setCommonInfo(rowData);
	}
	/**
	 * @description 加载表格的行信息
	 */
	function setCommonInfo(rowData) {
		for (var item in rowData) {
	        var domID = "#" + item;
			$(domID).combobox('setValue', rowData[item]);
	    }
	}
	function initCondition() {
		$HUI.combobox('#blankName', {
			valueField: 'value',
			textField: 'value',
			editable:true,
			panelHeight:"auto",
            enterNullValueClear:false,
            data: [
                { value: "尿量"},
                { value: "呕吐量"},
				{ value: "引流量"},
				{ value: "测试1"},
				{ value: "测试2"}
            ]
		});
		$HUI.combobox('#blankElement', {
			valueField: 'element',
			textField: 'desc',
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			url: $URL + '?ClassName=NurMp.DHCNurChangeLableRec&QueryName=GetEmrElement&ResultSetType=array&code=',
		});
	}
	function initTemplatesTree(searchCode) {
		$HUI.tree('#templateTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "NurMp.DHCNurChangeLableRec",
					MethodName: "GetInternalConfigTree",
					Parr: "^"+searchCode+"^"+hospId
				}, function(data) {
					success(data);
				});
			},
			autoNodeHeight: true,
			onSelect: function (node) {
				treeNodeClick(node)
			},
		    onContextMenu : function(e,node){
		    }
		});
		
	}
	function treeNodeClick(node){
		if(treeSelect==""){
			treeSelect=node.guid
		}else if(treeSelect!=node.guid){
			treeSelect=node.guid
		}else{
			$('#templateTree').find('.tree-node-selected').removeClass('tree-node-selected');
			treeSelect=""
		}
		var node=$HUI.tree('#templateTree').getSelected()
		debugger;
		if(node&&node.isLeaf!=0){
			$('#blankElement').combobox({url: $URL + '?ClassName=NurMp.DHCNurChangeLableRec&QueryName=GetEmrElement&ResultSetType=array&code='+node.guid });
			
		}else{
			$('#blankElement').combobox({url: $URL + '?ClassName=NurMp.DHCNurChangeLableRec&QueryName=GetEmrElement&ResultSetType=array&code=' });
		}
		reloadBlankGrid()
		
		
	}
	function reloadBlankGrid(){
		var dataRow = $('#locGrid').datagrid('getChecked');
		
		if (dataRow.length==0) {
			
		}
		var code=""
		var node=$HUI.tree('#templateTree').getSelected()
		if(!node||node.isLeaf==0){
		}else{
			code=node.guid;
		}
		
		var locs=""
		$.each(dataRow, function(index, item){
			if(locs=="") locs=item.id
			else locs=locs+"^"+item.id
		});
		$('#blankGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.DHCNurChangeLableRec',
				QueryName: 'GetLocBlankLable',
				locs: locs,
				code:code,
				hospId:hospId
			},
		});
	}
	
	function initLocGrid(searchCode) {
		$('#locGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.DHCNurChangeLableRec',
				QueryName: 'GetLocs',
				Parr: searchCode,
				hospId:hospId,
				rows: 1000
			},
			nowrap: false,
			rownumbers: false,
			singleSelect: false,
			
			onCheck:selectLocGridRow,
			onUncheck:selectLocGridRow,
			onCheckAll:selectLocGridRow,
			onUncheckAll:selectLocGridRow,
			
		});
	}
	function selectLocGridRow(){
		reloadBlankGrid();
	}
	function initEvent() {
		$('#searchLoc').searchbox({
			searcher: function(value) {
				initLocGrid(value)
			},
			prompt: '科室名称'
		});
		$('#searchTemplate').searchbox({
			searcher: function(value) {
				initTemplatesTree(value)
			},
			prompt: '模板名称,emrCode'
		});
	}
	function addItem() {
		var dataRow = $('#locGrid').datagrid('getChecked');
		if (dataRow.length==0) {
			$.messager.popover({msg:'未选择科室!',type:'error'});
			return;
		}
		var node=$HUI.tree('#templateTree').getSelected()
		if(!node||node.isLeaf==0){
			$.messager.popover({msg:'请选择模板!',type:'error'});
			return;
		}
		var blankElement = $('#blankElement').combobox('getValue');
		var blankName = $('#blankName').combobox('getText');
		if(blankElement==""||blankName==""){
			$.messager.popover({msg:'空白栏列和空白栏标题都不可为空!',type:'error'});
			return;
		}
	$.each(dataRow, function(index, item){
			var parr=blankName+"^"+blankElement+"^"+node.guid+"^"+item.id+"^"+session['LOGON.USERID']
			
			$m({
				ClassName: "NurMp.DHCNurChangeLableRec",
				MethodName: "Save",
				parr:parr,
				id:'' ,
				hospId:hospId
			},function(result){
				if(result == 0) {
					$.messager.popover({msg:'增加成功！',type:'success'});
					reloadBlankGrid()
					
				}else{
					$.messager.popover({msg:result,type:'error'});
				}
			});	
		});	
	}
	function editItem() {
		var dataRow = $('#blankGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'请先选中一条数据!',type:'info'});
			return;
		}
		var blankElement = $('#blankElement').combobox('getValue');
		var blankName = $('#blankName').combobox('getText');
		if(blankElement==""||blankName==""){
			$.messager.popover({msg:'空白栏列和空白栏标题都不可为空!',type:'error'});
			return;
		}
		var parr=blankName+"^"+blankElement+"^"+dataRow.guid+"^"+dataRow.locId+"^"+session['LOGON.USERID']
		$m({
			ClassName: "NurMp.DHCNurChangeLableRec",
			MethodName: "Save",
			parr:parr,
			id:dataRow.id,
			hospId:hospId
		},function(result){
			if(result == 0) {
				$.messager.popover({msg:'修改成功！',type:'success'});
				reloadBlankGrid()
					
			}else{
				$.messager.popover({msg:result,type:'error'});
			}
		});	
		
	}
	function deleteItem() {
		var dataRow = $('#blankGrid').datagrid('getSelected');
		if (!dataRow) {
			$.messager.popover({msg:'请先选中一条数据!',type:'info'});
			return;
		}
		$.messager.confirm("删除", "确定删除选中的记录吗?", function (r) {
		if (r) {
			$m({
				ClassName: "NurMp.DHCNurChangeLableRec",
				MethodName: "delete",
				id: dataRow.id,
				hospId:hospId
				},function(result){
					if(result == 0) {
						$.messager.popover({msg:'删除成功！',type:'success'});
						reloadBlankGrid();
					}else{
						$.messager.popover({msg:result,type:'error'});
					}
				});		
			}
		});
		
		
		
	}
	initUI();
});
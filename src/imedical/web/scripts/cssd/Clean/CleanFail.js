//删除明细
function deleteItem(ItemRowId){
	if (!isEmpty(ItemRowId)) {
		$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){
			if(data){
				$.cm({
					ClassName:'web.CSSDHUI.Clean.CleanFailItem',
					MethodName:'jsDelete',
					rowId:ItemRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#ItemList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});			
			}
		});
	}
}
//删除主表单据
//第一步:盘点单据是否可以删除
// 第二步删除主表单据
// 第三步删除子表数据 (包括修改打包表数据)目前的策略是:有明细不允许删除
function deleteMain(mainRowId){
	if (isEmpty(mainRowId)) {
		$UI.msg('alert','请选择要删除的单据!');
		return false;
	}
	$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){
		if(data){
			$.cm({
				ClassName:'web.CSSDHUI.Clean.CleanFailed',
				MethodName:'jsDelete',
				mainRowId:mainRowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#MainList').datagrid('reload');
					$('#ItemList').datagrid('reload');
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});		
		}
	});
}
	var GridListIndex = "";
	var GridListIndexId = ""
	function cancelOrder(Id){
		$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){
			if(data){
				var Rows = $('#MainList').datagrid("getRows");
				$.each(Rows,function(index,item){
					if(item.RowId==Id){
						GridListIndex=index;
						GridListIndexId=Id;
					}
				});
				$.cm({
					ClassName:'web.CSSDHUI.Clean.CleanFailed',
					MethodName:'jsCancelOrder',
					Id:Id
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#MainList').datagrid('reload');
						$('#ItemList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});				
			}
		});
	}
	function submitOrder(Id){
		var Rows = $('#MainList').datagrid("getRows");
		$.each(Rows,function(index,item){
			if(item.RowId==Id){
				GridListIndex=index;
				GridListIndexId=Id;
			}
		});
		$.cm({
			ClassName:'web.CSSDHUI.Clean.CleanFailed',
			MethodName:'jsSubmitOrder',
			Id:Id
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				$('#MainList').datagrid('reload');
				$('#ItemList').datagrid('reload');
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}

var init = function() {
	 //科室
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ReqLocBox = $HUI.combobox('#DeptLocID', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认登录科室
			$("#DeptLocID").combobox('setValue',gLocId);
		}
	});
	setDafult();
	var Params = JSON.stringify($UI.loopBlock('MainCondition'));
	//查询
	$UI.linkbutton('#SearchBT',{
		onClick:function(){
			query()
		}
	});
	var query = function query(){ 
		$UI.clear(ItemListGrid);
		GridListIndex = "";
		GridListIndexId = ""
		var ParamsObj=$UI.loopBlock('#MainCondition');
		var Params=JSON.stringify(ParamsObj);
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			QueryName: 'SelectAll'	,
			Params: Params
		});
		
	}
	//保存单据
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			if($("#DeptLocID").combobox('getValues')==""){
				$UI.msg('alert','请选择科室');
				return;
			}
			saveMast();
		}
	});
	function saveMast(){
		var MainObj = $UI.loopBlock('#MainCondition');
		GridListIndex = "";
		GridListIndexId = ""
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			MethodName: 'jsSave',
			Params: JSON.stringify(MainObj)
			},function(jsonData){
				if(!isEmpty(jsonData.rowid)){
					$UI.msg('success',jsonData.msg);
					FindNew(jsonData.rowid);
				}
		});
	}
	
	function Clear(){
		$UI.clearBlock('#MainCondition');
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
	}
	
	//设置默认值
	function setDafult(){
		var Dafult={
			FStartD:DefaultStDate(),
			FEndD:DefaultEdDate()
		}
		$UI.fillBlock('#MainCondition',Dafult)
		$("#DeptLocID").combobox('setValue',gLocId);
	}

	var MainCm = [[{
		field:'operate',
		title:'操作',
		align:'center',
		width:80,
		formatter:function(value, row, index){
			if(row.Status==1){
				var str = '<a href="#" name="operaM" class="easyui-linkbutton" title="删除" disabled onclick="deleteMain('+row.RowId+')"></a>';
				var str = str + '<a href="#" name="operaR" class="easyui-linkbutton" title="撤销" onclick="cancelOrder('+ row.RowId + ')"></a>';					
			}else{
				var str = '<a href="#" name="operaM" class="easyui-linkbutton" title="删除" onclick="deleteMain('+row.RowId+')"></a>';
				var str = str + '<a href="#" name="operaC" class="easyui-linkbutton" title="确认" onclick="submitOrder('+ row.RowId + ')"></a>';					
			}
			return str;
		}
	},{
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		}, {
			title: '确认标记',
			field: 'Status',
			width : 70,
			align : 'center',
			styler : flagColor,
			fitColumns:true,
			formatter : function(value) {
				var status = "";
				if (value == 1) {
					status = "确认";
				} else{
					status = "未确认";
				}
				return status;
			}
		},{
			title: '单号',
			field: 'CSSDUPNo',
			width:110,
			fitColumns:true
		}, {
			title: '科室',
			field: 'CSSDUPLoc',
			width:120,
			fitColumns:true
		}, {
			title: '登记日期',
			field: 'CSSDUPDate',
			width:170,
			fitColumns:true
		}, {
			title: '登记人',
			field: 'Register',
			width:120,
			fitColumns:true
		}
	]];
	function flagColor(val, row, index) {
		if (val == '1') {
			return 'background:#15b398;color:white';
		}else{
			return 'background:#ff584c;color:white';
		}
	}

	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			QueryName: 'SelectAll',
			Params:Params
		},
		columns: MainCm,
		toolbar: '#UomTB',
		lazy:false,
		onLoadSuccess:function(data){ 
			$("a[name='operaM']").linkbutton({plain:true,iconCls:'icon-cancel'});  
			$("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-upload'});  
			$("a[name='operaR']").linkbutton({text:'',plain:true,iconCls:'icon-back'});
			if(data.rows.length>0&&isEmpty(GridListIndex)){
				$('#MainList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].RowId);
			}
			if(!isEmpty(GridListIndex)){
				$('#MainList').datagrid("selectRow", GridListIndex);
				FindItemByF(GridListIndexId);
			}
		},
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);
		}
		MainListGrid.commonClickCell(index,filed);
		}
	})
	
	//不合格原因下拉
	var ReasonData=$.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetCleanReason'	,
		ResultSetType:"array"
	},false);

	var ReasonBox = {
		type: 'combobox',
		options: {
			data:ReasonData,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.ReasonDescription = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	};
	

	//所属消毒包下拉列表
	var PkgData=$.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetAllPackageDesc'	,
		ResultSetType:"array"
	},false);
	var PkgBox = {
		type: 'combobox',
		options: {
			data:PkgData,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.PackageDescription = record.Description;
				PackageDrParams = record.RowId;
			},
			onShowPanel: function () {
				
				$(this).combobox('reload')
			}
		}
	};
	
	//器械下拉列表
	var ItemBox = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.ItmDescription = record.Description;
			},
			required: true,
			onShowPanel: function () {
				$(this).combobox('clear');
				var url = $URL+'?ClassName=web.CSSDHUI.Clean.CleanFailed&QueryName=GetPackageItem&ResultSetType=array&PackageDr='+PackageDrParams
				$(this).combobox('reload',url)
			}
		}
	};
	
	var SelectRow = function (row) {
		ItemListGrid.updateRow({
			index: ItemListGrid.editIndex,
			row: {
				PackageDr: PackageDrParams,
				ItmSpec: row.Spec,
				ItmDescription: row.Description,
				ItmId: row.RowId
			}
		});
		ItemListGrid.refreshRow();
		ItemListGrid.startEditingNext('pkgnum');
	}
	
	var PackageDrParams=""
	var HandlerParams = function () {
		var Obj = {
			PackageDr: PackageDrParams
		};
		return Obj;
	}
	
	var ItemCm = [[{
		field:'operate',title:'操作',align:'center',width:50,
		formatter:function(value, row, index){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.Status==0){
				var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="删除"  onclick="deleteItem('+row.RowId+')"></a>';
			}else{
				var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="删除" disabled onclick="deleteItem('+row.RowId+')"></a>';
			}
			return str;
	}},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '消毒包名称',
			field: 'PackageDr',
			width:150,
			formatter: CommonFormatter(PkgBox, 'PackageDr', 'PackageDescription'),
			editor: PkgBox
		},{
			title: '器械名称Id',
			field: 'ItmDescription',
			width:150,
			hidden: true
			//editor: PackageItemFailEditor(HandlerParams,SelectRow)
		},{
			title: '器械名称',
			field: 'ItmId',
			formatter: CommonFormatter(ItemBox, 'ItmId', 'ItmDescription'),
			editor: ItemBox,
			width:150
			//formatter: CommonFormatter(ItemBox, 'ItmId', 'ItmDescription'),
			//editor: ItemBox
			//editor: PackageItemFailEditor(HandlerParams,SelectRow)
		},{
			title: '数量',
			field: 'pkgnum',
			width:50,
			align: 'right',
			editor:{type:'numberbox',options:{required:true}}
		},{
			title: '规格',
			field: 'ItmSpec',
			width:150
		},{
			title: '不合格原因',
			field: 'ReasonDr',
			width:130,
			formatter: CommonFormatter(ReasonBox, 'ReasonDr', 'ReasonDescription'),
			editor: ReasonBox
		},{
			title: '分析',
			field: 'ReasonAnalysis',
			width:200,
			editor:{type:'validatebox'}
		},{
			title: '改进措施',
			field: 'Improve',
			width:200,
			editor:{type:'validatebox'}
		},{
			title: '是否启用',
			field: 'IsUsed',
			width:130,
			hidden: true
		}
	]]; 

	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			MethodName: 'SelectByF'
			},
			columns: ItemCm,
			pagination:true,
			onLoadSuccess:function(data){  
				$("a[name='opera']").linkbutton({plain:true,iconCls:'icon-cancel'});  
			},
			showAddSaveDelItems:true,
			saveDataFn:function(){//保存明细
				var Rows=ItemListGrid.getChangesData();
				if(isEmpty(Rows)) return ;
				var rowMain = $('#MainList').datagrid('getSelected');
				var flag = false
				$.each(Rows,function(index,item){
					if(item.pkgnum<=0){
						flag = true;
					}
				});
				if(flag){
					$UI.msg('alert',"请输入合适的数量");
					return ;
				}
				$.cm({
					ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
					MethodName: 'jsSaveSter',
					Params: JSON.stringify(Rows),
					MainId:rowMain.RowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ItemListGrid.reload();
					}else{
						$UI.msg('alert',jsonData.msg);
					}
				});
			},
			beforeAddFn:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.Status==1){
					return false;
				}
			},
			onBeforeEdit:function(){
				$("a[name='opera']").linkbutton({plain:true,iconCls:'icon-cancel'});
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.Status==1){
					return false;
				}
			},
			onBeforeCellEdit:function(){
				var rowMain = $('#ItemList').datagrid('getSelected');
				if(rowMain.IsUsed.split("^")[0]=="N"){
					$UI.msg('alert','该明细的消毒包已禁用!');
					return false;
				}
				if(rowMain.IsUsed.split("^")[1]=="N"){
					$UI.msg('alert','该明细的器械已禁用!');
					return false;
				}
				if(rowMain.IsUsed.split("^")[2]=="N"){
					$UI.msg('alert','该明细的不合格原因已禁用!');
					return false;
				}
				
			},
			beforeDelFn:function(){
				var ItemRowId="";
				var row = $('#ItemList').datagrid('getSelected');
				if(!isEmpty(row)){
					ItemRowId = row.RowId;
				}else{
					$UI.msg('alert','请选择要删除的单据!');
					return false;
				}
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.Status==1){
					$UI.msg('alert','已确认单据不能删除明细!');
					return false;
				}
				deleteItem(ItemRowId);	
			},
			onClickCell: function(index, field, value){
				ItemListGrid.commonClickCell(index, field);
			}
	});	
	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			QueryName: 'SelectByF',
			MainId:Id
		});
	}
	function FindNew(Id){
		MainListGrid.load({
		ClassName: 'web.CSSDHUI.Clean.CleanFailed',
		QueryName: 'FindNew',
		ID:Id
		});
	}
}
$(init);

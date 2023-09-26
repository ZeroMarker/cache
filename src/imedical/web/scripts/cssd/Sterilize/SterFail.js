//删除明细
function deleteItem(ItemRowId){
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y"&&!isEmpty(ItemRowId)) {
		$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){  
			if(data){   
				$.cm({
					ClassName:'web.CSSDHUI.PackageSterilize.SterilizeFailItem',
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
				ClassName:'web.CSSDHUI.PackageSterilize.SterilizeFail',
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
						GridListIndexId=item.CSSDSPNo;
					}
				});
				$.cm({
					ClassName:'web.CSSDHUI.PackageSterilize.SterilizeFail',
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
		})
		$.cm({
			ClassName:'web.CSSDHUI.PackageSterilize.SterilizeFail',
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
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFail',
			QueryName: 'SelectAll',
			parame: Params
		});   
	}
	//保存单据
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			saveMast()
		}
	});
	function saveMast(){
		var Params = JSON.stringify($UI.loopBlock('MainCondition'));
		GridListIndex = "";
		GridListIndexId = ""
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFail',
			MethodName: 'GetItemCount',
			Params : Params
		},function(count){
			if(count==0){
				$.messager.confirm("操作提示","已存在一个没有明细的空单据,是否仍需要新建?",function(data){
					if(data){
						CreatMast()
					}
				})
			}else{
				CreatMast()
			}
		});
	}
	function CreatMast(){
		var MainObj = $UI.loopBlock('#MainCondition');
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFail',
			MethodName: 'jsSave',
			Params: JSON.stringify(MainObj)
		},function(jsonData){
			if(!isEmpty(jsonData.rowid)){
				$UI.msg('success',jsonData.msg);
				FindNew(jsonData.rowid);
			}
		});
	}
	function FindNew(ID){
		MainListGrid.load({
		ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFail',
		QueryName: 'FindNew',
		ID: ID
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
			FEndD:DefaultEdDate
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
		},  {
			title: '确认标记',
			field: 'Status',
			width : 70,
			align : 'center',
			styler : flagColor,
			fitColumns:true,
			formatter : function(value) {
				var status = "";
				if (value == 0) {
					status = "未确认";
				} else{
					status = "确认";
				}
				return status;
			}
		},{
			title: '单号',
			field: 'CSSDSPNo',
			width:150,
			fitColumns:true
		}, {
			title: '科室',
			field: 'CSSDSPLoc',
			width:150,
			fitColumns:true
		}, {
			title: '登记日期',
			field: 'CSSDSPDate',
			width:150,
			fitColumns:true
		}, {
			title: '登记人',
			field: 'Register',
			width:150,
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
	var Params=JSON.stringify($UI.loopBlock('#MainCondition')); 
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFail',
			QueryName: 'SelectAll'  ,
			parame: Params
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
		MainListGrid.commonClickCell(index,filed)
		}
	})
	//不合格原因下拉
	var packData=$.cm({
			ClassName: 'web.CSSDHUI.Common.Dicts',
			QueryName: 'GetRetReason'   ,
			ResultSetType:"array"
	},false);
	var ReasonBox = {
		type: 'combobox',
		options: {
			data:packData,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.ReasonName = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	};
	
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
			title: '条码',
			field: 'pkgnum',
			width:200,
			editor:{type:'validatebox',options:{required:true}}
		},{
			title: '不合格原因',
			field: 'ReasonDr',
			width:179,
			formatter: CommonFormatter(ReasonBox, 'ReasonDr', 'ReasonName'),
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
			field: 'NotUseFlag',
			width:130,
			hidden: true
		}
	]]; 

	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFailItem',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			pagination:false,
			onLoadSuccess:function(data){ 
				$("a[name='opera']").linkbutton({plain:true,iconCls:'icon-cancel'});  
			},
			showAddSaveDelItems: true,
			saveDataFn:function(){//保存明细
				var Rows=ItemListGrid.getChangesData();
				if(isEmpty(Rows)) return ;
				var rowMain = $('#MainList').datagrid('getSelected');
				$.cm({
					ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFailItem',
					MethodName: 'jsSaveSter',
					Params: JSON.stringify(Rows),
					MainId:rowMain.RowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ItemListGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			},
			beforeAddFn:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.Status==1){
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
			onBeforeEdit:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.Status==1){
					return false;
				}	
			},
			onBeforeCellEdit: function(index, field){
            	var RowData = $(this).datagrid('getRows')[index];
            	if(RowData['NotUseFlag']=="N"){
            		$UI.msg('alert','该器械已被停用，不可修改!');
               		return false;
            	}
        	},
			onClickCell: function(index, field, value){
				ItemListGrid.commonClickCell(index, field);
			}
	}); 
	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFailItem',
			QueryName: 'SelectByF',
			MainId:Id
		});
	}
}
$(init);

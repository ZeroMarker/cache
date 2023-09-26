//删除明细
function deleteItem(ItemRowId){
    var requiredDelete = RequiredDelete();
    if (requiredDelete == "Y"&&!isEmpty(ItemRowId)) {
        $.messager.confirm("操作提示","您确定要执行操作吗？",function(data){  
            if(data){   
                $.cm({
                    ClassName:'web.CSSDHUI.Apply.PackageApplyItm',
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
    if (requiredDelete != "Y") {
		$.cm({
					ClassName : 'web.CSSDHUI.Apply.PackageApplyItm',
					MethodName : 'jsDelete',
					rowId : ItemRowId
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						$('#ItemList').datagrid('reload');
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
	}
}  
// 删除主表单据
// 第一步:盘点单据是否可以删除
// 第二步删除主表单据
// 第三步删除子表数据 (包括修改打包表数据)目前的策略是:有明细不允许删除
function deleteMain(mainRowId){
    $.messager.confirm("操作提示","您确定要执行操作吗？",function(data){  
        if(data){   
            $.cm({
                ClassName:'web.CSSDHUI.Apply.PackageApply',
                MethodName:'jsDelete',
                mainRowId:mainRowId
            },function(jsonData){       
                if(jsonData.success==0){
                    $UI.msg('success',jsonData.msg);
                    $('#MainList').datagrid('reload');
                }else{
                    $UI.msg('alert',jsonData.msg);
                }
            });
        }
    });
}
//提交
var GridListIndex = "";
var GridListIndexId = ""
function submitOrder(mainRowId,ReqType){
    if (isEmpty(mainRowId)) {
            $UI.msg('alert','请选择要提交的单据!');
            return false;
        }
        var autAuditAfterSub = AutAuditAfterSub();
        var Params = JSON.stringify(addSessionParams({autAuditAfterSub:autAuditAfterSub}));
        var Rows = $('#MainList').datagrid("getRows");
        $.each(Rows,function(index,item){
			if(item.RowId==mainRowId){
				GridListIndex=index;
				GridListIndexId=mainRowId;
			}
		});
        $.cm({
            ClassName:'web.CSSDHUI.Apply.PackageApply',
            MethodName:'jsSubmitOrder',
            mainRowId:mainRowId,
			Params:Params
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success',jsonData.msg);
                $('#MainList').datagrid('reload');
                $('#ItemList').datagrid('reload');
            }else{
                $UI.msg('alert',jsonData.msg);
            }
        });
        
}
//撤销
function cancelOrder(mainRowId){
    if (isEmpty(mainRowId)) {
            $UI.msg('alert','请选择要撤销的单据!');
            return false;
        }
    var requiredCancel = RequiredCancel();
    if (requiredCancel == "Y") {
        $.messager.confirm("操作提示","您确定要执行操作吗？",function(data){  
            if(data){
            	var Rows = $('#MainList').datagrid("getRows");
				$.each(Rows,function(index,item){
					if(item.RowId==mainRowId){
						GridListIndex=index;
						GridListIndexId=mainRowId;
					}
				});
                $.cm({
                    ClassName:'web.CSSDHUI.Apply.PackageApply',
                    MethodName:'jsCancelOrder',
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
    if (requiredCancel != "Y") {
    	$.cm({
        	ClassName:'web.CSSDHUI.Apply.PackageApply',
        	MethodName:'jsCancelOrder',
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
}
//普通包接收
	function ReceOrder(mainRowId){
		if (isEmpty(mainRowId)) {
		    $UI.msg('alert','请选择要接收的单据!');
		    return false;
		}
		var Rows = $('#MainList').datagrid("getRows");
        $.each(Rows,function(index,item){
			if(item.RowId==mainRowId){
				GridListIndex=index;
				GridListIndexId=mainRowId;
			}
		});
		$.cm({
			ClassName:'web.CSSDHUI.Apply.PackageApply',
			MethodName:'jsReceOrder',
			mainRowId:mainRowId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				$('#MainList').datagrid('reload');
				$('#ItemList').datagrid('loadData',[]);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
}

var init = function() {
    var MainReqFlage="";
    //请求科室
    var ReqLocParams=JSON.stringify(addSessionParams({Type:"ReqLoc"}));
    var ReqLocBox = $HUI.combobox('#ReqLoc', {
        url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
        valueField: 'RowId',
        textField: 'Description',
        onLoadSuccess: function (data) {   //默认登录科室
            $("#ReqLoc").combobox('setValue',gLocId);
        }
    });
    //供应科室
    var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
    var SupLocBox = $HUI.combobox('#SupLoc', {
        url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
        valueField: 'RowId',
        textField: 'Description',
        onLoadSuccess: function (data) {   //默认第一个值
            $("#SupLoc").combobox('setValue',data[0].RowId);
        }
    });
    
    function Clear(){
        $UI.clear(ItemListGrid);
    }
    ////===============================初始化组件end=============================
    $UI.linkbutton('#AddBT',{ 
		onClick:function(){
			MainListGrid.commonAddRow();
			FindItemByF("");
		}
	});
	//保存单据
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			saveMast();
			var Rows=MainListGrid.getChangesData();
			if(!isEmpty(Rows)){
				Clear();
			}
		}
	});
	function saveMast(){
		var Rows=MainListGrid.getChangesData();
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有需要保存的信息!');
			return;
		}
		var GridListIndex = "";
		var GridListIndexId = "";
		var Obj = $UI.loopBlock('#MainCondition');
		var fromLoc = Obj.FSupLoc
		var MainObj = $('#MainList').datagrid('getSelected');
		if(!isEmpty(MainObj)){
			if((MainObj.ReqLoc==MainObj.SupLoc)&&((!isEmpty(MainObj.ReqLoc))||(!isEmpty(MainObj.SupLoc)))){
				$UI.msg('alert',"请领科室和供应科室不能相同");
				$('#MainList').datagrid('reload');
				return;
			}
			if((MainObj.ReqFlag!="未提交")&&!isEmpty(MainObj.ReqFlag)){
				$UI.msg('alert',"单据已提交无法修改");
				return;
			}
		}
		$.cm({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			MethodName: 'jsSave',
			Params: JSON.stringify(Rows),
			fromLoc: fromLoc
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				FindNew(jsonData.rowid);
			}else{
				$UI.msg('alert',jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function(){
			var MainRowId="";
			var rowMain = $('#MainList').datagrid('getSelected');
			if(!isEmpty(rowMain)){
				MainRowId = rowMain.RowId;
			}
			
			if(isEmpty(MainRowId)&&!isEmpty(rowMain)){
				MainListGrid.commonDeleteRow();
				return false;
			}
			if (isEmpty(MainRowId)) {
					$UI.msg('alert','请选择要删除的单据!');
				 	return false;
			}
			deleteMain(MainRowId);
		}
	});
	//归还
	$UI.linkbutton('#ReturnBT',{ 
		onClick:function(){
			var rowMain = $('#MainList').datagrid('getSelected');
			var ReqType = rowMain.ReqType;
			var mainRowId = rowMain.RowId;
			var rows = MainListGrid.getRows();
			var row = rows[MainListGrid.editIndex];
			var index = MainListGrid.getRowIndex(row);
			GridListIndex=index;
			GridListIndexId=mainRowId;
			if(ReqType==1){
				$.cm({
					ClassName: 'web.CSSDHUI.Apply.PackageApply',
					MethodName: 'jsReturn',
					mainRowId: mainRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#MainList').datagrid('reload');
					}else{
						$UI.msg('alert',jsonData.msg);
					}
				});
			}else{
				$UI.msg('alert','只有借包单能归还');
				return false;
			}
		}
	});
	//保存模板
	$UI.linkbutton('#SaveMoudleBT',{
		onClick:function(){		
			var MainObj = $('#MainList').datagrid('getChecked');
			var MoudleObj = $('#MainList').datagrid('getSelected');
			if(isEmpty(MainObj)){
				$UI.msg('alert',"请选择要设为模板的单据！");
				return;
			}
			if(MainObj.length>1){
				$UI.msg('alert',"请选择一条数据设为模板的单据！");
				return;
			}			
			$.cm({
				ClassName: 'web.CSSDHUI.Apply.PackageApply',
				MethodName: 'MoudleSave',
				MainId: MoudleObj.RowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#MainList').datagrid('reload');
				}else{
					$UI.msg('alert',jsonData.msg);
				}
			});
		}
	});
	//选取模板
	$UI.linkbutton('#ApplyMoudleBT',{ 
		onClick:function(){
			ApplyMoudle(function(){MainListGrid.reload();});
		}
	});
	//打印单据
	$UI.linkbutton('#Print', {
		onClick: function () {
			var Detail = MainListGrid.getChecked();
			var DetailParams = JSON.stringify(Detail);
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择需要打印单据');
			}
			if (!isEmpty(Detail)) {
				$.each(Detail, function (index, item) {
					PrintINApplyReq(item.RowId);
				});
			}
			
		}
	});
	
	var Dafult={
		FStartDate:DefaultStDate(),
		FEndDate:DefaultEdDate
	}
	$UI.fillBlock('#MainCondition',Dafult)
	
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			query();
			Clear();
		}
	});
	function query(){ 
		var Params = JSON.stringify($UI.loopBlock('#CondTB'));
		var Flag="";
		var GridListIndex = "";
		var GridListIndexId = ""
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll'  ,
			Params: Params,
			Flag:Flag
		});
	}
	
	var ReqTypeData = [{
			"RowId":"0",
			"Description":"请领单"
		},{	
			"RowId":"1",
			"Description":"借包单"
		},{	
			"RowId":"2",
			"Description":"敷料申请单"
		},{	
			"RowId":"3",
			"Description":"手术申请单"
		}]
	var ReqTypeCombox= {
		type: 'combobox',
		options: {
			data:ReqTypeData,
			valueField: 'RowId',
			textField: 'Description'
	    }
	};
	var ReqLevelData = [{
			"RowId":"0",
			"Description":"一般"
		},{
			"RowId":"1",
			"Description":"紧急"
		}]
	var ReqLevelCombox= {
		type: 'combobox',
		options: {
			data:ReqLevelData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"ReqLoc"}));
	var ReqLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onLoadSuccess: function (data) {
				//$(this).combobox('setValue',gLocId);
			},
			onSelect: function (record) {
				var rows = MainListGrid.getRows();
				var row = rows[MainListGrid.editIndex];
				row.ReqLocDesc = record.Description;
			}
		}
	};
	
	var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onLoadSuccess: function (data) {
				//$(this).combobox('setValue',data[0].RowId);
			},
			onSelect: function (record) {
				var rows = MainListGrid.getRows();
				var row = rows[MainListGrid.editIndex];
				row.SupLocDesc = record.Description;
			}
		}
	};
	//上面输入框的回车事件处理 end
	var MainCm = [[{
				title : '',
				field : 'ck',
				checkbox : true,
				width : 50
			}, {
				field : 'operate',
				title : '操作',
				align : 'center',
				width : 100,
				formatter : function(value, row, index) {
					if (row.ReqFlag != "未提交") {
						var str = '<a href="#" name="operaM" class="easyui-linkbutton" disabled title="删除" onclick="deleteMain('
								+ row.RowId + ')"></a>';
						var str = str
								+ '<a href="#" name="operaR" class="easyui-linkbutton" title="撤销" onclick="cancelOrder('
								+ row.RowId + ')"></a>';
					} else {
						var str = '<a href="#" name="operaM" class="easyui-linkbutton" title="删除" onclick="deleteMain('
								+ row.RowId + ')"></a>';
						var str = str
								+ '<a href="#" name="operaC" class="easyui-linkbutton" title="提交" onclick="submitOrder('
								+ row.RowId + ',' + row.ReqType + ')"></a>';
					}
					if((row.ReqFlag != "接收")&&(row.ReqFlag != "归还")){
						var str = str + '<a href="#" name="operaD" class="easyui-linkbutton" title="接收" onclick="ReceOrder('+row.RowId+')"></a>';
					}else {
						var str = str + '<a href="#" name="operaY" disabled class="easyui-linkbutton" title="已接收"></a>';
					}
					return str;
				}
			}, {
				title : 'RowId',
				field : 'RowId',
				width : 50,
				hidden : true
			}, {
				title : '申请科室',
				field : 'LocRowId',
				width : 100,
				formatter : CommonFormatter(ReqLocCombox, 'LocRowId',
						'ReqLocDesc'),
				editor : ReqLocCombox
			}, {
				title : '单号',
				field : 'No',
				width : 100
			}, {
				title : '单据状态',
				field : 'ReqFlag',
				width : 100
			}, {
				title : '提交时间',
				field : 'commitDate',
				width : 150
			}, {
				title : '提交人',
				field : 'commitUser',
				width : 100
			}, {
				title : '单据类型',
				field : 'ReqType',
				width : 100,
				formatter : CommonFormatter(ReqTypeCombox, 'ReqType',
						'ReqTypeDesc'),
				editor : ReqTypeCombox
			}, {
				title : '紧急程度',
				field : 'ReqLevel',
				width : 100,
				formatter : CommonFormatter(ReqLevelCombox, 'ReqLevel',
						'ReqLevelDesc'),
				editor : ReqLevelCombox
			}, {
				title : '供应科室',
				field : 'SupRowId',
				width : 100,
				formatter : CommonFormatter(SupLocCombox, 'SupRowId',
						'SupLocDesc'),
				editor : SupLocCombox
			}, {
				title : '需求日期',
				field : 'ReqDate',
				width : 100,
				editor : {
					type : 'datetimebox'
				}
			}]];
	$("#ReqLoc").combobox('setValue',gLocId);
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll'  ,
			Params:JSON.stringify($UI.loopBlock('#CondTB'))
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
        selectOnCheck: false,
		onLoadSuccess:function(data){  
			$("a[name='operaM']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
			$("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-upload'});  
			$("a[name='operaR']").linkbutton({text:'',plain:true,iconCls:'icon-back'});
			$("a[name='operaD']").linkbutton({text:'',plain:true,iconCls:'icon-download'});
	        $("a[name='operaY']").linkbutton({text:'',plain:true,iconCls:'icon-ok'});
			if(data.rows.length>0&&isEmpty(GridListIndex)){
				$('#MainList').datagrid("selectRow", 0)
				var Row=MainListGrid.getRows()[0]
				var Id = Row.RowId;
				FindItemByF(Id);
		 	}
			if(!isEmpty(GridListIndex)){
				$('#MainList').datagrid("selectRow", GridListIndex);
				FindItemByF(GridListIndexId);
			}
		},
		onClickCell: function(index, filed ,value){
//			var rowMain = $('#MainList').datagrid('getSelected');
//			if(!isEmpty(rowMain)){
//				if(rowMain.ReqFlag!="未提交") return false;
//			}
			var Row=MainListGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);
			}
			MainListGrid.commonClickCell(index,filed)
		},
		onAfterEdit: function(rowIndex, rowData){
			if(!isEmpty(rowData.RowId)){
				$("a[name='operaM']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
				$("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-upload'});  
				$("a[name='operaR']").linkbutton({text:'',plain:true,iconCls:'icon-back'});
				$("a[name='operaD']").linkbutton({text:'',plain:true,iconCls:'icon-download'});
	        	$("a[name='operaY']").linkbutton({text:'',plain:true,iconCls:'icon-ok'});
			}
		}
	})
	
	//消毒包下拉列表
	var PackageBox = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect: function (record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.PackageName = record.Description;
				var index = ItemListGrid.getRowIndex(row);
				for(var i=0;i<rows.length-1;i++){
					if(rows[i].PackageName==record.Description&&(i!=index)){
						$UI.msg('alert',"包名重复!");
						$(this).combobox('clear');
					}
				}
			},
			onShowPanel: function () {
				var url = $(this).combobox('options').url;
				var rowMain = $('#MainList').datagrid('getSelected');
				var ReqType = rowMain.ReqType;
				if (!url){
					if(ReqType==2){
						var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial='+7
					}else if(ReqType==3){
						var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial='+1
					}else{
						var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial='+2+','+10
					}
					$(this).combobox('reload',url);
				}
			}
		}
	};
	var ItemCm = [[
		{field:'operate',title:'操作',align:'center',width:80,
		formatter:function(value, row, index){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.ReqFlag!="未提交"){
				var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="删除" onclick="deleteItem('+row.RowId+')"></a>';
			}else{
				var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="删除" onclick="deleteItem('+row.RowId+')"></a>';
			}
			return str;
	}},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title:'',
			id:"selectAll",
			field:'ck',
			checkbox:true,
			hidden: true
		},{
			title: '消毒包名称',
			field: 'PackageDR',
			width:200,
			formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName'),
			editor: PackageBox
		},{
			title: '请领数量',
			field: 'Qty',
			width:100,
			align: 'right',
			editor:{type:'numberbox',options:{required:true}}
		},{
			title: '备注',
			field: 'Remark',
			width:110,
			editor:{type:'validatebox'}
		},{
			title: '反馈信息',
			field: 'RemarkInfo',
			width:110
		}
	]]; 

	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			MethodName: 'SelectByF'
		},
		columns: ItemCm,
		pagination:false,
		onLoadSuccess:function(data){
			$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
		},
		showAddSaveDelItems: true,
		saveDataFn:function(){//保存明细
			var Rows=ItemListGrid.getChangesData();
			if(isEmpty(Rows)){
				//$UI.msg('alert','没有需要保存的信息!');
				return;
			}
			var rowMain = $('#MainList').datagrid('getSelected');
			$.cm({
				ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
				MethodName: 'jsSave',
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
		beforeDelFn:function(){
			var ItemRowId="";
			var rowMain = $('#ItemList').datagrid('getSelected');
			if(!isEmpty(rowMain)){
				ItemRowId = rowMain.RowId;
			}
			if (isEmpty(rowMain)) {
				$UI.msg('alert','请选择要删除的单据!');
				return false;
			}
			var MainObj = $('#MainList').datagrid('getSelected');
			if(MainObj.ReqFlag == "未提交"){	
				deleteItem(ItemRowId);
			}else{
				$UI.msg('alert',"单据已提交不能删除明细!");
			}
		},
		onClickCell: function(index, field, value){
			ItemListGrid.commonClickCell(index, field);
		},
		beforeAddFn:function(){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.ReqFlag!="未提交") return false;
		},
		onBeforeEdit:function(){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.ReqFlag!="未提交") return false;
		},onAfterEdit:function(rowIndex,rowData){
			if(!isEmpty(rowData.RowId)){
				$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
			}
		}
	}); 
	
	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			QueryName: 'SelectByF',
			ApplyId:Id
		});
	}
	
	function FindNew(Id){
		MainListGrid.load({
		ClassName: 'web.CSSDHUI.Apply.PackageApply',
		QueryName: 'FindNew',
		ID:Id
		});
	}
}
$(init);

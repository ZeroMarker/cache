//删除明细
function deleteItem(ItemRowId){
	if (isEmpty(ItemRowId)) {
			//$UI.msg('alert','请选择要删除的单据!');
			return false;
		}
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y") {
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){	
			if(data){
				$.cm({
					ClassName:'web.CSSDHUI.PackageDisp.DispItm',
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
			ClassName : 'web.CSSDHUI.PackageDisp.DispItm',
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
//删除发放标签明细why0217
function deleteDispLabelItem(ItemRowId){
	if (isEmpty(ItemRowId)) {
			//$UI.msg('alert','请选择要删除的单据!');
			return false;
		}
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y") {
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){	
			if(data){
				$.cm({
					ClassName:'web.CSSDHUI.PackageDisp.DispDetail',
					MethodName:'jsDelete',
					rowId:ItemRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#ItemList').datagrid('reload');
						$('#ItemSList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		});
	}
	if (requiredDelete != "Y") {
		$.cm({
			ClassName : 'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName : 'jsDelete',
			rowId : ItemRowId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$('#ItemList').datagrid('reload');
				$('#ItemSList').datagrid('reload');
			} else {
				$UI.msg('error', jsonData.msg);
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
	$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){	
		if(data){	
			$.cm({
				ClassName:'web.CSSDHUI.PackageDisp.Disp',
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
//提交
function submitOrder(mainRowId){
	if (isEmpty(mainRowId)) {
			$UI.msg('alert','请选择要提交的单据!');
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
			ClassName:'web.CSSDHUI.PackageDisp.Disp',
			MethodName:'jsSubmitOrder',
			mainRowId:mainRowId,
			gUser:gUserId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				$('#MainList').datagrid('reload');
			}else{
				$UI.msg('error',jsonData.msg);
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
		$.messager.confirm("操作提示","您确定要执行撤销操作吗？",function(data){	
			if(data){
				var Rows = $('#MainList').datagrid("getRows");
				$.each(Rows,function(index,item){
					if(item.RowId==mainRowId){
						GridListIndex=index;
						GridListIndexId=mainRowId;
					}
				});
				$.cm({
					ClassName:'web.CSSDHUI.PackageDisp.Disp',
					MethodName:'jsCancelOrder',
					mainRowId:mainRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#MainList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		});
	}
}
///======================================事件处理end=======================
var init = function() {
	var MainReqFlage="";
	//发放科室
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认登录科室
			$("#ReqLoc").combobox('setValue',gLocId);
		}
	});
	//接收科室
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//楼号
	var FloorBox = $HUI.combobox('#FloorCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFloorCode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			//$("#FloorCode").combobox('setValue',data[0].RowId);
		},
		onSelect: function (row) {
                    if (row != null) {
						//alert(row.RowId);
                        $HUI.combobox('#LineCode', {
                          url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLineCode&ResultSetType=array&FloorCode='+row.RowId,
                          valueField: 'RowId',
                          textField: 'Description',
						  	onLoadSuccess: function (data) {   //默认第一个值
								$("#LineCode").combobox('setValue',data[0].RowId);
							}
                      }); 
                    }
                }

	});
	//发放人
	$("#toUser").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#toUser").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetPersonInfo',v);
			if(Ret.split('^')[0]=="Y"){
				$("#toUser").val(Ret.split('^')[2]);
				$("#toUserDr").val(Ret.split('^')[1]);
				$("#SterUser").focus();
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#SterUser").val("");
				$("#SterUser").focus();
			}
		}
	});
	//消毒包
	var typeDetial="2"
	var PackageBox = $HUI.combobox('#PackageName', {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=' + typeDetial,
			valueField: 'RowId',
			textField: 'Description'
		});
	
	var Dafult={
		FStartDate:DefaultStDate(),
		FEndDate:DefaultEdDate
	}
	$UI.fillBlock('#MainCondition',Dafult)
	
	function Clear(){
		//$UI.clearBlock('#MainCondition');
		SupLocBox.reload();
		//$UI.fillBlock('#MainCondition',Dafult);
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
	}
	////===============================初始化组件end=============================
	
	//生成请领单
	$UI.linkbutton('#CreateBT',{ 
		onClick:function(){
			SelReq(function(){MainListGrid.reload();});
		}
	});
	//通过借包单生成发放单
	$UI.linkbutton('#CreateBTApply',{ 
		onClick:function(){
			SelReqApply(function(){MainListGrid.reload();});
		}
	});
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			query();
			Clear();
		}
	});
	//扫码动作自动提交
	$("#BarCode").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#BarCode").val();
			var row = $('#MainList').datagrid('getSelected');
			if(isEmpty(row)){
				$UI.msg('alert','请选择需要添加的发放单据!');
				return;
			}
			if(isEmpty(row.RowId)){
				$UI.msg('alert','参数错误!');
				return;
			}
			if(isEmpty(v)){
				$UI.msg('alert','条码录入为空!');
				return;
			}
			//alert(row.RowId);
			var Rows = $('#MainList').datagrid("getRows");
				$.each(Rows,function(index,item){
					if(item.RowId==row.RowId){
						GridListIndex=index;
						GridListIndexId=row.RowId;
					}
			});
			$.cm({
				ClassName:'web.CSSDHUI.PackageDisp.DispDetail',
				MethodName:'jsSaveDetail',
				mainId:row.RowId,
				barCode:v,
				gUser:gUserId
			},function(jsonData){
				if(jsonData.success==0){
					//playSuccess();
					$UI.msg('success',jsonData.msg);
					ItemListGrid.reload();
					FindItemSByF(jsonData.rowid);
					IsCommit(row.RowId,gUserId);
				}else{
					//playWarn();
					$UI.msg('error',jsonData.msg);
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	function IsCommit(mainid,userdr){
		$.cm({
			ClassName:'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName:'IsCommit',
			rowId:mainid,
			guser:userdr
			},function(jsonData){
				if(jsonData==0)
				{
					submitOrder(mainid);
				}
			});
		}
	function query(){
		$UI.clear(ItemListGrid);
		var Params = JSON.stringify($UI.loopBlock('#CondTB'));
		var GridListIndex = "";
		var GridListIndexId = "";
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.Disp',
			QueryName: 'SelectAll',
			//sort:'RowId',
			//order:'Desc',
			Params: Params
		});
	}
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
					PrintINDispReq(item.RowId);
				});
			}
			
		}
	});
	//批量提交
	$UI.linkbutton('#submitAll', {
		onClick: function () {
			$.messager.confirm("操作提示","您确定要执行批量提交操作吗？",function(data){	
			if(data){
				var Detail = MainListGrid.getChecked();
				var DetailParams = JSON.stringify(Detail);
				if (isEmpty(Detail)) {
					$UI.msg('alert', '请选择需要提交单据');
					return;
				}
				$.cm({
					ClassName:'web.CSSDHUI.PackageDisp.Disp',
					MethodName:'jsSubmitAll',
					Params:DetailParams,
					gUser:gUserId	
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#MainList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
					});
				}
			});
		}
	});
	//上面输入框的回车事件处理 end
	var MainCm = [[{
				title : '',
				field : 'ck',
				checkbox : true,
				width : 50
			},{
		field:'operate',
		title:'操作',
		align:'center',
		width:'100',
		formatter:function(value, row, index){
			if(row.ComplateFlag=="Y"){
				var str = '<a href="#" name="operaM" class="easyui-linkbutton" disabled title="删除" onclick="deleteMain('+row.RowId+')"></a>';
				var str =str+ '<a href="#" name="operaR" class="easyui-linkbutton" title="撤销" onclick="cancelOrder('+row.RowId+')"></a>';
			}
			else {
				var str = '<a href="#" name="operaM" class="easyui-linkbutton" title="删除" onclick="deleteMain('+row.RowId+')"></a>';
				var str =str+ '<a href="#" name="operaC" class="easyui-linkbutton" title="提交" onclick="submitOrder('+row.RowId+')"></a>';
			}
			return str;
		}
	},{
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		}, {
			title: '单号',
			align:'left',
			field: 'No',
			width:150,
			fitColumns:true
		}, {
			title: '发放科室',
			align:'left',
			field: 'FroLocDesc',
			width:150,
			fitColumns:true
		}, {
			title:'发放人',
			align:'left',
			field:'FUserDesc',
			width:150,
			fitColumns:true
		},{
			title:'发放日期',
			align:'left',
			field:'FDate',
			width:150,
			fitColumns:true
		}, {
			title: '接收科室',
			align:'left',
			field: 'TLocDesc',
			width:150,
			fitColumns:true
		}, {
			title: '单据类型',
			align:'left',
			field: 'Type',
			width:150,
			fitColumns:true
		},{
			title:'提交人',
			align:'left',
			field:'DispUserDesc',
			width:150,
			fitColumns:true
		}, {
			title: '提交时间',
			align:'left',
			field: 'ChkDate',
			width:150,
			fitColumns:true
		},{
			title: '完成标志',
			align:'left',
			field: 'ComplateFlag',
			width:100,
			fitColumns:true
		}
	]];

	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.Disp',
			QueryName: 'SelectAll',
			Params:JSON.stringify($UI.loopBlock('#CondTB'))
			//sort:'RowId',
			//order:'desc'
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
		selectOnCheck: false,
		//singleSelect: false,
		onLoadSuccess:function(data){  
			$("a[name='operaM']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
			$("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-upload'});  
			$("a[name='operaR']").linkbutton({text:'',plain:true,iconCls:'icon-back'});  
			if(data.rows.length>0&&isEmpty(GridListIndex)){
				$('#MainList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].RowId);
			}
			if(!isEmpty(GridListIndex)){
				$('#MainList').datagrid("selectRow", GridListIndex);
				FindItemSByF(GridListIndexId);
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
	
//========================================消毒包明细====start==============	
	//消毒包下拉列表
	var packData=$.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
			QueryName: 'GetPackage'	,
			ResultSetType:"array",
			typeDetial: "2,7"
	},false);
	var PackageBox = {
		type: 'combobox',
		options: {
			data:packData,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect: function (record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.PackageName = record.Description;
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
				if(rowMain.ComplateFlag=="Y"){
					var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="删除" onclick="deleteItem('+row.RowId+')"></a>';
				}else{
					var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="删除" onclick="deleteItem('+row.RowId+')"></a>';
				}
				return str;
			}
		},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: 'CallBackDetailDr',
			field: 'CallBackDetailDr',
			width:100,
			hidden: true
		},{
			title: '消毒包名称',
			align:'left',
			field: 'PackageDR',
			width:140,
			formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName'),
			editor: PackageBox
		},{
			title: '待发放数量',
			align:'right',
			field: 'Qty',
			width:100,
			editor:{type:'numberbox',options:{required:true}}
		} ,
		{
			title: '发放数量',
			align:'right',
			field: 'DispQty',
			width:100
		}
	]]; 
	 $UI.linkbutton('#AddBT',{ 
		onClick:function(){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.ComplateFlag=="Y") return false;
			ItemListGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function(){
			var ItemRowId="";
			var rowMain = $('#ItemList').datagrid('getSelected');
			if(!isEmpty(rowMain)){
				ItemRowId = rowMain.RowId;
			}
			if(isEmpty(ItemRowId)&&!isEmpty(rowMain)){
				ItemListGrid.commonDeleteRow();
				return false;
			}
			if (isEmpty(rowMain)) {
				$UI.msg('alert','请选择要删除的单据!');
				 return false;
			}
			var MainObj = $('#MainList').datagrid('getSelected');
			if(MainObj.ComplateFlag != "Y"){	
				deleteItem(ItemRowId);
			}else{
				$UI.msg('alert',"单据已提交不能删除明细!");
			}
		}
	});
	//保存单据
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.ComplateFlag=="Y") return false;
			var Rows=ItemListGrid.getChangesData();	
			if(isEmpty(Rows)){
				//$UI.msg('alert','没有需要保存的信息!');
				return;
			}
			var rowMain = $('#MainList').datagrid('getSelected');
			$.cm({
				ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
				MethodName: 'jsSave',
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
		}
	});
	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			toolbar:'#Itembr',
			pagination:false,
			singleSelect:false,
			onLoadSuccess:function(data){  
				$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
				if(data.rows.length>0){
					$('#ItemList').datagrid("selectRow", 0)
						$("#BarCode").val("").focus();
						
				}
			},
			//showAddSaveDelItems: true,
			//toolbar:'#itmtd',
			//showAddSaveItems: true,
			//showSaveItems:true,
			/* saveDataFn:function(){//保存明细
				var Rows=ItemListGrid.getChangesData();	
				if(isEmpty(Rows)){
					//$UI.msg('alert','没有需要保存的信息!');
					return;
				}
				var rowMain = $('#MainList').datagrid('getSelected');
				$.cm({
					ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
					MethodName: 'jsSave',
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
			}, */
			/* beforeDelFn:function(){
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
				if(MainObj.ComplateFlag != "Y"){	
				deleteItem(ItemRowId);
				}else{
					$UI.msg('alert',"单据已提交不能删除明细!");
				}
			}, */
			onClickCell: function(index, field, value){
				var Row=ItemListGrid.getRows()[index]
				var Id = Row.PackageDR;
				var DispId = Row.RowId;
				if(!isEmpty(DispId)){
					FindItemSByF(DispId);
				}	
				ItemListGrid.commonClickCell(index, field);
			},
			/* beforeAddFn:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y") return false;
			}, */
			onBeforeEdit:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y") return false;
			},
			onAfterEdit:function(rowIndex,rowData){
				if(!isEmpty(rowData.RowId)){
					$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
            }
		}
			
	});	
	
	function FindItemByF(Id) {
		$UI.clear(ItemListGrid);
		$UI.clear(ItemSListGrid);
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			QueryName: 'SelectByF',
			MainId:Id
		});
	}
//=========================消毒包明细end====================
//发放标签明细
	var ItemSCm = [[{
		field:'operate',title:'操作',align:'center',width:50,
			formatter:function(value, row, index){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y"){
					var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="删除" onclick="deleteDispLabelItem('+row.RowId+')"></a>';
				}else{
					var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="删除" onclick="deleteDispLabelItem('+row.RowId+')"></a>';
				}
				return str;
			}
		},
        {
            title: 'RowId',
            field: 'RowId',
            width:100,
            hidden: true
        },{
		    title: '消毒包名称',
            field: 'PackageName',
            align: 'left',
            width:180
		},{
            title: '标签',
            field: 'Label',
            align: 'right',
            width:180
        }
    ]]; 

    var ItemSListGrid = $UI.datagrid('#ItemSList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			QueryName: 'SelectByF'
		},
		columns: ItemSCm,
		pagination:false,
		onLoadSuccess:function(data){  
				$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
				if(data.rows.length>0){
					$('#ItemSList').datagrid("selectRow", 0)
				}
		}
    }); 
    ///根据发放明细表id查具体标签明细
    function FindItemSByF(Id) {
        ItemSListGrid.load({
            ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
            QueryName: 'SelectByF',
            DispId:Id
        });
    }
}
$(init);

////手术包发放
//删除明细
function deleteItem(ItemRowId){
	if (isEmpty(ItemRowId)) {
			$UI.msg('alert','请选择要删除的单据!');
			return false;
		}
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y") {
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){
			if(data){
				$.cm({
					ClassName:'web.CSSDHUI.Disp.DispItem',
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
			ClassName : 'web.CSSDHUI.Disp.DispItem',
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
//删除主表单据

function deleteMain(mainRowId){
	if (isEmpty(mainRowId)) {
			$UI.msg('alert','请选择要删除的单据!');
			return false;
		}
	$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){
		if(data){
			$.cm({
				ClassName:'web.CSSDHUI.Disp.Disp',
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
//提交
function submitOrder(mainRowId){
	if (isEmpty(mainRowId)) {
			$UI.msg('alert','请选择要提交的单据!');
			return false;
		}
		$.cm({
			ClassName:'web.CSSDHUI.Disp.Disp',
			MethodName:'jsSubmitOrder',
			MainId:mainRowId,
			gUser:gUserId
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
				$.cm({
					ClassName:'web.CSSDHUI.Disp.Disp',
					MethodName:'jsCancelOrder',
					MainId:mainRowId
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

var init = function() {
	//发放科室
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var ReqLocBox = $HUI.combobox('#fromLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认登录科室
			$("#fromLocDr").combobox('setValue',gLocId);
		}
	});
	//接收科室
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#toLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//发放人
	$("#fromUser").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#fromUser").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetPersonInfo',v);
			if(Ret.split('^')[0]=="Y"){
				$("#fromUser").val(Ret.split('^')[2]);
				$("#fromUserDr").val(Ret.split('^')[1]);
				//saveMast();
			}else{
				$UI.msg('alert','未找到相关信息!');
				$("#fromUser").val("");
				$("#fromUser").focus();
			}
		}
	});
	var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate
	}
	$UI.fillBlock('#MainCondition',Dafult)
	
	function Clear(){
		SupLocBox.reload();
		$UI.fillBlock('#MainCondition',Dafult);
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
	}
	
	//保存单据
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			saveMast()
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
					PrintINDispReq(item.RowId);
				});
			}
			
		}
	});
	function saveMast(){
		var MainObj = $UI.loopBlock('#MainCondition');
		if(MainObj.fromLocDr==MainObj.toLocDr){
			$UI.msg('alert',"发放科室和接收科室不能相同");
			return;
		}
		if(ParamObj['RequiredDispUser']=="Y"&&isEmpty(MainObj.fromUserDr)){
			$UI.msg('alert',"发放人不能为空");
			return false;
		}else{
			if(isEmpty(MainObj.fromUserDr)){
				MainObj.fromUserDr=gUserId;
			}
		}
		if( isEmpty(MainObj.fromUserDr)){
			$UI.msg('alert',"回收人不能为空");
			return;
		}
		if(isEmpty(MainObj.toLocDr)){
			$UI.msg('alert',"接收科室不能为空");
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.Disp.Disp',
			MethodName: 'jsSave',
			Params: JSON.stringify(MainObj)
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success',jsonData.msg);
				FindNew(jsonData.rowid);
				//alert(jsonData.success);
				$("#BarCode").focus(); //条码获取到焦点
				MainListGrid.reload();
			}else{
				alert("fail");
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			$UI.clear(MainListGrid);
			$UI.clear(ItemListGrid);
			query();
			//Clear();
		}
	});
	 function query(ParamsObj){ 
	 	var Params = JSON.stringify($UI.loopBlock('#UomTB'));
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Disp.Disp',
			QueryName: 'SelectAll',
			parame: Params
		});
	}
//========================主表start===================	
	//上面输入框的回车事件处理 end
	var MainCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, 
		{
		field:'operate',
		title:'操作',
		align:'center',
		width:100,
		formatter:function(value, row, index){
			if(row.ComplateFlag=="Y"){
				var str = '<a href="#" name="operaM" class="easyui-linkbutton" disabled title="删除" onclick="deleteMain('+row.RowId+')"></a>';
				var str =str+ '<a href="#" name="operaR" class="easyui-linkbutton" title="撤销" onclick="cancelOrder('+row.RowId+')"></a>';
			}else {
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
			title: '发放单号',
			field: 'No',
			width:120,
			fitColumns:true
		}, {
			title: '发放科室',
			field: 'FromLocDesc',
			width:100,
			fitColumns:true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width:100,
			fitColumns:true
		}, {
			title: '发放人',
			field: 'FromUserDesc',
			width:100,
			fitColumns:true
		}, {
			title: '发放时间',
			field: 'DispDate',
			width:150,
			fitColumns:true
		}, {
			title: '提交人',
			field: 'DispCHKUserDesc',
			width:100,
			fitColumns:true
		}, {
			title: '提交时间',
			field: 'DispCHKDate',
			width:150,
			fitColumns:true
		}, {
			title: '完成标志',
			field: 'ComplateFlag',
			width:100,
			fitColumns:true
		}
	]];
	
	//var map = {};
	var Params = JSON.stringify($UI.loopBlock('#UomTB'));
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Disp.Disp',
			QueryName: 'SelectAll',
			parame:Params
		},
		columns: MainCm,
		toolbar: '#UomTB',
		lazy:false,
		selectOnCheck: false,
		onLoadSuccess:function(data){
			$("a[name='operaM']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
			$("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-upload'});
			$("a[name='operaR']").linkbutton({text:'',plain:true,iconCls:'icon-back'});
			if(data.rows.length>0){
				$('#MainList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].RowId);
				/* for(var i=0;i< data.rows.length;i++){
					map[i] = false;
				} */
			}	
		},
		/* onClickRow: function (rowIndex, rowData) {
			if (map[rowIndex]) {
				map[rowIndex]=false;
				$("#MainList").datagrid("unselectRow", rowIndex);
			}else{
				map[rowIndex]=true;
				$("#MainList").datagrid("selectRow", rowIndex);
			}
		}, */
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);
			}	
			MainListGrid.commonClickCell(index,filed)
		}
})
///=============================主表end===================
///=============================子表start======================
		//扫码动作
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
			$.cm({
				ClassName:'web.CSSDHUI.Disp.DispItem',
				MethodName:'jsSaveDetail',
				mainId:row.RowId,
				barCode:v
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					//$("#BarCodeInfo").val(jsonData.msg)
					ItemListGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	var ItemCm = [[
		{field:'operate',title:'操作',align:'center',width:120,
		formatter:function(value, row, index){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.ComplateFlag=="Y"){
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
			title: '条码',
			field: 'Label',
			width:150
		},{
			title: '消毒包名称',
			field: 'PackageName',
			width:200
		},{
			title: '数量',
			field: 'Qty',
			align:'right',
			width:80
		}
	]];

	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.Disp.DispItem',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			toolbar: '#InputTB',
			pagination:false,
			singleSelect:false,
			onLoadSuccess:function(data){
				$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
			}
	});	
	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Disp.DispItem',
			QueryName: 'SelectByF',
			MainId:Id
		});
	}
	function FindNew(Id){
		MainListGrid.load({
		ClassName: 'web.CSSDHUI.Disp.Disp',
		QueryName: 'FindNew',
		ID:Id
		});
	}
	
	
}
$(init);
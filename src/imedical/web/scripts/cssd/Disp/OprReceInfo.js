////手术包接收
//接收

function ReceOrder(mainRowId){
	if (isEmpty(mainRowId)) {
		    $UI.msg('alert','请选择要提交的单据!');
		    return false;
		}
		var UserId=gUserId;
		var MainObj = $UI.loopBlock('#MainCondition');
		if(ParamObj['RequiredReceiveUser']=="Y"){
			UserId=MainObj.toUserDr
			if( isEmpty(MainObj.toUserDr)){
				$UI.msg('alert',"接收人不能为空");
				return false;
			}
		}
		$.cm({
			ClassName:'web.CSSDHUI.Disp.Disp',
			MethodName:'jsReceOrder',
			mainRowId:mainRowId,
			UserId:UserId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				$('#MainList').datagrid('reload');
				$('#ItemList').datagrid('loadData',[]);
//				$UI.clear(ItemListGrid);
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
		textField: 'Description'
	});
	//接收科室
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#toLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			$("#toLocDr").combobox('setValue',gLocId);
		}
	});
	//接收人
	$("#toUser").keypress(function(event) {
	  if ( event.which == 13 ) {
	  	var v=$("#toUser").val();
	  	var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetPersonInfo',v);
	  	if(Ret.split('^')[0]=="Y"){
	  		$("#toUser").val(Ret.split('^')[2]);
	  		$("#toUserDr").val(Ret.split('^')[1]);
	  	}else{
	  		$UI.msg('alert','未找到相关信息!');
	  		$("#toUser").val("");
	  		$("#toUser").focus();
	  	}
	   }
	});
	
	//保存单据
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			saveMast()
		}
	});
	function saveMast(){
		var MainObj = $UI.loopBlock('#MainCondition');
		if(MainObj.fromLocDr==MainObj.toLocDr){
			$UI.msg('alert',"请领科室和供应科室不能相同");
			return;
		}
		if( isEmpty(MainObj.fromUserDr)){
			$UI.msg('alert',"回收人不能为空");
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.Disp.Disp',
			MethodName: 'jsSave',
			Params: JSON.stringify(MainObj)
		},function(jsonData){
			$UI.msg('success',jsonData.msg);
			if(jsonData.success==0){
				$("#BarCode").focus(); //条码获取到焦点
				MainListGrid.reload();
			}
		});
	}
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
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			query();
			$UI.clear(ItemListGrid);
			//Clear();
		}
	});
	 function query(){ 
	 	 var Params = JSON.stringify($UI.loopBlock('#UomTB'));
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Disp.Disp',
			QueryName: 'SelectAll',
			parame: Params
		});
	}
	
	//批量接收
	$UI.linkbutton('#ReceAll', {
		onClick: function () {
			$.messager.confirm("操作提示","您确定要执行批量接收操作吗？",function(data){	
			if(data){
				var Detail = MainListGrid.getChecked();
				if (isEmpty(Detail)) {
					$UI.msg('alert', '请选择需要接收的单据!');
					return;
				}
				var UserId=gUserId;
				var MainObj = $UI.loopBlock('#MainCondition');
				if(ParamObj['RequiredReceiveUser']=="Y"){
					UserId=MainObj.toUserDr
					if(isEmpty(MainObj.toUserDr)){
						$UI.msg('alert',"接收人不能为空");
						return false;
					}
				}
				var DetailParams = JSON.stringify(Detail);
				$.cm({
					ClassName:'web.CSSDHUI.Disp.Disp',
					MethodName:'jsReceAll',
					Params:DetailParams,
					UserId:UserId	
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
			});
		}
	});

	
//========================主表start===================	
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
		width:100,
		//hidden:ParamObj['ScanLabelForRes']=="Y",
		formatter:function(value, row, index){
			if(row.IsRec=="N"){
				var str ='<a href="#" name="operaC" class="easyui-linkbutton" title="接收" onclick="ReceOrder('+row.RowId+')"></a>';
			}else {
				var str ='<a href="#" name="operaY" disabled class="easyui-linkbutton" title="已接收"></a>';
			}
			return str;
		}
		},{
			title: '单据状态',
				field: 'RecStatu',
				width: 100,
				styler: flagColor,
				align:'center',
				formatter: function(value) {
					var status = "";
					if(value == "1") {
						status = "已接收";
					} else {
						status = "未接收";
					}
					return status;
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
			title: '接收人',
			field: 'ToUserDesc',
			width:100,
			fitColumns:true
		}, {
			title: '接收时间',
			field: 'RecDate',
			width:150,
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
			fitColumns:true,
			hidden:true
		}, {
			title: '是否提交',
			field: 'IsRec',
			width:100,
			fitColumns:true,
			hidden:true
		}
	]];
	function flagColor(val, row, index) {
		if(val == '1') {
			return 'background:#15b398;color:white';
		}else{
			return 'background:#ff584c;color:white';
		}
	}
	
	
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Disp.Disp',
			QueryName: 'SelectAll',
			parame:'{"FComplateFlag":"Y","FStatu":"2"}'
		},
		columns: MainCm,
		toolbar: '#UomTB',
		lazy:false,
		singleSelect: false,
		onLoadSuccess:function(data){  
	        $("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-download'});
	        $("a[name='operaY']").linkbutton({text:'',plain:true,iconCls:'icon-ok'}); 
	        if(data.rows.length>0){
				$('#MainList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].RowId);
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
				ItemListGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
			//$("#BarCode").val("").focus();
		});
	  }
});
	var ItemCm = [[
		{
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
			width:150
		},{
			title: '数量',
			field: 'Qty',
			align:'right',
			width:50
		},{
			title: '接收人',
			field: 'ToUserDesc',
			width:100
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
	
	
	
}   
$(init);
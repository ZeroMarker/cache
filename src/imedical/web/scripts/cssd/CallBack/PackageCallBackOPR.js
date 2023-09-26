//删除明细
function deleteItem(ItemRowId){
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y"&&!isEmpty(ItemRowId)) {
		$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){	
   			if(data){	
				$.cm({
					ClassName:'web.CSSDHUI.CallBack.CallBackItm',
					MethodName:'jsDelete',
					rowId:ItemRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#ItemList').datagrid('reload');
						$('#ItemSList').datagrid('loadData',[]);
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		});
	}
	if (requiredDelete != "Y") {
		$.cm({
					ClassName : 'web.CSSDHUI.CallBack.CallBackItm',
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
				ClassName:'web.CSSDHUI.CallBack.CallBack',
				MethodName:'jsDelete',
				mainRowId:mainRowId
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
			ClassName:'web.CSSDHUI.CallBack.CallBack',
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
					ClassName:'web.CSSDHUI.CallBack.CallBack',
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
	if (requiredCancel != "Y") {
    	$.cm({
                    ClassName:'web.CSSDHUI.CallBack.CallBack',
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
}
///======================================事件处理end=======================
var init = function() {
	$("#ReqLoc").focus();
	var MainReqFlage="";
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
	//回收科室
	$("#ReqLoc").keypress(function(event) {
	  if ( event.which == 13 ) {
	  	var v=$("#ReqLoc").val();
	  	var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetLocId',v);
	  	if(Ret.split('^')[0]=="Y"){
	  		$("#ReqLoc").val(Ret.split('^')[2]);
	  		$("#fromLocDr").val(Ret.split('^')[1]);
	   		$("#toUser").focus();
	  	}else{
	  		$UI.msg('alert','未找到相关信息!');
	  		$("#ReqLoc").val("");
	  		$("#ReqLoc").focus();
	  	}
	   }
	});
	//回收人
	$("#toUser").keypress(function(event) {
	  if ( event.which == 13 ) {
	  	var v=$("#toUser").val();
	  	var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetPersonInfo',v);
	  	if(Ret.split('^')[0]=="Y"){
	  		$("#toUser").val(Ret.split('^')[2]);
	  		$("#toUserDr").val(Ret.split('^')[1]);
	   		saveMast();
			$("#ReqLoc").val("");
			$("#toUser").val("");
			$("#ReqLoc").focus();
	  	}else{
	  		$UI.msg('alert','未找到相关信息!');
	  		$("#toUser").val("");
	  		$("#toUser").focus();
	  	}
	   }
	});
	
	var Dafult={
		FStartDate:DefaultStDate(),
		FEndDate:DefaultEdDate
	}
    $UI.fillBlock('#MainCondition',Dafult)
	
	function Clear(){
		//$UI.clearBlock('#MainCondition');
		//SupLocBox.reload();
		//$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
		$UI.clear(ItemSListGrid);
	}
	////===============================初始化组件end=============================
	//保存单据
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			saveMast()
		}
	});
	function saveMast(){
		var MainObj = $UI.loopBlock('#MainCondition');
		var GridListIndex = "";
		var GridListIndexId = "";
		if(MainObj.fromLocDr==MainObj.toLocDr){
			$UI.msg('alert',"回收科室和供应科室不能相同");
			$("#toUser").val("");
			$("#ReqLoc").val("");
			$("#ReqLoc").focus();
			return;
		}
		if( isEmpty(MainObj.toUserDr)){
			$UI.msg('alert',"回收人不能为空");
			return;
		}
		if(isEmpty(MainObj.fromLocDr)){
			$UI.msg('alert',"回收科室不能为空");
			return;
		}
		$.cm({
					ClassName: 'web.CSSDHUI.CallBack.CallBack',
					MethodName: 'jsSave',
					Params: JSON.stringify(MainObj)
				},function(jsonData){
					$UI.msg('success',jsonData.msg);
					if(jsonData.success==0){
						MainListGrid.reload();
					}
				});
	}
	
	//查询
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Clear();
			FindWin(query);
		}
	});
	 function query(ParamsObj){ 
	 	var Params = JSON.stringify(ParamsObj);
	 	var GridListIndex = "";
		var GridListIndexId = "";
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			QueryName: 'SelectAll',
			Params: Params,
			FIsOPRFlag: FIsOPRFlag
		});
	}
	
	//上面输入框的回车事件处理 end
	var MainCm = [[{
		field:'operate',
		title:'操作',
		align:'center',
		width:100,
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
			field: 'No',
			align: 'left',
			width:120,
			fitColumns:true
		}, {
			title: '回收科室',
			field: 'FroLocDesc',
			width:100,
			fitColumns:true
		}, {
			title: '是否提交',
			field: 'ComplateFlag',
			width:100,
			fitColumns:true,
			formatter:function(v){
				if(v=="Y")return "是";
				else return "否";
			}
		}, {
			title: '回收日期',
			field: 'CBDate',
			width:100,
			align: 'left',
			fitColumns:true
		},{
			title: '回收时间',
			field: 'CBTime',
			width:100,
			align: 'left',
			fitColumns:true
		},{
			title: '回收人',
			field: 'ToUser',
			width:100,
			fitColumns:true
		}, 
		{
			title: '提交日期',
			field: 'AckDate',
			width:100,
			align: 'left',
			fitColumns:true
		},{
			title: '提交人',
			field: 'AckUserDesc',
			width:100,
			fitColumns:true
		}
	]];

	var FIsOPRFlag = "Y";
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			QueryName: 'SelectAll',
			Params:JSON.stringify($UI.loopBlock('#MainCondition')),
			FIsOPRFlag:FIsOPRFlag
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
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
	
//========================================消毒包明细====start==============	
	
	var ItemCm = [[
	{field:'operate',title:'操作',align:'center',width:80,
			formatter:function(value, row, index){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y"){
					var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="删除" onclick="deleteItem('+row.RowId+')"></a>';
				}else{
					var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="删除" onclick="deleteItem('+row.RowId+')"></a>';
				}
				return str;
		}},	{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '消毒包名称',
			field: 'PackageName',
			width:130
		},{
			title: '消毒包名称',
			field: 'packageDesc',
			width:130,
			hidden:true
		},{
			title: '消毒包rowid',
			field: 'PackageDR',
			width:130,
			hidden:true
		},{
			title: '包标牌编码',
			field: 'DictLabel',
			width:130,
			align: 'left'
		},{
			title: '包外码',
			field: 'PackageLabel',
			width:130,
			align: 'left'
		},{
			title: '回收数量',
			field: 'Qty',
			width:80,
			align: 'right'
		},{
			title: '手术医生',
			field: 'oprDoctor',
			width:150
		},{
			title: '清点护士',
			field: 'instNurse',
			width:150
		},{
			title: '巡回护士',
			field: 'circNurse',
			width:150
		},{
			title: '感染信息',
			field: 'infectName',
			width:150
		},{
			title: '清点时间',
			field: 'oprDt',
			width:150
		},{
				title: "追踪信息",
				field: 'track',
				width: 150,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='TranInfoWin(\"" + row.PackageLabel + "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/location.png' title='跟踪信息' border='0'></a>";
					return str;
				}
			},{
				title: "图片信息",
				field: 'Icon',
				width: 150,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='ViewPic(" + row.PackageDR + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='查看图片' border='0'></a>";
					return str;
				}
			}
	]]; 
	//根据条码查询信息对返回值的处理
	function ReturnInfoFunc(row,BarCodeData){
		ItemListGrid.updateRow({
			index:ItemListGrid.editIndex,
			row: {
				PackageLabel:BarCodeData['packageLabel'],
				PackageName:BarCodeData['LabelName'],
				packageDesc:BarCodeData['packageDesc'],
				PackageDR:BarCodeData['packagedr'],
				Qty:1,
				oprDoctor:BarCodeData['UserInfo']['oprDoctor'],
				instNurse:BarCodeData['UserInfo']['instNurse'],
				circNurse:BarCodeData['UserInfo']['circNurse'],
				infectName:BarCodeData['UserInfo']['infectName'],
				oprDt:BarCodeData['UserInfo']['oprDt']
			}
		});
		var RowIndex = $('#ItemList').datagrid('getRowIndex', row);
		$('#ItemList').datagrid('refreshRow', RowIndex);
	}
	
	//扫码添加固定标签
	$("#BarCode").keypress(function(event) {
		if(event.which == 13) {
			var BarCode = $("#BarCode").val();
			var BarCodeData =  $.cm({
				ClassName: 'web.CSSDHUI.CallBack.CallBack',
				MethodName: 'GetCallbackLabelInfo',
				label: BarCode
			},false);
			if(!isEmpty(BarCodeData.success) && BarCodeData.success<0){
				$UI.msg('alert',BarCodeData.msg)
				$("#BarCode").val('').focus;
				return false;
			}
			var rowMain = $('#MainList').datagrid('getSelected');
			ItemListGrid.commonAddRow();
			var row = $('#ItemList').datagrid('getSelected');
			row['DictLabel']=BarCode
			ReturnInfoFunc(row,BarCodeData);
			var Rows=ItemListGrid.getChangesData();
			if(isEmpty(rowMain)) {
				$UI.msg('alert', '请选择需要添加的单据!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
				MethodName: 'jsSave',
				MainId: rowMain.RowId,
				Params:JSON.stringify(Rows)
			}, function(jsonData) {
				if(jsonData.success == 0) {
					$("#BarCodeInfo").val(jsonData.msg)
					ItemListGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	
	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			pagination:false,
			toolbar: '#CodeTB',
			onLoadSuccess:function(data){  
			    $("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
			    if(data.rows.length>0){
					$('#ItemList').datagrid("selectRow", 0)
					FindItemSByF(data.rows[0].PackageDR,data.rows[0].PackageLabel);
				}	
			},
			onClickCell: function(index, field, value){
				var Row=ItemListGrid.getRows()[index]
				var Id = Row.PackageDR;
				var Label = Row.PackageLabel
				if(!isEmpty(Id)&&!isEmpty(Label)){
					FindItemSByF(Id,Label);
				}	
				ItemListGrid.commonClickCell(index, field);
			},
			beforeAddFn:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y") return false;
			},
			onBeforeEdit:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y") return false;
			},
			onAfterEdit:function(){
            	$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
            }
	});	
	function FindItemByF(Id) {
		$UI.clear(ItemSListGrid);
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			QueryName: 'SelectByF',
			MainId:Id
		});
	}
//=========================消毒包明细end====================
//=========================器械明细==start======================
	// 不合格原因下拉
	var packData = $.cm({
				ClassName : 'web.CSSDHUI.Common.Dicts',
				QueryName : 'GetConsumeReason',
				ResultSetType : "array",
				typeDetial : "2"
			}, false);
	var ReasonBox = {
		type : 'combobox',
		options : {
			data : packData,
			valueField : 'RowId',
			textField : 'Description',
			onSelect : function(record) {
				var rows = ItemSListGrid.getRows();
				var row = rows[ItemSListGrid.editIndex];
				row.ConsumeReasonName = record.Description;
			},
			onShowPanel : function() {
				$(this).combobox('reload')
			}
		}
	};
	var ItemSCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '器械名称',
			field: 'Desc',
			width:100
		},{
			title: '规格',
			field: 'Spec',
			width:100
		},{
			title: '数量',
			field: 'Qty',
			align: 'right',
			width:70
		},{
			title: '缺少数量',
			field: 'ConsumeQty',
			align: 'right',
			width:70,
			editor:{type:'numberbox'}
		},{
			title: '缺失原因',
			field: 'ConsumeReasonDR',
			width:100,
			formatter: CommonFormatter(ReasonBox, 'ConsumeReasonDR', 'ConsumeReasonName'),
			editor: ReasonBox
		},{
			title: '是否启用',
			field: 'NotUseFlag',
			width:130,
			hidden: true
		},{
			title: '备注',
			field: 'Remarks',
			width:100
		}
	]]; 

	var ItemSListGrid = $UI.datagrid('#ItemSList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
				QueryName: 'SelectByLabel'
			},
			columns: ItemSCm,
			pagination:false,
			showSaveItems:true,
			saveDataFn:function(){//保存明细
				var MainObj=$UI.loopBlock('#MainCondition');
				var fromLocDr=MainObj.fromLocDr
				var Rows=ItemSListGrid.getChangesData();
				if(isEmpty(Rows)){
					$UI.msg('alert','没有需要保存的信息!');
					return;
				}
				var ItemRow = $('#ItemList').datagrid('getSelected');
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y"){
					$UI.msg('alert','单据已经提交无法修改!');
					return;
				}
				$.cm({
					ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
					MethodName: 'jsAddConsume',
					Params:JSON.stringify(Rows),
					PackageLabel:ItemRow.PackageLabel,
					LocDr:fromLocDr,
					CallBackDr:$('#MainList').datagrid('getSelected').RowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ItemSListGrid.reload();
					}else{
						$UI.msg('alert',jsonData.msg);
					}
				});
			},
			onLoadSuccess:function(data){
			},
			onBeforeCellEdit: function(index, field){
            	var RowData = $(this).datagrid('getRows')[index];
            	if(RowData['NotUseFlag']=="N"){
            		$UI.msg('alert','该器械已被停用，不可修改!');
               		return false;
            	}
        	},
			onClickCell: function(index, field, value){
                ItemSListGrid.commonClickCell(index, field);
            }
	});	
	///根据消毒包dr查询包含的器械明细
	function FindItemSByF(Id,Label) {
		ItemSListGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			QueryName: 'SelectByLabel',
			PackageRowId:Id,
			PackageLabel:Label
		});
	}
//=========================器械明细 end========================
}
$(init);

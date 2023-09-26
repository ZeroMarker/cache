var init = function() {
	$(".ystep1").loadStep({
				size : "large",
				color : "green",
				steps : [{
							title : "未提交",
							content : "该单据尚未提交"
						}, {
							title : "提交",
							content : "该单据已经提交"
						}, {
							title : "确认",
							content : "该单据已经确认"
						}, {
							title : "拒绝",
							content : "该单据已被拒绝"
						}, {
							title : "回收",
							content : "该单据已经回收"
						}, {
							title : "发放",
							content : "该单据已经发放"
						}, {
							title : "接收",
							content : "该单据已被接收"
						}, {
							title : "归还",
							content : "该单据已经归还"
						}]
			})        
	var MainReqFlage="";
	// 请求科室
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"ReqLoc"}));
	var ReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认登录科室
			$("#FReqLoc").combobox('setValue',gLocId);
		}
	});
	//供应科室
	var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocBox = $HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			$("#FSupLoc").combobox('setValue',data[0].RowId);
		}
	});
	
	////===============================初始化组件end=============================
	//查询
	
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			QueryDrugInfo();
			$UI.clear(ItemListGrid);
		}
	});
	$('#ClearBT').on('click', ClearDrugInfo);
	function QueryDrugInfo() {
		var Params = JSON.stringify($UI.loopBlock('#CondTB'));
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	function ClearDrugInfo(){
		$UI.clearBlock('#MainCondition');
		SupLocBox.reload();
		ReqLocBox.reload();
		$UI.fillBlock('#MainCondition',Dafult)
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
		$(".ystep1").setStep(1);
	}
	
	var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate
			}
	 $UI.fillBlock('#MainCondition',Dafult)
	
	//上面输入框的回车事件处理 end
	var MainCm = [[{
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		}, {
			title: '单号',
			field: 'No',
			width:100,
			fitColumns:true
		}, {
			title: '拒绝原因',
			field: 'RefuseReason',
			width:150,
			fitColumns:true
		}, {
			title: '单据状态',
			field: 'ReqFlag',
			width:100,
			fitColumns:true
		}, {
			title: '提交时间',
			field: 'commitDate',
			width:150,
			fitColumns:true
		}, {
			title: '提交人',
			field: 'commitUser',
			width:100,
			fitColumns:true
		}, {
			title: '单据类型',
			field: 'ReqTypeDesc',
			width:100,
			fitColumns:true
		}, {
			title: '紧急程度',
			field: 'ReqLevelDesc',
			width:100,
			fitColumns:true
		}, {
			title: '申请科室',
			field: 'ReqLocDesc',
			width:100,
			fitColumns:true
		}
	]];

	$("#FReqLoc").combobox('setValue',gLocId);
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Apply.PackageApply',
			QueryName: 'SelectAll',
			Params:JSON.stringify($UI.loopBlock('#CondTB'))
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
		onLoadSuccess:function(data){  
			        if(data.rows.length>0){
						$('#MainList').datagrid("selectRow", 0);
						var Row=MainListGrid.getRows()[0]
						var Id = Row.RowId;
						var state = Row.ReqFlag;
						if ("未提交" == state) {
							$(".ystep1").setStep(1);
						} else if ("提交" == state) {
							$(".ystep1").setStep(2);
						} else if ("确认" == state) {
							$(".ystep1").setStep(3);
						} else if ("回收" == state) {
							$(".ystep1").setStep(5);
						} else if ("发放" == state) {
							$(".ystep1").setStep(6);
						} else if ("接收" == state) {
							$(".ystep1").setStep(7);
						} else if ("归还" == state) {
							$(".ystep1").setStep(8);
						} else if ("拒绝" == state) {
							$(".ystep1").setStep(4);
						}
						FindItemByF(Id);
					}	
			},
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var state = Row.ReqFlag;
			if ("未提交" == state) {
				$(".ystep1").setStep(1);
			} else if ("提交" == state) {
				$(".ystep1").setStep(2);
			} else if ("确认" == state) {
				$(".ystep1").setStep(3);
			} else if ("回收" == state) {
				$(".ystep1").setStep(5);
			} else if ("发放" == state) {
				$(".ystep1").setStep(6);
			} else if ("接收" == state) {
				$(".ystep1").setStep(7);
			} else if ("归还" == state) {
				$(".ystep1").setStep(8);
			} else if ("拒绝" == state) {
				$(".ystep1").setStep(4);
			}
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);	
			}	
			MainListGrid.commonClickCell(index,filed)
		}
	})
	//消毒包下拉列表
	var packData=$.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
			QueryName: 'GetPackage'	,
			ResultSetType:"array",
			typeDetial: "2"
	},false);
	var PackageBox = {
		type: 'combobox',
		options: {
			data:packData,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = ItemListGrid.getRows();
				var row = rows[GridList.editIndex];
				row.PackageName = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	};
	var ItemCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '消毒包名称',
			field: 'PackageDR',
			width:200,
			formatter: CommonFormatter(PackageBox, 'LocDr', 'PackageName')
			
		},{
			title: '请领数量',
			field: 'Qty',
			align: 'right',
			width:100
		},{
			title: '备注',
			field: 'Remark',
			width:200
		}
	]]; 

	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			pagination:false,
			singleSelect:false
			
	});	
	
	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Apply.PackageApplyItm',
			QueryName: 'SelectByF',
			ApplyId:Id
			
		});
	}
	
}
$(init);

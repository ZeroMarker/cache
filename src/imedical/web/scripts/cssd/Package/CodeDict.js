var init = function() {
	$('#TypeDetail').combobox("setValue","");
	var LocParams =JSON.stringify(sessionObj);
	var LocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = GridList.getRows();
				var row = rows[GridList.editIndex];
				row.LocDesc = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	};
	
	var typeDetial="1,4,6,2,3"
	var PackageBox = $HUI.combobox('#package', {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=' + typeDetial,
			valueField: 'RowId',
			textField: 'Description'
		});
	$UI.linkbutton('#SearchBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('PackageItemTB'));
			GridList.load({
				ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
	});
	$UI.linkbutton('#CreateBarcodeBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('PackageItemTB'));
			if(!$("#package").combobox('getValue')){
				$UI.msg('alert','请选择消毒包');
				return ;	
			}	
			if(!$("#Qty").val()){
				$UI.msg('alert','请输入数量');
				$("#Qty").focus();
				return ;	
			}
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
				MethodName: 'CreateBarcode',
				Params: Params
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					GridList.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#PrintBarcodeBT',{ 
		onClick:function(){
			var Detail = GridList.getSelections();
            if (isEmpty(Detail)) {
                $UI.msg('alert', '请选择要打印的数据!');
            }
            if (!isEmpty(Detail)) {
                $.each(Detail, function (index, item) {
                    //PrintBarcode(item.pkglbl);
                    printCodeDict(item.Code,item.CodeDictName,item.SterTypeName);
                });
            }
		}
	});
	$UI.linkbutton('#PrintItm',{ 
		onClick:function(){
			var Detail = GridList.getSelections();
            if (isEmpty(Detail)) {
                $UI.msg('alert', '请选择要打印的数据!');
            }
            if (!isEmpty(Detail)) {
                $.each(Detail, function (index, item) {
                    //PrintBarcode(item.pkglbl);
                    printitmByCodeDict(item.Code,item.CodeDictName);
                });
            }
		}
	});
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			$UI.clearBlock('PackageItemTB');
			$UI.clear(GridList);
		}
	});
	
	$('#SaveBT').on('click', function(){
		var Rows=GridList.getChangesData();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			MethodName: 'Save',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(isEmpty(Rows)){
				//$UI.msg('alert','没有需要保存的信息!');
				return;
			}
			$UI.msg('success',jsonData.msg);
			if(jsonData.success==0){
				GridList.reload();
			}
		});
	});
	var Cm = [[{
			title: 'RowId',
			field: 'RowId',
			checkbox:true
		}, {
			title: '标牌编码',
			field: 'Code',
			width:150,
			fitColumns:true
		}, {
			title: '标牌名称',
			field: 'CodeDictName',
			width:200,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '消毒包名称',
			field: 'PackageInfoDesc',
			width:200,
			fitColumns:true
		}, {
			title: '标牌分类',
			field: 'PackTypeDetailDesc',
			width:100,
			fitColumns:true
		}, {
			title: '循环次数',
			field: 'CycleCount',
			width:150,
			fitColumns:true,
			align:"right"
		}, {
			title: '科室',
			field: 'LocDr',
			width:150,
			fitColumns:true,
			formatter: CommonFormatter(LocCombox, 'LocDr', 'LocDesc'),
			editor: LocCombox
		}, {
			title: '灭菌方式DR',
			field: 'SterType',
			width:100,
			fitColumns:true,
			hidden: true
		}, {
			title: '灭菌方式',
			field: 'SterTypeName',
			width:100,
			fitColumns:true
		}
	]];

	var GridList = $UI.datagrid('#GridList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			QueryName: 'SelectAll'				
		},
		columns: Cm,
		singleSelect: false,
		toolbar: "#PackageItemTB",
		lazy:false,
		onClickCell: function(index, filed ,value){
			var Row=GridList.getRows()[index]
			GridList.commonClickCell(index,filed)
		} 
	})	
}
$(init);
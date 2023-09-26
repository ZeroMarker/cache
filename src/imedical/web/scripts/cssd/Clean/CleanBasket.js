function deleteItem(RowId){
	$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			MethodName: 'jsDelete',
			ItemRowID: RowId
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				$('#MainList').datagrid('reload');
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
}
var init = function() {
	//灭菌车
	$("#CleanBasket").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#CleanBasket").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetSterCar',3, v);
			if(Ret.split('^')[0]=="Y"){
				$("#Label").focus();
				$("#CleanBasket").val(Ret.split('^')[2]);
				$("#CleanBasketValue").val(Ret.split('^')[1]);
				Query();
			}else{
				$UI.msg('alert', '错误的清洗篮筐条码!');
				$("#CleanBasket").val("");
				$("#CleanBasket").focus();
			}
		}
	});
	//条码
	$("#Label").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#Label").val();
			SaveBasketDetail();
		}
	});

	//装车
	function SaveBasketDetail(){
		var basketLabel=$("#CleanBasketValue").val();
		var pkgLabel=$("#Label").val();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			MethodName: 'jsSaveCleanBasket',
			pkgLabel: pkgLabel,
			basketLabel:basketLabel
		},function(jsonData){
			if(jsonData.success == 0){
				$UI.msg('success', jsonData.msg);
				MainListGrid.reload();
				$("#Label").val("");
				$("#Label").focus();
			}else{
				$UI.msg('error', jsonData.msg);	
			}
		});
	}
	
	function saveMast(){
		var Rows=MainListGrid.getChangesData();
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有需要保存的信息!');
			return;
		}
		$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanBasket',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					MainListGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
	}
	//查询数据
	function Query(){
		var CleanBasketLabel=$("#CleanBasketValue").val();
		if(isEmpty(CleanBasketLabel)){
				$UI.msg('alert', '请选择清洗篮筐！');
				return;
			}
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			QueryName: 'SelectCleanBasketInfo',
			basketLabel:CleanBasketLabel
		});
	}
	var MainCm = [[
		{field:'operate',title:'操作',align:'center',width:$(this).width()*0.1,
		formatter:function(value, row, index){
			var str = '<a href="#" name="operaM" class="easyui-linkbutton"  onclick="deleteItem('+row.RowId+')"></a>';
			return
	}},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '条码',
			field: 'packageLabel',
			width:300
		},{
			title: '消毒包名称',
			field: 'packageDesc',
			width:300
		},{
			title: '数量',
			field: 'Qty',
			width:100,
			align:'right',
			editor:{type:'numberbox',options:{required:true,min:1}}
		}
	]]; 
	
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			QueryName: 'SelectCleanBasketInfo'	
		},
		columns: MainCm,
		//toolbar: '#PackageItemTB',
		showSaveItems: true,
		lazy:false,
		onClickCell: function(index, filed ,value){
			MainListGrid.commonClickCell(index,filed)
		},
		saveDataFn: function(){
			saveMast();
		},
		onLoadSuccess:function(data){  
			$("a[name='operaM']").linkbutton({plain:true,iconCls:'icon-cancel'});  
		}
	})
	var Default = function() {
		$('#CleanBasket').focus();
	}
	Default();
}
$(init);

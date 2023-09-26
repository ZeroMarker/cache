function deleteItem(RowId){
		$.cm({
				ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
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
	$("#SterCar").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#SterCar").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetSterCar',6, v);
			if(Ret.split('^')[0]=="Y"){
				$("#Label").focus();
				$("#SterCar").val(Ret.split('^')[2]);
				$("#SterCarValue").val(Ret.split('^')[1]);
				Query();
			}else{
				$UI.msg('alert', '错误的灭菌车条码!');
				$("#SterCar").val("");
				$("#SterCar").focus();
			}
		}
	});
	//条码
	$("#Label").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#Label").val();
			SaveCarDetail()
			$("#Label").val("");
			$("#Label").focus();
		}
	});

	//装车
	function SaveCarDetail(){
		var carlbl=$("#SterCarValue").val();
		var pkglbl=$("#Label").val();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			MethodName: 'jsSaveSterCar',
			pkglbl: pkglbl,
			carlbl:carlbl
		},function(jsonData){
			if(jsonData.success == 0){
				$UI.msg('success', jsonData.msg);
				MainListGrid.reload();
			}else{
				$UI.msg('error', jsonData.msg);	
			}
		});
	}
	//查询数据
	function Query(){
		var carLabel=$("#SterCarValue").val();
		if(isEmpty(carLabel)){
				$UI.msg('alert', '请选择灭菌车!');
				return;
			}
		MainListGrid.load({
				ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
				QueryName: 'SelectByCarLable',
				CarLable:carLabel
			});
	}
	var MainCm = [[
		{field:'operate',title:'操作',align:'center',width:$(this).width()*0.1,
		formatter:function(value, row, index){
			var str = '<a href="#" name="operaM" class="easyui-linkbutton"  onclick="deleteItem('+row.RowId+')"></a>';
			return str;
	}},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '条码',
			field: 'Label',
			width:300
		},{
			title: '消毒包名称',
			field: 'PackageName',
			width:300
		},{
			title: '数量',
			field: 'Qty',
			width:100,
			align:'right'
		}
	]]; 
	
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			QueryName: 'SelectByCarLable'	
		},
		columns: MainCm,
		toolbar: '#PackageItemTB',
		lazy:false,
		onLoadSuccess:function(data){  
			$("a[name='operaM']").linkbutton({plain:true,iconCls:'icon-cancel'});  
		}
	})
//选取待灭菌包
$UI.linkbutton('#AddItemBT', {
		onClick: function(){
			var carLabel=$("#SterCarValue").val();
			if(isEmpty(carLabel)){
					$UI.msg('alert', '请选择灭菌车!');
					return;
				}
			SelBarcode(Query,carLabel,"","");	
		}
	});
var Default = function() {
		$('#SterCar').focus();
	}
	Default();
}
$(init);

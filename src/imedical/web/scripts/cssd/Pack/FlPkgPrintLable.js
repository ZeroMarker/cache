var ParamObj = GetAppPropValue('CSSDPACK');
var init = function () {
	var flag="";
	var PackageBox = $HUI.combobox('#package', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=7',
		valueField: 'RowId',
		textField: 'Description'
	});
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$("#cleandate").dateboxq("setValue", DateFormatter(new Date()));
	var Params = JSON.stringify($UI.loopBlock('cleantable'))
	//审核人回车
	$("#txtChker").keydown(function (e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#txtChker").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanUser",
					cleanCode: $("#txtChker").val()
				}, function (txtData) {
					if (txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#txtChkerv").val(arr[0]);
						$("#txtChker").val(arr[1]);
						$('#txtActor').focus();
					} else {
						$UI.msg('alert', '错误的审核人!');
						$("#txtChker").val("");
						$('#txtChker').focus();
						return;
					}
				})
			}
		}
	});
	//包装人回车
	$("#txtActor").keydown(function (e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#txtActor").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanUser",
					cleanCode: $("#txtActor").val()
				}, function (txtData) {
					if (txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#txtActorv").val(arr[0]);
						$("#txtActor").val(arr[1]);
						$('#num').focus();
					} else {
						$UI.msg('alert', '错误的审核人!');
						$("#txtActor").val("");
						$('#txtActor').focus();
						return;
					}
				})
			}
		}
	});
	//查询
	$UI.linkbutton('#query', {
		onClick: function () {
			var Params = JSON.stringify($UI.loopBlock('cleantable'));
			GridList.load({
				ClassName: 'web.CSSDHUI.Pack.FabricLbl',
				QueryName: 'QueryFabricPkgs',
				Params: Params
			});
		}
	});
	
	//标签生成
	$UI.linkbutton('#LabelGen', {
		onClick: function () {
			var Params = JSON.stringify($UI.loopBlock('cleantable'));
			if (!$("#package").combobox('getValue')) {
				$UI.msg('alert', '请选择敷料包');
				return;
			}
			if (!$("#Loc").combobox('getValue')) {
				$UI.msg('alert', '请选择科室');
				return;
			}
			if (!$("#txtChker").val()) {
				$UI.msg('alert', '请输入审核人');
				$("#txtChker").focus();
				return;
			}
			if (!$("#txtActor").val()) {
				$UI.msg('alert', '请输入包装人');
				$("#txtActor").focus();
				return;
			}
			if (!$("#num").val()) {
				$UI.msg('alert', '请输入数量');
				$("#num").focus();
				return;
			}
			//window.console.log(Params);
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.FabricLbl',
				MethodName: 'GenFabricPkgs',
				Params: Params
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					FindNew(jsonData.rowid);
				}else{
					$UI.msg('alert',jsonData.msg);
				}
			});
			$UI.clearBlock('#cleantable');
			$('#PackType').combobox('setValue', '5');
			Default();
		}
	});
	//标签生成并打印
	$UI.linkbutton('#GenLableAndPrint', {
		onClick: function () {
			flag=1;
			var Params = JSON.stringify($UI.loopBlock('cleantable'));
			if (!$("#package").combobox('getValue')) {
				$UI.msg('alert', '请选择敷料包');
				return;
			}
			if (!$("#Loc").combobox('getValue')) {
				$UI.msg('alert', '请选择科室');
				return;
			}
			if (!$("#txtChker").val()) {
				$UI.msg('alert', '请输入审核人');
				$("#txtChker").focus();
				return;
			}
			if (!$("#txtActor").val()) {
				$UI.msg('alert', '请输入包装人');
				$("#txtActor").focus();
				return;
			}
			if (!$("#num").val()) {
				$UI.msg('alert', '请输入数量');
				$("#num").focus();
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.FabricLbl',
				MethodName: 'GenFabricPkgs',
				Params: Params
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					FindNew(jsonData.rowid);
				}else{
					$UI.msg('alert',jsonData.msg);
				}
			});
			$UI.clearBlock('#cleantable');
			$('#PackType').combobox('setValue', '5');
			Default();
		}
	});
	//打印
	$UI.linkbutton('#Print', {
		onClick: function () {
			var Detail = GridList.getSelectedData();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择要打印的数据!');
			}
			if (!isEmpty(Detail)) {
				var Obj = $UI.loopBlock('#UomTB');
				var ToLoc = Obj.Loc;
				$.each(Detail, function (index, item) {
					printout(item.pkglbl,ToLoc);
				});
			}
		}
	});
	//标签打印(无明细)
	$UI.linkbutton('#PrintNot', {
	 onClick: function () {
		var Detail = GridList.getSelections();
		var DetailParams = JSON.stringify(Detail);
		if(isEmpty(Detail)){
				$UI.msg('alert', '请选择需要打印的消毒包');
				return ;
			}
		if(!isEmpty(Detail)){
			var Obj = $UI.loopBlock('#UomTB');
			var ToLoc = Obj.Loc;
			$.each(Detail, function(index, item){
				printoutnotitm(item.pkglbl,ToLoc);
			});  
		}
	}
	});
	var Cm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: '标签',
				field: 'pkglbl',
				width: 200,
				fitColumns: true
			}, {
				title: 'ID',
				field: 'packId',
				hidden: true
			}, {
				title: '消毒包名称',
				field: 'pkgName',
				width: 160,
				fitColumns: true
			}, {
				title: '配包人',
				field: 'AckUserName',
				width: 160,
				fitColumns: true
			}, {
				title: '审核人',
				field: 'ChkUserName',
				width: 160,
				fitColumns: true
			}, {
				title: '有效日期',
 				field: 'strExpDate',
				width: 160,
				fitColumns: true

			}, {
				title: '科室',
 				field: 'useLocDesc',
				width: 160,
				fitColumns: true

			}

		]];
	var GridList = $UI.datagrid('#GridList', {
		toolbar: '#UomTB',
		singleSelect: false,
		queryParams: {
 			ClassName: 'web.CSSDHUI.Pack.FabricLbl',
			QueryName: 'QueryFabricPkgs',
			Params: JSON.stringify($UI.loopBlock('cleantable'))
		},
		columns: Cm,
		lazy: false,
		onLoadSuccess:function(data){
			if(flag==1){
				var Obj = $UI.loopBlock('#UomTB');
				var ToLoc = Obj.Loc;
				var rows = $("#GridList").datagrid("getData").rows;
				for(var i=0;i<rows.length;i++){
					printout(rows[i].pkglbl,ToLoc);
				}
			}
			flag="";
		}
	})
	function FindNew(Id){
		GridList.load({
			ClassName: 'web.CSSDHUI.Pack.FabricLbl',
			QueryName: 'QueryFabricPkgsById',
			Params:Id
		});
	}
	var Default = function () {
		///设置初始值 考虑使用配置
		$("#cleandate").dateboxq("setValue",DateFormatter(new Date()));
	}
}
$(init);

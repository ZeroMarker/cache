var init = function () {
	
	//查询
	$UI.linkbutton('#query', {
		onClick: function () {
			var Params = JSON.stringify($UI.loopBlock('cleantable'));
			GridList.load({
				ClassName: 'web.CSSDHUI.Stat.ExpireQueryStat',
				QueryName: 'GetExpiredPkgs',
				Params: Params
			});
		}
	});
	$UI.linkbutton('#ExpCommit', {
		onClick: function () {
			var Detail = GridList.getChecked();
			var DetailParams = JSON.stringify(Detail);
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择需要处理的单据');
				return;
			}
			$.cm({
					ClassName:'web.CSSDHUI.Stat.ExpireQueryStat',
					MethodName:'Exp',
					Params:DetailParams
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#GridList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			
		}
	});
	var Cm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: '标签',
				field: 'label',
				width: 200,
				fitColumns: true
			},{
				title: '消毒包名称',
				field: 'pkgName',
				width: 200,
				fitColumns: true
			}, {
				title: '包类型',
				field: 'packTypeDetail',
				width: 100,
				fitColumns: true
			}, {
				title: '失效日期',
				field: 'expDate',
				width: 100,
				fitColumns: true
			}, {
				title: '离失效期的天数',
 				field: 'minusDate',
				width: 150,
				fitColumns: true

			}, {
				title: '当前位置',
 				field: 'curloc',
				width: 150,
				fitColumns: true

			},{
				title: '当前状态',
 				field: 'status',
				width: 150,
				fitColumns: true

			}

		]];
	var GridList = $UI.datagrid('#GridList', {
		toolbar: '#UomTB',
		singleSelect: false,
		queryParams: {
 			ClassName: 'web.CSSDHUI.Stat.ExpireQueryStat',
			QueryName: 'GetExpiredPkgs'
		},
		columns: Cm,
		lazy: false
	})
	var Default = function () {
	///设置初始值 考虑使用配置
	$("#cleandate").datebox("setValue", $('#cleandate').datebox('options').currentText);
	}
}
$(init);

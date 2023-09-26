function FindDetail(Id) {
	$HUI.dialog('#SelReqWin').open();
	function SelReqQuery() {
		CleanDetailList.load({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'GetOrdPackInfo',
			detailIds: Id,
			rows:999
		});
	}

	//修改人员和有效期
	$UI.linkbutton('#UpdatePack', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#usertb');
			var ParamsMain = JSON.stringify(ParamsObj);
			if(isEmpty(ParamsObj.txtChkeruv)){
				$UI.msg('alert', '审核人为空');
				return ;
			}
			if(isEmpty(ParamsObj.txtActoruv)){
				$UI.msg('alert', '包装人为空');
				return ;
			}
			var Rows = CleanDetailList.getSelectedData();
			var ParamsDetail = JSON.stringify(Rows);
			if(isEmpty(Rows)){
				$UI.msg('alert', '请选择需要修改的消毒包');
				return ;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				MethodName: 'ChangePackChkUser',
				Main: ParamsMain,
				Detail: ParamsDetail
			}, function(jsonData) {
				if(jsonData.success === 0) {
					CleanDetailList.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$("#txtChkeru").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#txtChkeru").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanUser",
					cleanCode: $("#txtChkeru").val()
				}, function(txtData) {
					if(txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#txtChkeruv").val(arr[0]);
						$("#txtChkeru").val(arr[1]);
						$('#txtActoru').focus();
					} else {
						$UI.msg('alert', '错误的审核人!');
						$("#txtChkeru").val("");
						$('#txtChkeru').focus();
						return;
					}
				})
			}
		}
	});
	//包装人回车
	$("#txtActoru").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#txtActoru").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanUser",
					cleanCode: $("#txtActoru").val()
				}, function(txtData) {
					//alert(txtData);
					if(txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#txtActoruv").val(arr[0]);
						$("#txtActoru").val(arr[1]);
					} else {
						$UI.msg('alert', '错误的包装人!');
						$("#txtActoru").val("");
						$('#txtActoru').focus();
						return;
					}
				})
			}
		}
	});
	//标签打印
	$UI.linkbutton('#Print', {
	 onClick: function () {
		var Detail = CleanDetailList.getSelections();
		var DetailParams = JSON.stringify(Detail);
		if(isEmpty(Detail)){
				$UI.msg('alert', '请选择需要打印的消毒包');
				return ;
			}
		if(!isEmpty(Detail)){
			var PrintDetailNum = PrintLine();
			var Obj = $UI.loopBlock('#Usertb');
			var ToLoc = Obj.ToLoc;
	 		var PotNoValue = Obj.PotNoValue;
			var HeatNo = Obj.HeatNo;
			var PotNoSterType = Obj.PotNoSterType;
			$.each(Detail, function(index, item){
				printout(item.pkglbl,ToLoc,PotNoValue,HeatNo,PotNoSterType,PrintDetailNum);
			});  
		}
	}
	});
	//标签打印(无明细)
	$UI.linkbutton('#PrintNot', {
	 onClick: function () {
		var Detail = CleanDetailList.getSelections();
		var DetailParams = JSON.stringify(Detail);
		if(isEmpty(Detail)){
				$UI.msg('alert', '请选择需要打印的消毒包');
				return ;
			}
		if(!isEmpty(Detail)){
			var Obj = $UI.loopBlock('#Usertb');
			var ToLoc = Obj.ToLoc;
			$.each(Detail, function(index, item){
				printoutnotitm(item.pkglbl,ToLoc);
			});  
		}
	}
	});
	var Cm = [
		[ 
		     {
				title: '',
				field: 'ck',
				checkbox: true,
				width: 50
			},{
				title: 'cleanDetailId',
				field: 'cleanDetailId',
				hidden: true
			}, {
				title: '条码号',
				field: 'pkglbl',
				width: 150,
				fitColumns: true
			}, {
				title: '消毒包名称',
				field: 'pkgName',
				width: 150,
				fitColumns: true
			}, {
				title: 'packId',
				field: 'packId',
				width: 100,
				hidden: true
			},
			{
				title: 'AckUserId',
				field: 'AckUserId',
				width: 150,
				hidden: true

			}, {
				title: '包装人',
				field: 'AckUserName',
				width: 100,
				fitColumns: true

			}, {
				title: 'ChkUserId',
				field: 'ChkUserId',
				width: 100,
				hidden: true

			},
			{
				title: '审核人',
				field: 'ChkUserName',
				width: 100

			},
			{
				title: '有效日期',
				field: 'strExpDate',
				width: 100

			}

		]
	];
	var CleanDetailList = $UI.datagrid('#CleanDetail', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'GetOrdPackInfo',
			detailIds: Id,
			rows:999
		},
		columns: Cm,
		pagination: false,
		singleSelect: false

	});
	SelReqQuery();

}
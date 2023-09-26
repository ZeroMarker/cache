var init = function () {
	var flag="";
	 //发放科室
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ReqLocBox = $HUI.combobox('#SelReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//接收科室
	var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocBox = $HUI.combobox('#toLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认第一个值
			$("#toLocDr").combobox('setValue',gLocId);
		}
	});
	
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
	$UI.linkbutton('#SelReqQueryBT',{ 
		onClick:function(){
			$UI.clear(GridList);
			$UI.clear(GridDetailList);
			query();
		}
	});
	 function query(){ 
	 	 var Params = JSON.stringify($UI.loopBlock('#SelReqConditions'));
		 GridList.load({
			ClassName: 'web.CSSDHUI.FLPkgPack.FLPackageApplyPrint',
			QueryName: 'SelectFlApply',
			Params: Params 
		 })
	}
	var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate
		}
	$UI.fillBlock('#SelReqConditions',Dafult); 
	$UI.linkbutton('#LabelGen', {
		onClick: function () {
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
			var Main = JSON.stringify(addSessionParams($UI.loopBlock('UomTB')));
			var Rows = GridList.getChecked();
			if(isEmpty(Rows)){
				$UI.msg('alert', '请选择需要生成的消毒包');
				return ;
			}
			var DetailParams = JSON.stringify(Rows);
			$.cm({
				ClassName: 'web.CSSDHUI.FLPkgPack.FLPackageApplyPrint',
				MethodName: 'GenFlLabel',
				Main: Main,
				Detail:DetailParams
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					GridList.reload();
					//FindNew(jsonData.rowid);
				}else{
					$UI.msg('alert',jsonData.msg);
				}
			});
		}
	});

	//标签生成并打印
	$UI.linkbutton('#GenLableAndPrint', {
		onClick: function () {
			flag=1;
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
			var Main = JSON.stringify(addSessionParams($UI.loopBlock('UomTB')));
			var Rows = GridList.getChecked();
			if(isEmpty(Rows)){
				$UI.msg('alert', '请选择需要生成的消毒包');
				return ;
			}
			var DetailParams = JSON.stringify(Rows);
			$.cm({
				ClassName: 'web.CSSDHUI.FLPkgPack.FLPackageApplyPrint',
				MethodName: 'GenFlLabel',
				Main: Main,
				Detail:DetailParams
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					Print(jsonData.rowid);
					GridList.reload();
				}else{
					$UI.msg('alert',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#Print', {
		onClick: function () {
			var Rows = GridList.getChecked();
			if(isEmpty(Rows)){
				$UI.msg('alert', '请选择需要打印的消毒包');
			}
			var DetailIds="";
			for(var i= 0, Len= Rows.length;i < Len;i++){
				var detailid = Rows[i]['RowId'];
				if(DetailIds == ""){
					DetailIds = detailid;
				}	
				else{
					DetailIds = DetailIds + ',' + detailid;
				}
			}
			$.cm({
				ClassName: 'web.CSSDHUI.FLPkgPack.FLPackageApplyPrint',
				MethodName: 'GetPackageLabels',
				details: DetailIds
			}, function(jsonData) {
				if(!isEmpty(jsonData)){
				$.each(jsonData, function(index, item){
						printout(item.label,"");
					}); 
				}
			});
		}
	});
	$UI.linkbutton('#PrintDetail', {
		onClick: function () {
			var Detail = GridDetailList.getChecked();
			var DetailParams = JSON.stringify(Detail);
			if(isEmpty(Detail)){
				$UI.msg('alert', '请选择需要打印的消毒包');
			}
			if(!isEmpty(Detail)){
				$.each(Detail, function(index, item){
					if(!isEmpty(item.pkglbl)){
						printout(item.pkglbl,"");
				}
			});  
		}
		}
	});
	function flagColor(val, row, index) {
		if(val == 'Y') {
			return 'background:#15b398;color:white';
		}else{
			return 'background:#ff584c;color:white';
		}
	}
	var Cm = [[{
				field: 'ck',
				checkbox: true
			},{
				title: '是否生成',
				field: 'IsGen',
				width: 120,
				fitColumns: true,
				styler: flagColor,
				formatter: function(value) {
					var status = "";
					if(value == "Y") {
						status = "已完成";
					} else {
						status = "未完成";
					}
					return status;
				}
			},
			{
				title: '申请单号',
				field: 'No',
				width: 120,
				fitColumns: true
			}, {
				title: 'RowId',
				field: 'RowId',
				hidden: true
			}, {
				title: '申请科室',
				field: 'FromLocDesc',
				width: 160,
				fitColumns: true
			}, {
				title: '申请时间',
				field: 'commitDate',
				width: 160,
				fitColumns: true
			}, {
				title: '消毒包名称',
				field: 'PackageName',
				width: 160,
				fitColumns: true
			}, {
				title: '数量',
 				field: 'Qty',
				width: 160,
				fitColumns: true

			}

		]];
	var GridList = $UI.datagrid('#GridList', {
		toolbar: '#UomTB',
		//singleSelect: false,
		selectOnCheck: false,
		queryParams: {
 			ClassName: 'web.CSSDHUI.FLPkgPack.FLPackageApplyPrint',
			QueryName: 'SelectFlApply',
			Params: JSON.stringify($UI.loopBlock('UomTB'))
		},
		columns: Cm,
		lazy: false,
		onLoadSuccess:function(data){
		},
		onClickCell: function(index, filed, value) {
			var Row = GridList.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)) {
				FindNew(Id);
			}
			GridList.commonClickCell(index, filed)
		}
	})
	var detailCm = [[{
				field: 'ck',
				checkbox: true
			},
			{
				title: '标签号',
				field: 'pkglbl',
				width: 160,
				fitColumns: true
			}, {
				title: '消毒包名称',
				field: 'pkgName',
				width: 160,
				fitColumns: true
			}, {
				title: '失效日期',
 				field: 'strExpDate',
				width: 160,
				fitColumns: true

			}

		]];
	var GridDetailList = $UI.datagrid('#ItemList', {
		toolbar: '#InputTB',
		queryParams: {
			ClassName: 'web.CSSDHUI.FLPkgPack.FLPackageApplyPrint',
			MethodName: 'QueryFabricPkgsByCallBackId'
		},
		singleSelect: false,
		columns: detailCm,
		//lazy: false,
		pagination:false
	})
	///标签明细
	function FindNew(Id){
		GridDetailList.load({
			ClassName: 'web.CSSDHUI.FLPkgPack.FLPackageApplyPrint',
			QueryName: 'QueryFabricPkgsByCallBackId',
			Params:Id,
			rows:9999
		});
	}
	function Print(details){
		$.cm({
			ClassName: 'web.CSSDHUI.FLPkgPack.FLPackageApplyPrint',
			MethodName: 'GetPackageLabels',
			details: details
		}, function(jsonData) {
			if(!isEmpty(jsonData)){
				$.each(jsonData, function(index, item){
					printout(item.label,"");
				}); 
			}
		});
	}
	
}
$(init);

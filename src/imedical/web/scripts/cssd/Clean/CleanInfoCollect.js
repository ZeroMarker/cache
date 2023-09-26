//删除明细
function deleteItem(sterItemRowId) {
	if(isEmpty(sterItemRowId)) {
		$UI.msg('alert', '请选择要删除的单据!');
		return false;
	}
	$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){
		if(data){
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'jsDelete',
				rowId: sterItemRowId
			}, function(jsonData) {
				if(jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$('#ItemList').datagrid('reload');
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});		
		}
	});

}

//删除主表
function Del(sterItemRowId, IsCmtEnterMachine) {
	if(isEmpty(sterItemRowId)) {
		$UI.msg('alert', '请选择要删除的单据!');
		return false;
	}
	$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){
		if(data){
			if(IsCmtEnterMachine == "1") {
				$UI.msg("alert", "已经确认进锅!");
				return;
			}	
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'jsDeleteMain',
				rowId: sterItemRowId
			}, function(jsonData) {
				if(jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$('#tabDrugList').datagrid('reload');
					//$("#BarCodeInfo").val("");
				} else {
				$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

}
var init = function() {
	var ifCleanRack = IfcleanRack();
	if(ifCleanRack=="N"){
		$("#cleanCode").attr("readonly","readonly");
		$("#cleanCode").attr("disabled",true);		
	}
	$("#cleandate").dateboxq("setValue", DateFormatter(new Date()));
	var Params = JSON.stringify($UI.loopBlock('cleantable'));
	var GridListIndex = "";
	var GridListIndexId = ""
	var typeDetial="2"
	var PackageBox = $HUI.combobox('#CommonPackage', {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=' + typeDetial,
			valueField: 'RowId',
			textField: 'Description'
		});
	//清洗方式
	$("#cleantype").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#cleantype").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanType",
					cleanCode: $("#cleantype").val()
				}, function(txtData) {
					if(txtData != null && !isEmpty(txtData)) {
						var ifCleanRack = IfcleanRack();
						arr = txtData.split('^');
						if(arr[2]=="N"){
							$UI.msg('alert', arr[1]+'方式未启用!');
							$("#cleantype").val("");
							$('#cleantype').focus();
							return ;
						}
						$("#cleantypev").val(arr[0]);
						$("#cleantype").val(arr[1]);
						if(ifCleanRack=="Y"){
							if(isEmpty($("#cleanmachine").val())){
								$("#cleanmachine").focus();
							}else if(isEmpty($("#cleanCode").val())){
								$("#cleanCode").focus();
							}else if(isEmpty($("#cleanStro").val())){
								$("#cleanStro").focus();
							}else if(isEmpty($("#cleaner").val())){
								$("#cleaner").focus();
							}
						}else{
							if(isEmpty($("#cleanmachine").val())){
								$("#cleanmachine").focus();
							}else if(isEmpty($("#cleanStro").val())){
								$("#cleanStro").focus();
							}else if(isEmpty($("#cleaner").val())){
								$("#cleaner").focus();
							}
						}
						
						
					} else {
						$UI.msg('alert', '错误的清洗方式!');
						$("#cleantype").val("");
						$('#cleantype').focus();
						return;
					}
				})
			}
		}
	});
	//锅号
	$("#cleanmachine").keydown(function(event) {
		var ifCleanRack = IfcleanRack();
		if(event.which == 13) {
			var v = $("#cleanmachine").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetMachineNo', "washer", v);
			if(Ret.split('^')[3]=="N"){
				$UI.msg('alert',Ret.split('^')[2]+'清洗锅未启用!');
				$("#cleanmachine").val("");
				$("#cleanmachine").focus();
				return;
			}
			if(Ret.split('^')[0] == "Y") {
				$("#MachineNoValue").val(Ret.split('^')[1]);
				$("#cleanmachine").val(Ret.split('^')[2]);
				var ifCleanRack = IfcleanRack();
				if(ifCleanRack=="Y"){
					$("#cleanCode").focus();
				}else{
					$("#cleanStro").focus();	
				}
				
			} else {
				$UI.msg('alert', '未找到相关信息!');
				$("#cleanmachine").val("");
				$("#cleanmachine").focus();
			}
			
		}
	});
	//清洗架
	$("#cleanCode").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#cleanCode").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanCode",
					cleanCode: $("#cleanCode").val()
				}, function(txtData) {
					if(txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#cleanCodev").val(arr[0]);
						$("#cleanCode").val(arr[1]);
						$('#cleanStro').focus();
					} else {
						$UI.msg('alert', '错误的清洗架号!');
						$("#cleanCode").val("");
						$('#cleanCode').focus();
						return;
					}
				})
			}
		}
	});
	//清洗程序
	$("#cleanStro").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#cleanStro").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanPro",
					cleanCode: $("#cleanStro").val()
				}, function(txtData) {
					if(txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						if(arr[2]=="N"){
							$UI.msg('alert', arr[1]+'程序未启用!');
							$("#cleanStro").val("");
							$('#cleanStro').focus();
							return ;
						}
						$("#cleanStrov").val(arr[0]);
						$("#cleanStro").val(arr[1]);
						$('#cleaner').focus();
					} else {
						$UI.msg('alert', '错误的清洗程序!');
						$("#cleanStro").val("");
						$('#cleanStro').focus();
						return;
					}
				})
			}
		}
	});
	//清洗人回车
	$("#cleaner").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#cleaner").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanUser",
					cleanCode: $("#cleaner").val()
				}, function(txtData) {
					if(txtData != null && !isEmpty(txtData)) {
						var arr = txtData.split('^');
						$("#cleanerv").val(arr[0]);
						$("#cleaner").val(arr[1]);
						//如果以上信息有一条为空,则此时不是在新建数据,而是准备执行查询操作
						if(isEmpty($("#cleantype").val())||isEmpty($("#cleanmachine").val())||isEmpty($("#cleanStro").val())){
							return ;
						}
						$('#BarCode').focus();
						$('#add').click();
					} else {
						$UI.msg('alert', '错误的清洗人!');
						$("#cleaner").val("");
						$('#cleaner').focus();
						return;
					}
				})
			}
		}
	});
	//确定框
	$("#cleanadd").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#cleanadd").val() == "0000000000") {
				$('#add').click();
			}
		}
	});
	//增加清洗主表
	$UI.linkbutton('#add', {
		onClick: function() {
			if($('#cleandate').dateboxq('getValue')==""){
				$UI.msg('alert', '请选择日期');
				$('#cleandate').focus();
				return ;
			}
			if($("#cleantype").val()==""){
				$UI.msg('alert', '请选择清洗方式');
				$('#cleantype').focus();
				return ;
			}
			if($("#cleanmachine").val()==""){
				$UI.msg('alert', '请选择清洗机号');
				$('#cleanmachine').focus();
				return ;
			}
			var ifCleanRack = IfcleanRack();
			if($("#cleanCode").val()==""&&ifCleanRack!="N"){
				$UI.msg('alert', '请选择清洗架号');
				$('#cleanCode').focus();
				return ;
			}
			if($("#cleanStro").val()==""){
				$UI.msg('alert', '请选择清洗程序');
				$('#cleanStro').focus();
				return ;
			}
			if($("#cleaner").val()==""){
				$UI.msg('alert', '请选择清洗人');
				$('#cleaner').focus();
				return ;
			}
			var Params = JSON.stringify($UI.loopBlock('cleantable'));
			GridListIndex = "";
			GridListIndexId = ""
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'jsSaveClean',
				Params: Params
			}, function(jsonData) {
				if(jsonData.success == 0) {
					$UI.msg("success", jsonData.msg);
					$UI.clear(ItemListGrid);
					$UI.clearBlock('#cleantable');
					$UI.clear(ItemListGrid)
					if(!isEmpty(jsonData.rowid)){
						FindNew(jsonData.rowid);
					}
					Default();
					$("#BarCode").val("").focus();
				} else {
					$UI.msg("alert", "请输入清洗信息");
					$("#cleantype").focus();
				}
			});
		}
	});
	//清空
	$UI.linkbutton('#clear', {
		onClick: function() {
			$UI.clearBlock('#cleantable');
			Default();
			//$("#BarCodeInfo").val("");
			$UI.clear(GridList);
			$UI.clear(ItemListGrid);
		}
	});
	//查询
	$UI.linkbutton('#query', {
		onClick: function() {
			var Params = JSON.stringify($UI.loopBlock('cleantable'));
			$UI.clear(ItemListGrid);
			GridListIndex = "";
			GridListIndexId = "";
			GridList.load({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
	});
	$UI.linkbutton('#AddItemBT', {
		onClick: function() {
			var row = $('#tabDrugList').datagrid('getSelected');
			if(isEmpty(row)){
				$UI.msg("alert", "请选择清洗信息!");
				return ;
			}
			if(row.IsCmtEnterMachine==1){
				$UI.msg("alert", "已经确认进锅无法继续添加明细!");
				return ;
			}
			$("#SelReqWinStartDate").dateboxq("setValue", DateFormatter(new Date()));
			$("#SelReqWinEndDate").dateboxq("setValue", DateFormatter(new Date()));
			FindItem();
			$HUI.dialog('#SelReqWin').open();
			ItemListGrid.commonReload();
		}
	});
	
	//待清洗公用包(普通包)弹窗
	$UI.linkbutton('#AddGYB', {
		onClick: function() {
			var row = $('#tabDrugList').datagrid('getSelected');
			if(isEmpty(row)){
				$UI.msg("alert", "请选择清洗信息!");
				return ;
			}
			if(row.IsCmtEnterMachine==1){
				$UI.msg("alert", "已经确认进锅无法继续添加明细!");
				return ;
			}
			$("#SelReqStartDate").dateboxq("setValue", DateFormatter(new Date()));
			$("#SelReqEndDate").dateboxq("setValue", DateFormatter(new Date()));
			var Params = JSON.stringify($UI.loopBlock('uncleanord'));
			UnCleanOrdListGrid.load({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				QueryName: 'SelectAllUnCleanOrd',
				Params: Params
			});
			$HUI.dialog('#OrdWin').open();
			UnCleanOrdListGrid.commonReload();
		}
	});
	//查询待清洗公用包
	$UI.linkbutton('#queryord', {
		onClick: function() {
			var Params = JSON.stringify($UI.loopBlock('uncleanord'));
			UnCleanOrdListGrid.load({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				QueryName: 'SelectAllUnCleanOrd',
				Params: Params
			});
			$HUI.dialog('#OrdWin').open();
		}
	});
	//查询待清洗专科器械包
	$UI.linkbutton('#querySelReqWin', {
		onClick: function() {
			var Params = JSON.stringify($UI.loopBlock('SelReqConditions'));
			UnCleanItemListGrid.load({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				QueryName: 'SelectUnClean',
				Params: Params
			});
			$HUI.dialog('#SelReqWin').open();
		}
	});
	//待清洗公用包添加消毒包功能
	$UI.linkbutton('#AddUnCleanOrd', {
		onClick: function() {
			var Rows = UnCleanOrdListGrid.getSelectedData();
			var DetailParams = JSON.stringify(Rows);
			if(isEmpty(Rows)){
				$UI.msg('alert', '请选择要清洗的消毒包');
				return;
			}
			var flag=""
			$.each(Rows,function(index,item){
				if(parseInt(item.willQty)<=0){
					$UI.msg('alert', '请输入合适的清洗数量');
					flag = 1;
				}
				if(parseInt(item.willQty)>parseInt(item.unCleanQty)){
					$UI.msg('alert', '清洗数量不能多于未清洗数量');
					flag=1;
				}
					
			});
			if(flag==1){
				return ;	
			}

			var mainRows = GridList.getSelected();
			if(isEmpty(mainRows)) {
				$UI.msg('alert', '请选择需要添加的锅次!');
				return;
			}
			
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'SaveUnOrdClean',
				Params: DetailParams,
				mainId: mainRows.ID
			}, function(jsonData) {
				UnCleanOrdListGrid.commonReload();
				$('#OrdWin').window('close');
				ItemListGrid.commonReload();
			});
			
		}
	});
	//弹出框里面按钮待清洗专科包
	$UI.linkbutton('#SelBarCodeCreateBT', {
		onClick: function() {
			var Rows = UnCleanItemListGrid.getSelectedData();
			if(isEmpty(Rows)){
				$UI.msg('alert', '请选择要清洗的消毒包');
				return ;
			}
			var params = JSON.stringify(Rows);
			var mainRows = GridList.getSelected();
			if(isEmpty(mainRows)) {
				$UI.msg('alert', '请选择需要添加的锅次!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'SaveUnClean',
				Params: params,
				mainId: mainRows.ID
			}, function(jsonData) {
				UnCleanItemListGrid.commonReload();
				$('#SelReqWin').window('close');
				ItemListGrid.commonReload();
			});

		}
	});
	//确认进锅
	$UI.linkbutton('#btnCommit', {
		onClick: function() {
			var Rows = GridList.getSelected();
			if(isEmpty(Rows)) {
				$UI.msg("alert", "请选择需要确认进锅的记录!");
				return;
			}
			var RowIndex = GridList.getRowIndex(Rows);
			GridListIndex = RowIndex;
			GridListIndexId = Rows.ID;
			if(ItemListGrid.getRows()==""){
				$UI.msg("alert", "没有明细不能进锅");
				return ;
			}	
			if(Rows.IsCmtEnterMachine == "1") {
				$UI.msg("alert", "已经确认进锅!");
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'CmtEnterMachine',
				Params: Rows.ID
			}, function(jsonData) {
				GridList.commonReload();
				ItemListGrid.commonReload();
			});
		}
	});
	//扫码添加固定标签
	$("#BarCode").keypress(function(event) {
		if(event.which == 13) {
			var value = $("#BarCode").val();
			var row = $('#tabDrugList').datagrid('getSelected');
			if(isEmpty(row)) {
				$UI.msg('alert', '请选择需要添加的锅次!');
				return;
			}
			if(row.IsCmtEnterMachine==1){
				$UI.msg('alert', '已经确认进锅无法继续添加明细!');
				$("#BarCode").val("");
				return ;
			}
			if(isEmpty(row.ID)) {
				$UI.msg('alert', '参数错误!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'jsSaveCleanDetail',
				mainId: row.ID,
				barCode: value
			}, function(jsonData) {
				if(jsonData.success == 0) {
					//$("#BarCodeInfo").val(jsonData.msg)
					FindItemByF(row.ID);
				} else {
					$UI.msg('error', jsonData.msg);
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	$UI.linkbutton('#CommonPackageCreateBT',{
		onClick: function() {
			var row = $('#tabDrugList').datagrid('getSelected');
			if(isEmpty(row)){
				$UI.msg('alert', '请选择需要添加的锅次!');
				return ;
			}
			if(row.IsCmtEnterMachine==1){
				$UI.msg("alert", "已经确认进锅无法继续添加明细!");
				$("#CommonPackage").combobox('setValue','');
				$("#CommonPackageNum").numberbox("setValue","");
				return ;
			}
			var packageDr = $("#CommonPackage").combobox('getValue')
			var number = $("#CommonPackageNum").val();
			if(isEmpty(packageDr)){
				$UI.msg('alert', '请选择需要添加的普通包!');
				return ;
			}
			if(isEmpty(number)||number<=0){
				$UI.msg('alert', '请输入合适的数量!');
				$("#CommonPackageNum").numberbox("setValue","");
				$("#CommonPackageNum").focus();
				return ;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'JsSaveCommonPackage',
				mainId: row.ID,
				PackageDr: packageDr,
				Number: number
			}, function(jsonData) {
				if(jsonData.success == 0) {
					FindItemByF(row.ID);
					$("#CommonPackage").combobox('setValue','');
					$UI.clearBlock('#CleanDetailTable');
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	})	
	var ItemCm = [
		[{
				field: 'operate',
				title: '操作',
				align: 'center',
				width: 50,
				formatter: function(value, row, index) {
					if(row.Iscmt != "0") {
						var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="删除"></a>';
					} else {
						var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="删除" onclick="deleteItem(' + row.ID + ')"></a>';
					}
					return str;
				}
			},
			{
				title: 'ID',
				field: 'ID',
				width: 100,
				hidden: true
			}, {
				title: '申请单',
				field: 'ApplyNo',
				width: 100
			}, {
				title: '科室',
				field: 'LocName',
				width: 100
			}, {
				title: '消毒包名称',
				field: 'packagedesc',
				width: 120
			},
			{
				title: '包标牌编码',
				field: 'CodeLabel',
				width: 100
			},
			{
				title: '数量',
				field: 'qty',
				width: 50,
				align: 'right'
			},
			{
				title: '是否进锅',
				field: 'Iscmt',
				width: 100,
				hidden: true
			}
		]
	];
	//右边明细
	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'SelectCleanDetail',
			rows:99999
		},
		columns: ItemCm,
		toolbar: '#InputTB',
		pagination:false,
		singleSelect: false,
		remoteSort:true,
		onLoadSuccess: function(data) {
			$("a[name='opera']").linkbutton({
				plain: true,
				iconCls: 'icon-cancel'
			});	
			
		}
	});

	var UnCleanCm = [
		[
			{
				title: '',
				field: 'ck',
				checkbox: true,
				width: 50
			},
			{
				title: 'DetailID',
				field: 'DetailID',
				width: 100,
				hidden: true
			}, {
				title: '申请单',
				field: 'ApplyNo',
				width: 100
			}, {
				title: '科室',
				field: 'LocName',
				width: 200
			},
			{
				title: '消毒包',
				field: 'pkgdr',
				width: 100,
				hidden: true
			},
			{
				title: '消毒包名称',
				field: 'pkgName',
				width: 200
			},
			{
				title: '数量',
				field: 'BackQty',
				align: 'right',
				width: 100
			}
		]
	];

	var UnCleanOrdCm = [
		[   
		     {
				title: '',
				field: 'ck',
				checkbox: true,
				width: 50
			},  
		    {
				title: 'pkgdr',
				field: 'pkgdr',
				width: 100,
				hidden: true
			}, {
				title: '消毒包名称',
				field: 'pkgName',
				width: 100
			}, {
				title: '回收数量',
				field: 'backQty',
				width: 100
			},
			{
				title: '清洗数量',
				field: 'cleanQty',
				width: 100
			},
			{
				title: '未清洗数量',
				field: 'unCleanQty',
				width: 100
			},
			{
				title: '要清洗数量',
				field: 'willQty',
				width: 100,
				editor: {
					type: 'numberbox',
					options: {
						//required: true
					}
				}
			}
		]
	];
	//待清洗专科器械包
	var UnCleanItemListGrid = $UI.datagrid('#UnCleanList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'SelectUnClean'
		},
		columns: UnCleanCm,
		toolbar: '#SelReqWinTB',
		singleSelect: false,
		pagination: true,
		singleSelect: false

	});
	var map = {};
	//待清洗供应室公用包
	var UnCleanOrdListGrid = $UI.datagrid('#UnCleanOrdList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'SelectAllUnCleanOrd'
		},
		columns: UnCleanOrdCm,
		pagination: true,
		singleSelect: false,
		toolbar: '#OrdWinTB',
		onClickCell: function(index, filed, value) {
			var Row = UnCleanOrdListGrid.getRows()[index];
			UnCleanOrdListGrid.commonClickCell(index, filed);
		},
		onClickRow: function (rowIndex, rowData) {
			if(map[rowIndex]){
				$("#UnCleanOrdList").datagrid("uncheckRow",rowIndex);
				map[rowIndex] = false;
			}else{
				$("#UnCleanOrdList").datagrid("checkRow",rowIndex);
				map[rowIndex]=true;
			}
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				for(var i=0;i<data.rows.length;i++){
					map[i] = false;
				}
			}
		}

	});
	var Cm = [
		[{
				title: '操作',
				field: 'MachineN',
				width: 50,
				formatter: formatOper
			},
			{
				title: '确认进锅',
				field: 'IsCmtEnterMachine',
				width: 100,
				styler: flagColor,
				formatter: function(value) {
					var status = "";
					if(value == "1") {
						status = "已完成";
					} else {
						status = "未完成";
					}
					return status;
				}
			},
			{
				title: 'ID',
				field: 'ID',
				hidden: true
			}, {
				title: '机器号',
				field: 'MachineNo',
				width: 60,
				align:'right'
			}, {
				title: '清洗方式',
				field: 'cleanType',
				width: 100
			}, {
				title: '日期',
				field: 'CleanDate',
				width: 100
			}, {
				title: '时间',
				field: 'CleanTime',
				width: 100
			}, {
				title: '清洗架号',
				field: 'VehicleLabel',
				width: 100
			}, {
				title: '清洗批号',
				field: 'CleanNo1',
				width: 150

			},
			{
				title: '清洗人',
				field: 'CleanerName',
				width: 100

			},
			{
				title: '验收人',
				field: 'ChkerName',
				width: 100

			}

		]
	];

	function flagColor(val, row, index) {
		if(val == '1') {
			return 'background:#15b398;color:white';
		}else{
			return 'background:#ff584c;color:white';
		}
	}

	function formatOper(val, row, index) {
			if(row.IsCmtEnterMachine=="1")
			var str = '<a href="#" name="operaM" class="easyui-linkbutton" disabled title="删除"></a>';
			else 
			var str = '<a href="#" name="operaM" class="easyui-linkbutton" title="删除" onclick="Del(' + row.ID + ',' + row.IsCmtEnterMachine + ')"></a>';
			return str;
		}
	

	var GridList = $UI.datagrid('#tabDrugList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectAll',
			Params: Params
		},
		columns: Cm,
		toolbar: "#UomTB",
		remoteSort: false,
		lazy: false,
		onLoadSuccess: function(data) {
			$("a[name='operaM']").linkbutton({plain:true,iconCls:'icon-cancel'});  
			if(data.rows.length > 0&&isEmpty(GridListIndex)) {
				$('#tabDrugList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].ID);
				
			}
			if(!isEmpty(GridListIndex)){
				$('#tabDrugList').datagrid("selectRow", GridListIndex);
				FindItemByF(GridListIndexId);
			}
			

		},
		/**
		onClickCell: function(index, filed, value) {
			var Row = GridList.getRows()[index]
			var Id = Row.ID;
			var IsCmt = Row.IsCmtEnterMachine;
			if(!isEmpty(Id)) {
				FindItemByF(Id);
				if(IsCmt == "1") {
					$('#BarCode').attr("disabled", "disabled"); //设为不可用
					$('#AddItemBT').linkbutton('disable');
					$('#AddGYB').linkbutton('disable');
					$('#CommonPackage').combobox('disable');
					$('#CommonPackageNum').attr("disabled", "disabled");
					$('#CommonPackageCreateBT').linkbutton('disable');
				}
				if(IsCmt == "0") {
					$("#BarCode").attr("disabled", false);
					$('#AddItemBT').linkbutton('enable');
					$('#AddGYB').linkbutton('enable');
					$('#CommonPackage').combobox('enable');
					$('#CommonPackageNum').attr("disabled", false);
					$('#CommonPackageCreateBT').linkbutton('enable');
				}
			}
			GridList.commonClickCell(index, filed)
		},
		**/
		onSelect:function(index, rowData) {
			var Row = GridList.getRows()[index]
			var Id = Row.ID;
			var IsCmt = Row.IsCmtEnterMachine;
			if(!isEmpty(Id)) {
				FindItemByF(Id);
				if(IsCmt == "1") {
					$('#BarCode').attr("disabled", "disabled"); //设为不可用
					$('#AddItemBT').linkbutton('disable');
					$('#AddGYB').linkbutton('disable');
					$('#CommonPackage').combobox('disable');
					$('#CommonPackageNum').attr("disabled", "disabled");
					$('#CommonPackageCreateBT').linkbutton('disable');
				}
				if(IsCmt == "0") {
					$("#BarCode").attr("disabled", false);
					$('#AddItemBT').linkbutton('enable');
					$('#AddGYB').linkbutton('enable');
					$('#CommonPackage').combobox('enable');
					$('#CommonPackageNum').attr("disabled", false);
					$('#CommonPackageCreateBT').linkbutton('enable');
				}
			}
			
		}
	
	})

	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectCleanDetail',
			Params: Id,
			rows:99999
		});

	}
	//待清洗专科器械包
	function FindItem() {
		var Params = JSON.stringify($UI.loopBlock('SelReqConditions'));
		UnCleanItemListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectUnClean',
			Params : Params
		});
	}
	
	function FindNew(Id){
		GridList.load({
		ClassName: 'web.CSSDHUI.Clean.CleanInfo',
		QueryName: 'FindNew',
		ID:Id
		});
	}
	var Default = function() {
		///设置初始值 考虑使用配置
		$("#cleandate").dateboxq("setValue", DateFormatter(new Date()));
		$('#cleantype').focus();
	}
	Default();

}

$(init);
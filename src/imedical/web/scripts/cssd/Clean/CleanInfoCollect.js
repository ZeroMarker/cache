//ɾ����ϸ
function deleteItem(sterItemRowId) {
	if(isEmpty(sterItemRowId)) {
		$UI.msg('alert', '��ѡ��Ҫɾ���ĵ���!');
		return false;
	}
	$.messager.confirm("������ʾ","��ȷ��Ҫִ�в�����",function(data){
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

//ɾ������
function Del(sterItemRowId, IsCmtEnterMachine) {
	if(isEmpty(sterItemRowId)) {
		$UI.msg('alert', '��ѡ��Ҫɾ���ĵ���!');
		return false;
	}
	$.messager.confirm("������ʾ","��ȷ��Ҫִ�в�����",function(data){
		if(data){
			if(IsCmtEnterMachine == "1") {
				$UI.msg("alert", "�Ѿ�ȷ�Ͻ���!");
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
	//��ϴ��ʽ
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
							$UI.msg('alert', arr[1]+'��ʽδ����!');
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
						$UI.msg('alert', '�������ϴ��ʽ!');
						$("#cleantype").val("");
						$('#cleantype').focus();
						return;
					}
				})
			}
		}
	});
	//����
	$("#cleanmachine").keydown(function(event) {
		var ifCleanRack = IfcleanRack();
		if(event.which == 13) {
			var v = $("#cleanmachine").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetMachineNo', "washer", v);
			if(Ret.split('^')[3]=="N"){
				$UI.msg('alert',Ret.split('^')[2]+'��ϴ��δ����!');
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
				$UI.msg('alert', 'δ�ҵ������Ϣ!');
				$("#cleanmachine").val("");
				$("#cleanmachine").focus();
			}
			
		}
	});
	//��ϴ��
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
						$UI.msg('alert', '�������ϴ�ܺ�!');
						$("#cleanCode").val("");
						$('#cleanCode').focus();
						return;
					}
				})
			}
		}
	});
	//��ϴ����
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
							$UI.msg('alert', arr[1]+'����δ����!');
							$("#cleanStro").val("");
							$('#cleanStro').focus();
							return ;
						}
						$("#cleanStrov").val(arr[0]);
						$("#cleanStro").val(arr[1]);
						$('#cleaner').focus();
					} else {
						$UI.msg('alert', '�������ϴ����!');
						$("#cleanStro").val("");
						$('#cleanStro').focus();
						return;
					}
				})
			}
		}
	});
	//��ϴ�˻س�
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
						//���������Ϣ��һ��Ϊ��,���ʱ�������½�����,����׼��ִ�в�ѯ����
						if(isEmpty($("#cleantype").val())||isEmpty($("#cleanmachine").val())||isEmpty($("#cleanStro").val())){
							return ;
						}
						$('#BarCode').focus();
						$('#add').click();
					} else {
						$UI.msg('alert', '�������ϴ��!');
						$("#cleaner").val("");
						$('#cleaner').focus();
						return;
					}
				})
			}
		}
	});
	//ȷ����
	$("#cleanadd").keydown(function(e) {
		var curKey = e.which;
		if(curKey == 13) {
			if($("#cleanadd").val() == "0000000000") {
				$('#add').click();
			}
		}
	});
	//������ϴ����
	$UI.linkbutton('#add', {
		onClick: function() {
			if($('#cleandate').dateboxq('getValue')==""){
				$UI.msg('alert', '��ѡ������');
				$('#cleandate').focus();
				return ;
			}
			if($("#cleantype").val()==""){
				$UI.msg('alert', '��ѡ����ϴ��ʽ');
				$('#cleantype').focus();
				return ;
			}
			if($("#cleanmachine").val()==""){
				$UI.msg('alert', '��ѡ����ϴ����');
				$('#cleanmachine').focus();
				return ;
			}
			var ifCleanRack = IfcleanRack();
			if($("#cleanCode").val()==""&&ifCleanRack!="N"){
				$UI.msg('alert', '��ѡ����ϴ�ܺ�');
				$('#cleanCode').focus();
				return ;
			}
			if($("#cleanStro").val()==""){
				$UI.msg('alert', '��ѡ����ϴ����');
				$('#cleanStro').focus();
				return ;
			}
			if($("#cleaner").val()==""){
				$UI.msg('alert', '��ѡ����ϴ��');
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
					$UI.msg("alert", "��������ϴ��Ϣ");
					$("#cleantype").focus();
				}
			});
		}
	});
	//���
	$UI.linkbutton('#clear', {
		onClick: function() {
			$UI.clearBlock('#cleantable');
			Default();
			//$("#BarCodeInfo").val("");
			$UI.clear(GridList);
			$UI.clear(ItemListGrid);
		}
	});
	//��ѯ
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
				$UI.msg("alert", "��ѡ����ϴ��Ϣ!");
				return ;
			}
			if(row.IsCmtEnterMachine==1){
				$UI.msg("alert", "�Ѿ�ȷ�Ͻ����޷����������ϸ!");
				return ;
			}
			$("#SelReqWinStartDate").dateboxq("setValue", DateFormatter(new Date()));
			$("#SelReqWinEndDate").dateboxq("setValue", DateFormatter(new Date()));
			FindItem();
			$HUI.dialog('#SelReqWin').open();
			ItemListGrid.commonReload();
		}
	});
	
	//����ϴ���ð�(��ͨ��)����
	$UI.linkbutton('#AddGYB', {
		onClick: function() {
			var row = $('#tabDrugList').datagrid('getSelected');
			if(isEmpty(row)){
				$UI.msg("alert", "��ѡ����ϴ��Ϣ!");
				return ;
			}
			if(row.IsCmtEnterMachine==1){
				$UI.msg("alert", "�Ѿ�ȷ�Ͻ����޷����������ϸ!");
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
	//��ѯ����ϴ���ð�
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
	//��ѯ����ϴר����е��
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
	//����ϴ���ð��������������
	$UI.linkbutton('#AddUnCleanOrd', {
		onClick: function() {
			var Rows = UnCleanOrdListGrid.getSelectedData();
			var DetailParams = JSON.stringify(Rows);
			if(isEmpty(Rows)){
				$UI.msg('alert', '��ѡ��Ҫ��ϴ��������');
				return;
			}
			var flag=""
			$.each(Rows,function(index,item){
				if(parseInt(item.willQty)<=0){
					$UI.msg('alert', '��������ʵ���ϴ����');
					flag = 1;
				}
				if(parseInt(item.willQty)>parseInt(item.unCleanQty)){
					$UI.msg('alert', '��ϴ�������ܶ���δ��ϴ����');
					flag=1;
				}
					
			});
			if(flag==1){
				return ;	
			}

			var mainRows = GridList.getSelected();
			if(isEmpty(mainRows)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӵĹ���!');
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
	//���������水ť����ϴר�ư�
	$UI.linkbutton('#SelBarCodeCreateBT', {
		onClick: function() {
			var Rows = UnCleanItemListGrid.getSelectedData();
			if(isEmpty(Rows)){
				$UI.msg('alert', '��ѡ��Ҫ��ϴ��������');
				return ;
			}
			var params = JSON.stringify(Rows);
			var mainRows = GridList.getSelected();
			if(isEmpty(mainRows)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӵĹ���!');
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
	//ȷ�Ͻ���
	$UI.linkbutton('#btnCommit', {
		onClick: function() {
			var Rows = GridList.getSelected();
			if(isEmpty(Rows)) {
				$UI.msg("alert", "��ѡ����Ҫȷ�Ͻ����ļ�¼!");
				return;
			}
			var RowIndex = GridList.getRowIndex(Rows);
			GridListIndex = RowIndex;
			GridListIndexId = Rows.ID;
			if(ItemListGrid.getRows()==""){
				$UI.msg("alert", "û����ϸ���ܽ���");
				return ;
			}	
			if(Rows.IsCmtEnterMachine == "1") {
				$UI.msg("alert", "�Ѿ�ȷ�Ͻ���!");
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
	//ɨ����ӹ̶���ǩ
	$("#BarCode").keypress(function(event) {
		if(event.which == 13) {
			var value = $("#BarCode").val();
			var row = $('#tabDrugList').datagrid('getSelected');
			if(isEmpty(row)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӵĹ���!');
				return;
			}
			if(row.IsCmtEnterMachine==1){
				$UI.msg('alert', '�Ѿ�ȷ�Ͻ����޷����������ϸ!');
				$("#BarCode").val("");
				return ;
			}
			if(isEmpty(row.ID)) {
				$UI.msg('alert', '��������!');
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
				$UI.msg('alert', '��ѡ����Ҫ��ӵĹ���!');
				return ;
			}
			if(row.IsCmtEnterMachine==1){
				$UI.msg("alert", "�Ѿ�ȷ�Ͻ����޷����������ϸ!");
				$("#CommonPackage").combobox('setValue','');
				$("#CommonPackageNum").numberbox("setValue","");
				return ;
			}
			var packageDr = $("#CommonPackage").combobox('getValue')
			var number = $("#CommonPackageNum").val();
			if(isEmpty(packageDr)){
				$UI.msg('alert', '��ѡ����Ҫ��ӵ���ͨ��!');
				return ;
			}
			if(isEmpty(number)||number<=0){
				$UI.msg('alert', '��������ʵ�����!');
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
				title: '����',
				align: 'center',
				width: 50,
				formatter: function(value, row, index) {
					if(row.Iscmt != "0") {
						var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="ɾ��"></a>';
					} else {
						var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="ɾ��" onclick="deleteItem(' + row.ID + ')"></a>';
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
				title: '���뵥',
				field: 'ApplyNo',
				width: 100
			}, {
				title: '����',
				field: 'LocName',
				width: 100
			}, {
				title: '����������',
				field: 'packagedesc',
				width: 120
			},
			{
				title: '�����Ʊ���',
				field: 'CodeLabel',
				width: 100
			},
			{
				title: '����',
				field: 'qty',
				width: 50,
				align: 'right'
			},
			{
				title: '�Ƿ����',
				field: 'Iscmt',
				width: 100,
				hidden: true
			}
		]
	];
	//�ұ���ϸ
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
				title: '���뵥',
				field: 'ApplyNo',
				width: 100
			}, {
				title: '����',
				field: 'LocName',
				width: 200
			},
			{
				title: '������',
				field: 'pkgdr',
				width: 100,
				hidden: true
			},
			{
				title: '����������',
				field: 'pkgName',
				width: 200
			},
			{
				title: '����',
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
				title: '����������',
				field: 'pkgName',
				width: 100
			}, {
				title: '��������',
				field: 'backQty',
				width: 100
			},
			{
				title: '��ϴ����',
				field: 'cleanQty',
				width: 100
			},
			{
				title: 'δ��ϴ����',
				field: 'unCleanQty',
				width: 100
			},
			{
				title: 'Ҫ��ϴ����',
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
	//����ϴר����е��
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
	//����ϴ��Ӧ�ҹ��ð�
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
				title: '����',
				field: 'MachineN',
				width: 50,
				formatter: formatOper
			},
			{
				title: 'ȷ�Ͻ���',
				field: 'IsCmtEnterMachine',
				width: 100,
				styler: flagColor,
				formatter: function(value) {
					var status = "";
					if(value == "1") {
						status = "�����";
					} else {
						status = "δ���";
					}
					return status;
				}
			},
			{
				title: 'ID',
				field: 'ID',
				hidden: true
			}, {
				title: '������',
				field: 'MachineNo',
				width: 60,
				align:'right'
			}, {
				title: '��ϴ��ʽ',
				field: 'cleanType',
				width: 100
			}, {
				title: '����',
				field: 'CleanDate',
				width: 100
			}, {
				title: 'ʱ��',
				field: 'CleanTime',
				width: 100
			}, {
				title: '��ϴ�ܺ�',
				field: 'VehicleLabel',
				width: 100
			}, {
				title: '��ϴ����',
				field: 'CleanNo1',
				width: 150

			},
			{
				title: '��ϴ��',
				field: 'CleanerName',
				width: 100

			},
			{
				title: '������',
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
			var str = '<a href="#" name="operaM" class="easyui-linkbutton" disabled title="ɾ��"></a>';
			else 
			var str = '<a href="#" name="operaM" class="easyui-linkbutton" title="ɾ��" onclick="Del(' + row.ID + ',' + row.IsCmtEnterMachine + ')"></a>';
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
					$('#BarCode').attr("disabled", "disabled"); //��Ϊ������
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
					$('#BarCode').attr("disabled", "disabled"); //��Ϊ������
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
	//����ϴר����е��
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
		///���ó�ʼֵ ����ʹ������
		$("#cleandate").dateboxq("setValue", DateFormatter(new Date()));
		$('#cleantype').focus();
	}
	Default();

}

$(init);
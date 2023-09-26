var init = function() {
	var MainReqFlage="";
	//�������
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ReqLocBox = $HUI.combobox('#FReqLoc',{
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {	//Ĭ�ϵ�¼����
			
		}
	});
	//��Ӧ����
	var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocBox = $HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�һ��ֵ
			$("#FSupLoc").combobox('setValue',data[0].RowId);
		}
	});
	var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate
	}
	$UI.fillBlock('#MainCondition',Dafult)
	
	function Clear(){
		$UI.clear(ItemListGrid);
	}
	////===============================��ʼ�����end=============================	
	//��ѯ
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			query();
			Clear();
		}
	});
	$UI.linkbutton('#Print',{
		onClick:function(){
			var Detail = MainListGrid.getSelections();
			var DetailParams = JSON.stringify(Detail);
			if (isEmpty(Detail)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ����');
			}
			if (!isEmpty(Detail)) {
				$.each(Detail, function (index, item) {
					PrintINCallBackReq(item.RowId);
				});
			}
		}
	});
	function query(){ 
		var Params = JSON.stringify($UI.loopBlock('#CondTB'));
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageCallBack.PackageApplyAudit',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	//���������Ļس��¼����� end
	var MainCm = [[
		{
			title:'',
			id:"selectAll",
			field:'ck',
			checkbox:true,
			width:50
			
		},{
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		},{
			title: '����',
			field: 'No',
			width:100,
			fitColumns:true
		},{
			title: '�ܾ�ԭ��',
			field: 'RefuseReason',
			width:150,
			fitColumns:true,
			editor:{type:'validatebox'}
		},{
			title: '����״̬',
			field: 'ReqFlagNew',
			width:100,
			fitColumns:true
		},{
			title: '�ύʱ��',
			field: 'commitDate',
			width:150,
			fitColumns:true
		},{
			title: '�ύ��',
			field: 'commitUser',
			width:100,
			fitColumns:true
		},{
			title: '��������',
			field: 'ReqType',
			width:100,
			fitColumns:true
		},{
			title: '�����̶�',
			field: 'ReqLevel',
			width:100,
			fitColumns:true
		},{
			title: '�������',
			field: 'LocDesc',
			width:100,
			fitColumns:true
		}
	]];
	
	
	
	//ȷ��
	$UI.linkbutton('#AuditBT',{ 
		onClick:function(){
			audit();
			Clear();
		}
	});
	function audit(){
		var rows=MainListGrid.getChecked();
		var itemRows=ItemListGrid.getChangesData();
		if(rows.length!=0){
			var Params = JSON.stringify(rows);
			$.cm({
				ClassName: 'web.CSSDHUI.PackageCallBack.PackageApplyAudit',
				MethodName: 'jsAudit',
				Params:Params,
				ParamsItem:JSON.stringify(itemRows)
			},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				$('#MainList').datagrid('reload');
			}else{
				$UI.msg('error',jsonData.msg);
			}
			});
		}else{
			$UI.msg('alert',"��ѡ�񵥾�");
		}
	}
	
	//�ܾ�
	$UI.linkbutton('#RefuseBT',{ 
		onClick:function(){
			refuse();
			Clear();
		}
	});
	function refuse(){
		var rows=MainListGrid.getSelectedData();
		if (isEmpty(rows[0].RefuseReason)) {
			$UI.msg('alert','������ܾ�ԭ��!');
			return false;
		}
		if(rows.length!=0){
			var Params = JSON.stringify(rows);
			$.cm({
				ClassName: 'web.CSSDHUI.PackageCallBack.PackageApplyAudit',
				MethodName: 'jsRefuse',
				Params:Params
			},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				$('#MainList').datagrid('reload');
			}else{
				$UI.msg('error',jsonData.msg);
			}
			});
		}else{
			$UI.msg('alert',"��ѡ�񵥾�");
		}
	}
	
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageCallBack.PackageApplyAudit',
			QueryName: 'SelectAll'	,
			Params:JSON.stringify($UI.loopBlock('#CondTB'))
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
		selectOnCheck: false,
		onLoadSuccess:function(data){  
			if (data.rows.length > 0) {
				$('#MainList').datagrid("selectRow", 0);
				var Row = MainListGrid.getRows()[0]
				var Id = Row.RowId;
				FindItemByF(Id);
			}	
		},
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);
			}
			MainListGrid.commonClickCell(index,filed)
		}
	})
	//�����������б�
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
				var row = rows[ItemListGrid.editIndex];
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
			title: '����������',
			field: 'PackageDR',
			width:166,
			formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName')
		},{
			title: '��������',
			field: 'Qty',
			align: 'right',
			editor:{type:'validatebox'},
			width:100
		},{
			title: '��ע',
			field: 'Remark',
			width:166
		},{
            title: '������Ϣ',
            field: 'RemarkInfo',
            width:110,
			editor:{type:'validatebox'}
        }
	]]; 

	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.PackageCallBack.PackageApplyDetailAudit',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			pagination:false,
			singleSelect:false,
			showSaveItems:true,
			saveDataFn:function(){//������ϸ
 				var ItemRows = ItemListGrid.getChangesData();
 				if(isEmpty(ItemRows)) reutrn;
 				var RowMain=MainListGrid.getChecked();
 				if(isEmpty(RowMain)) return;
 				$.cm({
					ClassName: 'web.CSSDHUI.PackageCallBack.PackageApplyDetailAudit',
					MethodName: 'jsUpdateQty',
					Params: JSON.stringify(ItemRows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ItemListGrid.reload();
					}else{
						$UI.msg('alert',jsonData.msg);
					}
				});
			},
			onClickCell: function(index, field, value){
                ItemListGrid.commonClickCell(index, field);
            }
	});	
	
	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageCallBack.PackageApplyDetailAudit',
			QueryName: 'SelectByF',
			ApplyId:Id
		});
	}
	
}

$(init);

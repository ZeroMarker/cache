//ɾ����ϸ
function deleteItem(ItemRowId){
	if (isEmpty(ItemRowId)) {
			//$UI.msg('alert','��ѡ��Ҫɾ���ĵ���!');
			return false;
		}
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y") {
		$.messager.confirm("������ʾ","��ȷ��Ҫִ��ɾ��������",function(data){	
			if(data){
				$.cm({
					ClassName:'web.CSSDHUI.PackageDisp.DispItm',
					MethodName:'jsDelete',
					rowId:ItemRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#ItemList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		});
	}
	if (requiredDelete != "Y") {
		$.cm({
			ClassName : 'web.CSSDHUI.PackageDisp.DispItm',
			MethodName : 'jsDelete',
			rowId : ItemRowId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$('#ItemList').datagrid('reload');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
}
//ɾ�����ű�ǩ��ϸwhy0217
function deleteDispLabelItem(ItemRowId){
	if (isEmpty(ItemRowId)) {
			//$UI.msg('alert','��ѡ��Ҫɾ���ĵ���!');
			return false;
		}
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y") {
		$.messager.confirm("������ʾ","��ȷ��Ҫִ��ɾ��������",function(data){	
			if(data){
				$.cm({
					ClassName:'web.CSSDHUI.PackageDisp.DispDetail',
					MethodName:'jsDelete',
					rowId:ItemRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#ItemList').datagrid('reload');
						$('#ItemSList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		});
	}
	if (requiredDelete != "Y") {
		$.cm({
			ClassName : 'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName : 'jsDelete',
			rowId : ItemRowId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$('#ItemList').datagrid('reload');
				$('#ItemSList').datagrid('reload');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
}
//ɾ��������
//��һ��:�̵㵥���Ƿ����ɾ��
// �ڶ���ɾ��������
// ������ɾ���ӱ����� (�����޸Ĵ��������)Ŀǰ�Ĳ�����:����ϸ������ɾ��
function deleteMain(mainRowId){
	if (isEmpty(mainRowId)) {
			$UI.msg('alert','��ѡ��Ҫɾ���ĵ���!');
			return false;
		}
	$.messager.confirm("������ʾ","��ȷ��Ҫִ��ɾ��������",function(data){	
		if(data){	
			$.cm({
				ClassName:'web.CSSDHUI.PackageDisp.Disp',
				MethodName:'jsDelete',
				mainRowId:mainRowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#MainList').datagrid('reload');
					$('#ItemList').datagrid('reload');
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
   		}
	});
}
var GridListIndex = "";
var GridListIndexId = ""
//�ύ
function submitOrder(mainRowId){
	if (isEmpty(mainRowId)) {
			$UI.msg('alert','��ѡ��Ҫ�ύ�ĵ���!');
			return false;
		}
		var Rows = $('#MainList').datagrid("getRows");
		$.each(Rows,function(index,item){
			if(item.RowId==mainRowId){
				GridListIndex=index;
				GridListIndexId=mainRowId;
			}
		});
		$.cm({
			ClassName:'web.CSSDHUI.PackageDisp.Disp',
			MethodName:'jsSubmitOrder',
			mainRowId:mainRowId,
			gUser:gUserId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				$('#MainList').datagrid('reload');
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
}
//����
function cancelOrder(mainRowId){
	if (isEmpty(mainRowId)) {
			$UI.msg('alert','��ѡ��Ҫ�����ĵ���!');
			return false;
		}
	var requiredCancel = RequiredCancel();
	if (requiredCancel == "Y") {
		$.messager.confirm("������ʾ","��ȷ��Ҫִ�г���������",function(data){	
			if(data){
				var Rows = $('#MainList').datagrid("getRows");
				$.each(Rows,function(index,item){
					if(item.RowId==mainRowId){
						GridListIndex=index;
						GridListIndexId=mainRowId;
					}
				});
				$.cm({
					ClassName:'web.CSSDHUI.PackageDisp.Disp',
					MethodName:'jsCancelOrder',
					mainRowId:mainRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#MainList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		});
	}
}
///======================================�¼�����end=======================
var init = function() {
	var MainReqFlage="";
	//���ſ���
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�¼����
			$("#ReqLoc").combobox('setValue',gLocId);
		}
	});
	//���տ���
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//¥��
	var FloorBox = $HUI.combobox('#FloorCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFloorCode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�һ��ֵ
			//$("#FloorCode").combobox('setValue',data[0].RowId);
		},
		onSelect: function (row) {
                    if (row != null) {
						//alert(row.RowId);
                        $HUI.combobox('#LineCode', {
                          url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLineCode&ResultSetType=array&FloorCode='+row.RowId,
                          valueField: 'RowId',
                          textField: 'Description',
						  	onLoadSuccess: function (data) {   //Ĭ�ϵ�һ��ֵ
								$("#LineCode").combobox('setValue',data[0].RowId);
							}
                      }); 
                    }
                }

	});
	//������
	$("#toUser").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#toUser").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetPersonInfo',v);
			if(Ret.split('^')[0]=="Y"){
				$("#toUser").val(Ret.split('^')[2]);
				$("#toUserDr").val(Ret.split('^')[1]);
				$("#SterUser").focus();
			}else{
				$UI.msg('alert','δ�ҵ������Ϣ!');
				$("#SterUser").val("");
				$("#SterUser").focus();
			}
		}
	});
	//������
	var typeDetial="2"
	var PackageBox = $HUI.combobox('#PackageName', {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=' + typeDetial,
			valueField: 'RowId',
			textField: 'Description'
		});
	
	var Dafult={
		FStartDate:DefaultStDate(),
		FEndDate:DefaultEdDate
	}
	$UI.fillBlock('#MainCondition',Dafult)
	
	function Clear(){
		//$UI.clearBlock('#MainCondition');
		SupLocBox.reload();
		//$UI.fillBlock('#MainCondition',Dafult);
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
	}
	////===============================��ʼ�����end=============================
	
	//�������쵥
	$UI.linkbutton('#CreateBT',{ 
		onClick:function(){
			SelReq(function(){MainListGrid.reload();});
		}
	});
	//ͨ����������ɷ��ŵ�
	$UI.linkbutton('#CreateBTApply',{ 
		onClick:function(){
			SelReqApply(function(){MainListGrid.reload();});
		}
	});
	//��ѯ
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			query();
			Clear();
		}
	});
	//ɨ�붯���Զ��ύ
	$("#BarCode").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#BarCode").val();
			var row = $('#MainList').datagrid('getSelected');
			if(isEmpty(row)){
				$UI.msg('alert','��ѡ����Ҫ��ӵķ��ŵ���!');
				return;
			}
			if(isEmpty(row.RowId)){
				$UI.msg('alert','��������!');
				return;
			}
			if(isEmpty(v)){
				$UI.msg('alert','����¼��Ϊ��!');
				return;
			}
			//alert(row.RowId);
			var Rows = $('#MainList').datagrid("getRows");
				$.each(Rows,function(index,item){
					if(item.RowId==row.RowId){
						GridListIndex=index;
						GridListIndexId=row.RowId;
					}
			});
			$.cm({
				ClassName:'web.CSSDHUI.PackageDisp.DispDetail',
				MethodName:'jsSaveDetail',
				mainId:row.RowId,
				barCode:v,
				gUser:gUserId
			},function(jsonData){
				if(jsonData.success==0){
					//playSuccess();
					$UI.msg('success',jsonData.msg);
					ItemListGrid.reload();
					FindItemSByF(jsonData.rowid);
					IsCommit(row.RowId,gUserId);
				}else{
					//playWarn();
					$UI.msg('error',jsonData.msg);
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	function IsCommit(mainid,userdr){
		$.cm({
			ClassName:'web.CSSDHUI.PackageDisp.DispDetail',
			MethodName:'IsCommit',
			rowId:mainid,
			guser:userdr
			},function(jsonData){
				if(jsonData==0)
				{
					submitOrder(mainid);
				}
			});
		}
	function query(){
		$UI.clear(ItemListGrid);
		var Params = JSON.stringify($UI.loopBlock('#CondTB'));
		var GridListIndex = "";
		var GridListIndexId = "";
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.Disp',
			QueryName: 'SelectAll',
			//sort:'RowId',
			//order:'Desc',
			Params: Params
		});
	}
	//��ӡ����
	$UI.linkbutton('#Print', {
		onClick: function () {
			var Detail = MainListGrid.getChecked();
			var DetailParams = JSON.stringify(Detail);
			if (isEmpty(Detail)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ����');
			}
			if (!isEmpty(Detail)) {
				$.each(Detail, function (index, item) {
					PrintINDispReq(item.RowId);
				});
			}
			
		}
	});
	//�����ύ
	$UI.linkbutton('#submitAll', {
		onClick: function () {
			$.messager.confirm("������ʾ","��ȷ��Ҫִ�������ύ������",function(data){	
			if(data){
				var Detail = MainListGrid.getChecked();
				var DetailParams = JSON.stringify(Detail);
				if (isEmpty(Detail)) {
					$UI.msg('alert', '��ѡ����Ҫ�ύ����');
					return;
				}
				$.cm({
					ClassName:'web.CSSDHUI.PackageDisp.Disp',
					MethodName:'jsSubmitAll',
					Params:DetailParams,
					gUser:gUserId	
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#MainList').datagrid('reload');
					}else{
						$UI.msg('error',jsonData.msg);
					}
					});
				}
			});
		}
	});
	//���������Ļس��¼����� end
	var MainCm = [[{
				title : '',
				field : 'ck',
				checkbox : true,
				width : 50
			},{
		field:'operate',
		title:'����',
		align:'center',
		width:'100',
		formatter:function(value, row, index){
			if(row.ComplateFlag=="Y"){
				var str = '<a href="#" name="operaM" class="easyui-linkbutton" disabled title="ɾ��" onclick="deleteMain('+row.RowId+')"></a>';
				var str =str+ '<a href="#" name="operaR" class="easyui-linkbutton" title="����" onclick="cancelOrder('+row.RowId+')"></a>';
			}
			else {
				var str = '<a href="#" name="operaM" class="easyui-linkbutton" title="ɾ��" onclick="deleteMain('+row.RowId+')"></a>';
				var str =str+ '<a href="#" name="operaC" class="easyui-linkbutton" title="�ύ" onclick="submitOrder('+row.RowId+')"></a>';
			}
			return str;
		}
	},{
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		}, {
			title: '����',
			align:'left',
			field: 'No',
			width:150,
			fitColumns:true
		}, {
			title: '���ſ���',
			align:'left',
			field: 'FroLocDesc',
			width:150,
			fitColumns:true
		}, {
			title:'������',
			align:'left',
			field:'FUserDesc',
			width:150,
			fitColumns:true
		},{
			title:'��������',
			align:'left',
			field:'FDate',
			width:150,
			fitColumns:true
		}, {
			title: '���տ���',
			align:'left',
			field: 'TLocDesc',
			width:150,
			fitColumns:true
		}, {
			title: '��������',
			align:'left',
			field: 'Type',
			width:150,
			fitColumns:true
		},{
			title:'�ύ��',
			align:'left',
			field:'DispUserDesc',
			width:150,
			fitColumns:true
		}, {
			title: '�ύʱ��',
			align:'left',
			field: 'ChkDate',
			width:150,
			fitColumns:true
		},{
			title: '��ɱ�־',
			align:'left',
			field: 'ComplateFlag',
			width:100,
			fitColumns:true
		}
	]];

	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.Disp',
			QueryName: 'SelectAll',
			Params:JSON.stringify($UI.loopBlock('#CondTB'))
			//sort:'RowId',
			//order:'desc'
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
		selectOnCheck: false,
		//singleSelect: false,
		onLoadSuccess:function(data){  
			$("a[name='operaM']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
			$("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-upload'});  
			$("a[name='operaR']").linkbutton({text:'',plain:true,iconCls:'icon-back'});  
			if(data.rows.length>0&&isEmpty(GridListIndex)){
				$('#MainList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].RowId);
			}
			if(!isEmpty(GridListIndex)){
				$('#MainList').datagrid("selectRow", GridListIndex);
				FindItemSByF(GridListIndexId);
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
	
//========================================��������ϸ====start==============	
	//�����������б�
	var packData=$.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
			QueryName: 'GetPackage'	,
			ResultSetType:"array",
			typeDetial: "2,7"
	},false);
	var PackageBox = {
		type: 'combobox',
		options: {
			data:packData,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
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
	var ItemCm = [[{
		field:'operate',title:'����',align:'center',width:50,
			formatter:function(value, row, index){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y"){
					var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="ɾ��" onclick="deleteItem('+row.RowId+')"></a>';
				}else{
					var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="ɾ��" onclick="deleteItem('+row.RowId+')"></a>';
				}
				return str;
			}
		},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: 'CallBackDetailDr',
			field: 'CallBackDetailDr',
			width:100,
			hidden: true
		},{
			title: '����������',
			align:'left',
			field: 'PackageDR',
			width:140,
			formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName'),
			editor: PackageBox
		},{
			title: '����������',
			align:'right',
			field: 'Qty',
			width:100,
			editor:{type:'numberbox',options:{required:true}}
		} ,
		{
			title: '��������',
			align:'right',
			field: 'DispQty',
			width:100
		}
	]]; 
	 $UI.linkbutton('#AddBT',{ 
		onClick:function(){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.ComplateFlag=="Y") return false;
			ItemListGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function(){
			var ItemRowId="";
			var rowMain = $('#ItemList').datagrid('getSelected');
			if(!isEmpty(rowMain)){
				ItemRowId = rowMain.RowId;
			}
			if(isEmpty(ItemRowId)&&!isEmpty(rowMain)){
				ItemListGrid.commonDeleteRow();
				return false;
			}
			if (isEmpty(rowMain)) {
				$UI.msg('alert','��ѡ��Ҫɾ���ĵ���!');
				 return false;
			}
			var MainObj = $('#MainList').datagrid('getSelected');
			if(MainObj.ComplateFlag != "Y"){	
				deleteItem(ItemRowId);
			}else{
				$UI.msg('alert',"�������ύ����ɾ����ϸ!");
			}
		}
	});
	//���浥��
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.ComplateFlag=="Y") return false;
			var Rows=ItemListGrid.getChangesData();	
			if(isEmpty(Rows)){
				//$UI.msg('alert','û����Ҫ�������Ϣ!');
				return;
			}
			var rowMain = $('#MainList').datagrid('getSelected');
			$.cm({
				ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				MainId:rowMain.RowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					ItemListGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			toolbar:'#Itembr',
			pagination:false,
			singleSelect:false,
			onLoadSuccess:function(data){  
				$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
				if(data.rows.length>0){
					$('#ItemList').datagrid("selectRow", 0)
						$("#BarCode").val("").focus();
						
				}
			},
			//showAddSaveDelItems: true,
			//toolbar:'#itmtd',
			//showAddSaveItems: true,
			//showSaveItems:true,
			/* saveDataFn:function(){//������ϸ
				var Rows=ItemListGrid.getChangesData();	
				if(isEmpty(Rows)){
					//$UI.msg('alert','û����Ҫ�������Ϣ!');
					return;
				}
				var rowMain = $('#MainList').datagrid('getSelected');
				$.cm({
					ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
					MethodName: 'jsSave',
					Params: JSON.stringify(Rows),
					MainId:rowMain.RowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ItemListGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}, */
			/* beforeDelFn:function(){
				var ItemRowId="";
				var rowMain = $('#ItemList').datagrid('getSelected');
				if(!isEmpty(rowMain)){
					ItemRowId = rowMain.RowId;
				}
				if (isEmpty(rowMain)) {
					$UI.msg('alert','��ѡ��Ҫɾ���ĵ���!');
				 	return false;
				}
				var MainObj = $('#MainList').datagrid('getSelected');
				if(MainObj.ComplateFlag != "Y"){	
				deleteItem(ItemRowId);
				}else{
					$UI.msg('alert',"�������ύ����ɾ����ϸ!");
				}
			}, */
			onClickCell: function(index, field, value){
				var Row=ItemListGrid.getRows()[index]
				var Id = Row.PackageDR;
				var DispId = Row.RowId;
				if(!isEmpty(DispId)){
					FindItemSByF(DispId);
				}	
				ItemListGrid.commonClickCell(index, field);
			},
			/* beforeAddFn:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y") return false;
			}, */
			onBeforeEdit:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y") return false;
			},
			onAfterEdit:function(rowIndex,rowData){
				if(!isEmpty(rowData.RowId)){
					$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
            }
		}
			
	});	
	
	function FindItemByF(Id) {
		$UI.clear(ItemListGrid);
		$UI.clear(ItemSListGrid);
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispItm',
			QueryName: 'SelectByF',
			MainId:Id
		});
	}
//=========================��������ϸend====================
//���ű�ǩ��ϸ
	var ItemSCm = [[{
		field:'operate',title:'����',align:'center',width:50,
			formatter:function(value, row, index){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y"){
					var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="ɾ��" onclick="deleteDispLabelItem('+row.RowId+')"></a>';
				}else{
					var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="ɾ��" onclick="deleteDispLabelItem('+row.RowId+')"></a>';
				}
				return str;
			}
		},
        {
            title: 'RowId',
            field: 'RowId',
            width:100,
            hidden: true
        },{
		    title: '����������',
            field: 'PackageName',
            align: 'left',
            width:180
		},{
            title: '��ǩ',
            field: 'Label',
            align: 'right',
            width:180
        }
    ]]; 

    var ItemSListGrid = $UI.datagrid('#ItemSList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			QueryName: 'SelectByF'
		},
		columns: ItemSCm,
		pagination:false,
		onLoadSuccess:function(data){  
				$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
				if(data.rows.length>0){
					$('#ItemSList').datagrid("selectRow", 0)
				}
		}
    }); 
    ///���ݷ�����ϸ��id������ǩ��ϸ
    function FindItemSByF(Id) {
        ItemSListGrid.load({
            ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
            QueryName: 'SelectByF',
            DispId:Id
        });
    }
}
$(init);

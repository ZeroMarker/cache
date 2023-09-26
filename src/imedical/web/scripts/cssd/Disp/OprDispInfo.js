////����������
//ɾ����ϸ
function deleteItem(ItemRowId){
	if (isEmpty(ItemRowId)) {
			$UI.msg('alert','��ѡ��Ҫɾ���ĵ���!');
			return false;
		}
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y") {
		$.messager.confirm("������ʾ","��ȷ��Ҫִ��ɾ��������",function(data){
			if(data){
				$.cm({
					ClassName:'web.CSSDHUI.Disp.DispItem',
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
			ClassName : 'web.CSSDHUI.Disp.DispItem',
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
//ɾ��������

function deleteMain(mainRowId){
	if (isEmpty(mainRowId)) {
			$UI.msg('alert','��ѡ��Ҫɾ���ĵ���!');
			return false;
		}
	$.messager.confirm("������ʾ","��ȷ��Ҫִ��ɾ��������",function(data){
		if(data){
			$.cm({
				ClassName:'web.CSSDHUI.Disp.Disp',
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
//�ύ
function submitOrder(mainRowId){
	if (isEmpty(mainRowId)) {
			$UI.msg('alert','��ѡ��Ҫ�ύ�ĵ���!');
			return false;
		}
		$.cm({
			ClassName:'web.CSSDHUI.Disp.Disp',
			MethodName:'jsSubmitOrder',
			MainId:mainRowId,
			gUser:gUserId
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
				$.cm({
					ClassName:'web.CSSDHUI.Disp.Disp',
					MethodName:'jsCancelOrder',
					MainId:mainRowId
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

var init = function() {
	//���ſ���
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var ReqLocBox = $HUI.combobox('#fromLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�¼����
			$("#fromLocDr").combobox('setValue',gLocId);
		}
	});
	//���տ���
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#toLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//������
	$("#fromUser").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#fromUser").val();
			var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetPersonInfo',v);
			if(Ret.split('^')[0]=="Y"){
				$("#fromUser").val(Ret.split('^')[2]);
				$("#fromUserDr").val(Ret.split('^')[1]);
				//saveMast();
			}else{
				$UI.msg('alert','δ�ҵ������Ϣ!');
				$("#fromUser").val("");
				$("#fromUser").focus();
			}
		}
	});
	var Dafult={
			FStartDate:DefaultStDate(),
			FEndDate:DefaultEdDate
	}
	$UI.fillBlock('#MainCondition',Dafult)
	
	function Clear(){
		SupLocBox.reload();
		$UI.fillBlock('#MainCondition',Dafult);
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
	}
	
	//���浥��
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			saveMast()
		}
	});
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
	function saveMast(){
		var MainObj = $UI.loopBlock('#MainCondition');
		if(MainObj.fromLocDr==MainObj.toLocDr){
			$UI.msg('alert',"���ſ��Һͽ��տ��Ҳ�����ͬ");
			return;
		}
		if(ParamObj['RequiredDispUser']=="Y"&&isEmpty(MainObj.fromUserDr)){
			$UI.msg('alert',"�����˲���Ϊ��");
			return false;
		}else{
			if(isEmpty(MainObj.fromUserDr)){
				MainObj.fromUserDr=gUserId;
			}
		}
		if( isEmpty(MainObj.fromUserDr)){
			$UI.msg('alert',"�����˲���Ϊ��");
			return;
		}
		if(isEmpty(MainObj.toLocDr)){
			$UI.msg('alert',"���տ��Ҳ���Ϊ��");
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.Disp.Disp',
			MethodName: 'jsSave',
			Params: JSON.stringify(MainObj)
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success',jsonData.msg);
				FindNew(jsonData.rowid);
				//alert(jsonData.success);
				$("#BarCode").focus(); //�����ȡ������
				MainListGrid.reload();
			}else{
				alert("fail");
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	//��ѯ
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			$UI.clear(MainListGrid);
			$UI.clear(ItemListGrid);
			query();
			//Clear();
		}
	});
	 function query(ParamsObj){ 
	 	var Params = JSON.stringify($UI.loopBlock('#UomTB'));
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Disp.Disp',
			QueryName: 'SelectAll',
			parame: Params
		});
	}
//========================����start===================	
	//���������Ļس��¼����� end
	var MainCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, 
		{
		field:'operate',
		title:'����',
		align:'center',
		width:100,
		formatter:function(value, row, index){
			if(row.ComplateFlag=="Y"){
				var str = '<a href="#" name="operaM" class="easyui-linkbutton" disabled title="ɾ��" onclick="deleteMain('+row.RowId+')"></a>';
				var str =str+ '<a href="#" name="operaR" class="easyui-linkbutton" title="����" onclick="cancelOrder('+row.RowId+')"></a>';
			}else {
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
			title: '���ŵ���',
			field: 'No',
			width:120,
			fitColumns:true
		}, {
			title: '���ſ���',
			field: 'FromLocDesc',
			width:100,
			fitColumns:true
		}, {
			title: '���տ���',
			field: 'ToLocDesc',
			width:100,
			fitColumns:true
		}, {
			title: '������',
			field: 'FromUserDesc',
			width:100,
			fitColumns:true
		}, {
			title: '����ʱ��',
			field: 'DispDate',
			width:150,
			fitColumns:true
		}, {
			title: '�ύ��',
			field: 'DispCHKUserDesc',
			width:100,
			fitColumns:true
		}, {
			title: '�ύʱ��',
			field: 'DispCHKDate',
			width:150,
			fitColumns:true
		}, {
			title: '��ɱ�־',
			field: 'ComplateFlag',
			width:100,
			fitColumns:true
		}
	]];
	
	//var map = {};
	var Params = JSON.stringify($UI.loopBlock('#UomTB'));
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Disp.Disp',
			QueryName: 'SelectAll',
			parame:Params
		},
		columns: MainCm,
		toolbar: '#UomTB',
		lazy:false,
		selectOnCheck: false,
		onLoadSuccess:function(data){
			$("a[name='operaM']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
			$("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-upload'});
			$("a[name='operaR']").linkbutton({text:'',plain:true,iconCls:'icon-back'});
			if(data.rows.length>0){
				$('#MainList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].RowId);
				/* for(var i=0;i< data.rows.length;i++){
					map[i] = false;
				} */
			}	
		},
		/* onClickRow: function (rowIndex, rowData) {
			if (map[rowIndex]) {
				map[rowIndex]=false;
				$("#MainList").datagrid("unselectRow", rowIndex);
			}else{
				map[rowIndex]=true;
				$("#MainList").datagrid("selectRow", rowIndex);
			}
		}, */
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				FindItemByF(Id);
			}	
			MainListGrid.commonClickCell(index,filed)
		}
})
///=============================����end===================
///=============================�ӱ�start======================
		//ɨ�붯��
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
			$.cm({
				ClassName:'web.CSSDHUI.Disp.DispItem',
				MethodName:'jsSaveDetail',
				mainId:row.RowId,
				barCode:v
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					//$("#BarCodeInfo").val(jsonData.msg)
					ItemListGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	var ItemCm = [[
		{field:'operate',title:'����',align:'center',width:120,
		formatter:function(value, row, index){
			var rowMain = $('#MainList').datagrid('getSelected');
			if(rowMain.ComplateFlag=="Y"){
				var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="ɾ��" onclick="deleteItem('+row.RowId+')"></a>';
			}else{
				var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="ɾ��" onclick="deleteItem('+row.RowId+')"></a>';
			}
			return str;
	}},{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '����',
			field: 'Label',
			width:150
		},{
			title: '����������',
			field: 'PackageName',
			width:200
		},{
			title: '����',
			field: 'Qty',
			align:'right',
			width:80
		}
	]];

	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.Disp.DispItem',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			toolbar: '#InputTB',
			pagination:false,
			singleSelect:false,
			onLoadSuccess:function(data){
				$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
			}
	});	
	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Disp.DispItem',
			QueryName: 'SelectByF',
			MainId:Id
		});
	}
	function FindNew(Id){
		MainListGrid.load({
		ClassName: 'web.CSSDHUI.Disp.Disp',
		QueryName: 'FindNew',
		ID:Id
		});
	}
	
	
}
$(init);
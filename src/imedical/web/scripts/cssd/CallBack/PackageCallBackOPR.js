//ɾ����ϸ
function deleteItem(ItemRowId){
	var requiredDelete = RequiredDelete();
	if (requiredDelete == "Y"&&!isEmpty(ItemRowId)) {
		$.messager.confirm("������ʾ","��ȷ��Ҫִ�в�����",function(data){	
   			if(data){	
				$.cm({
					ClassName:'web.CSSDHUI.CallBack.CallBackItm',
					MethodName:'jsDelete',
					rowId:ItemRowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#ItemList').datagrid('reload');
						$('#ItemSList').datagrid('loadData',[]);
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		});
	}
	if (requiredDelete != "Y") {
		$.cm({
					ClassName : 'web.CSSDHUI.CallBack.CallBackItm',
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
//��һ��:�̵㵥���Ƿ����ɾ��
// �ڶ���ɾ��������
// ������ɾ���ӱ����� (�����޸Ĵ��������)Ŀǰ�Ĳ�����:����ϸ������ɾ��
function deleteMain(mainRowId){
	if (isEmpty(mainRowId)) {
		    $UI.msg('alert','��ѡ��Ҫɾ���ĵ���!');
		    return false;
		}
	$.messager.confirm("������ʾ","��ȷ��Ҫִ�в�����",function(data){	
   		if(data){	
			$.cm({
				ClassName:'web.CSSDHUI.CallBack.CallBack',
				MethodName:'jsDelete',
				mainRowId:mainRowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#MainList').datagrid('reload');
					$('#ItemList').datagrid('reload');
				}else{
					$UI.msg('alert',jsonData.msg);
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
			ClassName:'web.CSSDHUI.CallBack.CallBack',
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
		$.messager.confirm("������ʾ","��ȷ��Ҫִ�в�����",function(data){	
			if(data){
				var Rows = $('#MainList').datagrid("getRows");
				$.each(Rows,function(index,item){
					if(item.RowId==mainRowId){
						GridListIndex=index;
						GridListIndexId=mainRowId;
					}
				});
				$.cm({
					ClassName:'web.CSSDHUI.CallBack.CallBack',
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
	if (requiredCancel != "Y") {
    	$.cm({
                    ClassName:'web.CSSDHUI.CallBack.CallBack',
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
}
///======================================�¼�����end=======================
var init = function() {
	$("#ReqLoc").focus();
	var MainReqFlage="";
	//��Ӧ����
	var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�һ��ֵ
			$("#SupLoc").combobox('setValue',data[0].RowId);
		}
	});
	//���տ���
	$("#ReqLoc").keypress(function(event) {
	  if ( event.which == 13 ) {
	  	var v=$("#ReqLoc").val();
	  	var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetLocId',v);
	  	if(Ret.split('^')[0]=="Y"){
	  		$("#ReqLoc").val(Ret.split('^')[2]);
	  		$("#fromLocDr").val(Ret.split('^')[1]);
	   		$("#toUser").focus();
	  	}else{
	  		$UI.msg('alert','δ�ҵ������Ϣ!');
	  		$("#ReqLoc").val("");
	  		$("#ReqLoc").focus();
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
	   		saveMast();
			$("#ReqLoc").val("");
			$("#toUser").val("");
			$("#ReqLoc").focus();
	  	}else{
	  		$UI.msg('alert','δ�ҵ������Ϣ!');
	  		$("#toUser").val("");
	  		$("#toUser").focus();
	  	}
	   }
	});
	
	var Dafult={
		FStartDate:DefaultStDate(),
		FEndDate:DefaultEdDate
	}
    $UI.fillBlock('#MainCondition',Dafult)
	
	function Clear(){
		//$UI.clearBlock('#MainCondition');
		//SupLocBox.reload();
		//$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
		$UI.clear(ItemSListGrid);
	}
	////===============================��ʼ�����end=============================
	//���浥��
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			saveMast()
		}
	});
	function saveMast(){
		var MainObj = $UI.loopBlock('#MainCondition');
		var GridListIndex = "";
		var GridListIndexId = "";
		if(MainObj.fromLocDr==MainObj.toLocDr){
			$UI.msg('alert',"���տ��Һ͹�Ӧ���Ҳ�����ͬ");
			$("#toUser").val("");
			$("#ReqLoc").val("");
			$("#ReqLoc").focus();
			return;
		}
		if( isEmpty(MainObj.toUserDr)){
			$UI.msg('alert',"�����˲���Ϊ��");
			return;
		}
		if(isEmpty(MainObj.fromLocDr)){
			$UI.msg('alert',"���տ��Ҳ���Ϊ��");
			return;
		}
		$.cm({
					ClassName: 'web.CSSDHUI.CallBack.CallBack',
					MethodName: 'jsSave',
					Params: JSON.stringify(MainObj)
				},function(jsonData){
					$UI.msg('success',jsonData.msg);
					if(jsonData.success==0){
						MainListGrid.reload();
					}
				});
	}
	
	//��ѯ
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Clear();
			FindWin(query);
		}
	});
	 function query(ParamsObj){ 
	 	var Params = JSON.stringify(ParamsObj);
	 	var GridListIndex = "";
		var GridListIndexId = "";
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			QueryName: 'SelectAll',
			Params: Params,
			FIsOPRFlag: FIsOPRFlag
		});
	}
	
	//���������Ļس��¼����� end
	var MainCm = [[{
		field:'operate',
		title:'����',
		align:'center',
		width:100,
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
			field: 'No',
			align: 'left',
			width:120,
			fitColumns:true
		}, {
			title: '���տ���',
			field: 'FroLocDesc',
			width:100,
			fitColumns:true
		}, {
			title: '�Ƿ��ύ',
			field: 'ComplateFlag',
			width:100,
			fitColumns:true,
			formatter:function(v){
				if(v=="Y")return "��";
				else return "��";
			}
		}, {
			title: '��������',
			field: 'CBDate',
			width:100,
			align: 'left',
			fitColumns:true
		},{
			title: '����ʱ��',
			field: 'CBTime',
			width:100,
			align: 'left',
			fitColumns:true
		},{
			title: '������',
			field: 'ToUser',
			width:100,
			fitColumns:true
		}, 
		{
			title: '�ύ����',
			field: 'AckDate',
			width:100,
			align: 'left',
			fitColumns:true
		},{
			title: '�ύ��',
			field: 'AckUserDesc',
			width:100,
			fitColumns:true
		}
	]];

	var FIsOPRFlag = "Y";
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			QueryName: 'SelectAll',
			Params:JSON.stringify($UI.loopBlock('#MainCondition')),
			FIsOPRFlag:FIsOPRFlag
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
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
						FindItemByF(GridListIndexId);
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
	
	var ItemCm = [[
	{field:'operate',title:'����',align:'center',width:80,
			formatter:function(value, row, index){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y"){
					var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="ɾ��" onclick="deleteItem('+row.RowId+')"></a>';
				}else{
					var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="ɾ��" onclick="deleteItem('+row.RowId+')"></a>';
				}
				return str;
		}},	{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '����������',
			field: 'PackageName',
			width:130
		},{
			title: '����������',
			field: 'packageDesc',
			width:130,
			hidden:true
		},{
			title: '������rowid',
			field: 'PackageDR',
			width:130,
			hidden:true
		},{
			title: '�����Ʊ���',
			field: 'DictLabel',
			width:130,
			align: 'left'
		},{
			title: '������',
			field: 'PackageLabel',
			width:130,
			align: 'left'
		},{
			title: '��������',
			field: 'Qty',
			width:80,
			align: 'right'
		},{
			title: '����ҽ��',
			field: 'oprDoctor',
			width:150
		},{
			title: '��㻤ʿ',
			field: 'instNurse',
			width:150
		},{
			title: 'Ѳ�ػ�ʿ',
			field: 'circNurse',
			width:150
		},{
			title: '��Ⱦ��Ϣ',
			field: 'infectName',
			width:150
		},{
			title: '���ʱ��',
			field: 'oprDt',
			width:150
		},{
				title: "׷����Ϣ",
				field: 'track',
				width: 150,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='TranInfoWin(\"" + row.PackageLabel + "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/location.png' title='������Ϣ' border='0'></a>";
					return str;
				}
			},{
				title: "ͼƬ��Ϣ",
				field: 'Icon',
				width: 150,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='ViewPic(" + row.PackageDR + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='�鿴ͼƬ' border='0'></a>";
					return str;
				}
			}
	]]; 
	//���������ѯ��Ϣ�Է���ֵ�Ĵ���
	function ReturnInfoFunc(row,BarCodeData){
		ItemListGrid.updateRow({
			index:ItemListGrid.editIndex,
			row: {
				PackageLabel:BarCodeData['packageLabel'],
				PackageName:BarCodeData['LabelName'],
				packageDesc:BarCodeData['packageDesc'],
				PackageDR:BarCodeData['packagedr'],
				Qty:1,
				oprDoctor:BarCodeData['UserInfo']['oprDoctor'],
				instNurse:BarCodeData['UserInfo']['instNurse'],
				circNurse:BarCodeData['UserInfo']['circNurse'],
				infectName:BarCodeData['UserInfo']['infectName'],
				oprDt:BarCodeData['UserInfo']['oprDt']
			}
		});
		var RowIndex = $('#ItemList').datagrid('getRowIndex', row);
		$('#ItemList').datagrid('refreshRow', RowIndex);
	}
	
	//ɨ����ӹ̶���ǩ
	$("#BarCode").keypress(function(event) {
		if(event.which == 13) {
			var BarCode = $("#BarCode").val();
			var BarCodeData =  $.cm({
				ClassName: 'web.CSSDHUI.CallBack.CallBack',
				MethodName: 'GetCallbackLabelInfo',
				label: BarCode
			},false);
			if(!isEmpty(BarCodeData.success) && BarCodeData.success<0){
				$UI.msg('alert',BarCodeData.msg)
				$("#BarCode").val('').focus;
				return false;
			}
			var rowMain = $('#MainList').datagrid('getSelected');
			ItemListGrid.commonAddRow();
			var row = $('#ItemList').datagrid('getSelected');
			row['DictLabel']=BarCode
			ReturnInfoFunc(row,BarCodeData);
			var Rows=ItemListGrid.getChangesData();
			if(isEmpty(rowMain)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӵĵ���!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
				MethodName: 'jsSave',
				MainId: rowMain.RowId,
				Params:JSON.stringify(Rows)
			}, function(jsonData) {
				if(jsonData.success == 0) {
					$("#BarCodeInfo").val(jsonData.msg)
					ItemListGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	
	var ItemListGrid = $UI.datagrid('#ItemList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
				MethodName: 'SelectByF'
			},
			columns: ItemCm,
			pagination:false,
			toolbar: '#CodeTB',
			onLoadSuccess:function(data){  
			    $("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
			    if(data.rows.length>0){
					$('#ItemList').datagrid("selectRow", 0)
					FindItemSByF(data.rows[0].PackageDR,data.rows[0].PackageLabel);
				}	
			},
			onClickCell: function(index, field, value){
				var Row=ItemListGrid.getRows()[index]
				var Id = Row.PackageDR;
				var Label = Row.PackageLabel
				if(!isEmpty(Id)&&!isEmpty(Label)){
					FindItemSByF(Id,Label);
				}	
				ItemListGrid.commonClickCell(index, field);
			},
			beforeAddFn:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y") return false;
			},
			onBeforeEdit:function(){
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y") return false;
			},
			onAfterEdit:function(){
            	$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
            }
	});	
	function FindItemByF(Id) {
		$UI.clear(ItemSListGrid);
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			QueryName: 'SelectByF',
			MainId:Id
		});
	}
//=========================��������ϸend====================
//=========================��е��ϸ==start======================
	// ���ϸ�ԭ������
	var packData = $.cm({
				ClassName : 'web.CSSDHUI.Common.Dicts',
				QueryName : 'GetConsumeReason',
				ResultSetType : "array",
				typeDetial : "2"
			}, false);
	var ReasonBox = {
		type : 'combobox',
		options : {
			data : packData,
			valueField : 'RowId',
			textField : 'Description',
			onSelect : function(record) {
				var rows = ItemSListGrid.getRows();
				var row = rows[ItemSListGrid.editIndex];
				row.ConsumeReasonName = record.Description;
			},
			onShowPanel : function() {
				$(this).combobox('reload')
			}
		}
	};
	var ItemSCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		},{
			title: '��е����',
			field: 'Desc',
			width:100
		},{
			title: '���',
			field: 'Spec',
			width:100
		},{
			title: '����',
			field: 'Qty',
			align: 'right',
			width:70
		},{
			title: 'ȱ������',
			field: 'ConsumeQty',
			align: 'right',
			width:70,
			editor:{type:'numberbox'}
		},{
			title: 'ȱʧԭ��',
			field: 'ConsumeReasonDR',
			width:100,
			formatter: CommonFormatter(ReasonBox, 'ConsumeReasonDR', 'ConsumeReasonName'),
			editor: ReasonBox
		},{
			title: '�Ƿ�����',
			field: 'NotUseFlag',
			width:130,
			hidden: true
		},{
			title: '��ע',
			field: 'Remarks',
			width:100
		}
	]]; 

	var ItemSListGrid = $UI.datagrid('#ItemSList', {
			queryParams: {
				ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
				QueryName: 'SelectByLabel'
			},
			columns: ItemSCm,
			pagination:false,
			showSaveItems:true,
			saveDataFn:function(){//������ϸ
				var MainObj=$UI.loopBlock('#MainCondition');
				var fromLocDr=MainObj.fromLocDr
				var Rows=ItemSListGrid.getChangesData();
				if(isEmpty(Rows)){
					$UI.msg('alert','û����Ҫ�������Ϣ!');
					return;
				}
				var ItemRow = $('#ItemList').datagrid('getSelected');
				var rowMain = $('#MainList').datagrid('getSelected');
				if(rowMain.ComplateFlag=="Y"){
					$UI.msg('alert','�����Ѿ��ύ�޷��޸�!');
					return;
				}
				$.cm({
					ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
					MethodName: 'jsAddConsume',
					Params:JSON.stringify(Rows),
					PackageLabel:ItemRow.PackageLabel,
					LocDr:fromLocDr,
					CallBackDr:$('#MainList').datagrid('getSelected').RowId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						ItemSListGrid.reload();
					}else{
						$UI.msg('alert',jsonData.msg);
					}
				});
			},
			onLoadSuccess:function(data){
			},
			onBeforeCellEdit: function(index, field){
            	var RowData = $(this).datagrid('getRows')[index];
            	if(RowData['NotUseFlag']=="N"){
            		$UI.msg('alert','����е�ѱ�ͣ�ã������޸�!');
               		return false;
            	}
        	},
			onClickCell: function(index, field, value){
                ItemSListGrid.commonClickCell(index, field);
            }
	});	
	///����������dr��ѯ��������е��ϸ
	function FindItemSByF(Id,Label) {
		ItemSListGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			QueryName: 'SelectByLabel',
			PackageRowId:Id,
			PackageLabel:Label
		});
	}
//=========================��е��ϸ end========================
}
$(init);

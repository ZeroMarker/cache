////����������
//����

function ReceOrder(mainRowId){
	if (isEmpty(mainRowId)) {
		    $UI.msg('alert','��ѡ��Ҫ�ύ�ĵ���!');
		    return false;
		}
		var UserId=gUserId;
		var MainObj = $UI.loopBlock('#MainCondition');
		if(ParamObj['RequiredReceiveUser']=="Y"){
			UserId=MainObj.toUserDr
			if( isEmpty(MainObj.toUserDr)){
				$UI.msg('alert',"�����˲���Ϊ��");
				return false;
			}
		}
		$.cm({
			ClassName:'web.CSSDHUI.Disp.Disp',
			MethodName:'jsReceOrder',
			mainRowId:mainRowId,
			UserId:UserId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				$('#MainList').datagrid('reload');
				$('#ItemList').datagrid('loadData',[]);
//				$UI.clear(ItemListGrid);
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
		textField: 'Description'
	});
	//���տ���
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#toLocDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //Ĭ�ϵ�һ��ֵ
			$("#toLocDr").combobox('setValue',gLocId);
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
	  	}else{
	  		$UI.msg('alert','δ�ҵ������Ϣ!');
	  		$("#toUser").val("");
	  		$("#toUser").focus();
	  	}
	   }
	});
	
	//���浥��
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			saveMast()
		}
	});
	function saveMast(){
		var MainObj = $UI.loopBlock('#MainCondition');
		if(MainObj.fromLocDr==MainObj.toLocDr){
			$UI.msg('alert',"������Һ͹�Ӧ���Ҳ�����ͬ");
			return;
		}
		if( isEmpty(MainObj.fromUserDr)){
			$UI.msg('alert',"�����˲���Ϊ��");
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.Disp.Disp',
			MethodName: 'jsSave',
			Params: JSON.stringify(MainObj)
		},function(jsonData){
			$UI.msg('success',jsonData.msg);
			if(jsonData.success==0){
				$("#BarCode").focus(); //�����ȡ������
				MainListGrid.reload();
			}
		});
	}
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
	//��ѯ
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			query();
			$UI.clear(ItemListGrid);
			//Clear();
		}
	});
	 function query(){ 
	 	 var Params = JSON.stringify($UI.loopBlock('#UomTB'));
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Disp.Disp',
			QueryName: 'SelectAll',
			parame: Params
		});
	}
	
	//��������
	$UI.linkbutton('#ReceAll', {
		onClick: function () {
			$.messager.confirm("������ʾ","��ȷ��Ҫִ���������ղ�����",function(data){	
			if(data){
				var Detail = MainListGrid.getChecked();
				if (isEmpty(Detail)) {
					$UI.msg('alert', '��ѡ����Ҫ���յĵ���!');
					return;
				}
				var UserId=gUserId;
				var MainObj = $UI.loopBlock('#MainCondition');
				if(ParamObj['RequiredReceiveUser']=="Y"){
					UserId=MainObj.toUserDr
					if(isEmpty(MainObj.toUserDr)){
						$UI.msg('alert',"�����˲���Ϊ��");
						return false;
					}
				}
				var DetailParams = JSON.stringify(Detail);
				$.cm({
					ClassName:'web.CSSDHUI.Disp.Disp',
					MethodName:'jsReceAll',
					Params:DetailParams,
					UserId:UserId	
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						$('#MainList').datagrid('reload');
						$('#ItemList').datagrid('loadData',[]);
					}else{
						$UI.msg('error',jsonData.msg);
					}
					});
				}
			});
		}
	});

	
//========================����start===================	
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
		width:100,
		//hidden:ParamObj['ScanLabelForRes']=="Y",
		formatter:function(value, row, index){
			if(row.IsRec=="N"){
				var str ='<a href="#" name="operaC" class="easyui-linkbutton" title="����" onclick="ReceOrder('+row.RowId+')"></a>';
			}else {
				var str ='<a href="#" name="operaY" disabled class="easyui-linkbutton" title="�ѽ���"></a>';
			}
			return str;
		}
		},{
			title: '����״̬',
				field: 'RecStatu',
				width: 100,
				styler: flagColor,
				align:'center',
				formatter: function(value) {
					var status = "";
					if(value == "1") {
						status = "�ѽ���";
					} else {
						status = "δ����";
					}
					return status;
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
			field: 'ToUserDesc',
			width:100,
			fitColumns:true
		}, {
			title: '����ʱ��',
			field: 'RecDate',
			width:150,
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
			fitColumns:true,
			hidden:true
		}, {
			title: '�Ƿ��ύ',
			field: 'IsRec',
			width:100,
			fitColumns:true,
			hidden:true
		}
	]];
	function flagColor(val, row, index) {
		if(val == '1') {
			return 'background:#15b398;color:white';
		}else{
			return 'background:#ff584c;color:white';
		}
	}
	
	
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Disp.Disp',
			QueryName: 'SelectAll',
			parame:'{"FComplateFlag":"Y","FStatu":"2"}'
		},
		columns: MainCm,
		toolbar: '#UomTB',
		lazy:false,
		singleSelect: false,
		onLoadSuccess:function(data){  
	        $("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-download'});
	        $("a[name='operaY']").linkbutton({text:'',plain:true,iconCls:'icon-ok'}); 
	        if(data.rows.length>0){
				$('#MainList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].RowId);
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
				ItemListGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
			//$("#BarCode").val("").focus();
		});
	  }
});
	var ItemCm = [[
		{
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
			width:150
		},{
			title: '����',
			field: 'Qty',
			align:'right',
			width:50
		},{
			title: '������',
			field: 'ToUserDesc',
			width:100
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
	
	
	
}   
$(init);
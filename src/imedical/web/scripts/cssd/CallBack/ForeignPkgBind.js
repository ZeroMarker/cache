var init = function() {
	//�������
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	///return:��ʼ����
	function DefaultStDate(){
		var Today = new Date();
		return DateFormatter(Today);	
		
	}
	var Dafult={
		FStartDate:DefaultStDate()
		//ExtStartDate:DefaultStDate()
	}
	var DafultExt={
		RecDateValue:DefaultStDate()
	}
	$UI.fillBlock('#MainCondition',Dafult)
	$UI.fillBlock('#DetailCondition',DafultExt)
	//��ѯ
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			query();
			//Clear();
		}
	});
	function query(){ 
		var Params = JSON.stringify($UI.loopBlock('#CondTB'));
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignPkgBindInfo',
			QueryName: 'GetOpPlan',
			Params: Params
		});
	}
	//��ϸ��ѯ
	$UI.linkbutton('#QueryBTExt',{ 
		onClick:function(){
			queryext();
		}
	});
	function queryext(){ 
		var Params = JSON.stringify($UI.loopBlock('#IpuntTB'));
		DetailListGrid.load({
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
			QueryName: 'GetDeviceRegister',
			Params: Params
		});
	}
	//���������Ű�����
	$UI.linkbutton('#ImportOP',{ 
		onClick:function(){
			Import();
		}
	});
	function Import(){ 
		var Params = $UI.loopBlock('#CondTB');
		$.cm({
			ClassName:'web.CSSDHUI.PackageCallBack.ForeignPkgBindInfo',
			MethodName:'Import',
			stdate:Params.FStartDate
		},function(jsonData){
			if(jsonData.success==0){
				 query();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		}); 
	}
	//ɨ�붯���Զ��ύ
	$("#BarCode").keypress(function(event) {
		if ( event.which == 13 ) {
			var v=$("#BarCode").val();
			var row = $('#MainList').datagrid('getSelected');
			if(isEmpty(row)){
				$UI.msg('alert','��ѡ����Ҫ�󶨵�����!');
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
				ClassName:'web.CSSDHUI.PackageCallBack.ForeignPkgBindInfo',
				MethodName:'jsSaveDetail',
				mainId:row.RowId,
				barCode:v,
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					MainListGrid.reload();
					DetailListGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
					$("#BarCode").val("").focus();
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	function flagColor(val, row, index) {
		if(val == '1') {
			return 'background:#15b398;color:white';
		}else{
			return 'background:#ff584c;color:white';
		}
	}
	//���������Ļس��¼����� end
	var MainCm = [[{
					title : '',
					field : 'ck',
					checkbox : true,
					width : 50
				},{
					title: '�Ƿ��',
					align:'left',
					field: 'isbind',
					width:100,
					fitColumns:true,
					styler: flagColor,
					formatter: function(value) {
					var status = "";
					if(value == "1") {
						status = "�Ѱ�";
					} else {
						status = "δ��";
					}
					return status;
					}
				},
				{
					title: 'RowId',
					field: 'RowId',
					width:50,
					hidden: true
				},{
					title: '��������',
					field: 'RecDate',
					width:150
				},{
					title: '������',
					align:'left',
					field: 'OPLocName',
					width:150,
					fitColumns:true
				}, {
					title: '��������',
					align:'left',
					field: 'OPERDesc',
					width:150,
					fitColumns:true
				},{
					title:'���˵ǼǺ�',
					align:'left',
					field:'RegNo',
					width:150,
					fitColumns:true
				},
				{
					title:'��������',
					align:'left',
					field:'PatientName',
					width:150,
					fitColumns:true
				},{
					title:'���˿���',
					align:'left',
					field:'PatientLocDesc',
					width:150,
					fitColumns:true
				},
				
			]];

	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignPkgBindInfo',
			QueryName: 'GetOpPlan',
			Params:JSON.stringify($UI.loopBlock('#CondTB'))
		},
		columns: MainCm,
		toolbar: '#CondTB',
		lazy:false,
		selectOnCheck: false,
		//singleSelect: false,
		onLoadSuccess:function(data){  
			if(data.rows.length>0){
				$('#MainList').datagrid("selectRow", 0)
				var Row=MainListGrid.getRows()[0]
				var Id = Row.RowId;
				$("#MainDr").val(Id);
				BindAllPackage();
		 	}
		},
		onClickCell: function(index, filed ,value){
			var Row=MainListGrid.getRows()[index]
			var Id = Row.RowId;
			$("#MainDr").val(Id);
			if(!isEmpty(Id)){
				BindAllPackage();
			}
			$("#BarCode").val("").focus();
		}
	})
	///�ұߵǼ�������е��
	var DetailCm = [[{
						title: 'RowId',
						field: 'RowId',
						width:50,
						hidden: true
					},{
						title: '����������',
						field: 'InstruName',
						width:150
					},{
						title: '�����Ʊ���',
						field: 'InstruCode',
						align: 'left',
						width:100,
					}, {
						title:'��������',
						align:'left',
						field:'SickerName',
						width:150,
						fitColumns:true
					},{
						title:'���˿���',
						align:'left',
						field:'ExtLocDesc',
						width:150,
						fitColumns:true
					},
					{
						title: '����ҽ��',
						field: 'UseDoctor',
						align: 'left',
						width:100,
						sortable: true,
					}
				]];

	var DetailListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
			QueryName: 'GetDeviceRegister',
			Params:JSON.stringify($UI.loopBlock('#IpuntTB'))
		},
		columns: DetailCm,
		toolbar: '#IpuntTB',
		//lazy:false,
		pagination:false
	})
	
	function BindAllPackage() {
		DetailListGrid.load({
			ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
			QueryName: 'GetDeviceRegister',
			Params:JSON.stringify($UI.loopBlock('#IpuntTB')),
			rows:999
		});
	}
}
$(init);
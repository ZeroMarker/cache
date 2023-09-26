var init = function() {
	var HospId=gHospId;
	var TableName="DHC_ItmNotUseReason";
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				Query();
			};
		}
	}
	function Query(){
		Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		if (TableName=="DHC_ItmNotUseReason") {
			NotUseReasonGrid.load({
				ClassName: 'web.DHCSTMHUI.ItmNotUseReason',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
		else if (TableName=="DHC_ItmQualityLevel") {
			QuailtyLevelGrid.load({
				ClassName: 'web.DHCSTMHUI.ITMQL',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
		else if (TableName=="INC_SterileCategory") {
			CategoryGrid.load({
				ClassName: 'web.DHCSTMHUI.ItmCate',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
	}
	
	$HUI.tabs("#DetailTabs", {
		onSelect: function (title, index) {
			if (title == "������ԭ��ά��") {
				TableName="DHC_ItmNotUseReason";
			}
			else if (title == "�������ά��") {
				TableName="DHC_ItmQualityLevel";
			}
			else if (title == "�������ά��") {
				TableName="INC_SterileCategory";
			}
			InitHosp();
		}
	});
	
	//������ԭ��--------------------------
	function SaveNotUseReason(){
		var Rows=NotUseReasonGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmNotUseReason',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','����ɹ���');
				NotUseReasonGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var NotUseReasonGrid = $UI.datagrid('#NotUseReasonGrid',{
			queryParams: {
				ClassName: 'web.DHCSTMHUI.ItmNotUseReason',
				QueryName: 'SelectAll'
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.ItmNotUseReason',
				MethodName:'Delete'
			},
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					SaveNotUseReason();
			}}],
			columns: [[{
					title: 'RowId',
					field: 'RowId',
					hidden: true
				}, {
					title: '����',
					field: 'Description',
					width:350,
					editor:{type:'validatebox',options:{required:true}}
				}
			]],
			lazy:false,
			showAddDelItems:true,
			onClickCell: function(index, filed ,value){
				NotUseReasonGrid.commonClickCell(index,filed)
				}
		});
	//�������--------------------------
	function SaveQuailtyLevel(){
		var Rows=QuailtyLevelGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.ITMQL',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','����ɹ���');
				QuailtyLevelGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var QuailtyLevelGrid = $UI.datagrid('#QuailtyLevelGrid',{
			queryParams: {
				ClassName: 'web.DHCSTMHUI.ITMQL',
				QueryName: 'SelectAll'
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.ITMQL',
				MethodName:'Delete'
			},
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					SaveQuailtyLevel();
			}}],
			columns: [[{
					title: 'RowId',
					field: 'RowId',
					hidden: true
				}, {
					title: '����',
					field: 'Code',
					width:310,
					editor:{type:'validatebox',options:{required:true}}
				}, {
					title: '����',
					field: 'Description',
					width:350,
					editor:{type:'validatebox',options:{required:true}}
				}
			]],
			lazy:false,
			showAddDelItems:true,
			onClickCell: function(index, filed ,value){
				QuailtyLevelGrid.commonClickCell(index,filed)
				}
		});	
	//�������--------------------------
	function SaveCategory(){
		var Rows=CategoryGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmCate',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','����ɹ���');
				CategoryGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var CategoryGrid = $UI.datagrid('#CategoryGrid',{
			queryParams: {
				ClassName: 'web.DHCSTMHUI.ItmCate',
				QueryName: 'SelectAll'
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.ItmCate',
				MethodName:'Delete'
			},
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					SaveCategory();
			}}],
			columns: [[{
					title: 'RowId',
					field: 'RowId',
					hidden: true
				}, {
					title: '����',
					field: 'Description',
					width:350,
					editor:{type:'validatebox',options:{required:true}}
				}
			]],
			lazy:false,
			showAddDelItems:true,
			onClickCell: function(index, filed ,value){
				CategoryGrid.commonClickCell(index,filed)
			}
		});
		InitHosp();
}
$(init)
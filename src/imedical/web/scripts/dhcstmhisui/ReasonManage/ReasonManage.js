var init = function() {
	var HospId=gHospId;
	var TableName="INC_ReasonForAdjustment";
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
		var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		if (TableName=="INC_ReasonForAdjustment") {
			IncReasonForAdjGrid.load({
				ClassName: 'web.DHCSTMHUI.INCReasonForAdj',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
		else if (TableName=="DHC_ReasonForAdjustPrice") {
			ReasonForAdjustPriceGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCReasonForAdjustPrice',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
		else if (TableName=="DHC_IncReasonForStockScrap") {
			IncReasonForScrapGrid.load({
				ClassName: 'web.DHCSTMHUI.INCReasonForScrap',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
		else if (TableName=="INC_ReasonForReturn") {
			IncReasonForRetGrid.load({
				ClassName: 'web.DHCSTMHUI.INCReasonForRet',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
		else if (TableName=="INC_POCanc_FullFillReason") {
			InPoReasonForCancleGrid.load({
				ClassName: 'web.DHCSTMHUI.InPoReasonForCancel',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
		else if (TableName=="DHC_ReasonForRefuseRequest") {
			ReasonForRefuseRequestGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCReasonForRefuseRequest',
				QueryName: 'SelectAll',
				Params: Params
			});
		}
	}
	
	$HUI.tabs("#DetailTabs", {
		onSelect: function (title, index) {
			if (title == "����ԭ��ά��") {
				TableName="INC_ReasonForAdjustment";
			}
			else if (title == "����ԭ��ά��") {
				TableName="DHC_ReasonForAdjustPrice";
			}
			else if (title == "����ԭ��ά��") {
				TableName="DHC_IncReasonForStockScrap";
			}
			else if (title == "�˻�ԭ��ά��") {
				TableName="INC_ReasonForReturn";
			}
			else if (title == "����ȡ��ԭ��ά��") {
				TableName="INC_POCanc_FullFillReason";
			}
			else if (title == "���󵥾ܾ�ԭ��ά��") {
				TableName="DHC_ReasonForRefuseRequest";
			}
			InitHosp();
		}
	});
	
	//����ԭ��--------------------------
	function SaveReasonForAdj(){
		var Rows=IncReasonForAdjGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCReasonForAdj',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','����ɹ���');
				IncReasonForAdjGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var IncReasonForAdjGrid = $UI.datagrid('#IncReasonForAdjGrid',{
			queryParams: {
				ClassName: 'web.DHCSTMHUI.INCReasonForAdj',
				QueryName: 'SelectAll'
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.INCReasonForAdj',
				MethodName:'Delete'
			},
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					SaveReasonForAdj();
			}}],
			columns: [[{
					title: 'RowId',
					field: 'RowId',
					fitColumns:true,
					hidden: true
				}, {
					title: '����',
					field: 'Code',
					width:310,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}, {
					title: '����',
					field: 'Description',
					width:350,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}
			]],
			lazy:false,
			showAddDelItems:true,
			onClickCell: function(index, filed ,value){
				IncReasonForAdjGrid.commonClickCell(index,filed)
				}
		});
	//����ԭ��--------------------------
	function SaveReasonForAdjPrice(){
		var Rows=ReasonForAdjustPriceGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCReasonForAdjustPrice',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','����ɹ���');
				ReasonForAdjustPriceGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var ReasonForAdjustPriceGrid = $UI.datagrid('#ReasonForAdjustPriceGrid',{
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCReasonForAdjustPrice',
				QueryName: 'SelectAll'
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.DHCReasonForAdjustPrice',
				MethodName:'Delete'
			},
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					SaveReasonForAdjPrice();
			}}],
			columns: [[{
					title: 'RowId',
					field: 'RowId',
					fitColumns:true,
					hidden: true
				}, {
					title: '����',
					field: 'Code',
					width:310,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}, {
					title: '����',
					field: 'Description',
					width:350,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}
			]],
			lazy:false,
			showAddDelItems:true,
			onClickCell: function(index, filed ,value){
				ReasonForAdjustPriceGrid.commonClickCell(index,filed)
				}
		});	
	//����ԭ��--------------------------
	function SaveReasonForScrap(){
		var Rows=IncReasonForScrapGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCReasonForScrap',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','����ɹ���');
				IncReasonForScrapGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var IncReasonForScrapGrid = $UI.datagrid('#IncReasonForScrapGrid',{
			queryParams: {
				ClassName: 'web.DHCSTMHUI.INCReasonForScrap',
				QueryName: 'SelectAll'
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.INCReasonForScrap',
				MethodName:'Delete'
			},
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					SaveReasonForScrap();
			}}],
			columns: [[{
					title: 'RowId',
					field: 'RowId',
					fitColumns:true,
					hidden: true
				}, {
					title: '����',
					field: 'Code',
					width:310,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}, {
					title: '����',
					field: 'Description',
					width:350,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}
			]],
			lazy:false,
			showAddDelItems:true,
			onClickCell: function(index, filed ,value){
				IncReasonForScrapGrid.commonClickCell(index,filed)
				}
		});
	//�˻�ԭ��--------------------------
	function SaveReasonForRet(){
		var Rows=IncReasonForRetGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCReasonForRet',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','����ɹ���');
				IncReasonForRetGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var IncReasonForRetGrid = $UI.datagrid('#IncReasonForRetGrid',{
			queryParams: {
				ClassName: 'web.DHCSTMHUI.INCReasonForRet',
				QueryName: 'SelectAll'
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.INCReasonForRet',
				MethodName:'Delete'
			},
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					SaveReasonForRet();
			}}],
			columns: [[{
					title: 'RowId',
					field: 'RowId',
					fitColumns:true,
					hidden: true
				}, {
					title: '����',
					field: 'Code',
					width:310,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}, {
					title: '����',
					field: 'Description',
					width:350,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}
			]],
			lazy:false,
			showAddDelItems:true,
			onClickCell: function(index, filed ,value){
				IncReasonForRetGrid.commonClickCell(index,filed)
				}
		});
	//����ȡ����ԭ��--------------------------
	function SaveReasonForPoCancle(){
		var Rows=InPoReasonForCancleGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.InPoReasonForCancel',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','����ɹ���');
				InPoReasonForCancleGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var InPoReasonForCancleGrid = $UI.datagrid('#InPoReasonForCancleGrid',{
			queryParams: {
				ClassName: 'web.DHCSTMHUI.InPoReasonForCancel',
				QueryName: 'SelectAll'
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.InPoReasonForCancel',
				MethodName:'Delete'
			},
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					SaveReasonForPoCancle();
			}}],
			columns: [[{
					title: 'RowId',
					field: 'RowId',
					fitColumns:true,
					hidden: true
				}, {
					title: '����',
					field: 'Code',
					width:310,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}, {
					title: '����',
					field: 'Description',
					width:350,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}
			]],
			lazy:false,
			showAddDelItems:true,
			onClickCell: function(index, filed ,value){
				InPoReasonForCancleGrid.commonClickCell(index,filed)
				}
		});
	//���󵥾ܾ�ԭ��--------------------------
	function SaveReasonForRefuseRequest(){
		var Rows=ReasonForRefuseRequestGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCReasonForRefuseRequest',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','����ɹ���');
				ReasonForRefuseRequestGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var ReasonForRefuseRequestGrid = $UI.datagrid('#ReasonForRefuseRequestGrid',{
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCReasonForRefuseRequest',
				QueryName: 'SelectAll'
			},
			deleteRowParams:{
				ClassName:'web.DHCSTMHUI.DHCReasonForRefuseRequest',
				MethodName:'Delete'
			},
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					SaveReasonForRefuseRequest();
			}}],
			columns: [[{
					title: 'RowId',
					field: 'RowId',
					fitColumns:true,
					hidden: true
				}, {
					title: '����',
					field: 'Code',
					width:310,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}, {
					title: '����',
					field: 'Description',
					width:350,
					fitColumns:true,
					editor:{type:'validatebox',options:{required:true}}
				}
			]],
			lazy:false,
			showAddDelItems:true,
			onClickCell: function(index, filed ,value){
				ReasonForRefuseRequestGrid.commonClickCell(index,filed)
				}
		});
		InitHosp();
}
$(init)
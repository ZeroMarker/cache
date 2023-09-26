var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		var Dafult={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			ReqLoc:gLocObj,
			AllTransfer:'Y',
			PartTransfer:'Y',
			NoTransfer:'Y',
			Complate:'Y',
			RecLocAudited:'N'
			}
		$UI.fillBlock('#Conditions',Dafult)
	};
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	function Query(){
		$UI.clear(RequestDetailGrid);
		$UI.clear(RequestMainGrid);
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.ReqLoc)){
			$UI.msg('alert','������Ҳ���Ϊ��!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		RequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM',
			Params:Params
		});
	}
	$UI.linkbutton('#AduitBT',{
		onClick:function(){
			var Row=RequestMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','��ѡ������!');
				return;
			}
			var Params=JSON.stringify(addSessionParams({Req:Row.RowId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'jsReqSideAudit',
				Params:Params
				
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(RequestDetailGrid);
					RequestMainGrid.commonReload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DenyBT',{
		onClick:function(){
			var Row=RequestMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','��ѡ������!');
				return;
			}
			var Params=JSON.stringify(addSessionParams({Req:Row.RowId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'ReqSideDeny',
				Params:Params
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(RequestDetailGrid);
					RequestMainGrid.commonReload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear()
		}
	});
	var ReqLocParams=JSON.stringify(addSessionParams({Type:INREQUEST_LOCTYPE}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var StatusBox = $HUI.combobox('#ReqType', {
		data:[{'RowId':'O','Description':'����'},{'RowId':'C','Description':'����ƻ�'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var RequestMainCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '��������',
			field: 'ReqType',
			width:150,
			formatter:function(v){
				if (v=='O') {return "����";}
				if (v=='C') {return '����ƻ�';}
				return '����';
			}
		}, {
			title: '���󵥺�',
			field: 'ReqNo',
			width:150
		}, {
			title: '������',
			field: 'ToLocDesc',
			width:150
		}, {
			title: "��������",
			field:'FrLocDesc',
			width:100
		}, {
			title:"������",
			field:'UserName',
			width:70
		}, {
			title:"����",
			field:'Date',
			width:90
		}, {
			title:"ʱ��",
			field:'Time',
			width:80
		}, {
			title:"���״̬",
			field:'Complete',
			align:'center',
			width:60
		}, {
			title:"ת��״̬",
			field:'Status',
			width:80,
			align:'center',
			formatter:function(value){
				var status="";
				if(value==0){
					status="δת��";
				}else if(value==1){
					status="����ת��";
				}else if(value==2){
					status="ȫ��ת��";
				}
				return status;
			}
		}, {
			title:"��ע",
			field:'Remark',
			width:100
		},{
			title:'�������',
			field:'RecLocAudited',
			align:'center',
			width:80
		},{
			title: "�������",
			field: 'AuditDate',
			width: 90,
			align: 'left'
		},{
			title:'��Ӧ�����',
			field:'ProvLocAudited',
			align:'center',
			width:80
		},{
			title:'�ֿ��Ƿ�ܾ�',
			field:'PreFlag',
			width:80,
			align:'center'
		}
	]];
	
	var RequestMainGrid = $UI.datagrid('#RequestMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM'
		},
		columns: RequestMainCm,
		onSelect:function(index, row){
			var ParamsObj={RefuseFlag:1}
			var Params=JSON.stringify(ParamsObj)
			RequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				QueryName: 'INReqD',
				Req: row.RowId,
				Params:Params,
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				$(this).datagrid('selectRow', 0);
			}
		}
	})
	
	var RequestDetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'Code',
			width:120
		}, {
			title: '��������',
			field: 'Description',
			width:150
		}, {
			title: "���",
			field:'Spec',
			width:100
		}, {
			title:"������",
			field:'SpecDesc',
			width:100
		}, {
			title:"����",
			field:'Manf',
			width:100
		}, {
			title:"��������",
			field:'Qty',
			width:100,
			align:'right'
		}, {
			title:"��λ",
			field:'UomDesc',
			width:80
		}, {
			title:"�ۼ�",
			field:'Sp',
			width:100,
			align:'right'
		}, {
			title:"�ۼ۽��",
			field:'SpAmt',
			width:100,
			align:'right'
		}, {
			title:"����ע",
			field:'ReqRemarks',
			width:100
		}, {
			title:"�Ƿ�ܾ�",
			field:'RefuseFlag',
			width:80,
			align:'center'
		}
	]];
	
	var RequestDetailGrid = $UI.datagrid('#RequestDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			rows: 99999
		},
		pagination:false,
		columns: RequestDetailCm
	})
	
	Clear();
	Query();
	
}
$(init);
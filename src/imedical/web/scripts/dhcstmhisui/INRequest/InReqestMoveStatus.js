var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		var Dafult={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			ReqLoc:gLocObj
			}
		$UI.fillBlock('#Conditions',Dafult)
	};
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}	
	});	
	function Query(){
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
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		RequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequestQuery',
			QueryName: 'INReq',
			Params:Params
		});
	}
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
	var SupLocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var RequestMainCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '��������',
			field: 'ReqType',
			width:100,
			formatter:function(v){
				if (v=='O') {return "����";}
				if (v=='C') {return '����ƻ�';}
				return '����';
			}
		}, {
			title: '���󵥺�',
			field: 'ReqNo',
			width:200
		}, {
			title: '������',
			field: 'ToLocDesc',
			width:150
		}, {
        	title: "��������",
       		field:'FrLocDesc',
        	width:150
    	}, {
	        title:"������",
	        field:'UserName',
	        width:70
	    }, {
	        title:"���������",
	        field:'AuditUser',
	        width:90
	    }, {
	        title:"��Ӧ�������",
	        field:'AuditUserProv',
	        width:90
	    }, {
	        title:"����",
	        field:'ReqDate',
	        width:90,
	        align:'right'
		}, {
	        title:"ʱ��",
	        field:'ReqTime',
	        width:80,
	        align:'right'
	    }, {
	        title:"���״̬",
	        field:'Complete',
	        width:60
	    }, {
	        title:"ת��״̬",
	        field:'TransStatus',
	        width:80,
	        align:'right',
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
	    }
	]];
	var RequestMainGrid = $UI.datagrid('#RequestMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM'
		},
		columns: RequestMainCm,
		onSelect:function(index, row){
			RequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINReqItmMoveStatus',
				QueryName: 'QueryReqDetail',
				Req: row.RowId,
				rows: 99999
			});
		}
	})
	
	var RequestDetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width:120
		}, {
			title: '��������',
			field: 'InciDesc',
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
	        title:"���ת���Ƿ�ܾ�",
	        field:'RefuseFlag',
	        width:80,
	        align:'center'
	    }, {
	        title:"�������",
	        field:'RD',
	        width:80,
	        align:'center'
	    }, {
	        title:"��������������",
	        field:'RA',
	        width:80,
	        align:'center'
	    }, {
	        title:"���󵥹�Ӧ��������",
	        field:'EA',
	        width:80,
	        align:'center'
	    }, {
	        title:"�ɹ������",
	        field:'PD',
	        width:80,
	        align:'center'
	    }, {
	        title:"�ɹ���������",
	        field:'PA',
	        width:80,
	        align:'center'
	    }, {
	        title:"�������",
	        field:'POD',
	        width:80,
	        align:'center'
	    }, {
	        title:"����������",
	        field:'POA',
	        width:80,
	        align:'center'
	    }, {
	        title:"����Ƶ����",
	        field:'IMD',
	        width:80,
	        align:'center'
	    }, {
	        title:"��ⵥ������",
	        field:'IMA',
	        width:80,
	        align:'center'
	    }, {
	        title:"�����Ƶ����",
	        field:'ID',
	        width:80,
	        align:'center'
	    }, {
	        title:"����������",
	        field:'IO',
	        width:80,
	        align:'center'
	    }, {
	        title:"�ܾ��������",
	        field:'IIR',
	        width:80,
	        align:'center'
	    }, {
	        title:"�������",
	        field:'II',
	        width:80,
	        align:'center'
	    }			
	]];
	
	var RequestDetailGrid = $UI.datagrid('#RequestDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINReqItmMoveStatus',
			QueryName: 'QueryReqDetail',
			rows: 99999
		},
		pagination:false,
		columns: RequestDetailCm
	})
	
	Clear();
	Query();
	
}
$(init);
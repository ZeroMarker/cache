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
			var ParamsObj={RefuseFlag:1}
			var Params=JSON.stringify(ParamsObj)
			RequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				QueryName: 'INReqD',
				Req: row.RowId,
				Params:Params,
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
			title : "��Ӧ�����",
			field : 'StkQty',
			width : 80,
			align : 'right'
		}, {
			title : "��ת������",
			field : 'TransQty',
			width : 80,
			align : 'right'
		}, {
			title : "δת������",
			field : 'NotTransQty',
			width : 80,
			align : 'right'
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
	        width:60,
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
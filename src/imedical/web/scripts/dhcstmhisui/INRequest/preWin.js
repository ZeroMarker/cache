var FindWin=function(Fn){
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		var Dafult={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			AllTransfer:'Y',
			PartTransfer:'Y',
			NoTransfer:'Y',
			ReqLoc:gLocObj,
			SupLoc:gLocId,
			ReqType:'C'
			}
		$UI.fillBlock('#FindConditions',Dafult)
	}
	$HUI.dialog('#FindWin').open()
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			Query();
		}	
	});	
	function Query(){
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg("alert",'��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg("alert",'��ֹ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.ReqLoc)){
			$UI.msg("alert",'������Ҳ���Ϊ��!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		RequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM',
			Params:Params
		});
	}
	$UI.linkbutton('#FComBT',{
		onClick:function(){
			var Row=RequestMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg("alert",'��ѡ��Ҫ���ص�����!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT',{
		onClick:function(){
			Clear()
		}
	});

	var FReqLocParams=JSON.stringify(addSessionParams({Type:INREQUEST_LOCTYPE}));
	var FReqLocBox = $HUI.combobox('#FReqLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FReqLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				if(!isEmpty(record.RowId)){
					$('#FSupLoc').val(record.RowId)
				}
			}
		});		
	var RequestMainCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
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
	        width:90,
	        align:'right'
		}, {
	        title:"ʱ��",
	        field:'Time',
	        width:80,
	        align:'right'
	    }, {
	        title:"���״̬",
	        field:'Complete',
	        width:60
	    }, {
	        title:"����״̬",
	        field:'Status',
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
	    }, {
	        title:"��ע",
	        field:'Remark',
	        width:100,
	        align:'right'
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
				Params:Params
			});
		},
		onDblClickRow:function(index, row){
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				$(this).datagrid('selectRow',0);
			}
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
			QueryName: 'INReqD'
		},
		columns: RequestDetailCm
	})
	
	Clear();
	Query();
}
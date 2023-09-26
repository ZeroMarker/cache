function GetArcforLinkInci(){
	var Inci=$('#Inci' ).val()
	if(isEmpty(Inci)){
		$UI.msg('alert','����ѡ��Ҫά���Ŀ����!')
		return;
	}	
	var Clear=function(){
		$UI.clearBlock('#ArcConditions');
		$UI.clear(ArcGrid);
		var Dafult={}
		$UI.fillBlock('#LinkArcWin',Dafult)
	}
	$HUI.dialog('#LinkArcWin').open()
	$UI.linkbutton('#ArcQueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#ArcConditions')
			var Params=JSON.stringify(ParamsObj);
			ArcGrid.load({
				ClassName: 'web.DHCSTMHUI.ShowArcinfoForlinkInci',
				QueryName: 'getArcinfo',
				Params:Params
			});
		}	
	});	
	$UI.linkbutton('#ArcLinkBT',{
		onClick:function(){
			 var ArcId=ArcGrid.getSelected().ArcId;
			 var Linked=tkMakeServerCall("web.DHCSTMHUI.ShowArcinfoForlinkInci","IfLinkInci",ArcId);
			 if (Linked=="Y")
			 {
			     $UI.msg("info","��ҽ���Ѿ����ڹ����Ŀ����,����ϵ����Ա����!");
			     return;
			 }
			 var Ret=tkMakeServerCall("web.DHCSTMHUI.ShowArcinfoForlinkInci","LinkInci",ArcId,Inci);
			 if(Ret==0){
			 	$UI.msg("success","�����ɹ�!");
			 }else{
			 	$UI.msg("error","����ʧ��!");
			 }
		}
	});
	$UI.linkbutton('#ArcClearBT',{
		onClick:function(){
			Clear()
		}
	});
	var OrdCatBox= $HUI.combobox('#OrdCatBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect:function(record){
			OrdSubCatBox.clear();
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array&OrdCat='+record.RowId;
            OrdSubCatBox.reload(url);
		}
	});
	var OrdSubCatBox= $HUI.combobox('#OrdSubCatBox', {
			valueField: 'RowId',
			textField: 'Description'
	});	
	var ArcCm = [[{
			title: 'ArcId',
			field: 'ArcId',
			width:150,
			hidden: true
		},{
			title: 'ҽ������',
			field: 'ArcCode',
			width:150
		}, {
			title: 'ҽ������',
			field: 'ArcDesc',
			width:150
		}, {
        	title: "�Ƽ۵�λ",
       		field:'BillUom',
        	width:100
    	}, {
	        title:"�Ʒ����ۼ�",
	        field:'TarPrice',
	        width:100,
	        align:'right'
	    }, {
	        title:"ҽ������",
	        field:'OrdCat',
	        width:100
		}, {
	        title:"ҽ������",
	        field:'OrdSubCat',
	        width:100
	    }, {
	        title:"����ҽ��",
	        field:'OwnFlag',
	        width:100,
	        align:'cenrer'
	    }, {
	        title:"ҽ������",
	        field:'InsuDesc',
	        width:100
	    },{ title:"ҽ����ʾ",
	        field:'OeMessage',
	        width:100
	    }, {
	        title:"�շ������",
	        field:'TariCode',
	        width:100
	    }, {
	        title:"�շ�������",
	        field:'TariDesc',
	        width:100
	    }
	]];
	var ArcGrid = $UI.datagrid('#LinkArcGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ShowArcinfoForlinkInci',
			QueryName: 'getArcinfo'
		},
		columns: ArcCm
	})
	Clear()
}
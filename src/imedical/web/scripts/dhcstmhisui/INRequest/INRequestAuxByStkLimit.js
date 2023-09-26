var init = function() {
	var Clear=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(LimitGrid);
		var Dafult={
			ReqLoc:gLocObj,
			ReqType:'O'
			}
		$UI.fillBlock('#MainConditions',Dafult)
	}
	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	var Manager = $HUI.combobox('#Manager', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'Y','Description':'�ص��ע'},{'RowId':'N','Description':'���ص��ע'}],
		valueField: 'RowId',
		textField: 'Description'
	});	
	var ReqLocParams=JSON.stringify(addSessionParams({Type:INREQUEST_LOCTYPE}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});		
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#MainConditions')
			if(isEmpty(ParamsObj.SupLoc)){
				$UI.msg('alert','��Ӧ���Ҳ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.ReqLoc)){
				$UI.msg('alert','������Ҳ���Ϊ��!');
				return;
			}
			if(InRequestParamObj.NoScgLimit!='Y'&&isEmpty($HUI.combobox("#ScgStk").getValue())){
				$UI.msg('alert',"���鲻��Ϊ��!");
				return false;
			};
			var Params=JSON.stringify(ParamsObj)
			LimitGrid.load({
				ClassName: 'web.DHCSTMHUI.INRequestAuxByLim',
				QueryName: 'LocItmForReq',
				Params:Params
			});
		}
	});
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			var MainObj=$UI.loopBlock('#MainConditions')
			var Main=JSON.stringify(MainObj)
			var Detail=LimitGrid.getRowsData();
			if(isEmpty(Detail)){
				$UI.msg('alert','��ѡ����Ӧ�ĸ�������');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'Save',
				Main: Main,
				Detail: JSON.stringify(Detail)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.clear(LimitGrid);
					$UI.msg('success',jsonData.msg);
					var Req=jsonData.rowid
					var HvFlagRadioJObj = $("input[name='HvFlag']:checked");
					if(HvFlagRadioJObj.val()=='N'){
						var UrlStr = "dhcstmhui.inrequest.csp?RowId="+Req;
					}else{
						var UrlStr = "dhcstmhui.inrequesthv.csp?RowId="+Req;	
					}
					Common_AddTab('����', UrlStr);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});	 
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});	
	var LimitGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '����RowId',
			field: 'Inci',
			hidden: true			
		}, {
			title: '����',
			field: 'Code',
			width:100
		}, {
			title: '����',
			field: 'Description',
			width:150
		}, {
        	title: "���",
       		field:'Spec',
        	width:100
    	}, {
	        title:"����",
	        field:'Manf',
	        width:150
	    }, {
	        title:"������������",
	        field:'ReqQty',
	        width:100,
	        align:'right',
	        hidden:true
	    }, {
	        title:"��������",
	        field:'Qty',
	        width:100,
	        align:'right'
	    },{
	        title:"��������",
	        field:'AvaQty',
	        width:100,
	        align:'right'
	    },{
	        title:"�������",
	        field:'MaxQty',
	        width:100,
	        align:'right'
	    },{
	        title:"�������",
	        field:'MinQty',
	        width:100,
	        align:'right'
	    },{
	        title:"��׼���",
	        field:'RepQty',
	        width:100,
	        align:'right'
	    },{
	        title:"��λ",
	        field:'Uom',
	        width:100,
	    	formatter: CommonFormatter(UomCombox,'Uom','UomDesc')
	    },{
			title:"��ֵ��־",
			field:'HvFlag',
			width:80,
			align:'center',
			renderer :function(v){
				if(v=="Y"){return "��"}
				else{return "��"}
			}
		}		
	]];
	
	var LimitGrid = $UI.datagrid('#LimitGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequestAuxByLim',
			QueryName: 'LocItmForReq'
		},
		pagination:false,
		columns: LimitGridCm
	})
	Clear()
}
$(init);

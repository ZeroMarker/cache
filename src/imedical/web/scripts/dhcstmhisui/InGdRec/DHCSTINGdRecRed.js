/*
��ⵥ���
����: �����Ѿ��������ҳ�������Ѿ������±���û������ҵ����������
*/
var init = function() {
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			IngrClear();
		}
	});
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			IngrRedData();
		}
	});
	var FRecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var FVendorBoxParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorBoxParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var InGdRecMainCm = [[{
			title : "RowId",
			field : 'IngrId',
			width : 100,
			hidden : true
		}, {
			title : "��ⵥ��",
			field : 'IngrNo',
			width : 120
		}, {
			title : "��Ӧ��",
			field : 'Vendor',
			width : 200
		}, {
			title : '��������',
			field : 'ReqLocDesc',
			width : 150
		}, {
			title : '������',
			field : 'AcceptUser',
			width : 70
		}, {
			title : '��������',
			field : 'CreateDate',
			width : 90
		}, {
			title : '�ɹ�Ա',
			field : 'PurchUser',
			width : 70
		}, {
			title : "��ɱ�־",
			field : 'Complete',
			width : 70
		}, {
			title : "���۽��",
			field : 'RpAmt',
			width : 100,
	        align : 'right'
		}, {
			title : "�ۼ۽��",
			field : 'SpAmt',
			width : 100,
	        align : 'right'
		}	
	]];
	
	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query'
		},
		columns: InGdRecMainCm,
		onSelect:function(index, row){
			$UI.setUrl(InGdRecDetailGrid)
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId,
				rows: 99999
			});
		}
	})
	
	var InGdRecDetailCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : '���ʴ���',
			field : 'IncCode',
			width : 80
		}, {
			title : '��������',
			field : 'IncDesc',
			width : 230
		}, {
			title : "���",
			field : 'Spec',
			width : 180
		}, {
			title : "������",
			field : 'SpecDesc',
			width : 180
		}, {
			title : "����",
			field : 'Manf',
			width : 180
		}, {
			title : "����",
			field : 'BatchNo',
			width : 90
		}, {
			title : "��Ч��",
			field : 'ExpDate',
			width : 100
		}, {
			title : "��λ",
			field : 'IngrUom',
			width : 80
		}, {
			title : "����",
			field : 'RecQty',
			width : 80,
	        align : 'right'
		}, {
			title : "����",
			field : 'Rp',
			width : 60,
	        align : 'right',
				editor:{
					type:'numberbox',
					options:{
						required:true
						}
					}
		}, {
			title : "ע��֤��",
			field : 'AdmNo',
			width : 80
		}, {
			title : "ע��֤��Ч��",
			field : 'AdmExpdate',
			width : 80
		}, {
			title : "ժҪ",
			field : 'Remark',
			width : 60
		}, {
			title : "�ۼ�",
			field : 'Sp',
			width : 60,
	        align : 'right'
		}, {
			title : "��Ʊ��",
			field : 'InvNo',
			width : 80
		}, {
			title : "��Ʊ����",
			field : 'InvDate',
			width : 100
		}, {
			title :"��Ʊ���",
			field :'InvMoney',
	        align : 'right',
			width :80
		}, {
			title : "���۽��",
			field : 'RpAmt',
			width : 100,
	        align : 'right'
		}, {
			title : "�ۼ۽��",
			field : 'SpAmt',
			width : 100,
	        align : 'right'
		}, {
			title : '��ֵ����',
			field : 'HVBarCode',
			width : 80
		}, {
			title : '�Դ�����',
			field : 'OrigiBarCode',
			width : 80
		}			
	]];
	
	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			rows: 99999
		},
		pagination:false,
		columns: InGdRecDetailCm,
		onClickCell: function(index, field ,value){
			InGdRecDetailGrid.commonClickCell(index,field,value);
		},
		onEndEdit:function(index, row, changes){
			var Editors = $(this).datagrid('getEditors', index);
		    for(var i=0;i<Editors.length;i++){
				var Editor = Editors[i];
				if(Editor.field=='Rp'){
					var rp = row.Rp;
					if (isEmpty(rp)) {
						$UI.msg('alert',"���۲���Ϊ��!");
						InGdRecDetailGrid.checked=false;
						return false;
					}else if (rp < 0) {
						//2016-09-26���ۿ�Ϊ0
						$UI.msg('alert',"���۲���С����!");
						InGdRecDetailGrid.checked=false;
						return false;
					}else if (rp==0) {
						$UI.msg('alert',"���۵�����!");
						InGdRecDetailGrid.checked=false;
						return false;
					}
					// ����ָ���еĽ������
					var RealTotal = accMul(row.RecQty, rp);
					row.RpAmt=RealTotal;
					row.InvMoney=RealTotal;
				}
		    }
		}
	})
	function QueryIngrInfo(){
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.FRecLoc)){
			$UI.msg('alert','���Ҳ���Ϊ��!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		$UI.setUrl(InGdRecMainGrid)
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			Params:Params
		});
	
	}
	function IngrRedData() {
		
	}
	function IngrClear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var Dafult={StartDate: DefaultStDate(),
					EndDate: DefaultEdDate(),
					FRecLoc:gLocObj,
					AuditFlag:"Y"
					}
		$UI.fillBlock('#FindConditions',Dafult);
	
	}
	IngrClear();
}
$(init);
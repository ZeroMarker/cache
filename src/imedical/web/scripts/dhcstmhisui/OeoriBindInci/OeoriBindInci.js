/*��ⵥ���*/
var init = function () {
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(IOeoriMainGrid);
		$UI.clear(IOeoriDetailGrid);
		///���ó�ʼֵ ����ʹ������
		var Dafult = {
			StartDate: new Date(),
			EndDate: new Date()
		};
		$UI.fillBlock('#FindConditions',Dafult)
	}
	var FRecLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FRecLocBox = $HUI.combobox('#LocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#FindConditions')
			var Params=JSON.stringify(ParamsObj);
			var mainData=IOeoriMainGrid.getSelectedData();
			var Detail=IOeoriDetailGrid.getChangesData('Inci');
			if (Detail === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)){	//��ϸ����
				$UI.msg("alert", "û����Ҫ�������ϸ!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.OeoriBindInci',
				MethodName: 'Save',
				Params:Params,
				MainInfo: mainData,
				ListDetail: JSON.stringify(Detail)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					Query();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#DelBT',{
		onClick:function(){
			var Row=IOeoriDetailGrid.getSelected();
			var IngrId=Row.IngrId;
			
		}
	});

	$('#BarCode').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var barcode=document.getElementById("BarCode").value;
			if(barcode==""){
				$UI.msg('alert', '����������!');
			}
			
			var info=tkMakeServerCall("web.DHCSTMHUI.DHCItmTrack","GetItmByBarcode",barcode);
			//var arrinfo=mianinfo.split("^")
			var info=$.parseJSON(info);
			if(info.Inclb==""){
				$UI.msg('alert', "û����Ӧ����¼,�����Ƶ�!");
				$("#BarCode").val("");
				return;
			}else if(info.IsAudit!="Y"){
				$UI.msg('alert', " ��ֵ������δ��˵�"+lastDetailOperNo+",���ʵ!");
				return;
			}else if(info.Type=="T"){
				$UI.msg('alert', " ��ֵ�����Ѿ�����,�����Ƶ�!");
				return;
			}else if(info.Status!="Enable"){
				$UI.msg('alert', " ��ֵ���봦�ڲ�����״̬,�����Ƶ�!");
				return;
			}
			
			var jsonData=tkMakeServerCall("web.DHCSTMHUI.DHCItmTrack","Select",barcode);
			var jsonData=$.parseJSON(jsonData);
			var record={
				Dhcit:jsonData.itmtrackid,
				InciCode:jsonData.incicode,
				InciDesc :jsonData.incidesc,
				BarCode:barcode,
				Manf:jsonData.manfdesc,
				Inclb:jsonData.inclb,
				BatExp:jsonData.expdate+"~"+jsonData.batno,
				Rp:jsonData.rp
			};
			OeoriDetailGrid.appendRow(record)
			$("#BarCode").val("");
		}
	});
	$('#wardno').bind('keypress', function (event) {
		if (event.keyCode == "13") {
			var wardno = $(this).val();
			if (wardno == "") {
				$UI.msg('alert', '������ǼǺ�!');
				return;
			}
			var patinfostr=tkMakeServerCall("web.DHCSTMHUI.HVMatOrdItm", "Pa",wardno);
			var patinfoarr=patinfostr.split("^");
			var newPaAdmNo=patinfoarr[0];
			var patinfo=patinfoarr[1]+","+patinfoarr[2];
			$("#wardno").val(newPaAdmNo);
		}
	});
	var OeoriMainCm = [[{
			title : "Oeori",
			field : 'Oeori',
			width : 100,
			hidden : true
		}, {
			title : "ҽ�������",
			field : 'ArcimCode',
			width : 120
		}, {
			title : 'ҽ��������',
			field : 'ArcimDesc',
			width : 150
		}, {
			title : '���ߵǼǺ�',
			field : 'PaAdmNo',
			width : 150
		}, {
			title : "��������",
			field : 'PaAdmName',
			width : 200
		}, {
			title : "���տ���id",
			field : 'RecLoc',
			width : 200,
			hidden : true
		}, {
			title : '���տ���',
			field : 'RecLocDesc',
			width : 70
		}, {
			title : 'ҽ������',
			field : 'OeoriDate',
			width : 90,
			hidden: true
		}, {
			title : 'ҽ��¼����',
			field : 'UserAddName',
			width : 70
		}, {
			title : 'Inci',
			field : 'Inci',
			width : 70,
			hidden:'true'
		}
	]];
	var IOeoriMainGrid = $UI.datagrid('#IOeoriMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindInci',
			QueryName: 'QueryOeori'
		},
		columns: OeoriMainCm,
		showBar:false,
		onSelect:function(index, row){
			IOeoriDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.OeoriBindInci',
				QueryName: 'QueryDetail',
				Parref: row.rowid
			});
			InciMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
				QueryName: 'GetDetail',
				Pack: row.Inci
			});
		}
	})
	var InciMainCm = [[{
			title : "PCL",
			field : 'PCL',
			width : 100,
			hidden : true
		}, {
			title : "Inci",
			field : 'Inci',
			width : 120,
			hidden : true
		}, {
			title : '���ʴ���',
			field : 'InciCode',
			width : 150
		}, {
			title : '��������',
			field : 'InciDesc',
			width : 150
		}, {
			title : "���",
			field : 'Spec',
			width : 200
		}, {
			title : "����",
			field : 'PbRp',
			width : 200
		}
	]];
	var InciMainGrid = $UI.datagrid('#InciMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetDetail'
		},
		columns: InciMainCm,
		showBar:false,
		onDblClickRow:function(index, row){
			var inci=row.Inci;
			var incicode=row.InciCode;
			var incidesc=row.InciDesc;
			var qty=1;
			var record={
				inci:inci,
				desc:incidesc,
				qty:1,
				code:incicode
				
			}
			IOeoriDetailGrid.appendRow(record);
		}
	})
	var OeoriDetailCm = [[{
			title : "orirowid",
			field : 'orirowid',
			width : 100,
			hidden : true
		}, {
			title : 'oeori',
			field : 'oeori',
			width : 80,
			hidden : true
		}, {
			title : 'inci',
			field : 'inci',
			width : 80,
			hidden : true
		}, {
			title : '���ʴ���',
			field : 'code',
			width : 80
		}, {
			title : '��������',
			field : 'desc',
			width : 80
		}, {
			title : '����',
			field : 'qty',
			width : 80
		}, {
			title : '��λ',
			field : 'uomdesc',
			width : 80
		}, {
			title: '����',
			field: 'batno',
			width:200,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title: 'Ч��',
			field: 'expdate',
			width:100,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title: '�Դ���',
			field: 'originalcode',
			width:200,
			editor:{
				type:'text',
				options:{
					}
				}
		}, {
			title : '���',
			field : 'specdesc',
			width : 80
		}, {
			title : 'dhcit',
			field : 'dhcit',
			width : 80,
			hidden:'true'
		}, {
			title : '��ֵ����',
			field : 'barcode',
			width : 80
		}, {
			title : '��¼���',
			field : 'IngrFlag',
			width : 80
		}, {
			title : '����',
			field : 'rp',
			width : 80
		}, {
			title : '�ۼ�',
			field : 'sp',
			width : 80
		}, {
			title : '��Ʊ���',
			field : 'invamt',
			width : 80
		}, {
			title : '��Ʊ��',
			field : 'invno',
			width : 80
		}, {
			title : '��Ʊ����',
			field : 'invdate',
			width : 80
		}, {
			title : '����״̬',
			field : 'feestatus',
			width : 80
		}, {
			title : '�����ܶ�',
			field : 'feeamt',
			width : 80
		}, {
			title : '��������',
			field : 'dateofmanu',
			width : 80
		}, {
			title : '��Ӧ��',
			field : 'vendor',
			width : 80
		}, {
			title : '����',
			field : 'manf',
			width : 80
		}
		
	]];
	
	var IOeoriDetailGrid = $UI.datagrid('#IOeoriDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindInci',
			QueryName: 'QueryDetail'
		},
		columns: OeoriDetailCm,
		showBar:false
	})
	function Query(){
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.clear(IOeoriDetailGrid);
		$UI.clear(InciMainGrid);
		IOeoriMainGrid.load({
			ClassName: 'web.DHCSTMHUI.OeoriBindInci',
			QueryName: 'QueryItem',
			Params:Params
		});
	}
	
	Clear();

}
$(init);
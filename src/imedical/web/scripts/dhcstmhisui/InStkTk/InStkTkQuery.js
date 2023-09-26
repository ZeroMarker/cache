var init = function() {
	//=======================������ʼ��start==================
	
	//����
	var LocParams=JSON.stringify(addSessionParams({Type:"LinkLoc"}));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams=function(){
		var Obj={StkGrpType:"M",BDPHospital:gHospId};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	$("#FInciDesc").lookup(InciLookUpOp(HandlerParams,'#FInciDesc','#FInci'));
	//===========================������ʼend===========================
	// ======================tbar�����¼�start=========================
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			Query();
		}
	});
	function Query(){ 
		var ParamsObj=$UI.loopBlock('Conditions');
		if(isEmpty(ParamsObj.FLocId)){
				$UI.msg('alert','���Ҳ���Ϊ��!');
				return;
			}
		if(isEmpty(ParamsObj.FStartDate)){
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
		if(isEmpty(ParamsObj.FEndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			}	
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		$UI.setUrl(MasterGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var Dafult={
				FLocId:gLocObj,
				FStartDate:DateFormatter(new Date()),
				FEndDate:DateFormatter(new Date()),
				FInstComp:"",
				FStkTkComp:"",
				FAdjComp:""
			}
		$UI.fillBlock('#Conditions',Dafult);
		$('#detailtype').tabs('disableTab', 1)
	}
	$UI.linkbutton('#PrintBT',{ 
		onClick:function(){
			Print();
		}
	});
	function Print(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','��������!');
			return;
		}
		var ret = tkMakeServerCall("web.DHCSTMHUI.INStkTk", "UpPrintFlag", row.inst);
		PrintINStk(row.inst, 1);
	}
	function loadDetailGrid(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','��������!');
			return;
		}
		var ParamsObj=$UI.loopBlock('DetailConditions');
		var Params = JSON.stringify(ParamsObj);
		$UI.setUrl(DetailGrid);
		DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItm',
				QueryName: 'jsDHCSTInStkTkItm',
				Inst: row.inst,
				Others:Params,
				qPar:"",
				totalFooter:'"code":"�ϼ�"',
				totalFields:'freezeRpAmt,countRpAmt,varianceRpAmt'
			});
	}
	//������ϸ
	$UI.linkbutton('#QueryDetailBT',{ 
		onClick:function(){
			loadDetailGrid();
		}
	});
	
	//Ҷǩ�л� ����
	$HUI.tabs("#detailtype",{
		onSelect:function(title){
			if(title=="��Ʒ�ֻ���"){
				loadDetailGridRQ();
			}else{
				loadDetailGrid();
			}
		}
	});
	function loadDetailGridRQ(){
		var row = $('#MasterGrid').datagrid('getSelected');
		var Rowid=row.inst;
		var Params=JSON.stringify({Inst:Rowid});
		var p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_INStkTk_GroupInci.raq'
			+"&Inst="+Rowid+"&Params="+Params
		$("#frameInstktkInciPanel").attr("src",p_URL);
	}
	//======================tbar�����¼�end============================
	
	var MasterGridCm = [[ {
			title: 'inst',
			field: 'inst',
			hidden: true
		},{
			title: '�̵㵥��',
			field: 'instNo',
			width:200
		}, {
			title:"����",
			field:'date',
			width:100
		}, {
			title:"ʱ��",
			field:'time',
			width:100
		}, {
			title:"����",
			field:'locDesc',
			width:150
		}, {
			title:"�̵����",
			field:'comp',
			width:70,
			formatter: function(value,row,index){
				if (row.comp=="Y"){
					return "�����";
				} else {
					return "δ���";
				}
			}
		}, {
			title:"ʵ��¼�����",
			field:'stktkComp',
			width:100,
			formatter: function(value,row,index){
				if (row.stktkComp=="Y"){
					return "�����";
				} else {
					return "δ���";
				}
			}
		}, {
			title:"�������",
			field:'adjComp',
			width:70,
			formatter: function(value,row,index){
				if (row.adjComp=="Y"){
					return "�����";
				} else {
					return "δ���";
				}
			}
		}, {
			title:"��־",
			field:'manFlag',
			width:70,
			hidden:true
		}, {
			title:"���̵�λ",
			field:'freezeUom',
			width:70,
			formatter: function(value,row,index){
				if (row.freezeUom==1){
					return "��ⵥλ";
				} else {
					return "������λ";
				}
			}
		}, {
			title:"���̽��۽��",
			field:'SumFreezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"�����ۼ۽��",
			field:'SumFreezeSpAmt',
			width:100,
			align:'right'
		}, {
			title:"ʵ�̽��۽��",
			field:'SumCount1RpAmt',
			width:100,
			align:'right'
		}, {
			title:"ʵ���ۼ۽��",
			field:'SumCount1SpAmt',
			width:100,
			align:'right'
		}, {
			title:"������۽��",
			field:'SumVariance1RpAmt',
			width:100,
			align:'right'
		}, {
			title:"�����ۼ۽��",
			field:'SumVariance1SpAmt',
			width:100,
			align:'right'
		}, {
			title:"����������",
			field:'includeNotUse',
			width:100
		}, {
			title:"��������",
			field:'onlyNotUse',
			width:70
		}, {
			title:"����",
			field:'scgDesc',
			width:100
		}, {
			title:"������",
			field:'scDesc',
			width:100
		}, {
			title:"��ʼ��λ��",
			field:'frSb',
			width:100
		}, {
			title:"������λ��",
			field:'toSb',
			width:100
		}, {
			title:"¼������",
			field:'InputType',
			width:70,
			hidden:true
		}, {
			title:"��ӡ��־",
			field:'printflag',
			width:70,
			hidden:true
		}, {
			title:"��ͽ���",
			field:'MinRp',
			width:70,
			align:'right'
		}, {
			title:"��߽���",
			field:'MaxRp',
			width:70,
			align:'right'
		}, {
			title:"�����",
			field:'RandomNum',
			width:70,
			align:'right'
		}, {
			title:"��ֵ��־",
			field:'HighValueFlag',
			width:70
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid',{
		url : $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk'
		},
		columns: MasterGridCm,
		onSelect:function(index, row){
			var DTTabed = $('#detailtype').tabs('getSelected');  
			var DTTabed=$('#detailtype').tabs('getTabIndex',DTTabed);
			if(DTTabed==0){
				loadDetailGrid();
			}else if(DTTabed==1){
				loadDetailGridRQ();
			}
			
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				$('#detailtype').tabs('enableTab', 1)
				$('#MasterGrid').datagrid("selectRow", 0)
				loadDetailGrid();
			}	
		}
	})
	var DetailGridCm = [[{
			title: 'rowid',
			field: 'rowid',
			hidden: true
		}, {
			title: 'inclb',
			field: 'inclb',
			hidden: true
		}, {
			title: 'inci',
			field: 'inci',
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'code',
			width:120
		}, {
			title: '��������',
			field: 'desc',
			width:150
		}, {
			title: "���",
			field:'spec',
			width:100
		}, {
			title:"����",
			field:'manf',
			width:100
		}, {
			title:"����",
			field:'barcode',
			width:100,
			hidden:true
		}, {
			title:"��������",
			field:'freQty',
			width:100,
			align:'right'
		}, {
			title:"��������",
			field:'freDate',
			width:100
		}, {
			title:"����ʱ��",
			field:'freTime',
			width:100
		}, {
			title:"ʵ������",
			field:'countQty',
			width:100,
			align:'right'
		}, {
			title:"ʵ������",
			field:'countDate',
			width:100
		}, {
			title:"ʵ��ʱ��",
			field:'countTime',
			width:80
		}, {
			title:"ʵ����",
			field:'countPerson',
			hidden: true,
			hidden:true
		}, {
			title:"ʵ����",
			field:'countPersonName',
			width:100
		}, {
			title:"dd",
			field:'variance',
			width:100,
			hidden:true
		}, {
			title:"��ע",
			field:'remark',
			width:60,
			hidden:true
		}, {
			title:"״̬",
			field:'status',
			width:60,
			hidden:true
		}, {
			title:"��λ",
			field:'uom',
			hidden: true,
			hidden:true
		}, {
			title:"��λ",
			field:'uomDesc',
			width:60
		}, {
			title:"����",
			field:'batchNo',
			width:100
		}, {
			title:"��Ч��",
			field:'expDate',
			width:100
		}, {
			title:"������־",
			field:'adjFlag',
			width:60,
			hidden:true
		}, {
			title:"��λ��",
			field:'sbDesc',
			width:100
		}, {
			title:"dd",
			field:'inadi',
			hidden: true,
			align:'right',
			hidden:true
		}, {
			title:"�ۼ�",
			field:'sp',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"����",
			field:'rp',
			width:60,
			align:'right'
		}, {
			title:"�����ۼ۽��",
			field:'freezeSpAmt',
			width:100,
			align:'right',
			hidden:true
		}, {
			title:"���̽��۽��",
			field:'freezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"ʵ���ۼ۽��",
			field:'countSpAmt',
			width:100,
			align:'right',
			hidden:true
		}, {
			title:"ʵ�̽��۽��",
			field:'countRpAmt',
			width:100,
			align:'right'
		}, {
			title:"�����ۼ۽��",
			field:'varianceSpAmt',
			width:100,
			align:'right',
			hidden:true
		}, {
			title:"������۽��",
			field:'varianceRpAmt',
			width:100,
			align:'right'
		}, {
			title:"dd",
			field:'trueQty',
			width:60,
			hidden:true
		}, {
			title:"����",
			field:'scgDesc',
			width:100
		}, {
			title:"��Ӧ��",
			field:'vendor',
			width:100
		}, {
			title:"������",
			field:'incscdesc',
			width:100
		}, {
			title:"������",
			field:'specdesc',
			width:100
		}, {
			title:"dd",
			field:'freeBarCode',
			width:60,
			hidden:true
		}, {
			title:"dd",
			field:'countBarCode',
			width:60,
			hidden:true
		}, {
			title:"dd",
			field:'varianceBarCode',
			width:60,
			hidden:true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			totalFooter:'"code":"�ϼ�"',
			totalFields: 'freezeRpAmt,countRpAmt,varianceRpAmt'
		},
		columns : DetailGridCm
	})
	Clear();
}
$(init);

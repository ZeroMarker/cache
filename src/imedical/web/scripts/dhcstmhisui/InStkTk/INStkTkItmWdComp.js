//�̵����
var init = function() {
	//=======================������ʼ��start==================
	
	//����
	var LocParams=JSON.stringify(addSessionParams({Type:"LinkLoc"}));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	//===========================������ʼend===========================
	// ======================tbar�����¼�start=========================
	//��ѯ
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
		ParamsObj.FInstComp="Y";
		ParamsObj.FAdjComp="N"
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			Params: Params,
			sort:'',
			order:''
		});
	}
	//ȡ�����
	$UI.linkbutton('#CancelCompleteBT',{ 
		onClick:function(){
			CancelComplete();
		}
	});
	function CancelComplete(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','��������!');
			return;
		}
		$.cm({
				ClassName: "web.DHCSTMHUI.INStkTkItmWd",
				MethodName: "StkCancelComplete",
				Inst:row.inst
			},function(jsonData){
				if(jsonData.success>=0){
					$UI.msg('success',jsonData.msg);
					Query();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
	}
	//ȷ�����
	$UI.linkbutton('#CompleteBT',{ 
		onClick:function(){
			Complete();
		}
	});
	function Complete(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','��������!');
			return;
		}
		if(isEmpty(row.InputType)){
			$UI.msg('alert','���̵㵥��δ����ʵ��¼��!');
			return;
		}
		if(row.stktkComp=="Y"){
			$UI.msg('alert','�̵㵥�Ѿ��������!');
			return;
		}
		var clName="";
		var mName="";
		if(row.InputType==1){
			clName="web.DHCSTMHUI.INStkTkItmWd";
			mName="INStkTkWdSum";
		}else if(row.InputType==2){
			clName="web.DHCSTMHUI.InStkTkInput";
			mName="CompleteInput";
		}else if(row.InputType==3){
			clName="web.DHCSTMHUI.INStkTkItmTrack";
			mName="CompleteItmTrack";
		}
		$.cm({
				ClassName: clName,
				MethodName: mName,
				Inst:row.inst,
				UserId:gUserId
			},function(jsonData){
				if(jsonData.success>=0){
					$UI.msg('success',jsonData.msg);
					Query();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
	}
	//����
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var Dafult={
				FLocId:gLocId,
				FStartDate:DateFormatter(new Date()),
				FEndDate:DateFormatter(new Date()),
				FInstComp:"Y",
				FStkTkComp:"",
				FAdjComp:"N"
			}
		$UI.fillBlock('#Conditions',Dafult)
	}
	//�������ʻ�����Ϣ
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
		DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
				QueryName: 'CollectItmCountQty',
				Inst: row.inst,
				Sort:"",
				Dir:""
			});
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
			width:70
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
			loadDetailGrid();
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				$('#MasterGrid').datagrid("selectRow", 0)
				loadDetailGrid();
			}
		}
	})
	//===========================================���ʻ���============================
	var DetailGridCm = [[{
			title: 'Inci',
			field: 'Inci',
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
			title:"��������",
			field:'FreezeQty',
			width:100,
			align:'right'
		}, {
			title:"ʵ������",
			field:'CountQty',
			width:100,
			align:'right'
		}, {
			title:"���½���",
			field:'LastRp',
			width:100,
			align:'right'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			QueryName: 'CollectItmCountQty'
		},
		columns : DetailGridCm,
		onSelect:function(index, row){
			loadInstItmGrid();
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				$('#DetailGrid').datagrid("selectRow", 0)
				loadInstItmGrid();
			}
		}
	})
	function loadInstItmGrid(){
		var MasterRow = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(MasterRow)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(MasterRow.inst)){
			$UI.msg('alert','��������!');
			return;
		}
		var Detailrow = $('#DetailGrid').datagrid('getSelected');
		if(isEmpty(Detailrow)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(Detailrow.Inci)){
			$UI.msg('alert','��������!');
			return;
		}
		InstDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
				MethodName: 'QueryItmTkWdDetail',
				Inst: MasterRow.inst,
				Inci:Detailrow.Inci
			});
		InstItmGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
				MethodName: 'QueryItmTkWd',
				Inst: MasterRow.inst,
				Inci:Detailrow.Inci
			});
	}
	//=============================���λ���=======================================
	var InstItmGridCm=[[{
			title: 'Insti',
			field: 'Insti',
			width:100,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width:100,
			hidden: true
		},{
			title: '����',
			field: 'BatNo',
			width:100
		},{
			title: 'Ч��',
			field: 'ExpDate',
			width:100
		},{
			title: '��λ',
			field: 'FreUomDesc',
			width:100
		},{
			title: '��������',
			field: 'FreQty',
			width:100,
			align:'right'
		},{
			title: 'ʵ������',
			field: 'CountQty',
			width:100,
			align:'right'
		}]]
	var InstItmGrid = $UI.datagrid('#InstItmGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWd'
		},
		columns : InstItmGridCm
	})
	//====================������ϸ=====================
	var InstDetailGridCm = [[{
			title: 'Rowid',
			field: 'Rowid',
			hidden: true,
			width:100
		}, {
			title: 'Inclb',
			field: 'Inclb',
			hidden: true,
			width:100
		}, {
			title: '����',
			field: 'BatNo',
			width:100
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width:100
		}, {
			title: '��λ',
			field: 'CountUom',
			width:100
		}, {
			title: 'ʵ������',
			field: 'CountQty',
			width:100,
			align:'right'
		}, {
			title: 'ʵ������',
			field: 'CountDate',
			width:100
		}, {
			title: 'ʵ��ʱ��',
			field: 'CountTime',
			width:100
		}, {
			title: 'ʵ����',
			field: 'CountUserName',
			width:100
		}
	]];
	var InstDetailGrid = $UI.datagrid('#InstDetailGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWdDetail'
		},
		columns : InstDetailGridCm
	})
	Clear();
}
$(init);
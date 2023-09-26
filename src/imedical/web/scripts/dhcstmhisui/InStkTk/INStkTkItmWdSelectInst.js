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
	//����
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			Clear();
		}
	});
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		var Dafult={
			FLocId:gLocObj,
			FStartDate:DateFormatter(new Date()),
			FEndDate:DateFormatter(new Date()),
			FInstComp:"Y",
			FStkTkComp:"N",
			FAdjComp:"N"
			}
		$UI.fillBlock('#Conditions',Dafult)
	}
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
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.setUrl(MasterGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			Params: Params,
			sort:'',
			order:''
		});
	}
	//ѡȡ
	$UI.linkbutton('#CompleteBT',{ 
		onClick:function(){
			SelectHandler();
		}
	});
	function SelectHandler(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','��������!');
			return;
		}
		SelectModel(row,Select)
		
	}
	
	function Select(selectModel,instwWin) {
		var row = $('#MasterGrid').datagrid('getSelected');
		var InstId=row.inst;
		var PhaLoc=$('#FLocId').combobox('getValue');
		if(isEmpty(PhaLoc)){
			$UI.msg('alert','��ѡ�����!');
			return;
		}
		// ��ת����Ӧ��¼�����
		if(selectModel==1){
			window.location.href='dhcstmhui.instktkitmwd.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==2){
			window.location.href='dhcstmhui.instktkitmwd2.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==3){
			window.location.href='dhcstmhui.instktkinput.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==4){
			window.location.href='dhcstmhui.instktkitmtrack.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}
	}
	
	//======================tbar�����¼�end============================
	
	var MasterGridCm = [[ {
			title: 'inst',
			field: 'inst',
			hidden: true
		},{
			title: '�̵㵥��',
			field: 'instNo',
			width:150
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
			field:'loc',
			hidden:true
		}, {
			title:"����",
			field:'locDesc',
			width:120
		}, {
			title:"�̵����",
			field:'comp',
			width:100,
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
			hidden: true
		}, {
			title:"�������",
			field:'adjComp',
			width:70,
			hidden: true
		}, {
			title:"��־",
			field:'manFlag',
			width:70,
			hidden: true
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
			width:100,
			formatter: function(value,row,index){
				if (row.InputType==1){
					return "������";
				} else if(row.InputType==2){
					return "��Ʒ��";
				}else if(row.InputType==3){
					return "����ֵ����"
				}else {
					return ""
				}
			}
		}, {
			title:"��ӡ��־",
			field:'printflag',
			width:70,
			hidden: true
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
		columns: MasterGridCm
	})
	Clear();
}
$(init);

// ����:��ֵ�������ߴ���
// ��д����:2019-11-05

var init = function() {
	var ComResultBox = $HUI.combobox('#ComResultBox', {
		data:[{'RowId':'0','Description':'�������ϸ�'},{'RowId':'2','Description':'������'},{'RowId':'3','Description':'�ѽ���'}],
		editable:false,
		valueField: 'RowId',
		textField: 'Description',
		onSelect:function(selData){
	    	QueryOrdInfo();
	    },
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function () {
			QueryOrdInfo();
		}

	});
	function QueryOrdInfo() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		OrdItmList.load({
			ClassName: 'web.DHCSTMHUI.CommentComPlain',
			QueryName: 'QueryOrdInfo',
			Params: Params
		});
	}
	var OrdItmListCm = [[{
				title: 'ComitmId',
				field: 'ComitmId',
				width: 80,
				hidden: true
			},{
				title: 'OrdReCheckId',
				field: 'OrdReCheckId',
				width: 80,
				hidden: true
			}, {
				title: "������ϸ״̬",
				field: 'CurrRet',
				width: 100,
				hidden: true,
		        formatter: function(value,row,index){
					if (row.CurrRet==0){
						return "������";
					} else if(row.CurrRet==1){
						return "����";
					}else if(row.CurrRet==2){
						return "������"
					}else if(row.CurrRet==3){
						return "�ѽ���"
					}else if(row.CurrRet==4){
						return "δ����"
					}else {
						return ""
					}
		        }
			}, {
				title: 'ҽ������',
				field: 'Arcim',
				width: 150
			}, {
				title: "����",
				field: 'OrdItmQty',
				width: 150
			}, {
				title: "OeoriUseradd",
				field: 'OeoriUseradd',
				width: 100,
				hidden: true
			}, {
				title: "ҽ��",
				field: 'Doctor',
				width: 100
			}, {
				title: "��ҽ��ʱ��",
				field: 'OeoriDate',
				width: 100
			}
		]];
	var OrdItmList = $UI.datagrid('#OrdItmList', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.CommentComPlain',
				QueryName: 'QueryOrdInfo'
			},
			columns: OrdItmListCm,
			onSelect: function (index, row) {
				var ComitmId = row['ComitmId'];
				ComLogGrid.load({
					ClassName: 'web.DHCSTMHUI.CommentComPlain',
					QueryName: 'QueryLog',
					DetailId: ComitmId
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					OrdItmList.selectRow(0);
				}
			}
		});
	var ComLogCm = [[{
				title: 'RowId',
				field: 'RowId',
				width: 80,
				hidden: true
			}, {
				title: '�������',
				field: 'ComResult',
				width: 100,
		        formatter: function(value,row,index){
					if (row.ComResult=="Y"){
						return "������";
					} else if(row.ComResult=="N"){
						return "����";
					}else {
						return ""
					}
		        }
			}, {
				title: "������",
				field: 'ComUser',
				width: 150
			}, {
				title: '��������',
				field: 'ComDate',
				width: 150
			}, {
				title: '����ʱ��',
				field: 'ComTime',
				width: 100
			}, {
				title: "���ϸ�ԭ��",
				field: 'ComReason',
				width: 100
			}, {
				title: "��������",
				field: 'ComAdvice',
				width: 100
			}, {
				title: "������ע",
				field: 'ComRemark',
				width: 100
			}
		]];
	var ComLogGrid = $UI.datagrid('#ComLogGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.CommentComPlain',
				QueryName: 'QueryLogDteail'
			},
			columns: ComLogCm,
			remoteSort: false
		});
	$UI.linkbutton('#AcceptBT', {
		onClick: function(){
			var Row = OrdItmList.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', '��ѡ����ܵ�ҽ����ϸ!');
				return;
			}
			var OrdReCheckId=Row.OrdReCheckId;
			var ComitmId=Row.ComitmId;
			var CurrRet=Row.CurrRet;
			if(CurrRet!=0){
				$UI.msg('alert', 'ҽ��������(����)����,�����������!');
				return;
			}
			var Params = JSON.stringify(addSessionParams({
				OrdReCheckId:OrdReCheckId,
				ComitmId:ComitmId
			}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.CommentComPlain',
				MethodName: 'jsSave',
				Params:Params,
				DocNote:"Accept"
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					OrdItmList.commonReload();
					DocNote= $("#DocNote").val("");
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$('#ComplainBT').on('click', function(){
		var Row = OrdItmList.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert', '��ѡ�����ߵ�ҽ����ϸ!');
			return;
		}
		var OrdReCheckId=Row.OrdReCheckId;
		var ComitmId=Row.ComitmId;
		var CurrRet=Row.CurrRet;
		if(CurrRet!=0){
			$UI.msg('alert', 'ҽ��������(����)����,�����������!');
			return;
		}
		var Params = JSON.stringify(addSessionParams({
			OrdReCheckId:OrdReCheckId,
			ComitmId:ComitmId
		}));
		var DocNote= $("#DocNote").val();
		if (DocNote == "") {
			$UI.msg('alert', '�����·�ԭ��¼������д����ԭ��');
            return;
        }
		$.cm({
			ClassName: 'web.DHCSTMHUI.CommentComPlain',
			MethodName: 'jsSave',
			Params:Params,
			DocNote:DocNote
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				OrdItmList.commonReload();
				DocNote= $("#DocNote").val("");
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	});
	function SetDefValue() {
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		}
		$UI.fillBlock('#Conditions', DefaultValue);
		$("#ComResultBox").combobox("setValue",0)
	}
	SetDefValue();

}
$(init);
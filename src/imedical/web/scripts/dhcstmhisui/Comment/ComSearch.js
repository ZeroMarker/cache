/*
��������ѯ
*/
var ComSearch=function(Fn){
	$HUI.dialog('#FindWin').open();
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#FindConditions');			
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			}
			
			var Params=JSON.stringify(ParamsObj);
			FindMainGrid.load({
				ClassName: 'web.DHCSTMHUI.Comment',
				QueryName: 'Query',
				Params:Params
			});
		}
	});
	$UI.linkbutton('#FSubmitBT', {
		onClick: function () {
			var Row=FindMainGrid.getSelected();
			if ((isEmpty(Row)) || (Row.length == 0)) {
				$UI.msg('alert', '��ѡ����Ҫ�ύ�ĵ���!');
				return false;
			}
			var ComId=Row.RowId;
			$UI.confirm('����Ҫ�ύ��ѡ����,�ύ������ȡ���ύ,�Ƿ����?', '', '', ComSubmit);		
		}
	});
	function ComSubmit() {
		showMask();
		var Row=FindMainGrid.getSelected();
		var ComId=Row.RowId;
		$.cm({
			ClassName: 'web.DHCSTMHUI.Comment',
			MethodName: 'Submit',
			ComId: ComId
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				FindMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			};
		});
	}
	var ComMainCm = [[{
			title : "������ID",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : "��������",
			field : 'ComNo',
			width : 200
		}, {
			title : "������״̬",
			field : 'Status',
			width : 200,
	        formatter: function(value,row,index){
				if (row.Status==0){
					return "δ����";
				} else if(row.Status==1){
					return "������";
				}else if(row.Status==2){
					return "�������"
				}else if(row.Status==3){
					return "���ύ"
				}else {
					return ""
				}
	        }
		}, {
			title : "�Ƶ�����",
			field : 'CreateDate',
			width : 200
		}, {
			title : "�Ƶ�ʱ��",
			field : 'CreateTime',
			width : 200
		}, {
			title : '�Ƶ���',
			field : 'CreateUser',
			width : 150
		}, {
			title : '��ȡ����',
			field : 'Conditions',
			width : 200
		}	
	]];
	$UI.linkbutton('#FClearBT',{
		onClick:function(){
			Clear();
		}
	});
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(FindMainGrid);
	///���ó�ʼֵ ����ʹ������
		var Dafult={StartDate: DateFormatter(new Date()),
					EndDate: DateFormatter(new Date()),
					}
		$UI.fillBlock('#FindConditions',Dafult)
	}
	$UI.linkbutton('#FReturnBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#FindConditions');	
			var RetStatus=ParamsObj.FResult;
			var Row=FindMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','��ѡ��Ҫ���صĵ�����!');
			}
			Fn(Row.RowId,RetStatus);
			$HUI.dialog('#FindWin').close();
		}
	});
	var FindMainGrid = $UI.datagrid('#FindMainGrid', {
		lazy:false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Comment',
			QueryName: 'Query'
		},
		columns: ComMainCm,
		onDblClickRow:function(index, row){
			var ParamsObj=$UI.loopBlock('#FindConditions');	
			var RetStatus=ParamsObj.FResult;
			Fn(row.RowId,RetStatus);
			$HUI.dialog('#FindWin').close();
		}
	})
	Clear()

}
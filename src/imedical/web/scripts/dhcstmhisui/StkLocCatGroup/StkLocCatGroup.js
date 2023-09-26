/*�����Լ���Ա������Ȩ*/
var init = function () {
	/// δ��Ȩ����
	var StkCatGroupCm= [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '����',
			field: 'Code',
			width:60,
			hidden: true
		}, {
			title: '����',
			field: 'Description',
			width:150
		}
	]];

	var StkCatGroupGrid = $UI.datagrid('#StkCatGroupGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INCSTKCAT',
			QueryName: 'SelectAll',
			rows:99999			
		},
		columns: StkCatGroupCm,
		fitColumns: true,
		sortName: 'RowId',  
		sortOrder: 'Desc',
		pagination: false,
		onSelect: function (index, row) {
			SearchBT();
		}
	})
	
	/// ��Ȩ����
	var AuthorStkCatGroupCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		},{
			title: 'GrpId',
			field: 'GrpId',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'GrpCode',
			width:100,
			hidden: true
		}, {
			title: '����',
			field: 'GrpDesc',
			width:150
		}, {
			title: '�Ƿ�Ĭ��',
			field: 'DefaultFlag',  
			width:130,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}, {
			title: '�±���־',
			field: 'MonFlag',
			width:130,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}
	]];
	function SearchAuthorStkBT(LocId) {
		if (isEmpty(LocId)){
			$UI.msg("alert","��ѡ�����");
			return false;
		}
		AuthorStkCatGroupGrid.load({
			ClassName: 'web.DHCSTMHUI.StkLocCatGroup',
			QueryName: 'Query',
			LocId: LocId,
			rows:99999
		});
	}
	/// ������Ȩ����
	var AuthorStkCatGroupTB = [{
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = AuthorStkCatGroupGrid.getChangesData();
				if(isEmpty(Rows)){
					$UI.msg('alert','û����Ҫ�������Ϣ!');
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.StkLocCatGroup',
					MethodName: 'Save',
					Params: JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						AuthorStkCatGroupGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					 }
				});
			}
		}
	];
	var AuthorStkCatGroupGrid = $UI.datagrid('#AuthorStkCatGroupGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkLocCatGroup',
			QueryName: 'Query',
			rows:99999				
		},
		columns: AuthorStkCatGroupCm,
		fitColumns: true,
		toolbar: AuthorStkCatGroupTB,
		sortName: 'RowId',  
		sortOrder: 'Desc',   
		pagination:false,
		onClickCell: function(index, filed ,value){
			var Row=AuthorStkCatGroupGrid.getRows()[index];
			var SLCGRowId=Row.RowId;
			SearchLocUserBT(SLCGRowId);
			AuthorStkCatGroupGrid.commonClickCell(index,filed)
		}
	});
	
	/// ������Ա
	function SearchLocUserBT(SLCGRowId) {
		if (isEmpty(SLCGRowId)){
			$UI.msg("alert","��ѡ������Ȩ����");
			return false;
		}
		LocUserGrid.load({
			ClassName: 'web.DHCSTMHUI.StkLocUserCatGrp',
			QueryName: 'GetDeptUser',
			SLCGRowId: SLCGRowId,
			rows:99999
		});
	}
	var LocUserGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			width:50,
			hidden: true
		},{
			title: '��Ա����',
			field: 'Initial', 
			width:60
		},{
			title: '����',
			field: 'Description',
			width:60
		},{
			title: 'DHCSLCGId',
			field: 'DHCSLCGId',
			width:50,
			hidden: true
		}, {
			title: 'Ĭ�ϱ�־',
			field: 'Default',
			width:60,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}, {
			title: '�����־',
			field: 'Active',
			width:60,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}, {
			title: '��Ȩ��־',
			field: 'AuthorFlag',
			width:60,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}
	]];
	//������Ա��Ȩ����
	var LocUserBar = [{
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = LocUserGrid.getChangesData();
				if(isEmpty(Rows)){
					$UI.msg('alert','û����Ҫ�������Ϣ!');
					return;
				}
				var AscgRow=AuthorStkCatGroupGrid.getSelected();
				if(isEmpty(AscgRow)){
					$UI.msg('alert','��ѡ��һ����Ȩ����!');
					return;
				}
				var LocGrpId= AscgRow.RowId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.StkLocUserCatGrp',
					MethodName: 'SaveLocUser',
					Params: JSON.stringify(Rows),
					LocGrpId:LocGrpId
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						LocUserGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					 }
				});
			}
		}
	]; 
	var LocUserGrid = $UI.datagrid('#LocUserGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.StkLocUserCatGrp',
				QueryName: 'GetDeptUser',
				rows:99999
			},
			columns: LocUserGridCm,
			fitColumns: true,
			toolbar: LocUserBar,
			pagination:false,
			onClickCell: function(index, field ,value){
				LocUserGrid.commonClickCell(index,field)
			}
	});
	
	// ����
	$UI.linkbutton('#LocSaveBT', {
		onClick: function () {
			LocSaveBT();
		}
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function () {
			SearchBT();
		}
	});
	
	var LocGridCm = [[{
				title: 'RowId',
				field: 'RowId',
				hidden: true
			}, {
				title: '��������',
				field: 'Description',
				width: 250
			}, {
				title: '��Ȩ��־',
				field: 'AuthorFlag',
				width:100,
				align:'center',
				formatter:BoolFormatter,
				editor:{type:'checkbox',options:{on:'Y',off:'N'}}
			}
		]];
	var LocGrid = $UI.datagrid('#LocGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.StkLocCatGroup',
				QueryName: 'GetCTLoc',
				rows:99999
			},
			columns: LocGridCm,
			pagination:false,   
			onClickCell: function(index, filed ,value){
				var Row=LocGrid.getRows()[index];
				var Locid=Row.RowId;
				if (!isEmpty(Locid)){
					SearchAuthorStkBT(Locid);
				}
				LocGrid.commonClickCell(index,filed);
			}
		});
	function SearchBT() {
		var ParamstmpObj = $UI.loopBlock('LocTB');
		var Row = StkCatGroupGrid.getSelected();
		var gSCGid="";
		if (!isEmpty(Row)){
			var gSCGid = Row['RowId'];
		}
		ParamsObj = jQuery.extend(true, addSessionParams(ParamstmpObj), {
				gSCGid: gSCGid
			});
		var Params = JSON.stringify(ParamsObj);
		LocGrid.load({
			ClassName: 'web.DHCSTMHUI.StkLocCatGroup',
			QueryName: 'GetCTLoc',
			Params: Params,
			rows:99999
		});
	}
	/// ������Ȩ����
	function LocSaveBT() {
		var Row = StkCatGroupGrid.getSelected();
		if (isEmpty(Row)){
			$UI.msg("alert","��ѡ��һ������");
			return false;
		}
		var gSCGid = Row['RowId'];
		var DefaultFlag="Y";
		var MonFlag="Y";
		var listData=gSCGid+"^"+DefaultFlag+"^"+MonFlag;
		var Detail=LocGrid.getChangesData('RowId');
		if((Detail===false)||(isEmpty(Detail))){
			$UI.msg('alert','û����Ҫ�������Ϣ!');
			return false;
		};
		$.cm({
			ClassName: 'web.DHCSTMHUI.StkLocCatGroup',
			MethodName: 'SaveLoc',
			Params: JSON.stringify(Detail),
			listData:listData
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				LocGrid.reload()
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
		SearchBT();
	}
}
$(init);

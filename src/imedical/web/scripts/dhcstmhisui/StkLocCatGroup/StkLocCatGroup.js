/*科室以及人员类组授权*/
var init = function () {
	/// 未授权类组
	var StkCatGroupCm= [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width:60,
			hidden: true
		}, {
			title: '描述',
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
	
	/// 授权类组
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
			title: '代码',
			field: 'GrpCode',
			width:100,
			hidden: true
		}, {
			title: '描述',
			field: 'GrpDesc',
			width:150
		}, {
			title: '是否默认',
			field: 'DefaultFlag',  
			width:130,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}, {
			title: '月报标志',
			field: 'MonFlag',
			width:130,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}
	]];
	function SearchAuthorStkBT(LocId) {
		if (isEmpty(LocId)){
			$UI.msg("alert","请选择科室");
			return false;
		}
		AuthorStkCatGroupGrid.load({
			ClassName: 'web.DHCSTMHUI.StkLocCatGroup',
			QueryName: 'Query',
			LocId: LocId,
			rows:99999
		});
	}
	/// 保存授权类组
	var AuthorStkCatGroupTB = [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = AuthorStkCatGroupGrid.getChangesData();
				if(isEmpty(Rows)){
					$UI.msg('alert','没有需要保存的信息!');
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
	
	/// 科室人员
	function SearchLocUserBT(SLCGRowId) {
		if (isEmpty(SLCGRowId)){
			$UI.msg("alert","请选择已授权类组");
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
			title: '人员工号',
			field: 'Initial', 
			width:60
		},{
			title: '姓名',
			field: 'Description',
			width:60
		},{
			title: 'DHCSLCGId',
			field: 'DHCSLCGId',
			width:50,
			hidden: true
		}, {
			title: '默认标志',
			field: 'Default',
			width:60,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}, {
			title: '激活标志',
			field: 'Active',
			width:60,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}, {
			title: '授权标志',
			field: 'AuthorFlag',
			width:60,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}
	]];
	//科室人员授权保存
	var LocUserBar = [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = LocUserGrid.getChangesData();
				if(isEmpty(Rows)){
					$UI.msg('alert','没有需要保存的信息!');
					return;
				}
				var AscgRow=AuthorStkCatGroupGrid.getSelected();
				if(isEmpty(AscgRow)){
					$UI.msg('alert','请选择一个授权类组!');
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
	
	// 科室
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
				title: '科室描述',
				field: 'Description',
				width: 250
			}, {
				title: '授权标志',
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
	/// 保存授权科室
	function LocSaveBT() {
		var Row = StkCatGroupGrid.getSelected();
		if (isEmpty(Row)){
			$UI.msg("alert","请选择一个类组");
			return false;
		}
		var gSCGid = Row['RowId'];
		var DefaultFlag="Y";
		var MonFlag="Y";
		var listData=gSCGid+"^"+DefaultFlag+"^"+MonFlag;
		var Detail=LocGrid.getChangesData('RowId');
		if((Detail===false)||(isEmpty(Detail))){
			$UI.msg('alert','没有需要保存的信息!');
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

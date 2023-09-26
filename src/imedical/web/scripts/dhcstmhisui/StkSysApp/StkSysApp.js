//应用程序维护
var HospId="";
var TableName="DHC_StkSysApp" 
function InitHosp() {
			var hospComp=InitHospCombo(TableName,gSessionStr);
			if (typeof hospComp ==='object'){
				HospId=$HUI.combogrid('#_HospList').getValue();
				$('#_HospList').combogrid("options").onSelect=function(index,record){
					HospId=record.HOSPRowId;
					Query();
				};
			}else{
				HospId=gHospId;
			}
		}
function GetHospId() {
		var HospId="";
		if ($("#_HospList").length!=0){
			HospId=$HUI.combogrid('#_HospList').getValue();
		}else{
			HospId=gHospId;
		}
		return HospId;
}
var init = function(){
	$HUI.tabs("#AppTabs", {
		onSelect: function (title, index) {
			if (title == "单号规则") {
				TableName="DHC_StkSysCounter";
			}
			else if (title == "应用程序") {
				TableName="DHC_StkSysApp";
			}
			InitHosp();
			Query();
		}
	});
	var StkSysSaveBT = {
		iconCls: 'icon-save',
		text: '保存',
		handler: function(){
			var Rows = StkSysAppGrid.getChangesData('Code');
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			var ExistNewRow = false;
			for(var i = 0, Len = Rows.length; i < Len; i++){
				if(isEmpty(Rows[i]['RowId'])){
					ExistNewRow = true;
					break;
				}
			}
			if(ExistNewRow){
				$UI.confirm('一旦保存,代码不可修改,是否继续?','','',StkSysAppSave);
			}else{
				StkSysAppSave();
			}
		}
	};
	
	function StkSysAppSave(){
		var Rows = StkSysAppGrid.getChangesData('Code');
		if (Rows === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCStkSysApp',
			MethodName: 'Save',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				StkSysAppGrid.reload();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var StkSysAppType = {
		type: 'combobox',
		options: {
			data: [{RowId: 'B', Description: '业务'}, {RowId: 'Q', Description: '查询'},
				{RowId: 'S', Description: '统计'}, {RowId: 'M', Description: '维护'}
			],
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'local'
		}
	};
	
	var StkSysAppGrid = $UI.datagrid('#StkSysAppGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkSysApp',
			MethodName: 'SelectAll',
			rows: 999
		},
		pagination: false,
		toolbar: [StkSysSaveBT],
		showAddDelItems: true,
		fitColumns: true,
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				width: 80,
				hidden: true
			},{
				title: '代码',
				field: 'Code',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},{
				title: '名称',
				field: 'Desc',
				width: 300,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},{
				title: '模块类别',
				field: 'Type',
				width: 200,
				editor: StkSysAppType,
				formatter: CommonFormatter(StkSysAppType)
			}
		]],
		onClickCell: function(index, field ,value){
			StkSysAppGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field){
			var RowData = $(this).datagrid('getRows')[index];
			if(field == 'Code' && !isEmpty(RowData['RowId'])){
				return false;
			}
			return true;
		}
	});
	InitHosp();
	initCounte();
}
$(init);

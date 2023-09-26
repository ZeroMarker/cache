
//双签字标志变量
gHVSignFlag = typeof(gHVSignFlag)=='undefined'? '' : gHVSignFlag;

var init = function(){
	
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			FindWin(QueryTrans, gHVSignFlag,"N");
		}
	});
	
	function Select(RowId){
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: RowId
		}, function(jsonData){
			$UI.fillBlock('#Conditions',jsonData);
			SetEditDisable();
			var InitComp = jsonData['InitComp'];
			var InitState = jsonData['InitState'];
			if(InitComp == 'Y'){
				if(InitState == '21'){
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
						'#CancelCompBT':false, '#AuditOutYesBT':false, '#AuditInYesBT':true};
				}else if(InitState == '31'){
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
						'#CancelCompBT':false, '#AuditOutYesBT':false, '#AuditInYesBT':false};
				}else{
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
						'#CancelCompBT':true, '#AuditOutYesBT':true, '#AuditInYesBT':false};
				}
			}else{
				var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':true, '#CompleteBT':true,
					'#CancelCompBT':false, '#AuditOutYesBT':false, '#AuditInYesBT':false};
			}
			ChangeButtonEnable(BtnEnaleObj);
		});
		
		var ParamsObj = {Init: RowId};
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			Params: Params,
			rows:99999,
			totalFooter:'"InciCode":"合计"',
			totalFields:'RpAmt,SpAmt'
		});
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var MainObj = $UI.loopBlock('#Conditions');
			
			var IsChange=$UI.isChangeBlock('#Conditions')
			var SelectedRow = DetailGrid.getSelected();
			if (isEmpty(SelectedRow)&&IsChange==false) {
				$UI.msg('alert',"没有需要保存的内容!");
				return;
			}
			if(MainObj['InitComp'] == 'Y'){
				$UI.msg('alert', '该单据已经完成,不可重复保存!');
				return;
			}
			if(InitParamObj['RequestNeeded'] == 'Y' && isEmpty(MainObj['ReqId'])){
				$UI.msg('alert', '只能根据请求单转移制单,不可保存新记录!');
				return;
			}
			if(isEmpty(MainObj['InitFrLoc'])){
				$UI.msg('alert', '出库科室不可为空!')
				return;
			}
			if(isEmpty(MainObj['InitToLoc'])){
				$UI.msg('alert', '接收科室不可为空!')
				return;
			}
			if(MainObj['InitFrLoc']==MainObj['InitToLoc']){
				$UI.msg('alert', '出库科室不允许与接收科室相同!')
				return;
			}
			MainObj['InitState'] = '10';
			var Main = JSON.stringify(MainObj);
			var Detail = DetailGrid.getChangesData('Inclb');
			if (Detail === false){	//未完成编辑或明细为空
				return;
			}
			if (!IsChange && isEmpty(Detail)){	//明细不变
				$UI.msg("alert", "没有需要保存的信息!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsSave',
				Main: Main,
				Detail: JSON.stringify(Detail)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					Select(InitId);
					if(InitParamObj['AutoPrintAfterSave'] == 'Y'){
						PrintInIsTrf(InitId, 'Y');
					}
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function Complete(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if(InitComp == 'Y'){
				$UI.msg('alert', '该单据已完成,不可重复操作!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			var AutoAuditFlag = gHVSignFlag == 'Y'? 'N' : '';	//双签字功能,不进行自动审核
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsSetCompleted',
				Params: Params,
				AutoAuditFlag: AutoAuditFlag
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					Select(InitId);
					//$('#InitComp').checkbox('setValue', true);
					var RowIndex = MasterGrid.find('RowId', InitId);
					if(RowIndex != -1){
						MasterGrid.updateRow({
							index: RowIndex,
							row: {'StatusCode': '已完成'}			//如此自动审核,这里??
						});
					}
//					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
//						'#CancelCompBT':true, '#AuditOutYesBT':true, '#AuditInYesBT':false};
//					ChangeButtonEnable(BtnEnaleObj);
					//完成后自动打印 或 完成后自动出库审核，出库审核后自动打印
					if((InitParamObj.AutoPrintAfterComp=='Y') || (InitParamObj.AutoAckOutAfterCompleted=='Y' && InitParamObj.AutoPrintAfterAckOut=='Y')){
						PrintInIsTrf(InitId, 'Y');
					}
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
	}
	// 完成前控额判断提示
	function CheckDataBeforeComplete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var InitId = ParamsObj['RowId'];
		if(isEmpty(InitId)){
			$UI.msg('alert', '无需要处理的单据');
			return false;
		}
		var checkret=tkMakeServerCall("web.DHCSTMHUI.LocLimitAmt","CheckIfExcess",InitId); //检查科室申请额度
		var checqtykret=tkMakeServerCall("web.DHCSTMHUI.LocLimitAmt","CheckIfExcessQty",InitId);  ///检查科室限领数量
		if ((checkret=="")&&(checqtykret=="")){return true;}
		var checkret="^"+checkret+"^";
		var rowData = DetailGrid.getRows();
		var rowCount = rowData.length;
		var whiteColor = '#FFFFFF';
		var yellowColor = '#FFFF00';
		for (var i = 0; i < rowCount; i++) {
			SetGridBgColor(DetailGrid,i,'RowId',whiteColor);
		}
		var count=0;
		for (var i = 0; i < rowCount; i++) {
			var initi = rowData[i].RowId;
			var chl=initi.split("||")[1];
			var tmpchl="^"+chl+"^";
			if (checkret.indexOf(tmpchl)>=0) {
				SetGridBgColor(DetailGrid,i,'RowId',yellowColor);
				count=count+1;
				continue;
			}
		}
		if (count>0){
			$UI.msg('alert', '以下汇总明细金额已超过科室限定额度!');
			return false;
		}
		var checqtykret=","+checqtykret+",";
		for (var i = 0; i < rowCount; i++) {
			SetGridBgColor(DetailGrid,i,'RowId',whiteColor);
		}
		var countqty=0;
		for (var i = 0; i < rowCount; i++) {
			var initi = rowData[i].RowId;
			var chl=initi.split("||")[1];
			var tmpchl=","+chl+",";
			if (checqtykret.indexOf(tmpchl)>=0) {
				SetGridBgColor(DetailGrid,i,'RowId',yellowColor);
				countqty=countqty+1;
				continue;
			}
		}
		if (countqty>0){
			$UI.msg('alert', '以下黄颜色背景的记录总数超过科室限定申领数量!');
			return false;
		}
		return true;
	}
	$UI.linkbutton('#CompleteBT', {
		onClick: function(){
			var rowData = DetailGrid.getRows();
			if (rowData.length<1){
				$UI.msg('alert', '该单据没有明细!');
				return false;
			}
			if((InitParamObj.UseLocLimitAmt=="Y")||(GetAppPropValue('DHCSTINREQM').UseLocLimitQty=="Y")){
				if (CheckDataBeforeComplete()){Complete();}
			}else{Complete();}
		}
	});
	$UI.linkbutton('#CancelCompBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if(InitComp != 'Y'){
				$UI.msg('alert', '该单据不是完成状态,不可操作!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsCancelComplete',
				Params: Params
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					Select(InitId);
					//$('#InitComp').checkbox('setValue', false);
					var RowIndex = MasterGrid.find('RowId', InitId);
					if(RowIndex != -1){
						MasterGrid.updateRow({
							index: RowIndex,
							row: {'StatusCode': '未完成'}	
						});
					}
//					var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':true, '#CompleteBT':true,
//						'#CancelCompBT':false, '#AuditOutYesBT':false, '#AuditInYesBT':false};
//					ChangeButtonEnable(BtnEnaleObj);
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if(InitComp == 'Y'){
				$UI.msg('alert', '该单据已经完成,不可删除!');
				return;
			}
			$UI.confirm('您将要删除单据,是否继续?', '', '', Delete);
		}
	});
	function Delete(){
		var ParamsObj = $UI.loopBlock('#Conditions');
		var InitId = ParamsObj['RowId'];
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsDelete',
			Params: Params
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				var RowIndex = MasterGrid.find('RowId', InitId);
				if(RowIndex != -1){
					MasterGrid.deleteRow(RowIndex);
				}
				Clear();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function(){
			Clear();
		}
	});
	function Clear(){
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		SetDefaValues();
		var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':false, '#CompleteBT':false,
					'#CancelCompBT': false, '#AuditOutYesBT':false, '#AuditInYesBT':false};
		ChangeButtonEnable(BtnEnaleObj);
		SetEditEnable();
		CheckLocationHref(gInitId);
		$('#InitScg').combotree('options')['setDefaultFun']()
	}
	function SetEditDisable(){
		$HUI.combobox('#InitFrLoc').disable();
		$HUI.combobox('#InitToLoc').disable();
		$HUI.combobox('#InitScg').disable();
	}
	function SetEditEnable(){
		$HUI.combobox('#InitFrLoc').enable();
		$HUI.combobox('#InitToLoc').enable();
		$HUI.combobox('#InitScg').enable();
	}
	
	$UI.linkbutton('#PrintBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			if(InitParamObj['PrintNoComplete']=='N' && ParamsObj['InitComp'] != 'Y'){
				Msg.info('warning','不允许打印未完成的转移单!');
				return;
			}
			PrintInIsTrf(InitId);
		}
	});
	
	$UI.linkbutton('#SelReqBT', {
		onClick: function(){
			SelReq(QueryTrans,"","N");
		}
	});
	
	function QueryTrans(InitStr){
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'QueryTrans',
			InitStr: InitStr,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#AuditOutYesBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				$UI.msg('alert', '请选择审核的转移单!');
				return;
			}
			var LocId = $HUI.combobox('#InitFrLoc').getValue();
			var UserCode = session['LOGON.USERCODE'];
			var ParamsObj = {LocId: LocId, UserId: gUserId, UserCode: UserCode};
			VerifyPassWord(ParamsObj, AuditOutYes);
		}
	});
	function AuditOutYes(OperUserId){
		var ParamsObj = $UI.loopBlock('#Conditions');
		var InitId = ParamsObj['RowId'];
		if (isEmpty(InitId)) {
			return;
		}
		var InitComp = ParamsObj['InitComp'];
		if(InitComp == false){
			$UI.msg('alert', '转移单尚未完成!');
			return;
		}
		//检查高值材料标签录入情况
		if(CheckHighValueLabels('T', InitId) == false){
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsTransOutAuditYesStr',
			InitStr: InitId,
			UserId: OperUserId,
			GroupId: gGroupId,
			AutoAuditInFlag: 'N'
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', '审核成功!');
				Select(InitId);
				if(InitParamObj['AutoPrintAfterAckOut'] == 'Y'){
					PrintInIsTrf(InitId, 'Y');
				}
			}else{
				$UI.msg('error', jsonData.msg);
			}
			hideMask();
		});
	}
	
	$UI.linkbutton('#AuditInYesBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				$UI.msg('alert', '请选择接收的转移单');
				return;
			}
			var LocId = $HUI.combobox('#InitToLoc').getValue();
			var UserId = $HUI.combobox('#InitReqUser').getValue();
			var UserName = $HUI.combobox('#InitReqUser').getText();
			var UserCode = '';
			if(!isEmpty(UserId) && !isEmpty(UserName)){
				try{
					UserCode = UserName.split('[')[1].split(']')[0];
				}catch(e){}
				if(UserCode == ''){
					UserId = '';
				}
			}
			var ParamObj = {LocId: LocId, UserId: UserId, UserCode: UserCode};
			VerifyPassWord(ParamObj, AuditInYes);
		}
	});
	function AuditInYes(OperUserId){
		var ParamsObj = $UI.loopBlock('#Conditions');
		var InitId = ParamsObj['RowId'];
		if(isEmpty(InitId)){
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsTransInAuditYes',
			Init: InitId,
			UserId: OperUserId
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				Select(InitId);
				if(InitParamObj['AutoPrintAfterAckIn'] == 'Y'){
					PrintInIsTrf(InitId, 'Y');
				}
			}else{
				$UI.msg('error', jsonData.msg);
			}
			hideMask();
		});
	}
	
	var InitFrLoc = $HUI.combobox('#InitFrLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'Login'})),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function (record) {
			var FrLoc = InitFrLoc.getValue();
			var ToLoc = InitToLoc.getValue();
			$HUI.combotree('#InitScg').setFilterByLoc(FrLoc, ToLoc);
		}
	});
	$('#InitFrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var InitToLoc = $HUI.combobox('#InitToLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record){
			var LocId = record['RowId'];
			$('#InitReqUser').combobox('clear');
			$('#InitReqUser').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({LocDr:LocId})
			);
			var FrLoc = InitFrLoc.getValue();
			var ToLoc = InitToLoc.getValue();
			$HUI.combotree('#InitScg').setFilterByLoc(FrLoc, ToLoc);
		}
	});
	
	var InitReqUser = $HUI.combobox('#InitReqUser',{
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var OperateType = $HUI.combobox('#OperateType',{
		url : $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type: 'OM'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var InitState = $('#InitState').simplecombobox({
		data: [
			{RowId: '10', Description: '未完成'},
			{RowId: '11', Description: '已完成'},
			{RowId: '20', Description: '出库审核不通过'},
			{RowId: '21', Description: '出库审核通过'},
			{RowId: '30', Description: '拒绝接收'},
			{RowId: '31', Description: '已接收'}
		]
	});
	
	
	var MasterCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '科室Id',
			field: 'FrLoc',
			width: 100,
			hidden: true
		}, {
			title: '科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '单据状态',
			field: 'StatusCode',
			width: 70
		}
	]];
	
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'QueryTrans'
		},
		columns: MasterCm,
		showBar: false,
		pagination: false,
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				MasterGrid.selectRow(0);
			}
		},
		onSelect: function(index, row){
			var Init = row['RowId'];
			Select(Init);
		}
	});
	
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			onBeforeLoad:function(param){
				var Select = DetailGrid.getRows()[DetailGrid.editIndex];
				if(!isEmpty(Select)){
					var Inci = Select.Inclb.split('||')[0];
					param.Inci = Inci;
				}
			},
			onSelect: function (record) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				row.UomDesc = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.UomId;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) {
					return false;
				}
				var BUomId = row.BUomId;
				
				var Rp = row.Rp;
				var InclbQty = row.InclbQty;
				var Qty = row.Qty;
				var Sp = row.Sp;
				var RpAmt = row.RpAmt;
				var SpAmt = row.SpAmt;
				var ReqQty = row.ReqQty;
				var InclbDirtyQty = row.InclbDirtyQty;
				var DirtyQty = row.DirtyQty;
				var InclbAvaQty = row.InclbAvaQty;
				var confac = row.ConFac;
				if (NewUomid == BUomId) { //入库单位转换为基本单位
					row.Rp = Number(Rp).div(confac);
					row.Sp = Number(Sp).div(confac);
					if(InclbQty!=""){
					row.InclbQty=Number(InclbQty).mul(confac)	
					}
					if(Qty!=""){
					row.Qty=Number(Qty).mul(confac)	
					}
					if(ReqQty!=""){
					row.ReqQty=Number(ReqQty).mul(confac)	
					}
					if(InclbDirtyQty!=""){
					row.InclbDirtyQty=Number(InclbDirtyQty).mul(confac)	
					}
					if((DirtyQty!="")&&(DirtyQty!=undefined)){
					row.DirtyQty=Number(DirtyQty).mul(confac)	
					}
					if(InclbAvaQty!=""){
					row.InclbAvaQty=Number(InclbAvaQty).mul(confac)	
					}
				} else { //基本单位转换为入库单位
					row.Rp = Number(Rp).mul(confac);
					row.Sp = Number(Sp).mul(confac);
					if(InclbQty!=""){
					row.InclbQty=Number(InclbQty).div(confac)	
					}
					if(Qty!=""){
					row.Qty=Number(Qty).div(confac)	
					}
					if(ReqQty!=""){
					row.ReqQty=Number(ReqQty).div(confac)	
					}
					if(InclbDirtyQty!=""){
					row.InclbDirtyQty=Number(InclbDirtyQty).div(confac)	
					}
					if(DirtyQty!=""){
					row.DirtyQty=Number(DirtyQty).div(confac)	
					}
					if(InclbAvaQty!=""){
					row.InclbAvaQty=Number(InclbAvaQty).div(confac)	
					}
				}
				row.UomId = NewUomid;
				$('#DetailGrid').datagrid('refreshRow', DetailGrid.editIndex);
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};
	
	var DetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			jump:false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			},
			width: 180
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		},{
			title: 'Inclb',
			field: 'Inclb',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '厂商',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '出库数量',
			field: 'Qty',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					required: true
				}
			},
			align: 'right',
			width: 80
		}, {
			title: '单位',
			field: 'UomId',
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId','UomDesc'),
			editor: UomCombox,
			width: 80
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '物资条码',
			field: 'BarCode',
			editor: {
				type: 'validatebox',
				options: {
				}
			},
			width: 160
		}, {
			title: '灭菌批号',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '请求数量',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: '占用数量',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '本次占用',
			field: 'DirtyQty',
			align: 'right',
			width: 80
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}, {
			title: 'Inrqi',
			field: 'Inrqi',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '请求备注',
			field: 'ReqRemark',
			width: 100
		}, {
			title: "BUomId",
			field: 'BUomId',
			width: 100,
			hidden: true
		},{
			title: "ConFac",
			field: 'ConFac',
			width: 100,
			hidden: true
		},{
			title: '具体规格',
			field: 'SpecDesc',
			width: 80
		},{
			title: '型号',
			field: 'Model',
			width: 80
		}
	]];
	
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			rows:99999,
			totalFooter:'"InciCode":"合计"',
			totalFields:'RpAmt,SpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			MethodName: 'jsDelete'
		},
		columns: DetailCm,
		remoteSort: false,
		showBar: true,
		showAddDelItems: true,
		pagination: false,
		beforeAddFn: function(){
			if(InitParamObj['RequestNeeded'] == 'Y'){
				$UI.msg('alert', '只能根据请求单转移制单,不可新增记录!');
				return;
			}
			if($('#InitComp').val() == 'Y'){
				$UI.msg('alert', '单据已完成, 不可增加');
				return false;
			}
			if(isEmpty($HUI.combobox('#InitToLoc').getValue())){
				$UI.msg('alert', '接收科室不可为空!');
				return false;
			}
			var OperateType = $HUI.combobox('#OperateType').getValue();
			if(InitParamObj.OutTypeNotNull == 'Y' && isEmpty(OperateType)){
				$UI.msg('alert', '请选择出库类型!');
				return false;
			}
			if(isEmpty($HUI.combotree('#InitScg').getValue())){
				$UI.msg('alert', '类组未选择,请谨慎核实数据!');
			}
			return true;
		},
		afterAddFn: function(){
			SetEditDisable();
			var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':false, '#CompleteBT':true, '#CancelCompBT':false};
			ChangeButtonEnable(BtnEnaleObj);
		},
		onClickCell: function(index, field, value){
			DetailGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field){
			var InitComp = $('#InitComp').val();
			if(InitComp == 'Y'){
				return false;
			}
		},
		onBeginEdit: function(index, row){
			//增加完成情况字数输入限制
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == 'InciDesc'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var Input = $(this).val();
							var InitScg = $('#InitScg').combotree('getValue');
							var InitFrLoc = $('#InitFrLoc').combobox('getValue');
							var InitToLoc = $('#InitToLoc').combobox('getValue');
							var HV = 'N';
							//NoLocReq:'N', 禁止请领的,仍可以出库
							var ParamsObj = {StkGrpRowId:InitScg, StkGrpType:'M', Locdr:InitFrLoc, NotUseFlag:'N', QtyFlag:'1',
								ToLoc:InitToLoc, HV:HV, QtyFlagBat:'1'};
							IncItmBatWindow(Input, ParamsObj, ReturnInfoFunc);
						}
					});
				}else if(e.field == 'Qty'){
					$(e.target).bind('keyup', function(event){
						if(event.keyCode == 13){
							DetailGrid.commonAddRow();
						}
					});
				}else if(e.field == 'BarCode'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var BarCode = $(this).val();
							var InitScg = $('#InitScg').combotree('getValue');
							var InitFrLoc = $('#InitFrLoc').combobox('getValue');
							var InitToLoc = $('#InitToLoc').combobox('getValue');
							var HV = 'N';
							var ParamsObj = {StkGrpRowId:InitScg, StkGrpType:'M', Locdr:InitFrLoc, NotUseFlag:'N', QtyFlag:'1',
								ToLoc:InitToLoc, NoLocReq:'N', HV:HV, QtyFlagBat:'1', BarCode:BarCode};
							//共用,物资名称传''
							IncItmBatWindow('', ParamsObj, ReturnInfoFunc);
						}
					});
				}
			}
		},
		onAfterEdit: function(index, row, changes){
			if(changes.hasOwnProperty('Qty')){
				var Qty = Number(changes['Qty']);
				var InclbAvaQty = Number(row['InclbAvaQty']);
				var InclbDirtyQty = Number(row['InclbDirtyQty']);
				if(accSub(Qty, InclbDirtyQty) > InclbAvaQty){
					$UI.msg('alert', '数量不可大于可用库存!');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							Qty: '',
							RpAmt: 0,
							SpAmt: 0
						}
					});
					DetailGrid.checked = false;
					return;
				}
				var Rp = Number(row['Rp']), Sp = Number(row['Sp']);
				$(this).datagrid('updateRow', {
					index: index,
					row: {
						RpAmt: accMul(Qty, Rp),
						SpAmt: accMul(Qty, Sp)
					}
				});
			}
			DetailGrid.setFooterInfo();
		}
	});
	
	function ReturnInfoFunc(rows){
		rows = [].concat(rows);
		$.each(rows, function(index, row){
			var RowIndex = DetailGrid.editIndex;
			var ed = $('#DetailGrid').datagrid('getEditor', {index:RowIndex,field:'UomId'});
			AddComboData(ed.target, row.PurUomId, row.PurUomDesc);
			DetailGrid.updateRow({
				index: RowIndex,
				row: {
					InciId: row.InciDr,
					InciCode: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					ManfDesc: row.Manf,
					BatExp: row.BatExp,
					Qty: row.OperQty,
					UomId: row.PurUomId,
					UomDesc: row.PurUomDesc,
					Rp: row.Rp,
					Sp: row.Sp,
					BUomId: row.BUomId,
					ConFac: row.ConFac,
					RpAmt: accMul(row.OperQty, row.Rp),
					SpAmt: accMul(row.OperQty, row.Sp),
					InclbQty: row.InclbQty,
					InclbDirtyQty: row.DirtyQty,
					InclbAvaQty: row.AvaQty,
					Model:row.Model,
					SpecDesc:row.SpecDesc
				}
			});
			$('#DetailGrid').datagrid('refreshRow', RowIndex);
			//var ed = $('#DetailGrid').datagrid('getEditor', {index: RowIndex, field: 'Qty'});
			//$(ed.target).focus();
			if(index< rows.length){
				DetailGrid.commonAddRow();
				var ed = $('#DetailGrid').datagrid('getEditor', {index: RowIndex+1, field: 'InciDesc'});
			}
		});
	}
	
		//设置缺省值
	function SetDefaValues(){
		$('#InitFrLoc').combobox('setValue', gLocId);
	}
	
	var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
		'#CancelCompBT':false, '#AuditOutYesBT':false, '#AuditInYesBT':false};
	ChangeButtonEnable(BtnEnaleObj);
	
	function SelectDefa(){
		SetDefaValues();
		if(gInitId > 0){
			Select(gInitId);
			gInitId="";
		}else if(InitParamObj['AutoLoadRequest'] == 'Y'){
			var InitFrLoc = $('#InitFrLoc').combobox('getValue');
			if(!isEmpty(InitFrLoc)){
				SelReq(QueryTrans,"N");
			}
		}
	}
	window.onload = SelectDefa;
	Clear()
}
$(init);
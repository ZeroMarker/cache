
//˫ǩ�ֱ�־����
gHVSignFlag = typeof(gHVSignFlag)=='undefined'? '' : gHVSignFlag;

var init = function(){
	
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			var HvFlag="Y";
			FindWin(Select, gHVSignFlag, HvFlag);
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
			rows:99999
		});
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var MainObj = $UI.loopBlock('#Conditions');
			if(MainObj['InitComp'] == 'Y'){
				$UI.msg('alert', '�õ����Ѿ����,�����ظ�����!');
				return;
			}
			if(isEmpty(MainObj['InitFrLoc'])){
				$UI.msg('alert', '������Ҳ���Ϊ��!')
				return;
			}
			if(isEmpty(MainObj['InitToLoc'])){
				$UI.msg('alert', '���տ��Ҳ���Ϊ��!')
				return;
			}
			if(MainObj['InitFrLoc']==MainObj['InitToLoc']){
				$UI.msg('alert', '������Ҳ���������տ�����ͬ!')
				return;
			}
			MainObj['InitState'] = '10';
			var Main = JSON.stringify(MainObj);
			var Detail = DetailGrid.getChangesData('Inclb');
			/*var Detail = DetailGrid.getRowsData();*/
			if (Detail === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			//�ж�
			var ifChangeMain=$UI.isChangeBlock('#MainObj');
			if (!ifChangeMain && (isEmpty(Detail))){	//��������ϸ����
				$UI.msg("alert", "û����Ҫ�������Ϣ!");
				return;
			}
			var RowsData = DetailGrid.getRows();
			var count = 0;
			for (var i = 0; i < RowsData.length; i++) {
				var HVBarCode=RowsData[i].HVBarCode;
				var inclb=RowsData[i].Inclb;
				if (!isEmpty(HVBarCode)&&(!isEmpty(inclb))) {
					count++;
				}
			}
			if ((RowsData.length <= 0 || count <= 0)) {
				$UI.msg('alert', '��������ϸ!');
				return false;
			}
			if (((RowsData.length-1) >count)) {
				$UI.msg('alert', '����ϸ������,����������Ϣ����!');
				return false;
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
				$UI.msg('alert', '�õ��������,�����ظ�����!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			var AutoAuditFlag = gHVSignFlag == 'Y'? 'N' : '';	//˫ǩ�ֹ���,�������Զ����
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
//					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
//						'#CancelCompBT':true, '#AuditOutYesBT':true, '#AuditInYesBT':false};
//					ChangeButtonEnable(BtnEnaleObj);
					//��ɺ��Զ���ӡ �� ��ɺ��Զ�������ˣ�������˺��Զ���ӡ
					if((InitParamObj.AutoPrintAfterComp=='Y') || (InitParamObj.AutoAckOutAfterCompleted=='Y' && InitParamObj.AutoPrintAfterAckOut=='Y')){
						PrintInIsTrf(InitId, 'Y');
					}
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
	}
	// ���ǰ�ض��ж���ʾ
	function CheckDataBeforeComplete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var InitId = ParamsObj['RowId'];
		if(isEmpty(InitId)){
			$UI.msg('alert', '����Ҫ����ĵ���');
			return false;
		}
		var checkret=tkMakeServerCall("web.DHCSTMHUI.LocLimitAmt","CheckIfExcess",InitId); //������������
		var checqtykret=tkMakeServerCall("web.DHCSTMHUI.LocLimitAmt","CheckIfExcessQty",InitId);  ///��������������
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
			$UI.msg('alert', '���»�����ϸ����ѳ��������޶����!');
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
			$UI.msg('alert', '���»���ɫ�����ļ�¼�������������޶���������!');
			return false;
		}
		return true;
	}
	$UI.linkbutton('#CompleteBT', {
		onClick: function(){
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
				$UI.msg('alert', '�õ��ݲ������״̬,���ɲ���!');
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
				$UI.msg('alert', '�õ����Ѿ����,����ɾ��!');
				return;
			}
			$UI.confirm('����Ҫɾ������,�Ƿ����?', '', '', Delete);
		}
	});
	function Delete(){
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsDelete',
			Params: Params
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
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
		$UI.clear(DetailGrid);
		SetDefaValues();
		var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':false, '#CompleteBT':false,
					'#CancelCompBT': false, '#AuditOutYesBT':false, '#AuditInYesBT':false};
		ChangeButtonEnable(BtnEnaleObj);
		SetEditEnable();
		CheckLocationHref(gInitId);
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
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			if(InitParamObj['PrintNoComplete']=='N' && ParamsObj['InitComp'] != 'Y'){
				Msg.info('warning','�������ӡδ��ɵ�ת�Ƶ�!');
				return;
			}
			PrintInIsTrf(InitId);
		}
	});
	
	$UI.linkbutton('#PrintHVColBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			if(InitParamObj['PrintNoComplete']=='N' && ParamsObj['InitComp'] != 'Y'){
				Msg.info('warning','�������ӡδ��ɵ�ת�Ƶ�!');
				return;
			}
			PrintInIsTrfHVCol(InitId);
		}
	});
	
	$UI.linkbutton('#SelReqBT', {
		onClick: function(){
			SelReq(QueryTrans,getlistReq,"Y");  //��ֵ��־
		}
	});
	function getlistReq(MainObj,ReqId){
		    SetEditDisable();
			var MainParamObj=$UI.loopBlock('#Conditions');
			if (MainParamObj.ReqId==ReqId){
				$UI.msg('alert', '�����쵥�Ѵ���!');
				return;
			}
			if((!isEmpty(MainParamObj.ReqId)) && (MainParamObj.ReqId!=ReqId)){   //�µ����쵥�������
				Clear(); 
		}
			$UI.fillBlock('#Conditions',MainObj);
			getReqDetaill(ReqId);
		};
		//������ϸ����
		function getReqDetaill(ReqId){
			var ParamsObj = {ReqId: ReqId};
			var Params = JSON.stringify(ParamsObj);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfFromReq',
				Params: Params
	});
		};
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
				$UI.msg('alert', '��ѡ����˵�ת�Ƶ�!');
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
			$UI.msg('alert', 'ת�Ƶ���δ���!');
			return;
		}
		//����ֵ���ϱ�ǩ¼�����
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
				$UI.msg('success', '��˳ɹ�!');
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
				$UI.msg('alert', '��ѡ����յ�ת�Ƶ�');
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
		textField: 'Description'
	});
	$('#InitFrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var VirtualFlag = $HUI.checkbox('#VirtualFlag',{
		onCheckChange: function(e, value){
			if(value){
				var FrLoc = $('#InitFrLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','GetMainLoc',FrLoc);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#InitFrLoc'), VituralLoc, VituralLocDesc);
				$('#InitFrLoc').combobox('setValue', VituralLoc);
			}else{
				$('#InitFrLoc').combobox('setValue', gLocId);
			}
		}
	});
	
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
			{RowId: '10', Description: 'δ���'},
			{RowId: '11', Description: '�����'},
			{RowId: '20', Description: '������˲�ͨ��'},
			{RowId: '21', Description: '�������ͨ��'},
			{RowId: '30', Description: '�ܾ�����'},
			{RowId: '31', Description: '�ѽ���'}
		]
	});
	
	
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
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 180
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 80,
			hidden: true
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			saveCol: true,
			jump:false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			},
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: 'Inclb',
			field: 'Inclb',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 200
		}, {
			title: '����',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '���ο��',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '��������',
			field: 'Qty',
			saveCol: true,
			align: 'right',
			width: 80
		}, {
			title: '��λId',
			field: 'UomId',
			saveCol: true,
			width: 50,
			hidden: true
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 50
		}, {
			title: '����',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ�',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '�������',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '��������',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '���󷽿��',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: 'ռ������',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: 'Inrqi',
			field: 'Inrqi',
			width: 80,
			saveCol: true,
			hidden: true
		},{
			title: '������',
			field: 'SpecDesc',
			width: 80
		}
	]];
	
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			rows:99999
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
			if($('#InitComp').val() == 'Y'){
				$UI.msg('alert', '���������, ��������');
				return false;
			}
			if(isEmpty($HUI.combobox('#InitToLoc').getValue())){
				$UI.msg('alert', '���տ��Ҳ���Ϊ��!');
				return false;
			}
			var OperateType = $HUI.combobox('#OperateType').getValue();
			if(InitParamObj.OutTypeNotNull == 'Y' && isEmpty(OperateType)){
				$UI.msg('alert', '��ѡ���������!');
				return false;
			}
			if(isEmpty($HUI.combotree('#InitScg').getValue())){
				$UI.msg('alert', '���鲻��Ϊ��!');
				return false;
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
			var RowData = $(this).datagrid('getRows')[index];
			if(field == 'HVBarCode' && !isEmpty(RowData['RowId'])){
				return false;
			}
			return true;
		},
		onBeginEdit: function(index, row){
			//����������������������
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == 'HVBarCode'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var BarCode = $(this).val();
							if(isEmpty(BarCode)){
								DetailGrid.stopJump();
								return false;
							}
							var FindIndex = DetailGrid.find('HVBarCode', BarCode);
							if(FindIndex >= 0 && FindIndex != index){
								$UI.msg('alert', '���벻���ظ�¼��!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return false;
							}
							var BarCodeData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCItmTrack',
								MethodName: 'GetItmByBarcode',
								BarCode: BarCode
							},false);
							
							if(!isEmpty(BarCodeData.success) && BarCodeData.success != 0){
								$UI.msg('alert', BarCodeData.msg);
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return false;
							}
							var ScgStk = BarCodeData['ScgStk'];
							var ScgStkDesc = BarCodeData['ScgStkDesc'];
							var Inclb = BarCodeData['Inclb'];
							var IsAudit = BarCodeData['IsAudit'];
							var OperNo = BarCodeData['OperNo'];
							var Type = BarCodeData['Type'];
							var Status = BarCodeData['Status'];
							var RecallFlag = BarCodeData['RecallFlag'];
							var Inci = BarCodeData['Inci'];
							var dhcit = BarCodeData['dhcit'];
							var InitScg = $('#InitScg').combobox('getValue');
							
							var CheckMsg = '';
							if(!CheckScgRelation(InitScg, ScgStk)){
								CheckMsg = '����'+BarCode+'����'+ScgStkDesc+'����,�뵱ǰ����!';
							}else if(Inclb == ''){
								CheckMsg = '�ø�ֵ����û����Ӧ����¼,�����Ƶ�!';
							}else if(IsAudit != 'Y'){
								CheckMsg = '�ø�ֵ������δ��˵�'+OperNo+',���ʵ!';
							}else if(Type=='T'){
								CheckMsg = '�ø�ֵ�����Ѿ�����,�����Ƶ�!';
							}else if('alert', Status!='Enable'){
								CheckMsg = '�ø�ֵ���봦�ڲ�����״̬,�����Ƶ�!';
							}else if(RecallFlag=='Y'){
								CheckMsg = '�ø�ֵ���봦������״̬,�����Ƶ�!';
							}
							if(CheckMsg != ''){
								$UI.msg('alert', CheckMsg);
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return false;
							}
							var ProLocId = $('#InitFrLoc').combobox('getValue');
							var ReqLocId = $('#InitToLoc').combobox('getValue');
							var ParamsObj = {InciDr: Inci, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: 1, Inclb: Inclb};
							var Params = JSON.stringify(ParamsObj);
							var InclbData = $.cm({
								ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
								MethodName: 'GetDrugBatInfo',
								page: 1,
								rows: 1,
								Params: Params
							},false);
							if(!InclbData || InclbData.rows.length < 1){
								$UI.msg('alert', BarCode + 'û����Ӧ����¼,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return false;
							}
							var InclbInfo = $.extend(InclbData.rows[0], {InciDr:Inci, dhcit: dhcit, HVBarCode: BarCode});
							ReturnInfoFunc(index, InclbInfo);
						}
					});
				}
			}
		}
	});
	
	function ReturnInfoFunc(RowIndex, row){
		if(row.AvaQty < 1){
			$UI.msg('alert', '���ÿ�治��');
			return;
		}
		DetailGrid.updateRow({
			index: RowIndex,
			row: {
				HVBarCode: row.HVBarCode,
				dhcit: row.dhcit,
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Inclb: row.Inclb,
				BatExp: row.BatExp,
				Qty: row.OperQty,
				UomId: row.PurUomId,
				UomDesc: row.PurUomDesc,
				Rp: row.Rp,
				Sp: row.Sp,
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				InclbQty: row.InclbQty,
				InclbDirtyQty: row.DirtyQty,
				Qty: 1,
				ManfDesc: row.Manf,
				SpecDesc:row.SpecDesc
			}
		});
		$('#DetailGrid').datagrid('refreshRow', RowIndex);
		var tmprows = $("#DetailGrid").datagrid("getRows");
		if (tmprows.length!=(RowIndex +1)){
			var tmprow = tmprows[RowIndex +1];
			var HVBarCode= tmprow.HVBarCode;
			var inclb=tmprow.Inclb;
			if (isEmpty(HVBarCode)&&!isEmpty(inclb)){
				var index=RowIndex +1;
				$('#DetailGrid').datagrid('beginEdit', index);
				var ed = DetailGrid.datagrid('getEditor', {index: index,field: 'HVBarCode'});
				$(ed.target).focus();
			}
		}else{
		DetailGrid.commonAddRow();
		}
	}
	
	//����ȱʡֵ
	function SetDefaValues(){
		$('#InitFrLoc').combobox('setValue', gLocId);
		$('#InitScg').combotree('options')['setDefaultFun']();
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
				SelReq(QueryTrans,getlistReq,"Y");
			}
		}
	}
	window.onload = SelectDefa;
}
$(init);
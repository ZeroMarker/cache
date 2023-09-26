//����:		�����̵�(ʵ�̲���������)
//��д�ߣ�		wangjiabin
//��д����:	2016.10.14

	var gIncId='';
	var Url = DictUrl + 'dhcsublocstktkaction.csp';
	var gGroupId = session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gSubStkTkId = '';

	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '�ⷿ',
		id : 'PhaLoc',
		anchor : '90%',
		width : 140,
		emptyText : '�ⷿ...',
		groupId:gGroupId
	});

	var StkTkLoc = new Ext.ux.LocComboBox({
		fieldLabel : '�̵����',
		id : 'StkTkLoc',
		anchor : '90%',
		emptyText : '�̵����...',
		defaultLoc : {},
		listeners : {
			'select' : function(cb){
				var StkTkLoc = cb.getValue();
				var PhaLoc=Ext.getCmp('PhaLoc').getValue();
				Ext.getCmp('StkGrpType').setFilterByLoc(PhaLoc,StkTkLoc);
			}
		}
	});

	var SubSTNo = new Ext.form.TextField({
		id : 'SubSTNo',
		fieldLabel : '����',
		anchor : '90%',
		disabled : true
	});

	var CreateUser = new Ext.form.TextField({
		fieldLabel : '�Ƶ���',
		id : 'CreateUser',
		anchor : '90%',
		disabled : true
	});

	var CreateDate = new Ext.ux.DateField({
		fieldLabel : '�Ƶ�����',
		id : 'CreateDate',
		anchor : '90%',
		
		value : new Date(),
		disabled : true
	});

	var CreateTime = new Ext.form.TextField({
		fieldLabel : '�Ƶ�ʱ��',
		id : 'CreateTime',
		anchor : '90%',
		disabled : true
	});

	// ��������
	var StkGrpType = new Ext.ux.StkGrpComboBox({
		id : 'StkGrpType',
		StkType : App_StkTypeCode,
		LocId : gLocId,
		UserId : gUserId,
		anchor : '90%',
		childCombo : 'DHCStkCatGroup'
	});

	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});

	var Completed = new Ext.form.Checkbox({
		id : 'Completed',
		hideLabel : true,
		boxLabel : '���',
		disabled : true
	});

	var CountCompleted = new Ext.form.Checkbox({
		id : 'CountCompleted',
		hideLabel : true,
		boxLabel : 'ʵ�����',
		disabled : true
	});

	var AdjCompleted = new Ext.form.Checkbox({
		id : 'AdjCompleted',
		hideLabel : true,
		boxLabel : '�������',
		disabled : true
	});

    /*�Ƿ����*/
    var IfActiveData=[['ȫ��','1'],['����','2'],['������','3']];
	
	var IfActiveStore = new Ext.data.SimpleStore({
		fields: ['IfActivedesc', 'IfActiveid'],
		data : IfActiveData
	});

	var IfActiveCombo = new Ext.form.ComboBox({
		store: IfActiveStore,
		displayField:'IfActivedesc',
		mode: 'local', 
		anchor : '90%',
		emptyText:'',
		id:'IfActiveCombo',
		fieldLabel : '�Ƿ����',
		triggerAction:'all', //ȡ���Զ�����
		valueField : 'IfActiveid'
	});
	Ext.getCmp("IfActiveCombo").setValue("1");
		
    /*�Ƿ��շ�*/
    var IfChargeData=[['ȫ��','1'],['�շ�','2'],['���շ�','3']];
	
	var IfChargeStore = new Ext.data.SimpleStore({
		fields: ['IfChargedesc', 'IfChargeid'],
		data : IfChargeData
	});

	var IfChargeCombo = new Ext.form.ComboBox({
		store: IfChargeStore,
		displayField:'IfChargedesc',
		mode: 'local', 
		anchor : '90%',
		emptyText:'',
		id:'IfChargeCombo',
		fieldLabel : '�Ƿ��շ�',
		triggerAction:'all', //ȡ���Զ�����
		valueField : 'IfChargeid'
	});
	Ext.getCmp("IfChargeCombo").setValue("1");
    
	var CreateStkTkBT = new Ext.ux.Button({
		id : 'CreateStkTkBT',
		text : '�����̵㵥',
		iconCls : 'page_save',
		handler : function() {
			var StkTkLoc = Ext.getCmp('StkTkLoc').getValue();
			if(Ext.isEmpty(StkTkLoc)){
				Msg.info('warning', '�̵���Ҳ���Ϊ��!');
				return false;
			}
			var PhaLoc = Ext.getCmp('PhaLoc').getValue();
			if(PhaLoc == StkTkLoc){
				Msg.info('warning', '�ⷿ���̵���Ҳ�����ͬ!');
				return false;
			}
			var StkTkLocDesc = Ext.getCmp('StkTkLoc').getRawValue();
			Ext.Msg.show({
				title : '��ʾ',
				msg : '�Ƿ�Ϊ ' + StkTkLocDesc + ' �����̵㵥?',
				buttons : Ext.Msg.YESNO,
				fn : function(b, t, o){
					if (b == 'yes'){
						CreateStkTk();
					}
				},
				icon: Ext.MessageBox.QUESTION
			});
		}
	});

	/**
	 * ���ɱ����̵㵥
	 */
	function CreateStkTk(){
		var StkTkLoc = Ext.getCmp('StkTkLoc').getValue();
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		var Scg = Ext.getCmp('StkGrpType').getValue();
		var Incsc = Ext.getCmp('DHCStkCatGroup').getValue();
		var IfActive = Ext.getCmp('IfActiveCombo').getValue(); ///�Ƿ����
		var IfCharge = Ext.getCmp('IfChargeCombo').getValue(); ///�Ƿ��շ�
		var StrParam = StkTkLoc + '^' + PhaLoc + '^' + gUserId + '^' + Scg + '^' + Incsc + '^' + IfActive + '^' +IfCharge ;
		var result = tkMakeServerCall('web.DHCSTM.DHCSubLocStkTk','Create',StrParam);
		if(result > 0){
			Msg.info('success', '���ɳɹ�!');
			Select(result);
		}else if(result == -11){
			Msg.info('error', '��������Ϣʧ��!');
		}else if(result == -12){
			Msg.info('error', '������ϸ��Ϣʧ��!');
		}else if(result == -13){
			Msg.info('error', 'û�п����ɵ���ϸ!');
		}else{
			Msg.info('error', '����ʧ��:' + result);
		}
	}
	function Select(RowId){
		gSubStkTkId = RowId;
		var MainInfo = tkMakeServerCall('web.DHCSTM.DHCSubLocStkTk','Select',RowId);
		MainInfo = Ext.util.JSON.decode(MainInfo);
		HisListTab.getForm().setValues(MainInfo);
		SetEditDisabled(true);
		ChangeButtonStatus();
		QueryDetail();

	}
	function SetEditDisabled(bool){
		bool = !!bool;
		Ext.getCmp('PhaLoc').setDisabled(bool);
		Ext.getCmp('StkTkLoc').setDisabled(bool);
		Ext.getCmp('StkGrpType').setDisabled(bool);
		Ext.getCmp('DHCStkCatGroup').setDisabled(bool);
		Ext.getCmp('IfActiveCombo').setDisabled(bool);
		Ext.getCmp('IfChargeCombo').setDisabled(bool);
	}
	///����������˵��
	var AddQtyDescription=new Ext.Toolbar.Button({
		id:'AddQtyDescription',
		text: '������˵��',
		tooltip: '<font color=red>����׼������ʵ������ʱ�������׼����ȥʵ���������ڿⷿ���������������������ڿⷿ�������������򲹻��������ڱ�׼����ȥʵ������</font>',
		anchor: '90%',
		cls:'ext-button-style'
	});
	var Filter=new Ext.Toolbar.Button({
		id:'filter',
		text:'����',
		iconCls : 'page_find',
		anchor:'90%',
		handler:function(){
			    gIncId = "";
				QueryDetail();
			}
	});
	//�����������Ʋ���
	var IncDesc=new Ext.form.TextField({
		id:'IncDesc',
		name:'IncDesc',
		emptyText:'��������',
		width:150,
		listeners:{
			'specialkey':function(field,e){
				if(e.getKey()==Ext.EventObject.ENTER){
					var stkgrp = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderWindow(field.getValue(), stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
				}
			}
		}
	});
		/**
	 * ���ط���
	 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gIncId = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("IncDesc").setValue(inciDesc);
		QueryDetail();
	}
	//�������ƹ���
	function QueryDetail() {
		var incidesc = Ext.getCmp('IncDesc').getValue();
		var StkGrpId = Ext.getCmp('StkGrpType').getValue();
		var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
		var CountStatus = '0';
		if(Ext.getCmp('onlySurplus').getValue()){
			CountStatus = '1';
		}else if(Ext.getCmp('onlyLoss').getValue()){
			CountStatus = '2';
		}else if(Ext.getCmp('onlyCount').getValue()){
			CountStatus = '3';
		}
		gStrDetailParams = gIncId + '^' + StkGrpId + '^' + StkCatId+ '^' + incidesc;
		DetailStore.removeAll();
		DetailStore.setBaseParam('sort', 'code');
		DetailStore.setBaseParam('dir', 'ASC');
		DetailStore.setBaseParam('Parref', gSubStkTkId);
		DetailStore.setBaseParam('CountStatus', CountStatus);
		DetailStore.setBaseParam('Params', gStrDetailParams);
		DetailStore.load({
			params : {start : 0, limit : DetailPagingToolbar.pageSize},
			callback : function(r,options,success){
				if(!success){
					Msg.info('error', '��ѯ����!')
				}
			}
		});
	}
    //����δ��������������
	var ReqLocSetDefaultBT2 = new Ext.Toolbar.Button({
		text : '����δ��������������',
		tooltip : '�������δ��������������',
		iconCls : 'page_save',
		width : 70,
		height : 30,
		handler : function() {
			var ss=Ext.Msg.show({
			   title:'��ʾ',
			   msg: '����δ��ʵ�����������������޸Ĵ��̵㵥����δ¼��ļ�¼���Ƿ������',
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
				   if (b=='yes'){
					   ReqLocSetDefaultQty(2);
				   }
			   },
			   icon: Ext.MessageBox.QUESTION
			});
		}
	});
	//����δ��������0
	var ReqLocSetDefaultBT = new Ext.Toolbar.Button({
		text : '����δ��������0',
		tooltip : '�������δ��������0',
		iconCls : 'page_save',
		width : 70,
		height : 30,
		handler : function() {
			var ss=Ext.Msg.show({
			   title:'��ʾ',
			   msg: '����δ��ʵ��������0���޸Ĵ��̵㵥����δ¼��ļ�¼���Ƿ������',
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
				   if (b=='yes'){
					   ReqLocSetDefaultQty(1);
				   }
			   },
			   icon: Ext.MessageBox.QUESTION
			});
		}
	});
	//����δ��ʵ����
	function ReqLocSetDefaultQty(flag){
		if(gSubStkTkId==''){
			Msg.info('Warning','û��ѡ�е��̵㵥��');
			return;
		}
		var Completed = Ext.getCmp('Completed').getValue();
		var CountCompleted = Ext.getCmp('CountCompleted').getValue();
		if(!Completed || CountCompleted){
			Msg.info('warning', '����δ������ɻ���ʵ��ȷ��,������ͳһ����ʵ����!');
			return;
	}
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:Url,
			params:{actiontype:'ReqLocSetDefaultQty',Inst:gSubStkTkId,Flag:flag},
			method:'post',
			waitMsg:'������...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info('success','�ɹ�!');
					Select(gSubStkTkId);
				}else{
					var ret=jsonData.info;					
					Msg.info('error','����δ���¼ʵ����ʧ��:'+ret);
				}
			}		
		});
	}
	var SaveBT = new Ext.ux.Button({
		id : 'SaveBT',
		text : '�����̵�����',
		iconCls : 'page_save',
		handler : function() {
			Save();
		}
	});
	function Save(){
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		}
		var rowCount = DetailStore.getCount();
		var ListDetail = '';
		for(var i = 0; i < rowCount; i++){
			var rowData = DetailStore.getAt(i);
			//�������޸Ĺ�������
			if(rowData.dirty || rowData.data.newRecord){
				var RowId = rowData.get('RowId');
				var CountQty = rowData.get('CountQty');
				if(CountQty == ""){
					CountQty=0;
				}
				var Qty = rowData.get('Qty');
				var Remarks = rowData.get('Remarks');
				var Detail = RowId + '^' + CountQty + '^' + Qty + '^' + Remarks;
				if(ListDetail == ''){
					ListDetail = Detail;
				}else{
					ListDetail = ListDetail + xRowDelim() + Detail;
				}
			}
		}
		if(ListDetail == ''){
			Msg.info('warning', 'û����Ҫ���������!');
			return;
		}
		var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
		Ext.Ajax.request({
			url : Url,
			params : {actiontype : 'SaveStkTkItm', ListDetail : ListDetail},
			method : 'post',
			waitMsg : '������...',
			success : function(response,opt){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if(jsonData.success == 'true'){
					Msg.info('success', '����ɹ�!');
					Select(gSubStkTkId);
				}else{
					var ret = jsonData.info;
					if(ret == '-1'){
						Msg.info('warning','û����Ҫ���������!');
					}else if(ret == '-2'){
						Msg.info('error','����ʧ��!');
					}else{
						Msg.info('error','�������ݱ���ʧ��:'+ret);
					}
				}
			}
		});
	}

	var AdjAndInitBT = new Ext.ux.Button({
		text : '�̵����&����',
		id : 'AdjAndInitBT',
		iconCls : 'page_gear',
		handler : function() {
			if(Ext.isEmpty(gSubStkTkId)){
				Msg.info('warning', 'û����Ҫ����ĵ���!');
				return false;
			}
			var mr = DetailGrid.getStore().getModifiedRecords();
			if(!Ext.isEmpty(mr)){
				Ext.Msg.show({
					title : '��ʾ',
					msg : '������¼����޸�, �㵱ǰ�Ĳ�������ʧ��Щ���, �Ƿ����?',
					buttons : Ext.Msg.YESNO,
					fn : function(b, t, o){
						if (b == 'yes'){
							AdjAndInit();
						}else{
							Msg.info('warning', '���ȵ������!');
						}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}else{
				Ext.Msg.show({
					title : '��ʾ',
					msg : '��Ҫ�����̵������������ҵ��, �Ƿ����?',
					buttons : Ext.Msg.YESNO,
					fn : function(b, t, o){
						if (b == 'yes'){
							AdjAndInit();
						}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}
		}
	});
	function AdjAndInit(){
		var result = tkMakeServerCall('web.DHCSTM.DHCSubLocStkTk', 'AdjAndInit', gSubStkTkId, gUserId);
		var resultArr = result.split('^');
		if(resultArr.length >= 2){
			Msg.info('success', '����������ɹ�!');
			var Init = resultArr[1];	//���ⵥrowid
			if(parseInt(Init) > 0){
				window.location.href = DictUrl + 'dhcinistrf.csp?Rowid=' + Init + '&QueryFlag=1';
			}
                 HisListTab.getForm().setValues({
			AdjCompleted: true
		});
		ChangeButtonStatus();
		}else if(result == -11){
			Msg.info('error', '�̵����ʧ��!');
		}else if(result == -21){
			Msg.info('error', '�������ⵥʧ��!');
		}else{
			Msg.info('error', '��������:' + result);
		}
	}

	var QueryBT = new Ext.Toolbar.Button({
		text : '��ѯ�̵㵥',
		tooltip : '�����ѯ�̵㵥',
		iconCls : 'page_find',
		width : 70,
		height : 30,
		handler : function() {
			SubLocStkTkFind(Select);
		}
	});

	var CompleteBT = new Ext.ux.Button({
		text : '�������',
		tooltip : '���ȷ�����',
		iconCls : 'page_refresh',
		handler : function() {
			Complete();
		}
	});
	function Complete(){
		if(Ext.isEmpty(gSubStkTkId)){
			Msg.info('warning', 'û����Ҫ��ɵĵ���!');
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTM.DHCSubLocStkTk', 'Complete', gSubStkTkId);
		if(result === '0'){
			Msg.info('success', '��ɳɹ�!');
			HisListTab.getForm().setValues({Completed : true});
			ChangeButtonStatus();
		}else{
			Msg.info('error', '���ʧ��:' + result);
		}
	}

	var CancelCompleteBT = new Ext.ux.Button({
		text : 'ȡ���������',
		tooltip : '���ȡ�����',
		iconCls : 'page_refresh',
		handler : function() {
			CancelComplete();
		}
	});
	function CancelComplete(){
		if(Ext.isEmpty(gSubStkTkId)){
			Msg.info('warning', 'û����Ҫȡ����ɵĵ���!');
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTM.DHCSubLocStkTk', 'CancelComplete', gSubStkTkId);
		if(result === '0'){
			Msg.info('success', 'ȡ����ɳɹ�!');
			HisListTab.getForm().setValues({Completed : false});
			ChangeButtonStatus();
		}else{
			Msg.info('error', '���ʧ��:' + result);
		}
	}

	var CountCompleteBT = new Ext.ux.Button({
		text : 'ʵ�����',
		tooltip : '���ȷ��ʵ��¼�����',
		iconCls : 'page_refresh',
		handler : function() {
			CountComplete();
		}
	});
	function CountComplete(){
		if(Ext.isEmpty(gSubStkTkId)){
			Msg.info('warning', 'û����Ҫ��ɵĵ���!');
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTM.DHCSubLocStkTk', 'CountComplete', gSubStkTkId);
		if(result === '0'){
			Msg.info('success', '��ɳɹ�!');
			HisListTab.getForm().setValues({CountCompleted : true});
			ChangeButtonStatus();
		}else{
			Msg.info('error', '���ʧ��:' + result);
		}
	}
	var CountCancelCompleteBT = new Ext.ux.Button({
		text : 'ʵ��ȡ�����',
		tooltip : '���ȡ��ʵ��¼�����',
		iconCls : 'page_refresh',
		handler : function() {
			CountCancelComplete();
		}
	});

	function CountCancelComplete(){
		if(Ext.isEmpty(gSubStkTkId)){
			Msg.info('warning', 'û����Ҫȡ����ɵĵ���!');
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTM.DHCSubLocStkTk', 'CountCancelComplete', gSubStkTkId);
		if(result === '0'){
			Msg.info('success', 'ȡ����ɳɹ�!');
			HisListTab.getForm().setValues({CountCompleted : false});
			ChangeButtonStatus();
		}else{
			Msg.info('error', '���ʧ��:' + result);
		}
	}
	var RefreshBT = new Ext.Toolbar.Button({
		text : '���',
		tooltip : '������',
		iconCls : 'page_clearscreen',
		width : 70,
		height : 30,
		handler : function() {
			ClearData();
		}
	});

	function ClearData() {
		gSubStkTkId = '';
		gIncId='';
		Ext.getCmp("IncDesc").setValue("");
		clearPanel(HisListTab);
		SetEditDisabled(false);
		HisListTab.getForm().setValues({CreateDate : new Date()});
		DetailStore.removeAll();
		DetailGrid.getView().refresh();
		ChangeButtonStatus();
		Ext.getCmp("IfActiveCombo").setValue("1");
		Ext.getCmp("IfChargeCombo").setValue("1");
	}
	var DeleteBT = new Ext.ux.Button({
		text : 'ɾ��',
		tooltip : '���ɾ������',
		iconCls : 'page_delete',
		width : 70,
		height : 30,
		handler : function() {
			if(Ext.isEmpty(gSubStkTkId)){
				Msg.info('warning', 'û����Ҫɾ���ĵ���!');
				return fasle;
			}else{
				Ext.Msg.show({
					title : '��ʾ',
					msg : '�Ƿ�ɾ�����̵㵥?',
					buttons : Ext.Msg.YESNO,
					fn : function(b, t, o){
						if (b == 'yes'){
							DeleteData(gSubStkTkId);
						}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}
		}
	});
	function DeleteData(RowId){
		var result = tkMakeServerCall('web.DHCSTM.DHCSubLocStkTk', 'Delete', RowId);
		if(result === '0'){
			Msg.info('success', 'ɾ���ɹ�');
			ClearData();
		}else{
			Msg.info('error', 'ɾ��ʧ��:' + result);
		}
	}
	function ChangeButtonStatus(){
		var AdjCompleted = Ext.getCmp('AdjCompleted').getValue();
		var CountCompleted = Ext.getCmp('CountCompleted').getValue();
		var Completed = Ext.getCmp('Completed').getValue();
		if(AdjCompleted){
			ChangeButtonEnable('0^0^0^0^0^0^0^0');
		}else if(CountCompleted){
			ChangeButtonEnable('0^0^0^0^0^1^1^0');
		}else if(Completed){
			ChangeButtonEnable('0^0^1^1^1^0^0^0');
		}else if(!Ext.isEmpty(gSubStkTkId)){
			ChangeButtonEnable('0^1^0^0^0^0^0^1');
		}else{
			ChangeButtonEnable('1^0^0^0^0^0^0^0');
		}
	}
	function ChangeButtonEnable(str) {
		var list = str.split('^');
		for (var i = 0; i < list.length; i++) {
			if (list[i] == "1") {
				list[i] = false;
			} else {
				list[i] = true;
			}
		}
		//����^���^ȡ�����^����^ʵ�����^ȡ��ʵ�����^����&����^ɾ��
		CreateStkTkBT.setDisabled(list[0]);
		CompleteBT.setDisabled(list[1]);
		CancelCompleteBT.setDisabled(list[2]);
		SaveBT.setDisabled(list[3]);
		CountCompleteBT.setDisabled(list[4]);
		CountCancelCompleteBT.setDisabled(list[5]);
		AdjAndInitBT.setDisabled(list[6]);
		DeleteBT.setDisabled(list[7]);
	}
	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		region : 'north',
		autoHeight : true,
		title : '����������̵�',
		labelAlign : 'right',
		frame : true,
		trackResetOnLoad : true,
		bodyStyle : 'padding:5px 0px 0px 0px;',
		tbar : [CreateStkTkBT, '-', QueryBT, '-', CompleteBT, '-', CancelCompleteBT, '-', SaveBT,
			'-', CountCompleteBT, '-', CountCancelCompleteBT, '-', AdjAndInitBT, '-', RefreshBT, '-', DeleteBT],
		items : [{
				style : 'padding:5px 0px 0px 0px',
				layout : 'column',
				xtype : 'fieldset',
				title : '�������̵�ѡ��',
				defaults : {border : false},
				items : [{
						columnWidth : .2,
						xtype : 'fieldset',
						items : [PhaLoc, StkTkLoc,IfActiveCombo]
					}, {
						columnWidth : .2,
						xtype : 'fieldset',
						items : [SubSTNo, CreateUser,IfChargeCombo]
					}, {
						columnWidth : .2,
						xtype : 'fieldset',
						items : [CreateDate, CreateTime]
					}, {
						columnWidth : .2,
						xtype : 'fieldset',
						items : [StkGrpType, DHCStkCatGroup]
					}, {
						columnWidth : .1,
						xtype : 'fieldset',
						items : [Completed, CountCompleted]
					}, {
						columnWidth : .1,
						xtype : 'fieldset',
						items : [AdjCompleted]
					}
				]
			}]
	});
	var DetailCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header : 'RowId',
			dataIndex : 'RowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : 'Incil',
			dataIndex : 'Incil',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : '���ʴ���',
			dataIndex : 'InciCode',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : '��������',
			dataIndex : 'InciDesc',
			width : 200,
			align : 'left',
			sortable : true
		},{
			header : '���',
			dataIndex : 'Spec',
			width : 80,
			align : 'left'
		},{
			header : '��������',
			dataIndex : 'FreezeQty',
			width : 80,
			align : 'right',
			sortable : true
		},{
			header : '��λ',
			dataIndex : 'PUomDesc',
			width : 100,
			align : 'left',
			sortable : true
		},{
			header : '���۽��',
			dataIndex : 'RpAmt',
			xtype : 'numbercolumn',
			align : 'right',
			sortable : true
		},{
			header : '�ۼ۽��',
			dataIndex : 'SpAmt',
			xtype : 'numbercolumn',
			align : 'right',
			sortable : true
		},{
			header  :  'ʵ������',
			dataIndex : 'CountQty',
			width : 100,
			align : 'right',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				allowNegative : false
			})
		},{
			header  :  '��׼���',
			dataIndex : 'RepQty',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header  :  '������',
			dataIndex : 'Qty',
			width : 100,
			align : 'right',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				allowNegative : false
			})
		},{
			header  :  '�ⷿ���ÿ��',
			dataIndex : 'PhaLocAvaQty',
			width : 100,
			align : 'right'
		},{
			header : '��ע',
			dataIndex : 'Remarks',
			width : 180,
			align : 'left',
			sortable : true,
			editable : true,
			editor : new Ext.form.TextField({
				maxLength : 40
			})
		}
	]);
	var DetailStore = new Ext.data.JsonStore({
		url : Url + '?actiontype=QueryDetail',
		root : 'rows',
		pruneModifiedRecords:true,
		totalProperty : 'results',
		fields : ['RowId','InciCode','InciDesc','Spec','RepLev','RepQty','Qty','PhaLocAvaQty',
				'Incil','FreezeQty','PUomDesc','CountQty','RpAmt','SpAmt','Remarks'],
		remoteSort : false
	});

	var DetailPagingToolbar = new Ext.PagingToolbar({
		store : DetailStore,
		pageSize : PageSize,
		displayInfo : true
	});

	var onlySurplus = {xtype:'radio',boxLabel:'����ӯ',name:'LossStatus',id:'onlySurplus',inputValue:1,
		listeners : {
			check : function(radio, checked){
				if(checked && !Ext.isEmpty(gSubStkTkId)){
					DetailStore.setBaseParam('CountStatus', this.inputValue);
					DetailStore.load({params : {start : 0, limit : DetailPagingToolbar.pageSize}});
				}
			}
		}
	};
	var onlyLoss = {xtype:'radio',boxLabel:'���̿�',name:'LossStatus',id:'onlyLoss',inputValue:2,
		listeners :��{
			check : function(radio, checked){
				if(checked && !Ext.isEmpty(gSubStkTkId)){
					DetailStore.setBaseParam('CountStatus', this.inputValue);
					DetailStore.load({params : {start : 0, limit : DetailPagingToolbar.pageSize}});
				}
			}
		}
	};
	var onlyCount = {xtype:'radio',boxLabel:'��ʵ������',name:'LossStatus',id:'onlyCount',inputValue:3,
		listeners :��{
			check : function(radio, checked){
				if(checked && !Ext.isEmpty(gSubStkTkId)){
					DetailStore.setBaseParam('CountStatus', this.inputValue);
					DetailStore.load({params : {start : 0, limit : DetailPagingToolbar.pageSize}});
				}
			}
		}
	};
	var allStatus = {xtype:'radio',boxLabel:'ȫ��',name:'LossStatus',inputValue:0,id:'allStatus',checked:true,
		listeners :��{
			check : function(radio, checked){
				if(checked && !Ext.isEmpty(gSubStkTkId)){
					DetailStore.setBaseParam('CountStatus', this.inputValue);
					DetailStore.load({params : {start : 0, limit : DetailPagingToolbar.pageSize}});
				}
			}
		}
	};
	var DetailGrid = new Ext.ux.EditorGridPanel({
		id : 'DetailGrid',
		region : 'center',
		title : '��ϸ',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.ux.CellSelectionModel(),
		loadMask : true,
		bbar : DetailPagingToolbar,
		tbar : [onlySurplus,onlyLoss,onlyCount,allStatus,'-',ReqLocSetDefaultBT,'-',ReqLocSetDefaultBT2,'-',IncDesc,'-',Filter,AddQtyDescription],
			//'->','<span style="font-size:10px;color:blue;">������������׼������ʵ������ʱ�������׼����ȥʵ���������ڿⷿ���������������������ڿⷿ�������������򲹻��������ڱ�׼����ȥʵ��������</span>'],
		listeners : {
			afteredit : function(e){
				if(e.field == 'CountQty'){
					// min(max(�������׼���-ʵ������, 0), �ⷿ���ÿ��)
					var Qty = Math.max(accSub(e.record.get('RepQty'), e.value), 0);
					Qty = Math.max(Math.min(Qty, e.record.get('PhaLocAvaQty')),0)
					e.record.set('Qty', Qty);
				}else if(e.field == 'Qty'){
					if(e.value > e.record.get('PhaLocAvaQty')){
						Msg.info('error', '���������ܴ��ڿⷿ���ÿ��!');
						e.record.set('Qty', e.originalValue);
					}
				}
			},
			beforeedit : function(e){
				var Completed = Ext.getCmp('Completed').getValue();
				var CountCompleted = Ext.getCmp('CountCompleted').getValue();
				var AdjCompleted = Ext.getCmp('AdjCompleted').getValue();
				if(AdjCompleted){
					return false;
				}else if(e.field == 'CountQty'){
					//δ�Ƶ����,����ʵ�����, �����޸�ʵ����
					if(!Completed || CountCompleted){
						e.cancel = true;
						Msg.info('warning', '����δ������ɻ���ʵ��ȷ��, ���ɱ༭!');
					}
				}
			}
		}
	});
	Ext.onReady(function() {
		Ext.QuickTips.init();

		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, DetailGrid],
			renderTo : 'mainPanel'
		});

		ChangeButtonStatus();
		
	});
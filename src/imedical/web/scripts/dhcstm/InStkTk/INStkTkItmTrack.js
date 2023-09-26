//����:		ʵ�̣�¼�뷽ʽ��(��ֵɨ���̵�)
//��д�ߣ�		wangjiabin
//��д����:	2015-07-14

	var url = DictUrl+'instktkaction.csp';
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	
	var LocManaGrp = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'LocManaGrp',
		anchor : '90%',
		store : LocManGrpStore,
		valueField : 'RowId',
		displayField : 'Description',
		valueParams : {locId : gLocId}
	});

	var PhaWindow = new Ext.ux.ComboBox({
		fieldLabel : 'ʵ�̴���',
		id : 'PhaWindow',
		anchor : '90%',
		store : INStkTkWindowStore,
		valueField : 'RowId',
		displayField : 'Description',
		emptyText : 'ʵ�̴���...',
		hidden : true,		//��ֵɨ���̵�,��ʹ��ʵ�̴���
		disabled:true,
		valueParams:{LocId:gLocId}
	}); 
	INStkTkWindowStore.load({
		params:{start:0,limit:99,'LocId':gLocId},
		callback:function(){
			Ext.getCmp('PhaWindow').setValue(gInstwWin);
		}
	});
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId,
		anchor:'90%',
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

	var StkBin = new Ext.ux.ComboBox({
		fieldLabel : '��λ',
		id : 'StkBin',
		anchor : '90%',
		width : 140,
		store : LocStkBinStore,
		valueField : 'RowId',
		displayField : 'Description',
		valueParams : {LocId : gLocId},
		filterName : 'Desc'
	});
	
	var InstNo = new Ext.form.TextField({
		id : 'InstNo',
		fieldLabel:'�̵㵥��',
		anchor:'90%',
		width:140,
		disabled:true
	});
	
	var HVBarCode = new Ext.form.TextField({
		fieldLabel : '��ֵ����',
		id : 'HVBarCode',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e){
				if(e.getKey() == Ext.EventObject.ENTER){
					var HVBarCode = field.getValue();
					HVINStkTk(HVBarCode, gRowid);
					field.setValue('');
				}
			}
		}
	});

	//����ʵ��
	function HVINStkTk(HVBarCode, gRowid){
		if(Ext.isEmpty(HVBarCode)){
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTM.INStkTkItmTrack', 'INStkTkItmTrack', HVBarCode, gRowid, gUserId);
		var resultArr = result.split('^');
		var ret = resultArr[0];
		if(ret === '0'){
			Msg.info('success', '¼��ɹ�!');
			var insti = resultArr[1];
			var countQty = resultArr[2];
			var FindIndex = InstDetailStore.findExact('rowid', insti, 0);
			if(FindIndex >= 0){
				InstDetailStore.getAt(FindIndex).set('countQty', countQty);
				var count=InstDetailStore.getAt(FindIndex).get('countQty')
				var freez=InstDetailStore.getAt(FindIndex).get('freQty')
				if(freez==count){
					InstDetailGrid.getView().getRow(FindIndex).style.backgroundColor='#5F9EA0';
				}
				var CodeFindIndex = InstitStore.findExact('HVBarCode', HVBarCode, 0);
				if(CodeFindIndex >= 0){
					InstitStore.getAt(CodeFindIndex).set('institFlag', 'Y');
				}
			}
		}else{
			if(ret == -10){
				Msg.info('error', '�����벻����!');
			}else if(ret == -11){
				Msg.info('error', '�����벻�ڵ�ǰ�̵㵥��!');
			}else if(ret == -12){
				Msg.info('error', '�������ѽ���ɨ���̵�!');
				
			}else if(ret == -19){
				Msg.info('error', '�Ѿ��̵���ɲ���������̵�!');
			}else{
				Msg.info('error', '����:' + ret);
			}
			return false;
		}
	}

	var SearchBT = new Ext.Toolbar.Button({
		text : '��ѯ',
		tooltip : '�����ѯ',
		iconCls : 'page_find',
		width : 70,
		height : 30,
		handler : function() {
			QueryDetail();
		}
	});

	//�����̵㵥��ϸ��Ϣ
	function QueryDetail(){
		var StkGrpId=Ext.getCmp('StkGrpType').getValue();
		var StkCatId=Ext.getCmp('DHCStkCatGroup').getValue();
		var StkBinId=Ext.getCmp('StkBin').getValue();
		var PhaWinId=Ext.getCmp('PhaWindow').getValue();
		var ManaGrpId=Ext.getCmp('LocManaGrp').getValue();
		var Params = '^^^^'+StkGrpId+'^'+StkCatId+'^'+ManaGrpId+'^'+StkBinId;
		var size = StatuTabPagingToolbar.pageSize;
		InstDetailStore.removeAll();
		InstDetailStore.setBaseParam('sort', 'desc');
		InstDetailStore.setBaseParam('dir', 'ASC');
		InstDetailStore.setBaseParam('Parref', gRowid);
		InstDetailStore.setBaseParam('Params', Params);
		InstDetailStore.load({params:{start:0,limit:size}});
	}
	
	var InstitPanel = new Ext.ux.FormPanel({
		title:'ʵ��:¼�뷽ʽ��(��ֵɨ���̵�)',
		bodyStyle : 'padding:10px 0px 0px 0px;',
		tbar:[SearchBT],
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			layout: 'column',
			style: 'padding:0 0 0 0;',
			defaults: {border:false},
			items : [{
					columnWidth: 0.34,
					xtype: 'fieldset',
					items: [LocManaGrp,StkBin]
				},{
					columnWidth: 0.33,
					xtype: 'fieldset',
					items: [StkGrpType,DHCStkCatGroup]
				},{
					columnWidth: 0.33,
					xtype: 'fieldset',
					items: [PhaWindow,InstNo]
				}]
			}, {
				xtype:'fieldset',
				title:'ɨ������¼��',
				layout: 'column',
				style: 'padding:0 0 5 0;',
				defaults: {border:false},
				items : [{
					columnWidth: 0.33,
					xtype: 'fieldset',
					items: [HVBarCode]
				}]
			}]
	});
    
    //��ѯ�̵㵥������Ϣ
    function Select(){
        if(gRowid==null || gRowid==''){
            return;
        }
        var mask=ShowLoadMask(Ext.getBody(),'���������Ժ�...');
        Ext.Ajax.request({
            url:url,
            params:{actiontype:'Select',Rowid:gRowid},
            method:'post',
            success:function(response,opt){
                var jsonData=Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if(jsonData.success=='true'){
                    var info=jsonData.info;
                    if(info!=''){
                        var detail=info.split('^');
                        var InstNo=detail[0];
                        var StkGrpId=detail[17];
                        var StkCatId=detail[18];
                        var StkCatDesc=detail[19];
                        var StkGrpDesc=detail[28];
                        Ext.getCmp('InstNo').setValue(InstNo);
                        addComboData(null,StkGrpId,StkGrpDesc,StkGrpType);
                        Ext.getCmp('StkGrpType').setValue(StkGrpId);
                        addComboData(StkCatStore,StkCatId,StkCatDesc);
                        Ext.getCmp('DHCStkCatGroup').setValue(StkCatId);
                    }
                }
            }
        });
    }

//    ['rowid', 'inclb', 'inci', 'code', 'desc','spec', 'manf', 'batchNo', 'expDate',
//			'freQty', 'uom', 'uomDesc', 'countQty','freDate','freTime',
//			'countDate','countTime','countPersonName','variance','sp','rp','freezeSpAmt','freezeRpAmt','countSpAmt',
//			'countRpAmt','varianceSpAmt','varianceRpAmt']

	var InstDetailStore = new Ext.data.JsonStore({
		url : url + '?actiontype=QueryDetail',
		root : 'rows',
		totalProperty : 'results',
		fields : ['rowid', 'inclb', 'inci', 'code', 'desc','spec', 'manf', 'batchNo', 'expDate',
			'freQty', 'uom', 'uomDesc', 'countQty','freDate','freTime',
			'countDate','countTime','countPersonName','variance','sp','rp','freezeSpAmt','freezeRpAmt','countSpAmt',
			'countRpAmt','varianceSpAmt','varianceRpAmt'],
		pruneModifiedRecords:true
	});

	var InstDetailGridCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header : 'parref',
			dataIndex : 'rowid',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header:'inclb',
			dataIndex:'inclb',
			width:80,
			align:'left',
			sortable:true,
			hidden:true
		},{
			header : '����',
			dataIndex : 'code',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'desc',
			width : 200,
			align : 'left',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'spec',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header:'����',
			dataIndex:'batchNo',
			width:100,
			align:'left',
			sortable:true
		},{
			header:'Ч��',
			dataIndex:'expDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header : '��λ',
			dataIndex : 'uomDesc',
			width : 60,
			align : 'left',
			sortable : true
		},{
			header:'��������',
			dataIndex:'freQty',
			width:80,
			align:'right',
			sortable:true
		},{
			header:'ʵ������',
			dataIndex:'countQty',
			width:80,
			align:'right',
			sortable:true
		},{
			header : '����',
			dataIndex : 'manf',
			width : 100,
			align : 'left',
			sortable : true
		},{
			header:'ʵ������',
			dataIndex:'countDate',
			width:80,
			align:'left',
			sortable:true
		},{
			header : 'ʵ��ʱ��',
			dataIndex : 'countTime',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header:'ʵ����',
			dataIndex:'userName',
			width:80,
			align:'left',
			sortable:true
		}
	]);
	
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : InstDetailStore,
		pageSize : PageSize,
		displayInfo : true
	});

	StatuTabPagingToolbar.addListener('beforechange',function(toolbar,params){
		if(InstDetailGrid.activeEditor != null){
			InstDetailGrid.activeEditor.completeEdit();
		}
		var records=InstDetailStore.getModifiedRecords();
		if(records.length>0){
			Msg.info('warning','��ҳ���ݷ����仯�����ȱ��棡');
			return false;
		}
	});

	var InstDetailSm = new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var insti = r.get('rowid');
				InstitStore.removeAll();
				InstitStore.setBaseParam('insti', insti);
				InstitStore.load({
					params : {start : 0, limit : 9999},
					callback : function(r, options, success){
						if(!success){
							Msg.info('error', '��ѯ����,��鿴��־!');
						}
					}
				});
			}
		}
	});

	var InstDetailGrid = new Ext.ux.GridPanel({
		id : 'InstDetailGrid',
		region : 'center',
		title : '�̵���ϸ��Ϣ',
		cm : InstDetailGridCm,
		store : InstDetailStore,
		sm : InstDetailSm,
		bbar : StatuTabPagingToolbar,
		clicksToEdit : 1,
		viewConfig:{
				getRowClass : function(record,rowIndex,rowParams,store){ 
					var count=record.get('countQty')
					var freez=record.get('freQty')
					if(freez==count){
					return 'classRed'
					}
				}
			}
	});

	var InstitStore = new Ext.data.JsonStore({
		url : url + '?actiontype=QueryItmTrackDetail',
		root : 'rows',
		totalProperty : 'results',
		fields : ['instit', 'dhcit', 'HVBarCode', 'institFlag', 'institDate',
			'institTime','institUser']
	});

	var HVBarCodeInfoCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header : 'instit',
			dataIndex : 'instit',
			width : 60,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '����ID',
			dataIndex : 'dhcit',
			width : 60,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '��ֵ����',
			dataIndex : 'HVBarCode',
			width : 220,
			align : 'left',
			sortable : true,
			editable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField())
		}, {
			header : '�̵��־',
			dataIndex : 'institFlag',
			width : 60,
			xtype : 'checkcolumn'
		}
	]);
	
	var HVBarCodeInfoGrid = new Ext.ux.EditorGridPanel({
		region : 'east',
		width : 350,
		id : HVBarCodeInfoGrid,
		title : '�����̵���Ϣ',
		cm : HVBarCodeInfoCm,
		sm : new Ext.grid.RowSelectionModel(),
		store : InstitStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		clicksToEdit : 1
	});
	
	Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [InstitPanel, InstDetailGrid, HVBarCodeInfoGrid]
		});
		
		Select();
		QueryDetail();
	});
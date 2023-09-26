// /����: ʵ�̣�¼�뷽ʽ���������������ݰ�Ʒ�����ʵ������
// /����: ʵ�̣�¼�뷽ʽ���������������ݰ�Ʒ�����ʵ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.07
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gUserId=session['LOGON.USERID'];
	var gStrDetailParams='';
	var url=DictUrl+'instktkaction.csp';
	var LocManaGrp = new Ext.form.ComboBox({
		fieldLabel : '������',
		id : 'LocManaGrp',
		name : 'LocManaGrp',
		anchor : '90%',
		store : LocManGrpStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		emptyText : '������...',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 20,
		listWidth : 250,
		valueNotFoundText : '',
		listeners:{
			'beforequery':function(combox){
				this.store.removeAll();
				LocManGrpStore.setBaseParam('locId',gLocId)
				LocManGrpStore.load({params:{start:0,limit:20}});	
			}
		}
	});
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		UserId:gUserId,
		LocId:gLocId,
		anchor:'90%',
		childCombo : ['DHCStkCatGroup']
	});

	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'DHCStkCatGroup',
		name : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});

	var StkBin = new Ext.ux.ComboBox({
		fieldLabel : '��λ',
		id : 'StkBin',
		name : 'StkBin',
		anchor : '90%',
		width : 140,
		store : LocStkBinStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 20,
		listWidth : 250,
		valueNotFoundText : '',
		enableKeyEvents : true,
		listeners : {
			'beforequery' : function(e) {
				this.store.removeAll();
				LocStkBinStore.setBaseParam('LocId',gLocId);
				LocStkBinStore.setBaseParam('Desc',Ext.getCmp('StkBin').getRawValue());
				LocStkBinStore.load({params:{start:0,limit:20}});
			}
		}
	});
	
	var InstNo=new Ext.form.TextField({
		id : 'InstNo',
		name : 'InstNo',
		fieldLabel:'�̵㵥��',
		width:140,
		anchor:'90%',
		disabled:true
	});
	
	var InputWin = new Ext.form.ComboBox({
		fieldLabel : 'ʵ�̴���',
		id : 'InputWin',
		name : 'InputWin',
		anchor : '90%',
		store : INStkTkWindowStore,
		valueField : 'RowId',
		displayField : 'Description',
		disabled:true,
		allowBlank : true,
		triggerAction : 'all',
		emptyText : 'ʵ�̴���...',
		listeners:{
			'beforequery':function(e){
				this.store.removeAll();
				this.store.setBaseParam('LocId',gLocId);
				this.store.load({params:{start:0,limit:99}});
			}
		}
	});
	
	INStkTkWindowStore.load({
		params:{start:0,limit:99,'LocId':gLocId},
		callback:function(){
			Ext.getCmp("InputWin").setValue(gInputWin);
		}
	});
	
	var InciCode = {
		id : 'InciCode',
		xtype : 'textfield',
		fieldLabel : '���ʴ���',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e){
				if(e.getKey() == Ext.EventObject.ENTER){
					QueryDetail();
				}
			}
		}
	};
	
	//����δ��������������
	var SetDefaultBT2 = new Ext.Toolbar.Button({
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
					   SetDefaultQty(2);
				   }
			   },
			   icon: Ext.MessageBox.QUESTION
			});
		}
	});

	//����δ��������0
	var SetDefaultBT = new Ext.Toolbar.Button({
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
					   SetDefaultQty(1);
				   }
			   },
			   icon: Ext.MessageBox.QUESTION
			});
		}
	});
	
	//����δ��ʵ����
	function SetDefaultQty(flag){
		if(gRowid==''){
			Msg.info('Warning','û��ѡ�е��̵㵥��');
			return;
		}
		var InstwWin=Ext.getCmp("InputWin").getValue();
		var UserId=session['LOGON.USERID'];
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'InputSetDefaultQty',Inst:gRowid,UserId:UserId,Flag:flag,InstwWin:InstwWin},
			method:'post',
			waitMsg:'������...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info('success','�ɹ�!');
					create(gRowid);
				}else{
					var ret=jsonData.info;					
					Msg.info('error','����δ���¼ʵ����ʧ��:'+ret);
				}
			}		
		});
	}
	// ��ѯ��ť
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
	
	// ��հ�ť
	var RefreshBT = new Ext.Toolbar.Button({
		text : '���',
		tooltip : '������',
		iconCls : 'page_clearscreen',
		width : 70,
		height : 30,
		handler : function() {
			clearData();
		}
	});

	/**
	 * ��շ���
	 */
	function clearData() {
		Ext.getCmp("DHCStkCatGroup").setValue('');
		Ext.getCmp("StkBin").setValue('');
		Ext.getCmp("StkGrpType").setValue('');
		Ext.getCmp("LocManaGrp").setValue('');
		Select();
		InstDetailGrid.store.removeAll();
		InstDetailGrid.getView().refresh();
	}

	var SaveBT=new Ext.Toolbar.Button({
		text:'����',
		tooltip:'�������',
		iconCls:'page_save',
		width:70,
		height:30,
		handler:function(){
			save();
		}
	});
	
	/*
	// ��ɰ�ť	//2013-09-29 wangjiabin: �˰�ť���޸���ʵ�̴��ں���ʹ��, �ݲ�ɾ��, �޸������
	var CompleteBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '������',
				iconCls : 'page_gear',
				width : 70,
				height : 30,
				handler : function() {
					Complete();
				}
			});
	function Complete(){
		var UserId=session['LOGON.USERID'];
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'CompleteInput',Inst:gRowid,User:UserId},
			method:'post',
			waitMsg:'������...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info('success','�����ɹ�!');
					QueryDetail();
				}else{
					var ret=jsonData.info;					
					Msg.info('error','����ʧ��:'+ret);
					
				}
			}		
		});
	
	}
	*/
	
	//����ʵ������
	function save(){
		if(InstDetailGrid.activeEditor != null){
			InstDetailGrid.activeEditor.completeEdit();
		}
		var rowCount=InstDetailStore.getCount();
		var ListDetail='';
		var InputWin=Ext.getCmp("InputWin").getValue();
		for(var i=0;i<rowCount;i++){
			var rowData=InstDetailStore.getAt(i);
			//�������޸Ĺ�������
			if(rowData.dirty || rowData.data.newRecord){
				var Parref=rowData.get('parref');
				var Rowid=rowData.get('rowid');
				var UserId=session['LOGON.USERID'];
				var CountQty=rowData.get('countQty');
				if(CountQty==""){
					CountQty=0;
				}
				var CountUomId=rowData.get('uom');
				var IncId=rowData.get('inci');
				var Detail=Rowid+'^'+Parref+'^'+IncId+'^'+CountUomId+'^'+CountQty+'^'+UserId+'^'+InputWin;
				if(ListDetail==''){
					ListDetail=Detail;
				}else{
					ListDetail=ListDetail+xRowDelim()+Detail;
				}
			}
		}
		if(ListDetail==''){
			Msg.info('Warning','û����Ҫ���������!');
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'SaveInput',Params:ListDetail},
			method:'post',
			waitMsg:'������...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info('success','����ɹ�!');
					InstDetailStore.reload();
				}else{
					var ret=jsonData.info;
					if(ret=='-1'){
						Msg.info('warning','û����Ҫ���������!');
					}else if(ret=='-2'){
						Msg.info('error','����ʧ��!');
					}else{
						Msg.info('error','�������ݱ���ʧ��:'+ret);
					}
				}
			}		
		});
	}

	//�����������ݲ���ʵ���б�
	function create(inst){
		if(inst==null || inst==''){
			Msg.info('warning','��ѡ���̵㵥');
			return;
		}
		var UserId=session['LOGON.USERID'];
	    var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'CreateStkTkInput',Inst:inst,UserId:UserId,InputWin:gInputWin},
			waitMsg:'������...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					QueryDetail();    //����ʵ���б�
				}else{
					var ret=jsonData.info;					
					Msg.info("error","��ȡʵ���б�ʧ�ܣ�"+ret);					
				}
			}			
		});
	}
		
	//�����̵㵥��ϸ��Ϣ
	function QueryDetail(){
		//��ѯ�̵㵥��ϸ
		var StkGrpId=Ext.getCmp('StkGrpType').getValue();
		var StkCatId=Ext.getCmp('DHCStkCatGroup').getValue();
		var StkBinId=Ext.getCmp('StkBin').getValue();
		var ManaGrpId=Ext.getCmp('LocManaGrp').getValue();
		var InputWin=Ext.getCmp('InputWin').getValue();
		var InciCode=Ext.getCmp('InciCode').getValue();
		var size=StatuTabPagingToolbar.pageSize;
		gStrDetailParams=gRowid+'^'+ManaGrpId+'^'+StkGrpId+'^'+StkCatId+'^'+StkBinId
			+'^'+InputWin+'^'+InciCode;
		InstDetailStore.setBaseParam('sort','code');
		InstDetailStore.setBaseParam('dir','ASC');
		InstDetailStore.setBaseParam('Params',gStrDetailParams)
		InstDetailStore.load({
			params:{start:0,limit:size},
			callback:function(r,options,success){
				if(success==false){
					Msg.info("error","��ѯ����,��鿴��־!");
				}
			}
		});
	}
	//��ѯ�̵㵥������Ϣ
	function Select(){
		if(gRowid==null || gRowid==""){
			return;
		}
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'Select',Rowid:gRowid},
			method:'post',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					var info=jsonData.info;
					if(info!=""){
						var detail=info.split("^");
						var InstNo=detail[0];
						var StkGrpId=detail[17];
						var StkCatId=detail[18];
						var StkCatDesc=detail[19];
						var StkGrpDesc=detail[28];
						Ext.getCmp("InstNo").setValue(InstNo);
						addComboData(null,StkGrpId,StkGrpDesc,StkGrpType);
						Ext.getCmp("StkGrpType").setValue(StkGrpId);
						addComboData(StkCatStore,StkCatId,StkCatDesc);
						Ext.getCmp("DHCStkCatGroup").setValue(StkCatId);
					}
				}
			}
		});
	}
	
	var nm = new Ext.grid.RowNumberer();
	var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
				header : "rowid",
				dataIndex : 'rowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "parref",
				dataIndex : 'parref',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header:"inci",
				dataIndex:'inci',
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
				header : "����",
				dataIndex : 'desc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'spec',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'uomDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'freQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header:'ʵ������',
				dataIndex:'countQty',
				width:80,
				align:'right',
				sortable:true,
				editor:new Ext.form.NumberField({
					selectOnFocus : true,
					allowNegative : false
				})
			},{
				header : "������",
				dataIndex : 'diffQty',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header:'��λ',
				dataIndex:'IncsbDesc',
				width:100,
				align:'left',
				sortable:true
			},{
				header:'ʵ������',
				dataIndex:'countDate',
				width:80,
				align:'left',
				sortable:true
			},{
				header : "ʵ��ʱ��",
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
			}]);
	InstDetailGridCm.defaultSortable = true;

	// ���ݼ�
	var InstDetailStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : url+"?actiontype=QueryInput",
			method : "POST"
		}),
		reader :  new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "rowid",
			fields : ["rowid","parref", "inci", "code", "desc","spec", 
				"uom", "uomDesc", "freQty", "countQty","countDate",
				"countTime","userName","IncsbDesc","diffQty"]
		}),
		pruneModifiedRecords: true
	});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : InstDetailStore,
		pageSize : PageSize,
		displayInfo : true,
		displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		emptyMsg : "No results to display",
		prevText : "��һҳ",
		nextText : "��һҳ",
		refreshText : "ˢ��",
		lastText : "���ҳ",
		firstText : "��һҳ",
		beforePageText : "��ǰҳ",
		afterPageText : "��{0}ҳ",
		emptyMsg : "û������"
	});
		
	StatuTabPagingToolbar.addListener('beforechange',function(toolbar,params){
		if(InstDetailGrid.activeEditor != null){
			InstDetailGrid.activeEditor.completeEdit();
		}
		var records=InstDetailStore.getModifiedRecords();
		if(records.length>0){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '��ҳ���ݷ����ı䣬�Ƿ���Ҫ���棿',
				buttons: Ext.Msg.YESNOCANCEL,
				fn: function(btn,text,opt){
					if(btn=='yes'){
						save();
						toolbar.store.commitChanges();
						changePagingToolBar(toolbar,params.start);
					}
					if(btn=='no'){
						toolbar.store.rejectChanges();
						changePagingToolBar(toolbar,params.start);
					}
				},
				animEl: 'elId',
				icon: Ext.MessageBox.QUESTION
			});
			return false;
		}
	});

	//startRow:��ǰҳ�п�ʼ�е������м�¼�е�˳��
	function changePagingToolBar(toolbar,startRow){
		if(toolbar.cursor > startRow){
			if(toolbar.cursor - startRow == toolbar.pageSize){
				toolbar.movePrevious();
			}else{
				toolbar.moveFirst();
			}
		}
		if(toolbar.cursor < startRow){
			if(toolbar.cursor - startRow == -toolbar.pageSize){
				toolbar.moveNext();
			}else{
				toolbar.moveLast();
			}
		}
	}
	var InstDetailGrid = new Ext.grid.EditorGridPanel({
		id:'InstDetailGrid',
		region : 'center',
		cm : InstDetailGridCm,
		store : InstDetailStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.ux.CellSelectionModel(),
		loadMask : true,
		bbar : StatuTabPagingToolbar,
		clicksToEdit:1,
		listeners:{
			'afteredit' : function(e){
				if(e.field=='countQty'){
					var FreQty=e.record.get("freQty");
					var countQty=e.record.get("countQty");
					var diffQty=countQty-FreQty;
					e.record.set("diffQty",diffQty);
				}
			}
		}
	});
	
	var form = new Ext.form.FormPanel({
		region : 'north',
		autoHeight : true,
		labelAlign : 'right',
		title : 'ʵ��:¼�뷽ʽ��(��Ʒ��¼��)',
		frame : true,
		tbar:[SearchBT,'-',SaveBT,'-',RefreshBT,'-',SetDefaultBT,'-',SetDefaultBT2],
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			layout: 'column',
			defaults: {layout:'form'},
			items : [{
				columnWidth: 0.34,
				items: [LocManaGrp,StkBin,InciCode]
			},{
				columnWidth: 0.33,
				items: [StkGrpType,InstNo]
			},{
				columnWidth: 0.33,
				items: [DHCStkCatGroup,InputWin]
			}]
		}]
	});
	
	// 5.2.ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [form,
				{
					region:'center',
					layout:'fit',
					items:[InstDetailGrid]
				}],
		renderTo : 'mainPanel'
	});
	Select();
	//�Զ������̵㵥
	create(gRowid);
})
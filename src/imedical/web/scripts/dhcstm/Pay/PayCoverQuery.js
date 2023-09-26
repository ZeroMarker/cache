// /����:�������
// /����: �������
// /��д�ߣ�zhangxiao
// /��д����: 2017.10.20
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var actionUrl = DictUrl+"paycoveraction.csp"
	
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// ��ⲿ��
		var PhaLoc=new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			width : 120,
			emptyText : '��ⲿ��...',
			groupId:gGroupId
		});
		
		
		
		
		
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 100,
			value:new Date()		
		});

		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '��ֹ����',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 100,
			value:new Date()
		});

		
		var CreateUser = new Ext.ux.ComboBox({
			id : 'CreateUser',
			fieldLabel : '�Ƶ���',
			store : UStore,
			params : {locId : 'PhaLoc'},
			filterName : 'name'
		});
		
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
			id:"SearchBT",
			text : '��ѯ',
			tooltip : '�����ѯ',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				MasterGrid.load();
			}
		});
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
			id:'ClearBT',
			text : '���',
			tooltip : '������',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				clearData();
			}
		});
		// ɾ����ť
		var DeleteBT = new Ext.Toolbar.Button({
			id:'DeleteBT',
			text : 'ɾ��',
			tooltip : '���ɾ��',
			width : 70,
			height : 30,
			iconCls : 'page_gear',
			handler : function() {
					var selections=MasterGrid.getSelectionModel().getSelections();
					if(selections.length<1){
					Msg.info("warning", "��ѡ����Ҫɾ���ĸ������!");
					return;
				}else{
					Ext.MessageBox.show({
						title : '��ʾ',
						msg : '�Ƿ�ɾ���ø������?',
						buttons : Ext.MessageBox.YESNO,
						fn: function(b,t,o){
							if (b=='yes'){
								Delete();
							}
						},
						icon : Ext.MessageBox.QUESTION
					});
				  }
				}
		});
		// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
			id:'PrintBT',
			text : '�������ӡ',
			tooltip : '�����ӡ',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "��ѡ����Ҫ��ӡ����ⵥ!");
					return;
				}
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var CoverId=record.get("CoverId");
					PrintPayCover(CoverId);
				}
			}
		});

		
		// ��ӡ��ť
		var PrintBT2 = new Ext.Toolbar.Button({
			id:'PrintBT2',
			text : '��Ӧ����ϸ��ӡ',
			tooltip : '��Ӧ����ϸ��ӡ',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "��ѡ����Ҫ��ӡ����ⵥ!");
					return;
				}
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var CoverId=record.get("CoverId");
					PrintPayCover2(CoverId);
				}
			}
		});
		
		/**
		 * ��շ���
		 */
		function clearData() {
			clearPanel(HisListTab);
			//HisListTab.getForm().setValues({StartDate:DefaultStDate(),EndDate:DefaultEdDate()});
			MasterGrid.removeAll();
			DetailGrid.removeAll();
			//DeleteBT.setDisabled(true);
			//PrintBT.setDisabled(true);

		}
		
		/**
		 * ��˷���
		 */
		function Delete() {
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "��ѡ����Ҫɾ���ĸ������!");
				return;
			}
			
			var CoverId = rowData.get("CoverId");
			var loadMask=ShowLoadMask(document.body,"ɾ����...");
			var url = DictUrl
					+ "paycoveraction.csp?actiontype=Delete&CoverId="+ CoverId;

			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					loadMask.hide();
					if (jsonData.success == 'true') {
						Msg.info("success", "ɾ���ɹ�!");
						MasterGrid.reload();
						
					} else {
						var Ret=jsonData.info;
						var arr=Ret.split("^");
						Ret=arr[0];
						var IncDesc=arr[1];
						if(Ret==-1){
							Msg.info("error", "��ⵥ�޸�ʧ��!");
						}else if(Ret==-2){
							Msg.info("error", "�˻����޸�ʧ��!");
						}else if(Ret==-3){
							Msg.info("error", "ɾ���������ʧ��!");
						}else{
							Msg.info("error", "���ʧ��:"+Ret);
						}
					}
				},
				scope : this
			});
		}
		
		var MasterCm = [ {
					header : "rowid",
					dataIndex : 'CoverId',
					width : 60,
					hidden : true
				}, {
					header : "����",
					dataIndex : 'CoverNo',
					width : 220,
					align : 'left',
					sortable : true
				}, {
					header : '����',
					dataIndex : 'LocDesc',
					width : 200,
					align : 'left',
					sortable : true
				},  {
					header : "��������",
					dataIndex : 'CreateDate',
					width : 80,
					align : 'left'
				}, {
					header : "�Ƶ���",
					dataIndex : 'CreateUser',
					width : 60,
					align : 'left'
				}, {
					header : "�·�",
					dataIndex : 'Month',
					width : 70,
					align : 'left'
				}, {
					header : "Ʊ������",
					dataIndex : 'VoucherCount',
					width : 80,
					align : 'left'
				}, {
					header : "���۽��",
					dataIndex : 'RpAmt',
					width : 100,
					xtype:'numbercolumn'
				}, {
					header : "�ۼ۽��",
					dataIndex : 'SpAmt',
					xtype : 'numbercolumn',
					width : 100,
					align : 'right'
				}];
		
		var MasterGrid = new Ext.dhcstm.EditorGridPanel({
			region : 'center',
			title: '�������',
			id:'MasterGrid',
			childGrid : "DetailGrid",
			region : 'center',
			editable : false,
			contentColumns : MasterCm,
			smType : 'checkbox',
			singleSelect : false,
			checkOnly : true,
			smRowSelFn : rowSelFn,
			autoLoadStore : true,
			actionUrl : actionUrl,
			queryAction : "Query",
			paramsFn : GetMasterParams,
			idProperty : 'IngrId',
			showTBar : false
		});
		function Types(value){
            if (value=="G"){
	          return  '���' ;
	       }else if (value=="R"){
		    return  '�˻�' ;
	     }
       }
		function rowSelFn(sm, rowIndex, r) {
			var rowData = sm.grid.getAt(rowIndex);
			var CoverId = rowData.get("CoverId");
			DetailGrid.load({params:{Parref:CoverId}});

		}
				
		function GetMasterParams(){
			var PhaLoc = Ext.getCmp("PhaLoc").getValue();
			var StartDate = Ext.getCmp("StartDate").getValue();
			var EndDate = Ext.getCmp("EndDate").getValue();
			if(PhaLoc==""){
				Msg.info("warning", "��ѡ����ⲿ��!");
				return false;
			}
			if(StartDate==""){
				Msg.info("warning", "��ѡ��ʼ����!");
				return false;
			}else{
				StartDate=StartDate.format(ARG_DATEFORMAT).toString();
			}
			if(EndDate==""){
				Msg.info("warning", "��ѡ���ֹ����!");
				return false;
			}else{
				EndDate=EndDate.format(ARG_DATEFORMAT).toString();
			}
			var CreateUser = Ext.getCmp("CreateUser").getValue();
			var ListParam=StartDate+'^'+EndDate+'^'+PhaLoc+'^'+CreateUser
			
			return {"ParamStr":ListParam};
		}
	

		var DetailCm = [{
					header : "RecRetId",
					dataIndex : 'RecRetId',
					width : 80,
					hidden : true
				}, {
					header : "����",
					dataIndex : 'gdNo',
					width : 200,
					align : 'left',
					//hidden : true,
					sortable : true
				}, {
					header : "����",
					dataIndex : 'type',
					width : 70,
					align : 'left',
					renderer:Types,
					sortable : true
				}, {
					header : '��Ӧ��',
					dataIndex : 'vendorName',
					width : 260,
					align : 'left',
					sortable : true
				}, {
					header : "���۽��",
					dataIndex : 'gdRpAmt',
					width : 100,
					xtype : 'numbercolumn'
				}, {
					header : "�ۼ۽��",
					dataIndex : 'gdSpAmt',
					width : 100,
					xtype : 'numbercolumn'
				}];
		
		var DetailGrid = new Ext.dhcstm.EditorGridPanel({
			region: 'south',
			height : gGridHeight,
			split: true,
			minSize: 200,
			maxSize: 350,
			collapsible: true,
			title: '���/�˻���',
			id : 'DetailGrid',
			contentColumns : DetailCm,
			actionUrl : actionUrl,
			queryAction : "QueryCoverRec",
			selectFirst : false,
			idProperty : "RecRetId",
			//checkProperty : "IncId",
			paging : false,
			showTBar : false
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			labelWidth : 60,
			title:'����������',
			bodyStyle : 'padding:5px 0px 0px 0px;',
			tbar : [SearchBT, '-', ClearBT, '-', DeleteBT, '-', PrintBT,'-',PrintBT2],
			items:[{
				xtype:'fieldset',
				title:'��ѯ����',
				layout: 'column',
				style:'padding:5px 0px 0px 0px;',
				defaults: {width: 220, border:false},
				items : [{
						columnWidth: 0.25,
						xtype: 'fieldset',
						items: [PhaLoc]
					},{
						columnWidth: 0.2,
						xtype: 'fieldset',
						items: [StartDate]
					},{
						columnWidth: 0.25,
						xtype: 'fieldset',
						items: [EndDate]
					},{
						columnWidth: 0.25,
						xtype: 'fieldset',
						items: [CreateUser]
					}]
			}]
		});

		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, MasterGrid, DetailGrid],
			renderTo : 'mainPanel'
		});
	}
})
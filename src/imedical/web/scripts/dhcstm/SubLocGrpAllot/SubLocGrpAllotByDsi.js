// /����: רҵ�����ʷ���
// /����: רҵ���쵽�����ʸ���Ȩ�ؽ����÷��䵽ҽ������
// /��д�ߣ�	wangjiabin
// /��д����:2013-12-23
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';	//����չ����ϸʱ�Ĳ���
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	ChartInfoAddFun();

	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType'
		});
		
		var ToPhaLoc = new Ext.ux.ComboBox({
			id:'ToPhaLoc',
			fieldLabel:'���տ���',
			emptyText:'���տ���...',
			triggerAction : 'all',
			store : LeadLocStore,
			valueParams : {groupId : gGroupId},
			filterName : '',
			childCombo : ['UserGroup']
		});
		SetLogInDept(ToPhaLoc.getStore(),'ToPhaLoc');
		
		var lastMon = new Date().add(Date.MONTH,-1);
		var firstDay = lastMon.getFirstDateOfMonth();
		var lastDay = lastMon.getLastDateOfMonth();
		
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			
			value : firstDay
		});
		
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '��ֹ����',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			
			value : lastDay
		});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor : '90%',
			LocId:gLocId,
			UserId:gUserId
		});
		
		//רҵ��
		var UserGroup = new Ext.ux.ComboBox({
			fieldLabel : 'רҵ��',
			id : 'UserGroup',
			name : 'UserGroup',
			store:UserGroupStore,
			valueField:'RowId',
			displayField:'Description',
			params:{SubLoc:'ToPhaLoc'}
		});
		
		UserGroupStore.load({
			params:{start:0,limit:UserGroup.pageSize,SubLoc:Ext.getCmp('ToPhaLoc').getValue()},
			callback:function(r,options,success){
				if(success && r.length>0){
					UserGroup.setValue(r[0].get(UserGroup.valueField))
				}
			}
		});
		
		var lastMonDesc = lastMon.format(ARG_DATEFORMAT);
		var AllotMon = new Ext.form.TextField({
			fieldLabel : '���䵥�·�',
			id : 'AllotMon',
			name : 'AllotMon',
			anchor : '90%',
			value : lastMonDesc.slice(0,7),
			regex : /^\d{4}-(0[1-9])|(1[0|1|2])$/,
			regexText : '�·ݸ�ʽ����'
		});
		
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				searchData();
			}
		});

		/**
		 * ��ѯ����
		 */
		function searchData() {
			// ��ѡ����
			var LUG=Ext.getCmp("UserGroup").getValue();		//רҵ��
			if(LUG==""){
				Msg.info("warning","רҵ�鲻��Ϊ��!");
				return;
			}
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "���Ҳ���Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var StartDate = Ext.getCmp("StartDate").getValue();
			if(StartDate==""){
				Msg.info("warning","��ʼ���ڲ���Ϊ��!");
				Ext.getCmp("StartDate").focus();
				return;
			}else{
				StartDate = StartDate.format(ARG_DATEFORMAT).toString();
			}
			var EndDate = Ext.getCmp("EndDate").getValue();
			if(EndDate==""){
				Msg.info("warning","��ֹ���ڲ���Ϊ��!");
				Ext.getCmp("EndDate").focus();
				return;
			}else{
				EndDate = EndDate.format(ARG_DATEFORMAT).toString();
			}
			if(StartDate>EndDate){
				Msg.info("warning","��ʼ���ڴ��ڽ�ֹ����!");
				return;
			}
			
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			
//			if (StkGrpRowId == null || StkGrpRowId.length <= 0) {
//				Msg.info("warning", "���鲻��Ϊ�գ�");
//				Ext.getCmp("StkGrpType").focus();
//				return;
//			}
			
			var IncludeRet=1,userDr="",inciDr="",StkCatDr="";
			var ToPhaLoc = Ext.getCmp("ToPhaLoc").getValue();
			//sd^ed^�����˻ر�־(0:������,1:����)^loc^userID^רҵ��^inci^scg^stkcat
			var strParam = StartDate+"^"+EndDate+"^"+IncludeRet+"^"+phaLoc+"^"+userDr
						+"^"+LUG+"^"+inciDr+"^"+StkGrpRowId+"^"+StkCatDr+"^"+ToPhaLoc;
			
			MasterStore.removeAll();
			DetailGrid.store.removeAll();
			AllotStore.removeAll();
			MasterStore.setBaseParam("strPar",strParam);
			var pageSize=MasterPagingBar.pageSize;
			MasterStore.load({
				params:{start:0,limit:pageSize},
				callback:function(r,options,success){
					if(!success){
						Msg.info("error","��ѯ����, ��鿴��־!");
					}else if(r.length>0){
						gStrParam = StartDate+"^"+EndDate+"^"+phaLoc+"^"+LUG+"^"+""
							+"^"+StkGrpRowId+"^^"+IncludeRet+"^"+ToPhaLoc;
     					MasterGrid.getSelectionModel().selectFirstRow();
     					MasterGrid.getView().focusRow(0);
					}
				}
			});
			ScaleStore.removeAll();
			ScaleStore.load({
				params:{UserGrpId:LUG}
			});
		}
				
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
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
			gStrParam='';
			SetLogInDept(PhaLoc.getStore(),"PhaLoc");
			SetLogInDept(ToPhaLoc.getStore(),"ToPhaLoc");
			Ext.getCmp("UserGroup").setValue("");
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-30));
			Ext.getCmp("EndDate").setValue(new Date());
			
			MasterStore.removeAll();
			Common_ClearPaging(MasterPagingBar);
			DetailStore.removeAll();
			AllotStore.removeAll();
			ScaleStore.removeAll();
		}

		// ���水ť
		var SaveBT = new Ext.Toolbar.Button({
			text : '����',
			tooltip : '�������',
			id : 'SaveBT',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				if(ScaleGrid.activeEditor != null){
					ScaleGrid.activeEditor.completeEdit();
				}
				saveData();
			}
		});
		
		function saveData(){
			var locId = Ext.getCmp('PhaLoc').getValue();
			var grpId = Ext.getCmp('UserGroup').getValue();
			var comp = 'N';
			var count = AllotStore.getCount();
			var StkGrpType = Ext.getCmp('StkGrpType').getValue();
			var AllotMon = Ext.getCmp("AllotMon").getValue();
			AllotMon = AllotMon+"-"+"01";
			var MainData = locId+"^"+grpId+"^"+gUserId+"^"+comp+"^"+StkGrpType+"^"+AllotMon;
			var listIndsiId = "";
			for(var k=0;k<count;k++){
				if(listIndsiId==""){
					listIndsiId = AllotStore.getAt(k).get('IndsiStr');
				}else{
					listIndsiId = listIndsiId +"^"+ AllotStore.getAt(k).get('IndsiStr');
				}
			}
			var ScaleCount = ScaleStore.getCount();
			var ListScaleStr="";
			for(var n=0;n<ScaleCount;n++){
				var UserScale = "^"+ScaleStore.getAt(n).get('UserId')+"^"+ScaleStore.getAt(n).get('ScaleValue');
				if(ListScaleStr==""){
					ListScaleStr = UserScale;
				}else{
					ListScaleStr = ListScaleStr +RowDelim+ UserScale;
				}
			}
			if(listIndsiId==""){
				Msg.info("warning","��ѡ����Ҫ���ɷ��䵥������!");
				return;
			}
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
				url: DictUrl+"sublocgrpallotaction.csp?actiontype=CreateAllotByDsi",
				method:'POST',
				waitMsg : '������...',
				params:{MainData:MainData,ListDsiId:listIndsiId,ListScaleStr:ListScaleStr},
				success:function(result,request) {
					loadMask.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if(jsonData.success=='true'){
						Msg.info("success","����ɹ�!");
						var AllotId=jsonData.info;
						window.location.href='dhcstm.sublocgrpallot.csp?gAllotId='+AllotId;
					}else{
						Msg.info("error","����ʧ��"+jsonData.info);
					}
				}
			});
		}
		
		var nm = new Ext.grid.RowNumberer();
		var MasterSm = new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
				rowselect : function(sm, rowIndex, r) {
					var inci = MasterStore.getAt(rowIndex).get("inci");
					var tmpArr = gStrParam.split("^");
					tmpArr[6] = inci;
					gStrParam = tmpArr.join("^");
					DetailStore.setBaseParam('strPar',gStrParam);
					DetailStore.load({
						params:{start:0,limit:999},
						callback:function(r,options,success){
							if(!success){
								Msg.info("error","��ϸ��ѯ����, ��鿴��־!");
							}else{
								RefreshDetailSm(inci);
							}
						}
					});
				}
			}
		});
		
		function RefreshDetailSm(inci){
			var allotIndex = AllotStore.findExact('inci',inci);
			if(allotIndex>=0){
				var IndsiStr = AllotStore.getAt(allotIndex).get('IndsiStr');
				var IndsiArr = IndsiStr.split("^");
				for(var i=0;i<IndsiArr.length;i++){
					var indsiDetailIndex = DetailStore.findExact('pointer',IndsiArr[i]);
					DetailSm.selectRow(indsiDetailIndex,true);
				}
			}
		}
		
		var MasterCm = new Ext.grid.ColumnModel([nm,{
					header : "�����id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '���ʴ���',
					dataIndex : 'InciCode',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'InciDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "���",
					dataIndex : 'Abbrev',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : "���",
					dataIndex : 'Spec',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : 'Ʒ��',
					dataIndex : 'Brand',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "�ͺ�",
					dataIndex : 'Model',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : '���۽��',
					dataIndex : 'RpAmt',
					width : 60,
					align : 'right',
					sortable : false
				}, {
					header : '��������',
					dataIndex : 'QtyUom',
					width : 80,
					align : 'left',
					sortable : false
				}
		]);
		MasterCm.defaultSortable = true;

		// ����·��
		var MasterUrl = DictUrl
					+ 'sublocmatstataction.csp?actiontype=INDispStat';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["inci","InciCode","InciDesc","Abbrev","Spec","Model","Brand","QtyUom","RpAmt"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "inci",
					fields : fields
				});
		// ���ݼ�
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true,
					baseParams:{
						ExcludeAlloted:1	//�����Ѿ��������䵥������
					}
				});

		var MasterPagingBar = new Ext.PagingToolbar({
					store : MasterStore,
					pageSize : PageSize,
					displayInfo : true
				});
		
		var MasterGrid = new Ext.ux.GridPanel({
					id:'MasterGrid',
					region:'west',
					title: '��������ͳ��',
					width:700,
					cm : MasterCm,
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : MasterSm,
					loadMask : true,
					bbar : [MasterPagingBar]
				});
		
		var	DetailSm = new Ext.grid.CheckboxSelectionModel({
			listeners:{
				rowselect : function(sm,rowIndex,record){
					var inci = record.get('inci');
					var allotIndex = AllotStore.findExact('inci',inci);
					//��ϸId
					var indsi = record.get('pointer');
					if(allotIndex>=0){
						var AllotRecord = AllotStore.getAt(allotIndex);
						var IndsiArr = AllotRecord.get('IndsiStr').split("^");
						if(IndsiArr.indexOf(indsi)==-1){
							IndsiArr.push(indsi);
							var IndsiStr = IndsiArr.join("^");
							AllotRecord.set('IndsiStr',IndsiStr);
							var AllotRpAmt = parseFloat(AllotRecord.get('AllotRpAmt'))+parseFloat(record.get('rpAmt'));
							AllotRecord.set('AllotRpAmt',AllotRpAmt);
						}
					}else{
						addNewAllotRow();
						var rowData = AllotStore.getAt(AllotStore.getCount()-1);
						rowData.set('inci',record.get('inci'));
						rowData.set('InciCode',record.get('inciCode'));
						rowData.set('InciDesc',record.get('inciDesc'));
						rowData.set('AllotRpAmt',parseFloat(record.get('rpAmt')));
						rowData.set('IndsiStr',indsi);
					}
				},
				rowdeselect : function(sm,rowIndex,record){
					var inci = record.get('inci');
					var allotIndex = AllotStore.findExact('inci',inci);
					//��ϸId
					var indsi = record.get('pointer');
					var AllotRecord = AllotStore.getAt(allotIndex);
					var IndsiArr = AllotRecord.get('IndsiStr').split("^");
					var indsiArrIndex = IndsiArr.indexOf(indsi);
					IndsiArr.splice(indsiArrIndex,1);
					if(IndsiArr.length==0){
						AllotStore.remove(AllotRecord);
					}else{
						IndsiStr = IndsiArr.join("^");
						AllotRecord.set('IndsiStr',IndsiStr);
						var AllotRpAmt = parseFloat(AllotRecord.get('AllotRpAmt'))-parseFloat(record.get('rpAmt'));
						AllotRecord.set('AllotRpAmt',AllotRpAmt);
					}
				}
			}
		});
		
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([
				nm,DetailSm, {
					header : "indsi",
					dataIndex : 'pointer',
					width : 60,
					align : 'left',
					hidden : true,
					sortable : true
				},{
					header : "ҵ������",
					dataIndex : 'trType',
					width : 60,
					align : 'left',
					hidden : true,
					sortable : true,
					renderer:function(v){
						if(v=="C"){
							return "����";
						}else if(v=="L"){
							return "�˻�";
						}else{
							return v;
						}
					}
				},{
					header : "�����id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "����~Ч��",
					dataIndex : 'batInfo',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'manf',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'qty',
					width : 50,
					align : 'right',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'uomDesc',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : "����(��װ��λ)",
					dataIndex : 'rp',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "���۽��",
					dataIndex : 'rpAmt',
					width : 80,
					align : 'right',
					sortable : true
				},{
					header : "���ŵ���",
					dataIndex : 'indsNo',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'dispDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "����ʱ��",
					dataIndex : 'dispTime',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "���쵥��",
					dataIndex : 'dsrqNo',
					width : 140,
					align : 'left',
					sortable : true
				}
		]);
		DetailCm.defaultSortable = false;
		
		// ����·��
		var DetailUrl = DictUrl
					+ 'sublocmatstataction.csp?actiontype=LocUserMatStat';
		// ͨ��AJAX��ʽ���ú�̨����
		var DetailProxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// ָ���в���
		var fieldsDetail = ["pointer","trType","inci","inciCode","inciDesc","spec","manf","batInfo",
				{name:"qty",convert:Negative},
				"uomDesc","rp",
				{name:"rpAmt",convert:Negative},
				"dispDate","dispTime","receiver","indsNo","dsrqNo","dsrqDate"
			];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var DetailReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fieldsDetail
				});
		// ���ݼ�
		var DetailStore = new Ext.data.Store({
					proxy : DetailProxy,
					reader : DetailReader,
					baseParams:{
						ExcludeAlloted:1	//�����Ѿ��������䵥������
					}
				});
				
		var DetailGrid = new Ext.ux.GridPanel({
					id : 'DetailGrid',
					region:'center',
					title:'������ϸ',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : DetailSm,
					loadMask : true				
				});
		
		function Negative(v,rec){
			return -parseFloat(v);
		}
		
		
		var nmAllot = new Ext.grid.RowNumberer();
		var AllotCm = new Ext.grid.ColumnModel([nmAllot, {
					header : "�����id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "���ʴ���",
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'InciDesc',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "������(����)",
					dataIndex : 'AllotRpAmt',
					width : 90,
					align : 'right',
					sortable : true
				},{
					header : "������(�ۼ�)",
					dataIndex : 'AllotSpAmt',
					width : 90,
					align : 'right',
					hidden : true,
					sortable : true
				}, {
					header : "������ϸrowid",
					dataIndex : 'IndsiStr',
					width : 90,
					align : 'left',
					sortable : true,
					hidden : true
				}
		]);
		AllotCm.defaultSortable = false;
		
		var AllotStore = new Ext.data.JsonStore({
			autoDestroy: true,
			url : '',
			fields : ["inci","AllotValue","AllotRpAmt","IndsiStr"]
		});

		var AllotGrid = new Ext.ux.GridPanel({
			id : 'AllotGrid',
			region:'west',
			width:700,
			title:'רҵ�鹫֧��ϸ',
			cm : AllotCm,
			store : AllotStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel(),
			loadMask : true				
		});

		function addNewAllotRow() {
			var AllotRecord = Ext.data.Record.create([
				{
					name : 'inci',
					type : 'int'
				},{
					name : 'InciCode',
					type : 'string'
				}, {
					name : 'InciDesc',
					type : 'string'
				}, {
					name : 'AllotRpAmt',
					type : 'double'
				}, {
					name : 'IndsiStr',
					type : 'string'
				}
			]);
							
			var AllotRecord = new AllotRecord({
				inci:'',
				InciCode:'',
				InciDesc:'',
				UomId:'',
				Uom:'',
				AllotRpAmt:'',
				IndsiStr:''
			});
				
			AllotStore.add(AllotRecord);
			AllotGrid.getSelectionModel().selectRow(AllotStore.getCount()-1,true); 
		}
		
		var nmScale = new Ext.grid.RowNumberer();
		var ScaleCm = new Ext.grid.ColumnModel([
				nmScale, {
					header : "��Աid",
					dataIndex : 'UserId',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "��Ա",
					dataIndex : 'UserName',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "����Ȩ��",
					dataIndex : 'ScaleValue',
					width : 140,
					align : 'right',
					sortable : true,
					editable : true,
					editor : new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : false,
						allowNegative : false
					})
				}
		]);
		ScaleCm.defaultSortable = false;
		
		var ScaleStore = new Ext.data.JsonStore({
			autoDestroy: true,
			url : DictUrl + 'sublocgrpallotaction.csp?actiontype=GetGroupUser',
			fields : ["UserId","UserName","ScaleValue","ScaleRpAmt","ScaleSpAmt"],
			root:'rows'
		});
		
		var ScaleGrid = new Ext.ux.EditorGridPanel({
			id : 'ScaleGrid',
			region:'center',
			title:'רҵ�鹫֧Ȩ��',
			cm : ScaleCm,
			store : ScaleStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel(),
			loadMask : true,
			clicksToEdit : 1
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			id : 'HisListTab',
			title: 'רҵ�鷢�����ݷ���',
			tbar : [SearchBT, '-', ClearBT, '-', SaveBT],
			items:[{
				xtype : 'fieldset',
				title : '���䵥��Ϣ',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults:{border:false,columnWidth:0.25,xtype:'fieldset'},
				items:[{
						items:[PhaLoc,ToPhaLoc]
					},{
						items:[StkGrpType,UserGroup]
					},{
						items:[StartDate,EndDate]
					},{
						items:[AllotMon]
					}]
			}]
		});
		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab,MasterGrid,DetailGrid,{
					region : 'south',
					height : gGridHeight,
					layout : 'border',
					items:[AllotGrid,ScaleGrid]
				}
				
			],
			renderTo : 'mainPanel'
		});
	}
})
///��ʾ��Ҫ����������ҽ������Ϣ
///2017-04-13 lihui
///

var arcinfoWin="";
GetArcforLinkInci=function(Fn){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	///���Ƶ����򿪶��
	var garcinfoWindowFlag = typeof(garcinfoWindowFlag)=='undefined'?false:garcinfoWindowFlag;
	if(arcinfoWin){
	   arcinfoWin.show();
	   return;
	}
	if(garcinfoWindowFlag){
		return;
	}
	var ArcinfoUrl='dhcstm.showarcinfoforlinkinci.csp?actiontype=GetArcInfo';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : ArcinfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["ArcitmId","ArcCode","ArcDesc","BillUomId","BillUomDesc","ArcSubCatId","ArcSubCat",
	              "BillCat","BillSubCatId","BillSubCat","OwnFlag","PriorId","Priority","WoStock",
	              "InsuDesc","SX","OeMessage","EffDate","EffDateTo","OrdCat","OrdCatId","ArcAlias",
	              "scDr","scDesc","acDr","acDesc","mcDr","mcDesc","icDr","icDesc","ocDr","ocDesc","ecDr","ecDesc",
	              "tariCode","tariDesc","feeFlag","newmcDr","newmcDesc","TarPrice"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "ArcitmId",
		fields : fields
	});
	// ���ݼ�
	var ArcinfoStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader,
		remoteSort: true,
		listeners : {
				load : function(store, records, options){
					if(records.length > 0){
						sm.selectFirstRow();
					}
				}
			}
	});
	
	var nm = new Ext.grid.RowNumberer();
	var sm =new Ext.grid.CheckboxSelectionModel({singleSelect:true});
	var ArcinfoCm = new Ext.grid.ColumnModel([nm,sm,
		{
		    header : "Arcid",
			dataIndex : 'ArcitmId',
			width : 80,
			align : 'left',
			hidden:true
		},{
			
			header : "ҽ������",
			dataIndex : 'ArcCode',
			width : 80,
			align : 'left',
			sortable : true
	    },{
		    header : "ҽ������",
			dataIndex : 'ArcDesc',
			width : 80,
			align : 'left',
			sortable : true 
		},{
			header : "�Ƽ۵�λ",
			dataIndex : 'BillUomDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "�ۼ�",
			dataIndex : 'TarPrice',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "ҽ������",
			dataIndex : 'OrdCat',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "ҽ������",
			dataIndex : 'ArcSubCat',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "���ô���",
			dataIndex : 'BillCat',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "��������",
			dataIndex : 'BillSubCat',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "����ҽ��",
			dataIndex : 'OwnFlag',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "ҽ�����ȼ�",
			dataIndex : 'Priority',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "�޿��ҽ��",
			dataIndex : 'WoStock',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "ҽ������",
			dataIndex : 'InsuDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "��д",
			dataIndex : 'SX',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "ҽ����ʾ",
			dataIndex : 'OeMessage',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "��Ч����",
			dataIndex : 'EffDate',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "��ֹ����",
			dataIndex : 'EffDateTo',
			width : 80,
			align : 'left',
			//hidden:true,
			sortable : true
		},{
			header : "�շ��ӷ���",
			dataIndex : 'scDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "�����ӷ���",
			dataIndex : 'ocDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "�����ӷ���",
			dataIndex : 'ecDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "������ҳ�ӷ���",
			dataIndex : 'mcDesc',
			width : 100,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "����ӷ���",
			dataIndex : 'acDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "�²�����ҳ�ӷ���",
			dataIndex : 'newmcDesc',
			width : 110,
			align : 'left',
			hidden:true,
			sortable : true
		}]);
	
   var ArcinfoToolbar = new Ext.PagingToolbar({
			store:ArcinfoStore,
			pageSize:PageSize,
			id:'ArcinfoToolbar',
			displayInfo:true
	});
	
	//ѡȡ
	var retBT = new Ext.Toolbar.Button({
				text : 'ѡȡ',
				tooltip : 'ȷ��ѡȡ',
				iconCls : 'page_goto',
				handler : function() {
					returnArcinfoData();
				}
			});
	function returnArcinfoData(){
	         var selectrow=ArcinfoGrid.getSelectionModel().getSelected();
	         var Arcid=selectrow.get("ArcitmId");
	         var linkedarc=tkMakeServerCall("web.DHCSTM.ShowArcinfoForlinkInci","IfLinkInci",Arcid);
	         if (linkedarc=="Y")
	         {
		         Msg.info("warning","��ҽ���Ѿ����ڹ����Ŀ����,����ϵ����Ա����!");
		         return;
		     }
	         if (selectrow.length == 0) {
				Msg.info("warning", "��ѡ��Ҫ���ص�ҽ����Ϣ��");
			} else {
			    Fn(selectrow);
			    arcwindow.hide();
			}
	}		
	
	//�ر�
	var closBT =new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '����ر�',
		iconCls : 'page_delete',
		handler : function() {
			if (Ext.getCmp('arcwindow')){
				Ext.getCmp('arcwindow').close();
			}
		}
	});
	//ҽ������
	var Arccode= new Ext.form.TextField({
		fieldLabel : 'ҽ������',
		id : 'Arccode',
		name : 'Arccode',
		anchor : '90%',
		valueNotFoundText : ''
	});
	//ҽ������
	var Arcdesc= new Ext.form.TextField({
		fieldLabel : 'ҽ������',
		id : 'Arcdesc',
		name : 'Arcdesc',
		anchor : '90%',
		valueNotFoundText : ''
	});
	//ҽ������
	var Arcordc= new Ext.ux.ComboBox({
		fieldLabel : 'ҽ������',
		id : 'Arcordc',
		name : 'Arcordc',
		store : OrderCategoryStore,
		valueField : 'RowId',
		displayField : 'Description',
		childCombo : ['Arccat']
	});
	//ҽ������
	var Arccat= new Ext.ux.ComboBox({
		fieldLabel : 'ҽ������',
		id : 'Arccat',
		name : 'Arccat',
		store : ArcItemCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc',
		params:{OrderCat:'Arcordc'}  //ArcordcΪҽ�������id
	});
	
	//��ѯ
	var searchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				arcrefreshGrid();
			}
		});
	//�Ƿ�ֻ��ʾû�й�����������Ϣ
	var Nolink = new Ext.form.Checkbox({
			id : 'Nolink',
			hideLabel : true,
			boxLabel : '��δ������ҽ��',
			checked:true
		});
	
	var ArcinfoGrid = new Ext.ux.GridPanel({
		id:'ArcinfoGrid',
		region:'center',
		autoScroll:true,
		cm:ArcinfoCm,
		store:ArcinfoStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,
		//loadMask : true,
		tbar : [retBT, '-', closBT,'ҽ������',Arccode,'ҽ������',Arcdesc,'ҽ������',Arcordc,'ҽ������',Arccat,searchBT,Nolink],
		bbar : ArcinfoToolbar,
		listeners : {
			'rowdblclick' : function() {
				returnArcinfoData();
			},
			'keydown' : function(e) {	// �س��¼�
				if (e.getKey() == Ext.EventObject.ENTER) {
					returnArcinfoData();
				}
			}
		}
	});
	var arcwindow = new Ext.Window({
		title : 'ҽ���շ�����Ϣ',
		id:'arcwindow',
		width : 1050,
		height : 500,
		layout:'border',
		plain : true,
		modal : true,
		buttonAlign : 'center',
		items : [{region:'center',layout:'fit',width:500,split:true,items:ArcinfoGrid}],
		listeners:{
			'show':function(){
				garcinfoWindowFlag=true;	//ͨ��ȫ�ֱ������ƶ��window��ʾ������,closeʱ��Ϊfalse
				arcrefreshGrid();
			},
			'close' : function(panel) {
				arcinfoWin=null;
				garcinfoWindowFlag=false;
			},
			'hide' : function(panel) {
				arcinfoWin=arcwindow;
				garcinfoWindowFlag=false;
			}
		}
	});
	arcwindow.show();
	
	function arcrefreshGrid(){
		var Arccdoe=Ext.getCmp("Arccode").getValue();
		var Arcdesc=Ext.getCmp("Arcdesc").getValue();
		var Arcordc=Ext.getCmp("Arcordc").getValue();
		var Arccat=Ext.getCmp("Arccat").getValue();
		var nolinkflag=Ext.getCmp("Nolink").getValue()?"Y":"N";
		var Others=Arcordc+"^"+Arccat+"^"+nolinkflag;
		ArcinfoStore.removeAll();
		ArcinfoStore.setBaseParam("arccdoe",Arccdoe);
		ArcinfoStore.setBaseParam("arcdesc",Arcdesc);
		ArcinfoStore.setBaseParam("others",Others);
	    ArcinfoStore.load({
			params:{start:0, limit:ArcinfoToolbar.pageSize},
			callback:function(r, options, success){
				if (!success || r.length==0) {
					Msg.info('warning','û���κη��ϵļ�¼��');
					//if(window&&Filter==0){
						//window.hide();
					//}
				} else if(r.length>0) {
					ArcinfoGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
					ArcinfoGrid.getView().focusRow(0);
				}
			}
		});
	}
}
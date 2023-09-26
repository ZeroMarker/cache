 function MCSAItmList(mcsa)
{
	 // //��ѯ����
	 function Query(){    
		 saItmListStore.setBaseParam('mcsa',mcsa);
		 saItmListStore.removeAll();
		 
		 var Page=saItmListPagingToolbar.pageSize;
		 saItmListStore.load({
			 callback:function(r,options,success){
				if(success==false){
					Msg.info("error", "��ѯ������鿴��־!");
				 }else{if(r.length>0){ }}
			 }	 
		 });
	}          

	// ����·��
	var url ='dhcstm.itmmanfcertsaaction.csp?actiontype=mcsaItmList';
	var proxy = new Ext.data.HttpProxy({
		url : url,
		method : "POST"
	});
	
	// ָ���в���
	var fields = [ "inci", "code","desc", "uomDesc", "spec","manf", "rp","sp", "remark"];
	
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "rowid",
		fields : fields
	});
			
	// ���ݼ�
	var saItmListStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	
	var nm = new Ext.grid.RowNumberer();
	var chkSm=new Ext.grid.CheckboxSelectionModel({});
	var saItmListCm = new Ext.grid.ColumnModel([nm,chkSm,
		{
			header : "����RowId",
			dataIndex : 'inci',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'code',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'desc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : "���",
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "��λ",
			dataIndex : 'uomDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "����",
			dataIndex : 'rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "�ۼ�",
			dataIndex : 'sp',
			width : 60,
			align : 'right',
			sortable : true
		}
	]);
			
	var saItmListPagingToolbar = new Ext.PagingToolbar({
		store:saItmListStore,
		pageSize:999,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});

	var saItmListGrid = new Ext.grid.GridPanel({
		id : 'mcsaItmListGrid',
		region : 'center',
		// title : '�б�',
		cm : saItmListCm,
		store : saItmListStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:saItmListPagingToolbar,
		// sm : new Ext.grid.RowSelectionModel({singleSelect:true})
		sm:chkSm
			
	});
	
	var addItm=new Ext.Toolbar.Button({
		text:'�������ʵ���',
		iconCls:'page_add',
		handler:function(){
			SelectItmToAdd(addItmToSa);
		}	
	});
	var changeSaButton=new Ext.Toolbar.Button({
		text:'������',
		iconCls:'page_gear',
		handler:function(){
			changeSa(changeSaOfItm);
		}
		
	}); 
	
	function addItmToSa(inciS)
	{
		if (mcsa=="") return;
		Ext.Ajax.request({
			url:'dhcstm.itmmanfcertsaaction.csp?actiontype=changeSaOfItm',
			params:{inciS:inciS,sa:mcsa},
			method:'POST',
			success:function()
			{
				Msg.info('success','��ӳɹ���');
				Ext.getCmp('mcsaItmListGrid').getStore().reload();		
				
			},
			failure:function(){}
		})
	}
	
	function changeSaOfItm(sa)
	{
		if (sa=="") return;
		var sm=Ext.getCmp('mcsaItmListGrid').getSelectionModel();
		var arr=sm.getSelections();
		if (arr.length<1)
		{
			Msg.info('error','��ѡ��!');
			return;
		}
		var inciS="";
		for (var i=0;i<arr.length;i++)
		{
			 var r=arr[i];
			var inci=r.get('inci');
			
			if (inciS=="")	{inciS=inci;}
			else { inciS=inciS+"^"+inci;}
		}
		if (inciS==""){Msg.info('error','��ѡ��!');
			return;}
		
		Ext.Ajax.request({
			url:'dhcstm.itmmanfcertsaaction.csp?actiontype=changeSaOfItm',
			params:{inciS:inciS,sa:sa},
			method:'POST',
			success:function()
			{
				Msg.info('success','�����ɹ���');
				Ext.getCmp('mcsaItmListGrid').getStore().reload();			
			},
			failure:function(){}
			
		})
		
	}
	
	var closeWin=new Ext.Toolbar.Button({
		text:'�ر�',
		iconCls:'page_delete',
		handler:function(){
			Ext.getCmp('saItmListWin').close();
		}
		
	});
	
	var saItmListWin=new Ext.Window({
		title:'����Ʒ���б�',
		id:'saItmListWin',
		width:950,
		height:560,
		minWidth:700,
		minHeight:500,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		tbar:[addItm,'-',changeSaButton,'-',closeWin],
		items:[saItmListGrid],
		resizable:false,
		listeners:{
		'show':function(){
			
			Query();
			
			}	
			
		}
	});
	if (saItmListWin) {
		saItmListWin.show();
	}
	
}


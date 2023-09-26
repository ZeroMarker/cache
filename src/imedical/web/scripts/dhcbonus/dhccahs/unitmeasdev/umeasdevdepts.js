measDevDeptsFun = function(dataStore,grid,pagingTool,unitSelecter,dataItemSelecter) {	
	
	var unitDr=unitSelecter.getValue();
	if(unitDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��λ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	var dataItemDr=dataItemSelecter.getValue();
	if(dataItemDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var tmpId="";
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		tmpId = rowObj[0].get("rowId"); 
	}
	//alert(tmpId);
	
	var unitMeasDevRowid = tmpId;
	
	/////////////////////////////////////////////////////////////////////////
	var unitsUrl = 'dhc.ca.unitsexe.csp';
	var unitMeasDevUrl = 'dhc.ca.unitmeasdevexe.csp';
	var measDevDeptsUrl = 'dhc.ca.measdevdeptsexe.csp';
	
	var measDevDeptsDs = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({url: measDevDeptsUrl + '?action=list&unitMeasDevDr='+tmpId}),
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'rowId',
							'deptDr',
							'rate',
							'inputPersonDr',
							'deptCode',
							'deptName',
							'inputPersonName'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	
	measDevDeptsDs.setDefaultSort('rowId', 'Desc');
	
	function formatDate(value){
	    return value ? value.dateFormat('Y-m-d') : '';
	};
	
	var measDevDeptsCm = new Ext.grid.ColumnModel([
		 	new Ext.grid.RowNumberer(),
		 	{
	    		header: '���Ŵ���',
	        dataIndex: 'deptCode',
	        width: 200,
	        align: 'left',
	        sortable: true
	    },
		 	{
	    		header: '��������',
	        dataIndex: 'deptName',
	        width: 200,
	        align: 'left',
	        sortable: true
	    },
	    {
	        header: "����",
	        dataIndex: 'rate',
	        width: 60,
	        align: 'left',
	        sortable: true
	    },
	    {
	        header: "¼����",
	        dataIndex: 'inputPersonName',
	        width: 150,
	        align: 'left',
	        sortable: true
	    }
	]);
	
	//StatuTabCm.defaultSortable = true;
	
	var addMeasDevDeptsButton = new Ext.Toolbar.Button({
			text: '���',
	    tooltip:'�������Ϣ',        
	    iconCls:'add',
			handler: function(){
				if(unitMeasDevRowid==""){
					Ext.Msg.show({title:'ע��',msg:'��ѡ��λ������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				else
				{
					addMeasDevDeptsFun(measDevDeptsDs,formPanel,measDevDeptsPagingToolbar,unitMeasDevRowid,unitDr,tmpId);
				}
			}
	});
	
	var editMeasDevDeptsButton  = new Ext.Toolbar.Button({
			text:'�޸�',        
			tooltip:'�޸�ѡ���ļ��������Ϣ',
			iconCls:'remove',        
			handler: function(){
				if(unitDr==""){
					Ext.Msg.show({title:'ע��',msg:'��ѡ��λ���޸ļ��������Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}
				else
				{
					editMeasDevDeptsFun(measDevDeptsDs,formPanel,measDevDeptsPagingToolbar,unitMeasDevRowid,unitDr,tmpId);
				}
			}
	});
	
	var delMeasDevDeptsButton  = new Ext.Toolbar.Button({
			text: 'ɾ��',        
			tooltip: 'ɾ��ѡ���ļ������',
			iconCls: 'remove',
			//disabled: true,
			handler: function(){delMeasDevDeptsFun(measDevDeptsDs,formPanel,measDevDeptsPagingToolbar,tmpId);}
	});
	
		var measDevDeptsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
	  	pageSize: 25,
			store: measDevDeptsDs,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg: "û������",
			doLoad:function(C){
				var B={},
				A=this.paramNames;
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B['parRef']=tmpId;
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}
		});
	
	var formPanel = new Ext.grid.GridPanel({
			store: measDevDeptsDs,
			cm: measDevDeptsCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			//tbar:[addMeasDevDeptsButton,'-',editMeasDevDeptsButton,'-',delMeasDevDeptsButton],
			bbar: measDevDeptsPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '������Ʋ���ά��',
			width: 700,
			height:500,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				{
					text: 'ȡ��',
					handler: function(){window.close();}
				}]
			});

			window.show();
			measDevDeptsDs.load({params:{start:0, limit:measDevDeptsPagingToolbar.pageSize,parRef:tmpId}});
	
};
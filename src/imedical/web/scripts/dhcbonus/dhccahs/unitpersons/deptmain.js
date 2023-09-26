CommFindFun = function(dataStore,grid,pagingTool) {
	var unitDr=units.getValue();
	if(unitDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��Ԫ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		tmpId = rowObj[0].get("rowid"); 
	}
	
	var tmpUId="";
	var PersonDeptsTabProxy = new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=listdept'});
	var tmpMonth="";

	var PersonDeptsTabDs = new Ext.data.Store({
		proxy: PersonDeptsTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
		'rowid',
		'parRef',
		'deptDr',
		'deptCode',
		'deptName',
		'rate',
		'inputPersonDr',
		'inputPersonName',
		'own'
		]),
		remoteSort: true
	});

	PersonDeptsTabDs.setDefaultSort('RowId', 'Desc');

	
	
	var adddeptButton  = new Ext.Toolbar.Button({
		text: '���Ӳ���',        
		tooltip: '���ӵ�λ��Ա�Ĳ���',
		iconCls: 'remove',
		handler: function(){addDeptFun(PersonDeptsTabDs,formPanel,PersonDeptsTabPagingToolbar,tmpId);}
	});
	
	var editdeptButton  = new Ext.Toolbar.Button({
		text: '�޸Ĳ���',        
		tooltip: '�޸ĵ�λ��Ա�Ĳ���',
		iconCls: 'remove',
		handler: function(){editDeptFun(PersonDeptsTabDs,formPanel,PersonDeptsTabPagingToolbar,tmpId);}
	});
	
var deldeptButton  = new Ext.Toolbar.Button({
	text:'ɾ������',
	tooltip:'ɾ��ѡ���ĵ�λ��Ա����',
	iconCls:'remove',
	handler: function(){
		var rowObj = formPanel.getSelections();
		var len = rowObj.length;
		var myId = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
			
			Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				     myId = rowObj[0].get("rowid");
				Ext.Ajax.request({
					url:'dhc.ca.unitpersonsexe.csp?action=del&id='+myId,
					waitMsg:'ɾ����...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							PersonDeptsTabDs.load({params:{start:PersonDeptsTabPagingToolbar.cursor, limit:PersonDeptsTabPagingToolbar.pageSize,parRef:tmpId}});
							//___________________________________________________
									Ext.Ajax.request({
										url: UnitPersonsUrl+'?action=percent&id='+parRef,
										waitMsg:'������...',
										failure: function(result, request) {
											Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											var percent=jsonData.info;
											if (jsonData.success=='true') {
												if(percent!=100){
													Ext.Msg.show({title:'ע��',msg:'������Ϊ100%�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
												}
												
											}
											else
											{
												var message = "";
												message = "SQLErr: " + jsonData.info;
												if(jsonData.info=='RepDept') message='����Ĵ����Ѿ�����!';
												Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
									scope: this
									});
									//___________________________________________________
						}
						else
							{
								var message="";
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});   	
			    }
		    } 
		)
				//--------------------------------------------------------------------------------------
				
				
			}
		});
	var actionButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip:'ͨ��������������',
		iconCls:'add',
		handler: function(){
			if (Ext.getCmp('monName').getValue()!="") {
				var tmpDate="";
				if(Ext.getCmp('bDate').getValue()!=""){
					tmpDate=Ext.getCmp('bDate').getValue().format('Y-m-d');
				}
				tmpMonth=Ext.getCmp("monName").getValue();
				PersonDeptsTabDs.proxy=new Ext.data.HttpProxy({url:'../csp/dhccacommtab.csp?action=find',method:'GET'});
				//20090612
				tmpUId=(persons.getValue()==true)?"":userId;
				PersonDeptsTabDs.load({params:{start:0, limit:PersonDeptsTabPagingToolbar.pageSize, userid:tmpUId, busitemdr:Ext.getCmp('itemName').getValue(), servedloc:Ext.getCmp('servedLocName').getValue(),monthdr:Ext.getCmp('monName').getValue(),bdate:tmpDate,servloc:roleLocId}});
				}else{
					Ext.Msg.show({title:'����',msg:'�·�Ϊ��ѡ��,��ѡ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		});

	var PersonDeptsTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '���Ŵ���',
			dataIndex: 'deptCode',
			width: 70,
			sortable: true
		},
		{
			header: '��������',
			dataIndex: 'deptName',
			width: 150,
			sortable: true
		},
		{
			header: '����',
			dataIndex: 'rate',
			width: 100,
			sortable: true
		},
		{
			header: '¼����',
			dataIndex: 'inputPersonName',
			width: 100,
			sortable: true
		},
		{
			header: "��������",
			dataIndex: 'own',
			width: 60,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td'; 
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);


		
		var PersonDeptsTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
			pageSize: 25,
			store: PersonDeptsTabDs,
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


		//==========================================================���==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: PersonDeptsTabDs,
			cm: PersonDeptsTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[adddeptButton,'-',editdeptButton,'-',deldeptButton],
			bbar: PersonDeptsTabPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '��Ա����ά��',
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
			PersonDeptsTabDs.load({params:{start:0, limit:PersonDeptsTabPagingToolbar.pageSize,parRef:tmpId}});
		};
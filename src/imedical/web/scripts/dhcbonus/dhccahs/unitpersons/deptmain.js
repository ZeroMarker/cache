CommFindFun = function(dataStore,grid,pagingTool) {
	var unitDr=units.getValue();
	if(unitDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择单元后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var tmpId="";
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		text: '增加部门',        
		tooltip: '增加单位人员的部门',
		iconCls: 'remove',
		handler: function(){addDeptFun(PersonDeptsTabDs,formPanel,PersonDeptsTabPagingToolbar,tmpId);}
	});
	
	var editdeptButton  = new Ext.Toolbar.Button({
		text: '修改部门',        
		tooltip: '修改单位人员的部门',
		iconCls: 'remove',
		handler: function(){editDeptFun(PersonDeptsTabDs,formPanel,PersonDeptsTabPagingToolbar,tmpId);}
	});
	
var deldeptButton  = new Ext.Toolbar.Button({
	text:'删除部门',
	tooltip:'删除选定的单位人员部门',
	iconCls:'remove',
	handler: function(){
		var rowObj = formPanel.getSelections();
		var len = rowObj.length;
		var myId = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
			
			Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				     myId = rowObj[0].get("rowid");
				Ext.Ajax.request({
					url:'dhc.ca.unitpersonsexe.csp?action=del&id='+myId,
					waitMsg:'删除中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							PersonDeptsTabDs.load({params:{start:PersonDeptsTabPagingToolbar.cursor, limit:PersonDeptsTabPagingToolbar.pageSize,parRef:tmpId}});
							//___________________________________________________
									Ext.Ajax.request({
										url: UnitPersonsUrl+'?action=percent&id='+parRef,
										waitMsg:'保存中...',
										failure: function(result, request) {
											Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											var percent=jsonData.info;
											if (jsonData.success=='true') {
												if(percent!=100){
													Ext.Msg.show({title:'注意',msg:'比例不为100%请调整!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
												}
												
											}
											else
											{
												var message = "";
												message = "SQLErr: " + jsonData.info;
												if(jsonData.info=='RepDept') message='输入的代码已经存在!';
												Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
									scope: this
									});
									//___________________________________________________
						}
						else
							{
								var message="";
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		text: '搜索',
		tooltip:'通过条件进行搜索',
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
					Ext.Msg.show({title:'错误',msg:'月份为必选项,请选择!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		});

	var PersonDeptsTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '部门代码',
			dataIndex: 'deptCode',
			width: 70,
			sortable: true
		},
		{
			header: '部门名称',
			dataIndex: 'deptName',
			width: 150,
			sortable: true
		},
		{
			header: '比率',
			dataIndex: 'rate',
			width: 100,
			sortable: true
		},
		{
			header: '录入人',
			dataIndex: 'inputPersonName',
			width: 100,
			sortable: true
		},
		{
			header: "行政归属",
			dataIndex: 'own',
			width: 60,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td'; 
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);


		
		var PersonDeptsTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
			pageSize: 25,
			store: PersonDeptsTabDs,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}',
			emptyMsg: "没有数据",
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


		//==========================================================面板==========================================================
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
			title: '人员部门维护',
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
					text: '取消',
					handler: function(){window.close();}
				}]
			});

			window.show();
			PersonDeptsTabDs.load({params:{start:0, limit:PersonDeptsTabPagingToolbar.pageSize,parRef:tmpId}});
		};
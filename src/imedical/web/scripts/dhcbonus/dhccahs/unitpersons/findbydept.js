personFindFun = function(dataStore,grid,pagingTool) {
	var unitDr=units.getValue();
	if(unitDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择单元后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	function formatDate(value){
	//alert(value);
		return value?value.dateFormat('Y-m-d'):'';
	};
	var ownFlag=""
	var PersonDeptsTabProxy = new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=list'});

	var PersonDeptsTabDs = new Ext.data.Store({
		proxy: PersonDeptsTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
		   'rowid',
			'code',
			'name',
			'shortcut',
			'gender',
			'national',
			'birthPlace',
			'education',
			'title',
			'duty',
			'state',
			'preparation',
			'phone',
			'remark',
			{name:'birthday',type:'date',dateFormat:'Y-m-d'},
			{name:'start',type:'date',dateFormat:'Y-m-d'},
			{name:'stop',type:'date',dateFormat:'Y-m-d'},
			'unitDr',
			'unitName',
			'active'
		]),
		remoteSort: true
	});

	PersonDeptsTabDs.setDefaultSort('RowId', 'Desc');

	var unitDr=units.getValue();
	
	var deptDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var dept = new Ext.form.ComboBox({
		id: 'dept',
		fieldLabel: '部门',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: deptDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择部门...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	deptDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=dept&searchValue='+Ext.getCmp('dept').getRawValue()+'&unitDr='+unitDr,method:'GET'});
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
			header: '代码',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '名称',
			dataIndex: 'name',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: '性别',
			dataIndex: 'gender',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: "出生日期",
			dataIndex: 'birthday',
			renderer:formatDate,
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: '民族',
			dataIndex: 'national',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: '籍贯',
			dataIndex: 'birthPlace',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: '学历',
			dataIndex: 'education',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: '职称',
			dataIndex: 'title',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: '职务',
			dataIndex: 'duty',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: '状态',
			dataIndex: 'state',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: '编制',
			dataIndex: 'preparation',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: '电话',
			dataIndex: 'phone',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: '备注',
			dataIndex: 'remark',
			width: 80,
			align: 'left',
			sortable: true
		},
		{
			header: "入职日期",
			dataIndex: 'start',
			renderer:formatDate,
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: "离职日期",
			dataIndex: 'stop',
			renderer:formatDate,
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: "单位名称",
			dataIndex: 'unitName',
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: '有效标志',
			dataIndex: 'active',
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
				B['id']=unitDr;
				B['type']=dept.getValue();
				B['ownFlag']=ownFlag;
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}

		});

		var showButton = new Ext.form.Checkbox({
			boxLabel: '行政归属',
			fieldLabel: '行政归属',
			checked: false
		});
		showButton.on("check",function(ds){
			if(dept.getValue()==""){
				Ext.Msg.show({title:'错误',msg:'请选择部门后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(showButton.getValue()){
				ownFlag="Y";
				PersonDeptsTabDs.load({params:{start:0, limit:PersonDeptsTabPagingToolbar.pageSize,id:unitDr,type:dept.getValue(),ownFlag:ownFlag}});
			}
			else{
				ownFlag="N";
				PersonDeptsTabDs.load({params:{start:0, limit:PersonDeptsTabPagingToolbar.pageSize,id:unitDr,type:dept.getValue(),ownFlag:ownFlag}});
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
			tbar:["部门:",dept,'-',showButton],
			bbar: PersonDeptsTabPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '查看部门人员',
			width: 900,
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
			dept.on("select",function(cmb,rec,id ){
					PersonDeptsTabDs.load({params:{start:0, limit:PersonDeptsTabPagingToolbar.pageSize,id:unitDr,type:cmb.getValue(),ownFlag:ownFlag}});
			});
			
		};
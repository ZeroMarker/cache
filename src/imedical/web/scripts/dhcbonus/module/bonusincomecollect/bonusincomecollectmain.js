//年月
	var yearmonth = new Ext.form.DateField({
		fieldLabel: '年月',
		name: 'yearmonth',
		width: 110,
		listWidth : 180,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
		// ,
	});
//	科室
var deptDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomecollectexe.csp'
								+ '?action=getDept&str='
								+ encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()),
						method : 'POST'
					})
		});

var deptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '科室',
			width : 100,
			listWidth : 285,
			//allowBlank : false,
			store : deptDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'deptCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
		
//
//	收费类别
var tariffTypeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

tariffTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomecollectexe.csp'
								+ '?action=getTariffType&str='
								+ encodeURIComponent(Ext.getCmp('tariffTypeCombo').getRawValue()),
						method : 'POST'
					})
		});

var tariffTypeCombo = new Ext.form.ComboBox({
			id : 'tariffTypeCombo',
			fieldLabel : '收费类别',
			width : 100,
			listWidth : 285,
			//allowBlank : false,
			store : tariffTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'tariffTypeCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
		
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'option',
			handler : function() {
				var myyearmonth,deptcode,tariffType;
				if (yearmonth!=undefined){
				myyearmonth = yearmonth.getValue();
				if (myyearmonth!=""){
				myyearmonth=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				}
				}
					
				if (deptCombo!=undefined){	
				deptcode = deptCombo.getValue();
				}
				if (tariffTypeCombo!=undefined){
				tariffType = tariffTypeCombo.getValue();
				}
				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode,
								tariffType : tariffType
							}
						});

			}
			
		});
		
var collectbutton = new Ext.Toolbar.Button(
		{
			text : '数据采集',
			tooltip : '数据采集',
			iconCls : 'option',
			handler : function() {  
				var myyearmonth = yearmonth.getValue();	
				if (myyearmonth==""){
				Ext.Msg.show({title:'注意',msg:'请选择年月!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
				var indate=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				//var enddate=myyearmonth.getLastDateOfMonth().format("Y-m-d");
				var progressBar = Ext.Msg.show({
						title : "数据采集",
						msg : "'正在采集中...",
						width : 300,
						wait : true,
						closable : true
					});
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincomecollectexe.csp?action=collect&date='+indate,
				waitMsg:'采集中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'采集成功！',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : indate
								
							}
						});	
				}
				},
				scope: this
				});
			}
});

var importButton = new Ext.Toolbar.Button({
					text : 'Excel导入',
					tooltip : 'Excel数据导入',
					iconCls : 'option',
					handler : function() {
						importExcel();
					}
				})
var itemGrid = new dhc.herp.Grid({
        title: '原始收入数据查询',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusincomecollectexe.csp',	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{

		     id:'rowid',
		     header: 'rowid',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'bonusyear',
		     header: '所属年月',
		     allowBlank: true,
		     width:80,
		     editable:false,
		     dataIndex: 'bonusyear'
		}, {
		     id:'incomeitemcode',
		     header: '收入项目',
		     allowBlank: true,
		     width:110,
		     editable:false,
		     dataIndex: 'incomeitemcode'
		}, {
		     id:'bonusperiod',
		     header: '奖金期间',
		     allowBlank: true,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'bonusperiod'
		}, {
		     id:'makebilldeptcode',
		     header: '开单科室',
		     allowBlank: true,
		     width:120,
		     editable:false,
		     dataIndex: 'makebilldeptcode'
		}, {
		     id:'executedeptcode',
		     header: '执行科室',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'executedeptcode'
		}, {
		     id:'sickdeptcode',
		     header: '病人科室',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'sickdeptcode'
		}, {
		     id:'sicktype',
		     header: '病人类型',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'sicktype'
		}, {
		     id:'chiefdoctorcode',
		     header: '主治医师',
		     allowBlank: true,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'chiefdoctorcode'
		}, {
		     id:'makebilldoctorcode',
		     header: '开单医生',
		     allowBlank: true,
		     hidden:true,
		     width:100,
		     editable:false,
		     dataIndex: 'makebilldoctorcode'
		}, {
		     id:'executedoctorcode',
		     header: '执行医生',
		     allowBlank: true,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'executedoctorcode'
		}, {
		     id:'incomemoney',
		     header: '金额',
		     allowBlank: true,
		     width:80,
		     align:'right',
		     editable:true,
		     dataIndex: 'incomemoney'
		}, {
		     id:'state',
		     header: '数据状态',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'state'
		}, {
		     id:'updatedate',
		     header: '采集时间',
		     allowBlank: true,
		     width:130,
		     editable:false,
		     dataIndex: 'updatedate'
		}],
        
        tbar:['年月:',yearmonth,'科室:',deptCombo,'收费类别:',tariffTypeCombo,findButton,collectbutton,importButton]
        
});

	 	//itemGrid.hiddenButton(); 	//隐藏第n个按钮
		itemGrid.btnAddHide() ;	//隐藏增加按钮
		//itemGrid.btnSaveHide(); //隐藏保存按钮
		itemGrid.btnResetHide(); 	//隐藏重置按钮
		itemGrid.btnDeleteHide(); //隐藏删除按钮
		itemGrid.btnPrintHide() ;	//隐藏打印按钮

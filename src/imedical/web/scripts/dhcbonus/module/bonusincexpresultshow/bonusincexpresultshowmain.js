var userid=session['LOGON.USERNAME'];

//年月
	var yearmonth = new Ext.form.DateField({
		fieldLabel: '年月',
		name: 'yearmonth',
		width: 150,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Ym',
		editable: false,
                  listeners:{'select':function(combo,record,index){
                          deptCombo.setValue("");
                          }} 
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
						url : 'dhc.bonus.module.bonusincexpresultshowexe.csp'
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
			editable : true,
                        listeners:{'select':function(combo,record,index){
                          yearmonth.setValue("");
                          }} 
		});

		

			
var auditbutton = new Ext.Toolbar.Button(
		{
			text : '审核',
			tooltip : '审核',
			iconCls : 'option',
			handler : function() {
				if (yearmonth!=undefined){
				myyearmonth = yearmonth.getValue();
				if (myyearmonth!=""){
				myyearmonth=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				}else{				Ext.Msg.show({title:'主意',msg:'请选择年月!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
				}
				
		         
		        if (deptCombo!=undefined){	
				deptcode = deptCombo.getValue();
				}
				    
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincexpresultexe.csp?action=audit&yearmonth='+myyearmonth+"&user="+userid,
		
				waitMsg:'审核中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'审核成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
											itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode
							}
						});	
				}
				},
				scope: this
				});
			}
});


var calculator = new Ext.Toolbar.Button(
		{
			text : '计算',
			tooltip : '计算',
			iconCls : 'option',
			handler : function() {
				
				if (yearmonth!=undefined){
				myyearmonth = yearmonth.getValue();
				if (myyearmonth!=""){
				myyearmonth=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				}else{				Ext.Msg.show({title:'主意',msg:'请选择年月!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
				}
				
		         
		        if (deptCombo!=undefined){	
				deptcode = deptCombo.getValue();
				}
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincexpresultexe.csp?action=calculator&yearmonth='+myyearmonth+"&user="+userid,
		
				waitMsg:'计算中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'计算成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
									itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode
							}
						});		
				}
				},
				scope: this
				});
			}
		});
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'option',
			handler : function() {

				if (yearmonth!=undefined){
				myyearmonth = yearmonth.getValue();
				if (myyearmonth!=""){
				myyearmonth=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				}
				}
					
				if (deptCombo!=undefined){	
				deptcode = deptCombo.getValue();
				}
                             //调用润乾报表
                              var reportFrame = document.getElementById("frameReport"); 
                              var p_URL = 'dhccpmrunqianreport.csp?reportName=dhcBonusModuleBonusIncExp.raq'
				+'&yearmonth='+myyearmonth+'&deptcode='+deptcode;
                              reportFrame.src=p_URL;
				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode
							}
						});

			}
			
		})
		
var itemGrid = new dhc.herp.Grid({
        title: '收入计算管理',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusincexpresultexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{

		     id:'yearmonth',
		     header: '年月',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'yearmonth'
		}, {
		     id:'deptcode',
		     header: '科室编码',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'deptcode'
		}, {
		     id:'deptname',
		     header: '科室名称',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'deptname'
		}, {
		     id:'myin',
		     header: '收入',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'myin',
 		      renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
			return '<font color="blue" onclick="income(\''+record.data.deptcode+'\',\''+record.data.yearmonth+'\')">'+value+'</blue>';
			
			}
		}, {
		     id:'myout',
		     header: '支出',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'myout',
		      renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
			return '<font color="blue" onclick="expend(\''+record.data.deptcode+'\',\''+record.data.yearmonth+'\')">'+value+'</blue>';
			
			}

		}, {
		     id:'myleave',
		     header: '结余',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'myleave'
		}, {
		     id:'checkdate',
		     header: '审核时间',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'checkdate'
		}, {
		     id:'checkman',
		     header: '审核人',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'checkman'
		}, {
		     id:'state',
		     header: '审核状态',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'state'
		}]
		,
        
        tbar:['年月:',yearmonth,'科室:',deptCombo,findButton/*,calculator,auditbutton*/]
        
});
 //定义修改按钮响应函数
 
		itemGrid.btnAddHide() ;	//隐藏增加按钮
		itemGrid.btnSaveHide(); 	//隐藏保存按钮
		itemGrid.btnResetHide(); 	//隐藏重置按钮
		itemGrid.btnDeleteHide(); //隐藏删除按钮
		itemGrid.btnPrintHide() ;	//隐藏打印按钮
//itemGrid.tbar.push(auditbutton);
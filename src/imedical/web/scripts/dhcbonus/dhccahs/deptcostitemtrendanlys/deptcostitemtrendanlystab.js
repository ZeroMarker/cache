var userCode = session['LOGON.USERCODE'];
var monthCombo = new Ext.ux.form.LovCombo({
	id:'monthCombo',
	fieldLabel: '核算月份',
	hideOnSelect: false,
	store: new Ext.data.Store({
		autoLoad: true,
		proxy: new Ext.data.HttpProxy({url: 'dhc.ca.accountmonthsexe.csp?action=list'}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			id: 'rowid'
		},[
			'rowid',
			'name'
		])
	},[
		'rowid', 'name'
    ]),
	valueField:'rowid',
	displayField:'name',
	typeAhead: false,
	triggerAction: 'all',
	pageSize:10,
	width:200,
	listWidth:200,
	allowBlank: false,
	emptyText:'请选择核算月份...',
	editable:false,
	anchor: '90%'
});

var deptSetComb = new Ext.form.ComboBox({
	id:'deptSetComb',
	fieldLabel: '单元部门',
	hideOnSelect: false,
	store: new Ext.data.Store({
		autoLoad: true,
		proxy: new Ext.data.HttpProxy({url: 'dhc.ca.deptcostitemtrendanlysexe.csp?action=entitydept'}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			id: 'id'
		},[
			'id',
			'shortcut'
		])
	}),
	valueField:'id',
	displayField:'shortcut',
	typeAhead: false,
	triggerAction: 'all',
	pageSize:10,
	width:200,
	listWidth:200,
	allowBlank: false,
	emptyText:'请选择单元部门...',
	editable:false,
	anchor: '90%'
});


var checkButton = new Ext.Toolbar.Button({
	text:'查询',        
	tooltip:'查询',
	iconCls:'add',        
	handler: function(){
		if(monthCombo.getValue()==""){
			Ext.Msg.alert("提示","请选择核算月份");
		}else{
			//准备数据
			Ext.Ajax.request({
				url:'dhc.ca.deptcostitemtrendanlysexe.csp?action=readydatas&monthDrStr='+monthCombo.getValue()+'&deptDr='+deptSetComb.getValue(),
				waitMsg:'正在准备数据...',
				success: function(result,request){	
					Ext.Ajax.request({
						url:'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode,
						waitMsg:'ֽ՚өѯ...',
						success: function(result,request){
							var jsonData = Ext.util.JSON.decode(result.responseText);
							var userInfo=jsonData.info;
							var aaa=encodeURI(encodeURI(userInfo));
							var center = Ext.getCmp('center_panel');
							center.remove('first_center');
							center.add(new Ext.Panel({
								id:'second_center',
								bodyCfg: {
									tag: 'applet',
									archive: 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar',
									code: 'EmbeddedViewerApplet.class',
									codebase: 'http://172.26.201.66:1969/dhccareport/applets',
									cn:[{tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2'},
										{tag: 'param', name: 'scriptable', value: 'false'},
										{tag: 'param', name: 'REPORT_URL', value: '../deptcostitemtrendanlys?userInfo='+aaa+'&outType=print'+'&deptDr='+deptSetComb.getValue()}
									]
								}
							}));
							center.getLayout().setActiveItem('second_center');
							center.doLayout();
						}
					});
				}
	    	});
		}
	}
});

var excelButton = new Ext.Toolbar.Button({
	text:'生成excel',        
	tooltip:'生成excel',
	iconCls:'add',        
	handler: function(){ 
		if(monthCombo.getValue()==""){
			Ext.Msg.alert("提示","请选择核算月份");
		}else{
			var userCode = session['LOGON.USERCODE'];
			//准备数据
			Ext.Ajax.request({
				url:'dhc.ca.deptcostitemtrendanlysexe.csp?action=readydatas&monthDrStr='+monthCombo.getValue()+'&deptDr='+deptSetComb.getValue(),
				waitMsg:'正在准备数据...',
				success: function(result,request){
					Ext.Ajax.request({
						url:'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode,
						waitMsg:'正在生成...',
						success: function(result,request){
							var jsonData = Ext.util.JSON.decode(result.responseText);
							var userInfo=jsonData.info;
							var aaa=encodeURI(encodeURI(userInfo));
							location.href = 'http://172.26.201.66:1969/dhccareport/deptcostitemtrendanlys?userInfo='+aaa+'&outType=xls'+'&deptDr='+deptSetComb.getValue();
						}
					});
				}
	    	});
	    	
		}
	}
});

var detailReport = new Ext.Panel({
	id:'detailReport',
	layout:'border',
	height:700,
	title:'科室成本项目趋势分析',
	items:[{
		id: 'center_panel',
		region: 'center',
		layout: 'card',
		items: [{id:'first_center',html:''}]
	}],
	tbar:['核算月份:',monthCombo,'-','单元部门（可选）:',deptSetComb,'-',checkButton,'-',excelButton]
});


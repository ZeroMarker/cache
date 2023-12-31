//Menu
var userCode = session['LOGON.USERCODE'];
var monthCombo = new Ext.form.ComboBox({
	id:'monthCombo',
	fieldLabel:'月份',
	store:  new Ext.data.Store({
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
	typeAhead:true,
	pageSize:10,
	minChars:1,
	anchor: '90%',
	width:100,
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择月份...',
	allowBlank: false,
	//name:'deptSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
var monsCombo = new Ext.ux.form.LovCombo({
	id:'monsCombo',
	fieldLabel: '累计月份',
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
	width:100,
	listWidth:250,
	allowBlank: false,
	emptyText:'选择月份...',
	editable:false,
	//allowBlank: false,
	anchor: '90%'
});
var deptSetDs = new Ext.data.Store({
	autoLoad: true,
	proxy:"",                                                        
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','name'])
});

deptSetDs.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.deptsincomereportexe.csp?action=deptlist&id=roo', method:'GET'});
});

var deptSetComb = new Ext.form.ComboBox({
	id:'deptSetComb',
	fieldLabel:'部门分层套',
	store: deptSetDs,
	valueField:'id',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	width:100,
	minChars:1,
	anchor: '90%',
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择部门分层套...',
	allowBlank: false,
	name:'deptSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
deptSetComb.on("select",function(cmb,rec,id ){
	////to do sth
});
var costDistResultDs = new Ext.data.Store({
	autoLoad: true,
	proxy:"",                                                        
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
});

costDistResultDs.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.blanceofpaymentreportexe.csp?action=list&id=roo', method:'GET'});
});

var costDistResultSetComb = new Ext.form.ComboBox({
	id:'costDistResultSetComb',
	fieldLabel:'成本分摊套',
	store: costDistResultDs,
	valueField:'rowid',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	minChars:1,
	width:100,
	anchor: '90%',
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择成本分摊套...',
	allowBlank: false,
	name:'costDistResultSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
costDistResultSetComb.on("select",function(cmb,rec,id ){
	////to do sth
});

var itemSetDs = new Ext.data.Store({
	autoLoad: true,
	proxy:"",                                                        
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','name'])
});

itemSetDs.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listsub&id=roo', method:'GET'});
});

var itemSetComb = new Ext.form.ComboBox({
	id:'itemSetComb',
	fieldLabel:'数据分层套',
	store: itemSetDs,
	valueField:'id',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	minChars:1,
	width:100,
	anchor: '90%',
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择数据分层套...',
	allowBlank: false,
	name:'itemSetComb',
	selectOnFocus: true,
	forceSelection: true 
});


var CalButton = new Ext.Toolbar.Button({
	text:'计算',        
	tooltip:'计算',
	iconCls:'remove',        
	handler: function(){ 
		if((monthCombo.getValue()=="")||(monsCombo.getValue()=="")||(deptSetComb.getValue()=="")||(costDistResultSetComb.getValue()=="")||(itemSetComb.getValue()=="")){
			Ext.Msg.alert("提示","请先选择各项参数");
		}else{
			Ext.Ajax.request({
				url:'dhc.ca.deptdetailreportexe.csp?action=del&intervalDr='+monthCombo.getValue()+'&distSetDr='+costDistResultSetComb.getValue()+'&dataSetDr='+itemSetComb.getValue()+'&repType=szjy',
				waitMsg:'正在删除...',
				success: function(result,request){
					Ext.Ajax.request({
						url:'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode,
						waitMsg:'正在查询...',
						success: function(result,request){
							var jsonData = Ext.util.JSON.decode(result.responseText);
							var userInfo=jsonData.info;
							var aaa=encodeURI(encodeURI(userInfo));
					
							//获取变量
							var mons=monsCombo.getValue();
							var month=monthCombo.getValue();
							var deptSet=deptSetComb.getValue();
							var cost=costDistResultSetComb.getValue();
							var item=itemSetComb.getValue();
						
							//获取用户成功时，发送计算数据的请求
							Ext.Ajax.request({
								url:'dhc.ca.deptdetailreportexe.csp?action=cal&CostDistId='+cost+'&month='+mons+'&itemSetDr='+item,
								waitMsg:'正在计算...',
								timeout: 120000,
								success: function(result,request){	
									Ext.Msg.alert("提示","计算成功!");
								}
							});
						}
					});
				}
	    	});
		}
	}
});

var checkButton = new Ext.Toolbar.Button({
	text:'查询',        
	tooltip:'查询',
	iconCls:'add',        
	handler: function(){
		if((monthCombo.getValue()=="")||(monsCombo.getValue()=="")||(deptSetComb.getValue()=="")||(costDistResultSetComb.getValue()=="")||(itemSetComb.getValue()=="")){
			Ext.Msg.alert("提示","请先选择各项参数");
		}else{
			Ext.Ajax.request({
				url:'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode,
				waitMsg:'正在查询...',
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
								{tag: 'param', name: 'REPORT_URL', value: '../CacheQueryTest?month='+monsCombo.getValue()+'&monthName='+monthCombo.getRawValue()+'&monthDr='+monthCombo.getValue()+'&deptClass='+deptSetComb.getValue()+'&cost='+costDistResultSetComb.getValue()+'&item='+itemSetComb.getValue()+'&repType=szjy'+'&userInfo='+aaa+'&outType=print'}
							]
						}
              		}));
					center.getLayout().setActiveItem('second_center');
					center.doLayout();
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
		if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")||(itemSetComb.getValue()=="")){
			Ext.Msg.alert("提示","请先选择各项参数");
		}else{
			var userCode = session['LOGON.USERCODE'];
	    	Ext.Ajax.request({
				url:'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode,
				waitMsg:'正在查询...',
				success: function(result,request){	
					var jsonData = Ext.util.JSON.decode(result.responseText);
					var userInfo=jsonData.info;
					var aaa=encodeURI(encodeURI(userInfo));
					//url: 'http://172.26.201.66:1969
					location.href = 'http://172.26.201.66:1969/dhccareport/servlets/blanceofpayment/JasperPrintServlet?month='+monsCombo.getValue()+'&monthDr='+monthCombo.getValue()+'&deptClass='+deptSetComb.getValue()+'&cost='+costDistResultSetComb.getValue()+'&item='+itemSetComb.getValue()+'&userInfo='+aaa+'&outType=xls';
				}
	    	});
		}
	}
});
var detailReport = new Ext.Panel({
	id:'detailReport',
	layout:'border',
	height:700,
	title: '收支结余总表',
	items:[{
		id: 'center_panel',
		region: 'center',
		layout: 'card',
		items: [{id:'first_center',html:''}]
	}],
	tbar:['核算月份:',monthCombo,'-','核算区间:',monsCombo,'-','成本分摊套:',costDistResultSetComb,'-','部门分层套',deptSetComb,'-','数据分层套:',itemSetComb,'-',CalButton,'-',checkButton,'-',excelButton]
});


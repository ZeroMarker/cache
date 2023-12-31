//Menu
var directStore = new Ext.data.SimpleStore({
		fields:['name','num'],
		data :[['开单等于执行','0'],['开单或执行','1']]
	});
var directCombo = new Ext.form.ComboBox({
		id:'directCombo',
		fieldLabel:'选项',
		store:directStore,
		valueField:'num',
		displayField:'name',
		mode:'local',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		width:100,
		listWidth:250,
		value:'0',
		triggerAction:'all',
		emptyText:'选择...',
		allowBlank: false,
		//name:'deptSetComb',
		selectOnFocus: true,
		forceSelection: true 
	});
	
directCombo.on("select",function(cmb,rec,id ){
	if(directCombo.getValue()=='1'){
		ddCombo.enable();
	}else{
		ddCombo.disable();
	}
});
	
var ddStore = new Ext.data.SimpleStore({
		fields:['name','num'],
		data :[['开单科室','1'],['执行科室','0']]
	});
var ddCombo = new Ext.form.ComboBox({
		id:'ddCombo',
		fieldLabel:'选项',
		store:ddStore,
		valueField:'num',
		displayField:'name',
		mode:'local',
		typeAhead:true,
		disabled:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		width:100,
		listWidth:250,
		value:'0',
		triggerAction:'all',
		emptyText:'科室选择...',
		allowBlank: false,
		//name:'deptSetComb',
		selectOnFocus: true,
		forceSelection: true 
	});

var monsCombo = new Ext.form.ComboBox({
	id:'monsCombo',
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
	width:90,
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择月份...',
	allowBlank: false,
	//name:'deptSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
/*
var monsCombo = new Ext.ux.form.LovCombo({
	id:'monsCombo',
	fieldLabel: '月份',
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
	listWidth:250,
	allowBlank: false,
	emptyText:'选择月份...',
	editable:false,
	//allowBlank: false,
	anchor: '90%'
});
*/
var cumulMonsCombo = new Ext.ux.form.LovCombo({
	id:'cumulMonsCombo',
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
	width:90,
	listWidth:250,
	//allowBlank: false,
	emptyText:'选择月份...',
	editable:false,
	//allowBlank: false,
	anchor: '90%'
});

var deptSetDs = new Ext.data.Store({
	autoLoad: true,
	proxy:"",                                                        
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name','deptSetDr'])
});

deptSetDs.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.costresultdatareportexe.csp?action=listCostDistSets&id=roo', method:'GET'});
});

var deptSetComb = new Ext.form.ComboBox({
	id:'deptSetComb',
	fieldLabel:'成本分摊套',
	store: deptSetDs,
	valueField:'rowid',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	minChars:1,
	anchor: '90%',
	width:90,
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择成本分摊套...',
	allowBlank: false,
	name:'deptSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
deptSetComb.on("select",function(cmb,rec,id ){
	itemSetComb.enable();
});

var itemSetDs = new Ext.data.Store({
	autoLoad: true,
	proxy:"",                                                        
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','name'])
});

itemSetDs.on('beforeload',function(ds, o){   
	var index=deptSetDs.find('rowid',deptSetComb.getValue());        
	var tmpObj=deptSetDs.getAt(index);
	var tmpDeptSetDr=tmpObj.get("deptSetDr");
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.deptdetailreportexe.csp?action=listDeptClass&parRef='+tmpDeptSetDr, method:'GET'});
});

var itemSetComb = new Ext.form.ComboBox({
	id:'itemSetComb',
	fieldLabel:'科室类别',
	store: itemSetDs,
	valueField:'id',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	disabled:true,
	minChars:1,
	anchor: '90%',
	width:90,
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择科室类别...',
	allowBlank: false,
	name:'itemSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
itemSetComb.on("select",function(cmb,rec,id ){
	////to do sth
});


var checkButton = new Ext.Toolbar.Button({
	text:'查看',        
	tooltip:'查看',
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
										//alert(encodeURI(userInfo)+"      "+encodeURI(encodeURI(userInfo)));
										var center = Ext.getCmp('center_panel');
										center.remove('first_center');
										center.add(new Ext.Panel({
  				    			
												id:'second_center',
	    							    
	    				    			bodyCfg: {
													tag: 'applet',
													archive: 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar',
													code: 'EmbeddedViewerApplet.class',
													codebase: 'http://172.26.201.66:1969/dhccareport/applets',
													cn: [
														{tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2'},
														{tag: 'param', name: 'scriptable', value: 'false'},
														{tag: 'param', name: 'REPORT_URL', value: '../DeptDetailReportServlet?month='+monsCombo.getValue()+'&cost='+deptSetComb.getValue()+'&deptClass='+itemSetComb.getValue()+'&userInfo='+aaa+'&cumulative='+cumulMonsCombo.getValue()+'&outType=print'+'&tf='+directCombo.getValue()+'&tf2='+ddCombo.getValue()}
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
										
										location.href = 'http://172.26.201.66:1969/dhccareport/DeptDetailReportServlet?month='+monsCombo.getValue()+'&cost='+deptSetComb.getValue()+'&deptClass='+itemSetComb.getValue()+'&userInfo='+aaa+'&cumulative='+cumulMonsCombo.getValue()+'&outType=xls'+'&tf='+directCombo.getValue()+'&tf2='+ddCombo.getValue();

								}
	    				});
							
			}
		}
});
/*
var northPanel = new Ext.form.FormPanel({
	 	//region: 'north',
		baseCls: 'x-plain',
		items: [
			cumulMonsCombo,'-',checkButton,'-',excelButton
		]
	});
*/
var detailReport = new Ext.Panel({
	id:'detailReport',
	layout:'border',
	height:700,
  title: '科室收入成本收益明细表',
  items:[{
						id: 'center_panel',
						region: 'center',
						layout: 'card',
						items: [
							{id: 'first_center', html: ''}
						]
					}
				],

	tbar:['月份:',monsCombo,'分摊套:',deptSetComb,'科室类:',itemSetComb,'-','累计:',cumulMonsCombo,'收入:',directCombo,ddCombo,'-',checkButton,excelButton]
});
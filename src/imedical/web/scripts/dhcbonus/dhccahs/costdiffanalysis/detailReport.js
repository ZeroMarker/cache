//Menu
var sqDr;//上期dr
var qtDr;//去年同期dr
var deptListStore = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			id: 'rowid'
		},[
			'rowid',
			'Name'
		])
	},[
		'rowid', 'Name'
    ]);
    

deptListStore.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url: 'dhc.ca.costdeptgroupbyitemexe.csp?action=listLeaf&cost='+deptSetComb.getValue(), method:'GET'});
});

var deptListCombo = new Ext.form.ComboBox({
	id:'deptListCombo',
	fieldLabel: '科室',
	hideOnSelect: false,
	store: deptListStore,
	valueField:'rowid',
	displayField:'Name',
	typeAhead: false,
	triggerAction: 'all',
	disabled:true,
	pageSize:1000,
		width:100,
	listWidth:250,
	allowBlank: false,
	emptyText:'选择科室...',
	editable:false,
	//allowBlank: false,
	anchor: '90%'
});

deptListCombo.on("select",function(cmb,rec,id ){
	itemSetComb.enable();
});

var directStore = new Ext.data.SimpleStore({
		fields:['name','num'],
		data :[['科室成本','0'],['医疗成本','1'],['医疗成本明细','2']]
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
	
//directCombo.on("select",function(cmb,rec,id ){

//});

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
	listWidth:250,
	width:100,
	triggerAction:'all',
	emptyText:'选择月份...',
	allowBlank: false,
	//name:'deptSetComb',
	selectOnFocus: true,
	forceSelection: true 
});

monsCombo.on("select",function(cmb,rec,id ){

	Ext.Ajax.request({
		url:'dhc.ca.costdiffanalysisexe.csp?action=getMonth&type=sq&month='+cmb.getValue(),
		waitMsg:'正在查询...',
		success: function(result,request){	
			var jsonData = Ext.util.JSON.decode(result.responseText);
			sqDr=jsonData.info;
		}
	});
	Ext.Ajax.request({
		url:'dhc.ca.costdiffanalysisexe.csp?action=getMonth&type=qt&month='+cmb.getValue(),
		waitMsg:'正在查询...',
		success: function(result,request){	
			var jsonData = Ext.util.JSON.decode(result.responseText);
			qtDr=jsonData.info;
		}
	});	
	
});

var monthListCombo = new Ext.ux.form.LovCombo({
	id:'monthListCombo',
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
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
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
	listWidth:250,
	width:100,
	triggerAction:'all',
	emptyText:'选择成本分摊套...',
	allowBlank: false,
	name:'deptSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
deptSetComb.on("select",function(cmb,rec,id ){
	//deptListCombo.enable();
});

//var itemSetDs = new Ext.data.Store({
//	autoLoad: true,
//	proxy:"",                                                        
//	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','name'])
//});
//
//itemSetDs.on('beforeload',function(ds, o){           
//	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.costresultdatareportexe.csp?action=listItemClass', method:'GET'});
//});


var itemSetDs = new Ext.data.SimpleStore({
		fields:['name','id'],
		data:[['成本分层套一','1'],
					['成本分层套二','66']]
	});

var itemSetComb = new Ext.form.ComboBox({
	id:'itemSetComb',
	fieldLabel:'数据分层套',
	store: itemSetDs,
	valueField:'id',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	disabled:true,
	minChars:1,
	anchor: '90%',
			mode:'local',
	listWidth:250,
	width:100,
	triggerAction:'all',
	emptyText:'选择数据分层套...',
	name:'itemSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
itemSetComb.on("select",function(cmb,rec,id ){
	////to do sth
});

var calculButton = new Ext.Toolbar.Button({
	text:'计算',        
	tooltip:'计算',
	iconCls:'add',        
	handler: function(){ 
			if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")||(monthListCombo.getValue()=="")||((reportNo==2)&&((deptListCombo.getValue()=="")||(itemSetComb.getValue()=="")))){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{
			
	    				var userCode = session['LOGON.USERCODE'];
	    				
	    				var tmpMonths = monthListCombo.getValue();
	    				var tmpMonArray = tmpMonths.split(',');
	    				var tmpSqNum=tmpMonArray.indexOf(sqDr);
	    				var tmpQtNum=tmpMonArray.indexOf(qtDr);
	    				if(tmpSqNum==-1){
	    					tmpMonths = tmpMonths+","+sqDr;
	    				}
	    				if(tmpQtNum==-1){
	    					tmpMonths = tmpMonths+","+qtDr;
	    				}
	    				
	    				//alert(tmpMonths);
	    				
	    				Ext.Ajax.request({
								url:'dhc.ca.costdiffanalysisexe.csp?action=calculation&dept='+deptSetComb.getValue()+'&item='+itemSetComb.getValue()+'&month='+tmpMonths+'&smallBig='+reportNo+'&doiDr='+deptListCombo.getValue()+'&doi=dept',
								waitMsg:'正在查询...',
								timeout:3600000,
								success: function(result,request){

							
	    				Ext.Ajax.request({
								url:'dhc.ca.costresultdatareportexe.csp?action=getUser&userCode='+userCode,
								waitMsg:'正在查询...',
								success: function(result,request){	
										var jsonData = Ext.util.JSON.decode(result.responseText);
										var userInfo=jsonData.info;
										var tmpMon=encodeURI(encodeURI(monsCombo.getRawValue()));
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
													cn: [
														{tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2'},
														{tag: 'param', name: 'scriptable', value: 'false'},
														{tag: 'param', name: 'REPORT_URL', value: '../CostDiffAnalysis?thisMonth='+monsCombo.getValue()+'&lastMonth='+sqDr+'&qtMonth='+qtDr+'&monthsAll='+tmpMonths+'&months='+monthListCombo.getValue()+'&cost='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=print'+'&itemSet='+itemSetComb.getValue()+'&monName='+tmpMon+'&smallBig='+reportNo+'&doiDr='+deptListCombo.getValue()+'&doi=dept'}
													]
												}
              			
	    							}));
										center.getLayout().setActiveItem('second_center');
										center.doLayout();
										}
	    						});
	    					
								}
	    				});

							center.getLayout().setActiveItem('second_center');
							center.doLayout();


			}
		}
});


var checkButton = new Ext.Toolbar.Button({
	text:'查看',        
	tooltip:'查看',
	iconCls:'add',        
	handler: function(){ 
			if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")||(monthListCombo.getValue()=="")||((reportNo==2)&&((deptListCombo.getValue()=="")||(itemSetComb.getValue()=="")))){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{
			
	    				var userCode = session['LOGON.USERCODE'];
	    				var tmpMonths = monthListCombo.getValue();
	    				var tmpMonArray = tmpMonths.split(',');
	    				var tmpSqNum=tmpMonArray.indexOf(sqDr);
	    				var tmpQtNum=tmpMonArray.indexOf(qtDr);
	    				if(tmpSqNum==-1){
	    					tmpMonths = tmpMonths+","+sqDr;
	    				}
	    				if(tmpQtNum==-1){
	    					tmpMonths = tmpMonths+","+qtDr;
	    				}
	    					    				
	    				Ext.Ajax.request({
								url:'dhc.ca.costresultdatareportexe.csp?action=getUser&userCode='+userCode,
								waitMsg:'正在查询...',
								success: function(result,request){	
										var jsonData = Ext.util.JSON.decode(result.responseText);
										var userInfo=jsonData.info;
										var tmpMon=encodeURI(encodeURI(monsCombo.getRawValue()));
										var aaa=encodeURI(encodeURI(userInfo));
										var center = Ext.getCmp('center_panel');
										center.remove('first_center');
										center.add(new Ext.Panel({
  				    			
												id:'second_center',
	    							    
	    							    bodyCfg: {
													tag: 'applet',
													archive: 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar',
													code: 'EmbeddedViewerApplet.class',
													//codebase: 'http://10.21.3.129:8080/dhccareport/applets',
													codebase: 'http://172.26.201.66:1969/dhccareport/applets',
													cn: [ 
														{tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2'},
														{tag: 'param', name: 'scriptable', value: 'false'},
														{tag: 'param', name: 'REPORT_URL', value: '../CostDiffAnalysis?thisMonth='+monsCombo.getValue()+'&lastMonth='+sqDr+'&qtMonth='+qtDr+'&monthsAll='+tmpMonths+'&months='+monthListCombo.getValue()+'&cost='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=print'+'&itemSet='+itemSetComb.getValue()+'&monName='+tmpMon+'&smallBig='+reportNo+'&doiDr='+deptListCombo.getValue()+'&doi=dept'}
													]
												}
              			
	    							}));
										center.getLayout().setActiveItem('second_center');
										center.doLayout();
								}
	    				});

							center.getLayout().setActiveItem('second_center');
							center.doLayout();


			}
		}
});

var excelButton = new Ext.Toolbar.Button({
	text:'生成excel',        
	tooltip:'生成excel',
	iconCls:'add',        
	handler: function(){ 
			if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")||(monthListCombo.getValue()=="")||((reportNo==2)&&((deptListCombo.getValue()=="")||(itemSetComb.getValue()=="")))){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{
			
	    				var userCode = session['LOGON.USERCODE'];
	    				var tmpMonths = monthListCombo.getValue();
	    				var tmpMonArray = tmpMonths.split(',');
	    				var tmpSqNum=tmpMonArray.indexOf(sqDr);
	    				var tmpQtNum=tmpMonArray.indexOf(qtDr);
	    				if(tmpSqNum==-1){
	    					tmpMonths = tmpMonths+","+sqDr;
	    				}
	    				if(tmpQtNum==-1){
	    					tmpMonths = tmpMonths+","+qtDr;
	    				}
	    					    				
	    				Ext.Ajax.request({
								url:'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode,
								waitMsg:'正在查询...',
								success: function(result,request){	
										var jsonData = Ext.util.JSON.decode(result.responseText);
										var userInfo=jsonData.info;
										var tmpMon=encodeURI(encodeURI(monsCombo.getRawValue()));
										var aaa=encodeURI(encodeURI(userInfo));	
										location.href = 'http://172.26.201.66:1969/dhccareport/CostDiffAnalysis?thisMonth='+monsCombo.getValue()+'&lastMonth='+sqDr+'&qtMonth='+qtDr+'&monthsAll='+tmpMonths+'&months='+monthListCombo.getValue()+'&cost='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=xls'+'&itemSet='+itemSetComb.getValue()+'&monName='+tmpMon+'&smallBig='+reportNo+'&doiDr='+deptListCombo.getValue()+'&doi=dept';

								}
	    				});
							
			}
		}
});

var detailReport = new Ext.Panel({
	id:'detailReport',
	layout:'border',
	height:700,
  title: '科室成本差异分析表',
  items:[{
						id: 'center_panel',
						region: 'center',
						layout: 'card',
						items: [
							{id: 'first_center', html: ''}
						]
				
				}],

	tbar:['核算月',monsCombo,'累计',monthListCombo,'分摊套',deptSetComb,'科室',deptListCombo,'数据分层套',itemSetComb,'-',calculButton,checkButton,excelButton]
});

detailReport.on("render",function(p ){
	if(reportNo==2){
		deptListCombo.enable();
		itemSetComb.enable();
	}else{
		deptListCombo.disable();
		itemSetComb.disable();
	}     
});
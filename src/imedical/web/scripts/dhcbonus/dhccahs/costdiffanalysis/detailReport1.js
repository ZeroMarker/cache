//Menu
var sqDr;//上期dr
var qtDr;//去年同期dr
var deptListStore1 = new Ext.data.Store({
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
    

deptListStore1.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url: 'dhc.ca.costdiffanalysisexe.csp?action=listLeaf&cost='+deptSetComb1.getValue(), method:'GET'});
});

var deptListCombo1 = new Ext.form.ComboBox({
	id:'deptListCombo1',
	fieldLabel: '科室',
	hideOnSelect: false,
	store: deptListStore1,
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

var monsCombo1 = new Ext.form.ComboBox({
	id:'monsCombo1',
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
	//name:'deptSetComb1',
	selectOnFocus: true,
	forceSelection: true 
});

monsCombo1.on("select",function(cmb,rec,id ){

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


var monthListCombo1 = new Ext.ux.form.LovCombo({
	id:'monthListCombo1',
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

var deptSetComb1 = new Ext.form.ComboBox({
	id:'deptSetComb1',
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
	name:'deptSetComb1',
	selectOnFocus: true,
	forceSelection: true 
});
	
deptSetComb1.on("select",function(cmb,rec,id ){
	deptListCombo1.enable();
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
	
var itemSetComb1 = new Ext.form.ComboBox({
	id:'itemSetComb1',
	fieldLabel:'数据分层套',
	store: itemSetDs,
	valueField:'id',
	displayField:'name',
	typeAhead:true,
	pageSize:10,
	minChars:1,
	anchor: '90%',
	listWidth:250,
		mode:'local',
	width:100,
	triggerAction:'all',
	emptyText:'选择数据分层套...',
	//allowBlank: false,
	name:'itemSetComb1',
	selectOnFocus: true,
	forceSelection: true 
});
	
itemSetComb1.on("select",function(cmb,rec,id ){
	////to do sth
});

var calculButton1 = new Ext.Toolbar.Button({
	text:'计算',        
	tooltip:'计算',
	iconCls:'add',        
	handler: function(){ 
			if((monsCombo1.getValue()=="")||(deptSetComb1.getValue()=="")||(monthListCombo1.getValue()=="")||(itemSetComb1.getValue()=="")){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{
			
	    				var userCode = session['LOGON.USERCODE'];
	    				var tmpMonths = monthListCombo1.getValue();
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
								url:'dhc.ca.costdiffanalysisexe.csp?action=calculation&dept='+deptSetComb1.getValue()+'&item='+itemSetComb1.getValue()+'&month='+tmpMonths+'&doiDr='+deptListCombo1.getValue()+'&doi=item',
								waitMsg:'正在查询...',
								timeout:3600000,
								success: function(result,request){
									//Ext.Msg.alert("提示","计算成功!");

	
	    				Ext.Ajax.request({
								url:'dhc.ca.costresultdatareportexe.csp?action=getUser&userCode='+userCode,
								waitMsg:'正在查询...',
								success: function(result,request){	
										var jsonData = Ext.util.JSON.decode(result.responseText);
										var userInfo=jsonData.info;
										var tmpMon=encodeURI(encodeURI(monsCombo1.getRawValue()));
										var aaa=encodeURI(encodeURI(userInfo));
										//alert(encodeURI(userInfo)+"      "+encodeURI(encodeURI(userInfo)));
										var center = Ext.getCmp('center_panel1');
										center.remove('first_center1');
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
														{tag: 'param', name: 'REPORT_URL', value: '../CostDiffAnalysis?thisMonth='+monsCombo1.getValue()+'&lastMonth='+sqDr+'&qtMonth='+qtDr+'&monthsAll='+tmpMonths+'&months='+monthListCombo1.getValue()+'&cost='+deptSetComb1.getValue()+'&userInfo='+aaa+'&outType=print'+'&itemSet='+itemSetComb1.getValue()+'&monName='+tmpMon+'&doiDr='+deptListCombo1.getValue()+'&doi=item'}
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

var checkButton1 = new Ext.Toolbar.Button({
	text:'查看',        
	tooltip:'查看',
	iconCls:'add',        
	handler: function(){ 
			if((monsCombo1.getValue()=="")||(deptSetComb1.getValue()=="")||(monthListCombo1.getValue()=="")||(itemSetComb1.getValue()=="")){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{
			
	    				var userCode = session['LOGON.USERCODE'];
	    					    				var tmpMonths = monthListCombo1.getValue();
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
										var tmpMon=encodeURI(encodeURI(monsCombo1.getRawValue()));
										var aaa=encodeURI(encodeURI(userInfo));
										//alert(encodeURI(userInfo)+"      "+encodeURI(encodeURI(userInfo)));
										var center = Ext.getCmp('center_panel1');
										center.remove('first_center1');
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
														{tag: 'param', name: 'REPORT_URL', value: '../CostDiffAnalysis?thisMonth='+monsCombo1.getValue()+'&lastMonth='+sqDr+'&qtMonth='+qtDr+'&monthsAll='+tmpMonths+'&months='+monthListCombo1.getValue()+'&cost='+deptSetComb1.getValue()+'&userInfo='+aaa+'&outType=print'+'&itemSet='+itemSetComb1.getValue()+'&monName='+tmpMon+'&doiDr='+deptListCombo1.getValue()+'&doi=item'}
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

var excelButton1 = new Ext.Toolbar.Button({
	text:'生成excel',        
	tooltip:'生成excel',
	iconCls:'add',        
	handler: function(){ 
			if((monsCombo1.getValue()=="")||(deptSetComb1.getValue()=="")||(monthListCombo1.getValue()=="")||(itemSetComb1.getValue()=="")){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{
			
	    				var userCode = session['LOGON.USERCODE'];
	    				var tmpMonths = monthListCombo1.getValue();
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
										var tmpMon=encodeURI(encodeURI(monsCombo1.getRawValue()));
										var aaa=encodeURI(encodeURI(userInfo));
										
										location.href = 'http://172.26.201.66:1969/dhccareport/CostDiffAnalysis?thisMonth='+monsCombo1.getValue()+'&lastMonth='+sqDr+'&qtMonth='+qtDr+'&monthsAll='+tmpMonths+'&months='+monthListCombo1.getValue()+'&cost='+deptSetComb1.getValue()+'&userInfo='+aaa+'&outType=xls'+'&itemSet='+itemSetComb1.getValue()+'&monName='+tmpMon+'&doiDr='+deptListCombo1.getValue()+'&doi=item';

								}
	    				});
							
			}
		}
});

var detailReport1 = new Ext.Panel({
	id:'detailReport1',
	layout:'border',
	height:700,
  title: '成本项目差异分析表',
  items:[{
						id: 'center_panel1',
						region: 'center',
						layout: 'card',
						items: [
							{id: 'first_center1', html: ''}
						]
				
				}],

	tbar:['核算月:',monsCombo1,'累计:',monthListCombo1,'分摊套:',deptSetComb1,'数据分层套:',itemSetComb1,'项目(可选):',deptListCombo1,'-',calculButton1,checkButton1,excelButton1]
});


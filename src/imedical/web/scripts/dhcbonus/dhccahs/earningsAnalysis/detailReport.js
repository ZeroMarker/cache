//Menu
var sqDr;//上期dr
var qtDr;//去年同期dr

var directStore = new Ext.data.SimpleStore({
		fields:['name','num'],
		data :[['直接医疗科室收入差异分析汇总表','1'],['医疗技术科室收入差异分析汇总表','2'],['医院收入构成表','3'],['直接医疗科室收益比较表','4'],['医疗技术科室收益比较表','5']]
	});
	
var reportTitle='';
if(reportNo==1){
	reportTitle='直接医疗科室收入差异分析汇总表';
}else if(reportNo==2){
	reportTitle='医疗技术科室收入差异分析汇总表';
}else if(reportNo==3){
	reportTitle='医院收入构成表';
}else if(reportNo==4){
	reportTitle='直接医疗科室收益比较表';
}else if(reportNo==5){
	reportTitle='医疗技术科室收益比较表';
}
	
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
		value:'1',
		triggerAction:'all',
		emptyText:'选择...',
		allowBlank: false,
		//name:'deptSetComb',
		selectOnFocus: true,
		forceSelection: true 
	});
	
directCombo.on("select",function(cmb,rec,id ){
	/*
	if(id==2){
		deptListCombo.enable();
		itemSetComb.enable();
	}else{
		deptListCombo.disable();
		itemSetComb.disable();
	}
	*/
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
			width:100,
	listWidth:250,
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


var monsListCombo = new Ext.ux.form.LovCombo({
	id:'monsListCombo',
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
			width:100,
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择成本分摊套...',
	allowBlank: false,
	name:'deptSetComb',
	selectOnFocus: true,
	forceSelection: true 
});
	
deptSetComb.on("select",function(cmb,rec,id ){
	////to do sth
});

var itemSetDs = new Ext.data.Store({
	autoLoad: true,
	proxy:"",                                                        
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','name'])
});

itemSetDs.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.costresultdatareportexe.csp?action=listItemClass', method:'GET'});
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
	anchor: '90%',
			width:100,
	listWidth:250,
	triggerAction:'all',
	emptyText:'选择数据分层套...',
	//allowBlank: false,
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
			if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{			
	    				var userCode = session['LOGON.USERCODE'];	
	    				
	    				var tmpMonths = monsListCombo.getValue();
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
								url:'dhc.ca.newextreportexe.csp?action=calculation&type='+reportNo+'&dept='+deptSetComb.getValue()+'&months='+tmpMonths,
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
																{tag: 'param', name: 'REPORT_URL', value: '../NewExt?thisMonth='+monsCombo.getValue()+'&lastMonth='+sqDr+'&qtMonth='+qtDr+'&type='+reportNo+'&monthsAll='+tmpMonths+'&cost='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=print'+'&monName='+tmpMon+'&months='+monsListCombo.getValue()+'&itemSet=1'}
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
			if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{
			
	    				var userCode = session['LOGON.USERCODE'];
	    				var tmpMonths = monsListCombo.getValue();
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
										//alert(encodeURI(userInfo)+"      "+encodeURI(encodeURI(userInfo)));
										var center = Ext.getCmp('center_panel');
										center.remove('first_center');
										center.add(new Ext.Panel({
  				    			
												id:'second_center',
	    							    
	    							    bodyCfg: {
													tag: 'applet',
													archive: 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar',
													code: 'EmbeddedViewerApplet.class',
													//codebase: 'http://172.26.201.66:1969/dhccareport/applets',
													codebase: 'http://172.26.201.66:1969/dhccareport/applets',
													cn: [
														{tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2'},
														{tag: 'param', name: 'scriptable', value: 'false'},
														{tag: 'param', name: 'REPORT_URL', value: '../NewExt?thisMonth='+monsCombo.getValue()+'&lastMonth='+sqDr+'&qtMonth='+qtDr+'&type='+reportNo+'&monthsAll='+tmpMonths+'&cost='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=print'+'&monName='+tmpMon+'&months='+monsListCombo.getValue()+'&itemSet=1'}
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
			if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")){
				Ext.Msg.alert("提示","请先选择各项参数");
			}else{
			
	    				var userCode = session['LOGON.USERCODE'];
	    				var tmpMonths = monsListCombo.getValue();
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
										
										//location.href = 'http://172.26.201.66:1969/dhccareport/ItemSummary?month='+monsCombo.getValue()+'&cost='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=xls'+'&itemSet='+itemSetComb.getValue()+'&monName='+tmpMon;
										location.href = 'http://172.26.201.66:1969/dhccareport/NewExt?thisMonth='+monsCombo.getValue()+'&lastMonth='+sqDr+'&qtMonth='+qtDr+'&type='+reportNo+'&monthsAll='+tmpMonths+'&cost='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=xls'+'&monName='+tmpMon+'&months='+monsListCombo.getValue()+'&itemSet=1';

								}
	    				});
							
			}
		}
});

var detailReport = new Ext.Panel({
	id:'detailReport',
	layout:'border',
	height:700,
  title: reportTitle,
  items:[{
						id: 'center_panel',
						region: 'center',
						layout: 'card',
						items: [
							{id: 'first_center', html: ''}
						]
				
				}],

	tbar:['核算月',monsCombo,'累计',monsListCombo,'分摊套',deptSetComb,'-',calculButton,checkButton,excelButton]
});


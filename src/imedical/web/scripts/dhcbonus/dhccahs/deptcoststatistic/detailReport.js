//Menu
monthURL='dhc.ca.accountmonthsexe.csp';
costDistResultUrl='dhc.ca.deptcoststatisticexe.csp';
var monsCombo = new Ext.form.ComboBox({
	id:'monsCombo',
	fieldLabel:'月份',
	store:  new Ext.data.Store({
		autoLoad: true,
		proxy: new Ext.data.HttpProxy({url:monthURL+'?action=list'}),
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
var deptSetDs = new Ext.data.Store({
	autoLoad: true,
	proxy:"",                                                        
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
});

deptSetDs.on('beforeload',function(ds, o){           
	ds.proxy = new Ext.data.HttpProxy({url:costDistResultUrl+'?action=listCostDistSets&id=roo', method:'GET'});
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

//var itemSetDs = new Ext.data.Store({
//	autoLoad: true,
//	proxy:"",                                                        
//	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','name'])
//});
//
//itemSetDs.on('beforeload',function(ds, o){           
//	ds.proxy = new Ext.data.HttpProxy({url:costDistResultUrl+'?action=listItemClass', method:'GET'});
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
		mode:'local',
	minChars:1,
	anchor: '90%',
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

var CalButton = new Ext.Toolbar.Button({
	text:'计算',        
	tooltip:'计算',
	iconCls:'remove',        
	handler: function(){ 
	    //Ext.Msg.alert("ok1");
		if((monsCombo.getValue()=="")||(deptSetComb.getValue()=="")||(itemSetComb.getValue()=="")){
			//Ext.Msg.alert("提示","请先选择各项参数");
		}else{
		    //alert("ok2");
			Ext.Ajax.request({ 
			   //alert("ok3");
				url:costDistResultUrl+'?action=del&month='+monsCombo.getValue()+'&cost='+deptSetComb.getValue()+'&itemSet='+itemSetComb.getValue()+'&repType=kscbhz',
				//alert(url);
				waitMsg:'正在删除...',
				success: function(result,request){	
					//Ext.Msg.alert("提示","删除成功!");
					
					Ext.Ajax.request({
						url:costDistResultUrl+'?action=insert&month='+monsCombo.getValue()+'&cost='+deptSetComb.getValue()+'&itemSet='+itemSetComb.getValue()+'&repType=kscbhz',
						waitMsg:'正在计算...',
						success: function(result,request){
							Ext.Msg.alert("提示","计算成功,请点查看按钮进行查看。");
						}
					});
				}
	    	});
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
	    				
	    				Ext.Ajax.request({
								url:costDistResultUrl+'?action=getUser&userCode='+userCode+'&cost='+deptSetComb.getValue()+'&month='+monsCombo.getValue()+'&itemSet='+itemSetComb.getValue(),
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
													codebase: 'http://172.26.201.66:1969/dhccareport/applets',
													cn: [
														{tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2'},
														{tag: 'param', name: 'scriptable', value: 'false'},
														//{tag: 'param', name: 'REPORT_URL', value: '../servlets/deptcoststatistic/DeptCostStatisticJasper?month='+monsCombo.getValue()+'&userInfo='+aaa+'&outType=print'+'&monName='+tmpMon}
														{tag: 'param', name: 'REPORT_URL', value: '../servlets/deptcoststatistic/DeptCostStatisticJasper?month='+monsCombo.getValue()+'&userInfo='+aaa+'&outType=print'+'&monName='+tmpMon+'&cost='+deptSetComb.getValue()+'&itemSet='+itemSetComb.getValue()}
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
	    				
	    				Ext.Ajax.request({
								url:costDistResultUrl+'?action=getUser&userCode='+userCode+'&cost='+deptSetComb.getValue()+'&month='+monsCombo.getValue()+'&itemSet='+itemSetComb.getValue(),
								waitMsg:'正在查询...',
								success: function(result,request){	
										var jsonData = Ext.util.JSON.decode(result.responseText);
										var userInfo=jsonData.info;
										var tmpMon=encodeURI(encodeURI(monsCombo.getRawValue()));
										var aaa=encodeURI(encodeURI(userInfo));									
										location.href = 'http://172.26.201.66:1969/dhccareport/servlets/deptcoststatistic/DeptCostStatisticJasper?month='+monsCombo.getValue()+'&userInfo='+aaa+'&outType=xls'+'&monName='+tmpMon+'&cost='+deptSetComb.getValue()+'&itemSet='+itemSetComb.getValue();

								}
	    				});
							
			}
		}
});

var detailReport = new Ext.Panel({
	id:'detailReport',
	layout:'border',
	height:700,
  title: '科室汇总查询',
  items:[{
						id: 'center_panel',
						region: 'center',
						layout: 'card',
						items: [
							{id: 'first_center', html: ''}
						]
				
				}],

	tbar:['核算月:',monsCombo,'-','分摊套:',deptSetComb,'-','数据分层套:',itemSetComb,'-',CalButton,'-',checkButton,'-',excelButton]
});


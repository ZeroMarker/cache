var userCode = session['LOGON.USERCODE'];
var monthCombo = new Ext.form.ComboBox({
	id:'monthCombo',
	fieldLabel:'核算月份',
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
	width:200,
	listWidth:200,
	triggerAction:'all',
	emptyText:'请选择核算月份...',
	allowBlank: false,
	selectOnFocus: true,
	forceSelection: true 
});


var deptSetComb = new Ext.ux.form.LovCombo({
	id:'deptSetComb',
	fieldLabel: '科室类别',
	hideOnSelect: false,
	store: new Ext.data.Store({
		autoLoad: true,
		proxy: new Ext.data.HttpProxy({url: 'dhc.ca.perforaccountreporttab.csp?action=depttype'}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			id: 'id'
		},[
			'id',
			'name'
		])
	},[
		'id', 'name'
    ]),
	valueField:'id',
	displayField:'name',
	typeAhead: false,
	triggerAction: 'all',
	pageSize:10,
	width:200,
	listWidth:200,
	allowBlank: false,
	emptyText:'选择科室类别...',
	editable:false,
	anchor: '90%'
});

var checkButton = new Ext.Toolbar.Button({
	text:'查询',        
	tooltip:'查询',
	iconCls:'add',        
	handler: function(){
		if((monthCombo.getValue()=="")||(deptSetComb.getValue()=="")){
			Ext.Msg.alert("提示","请选择各参数");
		}else{
			Ext.Ajax.request({
				url:'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode,
				waitMsg:'????...',
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
								{tag: 'param', name: 'REPORT_URL', value: '../proforaccountincome?monthDr='+monthCombo.getValue()+'&monthName='+monthCombo.getRawValue()+'&deptTypeDrStr='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=print'}
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
		if((monthCombo.getValue()=="")||(deptSetComb.getValue()=="")){
			Ext.Msg.alert("提示","请先选择各项参数");
		}else{
			var userCode = session['LOGON.USERCODE'];
	    	Ext.Ajax.request({
				url:'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode,
				waitMsg:'正在生成...',
				success: function(result,request){	
					var jsonData = Ext.util.JSON.decode(result.responseText);
					var userInfo=jsonData.info;
					var aaa=encodeURI(encodeURI(userInfo));
					location.href = 'http://172.26.201.66:1969/dhccareport/proforaccountincome?monthDr='+monthCombo.getValue()+'&monthName='+monthCombo.getRawValue()+'&deptTypeDrStr='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=xls';
				}
	    	});
		}
	}
});

var detailReport = new Ext.Panel({
	id:'detailReport',
	layout:'border',
	height:700,
	title:'绩效核算收入汇总表',
	items:[{
		id: 'center_panel',
		region: 'center',
		layout: 'card',
		items: [{id:'first_center',html:''}]
	}],
	tbar:['核算月份:',monthCombo,'-','科室类别:',deptSetComb,'-',checkButton,'-',excelButton]
});


var userCode = session['LOGON.USERCODE'];
var monthCombo = new Ext.form.ComboBox({
	id:'monthCombo',
	fieldLabel:'�����·�',
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
	emptyText:'��ѡ������·�...',
	allowBlank: false,
	selectOnFocus: true,
	forceSelection: true 
});


var deptSetComb = new Ext.ux.form.LovCombo({
	id:'deptSetComb',
	fieldLabel: '�������',
	hideOnSelect: false,
	store: new Ext.data.Store({
		autoLoad: true,
		proxy: new Ext.data.HttpProxy({url: 'dhc.ca.incomdetailtab.csp?action=depttype'}),
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
	emptyText:'ѡ��������...',
	editable:false,
	anchor: '90%'
});


var CalButton = new Ext.Toolbar.Button({
	text:'����',        
	tooltip:'����',
	iconCls:'remove',        
	handler: function(){ 
		if((monthCombo.getValue()=="")||(deptSetComb.getValue()=="")){
			Ext.Msg.alert("��ʾ","����ѡ��������");
		}else{
			
					Ext.Ajax.request({
						url:'dhc.ca.checkblanceexe.csp?action=getUser&userCode='+userCode,
						waitMsg:'���ڲ�ѯ...',
						success: function(result,request){
							var jsonData = Ext.util.JSON.decode(result.responseText);
							var userInfo=jsonData.info;
							var aaa=encodeURI(encodeURI(userInfo));
					
							//��ȡ����
							
							var month=monthCombo.getValue();
							var deptSet=deptSetComb.getValue();
							
						
							//?????????��?????????????��
							Ext.Ajax.request({
								url:'dhc.ca.checkblanceexe.csp?action=cal&month='+monthCombo.getValue()+'&deptClass='+deptSetComb.getValue()+'&cost='+disCostSet+'&inItemDr='+inItemDr+'&costItemDr='+costItemDr+'&comDeptDr='+comDeptDr+'&comItemDr='+comItemDr,
								waitMsg:'���ڼ���...',
								timeout: 120000,
								success: function(result,request){	
									Ext.Msg.alert("��ʾ","����ɹ�!");
								}
							});
						}
					});
				}
	    }
			});


var checkButton = new Ext.Toolbar.Button({
	text:'��ѯ',        
	tooltip:'��ѯ',
	iconCls:'add',        
	handler: function(){
		if((monthCombo.getValue()=="")||(deptSetComb.getValue()=="")){
			Ext.Msg.alert("��ʾ","��ѡ�������");
		}else{
			Ext.Ajax.request({
				url:'dhc.ca.checkblanceexe.csp?action=getUser&userCode='+userCode+'&month='+monthCombo.getValue()+'&deptClass='+deptSetComb.getValue()+'&cost='+disCostSet+'&inItemDr='+inItemDr+'&costItemDr='+costItemDr+'&comDeptDr='+comDeptDr+'&comItemDr='+comItemDr,
				waitMsg:'��ѯ��...',
				success: function(result,request){
					//alert('dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode+'&month='+monthCombo.getValue()+'&deptClass='+deptSetComb.getValue()),
					var jsonData = Ext.util.JSON.decode(result.responseText);
					var userInfo=jsonData.info;
					var aaa=encodeURI(encodeURI(userInfo));
					var monName=monthCombo.getRawValue();
					var monName=encodeURI(encodeURI(monName));
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
								{tag: 'param', name: 'REPORT_URL', value: '../servlets/checkBlance/CheckBlance?month='+monthCombo.getValue()+'&monName='+monName+'&deptClass='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=print'}
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
	text:'����excel',        
	tooltip:'����excel',
	iconCls:'add',        
	handler: function(){ 
		if((monthCombo.getValue()=="")||(deptSetComb.getValue()=="")){
			Ext.Msg.alert("��ʾ","����ѡ��������");
		}else{
			var userCode = session['LOGON.USERCODE'];
	    	Ext.Ajax.request({
				url:'dhc.ca.checkblanceexe.csp?action=getUser&userCode='+userCode+'&month='+monthCombo.getValue()+'&deptClass='+deptSetComb.getValue()+'&cost='+disCostSet+'&inItemDr='+inItemDr+'&costItemDr='+costItemDr+'&comDeptDr='+comDeptDr+'&comItemDr='+comItemDr,
				waitMsg:'��������...',
				success: function(result,request){	
					var jsonData = Ext.util.JSON.decode(result.responseText);
					var userInfo=jsonData.info;
					var aaa=encodeURI(encodeURI(userInfo));
					var monName=monthCombo.getRawValue();
					var monName=encodeURI(encodeURI(monName));
					location.href = 'http://172.26.201.66:1969/dhccareport/servlets/checkBlance/CheckBlance?month='+monthCombo.getValue()+'&monName='+monName+'&deptClass='+deptSetComb.getValue()+'&userInfo='+aaa+'&outType=xls';
				}
	    	});
		}
	}
});


var detailReport = new Ext.Panel({
	id:'detailReport',
	layout:'border',
	height:700,
	title:'��Ч���������ܱ�',
	items:[{
		id: 'center_panel',
		region: 'center',
		layout: 'card',
		items: [{id:'first_center',html:''}]
	}],
	tbar:['�����·�:',monthCombo,'-','�������:',deptSetComb,'-',CalButton,'-',checkButton,'-',excelButton]
});


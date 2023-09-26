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

	var deptSetCombDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows',id:'id'},['id','name'])
	},['id', 'name']);	
	deptSetCombDs.on('beforeload', function(ds,o){	
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.ca.deptincomeitemtrendanlysexe.csp?action=depttype',method:'GET'})
	});
	var deptSetComb = new Ext.ux.form.LovCombo({
		id: 'deptSetComb',
		fieldLabel: '科室类别',
       	width:220,
		listWidth : 220,
		allowBlank: false,
		store: deptSetCombDs,
		valueField: 'id',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择科室类别...',
		name: 'deptSetComb',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		//forceSelection:true,
		editable:true
	});
	var deptDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows',id:'id'},['id','shortcut'])
	});
	//从数据源获取数据
	deptDs.on('beforeload', function(ds, o){	
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.ca.deptincomeitemtrendanlysexe.csp?action=entitydept&deptTypeDrStr='+Ext.getCmp('deptSetComb').getValue(),method:'GET'})
	});
	//初始化业务项名称域
	var dept = new Ext.form.ComboBox({
		id: 'dept',
		fieldLabel: '单元部门',
       	width:220,
        listWidth : 220,
        allowBlank: false,
		store: deptDs,
		valueField: 'id',
        displayField: 'shortcut',
 		triggerAction: 'all',
     	emptyText:'请选择单元部门...',
        name: 'dept',
        minChars: 1,
        pageSize: 10,
		selectOnFocus:true,
        forceSelection:'true',
		editable:true
	});
deptSetComb.on("select",function(cmb,rec,id ){
		searchFun(cmb.getValue());
	});
	
function searchFun(busTypeDr){
		deptDs.proxy = new Ext.data.HttpProxy({
			url:'dhc.ca.deptincomeitemtrendanlysexe.csp?action=entitydept&deptTypeDrStr='+Ext.getCmp('deptSetComb').getValue(),method:'GET'})
		deptDs.load({params:{start:0, limit:10}});
};
var checkButton = new Ext.Toolbar.Button({
	text:'查询',        
	tooltip:'查询',
	iconCls:'add',        
	handler: function(){
		if(monthCombo.getValue()==""){
			Ext.Msg.alert("提示","请选择核算月份！");
		}else{
			if(deptSetComb.getValue()==""){
				Ext.Msg.alert("提示","请选择科室类别！");
			}else{
				//准备数据
				Ext.Ajax.request({
					url:'dhc.ca.deptincomeitemtrendanlysexe.csp?action=readydatas&monthDrStr='+monthCombo.getValue()+'&deptDr='+dept.getValue()+'&deptTypeDrStr='+deptSetComb.getValue(),
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
											{tag: 'param', name: 'REPORT_URL', value: '../deptincomeitemtrendanlys?userInfo='+aaa+'&outType=print'+'&deptName='+encodeURI(encodeURI(deptSetComb.getRawValue()))}
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
	}
});

var excelButton = new Ext.Toolbar.Button({
	text:'生成excel',        
	tooltip:'生成excel',
	iconCls:'add',        
	handler: function(){ 
		if(monthCombo.getValue()==""){
			Ext.Msg.alert("提示","请选择核算月份！");
		}else{
			if(deptSetComb.getValue()==""){
				Ext.Msg.alert("提示","请选择科室类别！");
			}else{
				var userCode = session['LOGON.USERCODE'];
				//准备数据
				Ext.Ajax.request({
					url:'dhc.ca.deptincomeitemtrendanlysexe.csp?action=readydatas&monthDrStr='+monthCombo.getValue()+'&deptDr='+dept.getValue()+'&deptTypeDrStr='+deptSetComb.getValue(),
					waitMsg:'正在准备数据...',
					success: function(result,request){
						Ext.Ajax.request({
							url:'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode='+userCode,
							waitMsg:'正在生成...',
							success: function(result,request){
								var jsonData = Ext.util.JSON.decode(result.responseText);
								var userInfo=jsonData.info;
								var aaa=encodeURI(encodeURI(userInfo));
								var deptName=encodeURI(encodeURI(deptSetComb.getRawValue()));
								location.href = 'http://172.26.201.66:1969/dhccareport/deptincomeitemtrendanlys?userInfo='+aaa+'&outType=xls'+'&deptName='+deptName;
							}
						});
					}
				});
			}
		}
	}
});

var detailReport = new Ext.Panel({
	id:'detailReport',
	layout:'border',
	height:700,
	title:'科室收入项目趋势分析',
	items:[{
		id: 'center_panel',
		region: 'center',
		layout: 'card',
		items: [{id:'first_center',html:''}]
	}],
	tbar:['核算月份:',monthCombo,'-','科室类别:',deptSetComb,'-','单元部门（可选）:',dept,'-',checkButton,'-',excelButton]
});


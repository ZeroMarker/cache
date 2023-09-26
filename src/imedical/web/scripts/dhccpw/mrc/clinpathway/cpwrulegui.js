function InitWinRules(){
	var obj = new Object();
	var cpwRowid=arguments[0];
	obj.gridRulesStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridRulesStore = new Ext.data.Store({
		proxy: obj.gridRulesStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RuleId', mapping: 'RuleId'}
			,{name: 'RuleDesc', mapping: 'RuleDesc'}
			,{name: 'RuleActive', mapping: 'RuleActive'}
			,{name: 'RuleExpression', mapping: 'RuleExpression'}
		])
	});
	//obj.gridRulesCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridRules = new Ext.grid.GridPanel({
		id : 'gridRules'
		,store : obj.gridRulesStore
		,region : 'center'
		,loadMask : true
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '规则', width: 200, dataIndex: 'RuleDesc', sortable: true}
			,{header: '有效', width: 80, dataIndex: 'RuleActive', sortable: true,
		        renderer : function(v, p, record){
		        	p.css += ' x-grid3-check-col-td'; 
		        	return '<div class="x-grid3-check-col'+(v.indexOf('Y')==0?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		    	}
			}
		]
		,stripeRows : true
        ,autoExpandColumn : 'RuleDesc'
        ,bodyStyle : 'width:100%'
        ,autoWidth : true
        ,autoScroll : true
        ,viewConfig : {
            forceFit : true
        }
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
		,disabled : true
	});
	obj.panelEdit = new Ext.Panel({
		id : 'panelEdit'
		,height : 250
		,buttonAlign : 'center'
		,region : 'south'
		,frame : true
		,border : false
		,layout : 'fit'
		,items:[
		]
		,buttons:[
			obj.btnSave
		]
	});
	obj.panelCenter = new Ext.Panel({
		id : 'panelCenter'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,layout : 'border'
		,items:[
			obj.gridRules
			,obj.panelEdit
		]
	});
	obj.panelTreeTab = new Ext.Panel({
		id : 'panelTreeTab'
		,buttonAlign : 'center'
		,region : 'west'
		,frame : true
		,layout : 'fit'
		,width : 300
		,items:[]
	});
	obj.panelMain = new Ext.Panel({
		id : 'panelMain'
		,buttonAlign : 'center'
		,border : false
		,layout : 'border'
		,items:[
			obj.panelTreeTab,
			obj.panelCenter
		]
	});
	obj.WinRules = new Ext.Viewport({
		id : 'WinRules'
		,height : 520
		,buttonAlign : 'center'
		,width : 800
		,title : '监控维护'
		,layout : 'fit'
		,frame : true
		,closeAction: 'close'
		//,resizable:false
		,closable:true
		,modal: true
		,items:[
			obj.panelMain
		]
		,scope:this
	});
	
	obj.gridRulesStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.CheckRule';
			param.QueryName = 'QueryRule';
			param.Arg1 = cpwRowid;
			param.ArgCnt = 1;
	});
	obj.gridRulesStore.load({});
	InitWinRulesEvent(obj);
	//事件处理代码
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.gridRules.on("rowclick", obj.gridRules_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}
function InitpanelTypeA(){
	var obj = new Object();
	obj.panelTitle = new Ext.form.FormPanel({
		id : 'panelTitle'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,height : 60
		,bodyStyle  : 'padding: 10px; background-color: #DFE8F6'
		,region : 'north'
		,items:[
			{
				xtype:'textfield',
                fieldLabel: '规则名称',
                id: 'txtRuleDesc',
                allowBlank:false,
                anchor : '90%'
            },{
            	xtype:'textfield',
                fieldLabel: '项目名称',
                id: 'txtItemDesc',
                anchor : '90%',
                allowBlank:false,
                readOnly : true
            },{
            	xtype:'textfield',
                id: 'txtRuleId',
                hidden : true
            },{
            	xtype:'textfield',
                id: 'txtItemId',
                hidden : true
            }
		]
	});
	
	obj.TimeStandard = [
        ['1', '入院时间'],
        ['2', '入径时间']
    ];
	obj.TimeUnit = [
        ['D', '天'],
        ['H', '时'],
        ['M', '分']
    ];
    
	obj.combTimeStand = new Ext.form.ComboBox({
		id : 'combTimeStand'
		,store : new Ext.data.ArrayStore({
        		fields: ['Code', 'Desc'],
        		data : obj.TimeStandard
    			})
		,displayField : 'Desc'
		,fieldLabel : '基准时间'
		,editable : 'false'
		,valueField : 'Code'
		//,typeAhead: true
		,mode: 'local'
		,forceSelection: true
		,value: '1'
		,allowBlank:false
    ,triggerAction: 'all'
    ,emptyText:'Select a row...'
    ,selectOnFocus:true
		//,anchor : '60%'
	});
	
	obj.combTimeUnit = new Ext.form.ComboBox({
		id : 'combTimeUnit'
		,store : new Ext.data.ArrayStore({
        		fields: ['Code', 'Desc'],
        		data : obj.TimeUnit
    			})
		,displayField : 'Desc'
		,fieldLabel : '时间单位'
		,editable : 'false'
		,valueField : 'Code'
		,typeAhead: true
		,mode: 'local'
		,forceSelection: true
		,value: 'H'
		,allowBlank:false
    ,triggerAction: 'all'
    ,emptyText:'Select a row...'
    ,selectOnFocus:true
		//,anchor : '60%'
	});
	

	obj.formTypeA = new Ext.form.FormPanel({
		id : 'formTypeA'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,columnWidth : .6
		,region : 'center'
		,items:[
			{
            	xtype:'checkbox',
                fieldLabel: '有效',
                checked:true,
                id: 'chkActive'
            },
			obj.combTimeStand,
			obj.combTimeUnit
		]
	});

	obj.formTypeB = new Ext.form.FormPanel({
		id : 'formTypeB'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,columnWidth : .4
		,items:[
			{
            	xtype:'numberfield',
                fieldLabel: '最小时间',
                id: 'txtTimeMin',
                value: '0',
                allowBlank:false,
                anchor : '80%'
            },{
            	xtype:'numberfield',
                fieldLabel: '最大时间',
                id: 'txtTimeMax',
                value: '0',
                allowBlank:false,
                anchor : '80%'
            },
			{
            	xtype:'numberfield',
                fieldLabel: '最小数量',
                value: '0',
                allowBlank:false,
                id: 'txtQtyMin',anchor : '80%'
            },{
            	xtype:'numberfield',
                fieldLabel: '最大数量',
                value: '0',
                allowBlank:false,
                id: 'txtQtyMax',anchor : '80%'
            }
		]
	});
	obj.panelForm = new Ext.Panel({
		id : 'panelForm'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.formTypeA
			,obj.formTypeB
		]
	});
	/*
	*约定主Panel的名称,用于加载 panelExpression
	*/
	obj.panelExpression = new Ext.Panel({
		id : 'panelExpression'
		,buttonAlign : 'center'
		,frame : true
		,border : false
		,title : 'A类规则-绝对时间差'
		,layout : 'border'
		,renderTo : document.body
		,items:[
			obj.panelTitle
			,obj.panelForm
		]
	});
	InitpanelTypeAEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}
/*
 *B类型规则界面
*/
function InitpanelTypeB(){
	var obj=new Object()	
	obj.panelTitle = new Ext.form.FormPanel({
		id : 'panelTitle'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,height : 60
		,bodyStyle  : 'padding: 10px; background-color: #DFE8F6'
		,region : 'north'
		,items:[
			{
				xtype:'textfield',
                fieldLabel: '规则名称',
                id: 'txtRuleDesc',
                allowBlank:false,
                anchor : '90%'
            },{
            	xtype:'textfield',
                fieldLabel: '项目名称',
                id: 'txtItemDesc',
                anchor : '90%',
                allowBlank:false,
                readOnly : true
            },{
            	xtype:'textfield',
                id: 'txtRuleId',
                hidden : true
            },{
            	xtype:'textfield',
                id: 'txtItemId',
                hidden : true
            }
		]
	});
	obj.TimeStandard = [
        ['1', '入院时间'],
        ['2', '入径时间']
    ];
	obj.TimeUnit = [
        ['D', '天'],
        ['H', '时'],
        ['M', '分']
    ];
    
	obj.ItemStandard=new Ext.form.TextField({
		id:'ItemStandard',
		fieldLabel:'基准项目',
		readOnly:true,
		width:156
	});
	obj.ItemStandardId=new Ext.form.TextField({
		id:'ItemStandardId',
		hidden : true
	});
	obj.combTimeUnit = new Ext.form.ComboBox({
		id : 'combTimeUnit'
		,store : new Ext.data.ArrayStore({
        		fields: ['Code', 'Desc'],
        		data : obj.TimeUnit
    			})
		,displayField : 'Desc'
		,fieldLabel : '时间单位'
		,editable : 'false'
		,valueField : 'Code'
		,typeAhead: true
		,mode: 'local'
		,forceSelection: true
		,value: 'H'
		,allowBlank:false
    ,triggerAction: 'all'
    ,emptyText:'Select a row...'
    ,selectOnFocus:true
		//,anchor : '60%'
	});
	

	obj.formTypeA = new Ext.form.FormPanel({
		id : 'formTypeA'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,columnWidth : .6
		,region : 'center'
		,items:[
			{
            	xtype:'checkbox',
                fieldLabel: '有效',
                checked:true,
                id: 'chkActive'
            },
			obj.ItemStandard,
			obj.combTimeUnit
		]
	});
	obj.formTypeB = new Ext.form.FormPanel({
		id : 'formTypeB'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,columnWidth : .4
		,items:[
			{
            	xtype:'numberfield',
                fieldLabel: '最小时间',
                id: 'txtTimeMin',
                value: '0',
                allowBlank:false,
                anchor : '80%'
            },{
            	xtype:'numberfield',
                fieldLabel: '最大时间',
                id: 'txtTimeMax',
                value: '0',
                allowBlank:false,
                anchor : '80%'
            },
			{
            	xtype:'numberfield',
                fieldLabel: '最小数量',
                value: '0',
                allowBlank:false,
                id: 'txtQtyMin',anchor : '80%'
            },{
            	xtype:'numberfield',
                fieldLabel: '最大数量',
                value: '0',
                allowBlank:false,
                id: 'txtQtyMax',anchor : '80%'
            }
		]
	});
	obj.panelForm = new Ext.Panel({
		id : 'panelForm'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.formTypeA
			,obj.formTypeB
		]
	});
	/*
	*约定主Panel的名称,用于加载 panelExpression
	*/
	obj.panelExpression = new Ext.Panel({
		id : 'panelExpression'
		,buttonAlign : 'center'
		,frame : true
		,border : false
		,title : 'B类规则-相对时间差'
		,layout : 'border'
		,renderTo : document.body
		,items:[
			obj.panelTitle
			,obj.panelForm
		]
	});
	InitpanelTypeBEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}

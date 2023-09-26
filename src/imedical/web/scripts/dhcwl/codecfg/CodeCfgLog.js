(function(){
	Ext.ns("dhcwl.codecfg.CodeCfgLog");
})();
//////------------------------------------------------------------该页面用于查看统计组日志信息-------------------------------------------------
dhcwl.codecfg.CodeCfgLog=function(kpiId,kpiName){
	this.kpiId=kpiId,this.kpiName=kpiName;
	var outThis=this;
	var serviceUrl="dhcwl/codecfg/codecfgservice.csp";
	var outThis=this;
	var sm=new Ext.grid.RowSelectionModel({
		singleSelect:true
	});
	
	var getOperTypeCombo=new Ext.form.ComboBox({
		width : 100,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		value:'',
		name : 'getOperTypeCombo',
		id: 'getOperTypeCombo',
		displayField : 'isGlobal',
		valueField : 'isGlobalV',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{isGlobal}' +   
			'</div>'+   
			'</tpl>',
		stype:{
			"padding":"20px"
		},
		store : new Ext.data.JsonStore({
			fields : ['isGlobal', 'isGlobalV'],
			data : [{
				isGlobal : '',
				isGlobalV : ''
			},{
				isGlobal : '新增',
				isGlobalV : '1'
			}, {
				isGlobal : '删除',
				isGlobalV : '2'
			}, {
				isGlobal : '更新',
				isGlobalV : '3'
			}]}),
		listeners :{
		}
	});	
	
	var grpCombo=new Ext.form.ComboBox({
		width : 110,
		editable:false,
		listWidth : 250,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//emptyText:'请选择维度分类',
		name : 'grpComboName',
		id:  'grpComboId',
		displayField : 'cfglogName',
		valueField : 'cfglogCode',
		tpl:'<tpl for=".">' +   
            '<div class="x-combo-list-item" style="height:18px;">' +   
            '{cfglogName}' +   
        '</div>'+   
        '</tpl>',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/codecfg/codecfgservice.csp?action=getGrpCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'cfglogCode'},{name:'cfglogName'}])
		}),
		listeners :{
			'select':function(combox){
				grpCombo.setValue(combox.getRawValue());
			}
		}
	});
	
	
	var getModuleTypeCombo=new Ext.form.ComboBox({
		width : 100,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		value:'',
		name : 'getModuleTypeCombo',
		id : 'getModuleTypeCombo',
		displayField : 'isGlobal',
		valueField : 'isGlobalV',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{isGlobal}' +   
			'</div>'+   
			'</tpl>',
		stype:{
			"padding":"20px"
		},
		store : new Ext.data.JsonStore({
			fields : ['isGlobal', 'isGlobalV'],
			data : [{
				isGlobal : '',
				isGlobalV : ''
			},{
				isGlobal : '归集大组',
				isGlobalV : '1'
			}, {
				isGlobal : '归集子组',
				isGlobalV : '2'
			}, {
				isGlobal : '子组明细',
				isGlobalV : '3'
			}]}),
		listeners :{
		}
	});
	
	var sm=new Ext.grid.RowSelectionModel({singleSelect:true});
	var logDetailField=new Ext.form.TextField({
    	name:'executeCodeField',
    	listeners:{
    		'focus':function(field,eve){
    			var sm = codeCfgLogGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要查询的行！");
               		return;
				}
				var logID=record.get("logID");
				var operModule=record.get("operModule");
				if (operModule!="子组明细"){
					return;
				}
				detailStore.proxy.setUrl(encodeURI(serviceUrl+'?action=GetLogDetailInfor&logID='+logID));
				detailStore.load();
				logDetailGrid.show();
			    codeCfgDetailLogWin.show();
    		}
    	}
    });
	
    var columnModel=new Ext.grid.ColumnModel({
        defaults: {
            //sortable: true,
            width   :60,menuDisabled : true
        },
        columns: [
        new Ext.grid.RowNumberer(),{
			header:'ID',
			dataIndex:'logID',
			hidden:true
		}, {
            header: '操作日期',
            dataIndex: 'operDate',
            width:100
        },{
			header: '操作时间',
            dataIndex: 'operTime',
            width:100
		},{
            header: '用户ID',
            dataIndex: 'userID'
        },{
            header: '用户名',
			width:100,
            dataIndex: 'userName'
        }, {
            header: '用户IP',
            width:100,
            dataIndex: 'userIP'
        }, {
            header: '操作类型',
            width:80,
            dataIndex: 'operType'
        },{
            header: '模块类型',
            dataIndex: 'operModule',
            width:100,
			renderer : function(value) {
				if (value == '子组明细') {
					return "<span style='color:blue;font-weight:bold;'>子组明细</span><img src='../images/uiimages/createschedule.png' />";
				}else{
					return value;
				}
			},
			editor:new Ext.grid.GridEditor(logDetailField)
        },{
			header:'模块信息',
			width:240,
			dataIndex:'dependMoudle',
		},{
			header:'统计组属性',
			width:540,
			dataIndex:'dependSubGrp',
		}]
    });
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=GetLogInfor"}), 
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'logID'},
            	{name: 'operDate'},
            	{name: 'operTime'},
        		{name: 'userID'},
        		{name: 'userName'},
            	{name: 'userIP'},
            	{name: 'operType'},
				{name: 'operModule'},
				{name:'dependMoudle'},
				{name:'dependSubGrp'}
       		]
    	})
    });
    var codeCfgLogGrid=new Ext.grid.EditorGridPanel({
        frame: true,
        store: store,
        cm: columnModel,
        sm:sm,
		clicksToEdit: 1,
		trackMouseOver : true,
        bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),
		 tbar: new Ext.Toolbar([{
            html: '用户名：'
        },{
			xtype:'textfield',
			name: 'searchName',
			id	: 'searchName',
			enableKeyEvents: true,
			listeners :{
				'keypress':function(ele,event){
				}
			}
		},'-',{
			html:'归集大组:'
		},grpCombo,'-',{
			html:'模块类型:'
		},getModuleTypeCombo,'-',{
			html:'操作类型:'
		},getOperTypeCombo,'-',{
			html:'操作日期：'
		},{
			xtype:'datefield',
            //format :'Y-m-d',
			format:GetWebsysDateFormat(),
            name: 'updateDate',
            id:'updateDate',
			editable:false ,
            width:100
		},'-',{
			text:'<span style="line-Height:1">查找</span>',
			icon: '../images/uiimages/search.png',
			handler:function(){
				var GrpName=Ext.get('searchName').getValue();
                var GrpModType=Ext.get('getModuleTypeCombo').getValue();
				var GrpOperType=Ext.get('getOperTypeCombo').getValue();
              	var GrpDate=Ext.get('updateDate').getValue(); 
				var GrplogCombo=Ext.get('grpComboId').getValue();
				//alert(GrplogCombo);
				//return;
				store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetLogInfor&start=0&limit=20&searchName='+GrpName+'&modType='+GrpModType+'&operType='+GrpOperType+'&date='+GrpDate+'&grpCode='+GrplogCombo+'&grpFlag=1'+'&onePage=1'));
				store.load();
				codeCfgLogGrid.show();
				//alert(GrpName+"#"+GrpModType+"#"+GrpOperType+"#"+GrpDate);
			}
			
		},'-',{
		   text: '<span style="line-Height:1">清空</span>',
		   icon: '../images/uiimages/clearscreen.png',
    	   handler:function(){
			   var value1=Ext.getCmp('searchName').setValue('');
               var value2=Ext.getCmp('getModuleTypeCombo').setValue('');
			   var value3=Ext.getCmp('getOperTypeCombo').setValue('');
               var value4=Ext.getCmp('updateDate').setValue('');
			   var value5=Ext.getCmp('grpComboId').setValue('');			   
    	   }
       }]),listeners: { 'beforeedit': function (editor) {
            if (editor.value != '子组明细') return false;
            return true;
        }
	   }
    });
    var codeCfgLogWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 1050,
		height : 550,
		autoScroll:true,
		plain : true,
		title : '统计子组日志展示',
		id : 'dhcwl_codecfg_codecfglog',
		items : codeCfgLogGrid,
		listeners:{
			'close':function(){
				//codeCfgDetailLogWin.close();
				codeCfgDetailLogWin.destroy();
				//codeCfgLogWin.close();
				codeCfgLogWin.destroy();
			}
		}
	});
	//----------------------------------------------------------------以上是主界面设计-------------------------------------------------------
	var detailSm=new Ext.grid.RowSelectionModel({
		singleSelect:true
	});
	
	var detailColumn=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :60,menuDisabled : true
        },
        columns: [
        new Ext.grid.RowNumberer(),{
            header: '字段名称',
			width:120,
            dataIndex: 'name'
        },{
            header: '明细值',
            width:380,
            dataIndex: 'value'
        }, {
            header: '类型',
            width:150,
            dataIndex: 'type'
        }]
    });
	
	var tempKpiId=0;
    var detailStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=GetKpiDimList&kpiId="+tempKpiId}), 
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'name'},
            	{name: 'value'},
            	{name: 'type'}
       		]
    	})
    });
    var logDetailGrid=new Ext.grid.EditorGridPanel({
        frame: true,
        store: detailStore,
        cm: detailColumn,
        sm:detailSm/*,
        bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        })*/
    });
	
	var codeCfgDetailLogWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 750,
		height : 550,
		autoScroll:true,
		plain : true,
		closable:true, 
		closeAction:'hide', 
		title : '日志明细信息展示',
		id : 'codecfgDetaillog',
		items : logDetailGrid,
		listeners:{
		}
	});
	
	this.show=function(id,kpiName){
		/*tempKpiId=id;
		this.kpiId=id,this.kpiName=kpiName;
		kpiDimWin.setTitle('指标维度维护--'+kpiName);*/
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetLogInfor&start=0&limit=20&searchName=&modType=&operType=&date=&grpFlag=1&onePage=1'));
		store.load();
		codeCfgLogGrid.show();
		codeCfgLogWin.show();
	}
}
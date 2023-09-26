var userid=session['LOGON.USERNAME'];
var deptDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomecollectexe.csp'
								+ '?action=getDept&str='
								+ encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()),
						method : 'POST'
					})
		});

var deptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '科室',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : deptDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'deptCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
//用于查询
var sDeptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '科室',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : deptDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'deptCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
		
//
//	科室
var tariffTypeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

tariffTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomerateexe.csp'
								+ '?action=getItem&str='
								+ encodeURIComponent(Ext.getCmp('tariffTypeCombo').getRawValue()),
						method : 'POST'
					})
		});

var tariffTypeCombo = new Ext.form.ComboBox({
			id : 'tariffTypeCombo',
			fieldLabel : '收费类别',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : tariffTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'tariffTypeCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
//用于查询
//	科室
var stariffTypeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

stariffTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomerateexe.csp'
								+ '?action=getItem&str='
								+ encodeURIComponent(Ext.getCmp('sTariffTypeCombo').getRawValue()),
						method : 'POST'
					})
		});

var sTariffTypeCombo = new Ext.form.ComboBox({
			id : 'sTariffTypeCombo',
			fieldLabel : '收费类别',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : stariffTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'sTariffTypeCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
/*
var sikeType = new Ext.form.ComboBox({												
				fieldLabel: '病人类别',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '门诊'], ['2', '住院'],['3', '急诊'], ['4', '体检'], ['9', '其它']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '0',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});	
			
//用于查询

var ssickType = new Ext.form.ComboBox({												
				fieldLabel: '病人类别',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['0', '全部'], ['1', '门诊'], ['2', '住院'],['3', '急诊'], ['4', '体检'], ['9', '其它']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				//value : '0',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});	
			*/
			var deptGroupDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptGroupDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomerateexe.csp'
								+ '?action=getDeptGroup&str='
								+ encodeURIComponent(Ext.getCmp('deptGroupCombo').getRawValue()),
						method : 'POST'
					})
		});

var deptGroupCombo = new Ext.form.ComboBox({
			id : 'deptGroupCombo',
			fieldLabel : '科室',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : deptGroupDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'deptGroupCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
//用于查询
	var sdeptGroupDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

sdeptGroupDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomerateexe.csp'
								+ '?action=getDeptGroup&str='
								+ encodeURIComponent(Ext.getCmp('sdeptGroupCombo').getRawValue()),
						method : 'POST'
					})
		});
var sDeptGroupCombo = new Ext.form.ComboBox({
			id : 'sdeptGroupCombo',
			fieldLabel : '科室',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : deptGroupDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'sdeptGroupCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
			

var auditbutton = new Ext.Toolbar.Button(
		{
			text : '审核',
			tooltip : '审核',
			iconCls : 'option',
			handler : function() {
				var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");     
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincomerateexe.csp?action=audit&rowid='+rowid+"&checker="+userid,
		
				waitMsg:'审核中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'审核成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({params:{start:0, limit:25}});		
				}
				},
				scope: this
				});
			}
});


var unauditbutton = new Ext.Toolbar.Button(
		{
			text : '取消审核',
			tooltip : '取消审核',
			iconCls : 'option',
			handler : function() {
			var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");     
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincomerateexe.csp?action=unaudit&rowid='+rowid+"&c+hecker="+userid,
		
				waitMsg:'取消审核中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'取消审核成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({params:{start:0, limit:25}});		
				}
				},
				scope: this
				});
			}
		});
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'option',
			handler : function() {

				if (sTariffTypeCombo!=undefined){
			 var tartype = sTariffTypeCombo.getValue();

				}
					
				if (sdeptGroupCombo!=undefined){	
			 var sicktype =sDeptGroupCombo.getValue();
				}

				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								tartype : tartype,
								DeptGroupName : sicktype
							}
						});

			}
			
		})
    function pctChange(val) {
        if (val > 0) {
            return '<span >' + val*100 + '%</span>';
        } else if (val < 0) {
            return '<span >' + val*100 + '%</span>';
        }
        return val;
    }
var itemGrid = new dhc.herp.Grid({
        title: '收入计提比例维护',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusincomerateexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
		   	 id:'rowid',
		     header: 'rowid',
		     //allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'rowid'
		}, {
		     id:'IncItemCode',
		     header: '收费类别',
		     allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'IncItemCode',
		     type:tariffTypeCombo
		}, {
		     id:'DeptGroupName',
		     header: '科室组',
		     //allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'DeptGroupName',
		     type:deptGroupCombo
		}, {
		     id:'makebilldeptrate',
		     header: '开单提成比例',
		     //allowBlank: false,
		     width:100,
		     align:'right',
		     renderer : pctChange, 
		     editable:true,
		     dataIndex: 'makebilldeptrate'
		}, {
		     id:'executedeptrate',
		     header: '执行提成比例',
		     //allowBlank: false,
		     align:'right',
		     renderer : pctChange, 
		     width:100,
		     editable:true,
		     dataIndex: 'executedeptrate'
		}, {
		     id:'sickdeptrate',
		     header: '病人科室提成比例',
		     align:'right',
		     //allowBlank: false,
		     renderer : pctChange, 
		     width:100,
		     editable:true,
		     dataIndex: 'sickdeptrate'
		}, {
		     id:'checkman',
		     header: '审核人',
		     //allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'checkman'
		}, {
		     id:'checkdate',
		     header: '审核时间',
		     //allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'checkdate'
		}, {
		     id:'updatedate',
		     header: '更新时间',
		    // allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'updatedate'
		}, {
		     id:'state',
		     header: '数据状态',
		     //allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'state'
		}],
        
        tbar:['收费类型:',sTariffTypeCombo,'科室组:',sDeptGroupCombo,findButton,auditbutton,'-',unauditbutton]
        
});
 //定义修改按钮响应函数
auditHandler = function(){
		
       
};
//itemGrid.tbar.push(auditbutton);
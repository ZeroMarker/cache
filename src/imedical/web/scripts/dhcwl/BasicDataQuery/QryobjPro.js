(function(){
	Ext.ns("dhcwl.BDQ.QryobjPro");
})();
dhcwl.BDQ.QryobjPro=function(){
	var serviceUrl="dhcwl/basedataquery/qryobjpro.csp";
	var outThis=this;
	//Ext.QuickTips.init();
	//Ext.form.Field.prototype.msgTarget = 'side';
	var columnModel = new Ext.grid.ColumnModel([
		{header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true
		},{header:'查询对象',dataIndex:'queryObj',sortable:true, width: 100, sortable: true ,menuDisabled : true
        },{header:'属性编码',dataIndex:'proCode',sortable:true, width: 100, sortable: true ,menuDisabled : true
        },{header:'属性名称',dataIndex:'proName', width: 100, sortable: true ,menuDisabled : true
        },{header:'属性描述',dataIndex:'proDesc', width: 160, sortable: true,menuDisabled : true
        },{header:'执行代码',dataIndex:'proExeCode', width: 160, sortable: true,menuDisabled : true}
		
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=lookupObjPro'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'queryObj'},
            	{name: 'proCode'},
            	{name: 'proName'},
            	{name: 'proDesc'},
            	{name: 'proExeCode'}
       		]
    	})
    });

    var proGrid = new Ext.grid.GridPanel({
        height:480,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
            		var id=rec.get("ID");
            		var form=proForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({ID:id});
             	}
            }
        })
    });
    var proForm = new Ext.FormPanel({
        /*
		frame: true,
        height: 145,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
             		"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        		},
        layout: 'table',
        defaultConfig:{width:130},
        layoutConfig: {columns:6},
        items:[{
        	html: 'ID：'
        },{
            xtype:'textfield',
            name: 'ID',
            disabled:true,
            flex:1
        },{
        	html: '查询对象：'
        },{
			allowBlank:false,
			xtype:'combo',
			id:'queryObj',
			mode:'local',			
			triggerAction:  'all',
			editable: false,
			displayField:   'Descript',
			valueField:     'Name',
			store:new Ext.data.Store({
					proxy: new Ext.data.HttpProxy({url:'dhcwl/basedataquery/queryobj.csp?action=getBDQObj'}),
					reader: new Ext.data.JsonReader({
						totalProperty: 'totalNum',
						root: 'root',
						fields:[
							{name: 'Descript'},
							{name: 'Name'}
						]
					})
				}),	
			mode:           'remote',
			triggerAction:  'all',
			//forceSelection: true,
			//editable:       false,				
			typeAhead: true,
			// transform the data already specified in html
			listClass: 'x-combo-list-small'				
			
		},{
        	html: '属性编码：'
        },{
            xtype:'textfield',
            name: 'proCode',
            id: 'proCode',
			allowBlank: false,
			msgTarget: 'side',			
			
            flex:1
        },{
            html: '属性名称：'
        },{
            name: 'proName',
            id: 'proName',
            xtype:'textfield',
            flex:1
        },{
            html:'属性描述：'
        },{
            name:'proDesc',
            id:'proDesc',
            xtype:'textfield',
            flex:1
        },{
            html: '执行代码：'
         },{
            xtype:'textfield',
            name: 'proExeCode',
            id: 'proExeCode'
        }],//{buttons: 
		*/
		labelAlign : 'right',
    	frame:true,
		height: 145,
		labelWidth : 85,
		layout : 'column',
		items:[
		{
			columnWidth : .3,
			layout : 'form',
			defaultType : 'textfield',
			defaults: {
					allowBlank : false
			},
			items : [{
							fieldLabel : 'ID',
							xtype:'textfield',
            				name: 'ID',
            				anchor:'85%',
							disabled:true							
											
					},{
							fieldLabel : '属性名称',
            				xtype:'textfield',
            				name: 'proName',
            				anchor:'85%'			
					}]
		},{
			columnWidth : .3,
			layout : 'form',
			defaultType : 'textfield',
			defaults: {
					allowBlank : false
			},
			items : [{
						fieldLabel : '查询对象',
						anchor:'85%',
						allowBlank:false,
						xtype:'combo',
						id:'queryObj',
						name:'queryObj',						
						triggerAction:  'all',
						editable: false,
						displayField:   'Descript',
						valueField:     'Name',
						store:new Ext.data.Store({
								proxy: new Ext.data.HttpProxy({url:'dhcwl/basedataquery/queryobj.csp?action=getBDQObj'}),
								reader: new Ext.data.JsonReader({
									totalProperty: 'totalNum',
									root: 'root',
									fields:[
										{name: 'Descript'},
										{name: 'Name'}
									]
								})
							}),	
						mode:           'remote',		
						typeAhead: true				
					},{
						fieldLabel : '属性描述',
						xtype:'textfield',
						name: 'proDesc',
						anchor:'85%',
						allowBlank : true						
					}]
		},{
			columnWidth : .3,
			layout : 'form',
			defaultType : 'textfield',
			defaults: {
					allowBlank : false
			},
			items : [{
							fieldLabel : '属性编码',
							xtype:'textfield',
            				name: 'proCode',
            				anchor:'85%'						
											
					},{
							fieldLabel : '执行代码',
            				xtype:'textfield',
            				name: 'proExeCode',
            				anchor:'85%'			
					}]
		}]
		
		
		
		
		,
        tbar:new Ext.Toolbar([{
            text: '添加属性',
            handler: function(){
				var insData = {
					ID: "",
					queryObj: "",
					proCode: "",
					proName: "",
					proDesc:"",
					proExeCode:""
				};
				var p = new store.recordType(insData); // create new record
				
                proGrid.stopEditing();
                store.insert(0, p);
                var sm = proGrid.getSelectionModel();
                sm.selectFirstRow();
            }
        }, '-', {
            text: '删除属性',
            handler: function(){
            	 var sm = proGrid.getSelectionModel();
                 var record = sm.getSelected();
                 if(!sm||!record){
               		alert("请选择要删除的属性！");
               		return;
               	 }
                Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID");
                        store.remove(record);
						if (ID=="") return;
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteQryobjPro&ID='+ID,"",function(jsonData){
							if(jsonData.success==true && jsonData.tip=="ok"){
								//store.reload();
								Ext.Msg.alert("提示","操作成功！");
							}else{
								Ext.Msg.alert("操作失败",jsonData.MSG);
							}
						},this)
                		outThis.clearForm();
                    }
                });
            }
        }, '-',{
        	text   : '保 存',
            handler: function() {
				if (!proForm.form.isValid()) {
					Ext.Msg.alert("提示","请录入完整的属性信息！");
					return;
				}
            	var proform=proForm.getForm();
                var sm = proGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要保存的属性！");
               		return;
                }
                var ID=record.get("ID");
                var proCode=proform.findField("proCode").getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||_]/;var reg2=/^\d/;
                if(reg.test(proCode)||(reg2.test(proCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||,_等特殊字符，并且不能以数字开头");
                	Ext.get("proCode").focus();
                	return;
                }

				dhcwl.mkpi.Util.ajaxExc(serviceUrl,
				{
					action:"saveQryobjPro",
					ID: ID,
					queryObj: proform.findField("queryObj").getValue(),
					proCode: proform.findField("proCode").getValue(),
					proName: proform.findField("proName").getValue(),
					proDesc: proform.findField("proDesc").getValue(),
					proExeCode: proform.findField("proExeCode").getValue()
				},function(jsonData){
					if(jsonData.success==true && jsonData.tip=="ok"){
						store.reload();
						Ext.Msg.alert("提示","操作成功！");
					}else{
						Ext.Msg.alert("操作失败",jsonData.MSG);
					}
				},this);

           }
    	},'-',{text   : '清 空',
            handler: function() {
            	outThis.clearForm();
            	return;
			}
        },'-',{
			text   : '刷 新',
            handler: function() {
            	store.reload();
            	return;		
				}	
			
		}/*,'-',{text   : '查 找',
            handler: function() {
                var KDTCode=Ext.get('KDTCode').getValue();
                var KDTName=Ext.get('KDTName').getValue();
                var KDTDesc=Ext.get('KDTDesc').getValue();
                var KDTExeCode=Ext.get('KDTExeCode').getValue();
                var KDTRemark=Ext.get('KDTRemark').getValue();
                var KDTUpdateDate=Ext.get('KDTUpdateDate').getValue();
                var KDTUser=Ext.get('KDTUser').getValue();
                paraValues='KDTCode='+KDTCode+'&KDTName='+KDTName+'&KDTDesc='+KDTDesc+'&KDTExeCode='+KDTExeCode;
                paraValues+='&KDTRemark='+KDTRemark+'&KDTUpdateDate='+KDTUpdateDate+'&KDTUser='+KDTUser;
				store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearch&className=DHCWL.BaseDataQuery.CustomDimType&"+paraValues+"&start=0&limit=21&onePage=1"));
            	store.load();
    			proGrid.show();
           }
        } */
		])
    });

    var proPanel =new Ext.Panel({
		closable:true,
    	title:'维护对象属性',
    	layout:'border',
        items: [{
        	region: 'north',
            height: 148,
            autoScroll:true,
            items:proForm
        },{
        	region:'center',
        	autoScroll:true,
            items:proGrid
    	}],
    	listeners:{
    		"resize":function(win,width,height){
    			proGrid.setHeight(height-150);
    			proGrid.setWidth(width-15);
    		}
    	}
    });
     proPanel.on('afterrender',function( th ){
 		store.load({params:{start:0,limit:21}});
	});	

    //以下为对外的接口方法。
    this.getProPanel=function(){
    	return proPanel;
    }

    this.clearForm=function(){
    	var form=proForm.getForm();
		form.setValues({
					ID: "",
					queryObj: "",
					proCode: "",
					proName: "",
					proDesc:"",
					proExeCode:""
		})
     }
	
}


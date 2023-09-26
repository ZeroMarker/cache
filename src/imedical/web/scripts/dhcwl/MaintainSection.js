dhcwl.mkpi.MaintainSection=function(){
	//var parentWin=null;
	var serviceUrl="dhcwl/kpi/kpiservice.csp";
	var outThis=this;
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:160,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'维护区间维度属性',
    			handler:function(cmp,event){
    				var sm = sectionGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                    var dimId=record.get('ID'),dimName=record.get('SecName');
                    getDimPro().show(dimId,dimName);
    			}
    		},
    		{
    			text:'导出到Excel文件',
    			handler:function(){
    				var excelObj=new dhcwl.mkpi.util.Excel();
    				excelObj.setTitle("区间导出");
    				excelObj.setHead(['ID','区间编码','区间描述','直接父区间','区间名称','备注','创建/更新日期','创建者']);
    				excelObj.setServerUrl(serviceUrl+'?action=mulSearch&className=DHCWL.MKPI.Section&session=SEC&isArrayType=1');
    				excelObj.exportExcel();
    			}
    		}]
	});
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true
        },{header:'区间编码',dataIndex:'SecCode',sortable:true, width: 100, sortable: true,menuDisabled : true
        },{header:'区间名称',dataIndex:'SecName', width: 100, sortable: true,menuDisabled : true
        },{header:'区间描述',dataIndex:'SecDesc', width: 160, sortable: true,menuDisabled : true
        },{header:'创建者',dataIndex:'SecUser', width: 160, sortable: true,menuDisabled : true
        },{header:'创建/更新日期',dataIndex:'SecUpdateDate', width: 100, sortable: true,menuDisabled : true
        },{header:'备注',dataIndex:'SecRemark', width: 80, sortable: true,menuDisabled : true
        },{header:'直接父区间',dataIndex:'SecDirectParent', width: 80, sortable: true,menuDisabled : true
        }
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearch&session=SEC&className=DHCWL.MKPI.Section'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'SecCode'},
            	{name: 'SecName'},
            	{name: 'SecDesc'},
            	{name: 'SecUser'},
            	{name: 'SecUpdateDate'},
            	{name: 'SecRemark'},
            	{name: 'SecDirectParent'}
       		]
    	})
    });
    var Record = Ext.data.Record.create([
    	{name: 'ID',type:'integer'},
    	{name: 'SecCode'},
        {name: 'SecName'},
        {name: 'SecDesc'},
        {name: 'SecUser'},
        {name: 'SecUpdateDate'},
        {name: 'SecRemark'},
        {name: 'SecDirectParent'}
    ]);
    var sectionGrid = new Ext.grid.GridPanel({
        height:508,
        store: store,
        cm: columnModel,
		viewConfig: {forceFit: true},
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
                	//sectionForm.getForm().loadRecord(rec);
                	var id=rec.get("ID");
            		var form=sectionForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({ID:id});
             	}
            }
        }),
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	}
        },
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),
        tbar: new Ext.Toolbar([/*
        {
            text: '添加指标区间',
            handler: function(){
				var date=dhcwl.mkpi.Util.nowDate();
                var initValue = {SecCode:'',SecName:'',SecDesc:'',SecUser:'',SecRemark:'',SecUpdateDate:date,SecDirectParent:''};
                var p = new Record(initValue);
                sectionGrid.stopEditing();
                store.insert(0, p);	
            }
        }, '-', {
            text: '删除指标类型',
            handler: function(){
                Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                        var sm = sectionGrid.getSelectionModel();
                        var record = sm.getSelected();
                        if(!sm||!record){
               				alert("请单击选择一行！");
               				return;
               			}
                        var SecCode=record.get("SecCode");
                        
                        dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteKpiSection&SecCode='+SecCode
                		,null,function(jsonData){
                			if(jsonData.tip!="ok"){
                				Ext.Msg.show({title:'错误',msg:"该区间下已经存在指标任务，删除区间会对任务又影响。您可以选择更新操作。",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                				Ext.Msg.confirm('信息', '删除区间会删除该区间下的所有任务，现在确定要删除吗？', function(btn){
                    				if (btn == 'yes') {
                    					store.remove(record);
                						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteKpiSectionWidthTask&SecCode='+SecCode);
                						outThis.refresh();
                    				}
                    			});
                			}
                		},outThis);
                    }
                });
            }
        }, '-', {
            text: '选定纬度',
            handler: function(){
               var sm=sectionGrid.getSelectionModel();         
               var record=sm.getSelected();
               if(!sm||!record){
               		alert("请单击选择一行！");
               		return;
               }
               dhcwl.mkpi.MaintainSection.parentWin.setKpiFormFile({section:record.get("SecName")});
               mainWin.close();
            }
    	}*/])
    });
    var parentFiledGrid=new Ext.grid.GridPanel({
    	width:200,
    	autoHeight:true,
    	title:'父区间选择',
    	store:new Ext.data.Store({
        	proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=sectionList'}),
        	reader: new Ext.data.JsonReader({
            	totalProperty: 'reslut',
            	root: 'root',
        		fields:[
            		{name: 'SecCode'},
            		{name: 'SecName'}
       			]
    		})
    	}),
    	columns:[{
    		header:'区间编码',dataIndex:'SecCode'
    	},{
    		header:'区间名称',dataIndex:'SecName'
    	}],
    	viewConfig:{forceFit:true}
    });
    var parentFiledSelectMenu=new Ext.menu.Menu({
    	boxMinWidth:200,
		ignoreParentClicks:true,
    	items:[parentFiledGrid]
    });
    parentFiledGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=sectionList'));
    parentFiledGrid.getStore().load();
    parentFiledGrid.show();
    /*
    var parentFiled=new Ext.form.TriggerField({
    	fieldLabel:'直接父区间',
    	name:'SecDirectParent',
    	disabled:true,
    	onSelect:function(record){
    		
    	},
    	onTriggerClick:function(){
    		
    		if(this.menu==null){
    			this.menu=parentFiledSelectMenu;
    		}
    		this.menu.show(this.el,"tl-bl?");
    	}
    });
    */
    var sectionCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//emptyText:'请选择指标区间',
		fieldLabel : '直接父区间',
		//name : 'sectionCombo',
		name : 'SecDirectParent',
		displayField : 'secName',
		valueField : 'secCode',
		
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{secName}' +   
			'</div>'+   
			'</tpl>',			
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getSectionCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'secCode'},{name:'secName'}])
		}),
		listeners :{
			'select':function(combox){
				//sectionCombo.setValue(combox.getRawValue());
			},
    		'expand':function(){
    			sectionCombo.getStore().load();
    		}
		}
	});    
    
    
    
    parentFiledGrid.on("rowclick",function(grid,rowIndex,e){
    	parentFiledSelectMenu.hide();
    	var sm=grid.getSelectionModel();
        var record = sm.getSelected();
        var v=record.get("SecCode");
    	parentFiled.setValue(v);
    });
    var enforceCheck=new Ext.form.Checkbox({
        xtype:'checkbox',
        checked: true,
        boxLabel: '是否强制维护区间之间的顺序关系？',
        name: 'isEnforce'
    });
  //modify by wk ~2017-03-16~公司UI标准修改
    /*var sectionForm = new Ext.FormPanel({
        frame: true,
        height: 145,
        labelAlign: 'left',
        //title: '指标区间列表',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        layoutConfig: {columns:8},
        items:[{
        	html: 'ID：'
        },{
            xtype:'textfield',
            name: 'ID',
            //id: 'ID',
            disabled:true,
            anchor:'95%'
        },{
        	html: '区间编码：'
        },{
            xtype:'textfield',
            name: 'SecCode',
            id: 'SecCode',
            anchor:'95%'
            //validator:dhcwl.mkpi.Util.valideValue
        },{
            html: '区间名称：'
        },{
            name: 'SecName',
            id: 'SecName',
            xtype:'textfield',
            anchor:'95%'
        },{
            html:'区间描述：'
        },{
            name:'SecDesc',
            id:'SecDesc',
            xtype:'textfield',
            flex:1
        },{
            html: '创建者：'
        },{
            name: 'SecUser',
            id: 'SecUser',
            xtype:'textfield',
            flex:1
        }, {
            html: '创建/更新日期：'
        },{
            xtype:'datefield',
            //format :'Y-m-d',
            name: 'SecUpdateDate',
            id: 'SecUpdateDate',
            width:130,
            flex:1
        },{
            html: '备注：'
        },{
        	xtype:'textfield',
            name: 'SecRemark',
            id: 'SecRemark'
        },{
            html: '直接父区间：'
        //},parentFiled],//{buttons: 	//modify by wz. 2015-6-20
        },sectionCombo],*/
    var sectionForm = new Ext.FormPanel({
    	frame : true,
		height : 127,
		bodyStyle:'padding:5px',
		labelAlign : 'right',
		labelWidth : 90,
		style : {
			"margin-right" : Ext.isIE6? (Ext.isStrict ? "-10px" : "-13px"): "0"
		},
		items : [{
			layout : 'column',
			items : [{ 
				columnWidth : .20,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 110
				},
				items : [{
							fieldLabel : 'ID',
							xtype:'textfield',
				            name: 'ID',
				            disabled:true
						},{
							fieldLabel : '创建者',
							name: 'SecUser',
				            id: 'SecUser',
				            xtype:'textfield'
						}]
			},{ 
				columnWidth : .20,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 110
				},
				items : [{
							fieldLabel : '区间编码',
							xtype:'textfield',
				            name: 'SecCode',
				            id: 'SecCode'
						},{
							fieldLabel : '更新日期',
							xtype:'datefield',
				            name: 'SecUpdateDate',
				            id: 'SecUpdateDate',
							format:GetWebsysDateFormat()
						}]
			},{ 
				columnWidth : .20,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 110
				},
				items : [{
							fieldLabel : '区间名称',
							name: 'SecName',
				            id: 'SecName',
				            xtype:'textfield'
						},{
							fieldLabel : '备注',
							xtype:'textfield',
				            name: 'SecRemark',
				            id: 'SecRemark'
						}]
			},{ 
				columnWidth : .20,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 110
				},
				items : [{
							fieldLabel : '区间描述',
							name:'SecDesc',
				            id:'SecDesc',
				            xtype:'textfield'
						},sectionCombo]
			}]
		}],
        tbar:new Ext.Toolbar([enforceCheck,'-',{
            //text: '刷新',
            text: '<span style="line-Height:1">刷新</span>',
            icon: '../images/uiimages/reload2.png',
            handler: function(){
				parentFiledGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=sectionList'));
   	 			parentFiledGrid.getStore().load();
    			parentFiledGrid.show();
    			store.proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=lookupObj&className=DHCWL.MKPI.Section&start=1&limit=21'));
				store.load();
    			sectionGrid.show();
            }
        }, '-',{
           //text: '新增',
            text: '<span style="line-Height:1">新增</span>',
            icon: '../images/uiimages/edit_add.png',
            handler: function(){
				var date=dhcwl.mkpi.Util.nowDate();
                var initValue = {ID:'',SecCode:'',SecName:'',SecDesc:'',SecUser:'',SecRemark:'',SecUpdateDate:date,SecDirectParent:''};
                var p = new Record(initValue);
                sectionGrid.stopEditing();
                store.insert(0, p);
                var sm = sectionGrid.getSelectionModel();
                sm.selectFirstRow();
            }
        }, '-', {
            //text: '删除',
            text: '<span style="line-Height:1">删除</span>',
            icon: '../images/uiimages/edit_remove.png',
            handler: function(){
            	var sm = sectionGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要删除的区间！");
               		return;
               	}
                Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                        var SecCode=record.get("SecCode");
                        var enforce=enforceCheck.getValue();
                        if(enforce){
                        	alert("现在要求强制维护区间顺序，不能进行删除");
                        	return;
                        }
                        dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteKpiSection&SecCode='+SecCode+'&flag=0'
                		,null,function(jsonData){
                			//alert(jsonData.tip);
                			if(jsonData.tip!="ok"){
                				Ext.Msg.show({title:'错误',msg:"该区间下已经存在指标任务，删除区间会对任务又影响。您可以选择更新操作。",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                				Ext.Msg.confirm('信息', '删除区间会删除该区间下的所有任务，现在确定要删除吗？', function(btn){
                    				if (btn == 'yes') {
                    					store.remove(record);
                						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteKpiSectionWidthTask&SecCode='+SecCode);
                						outThis.refresh();
                						dhcwl_mkpi_taskWin.refresh();
                						dhcwl_mkpi_showKpiWin.refreshCombo();
                						outThis.clearForm();
                    				}
                    			});
                			}else if(jsonData.tip=="ok"){
                				//store.remove(record);
                				dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteKpiSection&SecCode='+SecCode+'&flag=1',null,function(jsonData){
									if(!jsonData){
										Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										return;
									}
									if(jsonData.success){
										if (jsonData.tip=="ok") {
											Ext.Msg.alert("提示","删除成功！");
											outThis.refresh();
											outThis.clearForm();
										}else{
											Ext.Msg.alert("提示","删除失败！");
										}
									}else{
										Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										return;
									}
								},outThis); 
                			}
                		},outThis);
                    }
                });
            }
        }, /*'-', {
            text: '选定区间',
            handler: function(){
               var sm=sectionGrid.getSelectionModel();         
               var record=sm.getSelected();
               if(!sm||!record){
               		alert("请单击选择一行！");
               		return;
               }
               dhcwl.mkpi.MaintainSection.parentWin.setKpiFormFile({section:record.get("SecName")});
               mainWin.close();
            }
    	},*/'-',{
        	//text   : '保存',
        	text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
            handler: function() {
            	var form=sectionForm.getForm();
                var values=form.getValues(false);
                var sm = sectionGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要保存的区间！");
               		return;
                }
                var ID=record.get("ID");
                var SecCode=Ext.get('SecCode').getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||_]/;
                var reg2=/^\d/;
                if(reg.test(SecCode)||(reg2.test(SecCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||,_等特殊字符，并且不能以数字开头！");
                	Ext.get("SecCode").focus();
                	return;
                }
                
                var SecName=Ext.get('SecName').getValue();
                var SecDesc=Ext.get('SecDesc').getValue();
                var SecUser=Ext.get('SecUser').getValue();
                var SecUpdateDate=Ext.get('SecUpdateDate').getValue();
                var SecRemark=Ext.get('SecRemark').getValue();
                //var SecDirectParent=parentFiled.getValue(); //Ext.get('SecDirectParent').getValue();
                var SecDirectParent=sectionCombo.getValue();
                var enforce=enforceCheck.getValue();
                //alert("inforce="+enforce);
                //return;
                if(enforce) enforce=1;
                else enforce=0;
                if(!SecCode||!SecName){
                	alert("区间编码或名称不能为空！");
                	return;
                }
                if(SecDirectParent==SecCode){
                	alert("指标父区间不能是自己！");
                	return;
                }
                paraValues='ID='+ID+'&SecCode='+SecCode+'&SecName='+SecName+'&SecDesc='+SecDesc+'&SecUser='+SecUser+'&SecUpdateDate='+SecUpdateDate;
                paraValues+='&SecRemark='+SecRemark+"&SecDirectParent="+SecDirectParent+'&enforce='+enforce;
                //alert(paraValues);
                //return;
                record.set("SecCode",SecCode),record.set("SecName",SecName),record.set("SecDesc",SecDesc);
                record.set("SecUser",SecUser),record.set("SecUpdateDate",SecUpdateDate),record.set("SecRemark",SecRemark);
                //alert(paraValues);
                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addKpiSection&'+paraValues
				,null,function(jsonData){
					if(!jsonData){
						Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(jsonData.success){
						if (jsonData.tip=="ok") {
							Ext.Msg.alert("提示","保存成功！！");
						}else{
							Ext.Msg.alert("提示",jsonData.tip);
						}
						store.proxy.setUrl(encodeURI(serviceUrl+'?action=lookupObj&className=DHCWL.MKPI.Section&start=0&limit=21'));
						parentFiledGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=sectionList'));
						parentFiledGrid.getStore().load();
						parentFiledGrid.show();
						outThis.refresh();
						dhcwl_mkpi_showKpiWin.refreshCombo();
					}else{
						Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
				},outThis);   
           }
    	},'-',{//text   : '清空',
    		text: '<span style="line-Height:1">清空</span>',
    		icon: '../images/uiimages/clearscreen.png',
            handler: function() {
            	outThis.clearForm();
            	return;
            	var form=sectionForm.getForm();
    			form.setValues({ID:'',SecCode:'',SecName:'',SecDesc:'',SecUser:'',SecUpdateDate:'',SecRemark:'',SecDirectParent:''});
        	}
        },'-',{//text   : '查找',
        	text: '<span style="line-Height:1">查询</span>',
        	icon: '../images/uiimages/search.png',
            handler: function() {
                var SecCode=Ext.get('SecCode').getValue();
                var SecName=Ext.get('SecName').getValue();
                var SecDesc=Ext.get('SecDesc').getValue();
                var SecUser=Ext.get('SecUser').getValue();
                var SecUpdateDate=Ext.get('SecUpdateDate').getValue();
                var SecRemark=Ext.get('SecRemark').getValue();
                paraValues='SecCode='+SecCode+'&SecName='+SecName+'&SecDesc='+SecDesc+'&SecUser='+SecUser+'&SecUpdateDate='+SecUpdateDate;
                paraValues+='&SecRemark='+SecRemark;
                store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearch&className=DHCWL.MKPI.Section&"+paraValues+"&start=0&limit=21&onePage=1"));
            	store.load();
    			sectionGrid.show();
           }
        }]) //}]
    });
    //store.load({params:{start:0,limit:21,onePage:1}});--modify by wz 2015-1-16
    
   /* var sectionPanel =new Ext.Panel({
    	title:'区间维护',
    	layout:'border',
        items: [{
        	region: 'north',
            height: 130,
            autoScroll:true,
            items:sectionForm
        },{
        	region:'center',
        	autoScroll:true,
            items:sectionGrid
    	}],
    	listeners:{
    		"resize":function(win,width,height){
    			sectionGrid.setHeight(height-133);
    			sectionGrid.setWidth(width-15);
    		}
    	}
    });*/
	
	
	
	var sectionPanel =new Ext.Panel ({ 
		title:'区间维护',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		
    	defaults: { border :false},
        items: [{ 
			border :false,
			flex:1.1,
			layout:"fit",
            items:sectionForm
    	},{
			border :false,
			flex:3,
			layout:"fit",
            items:sectionGrid
        }]
    });	
	
	
	
	
	
 	sectionPanel.on('afterrender',function( th ){
 		store.load({params:{start:0,limit:21,onePage:1}});
	});	    
    /*return sectionPanel;
    //alert(dhcwl.mkpi.MaintainSection.parentWin.getKpiShowWin());
	var mainWin=null;
	if(!mainWin){
        mainWin = new Ext.Window({
        	width:800,
	        height:400,
	        allowDomMove:true,	
	        draggable:true,					//----------布局会充满整个窗口，组件自动根据窗口调整大小
			resizable:false,
			plain : true,                                                   //----------true则主体背景透明
			modal : true,
			frame : true,													//----------win具有全部阴影，若为false则只有边框有阴影
			autoScroll : true,
			collapsible : true,
			closeAction:'hide',
			hideCollapseTool : true,
			titleCollapse : false,
			constrain:true,
			//applyTo:dhcwl.mkpi.MaintainSection.parentWin.getKpiShowWin(),
			bodyStyle : 'padding:3px',
			layout:'fit',
			//layoutConfig: {columns:1},
	        items:sectionPanel,
	        buttons: [{
	        	text: 'Close',
	            handler: function(){
	            	mainWin.hide();
	        }}]
		});
    }
    mainWin.show();
    */
    //以下为对外的接口方法。
    this.getSectionWin=function(){
    	return mainWin;
    }
    
    this.getSectionPanel=function(){
    	return sectionPanel;
    }
    this.getStore=function(){
    	return store;
    }
    this.getSectionGrid=function(){
    	return sectionGrid;
    }
    function getDimPro(){
    	if(!dhcwl_mkpi_seDimPropertyWin){
    		dhcwl_mkpi_seDimPropertyWin=new dhcwl.mkpi.MaintainSectionProperty("","");
    	}
    	return dhcwl_mkpi_seDimPropertyWin;
    }
    this.clearForm=function(){
    	var form=sectionForm.getForm();
    	form.setValues({ID:'',SecCode:'',SecName:'',SecDesc:'',SecUser:'',SecUpdateDate:'',SecRemark:'',SecDirectParent:''});
    }
}
dhcwl.mkpi.MaintainSection.prototype.refresh=function(){
	this.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=lookupObj&className=DHCWL.MKPI.Section&start=1&limit=21'));
	this.getStore().load();
    this.getSectionGrid().show();
}
dhcwl.mkpi.MaintainSection.setParentWin=function(parentWin){
	dhcwl.mkpi.MaintainSection.parentWin=parentWin;
}
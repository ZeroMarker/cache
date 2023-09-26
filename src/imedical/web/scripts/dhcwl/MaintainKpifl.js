﻿dhcwl.mkpi.MaintainKpifl=function(){	//var parentWin=null;	var serviceUrl="dhcwl/kpi/kpiservice.csp";	var outThis=this;	var quickMenu=new Ext.menu.Menu({		//autoWidth:true,		boxMinWidth:160,		ignoreParentClicks:true,    	items:[    		{    			text:'导出到Excel文件',    			handler:function(){    				var excelObj=new dhcwl.mkpi.util.Excel();    				excelObj.setTitle("指标类型导出");    				excelObj.setHead(['ID','分类编码','分类描述','分类名称','备注','创建/更新日期','创建者']);    				excelObj.setServerUrl(serviceUrl+'?action=mulSearch&className=DHCWL.MKPI.MKPIFL&session=FL&isArrayType=1');    				excelObj.exportExcel();    			}    		}]	});	var columnModel = new Ext.grid.ColumnModel([        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true        },{header:'分类编码',dataIndex:'MKPIFLCode',sortable:true, width: 100, sortable: true,menuDisabled : true        },{header:'分类名称',dataIndex:'MKPIFLName', width: 100, sortable: true,menuDisabled : true        },{header:'分类描述',dataIndex:'MKPIFLDesc', width: 160, sortable: true,menuDisabled : true        },{header:'创建者',dataIndex:'MKPIFLUser', width: 160, sortable: true,menuDisabled : true        },{header:'创建/更新日期',dataIndex:'MKPIFLUpdateDate', width: 100, sortable: true,menuDisabled : true//,renderer:formateDate        },{header:'备注',dataIndex:'MKPIFLRemark', width: 80, sortable: true,menuDisabled : true        }    ]);    var store = new Ext.data.Store({        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearch&session=FL&className=DHCWL.MKPI.MKPIFL'}),        reader: new Ext.data.JsonReader({            totalProperty: 'totalNum',            root: 'root',        	fields:[        		{name: 'ID'},            	{name: 'MKPIFLCode'},            	{name: 'MKPIFLName'},            	{name: 'MKPIFLDesc'},            	{name: 'MKPIFLUser'},            	{name: 'MKPIFLUpdateDate'},            	{name: 'MKPIFLRemark'}       		]    	})    });    var Record = Ext.data.Record.create([    	{name: 'ID',type:'integer'},    	{name: 'MKPIFLCode', type: 'string'},        {name: 'MKPIFLName', type: 'string'},        {name: 'MKPIFLDesc', type: 'string'},        {name: 'MKPIFLUser', type: 'string'},        {name: 'MKPIFLUpdateDate', type: 'string'},        {name: 'MKPIFLRemark', type: 'string'}    ]);    var kpiflGrid = new Ext.grid.GridPanel({        height:503,        store: store,        cm: columnModel,		viewConfig: {forceFit: true},        sm: new Ext.grid.RowSelectionModel({        	singleSelect: true,            listeners: {            	rowselect: function(sm, row, rec) {            		var id=rec.get("ID");            		var form=kpiflForm.getForm();                	form.loadRecord(rec);                	form.setValues({ID:id});             	}            }        }),        listeners:{        	'contextmenu':function(event){        		event.preventDefault();        		quickMenu.showAt(event.getXY());        	}        },        bbar:new Ext.PagingToolbar({            pageSize: 21,            store: store,            displayInfo: true,            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',            emptyMsg: "没有记录"        }),        tbar: new Ext.Toolbar([/*        {            text: '添加指标类型',            handler: function(){				var date=dhcwl.mkpi.Util.nowDate();                var initValue = {MKPIFLCode:'',MKPIFLName:'',MKPIFLDesc:'',MKPIFLUser:'',KDTRemark:'',MKPIFLUpdateDate:date,MKPIFLRemark:''};                var p = new Record(initValue);                kpiflGrid.stopEditing();                store.insert(0, p);	            }        }, '-', {            text: '删除指标类型',            handler: function(){                Ext.Msg.confirm('信息', '确定要删除？', function(btn){                    if (btn == 'yes') {                        var sm = kpiflGrid.getSelectionModel();                        var record = sm.getSelected();                        if(!sm||!record){               				alert("请单击选择一行！");               				return;               			}                        var MKPIFLCode=record.get("MKPIFLCode");                        store.remove(record);                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteKpifl&MKPIFLCode='+MKPIFLCode);                		outThis.refresh();                    }                });            }        }, '-', {            text: '选定纬度',            handler: function(){               var sm=kpiflGrid.getSelectionModel();                        var record=sm.getSelected();               if(!sm||!record){               		alert("请单击选择一行！");               		return;               }               dhcwl.mkpi.MaintainKpifl.parentWin.setKpiFormFile({category:record.get("MKPIFLName")});               mainWin.close();            }    	}*/])    });    //modify by wk ~2017-03-16~公司UI标准修改    /*var kpiflForm = new Ext.FormPanel({        frame: true,        height: 145,        labelAlign: 'left',        //title: '指标分类列表',        bodyStyle:'padding:5px',        style: {        	//"margin-left": "10px", // when you add custom margin in IE 6...            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"         },        layout: 'table',        defaultConfig:{width:130},        layoutConfig: {columns:8},        items:[{        	html: 'ID：'        },{            xtype:'textfield',            name: 'ID',            //id: 'ID',            disabled:true,            anchor:'95%'        },{        	html: '分类编码：'        },{            xtype:'textfield',            name: 'MKPIFLCode',            id: 'MKPIFLCode',            anchor:'95%'            //validator:dhcwl.mkpi.Util.valideValue        },{            html: '分类名称：'        },{            name: 'MKPIFLName',            id: 'MKPIFLName',            xtype:'textfield',            anchor:'95%'        },{            html:'分类描述：'        },{            name:'MKPIFLDesc',            id:'MKPIFLDesc',            xtype:'textfield',            flex:1        },{            html: '创建者：'        },{            name: 'MKPIFLUser',            id: 'MKPIFLUser',            xtype:'textfield',            flex:1        }, {            html: '创建/更新日期：'        },{            xtype:'datefield',            //format :'Y-m-d',            name: 'MKPIFLUpdateDate',            id: 'MKPIFLUpdateDate',            width:130,            flex:1        },{            //columnWidth:.1,            html: '备注：'        },{        	xtype:'textfield',            name: 'MKPIFLRemark',            id: 'MKPIFLRemark'         }],*/    var kpiflForm = new Ext.FormPanel({    	frame : true,		height : 122,		bodyStyle:'padding:5px',		labelAlign : 'right',		labelWidth : 90,		style : {			"margin-right" : Ext.isIE6? (Ext.isStrict ? "-10px" : "-13px"): "0"		},		items : [{			layout : 'column',			items : [{ 				columnWidth : .20,				layout : 'form',				defaultType : 'textfield',				defaults : {					width : 110				},				items : [{							fieldLabel : 'ID',							name: 'ID',				            disabled:true						},{							fieldLabel : '创建者',							name: 'MKPIFLUser',				            id: 'MKPIFLUser',				            xtype:'textfield'						}]			},{ 				columnWidth : .20,				layout : 'form',				defaultType : 'textfield',				defaults : {					width : 110				},				items : [{							fieldLabel : '分类编码',							xtype:'textfield',				            name: 'MKPIFLCode',				            id: 'MKPIFLCode'						},{							fieldLabel : '更新日期',							xtype:'datefield',				            name: 'MKPIFLUpdateDate',				            id: 'MKPIFLUpdateDate',							format:GetWebsysDateFormat()						}]			},{ 				columnWidth : .20,				layout : 'form',				defaultType : 'textfield',				defaults : {					width : 110				},				items : [{							fieldLabel : '分类名称',							name: 'MKPIFLName',				            id: 'MKPIFLName',				            xtype:'textfield'						},{							fieldLabel : '备注',							xtype:'textfield',				            name: 'MKPIFLRemark',				            id: 'MKPIFLRemark'						}]			},{ 				columnWidth : .20,				layout : 'form',				defaultType : 'textfield',				defaults : {					width : 110				},				items : [{							fieldLabel : '分类描述',							name:'MKPIFLDesc',				            id:'MKPIFLDesc',				            xtype:'textfield'						}]			}]		}],         tbar:new Ext.Toolbar([{            //text: '新增',            text: '<span style="line-Height:1">新增</span>',            icon: '../images/uiimages/edit_add.png',            handler: function(){				var date=dhcwl.mkpi.Util.nowDate();                var initValue = {ID:'',MKPIFLCode:'',MKPIFLName:'',MKPIFLDesc:'',MKPIFLUser:'',KDTRemark:'',MKPIFLUpdateDate:date,MKPIFLRemark:''};                var p = new Record(initValue);                kpiflGrid.stopEditing();                store.insert(0, p);                var sm = kpiflGrid.getSelectionModel();                sm.selectFirstRow();            }        }, '-', {            //text: '删除',            text: '<span style="line-Height:1">删除</span>',            icon: '../images/uiimages/edit_remove.png',            handler: function(){            	var sm = kpiflGrid.getSelectionModel();                var record = sm.getSelected();                if(!sm||!record){               		alert("请选择要删除的类型！");               		return;               	}                Ext.Msg.confirm('信息', '确定要删除？', function(btn){                    if (btn == 'yes') {                        var MKPIFLCode=record.get("MKPIFLCode");                        store.remove(record);                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteKpifl&MKPIFLCode='+MKPIFLCode);                		outThis.refresh();                		dhcwl_mkpi_showKpiWin.refreshCombo();                		outThis.clearForm();                    }                });            }        },/* '-', {            text: '选定指标类型 ',            handler: function(){               var sm=kpiflGrid.getSelectionModel();                        var record=sm.getSelected();               if(!sm||!record){               		alert("请单击选择一行！");               		return;               }               dhcwl.mkpi.MaintainKpifl.parentWin.setKpiFormFile({category:record.get("MKPIFLName")});               mainWin.close();            }    	},*/'-',{        	//text   : '保 存',        	text: '<span style="line-Height:1">保存</span>',        	icon: '../images/uiimages/filesave.png',            handler: function() {            	var form=kpiflForm.getForm();                var values=form.getValues(false);                var sm = kpiflGrid.getSelectionModel();                var record = sm.getSelected();                if(!sm||!record){               		alert("请选择要保存的类型！");               		return;                }                var ID=record.get("ID");                var MKPIFLCode=Ext.get('MKPIFLCode').getValue();                var reg=/[\$\#\@\&\%\!\*\^\~||_]/;                var reg2=/^\d/;                if(reg.test(MKPIFLCode)||(reg2.test(MKPIFLCode))){                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||,_等特殊字符，并且不能以数字开头！");                	Ext.get("MKPIFLCode").focus();                	return;                }                                var MKPIFLName=Ext.get('MKPIFLName').getValue();                var MKPIFLDesc=Ext.get('MKPIFLDesc').getValue();                var MKPIFLUser=Ext.get('MKPIFLUser').getValue();                var MKPIFLUpdateDate=Ext.get('MKPIFLUpdateDate').getValue();                var MKPIFLRemark=Ext.get('MKPIFLRemark').getValue();                                if(MKPIFLName) MKPIFLName=MKPIFLName.trim();                if(MKPIFLCode) MKPIFLCode=MKPIFLCode.trim();                if(!MKPIFLCode || !MKPIFLName){                	alert("类别编码或名称不能为空！");                	return;                }                paraValues='ID='+ID+'&MKPIFLCode='+MKPIFLCode+'&MKPIFLName='+MKPIFLName+'&MKPIFLDesc='+MKPIFLDesc+'&MKPIFLUser='+MKPIFLUser+'&MKPIFLUpdateDate='+MKPIFLUpdateDate;                paraValues+='&MKPIFLRemark='+MKPIFLRemark;                record.set("MKPIFLCode",MKPIFLCode),record.set("MKPIFLName",MKPIFLName),record.set("MKPIFLDesc",MKPIFLDesc);                record.set("MKPIFLUser",MKPIFLUser),record.set("MKPIFLUpdateDate",MKPIFLUpdateDate),record.set("MKPIFLRemark",MKPIFLRemark);                //alert(paraValues);                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addKpifl&'+paraValues);                store.proxy.setUrl(encodeURI(serviceUrl+'?action=lookupObj&className=DHCWL.MKPI.MKPIFL&start=1&limit=21'));            	outThis.refresh();            	dhcwl_mkpi_showKpiWin.refreshCombo();           }    	},'-',{//text   : '清 空',    		text: '<span style="line-Height:1">清空</span>',    		icon: '../images/uiimages/clearscreen.png',            handler: function() {            	outThis.clearForm();            	return;            	var form=kpiflForm.getForm();    			form.setValues({ID:'',MKPIFLCode:'',MKPIFLName:'',MKPIFLDesc:'',MKPIFLUser:'',MKPIFLUpdateDate:'',MKPIFLRemark:''});        }        },'-',{//text   : '查 找',        	text: '<span style="line-Height:1">查询</span>',        	icon: '../images/uiimages/search.png',            handler: function() {                var MKPIFLCode=Ext.get('MKPIFLCode').getValue();                var MKPIFLName=Ext.get('MKPIFLName').getValue();                var MKPIFLDesc=Ext.get('MKPIFLDesc').getValue();                var MKPIFLUser=Ext.get('MKPIFLUser').getValue();                var MKPIFLUpdateDate=Ext.get('MKPIFLUpdateDate').getValue();                var MKPIFLRemark=Ext.get('MKPIFLRemark').getValue();                paraValues='MKPIFLCode='+MKPIFLCode+'&MKPIFLName='+MKPIFLName+'&MKPIFLDesc='+MKPIFLDesc+'&MKPIFLUser='+MKPIFLUser;                paraValues+='&MKPIFLUpdateDate='+MKPIFLUpdateDate+'&MKPIFLRemark='+MKPIFLRemark;                store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearch&className=DHCWL.MKPI.MKPIFL&"+paraValues+"&start=0&limit=21&onePage=1"));            	store.load();    			kpiflGrid.show();           }        }]) //}]    });    //store.load({params:{start:0,limit:21}});   /* var kpiflPanel =new Ext.Panel({    	title:'指标类型维护',    	layout:'border',        items: [{        	region: 'north',            height: 125,            autoScroll:true,            items:kpiflForm        },{        	region:'center',        	autoScroll:true,            items:kpiflGrid    	}],    	listeners:{    		"resize":function(win,width,height){    			kpiflGrid.setHeight(height-127);    			kpiflGrid.setWidth(width-15);    		}    	}    });*/			var kpiflPanel =new Ext.Panel ({ //Viewport({    	title:'指标类型维护',		layout: {			type: 'vbox',			pack: 'start',			align: 'stretch'		},		    	defaults: { border :false},        items: [{ 			border :false,			flex:1.1,			layout:"fit",            items:kpiflForm    	},{			border :false,			flex:3,			layout:"fit",            items:kpiflGrid        }]    });		 	kpiflPanel.on('afterrender',function( th ){ 		store.load({params:{start:0,limit:21,flag:1}});	});	    /*return kpiflPanel;	var mainWin=null;	if(!this.mainWin){        mainWin = new Ext.Window({        layout:'fit',        modal :true,        width:800,        height:400,        plain: true,        items: kpiflPanel,        buttons: [{        	text: 'Close',            handler: function(){            	mainWin.close();            }}]		});    }    mainWin.show(this);    */    //以下为对外的接口方法。    this.getKpiflWin=function(){    	return mainWin;    }    this.getKpiflPanel=function(){    	return kpiflPanel;    }    this.getStore=function(){    	return store;    }    this.getKpiflGrid=function(){    	return kpiflGrid;    }    this.clearForm=function(){    	var form=kpiflForm.getForm();    	form.setValues({ID:'',MKPIFLCode:'',MKPIFLName:'',MKPIFLDesc:'',MKPIFLUser:'',MKPIFLUpdateDate:'',MKPIFLRemark:''});    }}dhcwl.mkpi.MaintainKpifl.prototype.refresh=function(){	this.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=lookupObj&className=DHCWL.MKPI.MKPIFL&start=1&limit=21'));	this.getStore().load();    this.getKpiflGrid().show();}dhcwl.mkpi.MaintainKpifl.setParentWin=function(parentWin){	dhcwl.mkpi.MaintainKpifl.parentWin=parentWin;}
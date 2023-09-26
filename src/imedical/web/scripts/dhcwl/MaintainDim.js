dhcwl.mkpi.MaintainDim=function(parentWin){
	var parentWin=null;
	var serviceUrl="dhcwl/kpi/kpiservice.csp";
	var outThis=this;
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'维护维度属性',
    			handler:function(cmp,event){
    				var sm = dimGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                    var dimId=record.get('ID'),dimName=record.get('KDTName');
                    getDimPro().show(dimId,dimName);
    			}
    		},{
    			text:'导出到Excel文件',
    			handler:function(){
    				var excelObj=new dhcwl.mkpi.util.Excel();
    				excelObj.setTitle("指标维度导出");
    				excelObj.setHead(['ID','维度编码','维度描述','执行代码旧(指标3.0之前使用过）','执行代码','维度名称','备注','创建/更新日期','创建者']);
    				//excelObj.setServerUrl(serviceUrl+'?action=mulSearch&className=DHCWL.MKPI.MKPIDimType&session=DIM&isArrayType=1');
					excelObj.setServerUrl('dhcwl/kpi/dimioservice.csp?action=dimExportExcel');
					excelObj.exportExcel();
    			}
    		},{
    			text:'预览维度数据',
    			handler:function(){
    				var sm = dimGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                    dimCode=record.get('KDTCode');
                    var ViewDimDataObj=new dhcwl.mkpi.ViewDimData();
                    ViewDimDataObj.setKpiRule("",dimCode);
                    ViewDimDataObj.showWin();
    			}
    		}]
	});
	var columnModel = new Ext.grid.ColumnModel([
		{header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true
        },{header:'维度编码',dataIndex:'KDTCode',sortable:true, width: 100, sortable: true ,menuDisabled : true
        },{header:'维度名称',dataIndex:'KDTName', width: 100, sortable: true ,menuDisabled : true
        },{header:'维度描述',dataIndex:'KDTDesc', width: 160, sortable: true,menuDisabled : true
        },//{header:'维度执行代码',dataIndex:'KDTEXCode', width: 160, sortable: true},
        {header:'创建/更新日期',dataIndex:'KDTUpdateDate', width: 100, sortable: true,menuDisabled : true
        },{header:'创建者',dataIndex:'KDTUser', width: 50, sortable: true,menuDisabled : true
        },{header:'执行代码',dataIndex:'KDTExeCode', width: 160, sortable: true,menuDisabled : true
		},{header:'备注',dataIndex:'KDTRemark', width: 100, sortable: true,menuDisabled : true
     	}
		
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=lookupObj&session=DIM&className=DHCWL.MKPI.MKPIDimType'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'KDTCode'},
            	{name: 'KDTDesc'},
            	{name: 'KDTName'},
            	{name: 'KDTRemark'},
            	{name: 'KDTUpdateDate'},
            	{name: 'KDTUser'},
            	{name: 'KDTExeCode'}
       		]
    	})
    });
    var Record = Ext.data.Record.create([
    	{name: 'ID',type:'integer'},
    	{name: 'KDTCode', type: 'string'},
        {name: 'KDTDesc', type: 'string'},
        {name: 'KDTName', type: 'string'},
        {name: 'KDTRemark', type: 'string'},
        {name: 'KDTUpdateDate', type: 'string'},
        {name: 'KDTUser', type: 'string'},
        {name: 'KDTExeCode',type: 'string'}
    ]);
    var dimGrid = new Ext.grid.GridPanel({
        height:503,
        store: store,
        cm: columnModel,
		viewConfig: {forceFit: true},
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
                	//Ext.getCmp("kpiDim-list").getForm().loadRecord(rec);
            		//dimForm.getForm().loadRecord(rec);
            		var id=rec.get("ID");
            		var form=dimForm.getForm();
                	form.loadRecord(rec);
                	//alert("id="+id);
                	form.setValues({ID:id});
             	}
            }
        }),
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	}
        },
        tbar: new Ext.Toolbar([/*
        {
            text: '添加维度',
            handler: function(){
				var date=dhcwl.mkpi.Util.nowDate();
                var initValue = {KDTCode:'',KDTDesc:'',KDTEXCode:'',KDTName:'',KDTRemark:'',KDTUpdateDate:date,KDTUser:''};
                var p = new Record(initValue);
                dimGrid.stopEditing();
                store.insert(0, p);	
            }
        }, '-', {
            text: '删除维度',
            handler: function(){
                Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                        var sm = dimGrid.getSelectionModel();
                        var record = sm.getSelected();
                        if(!sm||!record){
               				alert("请单击选择一行！");
               				return;
               			}
                        var KDTCode=record.get("KDTCode");
                        store.remove(record);
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteDim&KDTCode='+KDTCode);
                		outThis.refresh();
                    }
                });
            }
        }, '-', {
            text: '选定维度',
            handler: function(){
               var sm=dimGrid.getSelectionModel();         
               var record=sm.getSelected();
               if(!sm||!record){
               		alert("请单击选择一行！");
               		return;
               }
               dhcwl.mkpi.MaintainDim.parentWin.setKpiFormFile({dimType:record.get("KDTName")});//,dimTypeCode:record.get("KDTCode")});
               mainWin.close();
            }
    	}*/])
    });
  //modify by wk ~2017-03-16~公司UI标准修改
    /*var dimForm = new Ext.FormPanel({
        frame: true,
        height: 145,
        labelAlign: 'left',
        //title: '维度列表',
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
            //editable:false,
            disabled:true,
            anchor:'95%'
        },{
        	html: '维度编码：'
        },{
            xtype:'textfield',
            name: 'KDTCode',
            id: 'KDTCode',
            anchor:'95%'
            //validator:dhcwl.mkpi.Util.valideValue
        },{
            html: '维度名称：'
        },{
            name: 'KDTName',
            id: 'KDTName',
            xtype:'textfield',
            anchor:'95%'
        },{
            html:'维度描述：'
        },{
            name:'KDTDesc',
            id:'KDTDesc',
            xtype:'textfield',
            flex:1
        }, {
            html: '备注：'
        },{
            xtype:'textfield',
            name: 'KDTRemark',
            id: 'KDTRemark',
            flex:1
        },{
            html: '创建/更新日期：'
        },{
        	xtype:'datefield',
        	//format :'Y-m-d',
            name: 'KDTUpdateDate',
            width:130,
            id: 'KDTUpdateDate'
         }, {
            html: '创建者：'
         },{
            xtype:'textfield',
            name: 'KDTUser',
            id: 'KDTUser',
            flex:1
        }, {
            html: '执行代码：'
         },{
            xtype:'textfield',
            name: 'KDTExeCode',
            id: 'KDTExeCode'
        }],*/
    var dimForm = new Ext.FormPanel({
    	frame : true,
		height : 122,
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
							fieldLabel : '备注',
							xtype:'textfield',
				            name: 'KDTRemark',
				            id: 'KDTRemark'
						}]
			},{ 
				columnWidth : .20,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 110
				},
				items : [{
							fieldLabel : '维度编码',
							xtype:'textfield',
				            name: 'KDTCode',
				            id: 'KDTCode'
						},{
							fieldLabel : '更新日期',
							xtype:'datefield',
				            name: 'KDTUpdateDate',
				            id: 'KDTUpdateDate',
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
							fieldLabel : '维度名称',
							name: 'KDTName',
				            id: 'KDTName',
				            xtype:'textfield'
						},{
							fieldLabel : '创建者',
							xtype:'textfield',
				            name: 'KDTUser',
				            id: 'KDTUser'
						}]
			},{ 
				columnWidth : .20,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 110
				},
				items : [{
							fieldLabel : '维度描述',
							name:'KDTDesc',
				            id:'KDTDesc',
				            xtype:'textfield'
						},{
							fieldLabel : '执行代码',
							xtype:'textfield',
					        name: 'KDTExeCode',
					        id: 'KDTExeCode'
						}]
			}]
		}],
        tbar:new Ext.Toolbar([{
            //text: '新增',
            text: '<span style="line-Height:1">新增</span>',
            icon: '../images/uiimages/edit_add.png',
            handler: function(){
				var date=dhcwl.mkpi.Util.nowDate();
                var initValue = {ID:'',KDTCode:'',KDTDesc:'',KDTName:'',KDTRemark:'',KDTUpdateDate:date,KDTUser:'',KDTExeCode:''};
                var p = new Record(initValue);
                dimGrid.stopEditing();
                store.insert(0, p);
                var sm = dimGrid.getSelectionModel();
                sm.selectFirstRow();
            }
        }, '-', {
            //text: '删除',
            text: '<span style="line-Height:1">删除</span>',
            icon: '../images/uiimages/edit_remove.png',
            handler: function(){
            	 var sm = dimGrid.getSelectionModel();
                 var record = sm.getSelected();
                 if(!sm||!record){
               		alert("请选择要删除的维度！");
               		return;
               	 }
                Ext.Msg.confirm('信息', '删除维度会删除该维度所有的维度属性和关联的指标维度，确定要删除？', function(btn){
                    if (btn == 'yes') {
                        var KDTCode=record.get("KDTCode");
                        store.remove(record);
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteDim&KDTCode='+KDTCode);
                		outThis.refresh();
                		dhcwl_mkpi_showKpiWin.refreshCombo();
                		outThis.clearForm();
                    }
                });
            }
        }, /*'-', {
            text: '选定维度',
            handler: function(){
               var sm=dimGrid.getSelectionModel();         
               var record=sm.getSelected();
               if(!sm||!record){
               		alert("请单击选择一行！");
               		return;
               }
               dhcwl.mkpi.MaintainDim.parentWin.setKpiFormFile({dimType:record.get("KDTName")});//,dimTypeCode:record.get("KDTCode")});
               mainWin.close();
            }
    	},*/'-',{
        	//text   : '保 存',
        	text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
            handler: function() {
            	var form=dimForm.getForm();
                var values=form.getValues(false);
                var sm = dimGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要保存的维度！");
               		return;
                }
                var ID=record.get("ID");
                var KDTCode=Ext.get('KDTCode').getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||_]/;var reg2=/^\d/;
                if(reg.test(KDTCode)||(reg2.test(KDTCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||,_等特殊字符，并且不能以数字开头");
                	Ext.get("KDTCode").focus();
                	return;
                }
                
                var KDTName=Ext.get('KDTName').getValue();
                var KDTDesc=Ext.get('KDTDesc').getValue();
                var KDTExeCode=Ext.get('KDTExeCode').getValue();
                var KDTRemark=Ext.get('KDTRemark').getValue();
                var KDTUpdateDate=Ext.get('KDTUpdateDate').getValue();
                var KDTUser=Ext.get('KDTUser').getValue();
                if(!KDTCode||!KDTName){
                	alert("维度代码或名称不能为空！");
                	return;
                }
                if(KDTExeCode)KDTExeCode=KDTExeCode.trim();
                paraValues='ID='+ID+'&KDTCode='+KDTCode+'&KDTName='+KDTName+'&KDTDesc='+KDTDesc+'&KDTRemark='+KDTRemark;
                paraValues+='&KDTUpdateDate='+KDTUpdateDate+'&KDTUser='+KDTUser+'&KDTExeCode='+KDTExeCode;
                record.set("KDTCode",KDTCode),record.set("KDTName",KDTName),record.set("KDTDesc",KDTDesc);
                //record.set("KDTEXCode",KDTEXCode),
                record.set("KDTRemark",KDTRemark),record.set("KDTUpdateDate",KDTUpdateDate);
                record.set("KDTUser",KDTUser);
                //alert(paraValues);
                //dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addDim&'+paraValues);
                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addDim&'+paraValues,null,function(jsonData){
                		
	                if(jsonData.success==true && jsonData.tip=="ok"){
						if(jsonData.TipMSG) {
							Ext.MessageBox.alert("提示",jsonData.TipMSG);
						}
		
					}else{
						Ext.Msg.alert("提示","操作失败！");
					}
                	
	                store.proxy.setUrl(encodeURI(serviceUrl+'?action=lookupObj&className=DHCWL.MKPI.MKPIDimType&start=1&limit=21'));
	            	outThis.refresh();
	            	dhcwl_mkpi_showKpiWin.refreshCombo();               	
                })


           }
    	},'-',{//text   : '清 空',
    		text: '<span style="line-Height:1">清空</span>',
    		icon: '../images/uiimages/clearscreen.png',
            handler: function() {
            	outThis.clearForm();
            	return;
            	var form=dimForm.getForm();
    			form.setValues({ID:'',KDTCode:'',KDTName:'',KDTDesc:'',KDTExeCode:'',KDTRemark:'',KDTUpdateDate:'',KDTUser:'',KDTExeCode:''});
        }
        },'-',{//text   : '查 找',
        	text: '<span style="line-Height:1">查询</span>',
        	icon: '../images/uiimages/search.png',
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
                //store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearch&className=DHCWL.MKPI.MKPIDimType&"+paraValues+"&start=0&limit=21&onePage=1"));
            	//store.load();
    			
    			store.baseParams={
	    			action:'mulSearch',
	    			className:'DHCWL.MKPI.MKPIDimType',			
					KDTCode:KDTCode,
					KDTName:KDTName,
					KDTDesc:KDTDesc,
					KDTExeCode:KDTExeCode,
					KDTRemark:KDTRemark,
					KDTUpdateDate:KDTUpdateDate,
					KDTUser:KDTUser,
					paraValues:paraValues
				};
				store.load({
					params : {
						start : 0,
						limit : 21,
						onePage : 1
					}
				});
    			dimGrid.show();
           }
        },'-',{
        	//text:'导出',
        	text: '<span style="line-Height:1">导出</span>',
        	icon: '../images/uiimages/redo.png',
        	handler:function(){
        		var dimOutputObj=new dhcwl.mkpi.DimOutput();
        		dimOutputObj.show();
        	}
        }])//}]
    });
    //store.load({params:{start:0,limit:21}});--moidfy by wz.2015-1-16
    /*var dimPanel =new Ext.Panel({
    	title:'维度维护',
    	layout:'border',
        items: [{
        	region: 'north',
            height: 125,
            autoScroll:true,
            items:dimForm
        },{
        	region:'center',
        	autoScroll:true,
            items:dimGrid
    	}],
    	listeners:{
    		"resize":function(win,width,height){
    			dimGrid.setHeight(height-127);
    			dimGrid.setWidth(width-15);
    		}
    	}
    });*/
	
	var dimPanel =new Ext.Panel ({ //Viewport({
    	title:'维度维护',
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
            items:dimForm
    	},{
			border :false,
			flex:3,
			layout:"fit",
            items:dimGrid
        }]
    });	
	
	
	
     dimPanel.on('afterrender',function( th ){
 		store.load({params:{start:0,limit:21}});
	});	
    function getDimPro(){
    	if(!dhcwl_mkpi_dimPropertyWin){
    		dhcwl_mkpi_dimPropertyWin=new dhcwl.mkpi.MaintainDimProperty("","");
    	}
    	return dhcwl_mkpi_dimPropertyWin;
    }
    //return dimPanel;
    /*
	var mainWin=null;
	if(!this.mainWin){
        mainWin = new Ext.Window({
        layout:'fit',
        modal :true,
        width:800,
        height:400,
        plain: true,
        items: dimPanel,
        buttons: [{
        	text: 'Close',
            handler: function(){
            	mainWin.close();
            }}]
		});
    }
    mainWin.show(this);
    */
    //以下为对外的接口方法。
    this.getDimWin=function(){
    	return mainWin;
    }
    this.getDimPanel=function(){
    	return dimPanel;
    }
    this.getStore=function(){
    	return store;
    }
    this.getDimGrid=function(){
    	return dimGrid;
    }
    this.clearForm=function(){
    	var form=dimForm.getForm();
    	form.setValues({ID:'',KDTCode:'',KDTName:'',KDTDesc:'',KDTExeCode:'',KDTRemark:'',KDTUpdateDate:'',KDTUser:'',KDTExeCode:''});
    }
}
dhcwl.mkpi.MaintainDim.prototype.refresh=function(){
	this.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=lookupObj&className=DHCWL.MKPI.MKPIDimType&start=1&limit=21'));
	this.getStore().load();
    this.getDimGrid().show();
}
//设定父窗口
dhcwl.mkpi.MaintainDim.setParentWin=function(parentWin){
	dhcwl.mkpi.MaintainDim.parentWin=parentWin;
}
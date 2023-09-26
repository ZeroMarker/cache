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
    			text:'维护指标维度',
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
    				excelObj.setHead(['ID','维度编码','维度名称','维度执行代码(自指标3.0之后已经废弃该字段）','维度描述','备注','创建/更新日期','创建者']);
    				excelObj.setServerUrl(serviceUrl+'?action=mulSearch&className=DHCWL.MKPI.MKPIDimType&session=DIM&isArrayType=1');
    				excelObj.exportExcel();
    			}
    		}]
	});
	var columnModel = new Ext.grid.ColumnModel([
		{header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true
        },{header:'维度编码',dataIndex:'KDTCode',sortable:true, width: 30, sortable: true 
        },{header:'维度名称',dataIndex:'KDTName', width: 100, sortable: true 
        },{header:'维度描述',dataIndex:'KDTDesc', width: 160, sortable: true
        },//{header:'维度执行代码',dataIndex:'KDTEXCode', width: 160, sortable: true},
        {header:'备注',dataIndex:'KDTRemark', width: 160, sortable: true
     	},{header:'创建/更新日期',dataIndex:'KDTUpdateDate', width: 80, sortable: true
        },{header:'创建者',dataIndex:'KDTUser', width: 80, sortable: true
        }
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearch&session=DIM&className=DHCWL.MKPI.MKPIDimType'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'KDTCode'},
            	{name: 'KDTDesc'},
            	//{name: 'KDTEXCode'},
            	{name: 'KDTName'},
            	{name: 'KDTRemark'},
            	{name: 'KDTUpdateDate'},
            	{name: 'KDTUser'}
       		]
    	})
    });
    var Record = Ext.data.Record.create([
    	{name: 'ID',type:'integer'},
    	{name: 'KDTCode', type: 'string'},
        {name: 'KDTDesc', type: 'string'},
        //{name: 'KDTEXCode', type: 'string'},
        {name: 'KDTName', type: 'string'},
        {name: 'KDTRemark', type: 'string'},
        {name: 'KDTUpdateDate', type: 'string'},
        {name: 'KDTUser', type: 'string'}
    ]);
    var dimGrid = new Ext.grid.GridPanel({
        height:480,
        store: store,
        cm: columnModel,
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
    var dimForm = new Ext.FormPanel({
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
        },/*{
            html: '维度执行代码：'
        },{
            name: 'KDTEXCode',
            id: 'KDTEXCode',
            xtype:'textfield',
            flex:1
        },*/ {
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
        	format :'Y-m-d',
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
        }],//{buttons: 
        tbar:new Ext.Toolbar([{
            text: '添加维度',
            handler: function(){
				var date=dhcwl.mkpi.Util.nowDate();
                var initValue = {ID:'',KDTCode:'',KDTDesc:'',KDTName:'',KDTRemark:'',KDTUpdateDate:date,KDTUser:''};
                var p = new Record(initValue);
                dimGrid.stopEditing();
                store.insert(0, p);	
            }
        }, '-', {
            text: '删除维度',
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
        	text   : '保 存',
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
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;var reg2=/^\d/;
                if(reg.test(KDTCode)||(reg2.test(KDTCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头");
                	Ext.get("KDTCode").focus();
                	return;
                }
                
                var KDTName=Ext.get('KDTName').getValue();
                var KDTDesc=Ext.get('KDTDesc').getValue();
                //var KDTEXCode=Ext.get('KDTEXCode').getValue();
                var KDTRemark=Ext.get('KDTRemark').getValue();
                var KDTUpdateDate=Ext.get('KDTUpdateDate').getValue();
                var KDTUser=Ext.get('KDTUser').getValue();
                if(!KDTCode||!KDTName){
                	alert("纬度代码或名称不能为空！");
                	return;
                }
                //if(KDTEXCode)KDTEXCode=KDTEXCode.trim();
                paraValues='ID='+ID+'&KDTCode='+KDTCode+'&KDTName='+KDTName+'&KDTDesc='+KDTDesc+'&KDTRemark='+KDTRemark;
                paraValues+='&KDTUpdateDate='+KDTUpdateDate+'&KDTUser='+KDTUser;
                record.set("KDTCode",KDTCode),record.set("KDTName",KDTName),record.set("KDTDesc",KDTDesc);
                //record.set("KDTEXCode",KDTEXCode),
                record.set("KDTRemark",KDTRemark),record.set("KDTUpdateDate",KDTUpdateDate);
                record.set("KDTUser",KDTUser);
                //alert(paraValues);
                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addDim&'+paraValues);
                store.proxy.setUrl(encodeURI(serviceUrl+'?action=lookupObj&className=DHCWL.MKPI.MKPIDimType&start=1&limit=21'));
            	outThis.refresh();
            	dhcwl_mkpi_showKpiWin.refreshCombo();
           }
    	},'-',{text   : '清 空',
            handler: function() {
            	var form=dimForm.getForm();
    			form.setValues({ID:'',KDTCode:'',KDTName:'',KDTDesc:'',KDTEXCode:'',KDTRemark:'',KDTUpdateDate:'',KDTUser:''});
        }
        },'-',{text   : '查 找',
            handler: function() {
                var KDTCode=Ext.get('KDTCode').getValue();
                var KDTName=Ext.get('KDTName').getValue();
                var KDTDesc=Ext.get('KDTDesc').getValue();
                //var KDTEXCode=Ext.get('KDTEXCode').getValue();
                var KDTRemark=Ext.get('KDTRemark').getValue();
                var KDTUpdateDate=Ext.get('KDTUpdateDate').getValue();
                var KDTUser=Ext.get('KDTUser').getValue();
                paraValues='KDTCode='+KDTCode+'&KDTName='+KDTName+'&KDTDesc='+KDTDesc;//+'&KDTEXCode='+KDTEXCode;
                paraValues+='&KDTRemark='+KDTRemark+'&KDTUpdateDate='+KDTUpdateDate+'&KDTUser='+KDTUser;
                store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearch&className=DHCWL.MKPI.MKPIDimType&"+paraValues+"&start=0&limit=21&onePage=1"));
            	store.load();
    			dimGrid.show();
           }
        }])//}]
    });
    store.load({params:{start:0,limit:21}});
    var dimPanel =new Ext.Panel({
    	title:'维度维护',
    	layout:'border',
        items: [{
        	region: 'north',
            height: 148,
            autoScroll:true,
            items:dimForm
        },{
        	region:'center',
        	autoScroll:true,
            items:dimGrid
    	}],
    	listeners:{
    		"resize":function(win,width,height){
    			dimGrid.setHeight(height-150);
    			dimGrid.setWidth(width-15);
    		}
    	}
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
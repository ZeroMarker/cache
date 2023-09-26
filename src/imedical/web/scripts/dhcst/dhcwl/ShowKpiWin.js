(function(){
	Ext.ns("dhcwl.mkpi.ShowKpiWin");
})();
dhcwl.mkpi.ShowKpiWin=function(){
	//右键菜单定义
	Ext.QuickTips.init();
	if(!dhcwl_mkpi_previewKpiData) dhcwl.mkpi.PreviewKpiData.create();
	function getPreviewKpiData(){
		if(!dhcwl_mkpi_previewKpiData){
			dhcwl_mkpi_previewKpiData=new dhcwl.mkpi.PreviewKpiData();
		}
		return dhcwl_mkpi_previewKpiData;
	}
	function getKpiDimObj(){
		if(null==dhcwl_mkpi_mantainKpiDim){
    		dhcwl_mkpi_mantainKpiDim=new dhcwl.mkpi.MaintainKpiDim("","");
    	}
    	return dhcwl_mkpi_mantainKpiDim;
	}
	
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'维护指标维度',
    			handler:function(cmp,event){
    				var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                	getKpiDimObj();
                    dhcwl_mkpi_showKpiWin.setKpiDim();
    			}
    		},'-',{
				text:'维护指标日志',
				handler:function(){
					var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
					var mKpiCode=record.get('kpiCode');
					var kpiWinKpiLoginInfoCfg = new dhcwl.mkpi.KpiWinKpiLoginInfoCfg(mKpiCode);
					kpiWinKpiLoginInfoCfg.showKpiLoginInfoCfgWin();
				}
			},'-',/*{
    			text:'添加到导出列表',
    			handler:function(cmp,event){
    				var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                    dhcwl_mkpi_taskIO.getOutputObj().add(record.get('kpiCode'));
    			}
    		},{
    			text:'查看导出指标列表',
    			handler:function(){
    				dhcwl_mkpi_taskIO.getOutputObj().showList();
    			}
    		},{
    			text:'清空导出指标列表',
    			handler:function(){
    				dhcwl_mkpi_taskIO.getOutputObj().clearList();
    			}
    		},*/{
    			text:'导出指标',
    			handler:function(){
    				for(var i=selectedKpiIds.length-1;i>-1;i--)
    					dhcwl_mkpi_taskIO.getOutputObj().add(selectedKpiIds[i]);
    				dhcwl_mkpi_taskIO.getOutputObj().ouputKpis();
    			}
    		},/*{
    			text:'添加到预览指标列表',
    			handler:function(){
    				var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                	getPreviewKpiData();
    				dhcwl_mkpi_previewKpiData.add(record.get('kpiCode'));
    			}
    		},{
    			text:'查看预览指标列表',
    			handler:function(){
    				getPreviewKpiData();
    				dhcwl_mkpi_previewKpiData.showList();
    			}
    		},{
    			text:'清空预览指标列表',
    			handler:function(){
    				getPreviewKpiData();
    				dhcwl_mkpi_previewKpiData.clearList();
    			}
    		},*/{
    			text:'预览指标数据',
    			handler:function(){
    				var selectKpiRec=[];
    				for(var i=selectedKpiIds.length-1;i>-1;i--){
    					selectKpiRec[i]={"kpiCode":selectedKpiIds[i],"kpiName":selectedKpiIds[i],"category":"","section":""};
    				}
    				if(true||!dhcwl_mkpi_previewKpiData){
    					dhcwl_mkpi_previewKpiData=new dhcwl.mkpi.ViewKpiData();
    				}
    				dhcwl_mkpi_previewKpiData.setSelectedKpis(selectKpiRec);
    				dhcwl_mkpi_previewKpiData.showWin();
    				/*getPreviewKpiData();
    				for(var i=selectedKpiIds.length-1;i>-1;i--)
    					dhcwl_mkpi_previewKpiData.add(selectedKpiIds[i]);
    				if(dhcwl_mkpi_previewKpiData.getKpiListLength()<1){
    					alert("还没有添加要预览的指标，请先将指标添加到预览列表后再操作！");
    					return;
    				}
    				dhcwl_mkpi_previewKpiData.previewKpiData();*/
    			}
    		},{
    			text:'转到指标任务维护页面',
    			handler:function(){
    				var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                	dhcwl_mkpi_taskWin.filterKpi(record.get('kpiCode'));
                	dhcwl_mkpi_maintain.mainTabs.get('dhcwl.mkpi.MaintainKpiTasks.taskPanel').show();
    			}
    		},{
    			text:'导出到Excel文件',
    			handler:function(){
    				var excelObj=new dhcwl.mkpi.util.Excel();
    				excelObj.setTitle("指标导出");
    				excelObj.setHead(['ID','编码','指标名称','指标描述','执行代码','是否使用global','创建者','创建/更新日期','备注','维度','类型','区间','数据节点']);
    				excelObj.setServerUrl('dhcwl/kpi/getkpidata.csp?action=mulSearch&isArrayType=1');
    				excelObj.exportExcel();
    			}
    		},{
    			text:'清空选取列表',
    			handler:function(){
    				var j=0,len=selectedKpiIds.length;
    				for(var i=store.getCount()-1;i>-1;i--){
    					for(j=len-1;j>-1;j--){
							if(selectedKpiIds[j]==store.getAt(i).get("id")){
								csm.deselectRow(i);
							}
    					}
					}
    				selectedKpiIds=[];
    			}
    		},'-',{
    			text:'指标维度模板',
    			handler:function(){
    				dhcwl.mkpi.KpiDimTemplate.getKpiDimTemplate().show();
    			}
    		},{
    			text:'指标任务模板',
    			handler:function(){
    				dhcwl.mkpi.KpiTaskTemplate.getKpiTaskTemplate().show();
    			}
    		}
    	]
    });
    var outThis=this;
    var kpiObj=null;
    //dhcwl.mkpi.MaintainKpifl.setParentWin(this);
    //dhcwl.mkpi.MaintainDim.setParentWin(this);
    //dhcwl.mkpi.MaintainSection.setParentWin(this);
    //定义指标列模型
    var selectedKpiIds=[];
    var csm=new Ext.grid.CheckboxSelectionModel({
		listeners :{
			rowselect: function(sm, row, rec) {
        		var rd=rec;   //sm.getSelected();
        		var kpiId=rec.get("id");
        		kpiForm.getForm().loadRecord(rec);
        		sectionCombo.setValue(rd.get('section')); 
        		kpiFlCombo.setValue(rd.get('category'));
        		globalFlagCombo.setValue(rd.get('MKPIGlobalFlag'));
        		addSelectedKpiId(kpiId);
        		//alert(selectedKpiIds.join(","));
            },
            'rowdeselect':function(sm, row, rec){
				var kpiId=rec.get("id"),len=selectedKpiIds.length;
				for(var i=0;i<len;i++){
					if(selectedKpiIds[i]==kpiId){
						for(var j=i;j<len;j++){
							selectedKpiIds[j]=selectedKpiIds[j+1];
							//selectKpiObj[rec.get("kpiCode")]=rec.get("kpiName");
						}
						selectedKpiIds.length=len-1;
						break;
					}
				}
			}
		}
	});
	//start
	var columnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),csm,
        {header:'ID',dataIndex:'id',sortable:true, width: 30, sortable: true
        },{header:'编码',dataIndex:'kpiCode', width: 100, sortable: true 
        },{header:'指标名称',dataIndex:'kpiName', width: 160, sortable: true 
        },{header:'指标描述',dataIndex:'kpiDesc', width: 160, sortable: true 
        },{header:'执行代码',dataIndex:'kpiExcode', width: 180, sortable: true
        },{header:'是否使用global',dataIndex:'MKPIGlobalFlag', width: 80, sortable: true
        },{header:'创建者',dataIndex:'createUser', width: 80, sortable: true
        },{header:'创建/更新日期',dataIndex:'updateDate', width: 88, sortable: true 
        },{header:'数据节点',dataIndex:'dataNode', width: 80, sortable: true 
        },{header:'维度',dataIndex:'dimType',resizable:'true',width:88, sortable: true
        },{header:'类型',dataIndex:'category',resizable:'true',width:88, sortable: true
        },{header:'区间',dataIndex:'section',resizable:'true',width:88, sortable: true
        },{header:'备注',dataIndex:'nodeMark',resizable:'true',width:88
        }
    ]);
    //end
    //定义指标的存储模型
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/getkpidata.csp?action=mulSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'id'},
            	{name: 'kpiCode'},
            	{name: 'kpiName'},
            	{name: 'kpiDesc'},
            	{name: 'kpiExcode'},
            	{name: 'MKPIGlobalFlag'},
            	{name: 'createUser'},
            	{name: 'updateDate'},
            	{name: 'dataNode'},
            	{name: 'dimType'},
            	{name: 'category'},
            	{name: 'section'},
            	{name: 'nodeMark'}
       		]
    	})
    });
    //start
    var record= Ext.data.Record.create([
        {name: 'id', type: 'int'},
        {name: 'kpiCode', type: 'string'},
        {name: 'kpiName', type: 'string'},
        {name: 'kpiDesc', type: 'string'},
        {name: 'kpiExcode',type: 'string'},
        {name: 'MKPIGlobalFlag',type: 'string'},
        {name: 'createUser', type: 'string'},
        {name: 'updateDate', type: 'string'},
        {name: 'dataNode', type: 'string'},
        {name: 'dimType', type: 'string'},
        {name: 'category', type: 'string'},
        {name: 'section', type: 'string'},
        {name: 'nodeMark', type: 'string'}
	]);
	//end
	//定义指标的显示表格。
	var pageTool=new Ext.PagingToolbar({
        pageSize: 20,
        store: store,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录",
        listeners :{
			'change':function(pt,page){
				var id="",j=0,found=false,storeLen=selectedKpiIds.length;
				for(var i=store.getCount()-1;i>-1;i--){
					id=store.getAt(i).get("id");
					found=false;
					for(j=storeLen-1;j>-1;j--){
						if(selectedKpiIds[j]==id) found=true;
					}
					if(found){
						csm.selectRow(i,true,false);
					}
				}
			}
		}
    });
	var kpiGrid = new Ext.grid.GridPanel({
        id:"dhcwl.mkpi.ShowKpiWin.kpiTables",
        resizeAble:true,
        //autoHeight:true,
        height:485,
        loadMask:true,
        enableColumnResize :true,
        store: store,
        cm: columnModel,
        sm: csm /*new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
                	//Ext.getCmp("kpi-list").getForm().loadRecord(rec);
            		//var form=kpiForm.getForm();
            		var rd=sm.getSelected();
            		kpiForm.getForm().loadRecord(rec);
            		//if(!sectionCombo.getValue()) 
            			sectionCombo.setValue(rd.get('section'));
            		//if(!kpiFlCombo.getValue()) 
            			kpiFlCombo.setValue(rd.get('category'));
            		//if(!kpiDimCombo.getValue())
            			//kpiDimCombo.setValue(rd.get('dimType'));
            		//if(!globalFlagCombo.getValue())
            			globalFlagCombo.setValue(rd.get('MKPIGlobalFlag'));
                }
            }
        })*/,
        bbar:pageTool,
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        		var sm = this.getSelectionModel();
        		var record = sm.getSelected();
        		if(record){
        			var id=record.get("id");
                	var kpiName=record.get("kpiName");
                	var record = sm.getSelected();
                	selectRowId=id;
                	selectRowKpiName=kpiName;
        		}  
        	}
        }
    });  
    var sectionCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择指标区间',
		//fieldLabel : '日期区间类型',
		name : 'sectionCombo',
		displayField : 'secName',
		valueField : 'secCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getSectionCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'secCode'},{name:'secName'}])
		}),
		listeners :{
			'select':function(combox){
				sectionCombo.setValue(combox.getRawValue());
			}
		}
	});
    var kpiFlCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择指标分类',
		//fieldLabel : '日期区间类型',
		name : 'kpiFlCombo',
		displayField : 'kpiFlName',
		valueField : 'kpiFlCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getKpiflCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'kpiFlCode'},{name:'kpiFlName'}])
		}),
		listeners :{
			'select':function(combox){
				kpiFlCombo.setValue(combox.getRawValue());
			}
		}
	});
	var kpiDimCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择指标维度',
		//fieldLabel : '日期区间类型',
		name : 'kpiDimCombo',
		displayField : 'kpiDimName',
		valueField : 'kpiDimCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getKpiDimCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'kpiDimCode'},{name:'kpiDimName'}])
		}),
		listeners :{
			'select':function(combox){
				kpiDimCombo.setValue(combox.getRawValue());
			}
		}
	});
	var globalFlagCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '是否从指定global获得指标数据',
		value:'',
		name : 'globalFlagCombo',
		displayField : 'isGlobal',
		valueField : 'isGlobalV',
		store : new Ext.data.JsonStore({
			fields : ['isGlobal', 'isGlobalV'],
			data : [{
				isGlobal : '',
				isGlobalV : ''
			},{
				isGlobal : '否',
				isGlobalV : 'N'
			}, {
				isGlobal : '是',
				isGlobalV : 'Y'
			}]}),
		listeners :{
			'select':function(combox){
				globalFlagCombo.setValue(combox.getValue());
			}
		}
	});
   
    var kpiForm=new Ext.FormPanel({
        //id: 'kpi-list',
    	height: 145,
        frame: true,
        autoScroll:true,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        defaultConfig:{width:130},
        layout: 'table',
        layoutConfig: {columns:10},
        items:[{
        	html: 'ID:'
        },{
            //disabled:true,
        	editable:false,
            xtype:'textfield',
            name: 'id',
            id:'id',
            anchor:'95%'
        },{
            html: '编码：'
        },{
            name: 'kpiCode',
            id:'kpiCode',
            xtype:'textfield',
            anchor:'95%'
            //validator:dhcwl.mkpi.Util.valideValue
        },{
            html: '指标名称：'
        },{
            name: 'kpiName',
            id:'kpiName',
            xtype:'textfield',
            anchor:'95%'
        },{
            html: '指标描述：'
        },{
            name: 'kpiDesc',
            id:'kpiDesc',
            xtype:'textfield',
            anchor:'95%'
        },{
            html:'执行代码：'
        },{
            name:'kpiExcode',
            id:'kpiExcode',
            xtype:'textfield',
            width:300,
            flex:1
        },{
            html:'是否使用global：'
        },globalFlagCombo,{
            html: '创建者：'
        },{
            name: 'createUser',
            id:'createUser',
            xtype:'textfield',
            flex:1
        }, {
            html: '创建/更新日期：'
        },{
            xtype:'datefield',
            format :'Y-m-d',
            name: 'updateDate',
            id:'updateDate',
            width:130,
            flex:1
        },{
            html: '数据节点：'
        },{
        	xtype:'textfield',
            name: 'dataNode',
            id: 'dataNode'
         },{
            html: '维度：'
         },{
            xtype: 'compositefield',
            defaults: {
            	flex: 1,
            	width:275
            },
            items: [{
            	name:'dimType',
           	 	id:'dimType',
            	xtype:'textfield',
            	width:275,
            	flex:1,
            	listeners:{
            	
            	}
        	},{
                html: '<IMG id="kpiDimImg" onclick="dhcwl_mkpi_showKpiWin.setKpiDim()" src="../images/websys/lookup.gif" >'
            }]
        },/*{
            name:'dimType',
            id:'dimType',
            xtype:'textfield',
            width:300,
            flex:1,
            listeners:{
            	
            }
        },*///kpiDimCombo,
         /*
         {
            xtype: 'compositefield',
            defaults: {
            	flex: 1,
            	width:100
            },
            items: [{
                xtype: 'textfield',
                name:'dimType',
                id:'dimType'
            },{
                html: '<IMG id="kpiDimImg" src="../images/websys/lookup.gif" onclick="new dhcwl.mkpi.MaintainDim();">'
            }]
        },*/{
            html: '类型：'
        },kpiFlCombo,/*
		{
            xtype: 'compositefield',
            defaults: {
               flex: 1,
               width:100
            },
             items: [{
                 xtype: 'textfield',
                 name:'category',
                 id:'category'
             },{
                 html: '<IMG id="kpiflImg" src="../images/websys/lookup.gif" onclick="new dhcwl.mkpi.MaintainKpifl();">'
             }]
        },*/{
            html: '指标区间：'
        },sectionCombo,/*
		{
            xtype: 'compositefield',
            defaults: {
               flex: 1,
               width:100
            },
             items: [{
                 xtype: 'textfield',
                 name:'section',
                 id:'section'
             },{
                 html: '<IMG src="../images/websys/lookup.gif" onclick="new dhcwl.mkpi.MaintainSection();">'
             }]
        },*/{
            html: '备注：'
        },{
        	xtype:'textfield',
            name: 'nodeMark',
            id: 'nodeMark'
         } ],/*{
        buttons: [*/
        tbar: new Ext.Toolbar([{
            text: '添加指标',
            handler: function(){
				var date=dhcwl.mkpi.Util.nowDate();
                var initValue = {id:'',kpiCode:'',kpiName:'',updateDate:date,kpiDesc:'',createUser:'',nodeMark:'',dimType:'',category:'',section:'',dataNode:'',kpiExcode:''};
                var p = new record(initValue);
                //tableGride.stopEditing();
                store.insert(0, p);	
            }
        }, '-', {
            text: '删除指标',
            handler: function(){
            	var sm = kpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要删除的指标！");
                	return;
                }
                Ext.Msg.confirm('信息', '删除指标会删除该指标的所有指标维度，确定要删除？', function(btn){
                    if (btn == 'yes') {
                        var id=record.get("id");
                        dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/savekpi.csp?action=delete&id='+id);
                        store.remove(record);
                        dhcwl.mkpi.ShowKpiWin.prototype.refresh.apply(outThis);
                    }
                });
            }
        },'-',{
        	cls:'align:right',
        	text   : '保  存',
            handler: function() {
            	var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
            	//cursor=(cursor-1)*pageTool.pageSize;
            	//alert(cursor);
            	//var rowNums=pageTool.cursor;
                var paraValues; //=form.getValues(true);此方法会出现乱码
                var sm = kpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要保存的指标！");
                	return;
                }
                var id=record.get("id");
                var kpiName=Ext.get('kpiName').getValue();
                var kpiDesc=Ext.get('kpiDesc').getValue();
                var kpiCode=Ext.get('kpiCode').getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(kpiCode)||(reg2.test(kpiCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头");
                	Ext.get("kpiCode").focus();
                	return;
                }
                var kpiExcode=Ext.get('kpiExcode').getValue();
                var createUser=Ext.get('createUser').getValue();
                var updateDate=Ext.get('updateDate').getValue();
                var nodeMark=Ext.get('nodeMark').getValue();
                if(kpiExcode) kpiExcode=kpiExcode.trim();
                if(!kpiName||!kpiCode){
                	alert("指标代码或名称不能为空!");
                	return;
                }
                //var section=Ext.get('section').getValue(); //sectionCombo.getRawValue();
                //var dimType=Ext.get('dimType').getValue(); //kpiDimCombo.getRawValue();
                //var category=Ext.get('category').getValue(); //kpiFlCombo.getRawValue();
                var section=sectionCombo.getRawValue();
                var dimType=kpiDimCombo.getRawValue();
                var category=kpiFlCombo.getRawValue();
                var globalFlag=globalFlagCombo.getValue();
                var dataNode=Ext.get('dataNode').getValue();
                if(!globalFlag||globalFlag==""||globalFlag=='否'||globalFlag=='N') globalFlag='N';
                else globalFlag='Y';
                paraValues='id='+id+'&category='+category+'&kpiCode='+kpiCode+'&kpiExcode='+kpiExcode;
                //paraValues='id='+id+'&dimType='+dimType+'&category='+category+'&kpiCode='+kpiCode+'&kpiExcode='+kpiExcode;
                paraValues+='&createUser='+createUser+'&updateDate='+updateDate+'&nodeMark='+nodeMark;
  				paraValues+='&kpiName='+kpiName+'&kpiDesc='+kpiDesc+'&section='+section+'&dataNode='+dataNode;
  				paraValues+='&globalFlag='+globalFlag;
                //paraValues=paraValues+"&id="+id+"&dimType="+dimType+"&category="+category;
                //alert(paraValues);
                //return;
                //record.set("kpiCode",values.kpiCode),record.set("kpiName",values.kpiName),record.set("kpiDesc",values.kpiDesc);
                //record.set("createUser",values.createUser),record.set("updateDate",values.updateDate),record.set("nodeMark",values.nodeMark);
                //record.set("dimType",values.dimType),record.set("category",values.category);
                record.set("kpiCode",kpiCode),record.set("kpiName",kpiName),record.set("kpiDesc",kpiDesc);
                record.set("createUser",createUser),record.set("updateDate",updateDate),record.set("nodeMark",nodeMark);
                record.set("dimType",dimType);
                record.set("category",category),record.set("section",section);
                record.set("dataNode",dataNode),record.set("globalFlag",globalFlag);;
                dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/savekpi.csp?action=add&'+paraValues);
                store.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=mulSearch")); //&start="+cursor+"&limit="+20));
                store.load();
                //kpiGrid.show();
                //alert(cursor);
                pageTool.cursor=0;
                pageTool.doLoad(pageTool.pageSize*(cursor-1));
                /*for(var i=1;i<cursor;i++){
                	alert(cursor);
                	pageTool.moveNext();
                }*/
            	//dhcwl.mkpi.ShowKpiWin.prototype.refresh.apply(outThis);
            	//dhcwl_mkpi_taskWin.refresh();
           }
        },'-',{text   : '复  制',
        	cls:'align:right',
            handler: function() {
            	var sm = kpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要复制的指标！");
                	return;
                }
        		var kpiCode=record.get("kpiCode"),kpiName=record.get("kpiName"),kpiDesc=record.get("kpiDesc");
        		var kpiExcode=record.get("kpiExcode"),MKPIGlobalFlag=record.get("MKPIGlobalFlag"),createUser=record.get("createUser");
        		var updateDate=record.get("updateDate"),dataNode=record.get("dataNode"),dimType=record.get("dimType");
        		var category=record.get("category"),section=record.get("section"),nodeMark=record.get("nodeMark");
        		kpiObj ={kpiCode:kpiCode,kpiName:kpiName,kpiDesc:kpiDesc,kpiExcode:kpiExcode,MKPIGlobalFlag:MKPIGlobalFlag
        		,createUser:createUser,updateDate:updateDate,dataNode:dataNode,dimType:dimType,category:category,section:section,nodeMark:nodeMark
        		}   //new record(initValue);
        	}
        },'-',{text   : '粘 贴',
        	cls:'align:right',
            handler: function() {
            	var rec=new record(kpiObj);
        		kpiForm.getForm().loadRecord(rec);
        		sectionCombo.setValue(kpiObj.section); 
        		kpiFlCombo.setValue(kpiObj.category);
        		globalFlagCombo.setValue(kpiObj.MKPIGlobalFlag);
        	}
        },'-',{text   : '清  空',
        	cls:'align:right',
            handler: function() {
            	var form=kpiForm.getForm();
    			form.setValues({id:'',kpiName:'',kpiDesc:'',kpiDimCombo:'',kpiFlCombo:'',sectionCombo:'',globalFlagCombo:'',kpiCode:'',kpiExcode:'',createUser:'',updateDate:'',nodeMark:'',dataNode:'',dimType:''});
    			//sectionCombo.setValue(''),kpiDimCombo.setValue(''),kpiFlCombo.setValue('');
    			//dimType,category,section
        	}
        },'-',{text   : '查  找',
        	cls:'align:right',
            handler: function() {
            	var id=Ext.get('id').getValue();
                var kpiName=Ext.get('kpiName').getValue();
                var kpiDesc=Ext.get('kpiDesc').getValue();
                var dimType=Ext.get('dimType').getValue();
                //var category=Ext.get('category').getValue();
                var section=sectionCombo.getRawValue();
                //var dimType=kpiDimCombo.getRawValue();
                var category=kpiFlCombo.getRawValue();
                var kpiCode=Ext.get('kpiCode').getValue();
                var kpiExcode=Ext.get('kpiExcode').getValue();
                var createUser=Ext.get('createUser').getValue();
                var updateDate=Ext.get('updateDate').getValue();
                var nodeMark=Ext.get('nodeMark').getValue();
                var dataNode=Ext.get('dataNode').getValue();
                //var section=Ext.get('section').getValue();
                var globalFlag=globalFlagCombo.getValue();
                if(!globalFlag) globalFlag='';
                else if(globalFlag=='否'||globalFlag=='N') globalFlag='N';
                else if(globalFlag=='是'||globalFlag=='Y') globalFlag='Y';
                else globalFlag='';
                paraValues='kpiId='+id+'&dimType='+dimType+'&category='+category+'&kpiCode='+kpiCode+'&kpiExcode='+kpiExcode;
                paraValues+='&createUser='+createUser+'&updateDate='+updateDate+'&nodeMark='+nodeMark;
  				paraValues+='&kpiName='+kpiName+'&kpiDesc='+kpiDesc+'&section='+section+'&dataNode='+dataNode+'&globalFlag='+globalFlag;
                store.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=mulSearch&"+paraValues+"&onePage=1"));
                //alert(paraValues);
            	store.load();
    			kpiGrid.show();
           }
        }
      ]) //}]
    });
    //var kpiDimEle=Ext.get("kpiDimImg");
    //kpiDimEle.addListener("click",function(){getKpiDimObj().show();});
    var kpiShowWin =new Ext.Panel({
    	title:'指标维护',
    	layout:'border',
        items: [{
        	region: 'north',
            height: 148,
            //autoScroll:true,
            items:kpiForm
        },{
        	region:'center',
        	autoScroll:true,
            items:kpiGrid
    	}],
    	listeners:{
    		"resize":function(win,width,height){
    			kpiGrid.setHeight(height-150);
    			kpiGrid.setWidth(width-15);
    		},
    		"afterlayout":function(thisPanel,layout){
    			dhcwl.mkpi.Util.ajaxExc("dhcwl/kpi/mkpiinfo.csp",
            		{'action':'KPIVERSION'
            		},
            		function(responseText){
            			if(responseText['version'])
            				thisPanel.setTitle("指标维护--"+responseText['version']+"版本");
            		}
            		,outThis
            	);
    			
    		}
    	}
    });
    /*var kpiShowWin=new Ext.Panel({
    	id:'dhcwl_mkpi_showKpiWin22',
    	title:"指标维护",
    	//layout:'border',  //'table',
    	layout:'table',
        layoutConfig: {columns:1},
    	expandOnShow:true,
        resizable:true,
        width:3800,
        height:800,
        items: [
        {
            height: 140,
        	region: 'north',
        	autoScroll:true,
            items:kpiForm
        },
        {
        	region: 'center',
        	autoScroll:true,
            items:kpiGrid
        }]
    });*/
    
    
    
    store.load({params:{start:0,limit:20,onePage:1}});
 /*
 * 设置指标的维度，支持一个指标支持多个维度add@20130415
 */
    this.setKpiDim=function(){
		var sm = kpiGrid.getSelectionModel();
	    var record = sm.getSelected();
	    if(!sm||!record){
	    	alert("请选择要配置的指标！");
	    	return;
	    }
	    var id=record.get("id"),kpiName=record.get("kpiName");
	    if(!id||id==""){
	    	alert("指标未创建，请创建完毕指标，保存后再执行本操作！")
	    	return;
	    }
	    getKpiDimObj().show(id,kpiName);
	    /*
	     * 将指标id传入指标维度配置界面，配置该指标的维度
	     */
    
}
    this.getStore=function(){
    	return store;
    }
    this.getColumnModel=function(){
    	return columnModel;
    }
    this.getKpiShowWin=function(){
    	//kpiGrid.setHeight(kpiShowWin.getHeight()-158);
    	return kpiShowWin;
    }
    this.getKpiForm=function(){
    	return kpiForm;
    }
    this.getKpiGrid=function(){
    	return kpiGrid;
    }
    this.getRecord=function(){
    	return record;
    }
    this.refreshCombo=function(){
    	sectionCombo.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=getSectionCombo'));
    	sectionCombo.getStore().load();
    	sectionCombo.show();
    	kpiDimCombo.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=getKpiDimCombo'));
    	kpiDimCombo.getStore().load();
    	kpiDimCombo.show();
    	kpiFlCombo.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=getKpiflCombo'));
    	kpiFlCombo.getStore().load();
    	kpiFlCombo.show();
    }
    this.getSelectedKpiIds=function(){
    	return selectedKpiIds;
    }
    function addSelectedKpiId(id){
    	if(!id||id=="") return;
		for(var i=selectedKpiIds.length-1;i>-1;i--){
			if(selectedKpiIds[i]==id)
				return;
		}
		selectedKpiIds.push(id);
    }
}

/*dhcwl.mkpi.ShowKpiWin.prototype.setKpiDim=function(){
	var sm = kpiGrid.getSelectionModel();
    var record = sm.getSelected();
    if(!sm||!record){
    	alert("请选择要配置的指标！");
    	return;
    }
    var id=record.get("id"),kpiName=recorde.get("kpiName");
    getKpiDimObj().show(id,kpiName);
    
     * 将指标id传入指标维度配置界面，配置该指标的维度
     
    
}*/
//用于设置表单中某一个字段的值
dhcwl.mkpi.ShowKpiWin.prototype.setKpiFormFile=function(filed){
	this.getKpiForm().getForm().setValues(filed);
}
dhcwl.mkpi.ShowKpiWin.prototype.refresh=function(){
	this.getStore().proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=mulSearch&onePage=1"));
	this.getStore().load();
    this.getKpiGrid().show();
}
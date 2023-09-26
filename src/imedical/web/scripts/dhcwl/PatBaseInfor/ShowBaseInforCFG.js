(function(){
	Ext.ns("dhcwl.mkpi.ShowKpiWin");
})();
dhcwl.mkpi.ShowKpiWin=function(){
	//右键菜单定义
	Ext.QuickTips.init();
    var outThis=this;
    var BICObj=null;
    //定义指标列模型
    var selectedKpiIds=[];
    var csm=new Ext.grid.CheckboxSelectionModel({
		listeners :{
			rowselect: function(sm, row, rec) {
        		var rd=rec;   //sm.getSelected();
        		var kpiId=rec.get("ID");
        		kpiForm.getForm().loadRecord(rec);
        		selectDateFlag.setValue(rd.get('BICDateFlag')); 
        		sectionInterFlag.setValue(rd.get('BICInterFlag'));
        		NatureCombo.setValue(rd.get('BICNature'));
        		addSelectedKpiId(kpiId);
        		//alert(selectedKpiIds.join(","));
            },
            'rowdeselect':function(sm, row, rec){
				var kpiId=rec.get("ID"),len=selectedKpiIds.length;
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
        {header:'ID',dataIndex:'ID',sortable:true, width: 50, sortable: true
        },{header:'编码',dataIndex:'BICCode', width: 100, sortable: true 
        },{header:'描述',dataIndex:'BICDesc', width: 100, sortable: true 
        },{header:'时间属性',dataIndex:'BICDateFlag', width: 100, sortable: true
        },{header:'取值标志',dataIndex:'BICInterFlag', width: 100, sortable: true
        },{header:'自然属性',dataIndex:'BICNature', width: 100, sortable: true
        },{header:'取值函数',dataIndex:'BICFunction', width: 150, sortable: true 
        }
    ]);
    //end
    //定义指标的存储模型
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/PatBaseInfor/GetPBIData.csp?action=mulSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'ID'},
            	{name: 'BICCode'},
            	{name: 'BICDesc'},
            	{name: 'BICDateFlag'},
            	{name: 'BICInterFlag'},
            	{name: 'BICNature'},
            	{name: 'BICFunction'}
       		]
    	})
    });
    //start
    var record= Ext.data.Record.create([
        {name: 'ID', type: 'int'},
        {name: 'BICCode', type: 'string'},
        {name: 'BICDesc', type: 'string'},
        {name: 'BICDateFlag', type: 'string'},
        {name: 'BICInterFlag',type: 'string'},
        {name: 'BICNature',type: 'string'},
        {name: 'BICFunction', type: 'string'}
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
					id=store.getAt(i).get("ID");
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
        sm: csm ,
        bbar:pageTool,
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		var sm = this.getSelectionModel();
        		var record = sm.getSelected();
        		if(record){
        			var id=record.get("ID");
                	var kpiName=record.get("BICDesc");
                	var record = sm.getSelected();
                	selectRowId=id;
                	selectRowKpiName=kpiName;
        		}  
        	}
        }
    });  
    var selectDateFlag=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择时间属性',
		name : 'selectDateFlag',
		displayField : 'secName',
		valueField : 'secCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/PatBaseInfor/PBIService.csp?action=selectDateFlag'}),
			reader:new Ext.data.ArrayReader({},[{name:'secCode'},{name:'secName'}])
		}),
		listeners :{
			'select':function(combox){
				selectDateFlag.setValue(combox.getRawValue());
			}
		}
	});
    var sectionInterFlag=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择取值标志',
		name : 'sectionInterFlag',
		displayField : 'secName',
		valueField : 'secCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/PatBaseInfor/PBIService.csp?action=selectInterFlag'}),
			reader:new Ext.data.ArrayReader({},[{name:'secCode'},{name:'secName'}])
		}),
		listeners :{
			'select':function(combox){
				sectionInterFlag.setValue(combox.getRawValue());
			}
		}
	});
	var NatureCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		emptyText : '请选择自然属性',
		value:'',
		name : 'NatureCombo',
		displayField : 'NatureL',
		valueField : 'NatureV',
		store : new Ext.data.JsonStore({
			fields : ['NatureL', 'NatureV'],
			data : [{
				NatureL : '',
				NatureV : ''
			},{
				NatureL : '更新<RF>',
				NatureV : 'RF'
			}, {
				NatureL : '累计<AF>',
				NatureV : 'AF'
			}]}),
		listeners :{
			'select':function(combox){
				NatureCombo.setValue(combox.getValue());
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
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        defaultConfig:{width:130},
        layout: 'table',
        layoutConfig: {columns:8},
        items:[{
        	html: 'ID:'
        },{
            //disabled:true,
        	editable:true,
            xtype:'textfield',
            name: 'ID',
            id:'ID',
            anchor:'95%'
        },{
            html: '编 码：'
        },{
            name: 'BICCode',
            id:'BICCode',
            xtype:'textfield',
            anchor:'95%'
        },{
            html: '描 述：'
        },{
            name: 'BICDesc',
            id:'BICDesc',
            xtype:'textfield',
            anchor:'95%'
        },{
            html: '时间属性：'
        },selectDateFlag,{
            html:'取值标志：'
        },sectionInterFlag,{
            html: '自然属性：'
        }, NatureCombo,{
            html: '取值函数'
        },{
            xtype:'textfield',
            name: 'BICFunction',
            id:'BICFunction',
            width:130,
            flex:1
        }],
        tbar: new Ext.Toolbar([{
            text: '添 加',
            handler: function(){
                var initValue = {ID:'',BICCode:'',BICDesc:'',BICDateFlag:'',BICInterFlag:'',BICNature:'',BICFunction:''};
                var p = new record(initValue);
                store.insert(0, p);	
            }
        }, '-', {
            text: '删 除',
            handler: function(){
            	var sm = kpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要删除的病人基础信息！");
                	return;
                }
                var id=record.get("ID");
                Ext.Msg.confirm('信息', '确定要删除BICRowid='+id+'的病人基础信息？', function(btn){
                    if (btn == 'yes') {
                        var id=record.get("ID");
                        dhcwl.mkpi.Util.ajaxExc('dhcwl/PatBaseInfor/SavePBIData.csp?action=delete&ID='+id);
                        store.remove(record);
                        //dhcwl.mkpi.ShowKpiWin.prototype.refresh.apply(outThis);
                    }
                });
            }
        },'-',{
        	cls:'align:right',
        	text   : '保  存',
            handler: function() {
            	var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
              	var paraValues; 
                var sm = kpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要保存的病人基础信息！");
                	return;
                }
                var ID=record.get("ID");
                var BICCode=Ext.get('BICCode').getValue();
                var BICDesc=Ext.get('BICDesc').getValue();
                var BICFunction=Ext.get('BICFunction').getValue();
                var BICDateFlag=selectDateFlag.getRawValue();
                var BICInterFlag=sectionInterFlag.getRawValue();
                var BICNature=NatureCombo.getRawValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(BICCode)||(reg2.test(BICCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头");
                	Ext.get("BICCode").focus();
                	return;
                }

                if(BICCode) BICCode=BICCode.trim();
                if(!BICCode||!BICDesc||!BICDateFlag||!BICInterFlag||!BICNature||!BICFunction){
                	alert("病人基础信息不全!");
                	return;
                }
                paraValues='ID='+ID+'&BICCode='+BICCode+'&BICDesc='+BICDesc+'&BICDateFlag='+BICDateFlag;
                paraValues+='&BICInterFlag='+BICInterFlag+'&BICNature='+BICNature+'&BICFunction='+BICFunction;
 				//alert(paraValues);
  				record.set("ID",ID),record.set("BICCode",BICCode),record.set("BICDesc",BICDesc);
                record.set("BICDateFlag",BICDateFlag),record.set("BICInterFlag",BICInterFlag),record.set("BICNature",BICNature);
                record.set("BICFunction",BICFunction);
                dhcwl.mkpi.Util.ajaxExc('dhcwl/PatBaseInfor/SavePBIData.csp?action=add&'+paraValues);
                store.proxy.setUrl(encodeURI("dhcwl/PatBaseInfor/GetPBIData.csp?action=mulSearch")); //&start="+cursor+"&limit="+20));
                store.load();
                pageTool.cursor=0;
                pageTool.doLoad(pageTool.pageSize*(cursor-1));
           }
        },'-',{text   : '复  制',
        	cls:'align:right',
            handler: function() {
            	var sm = kpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要复制的病人基础信息！");
                	return;
                }
        		var BICCode=record.get("BICCode"),BICDesc=record.get("BICDesc"),BICDateFlag=record.get("BICDateFlag");
        		var BICInterFlag=record.get("BICInterFlag"),BICNature=record.get("BICNature"),BICFunction=record.get("BICFunction");
        		BICObj ={BICCode:BICCode,BICDesc:BICDesc,BICDateFlag:BICDateFlag,BICInterFlag:BICInterFlag,BICNature:BICNature,BICFunction:BICFunction
        		}
        	}
        },'-',{text   : '粘 贴',
        	cls:'align:right',
            handler: function() {
				if (!BICObj){
					Ext.MessageBox.alert("错误请求","您还没有复制病人基础信息，请选择您要复制的基础信息后再执行粘贴操作！");
					return;
				}
				var rec=new record(BICObj);
        		kpiForm.getForm().loadRecord(rec);
        		selectDateFlag.setValue(BICObj.BICDateFlag); 
        		sectionInterFlag.setValue(BICObj.BICInterFlag);
        		NatureCombo.setValue(BICObj.BICNature);
        	}
        },'-',{text   : '清  空',
        	cls:'align:right',
            handler: function() {
            	var form=kpiForm.getForm();
    			form.setValues({ID:'',BICCode:'',BICDesc:'',BICDateFlag:'',BICInterFlag:'',BICNature:'',BICFunction:''});
    			selectDateFlag.setValue('');
    			sectionInterFlag.setValue('');
    			NatureCombo.setValue('');
    			BICObj=null;
        	}
        },'-',{text   : '查  找',
        	cls:'align:right',
            handler: function() {
            	var ID=Ext.get('ID').getValue();
                var BICCode=Ext.get('BICCode').getValue();
                var BICDesc=Ext.get('BICDesc').getValue();
                var BICFunction=Ext.get('BICFunction').getValue();
                var BICDateFlag=selectDateFlag.getRawValue();
                var BICInterFlag=sectionInterFlag.getRawValue();
                var BICNature=NatureCombo.getRawValue();
                paraValues='ID='+ID+'&BICCode='+BICCode+'&BICDesc='+BICDesc+'&BICFunction='+BICFunction+'&BICDateFlag='+BICDateFlag;
                paraValues+='&BICInterFlag='+BICInterFlag+'&BICNature='+BICNature;
	            store.proxy.setUrl(encodeURI("dhcwl/PatBaseInfor/GetPBIData.csp?action=mulSearch&"+paraValues+"&onePage=1"));
            	store.load();
    			kpiGrid.show();
           }
        }
      ])
    });
    var kpiShowWin =new Ext.Panel({
    	title:'病人基础信息',
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
    		}
    	}
    });
    store.load({params:{start:0,limit:20,onePage:1}});
    this.getStore=function(){
    	return store;
    }
    this.getColumnModel=function(){
    	return columnModel;
    }
    this.getKpiShowWin=function(){
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
//用于设置表单中某一个字段的值
dhcwl.mkpi.ShowKpiWin.prototype.setKpiFormFile=function(filed){
	this.getKpiForm().getForm().setValues(filed);
}
dhcwl.mkpi.ShowKpiWin.prototype.refresh=function(){
	this.getStore().proxy.setUrl(encodeURI("dhcwl/PatBaseInfor/GetPBIData.csp?action=mulSearch&onePage=1"));
	this.getStore().load();
    this.getKpiGrid().show();
}
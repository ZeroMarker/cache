(function(){
	Ext.ns("dhcwl.checkfun.CheckFunKpi");
})();

 // 
dhcwl.checkfun.CheckFunKpi=function(){
	//var parentWin=null;
	
	var serviceUrl="dhcwl/checkfun/checkfunservice.csp";
	var outThis=this;
	var curStart=0,curLimit=0;
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true},
        {header:'指标编码',dataIndex:'kpiCode',sortable:true, width: 100, sortable: true},
        {header:'指标描述',dataIndex:'kpiDesc', width: 100, sortable: true},
        {header:'有效标志',dataIndex:'kpiFlag', width: 160, sortable: true},
        {header:'更新日期',dataIndex:'kpiUpdateDate', width: 160, sortable: true},
        {header:'更新用户',dataIndex:'kpiUpdateUser', width: 160, sortable: true}
    ]);

    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearchKpi&className=DHCWL.CheckFun.CheckKPI&start=0&limit=21&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'kpiCode'},
            	{name: 'kpiDesc'},
            	{name: 'kpiFlag'},
            	{name: 'kpiUpdateDate'},
            	{name: 'kpiUpdateUser'}
            
       		]
    	})
    });
    //store.load()
    //store.load({params:{start:1,limit:21}});
    /*
    
    var myData = [
        ['1','分类编码1','分类描述1','执行代码1','值描述1','有效标志1'],
        ['2','分类编码2','分类描述1','执行代码1','值描述1','有效标志1'],
        ['5','分类编码5','分类描述1','执行代码1','值描述1','有效标志1']
    ];
    

   // create the data store
    var store = new Ext.data.ArrayStore({
        fields: [
           {name: 'ID'},
           {name: 'CheckKPICode'},
           {name: 'CheckKPIDesc'},
           {name: 'CheckKPIFlag'},
           {name: 'CheckKPIUpdateDate'},
           {name: 'CheckKPIUpdateUser'}
     
        ]
    });

    // manually load local data
    store.loadData(myData);
    */
    
    var CheckFunKpiGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:480,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
            		var id=rec.get("ID");
            		var form=CheckFunKpiForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({ID:id});
             	}
            }
        }),
        listeners:{
        	'contextmenu':function(event){
        		//event.preventDefault();
        		//quickMenu.showAt(event.getXY());
        	}
        },
       
        
        
         
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners:{
            	'beforechange':function(pt,params){
            		curStart=params.start;
            		curLimit=params.limit;
            	}
            }
        }),
        tbar: new Ext.Toolbar([
        ])
        
    });
    
    var kpiFlagCombo=new Ext.form.ComboBox({
		//width : 130,
		anchor : '80%',	
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '有效标志',
		value:'',
		name : 'kpiFlagCombo',
		id:  'kpiFlag',
		displayField : 'isValid',
		valueField : 'isValidV',
		tpl:'<tpl for=".">'+'<div class="x-combo-list-item" style="height:16px;">'+'{isValid}'+'</div>'+'</tpl>',
		store : new Ext.data.JsonStore({
			fields : ['isValid', 'isValidV'],
			data : [{
				isValid : '',
				isValidV : ''
			},{
				isValid : '是',
				isValidV : 'Y'
			},{
				isValid : '否',
				isValidV : 'N'
			}]}),
		listeners :{
			'select':function(combox){
				kpiFlagCombo.setValue(combox.getValue());
			}
		}
	});
	
    var CheckFunKpiForm = new Ext.FormPanel({
		/*
        frame: true,
        height: 102,
        labelAlign: 'left',
        //title: '指标分类列表',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        layoutConfig: {columns:10},
        items:[{
        	html: 'ID：'
        },{
            xtype:'textfield',
            name: 'ID',
            //id: 'ID',
            disabled:true,
            anchor:'95%'
        },{
        	html: '指标编码：'
        },{
            xtype:'textfield',
            name: 'kpiCode',
            id: 'kpiCode',
            anchor:'95%'
            //validator:dhcwl.codecfg2.Util.valideValue
        },{
            html: '指标描述：'
        },{
            name: 'kpiDesc',
            id: 'kpiDesc',
            xtype:'textfield',
            anchor:'95%'
        },{
            html:'有效标志：'
        },kpiFlagCombo],  //,{buttons:
		*/
		        frame: true,
		labelAlign : 'right',
		labelWidth : 65,
		bodyStyle : 'padding:5px',
		style : {
			"margin-right" : Ext.isIE6 ? (Ext.isStrict
					? "-10px"
					: "-13px") : "0"
		},
		
		layout : 'column',
		items:[
		{
			columnWidth : .25,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
				fieldLabel : 'ID',
				name: 'ID',
				disabled:true,
				anchor:'80%'				
			}]
		},{
			columnWidth : .25,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
				fieldLabel : '指标编码',
            name: 'kpiCode',
            id: 'kpiCode',
				anchor:'80%'						
			}]
		},{
			columnWidth : .25,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
				fieldLabel : '指标描述',
            name: 'kpiDesc',
            id: 'kpiDesc',
				anchor : '80%'				
			}]
		},{
			columnWidth : .25,
			layout : 'form',
			defaultType : 'textfield',
			items : kpiFlagCombo
		}],		
		
         tbar:new Ext.Toolbar([
         	{text: '<span style="line-Height:1">增加</span>',
icon   : '../images/uiimages/edit_add.png',
         	 handler: function() {
            	var form=CheckFunKpiForm.getForm();
                var values=form.getValues(false);
                var kpiCode=Ext.get('kpiCode').getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(kpiCode)||(reg2.test(kpiCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	Ext.get("kpiCode").focus();
                	return;
                }
                
                var kpiDesc=Ext.get('kpiDesc').getValue();
                var kpiFlag=kpiFlagCombo.getValue();
                if((!kpiCode)||(!kpiDesc)||(!kpiFlag)){
							alert("指标编码或者指标描述或者有效标志不能为空!");
							return;
							}
                var kpiUpdateUser="";
                paraValues='kpiCode='+kpiCode+'&kpiDesc='+kpiDesc+'&kpiFlag='+kpiFlag+'&kpiUpdateUser='+kpiUpdateUser;
                //alert(paraValues);    
                //return            
                //dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addCodecfg&'+paraValues);
                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addCheckFunKpi&'+paraValues);
            	store.load();
            	//this.refresh();
    			CheckFunKpiGrid.show();
         	
                }
            },'-',
         	{text: '<span style="line-Height:1">更新</span>',
icon   : '../images/uiimages/update.png',	
         	 //disabled : Ext.BDP.FunLib.Component.DisableFlag('updata_btn'),
         	 handler:function(){
         	 	var form=CheckFunKpiForm.getForm();
                var values=form.getValues(false);
         	 	var sm = CheckFunKpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要更新的行！");
               		return;}
         	 	Ext.Msg.confirm('信息', '确定要更新？', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID");
                        var kpiCode=Ext.get('kpiCode').getValue();
					 	var kpiDesc=Ext.get('kpiDesc').getValue();
					 	var kpiFlag=kpiFlagCombo.getValue();
						var kpiUpdateUser="";
                		if((!kpiDesc)||(!kpiFlag)||(!kpiCode)){
									alert("指标编码或者指标描述或者有效标志不能为空!");
									return;
								}
                		paraValues='ID='+ID+'&kpiCode='+kpiCode+'&kpiDesc='+kpiDesc+'&kpiFlag='+kpiFlag+'&kpiUpdateUser='+kpiUpdateUser;
                        //store.remove(record);
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=updateCheckFunKpi&'+paraValues);
                		store.load();
                		
                		}
                	});
         	 }
         	/*
         	},'-',
         	{text: '删 除',
         	 //disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
             handler: function(){
            	var sm = CheckFunKpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要删除的行！");
               		return;}
                Ext.Msg.confirm('信息', '删除考核指标？', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID");
                        store.remove(record);
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteCheckFunKpi&ID='+ID);
                		//this.refresh();
                		var form=CheckFunKpiForm.getForm();
                		///alert(111);
                		form.setValues({ID:'',kpiCode:'',kpiDesc:'',kpiFlagCombo:''});
                		//dhcwl_codecfg_showKpiWin.refreshCombo();
                		}
                	});
                }
                */
            },'-',
         	{text: '<span style="line-Height:1">清空</span>',						
icon   : '../images/uiimages/clearscreen.png',
         	 //disabled : Ext.BDP.FunLib.Component.DisableFlag('clear_btn'),
         	 handler: function() {
            	var form=CheckFunKpiForm.getForm();
    			form.setValues({ID:'',kpiCode:'',kpiDesc:'',kpiFlagCombo:''});
    			}
         	},'-',
         	{text: '<span style="line-Height:1">查询</span>',
icon   : '../images/uiimages/search.png',	
         	 //disabled : Ext.BDP.FunLib.Component.DisableFlag('search_btn'),
         	 handler: function() {
                            var kpiCode=Ext.get('kpiCode').getValue();
							var kpiDesc=Ext.get('kpiDesc').getValue();
						    var kpiFlag=kpiFlagCombo.getValue();
							if (kpiFlag=="是") kpiFlag="Y";
							else if (kpiFlag=="否") kpiFlag="N";
						    paraValues='kpiCode='+kpiCode+'&kpiDesc='+kpiDesc+'&kpiFlag='+kpiFlag;
						    //alert(paraValues);
						    //store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearchKpi&className=DHCWL.CheckFun.CheckKPI&"+paraValues+"&start=0&limit=21&onePage=1"));
						    //store.reload();
							store.reload({params:{start:0,limit:21,action:'mulSearchKpi',className:'DHCWL.CheckFun.CheckKPI','kpiCode':kpiCode,kpiDesc:kpiDesc,kpiFlag:kpiFlag}});
						    CheckFunKpiGrid.show();
    			}
         	}
    ])
    });

    
    var CheckFunKpiPanel =new Ext.Panel({
    	title:'考核指标',
    	layout:'border',
        items: [{
        	region: 'north',
            height: 100,
			layout:'fit',
            //autoScroll:true,
            items:CheckFunKpiForm
        },{
        	region:'center',
        	//height:500,
        	//autoScroll:true,
			layout:'fit',
            items:CheckFunKpiGrid
    	}]/*,
    	listeners:{
    		"resize":function(win,width,height){
    			CheckFunKpiGrid.setHeight(height-110);
    			CheckFunKpiGrid.setWidth(width-15);
    		}
    	}*/
    	
    });
    CheckFunKpiPanel.on('activate',function(thsss){
    	store.load({params:{start:0,limit:21}});
    });
    
    this.getCheckFunKpiPanel=function(){
    	return CheckFunKpiPanel;
    }
}


    



(function(){
	Ext.ns("dhcwl.checkfun.CheckFunKpiMain");
})();

 // 
dhcwl.checkfun.CheckFunKpiMain=function(setName){
	var parentWin=null;
	var serviceUrl="dhcwl/checkfun/checkfunservice.csp";
	var outThis=this;
	var curStart=0;curLimit=0;
	this.setName=setName;
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true},
        {header:'指标编码',dataIndex:'kpiCode',sortable:true, width: 100, sortable: true},
        {header:'指标描述',dataIndex:'kpiDesc', width: 100, sortable: true},
        {header:'有效标志',dataIndex:'kpiFlagMain', width: 160, sortable: true},
        {header:'更新日期',dataIndex:'kpiUpdateDate', width: 160, sortable: true},
        {header:'更新用户',dataIndex:'kpiUpdateUser', width: 160, sortable: true}
    ]);

    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearchKpiMain&start=0&limit=21&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'kpiCode'},
            	{name: 'kpiDesc'},
            	{name: 'kpiFlagMain'},
            	{name: 'kpiUpdateDate'},
            	{name: 'kpiUpdateUser'}
            
       		]
    	})
    });
    //store.load()
    //store.load({params:{start:1,limit:21}});
	store.load({params:{start:0,limit:21}});
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
    
    var CheckFunKpiMainGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        //height:480,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
            		var id=rec.get("ID");
            		var form=CheckFunKpiMainForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({ID:id});
             	}
            }
        }),
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		//quickMenu.showAt(event.getXY());
        	}
        },
        bbar:new Ext.PagingToolbar({
        	pageSize:21,
        	store:store,
        	displayInfo:true,
        	dislpayMsg:'显示第 {0}条到第{1}条记录，一共{2}条记录',
        	emptyMsg:"没有记录",
        	listeners:{
        		'beforechange':function(pt,params){
        			curStart=params.start;
        			curLimit=params.limit;
        		}
        	}
        	
        })
        
         /*
         ,
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),
        tbar: new Ext.Toolbar([
        ])
        */
    });
    
    var kpiFlagMainCombo=new Ext.form.ComboBox({
		//width : 130,
		anchor:'95%',
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '有效标志',
		value:'',
		name : 'kpiFlagMainCombo',
		id:  'kpiFlagMain',
		displayField : 'isValid',
		valueField : 'isValidV',
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
				kpiFlagMainCombo.setValue(combox.getValue());
			}
		}
	});
	
    var CheckFunKpiMainForm = new Ext.FormPanel({
        frame: true,
        //height:104 ,
        /*
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
            id: 'kpiCodeM',
            anchor:'95%'
        },{
            html: '指标描述：'
        },{
            name: 'kpiDesc',
            id: 'kpiDescM',
            xtype:'textfield',
            anchor:'95%'
        },{
            html:'有效标志：'
        },kpiFlagMainCombo],  //,{buttons:
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
			columnWidth : .5,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
				fieldLabel : 'ID',
				name: 'ID',
				disabled:true,
				anchor:'95%'				
			},{
				fieldLabel : '指标描述',
				name: 'kpiDesc',
				id: 'kpiDescM',
				xtype:'textfield',
				anchor:'95%'				
			}]
		},{
			columnWidth : .5,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
				fieldLabel : '指标编码',
				xtype:'textfield',
				name: 'kpiCode',
				id: 'kpiCodeM',
				anchor:'95%'						
			},kpiFlagMainCombo]
		}],				
		
		
		
         tbar:new Ext.Toolbar([
         	{text: '<span style="line-Height:1">增加</span>',
icon   : '../images/uiimages/edit_add.png',
         	 handler: function() {
            	var form=CheckFunKpiMainForm.getForm();
                var values=form.getValues(false);
                var kpiCode=Ext.get('kpiCodeM').getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(kpiCode)||(reg2.test(kpiCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	Ext.get("kpiCode").focus();
                	return;
                }
                
                var kpiDesc=Ext.get('kpiDescM').getValue();
                var kpiFlag=kpiFlagMainCombo.getValue();
                paraValues='kpiCode='+kpiCode+'&kpiDesc='+kpiDesc+'&kpiFlag='+kpiFlag+'&kpiUpdateUser='+kpiUpdateUser;
                
                if((!kpiCode)||(!kpiDesc)||(!kpiFlag)){
							alert("指标编码或者指标描述或者有效标志不能为空!");
							return;
							}
                var kpiUpdateUser="";
                paraValues='kpiCode='+kpiCode+'&kpiDesc='+kpiDesc+'&kpiFlag='+kpiFlag+'&kpiUpdateUser='+kpiUpdateUser;
                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addCheckFunKpi&'+paraValues);
            	store.load();
            	//this.refresh();
    			CheckFunKpiMainGrid.show();
         	
                }
            },'-',
         	{text: '<span style="line-Height:1">更新</span>',
icon   : '../images/uiimages/update.png',
         	 handler:function(){
         	 	var form=CheckFunKpiMainForm.getForm();
                var values=form.getValues(false);
         	 	var sm = CheckFunKpiMainGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要更新的行！");
               		return;}
         	 	Ext.Msg.confirm('信息', '确定要更新？', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID");
                        var kpiCode=Ext.get('kpiCodeM').getValue();
					 	var kpiDesc=Ext.get('kpiDescM').getValue();
					 	var kpiFlag=kpiFlagMainCombo.getValue();
						var kpiUpdateUser="";
                		if((!kpiDesc)||(!kpiFlag)||(!kpiCode)){
									alert("指标编码或者指标描述或者有效标志不能为空!");
									return;
								}
                		paraValues='ID='+ID+'&kpiCode='+kpiCode+'&kpiDesc='+kpiDesc+'&kpiFlag='+kpiFlag+'&kpiUpdateUser='+kpiUpdateUser;
                		dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=updateCheckFunKpi&'+paraValues);
                		store.load();
                		
                		}
                	});
         	 }
         	
            },'-',
         	{text: '<span style="line-Height:1">清空</span>',					
icon   : '../images/uiimages/clearscreen.png',
         	 //disabled : Ext.BDP.FunLib.Component.DisableFlag('clear_btn'),
         	 handler: function() {
            	var form=CheckFunKpiMainForm.getForm();
    			form.setValues({ID:'',kpiCode:'',kpiDesc:'',kpiFlagMainCombo:''});
    			}
         	},'-',
         	{text: '<span style="line-Height:1">查询</span>',
icon   : '../images/uiimages/search.png',	
         	 //disabled : Ext.BDP.FunLib.Component.DisableFlag('search_btn'),
         	 handler: function() {
                            var kpiCode=Ext.get('kpiCodeM').getValue();
							var kpiDesc=Ext.get('kpiDescM').getValue();
						    var kpiFlag=kpiFlagMainCombo.getValue();
							
							if (kpiFlag=="是") kpiFlag="Y";
							else if (kpiFlag=="否") kpiFlag="N";
							
						    //paraValues='kpiCode='+kpiCode+'&kpiDesc='+kpiDesc+'&kpiFlag='+kpiFlag;
							paraValues='kpiCode='+kpiCode+'&kpiDesc='+kpiDesc+'&kpiFlagMain='+kpiFlag;
						    
							//alert(paraValues);
						    //store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearchKpi&className=DHCWL.CheckFun.CheckKPI&"+paraValues+"&start=0&limit=21&onePage=1"));
						    store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSearchKpiMain&className=DHCWL.CheckFun.CheckKPI&"+paraValues+"&start=0&limit=21&onePage=1"));
						    
							
							store.reload();
						    CheckFunKpiMainGrid.show();
    			}
         	},'-',
         	{
text: '<span style="line-Height:1">关闭</span>',
icon   : '../images/uiimages/cancel.png',
         		handler:function(){
         			Ext.Msg.confirm('信息', '方案对应的指标维护完成？', function(btn){
         				if (btn == 'yes'){
         					var kpiStore=parentWin.getkpiStore();
         					kpiStore.reload();
         					kpiMainWin.close();
         				
         				}
         				else{
         					return;
         				
         				}
         			
         			})
         		 			
         		}
         		
         	}
         	
    ])
    });

    
    var CheckFunKpiMainPanel =new Ext.Panel({
    	//title:'考核指标',
		/*
    	layout:'table',
    	layoutConfig:{columns:1},
        items: [{
        	//region: 'north',
            height: 120,
            //width: 800,
            //autoScroll:true,
			layout:'fit',
            items:CheckFunKpiMainForm
        },{
        	//region:'center',
        	layout:'fit',
            items:CheckFunKpiMainGrid
    	}]
		*/
				layout: {
				type:'vbox',
				//padding:'0',
				align:'stretch',
				border:false
			},        
			items: [
				{
					title:'选择统计项',
					flex:1,
					layout:'fit',
					items:CheckFunKpiMainForm
				},{
					flex:3,
					layout:'fit',
					items:CheckFunKpiMainGrid			
				}
				]
			
    });
    var kpiMainWin=new Ext.Window({
		title:'考核指标',
		//layout:'table',
		width:810,
		height:540,
		modal:true,
				layout: {
				type:'vbox',
				//padding:'0',
				align:'stretch',
				border:false
			},        
			items: [
				{
					title:'选择统计项',
					flex:3,
					layout:'fit',
					items:CheckFunKpiMainForm
				},{
					flex:7,
					layout:'fit',
					items:CheckFunKpiMainGrid			
				}
				]
	});
	kpiMainWin.on('close',function(ths){
							var kpiStore=parentWin.getkpiStore();
         					kpiStore.reload();
	});
    
    this.getCheckFunKpiPanel=function(){
    	return CheckFunKpiMainPanel;
    }
    this.setParentWin=function(win){
		parentWin=win;
		var winTitle=setName+"---方案考核指标维护页面";
		kpiMainWin.setTitle(winTitle);
		kpiMainWin.show();
	}
	this.setSubWinParam=function(msetName){
		
		setName=msetName;
	}
}


    



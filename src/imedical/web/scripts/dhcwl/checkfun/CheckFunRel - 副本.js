(function(){
	Ext.ns("dhcwl.checkfun.CheckFunRel");
})();
dhcwl.checkfun.CheckFunRel=function(setId,setName){
	//setId="24";
	var parentWin=null;
	var KpiId=null;
	this.setId=setId;
	this.setName=setName;
	var serviceUrl="dhcwl/checkfun/checkfunrelservice.csp";
	var outThis=this;
	var columnModel=new Ext.grid.ColumnModel([
	{header:'ID',dataIndex:'ID',sortable:true,width:40,sortable:true},
	{header:'指标ID',dataIndex:'relkpiId',sortable:true,width:60,sortable:true},
	{header:'指标描述',dataIndex:'relkpiDesc',sortable:true,width:190,sortable:true},
	{header:'更新日期',dataIndex:'uDate',sortable:true,width:140,sortable:true},
	{header:'更新用户',dataIndex:'uUser',sortable:true,width:140,sortable:true}
	]);
	var store=new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSerchRel&start=0&limit=21&setId='+setId}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
			{name:'ID'},
			{name:'relkpiId'},
			{name:'relkpiDesc'},
			{name:'uDate'},
			{name:'uUser'}
			]
		})
	});
	store.load({params:{start:0,limit:21}});
	var relationGrid=new Ext.grid.GridPanel({
		stripeRows:true,
		loadMask:true,
		height:400,
		store:store,
		resizeAble:true,
		enableColumnResize:true,
		cm:columnModel,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
				rowselect:function(sm,row,rec){
					var id=rec.get("ID");
					var form=relationForm.getForm();
					form.loadRecord(rec);
					form.setValues({ID:id});
					if(id!=""){
						form.findField('relkpiId').disable();
						form.findField('relkpiDesc').disable();
					}
					else{
						form.findField('relkpiId').enable();
						form.findField('relkpiDesc').enable();
					}
				}
			}
		}),
		listeners:{
			'contextmenu':function(event){
				event.preventDefault();
			}
		},
		bbar:new Ext.PagingToolbar({
				pageSize: 21,
				store:store,
				displayInfo: true,
				displayMsg:'显示第{0} 条到第{1}条记录,一共{2}条记录',
				emptyMsg:'没有记录',
				listeners:{
					'beforechange':function(pt,params){
						curStartP=params.start;
						curLimitP=params.limit;
					}
				}
			})
		
	});
	var relationForm=new Ext.FormPanel({
		frame:true,
		height:100,
		width:610,
		labelAlign: 'left',
		bodyStyle:'padding:5px',
		style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        layoutConfig: {columns:8},
        items:[{
        	html:'ID: ',
        	width:40
        },{
        	xtype:'textfield',
            name: 'ID',
            //id: 'ID',
            disabled:true,
            width:80,
            anchor:'80%'
        },{
        	html: '考核指标ID：',
        	width:100
        },{
        	name:'relkpiId',
        	id:'relkpiId',
        	xtype:'textfield',
        	anchor:'85%',
        	disabled:true,
        	width:90
        },{
        	width:20,
        	name:'showKpiId',
        	id:'showKpiId',
        	xtype:'button',
        	anchor:'85%',
        	handler:OnShowKpiId
        },{
        	html:'考核指标描述：',
        	width:100
        },{
        	xtype:'textfield',
        	//width:
        	name:'relkpiDesc',
        	id:'relkpiDesc',
        	disabled:true,
        	width:140
        }
        ],
        tbar:new Ext.Toolbar([
        	{
        		text:'增 加',
        		handler:function(){
        			var form=relationForm.getForm();
        			var values=form.getValues(false);
        			var relkpiId=Ext.get('relkpiId').getValue();
        			if(!relkpiId){
        				alert("考核指标ID不允许为空");
        				return;
        			}
        			paraValues='setId='+setId+'&relkpiId='+relkpiId;
        			dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addCheckFunRel&'+paraValues);
        			store.load();
        			//alert(111);
    				relationGrid.show();
    				//window.close();
        		}
        	},'-',
        	{	text:'删 除',
        		handler:function(){
        			var sm=relationGrid.getSelectionModel();
        			var record = sm.getSelected();
        			if(!sm||!record){
               			alert("请选择要删除的行！");
               			return;
               		}
               		Ext.Msg.confirm('信息','确定删除',function(btn){
               			if(btn=='yes'){
               				var ID=record.get("ID");
               				store.remove(record);
               				dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteCheckFunRel&ID='+ID);
               				var form=relationForm.getForm();
               				form.setValues({ID:'',relkpiId:'',relkpiDesc:''});
               			}
               		})
               		
        		}
        	},'-',
        	{
        		text:'清 空',
        		handler:function(){
        			var form=relationForm.getForm();
        			form.setValues({ID:'',relkpiId:'',relkpiDesc:''});
        			
        		}
        	},'-',
        	{
        		text:'查 询',
        		handler:function(){
        			var relkpiId=Ext.get('relkpiId').getValue();
        			paraValues='setId='+setId+'&relkpiId='+relkpiId;
        			store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSerchRel&"+paraValues+"&start=0&limit=21&onePage=1"));
        			store.load();
        			relationGrid.show();
        		}
        	},'-',
        	{
        		text:'退 出',
        		handler:function(){
        			Ext.Msg.confirm('信息','方案和考核指标关系已经维护好？',function(btn){
        				if (btn == 'yes'){
        				var recCnt=relationGrid.getStore().getCount();
        				if(recCnt==0){
        					alert("方案对应的考核指标没维护，请维护");
        					return;
        				}
        				else{
        					var setStore=parentWin.getSetStore();
         					setStore.reload();
        					relationWin.close();
        				}
        				}
        				else{
        					return;
        				}
        			
        			})
        		}
        	}
        ])
		 
	});
	var relationPanel=new Ext.Panel({
		//title:''
		layout:'table',
		layoutConfig: {columns:1},
		items:[{
			region:'north',
			//width:'600',
			items:relationForm
		},{
			region:'center',
			items:relationGrid
		}],
		listeners:{
			"resize":function(win,width,height){
				relationGrid.setHeight(height-150);
    			relationGrid.setWidth(width-15);
			}
		}
        
	});
	 var relationWin = new Ext.Window({
		//title:'标准值界面--'+setName+'方案',
		id:'CheckFunRel',
		layout : 'table',
		//layoutConfig: {columns:1},
		width:630,
		height:500,
		modal:true,
		resizable:true,
		plain : true,
		layoutConfig: {columns:1},
		items:[{
            //autoScroll:true,
            items:relationPanel
            }
		]
	});
	relationWin.on('close',function(thss){
		var setStore=parentWin.getSetStore();
         					setStore.reload();
        					//relationWin.close();
	
	})
	this.setSubWinParam=function(msetId,msetName){
		
		setName=msetName;
		setId=msetId;
	}
	this.showWin=function(parent){
		parentWin=parent;
		var winTitle=setName+"---方案考核指标页面";
		relationWin.setTitle(winTitle);
		relationWin.show();
	}
	this.getRelationForm=function(){
    	return relationForm;
    }
	 function OnShowKpiId(){
    	/*if(KpiId==null){
    		KpiId=new dhcwl.checkfun.CheckFunGetKpi();
     	}*/
     	KpiId=new dhcwl.checkfun.CheckFunGetKpi(setName);
     	KpiId.setParentWin(outThis);
    }
	this.getCheckFunRelPanel=function(){
    	return relationPanel;
    }
}
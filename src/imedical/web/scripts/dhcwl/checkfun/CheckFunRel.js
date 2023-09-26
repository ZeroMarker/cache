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
	{header:'ID',dataIndex:'ID',sortable:true,width:30,sortable:true},
	{header:'指标ID',dataIndex:'relkpiId',sortable:true,width:80,sortable:true},
	{header:'指标描述',dataIndex:'relkpiDesc',sortable:true,width:160,sortable:true},
	{header:'更新日期',dataIndex:'uDate',sortable:true,width:160,sortable:true},
	{header:'更新用户',dataIndex:'uUser',sortable:true,width:160,sortable:true}
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
		height:440,
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
		/*
		frame:true,
		height:100,
		width:590,
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
        	html:'ID: '
        },{
        	xtype:'textfield',
            name: 'ID',
            //id: 'ID',
            disabled:true,
            anchor:'80%'
        },{
        	html: '考核指标ID：',
        	width:70
        },{
        	name:'relkpiId',
        	id:'relkpiId',
        	xtype:'textfield',
        	anchor:'85%',
        	disabled:true,
        	width:110
        },{
        	width:30,
        	name:'showKpiId',
        	id:'showKpiId',
        	xtype:'button',
        	anchor:'85%',
        	handler:OnShowKpiId
        },{
        	html:'考核指标描述',
        	width:70
        },{
        	xtype:'textfield',
        	//width:
        	name:'relkpiDesc',
        	id:'relkpiDesc',
        	disabled:true,
        	width:135
        }
        ],
		*/
		        frame: true,
		labelAlign : 'right',
		//labelWidth : 35,
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
			labelWidth : 35,
			layout : 'form',
			defaultType : 'textfield',
			items : [{

				fieldLabel : 'ID',
            name: 'ID',
            disabled:true,
				anchor:'95%'				
			}]
		},{
			columnWidth : .40,
			labelWidth : 80,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
				fieldLabel : '考核指标',
         	name:'relkpiId',
        	id:'relkpiId',
        	xtype:'textfield',
        	disabled:true,
				anchor:'100%'						
			}]
		},{
			
			//text:'...',
			width:30,
			hideLabel :true,
			layout : 'form',
			items : [{
				icon   : '../images/uiimages/search.png',	
        	name:'showKpiId',
        	id:'showKpiId',
        	xtype:'button',
			anchor : '100%'	,
        	handler:OnShowKpiId
			
			}]
		},{
			columnWidth : .35,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
				fieldLabel : '考核指标描述',
				name:'relkpiDesc',
				id:'relkpiDesc',
				anchor : '95%',
				disabled:true				

			}]
		}],				
		
        tbar:new Ext.Toolbar([
        	{
text: '<span style="line-Height:1">增加</span>',
icon   : '../images/uiimages/edit_add.png',
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
        	{	text: '<span style="line-Height:1">删除</span>',
icon   : '../images/uiimages/edit_remove.png',
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
text: '<span style="line-Height:1">清空</span>',					
icon   : '../images/uiimages/clearscreen.png',
        		handler:function(){
        			var form=relationForm.getForm();
        			form.setValues({ID:'',relkpiId:'',relkpiDesc:''});
        			
        		}
        	},'-',
        	{
text: '<span style="line-Height:1">查询</span>',
icon   : '../images/uiimages/search.png',	
        		handler:function(){
        			var relkpiId=Ext.get('relkpiId').getValue();
        			paraValues='setId='+setId+'&relkpiId='+relkpiId;
        			store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSerchRel&"+paraValues+"&start=0&limit=21&onePage=1"));
        			store.load();
        			relationGrid.show();
        		}
        	},'-',
        	{

text: '<span style="line-Height:1">关闭</span>',
icon   : '../images/uiimages/cancel.png',	
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
		width:620,
		height:590,
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
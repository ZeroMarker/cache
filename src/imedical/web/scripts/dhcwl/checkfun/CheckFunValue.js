(function(){
Ext.ns("dhcwl.checkfun.CheckFunValue");
})();
dhcwl.checkfun.CheckFunValue=function(setId,setName,setObjType){
	//alert(setId);
	//setName=""
	//setId="24";
	var parentWin=null;
	var mkpiWin=null;
	var mEDate=null;
	var mObjWin=null;
	var curStartP=0;curLimitP=0;
	var curStart=0;curLimit=0;
    this.setId=setId;
    this.setName=setName;
    this.setObjType=setObjType;
	var serviceUrl="dhcwl/checkfun/checkfunvalueservice.csp";
	var outThis=this;
	var historyId="";
	var extraId="";
	var valueId="";
	var columnModel=new Ext.grid.ColumnModel([
	{header:'ID',dataIndex:'ID',sortable:true, width: 50, sortable: true},
	{header:'指标ID',dataIndex:'setkpiId',sortable:true, width: 50, sortable: true},
	{header:'指标描述',dataIndex:'setkpiDesc',sortable:true, width: 80, sortable: true},
	{header:'标准值',dataIndex:'nValue',sortable:true, width: 80, sortable: true},
	{header:'生效日期',dataIndex:'eDate',sortable:true, width: 80, sortable: true},
	{header:'更新日期',dataIndex:'uDate',sortable:true, width: 80, sortable: true},
	{header:'更新用户',dataIndex:'uUser',sortable:true, width: 100, sortable: true}
	]);
	var store=new Ext.data.Store({
	//proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSerchEValue&start=0&limit=21&onePage=1&setId='+setId}),
	proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSerchEValue&start=0&limit=2000&onePage=1&setId='+setId}),
	reader:new Ext.data.JsonReader({
			totalProperty: 'totalNum',
            root: 'root',
            fields:[
            {name:'ID'},
            {name:'setkpiId'},
            {name:'setkpiDesc'},
            {name:'nValue'},
            {name:'eDate'},
            {name:'uDate'},
            {name:'uUser'}
            ]
		})
	});

	var presentValueGrid=new Ext.grid.GridPanel({
		stripeRows:true,
		loadMask:true,
		//height:400,
		//width:560,
		store:store,
		resizeAble:true,
		enableColumnResize:true,
		cm:columnModel,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
				rowselect:function(sm,row,rec){
					var id=rec.get("ID");
					var form=presentValueForm.getForm();
					form.loadRecord(rec);
					form.setValues({ID:id});
					if(id!=""){
							form.findField('setkpiId').disable();
							form.findField('setkpiDesc').disable();
						}
					else{
							form.findField("setkpiId").enable();
							form.findField("setkpiDesc").enable();
						}
					}
				}
			}),
			listeners:{
				'contextmenu':function(event){
					event.preventDefault();
					}
				},
			listeners:{
				'click':function(ele,event){
					var sm=presentValueGrid.getSelectionModel();
					if(!sm) {
						alert("请选择一行!");
						return;
						}
					var record = sm.getSelected();
					if(!record){
						return;
						}
						
					var mkpiId=record.get("setkpiId");
					if(!mkpiId){
						mkpiId="",
						historyId=mkpiId;
						return;
						}
						historyId=mkpiId;
						
					var ID=record.get("ID");
					if(!ID){
						ID="",
						valueId=ID;
						return;
						}
						valueId=ID;
					storeExtValue.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSerchExValue&extraId='+valueId+'&setId='+setId));
					storeExtValue.load();
					presentValueGrid.show();
					var form=extraValueForm.getForm();
					form.setValues({objId:'',objDesc:'',value:''});
					}
				}/*,
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
			})*/
			
	});
	//store.load({params:{start:0,limit:21}});
	store.load();
	var presentValueForm= new Ext.FormPanel({
		frame:true,
		//height:150,
		//width:560,
		title: '标准值页面',
		/*
		labelAlign:'left',
		bodyStyle:'padding:5px',
		title: '标准值页面',
		style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:60},
        layoutConfig: {columns:5},
        items:[{html:'考核指标ID'},
        		{
        			//width:100,
        			xtype:'textfield',
        			name:'setkpiId',
        			id:'setkpiId',
        			anchor:'95%'
        		},{
        			width:30,
        			name:'showSetkpiId',
        			id:'showSetkpiId',
        			xtype:'button',
        			anchor:'95%',
        			handler:OnShowSetkpiId
        		},{html:'考核指标描述'
        		
        		},{
        			xtype:'textfield',
        			name:'setkpiDesc',
        			id:'setkpiDesc',
        			anchor:'95%',
        			disabled:true
        		}
        		,{html:'生 效 日 期'}
        		,{
        			xtype:'textfield',
        			name:'eDate',
        			id:'eDate',
        			anchor:'95%'
        		},{
        			width:30,
        			name:'showEDate',
        			id:'showEDate',
        			xtype:'button',
        			anchor:'95%',
        			handler:OnShowEDate
        		},{html:'标 准 值 '}
        		,{
            		xtype:'textfield',
            		name: 'nValue',
            		id: 'nValue',
            		anchor:'95%'
        		}
            ],
			*/
							labelAlign : 'right',
				labelWidth : 80,
				bodyStyle : 'padding:15px 0',
				//bodyStyle : '0',
				style : {
					"margin-right" : Ext.isIE6 ? (Ext.isStrict
							? "-10px"
							: "-13px") : "0"
				},
				
				layout : 'column',
				items:[
				{
					columnWidth : .50,
					layout : 'form',
					defaultType : 'textfield',
					items : [{
						fieldLabel : '考核指标ID',
						xtype:'compositefield',
						items:[{
							xtype:'textfield',
							name:'setkpiId',
							id:'setkpiId',
							flex:4
						},{
							name:'showSetkpiId',
							id:'showSetkpiId',
							xtype:'button',
							handler:OnShowSetkpiId	,
							icon   : '../images/uiimages/search.png',		
							flex:1							
						}]

						//anchor:'90%'				
					},{
						fieldLabel : '生效日期',
						xtype:'compositefield',
						items:[{
							xtype:'textfield',
							name:'eDate',
							id:'eDate',
							flex:4
						},{
							name:'showSetkpiId',
							id:'showEDate',
							xtype:'button',
							handler:OnShowEDate	,
							icon   : '../images/uiimages/search.png',		
							flex:1										
						}]						
						//anchor:'90%'	
					}]
				},{
					labelWidth : 100,
					columnWidth : .50,
					layout : 'form',
					defaultType : 'textfield',
					items : [{
						fieldLabel : '考核指标描述',
        			xtype:'textfield',
        			name:'setkpiDesc',
        			id:'setkpiDesc',
        			anchor:'95%',
        			disabled:true			
					},{
						fieldLabel : '标准值',
            		xtype:'textfield',
            		name: 'nValue',
            		id: 'nValue',
            		anchor:'95%'				
					}]
				}],				
				
            tbar:new Ext.Toolbar([
            	{
text: '<span style="line-Height:1">增加</span>',
icon   : '../images/uiimages/edit_add.png',
            		handler:function(){
            			var form=presentValueForm.getForm();
            			var values=form.getValues(false);
            			var kpiId=Ext.get('setkpiId').getValue();
            			
            			var nvalue=Ext.get('nValue').getValue();
            			var edate=Ext.get('eDate').getValue();
            			if(!kpiId||!nvalue||!edate){
							 alert("考核指标或者标准值或生效日期不能为空!");
							 return;
               			}
               			
               			paraValues='kpiId='+kpiId+'&nvalue='+nvalue+'&edate='+edate+'&setId='+setId;
               			//alert(paraValues);
               			var url=serviceUrl+'?action=addStandardValue&'+paraValues;
               			dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
               				//alert(jsonData.count);
               				if(jsonData.success==true&&jsonData.tip=="ok"&&jsonData.count>1)
               				{
               					
               					   Ext.Msg.confirm('信息','是否复制例外值',function(btn)
               					   {
               					   	if (btn=='no'){
               						store.reload();
               						presentValueGrid.show();
               						}
               						if(btn=='yes'){
               						var stId=jsonData.id;
               						var checkfunExcValueItem=new dhcwl.checkfun.CheckfunExcValueItem(setId,kpiId,stId);
               						checkfunExcValueItem.showExcValueItemWin(outThis);
               						}
               					   	
               					   })
               					
               					
               					
               				}
               				else if(jsonData.success==true&&jsonData.tip=="ok"&&jsonData.count==1)
               				{ 
               				
               				 Ext.Msg.show({
               							title: '处理成功',
										msg:'操作成功',
										buttons: Ext.MessageBox.OK,
										icon: Ext.MessageBox.INFO

               					});
               					store.reload();
               				}
               				else if(jsonData.success==true&&jsonData.tip=="ok"&&jsonData.count==0)
               				{ 
               				
               				 Ext.Msg.show({
               							title: '处理失败',
										msg:'数据已存在',
										buttons: Ext.MessageBox.OK,
										icon: Ext.MessageBox.INFO

               					});
               					store.reload();
               				}
               				
               			},this)
               			
               			
            			
            			//this.refresh();
            			
            			
            			//storeHisValue.load();
            			//historyValueGrid.show();  ///need
            			}
            		},'-',
            		{
text: '<span style="line-Height:1">更新</span>',
icon   : '../images/uiimages/update.png',	
            			handler:function(){
            				var form=presentValueForm.getForm();
            				var values=form.getValues(false);
            				var sm=presentValueGrid.getSelectionModel();
            				var record=sm.getSelected();
            				if((!sm)||(!record)){
            					alert("请选择要更新的行!");
            					return;
            					}
            				Ext.Msg.confirm('信息','只允许更新标准值!',function(btn){
            					if (btn=='yes'){
            						var ID=record.get("ID");
            						var kpiId=Ext.get('setkpiId').getValue();
            						var nvalue=Ext.get('nValue').getValue();
            						var edate=Ext.get('eDate').getValue();
            						if(!kpiId||!nvalue||!edate){
                	     				alert("考核指标或者标准值或生效日期不能为空!");
                	     				return;
               							}
               						paraValues='kpiId='+kpiId+'&nvalue='+nvalue+'&edate='+edate+'&setId='+setId+'&ID='+ID;
               						//alert(paraValues);
               						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=updateStandardValue&'+paraValues);
               						store.load();
            						}
            					}
            				);
            			}
            		},'-',
            		{
text: '<span style="line-Height:1">删除</span>',
icon   : '../images/uiimages/edit_remove.png',
            			handler:function(){
            				var sm=presentValueGrid.getSelectionModel();
            				var record=sm.getSelected();
            				if(!sm||!record){
            					alert("请选择要更新的行!");
            					return;
            				}
            				Ext.Msg.confirm('信息','删除当前生效日期下该考核指标的标准值以及例外值',function(btn){
            					if(btn=='yes'){
            						var ID=record.get("ID");
            						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteStandardValue&ID='+ID);
          							storeExtValue.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSerchExValue&extraId='+ID+'&setId='+setId));
									storeExtValue.reload();
            						store.reload();
									////此处缺例外值界面页面加载
									var form=presentValueForm.getForm();
									form.setValues({setkpiId:'',setkpiDesc:'',nValue:'',eDate:''});
									var form=extraValueForm.getForm();
									form.setValues({objDesc:'',value:''});
            					}
            				});
            			}
            		},'-',
            		{
text: '<span style="line-Height:1">清空</span>',					
icon   : '../images/uiimages/clearscreen.png',
            			handler:function(){
            				var form=presentValueForm.getForm();
							form.setValues({setkpiId:'',setkpiDesc:'',nValue:'',eDate:''});
            			}
            		},'-',
            		{
text: '<span style="line-Height:1">查询</span>',
icon   : '../images/uiimages/search.png',
            			handler:function(){
            				var kpiId=Ext.get('setkpiId').getValue();
            				var nValue=Ext.get('nValue').getValue();
            				var eDate=Ext.get('eDate').getValue();
            				paraValues='kpiId='+kpiId+'&nValue='+nValue+'&eDate='+eDate+'&setId='+setId;
            				//alert(paraValues);
            				store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSerchEValue&"+paraValues+"&start=0&limit=21&onePage=1"));
            				store.load(); 
            				//store.proxy.setUrl(encodeURI(serviceUrl+"?action=mulSerchEValue&"+paraValues+"&start=0&limit=21&onePage=1"));
            			}
            		},'-',
            		{
text: '<span style="line-Height:1">复制</span>',
icon   : '../images/uiimages/copy1.png',
            			handler:function(){
            				var sm=presentValueGrid.getSelectionModel();
            				var record=sm.getSelected();
            				if(!sm||!record){
            					alert("请选择一行");
            					return;
            				}
            				Ext.Msg.confirm('信息','确定复制例外值',function(btn){
            					if (btn=='yes'){
            						var ID=record.get("ID");
            						var kpiId=record.get("setkpiId")
            						var excValueItem=new dhcwl.checkfun.ExcValueItem(setId,kpiId,ID);
            						excValueItem.showExcValueItemWin(outThis);
            					}
            				})
            			}
            		}
            	])
		
	});
	var columnModelExc=new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{header:'ID',dataIndex:'ID',sortable:true, width: 50, sortable: true},
		{header:'考核对象Id',dataIndex:'objId',sortable:true, width: 80, sortable: true},
		{header:'考核对象描述',dataIndex:'objDesc',sortable:true, width: 80, sortable: true},
		{header:'例外值',dataIndex:'value',sortable:true, width: 80, sortable: true},
		{header:'更新用户',dataIndex:'uUser',sortable:true, width: 100, sortable: true},
		{header:'更新日期',dataIndex:'uDate',sortable:true, width: 80, sortable: true}
	]);
	var storeExtValue=new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSerchExValue'}),
		reader: new Ext.data.JsonReader({
            totalProperty: 'totalNumss',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'objId'},
            	{name: 'objDesc'},
            	{name: 'value'},
            	{name: 'uUser'},
            	{name: 'uDate'}
       		]
    	})
	});
	storeExtValue.load();
	var exceptionalGrid=new Ext.grid.GridPanel({
		stripeRows:true,
		loadMask:true,
		//height:400,
		store:storeExtValue,
		resizeAble:true,
		enableColumnResize:true,
		cm:columnModelExc,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
				rowselect:function(sm,row,rec){
					var id=rec.get("ID");
					var form=extraValueForm.getForm();
					form.loadRecord(rec);
					form.setValues({ID:id});
					if(id!=""){
							form.findField('objId').disable();
							form.findField('objDesc').disable();
							
					
						}
					else{
							form.findField('objId').enable();
							form.findField('objDesc').enable();
						}	
					}
				}
			}),
			listeners:{
				'contextmenu':function(event){
					event.preventDefalut();
					}
				}
			});
	
	var extraValueForm = new Ext.FormPanel({
		frame: true,
        //height: 150,
        //width:600,
		title: '例外值页面',
        /*
		labelAlign: 'left',
        bodyStyle:'padding:5px',
        title: '例外值页面',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        layoutConfig: {columns:8},
         items:[{
        	html: '考核对象Id'
        },{
				xtype:'textfield',
				name:'objId',
				id:'objId',
				anchor:'95%'
			},{
				width:30,
				name:'showObjId',
				id:'showObjId',
				xtype:'button',
				anchor:'85%',
				handler:OnShowObjId
			},{
				html:'考核对象描述'
			
			},{
				xtype:'textfield',
				name:'objDesc',
				id:'objDesc',
				anchor:'95%',
				disabled:true
			},{html:'例外值'}
        		,{
            		xtype:'textfield',
            		name: 'value',
            		id: 'value',
            		anchor:'95%'
        		}
            ], 
			*/
				labelAlign : 'right',
				labelWidth : 80,
				bodyStyle : 'padding:15px 0',
				//bodyStyle : '0',
				style : {
					"margin-right" : Ext.isIE6 ? (Ext.isStrict
							? "-10px"
							: "-13px") : "0"
				},
				
				layout : 'column',
				items:[
				{
					columnWidth : .50,
					layout : 'form',
					defaultType : 'textfield',
					items : [{
						fieldLabel : '考核对象ID',
						xtype:'compositefield',
						anchor:'90%'	,
						items:[{
							xtype:'textfield',
							name:'objId',
							id:'objId',
							flex:4
									},{
										icon   : '../images/uiimages/search.png',	
							name:'showObjId',
							id:'showObjId',
							xtype:'button',
							handler:OnShowObjId,
							flex:1
							//width:20							
						}]

						//anchor:'90%'				
					},{
						fieldLabel : '例外值',
						xtype:'textfield',
						name: 'value',
						id: 'value',
						anchor:'90%'	
					}]
				},{
					labelWidth : 100,
					columnWidth : .50,
					layout : 'form',
					defaultType : 'textfield',
					items : [{
						fieldLabel : '考核对象描述',
						xtype:'textfield',
						name:'objDesc',
						id:'objDesc',
						anchor:'90%',
						disabled:true			
					}]
				}],				
			
			
			tbar:new Ext.Toolbar([
            	{
text: '<span style="line-Height:1">增加</span>',
icon   : '../images/uiimages/edit_add.png',
            		handler:function(){
            			var form=extraValueForm.getForm();
            			var values=form.getValues(false);
            			//var objId=objCombo.getValue();
            			var objId=Ext.get('objId').getValue();
            			var value=Ext.get('value').getValue();
            			if(!objId||!value){
                	     alert("考核对象或例外值不能为空!");
                	     return;
               				}
               			if(!valueId) {
							Ext.Msg.alert("提示","请先选择标准值!");
							return;
						}
               			paraValues='objId='+objId+'&value='+value+'&extraId='+valueId;
               			//alert(valueId);
               			dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addexceptValue&'+paraValues);
            			storeExtValue.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSerchExValue&extraId='+valueId+'&setId='+setId));
            			storeExtValue.reload();
            			
            			extraValueForm.show();
            			
            			}
            		},'-',
            		{
text: '<span style="line-Height:1">更新</span>',
icon   : '../images/uiimages/update.png',
            			handler:function(){
            				var form=extraValueForm.getForm();
            				var values=form.getValues(false);
            				var sm=exceptionalGrid.getSelectionModel();
            				var record=sm.getSelected();
            				if((!sm)||(!record)){
            					alert("请选择要更新的行!");
            					return;
            					}
            				Ext.Msg.confirm('信息','确定更新?',function(btn){
            					if (btn=='yes'){
            						var ID=record.get("ID");
            						//var kpiId=kpiCombo.getValue();
            						var objId=Ext.get('objId').getValue();
            						var value=Ext.get('value').getValue();
            						if(!objId||!value){
                	     				alert("考核对象或例外值不能为空!");
                	     				return;
               							}
               						paraValues='ID='+ID+'&objId='+objId+'&value='+value+'&extraId='+valueId;
               						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=updateexceptValue&'+paraValues,"",function(jsonData){
										if(jsonData.success==true && jsonData.tip=="ok"){
											var objId="";
											var value="";
											paraValues='objId='+objId+'&value='+value+'&extraId='+valueId+'&setId='+setId;
											storeExtValue.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSerchExValue&'+paraValues));
											storeExtValue.load();
										}
									},this)
									
									
               						
            						}
            					}
            				);
            			}
            		},'-',
            		{
text: '<span style="line-Height:1">删除</span>',
icon   : '../images/uiimages/edit_remove.png',
            			handler:function(){
            				var sm=exceptionalGrid.getSelectionModel();
            				var record=sm.getSelected();
            				if(!sm||!record){
            					alert("请选择要删除的行!");
            					return;
            				}
            				Ext.Msg.confirm('信息','确定删除',function(btn){
            					if(btn=='yes'){
            						var ID=record.get("ID");
            						storeExtValue.remove(record);
            						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteexceptValue&ID='+ID);
            						var form=extraValueForm.getForm();
									form.setValues({objId:'',objDesc:'',value:''});
            					}
            				});
            			}
            		},'-',
            		{
text: '<span style="line-Height:1">清空</span>',					
icon   : '../images/uiimages/clearscreen.png',
            			handler:function(){
            				var form=extraValueForm.getForm();
							form.setValues({objId:'',objDesc:'',value:''});
            			}
            		},'-',
            		{
text: '<span style="line-Height:1">查询</span>',
icon   : '../images/uiimages/search.png',	
            			handler:function(){
            						//var objId=objCombo.getValue();
            						var objId=Ext.get('objId').getValue();
            						var value=Ext.get('value').getValue();
            						paraValues='objId='+objId+'&value='+value+'&extraId='+valueId+'&setId='+setId;
            						storeExtValue.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSerchExValue&'+paraValues));
            						storeExtValue.load();
            			}
            		}
            	])
		
	});
	
	var checkfunValuePanel=new Ext.Panel({
		//title:'标准值界面',
		/*
		layout:'table',
		id:'dhcwl.checkfun.CheckFunValue.checkfunValue',
		layoutConfig:{columns:2},
		items: [{ 
			width: 560,
			height:150,
        	//autoScroll:true,
            items:presentValueForm
    	},{
    		width:600,
    		height:150,
    		//autoScroll:true,
    		items:extraValueForm
            
    	},{ width: 560,
			height:430,
    		//autoScroll:true,
            items:presentValueGrid
    	},{ 
    		width: 600,
    		height:430,
        	//autoScroll:true,
        	items:exceptionalGrid
            
    	}]
		*/
		id:'dhcwl.checkfun.CheckFunValue.checkfunValue',
		
		layout: {
			type:'hbox',
			padding:'0',
			align:'stretch',
			border:false
		},
		items: [{
						flex:10,
						layout:'fit',
						layout: {
							type:'vbox',
							padding:'0',
							align:'stretch',
							border:false
						},	
						defaults: {
							flex: 1
						},			
						items:[{
							layout:'fit',
							items:presentValueForm
						},{
							flex: 2,
							layout:'fit',
							items:presentValueGrid
						}]			
					},{
						flex:10,
						layout:'fit',
						layout: {
							type:'vbox',
							padding:'0',
							align:'stretch',
							border:false
						},	
						defaults: {
							flex: 1
						},	
						items:[{
							layout:'fit',
							items:extraValueForm
						},{
							flex: 2,
							layout:'fit',
							items:exceptionalGrid
						}]						
											}]
			
		
		
		
	});
	 this.mainWin=new Ext.Viewport({
    	id:'maintainStandValue',
        //renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'table',
        //width:1000,
        //heitht:800,
        items: [checkfunValuePanel]
    });
    var checkfunValueWin = new Ext.Window({
		//title:'标准值界面--'+setName+'方案',
		id:'checkfunValue',
		//layout : 'table',
		//layoutConfig: {columns:1},
		width:1000,
		height:500,
		modal:true,
		layout:'fit',
		items:checkfunValuePanel
		//resizable:true,
		//plain : true,
		/*,
		listeners:{
    		"resize":function(win,width,height){
    			if(height!=540){
    				checkfunValuePanel.setHeight(height-165);
    				checkfunValuePanel.setWidth(width-20);
    			}
    		}
    	}*/
	});
	
    this.getCheckFunValuePanel=function(){
    	return checkfunValuePanel;
    }
    this.showCheckFunValueWin=function(){
    	this.showData();
    	checkfunValueWin.show();
    	
    }
    this.showData=function(){
    	presentValueForm.show();
    	historyValueForm.show();
    	extraValueForm.show();
    	store.proxy.setUrl(encodeURI('dhcwl/checkfun/checkfunvalueservice.csp?action=mulSerchEValue&className=DHCWL.CheckFun.StandardValSet&setId='+setId));
    	store.load();
    	storeExtValue.proxy.setUrl(encodeURI('dhcwl/checkfun/checkfunvalueservice.csp?action=mulSerchExValue&extraId='+extraId));
    	storeExtValue.load();
		presentValueGrid.show();
    	exceptionalGrid.show();
    	
    }
    
    this.showKpi=function(){
    	dhcwl_checkfun_checkfungetkpi=new dhcwl.checkfun.CheckFunGetKpi();
    	dhcwl_checkfun_checkfungetkpi.show();
    	dhcwl_checkfun_checkfungetkpi.setParentWin(outThis);
    	
    	
    	
    	
    }
    this.showObj=function(setId){
    	var dhcwl_checkfun_checkfungetobj=new dhcwl.checkfun.CheckFunGetObj(setId);
    	dhcwl_checkfun_checkfungetobj.showobjItemWin();
    	dhcwl_checkfun_checkfungetobj.setParentWin(outThis);	
    	
    }
	
	this.showWin=function(parent){
		parentWin=parent;
		var winTitle=setName+"---方案标准值界面";
		checkfunValueWin.setTitle(winTitle);
		checkfunValueWin.show();
		checkfunValueWin.doLayout();
	}
	this.setSubWinParam=function(msetId,msetName){
		
		setName=msetName;
		setId=msetId;
	}
	function OnShowSetkpiId(){
    	/*if(mkpiWin==null){
    		mkpiWin=new dhcwl.checkfun.CheckFunGetRelKpi(setId);
     	}*/
     	mkpiWin=new dhcwl.checkfun.CheckFunGetRelKpi(setId);
     	mkpiWin.setParentWin(outThis);
    }
    function OnShowEDate(){
    	/*if(mkpiWin==null){
    		mkpiWin=new dhcwl.checkfun.CheckFunGetRelKpi(setId);
     	}*/
     	mEDate=new dhcwl.checkfun.CheckFunGetEDate(setId);
     	mEDate.setParentWin(outThis);
    }
    function OnShowObjId(){
    	/*if(mObjWin==null){
    			mObjWin=new dhcwl.checkfun.CheckFunGetObj(setId);
    		
    	}*/
    	if (setObjType=="全院"){
            				alert("全院没有例外值!");
            				return;
            			}
    	mObjWin=new dhcwl.checkfun.CheckFunGetObj(setId);
    	mObjWin.setParentWin(outThis);
    }
    this.getPresentValueForm=function(){
    	return presentValueForm;
    }
    this.getExtraValueForm=function(){
    	return extraValueForm;
    }
     this.getPresentStore=function(){
    	return store;
    }
    this.getStoreExtValue=function(){
    	return storeExtValue;
    }
    this.getPresentValueGrid=function(){
    	return presentValueGrid;
    }
    
}
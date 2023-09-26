dhcwl.codecfg.CodeCfgSubGroupItem= function(grpId,subgrpId){
	this.grpId=grpId,this.subgrpId=subgrpId;
	var serviceUrl="dhcwl/codecfg/codecfgservice.csp";
	var outThis=this
	
	var quickMenu=new Ext.menu.Menu({
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    	    {
    			text:'上移一',
    			handler:function(cmp,event){
					var sm = detailGrid.getSelectionModel();
					var record = sm.getSelected();
					if(!sm||!record){
						alert("请选择要移动的行！");
						return;
					}
					var ID=record.get("ID");
    				Ext.Ajax.request({
						url: serviceUrl,
						type : "POST",
						dataType : "json",
						success: function(response) {
							var retInfor=Ext.util.JSON.decode(response.responseText)
							if (retInfor.tip=="ok"){
								//refreshStore();   //---刷新两个store
								var pageValue=detailGrid.getBottomToolbar().cursor;
								detailStore.load({
									params : {
										start : pageValue,
										limit : 20
									},
									callback: function(records, options, success){  //--选中跳转后的明细项
										var recCnt=detailGrid.getStore().getCount();
										var aryProParaValue=[];
										for (i=0;i<recCnt;i++) {
											paraObj=detailGrid.getStore().getAt(i);
											if(ID==paraObj.get("ID")){
												 detailGrid.getSelectionModel().selectRow(i,true);  
											}
										}

									}
								});
							}else{
								Ext.Msg.alert('失败',retInfor.tip );
							}
						},
						failure: function(response) {
							Ext.Msg.alert('失败', "操作失败");
						},
						params: 
						{
							action:'moveup',
							subGrpID:subgrpId,
							itemID:ID
						}

					});
    			}
    		},'-',{
    			text:'下移一',
    			handler:function(cmp,event){
    				var sm = detailGrid.getSelectionModel();
					var record = sm.getSelected();
					if(!sm||!record){
						alert("请选择要删除的行！");
						return;
					}
					var ID=record.get("ID");
    				Ext.Ajax.request({
						url: serviceUrl,
						type : "POST",
						dataType : "json",
						success: function(response) {
							var retInfor=Ext.util.JSON.decode(response.responseText)
							if (retInfor.tip=="ok"){
								//refreshStore();   //---刷新两个store
								var pageValue=detailGrid.getBottomToolbar().cursor;
								detailStore.load({
									params : {
										start : pageValue,
										limit : 20
									},
									callback: function(records, options, success){  //--选中跳转后的明细项
										var recCnt=detailGrid.getStore().getCount();
										var aryProParaValue=[];
										for (i=0;i<recCnt;i++) {
											paraObj=detailGrid.getStore().getAt(i);
											if(ID==paraObj.get("ID")){
												 detailGrid.getSelectionModel().selectRow(i,true);  
											}
										}

									}
								});
							}else{
								Ext.Msg.alert('失败', retInfor.tip);
							}
						},
						failure: function(response) {
							Ext.Msg.alert('失败', "操作失败");
						},
						params: 
						{
							action:'itemNext',
							subGrpID:subgrpId,
							itemID:ID
						}

					});
    			}
    		},'-',{
    			text:'排序值设置',
    			handler:function(cmp,e){
					moveItermGroupForm.form.reset();
    				moveWin.show();
    			}
    		}
    	]
	})
	
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',width: 80, sortable: true,menuDisabled : true,hidden:true},
        {header:'ID',dataIndex:'dimID',width: 80, sortable: true,menuDisabled : true},
		{header:'描述',dataIndex:'ItemDesc', width: 180, sortable: true,menuDisabled : true},
		{header:'编码',dataIndex:'ItemCode', width: 180, sortable: true,menuDisabled : true},
		{header:'排序值',dataIndex:'sortValue', width: 80, sortable: true,menuDisabled : true}
    ]);    
    
    var detailStore = new Ext.data.Store({
    	//modify by wk~2017-11-10 将前台分页改为后台分页
		proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=list-subGrpItem'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
        		{name: 'dimID'},
            	{name: 'ItemDesc'},
				{name: 'sortValue'},
				{name: 'ItemCode'}
       		]
    	})
    	
    });
    
    var PagingToolbar=new Ext.PagingToolbar({
        pageSize: 20,
        store: detailStore,
        displayInfo: true,
        displayMsg: '显示{0}-{1} 条',
        emptyMsg: "没有记录"
    })
	
	var detailGrid = new Ext.grid.EditorGridPanel({
		id:detailGrid,
		stripeRows:true,
        loadMask:true,
		height:520,
		frame:true,
		store:detailStore,
		cm:columnModel,
		sm:new Ext.grid.RowSelectionModel(),
		viewConfig: {forceFit: true},
		clicksToEdit:1,
		columnLines: true,
		tbar:new Ext.Toolbar([
         {
        	 text: '<span style="line-Height:1">删除</span>',
        	 id:'del_btn',
		     icon: '../images/uiimages/edit_remove.png',
             handler: function(){
            	var sm = detailGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		alert("请选择要删除的行！");
               		return;
				}
                Ext.Msg.confirm('信息', '确定要删除吗？', function(btn){
                    if (btn == 'yes') {
                    	var ID=record.get("ID");
                    	dhcwl.mkpi.Util.ajaxExc('dhcwl/codecfg/codecfgservice.csp'+'?action=deleteSubGrpDetail&ID='+ID
            	                ,null,function(jsonData){
            	                	if(!jsonData){
            	                		Ext.Msg.show({title:'错误',msg:"删除失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            	                		return;
            	                	}
            	                	if(jsonData.success){
            	                		if (jsonData.tip=="ok") {
            	                			Ext.Msg.show({title:'提示',msg:"删除成功！",buttons: Ext.Msg.OK});
            	                			refreshStore();   //---刷新两个store
            	                          
            	                		}else{
            								Ext.Msg.alert("提示","删除失败了！");
            	                		}
            	                	}else{
            	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            	                		return;
            	                	}
            	                },outThis);
                		}
                	});
                }
         },'-',
         {
        	 text: '<span style="line-Height:1">全部删除</span>',
        	 icon: '../images/uiimages/edit_remove.png',
        	 id:'delall_btn',
             handler: function(){
                if(!subgrpId||subgrpId==""){
            		Ext.Msg.show({title:'错误',msg:"请先选择要维护的子组！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
                Ext.Msg.confirm('信息', '确定要全部删除吗？', function(btn){
                    if (btn == 'yes') {
                    	dhcwl.mkpi.Util.ajaxExc('dhcwl/codecfg/codecfgservice.csp'+'?action=deleteAllSubGrpDetail&subgrpId='+subgrpId
            	                ,null,function(jsonData){
            	                	if(!jsonData){
            	                		Ext.Msg.show({title:'错误',msg:"删除失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            	                		return;
            	                	}
            	                	if(jsonData.success){
            	                		if (jsonData.tip=="ok") {
            	                			Ext.Msg.show({title:'提示',msg:"删除成功！",buttons: Ext.Msg.OK});
            	                			refreshStore();//刷新两个store
            	                		}else{
            								Ext.Msg.alert("提示","删除失败了！");
            	                		}
            	                	}else{
            	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            	                		return;
            	                	}
            	                },outThis);
                		}
                	});
                }
         },'-',{
			 text: '<span style="line-Height:1">排序重置</span>',
        	 icon: '../images/uiimages/update.png',
             handler: function(){
				 Ext.Ajax.request({
					url: serviceUrl,
					type : "POST",
					dataType : "json",
					success: function(response) {
						var retInfor=Ext.util.JSON.decode(response.responseText)
						if (retInfor.tip=="ok"){
							Ext.Msg.alert('提示', "操作成功");
							refreshStore();//刷新两个store
						}else{
							Ext.Msg.alert('失败', "操作失败了");
						}
					},
					failure: function(response) {
						Ext.Msg.alert('失败', "操作失败");
					},
					params: 
					{
						action:'updateGrpItemSort',
						subGrpID:subgrpId														
					}

				 });
			 }
		 },'-','按条件搜索',
         {
			id:'searchCondItem',
			width: 70,
			xtype:'combo',
			mode:'local',
			emptyText:'请选择搜索类型',
			triggerAction:  'all',
			forceSelection: true,
			editable: false,
			displayField:'value',
			valueField:'name',
			store:new Ext.data.JsonStore({
				fields:['name', 'value'],
				data:[
					{name : 'Code',   value: '代码'},
					{name : 'Name',  value: '描述'}
				]}),
				listeners:{
					'select':function(combo){
						choicedSearcheCond=combo.getValue();//ele.getValue();
					}
				}
       	 	},{
        	xtype: 'textfield',
         	width:200,
         	flex : 1,
         	id:'searcheValueByCont',
         	enableKeyEvents: true,
         	allowBlank: true,
         	listeners :{
         		'keypress':function(ele,event){
         			searcheValue=Ext.get("searcheValueByCont").getValue();//ele.getValue();
         			if ((event.getKey() == event.ENTER)){
         				detailStore.baseParams={
							subgrpId:subgrpId,
							searcheValue:searcheValue,
							searcheCond:choicedSearcheCond
						};
						detailStore.load({
							params : {
								start : 0,
								limit : 20
							}
						});
         			}
         		}
         	}
         }
         ]),
     	bbar:PagingToolbar
	
	})
	
	detailGrid.on("contextmenu",function(event){
		event.preventDefault();
        quickMenu.showAt(event.getXY());

	});
	
	//显示所有要添加的项目明细
	
	var selectedKpiIds=[];
	var csm = new Ext.grid.CheckboxSelectionModel()     //新建复选框的对象，使用的时候直接写  'csm'

	var alldetailsCM = new Ext.grid.ColumnModel([
	    csm,
        {header:'ID',dataIndex:'ID',sortable:true, width: 60, sortable: true,menuDisabled : true},
        {header:'代码',dataIndex:'ItemCode',sortable:true, width: 130, sortable: true,menuDisabled : true},
        {header:'描述',dataIndex:'ItemDesc',sortable:true, width: 160, sortable: true,menuDisabled : true}
    ]);
	var allDetailStore=new Ext.data.Store({
		 proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=CheckGrpItem'}),  //modify by wk~2017-11-10~前台分页改为后台分页		
		 reader: new Ext.data.JsonReader({
	            totalProperty: 'totalNum',
	            root: 'root',
	        	fields:[
	        		{name: 'ID'},    
	            	{name: 'ItemCode'},
	            	{name: 'ItemDesc'}
	       		]
	    	})
		}); 
		
	var allDetailGrid = new Ext.grid.EditorGridPanel({
		id:allDetailGrid,
		height:520,
		frame:true,
		store:allDetailStore,
		cm:alldetailsCM,
		sm:csm,   //new Ext.grid.RowSelectionModel(),
		clicksToEdit:1,
		columnLines: true,
		viewConfig: {forceFit: true},
		tbar:new Ext.Toolbar(
		{
		    layout: 'hbox',
        	items : [
         	{
				text: '<span style="line-Height:1">新增</span>',
				icon: '../images/uiimages/edit_add.png',id:'add_btn',
				handler:function(){
					if(!grpId||grpId==""){
						Ext.Msg.show({title:'错误',msg:"请先选择要维护的大组！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(!subgrpId||subgrpId==""){
						Ext.Msg.show({title:'错误',msg:"请先选择要维护的子组！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}

					var selectItemPara="";
					var rowObj=allDetailGrid.getSelectionModel().getSelections();
					var len = rowObj.length;
					if(len < 1){
						Ext.Msg.show({title:'注意',msg:'请选择要添加的项目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}else{
						var idStr="",codeStr="";
						for(var i=0;i<len;i++){
							ItemId=rowObj[i].get("ID");
							ItemCode=rowObj[i].get("ItemCode");
							if(idStr==""){
								idStr=ItemId;
							}else{
								idStr=idStr+"-"+ItemId
							}
							if (codeStr==""){
								codeStr=ItemCode;
							}else{
								codeStr=codeStr+"@"+ItemCode;
							}
							
						}
						selectItemPara=idStr;
					}
			  
					paraValues='GrpId='+grpId+'&SubGrpId='+subgrpId+'&selectItemPara='+selectItemPara+'&selectItemCode='+codeStr;
					dhcwl.mkpi.Util.ajaxExc('dhcwl/codecfg/codecfgservice.csp'+'?action=addsubgrpitem&'+paraValues
						,null,function(jsonData){
							if(!jsonData){
								Ext.Msg.show({title:'错误',msg:"增加失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}
							if(jsonData.success){
								if (jsonData.tip=="ok") {
									Ext.Msg.show({title:'提示',msg:"增加成功！",buttons: Ext.Msg.OK});
									refreshStore();
								}else{
									Ext.Msg.alert("提示","增加失败了！");
								}
							}else{
								Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}
						},outThis); 
			  }
			 },'-',
			 {text:'    '},'按条件搜索',{
       	 		id:'searchCond',
	        	width: 70,
				xtype:'combo',
	        	mode:'local',
	        	emptyText:'请选择搜索类型',
	        	triggerAction:  'all',
	        	forceSelection: true,
	        	editable: false,
	        	displayField:'value',
	        	valueField:'name',
	        	store:new Ext.data.JsonStore({
	        		fields:['name', 'value'],
	            	data:[
	            		{name : 'Code',   value: '代码'},
	                	{name : 'Name',  value: '描述'}
	             	]}),
	             	listeners:{
	        			'select':function(combo){
	        				choicedSearcheCond=combo.getValue();//ele.getValue();
	        			}
	        		}
       	 	},{
       	 		xtype: 'textfield',
				width:200,
				flex : 1,
				id:'searcheContValue',
				enableKeyEvents: true,
				allowBlank: true,
				listeners :{
					'keypress':function(ele,event){
						searcheValue=Ext.get("searcheContValue").getValue();//ele.getValue();
						if ((event.getKey() == event.ENTER)){
							allDetailStore.baseParams={			//*----回车时将检索条件添加进去
								grpId:grpId,
								searcheCond:choicedSearcheCond,
								searcheValue:searcheValue,
								className:"DHCWL.CodeCfg.Group"
							};
							allDetailStore.load({
								params : {
									start : 0,
									limit : 20
								}
							});
						}
					}
				}
       	 	}
       	 	]}      
         ),
     	bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: allDetailStore,
            displayInfo: true,
			displayMsg: '显示{0}-{1} 条',
            emptyMsg: "没有记录"
        })
	})
	
	
	var codeCfgSubGrpItemWin = new Ext.Window({
		title:'项目归集明细维护',
		id:'codeCfgSubGrpItem',
		layout : 'table',
		layoutConfig: {columns:2},
		width:1000,
		height:560,
		modal:true,
		resizable:true,
		//items:detailGrid
		items:[{
            autoScroll:true,
            width:565,
            //region: 'north',
            items:detailGrid
            },{
			layout:'fit',
            autoScroll:true,
            width:445,
            //region: 'center',
            items:allDetailGrid
            }
		],listeners:{
			'close':function(){
				handleGrpLog();
		},'show':function(){  
            Ext.EventManager.on(window,'beforeunload',function(){  
                //浏览器刷新或关闭执行
				handleGrpLog();
			})  
        }
		}
	});
	
	//-----排序值跳转填写页面
	 var moveItermGroupForm=new Ext.FormPanel({
		height:110,
        width : 120,
		buttonAlign : 'center',
        bodyStyle: 'padding: 5px',
        defaults: {
            anchor: '0'
        },
        items:[{
        	id        : 'moveSortValue',
        	xtype     : 'textfield',
            name      : 'moveSortValue',
            fieldLabel: '排序值',
            anchor    : '-20'
        }],
        buttons:[{
			text:'确定',
			handler:function(){
				var value=Ext.get('moveSortValue').getValue();
				var sm = detailGrid.getSelectionModel();
				var record = sm.getSelected();
				if(!sm||!record){
					alert("请选择要操作的行！");
					return;
				}
				cleanForm();
				var ID=record.get("ID");
				Ext.Ajax.request({
					url: serviceUrl,
					type : "POST",
					dataType : "json",
					success: function(response) {
						var retInfor=Ext.util.JSON.decode(response.responseText)
						if (retInfor.tip=="ok"){
							//--更新成功后，加载时直接打开目标页
							var pageValue=(Math.floor((value-1)/20))*20;      
							detailStore.load({
								params : {
									start : pageValue,
									limit : 20
								},
								callback: function(records, options, success){  //--选中跳转后的明细项
									var recCnt=detailGrid.getStore().getCount();
									var aryProParaValue=[];
									for (i=0;i<recCnt;i++) {
										paraObj=detailGrid.getStore().getAt(i);
										if(ID==paraObj.get("ID")){
											 detailGrid.getSelectionModel().selectRow(i,true);  
										}
									}

								}								
							});
						}else{
							Ext.Msg.alert('失败',retInfor.tip );
						}
					},
					failure: function(response) {
						Ext.Msg.alert('失败', "操作失败");
					},
					params: 
					{
						action:'MoveToLocal',
						subGrpID:subgrpId,
						itemID:ID,
						aimsValue:value
					}

				});
				moveWin.hide();
			}
		},{
			text:'取消',
			handler:function(){
				moveWin.hide();
			}
		}]
	 })
	var moveWin=new Ext.Window({
		title  :'明细跳转选择',
    	layout :'fit',
	    modal:true,
    	width  :400,
    	height :200,
    	items  :[moveItermGroupForm]
    });
	
	function handleGrpLog(){
		dhcwl.mkpi.Util.ajaxExc('dhcwl/codecfg/codecfgservice.csp'+'?action=endGrpLogGlobal'
			,null,function(jsonData){
				if(!jsonData){
					Ext.Msg.show({title:'错误',msg:"保存日志数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				if(jsonData.success){
					if (jsonData.tip=="ok") {
						//Ext.Msg.show({title:'提示',msg:"增加成功！",buttons: Ext.Msg.OK});
				}
				}else{
					Ext.Msg.show({title:'错误',msg:"保存日志数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
			},outThis);
	}
	
	function refreshStore(){
		detailStore.load({
			params : {
				start : 0,
				limit : 20
			}
		});
		allDetailStore.load({
			params : {
				start : 0,
				limit : 20
			}
		});
	}
	function cleanForm(){
		detailStore.baseParams={			
			subgrpId:subgrpId		
		};
		Ext.getCmp("searchCondItem").setValue("");
		Ext.getCmp("searcheValueByCont").setValue("");
		
	}
	this.showCodeCfgSubGroupItemWin = function(){
		this.showData();
		codeCfgSubGrpItemWin.show();
	}
	this.showData = function(){
		allDetailStore.baseParams={			
			grpId:grpId,
			className:"DHCWL.CodeCfg.Group"				
		};
		allDetailStore.load({
			params : {
				start : 0,
				limit : 20
			}
		});
		
		detailStore.baseParams={			
			subgrpId:subgrpId,
			className:"DHCWL.CodeCfg.Group"				
		};
		detailStore.load({
			params : {
				start : 0,
				limit : 20
			}
		});
		detailGrid.show();
		allDetailGrid.show();
	}
	this.getDetailStore=function(){
    	return detailStore;
    	return allDetailStore;
    }

}
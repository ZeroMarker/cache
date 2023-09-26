dhcwl.codecfg.CodeCfgItmGroupDetails= function(grpId,storeGrpDetails){
	this.grpId=grpId;this.storeGrpDetails=storeGrpDetails;
	var serviceUrl="dhcwl/codecfg/codecfgservice.csp";
	var outThis=this
	
	
	
	
	//显示所有要添加的项目明细
	
	var selectedKpiIds=[];
	var csm = new Ext.grid.CheckboxSelectionModel()     //新建复选框的对象，使用的时候直接写  'csm' 

 
  
	
	var alldetailsCM = new Ext.grid.ColumnModel([
	    csm,
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true},
        {header:'代码',dataIndex:'ItemCode',sortable:true, width: 160, sortable: true,menuDisabled : true},
        {header:'描述',dataIndex:'ItemDesc',sortable:true, width: 160, sortable: true,menuDisabled : true}
    ]);
    //alert(grpId);
    var allDetailStore = new Ext.data.Store({ 
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
    	
    //
	var allDetailGrid = new Ext.grid.EditorGridPanel({
		id:allDetailGrid,
		height:510,
		frame:true,
		store:allDetailStore,
		cm:alldetailsCM,
		sm:csm,   //new Ext.grid.RowSelectionModel(),
		clicksToEdit:1,
		columnLines: true,
		tbar:new Ext.Toolbar(      
		{
			layout: 'hbox',
			items:[
					{//text:'新增',
					  text: '<span style="line-Height:1">新增</span>',
			          icon: '../images/uiimages/edit_add.png',id:'add_btn',
			          handler:function(){
			          if(!grpId||grpId==""){
			            		Ext.Msg.show({title:'错误',msg:"请先选择要维护的大组！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			            		return;
			            	}
			          
			          var selectItemPara="";
					  var rowObj=allDetailGrid.getSelectionModel().getSelections();
					  var len = rowObj.length;
					  if(len < 1){
						Ext.Msg.show({title:'注意',msg:'请选择要添加的项目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					  }else{
						var idStr="";
							for(var i=0;i<len;i++){
								ItemId=rowObj[i].get("ID");
								if(idStr==""){
									idStr=ItemId;
								}else{
									idStr=idStr+"-"+ItemId
								}
									
							}
						selectItemPara=idStr;	
						//window.close();
						}		
			           paraValues='GrpId='+grpId+'&selectItemPara='+selectItemPara;
			           //alert(paraValues); 
			           searcheValue=Ext.get("searcheContValue").getValue();
			           choicedSearcheCond=Ext.get("searchCond").getValue();
			           if (choicedSearcheCond=="描述"){
			 			  choicedSearcheCond="Name";
			 		  }else if(choicedSearcheCond=="代码"){
			 			  choicedSearcheCond="Code";
			 		  }
			           dhcwl.mkpi.Util.ajaxExc('dhcwl/codecfg/codecfgservice.csp'+'?action=addgrpitem&'+paraValues
				                ,null,function(jsonData){
				                	if(!jsonData){
				                		Ext.Msg.show({title:'错误',msg:"增加失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				                		return;
				                	}
				                	if(jsonData.success){
				                		if (jsonData.tip=="ok") {
				                			Ext.Msg.show({title:'提示',msg:"增加成功！",buttons: Ext.Msg.OK});
				                			Ext.Ajax.request({ //读取后台传递于前台数据 
				                				url: encodeURI('dhcwl/codecfg/codecfgservice.csp?action=CheckGroupItem&grpId='+grpId+'&searcheCond='+choicedSearcheCond+'&searcheValue='+searcheValue),
				                				method:'get', 
				                				success:function(response, opts){ 
				                				var obj= Ext.decode(response.responseText);//obj储存响应的数据 
				                				allDetailStore.proxy = new Ext.data.PagingMemoryProxy(obj),//PagingMemoryProxy() 一次性读取数据 
				                				allDetailStore.load({params:{start:0,limit:20}});//按20条记录分布 
				                				}, 
				                				failure: function(){Ext.Msg.alert("failure");} 
				                			});
				                			storeGrpDetails.proxy.setUrl(encodeURI(serviceUrl+'?action=list-GrpItem&grpId='+grpId));
				     			            storeGrpDetails.reload();
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
			         	//xtype : 'compositefield',
			        	//anchor: '-20',
			       	 	//msgTarget: 'side',
			       	 	//items :[{
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
				            	//name : 'searcheContValue',
				            	allowBlank: true,
				            	listeners :{
				            		'keypress':function(ele,event){
				            			searcheValue=Ext.get("searcheContValue").getValue();//ele.getValue();
				            			if ((event.getKey() == event.ENTER)){
				            				Ext.Ajax.request({ //读取后台传递于前台数据 
				            					url: encodeURI('dhcwl/codecfg/codecfgservice.csp?action=CheckGroupItem&grpId='+grpId+'&searcheCond='+choicedSearcheCond+'&searcheValue='+searcheValue),
				            					method:'get', 
				            					success:function(response, opts){ 
				            					var obj= Ext.decode(response.responseText);//obj储存响应的数据 
				            					allDetailStore.proxy = new Ext.data.PagingMemoryProxy(obj),//PagingMemoryProxy() 一次性读取数据 
				            					allDetailStore.load({params:{start:0,limit:20}});//按20条记录分布 
				            					}, 
				            					failure: function(){Ext.Msg.alert("failure");} 
				            				});
				            				//kpiPanelList.show();
				            			}
				            		}
				            	}
			       	 	}
			      ]
			
		}
       ),
	bbar:new Ext.PagingToolbar({
        pageSize: 20,
        store: allDetailStore,
        displayInfo: true,
        //displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		displayMsg: '显示{0}-{1} 条',
        emptyMsg: "没有记录"
    })
	})
	//allDetailStore.load({params:{start:0,limit:21}});
	
	function test(){
	var KPIDrStr="";
		OkHandler = function(){
			var rowObj=allDetailGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len < 1){
				Ext.Msg.show({title:'注意',msg:'请选择需要数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var idStr="";
					for(var i=0;i<len;i++){
						KPIDr=rowObj[i].get("ID");
						if(idStr==""){
							idStr=KPIDr;
						}else{
							idStr=idStr+"-"+KPIDr
						}
						
					}
				KPIDrStr=idStr;	
				//alert(KPIDrStr);
				window.close();
			}
		}

	}
	
	function selectItemPara(){
 
    }
	
	var codeCfgItmGroupDetailsWin = new Ext.Window({
		title:'项目明细添加',
		id:'codeCfgItmGroupDetails',
		layout : 'table',
		layoutConfig: {columns:2},
		width:500,
		height:550,
		modal:true,
		resizable:true,
		//items:detailGrid
		items:[{
            autoScroll:true,
            width:480,
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
	//明细窗口关闭时调用该方法，将日志记录信息存储起来。
	function handleGrpLog(){
		dhcwl.mkpi.Util.ajaxExc('dhcwl/codecfg/codecfgservice.csp'+'?action=endItemGrpLogGlobal'
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
	
	this.showCodeCfgItmGroupDetailsWin = function(){
		this.showData();
		codeCfgItmGroupDetailsWin.show();
	}
	this.showData = function(){
		Ext.Ajax.request({ //读取后台传递于前台数据 
			url: encodeURI('dhcwl/codecfg/codecfgservice.csp?action=CheckGroupItem&grpId='+grpId),
			method:'get', 
			success:function(response, opts){ 
			var obj= Ext.decode(response.responseText);//obj储存响应的数据 
			allDetailStore.proxy = new Ext.data.PagingMemoryProxy(obj),//PagingMemoryProxy() 一次性读取数据 
			allDetailStore.load({params:{start:0,limit:20}});//按20条记录分布 
			}, 
			failure: function(){Ext.Msg.alert("failure");} 
		}); 
		allDetailGrid.show();
	}
	this.getDetailStore=function(){
    	return allDetailStore;
    }

}
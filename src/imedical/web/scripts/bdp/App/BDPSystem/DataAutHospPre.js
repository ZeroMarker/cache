//数据授权（医院级）
//2014-2-12 by lisen

	var ObjectReference=""  //选中的类别ID，全局变量
	var ObjectType=""		//选中的类别类型，全局变量
	var ObjectReferenceText=""  //选中的选中的角色描述，全局变量
	
	var htmlurl = "../scripts/bdp/AppHelp/BDPSystem/DataAutHospPre/DataAutHospPre.htm";
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
	
Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	
	var GetGroupList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetGroupList";  //获取安全组数据
	var GetLocList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetLocList";  //获取科室数据
	var GetUserList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetUserList";  //获取用户数据
	
	var pagesize = 26;
	
	/**----初始化Ext状态管理器，在Cookie中记录用户的操作状态*/
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());   
	
	/**----显示安全组-----*/
	var Groupds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:GetGroupList_URL}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},
	      [{   name : 'SSGRPRowId',mapping : 'SSGRPRowId',type : 'string'},
		   {   name : 'SSGRPDesc',mapping : 'SSGRPDesc',type : 'string'}]),					
		remoteSort: true
    });

	Groupds.load({
		params : {												  //----------ds加载时发送的附加参数
			start : 0,
			limit : pagesize
		},
		callback : function(records, options, success) {          //----------加载完成后执行的回调函数
		}
	});
			
		/**---------分页工具条-----------*/	
	var Grouppaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : Groupds,											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
	
	/**---------搜索按钮-----------*/
	var GroupSearch = new Ext.Button({
		id : 'GroupSearch',
		iconCls : 'icon-search',
		//text : '搜索',
		handler : function() {                                  //-----------执行回调函数
			Groupgrid.getStore().baseParams={
       			desc :  Ext.getCmp("GroupText").getValue()
       		};
			Groupgrid.getStore().load({									//-----------加载查询出来的数据
			params : {
				start : 0,
				limit : pagesize
			}
		});
		}
	});		
	/**---------刷新按钮-----------*/
	var GroupRefresh = new Ext.Button({
		id : 'GroupRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("GroupText").reset();                     //-----------将输入框清空
			Groupgrid.getStore().baseParams={};
			Groupgrid.getStore().load({                              //-----------加载数据
				params : {
					start : 0,
					limit : pagesize
				}
			});
		}
	});		
	/**---------将工具条放在一起-----------*/
	var GroupText = new Ext.form.TextField({
		id : 'GroupText',
		title:'安全组',
		enableKeyEvents : true,
		width:100,
		listeners : {
       	'keyup' : function(field, e){
       		Groupgrid.getStore().baseParams={
       			desc :  Ext.getCmp("GroupText").getValue()
       		};
			Groupgrid.getStore().load({									//-----------加载查询出来的数据
				params : {				
					start : 0,
					limit : pagesize
					}
				});
	        }
		}						
	})
	var Grouptb = new Ext.Toolbar({
				id : 'Grouptb',
				items : [//GroupSearch, '-',
				GroupText, '->' ,GroupRefresh]
			});
	/**---------创建grid-----------*/
	var Groupgrid = new Ext.grid.GridPanel({
		id : 'Groupgrid',
		region:'center',
		iconCls : 'icon-book',
		title:'安全组',
		collapsed :false,              						//默认展开
		closable : true,
		store : Groupds,									//----------------表格的数据集
		trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
		columns : [sm,
			{ header: '安全组ID',sortable: true, dataIndex: 'SSGRPRowId',width : 50,hidden:true  },
			{ header: '安全组名',sortable: true, dataIndex: 'SSGRPDesc',width : 150  }],
		stripeRows : true,                                //------------------显示斑马线
		loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
			msg : '数据加载中,请稍候...'
		},
		// config options for stateful behavior
		stateful : true,                                  //-----------------
		viewConfig : {									  //-----------------视图配置
			forceFit : true								  //-----------------固定大小
		},
		bbar : Grouppaging,                                    //-----------------底部状态栏
		tbar : Grouptb, 
		stateId : 'Groupgrid'
	});
			
			
	/**----显示用户-----*/
	var Userds = new Ext.data.Store({											
		proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
			url : GetUserList_URL								//---------调用的动作
		}),
		reader : new Ext.data.JsonReader({						    //---------将原始数据转换
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
			},
			[	{   name : 'SSUSRRowId',mapping : 'SSUSRRowId',type : 'string'},
				{	name : 'SSUSRName',mapping : 'SSUSRName',type : 'string' }]),
			remoteSort: true
				
	});

	Userds.load({
		params : {												  //----------ds加载时发送的附加参数
			start : 0,
			limit : pagesize
		},
		callback : function(records, options, success) {          //----------加载完成后执行的回调函数
		}
	});
			
		/**---------分页工具条-----------*/	
	var Userpaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : Userds,											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
	
	/**---------搜索按钮-----------*/
	var UserSearch = new Ext.Button({
		id : 'UserSearch',
		iconCls : 'icon-search',
		//text : '搜索',
		handler : function() {                                  //-----------执行回调函数
			Usergrid.getStore().baseParams={
       			desc :  Ext.getCmp("UserText").getValue()
       		};
			Usergrid.getStore().load({									//-----------加载查询出来的数据
			params : {
				start : 0,
				limit : pagesize
			}
		});
		}
	});		
	/**---------刷新按钮-----------*/
	var UserRefresh = new Ext.Button({
		id : 'UserRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UserText").reset();                     //-----------将输入框清空
			Usergrid.getStore().baseParams={};
			Usergrid.getStore().load({                              //-----------加载数据
				params : {
					start : 0,
					limit : pagesize
				}
			});
		}
	});		
	/**---------将工具条放在一起-----------*/
	var UserText = new Ext.form.TextField({
		id : 'UserText',
		title:'用户',
		enableKeyEvents : true,
		width:100,
		listeners : {
       	'keyup' : function(field, e){
       		Usergrid.getStore().baseParams={
       			desc :  Ext.getCmp("UserText").getValue()
       		};
			Usergrid.getStore().load({									//-----------加载查询出来的数据
				params : {
					start : 0,
					limit : pagesize
					}
				});
	        }
		}						
	})
	var Usertb = new Ext.Toolbar({
				id : 'Usertb',
				items : [//UserSearch, '-',
				UserText, '->' ,UserRefresh]
			});
	/**---------创建grid-----------*/
	var Usergrid = new Ext.grid.GridPanel({
				id : 'Usergrid',
				region:'center',
				iconCls : 'icon-user',
				title:'用户',
				closable : true,
				store : Userds,											//----------------表格的数据集
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns : [sm,{ header: '用户ID',sortable: true, dataIndex: 'SSUSRRowId',width : 50,hidden:true  },
							{ header: '用户',sortable: true, dataIndex: 'SSUSRName',width : 150  }],
				stripeRows : true,                                //------------------显示斑马线
				loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				bbar : Userpaging,                                    //-----------------底部状态栏
				tbar : Usertb, 
				stateId : 'Usergrid'
			});		
			
			
	/**----显示科室-----*/
	var CTLOC = Ext.data.Record.create([				        // ------------
        {   name : 'CTLOCRowID',
			mapping : 'CTLOCRowID',
			type : 'string'
		},
		{	name : 'CTLOCDesc',
			mapping : 'CTLOCDesc',
			type : 'string'
		}
	]);

	var Locds = new Ext.data.Store({											
		proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
			url : GetLocList_URL								//---------调用的动作
		}),
		reader : new Ext.data.JsonReader({						    //---------将原始数据转换
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		},CTLOC),
		remoteSort: true
	});

	Locds.load({
		params : {												  //----------ds加载时发送的附加参数
			start : 0,
			limit : pagesize
		},
		callback : function(records, options, success) {          //----------加载完成后执行的回调函数
		}
	});
			
		/**---------分页工具条-----------*/	
	var Locpaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : Locds,											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
	
	/**---------搜索按钮-----------*/
	var LocSearch = new Ext.Button({
		id : 'LocSearch',
		iconCls : 'icon-search',
		//text : '搜索',
		handler : function() {                                  //-----------执行回调函数
			Locgrid.getStore().baseParams={
       			desc :  Ext.getCmp("LocText").getValue()
       		};
			Locgrid.getStore().load({									//-----------加载查询出来的数据
			params : {
				start : 0,
				limit : pagesize
			}
		});
		}
	});		
	/**---------刷新按钮-----------*/
	var LocRefresh = new Ext.Button({
		id : 'LocRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("LocText").reset();                     //-----------将输入框清空
			Locgrid.getStore().baseParams={};
			Locgrid.getStore().load({                              //-----------加载数据
				params : {
					start : 0,
					limit : pagesize
				}
			});
		}
	});		
	/**---------将工具条放在一起-----------*/
	var LocText = new Ext.form.TextField({
		id : 'LocText',
		title:'科室',
		enableKeyEvents : true,
		width:100,
		listeners : {
       	'keyup' : function(field, e){
       		Locgrid.getStore().baseParams={
       			desc :  Ext.getCmp("LocText").getValue()
       		};
			Locgrid.getStore().load({									//-----------加载查询出来的数据
				params : {
					start : 0,
					limit : pagesize
					}
				});
	        }
		}						
	})
	var Loctb = new Ext.Toolbar({
				id : 'Loctb',
				items : [//LocSearch, '-',
				LocText, '->' ,LocRefresh]
			});
	/**---------创建Locgrid-----------*/
	var Locgrid = new Ext.grid.GridPanel({
		id : 'Locgrid',
		region:'center',
		title:'科室',
		iconCls : 'icon-LoginLoc',
		closable : true,
		store : Locds,											//----------------表格的数据集
		trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
		columns : [sm,
			{ header: '科室ID',sortable: true, dataIndex: 'CTLOCRowID',width : 50,hidden:true  },
			{ header: '科室名',sortable: true, dataIndex: 'CTLOCDesc',width : 150  }],
		stripeRows : true,                                //------------------显示斑马线
		loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
			msg : '数据加载中,请稍候...'
		},
		// config options for stateful behavior
		stateful : true,                                  //-----------------
		viewConfig : {									  //-----------------视图配置
			forceFit : true								  //-----------------固定大小
		},
		bbar : Locpaging,                                    //-----------------底部状态栏
		tbar : Loctb, 
		stateId : 'grid'
	});
	
	/** 授权类别面板 */
	var westpanel = new Ext.Panel({
			id:'westpanel',
			region:"west",
			title:"<div style='text-align:center'>授权类别</div>",
			//autoScroll:true,
			split:true,
			collapsible:true, //自动收缩按钮 
			border:true,
			width:220,
			minSize: 220,
			maxSize: 300,
			//expanded : false,
			//margins:'0 0 5 5',
			//cmargins:'0 5 5 5',
			//lines:false,
	    	layout:"accordion",
	    	//extraCls:"roomtypegridbbar",
			//iconCls:'icon-feed', 
	 		//添加动画效果
			layoutConfig: {animate: true},
			items:[Groupgrid,Locgrid,Usergrid]
		});
	
	/** 以下为加载事件  */	
	var GridClick = function(ObjectType,ObjectReference){
		refreshTab();
		/*clearFind(); //清除树过滤
		//2013-5-14 by lisen
		var f  = function(node) {
			node.getUI().toggleCheck(false);
		}
		Ext.getCmp("menuConfigTreePanel").getRootNode().cascade(f);
		var AutJson="";
		AutJson = tkMakeServerCall("web.DHCBL.Authorize.Menu","GetAutJson",ObjectType,ObjectReference);
		if(AutJson!=""){
			var arr = Ext.decode(AutJson);
			for (var i=0;i<arr.length;i++){
				var node = Ext.getCmp("menuConfigTreePanel").getNodeById(arr[i].ID);
				if(node) node.getUI().toggleCheck(true);
				else continue;
			}
		}
		//如果是demo,则默认全部选中 2013-8-30 by lisen
		if(ObjectType=="G"&&ObjectReference==1){
			var f  = function(node) {
				node.getUI().toggleCheck(true);
			}
			Ext.getCmp("menuConfigTreePanel").getRootNode().cascade(f);
		}*/
	}
	
	Usergrid.on("rowclick", function(grid, rowIndex, e) {								//用户菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		ObjectReference=_record.get('SSUSRRowId')	
		ObjectType="U"
		ObjectReferenceText=_record.get('SSUSRName')
		GridClick(ObjectType,ObjectReference);
	},this,{stopEvent:true});
	
	Locgrid.on("rowclick", function(grid, rowIndex, e) {								//科室菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		ObjectReference=_record.get('CTLOCRowID')
		ObjectType="L"
		ObjectReferenceText=_record.get('CTLOCDesc')
		GridClick(ObjectType,ObjectReference);
	},this,{stopEvent:true});
		
	Groupgrid.on("rowclick", function(grid, rowIndex, e) {								//安全组菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		ObjectReference=_record.get('SSGRPRowId')
		ObjectType="G"
		ObjectReferenceText=_record.get('SSGRPDesc')
		GridClick(ObjectType,ObjectReference);
	},this,{stopEvent:true});
	 
	var roletitle = new Ext.form.Label({
		id: 'roletitle',
		html:""
		//cls: 'icon-refresh'
	});
	
	var Updateroletitle = function(ObjectType,ObjectReferenceText){
		var type ="";
		var icon ="";
		var text = ObjectReferenceText;
		switch (ObjectType){
		  case "G": 
		  	type =" 安全组："
		  	icon = "book.png'"
		    break;
		  case "L": 
		  	type =" 科室：";
		  	icon = "application_double.png'"
		    break;
		  case "U":
		  	type =" 用户：";
		  	icon = "user.png'"
		    break;
		}
		//Ext.getCmp("roletitle")
		Ext.getCmp("roletitle").el.dom.innerHTML ="<img src='"+Ext.BDP.FunLib.Path.URL_Icon + icon +"></img><span style='border: 2px'> "+type + text+"</span>"
	}
	
	/** 医院级授权TabPanel */
	var centertab =  new Ext.TabPanel({
                id:'main-tabs',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:120,
                //margins:'0 5 5 0',
                resizeTabs:true,
                tbar:[roletitle,"->",helphtmlbtn]  ,
                //tabWidth:150
                items:[{
                	id:'hosptab',
                	title:"医院级授权",
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='websys.csp'></iframe>"
                }]
		});
	/** 刷新医院级授权TabPanel */
	var refreshTab = function(){
		var obj = Ext.getCmp('hosptab');
		var url = "dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/DataAutHospPre_Panel"+"&ObjectType="+ObjectType+"&ObjectReference="+ObjectReference+"&ObjectReferenceText="+ObjectReferenceText;
		if ('undefined'!==typeof websys_getMWToken)
        {
			url += "&MWToken="+websys_getMWToken() // 增加token
		}
		var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>";
	    obj.update(html);
	    Updateroletitle(ObjectType,ObjectReferenceText);
	}
	
	/** 布局 */
	var viewport = new Ext.Viewport({
			id:'vp',
        	layout:'border',
        	items:[westpanel,centertab]
    	});
     /** 如果未开启医院级别授权，则禁用此页面。 */
    	var BDPHospAut =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut");
    	if (BDPHospAut != "Y")
    	{
    		Ext.getCmp('westpanel').disable();
    		//Ext.getCmp('centertab').disable();
    		Ext.getCmp('vp').disable();
    		//Ext.MessageBox.alert("","未开启医院级别授权，请在平台配置下开启，或者联系管理员。");
    		alert('未开启医院级别授权！医院级别授权通常在区域性医院使用，如需要开启医院级别授权请在平台配置下设置。')
    	}

});
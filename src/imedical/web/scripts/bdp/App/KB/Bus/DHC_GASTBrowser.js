/*!
 * 药品说明书主JS
 * 创建人 - 蔡昊哲
 * 创建时间 - 2014-12-2
 * 本JS分为四部分
 * 1.药品通用名展示部分
 * 2.胃镜项目说明书明细展示部分
 * 3.说明书编辑部分（弹出window）
 */
 document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPTabCloseMenu.js"> </script>');
 
 document.write('<style type="text/css"> .x-grid3-row td, .x-grid3-summary-row td { line-height:13px; vertical-align: middle; padding-left:1px; padding-right:1px; -moz-user-select: none; -khtml-user-select:none; -webkit-user-select:ignore; } </style>');
 //全局变量
	var GlPGenDr ="" //内镜项目通用名ID
	var GlPPointer =""  //关联剂型ID
	var GenDesc ="" //内镜项目名加剂型名
	
var GenCode = Ext.BDP.FunLib.getParam("GenCode"); 
var PointerCode = Ext.BDP.FunLib.getParam("PointerCode");
	
//alert(GenCode+PointerCode);

Ext.onReady(function(){

	
	/* 内镜项目通用名列表 */var DrugGeneric_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCBusMain&pClassQuery=GetInstrList"; 
	/* 内镜项目通用名列表 */var GetDrugBookList = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCBusMain&pClassQuery=GetDrugBookList1";
	
	/* 内镜项目说明书明细 *///var GetDrugBookList = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMain&pClassMethod=GetDrugBookList";
	var QUERY_HIS_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.Arcim&pClassQuery=GetDataForCmbGen1";
	var QUERY_CONTRAST_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCGenItmContrast&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCGenItmContrast&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCGenItmContrast";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCGenItmContrast&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	//http://127.0.0.1/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_DrugBrowser&GenCode=%E9%98%BF%E8%8E%AB%E8%A5%BF%E6%9E%97&PointerCode=%E8%BD%AF%E8%83%B6%E5%9B%8A
	
	
	//alert(pagesize_main);
	
	var lib = "ENDO";
	
	var hiddenflag= false;  //控制目录是否显示
	if (GenCode != "" && GenCode!=null)
	{
		hiddenflag =true;
	}
	
    Ext.QuickTips.init();
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	var LOADMENU_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMain&pClassMethod=GetMenu"+"&code="+lib;
	
	
	/** ----------------------------------------------------- 1.内镜项目通用名展示部分  -------------------------------------------------------------**/
	
		
    var xg = Ext.grid;

    // shared reader
    var reader = new Ext.data.ArrayReader({}, [
       {name: 'company'},
       {name: 'industry'},
       {name: 'desc'}
    ]);
    
	/** grid数据存储 */
	var dsWestN = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : DrugGeneric_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				},[{
						name : 'GlPRowId',
						mapping : 'GlPRowId',
						type : 'string'
					}, {
						name : 'PHEGDesc',
						mapping : 'PHEGDesc',
						type : 'string'
					}, {
						name : 'PHEFDesc',
						mapping : 'PHEFDesc',
						type : 'string'
					}, {
						name : 'GlPGenDr',
						mapping : 'GlPGenDr',
						type : 'string'
					}, {
						name : 'GlPPointer',
						mapping : 'GlPPointer',
						type : 'string'
					}, {
						name : 'GlPActiveFlag',
						mapping : 'GlPActiveFlag',
						type : 'string'
					}, {
						name : 'GlPSysFlag',
						mapping : 'GlPSysFlag',
						type : 'string'
					}
			])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWestN
	});
	/** grid加载数据 */
	dsWestN.baseParams={lib : lib};
	dsWestN.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var pagingWestN = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsWestN,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录"
		/*plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_main=this.pageSize;
			}
		}*/
	});
	/**搜索按钮 */
	var btnWestNSearch = new Ext.Button({
		id : 'btnWestNSearch',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnWestNSearch'),
		iconCls : 'icon-search',
		text : '搜索',
		handler : function() {
			gridWestN.getStore().baseParams={
					lib : lib,
					desc : Ext.getCmp("textDesc").getValue()
       		};	
			gridWestN.getStore().load({
				params : {
							start : 0,
							limit : pagesize_main
						}
				});
		}
	});
	/**重置按钮 */
	var btnWestNRefresh = new Ext.Button({
		id : 'btnWestNRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnWestNRefresh'),
		handler : function() {
			Ext.getCmp("textDesc").reset();
			gridWestN.getStore().baseParams={
				lib : lib		
			};
			gridWestN.getStore().load({
				params : {
					start : 0,
					limit : pagesize_main
					}
				});
		}
	});
	/**搜索工具条 */
	var tbWestN = new Ext.Toolbar({
		id : 'tbWestN',
		items : [
				{
					xtype : 'textfield',
					id : 'textDesc',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('textDesc')
				}, '-', btnWestNSearch, '-', '->'
		]
	});
	
	/** 创建grid */
	var gridWestN = new Ext.grid.GridPanel({
		id : 'gridWestN',
		region : 'west',
		width:220,
		hidden:hiddenflag,
		autoScroll:true,
		title:"内镜项目通用名",
		split:true,
		collapsible:true, //自动收缩按钮
		closable : true,
		store : dsWestN,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
							header : 'GlPRowId',
							sortable : true,
							dataIndex : 'GlPRowId',
							hidden : true
						}, {
							header : '内镜项目通用名',
							sortable : true,
							dataIndex : 'PHEGDesc'
						}, {
							header : '通用名ID',
							sortable : true,
							dataIndex : 'GlPGenDr',
							hidden:true
						}, {
							header : '部位',
							sortable : true,
							dataIndex : 'PHEFDesc'
						},  {
							header : '部位ID',
							sortable : true,
							dataIndex : 'GlPPointer',
							hidden:true
						},  {
							header : '是否可用',
							sortable : true,
							dataIndex : 'GlPActiveFlag',
							hidden : true,
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},  {
							header : '是否系统标识',
							sortable : true,
							hidden : true,
							dataIndex : 'GlPSysFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}],
		stripeRows : true,
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWestN,
		tbar : tbWestN,
		stateId : 'gridWestN'
	});
	
	
	gridWestN.on("rowclick",function(grid,rowIndex,e){  
		var _record = gridWestN.getSelectionModel().getSelected();//records[0]
		
		var Pdesc= _record.get('PHEGDesc');
		var PFdesc= _record.get('PHEFDesc');
		
		GlPGenDr = _record.get('GlPGenDr');
		GlPPointer = _record.get('GlPPointer');
	
		//alert(GlPGenDr);
		//alert( _record.get('PHEGDesc'));
		GenDesc=Pdesc+"/"+PFdesc
		//<img src='"+Ext.BDP.FunLib.Path.URL_Icon + icon +"></img>
		Ext.getCmp("roletitle").el.dom.innerHTML ="<h1>"+GenDesc+"</h1>"
		
		Ext.getCmp("edit_btn").setDisabled(false);
		
		var tabs=Ext.getCmp('main-tabs');
		tabs.removeAll();
		
		 ds.load({
			params:{
				'GenDr':GlPGenDr,
				'PointerType':'Form',
				'PointerDr':GlPPointer,
				start:0,
				limit:10000
			},
			callback: function(records, options, success){
			}
		});
    });  
    
       var showData = function(){
			
			var Pdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenDesc",GenCode);
			var PFdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getPartDesc",PointerCode);
			
			//alert(Pdesc);
			var GlPGenDr = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenRowId",GenCode);
			var GlPPointer = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getPartRowId",PointerCode);
			
			
			if ((Pdesc=="") || (PFdesc=="") || (GlPGenDr=="-1") ||(GlPPointer=="-1"))
			{
				GenDesc = "未查询到该内镜说明书"
			}
			else
			{
				GenDesc=Pdesc+"/"+PFdesc
				 ds.load({
				 params:{
					'GenDr':GlPGenDr,
					'PointerType':'Form',
					'PointerDr':GlPPointer,
					start:0,
					limit:10000
				},
				callback: function(records, options, success){
				}
				});
			}
			
			//alert(GlPGenDr);
			//alert( _record.get('PHEGDesc'));
			
			//<img src='"+Ext.BDP.FunLib.Path.URL_Icon + icon +"></img>
			//Ext.getCmp("roletitle").el.dom.innerHTML =
			
			roletitle.html="<h1>"+GenDesc+"</h1>";
			
			//Ext.getCmp("edit_btn").setDisabled(false);
			
			//var tabs=Ext.getCmp('main-tabs');
			//tabs.removeAll();
			
			
       }
	

    /** ----------------------------------------------------- 以上内镜项目通用名展示部分 Over -------------------------------------------------------------**/
	
	
	
	
	/** ----------------------------------------------------- 3.说明书编辑部分（弹出框）  -------------------------------------------------------------**/
	var westpanel = new Ext.Panel({
			id:'westpanel',
			region:"west",
			//title:"<div style='text-align:center'>欢迎进入基础数据平台</div>",
			//title:'阿莫西林',
			autoScroll:true,
			split:true,
			collapsible:true, //自动收缩按钮
			border:true,
			width:150,
			minSize: 100,
			maxSize: 220,
	    	layout:"accordion",
	    	defaults:{  
 				 collapsed:false  
			},  
	 		//添加动画效果
			layoutConfig: {animate: true},
			items:[]
		});
		
	//var SessionStr=Ext.BDP.FunLib.Session();
	// 获取一级菜单JSON
	var menusJson = [{"id":"1","text":"","iconCls":"","leaf":false}]
	//var menusJson = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetMenu","menuTreeRoot",SessionStr);
	if (menusJson=="") return;
	//window.eval("var menuArray = " + menusJson);
	
	var menuArray = menusJson;

	loadMenu(menuArray,westpanel);
	
	/** 加载菜单 */
	function loadMenu(menuArray,westpanel){
		for(var intRow = 0; intRow < menuArray.length; intRow ++){
			var menuObj = menuArray[intRow];
			/** TreePanel */
			var tree = new Ext.tree.TreePanel({
					border:false,
					animate:true,
					enableDD:false, //EnableDD="true" 才可实现选中全部子结点
					containerScroll:true,
		            loader: new Ext.tree.TreeLoader({
		            	nodeParameter : "id",
		            	dataUrl : LOADMENU_URL,
		            	baseParams : {SessionStr:""}
		            }),
		            rootVisible:menuObj.leaf,
		            lines:true, //虚线
		            autoScroll:true,
		            root: new Ext.tree.AsyncTreeNode({
	                          id: menuObj.id,
		                      text: menuObj.text
		            }),
		            listeners:{
		            	"click":function(node,event) {
									addtab(node);
								}
		            }
				});
			/** 定义一级菜单panel */
			var proPanel = new Ext.Panel({
					id:menuObj.id,
					title:menuObj.text,
					autoScroll:true,
					collapsed:true,
					iconCls:menuObj.iconCls,  //"icon-pro",
					//icon:"../Scripts/dhcmed/main/pro.gif",
					items:tree,
					listeners:{
	            		"beforeexpand":function(p,a){
					            			//alert(p.title);
					            		}
	                }
				});
			westpanel.add(proPanel);
		}
	}
	
	/** 新增TabPanel的函数 */
    var addtab = function(node){
	    	if (!node.isLeaf()) return;
	    	var tabs=Ext.getCmp('main-tabs');
	    	var tabId = "tab_"+node.id;
	    	var obj = Ext.getCmp(tabId);
	    	if (obj){ //判断tab是否已打开
	    		//刷新页面
//	    		var url = node.attributes.myhref;
//	    		var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>";
//	    		obj.update(html);
	    	}else{
	    		//alert(GlPGenDr);
	    		var parm = "&GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer
	    		var url = node.attributes.myhref + parm;
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:node.text,
	            	tabTip:node.text,
	            	iconCls:node.attributes.iconCls,
	            	html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>",
	            	closable:true
	      		 });
	    	}
	    	obj.show();	//显示tab页
	    };	
	
	 var menu = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [
            {
                text: '用法频率',
                checked: true       // when checked has a boolean value, it is assumed to be a CheckItem
            }, '-', {
                text: '用药频率'
            },{
                text: '用法用量'
            },{
                text: '适应症'
            }
        ]
    });				
 
	var action = new Ext.Action({
        text: 'Action 1',
        handler: function(){
            Ext.example.msg('Click','You clicked on "Action 1".');
        },
        iconCls: 'blist'
    });
 
	/** 初始化Home TabPanel */
	var centertab =  new Ext.TabPanel({
                id:'main-tabs',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:120,
              
                resizeTabs:true,
                //tabWidth:150
                plugins: new Ext.BDP.TabCloseMenu(), //右键关闭菜单
                items:[/*{
                	title:"Home",
					//html:"Welcome"
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='websys.csp'></iframe>"
                }*/]
		});
	
	/** 布局 */
	/*var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[westpanel,centertab]
    	});
	*/
	

 /** ----------------------------------------------------- ↑↑↑↑↑ 3.说明书编辑部分（弹出框）  -------------------------------------------------------------**/
		
		
		
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**主Grid部分**/

    var store = new Ext.data.GroupingStore({
            reader: reader,
            data: xg.dummyData,
            
            sortInfo:{field: 'company', direction: "ASC"},
            groupField:'industry'
        });

        
        
    /**  增加 **/   
        

	/** grid数据存储 */
	var ds = new Ext.data.GroupingStore({
		proxy : new Ext.data.HttpProxy({ url : GetDrugBookList }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					id:"PHINSTDesc",
					successProperty : 'success'
					}, [{
							name : 'PHINSTRowId',
							mapping : 'PHINSTRowId',
							type : 'string'
						}, {
							name : 'PHINSTDesc',
							mapping : 'PHINSTDesc',
							type : 'string'
						}, {
							name : 'PHINSTGroupDesc',
							mapping : 'PHINSTGroupDesc',
							type : 'string'
						}
				]),
		groupField:'PHINSTGroupDesc',
		sortInfo : {//排序
			 field : 'PHINSTRowId',
			 direction : "ASC"
			}
	});
	
	
		
	/**用于Grid中返回组图片**/
	//蔡昊哲  
	ReturnFlagIcon = function(value)
	{
		var returnValue = "";
		switch(value)
		{
		  case "用药频率":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/yypl32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;
		  case "给药途径":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/yyff32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;
		  case "适应证":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/syz32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;
		  case "用法用量":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/yfyl32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;
		  case "禁忌证":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/jjz32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;
		  case "相互作用":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/xhzy32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;
		  case "禁忌":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/jj32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;
		  case "不良反应":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/blfy32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;
		  case "注意事项":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/zysx32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;

		  default:
		  returnValue = "<span style='font-size:24px'>"+value+"</span>";
		} 
		return returnValue;
	}	
			
    var grid = new Ext.grid.GridPanel({
        store: ds,
        columns: [
            {id:'PHINSTRowId',header: "PHINSTRowId", width: 60, sortable: true,hidden:true , dataIndex: 'PHINSTRowId'},
            {id:'PHINSTDesc',header: "PHINSTDesc", width: 20, sortable: true, dataIndex: 'PHINSTDesc',renderer :
             function(v){
            	//alert(v);
                //m.css='x-grid-back-red';  
                //return v;  
                return v;
                //"<span style='font-size:18px'>"+v+"</span>";
            }},
            {id:'PHINSTGroupDesc',header: "PHINSTGroupDesc", width: 20, sortable: true, dataIndex: 'PHINSTGroupDesc',
            renderer : ReturnFlagIcon}
            /* function(v){
            	alert(v);
                //m.css='x-grid-back-red';  
                return v;  
                //return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"yes.png' style='border: 0px'";
            }}*/
        ],

        view: new Ext.grid.GroupingView({
        	//sortAscText: "升序",  
        	//sortDescText: "降序",  
       		//columnsText: "表格字段",  
        	//groupByText: "使用当前字段进行分组",  
        	//showGroupsText: "表格分组", 
        	//groupOnSort:true,
            forceFit:true,
            showGroupName: false,
            enableNoGroups: false,
			enableGroupingMenu: false,
            hideGroupedColumn: true
            //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        }),
        
		hideHeaders:true,
        frame:true,
        region:"center",
        width: 1000,
        height: 950,
        //collapsible: true,
        //animCollapse: false,
        //title: 'Grouping Example',
        iconCls: 'icon-grid'
        /*,
        fbar  : ['->', {
            text:'Clear Grouping',
            iconCls: 'icon-clear-group',
            handler : function(){
                store.clearGrouping();  }]
            }*/
      
        //renderTo: document.body
    });
    
    Ext.BDP.FunLib.Newline(grid);
    /** 新增TabPanel的函数 */
    var gridAddTab = function(id,text,myhref){
	    	//if (!node.isLeaf()) return;
	    	var tabs=Ext.getCmp('main-tabs');
	    	var tabId = "tab_"+ id;
	    	var obj = Ext.getCmp(tabId);
	    	if (obj){ //判断tab是否已打开
	    		//刷新页面
//	    		var url = node.attributes.myhref;
//	    		var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>";
//	    		obj.update(html);
	    	}else{
	    		//alert(GlPGenDr);
	    		var parm = "&GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer
	    		var url = myhref + parm;
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:text,
	            	tabTip:text,
	            	//iconCls:iconCls,
	            	html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>",
	            	closable:true
	      		 });
	    	}
	    	obj.show();	//显示tab页
	    };
	    	
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 1200,
		height : 600,
		layout:'border',
		//layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		  /*tbar:[     {text:'Button w/ Menu',
            				iconCls: 'bmenu',  // <-- icon
           					menu: menu  //       // <-- Add the action directly to a menu
            }],*/
		items : [westpanel,centertab],
		buttons : [{
			text : '确定',
			handler : function() {
				 ds.load({
			params:{
				'GenDr':GlPGenDr,
				'PointerType':'Form',
				'PointerDr':GlPPointer,
				start:0,
				limit:10000
			},
			callback: function(records, options, success){
			}
		});
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
			
			},
			//"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {}
		}
	});
	
	var btnRefresh = new Ext.Button({
			id : 'btnRefresh',
			iconCls : 'icon-refresh',
			text : '重置',
			x:'90%',
			y:'10%',
			handler : function() {
			}
	});
	
	var roletitle = new Ext.form.Label({
		id: 'roletitle',
		//html:"<h1>头孢拉定胶囊 [0.5g*16粒]</h1>",
		x:'35%',
		y:'5%'
		//cls: 'icon-refresh'
	});
	
	
	var btnEditwin = new Ext.Toolbar.Button({
			text : '编辑',
			tooltip : '编辑药品',
			iconCls : 'icon-edit',
			disabled : true,
			id:'edit_btn',
			x:'85%',
			y:'10%',
			//disabled : false,
			handler : function AddData() {
				win.setTitle(GenDesc);
				win.setIconClass('icon-edit');
				win.show('');
		},
		scope : this
	});
	
	var np=new Ext.Panel({
		id :"np",
		region:"north",
		border:true,
		layout: 'absolute',
		items:[roletitle],
		//title: 'A Panel with W3C-suggested body-html styling',
		preventBodyReset: true,
		height:80
		//renderTo: 'panel-reset-true',
		//width: 400,
		/*html:  [
			'<h1>阿莫西林胶囊 [0.5g*16粒]</h1>',
			'<h2>0.5g*16粒</h2>'
		]*/
	});
	
	
	var center = new Ext.Panel({
		id : 'gridWest',
		//title:'药品通用名与HIS对照',
		region : 'center',
		//width:550,
		split:true,
		//collapsible:true,
		layout:'border',
		items:[np,grid]
	})
	
   if(hiddenflag==true)
   {
   	  showData();
   }
    
    var viewport = new Ext.Viewport({
				layout : 'border',
				items : [gridWestN,center]//显示的内容grid
	});
});

//创建viewport
	

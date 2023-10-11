/*!
 * 药品说明书主JS
 * 创建人 - 蔡昊哲
 * 创建时间 - 2014-12-2
 * 本JS分为四部分
 * 1.药品通用名展示部分
 * 2.药品说明书明细展示部分
 * 3.说明书编辑部分（弹出window）
 */
 document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPTabCloseMenu.js"> </script>');
 
 document.write('<style type="text/css"> .x-grid3-row td, .x-grid3-summary-row td { line-height:13px; vertical-align: middle; padding-left:1px; padding-right:1px; -moz-user-select: none; -khtml-user-select:none; -webkit-user-select:ignore; } </style>');
 //全局变量

	var GlPGenDr ="" //药品通用名ID
	var GlPPointer =""  //关联剂型ID
	var GenDesc ="" //药品名加剂型名
	var GlPPointerType =""  //区分标识
	
Ext.onReady(function(){

	
	/* 通用名列表 */var DrugGeneric_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCBusMain&pClassQuery=GetInstrList"; 
	/* 药品通用名列表 */var GetDrugBookList = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCBusMain&pClassQuery=GetDrugBookList1";
	
	/* 药品说明书明细 *///var GetDrugBookList = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMain&pClassMethod=GetDrugBookList";
	var QUERY_HIS_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.Arcim&pClassQuery=GetDataForCmbGen1";
	var QUERY_CONTRAST_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCGenItmContrast&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCGenItmContrast&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCGenItmContrast";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCGenItmContrast&pClassMethod=DeleteData";
	var BindingForm="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtForm&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	//alert(pagesize_main);
	
	var lib = "DRUG";
	var countInfo="";
	
    Ext.QuickTips.init();
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	var LOADMENU_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMain&pClassMethod=GetMenu"+"&code="+lib;
	
	
	/** ----------------------------------------------------- 1.药品通用名展示部分  -------------------------------------------------------------**/
	
		
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
	//dsWestN.baseParams={lib : lib};
	
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
		text : '',
		handler : WestNSearch=function() {
			gridWestN.getStore().baseParams={
				lib : lib,
				desc : Ext.getCmp("textDesc").getValue(),
				point: Ext.getCmp("GlPPointer").getValue()
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
		text : '',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnWestNRefresh'),
		handler : WestNRefresh=function() {
			Ext.getCmp("textDesc").reset();
			Ext.getCmp("GlPPointer").reset();
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
				btnWestNSearch, '-',{
					xtype : 'textfield',
					id : 'textDesc',
					width:80,
					emptyText : '检索框',
					enableKeyEvents : true,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('textDesc'),
					listeners : {
	                    /*'specialkey': function(field,e){    
							if (e.keyCode ==13) {  //Enter
								WestNSearch();
							 }
							 if (e.keyCode==27){  //Escape
								WestNRefresh();
							 }
	                    }*/
						'keyup' : function(field, e){
					       		WestNSearch();
						 }
					}
				},'-', {
					xtype : 'combo',
					id : 'GlPPointer',
					width:80,
					emptyText : '剂型',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('GlPPointer'),
					triggerAction : 'all',// query
					queryParam : "desc",
					forceSelection : true,
					selectOnFocus : false,
					typeAhead : true,
					mode : 'remote',
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					allQuery : '',
					minChars : 1,
					listWidth : 250,
					valueField : 'PHEFRowId',
					displayField : 'PHEFDesc',
					store : new Ext.data.JsonStore({
						url : BindingForm,
						root : 'data',
						totalProperty : 'total',
						idProperty : 'PHEFRowId',
						fields : ['PHEFRowId', 'PHEFDesc'],
						remoteSort : true,
						sortInfo : {
							field : 'PHEFRowId',
							direction : 'ASC'
						}
					}),
					listeners : {
				       'select' : function(){
				       			WestNSearch();
					        }
					}	
				},'->',btnWestNRefresh
		]
	});
	
	/** 创建grid */
	var gridWestN = new Ext.grid.GridPanel({
		id : 'gridWestN',
		region : 'west',
		iconCls : 'icon-book',
		//width:220,
		autoScroll:true,
		title:"药品通用名",
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
							header : '药品通用名',
							sortable : true,
							dataIndex : 'PHEGDesc'
						}, {
							header : '通用名ID',
							sortable : true,
							dataIndex : 'GlPGenDr',
							hidden:true
						}, {
							header : '剂型',
							sortable : true,
							dataIndex : 'PHEFDesc'
						},  {
							header : '剂型ID',
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
	dsWestN.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		     lib : lib
		  }   
		)
	});
	dsWestN.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	
	gridWestN.on("rowclick",function(grid,rowIndex,e){  
		

		var _record = gridWestN.getSelectionModel().getSelected();//records[0]
		
		var Pdesc= _record.get('PHEGDesc');
		var PFdesc= _record.get('PHEFDesc');
		
		GlPGenDr = _record.get('GlPGenDr');
		GlPPointer = _record.get('GlPPointer');
		GlPPointerType="Form"
	
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
				'PointerType':GlPPointerType,
				'PointerDr':GlPPointer,
				start:0,
				limit:10000
			},
			callback: function(records, options, success){
			}
		});
		
		/*Ext.getCmp("np").html=[
			'<h1>'+_record.get('PHEGDesc')+'[0.5g*16粒]</h1>',
			'<h2>0.5g*16粒</h2>'
		]*/
		//np.html = 
		/*html:  [
			'<h1>阿莫西林胶囊 [0.5g*16粒]</h1>',
			'<h2>0.5g*16粒</h2>'
		]*/
        /*var row=grid.getStore().getAt(rowIndex).data;  
		win.setTitle('修改');
	    win.setIconClass('icon-update');
	    win.show(); 
	    loadFormData(grid);
		//var record = grid.getSelectionModel().getSelected();//records[0]
		//Ext.getCmp("form-spec-save").getForm().loadRecord(record);
	    
	    //激活基本信息面板
        tabs.setActiveTab(0);
        //加载别名面板
        var _record = grid.getSelectionModel().getSelected();
        AliasGrid.DataRefer = _record.get('CTSPCRowId');
        AliasGrid.loadGrid();*/
    });  
    
    
	
    /** ----------------------------------------------------- 以上药品通用名展示部分 Over -------------------------------------------------------------**/
	
	/** ----------------------------------------------------- 商品名展示部分  -------------------------------------------------------------**/
	var GetProList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassQuery=GetDataForCmb2";  //获取商品名数据	
	/**----显示商品名-----*/
	var Pro = Ext.data.Record.create([				        // ------------
        {   name : 'PHNRowId',
			mapping : 'PHNRowId',
			type : 'string'
		},
		{	name : 'PHNDesc',
			mapping : 'PHNDesc',
			type : 'string'
		}
		,
		{	name : 'PHNFormDr',
			mapping : 'PHNFormDr',
			type : 'string'
		}
		,
		{	name : 'PHNFactory',
			mapping : 'PHNFactory',
			type : 'string'
		}
		,
		{	name : 'PHNManfDR',
			mapping : 'PHNManfDR',
			type : 'string'
		}
		, 
		{
			name : 'PHNToxicity',
			mapping : 'PHNToxicity',
			type : 'string'
		}
	]);

	var Prods = new Ext.data.Store({											
		proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
			url : GetProList_URL								//---------调用的动作
		}),
		reader : new Ext.data.JsonReader({						    //---------将原始数据转换
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		},Pro)
	});
			
		/**---------分页工具条-----------*/	
	var Propaging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : Prods,											     //-----------刚ds发生load事件时会触发paging
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
	var ProSearch = new Ext.Button({
		id : 'ProSearch',
		iconCls : 'icon-search',
		//text : '搜索',
		handler : SearchPro=function() {                                  //-----------执行回调函数
			Progrid.getStore().baseParams={
       			desc :  Ext.getCmp("ProText").getValue(),
       			form :  Ext.getCmp("FormText").getValue()
       		};
			Progrid.getStore().load({									//-----------加载查询出来的数据
			params : {
				start : 0,
				limit : pagesize_main
			}
		});
		}
	});		
	/**---------刷新按钮-----------*/
	var ProRefresh = new Ext.Button({
		id : 'ProRefresh',
		iconCls : 'icon-refresh',
		handler : RefreshPro=function() {
			Ext.getCmp("ProText").reset();                     //-----------将输入框清空
			Ext.getCmp("FormText").reset();  
			Progrid.getStore().baseParams={};
			Progrid.getStore().load({                              //-----------加载数据
				params : {
					start : 0,
					limit : pagesize_main
				}
			});
		}
	});		
	/**---------将工具条放在一起-----------*/
	var ProText = new Ext.form.TextField({
		id : 'ProText',
		title:'商品名',
		emptyText : '检索框',
		enableKeyEvents : true,
		width:80,
		listeners : {
         /*'specialkey': function(field,e){    
				if (e.keyCode ==13) {  //Enter
					SearchPro();
				 }
				 if (e.keyCode==27){  //Escape
					RefreshPro();
				 }
            }*/
			'keyup' : function(field, e){
				 SearchPro();
			}
		}					
	})
	var FormText = new Ext.form.ComboBox({
					id : 'FormText',
					width:80,
					emptyText : '剂型',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('FormText'),
					triggerAction : 'all',// query
					queryParam : "desc",
					forceSelection : true,
					selectOnFocus : false,
					typeAhead : true,
					mode : 'remote',
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					allQuery : '',
					minChars : 1,
					listWidth : 250,
					valueField : 'PHEFRowId',
					displayField : 'PHEFDesc',
					store : new Ext.data.JsonStore({
						url : BindingForm,
						root : 'data',
						totalProperty : 'total',
						idProperty : 'PHEFRowId',
						fields : ['PHEFRowId', 'PHEFDesc'],
						remoteSort : true,
						sortInfo : {
							field : 'PHEFRowId',
							direction : 'ASC'
						}
					}),
					listeners : {
				       'select' : function(){
				       			SearchPro();
					        }
					}
				})
	var Protb = new Ext.Toolbar({
				id : 'Protb',
				items : [ProSearch, '-',ProText, '-',FormText, '->' ,ProRefresh]
			});
	/**---------创建Progrid-----------*/
	var Progrid = new Ext.grid.GridPanel({
		id : 'Progrid',
		region:'center',
		title:'商品名',
		autoScroll:true,
		iconCls : 'icon-LoginLoc',
		closable : true,
		store : Prods,											//----------------表格的数据集
		trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
		columns : [sm,
			{ header: '商品名ID',sortable: true, dataIndex: 'PHNRowId',width : 50,hidden:true  },
			{ header: '商品名',sortable : true, dataIndex: 'PHNDesc',width : 150  },
			{ header: '剂型',sortable : true, dataIndex: 'PHNFormDr',width : 150  },
			{ header: '厂商',sortable : true, dataIndex: 'PHNFactory',width : 150,hidden:true  },
			{ header: '厂商新',sortable : true, dataIndex: 'PHNManfDR',width : 150,hidden:true  },
			{ header: '毒性',sortable : true, dataIndex: 'PHNToxicity',width : 150 ,hidden:true }],
		stripeRows : true,                                //------------------显示斑马线
		loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
			msg : '数据加载中,请稍候...'
		},
		// config options for stateful behavior
		stateful : true,                                  //-----------------
		viewConfig : {									  //-----------------视图配置
			forceFit : true								  //-----------------固定大小
		},
		bbar : Propaging,                                    //-----------------底部状态栏
		tbar : Protb, 
		stateId : 'Progrid'
	});
	/*Prods.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		     desc :  Ext.getCmp("ProText").getValue()
		  }   
		)
	});*/
	Prods.load({
		params : {												  //----------ds加载时发送的附加参数
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {          //----------加载完成后执行的回调函数
		}
	});
	Progrid.on("rowclick",function(grid,rowIndex,e){  
	
		var _record = Progrid.getSelectionModel().getSelected();//records[0]
		
		GenDesc= _record.get('PHNDesc');	
		GlPGenDr = _record.get('PHNRowId');
		GlPPointer = "0";
		GlPPointerType="ProName"
		var factory= _record.get('PHNManfDR')  //厂商
		var toxicity= _record.get('PHNToxicity') //毒性
		if (toxicity!=""){
			GenDesc=GenDesc+"（"+toxicity+"）"
		}
		if(factory.indexOf("-") > 0 )
		{
		   factory = factory.split("-")[1];
		}		
		if (factory=="")
		{
			Ext.getCmp("roletitle").el.dom.innerHTML ="<h2 style='color:black;'>"+GenDesc+"</h2>"
		}
		else
		{
			Ext.getCmp("roletitle").el.dom.innerHTML ="<h2 style='color:black; margin-bottom: 1px; margin-top: 2px;'>"+GenDesc+"</h2><h3 style='color:black;margin-top: 2px;background-color: #fff;text-align:center;'>"+factory+"</h3>"
		}
		
		Ext.getCmp("edit_btn").setDisabled(false);
		
		var tabs=Ext.getCmp('main-tabs');
		tabs.removeAll();	
		 ds.load({
			params:{
				'GenDr':GlPGenDr,
				'PointerType':GlPPointerType,
				'PointerDr':GlPPointer,
				start:0,
				limit:10000
			},
			callback: function(records, options, success){
			}
		});
		
    });  
    
				
	/** 授权类别面板 */
	var leftpanel = new Ext.Panel({
			id:'leftpanel',
			region:"west",
			title:"<div style='text-align:center'>类别</div>",
			//autoScroll:true,
			split:true,
			collapsible:true, //自动收缩按钮 
			border:true,
			width:230,
			minSize: 230,
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
			items:[gridWestN,Progrid]
		});
	
	/** ----------------------------------------------------- 以上商品名展示部分 Over -------------------------------------------------------------**/
		
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

	//loadMenu(menuArray,westpanel);
	
	/** 加载菜单 */
	function loadMenu(menuArray,westpanel,GlPPointerType){
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
		            	baseParams : {
		            		SessionStr:"",
		            		countInfo:countInfo,
		            		pointType:GlPPointerType
		            	}
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
	    	var tabId = "tab_"+node.text.split("<")[0];
	    	var obj = Ext.getCmp(tabId);
	    	if (obj){ //判断tab是否已打开
	    		//刷新页面
//	    		var url = node.attributes.myhref;
//	    		var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>";
//	    		obj.update(html);
	    	}else{
	    		//alert(GlPGenDr);
	    		var parm = "&GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType
	    		var url = node.attributes.myhref + parm;
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:node.text.split("<")[0],
	            	tabTip:node.text.split("<")[0],
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
    /** 
  * 定义降序的groupingStore 
  */
var DescGroupingStore = Ext.extend(Ext.data.GroupingStore, { 
groupDir : 'ASC', 
groupBy : function(field, forceRegroup, direction) { 
    direction = direction ? (String(direction).toUpperCase() == 'DESC' ? 'DESC' : 'ASC') : this.groupDir;
    if (this.groupField == field || this.groupDir == direction && !forceRegroup) { 
          return; 
   } 
   this.groupField = field; 
   this.groupDir = direction; 
   if (this.remoteGroup) { 
       if (!this.baseParams) { 
          this.baseParams = {}; 
       } 
       this.baseParams['groupBy'] = field; 
          this.baseParams['groupDir'] = direction; 
       } 
       if (this.groupOnSort) { 
            this.sort(field, direction); 
            return; 
       } 
       if (this.remoteGroup) { 
            this.reload(); 
       } else { 
            var si = this.sortInfo || {}; 
            if (si.field != field || si.direction != direction) { 
                this.applySort(); 
            } else { 
                this.sortData(field, direction); 
            } 
            this.fireEvent('datachanged', this); 
        } 
    }, 
    applySort : function() { 
        Ext.data.GroupingStore.superclass.applySort.call(this); 
        if (!this.groupOnSort && !this.remoteGroup) { 
            if (this.groupField != this.sortInfo.field 
                    || this.groupDir != this.sortInfo.direction) { 
                this.sortData(this.groupField, this.groupDir); 
            } 
        } 
    }, 
    applyGrouping : function(alwaysFireChange) { 
        if (this.groupField !== false) { 
            this.groupBy(this.groupField, true, this.groupDir); 
            return true; 
        } else { 
            if (alwaysFireChange === true) { 
                this.fireEvent('datachanged', this); 
            } 
            return false; 
        } 
    } 
});   

	/** grid数据存储 */
	var ds = new DescGroupingStore({
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
						}, {
							name : 'PHINSTSoft',
							mapping : 'PHINSTSoft',
							type : 'int'
						}, {
							name : 'PHINSTCount',
							mapping : 'PHINSTCount',
							type : 'string'
						}
				]),
		groupDir : 'ASC', 
    	groupField : 'PHINSTSoft', 
		//groupField:'PHINSTGroupDesc',
		sortInfo : {//排序
			 field : 'PHINSTRowId',
			 direction : "ASC"
			}
	});
	
/*	*//*************************调用***************************//*
// 消息列表数据源 
var messageStore = new DescGroupingStore({ 
    proxy : new Ext.data.HttpProxy({ 
        url : "listMessGrid.action"
    }), 
    reader : myReader, 
    groupDir : 'DESC', 
    groupField : 'status', 
    sortInfo : { 
        field : 'id', 
        direction : "DESC"
    } 
}); */
	
		
	/**用于Grid中返回组图片**/
	//蔡昊哲   谷雪萍修改-显示顺序2017-08-29
	ReturnFlagIcon = function(value, meta, record)
	{
		var groupdesc=record.get('PHINSTGroupDesc')
		var returnValue = "";
		switch(groupdesc)
		{
		  case "成分含量(g)":  //"成分含量(g)"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/zzndhl32.png' style='border: 0px'><span style='font-size:24px'>"+"成分含量(g)"+"</span>";
		  break;
		  case "适应证": //"适应证"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/syz32.png' style='border: 0px'><span style='font-size:24px'>"+"适应证"+"</span>";
		  break;
		  case "用法用量":  //"用法用量"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/yfyl32.png' style='border: 0px'><span style='font-size:24px'>"+"用法用量"+"</span>";
		  break;
		  case "溶媒量":  //"溶媒量"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/rml32.png' style='border: 0px'><span style='font-size:24px'>"+"溶媒量"+"</span>";
		  break;
		  case "浓度": //"浓度"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/lcyy32.png' style='border: 0px'><span style='font-size:24px'>"+"浓度"+"</span>";
		  break;
		  case "给药途径":  //"给药途径"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/yyff32.png' style='border: 0px'><span style='font-size:24px'>"+"给药途径"+"</span>";
		  break;		  
		  case "用药频率":  //"用药频率"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/yypl32.png' style='border: 0px'><span style='font-size:24px'>"+"用药频率"+"</span>";
		  break;
		  case "滴速":  //"滴速"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/ds32.png' style='border: 0px'><span style='font-size:24px'>"+"滴速"+"</span>";
		  break;
		  case "不良反应":  //"不良反应"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/blfy32.png' style='border: 0px'><span style='font-size:24px'>"+"不良反应"+"</span>";
		  break;
		  case "禁忌证":  //"禁忌证"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/jjz32.png' style='border: 0px'><span style='font-size:24px'>"+"禁忌证"+"</span>";
		  break;
		  case "配伍禁忌":  //"配伍禁忌"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/jj32.png' style='border: 0px'><span style='font-size:24px'>"+"配伍禁忌"+"</span>";
		  break;
		  case "注意事项":  //"注意事项"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/zysx32.png' style='border: 0px'><span style='font-size:24px'>"+"注意事项"+"</span>";
		  break;		  
		  case "相互作用":  //"相互作用"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/xhzy32.png' style='border: 0px'><span style='font-size:24px'>"+"相互作用"+"</span>";
		  break;
		  case "可配伍药品":  //"可配伍药品"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/ddyy32.png' style='border: 0px'><span style='font-size:24px'>"+"可配伍药品"+"</span>";
		  break;
		  case "联合用药":  //"联合用药"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/lhyy32.png' style='border: 0px'><span style='font-size:24px'>"+"联合用药"+"</span>";
		  break;
		  case "辅助用药个数":  //"辅助用药个数"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/fzyygs32.png' style='border: 0px'><span style='font-size:24px'>"+"辅助用药个数"+"</span>";
		  break;
		  case "重复用药":  //"重复用药"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/cfyy32.png' style='border: 0px'><span style='font-size:24px'>"+"重复用药"+"</span>";
		  break;
		  case "炮制作用":  //"炮制作用"
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/pzzy32.png' style='border: 0px'><span style='font-size:24px'>"+"炮制作用"+"</span>";
		  break;
		  /*case "别称":
		  returnValue = "<img src='"+Ext.BDP.FunLib.Path.URL_Img +"KB/Alias32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
		  break;*/
		  default:  //"其他"
		  returnValue = "<span style='font-size:24px'>"+"其他"+"</span>";
		} 
		return returnValue;
	}	
			
    var grid = new Ext.grid.GridPanel({
        store: ds,
        columns: [
            {id:'PHINSTRowId',header: "PHINSTRowId", width: 60, sortable: true,hidden:true , dataIndex: 'PHINSTRowId'},
            {id:'PHINSTDesc',header: "PHINSTDesc", width: 20, sortable: true, dataIndex: 'PHINSTDesc',
             renderer: function(value, meta, record) { meta.attr = ''; return value; }},
             /*renderer :
             function(v){
            	//alert(v);
                //m.css='x-grid-back-red';  
                //return v;  
                return v;
                //"<span style='font-size:18px'>"+v+"</span>";
            }},*/
            {id:'PHINSTGroupDesc',header: "PHINSTGroupDesc", width: 20, sortable: true,hidden:true, dataIndex: 'PHINSTGroupDesc'/*,
            renderer : ReturnFlagIcon*/},
            {id:'PHINSTSoft',header: "PHINSTSoft", width: 20, sortable: true,dataIndex: 'PHINSTSoft',renderer : ReturnFlagIcon},
            /* function(v){
            	alert(v);
                //m.css='x-grid-back-red';  
                return v;  
                //return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"yes.png' style='border: 0px'";
            }}*/
             {id:'PHINSTCount',header: "PHINSTCount", width: 20, sortable: true,hidden:true ,dataIndex: 'PHINSTCount'}
        ],

        view: new Ext.grid.GroupingView({
        	//sortAscText: "升序",  
        	//sortDescText: "降序",  
       		//columnsText: "表格字段",  
        	//groupByText: "使用当前字段进行分组",  
        	//showGroupsText: "表格分组", 
        	groupOnSort:true,
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
	    		var parm = "&GlPGenDr="+GlPGenDr + "&GlPPointer="+ GlPPointer+ "&GlPPointerType="+ GlPPointerType
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
	    
	 grid.on("rowdblclick",function(grid,rowIndex,e){  //双击功能
        //if (grid.getSelectionModel().getSelected().get('PHINSTGroupDesc')=="别称")return;
	 	var countFreq=0,countPreMet=0,countIndic=0,countUsage=0,countContr=0,countInterEach=0,countTaboo=0,
		countAdvRea=0,countMatNeAt=0,countSolvent=0,countDrgAlone=0,countEleCon=0,countMenstruum=0,countMustDrug=0,countAssDrugNum=0,countRepeat=0,countProcessingAct=0,countDrippingSpeed=0
		var arrFreq=[],arrPreMet=[],arrIndic=[],arrUsage=[],arrContr=[],arrInterEach=[],arrTaboo=[],
		arrAdvRea=[],arrMatNeAt=[],arrSolvent=[],arrDrgAlone=[],arrEleCon=[],arrMenstruum=[],arrMustDrug=[],arrAssDrugNum=[],arrRepeat=[],arrProcessingAct=[],arrDrippingSpeed=[]
		ds.each(function(record) { 
			if (record.get('PHINSTGroupDesc')=='用药频率' ){arrFreq.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='给药途径' ){arrPreMet.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='适应证' ){arrIndic.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='用法用量' ){arrUsage.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='禁忌证' ){arrContr.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='相互作用' ){arrInterEach.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='配伍禁忌' ){arrTaboo.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='不良反应' ){arrAdvRea.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='注意事项' ){arrMatNeAt.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='浓度' ){arrSolvent.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='可配伍药品' ){arrDrgAlone.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='成分含量(g)' ){arrEleCon.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='溶媒量' ){arrMenstruum.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='联合用药' ){arrMustDrug.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='辅助用药个数' ){arrAssDrugNum.push(record.get('PHINSTCount'));}	
			if (record.get('PHINSTGroupDesc')=='重复用药' ){arrRepeat.push(record.get('PHINSTCount'));}
			if (record.get('PHINSTGroupDesc')=='炮制作用' ){arrProcessingAct.push(record.get('PHINSTCount'));}
			if (record.get('PHINSTGroupDesc')=='滴速' ){arrDrippingSpeed.push(record.get('PHINSTCount'));}
		})
		countFreq=arrFreq.length==0?0:Math.max.apply(null,arrFreq)
		countPreMet=arrPreMet.length==0?0:Math.max.apply(null,arrPreMet)
		countIndic=arrIndic.length==0?0:Math.max.apply(null,arrIndic)
		countUsage=arrUsage.length==0?0:Math.max.apply(null,arrUsage)
		countContr=arrContr.length==0?0:Math.max.apply(null,arrContr)
		countInterEach=arrInterEach.length==0?0:Math.max.apply(null,arrInterEach)
		countTaboo=arrTaboo.length==0?0:Math.max.apply(null,arrTaboo)
		countAdvRea=arrAdvRea.length==0?0:Math.max.apply(null,arrAdvRea)
		countMatNeAt=arrMatNeAt.length==0?0:Math.max.apply(null,arrMatNeAt)
		countSolvent=arrSolvent.length==0?0:Math.max.apply(null,arrSolvent);
		countDrgAlone=arrDrgAlone.length==0?0:Math.max.apply(null,arrDrgAlone)
		countEleCon=arrEleCon.length==0?0:Math.max.apply(null,arrEleCon)
		countMenstruum=arrMenstruum.length==0?0:Math.max.apply(null,arrMenstruum)
		countMustDrug=arrMustDrug.length==0?0:Math.max.apply(null,arrMustDrug)
		countAssDrugNum=arrAssDrugNum.length==0?0:Math.max.apply(null,arrAssDrugNum)
		countRepeat=arrRepeat.length==0?0:Math.max.apply(null,arrRepeat)
		countProcessingAct=arrProcessingAct.length==0?0:Math.max.apply(null,arrProcessingAct)
		countDrippingSpeed=arrDrippingSpeed.length==0?0:Math.max.apply(null,arrDrippingSpeed)
		countInfo="用药频率#"+countFreq+"^给药途径#"+countPreMet+"^适应证#"+countIndic+"^用法用量#"+countUsage+"^禁忌证#"+countContr+"^相互作用#"+countInterEach+"^配伍禁忌#"+countTaboo+"^不良反应#"+countAdvRea
		+"^注意事项#"+countMatNeAt+"^浓度#"+countSolvent+"^可配伍药品#"+countDrgAlone+"^成分含量(g)#"+countEleCon+"^溶媒量#"+countMenstruum+"^联合用药#"+countMustDrug+"^辅助用药个数#"+countAssDrugNum+"^重复用药#"+countRepeat+"^炮制作用#"+countProcessingAct+"^滴速#"+countDrippingSpeed
		loadMenu(menuArray,westpanel,GlPPointerType);
	    win.setTitle(GenDesc);
		win.setIconClass('icon-edit');
		win.show('');
		
		var tabs=Ext.getCmp('main-tabs');
		tabs.removeAll();
		
		var _record = grid.getSelectionModel().getSelected();//records[0]
		
		var PHINSTRowId = _record.get('PHINSTRowId');
		var PHINSTGroupDesc = _record.get('PHINSTGroupDesc');
		//alert(_record.get('PHINSTGroupDesc'));
		
		var ruleUrl = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","GetMenuOpen",lib,PHINSTGroupDesc);
		
		gridAddTab(PHINSTGroupDesc,PHINSTGroupDesc,ruleUrl);

            tabs.setActiveTab(0);
	        //加载别名面板
            //AliasGrid.DataRefer = _record.get('CTPCPRowId1');
	        //AliasGrid.loadGrid();
			        
	});	
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 1050,
		height : 500,
		layout:'border',
		//layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		//autoScroll : true,
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
			iconCls : 'icon-ok',
			handler : function() {
				 ds.load({
				params:{
					'GenDr':GlPGenDr,
					'PointerType':GlPPointerType,
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
			"hide" : function(){
				westpanel.removeAll()
			},
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
		x:'10%',
		y:'5%'
		//cls: 'icon-refresh'
	});
	
	var btnEditwin = new Ext.Toolbar.Button({
			text : '<div style="background:url(../scripts/bdp/Framework/imgs/editnew.jpg); width:85px;height:36px;line-height:113px;"></div>',
			tooltip : '编辑药品',
			//iconCls : 'icon-edit',
			disabled : true,
			id:'edit_btn',
			x:'89%',
			y:'10%',
			scale: 'large',
			iconAlign: 'bottom',
   			//renderTo : 'bt',
			//disabled : false,
			handler : function AddData() {
				var countFreq=0,countPreMet=0,countIndic=0,countUsage=0,countContr=0,countInterEach=0,countTaboo=0,
				countAdvRea=0,countMatNeAt=0,countSolvent=0,countDrgAlone=0,countEleCon=0,countMenstruum=0,countMustDrug=0,countAssDrugNum=0,countRepeat=0,countProcessingAct=0,countDrippingSpeed=0
				var arrFreq=[],arrPreMet=[],arrIndic=[],arrUsage=[],arrContr=[],arrInterEach=[],arrTaboo=[],
				arrAdvRea=[],arrMatNeAt=[],arrSolvent=[],arrDrgAlone=[],arrEleCon=[],arrMenstruum=[],arrMustDrug=[],arrAssDrugNum=[],arrRepeat=[],arrProcessingAct=[],arrDrippingSpeed=[]
				ds.each(function(record) { 
					if (record.get('PHINSTGroupDesc')=='用药频率' ){arrFreq.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='给药途径' ){arrPreMet.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='适应证' ){arrIndic.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='用法用量' ){arrUsage.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='禁忌证' ){arrContr.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='相互作用' ){arrInterEach.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='配伍禁忌' ){arrTaboo.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='不良反应' ){arrAdvRea.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='注意事项' ){arrMatNeAt.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='浓度' ){arrSolvent.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='可配伍药品' ){arrDrgAlone.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='成分含量(g)' ){arrEleCon.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='溶媒量' ){arrMenstruum.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='联合用药' ){arrMustDrug.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='辅助用药个数' ){arrAssDrugNum.push(record.get('PHINSTCount'));}	
					if (record.get('PHINSTGroupDesc')=='重复用药' ){arrRepeat.push(record.get('PHINSTCount'));}
					if (record.get('PHINSTGroupDesc')=='炮制作用' ){arrProcessingAct.push(record.get('PHINSTCount'));}
					if (record.get('PHINSTGroupDesc')=='滴速' ){arrDrippingSpeed.push(record.get('PHINSTCount'));}
				})
				countFreq=arrFreq.length==0?0:Math.max.apply(null,arrFreq)
				countPreMet=arrPreMet.length==0?0:Math.max.apply(null,arrPreMet)
				countIndic=arrIndic.length==0?0:Math.max.apply(null,arrIndic)
				countUsage=arrUsage.length==0?0:Math.max.apply(null,arrUsage)
				countContr=arrContr.length==0?0:Math.max.apply(null,arrContr)
				countInterEach=arrInterEach.length==0?0:Math.max.apply(null,arrInterEach)
				countTaboo=arrTaboo.length==0?0:Math.max.apply(null,arrTaboo)
				countAdvRea=arrAdvRea.length==0?0:Math.max.apply(null,arrAdvRea)
				countMatNeAt=arrMatNeAt.length==0?0:Math.max.apply(null,arrMatNeAt)
				countSolvent=arrSolvent.length==0?0:Math.max.apply(null,arrSolvent);
				countDrgAlone=arrDrgAlone.length==0?0:Math.max.apply(null,arrDrgAlone)
				countEleCon=arrEleCon.length==0?0:Math.max.apply(null,arrEleCon)
				countMenstruum=arrMenstruum.length==0?0:Math.max.apply(null,arrMenstruum)
				countMustDrug=arrMustDrug.length==0?0:Math.max.apply(null,arrMustDrug)
				countAssDrugNum=arrAssDrugNum.length==0?0:Math.max.apply(null,arrAssDrugNum)
				countRepeat=arrRepeat.length==0?0:Math.max.apply(null,arrRepeat)
				countProcessingAct=arrProcessingAct.length==0?0:Math.max.apply(null,arrProcessingAct)
				countDrippingSpeed=arrDrippingSpeed.length==0?0:Math.max.apply(null,arrDrippingSpeed)
				countInfo="用药频率#"+countFreq+"^给药途径#"+countPreMet+"^适应证#"+countIndic+"^用法用量#"+countUsage+"^禁忌证#"+countContr+"^相互作用#"+countInterEach+"^配伍禁忌#"+countTaboo+"^不良反应#"+countAdvRea
				+"^注意事项#"+countMatNeAt+"^浓度#"+countSolvent+"^可配伍药品#"+countDrgAlone+"^成分含量(g)#"+countEleCon+"^溶媒量#"+countMenstruum+"^联合用药#"+countMustDrug+"^辅助用药个数#"+countAssDrugNum+"^重复用药#"+countRepeat+"^炮制作用#"+countProcessingAct+"^滴速#"+countDrippingSpeed
				loadMenu(menuArray,westpanel,GlPPointerType);
				win.setTitle(GenDesc);
				win.setIconClass('icon-edit');
				win.show('');
		},
		scope : this
	});
	
	/*var btnEditwin = new Ext.Toolbar.Button({
   text: '<div style="background:url(../scripts/bdp/Framework/imgs/editnew.jpg); width:96px;height:96px;line-height:96px;">编辑</div>',
     // iconCls: 'add',
   scale: 'large',
   x:'85%',
   y:'10%',
   iconAlign: 'bottom',
   renderTo : 'bt'
  });*/
  
/*	var clickHandler = function(){
             
            // 设置跳转
            alert(1);
            //location.href = '#';
             
        }
        
	function AddData() {
		win.setTitle(GenDesc);
		win.setIconClass('icon-edit');
		win.show('');
	}
    
	var btnEditwin = new Ext.BoxComponent({
	id:'edit_btn',
	x:'85%',
	y:'12%',
	disabled : true,
	autoEl: {
	        tag: 'img',
	        src: '../scripts/bdp/Framework/imgs/editnew.jpg',
	        handler : function AddData() {
				win.setTitle(GenDesc);
				win.setIconClass('icon-edit');
				win.show('');
		}
	    }
	});*/


                                
	var np=new Ext.Panel({
		id :"np",
		region:"north",
		border:true,
		layout: 'absolute',
		items:[roletitle,btnEditwin],
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
	
    
    var viewport = new Ext.Viewport({
				layout : 'border',
				items : [leftpanel,center]//显示的内容grid
	});
});

//创建viewport
	


// Array data for the grids
Ext.grid.dummyData = [
	['每隔六小时，每隔8小时', '用药频率'],
	['口服', '用药方法'],
	['葡萄球肺炎', '适应症'],
	['每日5次', '用法用量'],
	['怀孕', '禁忌症'],
	['阿莫西林', '相互作用']
];

// add in some dummy descriptions
/*for(var i = 0; i < Ext.grid.dummyData.length; i++){
    Ext.grid.dummyData[i].push('Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed metus nibh, sodales a, porta at, vulputate eget, dui. Pellentesque ut nisl. Maecenas tortor turpis, interdum non, sodales non, iaculis ac, lacus. Vestibulum auctor, tortor quis iaculis malesuada, libero lectus bibendum purus, sit amet tincidunt quam turpis vel lacus. In pellentesque nisl non sem. Suspendisse nunc sem, pretium eget, cursus a, fringilla vel, urna.<br/><br/>Aliquam commodo ullamcorper erat. Nullam vel justo in neque porttitor laoreet. Aenean lacus dui, consequat eu, adipiscing eget, nonummy non, nisi. Morbi nunc est, dignissim non, ornare sed, luctus eu, massa. Vivamus eget quam. Vivamus tincidunt diam nec urna. Curabitur velit.');
}*/
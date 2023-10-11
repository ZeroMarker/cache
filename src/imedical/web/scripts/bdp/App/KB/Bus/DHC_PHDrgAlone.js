/// 名称:知识库业务表 - 可配伍药品
/// 编写者:基础平台组 - 谷雪萍
/// 编写日期: 2016-10-11
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassQuery=GetList";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDrgAlone";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCPHDrgAlone";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassMethod=DeleteData";
	//var DRG_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassQuery=GetDataForCmb1";
	var CAT_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHMenstruumCat&pClassQuery=GetDataForCmb1";
	
	var QUERY_UnSelDisea_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassQuery=GetUnSelDiseaList";
	var ACTION_URL_Disea = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassQuery=GetDiseaList";
	var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgAlone&pClassMethod=DeleteDiseaData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.form.Field.prototype.msgTarget = 'qtip';                         //--------设置消息提示方式为在下边显示
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
	var PointerType = Ext.BDP.FunLib.getParam("GlPPointerType"); 
	var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","DrgAlone");
	
	var pageSize_pop = Ext.BDP.FunLib.PageSize.Pop;
	var diseaStr="";//2016-08-09
	
	//清空选中的表头全选框checkbox  
	function clearCheckGridHead(grid){  
	  	var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');    
	     var hd = hd_checker.first();   
	     hd.removeClass('x-grid3-hd-checker-on'); 
	 } 
	
	var text = new Array();
	function getStr(text){
		if(text.length<0) return "";
		var str="";
		for (var i = 0 ; i < text.length; i++){
			if(text[i]==undefined){
				text[i]="";
			}
			str=str+text[i];
		}
		return str;
	}
	
	/**************************************商品名多选开始*****************************************/	
/** ---------商品名未选列表内容部分------------* */
	var dsUnSelDisea = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelDisea_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'PHNRowId', mapping:'PHNRowId',type: 'string'},
	  	{ name: 'PHNCode', mapping:'PHNCode',type: 'string'},
        { name: 'PHNDesc', mapping:'PHNDesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelDisea
	});
	dsUnSelDisea.on('beforeload',function(thiz,options){ 
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     diseaStr:diseaStr //2016-08-09
		  }   
		)
	});
	dsUnSelDisea.load({
		params : {
			start : 0,
			limit : pageSize_pop
		},
		callback : function(records, options, success) {
		}
	});
	var UnSelDiseaSearch = new Ext.Button({
		id : 'UnSelDiseaSearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelDisea.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelDiseaText").getValue(),
       			diseaStr:diseaStr //2016-08-09
       		};
			gridUnSelDisea.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_pop
					}
			});
		}
	});	
	var UnSelDiseaRefresh = new Ext.Button({
		id : 'UnSelDiseaRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelDiseaText").reset();                    
			gridUnSelDisea.getStore().baseParams={diseaStr:diseaStr};//2016-08-09
			gridUnSelDisea.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_pop
				}
			});
			clearCheckGridHead(gridUnSelDisea); //重置全选按钮
		}
	});	
	var UnSelDiseaText = new Ext.form.TextField({
		id : 'UnSelDiseaText',
		enableKeyEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelDisea.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelDiseaText").getValue(),
       			diseaStr:diseaStr //2016-08-09
       		};
			gridUnSelDisea.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_pop
					}
				});
	        }
		}						
	})
	
	var UnSelDiseaSave = new Ext.Button({			
				xtype : 'button',
				text : '',
				icon : Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
				id:'UnSelDiseaSave',
				handler : function SaveData() {
					var rs=gridUnSelDisea.getSelectionModel().getSelections();
					if(rs.length==0){
						Ext.Msg.show({
							title : '提示',
							msg : '请选择需要保存的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
					}else{
						var fieldStr = "";
						Ext.each(rs,function(){								
							var _record = new Ext.data.Record({
								'PHDALRowId':'',
								'PHDALDrgDr':this.get('PHNRowId'),
						 		'PHNCode':this.get('PHNCode'),
						 		'PHNDesc':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHNDesc')
						 	});
						 	gridDisea.stopEditing();
						 	dsDisea.insert(0,_record); 
						 	
						 	if (diseaStr!=""){
						 		diseaStr=diseaStr+"^<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHNCode')+">";
						 	}else{
						 		diseaStr="<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHNCode')+">";
						 	}  //2016-08-09
						 	//未选列表删除
						 	//var myrecord=gridUnSelDisea.getSelectionModel().getSelected();
						 	dsUnSelDisea.remove(this);
						 	//页面商品名框显示值
						 	var diseaDescs="";
						    dsDisea.each(function(record){
						    	if(diseaDescs==""){
						    		diseaDescs = record.get('PHNDesc');
						    	}else{
						    		diseaDescs = diseaDescs+","+record.get('PHNDesc');
						    	}
						    }, this);
						    Ext.getCmp("Disea").setValue(diseaDescs);
						    if(diseaDescs!=""){
						   		 text[0]="商品名:"+diseaDescs+";";
						    }else{
						    	text[0]="";
						    }
							//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
							
						})				
					}
				},
				scope : this
			});
	var unSelDiseatb = new Ext.Toolbar({
		id : 'unSelDiseatb',
		items : [UnSelDiseaSearch, UnSelDiseaText,UnSelDiseaRefresh,'->',UnSelDiseaSave]
	});
	var pagingUnSelDisea= new Ext.PagingToolbar({
            pageSize: pageSize_pop,
            store: dsUnSelDisea,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_pop=this.pageSize;
				         }
		        }
        })	
	var smUnSelDisea = new Ext.grid.CheckboxSelectionModel();
    var gridUnSelDisea = new Ext.grid.GridPanel({
		id:'gridUnSelDisea',
		closable:true,
	    store: dsUnSelDisea,
	    split:true,
	    trackMouseOver: true,
	    sm : new Ext.grid.CheckboxSelectionModel,
	    columns: [
	            smUnSelDisea,
	            { header: 'PHNRowId', width: 200, sortable: true, dataIndex: 'PHNRowId',hidden:true }, 
	            { header: '商品名代码', width: 200, sortable: true, dataIndex: 'PHNCode',hidden:true },
	            { header: '商品名描述', width: 200, sortable: true, dataIndex: 'PHNDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : unSelDiseatb, 
		bbar:pagingUnSelDisea,
	    stateId: 'gridUnSelDisea',
	    listeners:{
		    'mousedown':function(e){
				e.ctrlKey =true;
			}	
	    }
	});
	var WinDisea=new Ext.Window({  
        id:'WinDisea',  
        width:240,  
        height:380,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'商品名',  
        items:gridUnSelDisea  
    }); 
	//---商品名
	var PHDISLDisea = new Ext.form.TextField({
		fieldLabel : '商品名',
		name : 'PHDALDrgDr',
		id : 'Disea',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Disea'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Disea')),
		dataIndex:'PHDALDrgDr',
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("Disea").getValue()!=""){
					text[0]="商品名:"+Ext.getCmp("Disea").getValue()+";";
				}else{
					text[0]="";
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));	
			}		
		}
	});
	var BtnDisea = new Ext.Button({
		id : 'btnDisea',  
        text : '...',  
        tooltip : '商品名未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**商品名未选列表加载*/
	        	var InstId="";
			    if(typeof(grid)!="undefined"){
			    	if(grid.getSelectionModel().getCount()!=0){
			    		var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
			    	}
			    }
			    dsUnSelDisea.load({
					params : {
						'InstId':InstId,
						diseaStr:diseaStr, //2016-08-09
						start : 0,
						limit : pageSize_pop
					}
			    });
	        	WinDisea.setPosition(610,0);
	        	WinDisea.show();
	        }  
        }  
	});
		/** ---------商品名维护表单内容部分------------* */
	var dsDisea = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Disea}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'PHDALDrgDr', mapping:'PHDALDrgDr',type: 'string'},
	  	{ name: 'PHNCode', mapping:'PHNCode',type: 'string'},
        { name: 'PHNDesc', mapping:'PHNDesc',type: 'string'},
        { name: 'PHDALRowId', mapping:'PHDALRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsDisea
	});
	dsDisea.on('beforeload',function(thiz,options){ 
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId
		  }   
		)
	});
	dsDisea.load({
		params : {
			start : 0,
			limit : pageSize_pop
		},
		callback : function(records, options, success) {
		}
	});
	var pagingDisea= new Ext.PagingToolbar({
        pageSize: pageSize_pop,
        store: dsDisea,
        displayInfo: true,
        displayMsg: '',
        emptyMsg: "",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_pop=this.pageSize;
			         }
	        }
    });	
	var smDisea = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridDisea = new Ext.grid.GridPanel({
		id:'gridDisea',
		region: 'center',
		title:'商品名明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsDisea,
	    trackMouseOver: true,
	    columns: [
	            smDisea,
	            { header: 'PHDALDrgDr', width: 200, sortable: true, dataIndex: 'PHDALDrgDr',hidden:true },
	            { header: '商品名代码', width: 200, sortable: true, dataIndex: 'PHNCode' },
	            { header: '商品名描述', width: 200, sortable: true, dataIndex: 'PHNDesc' }, 
	            {
				header : '操作',
				dataIndex : 'PHDALRowId',
				align:'center',
				renderer:function (){    
			    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
     				var resultStr = String.format(formatStr);  
     				return '<div class="delBtn">' + resultStr + '</div>';  
			    }.createDelegate(this)
				}],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		bbar:pagingDisea ,
	    stateId: 'gridDisea'
	});
	gridUnSelDisea.on("rowdblclick", function(grid, rowIndex, e){
		var _record = new Ext.data.Record({
			'PHDALRowId':'',
			'PHDALDrgDr':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHNRowId'),
	 		'PHNCode':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHNCode'),
	 		'PHNDesc':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHNDesc')
	 	});
	 	gridDisea.stopEditing();
	 	dsDisea.insert(0,_record); 
	 	
	 	if (diseaStr!=""){
	 		diseaStr=diseaStr+"^<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHNCode')+">";
	 	}else{
	 		diseaStr="<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHNCode')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelDisea.getSelectionModel().getSelected();
	 	dsUnSelDisea.remove(myrecord);
	 	//页面商品名框显示值
	 	var diseaDescs="";
	    dsDisea.each(function(record){
	    	if(diseaDescs==""){
	    		diseaDescs = record.get('PHNDesc');
	    	}else{
	    		diseaDescs = diseaDescs+","+record.get('PHNDesc');
	    	}
	    }, this);
	    Ext.getCmp("Disea").setValue(diseaDescs);
	    if(diseaDescs!=""){
	   		 text[0]="商品名:"+diseaDescs+";";
	    }else{
	    	text[0]="";
	    }
		//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	});
	gridDisea.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 	  if (gridDisea.selModel.hasSelection()) {
	 		var PHDALRowId = gridDisea.getSelectionModel().getSelections()[0].get('PHDALRowId');
	 		if(PHDALRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'PHNRowId':gridDisea.getSelectionModel().getSelections()[0].get('PHDALDrgDr'),
			 		'PHNCode':gridDisea.getSelectionModel().getSelections()[0].get('PHNCode'),
			 		'PHNDesc':gridDisea.getSelectionModel().getSelections()[0].get('PHNDesc')
			 	});
			 	gridUnSelDisea.stopEditing();
			 	dsUnSelDisea.insert(0,_record);
			 	
			 	//已选列表删除
			 	diseaStr=diseaStr.replace("<"+gridDisea.getSelectionModel().getSelections()[0].get('PHNCode')+">","");//2016-08-09
	 			var myrecord=gridDisea.getSelectionModel().getSelected();
			 	
			 	//已选列表删除
			 	diseaStr=diseaStr.replace("<"+gridDisea.getSelectionModel().getSelections()[0].get('PHNCode')+">","");//2016-08-09
	 			var myrecord=gridDisea.getSelectionModel().getSelected();
			 	dsDisea.remove(myrecord);
	 			//页面商品名框显示值
	 			var diseaDescs="";
			    dsDisea.each(function(record){
			    	if(diseaDescs==""){
			    		diseaDescs = record.get('PHNDesc');
			    	}else{
			    		diseaDescs = diseaDescs+","+record.get('PHNDesc');
			    	}
			    }, this);
			    Ext.getCmp("Disea").setValue(diseaDescs);
			    if(diseaDescs!=""){
			   		 text[0]="商品名:"+diseaDescs+";";
			    }else{
			    	text[0]="";
			    }
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	 		}else{
	 			var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
				Ext.Ajax.request({
					url : DELETE_Disea_URL,
					method : 'POST',
					params : {
						'id' : PHDALRowId
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								var startIndex = grid.getBottomToolbar().cursor;
								var totalnum=grid.getStore().getTotalCount();
								if(totalnum==1){   //修改添加后只有一条，返回第一页
									var startIndex=0
								}
								else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
								{
									var pagenum=grid.getStore().getCount();
									if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
								}
								if(gridDisea.getSelectionModel().getCount()!='0'){
									var id = gridDisea.getSelectionModel().getSelections()[0].get('PHDALRowId');
								}
								/**商品名未选列表加载*/
								var _record = new Ext.data.Record({
									'PHNRowId':gridDisea.getSelectionModel().getSelections()[0].get('PHDALDrgDr'),
							 		'PHNCode':gridDisea.getSelectionModel().getSelections()[0].get('PHNCode'),
							 		'PHNDesc':gridDisea.getSelectionModel().getSelections()[0].get('PHNDesc')
							 	});
							 	gridUnSelDisea.stopEditing();
							 	dsUnSelDisea.insert(0,_record);

						        /**商品名明细加载*/
							   var myrecord=gridDisea.getSelectionModel().getSelected();
	 						   dsDisea.remove(myrecord);
	 						   //页面商品名框显示值
								var diseaDescs="";
							    dsDisea.each(function(record){
							    	if(diseaDescs==""){
							    		diseaDescs = record.get('PHNDesc');
							    	}else{
							    		diseaDescs = diseaDescs+","+record.get('PHNDesc');
							    	}
							    }, this);
							    Ext.getCmp("Disea").setValue(diseaDescs);
							    if(diseaDescs!=""){
							   		 text[0]="商品名:"+diseaDescs+";";
							    }else{
							    	text[0]="";
							    }
								//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
							} else {
								var errorMsg = '';
								if (jsonData.info) {
									errorMsg = '<br/>错误信息:' + jsonData.info
								}
								Ext.Msg.show({
										title : '提示',
										msg : '数据删除失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
						} else {
							Ext.Msg.show({
								title : '提示',
								msg : '异步通讯失败,请检查网络连接!',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
						}
					}
				}, this);
	 		}
	 	  }
	 	}
	});
	/**************************************商品名多选结束*****************************************/
	var formSearch = new Ext.form.FormPanel({
				title:'可配伍药品表单',
				id : 'form-save',
				frame:true,
				autoScroll:true,///滚动条
				border:false,
				region: 'center',
				width:500,
				//iconCls:'icon-find',
				plain : true,//true则主体背景透明
				//collapsible:true,
				split: true,
				bodyStyle:'overflow-y:auto;overflow-x:hidden;',
				//baseCls:'x-plain',
				buttonAlign:'center',
				labelAlign : 'right',
				labelWidth : 100,
				reader: new Ext.data.JsonReader({root:'list'},
		                             [
                                        {name: 'PHDALRowId',mapping:'PHDALRowId',type:'string'},
                                        {name: 'PHDALInstDr',mapping:'PHDALInstDr',type:'string'},
                                        {name: 'PHINSTMode',mapping:'PHINSTMode',type:'string'},
                                        {name: 'PHDALDrgDr',mapping:'PHDALDrgDr',type:'string'},
                                        {name: 'PHINSTText',mapping:'PHINSTText',type:'string'},
                                        {name: 'PHDALCatDr',mapping:'PHDALCatDr',type:'string'},
                                        {name: 'PHDALGrpNo',mapping:'PHDALGrpNo',type:'string'},
                                        
                                        {name: 'PHINSTTypeDr',mapping:'PHINSTTypeDr',type:'string'},
                                        {name: 'PHINSTOrderNum',mapping:'PHINSTOrderNum',type:'string'},
                                        {name: 'PHINSTGenDr',mapping:'PHINSTGenDr',type:'string'},
                                        {name: 'PHINSTPointerDr',mapping:'PHINSTPointerDr',type:'string'},
                                        {name: 'PHINSTLibDr',mapping:'PHINSTLibDr',type:'string'},
                                        {name: 'PHINSTPointerType',mapping:'PHINSTPointerType',type:'string'},
                                        {name: 'PHINSTActiveFlag',mapping:'PHINSTActiveFlag',type:'string'},
                                        {name: 'PHINSTSysFlag',mapping:'PHINSTSysFlag',type:'string'}

                                 ]),
		
				items:[{
							fieldLabel : 'PHDALRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHDALRowId'
						},{
							fieldLabel : 'PHDALInstDr',
							hideLabel : 'True',
							hidden : true,
							name : 'PHDALInstDr'
						},{
							xtype : 'combo',
							fieldLabel : '级别',
							name : 'PHINSTMode',
							hiddenName : 'PHINSTMode',
							id:'PHINSTModeF',
							value:mode,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTModeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTModeF')),
							width:300,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							editable: false	,
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['W','警示'],
									      ['C','管控'],
									      ['S','统计']
								     ]
							})
						},{
							fieldLabel:'组号',
							name : 'PHDALGrpNo',
							id:'PHDALGrpNoF',
							xtype : 'textfield',
							width:300,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHDALGrpNoF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHDALGrpNoF'))
						},/*{
							fieldLabel : '商品名',
							hiddenName : 'PHDALDrgDr',
							id:'PHDALDrgDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							emptyText:'请选择',
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHDALDrgDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHDALDrgDrF')),
   							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : DRG_QUERY_ACTION_URL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PHNRowId',mapping:'PHNRowId'},
										{name:'PHNDesc',mapping:'PHNDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'PHNDesc',
							valueField : 'PHNRowId',
							
							enableKeyEvents : true,
                         	validationEvent : 'blur',
                            listeners : {
								'blur' : function(){
									if(Ext.getCmp("PHDALDrgDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("本品可与"+Ext.getCmp("PHDALDrgDrF").getRawValue()+Ext.getCmp("PHDALCatDrF").getRawValue()+"一起用药");
									}
								
								}
                            }
						}*/{
							xtype : 'fieldset',
							title : '商品名',
							width:400,
							autoHeight : true,
							style:'margin-left:32px', 
							items:[{layout : 'column',
							border : false,
							items : [{
									width:340,
									layout : 'form',
									labelWidth : 60,
									labelPad : 1,// 默认5
									border : false,
									style:'margin-left:1px', 
									defaults : {
										anchor : '96%',
										xtype : 'textfield',
										msgTarget : 'under'
									},
									items : [PHDISLDisea]
								},{
									width:20,
									layout : 'form',
									labelWidth : 5,
									labelPad : 1,// 默认5
									border : false,
									defaults : {
										anchor : '96%',
										msgTarget : 'under'
									},
									items : [BtnDisea]
								}]},gridDisea]
						},{
							fieldLabel : '溶媒分类',
							hiddenName : 'PHDALCatDr',
							id:'PHDALCatDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width:300,
							emptyText:'请选择',
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHDALCatDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHDALCatDrF')),
   							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CAT_QUERY_ACTION_URL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PHMCRowId',mapping:'PHMCRowId'},
										{name:'PHMCDesc',mapping:'PHMCDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'PHMCDesc',
							valueField : 'PHMCRowId',
							
							enableKeyEvents : true,
                         	validationEvent : 'blur',
                            listeners : {
								'blur' : function(){
									if(Ext.getCmp("PHDALCatDrF").getValue()!=""){
										////Ext.getCmp("PHINSTTextF").setValue("本品可与"+Ext.getCmp("PHDALDrgDrF").getRawValue()+Ext.getCmp("PHDALCatDrF").getRawValue()+"一起用药");
										text[1]=" 溶媒分类："+Ext.getCmp("PHDALCatDrF").getRawValue()+";";
									}else{
										text[1]="";
									}
								    //Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
                            }
						},{
							fieldLabel : '描述',
							//allowBlank : false,
							xtype : 'textarea',
							name : 'PHINSTText',
							id:'PHINSTTextF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF')),
   							width:300,
   							height : 120
						}
					],
				buttons: [{
					text: '添加',
					width: 100,
					id:'btn_SavePanel',
					iconCls : 'icon-add',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_SavePanel'),
		      		handler: function (){
		      			if(Ext.getCmp("PHINSTTextF").getValue()==""){
		      				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          		return;
		      			}
		      			//病症赋值
		    			var diseastr="";
					    dsDisea.each(function(record){
							if(diseastr==""){
					    		diseastr = record.get('PHDALDrgDr');
					    	}else{
					    		diseastr = diseastr+","+record.get('PHDALDrgDr');
					    	}
					    }, this);
					    
						formSearch.form.submit({
								url : SAVE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
	                                 //主索引表必填项
										//'PHINSTTypeDr' :"9",
										'PHINSTOrderNum' :"1",
										'PHINSTGenDr' :GenDr,
										'PHINSTPointerDr' :PointerDr,
										//'PHINSTLibDr' :"25",
										'PHINSTPointerType':PointerType,
										'PHINSTActiveFlag' :"Y",
										'PHINSTSysFlag' :"Y",
										'PHDALDrgDr':diseastr		
									
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										Ext.Msg.show({
													title : '提示',
													msg : '添加成功！',
													icon : Ext.Msg.INFO,
										
													buttons : Ext.Msg.OK,
														fn : function(btn) {
															grid.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_main
																				}
																			});
															diseaStr=""; //2016-08-09/2016-08-11
															dsUnSelDisea.load({
																params : {
																	'InstId':"",
																	diseaStr:diseaStr, //2016-08-09
																	start : 0,
																	limit : pageSize_pop
																}
															});
															WinDisea.hide();
													        dsDisea.load({
																params : {
																	'InstId':"",
																	start : 0,
																	limit : pageSize_pop
																},
																callback : function(records, options, success) {
																}
														   });
															}
												});
												
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '添加失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '添加失败！');
								}
							})
		      			
		      			
		      			
		      	} 
				},{
					text: '修改',
					width: 100,
					id:'btn_UpdatePanel',
					iconCls : 'icon-update',
					//tooltip : '请选择一行后修改(Shift+D)',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdatePanel'),
					//disabled:true,
		      		handler: function (){	      			
		      		if (grid.selModel.hasSelection()) {
		      			if(Ext.getCmp("PHINSTTextF").getValue()==""){
		      				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
		      			}
		      			//病症赋值
		    			var diseastr="";
					    dsDisea.each(function(record){
					    	if(diseastr==""){
					    		diseastr = record.get('PHDALDrgDr');
					    	}else{
					    		diseastr = diseastr+","+record.get('PHDALDrgDr');
					    	}
					    }, this);
		      			formSearch.form.submit({
								url : UPDATE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
									'PHDALInstDr': checkRowId,
									'PHDALDrgDr':diseastr
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										var myrowid = "rowid=" + action.result.id;
										Ext.Msg.show({
													title : '提示',
													msg : '修改成功！',
													icon : Ext.Msg.INFO,
										
													buttons : Ext.Msg.OK,
														fn : function(btn) {
														   grid.getStore().load({
															   params : {
																	start : 0,
																	limit : pagesize_main
																	}
																});
															diseaStr=""; //2016-08-09/2016-08-11
															dsUnSelDisea.load({
														 		params : {
														 			'InstId':"",
														 			diseaStr:diseaStr, //2016-08-09
																	start : 0,
																	limit : pageSize_pop
														 		}
														 	});
															WinDisea.hide();
													        dsDisea.load({
																params : {
																	'InstId':"",
																	start : 0,
																	limit : pageSize_pop
																},
																callback : function(records, options, success) {
																}
														   });
														}
												});
												
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '修改失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '修改失败！');
								}
							})
		      		}else {
							Ext.Msg.show({
										title : '提示',
										msg : '请选择需要修改的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
						}
		      		} 
		      		
				},{
					text: '删除',
					width: 100,
					//tooltip : '请选择一行后删除(Shift+D)',
					id:'btn_DeletePanel',
					iconCls : 'icon-delete',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_DeletePanel'),
					//disabled : true,
		      		handler : function DelData() {
						if (grid.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
									Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									
									Ext.Ajax.request({
										url : DELETE_ACTION_URL,
										method : 'POST',
										params : {
											'id' : rows[0].get('PHINSTRowId')
										},
										callback : function(options, success, response) {
											if (success) {
												var jsonData = Ext.util.JSON.decode(response.responseText);
												if (jsonData.success == 'true') {
													Ext.getCmp("form-save").getForm().reset();
													Ext.Msg.show({
														title : '提示',
														msg : '数据删除成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															var startIndex = grid.getBottomToolbar().cursor;
															var totalnum=grid.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
															{
																var pagenum=grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															grid.getStore().load({
																		params : {
																			start : startIndex,
																			limit : pagesize_main
																		}
																	});
															diseaStr=""; //2016-08-09/2016-08-11
															dsUnSelDisea.load({
															params : {
																'InstId':"",
																diseaStr:diseaStr, //2016-08-09
																start : 0,
																limit : pageSize_pop
															}
															});
															WinDisea.hide();
													        dsDisea.load({
																params : {
																	'InstId':"",
																	start : 0,
																	limit : pageSize_pop
																},
																callback : function(records, options, success) {
																}
														   });
														}
													});
												} else {
													var errorMsg = '';
													if (jsonData.info) {
														errorMsg = '<br/>错误信息:' + jsonData.info
													}
													Ext.Msg.show({
																title : '提示',
																msg : '数据删除失败!' + errorMsg,
																minWidth : 200,
																icon : Ext.Msg.ERROR,
																buttons : Ext.Msg.OK
															});
												}
											} else {
												Ext.Msg.show({
															title : '提示',
															msg : '异步通讯失败,请检查网络连接!',
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
											}
										}
									}, this);
								}
							}, this);
						} else {
							Ext.Msg.show({
										title : '提示',
										msg : '请选择需要删除的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
						}
					}  		
				},
				{
					text: '重置',
					width: 100,
					id:'btn_RefreshPanel',
					iconCls : 'icon-refresh',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshPanel'),
		      		handler: function (){
		      			Ext.getCmp("form-save").getForm().reset();	
		      			grid.getStore().baseParams={
		      				TypeDr : "",
							GenDr: GenDr,
							PointerType:PointerType,
							PointerDr:PointerDr
		      			};
						grid.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
						diseaStr=""; //2016-08-09/2016-08-11
						dsUnSelDisea.load({
							params : {
								'InstId':"",
								diseaStr:diseaStr, //2016-08-09
								start : 0,
								limit : pageSize_pop
							}
						});
						WinDisea.hide();
				        dsDisea.load({
							params : {
								'InstId':"",
								start : 0,
								limit : pageSize_pop
							},
							callback : function(records, options, success) {
							}
					   });
						}	
						
				}]
	});
	
    
   /** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'PHINSTRowId',
									mapping : 'PHINSTRowId',
									type : 'string'
								}, {
									name : 'PHINSTText',
									mapping : 'PHINSTText',
									type : 'string'
								}// 列的映射
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : ds
					});
	ds.baseParams={			
					TypeDr : "",
					GenDr: GenDr, 
					PointerType:PointerType,
					PointerDr:PointerDr 
				};
	/** grid加载数据 */
	ds.load({
				params : {
					start : 0,
					limit : pagesize_main
				},
				callback : function(records, options, success) {
				}
			});

	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_main=this.pageSize;
					}
				}
			});

	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'west',
				closable : true,
				store : ds,
				trackMouseOver : true,
        		stripeRows: true,
        		split:true,
        		enableColumnMove: true,     //允许拖放列
	    		enableColumnResize: false,  //禁止改变列的宽度
        		autoScroll: true,
				title : '可配伍药品',
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PHINSTRowId',
							sortable : true,
							dataIndex : 'PHINSTRowId',
							hidden : true
						},{
							header : '描述',
							sortable : true,
							dataIndex : 'PHINSTText'
						}],
				width:200,
        		viewConfig: {
					forceFit: true //自动延展每列的长度//若为ture,column里面设置的无效,autoExpandColumn不起作用
		   		 },
		   		columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				//tbar : tb,
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
	/** grid单击事件 */
	grid.on("rowclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				checkRowId= _record.get('PHINSTRowId')
				if (!_record) {
					//Ext.getCmp("btn_DeletePanel").setDisabled(true);
		        	//Ext.getCmp("btn_UpdatePanel").setDisabled(true);
		
		        } else {
		        	//Ext.getCmp("btn_DeletePanel").setDisabled(false);
		        	//Ext.getCmp("btn_UpdatePanel").setDisabled(false);
		        	var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHINSTRowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		            
		            diseaStr=""; //2016-08-09
			        dsUnSelDisea.load({
						params : {
							'InstId':InstId,
							diseaStr:diseaStr, //2016-08-09
							start : 0,
							limit : pageSize_pop
						}
				   });
			        /**病症明细加载*/
			        dsDisea.load({
						params : {
							'InstId':InstId,
							start : 0,
							limit : pageSize_pop
						},
						callback : function(records, options, success) {
						}
				   });
		        }
			});
	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [formSearch,grid]
    });
	
	});
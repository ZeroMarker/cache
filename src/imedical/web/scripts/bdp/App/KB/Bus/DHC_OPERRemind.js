/// 名称:知识库业务表 - 高危提醒
/// 编写者:基础平台组 - 高姗姗
/// 编写日期:2017-4-11
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/MultiSelect.js"> </script>');
//document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/multiselect.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCOPERRemind&pClassQuery=GetList";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCOPERRemind&pClassMethod=OpenRemindData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCOPERRemind&pClassMethod=SaveRemindData&pEntityName=web.Entity.KB.DHCOPERRemind";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCOPERRemind&pClassMethod=UpdateRemindData&pEntityName=web.Entity.KB.DHCOPERRemind";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCOPERRemind&pClassMethod=DeleteData";
	//var Dis_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassQuery=GetDataForCmb1";
	var Age_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmb1";
	var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";
	var QUERY_UnSelDisea_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassQuery=GetUnSelDiseaList";
	var ACTION_URL_Disea = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDisease&pClassQuery=GetDiseaList";
	var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDisease&pClassMethod=DeleteDiseaData";
	var UOM_DR_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmbYMD";
		//特殊人群
	var PopuStr="" //2017-04-01
	var QUERY_UnSelPopu_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopu&pClassQuery=GetUnSelPopuList";
	var ACTION_URL_Popu = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLibSpecPopuItm&pClassQuery=GetPopuList";
	var DELETE_Popu_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLibSpecPopuItm&pClassMethod=DeletePopuData";
	var pageSize_Popu = Ext.BDP.FunLib.PageSize.Pop;
	
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pageSize_Disea = Ext.BDP.FunLib.PageSize.Pop;
	Ext.form.Field.prototype.msgTarget = 'qtip';                         //--------设置消息提示方式为在下边显示
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
	var diseaStr="";//2016-08-09
	
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
/*		//---特殊人群
	var CheckboxItems = [];  
	var SpecJson = tkMakeServerCall("web.DHCBL.KB.DHCSpecialPopu","GetSpecJson","","");
	var Spec = SpecJson.split(",");
	var strSpec="";
	for (var i = 0; i < Spec.length-1; i++) {    
        var popu = Spec[i];    
        var box = popu.split("^");
        CheckboxItems.push({    
            boxLabel :box[1],    
            name : "SpecialPopu",
            inputValue : box[0],
            listeners: {
                   'change': function (cb, nv, ov) {
            			if(cb.getValue()==true){
            				if(strSpec==""){
            					strSpec=cb.boxLabel
            				}else{
            					strSpec=strSpec+","+cb.boxLabel
            				}
             			}
             			if(strSpec!=""){
             				text[6] =strSpec+";";
             			}else{
             				text[6] ="";
             			}
             			//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
                  }
            }
         }); 
	}
	if(Spec.length-1==0){
		 CheckboxItems.push({})
	}
	var SpecialPopu=new Ext.BDP.FunLib.Component.CheckboxGroup({
		fieldLabel : '特殊人群',
		name : 'SpecialPopu',
		id : 'Popu',
		columns: 3,
		width:400,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Popu'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Popu')),
		items : CheckboxItems
	});
	if(Spec.length-1==0){
		Ext.getCmp('Popu').hidden=true
	}
	*/
		/********************************* ---------特殊人群表单内容部分开始------------*********************************************** */
	/** ---------特殊人群未选列表内容部分------------* */
	var dsUnSelPopu = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelPopu_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'SPERowId', mapping:'SPERowId',type: 'string'},
	  	{ name: 'SPECode', mapping:'SPECode',type: 'string'},
        { name: 'SPEDesc', mapping:'SPEDesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelPopu
	});
	dsUnSelPopu.on('beforeload',function(thiz,options){
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     PopuStr:PopuStr //2016-08-09
		  }   
		)
	});
	dsUnSelPopu.load({
		params : {
			start : 0,
			limit : pageSize_Popu
		},
		callback : function(records, options, success) {
		}
	});
	var UnSelPopuSearch = new Ext.Button({
		id : 'UnSelPopuSearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelPopu.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelPopuText").getValue(),
       			PopuStr:PopuStr //2016-08-09
       		};
			gridUnSelPopu.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Popu
					}
			});
		}
	});	
	var UnSelPopuRefresh = new Ext.Button({
		id : 'UnSelPopuRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelPopuText").reset();                    
			gridUnSelPopu.getStore().baseParams={PopuStr:PopuStr};//2016-08-09
			gridUnSelPopu.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_Popu
				}
			});
		}
	});	
	var UnSelPopuText = new Ext.BDP.FunLib.Component.TextField({
		id : 'UnSelPopuText',
		enableKeyEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelPopu.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelPopuText").getValue(),
       			PopuStr:PopuStr //2016-08-09
       		};
			gridUnSelPopu.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Popu
					}
				});
	        }
		}						
	})
	var unSelPoputb = new Ext.Toolbar({
		id : 'unSelPoputb',
		items : [UnSelPopuSearch, UnSelPopuText, '->' ,UnSelPopuRefresh]
	});
	var pagingUnSelPopu= new Ext.PagingToolbar({
            pageSize: pageSize_Popu,
            store: dsUnSelPopu,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_Popu=this.pageSize;
				         }
		        }
        })	
	var smUnSelPopu = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelPopu = new Ext.grid.GridPanel({
		id:'gridUnSelPopu',
		closable:true,
	    store: dsUnSelPopu,
	    trackMouseOver: true,
	    columns: [
	            smUnSelPopu,
	            { header: 'SPERowId', width: 200, sortable: true, dataIndex: 'SPERowId',hidden:true }, 
	            { header: '特殊人群代码', width: 200, sortable: true, dataIndex: 'SPECode',hidden:true },
	            { header: '特殊人群描述', width: 200, sortable: true, dataIndex: 'SPEDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : unSelPoputb, 
		bbar:pagingUnSelPopu,
	    stateId: 'gridUnSelPopu'
	});
	var WinPopu=new Ext.Window({  
        id:'WinPopu',  
        width:240,  
        height:360,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'特殊人群',  
        items:gridUnSelPopu  
    }); 
	//---特殊人群
	var SpecialPopu = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '特殊人群',
		name : 'SpecialPopu',
		id : 'Popu',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Popu'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Popu')),
		dataIndex:'SpecialPopu'
	});
	var BtnPopu = new Ext.Button({
		id : 'btnPopu',  
        text : '...',  
        tooltip : '特殊人群未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**特殊人群未选列表加载*/
			    var InstId="";
			    if(typeof(grid)!="undefined"){
			    	if(grid.getSelectionModel().getCount()!=0){
			    		var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
			    	}
			    }
			    dsUnSelPopu.load({
					params : {
						'InstId':InstId,
						PopuStr:PopuStr, //2016-08-09
						start : 0,
						limit : pageSize_Popu
					}
			    });
	        	WinPopu.setPosition(620,0);
	        	WinPopu.show();
	        }  
        }  
	});
	
	
	var dsPopu = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Popu}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'SPEPISpecDr', mapping:'SPEPISpecDr',type: 'string'},
	  	{ name: 'SPECode', mapping:'SPECode',type: 'string'},
        { name: 'SPEDesc', mapping:'SPEDesc',type: 'string'},
        { name: 'SPEPIRowId', mapping:'SPEPIRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsPopu
	});
	dsPopu.on('beforeload',function(thiz,options){ 
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
	dsPopu.load({
		params : {
			start : 0,
			limit : pageSize_Popu
		},
		callback : function(records, options, success) {
		}
	});
	var pagingPopu= new Ext.PagingToolbar({
        pageSize: pageSize_Popu,
        store: dsPopu,
        displayInfo: true,
        displayMsg: '',//显示第 {0} 条到 {1} 条记录，一共 {2} 条
        emptyMsg: "",//没有记录
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_Popu=this.pageSize;
			         }
	        }
    });	
	var smPopu = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridPopu = new Ext.grid.GridPanel({
		id:'gridPopu',
		region: 'center',
		title:'特殊人群明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsPopu,
	    trackMouseOver: true,
	    columns: [
	            smPopu,
	            { header: 'SPEPISpecDr', width: 200, sortable: true, dataIndex: 'SPEPISpecDr',hidden:true },
	            { header: 'SPEPIRowId', width: 200, sortable: true, dataIndex: 'SPEPIRowId',hidden:true },
	            { header: '特殊人群代码', width: 200, sortable: true, dataIndex: 'SPECode' },
	            { header: '特殊人群描述', width: 200, sortable: true, dataIndex: 'SPEDesc' }, 
	            {
				header : '操作',
				dataIndex : 'SPEPIRowId',
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
		bbar:pagingPopu ,
	    stateId: 'gridPopu'
	});
	gridUnSelPopu.on("rowdblclick", function(grid, rowIndex, e){
		//已选列表新增
		var _record = new Ext.data.Record({
			'SPEPIRowId':'',
			'SPEPISpecDr':gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPERowId'),
	 		'SPECode':gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPECode'),
	 		'SPEDesc':gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPEDesc')
	 	});
	 	gridPopu.stopEditing();
	 	dsPopu.insert(0,_record); 	
	 	
	 	if (PopuStr!=""){
	 		PopuStr=PopuStr+"^<"+gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPECode')+">";
	 	}else{
	 		PopuStr="<"+gridUnSelPopu.getSelectionModel().getSelections()[0].get('SPECode')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelPopu.getSelectionModel().getSelected();
	 	dsUnSelPopu.remove(myrecord);
	 	//页面特殊人群框显示值
	 	var PopuDescs="";
	    dsPopu.each(function(record){
	    	if(PopuDescs==""){
	    		PopuDescs = record.get('SPEDesc');
	    	}else{
	    		PopuDescs = PopuDescs+","+record.get('SPEDesc');
	    	}
	    }, this);
	    Ext.getCmp("Popu").setValue(PopuDescs);
		if(PopuDescs!=""){
	   		 text[6]="特殊人群:"+PopuDescs+"。";
	    }else{
	    	text[6]="";
	    }
		//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	});
	gridPopu.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 		var SPEPIRowId = gridPopu.getSelectionModel().getSelections()[0].get('SPEPIRowId');
	 		if(SPEPIRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'SPERowId':gridPopu.getSelectionModel().getSelections()[0].get('SPEPIRowId'),
			 		'SPECode':gridPopu.getSelectionModel().getSelections()[0].get('SPECode'),
			 		'SPEDesc':gridPopu.getSelectionModel().getSelections()[0].get('SPEDesc')
			 	});
			 	gridUnSelPopu.stopEditing();
			 	dsUnSelPopu.insert(0,_record);
			 	
			 	//已选列表删除
			 	PopuStr=PopuStr.replace("<"+gridPopu.getSelectionModel().getSelections()[0].get('SPECode')+">","");//2016-08-09
	 			var myrecord=gridPopu.getSelectionModel().getSelected();
			 	dsPopu.remove(myrecord);
	 			//页面特殊人群框显示值
	 			var PopuDescs="";
			    dsPopu.each(function(record){
			    	if(PopuDescs==""){
			    		PopuDescs = record.get('SPEDesc');
			    	}else{
			    		PopuDescs = PopuDescs+","+record.get('SPEDesc');
			    	}
			    }, this);
			    Ext.getCmp("Popu").setValue(PopuDescs);
				if(PopuDescs!=""){
			   		 text[6]="特殊人群:"+PopuDescs+"。";
			    }else{
			    	text[6]="";
			    }
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	 		}else{
	 			var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
				Ext.Ajax.request({
					url : DELETE_Popu_URL,
					method : 'POST',
					params : {
						'id' : SPEPIRowId
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
								if(gridPopu.getSelectionModel().getCount()!='0'){
									var id = gridPopu.getSelectionModel().getSelections()[0].get('SPEPIRowId');
								}
								/**特殊人群未选列表加载*/
							    var _record = new Ext.data.Record({
									'SPERowId':gridPopu.getSelectionModel().getSelections()[0].get('SPEPISpecDr'),
							 		'SPECode':gridPopu.getSelectionModel().getSelections()[0].get('SPECode'),
							 		'SPEDesc':gridPopu.getSelectionModel().getSelections()[0].get('SPEDesc')
							 	});
							 	gridUnSelPopu.stopEditing();
							 	dsUnSelPopu.insert(0,_record);
						        /**特殊人群明细加载*/
							   var myrecord=gridPopu.getSelectionModel().getSelected();
	 						   dsPopu.remove(myrecord);
	 						   //页面特殊人群框显示值
								var PopuDescs="";
							    dsPopu.each(function(record){
							    	if(PopuDescs==""){
							    		PopuDescs = record.get('SPEDesc');
							    	}else{
							    		PopuDescs = PopuDescs+","+record.get('SPEDesc');
							    	}
							    }, this);
							    Ext.getCmp("Popu").setValue(PopuDescs);
							    if(PopuDescs!=""){
							   		 text[6]="特殊人群:"+PopuDescs+"。";
							    }else{
							    	text[6]="";
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
	});
	//刷新特殊人群列表
	function RefreshPopuGrid(inst,str)
	{
		/**病特殊人群未选列表加载*/   
		dsUnSelPopu.load({
			params : {
				'InstId':inst,
				PopuStr:PopuStr,
				start : 0,
				limit : pageSize_Popu
			}
		});
		WinPopu.hide();
		/**特殊人群明细加载*/
        dsPopu.load({
			params : {
				'InstId':inst,
				start : 0,
				limit : pageSize_Popu
			},
			callback : function(records, options, success) {
			}
	   });
	}
/********************************* ---------特殊人群表单内容部分结束------------*********************************************** */
/**************************************病症多选开始*****************************************/	
/** ---------病症未选列表内容部分------------* */
	var dsUnSelDisea = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelDisea_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'PHDISLRowId', mapping:'PHDISLRowId',type: 'string'},
	  	{ name: 'PHDISLDiseaCode', mapping:'PHDISLDiseaCode',type: 'string'},
        { name: 'PHDISLDiseaDesc', mapping:'PHDISLDiseaDesc',type: 'string'}
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
			limit : pageSize_Disea
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
					limit : pageSize_Disea
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
					limit : pageSize_Disea
				}
			});
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
					limit : pageSize_Disea
					}
				});
	        }
		}						
	})
	var unSelDiseatb = new Ext.Toolbar({
		id : 'unSelDiseatb',
		items : [UnSelDiseaSearch, UnSelDiseaText, '->' ,UnSelDiseaRefresh]
	});
	var pagingUnSelDisea= new Ext.PagingToolbar({
            pageSize: pageSize_Disea,
            store: dsUnSelDisea,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_Disea=this.pageSize;
				         }
		        }
        })	
	var smUnSelDisea = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelDisea = new Ext.grid.GridPanel({
		id:'gridUnSelDisea',
		closable:true,
	    store: dsUnSelDisea,
	    trackMouseOver: true,
	    columns: [
	            smUnSelDisea,
	            { header: 'PHDISLRowId', width: 200, sortable: true, dataIndex: 'PHDISLRowId',hidden:true }, 
	            { header: '病症代码', width: 200, sortable: true, dataIndex: 'PHDISLDiseaCode',hidden:true },
	            { header: '病症描述', width: 200, sortable: true, dataIndex: 'PHDISLDiseaDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : unSelDiseatb, 
		bbar:pagingUnSelDisea,
	    stateId: 'gridUnSelDisea'
	});
	var WinDisea=new Ext.Window({  
        id:'WinDisea',  
        width:240,  
        height:380,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'病症',  
        items:gridUnSelDisea  
    }); 
	//---病症
	var PHDISLDisea = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '病症',
		name : 'PHDDDiseaDr',
		id : 'Disea',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Disea'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Disea')),
		dataIndex:'PHDDDiseaDr',
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("Disea").getValue()!=""){
					text[0]="病症:"+Ext.getCmp("Disea").getValue()+";";
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
        tooltip : '病症未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**病症未选列表加载*/
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
						limit : pageSize_Disea
					}
			    });
	        	WinDisea.setPosition(610,0);
	        	WinDisea.show();
	        }  
        }  
	});
		/** ---------病症维护表单内容部分------------* */
	var dsDisea = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Disea}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'PHDDDiseaDr', mapping:'PHDDDiseaDr',type: 'string'},
	  	{ name: 'PHDISLDiseaCode', mapping:'PHDISLDiseaCode',type: 'string'},
        { name: 'PHDISLDiseaDesc', mapping:'PHDISLDiseaDesc',type: 'string'},
        { name: 'PHDDRowId', mapping:'PHDDRowId',type: 'string'}
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
			limit : pageSize_Disea
		},
		callback : function(records, options, success) {
		}
	});
	var pagingDisea= new Ext.PagingToolbar({
        pageSize: pageSize_Disea,
        store: dsDisea,
        displayInfo: true,
        displayMsg: '',
        emptyMsg: "",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_Disea=this.pageSize;
			         }
	        }
    });	
	var smDisea = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridDisea = new Ext.grid.GridPanel({
		id:'gridDisea',
		region: 'center',
		title:'病症明细',
		width:390,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsDisea,
	    trackMouseOver: true,
	    columns: [
	            smDisea,
	            { header: 'PHDDDiseaDr', width: 200, sortable: true, dataIndex: 'PHDDDiseaDr',hidden:true },
	            { header: 'PHDDRowId', width: 200, sortable: true, dataIndex: 'PHDDRowId',hidden:true },
	            { header: '病症代码', width: 200, sortable: true, dataIndex: 'PHDISLDiseaCode' },
	            { header: '病症描述', width: 200, sortable: true, dataIndex: 'PHDISLDiseaDesc' }, 
	            {
				header : '操作',
				dataIndex : 'PHDDRowId',
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
			'PHDDRowId':'',
			'PHDDDiseaDr':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLRowId'),
	 		'PHDISLDiseaCode':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode'),
	 		'PHDISLDiseaDesc':gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')
	 	});
	 	gridDisea.stopEditing();
	 	dsDisea.insert(0,_record); 
	 	if (diseaStr!=""){
	 		diseaStr=diseaStr+"^<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode')+">";
	 	}else{
	 		diseaStr="<"+gridUnSelDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelDisea.getSelectionModel().getSelected();
	 	dsUnSelDisea.remove(myrecord);
	 	//页面病症框显示值
	 	var diseaDescs="";
	    dsDisea.each(function(record){
	    	if(diseaDescs==""){
	    		diseaDescs = record.get('PHDISLDiseaDesc');
	    	}else{
	    		diseaDescs = diseaDescs+","+record.get('PHDISLDiseaDesc');
	    	}
	    }, this);
	    Ext.getCmp("Disea").setValue(diseaDescs);
	    if(diseaDescs!=""){
	   		 text[0]="病症:"+diseaDescs+";";
	    }else{
	    	text[0]="";
	    }
		//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	});
	gridDisea.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 	  if (gridDisea.selModel.hasSelection()) {
	 		var PHDDRowId = gridDisea.getSelectionModel().getSelections()[0].get('PHDDRowId');
	 		if(PHDDRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'PHDISLRowId':gridDisea.getSelectionModel().getSelections()[0].get('PHDDDiseaDr'),
			 		'PHDISLDiseaCode':gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode'),
			 		'PHDISLDiseaDesc':gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')
			 	});
			 	gridUnSelDisea.stopEditing();
			 	dsUnSelDisea.insert(0,_record);
			 	//已选列表删除
			 	diseaStr=diseaStr.replace("<"+gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode')+">","");//2016-08-09
	 			var myrecord=gridDisea.getSelectionModel().getSelected();
			 	dsDisea.remove(myrecord);
	 			//页面病症框显示值
	 			var diseaDescs="";
			    dsDisea.each(function(record){
			    	if(diseaDescs==""){
			    		diseaDescs = record.get('PHDISLDiseaDesc');
			    	}else{
			    		diseaDescs = diseaDescs+","+record.get('PHDISLDiseaDesc');
			    	}
			    }, this);
			    Ext.getCmp("Disea").setValue(diseaDescs);
			    if(diseaDescs!=""){
			   		 text[0]="病症:"+diseaDescs+";";
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
						'id' : PHDDRowId
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
									var id = gridDisea.getSelectionModel().getSelections()[0].get('PHDDRowId');
								}
								/**病症未选列表加载*/
								var _record = new Ext.data.Record({
									'PHDISLRowId':gridDisea.getSelectionModel().getSelections()[0].get('PHDDDiseaDr'),
							 		'PHDISLDiseaCode':gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaCode'),
							 		'PHDISLDiseaDesc':gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')
							 	});
							 	gridUnSelDisea.stopEditing();
							 	dsUnSelDisea.insert(0,_record);

						        /**病症明细加载*/
							   var myrecord=gridDisea.getSelectionModel().getSelected();
	 						   dsDisea.remove(myrecord);
	 						   //页面病症框显示值
								var diseaDescs="";
							    dsDisea.each(function(record){
							    	if(diseaDescs==""){
							    		diseaDescs = record.get('PHDISLDiseaDesc');
							    	}else{
							    		diseaDescs = diseaDescs+","+record.get('PHDISLDiseaDesc');
							    	}
							    }, this);
							    Ext.getCmp("Disea").setValue(diseaDescs);
							    if(diseaDescs!=""){
							   		 text[0]="病症:"+diseaDescs+";";
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
	/**************************************病症多选结束*****************************************/
	//---年龄最小值
	var AgeMinVal= new Ext.BDP.FunLib.Component.NumberField({ 
		fieldLabel : '年龄限制',
		name : 'PDAMinVal',
		id : 'PDAMinValF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDAMinValF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDAMinValF')),
		dataIndex : 'PDAMinVal',
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是数字',
		listeners : {
			'blur' : function(){
					if(Ext.getCmp("PDAMinValF").getValue()!=""){
						text[2]="年龄"+Ext.getCmp("PDAMinValF").getValue();			
					}else{
						text[2]="";
					}
					//Ext.getCmp("PHINSTTextF").setValue(getStr(text));	
			}
		}	
	});
	//---年龄最大值
	var AgeMaxVal= new Ext.form.NumberField({ 
		name : 'PDAMaxVal',
		id : 'PDAMaxValF',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDAMaxValF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDAMaxValF')),
		dataIndex : 'PDAMaxVal',
		minValue : 0,
		minText : '不能小于0',
		nanText : '只能是数字',
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("PDAMaxValF").getValue()!=""){
					text[3]="-"+Ext.getCmp("PDAMaxValF").getValue()
				}else{
					text[3]=""
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
			}
		}	
	});
	//---单位
	var UomDesc= new Ext.form.ComboBox({	
		xtype : 'combo',
		//pageSize : Ext.BDP.FunLib.PageSize.Combo,
		loadByIdParam : 'rowid',
		listWidth:100,				
		hiddenName : 'PDAUomDr',
		name:'PDAUomDr',
		id : 'PDAUomDrF',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('PDAUomDrF'),
		store : new Ext.data.Store({		
					autoLoad: true,
					proxy : new Ext.data.HttpProxy({ url : UOM_DR_QUERY_ACTION_URL }),
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
					}, [{ name:'PHEURowId',mapping:'PHEURowId'},
						{name:'PHEUDesc',mapping:'PHEUDesc'} ])
				}),
		mode : 'local',
		shadow:false,
		queryParam : 'desc',
		forceSelection : true,
		selectOnFocus : false,
		triggerAction : 'all',
		displayField : 'PHEUDesc',
		valueField : 'PHEURowId',
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("PDAUomDrF").getValue()!=""){
					text[4]=Ext.getCmp("PDAUomDrF").getRawValue()+";"
				}else{
					text[4]=""
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
			}
		}	
	});
		
	//---BMI最小值
	var PHINSTBMIMin= new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : 'BMI',
		name : 'PHINSTBMIMin',
		id : 'PHINSTBMIMin',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTBMIMin'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTBMIMin')),
		dataIndex : 'PHINSTBMIMin'
	});
	//---BMI最大值
	var PHINSTBMIMax= new Ext.BDP.FunLib.Component.TextField({ 
		name : 'PHINSTBMIMax',
		id : 'PHINSTBMIMax',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTBMIMax'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTBMIMax')),
		dataIndex : 'PHINSTBMIMax'
	});				
	var formSearch = new Ext.form.FormPanel({
				title:'高危提醒表单',
				id : 'form-save',
				frame:true,
				autoScroll:true,///滚动条
				border:false,
				region: 'center',
				width:500,
				//iconCls:'icon-find',
				plain : true,//true则主体背景透明
				//collapsible:true,
				bodyStyle:'overflow-y:auto;overflow-x:hidden;',
				//bodyStyle:'padding:5px 5px 0',
				//baseCls:'x-plain',
				buttonAlign:'center',
				labelAlign : 'right',
				labelWidth : 100,
				reader: new Ext.data.JsonReader({root:'list'},
		                             [
                                        {name: 'PHDDRowId',mapping:'PHDDRowId',type:'string'},
                                        {name: 'PHDDInstDr',mapping:'PHDDInstDr',type:'string'},
                                        {name: 'PHDDDiseaDr',mapping:'PHDDDiseaDr',type:'string'},
                                        {name: 'PDAAgeDr',mapping:'PDAAgeDr',type:'string'},
                                        {name: 'PHINSTText',mapping:'PHINSTText',type:'string'},
                                        {name: 'PHINSTBMIMin',mapping:'PHINSTBMIMin',type:'string'},
                                        {name: 'PHINSTBMIMax',mapping:'PHINSTBMIMax',type:'string'},
                                        
                                        {name: 'PHINSTTypeDr',mapping:'PHINSTTypeDr',type:'string'},
                                        {name: 'PHINSTOrderNum',mapping:'PHINSTOrderNum',type:'string'},
                                        {name: 'PHINSTGenDr',mapping:'PHINSTGenDr',type:'string'},
                                        {name: 'PHINSTPointerDr',mapping:'PHINSTPointerDr',type:'string'},
                                        {name: 'PHINSTLibDr',mapping:'PHINSTLibDr',type:'string'},
                                        {name: 'PHINSTPointerType',mapping:'PHINSTPointerType',type:'string'},
                                        {name: 'PHINSTActiveFlag',mapping:'PHINSTActiveFlag',type:'string'},
                                        {name: 'PHINSTSysFlag',mapping:'PHINSTSysFlag',type:'string'},
                                        
                                        {name : 'SpecialPopu',mapping : 'SpecialPopu',type : 'string'},//特殊人群
                                        {name: 'PDAMinVal',mapping:'PDAMinVal',type:'string'},
                                        {name: 'PDAMaxVal',mapping:'PDAMaxVal',type:'string'},
                                        {name: 'PDAUomDr',mapping:'PDAUomDr',type:'string'}
                                        
                                 ]),
		
				items:[{
							fieldLabel : 'PHDDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHDDRowId'
						},{
							fieldLabel : 'PHDDInstDr',
							hideLabel : 'True',
							hidden : true,
							name : 'PHDDInstDr'
						},{
							xtype : 'fieldset',
							title : '病症',
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
						}, {
							fieldLabel : '年龄',
							hiddenName : 'PDAAgeDr',
							id:'PDAAgeDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width: 300,
							emptyText:'请选择',
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDAAgeDr'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDAAgeDr')),
   							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : Age_Dr_QUERY_ACTION_URL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PDARowID',mapping:'PDARowID'},
										{name:'PDAAgeDesc',mapping:'PDAAgeDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'PDAAgeDesc',
							valueField : 'PDARowID',
							listeners : {
								'blur' : function(){
									var PDARowId=Ext.getCmp("PDAAgeDrF").getValue()
									if(PDARowId!=""){
										text[1]=Ext.getCmp("PDAAgeDrF").getRawValue()+",";
										Ext.Ajax.request({											
										url:AGE_ACTION_URL,
										method:'GET', 
										params:{
											'id':PDARowId
											},
										callback:function(options,success,response){
												    if(success){	
												    var jsonData=Ext.util.JSON.decode(response.responseText);
						    				 		var PDAAgeMin=jsonData.PDAAgeMin;
						    				 		Ext.getCmp("PDAMinValF").setValue(PDAAgeMin);
						    				 		var PDAAgeMax=jsonData.PDAAgeMax;
						    				 		Ext.getCmp("PDAMaxValF").setValue(PDAAgeMax);
						    				 		var PDAUomDr=jsonData.PDAUomDr;
						    				 		Ext.getCmp("PDAUomDrF").setValue(PDAUomDr);
						    				 		if(Ext.getCmp("PDAMinValF").getValue()!=""){
														text[2]="年龄"+Ext.getCmp("PDAMinValF").getValue();			
													}
													if(Ext.getCmp("PDAMaxValF").getValue()!=""){
														text[3]="-"+Ext.getCmp("PDAMaxValF").getValue()
													}
													if(Ext.getCmp("PDAUomDrF").getValue()!=""){
														text[4]=Ext.getCmp("PDAUomDrF").getRawValue()+";"
													}
						  						 }
											}
										})									
									}
									//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
                            }
							
						},{
					layout : 'column',
					border : false,
					items:[{
							width:180,
							layout : 'form',
							labelWidth : 80,
							labelPad : 1,// 默认5
							border : false,
							style:'margin-left:21px', 
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [AgeMinVal]
						},{
							width:5,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%'
							},
							items : [{fieldLabel:'-',labelSeparator:''}]
						},{
							width:100,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								xtype : 'textfield',
								msgTarget : 'under'
							},
							items : [AgeMaxVal]
						},{
							width: 100,
							layout : 'form',
							labelWidth : 5,
							labelPad : 1,// 默认5
							border : false,
							defaults : {
								anchor : '96%',
								msgTarget : 'under'
							},
							items : [UomDesc]
						}]	
				},
				{
						layout : 'column',
						border : false,
						items:[{
								width:230,
								layout : 'form',
								labelWidth : 80,
								labelPad : 1,// 默认5
								border : false,
								style:'margin-left:21px', 
								defaults : {
									anchor : '96%',
									xtype : 'textfield',
									msgTarget : 'under'
								},
								items : [PHINSTBMIMin]
							},{
								width:5,
								layout : 'form',
								labelWidth : 5,
								labelPad : 1,// 默认5
								border : false,
								defaults : {
									anchor : '96%'
								},
								items : [{xtype:'label',fieldLabel:'-',labelSeparator:''}]
							},{
								width:150,
								layout : 'form',
								labelWidth : 5,
								labelPad : 1,// 默认5
								border : false,
								defaults : {
									anchor : '96%',
									xtype : 'textfield',
									msgTarget : 'under'
								},
								items : [PHINSTBMIMax]
							}]	
					},{
							xtype : 'fieldset',
							title : '特殊人群',
							width:400,
							autoHeight : true,
							style:'margin-left:32px', 
							items:[{layout : 'column',
							border : false,
							items : [{
									width:340,
									layout : 'form',
									labelWidth :60,
									labelPad : 1,// 默认5
									border : false,
									style:'margin-left:1px', 
									defaults : {
										anchor : '96%',
										xtype : 'textfield',
										msgTarget : 'under'
									},
									items : [SpecialPopu]
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
									items : [BtnPopu]
								}]},gridPopu]
						},{
							fieldLabel:'描述',
							//allowBlank : false,
							xtype : 'textarea',
							name : 'PHINSTText',
							id:'PHINSTTextF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF')),
   							width:320,
   							height:120
						}		
					],
				buttons: [{
					text: '添加',
					width: 100,
					id:'btn_SavePanel',
					iconCls : 'icon-add',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_SavePanel'),
		      		handler: function (){
		      			if(Ext.getCmp('PHINSTTextF').getValue()==""){
		      				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          		return;
		      			}
						if(formSearch.form.isValid()==false){return;}
		    			//病症赋值
		    			var diseastr="";
					    dsDisea.each(function(record){
							if(diseastr==""){
					    		diseastr = record.get('PHDDDiseaDr');
					    	}else{
					    		diseastr = diseastr+","+record.get('PHDDDiseaDr');
					    	}
					    }, this);
					    //Ext.getCmp("Disea").setValue(diseastr);
					    //特殊人群赋值
		    			/*var ids="";
					    var popuitems = SpecialPopu.items;    
					    for (var i = 0; i < popuitems.length; i++) {    
					        if (popuitems.itemAt(i).checked) {    
					            if(ids =="") {
					            	ids=popuitems.itemAt(i).inputValue
					            } else {
					            	ids=ids+","+popuitems.itemAt(i).inputValue
					            }
					        }    
					    }*/
					    //特殊人群赋值
					    var Popustr="";
					    dsPopu.each(function(record){
							if(Popustr==""){
					    		Popustr = record.get('SPEPISpecDr');
					    	}else{
					    		Popustr = Popustr+","+record.get('SPEPISpecDr');
					    	}
					    }, this);
					    Ext.getCmp("Popu").setValue(Popustr);
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
										'PHINSTPointerType':"Form",
										'PHINSTActiveFlag' :"Y",
										'PHINSTSysFlag' :"Y",
										//'popu':ids,
										'PHDDDiseaDr':diseastr
									
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										text.length=0;
										Ext.Msg.show({
													title : '提示',
													msg : '添加成功！',
													icon : Ext.Msg.INFO,									
													buttons : Ext.Msg.OK,
														fn : function(btn) {			
															grid.getStore().baseParams={
											      				TypeDr : "",
																GenDr: GenDr,
																PointerType:"Form",
																PointerDr:PointerDr
											      			};
															grid.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_main
																				}
																			});
															diseaStr=""; //2016-08-09
															dsUnSelDisea.load({
																params : {
																	'InstId':"",
																	diseaStr:diseaStr, //2016-08-09
																	start : 0,
																	limit : pageSize_Disea
																}
															});
															WinDisea.hide();
													        dsDisea.load({
																params : {
																	'InstId':"",
																	start : 0,
																	limit : pageSize_Disea
																},
																callback : function(records, options, success) {
																}
														   });
														    /**特殊人群列表加载*/
												            PopuStr=""; //2016-08-09
												            RefreshPopuGrid("",PopuStr)		
														
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
					tooltip : '请选择一行后修改(Shift+D)',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdatePanel'),
					//disabled:true,
		      		handler: function (){	      			
		      		if (grid.selModel.hasSelection()) {
		      			if(Ext.getCmp('PHINSTTextF').getValue()==""){
		      				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          		return;
		      			}
		      			
		      			//病症赋值
	    			var diseastr="";
				    dsDisea.each(function(record){
				    	if (record.get('PHDDRowId')==""){
					    	if(diseastr==""){
					    		diseastr = record.get('PHDDDiseaDr');
					    	}else{
					    		diseastr = diseastr+","+record.get('PHDDDiseaDr');
					    	}
				    	}
				    }, this);
				   // Ext.getCmp("Disea").setValue(diseastr);
				    //特殊人群赋值
	    			/*var ids="";
				    var popuitems = SpecialPopu.items;    
				    for (var i = 0; i < popuitems.length; i++) {    
				        if (popuitems.itemAt(i).checked) {    
				            if(ids =="") {
				            	ids=popuitems.itemAt(i).inputValue
				            } else {
				            	ids=ids+","+popuitems.itemAt(i).inputValue
				            }
				        }    
				    }*/
				    		      		//特殊人群赋值
				    var Popustr="";
				    dsPopu.each(function(record){
				    	if (record.get('SPEPIRowId')==""){
					    	if(Popustr==""){
					    		Popustr = record.get('SPEPISpecDr');
					    	}else{
					    		Popustr = Popustr+","+record.get('SPEPISpecDr');
					    	}
				    	}
				    }, this);
				    Ext.getCmp("Popu").setValue(Popustr);
				    
		      			formSearch.form.submit({
								url : UPDATE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
									'PHDDInstDr': checkRowId,
									//'popu':ids,
									'PHDDDiseaDr':diseastr
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										text.length=0;
										var myrowid = "rowid=" + action.result.id;
										Ext.Msg.show({
													title : '提示',
													msg : '修改成功！',
													icon : Ext.Msg.INFO,									
													buttons : Ext.Msg.OK,
														fn : function(btn) {
															grid.getStore().baseParams={
											      				TypeDr : "",
																GenDr: GenDr,
																PointerType:"Form",
																PointerDr:PointerDr
											      			};
															grid.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_main
																				}
																			});
															diseaStr=""; //2016-08-09
															dsUnSelDisea.load({
														 		params : {
														 			'InstId':"",
														 			diseaStr:diseaStr, //2016-08-09
																	start : 0,
																	limit : pageSize_Disea
														 		}
														 	});
															WinDisea.hide();
													        dsDisea.load({
																params : {
																	'InstId':"",
																	start : 0,
																	limit : pageSize_Disea
																},
																callback : function(records, options, success) {
																}
														   });
												             /**特殊人群列表加载*/
												            PopuStr=""; //2016-08-09
												            RefreshPopuGrid("",PopuStr)															   
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
					tooltip : '请选择一行后删除(Shift+D)',
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
													text.length=0;
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
															diseaStr=""; //2016-08-09
															dsUnSelDisea.load({
															params : {
																'InstId':"",
																diseaStr:diseaStr, //2016-08-09
																start : 0,
																limit : pageSize_Disea
															}
															});
															WinDisea.hide();
													        dsDisea.load({
																params : {
																	'InstId':"",
																	start : 0,
																	limit : pageSize_Disea
																},
																callback : function(records, options, success) {
																}
														   });
												            /**特殊人群列表加载*/
												            PopuStr=""; //2016-08-09
												            RefreshPopuGrid("",PopuStr)															   
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
		      			text.length=0;
		      			grid.getStore().baseParams={
		      				TypeDr : "",
							GenDr: GenDr,
							PointerType:"Form",
							PointerDr:PointerDr
		      			};
						grid.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
						
						//病症
						diseaStr=""; //2016-08-09
						dsUnSelDisea.load({
							params : {
								'InstId':"",
								diseaStr:diseaStr, //2016-08-09
								start : 0,
								limit : pageSize_Disea
							}
						});
						WinDisea.hide();
				        dsDisea.load({
							params : {
								'InstId':"",
								start : 0,
								limit : pageSize_Disea
							},
							callback : function(records, options, success) {
							}
					   });
						/**特殊人群列表加载*/
			            PopuStr=""; //2016-08-09
			            RefreshPopuGrid("",PopuStr)						   
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
								},{
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
					PointerType:"Form",
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
				split:true,
        		stripeRows: true,
        		enableColumnMove: true,     //允许拖放列
	    		enableColumnResize: false,  //禁止改变列的宽度
        		autoScroll: true,
				title : '高危提醒',
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
				stateId : 'grid'
			});
	/** grid双击事件 */
	grid.on("rowclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				checkRowId= _record.get('PHINSTRowId')
				
				if (!_record) {
		
		        } else {
					Ext.getCmp("form-save").getForm().reset();
					    /**重新加载数据*/
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHINSTRowId'),
		                success : function(form,action) {	                	
					       /* var popuValue=action.result.data.SpecialPopu;//获取特殊人群值串
							var checkboxGroup=Ext.getCmp('Popu');
							var strSpec=""
							if(popuValue!=""){
							  	var val=popuValue.split("^"); 
								var items=checkboxGroup.items;
								checkboxGroup.reset();
								for(var i=0;i<val.length;i++){     
							      items.each(function(items){
							          if(items.inputValue==val[i]){
							          	items.setValue(true);           //前台动态选中特殊人群多选框
							          	if(strSpec==""){
			            					strSpec=items.boxLabel
			            				}else{
			            					strSpec=strSpec+","+items.boxLabel
			            				}							          	
							          }
							      })
							    }
							}*/
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
			        var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
			       
					 /**病症未选列表加载*/
			         /**病症明细加载*/
			        dsDisea.load({
						params : {
							'InstId':InstId,
							start : 0,
							limit : pageSize_Disea
						},
						callback : function(records, options, success) {
						}
				   });
			        diseaStr=""; //2016-08-09
			        dsUnSelDisea.load({
						params : {
							'InstId':InstId,
							diseaStr:diseaStr, //2016-08-09
							start : 0,
							limit : pageSize_Disea
						}
				   });
			       
		            /**特殊人群列表加载*/
		            PopuStr=""; //2017-03-24
		            RefreshPopuGrid(InstId,PopuStr)	
		        }        
			});
	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [formSearch,grid]
    });
	
	});
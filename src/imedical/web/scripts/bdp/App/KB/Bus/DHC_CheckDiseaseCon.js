/// 名称:知识库业务表 - 禁忌证
/// 编写者:基础平台组 - 谷雪萍
/// 编写日期:2014-12-5
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/MultiSelect.js"> </script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/multiselect.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCCheckDiseaseC&pClassQuery=GetListCon";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCCheckDiseaseC&pClassMethod=OpenConData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCCheckDiseaseC&pClassMethod=SaveConData&pEntityName=web.Entity.KB.DHCCheckDiseaseC";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCCheckDiseaseC&pClassMethod=UpdateConData&pEntityName=web.Entity.KB.DHCCheckDiseaseC";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCCheckDiseaseC&pClassMethod=DeleteConData";
	
	var QUERY_UnSelDisea_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCCheckDiseaseI&pClassQuery=GetUnSelDiseaList";
	var ACTION_URL_Disea = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCCheckDiseaseI&pClassQuery=GetDiseaList";
	var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCCheckDiseaseI&pClassMethod=DeleteDiseaData";
	
	var Age_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmb1";
	var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";
	var Agy_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCAllergyFeild&pClassQuery=GetDataForCmb1";
	var UOM_DR_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmbYMD";
		//特殊人群
	var PopuStr="" //2017-04-01
	var QUERY_UnSelPopu_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopu&pClassQuery=GetUnSelPopuList";
	var ACTION_URL_Popu = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLibSpecPopuItm&pClassQuery=GetPopuList";
	var DELETE_Popu_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLibSpecPopuItm&pClassMethod=DeletePopuData";
	var pageSize_Popu = Ext.BDP.FunLib.PageSize.Pop;
		//治疗手术、病症体征
	var QUERY_UnSelKey_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHKeyWord&pClassQuery=GetUnSelKeyList";
	var ACTION_URL_Key = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHKeyWord&pClassQuery=GetKeyList";
	var DELETE_Key_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHKeyWord&pClassMethod=DeleteKeyData";
	var pageSize_Key = Ext.BDP.FunLib.PageSize.Pop;
	var pageSize_Key0 = Ext.BDP.FunLib.PageSize.Pop;
	var KeyStr="";//2017-03-23
	var Key0Str="";//2017-03-23
	
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pageSize_pop = Ext.BDP.FunLib.PageSize.Pop;
	var diseaStr="";//2016-08-09
	
	Ext.form.Field.prototype.msgTarget = 'qtip';                         //--------设置消息提示方式为在下边显示
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
	var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","CheckContr");
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
	//---特殊人群
	/*var CheckboxItems = [];  
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
	}*/

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
	var unSelDiseatb = new Ext.Toolbar({
		id : 'unSelDiseatb',
		items : [UnSelDiseaSearch, UnSelDiseaText, '->' ,UnSelDiseaRefresh]
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
						limit : pageSize_pop
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
		title:'病症明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsDisea,
	    trackMouseOver: true,
	    columns: [
	            smDisea,
	            { header: 'PHDDDiseaDr', width: 200, sortable: true, dataIndex: 'PHDDDiseaDr',hidden:true },
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
		//bbar:pagingDisea ,
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
	 			 /*var diseaDescs="";
			   	dsDisea.each(function(record){
			    	if(diseaDescs==""){
			    		diseaDescs = record.get('PHDISLDiseaDesc');
			    	}else{
			    		diseaDescs = diseaDescs+","+record.get('PHDISLDiseaDesc');
			    	}
			    }, this);	*/
			 	var diseaDescs=Ext.getCmp("Disea").getValue()
			   	diseaDescs=diseaDescs.replace("<"+gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')+">","");//2016-08-09
	 			
	 			/*var diseaDescs=Ext.getCmp("Disea").getValue();
	 			diseaDescs=diseaDescs.replace(gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')+",","");//2016-08-09
	 			*/
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
								/*var diseaDescs=Ext.getCmp("Disea").getValue();
	 							diseaDescs=diseaDescs.replace(gridDisea.getSelectionModel().getSelections()[0].get('PHDISLDiseaDesc')+",","");//2016-08-09
	 			*/
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
	
	/**************************************治疗手术多选开始*****************************************/	
/** ---------未选列表内容部分------------* */
	var dsUnSelKey = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelKey_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'KeyRowId', mapping:'KeyRowId',type: 'string'},
	  	{ name: 'KeyCode', mapping:'KeyCode',type: 'string'},
        { name: 'KeyDesc', mapping:'KeyDesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelKey
	});
	dsUnSelKey.on('beforeload',function(thiz,options){ 
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     KeyStr:KeyStr,//2016-08-09
		     type:"1"
		     
		  }   
		)
	});
	dsUnSelKey.load({
		params : {
			start : 0,
			limit : pageSize_Key
		},
		callback : function(records, options, success) {
		}
	});
	var UnSelKeySearch = new Ext.Button({
		id : 'UnSelKeySearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelKey.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelKeyText").getValue(),
       			KeyStr:KeyStr, //2016-08-09
       			type:"1"
       		};
			gridUnSelKey.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Key
					}
			});
		}
	});	
	var UnSelKeyRefresh = new Ext.Button({
		id : 'UnSelKeyRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelKeyText").reset();                    
			gridUnSelKey.getStore().baseParams={
				KeyStr:KeyStr,
				type:"1"
			};//2016-08-09
			gridUnSelKey.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_Key
				}
			});
		}
	});	
	var UnSelKeyText = new Ext.form.TextField({
		id : 'UnSelKeyText',
		enableKeyEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelKey.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelKeyText").getValue(),
       			KeyStr:KeyStr, //2016-08-09
       			type:"1"
       		};
			gridUnSelKey.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Key
					}
				});
	        }
		}						
	})
	var UnSelKeytb = new Ext.Toolbar({
		id : 'UnSelKeytb',
		items : [UnSelKeySearch, UnSelKeyText, '->' ,UnSelKeyRefresh]
	});
	var pagingUnSelKey= new Ext.PagingToolbar({
            pageSize: pageSize_Key,
            store: dsUnSelKey,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_Key=this.pageSize;
				         }
		        }
        })	
	var smUnSelKey = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelKey = new Ext.grid.GridPanel({
		id:'gridUnSelKey',
		closable:true,
	    store: dsUnSelKey,
	    trackMouseOver: true,
	    columns: [
	            smUnSelKey,
	            { header: 'KeyRowId', width: 200, sortable: true, dataIndex: 'KeyRowId',hidden:true }, 
	            { header: '代码', width: 200, sortable: true, dataIndex: 'KeyCode',hidden:true },
	            { header: '描述', width: 200, sortable: true, dataIndex: 'KeyDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : UnSelKeytb, 
		bbar:pagingUnSelKey,
	    stateId: 'gridUnSelKey'
	});
	var WinKey=new Ext.Window({  
        id:'WinKey',  
        width:240,  
        height:380,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'治疗手术',  
        items:gridUnSelKey  
    }); 
	//---治疗手术
	var TextKey = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '治疗手术',
		name : 'PDCUKeyWordDr',
		id : 'Key',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Key'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Key')),
		dataIndex:'PDCUKeyWordDr',
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("Key").getValue()!=""){
					text[8]="治疗手术:"+Ext.getCmp("Key").getValue()+";";
				}else{
					text[8]="";
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));	
			}		
		}
	});
	var BtnKey = new Ext.Button({
		id : 'btnKey',  
        text : '...',  
        tooltip : '治疗手术未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**治疗手术未选列表加载*/
	        	var InstId="";
			    if(typeof(grid)!="undefined"){
			    	if(grid.getSelectionModel().getCount()!=0){
			    		var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
			    	}
			    }
			    dsUnSelKey.load({
					params : {
						'InstId':InstId,
						KeyStr:KeyStr, //2016-08-09
						type:"1",
						start : 0,
						limit : pageSize_Key
					}
			    });
	        	WinKey.setPosition(610,0);
	        	WinKey.show();
	        }  
        }  
	});
		/** ---------治疗手术维护表单内容部分------------* */
	var dsKey = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Key}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'KeyDr', mapping:'KeyDr',type: 'string'},
	  	{ name: 'KeyCode', mapping:'KeyCode',type: 'string'},
        { name: 'KeyDesc', mapping:'KeyDesc',type: 'string'},
        { name: 'BusRowId', mapping:'BusRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsKey
	});
	dsKey.on('beforeload',function(thiz,options){ 
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     type:"1"
		  }   
		)
	});
	dsKey.load({
		params : {
			start : 0,
			limit : pageSize_Key
		},
		callback : function(records, options, success) {
		}
	});
	var pagingKey= new Ext.PagingToolbar({
        pageSize: pageSize_Key,
        store: dsKey,
        displayInfo: true,
        displayMsg: '',
        emptyMsg: "",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_Key=this.pageSize;
			         }
	        }
    });	
	var smKey = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridKey = new Ext.grid.GridPanel({
		id:'gridKey',
		region: 'center',
		title:'治疗手术明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsKey,
	    trackMouseOver: true,
	    columns: [
	            smKey,
	            { header: 'KeyDr', width: 200, sortable: true, dataIndex: 'KeyDr',hidden:true },
	            { header: '代码', width: 200, sortable: true, dataIndex: 'KeyCode' },
	            { header: '描述', width: 200, sortable: true, dataIndex: 'KeyDesc' }, 
	            {
				header : '操作',
				dataIndex : 'BusRowId',
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
		bbar:pagingKey ,
	    stateId: 'gridKey'
	});
	gridUnSelKey.on("rowdblclick", function(grid, rowIndex, e){
		var _record = new Ext.data.Record({
			'BusRowId':'',
			'KeyDr':gridUnSelKey.getSelectionModel().getSelections()[0].get('KeyRowId'),
	 		'KeyCode':gridUnSelKey.getSelectionModel().getSelections()[0].get('KeyCode'),
	 		'KeyDesc':gridUnSelKey.getSelectionModel().getSelections()[0].get('KeyDesc')
	 	});
	 	gridKey.stopEditing();
	 	dsKey.insert(0,_record); 
	 	
	 	if (KeyStr!=""){
	 		KeyStr=KeyStr+"^<"+gridUnSelKey.getSelectionModel().getSelections()[0].get('KeyRowId')+">";
	 	}else{
	 		KeyStr="<"+gridUnSelKey.getSelectionModel().getSelections()[0].get('KeyRowId')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelKey.getSelectionModel().getSelected();
	 	dsUnSelKey.remove(myrecord);
	 	//页面治疗手术框显示值
	 	var KeyDescs="";
	    dsKey.each(function(record){
	    	if(KeyDescs==""){
	    		KeyDescs = record.get('KeyDesc');
	    	}else{
	    		KeyDescs = KeyDescs+","+record.get('KeyDesc');
	    	}
	    }, this);
	    Ext.getCmp("Key").setValue(KeyDescs);
	    if(KeyDescs!=""){
	   		 text[8]="治疗手术:"+KeyDescs+";";
	    }else{
	    	text[8]="";
	    }
		//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	});
	gridKey.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 	  if (gridKey.selModel.hasSelection()) {
	 		var BusRowId = gridKey.getSelectionModel().getSelections()[0].get('BusRowId');
	 		if(BusRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'KeyRowId':gridKey.getSelectionModel().getSelections()[0].get('KeyDr'),
			 		'KeyCode':gridKey.getSelectionModel().getSelections()[0].get('KeyCode'),
			 		'KeyDesc':gridKey.getSelectionModel().getSelections()[0].get('KeyDesc')
			 	});
			 	gridUnSelKey.stopEditing();
			 	dsUnSelKey.insert(0,_record);
			 	//已选列表删除
			 	KeyStr=KeyStr.replace("<"+gridKey.getSelectionModel().getSelections()[0].get('KeyDr')+">","");//2016-08-09
	 			var myrecord=gridKey.getSelectionModel().getSelected();
			 	dsKey.remove(myrecord);
	 			//页面治疗手术框显示值
	 			var KeyDescs="";
			    dsKey.each(function(record){
			    	if(KeyDescs==""){
			    		KeyDescs = record.get('KeyDesc');
			    	}else{
			    		KeyDescs = KeyDescs+","+record.get('KeyDesc');
			    	}
			    }, this);
			    Ext.getCmp("Key").setValue(KeyDescs);
			    if(KeyDescs!=""){
			   		 text[8]="治疗手术:"+KeyDescs+";";
			    }else{
			    	text[8]="";
			    }
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	 		}else{
	 			var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
				Ext.Ajax.request({
					url : DELETE_Key_URL,
					method : 'POST',
					params : {
						'id' : BusRowId,
						'type':"1"
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
								else if((totalnum-1)%pageSize_Key==0)//最后一页只有一条
								{
									var pagenum=grid.getStore().getCount();
									if (pagenum==1){ startIndex=startIndex-pageSize_Key;}  //最后一页的时候,不是最后一页则还停留在这一页
								}
								if(gridKey.getSelectionModel().getCount()!='0'){
									var id = gridKey.getSelectionModel().getSelections()[0].get('BusRowId');
								}
								/**治疗手术未选列表加载*/
								var _record = new Ext.data.Record({
									'KeyRowId':gridKey.getSelectionModel().getSelections()[0].get('KeyDr'),
							 		'KeyCode':gridKey.getSelectionModel().getSelections()[0].get('KeyCode'),
							 		'KeyDesc':gridKey.getSelectionModel().getSelections()[0].get('KeyDesc')
							 	});
							 	gridUnSelKey.stopEditing();
							 	dsUnSelKey.insert(0,_record);

						        /**治疗手术明细加载*/
							   var myrecord=gridKey.getSelectionModel().getSelected();
	 						   dsKey.remove(myrecord);
	 						   //页面治疗手术框显示值
								var KeyDescs="";
							    dsKey.each(function(record){
							    	if(KeyDescs==""){
							    		KeyDescs = record.get('KeyDesc');
							    	}else{
							    		KeyDescs = KeyDescs+","+record.get('KeyDesc');
							    	}
							    }, this);
							    Ext.getCmp("Key").setValue(KeyDescs);
							    if(KeyDescs!=""){
							   		 text[8]="治疗手术:"+KeyDescs+";";
							    }else{
							    	text[8]="";
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
	/**************************************治疗手术多选结束*****************************************/
/**************************************症状体征多选开始*****************************************/	
/** ---------未选列表内容部分------------* */
	var dsUnSelKey0 = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelKey_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'KeyRowId', mapping:'KeyRowId',type: 'string'},
	  	{ name: 'KeyCode', mapping:'KeyCode',type: 'string'},
        { name: 'KeyDesc', mapping:'KeyDesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelKey0
	});
	dsUnSelKey0.on('beforeload',function(thiz,options){ 
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     KeyStr:Key0Str,//2016-08-09
		     type:"0"
		     
		  }   
		)
	});
	dsUnSelKey0.load({
		params : {
			start : 0,
			limit : pageSize_Key0
		},
		callback : function(records, options, success) {
		}
	});
	var UnSelKey0Search = new Ext.Button({
		id : 'UnSelKey0Search',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelKey0.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelKey0Text").getValue(),
       			KeyStr:Key0Str, //2016-08-09
       			type:"0"
       		};
			gridUnSelKey0.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Key0
					}
			});
		}
	});	
	var UnSelKey0Refresh = new Ext.Button({
		id : 'UnSelKey0Refresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelKey0Text").reset();                    
			gridUnSelKey0.getStore().baseParams={
				KeyStr:Key0Str,
				type:"0"
			};//2016-08-09
			gridUnSelKey0.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_Key0
				}
			});
		}
	});	
	var UnSelKey0Text = new Ext.form.TextField({
		id : 'UnSelKey0Text',
		enableKeyEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelKey0.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelKey0Text").getValue(),
       			KeyStr:Key0Str, //2016-08-09
       			type:"0"
       		};
			gridUnSelKey0.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Key0
					}
				});
	        }
		}						
	})
	var UnSelKeytb0 = new Ext.Toolbar({
		id : 'UnSelKeytb0',
		items : [UnSelKey0Search, UnSelKey0Text, '->' ,UnSelKey0Refresh]
	});
	var pagingUnSelKey0= new Ext.PagingToolbar({
            pageSize: pageSize_Key0,
            store: dsUnSelKey0,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_Key0=this.pageSize;
				         }
		        }
        })	
	var smUnSelKey = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelKey0 = new Ext.grid.GridPanel({
		id:'gridUnSelKey0',
		closable:true,
	    store: dsUnSelKey0,
	    trackMouseOver: true,
	    columns: [
	            smUnSelKey,
	            { header: 'KeyRowId', width: 200, sortable: true, dataIndex: 'KeyRowId',hidden:true }, 
	            { header: '代码', width: 200, sortable: true, dataIndex: 'KeyCode',hidden:true },
	            { header: '描述', width: 200, sortable: true, dataIndex: 'KeyDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : UnSelKeytb0, 
		bbar:pagingUnSelKey0,
	    stateId: 'gridUnSelKey0'
	});
	var WinKey0=new Ext.Window({  
        id:'WinKey0',  
        width:240,  
        height:380,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'症状体征',  
        items:gridUnSelKey0  
    }); 
	//---症状体征
	var TextKey0 = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '症状体征',
		name : 'PSYMKeyWordDr',
		id : 'TextKey0',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextKey0'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextKey0')),
		dataIndex:'PSYMKeyWordDr',
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("TextKey0").getValue()!=""){
					text[9]="症状体征:"+Ext.getCmp("TextKey0").getValue()+";";
				}else{
					text[9]="";
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));	
			}		
		}
	});
	var BtnKey0 = new Ext.Button({
		id : 'BtnKey0',  
        text : '...',  
        tooltip : '症状体征未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**症状体征未选列表加载*/
	        	var InstId="";
			    if(typeof(grid)!="undefined"){
			    	if(grid.getSelectionModel().getCount()!=0){
			    		var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
			    	}
			    }
			    dsUnSelKey0.load({
					params : {
						'InstId':InstId,
						KeyStr:Key0Str, //2016-08-09
						type:"0",
						start : 0,
						limit : pageSize_Key0
					}
			    });
	        	WinKey0.setPosition(610,0);
	        	WinKey0.show();
	        }  
        }  
	});
		/** ---------症状体征维护表单内容部分------------* */
	var dsKey0 = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Key}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'KeyDr', mapping:'KeyDr',type: 'string'},
	  	{ name: 'KeyCode', mapping:'KeyCode',type: 'string'},
        { name: 'KeyDesc', mapping:'KeyDesc',type: 'string'},
        { name: 'BusRowId', mapping:'BusRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsKey0
	});
	dsKey0.on('beforeload',function(thiz,options){ 
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     type:"0"
		  }   
		)
	});
	dsKey0.load({
		params : {
			start : 0,
			limit : pageSize_Key0
		},
		callback : function(records, options, success) {
		}
	});
	var pagingKey0= new Ext.PagingToolbar({
        pageSize: pageSize_Key0,
        store: dsKey0,
        displayInfo: true,
        displayMsg: '',
        emptyMsg: "",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_Key0=this.pageSize;
			         }
	        }
    });	
	var smKey0 = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridKey0 = new Ext.grid.GridPanel({
		id:'gridKey0',
		region: 'center',
		title:'症状体征明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsKey0,
	    trackMouseOver: true,
	    columns: [
	            smKey0,
	            { header: 'KeyDr', width: 200, sortable: true, dataIndex: 'KeyDr',hidden:true },
	            { header: '代码', width: 200, sortable: true, dataIndex: 'KeyCode' },
	            { header: '描述', width: 200, sortable: true, dataIndex: 'KeyDesc' }, 
	            {
				header : '操作',
				dataIndex : 'BusRowId',
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
		bbar:pagingKey0 ,
	    stateId: 'gridKey0'
	});
	gridUnSelKey0.on("rowdblclick", function(grid, rowIndex, e){
		var _record = new Ext.data.Record({
			'BusRowId':'',
			'KeyDr':gridUnSelKey0.getSelectionModel().getSelections()[0].get('KeyRowId'),
	 		'KeyCode':gridUnSelKey0.getSelectionModel().getSelections()[0].get('KeyCode'),
	 		'KeyDesc':gridUnSelKey0.getSelectionModel().getSelections()[0].get('KeyDesc')
	 	});
	 	gridKey0.stopEditing();
	 	dsKey0.insert(0,_record); 
	 	
	 	if (Key0Str!=""){
	 		Key0Str=Key0Str+"^<"+gridUnSelKey0.getSelectionModel().getSelections()[0].get('KeyRowId')+">";
	 	}else{
	 		Key0Str="<"+gridUnSelKey0.getSelectionModel().getSelections()[0].get('KeyRowId')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelKey0.getSelectionModel().getSelected();
	 	dsUnSelKey0.remove(myrecord);
	 	//页面症状体征框显示值
	 	var KeyDescs="";
	    dsKey0.each(function(record){
	    	if(KeyDescs==""){
	    		KeyDescs = record.get('KeyDesc');
	    	}else{
	    		KeyDescs = KeyDescs+","+record.get('KeyDesc');
	    	}
	    }, this);
	    Ext.getCmp("TextKey0").setValue(KeyDescs);
	    if(KeyDescs!=""){
	   		 text[9]="症状体征:"+KeyDescs+";";
	    }else{
	    	text[9]="";
	    }
		//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	});
	gridKey0.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 	  if (gridKey0.selModel.hasSelection()) {
	 		var BusRowId = gridKey0.getSelectionModel().getSelections()[0].get('BusRowId');
	 		if(BusRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'KeyRowId':gridKey0.getSelectionModel().getSelections()[0].get('KeyDr'),
			 		'KeyCode':gridKey0.getSelectionModel().getSelections()[0].get('KeyCode'),
			 		'KeyDesc':gridKey0.getSelectionModel().getSelections()[0].get('KeyDesc')
			 	});
			 	gridUnSelKey0.stopEditing();
			 	dsUnSelKey0.insert(0,_record);
			 	//已选列表删除
			 	Key0Str=Key0Str.replace("<"+gridKey0.getSelectionModel().getSelections()[0].get('KeyDr')+">","");//2016-08-09
	 			var myrecord=gridKey0.getSelectionModel().getSelected();
			 	dsKey0.remove(myrecord);
	 			//页面症状体征框显示值
	 			var KeyDescs="";
			    dsKey0.each(function(record){
			    	if(KeyDescs==""){
			    		KeyDescs = record.get('KeyDesc');
			    	}else{
			    		KeyDescs = KeyDescs+","+record.get('KeyDesc');
			    	}
			    }, this);
			    Ext.getCmp("TextKey0").setValue(KeyDescs);
			    if(KeyDescs!=""){
			   		 text[9]="症状体征:"+KeyDescs+";";
			    }else{
			    	text[9]="";
			    }
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	 		}else{
	 			var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
				Ext.Ajax.request({
					url : DELETE_Key_URL,
					method : 'POST',
					params : {
						'id' : BusRowId,
						'type':"0"
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
								else if((totalnum-1)%pageSize_Key0==0)//最后一页只有一条
								{
									var pagenum=grid.getStore().getCount();
									if (pagenum==1){ startIndex=startIndex-pageSize_Key0;}  //最后一页的时候,不是最后一页则还停留在这一页
								}
								if(gridKey0.getSelectionModel().getCount()!='0'){
									var id = gridKey0.getSelectionModel().getSelections()[0].get('BusRowId');
								}
								/**症状体征未选列表加载*/
								var _record = new Ext.data.Record({
									'KeyRowId':gridKey0.getSelectionModel().getSelections()[0].get('KeyDr'),
							 		'KeyCode':gridKey0.getSelectionModel().getSelections()[0].get('KeyCode'),
							 		'KeyDesc':gridKey0.getSelectionModel().getSelections()[0].get('KeyDesc')
							 	});
							 	gridUnSelKey0.stopEditing();
							 	dsUnSelKey0.insert(0,_record);

						        /**症状体征明细加载*/
							   var myrecord=gridKey0.getSelectionModel().getSelected();
	 						   dsKey0.remove(myrecord);
	 						   //页面症状体征框显示值
								var KeyDescs="";
							    dsKey0.each(function(record){
							    	if(KeyDescs==""){
							    		KeyDescs = record.get('KeyDesc');
							    	}else{
							    		KeyDescs = KeyDescs+","+record.get('KeyDesc');
							    	}
							    }, this);
							    Ext.getCmp("TextKey0").setValue(KeyDescs);
							    if(KeyDescs!=""){
							   		 text[9]="症状体征:"+KeyDescs+";";
							    }else{
							    	text[9]="";
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
	/**************************************症状体征多选结束*****************************************/
		//刷新治疗手术列表
	function RefreshKeyGrid(inst,str)
	{
		/**治疗手术未选列表加载*/
	    dsUnSelKey.load({
			params : {
				'InstId':inst,
				KeyStr:str, //2016-08-09
				type:"1",
				start : 0,
				limit : pageSize_Key
			}
	    });
        /**治疗手术明细加载*/
        dsKey.load({
			params : {
				'InstId':inst,
				type:"1",
				start : 0,
				limit : pageSize_Key
			},
			callback : function(records, options, success) {
			}
	   });
	}
	//刷新病症体征列表
	function RefreshKey0Grid(inst,str)
	{
		   	/**病症体征未选列表加载*/
		    dsUnSelKey0.load({
				params : {
					'InstId':inst,
					KeyStr:str, //2016-08-09
					type:"0",
					start : 0,
					limit : pageSize_Key0
				}
		    });
		    WinKey0.hide();
	        /**病症体征明细加载*/
	        dsKey0.load({
				params : {
					'InstId':inst,
					type:"0",
					start : 0,
					limit : pageSize_Key0
				},
				callback : function(records, options, success) {
				}
		   });
	}
	

	
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
	
	var formSearch = new Ext.form.FormPanel({
				title:'禁忌证表单',
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
				buttonAlign:'center',
				labelAlign : 'right',
				labelWidth : 100,
				reader: new Ext.data.JsonReader({root:'list'},
		                             [
                                        {name: 'PHDDRowId',mapping:'PHDDRowId',type:'string'},
                                        {name: 'PHDDInstDr',mapping:'PHDDInstDr',type:'string'},
                                        {name: 'PHINSTMode',mapping:'PHINSTMode',type:'string'},
                      
                                        {name: 'PHDDDiseaDr',mapping:'PHDDDiseaDr',type:'string'},
                                        {name: 'PDAAgeDr',mapping:'PDAAgeDr',type:'string'},
                                        {name: 'PHINSTSex',mapping:'PHINSTSex',type:'string'},
                                        
                                        {name: 'PHINSTTypeDr',mapping:'PHINSTTypeDr',type:'string'},
                                        {name: 'PHINSTOrderNum',mapping:'PHINSTOrderNum',type:'string'},
                                        {name: 'PHINSTGenDr',mapping:'PHINSTGenDr',type:'string'},
                                        {name: 'PHINSTPointerDr',mapping:'PHINSTPointerDr',type:'string'},
                                        {name: 'PHINSTLibDr',mapping:'PHINSTLibDr',type:'string'},
                                        {name: 'PHINSTPointerType',mapping:'PHINSTPointerType',type:'string'},
                                        {name: 'PHINSTActiveFlag',mapping:'PHINSTActiveFlag',type:'string'},
                                        {name: 'PHINSTSysFlag',mapping:'PHINSTSysFlag',type:'string'},
                                        
                                        {name: 'PHINSTText',mapping:'PHINSTText',type:'string'},                                     
                                        {name: 'LALCAllergyDr',mapping:'LALCAllergyDr',type:'string'},
                                        {name: 'SpecialPopu',mapping : 'SpecialPopu',type : 'string'},//特殊人群                                       
                                        {name: 'PDAMinVal',mapping:'PDAMinVal',type:'string'},
                                        {name: 'PDAMaxVal',mapping:'PDAMaxVal',type:'string'},
                                        {name: 'PDAUomDr',mapping:'PDAUomDr',type:'string'},
                                        
                                        {name: 'PDCUKeyWordDr',mapping:'PDCUKeyWordDr',type:'string'},
                                        {name: 'PSYMKeyWordDr',mapping:'PSYMKeyWordDr',type:'string'}
                                        
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
							//allowBlank:false,
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['W','警示'],
									      ['C','管控'],
									      ['S','统计']
								     ]
							})
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
						},{
							fieldLabel : '年龄',
							hiddenName : 'PDAAgeDr',
							id:'PDAAgeDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width:300,
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
									else
									{
										Ext.getCmp("PDAMinValF").setValue("");
										Ext.getCmp("PDAMaxValF").setValue("");
										Ext.getCmp("PDAUomDrF").setValue("");
									}
								}/*,
								'blur' : function(){
								var PDARowId=Ext.getCmp("PDAAgeDrF").getValue()
								if(PDARowId="")
								{
									Ext.getCmp("PDAMinValF").setValue("");
									Ext.getCmp("PDAMaxValF").setValue("");
									Ext.getCmp("PDAUomDrF").setValue("");
								}
								//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
							}*/
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
						},{
							fieldLabel : '过敏史',
							hiddenName : 'LALCAllergyDr',
							id:'LALCAllergyDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width:300,
							emptyText:'请选择',
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LALCAllergyDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LALCAllergyDrF')),
   							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : Agy_Dr_QUERY_ACTION_URL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'ALFRowId',mapping:'ALFRowId'},
										{name:'ALFDesc',mapping:'ALFDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'ALFDesc',
							valueField : 'ALFRowId',
							validationEvent : 'blur',
                            listeners : {
								'blur' : function(){
									if(Ext.getCmp("LALCAllergyDrF").getRawValue()!=""){
										text[5]="过敏史:"+Ext.getCmp("LALCAllergyDrF").getRawValue()+";";
									}else{
										text[5]="";
									}
									//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
                            }
							
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
						}/*,SpecialPopu*/,{
							fieldLabel: '性别',
				    		xtype:'radiogroup',
				    		defaultType:'radio',
							name :'PHINSTSex',
							id:'PHINSTSex',
							width:300,
							//layout:'column', //激活、未激活呈分列式排布
							items:[{boxLabel:'男',name:'PHINSTSex',inputValue:'M'},
								   {boxLabel:'女',name:'PHINSTSex',inputValue:'F'},
								   {boxLabel:'全部',name:'PHINSTSex',inputValue:'A',checked:true}],
							listeners : {
								'change' : function(){
										var sexE=formSearch.getForm().getValues()["PHINSTSex"]
										var sex=""
										var ss=Ext.getCmp("PHINSTTextF").getValue();
										switch(sexE){
											case'M':sex="男";break;
											case'F':sex="女";break;
											case'A':sex="全部";break;								
										}									
										if(sex!="全部"){
											text[7]="性别："+sex+";";
											
											if(sex=="男"){
												var str=ss.replace(("女"),sex);
											}
											if(sex=="女"){
												var str=ss.replace("男",sex);
											}			
										}else{
											text[7]="";
											if(ss.indexOf("性别：男")!='-1'){
												var str=ss.replace(("性别：男;"),"");
											}
											if(ss.indexOf("性别：女")!='-1'){
												var str=ss.replace(("性别：女;"),"");
											}
										}
										/*if(ss.indexOf("性别")!='-1'){
											Ext.getCmp("PHINSTTextF").setValue(str);
										}else{
											Ext.getCmp("PHINSTTextF").setValue(getStr(text));
										}*/
								}
                            }
						},{
							xtype : 'fieldset',
							title : '治疗手术',
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
									items : [TextKey]
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
									items : [BtnKey]
								}]},gridKey]
						},{
							xtype : 'fieldset',
							title : '症状体征',
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
									items : [TextKey0]
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
									items : [BtnKey0]
								}]},gridKey0]
						},{
							fieldLabel : '描述',
							//allowBlank : false,
							xtype : 'textarea',
							name : 'PHINSTText',
							id:'PHINSTTextF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF')),
   							width:300,
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
					    
					    					    //治疗手术赋值
		    			var str1="";
					    dsKey.each(function(record){
							if(str1==""){
					    		str1 = record.get('KeyDr');
					    	}else{
					    		str1 = str1+","+record.get('KeyDr');
					    	}
					    }, this);
					    
					   //病症体征赋值
		    			var str0="";
					    dsKey0.each(function(record){
							if(str0==""){
					    		str0 = record.get('KeyDr');
					    	}else{
					    		str0 = str0+","+record.get('KeyDr');
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
										'PHINSTPointerType':"Form",
										'PHINSTActiveFlag' :"Y",
										'PHINSTSysFlag' :"Y",
										//'popu':ids,
										'PHDDDiseaDr':diseastr,
										'PDCUKeyWordDr':str1,
										'PSYMKeyWordDr':str0
									
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
															grid.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_main
																				}
																			});
															diseaStr=""; //2016-08-09
															//病症
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
																}
														   });
														    /**特殊人群列表加载*/
												            PopuStr=""; //2016-08-09
												            RefreshPopuGrid("",PopuStr)		
															/**治疗手术列表加载*/
												            KeyStr=""; //2016-08-09
															RefreshKeyGrid("",KeyStr)	
														   
														   	/**病症体征列表加载*/
												            Key0Str=""; //2016-08-09
												            RefreshKey0Grid("",Key0Str)			
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
		      		//病症赋值
	    			var diseastr="";
				    dsDisea.each(function(record){
				    	if(diseastr==""){
				    		diseastr = record.get('PHDDDiseaDr');
				    	}else{
				    		diseastr = diseastr+","+record.get('PHDDDiseaDr');
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
				    	if(Popustr==""){
				    		Popustr = record.get('SPEPISpecDr');
				    	}else{
				    		Popustr = Popustr+","+record.get('SPEPISpecDr');
				    	}
				    }, this);
				    Ext.getCmp("Popu").setValue(Popustr);
				    //治疗手术赋值
	    			var str1="";
				    dsKey.each(function(record){
						if(str1==""){
				    		str1 = record.get('KeyDr');
				    	}else{
				    		str1 = str1+","+record.get('KeyDr');
				    	}
				    }, this);
				    
				   //病症体征赋值
	    			var str0="";
				    dsKey0.each(function(record){
						if(str0==""){
				    		str0 = record.get('KeyDr');
				    	}else{
				    		str0 = str0+","+record.get('KeyDr');
				    	}
				    }, this);    
		      		if (grid.selModel.hasSelection()) {
		      			if(Ext.getCmp('PHINSTTextF').getValue()==""){
		      				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          		return;
		      			}
		      			formSearch.form.submit({
								url : UPDATE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
									'PHDDInstDr': checkRowId,
									//'popu':ids,
									'PHDDDiseaDr':diseastr,
									'PDCUKeyWordDr':str1,
									'PSYMKeyWordDr':str0
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										text.length=0;
										//var myrowid = "rowid=" + action.result.id;
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
															diseaStr=""; //2016-08-09
															//病症
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
																}
														   });
													        /**特殊人群列表加载*/
												            PopuStr=""; //2016-08-09
												            RefreshPopuGrid("",PopuStr)															   
															/**治疗手术列表加载*/
												            KeyStr=""; //2016-08-09
															RefreshKeyGrid("",KeyStr)	
														   
														   	/**病症体征列表加载*/
												            Key0Str=""; //2016-08-09
												            RefreshKey0Grid("",Key0Str)		
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
															//病症
															diseaStr=""; //2016-08-09
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
												            /**特殊人群列表加载*/
												            PopuStr=""; //2016-08-09
												            RefreshPopuGrid("",PopuStr)	
												            
														   	/**治疗手术列表加载*/
												            KeyStr=""; //2016-08-09
															RefreshKeyGrid("",KeyStr)	
														   
														   	/**病症体征列表加载*/
												            Key0Str=""; //2016-08-09
												            RefreshKey0Grid("",Key0Str)														            
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
						/**特殊人群列表加载*/
			            PopuStr=""; //2016-08-09
			            RefreshPopuGrid("",PopuStr)		
			            
					   	/**治疗手术列表加载*/
			            KeyStr=""; //2016-08-09
						RefreshKeyGrid("",KeyStr)	
					   
					   	/**病症体征列表加载*/
			            Key0Str=""; //2016-08-09
			            RefreshKey0Grid("",Key0Str)					            
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
				split:true,//允许拖长
				trackMouseOver : true,
        		stripeRows: true,
        		enableColumnMove: true,     //允许拖放列
	    		enableColumnResize: false,  //禁止改变列的宽度
        		autoScroll: true,
				title : '禁忌证',
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
		        	/**清空所有表单数据包括病症列表*/
					Ext.getCmp("form-save").getForm().reset();
					text.length=0;
					WinDisea.hide();
				    dsDisea.load({
							params : {
								'InstId':"",
								start : 0,
								limit : pageSize_pop
							}
					   });
					 /**重新加载数据*/
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHINSTRowId'),
		                success : function(form,action) {	                	
					        /*var popuValue=action.result.data.SpecialPopu;//获取特殊人群值串
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
							
							
							 /**设置修改时描述的自动生成*/
							if(Ext.getCmp("Disea").getValue()!=""){
								text[0]="病症:"+Ext.getCmp("Disea").getValue()+";";
							}
							if(Ext.getCmp("PDAAgeDrF").getValue()!=""){
								text[1]=Ext.getCmp("PDAAgeDrF").getRawValue()+",";
							}
							if(Ext.getCmp("PDAMinValF").getValue()!=""){
								text[2]="年龄"+Ext.getCmp("PDAMinValF").getValue();			
							}
							if(Ext.getCmp("PDAMaxValF").getValue()!=""){
								text[3]="-"+Ext.getCmp("PDAMaxValF").getValue()
							}
							if(Ext.getCmp("PDAUomDrF").getValue()!=""){
								text[4]=Ext.getCmp("PDAUomDrF").getRawValue()+";"
							}
							if(Ext.getCmp("LALCAllergyDrF").getValue()!=""){									
								text[5]="过敏史："+Ext.getCmp("LALCAllergyDrF").getRawValue()+";";
							}
							/*if(strSpec!=""){
	             				text[6] =strSpec+";";
	             			}*/
							if(Ext.getCmp("Popu").getValue()!=""){
								text[6]="特殊人群:"+Ext.getCmp("Popu").getValue()+"。";
							}
							var sexE=formSearch.getForm().getValues()["PHINSTSex"]
							var sex=""
							switch(sexE){
								case'M':sex="男";break;
								case'F':sex="女";break;
								case'A':sex="全部";break;								
							}									
							if(sex!="全部"){
								text[7]="性别："+sex+";";
							}
							if(Ext.getCmp("Key").getValue()!=""){
								text[8]="治疗手术:"+Ext.getCmp("Key").getValue()+";";
							}
							if(Ext.getCmp("TextKey0").getValue()!=""){
								text[9]="病症体征:"+Ext.getCmp("TextKey0").getValue()+";";
							}
							//alert(text[0]+"^"+text[1]+"^"+text[2]+"^"+text[3]+"^"+text[4]+"^"+text[5]+"^"+text[6]+"^"+text[7]+"^"+text[8]+"^"+text[10]+"^"+text[10]+"^"+text[12]+"^"+text[12])
	             			
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
			         var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
					 /**病症未选列表加载*/
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
		            /**特殊人群列表加载*/
		            PopuStr=""; //2017-03-24
		            RefreshPopuGrid(InstId,PopuStr)					   
				    /**治疗手术列表加载*/
		            KeyStr=""; //2016-08-09
					RefreshKeyGrid(InstId,KeyStr)	
					/**病症体征列表加载*/
		            Key0Str=""; //2017-03-24
		            RefreshKey0Grid(InstId,Key0Str)				   
		     	 }
			});
	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [formSearch,grid]
    });
	
	});
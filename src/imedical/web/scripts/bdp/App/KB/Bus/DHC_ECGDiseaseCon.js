/// 名称:知识库业务表 - 禁忌症
/// 编写者:基础平台组 - 高姗姗
/// 编写日期:2014-12-5
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCECGDiseaseC&pClassQuery=GetListCon";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCECGDiseaseC&pClassMethod=OpenConData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCECGDiseaseC&pClassMethod=SaveConData&pEntityName=web.Entity.KB.DHCECGDiseaseC";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCECGDiseaseC&pClassMethod=UpdateConData&pEntityName=web.Entity.KB.DHCECGDiseaseC";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCECGDiseaseC&pClassMethod=DeleteConData";
	var QUERY_UnSelDisea_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassQuery=GetUnSelDiseaList";
	var ACTION_URL_Disea = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDisease&pClassQuery=GetDiseaList";
	var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDisease&pClassMethod=DeleteDiseaData";
	var QUERY_UnSelExam_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCExamineFeild&pClassQuery=GetUnSelExamList";
	var ACTION_URL_Exam = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLibExaItm&pClassQuery=GetExamList";
	var DELETE_Exam_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLibExaItm&pClassMethod=DeleteExamData";
	
	var BindingGen="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb1";
	var BindingUom = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtUom&pClassQuery=GetDataForCmb1";
	var BindingPhy= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPhysiologyFeild&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pageSize_Disea = Ext.BDP.FunLib.PageSize.Pop;
	var pageSize_Exam = Ext.BDP.FunLib.PageSize.Pop;
	Ext.form.Field.prototype.msgTarget = 'under';                         //--------设置消息提示方式为在下边显示
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
	var checkRowId="";
	var diseaStr="";
	var examStr="";
	/*var text = new Array();
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
	}*/
	//---级别
	var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","ELECTContr");
	var PHINSTMode = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel : '级别',
		name : 'PHINSTMode',
		hiddenName : 'PHINSTMode',
		id:'Mode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Mode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Mode')),
		editable:false,
		width : 200,
		mode : 'local',
		triggerAction : 'all',// query
		value:mode,
		valueField : 'value',
		displayField : 'name',
		store:new Ext.data.SimpleStore({
			fields:['value','name'],
			data:[
				      ['W','警示'],
				      ['C','管控'],
				      ['S','统计']
			     ]
		})
	});
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
			gridUnSelDisea.getStore().baseParams={diseaStr:diseaStr };//2016-08-09
			gridUnSelDisea.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_Disea
				}
			});
		}
	});	
	var UnSelDiseaText = new Ext.BDP.FunLib.Component.TextField({
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
        height:360,        
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
		dataIndex:'PHDDDiseaDr'
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
	        	WinDisea.setPosition(620,0);
	        	WinExam.hide();
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
        displayMsg: '',//显示第 {0} 条到 {1} 条记录，一共 {2} 条
        emptyMsg: "",//没有记录
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
		width:400,
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
	    /*if(diseaDescs!=""){
	    	text[0]="病症:"+diseaDescs+";";
	    }else{
	    	text[0]=""
	    }
		Ext.getCmp("PHINSTTextF").setValue(getStr(text));*/
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
				   /* if(diseaDescs!=""){
				    	text[0]="病症:"+diseaDescs+";";
				    }else{
				    	text[0]=""
				    }
					Ext.getCmp("PHINSTTextF").setValue(getStr(text));*/
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
								    /*if(diseaDescs!=""){
								    	text[0]="病症:"+diseaDescs+";";
								    }else{
								    	text[0]=""
								    }
									Ext.getCmp("PHINSTTextF").setValue(getStr(text));*/
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
	/**************************************检查结果多选开始*****************************************/	
/** ---------检查结果未选列表内容部分------------* */
	var dsUnSelExam = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelExam_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'ExaRowId', mapping:'ExaRowId',type: 'string'},
	  	{ name: 'ExaCode', mapping:'ExaCode',type: 'string'},
        { name: 'ExaResult', mapping:'ExaResult',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelExam
	});
	dsUnSelExam.on('beforeload',function(thiz,options){ 
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     examStr:examStr //2016-08-09
		  }   
		)
	});
	dsUnSelExam.load({
		params : {
			start : 0,
			limit : pageSize_Exam
		},
		callback : function(records, options, success) {
		}
	});
	var UnSelExamSearch = new Ext.Button({
		id : 'UnSelExamSearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelExam.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelExamText").getValue(),
       			examStr:examStr //2016-08-09
       		};
			gridUnSelExam.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Exam
					}
			});
		}
	});	
	var UnSelExamRefresh = new Ext.Button({
		id : 'UnSelExamRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelExamText").reset();                    
			gridUnSelExam.getStore().baseParams={examStr:examStr };//2016-08-09
			gridUnSelExam.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_Exam
				}
			});
		}
	});	
	var UnSelExamText = new Ext.BDP.FunLib.Component.TextField({
		id : 'UnSelExamText',
		enableKeyEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelExam.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelExamText").getValue(),
       			examStr:examStr //2016-08-09
       		};
			gridUnSelExam.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Exam
					}
				});
	        }
		}						
	})
	var unSelExamtb = new Ext.Toolbar({
		id : 'unSelExamtb',
		items : [UnSelExamSearch, UnSelExamText, '->' ,UnSelExamRefresh]
	});
	var pagingUnSelExam= new Ext.PagingToolbar({
            pageSize: pageSize_Exam,
            store: dsUnSelExam,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_Exam=this.pageSize;
				         }
		        }
        })	
	var smUnSelExam = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelExam = new Ext.grid.GridPanel({
		id:'gridUnSelExam',
		closable:true,
	    store: dsUnSelExam,
	    trackMouseOver: true,
	    columns: [
	            smUnSelExam,
	            { header: 'ExaRowId', width: 200, sortable: true, dataIndex: 'ExaRowId',hidden:true }, 
	            { header: '代码', width: 200, sortable: true, dataIndex: 'ExaCode',hidden:true },
	            { header: '检查结果', width: 200, sortable: true, dataIndex: 'ExaResult' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : unSelExamtb, 
		bbar:pagingUnSelExam,
	    stateId: 'gridUnSelExam'
	});
	var WinExam=new Ext.Window({  
        id:'WinExam',  
        width:240,  
        height:360,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'检查结果',  
        items:gridUnSelExam  
    }); 
	//---检查结果
	var PHDISLExam = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '检查结果',
		name : 'PHDDExamDr',
		id : 'Exam',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Exam'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Exam')),
		dataIndex:'PHDDExamDr'
	});
	var BtnExam = new Ext.Button({
		id : 'btnExam',  
        text : '...',  
        tooltip : '检查结果未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**检查结果未选列表加载*/
	        	var InstId="";
			    if(typeof(grid)!="undefined"){
			    	if(grid.getSelectionModel().getCount()!=0){
			    		var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
			    	}
			    }
			    dsUnSelExam.load({
					params : {
						'InstId':InstId,
						examStr:examStr, //2016-08-09
						start : 0,
						limit : pageSize_Exam
					}
			    });
	        	WinExam.setPosition(620,0);
	        	WinDisea.hide();
	        	WinExam.show();
	        }  
        }  
	});
		/** ---------检查结果维护表单内容部分------------* */
	var dsExam = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Exam}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'EXAIExamDr', mapping:'EXAIExamDr',type: 'string'},
	  	{ name: 'ExaCode', mapping:'ExaCode',type: 'string'},
        { name: 'ExaResult', mapping:'ExaResult',type: 'string'},
        { name: 'EXAIRowId', mapping:'EXAIRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsExam
	});
	dsExam.on('beforeload',function(thiz,options){ 
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
	dsExam.load({
		params : {
			start : 0,
			limit : pageSize_Exam
		},
		callback : function(records, options, success) {
		}
	});
	var pagingExam= new Ext.PagingToolbar({
        pageSize: pageSize_Exam,
        store: dsExam,
        displayInfo: true,
        displayMsg: '',//显示第 {0} 条到 {1} 条记录，一共 {2} 条
        emptyMsg: "",//没有记录
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_Exam=this.pageSize;
			         }
	        }
    });	
	var smExam = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridExam = new Ext.grid.GridPanel({
		id:'gridExam',
		region: 'center',
		title:'检查结果明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsExam,
	    trackMouseOver: true,
	    columns: [
	            smExam,
	            { header: 'EXAIExamDr', width: 200, sortable: true, dataIndex: 'EXAIExamDr',hidden:true },
	            { header: 'EXAIRowId', width: 200, sortable: true, dataIndex: 'EXAIRowId',hidden:true },
	            { header: '代码', width: 200, sortable: true, dataIndex: 'ExaCode' },
	            { header: '检查结果', width: 200, sortable: true, dataIndex: 'ExaResult' }, 
	            {
				header : '操作',
				dataIndex : 'EXAIRowId',
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
		bbar:pagingExam ,
	    stateId: 'gridExam'
	});
	gridUnSelExam.on("rowdblclick", function(grid, rowIndex, e){
		var _record = new Ext.data.Record({
			'EXAIRowId':'',
			'EXAIExamDr':gridUnSelExam.getSelectionModel().getSelections()[0].get('ExaRowId'),
	 		'ExaCode':gridUnSelExam.getSelectionModel().getSelections()[0].get('ExaCode'),
	 		'ExaResult':gridUnSelExam.getSelectionModel().getSelections()[0].get('ExaResult')
	 	});
	 	gridExam.stopEditing();
	 	dsExam.insert(0,_record); 
	 	if (examStr!=""){
	 		examStr=examStr+"^<"+gridUnSelExam.getSelectionModel().getSelections()[0].get('ExaCode')+">";
	 	}else{
	 		examStr="<"+gridUnSelExam.getSelectionModel().getSelections()[0].get('ExaCode')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelExam.getSelectionModel().getSelected();
	 	dsUnSelExam.remove(myrecord);
	 	//页面检查结果框显示值
	 	var ExamDescs="";
	    dsExam.each(function(record){
	    	if(ExamDescs==""){
	    		ExamDescs = record.get('ExaResult');
	    	}else{
	    		ExamDescs = ExamDescs+","+record.get('ExaResult');
	    	}
	    }, this);
	    Ext.getCmp("Exam").setValue(ExamDescs);
	    /*if(ExamDescs!=""){
	    	text[1]="检查结果:"+ExamDescs+";";
	    }else{
	    	text[1]="";
	    }
		Ext.getCmp("PHINSTTextF").setValue(getStr(text));*/
	});
	gridExam.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 		var EXAIRowId = gridExam.getSelectionModel().getSelections()[0].get('EXAIRowId');
	 		if(EXAIRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'ExaRowId':gridExam.getSelectionModel().getSelections()[0].get('EXAIExamDr'),
			 		'ExaCode':gridExam.getSelectionModel().getSelections()[0].get('ExaCode'),
			 		'ExaResult':gridExam.getSelectionModel().getSelections()[0].get('ExaResult')
			 	});
			 	gridUnSelExam.stopEditing();
			 	dsUnSelExam.insert(0,_record);
			 	//已选列表删除
			 	examStr=examStr.replace("<"+gridExam.getSelectionModel().getSelections()[0].get('ExaCode')+">","");//2016-08-09
	 			var myrecord=gridExam.getSelectionModel().getSelected();
			 	dsExam.remove(myrecord);
	 			//页面检查结果框显示值
	 			var ExamDescs="";
			    dsExam.each(function(record){
			    	if(ExamDescs==""){
			    		ExamDescs = record.get('ExaResult');
			    	}else{
			    		ExamDescs = ExamDescs+","+record.get('ExaResult');
			    	}
			    }, this);
			    Ext.getCmp("Exam").setValue(ExamDescs);
			    /*if(ExamDescs!=""){
			    	text[1]="检查结果:"+ExamDescs+";";
			    }else{
			    	text[1]="";
			    }
				Ext.getCmp("PHINSTTextF").setValue(getStr(text));*/
	 		}else{
	 			var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
				Ext.Ajax.request({
					url : DELETE_Exam_URL,
					method : 'POST',
					params : {
						'id' : EXAIRowId
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
								if(gridExam.getSelectionModel().getCount()!='0'){
									var id = gridExam.getSelectionModel().getSelections()[0].get('EXAIRowId');
								}
								/**检查结果未选列表加载*/
								var _record = new Ext.data.Record({
									'ExaRowId':gridExam.getSelectionModel().getSelections()[0].get('EXAIExamDr'),
							 		'ExaCode':gridExam.getSelectionModel().getSelections()[0].get('ExaCode'),
							 		'ExaResult':gridExam.getSelectionModel().getSelections()[0].get('ExaResult')
							 	});
							 	gridUnSelExam.stopEditing();
							 	dsUnSelExam.insert(0,_record);

						        /**检查结果明细加载*/
							   var myrecord=gridExam.getSelectionModel().getSelected();
	 						   dsExam.remove(myrecord);
	 						   //页面检查结果框显示值
								var ExamDescs="";
							    dsExam.each(function(record){
							    	if(ExamDescs==""){
							    		ExamDescs = record.get('ExaResult');
							    	}else{
							    		ExamDescs = ExamDescs+","+record.get('ExaResult');
							    	}
							    }, this);
							    Ext.getCmp("Exam").setValue(ExamDescs);
							    /*if(ExamDescs!=""){
							    	text[1]="检查结果:"+ExamDescs+";";
							    }else{
							    	text[1]="";
							    }
								Ext.getCmp("PHINSTTextF").setValue(getStr(text));*/
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

	//---检验项目
	var LABILabDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel:'检验项目',
		name : 'LABILabDr',
		id : 'LabDr',
		hiddenName : 'LABILabDr',
		width:350,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LabDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LabDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEGRowId',
		displayField : 'PHEGDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingGen,
			baseParams:{code:'LAB'},
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEGRowId',
			fields : ['PHEGRowId', 'PHEGDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEGRowId',
				direction : 'ASC'
			}
		}),
		listeners:{
			'select':function(){
				if(Ext.getCmp('LabDr').getValue()!=""){
					Ext.getCmp('LABIMinVal').enable();
					Ext.getCmp('LABIMaxVal').enable();
					Ext.getCmp('UomDr').enable();
				}		
			},
			'blur':function(){
				if(Ext.getCmp('LabDr').getValue()==""){
					Ext.getCmp('LABIMinVal').disable();
					Ext.getCmp('LABIMaxVal').disable();
					Ext.getCmp('UomDr').disable();
				}	
			}
		}
	});
	//---检验指标最小值
	var LABIMinVal= new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '指标值',
		name : 'LABIMinVal',
		id : 'LABIMinVal',
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LABIMinVal'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LABIMinVal')),
		dataIndex : 'LABIMinVal',
		minValue : 0
	});
	//---检验指标最大值
	var LABIMaxVal= new Ext.BDP.FunLib.Component.TextField({ 
		name : 'LABIMaxVal',
		id : 'LABIMaxVal',
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LABIMaxVal'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LABIMaxVal')),
		dataIndex : 'LABIMaxVal',
		minValue : 0
	});
	//---检验指标单位
	var LABIUomDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		name : 'LABIUomDr',
		id : 'UomDr',
		disabled:true,
		hiddenName : 'LABIUomDr',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('UomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('UomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		queryParam : "desc",
		mode : 'remote',
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		minChars : 0,
		listWidth : 230,
		valueField : 'PHEURowId',
		displayField : 'PHEUDesc',
		store : new Ext.data.JsonStore({
			autoLoad : true,
			url : BindingUom,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'PHEURowId',
			fields : ['PHEURowId', 'PHEUDesc'],
			remoteSort : true,
			sortInfo : {
				field : 'PHEURowId',
				direction : 'ASC'
			}
		})
	});
	//--生理参数
	var PHYVFeildDr = new Ext.BDP.FunLib.Component.BaseComboBox({
		fieldLabel : '生理参数',
		hiddenName : 'PHYVFeildDr',
		id:'FeildDr',
		width:350,
		pageSize : Ext.BDP.FunLib.PageSize.Combo,
		loadByIdParam : 'rowid',
		listWidth:250,
		//allowBlank:false,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('FeildDr'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FeildDr')),
		store : new Ext.data.Store({
					autoLoad: true,
					proxy : new Ext.data.HttpProxy({ url : BindingPhy}),
					reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{ name:'PHYFRowId',mapping:'PHYFRowId'},
					{name:'PHYFDesc',mapping:'PHYFDesc'} ])
			}),
		mode : 'local',
		shadow:false,
		queryParam : 'desc',
		forceSelection : true,
		selectOnFocus : false,
		typeAhead : true,
		displayField : 'PHYFDesc',
		valueField : 'PHYFRowId',
		listeners:{
			'select':function(){
				if(Ext.getCmp('FeildDr').getValue()!=""){
					Ext.getCmp('PHYVMinVal').enable();
					Ext.getCmp('PHYVMaxVal').enable();
				}		
			},
			'blur':function(){
				if(Ext.getCmp('FeildDr').getValue()==""){
					Ext.getCmp('PHYVMinVal').disable();
					Ext.getCmp('PHYVMaxVal').disable();
				}		
			}
		}
	});
	//--生理参数下限
	var PHYVMinVal= new Ext.BDP.FunLib.Component.TextField({
		fieldLabel:'生理参数下限',
		xtype : 'numberfield',
		name : 'PHYVMinVal',
		id:'PHYVMinVal',
		width:350,
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHYVMinVal'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHYVMinVal'))
	});
	//--生理参数上限
	var PHYVMaxVal= new Ext.BDP.FunLib.Component.TextField({
		fieldLabel:'生理参数上限',
		xtype : 'numberfield',
		name : 'PHYVMaxVal',
		id:'PHYVMaxVal',
		width:350,
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHYVMaxVal'),
		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHYVMaxVal'))
	});
	var formSearch = new Ext.form.FormPanel({
				title:'禁忌症表单',
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
				//bodyStyle:'padding:5px 5px 0',
				//baseCls:'x-plain',
				buttonAlign:'center',
				labelAlign : 'right',
				labelWidth : 90,
				reader: new Ext.data.JsonReader({root:'data'},
		                             [
                                        {name: 'PHDDRowId',mapping:'PHDDRowId',type:'string'},
                                        {name: 'PHDDInstDr',mapping:'PHDDInstDr',type:'string'},
                                        {name: 'PHDDDiseaDr',mapping:'PHDDDiseaDr',type:'string'},
                                        {name: 'PHDDExamDr',mapping:'PHDDExamDr',type:'string'},
                                        {name: 'PHYVFeildDr',mapping:'PHYVFeildDr',type:'string'},//生理参数
                                        {name: 'PHYVMinVal',mapping:'PHYVMinVal',type:'string'},//生理参数下限
                                        {name: 'PHYVMaxVal',mapping:'PHYVMaxVal',type:'string'},//生理参数上限
                                        {name : 'LABILabDr',mapping : 'LABILabDr',type : 'string'},//检验条目
										{name : 'LABIMinVal',mapping : 'LABIMinVal',type : 'string'},//检验指标最小值
										{name : 'LABIMaxVal',mapping : 'LABIMaxVal',type : 'string'},//检验指标最大值
										{name : 'LABIUomDr',mapping : 'LABIUomDr',type : 'string'},//检验指标单位
										
										{name: 'PHINSTMode',mapping:'PHINSTMode',type:'string'},
                                        {name: 'PHINSTText',mapping:'PHINSTText',type:'string'},
                                        
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
							fieldLabel : 'PHDDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHDDRowId'
						},{
							fieldLabel : 'PHDDInstDr',
							hideLabel : 'True',
							hidden : true,
							name : 'PHDDInstDr'
						},PHINSTMode,{
							xtype : 'fieldset',
							title : '病症',
							width:400,
							autoHeight : true,
							style:'margin-left:50px', 
							items:[{layout : 'column',
							border : false,
							items : [{
									width:265,
									layout : 'form',
									labelWidth : 50,
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
							xtype : 'fieldset',
							title : '检查结果',
							width:400,
							autoHeight : true,
							style:'margin-left:50px', 
							items:[{layout : 'column',
							border : false,
							items : [{
									width:265,
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
									items : [PHDISLExam]
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
									items : [BtnExam]
								}]},gridExam]
						},PHYVFeildDr,PHYVMinVal,PHYVMaxVal,LABILabDr,
						{
							layout : 'column',
							border : false,
							items:[{
									width:190,
									layout : 'form',
									labelWidth : 80,
									labelPad : 1,// 默认5
									border : false,
									style:'margin-left:12px', 
									defaults : {
										anchor : '96%',
										xtype : 'textfield',
										msgTarget : 'under'
									},
									items : [LABIMinVal]
								},{
									width:10,
									layout : 'form',
									labelWidth : 5,
									labelPad : 1,// 默认5
									border : false,
									defaults : {
										anchor : '96%'
									},
									items : [{xtype:'label',fieldLabel:'-',labelSeparator:''}]
								},{
									width:110,
									layout : 'form',
									labelWidth : 5,
									labelPad : 1,// 默认5
									border : false,
									defaults : {
										anchor : '96%',
										xtype : 'textfield',
										msgTarget : 'under'
									},
									items : [LABIMaxVal]
								},{
									width:127,
									layout : 'form',
									labelWidth : 10,
									labelPad : 1,// 默认5
									border : false,
									defaults : {
										anchor : '96%',
										msgTarget : 'under'
									},
									items : [LABIUomDr]
								}]	
						},{
							fieldLabel:'描述',
							xtype : 'textarea',
							name : 'PHINSTText',
							id:'PHINSTTextF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF')),
   							width:350,
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
		      			if(Ext.getCmp('PHINSTTextF').getValue()==""){//getStr(text)==""
		      	 			Ext.Msg.show({ title : '提示', msg : '请填写描述!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		          	 		return;
		      	 		}
		      			//病症赋值
		    			var diseastr="";
					    dsDisea.each(function(record){
							if(diseastr==""){
					    		diseastr = record.get('PHDDDiseaDr');
					    	}else{
					    		diseastr = diseastr+","+record.get('PHDDDiseaDr');
					    	}
					    }, this);
					    Ext.getCmp("Disea").setValue(diseastr);
					    //检查结果赋值
		    			var examstr="";
					    dsExam.each(function(record){
					    	if(examstr==""){
					    		examstr = record.get('EXAIExamDr');
					    	}else{
					    		examstr = examstr+","+record.get('EXAIExamDr');
					    	}
					    }, this);
					    Ext.getCmp("Exam").setValue(examstr);
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
										'PHINSTSysFlag' :"Y"
									
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										//text.length=0;
										Ext.getCmp('LABIMinVal').disable();
										Ext.getCmp('LABIMaxVal').disable();
										Ext.getCmp('UomDr').disable();
										Ext.getCmp('PHYVMinVal').disable();
										Ext.getCmp('PHYVMaxVal').disable();
										Ext.Msg.show({
													title : '提示',
													msg : '添加成功！',
													icon : Ext.Msg.INFO,
										
													buttons : Ext.Msg.OK,
														fn : function(btn) {
															diseaStr=""; //2016-08-09
															examStr=""; //2016-08-09
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
														   
														   dsUnSelExam.load({
																params : {
																	'InstId':"",
																	examStr:examStr, //2016-08-09
																	start : 0,
																	limit : pageSize_Exam
																}
															});
															WinExam.hide();
													        dsExam.load({
																params : {
																	'InstId':"",
																	start : 0,
																	limit : pageSize_Exam
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
					tooltip : '请选择一行后修改(Shift+D)',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdatePanel'),
					//disabled:true,
		      		handler: function (){
	      			if(Ext.getCmp('PHINSTTextF').getValue()==""){//getStr(text)==""
	      	 			Ext.Msg.show({ title : '提示', msg : '请填写描述!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
				    Ext.getCmp("Disea").setValue(diseastr);
				    //检查结果赋值
	    			var examstr="";
				    dsExam.each(function(record){
				    	if (record.get('EXAIRowId')==""){
					    	if(examstr==""){
					    		examstr = record.get('EXAIExamDr');
					    	}else{
					    		examstr = examstr+","+record.get('EXAIExamDr');
					    	}
				    	}
				    }, this);
				    Ext.getCmp("Exam").setValue(examstr);
		      		if (grid.selModel.hasSelection()) {
		      			formSearch.form.submit({
								url : UPDATE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
									'PHDDInstDr': checkRowId
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										//text.length=0;
										Ext.getCmp('LABIMinVal').disable();
										Ext.getCmp('LABIMaxVal').disable();
										Ext.getCmp('UomDr').disable();
										Ext.getCmp('PHYVMinVal').disable();
										Ext.getCmp('PHYVMaxVal').disable();
										var myrowid = "rowid=" + action.result.id;
										Ext.Msg.show({
													title : '提示',
													msg : '修改成功！',
													icon : Ext.Msg.INFO,
										
													buttons : Ext.Msg.OK,
														fn : function(btn) {
																	diseaStr=""; //2016-08-09
																	examStr=""; //2016-08-09
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
																   
																   dsUnSelExam.load({
																		params : {
																			'InstId':"",
																			examStr:examStr, //2016-08-09
																			start : 0,
																			limit : pageSize_Exam
																		}
																	});
																	WinExam.hide();
															        dsExam.load({
																		params : {
																			'InstId':"",
																			start : 0,
																			limit : pageSize_Exam
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
													//text.length=0;
													Ext.getCmp('LABIMinVal').disable();
													Ext.getCmp('LABIMaxVal').disable();
													Ext.getCmp('UomDr').disable();
													Ext.getCmp('PHYVMinVal').disable();
													Ext.getCmp('PHYVMaxVal').disable();
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
															diseaStr=""; //2016-08-09
															examStr=""; //2016-08-09
															grid.getStore().baseParams={
											      				TypeDr : "",
																GenDr: GenDr,
																PointerType:"Form",
																PointerDr:PointerDr
											      			};
															grid.getStore().load({
																		params : {
																			start : startIndex,
																			limit : pagesize_main
																		}
															});
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
														   
														   dsUnSelExam.load({
																params : {
																	'InstId':"",
																	examStr:examStr, //2016-08-09
																	start : 0,
																	limit : pageSize_Exam
																}
															});
															WinExam.hide();
													        dsExam.load({
																params : {
																	'InstId':"",
																	start : 0,
																	limit : pageSize_Exam
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
		      			//text.length=0;
		      			diseaStr=""; //2016-08-09
		      			examStr=""; //2016-08-09
		      			Ext.getCmp('LABIMinVal').disable();
						Ext.getCmp('LABIMaxVal').disable();
						Ext.getCmp('UomDr').disable();
						Ext.getCmp('PHYVMinVal').disable();
						Ext.getCmp('PHYVMaxVal').disable();
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
					   
					   dsUnSelExam.load({
							params : {
								'InstId':"",
								examStr:examStr, //2016-08-09
								start : 0,
								limit : pageSize_Exam
							}
						});
						WinExam.hide();
				        dsExam.load({
							params : {
								'InstId':"",
								start : 0,
								limit : pageSize_Exam
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
								},{
									name : 'PHDDRowId',
									mapping : 'PHDDRowId',
									type : 'string'
								}, {
									name : 'PHINSTText',
									mapping : 'PHINSTText',
									type : 'string'
								}
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
        		stripeRows: true,
        		split:true,
        		enableColumnMove: true,     //允许拖放列
	    		enableColumnResize: false,  //禁止改变列的宽度
        		autoScroll: true,
				title : '禁忌症',
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PHINSTRowId',
							sortable : true,
							dataIndex : 'PHINSTRowId',
							hidden : true
						},{
							header : 'PHDDRowId',
							sortable : true,
							dataIndex : 'PHDDRowId',
							hidden : true
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'PHINSTText'
						}],
				width:200,
        		viewConfig: {
					forceFit: true//自动延展每列的长度
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
					diseaStr=""; //2016-08-09
					examStr=""; //2016-08-09
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHINSTRowId'),
		                success : function(form,action) {
		                	if(action.result.data.LABILabDr!=""){
								Ext.getCmp('LABIMinVal').enable();
								Ext.getCmp('LABIMaxVal').enable();
								Ext.getCmp('UomDr').enable();
							}else{
								Ext.getCmp('LABIMinVal').disable();
								Ext.getCmp('LABIMaxVal').disable();
								Ext.getCmp('UomDr').disable();
							}
							if(action.result.data.PHYVFeildDr!=""){
								Ext.getCmp('PHYVMinVal').enable();
								Ext.getCmp('PHYVMaxVal').enable();
							}else{
								Ext.getCmp('PHYVMinVal').disable();
								Ext.getCmp('PHYVMaxVal').disable();
							}
							/**设置修改时描述的自动生成*/
							var diseaDescs="";
						    dsDisea.each(function(record){
						    	if(diseaDescs==""){
						    		diseaDescs = record.get('PHDISLDiseaDesc');
						    	}else{
						    		diseaDescs = diseaDescs+","+record.get('PHDISLDiseaDesc');
						    	}
						    }, this);
						    /*if(diseaDescs!=""){
								text[0]="病症:"+diseaDescs+";";
						    }*/
							var ExamDescs="";
						    dsExam.each(function(record){
						    	if(ExamDescs==""){
						    		ExamDescs = record.get('ExaResult');
						    	}else{
						    		ExamDescs = ExamDescs+","+record.get('ExaResult');
						    	}
						    }, this);
						    /*if(ExamDescs!=""){
								text[1]="检查结果:"+ExamDescs+";";
						    }*/
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		            var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
					 /**病症未选列表加载*/
			        dsUnSelDisea.load({
						params : {
							'InstId':InstId,
							diseaStr:diseaStr, //2016-08-09
							start : 0,
							limit : pageSize_Disea
						}
				   });
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
				    /**检查结果未选列表加载*/
			        dsUnSelExam.load({
						params : {
							'InstId':InstId,
							examStr:examStr, //2016-08-09
							start : 0,
							limit : pageSize_Exam
						}
				   });
			        /**检查结果明细加载*/
			        dsExam.load({
						params : {
							'InstId':InstId,
							start : 0,
							limit : pageSize_Exam
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
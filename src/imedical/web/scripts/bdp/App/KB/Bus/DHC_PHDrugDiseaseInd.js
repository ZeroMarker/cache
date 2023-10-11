/// 名称:知识库业务表 - 适应证
/// 编写者:基础平台组 - 谷雪萍
/// 编写日期:2014-12-4
Ext.override(Ext.form.BasicForm, {  
    findField: function (id) {  
        var field = this.items.get(id);  
        if (!field) {  
            this.items.each(function (f) {  
                if (f.isXType('radiogroup') || f.isXType('checkboxgroup')) {  
                    f.items.each(function (c) {  
                        if (c.isFormField && (c.dataIndex == id || c.id == id || c.getName() == id)) {  
                            field = c;  
                            return false;  
                        }  
                    });  
                }  
  
                if (f.isFormField && (f.dataIndex == id || f.id == id || f.getName() == id)) {  
                    field = f;  
                    return false;  
                }  
            });  
        }  
        return field || null;  
    }  
});
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassQuery=GetList";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassMethod=OpenIndData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassMethod=SaveIndData&pEntityName=web.Entity.KB.DHCPHDrugDiseaseI";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassMethod=UpdateIndData&pEntityName=web.Entity.KB.DHCPHDrugDiseaseI";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassMethod=DeleteData";
	//var Dis_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassQuery=GetDataForCmb1";
	var Age_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmb1";
	var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";
	var QUERY_UnSelDisea_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassQuery=GetUnSelDiseaList";
	var ACTION_URL_Disea = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassQuery=GetDiseaList";
	var DELETE_Disea_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugDiseaseI&pClassMethod=DeleteDiseaData";
	var UOM_DR_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmbYMD";
	
	//新加检验项目 2017-03-28
	var BindingGen="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb1";
	var BindingUom = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtUom&pClassQuery=GetDataForCmb1";
	
	//治疗手术、病症体征
	var QUERY_UnSelKey_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHKeyWord&pClassQuery=GetUnSelKeyList";
	var ACTION_URL_Key = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHKeyWord&pClassQuery=GetKeyList";
	var DELETE_Key_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHKeyWord&pClassMethod=DeleteKeyData";
	var pageSize_Key = Ext.BDP.FunLib.PageSize.Pop;
	var pageSize_Key0 = Ext.BDP.FunLib.PageSize.Pop;
	var KeyStr="";//2017-03-23
	var Key0Str="";//2017-03-23
	
	//细菌
	var QUERY_UnSelOrganism_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHBTOrganism&pClassQuery=GetUnSelOrganism";
	var ACTION_URL_Organism = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHBTOrganism&pClassQuery=GetOrganism";
	var DELETE_Organism_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHBTOrganism&pClassMethod=DeleteOrganismData";
	var pageSize_Organism = Ext.BDP.FunLib.PageSize.Pop;
	var OrganismStr="";//2017-03-23
	//菌属
	var QUERY_UnSelGenus_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHBtGenus&pClassQuery=GetUnSelGenus";
	var ACTION_URL_Genus = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHBtGenus&pClassQuery=GetGenus";
	var DELETE_Genus_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHBtGenus&pClassMethod=DeleteGenusData";
	var pageSize_Genus = Ext.BDP.FunLib.PageSize.Pop;
	var GenusStr="";//2017-03-23
	
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pageSize_Disea = Ext.BDP.FunLib.PageSize.Pop;
	
	Ext.QuickTips.init();   //--------启用悬浮提示
	Ext.form.Field.prototype.msgTarget = 'qtip';                         //--------设置消息提示方式为在下边显示
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
	var PointerType = Ext.BDP.FunLib.getParam("GlPPointerType"); 
	var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","Indic");
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
	//清空选中的表头全选框checkbox  
	 function clearCheckGridHead(grid){  
	  	var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');    
	     var hd = hd_checker.first();   
	     hd.removeClass('x-grid3-hd-checker-on'); 
	 } 
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
					limit : pageSize_Disea
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
								'PHDDRowId':'',
								'PHDDDiseaDr':this.get('PHDISLRowId'),
						 		'PHDISLDiseaCode':this.get('PHDISLDiseaCode'),
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
						 	//var myrecord=gridUnSelDisea.getSelectionModel().getSelected();
						 	dsUnSelDisea.remove(this);
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
						   		 text[0]="适应证:"+diseaDescs+";";
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
					text[0]="适应证:"+Ext.getCmp("Disea").getValue()+";";
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
	   		 text[0]="适应证:"+diseaDescs+";";
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
			   		 text[0]="适应证:"+diseaDescs+";";
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
							   		 text[0]="适应证:"+diseaDescs+";";
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
					text[6]="治疗手术:"+Ext.getCmp("Key").getValue()+";";
				}else{
					text[6]="";
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
	   		 text[6]="治疗手术:"+KeyDescs+";";
	    }else{
	    	text[6]="";
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
			   		 text[6]="治疗手术:"+KeyDescs+";";
			    }else{
			    	text[6]="";
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
							   		 text[6]="治疗手术:"+KeyDescs+";";
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
					text[7]="症状体征:"+Ext.getCmp("TextKey0").getValue()+";";
				}else{
					text[7]="";
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
	   		 text[7]="症状体征:"+KeyDescs+";";
	    }else{
	    	text[7]="";
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
			   		 text[7]="症状体征:"+KeyDescs+";";
			    }else{
			    	text[7]="";
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
							   		 text[7]="症状体征:"+KeyDescs+";";
							    }else{
							    	text[7]="";
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
	
/**************************************细菌多选开始*****************************************/	
/** ---------未选列表内容部分------------* */
	var dsUnSelOrganism = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelOrganism_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'BTORowId', mapping:'BTORowId',type: 'string'},
	  	{ name: 'BTOCode', mapping:'BTOCode',type: 'string'},
        { name: 'BTODesc', mapping:'BTODesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelOrganism
	});
	dsUnSelOrganism.on('beforeload',function(thiz,options){ 
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     OrganismStr:OrganismStr//2016-08-09
		     
		  }   
		)
	});
	dsUnSelOrganism.load({
		params : {
			start : 0,
			limit : pageSize_Organism
		},
		callback : function(records, options, success) {
		}
	});
	var UnSelOrganismSearch = new Ext.Button({
		id : 'UnSelOrganismSearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelOrganism.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelOrganismText").getValue(),
       			OrganismStr:OrganismStr //2016-08-09
       		};
			gridUnSelOrganism.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Organism
					}
			});
		}
	});	
	var UnSelOrganismRefresh = new Ext.Button({
		id : 'UnSelOrganismRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelOrganismText").reset();                    
			gridUnSelOrganism.getStore().baseParams={
				OrganismStr:OrganismStr
			};//2016-08-09
			gridUnSelOrganism.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_Organism
				}
			});
		}
	});	
	var UnSelOrganismText = new Ext.form.TextField({
		id : 'UnSelOrganismText',
		enableOrganismEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelOrganism.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelOrganismText").getValue(),
       			OrganismStr:OrganismStr //2016-08-09
       		};
			gridUnSelOrganism.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Organism
					}
				});
	        }
		}						
	})
	var UnSelOrganismtb = new Ext.Toolbar({
		id : 'UnSelOrganismtb',
		items : [UnSelOrganismSearch, UnSelOrganismText, '->' ,UnSelOrganismRefresh]
	});
	var pagingUnSelOrganism= new Ext.PagingToolbar({
            pageSize: pageSize_Organism,
            store: dsUnSelOrganism,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_Organism=this.pageSize;
				         }
		        }
        })	
	var smUnSelOrganism = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelOrganism = new Ext.grid.GridPanel({
		id:'gridUnSelOrganism',
		closable:true,
	    store: dsUnSelOrganism,
	    trackMouseOver: true,
	    columns: [
	            smUnSelOrganism,
	            { header: 'BTORowId', width: 200, sortable: true, dataIndex: 'BTORowId',hidden:true }, 
	            { header: '代码', width: 200, sortable: true, dataIndex: 'BTOCode',hidden:true },
	            { header: '描述', width: 200, sortable: true, dataIndex: 'BTODesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : UnSelOrganismtb, 
		bbar:pagingUnSelOrganism,
	    stateId: 'gridUnSelOrganism'
	});
	var WinOrganism=new Ext.Window({  
        id:'WinOrganism',  
        width:240,  
        height:380,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'细菌',  
        items:gridUnSelOrganism  
    }); 
	//---细菌
	var TextOrganism = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '细菌',
		name : 'PHORGOrgDr',
		id : 'Organism',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Organism'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Organism')),
		dataIndex:'PHORGOrgDr',
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("Organism").getValue()!=""){
					text[14]="细菌:"+Ext.getCmp("Organism").getValue()+";";
				}else{
					text[14]="";
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));	
			}		
		}
	});
	var BtnOrganism = new Ext.Button({
		id : 'btnOrganism',  
        text : '...',  
        tooltip : '细菌未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**细菌未选列表加载*/
	        	var InstId="";
			    if(typeof(grid)!="undefined"){
			    	if(grid.getSelectionModel().getCount()!=0){
			    		var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
			    	}
			    }
			    dsUnSelOrganism.load({
					params : {
						'InstId':InstId,
						OrganismStr:OrganismStr, //2016-08-09
						start : 0,
						limit : pageSize_Organism
					}
			    });
	        	WinOrganism.setPosition(610,0);
	        	WinOrganism.show();
	        }  
        }  
	});
		/** ---------细菌维护表单内容部分------------* */
	var dsOrganism = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Organism}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'PHORGOrgDr', mapping:'PHORGOrgDr',type: 'string'},
	  	{ name: 'BTOCode', mapping:'BTOCode',type: 'string'},
        { name: 'BTODesc', mapping:'BTODesc',type: 'string'},
        { name: 'PHORGRowId', mapping:'PHORGRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsOrganism
	});
	dsOrganism.on('beforeload',function(thiz,options){ 
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
	dsOrganism.load({
		params : {
			start : 0,
			limit : pageSize_Organism
		},
		callback : function(records, options, success) {
		}
	});
	var pagingOrganism= new Ext.PagingToolbar({
        pageSize: pageSize_Organism,
        store: dsOrganism,
        displayInfo: true,
        displayMsg: '',
        emptyMsg: "",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_Organism=this.pageSize;
			         }
	        }
    });	
	var smOrganism = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridOrganism = new Ext.grid.GridPanel({
		id:'gridOrganism',
		region: 'center',
		title:'细菌明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsOrganism,
	    trackMouseOver: true,
	    columns: [
	            smOrganism,
	            { header: 'PHORGOrgDr', width: 200, sortable: true, dataIndex: 'PHORGOrgDr',hidden:true },
	            { header: '代码', width: 200, sortable: true, dataIndex: 'BTOCode' },
	            { header: '描述', width: 200, sortable: true, dataIndex: 'BTODesc' }, 
	            {
				header : '操作',
				dataIndex : 'PHORGRowId',
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
		bbar:pagingOrganism ,
	    stateId: 'gridOrganism'
	});
	gridUnSelOrganism.on("rowdblclick", function(grid, rowIndex, e){
		var _record = new Ext.data.Record({
			'PHORGRowId':'',
			'PHORGOrgDr':gridUnSelOrganism.getSelectionModel().getSelections()[0].get('BTORowId'),
	 		'BTOCode':gridUnSelOrganism.getSelectionModel().getSelections()[0].get('BTOCode'),
	 		'BTODesc':gridUnSelOrganism.getSelectionModel().getSelections()[0].get('BTODesc')
	 	});
	 	gridOrganism.stopEditing();
	 	dsOrganism.insert(0,_record); 
	 	
	 	if (OrganismStr!=""){
	 		OrganismStr=OrganismStr+"^<"+gridUnSelOrganism.getSelectionModel().getSelections()[0].get('BTORowId')+">";
	 	}else{
	 		OrganismStr="<"+gridUnSelOrganism.getSelectionModel().getSelections()[0].get('BTORowId')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelOrganism.getSelectionModel().getSelected();
	 	dsUnSelOrganism.remove(myrecord);
	 	//页面细菌框显示值
	 	var BTODescs="";
	    dsOrganism.each(function(record){
	    	if(BTODescs==""){
	    		BTODescs = record.get('BTODesc');
	    	}else{
	    		BTODescs = BTODescs+","+record.get('BTODesc');
	    	}
	    }, this);
	    Ext.getCmp("Organism").setValue(BTODescs);
	    if(BTODescs!=""){
	   		 text[14]="细菌:"+BTODescs+";";
	    }else{
	    	text[14]="";
	    }
		//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	});
	gridOrganism.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 	  if (gridOrganism.selModel.hasSelection()) {
	 		var PHORGRowId = gridOrganism.getSelectionModel().getSelections()[0].get('PHORGRowId');
	 		if(PHORGRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'BTORowId':gridOrganism.getSelectionModel().getSelections()[0].get('PHORGOrgDr'),
			 		'BTOCode':gridOrganism.getSelectionModel().getSelections()[0].get('BTOCode'),
			 		'BTODesc':gridOrganism.getSelectionModel().getSelections()[0].get('BTODesc')
			 	});
			 	gridUnSelOrganism.stopEditing();
			 	dsUnSelOrganism.insert(0,_record);
			 	//已选列表删除
			 	OrganismStr=OrganismStr.replace("<"+gridOrganism.getSelectionModel().getSelections()[0].get('PHORGOrgDr')+">","");//2016-08-09
	 			var myrecord=gridOrganism.getSelectionModel().getSelected();
			 	dsOrganism.remove(myrecord);
	 			//页面细菌框显示值
	 			var BTODescs="";
			    dsOrganism.each(function(record){
			    	if(BTODescs==""){
			    		BTODescs = record.get('BTODesc');
			    	}else{
			    		BTODescs = BTODescs+","+record.get('BTODesc');
			    	}
			    }, this);
			    Ext.getCmp("Organism").setValue(BTODescs);
			    if(BTODescs!=""){
			   		 text[14]="细菌:"+BTODescs+";";
			    }else{
			    	text[14]="";
			    }
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	 		}else{
	 			var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
				Ext.Ajax.request({
					url : DELETE_Organism_URL,
					method : 'POST',
					params : {
						'id' : PHORGRowId
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
								else if((totalnum-1)%pageSize_Organism==0)//最后一页只有一条
								{
									var pagenum=grid.getStore().getCount();
									if (pagenum==1){ startIndex=startIndex-pageSize_Organism;}  //最后一页的时候,不是最后一页则还停留在这一页
								}
								if(gridOrganism.getSelectionModel().getCount()!='0'){
									var id = gridOrganism.getSelectionModel().getSelections()[0].get('PHORGRowId');
								}
								/**细菌未选列表加载*/
								var _record = new Ext.data.Record({
									'BTORowId':gridOrganism.getSelectionModel().getSelections()[0].get('PHORGOrgDr'),
							 		'BTOCode':gridOrganism.getSelectionModel().getSelections()[0].get('BTOCode'),
							 		'BTODesc':gridOrganism.getSelectionModel().getSelections()[0].get('BTODesc')
							 	});
							 	gridUnSelOrganism.stopEditing();
							 	dsUnSelOrganism.insert(0,_record);

						        /**细菌明细加载*/
							   var myrecord=gridOrganism.getSelectionModel().getSelected();
	 						   dsOrganism.remove(myrecord);
	 						   //页面细菌框显示值
								var BTODescs="";
							    dsOrganism.each(function(record){
							    	if(BTODescs==""){
							    		BTODescs = record.get('BTODesc');
							    	}else{
							    		BTODescs = BTODescs+","+record.get('BTODesc');
							    	}
							    }, this);
							    Ext.getCmp("Organism").setValue(BTODescs);
							    if(BTODescs!=""){
							   		 text[14]="细菌:"+BTODescs+";";
							    }else{
							    	text[14]="";
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
	
		//刷新细菌列表
	function RefreshOrganismGrid(inst,str)
	{
		/**细菌未选列表加载*/
	    dsUnSelOrganism.load({
			params : {
				'InstId':inst,
				OrganismStr:str, //2016-08-09
				start : 0,
				limit : pageSize_Organism
			}
	    });
        /**细菌明细加载*/
        dsOrganism.load({
			params : {
				'InstId':inst,
				start : 0,
				limit : pageSize_Organism
			},
			callback : function(records, options, success) {
			}
	   });
	}
	/**************************************细菌多选结束*****************************************/
	
/**************************************菌属多选开始*****************************************/	
/** ---------未选列表内容部分------------* */
	var dsUnSelGenus = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:QUERY_UnSelGenus_URL}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[{ name: 'BTGERowId', mapping:'BTGERowId',type: 'string'},
	  	{ name: 'BTGECode', mapping:'BTGECode',type: 'string'},
        { name: 'BTGEDesc', mapping:'BTGEDesc',type: 'string'}
		]),
		remoteSort: true
    });	
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsUnSelGenus
	});
	dsUnSelGenus.on('beforeload',function(thiz,options){ 
		if(typeof(grid)!="undefined"){
	    	if(grid.getSelectionModel().getCount()!=0){
	    		var	InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
	    	}
    	}
		Ext.apply(   
		  this.baseParams,   
		  {   
		     InstId:InstId,
		     GenusStr:GenusStr//2016-08-09
		     
		  }   
		)
	});
	dsUnSelGenus.load({
		params : {
			start : 0,
			limit : pageSize_Genus
		},
		callback : function(records, options, success) {
		}
	});
	var UnSelGenusSearch = new Ext.Button({
		id : 'UnSelGenusSearch',
		iconCls : 'icon-search',
		handler : function() {                                 
			gridUnSelGenus.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelGenusText").getValue(),
       			GenusStr:GenusStr //2016-08-09
       		};
			gridUnSelGenus.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Genus
					}
			});
		}
	});	
	var UnSelGenusRefresh = new Ext.Button({
		id : 'UnSelGenusRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UnSelGenusText").reset();                    
			gridUnSelGenus.getStore().baseParams={
				GenusStr:GenusStr
			};//2016-08-09
			gridUnSelGenus.getStore().load({                           
				params : {
					start : 0,
					limit : pageSize_Genus
				}
			});
		}
	});	
	var UnSelGenusText = new Ext.form.TextField({
		id : 'UnSelGenusText',
		enableGenusEvents : true,
		width:150,
		listeners : {
       	'keyup' : function(field, e){
       		gridUnSelGenus.getStore().baseParams={
       			desc :  Ext.getCmp("UnSelGenusText").getValue(),
       			GenusStr:GenusStr //2016-08-09
       		};
			gridUnSelGenus.getStore().load({									
				params : {
					start : 0,
					limit : pageSize_Genus
					}
				});
	        }
		}						
	})
	var UnSelGenustb = new Ext.Toolbar({
		id : 'UnSelGenustb',
		items : [UnSelGenusSearch, UnSelGenusText, '->' ,UnSelGenusRefresh]
	});
	var pagingUnSelGenus= new Ext.PagingToolbar({
            pageSize: pageSize_Genus,
            store: dsUnSelGenus,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pageSize_Genus=this.pageSize;
				         }
		        }
        })	
	var smUnSelGenus = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridUnSelGenus = new Ext.grid.GridPanel({
		id:'gridUnSelGenus',
		closable:true,
	    store: dsUnSelGenus,
	    trackMouseOver: true,
	    columns: [
	            smUnSelGenus,
	            { header: 'BTGERowId', width: 200, sortable: true, dataIndex: 'BTGERowId',hidden:true }, 
	            { header: '代码', width: 200, sortable: true, dataIndex: 'BTGECode',hidden:true },
	            { header: '描述', width: 200, sortable: true, dataIndex: 'BTGEDesc' }
	            ],
	    stripeRows: true,
		viewConfig: {
			forceFit: true
		},
		tbar : UnSelGenustb, 
		bbar:pagingUnSelGenus,
	    stateId: 'gridUnSelGenus'
	});
	var WinGenus=new Ext.Window({  
        id:'WinGenus',  
        width:240,  
        height:380,        
        autoHeight:false,  
        closeAction:"hide",  
        layout: 'fit',  
        plain: true,  
        title:'菌属',  
        items:gridUnSelGenus  
    }); 
	//---菌属
	var TextGenus = new Ext.BDP.FunLib.Component.TextField({
		fieldLabel : '菌属',
		name : 'PHGENGenusDr',
		id : 'Genus',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('Genus'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Genus')),
		dataIndex:'PHGENGenusDr',
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("Genus").getValue()!=""){
					text[15]="菌属:"+Ext.getCmp("Genus").getValue()+";";
				}else{
					text[15]="";
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));	
			}		
		}
	});
	var BtnGenus = new Ext.Button({
		id : 'btnGenus',  
        text : '...',  
        tooltip : '菌属未选列表',
        listeners : {  
	        'click' : function() {  
	        	/**菌属未选列表加载*/
	        	var InstId="";
			    if(typeof(grid)!="undefined"){
			    	if(grid.getSelectionModel().getCount()!=0){
			    		var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
			    	}
			    }
			    dsUnSelGenus.load({
					params : {
						'InstId':InstId,
						GenusStr:GenusStr, //2016-08-09
						start : 0,
						limit : pageSize_Genus
					}
			    });
	        	WinGenus.setPosition(610,0);
	        	WinGenus.show();
	        }  
        }  
	});
		/** ---------菌属维护表单内容部分------------* */
	var dsGenus = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_URL_Genus}),
        reader: new Ext.data.JsonReader({
        	totalProperty: 'total',
        	root: 'data',
        	successProperty :'success'
        },
	  	[
	  	{ name: 'PHGENGenusDr', mapping:'PHGENGenusDr',type: 'string'},
	  	{ name: 'BTGECode', mapping:'BTGECode',type: 'string'},
        { name: 'BTGEDesc', mapping:'BTGEDesc',type: 'string'},
        { name: 'PHGENRowId', mapping:'PHGENRowId',type: 'string'}
		]),
		remoteSort: true
    });	
    var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsGenus
	});
	dsGenus.on('beforeload',function(thiz,options){ 
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
	dsGenus.load({
		params : {
			start : 0,
			limit : pageSize_Genus
		},
		callback : function(records, options, success) {
		}
	});
	var pagingGenus= new Ext.PagingToolbar({
        pageSize: pageSize_Genus,
        store: dsGenus,
        displayInfo: true,
        displayMsg: '',
        emptyMsg: "",
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
			listeners : {
			          "change":function (t,p)
			         { 
			             pageSize_Genus=this.pageSize;
			         }
	        }
    });	
	var smGenus = new Ext.grid.CheckboxSelectionModel({singleSelect : true, checkOnly: false, width: 20});
    var gridGenus = new Ext.grid.GridPanel({
		id:'gridGenus',
		region: 'center',
		title:'菌属明细',
		width:400,
		height:180,
		//style:'margin-left:3px', 
		closable:true,
	    store: dsGenus,
	    trackMouseOver: true,
	    columns: [
	            smGenus,
	            { header: 'PHGENGenusDr', width: 200, sortable: true, dataIndex: 'PHGENGenusDr',hidden:true },
	            { header: '代码', width: 200, sortable: true, dataIndex: 'BTGECode' },
	            { header: '描述', width: 200, sortable: true, dataIndex: 'BTGEDesc' }, 
	            {
				header : '操作',
				dataIndex : 'PHGENRowId',
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
		bbar:pagingGenus ,
	    stateId: 'gridGenus'
	});
	gridUnSelGenus.on("rowdblclick", function(grid, rowIndex, e){
		var _record = new Ext.data.Record({
			'PHGENRowId':'',
			'PHGENGenusDr':gridUnSelGenus.getSelectionModel().getSelections()[0].get('BTGERowId'),
	 		'BTGECode':gridUnSelGenus.getSelectionModel().getSelections()[0].get('BTGECode'),
	 		'BTGEDesc':gridUnSelGenus.getSelectionModel().getSelections()[0].get('BTGEDesc')
	 	});
	 	gridGenus.stopEditing();
	 	dsGenus.insert(0,_record); 
	 	
	 	if (GenusStr!=""){
	 		GenusStr=GenusStr+"^<"+gridUnSelGenus.getSelectionModel().getSelections()[0].get('BTGERowId')+">";
	 	}else{
	 		GenusStr="<"+gridUnSelGenus.getSelectionModel().getSelections()[0].get('BTGERowId')+">";
	 	}  //2016-08-09
	 	//未选列表删除
	 	var myrecord=gridUnSelGenus.getSelectionModel().getSelected();
	 	dsUnSelGenus.remove(myrecord);
	 	//页面菌属框显示值
	 	var BTGEDescs="";
	    dsGenus.each(function(record){
	    	if(BTGEDescs==""){
	    		BTGEDescs = record.get('BTGEDesc');
	    	}else{
	    		BTGEDescs = BTGEDescs+","+record.get('BTGEDesc');
	    	}
	    }, this);
	    Ext.getCmp("Genus").setValue(BTGEDescs);
	    if(BTGEDescs!=""){
	   		 text[15]="菌属:"+BTGEDescs+";";
	    }else{
	    	text[15]="";
	    }
		//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	});
	gridGenus.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 	  if (gridGenus.selModel.hasSelection()) {
	 		var PHGENRowId = gridGenus.getSelectionModel().getSelections()[0].get('PHGENRowId');
	 		if(PHGENRowId==""){
	 			//未选列表新增
	 			var _record = new Ext.data.Record({
					'BTGERowId':gridGenus.getSelectionModel().getSelections()[0].get('PHGENGenusDr'),
			 		'BTGECode':gridGenus.getSelectionModel().getSelections()[0].get('BTGECode'),
			 		'BTGEDesc':gridGenus.getSelectionModel().getSelections()[0].get('BTGEDesc')
			 	});
			 	gridUnSelGenus.stopEditing();
			 	dsUnSelGenus.insert(0,_record);
			 	//已选列表删除
			 	GenusStr=GenusStr.replace("<"+gridGenus.getSelectionModel().getSelections()[0].get('PHGENGenusDr')+">","");//2016-08-09
	 			var myrecord=gridGenus.getSelectionModel().getSelected();
			 	dsGenus.remove(myrecord);
	 			//页面菌属框显示值
	 			var BTGEDescs="";
			    dsGenus.each(function(record){
			    	if(BTGEDescs==""){
			    		BTGEDescs = record.get('BTGEDesc');
			    	}else{
			    		BTGEDescs = BTGEDescs+","+record.get('BTGEDesc');
			    	}
			    }, this);
			    Ext.getCmp("Genus").setValue(BTGEDescs);
			    if(BTGEDescs!=""){
			   		 text[15]="菌属:"+BTGEDescs+";";
			    }else{
			    	text[15]="";
			    }
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
	 		}else{
	 			var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
				Ext.Ajax.request({
					url : DELETE_Genus_URL,
					method : 'POST',
					params : {
						'id' : PHGENRowId
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
								else if((totalnum-1)%pageSize_Genus==0)//最后一页只有一条
								{
									var pagenum=grid.getStore().getCount();
									if (pagenum==1){ startIndex=startIndex-pageSize_Genus;}  //最后一页的时候,不是最后一页则还停留在这一页
								}
								if(gridGenus.getSelectionModel().getCount()!='0'){
									var id = gridGenus.getSelectionModel().getSelections()[0].get('PHGENRowId');
								}
								/**菌属未选列表加载*/
								var _record = new Ext.data.Record({
									'BTGERowId':gridGenus.getSelectionModel().getSelections()[0].get('PHGENGenusDr'),
							 		'BTGECode':gridGenus.getSelectionModel().getSelections()[0].get('BTGECode'),
							 		'BTGEDesc':gridGenus.getSelectionModel().getSelections()[0].get('BTGEDesc')
							 	});
							 	gridUnSelGenus.stopEditing();
							 	dsUnSelGenus.insert(0,_record);

						        /**菌属明细加载*/
							   var myrecord=gridGenus.getSelectionModel().getSelected();
	 						   dsGenus.remove(myrecord);
	 						   //页面菌属框显示值
								var BTGEDescs="";
							    dsGenus.each(function(record){
							    	if(BTGEDescs==""){
							    		BTGEDescs = record.get('BTGEDesc');
							    	}else{
							    		BTGEDescs = BTGEDescs+","+record.get('BTGEDesc');
							    	}
							    }, this);
							    Ext.getCmp("Genus").setValue(BTGEDescs);
							    if(BTGEDescs!=""){
							   		 text[15]="菌属:"+BTGEDescs+";";
							    }else{
							    	text[15]="";
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
	
		//刷新菌属列表
	function RefreshGenusGrid(inst,str)
	{
		/**菌属未选列表加载*/
	    dsUnSelGenus.load({
			params : {
				'InstId':inst,
				GenusStr:str, //2016-08-09
				start : 0,
				limit : pageSize_Genus
			}
	    });
        /**菌属明细加载*/
        dsGenus.load({
			params : {
				'InstId':inst,
				start : 0,
				limit : pageSize_Genus
			},
			callback : function(records, options, success) {
			}
	   });
	}
	/**************************************菌属多选结束*****************************************/
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
	
	//---检验项目Ext.BDP.FunLib.Component.BaseComboBox
	var LABILabDr = new Ext.BDP.Component.form.ComboBox({
		fieldLabel:'检验项目',
		name : 'LABILabDr',
		id : 'LabDr',
		hiddenName : 'LABILabDr',
		width:300,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LabDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LabDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
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
		/*listeners:{
			'select':function(){
				if(Ext.getCmp('LabDr').getValue()!="")
				{
					Ext.getCmp('LABIMinVal').enable();
					Ext.getCmp('LABIMaxVal').enable();
					Ext.getCmp('UomDr').enable();
					text[8]="检验项目："+Ext.getCmp("LabDr").getRawValue()
				}
				else
				{
					text[8]=""
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
			},
			'blur':function(){
				if(Ext.getCmp('LabDr').getValue()==""){
					Ext.getCmp('LABIMinVal').disable();
					Ext.getCmp('LABIMaxVal').disable();
					Ext.getCmp('UomDr').disable();
				}
			}
		}*/
		listeners:{
			'select':function(){
				if(Ext.getCmp('LabDr').getValue()!=""){
					Ext.getCmp('LABIRelationF').enable();
					Ext.getCmp('LABIMinVal').enable();
					Ext.getCmp('LABIMaxVal').enable();
					Ext.getCmp('UomDr').enable();
				}
			},
			'blur':function(){
				if(Ext.getCmp('LabDr').getValue()==""){
					Ext.getCmp('LABIRelationF').disable();
					Ext.getCmp('LABIMinVal').disable();
					Ext.getCmp('LABIMaxVal').disable();
					Ext.getCmp('UomDr').disable();
				}
			}
		}
	});
	//---检验指标最小值
	var LABIMinVal= new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '指标值范围',
		name : 'LABIMinVal',
		id : 'LABIMinVal',
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LABIMinVal'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LABIMinVal')),
		dataIndex : 'LABIMinVal',
		//minValue : 0,
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("LABIMinVal").getValue()!=""){
					text[9]=" "+Ext.getCmp("LABIMinVal").getValue()+"-"
				}else{
					text[9]=""
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
			}
		}	
	});
	//---检验指标最大值
	var LABIMaxVal= new Ext.BDP.FunLib.Component.TextField({ 
		name : 'LABIMaxVal',
		id : 'LABIMaxVal',
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('LABIMaxVal'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LABIMaxVal')),
		dataIndex : 'LABIMaxVal',
		//minValue : 0,
		listeners : {
			'blur' : function(){
				if(Ext.getCmp("LABIMaxVal").getValue()!=""){
					text[10]=Ext.getCmp("LABIMaxVal").getValue()
				}else{
					text[10]=""
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
			}
		}
	});
	
	//---检验指标单位
	var LABIUomDr = new Ext.form.ComboBox({
		name : 'LABIUomDr',
		id : 'UomDr',
		hiddenName : 'LABIUomDr',
		width:230,
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('UomDr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('UomDr')),
		triggerAction : 'all',// query
		forceSelection : true,
		selectOnFocus : false,
		//typeAhead : true,
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
		}),
		listeners:{
			'select':function(){
				if(Ext.getCmp('UomDr').getValue()!="")
				{
					text[11]=Ext.getCmp("UomDr").getRawValue()+";"
				}
				else
				{
					text[11]=""
				}
				//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
			}
		}
	});
	//给级别设置悬浮提示，表明各级别的意思
	function ShowTip(name){
		if(name=="管控"){
			return "不满足合理性检查时，不仅提示用户，而且不允许完成当前操作"
		}
		else if(name=="警示"){
			return "不满足合理性检查时，仅仅提示用户，但允许继续完成当前操作"
		}
		else{
			return "暂时还没应用"
		}
	}
	var tpl = '<div class="x-combo-list-item" ext:qtitle="" ext:qtip="'+ShowTip("警示")+'">警示</div>'
	+'<div class="x-combo-list-item" ext:qtitle="" ext:qtip="'+ShowTip("管控")+'">管控</div>'
	+'<div class="x-combo-list-item" ext:qtitle="" ext:qtip="'+ShowTip("统计")+'">统计</div>'; 	
	
				
	var formSearch = new Ext.form.FormPanel({
				title:'适应证表单',
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
                                        {name: 'PHINSTMode',mapping:'PHINSTMode',type:'string'},
                                        {name: 'PHDDDiseaDr',mapping:'PHDDDiseaDr',type:'string'},
                                        {name: 'PDAAgeDr',mapping:'PDAAgeDr',type:'string'},
                                        {name: 'PHINSTSex',mapping:'PHINSTSex',type:'string'},
                                        {name: 'PHINSTDocUseTips',mapping:'PHINSTDocUseTips',type:'string'},
                                        {name: 'PHINSTNote',mapping:'PHINSTNote',type:'string'},
                                        {name: 'PHINSTText',mapping:'PHINSTText',type:'string'},
                                        
                                        {name: 'PHINSTTypeDr',mapping:'PHINSTTypeDr',type:'string'},
                                        {name: 'PHINSTOrderNum',mapping:'PHINSTOrderNum',type:'string'},
                                        {name: 'PHINSTGenDr',mapping:'PHINSTGenDr',type:'string'},
                                        {name: 'PHINSTPointerDr',mapping:'PHINSTPointerDr',type:'string'},
                                        {name: 'PHINSTLibDr',mapping:'PHINSTLibDr',type:'string'},
                                        {name: 'PHINSTPointerType',mapping:'PHINSTPointerType',type:'string'},
                                        {name: 'PHINSTActiveFlag',mapping:'PHINSTActiveFlag',type:'string'},
                                        {name: 'PHINSTSysFlag',mapping:'PHINSTSysFlag',type:'string'},
                                         //新增检验条目 2017-03-28
                                       	{name : 'LABILabDr',mapping : 'LABILabDr',type : 'string'},//检验条目
                                       	{name : 'LABIRelation',mapping : 'LABIRelation',type : 'string'},//逻辑
										{name : 'LABIMinVal',mapping : 'LABIMinVal',type : 'string'},//检验指标最小值
										{name : 'LABIMaxVal',mapping : 'LABIMaxVal',type : 'string'},//检验指标最大值
										{name : 'LABIUomDr',mapping : 'LABIUomDr',type : 'string'},//检验指标单位、
										
                                        {name: 'PDAMinVal',mapping:'PDAMinVal',type:'string'},
                                        {name: 'PDAMaxVal',mapping:'PDAMaxVal',type:'string'},
                                        {name: 'PDAUomDr',mapping:'PDAUomDr',type:'string'},
                                        
                                        {name: 'PDCUKeyWordDr',mapping:'PDCUKeyWordDr',type:'string'},
                                        {name: 'PSYMKeyWordDr',mapping:'PSYMKeyWordDr',type:'string'},
                                        {name: 'PHORGOrgDr',mapping:'PHORGOrgDr',type:'string'},  //细菌
                                        {name: 'PHGENGenusDr',mapping:'PHGENGenusDr',type:'string'}  //菌属
                                        
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
							tpl :tpl, 
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
							title : '适应证',
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
							name:'PDAAgeDr',
							id:'PDAAgeDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							//listWidth:250,
							width:300,
							emptyText:'请选择',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('PDAAgeDrF'),
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
							triggerAction : 'all',
							//typeAhead : true,
							displayField : 'PDAAgeDesc',
							valueField : 'PDARowID',
							listeners : {
								'select' : function(){
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
							style:'margin-left:5px', 
							border : false,
							defaults : {
								anchor : '96%',
								msgTarget : 'under'
							},
							items : [UomDesc]
						}]	
				},{
							fieldLabel: '性别',
				    		xtype:'radiogroup',
				    		defaultType:'radio',
							name :'PHINSTSex',
							id:'PHINSTSexF',
							autoHeight:true,
							width:300,
							//layout:'column', //激活、未激活呈分列式排布,checked:true
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
											text[5]="性别："+sex+";";
											
											if(sex=="男"){
												var str=ss.replace(("女"),sex);
											}
											if(sex=="女"){
												var str=ss.replace("男",sex);
											}			
										}else{
											text[5]="";
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
							xtype : 'fieldset',
							title : '细菌',
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
									items : [TextOrganism]
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
									items : [BtnOrganism]
								}]},gridOrganism]
						},{
							xtype : 'fieldset',
							title : '菌属',
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
									items : [TextGenus]
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
									items : [BtnGenus]
								}]},gridGenus]
						},LABILabDr,{
							xtype : 'combo',
							fieldLabel : '逻辑',
							name : 'LABIRelation',
							hiddenName : 'LABIRelation',
							id:'LABIRelationF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LABIRelationF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LABIRelationF')),
							//editable:false,
							disabled:true,
							width:300,
							labelWidth:30,
							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['>','大于'],
									      ['<','小于'],
									      ['=','等于'],
									      ['!>','不大于'],
									      ['!<','不小于'],
									      ['<>','不等于']
								     ]
							})	
						},
						{
							layout : 'column',
							border : false,
							items:[{
									width:200,
									layout : 'form',
									labelWidth :102,
									labelPad : 1,// 默认5
									border : false,
									//style:'margin-left:10px', 
									defaults : {
										anchor : '96%',
										xtype : 'textfield',
										msgTarget : 'under'
									},
									items : [LABIMinVal]
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
									items : [LABIMaxVal]
								},{
									width:100,
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
							fieldLabel:'提示（医生）',
							xtype : 'textarea',
							name : 'PHINSTDocUseTips',
							id:'PHINSTDocUseTipsF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTDocUseTipsF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTDocUseTipsF')),
   							width:300,
   							listeners : {
								'blur' : function(){
									if(Ext.getCmp("PHINSTDocUseTipsF").getValue()!=""){
										text[12]="医生提示："+Ext.getCmp("PHINSTDocUseTipsF").getValue()+";";
									}else{
										text[12]="";
									}
									//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
                            }
						},{
							fieldLabel:'备注',
							xtype : 'textarea',
							name : 'PHINSTNote',
							id:'PHINSTNoteF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTNoteF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTNoteF')),
   							width:300,
   							listeners : {
								'blur' : function(){
									if(Ext.getCmp("PHINSTNoteF").getValue()!=""){
										text[13]="备注："+Ext.getCmp("PHINSTNoteF").getValue()+";";
									}else{
										text[13]="";
									}
									//Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
                            }
						},{
							fieldLabel:'描述',
							xtype : 'textarea',
							name : 'PHINSTText',
							id:'PHINSTTextF',
							//allowBlank : false,
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
					    
					  	//细菌赋值
		    			var strOrg="";
					    dsOrganism.each(function(record){
							if(strOrg==""){
					    		strOrg = record.get('PHORGOrgDr');
					    	}else{
					    		strOrg = strOrg+","+record.get('PHORGOrgDr');
					    	}
					    }, this);  
					    
					   //菌属赋值
		    			var strGenus="";
					    dsGenus.each(function(record){
							if(strGenus==""){
					    		strGenus = record.get('PHGENGenusDr');
					    	}else{
					    		strGenus = strGenus+","+record.get('PHGENGenusDr');
					    	}
					    }, this); 
					    //Ext.getCmp("Disea").setValue(diseastr);
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
										'PHDDDiseaDr':diseastr,
										'PDCUKeyWordDr':str1,
										'PSYMKeyWordDr':str0,
										'PHORGOrgDr':strOrg,
										'PHGENGenusDr':strGenus
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										Ext.getCmp('LABIRelationF').disable();
										Ext.getCmp('LABIMinVal').disable();
										Ext.getCmp('LABIMaxVal').disable();
										Ext.getCmp('UomDr').disable();
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
														   
														   	/**治疗手术列表加载*/
												            KeyStr=""; //2016-08-09
															RefreshKeyGrid("",KeyStr)	
														   
														   	/**病症体征列表加载*/
												            Key0Str=""; //2017-03-23
												            RefreshKey0Grid("",Key0Str)	
												            
														   	/**细菌列表加载*/
												            OrganismStr=""; //2017-04-11
												            RefreshOrganismGrid("",OrganismStr)		
														   	/**菌属列表加载*/
												            GenusStr=""; //2017-04-11
												            RefreshGenusGrid("",GenusStr)															            
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
		      			if(Ext.getCmp('PHINSTTextF').getValue()==""){
		      				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
				    //Ext.getCmp("Disea").setValue(diseastr);
					   //细菌赋值
		    			var strOrg="";
					    dsOrganism.each(function(record){
							if(strOrg==""){
					    		strOrg = record.get('PHORGOrgDr');
					    	}else{
					    		strOrg = strOrg+","+record.get('PHORGOrgDr');
					    	}
					    }, this);  
					    
					    //菌属赋值
		    			var strGenus="";
					    dsGenus.each(function(record){
							if(strGenus==""){
					    		strGenus = record.get('PHGENGenusDr');
					    	}else{
					    		strGenus = strGenus+","+record.get('PHGENGenusDr');
					    	}
					    }, this); 
		      			formSearch.form.submit({
								url : UPDATE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
									'PHDDInstDr': checkRowId,
									'PHDDDiseaDr':diseastr,
									'PDCUKeyWordDr':str1,
									'PSYMKeyWordDr':str0,
									'PHORGOrgDr':strOrg,
									'PHGENGenusDr':strGenus
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										Ext.getCmp('LABIRelationF').disable();
										Ext.getCmp('LABIMinVal').disable();
										Ext.getCmp('LABIMaxVal').disable();
										Ext.getCmp('UomDr').disable();
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
																PointerType:PointerType,
																PointerDr:PointerDr
											      			};
															grid.getStore().load({
																params : {
																		start : 0,
																		limit : pagesize_main
																		}
																	});
															diseaStr=""; //2017-03-23/2016-08-11
															dsUnSelDisea.load({
														 		params : {
														 			'InstId':"",
														 			diseaStr:diseaStr, //2017-03-23
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
														   
														   	/**治疗手术列表加载*/
												            KeyStr=""; //2017-03-23
															RefreshKeyGrid("",KeyStr)	
														   
														   	/**病症体征列表加载*/
												            Key0Str=""; //2017-03-23
												            RefreshKey0Grid("",Key0Str)	
												            
														   	/**细菌列表加载*/
												            OrganismStr=""; //2017-04-11
												            RefreshOrganismGrid("",OrganismStr)	
														   	/**菌属列表加载*/
												            GenusStr=""; //2017-04-11
												            RefreshGenusGrid("",GenusStr)													            
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
															grid.getStore().baseParams={
											      				TypeDr : "",
																GenDr: GenDr,
																PointerType:PointerType,
																PointerDr:PointerDr
											      			};
															grid.getStore().load({
																		params : {
																			start : startIndex,
																			limit : pagesize_main
																		}
																	});
															diseaStr=""; //2017-03-23/2016-08-11
															dsUnSelDisea.load({
															params : {
																'InstId':"",
																diseaStr:diseaStr, //2017-03-23
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
														   
														   	/**治疗手术列表加载*/
												            KeyStr=""; //2017-03-23
															RefreshKeyGrid("",KeyStr)	
														   
														   	/**病症体征列表加载*/
												            Key0Str=""; //2017-03-23
												            RefreshKey0Grid("",Key0Str)		
															
														   	/**细菌列表加载*/
												            OrganismStr=""; //2017-04-11
												            RefreshOrganismGrid("",OrganismStr)	
														   	/**菌属列表加载*/
												            GenusStr=""; //2017-04-11
												            RefreshGenusGrid("",GenusStr)													            
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
      					Ext.getCmp('LABIRelationF').disable();
						Ext.getCmp('LABIMinVal').disable();
						Ext.getCmp('LABIMaxVal').disable();
						Ext.getCmp('UomDr').disable();
		      			text.length=0;      			
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
						//病症
						diseaStr=""; //2017-03-23/2016-08-11
						dsUnSelDisea.load({
							params : {
								'InstId':"",
								diseaStr:diseaStr, //2017-03-23
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
					   
					   	/**治疗手术列表加载*/
			            KeyStr=""; //2017-03-23
						RefreshKeyGrid("",KeyStr)	
					   
					   	/**病症体征列表加载*/
			            Key0Str=""; //2016-08-09
			            RefreshKey0Grid("",Key0Str)	
			            
					   	/**细菌列表加载*/
			            OrganismStr=""; //2017-04-11
			            RefreshOrganismGrid("",OrganismStr)	
					   	/**菌属列表加载*/
			            GenusStr=""; //2017-04-11
			            RefreshGenusGrid("",GenusStr)				            
					}		      		
				}],
			listeners : {
				/*"afterrender" : function() {
						Ext.getCmp("PHINSTSexF").setValue("A");
				}*/
			}
				
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
				split:true,
        		stripeRows: true,
        		enableColumnMove: true,     //允许拖放列
	    		enableColumnResize: false,  //禁止改变列的宽度
        		autoScroll: true,
				title : '适应证',
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
				var InstId = grid.getSelectionModel().getSelections()[0].get('PHINSTRowId');
		        	/**清空所有表单数据包括病症列表*/
					Ext.getCmp("form-save").getForm().reset();
					
					/*text.length=0;
					WinDisea.hide();
				    dsDisea.load({
						params : {
								'InstId':"",
								start : 0,
								limit : pageSize_Disea
							}
					   });*/
					    /**重新加载数据*/
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHINSTRowId'),
		                success : function(form,action) {
		 					/**设置检验项目是否可用**/
							if(action.result.data.LABILabDr!=""){
								Ext.getCmp('LABIMinVal').enable();
								Ext.getCmp('LABIMaxVal').enable();
								Ext.getCmp('UomDr').enable();
								Ext.getCmp('LABIRelationF').enable();
							}else{
								Ext.getCmp('LabDr').getStore().reload();
								Ext.getCmp('LABIMinVal').disable();
								Ext.getCmp('LABIMaxVal').disable();
								Ext.getCmp('UomDr').disable();
								Ext.getCmp('LABIRelationF').disable();
							}	
							
		                	 /**设置修改时描述的自动生成*/
							/*if(Ext.getCmp("Disea").getValue()!=""){
								text[0]="适应证:"+Ext.getCmp("Disea").getValue()+";";
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
							var sexE=formSearch.getForm().getValues()["PHINSTSex"]
							var sex=""
							switch(sexE){
								case'M':sex="男";break;
								case'F':sex="女";break;
								case'A':sex="全部";break;								
							}									
							if(sex!="全部"){
								text[5]="性别："+sex+";";
							}
							if(Ext.getCmp("Key").getValue()!=""){
								text[6]="治疗手术:"+Ext.getCmp("Key").getValue()+";";
							}
							if(Ext.getCmp("TextKey0").getValue()!=""){
								text[7]="病症体征:"+Ext.getCmp("TextKey0").getValue()+";";
							}
							if(Ext.getCmp("LabDr").getValue()!=""){
								text[8]="检验项目："+Ext.getCmp("LabDr").getRawValue();
							}
							if(Ext.getCmp("LABIMinVal").getValue()!=""){
								text[9]=" "+Ext.getCmp("LABIMinVal").getValue()+"-";			
							}
							if(Ext.getCmp("LABIMaxVal").getValue()!=""){
								text[10]=Ext.getCmp("LABIMaxVal").getValue()
							}
							if(Ext.getCmp("UomDr").getValue()!=""){
								text[11]=Ext.getCmp("UomDr").getRawValue()+";"
							}
							if(Ext.getCmp("PHINSTDocUseTipsF").getValue()!=""){
								text[12]="医生提示："+Ext.getCmp("PHINSTDocUseTipsF").getValue()+";";
							}
							if(Ext.getCmp("PHINSTNoteF").getValue()!=""){
								text[13]="备注："+Ext.getCmp("PHINSTNoteF").getValue()+";";
							}*/
							//alert(text[0]+"^"+text[1]+"^"+text[2]+"^"+text[3]+"^"+text[4]+"^"+text[5]+"^"+text[7])

		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });            
			       
					 /**病症未选列表加载*/
		            diseaStr=""; //2016-08-09
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

				    /**治疗手术列表加载*/
		            KeyStr=""; //2017-03-23
					RefreshKeyGrid(InstId,KeyStr)	
					/**病症体征列表加载*/
		            Key0Str=""; //2017-03-24
		            RefreshKey0Grid(InstId,Key0Str)	
		            
					   	/**细菌列表加载*/
		            OrganismStr=""; //2016-08-09
		            RefreshOrganismGrid(InstId,OrganismStr)		
					   	/**菌属列表加载*/
		            GenusStr=""; //2016-08-09
		            RefreshGenusGrid(InstId,GenusStr)			            
       
			});
	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [formSearch,grid]
    });
	
	});
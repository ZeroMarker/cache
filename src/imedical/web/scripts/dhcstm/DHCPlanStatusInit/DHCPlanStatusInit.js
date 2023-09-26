// /名称: 科室类组采购审核级别维护
// /描述: 科室类组采购审核级别维护
// /编写者：zhangxiao
// /编写日期: 2014.03.18
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';	
	var groupId=session['LOGON.GROUPID'];
	var userId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var StatusGrpGridUrl="dhcstm.dhcplanstatusinitaction.csp"
	var Loc=null;
	

     //科室代码
        var locCode = new Ext.form.TextField({
					id:'locCode',
   				 allowBlank:true,
					anchor:'90%'
				});
     //科室名称
        var locName = new Ext.form.TextField({
					id:'locName',
    				allowBlank:true,
					anchor:'90%'
             });
    
	 // 安全组Store
		var PointerStore = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['Description', 'RowId'])
	});			
	// 安全组
		var SSGroup=new Ext.form.ComboBox({ 
			fieldLabel:'<font color=blue>安全组</font>',
			id : 'SSGroup',
			name : 'SSGroup',
			StkType:App_StkTypeCode,     //标识类组类型
			UserId:userId,
			LocId:gLocId,
			store : PointerStore,
	        valueField : 'RowId',
	        displayField : 'Description',
	        allowBlank : true,
	        triggerAction : 'all',
	        selectOnFocus : true,
	        forceSelection : true,
	        minChars : 1,
	        pageSize : 999,
	        listWidth : 250,
	        valueNotFoundText : '',
			emptyText : '安全组...',
			anchor : '90%'
		});
		
		
	SSGroup.on('beforequery', function(e){
		this.store.removeAll();
		var type="G"
		this.store.setBaseParam('Type',type);
		this.store.setBaseParam('filter',this.getRawValue());
		this.store.setBaseParam('Group',groupId);
		this.store.proxy=new Ext.data.HttpProxy({url : 'dhcstm.orgutil.csp?actiontype=GetSSPPoint',method:'POST'});
	    this.store.load({params:{start:0,limit:999}});
		});	
	
	// 审核状态
		var DHCPlanStatusStore = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['Description', 'RowId'])
	});			
	    
		var DHCPlanStatus=new Ext.form.ComboBox({ 
			fieldLabel:'<font color=blue>审核状态</font>',
			id : 'DHCPlanStatus',
			name : 'DHCPlanStatus',
			StkType:App_StkTypeCode,     //标识类组类型
			store : DHCPlanStatusStore,
	        valueField : 'RowId',
	        displayField : 'Description',
	        allowBlank : true,
	        triggerAction : 'all',
	        selectOnFocus : true,
	        forceSelection : true,
	        minChars : 1,
	        pageSize : 999,
	        listWidth : 250,
	        valueNotFoundText : '',
			emptyText : '审核状态...',
			anchor : '90%'
		});
		
		
	DHCPlanStatus.on('beforequery', function(e){
		this.store.removeAll();
		this.store.proxy=new Ext.data.HttpProxy({url : 'dhcstm.orgutil.csp?actiontype=GetPlanStatus',method:'POST'});
	    this.store.load({params:{start:0,limit:999}});
		});	
			
	var CTLocGrid=""
    //配置数据源
    var LocGridUrl="dhcstm.stkloccatgroupaction.csp"
    //var CTLocGridProxy= new Ext.data.HttpProxy({url:LocGridUrl+'?actiontype=QueryLoc&start=0&limit=999&groupId='+groupId+'&locDesc=',method:'GET'});
    var CTLocGridProxy= new Ext.data.HttpProxy({url:LocGridUrl+'?actiontype=QueryLoc',method:'GET'});
    var CTLocGridDs = new Ext.data.Store({
	    proxy:CTLocGridProxy,
        reader:new Ext.data.JsonReader({
            root:'rows',
		    totalProperty:'results'
        }, [
	    	{name:'Rowid'},
		    {name:'Code'},
		    {name:'Desc'}
	    ]),
        remoteSort:false,
        pruneModifiedRecords:true
    });
    
    //模型
    var CTLocGridCm = new Ext.grid.ColumnModel([
    	 new Ext.grid.RowNumberer(),
	   {
        header:"代码",
        dataIndex:'Code',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true
    }
    ]);

        //初始化默认排序功能
    CTLocGridCm.defaultSortable = true;
        var find = new Ext.Toolbar.Button({
	    text:'查询',
        tooltip:'查询',
        iconCls:'page_find',
    	width : 70,
	    height : 30,
	    handler:function(){
    		Query()
    	}
    });
    function Query(){
              
	    CTLocGridDs.load({params:{strFilter:Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue(),start:0,limit:CTLocPagingToolbar.pageSize,sort:'Rowid',dir:'desc',groupId:groupId}})
	    
    }
    var CTLocPagingToolbar = new Ext.PagingToolbar({
    store:CTLocGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='Rowid';
		B[A.dir]='desc';
		B['strFilter']=Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue();
		B['groupId']=groupId;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

	//采购级别grid
    CTLocGrid = new Ext.grid.EditorGridPanel({
	   store:CTLocGridDs,
	   cm:CTLocGridCm,
	   trackMouseOver:true,
	   region:'center',
	   height:690,
	   stripeRows:true,
	   sm:new Ext.grid.CellSelectionModel({}),
	   loadMask:true,
	   bbar:CTLocPagingToolbar,
	   tbar:['科室代码:',locCode,'科室名称:',locName,'-',find]
	   //clicksToEdit:1
    });
    CTLocGrid.addListener("rowclick",function(grid,rowindex,e){
	    var selectRow=CTLocGridDs.getAt(rowindex);
	     Loc=selectRow.get("Rowid");
	    StatusGrpGridDs.load({params:{Loc:Loc}});
	    });
   
    
	//配置数据源
	var DetailUrl =StatusGrpGridUrl+'?actiontype=Select';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
	    		url : DetailUrl,
	    		method : "POST"
	    });
		
    // 指定列参数
    var fields = ["InitRowId","DHCPlanStatus","DHCPlanStatusDesc","SSGroup","SSGroupDesc"];
    		
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
	    	root : 'rows',
	    	totalProperty : "results",
		    id : "RowId",
		    fields : fields
    });	
    // 数据集
    var StatusGrpGridDs = new Ext.data.Store({
	    	proxy : proxy,
	    	reader : reader,
	    	listeners:{
	    	'load':function(ds){
	    	 }
    	}
    });	
    
    //模型
    var nm = new Ext.grid.RowNumberer(); 
    var StatusGrpGridCm=new Ext.grid.ColumnModel([nm,{
        header : "InitRowId",
		dataIndex : 'InitRowId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	},{
	    header:"审核级别",
        dataIndex:'DHCPlanStatus',
        width:250,
        align:'left',
        sortable:true,
        //editable:false,
        renderer :Ext.util.Format.comboRenderer2(DHCPlanStatus,"DHCPlanStatus","DHCPlanStatusDesc"),
        editor:new Ext.grid.GridEditor(DHCPlanStatus,new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var Loc=field.getValue();
							if (Loc==null || Loc.length<1){
								Msg.info("warning","科室不能为空!");
								return;
							}																
							var cell = StatusGrpGrid.getSelectionModel().getSelectedCell();
							var row = cell[0];
							var rowData = StatusGrpGrid.getStore().getAt(row);
							var record = StatusGrpGrid.getStore().getAt(cell[0]);
							var colIndex=GetColIndex(StatusGrpGrid,'SSGroup');
			        		StatusGrpGrid.startEditing(cell[0], colIndex);
							}
						}
					}
		}))
	 },{
        header:"安全组",
        dataIndex:'SSGroup',
        width:250,
        align:'left',
        sortable:true,
		renderer :Ext.util.Format.comboRenderer2(SSGroup,"SSGroup","SSGroupDesc"),
		editor:new Ext.grid.GridEditor(SSGroup,new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var SSGroup=	field.getValue();
							if (SSGroup==""){
								Msg.info("warning","安全组不能为空!");
								return;
							}																	
							addNewRow()
							}
						}
					}
		}))
      }
  ]);

	 //初始化默认排序功能
	 StatusGrpGridCm.defaultSortable = true;
    	 var addLocGrp = new Ext.Toolbar.Button({
		 text:'新建',
   	  	 tooltip:'新建',
   	  	 iconCls:'page_add',
		 width : 70,
		 height : 30,
		 handler:function(){
			if(Loc==null||Loc.length<1){
				Msg.info("warning","请选择采购科室！")
				return ;
				} 
		 	addNewRow();
		 }
	 });
     function addNewRow(){
	     var record=Ext.data.Record.create([{name:'InitRowId'},{name:'DHCPlanStatus'},{name:'SSGroup'}]);
	     var newRecord=new Ext.data.Record({
		     InitRowId:'',
		     DHCPlanStatus:'',
		     SSGroup:''
		     });
		    StatusGrpGridDs.add(newRecord);
		    var lastRow=StatusGrpGridDs.getCount()-1;
		    var colIndex=GetColIndex(StatusGrpGrid,'DHCPlanStatus');
			StatusGrpGrid.startEditing(lastRow,colIndex); 
	     }
	 var saveLocGrp = new Ext.Toolbar.Button({
		 text:'保存',
   	 	 tooltip:'保存',
    	 iconCls:'page_save',
		 width : 70,
		 height : 30,
		 handler:function(){
			if(Loc==null||Loc.length<1){
				Msg.info("warning","请选择采购科室！")
				return ;
				}  
	 		save()
	 	}
	 });
	 function save(){
		 var ListDetail="";
		 var rowCount = StatusGrpGrid.getStore().getCount();
		 for (var i = 0; i < rowCount; i++) {
				var rowData = StatusGrpGridDs.getAt(i);	
				//新增或数据发生变化时执行下述操作
				if(rowData.data.newRecord || rowData.dirty){
					var RowId = rowData.get("InitRowId");
					var Status = rowData.get("DHCPlanStatus").trim();
					var SSGroup=rowData.get("SSGroup").trim();
					if(Loc!="" && SSGroup!=""){
						var str = RowId+"^"+Loc+"^"+SSGroup+"^"+Status;	
						if(ListDetail==""){
							ListDetail=str;
						}
						else{
							ListDetail=ListDetail+xRowDelim()+str;
						}
					}
				}
			}
			if(ListDetail==""){
				Msg.info("warning","没有修改或添加新数据!");
				return false;
			}
			var PlanNo = tkMakeServerCall("web.DHCSTM.DHCPlanStatusInit", "GetPlanNotAuditAll",Loc );	
			if(PlanNo!=""){
				Msg.info("warning","该科室存在未审核完成的采购单,如"+PlanNo+"不能修改科室采购审核级别")
				return  false;
			}
			var url = StatusGrpGridUrl
					+ "?actiontype=Save";
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
						url : url,
						params: {Detail:ListDetail},
						method : 'POST',
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
						    mask.hide();
							if (jsonData.success == 'true') {
								 
								Msg.info("success", "保存成功!");
								// 刷新界面
								StatusGrpGridDs.load({params:{Loc:Loc}});

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "没有需要保存的数据!");
								}else if(ret==-3){
									Msg.info("error", "该科室此审核级别已维护!");
								}else if(ret==-4){
									Msg.info("error", "该科室下的该安全组已维护!");
								}else {
									Msg.info("error", "部分明细保存不成功："+ret);
								}
								
							}
						},
						scope : this
					});
		 
		 }
	 
	 var deleteLocGrp = new Ext.Toolbar.Button({
		text:'删除',
   	 	tooltip:'删除',
   	 	iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			Delete()
		}
	});
	function Delete(){
		var cell=StatusGrpGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择要删除的记录！");
			return;
			
		}
		var PlanNo = tkMakeServerCall("web.DHCSTM.DHCPlanStatusInit", "GetPlanNotAuditAll",Loc );	
		if(PlanNo!=""){
			Msg.info("warning","该科室存在未审核完成的采购单,如"+PlanNo+"不能修改科室采购审核级别")
			return  false;
		}
		var row=cell[0];
		var record=StatusGrpGridDs.getAt(row);
		var rowid=record.get("InitRowId");
		if(rowid==null || rowid.length<1){
			//Msg.info("warning","所选记录尚未保存，不能删除!");
			//return;
			StatusGrpGridDs.remove(record);
			StatusGrpGrid.getView().refresh();
		}else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该管理组信息',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}
			function showResult(btn) {
			if (btn == "yes") {
		var url = StatusGrpGridUrl+ "?actiontype=Delete";
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:url,
			method:'post',
			waitMsg:'处理中...',
			params:{Rowid:rowid},
			success: function(response,opts){	
				var jsonData=Ext.util.JSON.decode(response.responseText);
				  mask.hide();
				if (jsonData.success=='true'){
					Msg.info("success","删除成功!");
					StatusGrpGridDs.load({params:{Loc:Loc}})
				}else {
					Msg.info("error","删除失败!");
				}
			
			}
		});
		
	}}
		}	
	//审核级别安全组grid	
	StatusGrpGrid=	 new Ext.grid.EditorGridPanel({
	   store:StatusGrpGridDs,
	   cm:StatusGrpGridCm,
	   trackMouseOver:true,
	   region:'center',
	   height:690,
	   stripeRows:true,
	   sm:new Ext.grid.CellSelectionModel({}),
	   loadMask:true,
	   tbar:[addLocGrp,'-',saveLocGrp,'-',deleteLocGrp],		//
	   clicksToEdit:1
    });
   	 
   	//DHCPlanStatusGridDs.load()
   	
	//页面布局
	var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 509,
                			minSize: 450,
                			maxSize: 550,
                			collapsible: true,
			                title: '采购科室',
			                layout: 'fit', // specify layout manager for items
			                items: CTLocGrid       
			               
			            }, {             
			                region: 'center',						                
			                title: '审核级别与安全组维护',
			                layout: 'fit', // specify layout manager for items
			                items: StatusGrpGrid          	
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
				//find.handler();
				Query()
					
})	
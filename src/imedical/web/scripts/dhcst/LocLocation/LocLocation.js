// /名称: 科室关联维护
// /描述: 科室关联维护
// /编写者：caoting
// /编写日期: 2014.04.24
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';	
	var groupId=session['LOGON.GROUPID'];
	var gLocId=null;
	var gLocManId=null;
	var gLocCode=null;
	
			
	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});
    function GetLocList(record) {
		if (record == null || record == "") {
			return false;
		}
		RowId = record.get("RowId");
		var cell = RecLocGrid.getSelectionModel().getSelectedCell();
		// 选中行
		var row = cell[0];
		var rowData = RecLocGrid.getStore().getAt(row);
		if (gLocCode==record.get("Code"))
		{
			Msg.info("warning","不能与供给科室相同!");
			rowData.set("RowId","");
			rowData.set("Code","");
			
			return false;
		} 
		rowData.set("RowId",RowId);
		rowData.set("Code",record.get("Code"));
		rowData.set("Desc",record.get("Desc"));
    }
		/**
		 * 查询方法
		 */
		function Query() {
			// 必选条件
			var Code = Ext.getCmp("LocCode").getValue();
			var Desc = Ext.getCmp("LocDesc").getValue();
			
			
			ProLocGrid.store.removeAll();
			RecLocGrid.store.removeAll();
			InciDetailGrid.store.removeAll();
		
			gStrParam=Code+"^"+Desc;
			var PageSize=LocPagingToolbar.pageSize;
			LocStore.load({
				params:{
					start:0,
					limit:PageSize,
					StrParam:gStrParam,
					GroupId:groupId
				}});

		}
		
		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';	
			Ext.getCmp("LocCode").setValue('');
			Ext.getCmp("LocDesc").setValue('');
		
			ProLocGrid.store.removeAll();
			RecLocGrid.store.removeAll();
			InciDetailGrid.store.removeAll();
			ProLocGrid.store.reload();
			//ProLocGrid.getView().refresh();
		}
		
		//新建
		var AddBT=new Ext.Toolbar.Button({
			id:'AddBT',
			text:'新增',
			tooltip:'点击增加',
			width:70,
			height:30,
			iconCls:'page_add',
			handler:function(){
				
				if(gLocId==null || gLocId.length<1){
					Msg.info("warning","请先选择供给科室!");
					return;
				}
				
				AddNewRow();
			}
		});
		
		function AddNewRow(){
			var record=Ext.data.Record.create([{name:'Rowid'},{name:'Code'},{name:'Desc'}]);
			var newRecord=new Ext.data.Record({
				Rowid:'',
				Code:'',
				Desc:'',
				Type:'R'
			});
			
			RecLocStore.add(newRecord);
			var lastRow=RecLocStore.getCount()-1;
			RecLocGrid.startEditing(lastRow,3);
		}
		// 保存按钮
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : '保存',
					tooltip : '点击保存',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {

						// 保存科室库存管理信息					
						save();						
					}
				});
		function save(){
			if(gLocId==null || gLocId.length<1){
				Msg.info("warning","科室不能为空!")
				return;
			}
			var ListDetail="";
			var rowCount = RecLocGrid.getStore().getCount();
			
			for (var i = 0; i < rowCount; i++) {
				var rowData = RecLocStore.getAt(i);	
				//新增或数据发生变化时执行下述操作
				if(rowData.data.newRecord || rowData.dirty){
					var RelRowid = rowData.get("RelRowId");
					if (RelRowid==undefined){RelRowid=""}
					var Rowid=rowData.get("RowId");
					var Code = rowData.get("Code").trim();
					var Desc=rowData.get("Desc").trim();
					var Type=rowData.get("Type").trim();
					if (Type==""){var Type="R"}
					if(Code!="" && Desc!=""){
						var str = Rowid + "^" + Code+"^"+Desc+"^"+Type+"^"+RelRowid;	
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
			var url = DictUrl
					+ "locrelaction.csp?actiontype=Save";
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
						url : url,
						params: {LocId:gLocId,Detail:ListDetail},
						method : 'POST',
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
						    mask.hide();
							if (jsonData.success == 'true') {
								 
								Msg.info("success", "保存成功!");
								// 刷新界面
								RecLocStore.load({params:{LocId:gLocId}});

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "没有需要保存的数据!");
								}else {
									var errMsg=ret;
									if (errMsg.indexOf(":")>=0){
										errMsg=errMsg.split(":")[1];
									}
									Msg.info("error", "部分明细保存不成功"+errMsg);
								}
								
							}
						},
						scope : this
					});

		}
	
	var DeleteBT=new Ext.Toolbar.Button({
		id:'DeleteBT',
		text:'删除',
		width:'70',
		height:'30',
		tooltip:'点击删除',
		iconCls:'page_delete',
		handler: function(){
			Delete();
		}
	});
	
	function Delete(){
		var cell=RecLocGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择要删除的记录！");
			return;
		}
		var row=cell[0];
		var record=RecLocStore.getAt(row);
		var rowid=record.get("RelRowId");
		if(rowid==null || rowid.length<1){
			Msg.info("warning","所选记录尚未保存，不能删除!");
			return;
		}else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该科室关联信息',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

		}
		
		function showResult(btn) {
			if (btn == "yes") {
				var url = DictUrl+"locrelaction.csp?actiontype=Delete";
				var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
				Ext.Ajax.request({
					url:url,
					method:'POST',
					waitMsg:'处理中...',
					params:{Rowid:rowid},
					success: function(response,opts){			 
						var jsonData=Ext.util.JSON.decode(response.responseText);
						mask.hide();
						if (jsonData.success=='true'){
							Msg.info("success","删除成功!");
							RecLocStore.load({params:{LocId:gLocId}});
							InciDetailStore.removeAll();
							InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});
						}else {
							Msg.info("error","删除失败!");
						}
			
					}
				});
			}
		}}
	//配置数据源
	var locUrl =DictUrl+'locmangrpaction.csp?actiontype=QueryLoc';
	var LocGridProxy= new Ext.data.HttpProxy({url:locUrl,method:'POST'});
	var LocStore = new Ext.data.Store({
		proxy:LocGridProxy,
	    reader:new Ext.data.JsonReader({
			totalProperty:'results',
	        root:'rows'
	    }, [
			{name:'Rowid'},
			{name:'Code'},
			{name:'Desc'}
		]),
	    remoteSort:true
	});
	
	//模型
	var LocGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:"代码",
	        dataIndex:'Code',
	        width:100,
	        align:'left',
	        sortable:true,
	        hidden:true
	    },{
	        header:"名称",
	        dataIndex:'Desc',
	        width:250,
	        align:'left',
	        sortable:true
	    }
	]);
	//初始化默认排序功能
	LocGridCm.defaultSortable = true;
	var LocPagingToolbar = new Ext.PagingToolbar({
	    store:LocStore,
		pageSize:PageSize,
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
			B['StrParam']=gStrParam;
			B['GroupId']=groupId;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	
	var LocCode=new Ext.form.TextField({
		id:'LocCode',
		name:'LocCode',
		width:100,
		hidden:true
	});
	
	var LocDesc=new Ext.form.TextField({
		id:'LocDesc',
		name:'LocDesc',
		width:100
	});
	
	//表格
	ProLocGrid = new Ext.grid.GridPanel({
		region:'west',
		title:'供给科室',
		store:LocStore,
		cm:LocGridCm,
		trackMouseOver:true,
		width:420,
		height:300,
		stripeRows:true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask:true,
		bbar:LocPagingToolbar,
		tbar:[LocCode,'名称:',LocDesc,'-',SearchBT,'-',RefreshBT]
	});

	ProLocGrid.addListener("rowclick",function(grid,rowindex,e){
		//LocUserManGrpGridDs.removeAll(); //清空人员表格
		var selectRow=LocStore.getAt(rowindex);
		gLocId=selectRow.get("Rowid");
		gLocCode=selectRow.get("Code");
		RecLocStore.load({params:{LocId:gLocId}});
		InciDetailStore.removeAll();
	});
		var RecLocTypeStore = new Ext.data.SimpleStore({
				fields : ['RowId', 'Description'],
				data : [['R', '上下级'], ['T', '同级']]
			});
		var nm = new Ext.grid.RowNumberer();
		var RecLocCm = new Ext.grid.ColumnModel([nm, {
					header : "RelRowId",
					dataIndex : 'RelRowId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},  {
					header : "RowId",
					dataIndex : 'RowId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '代码',
					dataIndex : 'Code',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "名称",
					dataIndex : 'Desc',
					width : 225,
					align : 'left',
					sortable : true,
					editor:new Ext.form.TextField({
			         id:'descField',
                    allowBlank:false,
			        listeners:{
				       specialKey:function(field, e) {
					   if (e.getKey() == Ext.EventObject.ENTER) {
						  GetLocInfoWindow(Ext.getCmp('descField').getValue(),GetLocList);
					}
				}
			}
        })
			},{
					header : "类型",
					dataIndex : 'Type',
					width : 90,
					align : 'left',
					sortable : true,
			        renderer:function(v, p, record){
			            if(v=="R")
			                return "上下级";
			            if(v=="T")
			                return "同级";
			        },
			        editor: new Ext.form.ComboBox({
			            id:'RecLocTypeField',
			            width:200,
			            listWidth:200,
			            allowBlank:true,
			            store:RecLocTypeStore,
			            value:'R', // 默认值"同级药库"
			            valueField:'RowId',
			            displayField:'Description',
			            emptyText:'',
			            triggerAction:'all',
			            emptyText:'',
			            minChars:1,
			            mode:'local',
			            selectOnFocus:true,
			            forceSelection:true,
			            editable:true
			        })

				}
					]);
		RecLocCm.defaultSortable = true;

		// 访问路径
		var LocRelUrl = DictUrl
					+ 'locrelaction.csp?actiontype=Query&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : LocRelUrl,
					method : "POST"
				});
		// 指定列参数
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "RowId",
					fields : ["RowId","Code","Desc","RelRowId","Type"]
				});
		// 数据集
		var RecLocStore = new Ext.data.Store({
					pruneModifiedRecords:true,
					proxy : proxy,
					reader : reader
				});
		var RecLocGrid = new Ext.grid.EditorGridPanel({
			        region:'center',
					title:'接收科室<默认维护为上下级>',
					id:'RecLocGrid',
					cm : RecLocCm,
					store : RecLocStore,
					trackMouseOver : true,
					stripeRows : true,
					width:330,  //add by myq 20141104
					height:300,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					tbar:[AddBT,'-',SaveBT,'-',DeleteBT],
					loadMask : true
				});

		RecLocGrid.addListener("rowclick",function(grid,rowindex,e){
			var selectRow=RecLocStore.getAt(rowindex);  // 20141104 myq  放开注释
			gLocManId=selectRow.get("RowId");   // 20141104 myq  放开注释
			//QueryLocUserManGrp();
			//alert("gLocId:"+gLocId+"gLocManId:"+gLocManId)
			InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});  // add by myq 20141104
		});
		
		
		//---------------------add by myq 20141104 科室能申领药品的维护
		/*  */
		
		var nm = new Ext.grid.RowNumberer();
		var InciDetailCm = new Ext.grid.ColumnModel([nm, {
					header : "LreliRowid",
					dataIndex : 'LreliRowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : 'Inci',
					dataIndex : 'Inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
					
				}, {
					header : '药品代码',
					dataIndex : 'InciCode',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : false
					
				}, {
					header : "药品名称",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.TextField({
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									
									specialkey : function(field, e) {
									
										if (e.getKey() == Ext.EventObject.ENTER) {
											//var group = Ext.getCmp("StkGrpType").getValue();
											GetPhaOrderInfo(field.getValue(),"");
										}
									}
								}	
							})	 
						)
			}
					]);
		InciDetailCm.defaultSortable = true;
		
		// 访问路径
		var InciDetailUrl = DictUrl
					+ 'locrelaction.csp?actiontype=QueryInciDetail&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : InciDetailUrl,
					method : "POST"
				});
		// 指定列参数
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "LreliRowid",
					fields : ["LreliRowid","Inci","InciCode","InciDesc"]
				});
		// 数据集
		var InciDetailStore = new Ext.data.Store({
					pruneModifiedRecords:true,
					proxy : proxy,
					reader : reader
				});
	
	/**
		 * 调用药品窗体并返回结果
		 */
		function GetPhaOrderInfo(item, group) {
						
			if (item != null && item.length > 0) {
				
				GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
       function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var TRinciCode=record.get("TRInciCode");
			var inciDesc=record.get("InciDesc");
			var cell = InciDetailGrid.getSelectionModel().getSelectedCell();
			// 选中行
			var row = cell[0];
			var rowData = InciDetailGrid.getStore().getAt(row);
			rowData.set("Inci",inciDr);
			rowData.set("InciCode",inciCode);
			rowData.set("InciDesc",inciDesc);
			AddNewInciRow();	
       }
       
	//新建
		var AddInciBT=new Ext.Toolbar.Button({
			id:'AddInciBT',
			text:'新增',
			tooltip:'点击增加',
			width:70,
			height:30,
			iconCls:'page_add',
			handler:function(){
			     if(gLocManId==null || gLocManId.length<1){
					Msg.info("warning","请先选择接收科室!");
					return;
				}
				AddNewInciRow();
			}
		});
		
		function AddNewInciRow(){
			var record=Ext.data.Record.create([{name:'LreliRowid'},{name:'Inci'},{name:'InciCode'},{name:'InciDesc'}]);
			var newRecord=new Ext.data.Record({
				LreliRowid:'',
				Inci:'',
				InciCode:'',
				InciDesc:''
			});
			
			InciDetailStore.add(newRecord);
			var lastRow=InciDetailStore.getCount()-1;
			var newcolIndex=GetColIndex(InciDetailGrid,'InciDesc');
			InciDetailGrid.startEditing(lastRow,newcolIndex);
		}
		// 保存按钮
		var SaveInciBT = new Ext.Toolbar.Button({
					id : "SaveInciBT",
					text : '保存',
					tooltip : '点击保存',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {

						// 保存能申领的药品					
						saveinci();						
					}
				});
   function saveinci(){
	    
	    if(gLocId==null || gLocId.length<1){
				Msg.info("warning","供给科室不能为空!")
				return;
			}
			
		if(gLocManId==null || gLocManId.length<1){
				Msg.info("warning","接收科室不能为空!")
				return;
			}
				
	  var ListDetail="";
			var rowCount = InciDetailGrid.getStore().getCount();
			
			for (var i = 0; i < rowCount; i++) {
				var rowData = InciDetailStore.getAt(i);	
				//新增或数据发生变化时执行下述操作
				if(rowData.data.newRecord || rowData.dirty){
					var LreliRowid = rowData.get("LreliRowid");
					var Inci = rowData.get("Inci");
					var InciCode = rowData.get("InciCode").trim();
					var InciDesc=rowData.get("InciDesc").trim();

					if(InciCode!="" && InciDesc!=""){
						var str = LreliRowid +"^"+Inci + "^" + InciCode+"^"+InciDesc;	
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
			var url = DictUrl
					+ "locrelaction.csp?actiontype=SaveInci";
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
						url : url,
						params: {ProLoc:gLocId,RecLoc:gLocManId,Detail:ListDetail},
						method : 'POST',
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
						    mask.hide();
							if (jsonData.success == 'true') {
								 
								Msg.info("success", "保存成功!");
								// 刷新界面
								InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "没有需要保存的数据!");
								}
								else if(ret==-2){
									Msg.info("error", "不能重复添加药品!");
								}else {
									Msg.info("error", "部分明细保存不成功："+ret);
								}
								
							}
						},
						scope : this
					});
			

		}
	
	var DeleteInciBT=new Ext.Toolbar.Button({
		id:'DeleteInciBT',
		text:'删除',
		width:'70',
		height:'30',
		tooltip:'点击删除',
		iconCls:'page_delete',
		handler: function(){
			DeleteInci();
		}
	});
  
  function DeleteInci(){
			var cell=InciDetailGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择要删除的记录！");
			return;
		}
		var row=cell[0];
		var record=InciDetailStore.getAt(row);
		var LreliRowid=record.get("LreliRowid");
		if(LreliRowid==null || LreliRowid.length<1){
			Msg.info("warning","所选记录尚未保存，不能删除!");
			return;
		}else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该药品信息',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}
		
		function showResult(btn) {
			if (btn == "yes") {
		var url = DictUrl	+ "locrelaction.csp?actiontype=DeleteInci";
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:url,
			method:'post',
			waitMsg:'处理中...',
			params:{Rowid:LreliRowid},
			success: function(response,opts){	
		 
				var jsonData=Ext.util.JSON.decode(response.responseText);
				  mask.hide();
				if (jsonData.success=='true'){
					Msg.info("success","删除成功!");
					InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});
				}else {
					Msg.info("error","删除失败!");
				}
			
			}
		});
		
	}}

		}
  
		
		var InciDetailGrid = new Ext.grid.EditorGridPanel({
			        region:'east',
					title:'申领药品',
					id:'InciDetailGrid',
					cm : InciDetailCm ,
					store : InciDetailStore,
					trackMouseOver : true,
					stripeRows : true,
					width:350,
					height:300,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					tbar:[AddInciBT,'-',SaveInciBT,'-',DeleteInciBT],
					loadMask : true
				});
     

      //---------------------add by myq 20141104 科室能申领药品的维护

        //启用编辑列
		var ActiveField = new Ext.grid.CheckColumn({
			header:'是否有效',
			dataIndex:'Active',
			width:100,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		});

        //新增
		var AddLocUserManGrp = new Ext.Toolbar.Button({
			text:'新建',
			tooltip:'新建',
			iconCls:'page_add',
			width : 70,
			height : 30,
			handler:function(){
				AddLocUserNewRow();
			}
		});

　　　　//保存人员
		var SaveLocUserManGrp = new Ext.Toolbar.Button({
			text:'保存',
			tooltip:'保存',
			width : 70,
			height : 30,
			iconCls:'page_save',
			handler:function(){

				SaveLocUserMan();
			}
		});

　　　　//人员下拉
		var UStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
				url:'dhcst.orgutil.csp?actiontype=StkLocUserCatGrp'
			}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

		var UCG = new Ext.form.ComboBox({
			fieldLabel : '名称',
			id : 'UCG',
			name : 'UCG',
			anchor : '90%',
			width : 120,
			store : UStore,
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : false,
			triggerAction : 'all',
			emptyText : '名称...',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			pageSize : 10,
			listWidth : 250,
			valueNotFoundText : '',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						//addNewRow();
					}
				}
			}
		});

		UCG.on('beforequery', function(e) {
		UStore.removeAll();
		UStore.setBaseParam('name',Ext.getCmp('UCG').getRawValue());
		UStore.setBaseParam('locId',gLocId);
		var pageSize=Ext.getCmp("UCG").pageSize;
		UStore.load({params:{start:0,limit:pageSize}});
	  });

		//配置数据源
		//访问路径
		var gridUrl = DictUrl
					+ 'locmangrpaction.csp?actiontype=QueryLocUserMan&start=0&limit=200';
		var LocUserManGrpGridProxy= new Ext.data.HttpProxy({url:gridUrl,method:'GET'});
		var LocUserManGrpGridDs = new Ext.data.Store({
			proxy:LocUserManGrpGridProxy,
			reader:new Ext.data.JsonReader({
				root:'rows'
			}, [
				{name:'Rowid'},
				{name:'UserId'},
				{name:'Code'},
				{name:'Name'},
				{name:'Active'}
			]),
			pruneModifiedRecords:true,
			remoteSort:false
		});

		//模型
		var LocUserManGrpGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),{
				header:"Rowid",
				dataIndex:'Rowid',
				width:200,
				align:'left',
				sortable:true,
				hidden:true
			},{
				header:"代码",
				dataIndex:'Code',
				width:200,
				align:'left',
				sortable:true
			},{
				header:"名称",
				dataIndex:'UserId',
				width:200,
				align:'left',
				sortable:true,
				renderer:　Ext.util.Format.comboRenderer2(UCG,"UserId","Name"),
				editor:new Ext.grid.GridEditor(UCG)
			},ActiveField
		]);

		 

		//初始化默认排序功能
		LocUserManGrpGridCm.defaultSortable = true;

		var LocUserManGrpGridPagingToolbar = new Ext.PagingToolbar({
		store:LocUserManGrpGridDs,
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
			B['locGrpId']=LocGrpId;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
				}
			}
		});

		//按人分配表格
		LocUserManGrpGrid = new Ext.grid.EditorGridPanel({
			store:LocUserManGrpGridDs,
			cm:LocUserManGrpGridCm,
			trackMouseOver:true,
			height:370,
			plugins:[ActiveField],
			stripeRows:true,
			//sm:new Ext.grid.CellSelectionModel({}),
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask:true,
			clicksToEdit:2,
			tbar:[AddLocUserManGrp,'-',SaveLocUserManGrp],
			bbar:LocUserManGrpGridPagingToolbar
		});
		LocUserManGrpGrid.on('beforeedit',function(e){
			if(e.field=="UserId"){
				//addComboData(UCG.getStore(),e.record.get("UserId"),e.record.get("Name"));
			}
		})
		
		var LocUserManGroupPanel = new Ext.Panel({
			region:'south',
			deferredRender : true,
			title:'人员维护',
			activeTab: 0,
			height:300,
			layout:'fit',
			split:true,
			collapsible:true,
			items:[LocUserManGrpGrid]                                 
		});

		var HospPanel = InitHospCombo('PHA-IN-LocRequest',function(combo, record, index){
			HospId = this.value; 
			Query();
			RecLocStore.removeAll();
			RecLocStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});
			InciDetailStore.removeAll();
			InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});
			
		});


		// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ HospPanel,ProLocGrid, RecLocGrid, InciDetailGrid ]  ,       // create instance immediately
					renderTo : 'mainPanel'
				});
	    //-----------------------------Events----------------------//
	    Query();

        //新增行
		function AddLocUserNewRow(){

			if(gLocId==null || gLocId.length<1){
				Msg.info("warning","请先选择科室!");
				return;
			}

			if(gLocManId==null || gLocManId.length<1){
				Msg.info("warning","请先选择管理组!");
				return;
			}


			var record = Ext.data.Record.create([
				{
					name : 'Rowid',
					type : 'int'
				},{
					name : 'UserId',
					type : 'int'
				}, {
					name : 'Code',
					type : 'string'
				}, {
					name : 'Name',
					type : 'string'
				}, {
					name : 'Active',
					type : 'string'
				}
			]);
							
			var rec = new record({
				Rowid:'',
				UserId:'',
				Code:'',
				Name:'',
				Default:'Y',
				Active:'Y'
			});
			LocUserManGrpGridDs.add(rec);
			LocUserManGrpGrid.startEditing(LocUserManGrpGridDs.getCount() - 1, 2);

		}



     //保存人员管理组
     function SaveLocUserMan()
	 {
		    //获取所有的新记录
			var mr=LocUserManGrpGridDs.getModifiedRecords();
			var data="";
			var nameflag="";
			for(var i=0;i<mr.length;i++){
				var RowId = mr[i].data["Rowid"];
				var userId = mr[i].data["UserId"];
				var active = mr[i].data["Active"];
				var name = mr[i].data["Name"];

				if(RowId!=""){
					var dataRow = RowId+"^"+userId+"^"+active+"^"+name;
					if(data==""){
						data = dataRow;
						nameflag=nameflag+userId
					}else{
						data = data+xRowDelim()+dataRow;
						nameflag=nameflag+userId
					}
				}else{
					var dataRow = "^"+userId+"^"+active+"^"+name;
					if(data==""){
						data = dataRow;
						nameflag=nameflag+userId
					}else{
						data = data+xRowDelim()+dataRow;
						nameflag=nameflag+userId
					}
				}
			}
			
			if(nameflag==""){	Msg.info("error","没有需要保存的数据!");	return false;;}
			
			if(data!=""){
				Ext.Ajax.request({
					url: DictUrl+'locmangrpaction.csp?actiontype=SaveLocUserMan',
					params: {Detail:data,locGrpId:gLocManId},
					failure: function(result, request) {
						Msg.info("error", "请检查网络连接!");
					},
					success: function(result, request) {
						data="";
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", "保存成功!");
							QueryLocUserManGrp();
						}else{
							var info=jsonData.info
							var infoarr=info.split(",");
							var infovalue=infoarr[0];
							var infodesc=infoarr[1];
							if(infovalue==-99){
								Msg.info("error","人员不能重复增加!"+infodesc);
							}else{
								Msg.info("error", "保存失败"+infodesc);
							}
						}

						
					},
					scope: this
				});
			}
       
	 }

    //刷新表格
	function QueryLocUserManGrp()
	{   
		LocUserManGrpGridDs.removeAll();
		LocUserManGrpGridDs.load({params:{locGrpId:gLocManId}});
	}


})
// 名称:请领科室禁止请领物资
// 编写日期:2014-03-07
// 姓名:taosongrui

var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var RefuseReqLocGridUrl="dhcstm.refusereqlocaction.csp"
var gItmdr="";
var gInciCode="";

// 药品类组
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:gLocId,
	UserId:gUserId,
	anchor:'70%'
});
var ToLoc = new Ext.ux.LocComboBox({
	id:'ToLoc',
	name:'ToLoc',
	fieldLabel:'请领科室',
	allowBlank:true,
	emptyText:'请领科室...',
	anchor:'90%',
	defaultLoc:''
});
var M_InciDesc = new Ext.form.TextField({
	fieldLabel : '物资名称',
	id : 'M_InciDesc',
	name : 'M_InciDesc',
	anchor : '90%',
	listeners : {
	specialkey : function(field, e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			var stktype = Ext.getCmp("StkGrpType").getValue();
			GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});
var AuditedCK = new Ext.form.Checkbox({
	id: 'AuditedCK',
	hideLabel : true,
	boxLabel : '按科室维护',
	anchor:'90%',
	allowBlank:true
});
//调用药品窗体并返回结果
function GetPhaOrderInfo(item, group) {
	if (item != null && item.length > 0) {
	    GetPhaOrderWindow(item, group,App_StkTypeCode, "", "", "0", "",
						getDrugList);
		}
}
// 返回方法
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	gItmdr=record.get("InciDr");
	gInciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(inciDesc);
}
function GetPhaOrderInfo1(item, group) {
	if (item != null && item.length > 0) {
	    GetPhaOrderWindow(item, group,App_StkTypeCode, "", "N", "0", "",
						getDrugList1);
		}
} 
function getDrugList1(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr=record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	var ReqLoc=Ext.getCmp("ToLoc").getValue();
	var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	var rowData = RefuseReqLocGrid.getStore().getAt(row);
	rowData.set("IncId",inciDr);
	rowData.set("InciCode",inciCode);
	rowData.set("MDesc",inciDesc);
	rowData.set("FrLoc",gLocId);
	rowData.set("ReqLoc",ReqLoc);
	
//光标跳到开始日期
	var colIndex=GetColIndex(RefuseReqLocGrid,'StartDate');
	RefuseReqLocGrid.startEditing(row, colIndex);
}
 
//=====================================
// 供应科室
var Frloc = new Ext.ux.LocComboBox({
	fieldLabel : '供应科室',
	id : 'Frloc',
	name : 'Frloc',
	anchor : '90%'
});
var ReqLoc = new Ext.ux.LocComboBox({
	fieldLabel : '请领科室',
	id : 'ReqLoc',
	name : 'ReqLoc',
	anchor : '90%',
	listeners:{
		'select':function(cb){
			var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
							var row = cell[0];
							var rowData = RefuseReqLocGrid.getStore().getAt(row);
							var M_InciDesc=	Ext.getCmp("M_InciDesc").getValue();
							rowData.set("MDesc",M_InciDesc);
							rowData.set("IncId",gItmdr);
							rowData.set("InciCode",gInciCode);
							rowData.set("FrLoc",gLocId);
			}
		}
});

var findAPCVendor = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		Query()
	}
});

var addAPCVendor = new Ext.Toolbar.Button({
    text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
	    var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
	 	if(Audited=="Y"){
		    var ReqLoc=	Ext.getCmp("ToLoc").getValue();
				if (ReqLoc==""){
					Msg.info("warning","请领科室不能为空!");
					return;
				}
			var rowCount = RefuseReqLocGrid.getStore().getCount();
			if(rowCount>0){
				var rowData = RefuseReqLocGridDs.data.items[rowCount - 1];
				var data=rowData.get("MDesc")
				if(data=="" || data.length<=0){
					Msg.info("warning","已存在新建行");
					RefuseReqLocGrid.startEditing(RefuseReqLocGridDs.getCount()-1,4)
					return;
				}
			}
			RefuseReqLocGrid.store.removeAll();
       		addNewRow();
	 	}
	 	else{
		 	var M_InciDesc = Ext.getCmp("M_InciDesc").getValue();
				if (M_InciDesc==""){
					Msg.info("warning","物资名称不能为空!");
					return;
				}
				else{
					if(gItmdr==""){
						Msg.info("warning","该物资名称不存在!");
              			return;
					}
					var rowCount =RefuseReqLocGrid.getStore().getCount();
					if(rowCount>0){
						var rowData = RefuseReqLocGridDs.data.items[rowCount - 1];
						var data=rowData.get("ReqLoc")
						if(data=="" || data.length<=0){
							Msg.info("warning","已存在新建行");
							RefuseReqLocGrid.startEditing(RefuseReqLocGridDs.getCount()-1,6)
							return;
						}
					}
					RefuseReqLocGrid.store.removeAll();
        			addNewRow();
				}
	 	}	 	
    }
});
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : '保存',
	tooltip : '点击保存',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		saveOrder();}
});
//删除按钮
var deleteMarkType = new Ext.Toolbar.Button({
    text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
	    deleteDetail(); }
})				
			

//模型
var nm = new Ext.grid.RowNumberer();
var RefuseReqLocGridCm = new Ext.grid.ColumnModel([nm,{
        header : "RowId",
		dataIndex : 'RowId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
		},{
		header : "IncRowid",
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
		},{
		header : "物资代码",
		dataIndex : 'InciCode',
		width : 80,
		align : 'left',
		sortable : true
		},{
        header:"物资名称",
        dataIndex:'MDesc',
        width:120,
        align:'left',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.TextField({
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var ReqLoc=	Ext.getCmp("ToLoc").getValue();
											if (ReqLoc==""){
												Msg.info("warning","请领科室不能为空!");
												return;
											}
											var group = Ext.getCmp("StkGrpType").getValue();
											GetPhaOrderInfo1(field.getValue(),group);
											
										}
									   
									}
								}
							}))
							
    },{
	    header:"供应科室",
        dataIndex:'FrLoc',
        width:250,
        align:'left',
        sortable:true,
        editable:false,
        renderer :Ext.util.Format.comboRenderer2(Frloc,"FrLoc","FrLocDesc")
	 },{
        header:"请领科室",
        dataIndex:'ReqLoc',
        width:250,
        align:'left',
        sortable:true,
		renderer :Ext.util.Format.comboRenderer2(ReqLoc,"ReqLoc","ReqLocDesc"),
		editor:new Ext.grid.GridEditor(ReqLoc,new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var M_InciDesc=	Ext.getCmp("M_InciDesc").getValue();
							if (M_InciDesc==""){
								Msg.info("warning","物资不能为空!");
								return;
							}																	
							var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
							//var row = cell[0];
							//var rowData = RefuseReqLocGrid.getStore().getAt(row);
							//rowData.set("MDesc",M_InciDesc);
							//rowData.set("IncId",gItmdr);
							//rowData.set("InciCode",gInciCode);
							//rowData.set("FrLoc",gLocId);
							//var record = RefuseReqLocGrid.getStore().getAt(cell[0]);
							var colIndex=GetColIndex(RefuseReqLocGrid,'StartDate');
			        		RefuseReqLocGrid.startEditing(cell[0], colIndex);
							}
						}
					}
		}))
    },{
        header:"开始日期",
        dataIndex:'StartDate',
        width:200,
        align:'center',
        sortable:true,
        renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
				selectOnFocus : true,
				allowBlank : true,
				
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
							var record = RefuseReqLocGrid.getStore().getAt(cell[0]);
							var colIndex=GetColIndex(RefuseReqLocGrid,'EndDate');
			                RefuseReqLocGrid.startEditing(cell[0], colIndex);
						}
					}
			   }
		})
    },{
        header:"截止日期",
        dataIndex:'EndDate',
        width:200,
        align:'center',
        sortable:true,
         renderer : Ext.util.Format.dateRenderer(DateFormat),
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : true,
						
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
									var record = RefuseReqLocGrid.getStore().getAt(cell[0]);
									var SDate=record.get("StartDate")//.format(ARG_DATEFORMAT)
									var EDate=field.getValue()//.format(ARG_DATEFORMAT);
									if((SDate!="")&(EDate!="")){
										if (EDate.format(ARG_DATEFORMAT) <SDate.format(ARG_DATEFORMAT)) {
										Msg.info("warning", "截止日期不能小于开始日期!");
										return;
									}}
									var colIndex=GetColIndex(RefuseReqLocGrid,'Remark');
			                        RefuseReqLocGrid.startEditing(cell[0], colIndex);
								}
							}
						}
					})
    },{
		  header:'备注',
	    dataIndex:'Remark',
	    width:150,
	    align:'left',
	    sortable:true,
	    editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								addNewRow()
								}
							}
		}})   
	 }
]);

//初始化默认排序功能
RefuseReqLocGridCm.defaultSortable = true;

function addNewRow() {
	var record = Ext.data.Record.create([
      {
            name : 'RowId',
            type : 'int'
        },{
            name : 'IncId',
            type : 'string'
        },{
            name : 'InciCode',
            type : 'string'
        },{
            name : 'MDesc',
            type : 'string'
        },{
	        name : 'FrLoc',
	        type : 'string'
	    },{
            name : 'ReqLoc',
            type : 'string'
        }, {
            name : 'StartDate',
            type : 'date'
        }, {
            name : 'EndDate',
            type : 'date'
        }, {
            name : 'Remark',
            type : 'string'
        }
    ]);
    var NewRecord = new record({
	    RowId:'',
	    IncId:'',
	    InciCode:'',
        MDesc:'',
        FrLoc:'',
        ReqLoc:'',
        StartDate:'',
        EndDate:'',
        Remark:''
    });
    RefuseReqLocGridDs.add(NewRecord);
    var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
	 	if(Audited=="Y"){
		    RefuseReqLocGrid.startEditing(RefuseReqLocGridDs.getCount() - 1,4);
	 	}
	 	else{
			RefuseReqLocGrid.startEditing(RefuseReqLocGridDs.getCount() - 1, 6);
	 	}
    }

// 访问路径
var DetailUrl =RefuseReqLocGridUrl+
	'?actiontype=Query&ReqLoc=&IncId=&start=0&limit=RefuseReqLocPagingToolbar.pageSize';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
			url : DetailUrl,
			method : "POST"
	});
		
// 指定列参数
var fields = ["RowId", "IncId", "InciCode", "MDesc","FrLoc","FrLocDesc","ReqLoc","ReqLocDesc",{name:'StartDate',type:'date',dateFormat:DateFormat},
	{name:'EndDate',type:'date',dateFormat:DateFormat},"Remark"];
		
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "RowId",
		fields : fields
});
// 数据集
var RefuseReqLocGridDs = new Ext.data.Store({
		proxy : proxy,
		reader : reader,
		listeners:{
		'load':function(ds){
		 }
	}
});	 
			
//保存请领科室禁止请领物资
function saveOrder(){
	var ListDetail="";
	var rowCount = RefuseReqLocGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = RefuseReqLocGridDs.getAt(i);
		//新增或数据发生变化时执行下述操作
		if(rowData.data.newRecord || rowData.dirty){
			var RowId=rowData.get("RowId"); 
			var IncId=rowData.get("IncId");
			var FrLoc=rowData.get("FrLoc");
			var ReqLoc=rowData.get("ReqLoc");
			var StartDate =Ext.util.Format.date(rowData.get("StartDate"),ARG_DATEFORMAT);
			var EndDate =Ext.util.Format.date(rowData.get("EndDate"),ARG_DATEFORMAT);
			if((StartDate!="")&(EndDate!="")){
				if (EndDate<StartDate) {
					Msg.info("warning", "截止日期不能小于开始日期,保存失败!");
					return;
				}
			}
			var Remark=rowData.get("Remark");    
 			var str= ReqLoc + "^" + IncId+"^"+FrLoc+"^"+StartDate+"^"+EndDate+"^"+ Remark +"^"+RowId
			if(ListDetail==""){
				ListDetail=str;
			}else{
				ListDetail=ListDetail+","+str;
			}
		}
	}
	                   
	if(ListDetail==""){
		Msg.info("error","没有修改或添加新数据!");
		return false;
	}else{
		var url = RefuseReqLocGridUrl+"?actiontype=Save";
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
							.decode(result.responseText);
				mask.hide();		
				if (jsonData.success == 'true') {
					var IngrRowid = jsonData.info;
					Msg.info("success", "保存成功!");
					Query();
				}else{
					var ret=jsonData.info;
					if (ret=-10){
						Msg.info("warning","该物资的该请领科室已经维护");
						return;
					}else{
						Msg.info("error", "保存不成功："+ret);
					}
				}
			},
			scope : this
		});
	}
}
           
//查询函数
function Query()
{
	var ReqLoc=Ext.getCmp("ToLoc").getValue();
	var InciDesc=Ext.getCmp("M_InciDesc").getValue();
	var Stkcat=Ext.getCmp("StkGrpType").getValue();
	if(InciDesc==null||InciDesc==""){
		gItmdr="";
	}
    RefuseReqLocGridDs.removeAll();
	RefuseReqLocGridDs.load({
		params:{start:0,limit:RefuseReqLocPagingToolbar.pageSize,ReqLoc:ReqLoc,IncId:gItmdr,Stkcat:Stkcat},
		callback:function(r,options,success){
			if(success==false){
				Msg.info("error","查询有误, 请查看日志!");
			}
		}
	});
}
function deleteDetail()
{
	var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
                Msg.info("error","请选择数据!");
               return false;}
         else{ var record = RefuseReqLocGrid.getStore().getAt(cell[0]);
               var RowId = record.get("RowId");
               if (RowId!=""){
	               Ext.MessageBox.confirm('提示','确定要删除选定的行?',
	               function(btn){
		               if(btn=="yes"){
			               var url = RefuseReqLocGridUrl+"?actiontype=Delete&rowid="+RowId;
			               var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			               Ext.Ajax.request({
				              url:url,
				               waitMsg:'删除中...',
                                failure: function(result, request) {
                                    Msg.info("error","请检查网络连接!");
                                     mask.hide();
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                     if (jsonData.success=='true') {
                                        Msg.info("success","删除成功!");
                                        Query()
                                      }
                                      else{
                                        Msg.info("error","删除失败!");
                                    }
                                },
                                scope: this
				               });
				               
				               }
			               
			               })
	  }else{ var rowInd=cell[0];      
                if (rowInd>=0) RefuseReqLocGrid.getStore().removeAt(rowInd);  }
          
 
          
            }   
	
	}


//新建窗口
            
var formPanel = new Ext.ux.FormPanel({
	title:'科室禁止请领物资维护',
    tbar:[findAPCVendor,'-',addAPCVendor,'-',SaveBT,'-',deleteMarkType],
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
				columnWidth : 0.3,
				items : [StkGrpType]
			},{
				columnWidth : 0.3,
				items : [M_InciDesc]
			},{
				columnWidth : 0.25,
				items : [ToLoc]
			}, {
				columnWidth : 0.15,
				items : [AuditedCK]
			}]
	}]

});

//分页工具栏
var RefuseReqLocPagingToolbar = new Ext.PagingToolbar({
    store:RefuseReqLocGridDs,
	pageSize:19,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
     doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		
		var ReqLoc=Ext.getCmp("ToLoc").getValue();
	    var InciDesc=Ext.getCmp("M_InciDesc").getValue();
	    var ReqLoc=Ext.getCmp("ToLoc").getValue();
	    var InciDesc=Ext.getCmp("M_InciDesc").getValue();
	    var Stkcat=Ext.getCmp("StkGrpType").getValue();
	    if(InciDesc==null||InciDesc==""){
		      gItmdr="";
	    }
	    B['ReqLoc']=ReqLoc
	    B['IncId']=gItmdr
	    B['Stkcat']=Stkcat

		var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
	 	if(Audited=="Y"){
        	B['Parref']=Ext.getCmp("ToLoc").getValue();
	 	}
	 	else{
		 	B['Parref']=Ext.getCmp("M_InciDesc").getValue();
	 	}
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}

});

//表格
RefuseReqLocGrid = new Ext.grid.EditorGridPanel({
	store:RefuseReqLocGridDs,
	cm:RefuseReqLocGridCm,
	title:'禁止请领物资明细',
	trackMouseOver:true,
	clicksToEdit:0,
	region:'center',
	height:690,
	stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:RefuseReqLocPagingToolbar
});
//=========================供应商类别=============================



	
//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,RefuseReqLocGrid],
		renderTo:'mainPanel'
	});
});
	
//===========模块主页面===========================================
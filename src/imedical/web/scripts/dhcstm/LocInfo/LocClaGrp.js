function setLocClaGrp(loc,locDesc ){
var Url="dhcstm.locclagrpaction.csp"
var GrpRowId=null
//科室分类组
var AddButton=new Ext.ux.Button({
	text:'增加',
	iconCls:'page_add',
	handler:function(){
		AddNewRow()
	} 
})
function AddNewRow(){
	var record=Ext.data.Record.create([
		{
			name:'GrpId',
			type:'int'
		},{
			name:'GrpCode',
			type:'string'
		},{
			name:'GrpDesc',
			type:'string'
		}
	]);
	var NewRecord=new record({
		GrpId:'',
		GrpCode:'',
		GrpDesc:''
	});
	LocClaGrpStore.add(NewRecord);
	LocClaGrpGrid.startEditing(LocClaGrpStore.getCount()-1,2)
}
var SaveButton=new Ext.ux.Button({
	text:'保存',
	iconCls:'page_save',
	handler:function(){
		Save()
	}
})
function Save(){
	var ListDetail="";
	var rowCount=LocClaGrpGrid.getStore().getCount();
	for(i=0;i<rowCount;i++){
		var rowData=LocClaGrpStore.getAt(i);
		//新增或数据发生变化时执行下述操作
		if(rowData.data.newRecord||rowData.dirty){
		var RowId=rowData.get("GrpId"); 
		var Code=rowData.get("GrpCode");
		var Desc=rowData.get("GrpDesc")
		if (Code==""){
		    Msg.info("warning","代码不能为空!");
		    return;
		}	
		if (Desc==""){
		    Msg.info("warning","名称不能为空!");
		    return;
		}
		var str=RowId+"^"+Code+"^"+Desc+"^"+loc
		 
		if(ListDetail==""){
		  ListDetail=str
		}else{
		  ListDetail=ListDetail+xRowDelim()+str
		}     
		}
	}
	
	if(ListDetail==""){
		Msg.info("error","没有修改或添加新数据!");
		return false;
	}else{
		var url = Url+"?actiontype=Save";
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
					Msg.info("success", "保存成功!");
					LocClaGrpStore.load();
				}else{
					var ret=jsonData.info;
					if (ret=="-10"){
					Msg.info("error", "代码重复！");
					}else if (ret=="-11"){
					Msg.info("error", "名称重复！");
					}else{
					Msg.info("error", "保存不成功："+ret);
					}
					
				}
			},
			scope : this
		});
	}

}
var DeleteButton=new Ext.ux.Button({
	text:'删除',
	iconCls:'page_delete',
	handler:function(){
		Delele()
	}
})
function Delele(){
	var cell=LocClaGrpGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","请选择数据!");
		return false;
		}else{
			var record=LocClaGrpGrid.getStore().getAt(cell[0]);
			var RowId=record.get("GrpId")
			if (RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行并删除所有明细?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:Url+'?actiontype=Delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "删除成功!");
										LocClaGrpGrid.getStore().load()
										refresh()
									}else{
										Msg.info("error", "删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
				
				}else{
					var rowInd=cell[0];
					if(rowInd>=0){
						LocClaGrpGrid.getStore().removeAt(rowInd)
						}
					}
				
				
			}

}
var LocClaGrpCm=new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
    	header:'GrpId',
    	dataIndex:'GrpId',
    	align:'left',
    	width:100,
    	sortable:true, 
 	    hidden:true
    },{
    	header:'分组代码',
    	dataIndex:'GrpCode',
    	align:'left',
    	width:100,
    	editor:new Ext.form.TextField({
    		id:'GrpCode',
    		allowBlank:false,
    		listeners:{
			    specialKey:function(field,e){
    	   	 if(e.getKey()==Ext.EventObject.ENTER){
    	   	   LocClaGrpGrid.startEditing(LocClaGrpStore.getCount()-1,3);
    	   	     }
    	        }	    
			   }
    	})
    },{
    	header:'分组名称',
    	dataIndex:'GrpDesc',
    	align:'left',
    	width:100,
    	editor:new Ext.form.TextField({
    		id:'GrpDesc',
    		allowBlank:false,
    		listeners:{
			    specialKey:function(field,e){
    	   	 if(e.getKey()==Ext.EventObject.ENTER){
    	   	       AddNewRow()
    	   	     }
    	        }	    
			   }
    	})
    
    }

 
])
//初始化默认排序功能
LocClaGrpCm.defaultSortable=true
//配置数据源
var Proxy=new Ext.data.HttpProxy({url:Url+'?actiontype=Query&Loc='+loc,method:'GET'});
var LocClaGrpStore=new Ext.data.Store({
    proxy:Proxy,
    autoLoad:true,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pagesize:300
    },[
     {name:'GrpId'},
     {name:'GrpCode'},
     {name:'GrpDesc'}
    ]),
    remoteSort:true,
    pruneModifiedRecords:true
})
var	LocClaGrpGrid=new Ext.grid.EditorGridPanel({
	id:'LocClaGrpGrid',
	title:'分组维护',
	store:LocClaGrpStore,
	draggable:true,
	cm:LocClaGrpCm,
	tbar:[AddButton,SaveButton,DeleteButton],
	//sm:new Ext.grid.RowSelectionModel({rowSelect:'single'}),
	sm:new Ext.grid.CellSelectionModel({}),
	//stripeRows:true,
	//trackMouseOver:true,
	//clicksToEdit:1,
    loadMask:true
})
//科室分类组单击事件
LocClaGrpGrid.addListener("rowclick",function(grid,rowindex,e){
	var SelectRow=LocClaGrpStore.getAt(rowindex);
	GrpRowId=SelectRow.get("GrpId");
	ChooseStore.setBaseParam('rowid',GrpRowId);
	ChooseStore.load({params:{start:0,limit:PagingToolbar.pageSize}});


})
//科室分类组	

//已选物资

var url=Url+"?actiontype=QueryChoose"
var ChooseStore=new Ext.data.Store({
 	url:url,
 	pruneModifiedRecords:true,
 	reader:new Ext.data.JsonReader(
 	{
 	   root:'rows',
		totalProperty:'results',
		id:'LcGiId'
 	},['LcGiId','Incidr','INCICode','INCIDesc','Spec'])
  	
 }) ;

var Choosecm=new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
 	{
 	header:'LcGiId',
 	dataIndex:'LcGiId',
 	align:'left',
 	width:100,
 	hidden:true
 },{
 	header:'Incidr',
 	dataIndex:'Incidr',
 	align:'left',
 	width:100,
 	hidden:true
 },{
 	header:'物资代码',
 	dataIndex:'INCICode',
 	align:'left',
 	width:90
 },{
 	header:'物资名称',
 	dataIndex:'INCIDesc',
 	align:'left',
 	width:165
 },{
 	header:'规格',
 	dataIndex:'Spec',
 	align:'left',
 	width:50
 }
 ]
 );

var closeWin=new Ext.Button({
	text:'关闭窗口',
	iconCls : 'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		window.close();
	}
});
var PagingToolbar = new Ext.PagingToolbar({
    store:ChooseStore,
    pageSize:30,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条，一共 {2} 条',
    emptyMsg:"没有记录"
});
var ChooseGrid = new Ext.grid.GridPanel({
    id:'ChooseGrid',
    title:'已选物资(双击删除)..',
    //autoHeight:true,
    store:ChooseStore,
    draggable:true,
    cm:Choosecm,
    tbar : [closeWin],
    bbar:PagingToolbar,
    //sm:new Ext.grid.RowSelectionModel({rowSelect:'single'}),
    sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
    loadMask:true,
    listeners:{
 	   'rowdblclick':function(grid,ind){
 	   	   var reselectrow=grid.getSelectionModel().getSelected();
	 	   var rowid=reselectrow.get('LcGiId');
	 	   if (rowid=='') return;
	 	   DeleteGrpInci(rowid);		
 	}
 }
});



var LocFilter = new Ext.form.TextField({
    id:'LocFilter',
    fieldLabel:'别名',
    allowBlank:true,
    emptyText:'别名...',
    anchor:'90%',
    selectOnFocus:true
});

var FilterButton = new Ext.Toolbar.Button({
    text : '过滤',
    tooltip : '过滤',
    iconCls : 'page_gear',
    width : 70,
    height : 30,
    handler:function(){
    	var FilterDesc = Ext.getCmp("LocFilter").getValue();
		NotChooseGrid.getStore().setBaseParam('FilterDesc',FilterDesc);
		NotChooseGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});
    }
});

var NotChoosecm=new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
	{
		header:'InRowId',
		hidden:true,
		dataIndex:'InRowId'
	},{
		header:'物资代码',
		dataIndex:'InCode',
		width:90,
		tooltip:'双击可选择'
	},{
		header:'物资名称',
		dataIndex:'InDesc',
		width:160,
		tooltip:'双击可选择'
	},{
		header:'规格',
		dataIndex:'Inspec',
		width:80,
		tooltip:'双击可选择'
	}
]);


var NotChooseurl=Url+"?actiontype=NotChoose&Loc="+loc;
var NotChoosestore = new Ext.data.Store({
	url:NotChooseurl,
	//autoLoad:true,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	},['InRowId',"InCode","InDesc","Inspec"])
});

var PagingToolbar2 = new Ext.PagingToolbar({
    store:NotChoosestore,
    pageSize:30,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条，一共 {2} 条',
    emptyMsg:"没有记录"
});

var NotChooseGrid = new Ext.grid.GridPanel({
	title:'可选物资(双击选择)...',
	autoHeigth:true,
	store:NotChoosestore,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	cm:NotChoosecm,
	bbar:PagingToolbar2,
	tbar:[LocFilter,FilterButton],
	listeners:{
		'rowdblclick':function(grid,ind){
			if(GrpRowId==null){
				Msg.info("warning","请选择分组!");
				return
			}
			var rec=grid.getStore().getAt(ind);
			var InRowId=rec.get('InRowId');
			Add(GrpRowId,InRowId);
		}
	}
});
NotChooseGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});

function Add(GrpRowId,InRowId){
	Ext.Ajax.request({
		url:Url+'?actiontype=addGrpInci&rowid='+GrpRowId+"&Inci="+InRowId,
		success:function(){
			refresh();
			Msg.info('success','增加成功!');
		},
		failure:function(){
			Msg.info('error','增加失败!');
		}
	})
}

function DeleteGrpInci(rowid)
{
	Ext.Ajax.request({
		url:Url+'?actiontype=deleteGrpInci&GrpiId='+rowid,
		success:function(){
			refresh();
			Msg.info('success','删除成功!');
		},
		failure:function(){
			Msg.info('error','删除失败!');
		}	
	})
}

function refresh()
{
	ChooseGrid.getStore().reload();
	NotChooseGrid.getStore().load({params:{start:0,limit:PagingToolbar2.pageSize}});
	//NotChooseGrid.getStore().reload();
}
LocClaGrpGrid.getStore().load()
var window=new Ext.Window({
	title:'维护科室项目分组'+"("+locDesc+")",
	width:960,
	height:550,
	layout:'border',
	modal:true,
	resizable:false,
	items:[{region:'west',width: 230,layout:'fit',items:LocClaGrpGrid},
		{region:'center',layout:'fit',items:ChooseGrid},
		{region:'east',width: 380,layout:'fit',items:NotChooseGrid}]
})
 
window.show();
}
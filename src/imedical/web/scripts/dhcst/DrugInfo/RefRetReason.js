//=====================UI=======================
var RefUrl = 'dhcst.druginfomaintainaction.csp';
///配置数据源
var RefDetailGridProxy= new Ext.data.HttpProxy({url:RefUrl+'?actiontype=GetRefRetReason',method:'POST'});
var RefDetailGridDs = new Ext.data.Store({
	proxy:RefDetailGridProxy,
    reader:new Ext.data.JsonReader({
		totalProperty:'results',
        root:'rows'
    }, [
		{name:'RowID'},
		{name:'Code'},
		{name:'Desc'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
});

///不可退药ComboBox
var RefCombStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
				url : RefUrl+'?actiontype=GetRefRetReaComb&Desc='
			}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['RowID','Desc'])
});

var nm=new Ext.grid.RowNumberer();
var DetailCm=new Ext.grid.ColumnModel([nm,
	{
		header:'RowID',
		dataIndex:'RowID',
		width:100,
		sortable:true//,
		//hidden:true
	},{
		header:'代码',
		dataIndex:'Code',
		width:100,
		sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
	        allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						DetailGrid.startEditing(RefDetailGridDs.getCount() - 1, 3);
					}
				}
			}
	    })
	},{
		header:'名称',
		dataIndex:'Desc',
		width:300,
		sortable:false,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						AddNewRow();
					}
				}
			}
        })
	}
]);

//代码
var CodeField = new Ext.form.TextField({
	id:'CodeField',
	fieldLabel:'代码',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true
});

//名称
var DescField = new Ext.form.TextField({
	id:'DescField',
	fieldLabel:'名称',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true
});

var PagingToolBar1=new Ext.PagingToolbar({
	id:'PagingToolBar1',
	store:RefDetailGridDs,
	displayInfo:true,
	pageSize:'30',
	displayMsg:"第 {0} 条到 {1}条 ，一共 {2} 条",
	emptyMsg:"没有数据",
	firstText:'第一页',
	lastText:'最后一页',
	prevText:'上一页',
	refreshText:'刷新',
	nextText:'下一页'		
});

//原因
var RefReasonCmb = new Ext.ux.ComboBox({
	fieldLabel : '原因',
	id : 'RefReasonCmb',
	name : 'RefReasonCmb',
	store : RefCombStore,
	valueField : 'RowID',
	displayField : 'Desc',
	anchor:'90%',
	filterName : 'Desc'
});


var AddRefBT = new Ext.Toolbar.Button({
	text:'增加',
    tooltip:'增加',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		AddNewRow();
	}
});

var SaveRefBT = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		SaveRow();
	}
});

var DelRefBT = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		DelRow();
	}
}); 

var DetailGrid=new Ext.grid.EditorGridPanel({
	id:'DetailGrid',
	height : 200,
	region:'center',
	store:RefDetailGridDs,
	loadMask:true,
	cm:DetailCm,
	sm:new Ext.grid.CellSelectionModel({}),
	takeMouseOver:true,
	clicksToEdit:1,
	bbar:PagingToolBar1,
	tbar:[AddRefBT,'-',SaveRefBT,'-',DelRefBT]
});

var UpdRefBT = new Ext.Button({
	text:'更新',
    tooltip:'更新',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		UpdStkRefReason();
	}
});

var refRetBT=new Ext.Button({
	text : '维护',
	id : 'refRetBT',
	width : 30,
	handler : function() {
		if (drugRowid==""){
			Msg.info("warning","请选择需要维护拒绝退药原因的库存项！");
			return;
		}
		CreateEditWin(drugRowid);
	}
})

var refRetTF=new Ext.form.TextField({
	fieldLabel : '拒绝退药原因',
	id : 'refRetTF',
	name : 'refRetTF',
	//readOnly : true,
	disabled:true,
	anchor : '90%',
	width : 370,
	valueNotFoundText : ''
})

var RefWin="";
var CacelRefBT = new Ext.Button({
	text:'关闭',
    tooltip:'关闭',
    iconCls:'page_close',
    width : 70,
	height : 30,
	handler:function(){
		RefWin.hide();
	}
});

//初始化面板
var RefReaPanel = new Ext.form.FormPanel({
	labelWidth : 40,
	labelAlign : 'right',
	frame : true,
	autoScroll : true,
	defaults:{style:'padding:0px,0px,0px,0px',border:true},
	items : [{
		autoHeight : true,
		items : [{
			xtype : 'fieldset',
			title : '字典维护',
			autoHeight : true,
			items : [{
				layout : 'column',
				height:200,
				items : [DetailGrid]
			}]
		},{
			xtype : 'fieldset',
			title : '原因维护',
			buttons:[UpdRefBT,CacelRefBT],
			autoHeight : true,
			items : [{
				layout:'column',
				height:25,
				defaults:{border:false},
				items : [					
					{columnWidth:.35,layout:'form',items:[CodeField]},
					{columnWidth:.65,layout:'form',items:[DescField]}
				]
			},{
				layout:'column',
				height:25,
				defaults:{border:false},
				items : [					
					{columnWidth:.9,layout:'form',items:[RefReasonCmb]}
				]
			}]
		}]
	}]
})



	
function CreateEditWin(rowid)
{
	//初始化窗口
	RefWin = new Ext.Window({
		title:'不可退药原因维护',
		width:600,
		height:450,
		layout:'fit',
		buttonAlign:'center',
		items:RefReaPanel,
		closeAction: 'hide',
		listeners:{
			'show':function(){
				RefDetailGridDs.load({params:{start:0,limit:PagingToolBar1.pageSize}});
				RefCombStore.load({params:{start:0,limit:PagingToolBar1.pageSize}});
				InitForm(rowid);
			}
		}
	});
	RefWin.show(); 
}

//=====================UI=======================
///增加
function AddNewRow()
{
	var record = Ext.data.Record.create([
		{
			name : 'RowID',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}
	]);
		
	var NewRecord = new record({
		RowID:'',
		Code:'',
		Desc:''
	});
		
	RefDetailGridDs.add(NewRecord);
	DetailGrid.startEditing(RefDetailGridDs.getCount() - 1, 2);
}

///保存
function SaveRow()
{
	//获取所有的新记录 
	var mr=RefDetailGridDs.getModifiedRecords();
	var ListDate="";
	for(var i=0;i<mr.length;i++){ 
		var code = mr[i].data["Code"].trim();
		var desc = mr[i].data["Desc"].trim();
		if((code!="")&&(desc!="")){
			var dataRow = mr[i].data["RowID"]+"^"+code+"^"+desc;
			if(ListDate==""){
				ListDate = dataRow;
			}else{
				ListDate = ListDate+"#"+dataRow;
			}
		}
	}

	if(ListDate==""){
		Msg.info("error","没有修改或添加新数据!");
		return false;
	}else{
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: RefUrl+'?actiontype=SaveRefReason',
			params:{ListDate:ListDate},
			failure: function(result, request) {
				 mask.hide();
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","保存成功!");
					RefDetailGridDs.load({params:{start:0,limit:PagingToolBar1.pageSize}});
				}else{
					if(jsonData.info==-1){
						Msg.info("error","代码重复!");
					}else if(jsonData.info==-2){
						Msg.info("error","名称重复!");
					}else{
						Msg.info("error","保存失败"+jsonData);
					}
					RefDetailGridDs.load({params:{start:0,limit:PagingToolBar1.pageSize}});
				}
			},
			scope: this
		});
	}
}

///删除
function DelRow()
{
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","请选择数据!");
		return false;
	}else{
		var record = DetailGrid.getStore().getAt(cell[0]);
		var RowId = record.get("RowID");
		if(RowId!=""){
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
						Ext.Ajax.request({
							url:RefUrl+'?actiontype=DelRefReason&RowID='+RowId,
							waitMsg:'删除中...',
							failure: function(result, request) {
								 mask.hide();
								Msg.info("error","请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								 mask.hide();
								if (jsonData.success=='true') {
									Msg.info("success","删除成功!");
									RefDetailGridDs.load({params:{start:0,limit:PagingToolBar1.pageSize}});
								}else{
									Msg.info("error","删除失败!");
								}
							},
							scope: this
						});
					}
				}
			)
		}else{
			Msg.info("error","数据有错!");
		}
	}
}

///更新药品拒绝原因
function UpdStkRefReason()
{
	var InciCode=Ext.getCmp('CodeField').getValue();
	var RefReaDr=Ext.getCmp('RefReasonCmb').getValue();
	var RefReason=Ext.getCmp('RefReasonCmb').getRawValue();

	if(RefReaDr==null){
		Msg.info("error","请选择要更新的原因!");
		return false;
	}else{
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:RefUrl+'?actiontype=UpdDrgRefReason&InciCode='+InciCode+'&RefReaDr='+RefReaDr,
			waitMsg:'更新中...',
			failure: function(result, request) {
				mask.hide();
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","更新成功!");
					Ext.getCmp('refRetTF').setValue(RefReason);
				}else{
					Msg.info("error","更新失败!");
				}
			},
			scope: this
		});

		}
}

function InitForm(rowid)
{       
       
	var url = RefUrl+'?actiontype=GetRefReason&IncRowid='+rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var s = result.responseText;
			var jsonData = Ext.util.JSON.decode(s);
			if (jsonData.success == 'true') {
				var list = jsonData.info.split("^");
				Ext.getCmp('CodeField').setValue(list[0]); //代码
				Ext.getCmp('DescField').setValue(list[1]); //名称
				Ext.getCmp('RefReasonCmb').setValue(list[2]); //原因
				///设置不可编辑
				Ext.getCmp('CodeField').setDisabled(true);
				Ext.getCmp('DescField').setDisabled(true);		
			} 
		},
		scope : this
	});
}
// 名称:供应商类别管理
// 编写日期:2012-05-15

//=========================供应商类别=================================
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
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
		RowId:'',
		Code:'',
		Desc:''
	});
					
	ApcVendCatGridDs.add(NewRecord);
	ApcVendCatGrid.startEditing(ApcVendCatGridDs.getCount() - 1, 1);
}
	
var ApcVendCatGrid="";
//配置数据源
var ApcVendCatGridUrl = 'dhcst.apcvendcataction.csp';
var ApcVendCatGridProxy= new Ext.data.HttpProxy({url:ApcVendCatGridUrl+'?actiontype=selectAll',method:'GET'});
var ApcVendCatGridDs = new Ext.data.Store({
	proxy:ApcVendCatGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
});



//模型
var ApcVendCatGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("代码"),
        dataIndex:'Code',
        width:180,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ApcVendCatGrid.startEditing(ApcVendCatGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:$g("名称"),
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
        })
    }
]);

//初始化默认排序功能
ApcVendCatGridCm.defaultSortable = true;

var addApcVendCat = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveApcVendCat = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=ApcVendCatGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){

			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
			else if((code=="")&&(desc!="")){
				Msg.info("error", $g("代码不能为空!"));
			    return false;
			}
			else if((code!="")&&(desc=="")){
				Msg.info("error", $g("名称不能为空!"));
			    return false;
			}
		}
		
		if(data==""){
			Msg.info("error", $g("没有修改或添加新数据!"));
			return false;
		}
		else{
			var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
			Ext.Ajax.request({
				url: ApcVendCatGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					Msg.info("error", $g("请检查网络连接!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", $g("保存成功!"));
						ApcVendCatGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("warning", $g("代码重复!"));
						}else if(jsonData.info==-2){
							Msg.info("warning", $g("名称重复!"));
						}else{
							Msg.info("error", $g("保存失败!"));
						}
						ApcVendCatGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});

var deleteApcVendCat = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ApcVendCatGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", $g("请选择数据!"));
			return false;
		}else{
			var record = ApcVendCatGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
							Ext.Ajax.request({
								url:ApcVendCatGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('删除中...'),
								failure: function(result, request) {
									Msg.info("error", $g("请检查网络连接!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", $g("删除成功!"));
										ApcVendCatGridDs.load();
									}else{
										if (jsonData.info=="-1"){
											Msg.info("warning", $g("该分类已经在供应商定义中使用，不允许删除!"));
										}
										else{
											Msg.info("error", $g("删除失败!"));
										}
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error", $g("数据有错,没有RowId!"));
			}
		}
    }
});
var HospWinButton = GenHospWinButton("PH_Manufacturer");

//绑定点击事件
HospWinButton.on("click" , function(){
	var cell = ApcVendCatGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("warning", $g("请选择数据!"));
		return;
	}
	var record = ApcVendCatGrid.getStore().getAt(cell[0]);
	var rowID = record.get("RowId");
	if (rowID===''){
		Msg.info("warning",$g("请先保存数据!"));
		return;	
	}
    GenHospWin("APC_VendCat",rowID,function(){ApcVendCatGridDs.reload();}).show()   
});
var HospPanel = InitHospCombo('APC_VendCat',function(combo, record, index){
	HospId = this.value; 
	ApcVendCatGridDs.reload();
});
//表格
ApcVendCatGrid = new Ext.grid.EditorGridPanel({
	store:ApcVendCatGridDs,
	cm:ApcVendCatGridCm,
	trackMouseOver:true,
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addApcVendCat,'-',saveApcVendCat,'-',deleteApcVendCat,'-',HospWinButton],
	clicksToEdit:1
});

ApcVendCatGridDs.load();
//=========================供应商类别=================================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var ApcVendCatPanel = new Ext.Panel({
		title:$g('供应商分类维护'),
		activeTab: 0,
		region:'center',
		items:[ApcVendCatGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items:[HospPanel,ApcVendCatPanel],
		renderTo: 'mainPanel'
	});
});
//===========模块主页面===============================================
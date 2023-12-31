//实盘窗口维护
//2013-07-25
//zhangxiao
//InStkTkWindow.js

var LocId = session['LOGON.CTLOCID'];
function addNewRow(){
	var record=Ext.data.Record.create([
	    {
		    name:'RowId',
		    type:'int'
		},{
			name:'Code',
			type:'string'
		},{
			name:'Desc',
			type:'string'
		}
	]);
	var NewRecord=new record({
		RowId:'',
		Code:'',
		Desc:''
		});
	InStkTkWindowGriDs.add(NewRecord);
	InStkTkWindowGrid.startEditing(InStkTkWindowGriDs.getCount()-1,1)
	}

var InStkTkWindowGrid=""
//配置数据源
var InStkTkWindowGridUrl='dhcst.instktkwindowaction.csp';
var InStkTkWindowGridProxy=new Ext.data.HttpProxy({url:InStkTkWindowGridUrl+'?actiontype=query&LocId='+LocId,method:'GET'});
var InStkTkWindowGriDs=new Ext.data.Store({
	proxy:InStkTkWindowGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results',
		pagesize:35
	},[
	    {name:'RowId'},
	    {name:'Code'},
	    {name:'Desc'}
	]),
	remoteSort:true,
	pruneModifiedRecords:true
	})
//模型

//模型
var InStkTkWindowGridCm = new Ext.grid.ColumnModel([
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
						InStkTkWindowGrid.startEditing(InStkTkWindowGriDs.getCount() - 1, 2);
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
InStkTkWindowGridCm.defaultSortable = true;

var addInStkTkWindow=new Ext.Toolbar.Button({
	text:$g('新建'),
	tooltip:$g('新建'),
	iconCls:'page_add',
	width:70,
	height:30,
	handler:function(){
		addNewRow()
		}
	})
var saveInStkTkWindow=new Ext.Toolbar.Button({
	text:$g('保存'),
	tooltip:$g('保存'),
	iconCls:'page_save',
	width:70,
	height:30,
	handler:function(){
		//获取所有的新记录 
		var mr=InStkTkWindowGriDs.getModifiedRecords();
		var data="";
		for (i=0;i<mr.length;i++){
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var rowNum = InStkTkWindowGriDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", $g("第")+rowNum+$g("行代码为空!"));
				return;
			}
			if (desc==""){
				Msg.info("warning", $g("第")+rowNum+$g("行名称为空!"));
				return;
			}
			if((code!="")&&(desc!="")){
				var dataRow=mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+LocId
				if(data==""){
					data=dataRow}
				else{
					data=data+xRowDelim()+dataRow   
					}	 
				}
			}
			
		if(data==""){
			Msg.info("warning",$g("没有修改或添加新数据!"));
			return false;
			}else{
				var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
				Ext.Ajax.request({
					url:InStkTkWindowGridUrl+'?actiontype=save',
					params:{data:data},
					failure:function(result,request){
						mask.hide();
						Msg.info("error",$g("请检查网络连接!"))
						},
					success:function(result,request){
						var jsonData=Ext.util.JSON.decode(result.responseText);
						mask.hide();
						if(jsonData.success=='true'){
							Msg.info("success",$g("保存成功!"));
							InStkTkWindowGriDs.load()
						}else{
							if(jsonData.info==-1){
								Msg.info("warning", $g("代码重复!"));
							}else if(jsonData.info==-2){
								Msg.info("warning", $g("名称重复!"));
							}else{
								Msg.info("error", $g("保存失败!"));
							}
							InStkTkWindowGriDs.load()
						}
							
					},	
					scope:this
					});
				}	
			
			
		}
	})

var deleteInStkTkWindow=new Ext.Toolbar.Button({
	text:$g('删除'),
	tooltip:$g('删除'),
	iconCls:'page_delete',
	width:70,
	height:30,
	handler:function(){
		deleteDetail();
		}
	})
//删除函数	
function deleteDetail(){
	var cell=InStkTkWindowGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("warning",$g("请选择数据!"));
		return false;
		}else{
			var record=InStkTkWindowGrid.getStore().getAt(cell[0]);
			var RowId=record.get("RowId")
			if (RowId!=""){
				Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
							Ext.Ajax.request({
								url:InStkTkWindowGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('删除中...'),
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", $g("请检查网络连接!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", $g("删除成功!"));
										InStkTkWindowGriDs.load()
									}else{
										Msg.info("error", $g("删除失败!"));
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
						InStkTkWindowGrid.getStore().removeAt(rowInd)
						}
					}
				
				
			}
		}	
//表格
InStkTkWindowGrid=new Ext.grid.EditorGridPanel({
	store:InStkTkWindowGriDs,
	cm:InStkTkWindowGridCm,
	trackMouseOver:true,
	region:'center',
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMast:true,
	tbar:[addInStkTkWindow,'-',saveInStkTkWindow],		//,'-',deleteInStkTkWindow
	clicksToEdit:1
	})
InStkTkWindowGriDs.load()
//===========模块主页面===============================================
Ext.onReady(function(){
Ext.QuickTips.init();
Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var panel=new Ext.Panel({
	title:$g('实盘窗口'),
	activeTab:0,
	region:'center',
	items:[InStkTkWindowGrid]
	});
	
var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
	
})
//===========模块主页面===============================================
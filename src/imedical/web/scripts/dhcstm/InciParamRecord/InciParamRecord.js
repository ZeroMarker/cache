/// 物资属性审核维护
/// 20190306 lihui
/// 

// 同步属性信息
var synchroParams = new Ext.Toolbar.Button({
	text:'同步属性信息',
	tooltip:'同步属性信息',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var synchroRet = tkMakeServerCall("web.DHCSTM.Tools.InciParamRecordS","synchroParams");
		var synchroRetArr = synchroRet.split("^");
		Msg.info("success","遍历"+synchroRetArr[1]+"个, 新增"+synchroRetArr[0]+"个!");
		InciParamRecordStore.reload();
	}
});

//配置数据源
var InciParamRecordUrl='dhcstm.inciparamrecordaction.csp';
var InciParamRecordProxy=new Ext.data.HttpProxy({url:InciParamRecordUrl+'?actiontype=Query',method:'GET'});
var InciParamRecordStore = new Ext.data.Store({
    proxy:InciParamRecordProxy,
    reader:new Ext.data.JsonReader({
	    root:'rows',
	    totalProperty:'results'
	  },[
	    {name:'RowId'},
	    {name:'INCIPParamName'},
	    {name:'INCIPDesc'},
	    {name:'AuditFlag'}
	    
	  ]),
    remoteSort:true
});

var AuditFlag = new Ext.grid.CheckColumn({
    header:'审核标志',
    dataIndex:'AuditFlag',
    width:80,
    sortable:true
});

//模型
var nm=new Ext.grid.RowNumberer();
var InciParamRecordCm = new Ext.grid.ColumnModel([
    nm,
    {
	   header:"RowId",
	   dataIndex:'RowId',
	   hidden:true,
	   sortable:true,
	   align:'left'
	},{
	   header:"字段描述",
	   dataIndex:'INCIPDesc',
	   width:180,
	   sortable:true,
	   align:'left',
	   editor: new Ext.form.TextField({
			id:'INCIPDesc',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						InciParamRecordGrid.startEditing(InciParamRecordStore.getCount() - 1, 2);
					}
				}
			}
        })
    },{
	    header:"字段名称",
	   dataIndex:'INCIPParamName',
	   width:180,
	   sortable:true,
	   align:'left',
	   editor: new Ext.form.TextField({
			id:'INCIPParamName',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						InciParamRecordGrid.startEditing(InciParamRecordStore.getCount() - 1, 3);
					}
				}
			}
        })
	},AuditFlag
]); 


//方法
function addNewRow(){
    var DataRecord = CreateRecordInstance(InciParamRecordStore.fields, "");
					
	InciParamRecordStore.add(DataRecord);
	InciParamRecordGrid.startEditing(InciParamRecordStore.getCount()-1,2);
}

function INCIPSave()
{
	var modirec=InciParamRecordStore.getModifiedRecords();
	var datas="";
	for(var i=0;i<modirec.length;i++){
	   var rowid=modirec[i].data["RowId"];
	   var INCIPDesc=modirec[i].data["INCIPDesc"].trim();
	   var INCIPParamName=modirec[i].data["INCIPParamName"].trim();
	   var AuditFlag=modirec[i].data["AuditFlag"].trim();
	   if (((INCIPDesc=="")||(INCIPParamName==""))){
		   Msg.info("warning","字段描述或者字段名称不能为空!");
	       return;
	   }
	   if (INCIPDesc!=""&&INCIPParamName!=""){
	       var datarow=rowid+"^"+INCIPDesc+"^"+INCIPParamName+"^"+AuditFlag;
	       if (datas==""){
		       datas=datarow;
		   }else{
			   datas=datas+xRowDelim()+datarow;
		   }
	   }
	}
    if (datas=="")
    {
	    Msg.info("warning","没有需要保存的数据!");
    }else{
	    var mask=ShowLoadMask(Ext.getBody(),"处理中...");
	    Ext.Ajax.request({
		    url:InciParamRecordUrl+'?actiontype=Save',
		    params:{datas:datas},
		    failure:function(result,request){
			    mask.hide();
			    Msg.info("error","请检查网络链接!");
			    InciParamRecordStore.commitChanges();
			},
		    success:function(result,request){
			    mask.hide();
			    var jsondata=Ext.util.JSON.decode(result.responseText);
			    if (jsondata.success=='true'){
				    Msg.info("success","保存成功!");
				    InciParamRecordStore.load();
				}else{
					Msg.info("error","保存失败"+jsondata.info);
					InciParamRecordStore.load();
			    }
			    InciParamRecordStore.commitChanges();
			},
		    scope:this
		});
	}
}
function INCIPDelete()
{
	var cell=InciParamRecordGrid.getSelectionModel().getSelectedCell();
    if (cell==null){
	    Msg.info("warning","请选择要删除的数据!");
	    return false;
	}else{
	    var record=InciParamRecordGrid.getStore().getAt(cell[0]);
	    var rowid=record.get("RowId");
	    if (rowid!=""){
		    Ext.MessageBox.confirm("提示","确定要删除此行?",
		    function(btn){
			    if (btn=="yes"){
				    var mask=ShowLoadMask(Ext.getBody(),"处理中...");
				    Ext.Ajax.request
				     ({
					    url:InciParamRecordUrl+'?actiontype=delete&rowid='+rowid,
					    waitMsg:'删除中...', 
					    failure:function(result,request)
					        {
						       mask.hide();
						       Msg.info("error","请检查网络"); 
						    },
						success:function(result,request)
					    {
						        var jsondata=Ext.util.JSON.decode(result.responseText);
						        mask.hide();
						        if(jsondata.success=='true'){
							        Msg.info("success","删除成功");
							        InciParamRecordGrid.store.removeAll();
							        InciParamRecordGrid.getView().refresh();
							        InciParamRecordStore.load();
							    }else{
								    Msg.info("error","删除失败"+jsondata.info);
								    InciParamRecordGrid.store.removeAll();
								    InciParamRecordGrid.getView().refresh();
							        InciParamRecordStore.load();
								}
						},
					    scope:this 
					 });
				}
			
			
			})
	    }else{
		      InciParamRecordStore.remove(record);
			  InciParamRecordGrid.getView().refresh();
	    }
		}
}

var INCIPSearchBT = new Ext.Toolbar.Button({
    id : "SearchBT",
	text : '查询',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		InciParamRecordStore.load();
	}
});

var INCIPAddBT = new Ext.Toolbar.Button({
	id : 'INCIPAddBT',
    text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var INCIPSaveBT = new Ext.Toolbar.Button({
	id : 'INCIPSaveBT',
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		    INCIPSave();
		}
	
});

var INCIPDeleteBT = new Ext.Toolbar.Button({
	id : 'INCIPDeleteBT',
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		   INCIPDelete();
		}
	
});
var InciParamRecordGrid = new Ext.grid.EditorGridPanel({
	title:'物资属性审核维护',
	id : 'InciParamRecordGrid',
	store:InciParamRecordStore,
	cm:InciParamRecordCm,
	region:'center',
	plugins:[AuditFlag],
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[INCIPSearchBT,'-',INCIPAddBT,'-',INCIPSaveBT,'-',INCIPDeleteBT,'-',synchroParams],
    clicksToEdit:1
});
//页面布局
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
	    layout:'fit',
	    items:[InciParamRecordGrid]
	});
INCIPSearchBT.handler();
});
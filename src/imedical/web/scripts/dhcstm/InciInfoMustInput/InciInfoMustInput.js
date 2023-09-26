///基础字典控件必填项维护
///20170326 lihui
///需要随时同步物资维护界面的控件id值;控件id以及所在菜单csp名称一起作为唯一记录判断

//控件信息同步
var synchroElems = new Ext.Toolbar.Button({
	text:'同步控件信息',
	tooltip:'同步控件信息',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var synchroRet = tkMakeServerCall("web.DHCSTM.Tools.InciInfoMustInpinfo","synchroElems");
		var synchroRetArr = synchroRet.split("^");
		Msg.info("success","遍历"+synchroRetArr[1]+"个, 新增"+synchroRetArr[0]+"个!");
		InciInfoMIStore.reload();
	}
});

//配置数据源
var InciInfoMIUrl='dhcstm.inciinfomustinputaction.csp';
var InciInfoMIProxy=new Ext.data.HttpProxy({url:InciInfoMIUrl+'?actiontype=Query',method:'GET'});
var InciInfoMIStore = new Ext.data.Store({
    proxy:InciInfoMIProxy,
    reader:new Ext.data.JsonReader({
	    root:'rows',
	    totalProperty:'results'
	  },[
	    {name:'RowId'},
	    {name:'INCMIEleId'},
	    {name:'INCMIEleName'},
	    {name:'INCMICspName'},
	    {name:'cspCHNname'} ,
	    {name:'INCMIMustFlag'}
	    
	  ]),
    remoteSort:true
});

var INCMIMustFlag = new Ext.grid.CheckColumn({
    header:'是否必填',
    dataIndex:'INCMIMustFlag',
    width:80,
    sortable:true
});

//模型
var nm=new Ext.grid.RowNumberer();
var InciInfoMICm = new Ext.grid.ColumnModel([
    nm,
    {
	   header:"RowId",
	   dataIndex:'RowId',
	   hidden:true,
	   sortable:true,
	   align:'left'
	},{
	   header:"控件id",
	   dataIndex:'INCMIEleId',
	   width:180,
	   sortable:true,
	   align:'left',
	   editor: new Ext.form.TextField({
			id:'INCMIEleId',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						InciInfoMIGrid.startEditing(InciInfoMIStore.getCount() - 1, 2);
					}
				}
			}
        })
    },{
	    header:"控件名称",
	   dataIndex:'INCMIEleName',
	   width:180,
	   sortable:true,
	   align:'left',
	   editor: new Ext.form.TextField({
			id:'INCMIEleName',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						InciInfoMIGrid.startEditing(InciInfoMIStore.getCount() - 1, 3);
					}
				}
			}
        })
	},{
		header:"CSP名称",
	   dataIndex:'INCMICspName',
	   width:180,
	   sortable:true,
	   align:'left',
	   editor: new Ext.form.TextField({
			id:'INCMICspName',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
        })
    },{
		header:"菜单名称",
	   dataIndex:'cspCHNname',
	   width:180,
	   sortable:true,
	   align:'left'
    },INCMIMustFlag
]); 


//方法
function addNewRow(){
    var record=Ext.data.Record.create([
        {
	        name:'RowId',
	        type:'int'
	    },{
	        name:'INCMIEleId',
	        type:'string'
	    },{
	        name:'INCMIEleName',
	        type:'string'
	    },{
	        name:'INCMICspName',
	        type:'string'
	    },{
	        name:'cspCHNname',
	        type:'string'
	    },{
	        name:'INCMIMustFlag',
	        type:'string'
	    }
    ]);
    var NewRecord=new record({
	    RowId:'',
	    INCMIEleId:'',
	    INCMIEleName:'',
	    INCMICspName:'',
	    cspCHNname:'',
	    INCMIMustFlag:''
	});
	InciInfoMIStore.add(NewRecord);
	InciInfoMIGrid.startEditing(InciInfoMIStore.getCount()-1,2);
}

function INCMISave()
{
	var modirec=InciInfoMIStore.getModifiedRecords();
	var datas="";
	for(var i=0;i<modirec.length;i++){
	   var rowid=modirec[i].data["RowId"];
	   var incmieleid=modirec[i].data["INCMIEleId"].trim();
	   var incmielename=modirec[i].data["INCMIEleName"].trim();
	   var incmicspname=modirec[i].data["INCMICspName"].trim();
	   var incmimustflag=modirec[i].data["INCMIMustFlag"].trim();
	   if (((incmicspname!="")&&(incmieleid=="")||(incmieleid==null))||((incmieleid!="")&&(incmicspname=="")||(incmicspname==null))){
		   Msg.info("warning","控件id或者csp名称不能为空!");
	       return;
	   }
	   if (incmieleid!=""&&incmicspname!=""){
	       var datarow=rowid+"^"+incmieleid+"^"+incmielename+"^"+incmicspname+"^"+incmimustflag;
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
		    url:InciInfoMIUrl+'?actiontype=save',
		    params:{datas:datas},
		    failure:function(result,request){
			    mask.hide();
			    Msg.info("error","请检查网络链接!");
			    InciInfoMIStore.commitChanges();
			},
		    success:function(result,request){
			    mask.hide();
			    var jsondata=Ext.util.JSON.decode(result.responseText);
			    if (jsondata.success=='true'){
				    Msg.info("success","保存成功!");
				    InciInfoMIStore.load();
				}else{
					Msg.info("error","保存失败"+jsondata.info);
					InciInfoMIStore.load();
			    }
			    InciInfoMIStore.commitChanges();
			},
		    scope:this
		});
	}
}
function INCMIDelete()
{
	var cell=InciInfoMIGrid.getSelectionModel().getSelectedCell();
    if (cell==null){
	    Msg.info("warning","请选择要删除的数据!");
	    return false;
	}else{
	    var record=InciInfoMIGrid.getStore().getAt(cell[0]);
	    var rowid=record.get("RowId");
	    if (rowid!=""){
		    Ext.MessageBox.confirm("提示","确定要删除此行?",
		    function(btn){
			    if (btn=="yes"){
				    var mask=ShowLoadMask(Ext.getBody(),"处理中...");
				    Ext.Ajax.request
				     ({
					    url:InciInfoMIUrl+'?actiontype=delete&rowid='+rowid,
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
							        InciInfoMIGrid.store.removeAll();
							        InciInfoMIGrid.getView().refresh();
							        InciInfoMIStore.load();
							    }else{
								    Msg.info("error","删除失败"+jsondata.info);
								    InciInfoMIGrid.store.removeAll();
								    InciInfoMIGrid.getView().refresh();
							        InciInfoMIStore.load();
								}
						},
					    scope:this 
					 });
				}
			
			
			})
	    }else{
		      InciInfoMIStore.remove(record);
			  InciInfoMIGrid.getView().refresh();
	    }
		}
}

var INCMISearchBT = new Ext.Toolbar.Button({
    id : "SearchBT",
	text : '查询',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		InciInfoMIStore.load();
	}
});

var INCMIAddBT = new Ext.Toolbar.Button({
	id : 'INCMIAddBT',
    text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var INCMISaveBT = new Ext.Toolbar.Button({
	id : 'INCMISaveBT',
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		    INCMISave();
		}
	
});

var INCMIDeleteBT = new Ext.Toolbar.Button({
	id : 'INCMIDeleteBT',
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		   INCMIDelete();
		}
	
});
var InciInfoMIGrid = new Ext.grid.EditorGridPanel({
	title:'基础字典必填项维护',
	id : 'InciInfoMIGrid',
	store:InciInfoMIStore,
	cm:InciInfoMICm,
	region:'center',
	plugins:[INCMIMustFlag],
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[INCMISearchBT,'-',INCMIAddBT,'-',INCMISaveBT,'-',INCMIDeleteBT,'-',synchroElems],
    clicksToEdit:1
});
//页面布局
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
	    layout:'fit',
	    items:[InciInfoMIGrid]
	});
INCMISearchBT.handler();
});
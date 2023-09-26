/// �����������ά��
/// 20190306 lihui
/// 

// ͬ��������Ϣ
var synchroParams = new Ext.Toolbar.Button({
	text:'ͬ��������Ϣ',
	tooltip:'ͬ��������Ϣ',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var synchroRet = tkMakeServerCall("web.DHCSTM.Tools.InciParamRecordS","synchroParams");
		var synchroRetArr = synchroRet.split("^");
		Msg.info("success","����"+synchroRetArr[1]+"��, ����"+synchroRetArr[0]+"��!");
		InciParamRecordStore.reload();
	}
});

//��������Դ
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
    header:'��˱�־',
    dataIndex:'AuditFlag',
    width:80,
    sortable:true
});

//ģ��
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
	   header:"�ֶ�����",
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
	    header:"�ֶ�����",
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


//����
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
		   Msg.info("warning","�ֶ����������ֶ����Ʋ���Ϊ��!");
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
	    Msg.info("warning","û����Ҫ���������!");
    }else{
	    var mask=ShowLoadMask(Ext.getBody(),"������...");
	    Ext.Ajax.request({
		    url:InciParamRecordUrl+'?actiontype=Save',
		    params:{datas:datas},
		    failure:function(result,request){
			    mask.hide();
			    Msg.info("error","������������!");
			    InciParamRecordStore.commitChanges();
			},
		    success:function(result,request){
			    mask.hide();
			    var jsondata=Ext.util.JSON.decode(result.responseText);
			    if (jsondata.success=='true'){
				    Msg.info("success","����ɹ�!");
				    InciParamRecordStore.load();
				}else{
					Msg.info("error","����ʧ��"+jsondata.info);
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
	    Msg.info("warning","��ѡ��Ҫɾ��������!");
	    return false;
	}else{
	    var record=InciParamRecordGrid.getStore().getAt(cell[0]);
	    var rowid=record.get("RowId");
	    if (rowid!=""){
		    Ext.MessageBox.confirm("��ʾ","ȷ��Ҫɾ������?",
		    function(btn){
			    if (btn=="yes"){
				    var mask=ShowLoadMask(Ext.getBody(),"������...");
				    Ext.Ajax.request
				     ({
					    url:InciParamRecordUrl+'?actiontype=delete&rowid='+rowid,
					    waitMsg:'ɾ����...', 
					    failure:function(result,request)
					        {
						       mask.hide();
						       Msg.info("error","��������"); 
						    },
						success:function(result,request)
					    {
						        var jsondata=Ext.util.JSON.decode(result.responseText);
						        mask.hide();
						        if(jsondata.success=='true'){
							        Msg.info("success","ɾ���ɹ�");
							        InciParamRecordGrid.store.removeAll();
							        InciParamRecordGrid.getView().refresh();
							        InciParamRecordStore.load();
							    }else{
								    Msg.info("error","ɾ��ʧ��"+jsondata.info);
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
	text : '��ѯ',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		InciParamRecordStore.load();
	}
});

var INCIPAddBT = new Ext.Toolbar.Button({
	id : 'INCIPAddBT',
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var INCIPSaveBT = new Ext.Toolbar.Button({
	id : 'INCIPSaveBT',
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		    INCIPSave();
		}
	
});

var INCIPDeleteBT = new Ext.Toolbar.Button({
	id : 'INCIPDeleteBT',
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		   INCIPDelete();
		}
	
});
var InciParamRecordGrid = new Ext.grid.EditorGridPanel({
	title:'�����������ά��',
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
//ҳ�沼��
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
	    layout:'fit',
	    items:[InciParamRecordGrid]
	});
INCIPSearchBT.handler();
});
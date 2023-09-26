///�����ֵ�ؼ�������ά��
///20170326 lihui
///��Ҫ��ʱͬ������ά������Ŀؼ�idֵ;�ؼ�id�Լ����ڲ˵�csp����һ����ΪΨһ��¼�ж�

//�ؼ���Ϣͬ��
var synchroElems = new Ext.Toolbar.Button({
	text:'ͬ���ؼ���Ϣ',
	tooltip:'ͬ���ؼ���Ϣ',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var synchroRet = tkMakeServerCall("web.DHCSTM.Tools.InciInfoMustInpinfo","synchroElems");
		var synchroRetArr = synchroRet.split("^");
		Msg.info("success","����"+synchroRetArr[1]+"��, ����"+synchroRetArr[0]+"��!");
		InciInfoMIStore.reload();
	}
});

//��������Դ
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
    header:'�Ƿ����',
    dataIndex:'INCMIMustFlag',
    width:80,
    sortable:true
});

//ģ��
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
	   header:"�ؼ�id",
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
	    header:"�ؼ�����",
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
		header:"CSP����",
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
		header:"�˵�����",
	   dataIndex:'cspCHNname',
	   width:180,
	   sortable:true,
	   align:'left'
    },INCMIMustFlag
]); 


//����
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
		   Msg.info("warning","�ؼ�id����csp���Ʋ���Ϊ��!");
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
	    Msg.info("warning","û����Ҫ���������!");
    }else{
	    var mask=ShowLoadMask(Ext.getBody(),"������...");
	    Ext.Ajax.request({
		    url:InciInfoMIUrl+'?actiontype=save',
		    params:{datas:datas},
		    failure:function(result,request){
			    mask.hide();
			    Msg.info("error","������������!");
			    InciInfoMIStore.commitChanges();
			},
		    success:function(result,request){
			    mask.hide();
			    var jsondata=Ext.util.JSON.decode(result.responseText);
			    if (jsondata.success=='true'){
				    Msg.info("success","����ɹ�!");
				    InciInfoMIStore.load();
				}else{
					Msg.info("error","����ʧ��"+jsondata.info);
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
	    Msg.info("warning","��ѡ��Ҫɾ��������!");
	    return false;
	}else{
	    var record=InciInfoMIGrid.getStore().getAt(cell[0]);
	    var rowid=record.get("RowId");
	    if (rowid!=""){
		    Ext.MessageBox.confirm("��ʾ","ȷ��Ҫɾ������?",
		    function(btn){
			    if (btn=="yes"){
				    var mask=ShowLoadMask(Ext.getBody(),"������...");
				    Ext.Ajax.request
				     ({
					    url:InciInfoMIUrl+'?actiontype=delete&rowid='+rowid,
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
							        InciInfoMIGrid.store.removeAll();
							        InciInfoMIGrid.getView().refresh();
							        InciInfoMIStore.load();
							    }else{
								    Msg.info("error","ɾ��ʧ��"+jsondata.info);
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
	text : '��ѯ',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		InciInfoMIStore.load();
	}
});

var INCMIAddBT = new Ext.Toolbar.Button({
	id : 'INCMIAddBT',
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var INCMISaveBT = new Ext.Toolbar.Button({
	id : 'INCMISaveBT',
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		    INCMISave();
		}
	
});

var INCMIDeleteBT = new Ext.Toolbar.Button({
	id : 'INCMIDeleteBT',
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		   INCMIDelete();
		}
	
});
var InciInfoMIGrid = new Ext.grid.EditorGridPanel({
	title:'�����ֵ������ά��',
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
//ҳ�沼��
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
	    layout:'fit',
	    items:[InciInfoMIGrid]
	});
INCMISearchBT.handler();
});
//֧����ʽά��
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
	    },{
	    	name:'DefaultFlage',
	    	type:'string'
	    }
	]);
	var NewRecord=new record({
	    RowId:'',
	    Code:'',
	    Desc:'',
	    DefaultFlage:''
	});
	PayModeGrids.add(NewRecord);
	PayModeGrid.startEditing(PayModeGrids.getCount()-1,1)
}
var PayModeGrid=""
//��������Դ
var PayModeGridUrl='dhcstm.paymodeaction.csp';
var PayModeGridProxy=new Ext.data.HttpProxy({url:PayModeGridUrl+'?actiontype=query',method:'GET'});
var PayModeGrids=new Ext.data.Store({
    proxy:PayModeGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pagesize:35
    },[
     {name:'RowId'},
     {name:'Code'},
     {name:'Desc'},
     {name:'DefaultFlage'}
    ]),
    remoteSort:true,
    pruneModifiedRecords:true
})
var defaultFlag = new Ext.grid.CheckColumn({
	header:'ȱʡ��־',
	dataIndex:'DefaultFlage',
	width:60,
	sortable:true
});
//ģ��
var PayModeGridCm=new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
    	header:'����',
    	dataIndex:'Code',
    	width:180,
    	align:'left',
    	sortable:true,
    	editor:new Ext.form.TextField({
    	  id:'codeField',
    	  allowBlank:false,
    	  listeners:{
    	   specialKey:function(field,e){
    	   	 if(e.getKey()==Ext.EventObject.ENTER){
    	   	   PayModeGrid.startEditing(PayModeGrids.getCount()-1,2);
    	   	 }
    	   }
    	  }
    	})
     	
    },{
        header:'����',
        dataIndex:'Desc',
        width:300,
    	align:'left',
    	sortable:true,
    	editor:new Ext.form.TextField({
    	  id:'descField',
    	  allowBlank:false,
    	  listeners:{
    	   specialKey:function(fiels,e){
    	   	 if(e.getKey()==Ext.EventObject.ENTER){
    	   	   addNewRow();
    	   	 }
    	   }
    	  }
    	})
    },defaultFlag
])
//��ʼ��Ĭ��������
PayModeGridCm.defaultSortable=true

var AddPayMode=new Ext.Toolbar.Button({
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
    width:70,
    height:30,
    handler:function(){
      addNewRow()
    }
})

var SavePayMode=new Ext.Toolbar.Button({
    text:'����',
    tooltip:'����',
    iconCls:'page_save',
    width:70,
    height:30,
    handler:function(){
    	//��ȡ���е��¼�¼ 
    	var mr=PayModeGrids.getModifiedRecords();
    	var data=""
    	for(i=0;i<mr.length;i++){
    		var code=mr[i].data["Code"].trim();
    		var desc=mr[i].data["Desc"].trim();
    		var defaultFlage=mr[i].data["DefaultFlage"].trim();
    		if((code!="")&&(desc!="")){
    		   var dataRow=mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+defaultFlage
    		   if(data==""){
    		   data=dataRow
    		   }else{
    		   	data=data+xRowDelim()+dataRow  
    		   }
    		}
    	}
      if(data==""){
        Msg.info("error","û���޸Ļ����������!")
        return false
      }else{
      	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
      	Ext.Ajax.request({
      		url:PayModeGridUrl+'?actiontype=save',
      		params:{data:data},
      		failure:function(result,request){
      		   mask.hide();
      		   Msg.info("error","������������!")
      		},
      		success:function(result,request){
      			var jsonData=Ext.util.JSON.decode(result.responseText);
						mask.hide();
						if(jsonData.success=='true'){
							Msg.info("success","����ɹ�!");
							PayModeGrids.load()
						}else{
							if(jsonData.info==-10){
								Msg.info("error","�����ظ�!");
								}else if(jsonData.info==-1){
								Msg.info("error","�����ظ�!");
								}else{
							         Msg.info("error","����ʧ��!");
							         }
							PayModeGrids.load()
							}
      		},
      		scope:this
      		
      	});
      }
      
    	
    }
})
var DeletePayMode=new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width:70,
	height:30,
	handler:function(){
		deleteDetail();
		}
	})
//ɾ������	
function deleteDetail(){
	var cell=PayModeGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","��ѡ������!");
		return false;
		}else{
			var record=PayModeGrid.getStore().getAt(cell[0]);
			var RowId=record.get("RowId")
			if (RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:PayModeGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", "������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "ɾ���ɹ�!");
										PayModeGrids.load()
									}else{
										Msg.info("error", "ɾ��ʧ��!");
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
						PayModeGrid.getStore().removeAt(rowInd)
						}
					}
				
				
			}
		}		
//���
PayModeGrid=new Ext.grid.EditorGridPanel({
    id:'PayModeGrid',
    store:PayModeGrids,
    cm:PayModeGridCm,
    trackMouseOver:true,
    plugins:[defaultFlag],
    region:'center',
    height:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMast:true,
    tbar:[AddPayMode,'-',SavePayMode],//,'-',DeletePayMode],
    clicksToEdit:1
});
PayModeGrids.load();
//===========ģ����ҳ��===============================================

Ext.onReady(function(){

Ext.QuickTips.init();
Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
var panel=new Ext.Panel({
    title:'֧����ʽά��',
    activeTab:0,
    region:'center',
    layout:'fit',
    items:[PayModeGrid]
    });
 
var mainPanel=new Ext.ux.Viewport({
    layout:'border',
    items:[panel],
    renderTo:'mainPanel'
});    
	
})

//===========ģ����ҳ��===============================================
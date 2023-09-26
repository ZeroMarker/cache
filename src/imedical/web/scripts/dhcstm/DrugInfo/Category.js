//�������ά��
function addNewRow(){
	var record=Ext.data.Record.create([
	    {
	    	name:'RowId',
	    	type:'int'
	    },{
	    	name:'Desc',
	    	type:'string'
	    }
	]);
	var NewRecord=new record({
	    RowId:'',
	    Desc:''
	});
	SterileCateTypeGrids.add(NewRecord);
	SterileCateTypeGrid.startEditing(SterileCateTypeGrids.getCount()-1,1)
}
var SterileCateTypeGrid=""
//��������Դ
var SterileCateTypeGridUrl='dhcstm.categoryaction.csp';
var SterileCateTypeGridProxy=new Ext.data.HttpProxy({url:SterileCateTypeGridUrl+'?actiontype=query',method:'GET'});
var SterileCateTypeGrids=new Ext.data.Store({
    proxy:SterileCateTypeGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pagesize:35
    },[
     {name:'RowId'},
     {name:'Desc'}
    ]),
    remoteSort:true,
    pruneModifiedRecords:true
})

//ģ��
var SterileCateTypeGridCm=new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
   {
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
    }

])
//��ʼ��Ĭ��������
SterileCateTypeGridCm.defaultSortable=true

var AddSterileCateType=new Ext.Toolbar.Button({
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
    width:70,
    height:30,
    handler:function(){
      addNewRow()
    }
})

var SaveSterileCateType=new Ext.Toolbar.Button({
    text:'����',
    tooltip:'����',
    iconCls:'page_save',
    width:70,
    height:30,
    handler:function(){
    	//��ȡ���е��¼�¼ 
    	var mr=SterileCateTypeGrids.getModifiedRecords();
    	var data=""
    	for(i=0;i<mr.length;i++){
    		var desc=mr[i].data["Desc"].trim();
    		if((desc!="")){
    		   var dataRow=mr[i].data["RowId"]+"^"+desc
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
      	//alert(ItmChargeTypeGridUrl)
      	Ext.Ajax.request({
      		url:SterileCateTypeGridUrl+'?actiontype=save',
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
							SterileCateTypeGrids.load()
						}else{
							if(jsonData.info==-1){
								Msg.info("error","�����ظ�!");
								}else{
							         Msg.info("error","����ʧ��!");
							         }
							SterileCateTypeGrids.load()
							}
      		},
      		scope:this
      		
      	});
      }
      
    	
    }
})
var DeleteSterileCateType=new Ext.Toolbar.Button({
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
	var cell=SterileCateTypeGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","��ѡ������!");
		return false;
		}else{
			var record=SterileCateTypeGrid.getStore().getAt(cell[0]);
			var RowId=record.get("RowId")
			if (RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:SterileCateTypeGridUrl+'?actiontype=delete&rowid='+RowId,
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
										SterileCateTypeGrids.load()
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
						SterileCateTypeGrid.getStore().removeAt(rowInd)
						}
					}
				
				
			}
		}		
//���
SterileCateTypeGrid=new Ext.grid.EditorGridPanel({
    id:'SterileCateTypeGrid',
    store:SterileCateTypeGrids,
    cm:SterileCateTypeGridCm,
    trackMouseOver:true,
    region:'center',
    height:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMast:true,
    tbar:[AddSterileCateType,'-',SaveSterileCateType,'-',DeleteSterileCateType],
    clicksToEdit:1
});
SterileCateTypeGrids.load();
//===========ģ����ҳ��===============================================

Ext.onReady(function(){

Ext.QuickTips.init();
Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
var panel=new Ext.Panel({
    title:'�������ά��',
    activeTab:0,
    region:'center',
    layout:'fit',
    items:[SterileCateTypeGrid]
    });
 
var mainPanel=new Ext.ux.Viewport({
    layout:'border',
    items:[panel],
    renderTo:'mainPanel'
});    
	
})

//===========ģ����ҳ��===============================================
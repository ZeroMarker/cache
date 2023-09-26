//�ʽ���Դά��
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
	SourceOfFundGrids.add(NewRecord);
	SourceOfFundGrid.startEditing(SourceOfFundGrids.getCount()-1,1)
}
var SourceOfFundGrid=""
//��������Դ
var SourceOfFundGridUrl='dhcstm.sourceoffundaction.csp';
var SourceOfFundGridProxy=new Ext.data.HttpProxy({url:SourceOfFundGridUrl+'?actiontype=query',method:'GET'});
var SourceOfFundGrids=new Ext.data.Store({
    proxy:SourceOfFundGridProxy,
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

//ģ��
var SourceOfFundGridCm=new Ext.grid.ColumnModel([
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
    	   	   SourceOfFundGrid.startEditing(SourceOfFundGrids.getCount()-1,2);
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
    }

])
//��ʼ��Ĭ��������
SourceOfFundGridCm.defaultSortable=true

var AddSourceOfFund=new Ext.Toolbar.Button({
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
    width:70,
    height:30,
    handler:function(){
      addNewRow()
    }
})

var SaveSourceOfFund=new Ext.Toolbar.Button({
    text:'����',
    tooltip:'����',
    iconCls:'page_save',
    width:70,
    height:30,
    handler:function(){
    	//��ȡ���е��¼�¼ 
    	var mr=SourceOfFundGrids.getModifiedRecords();
    	var data=""
    	for(i=0;i<mr.length;i++){
    		var code=mr[i].data["Code"].trim();
    		var desc=mr[i].data["Desc"].trim();
    		if((code!="")&&(desc!="")){
    		   var dataRow=mr[i].data["RowId"]+"^"+code+"^"+desc
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
      		url:SourceOfFundGridUrl+'?actiontype=save',
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
							SourceOfFundGrids.load()
						}else{
							if(jsonData.info==-10){
								Msg.info("error","�����ظ�!");
								}else if(jsonData.info==-1){
								Msg.info("error","�����ظ�!");
								}else{
							         Msg.info("error","����ʧ��!");
							         }
							SourceOfFundGrids.load()
							}
      		},
      		scope:this
      		
      	});
      }
      
    	
    }
})
var DeleteSourceOfFund=new Ext.Toolbar.Button({
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
	var cell=SourceOfFundGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","��ѡ������!");
		return false;
		}else{
			var record=SourceOfFundGrid.getStore().getAt(cell[0]);
			var RowId=record.get("RowId")
			if (RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:SourceOfFundGridUrl+'?actiontype=delete&rowid='+RowId,
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
										SourceOfFundGrids.load()
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
						SourceOfFundGrid.getStore().removeAt(rowInd)
						}
					}
				
				
			}
		}		
//���
SourceOfFundGrid=new Ext.grid.EditorGridPanel({
    id:'SourceOfFundGrid',
    store:SourceOfFundGrids,
    cm:SourceOfFundGridCm,
    trackMouseOver:true,
    region:'center',
    height:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMast:true,
    tbar:[AddSourceOfFund,'-',SaveSourceOfFund],//,'-',DeleteSourceOfFund],
    clicksToEdit:1
});
SourceOfFundGrids.load();
//===========ģ����ҳ��===============================================

Ext.onReady(function(){

Ext.QuickTips.init();
Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
var panel=new Ext.Panel({
    title:'�ʽ���Դά��',
    activeTab:0,
    region:'center',
    layout:'fit',
    items:[SourceOfFundGrid]
    });
 
var mainPanel=new Ext.ux.Viewport({
    layout:'border',
    items:[panel],
    renderTo:'mainPanel'
});    
	
})

//===========ģ����ҳ��===============================================
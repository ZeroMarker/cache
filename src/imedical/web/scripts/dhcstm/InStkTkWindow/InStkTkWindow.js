//ʵ�̴���ά��
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
//��������Դ
var InStkTkWindowGridUrl='dhcstm.instktkwindowaction.csp';
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
//ģ��

//ģ��
var InStkTkWindowGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
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
        header:"����",
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
//��ʼ��Ĭ��������
InStkTkWindowGridCm.defaultSortable = true;

var addInStkTkWindow=new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width:70,
	height:30,
	handler:function(){
		addNewRow()
		}
	})
var saveInStkTkWindow=new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width:70,
	height:30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=InStkTkWindowGriDs.getModifiedRecords();
		var data="";
		for (i=0;i<mr.length;i++){
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
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
			Msg.info("error","û���޸Ļ����������!");
			return false;
			}else{
				var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
				Ext.Ajax.request({
					url:InStkTkWindowGridUrl+'?actiontype=save',
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
							InStkTkWindowGriDs.load()
						}else{
							if(jsonData.info==-10){
								Msg.info("error","�����ظ�!");
								}else if(jsonData.info==-1){
								Msg.info("error","�����ظ�!");
								}else{
							         Msg.info("error","����ʧ��!");
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
	var cell=InStkTkWindowGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","��ѡ������!");
		return false;
		}else{
			var record=InStkTkWindowGrid.getStore().getAt(cell[0]);
			var RowId=record.get("RowId")
			if (RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:InStkTkWindowGridUrl+'?actiontype=delete&rowid='+RowId,
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
										InStkTkWindowGriDs.load()
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
						InStkTkWindowGrid.getStore().removeAt(rowInd)
						}
					}
				
				
			}
		}	
//���
InStkTkWindowGrid=new Ext.grid.EditorGridPanel({
	id : 'InStkTkWindowGrid',
	store:InStkTkWindowGriDs,
	cm:InStkTkWindowGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMast:true,
	tbar:[addInStkTkWindow,'-',saveInStkTkWindow],		//,'-',deleteInStkTkWindow
	clicksToEdit:1
	})
InStkTkWindowGriDs.load()
//===========ģ����ҳ��===============================================
Ext.onReady(function(){
Ext.QuickTips.init();
Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var panel=new Ext.Panel({
	title:'ʵ�̴���',
	activeTab:0,
	region:'center',
	layout:'fit',
	items:[InStkTkWindowGrid]
	});
	
var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel],
		renderTo:'mainPanel'
	});
	
})
//===========ģ����ҳ��===============================================
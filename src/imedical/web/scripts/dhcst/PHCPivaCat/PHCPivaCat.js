// /����: 		ҩƷ��Һ����ά��
// /����: 		ҩƷ��Һ����ά��
// /��д�ߣ�	hulihua
// /��д����: 	2016.12.15
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
	PHCPivaCatGriDs.add(NewRecord);
	PHCPivaCatGrid.startEditing(PHCPivaCatGriDs.getCount()-1,1)
	}
var PHCPivaCatGrid=""
//��������Դ
var PHCPivaCatGridUrl='dhcst.phcpivacataction.csp';
var PHCPivaCatGridProxy=new Ext.data.HttpProxy({url:PHCPivaCatGridUrl+'?actiontype=query',method:'GET'});
var PHCPivaCatGriDs=new Ext.data.Store({
	proxy:PHCPivaCatGridProxy,
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
var PHCPivaCatGridCm = new Ext.grid.ColumnModel([
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
						PHCPivaCatGrid.startEditing(PHCPivaCatGriDs.getCount() - 1, 2);
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
PHCPivaCatGridCm.defaultSortable = true;
var addPHCPivaCat=new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width:70,
	height:30,
	handler:function(){
		addNewRow()
		}
	})
var savePHCPivaCat=new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width:70,
	height:30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=PHCPivaCatGriDs.getModifiedRecords();
		var data="";
		for (i=0;i<mr.length;i++){
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var rowNum = PHCPivaCatGriDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", "��"+rowNum+"�д���Ϊ��!");
				return;
			}
			if (desc==""){
				Msg.info("warning", "��"+rowNum+"������Ϊ��!");
				return;
			}
			if((code!="")&&(desc!="")){
				var dataRow=mr[i].data["RowId"]+"^"+code+"^"+desc
				if(data==""){
					data=dataRow}
				else{
					data=data+xRowDelim()+dataRow   
					}	 
				}
			}
			
		if(data==""){
			Msg.info("warning","û���޸Ļ����������!");
			return false;
			}else{
				var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
				Ext.Ajax.request({
					url:PHCPivaCatGridUrl+'?actiontype=save',
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
							PHCPivaCatGriDs.load()
						}else{
							if(jsonData.info==-1){
								Msg.info("warning","�˴����Ѿ�ά��!");
								}else if(jsonData.info==-2){
									Msg.info("warning","�������Ѿ�ά��!");
									}else{
							Msg.info("error","����ʧ��!");
									}
							PHCPivaCatGriDs.load()
							}
							
						},	
					scope:this
					});
				}	
			
			
		}
	})

var deletePHCPivaCat=new Ext.Toolbar.Button({
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
	var cell=PHCPivaCatGrid.getSelectionModel().getSelectedCell();
	if (cell==null){
		Msg.info("error","��ѡ������!");
		return false;
		}else{
			var record=PHCPivaCatGrid.getStore().getAt(cell[0]);
			var RowId=record.get("RowId")
			if (RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
							Ext.Ajax.request({
								url:PHCPivaCatGridUrl+'?actiontype=delete&rowid='+RowId,
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
										PHCPivaCatGriDs.load()
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
						PHCPivaCatGrid.getStore().removeAt(rowInd)
						}
					}
				
				
			}
		}		
//���
PHCPivaCatGrid=new Ext.grid.EditorGridPanel({
	store:PHCPivaCatGriDs,
	cm:PHCPivaCatGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMast:true,
	tbar:[addPHCPivaCat,'-',savePHCPivaCat],//,'-',deletePHCPivaCat],
	clicksToEdit:1
	})
PHCPivaCatGriDs.load()
//===========ģ����ҳ��===============================================
Ext.onReady(function(){
Ext.QuickTips.init();
Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			height : 30,
			labelAlign : 'right',
			title:'ҩƷ��Һ����ά��',
			region: 'center',
			frame : true,
			autoHeight:true,
			//autoScroll : true,
			bodyStyle : 'padding:10px 10px 10px 10px;'
			
		});
// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [  HisListTab,
				        {
			                 region: 'center',						                
					   title: 'ҩƷ��Һ����',
					   layout: 'fit', // specify layout manager for items
					   items: PHCPivaCatGrid  			               
			               }
	       			],
					renderTo : 'mainPanel'
				})
	
})

//===========ģ����ҳ��===============================================
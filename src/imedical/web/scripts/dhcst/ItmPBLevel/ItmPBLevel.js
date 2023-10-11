// ����:�б꼶��ά������
// ��д����:2012-06-4

//=========================�б꼶��ά��=============================
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'DateFrom',
			type : 'string'
		}, {
			name : 'DateTo',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		DateFrom:'',
		DateTo:''
	});
					
	ItmPBLevelGridDs.add(NewRecord);
	ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 1);
}
	
var ItmPBLevelGrid="";
//��������Դ
var ItmPBLevelGridUrl = 'dhcst.itmpblevelaction.csp';
var ItmPBLevelGridProxy= new Ext.data.HttpProxy({url:ItmPBLevelGridUrl+'?actiontype=query',method:'GET'});
var ItmPBLevelGridDs = new Ext.data.Store({
	proxy:ItmPBLevelGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'DateFrom',type:'date',dateFormat:App_StkDateFormat},
		{name:'DateTo',type:'date',dateFormat:App_StkDateFormat}
	]),
    remoteSort:false
});

//ģ��
var ItmPBLevelGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("����"),
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
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:$g("����"),
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
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:$g("��ʼ����"),
        dataIndex:'DateFrom',
        width:180,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
		editor:new Ext.ux.DateField({
			id:'dateFromField',
            allowBlank:false,
			format:App_StkDateFormat,
			anchor:'90%',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ItmPBLevelGrid.startEditing(ItmPBLevelGridDs.getCount() - 1, 4);
					}
				}
			}
        })
    },{
        header:$g("��ֹ����"),
        dataIndex:'DateTo',
        width:180,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
		editor:new Ext.ux.DateField({
			id:'dateToField',
            allowBlank:false,
			format:App_StkDateFormat,
			anchor:'90%',
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
ItmPBLevelGridCm.defaultSortable = true;
var addItmPBLevel = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveItmPBLevel = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(HospId==""){
			Msg.info("warning",$g("����ѡ��ҽԺ!"));
			return false;
		}
		//��ȡ���е��¼�¼ 
		var mr=ItmPBLevelGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowId = mr[i].data["RowId"];
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var dateFrom = mr[i].data["DateFrom"];
			var dateTo = mr[i].data["DateTo"];
			var dateFromB,dateToB;
			if((dateFrom!="")&&(dateFrom!=null)){
				dateFromB=dateFrom.format('Y-m-d');
				dateFrom = dateFrom.format(App_StkDateFormat);
			}
			if((dateTo!="")&&(dateTo!=null)){
				dateToB = dateTo.format('Y-m-d')
				dateTo = dateTo.format(App_StkDateFormat);
			}
			if(code==""){Msg.info("warning",$g("���벻��Ϊ��!"));return;}
			if(desc==""){Msg.info("warning",$g("���Ʋ���Ϊ��!"));return;}
			if ((dateToB!="")&&(dateFromB!="")&&(dateToB<dateFromB)){
				Msg.info("warning", desc+$g(":��ʼ���ڴ��ڽ�ֹ����!"));
				return;
			}
			if((code!="")&&(desc!="")){
				var dataRow = rowId+"^"+code+"^"+desc+"^"+dateFrom+"^"+dateTo;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		
		if(data==""){
			Msg.info("error", $g("û���޸Ļ����������!"));
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
			Ext.Ajax.request({
				url: ItmPBLevelGridUrl+'?actiontype=save',
				params:{data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", $g("������������!"));
					ItmPBLevelGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", $g("����ɹ�!"));
						ItmPBLevelGridDs.load();
					}else{
						ItmPBLevelGridDs.load();
						if(jsonData.info==-1){
							Msg.info("error", $g("�����ظ�!"));
						}else if(jsonData.info==-2){
							Msg.info("error", $g("�����ظ�!"));
						}else{
							Msg.info("error", $g("����ʧ��!"));
						}
					}
					ItmPBLevelGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});


var deleteItmPBLevel = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(HospId==""){
			Msg.info("warning",$g("����ѡ��ҽԺ!"));
			return false;
		}
		var cell = ItmPBLevelGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", $g("��ѡ������!"));
			return false;
		}else{
			var record = ItmPBLevelGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
							Ext.Ajax.request({
								url:ItmPBLevelGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('ɾ����...'),
								failure: function(result, request) {
									 mask.hide();
									Msg.info("error", $g("������������!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", $g("ɾ���ɹ�!"));
										ItmPBLevelGridDs.load();
									}else{
										Msg.info("error", $g("ɾ��ʧ��!"));
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error", $g("�����д�,û��RowId!"));
			}
		}
    }
});

//���
ItmPBLevelGrid = new Ext.grid.EditorGridPanel({
	store:ItmPBLevelGridDs,
	cm:ItmPBLevelGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addItmPBLevel,'-',saveItmPBLevel,'-',deleteItmPBLevel],
	clicksToEdit:1
});

ItmPBLevelGridDs.load();

var HospPanel = InitHospCombo('DHC_ItmPBLevel',function(combo, record, index){
	HospId = this.value; 
	ItmPBLevelGridDs.reload();
});
//=========================�б꼶��ά��=============================

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		id:"panel",
		title:$g('�б꼶��'),
		activeTab:0,
		region:'center',
		layout:'fit',
		items:[ItmPBLevelGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HospPanel,panel],
		renderTo:'mainPanel'
	});

});
//===========ģ����ҳ��=============================================
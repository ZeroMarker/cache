// ����:����ԭ�����
// ��д����:2012-6-7

//=========================����ԭ��=============================	
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
		}
	]);
					
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:''
	});
					
	ReasonForAdjustPriceGridDs.add(NewRecord);
	ReasonForAdjustPriceGrid.startEditing(ReasonForAdjustPriceGridDs.getCount() - 1, 1);
}
	
var ReasonForAdjustPriceGrid="";
//��������Դ
var ReasonForAdjustPriceGridUrl = 'dhcst.reasonforadjustpriceaction.csp';
var ReasonForAdjustPriceGridProxy= new Ext.data.HttpProxy({url:ReasonForAdjustPriceGridUrl+'?actiontype=query',method:'GET'});
var ReasonForAdjustPriceGridDs = new Ext.data.Store({
	proxy:ReasonForAdjustPriceGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'}
	]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var ReasonForAdjustPriceGridCm = new Ext.grid.ColumnModel([
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
						ReasonForAdjustPriceGrid.startEditing(ReasonForAdjustPriceGridDs.getCount() - 1, 2);
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
						addNewRow();
					}
				}
			}
        })
    }
]);

//��ʼ��Ĭ��������
ReasonForAdjustPriceGridCm.defaultSortable = true;

var addReasonForAdjustPrice = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveReasonForAdjustPrice = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=ReasonForAdjustPriceGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			var rowNum = ReasonForAdjustPriceGridDs.indexOf(mr[i])+1;
			if (code==""){
				Msg.info("warning", $g("��")+rowNum+$g("�д���Ϊ��!"));
				return;
			}
			if (desc==""){
				Msg.info("warning", $g("��")+rowNum+$g("������Ϊ��!"));
				return;
			}
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		
		if(data==""){
			Msg.info("warning", $g("û���޸Ļ����������!"));
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
			Ext.Ajax.request({
				url: ReasonForAdjustPriceGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", $g("������������!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", $g("����ɹ�!"));
						ReasonForAdjustPriceGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("warning", $g("�����ظ�!"));
						}else if(jsonData.info==-2){
							Msg.info("warning", $g("�����ظ�!"));
						}else{
							Msg.info("error", $g("����ʧ��!"));
						}
						ReasonForAdjustPriceGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});


var deleteReasonForAdjustPrice = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ReasonForAdjustPriceGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", $g("��ѡ������!"));
			return false;
		}else{
			var record = ReasonForAdjustPriceGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
							Ext.Ajax.request({
								url:ReasonForAdjustPriceGridUrl+'?actiontype=delete&rowid='+RowId,
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
										ReasonForAdjustPriceGridDs.remove(record);
										ReasonForAdjustPriceGrid.getView().refresh();
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
				ReasonForAdjustPriceGridDs.remove(record);
				ReasonForAdjustPriceGrid.getView().refresh();
			}
		}
    }
});

//���
ReasonForAdjustPriceGrid = new Ext.grid.EditorGridPanel({
	store:ReasonForAdjustPriceGridDs,
	cm:ReasonForAdjustPriceGridCm,
	trackMouseOver:true,
	region:'center',
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addReasonForAdjustPrice,'-',saveReasonForAdjustPrice,'-',deleteReasonForAdjustPrice],
	clicksToEdit:1
});

ReasonForAdjustPriceGridDs.load();
//=========================����ԭ��=============================
var HospPanel = InitHospCombo('DHC_ReasonForAdjustPrice',function(combo, record, index){
	HospId = this.value; 
	ReasonForAdjustPriceGridDs.reload();
});
//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:$g('����ԭ��'),
		activeTab:0,
		region:'center',
		items:[ReasonForAdjustPriceGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HospPanel,panel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===============================================
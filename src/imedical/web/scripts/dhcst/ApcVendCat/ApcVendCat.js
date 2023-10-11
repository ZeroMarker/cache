// ����:��Ӧ��������
// ��д����:2012-05-15

//=========================��Ӧ�����=================================
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
					
	ApcVendCatGridDs.add(NewRecord);
	ApcVendCatGrid.startEditing(ApcVendCatGridDs.getCount() - 1, 1);
}
	
var ApcVendCatGrid="";
//��������Դ
var ApcVendCatGridUrl = 'dhcst.apcvendcataction.csp';
var ApcVendCatGridProxy= new Ext.data.HttpProxy({url:ApcVendCatGridUrl+'?actiontype=selectAll',method:'GET'});
var ApcVendCatGridDs = new Ext.data.Store({
	proxy:ApcVendCatGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
});



//ģ��
var ApcVendCatGridCm = new Ext.grid.ColumnModel([
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
						ApcVendCatGrid.startEditing(ApcVendCatGridDs.getCount() - 1, 2);
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
ApcVendCatGridCm.defaultSortable = true;

var addApcVendCat = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveApcVendCat = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//��ȡ���е��¼�¼ 
		var mr=ApcVendCatGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){

			var code = mr[i].data["Code"].trim();
			var desc = mr[i].data["Desc"].trim();
			if((code!="")&&(desc!="")){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
			else if((code=="")&&(desc!="")){
				Msg.info("error", $g("���벻��Ϊ��!"));
			    return false;
			}
			else if((code!="")&&(desc=="")){
				Msg.info("error", $g("���Ʋ���Ϊ��!"));
			    return false;
			}
		}
		
		if(data==""){
			Msg.info("error", $g("û���޸Ļ����������!"));
			return false;
		}
		else{
			var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
			Ext.Ajax.request({
				url: ApcVendCatGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					Msg.info("error", $g("������������!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", $g("����ɹ�!"));
						ApcVendCatGridDs.load();
					}else{
						if(jsonData.info==-1){
							Msg.info("warning", $g("�����ظ�!"));
						}else if(jsonData.info==-2){
							Msg.info("warning", $g("�����ظ�!"));
						}else{
							Msg.info("error", $g("����ʧ��!"));
						}
						ApcVendCatGridDs.load();
					}
				},
				scope: this
			});
		}
    }
});

var deleteApcVendCat = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = ApcVendCatGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", $g("��ѡ������!"));
			return false;
		}else{
			var record = ApcVendCatGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),$g("���������Ժ�..."));
							Ext.Ajax.request({
								url:ApcVendCatGridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:$g('ɾ����...'),
								failure: function(result, request) {
									Msg.info("error", $g("������������!"));
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									 mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", $g("ɾ���ɹ�!"));
										ApcVendCatGridDs.load();
									}else{
										if (jsonData.info=="-1"){
											Msg.info("warning", $g("�÷����Ѿ��ڹ�Ӧ�̶�����ʹ�ã�������ɾ��!"));
										}
										else{
											Msg.info("error", $g("ɾ��ʧ��!"));
										}
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
var HospWinButton = GenHospWinButton("PH_Manufacturer");

//�󶨵���¼�
HospWinButton.on("click" , function(){
	var cell = ApcVendCatGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("warning", $g("��ѡ������!"));
		return;
	}
	var record = ApcVendCatGrid.getStore().getAt(cell[0]);
	var rowID = record.get("RowId");
	if (rowID===''){
		Msg.info("warning",$g("���ȱ�������!"));
		return;	
	}
    GenHospWin("APC_VendCat",rowID,function(){ApcVendCatGridDs.reload();}).show()   
});
var HospPanel = InitHospCombo('APC_VendCat',function(combo, record, index){
	HospId = this.value; 
	ApcVendCatGridDs.reload();
});
//���
ApcVendCatGrid = new Ext.grid.EditorGridPanel({
	store:ApcVendCatGridDs,
	cm:ApcVendCatGridCm,
	trackMouseOver:true,
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addApcVendCat,'-',saveApcVendCat,'-',deleteApcVendCat,'-',HospWinButton],
	clicksToEdit:1
});

ApcVendCatGridDs.load();
//=========================��Ӧ�����=================================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var ApcVendCatPanel = new Ext.Panel({
		title:$g('��Ӧ�̷���ά��'),
		activeTab: 0,
		region:'center',
		items:[ApcVendCatGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items:[HospPanel,ApcVendCatPanel],
		renderTo: 'mainPanel'
	});
});
//===========ģ����ҳ��===============================================
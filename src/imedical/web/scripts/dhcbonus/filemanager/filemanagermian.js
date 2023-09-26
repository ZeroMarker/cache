//����ʽ�淶�ַ�������
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

var userId = session['LOGON.USERID'];

var FileManagerTabUrl = '../csp/dhc.bonus.filemanagerexe.csp';
//�������Դ
var FileManagerTabProxy= new Ext.data.HttpProxy({url:FileManagerTabUrl+'?action=list'});
var FileManagerTabDs = new Ext.data.Store({
	proxy: FileManagerTabProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'userId',
		'userName',
		'fileName',
		'date'
	]),
	remoteSort: true
});

//����Ĭ�������ֶκ�������
FileManagerTabDs.setDefaultSort('rowid', 'name');

//���ݿ�����ģ��
var FileManagerTabCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '�ϴ��û�',
		dataIndex: 'userName',
		width: 150,		  
		sortable: true,
		align: 'center'
	},{
		header: ' �ļ�����',
		dataIndex: 'fileName',
		width: 250,
		sortable: true,
		align: 'center'
	},{
		header: '�ϴ�ʱ��',
		dataIndex: 'date',
		width: 250,
		sortable: true,
		align: 'center'
	}
]);

//��ʼ��Ĭ��������
FileManagerTabCm.defaultSortable = true;

//��ҳ������
var FileManagerTabPagingToolbar = new Ext.PagingToolbar({
	store: FileManagerTabDs,
	pageSize:25,
	displayInfo: true,
	displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg: "û�м�¼"
});

var excelUpload = new Ext.form.TextField({   
	id:'excelUpload', 
	anchor:'90%',   
	height:20,
	width:350,	
	inputType:'file',
	fieldLabel:'�ļ�ѡ��'
});
		
var formPanel = new Ext.form.FormPanel({
	labelWidth:80,
	bodyStyle:'padding:5 5 5 5',
	height:515,
	width:515,
	frame:true,
	fileUpload:true,
	items:[excelUpload]
});

var upLoadButton = new Ext.Toolbar.Button({
	text: '�ļ��ϴ�',     
    iconCls:'add',
	handler:function(){
		// ���尴ť
		var upLoadFile = new Ext.Toolbar.Button({
			text:'�ϴ�'
		});

		// �������ݹ���
		var up = function(bt) {
			if (bt == "yes") {
				function callback(id) {
					if (id == "yes") {
						var excelName = Ext.getCmp('excelUpload').getRawValue();// �ϴ��ļ����Ƶ�·��
						if (excelName == ""){
							Ext.Msg.show({title:'��ʾ',msg:'��ѡ���ļ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
							return;
						}else {
							var array = new Array();
							array = excelName.split("\\");
							var length = array.length;
							var fileName = "";
							var i = 0;
							for (i = 0; i < length; i++) {
								if (fileName == "") {
									fileName = array[i];
								} else {
									fileName = fileName + "/" + array[i];
								}
							}
							
							Ext.Ajax.request({
								url: '../csp/dhc.bonus.filemanagerexe.csp?action=add&userId='+userId+'&fileName='+array[length-1],
								waitMsg:'������...',
								failure: function(result, request){
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success == 'true'){
										var uploadUrl = "http://127.0.0.1:8080/dhchxbonus/upLoadFiles";
										formPanel.getForm().submit({
											url:uploadUrl,
											method:'POST',
											waitMsg:'���ݵ�����, ���Ե�...',
											success:function(form, action, o) {
												Ext.MessageBox.alert("��ʾ��Ϣ",action.result.mess);
												window.close();
												FileManagerTabDs.load({params:{start:0, limit:FileManagerTabPagingToolbar.pageSize}});
											},
											failure : function(form, action) {
												Ext.MessageBox.alert("��ʾ��Ϣ", action.result.mess);
												window.close();
												Ext.Ajax.request({
													url: '../csp/dhc.bonus.filemanagerexe.csp?action=del&fileName='+array[length-1],
													waitMsg:'������...',
													failure: function(result, request){
													},
													success: function(result, request){
													},
													scope: this
												})
											}
										});
									}else{
										var message="";
										if(jsonData.info == 'RepRec'){
											message = '�ϴ��ļ��Ѵ���!';
										}
										if(jsonData.info == '0'){
											message = '�ϴ�ʧ��,�������ϴ�!';
										}
										Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									}
								},
								scope: this
							})
						}
					} else {
						return;
					}
				}
				Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�ϴ����ļ���?', callback);
			}
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�ϴ����ļ���?', callback);
		}
			
		// ��Ӱ�ť����Ӧ�¼�
		upLoadFile.addListener('click', up, false);
			
		var window = new Ext.Window({
			title:'�ϴ��ļ�',
			width:500,
			height:200,
			minWidth:500,
			minHeight:200,
			layout:'fit',
			plain:true,
			modal:true,
			closeAction:'hide',
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items:formPanel,
			buttons:[upLoadFile]
		});
		window.show();
	}
});

var downButton = new Ext.Toolbar.Button({
	text: '�ļ�����',     
    iconCls:'add',
	handler:function(){
	
		//���岢��ʼ���ж���
		var rowObj=FileManagerTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�Ķ�������
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ�����ص��ļ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var fileName = rowObj[0].get("fileName");
			var checkFileExist="Y";
			var is="Y";
			window.location.href = 'http://127.0.0.1:8080/dhchxbonus/downFiles?fileName='+encodeURI(encodeURI(fileName))+'&checkFileExist='+checkFileExist+'&is='+is;
		}
	}
});

//���
var FileManagerTab = new Ext.grid.EditorGridPanel({
	title: '�ļ�����',
	store: FileManagerTabDs,
	cm: FileManagerTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	tbar:[upLoadButton,'-',downButton],
	loadMask: true,
	bbar:FileManagerTabPagingToolbar
});

FileManagerTabDs.load({params:{start:0, limit:FileManagerTabPagingToolbar.pageSize}});
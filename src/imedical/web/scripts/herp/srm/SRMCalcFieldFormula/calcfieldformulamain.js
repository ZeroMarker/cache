var CalcFieldFormulaURL='herp.srm.calcfieldformulaexe.csp';
var FieldCoefficientUrl='herp.srm.fieldcoefficientexe.csp';
var formu="";
var addButton = new Ext.Toolbar.Button({
					text : '����',
					iconCls: 'edit_add',
					handler : function() {
						AddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					//tooltip : '�޸�',
					iconCls : 'pencil',
					handler : function() {
						EditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			//tooltip : 'ɾ��',
			iconCls : 'edit_remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ѡ����Ҫɾ��������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					tmpRowid = rowObj[0].get("rowid");
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : CalcFieldFormulaURL + '?action=del&rowid=' + tmpRowid,
								waitMsg : 'ɾ����...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '����',
												msg : '������������!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : 'ע��',
													msg : '�����ɹ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										itemGrid.load({
													params : {
														start : 0,
														limit : 25
													}
												});
									} else {
										Ext.Msg.show({
													title : '����',
													msg : '����',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					})
				}
			}
});
//���ư�ť
var CopyButton = new Ext.Toolbar.Button({
	text: '����',
    tooltip:'�����������ݵ������',       
    id:'CopyButton', 
    iconCls:'copy',
	handler:function(){
		function handler(id){
			if(id=="yes"){
					Ext.Ajax.request({
						url:CalcFieldFormulaURL+'?action=copy',
						waitMsg:'������...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'���Ƴɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25}});
							}else{
							    var err=jsonData.info;
								Ext.Msg.show({title:'����',msg:err,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{return;}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ�����������ݵ��������?',handler);
	}
});
var itemGrid = new dhc.herp.Grid({
        title: '���м�Ч��ʽ�б�',
		iconCls: 'list',
        width: 400,
		edit:false,
        readerModel:'remote',
        region: 'center',
        url: CalcFieldFormulaURL,	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'Year',
            header: '���',
			allowBlank: false,
			width:80,
			edit:false,
            dataIndex: 'Year'
        },{
            id:'SysNO',
            header: 'ϵͳģ��',
			allowBlank: false,
			width:150,
			edit:false,
            dataIndex: 'SysNO'
        },{
            id:'Formula',
            header: '���㹫ʽ',
			allowBlank: false,
			edit:false,
			width:400,
			edit:false,
            dataIndex: 'Formula'
        },{
            id:'CodeFormula',
            header: '��ʽ����',
			allowBlank: false,
			edit:false,
			hidden:true,
			width:400,
			edit:false,
            dataIndex: 'CodeFormula'
        }],
		tbar:[addButton,'-',editButton,'-',delButton,'-',CopyButton] 
});

   itemGrid.btnResetHide();  //�������ð�ť
   itemGrid.btnPrintHide();  //���ش�ӡ��ť
   itemGrid.btnAddHide();  //�������Ӱ�ť
   itemGrid.btnDeleteHide();  //����ɾ����ť
   itemGrid.btnSaveHide();  //�����޸İ�ť
    
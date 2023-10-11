
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'remove',
    handler:function() {
    // get the selected items
    //���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		if (Ext.isEmpty(rowid)) {
			itemGrid.store.remove(rowObj);
			return;
		}
		function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:'../csp/herp.acct.acctcurexe.csp?action=del&rowid='+rowid,
					waitMsg:'�����...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load();
						}else{
							Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��Ŀ���¼��?',handler);
	}
	});


//�Ƿ�λ��

var monthField = new Ext.form.ComboBox({
	id: 'monthField',
	fieldLabel: '����ڼ�',
	width:200,
	listWidth : 60,
	allowBlank: false,
	store: [['0', '��'], ['1', '��']],
	triggerAction: 'all',
	emptyText:'��ѡ�����ڼ�..',
	name: 'monthField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


 var itemGrid = new dhc.herp.Grid({
        title: '����ά��',
        width: 400,
		iconCls:'maintain',
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctcurexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
 fields: [
       {
            id:'acctCurID',
            header: '<div style="text-align:center">����ID</div>',
            editable:true,
	    	allowBlank: true,
	    	width:130,
            dataIndex: 'rowid',
			align:'center',
            hidden: true,
            print:false
        },{
            id:'currCode',
            header: '<div style="text-align:center">���ֱ���</div>',
	  		calunit:true,
			//align:'center',
	  		allowBlank: false,
			width:100,
            dataIndex: 'currCode'	  
        },{
            id:'currName',
            header: '<div style="text-align:center">��������</div>',
			editable:true,
			allowBlank: false,
			width:150,
            //align:'center',
            dataIndex: 'currName'
       
        },{
            id:'isSelf',
            header: '<div style="text-align:center">�Ƿ�λ��</div>',
			editable:true,
			allowBlank: true,
			width:90,
            dataIndex: 'isSelf',
            align:'center',
            type:monthField
        }]
     
});
                                                                                                                              
	itemGrid.addButton(delButton);
	itemGrid.hiddenButton(2);
	itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);






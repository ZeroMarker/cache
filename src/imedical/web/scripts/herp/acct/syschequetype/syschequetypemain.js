
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'remove',
    handler:function() {
    // get the selected items
    //���岢��ʼ���ж���
		var rowObj=GridMain.getSelectionModel().getSelections();
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
			GridMain.store.remove(rowObj);
			return;
		}
		function handler(id){
			if(id=="yes"){
				Ext.Ajax.request({
					url:'../csp/herp.acct.syschequetypeexe.csp?action=del&rowid='+rowid,
					waitMsg:'�����...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							GridMain.load();
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

var GridMain = new dhc.herp.Grid({
        title: '���㷽ʽά��',
        width: 400,
		iconCls:'maintain',
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.syschequetypeexe.csp',	  
		//tbar:delButton,
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'Ʊ�����ͱ���ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: 'Ʊ�����ͱ���',
			allowBlank: false,
			width:150,
			update:true,
            dataIndex: 'code'
        },{
            id:'name',
            header: 'Ʊ����������',
			allowBlank: false,
			width:200,
			update:true,
            dataIndex: 'name'
        }/*,{
            id:'note',
            header: 'Ʊ����������',
			allowBlank: true,
			width:200,
			update:true,
            dataIndex: 'note'
        }*/] 
});
	//var peg = new PrintExtgrid(this);
	GridMain.addButton(delButton);
	GridMain.hiddenButton(2);
    GridMain.hiddenButton(3);
    GridMain.hiddenButton(4);
	//subjNameMain.hiddenButton(4);
	

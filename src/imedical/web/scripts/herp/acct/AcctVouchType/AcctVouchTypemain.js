
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
					url:'../csp/herp.acct.vouchtypeexe.csp?action=del&rowid='+rowid,
					// waitMsg:'�����...',
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


var itemGrid = new dhc.herp.Grid({
        title: 'ƾ֤����ά��',
        width: 400,
        //edit:false,   //�Ƿ�ɱ༭
		iconCls:'maintain',
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.vouchtypeexe.csp',	  
	    tbar:delButton,
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
        	  id:'code',
            header: '<div style="text-align:center">ƾ֤���ͱ���</div>',
			      allowBlank: false,
			      width:150,
            dataIndex: 'code'
        },{
            id:'name',
            header: '<div style="text-align:center">ƾ֤��������</div>',
			      allowBlank: false,
			      width:200,
            dataIndex: 'name'
        }] 
});
	
	itemGrid.addButton(delButton);
	itemGrid.hiddenButton(2);
	itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
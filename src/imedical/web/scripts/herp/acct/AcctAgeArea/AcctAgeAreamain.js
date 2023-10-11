var userid=session['LOGON.USERID'];
var bookID=IsExistAcctBook();

//���水ť
var saveButton = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'�������',
	iconCls: 'save',
	handler:function(){
		var rowObj=AcctAgeareamain.getSelectionModel().getSelections();
		var beginDays=rowObj[0].get("beginDays");
		var endDays=rowObj[0].get("endDays");
		if((/^[0-9]+$/.test(beginDays))&&(/^[0-9]+$/.test(endDays))){//�������������Ǽ��
			//���ñ��溯��
			AcctAgeareamain.save();
		}else if(beginDays=="" || endDays==""){
			Ext.Msg.show({
					title: '����',
					msg: '����ʼ�������͡���ֹ����������Ϊ�� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
		}else{					
			//alert('����д����ʼ�������͡���ֹ������Ϊ���֣�');
			Ext.Msg.show({title: 'ע��',msg: '����д����ʼ�������͡���ֹ������Ϊ���֣�',
				buttons: Ext.Msg.OK,icon: Ext.MessageBox.INFO
			});
		}		
	}
});

var AcctAgeareamain= new dhc.herp.Grid({
	   title: '�����������������',
	   iconCls:'maintain',
       // width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctageareaexe.csp',	  
		//atLoad : true, // �Ƿ��Զ�ˢ��
		tbar:saveButton,
		loadmask:true,
        fields: [{
			id:'rowid',
			header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: '<div style="text-align:center">������</div>',
			allowBlank: false,
			width:200,
			align: 'center',
            dataIndex: 'code'
        },{
            id:'describe',
            header: '<div style="text-align:center">��������</div>',
			allowBlank: false,
			align: 'center',
			width:200,
            dataIndex: 'describe'
        },{
            id:'beginDays',
            header: '<div style="text-align:center">��ʼ����</div>',
			allowBlank: false,
			align: 'center',
			width:200,
            dataIndex: 'beginDays'
        },{								
            id:'endDays',
            header: '<div style="text-align:center">��ֹ����</div>',
            allowBlank: false,
			width:200,
			align: 'center',
            dataIndex: 'endDays'
        }] 
});

AcctAgeareamain.load({
		    params:{
		    start:0,
		    limit:25,		    
			bookID:bookID
		   }
		  });

AcctAgeareamain.on('afteredit', afterEdit, this );

    function afterEdit(e) {
	
        // execute an XHR to send/commit data to the server, in callback do (if successful):
//    	grid - This grid
//    	record - The record being edited
//    	field - The field name being edited
//    	value - The value being set
//    	originalValue - The original value for the field, before the edit.
//    	row - The grid row index
//    	column - The grid column index
        var utotal = AcctAgeareamain.getStore().getCount();
		if (utotal>1){
			var total=utotal-2;
			var endDays=AcctAgeareamain.getStore().getAt(total).get('endDays');
			if(e.field=="describe"){
				// alert(parseInt(endDays));
				if((e.value!="")&&(endDays!="")){
					e.record.set("beginDays",parseInt(endDays)+1);
				}
			}
			
		}    
    };

	AcctAgeareamain.btnSaveHide()    //���ر��水ť
    AcctAgeareamain.btnResetHide() ;    //�������ð�ť
    AcctAgeareamain.btnPrintHide()  ;   //���ش�ӡ��ť

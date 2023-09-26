//var username = session['LOGON.USERCODE'];

var projUrl = 'dhc.bonus.module.bonusworkitemexe.csp';
/////////////////// ��Ŀ���������б� //////////////////

var WorkItemTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'itemtype'])
		});

WorkItemTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						//url : projUrl+'?action=List&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue())+'&userdr='+userdr,method:'POST'
						url : projUrl+'?action=WorkItemTypeList',method:'POST'
					});
		});

var itemtypeCombo = new Ext.form.ComboBox({
			fieldLabel : '��Ŀ����',
			store : WorkItemTypeDs,
			displayField : 'itemtype',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 190,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
		
var itemtypeCombo1 = new Ext.form.ComboBox({
			fieldLabel : '��Ŀ����',
			store : WorkItemTypeDs,
			displayField : 'itemtype',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});		
			

// ///////////////////��Ŀ����
var titleText = new Ext.form.TextField({
	width : 120,
	listWidth : 240,
	pageSize : 10,
	minChars : 1,
	selectOnFocus : true
});
/////////////////// ��ѯ��ť //////////////////
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
	    var ItemTypeID  = itemtypeCombo.getValue();
	    var ItemName = titleText.getValue();
		itemGrid.load({params:{start:0,limit:25,ItemTypeID:ItemTypeID,ItemName:ItemName}});
		
	}
});

 var CheckButton = new Ext.Toolbar.Button({
   	      text : '���',
					iconCls : 'remove',
					handler : function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			   }
			else
			   {
				   var row = rowObj[0].get("rowid");
				   	Ext.Ajax.request({
							url: projUrl+'?action=CheckList&rowid='+row+'&username='+session['LOGON.USERNAME'],
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									window.close();
								}
								else
								{
								  Ext.Msg.show({title:'���ʧ��',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
			   }
			   //ˢ��ҳ��
			   itemGrid.load({params:{start:0,limit:25}});
			}
  });

//var itemGrid={};

//var emGrid = new dhc.herp.Grid();

var itemGrid = new dhc.herp.Grid({
        title: '����������������',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusworkitemexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
           id: 'ID',
            dataIndex: 'rowid',
			edit:true,
            hidden: true
        },{
            id:'itemtype',
            header: '��Ŀ����',
			allowBlank: true,
			width:100,
			type:itemtypeCombo1,
            dataIndex: 'itemtype'
        },{
            id:'code',
            header: '��Ŀ����',
			allowBlank: true,
			width:100,
            dataIndex: 'code'
        },{
            id:'name',
            header: '��������Ŀ',
			allowBlank: true,
			width:150,
			//encodeURIComponent(name)
            dataIndex: 'name'
        },{
            id:'price',
            header: '��λ�������', 
            allowBlank:true,
            width:100,
            dataIndex: 'price'
        },{
            id:'state',
            header: '����״̬',
			allowBlank: true,
			editable:false,
			width:100,
            dataIndex: 'state'
        },{
            id:'auditperson',
            header: '�����',
			allowBlank: true,
		    editable:false,
			width:100,
            dataIndex: 'auditperson'
        },{
            id:'auditdate',
            type:'datefield',
            header: '���ʱ��',
			allowBlank: true,
		    editable:false,
			width:100,
            dataIndex: 'auditdate'
        }],
        
       tbar:['��Ŀ���ࣺ',itemtypeCombo,'-','��Ŀ���ƣ�',titleText,'-',findButton,'-',CheckButton]
        
});
var datefield =	new Ext.form.DateField({
						id:'datefield',
                        fieldLabel: '���ʱ��',
                        name: 'datefield',
                        width:190,
                        allowBlank:true,
                        format:'Y-m-d',
						selectOnFocus:'true'
                    })


   
   var UpdateButton = new Ext.Toolbar.Button({
   	      text : '�޸�',
		  iconCls : 'option',
		  handler : function() {
			var rowObj=itemGrid.getSelectionModel().getSelections();
		  var len = rowObj.length;
		  if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		  }if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			var participantsids = rowObj[i].get("ParticipantsID");	
			
			if(state == "δ�ύ" ){ 
				EditPaperfun(participantsids);}
			else {Ext.Msg.show({title:'����',msg:'�������ύ�������޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
			//ˢ��ҳ��
			//itemGrid.load({params:{start:0,limit:25}});			 
	
  });
   var DeleteButton = new Ext.Toolbar.Button({
   	      text : 'ɾ��',
					iconCls : 'remove',
					handler : function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			//alert(state);
			if(state == "δ�ύ" ){ 
				delFun();}
			else {Ext.Msg.show({title:'����',msg:'�������ύ������ɾ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });
  
/*  ///////////////////����
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '�ȴ�����'], ['1', 'ͨ��'], ['2', '��ͨ��']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '�������',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
*/
 
  itemGrid.btnResetHide(); 	//�������ð�ť
/*itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť
  itemGrid.load({params:{start:0, limit:12, userdr:username}});
*/
   
   
    


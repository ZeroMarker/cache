//var username = session['LOGON.USERCODE'];

var projUrl = 'dhc.bonus.module.workitemtargetexe.csp';
/////////////////// ����ָ�������б� //////////////////

var BonusTargetDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'bonustarget'])
		});
BonusTargetDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						//url : projUrl+'?action=List&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue())+'&userdr='+userdr,method:'POST'
						url : projUrl+'?action=BonusTargetList',method:'POST'
					});
		});
		
var WorkItemDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'workitem'])
		});

WorkItemDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=WorkItemList',method:'POST'
					});
		});

var BonusTargetCombo = new Ext.form.ComboBox({
			fieldLabel : '����ָ��',
			store : BonusTargetDs,
			displayField : 'bonustarget',
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
		
var BonusTargetCombo1 = new Ext.form.ComboBox({
			fieldLabel : '����ָ��',
			store : BonusTargetDs,
			displayField : 'bonustarget',
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

var WorkItemCombo = new Ext.form.ComboBox({
			fieldLabel : '��������Ŀ',
			store : WorkItemDs,
			displayField : 'workitem',
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

// ///////////////////��������Ŀ
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
	    var BonusTar  = BonusTargetCombo.getValue();
	    var ItemName = titleText.getValue();
		itemGrid.load({params:{start:0,limit:25,BonusTar:BonusTar,ItemName:ItemName}});
		
	}
});
  function pctChange(val) {
        if (val > 0) {
            return '<span >' + val*100 + '%</span>';
        } else if (val < 0) {
            return '<span >' + val*100 + '%</span>';
        }
        return val;
    }

var itemGrid = new dhc.herp.Grid({
        title: '��������Ŀ��Ӧ����ָ��ӳ������',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.workitemtargetexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'bonustarget',
            header: '����ָ��',
			allowBlank: true,
			width:120,
			type:BonusTargetCombo1,
            dataIndex: 'bonustarget'
        },{
            id:'workitem',
            header: '������ָ��',
			allowBlank: true,
			width:120,
			type:WorkItemCombo,
            dataIndex: 'workitem'
        },{
            id:'ItemRate',
            header: '�������',
			allowBlank: true,
			width:80,
		    renderer : pctChange, 
            dataIndex: 'ItemRate'
        },{
            id:'auditdate',
            header: '�޸�����',
			allowBlank: true,
			editable:false,
		    //editable:false,
			width:130,
            dataIndex: 'auditdate'
        }],
        
       tbar:['����ָ��',BonusTargetCombo,'-','��������Ŀ',titleText,'-',findButton]
        
});
/*
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
			//alert(state);
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
  */
 
  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnPrintHide() ;	//���ش�ӡ��ť
/*itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//�������ð�ť
  itemGrid.btnSaveHide(); 	//�������ð�ť
  itemGrid.load({params:{start:0, limit:12, userdr:username}});
*/
   
   
    


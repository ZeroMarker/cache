var projUrl="herp.acct.AcctFinalTransferexe.csp"
//////////////////////��������Ŀ/////////////////////////
var AcctSubjDs = new Ext.data.Store({
    proxy : "",
    reader : new Ext.data.JsonReader({
        totalProperty : "results",
        root : 'rows'
    },['subjCode','SubjNameAll'])
});
AcctSubjDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({
        url : projUrl+'?action=GetAcctSubj&bookID='+bookID,method:'POST'
    });
});
var AcctSubjCombo = new Ext.form.ComboBox({
    id:'AcctSubjCombo',
    fieldLabel : '��Ŀ',
    store : AcctSubjDs,
    valueField : 'subjCode',
    displayField : 'SubjNameAll',
    //typeAhead : true,
    triggerAction : 'all',
    emptyText : '��ѡ���Ŀ',
    width : 200,
    listWidth : 450,
    pageSize : 10,
    minChars : 1,
    selectOnFocus:true,
    forceSelection:'true'
});
////////////////////////�������///////////////////////////
var modeStore = new Ext.data.SimpleStore({
    fields : ['rowid', 'method'],
    data : [['1', '����Ŀ����'], ['2', '����������ж�']]
});
var modeCombo = new Ext.form.ComboBox({
    id:'modeCombo',
    fieldLabel : '��ʾ��ʽ',
    width : 200,
    listWidth : 200,
    selectOnFocus : true,
    allowBlank : true,
    store : modeStore,
    anchor : '90%',
    value : 1, //Ĭ��ֵ
    valueNotFoundText : '',
    displayField : 'method',
    valueField : 'rowid',
    triggerAction : 'all',
    emptyText : '',
    mode : 'local', // ����ģʽ
    editable : false           
}); 

/////////////////////////////ƾ֤ժҪ/////////////////////
var summaryField = new Ext.form.TextField({
    id: 'summary',
    width:200,
    //triggerAction: 'all',
    fieldLabel: 'ƾ֤ժҪ', 
    style:'text-align:left', 		
    name: 'summary' ,
	selectOnFocus : true
});


//******��ʱƾ֤����ƾ֤��ť**********/
function scpzcr(AcctSubj,mode,summary){
	Ext.Msg.confirm('��ʾ', '��ȷ��Ҫ����' + year + '��' + month + '�µĻ������ƾ֤�� ', callback);
	function callback(id) {
		if (id == 'yes') {
			Ext.Ajax.request({
				url : projUrl + '?action=add&UserID='+UserId+'&YearMonth='+YearMonth,
				method:'GET',
				success:function(result,request){
					var respText=Ext.util.JSON.decode(result.responseText);
					str=respText.info;
					if(str==""){
						Ext.Msg.show({
							title:'��ʾ',
							msg:'����ƾ֤�ɹ��� ',
							icon:Ext.Msg.INFO,
							buttons:Ext.MessageBox.OK
						});
						VouchButton.disable();
						transferGrid.getColumnModel().setHidden(2, false);
						transferGrid.load({
							params: {
								Summary: summary,
								AcctSubj: AcctSubj,
								mode: mode,
								bookID: bookID
							}
						});
						return;
					}else{
						Ext.Msg.show({
							title:'����',
							msg:'����ƾ֤ʱ���� ',
							icon:Ext.Msg.ERROR,
							buttons:Ext.MessageBox.OK
						});
						return;
					}
				},
				failure:function(result,request){
					return;
				}
			});
		}
	}
}

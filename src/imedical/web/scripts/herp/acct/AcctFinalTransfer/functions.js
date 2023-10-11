var projUrl="herp.acct.AcctFinalTransferexe.csp"
//////////////////////汇兑损益科目/////////////////////////
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
    fieldLabel : '科目',
    store : AcctSubjDs,
    valueField : 'subjCode',
    displayField : 'SubjNameAll',
    //typeAhead : true,
    triggerAction : 'all',
    emptyText : '请选择科目',
    width : 200,
    listWidth : 450,
    pageSize : 10,
    minChars : 1,
    selectOnFocus:true,
    forceSelection:'true'
});
////////////////////////借贷方向///////////////////////////
var modeStore = new Ext.data.SimpleStore({
    fields : ['rowid', 'method'],
    data : [['1', '按科目余额方向'], ['2', '按结果正负判断']]
});
var modeCombo = new Ext.form.ComboBox({
    id:'modeCombo',
    fieldLabel : '显示方式',
    width : 200,
    listWidth : 200,
    selectOnFocus : true,
    allowBlank : true,
    store : modeStore,
    anchor : '90%',
    value : 1, //默认值
    valueNotFoundText : '',
    displayField : 'method',
    valueField : 'rowid',
    triggerAction : 'all',
    emptyText : '',
    mode : 'local', // 本地模式
    editable : false           
}); 

/////////////////////////////凭证摘要/////////////////////
var summaryField = new Ext.form.TextField({
    id: 'summary',
    width:200,
    //triggerAction: 'all',
    fieldLabel: '凭证摘要', 
    style:'text-align:left', 		
    name: 'summary' ,
	selectOnFocus : true
});


//******临时凭证插入凭证表按钮**********/
function scpzcr(AcctSubj,mode,summary){
	Ext.Msg.confirm('提示', '您确定要生成' + year + '年' + month + '月的汇兑损益凭证吗？ ', callback);
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
							title:'提示',
							msg:'生成凭证成功！ ',
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
							title:'错误',
							msg:'生成凭证时出错！ ',
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

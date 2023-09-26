var userid=session['LOGON.USERNAME'];

		
var tariffTypeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

tariffTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusexpitemmapexe.csp'
								+ '?action=getBonusTarget&str='
								+ encodeURIComponent(Ext.getCmp('tariffTypeCombo').getRawValue()),
						method : 'POST'
					})
		});

var tariffTypeCombo = new Ext.form.ComboBox({
			id : 'tariffTypeCombo',
			fieldLabel : '����ָ��',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : tariffTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'tariffTypeCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
//���ڲ�ѯ
//	����
var stariffTypeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

stariffTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusexpitemmapexe.csp'
								+ '?action=getBonusTarget&str='
								+ encodeURIComponent(Ext.getCmp('sTariffTypeCombo').getRawValue()),
						method : 'POST'
					})
		});

var sTariffTypeCombo = new Ext.form.ComboBox({
			id : 'sTariffTypeCombo',
			fieldLabel : '����ָ��',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : stariffTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'sTariffTypeCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});




var DHCTarEMCCateDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

DHCTarEMCCateDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusexpitemmapexe.csp'
								+ '?action=getBonusExpendItem&str='
								+ encodeURIComponent(Ext.getCmp('DHCTarEMCCateCombo').getRawValue()),
						method : 'POST'
					})
		});

var DHCTarEMCCateCombo = new Ext.form.ComboBox({
			id : 'DHCTarEMCCateCombo',
			fieldLabel : 'SH������Ŀ',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : DHCTarEMCCateDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'DHCTarEMCCateCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
//���ڲ�ѯ
//	����
var sDHCTarEMCCateDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

sDHCTarEMCCateDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusexpitemmapexe.csp'
								+ '?action=getBonusExpendItem&str='
								+ encodeURIComponent(Ext.getCmp('sDHCTarEMCCateCombo').getRawValue()),
						method : 'POST'
					})
		});

var sDHCTarEMCCateCombo = new Ext.form.ComboBox({
			id : 'sDHCTarEMCCateCombo',
			fieldLabel : 'SH������Ŀ',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : sDHCTarEMCCateDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'sDHCTarEMCCateCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
			




var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls:'option',
			handler : function() {

				if (tariffTypeCombo!=undefined){
				 BonusTarget= sTariffTypeCombo.getValue();

				}
					
				if (DHCTarEMCCateCombo!=undefined){	
				DHCTarEMCCate = sDHCTarEMCCateCombo.getValue();
				}

				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								BonusTargetName :  BonusTarget,
								ItemName : DHCTarEMCCate
							}
						});

			}
			
		})
    function pctChange(val) {
        if (val > 0) {
            return '<span >' + val*100 + '%</span>';
        } else if (val < 0) {
            return '<span >' + val*100 + '%</span>';
        }
        return val;
    }
var itemGrid = new dhc.herp.Grid({
        title: '֧������ָ�����ά��',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusexpitemmapexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
		   	 id:'rowid',
		     header: 'rowid',
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'rowid'
		},{
		     id:'BonusTargetName',
		     header: '����ָ��',
		     //allowBlank: false,
		     width:120,
		     editable:true,
		     dataIndex: 'BonusTargetName',
		     type:tariffTypeCombo
		    
		} ,{
		     id:'ItemName',
		     header: '֧����Ŀ',
		     allowBlank: false,
		     width:200,
		     editable:true,
		     dataIndex: 'ItemName',
		     type:DHCTarEMCCateCombo
		} , {
		     id:'ItemRate',
		     header: '�������',
		     //allowBlank: false,
		     width:90,
		     align:'right',
		     renderer : pctChange, 
		     editable:true,
		     dataIndex: 'ItemRate'
		}, {
		     id:'UpdateDate',
		     header: '����ʱ��',
		     align:'right',
		     //allowBlank: false,
		     renderer : pctChange, 
		     width:110,
		     editable:false,
		     dataIndex: 'UpdateDate'
		}],
        
        tbar:['����ָ��:',sTariffTypeCombo,'�շ���Ŀ:',sDHCTarEMCCateCombo,findButton]
        
});
 //�����޸İ�ť��Ӧ����
auditHandler = function(){
		
       
};
itemGrid.load({
							params : {
								start : 0,
								limit : 25
							}
						});
  itemGrid.btnResetHide() ;	//�������ð�ť
    itemGrid.btnPrintHide() ;	//���ش�ӡ��ť
//itemGrid.tbar.push(auditbutton);
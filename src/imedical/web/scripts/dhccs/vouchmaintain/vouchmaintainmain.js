//var accountingPeriodST = new Ext.data.SimpleStore({
//		fields : ['rowid','name'],
//		data : [['1','01'],
//				['2','02'],
//				['3','03'],
//				['4','04']]
//	});
	
var accountingPeriodST = new Ext.data.Store({
    autoLoad: true,
    proxy:"",
    reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['render','rowid'])
});

accountingPeriodST.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=ACCTYearPeriodList&searchField=name&searchValue=' + Ext.getCmp('accountingPeriodCB').getRawValue(), method:'GET'});
        }
    );	
	
var accountingPeriodCB = new Ext.form.ComboBox({
		id:'accountingPeriodCB',
		store: accountingPeriodST,
		valueField:'rowid',
		displayField:'render',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ�����ڼ�...',
		allowBlank: false,
		name:'accountingPeriodCB',
		selectOnFocus: true,
		//mode:'local',
		forceSelection: true
	});
	
	
accountingPeriodCB.on(
        'select',
        function(combo, record, index ) {
				docNoST.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=VouchMaintainList&yearPeriodId='+accountingPeriodCB.getValue(), method:'GET'});				
				docNoST.load();
				docNoCB.clearValue();
			}
    );	
	
////////////////////////////////////////////////////
//var docNoST = new Ext.data.SimpleStore({
//		fields : ['rowid','name'],
//		data : [['40012010080004','40012010080004'],
//				['40012010100001','40012010100001']]
//	});
	
	
var docNoST = new Ext.data.Store({
    autoLoad: true,
    proxy:"",
    reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['vouchNo','rowid'])
});

docNoST.on(
        'beforeload',
        function(ds, o) {
            ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=VouchMaintainList&yearPeriodId='+accountingPeriodCB.getValue(), method:'GET'});
        }
    );	
	
		
var docNoCB = new Ext.form.ComboBox({
		id:'docNoCB',
		store: docNoST,
		valueField:'vouchNo',
		displayField:'vouchNo',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'docNoCB',
		selectOnFocus: true,
		//mode:'local',
		forceSelection: true
	});
		

var docNoCB2 = new Ext.form.ComboBox({
		id:'docNoCB2',
		store: docNoST,
		valueField:'vouchNo',
		displayField:'vouchNo',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'docNoCB2',
		selectOnFocus: true,
		//mode:'local',
		forceSelection: true
	});
	
/////////////////////////////////////////////////
var managersST = new Ext.data.SimpleStore({
		fields : ['rowid','name'],
		data : [['demo','demo']]
	});
	
var managersCB = new Ext.form.ComboBox({
		id:'managersCB',
		store: managersST,
		valueField:'rowid',
		displayField:'name',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��...',
		allowBlank: false,
		name:'managersCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});

////////////////////////////////////////////////////	
var saveButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',        
		iconCls: 'add',
		handler: function(){}
	})
	
var inquiryButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',        
		iconCls: 'add',
		handler: function(){
			if(false){
				Ext.Msg.alert('��ʾ','����Ϊ��!');
			}else{
				vouchMaintainSt.proxy = new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=VouchMaintain&yearPeriodId='+accountingPeriodCB.getValue()+'&noFrom='+docNoCB.getValue()+'&noTo='+docNoCB2.getValue()});
				vouchMaintainSt.load();				
			}
		}
	})

////////////////////////////////////////////////////
var vouchMaintainSt = new Ext.data.Store({
		//proxy: new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=VouchMaintain&yearPeriodId='+accountingPeriodCB.getValue()+'&docNoFrom='+docNoCB.getValue()+'&docNoTo='+docNoCB2.getValue()+'&managers='+managersCB.getValue()}),
		proxy: new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=VouchMaintain&yearPeriodId='+accountingPeriodCB.getValue()+'&managers='+managersCB.getValue()}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
			}, [
				//'TempNo',
				//'CertiNo',
				//'CertiDate',
				//'CertiType',
				//'Summary',
				//'DocNo',
				//'CreatUser',
				//'AuditUser',
				//'Accounter'
				
				'rowid','acctYearPeriod','acctVouchTypeDr','vouchSource','acctBusiTypeDr','acctBusiTypeName','vouchNo','vouchNoUse','vouchDate','vouchBillNum','operator','auditor','poster','isCheck','isAcc','isCx','isCancel','cVouchId','outSubjCode','sheetNo'
			]),
		remoteSort: true
	});
	
var vouchMaintainCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: '��ʱƾ֤��',
        dataIndex: 'vouchNo',
        width: 100,
        align: 'left',
		renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
        sortable: true
    },
    {
        header: "��ʽƾ֤��",
        dataIndex: 'vouchNoUse',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "ƾ֤����",
        dataIndex: 'vouchDate',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "ƾ֤����",
        dataIndex: 'acctBusiTypeName',
        width: 100,
        align: 'left',
        sortable: true
    },
    //{
    //    header: "ժҪ",
    //    dataIndex: 'Summary',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
    {
        header: "���ݺ�",
        dataIndex: 'sheetNo',
        width: 100,
        align: 'left',
		renderer:function(value,meta,rec,rowIndex,colIndex,store){
				return "<font color=blue>"+value+"</font>";
			},
        sortable: true
    },
    {
        header: "�Ƶ���",
        dataIndex: 'operator',
        width: 100,
        align: 'left',
        sortable: true
    }//,
	//{
    //    header: "�����",
    //    dataIndex: 'auditor',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
    //{
    //    header: "������",
    //    dataIndex: 'poster',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //}
]);

var autohisoutmedMain = new Ext.grid.GridPanel({
		title: 'ƾ֤ά��',
		store: vouchMaintainSt,
		cm:vouchMaintainCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel(),
		loadMask: true,
		//tbar: ['����ڼ�:',accountingPeriodCB,'-','ƾ֤��:',docNoCB,'��',docNoCB2,'-','�Ƶ���:',managersCB,'-',saveButton,inquiryButton],
		//tbar: ['����ڼ�:',accountingPeriodCB,'-','�Ƶ���:',managersCB,'-',inquiryButton],
		tbar: ['����ڼ�:',accountingPeriodCB,'-','ƾ֤��:',docNoCB,'��',docNoCB2,'-',inquiryButton],
		listeners : {
			'cellclick' : function(grid, rowIndex, columnIndex, e){
				//alert(columnIndex);
				if(columnIndex==1){
					autohisoutmedvouchFun(grid, rowIndex, columnIndex, e);
				}
				if(columnIndex==5){
					var selectedRec = grid.getStore().getAt(rowIndex);	
					var fieldNO = grid.getColumnModel().getDataIndex(5);
					var dataNO = selectedRec.get(fieldNO);
					var tmpTypeRec = vouchMaintainSt.getAt(rowIndex);
					var tmpTypeDr = tmpTypeRec.get('acctBusiTypeDr');
					//alert(tmpTypeDr);
					if(dataNO=='����'){
						purchasestorageformallFun(grid, rowIndex, columnIndex, e);
					}else{
						purchasestorageformFun(grid, rowIndex, columnIndex, e,tmpTypeDr);
					}
				}
			}
		}
	});
	
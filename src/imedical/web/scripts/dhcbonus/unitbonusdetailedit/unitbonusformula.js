function unitbonusformula(year,Period,UnitCodeName,BonusFormula,BonusSchemeCodeName){
	var itemGrid = new dhc.herp.Grid({
        //width: 400,
       
        region: 'center',
        url: 'dhc.bonus.unitbonusdetaileditexe1.csp', 
		atLoad : true,  // �Ƿ��Զ�ˢ��
		//loadmask:true,
        fields: [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
		{
            header: 'ID',
            dataIndex: 'rowid',
			editable:false,
            hidden: true
        },{
            id:'fBonusYear',
            header: '�������',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'fBonusYear'
        },{
           id:'fBonusPeriod',
            header: '�����ڼ�',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'fBonusPeriod'   
        },{
            id:'fBonusUnitCode',
            header: '���ұ���',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'fBonusUnitCode'
        },{
            id:'fBonusUnitName',
            header: '��������',
			allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'fBonusUnitName'
        },{
            id:'fBonusTargetCode',
            header: '����ָ�����',
			allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'fBonusTargetCode'
        },{
            id:'fBonusTargetName',
            header: '����ָ������',
			allowBlank: false,
			editable:false,
			width:100,
            dataIndex: 'fBonusTargetName'
        },{
            id:'fTargetValue',
            header: '����ָ��ֵ',
			allowBlank: false,
			editable:true,
			width:120,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							return '<span style="color:blue;cursor:hand">'+value+'</span>';
						},
            dataIndex: 'fTargetValue'
        },{
            id:'fSchemeName',
            header: '��������',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'fSchemeName'
        }]
});
	itemGrid.btnAddHide();     //�������Ӱ�ť
    itemGrid.btnSaveHide();    //���ر��水ť
    itemGrid.btnResetHide();   //�������ð�ť
    itemGrid.btnDeleteHide();  //����ɾ����ť
    itemGrid.btnPrintHide();   //���ش�ӡ��ť
	
	itemGrid.load({params:{start:0,limit:25,year:year,Period:Period,UnitCodeName:UnitCodeName,BonusFormula:BonusFormula,BonusSchemeCodeName:BonusSchemeCodeName}});

	var formulaWindow = new Ext.Window({
		title:'��ʽ��ϸ',
		width:750,
		height:480,
		region:'center',
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:itemGrid		
	});
	formulaWindow.show();
	
	var oldBonusValue="";
	itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
	var len = rowObj.length;
    if(len > 0)
    {
		if (columnIndex == 8) {
			var BonusValue=rowObj[0].get("fTargetValue");
			sOldBonusValue=BonusValue;
			
			//BonusValue=this.getStore().getModifiedRecords();
			

		}

	}
		
});
itemGrid.on("afteredit", afterEdit, itemGrid);  

function afterEdit(obj){  
var r = obj.record;//��ȡ���޸ĵ���  
var l = obj.field;//��ȡ���޸ĵ���  
var smyRowid = r.get("rowid");
var sItemCode=r.get("fBonusTargetCode");
var sItemName=r.get("fBonusTargetName");
var sBonusSchemeCodeName=r.get("fSchemeName");
var sBonusYear=r.get("fBonusYear");
var sBonusPeriod=r.get("fBonusPeriod");
var fBonusUnitCode=r.get("fBonusUnitCode");
var fBonusUnitName=r.get("fBonusUnitName");
var sBonusUnitCodeName=fBonusUnitCode+"_"+fBonusUnitName;
var sBonusValue=r.get("fTargetValue");
var sYearMonth=sBonusYear+sBonusPeriod;
var sdetailData="������"+sBonusSchemeCodeName+"--"+"���ң�"+sBonusUnitCodeName
Ext.Ajax.request({
			url:  'dhc.bonus.unitbonusdetaileditexe.csp?action=editTargetValue&srowid='+smyRowid+'&sOldBonusValue='+sOldBonusValue+'&sBonusValue='+sBonusValue+'&userCode='+userCode+'&sItemCode='+sItemCode+'&sItemName='+sItemName+'&sdetailData='+sdetailData+'&sYearMonth='+sYearMonth,
			waitMsg:'������...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {				
				var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGrid.load({params:{start:0, limit:25}});
				}
				else
				{
					var message = "";
					message = "SQLErr: " + jsonData.info;
					if(jsonData.info!=0) message='��Ϣ�޸�����!';
				  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
		scope: this
	});
}  
	
}
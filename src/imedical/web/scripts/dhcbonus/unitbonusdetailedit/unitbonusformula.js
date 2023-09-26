function unitbonusformula(year,Period,UnitCodeName,BonusFormula,BonusSchemeCodeName){
	var itemGrid = new dhc.herp.Grid({
        //width: 400,
       
        region: 'center',
        url: 'dhc.bonus.unitbonusdetaileditexe1.csp', 
		atLoad : true,  // 是否自动刷新
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
            header: '核算年度',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'fBonusYear'
        },{
           id:'fBonusPeriod',
            header: '核算期间',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'fBonusPeriod'   
        },{
            id:'fBonusUnitCode',
            header: '科室编码',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'fBonusUnitCode'
        },{
            id:'fBonusUnitName',
            header: '科室名称',
			allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'fBonusUnitName'
        },{
            id:'fBonusTargetCode',
            header: '核算指标编码',
			allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'fBonusTargetCode'
        },{
            id:'fBonusTargetName',
            header: '核算指标名称',
			allowBlank: false,
			editable:false,
			width:100,
            dataIndex: 'fBonusTargetName'
        },{
            id:'fTargetValue',
            header: '核算指标值',
			allowBlank: false,
			editable:true,
			width:120,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							return '<span style="color:blue;cursor:hand">'+value+'</span>';
						},
            dataIndex: 'fTargetValue'
        },{
            id:'fSchemeName',
            header: '方案名称',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'fSchemeName'
        }]
});
	itemGrid.btnAddHide();     //隐藏增加按钮
    itemGrid.btnSaveHide();    //隐藏保存按钮
    itemGrid.btnResetHide();   //隐藏重置按钮
    itemGrid.btnDeleteHide();  //隐藏删除按钮
    itemGrid.btnPrintHide();   //隐藏打印按钮
	
	itemGrid.load({params:{start:0,limit:25,year:year,Period:Period,UnitCodeName:UnitCodeName,BonusFormula:BonusFormula,BonusSchemeCodeName:BonusSchemeCodeName}});

	var formulaWindow = new Ext.Window({
		title:'公式明细',
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
var r = obj.record;//获取被修改的行  
var l = obj.field;//获取被修改的列  
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
var sdetailData="方案："+sBonusSchemeCodeName+"--"+"科室："+sBonusUnitCodeName
Ext.Ajax.request({
			url:  'dhc.bonus.unitbonusdetaileditexe.csp?action=editTargetValue&srowid='+smyRowid+'&sOldBonusValue='+sOldBonusValue+'&sBonusValue='+sBonusValue+'&userCode='+userCode+'&sItemCode='+sItemCode+'&sItemName='+sItemName+'&sdetailData='+sdetailData+'&sYearMonth='+sYearMonth,
			waitMsg:'保存中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {				
				var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGrid.load({params:{start:0, limit:25}});
				}
				else
				{
					var message = "";
					message = "SQLErr: " + jsonData.info;
					if(jsonData.info!=0) message='信息修改有误!';
				  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
		scope: this
	});
}  
	
}
(function(){
	Ext.ns("dhcwl.KDQ.RptItemPro");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.RptItemPro=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/rptitempro.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptName="";
	var initAttrib;
	
	
	
	var ItemProForm= new Ext.FormPanel({
        labelWidth: 90, // label settings here cascade unless overridden
        frame:true,
		//labelAlign : 'right',
        bodyStyle:'padding:5px',
        items: [
			{
				fieldLabel: '描述',
				name: 'descript',
				anchor: '95%',
				xtype:'textfield'
			},{
				xtype:'combo',
                fieldLabel: '显示格式',
				name:'showFormat',
				anchor: '95%',
				mode:'local',
				triggerAction:  'all',
				editable: false,
				displayField:   'description',
				valueField:     'name',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'name'],
					data   : [
						{description : '#0.00',name: '#0.00'},
						{description : '#0.000',name: '#0.000'},
						{description : '#0.0000',name: '#0.0000'},
						{description : '#',name: '#'}
					]
				})				
            },{
				xtype:'combo',
				hidden:true,
                fieldLabel: '<span style="line-Height:1">是否计算合计</span>',
                name: 'IsAggregate',
				anchor: '95%',
				mode:'local',
				triggerAction:  'all',
				editable: false,
				displayField:   'description',
				valueField:     'name',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'name'],
					data   : [
						{description : '是',name: '是'},
						{description : '否',name: '否'}
					]
				})
            }
        ]				
    });	
	

	
	var ItemProWin = new Ext.Window({
        width:300,
		height:300,
		resizable:false,
		closable : false,
		title:'报表项属性',
		modal:true,
		//items:[saveAsForm,rptGrid],
		layout: 'fit',
		items: ItemProForm,		

		buttons: [
		{
			text: '确定',
			handler: CloseWins
		}]
	});	
	
	this.getRptItemProWin=function() {
		return ItemProWin;
	}
	
	function CloseWins() {
		if (outThis.CallBack) {
			if (outThis.ModifyRec) {
				var baseForm=ItemProForm.getForm();				 
				var newObj=baseForm.getFieldValues();
				outThis.CallBack(outThis.ModifyRec,newObj);
			}
		}
		ItemProWin.close();
	}
	
	this.initV=function(oldValueObj) {
		var baseForm=ItemProForm.getForm();
		
		for (var v in oldValueObj) {
			if (v=="IsAggregate") baseForm.findField(v).setVisible(true);
			baseForm.findField(v).setValue(oldValueObj[v]);
			
		}
	}
	
}


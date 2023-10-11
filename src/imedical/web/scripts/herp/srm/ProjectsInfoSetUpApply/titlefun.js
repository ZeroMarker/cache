var titleFun = function(ProjectDR,RelyUnitsIDs) {
//alert(ProjectDR);
/////////////////////课题名称/////////////////////////
var NameField  = new Ext.form.TextField({
			fieldLabel: '课题名称',
			width : 160,
			emptyText: '',
			selectOnFocus : true		
		});
		
////////项目负责人
 HeadField = new Ext.form.TextField({
            fieldLabel: '项目负责人',
			width : 160,
			selectOnFocus : 'true'
           });		
 ////////科室
 DeptField = new Ext.form.TextField({
            fieldLabel: '科室',
			width : 160,
			selectOnFocus : 'true'
           });	
                     
 CompleteUnitField = new Ext.form.TextField({
            fieldLabel: '我院单位位次',
			width : 160,
			selectOnFocus : true
           });	

 PTNameField = new Ext.form.TextField({
            fieldLabel: '课题类型',   
			width : 160,
			selectOnFocus : true
           });	

var RelyUnitsGrid = new Ext.grid.GridPanel({
        fieldLabel: '依托单位', 
		id:'RelyUnitsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmprojectsinfoexe.csp'+'?action=RelyUnitsID&start='+0+'&limit='+25+'&RelyUnitsIDs='+RelyUnitsIDs,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 100,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '单位ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '单位名称', dataIndex: 'name',align:'center',width: 160}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 162,
    height: 100
});
	
 StartDateField = new Ext.form.TextField({
			fieldLabel: '开始日期',
			width : 160,	
			selectOnFocus : true
           });	
           
           /////结束日期
  EndDateField = new Ext.form.TextField({
			fieldLabel:'结束日期',
			width : 160,
			selectOnFocus : true
			
           });	
           /////是否政府项目
 IsGovBuyField = new Ext.form.TextField({
			fieldLabel:'是否政府项目',
			width : 160,
			selectOnFocus : true
			
           });	
           /////是否伦理审批	
 IsEthicalApprovalField = new Ext.form.TextField({
			fieldLabel:'是否需要伦理审批',
			width : 160,
			selectOnFocus : true
			
           });	
                      /////是否伦理审批	
 RemarkField = new Ext.form.TextField({
			fieldLabel:'备注',
			width : 160,
			selectOnFocus : true
			
           });	
	
Ext.Ajax.request({
					url: '../csp/herp.srm.srmprojectsinfoexe.csp?action=gettitle&rowid='+ProjectDR,				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcodes = jsonData.info;
							//alert(jsonData.info);
							//alert(bcodes);
							var arr = bcodes.split("^");
							var Name=arr[0];
							NameField.setValue(Name);
							var Head=arr[1];
							HeadField.setValue(Head);
							var CompleteUnit=arr[2];
							CompleteUnitField.setValue(CompleteUnit);
							var PTName=arr[3];
							PTNameField.setValue(PTName);
							var StartDate=arr[4];
							StartDateField.setValue(StartDate);
							var EndDate=arr[5];
							EndDateField.setValue(EndDate);
							var IsGovBuy=arr[6];
							IsGovBuyField.setValue(IsGovBuy);
						    var IsEthicalApproval=arr[7];
							IsEthicalApprovalField.setValue(IsEthicalApproval);
							var Remark=arr[8];
							RemarkField.setValue(Remark);
							var Dept=arr[9];
							DeptField.setValue(Dept);
							
						}else{
							var message="";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});						
						}
					},
					scope: this
					});

			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:8px 8px 3',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									NameField,	
									DeptField,
									HeadField,
									CompleteUnitField,	
									PTNameField,
									StartDateField,
									EndDateField
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								    RelyUnitsGrid,
									//IsGovBuyField,		
									IsEthicalApprovalField,								
									RemarkField
																			
								]
							}]
					}
				]	
				
				var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 90,
				height: 280,
				layout: 'form',
				frame: true,
				items: colItems
			});		
	
			addwin = new Ext.Window({
				title: '项目课题明细信息',
				width: 600,
				height: 330,
				//autoHeight: true,
				atLoad: true,
				//layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'sorth',
				items: formPanel
			});
		
			addwin.show();

}
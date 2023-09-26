function InitOPR(obj){
	
	var OPRitemLen = 13;
	var OPRbtnSave = new Array(OPRitemLen);
	var OPRbtnDelete = new Array(OPRitemLen);
	var OPRtxtLastSyncTime = new Array(OPRitemLen);
	
	function OPRinitbtn() {
		for (var i=0;i<OPRitemLen;i++) {
			OPRbtnSave[i] = new Ext.Button({
				id : 'OPRbtnSave'+i
				,text : 'ͬ������'
				,listeners : {
					'click' : function(){
						alert(this.id);
					}
				}
			});
			OPRbtnDelete[i] = new Ext.Button({
				id : 'OPRbtnDelete'+i
				,text : '�������'
				,hidden : true
				,listeners : {
					'click' : function(){
						alert(this.id);
					}
				}
			});
			OPRtxtLastSyncTime[i] = new Ext.form.TextField({
				id : 'OPRtxtLastSyncTime'+i
				,width : 150
				,fieldLabel : '���ͬ��ʱ��'
			});
		};
		
	}
	OPRinitbtn(); 
	
	obj.OPRpnReportData = new Ext.Panel({
		id : 'OPRpnReportData',
		height : 340,
		layout : 'form',
		items : [
			{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "ҵ������(Report)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [OPRbtnSave[12]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [OPRtxtLastSyncTime[12]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [OPRbtnDelete[12]]
							}
						]
			}
		]
	});
	
	obj.OPRReportData = new Ext.form.FieldSet({
		id : 'OPRReportData'
		,height : 60
		,title : 'ҵ������ͬ��'
		,items:[
			obj.OPRpnReportData
		]
	});
	
	obj.OPRDATA_ViewPort = {
		//title : '',
		layout : 'form',
		frame : true,
		height : 600,
		anchor : '-20',
		tbar : ['����ϵͳ����ͬ��'],
		items : [
			{
				layout : 'column',
				frame : false,
				items : [
					{
						columnWidth:.03,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : []
					},{
						columnWidth:.85,
						region: 'center',
						layout : 'form',
						height : 70,
						//frame : true,
						labelWidth : 60,
						items : [
							obj.OPRReportData
						]
					}
				]
			}
		]
	}

  return obj;
}



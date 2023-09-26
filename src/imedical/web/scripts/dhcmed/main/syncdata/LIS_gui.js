function InitLIS(obj){
	
	obj.TSResultCls=ExtTool.StaticServerObject("DHCMed.DCEns.LIS.TSResultHand");
	
	obj.txtSysver = new Ext.form.TextField({
		id : 'txtSysver'
		,width : 60
		,fieldLabel : '检验系统版本(V1/V2)'
	});
	obj.txtHospCode = new Ext.form.TextField({
		id : 'txtHospCode'
		,width : 60
		,fieldLabel : '医院缩写码(HospCode)'
	});
	obj.txtArgument = new Ext.form.TextField({
		id : 'txtArgument'
		,width : 140
		,fieldLabel : '查看数据'
		,emptyText : 'EpisodeId\\TSRowID'
		,listeners : {
			'specialKey' : function(fild,e) {
				if (e.getKey() != Ext.EventObject.ENTER) return;
				var DateFrom=obj.txtDateFrom.getRawValue();
				var DateTo=obj.txtDateTo.getRawValue();
				var Arg=obj.txtArgument.getValue();
				var objWinRepInfo = new InitWinRepInfo(DateFrom,DateTo,Arg);
				objWinRepInfo.WinRepInfo.show();
			}
		}
	});
	obj.txtDateFrom = new Ext.form.DateField({
		id : 'txtDateFrom'
		,fieldLabel : '同步日期'
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 20
		,anchor : '100%'
		,value : new Date()
	});
	obj.txtDateTo = new Ext.form.DateField({
		id : 'txtDateTo'
		,fieldLabel : '至'
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 30
		,anchor : '90%'
		,value : new Date()
	});
	obj.btnLoadTime = new Ext.Button({
		id : 'btnLoadTime'
		,text : '查看最后更新时间'
		,listeners : {
			'click' : function(){
				var TSVer1=obj.txtSysver.getValue();
				var HospCode1=obj.txtHospCode.getValue();
				if ((TSVer1=="")||(HospCode1=="")) {
					alert("入参不完整！");
					return;
				}
				var UpdateTimeArry=obj.TSResultCls.GetUpdateTime(TSVer1,HospCode1,"").split("^");
				for (var i=0;i<LISitemLen;i++) {
					LIStxtLastSyncTime[i].setValue(UpdateTimeArry[i]);
				}
			}
		}
	});
	obj.LISpnArgs = new Ext.Panel({
		id : 'LISpnArgs',
		height : 60,
		layout : 'form',
		items : [
			{
				layout : 'column',
				items : [
							{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "同步参数(必填)："
										}]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 150,
								items : [obj.txtSysver]
							},{
								columnWidth:.25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 150,
								items : [obj.txtHospCode]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 180,
								items : [obj.btnLoadTime]
							}
						]
			}
		]
	});
	var LISitemLen = 12;
	var LISbtnSave = new Array(LISitemLen);
	var LISbtnDelete = new Array(LISitemLen);
	var LIStxtLastSyncTime = new Array(LISitemLen);
	
	function LISinitbtn() {
		var j="";
		for (var i=0;i<LISitemLen;i++) {
			LISbtnSave[i] = new Ext.Button({
				id : 'LISbtnSave'+i
				,text : '同步数据'
				,listeners : {
					'click' : function(){
						//alert(this.id);
						var TSVer=obj.txtSysver.getValue();
						var HospCode=obj.txtHospCode.getValue();
						var DateFrom=obj.txtDateFrom.getRawValue();
						var DateTo=obj.txtDateTo.getRawValue();
						if ((TSVer=="")||(HospCode=="")) {
							alert("入参不完整！");
							return;
						}
						var ItemType="";
						switch (this.id)
						{
							case "LISbtnSave0" : ItemType="Doctor";j=0;break;
							case "LISbtnSave1" : ItemType="BTABOBG";j=1;break;
							case "LISbtnSave2" : ItemType="BTAntibiotics";j=2;break;
							case "LISbtnSave3" : ItemType="BTOrganism";j=3;break;
							case "LISbtnSave4" : ItemType="BTSensitivity";j=4;break;
							case "LISbtnSave5" : ItemType="BTSpecimen";j=5;break;
							case "LISbtnSave6" : ItemType="BTTestCode";j=6;break;
							case "LISbtnSave7" : ItemType="BTTestCodeSC";j=7;break;
							case "LISbtnSave8" : ItemType="BTTestSet";j=8;break;
							case "LISbtnSave9" : ItemType="BTWorkGroup";j=9;break;
							case "LISbtnSave10" : ItemType="Loc";j=10;break;
							case "LISbtnSave11" : ItemType="Report";j=11;break;
							default : alert("ERROR");return;
						}
						var ret=obj.TSResultCls.SyncData(TSVer,HospCode,ItemType,DateFrom,DateTo);
						//alert(ret);
						if ((j!="")&&(parseInt(ret)>0)) {
							var UpdateTime=obj.TSResultCls.GetUpdateTime(TSVer,HospCode,ItemType);
							LIStxtLastSyncTime[j].setValue(UpdateTime);
						}
					}
				}
			});
			LISbtnDelete[i] = new Ext.Button({
				id : 'LISbtnDelete'+i
				,text : '清除数据'
				,hidden : true
				,listeners : {
					'click' : function(){
						alert(this.id);
					}
				}
			});
			LIStxtLastSyncTime[i] = new Ext.form.TextField({
				id : 'LIStxtLastSyncTime'+i
				,width : 150
				,fieldLabel : '最后同步时间'
			});
		};
		
	}
	LISinitbtn(); 
	
	obj.LISpnBaseData = new Ext.Panel({
		id : 'LISpnBaseData',
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
											text: "医生(Doctor)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[0]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[0]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[0]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "科室(LOC)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[10]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[10]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[10]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "血型(ABOBG)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[1]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[1]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[1]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "抗生素(Antibiotics)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[2]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[2]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[2]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "细菌(Organism)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[3]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[3]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[3]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "细菌培养(Sensitivity)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[4]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[4]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[4]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "标本(Specimen)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[5]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[5]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[5]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "检验医嘱(TestSet)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[8]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[8]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[8]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "检验项目(TestCode)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[6]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[6]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[6]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "检验项目标准意见(TestCodeSC)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[7]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[7]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[7]]
							}
						]
			},{
				layout : 'column',
				items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [{
											xtype: "label",
											text: "工作组(WorkGroup)"
										}]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnSave[9]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LIStxtLastSyncTime[9]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[9]]
							}
						]
			}
		]
	});
	
	obj.LISpnReportData = new Ext.Panel({
		id : 'LISpnReportData',
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
											text: "业务数据(Report、Result、ResultSen)"
										}]
							},{
								columnWidth:.18,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [obj.txtDateFrom]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 20,
								items : [obj.txtDateTo]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 30,
								items : [LISbtnSave[11]]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [obj.txtArgument]
							},{
								columnWidth:.30,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								hidden : true,
								items : [LIStxtLastSyncTime[11]]
							},{
								columnWidth:.10,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 80,
								items : [LISbtnDelete[11]]
							}
						]
			}
		]
	});
	
	obj.LISBaseData = new Ext.form.FieldSet({
		id : 'LISBaseData'
		,height : 320
		,title : '基础字典数据同步'
		,items:[
			obj.LISpnBaseData
		]
	});
	
	obj.LISReportData = new Ext.form.FieldSet({
		id : 'LISReportData'
		,height : 70
		,title : '业务数据同步'
		,items:[
			obj.LISpnReportData
		]
	});
	
	obj.LISDATA_ViewPort = {
		//title : '',
		layout : 'form',
		frame : true,
		height : 500,
		anchor : '-20',
		tbar : ['检验系统数据同步'],
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
						height : 30,
						//frame : true,
						labelWidth : 120,
						items : [
							obj.LISpnArgs
						]
					}
				]
			},{
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
						height : 330,
						//frame : true,
						labelWidth : 60,
						items : [
							obj.LISBaseData
						]
					}
				]
			},{
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
							obj.LISReportData
						]
					}
				]
			}
		]
	}

  return obj;
}
function InitWinRepInfo(aFromDate,aToDate,aArgument){
	var obj = new Object();
	obj.btnClose = new Ext.Button({
		id : 'btnClose'
		,iconCls : 'icon-exit'
		,text : '关闭'
		,listeners : {
			'click' : function(){
				obj.WinRepInfo.close();
			}
		}
	});
	
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridPanelStore = new Ext.data.GroupingStore({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ind'
		},[
			{name: 'ind', mapping: 'ind'}
			,{name: 'TestSetRow', mapping: 'TestSetRow'}
			,{name: 'TestSetDesc', mapping: 'TestSetDesc'}
			,{name: 'SpecimenDesc', mapping: 'SpecimenDesc'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'CollectDT', mapping: 'CollectDT'}
			,{name: 'AuthDT', mapping: 'AuthDT'}
		])
	});
	
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,header : true
		,store : obj.GridPanelStore
		,columnLines:true
		,loadMask : true
		,region : 'center'
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'TestSetRow', width: 120, dataIndex: 'TestSetRow', menuDisabled:true}
			,{header: '检验医嘱', width: 150, dataIndex: 'TestSetDesc', sortable: true}
			,{header: '检验标本', width: 100, dataIndex: 'SpecimenDesc', sortable: true}
			,{header: '申请科室', width: 100, dataIndex: 'LocDesc', sortable: true}
			,{header: '采集时间', width: 100, dataIndex: 'CollectDT', sortable: true}
			,{header: '审核时间', width: 100, dataIndex: 'AuthDT', sortable: true}
		]
	});
	
	obj.WinRepInfo = new Ext.Window({
		id : 'WinRepInfo'
		,width : 800
		,plain : true
		,buttonAlign : 'center'
		,height : 500
		,title : '检验报告信息列表'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.GridPanel
		]
	,	buttons:[
			obj.btnClose
		]
	});
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.DCEns.LIS.TSResultHand';
			param.QueryName = 'QryLabRepInfo';
			param.Arg1 = aFromDate;
			param.Arg2 = aToDate;
			param.Arg3 = aArgument;
			param.ArgCnt = 3;
	});
	obj.GridPanelStore.load({});
  return obj;
}


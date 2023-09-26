
function InitviewMainEvent(obj)
{
	var grid;
	var ds;
	var index =0;
	var EpisodeID=0;
	var CtRowid=0;
	var CtDesc=""
	var CtStr=""
	var MrPathRowid=0
	obj.LoadEvent = function(args)
	{
		rowDblClick();
	}
	
	obj.GetAllDoc=function(){
		index=0;
		rowDblClick();
	}
	obj.GetDocPathWay=function(){
		index=1;
		rowDblClick();	
	}
	var rowDblClick = function(){
		var gridTitle=""
		obj.EpisodeID=""
		obj.PatientID=""
		obj.MRAdm=""
		Ext.getCmp('AllDoc').setVisible(false)
		Ext.getCmp('DocPathWay').setVisible(false)
		if (index==0){
			var queryClass = 'web.DHCCPW.MR.ClinPathWaysStat';
			var queryName = 'QryAdmitStat';
			var parameters = {ArgCnt:0};
		} else if(index==1){
			Ext.getCmp('AllDoc').setVisible(true)
			//var record=Ext.getCmp("gridResult").getSelectionModel().getSelected()     //Update By NiuCaicai FixBug:100 实施管理--在院患者统计-排序后点击【首页】返回，显示不正常
			var record=arguments[0].getSelectionModel().getSelected()
			if(record){
				if(record.get('CtRowid')){
					CtRowid=record.get('CtRowid');          //取科室id*/
					CtDesc=record.get('CtDesc')
					var InPathWayNum=record.get('InPathWayNum')     //取入径人数
					if(InPathWayNum==0) return
					CtStr="&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>科室</font>："+CtDesc
					CtStr=CtStr+"&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>在院人数</font>："+record.get('InHospitalNum')
					CtStr=CtStr+" &nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>入径人数</font>："+record.get('InPathWayNum')
				}
			}
			if(CtRowid=="") return
			var queryService = ExtTool.StaticServerObject("web.DHCCPW.QueryService");
			var retFns = queryService.GetQueryStore("web.DHCCPW.MR.ClinPathWaysStat","QryAdmitStatDetail")
			window.eval(retFns);
			var fns = arryCol
			var fns1 = Ext.data.Record.create(fns);
			var store = new Ext.data.GroupingStore({
				proxy:new Ext.data.HttpProxy(new Ext.data.Connection({
									url : ExtToolSetting.RunQueryPageURL
				})),
				reader:new Ext.data.JsonReader({
									root: 'record',
									totalProperty: 'total'
				},fns1),
				baseParams:{ClassName:"web.DHCCPW.MR.ClinPathWaysStat",QueryName:"QryAdmitStatDetail",ArgCnt:1,Arg1:CtRowid},
				sortInfo:{field: 'PathWayId', direction: "ASC"},
				groupField:'PathNumStr'
			});
			var colModel = new Ext.grid.ColumnModel([
				{header: '临床路径ID',dataIndex: 'PathWayId', sortable: true,hidden:true}
				,{header: '入径数',dataIndex: 'PathNumStr', sortable: true,hidden:true}
				,{header: '姓名',dataIndex: 'PAPMIName', sortable: true}
				,{header:'性别',dataIndex:'sex',sortable:true}
				,{header: '年龄',dataIndex: 'PAPMIAge', sortable: true}
				,{header: '医生',dataIndex: 'PAAdmDocCodeDR', sortable: true}
				,{header: '入院日期',dataIndex: 'admDate', sortable: true}
				,{header: '入径日期',dataIndex: 'cpwInDate', sortable: true}
				,{header: '所处步骤',dataIndex: 'currentStepDesc', sortable: true}
				,{header: '入径天数',dataIndex: 'cpwDateNo', sortable: true}
				,{header: '在院天数',dataIndex: 'AdmDays', sortable: true}
				,{header: '费用',dataIndex: 'cont', sortable: true}
				,{header: '药费比例',dataIndex: 'DrugRatio', sortable: true}
				//,{header: '入径天数/在院天数',dataIndex: 'cpwDataNoPercent', sortable: true}
				,{header: '已实施项目比例',dataIndex: 'implItemsPercent', sortable: true}
				,{header: '是否变异',dataIndex: 'CheckVar', sortable: true}
			]);
			var cm = colModel;
			//Update By NiuCaicai FixBug:100 实施管理--在院患者统计-排序后点击【首页】返回，显示不正常
			//var x = Ext.getCmp("gridResult");
			//if (x) obj.panelCenter.remove(x);
			obj.panelCenter.removeAll(true);
			var btnShowForm  = new Ext.Toolbar.Button({
				id : 'btnShowForm',
				text: '展现表单',
				iconCls : 'icon-export',
				tooltip: '展现表单'
			});
			var grid = new Ext.grid.GridPanel({
				//id:"gridResult",              //Update By NiuCaicai FixBug:100 实施管理--在院患者统计-排序后点击【首页】返回，显示不正常
				title:"",
				cm:cm,
				store:store,
				view: new Ext.grid.GroupingView({
					forceFit:true,
					groupTextTpl: '{[values.rs[0].get("PathNumStr")]}',
					groupByText:'依本列分组'
				}),
				tbar:[
					btnShowForm,
					{
						xtype:'label',
						html:CtStr
					}
				],
				listeners : {
					'rowdblclick': function(){
						rowDblClick(this);
					}
				}
			});
			grid.getSelectionModel().on('rowselect',function(){
				var record=grid.getSelectionModel().getSelected();
				EpisodeID=record.get('EpisodeID')
				obj.PatientID=record.get('PatientID')
				obj.MRAdm=record.get('MRAdm')
			});
			btnShowForm.on("click", function(){      //弹出"展现表单"页面
					var record=grid.getSelectionModel().getSelected();
					if(!record){
						alert("请选择一个病人")
						return
					}
					EpisodeID=record.get('EpisodeID');
					MrPathRowid=record.get('MrPathRowid');
					obj.PatientID=record.get('PatientID');
					obj.MRAdm=record.get('MRAdm');
					FormShowHeader(MrPathRowid,0,0,0,0,0,0,0);
			},obj);
			if (grid) {
					obj.panelCenter.add(grid);
					obj.panelCenter.doLayout();
			}
			store.load({})
			obj.CurrentGrid = grid;
			index++;
			return
		}else if(index==2){
			Ext.getCmp('AllDoc').setVisible(true);
			Ext.getCmp('DocPathWay').setVisible(true);
			return;
			/* update by zf 20101114
			Ext.getCmp('DocPathWay').setText(CtDesc)
			Ext.getCmp('AllDoc').setVisible(true)
			Ext.getCmp('DocPathWay').setVisible(true);
			var queryClass = 'web.DHCCPW.MRC.CheckPathItem';
			var queryName = 'GetCheckRules';
			var parameters = {ArgCnt:1,Arg1:EpisodeID};
			var record=Ext.getCmp("gridResult").getSelectionModel().getSelected()
			var patientName=record.get('PAPMIName')
			gridTitle="&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>科室</font>："+CtDesc
			gridTitle=gridTitle+"&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>病人</font>："+patientName
			*/
		}else if(index==3){
			Ext.getCmp('AllDoc').setVisible(true)
			Ext.getCmp('DocPathWay').setVisible(true)
			return;
		}
		//Update By NiuCaicai FixBug:100 实施管理--在院患者统计-排序后点击【首页】返回，显示不正常
		//var x = Ext.getCmp("gridResult");
		//if (x) obj.panelCenter.remove(x);
		obj.panelCenter.removeAll(true);
		grid = LoadData(queryClass,queryName,parameters,gridTitle);
		if (grid) {
			obj.panelCenter.add(grid);
			obj.panelCenter.doLayout();
		}
		ds.load({});
		obj.CurrentGrid = grid;
		index++;
	}
	var LoadData = function(queryClass,queryName,parameters,gridTitle){
		//var queryUrl = ExtToolSetting.RunQueryPageURL;
		parameters.ClassName = queryClass;
		parameters.QueryName = queryName;
		var queryService = ExtTool.StaticServerObject("web.DHCCPW.QueryService");
		var retFns = queryService.GetQueryStore(queryClass,queryName)
		
		window.eval(retFns);
		var fns = arryCol
		
		var retCm = queryService.GetQueryGridHeaderDeclare(queryClass,queryName)
		window.eval(retCm);
		var cm = colModel
			
		ds = new Ext.data.JsonStore({
			//Update By Niucaicai 2011-08-11  加载超时限制3分钟
			proxy : new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL,
				timeout:180000    
			})),
	        //url : queryUrl,
	        baseParams : parameters,
	        root:"record",
	        totalProperty:"total",
	        fields: fns
   		});
		var gridss = BuildGrid(cm,ds,gridTitle);
		return gridss;
	}
	
	var btnExport = new Ext.Button({
		//id : 'btnExport',
		text: '导出EXCEL'
	});
	
	var BuildGrid = function(cm,ds,gridTitle){
		var grid = new Ext.grid.GridPanel({
			//id:"gridResult",  //Update By NiuCaicai FixBug:100 实施管理--在院患者统计-排序后点击【首页】返回，显示不正常
			title:gridTitle,
			loadMask : true,
			cm:cm,
			ds:ds,
			viewConfig: {
				forceFit:true,
				getRowClass : function(record,rowIndex,rowParams,store){
				   if(record.get('InPathWayNum')){
						if(record.get('InPathWayNum')!=0){
								return 'x-grid-record'
						}
				   }
				}
			},
			listeners : {
				'rowdblclick': function(){
					rowDblClick(this);
				}
			}
		});
		return grid;
	}
	
	btnExport.on("click", function(){
		if (!obj.CurrentGrid) return;
		
		var strFileName="在院患者入径情况统计";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.CurrentGrid,strFileName);
	}, obj);
}
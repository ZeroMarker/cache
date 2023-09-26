(function(){
	Ext.ns("dhcwl.BDQ.ShowBDQData");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.ShowBDQData=function(pObj){
	var serviceUrl="dhcwl/basedataquery/dataqrycfg.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptName="";
	var rptID="";
	var qryParam=new Object();
	var curRptID="";
	
    var reader = new Ext.data.ArrayReader({}, [
           {name: 'name'},
           {name: 'descript'},
		   {name:'inPam'},
		   {name:'itemCls'}
    ]);
	
    var cfgStore = new Ext.data.GroupingStore({
		autoDestroy: true,
        reader:reader,
		groupField:'itemCls'
    });	
	
	var cfgCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '描述',
			id:'descript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'descript',
            width: 150
        }, {
            header: '入参',
            dataIndex: 'inPam',
            width: 50
        }, {
            header: '类型',
            dataIndex: 'itemCls',
            width: 80
        }]
	})	

    var cfgGrid = new Ext.grid.GridPanel({
        //height:480,
		//layout:'fit',
        store: cfgStore,
        cm: cfgCm,
		autoExpandColumn: 'descript',
        view: new Ext.grid.GroupingView({
            forceFit:true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        })
    });	
	
	var showDBQPanel=new Ext.Panel({
		title:'展示查询数据',
		layout:'border',	
		defaults: {
		    split: true
		},
		closable:true,
		items: [
		{
			title:'配置',
	        region:'east',
	        border: false,
	        split:true,
			collapsible: true,
            margins: '0 0 0 5',
	        width: 275,
	        minSize: 100,
	        maxSize: 500,
			layout:'fit',
			items: cfgGrid
		},		
		{
		    region:'center',
		    layout:'fit',
		    //items:,
			id:'viewPanelID',
			tbar:new Ext.Toolbar({
				layout: 'hbox',
				items : [		
				{
					text: '加载',
					icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/add.gif'	,
					handler:OnLoadRptCfg
				}//,"->"
				,{
					xtype:'spacer',
					flex:1
				},"日期范围",
				{
					xtype: 'datefield',
					name : 'startDate',
					id : 'BDQStartDate',
					format:GetWebsysDateFormat()
				},{
					xtype: 'displayfield',
					value : '-'
				},{
					xtype: 'datefield',
					name : 'endDate',
					id : 'BDQEndDate',
					format:GetWebsysDateFormat()
				},{
					text: '查询',
					icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/refresh.gif'	,
					handler:OnQueryDBQData
				},{
					xtype:'spacer',
					flex:1
				},{
					text: '导出说明',
					icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/folder_page.gif'	,
					handler:OnExpDBQData					
				}]	
				/*
				layout: 'hbox',
				items : [		
				'查找：',
				{
					id:'searchCond',
					width: 100,
					xtype:'combo',
					mode:'local',
					emptyText:'请选择搜索类型',
					triggerAction:  'all',
					forceSelection: true,
					editable: true,
					displayField:'value',
					valueField:'name',
					store:new Ext.data.JsonStore({
						fields:['name', 'value'],
						data:[
							{name : 'name',   value: '名称'},
							{name : 'descript',  value: '描述'},
							{name : 'type', value: '类型'},
							{name : 'dataType',  value: '数据类型'},
							{name : 'linkedSHMURI', value: '关联模型'},
							{name : 'sourceField', value: '源表字段'}
						]}),
						listeners:{
							'select':function(combo){
								itemSearchCond=combo.getValue();
							}
						}				
				},
				{
					xtype: 'textfield',
					//width:300,
					flex : 1,
					id:'itemSearch',
					enableKeyEvents: true,
					allowBlank: true,
					listeners :{
						'keypress':function(ele,event){
							if ((event.getKey() == event.ENTER)){
								var searchValue=Ext.getCmp("itemSearch").getValue();
								itemStore.reload({params:{itemSearchCond:itemSearchCond,searchValue:searchValue,treeID:curSelNodeID}});
							}
						}
					}
				}]
				
				
				*/
			})	
		}]
		
    });

	function OnLoadRptCfg() {
		var saveWin=new dhcwl.BDQ.SaveAsWin(outThis);

		var initAttrib=new Object();
		initAttrib.rptType="";
		//initAttrib.usedFor="load";
		initAttrib.usedFor="exec";
		//initAttrib.curRptName=rptName;
		saveWin.initAttrib(initAttrib);

		
		saveWin.initForLoad();
		saveWin.onLoadCallback=LoadRpt;
		saveWin.show();			
	}
	
	function LoadRpt(outRptName,outRptID) {


		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:"getLoadRptCfgData",
			rptName:outRptName,
			rptID:outRptID
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok" && jsonData.MSG=='SUCESS'){
				rptName=outRptName;
				rptID=outRptID;				
				updateGrids(jsonData.cfgData);

				//SummaryDataQryCfgPanel.setTitle("交叉表格显示——"+rptName);
				//CloseWins();
				
				
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);
	}
	
    this.getShowDBQPanel=function(){
    	return showDBQPanel;
    }  

	function updateGrids(cfgData) {
		cfgStore.removeAll();
		initQryParam();

		
		var curDate=dhcwl.mkpi.Util.nowDate();
		Ext.getCmp("BDQStartDate").setValue(curDate);
		Ext.getCmp("BDQEndDate").setValue(curDate);	

		
		var insData = {
			name: rptName,
			descript: "当前配置:"+rptName,
			itemCls:"总览"
		};	
		qryParam.rptName=rptName;
			
		var p = new cfgStore.recordType(insData); // create new record
		var pos=cfgStore.getCount();
		cfgStore.insert(pos, p); 			
		
		var baseObjName=cfgData.baseObjName;
		var insData = {
			name: baseObjName,
			descript: "查询对象:"+baseObjName,
			itemCls:"总览"
		};	
			
		var p = new cfgStore.recordType(insData); // create new record
		var pos=cfgStore.getCount();
		cfgStore.insert(pos, p); 	
		qryParam.qryObjName=baseObjName;

		insData = {
			name: cfgData.DateItemName,
			descript: "日期字段:"+cfgData.DateItemName,
			itemCls:"总览"
		};	
		var p = new cfgStore.recordType(insData); // create new record
		var pos=cfgStore.getCount();
		cfgStore.insert(pos, p); 
		qryParam.daterangeItem=cfgData.DateItemName;

		var rptType="网格/分组";
		if (cfgData.rptType=="corssRpt") {
			rptType="交叉";
		}
		insData = {
			name: cfgData.rptType,
			descript: "展示类型:"+rptType,
			itemCls:"总览"
		};	
		qryParam.rptType=cfgData.rptType;
		
		var p = new cfgStore.recordType(insData); // create new record
		var pos=cfgStore.getCount();
		cfgStore.insert(pos, p); 
		
		if (cfgData.rptType=="grpRpt") {
			var isAggregat="否";
			if (cfgData.IsAggregat=="1") isAggregat="是";
			insData = {
				name: cfgData.IsAggregat,
				descript: "是否聚合:"+isAggregat,
				itemCls:"总览"
			};	
			var p = new cfgStore.recordType(insData); // create new record
			var pos=cfgStore.getCount();
			cfgStore.insert(pos, p); 			
			qryParam.isAggregat=cfgData.IsAggregat;
		}

		
		aryRptsub=cfgData.rptsub;
		
		for(var i=0;i<aryRptsub.length;i++)
		{
			
			var item=aryRptsub[i].item;
			id=item.split("(")[0];
			var len=id.split("->").length;
			var name=id.split("->")[len-1];
			
			var descript=aryRptsub[i].descript;

			var insData = {
				name: name,
				descript: descript
				//inPam:inPam
			};			
			
			if(aryRptsub[i].type=="row") {
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				insData.itemCls="行显示";
				var p = new cfgStore.recordType(insData); // create new record
				var pos=cfgStore.getCount();
				cfgStore.insert(pos, p); 	
				if (qryParam.paramRows!="") {
					qryParam.paramRows=qryParam.paramRows+",";
					qryParam.inPamRows=qryParam.inPamRows+",";
				}
				qryParam.paramRows=qryParam.paramRows+id;
				qryParam.inPamRows=qryParam.inPamRows+inPam;
			}
			if(aryRptsub[i].type=="col") {
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				insData.itemCls="列显示";
				var p = new cfgStore.recordType(insData); // create new record
				var pos=cfgStore.getCount();
				cfgStore.insert(pos, p); 	

				if (qryParam.paramCols!="") {
					qryParam.paramCols=qryParam.paramCols+",";
					qryParam.inPamCols=qryParam.inPamCols+",";
					qryParam.paramColsDesc=qryParam.paramColsDesc+",";
				}
				qryParam.paramCols=qryParam.paramCols+id;
				qryParam.inPamCols=qryParam.inPamCols+inPam;	
				qryParam.paramColsDesc=qryParam.paramColsDesc+descript;				
			}			

			if(aryRptsub[i].type=="measure") {
				insData.itemCls="度量";				
				var p = new cfgStore.recordType(insData); // create new record
				var pos=cfgStore.getCount()
				cfgStore.insert(pos, p); 	

				if (qryParam.paramMeasure!="") {
					qryParam.paramMeasure=qryParam.paramMeasure+",";
					qryParam.paramMeasureDesc=qryParam.paramMeasureDesc+",";
				}
				qryParam.paramMeasure=qryParam.paramMeasure+id;
				qryParam.paramMeasureDesc=qryParam.paramMeasureDesc+descript;				
			}
			
			if(aryRptsub[i].type=="filter") {
				insData.itemCls="过滤条件";	
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				//insData.logicalOperators=item.split("^")[1];
				//insData.filterV=item.split("^")[2];
				insData.descript=descript+" "+item.split("^")[1]+" "+item.split("^")[2];
				var p = new cfgStore.recordType(insData); // create new record
				var pos=cfgStore.getCount()
				cfgStore.insert(pos, p); 	

				if (qryParam.filterIDs!="") {
					qryParam.filterIDs=qryParam.filterIDs+",";
					qryParam.filterOperas=qryParam.filterOperas+",";
					qryParam.filterValues=qryParam.filterValues+",";
					qryParam.inPamfilter=qryParam.inPamfilter+",";
				}
				qryParam.filterIDs=qryParam.filterIDs+id;
				qryParam.filterOperas=qryParam.filterOperas+item.split("^")[1];
				qryParam.filterValues=qryParam.filterValues+item.split("^")[2];
				qryParam.inPamfilter=qryParam.inPamfilter+inPam;	
			}
		}
		
		if (rptID!="curRptID") {
			if (cfgData.rptType=="corssRpt") {
				rebuildcorssRpt();	
			}else{
				//rebuildGrpRptStoreAndCol();	//暂时注释，不用删除,功能：使用extjs显示数据
				rebuildDetailRpt();
			}
		}

	}

	function initQryParam() {
		qryParam.qryObjName="";
		qryParam.paramRows="";
		qryParam.inPamRows="";
		qryParam.paramCols="";
		qryParam.paramColsDesc="";
		qryParam.inPamCols="";
		qryParam.paramMeasure="";
		qryParam.paramMeasureDesc="";
		qryParam.daterangeItem="";
		qryParam.startDate="";
		qryParam.endDate="";
		qryParam.filterIDs="";
		qryParam.filterOperas="";
		qryParam.filterValues="";
		qryParam.inPamfilter="";	
		qryParam.isAggregat="";	
		qryParam.rptType="";	
		qryParam.rptName="";
	}
	
	function rebuildGrpRptStoreAndCol() {
		var aryColCfg=new Array();
		var fields=new Array();
		var paramCols="";
		var inPamCols="";
		
		var aryCols=qryParam.paramCols.split(",");
		var aryColsDesc=qryParam.paramColsDesc.split(",");
		for(var i=0;i<aryCols.length;i++)
		{
			var header=aryColsDesc[i];
			var field={name:aryCols[i]};
			fields.push(field);	//重建store中的field
			
			//重建ColumnModel中的Column
			var col=new Ext.grid.Column({
							header: header,
							dataIndex: aryCols[i],
							width: 100
				});
			aryColCfg.push(col);	
		}
		
		var preDetailViewStore = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url:serviceUrl+'?action=getPreviewData&start=0&limit=50',
				listeners:{
					'exception':function(proxy,type,action,options,response,arg ){
						showDBQPanel.body.unmask();
						try {
							jsonData = Ext.util.JSON.decode(response.responseText);
							Ext.Msg.alert("提示",jsonData.MSG);
						} catch (e) {
							Ext.Msg.show({
										title : '错误',
										msg : "处理响应数据失败！响应数据为：\n"
												+ (response.responseText),
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							return;
						}					
					},
					'load':function(store,records,options) {
						showDBQPanel.body.unmask();
					}
				}					

			}),
			reader: new Ext.data.JsonReader({
				totalProperty: 'totalNum',
				root: 'root',
				fields:fields
			})
		})		
		
		
		var preDetailViewColumnModel = new Ext.grid.ColumnModel([
			{header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true
			},{header:'名称',dataIndex:'Name',sortable:true, width: 160, sortable: true,menuDisabled : true
			},{header:'描述',dataIndex:'Descript', width: 160, sortable: true,menuDisabled : true
			}
		]);
		var preDetailViewGrid = new Ext.grid.GridPanel({
			//height:480,
			title:'查询结果',
			store: preDetailViewStore,
			cm: preDetailViewColumnModel,
			bbar: new Ext.PagingToolbar({
				pageSize:50,
				store:preDetailViewStore,
				displayInfo:true,
				displayMsg:'{0}~{1}条,共 {2} 条',
				emptyMsg:'sorry,data not found!'
			})
		});		
	
			//重建ColumnModel中的Column
		preDetailViewGrid.getColumnModel().setConfig( aryColCfg) ;
	
		var gridContainer=Ext.getCmp("viewPanelID");
		gridContainer.removeAll();
		gridContainer.add(preDetailViewGrid);
		gridContainer.doLayout();
		
	}
	
	function rebuildcorssRpt() {
		var gridContainer=Ext.getCmp("viewPanelID");
		gridContainer.removeAll();
		gridContainer.add(
		{
			title: '查询结果',
			id:'runqianRpt',    
			frameName: 'runqianRpt',
			html: '<iframe id="runqianRpt" width=100% height=100% src="dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQry2.raq"></iframe>'	
			,autoScroll: true			
		})		
		gridContainer.doLayout(); 
		//var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		//iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQry.raq' ;		
	}
	
	function rebuildDetailRpt(){
		var gridContainer=Ext.getCmp("viewPanelID");
		gridContainer.removeAll();
		gridContainer.add(
		{
			title: '查询结果',
			id:'runqianRpt',    
			frameName: 'runqianRpt',
			html: '<iframe id="runqianRpt" width=100% height=100% src="dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQryDetail2.raq"></iframe>'	
			,autoScroll: true			
		})		
		gridContainer.doLayout(); 		
	}
	
	function OnQueryDBQData() {
		//if (qryParam.rptType=="grpRpt") qryGrpRptData();	先注释，不要删除；使用extjs输出
		if (qryParam.rptType=="grpRpt") qryDetailRptData();
		else qryCorssRptData();
		
	}
	
	function qryDetailRptData() {
		var gridContainer=Ext.getCmp("viewPanelID");
		
		var startDate=Ext.getCmp("BDQStartDate").getValue().format('Y-m-d');
		var endDate=Ext.getCmp("BDQEndDate").getValue().format('Y-m-d');
		
		var strParams="&rptID="+rptID+"&daterangeStart="+startDate+"&daterangeEnd="+endDate;				
		var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQryDetail2.raq'+strParams ;		
		
		
		
		/*
		var qryType="detail"
		if (qryParam.isAggregat=="1") qryType="aggregat";
		
		var startDate=Ext.getCmp("BDQStartDate").getValue().format('Y-m-d');
		var endDate=Ext.getCmp("BDQEndDate").getValue().format('Y-m-d');
		
		var strParams='&qryObjName='+qryParam.qryObjName+'&paramCols='+qryParam.paramCols;
		strParams=strParams+'&inPamCols='+qryParam.inPamCols+'&daterangeItem='+qryParam.daterangeItem+'&daterangeStart='+startDate+'&daterangeEnd='+endDate+'&rptName='+rptName;
		strParams=strParams+'&filterIDs='+qryParam.filterIDs+'&filterOperas='+qryParam.filterOperas+'&filterValues='+qryParam.filterValues+'&inPamfilter='+qryParam.inPamfilter+'&qryType='+qryType;		
		//src = encodeURI('dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQryDetail.raq'+strParams );	
		var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQryDetail.raq'+encodeURI(strParams) ;		
		*/
		
	}
	
	

	function qryCorssRptData() {
		/*
		var gridContainer=Ext.getCmp("viewPanelID");
		var startDate=Ext.getCmp("BDQStartDate").getValue().format('Y-m-d');
		var endDate=Ext.getCmp("BDQEndDate").getValue().format('Y-m-d');
		
		var qryObjName=qryParam.qryObjName;
		var paramRows=qryParam.paramRows;
		var inPamRows=qryParam.inPamRows;
		var paramCols=qryParam.paramCols;
		var inPamCols=qryParam.inPamCols;
		var paramMeasure=qryParam.paramMeasure;
		var paramMeasureDesc=qryParam.paramMeasureDesc;
		var dateItem=qryParam.daterangeItem;
		var filterIDs=qryParam.filterIDs;
		var filterOperas=qryParam.filterOperas;
		var filterValues=qryParam.filterValues;
		var inPamfilter=qryParam.inPamfilter;
		
		var strParams='&qryObjName='+qryObjName+'&paramRows='+paramRows+'&inPamRows='+inPamRows+'&paramCols='+paramCols;
		strParams=strParams+'&inPamCols='+inPamCols+'&paramMeasure='+paramMeasure+'&paramMeasureDesc='+paramMeasureDesc+'&daterangeItem='+dateItem+'&daterangeStart='+startDate+'&daterangeEnd='+endDate+'&rptName='+rptName;
		strParams=strParams+'&filterIDs='+filterIDs+'&filterOperas='+filterOperas+'&filterValues='+filterValues+'&inPamfilter='+inPamfilter;
		
		var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQry.raq'+strParams ;	
*/
		var gridContainer=Ext.getCmp("viewPanelID");
		
		var startDate=Ext.getCmp("BDQStartDate").getValue().format('Y-m-d');
		var endDate=Ext.getCmp("BDQEndDate").getValue().format('Y-m-d');
		
		var strParams="&rptID="+rptID+"&daterangeStart="+startDate+"&daterangeEnd="+endDate;				
		var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQry2.raq'+strParams ;		
				
	}
	
	function qryGrpRptData() {
	
		preDetailViewGrid=Ext.getCmp("viewPanelID").get(0);
		preDetailViewGrid.getStore().setBaseParam("qryObjName",qryParam.qryObjName);		//查询对象
		preDetailViewGrid.getStore().setBaseParam("paramCols",qryParam.paramCols);		//统计项
		preDetailViewGrid.getStore().setBaseParam("inPamCols",qryParam.inPamCols);
		
		preDetailViewGrid.getStore().setBaseParam("action","previewDetailData");

		preDetailViewGrid.getStore().setBaseParam("daterangeItem",qryParam.daterangeItem);			//查询日期字段
		//var startDate=Ext.getCmp("BDQStartDate").getRawValue();
		//var endDate=Ext.getCmp("BDQEndDate").getRawValue();	
		var startDate=Ext.getCmp("BDQStartDate").getValue().format('Y-m-d');
		var endDate=Ext.getCmp("BDQEndDate").getValue().format('Y-m-d');
		preDetailViewGrid.getStore().setBaseParam("daterangeStart",startDate);			//查询日期开始
		preDetailViewGrid.getStore().setBaseParam("daterangeEnd",endDate);			//查询日期结束
		
		
		preDetailViewGrid.getStore().setBaseParam("filterIDs",qryParam.filterIDs);			//过滤项标识
		preDetailViewGrid.getStore().setBaseParam("filterOperas",qryParam.filterOperas);		//过滤项操作费
		preDetailViewGrid.getStore().setBaseParam("filterValues",qryParam.filterValues);		//过滤值		
		preDetailViewGrid.getStore().setBaseParam("inPamfilter",qryParam.inPamfilter);
		var qryType="detail"
		if (qryParam.isAggregat=="1") qryType="aggregat";
		preDetailViewGrid.getStore().setBaseParam("qryType",qryType);
		preDetailViewGrid.getStore().removeAll();
		preDetailViewGrid.getStore().reload({params:{start:0,limit:50}});
		showDBQPanel.body.mask("正在读取数据，请稍候！");
	}
	
	function OnExpDBQData() {
		//rptName
			var htmlStr='<h2>1、导出为txt文件</h2>';
			htmlStr=htmlStr+'<p>打开terminal，切换到"dhc-app"名字空间.</p>';
			var epRptName="配置名称";
			if (rptName!="") epRptName=rptName;
			var epStartDate="开始日期";
			var epEndDate="结束日期";
			var startDate=Ext.getCmp("BDQStartDate").getRawValue();
			if (startDate!="") epStartDate=startDate;
			
			var endDate=Ext.getCmp("BDQEndDate").getRawValue();	
			if (endDate!="") epEndDate=endDate;
			
			
			htmlStr=htmlStr+'<p>在terminal中执行方法：<b>d ##CLASS(DHCWL.BaseDataQuery.Interface).ExtBDQDataToTxtFile("'+epRptName+'","'+epStartDate+'","'+epEndDate+'","文件路径")</b></p>';
			//htmlStr=htmlStr+'<p>"开始日期"，"结束日期"，"文件路径" 替换成实际值。执行成功后，会在指定路径下生成txt文件。  </p>';
			
			htmlStr=htmlStr+'<p>&nbsp&nbsp&nbsp&nbsp执行成功后，会在指定路径下生成txt文件。  </p>';
			/*
			htmlStr=htmlStr+'<h2>2、导出为%ListOfObjects对象</h2>';
			htmlStr=htmlStr+'<p>打开stdio，切换到"dhc-app"名字空间.</p>';
			htmlStr=htmlStr+'<p>在代码中使用方法：<b>s datalist=##CLASS(DHCWL.BaseDataQuery.Interface).ExtBDQDataToGlobal("'+epRptName+'","'+epStartDate+'","'+epEndDate+'")</b></p>';
			htmlStr=htmlStr+'<p>&nbsp&nbsp&nbsp&nbsp执行成功后，会返回%ListOfObjects对象。 </p>';
			*/
            win = new Ext.Window({
				title:'导出说明',
                width:500,
                height:350,
				layout:'fit',
                plain: true,

                items: new Ext.Panel({
                    border:false,
					html:htmlStr
                })
            });		
			win.show();
		
	}
}


(function(){
	//Ext.ns("dhcwl.mkpi.KpiDimCfg");
	Ext.ns("dhcwl.mkpi.KpiDatasetCfg");
})();

dhcwl.mkpi.KpiDatasetCfg=function(){
	     //Ext.QuickTips.init();
var outThis=this;
var menuAct="";
var searchCriteria="";
var mmSEDateCfgObj=null;
var selectedDSCodes=[];
var dhcwl_mkpi_previewKpiData=null;


var quickMenu=new Ext.menu.Menu({
	//autoWidth:true,
	boxMinWidth:140,
	ignoreParentClicks:true,
	items:[
		{
			text:'生成数据',
			handler:function(cmp,event){
				menuAct="produceData";
				Ext.MessageBox.confirm('提示框','请避免在操作高峰期使用该功能,确定要生成数据么？',function(btn){
	 				if(btn=='yes'){
	 					onKPIHandle();
	 				}
	 			});
				//onKPIHandle();
			}
		},{
			text:'清除数据',
			handler:function(){
	 			menuAct="cleanData";	
	 			onKPIHandle();    			
			}
		},{
			text:'重生数据',
			handler:function(){
	 			menuAct="reproduceData";
	 			Ext.MessageBox.confirm('提示框','请避免在操作高峰期使用该功能,确定要重生数据么？',function(btn){
	 				if(btn=='yes'){
	 					onKPIHandle();
	 				}
	 			});
	 			//onKPIHandle();     			
			}
		},{
			text:'数据指标展示',
			handler:function(){
				moduleKpiShow();
			}
		},{
			text:'预览数据',
			handler:function(){

				
				var selRow=datasetGrid.getSelectionModel().getSelected();
				if (!selRow) {
					Ext.MessageBox.alert("提示","请先选择数据集！");
					return;
				}
				var recs=datasetGrid.getSelectionModel().getSelections();
				if(recs.length>1){
					Ext.MessageBox.alert("提示","请选择单个数据集！");
					return;
				}
				if(recs[0].get("RptCfg_Code")==""){
					Ext.MessageBox.alert("提示","请选择有效数据集！");
					return;			
				}					
				
				
				
				
				
				var selectKpiRec=[];
		        var s = datasetGrid.getSelectionModel().getSelections();
		        if(s.length==0) {
		        	Ext.MessageBox.alert("提示","请先选择要操作的数据集！");
		        	return;
		        }
		        var i=0;
		        var j=0;
		        var rules="";
		        //var filter="";
		        for(var i = 0, r; r = s[i]; i++){
		        	var ruleList=r.get("DatasetCfg_RuleList");
		        	//var filterList=r.get("DatasetCfg_FilterList");
		        	if (ruleList=="") continue;
		        	if (rules!="") rules=rules+",";
		        	rules=rules+ruleList;
		        	//if (filter!="") filter=filter+",";
		        	//filter=filter+filterList;
		        	selectKpiRec[j]={"kpiCode":ruleList,"kpiName":"","category":"","section":""};
		        	j++;
		        }	
		        r=s[0];
		        var filterList=r.get("DatasetCfg_FilterList");
		        if(rules=="") {
		        	Ext.MessageBox.alert("提示","取数规则为空，无法预览数据！");
		        	return;		        	
		        }
		        	        
				//if(!dhcwl_mkpi_previewKpiData){
					dhcwl_mkpi_previewKpiData=new dhcwl.mkpi.ViewKpiData();
				//}
				//dhcwl_mkpi_previewKpiData.setSelectedKpis(selectKpiRec);
				dhcwl_mkpi_previewKpiData.setKpiRule("",rules);
				dhcwl_mkpi_previewKpiData.setKpiFilter("",filterList);
				dhcwl_mkpi_previewKpiData.showWin();

    			}
		}/*,{
			text:'预览数据2',
			handler:function(){
				dhcwl_mkpi_KpiPreViewFrame=new dhcwl.mkpi.KpiPreViewFrame();
				dhcwl_mkpi_KpiPreViewFrame.showWin();

    			}
		}*/
		,'-',    		
    		{
    			text:'指标任务开关',
    			menu:{
    				boxMinWidth:130,
    				items:[
		    			{
		    				text:'激活区间任务',
		    				handler:onActivateKPITask
		    			},{
		    				text:'停止区间任务',
		    				handler:onStopKPITask
		    			}
		    		]
    			
    			}    			
    		}
		]
});	



var serviceUrl='dhcwl/kpi/kpidatasetcfgdata.csp';

var sm = new Ext.grid.CheckboxSelectionModel();	

sm.on('rowselect',function(sm, row, rec){
	var code=rec.get("DatasetCfg_Code");
	if(!code||code=="") return;
	for(var i=selectedDSCodes.length-1;i>-1;i--){
		if(selectedDSCodes[i]==code)
			return;
	}
	selectedDSCodes.push(code);
	//alert(selectedKpiIds.join(","));
});


sm.on('rowdeselect',function(sm, row, rec){
	var code=rec.get("DatasetCfg_Code"),len=selectedDSCodes.length;
	for(var i=0;i<len;i++){
		if(selectedDSCodes[i]==code){
			for(var j=i;j<len;j++){
				selectedDSCodes[j]=selectedDSCodes[j+1];
				//selectKpiObj[rec.get("kpiCode")]=rec.get("kpiName");
			}
			selectedDSCodes.length=len-1;
			break;
		}
	}
});


var proxy = new Ext.data.HttpProxy({
    url: 'dhcwl/kpi/kpidatasetcfgdata.csp?action=getNode'
});

var reader = new Ext.data.JsonReader({
    totalProperty: 'totalNum',
    root: 'root'      	
}, [
    {name: 'DatasetCfg_RowID',type: 'string'},
    {name: 'DatasetCfg_Code',type: 'string', allowBlank: false},
    {name: 'DatasetCfg_Desc',type: 'string', allowBlank: true},
    {name: 'DatasetCfg_RuleList',type: 'string', allowBlank: true},
    {name: 'DatasetCfg_FilterList',type: 'string', allowBlank: true},
    {name: 'DatasetCfg_RptCode', type: 'string', allowBlank: false},    
    {name: 'DatasetCfg_TreeCode',type: 'string', allowBlank: false}
]);

var editor = new Ext.ux.grid.RowEditor({
    saveText: '保存',
    cancelText: '取消',
    clicksToEdit:2
});
    
var store = new Ext.data.Store({
    id: 'storeDimCfg',
    proxy: proxy,
    reader: reader
});

var columns =  [
	new Ext.grid.RowNumberer(),
	 sm,
    {header: "RowID", width: 30, sortable: true,menuDisabled : true, dataIndex: 'DatasetCfg_RowID',id: 'DatasetCfg_RowID', editor: {
                xtype: 'textfield',
                disabled: true,
                allowBlank: true
             }},
    {header: "编码", width: 30, sortable: true,menuDisabled : true, dataIndex: 'DatasetCfg_Code',id: 'DatasetCfg_Code', editor: {
                xtype: 'textfield',
                allowBlank: true
             }},
    {header: "描述", width: 30, sortable: true,menuDisabled : true, dataIndex: 'DatasetCfg_Desc',id: 'DatasetCfg_Desc', editor: {
                xtype: 'textfield',
                allowBlank: true
             }},             
    {header: "取数规则", width: 150, sortable: true,menuDisabled : true, dataIndex: 'DatasetCfg_RuleList',id: 'DatasetCfg_RuleList', editor: {
                xtype: 'textfield',
                disabled: true,
                allowBlank: true
             }},
    {header: "过滤规则", width: 150, sortable: true,menuDisabled : true, dataIndex: 'DatasetCfg_FilterList',id: 'DatasetCfg_FilterList', editor: {
                xtype: 'textfield',
                disabled: true,
                allowBlank: true
             }}
];

     var datasetGrid = new Ext.grid.GridPanel({
         id:'datasetCfgPanel',
         iconCls: 'icon-grid',
         height: 275,
        store: store,
        autoExpandColumn: 'DatasetCfg_Desc',
        plugins: [editor],
        columns : columns,
       sm: sm, 
       bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
	        	'change':function(pt,page){
					var code="";
					selRptLen=selectedDSCodes.length;
					var AllRowCnt=store.getCount();
					var selRowCnt=0;					
					for(var i=store.getCount()-1;i>-1;i--){
						code=store.getAt(i).get("DatasetCfg_Code");
						found=false;
						for(j=selRptLen-1;j>-1;j--){
							if(selectedDSCodes[j]==code) found=true;
						}
						if(found){
							sm.selectRow(i,true,false);
							selRowCnt++;
						}
					}
							
					
					
					var hd_checker = datasetGrid.getEl().select('div.x-grid3-hd-checker');
			    	var hd = hd_checker.first();
			    	if(hd!=null ){
			    	    if(AllRowCnt!=selRowCnt && hd.hasClass('x-grid3-hd-checker-on')){
			    	    	hd.removeClass('x-grid3-hd-checker-on');
				    	}else if(AllRowCnt==selRowCnt && !hd.hasClass('x-grid3-hd-checker-on'))
				    	{
				    		hd.addClass('x-grid3-hd-checker-on');
				    	}
			    	}					
				}
            }
        }),                
        tbar: [{
            //text: '新增数据集',
            text: '<span style="line-Height:1">新增数据集</span>',
            icon: '../images/uiimages/edit_add.png',
            iconCls: 'silk-add',
            handler: onAdd
        }, '-', {
            //text: '配置取数规则',
            text: '<span style="line-Height:1">配置取数规则</span>',
            icon: '../images/uiimages/config.png',
            handler: onConfig
        }, '-', {
        	//text:'配置过滤规则',
        	text: '<span style="line-Height:1">配置过滤规则</span>',
        	 icon: '../images/uiimages/config.png',
        	handler:onFilterConfig
        }, '-', {
            ref: '../removeBtn',
            //text: '删除',
            text: '<span style="line-Height:1">删除</span>',
            icon: '../images/uiimages/edit_remove.png',
            iconCls: 'silk-delete',
            disabled: true,
            handler: onDelete
        }],
        viewConfig: {
        	markDirty: false,
            forceFit: true
        }
    });

    
	datasetGrid.getSelectionModel().on('selectionchange', function(sm){
        	datasetGrid.removeBtn.setDisabled(sm.getCount() < 1);
    	});    
    store.load({params:{start:0,limit:10}});
    /**
     * onAdd
     */
	store.on('update',onUpdate,this);
	
	datasetGrid.on('contextmenu',function( e ){
			e.preventDefault();
			quickMenu.showAt(e.getXY());
	})
    function onAdd(btn, ev) {
    	//add by wz.2013-11-27
    	editor.stopEditing();
    	
		var rptCfgPanel=Ext.getCmp('rptCfgGridPanel');
		var isSel=rptCfgPanel.getSelectionModel().getSelected();
		if (!isSel) {
			Ext.MessageBox.alert("提示","请先选择报表！");
			return;
		}
		var recs=rptCfgPanel.getSelectionModel().getSelections();
		if(recs.length>1){
			Ext.MessageBox.alert("提示","请选择单个报表！");
			return;
		}
		if(recs[0].get("RptCfg_Code")==""){
			Ext.MessageBox.alert("提示","请选择有效报表！");
			return;			
		}
		//record = g.store.getAt(rowIndex);
        var e = new Ext.data.Record({
            DatasetCfg_RowID: '',
            DatasetCfg_Code: '',
            DatasetCfg_Desc: '',
            DatasetCfg_RuleList: '',
            DatasetCfg_RptCode: recs[0].get("RptCfg_Code"),            
            DatasetCfg_TreeCode:recs[0].get("RptCfg_TreeCode")
        });				

		
		store.insert(0, e);
		datasetGrid.getView().refresh();
		datasetGrid.getSelectionModel().selectRow(0);
		editor.startEditing(0);

    }
    function onFilterConfig(btn,ev){
    	var selRow=datasetGrid.getSelectionModel().getSelected();
    	if (!selRow) {
			Ext.MessageBox.alert("提示","请先选择数据集！");
			return;
		}
		var recs=datasetGrid.getSelectionModel().getSelections();
		if(recs.length>1){
			Ext.MessageBox.alert("提示","请选择单个数据集！");
			return;
		}
		if(recs[0].get("RptCfg_Code")==""){
			Ext.MessageBox.alert("提示","请选择有效数据集！");
			return;			
		}
		var selectedFilters=[];
		if(recs[0].get("DatasetCfg_FilterList")!=""){
			//selectedKpis=GetKpiAryByRuleList(recs[0].get("DatasetCfg_RuleList"));
			selectedFilters=recs[0].get("DatasetCfg_FilterList");
		}
		var setFilterWin=new dhcwl.mkpi.showkpidata.SetFilterRule();
		//setFilterWin.setFilterCode(selectedFilters);
		var selectedKpiRule = recs[0].get("DatasetCfg_RuleList");
		var selectedKpiFilter=recs[0].get("DatasetCfg_FilterList")
		if (!!selectedKpiRule == false){
			Ext.MessageBox.alert("消息","您需要选择或填写一个指标取数规则！");
			return;
		}
		
		var url=encodeURI("dhcwl/kpi/kpidatasetcfgdata.csp?action=FilterCheck");
		dhcwl.mkpi.Util.ajaxExc(url,
			{
				kpis:selectedKpiFilter
			},
			function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					//Ext.MessageBox.alert("提示","操作成功！");
					setFilterWin.InitKpiTreePanel(selectedKpiRule,selectedKpiFilter);
					setFilterWin.setParentWin(outThis);
					setFilterWin.show();
				}else{
					Ext.MessageBox.confirm('过滤规则有错误是否继续',jsonData.infor,function(btn){
		 				if(btn=='yes'){
		 					setFilterWin.InitKpiTreePanel(selectedKpiRule,selectedKpiFilter);
							setFilterWin.setParentWin(outThis);
							setFilterWin.show();
		 				}
		 			});
					
					}
				},this);
		
		/*setFilterWin.InitKpiTreePanel(selectedKpiRule,selectedKpiFilter);
		setFilterWin.setParentWin(outThis);
		setFilterWin.show();*/
    }
    function onConfig(btn,ev){
		//var rptCfgPanel=Ext.getCmp('rptCfgGridPanel');
		var selRow=datasetGrid.getSelectionModel().getSelected();
		if (!selRow) {
			Ext.MessageBox.alert("提示","请先选择数据集！");
			return;
		}
		var recs=datasetGrid.getSelectionModel().getSelections();
		if(recs.length>1){
			Ext.MessageBox.alert("提示","请选择单个数据集！");
			return;
		}
		if(recs[0].get("RptCfg_Code")==""){
			Ext.MessageBox.alert("提示","请选择有效数据集！");
			return;			
		}
		if(recs[0].get("DatasetCfg_RowID")==""){
			Ext.MessageBox.alert("提示","请保存后再进行该操作！");
			return;			
		}
		
		var selectedKpis=[];
		if(recs[0].get("DatasetCfg_RuleList")!=""){
			//selectedKpis=GetKpiAryByRuleList(recs[0].get("DatasetCfg_RuleList"));
			selectedKpis=recs[0].get("DatasetCfg_RuleList");
		}
		var url=encodeURI("dhcwl/kpi/kpidatasetcfgdata.csp?action=RuleCheck");
		dhcwl.mkpi.Util.ajaxExc(url,
			{
				kpis:selectedKpis
			},
			function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					//Ext.MessageBox.alert("提示","操作成功！");
					var setRuleWin=new dhcwl.mkpi.showkpidata.SetKpiRule2();
					//setRuleWin.setSelectedKpiArr(selectedKpis);
					//setRuleWin.setParentWin(outThis);  
					
					setRuleWin.setSelectedKpiCode(selectedKpis);
					setRuleWin.setParentWin(outThis);
					//setRuleWin.hideToolbar();
					//setRuleWin.reconfigureKpiListPanel(aryKpiDatas);		
					setRuleWin.show();
				}else{
					Ext.MessageBox.confirm('取数规则有错误是否继续',jsonData.infor,function(btn){
		 				if(btn=='yes'){
		 					var setRuleWin=new dhcwl.mkpi.showkpidata.SetKpiRule2();
		 					setRuleWin.setSelectedKpiCode("");
		 					setRuleWin.setParentWin(outThis);
		 					setRuleWin.show();
		 				}
		 			});
					}
				},this);
		//var selectedKpis=[];
		//var setRuleWin=new dhcwl.mkpi.showkpidata.SetKpiRule2();
		//setRuleWin.setSelectedKpiArr(selectedKpis);
		//setRuleWin.setParentWin(outThis);  
		
		//setRuleWin.setSelectedKpiCode(selectedKpis);
		//setRuleWin.setParentWin(outThis);
		//setRuleWin.hideToolbar();
		//setRuleWin.reconfigureKpiListPanel(aryKpiDatas);		
		
		
		
		//setRuleWin.show();    	
    }
    /**
     * onDelete
     */
    function onDelete() {

    	Ext.MessageBox.confirm('确认', '你确定要删除数据集吗？', function(id){
                 if (id=="no") {
 	                return;               	
                 }
    	
        editor.stopEditing();
        
        var aryDatasetCodes=[];
        var aryRptCodes=[];        
        var aryTreeCodes=[];
        var s = datasetGrid.getSelectionModel().getSelections();
        for(var i = 0, r; r = s[i]; i++){
        	var dsRowID=r.get("DatasetCfg_RowID");
        	if (dsRowID!="") {
      			aryDatasetCodes.push(r.get("DatasetCfg_Code"));
        		aryRptCodes.push(r.get("DatasetCfg_RptCode"));
        		aryTreeCodes.push(r.get("DatasetCfg_TreeCode"));
        	}else{
       			store.remove(r);        		
        	}
        }      
        if(aryDatasetCodes.length<=0) return;
        
		var url=encodeURI("dhcwl/kpi/kpidatasetcfgdata.csp?action=del");
		
		var dsCodesStr=aryDatasetCodes.join(",");
		var rptCodesStr=aryRptCodes[0];		
		var treeCodeStr=aryTreeCodes[0];
		dhcwl.mkpi.Util.ajaxExc(url,
			{
				dscodes:dsCodesStr,
				rptcode:rptCodesStr,
				treecode:treeCodeStr
			},
			function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
       				for(var i = 0, r; r = s[i]; i++){	
       					store.remove(r);
					Ext.MessageBox.alert("提示","数据删除成功！");   
					selectedDSCodes=[];
					store.reload();
       				}
				}else{
					Ext.Msg.show({
									title : '更新错误',
									msg : "SQLCODE:"+jsonData.SQLCODE,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
					}
				},this);				
  
        }
        
        )    	
    	
    	/*
        var rec = datasetGrid.getSelectionModel().getSelected();
        if (!rec) {
            return false;
        }
		kpiCfgRowID=rec.get("KpiCfg_RowID");
		dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
				'action' : 'del',					
	            'KpiCfg_RowID': kpiCfgRowID
				}, function(jsonData) {
				jsonData = Ext.util.JSON.decode(jsonData);
				if(jsonData.success==true && jsonData.tip=="ok"){
					datasetGrid.store.remove(rec);
				}else{ 
						Ext.Msg.show({
									title : '新增错误',
									msg : "SQLCODE:"+jsonData.SQLCODE,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
				}
	
				}, outThis, true);		        
        */

    }
	
	


	this.getDatasetCfgPanel=function(){
		return datasetGrid;
	}
	
	//在setkpirule.js中调用
	this.SetDatasetKpiRule=function(name,rule){
		if(name=="") name=rule;
		//if(rule=="") return;

		//var kpis=rule.split(",");
		//var i=0;
	
		var selRow=datasetGrid.getSelectionModel().getSelected();
		if (!selRow) return;
		var recs=datasetGrid.getSelectionModel().getSelections();
		var rowid=recs[0].get('DatasetCfg_RowID');
		var code=recs[0].get('DatasetCfg_Code');
		//var ruleList=recs[0].get('DatasetCfg_RuleList');
		var rptcode=recs[0].get('DatasetCfg_RptCode');
		var treecode=recs[0].get('DatasetCfg_TreeCode');
		dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
				'action' : 'updateRuleList',					
	            'rowid':rowid,
				'code': code,
	            'rulelist':rule,
	            'rptcode':rptcode,
	            'treecode':treecode
	            }, function(jsonData) {
				jsonData = Ext.util.JSON.decode(jsonData);
				if(jsonData.success==true && jsonData.tip=="ok"){
					//datasetGrid.store.remove(rec);
					store.un('update',onUpdate,this);
					recs[0].set('DatasetCfg_RuleList',rule);
					store.on('update',onUpdate,this);
					Ext.MessageBox.alert("提示","取数规则保存成功！");
				}else{ 
						Ext.Msg.show({
									title : '新增错误',
									msg : "SQLCODE:"+jsonData.SQLCODE,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
				}
	
				}, outThis, true);	
		
		
		

	}
	this.SetDatasetKpiFilter=function(name,rule){
		if(name=="") name=rule;
		//if(rule=="") return;

		//var kpis=rule.split(",");
		//var i=0;
	
		var selRow=datasetGrid.getSelectionModel().getSelected();
		if (!selRow) return;
		var recs=datasetGrid.getSelectionModel().getSelections();
		var rowid=recs[0].get('DatasetCfg_RowID');
		var code=recs[0].get('DatasetCfg_Code');
		var ruleList=recs[0].get('DatasetCfg_RuleList');
		var rptcode=recs[0].get('DatasetCfg_RptCode');
		var treecode=recs[0].get('DatasetCfg_TreeCode');
		dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
				'action' : 'updateFilter',					
	            'rowid':rowid,
				'code': code,
	            'rulelist':ruleList,
	            'filter':rule,
	            'rptcode':rptcode,
	            'treecode':treecode
	            }, function(jsonData) {
				jsonData = Ext.util.JSON.decode(jsonData);
				if(jsonData.success==true && jsonData.tip=="ok"){
					//datasetGrid.store.remove(rec);
					store.un('update',onUpdate,this);
					recs[0].set('DatasetCfg_FilterList',rule);
					store.on('update',onUpdate,this);
					Ext.MessageBox.alert("提示","过滤规则保存成功！");
				}else{ 
						Ext.Msg.show({
									title : '新增错误',
									msg : "SQLCODE:"+jsonData.SQLCODE,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
				}
	
				}, outThis, true);	
		
		
		

	}
	
	
	function moduleKpiShow(){
		var selDs = datasetGrid.getSelectionModel().getSelections();
		if (selDs.length <=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的数据集！");    					
			return;
		}
		
		var dsCodes="";
		for (var i=0;i<=selDs.length-1;i++){
			if (dsCodes=="") {
				dsCodes=selDs[i].get("DatasetCfg_Code");
			}else{
				dsCodes=dsCodes+','+selDs[i].get("DatasetCfg_Code");
			}
		}
		var treeCode=selDs[0].get("DatasetCfg_TreeCode");
		var rptCode=selDs[0].get("DatasetCfg_RptCode");
		var dataSetKpiShowObj=new dhcwl.mkpi.ModuleKpiShow();
	    var dataSetSign="dataset";
	    dataSetKpiShowObj.show(treeCode,rptCode,dsCodes,dataSetSign);
	}
	
    		//修改
	
	function onUpdate(s,record,operation){
           
		var rowid=record.get("DatasetCfg_RowID");
		var code=record.get("DatasetCfg_Code");
		var RuleList=record.get("DatasetCfg_RuleList");
		var desc=record.get("DatasetCfg_Desc");
		var filter=record.get("DatasetCfg_FilterList");
		var RptCode=record.get("DatasetCfg_RptCode");
		var TreeCode=record.get("DatasetCfg_TreeCode");		
		//var editor2=editor;
		
		if (code=="") {
			Ext.MessageBox.alert("提示","数据集编码不能为空！");
			return;
		}		
		
		if (code.indexOf(".")>=0 || code.indexOf("||")>=0) {
			Ext.MessageBox.alert("提示","数据集编码不能包含字符'.'或'||'！");
			store.un('update',onUpdate,this);			
			record.set("DatasetCfg_Code","");
			store.on('update',onUpdate,this);
			return;
		}
		
		
		var storeCnt=store.getCount();
		for(var i=0;i<=storeCnt-1;i++){
			var rec=store.getAt(i);
			if (rec==record) continue;
			if(rec.get("DatasetCfg_RowID")=="") continue;
			if (rec.get("DatasetCfg_Code")==code) {
				store.un('update',onUpdate,this);
				record.set("DatasetCfg_Code","");
				Ext.MessageBox.alert("提示","数据集编码有重复，请重新输入！");
				store.on('update',onUpdate,this);
				return;
			}
		}		
		

		var url=encodeURI("dhcwl/kpi/kpidatasetcfgdata.csp?action=update&rowid="+rowid+"&code="+code+"&rulelist="+RuleList+"&filter="+filter+"&desc="+desc+"&treecode="+TreeCode+"&rptcode="+RptCode);
		 dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					if (rowid=="") {
						store.un('update',onUpdate,this);
						record.set("DatasetCfg_RowID",jsonData.ROWID);
						store.on('update',onUpdate,this);
					}
					Ext.Msg.alert("提示","更新成功！");
					store.reload();
				}else{
					refreshRptCfg();
					Ext.Msg.show({
									title : '更新错误',
									msg : "SQLCODE:"+jsonData.SQLCODE,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
					}
					
				},this);	      				
      				
      				
      				
		}

	function GetKpiAryByRuleList(rule){
		var kpis=rule.split(",");
    	
		var selectKpiRec=[];
		var kpisLen=kpis.length;
		for (i=0;i<=kpisLen-1;i++) {
			var kpiStr=kpis[i].split(":");
			var kpiCode=kpiStr[0];
			selectKpiRec[i]={"kpiCode":kpiCode,"kpiName":"","category":"","section":""};
		}
		return selectKpiRec;
	}
	
	var task_CheckDateState={
			run:CreatDateProcess,
			interval:5000
	};
	
    function CreatDateProcess(){
    	var url=encodeURI("dhcwl/kpi/kpimodulecfgdata.csp");
    	dhcwl.mkpi.Util.ajaxExc(url,
    		{
    			action:'getCreatDataInfor',
    			moduleDataFlag:moduleDataFlag
    		},
    		function(jsonData){
    			if (jsonData.success==true){
    				Ext.MessageBox.updateProgress(jsonData.number,'生成进度');
    				//Ext.MessageBox.alert("提示框","这是个提示框");
    				if(jsonData.number==1){
    					Ext.TaskMgr.stop(task_CheckDateState);
    					Ext.MessageBox.alert("提示","生成成功");
    				}
    				if(jsonData.number==-1){
    					Ext.TaskMgr.stop(task_CheckDateState);
    					Ext.MessageBox.alert("提示","生成失败");
    				}
    			}else{
    				Ext.TaskMgr.stop(task_CheckDateState);
					Ext.MessageBox.alert("提示","生成失败");
    			}
    		},this);
    	
    }
	
	this.setSearchObj=function(sObj,sAttrib,sValue){
		searchCriteria=sObj+","+sAttrib+","+sValue;	
	}

	var moduleDataFlag="";
	this.onMmDataHandle=function(startDate,endDate,kpiCodes,actFlag,dateSecType){
 		if (actFlag==-1) {	//在页面中选择了取消操作
			menuAct="";
			return;
		}
		
		var treeCode="",rptCode="";
		if(store.getCount()>0) {
			treeCode=store.getAt(store.getCount()-1).get("DatasetCfg_TreeCode");
			rptCode=store.getAt(store.getCount()-1).get("DatasetCfg_RptCode");
			
		}	
		var url=encodeURI("dhcwl/kpi/kpimodulecfgdata.csp");
		dhcwl.mkpi.Util.ajaxExc(url,
			{
				action:'mmHandleData',
				Criteria:searchCriteria,
				treeNodes:'',
				rptCodes:'',
				KPICodes:kpiCodes,
				startDate:startDate,
				menuAct:menuAct,
				endDate:endDate,
				actFrom:'dataset',
				actFlag:actFlag,
				dateSecType:dateSecType
			},
			function(jsonData){
				//Ext.getBody().unmask();    
					if(actFlag==2 ||actFlag==3) {
						if(jsonData.success==true && jsonData.tip=="ok"){
							if(menuAct=="cleanData"){
								Ext.Msg.alert("提示","操作成功！");
							}else{
								moduleDataFlag=jsonData.dataFlag
								if(actFlag==2 || actFlag==3){
									if(menuAct!="cleanData"){
										Ext.MessageBox.progress("请稍后");
										Ext.TaskMgr.start(task_CheckDateState);
									}
								}
							}
	
						}else{
							Ext.Msg.alert("提示","操作失败！");
						}
						handleKpis="";
					}
					else{
						try{
							var inputKpiList=jsonData.root;
							
							var storeCnt=mmSEDateCfgObj.getStore().getCount();
							for(var i=inputKpiList.length-1;i>=0;i--){
								for(var j=0;j<=storeCnt-1;j++){
									var r=mmSEDateCfgObj.getStore().getAt(j);
									//alert(inputKpiList[i][1]+"..:"+inputKpiList[i][2]+":"+inputKpiList[i][3]+":"+inputKpiList[i][0]+"||"+treeCode+":"+rptCode+":"+r.get("DatasetCfg_Code")+":"+r.get("KpiCfg_Code"));
									if((inputKpiList[i][1]==treeCode)
										&& inputKpiList[i][2]==rptCode
										&& inputKpiList[i][3]==r.get("DatasetCfg_Code")
										&& inputKpiList[i][0]==r.get("KpiCfg_Code")){
											inputKpiList.splice(i,i);
											break;
									}
								}
								
							}
							mmSEDateCfgObj.getCheckGrid().getStore().loadData(inputKpiList);	
							//handleKpis=jsonData.kpiCodes;
	
						}catch(e){
							Ext.Msg.alert("提示2","操作失败！");
							return;
						}										
					}
				},this);	
			//Ext.getBody().mask("数据重新加载中，请稍等");    
	}	
	
	function onKPIHandle() {
		if (mmSEDateCfgObj==null) {
			//mmSEDateCfgObj=new dhcwl.mkpi.KpiMMgrSEDateKpiCfg();
			Ext.MessageBox.alert("弹出窗口对象：dhcwl.mkpi.KpiMMgrSEDateKpiCfg有错误。");
		}
		
		var recs=datasetGrid.getSelectionModel().getSelections();
		if (recs.length <=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的数据集！");    					
			return;
		}	 			
		

		mmSEDateCfgObj.setParentPanel(outThis);
		var childStore=mmSEDateCfgObj.getStore();
		childStore.removeAll();
		

		for (var i=0;i<=recs.length-1;i++){
			var dsCode=recs[i].get("DatasetCfg_Code");
			var ruleList=recs[i].get("DatasetCfg_RuleList");
			var aryList=ruleList.split(",");
			for(var j=0;j<=aryList.length-1;j++) {
				var e = new Ext.data.Record({
		            DatasetCfg_Code: dsCode,
		            KpiCfg_Code: aryList[j].split(":")[0]
				});		
				childStore.add(e);
			}
			
		}
		
		if(menuAct=="produceData") {
			mmSEDateCfgObj.setCheckGroupHide(true);
		}
		else {
			mmSEDateCfgObj.setCheckGroupHide(false);
		}
		mmSEDateCfgObj.show(); 			
		
		if(menuAct=="cleanData") {
			mmSEDateCfgObj.setDateSecTypeHide(false);
		}
		else {
			mmSEDateCfgObj.setDateSecTypeHide(true);
		}		
	}
	
	this.setSEDateCfgObj=function(seDateCfgObj)
	{
		mmSEDateCfgObj=seDateCfgObj;
	}	
	
	function onActivateKPITask(){
		var selDs = datasetGrid.getSelectionModel().getSelections();
		if (selDs.length <=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的报表！");    					
			return;
		}
		
		var dsCodes="";
		for (var i=0;i<=selDs.length-1;i++){
			if (dsCodes=="") {
				dsCodes=selDs[i].get("DatasetCfg_Code");
			}else{
				dsCodes=dsCodes+','+selDs[i].get("DatasetCfg_Code");
			}
		}
		var treeCode=selDs[0].get("DatasetCfg_TreeCode");
		var rptCode=selDs[0].get("DatasetCfg_RptCode");
		//return;
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',{
				action:'ActivateKPITask',
				treeCodes:treeCode,
				rptNodes:rptCode,
				dsNodes:dsCodes,
				actFrom:'dataset'
			},  
			function(jsonData){
				datasetGrid.body.unmask(); 
				if(jsonData.success==true && jsonData.tip=="ok"){
					Ext.Msg.alert("提示","操作成功！");
	
				}else{
					Ext.Msg.alert("提示","操作失败！");
				}			
	
			}
			,outThis);		
		datasetGrid.body.mask("数据处理中，请稍等");  
	}
	
	function onStopKPITask(){
		var selDs = datasetGrid.getSelectionModel().getSelections();
		if (selDs.length <=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的报表！");    					
			return;
		}
		
		var dsCodes="";
		for (var i=0;i<=selDs.length-1;i++){
			if (dsCodes=="") {
				dsCodes=selDs[i].get("DatasetCfg_Code");
			}else{
				dsCodes=dsCodes+','+selDs[i].get("DatasetCfg_Code");
			}
		}
		var treeCode=selDs[0].get("DatasetCfg_TreeCode");
		var rptCode=selDs[0].get("DatasetCfg_RptCode");
		
		 var actTaskWin=new dhcwl.mkpi.showkpidata.ActivateTaskPrompt();
		 actTaskWin.setParentWin(outThis);
		 actTaskWin.setSelNodes(treeCode,rptCode,dsCodes,"dataset");
		 actTaskWin.show();
		 
	}		
}
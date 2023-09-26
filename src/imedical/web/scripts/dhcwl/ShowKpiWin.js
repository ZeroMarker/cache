(function(){
	Ext.ns("dhcwl.mkpi.ShowKpiWin");
})();
dhcwl.mkpi.ShowKpiWin=function(){
	var winOfThis=this;
	var minSec="";
	//右键菜单定义
	//Ext.QuickTips.init();		//--modify by wz .2014-4-28
	var dhcwl_mkpi_execParamWin=null;		//--add by wz.2014-12-2
	if(!dhcwl_mkpi_previewKpiData) dhcwl.mkpi.PreviewKpiData.create();
	function getPreviewKpiData(){
		if(!dhcwl_mkpi_previewKpiData){
			dhcwl_mkpi_previewKpiData=new dhcwl.mkpi.PreviewKpiData();
		}
		return dhcwl_mkpi_previewKpiData;
	}
	function getKpiDimObj(){
		if(null==dhcwl_mkpi_mantainKpiDim){
    		dhcwl_mkpi_mantainKpiDim=new dhcwl.mkpi.MaintainKpiDim("","");
    	}
    	return dhcwl_mkpi_mantainKpiDim;
	}
	
	function getKpiMeasureObj(){
		if(null==dhcwl_mkpi_mantainKpiMeasure){
    		dhcwl_mkpi_mantainKpiMeasure=new dhcwl.mkpi.MaintainKpiMeasure("","");
    	}
    	return dhcwl_mkpi_mantainKpiMeasure;
	}
    
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:210,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'维护指标维度(单选)',
    			handler:function(cmp,event){
		    				var sm = kpiGrid.getSelectionModel();
		                	if(!sm){
		                		alert("请选择一行！");
		                		return;
		                	}
		                    var record = sm.getSelected();
		                    if(!record){
		                		alert("请选择一行！");
		                		return;
		                	}
		                	//getKpiDimObj();
		                    dhcwl_mkpi_showKpiWin.setKpiDim();

    			}
    		},'-',{
    			text:'维护指标度量(单选)',
    			handler:function(cmp,event){
		    				var sm = kpiGrid.getSelectionModel();
		                	if(!sm){
		                		alert("请选择一行！");
		                		return;
		                	}
		                    var record = sm.getSelected();
		                    if(!record){
		                		alert("请选择一行！");
		                		return;
		                	}
		                	//getKpiDimObj();
		                    dhcwl_mkpi_showKpiWin.setKpiMeasure();

    			}
    		},'-',{
				text:'维护指标日志(单选)',
				handler:function(){
					var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
					var mKpiCode=record.get('kpiCode');
					var kpiWinKpiLoginInfoCfg = new dhcwl.mkpi.KpiWinKpiLoginInfoCfg(mKpiCode);
					kpiWinKpiLoginInfoCfg.showKpiLoginInfoCfgWin();
				}
			},'-',/*{
    			text:'添加到导出列表',
    			handler:function(cmp,event){
    				var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                    dhcwl_mkpi_taskIO.getOutputObj().add(record.get('kpiCode'));
    			}
    		},{
    			text:'查看导出指标列表',
    			handler:function(){
    				dhcwl_mkpi_taskIO.getOutputObj().showList();
    			}
    		},{
    			text:'清空导出指标列表',
    			handler:function(){
    				dhcwl_mkpi_taskIO.getOutputObj().clearList();
    			}
    		},*/{
    			text:'导出指标',
    			menu:{
    				boxMinWidth:130,
    				items:[
		    			{
		    				text:'导出无维度版',
		    				handler:function(){
		        				for(var i=selectedKpiIds.length-1;i>-1;i--){
		        					dhcwl_mkpi_taskIO.getOutputObj().add(selectedKpiIds[i]);
		        					//alert(selectedKpiIds[i]);
		        				}
		        				dhcwl_mkpi_taskIO.getOutputObj().ouputKpis();
		        			}
		    			},{
		    				text:'导出有维度版',
		    				handler:function(){
		        				for(var i=selectedKpiIds.length-1;i>-1;i--){
		        					dhcwl_mkpi_taskIO.getOutputObj().add(selectedKpiIds[i]);
		        					//alert(selectedKpiIds[i]);
		        				}
		        				dhcwl_mkpi_taskIO.getOutputObj().ouputKpisWithDim();
		        			}
		    			}
		    			]}
    			/*handler:function(){
    				for(var i=selectedKpiIds.length-1;i>-1;i--){
    					dhcwl_mkpi_taskIO.getOutputObj().add(selectedKpiIds[i]);
    					//alert(selectedKpiIds[i]);
    				}
    				dhcwl_mkpi_taskIO.getOutputObj().ouputKpis();
    			}*/
    		},/*{
    			text:'添加到预览指标列表',
    			handler:function(){
    				var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                	getPreviewKpiData();
    				dhcwl_mkpi_previewKpiData.add(record.get('kpiCode'));
    			}
    		},{
    			text:'查看预览指标列表',
    			handler:function(){
    				getPreviewKpiData();
    				dhcwl_mkpi_previewKpiData.showList();
    			}
    		},{
    			text:'清空预览指标列表',
    			handler:function(){
    				getPreviewKpiData();
    				dhcwl_mkpi_previewKpiData.clearList();
    			}
    		},*/{
    			text:'预览指标数据',
    			handler:function(){
			    	if(selectedKpiIds.length<=0){
						alert("预览指标列表为空，请先选择要预览的指标！");
						return;
					}
    				var selectKpiRec=[];
    				/*
    				for(var i=selectedKpiIds.length-1;i>-1;i--){
    					selectKpiRec[i]={"kpiCode":selectedKpiIds[i],"kpiName":selectedKpiIds[i],"category":"","section":""};
    				}
    				*/
    				/*
    				for(var i=0;i<=selectedKpiIds.length-1;i++){
    					var kpiID=selectedKpiIds[i];
    					var kpiCode=""
    					for(var j=0;j<=store.getTotalCount()-1;j++){
    						if(store.getAt(i).get("id")==kpiID){
    							kpiCode=store.getAt(i).get("kpiCode");
    							break;
    						}
    						
    					}
    					selectKpiRec[i]={"kpiCode":kpiCode,"kpiName":"","category":"","section":""};
    				}
    				*/
    				var rules="";
    				for(var i=selectedKpiCodes.length-1;i>-1;i--){
    					if (rules!=""){
    						rules=rules+",";
    					}
    					rules=rules+selectedKpiCodes[i];
    				}
    				
    				if(true||!dhcwl_mkpi_previewKpiData){
    					dhcwl_mkpi_previewKpiData=new dhcwl.mkpi.ViewKpiData();
    				}
    				//dhcwl_mkpi_previewKpiData.setSelectedKpis(selectKpiRec);
    				dhcwl_mkpi_previewKpiData.setKpiRule("",rules);
    				dhcwl_mkpi_previewKpiData.showWin();
    				/*getPreviewKpiData();
    				for(var i=selectedKpiIds.length-1;i>-1;i--)
    					dhcwl_mkpi_previewKpiData.add(selectedKpiIds[i]);
    				if(dhcwl_mkpi_previewKpiData.getKpiListLength()<1){
    					alert("还没有添加要预览的指标，请先将指标添加到预览列表后再操作！");
    					return;
    				}
    				dhcwl_mkpi_previewKpiData.previewKpiData();*/
    			}
    		},{
    			text:'转到指标任务维护页面(单选)',
    			handler:function(){
    				var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                	dhcwl_mkpi_taskWin.filterKpi(record.get('kpiCode'));
                	dhcwl_mkpi_maintain.mainTabs.get('dhcwl.mkpi.MaintainKpiTasks.taskPanel').show();
    			}
    		},{  			
     			text:'导出到Excel文件',
    			menu:{
    				boxMinWidth:120,
    				items:[
		    			{
		    				text:'所有指标',
		    				handler:function(cmp,event){
			   					var excelObj=new dhcwl.mkpi.util.Excel();
			    				excelObj.setTitle("指标导出");
			    				excelObj.setHead(['ID','编码','指标名称','指标描述','执行代码','是否使用global','创建者','创建/更新日期','备注','维度','类型','区间','数据节点','取值方式']);
			    				excelObj.setServerUrl('dhcwl/kpi/getkpidata.csp?action=mulSearch&isArrayType=1');
			    				excelObj.exportExcel();
		    				}
		    			},{
		    				text:'已选指标',
		    				handler:function(cmp,event){
						    	if(selectedKpiIds.length<=0){
									alert("指标列表为空，请先选择要导出的指标！");
									return;
								}
			    				var strSelKpiIDs="";
			    				
			    				for(var i=selectedKpiIds.length-1;i>-1;i--){
			    					if (strSelKpiIDs!="") strSelKpiIDs=strSelKpiIDs+",";
			    					strSelKpiIDs=strSelKpiIDs+selectedKpiIds[i];
			    				}
			   					var excelObj=new dhcwl.mkpi.util.Excel();
			    				excelObj.setTitle("指标导出");
			    				excelObj.setHead(['ID','编码','指标名称','指标描述','执行代码','是否使用global','创建者','创建/更新日期','备注','维度','类型','区间','数据节点','取值方式','关联维度(只用于显示)']);
			    				excelObj.setCode(['MKPIId','MKPICode','MKPIName','MKPIDesc','MKPIEXCode','MKPIGlobalFlag','MKPIUser','MKPIUpdateDate','MKPIRemark','MKPIDim','MKPICate','MKPISectionFlag','MKPIDataNod','MKPIGetValueType','MKPIKpiDim'])
			    				excelObj.setServerUrl('dhcwl/kpi/getkpidata.csp?action=mulSearch&isArrayType=1&selKpiIDs='+strSelKpiIDs);
			    				excelObj.exportExcel();
			    				

		    				}
		    			}
		    			]
    			
    			}   			
    			
    			
    			
    		},{
    			text:'清空选取列表',
    			handler:function(){
    				var j=0,len=selectedKpiIds.length;
    				for(var i=store.getCount()-1;i>-1;i--){
    					for(j=len-1;j>-1;j--){
							if(selectedKpiIds[j]==store.getAt(i).get("id")){
								csm.deselectRow(i);
							}
    					}
					}
    				selectedKpiIds=[];
    				selectedKpiCodes=[];
    			}
    		},'-',{
    			text:'指标维度模板',
    			handler:function(){
    				

	    			if(!selectedKpiIds||selectedKpiIds.length==0){
	            		alert("请选择要设置的指标！");
	            		return;
	            	}
    				var choiceKpiListStr=selectedKpiIds.join(",");
	            	dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpidimservice.csp'+'?action=isConfiged&kpiIds='+choiceKpiListStr
	                ,null,function(jsonData){
	                	if(!jsonData){
	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                	if(jsonData.success){
	                		if (jsonData.tip=="ok") {
	                			dhcwl.mkpi.KpiDimTemplate.getKpiDimTemplate().show(); 
	                		}else{
								Ext.Msg.alert("提示","指标维度模板只能对未设置维度的指标操作！");
	                		}
	                	}else{
	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                },outThis);    				
    				    				
    			}
    		},{
    			text:'指标任务模板',
    			handler:function(){
	    			if(!selectedKpiIds||selectedKpiIds.length==0){
	            		alert("请选择要设置的指标！");
	            		return;
	            	}
    				var choiceKpiListStr=selectedKpiIds.join(",");
	            	dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/taskserver.csp'+'?action=isConfiged&kpiIds='+choiceKpiListStr
	                ,null,function(jsonData){
	                	if(!jsonData){
	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                	if(jsonData.success){
	                		if (jsonData.tip=="ok") {
	                			dhcwl.mkpi.KpiTaskTemplate.getKpiTaskTemplate().show();
	                		}else{
								Ext.Msg.alert("提示","指标任务模板只能对未设置任务的指标操作！");
	                		}
	                	}else{
	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                },outThis);    				
    				
    				
    				
    				
 
    			}
    		},{
    			text:'设置运算规则(单选)',
    			handler:function(){
					var kpiCalRelatCfgWin=new dhcwl.mkpi.kpiCalRelatCfg();
					//setRuleWin.setSelectedKpiCode(kpiRuleCombo.getValue());	
					//setRuleWin.setParentWin(outThis);
					var sm = kpiGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                	if(sm.getCount()>1){
                		alert("请选择一行！");
                		return;                		
                	}
                	
					var record = sm.getSelected();
					if(!record){
                		alert("请选择一行！");
                		return;
                	}

                	var getValueType=record.get('getValueType');
                	if (getValueType!=2 && getValueType!="计算指标") {
                		alert("请选择计算指标！");
                		return;                		
                	}
					var mKpiID=record.get('id')
					var kpiCalRelatCfgWin=new dhcwl.mkpi.kpiCalRelatCfg();
					kpiCalRelatCfgWin.showWin(mKpiID);
    			}
    		},{
    			text:'指标数据生成',
    			menu:{
    				boxMinWidth:120,
    				items:[
		    			{
		    				text:'生成数据',
		    				handler:function(cmp,event){
		    					Ext.MessageBox.confirm('提示框','请避免在操作高峰期使用该功能进行大量数据操作,确定要生成数据么？',function(btn){
		    		 				if(btn=='yes'){
		    		 					if(selectedKpiIds.length<=0){
											alert("指标列表为空，请先选择要导出的指标！");
											return;
										}
					    				var strSelKpiIDs="";
					    				
					    				for(var i=selectedKpiIds.length-1;i>-1;i--){
					    					if (strSelKpiIDs!="") strSelKpiIDs=strSelKpiIDs+",";
					    					strSelKpiIDs=strSelKpiIDs+selectedKpiIds[i];
					    				}
		    		 					dhcwl_mkpi_CreateKpiData=new dhcwl.mkpi.CreateKpiData();
				    					dhcwl_mkpi_CreateKpiData.show(strSelKpiIDs,0);
		    		 				}
		    		 			});
		    					
		    				}
		    			},{
		    				text:'重做数据',
		    				handler:function(cmp,event){
		    					Ext.MessageBox.confirm('提示框','请避免在操作高峰期使用该功能进行大量数据操作,确定要生成数据么？',function(btn){
		    		 				if(btn=='yes'){
		    		 					if(selectedKpiIds.length<=0){
											alert("指标列表为空，请先选择要导出的指标！");
											return;
										}
					    				var strSelKpiIDs="";
					    				
					    				for(var i=selectedKpiIds.length-1;i>-1;i--){
					    					if (strSelKpiIDs!="") strSelKpiIDs=strSelKpiIDs+",";
					    					strSelKpiIDs=strSelKpiIDs+selectedKpiIds[i];
					    				}
		    		 					dhcwl_mkpi_CreateKpiData=new dhcwl.mkpi.CreateKpiData();
				    					dhcwl_mkpi_CreateKpiData.show(strSelKpiIDs,1);
		    		 				}
		    		 			});
		    				}
		    			}
		    			]
    			
    			}
    		}
    	]
    });
    var outThis=this;
    var kpiObj=null;
    var copyKpiDimID="";
    var kpiDimFlag=0;
    //dhcwl.mkpi.MaintainKpifl.setParentWin(this);
    //dhcwl.mkpi.MaintainDim.setParentWin(this);
    //dhcwl.mkpi.MaintainSection.setParentWin(this);
    //定义指标列模型
    var selectedKpiIds=[];
    var selectedKpiCodes=[];
    var csm=new Ext.grid.CheckboxSelectionModel({
		listeners :{
			rowselect: function(sm, row, rec) {
        		var rd=rec;   //sm.getSelected();
        		var kpiId=rec.get("id");
        		kpiForm.getForm().loadRecord(rec);
        		sectionCombo.setValue(rd.get('section')); 
        		kpiFlCombo.setValue(rd.get('category'));
        		globalFlagCombo.setValue(rd.get('MKPIGlobalFlag'));
        		getValueTypeCombo.setValue(rd.get('getValueType'));
        		var kpiCode=rec.get("kpiCode");
        		addSelectedKpiId(kpiId,kpiCode);
        		
        		if (kpiId!="") {
             		kpiForm.getForm().findField("id").disable();       
             		//kpiForm.getForm().findField("kpiCode").disable();    
            	}else{
            		kpiForm.getForm().findField("id").enable();  
            		//kpiForm.getForm().findField("kpiCode").enable();  
            	}
        		//alert(selectedKpiIds.join(","));
            },
            'rowdeselect':function(sm, row, rec){
				var kpiId=rec.get("id"),len=selectedKpiIds.length;
				if ((kpiId=="")||(kpiId==" ")){
					return;
				}
				for(var i=0;i<len;i++){
					if(selectedKpiIds[i]==kpiId){
						for(var j=i;j<len;j++){
							selectedKpiIds[j]=selectedKpiIds[j+1];
							selectedKpiCodes[j]=selectedKpiCodes[j+1];
							//selectKpiObj[rec.get("kpiCode")]=rec.get("kpiName");
						}
						selectedKpiIds.length=len-1;
						selectedKpiCodes.length=len-1;
						break;
					}
				}
			}
		}
	});
	//start
	var columnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),csm,
        {header:'ID',dataIndex:'id',sortable:true, width: 30, sortable: true,menuDisabled : true
        },{header:'编码',dataIndex:'kpiCode', width: 100, sortable: true ,menuDisabled : true
        },{header:'指标名称',dataIndex:'kpiName', width: 160, sortable: true ,menuDisabled : true
        },{header:'指标描述',dataIndex:'kpiDesc', width: 160, sortable: true ,menuDisabled : true
        },{header:'执行代码',dataIndex:'kpiExcode', width: 180, sortable: true,menuDisabled : true
        },{header:'是否使用global',dataIndex:'MKPIGlobalFlag', width: 80, sortable: true,menuDisabled : true
        },{header:'创建者',dataIndex:'createUser', width: 80, sortable: true,menuDisabled : true
        },{header:'创建/更新日期',dataIndex:'updateDate', width: 88, sortable: true ,menuDisabled : true
        },{header:'数据节点',dataIndex:'dataNode', width: 80, sortable: true ,menuDisabled : true
        },{header:'维度',dataIndex:'dimType',resizable:'true',width:88, sortable: true,menuDisabled : true
        },{header:'类型',dataIndex:'category',resizable:'true',width:88, sortable: true,menuDisabled : true
        },{header:'区间',dataIndex:'section',resizable:'true',width:88, sortable: true,menuDisabled : true
        },{header:'备注',dataIndex:'nodeMark',resizable:'true',width:88
        },{header:'取值方式',dataIndex:'getValueType',resizable:'true',width:88, sortable: true,menuDisabled : true	//4.2加入
        },{header:'度量',dataIndex:'measure',resizable:'true',width:88, sortable: true,menuDisabled : true	
        }
    ]);
    //end
    //定义指标的存储模型
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/getkpidata.csp?action=mulSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'id'},
            	{name: 'kpiCode'},
            	{name: 'kpiName'},
            	{name: 'kpiDesc'},
            	{name: 'kpiExcode'},
            	{name: 'MKPIGlobalFlag'},
            	{name: 'createUser'},
            	{name: 'updateDate'},
            	{name: 'dataNode'},
            	{name: 'dimType'},
            	{name: 'category'},
            	{name: 'section'},
            	{name: 'nodeMark'},
            	{name: 'getValueType'},
				{name: 'measure'}
       		]
    	}),
    	listeners :{
    		'load' : function( th, records,options ) {
    			for(i=0;i<=records.length-1;i++){
    				var valueType=records[i].get("getValueType");
    				if (valueType==2) {
    					records[i].set("getValueType","计算指标");
    				}else if (valueType==1) {
    					records[i].set("getValueType","普通指标");
    				}
    			}
    		}
    	}

    });
    //start
    var record= Ext.data.Record.create([
        {name: 'id', type: 'int'},
        {name: 'kpiCode', type: 'string'},
        {name: 'kpiName', type: 'string'},
        {name: 'kpiDesc', type: 'string'},
        {name: 'kpiExcode',type: 'string'},
        {name: 'MKPIGlobalFlag',type: 'string'},
        {name: 'createUser', type: 'string'},
        {name: 'updateDate', type: 'string'},
        {name: 'dataNode', type: 'string'},
        {name: 'dimType', type: 'string'},
        {name: 'category', type: 'string'},
        {name: 'section', type: 'string'},
        {name: 'nodeMark', type: 'string'},
        {name: 'getValueType', type: 'string'},
		{name: 'measure',type:'string'}
	]);
	//end
	//定义指标的显示表格。
	var pageTool=new Ext.PagingToolbar({
        pageSize: 20,
        store: store,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录",
        listeners :{
			'change':function(pt,page){
				var id="",j=0,found=false,storeLen=selectedKpiIds.length;
				var AllRowCnt=store.getCount();
				var selRowCnt=0;
				for(var i=store.getCount()-1;i>-1;i--){
					id=store.getAt(i).get("id");
					found=false;
					for(j=storeLen-1;j>-1;j--){
						if(selectedKpiIds[j]==id) found=true;
					}
					if(found){
						csm.selectRow(i,true,false);
						selRowCnt++;
					}
				}
				
				
				var hd_checker = kpiGrid.getEl().select('div.x-grid3-hd-checker');
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
    });
	var kpiGrid = new Ext.grid.GridPanel({
        id:"dhcwl.mkpi.ShowKpiWin.kpiTables",
        view:new Ext.grid.GridView({markDirty : false}),
        resizeAble:true,
        //autoHeight:true,
        height:480,
        loadMask:true,
        enableColumnResize :true,
        store: store,
        cm: columnModel,
        sm: csm /*new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
                	//Ext.getCmp("kpi-list").getForm().loadRecord(rec);
            		//var form=kpiForm.getForm();
            		var rd=sm.getSelected();
            		kpiForm.getForm().loadRecord(rec);
            		//if(!sectionCombo.getValue()) 
            			sectionCombo.setValue(rd.get('section'));
            		//if(!kpiFlCombo.getValue()) 
            			kpiFlCombo.setValue(rd.get('category'));
            		//if(!kpiDimCombo.getValue())
            			//kpiDimCombo.setValue(rd.get('dimType'));
            		//if(!globalFlagCombo.getValue())
            			globalFlagCombo.setValue(rd.get('MKPIGlobalFlag'));
                }
            }
        })*/,
        bbar:pageTool,
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        		var sm = this.getSelectionModel();
        		var record = sm.getSelected();
        		if(record){
        			var id=record.get("id");
                	var kpiName=record.get("kpiName");
                	var record = sm.getSelected();
                	selectRowId=id;
                	selectRowKpiName=kpiName;
        		}  
        	}
        }
    }); 
	
    var sectionCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择指标区间',
		fieldLabel : '区间',
		name : 'sectionCombo',
		displayField : 'secName',
		valueField : 'secCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getSectionCombo'}),
			//reader:new Ext.data.ArrayReader({},[{name:'secCode'},{name:'secName'}])
			reader:new Ext.data.ArrayReader({},[{name:'secCode'},{name:'secName'}])
		}),
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{secName}' +   
			'</div>'+   
			'</tpl>',			
		listeners :{
			'select':function(combox){
				sectionCombo.setValue(combox.getRawValue());
			}
		}
	});
    var kpiFlCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择指标分类',
		fieldLabel : '类型',
		name : 'kpiFlCombo',
		displayField : 'kpiFlName',
		valueField : 'kpiFlCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getKpiflCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'kpiFlCode'},{name:'kpiFlName'}])
		}),
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{kpiFlName}' +   
			'</div>'+   
			'</tpl>',	
		listeners :{
			'select':function(combox){
				kpiFlCombo.setValue(combox.getRawValue());
			}
		}
	});
	var kpiDimCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择指标维度',
		fieldLabel : '维度',
		name : 'kpiDimCombo',
		displayField : 'kpiDimName',
		valueField : 'kpiDimCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getKpiDimCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'kpiDimCode'},{name:'kpiDimName'}])
		}),
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{kpiDimName}' +   
			'</div>'+   
			'</tpl>',			
		listeners :{
			'select':function(combox){
				kpiDimCombo.setValue(combox.getRawValue());
			}
		}
	});

	var globalFlagCombo=new Ext.form.ComboBox({
 		displayField : 'isGlobal',
		valueField : 'isGlobalV',       
        
        typeAhead: true,
		mode : 'local',        
 	    //forceSelection: true,
		triggerAction : 'all', 	        

        //emptyText:'Select a state...',
        selectOnFocus:true,
		width : 130,
		value:'',
		name : 'globalFlagCombo',		
		editable:false,
		fieldLabel : 'global存数据',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{isGlobal}' +   
			'</div>'+   
			'</tpl>',		
		store : new Ext.data.JsonStore({
			fields : ['isGlobal', 'isGlobalV'],
			data : [{
				isGlobal : '',
				isGlobalV : ''
			},{
				isGlobal : '否',
				isGlobalV : 'N'
			}, {
				isGlobal : '是',
				isGlobalV : 'Y'
			}]}),
		listeners :{
			'select':function(combox){
				globalFlagCombo.setValue(combox.getValue());
			}
		}
	});
   
	
	//add after v4.2 2015-2-5
	var getValueTypeCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '取值方式',
		value:'',
		name : 'getValueTypeCombo',
		displayField : 'isGlobal',
		valueField : 'isGlobalV',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{isGlobal}' +   
			'</div>'+   
			'</tpl>',
		stype:{
			"padding":"20px"
		},
		store : new Ext.data.JsonStore({
			fields : ['isGlobal', 'isGlobalV'],
			data : [{
				isGlobal : '',
				isGlobalV : ''
			},{
				isGlobal : '普通指标',
				isGlobalV : '1'
			}, {
				isGlobal : '计算指标',
				isGlobalV : '2'
			}]}),
		listeners :{
			/*
			'select':function(combox){
				globalFlagCombo.setValue(combox.getValue());
			}
			*/
		}
	});	
	
	
   this.setSelectValue=function(value){
		Ext.getCmp('kpiExcode').setValue(value);
		return;
    }
   
    var kpiForm=new Ext.FormPanel({
    	frame : true,
		height : 150,
		labelAlign : 'right',
		bodyStyle:'padding:5px',
		labelWidth : 90,
		style : {
			"margin-right" : Ext.isIE6? (Ext.isStrict ? "-10px" : "-13px"): "0"
		},items : [{
			layout : 'column',
			items : [{ 
				columnWidth : .18,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 100
				},
				items : [{
							fieldLabel : 'ID',
							xtype:'textfield',
							name: 'id',
				            id:'id',
							disabled : true
						}, globalFlagCombo,kpiFlCombo]
			}, {
				columnWidth : .18,
				labelWidth : 50,
				layout : 'form',
				defaults : {
					width : 140
				},
				items : [{
							fieldLabel : '编码',
							xtype : 'textfield',
							name: 'kpiCode',
				            id:'kpiCode'
						}, {
							fieldLabel : '创建人',
							xtype : 'textfield',
							name: 'createUser',
				            id:'createUser'
						},sectionCombo]
			}, {
				columnWidth : .18,
				layout : 'form',
				labelWidth : 70,
				defaults : {
					width : 120
				},
				items : [{
							xtype : 'textfield',
							fieldLabel : '指标名称',
							name: 'kpiName',
				            id:'kpiName'
						}, {
							xtype : 'datefield',
							name: 'updateDate',
				            id:'updateDate',
							fieldLabel : '更新日期',
							format:GetWebsysDateFormat()
						},{
							xtype: 'compositefield',
							fieldLabel : '备注',
				            defaults: {
				            	flex: 1
				            	//width:100
				            },
				        	items:[{
				        		xtype:'textfield',
				        		name: 'nodeMark',
				        		id: 'nodeMark',
				        		flex:1,
				        		width:95
				        		},{
				        			html: '<IMG id="kpiDimImg" src="../images/websys/lookup.gif" onclick="dhcwl_mkpi_showKpiWin.getMarkInfor()">'
				        	}]
						}]
			}, {
				columnWidth : .18,
				layout : 'form',
				labelWidth : 70,
				defaults : {
					width : 120
				},
				items : [{
					xtype:'textfield',
					fieldLabel : '指标描述',
					name: 'kpiDesc',
		            id:'kpiDesc'
				},{
					xtype:'textfield',
					fieldLabel:'数据节点',
		            name: 'dataNode',
		            id: 'dataNode'
				},getValueTypeCombo]
			},{
				columnWidth : .26,
				labelWidth : 65,
				layout : 'form',
				defaults : {
					width : 205
				},
				items : [{
					xtype:'textfield',
					fieldLabel : '执行代码',
					name:'kpiExcode',
		            id:'kpiExcode'
				},{
		            xtype: 'compositefield',
		            fieldLabel : '维度',
		            defaults: {
		            	flex: 1
		            	//width:275
		            },
		            items: [{
		            	name:'dimType',
		           	 	id:'dimType',
		            	xtype:'textfield',
		            	width:180,
		            	flex:1,
		            	listeners:{
		            	
		            	}
		        	},{
		                html: '<IMG id="kpiDimImg" onclick="dhcwl_mkpi_showKpiWin.setKpiDim()" src="../images/websys/lookup.gif" >'
		            }]
		        },{
		            xtype: 'compositefield',
		            fieldLabel : '度量',
		            defaults: {
		            	flex: 1
		            	//width:275
		            },
		            items: [{
		            	name:'measure',
		           	 	id:'measure',
		            	xtype:'textfield',
		            	width:180,
		            	flex:1,
		            	listeners:{
		            	
		            	}
		        	},{
		                html: '<IMG id="kpiDimImg" onclick="dhcwl_mkpi_showKpiWin.setKpiMeasure()" src="../images/websys/lookup.gif" >'
		            }]
		        }]
			}]

		}],
        tbar: new Ext.Toolbar([{
            //text: '新增',
        	text: '<span style="line-Height:1">新增</span>',
            icon: '../images/uiimages/edit_add.png',
            handler: function(){
				var date=dhcwl.mkpi.Util.nowDate();
                var initValue = {id:' ',kpiCode:'',kpiName:'',updateDate:date,kpiDesc:'',createUser:'',nodeMark:'',dimType:'',category:'',section:minSec,dataNode:'',kpiExcode:'',MKPIGlobalFlag:'是',getValueType:'普通指标'};
                var p = new record(initValue);
                store.insert(0, p);	
                csm.selectFirstRow();
            }
        }, '-', {
            //text: '删除',
            text: '<span style="line-Height:1">删除</span>',
            icon: '../images/uiimages/edit_remove.png',
            handler: function(){
				removeKpi();
				return;				
                var strSelKpiIDs=selectedKpiIds.join(",");
				if (strSelKpiIDs=="") {
                	alert("请勾选要删除的指标！");
                	return;					
				}
				Ext.Msg.confirm('信息', '删除指标有:  '+strSelKpiIDs+'  确定要删除？', function(btn){
					if (btn == 'yes'){
						
						var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
						Ext.Msg.confirm('信息', '删除指标时，会删除所有【勾选】的指标及这些指标的所有指标维度、模块与报表中数据集的配置，确定要删除？', function(btn){
		                    if (btn == 'yes') {                      
								dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/savekpi.csp?action=delete',{ids:strSelKpiIDs},function(jsonData){
										if(jsonData.success==true && jsonData.tip=="ok"){   
					                        dhcwl.mkpi.ShowKpiWin.prototype.refresh.apply(outThis);
					                        outThis.clearForm();
					                        selectedKpiIds=[];
					                        selectedKpiCodes=[];
					                        
					                        pageTool.cursor=0;
		                					pageTool.doLoad(pageTool.pageSize*(cursor-1));
										}else{
											Ext.Msg.alert("提示",jsonData.tip);
											}
											
										},this);	                        

		                    }
		                }); 
					}else{
						return;
					}
				 }); 
            }
        },'-',{
        	cls:'align:right',
        	//text   : '保  存',
        	text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
            handler: function() {
            	var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
                var paraValues; 
                var sm = kpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要保存的指标！");
                	return;
                }
                var id=record.get("id");
                var kpiName=Ext.get('kpiName').getValue();
                var kpiDesc=Ext.get('kpiDesc').getValue();
                var kpiCode=Ext.get('kpiCode').getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||\-\(\)\']/;
                var reg2=/^\d/;
                if(reg.test(kpiCode)||(reg2.test(kpiCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||,-,(,),'等特殊字符，并且不能以数字开头");
                	Ext.get("kpiCode").focus();
                	return;
                }
                var kpiExcode=Ext.get('kpiExcode').getValue();
                var createUser=Ext.get('createUser').getValue();
                var updateDate=Ext.get('updateDate').getValue();
                var nodeMark=Ext.get('nodeMark').getValue();
                var getValueType=getValueTypeCombo.getValue();
                if(kpiExcode) kpiExcode=kpiExcode.trim();
                if(!kpiName||!kpiCode){
                	alert("指标代码或名称不能为空!");
                	return;
                }
                var section=sectionCombo.getRawValue();
                var dimType=kpiDimCombo.getRawValue();
                var category=kpiFlCombo.getRawValue();
                var globalFlag=globalFlagCombo.getValue();
                var dataNode=Ext.get('dataNode').getValue();
                if(!globalFlag||globalFlag==""||globalFlag=='否'||globalFlag=='N') globalFlag='N';
                else globalFlag='Y';
               if(!getValueType||getValueType==""||getValueType=='普通指标'||getValueType=='1') getValueType='1';
                else getValueType=2;
               var params={"id":id,"category":category,"kpiCode":kpiCode,"kpiExcode":kpiExcode,"createUser":createUser,"updateDate":updateDate,"nodeMark":nodeMark,"kpiName":kpiName,"kpiDesc":kpiDesc,"section":section,"dataNode":dataNode,"globalFlag":globalFlag,"getValueType":getValueType};
                record.set("kpiCode",kpiCode),record.set("kpiName",kpiName),record.set("kpiDesc",kpiDesc);
                record.set("createUser",createUser),record.set("updateDate",updateDate),record.set("nodeMark",nodeMark);
                record.set("dimType",dimType);
                record.set("category",category),record.set("section",section);
                record.set("dataNode",dataNode),record.set("globalFlag",globalFlag);record.set("getValueType",getValueType);
                params["action"]="add";
                if((kpiDimFlag==1)&&((id=="")||(id==" "))){
                	params["copyKpiDimID"]=copyKpiDimID;
                	dhcwl.mkpi.Util.ajaxExc("dhcwl/kpi/savekpi.csp",params);
                }else{
                	dhcwl.mkpi.Util.ajaxExc("dhcwl/kpi/savekpi.csp",params);
                }
                store.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=mulSearch")); //&start="+cursor+"&limit="+20));
                store.load();
                kpiObj=null;
                copyKpiDimID="";
                kpiDimFlag=0;
                pageTool.cursor=0;
                pageTool.doLoad(pageTool.pageSize*(cursor-1));
           }
        },'-',{//text   : '复  制',
        	text: '<span style="line-Height:1">复制</span>',
        	cls:'align:right',
        	icon: '../images/uiimages/copy1.png',
            handler: function() {
            	var sm = kpiGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要复制的指标！");
                	return;
                }
        		var kpiCode=record.get("kpiCode"),kpiName=record.get("kpiName"),kpiDesc=record.get("kpiDesc");
        		var kpiExcode=record.get("kpiExcode"),MKPIGlobalFlag=record.get("MKPIGlobalFlag"),createUser=record.get("createUser");
        		var updateDate=record.get("updateDate"),dataNode=record.get("dataNode"),dimType=record.get("dimType");
        		var category=record.get("category"),section=record.get("section"),nodeMark=record.get("nodeMark"),getValueType=record.get("getValueType");
        		kpiObj ={kpiCode:kpiCode,kpiName:kpiName,kpiDesc:kpiDesc,kpiExcode:kpiExcode,MKPIGlobalFlag:MKPIGlobalFlag
        		,createUser:createUser,updateDate:updateDate,dataNode:dataNode,dimType:dimType,category:category,section:section,nodeMark:nodeMark,getValueType:getValueType
        		} 
        		copyKpiDimID=record.get("id");
        		Ext.Msg.alert("提示","复制成功");
                        	
        	}
        },'-',{//text   : '粘 贴',
        	text: '<span style="line-Height:1">粘贴</span>',
        	cls:'align:right',
        	icon: '../images/uiimages/paste.png',
            handler: function() {
				if (!kpiObj){
					Ext.MessageBox.alert("错误请求","您还没有复制指标，请选择您要复制的指标后再执行粘贴操作！");
					return;
				}
				var id=Ext.get('id').getValue();
				if ((id!="")&&(id!=" ")&&(id!=null)){
					Ext.MessageBox.alert("错误请求","您选中了一个已存在的指标,请点击新建指标后操作！");
				}
				var rec=new record(kpiObj);
        		kpiForm.getForm().loadRecord(rec);
        		sectionCombo.setValue(kpiObj.section); 
        		kpiFlCombo.setValue(kpiObj.category);
        		globalFlagCombo.setValue(kpiObj.MKPIGlobalFlag);
        		getValueTypeCombo.setValue(kpiObj.getValueType);
        		kpiDimFlag=1;
        	}
        },'-',{//text   : '清  空',
        	text: '<span style="line-Height:1">清空</span>',
        	cls:'align:right',
        	icon: '../images/uiimages/clearscreen.png',
            handler: function() {
            	kpiForm.getForm().findField("id").enable();
            	outThis.clearForm();
            	return;
            	var form=kpiForm.getForm();
    			form.setValues({id:'',kpiName:'',kpiDesc:'',kpiDimCombo:'',kpiFlCombo:'',sectionCombo:'',globalFlagCombo:'',kpiCode:'',kpiExcode:'',createUser:'',updateDate:'',nodeMark:'',dataNode:'',dimType:'',getValueTypeCombo:'',measure:''});
        	}
        },'-',{//text   : '查  找',
        	text: '<span style="line-Height:1">查询</span>',
        	cls:'align:right',
        	icon: '../images/uiimages/search.png',
            handler: function() {
            	var id=Ext.get('id').getValue();
                var kpiName=Ext.get('kpiName').getValue();
                var kpiDesc=Ext.get('kpiDesc').getValue();
                var dimType=Ext.get('dimType').getValue();
                var section=sectionCombo.getRawValue();
                var category=kpiFlCombo.getRawValue();
                var kpiCode=Ext.get('kpiCode').getValue();
                var kpiExcode=Ext.get('kpiExcode').getValue();
                var createUser=Ext.get('createUser').getValue();
                var updateDate=Ext.get('updateDate').getValue();
                var nodeMark=Ext.get('nodeMark').getValue();
                var dataNode=Ext.get('dataNode').getValue();
				var measure=Ext.get('measure').getValue();
                var globalFlag=globalFlagCombo.getValue();
                if(!globalFlag) globalFlag='';
                else if(globalFlag=='否'||globalFlag=='N') globalFlag='N';
                else if(globalFlag=='是'||globalFlag=='Y') globalFlag='Y';
                else globalFlag='';
                var getValueType=getValueTypeCombo.getValue();
                if (getValueType=="普通指标") getValueType=1; 
                if (getValueType=="计算指标") getValueType=2; 
                paraValues='kpiId='+id+'&dimType='+dimType+'&category='+category+'&kpiCode='+kpiCode+'&kpiExcode='+kpiExcode;
                paraValues+='&createUser='+createUser+'&updateDate='+updateDate+'&nodeMark='+nodeMark+'&measure='+measure;
  				paraValues+='&kpiName='+kpiName+'&kpiDesc='+kpiDesc+'&section='+section+'&dataNode='+dataNode+'&globalFlag='+globalFlag+'&getValueType='+getValueType;
                store.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=mulSearch&"+paraValues+"&onePage=1"));
                //alert(paraValues);
            	store.load();
    			kpiGrid.show();
           }
        },'-',{
			text: '<span style="line-Height:1">帮助</span>',
        	cls:'align:right',
        	icon: '../images/uiimages/help.png',
			handler:function(){
				Helpwin.show();
			}
		}
      ])
    });
    this.getMarkInfor=function(){
    	//var　markInfor=kpiForm.getForm.findField("nodeMark").getValue();
    	var　markInfor=Ext.get('nodeMark').getValue();
    	Ext.Msg.alert("备注详细信息：",markInfor);
    }
    //var kpiDimEle=Ext.get("kpiDimImg");
    //kpiDimEle.addListener("click",function(){getKpiDimObj().show();});
    /*var kpiShowWin =new Ext.Panel({
    	title:'指标维护',
    	layout:'border',
        items: [{
        	region: 'north',
            height: 153,
            //autoScroll:true,
            items:kpiForm
        },{
        	region:'center',
        	autoScroll:true,
            items:kpiGrid
    	}],
    	listeners:{
    		"resize":function(win,width,height){
    			kpiGrid.setHeight(height-155);
    			kpiGrid.setWidth(width-15);
    		},
    		"afterlayout":function(thisPanel,layout){
    			dhcwl.mkpi.Util.ajaxExc("dhcwl/kpi/mkpiinfo.csp",
            		{'action':'KPIVERSION'
            		},
            		function(responseText){
            			if(responseText['version'])
            				thisPanel.setTitle("指标维护--"+responseText['version']+"版本");
            		}
            		,outThis
            	);
    			
    		}
    	}
    });*/
	
	
	
	
	
	var kpiShowWin =new Ext.Panel ({ //Viewport({
    	title:'指标维护',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		
    	defaults: { border :false},
        items: [{ 
			border :false,
			flex:1.2,
			layout:"fit",
            items:kpiForm
    	},{
			border :false,
			flex:3,
			layout:"fit",
            items:kpiGrid
        }],
		listeners:{
    		"afterlayout":function(thisPanel,layout){
    			dhcwl.mkpi.Util.ajaxExc("dhcwl/kpi/mkpiinfo.csp",
            		{'action':'KPIVERSION'
            		},
            		function(responseText){
            			if(responseText['version'])
            				thisPanel.setTitle("指标维护--"+responseText['version']+"版本");
            		}
            		,outThis
            	);
    			
    		}
    	}
    });	
	
	
	
	
	
    /*var kpiShowWin=new Ext.Panel({
    	id:'dhcwl_mkpi_showKpiWin22',
    	title:"指标维护",
    	//layout:'border',  //'table',
    	layout:'table',
        layoutConfig: {columns:1},
    	expandOnShow:true,
        resizable:true,
        width:3800,
        height:800,
        items: [
        {
            height: 140,
        	region: 'north',
        	autoScroll:true,
            items:kpiForm
        },
        {
        	region: 'center',
        	autoScroll:true,
            items:kpiGrid
        }]
    });*/
    
    //新的代码
    kpiShowWin.on('afterrender',function( th ){
    	//Ext.Msg.alert("tip","after render");
 		store.load({params:{start:0,limit:20,onePage:1}});
 		
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpiservice.csp?action=getMinSec',null,
		function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok"){
                			minSec=jsonData.sec_name
						}},this);			
	})	
    
    //store.load({params:{start:0,limit:20,onePage:1}});	//原来的代码
 /*
 * 设置指标的维度，支持一个指标支持多个维度add@20130415
 */
    this.setKpiDim=function(){
		var sm = kpiGrid.getSelectionModel();
	    var record = sm.getSelected();
	    if(!sm||!record){
	    	alert("请选择要配置的指标！");
	    	return;
	    }
	    var id=record.get("id"),kpiName=record.get("kpiName");
	    if(!id||id==""||id==" "){
	    	alert("指标未创建，请创建完毕指标，保存后再执行本操作！")
	    	return;
	    }
	    getKpiDimObj().show(id,kpiName);
	    /*
	     * 将指标id传入指标维度配置界面，配置该指标的维度
	     */
    
}
	this.setKpiMeasure=function(){
		var sm = kpiGrid.getSelectionModel();
	    var record = sm.getSelected();
	    if(!sm||!record){
	    	alert("请选择要配置的指标！");
	    	return;
	    }
	    var id=record.get("id"),kpiName=record.get("kpiName");
	    if(!id||id==""||id==" "){
	    	alert("指标未创建，请创建完毕指标，保存后再执行本操作！")
	    	return;
	    }
	    getKpiMeasureObj().show(id,kpiName);
    
	}
	this.clearForm=function(){
		var form=kpiForm.getForm();
    	form.setValues({id:'',kpiName:'',kpiDesc:'',kpiDimCombo:'',kpiFlCombo:'',sectionCombo:'',globalFlagCombo:'',kpiCode:'',kpiExcode:'',createUser:'',updateDate:'',nodeMark:'',dataNode:'',dimType:'',getValueTypeCombo:'',measure:''});
    	return;
	}
    this.getStore=function(){
    	return store;
    }
    this.getColumnModel=function(){
    	return columnModel;
    }
    this.getKpiShowWin=function(){
    	//kpiGrid.setHeight(kpiShowWin.getHeight()-158);
    	return kpiShowWin;
    }
    this.getKpiForm=function(){
    	return kpiForm;
    }
    this.getKpiGrid=function(){
    	return kpiGrid;
    }
    this.getRecord=function(){
    	return record;
    }
    this.refreshCombo=function(){
    	sectionCombo.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=getSectionCombo'));
    	sectionCombo.getStore().load();
    	sectionCombo.show();
    	kpiDimCombo.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=getKpiDimCombo'));
    	kpiDimCombo.getStore().load();
    	kpiDimCombo.show();
    	kpiFlCombo.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=getKpiflCombo'));
    	kpiFlCombo.getStore().load();
    	kpiFlCombo.show();
    }
    this.getSelectedKpiIds=function(){
    	return selectedKpiIds;
    }
    function addSelectedKpiId(id,code){
    	if(!id||id==""||id==" ") return;
		for(var i=selectedKpiIds.length-1;i>-1;i--){
			if(selectedKpiIds[i]==id)
				return;
		}
		selectedKpiIds.push(id);
		selectedKpiCodes.push(code);
    }
    this.refreshDimType=function(){
    	var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
	    store.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=mulSearch")); //&start="+cursor+"&limit="+20));
	    store.load();
	    pageTool.cursor=0;
	    pageTool.doLoad(pageTool.pageSize*(cursor-1));   	
    }
	
	/*--指标删除--*/
	function removeKpi() {
		var strSelKpiIDs=selectedKpiIds.join(",");
		if (strSelKpiIDs=="") {
			alert("请勾选要删除的指标！");
			return;					
		}
		var formatKpiIDs=""
		for(var i=selectedKpiIds.length-1;i>-1;i--){
			if (formatKpiIDs==""){
				formatKpiIDs=selectedKpiIds[i];
			}else{
				if ((!(i%10))&&(i!=0)){
					formatKpiIDs=formatKpiIDs+","+'<br/>'+selectedKpiIds[i];
				}else{
					formatKpiIDs=formatKpiIDs+","+selectedKpiIds[i];
				}
			}
		}
		formatKpiIDs=formatKpiIDs+"<br/>"
		var htmlStr='<font color=blue style="font-weight:bold">您选择的下列指标将被删除，删除后<font color=blue style="font-weight:bold" size="5">不能恢复！！</font></font>'
		htmlStr=htmlStr+'<br/>'+formatKpiIDs
		htmlStr=htmlStr+'</br><font color=blue style="font-weight:bold">您确定要继续操作么?</font>'
		win = new Ext.Window({
			title:'<h1><font color=red>警告！！警告！！请谨慎操作！！</font></h1>',
			width:500,
			height:250,
			buttonAlign:'center', 
			layout:'fit',
			plain: true,
			items: new Ext.Panel({
				border:false,
				html:htmlStr
			}), buttons: [{
				text: '<span style="line-Height:1">确定</span>',
				icon: '../images/uiimages/ok.png',
				handler:function(){     /*--点击确定移除指标--*/
					var cursor=Math.ceil((pageTool.cursor + pageTool.pageSize) / pageTool.pageSize);
					Ext.Msg.confirm('再次确认', '删除指标时，会删除所有【勾选】的指标及这些指标的所有指标维度、模块与报表中数据集的配置，确定要删除？', function(btn){
						if (btn == 'yes') {                      
							dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/savekpi.csp?action=delete',{ids:strSelKpiIDs},function(jsonData){
								if(jsonData.success==true && jsonData.tip=="ok"){   
									dhcwl.mkpi.ShowKpiWin.prototype.refresh.apply(outThis);
									outThis.clearForm();
									selectedKpiIds=[];
									selectedKpiCodes=[];
									
									pageTool.cursor=0;
									pageTool.doLoad(pageTool.pageSize*(cursor-1));
								}else{
									Ext.Msg.alert("提示",jsonData.tip);
									}
									
								},this);	                        
								win.close();
						}
					}); 
				}
			},{
				text: '<span style="line-Height:1">取消</span>',
				icon: '../images/uiimages/cancel.png',
				handler: function(){
					win.close();   /*--点击取消关闭窗口--*/
				}

			}]
		});		
		win.show();
		
	}
	
}


 var tabs2 = new Ext.TabPanel({
        renderTo: document.body,
        activeTab: 0,
        width:850,
        height:550,
        plain:true,
        defaults:{autoScroll: true},
        items:[{
                title: '页面说明',
                html: ' <iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="../scripts/dhcwl/help/指标系统V4.4.0使用说明书.htm"></iframe>'
            },{
                title: '帮助文档',
                html:' <iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="../scripts/dhcwl/help/指标常见问题汇总.htm"></iframe>'
            }
        ]
    });

var Helpwin = new Ext.Window({
		title : '文档',
		width:850,
		height: 550,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		closeAction : 'hide',
		//layout : 'form',
		items:[tabs2]
		/*items : helphtml={
			html:' <iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="../scripts/dhcwl/help/指标系统V4.4.0使用说明书.htm"></iframe>'
		}*/
		
	})

/*dhcwl.mkpi.ShowKpiWin.prototype.setKpiDim=function(){
	var sm = kpiGrid.getSelectionModel();
    var record = sm.getSelected();
    if(!sm||!record){
    	alert("请选择要配置的指标！");
    	return;
    }
    var id=record.get("id"),kpiName=recorde.get("kpiName");
    getKpiDimObj().show(id,kpiName);
    
     * 将指标id传入指标维度配置界面，配置该指标的维度
     
    
}*/
//用于设置表单中某一个字段的值
dhcwl.mkpi.ShowKpiWin.prototype.setKpiFormFile=function(filed){
	this.getKpiForm().getForm().setValues(filed);
	this.refreshDimType();
	

}
dhcwl.mkpi.ShowKpiWin.prototype.refresh=function(){
	this.getStore().proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=mulSearch&onePage=1"));
	this.getStore().load();
    this.getKpiGrid().show();
}
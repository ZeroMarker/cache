(function(){
	Ext.ns("dhcwl.mkpi.KpiRptCfg");
})();

dhcwl.mkpi.KpiRptCfg=function(){

    //Ext.QuickTips.init();
	var searchCriteria="";
	var mmSEDateCfgObj=null;
	var outThis=this;
	var handleKpis="";	
	var datasetCfgObj;
	var selectedRptCodes=[];
	var curModuleTree;
	
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
    		},"-",{
    			text:'设置任务区间',
    			handler:function(){
    				onRptSecHandle();
    			}
    		},"-",{
    			text:'导出',
    			menu:{
    				boxMinWidth:130,
    				items:[{
			    				text:'导出无维度版',
				    			handler:function(cmp,event){
				    				onExport(0);			    				
				    			}
			    			},{
			    				text:'导出有维度版',
				    			handler:function(cmp,event){
				    				onExport(1);			    				
				    			}	
			    			}
			    			]
    			}
    			
    			//handler:onExport
    		},'-',    		
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
    		}]
	});		
	
	
	var sm = new Ext.grid.CheckboxSelectionModel();	
	sm.on('rowselect',function(sm, row, rec){
		var code=rec.get("RptCfg_Code");
    	if(!code||code=="") return;
		for(var i=selectedRptCodes.length-1;i>-1;i--){
			if(selectedRptCodes[i]==code)
				return;
		}
		selectedRptCodes.push(code);
		//alert(selectedKpiIds.join(","));
	});
	
	
	sm.on('rowdeselect',function(sm, row, rec){
		var code=rec.get("RptCfg_Code"),len=selectedRptCodes.length;
		for(var i=0;i<len;i++){
			if(selectedRptCodes[i]==code){
				for(var j=i;j<len;j++){
					selectedRptCodes[j]=selectedRptCodes[j+1];
					//selectKpiObj[rec.get("kpiCode")]=rec.get("kpiName");
				}
				selectedRptCodes.length=len-1;
				break;
			}
		}
	});
	//var actTreeCode="";		//保存报表节点的父节点。
    var rptCfgRec = Ext.data.Record.create([{
        name: 'RptCfg_RowID',
        type: 'string'
    }, {
        name: 'RptCfg_Code',
        type: 'string'
    }, {
        name: 'RptCfg_Name',
        type: 'string'
    },{
        name: 'RptCfg_Desc',
        type: 'string'
    },{
        name: 'RptCfg_TreeCode',
        type: 'string'
    }]);

	var rptProxy=new Ext.data.HttpProxy({url:"dhcwl/kpi/kpirptcfgdata.csp?action=getNode"});
    var store = new Ext.data.GroupingStore({
        id:"rptCfgStore",
        reader: new Ext.data.JsonReader({
             	totalProperty: 'totalNum',
            	root: 'root',       	
        		fields: rptCfgRec}),
            	/*
            	fields:[
           		{name: 'RptCfg_RowID'},
            	{name: 'RptCfg_Code'},
            	{name: 'RptCfg_Desc'},
            	{name: 'RptCfg_URL'}      	
            	]}),
            	*/
        proxy: rptProxy      
     });

    var editor = new Ext.ux.grid.RowEditor({
        saveText: '保存',
        cancelText: '取消',
        clicksToEdit:2
    });			//调用 RowEditor.js中的initComponent

    var grid = new Ext.grid.GridPanel({
    	id:"rptCfgGridPanel",
        store: store,
        height: 275,
        autoExpandColumn: 'RptCfg_Desc',
        plugins: [editor],
        /*view: new Ext.grid.GroupingView({
            markDirty: false
        }),
        */
        viewConfig: {
        	markDirty: false,
            forceFit: true
        },
        tbar: [{
            iconCls: 'icon-user-add',
            //text: '新增报表',
            text: '<span style="line-Height:1">新增报表</span>',
            icon: '../images/uiimages/edit_add.png',
            handler: onAddRpt
        },'-',{
            ref: '../removeBtn',
            iconCls: 'icon-user-delete',
            //text: '删除报表',
            text: '<span style="line-Height:1">删除报表</span>',
            icon: '../images/uiimages/edit_remove.png',
            disabled: true,
            handler: onDelRpt
        }],

        bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
	        	'change':function(pt,page){
					var code="";
					selRptLen=selectedRptCodes.length;
					var AllRowCnt=store.getCount();
					var selRowCnt=0;					
					for(var i=store.getCount()-1;i>-1;i--){
						code=store.getAt(i).get("RptCfg_Code");
						found=false;
						for(j=selRptLen-1;j>-1;j--){
							if(selectedRptCodes[j]==code) found=true;
						}
						if(found){
							sm.selectRow(i,true,false);
							selRowCnt++;
						}
					}
							
					
					
					var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');
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
        sm: sm,
        columns: [
        new Ext.grid.RowNumberer(),
        sm,        
        {
            id: 'RptCfg_RowID',
            header: 'RowID',
            dataIndex: 'RptCfg_RowID',
            width: 100,
            sortable: true,
            editor: {
                xtype: 'textfield',
                disabled: true,
                allowBlank: true
            },menuDisabled : true
        },{
        	id: 'RptCfg_Code',
            header: '编码',
            dataIndex: 'RptCfg_Code',
            width: 100,
            sortable: true,
            editor: {
                xtype: 'textfield',
                disabled: true,
                allowBlank: true
             },menuDisabled : true
        },{
            //xtype: 'datecolumn',
            header: '名称',
            dataIndex: 'RptCfg_Name',
            width: 250,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: true
            },menuDisabled : true
        },{
            header: '描述',
            id:'RptCfg_Desc',
            dataIndex: 'RptCfg_Desc',
            width: 350,
            sortable: true,
            
            editor: {
                xtype: 'textfield',
                allowBlank: true
            }					//调用 RowEditor.js中的init（）
            ,menuDisabled : true

         }]
    });


		//修改//update : ( Store this, Ext.data.Record record, String operation ) 
  		store.on('update',onUpdate,this);

 		/*
     	store.on('remove',function(record,operation){
  			var rowid=operation.data.RptCfg_RowID;
  			var code=operation.data.RptCfg_Code;
			var url=encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=del&rowid="+rowid);
			dhcwl.mkpi.Util.ajaxExc(url);

  		})                           		
            */
  		
  		
	
 
	store.load({params:{start:0,limit:10}});
        
	grid.getSelectionModel().on('selectionchange', function(sm){
        	grid.removeBtn.setDisabled(sm.getCount() < 1);
        	if (sm.getCount() < 1) {
				var datasetCfgPanel = Ext.getCmp('datasetCfgPanel');
        		datasetCfgPanel.getStore().removeAll();
        	}
    	});
 
	grid.getSelectionModel().on('rowselect', function(sm,rowIndex,r){
       		//grid.removeBtn.setDisabled(sm.getCount() < 1);
        	var datasetCfgPanel = Ext.getCmp('datasetCfgPanel');
        	var url="dhcwl/kpi/kpidatasetcfgdata.csp?action=getNode&code='"+r.get("RptCfg_Code")+"'"+"&treecode='"+r.get("RptCfg_TreeCode")+"'"+"&Criteria="+searchCriteria;   	
        	url=encodeURI(url);   	
        	datasetCfgPanel.store.proxy=new Ext.data.HttpProxy({url:url}); 
    		datasetCfgPanel.store.reload();

    	});
    	
	grid.on('contextmenu',function( e ){
    		e.preventDefault();
    		quickMenu.showAt(e.getXY());
	})		
		
	
    
 	this.getRptCfgPanel=function(){
		return grid;
	}   

	refreshRptCfg=function(){
		var tree=Ext.ComponentMgr.get('cfgTreePanel');
		var selNode = tree.getSelectionModel().getSelectedNode();
		var pcode=selNode.id;
		
		store.proxy=new Ext.data.HttpProxy({url:"dhcwl/kpi/kpirptcfgdata.csp?action=getNode&PCode='"+pcode+"'"}); 
		store.reload();		

	}
	//设置任务区间
	function onRptSecHandle(){
		var s = grid.getSelectionModel().getSelections();
		if (s.length <=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的报表！");    					
			return;
		}
		var rptRowIDs="";
		for(var i=0,r;r=s[i];i++){
			var rptRowID=r.get("RptCfg_RowID");
			if (rptRowIDs!=""){
				rptRowIDs=rptRowIDs+",";
			}
			rptRowIDs=rptRowIDs+rptRowID;
		}
		var maintainSectionTaskObj=new dhcwl.mkpi.MaintainSectionTask();
		var rptSign="report";
		maintainSectionTaskObj.show(rptRowIDs,rptSign);
		
	}
	
	function moduleKpiShow(){
		var s = grid.getSelectionModel().getSelections();
		if (s.length <=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的报表！");    					
			return;
		}
		var rptRowIDs="";
		for(var i=0,r;r=s[i];i++){
			var rptRowID=r.get("RptCfg_Code");
			if (rptRowIDs!=""){
				rptRowIDs=rptRowIDs+",";
			}
			rptRowIDs=rptRowIDs+rptRowID;
		}
		treeCode=s[0].get("RptCfg_TreeCode");
		var rptKpiShowObj=new dhcwl.mkpi.ModuleKpiShow();
		var rptSign="report";
		rptKpiShowObj.show(treeCode,rptRowIDs,"",rptSign);
	}

 	//删除报表
 	function onDelRpt(){
    	Ext.MessageBox.confirm('确认', '删除这个报表会同时删除该报表下的数据集、指标的配置数据。你确定要删除报表吗？', function(id){
                 if (id=="no") {
 	                return;               	
                 }
    	
        editor.stopEditing();
        
        var aryRptCodes=[];
        var aryRptTreeCodes=[];
        var s = grid.getSelectionModel().getSelections();
        for(var i = 0, r; r = s[i]; i++){
        	var rptRowID=r.get("RptCfg_RowID");
        	if (rptRowID!="") {
         		var rptCode=r.get("RptCfg_Code");       		
        		aryRptCodes.push(rptCode);
        		aryRptTreeCodes.push(r.get("RptCfg_TreeCode"));
        	}else{
        		store.remove(r);
        	}
        	
        }      
        if(aryRptCodes.length<=0) return;
        
		var url=encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=del");
		
		var rptCodesStr=aryRptCodes.join(",");
		var treeCodeStr=aryRptTreeCodes[0];
		dhcwl.mkpi.Util.ajaxExc(url,{rptCodes:aryRptCodes.join(","),TreeCode:aryRptTreeCodes[0]},function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					Ext.Msg.alert("提示","删除成功！");
       				for(var i = 0, r; r = s[i]; i++){	
       					store.remove(r);
       				}
       				store.reload();
       				selectedRptCodes=[];
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
    }	
	
  	function onAddRpt(){
        editor.stopEditing();
		var tree=curModuleTree;
		//var tree=Ext.ComponentMgr.get('cfgTreePanel');
		 var selNodes = tree.getChecked();
        
        if(selNodes.length<=0){
			Ext.MessageBox.alert("提示","选择模块后才能新增报表！请先勾选一个模块。");
			return;
		}
		
        if(selNodes.length>1){
			Ext.MessageBox.alert("提示","只能勾选单个模块。");
			return;
		}		
		
    	//var selNode = tree.getSelectionModel().getSelectedNode();
		var selNode = selNodes[0];		
		
		
		//var selNode = tree.getSelectionModel().getSelectedNode();
		//add by wz .2013-11-27
		if (selNode==null) {
			Ext.MessageBox.alert('提示', '选择模块后才能新增报表！');
			return;
		}

		/*
		if (selNode.hasChildNodes()==true) {
			Ext.MessageBox.alert('提示', '该模块含有子模块，不能新增报表！');
			return;
		}			
		*/

        var e = new rptCfgRec({
            RptCfg_RowID: '',
            RptCfg_Code: '',
            RptCfg_Name: '',
            RptCfg_Desc: '',
            RptCfg_TreeCode:selNode.id
        });				
		
		store.insert(0, e);
		grid.getView().refresh();
		grid.getSelectionModel().selectRow(0);
		editor.startEditing(0);
	}
	

    
	function onUpdate(s,record,operation){
		//alert("call update");
		//return;
		//ar rowid=record.get("RptCfg_RowID");
		
		var rowid=record.get("RptCfg_RowID");
		var code=record.get("RptCfg_Code");
		var name=record.get("RptCfg_Name");
		var desc=record.get("RptCfg_Desc");
		var treecode=record.get("RptCfg_TreeCode");
		//var editor2=editor;

		if (code=="" || name=="") {
			Ext.MessageBox.alert("提示","报表编码或名称不能为空！");
			return;
		}
		
		if (code.indexOf(".")>=0 || code.indexOf("||")>=0) {
			Ext.MessageBox.alert("提示","报表编码不能包含字符'.'或'||'！");
			store.un('update',onUpdate,this);			
			record.set("RptCfg_Code","");
			store.on('update',onUpdate,this);
			return;
		}
		
		//return;
		
		
		
		var storeCnt=store.getCount();
		for(var i=0;i<=storeCnt-1;i++){
			var rec=store.getAt(i);
			if (rec==record) continue;
			if(rec.get("RptCfg_RowID")=="") continue;
			if (rec.get("RptCfg_Code")==code) {
				store.un('update',onUpdate,this);
				record.set("RptCfg_Code","");
				Ext.MessageBox.alert("提示","报表编码有重复，请重新输入！");
				store.on('update',onUpdate,this);
				return;
			}
			if (rec.get("RptCfg_Name")==name) {
				store.un('update',onUpdate,this);
				record.set("RptCfg_Name","");
				Ext.MessageBox.alert("提示","报表名称有重复，请重新输入！");
				store.on('update',onUpdate,this);
				return;
			}			
		}
		var url=encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=update&rowid="+rowid+"&code="+code+"&name="+name+"&desc="+desc+"&treecode="+treecode);
		 dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					if (rowid=="") {
						store.un('update',onUpdate,this);
						record.set("RptCfg_RowID",jsonData.ROWID);
						store.on('update',onUpdate,this);
					}
					Ext.Msg.alert("提示","更新成功！");
					Ext.MessageBox.alert("提示","更新成功！");
					store.reload();
					
				}else{
					Ext.Msg.alert("提示","更新失败！");
					}
					
				},this);					
  		}
	var task_CheckDateState={
			run:CreatDateProcess,
			interval:5000
	};
	var textValue={result:2,totalNum:2,root:[{DatasetCfg_RowID:'1',DatasetCfg_Code:'ds3',DatasetCfg_Desc:'ds3',DatasetCfg_RuleList:'K0005:CTLOC.LocDesc,K0773:CTLOC.LocDesc,K0012:CTLOC.LocDesc,K0002:CTLOC.LocDesc',DatasetCfg_FilterList:'K0012:([{CTLOC.LocDesc} \[ 内科一组,内科二组])K0005:([{CTLOC.LocDesc} \[ 内科一组,内科二组])K0002:([{CTLOC.LocDesc} \[ 内科一组,内科二组])K0773:([{CTLOC.LocDesc} \[ 内科一组,内科二组])',DatasetCfg_RptCode:'KSCRZ',DatasetCfg_TreeCode:'root.CRZZBB'},{DatasetCfg_RowID:'3',DatasetCfg_Code:'ds9',DatasetCfg_Desc:'ds9',DatasetCfg_RuleList:'',DatasetCfg_FilterList:'',DatasetCfg_RptCode:'KSCRZ',DatasetCfg_TreeCode:'root.CRZZBB'}]}
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
		//alert();
		//store.proxy=new Ext.data.HttpProxy({url:encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=getNode"+'&Criteria='+searchCriteria)}); 
	}  		

	
 	this.onMmDataHandle=function(startDate,endDate,actFlag,dateSecType){
 		//Ext.MessageBox.alert('call rpt onhandle');
		if (actFlag==-1) {
			menuAct="";
			return;
		}

        var aryRptCodes=[];
        var aryRptTreeCodes=[];
        var s = grid.getSelectionModel().getSelections();
		if (actFlag==1 || actFlag==2) {				        
	        for(var i = 0, r; r = s[i]; i++){
	        	var rptRowID=r.get("RptCfg_RowID");
	        	if (rptRowID!="") {
	         		var rptCode=r.get("RptCfg_Code");       		
	        		aryRptCodes.push(rptCode);
	        		aryRptTreeCodes.push(r.get("RptCfg_TreeCode"));
	        	}
	        }
		}
		/*
        if(aryRptCodes.length<=0) {
 			menuAct="";       
        	return;		
        }
        */
		var rptCodesStr=aryRptCodes.join(",");		
		var url=encodeURI("dhcwl/kpi/kpimodulecfgdata.csp");
		dhcwl.mkpi.Util.ajaxExc(url,
			{
				action:'mmHandleData',
				Criteria:searchCriteria,
				treeNodes:aryRptTreeCodes[0],
				rptCodes:rptCodesStr,
				KPICodes:handleKpis,
				startDate:startDate,
				menuAct:menuAct,
				endDate:endDate,
				actFrom:'report',
				actFlag:actFlag	,//1:冲突检查；2：直接进行数据操作；3：根据冲突检查返回的KPI进行数据操作。
				dateSecType:dateSecType
			},
			function(jsonData){

				if(actFlag==2 ||actFlag==3) {
					if(jsonData.success==true && jsonData.tip=="ok"){
						if(menuAct=="cleanData"){
							Ext.Msg.alert("提示","操作成功！");
						}else{
							moduleDataFlag=jsonData.dataFlag
							Ext.MessageBox.progress("请稍后");
							Ext.TaskMgr.start(task_CheckDateState);
						}
						//Ext.Msg.alert("提示","操作成功！");

					}else{
						Ext.Msg.alert("提示","操作失败！");
					}
					handleKpis="";
				}else{
					try{
						var inputKpiList=jsonData.root;
						mmSEDateCfgObj.getCheckGrid().getStore().loadData(inputKpiList);	
						handleKpis=jsonData.kpiCodes;

					}catch(e){
						Ext.Msg.alert("提示","操作失败！");
						return;
					}										
				}
					
				},this);	

	}	

	function onExport(ExpFlag) {
        var aryRptCodes=[];
        var aryRptTreeCodes=[];
        var s = grid.getSelectionModel().getSelections();
        for(var i = 0, r; r = s[i]; i++){
        	var rptRowID=r.get("RptCfg_RowID");
        	if (rptRowID!="") {
         		var rptCode=r.get("RptCfg_Code");       		
        		aryRptCodes.push(rptCode);
        		aryRptTreeCodes.push(r.get("RptCfg_TreeCode"));
        	}
        }      
        if(aryRptCodes.length<=0) {
 			menuAct="";       
        	return;		
        }
		var rptCodesStr=aryRptCodes.join(",");         
        var ret="";
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',
		{action:'ExportModuleToXML',treeCodes:aryRptTreeCodes[0],reportCodes:rptCodesStr,actFrom:'report',Criteria:searchCriteria},  
		function(responseText){
			//alert(responseText);
			if(responseText){
				ret=dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+'outputRpt.rpt',dhcwl.mkpi.Util.trimLeft(responseText));
				//if (ret!="") Ext.MessageBox.alert("提示","导出成功！");
			}else{
				Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
			}
		}
		,outThis,true);
		if (ExpFlag==0){
			dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',
					{action:'getFileContent',treeCodes:aryRptTreeCodes[0],reportCodes:rptCodesStr,actFrom:'report',Criteria:searchCriteria},
					function(responseText){
						//alert("responseText="+responseText);
						
						if(responseText){
							var ret1=dhcwl.mkpi.Util.writeFile1(ret,dhcwl.mkpi.Util.nowDateTime()+'outputKpis.kpi',dhcwl.mkpi.Util.trimLeft(responseText));
							if ((ret!="")&&(ret1!="")) Ext.MessageBox.alert("提示","导出成功！");
						}else{
							Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
						
					}
					,outThis,true,null);
		}
		if (ExpFlag==1){
			dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',
					{action:'getFileContentExpDim',treeCodes:aryRptTreeCodes[0],reportCodes:rptCodesStr,actFrom:'report',Criteria:searchCriteria},
					function(responseText){
						//alert("responseText="+responseText);
						
						if(responseText){
							var ret1=dhcwl.mkpi.Util.writeFile1(ret,dhcwl.mkpi.Util.nowDateTime()+'outputKpis.kpi',dhcwl.mkpi.Util.trimLeft(responseText));
							if ((ret!="")&&(ret1!="")) Ext.MessageBox.alert("提示","导出成功！");
						}else{
							Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
						
					}
					,outThis,true,null);
		}
	} 	

	function onKPIHandle() {
		var s = grid.getSelectionModel().getSelections();
		if (s.length <=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的报表！");    					
			return;
		}
		if (mmSEDateCfgObj==null) {
			//mmSEDateCfgObj=new dhcwl.mkpi.KpiMMgrSEDateCfg();
			Ext.MessageBox.alert("弹出窗口对象：dhcwl.mkpi.KpiMMgrSEDateCfg有错误。");
		}
		if(menuAct=="produceData") {
			mmSEDateCfgObj.setCheckGroupHide(true);
		}
		else {
			mmSEDateCfgObj.setCheckGroupHide(false);
		}		
		mmSEDateCfgObj.setParentPanel(outThis);
		
		if(menuAct=="cleanData") {
			mmSEDateCfgObj.setDateSecTypeHide(false);
		}else{
			mmSEDateCfgObj.setDateSecTypeHide(true);
		}	
		
		mmSEDateCfgObj.show(); 

	}
	
	this.setSEDateCfgObj=function(seDateCfgObj)
	{
		mmSEDateCfgObj=seDateCfgObj;
	}	

	
function onActivateKPITask(){
		var selRpts = grid.getSelectionModel().getSelections();
		if (selRpts.length <=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的报表！");    					
			return;
		}
		
		var rptCodes="";
		for (var i=0;i<=selRpts.length-1;i++){
			if (rptCodes=="") {
				rptCodes=selRpts[i].get("RptCfg_Code");
			}else{
				rptCodes=rptCodes+','+selRpts[i].get("RptCfg_Code");
			}
		}
		var treeCode=selRpts[0].get("RptCfg_TreeCode");
		//return;
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',{
				action:'ActivateKPITask',
				treeCodes:treeCode,
				rptNodes:rptCodes,
				actFrom:'report'
			},  
			function(jsonData){
				grid.body.unmask(); 
				if(jsonData.success==true && jsonData.tip=="ok"){
					Ext.Msg.alert("提示","操作成功！");
	
				}else{
					Ext.Msg.alert("提示","操作失败！");
				}			
	
			}
			,outThis);		
		grid.body.mask("数据处理中，请稍等");  
	}
	
	function onStopKPITask(){
		var selRpts = grid.getSelectionModel().getSelections();
		if (selRpts.length <=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的报表！");    					
			return;
		}
		
		var rptCodes="";
		for (var i=0;i<=selRpts.length-1;i++){
			if (rptCodes=="") {
				rptCodes=selRpts[i].get("RptCfg_Code");
			}else{
				rptCodes=rptCodes+','+selRpts[i].get("RptCfg_Code");
			}
		}
		var treeCode=selRpts[0].get("RptCfg_TreeCode");
		
		 var actTaskWin=new dhcwl.mkpi.showkpidata.ActivateTaskPrompt();
		 actTaskWin.setParentWin(outThis);
		 actTaskWin.setSelNodes(treeCode,rptCodes,"","report");
		 actTaskWin.show();
		 
	}	
	
	this.clearSel=function(){
		selectedRptCodes=[];
	}
	
	this.setDSObj=function(DSObj){
		datasetCfgObj=DSObj;
	}
	
	this.setModuleTree=function(tree){
		curModuleTree=tree
	}
}
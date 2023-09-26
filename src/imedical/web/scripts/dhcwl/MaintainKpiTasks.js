(function(){
	Ext.ns("dhcwl.mkpi.MaintainKpiTasks");
})();
dhcwl.mkpi.MaintainKpiTasks=function(){
	var getTaskInfoUrl='dhcwl/kpi/taskserver.csp'
	var outThis=this;
	var choiceKpiCode="",kpiSectionName;
	var columnModelKpi = new Ext.grid.ColumnModel([
        {header:'编码',dataIndex:'kpiCode', width: 70, sortable: true ,menuDisabled : true
        },{header:'指标名称',dataIndex:'kpiName', width: 80, sortable: true ,menuDisabled : true
        },{header:'维度',dataIndex:'dimType',resizable:'true',width:88,menuDisabled : true
        },{header:'类型',dataIndex:'category',resizable:'true',width:88,menuDisabled : true
        },{header:'区间',dataIndex:'section',resizable:'true',width:88,menuDisabled : true
        }
    ]);
    //定义指标的存储模型
    var storeKpi = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=TASK&date='+dhcwl.mkpi.Util.nowDateTime()}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'kpiCode'},
            	{name: 'kpiName'},
            	{name: 'dimType'},
            	{name: 'category'},
            	{name: 'section'}
       		]
    	})
    });

	//定义指标的显示表格。
	var choicedSearcheCond="", searcheValue="";
	var kpiList = new Ext.grid.GridPanel({
        frame:true,   
        //border:false,		
        id:"kpiTables",
        enableColumnResize :true,
        store: storeKpi,
        cm: columnModelKpi,
        autoScroll: true,
        bbar:new Ext.PagingToolbar({
            pageSize: 50,
            store: storeKpi,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
	        	'beforechange':function(pt,page){
	        		//alert("test");
	        		storeKpi.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue));//+"&start=0&limit=50"));
		            //storeKpi.load();
		            //kpiList.show();
	        	}
            }
        }),
        tbar: new Ext.Toolbar(
        /*
        [ '按条件快速搜索：',{
    		xtype : 'compositefield',
        	anchor: '-20',
       	 	msgTarget: 'side',
        	items : [{
	        	id:'searchCond2',
	        	width: 100,
				xtype:'combo',
	        	mode:'local',
	        	emptyText:'请选择搜索类型',
	        	triggerAction:  'all',
	        	forceSelection: true,
	        	editable: false,
	        	displayField:'value',
	        	valueField:'name',
	        	store:new Ext.data.JsonStore({
	        		fields:['name', 'value'],
	            	data:[
	            		{name : 'Code',   value: '指标代码'},
	                	{name : 'Name',  value: '指标名称'},
	                	{name : 'Sec', value: '指标区间'},
	                	{name : 'Dim',  value: '指标维度'},
	                	{name : 'FL', value: '指标类型'},
	                	{name : 'ACTIVE', value: '是否激活'}
	             	]}),
	             	listeners:{
	        			'select':function(combo){
	        				//alert("combo="+combo.getValue()+"  "+combo.getRawValue())
	        				choicedSearcheCond=combo.getValue();//ele.getValue();
	        			}
	        		}
	         	}, {
	        		xtype: 'textfield',
	            	width:300,
	            	flex : 1,
	            	id:'taskSearcheContValue',
	            	enableKeyEvents: true,
	            	//name : 'searcheContValue',
	            	allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
	            			searcheValue=Ext.get("taskSearcheContValue").getValue();//ele.getValue();
	            			if(choicedSearcheCond=="ACTIVE"){
	            				searcheValue=((searcheValue=="Y")||(searcheValue=="y")||(searcheValue=="是")?"Y":((searcheValue==null||searcheValue=="")?"":"N"));
	            			}
	            			if ((event.getKey() == event.ENTER)){
	            				//alert("searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue);
	            				storeKpi.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&limit=50"));
	            				storeKpi.load();
	            				kpiList.show();
	            			}
	            		}
	            	}
	        	}
        	]}
        ]
        */
        
		{
        	layout: 'hbox',
    		xtype : 'compositefield',
        	items : [
        		'查找：',
				{
	        	id:'searchCond2',
	        	width: 100,
				xtype:'combo',
	        	mode:'local',
	        	emptyText:'请选择搜索类型',
	        	triggerAction:  'all',
	        	forceSelection: true,
	        	editable: false,
	        	displayField:'value',
	        	valueField:'name',
	        	store:new Ext.data.JsonStore({
	        		fields:['name', 'value'],
	            	data:[
	            		{name : 'Code',   value: '指标代码'},
	                	{name : 'Name',  value: '指标名称'},
	                	{name : 'Sec', value: '指标区间'},
	                	{name : 'Dim',  value: '指标维度'},
	                	{name : 'FL', value: '指标类型'},
	                	{name : 'ACTIVE', value: '是否激活'}
	             	]}),
	             	listeners:{
	        			'select':function(combo){
	        				//alert("combo="+combo.getValue()+"  "+combo.getRawValue())
	        				choicedSearcheCond=combo.getValue();//ele.getValue();
	        			}
	        		}
	         	}, {
	        		xtype: 'textfield',
	            	width:300,
	            	flex : 1,
	            	id:'taskSearcheContValue',
	            	enableKeyEvents: true,
	            	//name : 'searcheContValue',
	            	allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
	            			searcheValue=Ext.get("taskSearcheContValue").getValue();//ele.getValue();
	            			if(choicedSearcheCond=="ACTIVE"){
	            				searcheValue=((searcheValue=="Y")||(searcheValue=="y")||(searcheValue=="是")?"Y":((searcheValue==null||searcheValue=="")?"":"N"));
	            			}
	            			if ((event.getKey() == event.ENTER)){
	            				//alert("searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue);
	            				storeKpi.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&limit=50"));
	            				storeKpi.load();
	            				kpiList.show();
	            			}
	            		}
	            	}
	        	}        		
        	]}           
        

        ),
        listeners :{
        	'click':function(ele,event){
        		var sm=kpiList.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var kpiCode=record.get("kpiCode");
                kpiSectionName=record.get("section");
                if(!kpiCode) {
                	kpiCode="";
                	choiceKpiCode=kpiCode;
                	return;
                }
                choiceKpiCode=kpiCode;
                dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+'?action=list-kpiExc&kpiCode='+kpiCode
                ,null,function(jsonData){
                	if(!jsonData){
                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
                	}
                	if(jsonData.success==true){
                		var kpiExcForm=outThis.getKpiExcCodeForm();
                		var taskSecGrid=outThis.getTaskSectionExcListGrid();
                		var form=kpiExcForm.getForm();
                		var info=jsonData.info;
    					form.setValues({kpiRunCode:info.kpiExc});  //设置kpi执行代码
    					//form.setValues({dimExc:info.dimExc});
    					//更新任务代码列表
						try{
							var store=taskSecGrid.getStore();
							//store.proxy.url=encodeURI('dhcwl/kpi/taskServer.CSP?action=list-kpiTaskExc&kpiCode='+kpiCode2);
							store.proxy.setUrl(encodeURI('dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc&kpiCode='+kpiCode));
							store.load();
    						taskSecGrid.show();
						}catch(e){
							Ext.Msg.show({title:'错误',msg:"Sorry，处理任务列表出错了！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
							
						}
                	}else{
                		
                	}
                },outThis);
        	}
        }
    });
    storeKpi.on('beforeload',function(){
		//storeKpi.baseParams = {searcheCond:choicedSearcheCond, searcheValue:searcheValue};
	});
	storeKpi.load({params:{start:0,limit:50,mark:'TASK'}});	
	
    //if(null==dhcwl_mkpi_executeCodeWin){
    	//dhcwl_mkpi_executeCodeWin=new dhcwl.mkpi.TaskExectCode();
    	//dhcwl_mkpi_executeCodeWin.setParentWin(this);
    //}
    //var executeCodeWin=new dhcwl.mkpi.TaskExectCode();
    //executeCodeWin.setParentWin(this);
    var activeFlagCombo=new Ext.form.ComboBox({
		width : 150,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		//fieldLabel : '是否从指定global获得指标数据',
		value:'否',
		name : 'globalFlagCombo',
		displayField : 'isGlobal',
		valueField : 'isGlobalV',
		store : new Ext.data.JsonStore({
			fields : ['isGlobal', 'isGlobalV'],
			data : [{
				isGlobal : '否',
				isGlobalV : 'N'
			}, {
				isGlobal : '是',
				isGlobalV : 'Y'
			}]}),
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:12px;">' +   
			'{isGlobal}' +   
			'</div>'+   
			'</tpl>',				
		listeners :{
			'select':function(combox){
				activeFlagCombo.setValue(combox.getValue());
			}
		}
	});
	//是否默认激活指标任务,从服务器端取数据
	var recordActiveFlag=Ext.data.Record.create([
    	{name: 'disValue'},
		{name: 'realValue'}
	]);
	var globalActiveFlagCombo=new Ext.form.ComboBox({
		width : 150,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//fieldLabel : '是否从指定global获得指标数据',
		displayField : 'disValue',
		valueField : 'realValue',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:12px;">' +   
			'{disValue}' +   
			'</div>'+   
			'</tpl>',	
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/sysvarcfg.csp?action=getGlobalTaskActiveFlag'}),
			reader:new Ext.data.JsonReader({
				totalProperty: 'totalNums',
				root: 'root',
				fields:recordActiveFlag
			})
		}),
		listeners :{
			'select':function(combox){
				globalActiveFlagCombo.setValue(combox.getValue());
			}
		}
	});
	
    var sm=new Ext.grid.RowSelectionModel({singleSelect:true});
    var executeCodeField=new Ext.form.TextField({
    	name:'executeCodeField',
    	listeners:{
    		'focus':function(field,eve){
    			if(null==dhcwl_mkpi_executeCodeWin){
    				dhcwl_mkpi_executeCodeWin=new dhcwl.mkpi.TaskExectCode();
    				dhcwl_mkpi_executeCodeWin.setParentWin(outThis);
    			}
				var record=sm.getSelected();
				execCodeSubType=record.get('SecCode');
				dhcwl_mkpi_executeCodeWin.setExecCodeType('TAS',execCodeSubType);
    			dhcwl_mkpi_executeCodeWin.showWin();
    		}
    	}
    });
    var columnModelTask=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :80,menuDisabled : true
        },
        columns: [new Ext.grid.RowNumberer(),{
            header: '任务区间编码',
            dataIndex: 'SecCode',
            id:'SecCode'
        }, {
            header: '任务区间名称',
            dataIndex: 'SecName'
        }, {
            header: '任务区间执行代码',
            dataIndex: 'DTaskExcuteCode',
            width:160,
            editor:new Ext.grid.GridEditor(executeCodeField)
        }, {
            header: '运行时任务区间执行代码语句',
            dataIndex: 'DTaskExcuteCodeTip',
            width:180
        }, {
            //xtype: 'checkcolumn',
            header: '是否激活?',
            dataIndex: 'DTaskActiveFlag',
            editor:new Ext.grid.GridEditor(activeFlagCombo)//new Ext.form.TextField({}))
        }]
    });
    var storeTask = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNums',
            root: 'root',
        	fields:[
            	{name: 'SecCode'},
            	{name: 'SecName'},
            	{name: 'DTaskExcuteCode'},
            	{name: 'DTaskExcuteCodeTip'},
            	{name: 'DTaskActiveFlag'}
       		]
    	})
    });
    var RecordTask = Ext.data.Record.create([
    	{name: 'SecCode'},
        {name: 'SecName'},
        {name: 'DTaskExcuteCode'},
        {name: 'DTaskExcuteCodeTip'},
        {name: 'DTaskActiveFlag'}
    ]);
    var taskSectionExcListGrid=new Ext.grid.EditorGridPanel({
    	id:'dhcwl.mkpi.MaintainKpiTasks.GridPanel',
        title: '任务区间代码列表',
        frame: true,
        clicksToEdit: 1,
        store: storeTask,
        cm: columnModelTask,
        sm:sm,
        //autoExpandColumn:'DTaskActiveFlag',
        autoExpandColumn: 'SecCode', // column with this id will be expanded
        tbar: [{
            //text: '新增区间任务',
            text: '<span style="line-Height:1">新增区间任务</span>',
            icon: '../images/uiimages/edit_add.png',
            handler : function(){
				globalActiveFlagCombo.getStore().load();
				if(!choiceKpiCode||choiceKpiCode==""){
            		Ext.Msg.show({title:'错误',msg:"请先选择要维护的指标！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
            	if(!kpiSectionName||kpiSectionName==""){
            		Ext.Msg.show({title:'错误',msg:"该指标还没有设置指标区间类型，不能添加区间任务！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
            	//alert(choiceKpiCode);
            	dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+'?action=getSectionMaxToMin&kpiCode='+choiceKpiCode
                ,null,function(jsonData){
                	var taskExcList={D:"CreatYesterdayData^DHCWLAutoCreatMKPIData",HY:"",Q:"CreatLastQuaDateAt01^DHCWLAutoCreatMKPIData",M:"CreatLastMonDataAt1^DHCWLAutoCreatMKPIData",Y:"CreatLastYearDataAt0101^DHCWLAutoCreatMKPIData"};
                	if(!jsonData){
                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
                	}
                	if(jsonData.success==true){
                		var isEnforce=jsonData.isEnforce;
                		if(isEnforce!=1){
                			Ext.Msg.show({title:'错误',msg:"指标区间维护顺序关系不正确，请维护好后在添加任务！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
                		}
                		var secList=jsonData.secList;
                		var maxSec=secList.length,isBlank=true,minFlag=false,minSecIndex=0;
                		//以下为找出当前最大区间
                		for(var k=secList.length-1;k>=0;k--){
                			minFlag=true;
                			for(var i=storeTask.getCount()-1;i>=0;i-- ){
                				var rd=storeTask.getAt(i);
                				var sec=rd.get("SecCode");
                				if(sec!=null){
                					if(secList[k].SecCode==sec){
                						minFlag=false;
                						break;
                					}
                				}
                			}
                			if(minFlag){
                				minSecIndex=k;
                				break;
                			}
                		}
                		if(!minFlag){
                			for(var i=storeTask.getCount()-1;i>=0;i-- ){
                				var rd=storeTask.getAt(i);
                				var sec=rd.get("SecCode");
                				if(sec!=null){
                					for(var j=secList.length-1;j>=0;j--){
                						if(secList[j].SecCode==sec){
                							if(j<maxSec) maxSec=j;
                							break;
                						}
                					}
                				}
                				isBlank=false;
                			}
                		}else{
                			maxSec=minSecIndex+1;
                		}
                		maxSec--; //新加区间为找出最大区间加一
                		if(maxSec<0){
                			Ext.Msg.show({title:'提示！',msg:"当前指标任务已经达到最大区间了，不能再新建了！",icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
                			return;
                		}
                		//var choiceWin=dhcwl.mkpi.ChoiceWindow({test:'test',hello:'hello'},true);
                		//alert("选择后返回的值为："+choiceWin.getValue());
                		if(secList[maxSec]){
							var record=globalActiveFlagCombo.getStore().getAt(0);
							var activeFlag="N";
							if (!!record) {
								activeFlag=record.get('realValue');
							}
							
							var secDefExe=taskExcList[secList[maxSec].SecCode];
							if(secList[maxSec].SecDefExe !="") secDefExe=secList[maxSec].SecDefExe;
							//alert(secDefExe);
                			//var initV={SecCode:(secList[maxSec].SecCode),SecName:(secList[maxSec].SecName),DTaskExcuteCode:(taskExcList[secList[maxSec].SecCode]),DTaskExcuteCodeTip:("s monthId="+taskExcList[secList[maxSec].SecCode]+"()"),DTaskActiveFlag:activeFlag};
                			var initV={SecCode:(secList[maxSec].SecCode),SecName:(secList[maxSec].SecName),DTaskExcuteCode:(secDefExe),DTaskExcuteCodeTip:("s monthId="+taskExcList[secList[maxSec].SecCode]+"()"),DTaskActiveFlag:activeFlag};

                			storeTask.insert(0,new RecordTask(initV));
                		}
                	}else{
                		
                	}
                },outThis);
                
            }
        },"-",{
            //text: '顺序删除区间任务',
        	text: '<span style="line-Height:1">顺序删除区间任务</span>',
            icon: '../images/uiimages/edit_remove.png',
            handler : function(){
                if(!choiceKpiCode||choiceKpiCode==""){
            		Ext.Msg.show({title:'错误',msg:"请先选择要维护的指标！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
            	if(!kpiSectionName||kpiSectionName==""){
            		Ext.Msg.show({title:'错误',msg:"该指标还没有设置指标区间类型，不能执行删除操作！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
            	dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+'?action=deleteTaskOS&kpiCode='+choiceKpiCode
                ,null,function(jsonData){
                	if(!jsonData){
                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
                	}
                	if(jsonData.success){
                		var deleteSec=jsonData.deleteSec;
                		for(var i=storeTask.getCount()-1;i>=0;i-- ){
                			var rd=storeTask.getAt(i);
                			var sec=rd.get("SecCode");
                			if(sec==deleteSec){
                				storeTask.removeAt(i);
                				Ext.Msg.show({title:'处理成功！',msg:"指标任务区间"+sec+"删除成功！",icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
                				break;
                			}
                		}
                		storeTask.proxy.setUrl(encodeURI('dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc&kpiCode='+choiceKpiCode));
						storeTask.load();
    					taskSectionExcListGrid.show();
                	}else{
                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
                	}
                },outThis);
            }
        },"-",{
            //text: '保存修改',
        	text: '<span style="line-Height:1">保存修改</span>',
            icon: '../images/uiimages/filesave.png',
            handler : function(){
            	if(!choiceKpiCode||choiceKpiCode==""){
            		Ext.Msg.show({title:'错误',msg:"请先选择要维护的指标！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
                var paras="kpiCode="+choiceKpiCode,taskList="";
                for(var i=storeTask.getCount()-1;i>=0;i-- ){
                	var rd=storeTask.getAt(i);
                	var sec=rd.get("SecCode");
                	var exc=rd.get("DTaskExcuteCode");
                	var flag=rd.get("DTaskActiveFlag");
                	if(exc) exc=exc.trim();
                	if(flag) flag=flag.trim();
                	if(!exc) exc="";
                	if(!flag) flag="";
                	exc.trim();
                	taskList=taskList+"@"+sec+"||"+exc+"||"+flag
                }
                paras+="&taskList="+taskList.substring(1,taskList.length);
                //alert(paras);
                //return;
                dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+"?action=addKpiTask&"+paras);
                storeTask.proxy.setUrl(encodeURI('dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc&kpiCode='+choiceKpiCode));
				storeTask.load();
    			taskSectionExcListGrid.show();
            }
        },"-",{
            //text: '激活全部任务',
        	text: '<span style="line-Height:1">激活全部任务</span>',
            icon: '../images/uiimages/ok.png',
            handler : function(){
            	if(!choiceKpiCode||choiceKpiCode==""){
            		Ext.Msg.show({title:'错误',msg:"请先选择要维护的指标！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            		return;
            	}
                var paras="kpiCode="+choiceKpiCode,taskList="";
                for(var i=storeTask.getCount()-1;i>=0;i-- ){
                	var rd=storeTask.getAt(i);
                	var sec=rd.get("SecCode");
                	var exc=rd.get("DTaskExcuteCode");
                	var flag=rd.get("DTaskActiveFlag");
                	taskList=taskList+"@"+sec+"||"+exc+"||Y"
                }
                paras+="&taskList="+taskList.substring(1,taskList.length);
                dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+"?action=addKpiTask&"+paras);
                storeTask.proxy.setUrl(encodeURI('dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc&kpiCode='+choiceKpiCode));
				storeTask.load();
    			taskSectionExcListGrid.show();
            }
        }/*,"-",{
            text: '删除选中任务',
            handler : function(){
            	
            	if(sm.getCount()==0){
            		alert("请选中任务后在删除！");
            		return;
            	}
            	var taskSec=sm.getSelected().get("SecCode");
                dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+"?action=deleteTask&kpiCode="+choiceKpiCode+'&secCode='+taskSec);
                storeTask.proxy.setUrl(encodeURI('dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc&kpiCode='+choiceKpiCode));
				storeTask.load();
    			taskSectionExcListGrid.show();
            }
        }*/]
    });
    var taskAndExeCodeForm=new Ext.FormPanel({
        	title		  : '指标执行代码详细',
        	labelWidth	  : 125,
        	defaults	  : {width: 360, border:false},
        	bodyStyle	  :'padding:5px',
        	defaultType: 'textfield',
        	frame: true,
        	/*
        	style: {
             	"margin-left": "10px", // when you add custom margin in IE 6...
            	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
        	},*/
    		items: [{
    			id:'kpiRunCode',
            	fieldLabel: '指标执行代码',
            	//titile:'该代码作用是根据参数日期id,和指标id返回符合指标范围内的数据。',
                name: 'kpiExc',
                enableKeyEvents: true
            }/*{
            	id:'kpiRunCodeTip',
            	name:'kpiRunCodeTip',
            	width:500,
            	fieldLabel:'运行中拼接成的调用代码',
            	disabled:true
            },{
    			id:'dimExc',
            	fieldLabel: '维度执行代码',
            	//titile:'该代码作用是根据参数日期id,和指标id返回符合指标范围内的数据。',
                name: 'dimExc',
                disabled:true,
                enableKeyEvents: true
            }*//*,{
            	id:'dimExcTip',
            	name:'dimExcTip',
            	width:500,
            	fieldLabel:'运行中拼接成的调用代码',
            	disabled:true
            }*/],
            tbar: new Ext.Toolbar([{
            	//text: '保存更新',
            	text: '<span style="line-Height:1">保存更新</span>',
            	icon: '../images/uiimages/filesave.png',
            	handler: function(){
            		if(!choiceKpiCode||choiceKpiCode==""){
            			Ext.Msg.show({title:'错误',msg:"请先选择要维护的指标！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            			return;
            		}
            		
            		var kpiExc=taskAndExeCodeForm.getForm().findField('kpiExc').getValue();
					//var kpiExc=Ext.get('kpiExc').getValue();
					if(kpiExc)kpiExc=kpiExc.trim();
					//if(dimExc)dimExc=dimExc.trim();
					//if(kpiExc){
						var paras='kpiCode='+choiceKpiCode+'&kpiExc='+kpiExc;//+'&dimExc='+dimExc;
						dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+'?action=saveExecuteCode&'+paras);
					//}
            	}
        	}])
    	}
    );
    /*var taskPanel=new Ext.Panel({
    	id:'dhcwl.mkpi.MaintainKpiTasks.taskPanel',
    	title:'任务设置和执行代码维护',
    	layout:'column',
        items: [{
        	columnWidth: .4,
            items:kpiList,
            height:700,
            layout:'fit'
        },{
            columnWidth: .6,
            height:700,
        	layout: 'fit',
			items:taskSectionExcListGrid
        	items:[{
        		height:110,
				items:taskAndExeCodeForm,
				layout:'fit'
        	},{
         		height:590,
				items:taskSectionExcListGrid,
				layout:'fit'
        	}]

    	}]

    });*/
	
	
	
	
	var taskPanel =new Ext.Panel ({ //Viewport({
    	//title:'分组归集维护',
		id:'dhcwl.mkpi.MaintainKpiTasks.taskPanel',
    	title:'任务设置',
		layout: {
			type: 'hbox',
			pack: 'start',
			align: 'stretch'
		},
		
    	defaults: { border :false},
        items: [{ 
			border :false,
			flex:0.4,
			layout:"fit",
            items:kpiList
    	},{
			border :false,
			flex:0.6,
			layout:"fit",
            items:taskSectionExcListGrid
        }]
    });	
	
	
    
    taskPanel.on('afterrender',function( th ){
    	//Ext.Msg.alert("tip","after render");
 		//storeKpi.load({params:{start:0,limit:50,mark:'TASK'}});    	
	})	;
    this.getTaskPanel=function(){
		globalActiveFlagCombo.getStore().load();
    	return taskPanel;
    }
    this.getKpiListGrid=function(){
    	return kpiList;
    }
    this.getTaskSectionExcListGrid=function(){
    	return taskSectionExcListGrid;
    }
    this.getKpiExcCodeForm=function(){
    	return taskAndExeCodeForm;
    }
    this.refresh=function(){
    	storeKpi.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?onePage=1&limit=50&start=0"));
	    storeKpi.load();
	    kpiList.show();
    }
    this.setSelectValue=function(value){
    	var rd=sm.getSelected();
    	rd.set('DTaskExcuteCode',value);
    	//executeCodeField.setValue(value);
    }
    this.filterKpi=function(kpiCode){
    	storeKpi.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&searcheCond=Code&searcheValue="+kpiCode+"&start=0&&limit=50&onePage=1"));
	    storeKpi.load();
	    kpiList.show();
    }
}
//dhcwl.mkpi.MaintainKpiTasks.prototype
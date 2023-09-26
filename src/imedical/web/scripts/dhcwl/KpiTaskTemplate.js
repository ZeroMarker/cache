dhcwl.mkpi.KpiTaskTemplate=function(){
	
	var getTaskInfoUrl='dhcwl/kpi/taskserver.csp'
	var theTemplateKpiId="";
	var outThis=this;
	var activeFlagCombo=new Ext.form.ComboBox({
		id:'KpiTaskTemplateActiveCombo',
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
		id:'globalActiveFlagCombo',
		width : 150,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//fieldLabel : '是否从指定global获得指标数据',
		displayField : 'disValue',
		valueField : 'realValue',
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
            dataIndex: 'SecCode'//,
            //editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            header: '任务区间名称',
            dataIndex: 'SecName'//,
            //editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            header: '任务区间执行代码',
            dataIndex: 'DTaskExcuteCode',
            width:260,
            editor:new Ext.grid.GridEditor(executeCodeField)
        }, {
            header: '运行时任务区间执行代码语句',
            dataIndex: 'DTaskExcuteCodeTip',
            width:200//,
            //editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            //xtype: 'checkcolumn',
            header: '是否激活?',
            dataIndex: 'DTaskActiveFlag',
            editor:new Ext.grid.GridEditor(activeFlagCombo)//new Ext.form.TextField({}))
			//editor:new Ext.grid.GridEditor(globalActiveFlagCombo)
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
    	id:'dhcwl.mkpi.KpiTaskTemplate.GridPanel',
        frame: true,
        clicksToEdit: 1,
        store: storeTask,
        cm: columnModelTask,
        sm:sm,
        //autoExpandColumn: 'SecCode', // column with this id will be expanded
        width:600,
        height:550,/*
		bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: storeTask,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
             listeners :{
				'change':function(pt,page){
					//outThis.show();
					storeTask.proxy.setUrl(encodeURI("dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc&kpiCode="+theTemplateKpiId));
				}
			}
        }),*/
        tbar: [{
            //text: '新增',
            text: '<span style="line-Height:1">新增</span>',
            icon: '../images/uiimages/edit_add.png',
            handler : function(){
				globalActiveFlagCombo.getStore().load();
				var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
            	if(!selectedKpiIds||selectedKpiIds.length==0){
            		alert("请选择要设置的指标！");
            		return;
            	}
            	var choiceKpiCode=selectedKpiIds[0];
            	var choiceKpiListStr=selectedKpiIds.join(",");
            	dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+'?action=getSectionMaxToMin&kpiCode='+choiceKpiCode
                ,{"choiceKpiListStr":choiceKpiListStr},function(jsonData){
                	var taskExcList={D:"CreatYesterdayData^DHCWLAutoCreatMKPIData",HY:"",Q:"CreatLastQuaDateAt1^DHCWLAutoCreatMKPIData",M:"CreatLastMonDataAt1^DHCWLAutoCreatMKPIData",Y:"CreatLastYearDataAt0101^DHCWLAutoCreatMKPIData"};
                	if(!jsonData){
                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                		return;
                	}
                	if(jsonData.success==true){
                		var isEnforce=jsonData.isEnforce;
                		if(jsonData['sectionConfigFlag']){
                			Ext.Msg.show({title:'错误',msg:"指标ID:"+jsonData['wrongKpi']+"没有配置区间，无法维护指标任务！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                			return;
                		}
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
							var record=Ext.getCmp('globalActiveFlagCombo').getStore().getAt(0);
							var activeFlag="";
							if (!!record) {
								activeFlag=record.get('realValue');
							}
							var initV={SecCode:(secList[maxSec].SecCode),SecName:(secList[maxSec].SecName),DTaskExcuteCode:(taskExcList[secList[maxSec].SecCode]),DTaskExcuteCodeTip:("s monthId="+taskExcList[secList[maxSec].SecCode]+"()"),DTaskActiveFlag:activeFlag};
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
            	if(storeTask.getCount()<=0){
            		return;
            	}
            	var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
            	if(!selectedKpiIds||selectedKpiIds.length==0){
            		alert("请选择要设置的指标！");
            		return;
            	}
            	var taskSec=""
				Ext.Msg.confirm("删除","删除选定的任务数据,确定删除吗？", function(btn){
					if ('yes' == btn)
					{
						dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl,
						{action:'deleteTaskTemplate',kpiIds:selectedKpiIds.join(","),secCode:taskSec},
						function(jsonData){
						//	alert(jsonData.tip);
							if (("ok"!=jsonData.tip)&&("OK"!=jsonData.tip)){
								Ext.Msg.alert("提示",jsonData.tip);						
							}else{
								storeTask.removeAt(0);
								/*
								storeTask.proxy.setUrl(encodeURI('dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc&kpiCode='+selectedKpiIds));
								storeTask.load();
								taskSectionExcListGrid.show();
								*/
							}
						});

					}
                });
            }
        },"-",{
           // text: '保存',
            text: '<span style="line-Height:1">保存</span>',
            icon: '../images/uiimages/filesave.png',
            handler : function(){
            	var taskList="";
            	var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
            	if(!selectedKpiIds||selectedKpiIds.length==0){
            		alert("请选择要设置的指标！");
            		return;
            	}
            	if(storeTask.getCount()<=0){
            		alert("无数据可保存！");
            		return;
            	}
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
                var paras=taskList.substring(1,taskList.length);
                dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl
                ,{
                	action:'addKpiTaskTemplate',
                	kpiIds:selectedKpiIds.join(","),
                	taskList:paras
                },function(jsonData){
                	if (("ok"!=jsonData.tip)&&("OK"!=jsonData.tip)){
                		alert("保存任务出错，错误："+jsonData.tip);
                	}else{
		                storeTask.proxy.setUrl(encodeURI('dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc&kpiCode='+selectedKpiIds));
						storeTask.load();
						taskSectionExcListGrid.show();                	
	                	alert("保存成功！");
                	}
                }
                );

            }
        }]
    });
	
    var taskTempWin= new Ext.Window({
    	id:'dhcwl_mkpi_kpiTaskTemplateWin',
		layout : 'fit',
		width : 750,
		height : 400,
		autoScroll:true,
		plain : true,
		title : '指标区间任务维护',
		items : taskSectionExcListGrid,
		listeners:{
			'close':function(){
				taskTempWin.destroy();
				taskTempWin.close();
				if(dhcwl_mkpi_kpiTaskTemplate){
					dhcwl_mkpi_kpiTaskTemplate=null;
				}
			}
		}
	});
	this.show=function(){
		var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
		if(selectedKpiIds.length==1){
			theTemplateKpiId=selectedKpiIds[0];
			storeTask.proxy.setUrl(encodeURI('dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc&kpiCode='+selectedKpiIds[0]));
			storeTask.load();
			taskSectionExcListGrid.show();
		}
		globalActiveFlagCombo.getStore().load();
		taskSectionExcListGrid.show();
		taskTempWin.show();
	}
	this.setSelectValue=function(value){
    	var rd=sm.getSelected();
    	rd.set('DTaskExcuteCode',value);
    }
}
dhcwl.mkpi.KpiTaskTemplate.getKpiTaskTemplate=function(){
	if(!dhcwl_mkpi_kpiTaskTemplate){
		dhcwl_mkpi_kpiTaskTemplate=new dhcwl.mkpi.KpiTaskTemplate(); 
	}
	return dhcwl_mkpi_kpiTaskTemplate;
}
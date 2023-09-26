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
    var sm=new Ext.grid.RowSelectionModel({singleSelect:true});
    var executeCodeField=new Ext.form.TextField({
    	name:'executeCodeField',
    	listeners:{
    		'focus':function(field,eve){
    			if(null==dhcwl_mkpi_executeCodeWin){
    				dhcwl_mkpi_executeCodeWin=new dhcwl.mkpi.TaskExectCode();
    				dhcwl_mkpi_executeCodeWin.setParentWin(outThis);
    			}

    			dhcwl_mkpi_executeCodeWin.showWin();
    		}
    	}
    });
    var columnModelTask=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :80
        },
        columns: [new Ext.grid.RowNumberer(),{
            header: '任务区间编码',
            dataIndex: 'SecCode',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            header: '任务区间名称',
            dataIndex: 'SecName',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            header: '任务区间执行代码',
            dataIndex: 'DTaskExcuteCode',
            width:260,
            editor:new Ext.grid.GridEditor(executeCodeField)
        }, {
            header: '运行时任务区间执行代码语句',
            dataIndex: 'DTaskExcuteCodeTip',
            width:200,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
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
    	id:'dhcwl.mkpi.KpiTaskTemplate.GridPanel',
        frame: true,
        clicksToEdit: 1,
        store: storeTask,
        cm: columnModelTask,
        sm:sm,
        //autoExpandColumn: 'SecCode', // column with this id will be expanded
        width:600,
        height:550,
        tbar: [{
            text: '增加区间任务',
            handler : function(){
            	var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
            	if(!selectedKpiIds||selectedKpiIds.length==0){
            		alert("请选择要设置的指标！");
            		return;
            	}
            	var choiceKpiCode=selectedKpiIds[0];
            	dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+'?action=getSectionMaxToMin&kpiCode='+choiceKpiCode
                ,null,function(jsonData){
                	var taskExcList={D:"CreatYesterdayData^DHCWLAutoCreatMKPIData",HY:"",Q:"CreatLastQuaDateAt1^DHCWLAutoCreatMKPIData",M:"CreatLastMonDataAt1^DHCWLAutoCreatMKPIData",Y:"CreatLastYearDataAt0101^DHCWLAutoCreatMKPIData"};
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
                			var initV={SecCode:(secList[maxSec].SecCode),SecName:(secList[maxSec].SecName),DTaskExcuteCode:(taskExcList[secList[maxSec].SecCode]),DTaskExcuteCodeTip:("s monthId="+taskExcList[secList[maxSec].SecCode]+"()"),DTaskActiveFlag:'N'};
                			storeTask.insert(0,new RecordTask(initV));
                		}
                	}else{
                		
                	}
                },outThis);
                
            }
        },"-",{
            text: '删除选中任务',
            handler : function(){
            	if(sm.getCount()==0){
            		alert("请选中任务后在删除！");
            		return;
            	}
            	var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
            	if(!selectedKpiIds||selectedKpiIds.length==0){
            		alert("请选择要设置的指标！");
            		return;
            	}
            	var taskSec=sm.getSelected().get("SecCode");
                dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl,
                	{action:'deleteTaskTemplate',kpiIds:selectedKpiIds.join(","),secCode:taskSec},
                	function(jsonData){
                		alert(jsonData.tip);
                	}
                );
                
            }
        },"-",{
            text: '保存修改',
            handler : function(){
            	var taskList="";
            	var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
            	if(!selectedKpiIds||selectedKpiIds.length==0){
            		alert("请选择要设置的指标！");
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
                	alert(jsonData.tip);
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
		title : '指标维度维护',
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
(function(){
	Ext.ns("dhcwl.mkpi.MaintainSectionTask");
})();
dhcwl.mkpi.MaintainSectionTask=function(){
	
	

	var getTaskInfoUrl='dhcwl/kpi/taskserver.csp';
	var outThis=this;
	var ModuleDatakpiCode="";
	var smKpi=new Ext.grid.CheckboxSelectionModel({
		renderer:function(v,c,r){
			if(ModuleDatakpiCode != r.get("sectionKpiCode")){
				ModuleDatakpiCode=r.get("sectionKpiCode");
				return '<div class="x-grid3-row-checker">&#160;<div>';
			}else{
				return "";
			}
		},
		listeners:{
			"rowselect":function(grid,rowIndex,e){
				var ModuleKpiCode=store.getAt(rowIndex).get('sectionKpiCode');
				var number=rowIndex;
				var ModuleDataKpiCode="";
				for(var k=0;;k++){
					number=number+1;
					ModuleDataKpiCode=store.getAt(number).get('sectionKpiCode');
					if(ModuleDataKpiCode==ModuleKpiCode){
						this.grid.getView().onRowSelect(number);
					}else{
						break;
					}
				}
			},
			"rowdeselect":function(grid,rowIndex,e){
				var ModuleDeKpiCode=store.getAt(rowIndex).get('sectionKpiCode');
				var deNumber=rowIndex;
				var ModuleDeDataKpiCode="";
				for(var k=0;;k++){
					deNumber=deNumber+1;
					ModuleDeDataKpiCode=store.getAt(deNumber).get('sectionKpiCode');
					if(ModuleDeDataKpiCode==ModuleDeKpiCode){
						selectKpi.getSelectionModel().deselectRow(deNumber);
					}
					else{
						break;
					}
				}
			},
			beforerowselect:function(s,n,k,r){
				if(k==false){
					return false;
				}
			}
		}
	});
	var columnModel=new Ext.grid.ColumnModel({
        columns: [new Ext.grid.RowNumberer(),smKpi,{
        	header:'指标',
        	dataIndex:'sectionKpiCode',
        	width:50,
        	menuDisabled : true
        },{
        	header:'是否公有',
        	dataIndex:'kpiProperty',
        	width:60,
        	menuDisabled : true
        },{
            header: '任务区间编码',
            dataIndex: 'sectionSecCode',
            menuDisabled : true
        }, {
            header: '任务区间名称',
            dataIndex: 'sectionSecName',
            menuDisabled : true
        }, {
            header: '任务区间执行代码',
            dataIndex: 'sectionDTaskExcuteCode',
            width:130,
            menuDisabled : true
        }, {
            header: '运行时任务区间执行代码语句',
            dataIndex: 'sectionDTaskExcuteCodeTip',
            width:160,
            menuDisabled : true
        }, {
            //xtype: 'checkcolumn',
            header: '是否激活?',
            dataIndex: 'sectionDTaskActiveFlag',
            menuDisabled : true
        },{
        	header:'错误标志',
        	dataIndex:'sign',
        	hidden:true
        	//menuDisabled : true
        }]
    });
	
	var store = new Ext.data.GroupingStore({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/taskserver.csp?action=getKpiSectionInfor'}),
		//proxy:new Ext.data.MemoryProxy(data),
		reader: new Ext.data.JsonReader({
            //totalProperty: 'totalNums',
        //data:data,   
		root: 'root',
        	fields:[
        	    {name:'sectionKpiCode'},
        	    {name:'kpiProperty'},
            	{name: 'sectionSecCode'},
            	{name: 'sectionSecName'},
            	{name: 'sectionDTaskExcuteCode'},
            	{name: 'sectionDTaskExcuteCodeTip'},
            	{name: 'sectionDTaskActiveFlag'},
            	{name: 'sign'}
       		]
    	}),
			groupField:'sectionKpiCode',
			sortInfo:{field:'kpiProperty',direction:"ASC"}
    });
	
	var selectKpi=new Ext.grid.EditorGridPanel({
		
    	id:'dhcwl.mkpi.MaintainSectionTask.GridPanel',
    	labelAlign : 'top',
        frame: true,
        clicksToEdit: 1,
        store: store,
        cm: columnModel,
        view:new Ext.grid.GroupingView(),
        sm:smKpi,
        width:585,
        height:350,
        buttonAlign: 'center',
	      buttons : [  
	         {
	        	 //text:'确定',
	        	 text: '<span style="line-Height:1">确定</span>',
	        	 icon: '../images/uiimages/ok.png',
	        	 handler:function(){
	        		 var seleModel=selectKpi.getSelectionModel();
	        		 if(!seleModel){
	        			 alert("请选择一行！");
	                		return;
	        		 } 
	        		 var record = seleModel.getSelections();
	                 if(!record){
	                     alert("请选择一行！");
	                	 return;
	                 }
	                 var kpiCodes="";
	                 var kpiCode="";
	                 var selectKpiCode="";
	                 for(var i=0;i<=record.length-1;i++){
	                	 kpiCode=record[i].get("sectionKpiCode");
	                	 if (selectKpiCode!=kpiCode){
	                		 selectKpiCode=kpiCode;
	                		 if (kpiCodes!="") kpiCodes=kpiCodes+",";
	                		 kpiCodes=kpiCodes+kpiCode;
	                	 }
	                 }
	                 //Ext.Msg.show({title:"ddd",msg:kpiCodes});
	                 var secinfors=""
	                 for(var j=storeTask.getCount()-1;j>=0;j-- ){
	                	 var rd=storeTask.getAt(j);
			        	  var secCode=rd.get("SecCode");
			        	  var secName=rd.get("SecName");
			        	  var dTaskExcuteCode=rd.get("DTaskExcuteCode");
			        	  var dTaskExcuteCodeTip=rd.get("DTaskExcuteCodeTip");
			        	  var dTaskActiveFlag=rd.get("DTaskActiveFlag");
			        	  var secinfor=secCode+","+secName+","+dTaskExcuteCode+","+dTaskActiveFlag
			        	  if(secinfors!="") secinfors=secinfors+"@";
			        	  secinfors=secinfors+secinfor;
	                 }
	                 dhcwl.mkpi.Util.ajaxExc(getTaskInfoUrl+"?action=updateSection&kpiCodes="+kpiCodes+"&secinfors="+secinfors+'&kpiselNodeIDs='+kpiselNodeIDs+'&kpimoduleRptSign='+kpimoduleRptSign,null,function(jsonData){
	                	 if(!jsonData){
	                 		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                 		return;
	                 	}
	                	 if(!jsonData.success){
	                		 Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		                 	 return;
	                	 }
	                 });
	                 win.destroy();
		        	 win.close();
		        	 winshow.destroy();
		        	 winshow.close();
	        	 }
	         },
	         {  
	          //text : '取消',
	          text: '<span style="line-Height:1">取消</span>',
	          icon: '../images/uiimages/undo.png',
	          handler : function(){
	        	  win.destroy();
	        	  win.close();
	        	  winshow.destroy();
	        	  winshow.close();
	          }
	        }  
	      ]
	});
	
	
	selectKpi.getStore().on('load',function(s,records){
		var gridcount=0;
		s.each(function(r){
			if(r.get('sign')==5){
				selectKpi.getView().getRow(gridcount).style.backgroundColor='#FFFF00';
			}
			if(r.get('sign')==2){
				selectKpi.getView().getCell(gridcount,6).style.backgroundColor='red';
			}
			if(r.get('sign')==3){
				selectKpi.getView().getCell(gridcount,8).style.backgroundColor='red';
			}
			if(r.get('sign')==4){
				selectKpi.getView().getCell(gridcount,6).style.backgroundColor='red';
				selectKpi.getView().getCell(gridcount,8).style.backgroundColor='red';
			}
			gridcount=gridcount+1;
		});
	});
	
	
	
	var winshow=new Ext.Window({
		//title:'设置任务区间',
		title:'请选择要操作的指标',
		closable:true,
		modal : true,
		width : 600,
		resizable : false,
		plain : true,
		layout : 'form',
		items : [selectKpi]
	});
	
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
		listeners :{
			'select':function(combox){
				activeFlagCombo.setValue(combox.getValue());
			}
		}
	});
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
	var RecordTask = Ext.data.Record.create([
	    {name: 'SecCode'},
	    {name: 'SecName'},
	    {name: 'DTaskExcuteCode'},
	    {name: 'DTaskExcuteCodeTip'},
	    {name: 'DTaskActiveFlag'}
	]);
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
            width:80,menuDisabled:true
        },
        columns: [new Ext.grid.RowNumberer(),{
            header: '任务区间编码',
            dataIndex: 'SecCode'
        }, {
            header: '任务区间名称',
            dataIndex: 'SecName'
        }, {
            header: '任务区间执行代码',
            dataIndex: 'DTaskExcuteCode',
            width:130,
            editor:new Ext.grid.GridEditor(executeCodeField)
        }, {
            header: '运行时任务区间执行代码语句',
            dataIndex: 'DTaskExcuteCodeTip',
            width:160
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
        	    {name:'Index'},
            	{name: 'SecCode'},
            	{name: 'SecName'},
            	{name: 'DTaskExcuteCode'},
            	{name: 'DTaskExcuteCodeTip'},
            	{name: 'DTaskActiveFlag'}
       		]
    	})
    });
	var data="";
	var taskSectionExcListGrid=new Ext.grid.EditorGridPanel({
		
    	id:'dhcwl.mkpi.MaintainSectionTask.GridListPanel',
    	title:'任务区间代码列表',
    	labelAlign : 'top',
        frame: true,
        clicksToEdit: 1,
        store: storeTask,
        cm: columnModelTask,
        sm:sm,
        //autoExpandColumn: 'SecCode', // column with this id will be expanded
        width:585,
        height:350,
        tbar: [{
        	//text: '增加区间任务',
        	text: '<span style="line-Height:1">增加区间任务</span>',
        	icon: '../images/uiimages/edit_add.png',
        	handler:function(){
        		if (Ext.getCmp('nextStep').disabled==true){
        			Ext.getCmp('nextStep').setDisabled(false);
				}
        		var choiceKpiCode="";
        		globalActiveFlagCombo.getStore().load();
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
        					var record=globalActiveFlagCombo.getStore().getAt(0);
                        	//var record=activeFlagCombo.getStore().getAt(0);
        					var activeFlag="";
        					if (!!record) {
        						activeFlag=record.get('realValue');
        					}
        					if (activeFlag==""){
								activeFlag="N";
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
        }],
        buttonAlign: 'center',
	      buttons : [  
	         {  
	          //text : '下一步',
	          text: '<span style="line-Height:1">下一步</span>',
	          icon: '../images/uiimages/moveright.png',
	          disabled:true,
	          id:'nextStep',
	          handler : function(){
	        	  var secs="";
		          for(var i=storeTask.getCount()-1;i>=0;i-- ){
		        	  var rd=storeTask.getAt(i);
		        	  var sec=rd.get("SecCode");
		        	  var exeCode=rd.get("DTaskExcuteCode");
		        	  var activeFlag=rd.get("DTaskActiveFlag");
		        	  sec=sec+":"+exeCode+":"+activeFlag
		        	  if(sec!=null){
		        		  if(secs!=""){
		        			  secs=secs+","+sec;
		        		  }
		        		  else{
		        			  secs=sec;
		        		  }
		        	  }
		          }
		          try{
		        	  //Ext.Msg.show({title:'ss',msg:kpiselNodeIDs});
		        	  var store=selectKpi.getStore();
		        	  store.proxy.setUrl(encodeURI('dhcwl/kpi/taskserver.csp?action=getKpiSectionInfor&secs='+secs+'&kpiselNodeIDs='+kpiselNodeIDs+'&kpimoduleRptSign='+kpimoduleRptSign));
		        	  selectKpi.show();
		        	  winshow.show(this);
		        	  store.load();
		          }catch(e){
		        	  Ext.Msg.show({title:'错误',msg:"Sorry，显示指标信息出错了！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					  return;
		          }
		          //selectKpi.show();
		          win.hide(this);
	        	  //winshow.show(this);
	          }
	        }  
	      ]
	});  
	  
	taskSectionExcListGrid.getStore().on('load',function(s,records){
		Ext.getCmp('nextStep').setDisabled(true);
	})
	
	var win=new Ext.Window({
		title:'设置任务区间',
		closable:true,
		modal : true,
		width : 600,
		resizable : false,
		plain : true,
		layout : 'form',
		items : [taskSectionExcListGrid]
	});
	this.show=function(selNodeIDs,moduleRptSign){
		kpiselNodeIDs=selNodeIDs;
		kpimoduleRptSign=moduleRptSign;
		win.show(this);
		//winshow.hide(this);
	}
	
	this.setSelectValue=function(value){
    	var rd=sm.getSelected();
    	rd.set('DTaskExcuteCode',value);
    	//executeCodeField.setValue(value);
    }
}
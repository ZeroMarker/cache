(function(){
	Ext.ns("dhcwl.mkpi.MaintainKpiTasksGroup");
})();
dhcwl.mkpi.MaintainKpiTasksGroup=function(){
	var getTaskInfoUrl='dhcwl/kpi/taskserver.csp'
	var outThis=this;
	var selectedKpiIds=[];
	var selectedKpiCodes=[];
	var choiceKpiCode="",kpiSectionName;
	/*--查看任务组明细右键菜单--*/
	var quickMenu=new Ext.menu.Menu({
		boxMinWidth:150,
		ignoreParentClicks:true,
		items:[{
			text:'添加任务明细',
			handler:function(cmp,event){
				var obj=kpiList.getSelectionModel().getSelections();
				var len=obj.length;
				if (len < 1){
					Ext.MessageBox.alert("注意","请选择要维护的项目");
					return;
				}
				if (len > 1){
					Ext.MessageBox.alert("注意","只能选择一个项目维护");
					return;
				}
				mainKpiWin.show(this);
		        kpiListPanel.show();
		        storeKpi.load();
				
			}
		}/*,'-',{
			text:'批量新增指标'
		},'-',{
			text:'查看任务组明细',
			handler:function(cmp,event) {
				win.show();
			}
		}*/
		]
	});
	var taskGroupSm = new Ext.grid.CheckboxSelectionModel();
	var columnModelKpi = new Ext.grid.ColumnModel([
		taskGroupSm,
		{header:'ID',dataIndex:'groupID', width: 50, sortable: true ,menuDisabled : true,hidden:true
        },{header:'任务组编码',dataIndex:'code', width: 145, sortable: true ,menuDisabled : true
        },{header:'任务组描述',dataIndex:'desc', width: 145, sortable: true ,menuDisabled : true
        },{header:'创建人',dataIndex:'user',width:75,menuDisabled : true
        }
    ]);
    //定义指标任务组的存储模型
    var storeKpiTaskGroup = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/taskserver.csp?action=getTaskGroup'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name: 'groupID'},
            	{name: 'code'},
            	{name: 'desc'},
            	{name: 'user'}
       		]
    	})
    });

	//定义指标任务组的显示表格。
	var choicedSearcheCond="", searcheValue="";
	var kpiList = new Ext.grid.GridPanel({
        frame:true, 
		title: '任务组列表',		
        id:"kpiGroupTables",
        enableColumnResize :true,
        store: storeKpiTaskGroup,
        cm: columnModelKpi,
		viewConfig: {forceFit: true},
		sm:taskGroupSm,
        autoScroll: true,
		bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: storeKpiTaskGroup,
            displayInfo: true,
            displayMsg: '第{0}条到{1}条记录,共{2}条',
            emptyMsg: "没有记录"
        }),
        tbar: [{
            text: '<span style="line-Height:1">新增</span>',
            icon: '../images/uiimages/edit_add.png',
            handler : function(){
                var form=addTaskGroupForm.getForm();
				form.setValues({Code:'',Desc:'',User:''});
    			win.show();
            }
        },"-",{
			text: '<span style="line-Height:1">修改</span>',
			icon:'../images/uiimages/update.png',
			handler:function(){
				var obj=kpiList.getSelectionModel().getSelections();
				var len=obj.length;
				if ((len<1)||(len>1)){
					Ext.Msg.alert("提示","请先选择一个需要修改的任务组");
					return;
				}
				var form=modifyGroupForm.getForm();
				form.setValues({modDesc:'',modUser:''})
				modwin.show();
			}
		},"-",{
			text: '<span style="line-Height:1">删除</span>',
			icon:'../images/uiimages/edit_remove.png',
			handler:function(){
				var obj=kpiList.getSelectionModel().getSelections();
				var len=obj.length;
				if ((len<1)||(len>1)){
					Ext.Msg.alert("提示","请先选择一个需要修改的任务组");
					return;
				}
				var groupID=obj[0].get("groupID");
				Ext.Msg.confirm('警告', '当前的任务组将会删除，确认删除么？', function(btn){
					if (btn == 'yes'){
						dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/taskserver.csp'+'?action=delTaskGroup&groupID='+groupID
							,null,function(jsonData){
								if(!jsonData){
									Ext.Msg.show({title:'错误',msg:"删除失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									return;
								}
								if(jsonData.success){
									if (jsonData.tip=="ok") {
										Ext.Msg.alert("提示","删除成功了！");
										refresh();
									}else{
										Ext.Msg.alert("提示",jsonData.tip);
									}
								}else{
									Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									return;
								}
							},outThis);
					}
				});
			}
		},'-',{
			text: '<span style="line-Height:1">任务组导出</span>',
			icon:'../images/uiimages/redo.png',
			handler:function(){
				var obj=kpiList.getSelectionModel().getSelections();
				var len=obj.length;
				if (len<1) {
					Ext.Msg.alert("提示","请先选择需要导出的任务组");
					return;
				}
				var groupIDs="";
				for (var i=0;i<len;i++){
					var groupID=obj[i].get("groupID");
					if (groupIDs==""){
						groupIDs=groupID;
					}else{
						groupIDs=groupIDs+","+groupID;
					}
					
				}
				dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/taskserver.csp',{action:'getKpiTaskGroup',groupID:groupIDs},
					function(responseText){
						if(responseText){
							dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+"version"+'outputKpis.task',dhcwl.mkpi.Util.trimLeft(responseText));
						}else{
							Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
					}
				,outThis,true,null);
				
			}
		},'-',{
			text: '<span style="line-Height:1">任务组导入</span>',
			icon:'../images/uiimages/importdata.png',
			handler:function(){
				var taskObj=new dhcwl.mkpi.KpiTaskInput(storeKpiTaskGroup);
				taskObj.show();
			}
		}], 
        listeners :{
        	'contextmenu':function(event){
				event.preventDefault();
				quickMenu.showAt(event.getXY());
			},
			'click':function(e){
				Ext.getCmp("search").setValue("");
				refreshTaskDetail();
			}
        }
    });
	
    var sm1=new Ext.grid.CheckboxSelectionModel({});
    var columnModelTask=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :80,menuDisabled : true
        },
        columns: [new Ext.grid.RowNumberer(),sm1,{
            header: 'ID',
            dataIndex: 'kpiID',
            id:'SecCode'
        }, {
            header: '指标编码',
            dataIndex: 'kpiCode',
			width:160
        }, {
            header: '指标描述',
            dataIndex: 'kpiDesc',
            width:160
        }, {
            header: '维度',
            dataIndex: 'kpiDim',
            width:220
        }]
    });
    var storeTask = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/taskserver.csp?action=getTaskDetail'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'kpiID'},
            	{name: 'kpiCode'},
            	{name: 'kpiDesc'},
            	{name: 'kpiDim'}
       		]
    	})
    });
    var taskSectionExcListGrid=new Ext.grid.EditorGridPanel({
    	id:'dhcwl.mkpi.MaintainKpiTasks.GridGroupPanel',
        title: '任务组指标列表',
        frame: true,
        clicksToEdit: 1,
        store: storeTask,
        cm: columnModelTask,
        sm:sm1,
		bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: storeTask,
            displayInfo: true,
            displayMsg: '第{0}条到{1}条记录,共{2}条',
            emptyMsg: "没有记录"
        }),
        tbar: [{
        	text: '<span style="line-Height:1">移除</span>',
            icon: '../images/uiimages/edit_remove.png',
            handler : function(){
				removeGroupDetail();
				return;
            }
        },"-",{
            xtype:'label',
			text:'查找: '
		},{
			fieldLabel : '查找',
			xtype:'textfield',
			name: 'search',
			id	: 'search',
			enableKeyEvents: true,
			listeners :{
				'keypress':function(ele,event){
					searcheValue=Ext.get("search").getValue();//获取搜索值
					if ((event.getKey() == event.ENTER)){
						refreshTaskDetail();
					}
				}
			}

		}]
    });
    /*var taskPanel=new Ext.Panel({
    	id:'dhcwl.mkpi.MaintainKpiTasks.taskGroupPanel',
    	title:'任务组维护',
		height:700,
    	layout:'column',
        items: [{
        	columnWidth: .4,
            items:kpiList,
            //height:700,
            layout:'fit'
        },{
            columnWidth: .6,
            //height:700,
        	items:taskSectionExcListGrid,
			layout:'fit'

    	}],
		listeners:{
    		"resize":function(win,width,height){
    			kpiList.setHeight(height);
				taskSectionExcListGrid.setHeight(height);
    		}
		}
    });*/
	
	var taskPanel =new Ext.Panel ({ 
		id:'dhcwl.mkpi.MaintainKpiTasks.taskGroupPanel',
    	title:'任务组维护',
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
	
	//---------------------新增统计组弹框设计-----------------------
	var addTaskGroupForm=new Ext.FormPanel({
		height:150,
        width : 300,
		buttonAlign: 'center',
        bodyStyle: 'padding: 5px',
        defaults: {
            anchor: '0'
        },
        items:[{
        	id        : 'Code',
        	xtype     : 'textfield',
            fieldLabel: '编码',
            anchor    : '-20'
        },{
        	id        : 'Desc',
        	xtype     : 'textfield',
            fieldLabel: '描述',
            anchor    : '-20'
        },{
        	id        : 'User',
        	xtype     : 'textfield',
            fieldLabel: '创建人',
            anchor    : '-20'
        }],
		buttons:[{
			text:'保存',
			icon   : '../images/uiimages/filesave.png',
			handler:function(){
				var Code=Ext.get('Code').getValue();
				var Desc=Ext.get('Desc').getValue();
				var User=Ext.get('User').getValue();
				var reg=/[\$\#\@\&\%\!\*\^\~||]/;
				var reg2=/^\d/;
				var reg3=/\s/;
				if(reg.test(Code)||(reg2.test(Code))||(reg3.test(Code))||(Code=="")){
					alert("编码不能包括$,#,@,&,%,*,^,!,~,||,空格等特殊字符，并且不能以数字开头,也不能为空！");
					Ext.get("Code").focus();
					return;
				}
				if ((reg3.test(Desc))||(Desc=="")){
					alert("描述不能为空,且不能包含空格");
					return;
				}
				dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/taskserver.csp'+'?action=saveTaskGroup&Code='+Code+'&Desc='+Desc+'&User='+User
	                ,null,function(jsonData){
	                	if(!jsonData){
	                		Ext.Msg.show({title:'错误',msg:"增加失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                	if(jsonData.success){
	                		if (jsonData.tip=="ok") {
	                			Ext.Msg.alert("提示","增加成功了！");
								refresh();
	                		}else{
	                			Ext.Msg.alert("提示",jsonData.tip);
	                		}
	                	}else{
	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                },outThis);
     		 win.hide();
     	   }
        },{
     	   text:'取消',
		   icon   : '../images/uiimages/cancel.png',
     	   handler:function(){
     		   win.hide();
     	   }
        }]
    })
	
	var win=new Ext.Window({
		title:'添加任务组',
		closable:true,
		closeAction:'hide',
		modal : true,
		width : 300,
		resizable : false,
		plain : true,
		layout : 'form',
		items:[addTaskGroupForm],
		listeners:{
			
		}
	});
	
	
	
	
	//------------------修改统计组弹框设计-----------------------
	var modifyGroupForm=new Ext.FormPanel({
		height:150,
        width : 300,
		buttonAlign: 'center',
        bodyStyle: 'padding: 5px',
        defaults: {
            anchor: '0'
        },
        items:[{
        	id        : 'modDesc',
        	xtype     : 'textfield',
            fieldLabel: '描述',
            anchor    : '-20'
        },{
        	id        : 'modUser',
        	xtype     : 'textfield',
            fieldLabel: '创建人',
            anchor    : '-20'
        }],
		buttons:[{
			text:'保存',
			icon   : '../images/uiimages/filesave.png',
			handler:function(){
				var obj=kpiList.getSelectionModel().getSelections();
				var groupID=obj[0].get("groupID");
				var Desc=Ext.get('modDesc').getValue();
				var User=Ext.get('modUser').getValue();
				var reg3=/\s/;
				if ((reg3.test(Desc))||(Desc=="")){
					alert("描述不能包括空格等特殊字符，也不能为空！");
					return;
				}
				dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/taskserver.csp'+'?action=modTaskGroup'+'&Desc='+Desc+'&User='+User+'&groupID='+groupID
	                ,null,function(jsonData){
	                	if(!jsonData){
	                		Ext.Msg.show({title:'错误',msg:"修改失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                	if(jsonData.success){
	                		if (jsonData.tip=="ok") {
	                			Ext.Msg.alert("提示","修改成功了！");
								refresh();
	                		}else{
	                			Ext.Msg.alert("提示",jsonData.tip);
	                		}
	                	}else{
	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                },outThis);
     		 modwin.hide();
     	   }
        },{
     	   text:'取消',
		   icon   : '../images/uiimages/cancel.png',
     	   handler:function(){
     		   modwin.hide();
     	   }
        }]
    })
	
	var modwin=new Ext.Window({
		title:'修改任务组',
		closable:true,
		closeAction:'hide',
		modal : true,
		width : 300,
		resizable : false,
		plain : true,
		layout : 'form',
		items:[modifyGroupForm],
		listeners:{
			
		}
	});
	/*--新增明细指标功能--*/
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
		fieldLabel : 'global',
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
    var kpiForm=new Ext.FormPanel({
    	frame : true,
		height : 163,
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
					width : 95
				},
				items : [{
							fieldLabel : 'ID',
							name: 'id1',
				            id:'id1',
				            editable:false
						}, globalFlagCombo,kpiFlCombo]
			}, {
				columnWidth : .18,
				labelWidth : 50,
				layout : 'form',
				defaults : {
					width : 135
				},
				items : [{
							fieldLabel : '编码',
							xtype : 'textfield',
							name: 'kpiCode1',
				            id:'kpiCode1'
						}, {
							fieldLabel : '创建人',
							xtype : 'textfield',
							name: 'createUser1',
				            id:'createUser1'
						},sectionCombo]
			}, {
				columnWidth : .18,
				layout : 'form',
				labelWidth : 70,
				defaults : {
					width : 115
				},
				items : [{
							xtype : 'textfield',
							fieldLabel : '指标名称',
							name: 'kpiName1',
				            id:'kpiName1'
						}, {
							xtype : 'datefield',
							name: 'updateDate1',
				            id:'updateDate1',
							format:GetWebsysDateFormat(),
							fieldLabel : '更新日期'
						},{
							fieldLabel : '备注',
							xtype:'textfield',
				        	name: 'nodeMark1',
				        	id: 'nodeMark1'
						}]
			}, {
				columnWidth : .18,
				layout : 'form',
				labelWidth : 70,
				defaults : {
					width : 115
				},
				items : [{
					xtype:'textfield',
					fieldLabel : '指标描述',
					name: 'kpiDesc1',
		            id:'kpiDesc1'
				},{
					xtype:'textfield',
					fieldLabel:'数据节点',
		            name: 'dataNode1',
		            id: 'dataNode1'
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
					name:'kpiExcode1',
		            id:'kpiExcode1'
				},{
		            fieldLabel : '维度',
		            name:'dimType1',
		           	id:'dimType1',
		            xtype:'textfield'
		        }]
			}]

		}],
        tbar: new Ext.Toolbar([{
        	//text   : '查找',
        	text: '<span style="line-Height:1">查找</span>',
        	icon: '../images/uiimages/search.png',
        	cls:'align:right',
            handler: function() {
            	var id=Ext.get('id1').getValue();
                var kpiName=Ext.get('kpiName1').getValue();
                var kpiDesc=Ext.get('kpiDesc1').getValue();
                var dimType=Ext.get('dimType1').getValue();
                var section=sectionCombo.getRawValue();
                var category=kpiFlCombo.getRawValue();
                var kpiCode=Ext.get('kpiCode1').getValue();
                var kpiExcode=Ext.get('kpiExcode1').getValue();
                var createUser=Ext.get('createUser1').getValue();
                var updateDate=Ext.get('updateDate1').getValue();
                var nodeMark=Ext.get('nodeMark1').getValue();
                var dataNode=Ext.get('dataNode1').getValue();
                //var section=Ext.get('section').getValue();
                var globalFlag=globalFlagCombo.getValue();
                if(!globalFlag) globalFlag='';
                else if(globalFlag=='否'||globalFlag=='N') globalFlag='N';
                else if(globalFlag=='是'||globalFlag=='Y') globalFlag='Y';
                else globalFlag='';
                var getValueType=getValueTypeCombo.getValue();
                if (getValueType=="普通指标") getValueType=1; 
                if (getValueType=="计算指标") getValueType=2; 
                //if (getValueType=="") getValueType=1;
                paraValues='kpiId='+id+'&dimType='+dimType+'&category='+category+'&kpiCode='+kpiCode+'&kpiExcode='+kpiExcode;
                paraValues+='&createUser='+createUser+'&updateDate='+updateDate+'&nodeMark='+nodeMark;
  				paraValues+='&kpiName='+kpiName+'&kpiDesc='+kpiDesc+'&section='+section+'&dataNode='+dataNode+'&globalFlag='+globalFlag+'&getValueType='+getValueType;
  				storeKpi.proxy.setUrl(encodeURI("dhcwl/kpi/taskserver.csp?action=mulSearch&"+paraValues+"&onePage=1"));
                //alert(paraValues);
  				storeKpi.load();
  				kpiListPanel.show();
           }
        },'-',{//text   : '清  空',
        	text: '<span style="line-Height:1">清  空</span>',
        	icon: '../images/uiimages/clearscreen.png',
        	cls:'align:right',
            handler: function() {
            	//this.clearForm();
            	//return;
            	var form=kpiForm.getForm();
    			form.setValues({id1:'',kpiName1:'',kpiDesc1:'',kpiDimCombo:'',kpiFlCombo:'',sectionCombo:'',globalFlagCombo:'',kpiCode1:'',kpiExcode1:'',createUser1:'',updateDate1:'',nodeMark1:'',dataNode1:'',dimType1:'',getValueTypeCombo:''});
        	}
        },'-',{
        	//text   : '清空选取列表',
        	text: '<span style="line-Height:1">清空选取列表</span>',
        	icon: '../images/uiimages/clearscreen.png',
        	handler:function(){
        		var j=0,len=selectedKpiIds.length;
        		var kpiCode="";
				for(var i=storeKpi.getCount()-1;i>-1;i--){
					for(j=len-1;j>-1;j--){
						if(selectedKpiIds[j]==storeKpi.getAt(i).get("id")){
							sm.deselectRow(i);
						}
					}
				}
				selectedKpiIds=[];
				selectedKpiCodes=[];
        	}
        }])
	});
	
	var sm=new Ext.grid.CheckboxSelectionModel({
		listeners :{
			'rowselect': function(sm, row, rec) {
				var rd1=rec;   //sm.getSelected();
        		var kpiId=rec.get("id");
        		var kpiCode=rec.get("kpiCode");
        		var kpiName=rec.get("kpiName");
        		var kpiDesc=rec.get("kpiDesc");
        		var kpiExcode=rec.get("kpiExcode");
        		var createUser=rec.get("createUser");
        		var updateDate=rec.get("updateDate");
        		var dataNode=rec.get("dataNode");
        		var dimType=rec.get("dimType");
        		var nodeMark=rec.get("nodeMark");
        		var form=kpiForm.getForm();
    			form.setValues({id1:kpiId,kpiName1:kpiName,kpiDesc1:kpiDesc,kpiCode1:kpiCode,kpiExcode1:kpiExcode,createUser1:createUser,updateDate1:updateDate,nodeMark1:nodeMark,dataNode1:dataNode,dimType1:dimType});
    			addSelectedKpiId(kpiId,kpiCode);
        		sectionCombo.setValue(rd1.get('section')); 
        		kpiFlCombo.setValue(rd1.get('category'));
        		globalFlagCombo.setValue(rd1.get('MKPIGlobalFlag'));
        		getValueTypeCombo.setValue(rd1.get('getValueType'));

            },
            'rowdeselect':function(sm, row, rec){
            	var kpiCode=rec.get("kpiCode");
            	var kpiId=rec.get("id"),len=selectedKpiIds.length;
				for(var i=0;i<len;i++){
					if(selectedKpiIds[i]==kpiId){
						for(var j=i;j<len;j++){
							selectedKpiIds[j]=selectedKpiIds[j+1];
							selectedKpiCodes[j]=selectedKpiCodes[j+1];
						}
						selectedKpiIds.length=len-1;
						selectedKpiCodes.length=len-1;
						break;
					}
				}
			}
		}
	});	
	var columnModelKpi = new Ext.grid.ColumnModel([
		sm,
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
        }
    ]);


    var storeKpi = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/taskserver.csp?action=mulSearch'}), //&date='+dhcwl.mkpi.Util.nowDateTime()}),
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
            	{name: 'getValueType'}
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
    var kpiRecorde= Ext.data.Record.create([
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
        {name: 'getValueType', type: 'string'}
	]);
	
	var choicedSearcheCond="",searcheValue="";

    var kpiListPanel = new Ext.grid.GridPanel({
    	title:'指标',
        id:"kpiListPanel",
        width:380,
        height:400,
        enableColumnResize :true,
        store: storeKpi,
        sm:sm,
        cm: columnModelKpi,
        autoScroll: true,
        bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: storeKpi,
            displayInfo: true,
            displayMsg: '第{0}条到{1}条记录,共{2}条',
            emptyMsg: "没有记录",
            listeners :{
				'change':function(pt,page){
					var id="",j=0,found=false,storeLen=selectedKpiIds.length;
					var AllRowCnt=storeKpi.getCount();
					var selRowCnt=0;
					for(var i=storeKpi.getCount()-1;i>-1;i--){
						id=storeKpi.getAt(i).get("id");
						found=false;
						for(j=storeLen-1;j>-1;j--){
							if(selectedKpiIds[j]==id) found=true;
						}
						if(found){
							sm.selectRow(i,true,false);
							selRowCnt++;
						}
					}
					
					
					var hd_checker = kpiListPanel.getEl().select('div.x-grid3-hd-checker');
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
        listeners:{
        	
        }
    });	
	
	var mainKpiWin = new Ext.Window({
            title: '指标选择',
            modal:true,
            closable:true,
            closeAction: "hide",
            width:1100,
            height:570,
            plain:true,
            layout: 'border',
            buttonAlign:'center',
            items: [{
            	region: 'north',
                height: 148,
                items:kpiForm
            },{region: 'center',
                split: true,
                width: 852,
                margins:'3 0 3 3',
                cmargins:'3 3 3 3',
                layout:'fit',
    			items:kpiListPanel}],

	        buttons: [
	        {
	            text: '<span style="line-Height:1">保存</span>',
	            icon: '../images/uiimages/filesave.png',
	            handler: function(){
					var obj=kpiList.getSelectionModel().getSelections();
					var len=obj.length;
					if (len < 1){
						Ext.Msg.show({title:'注意',msg:'请选择要维护的项目'});
						return;
					}
					if (len > 1){
						Ext.Msg.show({title:'注意',msg:'只能选择一个项目维护'});
						return;
					}
					var groupID=obj[0].get("groupID");
					//alert(groupID);
					//return;
					//alert(selectedKpiIds);
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/taskserver.csp'+'?action=saveTaskDetail&groupID='+groupID+'&selectedKpiIds='+selectedKpiIds
	                ,null,function(jsonData){
	                	if(!jsonData){
	                		Ext.Msg.show({title:'错误',msg:"增加失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                	if(jsonData.success){
	                		if (jsonData.tip=="ok") {
	                			Ext.Msg.alert("提示","增加成功了！");
								refreshTaskDetail();
	                		}else{
	                			Ext.Msg.alert("提示",jsonData.tip);
	                		}
	                	}else{
	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                },outThis);
					clearFormAndGrid();
	            	mainKpiWin.hide();
	            }
	        },{
	            text: '<span style="line-Height:1">退出</span>',
	            icon: '../images/uiimages/cancel.png',
	            handler: function(){
					clearFormAndGrid();
					mainKpiWin.hide();
	            }
	        }]
            
        });
	//-----批量新增指标明细功能--------
	
		var addSetForm=new Ext.form.FormPanel({
    	frame: true,
        
        labelAlign: 'right',
        bodyStyle:'padding:15px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        buttonAlign: 'center',
        buttons:[{
        	text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
        	handler:function(){
        		addWin.hide(); 
        	}
        },{
        	text: '<span style="line-Height:1">关闭</span>',
        	icon: '../images/uiimages/cancel.png',
        	handler:function(){
        		addWin.hide(); 
        	}
        }],
        items:[{
        	fieldLabel:'请输入需要新增的指标编码',
			anchor:'95%',
			height:120,
			xtype: "textarea",
			id: "addKpiCodes"
        }]
	})
	
	var addWin=new Ext.Window({
		title:'新增指标维护',
		closable:true,
		modal : true,
		width : 600,
		height: 250,
		resizable : false,
		plain : true,
		layout : 'fit',
		items : [addSetForm],
		listeners:{
			'close':function(){
				addWin.close();
				addWin.hide(); 
			}
    	}
	});
	

	/*--常用方法和接口--*/
	function addSelectedKpiId(id,code){
		if(!id||id=="") return;
		for(var i=selectedKpiIds.length-1;i>-1;i--){
			if(selectedKpiIds[i]==id)
				return;
		}
		selectedKpiIds.push(id);
		selectedKpiCodes.push(code);
	}
		
	this.mainKpiWinShow=function(){
		mainKpiWin.show(this);
	}
	
    this.getTaskPanel=function(){
		storeKpiTaskGroup.proxy.setUrl(encodeURI("dhcwl/kpi/taskserver.csp?action=getTaskGroup"));
	    storeKpiTaskGroup.load();
	    kpiList.show();
    	return taskPanel;
    }
	/*--刷新任务组表格--*/
    function refresh(){
    	storeKpiTaskGroup.proxy.setUrl(encodeURI("dhcwl/kpi/taskserver.csp?action=getTaskGroup"));
	    storeKpiTaskGroup.load();
	    kpiList.show();
    }
	/*--刷新任务明细表格--*/
	function refreshTaskDetail(){
		var obj=kpiList.getSelectionModel().getSelections();
		var len=obj.length;
		if (len<1){
			return;
		}
		var groupID=obj[0].get("groupID");
		var searcheValue=Ext.get("search").getValue();//获取搜索值
		storeTask.proxy.setUrl(encodeURI("dhcwl/kpi/taskserver.csp?action=getTaskDetail&onePage=1&groupID="+groupID+"&searchValue="+searcheValue));
	    storeTask.load();
	    taskSectionExcListGrid.show();
	}
	function clearFormAndGrid(){
		var form=kpiForm.getForm();
		form.setValues({id1:'',kpiName1:'',kpiDesc1:'',kpiDimCombo:'',kpiFlCombo:'',sectionCombo:'',globalFlagCombo:'',kpiCode1:'',kpiExcode1:'',createUser1:'',updateDate1:'',nodeMark1:'',dataNode1:'',dimType1:'',getValueTypeCombo:''});
		var j=0,len=selectedKpiIds.length;
		var kpiCode="";
		for(var i=storeKpi.getCount()-1;i>-1;i--){
			for(j=len-1;j>-1;j--){
				if(selectedKpiIds[j]==storeKpi.getAt(i).get("id")){
					sm.deselectRow(i);
				}
			}
		}
		selectedKpiIds=[];
		selectedKpiCodes=[];
		mainKpiWin.hide();
	}
	/*--任务组明细删除方法--*/
	function removeGroupDetail() {
		var groupObj=kpiList.getSelectionModel().getSelections();
		var groupLen=groupObj.length;
		if (groupLen<1){
			Ext.Msg.alert("提示","任务组未选中");
			return;
		}
		if (groupLen>1){
			Ext.Msg.alert("提示","任务组只能选择一个");
			return;
		}
		var groupID=groupObj[0].get("groupID");
		var groupDesc=groupObj[0].get("desc");
		//获取任务明细ID
		var obj=taskSectionExcListGrid.getSelectionModel().getSelections();
		var len=obj.length;
		if (len<1){
			Ext.Msg.alert("提示","请先选择操作对象");
			return;
		}
		var kpis="",formatKpis="<br/>"
		for (var i=0;i<len;i++){
			var kpiID=obj[i].get("kpiID");
			if (kpis==""){
				kpis=kpiID;
				formatKpis=kpiID;
			}else{
				if (!(i%10)){
					formatKpis=formatKpis+","+'<br/>'+kpiID;
				}else{
					formatKpis=formatKpis+","+kpiID;
				}
				kpis=kpis+","+kpiID;
			}
		}
		formatKpis=formatKpis+"<br/>"
		htmlStr='<font color=blue style="font-weight:bold">您选择的下列指标从-'+groupDesc+'-组中移除，该操作<font color=blue style="font-weight:bold" size="5">不能恢复！！</font></font>'
		htmlStr=htmlStr+'<br/>'+formatKpis
		htmlStr=htmlStr+'</br><font color=blue style="font-weight:bold">您确定要继续操作么?</font>'
		warnWin = new Ext.Window({
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
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/taskserver.csp?action=deleteTaskDetail&kpis='+kpis+"&groupID="+groupID,"",function(jsonData){
							if(jsonData.success==true && jsonData.tip=="ok"){
								Ext.Msg.alert("提示","移除成功");
								refreshTaskDetail();
								warnWin.close();
							}else{
								Ext.Msg.alert("提示",jsonData.tip);
							}
						},this);
				}
			},{
				text: '<span style="line-Height:1">取消</span>',
				icon: '../images/uiimages/cancel.png',
				handler: function(){
					warnWin.close();   /*--点击取消关闭窗口--*/
				}

			}]
		});		
		warnWin.show();
		
	}
}
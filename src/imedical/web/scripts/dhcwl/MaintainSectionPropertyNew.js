dhcwl.mkpi.MaintainSectionProperty=function(dimId,dimName){
	this.dimId=dimId,this.dimName=dimName;
	var outThis=this;
	//var selectKpiDimId="",selectDimCode="",selectDimCodeName="";
	var serviceUrl="dhcwl/kpi/dimservice.csp";
	var outThis=this;
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'导出到Excel文件',
    			handler:function(){
    				var excelObj=new dhcwl.mkpi.util.Excel();
    				excelObj.setTitle("区间维度属性导出");
    				excelObj.setHead(['ID','维度属性编码','维度属性名称','维度属性描述','执行代码','是否为默认维度属性？']);
    				excelObj.setServerUrl(serviceUrl+'?action=GetSecProList&isArrayType=1&secDimId='+outThis.dimId);
    				excelObj.exportExcel();
    			}
    		}]
	});
	var sm=new Ext.grid.RowSelectionModel({
		singleSelect:true
	});
	 var defaultFlagCombo=new Ext.form.ComboBox({
		width : 150,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		value:'否',
		name : 'isDefaultCombo',
		displayField : 'isDefaultD',
		valueField : 'isDefaultV',
		store : new Ext.data.JsonStore({
			fields : ['isDefaultD', 'isDefaultV'],
			data : [{
				isDefaultD : '否',
				isDefaultV : 'N'
			}, {
				isDefaultD : '是',
				isDefaultV : 'Y'
			}]}),
		listeners :{
			'select':function(combox){
				defaultFlagCombo.setValue(combox.getValue());
			}
		}
	});
	var executeCodeField=new Ext.form.TextField({
    	name:'executeCodeField',
    	listeners:{
    		'focus':function(field,eve){
    			if(null==dhcwl_mkpi_executeCodeWin){
    				dhcwl_mkpi_executeCodeWin=new dhcwl.mkpi.TaskExectCode();
    				dhcwl_mkpi_executeCodeWin.setParentWin(outThis);
    			}
				dhcwl_mkpi_executeCodeWin.setExecCodeType('SEC');
    			dhcwl_mkpi_executeCodeWin.showWin();
    		}
    	}
    });
	this.setSelectValue=function(value){
		var rd=sm.getSelected();
    	rd.set('ExcuteCode',value);
    }
    var columnModel=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :80
        },
        columns: [new Ext.grid.RowNumberer(),{
            header: '维度属性编码',
            dataIndex: 'Code',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({})),
            menuDisabled : true
        }, {
            header: '维度属性名称',
            dataIndex: 'Name',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({})),
            menuDisabled : true
        }, {
            header: '维度属性描述',
            dataIndex: 'Desc',
            //width:160,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({})),
            menuDisabled : true
        }, {
            header: '是否为默认维度属性？',
            dataIndex: 'DefaultFlag',
            editor:new Ext.grid.GridEditor(defaultFlagCombo),
            //menuDisabled : true,
            hidden:true,
            width:40
        }]
    });

    var store = new Ext.data.Store({
        //proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=GetSecProList&secDimId="+dimId}), //+'?action=GetDimProList&dimId='+(outThis.dimId||"")}),
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=GetSecProList&secProCode="}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'Code'},
            	{name: 'Name'},
            	{name: 'Desc'},
            	{name: 'DefaultFlag'},
            	{name: 'OldCode'}
       		]
    	})
    });
    var recorde = Ext.data.Record.create([
    	{name: 'Code'},
        {name: 'Name'},
        {name: 'Desc'},
        {name: 'DefaultFlag'},
        {name: 'OldCode'}
    ]);
    var kpiDimGrid=new Ext.grid.EditorGridPanel({
        frame: true,
        clicksToEdit: 1,
        store: store,
        cm: columnModel,
        sm:sm,
        //width:600,
        flex:1,
        //height:300,
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	},
        	//'rowdblclick':function(gd,rowIndex,e){
        	'rowclick':function(gd,rowIndex,e){
        		rec=sm.getSelected();        		
        		
        		secProCode=rec.get("Code");
        		var url=encodeURI(serviceUrl+'?action=GetSecExcCodeList&secProCode='+secProCode);	
        		excCodeStore.proxy=new Ext.data.HttpProxy({url:url}); 
	    		excCodeStore.reload(); 
        	}
        },
        bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
				'change':function(pt,page){
					store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetSecProList&secDimId='+dimId));
				}
			}
        }),
        tbar: [{
            text: '增加维度属性',
            handler : function(){
            	
            	
             	var initV={Code:'',Name:'',Desc:'',DefaultFlag:'N',ValueDeli:'',OldCode:''};
                store.insert(0,new recorde(initV));
                sm.selectFirstRow();           
            }
        },"-",{
            text: '删除维度属性',
            handler : function(){
           		var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择区间维度属性！");
            		return ;
            	}
            	var oldCode="";
            	oldCode=rd.get('OldCode');
            	if (!oldCode) {
            		store.remove(rd);
            		return;
            	}
            	
            	
            	Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
            			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		            		{'action':'DeleteSecDimProByCode',
		            		 'secDimCode':oldCode
		            		},function(responseText){
		            			outThis.refresh();
		            			alert(responseText.tip);
		            		}
		            		,outThis
		            	);
                    }
            	});
            	
            	
            	//store.clearModified();
            }
        },"-",{
            text: '保存选定行',
            handler : function(){
            	//var rs=store.getModifiedRecords();
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要保存的区间维度属性！");
            		return ;
            	}
            	var code="",name="",desc="",oldCode="",defaultFlag="";
            	code=rd.get('Code');name=rd.get('Name'),desc=rd.get('Desc'),oldCode=rd.get('OldCode'),defaultFlag=rd.get('DefaultFlag');
            	if (oldCode && code!=oldCode) {
            		Ext.Msg.alert("提示","属性编码不能修改");
            		return;
            	}
            	
            	if(!code||code==""){
            		alert("维度属性编码不能为空！");
            		return;
            	}
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(code)||(reg2.test(code))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	return;
                }
        		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
        			{'action':'AddSecDimPro',
        			 'oldCode':oldCode,
        			 'Code':code||'',
        			 'Name':name||'',
        			 'Desc':desc||'',
        			 'DefaultFlag':defaultFlag||''
        			},function(responseText){

        				if(responseText.tip!="ok"){
        					Ext.Msg.show({
								title : '错误',
								msg : "处理失败：\n"
										+ (responseText.tip),
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
        				}else{
        					outThis.refresh();
        				}
        			}
        			,outThis
        		);
            }
        }]
    });
 
	this.show=function(id,dimName){
		//alert("id="+id+"   kpiName="+kpiName);
		this.dimId=id,this.dimName=dimName;
		dimId=id;
		//dimProWin.setTitle('维度属性维护--'+dimName);
		dimProWin.setTitle('维度属性维护');
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetSecProList&start=0&limit=10&secDimId='+id));
		store.load();
		//kpiDimGrid.show();
		dimProWin.show();
	}
	this.refresh=function(){
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetSecProList&start=0&limit=10&secDimId='+this.dimId));
		store.load();
		kpiDimGrid.show();
		dimProWin.show();
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////执行代码grid
	
	
	var excCodeSm=new Ext.grid.RowSelectionModel({
		singleSelect:true
	});
	var excCodeField=new Ext.form.TextField({
    	name:'executeCodeField',
    	listeners:{
    		'focus':function(field,eve){
    			if(null==dhcwl_mkpi_executeCodeWin){
    				dhcwl_mkpi_executeCodeWin=new dhcwl.mkpi.TaskExectCode();
    				dhcwl_mkpi_executeCodeWin.setParentWin(outThis);
    			}
				dhcwl_mkpi_executeCodeWin.setExecCodeType('SEC');
    			dhcwl_mkpi_executeCodeWin.showWin();
    		}
    	}
    });

    var excCodeColumnModel=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :60
        },
        columns: [
        {
            header: '区间编码',
            dataIndex: 'SecCode',
            menuDisabled : true
        }, {
            header: '区间名称',
            dataIndex: 'SecName',
            menuDisabled : true
        }, {
            header: '执行代码',
            dataIndex: 'ExcuteCode',
            width:160,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({})),
            menuDisabled : true
			//editor:new Ext.grid.GridEditor(executeCodeField)
        }]
    });

    var excCodeStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=GetSecProList&secCode="}), //+'?action=GetDimProList&dimId='+(outThis.dimId||"")}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'SecCode'},
            	{name: 'SecName'},
            	{name: 'ExcuteCode'}
       		]
    	})
    });
    var excCodeRecorde = Ext.data.Record.create([
        		{name: 'ID'},
            	{name: 'SecCode'},
            	{name: 'SecName'},
            	{name: 'ExcuteCode'}
    ]);
    var excCodeGrid=new Ext.grid.EditorGridPanel({
        frame: true,
        clicksToEdit: 1,
        store: excCodeStore,
        cm: excCodeColumnModel,
        sm:excCodeSm,
        //width:600,
        flex:1,
        //height:300,

        tbar: [{
            text: '增加执行代码',
            handler : function(){
            	
        		var rec=sm.getSelected();
        		if (!rec) {
        			Ext.Msg.alert("提示","请先选择维度属性！");
        			return;
        		}
        		
            	var oldCode="";
            	oldCode=rec.get('OldCode');
            	if (!oldCode) {
            		return;
            	}       		
        		
        		
        		var secProCode=rec.get("Code");
        		var Name=rec.get("Name");
        		var desc=rec.get("Desc");
        		var DefaultFlag=rec.get("DefaultFlag");
        		var url=serviceUrl+'?action=AddSecPros&secProCode='+secProCode;
				dhcwl.mkpi.Util.ajaxExc(url,{
					'Name':Name,
					'Desc':desc,
					'DefaultFlag':DefaultFlag
				},function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok"){
							
							Ext.Msg.alert("提示","操作成功！");
			        		var url=encodeURI(serviceUrl+'?action=GetSecExcCodeList&secProCode='+secProCode);	
			        		excCodeStore.proxy=new Ext.data.HttpProxy({url:url}); 
				    		excCodeStore.reload(); 
							
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
        },"-",{
            text: '删除执行代码',
            handler : function(){
            	var rd=excCodeSm.getSelected();
            	if(!rd){
            		alert("请选择要删除的执行代码！");
            		return ;
            	}

            	var dimProId=rd.get('ID');
            	if (!dimProId) {
            		excCodeStore.remove(rd);
            		return;
            	}
            	
            	Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
            			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		            		{'action':'DeleteSecDimPro',
		            		 'secDimProId':dimProId||''
		            		},function(responseText){
		            			if(responseText.tip!="ok"){
		            				Ext.Msg.alert("提示","操作失败！");
		            			}else{
					        		rec=sm.getSelected();
					        		secProCode=rec.get("Code");
					        		var url=encodeURI(serviceUrl+'?action=GetSecExcCodeList&secProCode='+secProCode);	
					        		excCodeStore.proxy=new Ext.data.HttpProxy({url:url}); 
						    		excCodeStore.reload(); 
		            			}
		            		}
		            		,outThis
		            	);
                    }
            	});

            	

            }
        },"-",{
            text: '保存选定行',
            handler : function(){
            	
            	var rd=excCodeSm.getSelected();
            	if(!rd){
            		alert("请选择要保存的执行代码！");
            		return ;
            	}
            	
            	var id=rd.get('ID');
            	var excuteCode=rd.get('ExcuteCode');
	       		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
	        			{'action':'updateSecDimProExCode',
	        			 'ID':id,
	        			 'ExcuteCode':excuteCode||''
	        			},function(responseText){
	        				if(responseText.tip!="ok"){
	        					Ext.Msg.show({
									title : '错误',
									msg : "处理响应数据失败！响应数据为：\n"
											+ (responseText.tip),
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
	        				}else{
				        		rec=sm.getSelected();
				        		secProCode=rec.get("Code");
				        		var url=encodeURI(serviceUrl+'?action=GetSecExcCodeList&secProCode='+secProCode);	
				        		excCodeStore.proxy=new Ext.data.HttpProxy({url:url}); 
					    		excCodeStore.reload(); 	        					
	        				}
	        			}
	        			,outThis
	        		);            	
            	//var rs=store.getModifiedRecords();
            	/*
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要保存的区间维度属性！");
            		return ;
            	}
            	var id="",code="",name="",desc="",excuteCode="",defaultFlag="";
            	id=rd.get('ID'),code=rd.get('Code');name=rd.get('Name'),desc=rd.get('Desc'),excuteCode=rd.get('ExcuteCode'),defaultFlag=rd.get('DefaultFlag');
            	if(!code||code==""){
            		alert("维度属性编码不能为空！");
            		return;
            	}
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(code)||(reg2.test(code))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	return;
                }
        		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
        			{'action':'AddSecDimPro',
        			 'ID':id,
        			 'SecDimDr':outThis.dimId,
        			 'Code':code||'',
        			 'Name':name||'',
        			 'Desc':desc||'',
        			 'ExcuteCode':excuteCode||'',
        			 'DefaultFlag':defaultFlag||''
        			},function(responseText){
        				outThis.refresh();
        				if(responseText.tip!="ok"){
        					Ext.Msg.show({
								title : '错误',
								msg : "处理响应数据失败！响应数据为：\n"
										+ (responseText.tip),
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
        				}
        			}
        			,outThis
        		);
        		
        		*/
            }
        }]
    });	
	
	
	
	    var dimProWin= new Ext.Window({
		//layout : 'fit',
    	layout : 'hbox',
    	layoutConfig: {
		    align : 'stretch',
		    pack  : 'start'
		},

		modal : true,
		width : 680,
		height : 400,
		autoScroll:true,
		//closeAction:'hide',
		plain : true,
		title : '维度属性维护',
		id : 'dhcwl_mkpi_secDimPropertyWin',
		items : [kpiDimGrid,excCodeGrid],
		listeners:{
			'close':function(){
				dimProWin.destroy();
				dimProWin.close();
				if(dhcwl_mkpi_seDimPropertyWin){
					dhcwl_mkpi_seDimPropertyWin=null;
				}
			}
		}
	});
	
	
	
	
	
	
	
	
	
}
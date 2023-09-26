dhcwl.mkpi.MaintainSectionProperty=function(dimId,dimName){
	this.dimId=dimId,this.dimName=dimName;
	var outThis=this;
	//var selectKpiDimId="",selectDimCode="",selectDimCodeName="";
	var serviceUrl="dhcwl/kpi/dimservice.csp";
	var outThis=this;
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:210,
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
            width:160,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({})),
            menuDisabled : true
        }, {
            header: '执行代码',
            dataIndex: 'ExcuteCode',
            width:200,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({})),
            menuDisabled : true
			//editor:new Ext.grid.GridEditor(executeCodeField)
        }, {
            header: '是否为默认维度属性？',
            dataIndex: 'DefaultFlag',
            editor:new Ext.grid.GridEditor(defaultFlagCombo),
            menuDisabled : true,
            hidden:true
        }]
    });
    var dimId=0;
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=GetSecProList&secDimId="+dimId}), //+'?action=GetDimProList&dimId='+(outThis.dimId||"")}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'Code'},
            	{name: 'Name'},
            	{name: 'Desc'},
            	{name: 'ExcuteCode'},
            	{name: 'DefaultFlag'}
       		]
    	})
    });
    var recorde = Ext.data.Record.create([
    	{name: 'Code'},
        {name: 'Name'},
        {name: 'Desc'},
        {name: 'ExcuteCode'},
        {name: 'DefaultFlag'}
    ]);
    var kpiDimGrid=new Ext.grid.EditorGridPanel({
        frame: true,
        clicksToEdit: 1,
        store: store,
        cm: columnModel,
        sm:sm,
        width:600,
        height:300,
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
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
            //text: '新增维度属性',
            text: '<span style="line-Height:1">新增维度属性</span>',
            icon: '../images/uiimages/edit_add.png',
            handler : function(){
            	var initV={Code:'',Name:'',Desc:'',ExcuteCode:'',DefaultFlag:'N',ValueDeli:''};
                store.insert(0,new recorde(initV));
                sm.selectFirstRow();
            }
        },"-",{
            //text: '删除维度属性',
            text: '<span style="line-Height:1">删除维度属性</span>',
            icon: '../images/uiimages/edit_remove.png',
            handler : function(){
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要删除的区间维度属性！");
            		return ;
            	}
            	
            	var dimProId=rd.get('ID');
            	if (!dimProId) {
            		store.remove(rd);
            		return;
            	}
            	
            	Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                    	//var dimProId=rd.get('ID');
                    	//alert(dimProId);
            			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		            		{'action':'DeleteSecDimPro',
		            		 'secDimProId':dimProId||''
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
            //text: '保存选定行',
            text: '<span style="line-Height:1">保存选定行</span>',
            icon: '../images/uiimages/filesave.png',
            handler : function(){
            	//var rs=store.getModifiedRecords();
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要保存的区间维度属性！");
            		return ;
            	}
            	kpiDimGrid.stopEditing();
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
            }
        }]
    });
    //store.load({params:{start:0,limit:2}});
    var dimProWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 680,
		height : 400,
		autoScroll:true,
		//closeAction:'hide',
		plain : true,
		title : '维度属性维护',
		id : 'dhcwl_mkpi_secDimPropertyWin',
		items : kpiDimGrid,
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
	//dimProWin.hide(this);
	this.show=function(id,dimName){
		//alert("id="+id+"   kpiName="+kpiName);
		this.dimId=id,this.dimName=dimName;
		dimId=id;
		dimProWin.setTitle('维度属性维护--'+dimName);
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
}
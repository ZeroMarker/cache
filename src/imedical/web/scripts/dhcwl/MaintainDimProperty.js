dhcwl.mkpi.MaintainDimProperty=function(dimId,dimName){
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
    				excelObj.setTitle("维度属性导出");
    				excelObj.setHead(['维度属性编码','维度属性名称','维度属性描述','执行代码','是否为默认维度属性？','拆分维度值的分隔符']);
    				excelObj.setServerUrl(serviceUrl+'?action=GetDimProList&isArrayType=1&dimId='+outThis.dimId);
    				excelObj.exportExcel();
    			}
    		}]
	});
	var sm=new Ext.grid.RowSelectionModel({
		singleSelect:true/*,
		listeners: {
            rowselect: function(sm, row, rec) {
            	var rd=sm.getSelected();
            	selectKpiDimId=rd.get('ID');
            	selectDimCode=rd.get('MKPIDimDimDr');
            	//alert("kpiDimId="+selectKpiDimId+"  dimDr="+selectDimCode);
            }
        }*/
	});
	 var defaultFlagCombo=new Ext.form.ComboBox({
		width : 150,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		//fieldLabel : '是否从指定global获得指标数据',
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
				dhcwl_mkpi_executeCodeWin.setExecCodeType('DIM');
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
            width   :80,menuDisabled : true
        },
        columns: [new Ext.grid.RowNumberer(),{
            header: '维度属性编码',
            dataIndex: 'Code',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }, {
            header: '维度属性名称',
            dataIndex: 'Name',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }, {
            header: '维度属性描述',
            dataIndex: 'Desc',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }, {
            header: '执行代码',
            dataIndex: 'ExcuteCode',
            width:160,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
			//editor:new Ext.grid.GridEditor(executeCodeField)
        }, {
            header: '是否为默认维度属性？',
            dataIndex: 'DefaultFlag',
			width:40,
            editor:new Ext.grid.GridEditor(defaultFlagCombo)
        }, {
            header: '拆分维度值的分隔符',
            dataIndex: 'ValueDeli',
			width:40,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }]
    });
    var dimId=0;
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=GetDimProList&dimId="+dimId}), //+'?action=GetDimProList&dimId='+(outThis.dimId||"")}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'Code'},
            	{name: 'Name'},
            	{name: 'Desc'},
            	{name: 'ExcuteCode'},
            	{name: 'DefaultFlag'},
            	{name: 'ValueDeli'}
       		]
    	})
    });
    var recorde = Ext.data.Record.create([
    	{name: 'Code'},
        {name: 'Name'},
        {name: 'Desc'},
        {name: 'ExcuteCode'},
        {name: 'DefaultFlag'},
        {name: 'ValueDeli'}
    ]);
    var kpiDimGrid=new Ext.grid.EditorGridPanel({
        frame: true,
        clicksToEdit: 1,
        store: store,
        cm: columnModel,
        sm:sm,
		viewConfig: {forceFit: true},
        //autoExpandColumn: 'SecCode', // column with this id will be expanded
        //width:600,
        height:300,
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	},//add by wz.2014-4-3
        	'cellclick' : function(grid,rowIndex,columnIndex,e ){
        		if(columnIndex!=1) return;
        		
	           	var rd=sm.getSelected();
            	if(!rd){
            		return ;
            	}
            	var id="",code="",name="",desc="",excuteCode="",defaultFlag="";
            	id=rd.get('ID'),code=rd.get('Code')        		
				if (id) {
					alert("对已保存的科室维度编码的修改是无效的！");
					return;
				}
        		      		
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
					store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetDimProList&dimId='+dimId));
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
            }
        },"-",{
            //text: '删除维度属性',
            text: '<span style="line-Height:1">删除维度属性</span>',
            icon: '../images/uiimages/edit_remove.png',
            handler : function(){
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要删除的维度属性！");
            		return ;
            	}
            	Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                    	var dimProId=rd.get('ID');
            			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		            		{'action':'DeleteDimPro',
		            		 'dimProId':dimProId||''
		            		},function(responseText){
		            			outThis.refresh();
		            		}
		            		,outThis,true
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
            		alert("请选择要保存的的维度属性！");
            		return ;
            	}
            	var id="",code="",name="",desc="",excuteCode="",defaultFlag="";
            	id=rd.get('ID'),code=rd.get('Code');name=rd.get('Name'),desc=rd.get('Desc'),excuteCode=rd.get('ExcuteCode'),defaultFlag=rd.get('DefaultFlag'),valueDeli=rd.get('ValueDeli');
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
                if(valueDeli=="@"||valueDeli=="&"){
                	alert("拆分维度值的分隔符不能使用@，&符合！");
                	return;
                }
        		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
        			{'action':'AddDimPro',
        			 'ID':id,
        			 'DimDr':outThis.dimId,
        			 'Code':code||'',
        			 'Name':name||'',
        			 'Desc':desc||'',
        			 'ExcuteCode':excuteCode||'',
        			 'DefaultFlag':defaultFlag||'',
        			 'ValueDeli':valueDeli||''
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
            	/*for(var i=rs.length-1;i>-1;i--){
            		id=rs[i].get('ID'),code=rs[i].get('Code');name=rs[i].get('Name'),desc=rs[i].get('Desc'),excuteCode=rs[i].get('ExcuteCode'),defaultFlag=rs[i].get('DefaultFlag');
            		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
            			{'action':'AddDimPro',
            			 'ID':id,
            			 'DimDr':outThis.dimId,
            			 'Code':code||'',
            			 'Name':name||'',
            			 'Desc':desc||'',
            			 'ExcuteCode':excuteCode||'',
            			 'DefaultFlag':defaultFlag||''
            			},function(responseText){
            				//alert(responseText);
            			}
            			,outThis,true
            		);
            	}*/
            	
            }
        },"-",{
            //text: '刷新',
            text: '<span style="line-Height:1">刷新</span>',
            icon: '../images/uiimages/reload2.png',
            handler : function(){
            	outThis.refresh();
            }
        }]
    });
    //store.load({params:{start:0,limit:2}});
    var dimProWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 1000,
		height : 430,
		autoScroll:true,
		//closeAction:'hide',
		plain : true,
		title : '维度属性维护',
		id : 'dhcwl_mkpi_dimPropertyWin',
		items : kpiDimGrid,
		listeners:{
			'close':function(){
				dimProWin.destroy();
				dimProWin.close();
				if(dhcwl_mkpi_dimPropertyWin){
					dhcwl_mkpi_dimPropertyWin=null;
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
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetDimProList&start=0&limit=10&dimId='+id));
		store.load();
		//kpiDimGrid.show();
		dimProWin.show();
	}
	this.refresh=function(){
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetDimProList&start=0&limit=10&dimId='+this.dimId));
		store.load();
		kpiDimGrid.show();
		dimProWin.show();
	}
}
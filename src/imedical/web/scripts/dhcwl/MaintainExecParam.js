dhcwl.mkpi.MaintainExecParam=function(KCode){
	var KPICode="";
	KPICode=KCode;
	var outThis=this;
	var serviceUrl="dhcwl/kpi/kpiexecparam.csp";


	var sm=new Ext.grid.RowSelectionModel({
		singleSelect:true
	});

	

    var columnModel=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :160,menuDisabled : true
        },
        columns: [new Ext.grid.RowNumberer(),{
            header: '参数名称',
            dataIndex: 'Name',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }, {
            header: '参数描述',
            dataIndex: 'Desc',
            width   :320,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }]
    });

    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=lookupObj&className=DHCWL.MKPI.ExecParam&Param_KPICode="+KPICode}), //+'?action=GetDimProList&dimId='+(outThis.dimId||"")}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'Name'},
            	{name: 'Desc'}
       		]
    	})
    });
    var recorde = Ext.data.Record.create([
        {name: 'Name'},
        {name: 'Desc'}
    ]);
    var paramGrid=new Ext.grid.EditorGridPanel({
        frame: true,
        clicksToEdit: 1,
        store: store,
        cm: columnModel,
        sm:sm,
        width:600,
        height:300,
        listeners:{
        	'cellclick' : function(grid,rowIndex,columnIndex,e ){
    		      		
        	}
        },
        tbar: [{
            text: '增加执行代码参数',
            handler : function(){
            	var initV={Name:'',Desc:''};
                store.insert(0,new recorde(initV));
            }
        },"-",{
            text: '删除执行代码参数',
            handler : function(){
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要删除的维度属性！");
            		return ;
            	}
            	Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                    	var execParamId=rd.get('ID');
            			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		            		{'action':'DeleteExecParam',
		            		 'ID':execParamId
		            		},function(responseText){
		            			outThis.refresh();
		            		}
		            		,outThis,true
		            	);
                    }
            	});
            	
            }
        },"-",{
            text: '保存选定行',
            handler : function(){
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要保存的的执行代码参数！");
            		return ;
            	}
            	var id="",name="",desc="";
            	id=rd.get('ID'),name=rd.get('Name'),desc=rd.get('Desc');
            	if(!name||name==""){
            		alert("参数不能为空！");
            		return;
            	}
                var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(name)||(reg2.test(name))){
                	alert("参数不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	return;
                }
                dhcwl.mkpi.Util.ajaxExc(serviceUrl,
        			{'action':'SaveExecParam',
        			 'ID':id,
        			 'Name':name||'',
        			 'Desc':desc||'',
        			 'KPICode':KPICode
        			},function(responseText){
        				outThis.refresh();
        				if(responseText.tip!="ok"){
        					Ext.Msg.show({
								title : '错误',
								msg : "处理响应数据失败！响应数据为：\n"
										+ (responseText.SQLCODE),
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
        				}
        			}
        			,outThis
        		);
           	
            }
        },"-",{
            text: '刷新',
            handler : function(){
            	outThis.refresh();
            }
        }]
    });
    //store.load({params:{start:0,limit:2}});
    var execParamWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 680,
		height : 400,
		autoScroll:true,
		closeAction:'hide',
		plain : true,
		title : '参数维护',
		id : 'dhcwl_mkpi_execParamWin',
		items : paramGrid,
		listeners:{
			'close':function(){
				//execParamWin.destroy();
				store.removeAll();
				execParamWin.close();
				/*
				if(dhcwl_mkpi_execParamWin){
					dhcwl_mkpi_execParamWin=null;
				}
				*/
			},
			'hide':function(th){
				store.removeAll();				
			}
		}
	});
	this.show=function(KCode){
		KPICode=KCode;
		execParamWin.setTitle('执行代码参数维护--'+KPICode);
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=lookupObj&className=DHCWL.MKPI.ExecParam&KPICode='+KPICode));
		store.load();
		execParamWin.show();
	}
	this.refresh=function(){
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=lookupObj&className=DHCWL.MKPI.ExecParam&KPICode='+KPICode));
		store.load();
		paramGrid.show();
		execParamWin.show();
	}
}
dhcwl.mkpi.MaintainDimProperty=function(dimId,dimName){
	this.dimId=dimId,this.dimName=dimName;
	var outThis=this;
	//var selectKpiDimId="",selectDimCode="",selectDimCodeName="";
	var serviceUrl="dhcwl/kpi/dimservice.csp";
	var outThis=this;
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
				activeFlagCombo.setValue(combox.getValue());
			}
		}
	});
    var columnModel=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :80
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
            width:160,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }, {
            header: '执行代码',
            dataIndex: 'ExcuteCode',
            width:160,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }, {
            header: '是否为默认维度属性？',
            dataIndex: 'DefaultFlag',
            editor:new Ext.grid.GridEditor(defaultFlagCombo)
        }]
    });
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl}), //+'?action=GetDimProList&dimId='+(outThis.dimId||"")}),
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
        //autoExpandColumn: 'SecCode', // column with this id will be expanded
        width:600,
        height:300,
        bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),
        tbar: [{
            text: '增加维度属性',
            handler : function(){
            	var initV={Code:'',Name:'',Desc:'',ExcuteCode:'',DefaultFlag:'N'};
                store.insert(0,new recorde(initV));
            }
        },"-",{
            text: '删除维度属性',
            handler : function(){
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要删除的指标维度！");
            		return ;
            	}
            	var dimProId=rd.get('ID');
            	dhcwl.mkpi.Util.ajaxExc(serviceUrl,
            		{'action':'DeleteDimPro',
            		 'dimProId':dimProId||''
            		},function(responseText){
            				outThis.refresh();
            			}
            			,outThis,true
            	);
            	
            	//store.clearModified();
            }
        },"-",{
            text: '保存',
            handler : function(){
            	//var rs=store.getModifiedRecords();
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要保存的指标维度！");
            		return ;
            	}
            	var id="",code="",name="",desc="",excuteCode="",defaultFlag="";
            	id=rd.get('ID'),code=rd.get('Code');name=rd.get('Name'),desc=rd.get('Desc'),excuteCode=rd.get('ExcuteCode'),defaultFlag=rd.get('DefaultFlag');
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
        				outThis.refresh();
        			}
        			,outThis,true
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
            text: '刷新',
            handler : function(){
            	outThis.refresh();
            }
        }]
    });
    store.load({params:{start:0,limit:10}});
    var dimProWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 600,
		height : 400,
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
		dimProWin.setTitle('维度属性维护--'+dimName);
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetDimProList&start=0&limit=10&dimId='+id));
		store.load();
		kpiDimGrid.show();
		dimProWin.show();
	}
	this.refresh=function(){
		store.proxy.setUrl(encodeURI(serviceUrl+'?action=GetDimProList&start=0&limit=10&dimId='+this.dimId));
		store.load();
		kpiDimGrid.show();
		dimProWin.show();
	}
}
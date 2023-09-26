dhcwl.mkpi.MaintainKpiDim=function(kpiId,kpiName){
	this.kpiId=kpiId,this.kpiName=kpiName;
	var outThis=this;
	var selectKpiDimId="",selectDimCode="",selectDimCodeName="";
	var serviceUrl="dhcwl/kpi/kpidimservice.csp";
	var outThis=this;
	var kpiDimList=[];
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'维度属性',
    			handler:function(cmp,event){
    				var sm = kpiDimGrid.getSelectionModel();
                	if(!sm){
                		alert("请选择一行！");
                		return;
                	}
                    var record = sm.getSelected();
                    if(!record){
                		alert("请选择一行！");
                		return;
                	}
                    var dimId=record.get('MKPIDimDimDr'),dimName=record.get('KDT_Name');
                    getDimPro().show(dimId,dimName);
    			}
    		}]
	});
	var sm=new Ext.grid.RowSelectionModel({
		singleSelect:true,
		listeners: {
        	rowselect: function(sm, row, rec) {
        		dimCombo.store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimDimList&kpiId='+outThis.kpiId));
				dimCombo.store.load();
        		var rd=sm.getSelected();
        		selectKpiDimId=rd.get('ID');
        		selectDimCode=rd.get('MKPIDimDimDr');
        		//alert("kpiDimId="+selectKpiDimId+"  dimDr="+selectDimCode);
            }
        }
	});
	var dimCombo=new Ext.form.ComboBox({
		id:'kpiDimDimCombobox',
		width:300,
		//autoWidth:true,
		//editable:false,
		enableKeyEvents:true,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择指标维度',
		//fieldLabel : '日期区间类型',
		name : 'kpiDimCombo',
		displayField : 'KDTName',
		valueField : 'KDTCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:serviceUrl}), //+'?action=GetKpiDimDimList'}),
			reader:new Ext.data.ArrayReader({},[{name:'KDTCode'},{name:'KDTName'}])
		}),
		listeners :{
			'select':function(combox){
				selectDimCode=combox.getValue();
				selectDimCodeName=combox.getRawValue();
				//combox.setValue(selectDimCodeName);
				var rd=sm.getSelected(),nums=kpiDimList.length;
				rd.set("KDT_Name",selectDimCodeName);
			},
			'keyup':function(filed,event){
				if(event.getKey()>37&&event.getKey()<41) return;
				var seaValue=Ext.get("kpiDimDimCombobox").getValue();
				dimCombo.store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimDimList&kpiId='+outThis.kpiId+'&searcheValue='+seaValue));
				dimCombo.store.load();
			}
		}
	});
    var columnModel=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :80
        },
        columns: [
        new Ext.grid.RowNumberer(),{
            header: '指标维度编码',
            dataIndex: 'MKPIDimCode',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        },{
            header: '指标维度描述',
            dataIndex: 'MKPIDimDes',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }, {
            header: '关联维度编码',
            width:200,
            dataIndex: 'MKPIDimDimDr',
            editor:new Ext.grid.GridEditor(dimCombo)
        }, {
            header: '关联维度名称',
            width:250,
            dataIndex: 'KDT_Name',
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))
        }, {
            header: '维度顺序',
            dataIndex: 'MKPIDimOrder',
            width:60,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }, {
            header: '指标维度分隔符',
            dataIndex: 'MKPIDimDeli',
            width:60,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }]
    });
    var tempKpiId=0;
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=GetKpiDimList&kpiId="+tempKpiId}), //url:serviceUrl+'?action=GetKpiDimList&kpiId='+(outThis.kpiId||"")}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
        		{name: 'MKPIDimCode'},
            	{name: 'MKPIDimDes'},
            	{name: 'MKPIDimDimDr'},
            	{name: 'KDT_Name'},
            	{name: 'MKPIDimOrder'},
            	{name: 'MKPIDimDeli'}
       		]
    	})
    });
    var recorde = Ext.data.Record.create([
    	{name: 'MKPIDimCode'},
    	{name: 'MKPIDimDes'},
        {name: 'MKPIDimDimDr'},
        {name: 'MKPIDimOrder'},
        {name: 'MKPIDimDeli'}
    ]);
    var kpiDimGrid=new Ext.grid.EditorGridPanel({
        frame: true,
        clicksToEdit: 1,
        store: store,
        cm: columnModel,
        sm:sm,
        //autoExpandColumn: 'SecCode', // column with this id will be expanded
        width:730,
        height:300,
        bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
             listeners :{
				'change':function(pt,page){
					store.proxy.setUrl(encodeURI(serviceUrl+"?action=GetKpiDimList&kpiId="+tempKpiId));
				}
			}
        }),
        tbar: [{
            text: '增加指标维度',
            handler : function(){
            	var nums=store.getCount()+1;
            	var initV={MKPIDimDes:'',MKPIDimDimDr:'',MKPIDimOrder:nums};
                store.insert(0,new recorde(initV));
            }
        },"-",{
            text: '删除指标维度',
            handler : function(){
            	var rd=sm.getSelected();
            	if(!rd){
            		alert("请选择要删除的指标维度！");
            		return ;
            	}
            	Ext.Msg.confirm('信息', '确定要删除？', function(btn){
                    if (btn == 'yes') {
                    	var kpiDimId=rd.get('ID');
		            	dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		            		{'action':'DeleteKpiDim',
		            		 'kpiDimId':kpiDimId||''
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
            		alert("请选择要保存的指标维度！");
            		return ;
            	}
            	//var rs=store.getModifiedRecords();
            	var kpiDimId="",kpiDimCode="",kpiDimDesc="",kpiDimOrder="",kpiDimDimCode="";
            	kpiDimId=rd.get('ID'),kpiDimDesc=rd.get('MKPIDimDes');kpiDimOrder=rd.get('MKPIDimOrder'),kpiDimDimCode=rd.get('MKPIDimDimDr'),MKPIDimDeli=rd.get('MKPIDimDeli');
        		kpiDimCode=rd.get('MKPIDimCode');
        		if(!kpiDimCode||kpiDimCode==""){
        			Ext.Msg.show({
						title : '错误',
						msg : "必须输入指标维度编码！",
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
					return;
        		}
        		var reg=/[\$\#\@\&\%\!\*\^\~||]/;
                var reg2=/^\d/;
                if(reg.test(kpiDimCode)||(reg2.test(kpiDimCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符，并且不能以数字开头！");
                	return;
                }
                if(MKPIDimDeli=="@"||MKPIDimDeli=="&"){
                	alert("分隔符不能使用@，&符合！");
                	return;
                }
        		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
        			{'action':'AddKpiDim',
        			 'kpiId':outThis.kpiId,
        			 'MKPIDimCode':kpiDimCode,
        			 'kpiDimId':kpiDimId||'',
        			 'kpiDimDesc':kpiDimDesc||'',
        			 'MKPIDimOrder':kpiDimOrder||'',
        			 'MKPIDimDimDr':kpiDimDimCode||'',
        			 'MKPIDimDeli':MKPIDimDeli||','
        			},function(responseText){
        				outThis.refresh();
        				jsonData = Ext.util.JSON.decode(responseText);
        				if((jsonData.tip)!="ok"){
        					Ext.Msg.show({
								title : '错误',
								msg : "处理响应数据失败！响应数据为：\n"
										+ (jsonData.tip),
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
        				}
        			}
        			,outThis,true
        		);
            	/*for(var i=rs.length-1;i>-1;i--){
            		kpiDimId=rs[i].get('ID'),kpiDimDesc=rs[i].get('MKPIDimDes');kpiDimOrder=rs[i].get('MKPIDimOrder'),kpiDimDimCode=rs[i].get('MKPIDimDimDr');
            		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
            			{'action':'AddKpiDim',
            			 'kpiId':outThis.kpiId,
            			 'kpiDimId':kpiDimId||'',
            			 'kpiDimDesc':kpiDimDesc||'',
            			 'MKPIDimOrder':kpiDimOrder||'',
            			 'MKPIDimDimDr':kpiDimDimCode||''
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
    //store.load({params:{start:0,limit:10}});
    var kpiDimWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 750,
		height : 400,
		autoScroll:true,
		//closeAction:'hide',
		plain : true,
		title : '指标维度维护',
		id : 'dhcwl_mkpi_mantainKpiDim',
		items : kpiDimGrid,
		listeners:{
			'close':function(){
				store.clearModified();
				var rd=null;
        		for(var i=store.getCount()-1;i>-1;i--){
        			rd=store.getAt(i);
        			//selectDimCode=rd.get("MKPIDimDimDr");
        			selectDimCodeName=rd.get("MKPIDimDes");   //rd.get("KDT_Name");
        			//kpiDimList[i*2]=selectDimCode;
					//kpiDimList[i*2+1]=selectDimCodeName;
        			kpiDimList[i]=selectDimCodeName;
        		}
				kpiDimWin.destroy();
				kpiDimWin.close();
				if(dhcwl_mkpi_mantainKpiDim){
					dhcwl_mkpi_mantainKpiDim=null;
				}
				//dhcwl_mkpi_showKpiWin.refresh();
				dhcwl_mkpi_showKpiWin.setKpiFormFile({dimType:kpiDimList.join(",")})
			}
		}
	});
	function getDimPro(){
    	if(!dhcwl_mkpi_dimPropertyWin){
    		dhcwl_mkpi_dimPropertyWin=new dhcwl.mkpi.MaintainDimProperty("","");
    	}
    	return dhcwl_mkpi_dimPropertyWin;
    }
	this.getKpiDim=function(){
		if(!dhcwl_mkpi_mantainKpiDim){
			dhcwl_mkpi_mantainKpiDim=new dhcwl.mkpi.MaintainKpiDim(); 
		}
		return dhcwl_mkpi_mantainKpiDim;
	}
	//kpiDimWin.hide(this);
	this.show=function(id,kpiName){
		//alert("id="+id+"   kpiName="+kpiName);
		tempKpiId=id;
		this.kpiId=id,this.kpiName=kpiName;
		kpiDimWin.setTitle('指标维度维护--'+kpiName);
		store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimList&start=0&limit=10&kpiId='+id));
		store.load();
		dimCombo.store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimDimList&kpiId='+id));
		dimCombo.store.load();
		//dimCombo.show();
		kpiDimGrid.show();
		kpiDimWin.show();
	}
	this.refresh=function(){
		dimCombo.store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimDimList&kpiId='+this.kpiId));
		dimCombo.store.load();
		//dimCombo.show();
		store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimList&start=0&limit=10&kpiId='+this.kpiId));
		store.load();
		
		kpiDimGrid.show();
		kpiDimWin.show();
	}
}
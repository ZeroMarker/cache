(function(){
	Ext.ns("dhcwl.mkpi.MaintainKpiDim");
})();
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
        	'rowselect': function(sm, row, rec) {
        		dimCombo.store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimDimList&kpiId='+outThis.kpiId));
				dimCombo.store.load();
        		var rd=sm.getSelected();
        		selectKpiDimId=rd.get('ID');
        		selectDimCode=rd.get('MKPIDimDimDr');
        		//alert("kpiDimId="+selectKpiDimId+"  dimDr="+selectDimCode);
            }
        }
	});
	
	////
	//add by wz.2014-7-23
	function seltext(v, record) {
    	return record.KDTCode+ record.KDTName;
	}
	
	var dimCombo=new Ext.form.ComboBox({
		id:'kpiDimDimCombobox',
		width:300,
		//autoWidth:true,
		editable:false,
		enableKeyEvents:true,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		selectOnFocus:true,
		emptyText:'请选择指标维度',
		//fieldLabel : '日期区间类型',
		name : 'kpiDimCombo',
		//displayField : 'KDTName',	//--modify by wz.2014-7-23
		displayField : 'KDTNameCode',
		valueField : 'KDTCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=GetKpiDimDimList'}),
			//reader:new Ext.data.ArrayReader({},[{name:'KDTCode'},{name:'KDTName'}])	
			//add by wz.2014-7-23
			reader:new Ext.data.ArrayReader({},[{name:'KDTCode'},{name:'KDTName'},{name:'KDTNameCode'}])


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
				if(seaValue.length>0){
					dimCombo.store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimDimList&kpiId='+outThis.kpiId+'&searcheValue='+seaValue));
					dimCombo.store.load();
				}
			}
		}
	});
    var columnModel=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :15,menuDisabled : true
        },
        columns: [
        new Ext.grid.RowNumberer(),{
            header: '指标维度编码',
            dataIndex: 'MKPIDimCode'
        },{
            header: '指标维度描述',
			width:30,
            dataIndex: 'MKPIDimDes'
        }, {
            header: '关联维度编码',
            dataIndex: 'MKPIDimDimDr'
        }, {
            header: '关联维度名称',
            width:30,
            dataIndex: 'KDT_Name'
        }, {
            header: '维度顺序',
            dataIndex: 'MKPIDimOrder'
        }, {
            header: '指标维度分隔符',
            dataIndex: 'MKPIDimDeli',
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
		{name: 'KDT_Name'},
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
		viewConfig: {
			forceFit: true             //强制充满
		},
        /*bbar:new Ext.PagingToolbar({
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
        }),*/
        tbar: [{
            //text: '维护指标维度',
			text: '<span style="line-Height:1">维护指标维度</span>',
            icon: '../images/uiimages/edit_add.png',
            handler : function(){
            	dimRoleObj=new dhcwl.mkpi.DimroleSelector();
				dimRoleObj.setParentWin(outThis);
				dimRoleObj.showWin();
            }
        },"-",{
            //text: '保存',
			text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
            handler : function(){
				var recCnt=kpiDimGrid.getStore().getCount();
				if (recCnt<=0) {
					Ext.Msg.alert("提示","先维护指标维度之后才能保存");
					return;
				} 
				Ext.MessageBox.confirm('提示框','将按照当前表格中维护的信息覆盖原来指标维度，确认保存么？',function(btn){
		    		 if(btn=='yes'){

						var aryKpiDimCode=[];
						var aryKpiDimName=[];
						var aryDimCode=[];
						var aryDimName=[];
						var aryDimOrder=[];
						var aryDimDeli=[];
						
						for(var i=0;i<=recCnt-1;i++){
							rec=kpiDimGrid.getStore().getAt(i);
							if (rec.get("MKPIDimCode")=="" || rec.get("MKPIDimDes")=="" || rec.get("MKPIDimDimDr")=="" || rec.get("KDT_Name")=="" || rec.get("MKPIDimOrder")==""  || rec.get("MKPIDimDeli")=="" ) {
								Ext.Msg.alert("提示","不能存在为空的信息！");
								return;
							}
							aryKpiDimCode.push(rec.get("MKPIDimCode"));
							aryKpiDimName.push(rec.get("MKPIDimDes"));
							aryDimCode.push(rec.get("MKPIDimDimDr"));
							aryDimName.push(rec.get("KDT_Name"));
							aryDimOrder.push(rec.get("MKPIDimOrder"));
							aryDimDeli.push(rec.get("MKPIDimDeli"));						
						}
						var strKpiDimCode=aryKpiDimCode.toString();
						var strKpiDimName=aryKpiDimName.toString();
						var strDimCode=aryDimCode.toString();
						var strDimName=aryDimName.toString();
						var strDimOrder=aryDimOrder.toString();
						var strDimDeli=aryDimDeli.toString();
						dhcwl.mkpi.Util.ajaxExc(serviceUrl,{
							action:'AddKpiDim',
							'kpiId':outThis.kpiId,
							strKpiDimCode:strKpiDimCode,
							strKpiDimName:strKpiDimName,
							strDimCode:strDimCode,
							strDimName:strDimName,
							strDimOrder:strDimOrder,
							strDimDeli:strDimDeli},
							function(jsonData){
							if(jsonData.success==true && jsonData.tip=="ok"){
								Ext.Msg.alert("提示","保存成功！");
								//outThis.refresh(); 
							}else{
								Ext.Msg.alert("保存失败",jsonData.error);
							}
						},this);
					}
				});
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
    //store.load({params:{start:0,limit:10}});
    var kpiDimWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 1000,
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
	this.getKpiDimInfor=function(dimCode,dimName,dimroleCode,dimroleName){
		var rd=sm.getSelected();
    	rd.set('MKPIDimCode',dimroleCode);
		rd.set('MKPIDimDes',dimroleName);
		rd.set('MKPIDimDimDr',dimCode);
		rd.set('KDT_Name',dimName);
	}
	this.getStore=function(){
		return store;
	}
	this.getRecord=function(){
		return recorde;
	}
	this.getKpiId=function(){
		return this.kpiId;
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
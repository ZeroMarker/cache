dhcwl.mkpi.KpiDimTemplate=function(){
	var serviceUrl="dhcwl/kpi/kpidimservice.csp";
	var sm=new Ext.grid.RowSelectionModel({
		singleSelect:true,
		listeners: {
        	rowselect: function(sm, row, rec) {
        		dimCombo.store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimDimList'));
				dimCombo.store.load();
        		//alert("kpiDimId="+selectKpiDimId+"  dimDr="+selectDimCode);
            }
        }
	});
	var outThis=this;
	var dimCombo=new Ext.form.ComboBox({
		id:'kpiDimTempCombobox',
		width:300,
		enableKeyEvents:true,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择指标维度',
		name : 'kpiDimCombo',
		displayField : 'KDTName',
		valueField : 'KDTCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=GetKpiDimDimList'}),
			reader:new Ext.data.ArrayReader({},[{name:'KDTCode'},{name:'KDTName'}])
		}),
		listeners :{
			'select':function(combox){
				selectDimCode=combox.getValue();
				selectDimCodeName=combox.getRawValue();
				var rd=sm.getSelected();
				rd.set("KDT_Name",selectDimCodeName);
			},
			'keyup':function(filed,event){
				if(event.getKey()>37&&event.getKey()<41) return;
				var seaValue=Ext.get("kpiDimTempCombobox").getValue();
				dimCombo.store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimDimList&searcheValue='+seaValue));
				dimCombo.store.load();
			}
		}
	});
    var columnModel=new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width   :80,menuDisabled : true
        },
        columns: [
        new Ext.grid.RowNumberer(),{
            header: '指标维度编码',
            dataIndex: 'MKPIDimCode'
        },{
            header: '指标维度描述',
            dataIndex: 'MKPIDimDes'
        }, {
            header: '关联维度编码',
            width:200,
            dataIndex: 'MKPIDimDimDr'
        }, {
            header: '关联维度名称',
            width:250,
            dataIndex: 'KDT_Name'
        }, {
            header: '维度顺序',
            dataIndex: 'MKPIDimOrder',
            width:60
        }, {
            header: '指标维度分隔符',
            dataIndex: 'MKPIDimDeli',
            width:60,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))
        }]
    });
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl}), //url:serviceUrl+'?action=GetKpiDimList&kpiId='+(outThis.kpiId||"")}),
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
    	id:'dhcwl_mkpi_kpiDimTemplateGrid',
        frame: true,
        clicksToEdit: 1,
        store: store,
        cm: columnModel,
        sm:sm,
        width:730,
        height:300,
        tbar: [{
            text: '<span style="line-Height:1">维护指标维度</span>',
			icon: '../images/uiimages/edit_add.png',
            handler : function(){
            	dimRoleObj=new dhcwl.mkpi.DimroleSelector();
				dimRoleObj.setParentWin(outThis);
				dimRoleObj.showWin();
            }
        },"-",{
            text: '<span style="line-Height:1">保存</span>',
			icon: '../images/uiimages/filesave.png',
            handler : function(){
            	var rd=null,kpiDimId="",kpiDimCode="",kpiDimDesc="",kpiDimOrder="",MKPIDimDimDr="",MKPIDimDeli="";
            	var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
            	if(!selectedKpiIds||selectedKpiIds.length==0){
            		alert("请选择指标！");
            		return;
            	}
            	if(store.getCount()<=0){
            		alert("无数据可保存！")
            		return;
            	}
            	var kpiDimArr={};
            	for(var i=store.getCount()-1;i>-1;i--){
            		rd=store.getAt(i);
            		kpiDimId=rd.get('ID'),kpiDimDesc=rd.get('MKPIDimDes');kpiDimOrder=rd.get('MKPIDimOrder'),MKPIDimDimDr=rd.get('MKPIDimDimDr'),MKPIDimDeli=rd.get('MKPIDimDeli');
        			kpiDimCode=rd.get('MKPIDimCode');
        			
        			
        			kpiDimOrder=(kpiDimOrder+'').trim();
	         		if (kpiDimOrder=="") {
	        			Ext.Msg.alert("提示","指标维度序号不能为空");
	        			return;
	        		}
	
	        		if (MKPIDimDimDr.trim()=="") {
	        			Ext.Msg.alert("提示","关联维度编码不能为空");
	        			return;
	        		}        		
	   
	        		if (kpiDimDesc.trim()=="") {
	        			Ext.Msg.alert("提示","维度属性描述不能为空");
	        			return;
	        		}        			
        			
        			
        			if(!kpiDimCode||kpiDimCode.trim()==""){
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
	                kpiDimArr['MKPIDimCode'+(i+1)]=kpiDimCode,
	                kpiDimArr['kpiDimId'+(i+1)]=kpiDimId||'',
	                kpiDimArr['MKPIDimDes'+(i+1)]=kpiDimDesc||'';
	                kpiDimArr['MKPIDimOrder'+(i+1)]=kpiDimOrder||'',
	                kpiDimArr['MKPIDimDimDr'+(i+1)]=MKPIDimDimDr||'',
	                kpiDimArr['MKPIDimDeli'+(i+1)]=MKPIDimDeli||',';
            	}
            	kpiDimArr['kpiDimNum']=store.getCount(),
            	kpiDimArr['action']='AddKpiDimTemplate',
            	kpiDimArr['kpiIds']=selectedKpiIds.join(",");
            	dhcwl.mkpi.Util.ajaxExc(serviceUrl,
        			kpiDimArr,
        			function(responseText){
        				jsonData = Ext.util.JSON.decode(responseText);
        				if((jsonData.tip)!="ok"){
        					Ext.Msg.show({
								title : '错误',
								msg : "处理响应数据失败！响应数据为：\n"
										+ (responseText),
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
        				}else{
        					if (jsonData.MSG!="ok") {
        						Ext.Msg.alert("提示",jsonData.MSG);
        						return;
        						
        					}else{
								var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
								if(selectedKpiIds.length==1){
									store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimList&start=0&limit=10&kpiId='+selectedKpiIds[0]));
									store.load();
									kpiDimGrid.show();
								}
	        					
	        					alert("保存成功！");
        					}
        				}
        			}
        			,outThis,true
        		);
        		//dhcwl_mkpi_showKpiWin.refresh();
            }
        }]
    });
    //store.load({params:{start:0,limit:10}});
    var kpiDimWin= new Ext.Window({
    	id:'dhcwl_mkpi_kpiDimTemplateWin',
		layout : 'fit',
		//modal : true,
		width : 750,
		height : 400,
		autoScroll:true,
		//closeAction:'hide',
		plain : true,
		title : '指标维度维护',
		items : kpiDimGrid,
		listeners:{
			'close':function(){
				store.clearModified();
				kpiDimWin.destroy();
				kpiDimWin.close();
				if(dhcwl_mkpi_kpiDimTemplate){
					dhcwl_mkpi_kpiDimTemplate=null;
				}
				dhcwl_mkpi_showKpiWin.setKpiFormFile("")
			}
		}
	});
	
	this.getStore=function(){
		return store;
	}
	this.getRecord=function(){
		return recorde;
	}
	this.getKpiId=function(){
		return "model";
	}
	this.getKpiDimInfor=function(dimCode,dimName,dimroleCode,dimroleName){
		var rd=sm.getSelected();
    	rd.set('MKPIDimCode',dimroleCode);
		rd.set('MKPIDimDes',dimroleName);
		rd.set('MKPIDimDimDr',dimCode);
		rd.set('KDT_Name',dimName);
	}

	//kpiDimWin.hide(this);
	this.show=function(){
		var selectedKpiIds=dhcwl_mkpi_showKpiWin.getSelectedKpiIds();
		if(selectedKpiIds.length==1){
			store.proxy.setUrl(encodeURI('dhcwl/kpi/kpidimservice.csp?action=GetKpiDimList&start=0&limit=10&kpiId='+selectedKpiIds[0]));
			store.load();
			kpiDimGrid.show();
		}
		kpiDimWin.setTitle('指标维度维护模板');
		kpiDimGrid.show();
		kpiDimWin.show();
	}
}
dhcwl.mkpi.KpiDimTemplate.getKpiDimTemplate=function(){
		if(!dhcwl_mkpi_kpiDimTemplate){
			dhcwl_mkpi_kpiDimTemplate=new dhcwl.mkpi.KpiDimTemplate(); 
		}
		return dhcwl_mkpi_kpiDimTemplate;
	}
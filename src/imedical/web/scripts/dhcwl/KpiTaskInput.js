(function(){
	Ext.ns("dhcwl.mkpi.KpiTaskInput");
})();

dhcwl.mkpi.KpiTaskInput=function(storeKpiTaskGroup){
	
	var serverSaveFileName="";
	var inputForm = new Ext.form.FormPanel({
		bodyStyle:'padding:5px',
		labelWidth : 120,
        frame:true,
        border:false,
        fileUpload:true,
		items:[{
			xtype:'textfield',
			allowBlank:false,
			hideLabel:false,
			name:'inputKpiTaskFile',
			fieldLabel:'选择导入指标文件',
			buttonText: '浏览2',
			inputType:'file',
			width: 258,
			id:'selectInputKpiTaskFile'
		}], 
		tbar: new Ext.Toolbar([{
        	text: '<span style="line-Height:1">读入指标任务文件</span>',
        	icon: '../images/uiimages/uploadyun.png',
            handler: function(){
				var path=Ext.get('selectInputKpiTaskFile').getValue();
				var readStr="",theStep=1,sc;
    			var inputCont={};
    			do{
    				readStr=dhcwl.mkpi.util.XML.stepTraverXML(path,512);  //dhcwl.mkpi.Util.stepReadFile(file,512);
    				inputCont["Node"+(theStep)]=readStr;
    				theStep++;
    			}while(readStr&&readStr!="");
    			dhcwl.mkpi.util.XML.close();
    			Ext.Ajax.request({
					url: encodeURI('dhcwl/kpi/taskserver.csp?action=UPTaskFile&theStep='+(theStep-1)),
					method:'POST',
					//waitMsg : '正在处理...',
					params:inputCont,
					timeout:60000,
					failure: function(result, request){
						alert(request);
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){	
						var jsonData;
						store.clearData();
						kpiTaskGrid.show();
						//alert(result.responseText);
						try{
							inputForm.body.unmask();
							jsonData = Ext.util.JSON.decode( result.responseText );
							
							if (jsonData.info=="wrong") {
								Ext.Msg.show({title:'错误',msg:jsonData.tips,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}
							var inputKpiList=jsonData.root; //findKpiNameFromXML(path,kpis);
		        			store.loadData(inputKpiList);
		        			kpiTaskGrid.show();
		        			serverSaveFileName=jsonData.tips;
		        			alert("文件读入成功！");
		        			//alert(jsonData.tempFile);
						}catch(e){
							Ext.Msg.show({title:'错误',msg:result.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
					}
    			});
    			inputForm.body.mask("数据处理中，请勿进行操作");
            }
        },'-',{
			text: '<span style="line-Height:1">导入指标任务文件</span>',
			icon: '../images/uiimages/importdata.png',
			handler: function(){
				if(serverSaveFileName==""){
						alert("请读入任务组！");
						return;
					}
					if(serverSaveFileName==null){
						Ext.Msg.show({title:'提示',msg:'已经执行导入操作了，请重新点击读入文件！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					var realInputKpiList=[];
					for(var i=store.getCount()-1;i>=0;i-- ){
						if(sm.isSelected(i)){
							realInputKpiList.push(store.getAt(i).get('kpiCode'));
						}
					}
					if(realInputKpiList.length<=0){
						Ext.Msg.show({title:'提示',msg:'未选择要导入的任务组',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					
					var url='dhcwl/kpi/taskserver.csp'; 
					Ext.Ajax.request({
						url: encodeURI(url),
						method:'POST',
						waitMsg : '正在处理...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:result.responseText+'<br/>\n导入超时，文件太大，请将文件分为多个依次导入!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){	
							inputForm.body.unmask();
							var jsonData;
							try{
								jsonData = Ext.util.JSON.decode( result.responseText );
							}catch(e){
								Ext.Msg.show({title:'错误',msg:result.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}
							if(jsonData.info=='ok'){
								Ext.Msg.show({title:'提示',msg:jsonData.tips,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
								storeKpiTaskGroup.load();
							}else{
								Ext.Msg.show({title:'错误',msg:jsonData.tips,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						params:{
							action:'inputKpiTask',
							fileName:serverSaveFileName,
							realInputTaskList:realInputKpiList.join(",")
						},
						timeout:1800000
					});
					inputForm.body.mask("数据处理中，请勿进行操作");
					serverSaveFileName=null;
					return;
			}
		}])
    });
	
	
	var sm=new Ext.grid.CheckboxSelectionModel();
	var column=new Ext.grid.ColumnModel({
		defaults: {
            sortable: true,
            width   :80,menuDisabled : true
        },
        columns: [new Ext.grid.RowNumberer(),sm,
		 {
            header: '指标编码',
            dataIndex: 'kpiCode',
            width:170
        }, {
            header: '指标名称',
            dataIndex: 'kpiName',
            width:360
        }]
	})
	
	var inputKpiList=[];
	var store=new Ext.data.Store({
		proxy:new Ext.data.MemoryProxy(inputKpiList),
		reader:new Ext.data.ArrayReader({},
			[{name:'kpiCode'},
			{name:'kpiName'}]
		)
	})
	var kpiTaskGrid=new Ext.grid.GridPanel({
		store:store,
		sm:sm,
		cm:column
	})
	
	
	var win=new Ext.Window({
		layout:'border',
		width:600,
		height:500,
		modal : true,
		title:'指标任务管理',
		items:[{
			height:80,
			region:'north',
			items:inputForm
		},{
			region:'center',
			layout:'fit',
			items:kpiTaskGrid
		}]
	})
	
	this.show=function(){
		win.show();
	}
}
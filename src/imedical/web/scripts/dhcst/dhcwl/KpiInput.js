dhcwl.mkpi.KpiInput=function(){
	Ext.QuickTips.init();
	var inputList=[];
    var sm=new Ext.grid.CheckboxSelectionModel();
    var outThis=this;
	var columnModel=new Ext.grid.ColumnModel({
		defaults: {
            sortable: true,
            width   :80
        },
        columns: [new Ext.grid.RowNumberer(),sm,
		 {
            header: '导入的指标代码',
            dataIndex: 'kpiCode',
            width:170/*,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))*/
        }, {
            header: '导入的指标名称',
            dataIndex: 'kpiName',
            width:360/*,
            editor:new Ext.grid.GridEditor(new Ext.form.TextField({disabled:true}))*/
        }]
	});
	var inputKpiList=[];
	var store = new Ext.data.Store({
        proxy: new Ext.data.MemoryProxy(inputKpiList),
        reader: new Ext.data.ArrayReader({},
        	[	{name: 'kpiCode'},
            	{name: 'kpiName'}
       		])
    });
    var checkedPanel = new Ext.grid.GridPanel({
    	title:'导入指标列表（红色代表要导入的指标和库中指标有冲突），只导入被勾选的指标！',
        //width:620,
        height:600,
        frame: true,
        enableColumnResize :true,
        store: store,
        cm: columnModel,
        sm:sm,
        bbar:new Ext.PagingToolbar({
            store: store,
            displayInfo: true,
            displayMsg: '一共导入 {1} 条',
            emptyMsg: "没有记录"
        })
    });
	
    var serverSaveFileName=null;
	var inputForm = new Ext.form.FormPanel({
        frame:true,   
        border:false,
        height:200,
        fileUpload:true,   
		items:[{
			xtype:'textfield',   
			allowBlank:false,
			hideLabel:false,
			name:'inputKpiFile',   
			fieldLabel:'选择导入指标XML文件',
			buttonText: '浏览2',  
			inputType:'file',
			width: 258,
			id:'selectInputKpiFile'
			/*listeners:{
				'focus':function(){
					setFilePath();
				}
			}*/
		}/*,{
            xtype: 'radiogroup',
            fieldLabel: '类型选择',
            id:'choiceIType',
            autoHeight:true,
            columns: 2,
            items: [
                {boxLabel: '新建，若有相同Code的指标不会更新，只新建不存在的',name: 'isUpdate', inputValue: 'N', checked: true},
                {boxLabel: '更新，完全将XML中的信息同步到数据库中',name: 'isUpdate', inputValue: 'U'}
            ]
		}*/], 
		tbar: new Ext.Toolbar([{
        	text: '读入指标文件',
            handler: function(){
            	var path=Ext.get('selectInputKpiFile').getValue();
            	if(!path||path==""){
            		alert("请选择要导入的XML文件！");
            		return;
            	}
            	/*inputForm.getForm().submit({
                    //waitMsg: 'Uploading ....',
                    url: 'dhcwl/kpi/kpinewinput.csp?action=UploadFile',
                    method: "POST",
                    success: function(form, action) {
                    	Ext.Msg.alert('Success', action.result);
                    },
                    failure:function(form,action){
						Ext.Msg.alert('Success', action.result);
                    }
                    
                });*/
            	//var xmlDoc=dhcwl.mkpi.util.XML.loadXML(path);
            	/*var x = xmlDoc.getElementsByTagName("List"); //documentElement.childNodes[0];  
            	if(!x||x.length==0){
            		x = xmlDoc.getElementsByTagName("list");
            	}
            	if(!x||x.length==0){
            		alert("导入的文件格式不正确，文档根节点为List，子节点为指标节点");
            		return;
            	}*/
    			//var file=dhcwl.mkpi.Util.openFile(path);
    			var readStr="",theStep=1,sc;
    			var inputCont={};
    			do{
    				readStr=dhcwl.mkpi.util.XML.stepTraverXML(path,512);  //dhcwl.mkpi.Util.stepReadFile(file,512);
    				//alert(readStr);
    				inputCont["Node"+(theStep)]=readStr;
    				theStep++;
    			}while(readStr&&readStr!="");
    			//file.Close();
    			dhcwl.mkpi.util.XML.close();
		        /*var kpis=dhcwl.mkpi.util.XML.getDirectChildren(x);
		        var inputKpiList=findKpiNameFromXML(path,kpis);
		        store.loadData(inputKpiList);
		        checkedPanel.show();*/
    			Ext.Ajax.request({
					url: encodeURI('dhcwl/kpi/kpiioservice.csp?action=UPFILE&theStep='+(theStep-1)),
					method:'POST',
					params:inputCont,
					failure: function(result, request){
						alert(request);
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){	
						var jsonData;
						store.clearData();
						checkedPanel.show();
						//alert(result.responseText);
						try{
							jsonData = Ext.util.JSON.decode( result.responseText );
							var inputKpiList=jsonData.root; //findKpiNameFromXML(path,kpis);
		        			store.loadData(inputKpiList);
		        			checkedPanel.show();
		        			serverSaveFileName=jsonData.tips;
		        			alert("文件读入成功！");
		        			//alert(jsonData.tempFile);
						}catch(e){
							Ext.Msg.show({title:'错误',msg:result.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
					}
    			});
            	/*var xmlDoc=dhcwl.mkpi.util.XML.loadXML(path);
            	var x = xmlDoc.getElementsByTagName("List");
            	if(!x||x==null){
            		alert("导入的文件格式不正确，文档根节点为List，子节点为指标节点");
            		return;
            	}
		        var kpis=dhcwl.mkpi.util.XML.getDirectChildren(x);
		        var inputKpiList=findKpiNameFromXML(path,kpis);
		        store.loadData(inputKpiList);
		        checkedPanel.show();*/
            }
        },'-',{
        			text: '导入前检验',
            		handler: function(){
            			if(serverSaveFileName==null||serverSaveFileName==""){
            				alert("还没有导入文件或导入文件错误，不能进行导入前查看");
            				return;
            			}
            			//var isUpdate=inputForm.getForm().getValues(false).isUpdate;
            			var url='dhcwl/kpi/kpiioservice.csp?action=inputKpiFile&checkedInput=1&fileName='+serverSaveFileName;
            			dhcwl.mkpi.Util.ajaxExc(url,{},
            			function(jsonData){
            				if(!jsonData){
                				Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                				return;
                			}
                			if(jsonData.success==true){
                				var containKpiList=jsonData.root,conKpiCode="";
                				var rd,inputKpiCode="",contFlag=false;
                				var tempSm=checkedPanel.getSelectionModel();
                				for(var i=store.getCount()-1;i>=0;i-- ){
                					contFlag=false;
                					rd=store.getAt(i);
                					inputKpiCode=rd.get("kpiCode");
                					inputKpiCode=inputKpiCode.toUpperCase( );
                					for(var j=containKpiList.length-1;j>-1;j--){
                						conKpiCode=containKpiList[j].codeValue;
                						if(conKpiCode.toUpperCase( )==inputKpiCode){
                							contFlag=true;
                							checkedPanel.getView().getRow(i).style.backgroundColor='red';
                						}
                					}
                					if(!contFlag) tempSm.selectRow(i,true,false);
                				}
                				
                			}
            			},
            			outThis,null,120000);
            			return;
            		}
        		},'-',{
        			text: '导入指标',
            		handler: function(){
            			if(serverSaveFileName==null||serverSaveFileName==""){
            				alert("还没有导入文件或导入文件错误，不能进行导入");
            				return;
            			}
            			var realInputKpiList=[];
            			for(var i=store.getCount()-1;i>=0;i-- ){
        					if(sm.isSelected(i)){
        						realInputKpiList.push(store.getAt(i).get('kpiCode'));
        					}
        				}
        				//alert(realInputKpiList.join(","));
        				//return ;
            			/*var isUpdate=inputForm.getForm().getValues(false).isUpdate;
            			if(isUpdate=="N") isUpdate=1;
            			else if(isUpdate="U") isUpdate=0;
            			else isUpdate=1;*/
            			//alert(isUpdate);
            			//return;
            			var url='dhcwl/kpi/kpiioservice.csp'; //?action=inputKpiFile&fileName='+serverSaveFileName+'&realInputKpiList='+realInputKpiList.join(",");
            			Ext.Ajax.request({
							url: encodeURI(url),
							method:'POST',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:result.responseText+'<br/>\n导入超时，文件太大，请将文件分为多个依次导入!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){	
								var jsonData;
								try{
									jsonData = Ext.util.JSON.decode( result.responseText );
								}catch(e){
									Ext.Msg.show({title:'错误',msg:result.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									return;
								}
								if(jsonData.info=='ok'){
									Ext.Msg.show({title:'提示',msg:jsonData.tips,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
								}else{
									Ext.Msg.show({title:'错误',msg:jsonData.tips,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							params:{
								action:'inputKpiFile',
								fileName:serverSaveFileName,
								realInputKpiList:realInputKpiList.join(",")
							},
							timeout:1800000
            			});
            			//inputForm.getForm().setValues({inputKpiFile:''});
            			serverSaveFileName=null;
            			return;
            		}
        		}
		])
    });
    var mainInputPanel=new Ext.Panel({
    	//layout:'table',
    	title:'指标导入',
    	layout:'table',
        layoutConfig: {columns:1},
        items: [{
        	width:620,
        	height:200,
        	//autoScroll:true,
            items:inputForm
        },{
        	//autoScroll:true,
        	width:620,
        	height:600,
            items:checkedPanel
    	}]
    });
    function setFilePath(){
    	var path=dhcwl.mkpi.Util.browseFile();
    	if(path){
    		inputForm.getForm().setValues({inputKpiFile:path});
    	}
    }
    this.getInputPanel=function(){
    	return mainInputPanel;
    }
    function findKpiNameFromXML(xmlFile,kpis){
    	var xmlDoc=dhcwl.mkpi.util.XML.loadXML(xmlFile);
    	var data=[];//,subData=[];
    	for(var i=0;i<kpis.length;i++){
    		var x = xmlDoc.getElementsByTagName(kpis[i]);
    		value=dhcwl.mkpi.util.XML.getValue(x,"MKPIName")
    		//subData[0]=kpis[i];
    		//subData[1]=value;
    		data[i]=[kpis[i],value];
    	}
    	return data;
    }
}
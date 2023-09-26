dhcwl.mkpi.KpiInput=function(){
	//Ext.QuickTips.init();   --moidify by wz.2014-4-28
	var inputList=[];
    var sm=new Ext.grid.CheckboxSelectionModel();
    var outThis=this;
    var impExlDataObj;
    var fileType="";
	var columnModel=new Ext.grid.ColumnModel({
		defaults: {
            sortable: true,
            width   :80,menuDisabled : true
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
    	
        frame: true,
        enableColumnResize :true,
        store: store,
        cm: columnModel,
        sm:sm
        /*,
        bbar:new Ext.PagingToolbar({
            store: store,
            displayInfo: true,
            //displayMsg: '一共导入 {1} 条',
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        })
        */
        /*
        bbar:new Ext.Toolbar([{
        	id:'inputbbar',
        	text:"没有记录！"
    	}])*/
    });
    
    var serverSaveFileName="";
	var inputForm = new Ext.form.FormPanel({
		bodyStyle:'padding:5px',
		labelWidth : 120,
        frame:true,   
        border:false,
        //height:200,
        fileUpload:true,   
		items:[{
            xtype: 'radiogroup',
            fieldLabel: '文件类型选择',
            id:'choiceIType',
            autoHeight:true,
            columns: 2,
            items: [
                {boxLabel: 'XML文件',name: 'impFileType', inputValue: 'xmlFile', checked: true},
                {boxLabel: 'EXCEL文件',name: 'impFileType', inputValue: 'exlFile'}
            ]
		},{
			xtype:'textfield',   
			allowBlank:false,
			hideLabel:false,
			name:'inputKpiFile',   
			fieldLabel:'选择导入指标文件',
			buttonText: '浏览2',
			inputType:'file',
			width: 258,
			id:'selectInputKpiFile'
		}], 
		tbar: new Ext.Toolbar([{
        	//text: '读入指标文件',
        	text: '<span style="line-Height:1">读入指标文件</span>',
        	icon: '../images/uiimages/uploadyun.png',
            handler: function(){
				//文件是
            	var path=Ext.get('selectInputKpiFile').getValue();
            	fileType=inputForm.getForm().getValues()["impFileType"] ;
            	if(fileType=="exlFile"){
            		if(!path||path==""){
            			alert("请选择要导入的excel文件！");
                		return;
            		}
            	}
            	if(!path||path==""){
            		alert("请选择要导入的xml文件！");
            		return;
            	}
            	
            	//fileType=inputForm.getForm().getValues()["impFileType"] ;
            	if (fileType=="exlFile") {	//文件是execl类型
            		readFileFromExcel(path);
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
					waitMsg : '正在处理...',
					params:inputCont,
					timeout:60000,
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
							inputForm.body.unmask();
							//checkedPanel.body.unmask;
							jsonData = Ext.util.JSON.decode( result.responseText );
							
							if (jsonData.info=="wrong") {
								Ext.Msg.show({title:'错误',msg:jsonData.tips,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}
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
    			inputForm.body.mask("数据处理中，请勿进行操作");
    			//checkedPanel.body.mask("数据处理中，请稍后");
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
        			//text: '导入前检验',
        			text: '<span style="line-Height:1">导入前检验</span>',
        			icon: '../images/uiimages/search.png',
            		handler: function(){
            			if(serverSaveFileName==""){
            				alert("请读入指标！");
            				return;
            			}
            			if(serverSaveFileName==null){
            				alert("已经执行导入操作了，请重新点击读入文件！");
            				return;
            			}
            			
            			if (fileType=="exlFile") {	//文件是execl类型
		            		CheckExlBeforeInput();
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
        			//text: '导入指标',
        			text: '<span style="line-Height:1">导入指标</span>',
        			icon: '../images/uiimages/importdata.png',
            		handler: function(){
            			if(serverSaveFileName==""){
            				alert("请读入指标！");
            				return;
            			}
            			if(serverSaveFileName==null){
            				Ext.Msg.show({title:'提示',msg:'已经执行导入操作了，请重新点击读入文件！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            				//alert("还没有导入文件或导入文件错误，不能进行导入");
            				return;
            			}
            			var realInputKpiList=[];
            			for(var i=store.getCount()-1;i>=0;i-- ){
        					if(sm.isSelected(i)){
        						realInputKpiList.push(store.getAt(i).get('kpiCode'));
        					}
        				}
        				if(realInputKpiList.length<=0){
        					Ext.Msg.show({title:'提示',msg:'未选择要导入的指标',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        					return;
        				}
        				//alert(realInputKpiList.join(","));
        				//return ;
            			/*var isUpdate=inputForm.getForm().getValues(false).isUpdate;
            			if(isUpdate=="N") isUpdate=1;
            			else if(isUpdate="U") isUpdate=0;
            			else isUpdate=1;*/
            			//alert(isUpdate);
            			//return;
        				
        				if (fileType=="exlFile") {	//文件是execl类型
		            		InputExlFile(realInputKpiList);
		            		return;            		
		            	} 
        				
            			var url='dhcwl/kpi/kpiioservice.csp'; //?action=inputKpiFile&fileName='+serverSaveFileName+'&realInputKpiList='+realInputKpiList.join(",");
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
            			inputForm.body.mask("数据处理中，请勿进行操作");
            			//inputForm.getForm().setValues({inputKpiFile:''});
            			serverSaveFileName=null;
            			return;
            		}
        		}
		])
    });
    var mainInputPanel=new Ext.Panel({
    	title:'指标导入',
    	//layout: 'anchor',

    	//layout:'table',
        //layoutConfig: {columns:1},
        items: [{
        	//width:620,
        	height:200,
        	//autoScroll:true,
            items:inputForm,
            layout:'fit'
        },{
        	//autoScroll:true,
        	//width:620,
        	//height:470,
            items:checkedPanel,
            layout:'fit'
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
    this.getInputForm=function(){
    	return 	inputForm;
    }
    this.getCheckPanel=function(){
    	return checkedPanel;
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
    function readFileFromExcel(filePath){
		//1、从后台读取excel文件
		var oXL = new ActiveXObject("Excel.application");  
        //打开指定路径的excel文件   
		var oWB = oXL.Workbooks.open(filePath); 

		if (!oWB) {
			Ext.Msg.alert("提示","打开文件错误！请确认是否是正确的excel文件！");
			return;
		}
		var strImpData="";
		//操作第一个sheet(从一开始，而非零)   
		try {

			var sheetInx=1;
			oWB.worksheets(sheetInx).select();  
			var oSheet = oWB.ActiveSheet;  
			//使用的行数   
			var rows =oSheet.usedrange.rows.count; 
			var clsNameRowbegin=2;
			var propertyRowbegin=3;
			var dataRowBegin=5;
			var aryProperName=new Array();
			var strDataset="";

			var clsName=oSheet.Cells(clsNameRowbegin, 1).value;
			var colInx=1;
			while (true) {
				var properName=oSheet.Cells(propertyRowbegin,colInx).value;
				/*if (properName=="关联维度(只用于显示)"){
						break;
				}*/
				if (!properName) {
					break;
				}else{
					aryProperName.push(properName);
					colInx=colInx+1;
				}
				
			}

			var colCnt=colInx-1;
			for (var i = dataRowBegin; i <= rows; i++) {
				var strRec="";
				for (var j=1;j<=colCnt;j++) {
					var cellData=oSheet.Cells(i, j).value;
					//if (!cellData) cellData="";
					if (cellData==undefined) cellData="";
					if(j==8){
						var date=new Date(cellData);
						var year=date.getYear();
						var month=date.getMonth()+1;
						var day=date.getDate();
						cellData=year+"-"+month+"-"+day;
					}
					if (strRec!="") strRec=strRec+",";
					strRec=strRec+'"'+aryProperName[j-1]+'":"'+cellData+'"'
				}
				if (strDataset!="") strDataset=strDataset+',';
				strDataset=strDataset+'{'+strRec+'}'	
			} 
			if (strImpData!="") strImpData=strImpData+',';
			strImpData=strImpData+'"'+clsName+'":['+strDataset+']'

			strImpData='{'+strImpData+'}';
			
			
			impExlDataObj=eval("("+strImpData+")")		
			
			var inputKpiList=[];
			
			for(var i=0;i<=impExlDataObj["DHCWL_MKPI.DHCWLMKPI"].length-1;i++) {
				var aryRec=[];
				var code=impExlDataObj["DHCWL_MKPI.DHCWLMKPI"][i].MKPICode;
				var name=impExlDataObj["DHCWL_MKPI.DHCWLMKPI"][i].MKPIName;
				aryRec.push(code);
				aryRec.push(name);
				inputKpiList.push(aryRec);
			}
			store.loadData(inputKpiList);
			checkedPanel.show();
			serverSaveFileName=filePath;
			alert("文件读入成功！");

		}catch(e) {  
					//退出操作excel的实例对象   
					oXL.Application.Quit();  
					CollectGarbage();
			      //Ext.Msg.alert("提示",e);
				Ext.Msg.alert("提示","打开文件错误！请确认是否是正确的excel文件！");
				return;
		}  

		//退出操作excel的实例对象   
		oXL.Application.Quit();  
		

		//手动调用垃圾收集器   
		CollectGarbage();      	
    	
    }
    
    function CheckExlBeforeInput() {
		var aryCode=[];
		for(var i=0;i<=impExlDataObj["DHCWL_MKPI.DHCWLMKPI"].length-1;i++) {
			var code=impExlDataObj["DHCWL_MKPI.DHCWLMKPI"][i].MKPICode;
			aryCode.push(code);
		}    

    	var url='dhcwl/kpi/kpiioservice.csp?action=checkKpiExl';
		dhcwl.mkpi.Util.ajaxExc(url,
			{'Codes':aryCode.join(",")},
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
    
	function InputExlFile(inputKpiList) {
		var realInputKpiList=[];
		for(var i=0;i<=impExlDataObj["DHCWL_MKPI.DHCWLMKPI"].length-1;i++) {
			var code=impExlDataObj["DHCWL_MKPI.DHCWLMKPI"][i].MKPICode;
			for(var j=0;j<=inputKpiList.length-1;j++) {
				var inputCode=inputKpiList[j];
				if (code==inputCode) {
					realInputKpiList.push(impExlDataObj["DHCWL_MKPI.DHCWLMKPI"][i]);
				}
			}
		}  

		realInputKpiList=Ext.util.JSON.encode(realInputKpiList);
		strUpdateData='{"DHCWL.MKPI.MKPI":'+realInputKpiList+'}'
		
		//var strUpdateData=Ext.util.JSON.encode(realInputKpiList);
		var url='dhcwl/kpi/kpiioservice.csp?action=inputKpiExl';
        dhcwl.mkpi.Util.ajaxExc(url,
        	{'impDataObj':strUpdateData}
			,function(jsonData){
				if(jsonData.success==true){
					if (jsonData.tip!="ok") {
						Ext.Msg.alert("提示",jsonData.tip);
					}else{
						Ext.Msg.alert("提示","操作成功！");	
					}
					serverSaveFileName=null;
			}else{
				Ext.Msg.alert("提示","操作失败！");
				}
				
			},this);		
		
	}
    
    
    
}
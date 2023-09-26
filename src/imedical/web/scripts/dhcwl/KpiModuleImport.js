(function(){
	Ext.ns("dhcwl.mkpi.KpiModuleImport");
})();

//模块导入
dhcwl.mkpi.KpiModuleImport=function(){
	var useddebug=0;
	var serverSaveFileName=null;
	var outThis=this;
	var imported=0;
	
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:120,
		ignoreParentClicks:true,
    	items:[
    		{   			
    			text:'点选方式',
    			menu:{
    				boxMinWidth:120,
    				items:[
		    			{
		    				text:'级联选择',
		    				handler:function(cmp,event){
		    					tree.on('checkchange',  selSubNode);   
		    				}
		    			},{
		    				text:'单    选',
		    				handler:function(cmp,event){
		    					tree.un('checkchange',  selSubNode);   		    					
		    				}
		    			}
		    			]
    			
    			}
    		}]
	});		
	
	
	
	var loadFn = function(btn, statusBar){
        btn = Ext.getCmp(btn);
        statusBar = Ext.getCmp(statusBar);

        btn.disable();
        statusBar.showBusy();

		(function(){		
            	var path=Ext.get('selectImportModuleFile').getValue();
            	if(!path||path==""){
            		statusBar.clearStatus({useDefaults:true});
            		btn.enable();
            		alert("请选择要导入的XML文件！");
            		return;
            	}
				//加入状态条处理
            	//loadFn.createCallback('readxml-btn', 'imp-statusbar');
            	//清除树结构及保存在服务器上的文件名
            	tree.getRootNode().removeAll();
            	serverSaveFileName=null;
            	
    			var readStr="",theStep=1,sc;
    			var inputCont={};
    			do{
    				readStr=dhcwl.mkpi.util.XML.stepTraverXML(path,256);  //dhcwl.mkpi.Util.stepReadFile(file,512);
    				//alert(readStr);
    				inputCont["Node"+(theStep)]=readStr;
    				theStep++;
    			}while(readStr&&readStr!="");

    			dhcwl.mkpi.util.XML.close();

    			Ext.Ajax.request({
					url: encodeURI('dhcwl/kpi/kpimoduleimp.csp?action=UPFILE&theStep='+(theStep-1)),
					waitMsg : '正在处理...',
					method:'POST',
					timeout:6000,
					params:inputCont,
					failure: function(result, request){
						Ext.Msg.show({title:'错误1',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){	
						var jsonData;
						try{
							jsonData = Ext.util.JSON.decode( result.responseText );
							var treeDatas=jsonData.data; //findKpiNameFromXML(path,kpis);
		        			serverSaveFileName=jsonData.tips;
							var len=treeDatas.length;
							var startNode=tree.getRootNode();
							for (var i=0;i<=len-1;i++) {
							
								
								className=treeDatas[i].className;
								//salert("treeDatas[i].primaryValue="+treeDatas[i].primaryValue);

								var childNode;
								if(className=="DHCWL.MKPI.MMgrModuleCfg") {
									
									childNode = new Ext.tree.TreeNode( {
										primaryValue:treeDatas[i].primaryValue,
										className:treeDatas[i].className,
										desc:treeDatas[i].ModuleCfgDesc,
										pTreeCode:treeDatas[i].ModuleCfgPTreeCode,
										treeCode:treeDatas[i].ModuleCfgTreeCode,
										object:treeDatas[i].ModuleCfgDesc,
										
										
									    type:'模块',
									    code:treeDatas[i].ModuleCfgCode,
									    iconCls:'task-folder',
									    expanded: true,
									    checked: false
									  });		
									
									
									var pNode=searchNodeByAttrib(startNode,"DHCWL.MKPI.MMgrModuleCfg",treeDatas[i].ModuleCfgPTreeCode,"","","");
									if (pNode.length>0) {
										pNode[0].appendChild(childNode);
									}
									
								}

								if(className=="DHCWL.MKPI.MMgrRptCfg") {
									childNode = new Ext.tree.TreeNode( {
										primaryValue:treeDatas[i].primaryValue,
										className:treeDatas[i].className,
										rptCode:treeDatas[i].RptCfgCode,
										desc:treeDatas[i].RptCfgDesc,
										//pTreeCode:treeDatas[i].ModuleCfgPTreeCode,
										treeCode:treeDatas[i].RptCfgTreeCode,
										object:treeDatas[i].RptCfgDesc,
									    type:'报表',
									    code:treeDatas[i].RptCfgCode,
									    iconCls:'task-folder',
									    expanded: true,
									    checked: false
									  });		

									var pNode=searchNodeByAttrib(startNode,"",treeDatas[i].RptCfgTreeCode,"","","");
									//alert(pNode.length);
									if (pNode.length>0) {
										pNode[0].appendChild(childNode);
									}
									//startNode.expand();
								}
								if(className=="DHCWL.MKPI.MMgrDataSetCfg") {

									childNode = new Ext.tree.TreeNode( {
										primaryValue:treeDatas[i].primaryValue,
										className:treeDatas[i].className,
										datasetCode:treeDatas[i].DatasetCfgCode,
										desc:treeDatas[i].DatasetCfgDesc,
										rptCode:treeDatas[i].DatasetRptCode,
										treeCode:treeDatas[i].DatasetTreeCode,
										object:treeDatas[i].DatasetCfgDesc,
									    type:'数据集',
									    code:treeDatas[i].DatasetCfgCode,
									    iconCls:'task-folder',
									    expanded: true,
									    checked: false
									  });		

									//alert("class="+treeDatas[i].className+"treecode="+treeDatas[i].RptCfgTreeCode);
									var pNode=searchNodeByAttrib(startNode,"",treeDatas[i].DatasetTreeCode,treeDatas[i].DatasetRptCode,"","");
									//alert(pNode.length);
									if (pNode.length>0) {
										pNode[0].appendChild(childNode);
									}
									//startNode.expand();
								}
								if(className=="DHCWL.MKPI.MMgrKPICfg") {


									childNode = new Ext.tree.TreeNode( {
										primaryValue:treeDatas[i].primaryValue,
										className:treeDatas[i].className,
										datasetCode:treeDatas[i].KPIDatasetCfgCode,
										//desc:treeDatas[i].DatasetCfgDesc,
										kpiCode:treeDatas[i].KPICfgCode,
										rptCode:treeDatas[i].KPIRptCode,
										treeCode:treeDatas[i].KPITreeCode,
										object:treeDatas[i].KPICfgCode,
									    type:'指标',
									    code:treeDatas[i].KPICfgCode,
									    iconCls:'task-folder',
									    expanded: true,
									    checked: false
									  });		

									//alert("class="+treeDatas[i].className+"treecode="+treeDatas[i].RptCfgTreeCode);
									var pNode=searchNodeByAttrib(startNode,"",treeDatas[i].KPITreeCode,treeDatas[i].KPIRptCode,treeDatas[i].KPIDatasetCfgCode,"");
									//alert(pNode.length);
									if (pNode.length>0) {
										pNode[0].appendChild(childNode);
									}
									//startNode.expand();
								}
								
							}
						
							startNode.expand();

							statusBar.clearStatus({useDefaults:true});
            				btn.enable();
							alert("文件读入成功！");

		        			//alert(jsonData.tempFile);
						}catch(e){
							statusBar.clearStatus({useDefaults:true});
							btn.enable();
							Ext.Msg.show({title:'错误2',msg:result.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}

					}
    			});
		}).defer(1)
	            
            /*
        (function(){
            statusBar.clearStatus({useDefaults:true});
            btn.enable();
        }).defer(15000);
        */
    };	
/*
 treegrid_data={
 	object:'root: root',
    type:'',
    code:'Tommy Maintz',
    iconCls:'task-folder',
    expanded: true,
    validChecked:false,
    children:
 	[{
    object:'出入转',
    type:'模块',
    code:'CRZ',
    iconCls:'task-folder',
    expanded: true,
    checked:false,
    validChecked:false,
    children:[{
        object:'武汉儿童医院出入转',
        type:'模块',
        code:'WZETCRZ',
        iconCls:'task-folder',
    	checked:false,
    	validChecked:false,
        children:[{
            object:'科室汇总报表',
            type:'报表',
            code:'tabDepSummary',
            iconCls:'task-folder',
            //leaf:true,
            checked: false,
            validChecked:false,
			children:[{
				object:'ds1',
				type:'数据集',
				code:'ds1',
				iconCls:'task-folder',
				//leaf:true,
				checked: false,
				validChecked:false,
				children:[{
					object:'实有床数',
					type:'指标',
					code:'K0021',
					iconCls:'task',
					leaf:true,
					validChecked:false,
					checked: false
					},{
					object:'原有人数',
					type:'指标',
					code:'K0023',
					iconCls:'task',
					leaf:true,
					validChecked:false,
					checked: false						
					},{
					object:'入院人数',
					type:'指标',
					code:'K0024',
					iconCls:'task',
					leaf:true,
					validChecked:false,
					checked: false						
					}]
			},{
				object:'ds2',
				type:'数据集',
				code:'ds2',
				iconCls:'task-folder',
				//leaf:true,
				validChecked:false,
				checked: false,
				children:[{
					object:'病区死亡人数',
					type:'指标',
					code:'K0659',
					iconCls:'task',
					leaf:true,
					validChecked:false,
					checked: false
					}]				
			}]
					
        },{
            object:'科室明细报表',
            type:'报表',
            code:'tabDepDetail',
            iconCls:'task-folder',
            //leaf:true,
            checked:false,
			children:[{
				object:'ds1',
				type:'数据集',
				code:'ds1',
				iconCls:'task-folder',
				//leaf:true,
				validChecked:false,
				checked: false,
				children:[{
					object:'病区工作量明细',
					type:'指标',
					code:'K0656',
					iconCls:'task',
					leaf:true,
					validChecked:false,
					checked: false
					}]
			}]
        }]
    }]
	}]
	}
	
*/
	

treegrid_data={
	treeCode:"root",
	className:"DHCWL.MKPI.MMgrModuleCfg",
 	object:'root: root',
    type:'',
    code:'Tommy Maintz',
    iconCls:'task-folder',
    expanded: true
}

/*	
treegrid_data={
	treeCode:"rootr",
	className:"root",
 	object:'root:root',
    type:'',
    code:'Tommy Maintz',
    iconCls:'task-folder',
    expanded: true,
	children:[{
		treeCode:"root",
		className:"DHCWL.MKPI.MMgrModuleCfg",
		object:'病区工作量明细',
		type:'指标',
		code:'K0656',
		iconCls:'task',
		//leaf:true,
		validChecked:false,
		checked: false
		}]
}
*/
    /*
var actFormItem = [{
        bodyStyle: 'padding-left:5px;',
 		fileUpload:true,
            items: [{
				xtype:'textfield',
				allowBlank:true,
				name:'importModuleFile',
				fieldLabel:'安装文件',
				inputType:'file',
				id:'selectImportModuleFile'
			}]
    	}];

 
    var fp = new Ext.FormPanel({    
	    title: '选择要导入的文件',
	    frame: true,
	    labelWidth: 110,
	    bodyStyle: 'padding:0 10px 0;',
	    items: [
	        {
	            layout: 'column',
	            border: false,
	            defaults: {
	                border: false
	            },            
	            items: actFormItem
	        }
	    ]
        });
	*/
 
    var fp = new Ext.FormPanel({    
	    title: '选择要导入的文件',
	    frame: true,
	    labelWidth: 110,
	    bodyStyle: 'padding-left:5px;',
        layout: 'column',
        border: false,
 		fileUpload:true,           	    
	    items: [
	        {
				xtype:'textfield',
				allowBlank:true,
				name:'importModuleFile',
				fieldLabel:'安装文件',
				inputType:'file',
				id:'selectImportModuleFile'
	        }
	    ]
        });
	 var formPanel = new Ext.FormPanel({
        labelWidth: 75, 
        url:'save-form.php',
        frame:true,
        title: 'Simple Form',
        bodyStyle:'padding:5px 5px 0',
        //width: 350,
        defaults: {width: 230},
        defaultType: 'textfield',

        items: [{
                fieldLabel: 'First Name',
                name: 'first',
                allowBlank:false
            },{
                fieldLabel: 'Last Name',
                name: 'last'
            },{
                fieldLabel: 'Company',
                name: 'company'
            }, {
                fieldLabel: 'Email',
                name: 'email',
                vtype:'email'
            }, new Ext.form.TimeField({
                fieldLabel: 'Time',
                name: 'time',
                minValue: '8:00am',
                maxValue: '6:00pm'
            })
        ],

        buttons: [{
            text: 'Save'
        },{
            text: 'Cancel'
        }]
    });

    
    
    var tree = new Ext.ux.tree.TreeGrid({
        //title: '模块数据',
    	enableSort : false,
        width: 500,
        height: 350,
        enableDD: true,
        //autoHeight:true,
        //autoScroll:true,
      	loader: new Ext.tree.TreeLoader(),
        //root: new Ext.tree.AsyncTreeNode(treegrid_data),        
        columns:[{
            header: '对象',
            dataIndex: 'object',
            width: 230
        },{
            header: '类型',
            width: 100,
            dataIndex: 'type',
            align: 'center'
 
        },{
            header: '编码',
            width: 150,
            dataIndex: 'code'
        }],
       tbar: [{
            iconCls: 'icon-user-add',
            //text: '读入模块文件',
            text: '<span style="line-Height:1">读入模块文件</span>',
            icon: '../images/uiimages/uploadyun.png',
            id:'readxml-btn',
            handler: //loadFn.createCallback('readxml-btn', 'imp-statusbar')
            function(){
				
            	var path=Ext.get('selectImportModuleFile').getValue();
            	if(!path||path==""){
            		alert("请选择要导入的XML文件！");
            		return;
            	}
				//加入状态条处理
            	//loadFn.createCallback('readxml-btn', 'imp-statusbar');
            	//清除树结构及保存在服务器上的文件名
            	tree.getRootNode().removeAll();
            	serverSaveFileName=null;
            	
    			var readStr="",theStep=1,sc;
    			var inputCont={};
    			do{
    				readStr=dhcwl.mkpi.util.XML.stepTraverXML(path,256);  //dhcwl.mkpi.Util.stepReadFile(file,512);
    				//alert(readStr);
    				inputCont["Node"+(theStep)]=readStr;
    				theStep++;
    			}while(readStr&&readStr!="");

    			dhcwl.mkpi.util.XML.close();

    			Ext.Ajax.request({
					url: encodeURI('dhcwl/kpi/kpimoduleimp.csp?action=UPFILE&theStep='+(theStep-1)),
					waitMsg : '正在处理...',
					method:'POST',
					timeout:60000,
					params:inputCont,
					failure: function(result, request){
						Ext.Msg.show({title:'错误1',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){	
						var jsonData;
						try{
           					win.body.unmask();
							jsonData = Ext.util.JSON.decode( result.responseText );
							var treeDatas=jsonData.data; //findKpiNameFromXML(path,kpis);
		        			serverSaveFileName=jsonData.tips;
							var len=treeDatas.length;
							var startNode=tree.getRootNode();
							for (var i=0;i<=len-1;i++) {
							
								
								className=treeDatas[i].className;
								//salert("treeDatas[i].primaryValue="+treeDatas[i].primaryValue);

								var childNode;
								if(className=="DHCWL.MKPI.MMgrModuleCfg") {
									
									childNode = new Ext.tree.TreeNode( {
										primaryValue:treeDatas[i].primaryValue,
										className:treeDatas[i].className,
										desc:treeDatas[i].ModuleCfgDesc,
										pTreeCode:treeDatas[i].ModuleCfgPTreeCode,
										treeCode:treeDatas[i].ModuleCfgTreeCode,
										object:treeDatas[i].ModuleCfgDesc,
										
										
									    type:'模块',
									    code:treeDatas[i].ModuleCfgCode,
									    iconCls:'task-folder',
									    expanded: true,
									    checked: false
									  });		
									
									
									var pNode=searchNodeByAttrib(startNode,"DHCWL.MKPI.MMgrModuleCfg",treeDatas[i].ModuleCfgPTreeCode,"","","");
									if (pNode.length>0) {
										pNode[0].appendChild(childNode);
									}
									
								}

								if(className=="DHCWL.MKPI.MMgrRptCfg") {
									childNode = new Ext.tree.TreeNode( {
										primaryValue:treeDatas[i].primaryValue,
										className:treeDatas[i].className,
										rptCode:treeDatas[i].RptCfgCode,
										desc:treeDatas[i].RptCfgDesc,
										//pTreeCode:treeDatas[i].ModuleCfgPTreeCode,
										treeCode:treeDatas[i].RptCfgTreeCode,
										object:treeDatas[i].RptCfgDesc,
									    type:'报表',
									    code:treeDatas[i].RptCfgCode,
									    iconCls:'task-folder',
									    expanded: true,
									    checked: false
									  });		

									var pNode=searchNodeByAttrib(startNode,"",treeDatas[i].RptCfgTreeCode,"","","");
									//alert(pNode.length);
									if (pNode.length>0) {
										pNode[0].appendChild(childNode);
									}
									//startNode.expand();
								}
								if(className=="DHCWL.MKPI.MMgrDataSetCfg") {

									childNode = new Ext.tree.TreeNode( {
										primaryValue:treeDatas[i].primaryValue,
										className:treeDatas[i].className,
										datasetCode:treeDatas[i].DatasetCfgCode,
										desc:treeDatas[i].DatasetCfgDesc,
										rptCode:treeDatas[i].DatasetRptCode,
										treeCode:treeDatas[i].DatasetTreeCode,
										object:treeDatas[i].DatasetCfgDesc,
									    type:'数据集',
									    code:treeDatas[i].DatasetCfgCode,
									    iconCls:'task-folder',
									    expanded: true,
									    checked: false
									  });		

									//alert("class="+treeDatas[i].className+"treecode="+treeDatas[i].RptCfgTreeCode);
									var pNode=searchNodeByAttrib(startNode,"",treeDatas[i].DatasetTreeCode,treeDatas[i].DatasetRptCode,"","");
									//alert(pNode.length);
									if (pNode.length>0) {
										pNode[0].appendChild(childNode);
									}
									//startNode.expand();
								}
								if(className=="DHCWL.MKPI.MMgrKPICfg") {


									childNode = new Ext.tree.TreeNode( {
										primaryValue:treeDatas[i].primaryValue,
										className:treeDatas[i].className,
										datasetCode:treeDatas[i].KPIDatasetCfgCode,
										//desc:treeDatas[i].DatasetCfgDesc,
										kpiCode:treeDatas[i].KPICfgCode,
										rptCode:treeDatas[i].KPIRptCode,
										treeCode:treeDatas[i].KPITreeCode,
										object:treeDatas[i].KPICfgCode,
									    type:'指标',
									    code:treeDatas[i].KPICfgCode,
									    iconCls:'task-folder',
									    expanded: true,
									    checked: false
									  });		

									//alert("class="+treeDatas[i].className+"treecode="+treeDatas[i].RptCfgTreeCode);
									var pNode=searchNodeByAttrib(startNode,"",treeDatas[i].KPITreeCode,treeDatas[i].KPIRptCode,treeDatas[i].KPIDatasetCfgCode,"");
									//alert(pNode.length);
									if (pNode.length>0) {
										pNode[0].appendChild(childNode);
									}
									//startNode.expand();
								}
								
							}
						
							startNode.expand();
							imported=0;
							alert("文件读入成功！");

		        			//alert(jsonData.tempFile);
						}catch(e){
							Ext.Msg.show({title:'错误2',msg:result.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}

					}
    			});
           		win.body.mask("数据处理中，请稍等");
	            
            }
        },'-',{
            ref: '../removeBtn',
            iconCls: 'icon-user-delete',
            //text: '导入前检查',
            text: '<span style="line-Height:1">导入前检查</span>',
            icon: '../images/uiimages/search.png',
            //disabled: true,
            handler: onCheck
        },'-',{
            ref: '../removeBtn',
            iconCls: 'icon-user-delete',
            //text: '导入模块',
            text: '<span style="line-Height:1">导入模块</span>',
            icon: '../images/uiimages/importdata.png',
            //disabled: true,
            handler: onImport
        }],
        buttonAlign:'center',
        buttons : [  
        {  
          //text : '关闭', 
          text: '<span style="line-Height:1">关闭</span>',
          icon: '../images/uiimages/cancel.png',
          handler : function() {
          	//clean();
            //win.hide(this);    
          	win.close();
          }

        }
      ]  

        //dataUrl: 'treegrid-data.json'
        //dataUrl:treegrid_data
    });
    
		var root = new Ext.tree.TreeNode( {
		treeCode:"root",
		className:"DHCWL.MKPI.MMgrModuleCfg",
	 	object:'root: root',
	    type:'',
	    iconCls:'task-folder',
	    expanded: true,		
		
		
		text : '模块管理树',
		draggable : false,
		checked :false
		  });
		tree.setRootNode(root);    
    
    
       
    
    //add by wz.2014-4-21
    tree.on('contextmenu',function( node,  e ){
        		e.preventDefault();
        		quickMenu.showAt(e.getXY());
		})   
		
	//级联选择子节点
	function selSubNode(node, checked){
			node.expand();  
            node.attributes.checked = checked;  
            node.eachChild(function(child) {  
                child.ui.toggleCheck(checked);  
                child.attributes.checked = checked;  
                //child.fireEvent('checkchange', child, checked);  
            });  
        }		
		
         
   // rd=new Ext.tree.AsyncTreeNode(treegrid_data);
	//	tree.setRootNode(rd);
	function searchNodeByAttrib(startNode,className,treeCode,rptCode,datasetCode,kpiCode) {

        var r = [];
        var f = function(){
        	var falsecnt=0;
        	var attrib=this.attributes;
        	if (className!="") {
        		if (useddebug==1)  alert("attrib.className="+attrib.className+"  className="+className);
        		if ("undefined" == typeof attrib.className || attrib.className!=className) {
					falsecnt=1
        		}
        	}
        	if (falsecnt==0 && treeCode!="") {
        		if (useddebug==1)  alert("attrib.className="+attrib.className+"  className="+className);
        		if ("undefined" == typeof attrib.treeCode || attrib.treeCode!=treeCode) {
					falsecnt=1
        		}
        	}	        	
        	if (falsecnt==0 && rptCode!="") {
        		if (useddebug==1)  alert("attrib.rptCode="+attrib.rptCode+"  rptCode="+rptCode);        		
        		if ("undefined" == typeof attrib.rptCode || attrib.rptCode!=rptCode) {
					falsecnt=1
        		}
        	}		        	
        	if (falsecnt==0 && datasetCode!="") {
        		if (useddebug==1)  alert("attrib.datasetCode="+attrib.datasetCode+"  datasetCode="+datasetCode);        		
        		if ("undefined" == typeof attrib.datasetCode || attrib.datasetCode!=datasetCode) {
					falsecnt=1
        		}
        	}	
        	if (falsecnt==0 && kpiCode!="") {
        		if (useddebug==1)  alert("attrib.kpiCode="+attrib.kpiCode+"  kpiCode="+kpiCode);        		
        		if ("undefined" == typeof attrib.kpiCode || attrib.kpiCode!=kpiCode) {
					falsecnt=1
        		}
        	}		        	
            if(falsecnt==0){
                r.push(this);
            }
        };
        startNode.cascade(f);
        return r;
		
		
	}

	//得到某个节点下面的叶子节点
	function getLeafNode(startNode){

	        var r = [];
	        var f = function(){
	            if(this.childNodes<=0){
	                r.push(this.id);
	            }
	        };
	        startNode.cascade(f);
	        return r;

	}

	function onImport(btn, ev) {

		if (imported==1) {
			Ext.Msg.alert("提示","已经执行导入操作了，请重新点击读入模块文件");
			return;
		}
		var nodePKs=new Array();
        selNodes = tree.getChecked();
        
        if(selNodes.length==0){
			alert("导入列表为空，请先选择要导入的模块！");
			return;
		}
		
		/*
		for (var i=0;i<=selNodes.length-1;i++) {
			var tmpNode=selNodes[i];
			alert("tmpNode.attributes.primaryValue:"+tmpNode.attributes.primaryValue);
			while (tmpNode.getDepth()>0) {
				var isSame=0;
				for(var j=0;j<=nodePKs.length-1;j++) {
					if (nodePKs[j]==tmpNode.attributes.primaryValue) {
						isSame=1;
						break;
					}
				}
				if (isSame==0) nodePKs.push(tmpNode.attributes.primaryValue);
				tmpNode=tmpNode.parentNode;
			}
		}
		*/
		for (var i=0;i<=selNodes.length-1;i++) {
			var tmpNode=selNodes[i];

			//alert("tmpNode.attributes.primaryValue:"+tmpNode.attributes.primaryValue);
			while (tmpNode.getDepth()>0) {
				var isSame=0;
				var pValue=tmpNode.attributes.primaryValue;
				//alert("pValue="+pValue);
				if (tmpNode.attributes.type=="指标") {
					pValue=tmpNode.attributes.kpiCode;
				}				
				for(var j=0;j<=nodePKs.length-1;j++) {
					if (nodePKs[j]==pValue) {
						isSame=1;
						break;
					}
				}
				if (isSame==0) nodePKs.push(pValue);
				tmpNode=tmpNode.parentNode;
			}
		}		
		//alert(nodePKs.join(","));
		//return;
		var url='dhcwl/kpi/kpimoduleimp.csp'; //?action=inputKpiFile&fileName='+serverSaveFileName+'&realInputKpiList='+realInputKpiList.join(",");
		Ext.Ajax.request({
			url: encodeURI(url),
			waitMsg : '正在处理...',
			method:'POST',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:result.responseText+'<br/>\n导入超时，文件太大，请将文件分为多个依次导入!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){	
				win.body.unmask();
				var jsonData;
				try{
					jsonData = Ext.util.JSON.decode( result.responseText );
				}catch(e){
					Ext.Msg.show({title:'错误',msg:result.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				if(jsonData.info=='ok'){
					serverSaveFileName=null;
					//tree.getRootNode().removeAll();
					onFlashTree();			//add by wz.2014-4-18.更新树
					Ext.Msg.show({title:'提示',msg:jsonData.tips,icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					imported=1;
					//parentPanel.tree.expandAll();
				}else{
					Ext.Msg.show({title:'错误',msg:jsonData.tips,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			params:{
				action:'inputKpiFile',
				fileName:serverSaveFileName,
				realInputModuleList:nodePKs.join(",")
			},
			timeout:1800000
		});
		win.body.mask("数据处理中，请稍等");



		return;
		
		/*
        Ext.each(selNodes, function(node){
            if(nodeIDs.length > 0){
                nodeIDs += ","+node.id;
            }else{
	            nodeIDs=node.id
            }
        });           		
		*/
		//nodePKs += ","+node.attributes.primaryValue;
		
		/*
		
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

		serverSaveFileName=null;
		return;
		
	
	}
	*/
	}
	function onReadXML(btn, ev){}
	
	function onCheck(btn,ev){

		if(serverSaveFileName==null||serverSaveFileName==""){
			alert("还没有导入文件或导入文件错误，不能进行导入前查看");
			return;
		}
		//var isUpdate=inputForm.getForm().getValues(false).isUpdate;
		var url='dhcwl/kpi/kpimoduleimp.csp?action=inputKpiFile&checkedInput=1&fileName='+serverSaveFileName;
		dhcwl.mkpi.Util.ajaxExc(url,{},
		function(jsonData){
			if(!jsonData){
				Ext.Msg.show({title:'错误',msg:"处理响应数据失败1！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(jsonData.success==true){
				//add for debug
				
					try{
					var treeDatas=jsonData.data; //findKpiNameFromXML(path,kpis);
					var len=treeDatas.length;
					var startNode=tree.getRootNode();					
					for (var i=0;i<=len-1;i++) {
						//if (treeDatas[i]==null || treeDatas[i]=="") continue;
						className=treeDatas[i].className;

						var pNode=null;
						if(className=="DHCWL.MKPI.MMgrModuleCfg") {
							pNode=searchNodeByAttrib(startNode,"DHCWL.MKPI.MMgrModuleCfg",treeDatas[i].ModuleCfgTreeCode,"","","");
							if (pNode.length<=0) continue;
						}
						if(className=="DHCWL.MKPI.MMgrRptCfg") {
							pNode=searchNodeByAttrib(startNode,"",treeDatas[i].RptCfgTreeCode,treeDatas[i].RptCfgCode,"","");
							if (pNode.length<=0) continue;
						}
						if(className=="DHCWL.MKPI.MMgrDataSetCfg") {
							pNode=searchNodeByAttrib(startNode,"",treeDatas[i].DatasetTreeCode,treeDatas[i].DatasetRptCode,treeDatas[i].DatasetCfgCode,"");
							if (pNode.length<=0) continue;
						}
						if(className=="DHCWL.MKPI.MMgrKPICfg") {
							pNode=searchNodeByAttrib(startNode,"",treeDatas[i].KPITreeCode,treeDatas[i].KPIRptCode,treeDatas[i].KPIDatasetCfgCode,treeDatas[i].KPICfgCode);
							if (pNode.length<=0) continue;
						}
						pNode[0].getUI().addClass('complete');
					}
				}catch(e){
					Ext.Msg.show({title:'错误',msg:"处理响应数据失败2！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				
			}
		},
		outThis,null,120000);
		return;
            				
	}
	
	

 		//得到某个节点下面的叶子节点
 	/*	function getLeafNode(startNode){

		        var r = [];
		        var f = function(){
		            if(this.childNodes<=0){
		                r.push(this.id);
		            }
		        };
		        startNode.cascade(f);
		        return r;

 		}    	
    	*/
    	/*
    	 * 1、勾选某个节点，其下的节点默认都被选择。
    	 * 2、有效checked节点的判断
    	 * 		统计所以被勾选的节点，得到所以节点中最深的层数endDep和开始深度startDep。
    	 * 		定义祖先节点对象数组Ancestor
    	 * 		将深度是startDep的节点加入Ancestor
    	 * 		for(i=startDep+1;i<=depCnt;i++){
    	 * 			判断被勾选的深度为I的节点的祖先在不在Ancestor中，如果不在，则把该节点加入到祖先中。
    	 * 		}
    	 * 
    	 * 导出之合并树
    	 * 		for(所以要导出的数据){
    	 * 			1、如果是模块，根据treecode得到祖先treecode并加入到expModeary,得到所以子模块，并将ID加入到expModeAry，得到所有报表并将ID加入到expRpt,得到所有数据集并加入到
    	 * 				dataSetRpt中，得到所以指标并加入到KPIAry.
    	 * 			2、如果是报表，根据treecode得到祖先treecode并加入到expModeary,得到所以子模块，并将ID加入到expModeAry，然后调用putDataStartWithRpt
    	 * 		}
    	 * 
    	 */


    var win = new Ext.Window({  
	  title : '模块导入',  
	  closable : true,  
	  modal : true,  
	  width : 510,  
	  resizable : false,  
	  plain : true,  
	  //Plain为True表示为渲染window body的背景为透明的背景，这样看来window body与边框元素（framing elements）融为一体，  
	  //false表示为加入浅色的背景，使得在视觉上body元素与外围边框清晰地分辨出来（默认为false）。  
	  //layout : 'form',  
		items: [{
			items:fp
		},{
		    items:tree	
		}] /*,
		bbar: new Ext.ux.StatusBar({
			id: 'imp-statusbar',
			defaultText: 'Ready'
		})*/
	
	}
    );  

  
    this.setParentPanel=function(parentP){
    	parentPanel=parentP;
    }
    this.show=function(){
    	win.show(this);
    }

	function clean(){
		var form=fp.getForm();
		form.findField("selectImportModuleFile").setValue("");  
		//Ext.ComponentMgr.get('selectImportModuleFile').setValue(""); 
		serverSaveFileName=null;
		           	//清除树结构及保存在服务器上的文件名
        tree.getRootNode().removeAll();
		tree.getRootNode().removeAll();
	}
	
	function onFlashTree() {
		parentPanel.setSearchObj("","","");
		parentPanel.expandAllNode();
	}
	

}
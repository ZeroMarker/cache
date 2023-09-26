(function(){
	Ext.ns("dhcwl.mkpi.KpiModuleCfg");
})();

dhcwl.mkpi.KpiModuleCfg=function(){
	var outThis=this;
	var searchCriteria="";
	var menuAct="";
	var mmSEDateCfgObj=null;
	var kpiModuleImp=null;
	var handleKpis="";
	var rptFunObj;
	/*
    var fbutton = new Ext.ux.form.FileUploadField({
        buttonOnly: true,
        listeners: {
            'fileselected': function(fb, v){
				alert(v);
			}
        }
    });	
	*/
	
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:150,
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
    		},{
    			text:'清除选择',
    			handler:
    			    function(cmp,event){
    			    	var selNodes = tree.getChecked();
						for(var i=0;i<=selNodes.length-1;i++){
							selNodes[i].ui.toggleCheck(false)
							selNodes[i].attributes.checked = false; 
						}
    			    }    		
    		},"-",
    		{
    			text:'生成数据',
    			handler:
    			    function(cmp,event){
		 			menuAct="produceData";	
		 			Ext.MessageBox.confirm('提示框','请避免在操作高峰期使用该功能,确定要生成数据么？',function(btn){
		 				if(btn=='yes'){
		 					onKPIHandle();
		 				}
		 			});
		 			//onKPIHandle();
    			}
    		},{
    			text:'清除数据',
    			handler:function(){
		 			menuAct="cleanData";	
		 			onKPIHandle();    			
    			}
    		},{
    			text:'重生数据',
    			handler:function(){
		 			menuAct="reproduceData";
		 			Ext.MessageBox.confirm('提示框','请避免在操作高峰期使用该功能,确定要重生数据么？',function(btn){
		 				if(btn=='yes'){
		 					onKPIHandle();
		 				}
		 			});
		 			//onKPIHandle();     			
    			}
    		},{
    			text:'数据指标展示',
    			handler:function(){
    				moduleKpiShow();
    			}
    		},"-",{
    			text:'导出',
    			menu:{
    				boxMinWidth:130,
    				items:[{
			    				text:'导出无维度版',
				    			handler:function(cmp,event){
				    				onExport2(0);			    				
				    			}
			    			},{
			    				text:'导出有维度版',
				    			handler:function(cmp,event){
				    				onExport2(1);			    				
				    			}	
			    			}
			    			]
    			}
    			
    			//handler:onExport2
    		},{
    			text:'安装',
    			menu:{
    				boxMinWidth:150,
    				items:[{
			    				text:'从XML文件安装',
				    			handler:function(cmp,event){
				    				//outThis.onShowInput("produceData");
									var kpiModuleImp=new dhcwl.mkpi.KpiModuleImport();
									kpiModuleImp.setParentPanel(outThis);
									//kpiModuleImp.clean();
									kpiModuleImp.show(); 			    				
				    			}
			    			},{
			    				text:'从EXECL文件安装',
				    			handler:function(cmp,event){
				    				//outThis.onShowInput("produceData");
									var kpiModuleImp=new dhcwl.mkpi.KpiModuleImportFormExl();
						 			
									kpiModuleImp.setParentPanel(outThis);
									//kpiModuleImp.clean();
									kpiModuleImp.show(); 			    				
				    			}	
			    			}
			    			]
    			}	
    		},'-',
    		{
    			text:'任务区间设置',
    			handler:function(){
    				onSectionHandle();
    			}
    		},
    		{
    			text:'指标任务开关',
    			menu:{
    				boxMinWidth:130,
    				items:[
		    			{
		    				text:'激活区间任务',
		    				handler:onActivateKPITask
		    			},{
		    				text:'停止区间任务',
		    				handler:onStopKPITask
		    			}/*,{
		    				text:'停止全部指标任务',
		    				handler:onStopAllKPITask
		    			}*/
		    		]
    			
    			}    			
    		}]
	});	
	

    
	
	var formPanel = new Ext.FormPanel({
        labelWidth: 75, 
        frame:false,
        bodyStyle:'padding:5px 5px 0',
        height:100,
        defaultType: 'textfield',

        items: [{
                id:'formModulecfgDesc',
                fieldLabel: '模块名称',
                name: 'modulecfgDesc',
                allowBlank:false
            },{
                id:'formModulecfgCode',
                fieldLabel: '模块编码',
                name: 'modulecfgCode'
            }
        ],

        buttons: [{
            //text: '保存',
            text: '<span style="line-Height:1">保存</span>',
            icon: '../images/uiimages/filesave.png',
            handler : function(){
            	//var selNode = tree.getSelectionModel().getSelectedNode();
				 var selNodes = tree.getChecked();
		        
		        if(selNodes.length<=0){
					Ext.MessageBox.alert("提示","请先勾选一个模块作为父模块。");
					return;
				}
				
		        if(selNodes.length>1){
					Ext.MessageBox.alert("提示","只能勾选单个模块作为父模块。");
					return;
				}		
				
	        	//var selNode = tree.getSelectionModel().getSelectedNode();
				var selNode = selNodes[0];            	
            	
            	
            	
            	
            	
            	
            	if(selNode){ 
            		
            		var moduleDesc=Ext.get('formModulecfgDesc').getValue();
            		if(moduleDesc) moduleDesc=moduleDesc.trim();
            		var moduleCode=Ext.get('formModulecfgCode').getValue();
            		if(moduleCode) moduleCode=moduleCode.trim();          		
            		
                 	var form=formPanel.getForm();
                	var field=form.findField("formModulecfgCode");
                	var isHide=field.hidden;
                	
            		//add by wz 2013-11-27
            		if (isHide) {
            			if (moduleDesc=="") {

	            			Ext.MessageBox.alert('提示','模块名称不能为空！');
	            			return;
            			}
            			
            			var pNode=selNode.parentNode;
            			for(var i=0;i<=pNode.childNodes.length-1;i++){
            				var brotherNode=pNode.childNodes[i]
            				if (brotherNode==selNode) continue; 
            				if(brotherNode.text.split(":")[0]==moduleDesc){
            				//if(brotherNode.id==selNode.id+"."+moduleCode){
            					Ext.MessageBox.alert('提示','亲，新的模块名称与他的兄弟名称相同！请更换名称再试！');   
            					return;
            				}
            				
            			}        
            		}else if (!isHide ) {
            			if (moduleDesc=="" || moduleCode==""){
            				Ext.MessageBox.alert('提示','模块名称或模块编码不能为空！');
            				return;
            			}
            			
            			if (moduleCode.indexOf(".")>=0 || moduleCode.indexOf("||")>=0 || moduleCode.indexOf("（")>=0 || moduleCode.indexOf("）")>=0 || moduleCode.indexOf("(")>=0 || moduleCode.indexOf(")")>=0) {
							Ext.MessageBox.alert("提示","模块编码不能包含字符'.'或'||'或'('或')'！");
							return;
						}            	            			
            			
            			//var PNode=selNode.parentNode;
            			for(var i=0;i<=selNode.childNodes.length-1;i++){
            				var brotherNode=selNode.childNodes[i]
            				if(brotherNode.id==selNode.id+"."+moduleCode){
            					Ext.MessageBox.alert('提示','亲，新的模块编码与他的兄弟编码相同！请更换编码再试！');   
            					return;
            				}
            				
            			}
            			
            			for(var i=0;i<=selNode.childNodes.length-1;i++){
            				var brotherNode=selNode.childNodes[i]
            				if(brotherNode.text.split(":")[0]==moduleDesc){
            				//if(brotherNode.id==selNode.id+"."+moduleCode){
            					Ext.MessageBox.alert('提示','亲，新的模块名称与他的兄弟名称相同！请更换名称再试！');   
            					return;
            				}
            				
            			}             			
            			           			
            		}
            		/*
            		}else if (!isHide && (moduleDesc=="" || moduleCode=="")) {
            			Ext.MessageBox.alert('提示','模块名称或模块编码不能为空！');
            			return;
            		}*/

            			
            			
                	
                	var pCode=selNode.id;
                	if(isHide) {
 						//修改

                		
	            		var url="dhcwl/kpi/kpimodulecfgdata.csp?action=modifyTreeNode&desc="+moduleDesc+"&treecode="+selNode.id;
						dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
	 						if(jsonData.success==true){
								if(jsonData.tip!="ok"){
	 								alert(jsonData.tip+":SQLCODE="+jsonData.SQLCODE);
	 							}else{
	 								selNode.setText(moduleDesc+":"+selNode.attributes.code);
	  								alert("修改成功！");
	 							}	 							
	 							

	 						}
	 					},this);		            		
	            		
	            		
	 					formPanel.ownerCt.setHeight(0);
               			field.show();
               			field.label.show();
                	}else{
                		//添加
	            		var url="dhcwl/kpi/kpimodulecfgdata.csp?action=addTreeNode&desc="+moduleDesc+"&code="+moduleCode+"&pcode="+pCode;
	 					dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
	 						if(jsonData.success==true&&jsonData.tip=="ok"){
								
								var childNode = new Ext.tree.AsyncTreeNode( {
								text : moduleDesc+":"+moduleCode,
								draggable : true,
								checked :false,
								//leaf:true,
								id:pCode+"."+moduleCode,
								code:moduleCode				//add by wz.2014-4-18
								  });
								//2013-11-7
								selNode.leaf=false;
								selNode.appendChild(childNode);
								selNode.expandChildNodes();
								
	 						}else{
	 							if(jsonData.SQLCODE==-119) alert("亲，新的模块编码与他的兄弟编码相同！请更换编码再试！");
	 							else alert(jsonData.tip+":SQLCODE="+jsonData.SQLCODE);
	 						}
	 						
	 					},this);	
                	}
            	}
            	this.ownerCt.ownerCt.ownerCt.setHeight(0);
            }
        },{
            //text: '取消',
            text: '<span style="line-Height:1">取消</span>',
            icon: '../images/uiimages/undo.png',
            handler : function(){
             	this.ownerCt.ownerCt.ownerCt.setHeight(0);
             	
             	//显示被隐藏的form 
             	var form=formPanel.getForm();
            	var field=form.findField("formModulecfgCode");
            	var isHide=field.hidden;
            	if(isHide) {
 					formPanel.ownerCt.setHeight(0);
           			field.show();
           			field.label.show();
            	}             	
            }
        }]
    });	
	
	 var tree = new Ext.tree.TreePanel( {
		 tbar: [{
            /*
            xtype: 'buttongroup',
            columns: 5,
			defaults: {
                //labelSeparator:'|'
            },*/

            id:'add',
            //text:'新增',
            text: '<span style="line-Height:1">新增</span>',
            icon: '../images/uiimages/edit_add.png',
            handler: onAdd,
            scope: this
        },'-',{
            id:'del',
            //text:'删除',
            text: '<span style="line-Height:1">删除</span>',
            icon: '../images/uiimages/edit_remove.png',
            handler: onDel,
            scope: this
        },'-',{
            id:'modify',
            //text:'修改',
            text: '<span style="line-Height:1">修改</span>',
            icon: '../images/uiimages/pencil.png',
            handler: onModify,
            scope: this
        }]
		,	
		height:500,
		//name:"cfgTreePanel",
		id:"cfgTreePanel",
		autoScroll : true,
		animate : true,
		//enableDD : true,
		containerScroll : true,
		loader : new Ext.tree.TreeLoader( {
		      dataUrl : 'dhcwl/kpi/kpimodulecfgdata.csp?action=getTreeNode'+'&Criteria='+searchCriteria// OrgTreeJsonData.action就是要动态载入数据的请求地址，这里请求时会提交一个参数为node的值，值为root即new Tree.AsyncTreeNode()对象的id值
		        })
	 	/*listeners:{load:function(){
	 		var rootnode=tree.getRootNode();
	 		console.log(tree.getRootNode());
	 		if(rootnode.childNodes.length>0){
	 			console.log(1);
	 			rootnode.childNodes[0].expand();
	 		}
	 	}}*/
		});
	 	 

		
		function cleanNodeChk() {
			var selNodes = tree.getChecked();
			for(var i=0;i<=selNodes.length-1;i++){
				selNodes[i].attributes.checked = false; 
			}
 
		}
		//级联选择子节点
		function selSubNode(node, checked){
                /*
                if(checked){
                	var nodeCode=node.id;
                    node.getUI().addClass('complete');
                }else{
                    node.getUI().removeClass('complete');
                }
               
                if(checked){
                	if (node.hasChildNodes() ){
                		for(var i=0;i<=node.childNodes.length-1;i++){
                			node.childNodes[i].checked=true;	
                			node.childNodes[i].ui.toggleCheck(checked); 
                		}
                	}
                  }else{
                    node.getUI().removeClass('complete');
                }
                 */
				node.expand();  
                node.attributes.checked = checked;  
                node.eachChild(function(child) {  
                    child.ui.toggleCheck(checked);  
                    child.attributes.checked = checked;  
                    //child.fireEvent('checkchange', child, checked);  
                });  
            }
        //tree.on('checkchange',  selSubNode);   
            /*
		tree.on('checkchange', function(node, checked){
                /*
                if(checked){
                	var nodeCode=node.id;
                    node.getUI().addClass('complete');
                }else{
                    node.getUI().removeClass('complete');
                }
               
                if(checked){
                	if (node.hasChildNodes() ){
                		for(var i=0;i<=node.childNodes.length-1;i++){
                			node.childNodes[i].checked=true;	
                			node.childNodes[i].ui.toggleCheck(checked); 
                		}
                	}
                  }else{
                    node.getUI().removeClass('complete');
                }
                 
                 				
                 				
                node.expand();  
                node.attributes.checked = checked;  
                node.eachChild(function(child) {  
                    child.ui.toggleCheck(checked);  
                    child.attributes.checked = checked;  
                    //child.fireEvent('checkchange', child, checked);  
                });  
			
			
            })
            
            */
            
 		tree.on('afterrender', function(t){
 				//Ext.Msg.alert("tip","after render");
				//tree.expandAll();
 			tree.getRootNode().expand(false,true,function(){
 				var nodeArray=tree.getRootNode();
            });  
 		});
           
   		tree.on('beforedblclick', function(node,e){
 			var nodeCode=node.id;
			var rptPanel=Ext.ComponentMgr.get('rptCfgGridPanel');
			rptFunObj.clearSel();
			//alert(searchCriteria);
			rptPanel.store.proxy=new Ext.data.HttpProxy({url:encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=getNode&PCode="+nodeCode+"&Criteria="+searchCriteria)}); 
			//rptPanel.store.proxy=new Ext.data.HttpProxy({url:"dhcwl/kpi/kpirptcfgdata.csp?action=getNode&PCode="+nodeCode+"&Criteria="+searchCriteria}); 
			rptPanel.store.reload({params:{start:0,limit:10}});

			//清空维度列表.add by wz.2013-12-4
			var dimPanel=Ext.ComponentMgr.get('datasetCfgPanel');	
			if(dimPanel.store.getCount()>0){
				dimPanel.store.removeAll();
			}
			
				//return true;
			return false;
            });          
 
  		tree.on('checkchange',function(node, checked){
                if(checked){
		 			var nodeCode=node.id;
					var rptPanel=Ext.ComponentMgr.get('rptCfgGridPanel');
					//alert();
					rptPanel.store.proxy=new Ext.data.HttpProxy({url:encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=getNode&PCode="+nodeCode+"&Criteria="+searchCriteria)}); 
					//rptPanel.store.proxy=new Ext.data.HttpProxy({url:"dhcwl/kpi/kpirptcfgdata.csp?action=getNode&PCode="+nodeCode+"&Criteria="+searchCriteria}); 
					rptPanel.store.reload();
		
					//清空维度列表.add by wz.2013-12-4
					var dimPanel=Ext.ComponentMgr.get('datasetCfgPanel');	
					if(dimPanel.store.getCount()>0){
						dimPanel.store.removeAll();
					}
			
                }else{
		 			var nodeCode=node.id;
					var rptPanel=Ext.ComponentMgr.get('rptCfgGridPanel');
					if(rptPanel.store.getCount()>0){
						rptPanel.store.removeAll();
					}
                }
           });          
            
		tree.on('contextmenu',function( node,  e ){
        		e.preventDefault();
        		quickMenu.showAt(e.getXY());
		});


		
		var root = new Ext.tree.AsyncTreeNode( {
		      text : '模块管理树',
		draggable : false,
		checked :false,
		id : 'root'//默认的node值：?node=-100
		  });
		tree.setRootNode(root);

	
	var moduleCfgPanel=new Ext.Panel({
		frame:false,
	items: [{

		//collapsible: false,
		id:"moduleCfgFormPanel",
		frame:false,
	    margins: '5 0 0 0',
	    cmargins: '5 5 0 0',
	    height:100,
	    minSize: 100,
	    maxSize: 500,
	    items:formPanel			            
	},{
		id:"moduleCfgTreePanel",
		autoHeight:true,
		autoScroll:true,
		//collapsible: true,
	    title: '模块树',
	    margins: '5 0 0 0',
	    cmargins: '5 5 0 0',
	    minSize: 100,
	    maxSize: 500,
	    items:tree
	}
	]}
	)
	
		this.showWindow = function(btn){
        Ext.MessageBox.alert("hello","Hello,easyjf open source");
    };
	
	
	formPanel.ownerCt.setHeight(0);


 	this.getModuleCfgPanel=function(){
		return moduleCfgPanel;
	}   

	this.setSearchObj=function(sObj,sAttrib,sValue){
		//alert(sObj);
		searchCriteria=sObj+","+sAttrib+","+sValue;
		//alert(searchCriteria);
		rootNode=tree.getRootNode();
		rootNode.remove();
		//rootNode.leaf=false;
		
		var root = new Ext.tree.AsyncTreeNode( {
		      text : '模块管理树',
		draggable : false,
		checked :false,
		id : 'root'//默认的node值：?node=-100
		  });
		tree.setRootNode(root);	
		
		tree.loader = new Ext.tree.TreeLoader( {
		      dataUrl : encodeURI('dhcwl/kpi/kpimodulecfgdata.csp?action=getTreeNode'+'&Criteria='+searchCriteria)// OrgTreeJsonData.action就是要动态载入数据的请求地址，这里请求时会提交一个参数为node的值，值为root即new Tree.AsyncTreeNode()对象的id值
		        })
		/*tree.getRootNode().expand(false,true,function(){
			var nodeArray=tree.getRootNode().childNodes;
			for(var nodeIndex in nodeArray){
				nodeArray[nodeIndex].expand(false,true);
			};
		});*/
		
		
	}

	function onExport(btn, ev) {
        var nodeIDs = '', selNodes = tree.getChecked();
        Ext.each(selNodes, function(node){
            if(nodeIDs.length > 0){
                nodeIDs += ","+node.id;
            }else{
	            nodeIDs=node.id
            }
        });           
    
        
 
    	if(nodeIDs.length==0){
			alert("导出列表为空，请先选择要导出的模块！");
			return;
		}
		
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',
		{action:'ExportModuleToXML',codes:nodeIDs},  //getFileContent edited by lhh @20131101
		function(responseText){
			//alert(responseText);
			if(responseText){
				//alert(responseText);
				dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+'outputModule.kpi',dhcwl.mkpi.Util.trimLeft(responseText));
			}else{
				Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
			}
		}
		,outThis,true);
	}
	
	
		function onImport(btn, ev) {
			var insModule=new dhcwl.mkpi.InsModuleData();
			insModule.show();
		
		}
		
		function onAdd(btn, ev) {
			 var selNodes = tree.getChecked();
	        
	        if(selNodes.length<=0){
				Ext.MessageBox.alert("提示","请先勾选一个模块作为父模块。");
				return;
			}
			
	        if(selNodes.length>1){
				Ext.MessageBox.alert("提示","只能勾选单个模块作为父模块。");
				return;
			}		
			
        	//var selNode = tree.getSelectionModel().getSelectedNode();
			var selNode = selNodes[0];
        	if(selNode){
        		
        		/*
        		var abc=getLeafNode(selNode);
        		for (var i=0;i<=abc.length-1;i++) {
        			
        			alert(tree.getNodeById(abc[i]).text);
        		}
        		*/
        		//alert(tree.getNodeById("whetcrz").text);
             	//新增之前判读该节点是否关联报表，如果关联报表就不能新增。add by wz.2013-12-13
            		//添加
            		/*
            		var url="dhcwl/kpi/kpimodulecfgdata.csp?action=getRptCnt&code="+selNode.id;
 					dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
 						if(jsonData.success==true){
 							if(jsonData.recCnt>0){
 								Ext.MessageBox.alert("提示","该模块已关联报表，不能添加子模块！");
								return;
 							}else{
			            		//add by wz .2013-11-27
			            		var form=formPanel.getForm();
			            		form.findField("formModulecfgCode").setValue("");      
			                	form.findField("formModulecfgDesc").setValue("");  
			            		formPanel.ownerCt.setHeight(100);      	 								
 							}
 						}
 					},this);	
 					*/ 
			            		var form=formPanel.getForm();
			            		form.findField("formModulecfgCode").setValue("");      
			                	form.findField("formModulecfgDesc").setValue("");  
			            		formPanel.ownerCt.setHeight(100);      	 					        		
        	}
        	else {
				Ext.MessageBox.alert("提示","请先选择一个模块作为父模块。");
        	}
		}
		
		function onDel(btn, ev) {	
			 var selNodes = tree.getChecked();
	        if(selNodes.length<=0){
				Ext.MessageBox.alert("提示","请先勾选一个模块。");
				return;
			}
			
	        if(selNodes.length>1){
				Ext.MessageBox.alert("提示","只能勾选单个模块。");
				return;
			}		
			
        	//var selNode = tree.getSelectionModel().getSelectedNode();
			var selNode = selNodes[0];					
			
            //var selNode = tree.getSelectionModel().getSelectedNode();
        	if(selNode){
        		//if(selNode.hasChildNodes()){
        		if(selNode.childNodes.length>0){
        			Ext.MessageBox.alert("提示","要删除的模块含有子模块，无法删除！请选择叶子节点模块。");
        			return;
        		}
        		if(selNode.id=='root'){
                	Ext.MessageBox.alert("提示","根模块不能删除！");
                	return;
                }  
        		//modify by wz.2013-11-28
            	 Ext.MessageBox.confirm('确认', '删除这个模块会同时删除该模块下的报表、数据集、指标的配置数据。你确定要删除这个模块吗？', function(id){
	                 if (id=="no") {
	 	                return;               	
	                 }

                	var pNode=selNode.parentNode;
              		var url="dhcwl/kpi/kpimodulecfgdata.csp?action=delTreeNode&treecode="+selNode.id;
 					
 					dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
 						if(jsonData.success==true){
 							if(jsonData.tip!="ok"){
 								alert(jsonData.tip+":SQLCODE="+jsonData.SQLCODE);
 							}else{
 								
 								//清空报表和数据集控件
  								var rptPanel=Ext.ComponentMgr.get('rptCfgGridPanel');
  								if(rptPanel.getStore().getCount()>0) {
  									var rptRec=rptPanel.getStore().getAt(0);
  									if (rptRec.get("RptCfg_TreeCode")==selNode.id) {
  										rptPanel.getStore().removeAll();
  										
 	 									var datasetPanel=Ext.ComponentMgr.get('datasetCfgPanel'); 
 	 									datasetPanel.getStore().removeAll();
  									}
  								}
  								
  								selNode.remove();	
  								
  								
  								Ext.MessageBox.alert("提示","删除成功！");
 							}
 						}
 					},this);		                 
                 })            		
            }                
            else Ext.MessageBox.alert("提示","请先选择要删除的模块！");
 		}
		
		function onModify(btn, ev) {
			 var selNodes = tree.getChecked();
	        if(selNodes.length<=0){
				Ext.MessageBox.alert("提示","请先勾选一个模块。");
				return;
			}
			
	        if(selNodes.length>1){
				Ext.MessageBox.alert("提示","只能勾选单个模块。");
				return;
			}		
			
        	//var selNode = tree.getSelectionModel().getSelectedNode();
			var selNode = selNodes[0];			
            //var selNode = tree.getSelectionModel().getSelectedNode();
        	if(selNode){
               if(selNode.id=='root'){
                	Ext.MessageBox.alert("提示","根模块不能修改！");
                }  
                else{
                	var form=formPanel.getForm();
                	//add by wz.2013-12-11
            		form.findField("formModulecfgCode").setValue("");
            		var modifyText=selNode.text.split(":")[0];
                	form.findField("formModulecfgDesc").setValue(modifyText);  //add by wz.2013-11-27
                	
					//隐藏编码fom
                	form.findField("formModulecfgCode").hide();
                	form.findField("formModulecfgCode").label.hide();
                	
                	formPanel.ownerCt.setHeight(100);
                }
            }                
 		}

 		function onSearch(){
 			
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
 		
 		var task_CheckDateState={
 				run:CreatDateProcess,
 				interval:5000
 		};
 		
 	    function CreatDateProcess(){
 	    	var url=encodeURI("dhcwl/kpi/kpimodulecfgdata.csp");
 	    	dhcwl.mkpi.Util.ajaxExc(url,
 	    		{
 	    			action:'getCreatDataInfor',
 	    			moduleDataFlag:moduleDataFlag
 	    		},
 	    		function(jsonData){
 	    			if (jsonData.success==true){
 	    				Ext.MessageBox.updateProgress(jsonData.number,'生成进度');
 	    				//Ext.MessageBox.alert("提示框","这是个提示框");
 	    				if(jsonData.number==1){
 	    					Ext.TaskMgr.stop(task_CheckDateState);
 	    					Ext.MessageBox.alert("提示","生成成功");
 	    				}
 	    				if(jsonData.number==-1){
 	    					Ext.TaskMgr.stop(task_CheckDateState);
 	    					Ext.MessageBox.alert("提示","生成失败");
 	    				}
 	    			}else{
 	    				Ext.TaskMgr.stop(task_CheckDateState);
 						Ext.MessageBox.alert("提示","生成失败");
 	    			}
 	    		},this);
 	    	
 	    }
 		
 		/*
 		this.onShowInput=function(actStr){
			
			if (mmSEDateCfgObj==null) {
				mmSEDateCfgObj=new dhcwl.mkpi.KpiMMgrSEDateCfg();
 			}
 			menuAct=actStr;	
			mmSEDateCfgObj.setParentPanel(outThis);
			mmSEDateCfgObj.show(); 			
 		}
 		*/
 		
 		//actFlag————1:冲突检查；2：直接进行数据操作；3：根据冲突检查返回的KPI进行数据操作。
 		this.onMmDataHandle=function(startDate,endDate,actFlag,dateSecType){
 			
 			if (actFlag==-1) {	//在页面中选择了取消操作
 				menuAct="";
 				return;
 			}

	        var selNodeIDs = "", selNodes = tree.getChecked();
	        var notLeafNodes="";
		    if (actFlag==1 || actFlag==2) {				
		        for (var i=0;i<=selNodes.length-1;i++) {
		        	if(selNodeIDs.length > 0){
		                selNodeIDs = selNodeIDs + ",";
		            }
			        selNodeIDs=selNodeIDs + selNodes[i].id;	  
		        }
		    }
    		var url=encodeURI("dhcwl/kpi/kpimodulecfgdata.csp");
			dhcwl.mkpi.Util.ajaxExc(url,
				{
					action:'mmHandleData',
					Criteria:searchCriteria,
					treeNodes:selNodeIDs,
					rptCodes:'',
					KPICodes:handleKpis,
					startDate:startDate,
					menuAct:menuAct,
					endDate:endDate,
					actFrom:'module',
					actFlag:actFlag	,//1:冲突检查；2：直接进行数据操作；3：根据冲突检查返回的KPI进行数据操作。
					dateSecType:dateSecType
				},
				function(jsonData){
					if(actFlag==2 ||actFlag==3) {
						if(jsonData.success==true && jsonData.tip=="ok"){
							//Ext.Msg.alert("提示","操作成功！");
							if(menuAct=="cleanData"){
								Ext.Msg.alert("提示","操作成功！");
							}else{
								moduleDataFlag=jsonData.dataFlag
								Ext.MessageBox.progress("请稍后");
								Ext.TaskMgr.start(task_CheckDateState);
							}
						}else{
							Ext.Msg.alert("提示","操作失败！");
						}
						handleKpis="";
					}
					else{
						try{
							var inputKpiList=jsonData.root;
							mmSEDateCfgObj.getCheckGrid().getStore().loadData(inputKpiList);	
							handleKpis=jsonData.kpiCodes;
	
						}catch(e){
							Ext.Msg.alert("提示","操作失败！");
							return;
						}										
					}
				}
					,this);	
 		}
	
 		
 		
	function onExport2(ExpFlag) {
        var nodeIDs = '', selNodes = tree.getChecked();
        
        if(selNodes.length==0){
			alert("导出列表为空，请先选择要导出的模块！");
			return;
		}
		
        Ext.each(selNodes, function(node){
            if(nodeIDs.length > 0){
                nodeIDs += ","+node.id;
            }else{
	            nodeIDs=node.id
            }
        });           
    
        var ret="";
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',
		{action:'ExportModuleToXML',treeCodes:nodeIDs,actFrom:'module',Criteria:searchCriteria},  
		function(responseText){
			//alert(responseText);
			if(responseText){
				try{
					var strtip=dhcwl.mkpi.Util.trimLeft(responseText).substr(0,4)
					if (strtip=="导出错误") {
						Ext.Msg.show({title:'错误',msg:responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;						
					}

					ret=dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+'outputModule.modu',dhcwl.mkpi.Util.trimLeft(responseText));
					//if (ret!="") Ext.MessageBox.alert("提示","导出成功！");
				}catch(e){
					Ext.Msg.show({title:'错误',msg:"写文件错误！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}				
			}else{
				Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
			}
		}
		,outThis,true);
		
		if (ExpFlag==0){
			dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',
					{action:'getFileContent',treeCodes:nodeIDs,actFrom:'module',Criteria:searchCriteria},
					function(responseText){
						//alert("responseText="+responseText);
						
						if(responseText){
							var ret1=dhcwl.mkpi.Util.writeFile1(ret,dhcwl.mkpi.Util.nowDateTime()+'outputKpis.kpi',dhcwl.mkpi.Util.trimLeft(responseText));
						}else{
							Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
						if((ret!="")&&(ret1!="")){
							Ext.MessageBox.alert("提示","导出成功！");
						}
					}
					,outThis,true,null);
		}
		if (ExpFlag==1){
			dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',
					{action:'getFileContentExpDim',treeCodes:nodeIDs,actFrom:'module',Criteria:searchCriteria},
					function(responseText){
						//alert("responseText="+responseText);
						
						if(responseText){
							var ret1=dhcwl.mkpi.Util.writeFile1(ret,dhcwl.mkpi.Util.nowDateTime()+'outputKpis.kpi',dhcwl.mkpi.Util.trimLeft(responseText));
						}else{
							Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
						if((ret!="")&&(ret1!="")){
							Ext.MessageBox.alert("提示","导出成功！");
						}
					}
					,outThis,true,null);
		}

	}
	
	function moduleKpiShow(){
		var selNodes=tree.getChecked();
		if (selNodes.length<=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的模块！");
			return;	   
		}
		var selNodeIDs = "", selNodes = tree.getChecked();
        var notLeafNodes="";				
	    for (var i=0;i<=selNodes.length-1;i++) {
	    	if(selNodeIDs.length > 0){
	    		selNodeIDs = selNodeIDs + ",";
	        }
		    selNodeIDs=selNodeIDs + selNodes[i].id;	  
	    }
	    var moduleKpiShowObj=new dhcwl.mkpi.ModuleKpiShow();
	    var moduleSign="module";
	    moduleKpiShowObj.show(selNodeIDs,"","",moduleSign);
	}
	function onSectionHandle(){
		var selNodes=tree.getChecked();
		if (selNodes.length<=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的模块！");
			return;	   
		}
		var selNodeIDs = "", selNodes = tree.getChecked();
        var notLeafNodes="";				
	    for (var i=0;i<=selNodes.length-1;i++) {
	    	if(selNodeIDs.length > 0){
	    		selNodeIDs = selNodeIDs + ",";
	        }
		    selNodeIDs=selNodeIDs + selNodes[i].id;	  
	    }
	    var maintainSectionTaskObj=new dhcwl.mkpi.MaintainSectionTask();
	    var moduleSign="module";
		maintainSectionTaskObj.show(selNodeIDs,moduleSign);
	}
	
	function onKPIHandle() {
		var selNodes = tree.getChecked();
		if (selNodes.length<=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的模块！");
			return;	   
		}

		if (mmSEDateCfgObj==null) {
			//mmSEDateCfgObj=new dhcwl.mkpi.KpiMMgrSEDateCfg();
			Ext.MessageBox.alert("弹出窗口对象：dhcwl.mkpi.KpiMMgrSEDateCfg有错误。");
			return;
		}

		//menuAct="produceData";	
		
		mmSEDateCfgObj.setParentPanel(outThis);
		if(menuAct=="produceData") {
			mmSEDateCfgObj.setCheckGroupHide(true);
		}
		else {
			mmSEDateCfgObj.setCheckGroupHide(false);
		}

		if(menuAct=="cleanData") {
			mmSEDateCfgObj.setDateSecTypeHide(false);
		}
		else {
			mmSEDateCfgObj.setDateSecTypeHide(true);
		}				
		mmSEDateCfgObj.show(); 
	}
	
	function onActivateKPITask(){
		var selNodes = tree.getChecked();
		if (selNodes.length<=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的模块！");
			return;	   
		}
		
		var nodeIDs="";
		for (var i=0;i<=selNodes.length-1;i++){
			if (nodeIDs=="") {
				nodeIDs=selNodes[i].id;
			}else{
				nodeIDs=nodeIDs+','+selNodes[i].id;
			}
		}
		
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',{
				action:'ActivateKPITask',
				treeCodes:nodeIDs,
				actFrom:'module'
			},  
			function(jsonData){
				moduleCfgPanel.body.unmask(); 
				if(jsonData.success==true && jsonData.tip=="ok"){
					Ext.Msg.alert("提示","操作成功！");
	
				}else{
					Ext.Msg.alert("提示","操作失败！");
				}			
	
			}
			,outThis);		
		moduleCfgPanel.body.mask("数据处理中，请稍等");  
	}
	
	function onStopKPITask(){
		var selNodes = tree.getChecked();
		if (selNodes.length<=0) {
			Ext.MessageBox.alert("提示","请先选择要操作的模块！");
			return;	   
		}
		
		var treeCodes="";
 		for (i=0;i<=selNodes.length-1;i++){
 			if (treeCodes!="") {
 				treeCodes=treeCodes+",";
 			}
 			treeCodes=treeCodes+selNodes[i].id;
 		}
		
		 var actTaskWin=new dhcwl.mkpi.showkpidata.ActivateTaskPrompt();
		 actTaskWin.setParentWin(outThis);
		 actTaskWin.setSelNodes(treeCodes,"","","module");
		 actTaskWin.show();
		 
	}
	
	/*function onStopAllKPITask(){
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodulecfgdata.csp',{
				action:'DisActivateAllKPITask'
			},  
			function(jsonData){
				moduleCfgPanel.body.unmask(); 
				//jsonData=dhcwl.mkpi.Util.trimLeft(jsonData);
				if(jsonData.success==true && jsonData.tip=="ok"){
					Ext.Msg.alert("提示","操作成功！");
	
				}else{
					Ext.Msg.alert("提示","操作失败！");
				}			
			}
			,outThis);	
		moduleCfgPanel.body.mask("数据处理中，请稍等");   		

	}*/
	
	this.setSEDateCfgObj=function(seDateCfgObj)
	{
		mmSEDateCfgObj=seDateCfgObj;
	}
	
	/*this.setSectionTaskObj=function(seSectionTaskObj)
	{
		maintainSectionTaskObj=seSectionTaskObj;
	}*/
	this.expandAllNode=function()
	{
		Ext.ComponentMgr.get('cfgTreePanel').expandAll();
	}
	this.setRptObj=function(rptObj){
		rptFunObj=rptObj;
	}
	this.getModuleTree=function(){
		return tree;
	}
}
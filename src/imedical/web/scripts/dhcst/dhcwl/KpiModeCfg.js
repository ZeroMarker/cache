(function(){
	Ext.ns("dhcwl.mkpi.KpiModeCfg");
})();

dhcwl.mkpi.KpiModeCfg=function(){
	var outThis=this;
	var formPanel = new Ext.FormPanel({
        labelWidth: 75, 
        frame:false,
        bodyStyle:'padding:5px 5px 0',
        height:100,
        defaultType: 'textfield',

        items: [{
                id:'formModecfgDesc',
                fieldLabel: '模块名称',
                name: 'modecfgDesc',
                allowBlank:false
            },{
                id:'formModecfgCode',
                fieldLabel: '模块编码',
                name: 'modecfgCode'
            }
        ],

        buttons: [{
            text: '保存',
            handler : function(){
            	var selNode = tree.getSelectionModel().getSelectedNode();
            	if(selNode){ 
            		
            		var modeDesc=Ext.get('formModecfgDesc').getValue();
            		if(modeDesc) modeDesc=modeDesc.trim();
            		var modeCode=Ext.get('formModecfgCode').getValue();
            		if(modeCode) modeCode=modeCode.trim();
 
            		
                 	var form=formPanel.getForm();
                	var field=form.findField("formModecfgCode");
                	var isHide=field.hidden;
                	var pCode=selNode.id;
                	if(isHide) {
 						//修改
	            		var url="dhcwl/kpi/kpimodecfgdata.csp?action=modifyTreeNode&desc="+modeDesc+"&code="+pCode;
						dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
	 						if(jsonData.success==true){
								selNode.setText(modeDesc);
	 						}
	 					},this);		            		
	            		
	            		
	 					formPanel.ownerCt.setHeight(0);
               			field.show();
               			field.label.show();
                	}else{
                		//添加
	            		var url="dhcwl/kpi/kpimodecfgdata.csp?action=addTreeNode&desc="+modeDesc+"&code="+modeCode+"&pcode="+pCode;
	 					dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
	 						if(jsonData.success==true){
								var childNode = new Ext.tree.AsyncTreeNode( {
								text : modeDesc,
								draggable : false,
								checked :false,
								leaf:true,
								id:modeCode
								  });
								selNode.appendChild(childNode);
	 						}
	 					},this);	
                	}
            	}
            	this.ownerCt.ownerCt.ownerCt.setHeight(0);
            }
        },{
            text: '取消',
            handler : function(){
             	this.ownerCt.ownerCt.ownerCt.setHeight(0);
             	
             	//显示被隐藏的form 
             	var form=formPanel.getForm();
            	var field=form.findField("formModecfgCode");
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
            iconCls:'add-feed',
            text:'新增',
            handler: function(){
            	var selNode = tree.getSelectionModel().getSelectedNode();
            	if(selNode){ 
            		formPanel.ownerCt.setHeight(100);           		
            	}
            	else {
					Ext.MessageBox.alert("提示","请先选择一个模块作为父模块。");
            	}
            },
            scope: this
        },'-',{
            id:'delete',
            iconCls:'delete-icon',
            text:'删除',
            handler: function(){
                var selNode = tree.getSelectionModel().getSelectedNode();
            	if(selNode){
	               if(selNode.id=='root'){
	                	Ext.MessageBox.alert("提示","根模块不能删除！");
	                }  
	                else{
	                	var pNode=selNode.parentNode;
	              		var url="dhcwl/kpi/kpimodecfgdata.csp?action=delTreeNode&code="+selNode.id;
	 					
	 					dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
	 						if(jsonData.success==true){
	 							selNode.remove();
	 						}
	 					},this);	
	 					
	                }
                }                
                else Ext.MessageBox.alert("提示","请先选择要删除的模块！");
            },
            scope: this
        },'-',{
            id:'modify',
            iconCls:'delete-icon',
            text:'修改',
            handler: function(){
                var selNode = tree.getSelectionModel().getSelectedNode();
            	if(selNode){
	               if(selNode.id=='root'){
	                	Ext.MessageBox.alert("提示","根模块不能修改！");
	                }  
	                else{
	                	var form=formPanel.getForm();
	                	var fields=form.items;
	                	fields.each(function(field) { 
	                		if(field.getId()=="formModecfgCode") {
	                		field.hide();
	                		field.label.hide();
	                		}
						})
	                	formPanel.ownerCt.setHeight(100);
	                }
                }                
                else Ext.MessageBox.alert("提示","请先选择要删除的模块！");
            },
            scope: this
        },'-',{
            id:'export',
            iconCls:'export-icon',
            text:'导出',
            handler: onExport,
            scope: this
        },'-',{
            id:'import',
            iconCls:'import-icon',
            text:'安装',
            handler: onImport,
            scope: this
        }],
		id:"cfgTreePanel",
		autoScroll : true,
		animate : true,
		enableDD : true,
		containerScroll : true,
		loader : new Ext.tree.TreeLoader( {
		      dataUrl : 'dhcwl/kpi/kpimodecfgdata.csp?action=getTreeNode'// OrgTreeJsonData.action就是要动态载入数据的请求地址，这里请求时会提交一个参数为node的值，值为root即new Tree.AsyncTreeNode()对象的id值
		        })
		 
		        });

		        
		        
		tree.on('checkchange', function(node, checked){
                if(checked){
                	var nodeCode=node.id;
                    node.getUI().addClass('complete');
                }else{
                    node.getUI().removeClass('complete');
                }
            })
            
           
   		tree.on('beforedblclick', function(node,e){
 			var nodeCode=node.id;
			var rptPanel=Ext.ComponentMgr.get('rptCfgGridPanel');
			rptPanel.store.proxy=new Ext.data.HttpProxy({url:"dhcwl/kpi/kpirptcfgdata.csp?action=getNode&PCode='"+nodeCode+"'"}); 
			rptPanel.store.reload();

				return true;
            })          
                  
		var root = new Ext.tree.AsyncTreeNode( {
		      text : '模块管理树',
		draggable : false,
		checked :false,
		id : 'root'//默认的node值：?node=-100
		  });
		tree.setRootNode(root);

		
	
	var modeCfgPanel=new Ext.Panel({
		frame:false,
	items: [{

		collapsible: false,
		id:"modeCfgFormPanel",
		frame:false,
	    margins: '5 0 0 0',
	    cmargins: '5 5 0 0',
	    height:100,
	    minSize: 100,
	    maxSize: 500,
	    items:formPanel			            
	},{
		id:"modeCfgTreePanel",
		autoHeight:true,
		autoScroll:true,
		collapsible: true,
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

 	this.getModeCfgPanel=function(){
		return modeCfgPanel;
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
		
		dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/kpimodecfgdata.csp',
		{action:'ExportModeToXML',codes:nodeIDs},  //getFileContent edited by lhh @20131101
		function(responseText){
			if(responseText){
				dhcwl.mkpi.Util.writeFile(dhcwl.mkpi.Util.nowDateTime()+'outputMode.xml',dhcwl.mkpi.Util.trimLeft(responseText));
			}else{
				Ext.Msg.show({title : '错误',msg : "导出失败！\n" +responseText,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
			}
		}
		,outThis,true);
	}
	
	
		function onImport(btn, ev) {
			var insMode=new dhcwl.mkpi.InsModeData();
			insMode.show();
		
		}
}
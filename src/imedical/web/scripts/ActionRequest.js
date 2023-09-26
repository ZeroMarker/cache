
//debugger;
Ext.QuickTips.init();


    var northPanel = new Ext.FormPanel({
        id:'northPanel',
        labelWidth: 75,
        labelAlign: 'right',
        frame:true,
        //bodyStyle:'padding:5px 5px 0',
        //width: 500,
        //layout:'north',
        items: [{
            xtype:'fieldset',
            title: '基本信息',
            collapsible: true,
            autoHeight:true,
            defaults: {width: 210},
            defaultType: 'textfield',
            items:[{
                id:'requestUser',
                fieldLabel: '申请人',
                name: 'requestUser',
                value:currAuthor
                //allowBlank:false
            },{
                id:'requestDept',
                fieldLabel: '申请科室',
                name: 'requestDept',
                value:userLocDes
            },{
                id:'actionType',
                xtype:'combo',
                fieldLabel: '权限类型',
                name:'actionType',
                hiddenName:'value',
                mode: 'local',
                name: 'email',
                store: new Ext.data.SimpleStore({
                           fields:['value','text'],
                           data:[['view','界面模板浏览'],
                                 ['save','保存'],
                                 ['print','打印'],
                                 ['commit','提交'],
                                 ['switch','选择模板'],
                                 ['switchtemplate','更新模板'],
                                 ['chiefcheck','主任医师签名'],
                                 ['attendingcheck','主治医生签名'],
                                 ['browse','病历浏览']]
                }),
                valueField:'value',
                displayField:'text',
                typeAhead: true,
                mode: 'local',
                triggerAction: 'all',
                emptyText:'请选择一种权限类型...',
                selectOnFocus:true
            }]
        }],
        tbar:['->','-',
		        {id:'btnCommit',name:'btnCommit',text:'提交',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false,handler:commitRequest},
		        '-',
		        {id:'btnCancel',name:'btnCancel',text:'取消',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false,handler:cancelRequest}]
    });
    


//var northPanel = createNorthPanel();


    var Tree = Ext.tree;
    var treeLoader = new Tree.TreeLoader( {dataUrl : "../web.eprajax.actionappointchapter.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&ActionType=0"});
    
    
    
    var tree = new Tree.TreePanel({
		//el:"currentDocs",
		rootVisible: false,
		autoScroll:true,
		trackMouseOver:false,
		//title:'病历范围',
		animate:false,
		containerScroll:true,
		bodyStyle:'padding:5px 5px 0',
		lines:true, 
		checkModel:'cascade',
		//autoHeight:true,
		height:500,
		border:true,
		loader : treeLoader,
		id:"myTree"
		//tbar:treeTbar,
		//bbar:treeBbar
		

	});
	
	var rootNode = new Tree.AsyncTreeNode( {
		text : '请选择病历范围',
		nodeType: 'async',
		draggable : false,
		id : "RT0"
    });	
		
	
    //抛出异常时的处理				
    treeLoader.on("loadexception", function(tree, node, response) {
	    var obj = response.responseText;
	    alert(obj);
    });
    
    tree.setRootNode(rootNode);
    rootNode.expand(true);
    
    tree.on("checkchange", function(node,checked) {
        if (node.leaf)
                {
                    if (!checked)
                    {   
                        //任一子节点未选中，则不选中父节点
                        node.parentNode.attributes.checked = false;
                        node.parentNode.getUI().checkbox.checked = false;
                    }
                    else
                    {
                        //选中所有子节点，则选中父节点
                        var totChecked = true;
                        for ( var i=0; i<node.parentNode.childNodes.length; i++)
                        {
                            if (!node.parentNode.childNodes[i].attributes.checked)
                            {
                                totChecked = false;
                                break;
                            }
                        }
                        node.parentNode.attributes.checked = totChecked;
                        node.parentNode.getUI().checkbox.checked = totChecked;
                    }   
                }
                else
                {
                    //选中父节点，则选中所有子节点
                    for (var i=0; i<node.childNodes.length; i++)
                    {
                        node.childNodes[i].attributes.checked = checked;
                        node.childNodes[i].getUI().checkbox.checked = checked;
                    }
                }  
	});
    

//var requestForm = getFormPanel();

var view = new Ext.Viewport({
	id: 'requestViewPort',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
   	        border:true,
            region:'north',
            height:150,
            //layout:'north',
            split: true,
		    collapsible: true,  
            items:northPanel 
          },{
            border:true,
            region:'center',
            layout:'fit',
            split: true,
		    collapsible: true,  
            items:tree              
    }]
});

SetTextFieldDisable();

 tree.render('tree');
 tree.doLayout();
  
function SetTextFieldDisable()
{
    //设置申请人、申请科室不可改
    var txtUserName = Ext.getCmp('requestUser');
    txtUserName.setDisabled(true);
    var txtUserLocDes = Ext.getCmp('requestDept');
    txtUserLocDes.setDisabled(true);
}

function commitRequest()
{    
    //alert(userID);
    //alert(userLoc);
    //debugger;
    var combo = Ext.getCmp('actionType');
    var action = combo.getValue();
    
    if(action=="")
    {
        Ext.MessageBox.alert('操作提示','请选择一种权限类型再提交申请');
        return;
    }
    
    //debugger;
    var count=0;
    var requestCateCharpter = "";
    for(var i = 0; i<rootNode.childNodes.length; i++)
	{
	    var cgNode = rootNode.childNodes[i];
	    for (var j=0; j<cgNode.childNodes.length; j++)
	    {
	        var ccNode = cgNode.childNodes[j];
	        if (ccNode.leaf && ccNode.attributes.checked)
	        {
	            var cateInfo = ccNode.id.substring(2,ccNode.id.length);
	           if  (requestCateCharpter == "")
	           {    requestCateCharpter = cateInfo; }
	           else
	           {    requestCateCharpter = requestCateCharpter + "^" + cateInfo;}
	        }
	    }
	}
    
    if (requestCateCharpter=="")
    {
    	Ext.MessageBox.alert('操作提示','请选择申请范围');
        return;
    }
    
    //alert(action);
    Ext.Ajax.request({			
		url: '../web.eprajax.EPRAction.cls',
		timeout : 5000,
		params: { Action:"request",EpisodeID:episodeID,RequestCateCharpter:requestCateCharpter,RequestUserID:userID,RequestDept:userLoc,EPRAction:action},
		success: function(response, opts) {
			//alert(response.responseText);
			//debugger;
			if(response.responseText=="1")
			{
			    parent.Ext.getCmp('requestWin').close(this);
			}
			else
			    Ext.MessageBox.alert('操作提示', '申请权限操作提交失败');
		},
		failure: function(response, opts) {
			Ext.MessageBox.alert('提示',response.responseText);
		}
	}); 
}

function cancelRequest()
{
    var win = parent.Ext.getCmp('requestWin');
    win.close(this);
}
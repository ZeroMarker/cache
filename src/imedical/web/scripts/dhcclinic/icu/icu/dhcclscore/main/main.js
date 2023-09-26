function InitViewScreen(){
       
  	    var isSet=false
		var win=top.frames['eprmenu'];
		if (win)
		{
			var frm = win.document.forms['fEPRMENU'];
			if (frm)
			{
				var EpisodeID=frm.EpisodeID.value; 
				isSet=true
			}
		}
		if (isSet==false)
		{
			var frm =dhcsys_getmenuform();
			if (frm) { var EpisodeID=frm.EpisodeID.value;}
		}
	var dateFrom = new Ext.form.DateField({
		id : 'dateFrom'
		,value : new Date()
		,format : 'd/m/Y'
		,fieldLabel : '开始日期'
		,anchor : '95%'
	});
	var dateTo = new Ext.form.DateField({
		id : 'dateTo'
		,value : new Date()
		,format : 'd/m/Y'
		,fieldLabel : '结束日期'
		,anchor : '95%'
	});
	var panel1 = new Ext.Panel({
		id : 'panel1'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth:58
		,layout : 'form'
		,items:[
			dateFrom
			,dateTo
		]
	});
	var txtRegNo = new Ext.form.TextField({
		id : 'txtRegNo'
		,fieldLabel : '登记号'
		,anchor : '95%'
	    });
    var txtName = new Ext.form.TextField({
		id : 'txtName'
		,fieldLabel : '姓名'
		,anchor : '95%'
	    });
	var txtSex=new Ext.form.TextField({
		id : 'txtSex'
		,fieldLabel : '性别'
		,anchor : '95%'
	    });
	var txtBed=new Ext.form.TextField({
		id : 'txtBed'
		,fieldLabel : '床位'
		,anchor : '95%'
	    });
	var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');
	var ret=_DHCANOPCom.PatInfo('^'+EpisodeID)
	patInfo=ret.split("^")
	if(patInfo[11]=="") alert("该病人未指定医生!");
	txtRegNo.setValue(patInfo[0])
	txtName.setValue(patInfo[4])
	txtSex.setValue(patInfo[3])
	txtBed.setValue(patInfo[6])
	//alert(patInfo[11]+"/"+patInfo[4]+"/"+patInfo[3]+"/"+patInfo[6])
	var panel2 = new Ext.Panel({
		id : 'panel2'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth:55
		,layout : 'form'
		,items:[
		txtRegNo,
		txtName
		]
	});
	var panel3 = new Ext.Panel({
		id : 'panel3'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth:55
		,layout : 'form'
		,items:[
		txtSex,
		txtBed
		]
	});
	
    var panel4=new Ext.Panel({
		id : 'panel4'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth:55
		,layout : 'form'
		,items:[
		]
	});
	var btnSch = new Ext.Button({
		id : 'btnSch'
		,iconCls : ''
		,text : '查询'
		,handler:function()
		{
		 var root=tree.root
		 var loader=tree.getLoader();
		 var param={
	       adm:EpisodeID
	      ,dateFrom:dateFrom.getValue().format('Y/m/d')
	      ,dateTo:dateTo.getValue().format('Y/m/d')
	         }
		 loader.baseParams=param	 
		 loader.load(root,function(){
         tree.expandAll();//重新加载后展开根节点
         });//
		}
	});
		// tree.expandAll()
	var panel5=new Ext.Panel({
		id : 'panel5'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth:55
		,layout : 'form'
		,buttons:[
	     btnSch
		]
	});
	var btnNewScore = new Ext.Button({
		id : 'btnNewScore'
		,iconCls : ''
		,text : '新建评分'
		,handler:function()
		{
		  var sm = tree.getSelectionModel();//取得树的选择模式对象
          var node = sm.getSelectedNode();//取得当前选中的节点
		  if(node==null)
		  {
		    alert("没有选中节点!") 
		  }
		  else 
		  {
		    if(node.isLeaf()) return; 
		    var _DHCCLScore=ExtTool.StaticServerObject('web.DHCCLScore');
			var ret=_DHCCLScore.InsertScore(EpisodeID,node.id)
			var retArr=ret.split("^")
			if(retArr[0]!=0) alert(retArr[1]);
			else
			{
			var addNodeId=node.id+"||"+retArr[1]
			
			
			var path=node.getPath('id');
            tree.root.reload();
			tree.expandPath(path,"id",function(sucess,lastNode)
			{
			  var addNode=tree.getNodeById(addNodeId)
			  tree.getSelectionModel().select(addNode);	
              addtab(addNode);			  
			});
			}
		  }
		}
    });
	var panel6=new Ext.Panel({
		id : 'panel6'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth:55
		,layout : 'form'
		,buttons:[
	     btnNewScore
		]
	});
	var btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : ''
		,text : '删除评分'
		,handler:function()
		{
		  var sm = tree.getSelectionModel();//取得树的选择模式对象
          var node = sm.getSelectedNode();//取得当前选中的节点
		  if(node==null)
		  {
		    alert("没有选中节点!") 
		  }
		  else 
		  {
		    if(!node.isLeaf()) return; 
		    var _DHCCLScore=ExtTool.StaticServerObject('web.DHCCLScore');
			var ret=_DHCCLScore.DeleteScore(node.id)
			if(ret!=0)alert(ret)
			else
			{
			 var tabs=Ext.getCmp('main-tabs');
             var tabId = "tab_"+node.id;
             var obj = Ext.getCmp(tabId);
			 tabs.remove(obj)
			 var path=node.parentNode.getPath('id');
             tree.root.reload();
			 tree.expandPath(path,"id",function(sucess,lastNode)
			 {
			 });
			}
		  }
		}
    });
	var panel7=new Ext.Panel({
		id : 'panel7'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth:55
		,layout : 'form'
		,buttons:[
	     btnDelete
		]
	});
	var baseInfoPanel=new Ext.Panel({
	id:'baseInfoPanel',
	region:'center',
	//autoScroll:true,
	//split:true,
	layout:'column',
	height:55,
	border:true,
	items:[
	panel1,
	panel2,
	panel3,
	panel4,
	panel5,
	panel6,
	panel7
	]
	})
	var northPanel=new Ext.Panel({
	id:'northPanel',
	region:'north',
	title:"基本信息",
	autoScroll:true,
	//split:true,
	layout:'border',
	frame:true,
	height:85,
	border:true,
	items:[
	baseInfoPanel
	//,gridPannel
	]
	})
	var tree = new Ext.tree.TreePanel({
    border:false,
    animate:true,
    enableDD:false,
    containerScroll:true,
    loader: new Ext.tree.TreeLoader({
	dataUrl:"dhcclinic.icu.dhcclscore.treeloader.csp",
	baseParams:{
	 adm:EpisodeID
	 ,dateFrom:dateFrom.getValue().format('Y/m/d')
	 ,dateTo:dateTo.getValue().format('Y/m/d')
	}
	}),
    rootVisible:false,
    lines:true,
    autoScroll:true,
	root: new Ext.tree.AsyncTreeNode({
	id:'root',
	text: 'Project',
    expanded:true }),
	listeners:{
	"click":function(node,event)
	{
		addtab(node);
    }
	}
	});
	var addtab = function(node){
    if (!node.isLeaf()) return;
	var menuId=node.id
    var tabs=Ext.getCmp('main-tabs');
    var tabId = "tab_"+node.id;
    var obj = Ext.getCmp(tabId);
    if (obj){}
    else{
    	  var strURL="dhcclinic.icu.dhcclscore.custum.csp?&menuId="+menuId;
    	  obj=tabs.add({
    	  id:tabId,
          title:node.text,
          tabTip:node.text,
          html:"<iframe height='100%' width='100%' src='" + strURL + "'/>",
          closable:true
      		 })
    	}
    	obj.show();
    };
   var scorePanel = new Ext.Panel({
	title:"评分分类",
	autoScroll:true,
	collapsed:false,
	//icon:"../Scripts/dhcmed/main/pro.gif",
	items:[tree]
	});
    var westPanel = new Ext.Panel({
	id:'westpanel',
    region:"west",
    title:"",
    autoScroll:true,
    		split:true,
    		collapsible:true,   //自动收缩按钮 
    		border:true,
    		width:220,
    		minSize: 220,
		    maxSize: 300,
		//margins:'0 0 5 5',
		//cmargins:'0 5 5 5',
		//lines:false,
    		layout:"accordion",
    		//extraCls:"roomtypegridbbar",
		    //iconCls:'icon-feed', 
     		//添加动画效果
    		layoutConfig: {animate: true},
    		items:[scorePanel]
	});
	var centerTab =  new Ext.TabPanel({
    id:'main-tabs',
    activeTab:0,
    region:'center',
    enableTabScroll:true,
    resizeTabs: true,
    tabWidth:130,
    minTabWidth:120,
    //margins:'0 5 5 0',
    resizeTabs:true,
    tabWidth:150,
    items:[ 
	        //{
            // title:"Home",
			 //html:"Welcome"
			// html : '<iframe id="searchTreeIframe_id" src="dhcmed.ss.welcomepage.csp" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'
            // }
		  ]
	});
	var centerPanel =  new Ext.Panel({
    id:'centerPanel',
    region:'center',
    //margins:'0 5 5 0',
	layout:'border',
    items:[
	//northPanel,
	centerTab
          ]
	});

  var viewport = new Ext.Viewport({
  layout:'border',
  items:[
         northPanel,
         westPanel,
         centerTab]
    	});
  //InitViewScreenEvent(obj);		
  //obj.LoadEvent(arguments);
  //return obj;
}
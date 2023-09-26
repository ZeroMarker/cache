/*
 * Ext JS Library 3.1.0
 * Copyright(c) 2009-2010 DHCC
 */

Ext.onReady(function(){

	Ext.QuickTips.init();
	var Document = ExtTool.StaticServerObject("web.PMP.Document");
	var IndependentUserRet=Document.IndependentUser();
	var groupId =session['LOGON.GROUPID'];
	var UserId=session['LOGON.USERID'];
	if (IndependentUserRet=="Y"){
	 var IndependentType=Document.IndependentType(UserId);
	 var CommonUserRet=Document.CommonUser();
	 if (CommonUserRet==""){
	 Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请在“功能配置”中维护公共his帐号，类型编码为“CommonUser”！',
			  minWidth : 200,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	 };
	};
	var NewUserStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=NewUserStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	NewUserStore.load();
	var NewPassWord = new Ext.form.TextField({
		id : 'NewPassWord'
		,width : 60
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '个人密码'
		,inputType: 'password'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
		,listeners:{specialkey:function(textfield,e){
         if(e.getKey() == Ext.EventObject.ENTER){
		 NewUserAddClick();
		    }
		   }
		 }
	});
	var NewUserName= new Ext.form.ComboBox({
		id : 'NewUserName'
		,width : 60
		,minChars : 1
		,store:NewUserStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '功能用户'
		,valueNotFoundText : ''
		,editable : true
		//,disabled:true
		,triggerAction : 'all'
		,listeners:{
        	beforequery : function(e){
            	var combo = e.combo;
                if(!e.forceAll){
                	var value = e.query;
                	combo.store.filterBy(function(record,id){
                		var text = record.get(combo.displayField);
                		return (text.indexOf(value)!=-1);
                	});
                	combo.expand();
                	return false;
                }
        	}
		   ,select:function(cmb,rec,id){
		   //alert("2");
		   //NewPassWord.disabled=true;
		   }
        }
		,anchor : '99%'
	});
	var NewUserAdd = new Ext.Button({
		id : 'NewUserAdd'
		,iconCls : 'icon-add'
		,text : '保存'
		,listeners:{
		    "click":function(node,event)
			{
		     NewUserAddClick();
			 }
		}
	});
	var NewUserDelete = new Ext.Button({
		id : 'NewUserDelete'
		,iconCls : 'icon-delete'
		,text : '取消'
		,hidden:true
		,listeners:{
		    "click":function(node,event)
			{
		     NewUserDeleteClick();
			 }
		}
	});
	var menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 130
		,buttonAlign : 'center'
		,width : 250
		,modal : true
		,title : '选择身份'
		,layout : 'form'
		,margins:'0 0 5 5'
		,cmargins:'0 5 5 5'
		,labelWidth:60
		,border:true
		,closable: false
		,items:[NewUserName,NewPassWord]
		,buttons:[NewUserAdd,NewUserDelete]
	});
	var westpanel = new Ext.Panel({
		id:'westpanel',
		region:"west",
		title:"东华软件项目质量管理系统",
		autoScroll:false,
		split:true,
		collapsible:true,   //自动收缩按钮 
		border:true,
		width:220,
		minSize: 100,
		maxSize: 300,
		//margins:'0 0 5 5',
		//cmargins:'0 5 5 5',
		//lines:false,
		layout:"accordion",
		//extraCls:"roomtypegridbbar",
		//iconCls:'icon-Add', 
		//添加动画效果
		layoutConfig: {animate: true},
		items:[]
	});
	
	var objMainService = ExtTool.StaticServerObject("DHCPM.SSService.Main");
	var sProducts = objMainService.GeProductsByGroup(groupId);
	var arryTmp = sProducts.split("<$C1>");
		for(var intRow = 0; intRow < arryTmp.length; intRow ++)
		{
			 var product = arryTmp[intRow];
			 if(product == "") continue;
			 /*
			 var arryField = product.split("<$C2>");
			 var pId = arryField[0];
			 var pName = arryField[1];
			 */
			 var arryField = product.split("^");
			 var pId = arryField[0];
			 var pName = arryField[1];
			 var IconClass = arryField[2]
			 var ProVersion = arryField[3];
			 var tree = new Ext.tree.TreePanel({
    						border:false,
    						animate:true,
    						enableDD:false,
    						containerScroll:true,
		                loader: new Ext.tree.TreeLoader({dataUrl:"dhcpm.main.loadmeus.csp?groupId="+groupId+"&parentId=0&proId="+pId}),
		                rootVisible:false,
		                lines:false,
		                autoScroll:true,
		                root: new Ext.tree.AsyncTreeNode({
		                          text: 'Project',
		                          expanded:true
		                }),
		                listeners:{
		                	"click":function(node,event)
		        						{
		        							addtab(node);
		        							}
		                }
			});
       			
			var proPanel = new Ext.Panel({
	    			title:pName+" "+ProVersion,
	    			autoScroll:true,
	    			collapsed:true,
	    			iconCls:IconClass,  //"icon-pro",
	    			//icon:"../Scripts/dhcmed/main/pro.gif",
	    			items:tree
	    		});
	    		westpanel.add(proPanel);
		}
		
    var addtab = function(node){
    	if (!node.isLeaf()) return;
    	var tabs=Ext.getCmp('main-tabs');
    	var tabId = "tab_"+node.id;
    	var obj = Ext.getCmp(tabId);
    	if (obj){}
    	else{
    		//var objMainService = ExtTool.StaticServerObject("MainService");
    	    var strURL=objMainService.GetMenuLinkUrl(node.id);
    	    if (strURL!="") strURL=strURL+"&menuId="+node.id;
    	    obj=tabs.add({
    	    	  id:tabId,
            	title:node.text,
            	tabTip:node.text,
            	html:"<iframe height='100%' width='100%' src='" + strURL + "'/>",
            	closable:true
      		 })
    	}
    	obj.show();
    	//westpanel.collapse(true);    //add by wuqk 2012-05-17
    };
         
	var centertab =  new Ext.TabPanel({
		id:'main-tabs',
		activeTab:0,
		region:'center',
		enableTabScroll:true,
		resizeTabs: true,
		tabWidth:130,
		minTabWidth:120,
		//margins:'0 5 5 0',
		resizeTabs:true,
		//tabWidth:150
		items:[{
			title:"Home",
			//html:"Welcome"   dhcmed.ss.welcomepage.csp -> dhcmed.ss.portal.csp
			html : '<iframe id="searchTreeIframe_id" src="dhcpm.main.home.csp" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'
		}]
	});
    if (IndependentType=="Y"){
	  menuwind.show();
	  var viewport = new Ext.Viewport({
        	layout:'border',
			title:'项目质量管理系统',
        	items:[westpanel,centertab]
    	});  
	}
	else{
	var viewport = new Ext.Viewport({
        	layout:'border',
			title:'项目质量管理系统',
        	items:[westpanel,centertab]
    	});  
	};
  var NewUserDeleteClick=function (){
    menuwind.close();
  }
  var NewUserAddClick=function(){
  var NewUserNameValue=NewUserName.getValue();
  var NewPassWordValue=NewPassWord.getValue();
  if (NewUserNameValue==""){
  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择身份！',
			  minWidth : 200,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
  };
  var NewPassWordTypeRet=Document.NewPassWordType(NewPassWordValue,NewUserNameValue);
  if (NewPassWordValue!="1"){
  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '密码错误！',
			  minWidth : 200,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
  };
  NewPassWord.setValue('');
  var InertNewUserRet=Document.InertNewUser(NewUserNameValue,getIpAddress());
  if (InertNewUserRet=="1"){
    menuwind.close();
  }
  else{
  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '操作失败，请联系管理员！错误代码：'+InertNewUserRet,
			  minWidth : 200,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
  }
  
  }
});
/* var add=function(tab){
  	//Ext.Msg.alert("",str);
  	//centertab.setTitle(str);
		var strURL=""  //"dhcmed.portletdefalut.csp?id="+tab.id;
		//var html='<iframe src="dhcmed.ss.portal.csp"'+strURL+' width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>';  	
  	var tabPage = Ext.getCmp("main-tabs").add({//动态添加tab页
  					id:"tab_"+tab.id,    
            title:tab.title,
            tabTip:tab.title,    
            html:"<iframe src='"+strURL+"' height='100%' width='100%'></iframe>",  //'test tabs',    
            closable:true//允许关闭    
        });  
    // tabPage.show();   
        Ext.getCmp("main-tabs").setActiveTab(tabPage);//设置当前tab页 
  	//Ext.getCmp("main-tabs").add({contentEl:'tab3', title:'Tab 3'});
  	//Ext.getCmp("main-tabs").setTitle(str+"MIX");
  	//Ext.Msg.alert("",Ext.getCmp("main-tabs").title);
  	
}; */
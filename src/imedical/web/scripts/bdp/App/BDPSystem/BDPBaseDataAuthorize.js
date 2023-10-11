/**
 * @Title: 数据授权
 * @Author: 蔡昊哲 DHC-BDP
 * @Description:用于数据授权，包含登录科室授权和安全组授权
 * @Created on 2013-5-8
 */
 
var treePanel;

var GetGroupTree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.BaseData&pClassMethod=GetGroupTreeJson";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.BaseData&pClassMethod=SaveAuthorizeBaseDataJson";
var GetLogonLocTree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.BaseData&pClassMethod=GetLogonLocTreeJson1";

	var Tree=Ext.tree;
	/** 安全组授权面板 */
	var groupTreeLoader = new Tree.TreeLoader({
		nodeParameter: "ParentID",
		dataUrl: GetGroupTree_ACTION_URL
	});
	var groupPanel = {
		title: '用户维护可分配安全组授权',
		region: 'center',
		iconCls : 'icon-Book',
		xtype:'treepanel',
		id: 'groupConfigTreePanel',
		expanded:true,
		root: new Tree.AsyncTreeNode({
				id:"groupTreeRoot",
				text:"菜单",
				draggable:false,  //可拖拽的
				expanded:true  //根节点自动展开
			}),
		loader: groupTreeLoader,
		autoScroll: true,
		containerScroll: true,
		rootVisible:true,
		tbar:[{ text:'保存',
			icon:Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
			handler:function() {
			if(ObjectReference==""){
				Ext.Msg.alert("提示","没有选中安全组!");
				return ;							
			}
			str = "";
			var f  = function(node) {
				var flag = this.attributes.checked;
				if(flag==true) {
					if (str!="") str=str+",{";
					else str=str+"{";
					str=str+"ID:"+node.id+"}"
				}
			}					
			Ext.getCmp("groupConfigTreePanel").getRootNode().cascade(f); //在所有childnode上做f
			if(str!="") str="["+str+"]";
			Ext.Ajax.request({
				url: SAVE_ACTION_URL,
				params: {ObjectType:ObjectType, ObjectReference:ObjectReference, Data:str,SubKey:"Group"},
				success: function(resp,option){
							var rtn = resp.responseText.replace(/\r\n/g,"");
							try{var obj = Ext.decode(rtn);}catch(e){alert("操作失败!");return ;}
							if (obj.msg == "0") {
								Ext.Msg.show({
									title : '提示',
									msg : '保存成功!',
									minWidth : 150,
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK
								});
							}else {
								Ext.Msg.show({
									title : '提示',
									msg : '保存失败!<br>代码:' + obj.msg,
									minWidth : 150,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
							}
						},
				failure: function(response, opts) {
							console.log('server-side failure with status code ' + response.status);
						},
				scope : this
			});
			}
		}]
	}
	
		/** 获取菜单面板 */
	function getGroupPanel(){
		return groupPanel;
	};
	
	
	/** 登录科室授权面板 */
	
	Ext.tree.TreeLoaderStore = Ext.extend(Ext.data.Store,{  
    /** 
     * 加载数据源的数据对象，是树结构的loader 
     * @type  Ext.tree.TreePagingLoader 
     */  
    loader:null,  
    /** 
     * 树的根节点，最顶的节点 
     * @type Ext.tree.AsyncTreeNode 
     */  
    rootNode:null,  
    constructor : function(config){  
        Ext.tree.TreeLoaderStore.superclass.constructor.call(this);  
        this.loader = config.loader;  
        this.rootNode = config.rootNode;  
     },  
     load:function(options){  
        var _self = this;  
        if(!this.loader || !this.rootNode){  
            Ext.MessageBox.alert("错误","必须指定loader或者rootNode");  
            return false;  
        }  
        Ext.apply(this.loader.baseParams,{start:options.params.start,limit:options.params.limit}),  
        this.loader.load(this.rootNode,function(node){  
            _self.currentCount = _self.loader.currentCount;  
            _self.totalLength = _self.loader.totalCount;  
            node.expand();  
            _self.fireEvent("load",_self,null,options);  
            delete _self;  
        });  
        return true;  
     },  
     getCount : function(){  
        return this.currentCount || 0;  
     },  
     getTotalCount : function(){  
        return this.totalLength || 0;  
    }  
})  
  
Ext.tree.TreePagingLoader = Ext.extend(Ext.tree.TreeLoader,{  
    processResponse : function(response, node, callback, scope){  
        var json = response.responseText;  
        try {  
            var o = response.responseData || Ext.decode(json);  
            //TODO:暂时从后台获取当前页的记录数，通过currentCount属性获取  
            //最佳做法是效仿pagingToolbar的做法，在客户端获取  
            //目前的障碍是，loader还没读取完，翻页的工具栏已经初始化了，导致当前页记录数无法获取  
            //有空再继续修改，思路是把loader当store来用  
            this.totalCount = o.totalCount;  
            this.currentCount = o.data.length;  
            var o = o.data;  
            node.beginUpdate();  
            for(var i = 0, len = o.length; i < len; i++){  
                var n = this.createNode(o[i]);  
                if(n){  
                    node.appendChild(n);  
                }  
            }  
            node.endUpdate();  
            this.runCallback(callback, scope || node, [node]);  
        }catch(e){  
            this.handleFailure(response);  
        }  
    }  
})  

var root = new Ext.tree.AsyncTreeNode({ 
			 id:"LogonLocTreeRoot",
             text: '菜单',   
             expanded :true,  
             draggable:false     
             //id:"1" 
             
             });  
             
    var LogonLocTreeLoader = new Ext.tree.TreePagingLoader({     
       dataUrl:GetLogonLocTree_ACTION_URL ,  
       listeners : {     
          'click' : function(loader,node) {   
               alert(node.href);  
               this.baseParams.type = node.id;   
            }  
       }  
   })  ;  
    var store = new Ext.tree.TreeLoaderStore({  
        rootNode:root,  
        loader:LogonLocTreeLoader  
    });  
    var bbar = new Ext.PagingToolbar({  
        pageSize: 25,  
        store: store,  
        displayInfo: true,  
        displayMsg: '显示第 {0} - {1}条记录 共{2}条记录',  
        //displaySize:'5|10|15|20|all',  
        emptyMsg: "无记录"  
    });  
    
    var LogonLocPanel = new Ext.tree.TreePanel({
    	title: '用户维护可分配登录科室授权',
		region: 'center',
		iconCls : 'icon-LoginLoc',
		xtype:'treepanel',
		id: 'LogonLocConfigTreePanel', 
        autoScroll:true,     
        animate:true,     
        enableDD:true,     
        containerScroll: true,   
        bbar:bbar,  
        root:root,  
        loader:LogonLocTreeLoader,
        tbar:[{ text:'保存',
			icon:Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
			handler:function() {
			if(ObjectReference==""){
				Ext.Msg.alert("提示","没有选中安全组!");
				return ;							
			}
			str = "";
			var Cid=""
			var arr=[];
			var arrTrue=[];
			var AutJson="";
			var arrResult=[];
						
			var count=0;
			var f  = function(node) {
				arr[count] = node.id;
				count=count+1;
				var flag = this.attributes.checked;
				if(flag==true) {
					if (str!="") str=str+",{";
					else str=str+"{";
					str=str+"ID:"+node.id+"}"
				}
			}
			Ext.getCmp("LogonLocConfigTreePanel").getRootNode().cascade(f);
			
			AutJson = tkMakeServerCall("web.DHCBL.Authorize.BaseData","AutJson",ObjectType,ObjectReference,"LogonLoc");
			if(AutJson!=""){
					arrTrue = Ext.decode(AutJson);	
					var flag;
					for (var i=0;i<arrTrue.length;i++){
						for (var j=0;j<arr.length;j++){
								if (arrTrue[i].ID==arr[j])
							{
								flag = 1;
								break;								
							}							
						}	
						if (flag!=1)
							{
								if (str!="") str=str+",{";
								else str=str+"{";
								str=str+"ID:"+arrTrue[i].ID+"}";
							}	
					}			
			}

			 //在所有childnode上做f
			if(str!="") str="["+str+"]";
			Ext.Ajax.request({
				url: SAVE_ACTION_URL,
				params: {ObjectType:ObjectType, ObjectReference:ObjectReference, Data:str,SubKey:"LogonLoc"},
				success: function(resp,option){
							var rtn = resp.responseText.replace(/\r\n/g,"");
							try{var obj = Ext.decode(rtn);}catch(e){alert("操作失败!");return ;}
							if (obj.msg == "0") {
								Ext.Msg.show({
									title : '提示',
									msg : '保存成功!',
									minWidth : 150,
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK
								});
							}else {
								Ext.Msg.show({
									title : '提示',
									msg : '保存失败!<br>代码:' + obj.msg,
									minWidth : 150,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
							}
						},
				failure: function(response, opts) {
							console.log('server-side failure with status code ' + response.status);
						},
				scope : this
			});
			}
		}]
    });     
    //store.load({params:{start:0,limit:25}});  
	
		/** 获取菜单面板 */
	function getLogonLocPanel(){
		return LogonLocPanel;
	};

	var DBtb =  new Ext.TabPanel({
				title:"数据授权",
                id:'BaseDataTB',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:220,
                //margins:'0 5 5 0',
                resizeTabs:true,
                //tabWidth:150
                items:[LogonLocPanel,groupPanel]
		});


function getMeunPanel(){
	return getMeunPanel;
}
//Ext.onReady(init);
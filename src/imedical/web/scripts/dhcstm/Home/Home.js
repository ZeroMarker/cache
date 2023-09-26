
Ext.onReady(function(){
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.QuickTips.init();
	var path="../scripts/dhcstm/Video/"
	var postfix=".mp4"
	var allpath=path+"视频名字"+postfix
	var flashvars={
		f:allpath,
		c:0,
		b:1
		};
	var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
	/*
	下面是调用html5播放器用到的
	*/
	//var video=[allpath];
	var support=['all'];
	
	var westpanel = new Ext.Panel({
			id:'westpanel',
			region:"center",
			cls:'loginbgimage',//设置页面背景的CSS
			baseCls : 'ex-panel',//设置透明FORM 嵌入页面
			//title:'视频',
			html:'<div id="player"></div>  <div style="text-align: center; padding:40px"> <img  src="../scripts/dhcstm/ExtUX/images/lct.png"/><div style="font-size:40px">总体业务流程图</div></div>'
		
		});
	var GridProxy= new Ext.data.HttpProxy({
		url:'dhcstm.videoaction.csp?actiontype=Query'
		});
	var GridDs = new Ext.data.GroupingStore({
    	proxy:GridProxy,
		//sortInfo:{field: 'App', direction: 'ASC'},
	 	//groupOnSort: true,
    	remoteSort:true,
		groupField:'App',
    	reader:new Ext.data.JsonReader({
		idProperty:'Rowid',
        root:'rows',
        totalProperty:'results'
    }, [
	    {name:'Rowid'}, 
        {name:'App'},
        {name:'Name'}
    	])
	});
	var GridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
	 {
        header:"Rowid",
        dataIndex:'Rowid',
		hidden:true,
        align:'left',
        sortable:true
    },
     {
        header:"模块",
        dataIndex:'App',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"视频名称",
        dataIndex:'Name',
        width:100,
        align:'left',
        sortable:true
    }])
    //表格
	var Grid = new Ext.grid.EditorGridPanel({
	title:'学习视频列表',
	id:'Grid',
    store:GridDs,
    cm:GridCm,
    trackMouseOver:true,
    //region:'center',
    region:'east',
    width:180,
    stripeRows:true,
	view: new Ext.grid.GroupingView({
        forceFit: true,
		headersDisabled :true,
		hideGroupedColumn :true,
        groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "条" : "条"]})'
    }),
    sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
    loadMask:true,
    listeners:{
   	 rowdblclick:function (Grid,rowIndex,e){
   		 var name=GridDs.getAt(rowIndex).get("Name")
   		 var allpath=path+name+postfix
		 flashvars.f=allpath
	     //CKobject.embedSWF('../scripts/dhcstm/ExtUX/ckplayer/ckplayer.swf','player','dhcstmplayer','900',h,flashvars,params);
	     ///html5
	     var video=[allpath];
	     
	     //CKobject.embedHTML5('player','dhcstmplayer',900,h,video,flashvars,support);
	     //CKobject.embed('ckplayer.swf地址[必需]','视频所在容器的ID[必需]','播放器的ID[必需]','宽度[必需，支持具体值以及百分比]','高度[必需，支持具体值以及百分比]]',平台优先选项[false=优先使用flashplayer，true=优先使用h5的video],初始化参数[必需],移动端所使用的地址数组[必需],其它配置[非必需，主要针对flashplayer的配置]);
	     CKobject.embed('../scripts/dhcstm/ExtUX/ckplayer/ckplayer.swf','player','dhcstmplayer','100%','100%',true,flashvars,video,params);
   	 	}
   	 
    }
});


	/** 布局 */
	var viewport = new Ext.Viewport({
			id:'viewport',
        	layout:'border',
        	items:[westpanel,Grid] 
        	
    	});
    GridDs.load()
    //CKobject.embedSWF(播放器路径,容器id,播放器id/name,播放器宽,播放器高,flashvars的值,其它定义也可省略);
    //CKobject.embedSWF('../scripts/dhcstm/ExtUX/ckplayer/ckplayer.swf','player','dhcstmplayer','900',h,flashvars,params);
  	//CKobject.embedHTML5('player','dhcstmplayer',900,h,video,flashvars,support);
});
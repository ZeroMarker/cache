
Ext.onReady(function(){
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.QuickTips.init();
	var path="../scripts/dhcstm/Video/"
	var postfix=".mp4"
	var allpath=path+"��Ƶ����"+postfix
	var flashvars={
		f:allpath,
		c:0,
		b:1
		};
	var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
	/*
	�����ǵ���html5�������õ���
	*/
	//var video=[allpath];
	var support=['all'];
	
	var westpanel = new Ext.Panel({
			id:'westpanel',
			region:"center",
			cls:'loginbgimage',//����ҳ�汳����CSS
			baseCls : 'ex-panel',//����͸��FORM Ƕ��ҳ��
			//title:'��Ƶ',
			html:'<div id="player"></div>  <div style="text-align: center; padding:40px"> <img  src="../scripts/dhcstm/ExtUX/images/lct.png"/><div style="font-size:40px">����ҵ������ͼ</div></div>'
		
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
        header:"ģ��",
        dataIndex:'App',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"��Ƶ����",
        dataIndex:'Name',
        width:100,
        align:'left',
        sortable:true
    }])
    //���
	var Grid = new Ext.grid.EditorGridPanel({
	title:'ѧϰ��Ƶ�б�',
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
        groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "��" : "��"]})'
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
	     //CKobject.embed('ckplayer.swf��ַ[����]','��Ƶ����������ID[����]','��������ID[����]','���[���裬֧�־���ֵ�Լ��ٷֱ�]','�߶�[���裬֧�־���ֵ�Լ��ٷֱ�]]',ƽ̨����ѡ��[false=����ʹ��flashplayer��true=����ʹ��h5��video],��ʼ������[����],�ƶ�����ʹ�õĵ�ַ����[����],��������[�Ǳ��裬��Ҫ���flashplayer������]);
	     CKobject.embed('../scripts/dhcstm/ExtUX/ckplayer/ckplayer.swf','player','dhcstmplayer','100%','100%',true,flashvars,video,params);
   	 	}
   	 
    }
});


	/** ���� */
	var viewport = new Ext.Viewport({
			id:'viewport',
        	layout:'border',
        	items:[westpanel,Grid] 
        	
    	});
    GridDs.load()
    //CKobject.embedSWF(������·��,����id,������id/name,��������,��������,flashvars��ֵ,��������Ҳ��ʡ��);
    //CKobject.embedSWF('../scripts/dhcstm/ExtUX/ckplayer/ckplayer.swf','player','dhcstmplayer','900',h,flashvars,params);
  	//CKobject.embedHTML5('player','dhcstmplayer',900,h,video,flashvars,support);
});
//GR0033 extjs 图片上传
//图片预览模态窗口布局代码
//关联csp：dhceq.process.pictureview.csp
//=========================子窗口=============================

//图片预览窗口
	var PictureData=window.dialogArguments.PictureData
	var PiclistData=window.dialogArguments.PiclistData
	var PictureDR=PictureData.TRowID
	var TSourceType=PictureData.TSourceType
	//==========================================控件=====================================
 	var PicViewWinImage = new Ext.BoxComponent({
	 	autoEl: {  
        	tag: 'img'}
		//width : 800,  
		//height : 600
		//src:'ftp://windows%5cadmin:admin@192.168.109.129/TestFtp/DHCEQPicture/176.bmp'  
	})
       
	var PicViewWinDownload = new Ext.Toolbar.Button({
	text:'下载',
    tooltip:'下载',
	width : 70,
	height : 30,
	hidden:true,
	handler:function(){
		//saveAs(PicViewWinImage.getEl().dom.src,"new.jpg")
		//PicViewWinImage.el.dom.document.execCommand("SaveAs");同一页面只维护一个document对象，所以此方法不可行
		//var fso = new ActiveXObject("Scripting.FileSystemObject");无法创建服务器对象
		
		var imgURL=PicViewWinImage.getEl().dom.src
		var oPop = window.open(imgURL);
		Ext.Msg.hide()
	}
	});
	var PicViewWinGridProxy= new Ext.data.HttpProxy({url:'dhceq.jquery.csp?ClassName=web.DHCEQ.Process.DHCEQPictureList&QueryName=GetPictureList',method:'POST'});
	var PicViewWinStore = new Ext.data.Store({
	proxy:PicViewWinGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'total',
        pageSize:1
    }, [
		{name:'TRowID'},
		{name:'TPicName'},
		{name:'TPicListSort', type: 'int'},
		{name:'TSuffix'},
		{name:'TDefaultFlag'},
		{name:'TFtpStreamSrc'}
	]),sortInfo : {
        field : 'TPicListSort', // 指定要排序的列索引
        direction : 'ASC' // DESC降序，  ASC：赠序
    }
    ,remoteSort:false//远程排序与否
	});

	
	var PicViewWinPagingToolbar = new Ext.PagingToolbar({
    store:PicViewWinStore,
	pageSize:1,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		if (undefined!=this.store.getAt(C))
		{
		var TRowID=this.store.getAt(C).get("TRowID")
		GetImage(C)
		}
		//this.getPageData().activePage=2 无效
		//this.store.currentPage=C	4.0才能用
		//this.inputItem.setValue(2)	只能修改显示页码值，无法实现跳页等按钮灰化
		//this.store.setBaseParam("start",C)	不load无法生效
		//this.store.lastOptions.params.start=C 无效
		this.cursor = C;
		//数据源本地化，取代onload event
        var d = this.getPageData(), ap = d.activePage, ps = d.pages;
        this.afterTextItem.setText(String.format(this.afterPageText, d.pages));
        this.inputItem.setValue(ap);
        this.first.setDisabled(ap == 1);
        this.prev.setDisabled(ap == 1);
        this.next.setDisabled(ap == ps);
        this.last.setDisabled(ap == ps);
        this.refresh.enable();
        this.updateInfo();
	}, // private
    updateInfo : function(){
        if(this.displayItem){
            var count = this.store.getCount();
            //var count =this.store.getCount()>this.pageSize?this.pageSize:this.store.getCount()
            var msg = count == 0 ?
                this.emptyMsg :
                String.format(
                    this.displayMsg,
                    //this.cursor+1, this.cursor+((count>this.pageSize)?this.pageSize:count), this.store.getTotalCount()>this.pageSize?this.pageSize:this.store.getTotalCount()
                    this.cursor+1, this.cursor+((count>this.pageSize)?this.pageSize:count), this.store.getTotalCount()
                );
            this.displayItem.setText(msg);
        }}
});
//============================面板==========================
	
	//========================窗体========================

	//==============================功能函数==================================
	function GetImage(C){
	var TSuffix=PicViewWinStore.getAt(C).get("TSuffix")
	if(TSuffix=="") 
		{Msg.info("error","图片尚未上传，无法预览!");
		PicViewWinImage.setHeight("")
		PicViewWinImage.setWidth("")
		PicViewWinImage.getEl().dom.src="blank.gif"
		PicViewWinDownload.setDisabled(true)
		return
		}
	PicViewWinDownload.setDisabled(false)
	var TFtpStreamSrc=PicViewWinStore.getAt(C).get("TFtpStreamSrc")
	//PicViewWinImage.el.dom.style.width=""
	//PicViewWinImage.el.dom.style.height=""
	PicViewWinImage.setHeight("")
	PicViewWinImage.setWidth("")
	PicViewWinImage.getEl().dom.src=TFtpStreamSrc
				
	PicViewWinDownload.setVisible(true)
	PicViewWinImage.setVisible(true)
	
	}
	function SetImageSize(){
		if(PicViewWinImage.getHeight()>600) PicViewWinImage.setHeight(600)
		if(PicViewWinImage.getWidth()>800)PicViewWinImage.setWidth(800)
	}
//=====================初始化============================
	function initpicture()
	{
		if((PiclistData.TRowID)!=undefined) 
		{
			var index=PicViewWinStore.find("TRowID",PiclistData.TRowID)
			PicViewWinPagingToolbar.doLoad(index)
			//GetImage(PiclistData.RowId)
		}
		else if(PictureDR!="")
		{
			var index=PicViewWinStore.find("TDefaultFlag","Y")
			if (index==-1) index=0
			PicViewWinPagingToolbar.doLoad(index)
		}
	}
	
	
//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var PicViewWinPanel = new Ext.Panel({
		autoScroll:true,
		//labelAlign : 'right',
		frame : true,
		region:'center',
		//height : 240,
		items : [PicViewWinImage,PicViewWinDownload]	
	})
	var mainPanel = new Ext.Viewport({//将document body作为渲染对象，它会根据浏览器窗口的大小自动调整自身的尺寸。
		layout:'border',
		items:[PicViewWinPanel,PicViewWinPagingToolbar],
		renderTo:'mainPanel'
	});
	PicViewWinImage.el.dom.onresize=function() {
             }
    PicViewWinImage.el.dom.onreadystatechange=function() {
		if(PicViewWinImage.el.dom.readyState=="complete")
		{ 
			SetImageSize()		//图片显示会维持一定长宽比，所以强制设置大小后实际显示图片会更小些
			//if(PicViewWinImage.getWidth()>480) PicViewWinImage.el.dom.style.width=480
			//if(PicViewWinImage.getHeight()>480) PicViewWinImage.el.dom.style.height=480
		}
    }
    PicViewWinStore.load({params:{Arg1:PictureDR,ArgCnt:1},
			callback : function(r, options, success) {initpicture()}})
		
});	

		
		
	

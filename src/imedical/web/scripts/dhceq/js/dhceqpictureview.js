//GR0033 extjs ͼƬ�ϴ�
//ͼƬԤ��ģ̬���ڲ��ִ���
//����csp��dhceq.process.pictureview.csp
//=========================�Ӵ���=============================

//ͼƬԤ������
	var PictureData=window.dialogArguments.PictureData
	var PiclistData=window.dialogArguments.PiclistData
	var PictureDR=PictureData.TRowID
	var TSourceType=PictureData.TSourceType
	//==========================================�ؼ�=====================================
 	var PicViewWinImage = new Ext.BoxComponent({
	 	autoEl: {  
        	tag: 'img'}
		//width : 800,  
		//height : 600
		//src:'ftp://windows%5cadmin:admin@192.168.109.129/TestFtp/DHCEQPicture/176.bmp'  
	})
       
	var PicViewWinDownload = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
	width : 70,
	height : 30,
	hidden:true,
	handler:function(){
		//saveAs(PicViewWinImage.getEl().dom.src,"new.jpg")
		//PicViewWinImage.el.dom.document.execCommand("SaveAs");ͬһҳ��ֻά��һ��document�������Դ˷���������
		//var fso = new ActiveXObject("Scripting.FileSystemObject");�޷���������������
		
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
        field : 'TPicListSort', // ָ��Ҫ�����������
        direction : 'ASC' // DESC����  ASC������
    }
    ,remoteSort:false//Զ���������
	});

	
	var PicViewWinPagingToolbar = new Ext.PagingToolbar({
    store:PicViewWinStore,
	pageSize:1,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
	doLoad:function(C){
		if (undefined!=this.store.getAt(C))
		{
		var TRowID=this.store.getAt(C).get("TRowID")
		GetImage(C)
		}
		//this.getPageData().activePage=2 ��Ч
		//this.store.currentPage=C	4.0������
		//this.inputItem.setValue(2)	ֻ���޸���ʾҳ��ֵ���޷�ʵ����ҳ�Ȱ�ť�һ�
		//this.store.setBaseParam("start",C)	��load�޷���Ч
		//this.store.lastOptions.params.start=C ��Ч
		this.cursor = C;
		//����Դ���ػ���ȡ��onload event
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
//============================���==========================
	
	//========================����========================

	//==============================���ܺ���==================================
	function GetImage(C){
	var TSuffix=PicViewWinStore.getAt(C).get("TSuffix")
	if(TSuffix=="") 
		{Msg.info("error","ͼƬ��δ�ϴ����޷�Ԥ��!");
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
//=====================��ʼ��============================
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
	
	
//===========ģ����ҳ��===========================================
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
	var mainPanel = new Ext.Viewport({//��document body��Ϊ��Ⱦ�������������������ڵĴ�С�Զ���������ĳߴ硣
		layout:'border',
		items:[PicViewWinPanel,PicViewWinPagingToolbar],
		renderTo:'mainPanel'
	});
	PicViewWinImage.el.dom.onresize=function() {
             }
    PicViewWinImage.el.dom.onreadystatechange=function() {
		if(PicViewWinImage.el.dom.readyState=="complete")
		{ 
			SetImageSize()		//ͼƬ��ʾ��ά��һ������ȣ�����ǿ�����ô�С��ʵ����ʾͼƬ���СЩ
			//if(PicViewWinImage.getWidth()>480) PicViewWinImage.el.dom.style.width=480
			//if(PicViewWinImage.getHeight()>480) PicViewWinImage.el.dom.style.height=480
		}
    }
    PicViewWinStore.load({params:{Arg1:PictureDR,ArgCnt:1},
			callback : function(r, options, success) {initpicture()}})
		
});	

		
		
	

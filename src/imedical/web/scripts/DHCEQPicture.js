//GR0033 extjs ͼƬ�ϴ�
//ͼƬ�ϴ������沼�ִ���
//����csp��dhceq.process.picture.csp
//=========================================��ʼ������================================
var CurrentSourceID=GetQueryString("CurrentSourceID")
var CurrentSourceType=GetQueryString("CurrentSourceType")
var EquipDR=GetQueryString("EquipDR")
var LastPicSelectRowid=0
var LastPicListSelectRowid=0
var PictureGridUrl = 'dhceq.process.pictureaction.csp';
//=========================�ؼ�===========================================
var PicNoField=	new Ext.form.TextField({		
					id:'PicNoField',
					name:'PictureNo',
					fieldLabel: 'ͼƬ���',
					selectOnFocus:true,
					emptyText:'ͼƬ���...',
					width:100
				  });
var PicNameField=	new Ext.form.TextField({		
					id:'PicNameField',
					name:'PicName',
					fieldLabel: 'ͼƬ����',
					emptyText:'ͼƬ����...',
					selectOnFocus:true,
					width:200,
	    			listWidth : 200
				  });
var DefaultFlagField=new Ext.grid.CheckColumn({
	id:'DefaultFlagField',
    header:'Ĭ����ʾ��־',
    dataIndex:'TDefaultFlag',
    width:80,
    sortable:false
})
var findPicture = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
    //iconCls: 'find',
	width : 70,
	height : 30,
	handler:function(){
		var PicNo=Ext.getCmp('PicNoField').getValue();
		var PicName=Ext.getCmp('PicNameField').getValue()
		if (undefined==PicNo) PicNo=""	//�˵�������ô˷���ʱ���ֿؼ�����δ��ʼ��
		if (undefined==PicName) PicName=""
		var vPicData="^^"+PicNo+"^^^"+window.parent.PicType+"^^^^^^^^"+PicName
		PictureGridDs.load({params:{start:0,limit:PicturePagingToolbar.pageSize,Arg1:CurrentSourceType,Arg2:CurrentSourceID,Arg3:vPicData,ArgCnt:3,page:1,rows:PicturePagingToolbar.pageSize}});
		PicListGrid.store.removeAll()

	}
});
//==============================ͼƬ��������Դ===============================

var PictureGridProxy= new Ext.data.HttpProxy({url:'dhceq.jquery.csp?ClassName=web.DHCEQ.Process.DHCEQPicture&QueryName=GetPicture',method:'POST'});
var PictureGridDs = new Ext.data.Store({
	proxy:PictureGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'total'
        //,pageSize:5
    }, [
		{name:'TRowID'},
		{name:'TEquipDR'},
		{name:'TPath'},
		{name:'TRemark'},
		{name:'TPicTypeDR'},
		{name:'TPicTypeDesc'},
		{name:'TPicNo'},
		{name:'TPicLocation'},
		{name:'TPicName'},
		{name:'TPicNum'},
		{name:'TSourceType'},
		{name:'TSourceTypeDesc'}
	]),
    remoteSort:false
});

//ģ��
var PictureGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	//new Ext.grid.CheckboxSelectionModel(),
	 {
        header:"ͼƬ����",
        dataIndex:'TPicName',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"ͼƬ����DR",
        dataIndex:'TPicTypeDR',
        width:120,
        align:'left',
        sortable:false,
        hidden:true
    },{
        header:"ͼƬ����",
        dataIndex:'TPicTypeDesc',
        width:80,
        align:'left',
        sortable:false
        //hidden:true
    },{
        header:"ҵ����ԴDR",
        dataIndex:'TSourceType',
        width:80,
        align:'left',
        sortable:false,
        hidden:true
    },{
        header:"ҵ����Դ����",
        dataIndex:'TSourceTypeDesc',
        width:80,
        align:'left',
        sortable:false
    },{
        header:"ͼƬ���",
        dataIndex:'TPicNo',
        width:80,
        align:'left',
        sortable:false
    },{
        header:"��ע",
        dataIndex:'TRemark',
        width:80,
        align:'left',
        sortable:false
    },{
        header:"���λ��",
        dataIndex:'TPicLocation',
        width:80,
        align:'left',
        sortable:false
    }, {
        header:"ͼƬ����",
        dataIndex:'TPicNum',
        width:80,
        align:'left',
        sortable:false
    },{  
     header: "Ԥ��",  
  	 renderer:pictureview
 	},{
	header:'����',
	renderer:pictureupload
	},{
	header:'ɾ��',
	renderer:picturedelete
	}
]);
//��ʼ��Ĭ��������
PictureGridCm.defaultSortable = true;
//��ҳ������
var PicturePagingToolbar = new Ext.PagingToolbar({
    store:PictureGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B["page"]=C/this.pageSize+1;
		B["rows"]=this.pageSize;
		B["Arg1"]=CurrentSourceType;
		B["Arg2"]=CurrentSourceID;
		var PicNo=Ext.getCmp('PicNoField').getValue();
		var PicName=Ext.getCmp('PicNameField').getValue()
		B["Arg3"]="^^"+PicNo+"^^^"+window.parent.PicType+"^^^^^^^^"+PicName
		B["ArgCnt"]=3
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
PictureGrid = new Ext.grid.EditorGridPanel({
	store:PictureGridDs,
	cm:PictureGridCm,
	title:'ͼƬ����Ϣ',
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	bbar:PicturePagingToolbar,
	tbar:[PicNoField,'-',PicNameField,'-',findPicture,'-',{  
            text:'����',
            iconCls:'page_add',  
            handler:function(){  
                CreatePicuploadWin("","")
                }  
            },'-'],
	listeners:{
	'rowdblclick':function(){}
	,
	'rowclick':function(){
		var rowObj = PictureGrid.getSelectionModel().getSelected(); 
		var TRowID = rowObj.get('TRowID');
		if(LastPicSelectRowid==TRowID) 
		{
			//PictureGrid.getSelectionModel().clearSelections();
			//LastPicSelectRowid=0;
			//PicListGrid.store.removeAll()
			//PicListGrid.store.load({params:{start:0,limit:PicListPagingToolbar.pageSize,ArgCnt:0}})
		}
		else {
			LastPicSelectRowid=TRowID
			PicListGridDs.load({params:{start:0,limit:PicListPagingToolbar.pageSize,rowid:TRowID,Arg1:TRowID,ArgCnt:1,page:1,rows:PicListPagingToolbar.pageSize}});
		}
		}
	}
});

if(window.parent.PicType!=-1) PictureGridDs.load({params:{start:0,limit:PicturePagingToolbar.pageSize,Arg1:CurrentSourceType,Arg2:CurrentSourceID,Arg3:"^^^^^"+window.parent.PicType,ArgCnt:3,page:1,rows:PicturePagingToolbar.pageSize}});
//============================ͼƬ��ϸ����Դ===============================
//var PicListGridProxy= new Ext.data.HttpProxy({url:PictureGridUrl+'?actiontype=GetPictureList',method:'POST'});
var PicListGridProxy= new Ext.data.HttpProxy({url:'dhceq.jquery.csp?ClassName=web.DHCEQ.Process.DHCEQPictureList&QueryName=GetPictureList',method:'POST'});
var PicListGridDs = new Ext.data.Store({
	proxy:PicListGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'total'
        //,pageSize:35
    }, [
		{name:'TRowID'},
		{name:'TPicName'},
		{name:'TPicListSort', type: 'int'},
		{name:'TSuffix'},
		{name:'TDefaultFlag'},
		{name:'TFtpStreamSrc'}
	]),
    remoteSort:false,
    sortInfo : {
        field : 'TPicListSort', // ָ��Ҫ�����������
        direction : 'ASC' // DESC����  ASC������
    }
});
//ģ��
var PicListGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 //new Ext.grid.CheckboxSelectionModel({editable:false}),
	 {
        header:"ͼƬ����",
        dataIndex:'TPicName',
        width:160,
        align:'left',
        sortable:false
    },{
        header:"���",
        dataIndex:'TPicListSort',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"��׺",
        dataIndex:'TSuffix',
        width:80,
        align:'left',
        sortable:false
    },DefaultFlagField,
{  
     header: "Ԥ��",  
  	 renderer:piclistview
 	},{
	header:'����',
	renderer:piclistupload
	},{
	header:'ɾ��',
	renderer:piclistdelete
	},{
	header:'����',
	renderer:piclistdownload
	}
    
]);

//��ʼ��Ĭ��������
PicListGridCm.defaultSortable = true;

//��ҳ������
var PicListPagingToolbar = new Ext.PagingToolbar({
    store:PicListGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B["page"]=C/this.pageSize+1;
		B["rows"]=this.pageSize;
		var rowObj = PictureGrid.getSelectionModel().getSelected(); 
		var TRowID ="" 
		if  (rowObj!=undefined) TRowID=rowObj.get('TRowID');
		B["Arg1"]=TRowID;
		B["ArgCnt"]=1
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
PicListGrid = new Ext.grid.EditorGridPanel({
	store:PicListGridDs,
	cm:PicListGridCm,
	title:'ͼƬ��ϸ',
	trackMouseOver:true,
	region:'south',
	height:300,
	//plugins:[DefaultFlagcheck],//����������ԲŻ����ԭ����ʼ������,ʹcheck����ֱ��ʹ�ã�������˫������༭ģʽȻ��check
	stripeRows:true,
	
	loadMask : true,

	//sm:new Ext.grid.CellSelectionModel({singleSelect:true}),
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	
	loadMask:true,
	bbar:PicListPagingToolbar,
	tbar:['-',{  
            text:'����', 
            iconCls:'page_add', 
            handler:function(){  
            	CreatePicListuploadWin(GetPictureData(),"")
                }  
            },'-'
	]
});










//=============================���ܺ���=========================

function GetPictureData()
{
	var data={}
	var rowObj = PictureGrid.getSelectionModel().getSelected();
	if  (undefined!=rowObj) return rowObj.data
	return data
}
function GetPiclistData()
{
	var data={}
	var rowObj = PicListGrid.getSelectionModel().getSelected();
	if  (undefined!=rowObj)return rowObj.data
	return data
}

function pictureview(){
			var str ="<button  onclick='Picview()'><font color='#FF0000'>Ԥ��</font></button>"; 
			return str;
		  }
function pictureupload(){
			var str ="<button  onclick='CreatePicuploadWin(GetPictureData(),GetPiclistData())'><font color='#FF0000'>�༭</font></button>"; 
			return str;
		  }
function picturedelete(){
			var str ="<button  onclick='DeletePicData(&quot;DeletePicture&quot;,PictureGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>ɾ��</font></button>"; 
			return str;
		  }
function piclistview(){
			var str ="<button  onclick='Picview()'><font color='#FF0000'>Ԥ��</font></button>"; 
			return str;
		  }
function piclistupload(){
			var str ="<button  onclick='CreatePicListuploadWin(GetPictureData(),GetPiclistData())'><font color='#FF0000'>�༭</font></button>"; 
			return str;
		  }
function piclistdelete(){
			var str ="<button  onclick='DeletePicData(&quot;DeletePiclist&quot;,PicListGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>ɾ��</font></button>"; 
			return str;
		  }
function piclistdownload(){
			var str ="<button  onclick='Picdownload(PicListGrid.getSelectionModel().getSelected().data.TFtpStreamSrc)'><font color='#FF0000'>����</font></button>"; 
			return str;
		  }
function DeletePicData(actiontype,RowID)
{
	//�������ҵ��ɾ��
	if(PictureGrid.getSelectionModel().getSelected().data.TSourceType!=CurrentSourceType){Msg.info("error","�޷���ҵ��ɾ��");return}
	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
	Ext.Ajax.request({
	   	url: PictureGridUrl+'?&actiontype='+actiontype,
	   	success: function(response, opts){
		   	var jsonData = Ext.util.JSON.decode( response.responseText );
				 mask.hide();
				if(jsonData.success==true){
					Msg.info("success","ɾ���ɹ�!");
		   			PictureGrid.store.reload()
		   			PicListGrid.store.removeAll()
				}else{
						Msg.info("error","ɾ��ʧ��!");
				}	
			},
	   	failure: function(response, opts){mask.hide();},
	   	timeout: 6000
	   	,params: { rowid: RowID }
	   	})
}
function Picdownload(url){
	//var oPop = window.open(window.location.host+"/dthealth/web/csp/"+url);
	var oPop = window.open(url)
	
}
function Picview(){
	var Arguments={};
	Arguments.PictureData=GetPictureData();
	Arguments.PiclistData=GetPiclistData();
	Arguments.Getactiontype="GetFtpStreamSrcByRowid"
	window.parent.showModalDialog("dhceq.process.pictureview.csp",Arguments,'dialogWidth=810px;dialogHeight:645px')
}


						 
//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[PictureGrid,PicListGrid],
		renderTo:'mainPanel'
	});
		
});



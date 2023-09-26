//GR0033 extjs 图片上传
//图片上传主界面布局代码
//关联csp：dhceq.process.picture.csp
//=========================================初始化数据================================
var CurrentSourceID=GetQueryString("CurrentSourceID")
var CurrentSourceType=GetQueryString("CurrentSourceType")
var EquipDR=GetQueryString("EquipDR")
var LastPicSelectRowid=0
var LastPicListSelectRowid=0
var PictureGridUrl = 'dhceq.process.pictureaction.csp';
//=========================控件===========================================
var PicNoField=	new Ext.form.TextField({		
					id:'PicNoField',
					name:'PictureNo',
					fieldLabel: '图片编号',
					selectOnFocus:true,
					emptyText:'图片编号...',
					width:100
				  });
var PicNameField=	new Ext.form.TextField({		
					id:'PicNameField',
					name:'PicName',
					fieldLabel: '图片名称',
					emptyText:'图片名称...',
					selectOnFocus:true,
					width:200,
	    			listWidth : 200
				  });
var DefaultFlagField=new Ext.grid.CheckColumn({
	id:'DefaultFlagField',
    header:'默认显示标志',
    dataIndex:'TDefaultFlag',
    width:80,
    sortable:false
})
var findPicture = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    //iconCls: 'find',
	width : 70,
	height : 30,
	handler:function(){
		var PicNo=Ext.getCmp('PicNoField').getValue();
		var PicName=Ext.getCmp('PicNameField').getValue()
		if (undefined==PicNo) PicNo=""	//菜单界面调用此方法时部分控件可能未初始化
		if (undefined==PicName) PicName=""
		var vPicData="^^"+PicNo+"^^^"+window.parent.PicType+"^^^^^^^^"+PicName
		PictureGridDs.load({params:{start:0,limit:PicturePagingToolbar.pageSize,Arg1:CurrentSourceType,Arg2:CurrentSourceID,Arg3:vPicData,ArgCnt:3,page:1,rows:PicturePagingToolbar.pageSize}});
		PicListGrid.store.removeAll()

	}
});
//==============================图片主表数据源===============================

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

//模型
var PictureGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	//new Ext.grid.CheckboxSelectionModel(),
	 {
        header:"图片名称",
        dataIndex:'TPicName',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"图片类型DR",
        dataIndex:'TPicTypeDR',
        width:120,
        align:'left',
        sortable:false,
        hidden:true
    },{
        header:"图片类型",
        dataIndex:'TPicTypeDesc',
        width:80,
        align:'left',
        sortable:false
        //hidden:true
    },{
        header:"业务来源DR",
        dataIndex:'TSourceType',
        width:80,
        align:'left',
        sortable:false,
        hidden:true
    },{
        header:"业务来源类型",
        dataIndex:'TSourceTypeDesc',
        width:80,
        align:'left',
        sortable:false
    },{
        header:"图片编号",
        dataIndex:'TPicNo',
        width:80,
        align:'left',
        sortable:false
    },{
        header:"备注",
        dataIndex:'TRemark',
        width:80,
        align:'left',
        sortable:false
    },{
        header:"存放位置",
        dataIndex:'TPicLocation',
        width:80,
        align:'left',
        sortable:false
    }, {
        header:"图片数量",
        dataIndex:'TPicNum',
        width:80,
        align:'left',
        sortable:false
    },{  
     header: "预览",  
  	 renderer:pictureview
 	},{
	header:'保存',
	renderer:pictureupload
	},{
	header:'删除',
	renderer:picturedelete
	}
]);
//初始化默认排序功能
PictureGridCm.defaultSortable = true;
//分页工具栏
var PicturePagingToolbar = new Ext.PagingToolbar({
    store:PictureGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
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

//表格
PictureGrid = new Ext.grid.EditorGridPanel({
	store:PictureGridDs,
	cm:PictureGridCm,
	title:'图片主信息',
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	bbar:PicturePagingToolbar,
	tbar:[PicNoField,'-',PicNameField,'-',findPicture,'-',{  
            text:'新增',
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
//============================图片明细数据源===============================
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
        field : 'TPicListSort', // 指定要排序的列索引
        direction : 'ASC' // DESC降序，  ASC：赠序
    }
});
//模型
var PicListGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 //new Ext.grid.CheckboxSelectionModel({editable:false}),
	 {
        header:"图片名称",
        dataIndex:'TPicName',
        width:160,
        align:'left',
        sortable:false
    },{
        header:"序号",
        dataIndex:'TPicListSort',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"后缀",
        dataIndex:'TSuffix',
        width:80,
        align:'left',
        sortable:false
    },DefaultFlagField,
{  
     header: "预览",  
  	 renderer:piclistview
 	},{
	header:'保存',
	renderer:piclistupload
	},{
	header:'删除',
	renderer:piclistdelete
	},{
	header:'下载',
	renderer:piclistdownload
	}
    
]);

//初始化默认排序功能
PicListGridCm.defaultSortable = true;

//分页工具栏
var PicListPagingToolbar = new Ext.PagingToolbar({
    store:PicListGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
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

//表格
PicListGrid = new Ext.grid.EditorGridPanel({
	store:PicListGridDs,
	cm:PicListGridCm,
	title:'图片明细',
	trackMouseOver:true,
	region:'south',
	height:300,
	//plugins:[DefaultFlagcheck],//设置这个属性才会调用原来初始化方法,使check功能直接使用，不用再双击进入编辑模式然后check
	stripeRows:true,
	
	loadMask : true,

	//sm:new Ext.grid.CellSelectionModel({singleSelect:true}),
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	
	loadMask:true,
	bbar:PicListPagingToolbar,
	tbar:['-',{  
            text:'新增', 
            iconCls:'page_add', 
            handler:function(){  
            	CreatePicListuploadWin(GetPictureData(),"")
                }  
            },'-'
	]
});










//=============================功能函数=========================

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
			var str ="<button  onclick='Picview()'><font color='#FF0000'>预览</font></button>"; 
			return str;
		  }
function pictureupload(){
			var str ="<button  onclick='CreatePicuploadWin(GetPictureData(),GetPiclistData())'><font color='#FF0000'>编辑</font></button>"; 
			return str;
		  }
function picturedelete(){
			var str ="<button  onclick='DeletePicData(&quot;DeletePicture&quot;,PictureGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>删除</font></button>"; 
			return str;
		  }
function piclistview(){
			var str ="<button  onclick='Picview()'><font color='#FF0000'>预览</font></button>"; 
			return str;
		  }
function piclistupload(){
			var str ="<button  onclick='CreatePicListuploadWin(GetPictureData(),GetPiclistData())'><font color='#FF0000'>编辑</font></button>"; 
			return str;
		  }
function piclistdelete(){
			var str ="<button  onclick='DeletePicData(&quot;DeletePiclist&quot;,PicListGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>删除</font></button>"; 
			return str;
		  }
function piclistdownload(){
			var str ="<button  onclick='Picdownload(PicListGrid.getSelectionModel().getSelected().data.TFtpStreamSrc)'><font color='#FF0000'>下载</font></button>"; 
			return str;
		  }
function DeletePicData(actiontype,RowID)
{
	//不允许跨业务删除
	if(PictureGrid.getSelectionModel().getSelected().data.TSourceType!=CurrentSourceType){Msg.info("error","无法跨业务删除");return}
	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
	Ext.Ajax.request({
	   	url: PictureGridUrl+'?&actiontype='+actiontype,
	   	success: function(response, opts){
		   	var jsonData = Ext.util.JSON.decode( response.responseText );
				 mask.hide();
				if(jsonData.success==true){
					Msg.info("success","删除成功!");
		   			PictureGrid.store.reload()
		   			PicListGrid.store.removeAll()
				}else{
						Msg.info("error","删除失败!");
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


						 
//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[PictureGrid,PicListGrid],
		renderTo:'mainPanel'
	});
		
});



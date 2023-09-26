//GR0033 extjs 图片上传
//图片上传主界面布局代码
//关联csp：dhceq.process.picture.csp
//=========================================初始化数据================================
var CurrentSourceID=GetQueryString("CurrentSourceID")
var CurrentSourceType=GetQueryString("CurrentSourceType")
var EquipDR=GetQueryString("EquipDR")
var Status=GetQueryString("Status")
var LastPicSelectRowid=0
var LastPicListSelectRowid=0
var PicSelectRowid=0 //add by lmm 2017-10-11 458645
var PictureGridUrl = 'dhceq.process.pictureaction.csp';
var ReadOnly=GetQueryString("ReadOnly")
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
     dataIndex:'TPicNum',
  	 renderer:pictureview
 	},{
	header:'保存',
	dataIndex:'TSourceType',
	renderer:pictureupload
	},{
	header:'删除',
	dataIndex:'TSourceType',
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
            disabled:ReadOnly>0,
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
		if(PicSelectRowid==TRowID)   //modify by lmm 2017-10-11 458645
		{
			//PictureGrid.getSelectionModel().clearSelections();
			//LastPicSelectRowid=0;
			//PicListGrid.store.removeAll()
			//PicListGrid.store.load({params:{start:0,limit:PicListPagingToolbar.pageSize,ArgCnt:0}})
		}
		else {
			LastPicSelectRowid=TRowID
			PicListGridDs.load({params:{start:0,limit:PicListPagingToolbar.pageSize,rowid:TRowID,Arg1:TRowID,ArgCnt:1,page:1,rows:PicListPagingToolbar.pageSize}});
			PicSelectRowid=0;  //modify by lmm 2017-10-11 458645
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
     dataIndex:'TSuffix', 
  	 renderer:piclistview
 	},{
	header:'保存',
	renderer:piclistupload
	},{
	header:'删除',
	renderer:piclistdelete
	},{
	header:'下载',
	dataIndex:'TSuffix',
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
            disabled:ReadOnly>0, 
            handler:function(){
	            browsername=GetBrowserInfo(1)
	            browserverinfo=GetBrowserInfo(2)
	            if ((browsername=="msie")&&(browserverinfo>9.0))
	            {
					var PTRowID=GetPictureData()
					if (PTRowID.TRowID==undefined)
					{
						alertShow("请选择主表")
						return
					}
					var str='../csp/dhceq.process.picbatchupload.csp?PTRowID='+PTRowID.TRowID
					window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	            }
	            else
	            {
		            CreatePicListuploadWin(GetPictureData(),"")
	            }
                }  
            },'-'
	]
});










//=============================功能函数=========================
///Add By DJ 2016-09-26
///描述:获取IE浏览器版本
function GetBrowserInfo(vType)
{
	var agent = navigator.userAgent.toLowerCase() ;
	var regStr_ie = /msie [\d.]+;/gi ;
	var regStr_ff = /firefox\/[\d.]+/gi
	var regStr_chrome = /chrome\/[\d.]+/gi ;
	var regStr_saf = /safari\/[\d.]+/gi ;
	var regStr_ie11 = /rv[\:][\d.]+/gi ;
	var Return=""
	//IE
	if(agent.indexOf("msie") > 0)		{Return=regStr_ie}
	
	//IE11
	if(agent.indexOf("rv") > 0)			{Return=regStr_ie11}
	
	//firefox
	if(agent.indexOf("firefox") > 0)	{Return=regStr_ff}

	//Chrome
	//if(agent.indexOf("chrome") > 0)		{Return=regStr_chrome}

	//Safari
	//if(agent.indexOf("safari") > 0 && agent.indexOf("chrome") < 0)	{Return=regStr_saf}
	
	if (Return=="")
	{
		return	""
	}
	else
	{
		var browser=agent.match(Return);
		if (vType=="1")		//浏览器
		{
			var browsername = (browser+"").replace(/[0-9.:;\/]/ig,"");
			if (browsername=="rv") browsername="msie"
			return browsername
		}
		else if (vType=="2")	//版本
		{
			var verinfo = (browser+"").replace(/[^0-9.]/ig,"");
			return verinfo
		}
		else		//浏览器及版本号
		{
			return browser ;
		}
	}
}

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

function pictureview(value, metaData, record, rowIndex, colIndex, store){
			if(value==0) var str="<button  disabled=true><font color='#FF0000'>暂无预览</font></button>"; 
			else var str ="<button  onclick='Picview()'><font color='#FF0000'>预览</font></button>"; 
			return str;
		  }
function pictureupload(value, metaData, record, rowIndex, colIndex, store){
			if ((value!=CurrentSourceType)||(ReadOnly>0)) metaData.attr ='disabled=true' //这里如果设置disabled=false似乎无法生效，所以只能用if语句来决定是否要设置这条属性
			var str ="<button onclick='CreatePicuploadWin(GetPictureData(),GetPiclistData())'><font color='#FF0000'>更新</font></button>"; 
			return str;
		  }
function picturedelete(value, metaData, record, rowIndex, colIndex, store){
			if ((value!=CurrentSourceType)||(ReadOnly>0)) metaData.attr ='disabled=true'
			var str ="<button onclick='DeletePicData(&quot;DeletePicture&quot;,PictureGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>删除</font></button>"; 
			return str;
		  }
function piclistview(value, metaData, record, rowIndex, colIndex, store){
			if(value=="") var str ="<button  disabled=true><font color='#FF0000'>暂无预览</font></button>"; 
			else var str ="<button  onclick='Picview()'><font color='#FF0000'>预览</font></button>"; 
			return str;
		  }
function piclistupload(value, metaData, record, rowIndex, colIndex, store){
			var rowObj = PictureGrid.getSelectionModel().getSelected(); 
			var TSourceType = rowObj.get('TSourceType');
			if ((TSourceType!=CurrentSourceType)||(ReadOnly>0)) metaData.attr ='disabled=true'
			var str ="<button  onclick='CreatePicListuploadWin(GetPictureData(),GetPiclistData())'><font color='#FF0000'>更新</font></button>"; 
			return str;
		  }
function piclistdelete(value, metaData, record, rowIndex, colIndex, store){
			var rowObj = PictureGrid.getSelectionModel().getSelected(); 
			var TSourceType = rowObj.get('TSourceType');
			if ((TSourceType!=CurrentSourceType)||(ReadOnly>0)) metaData.attr ='disabled=true'
			var str ="<button onclick='DeletePicData(&quot;DeletePiclist&quot;,PicListGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>删除</font></button>"; 
			return str;
		  }
function piclistdownload(value, metaData, record, rowIndex, colIndex, store){
			if(value=="") var str ="<button  disabled=true><font color='#FF0000'>暂无下载</font></button>"; 
			else var str ="<button  onclick='Picdownload(PicListGrid.getSelectionModel().getSelected().data.TFtpStreamSrc)'><font color='#FF0000'>下载</font></button>"; 
			return str;
		  }
function DeletePicData(actiontype,RowID)
{
	var truthBeTold = window.confirm("确定删除改记录吗?");
    if (!truthBeTold) return;
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
					if (actiontype=="DeletePiclist") UpdateForPicListChange()
					else UpdateForPicChange()
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
function UpdateForPicListChange(){	//当明细表发生变化时调用，用来更新主表明细表
	PictureGrid.store.reload({callback : function(r, options, success) {
		var row=PictureGrid.store.find("TRowID",LastPicSelectRowid)
		if (row>=0) PictureGrid.getSelectionModel().selectRow(row)
		else LastPicSelectRowid=0 //正常来说不会执行到这句
		PicListGrid.store.reload()
		LastPicListSelectRowid=0
		}
	})
	
}
function UpdateForPicChange(){	//当主表发生变化时调用，用来更新主表明细表
	LastPicSelectRowid=0
	LastPicListSelectRowid=0
	PictureGrid.store.reload()
	PicListGrid.store.removeAll()
	
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



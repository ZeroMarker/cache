//GR0046 extjs 文件上传
//文件上传主界面布局代码
//关联csp：dhceq.process.AppendFile.csp
//=========================================初始化数据================================
var CurrentSourceType=GetQueryString("CurrentSourceType")
var CurrentSourceID=GetQueryString("CurrentSourceID")
//var CurrentSourceType=52
//var CurrentSourceID=1
var Status=GetQueryString("Status")
var ReadOnly=GetQueryString("ReadOnly")	//add by csj 2020-03-13 需求号：1227406
var Status=0
var LastFileSelectRowID=0
var AppendFileActionUrl = 'dhceq.process.appendfileaction.csp';
//add by lmm 2020-03-31 1239390
var HiddenFlag=false
if (ReadOnly==2)
{
	var HiddenFlag=true
}

//=========================控件===========================================
var DocNameField=	new Ext.form.TextField({		
					id:'DocNameField',
					name:'DocName',
					fieldLabel: '资料名称',
					selectOnFocus:true,
					emptyText:'资料名称...',
					width:100
				  });
var findAppendFile = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    //iconCls: 'find',
	width : 70,
	height : 30,
	handler:function(){
		//modify by lmm 2020-03-19 1224308
		var DocName=Ext.getCmp('DocNameField').getValue();
		AppendFileFindGridDs.load({params:{start:0,limit:AppendFileFindPagingToolbar.pageSize,Arg1:CurrentSourceType,Arg2:CurrentSourceID,Arg3:"^^"+DocName,ArgCnt:3,page:1,rows:AppendFileFindPagingToolbar.pageSize}});
		jQuery('#dlg').dialog('open');
		jQuery('a.media').media({width:500, height:400});
		
	}
});
//==============================文件主表数据源===============================

var AppendFileFindGridProxy= new Ext.data.HttpProxy({url:'dhceq.jquery.csp?ClassName=web.DHCEQ.Process.DHCEQAppendFile&QueryName=GetAppendFile',method:'POST'});
var AppendFileFindGridDs = new Ext.data.Store({
	proxy:AppendFileFindGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'total'
        //,pageSize:5
    }, [
		{name:'TRowID'},
		{name:'TSourceType'},
		{name:'TSourceTypeDesc'},
		{name:'TSourceID'},
		{name:'TAppendFileTypeDR'},
		{name:'TAppendFileTypeDesc'},
		{name:'TDocName'},
		{name:'TFileName'},
		{name:'TFilePath'},
		{name:'TFileType'},
		{name:'TRemark'},
		{name:'TToSwfFlag'},
		{name:'TFtpStreamSrc'}
	]),
    remoteSort:false
});

//模型
var AppendFileFindGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	//new Ext.grid.CheckboxSelectionModel(),
	{
        header:"业务来源类型",
        dataIndex:'TSourceTypeDesc',
        width:80,
        align:'left',
        sortable:false
    },
	{
        header:"资料来源类型DR",
        dataIndex:'TAppendFileTypeDR',
        width:120,
        align:'left',
        sortable:false,
        hidden:true
    },{
        header:"资料来源类型",
        dataIndex:'TAppendFileTypeDesc',
        width:80,
        align:'left',
        sortable:false
        //hidden:true
    },{
        header:"资料名称",
        dataIndex:'TDocName',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"文件名称",
        dataIndex:'TFileName',
        width:80,
        align:'left',
        sortable:false,
        hidden:true
    },{
        header:"文件类型",
        dataIndex:'TFileType',
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
		header: "浏览",  
		dataIndex:'TFileType',
		renderer:AppendFileview
 	},{
		header:'保存',
		dataIndex:'TSourceType',
		hidden:HiddenFlag,     //add by lmm 2020-03-31 1239390
		renderer:AppendFileupload
	},{
		header:'下载',
		dataIndex:'TFtpStreamSrc',
		renderer:AppendFiledownload
	},{
		header:'删除',
		dataIndex:'TSourceType',
		hidden:HiddenFlag,     //add by lmm 2020-03-31 1239390
		renderer:AppendFiledelete
	}
]);
//初始化默认排序功能
AppendFileFindGridCm.defaultSortable = true;
//分页工具栏
var AppendFileFindPagingToolbar = new Ext.PagingToolbar({
    store:AppendFileFindGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={};
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B["page"]=C/this.pageSize+1;
		B["rows"]=this.pageSize;
		B["Arg1"]=CurrentSourceType;
		B["Arg2"]=CurrentSourceID;
		B["Arg3"]=Ext.getCmp('DocNameField').getValue();
		B["ArgCnt"]=3
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
AppendFileFindGrid = new Ext.grid.EditorGridPanel({
	store:AppendFileFindGridDs,
	cm:AppendFileFindGridCm,
	title:'文件主信息',
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	bbar:AppendFileFindPagingToolbar,
	tbar:[DocNameField,'-',findAppendFile,'-',{  
            text:'新增',
            iconCls:'page_add', 
            disabled:Status>0||ReadOnly==1,//modified by csj 2020-03-13 需求号：1227406
            handler:function(){  
            	CreateAppendFileuploadWin("")
            	//window.open(DHCEQTomcatServer+"uploadfile.jsp")
                //CreatePicuploadWin("","")
                }  
            },'-'],
	listeners:{
	'rowdblclick':function(){}
	,
	'rowclick':function(){
		var rowObj = AppendFileFindGrid.getSelectionModel().getSelected(); 
		var TRowID = rowObj.get('TRowID');
		if(LastFileSelectRowID==TRowID) 
		{
			//AppendFileFindGrid.getSelectionModel().clearSelections();
			//LastPicSelectRowid=0;
			//PicListGrid.store.removeAll()
			//PicListGrid.store.load({params:{start:0,limit:PicListPagingToolbar.pageSize,ArgCnt:0}})
		}
		else {
			LastFileSelectRowID=TRowID
			//PicListGridDs.load({params:{start:0,limit:PicListPagingToolbar.pageSize,rowid:TRowID,Arg1:TRowID,ArgCnt:1,page:1,rows:PicListPagingToolbar.pageSize}});
		}
		}
	}
});

AppendFileFindGridDs.load({start:0,limit:AppendFileFindPagingToolbar.pageSize,params:{Arg1:CurrentSourceType,Arg2:CurrentSourceID,Arg3:"",ArgCnt:3,page:1,rows:AppendFileFindPagingToolbar.pageSize}});







//=================================事件响应==============================
function AppendFileview(value, metaData, record, rowIndex, colIndex, store){
			
			if(value=="") var str="<button  disabled=true><font color='#FF0000'>暂无浏览</font></button>"; 
			else 
			{
				var ftpappendfilename=record.data.TRowID+"."+value;
				if ((record.data.TToSwfFlag!="Y")&&(value.toLowerCase()!="pdf")) //add by zx 2017-08-11 pdf文件不需要转换 BUG ZX0038
					var str ="<button  onclick='AppendFileSwitchAndView(&quot;"+ftpappendfilename+"&quot;)'><font color='#FF0000'>浏览</font></button>"; 
				else
				//add by zx 2017-12-09 ZX0051 窗口打开不显示地址栏等
				var url="dhceq.process.appendfileview.csp?RowID="+record.data.TRowID+"&ToSwfFlag=Y";
				if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
					url += "&MWToken="+websys_getMWToken()
				}
				var str ="<button  onclick='window.open(&quot;"+url+"&quot;,&quot_blank&quot,&quot;toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes&quot;)'><font color='#FF0000'>浏览</font></button>";   //add by zx 2017-08-09 BUG ZX0038
				//var str ="<button  onclick='window.open(&quot;dhceq.process.appendswffileview.csp?RowID="+record.data.TRowID+"&ToSwfFlag=Y&quot;)'><font color='#FF0000'>浏览</font></button>"; 
			}
			return str;
		  }
function AppendFileupload(value, metaData, record, rowIndex, colIndex, store){
			if ((value!=CurrentSourceType)||(Status>0)) 
			//metaData.attr ='disabled=true' //这里如果设置disabled=false似乎无法生效，所以只能用if语句来决定是否要设置这条属性
			var str ="<button disabled=true onclick='CreateAppendFileuploadWin(GetAppendFileData())'><font color='#FF0000'>更新</font></button>"; 
			//var str ="<button onclick='window.showModalDialog(DHCEQAppendFileServer+&quot;uploadfile.jsp&quot;)'><font color='#FF0000'>更新</font></button>"; 
			else var str ="<button onclick='CreateAppendFileuploadWin(GetAppendFileData())'><font color='#FF0000'>更新</font></button>"; 
			return str;
		  }
function AppendFiledownload(value, metaData, record, rowIndex, colIndex, store){
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				value += "&MWToken="+websys_getMWToken()
			}
			var str ="<button onclick='window.open(&quot;"+value+"&quot;)'><font color='#FF0000'>下载</font></button>"; 
			return str;
		  }
function AppendFiledelete(value, metaData, record, rowIndex, colIndex, store){
			//if ((value!=SourceType)||(Status>0)) metaData.attr ='disabled=true'
			if ((value!=CurrentSourceType)||(Status>0))
				var str ="<button disabled=true onclick='DeleteAppendFileData(&quot;DeleteAppendFile&quot;,AppendFileFindGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>删除</font></button>"; 
			else
				var str ="<button onclick='DeleteAppendFileData(&quot;DeleteAppendFile&quot;,AppendFileFindGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>删除</font></button>"; 
			return str;
		  }


//=============================功能函数=========================

function GetAppendFileData()
{
	var data={}
	var rowObj = AppendFileFindGrid.getSelectionModel().getSelected();
	if  (undefined!=rowObj) return rowObj.data
	//var row=AppendFileFindGridDs.store.find("TRowID",LastFileSelectRowID)
	//AppendFileFindGridDs.getAt(row)
	return data
}

function DeleteAppendFileData(actiontype,RowID)
{
	//不允许跨业务删除
	//if(AppendFileFindGrid.getSelectionModel().getSelected().data.TSourceType!=CurrentSourceType){Msg.info("error","无法跨业务删除");return}
	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
	Ext.Ajax.request({
	   	url: AppendFileActionUrl+'?&actiontype='+actiontype,
	   	success: function(response, opts){
		   	var jsonData = Ext.util.JSON.decode( response.responseText );
				 mask.hide();
				if(jsonData.success==true){
					Msg.info("success","删除成功!");
					UpdateForAppendFileChange()
				}else{
					mask.hide();
					Msg.info("error","删除失败!");
				}	
			},
	   	failure: function(response, opts){mask.hide();},
	   	timeout: 6000,
	   	params: { RowID: RowID }
	   	})
}
function Picdownload(url){
	//var oPop = window.open(window.location.host+"/dthealth/web/csp/"+url);
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	var oPop = window.open(url)
	
}
function AppendFileSwitchAndView(ftpappendfilename){ //office文件类型转化并预览
	//window.open(DHCEQTomcatServer+"uploadfile.jsp?ftpappendfilename="+ftpappendfilename+"&parenthost="+window.location.host+"&FTPPictureFilePath="+encodeURIComponent(FTPPictureFilePath))
	//messageShow("","","",DHCEQTomcatServer+"DHCEQOfficeView/uploadfile.jsp?ftpappendfilename="+ftpappendfilename)
	//add by zx 2017-12-09 ZX0051 窗口打开不显示地址栏等
	var url=DHCEQTomcatServer+"DHCEQOfficeView/uploadfile.jsp?ftpappendfilename="+ftpappendfilename;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.open(url,'_blank',"toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes"); //add by zx 2017-08-09 BUG ZX0038
}
function UpdateForAppendFileChange(){	//当主表发生变化时调用，用来更新主表明细表
	LastFileSelectRowID=0
	AppendFileFindGrid.store.reload()
	
}						 
//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[AppendFileFindGrid],
		renderTo:'mainPanel'
	});
		
});



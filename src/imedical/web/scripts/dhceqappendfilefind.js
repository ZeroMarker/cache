//GR0046 extjs �ļ��ϴ�
//�ļ��ϴ������沼�ִ���
//����csp��dhceq.process.AppendFile.csp
//=========================================��ʼ������================================
var CurrentSourceType=GetQueryString("CurrentSourceType")
var CurrentSourceID=GetQueryString("CurrentSourceID")
//var CurrentSourceType=52
//var CurrentSourceID=1
var Status=GetQueryString("Status")
var ReadOnly=GetQueryString("ReadOnly")	//add by csj 2020-03-13 ����ţ�1227406
var Status=0
var LastFileSelectRowID=0
var AppendFileActionUrl = 'dhceq.process.appendfileaction.csp';
//add by lmm 2020-03-31 1239390
var HiddenFlag=false
if (ReadOnly==2)
{
	var HiddenFlag=true
}

//=========================�ؼ�===========================================
var DocNameField=	new Ext.form.TextField({		
					id:'DocNameField',
					name:'DocName',
					fieldLabel: '��������',
					selectOnFocus:true,
					emptyText:'��������...',
					width:100
				  });
var findAppendFile = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
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
//==============================�ļ���������Դ===============================

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

//ģ��
var AppendFileFindGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	//new Ext.grid.CheckboxSelectionModel(),
	{
        header:"ҵ����Դ����",
        dataIndex:'TSourceTypeDesc',
        width:80,
        align:'left',
        sortable:false
    },
	{
        header:"������Դ����DR",
        dataIndex:'TAppendFileTypeDR',
        width:120,
        align:'left',
        sortable:false,
        hidden:true
    },{
        header:"������Դ����",
        dataIndex:'TAppendFileTypeDesc',
        width:80,
        align:'left',
        sortable:false
        //hidden:true
    },{
        header:"��������",
        dataIndex:'TDocName',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"�ļ�����",
        dataIndex:'TFileName',
        width:80,
        align:'left',
        sortable:false,
        hidden:true
    },{
        header:"�ļ�����",
        dataIndex:'TFileType',
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
		header: "���",  
		dataIndex:'TFileType',
		renderer:AppendFileview
 	},{
		header:'����',
		dataIndex:'TSourceType',
		hidden:HiddenFlag,     //add by lmm 2020-03-31 1239390
		renderer:AppendFileupload
	},{
		header:'����',
		dataIndex:'TFtpStreamSrc',
		renderer:AppendFiledownload
	},{
		header:'ɾ��',
		dataIndex:'TSourceType',
		hidden:HiddenFlag,     //add by lmm 2020-03-31 1239390
		renderer:AppendFiledelete
	}
]);
//��ʼ��Ĭ��������
AppendFileFindGridCm.defaultSortable = true;
//��ҳ������
var AppendFileFindPagingToolbar = new Ext.PagingToolbar({
    store:AppendFileFindGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
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

//���
AppendFileFindGrid = new Ext.grid.EditorGridPanel({
	store:AppendFileFindGridDs,
	cm:AppendFileFindGridCm,
	title:'�ļ�����Ϣ',
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	bbar:AppendFileFindPagingToolbar,
	tbar:[DocNameField,'-',findAppendFile,'-',{  
            text:'����',
            iconCls:'page_add', 
            disabled:Status>0||ReadOnly==1,//modified by csj 2020-03-13 ����ţ�1227406
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







//=================================�¼���Ӧ==============================
function AppendFileview(value, metaData, record, rowIndex, colIndex, store){
			
			if(value=="") var str="<button  disabled=true><font color='#FF0000'>�������</font></button>"; 
			else 
			{
				var ftpappendfilename=record.data.TRowID+"."+value;
				if ((record.data.TToSwfFlag!="Y")&&(value.toLowerCase()!="pdf")) //add by zx 2017-08-11 pdf�ļ�����Ҫת�� BUG ZX0038
					var str ="<button  onclick='AppendFileSwitchAndView(&quot;"+ftpappendfilename+"&quot;)'><font color='#FF0000'>���</font></button>"; 
				else
				//add by zx 2017-12-09 ZX0051 ���ڴ򿪲���ʾ��ַ����
				var url="dhceq.process.appendfileview.csp?RowID="+record.data.TRowID+"&ToSwfFlag=Y";
				if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
					url += "&MWToken="+websys_getMWToken()
				}
				var str ="<button  onclick='window.open(&quot;"+url+"&quot;,&quot_blank&quot,&quot;toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes&quot;)'><font color='#FF0000'>���</font></button>";   //add by zx 2017-08-09 BUG ZX0038
				//var str ="<button  onclick='window.open(&quot;dhceq.process.appendswffileview.csp?RowID="+record.data.TRowID+"&ToSwfFlag=Y&quot;)'><font color='#FF0000'>���</font></button>"; 
			}
			return str;
		  }
function AppendFileupload(value, metaData, record, rowIndex, colIndex, store){
			if ((value!=CurrentSourceType)||(Status>0)) 
			//metaData.attr ='disabled=true' //�����������disabled=false�ƺ��޷���Ч������ֻ����if����������Ƿ�Ҫ������������
			var str ="<button disabled=true onclick='CreateAppendFileuploadWin(GetAppendFileData())'><font color='#FF0000'>����</font></button>"; 
			//var str ="<button onclick='window.showModalDialog(DHCEQAppendFileServer+&quot;uploadfile.jsp&quot;)'><font color='#FF0000'>����</font></button>"; 
			else var str ="<button onclick='CreateAppendFileuploadWin(GetAppendFileData())'><font color='#FF0000'>����</font></button>"; 
			return str;
		  }
function AppendFiledownload(value, metaData, record, rowIndex, colIndex, store){
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				value += "&MWToken="+websys_getMWToken()
			}
			var str ="<button onclick='window.open(&quot;"+value+"&quot;)'><font color='#FF0000'>����</font></button>"; 
			return str;
		  }
function AppendFiledelete(value, metaData, record, rowIndex, colIndex, store){
			//if ((value!=SourceType)||(Status>0)) metaData.attr ='disabled=true'
			if ((value!=CurrentSourceType)||(Status>0))
				var str ="<button disabled=true onclick='DeleteAppendFileData(&quot;DeleteAppendFile&quot;,AppendFileFindGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>ɾ��</font></button>"; 
			else
				var str ="<button onclick='DeleteAppendFileData(&quot;DeleteAppendFile&quot;,AppendFileFindGrid.getSelectionModel().getSelected().data.TRowID)'><font color='#FF0000'>ɾ��</font></button>"; 
			return str;
		  }


//=============================���ܺ���=========================

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
	//�������ҵ��ɾ��
	//if(AppendFileFindGrid.getSelectionModel().getSelected().data.TSourceType!=CurrentSourceType){Msg.info("error","�޷���ҵ��ɾ��");return}
	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
	Ext.Ajax.request({
	   	url: AppendFileActionUrl+'?&actiontype='+actiontype,
	   	success: function(response, opts){
		   	var jsonData = Ext.util.JSON.decode( response.responseText );
				 mask.hide();
				if(jsonData.success==true){
					Msg.info("success","ɾ���ɹ�!");
					UpdateForAppendFileChange()
				}else{
					mask.hide();
					Msg.info("error","ɾ��ʧ��!");
				}	
			},
	   	failure: function(response, opts){mask.hide();},
	   	timeout: 6000,
	   	params: { RowID: RowID }
	   	})
}
function Picdownload(url){
	//var oPop = window.open(window.location.host+"/dthealth/web/csp/"+url);
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	var oPop = window.open(url)
	
}
function AppendFileSwitchAndView(ftpappendfilename){ //office�ļ�����ת����Ԥ��
	//window.open(DHCEQTomcatServer+"uploadfile.jsp?ftpappendfilename="+ftpappendfilename+"&parenthost="+window.location.host+"&FTPPictureFilePath="+encodeURIComponent(FTPPictureFilePath))
	//messageShow("","","",DHCEQTomcatServer+"DHCEQOfficeView/uploadfile.jsp?ftpappendfilename="+ftpappendfilename)
	//add by zx 2017-12-09 ZX0051 ���ڴ򿪲���ʾ��ַ����
	var url=DHCEQTomcatServer+"DHCEQOfficeView/uploadfile.jsp?ftpappendfilename="+ftpappendfilename;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.open(url,'_blank',"toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes"); //add by zx 2017-08-09 BUG ZX0038
}
function UpdateForAppendFileChange(){	//���������仯ʱ���ã���������������ϸ��
	LastFileSelectRowID=0
	AppendFileFindGrid.store.reload()
	
}						 
//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[AppendFileFindGrid],
		renderTo:'mainPanel'
	});
		
});



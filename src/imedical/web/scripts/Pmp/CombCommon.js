//zzp
//2015-05-15
//��ȡ�ͻ���IP��ַ
function getIpAddress()
{
     try
     {
          var locator = new ActiveXObject ("WbemScripting.SWbemLocator");
          var service = locator.ConnectServer(".");
          var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
          var e = new Enumerator (properties);
          {
              var p = e.item();
              var ip = p.IPAddress(0);
              return ip
          }
     }
     catch(err)
     {
          return "";
     }
}
//zzp
//2015-05-22
//��ѡ���ļ�����
//��Σ��ļ���������Ϊ�գ�
//����ֵ���ļ�·��+�ļ���
function BrowseFolder(name) {
	 
	 var fd = new ActiveXObject("MSComDlg.CommonDialog");
       fd.Filter = "��������(*)"; //�^�V�ļ����
       fd.filename=name
       fd.FilterIndex = 2;
       fd.MaxFileSize = 128;
       //fd.ShowOpen();//�򿪶Ի���
       fd.ShowSave();//����Ի���
       VerStrstr=fd.filename;//fd.filename·��
}
//zzp
//2015-05-21
//�����������
//��Σ������������λ��
//����ֵ�����ֵ
function generateMixed(n) { 
var chars = new Array('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'); 
var res = ""; 
for (var i = 0; i < n ; i ++) { 
    var id = Math.ceil(Math.random()*35); 
    res += chars[id]; 
  } 
return res; 
} 
 
//zzp
//2015-05-21
//�ϴ������ظ������ú���
//��Σ������ļ�·��+����,ftp�������ļ�����,�������ͣ�UpLoad,DownLoad��
//����ֵ�� true:�ɹ�;false:ʧ�� 
function FileDownload(LocaName,FtpName,Type){
   var SizeType="",ret="Other";
   var SizeSwitch=1024*1024;
   var PortDll = new ActiveXObject("FtpPortDLL.FtpPortList");
   var objAudit = ExtTool.StaticServerObject("web.PMP.FileDownload");
   var FtpConfigRet=objAudit.FtpConfig();
   var sysFileSize=objAudit.FileSize();
   var sysRandomness=objAudit.Randomness();
   if((LocaName=="")||(Type=="")){
        ret='-1//��������ȷ';
		return ret;
   };
   if (FtpConfigRet==""){
        ret='-2//���ڡ��������á������á����ͱ��롱Ϊ��AdjunctIP����ftp·������!';
		return ret;
   };
   try{
     if(Type=="UpLoad"){
       var FielSizeBit=PortDll.FileSize(LocaName);
	   var FielSize=FielSizeBit/SizeSwitch;
	   if (FielSize>sysFileSize){
	   SizeType="1";
	   };
	   if(FielSize>1000){
	   FielSize=FielSize/1024;
	   FielSize=FielSize.toFixed(2)+"GB"
	   }
	   else{
	   FielSize=FielSize.toFixed(2)+"M"
	   };
	   if (SizeType=="1"){
	    ret='-3//��������ҽԺ�涨��С����ǰ��СΪ��'+FielSize;
		return ret;
	   };
	   var SerialNumber=generateMixed(sysRandomness);
	   var OldName=LocaName.split("\\")[LocaName.split("\\").length-1];
	   var NewFileName=objAudit.NewFileName(OldName,SerialNumber);
	   var NewFileAddress=FtpConfigRet.split("#")[3]+NewFileName;
	   var ret=PortDll.FTPFileUpload(FtpConfigRet.split("#")[0],FtpConfigRet.split("#")[2],FtpConfigRet.split("#")[1],LocaName,NewFileAddress);
	   var ret=ret+"//"+NewFileName;
	   return ret
     };
	 if(Type=="DownLoad"){
	 var NewFileAddress=FtpConfigRet.split("#")[3]+FtpName;var ret=PortDll.FTPFileDownload(FtpConfigRet.split("#")[0],FtpConfigRet.split("#")[2],FtpConfigRet.split("#")[1],NewFileAddress,LocaName);
	 return ret
	 };
   }catch(err)
	{
	  ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}; 
  
};

//zzp
//2015-05-23
//�������ؽ���
function DownLoadWind (){
     var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	 var ip=getIpAddress();
     var obj = new Object();
     obj.winfDownLoadProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfDownLoadStore = new Ext.data.Store({
		proxy: obj.winfDownLoadProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			//idProperty: 'DemRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'attachment', mapping: 'attachment'}
			,{name: 'UpDate', mapping: 'UpDate'}
			,{name: 'UpUser', mapping: 'UpUser'}
			,{name: 'DownLoadFlag', mapping: 'DownLoadFlag'}
			,{name:'ADRowid',mapping:'ADRowid'}
			,{name:'Filename',mapping:'Filename'}
		])
	});
	obj.winfGPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.winfDownPanel = new Ext.grid.GridPanel({
		id : 'winfDownPanel'
		,store : obj.winfDownLoadStore
		//,columnLines : true
		,height: 250
		,layout:'form'
		//,autoHeight:true
		,loadMask : true
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,buttonAlign : 'center'
		,plugins : obj.winfGPanelCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��������', width: 200, dataIndex: 'attachment', sortable: true}
			,{header: 'Rowid', width: 100, hidden:true,dataIndex: 'ADRowid', sortable: true}
			,{header: '�������ļ���', width: 100, hidden:true,dataIndex: 'Filename', sortable: true}
			,{header: '�ϴ�����', width: 100, dataIndex: 'UpDate', sortable: true}
			,{header: '�ϴ��û�', width: 100, dataIndex: 'UpUser', sortable: true}
			,{header : "���ظ���",width : 150,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='alarm_detail'>���غ�ͬ</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
               return strRet}}]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.winfDownLoadStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
			})
           ,iconCls: 'icon-grid'
		   ,viewConfig : {
			//forceFit : true
			//,scrollOffset: 0
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
});
	obj.ContractaaPanal=new Ext.Panel({
			id : 'ContractaaPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			//,collapsible: true
			,border:true
			,items:[obj.winfDownPanel]
		});		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 300
		,buttonAlign : 'center'
		,width : 600
		,layout:'fit'
		,border:true
		,modal:true
		,title : '��������'
		,items:[obj.ContractaaPanal]
	});
	obj.winfDownLoadStore.load({}); 
	DownLoadWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
  
    return obj;
};

function DownLoadWindEvent(obj){
     var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	 var ip=getIpAddress();
    obj.LoadEvent = function(args){
	
	obj.winfDownPanel.on('cellclick',obj.winfDownPanel_OnClick,obj);
	
	};
	
   obj.winfDownPanel_OnClick=function (grid, rowIndex, columnIndex, e){  
    var btn = e.getTarget('.controlBtn');  
     if (btn) {  
      var t = e.getTarget();  
      var record = obj.winfDownPanel.getStore().getAt(rowIndex);  
	  var attachName=record.get("attachment");
	  var ADRowid=record.get("ADRowid");
	  var Filename=record.get("Filename");
	  BrowseFolder(attachName);  //
	  if (VerStrstr==Filename){
	   return;
	   }
	  var retDownLoadFile=FileDownload(VerStrstr,Filename,"DownLoad");
	  if (retDownLoadFile=="true"){
	  var Down='���سɹ����ļ�������'+VerStrstr;
	  var retDownLoadFile=objApply.PMPDownloads(ADRowid,'PMP_ImprovementAdjunct',ip)
	  }
	  else{
	  var Down='����ʧ�ܣ�';
	  };
	  Ext.MessageBox.alert('Status', Down);
	  }  
	 }
}
//�������ع��ý���
function AdjunctAllWind(){
    var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var ip=getIpAddress();
    var obj = new Object();
	obj.AdjunctAllAdd = new Ext.Button({
		id : 'AdjunctAllAdd'
		,iconCls : 'icon-add'
		,text : '�ϴ�����'
	});
	obj.AdjunctAllRowid= new Ext.form.TextField({
		id : 'AdjunctAllRowid'
		,width : 200
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		,editable : true
		,hidden:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AdjunctAllType= new Ext.form.TextField({
		id : 'AdjunctAllType'
		,width : 200
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		,hidden:true
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.tbAdjunctAll = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tbAdjunctAll',
				items : [obj.AdjunctAllAdd,obj.AdjunctAllRowid,obj.AdjunctAllType]
			});
	//****************************** End ****************************
	obj.AdjunctAllTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.AdjunctAllTypeStore = new Ext.data.Store({
		proxy: obj.AdjunctAllTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['ConAdRowid'
		,'ConAdName'
		,'ConAdFileType'
		,'ConAdDate'
		,'ConAdUser'
		,'ConAdType'
		,'ConAdFtpName'
		,'ConAdFalg'
		,'ConAdAll'])
	});
	obj.gridContractCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.AdjunctAllPanel = new Ext.grid.GridPanel({
		id : 'AdjunctAllPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridContractCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.AdjunctAllTypeStore
		,tbar:obj.tbAdjunctAll
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridContractCheckCol
			, { header : 'Rowid', width : 150, dataIndex : 'ConAdRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '��������', width : 230, dataIndex : 'ConAdName', sortable : false, align : 'center',editable: true }
			, { header : '�ļ�����', width : 70, dataIndex : 'ConAdFileType', sortable : false ,align : 'center'}
			, { header : '�ϴ�ʱ��', width : 150, dataIndex : 'ConAdDate', sortable : true, align : 'center' }
			, { header : '�ϴ���', width : 100, dataIndex : 'ConAdUser',sortable : true,align : 'center' }
			, { header : '�ϴ�����', width : 120, dataIndex : 'ConAdType',sortable : true,align : 'center'}
			, { header : '�������ļ���', width : 250, dataIndex : 'ConAdFtpName', hidden: true ,sortable : true, align : 'center' }
			, { header : '������־', width : 100, dataIndex : 'ConAdFalg', hidden: true ,sortable : true, align : 'center' }
			, { header : 'ȫ·��', width : 250, dataIndex : 'ConAdAll', hidden:true,sortable : true, align : 'center' }
			, {header : "����",width : 80,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   if(record.get("ConAdFalg")=="Y"){
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='Download'>���غ�ͬ</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   }
			   else {
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='EditDetail'>ɾ��</a>";
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   };
			   return strRet;
			   }}]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.AdjunctAllTypeStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			//,scrollOffset: 0
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	//--------------------------------------------------------------------
    obj.ContractaPanal=new Ext.Panel({
			id : 'ContractaPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			//,collapsible: true
			,border:true
			,items:[obj.AdjunctAllPanel]
		});
    obj.menuwindContracAd = new Ext.Window({
		id : 'menuwindContracAd'
		,height : 360
		,buttonAlign : 'center'
		,width : 800
		,modal : true
		,title : '��������'
		,layout : 'fit'
		,border:true
		,items:[
			   obj.ContractaPanal
		]
	});
	obj.AdjunctAllTypeStore.load({}); 
	AdjunctAllWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;

}

function AdjunctAllWindEvent(obj){
  var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
  var objAudit=ExtTool.StaticServerObject("web.PMP.Document");
  var ip=getIpAddress();
  var dowmret=""
  obj.LoadEvent = function(args){
  obj.AdjunctAllAdd.on("click",obj.AdjunctAllAdd_OnClick,obj);
  
  obj.AdjunctAllPanel.on('cellclick',obj.AdjunctAllPanel_CellClick,obj)  
  }
  obj.AdjunctAllAdd_OnClick=function(){
    BrowseFolder('');
	var Rowid=obj.AdjunctAllRowid.getValue();
	var type=obj.AdjunctAllType.getValue();
	if (VerStrstr!=""){
	var FileName=objAudit.AddFileName(VerStrstr);  //User_"^"_type_"^"_flag_"^"_date
	var OldName=VerStrstr.split("\\")[VerStrstr.split("\\").length-1];
	var retDounload=FileDownload(VerStrstr,"","UpLoad");
	var flag=retDounload.split("//")[0]
	if(flag=="true"){
	  var FileNameAddRet=objApply.AdjunctAll(VerStrstr,retDounload.split("//")[1],Rowid,type,ip);
	  dowmret='�����ϴ��ɹ�';
	}
	if(flag!="true"){
	  dowmret='�����ϴ�ʧ��'+retDounload.split("//")[1];
	};
	Ext.MessageBox.alert('Status',dowmret);
	obj.AdjunctAllTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'ContracAdjunctStore';
			param.Arg1 = obj.AdjunctAllType.getValue();
			param.Arg2 = obj.AdjunctAllRowid.getValue();
			param.ArgCnt = 2;
	});
	obj.AdjunctAllTypeStore.load({}); 
	var Plant = obj.AdjunctAllTypeStore.recordType;
	//var p = new Plant({ConAdRowid:'',ConAdName:OldName,ConAdFileType:FileName.split("^")[1],ConAdDate:FileName.split("^")[3],ConAdUser:FileName.split("^")[0],ConAdType:FileName.split("^")[2],ConAdFtpName:'',ConAdFalg:'',ConAdAll:VerStrstr});
    //AdjunctObGrid.stopEditing();
    //obj.AdjunctAllTypeStore.insert(0, p);
	};
  }
  obj.AdjunctAllPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.AdjunctAllPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var ConAdRowid=record.get('ConAdRowid');
	var ConAdName=record.get('ConAdName');
	var ConAdFtpName=record.get('ConAdFtpName');
	if(control=="Download"){
	try{
	BrowseFolder(ConAdName);
	if (VerStrstr==ConAdName){
	return;
	}
	var ret=FileDownload(VerStrstr,ConAdFtpName,"DownLoad");
	if (ret==true){
	var Down='���سɹ����ļ�������'+VerStrstr;
	var ret=objApply.PMPDownloads(ConAdRowid,'PMP_ImprovementAdjunct',ip)
	}
	else{
	var Down='����ʧ�ܣ�';
	};
	Ext.MessageBox.alert('Status', Down);
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="EditDetail"){
	try{
	alert('ɾ��');
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	
	};
	};
};
//zzp
//2015-05-15
//��ȡ�ͻ���IP��ַ
function getIpAddress()
{
     try
     {
          var locator = new ActiveXObject ("WbemScripting.SWbemLocator");
          var service = locator.ConnectServer(".");
          var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
          var e = new Enumerator (properties);
          {
              var p = e.item();
              var ip = p.IPAddress(0);
              return ip
          }
     }
     catch(err)
     {
          return "";
     }
}
//zzp
//2015-05-21
//�����������
//��Σ������������λ��
//����ֵ�����ֵ
function generateMixed(n) { 
var chars = new Array('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'); 
var res = ""; 
for (var i = 0; i < n ; i ++) { 
    var id = Math.ceil(Math.random()*35); 
    res += chars[id]; 
  } 
return res; 
} 
 
//zzp
//2015-05-21
//�ϴ������ظ������ú���
//��Σ������ļ�·��+����,ftp�������ļ�����,�������ͣ�UpLoad,DownLoad��
//����ֵ�� true:�ɹ�;false:ʧ�� 
function FileDownload(LocaName,FtpName,Type){
   var SizeType="",ret="Other";
   var SizeSwitch=1024*1024;
   var PortDll = new ActiveXObject("FtpPortDLL.FtpPortList");
   var objAudit = ExtTool.StaticServerObject("web.PMP.FileDownload");
   var FtpConfigRet=objAudit.FtpConfig();
   var sysFileSize=objAudit.FileSize();
   var sysRandomness=objAudit.Randomness();
   if((LocaName=="")||(Type=="")){
        ret='-1//��������ȷ';
		return ret;
   };
   if (FtpConfigRet==""){
        ret='-2//���ڡ��������á������á����ͱ��롱Ϊ��AdjunctIP����ftp·������!';
		return ret;
   };
   try{
     if(Type=="UpLoad"){
       var FielSizeBit=PortDll.FileSize(LocaName);
	   var FielSize=FielSizeBit/SizeSwitch;
	   if (FielSize>sysFileSize){
	   SizeType="1";
	   };
	   if(FielSize>1000){
	   FielSize=FielSize/1024;
	   FielSize=FielSize.toFixed(2)+"GB"
	   }
	   else{
	   FielSize=FielSize.toFixed(2)+"M"
	   };
	   if (SizeType=="1"){
	    ret='-3//��������ҽԺ�涨��С����ǰ��СΪ��'+FielSize;
		return ret;
	   };
	   var SerialNumber=generateMixed(sysRandomness);
	   var OldName=LocaName.split("\\")[LocaName.split("\\").length-1];
	   var NewFileName=objAudit.NewFileName(OldName,SerialNumber);
	   var NewFileAddress=FtpConfigRet.split("#")[3]+NewFileName;
	   var ret=PortDll.FTPFileUpload(FtpConfigRet.split("#")[0],FtpConfigRet.split("#")[2],FtpConfigRet.split("#")[1],LocaName,NewFileAddress);
	   var ret=ret+"//"+NewFileName;
	   return ret
     };
	 if(Type=="DownLoad"){
	 var NewFileAddress=FtpConfigRet.split("#")[3]+FtpName;var ret=PortDll.FTPFileDownload(FtpConfigRet.split("#")[0],FtpConfigRet.split("#")[2],FtpConfigRet.split("#")[1],NewFileAddress,LocaName);
	 return ret
	 };
   }catch(err)
	{
	  ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}; 
  
};


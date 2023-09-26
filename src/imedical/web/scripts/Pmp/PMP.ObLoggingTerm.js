//张枕平  
//2015-04-01
function BrowseFolder(name) {
	 
	 var fd = new ActiveXObject("MSComDlg.CommonDialog");
       fd.Filter = "所有类型(*)"; //過濾文件類型
       fd.filename=name
       fd.FilterIndex = 2;
       fd.MaxFileSize = 128;
       //fd.ShowOpen();//打开对话框
       fd.ShowSave();//保存对话框
       VerStrstr=fd.filename;//fd.filename路径
}
//获取工作记录数据
var store=new Ext.data.Store({
	  proxy: new Ext.data.HttpProxy({
			 url:'PMP.Common.csp?actiontype=ObStore'
			}),
	  reader:new Ext.data.JsonReader({
	    	 totalProperty : "results",
			 root : 'rows',
			  idProperty: 'threadid',
              remoteSort: true,
              fields: ['title', 'forumtitle', 'forumid', 'author',
                       {name: 'ObRowid', type: 'int'},
                       {name: 'ObDate'},  //, mapping: 'ObDate', type: 'date', dateFormat: 'timestamp'
                       'lastposter', 'ObMenu','ObSolution','glipml','gluser']
			 })
    	});
    store.setDefaultSort('ObDate', 'desc');

//获取产品组下拉列表数据
var ObUserstore=new Ext.data.Store({
	  proxy: new Ext.data.HttpProxy({
			url:'PMP.Common.csp?actiontype=ObUserstore'
			}),
	  reader:new Ext.data.JsonReader({
	    	totalProperty : "results",
			root : 'rows'
			},['RowId','Description'])
    }); 
 //获取附件信息
 var AdjunctObStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
					url:'PMP.Common.csp?actiontype=AdjunctObStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['AdjunctObRowid','AdjunctObName','AdjunctObTime','AdjunctObUser','AdjunctObType','AdjunctFTPObName'])
    	});
  //获取需求名称下拉列表数据
var ObIpmlboxstore=new Ext.data.Store({
	  proxy: new Ext.data.HttpProxy({
			url:'PMP.Common.csp?actiontype=ObIpmlboxstore'
			}),
	  reader:new Ext.data.JsonReader({
	    	totalProperty : "results",
			root : 'rows'
			},['RowId','Description'])
    });
//检索按钮 参照scripts/dhcpa/outkpidata/outkpidatamain.js
var ObSearchField = 'MainTitle';
var ObFilterItem = new Ext.SplitButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '标题',value: 'MainTitle',checked: false,group: 'group',checkHandler: onOutObItemCheck }),
				new Ext.menu.CheckItem({ text: '标签',value: 'Title',checked: false,group: 'group',checkHandler: onOutObItemCheck }),
				new Ext.menu.CheckItem({ text: '创建日期',value: 'Date',checked: false,group: 'group',checkHandler: onOutObItemCheck }),
				new Ext.menu.CheckItem({ text: '内容',value: 'Menu',checked: false,group: 'group',checkHandler: onOutObItemCheck }),
				new Ext.menu.CheckItem({ text: '创建用户',value: 'User',checked: false,group: 'group',checkHandler: onOutObItemCheck }),
				new Ext.menu.CheckItem({ text: '工作类型',value: 'WorkType',checked: false,group: 'group',checkHandler: onOutObItemCheck })
		]}
});
function onOutObItemCheck(item, checked){
		if(checked) {
				ObSearchField = item.value;
				ObFilterItem.setText(item.text + ':');
		}
};
var ObSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 260,
		//autoWidth:true,  
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'请输入搜索关键字...',
		listeners: {
			specialkey: {fn:function(field, e) {
			var key = e.getKey();
			if(e.ENTER === key) {this.onTrigger2Click();}}}
		},
		grid: this,
		onTrigger1Click: function() {
			//if(this.getValue()) {
				this.setValue('');
				store.removeAll();
        store.load({params:{InPut:'',type:ObSearchField,menu:this.getValue()}});
				//store.proxy = new Ext.data.HttpProxy({url: 'PMP.Common.csp?actiontype=ObStore'+'&type='+ObSearchField+'&menu='+this.getValue()});
				//store.load();
			//}
		},
		onTrigger2Click: function() {
			//if(this.getValue()) {
				//store.proxy = new Ext.data.HttpProxy({
				store.removeAll();
        store.load({params:{InPut:'',type:ObSearchField,menu:this.getValue()}});
				//store.proxy = new Ext.data.HttpProxy({url: 'PMP.Common.csp?actiontype=ObStore'+'&type='+ObSearchField+'&menu='+this.getValue()});
				//store.load();
	    	//}
		}
		
});
var NewButton = new Ext.Button({text:'新建记录',handler: function(){NewClear();}});
var Obtbar=[ObFilterItem,ObSearchBox,{xtype:"tbseparator"},NewButton];
function NewClear(){
Ext.getCmp("Obtitle").setValue("");
Ext.getCmp("ROWID").setValue("");
Ext.getCmp("ObMaintitle").setValue("");
Ext.getCmp("ObDate").setValue(new Date().add(Date.DAY,0));
Ext.getCmp("ObUpDate").setValue(new Date().add(Date.DAY,0));
//Ext.getCmp("ObDate").setValue(data.ObDate);
//alert(data.ObDate);
Ext.getCmp("ObContenti").setValue("");
//Solutioni
Ext.getCmp("Solutioni").setValue("");
AdjunctObStore.removeAll();
AdjunctObStore.load({params:{InPut:'',type:'new'}});
};
///JS生成bat文件   update by lzt 20150205
function Log(url){ 
    //var url=url.replace(/(^\s*)|(\s*$)/g, "");
    var listret=tkMakeServerCall("web.PMP.Common","AdjunctIP");
	var user=listret.split("#")[2];
	var IP=listret.split("#")[0];
	var PassWord=listret.split("#")[1];
	var ipurl=listret.split("#")[3];
	var fso=new	ActiveXObject("Scripting.FileSystemObject");
	var LogFolder="D:";
	if(!fso.FolderExists(LogFolder)){
		fso.CreateFolder(LogFolder);     	
	}
    ts=fso.OpenTextFile(LogFolder+"\\"+"cmd.bat",8,true);
	ts.WriteLine("@echo off");
	//ts.WriteLine("net use \\\\127.0.0.1\\ipc$ "+'"'+"zhangkui"+'"'+" /user:"+'"'+"administrator"+'"');
	ts.WriteLine("net use \\\\"+IP+"\\ipc$ "+'"'+PassWord+'"'+" /user:"+'"'+user+'"');
    ts.WriteLine(url);
    ts.WriteLine("net use \\\\"+IP+"\\ipc$ /delete");
    //ts.WriteLine("net use \\\\127.0.0.1\\ipc$ /delete");
    ts.WriteLine("del d:\\cmd.bat");
	ts.Close();
	OpenWindow()
}
//zzp
//2015-05-15
//获取客户端IP地址
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
function OpenWindow() {
	 s=new  ActiveXObject("WScript.Shell"); 
	 //alert("执行")   
     s.Run("d:\cmd.bat",0,true);
    // alert(t["2"])
}
//zzp
//2015-05-21
//生成随机函数
//入参：生成随机函数位数
//返回值：随机值
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
//上传、下载附件公用函数
//入参：本地文件路径+名称,ftp服务器文件名称,操作类型（UpLoad,DownLoad）
//返回值： true:成功;false:失败 
function FileDownload(LocaName,FtpName,Type){
   var SizeType="",ret="Other";
   var SizeSwitch=1024*1024;
   var PortDll = new ActiveXObject("FtpPortDLL.FtpPortList");
   var FtpConfigRet=tkMakeServerCall("web.PMP.FileDownload","FtpConfig");
   var sysFileSize=tkMakeServerCall("web.PMP.FileDownload","FileSize");
   var sysRandomness=tkMakeServerCall("web.PMP.FileDownload","Randomness");
   if((LocaName=="")||(Type=="")){
        ret='-1//参数不正确';
		return ret;
   };
   if (FtpConfigRet==""){
        ret='-2//请在“功能配置”中配置“类型编码”为“AdjunctIP”的ftp路径属性!';
		return ret;
   };
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
	    ret='-3//附件超出医院规定大小，当前大小为：'+FielSize;
		return ret;
	   };
	   var SerialNumber=generateMixed(sysRandomness);
	   var OldName=LocaName.split("\\")[LocaName.split("\\").length-1];
	   var NewFileName=tkMakeServerCall("web.PMP.FileDownload","NewFileName",OldName,SerialNumber);
	   var NewFileAddress=FtpConfigRet.split("#")[3]+NewFileName;
	   var ret=PortDll.FTPFileUpload(FtpConfigRet.split("#")[0],FtpConfigRet.split("#")[2],FtpConfigRet.split("#")[1],LocaName,NewFileAddress);
	   var ret=ret+"//"+NewFileName;
	   return ret
     };
	 if(Type=="DownLoad"){
	 var NewFileAddress=FtpConfigRet.split("#")[3]+FtpName;var ret=PortDll.FTPFileDownload(FtpConfigRet.split("#")[0],FtpConfigRet.split("#")[2],FtpConfigRet.split("#")[1],NewFileAddress,LocaName);
	 return ret
	 };
  
};



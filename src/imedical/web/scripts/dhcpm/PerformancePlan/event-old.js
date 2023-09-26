//Create by zzp
// 20150519
//任务计划
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
	  obj.Plantree.on("click",obj.Plantree_OnClick,obj);  //树形结构单击事件
	  
	  obj.PlanAdd.on("click", obj.PlanAdd_OnClick, obj);  //新增事件 
		
	  obj.PlanUpdate.on("click", obj.PlanUpdate_OnClick, obj);  //修改 事件
		
	  obj.PlanQuery.on("click", obj.PlanQuery_OnClick, obj);  //查询事件  
		
	  obj.PlanBatch.on("click", obj.PlanBatch_OnClick, obj ); //重置事件 

      obj.PlanCode.on("specialkey", obj.PlanCode_specialkey,obj)  //编码回车事件
		
	  obj.PlanDesc.on("specialkey", obj.PlanDesc_specialkey,obj)  //名称回车事件

     obj.ContractGridPanel.on('cellclick',obj.ContractGridPanel_CellClick,obj)  	  
		
   };
   obj.ContractGridPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.ContractGridPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var PPPGridRowid=record.get('PPPGridRowid');
	if(control=="ContractDetail"){
	try{
	alert("查看详情");
	var PortDll = new ActiveXObject("FtpPortDLL.FtpPortList");
	//var ret=FileDownload("E:\\360Downloads\\cs.exe","63693762171J5WP9C.exe","DownLoad");
	//var ret=FileDownload("E:\\360Downloads\\foxmail_7.2.6.40.exe","","UpLoad");
	var ret=FileDownload("E:\\360Downloads\\FlashFXP_5.0.0.3804.exe","","UpLoad");
	alert(ret);
	//alert(PortDll.FileSize("E:\\360Downloads\\项目经理集中训练营照片.rar"));   //FileSize(FilePath As String)
	//alert(PortDll.FTPFileDownload("192.168.1.3","admin","zhangkui","//myftp//b.txt","C:\\zhangs.txt"));
    //alert(PortDll.FTPFileUpload("192.168.1.3","admin","zhangkui","C:\\zhangs.txt","//myftp//zhangsong.txt"));
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="ContractUser"){
	try{
	alert("责任人");
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="Download"){
	try{
	//附件下载列表
	DownLoadWind=new AdjunctAllWind();
	DownLoadWind.AdjunctAllRowid.setValue(PPPGridRowid);
	DownLoadWind.AdjunctAllType.setValue('PMP_ProjectPlan');
	DownLoadWind.AdjunctAllTypeStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'DHCPM.Query.PMQueryAll';
    param.QueryName = 'ContracAdjunctStore';
    param.Arg1 = 'PMP_ProjectPlan';   //  IPAJ_Affiliation  附件表中的归属字段
    param.Arg2 = PPPGridRowid;      //rowid
    param.ArgCnt = 2; 
	});
	DownLoadWind.AdjunctAllTypeStore.load({}); 
	DownLoadWind.menuwindContracAd.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	}
	}
   obj.PlanAdd_OnClick=function(){
   try{
        var node=obj.PlanRowid.getValue();
		if (node==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择左侧节点!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
		return;
		}
		else{
		distrObj = new PPPMenuWind();
	    distrObj.PPPMenuRowid.setValue(node);
	    distrObj.PPPMenuFlag.setValue('Add');
	    distrObj.menuwindadd.show();
		};        
   }catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};  
   };
   obj.PlanUpdate_OnClick=function(){
   var _record = obj.ContractGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	   return;
	}
	else {
	try{
	var PPPGridRowid=_record.get('PPPGridRowid');
	    distrObj = new PPPMenuWind();
	    distrObj.PPPMenuRowid.setValue(PPPGridRowid);
	    distrObj.PPPMenuFlag.setValue('Update');
	    distrObj.menuwindadd.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
   };
   obj.PlanBatch_OnClick=function(){
   obj.PlanCode.setValue('');
   obj.PlanDesc.setValue('');
   obj.PlanQuery_OnClick();
   };
   obj.PlanQuery_OnClick=function(){
      obj.PlanGridStore.removeAll();
	  obj.PlanGridStore.load({params : {start:0,limit:20}});
   };
   obj.PlanCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.PlanQuery_OnClick();
	};
   };
   obj.PlanDesc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.PlanQuery_OnClick();
	};
   };
   obj.Plantree_OnClick=function(node,event){
	  var Rowid=node.id;
	  var Text=node.text;
	  obj.PlanRowid.setValue(Rowid);
	  obj.PlanGridStore.removeAll();
	  obj.PlanGridStore.load({params : {start:0,limit:20}});
	  };

}
function ContractMenuWindEvent(obj){
    obj.LoadEvent = function(args){
	  obj.PPPMenuAdd.on("click",obj.PPPMenuAdd_OnClick,obj);
	  
	  obj.PPPMenuDelete.on("click",obj.PPPMenuDelete_OnClick,obj);
	  
	};
	obj.PPPMenuAdd_OnClick=function(){
	alert('新增事件');
	};
	obj.PPPMenuDelete_OnClick=function(){
	obj.menuwindadd.close();
	};

};
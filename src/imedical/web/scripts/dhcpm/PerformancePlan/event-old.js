//Create by zzp
// 20150519
//����ƻ�
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
	  obj.Plantree.on("click",obj.Plantree_OnClick,obj);  //���νṹ�����¼�
	  
	  obj.PlanAdd.on("click", obj.PlanAdd_OnClick, obj);  //�����¼� 
		
	  obj.PlanUpdate.on("click", obj.PlanUpdate_OnClick, obj);  //�޸� �¼�
		
	  obj.PlanQuery.on("click", obj.PlanQuery_OnClick, obj);  //��ѯ�¼�  
		
	  obj.PlanBatch.on("click", obj.PlanBatch_OnClick, obj ); //�����¼� 

      obj.PlanCode.on("specialkey", obj.PlanCode_specialkey,obj)  //����س��¼�
		
	  obj.PlanDesc.on("specialkey", obj.PlanDesc_specialkey,obj)  //���ƻس��¼�

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
	alert("�鿴����");
	var PortDll = new ActiveXObject("FtpPortDLL.FtpPortList");
	//var ret=FileDownload("E:\\360Downloads\\cs.exe","63693762171J5WP9C.exe","DownLoad");
	//var ret=FileDownload("E:\\360Downloads\\foxmail_7.2.6.40.exe","","UpLoad");
	var ret=FileDownload("E:\\360Downloads\\FlashFXP_5.0.0.3804.exe","","UpLoad");
	alert(ret);
	//alert(PortDll.FileSize("E:\\360Downloads\\��Ŀ������ѵ��Ӫ��Ƭ.rar"));   //FileSize(FilePath As String)
	//alert(PortDll.FTPFileDownload("192.168.1.3","admin","zhangkui","//myftp//b.txt","C:\\zhangs.txt"));
    //alert(PortDll.FTPFileUpload("192.168.1.3","admin","zhangkui","C:\\zhangs.txt","//myftp//zhangsong.txt"));
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="ContractUser"){
	try{
	alert("������");
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="Download"){
	try{
	//���������б�
	DownLoadWind=new AdjunctAllWind();
	DownLoadWind.AdjunctAllRowid.setValue(PPPGridRowid);
	DownLoadWind.AdjunctAllType.setValue('PMP_ProjectPlan');
	DownLoadWind.AdjunctAllTypeStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'DHCPM.Query.PMQueryAll';
    param.QueryName = 'ContracAdjunctStore';
    param.Arg1 = 'PMP_ProjectPlan';   //  IPAJ_Affiliation  �������еĹ����ֶ�
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
	          title : '��ܰ��ʾ',
			  msg : '��ѡ�����ڵ�!',
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
	          title : '��ܰ��ʾ',
			  msg : '��ѡ������!',
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
	alert('�����¼�');
	};
	obj.PPPMenuDelete_OnClick=function(){
	obj.menuwindadd.close();
	};

};
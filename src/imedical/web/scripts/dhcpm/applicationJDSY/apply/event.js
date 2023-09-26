//Create by dongzt
// 20150118
//需求申请
function InitviewScreenEvent(obj) {
	
	var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var objApply2 = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var objApply3 = ExtTool.StaticServerObject("web.PMP.Common");
	var objApply4 = ExtTool.StaticServerObject("web.PMP.Document");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.btnApply.on("click", obj.btnApply_OnClick, obj);
				
		//单击事件  

		
		
		//obj.StatDataGridPanel.on("rowclick", obj.StatDataGridPanel_rowclick, obj);
	};
	obj.btnApply_OnClick = function(){
		// Ext.MessageBox.alert('Status', 'Changes saved successfully.');
		 
		 var objWinEdit = new InitwinScreen();
		 objWinEdit.winScreen.show();
		/*  objWinEdit.winScreen.show();
		 ExtDeignerHelper.HandleResize(objwinScreen); */
		//Ext.example.msg("AA","BB",obj.btnApply_OnClick);
		/*   Ext.MessageBox.show({
           title: 'Please wait',
           msg: 'Loading items...',
           progressText: 'Initializing...',
           width:300,
           progress:true,
           closable:false,
           animEl: 'mb6'
       }); */

	}
	
	
	obj.btnQuery_OnClick = function(){
		obj.DtlDataGridPanelStore.removeAll();
		obj.DtlDataGridPanelStore.load({params : {start:0,limit:20}});
		
		/* obj.DtlDataGridPanelStore.removeAll();
		obj.DtlDataGridPanelStore.load({}); */
	}
	obj.DtlDataGridPanel.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
//alert(1);
  var btn = e.getTarget('.controlBtn');  
  if (btn) 
  {  
    var t = e.getTarget();  
    var record = obj.DtlDataGridPanel.getStore().getAt(rowIndex);  
	//alert(1);
	var DemandID=record.get("DemandID");
	//alert(DemandID);
	var DemandDesc=record.get("DemandDesc");
	var DemandType=record.get("DemandType");
	var EmergDegree=record.get("EmergDegree");
	//alert(EmergDegree);
	var Serious=record.get("Serious");
	var UserPhone=record.get("UserPhone");
	var DemandStatus=record.get("DemandStatus");
	var PMModule=record.get("PMModule");
	var DemSituation=record.get("DemSituation");
	var DemandResult=record.get("DemandResult");  
	var Engineer=record.get("Engineer"); 
	
	var MenuName=record.get("MenuName"); 
	var UserName=record.get("UserName");  //
	var LocName=record.get("LocName");
	var DemStatusCode=record.get("DemStatusCode");
	var InHanderName=record.get("InHanderName");
	var EditDemDesc=record.get("EditDemDesc");
	var EditUser=record.get("EditUser");
	
	
	var control = t.className; 
	//alert(control);
	if ('PMapply'==control)
	{
		
		if (DemandID !='')
		{
			try
			{
						//Ext.MessageBox.confirm('确认框', '您需要直接提交吗？',fn1);
				
				
						 var errStr = objApply.SubmitApplication(DemandID);
						if (errStr=="0")
						{ 
						   var PermissionTypeRet=objApply4.PermissionType();  //判断配置中的是否开启申请人在审核列表中的时候自动审核
						   if(PermissionTypeRet=='Y'){
						    var PermissionUserRet=objApply4.PermissionUser(''); //判断该用户是否存在审核权限
							if(PermissionUserRet.split("^")[0]=='Y'){
							  var AutoRet=objApply4.PermissionAuto(DemandID,PermissionUserRet.split("^")[1]);
							  if (AutoRet=="1"){
							  Ext.MessageBox.alert('Status','提交成功，自动审核成功！');
							  ExtTool.LoadCurrPage('DtlDataGridPanel'); 
							  }
							  else{
							  Ext.MessageBox.alert('Status','提交成功，自动审核失败！');
							  ExtTool.LoadCurrPage('DtlDataGridPanel'); 
							  }
							}
							else{
							  Ext.MessageBox.alert('Status','提交成功！');
							  ExtTool.LoadCurrPage('DtlDataGridPanel'); 
							};
						   }
						   else{
						    Ext.MessageBox.alert('Status','提交成功！');
							ExtTool.LoadCurrPage('DtlDataGridPanel'); 
						   };
						}
						else
						{
							Ext.MessageBox.alert('Status','保存失败!errCode='+errStr);	
						} 
				}catch(err)
			{
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
		}	
	}
    if ('UpdateIPML'==control){
	DownLoadWind=new EditWind(DemandID,'Improvement');
	DownLoadWind.menuwindadd.show();
	}	
	if ('PMdelete'==control)
	{
		//alert(DemandID);
		if (DemandID !='')
		{
			try
			{
			Ext.MessageBox.confirm('确认框', '您确定要删除这条需求吗？',fn);
				
				function fn(id)
				{
					//alert('单击的按钮id是：'+id); 
					if (id=='yes')
					{
						
						 var errStr = objApply.DeleteApply(DemandID);
						if (errStr=="0")
						{
							//alert(errStr);
							Ext.MessageBox.alert('Status', '删除成功！');
						
							ExtTool.LoadCurrPage('DtlDataGridPanel'); 
						}
						else
						{
							Ext.MessageBox.alert('Status','删除失败!errCode='+errStr);
							
						} 
					}
					
					 
						
				}
				}catch(err)
			{
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
			
			
		}
		
		
	}
	if ('Download'==control){
	//附件下载列表
	try{
	DownLoadWind=new AdjunctAllWind(DemandID,'Improvement');
	DownLoadWind.AdjunctAllRowid.setValue(DemandID);
	DownLoadWind.AdjunctAllType.setValue('Improvement');
	DownLoadWind.menuwindContracAd.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	
	}
	if ('PMDescription'==control)
	{
		
			
			objWinDetail = new InitDescScreen();
			
			//alert(PDemandID);
			objWinDetail.DemandID.setValue(DemandID);
			//alert(obj.DemandID.getValue());
			objWinDetail.winfDemName.setValue(DemandDesc);
			objWinDetail.winfDemName.disabled=true;
			//alert(obj.winfDemName.getValue());
			
			objWinDetail.winfDemType.setValue(DemandType);
			objWinDetail.winfDemType.disabled=true;
			objWinDetail.winfEmergency.setValue(EmergDegree);
			objWinDetail.winfEmergency.disabled=true;
			objWinDetail.winfPhone.setValue(UserPhone);
			
			objWinDetail.winfPhone.disabled=true;
			objWinDetail.winfDemDesc.setValue(DemSituation); //
			//objWinDetail.winfDemDesc.disabled=true;
			objWinDetail.winfCreater.setValue(UserName); 
			objWinDetail.winfCreater.disabled=true;
			objWinDetail.winfLocation.setValue(LocName); //
			objWinDetail.winfLocation.disabled=true;
			objWinDetail.winfModule.setValue(PMModule); 
			objWinDetail.winfModule.disabled=true;
			objWinDetail.winfInHandler.setValue(InHanderName);
			
			//var editNote="修改人:"+EditUser+"                             "+EditDemDesc;
			if(EditDemDesc!="")
			{objWinDetail.winfEditDemDesc.setValue(EditDemDesc);} 
			
			 //操作列表
			objWinDetail.winfGPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryDemList';
			param.Arg1 = DemandID;    //obj.MenuID.getValue();
			param.ArgCnt = 1; 
			});
			
			//沟通记录列表
			objWinDetail.winfComlistStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Handle.PMHandle';
			param.QueryName = 'QryComContent';
			param.Arg1 = DemandID;    //obj.MenuID.getValue();
			param.ArgCnt = 1; 
			});
			 //附件下载列表
			objWinDetail.winfDownLoadProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryDownLoadList';
			param.Arg1 = "";
			param.Arg2 = DemandID;    //obj.MenuID.getValue();
			param.ArgCnt = 2; 
			});
			objWinDetail.winfGPanelStore.load({});
			
			objWinDetail.winfComlistStore.load({}); 
				
			objWinDetail.winfDownLoadStore.load({}); 
		 
		
		
		
		objWinDetail.winScreen.show();
		
	}
	// 
	//回执事件
	if ('PMback'==control)
	{
		
		
		 //alert(1)
		 if(('测试'==DemandStatus))
		{
			
		
				
						var receiptObj = new receiptScreen();
						receiptObj.DemandID.setValue(DemandID);
						//alert(1);
						receiptObj.winScreen.show();
						
	
	
			
		} 

		
		
	}
	
	if('PMfinish'==control)
	{
		//alert(1)
		
		
		 if('测试'==DemandStatus)
		{
			var receiptobj = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	        var  finishRet=receiptobj.FinishInsert(DemandID);
			try
			{
				if('0'==finishRet)
				{
					//Ext.MessageBox.alert('Status', '恭喜您，本次需求顺利完成！');
					Ext.MessageBox.confirm('确认框', '亲!，需求处理完成，需要马上进行评价吗？',function(btn){
					if (btn=="yes"){
					try{
	                   var distrObj = new Appraisal();
		               distrObj.ImAppRowid.setValue(DemandID);
		               distrObj.menuwind.show();
	                }catch(err){
			        	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			           }
					
					}
					else {
					}
					});
				}
				else
				{
					Ext.MessageBox.alert('Status', '保存失败：'+finishRet);
				}
				
			}
			catch(err){
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
			
			ExtTool.LoadCurrPage('DtlDataGridPanel');  
			
		}
		
		
		
	}
	
	if ('PMHandler'==control)
	{
	
		var distrObj = new InHandleSubScreen();
		distrObj.DemandID.setValue(DemandID);
						//alert(1);
		distrObj.winScreen.show();
						

	}
	//评价事件
	if ('FinPing'==control)
	{
	   var AppRet=objApply3.AppSelect(DemandID);
	   if (AppRet!=""){
	   Ext.MessageBox.confirm('确认框', '您已经评价过，是否要继续评价？',function(btn){
	   if (btn=="yes"){
	   try{
	    var distrObj = new Appraisal();
		distrObj.ImAppRowid.setValue(DemandID);
		distrObj.menuwind.show();
	   }catch(err){
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
	   }});
	   }
	   else {
	   try{
	    var distrObj = new Appraisal();
		distrObj.ImAppRowid.setValue(DemandID);
		distrObj.menuwind.show();
	   }catch(err){
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
	   
	   }
	   
      	
	}
	
	if ('PMEdit'==control)
	{
		//重置先不做了，后台程序需要重写
		//只作删除和提交
		//回执和完成
		objWinEdit = new InitwinScreen();
		objWinEdit.winfDemName.setValue(DemandDesc);   //姓名
		objWinEdit.winfDemName.disabled=true;
		objWinEdit.winfDemType.setValue(DemandType);  //类型
		objWinEdit.winfDemType.disabled=true;
		
		objWinEdit.winfEmergency.setValue(EmergDegree);  //紧急
		objWinEdit.winfEmergency.disabled=true;
		
		objWinEdit.cboDemUser.setValue(Engineer);  //gon
		objWinEdit.cboDemUser.disabled=true;
		
		objWinEdit.winfPhone.setValue(Serious);  //yanzhong
		objWinEdit.winfPhone.disabled=true;
		
		objWinEdit.cboDemMenu.setValue(MenuName);  //yanzhong
		objWinEdit.cboDemMenu.disabled=true;
		
		objWinEdit.winfDemDesc.setValue(DemSituation);  //yanzhong
		objWinEdit.winfDemDesc.disabled=true;
		
		
		objWinEdit.winfDemResult.setValue(DemandResult);  //yanzhong
		objWinEdit.winfDemResult.disabled=true;
		
		Ext.getCmp("chkActivePanel").hidden=true;
		
		
		//Ext.getCmp("textfield").disabled=true;
		
		
		
		
		
		
		
		
		objWinEdit.winScreen.show();
	}
	
	
  

  }
},  
this);  


}

//校验是否放出指派科室内部处理人的链接
function CheckHandler(demRowid,statuscode)
{
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var CheckHandler=objAudit.CheckInHandler(demRowid);
	//alert(statuscode)
	if ((CheckHandler =='')&&(statuscode=='002'))  //指定处理人为空，并且需求状态为'提交'
	{
		formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>详情</a>";
		formatStr += " | <a href='javascript:void({1});' onclick='javscript:return false;' class='PMHandler'>指派处理人</a>";
	}
	else
	{
		formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>详情</a>";
	}
							
	return formatStr;
	
	
}




//回执处理
function receiptScreenEvent(obj) {
	
	
	obj.LoadEvent = function(){
		obj.btnConfirm.on("click", obj.btnConfirm_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	
	
};
 obj.btnConfirm_click=function()
{
	//alert("分配人员");
	var DemandID=obj.DemandID.getValue();
	var note=obj.winfDemResult.getValue();
	//alert(DemandID+"^"+note);
	
	//alert(DemandID+"^"+DemHanderID+"^"+note);
	
	var receiptobj = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var  receiptRet=receiptobj.ReceiptInsert(note,DemandID);
	
	if ('0'==receiptRet)
	{
		Ext.MessageBox.alert('Status','回执成功！');
	}
	else
	{
		Ext.MessageBox.alert('Status','回执失败'+receiptRet);
	}
	
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel');
	
	
}

obj.btnCancel_click=function()
{
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel'); 
	
	
} 
	
	
	
	
	
	
}

//指定审核人事件
function toAuditSubScreenEvent(obj) {
	obj.LoadEvent = function(){
		obj.btnConfirm.on("click", obj.btnConfirm_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	
	
};
 obj.btnConfirm_click=function()
{
	//alert("分配人审核人");
	var DemandID=obj.DemandID.getValue();
	var AuditUserID=obj.cboAuditUser.getValue();
	//alert(AuditUserID);
	var note=obj.winAudiResult.getValue();
	var statusCode=obj.StatusCode.getValue();
	
	//alert(DemandID+"^"+statusCode+"^"+note);
	
	
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var str=DemandID+"^"+AuditUserID+"^"+note+"^"+"005";
	//alert(str);
	var  distriRet=objAudit.appointAuditor1(str);
	//var  distriRet=objAudit.adjustStatusSave(str);
	
	if ('0'==distriRet)
	{
		Ext.MessageBox.alert('Status','指定审核人成功！');
	}
	else
	{
		Ext.MessageBox.alert('Status','保存失败'+distriRet);
	}
	
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel');
	
	
}

obj.btnCancel_click=function()
{
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel'); 
	
	
} 
	
	
	
}

function AppraisalEvent(obj){
    var objApply3 = ExtTool.StaticServerObject("web.PMP.Common");
    var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var objApply2 = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	obj.LoadEvent = function(args){
		obj.ImAppUpdate.on("click", obj.ImAppUpdate_OnClick, obj);
		obj.ImAppDelete.on("click", obj.ImAppDelete_OnClick, obj);
	};
 obj.ImAppUpdate_OnClick=function (){
 var ImAppMenu=obj.ImAppText.getValue();  //整体评价
 var ImAppPJ1=obj.ImAppPJ1.getValue();
 var ImAppPJ2=obj.ImAppPJ2.getValue();
 var ImAppPJ3=obj.ImAppPJ3.getValue();
 var ImAppRowid=obj.ImAppRowid.getValue();
 if (ImAppPJ1==""){
  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '改进速度不能为空！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
 };
 if (ImAppPJ2==""){
  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '改进质量不能为空！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
 };
 if (ImAppPJ3==""){
  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '服务态度不能为空！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
 };
 var input=ImAppPJ1+"^"+ImAppPJ2+"^"+ImAppPJ3+"^"+ImAppRowid;
 var insetret=objApply3.insertApp(input,ImAppMenu);
 if (insetret=="0"){
 Ext.MessageBox.alert('Status','评价成功！');
 obj.menuwind.close();
 ExtTool.LoadCurrPage('DtlDataGridPanel');
 }
 else {
 Ext.Msg.show({
	          title : '温馨提示',
			  msg : '评价失败！，错误代码：'+insetret,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
 };
 };
 obj.ImAppDelete_OnClick=function (){
 obj.menuwind.close();
 };
}
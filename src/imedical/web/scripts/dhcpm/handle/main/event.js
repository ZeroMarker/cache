//Create by dongzt
// 20150121
//需求处理
var DemID;
function InitviewScreenEvent(obj) {
	var PMHandle=ExtTool.StaticServerObject("DHCPM.Handle.PMHandle");
	var PMMODE=ExtTool.StaticServerObject("web.PMP.Document");
	
	obj.LoadEvent = function(args){
		
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj); 
		//沟通记录提交
		obj.btnSubmit.on("click", obj.btnSubmit_OnClick, obj);
		//沟通记录更新
		obj.btnUpdate.on("click", obj.btnUpdate_OnClick, obj);  
		//状态更改
		obj.btnUpStatus.on("click", obj.btnUpStatus_OnClick, obj); 
		//问题记录提交
		obj.btnRecSubmit.on("click", obj.btnRecSubmit_OnClick, obj);
		//问题记录更新
		obj.btnRecUpdate.on("click", obj.btnRecUpdate_OnClick, obj);
		
		
		
		
		obj.DtlDataGridPanel.getSelectionModel().on('rowselect', function(sm, rowIdx, r) {
            
			//alert(r.data.DemandID)
			DemID=r.data.DemandID;
			var PMMODEret=PMMODE.ImplMode(DemID);
			obj.cboDemModule.setValue(PMMODEret.split("^")[0]); 
			obj.txtDuration.setValue(PMMODEret.split("^")[2]);
			obj.txtdeveloper.setValue(PMMODEret.split("^")[1]);
			obj.txtDemName.setValue(r.data.DemandDesc);
			//obj.cboDemStatus.setValue(r.data.DemandStatus);
		
        });

			
	};
	//问题记录提交
	obj.btnRecSubmit_OnClick=function(){
		
		var retResult=""
		
	if (obj.cboDemModule.getValue() !='')
		{
			retResult = PMHandle.checkModule(obj.cboDemModule.getValue());
			
		}
		if(retResult=='')
		{
			Ext.MessageBox.alert('Status', '请重新选择模块！');
			return;
			
		}
		else{
		var tmp1=DemID+"^";
	   tmp1 += retResult+"^";
	
	   //tmp1 += obj.cmbStatus.getValue() + "^";
	   tmp1 += obj.txtDuration.getValue() + "^";
	   tmp1 += obj.txtdeveloper.getValue() + "^";
	  tmp1 += obj.winHandRec.getValue();
		
		}
	
	if ((obj.winHandRec.getValue().length<10))
	{
		Ext.MessageBox.alert('警告', '处理记录必须超过10个字！');
		return false;
	}
	
	//alert(tmp1);
	 try
		{
			var ret = PMHandle.HanRecSubmit(tmp1);
			if (ret==0)
			{
				
				
				Ext.MessageBox.alert('Status', '更新成功！');
				obj.cboDemModule.setValue('');
				obj.txtDuration.setValue('');
				obj.txtdeveloper.setValue('');
				obj.winHandRec.setValue('');
			}
			else
			{
					ExtTool.alert("提示","保存失败!errCode="+ret);
				
			}
				ExtTool.LoadCurrPage('DtlDataGridPanel');  
				
			
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}  
	
	
		
	}
	//问题记录更新
	obj.btnRecUpdate_OnClick=function(){
		Ext.MessageBox.alert('Status','无更新数据！');
		
	}
	
	obj.btnUpStatus_OnClick=function(){
		var retResult="";
		var FinishTestRet=PMMODE.FinishTest();
	    var TestFinishUpdateRet=PMMODE.TestFinishUpdate();
		var demStatus =obj.cboDemStatus.getValue();
		
		//alert(demStatus);
		//return;
		if (demStatus =='')
		{
			Ext.MessageBox.alert('Status', '请重新选择需求状态！');
			return false;
		}
		if (demStatus !='')
		{
			retResult = PMHandle.checkStatus(demStatus);
		}
		//alert(retResult);
		if (retResult =='1')
		{
			Ext.MessageBox.alert('Status', '请重新选择需求状态！');
			return;
		}
		//alert(DemID);
		if ('undefined'==typeof(DemID)||(DemID==""))
		{
			Ext.MessageBox.alert('Status', '请先选中要更改的记录！');
			return false;
		}
		
			
		var paraStr=DemID+"^"+demStatus;
		//alert(paraStr);FinishTestRet
		var modedrret=PMMODE.IpmlModule(DemID);
		if((modedrret=="N")&&(demStatus==FinishTestRet.split(",")[0])&&(TestFinishUpdateRet.split(",")[0]=="Y")){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '您还未分配模块，不能将状态改变为测试!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
		 return;
		};
		if((modedrret=="N")&&(demStatus==FinishTestRet.split(",")[1])&&(TestFinishUpdateRet.split(",")[1]=="Y")){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '您还未分配模块，不能将状态改变为完成!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
		 return;
		};
		 try
		{
			var ret = PMHandle.UpdateStatus(paraStr);
			if (ret==0)
			{
				
				
				Ext.MessageBox.alert('Status', '更新成功！');
			}
			else
			{
					ExtTool.alert("提示","保存失败!errCode="+ret);
				
			}
				ExtTool.LoadCurrPage('DtlDataGridPanel');  
				
			
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}  
		
		
		
	}
	//沟通记录提交
	obj.btnSubmit_OnClick= function(){
	
		
		
	var retResult="";
	var tmp2 = DemID + "^";
	tmp2 += obj.ComDate.getRawValue() + "^";
	tmp2 += obj.ComTime.getRawValue() + "^";
	tmp2 += obj.txtComDuration.getValue() + "^";
	tmp2 += obj.cmbComWay.getValue() + "^";
	
	tmp2 += obj.txtHosStr.getValue() + "^";
	tmp2 += obj.txtPrjStr.getValue() + "^";
	tmp2 += obj.txtOtherStr.getValue() + "^";   
	tmp2 += obj.txtComNote.getValue() +"^";
	tmp2 += obj.txtLocation.getValue();
	
	
	//Ext.MessageBox.alert('Status', tmp2);
	ExtTool.alert("提示",tmp2)
	//return;
	
	//alert(obj.cmbComWay.getValue())
	
	if (obj.cmbComWay.getValue() !='')
		{
			retResult = PMHandle.checkStatus(obj.cmbComWay.getValue());
			
		}
		if(retResult=='1')
		{
			Ext.MessageBox.alert('Status', '请重新选择沟通方式！');
			return false;
			
		}
	
	if ((obj.ComDate.getRawValue()=="")||(obj.ComTime.getRawValue()=="")||(obj.txtComNote.getValue()==""))
	{
		Ext.MessageBox.alert('Status', '沟通日期，时间和沟通内容为必填项！');
		return false;
	}
	
	/* if((obj.txtComNote.getValue().length<10))
		{
			ExtTool.alert("提示","沟通内容必须大于10个字！")
			return false;	
		} */
		 
	
		 try
		{
			var ret = PMHandle.InsertPMCom(tmp2);
			if (ret==0)
			{
				
				
				Ext.MessageBox.alert('Status', '提交成功！');
				
				obj.ComDate.setValue("");
				obj.ComTime.setValue('');
				obj.txtComDuration.setValue('');
				obj.cmbComWay.setValue('');
				obj.txtHosStr.setValue('');
				obj.txtPrjStr.setValue('');
				obj.txtOtherStr.setValue('');
				obj.txtComNote.setValue('');
				obj.txtLocation.setValue('');
				
				
				
			}
			else
			{
					ExtTool.alert("提示","保存失败!errCode="+ret);
				
			}
				//ExtTool.LoadCurrPage('DtlDataGridPanel'); 
				//location="javascript:location.reload()";	////窗口关闭后刷新当前页面 	
				//parent.location="javascript:location.reload()";//窗口关闭后刷新父页面 				
				
			
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}  
		
	}
	//沟通记录更新
	obj.btnUpdate_OnClick= function(){
		
		Ext.MessageBox.alert('Status','请使用“提交”！');
		
	}
	
	
	
function connectStr()
{
	
	
	
	
	
	
	//沟通日期^沟通时间^沟通时长^沟通方式^院方与会人^公司与会人^其他与会人^沟通内容
	
	var tmp2 = obj.ComDate.getRawValue() + "^";
	tmp2 += obj.ComTime.getRawValue() + "^";
	tmp2 += obj.txtComDuration.getValue() + "^";
	tmp2 += obj.cmbComWay.getValue() + "^";
	
	tmp2 += obj.txtHosStr.getValue() + "^";
	tmp2 += obj.txtPrjStr.getValue() + "^";
	tmp2 += obj.txtOtherStr.getValue() + "^";   
	tmp2 += obj.txtComNote.getValue(); 
	
	Ext.MessageBox.alert('Status', tmp2);
	return tmp;
	
	
	if((obj.txtComNote.getValue().length<10))
		{
			ExtTool.alert("提示","沟通内容必须大于10个字！")
			return false;	
		}
		
    return tmp;
	
}
//**************************************************************
	
	
	
	obj.btnQuery_OnClick = function(){
		obj.DtlDataGridPanelStore.removeAll();
		obj.DtlDataGridPanelStore.load({params : {start:0,limit:20}});
	}
	obj.DtlDataGridPanel.on('cellclick', function (grid, rowIndex, columnIndex, e) { 
	

var rec = e.getTarget('.RecInsert'); 	

if (rec) 
  { 
	var t = e.getTarget(); 
	var control = t.className; 
	//alert(control)
	
	var w = Ext.getCmp('HandlePanal2');
            // expand or collapse that Panel based on its collapsed property state
            w.collapsed ? w.expand() : w.collapse();
  

   
  }
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
	var InHanderName=record.get("InHanderName");
	var EditDemDesc=record.get("EditDemDesc");
	var EditUser=record.get("EditUser");
	var control = t.className; 
	//alert(control);
	if ('Download'==control){
	DownLoadWind=new AdjunctAllWind(DemandID,"Improvement");
	DownLoadWind.AdjunctAllRowid.setValue(DemandID);
	DownLoadWind.AdjunctAllType.setValue('Improvement');
	DownLoadWind.menuwindContracAd.show();
	}
	//详情
	if ('PMDescription'==control)
	{
		
			objWinDetail = new InitDescScreen();
			//alert(DemandID);
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
			objWinDetail.winfDemDesc.disabled=true;
			objWinDetail.winfCreater.setValue(UserName); 
			objWinDetail.winfCreater.disabled=true;
			objWinDetail.winfLocation.setValue(LocName); //
			objWinDetail.winfLocation.disabled=true;
			objWinDetail.winfModule.setValue(PMModule); 
			objWinDetail.winfModule.disabled=true;
			objWinDetail.winfInHandler.setValue(InHanderName); 
			
			//var editNote="修改人:"+EditUser+"                                "+EditDemDesc;
			if(EditDemDesc!="")
			{objWinDetail.winfEditDemDesc.setValue(EditDemDesc);} 
			
			 //alert(DemandID)
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
	
	
  }
	

  
},  
this);  



}







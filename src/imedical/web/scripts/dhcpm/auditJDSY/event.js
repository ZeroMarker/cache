//Create by dongzt
//Create by dongzt
// 20150118


//需求审核
function InitviewScreenEvent(obj) {
	
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var PMHandle = ExtTool.StaticServerObject("DHCPM.Handle.PMHandle");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);  //查询事件
		//obj.btnApply.on("click", obj.btnApply_OnClick, obj);  //obj.
		
		obj.btnBatch.on("click", obj.btnBatch_OnClick, obj);  //批量审核 事件
		//obj.chkActive.on("check", obj.chkActive_check, obj);
		obj.btnBatchAll.on("click", obj.btnBatchAll_OnClick, obj);  //全审核 事件
		
		obj.btnBatchNot.on("click", obj.btnBatchNot_OnClick, obj);  //审核不通过事件  add by zzp 2015-04-20
			
	};
	
	obj.chkActive_check=function(){
		//obj.DtlDataGridPanel.getSelectionModel().selectRecords();
	
		/* var array = Ext.getCmp('gridPMQueryCheckCol').items;  
                        array.each(function(item){  
						item.setValue(true);}
		//alert(obj.chkActive.getValue()); */
		if(obj.chkActive.getValue())
		{
			//obj.DtlDataGridPanel.getSelectionModel().selectAll();
			//alert(obj.DtlDataGridPanel.getSelectionModel().selectAll()); //.getSelections()
			 for(var batchNum = 0; batchNum < obj.DtlDataGridPanelStore.getCount(); batchNum++)
			{	
		 	var objbatch = obj.DtlDataGridPanelStore.getAt(batchNum);
			//alert(objbatch.get("checked"));
			//objbatch.get("checked").setValue(true);
			objbatch.set(objbatch.get("checked"), true);
			//alert(objbatch.get("checked"));
			//obj.DtlDataGridPanel.CheckboxSelectionModel().selectRow(batchNum);
			}	
		}	
	}
	
	//全审核
	obj.btnBatchAll_OnClick= function(){
		Ext.MessageBox.alertalert('提示','暂时不用,请使用批量审核');
		return;
	}
	
	//批量审核
	obj.btnBatch_OnClick= function()
	{
	    if(obj.toHandle.checked!=true){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '非“需处理”下不能进行审核',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	       return;
		};
		//alert(obj.DtlDataGridPanelStore.getCount());
		var demRowIDList1 = "";
		var demRowIDList2 = "";
		for(var batchNum = 0; batchNum < obj.DtlDataGridPanelStore.getCount(); batchNum++){
			var objbatch = obj.DtlDataGridPanelStore.getAt(batchNum);
			if (objbatch.get("checked")) 
			{
				//*******add by zzp 2015-04-20  start*******
				if(demRowIDList1 != "") 
				{
				demRowIDList1 += "^"
				demRowIDList1 += objbatch.get("DemandID");
				}
				else 
				{
					demRowIDList1=objbatch.get("DemandID");
				};
				
				//*******add by zzp 2015-04-20  end*******
				/*  edit by zzp 2015-04-20  
				if('提交'==objbatch.get("DemandStatus"))
					{
						if(demRowIDList1 != "") demRowIDList1 += "^"
						demRowIDList1 += objbatch.get("DemandID");
					}
				if('审核1'==objbatch.get("DemandStatus"))
					{
						if(demRowIDList2 != "") demRowIDList2 += "^"
						demRowIDList2 += objbatch.get("DemandID");
					}
			*/
			}
		}
		//alert(demRowIDList1+"       "+demRowIDList2);
		//只做提交审核 ，没做二级的批量审核，可以做但是二级需要指派人员
		var firstlevel=demRowIDList1.split('^');
		var flevelret=""
		if(firstlevel!=""){
		for(var i=0;i<firstlevel.length;i++){
		//alert(firstlevel);
			if (firstlevel[i] !=''){
				//alert(firstlevel[i]);
				flevelret=objAudit.FirLevelSave(firstlevel[i]);
				var lev=flevelret.split('^')[1];    
				//"RevList"代表需审核列表审核   "loc"代表科室审核   数字代表权限级别审核的级别数  
				//以下是判断程序是否需要弹出一些科室分配或者项目分配的界面；
				if ((lev>0)&(lev<10000000)){
					var levret=objAudit.FirLevelev(lev);
					
					//判断是否是项目办审核通过，如果项目办审核通过则需要分配审核人；
					if(levret.split('^')[2]==lev){
						
				     //判断是否要弹出提示窗口  Y需要弹窗 ，else其他情况不弹窗
				      
				     if(levret.split('^')[3]=="Y"){
					 try{
			            var mytrn=Ext.MessageBox.confirm('confirm','是否马上分配需求负责人？',levretfun);
						 return;
				          function levretfun(id){
						   if(id=='yes'){
	                          distrObj = new DistrSubScreen();
	                          distrObj.DemandID.setValue(firstlevel[i]);
	                          distrObj.winScreen.show();
	                         }
	                      };
					 }catch(err)
			         {
				        ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			         } 
	                   }
					   else {
						   distrObj = new DistrSubScreen();
						   distrObj.DemandID.setValue(firstlevel[i]);
						   distrObj.winScreen.show();
						   }
						};
					//判断是否需要分配科室等
					if(levret.split('^')[1]=="F"){
						alert(levret.split('^')[1]);
						audiObj = new toAuditSubScreen();
						audiObj.DemandID.setValue(firstlevel[i]);
						audiObj.winScreen.show();
						};
			       //判断是否需要院长什么
					if(levret.split('^')[0]!=""){
						var objts=levret.split('^')[0].split('@')[1];
						var objdesc=levret.split('^')[0].split('@')[2];
						if (objts!=""){
							var mytrn=Ext.MessageBox.confirm('confirm', '是否需要由:'+objdesc+'审核？',objtsfun );
							return;
							function objtsfun(id){
								if(id="yes"){
								    var objyz=objAudit.SetYzshY(firstlevel[i]);
								    if(objyz!="0"){
										Ext.MessageBox.alert('Status', '数据保存失败：'+objyz);
									};
								};
							};
					    };
					};
				};
			    if(flevelret.split('^')[0]!='0'){
				Ext.MessageBox.alert('提示',"错误代码：SQLCODE="+flevelret);
			} ;
		    };
			};
			Ext.MessageBox.alert('Status', '批量审核完成');
		    ExtTool.LoadCurrPage('DtlDataGridPanel'); 
		}
        else{
			Ext.MessageBox.alert('Status', '没有选中的审批列表');
		}
		//var objAudit  objAudit.FirLevelSave(DemandID);
	}
	//审核不通过事件处理程序  
	//add by zzp 2015-04-20   ******start*********
	obj.btnBatchNot_OnClick=function (){
	if(obj.toHandle.checked!=true){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '非“需处理”下不能进行审核',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	       return;
		};
		var demRowIDList1 = "";
		//获取界面勾选上的数据的Rowid 并将其值通过^组合到demRowIDList1字符串里面;
		for(var batchNum = 0; batchNum < obj.DtlDataGridPanelStore.getCount(); batchNum++)
		{
			var objbatch = obj.DtlDataGridPanelStore.getAt(batchNum);
			if (objbatch.get("checked")) {
				audiObj = new toNotSubScreen();
	            audiObj.NotRowid.setValue(objbatch.get("DemandID"));
		        audiObj.winNot.show();
		         return;
				if(demRowIDList1 != "") {
					demRowIDList1 += "^"
				demRowIDList1 += objbatch.get("DemandID");
				}
				else {
					demRowIDList1=objbatch.get("DemandID");
					};
			}
		};
		if (demRowIDList1==""){
			Ext.MessageBox.alert('Status', '没有选中的审批列表');
			}
	};
	//add by zzp 2015-04-20   ******end*********
	obj.btnQuery_OnClick = function(){
		obj.DtlDataGridPanelStore.removeAll();
		obj.DtlDataGridPanelStore.load({params : {start:0,limit:20}});
	}
obj.DtlDataGridPanel.on('cellclick', function (grid, rowIndex, columnIndex, e) {  

 
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
	//需改需求
	if ('UpdateIPML'==control){
	  if(obj.toHandle.checked!=true){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '您不能进行修改！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	       return;
		};
		DownLoadWind=new EditWind(DemandID,'Approval');
	    DownLoadWind.menuwindadd.show();
	}
	//修改状态
	if('PMStatusChange'==control)
	{
		
		
				var DemStatus=obj.cboDemStatus.getValue();
				var DemRawStatus=obj.cboDemStatus.getRawValue();
				//alert(DemStatus+"!!"+DemRawStatus);
				
					
				var myrtn=Ext.MessageBox.confirm('confirm', '您确定要修改这条需求的状态',funstatus);
					
					
				function funstatus(id)
				{
					//alert('单击的按钮id是：'+id); 
					if (id=='yes')
					{
						
						if (DemStatus !='')
						{
							retResult = PMHandle.checkStatus(DemStatus);
						}
		
						if (retResult =='1')
						{
							Ext.MessageBox.alert('Status', '请重新选择需求状态！');
							return;
						}
		
		
			
							var paraStr=DemandID+"^"+DemStatus;
		
		
		
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
				
			
			
							}catch(err){
							
								ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
							} 
						
						
					}
					
					
				}
					
				
			
		
		
	}
	
	//科室审核 
	//科室也会指派相关的人员负责
	if ('PMAgree'==control)
	{
		var level1=0,level2=0;
	
		var level=objAudit.AuditAuthority();
		
		var levelArray=level.split("^");
		//alert(levelArray[0]);
		  for(var i=0;i<levelArray.length;i++)
		{
			//alert(levelArray[i]);
			if ('1'==levelArray[i])
			{
				level1='1';
			}
			if ('2'==levelArray[i])
			{
				level2='2';
			}
			if ('3'==levelArray[i])
			{
				level2='3';
			}
			if ('4'==levelArray[i])
			{
				level2='4';
			}
			if ('5'==levelArray[i])
			{
				level2='5';
			}
			
		} 
		var AuthModeRet=objAudit.CheckAuthMode();
		//alert(AuthModeRet)
		//return;
		 //一级审核
		 if((('007'==DemStatusCode)||('002'==DemStatusCode))&&('1'==level1))
		{
			
			
						//.........
						//------CheckAuthMode-----------------
						
						if (AuthModeRet=="AM001")
						{
								
							try
							{
								var newStr=DemandID+"^"+"009"
								//var aurRet=objAudit.SecLevelSave(DemandID);
								var aurRet=objAudit.adjustStatusSave(newStr);
						
								if('0'==aurRet)
								{
										var myrtn=Ext.MessageBox.confirm('confirm', '审核通过请指定需求负责人',fun);
										function fun(id)
										{
											if (id=='yes')
											{
								
												distrObj = new DistrSubScreen();
												distrObj.DemandID.setValue(DemandID);
								
												distrObj.winScreen.show();
								
								
											}
											else
											{
												Ext.MessageBox.alert('Status', '审核成功！');
												//ExtTool.LoadCurrPage('DtlDataGridPanel');
											}
						
										}
								}
								else
								{
									Ext.MessageBox.alert('Status', '审核失败：'+aurRet);
								}
									ExtTool.LoadCurrPage('DtlDataGridPanel');  
							}
							catch(err){
								ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
							}
						}
						
						if (AuthModeRet=="AM002")
						{
							
							//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
			
							var myrtn=Ext.MessageBox.confirm('confirm', '是否需要先由其他科室的人审核？',funadd);
							function funadd(id)
							{
					
								if (id=='yes')
								{
									audiObj = new toAuditSubScreen();
									audiObj.DemandID.setValue(DemandID);
									audiObj.winScreen.show();
								}
								else
								{
						
									var aurRet=objAudit.FirLevelSave(DemandID);
									try
									{
										if('0'==aurRet)
										{
											Ext.MessageBox.alert('Status', '审核成功！');
										}
										else
										{
											Ext.MessageBox.alert('Status', '审核失败：'+aurRet);
										}
											ExtTool.LoadCurrPage('DtlDataGridPanel');  
									}
									catch(err){
										ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
									}
								}
					
							}
						//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
						}
						
					
		}
		
		
		 //二级审核
		 if(('004'==DemStatusCode)&&('2'==level2))
		{
			try
			{
				var newStr=DemandID+"^"+"009"
				//var aurRet=objAudit.SecLevelSave(DemandID);
				var aurRet=objAudit.adjustStatusSave(newStr);
				//var aurRet=0;
				
				if('0'==aurRet)
				{
					//Ext.MessageBox.alert('Status', '审核成功！');
					var myrtn=Ext.MessageBox.confirm('confirm', '审核通过请指定需求负责人',fun);
					
					
				function fun(id)
				{
					//alert('单击的按钮id是：'+id); 
					if (id=='yes')
					{
						
						//alert(2);
						distrObj = new DistrSubScreen();
						distrObj.DemandID.setValue(DemandID);
						//alert(1);
						distrObj.winScreen.show();
						
						
						//-------------------------------------
						
						 /* var errStr = objApply.SubmitApplication(ret.split("^")[1]);
						if (errStr=="0")
						{
							//alert(errStr);
							Ext.MessageBox.alert('Status', '提交成功！');
						
      		 
						}
						else
						{
							Ext.MessageBox.alert('Status','保存失败!errCode='+errStr);
							obj.winScreen.close();
						}  */
					}
					else
					{
						Ext.MessageBox.alert('Status', '保存成功！');
						ExtTool.LoadCurrPage('DtlDataGridPanel');
					}
					//  
						//obj.winScreen.close();
				}
					
				}
				else
				{
					Ext.MessageBox.alert('Status', '审核失败：'+aurRet);
				}
				 
			}
			catch(err){
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
			
		}


		//@@@@@
		//指定审核人审核
		
		var userId=session['LOGON.USERID'];
		
		var toaudiRet=objAudit.checktoAudit(userId,DemandID);
		//alert(toaudiRet)
		 if('0'!=toaudiRet)
		{
						var str=DemandID+"^"+"007";
						var aurRet=objAudit.adjustStatusSave(str);
						//alert(str+" "+ aurRet)
						try
						{
							if('0'==aurRet)
							{
								Ext.MessageBox.alert('Status', '审核成功！');
							}
							else
							{
								Ext.MessageBox.alert('Status', '审核失败：'+aurRet);
							}
							ExtTool.LoadCurrPage('DtlDataGridPanel');  
						}
						catch(err){
							ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
						}
				
			
			
			
			
			
			
			
		}

		
		
	}
	
	if ('PMHandler'==control)
	{
	
		var distrObj = new DistrSubScreen();
		distrObj.DemandID.setValue(DemandID);
						//alert(1);
		distrObj.winScreen.show();
						

	}
	
	if('PMDisagree'==control)
	{
		var disObj = new DisAgreeScreen();
		disObj.DemandID.setValue(DemandID);
						//alert(1);
		disObj.winScreen.show();
	}
	
  }
	

  
},  
this);  



}

//2级审核
function checkLevel1()
{
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
							var level1=0,level2=0;
							var level=objAudit.AuditAuthority();
							var levelArray=level.split("^");
							//alert(levelArray.length);
							  for(var i=0;i<levelArray.length;i++)
							{
								//alert(levelArray[i]);
								if ('1'==levelArray[i])
								{
									level1='1';
								}
								if ('2'==levelArray[i])
								{
									level2='2';
								}
								
							}
							
							
							if ('2'==level2)
							{
								formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>详情</a>";
								formatStr += " | <a href='javascript:void({1});' onclick='javscript:return false;' class='PMAgree'>同意</a>";
								formatStr += " | <a href='javascript:void({2});' onclick='javscript:return false;' class='PMDisagree'>不同意</a>";
							}
							else
							{
								formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>详情</a>";
							}
							
							return formatStr;
}

//1级审核
function checkLevel2()
{
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	
	
	
							var level1=0,level2=0;
	
							var level=objAudit.AuditAuthority();
							var levelArray=level.split("^");
							//alert(levelArray.length);
							  for(var i=0;i<levelArray.length;i++)
							{
								//alert(levelArray[i]);
								if ('1'==levelArray[i])
								{
									level1='1';
								}
								if ('2'==levelArray[i])
								{
									level2='2';
								}
								
							}
							
							
							if ('1'==level1)
							{
								formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>详情</a>";
								formatStr += " | <a href='javascript:void({1});' onclick='javscript:return false;' class='PMAgree'>同意</a>";
								formatStr += " | <a href='javascript:void({2});' onclick='javscript:return false;' class='PMDisagree'>不同意</a>";
							}
							
							
							else
							{
								formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>详情</a>";
							}
							
							return formatStr;
}

//校验改用是否有超级权限
function checkSuperAuth()
{
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var userId=session['LOGON.USERID'];
	var Result=objAudit.CheckSuperAuth(userId);
	if (Result=='Y')
	{
		formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMStatusChange'>修改状态</a>";
								
	}
	else
	{
		formatStr ="";		
	}
					
	return formatStr;					
							
							
	
							
							
}

function checktoAudi(DemandID)
{
	var userId=session['LOGON.USERID'];
	
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var ret=objAudit.checktoAudit(userId,DemandID);
	
	if ('0'!=ret)
	{
		formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>详情</a>";
		formatStr += " | <a href='javascript:void({1});' onclick='javscript:return false;' class='PMAgree'>同意</a>";
		formatStr += " | <a href='javascript:void({2});' onclick='javscript:return false;' class='PMDisagree'>不同意</a>";
	}						
	else
	{
		formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'>详情</a>";
	}
							
	return formatStr;
	
}


 
							
							


//校验是否放出指派联系人的链接
function CheckHandler(demRowid,statuscode)
{
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var CheckHandler=objAudit.CheckHandler(demRowid);
	//alert(statuscode)
	//if ((CheckHandler =='')&&(statuscode=='009'))
	if (CheckHandler =='')
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




function DistrSubScreenEvent(obj) {
	obj.LoadEvent = function(){
		obj.btnDistribute.on("click", obj.btnDistribute_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	
	
};
 obj.btnDistribute_click=function()
{
	//alert("分配人员");
	var DemandID=obj.DemandID.getValue();
	var DemHanderID=obj.cboDemUser.getValue();
	var note=obj.winfDemResult.getValue();
	
	//alert(DemandID+"^"+DemHanderID+"^"+note);
	
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var  distriRet=objAudit.distribution(DemHanderID,DemandID,note);
	
	if ('0'==distriRet)
	{
		Ext.MessageBox.alert('Status','分配成功！');
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

//信息科指定审核人事件
function toAuditSubScreenEvent(obj) {
	obj.LoadEvent = function(){
		obj.btnConfirm.on("click", obj.btnConfirm_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	
	
};
 obj.btnConfirm_click=function()
{
	//alert("分配人员");
	var DemandID=obj.DemandID.getValue();
	var AuditUserID=obj.cboAuditUser.getValue();
	var note=obj.winAudiResult.getValue();
	
	//alert(DemandID+"^"+DemHanderID+"^"+note);
	
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var str=DemandID+"^"+AuditUserID+"^"+note;
	var  distriRet=objAudit.appointAuditor1(str);
	
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

//disagree
function DisAgreeScreenEvent(obj) {
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
	
	var disagreeobj = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var  distriRet=disagreeobj.DisAgreeInsert(note,DemandID);
	
	if ('0'==distriRet)
	{
		Ext.MessageBox.alert('Status','审核成功！');
	}
	else
	{
		Ext.MessageBox.alert('Status','审核失败'+distriRet);
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

//审核不通过事件

function toNotSubScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	obj.LoadEvent = function(){
	obj.btnNotY.on("click", obj.btnNotY_click, obj);
	obj.btnNotN.on("click", obj.btnNotN_click, obj);
};

obj.btnNotY_click=function()
{
	//获取后台配置，不通过Y/直接返回给体需求用户 N/逐级返回; 可以配置用户
	var BatchNotType=objAudit.BatchNotType();
	var Rowid=obj.NotRowid.getValue();
	var Menu=obj.WinNotMenuid.getValue();
	if(Menu.length<5){
		Ext.MessageBox.alert('提示','原因不能太少额！-^^5个字额^^_')
		return;
		};
	
	flevelret=objAudit.FirLevelSaveNot(Rowid,Menu,BatchNotType);
	//0-完成;-1-未选中数据;-2-未配置审核不通过状态 ;-3-暂时怎能将审核不通过返回状态配置为Y
	if(flevelret!='0')
	{
		Ext.MessageBox.alert('提示',"操作失败，错误代码："+flevelret);
		ExtTool.LoadCurrPage('DtlDataGridPanel'); 
		return;			
		} 
	else {
		Ext.MessageBox.alert('提示', '审批完成');
		ExtTool.LoadCurrPage('DtlDataGridPanel'); 
		}
	obj.winNot.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel'); 
	};
obj.btnNotN_click=function()
{
	obj.winNot.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel'); 
	};
}


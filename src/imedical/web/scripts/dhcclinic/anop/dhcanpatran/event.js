function InitWinScreenEvent(obj)
{
	var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	var _DHCOPPatTran=ExtTool.StaticServerObject('web.DHCOPPatTran');
	var intReg=/^[1-9]\d*$/;
	obj.LoadEvent = function(args)
	{
     var userId=session['LOGON.USERID'];
     var GROUPDESC=session['LOGON.GROUPDESC'];
	 var GROUPID=session['LOGON.GROUPID'];
	 if((appType=="")&&(GROUPDESC.indexOf("病区护士")!=-1))
		{
			if(GROUPID=="446") //446：病区护士长
			{appType="Nurse";}
			else{appType="ward";}	
		}
	
	 InitialElement()
	if ((opaId!="")||(EpisodeID!=""))
	  {
	     
		var operInfo=_DHCOPPatTran.GetOpaIdByAdmIdNew(EpisodeID)
		if(operInfo=="")
		{
			alert("病人目前没有手术");
			//parent.window.close();
		}
		else
		{
			var opaIdInfoList=_DHCOPPatTran.GetOperArrangeInfo(operInfo);
		 	obj.txtopaIdInfoList.setValue(opaIdInfoList);
		}
		if(opaId!="")
		{
			obj.comopaId.setValue(opaId);
		}
		var retStr0=_DHCOPPatTran.GetPatInfoByAdmId(EpisodeID)
		var appList=retStr0.split("^");
		LoadData(appList)
	   }
	 }
	 function LoadData(appList)
	 {

       obj.txtPatname.setValue(appList[3]); //姓名
	   obj.txtMedCareNo.setValue(appList[2]); //住院号
	   obj.txtPatSex.setValue(appList[4]); //性别
	   obj.txtPatAge.setValue(appList[5]); //年龄
	   obj.txtPatLoc.setValue(appList[1]); //病人科室
	   
	   if(opaId!=""){
		//病区信息显示
	   LoadWardData(EpisodeID,opaId);
	   //手术室信息显示
	   LoadOPData(EpisodeID,opaId);
	   //PACU信息显示
	   LoadPACUData(EpisodeID,opaId);
	   }
	   
	   
	   
	 }
	 //病区
	function LoadWardData(EpisodeID,opaId)
	{
    var ret2= _DHCOPPatTran.GetPatInfoById(EpisodeID,opaId,"OB")
    if (ret2!="")
    {
	   var checkList=ret2.split("^");
	   var chkconsciousness=checkList[0];   //意识状态
	   obj.chkconsciousness.setValue(Name='consciousness', inputValue=chkconsciousness,checked=true);
		var chkskin=checkList[1];	//皮肤情况
		obj.chkskin.setValue(Name='skin', inputValue=chkskin, checked=true);
		var chkIsTube=checkList[2];	//胃管
		obj.chkIsTube.setValue(Name='IsTube', inputValue=chkIsTube, checked=true);
	 	var chkIsinfusion=checkList[3];	//输液
	 	obj.chkIsinfusion.setValue(Name='Isinfusion', inputValue=chkIsinfusion, checked=true);
	 	var chkIsCatheter=checkList[4];	//尿管
	 	obj.chkIsCatheter.setValue(Name='IsCatheter', inputValue=chkIsCatheter, checked=true);
	 	var chkIsTracintubation=checkList[5];	//气管插管
	 	obj.chkIsTracintubation.setValue(Name='IsTracintubation', inputValue=chkIsTracintubation, checked=true);
	 	var chkIsOxygentube=checkList[6];	//吸氧管
	 	obj.chkIsOxygentube.setValue(Name='IsOxygentube', inputValue=chkIsOxygentube, checked=true);
	 	var chkIsDrainagetube=checkList[7];	//引流管
	 	obj.chkIsDrainagetube.setValue(Name='IsDrainagetube', inputValue=chkIsDrainagetube, checked=true);
	 	var chkIsCase=checkList[8];	//病历
	 	obj.chkIsCase.setValue(Name='IsCase', inputValue=chkIsCase, checked=true);
	 	var chkIsTakemedicine=checkList[9];	//术中带药
	 	obj.chkIsTakemedicine.setValue(Name='IsTakemedicine', inputValue=chkIsTakemedicine, checked=true);
    } 
    var ret5=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,opaId,"OB")
    if (ret5!="")
    {
		var data=ret5.split("^")
		obj.txtskin.setValue(data[0]);	//具体情况
	   	obj.Panel60Num.setValue(data[2]);	//引流管数量
	    obj.Panel70Num.setValue(data[9]);	//术中带药数量
	    obj.PaneXlightNum.setValue(data[10]);//X光片数量
	    obj.txtwardqt.setValue(data[1]);		//其他
	    obj.txtPatBP.setValue(data[3]);		//BP
	   	obj.txtPatP.setValue(data[4]);			//P
	    obj.txtPatT.setValue(data[5]);			//T
	    obj.txtOperator.setValue(data[6]);	//操作人
	    obj.txtOperatortime.setValue(data[12]);//操作时间
		var Transitman=_DHCOPPatTran.GetNameInfoByCode(data[8]);
		obj.txtTransitman.setValue(Transitman);//转运人
		var GROUPID=session['LOGON.GROUPID'];
		if((data[6]=="")&&((appType=="OP")||(GROUPID=="582")||(GROUPID=="838")||(GROUPID=="841")))	//临时保存不让手术室看到内容
		{
			obj.txtPatBP.setValue('');
			obj.txtPatP.setValue('');
			obj.txtPatT.setValue('');
			obj.chkconsciousness.setValue('');
			obj.chkskin.setValue('');
			obj.txtskin.setValue('');
			obj.chkIsTube.setValue('');
			obj.chkIsinfusion.setValue('');
			obj.chkIsCatheter.setValue('');
			obj.chkIsTracintubation.setValue('');
			obj.chkIsOxygentube.setValue('');
			obj.chkIsDrainagetube.setValue('');
			obj.Panel60Num.setValue('');
			obj.chkIsCase.setValue('');
			obj.chkIsTakemedicine.setValue('');
			obj.Panel70Num.setValue('');
			obj.PaneXlightNum.setValue('');
			obj.txtwardqt.setValue('');
			obj.txtOperator.setValue('');
			obj.txtOperatortime.setValue('');
			obj.txtTransitman.setValue('');
			obj.txtAuditTime.setValue('');
			obj.txtHandoverperson.setValue('');
			obj.txtwardReq.setValue('');
		}
    }
    //审核人、交接人
   var retB=_DHCOPPatTran.GetConfirmTime(EpisodeID,opaId,"OB")
   if(retB!=0)
   {
		retB=retB.split("^")
		obj.txtAuditTime.setValue(retB[1]);
		obj.txtHandoverperson.setValue(retB[2]);
   } 
   //备注
  var rets=_DHCOPPatTran.GetWardNote(opaId,"OB")
  obj.txtwardReq.setValue(rets);
  
	  	  
}
    //手术室
	function LoadOPData(EpisodeID,opaId)
	{
    var ret1= _DHCOPPatTran.GetPatInfoById(EpisodeID,opaId,"OI")
    if (ret1!="")
    {
	   var checkList=ret1.split("^");
	   var chkPatientTo=checkList[0];   //病人去向
	   obj.chkPatientTo.setValue(Name='PatientTo', inputValue=chkPatientTo, checked=true);
	   var chkopconsciousness=checkList[1];   //意识状态
	   obj.chkopconsciousness.setValue(Name='opconsciousness', inputValue=chkopconsciousness,checked=true);
		var chkopskin=checkList[2];	//皮肤情况
		obj.chkopskin.setValue(Name='opskin', inputValue=chkopskin, checked=true);
		var chkopIsTube=checkList[3];	//胃管
		obj.chkopIsTube.setValue(Name='opIsTube', inputValue=chkopIsTube, checked=true);
	 	var chkopIsinfusion=checkList[4];	//输液
	 	obj.chkopIsinfusion.setValue(Name='opIsinfusion', inputValue=chkopIsinfusion, checked=true);
	 	var chkopIsCatheter=checkList[5];	//尿管
	 	obj.chkopIsCatheter.setValue(Name='opIsCatheter', inputValue=chkopIsCatheter, checked=true);
	 	var chkopIsTracintubation=checkList[6];	//气管插管
	 	obj.chkopIsTracintubation.setValue(Name='opIsTracintubation', inputValue=chkopIsTracintubation, checked=true);
	 	
	 	var chkopIsDrainagetube=checkList[7];	//引流管
	 	obj.chkopIsDrainagetube.setValue(Name='opIsDrainagetube', inputValue=chkopIsDrainagetube, checked=true);
	 	var chkopIsCase=checkList[8];	//病历
	 	obj.chkopIsCase.setValue(Name='opIsCase', inputValue=chkopIsCase, checked=true);
	 	var chkopIsTakemedicine=checkList[9];	//术中带药
	 	obj.chkopIsTakemedicine.setValue(Name='opIsTakemedicine', inputValue=chkopIsTakemedicine, checked=true);
    } 
    var ret4=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,opaId,"OI")
    if (ret4!="")
    {
		var data=ret4.split("^")
		obj.txtopskin.setValue(data[0]);	//具体情况
	   	obj.Panel143Num.setValue(data[2]);	//引流管数量
	    obj.PaneopXlightNum.setValue(data[6]);//X光片数量
	    obj.txtopqt.setValue(data[1]);		//其他
	    obj.txtopOperator.setValue(data[3]);	//操作人
	    obj.txtopOperatortime.setValue(data[7]);//操作时间
		var opTransitman=_DHCOPPatTran.GetNameInfoByCode(data[5]);
		obj.txtopTransitman.setValue(opTransitman);//转运人
    }
     //审核人、交接人
   var retB2=_DHCOPPatTran.GetConfirmTime(EpisodeID,opaId,"OI")
   if(retB2!=0)
   {
		retB2=retB2.split("^")
		obj.txtopAuditTime.setValue(retB2[1]);
		obj.txtopHandoverperson.setValue(retB2[2]);
   }
   
   }
   //PACU
	function LoadPACUData(EpisodeID,opaId)
	{
    var ret3= _DHCOPPatTran.GetPatInfoById(EpisodeID,opaId,"OO")
    if (ret3!="")
    {
	   	var checkList=ret3.split("^");
	   	var chkpacuPatientTo=checkList[0];   //病人去向
	   	obj.chkpacuPatientTo.setValue(Name='pacuPatientTo', inputValue=chkpacuPatientTo, checked=true);
	   	var chkpacuconsciousness=checkList[1];   //意识状态
	   	obj.chkpacuconsciousness.setValue(Name='pacuconsciousness', inputValue=chkpacuconsciousness,checked=true);
		var chkpacuskin=checkList[2];	//皮肤情况
		obj.chkpacuskin.setValue(Name='pacuskin', inputValue=chkpacuskin, checked=true);
		var chkpacuIsTube=checkList[3];	//胃管
		obj.chkpacuIsTube.setValue(Name='pacuIsTube', inputValue=chkpacuIsTube, checked=true);
	 	var chkpacuIsinfusion=checkList[4];	//输液
	 	obj.chkpacuIsinfusion.setValue(Name='pacuIsinfusion', inputValue=chkpacuIsinfusion, checked=true);
	 	var chkpacuIsCatheter=checkList[5];	//尿管
	 	obj.chkpacuIsCatheter.setValue(Name='pacuIsCatheter', inputValue=chkpacuIsCatheter, checked=true);
	 	var chkpacuIsTracintubation=checkList[6];	//气管插管
	 	obj.chkpacuIsTracintubation.setValue(Name='pacuIsTracintubation', inputValue=chkpacuIsTracintubation, checked=true);
	 	var chkpacuIsOxygentube=checkList[7];	//吸氧管
	 	obj.chkpacuIsOxygentube.setValue(Name='pacuIsOxygentube', inputValue=chkpacuIsOxygentube, checked=true);
	 	var chkpacuIsDrainagetube=checkList[8];	//引流管
	 	obj.chkpacuIsDrainagetube.setValue(Name='pacuIsDrainagetube', inputValue=chkpacuIsDrainagetube, checked=true);
	 	var chkpacuIsCase=checkList[9];	//病历
	 	obj.chkpacuIsCase.setValue(Name='pacuIsCase', inputValue=chkpacuIsCase, checked=true);
    } 
    var ret6=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,opaId,"OO")
    if (ret6!="")
    {
		var data=ret6.split("^")
		obj.txtpacuskin.setValue(data[0]);	//具体情况
	   	obj.pacufPanel6Num.setValue(data[2]);	//引流管数量
	    obj.PanepacuXlightNum.setValue(data[10]);//X光片数量
	    obj.txtpacuqt.setValue(data[1]);		//其他
	    obj.txtpacuP.setValue(data[3]);		//P
	    obj.txtpacuR.setValue(data[4]);		//R
	    obj.txtpacuBP.setValue(data[5]);		//BP
	    obj.txtpacuSaO.setValue(data[6]);		//SaO
	    obj.txtpacuOperator.setValue(data[7]);	//操作人
	    obj.txtpacuOperatortime.setValue(data[11]);//操作时间
		var pacuTransitman=_DHCOPPatTran.GetNameInfoByCode(data[9]);
		obj.txtpacuTransitman.setValue(pacuTransitman);//转运人
    }
    //审核人、交接人
   var retB3=_DHCOPPatTran.GetConfirmTime(EpisodeID,opaId,"OO")
   if(retB3!=0)
   {
		retB3=retB3.split("^")
		obj.txtpacuAuditTime.setValue(retB3[1]);
		obj.txtpacuHandoverperson.setValue(retB3[2]);
   }
    
   //登录角色分配权限
   }
	 function InitialElement()
	{
     DisableBaseInfo();
     switch(appType)
	  {
		case "ward":
			obj.contentTab.setActiveTab("wardPanel")//显示病区填写
			DisableOPPanel();
			DisablePACUPanel();
			DisablePACUPanel();
			obj.NurPanel.disable();
			break;
		case "PACU":
			obj.contentTab.setActiveTab("PACUPanel");//进入显示手术填写项
		   	obj.comopaId.disable();
		    obj.txtopaIdInfoList.disable();
		    DisablewardPanel();
		    DisableOPPanel();
		    obj.NurPanel.disable();
		    btncollect();
			break;
		case "OP":
			obj.contentTab.setActiveTab("opPanel");//进入显示手术填写项
			obj.comopaId.disable();
		    obj.txtopaIdInfoList.disable();
		    DisablewardPanel();
		    DisablePACUPanel();
		    obj.NurPanel.disable();
		    btncollect();
		   break;
		 case "Nurse":
			var GROUPID=session['LOGON.GROUPID'];
			if(GROUPID=="988")
			{
				obj.contentTab.setActiveTab("PACUPanel")//显示PACU填写
			}else if(GROUPID=="446")
			{
				obj.contentTab.setActiveTab("wardPanel")//显示病区填写
			}else
			{
				obj.contentTab.setActiveTab("opPanel");//显示手术填写项
			}
		 	
		 	if(GROUPID=="446")	//病区护士长安全组
			{
				DisableOPPanel();
				DisablePACUPanel();
				obj.NurPanel2.hide();
				obj.NurPanel3.hide();
			}else if(GROUPID=="988")	//麻醉PACU护士长
			{
				DisablewardPanel();
				DisableOPPanel();
				obj.NurPanel1.hide();
				obj.NurPanel2.hide();
				var PatInfoConfirmFlag7= _DHCOPPatTran.GetPatInfoById(EpisodeID,opaId,"OI")
	 			var checkList2=PatInfoConfirmFlag7.split("^");
	   		var chkopPatientTo=checkList2[0];   //
	   		if (chkopPatientTo!="1")
	   			{obj.btnLepatSave.hide();}
			}else
			{
				DisablePACUPanel();
		    DisablewardPanel();
				obj.NurPanel1.hide();
				obj.NurPanel3.hide();
				//病区护士是否提交转运单，提交了则显示出入室审核按钮
    		var retst=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,opaId,"OB")
				if(retst=="")
    		{obj.btnInRoomSave.hide();}
    		
			}
			
		 	break;
		default:
	  }
	}
	 function DisableBaseInfo()
	{
	  obj.txtPatname.disable()
	  obj.txtMedCareNo.disable()
	  obj.txtPatSex.disable()
	  obj.txtPatAge.disable()
	  obj.txtPatLoc.disable()
	}
	function DisablewardPanel()
	{
	  	obj.txtPatBP.disable()
	  	obj.txtPatP.disable()
	  	obj.txtPatT.disable()
	  	obj.chkconsciousness.disable()
	  	obj.chkskin.disable()
	  	obj.txtskin.disable()
	  	obj.chkIsTube.disable()
	  	obj.chkIsinfusion.disable()
	  	obj.chkIsCatheter.disable()
	  	obj.chkIsTracintubation.disable()
	  	obj.chkIsOxygentube.disable()
	  	obj.chkIsDrainagetube.disable()
	  	obj.Panel60Num.disable()
	  	obj.chkIsCase.disable()
	  	obj.chkIsTakemedicine.disable()
	  	obj.Panel70Num.disable()
	  	obj.PaneXlightNum.disable()
	  	//obj.txtwardqt.disable()
	  	obj.txtOperator.disable()
	  	obj.txtOperatortime.disable()
	  	obj.txtTransitman.disable()
	  	obj.txtAuditTime.disable()
	  	obj.txtHandoverperson.disable()
	  	obj.btnWardSendSave.disable()
		obj.btntempSave.disable()
	  	obj.txtwardReq.disable()
	  	obj.btnOpToWardSave.disable()
	  	obj.btnPACUToWardSave.disable()
	}
	function DisableOPPanel()
	{
	  	obj.chkPatientTo.disable()
	  	obj.btnInRoomSave.disable()
	  	obj.chkopconsciousness.disable()
	  	obj.chkopskin.disable()
	  	obj.txtopskin.disable()
	  	obj.chkopIsTube.disable()
	  	obj.chkopIsinfusion.disable()
	  	obj.chkopIsCatheter.disable()
	  	obj.chkopIsTracintubation.disable()
	  	obj.chkopIsDrainagetube.disable()
	  	obj.Panel143Num.disable()
	  	obj.chkopIsCase.disable()
	  	obj.chkopIsTakemedicine.disable()
	  	obj.PaneopXlightNum.disable()
	  	obj.txtopqt.disable()
	  	obj.txtopOperator.disable()
	  	obj.txtopOperatortime.disable()
	  	obj.txtopTransitman.disable()
	  	obj.txtopAuditTime.disable()
	  	obj.txtopHandoverperson.disable()
	  	obj.btnoproomSave.disable()
	}
	function DisablePACUPanel()
	{
	  	obj.chkpacuPatientTo.disable()
		obj.btnLepatSave.disable() 
		obj.txtpacuBP.disable()
		obj.txtpacuP.disable()
		obj.txtpacuR.disable() 
		obj.txtpacuSaO.disable()
		obj.chkpacuconsciousness.disable()
		obj.chkpacuskin.disable()
		obj.txtpacuskin.disable()
		obj.chkpacuIsTube.disable()
		obj.chkpacuIsinfusion.disable()
		obj.chkpacuIsCatheter.disable()
		obj.chkpacuIsTracintubation.disable()
		obj.chkpacuIsOxygentube.disable()
		obj.chkpacuIsDrainagetube.disable()
		obj.pacufPanel6Num.disable()
		obj.chkpacuIsCase.disable()
		obj.PanepacuXlightNum.disable()
		obj.txtpacuqt.disable()
		obj.txtpacuOperator.disable()
		obj.txtpacuOperatortime.disable()
		obj.txtpacuTransitman.disable()
		obj.txtpacuAuditTime.disable()
		obj.txtpacuHandoverperson.disable()
		obj.btnpacuroomSave.disable()
	}
	//按钮显示控制
	function btncollect()
	{
		var ret1= _DHCOPPatTran.GetPatInfoById(EpisodeID,opaId,"OI")
    		if (ret1!="")
    		{
	   			var checkList=ret1.split("^");
	   			var chkPatientTo=checkList[0];   //病人去向
	   			var retB4=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,opaId,"OI");
				if((retB4=="Y")&&((chkPatientTo==2)||(chkPatientTo==3)))
				{	obj.btnOpToWardSave.show();
					obj.btnOpToWardSave.disable();
					obj.btnoproomSave.hide();
				}
				if((retB4!="Y")&&((chkPatientTo==2)||(chkPatientTo==3)))
				{obj.btnOpToWardSave.show();}
	   			
    		}
			
    		var retB5=_DHCOPPatTran.GetPatInfoById(EpisodeID,opaId,"OO")
  			if(retB5!="")
   			{
				var checkList=retB5.split("^");
	   			var chkpacuPatientTo=checkList[0];   //病人去向
	   			var rett=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,opaId,"OO");
				
				if((rett=="Y")&&((chkpacuPatientTo==1)||(chkpacuPatientTo==2)||(chkpacuPatientTo==3)))
					{	
						obj.btnPACUToWardSave.show();
						obj.btnPACUToWardSave.disable();
						obj.btnpacuroomSave.hide();
					}
				if((rett!="Y")&&((chkpacuPatientTo==1)||(chkpacuPatientTo==2)||(chkpacuPatientTo==3)))
					{	
						obj.btnPACUToWardSave.show();
						
					}
				
  			}
   			//病区护士是否提交转运单，提交了则显示出入室审核按钮
			var retst=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,opaId,"OB")
			if(retst!="")
    		{
		  		var checkList=retst.split("^");
	   			var txtOperator=checkList[6];
		  		if(txtOperator=="")
		  		{
					obj.btnInRoomSave.hide();
					
					}	
				else
				{
					obj.btntempSave.disable();
					obj.btnWardSendSave.disable();
					}
				
		  	}else{
				obj.btnInRoomSave.hide();
			}
			
			//护士入室审核了，病区按钮消失，入室审核按钮变灰
			
	 		var PatInfoConfirmFlag1=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,opaId,"OB")
	   		
	   		if (PatInfoConfirmFlag1=="Y")
	   		{
		  		obj.btnWardSendSave.hide();
		  		obj.btnInRoomSave.disable();
	   		}else{
		   		obj.btnoproomSave.disable();
		   		}
     		
	   		//手术室护士是否提交转运单
    		var PatInfoConfirmFlag=_DHCOPPatTran.GetPatInfoById(EpisodeID,opaId,"OI")
    		if (PatInfoConfirmFlag!="")
    		{
	    		var PatInfoConfirmFlag7= _DHCOPPatTran.GetPatInfoById(EpisodeID,opaId,"OI")
	 			var checkList2=PatInfoConfirmFlag7.split("^");
	   			var chkopPatientTo=checkList2[0]; 
	   			if (chkopPatientTo!="1")
	   			{
		  		obj.btnLepatSave.hide();
		 		}
	    	}else
	  		{	
		 		obj.btnLepatSave.hide();
	  		}
	 	
			var PatInfoConfirmFlag6=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,opaId,"OI")
			var PatInfoConfirmFlag8= _DHCOPPatTran.GetPatInfoById(EpisodeID,opaId,"OI")
	 		var checkList3=PatInfoConfirmFlag8.split("^");
	   		var chkopPatientTo1=checkList3[0];  
	   		if ((PatInfoConfirmFlag6=="Y")&&(chkopPatientTo1=="1"))
	   		{
		  		obj.btnoproomSave.hide();
		  		obj.btnLepatSave.disable();
	   		}else
	   		{
		   		obj.btnpacuroomSave.disable();
		   	} 
		
		}
	//手术室保存
	obj.btnoproomSave_click=function()
	 {
	  	var type="OI"
	  	var chkPatientTo=Ext.getCmp("chkPatientTo").getValue();
		if(chkPatientTo==null)
		{
			alert("请选择病人去向！");
			return;
			}
	  	if(chkPatientTo==null)
	  	{var chkPatientTo=0}else{var chkPatientTo=obj.chkPatientTo.getValue().inputValue;}
	  	var chkopconsciousness=Ext.getCmp("chkopconsciousness").getValue();
	  	if(chkopconsciousness==null)
	  	{var chkopconsciousness=0}else{var chkopconsciousness=obj.chkopconsciousness.getValue().inputValue;}
	  	var chkopskin=Ext.getCmp("chkopskin").getValue();
	  	if(chkopskin==null)
	  	{var chkopskin=0}else{var chkopskin=obj.chkopskin.getValue().inputValue;}
	  	var chkopIsTube=Ext.getCmp("chkopIsTube").getValue();
	  	if(chkopIsTube==null)
	  	{var chkopIsTube=0}else{var chkopIsTube=obj.chkopIsTube.getValue().inputValue;}
	  	var chkopIsinfusion=Ext.getCmp("chkopIsinfusion").getValue();
	  	if(chkopIsinfusion==null)
	  	{var chkopIsinfusion=0}else{var chkopIsinfusion=obj.chkopIsinfusion.getValue().inputValue;}
	  	var chkopIsCatheter=Ext.getCmp("chkopIsCatheter").getValue();
	  	if(chkopIsCatheter==null)
	  	{var chkopIsCatheter=0}else{var chkopIsCatheter=obj.chkopIsCatheter.getValue().inputValue;}
	  	var chkopIsTracintubation=Ext.getCmp("chkopIsTracintubation").getValue();
	  	if(chkopIsTracintubation==null)
	  	{var chkopIsTracintubation=0}else{var chkopIsTracintubation=obj.chkopIsTracintubation.getValue().inputValue;}
	  	var chkopIsDrainagetube=Ext.getCmp("chkopIsDrainagetube").getValue();
	  	if(chkopIsDrainagetube==null)
	  	{var chkopIsDrainagetube=0}else{var chkopIsDrainagetube=obj.chkopIsDrainagetube.getValue().inputValue;}
	  	var chkopIsCase=Ext.getCmp("chkopIsCase").getValue();
	  	if(chkopIsCase==null)
	  	{var chkopIsCase=0}else{var chkopIsCase=obj.chkopIsCase.getValue().inputValue;}
	  	var chkopIsTakemedicine=Ext.getCmp("chkopIsTakemedicine").getValue();
	  	if(chkopIsTakemedicine==null)
	  	{var chkopIsTakemedicine=0}else{var chkopIsTakemedicine=obj.chkopIsTakemedicine.getValue().inputValue;}
	  
	  	var str1=chkPatientTo+"^"+chkopconsciousness+"^"+chkopskin+"^"+chkopIsTube+"^"+chkopIsinfusion+"^"+chkopIsCatheter+"^"+chkopIsTracintubation+"^"+chkopIsDrainagetube+"^"+chkopIsCase+"^"+chkopIsTakemedicine
	 	var UserId=session['LOGON.USERID'];
	 	var comopaId=obj.comopaId.getValue();
		var retStr=_DHCOPPatTran.SavePatInfoByAdmId(EpisodeID,comopaId,str1,type,UserId)
    	if (retStr!=0)
    	{
			alert(retStr)
			return
    	}
    	var txtopskin=obj.txtopskin.getValue();	//具体情况
	    var Panel143Num=obj.Panel143Num.getValue();	//引流管数量
	    var PaneopXlightNum=obj.PaneopXlightNum.getValue();//X光片数量
	    var txtopqt=obj.txtopqt.getValue();		//其他
	    var txtopOperator=session['LOGON.USERNAME'];	//操作人
	    var txtopOperatorId=session['LOGON.USERID']	//操作人ID
    	var txtopTransitman=obj.txtopTransitman.getValue();//转运人
    	if(txtopTransitman!="")
    	{
	    	if(/^\d+$/.test(txtopTransitman)) 
			{ var opTransitman=_DHCOPPatTran.GetNameInfoByCode(txtopTransitman);
			if(opTransitman=="1"){alert("转运人:工号无效!");return;}
				var comopaId=obj.comopaId.getValue();
    			var Str1=txtopskin+"^"+txtopqt+"^"+Panel143Num+"^"+txtopOperator+"^"+txtopOperatorId
					+"^"+txtopTransitman+"^"+PaneopXlightNum+"^"
    			var retStr2=_DHCOPPatTran.SavePatOtherInfoByAdmId(EpisodeID,comopaId,Str1,type,UserId)
    			if (retStr2!=0)
   		 		{
					alert("Error")
					return
   		 		}  
				else
				{
					alert("保存成功");
					self.location.reload();
				}
			}
			else
			{alert("转运人:输入工号！");
			return;}
	    }else
	    {
	    	var comopaId=obj.comopaId.getValue();
    			var Str1=txtopskin+"^"+txtopqt+"^"+Panel143Num+"^"+txtopOperator+"^"+txtopOperatorId
					+"^"+txtopTransitman+"^"+PaneopXlightNum+"^"
    			var retStr2=_DHCOPPatTran.SavePatOtherInfoByAdmId(EpisodeID,comopaId,Str1,type,UserId)
    			if (retStr2!=0)
   		 		{
					alert("Error")
					return
   		 		}  
				else
				{
					alert("保存成功");
					self.location.reload();
				}
	    	}
	 }
	 //病区保存
	obj.btnWardSendSave_click=function()
	 {
		var type="OB"
	  	var chkconsciousness=Ext.getCmp("chkconsciousness").getValue();
	  	if(chkconsciousness==null)
	  	{var chkconsciousness=0}else{var chkconsciousness=obj.chkconsciousness.getValue().inputValue;}
	
	  	var chkskin=Ext.getCmp("chkskin").getValue();
	  	if(chkskin==null)
	  	{var chkskin=0}else{var chkskin=obj.chkskin.getValue().inputValue;}
	 	var chkIsTube=Ext.getCmp("chkIsTube").getValue();
	  	if(chkIsTube==null)
	  	{var chkIsTube=0}else{var chkIsTube=obj.chkIsTube.getValue().inputValue;}
	 	var chkIsinfusion=Ext.getCmp("chkIsinfusion").getValue();
	  	if(chkIsinfusion==null)
	  	{var chkIsinfusion=0}else{var chkIsinfusion=obj.chkIsinfusion.getValue().inputValue;}
	 	var chkIsCatheter=Ext.getCmp("chkIsCatheter").getValue();
	  	if(chkIsCatheter==null)
	  	{var chkIsCatheter=0}else{var chkIsCatheter=obj.chkIsCatheter.getValue().inputValue;}
	 	var chkIsTracintubation=Ext.getCmp("chkIsTracintubation").getValue();
	  	if(chkIsTracintubation==null)
	  	{var chkIsTracintubation=0}else{var chkIsTracintubation=obj.chkIsTracintubation.getValue().inputValue;}
	 	var chkIsOxygentube=Ext.getCmp("chkIsOxygentube").getValue();
	  	if(chkIsOxygentube==null)
	  	{var chkIsOxygentube=0}else{var chkIsOxygentube=obj.chkIsOxygentube.getValue().inputValue;}
	 	var chkIsDrainagetube=Ext.getCmp("chkIsDrainagetube").getValue();
	  	if(chkIsDrainagetube==null)
	  	{var chkIsDrainagetube=0}else{var chkIsDrainagetube=obj.chkIsDrainagetube.getValue().inputValue;}
	 	var chkIsCase=Ext.getCmp("chkIsCase").getValue();
	  	if(chkIsCase==null)
	  	{var chkIsCase=0}else{var chkIsCase=obj.chkIsCase.getValue().inputValue;}
	 	var chkIsTakemedicine=Ext.getCmp("chkIsTakemedicine").getValue();
	  	if(chkIsTakemedicine==null)
	  	{var chkIsTakemedicine=0}else{var chkIsTakemedicine=obj.chkIsTakemedicine.getValue().inputValue;}
	  	
	 	var str=chkconsciousness+"^"+chkskin+"^"+chkIsTube+"^"+chkIsinfusion+"^"+chkIsCatheter+"^"+chkIsTracintubation+"^"+chkIsOxygentube+"^"+chkIsDrainagetube+"^"+chkIsCase+"^"+chkIsTakemedicine

	 	var UserId=session['LOGON.USERID'];
	 	var comopaId=obj.comopaId.getValue();
		var retStr=_DHCOPPatTran.SavePatInfoByAdmId(EpisodeID,comopaId,str,type,UserId)
    	if (retStr!=0)
    	{
			alert(retStr)
			return
    	} 
	    var txtskin=obj.txtskin.getValue();	//具体情况
	    var Panel60Num=obj.Panel60Num.getValue();	//引流管数量
	    var Panel70Num=obj.Panel70Num.getValue();	//术中带药数量
	    var PaneXlightNum=obj.PaneXlightNum.getValue();//X光片数量
	    var txtwardqt=obj.txtwardqt.getValue();		//其他
	    var txtPatBP=obj.txtPatBP.getValue();		//BP
	    var txtPatP=obj.txtPatP.getValue();			//P
	    var txtPatT=obj.txtPatT.getValue();			//T
	    var txtOperator=session['LOGON.USERNAME'];	//操作人
	    var txtOperatorId=session['LOGON.USERID']	//操作人ID
	    var txtOperatortime=obj.txtOperatortime.getValue();//操作时间
    	var txtTransitman=obj.txtTransitman.getValue();//转运人
    	if(txtTransitman!="")
    	{	
	    	if(/^\d+$/.test(txtTransitman)) 
			{ var Transitman=_DHCOPPatTran.GetNameInfoByCode(txtTransitman);
			if(Transitman=="1"){alert("转运人:工号无效!");return;}
 				var comopaId=obj.comopaId.getValue();
    			var Str=txtskin+"^"+txtwardqt+"^"+Panel60Num+"^"+txtPatBP+"^"+txtPatP
				+"^"+txtPatT+"^"+txtOperator+"^"+txtOperatorId+"^"+txtTransitman+"^"+Panel70Num
				+"^"+PaneXlightNum+"^"+comopaId+"^"
    			var retStr1=_DHCOPPatTran.SavePatOtherInfoByAdmId(EpisodeID,comopaId,Str,type,UserId)
    			if (retStr1!=0)
   		 		{
					alert("Error");
					return;
   		 		}  
					else
				{
				alert("保存成功");
				self.location.reload();
					}  
			}else
			{alert("转运人:输入工号！");
			return;}
			
	    }
	    else
	    {
	   		var comopaId=obj.comopaId.getValue();
    			var Str=txtskin+"^"+txtwardqt+"^"+Panel60Num+"^"+txtPatBP+"^"+txtPatP
				+"^"+txtPatT+"^"+txtOperator+"^"+txtOperatorId+"^"+txtTransitman+"^"+Panel70Num
				+"^"+PaneXlightNum+"^"+comopaId+"^"
    			var retStr1=_DHCOPPatTran.SavePatOtherInfoByAdmId(EpisodeID,comopaId,Str,type,UserId)
    			if (retStr1!=0)
   		 		{
					alert("Error");
					return;
   		 		}  
					else
				{
				alert("保存成功");
				self.location.reload();
					}  
	    	}
		
	 }
	//临时保存
	obj.btntempSave_click=function()
	 {
		var type="OB"
	  	var chkconsciousness=Ext.getCmp("chkconsciousness").getValue();
	  	if(chkconsciousness==null)
	  	{var chkconsciousness=0}else{var chkconsciousness=obj.chkconsciousness.getValue().inputValue;}
	
	  	var chkskin=Ext.getCmp("chkskin").getValue();
	  	if(chkskin==null)
	  	{var chkskin=0}else{var chkskin=obj.chkskin.getValue().inputValue;}
	 	var chkIsTube=Ext.getCmp("chkIsTube").getValue();
	  	if(chkIsTube==null)
	  	{var chkIsTube=0}else{var chkIsTube=obj.chkIsTube.getValue().inputValue;}
	 	var chkIsinfusion=Ext.getCmp("chkIsinfusion").getValue();
	  	if(chkIsinfusion==null)
	  	{var chkIsinfusion=0}else{var chkIsinfusion=obj.chkIsinfusion.getValue().inputValue;}
	 	var chkIsCatheter=Ext.getCmp("chkIsCatheter").getValue();
	  	if(chkIsCatheter==null)
	  	{var chkIsCatheter=0}else{var chkIsCatheter=obj.chkIsCatheter.getValue().inputValue;}
	 	var chkIsTracintubation=Ext.getCmp("chkIsTracintubation").getValue();
	  	if(chkIsTracintubation==null)
	  	{var chkIsTracintubation=0}else{var chkIsTracintubation=obj.chkIsTracintubation.getValue().inputValue;}
	 	var chkIsOxygentube=Ext.getCmp("chkIsOxygentube").getValue();
	  	if(chkIsOxygentube==null)
	  	{var chkIsOxygentube=0}else{var chkIsOxygentube=obj.chkIsOxygentube.getValue().inputValue;}
	 	var chkIsDrainagetube=Ext.getCmp("chkIsDrainagetube").getValue();
	  	if(chkIsDrainagetube==null)
	  	{var chkIsDrainagetube=0}else{var chkIsDrainagetube=obj.chkIsDrainagetube.getValue().inputValue;}
	 	var chkIsCase=Ext.getCmp("chkIsCase").getValue();
	  	if(chkIsCase==null)
	  	{var chkIsCase=0}else{var chkIsCase=obj.chkIsCase.getValue().inputValue;}
	 	var chkIsTakemedicine=Ext.getCmp("chkIsTakemedicine").getValue();
	  	if(chkIsTakemedicine==null)
	  	{var chkIsTakemedicine=0}else{var chkIsTakemedicine=obj.chkIsTakemedicine.getValue().inputValue;}
	  	
	 	var str=chkconsciousness+"^"+chkskin+"^"+chkIsTube+"^"+chkIsinfusion+"^"+chkIsCatheter+"^"+chkIsTracintubation+"^"+chkIsOxygentube+"^"+chkIsDrainagetube+"^"+chkIsCase+"^"+chkIsTakemedicine

	 	var UserId=session['LOGON.USERID'];
	 	var comopaId=obj.comopaId.getValue();
		var retStr=_DHCOPPatTran.SavePatInfoByAdmId(EpisodeID,comopaId,str,type,UserId)
    	if (retStr!=0)
    	{
			alert(retStr)
			return
    	} 
	    var txtskin=obj.txtskin.getValue();	//具体情况
	    var Panel60Num=obj.Panel60Num.getValue();	//引流管数量
	    var Panel70Num=obj.Panel70Num.getValue();	//术中带药数量
	    var PaneXlightNum=obj.PaneXlightNum.getValue();//X光片数量
	    var txtwardqt=obj.txtwardqt.getValue();		//其他
	    var txtPatBP=obj.txtPatBP.getValue();		//BP
	    var txtPatP=obj.txtPatP.getValue();			//P
	    var txtPatT=obj.txtPatT.getValue();			//T
	    var txtOperator="";	//操作人
	    var txtOperatorId=""	//操作人ID
    	var txtTransitman=obj.txtTransitman.getValue();//转运人
		var txtPatLoc=obj.txtPatLoc.getValue();			//病人科室
    	var temp="Y"
    	if(txtTransitman!="")
    	{	
	    	if(/^\d+$/.test(txtTransitman)) 
			{ 
			var GROUPDESC=session['LOGON.GROUPDESC'];
			var GROUPID=session['LOGON.GROUPID'];
			var Transitman=_DHCOPPatTran.GetNameInfoByCode(txtTransitman);
			if(Transitman=="1"){alert("转运人:工号无效!");return;}
 				var comopaId=obj.comopaId.getValue();
    			var Str=txtskin+"^"+txtwardqt+"^"+Panel60Num+"^"+txtPatBP+"^"+txtPatP
				+"^"+txtPatT+"^"+txtOperator+"^"+txtOperatorId+"^"+txtTransitman+"^"+Panel70Num
				+"^"+PaneXlightNum+"^"+comopaId+"^"
    			var retStr1=_DHCOPPatTran.SavePatOtherInfoByAdmId(EpisodeID,comopaId,Str,type,UserId,temp)
    			if (retStr1!=0)
   		 		{
					alert("Error");
					return;
   		 		}  
					else
				{
				alert("保存成功");
				self.location.reload();
					}  
			}else
			{alert("转运人:输入工号！");
			return;}
			
	    }
	    else
	    {
			var GROUPDESC=session['LOGON.GROUPDESC'];
			var GROUPID=session['LOGON.GROUPID'];
	   		var comopaId=obj.comopaId.getValue();
    			var Str=txtskin+"^"+txtwardqt+"^"+Panel60Num+"^"+txtPatBP+"^"+txtPatP
				+"^"+txtPatT+"^"+txtOperator+"^"+txtOperatorId+"^"+txtTransitman+"^"+Panel70Num
				+"^"+PaneXlightNum+"^"+comopaId+"^"
    			var retStr1=_DHCOPPatTran.SavePatOtherInfoByAdmId(EpisodeID,comopaId,Str,type,UserId,temp)
    			if (retStr1!=0)
   		 		{
					alert("Error");
					return;
   		 		}  
					else
				{
				alert("保存成功");
				//alert(txtPatLoc);
				//self.location.reload();
				if(txtPatLoc=="甲状腺外科/烧伤科病区")
				{
				if(window.confirm('是否同步生命体征信息到护理记录体温单上？')){
					var DHCNurseRecAfterCommit=_DHCNurseRecAfterCommit.dhcNurseRecAfterOpTransCommit(EpisodeID,txtPatT,txtPatP,txtPatBP,UserId,GROUPID,GROUPDESC);
					}
				}
				self.location.reload();
					}  
	    	}	 
		 
	}
	 //pacu回病房运送
	obj.btnpacuroomSave_click=function()
	{
		var type="OO" 
		
	 	var chkpacuPatientTo=Ext.getCmp("chkpacuPatientTo").getValue();
		if(chkpacuPatientTo==null)
		{alert("请填写病人去向！");
		return;}
	  	if(chkpacuPatientTo==null)
	  	{var chkpacuPatientTo=0}else{var chkpacuPatientTo=obj.chkpacuPatientTo.getValue().inputValue;}
		var chkpacuconsciousness=Ext.getCmp("chkpacuconsciousness").getValue();
	  	if(chkpacuconsciousness==null)
	  	{var chkpacuconsciousness=0}else{var chkpacuconsciousness=obj.chkpacuconsciousness.getValue().inputValue;}
		var chkpacuskin=Ext.getCmp("chkpacuskin").getValue();
	  	if(chkpacuskin==null)
	  	{var chkpacuskin=0}else{var chkpacuskin=obj.chkpacuskin.getValue().inputValue;}
		var chkpacuIsTube=Ext.getCmp("chkpacuIsTube").getValue();
	  	if(chkpacuIsTube==null)
	  	{var chkpacuIsTube=0}else{var chkpacuIsTube=obj.chkpacuIsTube.getValue().inputValue;}
	 	var chkpacuIsinfusion=Ext.getCmp("chkpacuIsinfusion").getValue();
	  	if(chkpacuIsinfusion==null)
	  	{var chkpacuIsinfusion=0}else{var chkpacuIsinfusion=obj.chkpacuIsinfusion.getValue().inputValue;}
	 	var chkpacuIsCatheter=Ext.getCmp("chkpacuIsCatheter").getValue();
	  	if(chkpacuIsCatheter==null)
	  	{var chkpacuIsCatheter=0}else{var chkpacuIsCatheter=obj.chkpacuIsCatheter.getValue().inputValue;}
	 	var chkpacuIsTracintubation=Ext.getCmp("chkpacuIsTracintubation").getValue();
	  	if(chkpacuIsTracintubation==null)
	  	{var chkpacuIsTracintubation=0}else{var chkpacuIsTracintubation=obj.chkpacuIsTracintubation.getValue().inputValue;}
	 	var chkpacuIsOxygentube=Ext.getCmp("chkpacuIsOxygentube").getValue();
	  	if(chkpacuIsOxygentube==null)
	  	{var chkpacuIsOxygentube=0}else{var chkpacuIsOxygentube=obj.chkpacuIsOxygentube.getValue().inputValue;}
	 	var chkpacuIsDrainagetube=Ext.getCmp("chkpacuIsDrainagetube").getValue();
	  	if(chkpacuIsDrainagetube==null)
	  	{var chkpacuIsDrainagetube=0}else{var chkpacuIsDrainagetube=obj.chkpacuIsDrainagetube.getValue().inputValue;}
	 	var chkpacuIsCase=Ext.getCmp("chkpacuIsCase").getValue();
	  	if(chkpacuIsCase==null)
	  	{var chkpacuIsCase=0}else{var chkpacuIsCase=obj.chkpacuIsCase.getValue().inputValue;}
	 	var str3=chkpacuPatientTo+"^"+chkpacuconsciousness+"^"+chkpacuskin+"^"+chkpacuIsTube+"^"+chkpacuIsinfusion+"^"+chkpacuIsCatheter+"^"+chkpacuIsTracintubation+"^"+chkpacuIsOxygentube+"^"+chkpacuIsDrainagetube+"^"+chkpacuIsCase
	 	var UserId=session['LOGON.USERID'];
	 	var comopaId=obj.comopaId.getValue();
		var retStr=_DHCOPPatTran.SavePatInfoByAdmId(EpisodeID,comopaId,str3,type,UserId)
    	if (retStr!=0)
    	{
			alert(retStr)
			return
    	} 
    	var txtpacuskin=obj.txtpacuskin.getValue();	//具体情况
	    var pacufPanel6Num=obj.pacufPanel6Num.getValue();	//引流管数量
	    var PanepacuXlightNum=obj.PanepacuXlightNum.getValue();//X光片数量
	    var txtpacuqt=obj.txtpacuqt.getValue();		//其他
	    var txtpacuBP=obj.txtpacuBP.getValue();		//BP
	    var txtpacuP=obj.txtpacuP.getValue();			//P
	    var txtpacuR=obj.txtpacuR.getValue();			//R
	    var txtpacuSaO=obj.txtpacuSaO.getValue();			//Sao
	    var txtpacuOperator=session['LOGON.USERNAME'];	//操作人
	    var txtpacuOperatorId=session['LOGON.USERID']	//操作人ID
    	var txtpacuTransitman=obj.txtpacuTransitman.getValue();//转运人
    	if(txtpacuTransitman!="")
    	{	
	    	if(/^\d+$/.test(txtpacuTransitman)) 
			{ var pacuTransitman=_DHCOPPatTran.GetNameInfoByCode(txtpacuTransitman);
			if(pacuTransitman=="1"){alert("转运人:工号无效!");return;}
 				var comopaId=obj.comopaId.getValue();
    			var Str4=txtpacuskin+"^"+txtpacuqt+"^"+pacufPanel6Num+"^"+txtpacuP+"^"+txtpacuR
				+"^"+txtpacuBP+"^"+txtpacuSaO+"^"+txtpacuOperator+"^"+txtpacuOperatorId+"^"+txtpacuTransitman
				+"^"+PanepacuXlightNum+"^"
    			var retStr3=_DHCOPPatTran.SavePatOtherInfoByAdmId(EpisodeID,comopaId,Str4,type,UserId)
    			if (retStr3!=0)
   		 		{
					alert("Error");
					return;
   		 		}  
					else
				{
				alert("保存成功");
				self.location.reload();
					}  
			}else
			{alert("转运人:输入工号！");
			return;}
			
	    }else
	    {
		    var comopaId=obj.comopaId.getValue();
    			var Str4=txtpacuskin+"^"+txtpacuqt+"^"+pacufPanel6Num+"^"+txtpacuP+"^"+txtpacuR
				+"^"+txtpacuBP+"^"+txtpacuSaO+"^"+txtpacuOperator+"^"+txtpacuOperatorId+"^"+txtpacuTransitman
				+"^"+PanepacuXlightNum+"^"
    			var retStr3=_DHCOPPatTran.SavePatOtherInfoByAdmId(EpisodeID,comopaId,Str4,type,UserId)
    			if (retStr3!=0)
   		 		{
					alert("Error");
					return;
   		 		}  
					else
				{
				alert("保存成功");
				self.location.reload();
					}  
		    
		    }
	   
		 
	}
	//入室交接审核
	obj.btnInRoomSave_click=function()
	{
		UserName=session['LOGON.USERNAME']
		UserId=session['LOGON.USERID']
		var comopaId=obj.comopaId.getValue();
    	var retStr5=_DHCOPPatTran.PatInfoConfirm(EpisodeID,comopaId,"OB",UserId,UserName)
    	if (retStr5!=0)
    	{
		alert("Error")
		return
    	}
    	else 
    	{
	    alert("审核成功")
		self.location.reload();
    	}  
		
	}
	//术毕病人交接审核
	obj.btnLepatSave_click=function()
	{
		UserName=session['LOGON.USERNAME']
		UserId=session['LOGON.USERID']
		var comopaId=obj.comopaId.getValue();
    	var retStr6=_DHCOPPatTran.PatInfoConfirm(EpisodeID,comopaId,"OI",UserId,UserName)
    	if (retStr6!=0)
    	{
		alert("Error")
		return
    	}
    	else 
    	{
	    alert("审核成功")
		self.location.reload();
    	}  
	}
	//手术室回病房审核按钮
	obj.btnOpToWardSave_click=function()
	{
		UserName=session['LOGON.USERNAME']
		UserId=session['LOGON.USERID']
		var comopaId=obj.comopaId.getValue();
		var txtwardReq=obj.txtwardReq.getValue();
		var wardnote1=_DHCOPPatTran.WardNoteConfirm(comopaId,"OB",txtwardReq)
    	var retStr7=_DHCOPPatTran.PatInfoConfirm(EpisodeID,comopaId,"OI",UserId,UserName)
    	if (retStr7!=0)
    	{
		alert("Error")
		return
    	}
    	else 
    	{
	    alert("审核成功")
		self.location.reload();
   		}  
	}
	//恢复室回病房审核按钮
	obj.btnPACUToWardSave_click=function()
	{
		UserName=session['LOGON.USERNAME']
		UserId=session['LOGON.USERID']
		var comopaId=obj.comopaId.getValue();
		var txtwardReq=obj.txtwardReq.getValue();
		var wardnote=_DHCOPPatTran.WardNoteConfirm(comopaId,"OB",txtwardReq)
    	var retStr8=_DHCOPPatTran.PatInfoConfirm(EpisodeID,comopaId,"OO",UserId,UserName)
    	if (retStr8!=0)
    	{
		alert("Error")
		return
    	}
    	else 
    	{
	    alert("审核成功")
		self.location.reload();
   		}  
	}
	
	obj.comopaId_select=function()
	{
		//选择opaid初始化控件里的值
		obj.txtPatBP.setValue('');
		obj.txtPatP.setValue('');
		obj.txtPatT.setValue('');
		obj.chkconsciousness.setValue('');
		obj.chkskin.setValue('');
		obj.txtskin.setValue('');
		obj.chkIsTube.setValue('');
		obj.chkIsinfusion.setValue('');
		obj.chkIsCatheter.setValue('');
		obj.chkIsTracintubation.setValue('');
		obj.chkIsOxygentube.setValue('');
		obj.chkIsDrainagetube.setValue('');
		obj.Panel60Num.setValue('');
		obj.chkIsCase.setValue('');
		obj.chkIsTakemedicine.setValue('');
		obj.Panel70Num.setValue('');
		obj.PaneXlightNum.setValue('');
		obj.txtwardqt.setValue('');
		obj.txtOperator.setValue('');
		obj.txtOperatortime.setValue('');
		obj.txtTransitman.setValue('');
		obj.txtAuditTime.setValue('');
		obj.txtHandoverperson.setValue('');
		obj.txtwardReq.setValue('');
		obj.btnWardSendSave.enable();
		obj.btnWardSendSave.show();
		obj.btntempSave.enable();
		obj.btntempSave.show();
		//手术室初始化
		obj.chkPatientTo.setValue('');
		obj.chkopconsciousness.setValue('');
		obj.chkopskin.setValue('');
		obj.txtopskin.setValue('');
		obj.chkopIsTube.setValue('');
		obj.chkopIsinfusion.setValue('');
		obj.chkopIsCatheter.setValue('');
		obj.chkopIsTracintubation.setValue('');
		obj.chkopIsDrainagetube.setValue('');
		obj.Panel143Num.setValue('');
		obj.chkopIsCase.setValue('');
		obj.chkopIsTakemedicine.setValue('');
		obj.PaneopXlightNum.setValue('');
		obj.txtopqt.setValue('');
		obj.txtopOperator.setValue('');
		obj.txtopOperatortime.setValue('');
		obj.txtopTransitman.setValue('');
		obj.txtopAuditTime.setValue('');
		obj.txtopHandoverperson.setValue('');
		//pacu
		obj.chkpacuPatientTo.setValue('');
		obj.txtpacuBP.setValue('');
		obj.txtpacuP.setValue('');
		obj.txtpacuR.setValue('');
		obj.txtpacuSaO.setValue('');
		obj.chkpacuconsciousness.setValue('');
		obj.chkpacuskin.setValue('');
		obj.txtpacuskin.setValue('');
		obj.chkpacuIsTube.setValue('');
		obj.chkpacuIsinfusion.setValue('');
		obj.chkpacuIsCatheter.setValue('');
		obj.chkpacuIsTracintubation.setValue('');
		obj.chkpacuIsOxygentube.setValue('');
		obj.chkpacuIsDrainagetube.setValue('');
		obj.pacufPanel6Num.setValue('');
		obj.chkpacuIsCase.setValue('');
		obj.PanepacuXlightNum.setValue('');
		obj.txtpacuqt.setValue('');
		obj.txtpacuOperator.setValue('');
		obj.txtpacuOperatortime.setValue('');
		obj.txtpacuTransitman.setValue('');
		obj.txtpacuAuditTime.setValue('');
		obj.txtpacuHandoverperson.setValue('');
		obj.btnoproomSave.show();
		obj.btnInRoomSave.show();
		obj.btnpacuroomSave.show();
		obj.btnLepatSave.show();
		var comopaId = obj.comopaId.getValue();
		LoadWardData(EpisodeID,comopaId);
		LoadOPData(EpisodeID,comopaId);
	   	LoadPACUData(EpisodeID,comopaId);
	   	if(appType=="ward")
	   	{
	     	//病房备注按钮
		   var ret1= _DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OI")
    		if (ret1!="")
    		{
	   			var checkList=ret1.split("^");
	   			var chkPatientTo=checkList[0];   //病人去向
	   			var retB4=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,comopaId,"OI");
				if((retB4=="Y")&&((chkPatientTo==2)||(chkPatientTo==3)))
				{	obj.btnOpToWardSave.show();
					obj.btnOpToWardSave.disable();
					obj.btnoproomSave.hide();
				}
				if((retB4!="Y")&&((chkPatientTo==2)||(chkPatientTo==3)))
				{obj.btnOpToWardSave.show();}
	   			
    		}
			
    		var retB5=_DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OO")
  			if(retB5!="")
   			{
				var checkList=retB5.split("^");
	   			var chkpacuPatientTo=checkList[0];   //病人去向
	   			var rett=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,comopaId,"OO");
				
				if((rett=="Y")&&((chkpacuPatientTo==1)||(chkpacuPatientTo==2)||(chkpacuPatientTo==3)))
					{	
						obj.btnPACUToWardSave.show();
						obj.btnPACUToWardSave.disable();
						obj.btnpacuroomSave.hide();
					}
				if((rett!="Y")&&((chkpacuPatientTo==1)||(chkpacuPatientTo==2)||(chkpacuPatientTo==3)))
					{	
						obj.btnPACUToWardSave.show();
						
					}
				
  			}
   			//病区护士是否提交转运单，提交了则显示出入室审核按钮
    		var retst=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,comopaId,"OB")
			if(retst!="")
    		{
		  		var checkList=retst.split("^");
	   			var txtOperator=checkList[6];
		  		if(txtOperator=="")
		  		{obj.btnInRoomSave.hide();}	
				else
				{
					obj.btntempSave.disable();
					obj.btnWardSendSave.disable();
				}
		  	}else{
				obj.btnInRoomSave.hide();
			}
			
			//护士入室审核了，病区按钮消失，入室审核按钮变灰
			
	 		var PatInfoConfirmFlag1=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,comopaId,"OB")
	   		
	   		if (PatInfoConfirmFlag1=="Y")
	   		{
		  		obj.btnWardSendSave.hide();
				obj.btntempSave.hide();
		  		obj.btnInRoomSave.disable();
	   		}else{
		   		obj.btnoproomSave.disable();
		   		}
     		
	   
	   		//手术室护士是否提交转运单
    		var PatInfoConfirmFlag=_DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OI")
    		if (PatInfoConfirmFlag!="")
    		{
	    		var PatInfoConfirmFlag7= _DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OI")
	 			var checkList2=PatInfoConfirmFlag7.split("^");
	   			var chkopPatientTo=checkList2[0];   //
	   			if (chkopPatientTo!="1")
	   			{
		  		obj.btnLepatSave.hide();
		 		}
	    	}else
	  		{	
		 		obj.btnLepatSave.hide();
	  		}
	 	
			var PatInfoConfirmFlag6=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,comopaId,"OI")
			var PatInfoConfirmFlag8= _DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OI")
	 		var checkList3=PatInfoConfirmFlag8.split("^");
	   		var chkopPatientTo1=checkList3[0];  
	   		if ((PatInfoConfirmFlag6=="Y")&&(chkopPatientTo1=="1"))
	   		{
		  		obj.btnoproomSave.hide();
		  		obj.btnLepatSave.disable();
	   		}else
	   		{
		   		obj.btnpacuroomSave.disable();
		   	}
     		
	   	}
	   	if(appType=="Nurse")
	   	{
		   var ret1= _DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OI")
    		if (ret1!="")
    		{
	   			var checkList=ret1.split("^");
	   			var chkPatientTo=checkList[0];   //病人去向
	   			var retB4=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,comopaId,"OI");
				if((retB4=="Y")&&((chkPatientTo==2)||(chkPatientTo==3)))
				{	
					obj.btnOpToWardSave.show();
					obj.btnOpToWardSave.disable();
				}
				if((retB4!="Y")&&((chkPatientTo==2)||(chkPatientTo==3)))
				{obj.btnOpToWardSave.show();}
	   			
    		}
			
    		var retB5=_DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OO")
  			if(retB5!="")
   			{
				var checkList=retB5.split("^");
	   			var chkpacuPatientTo=checkList[0];   //病人去向
	   			var rett=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,comopaId,"OO");
				
				if((rett=="Y")&&((chkpacuPatientTo==1)||(chkpacuPatientTo==2)||(chkpacuPatientTo==3)))
					{	
						obj.btnPACUToWardSave.show();
						obj.btnPACUToWardSave.disable();
					}
				if((rett!="Y")&&((chkpacuPatientTo==1)||(chkpacuPatientTo==2)||(chkpacuPatientTo==3)))
					{	
						obj.btnPACUToWardSave.show();
					}	
  			}
		   
		   var PatInfoConfirmFlag7= _DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OI")
	 			var checkList2=PatInfoConfirmFlag7.split("^");
	   			var chkopPatientTo=checkList2[0];   //
	   			if (chkopPatientTo!="1")
	   			{
		  		obj.btnLepatSave.hide();
		 		}
		   
		   //病区护士是否提交转运单，提交了则显示出入室审核按钮
    		var retst=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,comopaId,"OB")
			if(retst!="")
    		{
		  		var checkList=retst.split("^");
	   			var txtOperator=checkList[6];
		  		if(txtOperator=="")
		  		{
					obj.btnInRoomSave.hide();
				}
		  	}else{
				obj.btnInRoomSave.hide();
			}
			
		  }
		   
	}

	obj.btnWard_click=function()
	{
		
		var startTime=obj.timeOper1.getRawValue();
		var startDate=obj.dateFrm1.getRawValue();
		var comopaId = obj.comopaId.getValue();
		var Operator1 =obj.Operator1.getValue();
		if((startDate!="")&&(startTime!=""))
		{
			var ret=_DHCOPPatTran.SavePatOtherInfoByopaId(comopaId,"OB",startDate,startTime)
			if(ret!="0")
			{
				alert(ret);
				return;	
			}else{
				alert("操作时间修改成功")
				}
		}
		if(Operator1!="")
    	{	
	    	if(/^\d+$/.test(Operator1)) 
			{ 
				var pacuTransitman=_DHCOPPatTran.GetNameInfoByCode(Operator1);
				if(pacuTransitman=="1"){alert("操作人:工号无效!");return;}
				var ret=_DHCOPPatTran.updateOperator(comopaId,"OB",Operator1)
				if(ret!="0")
				{
					alert(ret);
					return;	
				}else{
					alert("操作人修改成功")
				}
			}else
			{
				alert("操作人:输入工号！");
				return;
			}
		}
	//审核时间和审核人修改
		var startTime1=obj.timeOper2.getRawValue();
		var startDate1=obj.dateFrm2.getRawValue();
		var comopaId = obj.comopaId.getValue();
		var Handoverperson2 =obj.Handoverperson2.getValue();
		if((startDate1!="")&&(startTime1!=""))	//判断修改手术室还是pacu
		{
			var PatInfoConfirmFlag1=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,comopaId,"OO")
	   		if (PatInfoConfirmFlag1=="Y")
	   		{
				var ret1=_DHCOPPatTran.PatInfoConfirmbyOpaId(comopaId,"OO",startDate1,startTime1)
				if(ret1!="0")
				{
					alert(ret1);
					return;	
				}else
				{
					alert("审核时间修改成功")
				}
			}else
			{
				var ret1=_DHCOPPatTran.PatInfoConfirmbyOpaId(comopaId,"OI",startDate1,startTime1)
				if(ret1!="0")
				{
					alert(ret1);
					return;	
				}else{
					alert("审核时间修改成功")
				}
			}
			
		}
		
		if(Handoverperson2!="")
    	{	
	    	var PatInfoConfirmFlag1=_DHCOPPatTran.PatInfoConfirmFlag(EpisodeID,comopaId,"OO")
	   		if (PatInfoConfirmFlag1=="Y")
	   		{
				if(/^\d+$/.test(Handoverperson2)) 
				{ 
					var pacuTransitman=_DHCOPPatTran.GetNameInfoByCode(Handoverperson2);
					if(pacuTransitman=="1"){alert("交接人:工号无效!");return;}
					var ret=_DHCOPPatTran.updateHandoverperson(comopaId,"OO",Handoverperson2)
					if(ret!="0")
					{
						alert(ret);
						return;	
					}else{
						alert("交接人修改成功")
					}
				}else
				{
					alert("交接人:输入工号！");
					return;
				}
			}else
			{
				if(/^\d+$/.test(Handoverperson2)) 
				{ 
					var pacuTransitman=_DHCOPPatTran.GetNameInfoByCode(Handoverperson2);
					if(pacuTransitman=="1"){alert("交接人:工号无效!");return;}
					var ret=_DHCOPPatTran.updateHandoverperson(comopaId,"OI",Handoverperson2)
					if(ret!="0")
					{
						alert(ret);
						return;	
					}else{
						alert("交接人修改成功")
					}
				}else
				{
					alert("交接人:输入工号！");
					return;
				}
			}
		}
		self.location.reload();
	}
	obj.btnWard1_click=function()
	{
		
		var startTime=obj.timeOper3.getRawValue();
		var startDate=obj.dateFrm3.getRawValue();
		var comopaId = obj.comopaId.getValue();
		var Operator3 =obj.Operator3.getValue();
		if((startDate!="")&&(startTime!=""))
		{
			var ret=_DHCOPPatTran.SavePatOtherInfoByopaId(comopaId,"OI",startDate,startTime)
			if(ret!="0")
			{
				alert(ret);
				return;	
			}else{
				alert("操作时间修改成功")
				}
		}
		if(Operator3!="")
    	{	
	    	if(/^\d+$/.test(Operator3)) 
			{ 
				var pacuTransitman=_DHCOPPatTran.GetNameInfoByCode(Operator3);
				if(pacuTransitman=="1"){alert("操作人:工号无效!");return;}
				var ret=_DHCOPPatTran.updateOperator(comopaId,"OI",Operator3)
				if(ret!="0")
				{
					alert(ret);
					return;	
				}else{
					alert("操作人修改成功")
				}
			}else
			{
				alert("操作人:输入工号！");
				return;
			}
		}
	//审核时间和审核人修改
		var startTime1=obj.timeOper4.getRawValue();
		var startDate1=obj.dateFrm4.getRawValue();
		var comopaId = obj.comopaId.getValue();
		var Handoverperson4 =obj.Handoverperson4.getValue();
		if((startDate1!="")&&(startTime1!=""))
		{
			var ret1=_DHCOPPatTran.PatInfoConfirmbyOpaId(comopaId,"OB",startDate1,startTime1)
			if(ret1!="0")
			{
				alert(ret1);
				return;	
			}else{
				alert("审核时间修改成功")
				}
		}
		if(Handoverperson4!="")
    	{
	    	if(/^\d+$/.test(Handoverperson4)) 
				{ 
					var pacuTransitman=_DHCOPPatTran.GetNameInfoByCode(Handoverperson4);
					if(pacuTransitman=="1"){alert("交接人:工号无效!");return;}
					var ret=_DHCOPPatTran.updateHandoverperson(comopaId,"OB",Handoverperson4)
					if(ret!="0")
					{
						alert(ret);
						return;	
					}else{
						alert("交接人修改成功")
					}
				}else
				{
					alert("交接人:输入工号！");
					return;
				}	
	    }
		self.location.reload();
	}
	obj.btnWard2_click=function()
	{
		
		var startTime=obj.timeOper5.getRawValue();
		var startDate=obj.dateFrm5.getRawValue();
		var comopaId = obj.comopaId.getValue();
		var Operator5 =obj.Operator5.getValue();
		if((startDate!="")&&(startTime!=""))
		{
			var ret=_DHCOPPatTran.SavePatOtherInfoByopaId(comopaId,"OO",startDate,startTime)
			if(ret!="0")
			{
				alert(ret);
				return;	
			}else{
				alert("操作时间修改成功")
				}
		}
		if(Operator5!="")
    	{	
	    	if(/^\d+$/.test(Operator5)) 
			{ 
				var pacuTransitman=_DHCOPPatTran.GetNameInfoByCode(Operator5);
				if(pacuTransitman=="1"){alert("操作人:工号无效!");return;}
				var ret=_DHCOPPatTran.updateOperator(comopaId,"OO",Operator5)
				if(ret!="0")
				{
					alert(ret);
					return;	
				}else{
					alert("操作人修改成功")
				}
			}else
			{
				alert("操作人:输入工号！");
				return;
			}
		}
	//审核时间和审核人修改
		var startTime1=obj.timeOper6.getRawValue();
		var startDate1=obj.dateFrm6.getRawValue();
		var comopaId = obj.comopaId.getValue();
		var Handoverperson6 =obj.Handoverperson6.getValue();
		if((startDate1!="")&&(startTime1!=""))
		{
			var ret1=_DHCOPPatTran.PatInfoConfirmbyOpaId(comopaId,"OI",startDate1,startTime1)
			if(ret1!="0")
			{
				alert(ret1);
				return;	
			}else{
				alert("审核时间修改成功")
				}
		}
		if(Handoverperson6!="")
    	{
	    	if(/^\d+$/.test(Handoverperson6)) 
				{ 
					var pacuTransitman=_DHCOPPatTran.GetNameInfoByCode(Handoverperson6);
					if(pacuTransitman=="1"){alert("交接人:工号无效!");return;}
					var ret=_DHCOPPatTran.updateHandoverperson(comopaId,"OI",Handoverperson6)
					if(ret!="0")
					{
						alert(ret);
						return;	
					}else{
						alert("交接人修改成功")
					}
				}else
				{
					alert("交接人:输入工号！");
					return;
				}	
	    }
		self.location.reload();
	}
	
	obj.btnPrint_click=function()
	{
		var xlsExcel,xlsBook,xlsSheet,fileName,path
    	var path=_UDHCANOPArrange.GetPath();
		//var path="D:\\DTHealth\\app\\dthis\\med\\Results\\Template\\"
		fileName=path+"PatTran.xlsx";
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName) ;
		xlsSheet = xlsBook.ActiveSheet;
		var retStr=_DHCOPPatTran.GetPatInfoByAdmId(EpisodeID);
		if(retStr!="")
		{
			var data=retStr.split("^");
			xlsSheet.cells(4,2)=data[1];
			xlsSheet.cells(4,6)=data[3];
			xlsSheet.cells(4,8)=data[2];	
			xlsSheet.cells(4,10)=data[5];
			xlsSheet.cells(4,12)=data[4];
		}
		//术前信息
		var comopaId = obj.comopaId.getValue();
		if(comopaId==""){alert("手术ID不能为空");return;}
    	var ret2=_DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OB")
    	if (ret2!="")
    	{
	    	//意识状态
	    	var data=ret2.split("^");
	    	if(data[0]==1)
	    	{
		   		xlsSheet.cells(8,2)="清醒"
			}else if(data[0]==2)
			{
				xlsSheet.cells(8,2)="嗜睡"
			}else if(data[0]==3)
	    	{
		    	xlsSheet.cells(8,2)="模糊"
	   		}else if(data[0]==4)
			{
				xlsSheet.cells(8,2)="昏睡"
			}else if(data[0]==5)
			{
				xlsSheet.cells(8,2)="昏迷"	
			}else if(data[0]==6)
			{
				xlsSheet.cells(8,2)="镇静"
			}

			//皮肤情况
			if(data[1]=="N")
	    	{
		   		xlsSheet.cells(8,5)="完整"
			}else if(data[1]=="Y")
			{
				xlsSheet.cells(8,5)="压疮"
			}
			//胃管
			if(data[2]=="N")
	    	{
		   		xlsSheet.cells(10,2)="无"
			}else if(data[2]=="Y")
			{
				xlsSheet.cells(10,2)="有"
			}
			//输液
			if(data[3]=="N")
	    	{
		   		xlsSheet.cells(10,5)="无"
			}else if(data[3]=="Y")
			{
				xlsSheet.cells(10,5)="有"
			}
			//尿管
			if(data[4]=="N")
	    	{
		   		xlsSheet.cells(10,7)="无"
			}else if(data[4]=="Y")
			{
				xlsSheet.cells(10,7)="有"
			}
			//气管插管
			if(data[5]=="N")
	    	{
		   		xlsSheet.cells(12,2)="无"
			}else if(data[5]=="Y")
			{
				xlsSheet.cells(12,2)="有"
			}
			//吸氧管
			if(data[6]=="N")
	    	{
		   		xlsSheet.cells(12,5)="无"
			}else if(data[6]=="Y")
			{
				xlsSheet.cells(12,5)="有"
			}
			//引流管
			if(data[7]=="N")
	    	{
		   		xlsSheet.cells(12,7)="无"
			}else if(data[7]=="Y")
			{
				xlsSheet.cells(12,7)="有"
			}
			//病历
			if(data[8]=="N")
	    	{
		   		xlsSheet.cells(14,2)="无"
			}else if(data[8]=="Y")
			{
				xlsSheet.cells(14,2)="有"
			}
			//术中带药
			if(data[9]=="N")
	    	{
		  		xlsSheet.cells(14,5)="无"
			}else if(data[9]=="Y")
			{
				xlsSheet.cells(14,5)="有"
			}
		
   		}
		var ret3=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,comopaId,"OB")
    	if (ret3!="")
    	{
	    	//意识状态
	    	var data=ret3.split("^");
			xlsSheet.cells(8,7)=data[0];
			xlsSheet.cells(15,2)=data[1];
			xlsSheet.cells(12,9)=data[2];
			xlsSheet.cells(6,3)=data[3];
			xlsSheet.cells(6,5)=data[4];
			xlsSheet.cells(6,7)=data[5];
			xlsSheet.cells(14,7)=data[9];
			xlsSheet.cells(14,9)=data[10];
			
    	}
		//***********术中信息
		
    	var ret4=_DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OI")
    	if (ret4!="")
    	{	
	    	//病人去向
	    	var data=ret4.split("^");
	    	if(data[0]==1)
	    	{
		   		xlsSheet.cells(22,2)="PACU"
			}else if(data[0]==2)
			{
				xlsSheet.cells(22,2)="病房"
			}else if(data[0]==3)
	    	{
		    	xlsSheet.cells(22,2)="ICU"
	   		}
			//意识状态
	    	if(data[1]==1)
	    	{
		   		xlsSheet.cells(23,2)="清醒"
			}else if(data[1]==2)
			{
				xlsSheet.cells(23,2)="嗜睡"
			}else if(data[1]==3)
	    	{
		    	xlsSheet.cells(23,2)="模糊"
	   		}else if(data[1]==4)
			{
				xlsSheet.cells(23,2)="昏睡"
			}else if(data[1]==5)
			{
				xlsSheet.cells(23,2)="昏迷"	
			}else if(data[1]==6)
			{
				xlsSheet.cells(23,2)="镇静"
			}
			//皮肤情况
			if(data[2]=="N")
	    	{
		   		xlsSheet.cells(23,5)="完整"
			}else if(data[2]=="Y")
			{
				xlsSheet.cells(23,5)="压疮"
			}
			//胃管
			if(data[3]=="N")
	    	{
		   		xlsSheet.cells(25,2)="无"
			}else if(data[3]=="Y")
			{
				xlsSheet.cells(25,2)="有"
			}
			//输液
			if(data[4]=="N")
	    	{
		   		xlsSheet.cells(25,5)="无"
			}else if(data[4]=="Y")
			{
				xlsSheet.cells(25,5)="有"
			}
			//尿管
			if(data[5]=="N")
	    	{
		   		xlsSheet.cells(25,7)="无"
			}else if(data[5]=="Y")
			{
				xlsSheet.cells(25,7)="有"
			}
			//气管插管
			if(data[6]=="N")
	    	{
		   		xlsSheet.cells(27,2)="无"
			}else if(data[6]=="Y")
			{
				xlsSheet.cells(27,2)="有"
			}
			//引流管
			if(data[7]=="N")
	    	{
		   		xlsSheet.cells(27,5)="无"
			}else if(data[7]=="Y")
			{
				xlsSheet.cells(27,5)="有"
			}
			
			//病历
			if(data[8]=="N")
	    	{
		   		xlsSheet.cells(29,2)="无"
			}else if(data[8]=="Y")
			{
				xlsSheet.cells(29,2)="有"
			}
			//术中带药
			if(data[9]=="N")
	    	{
		  		xlsSheet.cells(29,6)="未用"
			}else if(data[9]=="Y")
			{
				xlsSheet.cells(29,6)="已用"
			}
		
   		}
		var ret5=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,comopaId,"OI")
    	if (ret5!="")
    	{
	    	var data=ret5.split("^");
			xlsSheet.cells(23,7)=data[0];
			xlsSheet.cells(27,7)=data[2];
			xlsSheet.cells(29,9)=data[6];
			xlsSheet.cells(30,2)=data[1];
    	}
		//***********恢复室信息
		
    	var ret6=_DHCOPPatTran.GetPatInfoById(EpisodeID,comopaId,"OO")
    	if (ret6!="")
    	{
	    	//病人去向
	    	var data=ret6.split("^");
	    	if(data[0]==1)
	    	{
		   		xlsSheet.cells(37,3)="病房"
			}else if(data[0]==2)
			{
				xlsSheet.cells(37,3)="ICU"
			}else if(data[0]==3)
	    	{
		    	xlsSheet.cells(37,3)="其他"
	   		}
			//意识状态
	    	if(data[1]==1)
	    	{
		   		xlsSheet.cells(40,2)="清醒"
			}else if(data[1]==2)
			{
				xlsSheet.cells(40,2)="嗜睡"
			}else if(data[1]==3)
	    	{
		    	xlsSheet.cells(40,2)="模糊"
	   		}else if(data[1]==4)
			{
				xlsSheet.cells(40,2)="昏睡"
			}else if(data[1]==5)
			{
				xlsSheet.cells(40,2)="昏迷"	
			}else if(data[1]==6)
			{
				xlsSheet.cells(40,2)="镇静"
			}
			//皮肤情况
			if(data[2]=="N")
	    	{
		   		xlsSheet.cells(40,5)="完整"
			}else if(data[2]=="Y")
			{
				xlsSheet.cells(40,5)="压疮"
			}
			//胃管
			if(data[3]=="N")
	    	{
		   		xlsSheet.cells(42,2)="无"
			}else if(data[3]=="Y")
			{
				xlsSheet.cells(42,2)="有"
			}
			//输液
			if(data[4]=="N")
	    	{
		   		xlsSheet.cells(42,5)="无"
			}else if(data[4]=="Y")
			{
				xlsSheet.cells(42,5)="有"
			}
			//尿管
			if(data[5]=="N")
	    	{
		   		xlsSheet.cells(42,7)="无"
			}else if(data[5]=="Y")
			{
				xlsSheet.cells(42,7)="有"
			}
			//气管插管
			if(data[6]=="N")
	    	{
		   		xlsSheet.cells(44,2)="无"
			}else if(data[6]=="Y")
			{
				xlsSheet.cells(44,2)="有"
			}
			//吸氧管
			if(data[7]=="N")
	    	{
		   		xlsSheet.cells(44,5)="无"
			}else if(data[7]=="Y")
			{
				xlsSheet.cells(44,5)="有"
			}
			
			//引流管
			if(data[8]=="N")
	    	{
		   		xlsSheet.cells(44,7)="无"
			}else if(data[8]=="Y")
			{
				xlsSheet.cells(44,7)="有"
			}
			//病例
			if(data[9]=="N")
	    	{
		  		xlsSheet.cells(46,2)="无"
			}else if(data[9]=="Y")
			{
				xlsSheet.cells(46,2)="有"
			}
		
   		}
		var ret7=_DHCOPPatTran.GetPatOtherInfoById(EpisodeID,comopaId,"OO")
    	if (ret7!="")
    	{
	    	
	    	var data=ret7.split("^");
			xlsSheet.cells(40,7)=data[0];
			xlsSheet.cells(47,2)=data[1];
			xlsSheet.cells(44,9)=data[2];
			xlsSheet.cells(38,5)=data[3];
			xlsSheet.cells(38,7)=data[4];
			xlsSheet.cells(38,3)=data[5];
			xlsSheet.cells(38,10)=data[6];
			xlsSheet.cells(46,5)=data[10];
			
    	}
		xlsExcel.Visible = true;
		xlsSheet.PrintPreview;
		xlsSheet = null;
 		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null; 
		 
	}
	
	
	
	
	
}
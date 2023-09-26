/// 修改函数:SetEnabled
/// Desc:当为只读时,屏蔽"取消提交"和"审核"按钮.
/// ------------------------------------------------
/// Add By ZY 2011-07-05 Bug ZY0073
/// Discription:增加hold字段的显示，其中Hold1用于存储验收单号
/// -------------------------------------------------
/// Add By DJ 2010-05-31 DJ0044
/// Description:设备分类增加设备分类生成编码标志控制
///--------------------------------------------------
/// 修改:ZY 2009-10-30  zy0014
/// 修改函数:BUpdate_Clicked,FillData
/// 描述:修改设备验收单的录入信息存储
/// 备注:个性需求
/// -----------------------------------------
///修改:zy 2009-10-29 BugNo.ZY0013
///创建函数:BCopy_Clicked
///描述:复制验收单信息
/// -------------------------------
/// 修改:zy 2009-10-28 BugNo.ZY0013
/// 新建函数:GetProviderRowID?GetManuFactoryRowID,
/// 修改函数BUpdate_Clicked?InitEvent
/// 描述:改进功能,对机型,供应商,生产厂商取RowID?
/// 备注0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
/// -------------------------------

//Add by jdl 2010-12-04 导入验收单的附件信息及发票信息
var AffixInfos;
var InvoiceInfos;

function BodyLoadHandler() 
{
	InitStyle("FileNo","7");
	InitUserInfo();
	InitEvent();	//初始化
	FillData();
	//Function:Funds	2012-2-16 生成资金来源信息
	SelfFunds_Change();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole")); //add by QW 2017-12-01 bug号:QW0009 增加验收可编辑字段
	KeyUp("EquiCat^Unit^UseLoc^Currency^Service^PurposeType^Country^BuyType^Model^EquipType^PurchaseType^StatCat^Origin^FromDept^ManuFactory^Provider^Contract^InstallLoc^PackType^CheckType^StoreLoc^WorkLoadUnit^DepreMethod^Brand^SStruct^Location^Expenditures","N");	//清空选择
	Muilt_LookUp("EquiCat^Unit^UseLoc^Currency^Service^PurposeType^Country^BuyType^Model^EquipType^PurchaseType^StatCat^Origin^FromDept^Name^ManuFactory^Provider^Contract^InstallLoc^PackType^CheckType^StoreLoc^WorkLoadUnit^DepreMethod^Brand^SStruct");
	
	Muilt_LookUp("OpenCheckDate^CheckDate^MakeDate^LeaveFactoryDate^Location^Expenditures");
	Muilt_Tab("Code^Quantity^OriginalFee^NetRemainFee^LimitYearsNum^MemoryCode^ServiceTel^DesignWorkLoadNum^ContractNo^ProviderHandler^ProviderTel^Hold1");
	//Muilt_Tab("PackageState^FileState^ConfigState^AffixState^RunningState^OpenState^CheckResult");
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BCheckItem");
	if (obj) obj.onclick=BCheckItem_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
	var obj=document.getElementById("Name");
	if (obj) obj.onchange=ValueClear;
	var obj=document.getElementById(GetLookupName("EquiCat")); //2010-05-25 党军 设备分类以树状结构显示
	if (obj) obj.onclick=EquiCat_Click;
	var obj=document.getElementById(GetLookupName("Name"));
	if (obj) obj.onclick=Equip_Click;
	var ModelOperMethod=GetElementValue("GetModelOperMethod") //2009-07-09 党军 begin DJ0016
	if (ModelOperMethod==1) //1:手工录入 0:放大镜选择操作.
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iModel").removeNode(true)
	} //2009-07-09 党军 end
	
	//2009-10-26 ZY begin ZY0013
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	var GetLocationOperMethod=GetElementValue("GetLocationOperMethod")
	// 0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
	if (GetManuFactoryOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iManuFactory").removeNode(true)
	}
	if (GetProviderOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iProvider").removeNode(true)
	}
	if (GetLocationOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iLocation").removeNode(true)
	}
	var obj=document.getElementById("BCopy"); 
	if (obj) obj.onclick=BCopy_Clicked;
	
	var obj=document.getElementById("BAffix"); //2009-08-21 党军 begin DJ0028
	if (obj) obj.onclick=BAffix_Clicked;
	var obj=document.getElementById("BDoc"); 
	if (obj) obj.onclick=BDoc_Clicked;
	var obj=document.getElementById("BPicture"); 
	if (obj) obj.onclick=BPicture_Clicked; //2009-08-21 党军 end
	var obj=document.getElementById("Configuration");
	if (obj) obj.onclick=Configuration_Clicked;
	//add by jdl 2009-9-12 JDL0029
	var obj=document.getElementById(GetLookupName("Currency"));
	if (obj) obj.onclick=Currency_Click;
	//add by jdl 2010-4-19
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	
	///Add by JDL 2010-11-22 JDL0060
	///根据验收单模板信息导入验收单
	var obj=document.getElementById("BImport");
	if (obj) obj.onclick=BImport_Clicked;
	var obj=document.getElementById("BOtherFunds");
	if (obj) obj.onclick=BOtherFunds_Clicked;
	var obj=document.getElementById("Originalfee");
	if (obj) obj.onchange=SelfFunds_Change;
	var obj=document.getElementById("Quantity");
	if (obj) obj.onchange=SelfFunds_Change;
	var obj=document.getElementById("BCheckEquipZZ");
	if (obj) obj.onclick=BCheckEquipZZ_Clicked;
	var obj=document.getElementById("BAppendFile");
	if (obj) obj.onclick=BAppendFile_Clicked;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=BCancel_Clicked;
	var obj=document.getElementById("BInvoiceMore");		//Add By DJ 2016-08-16
	if (obj) obj.onclick=BInvoiceMore_Clicked;
	var obj=document.getElementById("GuaranteePeriodNum");
	if (obj) obj.onchange=GuaranteePeriodNumChange;
	var obj=document.getElementById("BScan");		//Add By DJ 2017-04-25
	if (obj) obj.onclick=BScan_Clicked;
	var obj=document.getElementById("LeaveFactoryNo");      //Add By JYP 2017-04-15
	if (obj) obj.onchange=LeaveFactoryNoChange;	
}

function CheckNull()
{
	var SelectType=GetElementValue("SelectEquipType");
	var Contract=GetElementValue("ContractDR");
	/// Mozy	2017-10-12	463814	调整对合同信息的判断
	if ((SelectType=="1")||(SelectType==""))
	{
		//if (CheckItemNull(1,"Contract")) return true;
		if (CheckItemNull(2,"ContractListDR","设备名称")) return true;
	/*}
	if (Contract!="")
	{
		if (CheckItemNull(2,"ContractListDR","设备名称")) return true;*/
	}
	if (CheckItemNull(1,"Name")) return true;
	
	if (CheckMustItemNull("Contract^Name^Provider^ManuFactory^Model")) return true;
	
	var obj=document.getElementById("cProvider");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetProviderOperMethod")==0)
		{
			if (CheckItemNull(1,"Provider")==true) return true;
		}
		else
		{
				if (CheckItemNull("","Provider")==true) return true;
		}		
	}
	var obj=document.getElementById("cManuFactory");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetManuFactoryOperMethod")==0)
		{
			if (CheckItemNull(1,"ManuFactory")==true) return true;
		}
		else
		{
			if (CheckItemNull("","ManuFactory")==true) return true;
		}		
	} 
	var obj=document.getElementById("cModel");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetModelOperMethod")==0)
		{
			if (CheckItemNull(1,"Model")==true) return true;
		}
		else
		{
				if (CheckItemNull("","Model")==true) return true;
		}		
	}
	var obj=document.getElementById("cLocation");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetLocationOperMethod")==0)
		{
			if (CheckItemNull(1,"Location")==true) return true;
		}
		else
		{
			if (CheckItemNull("","Location")==true) return true;
		}
	}
	return false;
}

function BCheckItem_Clicked()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckItem&RowID='+GetElementValue("RowID")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BAudit_Clicked()
{
	//20170327 Mozy0184	自动入库出库
	if (CheckAuditNull()) return;                 //modified by czf 364410
	var combindata=GetElementValue("RowID")+"^"+GetOpinion();
	var AutoInOutInfo=cspRunServerMethod(GetElementValue("GetAutoInOut"),combindata);
	//alertShow(combindata+" : "+AutoInOutInfo)
	var list=AutoInOutInfo.split("^");
	var truthBeTold=false;
	var inflag=list[0];
	var outflag=list[1];	
	if(inflag==1)
	{
		truthBeTold=true;
	}
	else if(inflag==2)
	{
		truthBeTold = window.confirm("是否进行自动入库操作?");
	}
	
	if(truthBeTold)
	{
		inflag=1;
		//判断入库单中的科室类型是否属于库房
		if (cspRunServerMethod(GetElementValue("CheckLocStock"),1,curLocID)<0)
		{
			alertShow("当前登陆科室不是库房不能办理自动入库.");
			return;
		}
		else
		{
			truthBeTold=false;
			var obj=document.getElementById("fillData");
			if (obj){var encmeth=obj.value} else {var encmeth=""};
			var ReturnList=cspRunServerMethod(encmeth,GetElementValue("RowID"));
			ReturnList=ReturnList.replace(/\\n/g,"\n");
			Templist=ReturnList.split("^");
			if(outflag==1)
			{
				truthBeTold=true;
			}
			else if(outflag==2)
			{
				truthBeTold = window.confirm("是否进行自动出库操作?");
			}
			
			if(truthBeTold)
			{
				/*自动入库出库*/
				if (Templist[37]=="") 
				{
					alertShow("使用部门未选择不能办理自动出库.");
					return;
				}
				//判断入库单中的科室类型是否属于库房
				if (cspRunServerMethod(GetElementValue("CheckLocStock"),0,GetElementValue("UseLocDR"))<0)
				{
					alertShow("使用部门未设置科室属性不能办理自动出库.");
					return;
				}
				outflag=1
			}
			else
			{
				/*只自动入库*/
				outflag=0
			}
		}
	}
	else
	{
		/*无操作*/
		inflag=0
	}
	
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		alertShow(t["02"])
		return;
	}
	var rowid=GetElementValue("RowID");
	var Type=GetElementValue("Type");
	var Quantity=GetElementValue("Quantity");
	//add by QW 2017-12-01 bug号:QW0009 增加验收可编辑字段
	var objtbl=document.getElementById('tDHCEQOpenCheckRequest');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl,"");
	if (EditFieldsInfo=="-1") return;
	//End  by QW 2017-12-01    
	var encmeth=GetElementValue("GetUpdate");
	if (Quantity=="")
	{
		Quantity=0;
	}
	if (encmeth=="") 
	{
		alertShow(t["02"])
		return;
	}
	if (Type=="2")
	{
		Quantity=GetArriveNum() - Quantity;
		if (Quantity<0)
		{
			alertShow(t["03"]+"  "+Quantity);
			return;
		}
		var ContractListDR=GetElementValue("ContractListDR");
		var combindata=rowid+"^"+ContractListDR+"^"+Quantity+"^Y";
		var result=cspRunServerMethod(encmeth,'','',combindata,'5','',inflag,outflag,EditFieldsInfo);	//20170327 Mozy0184
	}
	if (Type=="1")
	{
		if (CheckAuditNull()) return;
		var combindata=rowid+"^"+GetOpinion();
		var result=cspRunServerMethod(encmeth,'','',combindata,'6','',inflag,outflag,EditFieldsInfo);	//20170327 Mozy0184
	}
    if (result>0)
    {
	    alertShow("审核成功!");   // add by kdf 2018-01-17 需求号：517240、517270
	    window.location.reload(true);
	    //var url=window.location.href
	    //if(url.indexOf("killcache=1")!=-1)  url=url.replace(/killcache=1/,"killcache=0") //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    //else 								url=url.replace(/killcache=0/,"killcache=1")
	    //window.location.href=url 
	}
    else
    {
	    alertShow(t["02"]);
    }
}

function BSubmit_Clicked()
{
	/*
	//检测是否有资质信息
  	var encmeth=GetElementValue("CheckEquipZZ")
  	if (encmeth=="") return;
  	var CheckListDR=GetElementValue("CheckListDR")
	var CheckReturn=cspRunServerMethod(encmeth,CheckListDR,"DHCEQ0007");
	if (CheckReturn==1)
	{
		alertShow("请先确认所有资质是否齐全!")
		return
	}
	*/
	var rowid=GetElementValue("RowID");
	if (GetCheckQuantityNum(GetElementValue("Quantity"))) return;		// Mozy0117	2014-1-27
	///add by zy 2011-10-25 zy0083
	var encmeth=GetElementValue("CheckFeeArea");
	var result=cspRunServerMethod(encmeth,"OpenCheck",rowid);
	var list=result.split("^");
	if (list[0]==-1012)
	{
		alertShow(list[1]+" "+t[list[0]])
		return;
	}
	else if ((list[0]==-1013)||(list[0]==-1014))
	{
		var truthBeTold = window.confirm(list[1]+" "+t[list[0]]);
		if (truthBeTold) return;
	}
	///end by zy 2011-10-25 zy0083
	var encmeth=GetElementValue("GetUpdate");
	//Function:Funds	2012-2-16 生成资金来源信息
	if (GetElementValue("GetSelfFundsID")=="") //2011-05-05 DJ
	{
		alertShow("请设置自有资金参数!")
		return
	}

	//检测录入出厂编号是否有重复 Add by jdl 2010-12-6 JDL0061
	var rtn=CheckLeaveFactoryNo();
	if (rtn!="1") return;
	
	//检测录入数量与出厂编号数量是否一致
	var sysinfo=GetElementValue("GetSysInfo"); //0:不限制 1:提示 2:提交限制
	if (sysinfo!=0)
	{
		var obj=document.getElementById("fillData");
		if (obj){var encmeth1=obj.value} else {var encmeth1=""};
		var ReturnList=cspRunServerMethod(encmeth1,rowid);
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		list=ReturnList.split("^");
		var OldQuantity=list[72];
		var OldLFNo=list[92];
		/*
		var CurQuantity=GetElementValue("Quantity");
		var CurLFNo=GetElementValue("LeaveFactoryNo");
		if (OldQuantity!=CurQuantity)
		{
			alertShow("数量发生变化,请先更新数据!");
			return
		}
		if (OldLFNo!=CurLFNo)
		{
			alertShow("出厂编号发生变化,请先更新数据!");
			return
		}
		*/
		var OldLFNo=OldLFNo.split(",");
		if (OldQuantity!=OldLFNo.length)
		{
			if (sysinfo==1)
			{
				// 20111124  Mozy0069
				var dialogue=t["04"];
				if ((OldLFNo.length==1)&&(OldLFNo[0]=="")) 
				{dialogue=dialogue+0}
				else
				{dialogue=dialogue+OldLFNo.length}
				var truthBeTold = window.confirm(dialogue);
				if (!truthBeTold) return;
			}
			else
			{
				alertShow(t["05"]);
				return;
			}
		}
	}
	//20150822  Mozy0162	档案号的唯一性限制参数设置
	var result=cspRunServerMethod(GetElementValue("CheckFileNo"), 1, GetElementValue("RowID"), GetElementValue("FileNo"));
	if (result!="0")
	{
		var list=result.split("^");
		var msg;
		if (list[0]=="1")
		{	msg="档案中有重复编号,重复编号:"+list[1];		}
		else if (list[0]=="2")
		{	msg="已有设备使用此档案号,重复编号:"+list[1];		}
		else if (list[0]=="3")
		{	msg="已有验收单使用此档案号,重复编号:"+list[1];		}
		if (GetElementValue("CheckFileNoFlag")!=0)
		{
			alertShow(msg+",请核对修正信息!");
	    	return 0;
		}
		else
		{
			var truthBeTold = window.confirm(msg+",是否继续操作?");
	    	if (!truthBeTold) return 0;
		}
	}
	//20170327 Mozy0184	自动入库出库
	var combindata=GetElementValue("RowID")+"^"+GetOpinion();
	var AutoInOutInfo=cspRunServerMethod(GetElementValue("GetAutoInOut"),combindata);
	//alertShow(combindata+" : "+AutoInOutInfo)
	var list=AutoInOutInfo.split("^");
	var truthBeTold=false;
	var inflag=list[0];
	var outflag=list[1];	
	if(inflag==1)
	{
		truthBeTold=true;
	}
	else if(inflag==2)
	{
		truthBeTold = window.confirm("是否进行自动入库操作?");
	}
	
	if(truthBeTold)
	{
		inflag=1;
		//判断入库单中的科室类型是否属于库房
		if (cspRunServerMethod(GetElementValue("CheckLocStock"),1,curLocID)<0)
		{
			alertShow("当前登陆科室不是库房不能办理自动入库.");
			return;
		}
		else
		{
			truthBeTold=false;
			var obj=document.getElementById("fillData");
			if (obj){var encmeth=obj.value} else {var encmeth=""};
			var ReturnList=cspRunServerMethod(encmeth,rowid);
			ReturnList=ReturnList.replace(/\\n/g,"\n");
			Templist=ReturnList.split("^");
			if(outflag==1)
			{
				truthBeTold=true;
			}
			else if(outflag==2)
			{
				truthBeTold = window.confirm("是否进行自动出库操作?");
			}
			
			if(truthBeTold)
			{
				/*自动入库出库*/
				if (Templist[37]=="") 
				{
					alertShow("使用部门未选择不能办理自动出库.");
					return;
				}
				//判断入库单中的科室类型是否属于库房
				if (cspRunServerMethod(GetElementValue("CheckLocStock"),0,GetElementValue("UseLocDR"))<0)
				{
					alertShow("使用部门未设置科室属性不能办理自动出库.");
					return;
				}
				outflag=1
			}
			else
			{
				/*只自动入库*/
				outflag=0
			}
		}
	}
	else
	{
		/*无操作*/
		inflag=0
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		alertShow(t["02"])
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'3','',inflag,outflag);
	//alertShow(result)
	result=result.replace(/\\n/g,"\n")
	if (result > 0)
	{
		alertShow("提交成功!")  //add by kdf 2018-01-17 需求号:517227
		window.location.reload();
		/*var url=window.location.href
	    if(url.indexOf("killcache=1")!=-1)  url=url.replace(/killcache=1/,"killcache=0") //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    else 								url=url.replace(/killcache=0/,"killcache=1")
	    window.location.href=url */
	}
	else
	{
		alertShow(EQMsg(t["02"],result));
	}
}

function BCancelSubmit_Clicked()
{
	var rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("GetUpdate");
	var reason=GetElementValue("RejectReason");
	//Modified by jdl 2011-3-9  jdl0073
	var val=rowid+"^"+reason+"^"+GetElementValue("CurRole");
	if (reason=="")
	{
		alertShow("请输入拒绝原因!");
		SetFocus("RejectReason") 	//2011-02-19 ZY0062
		return;
	}
	if (encmeth=="") 
	{
	alertShow(t["02"])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',val,'4');
	result=result.replace(/\\n/g,"\n")
	if (result > 0)
	{
		alertShow("操作成功!")
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequest&RowID='+result;
		//window.location.reload();
		/*var url=window.location.href
	    if(url.indexOf("killcache=1")!=-1)  url=url.replace(/killcache=1/,"killcache=0") //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    else 								url=url.replace(/killcache=0/,"killcache=1")
	    window.location.href=url */
	}
	else
	{
		alertShow(t["02"]);
	}
}

function BDelete_Clicked()
{	
	var rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		alertShow(t["02"]);
		return;
	}
	//var Info=GetAssetTypeInfo();
	//var result=cspRunServerMethod(encmeth,'','',rowid,'1',Info);
	var AssetType=GetElementValue("AssetType");	//GR0021 删除操作资产卡片信息不能为空
	var ATRowID=GetElementValue("ATRowID");
	var result=cspRunServerMethod(encmeth,'','',rowid,'1',AssetType+"^"+ATRowID);
	result=result.replace(/\\n/g,"\n")
	if (result=="")
	{
		//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+GetElementValue("GetComponentName")+'&Type=0&RowID='+result+"&CheckTypeDR="+GetElementValue("CheckTypeDR");	/// 20150327  Mozy0153
		var url=window.location.href//GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    if(url.indexOf("killcache=1")!=-1)
	    {
		    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+GetElementValue("GetComponentName")+'&killcache=0&Type=0&RowID='+result 
	    }
	    else
	    {
		    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+GetElementValue("GetComponentName")+'&killcache=1&Type=0&RowID='+result 
	    }
	}
	else
	{
		alertShow(t["02"]+",错误代码:"+result);
	}
}
///修改:ZY 2009-10-30  zy0014
///描述:修改设备验收单的录入信息
function BUpdate_Clicked()  
{
	//add by lmm 2018-09-13 begin 693735
	var LimitYearsNum=+GetElementValue("LimitYearsNum");
	if (IsValidateNumber(LimitYearsNum,1,0,0,1)==0)    //modify by mwz 2017-10-25 需求号467117
	{
		alertShow("使用年限数据异常，请修正.");
		return;
	}
	//add by lmm 2018-09-13 end 693735
	var ModelOperMethod=GetElementValue("GetModelOperMethod")
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	var GetLocationOperMethod=GetElementValue("GetLocationOperMethod")
	var GetBrandOperMethod=GetElementValue("GetBrandOperMethod")		//Add By DJ 2016-07-21
	if (CheckNull()) return;
	//Function:Funds	2012-2-16 生成资金来源信息
	if (GetElementValue("GetSelfFundsID")=="") //2011-05-05 DJ
	{
		alertShow("请设置自有资金参数!")
		return
	}

	if (CheckEquipCat(GetElementValue("EquiCatDR"))<0)	//2010-05-31 党军 DJ0044 begin
	{
		alertShow("设备分类设置有误!")
		return
	}	//2010-05-31 党军 DJ0044 end
	var result=CheckEqCatIsEnd(GetElementValue("EquiCatDR"))
	if ((result=="0")||(result=="2"))
	{
		alertShow("当前选择设备分类不是最末级!")
		if (result=="0") return
	}
    var encmeth=GetElementValue("CheckLocType"); //2010-10-26 DJ begin
    if (encmeth=="") return;
    var val=GetElementValue("StoreLocDR")
    if (val!="")
    {
	    var result=cspRunServerMethod(encmeth,'0101',val);
	    if (result=="-1")
	    {
		    alertShow("当前设备库房不是库房")
		    return
	    }
	    var encmeth=GetElementValue("LocIsInEQ");
	    if (encmeth=="") return;
	    var result=cspRunServerMethod(encmeth,"1",val);
	    if (result=="1")
	    {
		    alertShow("当前设备库房不在登录安全组管理范围内")
		    return
	    } //2010-10-26 DJ end
    }
    //2013-01-17 DJ begin
    var RModelDR=GetModelRowID(ModelOperMethod)
    if ((RModelDR<=0)&&(GetElementValue("Model")!=""))
    {
	    alertShow("规格型号登记错误!")
	    return
    }
    var RProvDR=GetProviderRowID(GetProviderOperMethod)
    if ((RProvDR<=0)&&(GetElementValue("Provider")!=""))
    {
	    alertShow("供应商登记错误!")
	    return
    }
    var RManuDR=GetManuFactoryRowID(GetManuFactoryOperMethod)
    if ((RManuDR<=0)&&(GetElementValue("ManuFactory")!=""))
    {
	    alertShow("生产厂家登记错误!")
	    return
    }
       var LocationDR=GetLocationRowID(GetLocationOperMethod)
     if ((LocationDR<=0)&&(GetElementValue("Location")!=""))
    {
	    alertShow("存放地点登记错误!")
	    return
    }
    var BrandDR=GetBrandRowID(GetBrandOperMethod)		//Add By DJ 2016-07-21
    if ((BrandDR<=0)&&(GetElementValue("Brand")!=""))
    {
	    alertShow("品牌登记操作!")
	    return
    }
     //2013-01-17 DJ End
    if(GetElementValue("AssetType")==4)
    {
	    if(GetElementValue("Quantity")>1)
	    {
		    alertShow("每次只能验收一辆")
		    return
		}
	}
	//add by czf 20170831 不计提折旧的设备来源
	var NonDepreOrigins=GetElementValue("GetNonDepreOrigins");
	if(NonDepreOrigins!="")
	{
		var StrArray=NonDepreOrigins.split(",");
		var i=StrArray.length;
		for (var j=0;j<i;j++)
		{
			var origin=StrArray[j].split(",");
			if((GetElementValue("OriginDR")==origin)&&(GetElementValue("DepreMethodDR")!=3))
			{
				alertShow("该设备来源不计提折旧！");
				return
			}
		}
	}
	var combindata="";
    combindata=GetElementValue("RowID") ; //1
    combindata=combindata+"^"+GetElementValue("Name") ;//2
    combindata=combindata+"^"+GetElementValue("Code");//3
    combindata=combindata+"^"+GetElementValue("PurchaseTypeDR"); //4
    combindata=combindata+"^"+GetElementValue("EquipTypeDR"); //5
    combindata=combindata+"^"+GetElementValue("StatCatDR"); //6
    combindata=combindata+"^"+GetElementValue("EquiCatDR"); //7
    combindata=combindata+"^"+GetElementValue("MemoryCode"); //8
    combindata=combindata+"^"+GetElementValue("BuyTypeDR"); //9
    combindata=combindata+"^"+GetElementValue("StoreLocDR"); //10
    combindata=combindata+"^"+GetElementValue("ABCType"); //11
    combindata=combindata+"^"+GetElementValue("PackTypeDR"); //12
    combindata=combindata+"^"+GetElementValue("UnitDR"); //13
	combindata=combindata+"^"+RModelDR; //14               2009-10-26  ZY  ZY0013	
    combindata=combindata+"^"+GetElementValue("CountryDR"); //15
    combindata=combindata+"^"+GetElementValue("CurrencyDR"); //16
    combindata=combindata+"^"+GetElementValue("Quantity"); //17
    combindata=combindata+"^"+GetElementValue("PurposeTypeDR"); //18
    combindata=combindata+"^"+GetElementValue("CurrencyFee"); //19
    combindata=combindata+"^"+RProvDR;//20             2009-10-26  ZY  ZY0013	
    combindata=combindata+"^"+GetElementValue("ProviderHandler"); //21
    combindata=combindata+"^"+GetElementValue("ProviderTel"); //22
    combindata=combindata+"^"+RManuDR;//            2009-10-26  ZY  ZY0013	
    combindata=combindata+"^"+GetElementValue("MakeDate"); //24
    combindata=combindata+"^"+GetElementValue("LeaveFactoryDate"); //25
    combindata=combindata+"^"+GetElementValue("ServiceDR"); //26
    combindata=combindata+"^"+LocationDR					//GetElementValue("ServiceHandler"); //27	存放地点
    //combindata=combindata+"^"+GetElementValue("ServiceTel"); //28
    combindata=combindata+"^"+GetElementValue("GuaranteePeriodNum");	///20150827  Mozy0163	保修期
    combindata=combindata+"^"+GetElementValue("OriginalFee"); //29
    combindata=combindata+"^"+GetElementValue("NetRemainFee"); //30
    combindata=combindata+"^"+GetElementValue("OriginDR"); //31
    combindata=combindata+"^"+GetElementValue("UseLocDR"); //32
    combindata=combindata+"^"+GetElementValue("LimitYearsNum"); //33
    combindata=combindata+"^"+GetElementValue("DepreMethodDR"); //34
    combindata=combindata+"^"+GetElementValue("InstallDate"); //35
    combindata=combindata+"^"+GetElementValue("InstallLocDR"); //36
    combindata=combindata+"^"+GetElementValue("DesignWorkLoadNum"); //37
    combindata=combindata+"^"+GetElementValue("WorkLoadUnitDR"); //38
    combindata=combindata+"^"+GetElementValue("GuaranteeStartDate"); //39
    combindata=combindata+"^"+GetElementValue("GuaranteeEndDate"); //40
    combindata=combindata+"^"+GetElementValue("FromDeptDR"); //41
    combindata=combindata+"^"+GetChkElementValue("GuaranteeFlag"); //42
    combindata=combindata+"^"+GetChkElementValue("UrgencyFlag"); //43
    combindata=combindata+"^"+GetChkElementValue("MeasureFlag"); //44
    combindata=combindata+"^"+GetChkElementValue("MedicalFlag"); //45
    combindata=combindata+"^"+GetChkElementValue("TestFlag"); //46
    combindata=combindata+"^"+GetElementValue("AffixState"); //47
    combindata=combindata+"^"+GetElementValue("CheckResult"); //48
    combindata=combindata+"^"+GetElementValue("CheckUser"); //49
    combindata=combindata+"^"+GetElementValue("ConfigState"); //50
    combindata=combindata+"^"+GetElementValue("FileState"); //51
    combindata=combindata+"^"+GetElementValue("OpenState"); //52
    combindata=combindata+"^"+GetElementValue("PackageState"); //53
    combindata=combindata+"^"+GetElementValue("RejectReason"); //54
    combindata=combindata+"^"+GetElementValue("Remark"); //55
    combindata=combindata+"^"+GetElementValue("RunningState"); //56
    combindata=combindata+"^"+GetElementValue("ContractListDR"); //57
    combindata=combindata+"^"+GetElementValue("ContractNo"); //58
    combindata=combindata+"^"+GetElementValue("CheckTypeDR"); //59
    combindata=combindata+"^"+GetElementValue("CheckDate"); //60
    combindata=combindata+"^"+GetElementValue("OpenCheckDate"); //61
    combindata=combindata+"^"+GetElementValue("ItemDR"); //62
    combindata=combindata+"^"+GetElementValue("Status"); //63
    combindata=combindata+"^"+GetElementValue("LeaveFactoryNo"); //64
    combindata=combindata+"^"+GetElementValue("Hold1"); //65
    combindata=combindata+"^"+GetElementValue("Hold2"); //66
    combindata=combindata+"^"+GetElementValue("Hold3"); //67
    combindata=combindata+"^"+BrandDR; //68		//Modify DJ 2016-07-21
    //combindata=combindata+"^"+GetElementValue("Hold5"); //69
    combindata=combindata+"^"+GetElementValue("ExpendituresDR"); //69	经费来源
    combindata=combindata+"^"+GetChkElementValue("BenefitAnalyFlag");//65
    combindata=combindata+"^"+GetChkElementValue("CommonageFlag");//66
    combindata=combindata+"^"+GetChkElementValue("AutoCollectFlag");//67
    combindata=combindata+"^"+GetElementValue("HSourceType");//68
    combindata=combindata+"^"+GetElementValue("SourceID");//69
    combindata=combindata+"^"+GetElementValue("WorkLoadPerMonth");//70
    combindata=combindata+"^"+GetElementValue("RequestHold1");//76
    combindata=combindata+"^"+GetElementValue("RequestHold2");//77
    combindata=combindata+"^"+GetElementValue("RequestHold3");//78
    combindata=combindata+"^"+GetElementValue("RequestHold4");//79
    combindata=combindata+"^"+GetElementValue("RequestHold5");//80
    combindata=combindata+"^"+GetElementValue("CommonName");//81
  	combindata=combindata+"^"+GetElementValue("ValueType");//82 价值类型
  	combindata=combindata+"^"+GetElementValue("DirectionsUse");//83 使用方向
  	combindata=combindata+"^"+GetElementValue("UserDR"); //84 UserDR
  	combindata=combindata+"^"+GetElementValue("AccountShape");  //85 入账形式
  	combindata=combindata+"^"+GetElementValue("ProjectNo"); //86 项目预算编号
    combindata=combindata+"^"+GetElementValue("AccountNo");  //87 会计凭证号
    combindata=combindata+"^"+GetChkElementValue("Hold6");	//88 放射标志
    combindata=combindata+"^"+GetChkElementValue("Hold7");	//89 中医标志		//Modify DJ 2017-01-20
    combindata=combindata+"^"+GetElementValue("Hold8");
    combindata=combindata+"^"+GetElementValue("Hold9");
    combindata=combindata+"^"+GetElementValue("Hold10");
    combindata=combindata+"^"+GetElementValue("FileNo");
    
    var OriginalFee=parseFloat(GetElementValue("OriginalFee"));
    if (OriginalFee<0)
    {
	    alertShow("请您正确输入原值!")
	    return;
    }
    var Quantity=GetElementValue("Quantity");
    if (Quantity<=0)
    {
	    alertShow("请您正确输入数量!")
	    return
    }
	if (parseInt(Quantity)!=Quantity)
	{
		alertShow("不允许输入小数位数量,请检查修正!");
		SetFocus("Quantity");
		return;
	}
    var encmeth=GetElementValue("UsableQuantity");
    if (encmeth=="") return;
    var val=GetElementValue("RowID")+"^"+GetElementValue("HSourceType")+"^"+GetElementValue("SourceID")
    var result=+cspRunServerMethod(encmeth,val);
    if ((GetElementValue("HSourceType")!=0)&&(result<GetElementValue("Quantity")))
    {
	    alertShow("当前设备可用数量为:"+result+"请您正确输入!");
	    return
    }
    var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	
    // 专属信息		Mozy0145	20141017
    var Info=GetAssetTypeInfo();
	var result=cspRunServerMethod(encmeth,'','',combindata,'2',Info);
	result=result.replace(/\\n/g,"\n")
    if (result>0)
    {
		//add by HHM 20150910 HHM0013
		//添加操作成功是否提示
		ShowMessage();
	   //window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+GetElementValue("GetComponentName")+'&Type=0&RowID='+result
	    var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    if(url.indexOf("killcache=1")!=-1)  window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+GetElementValue("GetComponentName")+"&killcache=0&Type=0&RowID="+result 
	    else 								window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+GetElementValue("GetComponentName")+"&killcache=1&Type=0&RowID="+result
	}
    else
    {
	    if (result=="-1015")
	    {
		    alertShow(t[result])
	    }
	    else
	    {
		    alertShow(t["02"]);
	    }
    }
}

function ValueClear()
{
	SetElement("ContractListDR","");
	SetElement("NameDR","");
	SetElement("ItemDR","");
	SetElement("EquipType","");		//Add By DJ  2016-12-01 begin
	SetElement("EquipTypeDR","");
	SetElement("StatCat","");
	SetElement("StatCatDR","");
	SetElement("EquiCatDR","");
	SetElement("EquiCat","");
	SetElement("CommonName","");	//Add By DJ 2016-12-01 end
}

///修改:2009-11-25 党军 begin DJ0037
///描述:验收单增加来源类型及来源ID
function Equip_Click()
{
	var SourceType=GetElementValue("SourceType");
	if ((SourceType==0)||(SourceType=="")) //设备项
	{
		LookUpMasterItem("GetMasterItem","EquipTypeDR,,Name,AssetType");	/// Mozy0145	20141017
	}
	else if (SourceType==1) //合同
	{
		LookUp("","web.DHCEQOpenCheckRequest:GetContractList","GetContractList","Name,AssetType");	/// Mozy0145	20141017
	}
	else if ((SourceType==2)||(SourceType==3)) //2.采购单 3,计划单
	{
		LookUp("","web.DHCEQOpenCheckRequest:GetBPList","GetBuyPlan","Name,SourceType,AssetType");	/// Mozy0145	20141017
	}
}

function SetContractEnabled()
{
	var SelectType=GetElementValue("SelectEquipType");
	if (SelectType=="0")
	{
		DisableLookup("ContractList",true);
	}
}
///修改:ZY 2009-10-30  zy0014
///描述:修改设备验收单的录入信息
function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	
	list=ReturnList.split("^");
	SetElement("CheckTypeDR", list[1]);
	SetElement("CheckType", list[2]);
	SetElement("EquipTypeDR", list[3]);
	SetElement("EquipType", list[4]);
	SetElement("PurchaseTypeDR", list[5]);
	SetElement("PurchaseType", list[6]);
	SetElement("StatCatDR", list[7]);
	SetElement("StatCat", list[8]);
	SetElement("ProviderDR", list[9]);
	SetElement("Provider", list[10]);
	SetElement("OriginDR", list[11]);
	SetElement("Origin", list[12]);
	SetElement("FromDeptDR", list[13]);
	SetElement("FromDept", list[14]);
	SetElement("EquiCatDR", list[15]);
	SetElement("EquiCat", list[16]);
	
	SetCatNo(list[15]);
	
	SetElement("BuyTypeDR", list[17]);
	SetElement("BuyType", list[18]);
	SetElement("StoreLocDR", list[19]);
	SetElement("StoreLoc", list[20]);
	SetElement("PackTypeDR", list[21]);
	SetElement("PackType", list[22]);
	SetElement("UnitDR", list[23]);
	SetElement("Unit", list[24]);
	SetElement("ModelDR", list[25]);
	SetElement("Model", list[26]);
	SetElement("CountryDR", list[27]);
	SetElement("Country", list[28]);
	SetElement("CurrencyDR", list[29]);
	SetElement("Currency", list[30]);
	SetElement("PurposeTypeDR", list[31]);
	SetElement("PurposeType", list[32]);
	SetElement("ManuFactoryDR", list[33]);
	SetElement("ManuFactory", list[34]);
	SetElement("ServiceDR", list[35]);
	SetElement("Service", list[36]);
	SetElement("UseLocDR", list[37]);
	SetElement("UseLoc", list[38]);
	SetElement("DepreMethodDR", list[39]);
	SetElement("DepreMethod", list[40]);
	SetElement("InstallLocDR", list[41]);
	SetElement("InstallLoc", list[42]);
	SetElement("WorkLoadUnitDR", list[43]);
	SetElement("WorkLoadUnit", list[44]);
	SetElement("ContractListDR", list[45]);
	SetElement("ContractDR", list[46]);
	SetElement("Contract", list[47]);
	SetElement("OpenCheckDate",list[48]);
	SetElement("CheckDate",list[49]);
	SetElement("ProviderHandler",list[50]);
	SetElement("ProviderTel",list[51]);
	SetElement("PackageState",list[52]);
	SetElement("ConfigState",list[53]);
	SetElement("FileState",list[54]);
	SetElement("AffixState",list[55]);
	SetElement("RunningState",list[56]);
	SetElement("OpenState",list[57]);
	SetElement("CheckResult",list[58]);
	SetElement("CheckUser",list[59]);
	SetElement("Status",list[60]);
	SetElement("Remark",list[61]);
	SetElement("RejectReason",list[62]);
	SetElement("ApproveSetDR",list[63]);
	SetElement("NextRoleDR",list[130]);
	SetElement("NextFlowStep",list[131]);
	SetElement("ApproveStatu",list[66]);
	SetElement("ApproveRoleDR",list[67]);
	SetElement("Name",list[112]);	//2013-06-24 DJ0118
	SetElement("ABCType",list[69]);
	SetElement("Code",list[70]);
	SetElement("ItemDR",list[71]);
	SetElement("NameDR",list[71]);
	SetElement("Quantity",list[72]);
	SetElement("OriginalFee",list[73]);
	SetElement("NetRemainFee",list[74]);
	SetElement("LimitYearsNum",list[75]);
	SetElement("MemoryCode",list[76]);
	SetElement("LocationDR",list[77]);			///20150827  Mozy0163
	SetElement("GuaranteePeriodNum",list[78]);	///20150827  Mozy0163
	SetElement("DesignWorkLoadNum",list[79]);
	SetElement("CurrencyFee",list[80]);
	SetElement("ContractNo",list[81]);
	SetChkElement("MedicalFlag",list[82]);
	SetChkElement("MeasureFlag",list[83]);
	SetChkElement("TestFlag",list[84]);
	SetChkElement("UrgencyFlag",list[85]);
	SetChkElement("GuaranteeFlag",list[86]);
	SetElement("GuaranteeStartDate",list[87]);
	SetElement("GuaranteeEndDate",list[88]);
	SetElement("InstallDate",list[89]);
	SetElement("LeaveFactoryDate",list[90]);
	SetElement("MakeDate",list[91]);
	SetElement("LeaveFactoryNo",list[92]);
	SetElement("Hold1",list[93]);  
	SetElement("Hold2",list[94]);
	SetElement("Hold3",list[95]);
	SetElement("BrandDR",list[96]);
	//SetElement("Hold5",list[97]);
	SetElement("ExpendituresDR",list[97]);
	SetChkElement("BenefitAnalyFlag",list[98]);
	SetChkElement("CommonageFlag",list[99]);
	SetChkElement("AutoCollectFlag",list[100]);
	SetElement("SourceType",list[101]);
	SetElement("SourceID",list[102]);
	SetElement("WorkLoadPerMonth",list[103]);
	SetElement("HSourceType",list[101]);
	SetElement("Location",list[105]);
	SetElement("RequestHold1",list[106]);
	SetElement("RequestHold2",list[107]);
	SetElement("RequestHold3",list[108]);
	SetElement("RequestHold4",list[109]);
	SetElement("RequestHold5",list[110]);
	SetElement("CheckListDR",list[111]);
	SetElement("CommonName",list[68]);	//2013-06-24 DJ0118
	SetElement("Brand",list[113]);	//2013-12-11 DJ0122
	SetElement("ValueType",list[114]);
	SetElement("DirectionsUse",list[115]);
	SetElement("UserDR",list[116]);
	SetElement("AccountShape",list[117]);
	SetElement("ProjectNo",list[118]);
	SetElement("User",list[119]);
	SetElement("AccountNo",list[120]);
	SetChkElement("Hold6",list[121]);
	SetChkElement("Hold7",list[122]);		//Modify DJ 2017-01-20
	SetElement("Hold8",list[123]);
	SetElement("Hold9",list[124]);
	SetElement("Hold10",list[125]);
	SetElement("Expenditures",list[126]);	//20150630  Mozy0154
	SetElement("FileNo",list[127]);		//20150819  Mozy0159
	SetElement("CancelFlag",list[134]);		//modified by czf 需求号：354926
	// 专属信息		Mozy0145	20141017
	encmeth=GetElementValue("GetInfoData");
	if (encmeth=="") return;
	//modified by zy ZY0154 2016-12-22 专属信息应该通过验收明细id取值
	var CheckListDR=GetElementValue("CheckListDR")
	if (CheckListDR=="") return;
	var InfoList=cspRunServerMethod(encmeth,0,CheckListDR);
	InfoList=InfoList.replace(/\\n/g,"\n");
	//alertShow(InfoList)
	FillAssetTypeInfo(InfoList);
}

function SetEnabled()
{
	DisableBElement("BCancel",true);
	ReadOnlyElements("RequestHold1",true)
	SetContractEnabled();
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	var ReadOnly=GetElementValue("ReadOnly");
	if (Status=="0") //新增
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableElement("RejectReason",true);  //add by kdf 2018-02-05 需求号：541048
		
	}
	if (Status=="1") //提交
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCheckItem",true);
		DisableBElement("BImport",true);
	}
	if (Status=="2") //审核
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BCheckItem",true);
		DisableBElement("BImport",true);
		var CancelOper=GetElementValue("CancelOper");
		if (CancelOper=="Y")
		{
			DisableBElement("BCancel",false);
			var obj=document.getElementById("BCancel");
			if (obj) obj.onclick=BCancel_Clicked;
		}
	}
	if (Status=="") //点击新增按钮
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCheckItem",true);
		DisableBElement("BEdititem",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAffix",true);
		DisableBElement("BDoc",true);
		DisableBElement("BPicture",true);
		DisableBElement("BCopy",true);
		DisableBElement("Configuration",true);
		EQCommon_HiddenElement("BOtherFunds")
		DisableElement("RejectReason",true);  //add by kdf 2018-02-05 需求号：541048
	}
	if (Status=="3")		//作废单据
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCheckItem",true);
		DisableBElement("BImport",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAffix",true);
		DisableBElement("BDoc",true);
		DisableBElement("BPicture",true);
		DisableBElement("BCopy",true);
		DisableBElement("Configuration",true);
	}
	if (Type!="0")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCheckItem",true);
		DisableBElement("BImport",true);
		var NextStep=GetElementValue("NextFlowStep");           //modified by czf 需求号：354926
		var CurRole=GetElementValue("CurRole");
		var NextRole=GetElementValue("NextRoleDR");
		var RoleStep=GetElementValue("RoleStep");
		///当当前用户角色和下一步角色一致时方可操作
		///如果工作流设置中该步骤可以取消则取消按钮可用
		var CancelFlag=GetElementValue("CancelFlag");
		if (Type=="1")
		{
			if ((CurRole==NextRole)&&(NextStep==RoleStep)&&(CancelFlag=="Y"))
			{
				var obj=document.getElementById("BCancelSubmit");
				if (obj) obj.onclick=BCancelSubmit_Clicked;
				ReadOnlyElement("RejectReason",false);		
			}
			else
			{
				DisableBElement("BCancelSubmit",true);
				DisableBElement("BAudit",true);
				ReadOnlyElement("RejectReason",true);
				if(((CurRole==NextRole)&&(NextStep==RoleStep)&&(CancelFlag!="Y")))
				{
					DisableBElement("BAudit",false);
					var obj=document.getElementById("BAudit");
					if (obj) obj.onclick=BAudit_Clicked;
				}
			}
		}
		if (Type=="2")
		{
			if (NextStep!="")
			{
				DisableBElement("BCancelSubmit",true);
				DisableBElement("BAudit",true);
			}
		}
	}
	else
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BCancel",true);
	}
	if (ReadOnly=="1")
	{
		//DisableBElement("BAffix",true);
		DisableBElement("BDoc",true);
		//DisableBElement("BPicture",true);
		DisableBElement("BCopy",true);
		DisableBElement("Configuration",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancel",true);
	}
}

function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
function GetCurrency(value)
{
	var type=value.split("^");
	var obj=document.getElementById("CurrencyDR");
	obj.value=type[2];
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetStatCat (value)
{
    GetLookUpID("StatCatDR",value);
}
function GetEquiCat(value)
{
	GetLookUpID("EquiCatDR",value);
}
function GetBuyType(value)
{
	GetLookUpID("BuyTypeDR",value);
}
function GetUnit(value)
{
	GetLookUpID("UnitDR",value);
}
function GetCountry(value)
{
	GetLookUpID("CountryDR",value);
}
function GetPurposeType (value)
{
    GetLookUpID("PurposeTypeDR",value);
}
function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
	var list=value.split("^")
	SetElement("ProviderHandler",list[4])
	SetElement("ProviderTel",list[5])
}
function GetManuFactory(value)
{
	GetLookUpID("ManuFactoryDR",value);
}
function GetService (value)
{
    GetLookUpID("ServiceDR",value);
}
function GetOrigin(value)
{
	GetLookUpID("OriginDR",value);
}
function GetFromDept(value)
{
	GetLookUpID("FromDeptDR",value);
}
function GetUser(value)
{
	GetLookUpID("UserDR",value);
}
function GetStoreLoc(value)
{
	GetLookUpID("StoreLocDR",value);
}
function GetDepreMethodID(value)
{
	GetLookUpID("DepreMethodDR",value);
}
function GetPackType (value)
{
    GetLookUpID("PackTypeDR",value);
}
///20150630  Mozy0154
function GetExpenditures(value)
{
    GetLookUpID("ExpendituresDR",value);
}
function GetCheckType(value)
{
	var user=value.split("^");
	var obj=document.getElementById("CheckTypeDR");
	obj.value=user[1];
}
function GetArriveNum()
{
	var encmeth=GetElementValue("getArriveNum");
	var ContractListDR=GetElementValue("ContractListDR");
	return cspRunServerMethod(encmeth,"","",ContractListDR);
}
function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false
}
function GetOpinion()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	var combindata=""
	combindata=combindata+GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	return combindata;
  	
}
function GetContract(value)
{
	SetElement("Name","");
	SetElement("ItemDR","");
	SetElement("ContractListDR","");
	var type=value.split("^");
	var obj=document.getElementById("ContractNo");
	obj.value=type[2];
	GetLookUpID("ContractDR",value);
}
//新增:2009-11-25 党军 DJ0037
//描述:获取采购计划或采购单列表信息
function GetBuyPlan(value)
{
	list=value.split("^");
	SetElement("Name",list[0]);
	SetElement("SourceID",list[1]);
	SetElement("Model",list[2]);
	SetElement("Quantity",list[3]);
	SetElement("ManuFactory",list[4]);
	SetElement("Code",list[6]);
	SetElement("EquipType",list[7]);
	SetElement("EquipTypeDR",list[8]);
	SetElement("StatCat",list[9]);
	SetElement("StatCatDR",list[10]);
	SetElement("EquiCat",list[11]);
	SetElement("EquiCatDR",list[12]);
	
	//add by jdl 2010-7-19
	SetCatNo(list[12]);
	
	SetElement("Unit",list[13]);
	SetElement("UnitDR",list[14]);
	SetElement("ModelDR",list[15]);
	SetElement("ManuFactoryDR",list[16]);
	var obj=document.getElementById("TestFlag")
	if (list[17]=="Y"){
		if (obj) {obj.checked=true;}
		}
	else{
		if (obj) {obj.checked=false;}}
	var obj=document.getElementById("UrgencyFlag")
	if (list[18]=="Y"){
		if (obj) {obj.checked=true;}
		}
	else{
		if (obj) {obj.checked=false;}}
	SetElement("OriginalFee",list[19]);
	SetElement("ItemDR",list[20]);
	SetElement("NameDR",list[20]);
	SetElement("HSourceType",GetElementValue("SourceType"));
	
	SetElement("LimitYearsNum",list[22]);	//Modified by jdl 2012-3-7 JDL0120
	SetElement("CommonName",list[23]);	//2013-06-24 DJ0118
	SetElement("PurposeTypeDR",list[24]);  //Modefied by zc 2014-9-23 ZC0007
	SetElement("PurposeType",list[25]);  //Modefied by zc 2014-9-23 ZC0007
	//add by lmm 2018-03-01 begin 523557
	SetElement("PurchaseTypeDR",list[26]); 
	SetElement("PurchaseType",list[27]); 
	//add by lmm 2018-03-01 end 523557
}

function GetMasterItem(value)
{
	list=value.split("^");
	SetElement("Name",list[0]);
	SetElement("NameDR",list[1]);
	SetElement("ItemDR",list[1]);
	SetElement("Code",list[2]);
	SetElement("EquiCat",list[4]);
	SetElement("EquiCatDR",list[3]);
	SetElement("CommonName",list[0]);  //2013-06-24 DJ0118
	//add by jdl 2010-7-19
	SetCatNo(list[3]);
	
	SetElement("EquipType",list[8]);
	SetElement("EquipTypeDR",list[7]);
	SetElement("StatCat",list[10]);
	SetElement("StatCatDR",list[9]);
	SetElement("Unit",list[6]);
	SetElement("UnitDR",list[5]);
	SetElement("HSourceType",GetElementValue("SourceType")); //2009-11-25 党军 DJ0037
	SetElement("SourceID",list[1]); //2009-11-25 党军 DJ0037
	
	//2010-3-31 党军
	if (list[11]!="") SetElement("DepreMethodDR",list[11]);
	if (list[11]!="") SetElement("DepreMethod",list[12]);
	SetElement("LimitYearsNum",list[13]);
	
	var obj=document.getElementById("Name");
	if (obj) websys_nextfocusElement(obj);
	
}

function GetContractList(value)
{
	val=value.split("^");
	SetElement("Name",val[0]);
	SetElement("Quantity",val[3]); //2009-11-25 党军 DJ0037
	SetElement("HSourceType",GetElementValue("SourceType")); //2009-11-25 党军 DJ0037
	SetElement("SourceID",val[1]); //2009-11-25 党军 DJ0037
	var encmeth=GetElementValue("GetContractListInfo");
	var ValueList=cspRunServerMethod(encmeth,"","",val[1]);
	val=ValueList.split("^");
	SetElement("ContractListDR",val[0]);
	SetElement("ModelDR",val[2]);
	SetElement("Model",val[3]);
	SetElement("ManuFactoryDR",val[4]);
	SetElement("ManuFactory",val[5]);
	SetElement("ProviderDR",val[6]);
	SetElement("Provider",val[7]);
	var obj=document.getElementById("TestFlag")
	if (val[8]=="Y"){
		if (obj) {obj.checked=true;}
		}
	else{
		if (obj) {obj.checked=false;}}
	SetElement("OriginalFee",val[9]);
	SetElement("ProviderHandler",val[10]);
	SetElement("ProviderTel",val[11]);
	var obj=document.getElementById("UrgencyFlag")
	if (val[12]=="Y"){
		if (obj) {obj.checked=true;}
		}
	else{
		if (obj) {obj.checked=false;}}
	SetElement("EquipTypeDR",val[13]);
	SetElement("EquipType",val[14]);
	SetElement("PurchaseTypeDR",val[15]);
	SetElement("PurchaseType",val[16]);
	SetElement("PurposeTypeDR",val[17]);
	SetElement("PurposeType",val[18]);
	SetElement("ServiceDR",val[19]);
	SetElement("Service",val[20]);
	SetElement("ServiceHandler",val[21]);
	SetElement("ServiceTel",val[22]);
	SetElement("NameDR",val[23]);
	SetElement("ItemDR",val[23]);
	SetElement("EquiCatDR",val[24]);
	
	//add by jdl 2010-7-19
	SetCatNo(val[24]);
	
	SetElement("EquiCat",val[25]);
	SetElement("UnitDR",val[26]);
	SetElement("Unit",val[27]);
	SetElement("Code",val[28]);
	SetElement("StatCatDR",val[29]); //2009-11-25 党军 DJ0037
	SetElement("StatCat",val[30]); //2009-11-25 党军 DJ0037
	
	SetElement("LimitYearsNum",val[31]);	//Modified by jdl 2012-3-7 JDL0120
	SetElement("ContractNo",val[32]); //2013-4-28 zy
	SetElement("CommonName",val[33]); //2013-06-24 DJ0118
	SetElement("GuaranteePeriodNum",val[34]);	///20150825  Mozy0163	保修期
	var obj=document.getElementById("Name");
	if (obj) websys_nextfocusElement(obj);
}

//2009-08-21 党军 begin DJ0028

function BAffix_Clicked() 
{
	var ReadOnly=GetElementValue("ReadOnly")
	var encmeth=GetElementValue("GetOpenCheckListDR");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (result<=0) return
	
	var Status=GetElementValue("Status");       //add by czf 需求号：357302
	if(Status!=0){ReadOnly=1}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAffix&CheckListDR='+result+'&ReadOnly='+ReadOnly;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function Configuration_Clicked() 
{
	var result=GetElementValue("ContractListDR");
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckConfig&ContractListDR='+result
	if (GetElementValue("Status")>0) str=str+"&ReadOnly=1";		/// 20150327  Mozy0153
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BDoc_Clicked()
{
	var encmeth=GetElementValue("GetOpenCheckListDR");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (result<=0) return
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDoc&CheckListDR='+result
	if (GetElementValue("Status")>0) str=str+"&ReadOnly=1";		/// 20150327  Mozy0153
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BPicture_Clicked()
{
	var ReadOnly=GetElementValue("ReadOnly")
	var encmeth=GetElementValue("GetOpenCheckListDR");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (result<=0) return
	
	//GR0033
	var Status=GetElementValue("Status");
	var str='dhceq.process.picturemenu.csp?&CurrentSourceType=11&CurrentSourceID='+result+'&Status='+Status+'&ReadOnly='+ReadOnly;
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	
	/*
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPicture&CheckListDR='+result
	if (GetElementValue("Status")>0) str=str+"&ReadOnly=1";		/// 20150327  Mozy0153
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	*/
}

///创建:ZY 2009-10-29 ZY0013
///描述:复制验收单信息
function BCopy_Clicked()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return
	var encmeth=GetElementValue("CopyOpenCheckRequest");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,RowID);
	result=result.replace(/\\n/g,"\n")
    if ((result>0)&&(result!=100))
    {
           ///////modified by  ZY 2009-10-26  ZY0086
	    //window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+GetElementValue("GetComponentName")+'&RowID='+result+'&CurRole='+GetElementValue("CurRole")+'&Type='+GetElementValue("Type")
		var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT='+GetElementValue("GetComponentName")+'&killcache=0&RowID='+result+'&CurRole='+GetElementValue("CurRole")+'&Type='+GetElementValue("Type")
	    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT='+GetElementValue("GetComponentName")+'&killcache=1&RowID='+result+'&CurRole='+GetElementValue("CurRole")+'&Type='+GetElementValue("Type")
	
	}
    else
    {
	    alertShow(t["06"]);
    }
}

//add by jdl 2009-9-12 JDL0029
function Currency_Click()
{
	var CatName=GetElementValue("Currency")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCTree&TreeType=1&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

//add by jdl 2009-9-12 JDL0029
function SetTreeDR(id,text) // 
{
	//alertShow(value);
	
	var obj=document.getElementById("CurrencyDR");	
	if (obj) obj.value=id;
	var obj=document.getElementById("Currency");
	if (obj) obj.value=text;
}

//add by jdl 2010-4-19
function BPrint_Clicked()
{
	Print();
}

//add by jdl 2010-4-19
function Print()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQOpenCheck.xls";
	    xlApp = new ActiveXObject("Excel.Application");

	    xlBook = xlApp.Workbooks.Add(Template);
    	xlsheet = xlBook.ActiveSheet;
    	xlsheet.cells(3,2)=list[4];		//类组
    	xlsheet.cells(3,6)=username;	//制单人
    	xlsheet.cells(4,2)=list[68];	//名称
    	xlsheet.cells(4,6)=list[12];	//设备来源
    	xlsheet.cells(5,2)=list[34];	//生产厂商
    	xlsheet.cells(5,6)=list[26];	//型号规格
    	xlsheet.cells(6,2)=list[73];	//原值
    	xlsheet.cells(6,4)=list[72];	//数量
    	xlsheet.cells(6,6)=list[73]*list[72];	//总额
    	
    	xlsheet.cells(7,2)=GetShortName(list[10],"-");  //供应商
    	xlsheet.cells(7,6)=ChangeDateFormat(list[49]);  //验收日期
    	xlsheet.cells(8,2)=GetShortName(list[38],"-");  //使用科室
    	xlsheet.cells(8,6)=list[32];	//用途
    	
    	xlsheet.cells(9,2)=list[92];  //序列号
    	xlsheet.cells(10,2)=list[61];  //备注
    	
    	xlsheet.cells(11,2)=ChangeDateFormat(GetCurrentDate());  //打印日期
    	//xlsheet.cells(11,6)=;  //管理部门签字
    	//ChangeDateFormat(lista[3])
    	   
    	//var obj = new ActiveXObject("PaperSet.GetPrintInfo");		/// 20150327  Mozy0153
		//var size=obj.GetPaperInfo("DHCEQInStock");
		//if (0!=size) xlsheet.PageSetup.PaperSize = size;
		
		xlsheet.printout; //打印输出
	    //xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    
	    xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}


//add by jdl 2010-7-19
function SetCatNo(CatDR)
{
	if (CatDR=="") return ""
	var encmeth=GetElementValue("GetCatCode");
	var Code=cspRunServerMethod(encmeth,CatDR);
	SetElement("CatCode",Code);	
}

function EquiCat_Click() //2010-05-25 党军 设备分类以树状结构显示
{
	var CatName=GetElementValue("EquiCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}
//2009-08-21 党军 end DJ0028

function SetEquipCat(id,text)
{
	SetElement("EquiCat",text);
	SetElement("EquiCatDR",id);
}


///Add by JDL 2010-11-22 JDL0060
///根据验收单模板信息导入验收单
function ImportCheck()
{
	AffixInfos="";
	InvoiceInfos="";
	
	var FileName=GetFileName();
    if (FileName=="") {return 0;}
    
    var xlApp,xlsheet,xlBook
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(FileName);
    //xlsheet = xlBook.ActiveSheet
    xlsheet =xlBook.Worksheets("验收单");
    
    var Row=2;
    var Col=1;
    var Provider=trim(xlsheet.cells(Row,Col++).text);
    var ProviderHandler=trim(xlsheet.cells(Row,Col++).text);
    var ProviderTel=trim(xlsheet.cells(Row,Col++).text);
    var Name=trim(xlsheet.cells(Row,Col++).text);
    var Model=trim(xlsheet.cells(Row,Col++).text);
    var ModelDR=""
    var OriginalFee=trim(xlsheet.cells(Row,Col++).text);
    var Quantity=trim(xlsheet.cells(Row,Col++).text);
    var ManuFactory=trim(xlsheet.cells(Row,Col++).text);
    var ManuFactoryDR="";
    var Country=trim(xlsheet.cells(Row,Col++).text); 
    var CountryDR="";   
    var LeaveFactoryNo=trim(xlsheet.cells(Row,Col++).text);
    var LeaveFactoryDate=trim(xlsheet.cells(Row,Col++).text);
    var CheckDate=trim(xlsheet.cells(Row,Col++).text);
    var GuaranteePeriodNum=trim(xlsheet.cells(Row,Col++).text);	//保修期
    var ContractNo=trim(xlsheet.cells(Row,Col++).text);	//合同号
    var Remark=trim(xlsheet.cells(Row,Col++).text);
    var Origin=trim(xlsheet.cells(Row,Col++).text);
    var OriginDR="";
    var BuyType=trim(xlsheet.cells(Row,Col++).text);
    var BuyTypeDR="";
    var PurchaseType=trim(xlsheet.cells(Row,Col++).text);
    var PurchaseTypeDR="";
    var PurposeType=trim(xlsheet.cells(Row,Col++).text);
    var PurposeTypeDR="";    
    var UseLoc=trim(xlsheet.cells(Row,Col++).text);
    var UseLocDR="";
    var FileNo=trim(xlsheet.cells(Row,Col++).text);
    var Expenditures=trim(xlsheet.cells(Row,Col++).text);
    var ExpendituresDR="";
    var Location=trim(xlsheet.cells(Row,Col++).text);
    var LocationDR="";
    
    InvoiceInfos=trim(xlsheet.cells(Row,Col++).text);
    
    xlsheet = xlBook.Worksheets("附件");
    var i=2
    while(xlsheet.cells(i,1).text!="") 
    {
	    if (AffixInfos!="") AffixInfos=AffixInfos+"&";
	    AffixInfos=AffixInfos+xlsheet.cells(i,1).text;
	    AffixInfos=AffixInfos+"^"+xlsheet.cells(i,2).text;
	    AffixInfos=AffixInfos+"^"+xlsheet.cells(i,3).text;
	    AffixInfos=AffixInfos+"^"+xlsheet.cells(i,4).text;
	    AffixInfos=AffixInfos+"^"+xlsheet.cells(i,5).text;
	    AffixInfos=AffixInfos+"^"+xlsheet.cells(i,6).text;
	    AffixInfos=AffixInfos+"^"+xlsheet.cells(i,7).text;
	    AffixInfos=AffixInfos+"^";
	    if (xlsheet.cells(i,6).text!="") AffixInfos=AffixInfos+GetPYCode(xlsheet.cells(i,6).text);
	    i++;
	}
    
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet.Quit;
    xlsheet=null;
    if (Name=="")
    {
	    alertShow("设备名称为空!");
	    return 0;
    }
    var encmeth=GetElementValue("GetItemInfo");
	var ItemInfo=cspRunServerMethod(encmeth,Name);
	if (ItemInfo=="")
	{
		alertShow(Name+":尚未定义设备项,请先定义设备项!");
	    return 0;
	}
	var encmeth=GetElementValue("GetIDByDesc");
	if (Country!="")
	{
		CountryDR=cspRunServerMethod(encmeth,"CTCountry",Country);
		if (CountryDR=="")
		{
			alertShow("国别的信息不正确:"+Country);
			return 0;
		}
	}
	if (Origin!="")
	{
		OriginDR=cspRunServerMethod(encmeth,"DHCEQCOrigin",Origin);
		if (OriginDR=="")
		{
			alertShow("设备来源的信息不正确:"+Origin);
			return 0;
		}
	}
	if (BuyType!="")
	{
		BuyTypeDR=cspRunServerMethod(encmeth,"DHCEQCBuyType",BuyType);
		if (BuyTypeDR=="")
		{
			alertShow("采购方式的信息不正确:"+BuyType);
			return 0;
		}
	}
	if (PurchaseType!="")
	{
		PurchaseTypeDR=cspRunServerMethod(encmeth,"DHCEQCPurchaseType",PurchaseType);
		if (PurchaseTypeDR=="")
		{
			alertShow("申购类别的信息不正确:"+PurchaseType);
			return 0;
		}
	}
	if (PurposeType!="")
	{
		PurposeTypeDR=cspRunServerMethod(encmeth,"DHCEQCPurposeType",PurposeType);
		if (PurposeTypeDR=="")
		{
			alertShow("设备用途的信息不正确:"+PurposeType);
			return 0;
		}
	}
    if (UseLoc!="")
	{
		UseLocDR=cspRunServerMethod(encmeth,"CTLoc",UseLoc);
		if (UseLocDR=="")
		{
			alertShow("使用部门的信息不正确:"+UseLoc);
			return 0;
		}
	}
	if (Expenditures!="")
	{
		ExpendituresDR=cspRunServerMethod(encmeth,"DHCEQCExpenditures",Expenditures);
		if (ExpendituresDR=="")
		{
			alertShow("设备经费来源的信息不正确:"+Expenditures);
			return 0;
		}
	}
	var list=ItemInfo.split("^");
	var sort=22;
	ClearData();
	
	SetElement("EquipTypeDR",list[2]);
	SetElement("EquipType",list[sort]);
	
	SetElement("PurchaseTypeDR",PurchaseTypeDR);
	SetElement("PurchaseType",PurchaseType);
	
	SetElement("StatCatDR",list[4]);
	SetElement("StatCat",list[sort+2]);
	SetElement("Provider",Provider);
	
	SetElement("OriginDR",OriginDR);
	SetElement("Origin",Origin);
	//SetElement("FromDeptDR","");
	//SetElement("FromDept","");
	
	SetElement("EquiCatDR",list[3]);
	SetElement("EquiCat",list[sort+1]);
	
	//SetElement("CatCode","");
	
	SetElement("BuyTypeDR",BuyTypeDR);
	SetElement("BuyType",BuyType);
	//SetElement("StoreLocDR","");
	//SetElement("StoreLoc","");
	//SetElement("PackTypeDR","");
	//SetElement("PackType","");
	
	SetElement("UnitDR",list[6]);
	SetElement("Unit",list[sort+3]);
	
	SetElement("Model",Model);
	SetElement("CountryDR",CountryDR);
	SetElement("Country",Country);
	SetElement("CurrencyDR",list[9]);
	SetElement("Currency",list[sort+4]);
	SetElement("PurposeTypeDR",PurposeTypeDR);
	SetElement("PurposeType",PurposeType);
	
	SetElement("ManuFactory",ManuFactory);
	
	//SetElement("ServiceDR","");
	//SetElement("Service","");
	//SetElement("UseLocDR","");
	//SetElement("UseLoc","");
	
	SetElement("DepreMethodDR",list[sort+6]);
	SetElement("DepreMethod",list[sort+7]);
	
	//SetElement("InstallLocDR","");
	//SetElement("InstallLoc","");
	//SetElement("WorkLoadUnitDR","");
	//SetElement("WorkLoadUnit","");
	//SetElement("ContractListDR","");
	//SetElement("ContractDR","");
	//SetElement("Contract","");
	//SetElement("OpenCheckDate","");
	SetElement("CheckDate",CheckDate);
	SetElement("ProviderHandler",ProviderHandler);
	SetElement("ProviderTel",ProviderTel);
	//SetElement("PackageState","");
	//SetElement("ConfigState","");
	//SetElement("FileState","");
	//SetElement("AffixState","");
	//SetElement("RunningState","");
	//SetElement("OpenState","");
	//SetElement("CheckResult","");
	//SetElement("CheckUser","");
	SetElement("Remark",Remark);
	
	SetElement("Name",list[0]);
	//SetElement("ABCType","");
	SetElement("Code",list[1]);
	SetElement("ItemDR",list[sort+8]);
	SetElement("NameDR",list[sort+8]);
	SetElement("SourceID",list[sort+8]);
	SetElement("Quantity",Quantity);
	SetElement("OriginalFee",OriginalFee);
	//SetElement("NetRemainFee","");
	SetElement("LimitYearsNum",list[sort+5]);
	
	//SetElement("MemoryCode","");	
	//SetElement("ServiceHandler","");
	SetElement("GuaranteePeriodNum",GuaranteePeriodNum);
	//SetElement("DesignWorkLoadNum","");
	//SetElement("CurrencyFee","");
	
	SetElement("ContractNo",ContractNo);
	
	//SetElement("GuaranteeStartDate","");
	SetElement("GuaranteeEndDate","");
	//SetElement("InstallDate","");
	
	SetElement("LeaveFactoryDate",LeaveFactoryDate);
	//SetElement("MakeDate","");
	SetElement("LeaveFactoryNo",LeaveFactoryNo);

	SetElement("Hold1",InvoiceInfos);
	//SetElement("Hold2","");
	//SetElement("Hold3","");
	//SetElement("Hold4","");
	//SetElement("Hold5","");
	SetElement("CommonName",list[0]);
	SetElement("UseLocDR",UseLocDR);
	SetElement("UseLoc",UseLoc);
	SetElement("ExpendituresDR",ExpendituresDR);
	SetElement("Expenditures",Expenditures);
	SetElement("FileNo",FileNo);
	SetElement("Location",Location);
	return 1;	
	//alertShow("导入验收信息完成!请更新保存验收信息!");
}

///Add by JDL 2010-11-22 JDL0060
///根据验收单模板信息导入验收单
function ClearData()
{
	SetElement("RowID","");

	//SetElement("CheckTypeDR","");
	//SetElement("CheckType","");
	SetElement("HSourceType","");
	SetElement("SourceType","");
	
	SetElement("EquipTypeDR","");
	SetElement("EquipType","");
	SetElement("PurchaseTypeDR","");
	SetElement("PurchaseType","");
	SetElement("StatCatDR","");
	SetElement("StatCat","");
	SetElement("ProviderDR","");
	SetElement("Provider","");
	SetElement("OriginDR","");
	SetElement("Origin","");
	SetElement("FromDeptDR","");
	SetElement("FromDept","");
	SetElement("EquiCatDR","");
	SetElement("EquiCat","");
	
	SetElement("CatCode","");
	
	SetElement("BuyTypeDR","");
	SetElement("BuyType","");
	SetElement("StoreLocDR","");
	SetElement("StoreLoc","");
	SetElement("PackTypeDR","");
	SetElement("PackType","");
	SetElement("UnitDR","");
	SetElement("Unit","");
	SetElement("ModelDR","");
	SetElement("Model","");
	SetElement("CountryDR","");
	SetElement("Country","");
	SetElement("CurrencyDR","");
	SetElement("Currency","");
	SetElement("PurposeTypeDR","");
	SetElement("PurposeType","");
	SetElement("ManuFactoryDR","");
	SetElement("ManuFactory","");
	SetElement("ServiceDR","");
	SetElement("Service","");
	SetElement("UseLocDR","");
	SetElement("UseLoc","");
	SetElement("DepreMethodDR","");
	SetElement("DepreMethod","");
	SetElement("InstallLocDR","");
	SetElement("InstallLoc","");
	SetElement("WorkLoadUnitDR","");
	SetElement("WorkLoadUnit","");
	SetElement("ContractListDR","");
	SetElement("ContractDR","");
	SetElement("Contract","");
	//SetElement("OpenCheckDate","");
	//SetElement("CheckDate","");
	SetElement("ProviderHandler","");
	SetElement("ProviderTel","");
	SetElement("PackageState","");
	SetElement("ConfigState","");
	SetElement("FileState","");
	SetElement("AffixState","");
	SetElement("RunningState","");
	SetElement("OpenState","");
	SetElement("CheckResult","");
	SetElement("CheckUser","");
	SetElement("Status","");
	SetElement("Remark","");
	SetElement("RejectReason","");
	SetElement("ApproveSetDR","");
	SetElement("NextRoleDR","");
	SetElement("NextFlowStep","");
	SetElement("ApproveStatu","");
	SetElement("ApproveRoleDR","");
	SetElement("Name","");
	SetElement("ABCType","");
	SetElement("Code","");
	SetElement("ItemDR","");
	SetElement("NameDR","");
	SetElement("Quantity","");
	SetElement("OriginalFee","");
	SetElement("NetRemainFee","");
	SetElement("LimitYearsNum","");
	SetElement("MemoryCode","");
	SetElement("ServiceHandler","");
	SetElement("ServiceTel","");
	SetElement("DesignWorkLoadNum","");
	SetElement("CurrencyFee","");
	SetElement("ContractNo","");
	SetChkElement("MedicalFlag",0);
	SetChkElement("MeasureFlag",0);
	SetChkElement("TestFlag",0);
	SetChkElement("UrgencyFlag",0);
	SetChkElement("GuaranteeFlag",0);
	SetElement("GuaranteeStartDate","");
	SetElement("GuaranteeEndDate","");
	SetElement("InstallDate","");
	SetElement("LeaveFactoryDate","");
	SetElement("MakeDate","");
	SetElement("LeaveFactoryNo","");
	//Add ZY 2009-10-30  zy0014
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	
	SetChkElement("BenefitAnalyFlag",0); 
	SetChkElement("CommonageFlag",0); 
	SetChkElement("AutoCollectFlag",0); 	
	SetElement("SourceID","");
	SetElement("WorkLoadPerMonth","");
	
	SetElement("ServiceHandlerDesc","");	
	SetElement("CommonName","");	//2013-06-24 DJ0118
	SetElement("BrandDR","");	//2013-12-11 DJ0122
	SetElement("Brand","");	//2013-12-11 DJ0122
	SetElement("ExpendituresDR","");	//20150819  Mozy0159
	SetElement("Expenditures","");
	SetElement("FileNo","");
}

///Add by JDL 2010-11-22 JDL0060
///根据验收单模板信息导入验收单
function BImport_Clicked()
{
	//填充页面信息
	var Result=ImportCheck();
	if (Result==0) return;
	//alertShow("附件信息:"+AffixInfos);
	//alertShow("发票信息:"+InvoiceInfos);
	//alertShow("导入验收信息完成,请保存后检查核对验收信息!");
	//return;
	
	//自动调用保存验收单
	var OCRRowID=SaveOpenCheckData();
	//alertShow(OCRRowID);
	if (OCRRowID>0)
	{
		//如果有附件和发票信息则调用导入附件发票信息
		//if ((AffixInfos!="")||(InvoiceInfos!=""))
		if ((AffixInfos!=""))
		{
			Result=ImportAffix(OCRRowID);
			if (Result!="1")
			{
				alertShow("导入附件信息失败,请手工补录附件信息!"+Result);
				window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequest&Type=0&RowID='+OCRRowID;
				return;
			}			
		}
	}
	else
	{
		alertShow("导入验收单保存失败!");
		return;
	}
	alertShow("导入验收信息完成,请检查核对验收单信息!");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequest&Type=0&RowID='+OCRRowID;
	
}

///Add by JDL 2010-12-4 
///导入附件信息
function ImportAffix(OCRRowID)
{
	var encmeth=GetElementValue("GetOpenCheckListDR");
	if (encmeth=="") return 0;
	var OCLRowID=cspRunServerMethod(encmeth,OCRRowID);
	if (OCLRowID<=0) return 0;
	//alertShow("OCLRowID:"+OCLRowID);
	var encmeth=GetElementValue("GetImportAffix");
	if (encmeth=="") return 0;
	//var Result=cspRunServerMethod(encmeth,OCLRowID,AffixInfos,InvoiceInfos);
	var Result=cspRunServerMethod(encmeth,OCLRowID,AffixInfos);
	if (Result!="1") return Result;
	return 1;	
}

function SaveOpenCheckData()
{
	var ModelOperMethod=GetElementValue("GetModelOperMethod")
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	var GetLocationOperMethod=GetElementValue("GetLocationOperMethod")
	if (CheckNull()) return 0;
	if (CheckEquipCat(GetElementValue("EquiCatDR"))<0)	//2010-05-31 党军 DJ0044 begin
	{
		alertShow("设备分类设置有误!")
		return 0;
	}	//2010-05-31 党军 DJ0044 end
	var result=CheckEqCatIsEnd(GetElementValue("EquiCatDR"))
	if ((result=="0")||(result=="2"))
	{
		alertShow("当前选择设备分类不是最末级!")
		if (result=="0") return 0;
	}
    var encmeth=GetElementValue("CheckLocType"); //2010-10-26 DJ begin
    if (encmeth=="") return 0;
    var val=GetElementValue("StoreLocDR")
    if (val!="")
    {
	    var result=cspRunServerMethod(encmeth,'0101',val);
	    if (result=="-1")
	    {
		    alertShow("当前设备库房不是库房")
		    return 0;
	    }
	    var encmeth=GetElementValue("LocIsInEQ");
	    if (encmeth=="") return;
	    var result=cspRunServerMethod(encmeth,"1",val);
	    if (result=="1")
	    {
		    alertShow("当前设备库房不在登录安全组管理范围内")
		    return 0;
	    } //2010-10-26 DJ end
    }
	var combindata="";
    combindata=GetElementValue("RowID") ; //1
    combindata=combindata+"^"+GetElementValue("Name") ;//2
    combindata=combindata+"^"+GetElementValue("Code");//3
    combindata=combindata+"^"+GetElementValue("PurchaseTypeDR"); //4
    combindata=combindata+"^"+GetElementValue("EquipTypeDR"); //5
    combindata=combindata+"^"+GetElementValue("StatCatDR"); //6
    combindata=combindata+"^"+GetElementValue("EquiCatDR"); //7
    combindata=combindata+"^"+GetElementValue("MemoryCode"); //8
    combindata=combindata+"^"+GetElementValue("BuyTypeDR"); //9
    combindata=combindata+"^"+GetElementValue("StoreLocDR"); //10
    combindata=combindata+"^"+GetElementValue("ABCType"); //11
    combindata=combindata+"^"+GetElementValue("PackTypeDR"); //12
    combindata=combindata+"^"+GetElementValue("UnitDR"); //13
	combindata=combindata+"^"+GetModelRowID(ModelOperMethod); //14               2009-10-26  ZY  ZY0013	
    combindata=combindata+"^"+GetElementValue("CountryDR"); //15
    combindata=combindata+"^"+GetElementValue("CurrencyDR"); //16
    combindata=combindata+"^"+GetElementValue("Quantity"); //17
    combindata=combindata+"^"+GetElementValue("PurposeTypeDR"); //18
    combindata=combindata+"^"+GetElementValue("CurrencyFee"); //19
    combindata=combindata+"^"+GetProviderRowID(GetProviderOperMethod);//20             2009-10-26  ZY  ZY0013	
    combindata=combindata+"^"+GetElementValue("ProviderHandler"); //21
    combindata=combindata+"^"+GetElementValue("ProviderTel"); //22
    combindata=combindata+"^"+GetManuFactoryRowID(GetManuFactoryOperMethod);//            2009-10-26  ZY  ZY0013	
    combindata=combindata+"^"+GetElementValue("MakeDate"); //24
    combindata=combindata+"^"+GetElementValue("LeaveFactoryDate"); //25
    combindata=combindata+"^"+GetElementValue("ServiceDR"); //26
    //combindata=combindata+"^"+GetElementValue("ServiceHandler"); //27
    combindata=combindata+"^"+GetLocationRowID(GetLocationOperMethod);	///20150827  Mozy0163	存放地点
    //combindata=combindata+"^"+GetElementValue("ServiceTel"); //28
    combindata=combindata+"^"+GetElementValue("GuaranteePeriodNum");	///20150827  Mozy0163	保修期
    combindata=combindata+"^"+GetElementValue("OriginalFee"); //29
    combindata=combindata+"^"+GetElementValue("NetRemainFee"); //30
    combindata=combindata+"^"+GetElementValue("OriginDR"); //31
    combindata=combindata+"^"+GetElementValue("UseLocDR"); //32
    combindata=combindata+"^"+GetElementValue("LimitYearsNum"); //33
    combindata=combindata+"^"+GetElementValue("DepreMethodDR"); //34
    combindata=combindata+"^"+GetElementValue("InstallDate"); //35
    combindata=combindata+"^"+GetElementValue("InstallLocDR"); //36
    combindata=combindata+"^"+GetElementValue("DesignWorkLoadNum"); //37
    combindata=combindata+"^"+GetElementValue("WorkLoadUnitDR"); //38
    combindata=combindata+"^"+GetElementValue("GuaranteeStartDate"); //39
    combindata=combindata+"^"+GetElementValue("GuaranteeEndDate"); //40
    combindata=combindata+"^"+GetElementValue("FromDeptDR"); //41
    combindata=combindata+"^"+GetChkElementValue("GuaranteeFlag"); //42
    combindata=combindata+"^"+GetChkElementValue("UrgencyFlag"); //43
    combindata=combindata+"^"+GetChkElementValue("MeasureFlag"); //44
    combindata=combindata+"^"+GetChkElementValue("MedicalFlag"); //45
    combindata=combindata+"^"+GetChkElementValue("TestFlag"); //46
    combindata=combindata+"^"+GetElementValue("AffixState"); //47
    combindata=combindata+"^"+GetElementValue("CheckResult"); //48
    combindata=combindata+"^"+GetElementValue("CheckUser"); //49
    combindata=combindata+"^"+GetElementValue("ConfigState"); //50
    combindata=combindata+"^"+GetElementValue("FileState"); //51
    combindata=combindata+"^"+GetElementValue("OpenState"); //52
    combindata=combindata+"^"+GetElementValue("PackageState"); //53
    combindata=combindata+"^"+GetElementValue("RejectReason"); //54
    combindata=combindata+"^"+GetElementValue("Remark"); //55
    combindata=combindata+"^"+GetElementValue("RunningState"); //56
    combindata=combindata+"^"+GetElementValue("ContractListDR"); //57
    combindata=combindata+"^"+GetElementValue("ContractNo"); //58
    combindata=combindata+"^"+GetElementValue("CheckTypeDR"); //59
    combindata=combindata+"^"+GetElementValue("CheckDate"); //60
    combindata=combindata+"^"+GetElementValue("OpenCheckDate"); //61
    combindata=combindata+"^"+GetElementValue("ItemDR"); //62
    combindata=combindata+"^"+GetElementValue("Status"); //63
    combindata=combindata+"^"+GetElementValue("LeaveFactoryNo"); //64
    // Add ZY 2009-10-30  zy0014
    combindata=combindata+"^"+GetElementValue("Hold1"); //65
    combindata=combindata+"^"+GetElementValue("Hold2"); //66
    combindata=combindata+"^"+GetElementValue("Hold3"); //67
    combindata=combindata+"^"+GetElementValue("Hold4"); //68
    //combindata=combindata+"^"+GetElementValue("Hold5"); //69
    combindata=combindata+"^"+GetElementValue("ExpendituresDR"); //69	经费来源20150819  Mozy0159
    combindata=combindata+"^"+GetChkElementValue("BenefitAnalyFlag");//65
    combindata=combindata+"^"+GetChkElementValue("CommonageFlag");//66
    combindata=combindata+"^"+GetChkElementValue("AutoCollectFlag");//67
    combindata=combindata+"^"+GetElementValue("HSourceType");//68
    combindata=combindata+"^"+GetElementValue("SourceID");//69
    combindata=combindata+"^"+GetElementValue("WorkLoadPerMonth");//70
    combindata=combindata+"^"+GetElementValue("RequestHold1");//76	20150819  Mozy0159
    combindata=combindata+"^"+GetElementValue("RequestHold2");//77
    combindata=combindata+"^"+GetElementValue("RequestHold3");//78
    combindata=combindata+"^"+GetElementValue("RequestHold4");//79
    combindata=combindata+"^"+GetElementValue("RequestHold5");//80
    combindata=combindata+"^"+GetElementValue("CommonName");//81
  	combindata=combindata+"^"+GetElementValue("ValueType");//82 价值类型
  	combindata=combindata+"^"+GetElementValue("DirectionsUse");//83 使用方向
  	combindata=combindata+"^"+GetElementValue("UserDR"); //84 UserDR
  	combindata=combindata+"^"+GetElementValue("AccountShape");  //85 入账形式
  	combindata=combindata+"^"+GetElementValue("ProjectNo"); //86 项目预算编号
    combindata=combindata+"^"+GetElementValue("AccountNo");  //87 会计凭证号
    combindata=combindata+"^"+GetElementValue("Hold6");
    combindata=combindata+"^"+GetElementValue("Hold7");
    combindata=combindata+"^"+GetElementValue("Hold8");
    combindata=combindata+"^"+GetElementValue("Hold9");
    combindata=combindata+"^"+GetElementValue("Hold10");
    combindata=combindata+"^"+GetElementValue("FileNo");
    //combindata=combindata+"^"+GetElementValue("FileNo");
    var Quantity=GetElementValue("Quantity");
    if (Quantity<=0)
    {
	    alertShow("请您正确输入数量!")
	    return 0;
    }
	if (parseInt(Quantity)!=Quantity)
	{
		alertShow("不允许输入小数位数量,请检查修正!");
		return 0;
	}
    var encmeth=GetElementValue("UsableQuantity");
    if (encmeth=="") return;
    var val=GetElementValue("RowID")+"^"+GetElementValue("HSourceType")+"^"+GetElementValue("SourceID")
    var result=cspRunServerMethod(encmeth,val);
    if ((GetElementValue("HSourceType")!=0)&&(result<GetElementValue("Quantity")))
    {
	    alertShow("当前设备可用数量为:"+result+"请您正确输入!");
	    return 0;
    }
    var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return 0;
	///alertShow(combindata);
	var result=cspRunServerMethod(encmeth,'','',combindata,'2');
	///alertShow(result)
	result=result.replace(/\\n/g,"\n")
	return result;
}

///Add by jdl 2010-12-6 JDL0061
///检测设备序列号是否有重复
function CheckLeaveFactoryNo()
{
	var encmeth=GetElementValue("CheckLeaveFactoryNo");
	if (encmeth=="") return 0;
	
	var result=cspRunServerMethod(encmeth,GetElementValue("LeaveFactoryNo"),"1",GetElementValue("RowID"));
	if (result!="0")
	{
		var list=result.split("^");
		var msg;
		if (list[0]=="1")
		{	msg="出厂编号中有重复编号,重复编号:"+list[1];		}
		else if (list[0]=="2")
		{	msg="已有设备使用此出厂编号,重复编号:"+list[1];		}
		else if (list[0]=="3")
		{	msg="已有验收单使用此出厂编号,重复编号:"+list[1];		}
		
		var truthBeTold = window.confirm(msg+",是否继续操作?");
    	if (!truthBeTold) return 0;		
	}
	return 1;
}

///20150827  Mozy0163	存放地点
function SetLocation(value)
{
	list=value.split("^");
	SetElement("LocationDR",list[0]);
	SetElement("Location",list[2]);
}

//Function:Funds	2012-2-16 生成资金来源信息
///Add By DJ 2011-04-28
function BOtherFunds_Clicked()
{
	var ReadOnly=GetElementValue("ReadOnly")
	var ID=GetElementValue("RowID")
	if (ID=="") return;
	var CheckListDR=GetElementValue("CheckListDR")
	var OCRStatus=GetElementValue("Status")
	var Type=GetElementValue("Type")
	if ((OCRStatus!="0")||(Type==1))
	{
		ReadOnly=1
	}
	var FundsAmount=GetElementValue("OriginalFee")*GetElementValue("Quantity")
	FundsAmount=parseFloat(FundsAmount).toFixed(2);		//20150713  Mozy0156
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQFunds&FromType=0&FromID='+CheckListDR+'&ReadOnly='+ReadOnly+'&FundsAmount='+FundsAmount
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
///Add By DJ 2011-04-28
function SelfFunds_Change()
{
	if (GetElementValue("GetSelfFundsID")=="") //2011-05-05 DJ
	{
		alertShow("请设置自有资金参数!")
		return
	}
	// Mozy0075 2011-12-29
	//var ID=GetElementValue("RowID");
	var ID=GetElementValue("CheckListDR");
	var Originalfee=GetElementValue("OriginalFee");
	if (Originalfee=="") Originalfee=0
	Originalfee=parseFloat(Originalfee);
	var QuantityNum=GetElementValue("Quantity")
	if (QuantityNum=="") QuantityNum=0
	QuantityNum=parseFloat(QuantityNum);
	var OCRStatus=GetElementValue("Status")
	var Type=GetElementValue("Type")
	if (ID=="") //新增单据
	{
		SetElement("SelfFunds", Originalfee*QuantityNum)
	}
	else
	{
		var encmeth=GetElementValue("GetSourceFunds");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,"0",ID,Originalfee*QuantityNum,1);
		if (result<0)
		{
			SetElement("SelfFunds",0)
		}
		else
		{
			SetElement("SelfFunds",result)
		}
	}
	var SelfFunds=GetElementValue("SelfFunds")
	if (SelfFunds=="") SelfFunds=0
	SelfFunds=parseFloat(SelfFunds);
	SelfFunds=SelfFunds.toFixed(2)
	SetElement("SelfFunds",SelfFunds)
	//20150821  Mozy0161
	var tmpValue=parseFloat(Originalfee*QuantityNum);
	tmpValue=tmpValue.toFixed(2)-SelfFunds;
	SetElement("OtherFunds",tmpValue.toFixed(2))
}
// Mozy0117	2014-1-27
function GetCheckQuantityNum(QuantityNum)
{
	if (QuantityNum=="") QuantityNum=0;
	QuantityNum=parseInt(QuantityNum);
	var encmeth=GetElementValue("GetCheckQuantityNum");
	var result=cspRunServerMethod(encmeth,"201007");
	if (result!="")
	{
		list=result.split(",");
		if (list[0]=="") list[0]=0;
		if (list[1]=="") list[1]=0;
		list[0]=parseInt(list[0]);
		list[1]=parseInt(list[1]);
		if (list[0]>list[1])
		{
			alertShow("系统参数设置错误--(代码201007),请联系管理员!");
			return true;
		}
		if (QuantityNum>=list[1])
		{
			alertShow("该单据的设备数量大于系统限制数量,系统禁止提交该单据!");
			return true;
		}
		else if (QuantityNum>=list[0])
		{
			var truthBeTold = window.confirm("该单据的设备数量大于"+list[0]+",是否继续操作?");
			if (!truthBeTold) return true;
		}
	}
	return false;
}

//Add By DJ 2013-12-11 DJ0122
function GetBrandID(value)
{
	var obj=document.getElementById("BrandDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function BCheckEquipZZ_Clicked()
{
	var SourceID=GetElementValue("RowID");
	var SourceListID=GetElementValue("CheckListDR");
	var SourceStatus=GetElementValue("Status");
	if (SourceListID>0)
	{
		var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQ0007&SourceID='+SourceID+'&SourceListID='+SourceListID+'&SourceStatus='+SourceStatus+'&SourceType=OpenCheckRequest';
    	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=640,left=80,top=0')
	}
	else
	{
		alertShow("请先保存数据!")
		return
	}
}
// 专属信息		Mozy0145	20141017
function GetAssetTypeInfo()
{
	var AssetType=GetElementValue("AssetType");
	var combindata=AssetType;
    combindata=AssetType+"^"+GetElementValue("ATRowID");
    
    if (AssetType==1)
    {
	    //GR0019 土地资产卡片
    	//combindata=combindata+"^"+GetElementValue("LRowID");			//0
	    combindata=combindata+"^"+GetElementValue("LEquipDR");
	    combindata=combindata+"^"+GetElementValue("LArea");
	    combindata=combindata+"^"+GetElementValue("LLandNo");
	    combindata=combindata+"^"+GetElementValue("LOwnerFlag");
	    combindata=combindata+"^"+GetElementValue("LPlace");
	    combindata=combindata+"^"+GetElementValue("LSelfUsedArea");
	    combindata=combindata+"^"+GetElementValue("LIdleArea");
	    combindata=combindata+"^"+GetElementValue("LLendingArea");
	    combindata=combindata+"^"+GetElementValue("LRentArea");
	    combindata=combindata+"^"+GetElementValue("LWorkArea");	//10
	    combindata=combindata+"^"+GetElementValue("LOtherArea");
	    combindata=combindata+"^"+GetElementValue("LLendCompany");
	    combindata=combindata+"^"+GetElementValue("LRentCompany");
	    combindata=combindata+"^"+GetElementValue("LOwnerCertificate");
	    combindata=combindata+"^"+GetElementValue("LCertificateNo");
	    combindata=combindata+"^"+GetElementValue("LCertificateDate");
	    combindata=combindata+"^"+GetElementValue("LOwnerKind");
	    combindata=combindata+"^"+GetElementValue("LCertificateArea");
	    combindata=combindata+"^"+GetElementValue("LHold1");
	    combindata=combindata+"^"+GetElementValue("LHold2");	//20
	    combindata=combindata+"^"+GetElementValue("LHold3");
	    combindata=combindata+"^"+GetElementValue("LHold4");
	    combindata=combindata+"^"+GetElementValue("LHold5");
	    combindata=combindata+"^"+GetElementValue("LSelfUsedFee");
	    combindata=combindata+"^"+GetElementValue("LIdleFee");
	    combindata=combindata+"^"+GetElementValue("LLendingFee");
	    combindata=combindata+"^"+GetElementValue("LRentFee");
	    combindata=combindata+"^"+GetElementValue("LWorkFee");
	    combindata=combindata+"^"+GetElementValue("LOtherFee");	
	    combindata=combindata+"^"+GetElementValue("LSelfOwnFee");	//30
	    combindata=combindata+"^"+GetElementValue("LShareFee");
	    combindata=combindata+"^"+GetElementValue("LSubjectsRecorded");
	    combindata=combindata+"^"+GetElementValue("LUsersrightType");
	    combindata=combindata+"^"+GetElementValue("LOwnershipYear");
	    combindata=combindata+"^"+GetElementValue("LGetFee");
	    //combindata=combindata+"^"+GetElementValue("LSourceType");
	    //combindata=combindata+"^"+GetElementValue("LSourceID");
	    combindata=combindata+"^^^"+GetElementValue("LUserRightArea");
	    combindata=combindata+"^"+GetElementValue("LRemark");
    }
    else if (AssetType==2)
    {
   		//GR0014 房屋资产卡片
    	//combindata=combindata+"^"+GetElementValue("BDRowID");
	    combindata=combindata+"^"+GetElementValue("BDEquipDR");
	    combindata=combindata+"^"+GetElementValue("BDStructDR");
	    combindata=combindata+"^"+GetElementValue("BDBuildingArea");
	    combindata=combindata+"^"+GetElementValue("BDUtilizationArea");
	    combindata=combindata+"^"+GetElementValue("BDSubArea");
	    combindata=combindata+"^"+GetElementValue("BDPlace");
	    combindata=combindata+"^"+GetElementValue("BDOwnerFlag");
	    combindata=combindata+"^"+GetElementValue("BDSelfUseArea");
	    combindata=combindata+"^"+GetElementValue("BDLendingArea");
	    combindata=combindata+"^"+GetElementValue("BDRentArea");
	    combindata=combindata+"^"+GetElementValue("BDWorkArea");
	    combindata=combindata+"^"+GetElementValue("BDIdleArea");
	    combindata=combindata+"^"+GetElementValue("BDOtherArea");
	    combindata=combindata+"^"+GetElementValue("BDLendCompany");
	    combindata=combindata+"^"+GetElementValue("BDRentCompany");
	    combindata=combindata+"^"+GetElementValue("BDOwnerCertificate");
	    combindata=combindata+"^"+GetElementValue("BDCertificateNo");
	    combindata=combindata+"^"+GetElementValue("BDCertificateDate");
	    combindata=combindata+"^"+GetElementValue("BDFloorNum");
	    combindata=combindata+"^"+GetElementValue("BDUnderFloorNum");
	    combindata=combindata+"^"+GetElementValue("BDHold1");
	    combindata=combindata+"^"+GetElementValue("BDHold2");
	    combindata=combindata+"^"+GetElementValue("BDHold3");
	    combindata=combindata+"^"+GetElementValue("BDHold4");
	    combindata=combindata+"^"+GetElementValue("BDHold5");
	    //combindata=combindata+"^"+GetElementValue("BDSourceType");
	    //combindata=combindata+"^"+GetElementValue("BDSourceID");
	    combindata=combindata+"^^^"+GetElementValue("BDOwnerKind"); 
	    combindata=combindata+"^"+GetElementValue("BDOwnershipYear");
	    combindata=combindata+"^"+GetElementValue("BDOwner");
	    combindata=combindata+"^"+GetElementValue("BDCompletionDate");
	    combindata=combindata+"^"+GetElementValue("BDSelfUseFee");
	    combindata=combindata+"^"+GetElementValue("BDLendingFee");
	    combindata=combindata+"^"+GetElementValue("BDRentFee");
	    combindata=combindata+"^"+GetElementValue("BDWorkFee");
	    combindata=combindata+"^"+GetElementValue("BDIdleFee");
	    combindata=combindata+"^"+GetElementValue("BDOtherFee");
	    //combindata=combindata+"^"+GetElementValue("BDLandPurposeDR");
	
    }
    else if (AssetType==3)
    {
   		//GR0021 构筑物资产卡片
    	//combindata=combindata+"^"+GetElementValue("SRowID");
	    combindata=combindata+"^"+GetElementValue("SStructDR");
	    combindata=combindata+"^"+GetElementValue("SPlace");
	    combindata=combindata+"^"+GetElementValue("SOwnerFlag");
	    combindata=combindata+"^"+GetElementValue("SOwnerKind");
	    combindata=combindata+"^"+GetElementValue("SCompletionDate");
	    combindata=combindata+"^"+GetElementValue("SRemark");
	    //combindata=combindata+"^"+GetElementValue("SInvalidFlag");
	    //combindata=combindata+"^"+GetElementValue("SSourceType");
	    //combindata=combindata+"^"+GetElementValue("SSourceID");
    }
    else if (AssetType==4)
    {
   		//combindata=combindata+"^"+GetElementValue("VRowID");
   		combindata=combindata+"^"+GetElementValue("VEquipDR");
	    combindata=combindata+"^"+GetElementValue("VehicleNo");
	    combindata=combindata+"^"+GetElementValue("EngineNo");
	    combindata=combindata+"^"+GetElementValue("CarFrameNo");
	    combindata=combindata+"^"+GetElementValue("Displacemint");
	    combindata=combindata+"^"+GetElementValue("Mileage");
	    combindata=combindata+"^^^^^^^"+GetElementValue("SeatNum");
	    combindata=combindata+"^"+GetElementValue("VehicleOrigin");
	    combindata=combindata+"^"+GetElementValue("VPurpose");
	    combindata=combindata+"^"+GetElementValue("Plait");
    }
    else if (AssetType==5)
    {
   	
    }
    else if (AssetType==6)
    {
   	
    }
    else if (AssetType==7)
    {
   	
    }
    else if (AssetType==8)
    {
	    combindata=combindata+"^^^"+GetElementValue("Level");
	    combindata=combindata+"^"+GetElementValue("Year");
	    combindata=combindata+"^"+GetElementValue("OriginPlace");
   	
    }
    else if (AssetType==9)
    {
	    combindata=combindata+"^^^"+GetElementValue("PlantDate");
	    combindata=combindata+"^"+GetElementValue("Life");
	    combindata=combindata+"^"+GetElementValue("Classes");
	    combindata=combindata+"^"+GetElementValue("OriginPlace");
    }
    else if (AssetType==10)
    {
   	
    }
    else if (AssetType==11)
    {
	    combindata=combindata+"^"+GetElementValue("TitleOfInvention");
	    combindata=combindata+"^"+GetElementValue("CertificateNo");
	    combindata=combindata+"^"+GetElementValue("RegistrationDept");
	    combindata=combindata+"^"+GetElementValue("RegistrationDate");
	    combindata=combindata+"^"+GetElementValue("ApprovalNo");
	    combindata=combindata+"^"+GetElementValue("PatentNo");
	    combindata=combindata+"^"+GetElementValue("Inventor");
	    combindata=combindata+"^"+GetElementValue("AnnouncementDate");
    }
    
    return combindata;
}

// 专属信息
function FillAssetTypeInfo(InfoList)
{
	var Info=InfoList.split("^");	
	var AssetType=GetElementValue("AssetType");
	//InfoList增加返回AssetType并放在第一位，后面为附加资产信息
	var AssetType=Info[0];
	SetElement("AssetType",AssetType);
    SetElement("ATRowID",Info[1]);
    if (AssetType==1)
    {
	    //GR0019 土地资产卡片
	    //--------------------------DHC_EQLand-------------------------------------------
	    var LCount=40
    	//SetElement("LRowID",Info[1]);
	    SetElement("LEquipDR",Info[2]);
	    SetElement("LArea",Info[3]);
	    SetElement("LLandNo",Info[4]);
	    SetElement("LOwnerFlag",Info[5]);
	    SetElement("LPlace",Info[6]);
	    SetElement("LSelfUsedArea",Info[7]);
	    SetElement("LIdleArea",Info[8]);
	    SetElement("LLendingArea",Info[9]);
	    SetElement("LRentArea",Info[10]);
	    SetElement("LWorkArea",Info[11]);
	    SetElement("LOtherArea",Info[12]);
	    SetElement("LLendCompany",Info[13]);
	    SetElement("LRentCompany",Info[14]);
	    SetElement("LOwnerCertificate",Info[15]);
	    SetElement("LCertificateNo",Info[16]);
	    SetElement("LCertificateDate",Info[17]);
	    SetElement("LOwnerKind",Info[18]);
	    SetElement("LCertificateArea",Info[19]);
	    SetElement("LHold1",Info[20]);
	    SetElement("LHold2",Info[21]);
	    SetElement("LHold3",Info[22]);
	    SetElement("LHold4",Info[23]);
	    SetElement("LHold5",Info[24]);
	    SetElement("LSelfUsedFee",Info[25]);
	    SetElement("LIdleFee",Info[26]);
	    SetElement("LLendingFee",Info[27]);
	    SetElement("LRentFee",Info[28])
	    SetElement("LWorkFee",Info[29])
	    SetElement("LOtherFee",Info[30])
	    SetElement("LSelfOwnFee",Info[31]) 
	    SetElement("LShareFee",Info[32])
	    SetElement("LSubjectsRecorded",Info[33])
	    SetElement("LUsersrightType",Info[34])
	    SetElement("LOwnershipYear",Info[35])
	    SetElement("LGetFee",Info[36])
	    //SetElement("LSourceType",Info[37])
	    //SetElement("LSourceID",Info[38])
	    SetElement("LUserRightArea",Info[39])
	    SetElement("LRemark",Info[40])
	    //----------DHC_EQEquip-----------
	    var EQCount=1
	    //SetElement("EQAddDate",Info[LCount+1]);
    }
    else if (AssetType==2)
    {
   			    //-----------DHC_EQStructures--------
	    var BDCount=38
   		//GR0014 房屋资产卡片
    	//SetElement("BDRowID",Info[1]);
	    SetElement("BDEquipDR",Info[2]);
	    SetElement("BDStructDR",Info[3]);
	    SetElement("BDBuildingArea",Info[4]);
	    SetElement("BDUtilizationArea",Info[5]);
	    SetElement("BDSubArea",Info[6]);
	    SetElement("BDPlace",Info[7]);
	    SetElement("BDOwnerFlag",Info[8]);
	    SetElement("BDSelfUseArea",Info[9]);
	    SetElement("BDLendingArea",Info[10]);
	    SetElement("BDRentArea",Info[11]);
	    SetElement("BDWorkArea",Info[12]);
	    SetElement("BDIdleArea",Info[13]);
	    SetElement("BDOtherArea",Info[14]);
	    SetElement("BDLendCompany",Info[15]);
	    SetElement("BDRentCompany",Info[16]);
	    SetElement("BDOwnerCertificate",Info[17]);
	    SetElement("BDCertificateNo",Info[18]);
	    SetElement("BDCertificateDate",Info[19]);
	    SetElement("BDFloorNum",Info[20]);
	    SetElement("BDUnderFloorNum",Info[21]);
	    SetElement("BDHold1",Info[22]);
	    SetElement("BDHold2",Info[23]);
	    SetElement("BDHold3",Info[24]);
	    SetElement("BDHold4",Info[25]);
	    SetElement("BDHold5",Info[26]);
	    //SetElement("BDSourceType",Info[27]);
	    //SetElement("BDSourceID",Info[28])
	    SetElement("BDOwnerKind",Info[29])
	    SetElement("BDOwnershipYear",Info[30])
	    SetElement("BDOwner",Info[31])
	    SetElement("BDCompletionDate",Info[32])
	    SetElement("BDSelfUseFee",Info[33])
	    SetElement("BDLendingFee",Info[34])
	    SetElement("BDRentFee",Info[35])
	    SetElement("BDWorkFee",Info[36])
	    SetElement("BDIdleFee",Info[37])
	    SetElement("BDOtherFee",Info[38])
	    //SetElement("BDLandPurposeDR",Info[39])
	    //----------DHC_EQEquip-----------
	    var EQCount=1
	    //SetElement("EQAddDate",Info[BDCount+1]);
	    //-----------DHCEQCBuildingStruct--------
	    var ESCount=1
	    SetElement("BDStruct",Info[BDCount+ESCount+1]);
	    //SetElement("BUBuildingDR",Info[1]) //房屋资产分配明细 GR0014
    }
    else if (AssetType==3)
    {
	    //GR0021 构筑物资产卡
	    //-----------DHC_EQStructures--------
	    var SCount=7
	    //SetElement("SRowID",Info[1]);
   		SetElement("SStructDR",Info[2]);
	    SetElement("SPlace",Info[3]);
	    SetElement("SOwnerFlag",Info[4]);
	    SetElement("SOwnerKind",Info[5]);
	    SetElement("SCompletionDate",Info[6]);
	    SetElement("SRemark",Info[7]);
	    //SetElement("SInvalidFlag",Info[8]);
	    //SetElement("SSourceType",Info[9]);
	    //SetElement("SSourceID",Info[10]);
	    //----------DHC_EQEquip-----------
	    var EQCount=1
	    //SetElement("EQAddDate",Info[SCount+1]);
	    //-------DHC_EQCBuildingStruct------
	    var BSCount=1
	    SetElement("SStruct",Info[SCount+EQCount+1]);
    }
    else if (AssetType==4)
    {
   		//SetElement("VRowID");
	    SetElement("VehicleNo",Info[3]);
	    SetElement("EngineNo",Info[4]);
	    SetElement("CarFrameNo",Info[5]);
	    SetElement("Displacemint",Info[6]);
	    SetElement("Mileage",Info[7]);
	    SetElement("SeatNum",Info[14]);
	    SetElement("VehicleOrigin",Info[15]);
	    SetElement("VPurpose",Info[16]);
	    SetElement("Plait",Info[17]);
    }
    else if (AssetType==5)
    {
   	
    }
    else if (AssetType==6)
    {
   	
    }
    else if (AssetType==7)
    {
   	
    }
    else if (AssetType==8)
    {
	    SetElement("Level",Info[4]);
		SetElement("Year",Info[5]);
		SetElement("OriginPlace",Info[6]);
    }
    else if (AssetType==9)
    {
	    SetElement("OriginPlace",Info[7]);
		SetElement("Classes",Info[6]);
		SetElement("Life",Info[5]);
		SetElement("PlantDate",Info[4]);
    }
    else if (AssetType==10)
    {
   	
    }
    else if (AssetType==11)
    {
	    SetElement("TitleOfInvention",Info[4]);
		SetElement("CertificateNo",Info[5]);
		SetElement("RegistrationDept",Info[6]);
		SetElement("RegistrationDate",Info[7]);
		SetElement("ApprovalNo",Info[8]);
		SetElement("PatentNo",Info[9]);
		SetElement("Inventor",Info[10]);
		SetElement("AnnouncementDate",Info[11]);
    }
}

//Add By DJ 2014-10-15
function BAppendFile_Clicked()
{
	var SourceID=GetElementValue("RowID");
	var SourceListID=GetElementValue("CheckListDR");
	if (SourceListID>0)
	{
		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAppendFile&&OriginalType=9&OriginalID="+SourceListID;
    	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	}
	else
	{
		alertShow("请先保存数据!")
		return
	}
}

function GetSStructDR(para)
{
	var Info=para.split("^");
	SetElement("SStruct",Info[2]);
	SetElement("SStructDR",Info[0]);
	
}
function GetBDStructDR(para)
{
	var Info=para.split("^");
	SetElement("BDStruct",Info[2]);
	SetElement("BDStructDR",Info[0]);
}
//20150822  Mozy0162	增加清空按钮
function BClear_Clicked()
{
	var url=window.location.href//GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题
	if(url.indexOf("killcache=1")!=-1)
	{
		window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT="+GetElementValue("GetComponentName")+"&killcache=0&Type=0&RowID=&CheckTypeDR="+GetElementValue("CheckTypeDR");
	}
	else
	{
		window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT="+GetElementValue("GetComponentName")+"&killcache=1&Type=0&RowID=&CheckTypeDR="+GetElementValue("CheckTypeDR");
	}
}
function BAppendFile_Clicked()
{
	var encmeth=GetElementValue("GetOpenCheckListDR");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (result<=0) return
	
	//GR0033
	var Status=GetElementValue("Status");
	var str='dhceq.process.appendfile.csp?&CurrentSourceType=11&CurrentSourceID='+result+'&Status='+Status
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	
	/*
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPicture&CheckListDR='+result
	if (GetElementValue("Status")>0) str=str+"&ReadOnly=1";		/// 20150327  Mozy0153
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	*/
}
function BCancel_Clicked()
{
	var encmeth=GetElementValue("CheckBuss");
	if (encmeth=="") return;
	var results=cspRunServerMethod(encmeth,1,GetElementValue("RowID"));
	var result=results.split("^")
	if (result[0]!=="0")
	{
		alertShow(result[1])
	}
	else
	{
		var truthBeTold = window.confirm("相关的入库,出库,台账也一起作废!是否继续？");
	    if (!truthBeTold) return;
		var encmeth=GetElementValue("CancelBuss");
		if (encmeth=="") return;
		var results=cspRunServerMethod(encmeth,1,GetElementValue("RowID"));
		var result=results.split("^")
		if (result[0]!=="0")
		{
			if (result[1]!="")
			{
				alertShow("操作失败:"+result[1])
			}
			else
			{
				alertShow("操作失败:"+result[0])
			}
		}
		else
		{
			alertShow("成功作废!")
		    var url=window.location.href
		    if(url.indexOf("killcache=1")!=-1)  window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+GetElementValue("GetComponentName")+"&killcache=0&Type=0&RowID="+GetElementValue("RowID")
		    else 								window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+GetElementValue("GetComponentName")+"&killcache=1&Type=0&RowID="+GetElementValue("RowID")
		}
	}
}
function BInvoiceMore_Clicked()
{
	var CheckListDR=GetElementValue("CheckListDR");
	var ProviderDR=GetElementValue("ProviderDR");
	if (CheckListDR=="")
	{
		alertShow("请先保存验收单!")
		return
	}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInvoiceCertificate&SourceType=6&SourceID='+CheckListDR+'&ProviderDR='+ProviderDR
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
//201702-04	Mozy
function GuaranteePeriodNumChange()
{
	//alertShow("ServiceTelChange:"+GetElementValue("ServiceTel")+GetElementValue("OpenCheckDate"))
	var number=GetElementValue("GuaranteePeriodNum");
	var interval="m";	//年
	var numberInt=parseInt(number);
	if (number!=numberInt)	// 不能进行浮点数的增加操作,需要转化为整数型的增加操作
	{
		interval="m";		//月
		numberInt=parseInt(number*12);
	}
	// ##class(web.DHCEQCommon).DateAdd("yyyy",1,"31/1/2010")
	var encmeth=GetElementValue("GetEndDate");
	var EndDate=cspRunServerMethod(encmeth,interval,numberInt,GetElementValue("CheckDate"));

	SetElement("GuaranteeEndDate",EndDate);
}
function BScan_Clicked()
{
	var RowID=GetElementValue("RowID")
	if (RowID=="")
	{
		alertShow("请先保存单据")
		return
	}
	var ReadOnly=GetElementValue("ReadOnly")
	var encmeth=GetElementValue("GetOpenCheckListDR");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (result<=0) return
	var Status=GetElementValue("Status");
	var str='dhceqcamera.csp?&CurrentSourceType=11&CurrentSourceID='+result+'&Status='+Status+'&ReadOnly='+ReadOnly;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=940,height=650,left=120,top=0')
}
/**
*用于北京康复医院出厂编号便捷输入
*2017-04-15
*JYP
*可以将AKB222,AKB235~40拆分为AKB222,AKB235，AKB236，AKB237，AKB238，AKB239，AKB240
**/
function LeaveFactoryNoChange()
{
	var LeaveFactoryNoOld=document.getElementById("LeaveFactoryNo").value;    //旧出厂编号串
	var LeaveFactoryNoNew=StringBreakUp(LeaveFactoryNoOld,",","~");                                               //新出厂编号串
    SetElement("LeaveFactoryNo",LeaveFactoryNoNew);

}
//定义页面加载方法
document.body.onload = BodyLoadHandler;

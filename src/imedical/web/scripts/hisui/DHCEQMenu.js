/// -------------------------------
/// 修    改:ZY  2010-08-03  No.ZY0026
/// 修改描述:连接折旧设置
/// -------------------------------
/// 新    增:ZY  2010-04-26  No.ZY0022
/// 新增函数:MenuInvoice(),MenuCertificate()
/// 修改描述:连接发票和凭证
/// -------------------------------
/// 修    改:ZY  2009-08-24  No.ZY0010
/// 修改描述:连接设备报废申请
/// -------------------------------
/// Modified by jdl 2009-07-21 JDL0020
/// Add Method:MenuAppendFile
/// Remark?增加附加电子资料
/// -------------------------------

var menuequipdr;
///设备启用
function MenuStart()
{
	if (!CheckEquipDR()) return;
	var str='dhceqstart.csp?RowID='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}

///设备停用
function MenuStop()
{
	if (!CheckEquipDR()) return;
	var str='dhceqstop.csp?RowID='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}

///设备移动
function MenuMove()
{
	if (!CheckEquipDR()) return;
	var str='dhceqmove.csp?RowID='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}

///设备年限变动
function MenuChangeYears()
{
	if (!CheckEquipDR()) return;
	var str='dhceqchangeyears.csp?RowID='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
    
}

///设备调拨
function MenuMoveOut()
{
	if (!CheckEquipDR()) return;
	var str='dhceqmoveout.csp?RowID='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}

///设备调帐
function MenuChangeAccount()
{
	if (!CheckEquipDR()) return;
	var str='dhceqchangeaccount.csp?RowID='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
	SetWindowSize(str,1)
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}
///打印条码
function MenuPrintBarCode()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPrintBarCode';
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=480,height=280,left=120,top=0')
}
/// -------------------------------
/// 修    改:ZY  2009-08-24  No.ZY0010
/// 修改描述:连接设备报废申请
/// --------------------------------
///设备报废申请
function MenuDisuseRequest()
{
	if (!CheckEquipDR()) return;
	
	var EquipDR=menuequipdr
	var obj=document.getElementById("GetDisuseRequestRowID");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var DisuseReqquestRowID=cspRunServerMethod(encmeth,EquipDR);
	var ReadOnly=GetElementValue("ReadOnly");
	if (DisuseReqquestRowID!="")
	{
		var list=DisuseReqquestRowID.split("^")
		//Modified by jdl 2011-12-13 JDL0104
		var Component="DHCEQBatchDisuseRequest";
		if (list[2]=="2") Component="DHCEQDisuseRequestSimple";
		var str='websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&DType=1&Type=0&EquipDR='+menuequipdr+"&RowID="+list[0]+"&ApproveSetDR="+list[1]+"&RequestLocDR="+session["LOGON.CTLOCID"]+"&ReadOnly="+ReadOnly;   //modified by czf 需求号：359844
	}
	if (DisuseReqquestRowID=="")
	{
		var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&DType=1&Type=0&EquipDR='+menuequipdr+"&RequestLocDR="+session["LOGON.CTLOCID"]+"&ReadOnly="+ReadOnly;
	}
		
	//var str='dhceqdisuserequest.csp?DType=1&Type=0&EquipDR='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=680,left=120,top=0')
}

///设备报废
function MenuDisuse()
{
	if (!CheckEquipDR()) return;
	var str='dhceqdisuserequest.csp?DType=2&RowID='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}

///设备使用记录
function MenuUseRecord()
{
	if (!CheckEquipDR()) return;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUseRecordFind&EquipDR='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}

///设备支出费用
function MenuLifeFee()
{
	if (!CheckEquipDR()) return;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQLifeFeeFind&EquipDR='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}

///设备变动记录
function MenuChangeInfo()
{
	if (!CheckEquipDR()) return;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQChangeInfoFind&EquipNameDR='+menuequipdr;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}


///检查是否已经选定设备
function CheckEquipDR()
{
	menuequipdr=GetEquipDR();
	if ((menuequipdr=="")||(menuequipdr<1))
	{
		messageShow("","","",t[-4004]);
		return false;
	}
	return true;
}

///设备图片资料
function MenuPicture()
{
	/*
	if (!CheckEquipDR()) return;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPicture&EquipDR='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
	//var str='dhceqpicture.csp?EquipDR='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
    */
    //GR0053 EXTJS图片上传
    if (!CheckEquipDR()) return;
    var str='dhceq.process.picturemenu.csp?&CurrentSourceType=52&CurrentSourceID='+menuequipdr+'&EquipDR='+menuequipdr
	//window.open(str,'_blank','toolbar=no,location=no,menubar=no,status=no,resizable=yes')
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
}

///设备资料
function MenuDoc()
{
	if (!CheckEquipDR()) return;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDoc&EquipDR='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}

///附件
function MenuAffix()
{
	if (!CheckEquipDR()) return;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAffix&EquipDR='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');	
}

///附加费
function MenuAppendFee()
{
	if (!CheckEquipDR()) return;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAppendFee&EquipDR='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}
function MenuAppendFeeLook()
{
	if (!CheckEquipDR()) return;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAppendFee&EquipDR='+menuequipdr+"&ReadOnly=1";
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}
///设备配置
function MenuConfig()
{
	if (!CheckEquipDR()) return;
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQConfig&EquipDR='+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}

///服务合同
function MenuServiceContract()
{
	if (!CheckEquipDR()) return;
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&EquipDR="+menuequipdr+"&ReadOnly="+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

///电子资料
function MenuAppendFile()
{
	//GR0046 EXTJS文件上传
    if (!CheckEquipDR()) return;
    var str='dhceq.process.appendfile.csp?&CurrentSourceType=52&CurrentSourceID='+menuequipdr
	//window.open(str,'_blank','toolbar=no,location=no,menubar=no,status=no,resizable=yes')
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	/*
	var AppendFileSourceID=GetElementValue("RowID");
	if ((AppendFileSourceID=="")||(AppendFileSourceType)=="") return;
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAppendFile&&OriginalType="+AppendFileSourceType+"&OriginalID="+AppendFileSourceID;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
    */
}

///生命周期
function MenuLifeInfo()
{
	if (!CheckEquipDR()) return;
	//var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQLifeInfo&EquipDR='+menuequipdr;
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
    var para="&EquipDR="+menuequipdr;
	var url="dhceq.process.lifeinfo.csp?"+para;
	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=680,left=120,top=0')
}
///关联设备
function MenuAssociated()
{
	if (!CheckEquipDR()) return;
	var str='dhceqassociated.csp?ParEquipDR='+menuequipdr;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function MenuMasterItem()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem';
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function MenuModel()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCModel';
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function MenuManufacturer()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCManufacturer';
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function MenuVendor()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQVendor';
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

//Function:Funds	2012-2-16 生成资金来源信息
///资金来源 2011-05-05 DJ 修改
function MenuFunds()
{
	if (!CheckEquipDR()) return;
	var FundsAmount=GetElementValue("OriginalFee");
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQFunds&FromType=1&FromID='+menuequipdr+"&ReadOnly=1&FundsAmount="+FundsAmount;
	//hisui改造 modify by czf 20181011 begin 
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
	var iWidth=1080
	var iHeight=650
  	var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
	var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
	SetWindowSize(str,false,iWidth,iHeight,iTop,iLeft,"资金来源","true","","")
	// hisui改造 modified by czf 20181010 end
}
function MenuFundsLook() //2011-05-05 DJ 修改
{
	if (!CheckEquipDR()) return;
	var FundsAmount=GetElementValue("OriginalFee");
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQFunds&FromType=1&FromID='+menuequipdr+"&ReadOnly=1&FundsAmount="+FundsAmount;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}

///修改发票
function MenuInvoice()
{
	var rowid=GetElementValue("InvoiceNoDR");
	if (rowid=="")
	{
		alertShow("请选择要修改的发票!")
		return;
	}
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInvoice&RowID="+rowid;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=580,left=120,top=0')
}
///修改凭证
function MenuCertificate()
{
	var InvoiceNoDR=GetElementValue("InvoiceNoDR");
	var encmeth=GetElementValue("GetCertiByInvoice");
	if (encmeth=="") return
	var rtn=cspRunServerMethod(encmeth,InvoiceNoDR);
	if (rtn=="")
	{
		alertShow("凭证号不能为空!")
		return;
	}
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCertificate&RowID="+rtn;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=580,left=120,top=0')
}
///修改设备信息
function MenuUpdateLeavefactoryNo()
{
	BUpdate_Clicked();
}

/// 修    改:ZY  2010-08-03  No.ZY0026
///折旧设置(更新)
function MenuDepreSet(val)
{
	DepreSet(val,0)
}
/// 修    改:ZY  2010-08-03  No.ZY0026
///折旧设置(审核)
function MenuDepreSetAudit(val)
{
	DepreSet(val,1)
}
/// 修    改:ZY  2010-08-03  No.ZY0026
function DepreSet(val,Flag)
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var list=val.split("&");
	if (list[1]=="Type=cat")
	{
		var SourceTypeDR=1
		var SourceType="分类"
		var SourceID=GetElementValue("Desc");
	}
	else if (list[1]=="Type=equip")
	{
		var SourceTypeDR=0
		var SourceType="设备"
		var SourceID=GetElementValue("Name");
	}
	var link="&SourceTypeDR="+SourceTypeDR;
	link=link+"&PreSourceType="+SourceType
	link=link+"&SourceIDDR="+GetElementValue("RowID");
	link=link+"&PreSourceID="+SourceID
	link=link+"&Flag="+Flag
	link=link+"&DepreTypeDR=1"
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSet'+link
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=500,left=131,top=0')
}

///Add By JDL 2011-05-11 JDL0081
///付款计划
function MenuPayPlan()
{
	///SourceType:1合同  2验收
	var SourceType=GetElementValue("PayPlanSourceType");
	var SourceID=GetElementValue("RowID");
	if ((SourceType!="1")&&(SourceType!="2"))
	{
		alertShow("业务类型不对,不支持付款计划!");
		return;
	}
	if (SourceID=="")
	{
		alertShow("请先保存该数据,才能处理付款计划!");
		return;
	}
	var ReadOnly=GetElementValue("ReadOnly");
	if (GetElementValue("Status")!=0) ReadOnly=1;	//HISUI改造 modified by czf 20180831
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQPayPlan&SourceType="+SourceType+"&SourceID="+SourceID+"&ReadOnly="+ReadOnly;
	showWindow(str,"付款计划","","","icon-w-paper","modal","","","large");	//modify by lmm 2019-02-16


}
///Add By ZY 20141126  ZY0124
///维修申请
function MenuMaintRequest()
{
	if (!CheckEquipDR()) return;
	var Status=0;
	var RowID="";
	var str="dhceqmaintrequestnew.csp?RowID="+RowID+"&Status="+Status+"&EquipDR="+menuequipdr;
	messageShow("","","",str)
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=580,left=120,top=0')
}

///2015-08-04 ZY0134 设备停用
function MenuStopEquip()
{
	if (!CheckEquipDR()) return;
	var ReadOnly=GetElementValue("ReadOnly");
	var Status=GetElementValue("Status");
	if (Status=="2")
	{
		//alertShow("设备已经是停用状态,不能操作!")
		//return
		ReadOnly=1;		/// 20150918  Mozy0166
	}
	var StatusDisplay=GetElementValue("StatusDisplay");
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipStop&EquipID='+menuequipdr+"&ReadOnly="+ReadOnly+"&FromStatusDR="+Status+"&FromStatus="+StatusDisplay+"&StopFlag=Y";   //hisui改造 add by lmm 2018-08-18
	SetWindowSize(str,1)
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=500,left=120,top=0');
}
///2015-08-04 ZY0134 设备启用
function MenuStartEquip()
{
	if (!CheckEquipDR()) return;
	var ReadOnly=GetElementValue("ReadOnly");
	var Status=GetElementValue("Status");
	if (Status<"2")
	{
		//alertShow("设备不是停用状态,,不能操作!")
		//return
		ReadOnly=1;		/// 20150918  Mozy0166
	}
	var StatusDisplay=GetElementValue("StatusDisplay");
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipStart&EquipID='+menuequipdr+"&ReadOnly="+ReadOnly+"&FromStatusDR="+Status+"&FromStatus="+StatusDisplay+"&StartFlag=Y";   //hisui改造 add by lmm 2018-08-18
	SetWindowSize(str,1)
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=500,left=120,top=0');
}
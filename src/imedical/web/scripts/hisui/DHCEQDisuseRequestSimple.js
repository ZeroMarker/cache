///记录 设备 RowID?处理重复选择RowID的问题
var ObjSources=new Array();
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;
//操作行号
var selectrow=0;
var Component;

function BodyLoadHandler() 
{
	//add hly 20200422 begin
	var Reason = $HUI.combobox("#Reason",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1',text:'影响使用安全、无法维修'},{id:'2',text:'性能下降、达不到基本质量要求'},{id:'3',text:'技术落后、技术已淘汰'}
			,{id:'4',text:'维修费用比例过高'},{id:'5',text:'原产品已停产、无零配件供应、且无类似替代品'},{id:'6',text:'使用年限超时'},{id:'7',text:'未达到国家计量标准，又无法矫正修复'}
			,{id:'8',text:'相关试剂耗材无法测证'},{id:'9',text:'国家有关部门公布淘汰、禁止产品'},{id:'10',text:'特殊设备强制报废'},{id:'11',text:'设备残缺不全、或丢失'}
		]
	});
	//add hly 20200422 end
	KeyUp("RequestLoc^Loc^Equip^DisuseType^EquipType","N");	//清空选择
	Muilt_LookUp("RequestLoc^Loc^Equip^DisuseType^EquipType"); //回车选择
	Component=GetElementValue("ComponentName");
	if (Component=="") Component="DHCEQBatchDisuseRequest";
	InitStyle("Remark","5");
	InitUserInfo();
	InitPage();
	FillData(Reason); //modified hly 20200422
	setButtonText(); //add by lmm 2019-11-22 LMM0050
	//单种报废
	if (Component=="DHCEQBatchDisuseRequest")
	{
		var RowIDs=GetElementValue("RowIDs");
		if (RowIDs!="")	SetElement("Amount", RowIDs.split(",").length);
				
		
		var obj=document.getElementById("KindFlag");
		if (obj)
		{
			
				///hisui改造 modify by lmm 2018-08-17 begin
				$('#KindFlag').combobox('options').onSelect=function(){
						KindFlag_Change();
				
				}
				var KindFlagvalue=jQuery("#KindFlag").combobox("getValue")
				///hisui改造 modify by lmm 2018-08-17 end
				
				
						//obj.onchange=KindFlag_Change;
						//修改报废选择批量报废时,设备明细不能选择的问题
						if (KindFlagvalue==0) 
						{
							DisableBElement("EquipList",true);
						}
						else
						{
							var obj=document.getElementById("EquipList");
							if (obj) obj.onclick=EquipListClick;
						}
							
			
		}		
	}
	else
	{
		SetTableItem('','');
		SetElement("Job",GetElementValue("TJobz1"))
	}
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));     //add by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	SetDisplay();
	SetEnabled();
	initButtonWidth()  //hisui改造 add by lmm 2018-08-20

	var status=GetElementValue("Status")
	hideButton(status);
	
	SetTableMarginbottom()	//HISUI改造 add by kdf 20190125 需求号：814963
	Muilt_Tab() //add by lmm 2020-06-29 回车下一输入框
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
	var obj=document.getElementById("BPrint");   
	if (obj) obj.onclick=BPrint_Click;
	
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	//Add By QW20191008 BUG:QW0028 增加报废恢复按钮
    var obj=document.getElementById("BRecover");
	if (obj) obj.onclick=BRecover_Click;
	//End By QW20191008 BUG:QW0028
	
	///Modiedy by zc0057 报废打印标签  begin
	var obj=document.getElementById("BDisusePrintBar");
	if (obj) obj.onclick=BDisusePrintBar_Click;
	///Modiedy by zc0057 报废打印标签  begin
}



function KindFlag_Change()
{
	Clear();
	var KindFlag=GetElementValue("KindFlag")
	if (KindFlag==0)
	{
		DisableBElement("EquipList",true);
	}
	else
	{
		DisableBElement("EquipList",false);
		var obj=document.getElementById("EquipList");
		if (obj) obj.onclick=EquipListClick;
	}

}

/// 更新
function BUpdate_Clicked()
{
	if (CheckNull()) return
	if (CheckInvalidData()) return;
	//add by zy ZY0089
	/*			//Add By DJ 2016-04-25
	if ((GetElementValue("KindFlag")==1))
	{
		if (GetElementValue("RowIDs")=="")
		{
			alertShow("请选择设备明细!")
			return;
		}
	}	
	*/
	if (Component=="DHCEQBatchDisuseRequest")
	{
		//add by wy 20190301检查设备是否被其他单据占用 需求836844
		//modfied by wy 2019-12-31 需求1150377只检查过滤台账生报废单的情况
	    var KindFlag=GetElementValue("KindFlag")
		if (KindFlag==0)
		{
			var EquipDR=GetElementValue("EquipDR") 		
			var SourceID=GetElementValue("RowID");
			var encmeth=GetElementValue("CheckEquipDR");
			if (encmeth=="") return
			var CheckResult=cspRunServerMethod(encmeth,"3",SourceID,EquipDR,"","","Y");
			CheckResult=CheckResult.replace(/\ +/g,"")	//去掉空格
			CheckResult=CheckResult.replace(/[\r\n]/g,"")	//去掉回车换行
			var	list=CheckResult.split("^");
			if (list[0]!=0)
			{
				messageShow('alert','error','提示',"错误信息:"+list[1]);		//Mozy	949803	2019-9-12
				return;
			}
		}
		var Amount=GetElementValue("Amount")
		if (Amount=="")
		{
			alertShow("请选择设备明细!")
			return
		}
		//add by lmm 2020-03-02 LMM0060 begin
		var ListVal=GetEquipInfo();  
		
		
	}
	else
	{
		
		var ListVal=GetTableInfo();
	}
		//add by lmm 2020-03-02 LMM0060 begin
	var ReqVal=CombinData();
	//alertShow("ListVal"+ListVal)
	var val=$("#Reason").combobox("getValues"); //add hly 20200311 bug:1170377
	val=val.toString(); //add hly 20200422
  	if (ListVal=="-1")  return;
  	var DelListIDs=tableList.toString();
	//alertShow("ReqVal"+ReqVal+"ListVal"+ListVal+"DelListIDs"+DelListIDs)
	//return;
	disableElement("BUpdate",true)	//add by csj 2020-03-10 表单校验后禁用
    var rtn=SaveDisuseRequest(ReqVal,ListVal,DelListIDs,"0",val); //modify hly 20200311 bug:1170377
    if (rtn!=-1)
    {
	    window.location.href= "websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+"&Type=0&RowID="+rtn+"&RowIDs="+GetElementValue("RowIDs");  //hisui改造 modify by lmm 2018-08-17
	}   
	else{
		disableElement("BUpdate",false)	//add by csj 2020-03-10 保存失败后启用
	}
}
///add by lmm 2020-03-02 LMM0060
///desc:获取单批次报废设备明细数据
function GetEquipInfo()
{
	
	var TRow="1";
	var TRowID=GetElementValue("DisuseID");
			
    var KindFlag=GetElementValue("KindFlag")
	if (KindFlag==0)
	{
		var TSourceType=0
		var TSourceID=GetElementValue("EquipDR")

	}
	else if (KindFlag==1)
	{
		var TSourceType=1
		var TSourceID=GetElementValue("InStockListDR")

	}
			
	var TQtyNum=GetElementValue("Amount");
	var TUseState=GetElementValue("UseState");			
	var TDisuseReason="";
	var TDisuseDate="";
	var TRemark="";
	var THold1=GetElementValue("OriginalFee");
	var THold2=GetElementValue("DisuseLocation");
	var THold3=""  //GetElementValue("Hold3");
	var THold4=""  //GetElementValue("Hold4");
	var THold5=""  //GetElementValue("Hold5");
	var TEquipIDs=GetElementValue("RowIDs");
	var TJob=GetElementValue("Job");		//Add By DJ 2016-04-25
	
	var ListVal=""
	ListVal=ListVal+TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+TQtyNum+"^"+TUseState+"^"+TDisuseReason+"^"+TDisuseDate+"^"+TRemark;
	ListVal=ListVal+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5+"^"+TEquipIDs+"^1^"+TJob;
	
	return  ListVal;
	
	
	
}
//modified by wy 2020-4-8 bug WY0060 begin
function BDelete_Clicked()
{
	messageShow("confirm","","",t["-4003"],"",DeleteDisuseRequest,DisConfirmOpt);

}
function DeleteDisuseRequest()
{
	var RowID=GetElementValue("RowID");
	var rtn=SaveDisuseRequest(RowID,"","","1");
	if (rtn!=-1)
    {
	    var val="&RequestLocDR="+GetElementValue("RequestLocDR")
	    val=val+"&RequestLoc="+GetElementValue("RequestLoc");
	    val=val+"&RequestDate="+GetElementValue("RequestDate");
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT='+Component+'&Type=0'+val   //hisui改造 modify by lmm 2018-08-17
	}

}
function DisConfirmOpt()
{
   return;
}
//modified by wy 2020-4-8 bug WY0060 end
///提交
function BSubmit_Clicked()
{
	SubmitRequest();
}

/// 取消提交
function BCancelSubmit_Clicked()
{
	CancelSubmit();
}

/// 审核
function BAudit_Clicked()
{
	Audit();
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
	var combindata=GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	return combindata;
  	
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+""; //GetElementValue("GroupDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetElementValue("UseState") ;
  	combindata=combindata+"^"+GetElementValue("DisuseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReason") ;
  	combindata=combindata+"^"+""; //GetElementValue("DisureDate") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	//begin 11 to 33
  	for (var j=11;j<34;j++)
	{
		combindata=combindata+"^"
	}
    combindata=combindata+"^"+GetElementValue("RequestNo") ;//
    combindata=combindata+"^"+GetElementValue("LocDR") ;//
    combindata=combindata+"^"+GetElementValue("TotleTime") ;//
    combindata=combindata+"^"+GetElementValue("Income") ;//
    combindata=combindata+"^"+GetElementValue("CheckResult") ;//
    combindata=combindata+"^"+GetElementValue("TechnicEvaluate") ;//
    combindata=combindata+"^"+GetElementValue("RepairHours") ;//
    combindata=combindata+"^"+GetElementValue("RepairFee") ;//
    combindata=combindata+"^"+GetElementValue("RepairTimes") ;//
    combindata=combindata+"^"+GetElementValue("LimitYears") ;//
    combindata=combindata+"^"+GetElementValue("KindFlag") ;//
    combindata=combindata+"^"+GetElementValue("InStockListDR") ;//
    combindata=combindata+"^"+GetElementValue("RejectReason") ;//
    combindata=combindata+"^"+GetElementValue("RowIDs") ;//
    combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;//48
    combindata=combindata+"^"+GetElementValue("Hold2");	//20150820  Mozy0160
    combindata=combindata+"^"+GetElementValue("Hold3");
    combindata=combindata+"^"+GetElementValue("Hold4");
    combindata=combindata+"^"+GetElementValue("Hold5");
    combindata=combindata+"^"+GetElementValue("Job");		//Add By DJ 2016-04-25
    
  	return combindata;
}
function GetEquipID(value)
{
    //add by wy 2020-4-20  1276182
	var DisuseTypeDR=GetElementValue("DisuseTypeDR")
	if (DisuseTypeDR=="")
	{
		messageShow('alert','info','提示','请先选择报废类型！');
		Clear();
		return;
	}
	Clear()	
	// 2012-02-27  Mozy0078
	//	0			1			2			3			4			5				6			7			8		9			10			11		12		13			14				15		16		17			18			19		20				21
	//TEquipDR,TStoreLocDR,TInStockListDR,TModelDR,TEquipCatDR,TEQManufacturerDR,TProviderDR,TEquipTypeDR,TEquip,TStoreLoc,TInStockNo,TQuantityNum,TModel,TEquipCat,TEQManufacturer,TProvider,TInDate,TEquipType,TLimitYearsNum,TNo,TLeaveFactoryNo,TOriginalFee)
	var val=value.split("^");
	SetElement("EquipDR", val[0]);
	SetElement("LocDR",val[1]);
	SetElement("InStockListDR", val[2]);
	SetElement("ModelDR", val[3]);
	SetElement("EquipCatDR", val[4]);
	SetElement("ManuFactoryDR", val[5]);
	SetElement("ProviderDR", val[6]);
	SetElement("EquipTypeDR",val[7]);
	SetElement("Equip", val[8]);
	//add hly 20200311 bug:1096983
	var encmeth=GetElementValue("GetFlag");
	var Flag=cspRunServerMethod(encmeth,GetElementValue("EquipDR"));
	if (Flag<0)
	{
		if (GetElementValue("LimitYearsType")==GetElementValue("DisuseTypeDR"))
		{
			messageShow('alert','info','提示','当前设备未到使用年限，不能报废！');
			Clear()
			return;
		}
		else
		{
			messageShow('alert','info','提示','当前设备未到使用年限!');
		}
	}
	SetElement("Loc",val[9]);
	SetElement("InStockList", val[10]);
	//SetElement("Amount", val[11]);
	SetElement("Model", val[12]);
	SetElement("EquipCat", val[13]);
	SetElement("ManuFactory", val[14]);
	SetElement("Provider", val[15]);
	SetElement("InDate", val[16]);
	SetElement("EquipType",val[17]);
	SetElement("LimitYears",val[18]);
	SetElement("No",val[19]);
	SetElement("LeaveFactoryNo",val[20]);
	SetElement("OriginalFee",val[21]);
	SetElement("Amount",val[11]); // Modified By QW20200218 BUG:QW0041 测试需求
	SetElement("FileNo",val[23]);	//20150820  Mozy0160
	//messageShow("","","",val[23])
	SetElement("RowIDs", "");
	
	//add by lmm 2020-03-03 begin LMM0060
	var MXInfo=GetElementValue("Job")+"^1^"+val[11]+"^"+GetElementValue("RowID")
	var EquipDRs=val[26]
	var ApproveListInfo=tkMakeServerCall("web.DHCEQUpdateEquipsByList","UpdateEquipsByList",EquipDRs,MXInfo)
	
	
}

function Clear()
{
	SetElement("Equip","");
	SetElement("EquipDR","");
	//SetElement("LocDR","");
	//SetElement("Loc","");
	SetElement("InStockList","");
	SetElement("InStockListDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("EquipCat","");
	SetElement("EquipCatDR","");
	SetElement("ManuFactory","");
	SetElement("ManuFactoryDR","");
	SetElement("Provider","");
	SetElement("ProviderDR","");
	SetElement("InDate","");
	SetElement("LeaveFactoryNo","");
	SetElement("No","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("LimitYears","");
	SetElement("Amount","");
	SetElement("OriginalFee","");
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	ReadOnlyElement("Opinion_"+GetElementValue("CurRole")+"_"+GetElementValue("RoleStep"),true);
	ReadOnlyElement("RejectReason",true);
	
	/// Mozy0074 2011-12-21
	var ReadOnly=GetElementValue("ReadOnly");
	if (Status!=2)  DisableBElement("BRecover",true);  //Add By QW20191008 BUG:QW0028 初始化报废恢复按钮
	if (ReadOnly=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		//return  	//modified by wy 2020-4-18 1276569

	}
	
	if ((Status>0))
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		var NextStep=GetElementValue("NextFlowStep");           //modified by czf 需求号：353836
		var CurRole=GetElementValue("CurRole");
		var NextRole=GetElementValue("NextRoleDR");
		var RoleStep=GetElementValue("RoleStep");
		var CancelFlag=GetElementValue("CancelFlag");
		if (Type=="1")
		{
			if ((CurRole==NextRole)&&(NextStep==RoleStep)&&(CancelFlag=="Y"))
			{
				var obj=document.getElementById("BCancelSubmit");
				if (obj) obj.onclick=BCancelSubmit_Clicked;
				ReadOnlyElement("RejectReason",false);
				ReadOnlyElement("Opinion_"+GetElementValue("CurRole")+"_"+GetElementValue("RoleStep"),false);
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
					ReadOnlyElement("Opinion_"+GetElementValue("CurRole")+"_"+GetElementValue("RoleStep"),false);
				}
			}
		}
		else
		{
			//Mozy	972172,998131	2019-9-12
			DisableBElement("BAudit",true);
			DisableBElement("BCancelSubmit",true);
		}
	}
	else
	{
		DisableBElement("BDisusePrintBar",true);   ///Modiedy by zc0057 报废打印标签影藏 
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		if (Type!="0")
		{
			
			DisableBElement("BUpdate",true);
			DisableBElement("BDelete",true);
			DisableBElement("BSubmit",true);
			DisableBElement("BAdd",true);
		}
		else
		{
			
			if (Status=="")
			{
				DisableBElement("BDelete",true);
				DisableBElement("BSubmit",true);
			}
		}
	}	
	// Add By QW20200218 begin BUG:QW0041 测试需求:报废权限限制
	//modified by wy 2020-4-18 1276569
	var RecoverFlag=GetElementValue("RecoverFlag");
	if ((RecoverFlag=="1")&&(Status=="2"))
	{
		disableElement("BRecover",false); 
	}
	else{
		disableElement("BRecover",true);  
		
	}
	// Add By QW20200218 begin BUG:QW0041 测试需求修改
}
//modify hly 20200422
//Reason：报废原因
function FillData(Reason)
{
	var RowID=GetElementValue("RowID");
	var EquipDR=GetElementValue("EquipDR");
	if (RowID!="")
	{
		var sort=54    //add by kdf 2018-12-12 需求号：775418 DHC_EQDisuseRequest表结构被多加了一个字段
		if (RowID<1)	return;
		var obj=document.getElementById("filldata");
		if (obj){var encmeth=obj.value} else {var encmeth=""};
		var ReturnList=cspRunServerMethod(encmeth,"","",RowID);		
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		list=ReturnList.split("^");
		//SetElement("RowID", list[sort+16]);
		if (list[0]!="")
		{
			SetElement("EquipDR", list[0]);		
		}else
		{
			SetElement("EquipDR", list[44]);
		}
        //add by wy 2020-4-28 1294046 报废原因保存更新
	    var Reasonarry=new Array()
     	for (var n=sort+52;n<list.length;n++)
	    {    
		    if (list[n]!=""){
		      Reasonarry.push(list[n])
		    }
	    }
	    Reason.setValues(Reasonarry);
		SetElement("KindFlag", list[43]);
		SetElement("RequestLoc", list[sort+2]);
		//return;
		SetElement("RequestLocDR", list[2]);
		
		SetElement("RequestDate", list[3]);
		SetElement("UseState", list[4]);
		SetElement("DisuseType", list[sort+3]);
		SetElement("DisuseTypeDR", list[5]);
		SetElement("ChangeReason", list[6]);
		SetElement("DisureDate", list[7]);
		SetElement("Remark", list[8]);
		SetElement("Status", list[9]);
		//SetElement("AddUserDR", list[10]);
		//SetElement("AddUser", list[sort+6]);
		//SetElement("AddDate", list[11]);
		//SetElement("AddTime", list[12]);
		//SetElement("UpdateUserDR", list[13]);
		//SetElement("UpdateUser", list[sort+8]);
		//SetElement("UpdateDate", list[14]);
		//SetElement("UpdateTime", list[15]);
		//SetElement("SubmitUserDR", list[16]);
		SetElement("SubmitUser", list[sort+6]);		//20150820  Mozy0160
		//SetElement("SubmitDate", list[17]);
		//SetElement("SubmitTime", list[18]);
		//SetElement("AuditUserDR", list[19]);
		//SetElement("AuditUserDR", list[sort+12]);
		//SetElement("AuditDate", list[20]);
		//SetElement("AuditTime", list[21]);
		SetElement("RejectReason", list[22]);
		//SetElement("RejectUserDR", list[23]);
		//SetElement("RejectUser", list[sort+14]);
		//SetElement("RejectDate", list[24]);
		//SetElement("RejectTime", list[25]);
		SetElement("ApproveSetDR", list[26]);
		SetElement("NextRoleDR", list[27]);
		SetElement("NextFlowStep", list[28]);
		SetElement("ApproveStatu", list[29]);
		SetElement("ApproveRoleDR", list[30]);
		//SetElement("Hold1", list[sort+21]);
		SetElement("RequestNo", list[32]);
		SetElement("Loc", list[sort+12]);
		SetElement("LocDR", list[33]);
		SetElement("TotleTime", list[34]);
		SetElement("Income", list[35]);
		SetElement("CheckResult", list[36]);
		SetElement("TechnicEvaluate", list[37]);
		SetElement("RepairHours", list[38]);
		SetElement("RepairFee", list[39]);
		SetElement("RepairTimes", list[40]);
		SetElement("LimitYears", list[41]);
		SetElement("EquipType", list[sort+14]);
		SetElement("EquipTypeDR", list[42]);
		SetElement("Hold2", list[45]);	//20150820  Mozy0160
		SetElement("Hold3", list[46]);
		SetElement("Hold4", list[47]);
		SetElement("Hold5", list[48]);
		SetElement("InStockList", list[sort+13]);
		SetElement("InStockListDR", list[44]);	
		SetElement("Equip", list[sort+16]);
		SetElement("Model", list[sort+17]);
		SetElement("ModelDR", list[sort+18]);
		SetElement("EquipCat", list[sort+19]);
		SetElement("EquipCatDR", list[sort+20]);
		SetElement("ManuFactory", list[sort+21]);
		SetElement("ManuFactoryDR", list[sort+22]);
		SetElement("Provider", list[sort+23]);
		SetElement("ProviderDR", list[sort+24]);
		SetElement("InDate", list[sort+25]);
		SetElement("RowIDs", list[sort+26]);
		SetElement("No", list[sort+27]);
		SetElement("LeaveFactoryNo", list[sort+28]);
		SetElement("OriginalFee", list[sort+29]);
		SetElement("FileNo",list[sort+47]);	//20150820  Mozy0160
		SetElement("CancelFlag",list[sort+48]);           //modified by czf 2017-03-28   需求号：353835*/
		SetElement("DisuseID",list[sort+50]);     //add by lmm 2020-03-02 LMM0060
		SetElement("DisuseLocation",list[sort+51]);     //add by lmm 2020-03-02 LMM0060
		var KindFlag=GetElementValue("KindFlag")
		if (KindFlag==2)          //2:多批报废,1:同种批量:,0：同种单台
		{
			SetElement("CancelFlag", list[sort+28]);
		}
		//Add By QW20191008 BUG:QW0030 报废单无效屏蔽按钮
		if (list[43]=="1")
		{
			 DisableBElement("BRecover",true); 
		}
		//End By QW20191008 BUG:QW0030
	}
	else if (EquipDR!="")
	{
		var sort=EquipGlobalLen
		if (EquipDR<1)	return;
		var obj=document.getElementById("GetEquipInfo");
		if (obj){var encmeth=obj.value} else {var encmeth=""};
		var ReturnList=cspRunServerMethod(encmeth,"","",EquipDR);
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		list=ReturnList.split("^");
		SetElement("RowID", "");
		SetElement("Equip", list[0]);
		SetElement("No",list[70]);
		SetElement("Status", "");
		SetElement("Loc", list[sort+26]);
		SetElement("LocDR", list[66]);
		SetElement("LimitYears", list[30]);
		SetElement("EquipType", list[sort+22]);
		SetElement("EquipTypeDR", list[62]);
		SetElement("InStockList", list[sort+42]);	
		SetElement("InStockListDR", list[69]);
		SetElement("Model", list[sort+0]);
		SetElement("ModelDR", list[2]);
		SetElement("EquipCat", list[sort+1]);
		SetElement("EquipCatDR", list[3]);
		SetElement("ManuFactory", list[sort+13]);
		SetElement("ManuFactoryDR", list[25]);
		SetElement("Provider", list[sort+12]);
		SetElement("ProviderDR", list[24]);
		SetElement("OriginalFee", list[26]);
		if (list[69]=="")
		{
			SetElement("InDate", list[sort+32]);
		}
		else
		{
			SetElement("InDate", list[sort+32]);
		}		
		SetElement("No", list[70]);
		SetElement("LeaveFactoryNo", list[9]);
		SetElement("FileNo",list[84]);	//20150820  Mozy0160
		SetElement("Amount", 1);

	}

}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("TotleTime"),1,1,0,1)==0)
	{
		//Mozy	997984	2019-9-12	允许小数
		alertShow("总使用时间异常,请修正.");
		return true;
	}
    if (IsValidateNumber(GetElementValue("Income"),1,1,0,1)==0)
	{
		alertShow("总效益异常,请修正.");
		return true;
	}
    if (IsValidateNumber(GetElementValue("RepairHours"),1,0,0,1)==0)
	{
		alertShow("再修复工时异常,请修正.");
		return true;
	}
    if (IsValidateNumber(GetElementValue("RepairFee"),1,1,0,1)==0)
	{
		alertShow("再修复费用异常,请修正.");
		return true;
	}
    if (IsValidateNumber(GetElementValue("RepairTimes"),1,0,0,1)==0)
	{
		alertShow("已修理次数异常,请修正.");
		return true;
	}
	
	return false;
}
function GetLocID(value)
{
	GetLookUpID('LocDR',value);
}

function GetRequestLocID(value)
{
	GetLookUpID('RequestLocDR',value);
}

function GetDisuseTypeID(value)
{
	GetLookUpID('DisuseTypeDR',value);
}

///???
function GetInStockListID(value)
{
	GetLookUpID('InStockListDR',value);
}
///HISUI改造需重新调整 曾超[元素:initRunQian,PrintFlag 继承:DHCCPMRQCommon.js]
///Modified by zc 2015-04-09 zc0022
///描述:修改单台报废与多批次报废打印模版及程序的不区分
///modified by kdf 2018-01-04
///描述：根据系统参数增加单台润乾打印控制
function BPrint_Click()
{
	var disuseid=GetElementValue("RowID");
	if (disuseid=="") return;
	if (GetElementValue("Status")=="0") return
	var encmeth=GetElementValue("filldata");	
	if (encmeth=="") return;
	var RequestData=cspRunServerMethod(encmeth,'','',disuseid);
	RequestData=RequestData.replace(/\\n/g,"\n");
	
	var lista=RequestData.split("^");
	var PrintFlag=GetElementValue("PrintFlag");
	var sort=54
	if(lista[43]==0)
	{
	 //add by kdf 2018-01-04 增加参数控制
	 if(PrintFlag==1)
	 {
	    var RequestNo=lista[32];
        var RequestDate=FormatDate(lista[11]);
        var UseLoc=lista[65];
        fileName="DHCEQDisuseRequestOnePrint.raq&RowID="+disuseid+"+&RequestNo="+RequestNo+"&RequestDate="+RequestDate+"&UseLoc="+UseLoc;
        //alertShow(fileName)
        DHCCPM_RQPrint(fileName);
	 }
	//add by kdf 2018-01-04 增加参数控制
     if(PrintFlag==0)
     {
		try {
        	var xlApp,xlsheet,xlBook;
			var	TemplatePath=GetElementValue("GetRepPath");	
	    	var Template=TemplatePath+"DHCEQDisuse.xls";
	    	xlApp = new ActiveXObject("Excel.Application");
			xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	//医院名称替换 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	//Modified by QW20191022 BUG:QW0032 修正打印错误
	    	xlsheet.cells(3,3)=lista[32];//报废单号
	    	xlsheet.cells(3,9)=FormatDate(lista[3]);  //报废日期
			xlsheet.cells(3,6)=GetShortName(lista[sort+12],"-");  //使用科室
			xlsheet.cells(4,3)=lista[sort+16];//设备名称	
			xlsheet.cells(4,7)=lista[sort+17];//机型
			xlsheet.cells(5,3)=lista[sort+21];//生产厂商
			xlsheet.cells(5,7)=lista[sort+41];//验收日期
			xlsheet.cells(6,3)=lista[sort+29];//单价
			xlsheet.cells(6,7)=GetElementValue("Amount");//数量
			xlsheet.cells(7,3)=lista[sort+40];//单位
			xlsheet.cells(7,7)=GetElementValue("Amount")*lista[sort+29];//总金额
			xlsheet.cells(8,7)=lista[sort+25];  //入库日期
			xlsheet.cells(8,3)=lista[sort+43];  //已提折旧
			xlsheet.cells(9,3)=lista[sort+27];//设备编码
			//End by QW20191022 BUG:QW0032 修正打印错误
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    	var size=obj.GetPaperInfo("DHCEQInStock");
	    	if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	xlsheet.printout; //打印输出
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
	}
	else if(lista[43]==2)
	{
	//add by kdf 2018-01-04 增加参数控制 批量
	 if(PrintFlag==1)
		{
			 var RequestNo=lista[32];
        var RequestLoc=lista[55];
        var EquipType=lista[67];
        var RequestDate=FormatDate(lista[11]);
        var UseLoc=lista[65];
        var UseLocCode=tkMakeServerCall("web.DHCEQCommon", "GetTrakNameByID","deptcode",lista[33]);;
        fileName="DHCEQDisuseRequestPrint.raq&RequestNo="+RequestNo+"&RequestLoc="+RequestLoc+"&RequestDate="+RequestDate+"&UseLoc="+UseLoc+"&EquipType="+EquipType+"&UseLocCode="+UseLocCode;
        //alertShow(fileName);
        DHCCPM_RQPrint(fileName);	
		}
	 //add by kdf 2018-01-04 增加参数控制
	 if(PrintFlag==0)
	 {
		var encmeth=GetElementValue("GetList");
		if (encmeth=="") return;
		var gbldata=cspRunServerMethod(encmeth,disuseid);
		var list=gbldata.split(GetElementValue("SplitNumCode"));
		var Listall=list[0];
		rows=list[1];
		var PageRows=6;
		var Pages=parseInt(rows / PageRows); //总页数?1  3为每页固定行数
		var ModRows=rows%PageRows; //最后一页行数
		if (ModRows==0) {Pages=Pages-1;}
        var xlApp,xlsheet,xlBook;
		var	TemplatePath=GetElementValue("GetRepPath");
	    var Template=TemplatePath+"DHCEQDisuse11.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
		   
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//医院名称替换 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,3)=lista[32];//报废单号
	    	xlsheet.cells(2,9)=FormatDate(lista[11]);  //报废日期
	    	//xlsheet.cells(2,9)=GetShortName(lista[55],"-");  //申请科室
	    	//xlsheet.cells(3,2)="类  组:"+lista[67]; //类组
	    	//alertShow(lista[102])
			xlsheet.cells(3,3)=GetShortName(lista[65],"-");  //使用科室
			// xlsheet.cells(3,8)=GetShortName(lista[102],"-");  //使用科室代码
			var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		var Lists=Listall.split(GetElementValue("SplitRowCode"));
	   		for (var j=1;j<=OnePageRow;j++)
			{

				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=4+j;
				if ((List[0]=='合计')&&(i==Pages))
				{
					xlsheet.cells(3,9)=List[11];//使用科室代码
					xlsheet.cells(10,7)=List[4];//数量
					xlsheet.cells(10,9)=List[6];//金额
				}
				else
				{
					xlsheet.cells(Row,2)=List[0];//设备名称
					xlsheet.cells(Row,3)=List[8];//设备编码	
					xlsheet.cells(Row,4)=List[1];//机型
					xlsheet.cells(Row,5)=List[9];// 旧编号
					xlsheet.cells(Row,6)=List[6];//单价
					xlsheet.cells(Row,7)=List[5];//数量
					//xlsheet.cells(Row,4)=List[2];//单位
					//xlsheet.cells(Row,5)=List[3];//生产厂商
					xlsheet.cells(Row,8)=List[4];//入库日期
					//xlsheet.cells(Row,9)=List[7];//金额
					xlsheet.cells(Row,9)=List[7];		
				}
					var Row=Row+1;
				
	    	}
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    	var size=obj.GetPaperInfo("DHCEQInStock");
	    	if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	xlsheet.printout; //打印输出
	    	xlBook.Close (savechanges=false);	    
	    	xlsheet.Quit;
	    	xlsheet=null;
		}
		xlApp=null;
		
	  }	 }
	  		
}

function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function SetEquipIDs(EquipIDs,LeaveFactoryNos,Nos,Qty,RowNo)
{
	if (Component=="DHCEQDisuseRequestSimple")
	{
		SetElement('TEquipIDsz'+RowNo,EquipIDs);
		SetElement('TQtyNumz'+RowNo,Qty);
		var TotalFee=0;
		TotalFee=Qty*GetElementValue("TOriginalFeez"+RowNo);
		TotalFee=TotalFee.toFixed(2);
		SetElement('TTotalFeez'+RowNo,TotalFee);
		SumList_Change()
	}
	else
	{
		SetElement("RowIDs",EquipIDs);
		SetElement("LeaveFactoryNo",LeaveFactoryNos);
		SetElement("No",Nos);
		SetElement("Amount",Qty);		
	}
}

function SourceType_Change()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQDisuseRequestSimple'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	
	selectrow=rowObj.rowIndex;								//当前选择行
	
	RowNo=GetTableCurRow();
	var TSourceType=GetElementValue("TSourceTypez"+RowNo)
	SetElement("TSourceTypeDRz"+RowNo,TSourceType);
	SetTableItem(RowNo,selectrow);		///改变一行的内容显示
	
	selectrow=RowNo;
	ClearValue();
	SetFocusColumn("TSourceTypez",selectrow);
}

function SetTableItem(RowNo,selectrow)
{
  	var objtbl=document.getElementById('t'+Component);
	var rows=objtbl.rows.length-1;
	if (RowNo=="")
	{
		for (var i=1;i<=rows;i++)
		{
			ObjSources[i]=new SourceInfo(GetElementValue("TSourceTypeDRz"+i),GetElementValue("TSourceIDz"+i));  //0,设备;1,入库单
			
			if(tableList[i]!="0") tableList[i]=0;
			var TRowID=GetElementValue("TRowIDz"+i);
			if (TRowID==-1)
			{
				obj=document.getElementById("BDeleteListz"+i);
				if (obj) obj.innerText=""
				obj=document.getElementById("TEquipListz"+i);
				if (obj)
				{
					obj.innerText=""
					DisableBElement("TEquipListz"+i,true);
					HiddenObj("TEquipListz"+i,1)
				}
				tableList[i]=-1;
				continue;
			}
			else
			{
				ChangeRowStyle(objtbl.rows[i]);		///改变一行的内容显示
			}
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow]);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj)
{
  	var objtbl=document.getElementById('t'+Component);
	var Status=GetElementValue("Status");
	for (var j=0;j<RowObj.cells.length;j++)
	{
		var html="";
		var value="";
    	if (!RowObj.cells[j].firstChild) {continue}
		var Id=RowObj.cells[j].firstChild.id;
		var offset=Id.lastIndexOf("z");
		var objindex=Id.substring(offset+1);
		var colName=Id.substring(0,offset);
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		if (colName=="TSource")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpEquip","","","KeyUpEquip")
		}
		else if (colName=="TSourceType")
		{
			value=GetElementValue("TSourceTypeDRz"+objindex);	
			if (CheckUnEditField(Status,colName))
			{
				html=CreatElementHtml(4,Id,objwidth,objheight,"","","0^单台&1^批量","")
				RowObj.cells[j].innerHTML=html;
				DisableElement("TSourceTypez"+objindex,true);
				SetElement("TSourceTypez"+objindex,value);
				continue;
			}
			else
			{			
				//0^设备&1^入库明细&2^设备树
				html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","0^单台&1^批量","")
			}
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TUseState")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TDisuseReason")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="BDeleteList")
		{
			if (Status>0)
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		else if (colName=="TEquipList")
		{
			RowObj.cells[j].onclick=EquipListClick;
		}
		if (html!="")
		{
			//RowObj.cells[j].firstChild.outerHTML=html;
			RowObj.cells[j].innerHTML=html;
		}
		if (value!="")
		{
         	value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else if (RowObj.cells[j].firstChild.tagName=="checkbox")
		    {
			    RowObj.cells[j].firstChild.checked=value;
			}
			else
		    {
			    RowObj.cells[j].firstChild.value=value;
		    }
         	RowObj.cells[j].firstChild.value=trim(value);
		}
	}
}

function ClearValue()
{
	selectrow=GetTableCurRow();
	SetElement('TSourcez'+selectrow,"");
	SetElement('TSourceIDz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");
	SetElement('TManuFactoryz'+selectrow,"");
	SetElement('TProviderz'+selectrow,"");
	SetElement('TInDatez'+selectrow,"");
	SetElement('TLimitYearsz'+selectrow,"");
	
	SetElement('TQtyNumz'+selectrow,"");	
	SetElement('TOriginalFeez'+selectrow,"");
	SetElement('TTotalFeez'+selectrow,"");
	SetElement('TUnitz'+selectrow,"");
	SetElement('TUseStatez'+selectrow,"");	
	SetElement('TDisuseReasonz'+selectrow,"");
	SetElement('TDisuseDatez'+selectrow,"");
	SetElement('TEquipIDsz'+selectrow,"");	
	SetElement('TRemarkz'+selectrow,"");	
	
	SetElement('THold2z'+selectrow,"");
	SetElement('THold3z'+selectrow,"");
	SetElement('THold4z'+selectrow,"");
	SetElement('THold5z'+selectrow,"");
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
}
function LookUpEquip(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		var TSourceType=GetElementValue('TSourceTypez'+selectrow);
		if (TSourceType=="") return;
		GetExcludeIDs();
		LookUp("","web.DHCEQBatchDisuseRequest:Equip","GetSourceID","LocDR,TSourceTypez"+selectrow+",TSourcez"+selectrow+",QXType,RowID,EquipTypeDR,ExcludeIDs");
	}
}
///Modify By DJ 2012-12-14  DJ0109
///描述:多批选择记录时位置错位修改 
function GetSourceID(value)
{
	var list=value.split("^")
	var Length=ObjSources.length
	
	var LastSourceType=ObjSources[selectrow].SourceType //变动之前的SourceType
	var LastSourceID=ObjSources[selectrow].SourceID //变动之前的SourceID
	SetElement('TSourceTypeDRz'+selectrow,list[22]);
	if (list[22]==0)
	{
		for (var i=0;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="0")&&(ObjSources[i].SourceID==list[0])&&(selectrow!=i))
			{
				var TRow=GetElementValue("TRowz"+i);
				alertShow("选择行与第"+(TRow)+"行是重复的设备!")
				return;
			}
		}
		ObjSources[selectrow]=new SourceInfo("0",list[0]);
	}
	else
	{
		for (var i=0;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[2])&&(selectrow!=i))
			{
				var TRow=GetElementValue("TRowz"+i);
				alertShow("选择行与第"+(TRow)+"行是重复的入库单!")
				return;
			}
		}
		ObjSources[selectrow]=new SourceInfo("1",list[2]);
	}	
	
	SetElement('TSourcez'+selectrow,list[8]);
	if (list[22]==0)
	{
		//EquipTypeDR
		SetElement('TSourceIDz'+selectrow,list[0]);
		SetElement('TNoz'+selectrow,list[19]);
		SetElement('TQtyNumz'+selectrow,"1");
		SetElement('TTotalFeez'+selectrow,(list[21]*1).toFixed(2));
	}
	else
	{
		//InStockListDR
		SetElement('TSourceIDz'+selectrow,list[2]);
		//TInStockNo
		SetElement('TNoz'+selectrow,list[10]);
		SetElement('TQtyNumz'+selectrow,"");
		SetElement('TTotalFeez'+selectrow,"");
	}
	SetElement('TModelz'+selectrow,list[12]);
	SetElement('TManuFactoryz'+selectrow,list[14]);
	
	//单位?	
	//SetElement('TUnitz'+selectrow,list[9]);
	
	SetElement('TOriginalFeez'+selectrow,list[21]);
	SetElement('TInDatez'+selectrow,list[16]);
	SetElement('TLimitYearsz'+selectrow,list[18]);
	SetElement('TProviderz'+selectrow,list[15]);

	SumList_Change()
	var obj=document.getElementById("TSourcez"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}

function AddClickHandler() {
	try 
	{
  		var objtbl=document.getElementById('tDHCEQDisuseRequestSimple');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	ObjSources[NewNameIndex]=new SourceInfo("","");
	    	SetElement("TSourceTypeDRz"+NewNameIndex,GetElementValue("TSourceTypez"+NewNameIndex));
	    }
        return false;
	}
	catch(e)
	{};
}
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag")
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	if  (GetElementValue('TSourcez'+LastNameIndex)=="")
	{
		SetFocusColumn("TSource",LastNameIndex);
		return false;
	}
	return true;
}
//modified by wy 2020-4-8 bug WY0060 begin
function DeleteClickHandler()
 {
	messageShow("confirm","","",t["-4003"],"",DeleteHandler,DisConfirmOpt);
	
 }
 function DeleteHandler()
 {
	try
	{
  		var objtbl=document.getElementById('t'+Component);
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		
		var TotalFlag=GetElementValue("TotalFlag")
		
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		var delNo=GetElementValue("TRowz"+selectrow);
		
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			//Modified by jdl 2011-01-28 JDL0068
			//修改删除仅剩的一行后?编辑保存数据异常?无法保存的问题
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			ClearValue()
			//SetElement("Job","")		Modify DJ 2015-09-10 DJ0163
		} 
		else
		{
	    	var eSrc=window.event.srcElement;
			var rowObj=getRow(eSrc);
			objtbl.deleteRow(rowObj.rowIndex);
		}
		ResetNo(selectrow,delNo);
	    SumList_Change();
	} catch(e) {};
	
 }
//modified by wy 2020-4-8 bug WY0060 end


function SetDisplay()
{
	
	var Status=GetElementValue("Status");
	ReadOnlyCustomItem(GetParentTable("RequestNo"),Status);
	ReadOnlyElement("RequestNo",true)
	TransDisableToReadOnly("input");
	DisableElement("InStockList",true);   //add by lmm 2020-06-24 UI
	// TransDisableToReadOnly("textarea");  //modified by kdf 2019-03-04 需求号：836872
}
///modify by lmm 2019-02-19  添加批量报废赋值
function SumList_Change(Amount,EqNos)
{
	
	if (Component=="DHCEQBatchDisuseRequest")
	{
		SetElement("Amount",Amount)
		SetElement("No",EqNos)
		
	}
	else
	{
		var SumIndex=0
		var SumFee=0
		var SumQty=0
		var length=tableList.length
		for (var i=1;i<=length;i++)
		{
			if (tableList[i]=="0")
			{
				if (GetElementValue("TQtyNumz"+i)=="") continue;
				var TotalFee=GetElementValue("TQtyNumz"+i)*GetElementValue("TOriginalFeez"+i);		//Add By DJ 2016-04-25
				TotalFee=TotalFee.toFixed(2);
				SetElement('TTotalFeez'+i,TotalFee);
				var TTotalFee=parseFloat(GetElementValue("TTotalFeez"+i))
				var TQtyNum=parseInt(GetElementValue("TQtyNumz"+i))
				if ((isNaN(TTotalFee))||(isNaN(TQtyNum))) continue;
				SumFee=SumFee+TTotalFee;
				SumQty=SumQty+TQtyNum;
			}
			else if (tableList[i]==-1)
			{
				var SumIndex=i
			}
		}
		SetElement('TTotalFeez'+SumIndex,SumFee.toFixed(2));
		SetElement('TQtyNumz'+SumIndex,SumQty);
	}
	
		
}

function EquipListClick()
{
	var InStockListDR=""
	var EquipDR=""
	if (Component=="DHCEQBatchDisuseRequest")
	{
		InStockListDR=GetElementValue("InStockListDR")
		if (InStockListDR=="")
		{
			alertShow("请先选择设备!")
			return
		}
		EquipDR=""
		selectrow="1"
		var QuantityNum=GetElementValue("Amount")
		var Job=GetElementValue("Job")
		var MXRowID=GetElementValue("RowID")
		var Type=6
	}
	else
	{
		selectrow=GetTableCurRow();
		var SourceType=GetElementValue("TSourceTypez"+selectrow)
		if (SourceType!="1")
		{
			messageShow("","","",t[-1007]);
			return;
		}
		if (GetElementValue("TSourceIDz"+selectrow)=="")
		{
			messageShow("","","",t[-1012]);
			return;
		}	
		if (SourceType=="1")	//批量
		{
			InStockListDR=GetElementValue("TSourceIDz"+selectrow);
		}
		else					//单台
		{
			EquipDR=GetElementValue("TSourceIDz"+selectrow);
		}
		if ((InStockListDR=="")&&(EquipDR=="")) return
		var QuantityNum=GetElementValue("TQtyNumz"+selectrow)
		var Job=GetElementValue("Job")
		var MXRowID=GetElementValue("TRowIDz"+selectrow)
		var Type=5
	}
	if (Job=="") //270333  Add BY BRB 2016-11-02 
	{
		return;
	}
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUpdateEquipsByList";  //hisui改造 modify by lmm 2018-08-17
	lnk=lnk+"&SourceID="+InStockListDR
	lnk=lnk+"&QuantityNum="+QuantityNum
	lnk=lnk+"&Job="+Job
	lnk=lnk+"&index="+selectrow
	lnk=lnk+"&MXRowID="+MXRowID
	lnk=lnk+"&StoreLocDR="+GetElementValue("LocDR")
	lnk=lnk+"&Status="+GetElementValue("Status")
	lnk=lnk+"&Type="+Type
	lnk=lnk+"&EquipID="+EquipDR
	showWindow(lnk,"设备明细","","","icon-w-paper","modal","","","small",SumList_Change)	//modify by lmm 2019-02-19 增加回调
	
	
	/*
	var InStockListDR;
	var ExcludeIDs="";
	var RowIDs="";
	if (Component=="DHCEQBatchDisuseRequest")
	{
		var EquipDR=GetElementValue("EquipDR")
		if (EquipDR=="")
		{
			messageShow("","","",t[-1004]);
			return;
		}
		InStockListDR=GetElementValue("InStockListDR");
		RowIDs=GetElementValue("RowIDs");
	}
	else
	{
		selectrow=GetTableCurRow();
		var SourceType=GetElementValue("TSourceTypez"+selectrow)
		if (SourceType!="1")
		{
			messageShow("","","",t[-1007]);
			return;
		}
		if (GetElementValue("TSourceIDz"+selectrow)=="")
		{
			messageShow("","","",t[-1012]);
			return;
		}
		InStockListDR=GetElementValue("TSourceIDz"+selectrow);
		//ExcludeIDs=GetExcludeIDs();
		//RowIDs=GetElementValue("TEquipIDsz"+selectrow);
	}
	
	var val="&LocDR="+GetElementValue("LocDR");
	val=val+"&InStockListDR="+InStockListDR;	
	val=val+"&RowID="+GetElementValue("RowID")
	val=val+"&Status="+GetElementValue("Status")
	val=val+"&SelectRow="+selectrow;
	val=val+"&ExcludeIDs="+ExcludeIDs;
	val=val+"&RowIDs="+RowIDs;
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseEquipList"+val;
   	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
   	*/
}

function KeyUpEquip()
{
	selectrow=GetTableCurRow();
	SetElement('TSourceIDz'+selectrow,"");	
}

///保存或删除报废单
function SaveDisuseRequest(ReqVal, ListVal, DelListIDs, IsDel, val) //modify hly 20200422
{
	var encmeth=GetElementValue("GetSaveData");
	
	var rtn=cspRunServerMethod(encmeth,ReqVal, ListVal, DelListIDs, IsDel, val); //modify hly 20200422
	var list=rtn.split("^");
	if (list[0]!=0)
	{
		messageShow("","","",EQMsg(list[1],list[0]));
		//失败 返回SQLCODE
		return -1;
	}
	//成功返回 RowID
	return list[1];
}

///提交报废单
function SubmitRequest()
{
	//midified by zy 2015-7-1 ZY0134
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	// Mozy		1006269		2019-9-14
	var NeedChange=tkMakeServerCall("web.DHCEQChangeInfo","NeedChange","34",RowID,"1");
	var GetStopEquipFlag=GetElementValue("GetStopEquipFlag")
	var CheckStoreLocDR=tkMakeServerCall("web.DHCEQBatchDisuseRequest","CheckStoreLocDR",GetElementValue("LocDR"));   // add by kdf 2019-06-10 在库设备不提示停用 需求号920964
	if ((NeedChange==1) && (GetStopEquipFlag==1) && (CheckStoreLocDR!=1))   // modified by kdf 2019-06-10 在库设备不提示停用 需求号920964
	{
		//modified by wy 2020-4-8 bug WY0060 begin
		messageShow("confirm","","","当前报废设备是否停用?","",function(){
			GetStopEquipFlag=2;
			SubmitData(RowID,GetStopEquipFlag)
			},
			function(){
				SubmitData(RowID,GetStopEquipFlag)
				
			});
	}
	else
	{
		SubmitData(RowID,GetStopEquipFlag)
	}
}
function SubmitData(RowID,GetStopEquipFlag){
	if (GetStopEquipFlag==2)
	{
		var encmeth=GetElementValue("StopFlag");
		var result=cspRunServerMethod(encmeth,"34",RowID,"1");
		if (result!=0)
		{
			alertShow("设备停用失败!")
			return;
		}
	}
	// Mozy0217  2018-11-01	检测配置设备并提示
	var CheckConfig=tkMakeServerCall("web.DHCEQBatchDisuseRequest","CheckConfigDR",RowID);
  	if (CheckConfig!="") messageShow("","","","本报废单设备明细包含有配置设备,如需报废请另外建单处理!!!");
	var encmeth=GetElementValue("GetSubmit");
	if (encmeth=="")  return;
	//end by zy 2015-7-1
	var rtn=cspRunServerMethod(encmeth,RowID);
	if (rtn==0)
    {	    
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT='+Component+'&Type=1&RowID='+RowID  //hisui改造 modify by lmm 2018-08-17
    }
    else
    {
	    var list=rtn.split("^");
	    messageShow("","","",EQMsg(list[1],list[0]));
    }	

	
	}
//modified by wy 2020-4-8 bug WY0060 end
///取消提交报废单
function CancelSubmit()
{
	//midified by zy 2015-7-1 ZY0134
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	//Mozy	998178	2019-9-12
	var RejectReason=GetElementValue("RejectReason")
	if (RejectReason=="")
	{
		messageShow("","","",t[-1003])
		SetFocus("RejectReason") 	//2011-02-19 ZY0062
		return
	}
	// Mozy		1006269		2019-9-14
	var NeedChange=tkMakeServerCall("web.DHCEQChangeInfo","NeedChange","34",RowID,"0");
	var GetStopEquipFlag=GetElementValue("GetStopEquipFlag")
	var CheckStoreLocDR=tkMakeServerCall("web.DHCEQBatchDisuseRequest","CheckStoreLocDR",GetElementValue("LocDR"));   // add by kdf 2019-06-10 在库设备不提示停用 需求号920964
		if ((NeedChange==1) && (GetStopEquipFlag==1) && (CheckStoreLocDR!=1))   // modified by kdf 2019-06-10 在库设备不提示停用 需求号920964
	{
		//modified by wy 2020-4-8 bug WY0060 begin
		messageShow("confirm","","","当前报废设备是否取消停用?","",function(){
		GetStopEquipFlag=2;
		CancelSubmitData(RowID,GetStopEquipFlag)
			},
			function(){
				CancelSubmitData(RowID,GetStopEquipFlag)
				
			});
	}
	else
	{
		CancelSubmitData(RowID,GetStopEquipFlag)
	}

}
function CancelSubmitData(RowID,GetStopEquipFlag)
{	
if (GetStopEquipFlag==2)
	{
		var encmeth=GetElementValue("StopFlag");
		var result=cspRunServerMethod(encmeth,"34",RowID,"0");
		if (result!=0)
		{
			alertShow("设备取消停用失败!")
			return;
		}
	}
	//add by wy 2020-05-06 1288746系统参数控制是否删除汇总报废单中的对应明细记录 begin
	var RoleStep=GetElementValue("RoleStep");
	if(RoleStep==1)
	{
		var vFlag=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetMergeOrderFlag",RowID);
		var CheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601006");
		if ((CheckFlag==1)&&(vFlag==0))
			{
				messageShow("confirm","","","继续操作还是取消(继续将无效汇总报废单中的对应明细记录)?","",function(){		
					BCancelSubmitData();
					},
					function(){return;})	
			}
		else {
				BCancelSubmitData();
			
			 }
		 
    }
    else{
		BCancelSubmitData();
    } 	
}
//modified by wy 2020-4-8 bug WY0060 end
function BCancelSubmitData()
{
	var RowID=GetElementValue("RowID");	
	var RejectReason=GetElementValue("RejectReason")
	var combindata=RowID+"^"+RejectReason+"^"+GetElementValue("CurRole");
	var encmeth=GetElementValue("GetCancelSubmit");
	if (encmeth=="")  return;
	var rtn=cspRunServerMethod(encmeth,combindata);
	
	if (rtn==0)
    {
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT='+Component+'&Type=1&RowID='+RowID  //hisui改造 modify by lmm 2018-08-17
    }
    else
    {
	    var list=rtn.split("^");
	    messageShow("","","",EQMsg(list[1],list[0]));
    }	
	
}
	//add by wy 2020-05-06 1288746系统参数控制是否删除汇总报废单中的对应明细记录 begin
///审批报废单
function Audit()
{	
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;

	if (CheckAuditNull()) return;
	//begin add  by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	var objtbl=document.getElementById('t'+Component);    
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);   
	if (EditFieldsInfo=="-1") return;                 
	//end add  by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
	var combindata=RowID+"^"+GetOpinion();
	
	var encmeth=GetElementValue("GetAudit");
	
	var rtn=cspRunServerMethod(encmeth,combindata,EditFieldsInfo);   //modify  by jyp 2020-02-27  JYP0022  报废信息表添加可编辑字段
    if (rtn==0)
    {
	    window.location.reload();
	}
    else
    {
	    var list=rtn.split("^");
	    messageShow("","","",EQMsg(list[1],list[0]));
    }    
}


function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQDisuseRequestSimple');
	var rows=tableList.length
	var ListVal="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TSourceType=GetElementValue("TSourceTypeDRz"+i);
			var TSourceID=GetElementValue("TSourceIDz"+i);
			var TQtyNum=GetElementValue("TQtyNumz"+i);
			var TUseState=GetElementValue("TUseStatez"+i);			
			var TDisuseReason=GetElementValue("TDisuseReasonz"+i);
			var TDisuseDate=GetElementValue("TDisuseDatez"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			var THold1=GetElementValue("TOriginalFeez"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			var TEquipIDs=GetElementValue("TEquipIDsz"+i);
			var TJob=GetElementValue("Job");		//Add By DJ 2016-04-25
			if ((TSourceType==""))
			{
				alertShow("第"+TRow+"行,请选择正确的类型")
				SetFocusColumn("TSourceType",i)
				return "-1"
			}
			if ((TSourceID==""))
			{
				alertShow("第"+TRow+"行,请选择正确的设备信息")
				SetFocusColumn("TSourceID",i)
				return "-1"
			}
			//add by zy ZY0089
			if ((TSourceType==1)&&(TQtyNum==""))		//Modify DJ 2016-04-25
			{				
				alertShow("第"+TRow+"行,请选择要报废的设备")
				return "-1"
			}
						
			if(ListVal!="") {ListVal=ListVal+"&";}			
			ListVal=ListVal+TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+TQtyNum+"^"+TUseState+"^"+TDisuseReason+"^"+TDisuseDate+"^"+TRemark;
			ListVal=ListVal+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5+"^"+TEquipIDs+"^"+i+"^"+TJob;
		}
	}
	return  ListVal;
}

function GetExcludeIDs()
{
	return ""		//Modify DJ 2016-04-25
	var length=tableList.length
	var ExcludeIDs="";
	for (var i=1;i<=length;i++)
	{
		if (i==selectrow) continue;
		if (tableList[i]=="0")
		{			
			var SourceType=GetElementValue("TSourceTypeDRz"+i);
			if (ObjSources[i].SourceType==0)
			{
				if (ObjSources[i].SourceID!="")
				{
					if (ExcludeIDs!="") ExcludeIDs=ExcludeIDs+",";
					ExcludeIDs=ExcludeIDs+ObjSources[i].SourceID;
				}
			}
			else if (ObjSources[i].SourceType==1)
			{
				if (GetElementValue("TEquipIDsz"+i)!="")
				{
					if (ExcludeIDs!="") ExcludeIDs=ExcludeIDs+",";
					ExcludeIDs=ExcludeIDs+GetElementValue("TEquipIDsz"+i);
				}
			}
			else
			{
			}			
		}
		else
		{
		}
	}
	SetElement("ExcludeIDs",ExcludeIDs);
	return ExcludeIDs;
}
//Add By QW20191008 BUG:QW0028
//增加报废恢复功能
function BRecover_Click()
{
	var RowID=GetElementValue("RowID");
	//add by wy 2020-05-06 1288746系统参数控制是否删除汇总报废单中的对应明细记录 begin
	var vFlag=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetMergeOrderFlag",RowID);
	var CheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601006");
	if ((CheckFlag==1)&&(vFlag==0))
	{
		messageShow("confirm","","","继续操作还是取消(继续将无效汇总报废单中的对应明细记录)?","",function(){
				
			BRecover();
			},
			function(){
				return;
				})	
	}
	else {
			BRecover();
		
		}
}
function BRecover()
{
	var RowID=GetElementValue("RowID");
	var Result=tkMakeServerCall("web.DHCEQBatchDisuseRequest","RecoverDisUseEquip",RowID);
	var	list=Result.split("^");
	if (list[0]!=0)
	{
		messageShow('alert','error','提示',"错误信息:"+list[1]);		//Mozy	949803	2019-9-12
		return;
	}else
	{
		 messageShow('alert','error','提示',"恢复报废单成功");		
		 websys_showModal("close"); 
	}
}
//add by wy 2020-05-06 1288746系统参数控制是否删除汇总报废单中的对应明细记录 end
///Modiedy by zc0057 增加报废标签打印 
function BDisusePrintBar_Click()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSDisuseRequest","GetOneDisuseRequest",RowID,'','','')
	jsonData=jQuery.parseJSON(jsonData);
	var objDisUse=jsonData.Data;
	var strs=tkMakeServerCall("web.DHCEQBatchDisuseRequest","GetDisuseEquipIDs",RowID)
	var strArray=strs.split(",");
	var n=strArray.length;
	for (var m=0;m<n;m++)
	{
		var equipid=strArray[m];
		if (equipid=="")
		{
			messageShow('alert','error','提示','没有找到设备信息!','','','');
			return;
		}
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",equipid);
		jsonData=jQuery.parseJSON(jsonData);
		if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
		var objEquip=jsonData.Data;
		var BarInfoDR=tkMakeServerCall("web.DHCEQCBarInfo","GetBarInfoDR",'DHCEQDisuseRequest');
		var Listall=tkMakeServerCall("web.DHCEQCBarInfo","GetPrintBarInfo",equipid,BarInfoDR);
		//alertShow(Listall)
		if (Listall=="")
		{
			alertShow("设备信息或条码配置信息无效,请核对!");
			return;
		}
		var Lists=Listall.split(GetElementValue("SplitRowCode"));
		var NewString="";
		var InfoList=Lists[0].split("^");
		//alertShow("No="+Listall)
		for (var i=1;i<Lists.length;i++)
		{
			// 1^0^^标题^标准二维条码左侧打印^宋体^16^N^^^N^60^150^^^N^^^^N^^^1^^^^^&1^0^EQName^设备名称^名称:^宋体^8^N^1^^N^^^^^N^^^^N^^^2^^^^^&1^0^EQNo^设备编号^编号:^宋体^8^N^2^^N^^^^^N^^^^N^^^3^^^^^&1^0^EQModelDR_MDesc^规格型号^型号:^宋体^8^N^3^^N^^^^^N^^^^N^^^^^^^^&1^0^EQManuFactoryDR_MFName^生产厂家^厂家:^宋体^8^N^4^^N^^^^^N^^^^N^^^^^^^^&1^0^EQLeaveFactoryNo^出厂编号^SN码:^宋体^8^N^5^^N^^^^^N^^^^N^^^^^^^^&1^0^EQStartDate^启用日期^启用:^宋体^8^N^6^^N^^^^^N^^^^N^^^^^^^^&1^0^EQUseLocDR_CTLOCDesc^使用科室^科室:^宋体^8^N^7^^N^^^^^N^^^^N^^^^^^^^&1^0^EQLocationDR_LDesc^存放地点^存放:^宋体^8^N^8^^N^^^^^N^^^^N^^^^^^^^&1^0^EQHospital^医院名称^医院:^宋体^8^N^9^^N^^^^^N^^^^Y^^^^^^^^&1^0^EQOriginalFee^原值^原值:^宋体^8^N^10^^N^^^^^N^^^^Y^^^^^^^^&1^1^^^^^^N^^^N^1400^500^^^N^1400^1900^^N^^竖线1^4^^^^^
			// 1^0^^标题^标准二维条码左侧打印^宋体^16^N^^^N^60^150^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^车载显示系统^设备名称^名称:^宋体^8^N^1^^N^^^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^3222299001100^设备编号^编号:^宋体^8^N^2^^N^^^^^N^^^^N^^^30^^^^^$CHAR(3)1^0^\sd^规格型号^型号:^宋体^8^N^3^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^万通制造公司^生产厂家^厂家:^宋体^8^N^4^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^CCBH2019020201^出厂编号^SN码:^宋体^8^N^5^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^2019-02-02^启用日期^启用:^宋体^8^N^6^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^X线室^使用科室^科室:^宋体^8^N^7^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^210C房^存放地点^存放:^宋体^8^N^8^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^0^东华标准版数字化医院[总院]^医院名称^医院:^宋体^8^N^9^^N^^^^^N^^^^N^^^16^^^^^$CHAR(3)1^0^6300.00^原值^原值:^宋体^8^N^10^^N^^^^^N^^^^N^^^^^^^^$CHAR(3)1^1^^^^^^N^^^N^1400^500^^^N^1400^1900^^N^^竖线1^4^^^^^
			var DetailList=Lists[i].split("^");
			// 过滤隐藏元素
			if (DetailList[19]!="Y")
			{
				if (DetailList[2]!="")
				{
					// 数值格式化
					if (DetailList[20]!="")
					{
						if (DetailList[23]=="DHCEQDisuseRequest")
						{
							var tmpValue=ColFormat(objDisUse[DetailList[2]],DetailList[20]);
						}
						else
						{
							var tmpValue=ColFormat(objEquip[DetailList[2]],DetailList[20]);
						}
						Lists[i]=DetailList[0]+"^"+DetailList[1]+"^"+tmpValue;
						for (var j=3;j<DetailList.length;j++)
						{
							Lists[i]=Lists[i]+"^"+DetailList[j];
						}
					}
					else
					{
						if (DetailList[23]=="DHCEQDisuseRequest")
						{
							Lists[i]=Lists[i].replace("^"+DetailList[2]+"^","^"+objDisUse[DetailList[2]]+"^");
						}
						else
						{
							Lists[i]=Lists[i].replace("^"+DetailList[2]+"^","^"+objEquip[DetailList[2]]+"^");
						}
					}
				}
				if (NewString!="") NewString=NewString+GetElementValue("SplitRowCode");
				NewString=NewString+Lists[i];
			}
		}
	
		//每条边格子数 17+3*4,纠错级别
		//alertShow(InfoList[19]+":"+QRErrorCorrectLevel.Q)
		var type=0;
		var qrcode="";
		if (InfoList[19]==0)
		{
			type=getTypeNumber(InfoList[38],QRErrorCorrectLevel.M);
			qrcode = new QRCode(type, QRErrorCorrectLevel.M);
		}
		if (InfoList[19]==1)
		{
			type=getTypeNumber(InfoList[38],QRErrorCorrectLevel.L);
			qrcode = new QRCode(type, QRErrorCorrectLevel.L);
		}
		if (InfoList[19]==2)
		{
			type=getTypeNumber(InfoList[38],QRErrorCorrectLevel.H);
			qrcode = new QRCode(type, QRErrorCorrectLevel.H);
		}
		if (InfoList[19]==3)
		{
			type=getTypeNumber(InfoList[38],QRErrorCorrectLevel.Q);
			qrcode = new QRCode(type, QRErrorCorrectLevel.Q);
		}
		//var valueStr=(objEquip.EQFileNo=="")?objEquip.EQNo:"fileno:"+objEquip.EQFileNo+",no:"+objEquip.EQNo;
		var ValueStr=utf16to8(objEquip.EQNo);
		qrcode.addData(ValueStr);
		qrcode.make();
		var TempCode=""
		for (var i=0;i<qrcode.modules.length;i++)
		{
			for (var j=0;j<qrcode.modules.length;j++)
			{
				TempCode+=String(Number(qrcode.modules[i][j]))
			}
		}
		if (GetElementValue("ChromeFlag")=="1")
		{
			var Str ="(function test(x){"
			Str +="var Bar=new ActiveXObject('EquipmentBar.PrintBar');"
			Str +="Bar.SplitRowCode='"+GetElementValue("SplitRowCode")+"';"			// Mozy003002	2020-03-18	调整调用方法
			Str +="Bar.BarInfo='"+Lists[0]+"';"	// 二维条码左侧打印-南方医院^1^60^500^0^2^2^3500^2000^1350^200^宋体^10^Y^0^160^600^1200^0^3^EQNo^0^520^0^Y^tiaoma^2^N^10248^65285^42428^^^^^^^标准二维码^3222299001100
			Str +="Bar.BarDetail='"+NewString+"';"
			Str +="Bar.QRCode='"+TempCode+"';"
			Str +="Bar.PrintOut('1');"
			Str +="return 1;}());";
			CmdShell.notReturn =0;   //设置无结果调用，不阻塞调用
			var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
		}
		else
		{
			var Bar=new ActiveXObject("EquipmentBar.PrintBar");
			Bar.SplitRowCode=GetElementValue("SplitRowCode");
			Bar.BarInfo=Lists[0];
			Bar.BarDetail=NewString;
			Bar.QRCode=TempCode;
			Bar.PrintOut('1');
		}
	}
}

document.body.onload = BodyLoadHandler;


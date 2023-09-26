//设备论证
function BodyLoadHandler() 
{
	var Type=GetElementValue("Type");
	if (Type=="1")
	{
		DisableAllTxt();
		DisableElement("RejectReason",false);
	}
	InitInfo();	
	InitStyle("ProductIntroduce","3");	
  	InitEvent();
  	FillEquipData();
  	FillData();  	
  	SetBEnabled();
  	SetElementEnable();  	
}

function InitInfo()
{
	Guser=curUserID;
	usercode=curUserCode;
    username=curUserName;
    BElement=new Array;
    BElementDeclare();
    InitMessage();
}


function SetElementEnable()
{
	var Type=GetElementValue("Type");
	var NextStep=GetElementValue("NextFlowStep")
	if (Type=="1")
	{
		//DisableAllTxt();
		//DisableElement("RejectReason",false);
		var RoleStep=GetElementValue("RoleStep");
		if (RoleStep==NextStep)
		{
			SetItemDisabale(3,0,GetElementValue("CurRole"))
		}
	}
	GetDisabledElement();
}

function InitEvent()
{
	var obj=document.getElementById("BAdd");//更新
	if (obj) obj.onclick=BAdd_Clicked;
	var obj=document.getElementById("BDelete");//删除
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BAudit");//审核
	if (obj) obj.onclick=BAudit_Clicked;
	var obj=document.getElementById("BSubmit");//提交
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BClose");//提交
	if (obj) obj.onclick=BClose_Clicked;
	var obj=document.getElementById("BCancelSubmit");//提交
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BPrint");//提交
	if (obj) obj.onclick=BPrint_Clicked;
}
function SetBEnabled()
{
	var Type=GetElementValue("Type");
	var Status=GetElementValue("Status");
	if (Status=="")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status=="0")
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status=="1")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
	}
	if (Status=="2")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Type=="0")
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	else
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		var NextStep=GetElementValue("NextFlowStep")
		if (Type=="1")
		{
			var RoleStep=GetElementValue("RoleStep")
			if (RoleStep!=NextStep)
			{
				DisableBElement("BCancelSubmit",true);
				DisableBElement("BAudit",true);
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
}
function BCancelSubmit_Clicked()
{
	if (CheckItemNull(2,"RejectReason")) return
	var RejectReason=GetElementValue("RejectReason");
	UpdateData(RejectReason,"5");
}
function BAudit_Clicked() //审核
{
	var Type=GetElementValue("Type");
	if (Type=="1") //审批
	{
		if (CheckAuditNull()) return;
		var val=GetOpinion();
		UpdateData(val,"2")
	}
	if (Type=="2") //审核
	{
		UpdateData(val,"3")
	}
}
function BSubmit_Clicked() //提交
{
	UpdateData("","1")
}
function BDelete_Clicked() 
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	UpdateData("","4")
}
function BAdd_Clicked() 
{
	if (CheckNull()) return;
	var combindata=CombinData();
	UpdateData(combindata,"0")
}

function BApproveUpdate_Clicked()
{
	var combindata=CombinData();
	UpdateData(combindata,"0","1")
}

function BClose_Clicked() 
{
	window.close();
}
function UpdateData(val,AppType,isApprove)
{
	var RowID=GetElementValue("RowID");
	val=RowID+"^"+val
	var encmeth=GetElementValue("upd")
	if (!isApprove) isApprove=0
	var ReturnValue=cspRunServerMethod(encmeth,val,AppType,"Y",isApprove);
	if (ReturnValue>0)
	{
		if (AppType=="4") 
		{
			var obj=opener.document.getElementById("ArgumentationDR");
			if (obj) obj.value=""
			window.close();
			opener.parent.frames["DHCEQBuyRequestItem"].location.reload();
			return;
		}
		if (AppType=="0"&RowID=="")
		{
			var obj=opener.document.getElementById("ArgumentationDR");
			if (obj) obj.value=ReturnValue
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQArgumentation&RowID='+ReturnValue+'&BuyRequestListDR='+GetElementValue("BuyRequestListDR")+'&Type=0'
			opener.parent.frames["DHCEQBuyRequestItem"].location.reload();
			return;
		}
		window.location.reload();
		
	}
	else
	{
		alertShow(t[ReturnValue]+"  "+t["01"]) //alertShow(t[ReturnValue])
	}
	opener.parent.frames["DHCEQBuyRequestItem"].location.reload();
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(2,"ProductIntroduce")) return true;
	return false;
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
function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;
  	combindata=combindata+"^"+GetElementValue("ProductIntroduce") ;
  	combindata=combindata+"^"+GetElementValue("Actuality") ;
  	combindata=combindata+"^"+GetElementValue("BuyReason") ;
  	combindata=combindata+"^"+GetElementValue("UseYearsNum") ;
  	combindata=combindata+"^"+GetElementValue("ReclaimYearsNum") ;
  	combindata=combindata+"^"+GetElementValue("AffectAnalyse") ;
  	combindata=combindata+"^"+GetElementValue("Condicion") ;
  	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
  	combindata=combindata+"^"+GetElementValue("NextRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("NextFlowStep") ;
  	combindata=combindata+"^"+GetElementValue("ApproveStatu") ;
  	combindata=combindata+"^"+GetElementValue("ApproveRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("Service") ;
  	combindata=combindata+"^"+GetElementValue("RejectReason") ;
  	combindata=combindata+"^"+GetElementValue("RejectUserDR") ;
  	combindata=combindata+"^"+GetElementValue("RejectDate") ;
  	combindata=combindata+"^"+GetElementValue("RejectTime") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ;
  	combindata=combindata+"^"+GetElementValue("SubmitDate") ;
  	combindata=combindata+"^"+GetElementValue("SubmitTime") ;
  	combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("CountNum") ;
  	combindata=combindata+"^"+GetElementValue("UseRate") ;
  	combindata=combindata+"^"+GetElementValue("GoodRate") ;
  	combindata=combindata+"^"+GetElementValue("ClinicEffect") ;
  	combindata=combindata+"^"+GetElementValue("UsePerWeekNum") ;
  	combindata=combindata+"^"+GetElementValue("WorkLoadPerWeekNum") ;
  	combindata=combindata+"^"+GetElementValue("UsePriceFee") ;
  	combindata=combindata+"^"+GetElementValue("YearIncomeFee") ;
  	combindata=combindata+"^"+GetElementValue("CostFee") ;
  	combindata=combindata+"^"+GetElementValue("SettleState") ;
  	combindata=combindata+"^"+GetElementValue("ResourceState") ;
  	combindata=combindata+"^"+GetElementValue("PolluteState") ;
  	combindata=combindata+"^"+GetElementValue("OtherState") ;
  	combindata=combindata+"^"+GetElementValue("PersonnelState") ;
  	combindata=combindata+"^"+GetElementValue("BuyRequestListDR") ;
  	
  	
  	combindata=combindata+"^"+GetElementValue("Material"); 
	combindata=combindata+"^"+GetElementValue("OperatorCount");
	combindata=combindata+"^"+GetElementValue("MedicalItem");
	combindata=combindata+"^"+GetElementValue("Consumption");
	combindata=combindata+"^"+GetElementValue("YearRunTime");
	combindata=combindata+"^"+GetElementValue("RatingPower");
	combindata=combindata+"^"+GetElementValue("CountInLoc");
	combindata=combindata+"^"+GetElementValue("DepreLimitYear");
	combindata=combindata+"^"+GetElementValue("FeeOfEmployee");
	combindata=combindata+"^"+GetElementValue("FeeOfDepre");
	combindata=combindata+"^"+GetElementValue("FeeOfMaterial");
	combindata=combindata+"^"+GetList("Income",5);	//GetElementValue("Income1");
	combindata=combindata+"^"+GetList("Effect",5);	//GetElementValue("Effect1");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
	//alertShow(combindata);
  	return combindata;
}

function FillList(name,value,max)
{
	//alertShow(value);
	var sum=0;
	if (value=="") return ;
	var list=value.split("&");
	for (var i=1;i<=max;i++)
	{
		try
		{
			if (list[i-1]!="") sum=sum+parseFloat(list[i-1]);
		}
		catch(e)
		{}
		SetElement(name+i,list[i-1]);
	}
	SetElement(name+"Sum",sum);
}

function GetList(name,max)
{
	var rtn="";
	for (var i=1;i<=max;i++)
	{
		if (rtn=="") 
		{	rtn=GetElementValue(name+i);}
		else
		{	rtn=rtn+"&"+GetElementValue(name+i);}
	}
	return rtn;
}

function FillEquipData()
{
	var BuyRequestList=GetElementValue("BuyRequestListDR");
	if ((BuyRequestList=="")||(BuyRequestList<1)) return;
	var encmeth=GetElementValue("fillEquipData");
	var ReturnList=cspRunServerMethod(encmeth,BuyRequestList);
	list=ReturnList.split("^");
	SetElement("EquipName",list[0]);
	SetElement("Manufacturer",list[2]);
	SetElement("Model",list[1]);
	SetElement("PriceFee",list[4]);
	SetElement("EquipCat",list[3]);
	SetElement("RequestLoc",list[5]);
}
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
	//var sort=43
	var sort=61;
	var sum=0;
	/*SetElement("AuditUserDR",list[0]);
	SetElement("AuditUser",list[sort+0]);
	SetElement("AuditDate",list[1]);
	SetElement("AuditTime",list[2]);*/
	SetElement("ProductIntroduce",list[3]);
	SetElement("Actuality",list[4]);
	SetElement("BuyReason",list[5]);
	SetElement("UseYearsNum",list[6]);
	SetElement("ReclaimYearsNum",list[7]);
	SetElement("AffectAnalyse",list[8]);
	SetElement("Condicion",list[9]);
	SetElement("ApproveSetDR",list[10]);
	SetElement("ApproveSet",list[sort+1]);
	SetElement("NextRoleDR",list[11]);
	SetElement("NextRole",list[sort+2]);
	SetElement("NextFlowStep",list[12]);
	SetElement("ApproveStatu",list[13]);
	SetElement("ApproveRoleDR",list[14]);
	SetElement("ApproveRole",list[sort+3]);
	SetElement("Service",list[15]);
	SetElement("RejectReason",list[16]);
	/*SetElement("RejectUserDR",list[17]);
	SetElement("RejectUser",list[sort+4]);
	SetElement("RejectDate",list[18]);
	SetElement("RejectTime",list[19]);*/
	SetElement("Remark",list[20]);
	SetElement("Status",list[21]);
	/*SetElement("SubmitUserDR",list[22]);
	SetElement("SubmitUser",list[sort+5]);
	SetElement("SubmitDate",list[23]);
	SetElement("SubmitTime",list[24]);
	SetElement("AddUserDR",list[25]);
	SetElement("AddUser",list[sort+6]);
	SetElement("AddDate",list[26]);
	SetElement("AddTime",list[27]);*/
	SetElement("CountNum",list[28]);
	SetElement("UseRate",list[29]);
	SetElement("GoodRate",list[30]);
	SetElement("ClinicEffect",list[31]);
	SetElement("UsePerWeekNum",list[32]);
	SetElement("WorkLoadPerWeekNum",list[33]);
	SetElement("UsePriceFee",list[34]);
	SetElement("YearIncomeFee",list[35]);
	SetElement("CostFee",list[36]);
	SetElement("SettleState",list[37]);
	SetElement("ResourceState",list[38]);
	SetElement("PolluteState",list[39]);
	SetElement("OtherState",list[40]);
	SetElement("PersonnelState",list[41]);
	SetElement("BuyRequestListDR",list[42]);
	//SetElement("BuyRequestList",list[sort+7]);
	//
	SetElement("Material",list[43]);
	SetElement("OperatorCount",list[44]);
	SetElement("MedicalItem",list[45]);
	SetElement("Consumption",list[46]);
	SetElement("YearRunTime",list[47]);
	SetElement("RatingPower",list[48]);
	SetElement("CountInLoc",list[49]);
	SetElement("DepreLimitYear",list[50]);
	SetElement("FeeOfEmployee",list[51]);
	SetElement("FeeOfDepre",list[52]);
	SetElement("FeeOfMaterial",list[53]);
	if (list[36]!="") sum=sum+parseFloat(list[36]);
	if (list[51]!="") sum=sum+parseFloat(list[51]);
	if (list[52]!="") sum=sum+parseFloat(list[52]);
	if (list[53]!="") sum=sum+parseFloat(list[53]);
	SetElement("CostSum",sum);
	//SetElement("Income1",list[54]);
	//SetElement("Effect1",list[55]);
	FillList("Income",list[54],5)
	FillList("Effect",list[55],5)
	SetElement("Hold1",list[56]);
	SetElement("Hold2",list[57]);
	SetElement("Hold3",list[58]);
	SetElement("Hold4",list[59]);
	SetElement("Hold5",list[60]);
}

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
	var sort=61;
	var sum=0;
	
	
	var BuyRequestList=GetElementValue("BuyRequestListDR");
	if ((BuyRequestList=="")||(BuyRequestList<1)) return;
	var encmeth=GetElementValue("fillEquipData");
	var ReturnList=cspRunServerMethod(encmeth,BuyRequestList);
	var equipList=ReturnList.split("^");
	
	
	
	var TemplatePath=GetElementValue("GetRepPath");
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQArgumentation.xls";
	    xlApp = new ActiveXObject("Excel.Application");	 
		xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    //xlsheet.PageSetup.RightMargin=0;
	    xlsheet.PageSetup.TopMargin=0;
	    	
	    var row=2;
	    xlsheet.cells(row,3)=equipList[5];//申请科室
	    xlsheet.cells(row,5)=equipList[0];//设备名称
	    xlsheet.cells(row,7)=equipList[2];//生产厂商
	   	row=row+1;
	    xlsheet.cells(row,3)=equipList[4];//预计单价
	    xlsheet.cells(row,5)=equipList[6];//申购台数
	    xlsheet.cells(row,7)=equipList[7];//预计总价
	    xlsheet.cells(row,9)=equipList[1];//规格型号
	    	
	    row=row+2;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[5];	//购置理由 BuyReason
	    row=row+5;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[3];	//产品介绍 "ProductIntroduce"
	    row=row+2;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[4];	//现状介绍	"Actuality"
	    row=row+2;
	    xlsheet.cells(row,3)=list[41];	//人员配备情况	PersonnelState
	    row=row+1;
	    xlsheet.cells(row,3)=list[15];	//售后服务	Service
	    row=row+1;
	    xlsheet.cells(row,3)=list[6];	//预计使用年限	UseYearsNum
	    xlsheet.cells(row,6)=list[44];	//操作仪器人数	OperatorCount
	    xlsheet.cells(row,7)=xlsheet.cells(row,7)+list[37];	//房屋水电配备情况	SettleState
	    xlsheet.cells(row,7)=xlsheet.cells(row,7)+list[40];	//其他特殊需求	OtherState	    
	    row=row+1;
	    xlsheet.cells(row,3)=list[45];	//该设备可开展的医疗服务项目	MedicalItem
	    row=row+2;
	    xlsheet.cells(row,3)=list[33];	//每年工作量	WorkLoadPerWeekNum
	    xlsheet.cells(row,6)=list[46];	//每工作量用消耗品用量	Consumption
	    row=row+1;
	    xlsheet.cells(row,3)=list[47];	//年开机时间	YearRunTime
	    xlsheet.cells(row,6)=list[48];	//仪器设备功率	RatingPower
	    row=row+1;
	    xlsheet.cells(row,3)=list[43];	//耗材价格	Material
	    row=row+1;
	    //xlsheet.cells(row,2)=xlsheet.cells(row,2);	//医务科或护理部或科教办填写
	    row=row+5;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[8];	//原有设备更新原因 "AffectAnalyse"
	    row=row+2;
	    xlsheet.cells(row,4)=list[49];	//申请部门目前有该类设备台数	CountInLoc
	    row=row+1;
	    xlsheet.cells(row,4)=list[28];	//全院有该类设备台数	CountNum
	    row=row+1;
	    xlsheet.cells(row,4)=list[50];	//规定折旧年限	DepreLimitYear
	    row=row+1;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[31];	//能否在本部门或全院调剂使用及原因	ClinicEffect
	    row=row+5;
	    //xlsheet.cells(row,2)=xlsheet.cells(row,2);	//物价办; 该仪器设备提供医疗服务每次收费标准?	
	    row=row+4;
	    //xlsheet.cells(row,2)=xlsheet.cells(row,2);	//总务科; 房屋?水电等配套设施情况?排污解决措施??	
	    
	    
	    row=2;
	    
	    row=row+6;
	    xlsheet.cells(row,13)=list[51];	//人员经费 费用测算	FeeOfEmployee	    
	    ///收入测算
		if (list[54]!="")
		{
			sum=0;
			var IncomeList=list[54].split("&");
			for (var i=1;i<=5;i++)
			{
				try
				{
					if (IncomeList[i-1]!="") sum=sum+parseFloat(IncomeList[i-1]);
				}
				catch(e)
				{}
				xlsheet.cells(row+i-1,15)=IncomeList[i-1];
			}
			if (sum>0) xlsheet.cells(row+i-1,15)=sum;			
		}
		///效益测算
		if (list[55]!="")
		{
			sum=0;
			var EffectList=list[55].split("&");
			for (var i=1;i<=5;i++)
			{
				try
				{
					if (EffectList[i-1]!="") sum=sum+parseFloat(EffectList[i-1]);
				}
				catch(e)
				{}
				xlsheet.cells(row+i-1,17)=EffectList[i-1];
			}
			if (sum>0) xlsheet.cells(row+i-1,17)=sum;			
		}
	    row=row+1;
	    xlsheet.cells(row,13)=list[52];	//仪器折旧 费用测算	FeeOfDepre
	    row=row+1;
	    xlsheet.cells(row,13)=list[36];	//耗电额 费用测算	CostFee
	    row=row+1;
	    xlsheet.cells(row,13)=list[53];	//消耗品金额 费用测算	FeeOfMaterial
	    row=row+2;
	    sum=0;
	    if (list[36]!="") sum=sum+parseFloat(list[36]);
		if (list[51]!="") sum=sum+parseFloat(list[51]);
		if (list[52]!="") sum=sum+parseFloat(list[52]);
		if (list[53]!="") sum=sum+parseFloat(list[53]);
	    xlsheet.cells(row,13)=sum;	//费用测算	合计
	    
	    var GetOpinionByRole=GetElementValue("GetOpinionByRole");
	    
	    var role=11;///医务
	    var Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    if (Opinion=="")
	    {
		    role=12;///科教
	    	Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
		}
		if (Opinion=="")
	    {
		    role=16;///护理
	    	Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
		}
	    xlsheet.cells(22,2)=xlsheet.cells(22,2)+Opinion;
	    
	    role=15;///物价办
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(37,2)=xlsheet.cells(37,2)+Opinion;
	    role=10;///总务
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(42,2)=xlsheet.cells(42,2)+Opinion;
	    role=13;///财务科
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(2,12)=xlsheet.cells(2,12)+Opinion;
	    role=17;///会计测算
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(14,12)=xlsheet.cells(14,12)+Opinion;	    
	    role=9;///院采购委员会
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(18,12)=xlsheet.cells(18,12)+Opinion;
	    role=6;///采购中心
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(27,12)=xlsheet.cells(27,12)+Opinion;
	    role=4;///审计办
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(33,12)=Opinion;
	    
	    ////计划信息
	    var buyplaninfo=GetElementValue("GetBuyPlanListInfo");
	    buyplaninfo=cspRunServerMethod(buyplaninfo,BuyRequestList);
	    list=buyplaninfo.split("^");
		sort=25
		
		xlsheet.cells(25,13)=list[1];		///Name
		var model=list[sort+2];
		if (model!="") model=":";
		model=model+list[sort+1];
		xlsheet.cells(25,15)=model;		///品牌  "ManuFac",list[sort+2]///"Model",list[sort+1]
		xlsheet.cells(25,17)=list[6];		///QuantityNum
		xlsheet.cells(25,19)=list[5];		///PriceFee
		xlsheet.cells(26,13)=list[7];		///TotalFee
		xlsheet.cells(26,15)=list[sort+11];		///Hold1Desc 供应商
		///xlsheet.cells(26,17)=list[6];		///供应商信誉
		///xlsheet.cells(26,19)=list[5];		///供应商电话
			
		/*
		SetElement("BuyPlan",list[sort+0]);
		SetElement("Name",list[1]);
		SetElement("ModelDR",list[2]);
		SetElement("Model",list[sort+1]);
		SetElement("ManuFacDR",list[3]);
		SetElement("ManuFac",list[sort+2]);
		SetChkElement("TestFlag",list[4]);
		SetElement("PriceFee",list[5]);
		SetElement("QuantityNum",list[6]);
		SetElement("TotalFee",list[7]);
		SetElement("Remark",list[8]);
		SetElement("BuyRequestListDR",list[9]);
		SetElement("BuyRequestList",list[sort+3]);
		SetElement("ContractDR",list[10]);
		SetElement("Contract",list[sort+4]);
		SetElement("UpdateUserDR",list[11]);
		SetElement("UpdateUser",list[sort+5]);
		SetElement("UpdateDate",list[12]);
		SetElement("UpdateTime",list[13]);
		SetElement("CurrencyDR",list[14]);
		SetElement("Currency",list[sort+6]);
		SetElement("EquipCatDR",list[15]);
		SetElement("EquipCat",list[sort+7]);
		SetElement("Hold1",list[16]);
		SetElement("ItemDR",list[17]);
		//SetElement("PurchaseType",list[sort+8]);
		SetElement("ArriveDate",list[18]);
		SetElement("PurposeTypeDR",list[19]);
		SetElement("PurposeType",list[sort+8]);
		SetChkElement("RefuseFlag",list[20]);
		SetElement("RefuseReason",list[21]);
		SetElement("BuyRequestDR",list[sort+9]);
		SetElement("BuyRequest",list[sort+10]);
		*/
    
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

function BPrint_Clicked()
{
	Print();
}

document.body.onload = BodyLoadHandler;
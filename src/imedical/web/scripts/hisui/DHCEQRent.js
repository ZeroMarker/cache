///Modified By HZY 2011-08-29 HZY0008
///Description:�޸ĺ���BUpdate_Click
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() 
{
	InitUserInfo();
	InitEvent();
	FillData();
	SetComboboxRequired();//add by csj 20180906 �ɲ��ӣ��ɱ༭�ֶ������ñ���ұ���ŵ�SetEnabled()����ǰ������47��HISUI�����б���� 
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"),GetElementValue("Action"));	//Add By DJ 2016-05-11
	KeyUp("RequestLoc^FromLoc^Model^RequestUser^RentManager^LocReceiver^ReturnManager^LocReturn");	//���ѡ��
	Muilt_LookUp("Equip^RequestLoc^FromLoc^Item^Model^RequestUser^RentManager^LocReceiver^ReturnManager^LocReturn"); //�س�ѡ��
	SetFocus("No");
	initButtonWidth();//add by csj 20180902 ����60��HISUIͳһ��ť���
	setButtonText();
 	var status=GetElementValue("StatusDR");
	hideButton(status);			//HISUI���� add by csj 20181011 ���ض��ఴť	
	SetTableMarginbottom();	//HISUI���� add by csj 20190107 ���������
}

///add by lmm 2018-09-18
///modified by csj 20181015 ��������״̬ 0������ 1:���� 2�����  3���黹  4:����
///���������ݵ���״̬���ð�ť�һ�
///��Σ�status������״̬ 0������ 1���ύ 2����� ��Ϊδ������
function hideButton(status)
{
	if (status=="")
	{
		hiddenObj("BAudit",1);
		hiddenObj("BCancelSubmit",1);
		hiddenObj("BCancel",1);
		hiddenObj("BDelete",1);
		hiddenObj("BSubmit",1);
	}
	else if (status==0)
	{
		hiddenObj("BAudit",1);
		hiddenObj("BCancelSubmit",1);
		hiddenObj("BCancel",1);
	}
	else if (status==1||status==2)
	{
		hiddenObj("BSubmit",1); 
		hiddenObj("BUpdate",1);
		hiddenObj("BDelete",1);	
	}
	else if (status==3)
	{
		hiddenObj("BCancelSubmit",1);
		hiddenObj("BAudit",1);
		hiddenObj("BSubmit",1); 
		hiddenObj("BUpdate",1);
		hiddenObj("BDelete",1);	
		
	}
	
}

function SetEnabled()
{
	var Equip=GetElementValue("Equip")
	var Action=GetElementValue("Action")
	var CancelFlag=GetElementValue("CancelFlag"); //add by zx 2016-07-14 ȡ���ύ��ť����
	if(CancelFlag=="N")
	{
		DisableBElement("BCancelSubmit",true);  
	}
	if (Equip!="")
	{
		DisableLookup("FromLoc",true)
		DisableLookup("Item",true)
		DisableLookup("Model",true)
	}
	var Status=GetElementValue("StatusDR");
	var Type=GetElementValue("Type");
	
	if (Status=="") //���������ťǰ
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if ((Status=="3")||(Action==""))	//�µ���,�ѹ黹,����
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (((Status!="")&&(Status!="0"))||(Action!="")||(Type=="Find")) //���ύ,�ѹ黹,����
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if(Status<1)
	{
		DisableBElement("BEquipRentPrint",true);
		DisableBElement("BRentPrint",true);
	}
	//����
	if (Type=="Apply")
	{
		var Str="RequestNo^StartDate^StartTime^RentManager^LocReceiver^RentStatus^RentStatusRemark^ReturnDate^ReturnTime^ReturnManager^LocReturn^ReturnStatus^ReturnStatusRemark^WorkLoad^LucreFee^LosingFee^WorkLoadUOM^TotalFee^RenewalToDate^RenewalToTime^Hold4^Hold5"
	}
	else
	{
		var Str="RequestNo^RequestLoc^FromLoc^Model^Item^PlanBeginDate^PlanBeginTime^PlanEndDate^PlanEndTime^RequestUser^No^Hold3"
		if (Action=="ZL_Loan")		//���
		{
			if (GetElementValue("EquipDR")!="")
			{
				Str=Str+"^Equip";
			}
			Str=Str+"^ReturnDate^ReturnTime^ReturnManager^LocReturn^ReturnStatus^ReturnStatusRemark^WorkLoad^LucreFee^LosingFee^WorkLoadUOM^TotalFee^RenewalToDate^RenewalToTime^Hold5"
		}
		if (Action=="ZL_LocReturn")	//�黹ȷ��
		{
			Str=Str+"^Equip^StartDate^StartTime^RentManager^LocReceiver^RentStatus^RentStatusRemark^ReturnDate^ReturnTime^ReturnManager^LocReturn^ReturnStatus^ReturnStatusRemark^WorkLoad^LucreFee^LosingFee^WorkLoadUOM^TotalFee^RenewalToDate^RenewalToTime^Hold4^Hold5"
		}
		if (Action=="ZL_Return")	//�黹
		{
			Str=Str+"^Equip^StartDate^StartTime^RentManager^LocReceiver^RentStatus^RentStatusRemark^No^RenewalToDate^RenewalToTime^Hold4"
		}
		if ((Action=="ZL_Renewal")||(Action=="ZL_RenewalOK"))		//���輰����ȷ��
		{
			Str=Str+"^Equip^StartDate^StartTime^RentManager^LocReceiver^RentStatus^RentStatusRemark^ReturnDate^ReturnTime^ReturnManager^LocReturn^ReturnStatus^ReturnStatusRemark^WorkLoad^LucreFee^LosingFee^WorkLoadUOM^TotalFee^Hold4^Hold5"
		}
		if (Type=="Find")			//����
		{
			// modified by sjh SJH0029 2020-6-29 ����ӡ���水ť����  bedin
			DisableBElement("BAudit",true);
			DisableBElement("BCancelSubmit",true); 
			// modified by sjh SJH0029 2020-6-29 ����ӡ���水ť����  end
			var tableName=GetParentTable("RequestNo")
			var All = tableName.getElementsByTagName( "INPUT" );
			var Length = All.length;
			for(var I = 0; I < Length; I++)
			{
				ReadOnlyElement(All[I].id,true)
			}
			Str="RentStatus^RentStatusRemark^ReturnStatus^ReturnStatusRemark"
		}
	}
	if (Str!="")
	{
		var list=Str.split("^");
		var num=list.length;
		for (var i=0;i<num;i++)
		{
			var ColName=list[i]
			DisableLookup(ColName,true);
			ReadOnlyElement(ColName,true);
			setItemRequire(ColName,false);	//add by csj 20180903 ����29.��̬���ñ�����ʽ
		}
	}
	//��˰�ť�䶯  Add By DJ 2016-05-31
	var ApproveAction=GetElementValue("ApproveAction")
	if (Action=="ZL_Loan") {SetCElement("BAudit","���");}
	if (Action=="ZL_Renewal") {SetCElement("BAudit","����");}
	if (Action=="ZL_LocReturn") {SetCElement("BAudit","�黹����");}
	if (Action=="ZL_Return") {SetCElement("BAudit","�黹");}
	if (Action=="ZL_RenewalOK") {SetCElement("BAudit","����ȷ��");}
	if ((!StrIsInStrs(ApproveAction,Action,","))||(1==GetElementValue("PrintFlag")))		//�˵��ݲ��ڲ�����ΧȨ�޷�Χ��  ///modify by lmm 2017-04-11 359763
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
}
function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BCopy");
	if (obj) obj.onclick=BCopy_Click;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Click;
	var obj=document.getElementById("BRent");
	if (obj) obj.onclick=BRent_Click;
	var obj=document.getElementById("BReturn");
	if (obj) obj.onclick=BReturn_Click;
	var obj=document.getElementById("WorkLoad");
	if (obj) obj.onchange=TotalFee_Change;
	var obj=document.getElementById("Equip");
	if (obj) obj.onchange=ClearMessage;
	var obj=document.getElementById("Item");
	if (obj) obj.onkeyup=ClearItemMessage;
	var obj=document.getElementById("No");
	if (obj) obj.onkeydown=No_KeyDown;

	var obj=document.getElementById("BackEquipNo");
	if (obj) obj.onkeydown=BackEquipNo_KeyDown;
	var obj=document.getElementById("RentAffix");
	if (obj) obj.onchange=RentAffix_Change;
	var obj=document.getElementById("ReturnAffix");
	if (obj) obj.onchange=ReturnAffix_Change;
	var obj=document.getElementById("BAddAffix");
	if (obj) obj.onclick=BAddAffix_Change;
	//var obj=document.getElementById("ReturnDate");
	//if (obj) obj.onchange=DateChange;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
	
	var obj=document.getElementById("BEquipRentPrint");  //add by zx 2016-07-04 
	if (obj) obj.onclick=BEquipRentPrint_Clicked;
	var obj=document.getElementById("BRentPrint");
	if (obj) obj.onclick=BRentPrint_Clicked;
}

function CombinData()
{
	//RentAffix_Change();
	//ReturnAffix_Change();
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("RequestNo") ;//2
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ; //3
  	combindata=combindata+"^"+GetElementValue("FromLocDR") ;  //4
  	combindata=combindata+"^"+GetElementValue("RequestUserDR") ; //5
  	//combindata=combindata+"^"+GetElementValue("RequestDate") ; //6
  	//combindata=combindata+"^"+GetElementValue("RequestTime") ; //7
  	combindata=combindata+"^"+GetElementValue("ItemDR") ; //8
  	combindata=combindata+"^"+GetElementValue("ModelDR") ; //9
  	combindata=combindata+"^"+GetElementValue("EquipDR") ; //10
  	combindata=combindata+"^"+GetElementValue("PlanBeginDate") ; //11
  	combindata=combindata+"^"+GetElementValue("PlanBeginTime") ; //12
  	combindata=combindata+"^"+GetElementValue("PlanEndDate") ; //13
  	combindata=combindata+"^"+GetElementValue("PlanEndTime") ;//14
  	combindata=combindata+"^"+GetElementValue("StartDate") ;//15
  	combindata=combindata+"^"+GetElementValue("StartTime") ; //16
  	combindata=combindata+"^"+GetElementValue("RentManagerDR") ;//17
  	combindata=combindata+"^"+GetElementValue("LocReceiverDR") ;//18
  	combindata=combindata+"^"+GetElementValue("RentStatus") ; //19
  	combindata=combindata+"^"+GetElementValue("RentStatusRemark") ;//20
  	combindata=combindata+"^"+curUserID;			  //RentOperatorDR  21
  	//combindata=combindata+"^"+GetElementValue("RentOperateDate") ; //RentOperateDate  22
  	//combindata=combindata+"^"+GetElementValue("RentOperateTime") ; //RentOperateTime  23
  	combindata=combindata+"^"+GetElementValue("ReturnManagerDR") ;//24
  	combindata=combindata+"^"+GetElementValue("LocReturnDR") ; //25
  	combindata=combindata+"^"+GetElementValue("ReturnDate") ; //26
  	combindata=combindata+"^"+GetElementValue("ReturnTime") ; //27
  	combindata=combindata+"^"+GetElementValue("ReturnStatus") ; //28
  	combindata=combindata+"^"+GetElementValue("ReturnStatusRemark") ; //29
  	combindata=combindata+"^"+curUserID;				//ReturnOperatorDR  30
  	//combindata=combindata+"^"+GetElementValue("ReturnOperateDate") ;//ReturnOperateDate  31
  	//combindata=combindata+"^"+GetElementValue("ReturnOperateTime") ; //ReturnOperateTime  32
  	combindata=combindata+"^"+GetElementValue("WorkLoad") ; // 33
  	combindata=combindata+"^"+GetElementValue("WorkLoadUOMDR") ; //34
  	combindata=combindata+"^"+GetElementValue("RentFee") ;   //35
  	combindata=combindata+"^"+GetElementValue("LucreFee") ; //36
  	combindata=combindata+"^"+GetElementValue("LosingFee") ; // 37
  	combindata=combindata+"^"+GetElementValue("TotalFee") ; //38
  	//combindata=combindata+"^"+GetElementValue("Status") ; //39
  	combindata=combindata+"^"+GetElementValue("Quantity") ; //39
  	combindata=combindata+"^"+GetElementValue("CurRole");
  	combindata=combindata+"^"+GetElementValue("RenewalToDate");
  	combindata=combindata+"^"+GetElementValue("RenewalToTime");
  	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetChkElementValue("Hold4");  //add by zx 2016-06-28 ������ȫ��־
  	combindata=combindata+"^"+GetChkElementValue("Hold5");  //add by zx 2016-06-28 ������ȫ��־ 
  	return combindata;
}
///Modified By HZY 2011-08-29 HZY0008
function BUpdate_Click() //����
{
	//Modify by zx 2020-06-24 Bug ZX0093
	var RentModeFlag=GetElementValue("RentModeFlag");
	if (RentModeFlag!="1")
	{
		alertShow("��ǰ����ģʽ���������޸����ã�")
		return;
	}
	if (CheckMustItemNull()) return;
	var BeginDate = GetElementValue("PlanBeginDate");
	var EndDate = GetElementValue("PlanEndDate");
	if((EndDate!="")&&(DateDiff(BeginDate,EndDate)>0))
	{
		messageShow("","","",t["-3001"]);	//Ԥ�ƽ���ʱ�䲻���ڿ�ʼʱ��֮ǰ !
		return;	
	}
	var EquipDR=GetElementValue("EquipDR");
	var rowid=GetElementValue("RowID");
	var Action=GetElementValue("Action");
	if (rowid=="")
	{
		var encmeth=GetElementValue("CheckUsedEquip");
		if (encmeth=="") return
		var CheckResult=cspRunServerMethod(encmeth,EquipDR,rowid,Action);
		if (CheckResult==1)
		{
			alertShow("���豸�Ѿ�������,��ȷ��!")
			return;
		}
	}
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,"0");
    if (result>0)
    {
	    alertShow("�����ɹ�!")
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&RowID='+result+"&Type=Apply";
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
	}
    else
    {
	    messageShow("","","",result+"   "+t["01"]);
    }
}

function BDelete_Click() 
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid,"1");
	if (result==rowid)
	{
		alertShow("ɾ���ɹ�!")
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&Type=Apply';
	}	
    else
    {
	    messageShow("","","",t[result]+"   "+t["01"]);
    }
}

function BSubmit_Click() 
{
	if (CheckMustItemNull()) return;
	var EquipDR=GetElementValue("EquipDR");
	if (EquipDR!="")
	{		
		var encmeth=GetElementValue("CheckEquipStockStatus");
		var Return=cspRunServerMethod(encmeth,EquipDR);
		if (Return!="0")
		{
			messageShow("","","",t[Return])
			return
			//var truthBeTold = window.confirm(t[Return]);
   			//if (!truthBeTold) return;
		}
	}
    var rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid,'2');
    if (result==rowid)
    {
	    alertShow("�����ɹ�!")
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&RowID='+rowid+"&Type=Apply";
		//ˢ�¸�������
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
	}
    else
    {
	    messageShow("","","",t[result]+"   "+t["01"]);
    }
}

///modify by GBX
function BAudit_Clicked()
{
	var ApproveRole=GetElementValue("CurRole");
	var EquipDR=GetElementValue("EquipDR");
	var rowid=GetElementValue("RowID");
	var Action=GetElementValue("Action");		//Add By DJ 2016-05-30
	if (Action=="ZL_Loan")		//���ʱ�ж��Ƿ��ж���
	{
		/*var Price=GetElementValue("Price")
		if (Price=="")
		{
			alertShow("�������豸�޶���!��������.")
			return
		}*/
		if (EquipDR=="")
		{
			alertShow("��ѡ�����豸!")
			return
		}
		var encmeth=GetElementValue("CheckUsedEquip");
		if (encmeth=="") return
		var CheckResult=cspRunServerMethod(encmeth,EquipDR,rowid,Action);
		if (CheckResult==1)
		{
			alertShow("���豸�Ѿ�������,��ȷ��!")
			return;
		}
	}
	if (CheckMustItemNull()) return; 
	var rowid=GetElementValue("RowID");
	//var zType=GetElementValue("Type");
	var plist=CombinData(); //��������
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") 
	{
		messageShow("","","",t["02"])
		return;
	}
	var result=cspRunServerMethod(encmeth,plist,'5',Action);
	if (result>0)
    {
	    alertShow("�����ɹ�!")
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&RowID='+rowid+"&Type=Find&Action="+Action;
	    //ˢ�¸�������
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
	}
 	else
    {
	    messageShow("","","",t[result]+"   "+t["01"]);
    }
}
function BCopy_Click() 
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,rowid,'3');
    if (result>0)
    {
	    alertShow("�����ɹ�!")
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&RowID='+result+"&Type=Apply";
	}
    else
    {
	    messageShow("","","",t[result]+"   "+t["01"]);
    }	
}
function BCancelSubmit_Click() 
{
	var rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var CurRole=GetElementValue("CurRole");
	if (CurRole=="") return;
	var Action=GetElementValue("Action");
	if (Action=="") return;
	var plist=rowid+"^"+CurRole
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,plist,'4',Action);
    if (result==rowid)
    {
	    alertShow("�����ɹ�!")
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&RowID='+result+"&Type=Find";
	}
    else
    {
	    messageShow("","","",t[result]+"   "+t["01"]);
    }	
}

function BRent_Click() 
{
	if (CheckMustItemNull()) return;
	if (GetElementValue("EquipDR")=="")
	{
		alertShow("�豸����Ϊ��!")
		return
	}
	var rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'5');
    if (result==rowid)
    {
	    alertShow("�����ɹ�!")
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&RowID='+result+"&Type=Find";
	    opener.location.reload()
	}
    else
    {
	    messageShow("","","",t[result]+"   "+t["01"]);
    }	
}
function BReturn_Click() 
{
	if (CheckMustItemNull()) return;
	var rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'6');
    if (result==rowid)
    {
	    alertShow("�����ɹ�!")
	    window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&RowID='+result+"&Type=Find";
	    opener.location.reload()
	}
    else
    {
	    messageShow("","","",t[result]+"   "+t["01"]);
    }	
}


function FillData()
{
	var RowID=GetElementValue("RowID");
	//messageShow("","","",RowID)
	if ((RowID=="")||(RowID<1)) return;
	var ApproveRoleDR=GetElementValue("ApproveRoleDR");  //add by zx 2016-07-14
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID,ApproveRoleDR);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=49;
	SetElement("RequestNo",list[0]);
	SetElement("RequestLocDR",list[1]);
	SetElement("RequestLoc",list[sort+1]);
	SetElement("FromLocDR",list[2]);
	SetElement("FromLoc",list[sort+2]);
	SetElement("RequestUserDR",list[3]);
	SetElement("RequestUser",list[sort+3]);
	SetElement("RequestDate",list[sort+4]);
	SetElement("RequestTime",list[sort+5]);
	SetElement("ItemDR",list[6]);
	SetElement("Item",list[sort+6]);
	SetElement("ModelDR",list[7]);
	SetElement("Model",list[sort+7]);
	SetElement("EquipDR",list[8]);
	SetElement("Equip",list[sort+8]);
	SetElement("PlanBeginDate",list[sort+29]);
	SetElement("PlanBeginTime",list[sort+30]);
	SetElement("No",list[sort+31]);
	SetElement("Quantity",list[38]); //mark
	SetElement("PlanEndDate",list[sort+11]);
	SetElement("PlanEndTime",list[sort+12]);
	if ((GetElementValue("Type")!="Rent")||(list[35]!="1"))
	{
		SetElement("StartDate",list[sort+9]);
		SetElement("StartTime",list[sort+10]);
		SetElement("RentManagerDR",list[13]);
		SetElement("RentManager",list[sort+13]);
		SetElement("LocReceiverDR",list[14]);
		SetElement("LocReceiver",list[sort+14]);
		SetElement("RentStatus",list[15]);		//list[sort+15]);
		SetElement("RentStatusRemark",list[16]);
	}
	if ((GetElementValue("Type")!="Return")||(list[35]!="2"))
	{
		var ReturnManagerDR=list[20]			//modified by czf 2017-10-13 355515 begin
		if(ReturnManagerDR=="")
		{
			ReturnManagerDR=curUserID
		}
		SetElement("ReturnManagerDR",ReturnManagerDR);
		var ReturnManager=list[sort+19]
		if(ReturnManager=="")
		{
			ReturnManager=curUserName
		}
		SetElement("ReturnManager",ReturnManager);  //modified by czf 2017-10-13 355515 end
		SetElement("LocReturnDR",list[21]);
		SetElement("LocReturn",list[sort+20]);
		SetElement("ReturnDate",list[sort+21]);
		SetElement("ReturnTime",list[sort+22]);
		SetElement("ReturnStatus",list[24]);			//list[sort+23]);
		SetElement("ReturnStatusRemark",list[25]);
		SetElement("WorkLoad",list[29]);
		SetElement("RentFee",list[31]);
		SetElement("LucreFee",list[32]);
		SetElement("LosingFee",list[33]);
		SetElement("TotalFee",list[34]);
	}
	
	SetElement("WorkLoadUOMDR",list[sort+50]);//add by wy 2017-8-18 ��������λ
	SetElement("WorkLoadUOM",list[sort+51]);
	SetElement("StatusDR",list[35]);
	SetElement("Status",list[sort+28]);
	SetElement("Price",list[sort+32]);
	SetElement("Mode",list[sort+33]); //�Ƽ۷�ʽ
	SetElement("ApproveSetDR",list[sort+34]);		//Add By DJ 2016-06-01
	SetElement("ApproveAction",list[sort+35]);		//Add By DJ 2016-06-02
	SetElement("RenewalToDate",list[42]);
	SetElement("RenewalToTime",list[43]);
	SetElement("Hold1",list[44]);
	SetElement("Hold2",list[45]);
	SetElement("Hold3",list[46]);
	if (list[47]=="Y")   //add by zx 2016-06-28 ������ȫ��ʶ
	{	SetChkElement("Hold4",1);	}
	else
	{	SetChkElement("Hold4",0);	}
	//SetElement("Hold4",list[47]);
	if (list[48]=="Y")   //add by zx 2016-06-28 ������ȫ��ʶ
	{	SetChkElement("Hold5",1);	}
	else
	{	SetChkElement("Hold5",0);	}
	//SetElement("Hold5",list[48]);
	SetElement("CancelFlag",list[sort+43]); //add by zx 2016-07-14 ȡ���ύ��ť����
	var Mode=GetElementValue("Mode");
	if (Mode==1)  //��ʱ���շ�
	{
		var StartDate=GetElementValue("StartDate");
		var StartTime=GetElementValue("StartTime");
		var ReturnDate=GetElementValue("ReturnDate");
		var ReturnTime=GetElementValue("ReturnTime");
		var UsedHour=(DateDiff(ReturnDate,StartDate))*24+TimeDiff(ReturnTime,StartTime)
		if (UsedHour<=0)
		{
			UsedHour="0"
			var Action=GetElementValue("Action");
			if (Action=="ZL_Return"||Action=="")	UsedHour="1"		//����1Сʱ��1Сʱ�Ʒ� ,modified by csj 20181010 ����ѯAction==",UsedHour��ӦΪ0 �����:681668
		}
		SetElement("WorkLoad",UsedHour)
	}
	TotalFee_Change()
}

function GetRequestLocID(value)
{
	GetLookUpID("RequestLocDR",value);
}
function GetFromLocID(value)
{
	GetLookUpID("FromLocDR",value);
}
function GetItemID(value)
{
	GetLookUpID("ItemDR",value);
}
function GetRequestUserID(value)
{
	GetLookUpID("RequestUserDR",value);
}
function GetRentManagerID(value)
{
	GetLookUpID("RentManagerDR",value);
}
function GetReturnManagerID(value)
{
	GetLookUpID("ReturnManagerDR",value);
}
function GetLocReceiverID(value)
{
	GetLookUpID("LocReceiverDR",value);
}
function GetLocReturnID(value)
{
	GetLookUpID("LocReturnDR",value);
}
function GetItemID(value)
{
	var val=value.split("^");
	SetElement("ItemDR",val[1]);
	SetElement("Item",val[0]);
	SetElement("Model",val[2]);
	SetElement("ModelDR",val[3]);
}
function GetEquipID(value)
{
	var val=value.split("^");
	SetElement("Equip",val[0]);
	SetElement("EquipDR",val[1]);
	SetElement("No",val[2]);
	SetElement("Model",val[3]);
	SetElement("ModelDR",val[4]);
	SetElement("FromLoc",val[5]);
	SetElement("FromLocDR",val[6]);
	SetElement("Item",val[7]);
	SetElement("ItemDR",val[8]);
	DisableLookup("FromLoc",true)
	DisableLookup("Item",true)
	DisableLookup("Model",true)
	DisableLookup("No",true)
}

function TotalFee_Change()
{
	var Price=GetElementValue("Price");
	var WorkLoad=parseInt(GetElementValue("WorkLoad"));
	if (isNaN(Price)||isNaN(WorkLoad))
	{
		SetElement('TotalFee','0');
	}
	else
	{
		var TotalFee=Price*WorkLoad
		if (TotalFee<=0)
		{
			SetElement('TotalFee','0');
		}
		else
		{
			SetElement('TotalFee',TotalFee.toFixed(2));
		}
	}
}
function ClearItemMessage()
{
	SetElement("ItemDR","")
	SetElement("Model","")
	SetElement("ModelDR","")
}
function ClearMessage()
{
	SetElement("EquipDR","")
	SetElement("Item","")
	SetElement("ItemDR","")
	SetElement("Model","")
	SetElement("ModelDR","")
	SetElement("No","")
	DisableLookup("FromLoc",false)
	DisableLookup("Item",false)
	DisableLookup("Model",false)
	DisableLookup("No",false)
}
function No_KeyDown()
{
	if (event.keyCode==13)
	{
		FillEquipInfo();
		SetFocus("RequestLoc");
	}
}

function FillEquipInfo()
{
	var EquipNo=GetElementValue("No");
	if (EquipNo=="") return;
	var encmeth=GetElementValue("GetInfoByEquipNo");
	if (encmeth=="")
	{
		messageShow("","","",t['NoMethod']);
		return;
	}
	/// "fileno:"+objEquip.FileNo+",no:"+objEquip.No;
	var EquipNolist=EquipNo.split(",");
	if (EquipNolist.length>1)
	{
		for (var i=0;i<EquipNolist.length;i++)
		{
			var list=EquipNolist[i].split(":");
			if (list[0]=="no") EquipNo=list[1];
		}
	}
	var FromLoc=GetElementValue("FromLoc");
	var FromLocDR=GetElementValue("FromLocDR");
	var result=cspRunServerMethod(encmeth,EquipNo, FromLocDR, FromLoc);
	if (result=="-1")
	{
		alertShow("��������ȷ���ţ�")
		return;
	}
	else if (result=="-2")
	{
		alertShow("�豸����ά�޻��Ѿ�����,����")
		return;
	}
	else if (result=="-3")
	{
		alertShow("�豸δ���ۣ�")
		return;
	}
	else
	{
		GetEquipID(result);
	}
}
function BackEquipNo_KeyDown()
{
	if (event.keyCode==13)
	{
		ReturnEquip();
	}	
}
function ReturnEquip()
{
	var EquipNo=GetElementValue("BackEquipNo");
	if (EquipNo=="") return;
	var encmeth=GetElementValue("GetBackInfoByEquipNo");
	if (encmeth=="")
	{
		messageShow("","","",t['NoMethod']);
		return;
	}
	var rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var result=cspRunServerMethod(encmeth,EquipNo,rowid);
	if (result=="-1")
	{
		alertShow("�黹�豸�����޳�ȥ�豸��һ��!")
		return;
	}
	else if (result=="-2")
	{
		//alertShow("")
		return;
	}
	else if (result=="0")
	{
		BReturn_Click();
	}
}

///Modified By GBX 2016-01-28  ����ѡ��
function RentAffix_Change()
{
	var AffixIds=GetSelectedAffix(1);
	SetElement("ValAffixs",AffixIds);
}

function FillRentAFFix()
{
	var AffixIn=GetElementValue("AffixInfos");
	if (AffixIn=="") return;
	var EquipDR=GetElementValue("EquipDR");
	if (EquipDR=="")
	{
		return;
	}
	var RowID=GetElementValue("RowID");
	var result=cspRunServerMethod(AffixIn,EquipDR);
	var obj=document.getElementById("RentAffix");
	var Affixlist=result.split("&");
	var Affixids=GetElementValue("ValAffixs");
	if (Affixids!="") Affixids=","+Affixids+",";
	for (var i=0;i<Affixlist.length;i++)
	{
		var list=Affixlist[i].split("^");
		obj.options.add(new Option(list[0],list[1],true,true));	//Modified By HZY 2012-04-27.HZY0029.��DHC_EQCEquipType��ṹ�仯,���ｫԭ����'4'��Ϊ���ڵ�'13'.
		if (Affixids.indexOf(","+list[1]+",")>-1)
		{	obj.options[i].selected=true;	}
		else
		{	obj.options[i].selected=false;	}
		
		if ((Affixids=="")&&(RowID==""))
		{
			obj.options[i].selected=true;
		}
	}
}

///type: 1 ids  2 names
function GetSelectedAffix(type)
{
	var Affixids="";
	var obj=document.getElementById("RentAffix");
	for (var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].selected!=true) continue;
		if (Affixids!="") Affixids=Affixids+",";
		if (type==1)
		{	
			Affixids=Affixids+obj.options[i].value;}
		else
		{	Affixids=Affixids+obj.options[i].text;}
	}
	return Affixids;
}
//�黹����
function ReturnAffix_Change()
{
	var AffixIds=GetSelectedReAffix(1);
	SetElement("ValReAffixs",AffixIds);
}

function FillReturnAFFix()
{
	var AffixIn=GetElementValue("AffixInfos");
	if (AffixIn=="") return;
	var EquipDR=GetElementValue("EquipDR");
	if (EquipDR=="")
	{
		return;
	}
	var RowID=GetElementValue("RowID");
	var result=cspRunServerMethod(AffixIn,EquipDR);
	var obj=document.getElementById("ReturnAffix");
	var Affixlist=result.split("&");
	var Affixids=GetElementValue("ValReAffixs");
	if (Affixids!="") Affixids=","+Affixids+",";
	for (var i=0;i<Affixlist.length;i++)
	{
		var list=Affixlist[i].split("^");
		obj.options.add(new Option(list[0],list[1],true,true));	
		obj.options[i].selected=true;
		if (Affixids.indexOf(","+list[1]+",")>-1)
		{	obj.options[i].selected=true;	}
		else
		{	obj.options[i].selected=false;	}
		
		if ((Affixids=="")&&(RowID==""))
		{
			obj.options[i].selected=true;
		}
	}
	
}

///type: 1 ids  2 names
function GetSelectedReAffix(type)
{
	var Affixids="";
	var obj=document.getElementById("ReturnAffix");
	for (var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].selected!=true) continue;
		if (Affixids!="") Affixids=Affixids+",";
		if (type==1)
		{	
			Affixids=Affixids+obj.options[i].value;}
		else
		{	Affixids=Affixids+obj.options[i].text;}
	}
	return Affixids;
}

function BAddAffix_Change()
{
	var EquipDR=GetElementValue("EquipDR");
	if (EquipDR=="")
	{
		alertShow("����ѡ���豸");
		return;
	}
	var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAffix&EquipDR='+EquipDR
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')

}

//�������޵ǼǱ��ӡ
//modified by sjh 2019-11-22 BUG00018
//modify by wl 2019-11-23 WL0040 PrintFlag �ѱ���,��ΪERPrintFlag
function BEquipRentPrint_Clicked()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var ERPrintFlag = GetElementValue("ERPrintFlag");	 //��ӡ��ʽ��־λ excel��0  ��Ǭ:1   
	var PreviewRptFlag = GetElementValue("PreviewRptFlag"); //��ǬԤ����־ ��Ԥ�� :0  Ԥ�� :1
	var HOSPDESC = GetElementValue("GetHospitalDesc");
	var filename = ""
	//Excel��ӡ��ʽ
	if(ERPrintFlag==0)  
	{
		BEquipRentPrint(RowID);
	}
	//��Ǭ��ӡ
	if(ERPrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQEquipRentPrint.raq(RowID="+RowID
		    +";HOSPDESC="+HOSPDESC
		    +";USERNAME="+curUserName
		    +")}";	
	        DHCCPM_RQDirectPrint(fileName);		
		}
		
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQEquipRentPrint.raq&RowID="+RowID
		    +"&HOSPDESC="+HOSPDESC
		    +"&USERNAME="+curUserName	   
			DHCCPM_RQPrint(fileName);	
		}
	}	
}
//add by zx 2016-07-04 
//�����豸��¼��ӡ
//modify by wl 2019-12-18 WL0040������Ǭ��ӡ��ʽ
function BRentPrint_Clicked()
{ 
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var ERPrintFlag = GetElementValue("ERPrintFlag");	 //��ӡ��ʽ��־λ excel��0  ��Ǭ:1   
	var PreviewRptFlag = GetElementValue("PreviewRptFlag"); //��ǬԤ����־ ��Ԥ�� :0  Ԥ�� :1
	var HOSPDESC = GetElementValue("GetHospitalDesc");
	var fileName = "";
		//Excel��ӡ��ʽ
	if(ERPrintFlag==0)  
	{
		BRentPrint(RowID);
	}
		//��Ǭ��ӡ
	if(ERPrintFlag==1)
	{
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQRent.raq(RRowID="+RowID
		    +";HOSPDESC="+HOSPDESC
		    +";USERNAME="+curUserName
		    +")}";	
	        DHCCPM_RQDirectPrint(fileName);		
		}
		
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQRent.raq&RRowID="+RowID
		    +"&HOSPDESC="+HOSPDESC
		    +"&USERNAME="+curUserName	   
			DHCCPM_RQPrint(fileName);	
		}
	}	
	
}
function BRentPrint()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmeth=GetElementValue("fillData"); ////2276482 Modify By BRB �޸�fillData��Сд2016-11-16	
	if (encmeth=="") return;
	var RentData=cspRunServerMethod(encmeth,RowID);
	RentData=RentData.replace(/\\n/g,"\n");
	var list=RentData.split("^");
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQRent.xls";
	    xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.TopMargin=0;
	    xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));		// Mozy 2017-9-28	457652
	    xlsheet.cells(2,9)="�� "+ list[0];
	    xlsheet.cells(3,4)=list[50];//��������
	    //xlsheet.cells(3,6)=GetShortName(lista[65],"-");  //
	    //xlsheet.cells(3,9)=FormatDate(lista[11]);  //
	    xlsheet.cells(3,10)=list[46];  //
	    xlsheet.cells(4,4)="";   //
	    xlsheet.cells(4,10)=FormatDate(list[58]);  //
	    xlsheet.cells(5,4)=list[57];   //�豸����
	    xlsheet.cells(5,10)=list[56];  //�豸����
	    xlsheet.cells(6,4)="";   //�豸���
	    xlsheet.cells(6,10)=list[80];  //�豸���
	    xlsheet.cells(7,4)="";   //
	    
	    xlsheet.cells(16,5)=list[57];  //�豸����
	    xlsheet.cells(16,9)=list[80];  //�豸���
	    xlsheet.cells(17,5)="";  //
	    xlsheet.cells(18,5)="";  //
	    xlsheet.cells(19,10)="�� "+ list[0];  //

	    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    var size=obj.GetPaperInfo("letter");
	    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    xlsheet.printout; //��ӡ���
	    xlBook.Close (savechanges=false);	    
	    xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	}
	catch(e)
	{
		messageShow("","","",e.message);
	}
	xlApp=null;
}
// add by zx 2016-07-04
// ʱ��ת��
//Modified  by wy 2017-5-25 ����ϵͳʱ���ʽ��ת��
function strToDate(str) {
	var tempStrs = str.split(" ");
	var SysDateFormat=tkMakeServerCall("websys.Conversions","DateFormat") 
	if ((SysDateFormat=="")||(SysDateFormat=="4"))
	{ 
	  var dateStrs = tempStrs[0].split("/");
	  var year = parseInt(dateStrs[2], 10);
	  var month = parseInt(dateStrs[1], 10);
	  var day = parseInt(dateStrs[0], 10);   
	} 
	if (SysDateFormat=="1")
	{
	    
	  var dateStrs = tempStrs[0].split("/");
	  var year = parseInt(dateStrs[2], 10);
	  var month = parseInt(dateStrs[0], 10);
	  var day = parseInt(dateStrs[1], 10);   
	}
	if (SysDateFormat=="3")
	{
	  var dateStrs = tempStrs[0].split("-");
	  var year = parseInt(dateStrs[0], 10);
	  var month = parseInt(dateStrs[1], 10);
	  var day = parseInt(dateStrs[2], 10);   
	
	}
	var timeStrs = tempStrs[1].split(":");
	var hour = parseInt(timeStrs [0], 10);
	var minute = parseInt(timeStrs[1], 10);
	var second = parseInt(timeStrs[2], 10);
	if(isNaN(year))
	{
		year="    ";
	}
	if(isNaN(month))
	{
		month="    ";
	}
	if(isNaN(day))
	{
		day="    ";
	}
	if(isNaN(hour))
	{
		hour="    ";
	}
	var date = year+"��"+month+"��"+day+"��"+hour+"ʱ"
	return date;
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;

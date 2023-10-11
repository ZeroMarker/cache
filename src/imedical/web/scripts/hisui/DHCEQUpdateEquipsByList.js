//Modefied by zc 2014-10-21 
//修改位置:BSubmit_Clicked
//描述:若SourceID为空，则为单台设备，设备明细不能修改
function BodyLoadHandler() 
{
	InitPage();
	var Status=GetElementValue("Status")
	if ((Status==1)||(Status==2)) 
	{
		DisableBElement("BUpdate",true)
		DisableBElement("SelectAll",true)
	}
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BSubmit_Clicked;

	//hisui改造 add by lmm 2018-08-17 begin
	$('#SelectAll').checkbox({
		onCheckChange:function(e,vaule){
			SelectAll_Clicked(vaule);
			
			}
			
	});
	//hisui改造 add by lmm 2018-08-17 end
	
	if (opener)
	{
		var obj=document.getElementById("BClose");
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
}
///出场编号修改
function BUpdate_Clicked()
{
	/*	Mozy	2001-5-4
	var SourceID=GetElementValue("SourceID");
	if (SourceID=="")
	{
		alertShow("该设备为导入的初始设备,请转到设备台帐更新该设备的出厂编号信息.");
		return;
	}*/
	if (GetElementValue("Type")=="3") return;	//验收明细的设备出厂编号不进行修改
	var listinfos="";
	var objtbl=document.getElementById('tDHCEQUpdateEquipsByList'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++)
	{
		var TRowID=GetElementValue("TRowIDz"+i)
		var TLeaveFactoryNo=GetElementValueNew("TLeaveFactoryNoz"+i,"")
		var ListInfo=TRowID+"^"+TLeaveFactoryNo
		var TSelect=GetElementValueNew("TSelectz"+i,"2")
		if (TSelect==true)
		{
			if (listinfos=="") listinfos=ListInfo
			else 
			{
				listinfos=","+listinfos+","
				if (listinfos.indexOf(","+ListInfo+",")<0)
				{
					listinfos=listinfos+ListInfo+","
				}
				listinfos=listinfos.substring(1,listinfos.length - 1)
			}
		}
	}
	if (listinfos=="") return;
	// Mozy	2011-5-31
	var rtn=CheckLeaveFactoryNo(listinfos);
	if (rtn!="1") return;
	
	var encmeth=GetElementValue("UpdateLeaveFactoryNo");
	if (encmeth=="") return
	var result=cspRunServerMethod(encmeth,listinfos);
	if (result==0)
	{
		location.reload();
	}
	else
	{
		alertShow("更新失败!");
	}
}

///Modified by JDL 2011-01-21 JDL0067
///明细选择
function BSubmit_Clicked()
{	
	var SourceID=GetElementValue("SourceID");
	if (SourceID=="") 
	{         //Modefied by zc 2014-10-21  zc0015  begin
		alertShow("设备数量为1，不能修改");
		return;
	
	}         //Modefied by zc 2014-10-21  zc0015 end
	//hisui改造 add by lmm 2018-03-15 begin
    //var i=rows-1
	//SetElement("Job",objtbl[i].TJob);	
	
	/*
	
	var objtbl=document.getElementById('tDHCEQUpdateEquipsByList'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var i=rows-1
	var TJob=GetElementValue("TJobz"+i)
	SetElement("Job",TJob);
	*/
    var objtbl = $("#tDHCEQUpdateEquipsByList").datagrid('getRows');
    var rows=objtbl.length

	var Job=objtbl[1].TJob 
	//hisui改造 add by lmm 2018-03-15 end
	
	
	var index=GetElementValue("index");
	var MXRowID=GetElementValue("MXRowID");
	var Type=GetElementValue("Type")
	//Modified by jdl 2011-01-21 JDL0067
	var SourceID=GetElementValue("SourceID");
	var StoreLocDR=GetElementValue("StoreLocDR");
	var QuantityNum=GetElementValue("QuantityNum");	
	var encmeth=GetElementValue("GetEquipIDsInfo");
	if (encmeth=="") return
	var listinfos=cspRunServerMethod(encmeth,Type,MXRowID,StoreLocDR,SourceID,QuantityNum,Job,index);	//取得已经存在的RowIDs
	var list=listinfos.split("&");
	listinfos=list[1];
	for (i=0;i<rows;i++)
	{
		var TRowID=objtbl[i].TRowID //GetElementValue("TRowIDz"+i)
		var ListInfo=TRowID
		//var TSelect=objtbl[i].TSelect  //GetElementValueNew("TSelectz"+i,"2")
		var TSelect=getColumnValue(i,"TSelect")  //hisui改造 add by lmm 2018-03-15 
		
		var tmp=","+listinfos+",";
		if (tmp.indexOf(","+ListInfo+",")==-1)
		{
			if (TSelect=="1")  //true
			{
				if (listinfos!="") listinfos=listinfos+",";
				listinfos=listinfos+ListInfo;
			}			
		}
		else
		{
			if (TSelect=="0") //false
			{
				tmp=tmp.replace(","+ListInfo+",",",")
				//Modified by jdl JDL0080 2011-04-26  转移单中?根据入库明细转移时?选择设备有时提示错误的问题?只选择一台设备?然后取消再选择出错的问题
				if (tmp==",")
				{	listinfos="";	}
				else
				{	listinfos=tmp.substring(1,tmp.length - 1) }
			}
		}		
	}	
	var Num=0
	if ((listinfos!="")&&(listinfos!=","))
	{
		var list=listinfos.split(",")
		Num=list.length
	}	
	//messageShow("","","",Num+"&"+QuantityNum+"&"+listinfos);
	
	var truthBeTold = true;
	var Rnt=Num-QuantityNum;
	// add by sjh SJH0034 2020-09-16 BEGIN
	if(Num==0)
	{
		var truthBeTold = window.confirm("选择的设备数量为0，最少选择一台或一台以上的设备！");
		return
	}
	// add by sjh SJH0034 2020-09-16 END
	if (Rnt<0)
	{
		var truthBeTold = window.confirm("选择的设备数量少了"+-Rnt+"台,是否修改?");
	}
	else if (Rnt>0)
	{
		var truthBeTold = window.confirm("选择的设备数量多了"+Rnt+"台,是否修改?");
	}
	if(truthBeTold)
	{
		var encmeth=GetElementValue("GetUpdate");
		if (encmeth=="") return
		var MXInfo=Job+"^"+index+"^"+Num+"^"+MXRowID+"^"+Type;
		var result=cspRunServerMethod(encmeth,listinfos,MXInfo);
		
		if (result==0)
		{
			if (Type==1)
			{
				var obj=opener.document.getElementById("TQuantityNumz"+index)
			}
			else if (Type==2)
			{
				var obj=opener.document.getElementById("TReturnQtyNumz"+index)
			}
			else if (Type==5)		//Add By DJ 2015-04-25
			{
				var obj=opener.document.getElementById("TQtyNumz"+index)
				if (obj) obj.innerText=Num;
			}
			else if (Type==6)		//Add By DJ 2015-04-25
			{
				//modify by lmm 2019-02-19 begin
				var encmeth=GetElementValue("GetEqNos");
				if (encmeth=="") return
				var EqNosInfo=cspRunServerMethod(encmeth,"","",listinfos);
				var EqNos=EqNosInfo.split("^");
				websys_showModal("options").mth(Num,EqNos[0]);  //modify by lmm 2019-02-19
				/*
				var obj=opener.document.getElementById("Amount")
				//if (obj) obj.innerText=Num;
				if (obj) obj.value=Num;  //hisui改造 modify by lmm 2018-07-26
				//Add By DJ 2016-12-01 单批次批量报废回写选择设备编号串
				var encmeth=GetElementValue("GetEqNos");
				if (encmeth=="") return
				var EqNosInfo=cspRunServerMethod(encmeth,"","",listinfos);
				var EqNos=EqNosInfo.split("^");
				var obj=opener.document.getElementById("No");
				if (obj)
				{
					obj.value=EqNos[0];
				}
				*/
			}
			
			if (Type!=6)
			{
				if (obj) obj.value=Num;
				//window.opener.SumList_Change()   //修改父窗口合计信息
				websys_showModal("options").mth();  //modify by lmm 2019-02-19
				//modify by lmm 2019-02-19 end
			}
			var val="&Job="+Job
			val=val+"&index="+index
			val=val+"&SourceID="+SourceID
			val=val+"&MXRowID="+MXRowID
			val=val+"&QuantityNum="+Num
			val=val+"&StoreLocDR="+StoreLocDR
			val=val+"&Status="+GetElementValue("Status")
			val=val+"&Type="+Type
			window.location.href= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUpdateEquipsByList&'+val;  //hisui改造 modify by lmm 2018-08-17
		}
		else
		{
			alertShow("更新失败!");
		}
	}
}

function SelectAll_Clicked(value)
{
	var valRowIDs=""
	//hisui改造 modify by lmm 2018-08-17 begin
	var SelectAll=""
	
	if (value==true) 
	{var SelectAll=1
	}
	else
	{ var SelectAll=0}
    var objtbl = $("#tDHCEQUpdateEquipsByList").datagrid('getRows');
    var Rows=objtbl.length
	for (var i=1;i<=Rows;i++)
	{
		var index=i-1 //用于获取当前行
		setColumnValue(index,"TSelect",SelectAll)
		
		/*
		var TSelect=getColumnValue(index,"TSelect")
		if (TSelect=="1")
		{
			var TRowID=objtbl[i].TRowID;
			var Select=getColumnValue(index,"TSelect");
			if (Select=="1")
			{
				Select=1;
				if (valRowIDs=="") valRowIDs=TRowID
				else 
				{
					if (valRowIDs.indexOf(TRowID)!=-1) 
					{
						valRowIDs=TRowID
					}else 
					{
						valRowIDs=valRowIDs+","+TRowID
					}
				}
			}
			else
			{
				Select=0;
				if (valRowIDs.indexOf(TRowID)!=-1)
				{
					var valRowIDs=","+valRowIDs+","
					var valRowIDs=valRowIDs.replace(","+TRowID+",",",")
					var valRowIDs=valRowIDs.substring(1,valRowIDs.length - 1)
					if (valRowIDs=",") valRowIDs=""
				}
			}
		}*/

	}
	//hisui改造 modify by lmm 2018-08-17 end
	
}
/// Add by Mozy 2011-5-31
/// 检测待保存的设备出厂编号是否有重复
function CheckLeaveFactoryNo(value)
{
	var encmeth=GetElementValue("CheckLeaveFactoryNo");
	if (encmeth=="") return 0;
	
	var result=cspRunServerMethod(encmeth,value);
	if (result!=0)
	{
		var list=result.split("^");
		var msg="";
		if (list[0]=="1")
		{	msg="待更新的出厂编号中有重复编号:"+list[1];}
		else
		{	msg="已有设备使用此出厂编号:"+list[1];		}
		
		var truthBeTold = window.confirm(msg+",是否继续更新保存?");
    	if (!truthBeTold) return 0;
	}
	return 1;
}
document.body.onload = BodyLoadHandler;
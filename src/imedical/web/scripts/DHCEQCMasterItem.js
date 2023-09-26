/// 版本号=Q3443
/// 注:Q表示"缺陷号"?[N]表示第N次补充修复?
/// 版本号=缺陷号+修改号;
/// 版本号统计自2014-07-01后开始
/// -------------------------------------------------------------
///add by GR 2014-10-10 
///缺陷号3443 代码维护-设备项维护-设备类组与设备类型不对应，新增成功
///缺陷原因：重新选择设备类组时没有清空设备类型
///修改:增加EquipTypeDR()
///----------------------------------------------------------------
/// Add By DJ 2010-05-31 DJ0044
/// Description:设备分类增加生成设备编码标志控制
///----------------------------------------------
//设备项
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //系统参数
	InitEvent();
	KeyUp("EquipType^Cat^StatCat^Unit");	//清空选择	
	Muilt_LookUp("EquipType^Cat^StatCat^Unit^Hold1Desc^Hold2Desc");
	disabled(true);//灰化
	
	//Add by JDL 2012-12-20 JDL0095
	//InitPageNumInfo("DHCEQCMasterItem.MasterItem","DHCEQCMasterItem");
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById(GetLookupName("Cat"));
	if (obj) obj.onclick=EquiCat_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BCopy")
	if (obj) obj.onclick=BCopy_Click;
	var obj=document.getElementById("Code");
	if (obj) obj.onkeydown=Code_KeyDown;
	//add by jdl 2009-9-12 JDL0029
	var obj=document.getElementById(GetLookupName("Hold1Desc"));
	if (obj) obj.onclick=Hold1Desc_Click;
	var obj=document.getElementById("Hold1Desc");
	if (obj) obj.onkeyup=Hold1Desc_KeyUp;
	
	//Add by JDL 2011-6-14 JDL0083
	var obj=document.getElementById("Hold2Desc");
	if (obj) obj.onkeyup=Hold2Desc_KeyUp;
	
	if (opener)
	{
		var obj=document.getElementById("BClose")
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
	//add by zy 20120426 ZY0093  ???????
	var obj=document.getElementById("Desc");
	if (obj) obj.onchange=GetCode;
}
function Code_KeyDown()
{
	if (event.keyCode==13)
	{
		//BFind_Click();
	}
}
function BFind_Click()
{
	var val="&Desc="+GetElementValue("Desc");
	val=val+"&Code="+GetElementValue("Code");
	val=val+"&Remark="+GetElementValue("Remark")
	val=val+"&EquipType="+GetElementValue("EquipType")
	val=val+"&EquipTypeDR="+GetElementValue("EquipTypeDR")
	val=val+"&Unit="+GetElementValue("Unit")
	val=val+"&UnitDR="+GetElementValue("UnitDR")
	val=val+"&Cat="+GetElementValue("Cat")
	val=val+"&CatDR="+GetElementValue("CatDR")
	val=val+"&StatCatDR="+GetElementValue("StatCatDR")
	val=val+"&StatCat="+GetElementValue("StatCat")
	val=val+"&Hold1="+GetElementValue("Hold1");
	//Add by JDL 2011-6-14 JDL0083
	val=val+"&Hold2="+GetElementValue("Hold2");
	///ZY0099
	val=val+"&ItemMode="+GetElementValue("ItemMode");
	val=val+"&Index="+GetElementValue("Index");
	val=val+"&Hold1Code="+GetElementValue("Hold1Code");
	val=val+"&Hold1Desc="+GetElementValue("Hold1Desc");
	
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem"+val;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function EquiCat_Click()
{
	var CatName=GetElementValue("Cat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("Cat",text);
	SetElement("CatDR",id);
}

function BCopy_Click() //
{
	if (condition()) return;
	if (CheckEquipCat(GetElementValue("CatDR"))<0)	//2010-05-31 党军 DJ0044 begin
	{
		alertShow("设备分类设置有误!")
		return
	}	//2010-05-31 党军 DJ0044 end
	var result=CheckEqCatIsEnd(GetElementValue("CatDR"))
	if ((result=="0")||(result=="2"))
	{
		alertShow("当前选择设备分类不是最末级!")
		if (result=="0") return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'3');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001])
		return
		}
	if (result>0)
	{
		alertShow("操作成功!")
		location.reload();
	}	
}

function BAdd_Click() //增加
{
	if (condition()) return;
	if (GetElementValue("EquipTypeDR")=="")	//Modefied by zc ZC0034 2018-2-12 begin
	{
		alertShow("设备类组不能为空!")
		return
	}  //Modefied by zc ZC0034 2018-2-12 end
	if (CheckEquipCat(GetElementValue("CatDR"))<0)	//2010-05-31 党军 DJ0044 begin
	{
		alertShow("设备分类设置有误!")
		return
	}	//2010-05-31 党军 DJ0044 end
	var result=CheckEqCatIsEnd(GetElementValue("CatDR"))
	if ((result=="0")||(result=="2"))
	{
		alertShow("当前选择设备分类不是最末级!")
		if (result=="0") return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001])
		return
		}
	if (result>0)
	{
		alertShow("操作成功")
		location.reload();
	}	
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Desc") ;//
  	combindata=combindata+"^"+GetElementValue("Code") ; //
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;//设备类别
  	combindata=combindata+"^"+GetElementValue("CatDR") ;//设备分类
  	combindata=combindata+"^"+GetElementValue("StatCatDR") ;//统计分类
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
  	combindata=combindata+"^"+GetElementValue("UnitDR") ; //单位
  	
  	//add by jdl 2009-9-12 JDL0029
  	combindata=combindata+"^"		//GetElementValue("InvalidFlag")
  	combindata=combindata+"^"+GetChkElementValue("ForceInspectFlag") ; 
  	combindata=combindata+"^"+GetElementValue("Hold1") ; 
  	combindata=combindata+"^"+GetElementValue("Hold2") ; 
  	combindata=combindata+"^"+GetChkElementValue("Hold3") ;  //add by zx 2016-06-15  维修设备项标志
  	combindata=combindata+"^"+GetChkElementValue("Hold4") ; 
  	combindata=combindata+"^"+GetElementValue("Hold5") ; 
  	
  	//alertShow(combindata);
  	  	
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	if (CheckEquipCat(GetElementValue("CatDR"))<0)	//2010-05-31 党军 DJ0044 begin
	{
		alertShow("设备分类设置有误!")
		return
	}	//2010-05-31	党军 DJ0044 end
	var result=CheckEqCatIsEnd(GetElementValue("CatDR"))
	if ((result=="0")||(result=="2"))
	{
		alertShow("当前选择设备分类不是最末级!")
		if (result=="0") return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,"");
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		alertShow(t[-3001]);
		return
	}
	if (result>0)
	{
		alertShow("操作成功!")
		location.reload();
	}	
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t[-3001])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("删除成功!")
		location.reload();
	}	
}
///选择表格行触发此方法
function SelectRowHandler()
	{
		//alertShow('a');
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCMasterItem');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	//alertShow("selectrow"+selectrow)
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();
		disabled(true)//灰化		
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		//alertShow("rowid"+rowid)
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Code",""); 
	SetElement("Desc","");
	//SetElement("EquipTypeDR",""); //  //Modefied by zc ZC0034 2018-2-12
	//SetElement("EquipType",""); //    //Modefied by zc ZC0034 2018-2-12									
	SetElement("CatDR",""); //
	SetElement("Cat","");//
	SetElement("StatCatDR","");//
	SetElement("StatCat","");//
	SetElement("Remark","");//
	SetElement("UnitDR","");//
	SetElement("Unit","");
	
	//add by jdl 2009-9-12 JDL0029
	//SetElement("InvalidFlag","");//
	SetElement("ForceInspectFlag","");//
	SetElement("Hold1","");//
	SetElement("Hold2","");//
	SetElement("Hold3","");//
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetElement("Hold1Desc","");
	SetElement("Hold1Code",""); //Mozy0110
	SetElement("Hold2Desc","");//

}
function SetData(rowid)
{
	//alertShow("rowid::::"+rowid)
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow("gbldata"+gbldata);
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]); //
	SetElement("Desc",list[2]); //
	SetElement("EquipTypeDR",list[3]); //
	SetElement("EquipType",list[4]); //
	SetElement("CatDR",list[5]); //
	SetElement("Cat",list[6]);//
	SetElement("StatCatDR",list[7]);//
	SetElement("StatCat",list[8]);//
	SetElement("Remark",list[9]);//
	SetElement("UnitDR",list[10]);//
	SetElement("Unit",list[11]);//
	
	//add by jdl 2009-9-12 JDL0029
	if (list[12]=="N")
	{	SetChkElement("ForceInspectFlag",0);	}
	else
	{	SetChkElement("ForceInspectFlag",1);	}
	SetElement("Hold1",list[13]);//
	SetElement("Hold2",list[14]);//
	SetChkElement("Hold3",list[15]);//// Mozy	20161111
	SetChkElement("Hold4",list[16]);
	SetElement("Hold5",list[17]);
	SetElement("Hold1Desc",list[18]);
	
	//Add by JDL 2011-6-14 JDL0083
	SetElement("Hold2Desc",list[19]);
	SetElement("Hold1Code",list[20]);//Mozy0110
	///ZY0099	
	if (GetElementValue("ItemMode")!="")
	{
		//var truthBeTold = window.confirm(t["-3002"]);	//2012-09-15
		//if (!truthBeTold) return;
		try
		{
			var index=GetElementValue("Index");
			var obj=opener.document.getElementById("TItemz"+index)
			if (obj) obj.value=list[2];
			var obj=opener.document.getElementById("TItemDRz"+index)
			if (obj) obj.value=list[0];
			var obj=opener.document.getElementById("EquipTypeDR")
			if (obj) obj.value=list[3];
			var obj=opener.document.getElementById("EquipType")
			if (obj) obj.value=list[4];
			var obj=opener.document.getElementById("TEquipCatz"+index)
			if (obj) obj.value=list[6];
			var obj=opener.document.getElementById("TEquipCatDRz"+index)
			if (obj) obj.value=list[5];
			var obj=opener.document.getElementById("SaveFlag")
			if (obj) obj.value="N";
		} catch(e) {};
	}
	
}
function UnitDR(value) // 单位
{
	//alertShow(value);
	var obj=document.getElementById("UnitDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]+"/"+val[2]);
}
function EquipTypeDR(value) //
{
	//alertShow(value);
	var obj=document.getElementById("EquipTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]+"/"+val[2]);
	SetElement('StatCat','');
	SetElement('StatCatDR','');
}
function CatDR(value) // 
{
	//alertShow(value);
	var obj=document.getElementById("CatDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]+"/"+val[2]);
}
function StatCatDR(value) // ItemDR
{
	//alertShow(value);
	var obj=document.getElementById("StatCatDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]+"/"+val[2]);StatCatDR
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)

	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(0,"Code")) return true;
	if (CheckItemNull(0,"Desc")) return true;
	*/
	return false;
}

//add by jdl 2009-9-12 JDL0029
function SetTreeDR(id,text) // 
{
	//alertShow(value);
	
	var obj=document.getElementById("Hold1");	
	if (obj) obj.value=id;
	var obj=document.getElementById("Hold1Desc");
	if (obj) obj.value=text;
	//add by zy 0113
	var encmeth=GetElementValue("GetOneTree");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',id);
	var list=gbldata.split("^");
	SetElement("Hold1Code",list[1]);//
}

//add by jdl 2009-9-12 JDL0029
function Hold1Desc_Click()
{
	var CatName=GetElementValue("Hold1Desc")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCTree&TreeType=1&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}


function Hold1Desc_KeyUp()
{
	var obj=document.getElementById("Hold1");	
	if (obj) obj.value="";
}

//Add by JDL 2011-6-14 JDL0083
function GetHospital(value)
{
	///alertShow(value);
	var obj=document.getElementById("Hold2");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}

//Add by JDL 2011-6-14 JDL0083
function Hold2Desc_KeyUp()
{
	var obj=document.getElementById("Hold2");	
	if (obj) obj.value="";
}
//add by zy 20120426 ZY0093  ???????
function GetCode()
{
	var Desc=GetElementValue("Desc");
	var Code=GetPYCode(Desc);
	SetElement("Code",Code);
}
document.body.onload = BodyLoadHandler;
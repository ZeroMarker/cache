
/*
if (document.all) {
         document.write(' <OBJECT id="Player"');
         document.write(' classid="clsid:6BF52A52-394A-11d3-B153-00C04F79FAA6"');
         document.write(' width=0 height=0 > <param name="URL" value="../videos/msg.wav" /> <param name="AutoStart" value="false" /> </OBJECT>');
     }
     else {
         document.write(' <OBJECT id="Player"');
         document.write(' type="application/x-ms-wmp"');
         document.write(' src= "${base}/videos/msg.wav" width=0 height=0> </OBJECT>');
     }
*/

//设备机型
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	//modified by cjt 20230212 需求号3221958 UI页面改造
	initPanelHeaderStyle();
	initButtonColor();
	InitUserInfo(); //系统参数
	InitEvent();	
	KeyUp("Item");	//清空选择
	Muilt_LookUp("Item");
	disabled(true);//灰化
	//Add by JDL 2011-08-30 JDL0095
	InitPageNumInfo("DHCEQCModel.Model","DHCEQCModel");
	InitPlayer();
	initButtonWidth();  //hisui改造 add by MWZ 2018-08-28
	setButtonText();	//HISUI改造 add by MWZ 2018-09-28
	//SetItemFontSize("*","24px")
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
}
function BFind_Click()
{
	var val="&Desc="+GetElementValue("Desc");
	val=val+"&Code="+GetElementValue("Code");
	val=val+"&Remark="+GetElementValue("Remark")
	val=val+"&Item="+GetElementValue("Item")
	val=val+"&ItemDR="+GetElementValue("ItemDR")
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCModel"+val;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BAdd_Click() //增加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("操作成功!")
		location.reload();
	}
	else
	{
		if(result=="-3001") messageShow("","","",t[-3001])
		else  alertShow("操作失败!错误代码:"+result)
		return
	}
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Code") ;//
  	combindata=combindata+"^"+GetElementValue("Desc") ; //
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
  	combindata=combindata+"^"+GetElementValue("ItemDR") ; //
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	combindata=combindata+"^"+GetElementValue("Hold4") ; //
  	combindata=combindata+"^"+GetElementValue("Hold5") ; //
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("操作成功!")
		location.reload();
	}
	else
	{
		if(result=="-3001") messageShow("","","",t[-3001])
		else  alertShow("操作失败!错误代码:"+result)
		return
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
		messageShow("","","",t[-3001])
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
///modify by lmm 2018-08-17
///描述：hisui改造 更改值获取方式 并添加入参
///入参：index 行号
///      rowdata 行json数据
function SelectRowHandler(index,rowdata)
	{
		
	if (SelectedRow==index)	{
		Clear();
		disabled(true)//灰化		
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		
		$('#tDHCEQCModel').datagrid('unselectAll');  
		
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID   
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}

function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("ItemDR","");
	SetElement("Item","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	}
function SetData(rowid)
{
	//alertShow("rowid::::"+rowid)
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]); //
	SetElement("Desc",list[2]); //
	SetElement("Remark",list[3]);//
	SetElement("ItemDR",list[4]);//
	SetElement("Item",list[5]);//
	SetElement("Hold1",list[6]);//
	SetElement("Hold2",list[7]);//
	SetElement("Hold3",list[8]);//
	SetElement("Hold4",list[9]);//
	SetElement("Hold5",list[10]);//
}
function ItemDR(value) // ItemDR
{
	//messageShow("","","",value);
	var obj=document.getElementById("ItemDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//messageShow("","","",val[1]+"/"+val[2]);StatCatDR
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

function InitPlayer()
{
     //Player.controls.play();
}

document.body.onload = BodyLoadHandler;

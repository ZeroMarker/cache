
function BodyLoadHandler()
{
	SetElement("SourceType",GetElementValue("SourceTypeDR"))
	InitPage();
	initButtonWidth()  //hisui����:�޸Ľ��水ť���Ȳ�һ�� add by lmm 2018-08-20
	singlelookup("SourceID","PLAT.L.EquipType","","")  //hisui����:��ʼ����Դ������ add by lmm 2018-08-17   //modify by lmm 2018-12-04
	//add by lmm 2020-05-19 1324470
	if (GetElementValue("CancelFlag")=="Y")
	{
		DisableBElement("BAdd1",true);
	}

}
function InitPage()
{
	
	if (GetElementValue("BussType")==2)
	{
		KeyUp("Name^MaintLoc^SourceID","N");
		Muilt_LookUp("Name^MaintLoc^SourceID","N");
	}
	else
	{
		KeyUp("Name^MaintType^MaintLoc^SourceID","N");
		Muilt_LookUp("Name^MaintType^MaintLoc^SourceID","N");
	}
	
	var obj=document.getElementById("BAdd1");;
	if (obj) obj.onclick=BAdd1_Click;
	
}


//hisui���� add by lmm 2018-08-17 begin  �л������б����¶�����Դ������
///modify by lmm 2018-12-04
$("#SourceType").combobox({
    onChange: function () {
	SourceType_Click()
	var SourceType=$("#SourceType").combobox('getValue')
	if (SourceType==1){    //1:�豸���� 
		singlelookup("SourceID","PLAT.L.EquipType","","")  
	}
	else if (SourceType==2)
	{    
		singlelookup("SourceID","PLAT.L.StatCat",[{name:"SourceID",type:1,value:"SourceID"},{name:"EquipTypeDR",type:2,value:''},{name:"EquipTypeFlag",type:2,value:'Y'}],"")   //modify by lmm 2019-08-29 990959

	}
	else if (SourceType==4)
	{    
		singlelookup("SourceID","PLAT.L.Loc","","")

	}
	else if (SourceType==6)
	{    
		singlelookup("SourceID","EM.L.GetMasterItem","","")

	}
	else if (SourceType==5) //3:�豸
	{
		singlelookup("SourceID","EM.L.Equip","","")
	
	}
  }
})
//hisui���� add by lmm 2018-08-17 end 
function SourceType_Click()
{    
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
	SetElement('SourceID',"");
	SetElement('SourceIDDR',"");
}

///add by lmm 2018-08-17
///������hisui���� ������ֵ
///��Σ�item ѡ����json����
function GetSourceID(item) 
{
	SetElement('SourceIDDR',item.EQRowID);
}

function GetNameID(value)
{
	GetLookUpID('NameDR',value);
}
function GetMaintType(value)
{
	GetLookUpID('MaintTypeDR',value);
}
function GetMaintLoc(value)
{
	GetLookUpID('MaintLocDR',value);
}
function SetEquipCat(id,text)
{
	SetElement('SourceID',text);
	SetElement('SourceIDDR',id);
}
///add by lmm 2018-08-17
///������hisui���� ������ֵ
///��Σ�item ѡ����json����
function GetCatID(item) 
{
	SetElement('SourceIDDR',item.ECRowID);
}
///add by lmm 2018-08-17
///������hisui���� ������ֵ
///��Σ�item ѡ����json����
function GetMasterItemID(item) 
{
	SetElement('SourceIDDR',item.MIRowID);
}
///add by lmm 2018-10-31 hisui���죺�����������
function BAdd1_Click() //GR0026 ����������´��ڴ�ģ̬����
{
	var BussType=GetElementValue("BussType");
	var QXType=GetElementValue("QXType"); 
	var MaintTypeDR=GetElementValue("MaintTypeDR");
	var val="&BussType="+BussType+"&QXType="+QXType+"&MaintTypeDR="+MaintTypeDR;
	url="dhceq.em.meterageplan.csp?"+val
	//add by lmm 2018-01-18 begin
	var title="�豸�����ƻ�"
	if (GetElementValue("MaintTypeDR")=="4")
	{
		url="dhceq.em.inspectplan.csp?"+val
		var title="�豸Ѳ��ƻ�"
	}
	if (BussType=="1")
	{
		url="dhceq.em.maintplan.csp?"+val
		var title="�豸�����ƻ�"
	}
	showWindow(url,title,"","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
}
///add by lmm 2019-1-12 804471
///������������ֵ�¼�
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}
///add by lmm 2019-1-12 804471
///����������������¼�
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
		
}

document.body.onload = BodyLoadHandler;

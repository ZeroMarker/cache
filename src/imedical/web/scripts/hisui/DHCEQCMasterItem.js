/// �汾��=Q3443
/// ע:Q��ʾ"ȱ�ݺ�"?[N]��ʾ��N�β����޸�?
/// �汾��=ȱ�ݺ�+�޸ĺ�;
/// �汾��ͳ����2014-07-01��ʼ
/// -------------------------------------------------------------
///add by GR 2014-10-10 
///ȱ�ݺ�3443 ����ά��-�豸��ά��-�豸�������豸���Ͳ���Ӧ�������ɹ�
///ȱ��ԭ������ѡ���豸����ʱû������豸����
///�޸�:����EquipTypeDR()
///----------------------------------------------------------------
/// Add By DJ 2010-05-31 DJ0044
/// Description:�豸�������������豸�����־����
///----------------------------------------------
//�豸��
var SelectedRow = -1;  //hisui���� modified by kdf 2018-03-01
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //ϵͳ����
	InitEvent();
	KeyUp("EquipType^Cat^StatCat^Unit");	//���ѡ��	
	//messageShow("","","",document.getElementById("UnitDR").value)
	Muilt_LookUp("EquipType^Cat^StatCat^Unit^Hold1Desc^Hold2Desc");
	disabled(true);//�һ�
	initButtonWidth()  //hisui���� add by lmm 2018-08-20
	initCatLookUp()	//add by csj 20190603	���������ݲ����Ƿ񵯴�
	//Add by JDL 2012-12-20 JDL0095
	//InitPageNumInfo("DHCEQCMasterItem.MasterItem","DHCEQCMasterItem");
	initMasterItem()	//add by csj 20190809
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
		EQCommon_HiddenElement("BComputer")   //add by lmm 2020-05-07
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
	//add by zy 20120426 ZY0093  ???????
	var obj=document.getElementById("Desc");
	if (obj) obj.onchange=GetCode;
	
	var obj=document.getElementById("BComputer");
	if (obj) obj.onclick=BComputer_Click;
	
}

function BComputer_Click()
{
	url="dhceq.em.maintmasteritemlimitlist.csp?"+"&SourceType=1"+"&Planstatus=3&EquipAttributeString=id1";	
	showWindow(url,"�豸��","","","","modal","","","verylarge",BFind_Click)  //modify by lmm 2020-06-05 UI
	
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
	val=val+"&ReadOnly="+GetElementValue("ReadOnly");		// Mozy	1066474	2019-10-26
	//add by wl 2020-02-18 WL0051 
	//add by lmm 2020-05-07 ��Ϊ��ȡ��������
	if (GetElementValue("EquipAttributeFlag")=="")
	{
		val=val+"&EquipAttributeString="+getKeywordsData();
	}
	else
	{
		val=val+"&EquipAttributeString="+GetElementValue("EquipAttributeString")
		
	}
	val=val+"&EquipAttributeFlag="+GetElementValue("EquipAttributeFlag");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem"+val;  //hisui���� modify by lmm 2018-08-17
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function EquiCat_Click()
{
	var CatName=GetElementValue("Cat")
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
	showWindow(str,"�豸������","","","","","","","middle",SetEquipCat)	 //modify by lmm 2020-06-05 UI
//    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("Cat",text);
	SetElement("CatDR",id);
}

function BCopy_Click() //
{
	if (condition()) return;
	if (CheckEquipCat(GetElementValue("CatDR"))<0)	//2010-05-31 ���� DJ0044 begin
	{
		alertShow("�豸������������!")
		return
	}	//2010-05-31 ���� DJ0044 end
	var result=CheckEqCatIsEnd(GetElementValue("CatDR"))
	if ((result=="0")||(result=="2"))
	{
		alertShow("��ǰѡ���豸���಻����ĩ��!")
		if (result=="0") return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,'','',plist,'3');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
		}
	if (result>0)
	{
		alertShow("�����ɹ�!")
		location.reload();
	}	
}

function BAdd_Click() //����
{
	if (condition()) return;
	if (CheckEquipCat(GetElementValue("CatDR"))<0)	//2010-05-31 ���� DJ0044 begin
	{
		alertShow("�豸������������!")
		return
	}	//2010-05-31 ���� DJ0044 end
	var result=CheckEqCatIsEnd(GetElementValue("CatDR"))
	if ((result=="0")||(result=="2"))
	{
		alertShow("��ǰѡ���豸���಻����ĩ��!")
		if (result=="0") return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	//begin add by jyp 2019-09-02 �豸������ص���
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var i=SelectType.length;
	var EquipAttributeString=""
	for (var j=0;j<i;j++)
	{
		if(EquipAttributeString=="")
		{
			EquipAttributeString=SelectType[j].id
		}else
		{
			EquipAttributeString=EquipAttributeString+"^"+SelectType[j].id
		}
	}
	//begin add by jyp 2019-09-02 �豸������ص���
	var result=cspRunServerMethod(encmeth,'','',plist,'2',EquipAttributeString);
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
		}
	if (result>0)
	{
		alertShow("�����ɹ�")
		location.reload();
	}	
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Desc") ;//
  	combindata=combindata+"^"+GetElementValue("Code") ; //
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;//�豸���
  	combindata=combindata+"^"+GetElementValue("CatDR") ;//�豸����
  	combindata=combindata+"^"+GetElementValue("StatCatDR") ;//ͳ�Ʒ���
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
  	combindata=combindata+"^"+GetElementValue("UnitDR") ; //��λ
  	
  	//add by jdl 2009-9-12 JDL0029
  	combindata=combindata+"^"		//GetElementValue("InvalidFlag")
  	combindata=combindata+"^"+GetChkElementValue("ForceInspectFlag") ; 
  	combindata=combindata+"^"+GetElementValue("Hold1") ; 
  	combindata=combindata+"^"+GetElementValue("Hold2") ; 
  	combindata=combindata+"^"+GetChkElementValue("Hold3") ;  //add by zx 2016-06-15  ά���豸���־
  	combindata=combindata+"^"+GetElementValue("Hold4") ; 
  	combindata=combindata+"^"+GetElementValue("Hold5") ; 
  	combindata=combindata+"^"+GetElementValue("MeasureFee") ;	//add by czf 1283059 ��̨��������
  	
  	//messageShow("","","",combindata);
  	  	
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	if (CheckEquipCat(GetElementValue("CatDR"))<0)	//2010-05-31 ���� DJ0044 begin
	{
		alertShow("�豸������������!")
		return
	}	//2010-05-31	���� DJ0044 end
	var result=CheckEqCatIsEnd(GetElementValue("CatDR"))
	if ((result=="0")||(result=="2"))
	{
		alertShow("��ǰѡ���豸���಻����ĩ��!")
		if (result=="0") return
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	//begin add by jyp 2019-09-02 �豸������ص���
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var i=SelectType.length;
	var EquipAttributeString=""
	for (var j=0;j<i;j++)
	{
		if(EquipAttributeString=="")
		{
			EquipAttributeString=SelectType[j].id
		}else
		{
			EquipAttributeString=EquipAttributeString+"^"+SelectType[j].id
		}
	}
	//begin add by jyp 2019-09-02 �豸������ص���
	var result=cspRunServerMethod(encmeth,'','',plist,"",EquipAttributeString);    // modify by jyp 2019-09-02 �豸������ص���
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		messageShow("","","",t[-3001]);
		return
	}
	if (result>0)
	{
		alertShow("�����ɹ�!")
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
	messageShow("","","",t[-3001])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("ɾ���ɹ�!")
		location.reload();
	}	
}
///ѡ�����д����˷���
///modify by lmm 2018-08-17
///������hisui���� ����ֵ��ȡ��ʽ ��������
///��Σ�index �к�
///      rowdata ��json����
function SelectRowHandler(index,rowdata)
{	
	if (SelectedRow==index)	{
		Clear();
		disabled(true)//�һ�		
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		$("#EquipAttributeList").keywords("clearAllSelected")
		$('#tDHCEQCMasterItem').datagrid('unselectAll');  
		
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID   
		SetData(rowid);//���ú���
		SetEquipAttribute(rowid)
		disabled(false)//���һ�
		}
}

function Clear()
{
	SetElement("RowID","");
	SetElement("Code",""); 
	SetElement("Desc","");
	//SetElement("EquipTypeDR",""); //modified by wy 2019-5-25 899765
	//SetElement("EquipType",""); //
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
	$("#EquipAttributeList").keywords("clearAllSelected"); //add by wl 2020-02-18 WL0051
	SetElement("MeasureFee","");		//czf 2020-04-27

}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
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
	SetElement("Hold4",list[16]);
	SetElement("Hold5",list[17]);
	SetElement("Hold1Desc",list[18]);
	
	//Add by JDL 2011-6-14 JDL0083
	SetElement("Hold2Desc",list[19]);
	SetElement("Hold1Code",list[20]);//Mozy0110
	SetElement("MeasureFee",list[21]);	//czf 1283059
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
function UnitDR(value) // ��λ
{
	var obj=document.getElementById("UnitDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function EquipTypeDR(value) 
{
	var obj=document.getElementById("EquipTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	SetElement('StatCat','');
	SetElement('StatCatDR','');
}
// MZY0032	2020-06-09	�������ำֵ
function CatDR(value) 
{
	SetElement("Cat",value.TDescription);
	SetElement("CatDR",value.TRowID);
}
function StatCatDR(value) 
{
	var obj=document.getElementById("StatCatDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function disabled(value)//�һ�
{
	// Mozy	1066474	2019-10-26
	if (GetElementValue("ReadOnly")==1)
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		DisableBElement("BAdd",true)
	}
	else
	{
		InitEvent();
		DisableBElement("BUpdate",value)
		
		DisableBElement("BDelete",value)
		DisableBElement("BAdd",!value)
		EQCommon_HiddenElement("BComputer")   //add by lmm 2020-05-07
	}
}	
function condition()//����
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(0,"Code")) return true;
	if (CheckItemNull(0,"Desc")) return true;
	*/
	return false;
}

//modified by csj 20191107 
function SetTreeDR(value)  
{
	var obj=document.getElementById("Hold1");
	var val=value.split("^");	
	if (obj) obj.value=val[1];	
	var obj=document.getElementById("Hold1Desc");
	if (obj) obj.value=val[0];
	//add by zy 0113
	var encmeth=GetElementValue("GetOneTree");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',val[1]);
	var list=gbldata.split("^");
	SetElement("Hold1Code",list[1]);
}

//add by jdl 2009-9-12 JDL0029
function Hold1Desc_Click()
{
	var CatName=GetElementValue("Hold1Desc")
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCTree&TreeType=1&Type=SelectTree&CatName="+CatName;  //hisui���� modify by lmm 2018-08-17
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

//add by csj 20190603	���������ݲ����Ƿ񵯴�
function initCatLookUp()
{
	// MZY0032		2020-06-09	�޸����Ӵ������
	singlelookup("Cat","EM.L.EquipCat",[{name:"Desc",type:1,value:"Cat"},{name:"EquipTypeDR",type:4,value:"EquipTypeDR"},{name:"StatCatDR",type:4,value:"StatCatDR"},{"name":"EditFlag","type":"2","value":"1"}],CatDR)
	/*var CatShow=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990052")	//�Ƿ��´��ڴ򿪷�����
	$('#Cat').lookup({
		onBeforeShowPanel:function (){
			if(!+CatShow){	//modified by csj 20190610 ����ȡ��
				EquiCat_Click()
				return false
			}
			return true
		}
	})*/
}
//���������ӹؼ����б�����ѡ���豸����  
//add by jyp 2019-09-02 �豸������ص���
$(function(){
	var result=""
	var string=[{text:'',id:''}]
	if (GetElementValue("EquipAttributeFlag")=="")
	{
		jsonData=tkMakeServerCall("web.DHCEQCMasterItem","ReturnJsonEquipAttribute")
		jsonData=jQuery.parseJSON(jsonData);
		var string=eval('(' + jsonData.Data+ ')');		
		
	}
	
        $("#EquipAttributeList").keywords({
            items:[{
                text:"�豸����",
                type:"chapter",
                items:string
            }]
        });
})
//Add by jyp 2019-09-02 �豸������ص���
//���ڴ���ѡ���豸�����ʾ��Ӧ���豸����
//��Σ�TRowID �豸��id
function SetEquipAttribute(TRowID)
{
	CodeString=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","GetOneEquipAttribute","1",TRowID)
	list=CodeString.split("^");
	var i=list.length;
	$("#EquipAttributeList").keywords("clearAllSelected")
	if(CodeString!="")
	{	
		for (var j=0;j<i;j++)
		{
			$("#EquipAttributeList").keywords("select",list[j]);
		}
	}
}
//add by csj 20190809 �������豸��id����渳ֵ
function initMasterItem()
{
	var searchArr = window.location.search.substring(1).split("&")
	var ItemDR=""
	for (var i=0;i<searchArr.length;i++) {
       var pair = searchArr[i].split("=");
       if(pair[0] == "MasterItemDR"){
//           return pair[1];
			 ItemDR = pair[1]
       }
    }
    if(ItemDR) {
	    SetData(ItemDR)
	    disabled(false)//���һ�
	    setTimeout(function(){
		   $('#tDHCEQCMasterItem').datagrid('load',{ComponentID:getValueById("GetComponentID"),Code:getValueById("Code"),Desc:getValueById("Desc"),Remark:getValueById("Remark"),EquipTypeDR:getValueById("EquipTypeDR"),EquipType:getValueById("EquipType"),CatDR:getValueById("CatDR"),Cat:getValueById("Cat"),StatCatDR:getValueById("StatCatDR"),StatCat:getValueById("StatCat"),UnitDR:getValueById("UnitDR"),Unit:getValueById("Unit"),Hold2:getValueById("Hold2"),Hold1:getValueById("Hold1"),Hold1Code:getValueById("Hold1Code"),Hold1Desc:getValueById("Hold1Desc")})
		},500)
		websys_showModal("options").mth();
	

	}
	initKeywords();
}
//add by wl 2020-02-18 WL0051
function initKeywords()
{
	if(getElementValue("EquipAttributeString")!="")
	{ 
		var arr=new Array()
		var  CurData=getElementValue("EquipAttributeString");
		var SplitNumCode=GetElementValue("SplitNumCode");
		arr= CurData.split(SplitNumCode);
		for(var i=0 ;i <arr.length;i++)
		{ 
			$("#EquipAttributeList").keywords("select",arr[i])
		}
	}
 }	
 //add by wl 2020-02-18 WL0051
function getKeywordsData()
{ 
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var EquipAttributeString=""
	for (var j=0;j<SelectType.length;j++)
	{
		if(EquipAttributeString=="")
		{
			EquipAttributeString=SelectType[j].id
		}else
		{
			EquipAttributeString=EquipAttributeString+GetElementValue("SplitNumCode")+SelectType[j].id
		}
	}
	return EquipAttributeString;
	
}
// MZY0030	1340074		2020-06-01
function clearData()
{

}
document.body.style.padding="10px 10px 10px 5px"  // hisui-���� add by kdf 2018-11-09 ��������ڱ߾� 
document.body.onload = BodyLoadHandler;
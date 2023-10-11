/// DHCEQCertificateInfoNew.js
//modified by czf 20180827 HISUI改造
var SelectedRow = -1;
var rowid=0;

function BodyLoadHandler() 
{
	//modified by cjt 20230212 需求号3221988 UI页面改造
	initPanelHeaderStyle();
	initButtonColor();
	hidePanelTitle();
	var Request = new Object();
	Request = GetRequest();
	var SourceType,SourceDesc;
	SourceType=Request["SourceType"];     //需求号：371907 2017-05-08 by mwz 
	SourceDesc=GetElementValue("SourceDesc");	//modified by czf 20180827 HISUI改造 Request方式获取汉字乱码
	SourceID=Request["SourceID"];
	SetElement("SourceType",SourceType);
	SetElement("SourceDesc",SourceDesc);
	SetElement("SourceID",SourceID);
	SetElement("Level",GetElementValue("LevelID"));        //modified by czf 
	InitMessage();			//20140228  Mozy0120
	InitButton(false);
	initButtonWidth();	//modified by czf 20180827 HISUI改造
	KeyUp("SourceDesc^CertificateType","N");
	Muilt_LookUp("SourceDesc^CertificateType");
}

function InitButton(isselected)
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BPicture");
	if (obj) obj.onclick=BPicture_Click;
	var obj=document.getElementById("SourceType");
	if (obj) obj.onchange=SourceType_change;
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iSourceDesc");
	if (obj) obj.onclick=BSourceDesc_Click;
	var obj=document.getElementById("BFind")    //modified by czf 
	if (obj) obj.onclick=BFind_Click;
	
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	DisableBElement("BDisuse",!isselected);
	DisableBElement("BPicture",!isselected);
}
function Clear()
{
	SetElement("RowID","");
	//SetElement("SourceType","");     //modified by czf 399195
	//SetElement("SourceDesc","");
	//SetElement("SourceID","");
	SetElement("CertificateType","");
	SetElement("CertificateTypeDR","");
	SetElement("No","");
	SetElement("Level","");
	SetElement("CertificateDept","");
	SetElement("CertificateDate","");
	SetElement("AvailableDate","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
//modified by czf 需求号：335873
function BFind_Click()
{
	var val="&SourceID="+GetElementValue("SourceID");
	val=val+"&SourceDesc="+GetElementValue("SourceDesc");
	val=val+"&CertificateType="+GetElementValue("CertificateType")
	val=val+"&No="+GetElementValue("No")
	val=val+"&Level="+GetElementValue("Level")
	val=val+"&CertificateDept="+GetElementValue("CertificateDept")
	val=val+"&CertificateDate="+GetElementValue("CertificateDate")
	val=val+"&AvailableDate="+GetElementValue("AvailableDate")
	val=val+"&Remark="+GetElementValue("Remark")
	val=val+"&SourceType="+GetElementValue("SourceType");   //modified by czf 399195
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCertificateInfoNew"+val;
}
function BUpdate_Click() 
{
	if (CheckMustItemNull()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,plist,"0");
	if (result>0)
	{	location.reload();	}
	else
	{
		if (result=="-3003"){	//czf 2261290
			messageShow("","","",t['-3003']);
		}else{
			alertShow("SQLCODE="+result);
		}
	}
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		messageShow("","","",t['-3002']);
		return;
	}
	var truthBeTold = window.confirm(t['-3001']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid+"^"+"",'1');
	//messageShow("","","",result)
	if (result>0)
	{	location.reload();	}
}
//modified by csj 20190301 改为新图片上传界面模态窗
function BPicture_Click()
{
	var SourceType=GetElementValue("SourceType")   //modified by czf 399195
	if ((SourceType==2)||(SourceType==5))		//modified by czf 20200404
	{
		var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=63-1&CurrentSourceID='+GetElementValue("RowID")+'&Status=0';
	}
	else if (SourceType==3)
	{
		var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=63-2&CurrentSourceID='+GetElementValue("RowID")+'&Status=0';
	}
	var title="图片信息"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(str,title,width,height,icon,showtype,"","","middle")  //modify by lmm 2020-06-05 UI
}
function BClose_Click()
{
	//window.close();
	CloseWindow();
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("SourceType");
  	combindata=combindata+"^"+GetElementValue("SourceID");
  	combindata=combindata+"^"+GetElementValue("CertificateTypeDR");
  	combindata=combindata+"^"+GetElementValue("No");
  	combindata=combindata+"^"+GetElementValue("Level");
  	combindata=combindata+"^"+GetElementValue("CertificateDept");
  	combindata=combindata+"^"+GetElementValue("CertificateDate");
  	combindata=combindata+"^"+GetElementValue("AvailableDate");
  	combindata=combindata+"^"+GetElementValue("Remark");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
	
  	return combindata;
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow("元素空值");
		return;
	}
	var sort=18;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	//messageShow("","","",gbldata)
	SetElement("SourceType",list[0]);
	SetElement("SourceID",list[1]);
	SetElement("SourceDesc",list[sort+0]);
	SetElement("CertificateTypeDR",list[2]);
	SetElement("CertificateType",list[sort+1]);
	SetElement("No",list[3]);
	SetElement("Level",list[4]);
	SetElement("CertificateDept",list[5]);
	SetElement("CertificateDate",list[6]);
	SetElement("AvailableDate",list[7]);
	SetElement("Remark",list[8]);
	SetElement("Hold1",list[13]);
	SetElement("Hold2",list[14]);
	SetElement("Hold3",list[15]);
	SetElement("Hold4",list[16]);
	SetElement("Hold5",list[17]);
}
//modified by czf 20180827 HISUI改造
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)
	{
		Clear();
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID;
		if (rowid=="") return;
		SetElement("RowID",rowid);
		SetData(rowid);
		InitButton(true);
	}
}
function GetCertificateType(value)
{
	GetLookUpID("CertificateTypeDR",value);
}

function SourceType_change()
{
	//SetElement("ExTypeDR",GetElementValue("ExType"));
	//changeSourceDesc();
	SetElement("SourceID","");
	SetElement("SourceDesc","");
}
function BSourceDesc_Click()
{	
	var value=GetElementValue("SourceType");
	if (value=="0")
	{
		LookUp("","web.DHCEQFind:EQUser","GetSourceID",",SourceDesc");
	}
	else if (value=="1")
	{
		LookUp("","web.DHCEQCVendor:GetVendor","GetSourceID","SourceDesc");
	}
	else if (value=="2")
	{
		LookUp("","web.DHCEQCManufacturer:LookUp","GetSourceID","SourceDesc");		
	}
}
function GetSourceID(value) 
{
	//messageShow("","","",value)
	var list=value.split("^");
	SetElement('SourceDesc',list[0]);
	SetElement('SourceID',list[1]);
}
//2015-12-15  JYP
//获取url中"?"符后的字串
function GetRequest() {
  
  var url = location.search;
   var theRequest = new Object();
   if (url.indexOf("?") != -1) {
      var str = url.substr(1);
      strs = str.split("&");
      for(var i = 0; i < strs.length; i ++) {
         theRequest[strs[i].split("=")[0]]=(strs[i].split("=")[1]);
      }
   }
   return theRequest;
}
document.body.onload = BodyLoadHandler;

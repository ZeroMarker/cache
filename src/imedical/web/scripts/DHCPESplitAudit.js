//ҳ���ʼ��
function BodyLoadHandler()
{
	InitPage();
	FillData();
	initSplitType();
}

function InitPage()
{
	InitPrivilegeMode("privilegeMode");
	InitPrivilegeMode("ToprivilegeMode");
	InitType("Type");
	InitType("ToType");
	var obj=document.getElementById("MoveToR");
	if (obj) obj.onclick=MoveToR_clicked;
	var obj=document.getElementById("MoveToL");
	if (obj) obj.onclick=MoveToL_clicked;
	var obj=document.getElementById("SelectR");
	if (obj) obj.onclick=SelectR_clicked;
	var obj=document.getElementById("SelectA");
	if (obj) obj.onclick=SelectA_clicked;
	var obj=document.getElementById("SelectFX");
	if (obj) obj.onclick=SelectFX_clicked;
	var obj=document.getElementById("ARCIMDesc");
	if (obj) obj.onchange=ARCIMDesc_change;
	var obj=document.getElementById("txtItemSetDesc");
	if (obj) obj.onchange=txtItemSetDesc_change;
	
}
function SelectFX_clicked()
{
	Select("FX");
}
function SelectR_clicked()
{
	Select("R");
}
function SelectA_clicked()
{
	Select("A");
}

function Select(Type)
{
	var obj=parent.frames["TwoFeeList"];
	if (obj)
	{
		obj=obj.frames["LeftFeeList"];
		if (obj)
		{
			SelectApp(obj,Type);
		}
		
	}
}
function SelectApp(obj,Type)
{
	var eSrc = window.event.srcElement;	
	var obj=obj.document;
	var objtbl=obj.getElementById('tDHCPEFeeListNew');
	if (!objtbl) return;
	var rows=objtbl.rows.length;
	var RowIDs="";
	for (i=1;i<=rows;i++)
	{
		var objChk=obj.getElementById('TCheckedz'+i);
		if (!objChk) continue;
		var objStatus=obj.getElementById('TItemNamez'+i);
		var Status=""
		if (objStatus) Status=objStatus.innerText;
		if ((Type=="A")&&(Status=="ARRIVED")) objChk.checked=eSrc.checked;
		if ((Type=="R")&&(Status=="REGISTERED")) objChk.checked=eSrc.checked;
		if (Type=="FX") objChk.checked=!objChk.checked;
		if (objChk.checked)
		{
			var itemfeeid=obj.getElementById("TRowIdz"+i).value;
			var itemfeetype=obj.getElementById("TFeeTypez"+i).value;
			var itemfeeinfos="";
			if ((""!=itemfeeid)&&(""!=itemfeetype)) itemfeeinfos=itemfeeid+","+itemfeetype;
			if((""!=itemfeeid)&&(""==itemfeetype)) itemfeeinfos=itemfeeid;
			if (RowIDs=="") RowIDs=RowIDs+"^"		
			RowIDs=RowIDs+itemfeeinfos+"^";
		}
	}
	obj.getElementById("SelectRows").value=RowIDs;
	
	
}
///��ʼ���Żݷ�ʽ
function InitPrivilegeMode(name)
{
	var obj=document.getElementById(name);
	if (obj) {
		obj.multiple=false;
		obj.size=1
		var NewIndex=obj.length;
		obj.options[0] = new Option("���Ż�","NP");
		//obj.options[1] = new Option("�ܼ��Ż�","TP");
		obj.options[1] = new Option("�ۿ�","OR");
		obj.options[2] = new Option("��Ŀ�Ż�","OP");
	}
}

///��ʼ������
function InitType(name)
{
	var obj=document.getElementById(name);
	if (obj) {
		obj.multiple=false;
		obj.size=1
		obj.options[0] = new Option("ԤԼ","PRE");
		obj.options[1] = new Option("����","ADD");
	}
}

function MoveToR_clicked()
{
	alert('a');
}

function MoveToL_clicked()
{
	alert('b');
}

///���ݱ�ṹ����һ������
function FillData()
{
	var data="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	var data1=data;
	var auditId=GetEValue("AuditID");
	var toAuditID=GetEValue("ToAuditID");
	if (""!=auditId)
	{
		var encmeth=GetEValue("fillData");
		data=cspRunServerMethod(encmeth,auditId);
		data=auditId+"^"+data;
		if (""!=toAuditID)
		{
			data1=cspRunServerMethod(encmeth,toAuditID);
			data1=toAuditID+"^"+data1;
		}		
	}
	
	var data=data.split("^");
	var data1=data1.split("^");
	var Name="RowID^ADMType^CRMADM^GIADM^ContractNo^Rebate^AccountAmount^DiscountedAmount^SaleAmount^FactAmount^AuditedStatus"
	Name=Name+"^AuditUser_DR^AuditDate^AuditTime^ChargedStatus^CancelUser_DR^CancelDate^CancelTime^Remark^PrivilegeMode^Type"
	Name=Name.split("^");
	var i,j;
	j=Name.length;
	for (i=0;i<j;i++)
	{
		SetValue(Name[i],data[i]);
		SetValue("To"+Name[i],data1[i]);
	}	
}

function SetValue(Name,Value)
{
	var obj=document.getElementById(Name);
	if (obj) obj.value=Value;
}

function GetEValue(Name)
{
	var rtn="";	
	var obj=document.getElementById(Name);	
	if (obj) rtn=obj.value;
	return trim(rtn);
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
///creator:wangfujian
///createDate:2009-05-22
///description:��ʼ�����ѡ���?ADM����Ϊ����ʱ?��ʾ�������ѡ���
function initSplitType(){
	
	var obj =document.getElementById("ADMType");
	if (obj){
		var SplitType=obj.value;
		if(SplitType="G"){
			//ֻ������?����ʾ�������ѡ���
			var obj=document.getElementById("dDHCPESplitAudit");
			if(obj){
				var lable=CreateElementByTagName("Lable");
				
				lable.style.size="24";
				lable.innerText="��ѡ���ַ�ʽ";
				var splitTypeObj=CreateElementByTagName("select","SplitType","SplitType");
				splitTypeObj.style.width="100"
				splitTypeObj.style.heigth="50"
				addSelectOption(splitTypeObj,"item","��Ŀ");
				addSelectOption(splitTypeObj,"person","��Ա");
				addSelectOption(splitTypeObj,"group","����")
				obj.appendChild(lable);
				splitTypeObj.onchange=splitTypeChanged;
  				obj.appendChild(splitTypeObj);  
  				//����Ĭ��ѡ��
  			 	obj=document.getElementById("SplitType")
  			 	if(obj){
	  			 	var SplitType=obj.value;
	  			 	if(SplitType=="item") splitTypeObj.selectedIndex=0;
	  			 	if(SplitType=="person") splitTypeObj.selectedIndex=1;
	  			 	if(SplitType=="group") splitTypeObj.selectedIndex=2;
  			 	}
  		
			}
		}
	}
}
///creator:wangfujian
///createDate:2009-05-22
///description:��������������һ��Ԫ��
function splitTypeChanged(){
	var obj="";
	var splitType="";
	var AuditID="";
	var AuditID="";
	var src=window.event.srcElement;
	var index=src.selectedIndex
	splitType = src.options[index].value;
	
	obj=document.getElementById("AuditID");
	AuditID=obj.value;
	
	obj=document.getElementById("ToAuditID");
	ToAuditID=obj.value;
	
	var ARCIMID="",OrdSetID="";
	obj=document.getElementById("ARCIMID");
	if (obj) ARCIMID=obj.value;
	obj=document.getElementById("txtItemSetId");
	if (obj) OrdSetID=obj.value;
	
	CurSplitType=splitType;
	
	parent.frames["TwoFeeList"].location.href="dhcpe2feelist.csp?AuditID="+AuditID+"&ToAuditID="+ToAuditID+"&SplitType="+CurSplitType+"&ARCIMID="+ARCIMID+"&OrdSetID="+OrdSetID
	
}
///creator:wangfujian
///createDate:2009-05-22
///description:��������������һ��Ԫ��
function CreateElementByTagName(TagName,Id,Name){
	//����   
	var obj = document.createElement(TagName);
	obj.id=Id;
	obj.name=Name
	return obj;
}
///creator:wangfujian
///createDate:2009-05-22
///description:��ѡ������Ԫ��?�Ͷ�Ӧ��ѡ�񴥷�����
function addSelectOption(selectObj,value,text){
	
	//ʹ�ô���Ķ�����ѡ�����͵Ķ���������
	if(selectObj&&selectObj.tagName=="SELECT"){
		var objOption = CreateElementByTagName("OPTION");
		objOption.value=value;
     	objOption.text=text ;
     	selectObj.options.add(objOption);
	}
	    
}
function ARCIMSelect(value)
{
	if (value=="") return false;
	var obj,AuditID="",ToAuditID="",ARCIMID="";
	obj=document.getElementById("ARCIMID");
	if (obj) obj.value=value.split("^")[2];
	obj=document.getElementById("ARCIMDesc");
	if (obj) obj.value=value.split("^")[1];
	
	obj=document.getElementById("AuditID");
	AuditID=obj.value;
	
	obj=document.getElementById("ToAuditID");
	ToAuditID=obj.value;
	
	obj=document.getElementById("ARCIMID");
	if (obj) ARCIMID=obj.value;
	//CurSplitType=splitType;
	parent.frames["TwoFeeList"].location.href="dhcpe2feelist.csp?AuditID="+AuditID+"&ToAuditID="+ToAuditID+"&SplitType="+CurSplitType+"&ARCIMID="+ARCIMID
}
function ARCIMDesc_change()
{
	var obj;
	obj=document.getElementById("ARCIMID");
	if (obj) obj.value="";
}
function SelectItemSet(value)
{
	if (value=="") return false;
	var obj,AuditID="",ToAuditID="",OrdSetID="";
	obj=document.getElementById("txtItemSetId");
	if (obj) obj.value=value.split("^")[2];
	obj=document.getElementById("txtItemSetDesc");
	if (obj) obj.value=value.split("^")[1];
	
	obj=document.getElementById("AuditID");
	AuditID=obj.value;
	
	obj=document.getElementById("ToAuditID");
	ToAuditID=obj.value;
	
	obj=document.getElementById("txtItemSetId");
	if (obj) OrdSetID=obj.value;
	//CurSplitType=splitType;
	parent.frames["TwoFeeList"].location.href="dhcpe2feelist.csp?AuditID="+AuditID+"&ToAuditID="+ToAuditID+"&SplitType="+CurSplitType+"&OrdSetID="+OrdSetID
}
function txtItemSetDesc_change()
{
	var obj;
	obj=document.getElementById("txtItemSetId");
	if (obj) obj.value="";
}
document.body.onload = BodyLoadHandler;
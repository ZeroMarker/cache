/// ypp
/// ��Ҫ����:VIP�ͻ��ȼ�ά��
/// DHCPEVIPLevel.js

var CurRow=0
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("Add");
	if (obj){ obj.onclick=Add_click; }
	obj=document.getElementById("BCreateGlobal");
	if (obj){ obj.onclick=BCreateGlobal_click; }
	obj=document.getElementById("OrdSetsDesc");
	if (obj){ obj.onchange=OrdSetsDesc_change; }
	
	//����
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
}

function Clear_click()
{
	var obj;
	
	//���� 
	obj=document.getElementById("Level");
	if(obj){obj.value="";}
	
	//����
	obj=document.getElementById("Desc");
	if(obj){obj.value="";}
	
	//ģ������
	obj=document.getElementById("Template");
	if(obj){obj.value="";}
	
	//Ĭ��
	var obj=document.getElementById("IsApprove");
	if(obj){obj.checked=false;}
	
	//����
	var obj=document.getElementById("IsSecret");
	if(obj){obj.checked=false;}
	
	//ʹ��
	var obj=document.getElementById("IsUse");
	if(obj){obj.checked=false;}
	
	//���ű���
	obj=document.getElementById("HPCode");
	if(obj){obj.value="";}
	
	//�ײʹ���
	obj=document.getElementById("SetCode");
	if(obj){obj.value="";}
	
	//������
	obj=document.getElementById("PatFeeType_DR_Name");
	if(obj){obj.value="";}
	
	//csp�ļ�
	obj=document.getElementById("cspfile");
	if(obj){obj.value="";}

	//ָ������ʾ
	obj=document.getElementById("ZYDInfo");
	if(obj){obj.value="";}
	
	//ָ����ģ��
	obj=document.getElementById("ZYDTemplate");
	if(obj){obj.value="";}

	//�ʾ���񼶱����
	obj=document.getElementById("HMService");
	if(obj){obj.value="";}

} 

function OrdSetsDesc_change()
{
	var obj=document.getElementById("OrdSetsDR");
	if (obj) obj.value="";
}
function GetItemSet(value)
{
	if (value=="") return false;
	var StrArr=value.split("^");
	var obj=document.getElementById("OrdSetsDR");
	if (obj) obj.value=StrArr[0];
	obj=document.getElementById("OrdSetsDesc");
	if (obj)obj.value=StrArr[1];
}
function BCreateGlobal_click()
{
	var RCTotal="";
	var obj=document.getElementById("RCTotal");
	if (obj) RCTotal=obj.value;
	if (RCTotal==""){
		alert("����������20*10��ʽ����*����ֵ");
		return false;
	}
	var RCArr=RCTotal.split("*")
	if (RCArr.length!=2){
		alert("����������20*10��ʽ����*����ֵ");
		return false;
	}
	
	
	var OpenFile = new ActiveXObject("MSComDlg.CommonDialog")   
  	OpenFile.Filter="Excel�ļ�|*.xls";
  	OpenFile.MaxFileSize=260;
  	
  	OpenFile.ShowOpen();
  	Template=OpenFile.FileName;
  	/*
  	var Template="D:\\DHCPEWHYYSeafarersReport.xls";
  	*/
	if (Template=="") return "";
	//Template="d:\\��������ģ��.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.WorkSheets("Sheet1");
	
	var Row=RCArr[0];
	var Col=RCArr[1];
	var char_1=String.fromCharCode(1);
	var char_2=String.fromCharCode(2);
	var SetInfo="";
	for (i=1;i<=Row;i++)
	{
		for (j=1;j<=Col;j++)
		{
			try{
			var Value=xlsheet.cells(i,j).Value;
			if ((Value=="")||(Value==null)) continue;
			if (Value.split("^").length>1)
			{
				var OneInfo=i+";"+j+char_2+Value;
				if (SetInfo=="")
				{
					SetInfo=OneInfo;
				}
				else
				{
					SetInfo=SetInfo+char_1+OneInfo;
				}
			}
			}catch(e){
				continue;
			}
		}
	}
	if (SetInfo=="")
	{
		alert("û������ģ������");
		return false;
	}
	var iTemplate="";
	var obj=document.getElementById("Template");
	if (obj){iTemplate=obj.value; }
	if (iTemplate==""){
		alert("û������ģ������");
		return false;
	}
	var ret=tkMakeServerCall("web.DHCPE.VIPLevel","SetTemplateGlobal",iTemplate,SetInfo);
	alert(ret);
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function Clear() {
	var obj;
	
    //ID 
	var obj=document.getElementById("ID");
	if (obj) obj.value=""
	
	//�ȼ� 
	var obj=document.getElementById("Level");
	if (obj) obj.value="" 
	
	//�ײʹ���
	var obj=document.getElementById("SetCode");
	if (obj) obj.value="" 
    
    //���Ŵ���
	var obj=document.getElementById("HPCode");
	if (obj) obj.value="" 
	
    //����
	var obj=document.getElementById("Desc");
	if (obj) obj.value=""
    
    //�Ƿ���
    var obj=document.getElementById("IsSecret");
	if (obj) obj.checked=false
    
    //�Ƿ�ʹ��
    var obj=document.getElementById("IsUse");
	if (obj) obj.checked=false
	
	//�Ƿ�Ĭ��
    var obj=document.getElementById("IsApprove");
	if (obj) obj.checked=false
	var obj=document.getElementById("cspfile");
	obj.value=""
	
}

function Add_click() {
	var iLevel="", iDesc="",iIsSecret="",iIsUse="",iIsApprove="",iID="",iTemplate="",iFeeType="",iSetCode="",iHPCode="",icspfile="",IsApprove="";
	var OrdSetsDR="",ZYDInfo="",ZYDTemplate="";

	//ID 
	var obj=document.getElementById("ID");
	if (obj){iID=obj.value; } 
	
	
	//�ȼ� 
	var obj=document.getElementById("Level");
	if (obj){iLevel=obj.value; } 

    //����
	var obj=document.getElementById("Desc");
	if (obj){iDesc=obj.value; } 
	if (""==iDesc) {
            obj=document.getElementById("Desc")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("��������Ϊ��");
		return false;

	}

    
    //�Ƿ���
    var obj=document.getElementById("IsSecret");
	if (obj.checked){iIsSecret="Y"; } 
    else{iIsSecret="N"; }
    
    //�Ƿ�ʹ��
    var obj=document.getElementById("IsUse");
	if (obj.checked){iIsUse="Y"; } 
	else{iIsUse="N"; }
	
	//�Ƿ�Ĭ��
    var obj=document.getElementById("IsApprove");
	if (obj.checked){iIsApprove="Y"; } 
	else{iIsApprove="N"; }
	
	//ģ��
	var obj=document.getElementById("Template");
	if (obj){iTemplate=obj.value; }
	
	var obj=document.getElementById("PatFeeType_DR_Name");
	if (obj){iFeeType=obj.value; }
	//�ײʹ���
	var obj=document.getElementById("SetCode");
	if (obj){iSetCode=obj.value; }
	if (""==iSetCode) {
            obj=document.getElementById("SetCode")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("�ײͱ��벻��Ϊ��");
		return false;

	}

	//���Ŵ���
	var obj=document.getElementById("HPCode");
	if (obj){iHPCode=obj.value; }
	if (""==iHPCode) {
            obj=document.getElementById("HPCode")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("���ű��벻��Ϊ��");
		return false;

	}

	
	var obj=document.getElementById("cspfile");
	if (obj){icspfile=obj.value; }
	
	var obj=document.getElementById("OrdSetsDR");
	if (obj){OrdSetsDR=obj.value; }
	var obj=document.getElementById("ZYDInfo");
	if (obj){ZYDInfo=obj.value; }
	var obj=document.getElementById("ZYDTemplate");
	if (obj){ZYDTemplate=obj.value; }
	var obj=document.getElementById("HMService");
	if (obj){HMService=obj.value; }

	var Instring=trim(iLevel)		
		    +"^"+trim(iDesc)
		    +"^"+trim(iIsSecret)
		    +"^"+trim(iIsUse) 		
            +"^"+trim(iIsApprove)				
            +"^"+trim(iID)
            +"^"+trim(iTemplate)
			+"^"+trim(iFeeType)
			+"^"+trim(iSetCode)
			+"^"+trim(iHPCode)
			+"^"+trim(icspfile)
			+"^"+trim(OrdSetsDR)
			+"^"+trim(ZYDInfo)
			+"^"+trim(ZYDTemplate)
			+"^"+trim(HMService)
			;
			
	var obj=document.getElementById("TIsApprovez"+CurRow);
	if (obj&&obj.checked){var IsApprove="Y"; } 
	else{var IsApprove="N"; }
	
	var ret=tkMakeServerCall("web.DHCPE.VIPLevel","GetVipApprove");
	if((IsApprove=="N")&&(iIsApprove=="Y")&&(ret=="1"))
	 {
	   alert("Ĭ��ֵ������,�����ظ�����");
	    return false;
    
	}
	


	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
    if (flag==0)  
    {
		window.location.reload();   	 
	}
	
      
}

	
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEVIPLevel');	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		CurRow=0      
	    Clear()
	}
	else
	{
		CurRow=Row;
	}
	
	
	var obj=document.getElementById("TIDz"+CurRow)
	var objLevel=document.getElementById("ID")
	if (objLevel)  objLevel.value=obj.value;
	
    var obj=document.getElementById("TLevelz"+CurRow)
	var objLevel=document.getElementById("Level")
	if (objLevel)  objLevel.value=obj.innerText;

    var obj=document.getElementById("TDescz"+CurRow)
    var objDesc=document.getElementById("Desc")
	if (objDesc)  objDesc.value=obj.innerText;
    
    var obj=document.getElementById("TIsSecretz"+CurRow)
    var objDesc=document.getElementById("IsSecret")
	if (objDesc)  objDesc.checked=obj.checked;
	
	var obj=document.getElementById("TIsUsez"+CurRow)
    var objDesc=document.getElementById("IsUse")
	if (objDesc)  objDesc.checked=obj.checked;
	
	var obj=document.getElementById("TIsApprovez"+CurRow)
    var objDesc=document.getElementById("IsApprove")
	if (objDesc)  objDesc.checked=obj.checked;
	
	var obj=document.getElementById("TTemplatez"+CurRow)
    var objDesc=document.getElementById("Template")
	if (objDesc) objDesc.value=obj.innerText;
	
	var obj=document.getElementById("TFeeTypeDRz"+CurRow)
    var objDesc=document.getElementById("PatFeeType_DR_Name")
	if (objDesc) objDesc.value=obj.value;
	var obj=document.getElementById("TSetCodez"+CurRow)
    var objDesc=document.getElementById("SetCode")
	if (objDesc) objDesc.value=obj.innerText;
	var obj=document.getElementById("THPCodez"+CurRow)
    var objDesc=document.getElementById("HPCode")
	if (objDesc) objDesc.value=obj.innerText;
	var obj=document.getElementById("Tcspfilez"+CurRow)
	
    var objDesc=document.getElementById("cspfile")
	if (objDesc) objDesc.value=obj.innerText;
	
	var obj=document.getElementById("TOrdSetsDRz"+CurRow)
	var objDesc=document.getElementById("OrdSetsDR")
	if (objDesc) objDesc.value=trim(obj.value);
	
	var obj=document.getElementById("TOrdSetsDescz"+CurRow)
	var objDesc=document.getElementById("OrdSetsDesc")
	if (objDesc) objDesc.value=trim(obj.innerText);
	
	var obj=document.getElementById("TZYDInfoz"+CurRow)
	var objDesc=document.getElementById("ZYDInfo")
	if (objDesc) objDesc.value=trim(obj.innerText);
	
	var obj=document.getElementById("TZYDTemplatez"+CurRow)
	var objDesc=document.getElementById("ZYDTemplate")
	if (objDesc) objDesc.value=trim(obj.innerText);

	var obj=document.getElementById("THMServiceDRz"+CurRow)
	var objDesc=document.getElementById("HMService")
	if (objDesc) objDesc.value=obj.value;

}	

document.body.onload = BodyLoadHandler;
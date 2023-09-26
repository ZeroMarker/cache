/// ypp
/// 主要功能:VIP客户等级维护
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
	
	//清屏
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
}

function Clear_click()
{
	var obj;
	
	//级别 
	obj=document.getElementById("Level");
	if(obj){obj.value="";}
	
	//描述
	obj=document.getElementById("Desc");
	if(obj){obj.value="";}
	
	//模板名称
	obj=document.getElementById("Template");
	if(obj){obj.value="";}
	
	//默认
	var obj=document.getElementById("IsApprove");
	if(obj){obj.checked=false;}
	
	//保密
	var obj=document.getElementById("IsSecret");
	if(obj){obj.checked=false;}
	
	//使用
	var obj=document.getElementById("IsUse");
	if(obj){obj.checked=false;}
	
	//体检号编码
	obj=document.getElementById("HPCode");
	if(obj){obj.value="";}
	
	//套餐代码
	obj=document.getElementById("SetCode");
	if(obj){obj.value="";}
	
	//体检类别
	obj=document.getElementById("PatFeeType_DR_Name");
	if(obj){obj.value="";}
	
	//csp文件
	obj=document.getElementById("cspfile");
	if(obj){obj.value="";}

	//指引单提示
	obj=document.getElementById("ZYDInfo");
	if(obj){obj.value="";}
	
	//指引单模板
	obj=document.getElementById("ZYDTemplate");
	if(obj){obj.value="";}

	//问卷服务级别代码
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
		alert("请输入类似20*10格式的行*列数值");
		return false;
	}
	var RCArr=RCTotal.split("*")
	if (RCArr.length!=2){
		alert("请输入类似20*10格式的行*列数值");
		return false;
	}
	
	
	var OpenFile = new ActiveXObject("MSComDlg.CommonDialog")   
  	OpenFile.Filter="Excel文件|*.xls";
  	OpenFile.MaxFileSize=260;
  	
  	OpenFile.ShowOpen();
  	Template=OpenFile.FileName;
  	/*
  	var Template="D:\\DHCPEWHYYSeafarersReport.xls";
  	*/
	if (Template=="") return "";
	//Template="d:\\导入团体模版.xls"
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
		alert("没有设置模板内容");
		return false;
	}
	var iTemplate="";
	var obj=document.getElementById("Template");
	if (obj){iTemplate=obj.value; }
	if (iTemplate==""){
		alert("没有设置模板名称");
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
	
	//等级 
	var obj=document.getElementById("Level");
	if (obj) obj.value="" 
	
	//套餐代码
	var obj=document.getElementById("SetCode");
	if (obj) obj.value="" 
    
    //体检号代码
	var obj=document.getElementById("HPCode");
	if (obj) obj.value="" 
	
    //描述
	var obj=document.getElementById("Desc");
	if (obj) obj.value=""
    
    //是否保密
    var obj=document.getElementById("IsSecret");
	if (obj) obj.checked=false
    
    //是否使用
    var obj=document.getElementById("IsUse");
	if (obj) obj.checked=false
	
	//是否默认
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
	
	
	//等级 
	var obj=document.getElementById("Level");
	if (obj){iLevel=obj.value; } 

    //描述
	var obj=document.getElementById("Desc");
	if (obj){iDesc=obj.value; } 
	if (""==iDesc) {
            obj=document.getElementById("Desc")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("描述不能为空");
		return false;

	}

    
    //是否保密
    var obj=document.getElementById("IsSecret");
	if (obj.checked){iIsSecret="Y"; } 
    else{iIsSecret="N"; }
    
    //是否使用
    var obj=document.getElementById("IsUse");
	if (obj.checked){iIsUse="Y"; } 
	else{iIsUse="N"; }
	
	//是否默认
    var obj=document.getElementById("IsApprove");
	if (obj.checked){iIsApprove="Y"; } 
	else{iIsApprove="N"; }
	
	//模板
	var obj=document.getElementById("Template");
	if (obj){iTemplate=obj.value; }
	
	var obj=document.getElementById("PatFeeType_DR_Name");
	if (obj){iFeeType=obj.value; }
	//套餐代码
	var obj=document.getElementById("SetCode");
	if (obj){iSetCode=obj.value; }
	if (""==iSetCode) {
            obj=document.getElementById("SetCode")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("套餐编码不能为空");
		return false;

	}

	//体检号代码
	var obj=document.getElementById("HPCode");
	if (obj){iHPCode=obj.value; }
	if (""==iHPCode) {
            obj=document.getElementById("HPCode")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("体检号编码不能为空");
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
	   alert("默认值已设置,不能重复设置");
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
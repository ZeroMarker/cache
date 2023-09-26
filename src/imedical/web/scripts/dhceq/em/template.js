
///记录当前模版对象
var ObjTemplate=new Array();
///记录 元素ID
var ObjElement=new Array();
///记录 元素分组对象
var ObjElementGroup=new Array();
///记录元素个数
var ElementNum=0
var GlobalObj = {
	SourceType : "",
	SourceID : "",
	ReadOnly : "",
	CurRole : "",
	Status : "",
	Action : "",
	BRLPriceFee : "",
	TemplateID : "",
	GetData : function()
	{
		this.SourceType = getElementValue("SourceType");
		this.SourceID = getElementValue("SourceID");
		this.ReadOnly = getElementValue("ReadOnly");
		this.CurRole = getElementValue("CurRole");
		this.Status = getElementValue("Status");
		this.Action = getElementValue("Action");
		this.BRLPriceFee = getElementValue("BRLPriceFee");
		if (this.Status>0) this.ReadOnly=1;
		var DataInfo=tkMakeServerCall("web.DHCEQTemplate","GetTemplate",GlobalObj.SourceType,GlobalObj.SourceID)
		if (DataInfo<0)
		{
			alertShow("没有定义模版!")
			return;
		}
		var list=DataInfo.split("@");
	    //模版对象
		ObjTemplate=new Template(list[0])
	    if (list[1]=="") return
	    var TemplateListInfo=list[1].split("&")
	    ElementNum=TemplateListInfo.length
		for (var i=0;i<ElementNum;i++)
		{
			var OneElement=TemplateListInfo[i];
			OneElement=OneElement.split("^");
			var ElementID=OneElement[2]
			ObjElement[i]=new Element(ElementID,OneElement)
			
			var GroupDR=ObjElement[i].GroupDR
			var Group=ObjElement[i].Group
			var GroupLen=ObjElementGroup.length
			//是否在已有的元素组中
			var FindFlag=0
			for (var j=0;j<GroupLen;j++)
			{
				if (ObjElementGroup[j].GroupDR==GroupDR)
				{
					ObjElementGroup[j].ElementIDs=ObjElementGroup[j].ElementIDs+","+i;
					FindFlag=1
				}
			}
			if (FindFlag==0)
			{
				ObjElementGroup[GroupLen]=new ElementGroup(GroupDR,Group,i)
			}
		}
	}
}

///add by zy 2017-4-6  ZY0162
///创建模版元素对象
///入参：itemID  	DHC_EQCCTemplate表的ID
///		 itemSetID  DHC_EQCComponentSetItem表的ID
///把取到的元素信息放在对象中。
function ElementGroup(GroupDR,Group,ElementIDs)
{
	this.GroupDR=GroupDR
	this.Group=Group
	this.ElementIDs=ElementIDs
}
///add by zy 2017-4-6  ZY0162
///创建模版元素对象
///入参：itemID  	DHC_EQCCTemplate表的ID
///		 itemSetID  DHC_EQCComponentSetItem表的ID
///把取到的元素信息放在对象中。
function Template(val)
{
	var list=val.split("^");
	this.ID=list[0];
	this.ItemDR=list[1];
	this.EquipDR=list[2];
	this.Name=list[3];
	this.Caption=list[4];
	this.Note=list[5];
	this.Remark=list[6];
	this.InvalidFlag=list[7];
	this.Hold1=list[8];
	this.Hold2=list[9];
	this.Hold3=list[10];
}

///add by zy 2017-4-6  ZY0162
///创建组件元素对象,及元素对象的html
///入参：ElementID  	元素ID
///		 CurElementInfo  元素在当前业务模版中的信息
///		 Num   元素在当前页面的元素数组ID
///把取到的元素信息放在对象中。
function Element(ElementID,CurElementInfo)
{
	if (CurElementInfo!="")
	{
		this.CTemplistID=CurElementInfo[0]
		this.CTemplateID=CurElementInfo[1]
		this.SettingValue=CurElementInfo[3]
		this.Key=CurElementInfo[4]
		this.Note=CurElementInfo[5]
		this.Sort=CurElementInfo[6]
		this.Repeat=CurElementInfo[7]
		this.MustFlag=CurElementInfo[8];	//MustFlag
		this.RoleDR=CurElementInfo[9];	//RoleDR
		this.Action=CurElementInfo[10];	//Action
	}
	else
	{
		this.CTemplistID="";
		this.CTemplateID="";
		this.SettingValue="";
		this.Key="";
		this.Note="";
		this.Sort="";
		this.Repeat="";
		this.MustFlag="" ;//MustFlag
		this.RoleDR="" ;//RoleDR
		this.Action=""	//Action
	}
	var list=tkMakeServerCall("web.DHCEQTemplate","GetElement",ElementID,ObjTemplate.ID)
    if (list=="")return;
	var list=list.split("^");
	this.ID=ElementID;
	this.ElementCatDR=list[0];
	this.Name=list[1];
	this.Note=list[2];
	this.ValueType=list[3];
	this.Reference=list[4];
	this.Qualitative=list[5];
	this.SettingFlag=list[6];
	this.CompositeFlag=list[7];
	this.GroupDR=list[8];
	this.Remark=list[9];
	this.InvalidFlag=list[10];
	this.ElementCat=list[11];
	this.Group=list[12];
	
	this.TemplistID=list[13];	//TL_RowID
	this.TemplateID=list[14];	//TL_TemplateDR
	GlobalObj.TemplateID=list[14];
	//this.ID=list[15];			//TL_ElementDR
	this.SettingValue=list[16];	//TL_SettingValue
	this.Key=list[17];			//TL_TL_Key
	this.Times=list[18];		//TL_Times
	this.Result=list[19];		//TL_Result
	this.Note=list[20];			//TL_Note
	this.NormalFlag=list[21];	//TL_NormalFlag
	//this.Remark=list[22];		//TL_Remark
	//this.Sort=list[23];			//TL_Sort
	this.UpdateUserDR=list[24];		//TL_UpdateUserDR
	this.UpdateDate=list[25];	//TL_UpdateDate
	this.UpdateTime=list[26];	//TL_UpdateTime
	this.Hold1=list[27];		//TL_Hold1
	this.Hold2=list[28];		//TL_Hold2
	this.Hold3=list[29];		//TL_Hold3
	this.UpdateUser=list[30];	//TL_UpdateUser
	this.Values=list[31];		//DHC_EQCElementValues
	if (this.MustFlag==1)
	{
		this.MustFlag="true"
	}
	else
	{
		this.MustFlag="false"
	}
	this.Html=crateElementHtml(this.ID,this.Name,this.ValueType,this.Result,this.Action,this.MustFlag,this.Reference,this.Values,this.Remark,this.TemplistID)	
}

///add by zy 2017-11-6  ZY0165
///创建元素对象的HTML
///入参：objid  	对象ID
///		 desc  		描述
///		 type  		类型
///把取到的元素信息放在对象中。
function crateElementHtml(id,desc,type,result,action,required,reference,values,remark,templatelistid)
{
	var HTML='<td width="20%" id="TD'+id+'" align="right">'+desc+': </td><td width="30%">'
	//id="Element"+id
	switch(type)
	{
		case "0" :  //文本
			if ((GlobalObj.Status>0)&&(GlobalObj.Action!=action))
			{
				HTML=HTML+result
			}
			else
			{
				var disabledflag=""
				if (remark=="disabled") HTML=HTML+'<input value="'+result+'" id="'+id+'" required="'+required+'" onchange="'+reference+'" type="text" class="easyui-textbox" disabled="disabled"/>'
				else HTML=HTML+'<input value="'+result+'" id="'+id+'" required="'+required+'" onchange="'+reference+'" type="text" class="easyui-textbox"/>'
			}
			//if (id==16) alertShow(HTML)
			break;
		case "1" :  //日期
			HTML=HTML+'<input value="'+result+'" id="'+id+'" required="'+required+'" class="easyui-datebox" />';
			break;
		case "2" :  //时间
			HTML=HTML+result
			break;
		case "3" :  //选择
			//1:国产:国产:&2:进口:进口:&3:两者均可:两者均可:
			if (values!="")
			{
				var values=values.split("&")
				var len=values.length
				/*
				var options="valueField: 'id',textField: 'text',data:["
				for (var i=0;i<len;i++)
				{
					var oneValue=values[i].split(":")
					var selectID=oneValue[0];
					var selectText=oneValue[1];
					var oneValueStr="{id:'"+selectID+"',text:'"+selectText+"'}"
					if (i==0) options=options+oneValueStr
					else options=options+","+oneValueStr
				}
				options=options+"]"
				*/
				var options=""
				for (var i=0;i<len;i++)
				{
					var oneValue=values[i].split(":")
					var selectID=oneValue[0];
					var selectText=oneValue[1];
					var oneValueStr='<option value="'+selectID+'">'+selectText+'</option>'
					if (result==selectID) oneValueStr='<option value="'+selectID+'" selected>'+selectText+'</option>'
					options=options+oneValueStr
				}
				if ((GlobalObj.Status>0)&&(GlobalObj.Action!=action)) 
				{
					HTML=HTML+'<select id="'+id+'" disabled="true">'+options+'</select>'
					//HTML=HTML+'<input value="'+result+'" disabled="true" required="'+required+'" class="easyui-combobox" data-options="'+options+'"/>'
				}
				else
				{
					HTML=HTML+'<select id="'+id+'">'+options+'</select>'
					//HTML=HTML+'<input value="'+result+'" id="'+id+'" required="'+required+'" class="easyui-combobox" data-options="'+options+'"/>'
				}
				//alertShow(result+"&"+HTML)
			}
			else
			{
				HTML=HTML+result
			}
			//alertShow(HTML)
			break;
		case "4" :  //指向
			HTML=HTML+'<a class="btn btn-primary" href="#" id="'+id+'" value="'+result+'" onclick="'+reference+'">'+desc+'</A>'
			//alertShow(HTML)
			break;
		case "5" :  //布尔
			if ((GlobalObj.Status>0)&&(GlobalObj.Action!=action))
			{
				if (result==1) HTML=HTML+'<input checked="checked" type="checkbox" disabled="disabled" /></td>'
				else HTML=HTML+'<input  type="checkbox" disabled="disabled" /></td>'
			}
			else
			{
				if (result==1) HTML=HTML+'<input checked="checked" id="'+id+'" type="checkbox" />'
				else HTML=HTML+'<input id="'+id+'" type="checkbox" />'
			}
			break;
		case "6" :  //整数
			HTML=HTML+'<input value="'+result+'" id="'+id+'" required="'+required+'" type="text" class="easyui-numberbox" precision="2" max="999999999999.99" size="8" maxlength="12"  style="text-align:right;" />'
			break;
		case "7" :  //浮点
			HTML=HTML+'<input value="'+result+'" id="'+id+'" required="'+required+'" type="text" class="easyui-numberbox" precision="2" max="999999999999.99" size="8" maxlength="12"  style="text-align:right;" />'
			break;
		case "8" :  //百分数
			if ((GlobalObj.Status>0)&&(GlobalObj.Action!=action))
			{
				HTML=HTML+result
			}
			else
			{
				HTML=HTML+'<input value="'+result+'" id="'+id+'" required="'+required+'" type="text" class="easyui-numberbox" precision="2" max="999999999999.99" size="8" maxlength="12"  style="text-align:right;" />'
			}
			//alertShow(HTML)
			break;
		case "9" :  //大文本
			if ((GlobalObj.Status>0)&&(GlobalObj.Action!=action))
			{
				HTML=HTML+result
			}
			else
			{
				HTML=HTML+'<textarea id="'+id+'" style="HEIGHT: 54px; WIDTH: 250px">'+result+'</textarea>'
			}
			break;
		default :
			HTML=HTML+result
			break;
	}
	HTML=HTML+'</td>'
	if ((remark!="")&&(remark!="disabled")) HTML=HTML+'<td  align="left"><FONT color=#0000ff>'+remark+'</FONT></td>'
	return HTML
}
jQuery(document).ready(function()
{
	initDocument();
})

function initDocument()
{
	GlobalObj.GetData();
	cratePageHtml();
}

function cratePageHtml()
{
	var HTML=""
	var GroupNum=ObjElementGroup.length
	//定义显示几列
	//var Group="title";
	var ColsNum=2
	//var ArgRate=100/GroupNum
	HTML=HTML+'<TABLE width="100%">';
	for (var i=0;i<GroupNum;i++)
	{
		var GroupDR=ObjElementGroup[i].GroupDR
		var Group=ObjElementGroup[i].Group
		var ElementIDs=ObjElementGroup[i].ElementIDs
		ElementIDs=ElementIDs.toString();
		ElementIDs=ElementIDs.split(",")
		var ElementLen=ElementIDs.length
		HTML=HTML+'<TR>'	
		HTML=HTML+'<TD class=edittitle>'
		HTML=HTML+'<STRONG><FONT color=#0000ff>'+Group+'</FONT></STRONG>'
		HTML=HTML+'</TD>'	
		HTML=HTML+'</TR>'
		HTML=HTML+'<TR>'	
		HTML=HTML+'<TD class=i-tableborder>'	
		HTML=HTML+'<TABLE width="100%" border="0">'
		HTML=HTML+'<TBODY>'
		HTML=HTML+'<TR>'
		for (var j=0;j<ElementLen;j++)
		{
			var ID=ElementIDs[j]
			HTML=HTML+ObjElement[ID].Html
			if((j+1)%ColsNum==0) HTML=HTML+'</TR><TR>'
		}
		if (ElementLen%ColsNum!=0)
		{
			var LossTDNum=(ColsNum-(ElementLen%ColsNum))*2
			for (var k=0;k<LossTDNum;k++)
			{
				HTML=HTML+'<td></td>'
			}
		}
		HTML=HTML+'</TBODY>'	
		HTML=HTML+'</TABLE>'	
		HTML=HTML+'</TD>'	
		HTML=HTML+'</TR>'
	}
	HTML=HTML+'</TABLE>'
	$('#Node').empty();
	$('#Node').append(HTML);
	//$.parser.parse("#Node");
	if (!((GlobalObj.Status==1)&&(GlobalObj.CurRole=="")))
	{
		HTML='<TABLE width="100%">'
		HTML=HTML+'<TBODY>'
		HTML=HTML+'<TR>'
		HTML=HTML+'<TD style="align: center" align=center>'
		HTML=HTML+'<a class="btn btn-primary" href="#" id="BSave" name="BSave"><img SRC="../images/uiimages/filesave.png" BORDER="0">保存</A>'
		HTML=HTML+'</TD>'
		if (GlobalObj.Status==0)
		{
			HTML=HTML+'<TD style="align: center" align=center>'
			HTML=HTML+'<a class="btn btn-primary" href="#" id="BDelete" name="BDelete"><img SRC="../images/uiimages/filesave.png" BORDER="0">删除</A>'
			HTML=HTML+'</TD>'
		}
		HTML=HTML+'</TR>'
		HTML=HTML+'</TBODY>'
		HTML=HTML+'</TABLE>'
		$('#Button').empty();
		$('#Button').append(HTML);
		$.parser.parse("#Button")
		$("#BSave").bind("click",BSaveClick);
		$("#BDelete").bind("click",BDeleteClick);
	}
	//$("input").change(function(e){AllOutFee(e);});
	
	var obj=document.getElementById("33")
	if (obj) obj.onchange=HiddenElement;
	var obj=document.getElementById("34")
	if (obj) obj.onchange=HiddenElement;
	
	var obj=document.getElementById("36")
	if (obj) obj.onclick=HiddenElement;
	var obj=document.getElementById("38")
	if (obj) obj.onclick=HiddenElement;
	var obj=document.getElementById("15")
	if (obj) obj.value=parseFloat(GlobalObj.BRLPriceFee).toFixed(2)
	var obj=document.getElementById("17")
	if (obj) obj.value=(GlobalObj.BRLPriceFee*0.06).toFixed(2)
	var obj=document.getElementById("21")
	if (obj) obj.value=(GlobalObj.BRLPriceFee*0.06).toFixed(2)
	var obj=document.getElementById("16")
	if (obj) obj.value=(GlobalObj.BRLPriceFee/5).toFixed(2)
	//var obj=document.getElementById("24")
	//if (obj) obj.value=(parseFloat(document.getElementById("25").value)+parseFloat(document.getElementById("23").value))
	HiddenElement()
}
function HiddenElement()
{
	var hideFlag=0
	var obj=document.getElementById("36")
	if (obj)
	{
		if (obj.checked==true)
		{
			$("#TD38").show();
			$("#38").show();
		}
		else
		{
			$("#TD38").hide();
			$("#38").hide();
			$("#TD39").hide();
			$("#39").hide();
			hideFlag=1
		}
	}
	var obj=document.getElementById("38")
	if (obj)
	{
		if ((obj.checked==true)&&(hideFlag==0))
		{
			$("#TD39").show();
			$("#39").show();
		}
		else
		{
			$("#TD39").hide();
			$("#39").hide();
		}
	}
	var obj=document.getElementById("33")
	/*
	if (obj.value=="5")
	{
		$("#TD67").show();
		$("#67").show();
	}
	else
	{
		$("#TD67").hide();
		$("#67").hide();
	}
	*/
	var obj=document.getElementById("34")
	if (obj)
	{
		if (obj.value=="6")
		{
			$("#TD68").show();
			$("#68").show();
		}
		else
		{
			$("#TD68").hide();
			$("#68").hide();
		}
	}
}
function CombineData()
{
	var combindata="";
  	combindata=ObjTemplate.ID ;
  	combindata=combindata+"^"+GlobalObj.SourceType ;
  	combindata=combindata+"^"+GlobalObj.SourceID ;
  	combindata=combindata+"^"+ObjTemplate.ItemDR ;
  	combindata=combindata+"^"+ObjTemplate.EquipDR ;
  	combindata=combindata+"^"+ObjTemplate.Name ;
  	combindata=combindata+"^"+ObjTemplate.Caption ;
  	combindata=combindata+"^"+ObjTemplate.Note ;
  	combindata=combindata+"^"+ObjTemplate.Remark ;
  	combindata=combindata+"^"+ObjTemplate.InvalidFlag ;
  	combindata=combindata+"^"+ObjTemplate.Hold1 ;
  	combindata=combindata+"^"+ObjTemplate.Hold2 ;
  	combindata=combindata+"^"+ObjTemplate.Hold3 ;
  	return combindata;
	
}
function CombineListData()
{
	var valList="";
	for (var i=0;i<ElementNum;i++)
	{
		var OnElement=ObjElement[i].TemplistID+"^"+ObjElement[i].ID+"^"
		//var obj=document.getElementById("Element"+ObjElement[i].ID)
		var obj=document.getElementById(ObjElement[i].ID)
		if (!obj) continue
		//0:文本 1:日期 2:时间 3:选择 4:指向 5:布尔 6:整数 7:浮点 8:百分数 9:大文本
		if ((ObjElement[i].ValueType==0)||(ObjElement[i].ValueType==3)||(ObjElement[i].ValueType==6)||(ObjElement[i].ValueType==7)||(ObjElement[i].ValueType==8)||(ObjElement[i].ValueType==9))
		{
			OnElement=OnElement+obj.value
		}
		else if (ObjElement[i].ValueType==1)
		{
			//OnElement=OnElement+
		}
		else if (ObjElement[i].ValueType==2)
		{
			//OnElement=OnElement+
			//OnElement=OnElement+getJQValue(jQuery("#"+ObjElement[i].ID),"value")
		}
		else if (ObjElement[i].ValueType==4)
		{
			//OnElement=OnElement+
		}
		else if (ObjElement[i].ValueType==5)
		{
			if (obj.checked==true) OnElement=OnElement+1
			else OnElement=OnElement+0
		}
		else
		{
			
		}
		if (valList=="")
		{
			valList=OnElement
		}
		else
		{
			valList=valList+"&"+OnElement
		}
	}
  	return valList;
	
}
function BSaveClick()
{
	var val=CombineData()
	var valList=CombineListData()
	var data=tkMakeServerCall("web.DHCEQTemplate","SaveData",val,valList,"0")
	data=data.replace(/\ +/g,"")	//去掉空格
	data=data.replace(/[\r\n]/g,"")	//去掉回车换行
	var list=data.split("^");
	if(list[0]>0)
	{
		$.messager.show({title: '提示',msg: '更新成功'});
		var url="dhceq.em.template.csp?&SourceType="+GlobalObj.SourceType+"&SourceID="+GlobalObj.SourceID+'&CurRole='+GlobalObj.CurRole+'&ReadOnly='+GlobalObj.ReadOnly+'&Action='+GlobalObj.Action;
		window.location.href=url;
	}
	else{
		$.messager.alert('更新失败！','错误代码:'+data, 'warning');
	}
}
function BDeleteClick()
{
	var result=tkMakeServerCall("web.DHCEQTemplate","SaveData",ObjTemplate.ID,"","1")
	var list=result.split("^");
	if(list[0]>0)
	{
		var url="dhceq.em.template.csp?&SourceType="+GlobalObj.SourceType+"&SourceID="+GlobalObj.SourceID+'&CurRole='+GlobalObj.CurRole+'&ReadOnly='+GlobalObj.ReadOnly+'&Action='+GlobalObj.Action;
		window.location.href=url;
	}
	else{
		alertShow("删除失败!")
	}
	
}
/*
function BBillItemClick1()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return "";
    var url="dhceq.process.billitem.csp?SourceType=1&SourceID="+GlobalObj.SourceID+'&CurRole='+GlobalObj.CurRole+'&ReadOnly='+GlobalObj.ReadOnly+'&ElementID='+eSrc.id+'&TemplateID='+GlobalObj.TemplateID+"&IsFunction=1";
	ShowOrderDetails(url, '800px', '400px', 'no');
}
*/
function BBillItemClick()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return "";
    var url="dhceq.em.billitem.csp?SourceType=1&SourceID="+GlobalObj.SourceID+'&CurRole='+GlobalObj.CurRole+'&ReadOnly='+GlobalObj.ReadOnly+'&ElementID='+eSrc.id+'&TemplateID='+GlobalObj.TemplateID+"&IsFunction=0";
	if((GlobalObj.Action=="SQ_Opinion13")||(GlobalObj.Action=="SQ_Opinion14"))
	{
		var url="dhceq.em.billitem.csp?SourceType=1&SourceID="+GlobalObj.SourceID+'&CurRole='+GlobalObj.CurRole+'&ReadOnly=0&ElementID='+eSrc.id+'&TemplateID='+GlobalObj.TemplateID+"&IsFunction=0";
	}
	ShowOrderDetails(url, '800px', '400px', 'no');
}

function BConsumableItemInfoClick()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return "";
    var url="dhceq.process.consumableiteminfo.csp?SourceType=1&SourceID="+GlobalObj.SourceID+'&CurRole='+GlobalObj.CurRole+'&ReadOnly='+GlobalObj.ReadOnly+'&ElementID='+eSrc.id+'&TemplateID='+GlobalObj.TemplateID;
	ShowOrderDetails(url, '1200px', '600px', 'no');
	window.opener.close();
}
function BVendorListClick()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return "";
    var url="dhceq.em.ifblistforloc.csp?SourceType=1&SourceID="+GlobalObj.SourceID+'&ReadOnly='+GlobalObj.ReadOnly+'&ElementID='+eSrc.id+'&TemplateID='+GlobalObj.TemplateID;
	///var url="dhceq.process.ifblist.csp?SourceType=2&SourceID=25"+'&ReadOnly='+GlobalObj.ReadOnly;
	ShowOrderDetails(url, '800px', '400px', 'no');
}
function BEliminateListClick()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return "";
    //var url="dhceq.process.eliminatelist.csp?SourceType=1&SourceID="+GlobalObj.SourceID+'&CurRole='+GlobalObj.CurRole+'&ReadOnly='+GlobalObj.ReadOnly+'&ElementID='+eSrc.id+'&TemplateID='+GlobalObj.TemplateID+"&IsFunction=0";
	var url="dhceq.process.eliminatelist.csp?SourceType=1&SourceID="+GlobalObj.SourceID+'&ReadOnly='+GlobalObj.ReadOnly+'&ElementID='+eSrc.id+'&TemplateID='+GlobalObj.TemplateID;
	ShowOrderDetails(url, '800px', '400px', 'no');
}
function ShowOrderDetails(url,width,height,showScroll)
{
    $("body").addClass("body1");
	//window.showModalDialog(url, "", "location:No;status:No;help:NO;dialogWidth:" + width + ";dialogHeight:" + height + ";scroll" + showScroll + ";");
	window.open(url, "", "location=no,status=no,help=no,width=" + width + ",height=" + height + ",scrollbars=" + showScroll);
	$("body").removeClass("body1");
}
function AllOutFee(e)
{
	

	var obj=document.getElementById("7")
	var preWorkLoadNum=0
	if ((obj)&&(obj.value!="")) preWorkLoadNum=obj.value
	var obj=document.getElementById("9")
	var newWorkLoadNum=0
	if ((obj)&&(obj.value!="")) newWorkLoadNum=obj.value
	
	if (newWorkLoadNum<preWorkLoadNum)
	{
		alertShow("新设备年预计工作量要大于现有设备平均每台年工作量.")
	}
	var obj=document.getElementById("16")
	var depreFee=0
	if ((obj)&&(obj.value!="")) depreFee=obj.value
	var obj=document.getElementById("17")
	var maintFee=0
	if ((obj)&&(obj.value!="")) maintFee=obj.value
	var obj=document.getElementById("18")
	var personNum=0
	if ((obj)&&(obj.value!="")) personNum=obj.value
	var obj=document.getElementById("19")
	var onePersonFee=0
	if ((obj)&&(obj.value!="")) onePersonFee=obj.value
	if ((onePersonFee<80000)&&(onePersonFee>0))
	{
		alertShow("人年均收入必须大于80000万")
	}
	var obj=document.getElementById("20")
	var PersonFee=0
	if (obj)
	{
		obj.value=parseFloat(personNum)*parseFloat(onePersonFee)
		PersonFee=obj.value
	}
	
	var obj=document.getElementById("21")
	var manageFee=0
	if ((obj)&&(obj.value!="")) manageFee=obj.value
	//alertShow("depreFee="+depreFee+",maintFee="+maintFee+",PersonFee="+PersonFee+",manageFee="+manageFee)
	var AllOutFee=parseFloat(depreFee)+parseFloat(maintFee)+parseFloat(PersonFee)+parseFloat(manageFee)
	var obj=document.getElementById("22")
	if (obj) obj.value=AllOutFee
	var obj=document.getElementById("24")
	//obj.value=parseFloat(document.getElementById("AllInFee").value)
	var AllInFee=0
	if ((obj)&&(obj.value!="")) AllInFee=obj.value
	//alertShow("AllInFee="+AllInFee+",AllOutFee="+AllOutFee)
	var obj=document.getElementById("26")
	if (obj) obj.value=(parseFloat(AllInFee)-parseFloat(AllOutFee)).toFixed(2)
	return
}


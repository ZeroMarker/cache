//界面入口
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initPicList()
	initButtonWidth()
	if (getElementValue("ReadOnly")==1)
	{
		disableElement("BUpLoad",true)
		disableElement("BDelete",true)
	}
	else
	{
		var obj=document.getElementById("BUpLoad");
		if (obj)
		{
			jQuery("#BUpLoad").on("click", BUpLoad_Click);
		}
		var obj=document.getElementById("BDelete");
		if (obj)
		{
			jQuery("#BDelete").on("click", BDelete_Click);
		}
		
		///add by ZY0307 20220713 2761399
		var obj=document.getElementById("BDownload");
		if (obj)
		{
			jQuery("#BDownload").on("click", BDownload_Click);
		}
	}
}
function initPicList()
{
	var PicListJson=tkMakeServerCall("web.DHCEQ.Plat.LIBPicture","GetPictureList",getElementValue("PTRowID"))
	var PictureInfoObj=jQuery.parseJSON(PicListJson)
	if (PictureInfoObj.SQLCODE<0) return
	var FirstFlag=1
	for (var key in PictureInfoObj.Data)
	{
		//add by zx 2019-07-25 轮播图片查看居中处理
		var id="PLRowID_"+key
		var picpath=PictureInfoObj.Data[key]
		divInfo="<div class=\"item\" style=\"text-align:center\"><img id="+id+" src=\""+picpath+"\" style=\"display:inline-block\"></div>"
		if (FirstFlag==1) var divInfo="<div class=\"item active\" style=\"text-align:center\"><img id="+id+" src=\""+picpath+"\" style=\"display:inline-block\"></div>"
		FirstFlag=FirstFlag+1
		jQuery("#PicListView").append(divInfo)
	}
}
function getPicType()
{
	var PicTypesJson=tkMakeServerCall("web.DHCEQ.Process.DHCEQCPicSourceType","GetPicTypeMenu",getElementValue("SourceType"),"")
	window.eval("var PicTypes = " + PicTypesJson);
	var childdatainfo=""
	for (var i=0;i<PicTypes.length;i++)
	{
		var childinfo="{id:'"+PicTypes[i].id+"',text:'"+PicTypes[i].text+"'}"
		if (childdatainfo!="") childdatainfo=childdatainfo+","
		childdatainfo=childdatainfo+childinfo
	}
	return "[{id:0,text:'请选择'},"+childdatainfo+"]"
}
function BUpLoad_Click()
{
	var PTRowID=getElementValue("PTRowID")
	var PicTypeData=getPicType()
	var PicInfo=getElementValue("PicInfo")
	var CurPic=PicInfo.split("^")
	var PicType=CurPic[0]
	var PicName=CurPic[1]
	var str='../csp/dhceq.plat.picbatchupload.csp?&PTRowID='+PTRowID+'&PicTypeData='+PicTypeData+'&PicType='+PicType+'&PicName='+PicName+'&SourceType='+getElementValue("SourceType")+'&SourceID='+getElementValue("SourceID")
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
function BDelete_Click()
{
	var CurPicDiv=$("#PicListView").find('.active')
	var CurPicObj=CurPicDiv.children()
	var CurPicInfo=$(CurPicObj).attr("id")
	var Return=tkMakeServerCall("web.DHCEQ.Plat.LIBPicture","DeletePic",CurPicInfo.split("_")[1])
	if (Return==0)
	{
		alertShow("操作成功!")
		location.reload()
	}
}
///add by ZY0307 20220713 2761399
function BDownload_Click()
{
	var src=$(".active>img").attr("src")
	var alink = document.createElement("a");
	alink.href = src;
	alink.download = "testImg.jpg";
	alink.click();
}
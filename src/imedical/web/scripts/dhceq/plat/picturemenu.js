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
	//初始化图片业务访问图片类型
	initPicType()
}
function initPicType()
{
	var PicTypesJson=tkMakeServerCall("web.DHCEQ.Process.DHCEQCPicSourceType","GetPicTypeMenu",getElementValue("CurrentSourceType"),"")
	window.eval("var PicTypes = " + PicTypesJson);
	var defaultnode=""
	var childdata=[]
	for (var i=0;i<PicTypes.length;i++)
	{
		var checkflag=true
		if (i==0)
		{
			defaultnode =PicTypes[i].id
			initPicList(getElementValue("CurrentSourceType"),getElementValue("CurrentSourceID"),PicTypes[i].id)
		}
		var childinfo={"id":"PicType_"+PicTypes[i].id,"text":PicTypes[i].text,"checked":checkflag}
		childdata.push(childinfo)
	}
	$("#tPicType").tree('append', {data:[{"id":"PicType_0","text":"图片类型","children":childdata}]});
	//默认选中
	if (defaultnode!="")
	{
		var node = $('#tPicType').tree('find', "PicType_"+defaultnode);
		$('#tPicType').tree('select', node.target);
	}
	//监听事件
	$('#tPicType').tree({
		onClick:function(node)
		{
			var PicTypeID=node.id
			var PicType=PicTypeID.split("_")
			jQuery("#tPicList").empty();
			initPicList(getElementValue("CurrentSourceType"),getElementValue("CurrentSourceID"),PicType[1])
		}
	})
}
function initPicList(SourceType,SourceID,PicTypeDR)
{
	if ((SourceType=="")||(SourceID=="")) return
	var PictureInfo=tkMakeServerCall("web.DHCEQ.Plat.LIBPicture","GetPictureBySource",SourceType,SourceID,PicTypeDR)
	var PictureInfoObj=jQuery.parseJSON(PictureInfo)
	if (PictureInfoObj.SQLCODE<0) return
	var Count=0
	var PicList=""
	for (var key in PictureInfoObj.Data)
	{
		Count=Count+1
		var OntPictureInfo=PictureInfoObj.Data[key]
		var id=OntPictureInfo["id"]
		var picpath=OntPictureInfo["path"]
		var picname=OntPictureInfo["name"]
		PicList=""
		PicList=PicList+"<div style=\""+"height:230px;width:229px;border:1px dashed #DCDCDC;padding:10px 10px 10px 10px;float:left;text-align:center\">"
		PicList=PicList+"<div style=\""+"width:100%;height:95%;\"><img id=\"PT_+id+\" src=\""+picpath+"\" onclick=\"PicClick("+id+")\" style=\"width:100%;height:100%;\"/></div>"
		PicList=PicList+"<div><span>"+picname+"</span></div>"
		PicList=PicList+"</div>"
		jQuery("#tPicList").append(PicList)
	}
	if (getElementValue("Status")>=1)
	{
		setElement("ReadOnly",1)
		if ((getElementValue("CurrentSourceType")=="31")&&(getElementValue("Status")==1)&&(getElementValue("Action")=="WX_Maint"))
		{
			setElement("ReadOnly",0)
		}
	}
	if (getElementValue("ReadOnly")!=1)
	{
		PicList=""
		PicList=PicList+"<div style=\""+"height:230px;width:229px;border:1px dashed #DCDCDC;padding:10px 10px 10px 10px;float:left;text-align:center\">"
		PicList=PicList+"<div style=\""+"width:100%;height:95%;\"><img id=\"PT_0\" src=\"../images/eq-picadd.jpg\" onclick=\"PicClick('')\" style=\"width:100%;height:100%;\"/></div>"
		PicList=PicList+"<div><span>新图片</span></div>"
		PicList=PicList+"</div>"
		jQuery("#tPicList").append(PicList)
		Count=Count+1
	}
	
	PicList=""
	if (Count<=6)
	{
		var ZJCount=6-Count
	}
	else
	{
		var ZJCount=Count%3
		if (ZJCount!=0) ZJCount=3-Count%3
	}
	if (ZJCount!=0)
	{
		for (var j=1;j<=ZJCount;j++)
		{
			PicList=PicList+"<div style=\""+"height:230px;width:229px;border:1px dashed #DCDCDC;padding:10px 10px 10px 10px;float:left;text-align:center\"></div>"
		}
	}
	if (PicList!="") jQuery("#tPicList").append(PicList)
}
function getPicType()
{
	var PicTypesJson=tkMakeServerCall("web.DHCEQ.Process.DHCEQCPicSourceType","GetPicTypeMenu",getElementValue("CurrentSourceType"),"")
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
function PicClick(vID)
{
	if (vID=="")
	{
		var PicTypeData=getPicType()
		var PicTypeID=$("#tPicType").tree('getSelected').id
		var PicType=PicTypeID.split("_")
		var str='../csp/dhceq.plat.picbatchupload.csp?&PTRowID=&PicTypeData='+PicTypeData+'&PicType='+PicType[1]+'&SourceType='+getElementValue("CurrentSourceType")+'&SourceID='+getElementValue("CurrentSourceID")
		showWindow(str,"上传图片","","","icon-w-paper","modal","","","middle");	//modify by czf 2019-03-04
	}
	else
	{
		var str='../csp/dhceq.plat.pictureview.csp?&PTRowID='+vID+'&SourceType='+getElementValue("CurrentSourceType")+'&SourceID='+getElementValue("CurrentSourceID")+'&ReadOnly='+getElementValue("ReadOnly")
		showWindow(str,"上传图片","","","icon-w-paper","modal","","","middle");	//modify by czf 2019-03-04
	}
}
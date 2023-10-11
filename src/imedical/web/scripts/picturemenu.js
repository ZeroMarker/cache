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
	defaultnode="0"		//默认选中图片类型 czf 2022-05-11 begin
	if (defaultnode!="")
	{
		var node = $('#tPicType').tree('find', "PicType_"+defaultnode);
		$('#tPicType').tree('select', node.target);
		var PicTypeID=node.id
		var PicType=PicTypeID.split("_")
		jQuery("#tPicList").empty();
		initPicList(getElementValue("CurrentSourceType"),getElementValue("CurrentSourceID"),PicType[1])	//默认选中图片类型 czf 2022-05-11 end
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
		var picunm=OntPictureInfo["picunm"]  //Add by zc0125 2022-12-8 添加数量显示
		PicList=""
		PicList=PicList+"<div style=\""+"height:230px;width:229px;border:1px dashed #DCDCDC;padding:10px 10px 10px 10px;float:left;text-align:center\">"
		PicList=PicList+"<div style=\""+"width:100%;height:95%;\"><img id=\"PT_+id+\" src=\""+picpath+"\" onclick=\"PicClick("+id+")\" style=\"width:100%;height:100%;\"/></div>"
		PicList=PicList+"<div><span>"+picname+"("+picunm+"张)</span></div>"  //Add by zc0125 2022-12-8 添加数量显示
		PicList=PicList+'<a href="#\" onclick="javascript:PrintPic('+id+')" style="padding:10px 15px;background:url(../images/uiimages/printBedCard.png) no-repeat center;"></a>'
		PicList=PicList+"</div>"
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


//czf 2022-05-12
//打印图片
function PrintPic(vID)
{
	if (vID=="")
	{
		return;
	}
	else
	{
		var PTRowID=vID;
		var SourceType=getElementValue("CurrentSourceType");
		var SourceID=getElementValue("CurrentSourceID");
		//window.print();	//打印当前页面
		var PicListJson=tkMakeServerCall("web.DHCEQ.Plat.LIBPicture","GetPictureList",PTRowID)
		var PictureInfoObj=jQuery.parseJSON(PicListJson)
		if (PictureInfoObj.SQLCODE<0) return
		
		var iframe = document.createElement('IFRAME');
		var doc = null;
		iframe.setAttribute('style','position:absolute;width:0px;height:0px;left:-500px;top:-500px;');
		document.body.appendChild(iframe);
		doc = iframe.contentWindow.document;
		
		var iframehtml='<div><ul style="width:100%;display:block;list-style:none;">';
		
		for (var key in PictureInfoObj.Data)
		{
			//var Imgid="PLRowID_"+key;
			//var ImgObj = document.getElementById(Imgid);
			var id="PLRowID_"+key;
			var picpath=PictureInfoObj.Data[key];
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				picpath += "&MWToken="+websys_getMWToken()
			}
			iframehtml+='<li style="width:100%;padding-bottom:10px;">';
			iframehtml+='<img id="'+id+ '" src="' + picpath + '" style="display:inline-block; max-width:100%; max-height:100%;">'
			iframehtml+='</li>';
		}
		iframehtml+='</ul></div>';
		doc.write(iframehtml);
		doc.close();
		
		var img = $(doc).find("img");
		for(var i = 0; i < img.length; i++) {
		    img.eq(i).css("margin", "0 auto");
		}
		$(doc).find("img").load(function () { //modify by zyq 2022-12-21 等待图片加载完了再加载打印预览页面
			iframe.contentWindow.focus();
 			iframe.contentWindow.print();
		});
		if(navigator.userAgent.indexOf("MSIE") > 0) {
		    document.body.removeChild(iframe);
		}
	}
}

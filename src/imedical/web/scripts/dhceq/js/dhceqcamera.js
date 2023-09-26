var dev1;
var dev2;
var video;

function plugin()
{
    return document.getElementById('view1');
}

function view()
{
    return document.getElementById('view1');
}
	
function thumb1()
{
    return document.getElementById('thumb1');
}

function addEvent(obj, name, func)
{
    if (obj.attachEvent) {
        obj.attachEvent("on"+name, func);
    } else {
        obj.addEventListener(name, func, false); 
    }
}
function OpenVideo()
{	
	CloseVideo();
	
	var sSubType = document.getElementById('subType'); 								
	var sResolution = document.getElementById('selRes'); 
	var sDevice =   document.getElementById('device');			
		
	var SelectType = 0;
	var txt;
	if(sSubType.options.selectedIndex != -1)
	{
		txt = sSubType.options[sSubType.options.selectedIndex].text;
		if(txt == "YUY2")
		{
			SelectType = 1;
		}
		else if(txt == "MJPG")
		{
			SelectType = 2;
		}
		else if(txt == "UYVY")
		{
			SelectType = 4;
		}
	}
	
	var nResolution = sResolution.selectedIndex;
					
	var dev;
	if(sDevice.selectedIndex == 0)
		dev = dev1;
	else if(sDevice.selectedIndex == 1)
		dev = dev2;
		
	video = plugin().Device_CreateVideo(dev, nResolution, SelectType);
	if (video)
	{

		view().View_SelectVideo(video);
		view().View_SetText("打开视频中，请等待...", 0);						
	}
}

function CloseVideo()
{
	if (video)
	{
		view().View_SetText("", 0);
		plugin().Video_Release(video);
		video = null;
	}		
}

function changesubType()
{	
	var sSubType = document.getElementById('subType'); 								
	var sResolution = document.getElementById('selRes'); 
	var sDevice =   document.getElementById('device');		
	
	var SelectType = 0;
	var txt;
	if(sSubType.options.selectedIndex != -1)
	{
		var txt = sSubType.options[sSubType.options.selectedIndex].text;
		if(txt == "YUY2")
		{
			SelectType = 1;
		}
		else if(txt == "MJPG")
		{
			SelectType = 2;
		}
		else if(txt == "UYVY")
		{
			SelectType = 4;
		}
	}
		
	var dev;
	if(sDevice.selectedIndex == 0)
		dev = dev1;
	else if(sDevice.selectedIndex == 1)
		dev = dev2;
		
	var nResolution = plugin().Device_GetResolutionCountEx(dev, SelectType);
	sResolution.options.length = 0; 
	for(var i = 0; i < nResolution; i++)
	{
		var width = plugin().Device_GetResolutionWidthEx(dev, SelectType, i);
		var heigth = plugin().Device_GetResolutionHeightEx(dev, SelectType, i);
		sResolution.add(new Option(width.toString() + "*" + heigth.toString())); 
	}
	sResolution.selectedIndex = 0;		
}

function changeDev()
{
	var sSubType = document.getElementById('subType'); 								
	var sResolution = document.getElementById('selRes'); 	
	var lDeviceName =  document.getElementById('lab1');
	var sDevice =   document.getElementById('device');

	var dev;
	if(sDevice.selectedIndex == 0)
		dev = dev1;
	else if(sDevice.selectedIndex == 1)
		dev = dev2;			
	
	sSubType.options.length = 0; 
	var subType = plugin().Device_GetSubtype(dev);
	if(subType&1)
	{
		sSubType.add(new Option("YUY2")); 
	}
	if(subType&2)
	{
		sSubType.add(new Option("MJPG")); 
	}							
	if(subType&4)
	{
		sSubType.add(new Option("UYVY")); 
	}	
	sSubType.selectedIndex = 0;
	
	var SelectType = 0;
	var txt;
	if(sSubType.options.selectedIndex != -1)
	{
		var txt = sSubType.options[sSubType.options.selectedIndex].text;
		if(txt == "YUY2")
		{
			SelectType = 1;
		}
		else if(txt == "MJPG")
		{
			SelectType = 2;
		}
		else if(txt == "UYVY")
		{
			SelectType = 4;
		}
	}
						
	var nResolution = plugin().Device_GetResolutionCountEx(dev, SelectType);
	sResolution.options.length = 0; 
	for(var i = 0; i < nResolution; i++)
	{
		var width = plugin().Device_GetResolutionWidthEx(dev, SelectType, i);
		var heigth = plugin().Device_GetResolutionHeightEx(dev, SelectType, i);
		sResolution.add(new Option(width.toString() + "*" + heigth.toString())); 
	}
	sResolution.selectedIndex = 0;		
}
function Load()
{
	//设备接入和丢失
	//type设备类型， 1 表示视频设备， 2 表示音频设备
	//idx设备索引
	//dbt 1 表示设备到达， 2 表示设备丢失		
	addEvent(plugin(), 'DevChange', function(type,idx,dbt)
	{
		if(1 != type)
		{
			return;
		}
		
		if (0 == idx)
		{
			if (1 == dbt)
			{
				dev1 = plugin().Global_CreateDevice(1, 0);
				if (dev1)
				{
					var sSubType = document.getElementById('subType'); 								
					var sResolution = document.getElementById('selRes'); 	
					var lDeviceName =  document.getElementById('lab1');
					var sDevice =   document.getElementById('device');
					
					sDevice.options.length = 0; 
					sDevice.add(new Option(plugin().Device_GetFriendlyName(dev1))); 
					
					sSubType.options.length = 0; 
					var subType = plugin().Device_GetSubtype(dev1);
					if(subType&1)
					{
						sSubType.add(new Option("YUY2")); 
					}
					if(subType&2)
					{
						sSubType.add(new Option("MJPG")); 
					}							
					if(subType&4)
					{
						sSubType.add(new Option("UYVY")); 
					}	
					sSubType.selectedIndex = 0;
					
					var SelectType = 0;
					var txt;
					if(sSubType.options.selectedIndex != -1)
					{
						var txt = sSubType.options[sSubType.options.selectedIndex].text;
						if(txt == "YUY2")
						{
							SelectType = 1;
						}
						else if(txt == "MJPG")
						{
							SelectType = 2;
						}
						else if(txt == "UYVY")
						{
							SelectType = 4;
						}
					}
										
					var nResolution = plugin().Device_GetResolutionCountEx(dev1, SelectType);
					sResolution.options.length = 0; 
					for(var i = 0; i < nResolution; i++)
					{
						var width = plugin().Device_GetResolutionWidthEx(dev1, SelectType, i);
						var heigth = plugin().Device_GetResolutionHeightEx(dev1, SelectType, i);
						sResolution.add(new Option(width.toString() + "*" + heigth.toString())); 
					}
					sResolution.selectedIndex = 0;
			
					OpenVideo();									
				}						
			}
			else if (2 == dbt)
			{
				if (dev1)
				{
					if(plugin().Device_GetIndex(dev1) == idx)
					{
						if(video)
						{
							view().View_SetText("", 0);
							plugin().Video_Release(video);
							video = null;
						}
						plugin().Device_Release(dev1);
						dev1 = null;
						
						document.getElementById('device').options[0]=null;
					}
				}
				if (dev2)
				{
					if(plugin().Device_GetIndex(dev2) == idx)
					{
						if(video)
						{
							view().View_SetText("", 0);
							plugin().Video_Release(video);
							video = null;
						}
						plugin().Device_Release(dev2);
						dev2 = null;
						
						document.getElementById('device').options[1]=null;
					}
				}							
			}						
		}
		else if (1 == idx)
		{
			if (1 == dbt)
			{
				dev2 = plugin().Global_CreateDevice(1, 1);
				if (dev2)
				{	
					var sDevice =   document.getElementById('device');
					sDevice.add(new Option(plugin().Device_GetFriendlyName(dev2))); 								
				}						
			}
			else if (2 == dbt)
			{
				if (dev1)
				{
					if(plugin().Device_GetIndex(dev1) == idx)
					{
						if(video)
						{
							view().View_SetText("", 0);
							plugin().Video_Release(video);
							video = null;
						}
						plugin().Device_Release(dev1);
						dev1 = null;
						
						document.getElementById('device').options[0]=null;
					}
				}
				if (dev2)
				{
					if(plugin().Device_GetIndex(dev2) == idx)
					{
						if(video)
						{
							view().View_SetText("", 0);
							plugin().Video_Release(video);
							video = null;
						}
						plugin().Device_Release(dev2);
						dev2 = null;
						
						document.getElementById('device').options[1]=null;
					}
				}
			}
		}				
    });

	addEvent(plugin(), 'Deskew', function(video, view, list)
			        {
				        // 纠偏回调事件
				        var count = plugin().RegionList_GetCount(list);
				        for (var i = 0; i < count; ++i)
				        {				
					        var region = plugin().RegionList_GetRegion(list, i);
					
					        var x1 = plugin().Region_GetX1(region);
					        var y1 = plugin().Region_GetY1(region);
					
					        var width = plugin().Region_GetWidth(region);
					        var height = plugin().Region_GetHeight(region);
					        plugin().Region_Release(region);
				        }
				        plugin().RegionList_Release(list);
			        });

	view().Global_SetWindowName("view");
	thumb1().Global_SetWindowName("thumb");
	//加载图片类型
	var obj=document.getElementById('PicType')
	if (obj)
	{
		var obj=document.getElementById('PicTypeInfo');
		if (obj)
		{
			var PicTypeList=obj.value;
			PicTypeList=PicTypeList.split("&");
			var PicTypeCount=PicTypeList.length
			for (var i=0;i<PicTypeCount;i++)
			{
				var CurPicType=PicTypeList[i].split("^")
				var PicTypeDR=CurPicType[0];
				var PicTypeName=CurPicType[1];
				PicType.add(new Option(PicTypeName,PicTypeDR));
			}
		}
	}
	plugin().Global_InitDevs();		
}
 function Deskew(obj)
		        { 
			        if (obj.checked)
			        {
				        if(video)
				        {
					        plugin().Video_EnableDeskewEx(video, 1);
				        }
			        }
			        else
			        {
				        if(video)
				        {
					        plugin().Video_DisableDeskew(video);
				        }
			        }
		        }
				
function Unload()
{
	if (video)
	{
		view().View_SetText("", 0);
		plugin().Video_Release(video);
		video = null;
	}
	if(dev1)
	{
		plugin().Device_Release(dev1);
		dev1 = null;	
	}
	if(dev2)
	{
		plugin().Device_Release(dev2);
		dev2 = null;	
	}
	plugin().Global_DeinitDevs();
}
//拍照
function Scan()
{
	var date = new Date();
	var yy = date.getFullYear().toString();
	var mm = (date.getMonth() + 1).toString();
	var dd = date.getDate().toString();
	var hh = date.getHours().toString();
	var nn = date.getMinutes().toString();
	var ss = date.getSeconds().toString();
	var mi = date.getMilliseconds().toString();
	var obj=document.getElementById("CurrentSourceType")
	if (obj){var CurrentSourceType=obj.value}
	var obj=document.getElementById("CurrentSourceID")
	if (obj){var CurrentSourceID=obj.value}
	//检测文件夹是否存在,不存在则提示用户(此处的ActiveX控件有的额IE浏览器报错)
	var fso=new ActiveXObject("Scripting.FileSystemObject");
    var tmpFolder="D:\\DHCEQPic\\";
    if(!fso.FolderExists(tmpFolder))		//判断文件夹是否存在
    {
        fso.CreateFolder(tmpFolder);         
    }
	var Name = "D:\\DHCEQPic\\"+CurrentSourceType+"_"+CurrentSourceID+"_" + yy + mm + dd + hh + nn + ss + mi + ".jpg";
	
	var img = plugin().Video_CreateImage(video, 0, view().View_GetObject());
	var bSave = plugin().Image_Save(img, Name, 0);
	if (bSave)
	{
		view().View_PlayCaptureEffect();
		thumb1().Thumbnail_Add(Name);
	}
	
	plugin().Image_Release(img);
}
//上传
function Upload()
{
 	var FtpInfo=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990018")
 	FtpInfo=FtpInfo.split("&")
 	var FtpUrlStr="ftp://"+FtpInfo[1]+":"+FtpInfo[2]+"@"+FtpInfo[0]
 	if (FtpInfo[3]!="") FtpUrlStr=FtpUrlStr+":"+FtpInfo[3]
 	
 	var CurrentSourceType=GetElementValue("CurrentSourceType")
 	var CurrentSourceID=GetElementValue("CurrentSourceID")
 	var PTRowID=GetElementValue("PTRowID")
 	var PLRowID=GetElementValue("PLRowID")
 	var EquipDR=GetElementValue("EquipDR")
 	var Path=GetElementValue("Path")
 	var PicName=GetElementValue("PicName")
	if (PicName=="")
	{
		alertShow("图片名称不能为空!");
		return
	}
	var obj=document.getElementById("PicType")
	if (obj)
	{
		if (PicType.options.selectedIndex!=-1)
		{
			var PicTypeDR=PicType.options[PicType.options.selectedIndex].value
			if (PicTypeDR=="")
			{
				alertShow("请选择图片类型!")
				return
			}
		}
		else
		{
			alertShow("请选择图片类型!")
			return
		}
	}
    var succAry=new Array();
    var num=0,succNum=0,failNum=0;
	//获取选中的图片索引
	var selImgAry=getSelectImageIndex(thumb1());
	var count=selImgAry.length;
	var vPTInfo=PTRowID+"^^^^"+Path+"^"+PicTypeDR+"^^^"+CurrentSourceType+"^"+CurrentSourceID+"^^^^"+PicName+"^^^^^"
	var vPLInfo=PLRowID+"^^^jpg^"
	if ((PLRowID!="")&&(count>1))	//明细记录更新时只能选择一张图片
	{
		alertShow("更新明细记录图片只能选择一张图片!")
		return
	}
	for(var n=0;n<count;n++)
	{
		if (n==0) vPLInfo=vPLInfo+"Y"
		var targetFileName=""
    	var idx=selImgAry[n];
    	var tmpFileName=thumb1().Thumbnail_GetFileName(idx);	//高拍仪采集图片源文件
    	var UploadResult=tkMakeServerCall("web.DHCEQ.Process.DHCEQPictureList","CameraPicSave",vPTInfo,vPLInfo);
        if ((UploadResult=="")||(UploadResult<0))
        {
	        alertShow("数据存储失败!")
	        return
        }
        else
        {
	        var ReturnInfo=UploadResult.split("^");
	        vPTInfo=ReturnInfo[0]
	        var obj=document.getElementById("PTRowID")
			if (obj){obj.value=ReturnInfo[0]}
			targetFileName=ReturnInfo[1]
        }
        
        //图片上传
        FtpUrl = plugin().Global_CreateFtp(FtpUrlStr)
        if (FtpUrl)
        {
	        var targetFileName=Path+targetFileName+".jpg"
	        var FtpUpload=plugin().Ftp_Upload(FtpUrl,0,tmpFileName,targetFileName)
        	if (FtpUpload)
        	{
	        	succNum=succNum+1;
	        	succAry.push(idx);
        	}
        	else
        	{
	        	failNum=failNum+1; 
        	}
        	num=num+1
        	plugin().Ftp_Release(FtpUrl);
        }
        else
        {
	        alertShow("FTP错误!")
        }
        
	}
    alertShow("共上传 "+ num + " 张(其中成功 " +succNum + " 张,失败 "+failNum+" )");
    
    //清除上传成功的本地图片
    var len=succAry.length;
    for(var i=len-1;i>=0;i--){
		var idx=succAry[i];
		var bool=thumb1().Global_DelFile(thumb1().Thumbnail_GetFileName(idx));		//上传成功则删除本地临时存储文件
		var bool=thumb1().Thumbnail_Remove(idx,true);
	}
	//关闭窗口
	//CloseVideo();
}
//查看图片
function ShowImage()
{
    CloseVideo();
	//显示缩略图的图片
	var idx=thumb1().Thumbnail_GetSelected();
	var path=thumb1().Thumbnail_GetFileName(idx);
	var imgObj=plugin().Global_CreateImageFromFile(path,0);
	view().View_SelectImage(imgObj);
}
///全选，全不选
function SelectAll(bool)
{
	if(thumb1())
	{
		var imgCount=thumb1().Thumbnail_GetCount();
		for(var i=0;i<imgCount;i++){
			thumb1().Thumbnail_SetCheck(i, bool);
		}	
	}	
}
///清除缩略图中选中的图片
function DelSelImg()
{
	if(thumb1())
	{
		var selImgAry=getSelectImageIndex(thumb1());
		var len=selImgAry.length;
		for(var i=len-1;i>=0;i--){
			var idx=selImgAry[i];
			var bool=thumb1().Thumbnail_Remove(idx,true);  
		}
	}	
}
///清除缩略图中的所有图片
function Clear()
{
	if(thumb1())
	{
		var bool=thumb1().Thumbnail_Clear(true);	
	}
}
///获取缩略图中被选中的图片索引
function getSelectImageIndex(thumbObj)
{
	var imgCount=thumbObj.Thumbnail_GetCount();
	var idxAry=new Array();
	for(var i=0;i<imgCount;i++)
	{
		var isCheck=thumbObj.Thumbnail_GetCheck(i);
		if(isCheck)
		{
			idxAry.push(i);	
		}	
	}
	return idxAry;
}
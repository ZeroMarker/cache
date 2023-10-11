//网页初始化函数
window.onload = function() {
	baseUrl = "ws://127.0.0.1:12345";			  
	openSocket(); 
	initData();					
}
//单击缩略图,预览
function openImage(imageItem)
{
	window.imgUrl = imageItem.src;
	var dialogId = "thumbShoweDialog";
    var src = "emr.thumbshow.csp";
    var iframeId= "thumbShowFrame";
    var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>";         
    createModalDialog(dialogId,"缩略图预览", 1300, 700,iframeId,iframeCotent,"");
}			
//增加图片缩略图，将缩略图转base64码
function addImgDiv(){  
	dialog.get_functionTypes("getFileBase64",imgPath, "","");
}
//缩略图显示
function loadPic(value){
	var container =document.getElementById('container');
	var newchild = document.createElement("div");
	newchild.setAttribute("style", "float:left");
	newchild.setAttribute("id", imgPath);
	//增加缩略图时默认把路径加入图片数组
	imgPathArray.push(imgPath);
	var index = imgPathArray.length ? imgPathArray.length-1 : 0;
	newchild.innerHTML = "<img width='105' height='85' src='data:image/jpeg;base64,"+value+"' onclick='openImage(this)' /></img><input class='hisui-checkbox' type='checkbox' checked value='"+index+"'/>";
	container.appendChild(newchild);	
	$.parser.parse(newchild);
}
//删除选中缩略图
function removeChecked(){
	$('#container div input').each(function(index,obj){
		if ($(obj).checkbox('getValue')) {
			var path =  imgPathArray[index];
			//删除文件，第2个参数：图片文件路径，第3，第4个参数为空
			if(path.indexOf("file:///") >= 0)
			{
				path = path.substr(8);
			}
			dialog.get_functionTypes("deleteFile", path, "", "");
						
			}
	});
	//删除本地文件后，删除缩略图
	removePic();
}
//删除缩略图
function removePic(){
	var container =document.getElementById('container');
	var picList = $("#container div");
	var delArr = [];
	$('#container div input').each(function(index,obj){
		if ($(obj).checkbox('getValue')) {
			container.removeChild(picList[index]);
			delArr.unshift(index);
		}
	})
	if(delArr.length>0){
		delArr.forEach(function(num){
			imgPathArray.splice(num,1);
		})
		delArr = [];
	}
}
//清空缩略图和本地图片
function removeAll(){
	for(var i=0;i<imgPathArray.length;i++){
		var path = imgPathArray[i];
		//删除文件，第2个参数：图片文件路径，第3，第4个参数为空
		if(path.indexOf("file:///") >= 0)
		{
			path = path.substr(8);
		}
		dialog.get_functionTypes("deleteFile", path, "", "");
	}
	document.getElementById('container').innerHTML = "";
	imgPathArray = [];
}
//全选
function checkAll(){
	$('#container div input').each(function(index,obj){
		$(obj).checkbox('check');
	})
}
//取消全选
function unCheckAll(){
	$('#container div input').each(function(index,obj){
		$(obj).checkbox('uncheck');
	})
}
//反选 
function toggleCheck(){
	$('#container div input').each(function(index,obj){
		if ($(obj)) {
			$(obj).checkbox('toggle');
		}
	})
}
function openSocket(){
	socket = new WebSocket(baseUrl);
    socket.onclose = function()
	{
		//console.error("web channel closed");
	};
	socket.onerror = function(error)
	{
		alert("高拍仪系统错误：" + error);
	};
	socket.onopen = function()
	{
      
        new QWebChannel(socket, function(channel) {
			// make dialog object accessible globally
			window.dialog = channel.objects.dialog;
			window.onunload = function() {
				
				window.returnValue="close";
				//删除本地文件
				removeAll();
				//发送关闭信号
				dialog.get_actionType("closeSignal");
				//关闭socket
				socket.close(); 
			}
			/***********设备状态更改（区分摄像头）*****************/
			//网页控件事件，主视频模式列表点击
			document.getElementById("priModelList").onchange = function() {
				//清除展示信息
				var resolutionList = document.getElementById("priResolutionList");
				resolutionList.options.length = 0;
				var select = document.getElementById("priModelList");
				dialog.devChanged("primaryDev_:" + select.value);
			};
			//网页控件事件，主视频分辨率列表点击
			document.getElementById("priResolutionList").onchange = function() {
				//清除展示信息
				var select = document.getElementById("priResolutionList");
				dialog.devChanged("primaryDev_:" + select.value);
			};
			//网页控件事件，副视频模式列表点击
			document.getElementById("subModelList").onchange = function() {
				//清除展示信息
				var resolutionList = document.getElementById("subResolutionList");
				resolutionList.options.length = 0;
				var select = document.getElementById("subModelList");
				dialog.devChanged("subDev_:" + select.value);
			};
			//网页控件事件，副视频分辨率列表点击
			document.getElementById("subResolutionList").onchange = function() {
				//清除展示信息
				var select = document.getElementById("subResolutionList");
				dialog.devChanged("subDev_:" + select.value);
			};
			//设置尺寸列表点击，只有主头有设置尺寸
			document.getElementById("setScanSize").onchange = function() {
				var select = document.getElementById("setScanSize");
				if(select.value == "原始尺寸")
				{
					dialog.get_actionType("setScanSize_ori");
				}
				if(select.value == "A5")
				{
					dialog.get_actionType("setScanSize_A5");
				}
				if(select.value == "卡片")
				{
					dialog.get_actionType("setScanSize_card");
				}
			};
			//打开主视频
			document.getElementById("openPriVideo").onclick = function() {
				var resolutionList = document.getElementById("priResolutionList");
				resolutionList.options.length = 0;
				var modelList = document.getElementById("priModelList");
				modelList.options.length = 0;
				var label1 = document.getElementById("lab1").innerHTML;
				dialog.devChanged("primaryDev_:" + label1);
			};
			//关闭主视频
			document.getElementById("closePriVideo").onclick = function() {
				dialog.get_actionType("closePriVideo");	
				var element = document.getElementById("bigPriDev");
				element.src = "";	
			};
			//主头拍照
			document.getElementById("photographPri").onclick = function() {
				dialog.photoBtnClicked("primaryDev_");
				dialog.get_actionType("savePhotoPriDev");
			};
			//打开副视频
			document.getElementById("openSubVideo").onclick = function() {
				var resolutionList = document.getElementById("subResolutionList");
				resolutionList.options.length = 0;
				var modelList = document.getElementById("subModelList");
				modelList.options.length = 0;
				var label1 = document.getElementById("lab2").innerHTML;
				dialog.devChanged("subDev_:" + label1);
			};
			//关闭副视频
			document.getElementById("closeSubVideo").onclick = function() {
				dialog.get_actionType("closeSubVideo");	
				var element = document.getElementById("bigSubDev");
				element.src = "";	
			};
			//副摄像头拍照按钮点击
			document.getElementById("photographSub").onclick = function() {
			
				dialog.photoBtnClicked("subDev_");
				dialog.get_actionType("savePhotoSubDev");
			};
			
			//左转
			document.getElementById("rotateLeft").onclick = function() {
				dialog.get_actionType("rotateLeft");
			};
			//右转
			document.getElementById("rotateRight").onclick = function() {
				dialog.get_actionType("rotateRight");
			};
			//删除本地文件
			document.getElementById("deleteFile").onclick = function() {
				//dialog.get_functionTypes("deleteFile", "C:\\Users\\Administrator\\Desktop\\eloamPhoto\\20180903-200102046.jpg", "", "");
				//dialog.get_functionTypes("deleteFile", "C:/Users/Administrator/Desktop/eloamPhoto/eeee.jpg", "", "");
					
				//删除缩略图
				removeChecked();
			};
			document.getElementById("uploadFile").onclick=function(){
				var sort = $("input[name='sort']:checked").val();
				if(sort==="" || sort===undefined){
					sort="DEFAULT"	
				}
				sort = sort.toUpperCase();
				var checkedLen = 0;
				$('#container div input').each(function(index,obj){
					if ($(obj).checkbox('getValue')) {
						checkedLen +=1;
					}
				});	
				if(checkedLen===0)
				{
					alert("请选择图片");
					return;
				}
				//限制只能上传50张图片
				if(PicMax=="")
				{
					PicMax=10;
				}
				if(checkedLen>PicMax)
				{
					alert("最多只能上传"+PicMax+"张图片");
					return;
				}
				var ftpUrl="ftp://dhcepr:dhcc$123@10.17.0.9"
				var DicNamePerNewOvertRoot="/picDoc";
				dialog.get_functionTypes("createFTPDir",ftpUrl,DicNamePerNewOvertRoot,"");
				var DicNamePerNewOver=DicNamePerNewOvertRoot+"/"+patientID;
				dialog.get_functionTypes("createFTPDir",ftpUrl,DicNamePerNewOver,"")
				var DicNamePerNew=DicNamePerNewOver+"/"+episodeID;
				dialog.get_functionTypes("createFTPDir",ftpUrl,DicNamePerNew,"")
				var DicName=DicNamePerNew+"/"+sort; 
				dialog.get_functionTypes("createFTPDir",ftpUrl,DicName,"")
				var flag = 1;
				$('#container div input').each(function(index,obj){
					if ($(obj).checkbox('getValue')) {
						var imgSrc = imgPathArray[index];
						var fileName =imgSrc.split("\\")[2];
					 	dialog.get_functionTypes("ftpUpload",ftpUrl,imgSrc,DicName+"/"+fileName);
						flag = SavePic(patientID,episodeID,DicName,fileName,sort,ftpUrl,userName);
					}
				});
				if(flag!=1){
					alert("上传失败");
					return
				}else{
					alert("上传成功");
				}

				//上传结束后，删除本地图片
				removeChecked();	
			}
			//服务器返回消息
			dialog.sendPrintInfo.connect(function(message) {
				//获取文件base64返回值
				if(message.indexOf("fileBase64:") >= 0)
				{
					var value = message.substr(11);
					loadPic(value);
					return;
				}
				/********主头设备信息***********/
				//设备名 priModel
				if(message.indexOf("priDevName:") >= 0)
				{
					message = message.substr(11);
					var label = document.getElementById("lab1");
					label.innerHTML = message;
				}
				//主头设备出图格式
				if(message.indexOf("priModel:") >= 0)
				{
					message = message.substr(9);
					var select = document.getElementById("priModelList");
					if(message.indexOf("MJPG") >= 0)
					{
						select.add(new Option(message), 0);									
					} else{
						select.add(new Option(message));
					}
					select.selectedIndex=0;
				}
				//主头设备分辨率
				if(message.indexOf("priResolution:") >= 0)
				{
					message = message.substr(14);
					var select = document.getElementById("priResolutionList");
					select.add(new Option(message));
					if(select.options.length > 2)
					{
						select.selectedIndex = 2;
					}
				}
				/********副头设备信息***********/
				//设备名
				else if(message.indexOf("subDevName:") >= 0)
				{
					message = message.substr(11);
					var label = document.getElementById("lab2");
					label.innerHTML = message;
				}
				//副头设备出图格式
				if(message.indexOf("subModel:") >= 0)
				{
					message = message.substr(9);
					var select = document.getElementById("subModelList");
					if(message.indexOf("MJPG") >= 0)
					{
						select.add(new Option(message), 0);									
					} else{
						select.add(new Option(message));
					}
					select.selectedIndex=0;
				}
				//副头设备分辨率
				if(message.indexOf("subResolution:") >= 0)
				{
					message = message.substr(14);
					var select = document.getElementById("subResolutionList");
					select.add(new Option(message));
					if(select.options.length > 2)
					{
						select.selectedIndex = 1;
					}
				}
				//图片保存后返回路径关键字savePhoto_success:
				else if(message.indexOf("savePhoto_success:") >= 0)
				{
					imgPath = message.substr(18);
					addImgDiv();
				}
			
			});
			//接收图片流用来展示，多个，较小的base64，主头数据
			dialog.send_priImgData.connect(function(message) {
				var element = document.getElementById("bigPriDev");
				element.src = "data:image/jpg;base64," + message;							
			});
			//接收图片流用来展示，多个，较小的base64，副头数据
			dialog.send_subImgData.connect(function(message) {
				var element = document.getElementById("bigSubDev");
				element.src = "data:image/jpg;base64," + message;							
			});
			//网页加载完成信号
			dialog.html_loaded("two");
		});
    }
}
function initData()
{ 
    RecordID=patientID;
    if(episodeID=="")
    {
        alert("就诊号为空,不能上传图片");
        return;
    }
 	var pictureSystem  = getPictureSystem();
 	ftpUrl = "ftp://"+pictureSystem["username"]+":"+pictureSystem["password"]+"@"+pictureSystem["server"];
 	if(pictureSystem['port']){
	 	ftpUrl = ftpUrl+":"+pictureSystem['port'];
	 }
    PicMax = pictureSystem['picmax'];
}

function getPictureSystem()
{
    var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.Ajax.pictureManage",
			"Method":"GetFtpValue"
		},
		success : function(d) {
			result = d;
		},
		error : function(d) { alert("getImageZoomRatio error");}
	});
	return result;
}
//保存图片信息
function SavePic(PatientID,EpisodeID,DicName,FileName,Sort,ftpUrl,UserName)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.Ajax.pictureManage",
			"Method":"SavePicture",
			"p1":PatientID,
			"p2":EpisodeID,
			"p3":DicName,
			"p4":FileName,
			"p5":Sort,
			"p6":ftpUrl,
			"p7":UserName,
			"p8":"Y"
		},
		success : function(d) {
			result = d;
		},
		error : function(d) { alert("getImageZoomRatio error");}
	});
	return result;
}


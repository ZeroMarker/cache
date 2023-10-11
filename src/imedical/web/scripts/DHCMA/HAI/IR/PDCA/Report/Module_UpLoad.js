//加载'文件框'基本界面
function InitPARepWinUpLoad(obj){
	//是否启用'文件上传功能'
	obj.IsOpenUpLoad= $m({	
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "PDCAUseUpLoad"
	}, false);
	
	obj.FileUrl="";				//已上传文件
	
	//1.初始化文件框
	obj.LoadUpLoad=function(UpLoadID){
		if(obj.IsOpenUpLoad!="1")return false;
		var fileName="";		//文件名
		//获取当前日期
		var NowDate = new Date();
		var Date_Day = NowDate.getDate();
   	 	var Date_Month = NowDate.getMonth() + 1; 
    	var Date_Year = NowDate.getFullYear();
    	var CurDate = Date_Year+""+Date_Month+""+Date_Day;
		
		//初始化文件框
		$("#"+UpLoadID).uploadify({
			buttonClass:"uploadify-button-a",
			buttonText:"上传文件",
			fileObjName:"FileStream",
			formData:{"fileName":fileName},
			removeCompleted:true,
			'uploader': "dhcma.hai.ir.pdca.upload.csp?dirname=\\DHCMA\\PDCA\\"+CurDate+"\\",
	   	 	'swf': '../scripts/DHCMA/HAI/IR/PDCA/Report/jqueryplugins/uploadify/uploadify.swf',
	    	'fileTypeExts':'*',			//不控制上传类型
	    	height:30,   
	    	width:100,
	    	auto:true,
	    	'onUploadComplete' : function(file) {},
	   		'onUploadSuccess' : function(file, data, response) {
		    	var FileUrl = $.parseJSON(data).fileFullName;		//文件路径
				var Length=FileUrl.split("/").length;
				var FileName=FileUrl.split("/")[Length-1];			//文件名
				
				if (FileUrl){
					var InputStr="^"+obj.RepID+"^"+UpLoadID+"^"+FileUrl+"^"+FileName+"^^^"+$.LOGON.USERID;
					if(obj.RepID!=""){
						var Flag = $m({ 
							ClassName: "DHCHAI.IR.PDCAFileUrl",
							MethodName: "Update",
							aInputStr:InputStr
						}, false);
						if(Flag>0){
							//加载'上传记录'
							obj.LoadRecord(UpLoadID);
							
							$.messager.alert("提示","上传数据成功！", 'info');
							return true;
						}
						else{
							$.messager.alert("提示","上传数据失败！", 'info');
							return true;
						}
					}
					else{
						//暂存'上传记录'
						obj.FileUrl=obj.FileUrl+"#"+InputStr;
						//加载'上传记录'
						obj.LoadRecord(UpLoadID);
					}
				}
				else{
					$.messager.alert("提示","上传数据失败！", 'info');
				}
			},
			'onUploadError' : function(file, errorCode, errorMsg, errorString) {},
			'onComplete': function (evt, queueID, fileObj, response, data) {},
	    	'multi': true                                 			//默认值true，是否允许多文件上传。
    	});
	}
	
	//3.加载'上传记录'
	obj.LoadRecord=function(UpLoadID){
		if(obj.RepID!=""){
			var DataList = $cm ({
				ClassName:"DHCHAI.IRS.PDCAFileUrlSrv",
				QueryName:"QryFileUrl",
				aRepID:obj.RepID,
				aTxtID:UpLoadID
			},false);
			var html="";
			for (var ind = 0; ind < DataList.total; ind++) {
        		var Data = DataList.rows[ind];

				var UrlID= Data.ID;
				var Path = Data.Path;
				var Name = Data.Name;
		
				if(ind!=0)var html=html+",";
				var html = html+"&nbsp;<a href='#' onclick=\"LoadFile('"+Path+"')\">"+Name+"</a>&nbsp;&nbsp;";
				var html = html+"<a href='#' onclick=\"DeleteFile('"+Path+"','"+Name+"')\"><span style='color:red;'>删除<\span></a>&nbsp;";
			}
			$("#txt"+UpLoadID).html(html);	
		}
		else{
			var html="";
			for (var ind = 0; ind < obj.FileUrl.split("#").length; ind++) {
        		var Data = obj.FileUrl.split("#")[ind];
        		if(Data=="")continue;

				var UrlID= Data.split("^")[2];
				var Path = Data.split("^")[3];
				var Name = Data.split("^")[4];
		
				if(ind!=0)var html=html+",";
				var html = html+"&nbsp;<a href='#' onclick=\"LoadFile('"+Path+"')\">"+Name+"</a>&nbsp;&nbsp;";
				var html = html+"<a href='#' onclick=\"DeleteFile('"+Path+"','"+Name+"')\"><span style='color:red;'>删除<\span></a>&nbsp;";
			}
			$("#txt"+UpLoadID).html(html);	
		}
	}
	
	//4.保存'上传记录'
	obj.SaveFileUrl=function(){
		for (var ind = 0; ind < obj.FileUrl.split("#").length; ind++) {
        	var Data = obj.FileUrl.split("#")[ind];
        	if(Data=="")continue;
			
			var Flag = $m({ 
				ClassName: "DHCHAI.IR.PDCAFileUrl",
				MethodName: "Update",
				aInputStr:Data
			}, false);
			if(Flag<0){
				$.messager.alert("提示","上传数据失败！", 'info');
				return false;
			}
		}
	}
	
}
//3.打开预览'文件'
function LoadFile(FileUrl){
	websys_createWindow(FileUrl)
}
//2.删除'FTP服务器文件'+'上传记录'
function DeleteFile(FileUrl,FileName){
	//删除服务器文件
	var FtpFlag= $m({ 
		ClassName: "DHCHAI.IRS.PDCAFileUrlSrv",
		MethodName: "DeleteFileUrl",
		aFileUrl:FileUrl,
		aFileName:FileName
	}, false);
	if(FtpFlag=="1"){
		if(obj.RepID!=""){
			//同步删除'上传记录'
			var UrlFlag = $m({ 
				ClassName: "DHCHAI.IRS.PDCAFileUrlSrv",
				MethodName: "DelUpLoadRecords",
				aRepID:obj.RepID,
				aFileName:FileName
			}, false);
			if(UrlFlag>=0){
				$.messager.alert("提示","删除成功！");
				return true;
			}
			else{
				$.messager.alert("提示","删除失败！");
				return true;
			}
		}
		else{
			//同步删除暂存'上传记录'
			var OldFileUrl=obj.FileUrl;
			obj.FileUrl="";
			for (var ind = 0; ind < OldFileUrl.split("#").length; ind++) {
        		var Data = OldFileUrl.split("#")[ind];
        		if(Data=="")continue;
        		if(FileName==Data.split("^")[4])continue;		//删除'文件'
        		obj.FileUrl=obj.FileUrl+"#"+Data;
			}
			$.messager.alert("提示","删除成功！");
			return true;
		}
	}
	else{
		$.messager.alert("提示","删除失败！");
		return false;
	}
}
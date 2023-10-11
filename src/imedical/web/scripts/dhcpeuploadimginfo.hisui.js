/*
 * FileName:    dhcpeuploadimginfo.hisui.js
 * Author:      ln
 * Date:        20230208
 * Description: 图片报告上传
 */
 
 $(function(){
	 
	//下拉列表框
	InitCombobox();
		
	var ComputeName=GetComputeInfo("IP");
	$("#ComputeName").val(ComputeName);
	
	//保存
	$("#BSave").click(function() {	
		BSave_click();		
     });
    
	//上传
	$("#BUpload").click(function() {	
		BUpload_click();		
     });
     
     var OtherInfo=tkMakeServerCall("web.DHCPE.UploadImgInfo","GetOtherInfo",ComputeName);
     if (OtherInfo!="")
     {
	     var Arr=OtherInfo.split("^");
	     $("#ItemName").combogrid('setValue',Arr[4]);
	     $("#ItemID").val(Arr[0]);
	     $("#ImgPath").val(Arr[1]);
	     $("#LastFileName").val(Arr[2]);
	     
	     if(Arr[3]=="1"){
				$("#ReadTxt").checkbox('setValue',true);
			}else{
				$("#ReadTxt").checkbox('setValue',false);
			}
     }
     
     SetWaitUploadInfo();
	 SetHadUpLoadUploadInfo();
     
})

function BSave_click()
{
	var obj,ComputeName="",ItemID="",ImgPath="",ReadTxt="0",LastFileName="";
	var ComputeName=$("#ComputeName").val();
	
	var ItemName=$("#ItemName").combogrid("getValue");
	if (ItemName == undefined || ItemName == "undefined") { var ItemName = ""; }
	if (ItemName==""){
		websys_setfocus("ItemName");
		$.messager.alert("提示","项目不能为空","info"); 
		return false;
	}
	
	var ImgPath=$("#ImgPath").val();
	if (ImgPath==""){
		websys_setfocus("ImgPath");
		$.messager.alert("提示","图片路径不能为空","info");
		return false;
	}
	var LastFileName=$("#LastFileName").val();
	if (LastFileName==""){
		websys_setfocus("LastFileName");
		$.messager.alert("提示","文件后缀名不能为空","info");
		return false;
	}
	
	//读取文本
	var ReadTxt=$("#ReadTxt").checkbox('getValue');
	if(ReadTxt) ReadTxt="1";
	
	//var OtherInfo=ItemID+"^"+ImgPath+"^"+LastFileName+"^"+ReadTxt;
	var OtherInfo=ItemName+"^"+ImgPath+"^"+LastFileName+"^"+ReadTxt;
	
	var NumType=""
	
	var ret=tkMakeServerCall("web.DHCPE.UploadImgInfo","SaveOtherInfo",ComputeName,OtherInfo,NumType);
	
	SetWaitUploadInfo();
}
function BUpload_click()
{
	var ImgPath="",ReadTxt="0",ItemName="",CurDate="";
	var ImgPath=$("#ImgPath").val();
	var CurOEID="";
	var obj=document.getElementById("OEID");
	if (obj) CurOEID=obj.value;
	
	if (CurOEID!=""){
		var obj=document.getElementById("CurDate");
		if (obj) CurDate=obj.value;
		var ImgPath=ImgPath+"/"+CurDate;
	}
	if (CurOEID!=""){
		var ListObj=document.getElementById("ErrFileName");
	}else{
		var ListObj=document.getElementById("UploadInfo");
	}
	var ListLength=ListObj.options.length;
	
	var HadListObj=document.getElementById("HadUploadInfo");
	obj=document.getElementById("ReadTxt");
	if (obj&&obj.checked) ReadTxt="1";
	obj=document.getElementById("ItemName");
	if (obj) ItemName=obj.value;
	var UserID=session["LOGON.USERID"];
	//alert(PhotoFtpInfo+"PhotoFtpInfo")
	var FTPArr=PhotoFtpInfo.split("^");
	var DeleteFlag="1";
	var SuccessFlag=1;
	if (ListLength==0){
		$.messager.alert("提示","没有待上传数据","info");
		return false;
	}	
	for (i=0;i<ListLength;i++){
		var ShortFileName=ListObj.options[i].text;
		var OEID=ListObj.options[i].value;
		
		//var FileName=ImgPath+"/"+ShortFileName;
		var FileName=ImgPath+"\\"+ShortFileName;  /// 新版客户端路径
		 
		 /*  客户端可以判断文件是否存在
		if ((PicFileIsExist(FileName)=="False")||((!PicFileIsExist(FileName)))){
			//alert(图片不存在);
			continue;
			
		}
		*/
		/*
		PEPhoto.FileName = FileName; //保存图片的名称包括后缀
		PEPhoto.AppName = FTPArr[4]+"/" //ftp目录
		PEPhoto.DBFlag = "0" //是否保存到数据库  0  1
		PEPhoto.FTPFlag = "1" //是否上传到ftp服务器  0  1
		PEPhoto.DBConnectString = "CN_IPTCP:172.26.201.11[1972]:websrc" //数据库服务器
		PEPhoto.FTPString = FTPArr[0]+"^"+FTPArr[1]+"^"+FTPArr[2]+"^"+FTPArr[3] //FTP服务器
		*/
		if (CurOEID!=""){
			if (i>0) DeleteFlag="0";
			FTPFileName=CurOEID+"-"+i
			OEID=CurOEID;
		}else{
			var Sort=tkMakeServerCall("web.DHCPE.UploadImgInfo","GetOESort",OEID)
			FTPFileName=OEID+"_"+Sort;
		}
		
		//alert(FTPFileName+"FTPFileName")
		//PEPhoto.PatientID = FTPFileName;  //eSrc.id;//PA_PatMas表的ID
		var LastFileName=$("#LastFileName").val();
		var FileTypeDesc="jpg";
		var obj=document.getElementById("LastFileName");
		if (obj) FileTypeDesc=obj.value;
		//PEPhoto.SaveFile(FileTypeDesc);  //对于已经存在图片保存到数据库同时上传FTP的标志有效
		
		/// /// UploadFtpInfo: ftp://peftp:rkgkGFVv@172.18.18.138:2121/cs1
		/// "172.18.18.150^peftp^GWBDLWHx^2121^dhccftp/peftp^300^200"
		var UploadFtpInfo="ftp://" + FTPArr[1] + ":" + FTPArr[2] + "@" + FTPArr[0] +":" + FTPArr[3] + "/" + FTPArr[4];
		var FileFrom=FileName;  //D:\\2.txt##D:\\1.gof
		
		var FileTo=FTPFileName+"."+FileTypeDesc;
		exec(UploadFtpInfo,FileFrom,FileTo);
		
		
		
		
		try{
			//if ((PicFileIsExist(FileName)=="False")||((!PicFileIsExist(FileName)))){
				/// 客户端异步回调可能需要修改客户端 先不判断文件是否存在了
			//if ((PicFileIsExist(FileName)=="true")||((PicFileIsExist(FileName)))){
				var SaveRet=tkMakeServerCall("web.DHCPE.UploadImgInfo","SaveUploadInfo",OEID,UserID,FTPFileName,DeleteFlag);
				
			//}
			HadListObj.options[i]=ListObj.options[i];
		}catch(e){}
		if (ReadTxt=="1"){
			var TxtFileName=ImgPath+"/"+ShortFileName.split(".")[0]+".txt";
			if (PicFileIsExist(TxtFileName)){
				if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
				var fso=new ActiveXObject("Scripting.FileSystemObject");
				var f=fso.opentextfile(TxtFileName,1,true,0);
				var ResultStr="";
				var Row=0
				while (!f.AtEndOfStream) 
				{ 
					Row=Row+1;
					var LineStr=f.Readline();
					//alert(LineStr+"LineStr")
					if (ItemName=="14碳呼气试验(各类呼气试验)"){
						if (LineStr.split("检测结果 :DPM=").length>1) ResultStr=LineStr;
					}else if(ItemName=="骨密度测定"){
						if ((Row=="18")||(Row=="19")||(Row=="22")||(Row=="24")||(Row=="26")||(Row=="27")||(Row=="30")||(Row=="32")||(Row=="34")||(Row=="51")||(Row=="52")||(Row=="54")||(Row=="56")||(Row=="57")||(Row=="58")||(Row=="60")){
							if (ResultStr==""){
								ResultStr=LineStr;
							}else{
								ResultStr=ResultStr+"^"+LineStr;
							}
						}
						
					}
				}
				f.close();
				if (ResultStr!="") fso.DeleteFile(TxtFileName,true); 
				if (ResultStr=="") continue;
				var SaveRet=tkMakeServerCall("web.DHCPE.UploadImgInfo","SaveResultInfo",OEID,UserID,ResultStr);
				if(SaveRet.indexOf("更新成功")>=0){
					var SuccessFlag=SuccessFlag+1;
				}

			}
			else{
				/// 启用中间件 谷歌
				var TxtFileNameNew=TxtFileName.replace(/\\/g,"\\\\")
			    var ResultStr="";
			    var Str = "(function test(x){"+
			    "var TestStr='';"+
			    "var   fso,   s   =   '"+TxtFileNameNew+"';"+
			    "var fso=new ActiveXObject('Scripting.FileSystemObject');"+
			    "var f=fso.opentextfile(s,1,true,0);"+
			    "TestStr=f.ReadAll();"+
			    "f.close();"+
			    "fso.DeleteFile(s,true); "+
			    "return TestStr"+
			    "}());";
			     CmdShell.notReturn = 0;
			     var rtn = CmdShell.EvalJs(Str);
			    var TextStr= rtn.rtn; /// 至此取到txt里的全部内容
			     var Char=String.fromCharCode(13,10);
			     var length=TextStr.split(Char).length;
			     for (i=0;i<length;i++){
				     var LineStr=TextStr.split(Char)[i]; /// 每行数据
				     
			    	if (ItemName=="14碳呼气试验(各类呼气试验)"){
						if (LineStr.split("检测结果 :DPM=").length>1) ResultStr=LineStr;
					}else if(ItemName=="骨密度测定"){
						if ((i=="18")||(i=="19")){
							if (ResultStr==""){
								ResultStr=LineStr;
							}else{
								ResultStr=ResultStr+"^"+LineStr;
							}
						}	
					}		
			    }
			    if (ResultStr=="") continue;
				var SaveRet=tkMakeServerCall("web.DHCPE.UploadImgInfo","SaveResultInfo",OEID,UserID,ResultStr);
				if(SaveRet.indexOf("更新成功")>=0){
					var SuccessFlag=SuccessFlag+1;
				} 
				
				
				
				}
			}
		}
	}
	
	/// 客户端异步回调方式 先提示操作完成
	 $.messager.popover({msg: "操作完成", type: "info"});


}
/// UploadFtpInfo: ftp://peftp:rkgkGFVv@172.18.18.138:2121
function exec(UploadFtpInfo,FileFrom,FileTo){
	var filePaths = FileFrom
	if(filePaths == ""){
		$.messager.alert("提示","本地文件必填","info");
		return;
	}
	var ftpParam ={
		business : "UPLOAD",
		transType : "FTPS",
		files : filePaths,
		fileNames : FileTo,
		delAftUpload : 1,
		serverPath : UploadFtpInfo 
	};
	var sftpParam ={
		business : "UPLOAD",
		transType : "SFTP",
		files : filePaths,
		fileNames : $("#FileNames").val(),
		serverPath : "",
		delAftUpload : 0,
		login : {
			host : "172.18.18.138",
			port : 2121,
			userName : "peftp",
			password : "rkgkGFVv"
		}
	};
	var json = JSON.stringify(ftpParam); 
	//console.log("客户端入参："+json)
	$("#ExecParam").html(json);
	$("#RtnMsg").val('');
	$PESocket.sendMsg(json,peSoceket_onMsg);
}


function peSoceket_onMsg(param,event)
{
	console.log(param)
	console.log(event)
	var paramObj = JSON.parse(param);
	var FileName = paramObj.files;
	$("#RtnMsg").val(event.data);
	var retObj = JSON.parse(event.data);
	if(retObj.code == "0"){

	}else{
		$.messager.alert("提示","【"+FileName+"】上传失败:<br><span style='color:red;font-weight:600;'>"+ retObj.msg+"</span>","info");
	}
}
function SetWaitUploadInfo()
{
	var obj,ImgPath="",OEID="",CurDate="";
	var ImgPath=$("#ImgPath").val();
	if (ImgPath=="") return false;
	var OEID=$("#OEID").val();
	if ((OEID!="")&&(OEID!=undefined)){
		var CurDate=$("#CurDate").val();
		var ImgPath=ImgPath+"/"+CurDate;
	}
	
	
	var LastFileName=$("#LastFileName").val();
	//var ItemID=$("#ItemName").combogrid("getValue");
	var ItemID=$("#ItemID").val();
	var Str = "(function test(x){"+
	"var fso = new ActiveXObject('Scripting.FileSystemObject');"+
	"var f = fso.GetFolder('"+ImgPath+"');"
	var Str = Str+"var fc = new Enumerator(f.Files);"+
	"var FileNameStr=''; "+
	"var i=0;"+
	"for (; !fc.atEnd(); fc.moveNext())"+ 
    "{"+
	"    	var OneFileName=fc.item().Name;"+
	 "   	if (FileNameStr==''){"+
		"	    FileNameStr=OneFileName;"+
	    "	}else{"+
		"	    FileNameStr=FileNameStr+'^'+OneFileName;"+
	    "	}"+
	    "}"+
	    "return FileNameStr;}());";
        //alert(Str+"Str")
           //console.log(Str)
      //以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 0;   //设置无结果调用，不阻塞调用
	  // debugger; //
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		var FileNameStr=rtn.rtn
    if (FileNameStr=="") return false;
    //alert(FileNameStr+"FileNameStr")

    var OEIDInfo=tkMakeServerCall("web.DHCPE.UploadImgInfo","GetOEIDInfo",ItemID,FileNameStr,LastFileName);
    if (OEIDInfo=="") return false;
	var C1=String.fromCharCode(1);
	var C2=String.fromCharCode(2);
	var Arr=OEIDInfo.split(C2);
	var FileInfo=Arr[0];
	var ErrFileInfo=Arr[1];
	WaitsetData(FileInfo, 0, WaitUploadInfoGrid.getData());
	ErrsetData(ErrFileInfo, 0, ErrFileNameGrid.getData());
	
}
function WaitsetData(OneFile, i, OldData) 
{
	var obj = OneFile[i];
	var jsonObj = new Object();
	jsonObj.OEID=obj.OEID;
	jsonObj.OneFileName=obj.OneFileName;
	OldData.rows.push(jsonObj);
	
	if (i == (OneFile.length - 1)) {
		WaitUploadInfoGrid.loadData(OldData);
	} else {
		if (i % interval_num == 0) {
			$("#LoadMsg").html("填充数据：<font color='red'> " + (i + 1) + "</font>/" + OneFile.length);
			// onsole.log($("#LoadMsg").html());
		}
		setTimeout(function() {
			WaitsetData(OneFile, i + 1, OldData);
		}, 0);
	}
}
function ErrsetData(OneFile, i, OldData) 
{
	var obj = OneFile[i];
	var jsonObj = new Object();
	jsonObj.OEID=obj.OEID;
	jsonObj.OneFileName=obj.OneFileName;
	OldData.rows.push(jsonObj);
	
	if (i == (OneFile.length - 1)) {
		ErrFileNameGrid.loadData(OldData);
	} else {
		if (i % interval_num == 0) {
			$("#LoadMsg").html("填充数据：<font color='red'> " + (i + 1) + "</font>/" + OneFile.length);
			// onsole.log($("#LoadMsg").html());
		}
		setTimeout(function() {
			ErrsetData(OneFile, i + 1, OldData);
		}, 0);
	}
}
function HadsetData(OneFile, i, OldData) 
{
	var obj = OneFile[i];
	var jsonObj = new Object();
	jsonObj.OEID=obj.OEID;
	jsonObj.OneFileName=obj.OneFileName;
	OldData.rows.push(jsonObj);
	
	if (i == (OneFile.length - 1)) {
		HadUpLoadInfoGrid.loadData(OldData);
	} else {
		if (i % interval_num == 0) {
			$("#LoadMsg").html("填充数据：<font color='red'> " + (i + 1) + "</font>/" + OneFile.length);
			// onsole.log($("#LoadMsg").html());
		}
		setTimeout(function() {
			HadsetData(OneFile, i + 1, OldData);
		}, 0);
	}
}

function SetHadUpLoadUploadInfo()
 {
	 var ItemID=""
	 var obj=document.getElementById("ItemID");
	 if (obj) ItemID=obj.value;
	 var HadUpLoadInfos=tkMakeServerCall("web.DHCPE.UploadImgInfo","GetHadUpLoadInfos",ItemID)
	 HadsetData(HadUpLoadInfos, 0, HadUpLoadInfoGrid.getData());
	 
	 /*var infos=HadUpLoadInfos.split("^");
	 	var FileLength=infos.length
	 	var HadListObj=document.getElementById("HadUploadInfo");
	 	for (var i=0;i<FileLength;i++){
			OneFile=infos[i];
		
			HadListObj.options[i] = new Option(OneFile,"");
	 	}*/
	 
}

function InitCombobox()
{
	//体检项目-多院区
	var ItemNameObj=$HUI.combogrid("#ItemName", {
		panelWidth:450,
		panelHeight:245,
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationOrder",
		idField:'id',
		textField:'desc',
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="F";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		},
        onShowPanel:function()
		{
			$('#ItemName').combogrid('grid').datagrid('reload');
		},		
		columns:[[
			{field:'Code',title:'编码',width:80},
			{field:'desc',title:'名称',width:180},
			{field:'id',title:'ID',width:80}         		
		]]

	});
}
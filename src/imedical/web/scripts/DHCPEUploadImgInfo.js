//DHCPEUploadImgInfo
var FileNameStr="";
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj;

	var ComputeName=GetComputeInfo("");
	obj=document.getElementById("ComputeName");
	if (obj) obj.value=ComputeName;
	var OtherInfo=tkMakeServerCall("web.DHCPE.UploadImgInfo","GetOtherInfo",ComputeName);

	if (OtherInfo!=""){
		var Arr=OtherInfo.split("^");
		obj=document.getElementById("ItemID");
		if (obj) obj.value=Arr[0];
		obj=document.getElementById("ItemName");
		if (obj) obj.value=Arr[4];
		obj=document.getElementById("ImgPath");
		if (obj) obj.value=Arr[1];
		obj=document.getElementById("LastFileName");
		if (obj) obj.value=Arr[2];
		
		var ReadTxt=Arr[3];
		obj=document.getElementById("ReadTxt");
		if ((ReadTxt=="1")&&(obj)) obj.checked=true;
	}
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	
	obj=document.getElementById("BUpload");
	if (obj) obj.onclick=BUpload_click;
	SetWaitUploadInfo();

}
function ItemInfo(value) {
	if (value=="") return;
    var tmp=value.split("^")
    var obj=document.getElementById('ItemID');
    obj.value=tmp[1];
    var obj=document.getElementById('ItemName');
    obj.value=tmp[0]
 }
function BSave_click()
{
	var obj,ComputeName="",ItemID="",ImgPath="",ReadTxt="0",LastFileName="";
	obj=document.getElementById("ComputeName");
	if (obj) ComputeName=obj.value;
	obj=document.getElementById("ItemID");
	if (obj) ItemID=obj.value;
	if (ItemID==""){
		websys_setfocus("ItemName");
		alert("项目不能为空");
		return false;
	}
	obj=document.getElementById("ImgPath");
	if (obj) ImgPath=obj.value;
	if (ImgPath==""){
		websys_setfocus("ImgPath");
		alert("图片路径不能为空");
		return false;
	}
	obj=document.getElementById("LastFileName");
	if (obj) LastFileName=obj.value;
	if (LastFileName==""){
		websys_setfocus("LastFileName");
		alert("文件后缀名不能为空");
		return false;
	}
	
	
	obj=document.getElementById("ReadTxt");
	if (obj&&obj.checked) ReadTxt="1";
	var OtherInfo=ItemID+"^"+ImgPath+"^"+LastFileName+"^"+ReadTxt;
	var ret=tkMakeServerCall("web.DHCPE.UploadImgInfo","SaveOtherInfo",ComputeName,OtherInfo);
	
	SetWaitUploadInfo();
}
function BUpload_click()
{
	var ImgPath="",ReadTxt="0",ItemName="",CurDate="";
	var obj=document.getElementById("ImgPath");
	if (obj) ImgPath=obj.value;
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
			
	for (i=0;i<ListLength;i++){
		var ShortFileName=ListObj.options[i].text;
		var OEID=ListObj.options[i].value;
		var FileName=ImgPath+"/"+ShortFileName;
		if (!PicFileIsExist(FileName)){
			//alert(图片不存在);
			continue;
			
		}
		PEPhoto.FileName = FileName; //保存图片的名称包括后缀
		PEPhoto.AppName = FTPArr[4]+"/" //ftp目录
		PEPhoto.DBFlag = "0" //是否保存到数据库  0  1
		PEPhoto.FTPFlag = "1" //是否上传到ftp服务器  0  1
		PEPhoto.DBConnectString = "CN_IPTCP:172.26.201.11[1972]:websrc" //数据库服务器
		PEPhoto.FTPString = FTPArr[0]+"^"+FTPArr[1]+"^"+FTPArr[2]+"^"+FTPArr[3] //FTP服务器
		if (CurOEID!=""){
			if (i>0) DeleteFlag="0";
			FTPFileName=CurOEID+"-"+i
			OEID=CurOEID;
		}else{
			FTPFileName=OEID;
		}
		PEPhoto.PatientID = FTPFileName;  //eSrc.id;//PA_PatMas表的ID
		PEPhoto.SaveFile("jpg") //对于已经存在图片保存到数据库同时上传FTP的标志有效
		//alert(PEPhoto.FTPString)
		try{
			if (!PicFileIsExist(FileName)){
				//上传成功后记录已上传图片
				var SaveRet=tkMakeServerCall("web.DHCPE.UploadImgInfo","SaveUploadInfo",OEID,UserID,FTPFileName,DeleteFlag);
				
			}
			//HadListObj.options[i]=ListObj.options[i];
		}catch(e){}
		if (ReadTxt=="1"){
			var TxtFileName=ImgPath+"/"+ShortFileName.split(".")[0]+".txt";
			if (PicFileIsExist(TxtFileName)){
				var fso=new ActiveXObject("Scripting.FileSystemObject");
				var f=fso.opentextfile(TxtFileName,1,true,0);
				var ResultStr="";
				var Row=0
				while (!f.AtEndOfStream) 
				{ 
					Row=Row+1;
					var LineStr=f.Readline();
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
				
			}
		}
	}
	if (CurOEID!=""){
		window.close();	
	}else{
		alert("操作完成");
	}
}

function SetWaitUploadInfo()
{
	var obj,ImgPath="",OEID="",CurDate="";
	obj=document.getElementById("ImgPath");
	if (obj) ImgPath=obj.value;
	if (ImgPath=="") return false;
	var obj=document.getElementById("OEID");
	if (obj) OEID=obj.value;
	if (OEID!=""){
		var obj=document.getElementById("CurDate");
		if (obj) CurDate=obj.value;
		var ImgPath=ImgPath+"/"+CurDate;
	}
	//alert(ImgPath)
	obj=document.getElementById("LastFileName");
	if (obj) LastFileName=obj.value;
	//LastFileName=LastFileName.toUpperCase();
	
	obj=document.getElementById("ItemID");
	if (obj) ItemID=obj.value;
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	//ImgPath=ImgPath+"/"
	var f = fso.GetFolder(ImgPath); 
	var fc = new Enumerator(f.Files);
	var FileNameStr="";  
	//以下内容是显示文件名 
	var i=0; 
	for (; !fc.atEnd(); fc.moveNext())  
    {
	    try{
	    	var OneFileName=fc.item().Name;
	    	if (FileNameStr==""){
			    FileNameStr=OneFileName;
	    	}else{
			    FileNameStr=FileNameStr+"^"+OneFileName;
	    	}
	    }catch(e)
	    {}
	    
    }
    if (FileNameStr=="") return false;
    var OEIDInfo=tkMakeServerCall("web.DHCPE.UploadImgInfo","GetOEIDInfo",ItemID,FileNameStr,LastFileName);
    if (OEIDInfo=="") return false;
	var C1=String.fromCharCode(1);
	var C2=String.fromCharCode(2);
	var Arr=OEIDInfo.split(C2);
	var FileInfo=Arr[0];
	var ErrFileInfo=Arr[1];
	if (FileInfo!=""){
		ListObj=document.getElementById("UploadInfo");
		var Arr=FileInfo.split(C1);
		var FileLength=Arr.length;
		for (var i=0;i<FileLength;i++){
			OneFile=Arr[i];
			var OneArr=OneFile.split("^");
			ListObj.options[i] = new Option(OneArr[1],OneArr[0]);
    	}
	}
	
	if (ErrFileInfo!=""){
		ErrListObj=document.getElementById("ErrFileName");
		var Arr=ErrFileInfo.split(C1);
		var FileLength=Arr.length;
		for (var i=0;i<FileLength;i++){
			OneFile=Arr[i];
			var OneArr=OneFile.split("^");
			ErrListObj.options[i] = new Option(OneArr[1],OneArr[0]);
    	}
	}
}



function GetFileExt(str) 
{ 
	var d=/\.[^\.]+$/.exec(str); 
	return d; 
}
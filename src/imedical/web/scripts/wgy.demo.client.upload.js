/**
 * Demoy演示  wgy.demo.client.upload.js
 * @Author   wangguoying
 * @DateTime 2021-02-24
 */

function exec(){
	var filePaths = $("#FilePaths").val();
	if(filePaths == ""){
		$.messager.alert("提示","本地文件必填","info");
		return;
	}
	var ftpParam ={
		business : "UPLOAD",
		transType : "FTP",
		files : filePaths,
		fileNames : $("#FileNames").val(),
		delAftUpload : 0,
		serverPath : "ftp://DHCPE:DHCPE@127.0.0.1:21/中文路径" 
	};
	var sftpParam ={
		business : "UPLOAD",
		transType : "SFTP",
		files : filePaths,
		fileNames : $("#FileNames").val(),
		serverPath : "中文路径",
		delAftUpload : 0,
		login : {
			host : "127.0.0.1",
			port : 22,
			userName : "dhc",
			password : "dhc"
		}
	};
	var json = JSON.stringify(sftpParam); 
	$("#ExecParam").html(json);
	$("#RtnMsg").val('');
	$PESocket.sendMsg(json,peSoceket_onMsg);
}


function peSoceket_onMsg(param,event)
{
	var paramObj = JSON.parse(param);
	var FileName = paramObj.files;
	$("#RtnMsg").val(event.data);
	var retObj = JSON.parse(event.data);
	if(retObj.code == "0"){

	}else{
		$.messager.alert("提示","【"+FileName+"】上传失败:<br><span style='color:red;font-weight:600;'>"+ retObj.msg+"</span>","info");
	}
}


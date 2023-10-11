///Creator:qqa
///CreatDate:2019-04-18
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var lgUserCode = session['LOGON.USERCODE'];
var lgSessionID = session['LOGON.SSUSERLOGINID'];
var baseUrl="http://82.156.2.141:8023";
$(function(){
	
	initParams();  
	
	initPage();
	
	initCombobox();
	
	initTable();
	
	initWindow();
	
	initMethod();
	
	openWebSocket();
	
	writeTxtFile();
})

function writeTxtFile(){
	var fileName=lgUserCode+"^"+lgSessionID+".txt";
	writeText(fileName,"mdtcheckin^会诊签到");
}

function initWindow(){
	$HUI.window("#userWin",{
		onClose:function(){
			clearAddSureUser();
		}
	})
}

function initMethod(){
	$('#code').on('keypress', function(e){
		e=e||event;
		if(e.keyCode=="13"){
			getMemberDetails();
		}
	});	
}

function getMemberDetails(){
	var memberJobNum=$('#code').val();
	if(!$.trim(memberJobNum)) return;
	$.cm({ 
		ClassName:"DHCDoc.GetInfo.Service.FaceAuthentication",
		MethodName:"GetMemberDetailsByJobNum",
		"MemberJobNum":memberJobNum
	},function(jsonRet){
		if(jsonRet.code==="0"){
			$("#addUserId").val(jsonRet.data.memberId);
			$("#name").val(jsonRet.data.memberName);
			$("#code").val(jsonRet.data.memberJobNum);
			$("#pos").val(jsonRet.data.memberPosition);
			if(jsonRet.data.memberGender){
				$HUI.radio("input[name='gender'][value="+jsonRet.data.memberGender+"]").setValue(true);
			}
			
			$("#cardNum").val(jsonRet.data.memberCardNum);
			$("#mobile").val(jsonRet.data.memberMobile);
			$("#idenCard").val(jsonRet.data.identityCard);
			$HUI.validatebox("#mobile").isValid();
			$HUI.validatebox("#idenCard").isValid();
			$("#addUserImg").attr("data-verifyfaceurl",jsonRet.data.verifyFaceUrl);
			$("#addUserImg").attr("src",baseUrl+jsonRet.data.verifyFaceUrl);
			$("#addUserId").val(jsonRet.data.memberId);
			return;
		}else{
			$.messager.alert("提示",jsonRet.errorMessage);
			//clearAddSureUser();
			return;	
		}
	})
}


function initParams(){
	CstID = getParam("ID");              /// 会诊ID
	var RetData=$.cm({ 
		ClassName:"web.DHCMDTMatReview",
		MethodName:"GetPageData",
		MdtID:CstID,
		LgParams:LgParams,
		dataType:"text"
	}, false);
	var RetDataArr=RetData.split("^");
	///联络人
	IsContact=RetDataArr[1];
	ConsSatatus=RetDataArr[0];
	IsConsExperts=RetDataArr[2];
}

function initPage(){
	if(SingnIn!=1){
		$('#mainLayout').layout('hidden','north');	
	}
	
	if((IsContact!="Y")&&(SIGNJUR=="1")){
		$.messager.alert("提示","非联络人无权限进行签到操作!","info",function(){
			window.parent.$("#mdtPopAccWin").length?window.parent.$("#mdtPopAccWin").window("close"):"";
			window.parent.$("#mdtWin").length?window.parent.$("#mdtWin").window("close"):"";
		});
		return;		
	}
	
	timeClock();
}

function initCombobox(){
	$HUI.combobox("#userLoc",{
		url:$URL+"?ClassName=web.DHCMDTConssignIn&MethodName=GetLoginLocList",
		valueField:'id',
		textField:'text'	
	})	
}

function initTable(){
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
    ///  定义columns
	var columns=[[
		{field:'PrvTpID',title:'职称ID',width:100,hidden:true},
		{field:'PrvTp',title:'职称',width:100,hidden:true},
		{field:'HosID',title:'HosID',width:100,hidden:true},
		{field:'HosType',title:'院内院外',width:110,align:'center'},
		{field:'LocID',title:'科室ID',width:100,hidden:true},
		{field:'LocDesc',title:'科室',width:100,align:'center'},
		{field:'MarID',title:'亚专业ID',width:100,hidden:true},
		{field:'MarDesc',title:'亚专业',width:100,hidden:true},
		{field:'UserID',title:'医生ID',width:110,hidden:true},
		{field:'UserName',title:'医生',width:120,align:'center'},
		{field:'UserPas',title:'密码',width:100,formatter:setInput,align:'center'},
		{field:'ConssignInDateTime',title:'签到时间',width:120,align:'center'},
		{field:'Op',title:"操作",width:100,align:'center',formatter:setConIn}
	]];
  
	$HUI.datagrid('#docListTable',{
		url: $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID,
		toolbar:"",
		fit:true,
		border:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		headerCls:"panel-header-gray",
		pageSize:60,  
		pageList:[60], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:false,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'', 
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			
		},
		onDblClickRow:function(index,row){
			
		},
		onLoadSuccess:function(data){
			showQRCodeConIn(data.rows);
			/// 签到方式：1、无需验证密码；其他、验证密码；
			if (SignType == 1){
				$("#docListTable").datagrid('hideColumn','UserPas');
			}
		}
    })			
}

function showQRCodeConIn(datas){
	$("#qrCodeConInDiv").html("");

	for(i in datas){
		addQRCode(datas[i].UserName);
	}
	return;
}

function addQRCode(name){
	if(name=="") return;
	var html="";
	html+='<div class="imgDivItm">';
	html+=	'<div class="imgItm">';
	html+=		'<img class="imgView" style="width:150px;height:150px" src="../scripts/dhcnewpro/images/Nurse_implementPrint.png"/>';
	html+=	'</div>';
	html+=	'<div class="imgDocName">'+name+'</div>';
	html+='</div>';
	$("#qrCodeConInDiv").append(html);
	return;
}

/// 链接
function setInput(value, rowData, rowIndex){
	var isConssignIn = rowData.IsConssignIn;
	var html = "";
	if(isConssignIn!=1){
		html = "<input type='password' index="+rowIndex+" class='hisui-validatebox validatebox-text' style='width:95%' />";
	}else{
		html = "***"
	}
	return html;
}


function setConIn(value, rowData, rowIndex){
	var html = "";
	var cstItmID = rowData.itmID;  //这个UserID是CareProvID
	var isConssignIn = rowData.IsConssignIn;
	if(isConssignIn!=1){
		 html = "<a href='javascript:void(0)' onclick='conssignIn(\""+cstItmID+"\","+rowIndex+")'>"+$g("签到")+"</a>";
	}else{
		html = "√"
	}
	return html;
}


function conssignIn(cstItmID,rowIndex){
	var password = $("input[index="+rowIndex+"]").val();
	if(password==""){
		if(SignType!=1){
			$.messager.alert("提示","密码不能为空!");
			return;	
		}
	}
	
	sign(cstItmID,password,SignType);
	return;
	
	runClassMethod("web.DHCMDTConssignIn","UserConssignIn",{"CstItmID":cstItmID,"Password":password,"SignType":SignType,"LgUserID":LgUserID},function(retData){
		var retDataArr=retData.split("^");
		var ret=retDataArr[0];
		var isConsInAll=retDataArr[1];
		if(ret==0) {
			$.messager.alert("提示","签到成功！");
			$HUI.datagrid('#docListTable').load({
				ID:CstID
			})
			
			///全部签到刷新
			if(isConsInAll==1){
				parentQryConsList();
			}
			return;	
		}
		
		
		
		if(ret!=0){
			$.messager.alert("提示",ret);
			return;	
		}
	},'text')
}

function parentQryConsList(){
	if(window.parent){
		///会诊执行
		if(window.parent.qryConsList){
			window.parent.qryConsList();
		}
		///中心查询
		if(window.parent.QryPatList){
			window.parent.QryPatList();
		}	
	}	
}

function signByUserCode(userCode){
	$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"GetCstItmIdByUserCode",
		"ID":CstID,
		"UserCode":userCode,
		dataType:"text"
	},function(retData){
		var code=retData.split("^")[0];
		var cstItmID=retData.split("^")[1];
		if (code != 0){
			$.messager.alert("提示",retData,"warning");
		}else{
			sign(cstItmID,"",1);
		}	
	})
}

function sign(cstItmID,password,sType){
	runClassMethod("web.DHCMDTConssignIn","UserConssignIn",{"CstItmID":cstItmID,"Password":password,"SignType":sType,"LgUserID":LgUserID},function(retData){
		
		var retDataArr=retData.split("^");
		var ret=retDataArr[0];
		var isConsInAll=retDataArr[1];
		
		if(ret==0) {
			$.messager.alert("提示","签到成功！","info",function(){
				closeWin();
			});
			
			$HUI.datagrid('#docListTable').load({
				ID:CstID
			})
			
			//var userId=$("#userName").attr("userId");
			//showFaceText("",userId);
			return;	
		}
		if(ret!=0){
			if(ret==-1){
				$.messager.alert("提示","密码不正确!");
			}else if(ret==-2){
				$.messager.alert("提示","没有医生信息，无法签到！");
			}else if(ret==-3){
				$.messager.alert("提示","密码格式错误！");
			}else if(ret==-99){
				$.messager.alert("提示","非发送状态不予许签到！");
			}else{
				$.messager.alert("提示","插入日志错误！");
			}
			
			return;	
		}
	},'text')	
}

function signIn(){
	$HUI.window("#signInWin").open();
}

//获取时间函数
function timeClock(){
	    var today = new Date();
	    var year = today.getFullYear();
	    var month = today.getMonth()+1;
	    var day = today.getDay();
	    var hour = today.getHours();
	    var minute = today.getMinutes();
	    var second = today.getSeconds();

	    minute = checkTime(minute);
	    second = checkTime(second);

	    document.getElementById("time").innerHTML =
	    // "当前时间:"+year+"年"+month+"月"+day+"日 "+
	    "<p style='font-size:30px;color:#4169E1'>"+hour+":"+minute+":"+second+"</p>";
	    t = setTimeout("timeClock()",500);	    	   	    
}
//调整时间格式
function checkTime(i) {
	    if(i<10){
	        i="0"+i;
	    }
	    return i;
}

function openWebSocket(){
	//使用websoket通讯
	var wsUrl = ((window.location.protocol == "https:")?"wss:":"ws:")+"//"+window.location.host+
					"/imedical/web/web.DHCMDTWebSocketServer.cls"; //UnRead是标识未读数字的ws
	var ws = new WebSocket(wsUrl);
	if(parent) parent.ws=ws;
	
	ws.onopen  = function(event) {
		console.log("socket connected!");
	};
	
	ws.onmessage = function(event) {
		var data=event.data;
		console.log(data);
		if(data.indexOf("medConSign")!=-1){
			signByUserCode(data.split("^")[1]);
		}else{
			sureDocMes(data);
		}
	};
	
	ws.onerror = function(event) {
		
	};
	
	ws.onclose = function(event) {
		console.log("closed!");
	};
}

function sureDocMes(data){
	$HUI.window("#sureDocMes").open();
	var retObj=$.parseJSON(data);

	var imgUrl=retObj.snapFaceUrl;
	var userName=retObj.memberName;
	var userCode=retObj.jobNum;
	$("#userImg").attr("src",baseUrl+imgUrl);
	showFaceText(userCode,"");
}

function reloadUserLoginLoc(userId){
	var unitUrl=$URL+"?ClassName=web.DHCMDTConssignIn&MethodName=GetLoginLocList&UserID="+userId
	$("#userLoc").combobox('reload',unitUrl);
}

function addCstDoc(){
	var locId = $HUI.combobox("#userLoc").getValue();
	if(!locId){
		$.messager.alert("提示","科室不能为空!");
		return;
	}
	var userCareProvId = $("#userName").attr("userCareProvID");
	var userId=$("#userName").attr("userId");
	var prvTpId = $("#userPrvTp").attr("userPrvTpId");
	var mLocParams = locId+"^"+userCareProvId+"^"+prvTpId;
	
	$.cm({ 
		ClassName:"web.DHCMDTConsult",
		MethodName:"InsLocParams",
		"mdtIds":CstID,
		"mLocParams":mLocParams,
		dataType:"text"
	},function(ret){
		if (ret < 0){
			$.messager.alert("提示","保存失败，失败原因:"+jsonString,"warning");
		}else{
			$HUI.datagrid('#docListTable').reload();
			showFaceText("",userId);
		}	
	})
}

function showFaceText(userCode,userId){
	$HUI.linkbutton("#sureBtn").enable();
	$.cm({ 
		ClassName:"web.DHCMDTConssignIn",
		MethodName:"GetUserCstData",
		"CstID":CstID,
		"UserCode":userCode,
		"UserId":userId,
		dataType:"text"
	},function(ret){
		var retSuc=ret.split(",")[0];
		var retSucCode=retSuc.split("^")[0];
		var retSucDesc=retSuc.split("^")[1];
		if(retSucCode!="0"){
			$HUI.linkbutton("#sureBtn").disable();
			$("#userInfoTip").hide();
			$("#errTip").show();
			$("#errMes").html(retSucDesc);
			if(retSucCode=="-2"){
				var userData=ret.split(",")[1];
				$HUI.combobox("#userLoc").setValue("");
				$("#userName").attr("userId",userData.split("^")[0]);
				$("#userName").attr("userCareProvID",userData.split("^")[4]);
				$("#userName").val(userData.split("^")[1]);
				$("#userPrvTp").attr("userPrvTpId",userData.split("^")[2]);
				$("#userPrvTp").val(userData.split("^")[3]);
				reloadUserLoginLoc(userData.split("^")[0]);
				$("#addDoc").show();
			}else{
				$HUI.combobox("#userLoc").setValue("");
				$("#userName").val("");
				$("#userPrvTp").val("");
				$("#addDoc").hide();	
			}
		}else{
			$("#userInfoTip").show();
			$("#errTip").hide();
			var cstDocData=ret.split(",")[2];
			$("#userInfo").attr("CstItmId",cstDocData.split("^")[3]);
			$("#userInfo").html("<span style='font-size: 18px;font-weight: 500;'>科室:</span>"+
								cstDocData.split("^")[0]+"<br/><span style='font-size: 18px;font-weight: 500;'>职称:</span>"+
								cstDocData.split("^")[1]+"<br/><span style='font-size: 18px;font-weight: 500;'>职称:</span>"+
								cstDocData.split("^")[2]);
			if(cstDocData.split("^")[4]==1){
				$("#signTipMes").html("已签到");
				$HUI.linkbutton("#sureBtn").disable();
			}else{
				$("#signTipMes").html("核对无误后,点击确定完成签到!");
			}
		}
	});	
}

function surSign(){
	var itmId=$("#userInfo").attr("CstItmId");
	if(!itmId){
		$.messager.alert("提示","未匹配到对应的会诊信息!");
		return;
	}
	sign(itmId,"","1");
}

function closeWin(){
	$HUI.window("#sureDocMes").close();	
}

function showUserWin(){
	$HUI.window("#userWin").open();		
}

function photo(){
	var jobNum=Date.parse(new Date());
	$.cm({ 
		ClassName:"DHCDoc.GetInfo.Service.FaceAuthentication",
		MethodName:"ExtractNotice",
		"JobNum":jobNum
	},function(jsonRet){
		if(jsonRet.code==="0"){
			var queryKey=jsonRet.data.queryKey;
			loadingShowOrHide("show");
			showImgCount=0;
			getPhotoImg(jobNum,queryKey);
		}else{
			$.messager.alert("提示","服务调起失败!");
			return;	
		}
	})	
}

function getPhotoImg(jobNum,queryKey){
	if(showImgCount>30){
		loadingShowOrHide("hide");
		$.messager.alert("提示","失败!");
		return;	
	}
	setTimeout(function(){
		showImgCount++;
		$.cm({ 
			ClassName:"DHCDoc.GetInfo.Service.FaceAuthentication",
			MethodName:"QueryExtractFeatureResult",
			"JobNum":jobNum
		},function(jsonRet){
			//{"code":"0","message":"OK","data":{"extractResut":{"4c983516-0560-417f-81f5-7b714891f13a":{"expireTime":1634366955051,"status":1,"verifyFaceUrl":"/faceimg/2021101616343669275668384-image.png","memberJobNum":null,"orgId":1,"eigenvalue":"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","count":null},"50be3eab-12ed-4e6e-9f77-0aaf394f5cdc":{"expireTime":1634366916008,"status":0,"verifyFaceUrl":null,"memberJobNum":null,"orgId":1,"eigenvalue":null,"count":null},"08c1b320-64bd-4ca6-8dcb-d4fe006a006d":{"expireTime":1634366932599,"status":1,"verifyFaceUrl":"/faceimg/2021101616343669164962743-image.png","memberJobNum":null,"orgId":1,"eigenvalue":"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","count":null}}}}
			if(jsonRet.code==="0"){
				var imgObj=jsonRet.data.extractResut[queryKey];
				if(imgObj.status==1){
					var verifyFaceUrl = imgObj.verifyFaceUrl;
					$("#addUserImg").attr("src",baseUrl+verifyFaceUrl);
					$("#addUserImg").attr("data-verifyFaceUrl",verifyFaceUrl);
					loadingShowOrHide("hide");
					return;
				}
			}
			getPhotoImg(jobNum,queryKey);
		})	
	}, 1000 )
}


function loadingShowOrHide(mode){
	if(mode=="hide"){
		$("#Loading").fadeOut("fast");	
	}else{
		$("#Loading").fadeIn("fast");	
	}
}

function addSureUser(){
	var id =$("#addUserId").val();
	var name = $("#name").val();
	var code = $("#code").val();
	var pos = $("#pos").val();
	var checkedRadioJObj = $("input[name='gender']:checked");
  	var gender = checkedRadioJObj.val()
  	var cardNum = $("#cardNum").val();
	var mobile = $("#mobile").val();
	var idenCard = $("#idenCard").val();
	var verifyFaceUrl = ($("#addUserImg").attr("data-verifyfaceurl")||"");
	var jobNum=Date.parse(new Date());
  	if(!code){
		 $.messager.alert("提示","工号不能为空!"); 
		 return;
	}
	if(!name){
		 $.messager.alert("提示","姓名不能为空!"); 
		 return;
	}
  	if(!gender){
		 $.messager.alert("提示","性别不能为空!"); 
		 return;
	}
	
	if(!mobile){
		$.messager.alert("提示","手机号不能为空！"); 
		return;
	}
	if(!idenCard){
		$.messager.alert("提示","身份证号不能为空!(设备要求)"); 
		return;
	}
	
	var params=id+"^"+name+"^"+code+"^"+pos+"^"+gender+"^"+cardNum+"^"+mobile+"^"+idenCard+"^"+verifyFaceUrl+"^"+jobNum;
	$.cm({ 
		ClassName:"DHCDoc.GetInfo.Service.FaceAuthentication",
		MethodName:"SaveMember",
		"Params":params
	},function(jsonRet){
		if(jsonRet.code==="0"){
			var tip=(id==""?"添加成功!":"修改成功!");
			$.messager.alert("提示",tip,function(){
				closeUserWin();
			});
			$("#addUserId").val(jsonRet.data.memberId);
			return;
		}else{
			$.messager.alert("提示","添加失败!"+jsonRet.errorMessage);
			return;	
		}
	})
}

function clearAddSureUser(){
	$("#addUserId").val("");
	$("#name").val("");
	$("#code").val("");
	$("#pos").val("");
	if($("input[name='gender']:checked").length){
		$("input[name='gender']:checked").radio("uncheck");
	}
	$("#cardNum").val("");
	$("#mobile").val("");
	$("#idenCard").val("");
	$("#addUserImg").attr("data-verifyfaceurl","");
	$("#addUserImg").attr("src","");
	return;
}


function closeUserWin(){
	$HUI.window("#userWin").close();
}


function writeText(fileName,text){
	var str ='var fso,s="";'   // filespec="C:/path/myfile.txt"
		+"\n"+'fso = new ActiveXObject("Scripting.FileSystemObject");'
		+"\n"+'if(!fso.FolderExists("D:/imedicallog")){'
		+"\n"+'fso.CreateFolder("D:/imedicallog");'
		+"\n"+'}'
		+"\n"+'var f="";'
		+"\n"+'if(!fso.FileExists("D:/imedicallog/'+fileName+'")){'
		+"\n"+'f = fso.CreateTextFile("D:/imedicallog/'+fileName+'",true);'
		+"\n"+'}else{'
		+"\n"+'f = fso.OpenTextFile("D:/imedicallog/'+fileName+'",8,false);' ///第二个参数8表示追加,2表示修改,1表示只读;第三个参数为不存在是否新增文件
		+"\n"+'}'
		+"\n"+'f.WriteLine("'+text+'");'
		+"\n"+'f.Close();'
	CmdShell.clear();
	CmdShell.notReturn=0;
	CmdShell.EvalJs(str);
	return;
}

//var path="D:/imedicallog/"+lgUserCode+lgSessionID+".txt";
//读取文件
function readText(path){
	var str ='var fso,s="";'   // filespec="C:/path/myfile.txt"
		+"\n"+'fso = new ActiveXObject("Scripting.FileSystemObject");'
		+"\n"+'if (fso.FileExists("'+path+'")){'
		+"\n"+'f = fso.OpenTextFile("'+path+'", 1);'
		+"\n"+'s = f.ReadLine();'
		+"\n"+'}else{'
		+"\n"+'s="";'
		+"\n"+'};'
		+'\n'+'return s;'
	CmdShell.clear();CmdShell.notReturn=0;
	var obj = CmdShell.EvalJs(str);
	console.log(obj.rtn);
	return;
}

window.onunload = function(){
	var fileName=lgUserCode+"^"+lgSessionID+".txt";
	writeText(fileName,"mdtcheckout^会诊签到退出");
};

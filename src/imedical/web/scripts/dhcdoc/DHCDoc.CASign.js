/**!
* 日期: 2021-04-28
* 作者：lixu
* CA签名js【新版回调函数使用】
* 
*/

if (websys_isIE == true) {
	if($("script[src='../scripts/dhcdoc/tools/bluebird.min.js']").length < 1){
		var script = document.createElement('script');
		script.type = 'text/javaScript';
		script.src = '../scripts/dhcdoc/tools/bluebird.min.js'; // bluebird 文件地址
		document.getElementsByTagName('head')[0].appendChild(script);
	}
}

// 启用CA标识
var CAInitFlag = $cm({
	ClassName: "web.DHCDocSignVerify",
	MethodName: "GetCAServiceStatus",
	LocID: session['LOGON.CTLOCID'],
	UserID: session['LOGON.USERID']
},false);

var CAConfigObj = {
	Async: true //异步调用基础平台
}

var CASignObj = {
	CASignLogin: function(callBackFun,callType,isHeaderMenuOpen) {
		//判断CA登录情况
		var CAObj = {
			"caIsPass": "0"
		}
		if (CAInitFlag == 1) {
			CAObj.caIsPass = 1;
			var logonType = "";// UKEY|PHONE|FACE|SOUND|"" 空时弹出配置签名方式，其它弹出固定方式
			var singleLogon = 0; //0-弹出多页签签名，1-单种签名方式
			var forceOpen = 0; //1-强制每次都弹出签名窗口
			new Promise(function(resolve, rejected) {
				if (CAConfigObj.Async == true) {
					var cacallBack = function(Obj) {
						resolve(Obj);
					}
					dhcsys_getcacert({
						modelCode:callType,
						callback: cacallBack,
						isHeaderMenuOpen:isHeaderMenuOpen
						//isHeaderMenuOpen:true, //是否在头菜单打开签名窗口. 默认true
						//SignUserCode:txtUser,   //期望签名人HIS工号，会校验证书用户与HIS工号. 默认空
						//signUserType:"",   // 默认空，表示签名用户与当前HIS用户一致。ALL时不验证用户与证书
						//notLoadCAJs:1,  //登录成功后，不向头菜单加载CA
						//loc:deptDesc,   //科室id或描述，默认当前登录科室
						//groupDesc:groupDesc,  //安全组描述，默认当前登录安全组
						//caInSelfWindow:1  //用户登录与切换科室功能， 业务组不用
					}) // "", "", "");
				} else {
					var Obj = dhcsys_getcacert();
					resolve(Obj);
				}
			}).then(function(Obj) {
				if ((!Obj.IsSucc)) {
					$.messager.alert("警告", "证书未登录,请重新登录证书!", "info");
					callBackFun(false);
					return false;
				}else if (Obj.ContainerName == "") {
					var CAObj = {
						"caIsPass": "0"
					}
					callBackFun(CAObj);
					return true;
					}
				var CAObj = {
						"caIsPass": "1"
					}
				$.extend(CAObj, {"CAObj": Obj}) 
				callBackFun(CAObj);
				return true;
			})
		} else {
			callBackFun(CAObj);
		}
	},
	SaveCASign: function(CAObj, OrdList, OperationType) {
		try {
			// CAObj :基础平台dhcsys_getcacert()返回的对象
			// OperationType="A" 审核医嘱,OrdList 格式：arcimID*oeitmID*status^arcimID*oeitmID*status
			// OperationType="S" 停医嘱,OrdList 格式：oeitmID^oeitmID
			// OperationType="CA" 治疗评估,OrdList 格式：oeitmID^oeitmID
			// OperationType="CR" 治疗记录执行,OrdList 格式：oeitmID^oeitmID
			// OperationType="CS" 治疗评定,OrdList 格式：oeitmID^oeitmID
			debugger
			if ((CAObj.ContainerName == "") || (!CAObj.IsSucc)) return false;
			//0.获取客户端证书
			var ContainerName = CAObj.ContainerName; //证书容器名
			var CALogonType = CAObj.CALogonType; //登录方式代码
			var varCert = CAObj.varCert; //数字证书
			var varCertCode = CAObj.CAUserCertCode; //用户唯一标识
			var varCertNo = CAObj.CACertNo; //证书唯一标识
			//1.数据重组
			var CASignOrdStr = "";
			var TempIDs = OrdList.split("^");
			var IDsLen = TempIDs.length;
			for (var k = 0; k < IDsLen; k++) {
				if (OperationType == "A") {
					var TempNewOrdDR = TempIDs[k].split("*");
					if (TempNewOrdDR.length < 2) continue;
					var newOrdIdDR = TempNewOrdDR[1];
				}
				else if (OperationType == "S") {
					var newOrdIdDR = TempIDs[k];
				}
				else if (OperationType=="Diag"){
					var TempNewOrdDR =TempIDs[k].split(String.fromCharCode(1));
					var newOrdIdDR = TempNewOrdDR[0];
				}
				else if (OperationType=="DeDiag"){
					var TempNewOrdDR =TempIDs[k].split(String.fromCharCode(1));
					var newOrdIdDR = TempNewOrdDR[0];
				}else{
					//目前新增了治疗记录执行、治疗评估的CA认证，走此分支
					var newOrdIdDR = TempIDs[k];
				}
				if(newOrdIdDR==""){continue;}
				if (CASignOrdStr == "") CASignOrdStr = newOrdIdDR;
				else CASignOrdStr = CASignOrdStr + "^" + newOrdIdDR;
			}
			//2.数据加密
			var SignOrdHashStr = "", SignedOrdStr = "", CASignOrdValStr = "";
			var CASignOrdArr = CASignOrdStr.split("^");
			for (var count = 0; count < CASignOrdArr.length; count++) {
				var CASignOrdId = CASignOrdArr[count];
				var OEORIItemXML = $.cm({
					ClassName: "web.DHCDocSignVerify",
					MethodName: "GetOEORIItemXML",
					dataType: "text",
					newOrdIdDR: CASignOrdId,
					OperationType: OperationType
				},false);
				var OEORIItemXMLArr = OEORIItemXML.split(String.fromCharCode(2));
				for (var ordcount = 0; ordcount < OEORIItemXMLArr.length; ordcount++) {
					if (OEORIItemXMLArr[ordcount] == "") continue;
					var OEORIItemXML = OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[1];
					var OEORIOperationType = OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[0];
					var OEORIItemXMLHash = CAObj.ca_key.HashData(OEORIItemXML);
					if (SignOrdHashStr == "") SignOrdHashStr = OEORIItemXMLHash;
					else SignOrdHashStr = SignOrdHashStr + "&&&&&&&&&&" + OEORIItemXMLHash;
					var SignedData = CAObj.ca_key.SignedOrdData(OEORIItemXMLHash, ContainerName);
					if (SignedOrdStr == "") SignedOrdStr = SignedData;
					else SignedOrdStr = SignedOrdStr + "&&&&&&&&&&" + SignedData;
					if (CASignOrdValStr == "") CASignOrdValStr = OEORIOperationType + String.fromCharCode(1) + CASignOrdId;
					else CASignOrdValStr = CASignOrdValStr + "^" + OEORIOperationType + String.fromCharCode(1) + CASignOrdId;
				}
			}
			if (SignOrdHashStr != "") SignOrdHashStr = SignOrdHashStr + "&&&&&&&&&&";
			if (SignedOrdStr != "") SignedOrdStr = SignedOrdStr + "&&&&&&&&&&";
			//3.保存签名信息记录
			debugger
			if ((CASignOrdValStr != "") && (SignOrdHashStr != "") && (varCert != "") && (SignedOrdStr != "")) {
				var ret = $.cm({
					ClassName: "web.DHCDocSignVerify",
					MethodName: "InsertSignBatchSignRecord",
					dataType: "text",
					CurrOrderItemStr: CASignOrdValStr,
					UserID: session['LOGON.USERID'],
					OperationType: OperationType,
					OrdItemsHashVal: SignOrdHashStr,
					MainSignCertCode: varCertCode,
					MainSignValue: SignedOrdStr,
					ExpStr: ContainerName,
					MainSignCertNo: varCertNo
				},false);
				if (ret != "0") {
					$.messager.alert("警告", "数字签名没成功","warning");
					return false;
				}
			} else {
				$.messager.alert("警告", "没有要数字签名的数据","warning");
				return false;
			}
			return true;
		} catch(e) {
			$.messager.alert("警告", e.message,"warning");
			return false;
		}
	}
}

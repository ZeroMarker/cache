/*
 * 功能描述：
 *     PDF虚拟打印机插件接口，提供使用clawPDF虚拟打印机生成PDF文件的功能
 *     建议使用ca_pdfcreator.genPDFBase64(pdfName, outPath, printFunction)函数生成PDF并获取其Base64数据
 *
 * 接口描述：
 *     ca_pdfcreator.genPDFBase64(pdfName, outPath, printFunction, monitorTime)
 *     描述：通过业务系统打印函数生成PDF并获取其Base64数据
 *     参数：@pdfName 临时PDF文件名称，传空值即可，插件会自动指定临时文件并自动清空
 *           @outPath 临时PDF文件路径，传空值即可，插件会自动指定临时文件目录
 *           @printFunction 业务系统的打印函数
 *           @monitorTime 监测时间，留空或未定义则默认5000毫秒
 *     返回值：PDF文件的Base64字符串；若生成失败，则返回空值
 *
 *     ca_pdfcreator.genPDF(pdfName, outPath, printFunction)
 *     描述：通过业务系统打印函数生成PDF文件
 *     参数：@pdfName 临时PDF文件名称，传空值即可，插件会自动指定临时文件并自动清空
 *           @outPath 临时PDF文件路径，传空值即可，插件会自动指定临时文件目录
 *           @printFunction 业务系统的打印函数
 *           @monitorTime 监测时间，留空或未定义则默认5000毫秒
 *     返回值：PDF文件名称（包含目录路径）；若生成失败，则返回空值
 *
 *     ca_pdfcreator.getPDFBase64(fileName)
 *     描述：获取指定文件的Base64数据
 *     参数：@fileName 文件名称（包含目录路径）
 *     返回值：文件的Base64数据；若文件不存在，则返回空值
 *     
 *     ca_pdfcreator.delPDFFile(fileName)
 *     描述：删除指定文件
 *     参数：@fileName 文件名称（包含目录路径）
 *     返回值：true 删除成功；false 删除失败    
 */
var ca_pdfcreator = (function() {
	
	var Const_PDF_Printer = "clawPDF";
	var Const_EMRPDFCreator_Version = "1,0,1,0";
	var Const_PDF_MonitorTime = 5000;		//监控PDF是否生成成功时间，单位毫秒，默认5000毫秒
	var Const_PDF_MonitorTimeSpan = 500;	//监控PDF是否生成成功时间间隔，单位毫秒，默认500毫秒
	var CA_EMRPDFCreator = "";
	
	function initCAEMRPDFCreator() {
	
		if (CA_EMRPDFCreator != "") return;
		
		if("undefined"==typeof(EnableLocalWeb) || 0==EnableLocalWeb ){
		    //未开启使用中间件 或 老项目，然仍用老的方式运行
		    if ((window.ActiveXObject)||("ActiveXObject" in window)) {
			    var codebase = "../addins/plugin/EMRPDFCreator/EMRPDFCreator.cab#version=" + Const_EMRPDFCreator_Version;
			    EMRPDFCreator = document.createElement("object");
			    EMRPDFCreator.setAttribute("id","EMRPDFCreator");
	        	EMRPDFCreator.setAttribute("name","EMRPDFCreator");
	        	EMRPDFCreator.setAttribute("style","display:none;position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
	         	EMRPDFCreator.setAttribute("classid","clsid:469DF3E9-E798-4076-A487-745AEAB72DE3");
	         	EMRPDFCreator.setAttribute("codebase",codebase);
	         	document.documentElement.appendChild(EMRPDFCreator);
	    	}
	    	
	    	CA_EMRPDFCreator = {
		    	Exec : function(commandJson) {
					var command = commandJson;
					if (typeof(commandJson) == "object") {
						command = JSON.stringify(commandJson);
					}
					var ret = "";
					try {
						console.log(getTime() + " start:" + command);
						ret = EMRPDFCreator.Exec(command);
						console.log(getTime() + " end:" + command);
					} catch (e) {
						return {status:"-9999",message:"请安装电子病历PDF生成插件[iEMRPDFCreator]"};
					}
		    		return JSON.parse(ret);
		    	}
		    }
	    }else{
		   	//中间件运行,此处的EMRPDFCreator为配置界面的调用ID
		   	//debugger;
		   	EMRPDFCreator.notReturn = 0;
			CA_EMRPDFCreator = {
				Exec : function(commandJson) {
					var command = commandJson;
					if (typeof(commandJson) == "object") {
						command = JSON.stringify(commandJson);
					}
					var ret = "";
					try {
						console.log(getTime() + " start:" + command);
						ret = EMRPDFCreator.Exec(command);
						console.log(getTime() + " end:" + command);
					} catch (e) {
						return {status:"-9999",message:"医为客户端服务异常:"};
					}
					
					if (ret.status == "200") {
						return JSON.parse(ret.rtn);
					} else {
						return {status:"-9999",message:"医为客户端服务异常:" + ret.msg};
					}
				}
			}
		}
	}
	
	//生成当前时间，精确到毫秒，方便性能调试使用
	function getTime() {
		var dt = new Date();
	    var hours = dt.getHours()
	    hours = "00" + hours;
	    hours = hours.substring(hours.length-2);

	    var min   = dt.getMinutes()
	    min = "00" + min;
	    min = min.substring(min.length-2);

	    var sec   = dt.getSeconds()
	    sec = "00" + sec;
	    sec = sec.substring(sec.length-2);

	    var msec  = dt.getMilliseconds()
	    msec = "00" + msec;
	    msec = msec.substring(msec.length-3);

	    return hours+":"+min+":"+sec+":"+msec;
	}
	
	//生成本地时间戳，时间精确到毫秒
	function genTS(){
	    var dt = new Date();
	    var fYear = dt.getFullYear()

	    var month = dt.getMonth()+1
	    month = "00" + month;
	    month = month.substring(month.length-2);

	    var dat   = dt.getDate()
	    dat = "00" + dat;
	    dat = dat.substring(dat.length-2);

	    var hours = dt.getHours()
	    hours = "00" + hours;
	    hours = hours.substring(hours.length-2);

	    var min   = dt.getMinutes()
	    min = "00" + min;
	    min = min.substring(min.length-2);

	    var sec   = dt.getSeconds()
	    sec = "00" + sec;
	    sec = sec.substring(sec.length-2);

	    var msec  = dt.getMilliseconds()
	    msec = "00" + msec;
	    msec = msec.substring(msec.length-3);

	    return fYear+month+dat+hours+min+sec+msec;
	}
	
	function getVersion() {
		try {
			var ret = CA_EMRPDFCreator.Exec( {action:"get_version"});
			if (ret.status == "0") {
				return ret.data;
			} else {
				alert(ret.message);
				return "";
			}
		} catch (e) {
			alert(ex.message);
			return "";
		}
	}
	
	function isPDFCreatorExist() {
		try {
			var ret = CA_EMRPDFCreator.Exec( {action:"is_printer_exist",printerName:Const_PDF_Printer});
			if (ret.status == "0") {
				return ret.data == "1";
			} else {
				return fasle;
			}
		} catch (e) {
			return false;
		}
	}
	
	function installClawPDF() {
	   	var iWidth = 800;
		var iHeight = 600;
		var iLeft = (screen.availWidth - iWidth)  / 2;
		var iTop = (screen.availHeight- iHeight) / 2;
	   	window.open("./dhc.certauth.cfg.pdfprinter.csp","_blank","height="+iHeight+",width="+iWidth+",left="+iLeft+",top="+iTop+",menubar=no,titlebar=no,toolbar=no, status=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes")
	}
	
	//生成pdf文件，返回文件路径
	function genPDF(pdfName, outPath, printFunction, monitorTime) {
		
		monitorTime = monitorTime || Const_PDF_MonitorTime;
		
		if (typeof(printFunction) != "function") {
			alert("请指定业务系统打印函数!");
		    return "";
	    }
		
		//检查pdfCreator对象版本
		if (getVersion() == "") {
			return "";
		}
		
		//检查PDF打印机[clawPDF]是否存在
		if (!isPDFCreatorExist()) {
			if("undefined"==typeof(EnableLocalWeb) || 0==EnableLocalWeb ) {
				alert("请安装虚拟PDF打印机[" + Const_PDF_Printer + "]");
			} else {
				installClawPDF();
			}
			return "";
		}
	    
		var retPdfName = "";
		var tmpPdfName = "";
	    
	    //设置横向打印
	    //pdfCreator.SetLandscape("");
		
		try {
			
			//设置打印输出PDF文件名称
			if (pdfName == "") {
				pdfName = genTS();
			}
			
			var startConfig = "";
			var startConfig = CA_EMRPDFCreator.Exec({
				action:"start_pdf_create",
				printerName:Const_PDF_Printer,
				outPath:"",
				pdfName:pdfName,
				clearFile:"1"			////先确认要输出的PDF文件不存在，防止出现本次修改输出文件名称失败、本次输出PDF文件失败而导致返回之前生成的PDF文件错误, 很重要，防止串数据
			});
			if (startConfig.status != "0") {
				alert(startConfig.message);
				return "";
			}
			
			retPdfName = startConfig.outPath + startConfig.pdfName + ".pdf";
			tmpPdfName = startConfig.outPath + pdfName + ".pdf";
			if (retPdfName != tmpPdfName) {
				alert("检验输出文件名失败");
				return "";
			}
			
			//先确认要输出的PDF文件不存在，防止出现本次修改输出文件名称失败、本次输出PDF文件失败而导致返回之前生成的PDF文件错误
			//很重要，防止串数据
			/*
			pdfCreator.DelPDF(tmpPdfName);
			
			if (defPrinter != Const_PDF_Printer) {
				pdfCreator.SwitchDefaultPrinter(Const_PDF_Printer);
			}
			*/
			
			printFunction();
				
			
			//检测pdf文件是否生成【方法1】
			/*
			//开始打印监控
			pdfCreator.monPDFPrntSt(20000);
			//执行打印操作
			printFunction();
			//监控打印作业是否完成
			var ret = pdfCreator.chkPDFPrntEd(20000);
			*/
			//检测pdf文件是否生成【方法2】，更准确
			var endConfig = CA_EMRPDFCreator.Exec({
				action: "end_pdf_create",
				defaultPrinterName: startConfig.defaultPrinter,
				outPdfName: retPdfName,
				monitorTime: monitorTime,
				monitorTimeSpan: Const_PDF_MonitorTimeSpan,
				getBase64: "0",
				clearFile: "0"
			});
			if ((endConfig.status == "0")&&(endConfig.fileCreateFlag == "2")) {
				return retPdfName;
			} else {
				alert("生成PDF文件失败");
				return ""
			}
			
		} catch(e) {
			alert("生成PDF异常:" + e);
			return "";
		}
	}

	//生成pdf文件Base64
	function genPDFBase64(pdfName, outPath, printFunction, monitorTime) {
		var genName = genPDF(pdfName, outPath, printFunction, monitorTime);
		if(genName == "") return "";
	
		var pdfBase64 = getPDFBase64(genName,"1");
		return pdfBase64;
	}

	function getPDFBase64(fileName,clearFile) {
		try {
			clearFile = clearFile || "0";
			var ret = CA_EMRPDFCreator.Exec( {action:"bin_2_base64",fileName:fileName,clearFile:clearFile});
			if (ret.status == "0") {
				return ret.data;
			} else {
				return "";
			}
		} catch (e) {
			return "";
		}
	}

	function delPDFFile(fileName) {
		try {
			var ret = CA_EMRPDFCreator.Exec( {action:"del_pdf",fileName:fileName});
			if (ret.status == "0") {
				return true;
			} else {
				return false;
			}
		} catch (e) {
			return false;
		}
	}
	
	
    return {
		getVersion:function() {
			initCAEMRPDFCreator();
			return getVersion();
		},
    	genTS:function() {
	    	return genTS();
    	},
		genPDFBase64: function(pdfName, outPath, printFunction, monitorTime) {
	    	initCAEMRPDFCreator();
	    	return genPDFBase64(pdfName, outPath, printFunction, monitorTime);
    	},
    	genPDF: function(pdfName, outPath, printFunction, monitorTime) {
	    	initCAEMRPDFCreator();
	    	return genPDF(pdfName, outPath, printFunction, monitorTime);
    	},
		getPDFBase64: function(fileName) {
			initCAEMRPDFCreator();
	    	return getPDFBase64(fileName);
    	},
    	delPDFFile: function(fileName) {
	    	initCAEMRPDFCreator();
    		return delPDFFile(fileName);
    	}
    }
})();


// 数据式手写签名插件对象
var hsPluginData = {
    initCtrl: function() {
    },
    checkStatus: function () {
        return true;
    },
    getEvidenceData: function (signerInfo, imgType) {
        var evidenceValue = '';
        return "";
    },
    getErrorMessage: function (ErrorCode) {
        var Message = '';
        switch (ErrorCode) {
            case 0:
                Message = '成功';
                break;
            case 1:
                Message = '未知错误';
                break;
            default:
                Message = '未知错误';
                break;
        }
        Message += ',错误码：' + ErrorCode;
        return Message;
    }
}


/* 
 * PDF手写签名插件对象
 *
 * 前置要求：dhc.certauth.hs.shca.sign.csp和dhc.certauth.hs.shca.pdf.csp页面已部署测试
 */
var hsPluginPDF = (function(){
	
	var handSign_dlg = "";
	
	function initHandSignDlg() {
		if ($('#handSign_dlg').length === 0) {
            var dialogHtml = '<div id="handSign_dlg" class="hisui-dialog" title="患者签名" style="display:none;overflow:hidden;width:430px;height:500px" ';
            dialogHtml += '<div style="width:400px;height:400px;margin-left:15px;margin-top:15px"><span id="handSign_tip">请稍候...</span></div>';
            dialogHtml += '</div>';
            $('body').append(dialogHtml);
            handSign_dlg = $('#handSign_dlg');
        }
	}
	
	function showHandSignDlg(onConfirm, onCancel, tip) {
		tip = tip || "请稍候...";
		$('#handSign_tip').html(tip);
		
		handSign_dlg.show().dialog({
			isTopZindex: true,
			closable: false,
			modal: true,
			buttons: [/*{
				id: 'wechatSign',
				text: '微信签署',
				handler: function () {
					alert("微信签署");
					doPushSignPDF("WeChat");
				}
			},{
				id: 'padSign',
				text: 'PC签名板签署',
				handler: function () {
					alert("PC签名板签署");
					doPCSignPDF("Pad");
				}
			},*/
			{
				id: 'confirmSign',
				text: '关闭',
				handler: function () {
					if ('function' === typeof onConfirm) {}
					$('#handSign_tip').html("请稍候...");
					handSign_dlg.dialog('close');
				}
			}]
		});
	}
	
	function closeHandSignDlg() {
		$('#handSign_dlg').dialog('close');
	}
	
	function showTip(tip) {
		$('#handSign_tip').html(tip);
	}
	
	function pushToSignPDF(pdfName, pdfBase64, keyWord, signType) {
		var keyWordStr = keyWord;
		var uRet = '';
		var argsData = {
			Action : 'pushToSignPDFBase64',
			pdfName: pdfName,
			pdfB64 : pdfBase64,
			keyWord : keyWordStr,
			signType : signType
		};
		$.ajax({
			type: 'POST',
			dataType: 'text',
			url: '../EMRservice.Ajax.anySign.cls',
			async: false,
			cache: false,
			data: argsData,
			success: function (ret) {
				if (ret.split('^')[0] == 1) {
					uRet = ret.split('^')[1]
				} else { throw { message : 'pushToSignPDFBase64 失败！' + ret}; }
			},
			error: function (err) {
				throw { message : 'pushToSignPDFBase64 error:' + err };
			}
		});
		return uRet;
	}
		
	function signPDF(parEditor) {
		initHandSignDlg();
		
		var instanceID = parEditor.signProps.instanceID;
		var canDo = parEditor.canDoPDFSign("", instanceID);
		if (!canDo) return;
		
		var updateInst = false;
		var allKeyWord = parEditor.getPatSignKeyWord(instanceID,updateInst);
		if (allKeyWord == "") {
			showTip("未找到有效的患者签名关键字！");
			return;
		}
		parEditor.allKeyWord = allKeyWord;
		global_hs_parEditor = parEditor;
		showHandSignDlg("","","请稍候...");
		
		doPCSignPDF("");
	}
	
	function doSignPDF(signType) {
		var parEditor = global_hs_parEditor;
		
		var instanceID = parEditor.signProps.instanceID;
		var pdfBase64 = parEditor.getSignedPDF(instanceID);
		if (pdfBase64 == "") {
			pdfBase64 = parEditor.createToSignPDFBase64(instanceID);
		}
		if (pdfBase64 == "") {
			showTip("生成待签名PDF失败！");
			return;
		}
		parEditor.pdfBase64 = pdfBase64;
		
		var pdfName = parEditor.signProps.patientID + "-" + parEditor.signProps.episodeID + "-" + parEditor.signProps.instanceID;
	    pdfName = pdfName.replace("||",'@');
		
		try {
			var allKeyWord = parEditor.allKeyWord;
            var ret = pushToSignPDF(pdfName, pdfBase64, allKeyWord, signType);
            if (ret != "") {
                showTip("推送待签名PDF成功...");
                //setTimeout("$('#handSign_dlg').dialog('close');", 2000 )
	        }
        } catch(e) {
			showTip("推送待签名PDF失败：\r\n" + e.message);
		}
	}
	
	function doPCSignPDF(signType) {
		var parEditor = global_hs_parEditor;
		
		var instanceID = parEditor.signProps.instanceID;
		var pdfBase64 = parEditor.getSignedPDF(parEditor.signProps.episodeID, instanceID);
		if (pdfBase64 == "") {
			pdfBase64 = parEditor.createToSignPDFBase64(instanceID);
		}
		if (pdfBase64 == "") {
			showTip("生成待签名PDF失败！");
			return;
		}
		global_hs_parEditor.pdfBase64 = pdfBase64;
		
		var pdfName = parEditor.signProps.patientID + "-" + parEditor.signProps.episodeID + "-" + parEditor.signProps.instanceID;
	    pdfName = pdfName.replace("||",'@')
		
		var iWidth = screen.availWidth - 200;
		var iHeight = screen.availHeight - 100;
		var iLeft = 200 / 2;
		var iTop = 100 / 2;
		var urName = parEditor.signProps.patientID;
		var userID = parEditor.signProps.patientID;
		var docuNo =  parEditor.signProps.episodeID + "-" + parEditor.instanceId.replace("||","@")
		var keyWrd = parEditor.signProps.signKeyWord;
		var urlKeyWrd = encodeURI(keyWrd);
		var signWin = window.open("./dhc.certauth.hs.shca.sign.csp?urName="+urName+"&userID="+userID+"&docuNo="+docuNo+"&keyWrd="+urlKeyWrd+"&episodeID="+parEditor.signProps.episodeID,
						"_blank","height="+iHeight+",width="+iWidth+",left="+iLeft+",top="+iTop+",menubar=no,titlebar=no,toolbar=no, status=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes")
		signWin.focus();
	}
	
	/// 保存签名后pdf
	function saveCallbackPDF(parPDF) {
		
		var pdfBase64 = parPDF.pdfBase64||"";
		var instanceID = parPDF.instanceID||"";
		var userID = parPDF.userID||"";
		
		var argsData = {
			Action: 'setPDFBase64',
			instanceID: instanceID,
			userID: userID,
			pdfB64: pdfBase64
		};
	        
		$.ajax({
			type: 'POST',
			dataType: 'text',
			url: '../EMRservice.Ajax.anySign.cls',
			async: false,
			cache: false,
			data: argsData,
			success: function (ret) {
				if (ret.split("^")[0] == "1") {
					showTip("保存签名后PDF成功");
					closeHandSignDlg();
				} else {
					showTip("保存签名后PDF失败:" + ret);
				}
			},
			error: function (err) {
				throw { message : 'setPDFBase64 error:' + err };
			}
		});
	}
	
	return {
		signPDF: function(parEditor){
			signPDF(parEditor);
		},
		saveCallbackPDF: function(parPDF) {
			saveCallbackPDF(parPDF);
		}
	}
})();

//电子病历全局签名对象
var global_hs_parEditor = "";
var handSign = (function(){

	function doHandSign(parEditor) {
		global_hs_parEditor = "";
		hsPluginPDF.signPDF(parEditor);
	}
	
	return {
		sign: function(parEditor) {
			doHandSign(parEditor);
		},
		saveCallbackPDF: function(parPDF) {
			hsPluginPDF.saveCallbackPDF(parPDF);
		}
	}
})();



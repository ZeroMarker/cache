﻿/*
 * 功能描述：
 *     PDF虚拟打印机插件接口，提供使用clawPDF虚拟打印机生成PDF文件的功能
 *     建议使用ca_pdfcreator.genPDFBase64(pdfName, outPath, printFunction)函数生成PDF并获取其Base64数据
 *
 * 接口描述：
 *     ca_pdfcreator.genPDFBase64(pdfName, outPath, printFunction)
 *     描述：通过业务系统打印函数生成PDF并获取其Base64数据
 *     参数：@pdfName 临时PDF文件名称，传空值即可，插件会自动指定临时文件并自动清空
 *           @outPath 临时PDF文件路径，传空值即可，插件会自动指定临时文件目录
 *           @printFunction 业务系统的打印函数
 *     返回值：PDF文件的Base64字符串；若生成失败，则返回空值
 *
 *     ca_pdfcreator.genPDF(pdfName, outPath, printFunction)
 *     描述：通过业务系统打印函数生成PDF文件
 *     参数：@pdfName 临时PDF文件名称，传空值即可，插件会自动指定临时文件并自动清空
 *           @outPath 临时PDF文件路径，传空值即可，插件会自动指定临时文件目录
 *           @printFunction 业务系统的打印函数
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
	function genPDF(pdfName, outPath, printFunction) {
		
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
				monitorTime: 5000,
				monitorTimeSpan: 500,
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
	function genPDFBase64(pdfName, outPath, printFunction) {
		var genName = genPDF(pdfName, outPath, printFunction);
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
		genPDFBase64: function(pdfName, outPath, printFunction) {
	    	initCAEMRPDFCreator();
	    	return genPDFBase64(pdfName, outPath, printFunction);
    	},
    	genPDF: function(pdfName, outPath, printFunction) {
	    	initCAEMRPDFCreator();
	    	return genPDF(pdfName, outPath, printFunction);
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



// 公用实用函数接口对象
var utilityIF = {
    isNull: function(str) {
        if ("" === str) {
            return true;
        } else if (null === str) {
            return true;
        } else if ("undefined" === typeof str) {
            return true;
        }
        return false;
    },
    isNumber: function(val) {//校验只要是数字（包含正负整数，0以及正负浮点数）就返回true
        var regPos = /^\d+(\.\d+)?$/; //非负浮点数
        var regNeg = /^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //负浮点数
        if (regPos.test(val) || regNeg.test(val)) return true;
        else return false;
    },
    genTS: function(){
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
    },
    genUsrID: function (evidenceData) {
        return (new Date()).getTime();
    },
    QRShow: function(qrContent) {
        $('#handSign_qr').qrcode({
            render:"div",
            size: 400,
            quiet: 0,
            ecLevel:'L',
            text: qrContent,
            background:"#E6E6E6",
            foreground:"#000000",
        });
    }
}

var handSignInterface = {
    getAnySignLocation: function () {
        $.ajax({
            type: 'GET',
            dataType: 'text',
            url: '../EMRservice.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: { Action: 'GetAnySignLocation'},
            success: function (ret) {
                ret = $.parseJSON(ret);
                if (ret.Err || false) {
                    throw {
                        message: 'getAnySignLocation 失败！' + ret.Err
                    };
                } else {
                    if (ret.Value === '') {
                        throw {
                            message: 'AnySignLocation 未设置！'
                        };    
                    }
                    this.hostAddress = ret.Value.split(':')[0];
					this.port = ret.Value.split(':')[1];
                }
            },
            error: function (err) {
                throw {
                    message: 'getAnySignLocation error:' + err
                };
            }
        });    
    },	
	getEvidenceData: function (signerInfo, imgType) {
		var evidenceValue = '{"Evidence":[{"Content":"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","ImageType":"jpg","Type":"1"},{"Content":"R0lGODlhcwBxAOcAAAAAAAAAMwArAAArMzMAADMAMzMrADMrMwAAZjMrZjNVADNVMwBVZjNVZmYrZmZVM2ZVZjNVmWZVmWaAM2aAZmaAmWaAzJlVM5mAM5mqZsyqZpmAmZmqmZmAzJmqzJmq/8yqmcyAzMyqzMzVmczVzMzV/8z/zMz////VzP//zP///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAACoALAAAAABzAHEAAAj+AFUIHEiwoMGDCBMqXMiwocOHECNKnEixosWLGDNq3Mixo8ePIEOKHEmypMmTHVNYSIGypUcIBQwAMLDBpUkPAQwYCCDCIgcBB4AGPWAzZAMDBwgMNSDAQEUOSgkMUDqzaEcKSgsAFRBzQIEDAShyGIDUANkDBwywtIoRwFCuSIESAApgrUQDWr+63UuCrUWkbpWajToArQELFFPkXDr0gF2/D1O4jXvA7dukXB9LVJC0cmcAACA/BLF474GYnmMubtC2sVCiohkyBWyY7FQFEARy2K3x9E68AubGVpgaKG0Cmj0q6Io0KevhBmcOlSoVqUmmqs0WgF4Q6dSkZyv+Jw+ZlmzMptwFmjabVmtulA+8msU74P1wxnADjC9JOygBp8PNlBdcA+xXUgpxKVVYaKJRltZQoi0mGFiQmUbdabEVkBNZOQlgYEmNzRfUhy3RhldlVgnIFVcocofUhoCR6FEF5T04X3oqLPZbWgCa9IBn1H0nY1FTmbfikBiZMFh5ZRWI40DtCbUTSShM5lV+sD05UGHz5RRWSCkINVlaOSHp14VKZRYSANl5ppOWBqWQ5lICgGTli0hFAOdB5gGnl0digmfdngdBEFQBZxnHEXhzvkkoQnABSVaPFpkw14NuafVoQhwsaVxOHFyUQl5ukrWpQk22ySBFFdwJpJn+cB7aZFk';
        evidenceValue = evidenceValue + 'UacBkm6c2pNN3QcKqW07ZcZmrQ8AdcJajD0F1GY/DOpQCr0US8FxDCSxJVVrNPjTfsV5R0BAFO26FbbbaZpcTUgksFEB1YJ24Krm6hngaV9MaxFR5cwoQArwPmWCuiAB4cFCmkQbmLb8PEVhWaQbJdVZ1BSiAMEQhyOWmmwQ1GsBSlE7c0LpcLshjqCrE1aZSX3oM0caBlZdXjuGSacAEKk9EWWDHGvfdajVTJNjDRbYJmH09RzRWsLNiegDJRdvMHsp4/bYY0U1LRBhlUg6QctUTdWpkTAN2zPVdOxYb9dgVNfCVdoFyiLZEH2wrmFbtIfXA2w9tEJX+oEYO5dbWeCNkwmXG0X1tWQwErtCFwBZZo9RIMa04QQ5ThtQEwEY6mAAaTE7QmBe6JRAGibb7VWUSeF5ylExmqcIFvL6FFAGAox2A41KpJrkKDEwHHt0GIBA4gY0eUO9A6142O1l3oz3ZYvntTpB2fn4aFAhce3mrWZ0TJy5SwGtFQAVFI1AWqUBRjVDUMNItpfrwSpioag9tLGufAxJgwsQQyO2m2AuZgGA2tq3muCUD/OoUsLwDvolQwHDfAZvF0kWuWWWudg/p31JsUyy6+Co2XjoRUDAIEQlc60IWS1MBALC/U1lwShgZgasWYxsVyuQDm2pA7l60kRSg5UL+v+nKnJKygE1BYCvwuwgBOUQZGy5GeqoTiAbkgy9jKaiJDogiQtQWKZ2dcFJaRAjdMocaBs6reWEkCASgJ7PMLSUAUIzis/zEnvmADTAk1CKXyPgW4NUljQY5yoMcVsaNjQ+QBlng/CJlKkQSBAR2jNRbqPLBsSnrU1H7ipEcWRAFQE12wKMgJwVygv/IZ4nX2tcokdfE7ySIfKsUiATYeKhj1SSWKgCSoFTTIlwWkDlLwaVArvYdnKFxlf4CCjDtGEdEDvFvwJmZMC11MRFpJY9pHBxtcBa1d62yLGipHFoA0Mw0ykRSJgrAMUe5QVWl5Xic1AkwdeQVeDpSQm8/TApwkphGCNSwVEv64yongBqH/YyHseyAebiVHYHGcnnsklKdhCkiXWaqnGnk4iCZI0yDlEAg4BJlR0fqkYAAADs=","ImageType":"gif","Type":"0"},{"Content":"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RRQAlFLRQAlFFFABRRRQAUUUUAFFFFAAelMbpTjTRy30oAkooopAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUANPBpQaUjIpv86AH0Ug5FLQAUUUUAFFFFABRRRTAKKKKAClpKWgAooooAKKKKACiiigApp6inUjdKAEH3vrTqYexp9ABS0lFAC0UlFABRRRQAUUUUAFLSUUAFFFFABRRRQAUUUUAFJRRQAjfdNNb7tOb7pprfdoAcOlLSUtACUUtJQAUUUUAFFFFABRRRQAUlFFABRRmjNABRSZozQAtFN3UZoAcaKbk+lNLHOKAHGkXjrS9aNtAD6KKKQBRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABSMO9LRQAgNOpmMHFKp7UAOooooAKKKKACiiimAUUUUAFFFFABRRRQAtFJS0AFFFFABRRRQA3HBFKp4pD1oX7xH40AOooooAKKKKACiiigAooooAKKKKACiiigAopM0ZoAWkpM0bhQAtFN3ijfQArfdpj9PxoZunBpxGaAFozSYNG0+tAC5pM0bfejbQAZozRtFGB6UAJuo3U7FFADMn0NHPpT6KAGYNGD60+igBu0+tG2nUlACbRS4FFFABgUUUUAFM6uT6U4nApg4FADxS0g6UtAC0UUUgCiiigAooooAKKKKACiiigAooooAKKKKACiiigBGGaT3p1NPB+tAD6KaDg4p1ABRRRQAUUUUAFFFFMAooooAKKKKACijNGaACikzRuFADqKZvFG72oAcaaeCD+FBJx0pM5TNAEmaTNNwSOtLtPrQA7NJmk2+5pdooATdRupdo9KPwoATdRk+lOooAbk+lHNOooAbg+oowfWnUUAN2+9G0e9OooAbtFGB6U6koAMUUUUAMk7fWlHWh/4frQOtADqKKKACkpaSgAooooAKKKKACiiigAooooASilooAKSlpKACiiigBr+lA5ag9aVfWkAtFFFMABpab0pQc0gFooooAKKKKACiiigAooooAKKKKACijNGaACikzRuFAC0EZFN3j1o3Z9aYAf1FOByKZnHODS/SkA7NGaTB9aMUALmjNJtFLgUwE3UbqXFLQA3J9DRlvSnUUAN+b2owfWnUUAN2+9LtFLRQAm0elLgelFFABRS0UAJTBwSKkpjcMD60AKvSnU1epp1ABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUlFFADX6j60D71DdVoH3vwoAdRRRQAUUUUAFFFFACUUUUAFFFFABRRRQAUUUUAFFFFABSHgUtNNADaeKaBk/SnUAFFFFAAaTpRz6UhzSAcDRmmg5pwFABmjNGBRgelACbqN1LiloAbk+lHPpTqKAG4NG0+tOooAbt96XaPelooATaPSjaPSlpaAExRRRQAEcU0cHFOpGHFACilpoNOoAKKKKACiiimAUUUUAFFLRQAlFLRQAlLRRQAUUUUAFNfpTqDQAzuDT6Z2xTh0oAWiiigAooooAKKKKACiiigAooooAKKKKACiiigBKKKKAGt1FA+8aU9RSL940AOooooAKKKKAEpaKKAEopaSgAoopaAEooooAKKKKACiiigApp9acelMPpSAVRxTqKKYBRRRQAUUUUgGMvORSq2adTCMcigB9FNDU6gAooooAKKKKACiiigAooooAKKKWgBKKKWmAUUUUgGng+xpQaCMikFADqKKKAClpKWmAUUUlAC0UUUAFFFFABRRRQAUUUUAFFFFADT1oXpStSDhvrQA6iiigAooooAKKKKACiiigAooooAKKKKACiiigApKWigBp60i9TSnrSL3oAdRRRQAUUUUAFFFFABRRRQAUlLRQAUUUUAJRRS0AJRRRQAh9KReTmgngmlUYFAC0UUUAFFFFABRRRSAKKKKAGEYORSg5FLTSNpyOlAD6KQHNLQAUUUUAFFFFABRRRQAtJS0UAFFFFABRRRQAUhHelopgIDS03ocU4c0gFooooAKKKKYBRRS0AJRRRQAopKUUGgBKKKKACiiigAPIpnofSn00jqKAHUUinK0tABRRS0AJRS0lABRRRQAUUUUAFFFFABRRRQAUUUUAIetNTv9aU0J0NADqSlpKACiijNABRRmkzQAtFJuFJuFADqKbuFG72oAdRTcn0NJlvSgB9FM+b2ow3qKAH0hNN2n1pADk80ADdRTs0AZpcD0oATcKN1LiloAbk+hpMn0p9FACUUUUAFFFFABRRRSAYflPtTgaWmfdPtQA+ikBzS0AFFFFABRRRQAtFFFABRRRQAUUUUAFFFFMBCKQGnUhFIB1FIDSimAUUUUAFL2pKWgBKKKKAClNFHagBKKWkoAKKM0ZoAKQ0uaQkUAIvUinU3oQaXNAC0UmTRk+lAC0UnNHNADqSkwfWjB9aAFozSbfejbQAuRRkUm0UuBQAm4UbhS4HpRigBN1Jk+lOooAbnOaQA44pe5pR0oATBowfWnUUAN2n1o2+5p1FADdg96NopaKAE2j0pcCiigAooooAKKKKAEpaKKAEPSmj+dK3TFIOW+lAD6KKKACiiigAooooASiiikAUUUUAFFFFABRiiigBvQ04HNB5pvSgB1FAOaKAFpKKKAFopM0ZFMBaKTIo3CgBaKbuoz7UAOopuT6UvNAC0UmDRg+tAB0pwIphyPenDFIBc0maMCjA9KYBuFAb0pcUCgBM+1GT6UtFACc+lKAxFFKKAG4PrRtPrTiKSgBNvvRtHvS0UAJtFG0elLRQAwdPpT6aep96cvIoAKWiigAooooAKKKKACiiigAooooAKSlooASilpKAGnvTh0pp704UAFFFFABRRRQAUUUUAFFFFABRRRQAlFLSUAFFFB6UANJ60qjimnnAp9ABRS0lABRRRQAUUtFADaKbg0Y96AHUmaNtG0UAGRRuFGB6UuB6UAJuo3UuKKQDcn0o59KdRQAwHnHQ07B9aGXP1pAexoAXHvRinUUAN2il2j0paKAEwPSloopgFFFFABRRRQAUtJS0AHUU0cHFOppHegB1FNBp1ABRmiigAooooAKKKKADNFFFABRRRQAUtFFADW7GhepFKeab0IoAfRRRQAUUtFACUUtFACUUtFACUUtFACUUtFACUUUUAMPQ06kPSnUAJRS0UAJRS0lABRRRQAUUUUAFFFFABRRRQAUjUtNY4FACLy2afSKMCloAKKKKACiiigAooooAbRRRQAUUUUAFFFFABRRS0AJS0lLQAU0jP1p1FADQadSEUgNADqKKKACiiigAooooAKWkooAKKWigAooooAaRg0ooPIpBxQA6iiigAooooAKKKKACiiloAKKKKACiiigAprDrinUhFACg5GaWmp3HpTqACilxRigBKWjFFABRS4oxQA2inYoxQAlJinYoxQA2inYpMUARn+tOprf1p9ACUUUUAFJS5FJkUAFLTdw9aN4oAWik3UZ9qAFopMn0o+b0oAWik+b2ow3rQAtMPLAUvIPWgDPNADqKTbRtFAC5FJkUbRS4HpQAm4Um4U7FFACbvajd7UtFADOlLRSdKAFooFLQAlLRRQAUlLRQAUUUUAFFFFABSEUtFACA0tIRQDQAtFFFABRRRQAUtJS0AFFFFABRRRQAUhFLRQAgPalpp4p2aACiijNABRRkUm4etAC0tN3j1o3UAOopu72NG4+lADqKbk+lL81ADqQ9KT5vajB9aAEHEn1qUDNRr1GfXmtdIo1A2qPrQBnKpJwBk1IbeQDO01fCgHIAB+lLQBmiJz0Un6ChYnbopP4VpUUAUFt5CcbcVIbQ4+8M1booApC0c+g/GgWj55wB61dooArC0/wBr9Kk+zx4xt/WpaKAIPssee9MmtUETMuQQCatUyVS0TKOpFAGRjOKXb7mjHIp1ADNo96No/wAmnUUAN2j0pcD0paKAExRRS0AJRRRQAUUUUAFFFIelADTz+NOHApo5P0p9ABRRRQAUUUUAFJTTIo70quG6GgB1FFFADaKKWgBuPSlFLinpEZDhRk0AMxSVZNpKBnbmoCMUANooJozQAUUmfajJ9KAFopOaOfagBaKTDeoowfWgBaQijHvRj60AANLkU0jHPalGDQAuRSbhS4oxQAm4UZ9qdRQA3PtRk+lOooAb83pR83tTqKAG8+tGD606igBpB9aBzTqaRg0ALtFGBSg5ooAMD0owPSiloASloooAKKKKACloooAKWkpaAG45rUtTm3T6YrNq7YsNjL3BzQBaooooAKKKKACiiigAooooAKKKKACmS/6l/wDdNPpk3+pf/dP8qAMruKWjuPpRQAUlLRQAlFFFABRRRQAUUUUAFFFFABTWp1Mbk49aQCoOM0tFLTASilooASkIyMUtFAFd7cHnJz6VJCm1eRg1JRQAUUUUARgjuTV21NuwCsBu9T3qpJEyH5lI+opE2qfmBpAbHkRf3BTwqr0UD6CqNveKvyPnHY1eBBGQcg0wFqvPbbyWXH0qxRQBlPGVJBHNRkVqSwCXnODVGWIoxBoAgpKeRTcUAJRS0UAJRQSB1pAwPQ0ALRS0UAJTT8v0p9FACA5paZ90+1PFABRRRQAUUUUAFFFFABRRRQAUYzRRQA0cU6kI70A0gHUUUUwCiiigApaKKACiiigBaKKKAFqezbbMAf4hioKVG2uGHY5oA1aKAcjIooAKKKKACiiigAooooAKKKKACmS/6l/900+o5/8AUP8ASgDM/i/ClpP4vwoyKACijIpNwoAWik3expN3saAFopMn+6aMn0oAWikyfSj5vagBaKb83rRg+tADjTBy1ISQetHSkBJRUJfBxmkMi+tAE2aMj1qDzF9aTzVoAn3D1o3j1qDzl9DR5y+h/OgCfcPWjcKr+cP7v60ebnov60wLG6jd7VXDuewqRc5+bFIDbljEiYPXsazp7WRCTjI9RWpQQCMHkUwMMZQ9KsQ3bRnGMj0qeayyCyHPtVFk2GkBsRSrKuVP4U+saOZ0YFTg1pQXIlGG4b+dMCemSRLJ94U+igDOmhMbY7djUBFa5UMMEAj3qlPblSSoJX+VAFTFJTyKaRQAxlDDmo0hw2Tmp8UlABRRRQAUUUUABpv3fpTqKACik6HrS0gCijijIpgFFJuHrRuHrSAWik3Ck3CmA6ik3expN3tQA6kPBpN/0/OkyT6UgHg0tMUmnc0wHUU3n1owfWgB1FNx7ml2+9AC0Um2jaKAFyKMijaPSjA9KAF';
        evidenceValue = evidenceValue + '3CgEZoxQelAGlbNugX1HFS1TsX5ZO3WrlABRRRQAUUUUAFFFFABRRRQAVHP8A6h/pUlR3H+of6UAZp6mkwKXuaKAEooooAKKKSgAoopKAFopM0lIBc0hNJmmmgA6mlJwM0gHBpsxwoA6mgCHP3m9eBSY5C9+pNPA+YDsozSBSVJ7mmAzrkjoKTBqfyuAOwp6qoOSM0AVcGnBGNWhtH8I/Km45pARLF6mnhAOgp2KKAEpyrnmkAycVIcAUAbKsGGVORS1lRTPCflPHoavw3KSjGdrehpgTVDLbRy5OMN6ipqKAMeaExnBUimA4PUitplDKVIyDWfPZsoLLggfnQBJBeDhZGz71dBBGRyKxMFTViC7aM4x8vpQBp0U1HEi5WnUAVZrbJLJ+VU2UjtWtUMtur5I4Y0AZnPpSc1M6FTgjFMIpAMwaMGnUlMBMH1owfWnUlIBMe9G33NLRTAbsFJjnmn0EZpARkGmkkdqk9jTSKAIjIQeho8z2P50800qvpzQA3zfb9aTzT7UpiHam+U31oAXzT7flSeYfak8th1BpNpBx37e9MB/mH1/GpIn3cHrUH8j19qcCQc9xSAsn1pw5piMGGexpw4OKAHUCiimAtFFFABS0lFAC0UUUALRSUtAElu22dOe+K0qyDWrG2+NW9RQA6iiigAooooAKKKKACiiigAqK5OLdvw/nUtQXefs5x6jNAFAdTRSA8migAoopKACiikoAKSlzSZFIAopNw9aNy+ooADTSaXevrSY+bPNMB39KjI3SZ7CpPwNJj2NIBqoOfenhaTn+7+tGD6frQAuKTFLg+gow3tQAmKOKXDeo/Kja3979KAEpMU7Yf7xo2epNAAMKKbnc3tRjnAp4QAUALSg802lpgW4Lsr8smSPXvV1WV13KcisepI5XjbKHHtQBq0VBDdLJgN8rfzqegCtNZoykoMN169aznQo2CCD71tVHNEsqbT17H0oAy4pmjYEMRWjBcpKAM4b0rOmgkib5hgetNiEhJKDOKQG1RVOC6bISYY9DVwEEZHIpgMljEi4PXsaoTQtGeenrWlTJYxKm0/hQBlGipZomibDdPWoqQBRRRQAlFLRTAKKKKQDSM032PWpKQjNAEZFNIqQ803FADQKXOKXFGKAEJpCAadikx/nFADSg/Om+X0x1FS0Y+tADEGxvY1KelN/A0uT6UAKpp1RnIanjPtQA6im8+1LzQAtLTcH1owfWgB1FNwfU0u33NAC0Um360bRQAtXLOZRGUY4IPGapFRilWgDU82P++v50vmIP41/OszNLmmBoGeIfxik+0Rf3/wBDVDNJmgDQ+0Rf3v0NNN2g6BjVHNGaALn2xf7jUfbF/umqeaTNAFxrwDon61XnundQpAAJ7VHTH6r9aAAA9jS4PrQvSloAbg+po2+5p1FIBm0ep/OjYP8AJp9FADNg9KNg9BT6KAG7B6UbR6U6igBhApQOKQ8mnUAFJS0UAJRS0UAJS0UUAFFFFABSMcUpNNUbjn8qAFUYGT1NOoooAZRSYFGBQAuaXI9abgelLgUALuFWIbwx/Kx3L/Kq1LTA0heQnufyo+1xep/Kszp0pQ2frQBoS3EDoVILA+1ZpX0zin5ooAjCmrEE8kPHVfQ1HRSAt/bm/uD86UXx7xj86p0UATT3DTLt2gDOagyehpaDzQAn40Y96OnWloATHvRj3NLRQAmPc0YFLRQAm0UYHpS0UAIV9KBS0hHegBaKQHNLQAlGKWigBuKKWigBKKWigBCMikU06mn1oAdS0gOaKAFooooAWikooAWikpaACkHBNLSHrQA6ikHSigBaKSimAtFJRQAtFJRmgAprdRTs0xjgjNIBy9KWmK3y0u6mA6ikzRmkAtFJn2NJk+lADqKbk+lLk+lAC0hpPm9qTnPNAAOWJp1JjAo/GgBaSkx70Y+tAC0Um0UYHpQAuaMj1o2j0owPSgA3D1o3CikNACHninA0CloAM0Z9qKKAGA0UmKM4oAXNLSUUALRRRQAUYzRRmgAzilzSZFHHrQA6img0uaAFopM0ZoAWikzRn2oAWk6UmfajJ9KAFBpaYQeopQSaAHUU3mjmgB1FJz60mD60AOopMe9GPegANANGKQj0oAdSZpBg0uBQAZozRgUYFACZHrRuHrS4HpRgUAJuHrSbh607FFADM88U7dQRQOaADdRu9jS0UAJn2oyfSlooAMn0oyfSiloATmg5paKAEHXil59aQcY/KnUAJz60Y96WimAmPc0YpaKAEwKMClopAN2ikK+1DyBTzTA5O7vQOxIBS4qEyEMM8e1PSTd2oFYfRRRQAUUUUwCikopALTe9LSDrmgBaKKSgBaKSigBaKSjNAC0UmRRkUABpB60E5PtS5pgLRSZpM0AOzRSZozSAbijFFFABij60UUALxRgUmPSjNAC4pcUlFAC0UUUAGKTp1paKACik+lLmgBaKSloAKKMUUAIaMUhYetOHPSgAFFLto2n0oASilIpKACiiigAopM0ZFAB05ozRkUmcUAOopM0ZoAWikzRmgBaKTNFABSHilo5oAKWmiloAWik5o5oAWikwfWjB9aAFpabj3pce9AAe9OAJpvQ1o2gUwKdoyODxQBSEbEdDRtPpWrSYHoKYGYI2J4BpxgkH8B/KtKigDMETk4CmnC2kP8JrRooAypLZsHcpA9ap7mQ8VvSp5kTJnGRisKRDHIQ3UGkUhjbtwLVOhARaidg5GKmcBYlA6g5NAMdn2oz7UUUyQzSc0tFACc0c0UUAAzzRig+lFIApMUtFACYo2ilopgJgUYFLRQAmKDS0g9aAFooooAKKKKACiiloAjzRmijNIAzS5pKWgAzR+FFFACc0uaKMZoAWjmk5HvQDmgBeaOaKKADmiiigB0e3eN+dvfFaKW0DLleR65rNqSKZ4jlT+FAGiLeIfwD8arX6IkalVwSe1TwXKS8fdb0qLUR+7Q+hoAzRjGOhq5p8auz7hnA4qpj5q0tPi2xlz1b+VCGyyI0HRF/KnYGMYoopiKs9qGyycH0qkyFTgjFa9RTQLKPRvWkBl4pMVLJG0bEMKjoASiiigAooooATpS0UnSgBaKKKACiijNABRRmjNACH1paKTODQAtLSUUAFLSUUALRSUvNMAq7YP95PxqlzU1o5W4X34oA06KKKACiiigAooooAKyryMLcPnvzWrWfe/wCv/AUgKPl7cNjjOKmkO8Y6cYpS2U244zmm4osNsKSjApMimIXNFAxRSAM0UUUwEzRmlooATPtRn2paaWwwGOtAC8+lHNFFABzRzS03NACnmjmiloATn1o5paKAExRilooATFOApKnt4vNbHYdaAKtGaUjFJSASjNIWA60oOaAFzRmkooAXNGaKKAFzSUUtACZpc0UUAFLSUtABRzRRQAuSKsRXZUbZRvX3qvQPU0DRfie3mk2rGMkdxVscDArGR2Vgy8Ed60ILtX4f5W/Q0IGWaKKKYgooooAbJGsi4YVnz27RH1X1rSpCAwIIyDQBjkUlWLqHyWBB+U9Kr0gExRxS01VwxNMBcUYpaKQDRwcGnYpCM0A4oAWijNGRQAUUZozQAUEcUZooABS00560tAC0UUUwCijmjmgBaBwcikpeaANZG3orDuM06s2G5eNNoxgetSfbJMdBQBeoqh9ql/vD8qBdyeo/KgC/RWcbmU/xflQLmUfx0AaNZ16f9IP0FI08jHJc1CSS5JOaACim5+fHtTsUgEqNkOeCKlxRigBijA96XinYoxTAbmjvSt0oHSgBKKWkoAKaRkj2p1FACUUtFACE0Ad6ByfalpAFFFFMApKWigBKPxozSFu3egAJqSKR4jlWxmoxxS5oAt3LWzRkp9/tgVRzRmkoAQkGjcKMUhWkA7eKN4qIqRSc0AS7hShqgpRmgCwDmiolY08NQA6jmjNLTAKOaM0UgClpKOlAC4o6UA0HNDGtwzmlFJ/Fn8KXNAMkE0ijAdsfWnC4k/vt+dQ5opiJTNITy7fnQJpB0dvzqLNLmkA9pXPVifxoErjozD8aZS0ADsXOWJJ96b0pfwo/CgBMUYowRSigAxSYpaOaAExQVpeaOaAGiloIzSZxQAtFMMmO1NMuO1AEtLUHnGjzj6UAT0g44qDz6esm4ZoAlpaYGyKXNADqKTNHFAC0UnFLxQADg0tMPBp3FAC5FGaKKADIozRS0wEzTf4qfTV+8aQDTxKPpT6GQ71PpTsGgbG/hR+FO2n0o2n0oEM/CinmNgOhpjAigBrGmGUDjFBHembM0AL51HnUgQUuxfSgBPOpfMY0u32o2nsDQAAse9BznGaUAj604JigBopafj2ox7UAMxRin49qMe1MBmKMU/8ACmk9hSAafQdaULilAxQTigAxSYo3e1JupgR5paTFGKAHUU3BpeaAFxRgUYNFABgUuBRSUALgUcUnNLQAtFJRQAtKKSigB1FNzS0ALilBIptLSAUUUmKKAHUUlFAC0dKSloABzTgpPQU3Aq5b3QACyf8AfVAEPkSYzsP5Ughc9FP5VpggjIORS0wMwwSDqhoFtIeQprTopAZTxun3lIphrXZQ64YZFUZ7YpyvK/yoAq5ozTiKSgBKawz9afRQBCVz9aQqfSpiAaQHsaAIdvtS7PapeKTigCLyx6UqrtPAqTijIoAYCQelOA9qXg0oNAAPpS4ozS5oATBowaXNGaAGsDilXOOtOzTVPagBcH1pcGjPtRn2oAMH1owaM+1LQAmD61ZsolcsWGcVXq5Y9H/CgCxsXGNo/KgRoP4R+VOopgJgYxgUYHoKWigAqnfkYRR1zmrlZ1y2+c47cUARbRRtHpRR+NABikxS/jRj3oATFGKXFJjJoARR3paXAoxQAlFLikwKACkpcCkI7CgBpPYUDgUu3FIaAAkU3r1ox3p1ADCOaMUpooAjopaKACgUtFABRRRQAmKMmlpKADNFIabmgB/NGabmjNAD80ZplLmgB2aKbmlzQA7NGabu5xRQA/NGaZmlzQA6jNNzS5oAdmjNMpc0APozTM0uaQFiK4eI8HI9DV+GdJRwcN6GsjNKGI5BxTA26KyxeTAfe/SnG9lI6gfQUAaVFZgvJR/F+lIbuUnO4/hQBZubYbS6cY5IqiTUpvJSMbv0qsTSAfRmm5ozQA7NIabu5xRmgBwNGRTTQDQA7IoyKbmjNADsikJxzSZoyKAHBhS5qMHFLuoAfmlzUe6l3UwH5pM4am7qCaQEmaM0wNRmmA/NLmmbqN1AD81PaTrHuDA8+lVd1Cnk0Aaf2qPHekF2noaz91G6gDRN2nYGkF2noaz91G6gC894oU4U57VSBPU96axzgUuaAFyaTcaM0jDIoAdk0vNNBo3UAKSRQBgU0HJzS5oAdRTc0ZoAdRTc0hagBx9BQBTRS596AHYpjDBpc0hNACUUUhNAAaSnDkUlAH//2Q==","ImageType":"jpg","Type":"2"}],"Hash":"184A1B6C57B7BAABB381DC7EEAED162FBF4CEFD1"}';
		return $.parseJSON(evidenceValue)
	},
	getSignDataValue: function (evidenceHash, plainData) {
        var ret = '{"SigValue":{"Algorithm":"SM2","BioFeature":"ewogICAiRmluZ2VyUHJpbnQiIDogewogICAgICAiRGF0YSIgOiAiLzlqLzRBQVFTa1pKUmdBQkFRRUFZQUJnQUFELzJ3QkRBQlFPRHhJUERSUVNFQklYRlJRWUhqSWhIaHdjSGowc0xpUXlTVUJNUzBkQVJrVlFXbk5pVUZWdFZrVkdaSWhsYlhkN2dZS0JUbUNObDR4OWxuTitnWHovd0FBTENBRWdBUUFCQVNJQS84UUFId0FBQVFVQkFRRUJBUUVBQUFBQUFBQUFBQUVDQXdRRkJnY0lDUW9MLzhRQXRSQUFBZ0VEQXdJRUF3VUZCQVFBQUFGOUFRSURBQVFSQlJJaE1VRUdFMUZoQnlKeEZES0JrYUVJSTBLeHdSVlMwZkFrTTJKeWdna0tGaGNZR1JvbEppY29LU28wTlRZM09EazZRMFJGUmtkSVNVcFRWRlZXVjFoWldtTmtaV1puYUdscWMzUjFkbmQ0ZVhxRGhJV0doNGlKaXBLVGxKV1dsNWlabXFLanBLV21wNmlwcXJLenRMVzJ0N2k1dXNMRHhNWEd4OGpKeXRMVDFOWFcxOWpaMnVIaTQrVGw1dWZvNmVyeDh2UDA5ZmIzK1BuNi85b0FDQUVCQUFBL0FNbHJtZVNCb1pKcEdpWTVaR2NsU2M1eVI5ZWZyVFVqVmZ1cUI5QlVnRktCNlU3RkxqTk94U2hlYWNGcGR0TzIwWXBRdEx0cGNVQVVvV2t4elNGYU5vSW9LMDNiUnQ0cE52dFRTdWZwU0ZCelRTbEpzcHBTbUZCVFNuRlJzZ3BWcVFEbW5nVTRVVThEMnBjVTZuQmFkM3hSam1uWXBhTVVZb0FwZHZwU2JjVWNIdnpTNHBNVVlwdTJnakZOSXBNYzAwaWtJeFRUVE1acHBGUk9PYVJSMHFRVThVNENsRlB4NlVvRk94VHFVQ2xBQXBhY0I2MFk5YWlsazJZR0NTYVVNVkdYNlVpU0dUN3ZBelN5cm1Oc3RqTk1pa2pYZ0VrZ1VxUzVib2NHbitjZ2ZabkJwTnpDUTU2VXFzR3pqdFNuclNIM3B0SmlrSXBoRk43MHdpb25GTlhqRlNEZzArbkwwcDJNMDRVN0hBcDFLQnpUZ0tYdFM5cVRsU1RuaW1MSnVjZ2dnWXFPVzRSSENBYmpVa3Npb2dkaG4ycUtOMm1iNVFWVVU2VkY2U1BoYVNOSW94OHJBazFFclQrWWNxTUNwVlZKaXJkRzYxSVNWWWc5S1l5bUxsQmtFNU5PVEorZjJwLzNoNlUxVnhTRVlPVFNFOXFhZXROSXFOaGlvMzZjMDFhZXRQSDBwNHB3NEZLS2VLVUR2VHFVQ2xJeU1Db0pQTUxxbzRVZFQ2MGp5ZWJJRmpianZpaWFYRGVYR1BtUEJxTUtscU56OHUxT2lJS21XVnNLZWdOUlBkdTN5d3IxOUtzQ01HRUdZOGtjazB3UVFrRGE5TzhtUUViSHlLV1NGbWRXVTR4MXFSc01kcDY5cWhqZHhsWlBXbFdSbGZZMVNBbGV2SU5PTk1aU2VCU1UwMG1LWWVsUlAwcGkxSUJUMXA2MDZuTDBwd0hwU2pwVGg3MDZtdm5ISFUxRGN5TEhGdFkvTVJ4VU1HMjNoRHQ5NXZXbkJ0aXRNdytkdWdxRlY4eHZObXpqUEFxU1JmdEFHUGxqV3BJM1RBU0hrampPS1pKSEpMSUF4d0JTaTFPM09jTVR6VVE4MjJuK1lrb2FsVjVOeXNoeXJHcDVPVkRBZk1LSEc2UFBlbVNLR1FIdlJKS0VpeWUxSTh5ckVKTzFLSmg1WWZzYWZrRVpIZW0wMGowcU5xaWYxcHFWSUtmVGdLY0JrVTlhY0JTZ1U3dFZXT1YzdVNHR0FCVDBuTDNCWFBDaXFwSnVMd0EvZEJxYVpZNXBsVFBJcGtxK2RjcWl0OGk5Y1VwekxPRVhpTk85RE41eitURnd2clNncGJsbFFaYkhKOTZJbzVaSHl6SEZUU282b05wT2MxSXhEL3UzR1RqclZhUE1FM2xuN3RTcWZtWkQzNlVxWjJPcDY5S2pKUDJkczlxaTRhek80NXBIVVBaZ0RrQ2hGZjdLQUJrMVppQjh0ZHd3YVUwdzB4cWhjY1UxUFNwVnA0RlBBcHkwNENuYzBvRkt4d3BQb0tweHlMNVVzZ0hPYVphY1JTeUhybm1pMkcwU1NrbmdZR2FaYnF3ODJjbm9PS1ZENU1CY2N1NXdQcFQyazh1TlkxNWR1dFNCUkRGdGpBTWg0UHJUMUF0a1pwT1NhV0ZuUDd4aVZVVW4yOWZNSUsvTDJQclRmdGF6T1ZqVWh4elQ3ZVVYT2R5NFpUVW0xR2wzQThqdFVhSy9uT0dIeW5wVGhBUExaU2V0TVczUllXWE9RYUYyUng0L2hGT0RxRUJIU25BaHVRYzBqVTFoeFViVkRKMHBxVkt0UEZPSFduMDRDbkRuaW5kS2hXUkNyblAxcXNBUHNMRWR6VEYvZFdlYzh1YWZqR25nZEMxRHEwTm1pWXlYUE5TU1JyR1ZlUTRWUndQZW1SQlFHdUpQWGlwYlZUdWFhUWpCNlZYbGRncG1jNXowVTFhdDNOd054RzFNWXhURU51MG14ZVhHY2NWQTBndDc0RngyeFVxUDVkNEFvK1Z4bk5LcDhxK0s1KzlTck81dXloUHk1cDRsWnZNejI2VTFTV3RtUGVrOHRudHdHNm1uZVZpSUtmU2xpak1ZeG5pbm1tR21NS2drNkdtcFVvcDQ2VThkRFQxcHdwMmNWRzBoOHVRNHdRS3BSWmExbEo3bWdGVnNNSHVlS1c0VlRacGc4QVpGTGNzUExpajdtcEoyM1hFTVFQM2V0TnVzWFZ5c0k2TDFwR0psbkVDajVGNHFjbFhrV0ZmdXFPYWprVlo1eUcvMWNZcHFGNWlmTGJaR3ZTbXBibUtkQ0R1NzhVWEdMcU5tQStkRHpUb295RmhKT0RVczBKYThSaFRsaDIzTE9hRVhha2pkYWxSUjVRNHhtbXlIQlZlOU9QTGZTZzAwNHBoT0tZM1dvWkJ4VEVxVmVSVWdGUEhTbkFlbE9IV2h3U3ZIV29KSEloa0J4a2NWQXJGRWFFZjNNMVhjSDdJdis4YW1taUlodHdlZTFPblV0ZUlnSFFDcHYzZjJoNU0vZEZSV3BBRXM1N2NETlBpY0pibWJIenNjQTBXcEVNVFRTZmVQVDNxYUpFVzEvZW5HL3JWWlFKQ3lRa2hjOFU0bHJlNlVEa0hwVHR2azN3QzlINmlwYmhXYTVqUk9nNW8ydWI3T2ZsQXFiajVtNmltUExzVkJqSmFsYVFCMVh1YWRnRTU5S2FXVmNtaFRsYzBVdzlhamIycUdUcFRVcVZha0ZQcFFEbW5pbmpwVldWTXhTWUhKTlY1TUpNcFA4U1lwakVmWkkvY2tWWUxITHJqS3FvSXFRU3FaZk14OG9YT2FZcUtiZVdSVG5mVVU4Uml0SW94MWM1TkV2RHgydzdBWnEwUkhLNnhEQkM5YXJYTE5MSTIwWVJCU1N5YkxkRmlUQmJyVm5hQUlsWVpaY0VtckJqUnA4NCtaUlNBS1o5MmVncEVZRjNmM3hUTHA5cTdGNExHbmNEQ25xQlZXRWw1WkpPM2FoSkdTSm5ibkp3S0pBNVZBUDRqazFZUWdmTDNBcFRUVDFxSmhVTXZTa1dwbHBkd0J4M05QWG1wS2NPb3BHUWtnZzR4VFNBaXVjOU9hcnlLa3pSU0U4RVlxSjRpSVkxOUhJL1dyTWpwaVpCMUMxVlJzYWV3T2VUZ1ZMRy9rMmNQR1FUazBYc2lpNGlIcGcxQmsvd0JvdVcvaHlhbHMvd0J6Qzg1NUo0Rk5tbXdpeEwxY1pOU2hkMXdxamtKMXBrRWpQZU81UHlEbjhLdndUTE1yU0tLcnE1VzJrY25CNkNtcXpDU09FZlUwbzN0Y3N6L2NXbExNOEVqTDk3a0NvOWp4Mm1NZk9hZDVmeVJxZWNISnAzbWhVWjI0VWRLZGJuZUMvclR6VFc2ZTlSRTlhaGs2VUxVcWlsMmdrRTlSVXFqaW5DbjAyUXNNYlJubm1xNzVMelI1NnFjVkZicHZ0dHVlVmFyTTBZV0pBRC9GMXFFSUJjekR1eUhGTVpHZTFLcU0vTlJPRit4UmtkdUtXNWpFanhTOFl3S2JkQXBkczRYSzR3YWZjSUk0MGhUbGNaK3RTdkZFa2F6TVBtQ2pGUlE0aWhlUno4OG5TbDhrd1dwSzh1LzhxbGljVzhTeEg3N2RhanVsQ3JERDZuSnFXTmRyUE0vWGtDa2trMlJLRzZ2U3NoQ0pHUDR1dFNTQVpBUFFWVUVqVFBJWTg0SEFwc2tiTjVjUStwcTZxQkVDanRTR21tbzJIV29aT2xJbmFwVkhGUEE1cDROUEhXbmltU3ZzVTQ1SXF1emdYS0hIM2gxcUtFbU9lVkIxSXlLYzBqTmE1UDNrZW81WmR0MUU1SEJBcVVOKzdtang3ajZVeGYzbHE2NTVRNS9Dai9XV3Fsc2d4bkg0VSs4Vm5SWkUvaUdEVDRsV2VGVlp0c2lEQnBXajhvczg3Qms3Q21oVm1rTTJNUm9PbElqaTZiZTJWVktJMFc2dS9OL2hXcEpGRXQ0aEgzVkhXbWwybnU5Z0h5TDFwV2hhUzRaMis0ZzRGT0RzcUdXUVlBN1U4Z1BHV1BCWWNVa1VTUVI0WHYxTkNoRlV1S2NqaDF5T2xJZXROTlJ0VU1nd0RUVTVxWmVsU0xUMXB3NjA4RE5SVEprTWY5azFUWWxvb24vdW5tbk93VzlROW1GT2lCODJTSmh3eE5KSkNaQW94OHlmTFRsVVIzaFZqOTRiYWdpUm83MTR6OTFnVnFTQmRrelJ5Wnc0SXA4VC9aNURGTDkxdWxLYlVObnkzeVByelNOWmZMbVdRNEhYbW9ta2FkL0tpQkNBOWZXblRIQit6VzQ0L2lOVGxmczZwSEYvSHd4NjA2VkNpQ09MNzdVNDRoVlVIM3oxT0tra1lJZ0pQMXFKcEJJaWdqTzd0Uk11UW9VNFVkYWlSdk9iYnp0QnhuTlNLUTJZOGNDbnJnREFHQUtEaW1FWnBqQ29KVG1rVHBVcTlLa0ZQSHJUZ09hZUJ4NzAxTW5jckNxcXhnd3lKNkhOUmtHU0ZXVDd5bkZXU3BrVlpGNE9lYWZMOGhFcTl4elVGNG5uYlpvK1NPdFNTamZENWdYNXdPYVJHOCtGaUFQTUF4UUFzaWJibmhoME5RdGFPcExSU2dlZ0ZLdHJJMlRQTWRvNmpORXppUDhBYzIvRGV2clNnQ0ZDQVEwemVsUEVqUXB0YjVwRzV4NlZKNWh3REg4em5ybnRUWFpuZlloL2VkejZVanA1b1ZFYklRL01hU01iU3p0d09paW56RUpEN3RSQkY1VVdPN2RLVmtLcUF2VTlUVWdYQ2dkYVExR2VsTVkxWGs2R2hPMVNyMHFRY1Uva1U4ZEtlS2pra0tNdkdjMVhkekZOdTZvMU5RckRPeUg3c25OVHhrUnNZczh0MDlxa0RMR3ZsU0VZSTYxQ2hhS2JZUmxINzBqbDdlNFBkV3B6d2xDSGdPZWM0cGpYRWNyYlpSc2YxcHBzM2JESTQ0NzU2MDE0U3I0bm1HTTV4bW50SjVpNHQweTJNRnFZcW1FYmM3cG0vU3JBVkk1VHZPNTI0SHRUWHhiS1FuTG50VENSQ3UxVG1WeG42VkpFZ2hqMlorWnVTYUIrOW16L0FNc3dLbDRjWkk2ZEtqUnk3TXhIQTZWSkNDRjNNYzVwemVsUmswMXFZMVY1T1FhRTdWTXZTbmluanBUeFR1eHFFNTJaUDhKcUZrRGxrejE1V21yOHliV1g1NHhVamt5eEs4ZjNoMXAxdzI2Q05tSFhyaW5SdnQycGpLbm8xSUpqdkVjNEhQZWtjUGJrdkdkeUdrQmh1VitjQkhOSDJabzIzQ1Q1U01aelVjME1La0Y1Q1RqbkhOU0NYQ2lPMlVqSTY0cHNaU0Zoazc1V05UVG9JQTB2M3BEMEZWa0R4cjVzb3k3Y0FHbFVGQVpKZjlaMEFvZU4yR3dINW41WStncU1NVWoyb1R0empQclZ0M0tiRlZUOHdvWlNYVkFNRHFUVStLUWlveU0walZHM1NxOGg3VUlhbFhwVWkwOGNVOWFjS2psWlZPMDlHcXNaUmpDL2ZTcEF3T0p3T0NNTlFOc1RoMTVSdXRTU3lnQUVnR0krbmFtaFFvVjBKS0E1eFRwRWp1U2NFQjhVek1sdTIxbDNKVHhIYjNCRGRDTzFEMjZzUVBONEhZbW5mWnJjTVhQSit0UnE3U0I0NFVLK2hxYTFza2dPOWp1ZjFwWnpHamIzNVBRQ28vdmp6SmVGSE9LaU1pTklHQzVadW5zS2tqWldKVkRuSDNqVVd3TTRPM0VhZFBlcDVKUW9YQStadWxTRGpIdjFwcFlGOXRLZXROUFBGTWFvMjZWWGs2VWlkS21VY1ZJdlNuajYwOFU0R3ExeURMR3cvaVhtcW9WbmtXVWZlSERDcm13UjVVNDh0cWlBTWNubHQ5eHVudFVpSnNieXlDWXo2MEtIdGkzRzZNMGVXczU4eUJ0ckRpbnJPMGFiWjE1NlUxVGJPM1pUVFFsc1pYWXk5ZTFLc2tDZ0JSdnhWbUdVN0NTdXdkczB5ZTRDQmduTDFFc1J6NXR3Zmw2Z0dnWm5tSGFKUm1rWXJLeFNFY2RDd3FSRlJCdFRvT3BwcVB1azVHMUIwOTZrbENxZCtNbm9LZEVyQkJ1T1QzcFBMSG1iKytNVXBwaDROTU5NYkZRU0RpbUoycWRhZUJVaTlLZXZTZzlDUlZhUi9sOHhmeEZNVWJKQklPVWJxS3NGUVFZMno3R21jY3hPZm1IUTAyTm15WTV1aDRCb2J6WUdQOFVkUFJJMkhtUk50SjZBMHFYQkRFVEorTkk4bHFUa2c4MDd5N1ZTcFBWdWxOYWRZMjJReDg1eFVYbDNGdzUzZktvUDBxMnhpUU15L013NjFDRmVaZDB4d25YRk5NMjUxamlIeUVFY1ZJWTl1STE0VUQ1alNTUmtiVkRiWSs1OWFaMUlsYjVWVG9QV294Y1NNcnV5NEg4STlhdDJvWVE1YzVKNU5TbW1rMDBqaW96VWI5YWdsUEZOanFkYWVwcVFVNWFkbmlxaElpY3FSbFhOU3dwNVpZSGxlb3A4b0JYY3A1RlFuYk1NL3dBWXBxTUpSNWN1UXdQQnA0V1dMSWI1a3A3ckMwWEIyNDZVeUJvNCtIY1BucG1ubUNDUWdnKy9XbXlOYlJzTjJTVnFXT2VKOTdLZ08zdmpyVVJNOHg0K1JjMUppRzM1SnkzODZZVmx1TWZ3b2FlcXBBQWtZeTVwR0cxY3pOazU2Q295U3krWkw4cWc4Q21xM21qZklOc2E5QjYwMTVjcXo5aHdvcTNib1VpR1R5ZWFrcHBGTk5NUFNvbnF0S2NBMGtmU3AxcVJha0hTbkw3MFNESUlxaXJBczBibkpISXpVZ3VodGJqbGVvcHBtWkNKRTVROXFjVTh6RTBYWHVLbFF4eThPTU9PYUMwMFpCQTNnbnRRMHNNNkVTamI5YWlTMnR3MlZrN1ZLdHZFc2lzSDRIU2srejI2bG5aK080cDhicEg4c01mWHZRNlhCWGNTY2s4QVVyeHh4c1hsT1NlZ3BpWEVrMlJHTUtEMXA0QldNaER1azlhWnhGaVNkaVQyRkxLeU9FWjJ3bldtWEtpVkVDbkVmVTRxSjJVSmtqQVg3bzlhdndGbWhVdndUVHFiNjVwcDZHbUdvbXFyTWFJK2xUcjFwNHA0cDRwWk1sUGw2MW55SzBqaGw0ZFR6UTZGSndTUGxZYzB0c2g4d3h0eWpkRFV3VnJjNS9oN0FVOW8xbVV0SDk0am1teHRMRVNDdVZxWVBES256REE5NmExdkRLUVZiR2VtS0RheGM1WTAxL0lqd3YzMjdBVW84em5vaWR2V3JJZmNoUlQ4d0hXbWVRSEpNcDNlbFJGSkdmYWc4dEIrdFBkeEFuc09CN21xYktXQmtuSnhuZ1U1RWFkaEpJTnNZNkNwSndyWU9jUnJUWVltdXBBN0RDTDBIcldoMEdLU21rMHhxWTNTb1hxbmNOak5PajZWT3ZhcEJ4VHgxcDRwWkJsZU9vcXVJOTdxNEdEbm1vSldLWEJSdnV0VTF2R3doWUhyMnAwRXU1U3N2VVU5WWgxaGFvMnVXUnRyTG4xcHhNTGZNVGpqMW9RUXVGQ3RqSHZTbTA1Sjh3OCs5Tk5rZ0c0eVlQclQ0NDBqVXlGaS9hZ0dXUnhzQVVHcE54aTJwZ3VjOG1sdTVmTFZXd1Nld0ZOMkNXTlpKQnlPY1ZXWldiNTVqaFFlRjlhbXlKSXdXRzFCMnBpcDlva0I2UnIrdFhJK01xQmhSMHBUU1UwMDFxalBGUXlISFNxRndlMVN4R3JDbW5pbmluanBUd2FiSnh5T3dyUHZNeU1wSFQxcWR2TWpqWHkrUUJUZk1XVlNyL0t4cVVLMEVMRk1FbjBwa2N2bW5FcTRQclJMYndrYnQzRkxEYVJxeXNyWkhXcHpFUXVOOUhrcTNMUG5pbXRLbzJ4eEp1QXBTN1JrTTdZLzJha0xPeERBQUtSbm1vWnB3Y0tuek9LRWtNYS9PMlc3Q3BGaTg3RFM4RHNLa2VKWFVEb283VkJ0ZDVkaURhZzcxY0F3TVVoNjAybW5yVFc2Vkd4NHF2SWFveTFMRWVLc0wwcVFkS2NNMUl0T1VZcUdRbFNXQnlPNHFCTU16TVdHdzlxbkxHTUFLQVZwSkk0cGV1RmFuUXBKRXBCTzRkcVZXamtKM0xnMFNRUm5BTGR1S1JiWWdqNXVncHIyN3lINTVEaW5NaVF4NVpzZ2RxY2poNFNZRkdhaWtmYTZxNExTR3AxV1NTUDV2bCtsVkMyQ1VnVG51YWxUYkY5ODVjMUlyeXFqTTQ3OENwZ3pHTUhIUHBVZ0lwYWFldEl4cHAvV21OVWJWQklLcVRERkVOV1Z4VWdQUVZJRG1uclR2V29mSndYSlBEVkVrQVFuSjROS1dNTGplY3FlbFBmeThBblBQY1ZJV01jUzRCYW1MTWpxMlJqSEhTZ3hLM1IrUjcwdmxuZ0NYZ1UwUUhrRitQclQzaWpJK2R1bnZTckpIQ01MMDlxWkpjQitVVExmU3A0WEpqSmtHS2preWZsakFCejFwRmdFV1crODNiTlM4Z1lQSk5TeEFoY04xcFdGSFFVM3JTSHBUYVkzU296MHFKK2xVcCthSWUxV1Y3Vkt0UFduclRxamtZaVJSaklOUnprRmxROGR3YWZLeWJWVis5Um9qSzJPcVo0cXc3RXArNzZpb0ZkSEpSMXdUVWl3cUNTcmRSaW1HM0pWUWpuUGVubTJZakJrNXByVy93RGVmSXA0U0pHOTZWSERIYkd2WHZUMGg2N21KOXFZNlNTVFl6dFNwWHpuYXZIcWFZWk12dFhrMU92QzBwNXBLU21tbW5wVFQwcU05S2hjMVJtUE9LV0dyU21wQWFrV25EclQvZWdjMHlRS3pBSHIycUptRHZzUFVkRFVnTFJxZHd6aW1HUS9mak9mVVU0dkV3QllBR2s4a0g3cmtacVNLSW93TzdnVXBJRW1TM1NrV0RLbmMzQnBDSTRnU3g0UHJTUXN4ZkNMaEtmSklJMkp5U1QwRk5VdTdxeEpVWjZldFN1emIrUjh2clQ0a1ZNNDcwNDBwN1UzdlNFK3RJZUtZMU5KcU56aW9ITlVwK3BwWVRWcFR4VWdOU0tlYWNLY0tjS2JLbTlmbDZpbVE4L2ZISXBHWmk1VUg4RFREc2hmUDZVcE1Ubm44NmVrYU4wYjlhbldNS2NscXJQY';
        ret = ret + 'm1NczV5M29LbUt0SkV2TzNGTVpZMWpiSjNkNklKR2REbGRveFRvTnBZak80anZTT3FyS0NTYzU0RlRTb0pGQUp4VWlqQXhRZXRKU1pvTk1icFNVeHFqWTVxQ1E5YXBTOVRSQ2F0Um1wUWFrQjcwNEhOT3ArYVVVeGg4cHh3YWpqWGNRVzZnOWFZMlRLUTYvS2U5S0ZqQzRKb2hSRk9RM0ZXeW9iSHR6UXpIQkFGTlpXWlFDY1ZHUExVSGpQclJLKzJOdXc3VVdnQmlKQXdmVTA5VVR6T2NraXBqZzB1YUthZXROcFRUVDBwdE1hbzJxQ1E4R3FNaDVORVJxekdlS21WcWtVOGMwNEduZzBvT0tjRFNNTnk4SEZSeGJ1VmNkTzlPbGRWQURkS2hkSXoxTk9TMzRHMDFhUHlnYzAxaVdZRU5nVXYzczgwd2tEaEY2OWFVUTc4N3prZWxUQlFGd09LTUFBWUZDa0VVWkFKb0pwdEdjVWRxWVRTTjBwaE5SdFZlVThHcU1uUTB5TnFzSkpVaXlEMXFRVERGUEVveDFwd21GT0VvcDNtZTlLSmFYelJVWmtQTzRaSGFreWtveVFSemlwVTJxQUFlbEpKSUcvajZVd3VnQVhmaXBONm9BUmtucFQyTzVSdE9LZWpCUUJuTk9NZzlhUXVEeDJwQVZVZkxTZVo2OWFYekFhUU9LREp4U2VZTVUwdlNGNll6NHFObnF2STRJcW5JMVZBNUJwNGtiMXAzbXQ2MHZuUFMrZTRwUk8vclMvYVpCM3AzMm1USFdqN1ZKNjBmYkpPbWFQdGtnNHBSZXlEb0tYN2RJQlRHdW1idFMvYWM0K1hwVW45b01PMU9HcE42VWYyaTJlbEExSW5xdEtOUk9NWU5ML0FHajdVcDFEUGFqN2VLVVg0cGZ0NjBHK1gzcFB0eTBodlY5YVEzYSt0TWE2WDFxTnB3YWdkd2M4MS8vWiIsCiAgICAgICJEZXZpY2UiIDogewogICAgICAgICAiRGV2aWNlSUQiIDogIiIsCiAgICAgICAgICJEZXZpY2VOYW1lIiA6ICIiLAogICAgICAgICAiRHJpdmVyVmVyIiA6ICIiLAogICAgICAgICAiU2FtcGxlUmF0ZSIgOiAiIgogICAgICB9LAogICAgICAiRm9ybWF0IiA6ICJqcGciCiAgIH0sCiAgICJQaG90b0FycmF5IiA6IFsKICAgICAgewogICAgICAgICAiQmlvVHlwZSIgOiAxMDAwLAogICAgICAgICAiQ29udGVudCIgOiAiLzlqLzRBQVFTa1pKUmdBQkFRRUFZQUJnQUFELzJ3Q0RFQUFvQUJ3QUhnQWpBQjRBR1FBb0FDTUFJUUFqQUMwQUt3QW9BREFBUEFCa0FFRUFQQUEzQURjQVBBQjdBRmdBWFFCSkFHUUFrUUNBQUprQWxnQ1BBSUFBakFDS0FLQUF0QURtQU1NQW9BQ3FBTm9BclFDS0FJd0F5QUVSQU1zQTJnRHVBUFVCQWdFRUFRSUFtd0RCQVJzQkx3RVlBUG9CTEFEbUFQMEJBZ0Q0LzlzQVF3RXJMUzA4TlR4MlFVRjIrS1dNcGZqNCtQajQrUGo0K1BqNCtQajQrUGo0K1BqNCtQajQrUGo0K1BqNCtQajQrUGo0K1BqNCtQajQrUGo0K1BqNCtQajQvOEVBRVFnQjRBS0FBd0VpQUFJUkFRTVJBZi9FQUI4QUFBRUZBUUVCQVFFQkFBQUFBQUFBQUFBQkFnTUVCUVlIQ0FrS0MvL0VBTFVRQUFJQkF3TUNCQU1GQlFRRUFBQUJmUUVDQXdBRUVRVVNJVEZCQmhOUllRY2ljUlF5Z1pHaENDTkNzY0VWVXRId0pETmljb0lKQ2hZWEdCa2FKU1luS0NrcU5EVTJOemc1T2tORVJVWkhTRWxLVTFSVlZsZFlXVnBqWkdWbVoyaHBhbk4wZFhaM2VIbDZnNFNGaG9lSWlZcVNrNVNWbHBlWW1acWlvNlNscHFlb3FhcXlzN1MxdHJlNHVickN3OFRGeHNmSXljclMwOVRWMXRmWTJkcmg0dVBrNWVibjZPbnE4Zkx6OVBYMjkvajUrdi9FQUI4QkFBTUJBUUVCQVFFQkFRRUFBQUFBQUFBQkFnTUVCUVlIQ0FrS0MvL0VBTFVSQUFJQkFnUUVBd1FIQlFRRUFBRUNkd0FCQWdNUkJBVWhNUVlTUVZFSFlYRVRJaktCQ0JSQ2thR3h3UWtqTTFMd0ZXSnkwUW9XSkRUaEpmRVhHQmthSmljb0tTbzFOamM0T1RwRFJFVkdSMGhKU2xOVVZWWlhXRmxhWTJSbFptZG9hV3B6ZEhWMmQzaDVlb0tEaElXR2g0aUppcEtUbEpXV2w1aVptcUtqcEtXbXA2aXBxckt6dExXMnQ3aTV1c0xEeE1YR3g4akp5dExUMU5YVzE5aloydUxqNU9YbTUranA2dkx6OVBYMjkvajUrdi9hQUF3REFRQUNFUU1SQUQ4QWJSUlNVZ0Zvb29vQUtLS0tBQ2lpaWdCcEdEU1oydG5zYWRTRWNZb0FkUlRWUFk5UlRxQUNpaWlnQW9velNacGdPb3B1YU0wZ0ZwYWJta0xlOUFENktqM2oxbzNqNjB3Sk0wWkZSN2ovQUhUUjg1N1VBUHpTNXBtMXozQW9DSHUxQUR0MUJQdlNlV1BlbENMNlVBSnZIclNiL1RKcCtBTzFMUUF6TGYzYVhEbjBGT3BhQUl6dVhCSkZPUE5Ld3lwRk5ISzBBUENpbEFBcEFjaWxvRUxTMGxGQUMwWm9wS0FGb3BLS0FGb3BLS0FGb3pTVVVBTFNVVWxBQzBVbEZBQlJSUlFBVVVsRkFDMGxGSlFNS2lUN3pmV3BEVWFkL3JRSWVLV2tIZWxvR0ZKUzBsQUJSUlJRQVVVVVVBRkZGRkFDVVVVVUFGRkZGQUJSUlNVQUxSUlJRQWxMU1VVQUZGRkZBQzBVWm96U0FLV201b3pRQXRGSm1rM0Qxb0FkUlRONG8zZWdOQUQ4MGhwdVdQUVVZZjJvQVhIT2FYTk5VbkpEZGFCR3VlYUFBdUIzbzNyNjA0SW83Q25VQVI3ajJVMFpjL3cxSlJRQXpEK29GR3h1N2ZwVDZLQUdlV1BVbWw4dGZTblVVQUp0QTdDbDZVdEZNQW9vb29BS0tLS0FDaWlpZ0JhS0tLQUNpak5GQUJUVjRKSHBUcWEzRGozb0FjdmNVNm1EZzA2Z0JhS0tLQUZwS0tLQkJTMGxGQUJSUlJRTUtLS0tCQzBsRkZBQlJTVVVBTFNVVVVBRkZGSlFBVVVVVUFKVWFkRDlha05SUi9kUDFvR1NDbHBxOUtXZ0Fvb29vQUtLS0tBQ2lrcGFBRW9vb29BS0tLS0FDaWlrb0FXa3BhU2dCYVNpaWdBb29vb0FLS0tLQUxGbkVYZmV3NEhUUGMwSzNudkp2UlMrQ1ZPVHordFB0R1pweHVQUmNDb1lRL21BeGprZCt3cVJqN1pWa2wrYU5Bb0dTUm4vQUJxQ1FCbllnYlFUd0JWeDhORzYyK0NTY3VBZWZ3OXFxRUVFZ2dnKzlDQmxtS0pQSWgrVmNsamtsUWM5YVZXRWduWmxBQXhnYlFjZGFRaFRhUmJtS2pKNXhuMXFUZjVnbWFMT2NBWkhVbm1rTVpiRkRNQUQvd0NRd0tyUDk5dW5YdFZ3bGo4d0xHUURtTVArdi8xcXFTRWx5V1VLZTR4aW1oTWtXQU5BSEcvT2NFS00xTWtlTFYxSG1ESi91OC9sbW9SSW4yWUkyU2M1d09LZWhUN0cvd0FyWTNkTjMwOXFBR2ZabE1idTNtQXFNaks0cXV1VzZBaytncXpISkdFZEFyQXVNREp6VmQxYUNZak9DTzRvQWVzaEF3QXY0cURVMFkzUm1SbVVLRGdnSU0xQ3NzcE9BN2svVTFZVjMreHMyOXM3dXVmcFF3R2VhemdwSEdBTytGeVQ5YWlWQ1gybkMrdTdpZ3lPd3d6c1I2RTBCZ1d5K1cvR21Jc0pKRzM3a0E3T3g1NVA0VW9YeVFYQ0tYWHNwSng5YWJDMjVXOHRWVmgyNTVIMTYwNVJneHZFcUF0NjVKSHIzcVJrYnZHeWg5b0xucURuL0dvUUN4d296bnNLbmxrVm1ZSWdjZFNTdjlSVUtnTVRsZ2cvR3FRRThLQ05za2d5NCtWTTBZZVdRbDQxR0Q4ekVuQS9XaUJJbUxEQllnWjU0Rk1hY3VBR1JjRG9PUVA1MGdFbU1YU05lbmZQV293Y0hJcVoxVDdNcmhBQ1RqZ21vVkJKQUF5ZlNtaEZsRjdzMGJlaXFGNXB6QncyTXBHUDlnY21rM0ZJemtLcEhVS0RuOFRtaDlzZmxsU0V5TTUyNXBESzdzV1AzbVlEcHVwOEtLZm1ZZzQ2TGtaTlBuM21NTXlxMysydmVrZ3lxczRSVDIzRnNZcDlBSHlnRW56U1djOUZYdFJsRlR5aVRrOVFXR0YvSEZNM01EOGhRT2Y3dVNUK05XQTU4OUk5eE9GK2JudlNBcXlxRkdQS0tuc2M1elRyYUxmSUNmdWo5YWEyOW84bHNxR3hqM3Axc3pHWkFUd000SDRVK2dEM0FsTHUvUlRqNzNIOHFXWVJtQ01FOGR1VC9oVEkzSWQ0OFpESDB6VDU5eW9nQUJDams3UVJTQWd1RldNaGR1Q080T2FsdDhlVkxuSFFkUm1xN3lOS3hac1o2Y1ZQRWZMdFNXR1M1d0FlOVBvQStFQm5JSmpZWTZCZi9yVWtSL2VyODBaNTdMLzlhaTJZRjJ3aWo1VDB6VFlUKzlUOTJCazhIbWtBMmIvWFA5YVpUNXY5Yy8xcGxVaEJSU1VVQUxTVVVVQUxTVVVVQUZGRkJvRUZGRkpRQXRKUlJRTUtLS1NnUXRGSlJRQUdvMCs3VHowcGkvZG9HT1RwUzBpOUtXZ0Fvb29vQUtLS1NnQW9vb29BS0tLS0FDaWlrb0FXa3BhS0FFb29vb0FLS0tLQUNpaWlnQW9vb05BRDBka09WT0RTdEk3akRIajBIQXBsRklCUVNEa0hCcHpTTzRBWmlRS1pSUUE0dXhRSVQ4bzZDaFhaUVFyRUE5YWJSUUFvSkJ5RGcwck96L2VZbjZtbTBVQUZPVjNYaFdZZlEwMmlnQi9teS84QVBSL3pOTmNsL3ZFays1b3BLQUdxeEI0SkJIY1ZLMDBqcUZaaVFLaVlZT1JTZzBBT29CS25JSkI5UlJSUUEvelpQK2VqZjk5R2p6WlArZWovQVBmUnBsRkFEL09rL3dDZWovblRPOUZGQURsZGt6dEpHUmppbDgyVC9uby81MHlpZ0J6TzdERE14SHVhRlpsQkFZZ0hyZzAyaWdCeXNWT1ZKQjlxVjNhUTVjNU5Nb29BZHVPM2JrNDlLU2twYVlEaEl3WGFEZ2V3eFNBbFRrRWcrb3BLS0FIR1IyR0M3RWU1b1YyUmd5bkJGTm9vQWVaWEl4dXdEMXdNWnBGWmxQeXNSOURUYVdnQlpKWkhiRHNTTWRLUXV6Tjh4enh4VFc3SDBvemdpZ0I2c1Y1QkkrbE9TUjArNnhGTW9vQVhPZVRSU1V0QUJSUlNVQUxSU1V0QUJSU1VVQUxSU1V0QUNVVVVVQUZGRkpRQVVVVVVBRkZGRkFDSHBUUjkybkhwVFI5d2ZTZ0JWNkNscEY2Q2xvQUtTbHBLQUNpaWlnQW9vb29BS0tLS0FDa3BhU2dBb29vb0FLS0tLQUNpaWlnQW9vb29BS1EwdE5OQUQ2S0tLUUJSUlJRQVVVVVVBRkZGRkFCUlJSUUF0SlJSUUFVM29jVTZrWVpvQVVHbHBnOWFmUUFVVVVVQUZGRkZBQlJSUlFBVVVVVXdDbHBLV2dBb29vb0FLS0tLQUNpaWlnQW9vb29BQ01qRk42aW5VM29TS0FIQThVdE5XbG9BV2lrcGFBQ2lpaWdBb29vb0FLS0tLQUNpa3BhQUNpaWtvQUtLS0tBQ2lpaWdBb29vb0FROUtZZnVmaFRtNkdtbjdsQURoMEZMU0RwUzBBRkZGSlFBVVVVVUFGRkZGQUJSUlJRQWxGTFJRQWxGRkZBQlJSUlFBVVVVVUFGRkZGQUFlbE1icFRqVFJ5MzBvQWtvb29wQUZGRkZBQlJSUlFBVVVVVUFGRkZGQUJSUlJRQVVVVVVBTlBCcFFhVWpJcHY4NkFIMFVnNUZMUUFVVVVVQUZGRkZBQlJSUlRBS0tLS0FDbHBLV2dBb29vb0FLS0tLQUNpaWlnQXBwNmluVWpkS0FFSDN2clRxWWV4cDlBQlMwbEZBQzBVbEZBQlJSUlFBVVVVVUFGTFNVVUFGRkZGQUJSUlJRQVVVVVVBRkpSUlFBamZkTk5iN3RPYjdwcHJmZG9BY09sTFNVdEFDVVV0SlFBVVVVVUFGRkZGQUJSUlJRQVVsRkZBQlJSbWpOQUJSU1pvelFBdEZOM1Vab0FjYUtiaytsTkxIT0tBSEdrWGpyUzlhTnRBRDZLS0tRQlJSUlFBVVVVVUFGRkZGQUJSUlJRQVVVVVVBRkZGRkFCU01POUxSUUFnTk9wbU1IRktwN1VBT29vb29BS0tLS0FDaWlpbUFVVVVVQUZGRkZBQlJSUlFBdEZKUzBBRkZGRkFCUlJSUUEzSEJGS3A0cEQxb1g3eEg0MEFPb29vb0FLS0tLQUNpaWlnQW9vb29BS0tLS0FDaWlpZ0FvcE0wWm9BV2twTTBiaFFBdEZOM2lqZlFBcmZkcGo5UHhvWnVuQnB4R2FBRm96U1lORzArdEFDNXBNMGJmZWpiUUFab3pSdEZHQjZVQUp1bzNVN0ZGQURNbjBOSFBwVDZLQUdZTkdENjAraWdCdTArdEcyblVsQUNiUlM0RkZGQUJnVVVVVUFGTTZ1VDZVNG5BcGc0RkFEeFMwZzZVdEFDMFVVVWdDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQkdHYVQzcDFOUEIrdEFENkthRGc0cDFBQlJSUlFBVVVVVUFGRkZGTUFvb29vQUtLS0tBQ2lqTkdhQUNpa3pSdUZBRHFLWnZGRzcyb0FjYWFlQ0QrRkJKeDBwTTVUTkFFbWFUTk53U090THRQclFBN05KbWsyKzVwZG9vQVRkUnVwZG85S1B3b0FUZFJrK2xPb29BYmsrbEhOT29vQWJnK29vd2ZXblVVQU4yKzlHMGU5T29vQWJ0RkdCNlU2a29BTVVVVVVBTWs3ZldsSFdoLzRmclFPdEFEcUtLS0FDa3BhU2dBb29vb0FLS0tLQUNpaWlnQW9vb29BU2lsb29BS1NscEtBQ2lpaWdCcitsQTVhZzlhVmZXa0F0RkZGTUFCcGFiMHBRYzBnRm9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lqTkdhQUNpa3pSdUZBQzBFWkZOM2oxbzNaOWFZQWYxRk9CeUtabkhPRFMvU2tBN05HYVRCOWFNVUFMbWpOSnRGTGdVd0UzVWJxWEZMUUEzSjlEUmx2U25VVUFOK2Iyb3dmV25VVUFOMis5THRGTFJRQW0wZWxMZ2VsRkZBQlJTMFVBSlRCd1NLa3BqY01ENjBBS3ZTblUxZXBwMUFCUlJSUUFVVVVVQUZGRkZBQlJSUlFBVVVVVUFGRkZGQUJSUlJRQVVsRkZBRFg2ajYwRDcxRGRWb0gzdndvQWRSUlJRQVVVVVVBRkZGRkFDVVVVVUFGRkZGQUJSUlJRQVVVVVVBRkZGRkFCU0hnVXROTkFEYWVLYUJrL1NuVUFGRkZGQUFhVHBSejZVaHpTQWNEUm1tZzVwd0ZBQm1qTkdCUmdlbEFDYnFOMUxpbG9BYmsrbEhQcFRxS0FHNE5HMCt0T29vQWJ0OTZYYVBlbG9vQVRhUFNqYVBTbHBhQUV4UlJSUUFFY1UwY0hGT3BHSEZBQ2lscG9OT29BS0tLS0FDaWlpbUFVVVVVQUZGTFJRQWxGTFJRQWxMUlJRQVVVVVVBRk5mcFRxRFFBenVEVDZaMnhUaDBvQVdpaWlnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ2lpaWdCS0tLS0FHdDFGQSs4YVU5UlNMOTQwQU9vb29vQUtLS0tBRXBhS0tBRW9wYVNnQW9vcGFBRW9vb29BS0tLS0FDaWlpZ0FwcDlhY2VsTVBwU0FWUnhUcUtLWUJSUlJRQVVVVVVnR012T1JTcTJhZFRDTWNpZ0I5Rk5EVTZnQW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS1dnQktLS1dtQVVVVVVnR25nK3hwUWFDTWlrRkFEcUtLS0FDbHBLV21BVVVVbEFDMFVVVUFGRkZGQUJSUlJRQVVVVVVBRkZGRkFEVDFvWHBTdFNEaHZyUUE2aWlpZ0Fvb29vQUtLS0tBQ2lpaWdBb29vb0FLS0tLQUNpaWlnQXBLV2lnQnA2MGk5VFNuclNMM29BZFJSUlFBVVVVVUFGRkZGQUJSUlJRQVVsTFJRQVVVVVVBSlJSUzBBSlJSUlFBaDlLUmVUbWduZ21sVVlGQUMwVVVVQUZGRkZBQlJSUlNBS0tLS0FHRVlPUlNnNUZMVFNOcHlPbEFENktRSE5MUUFVVVVVQUZGRkZBQlJSUlFBdEpTMFVBRkZGRkFCUlJSUUFVaEhlbG9wZ0lEUzAzb2NVNGMwZ0Zvb29vQUtLS0tZQlJSUzBBSlJSUlFBb3BLVVVHZ0JLS0tLQUNpaWlnQVBJcG5vZlNuMDBqcUtBSFVVaW5LMHRBQlJSUzBBSlJTMGxBQlJSUlFBVVVVVUFGRkZGQUJSUlJRQVVVVVVBSWV0TlR2OWFVMEowTkFEcVNscEtBQ2lpak5BQlJSbWt6UUF0Rkp1Rkp1RkFEcUtidUZHNzJvQWRSVGNuME5KbHZTZ0I5Rk0rYjJvdzNxS0FIMGhOTjJuMXBBRGs4MEFEZFJUczBBWnBjRDBvQVRjS04xTGlsb0FiaytocE1uMHA5RkFDVVVVVUFGRkZGQUJSUlJTQVlmbFB0VGdhV21mZFB0UUEraWtCelMwQUZGRkZBQlJSUlFBdEZGRkFCUlJSUUFVVVVVQUZGRkZNQkNLUUduVWhGSUIxRklEU2ltQVVVVVVBRkwycEtXZ0JLS0tLQUNsTkZIYWdCS0tXa29BS0tNMFpvQUtRMHVhUWtVQUl2VWluVTNvUWFYTkFDMFVtVFJrK2xBQzBVbk5ITkFEcVNrd2ZXakI5YUFGb3pTYmZlamJRQXVSUmtVbTBVdUJRQW00VWJoUzRIcFJpZ0JOMUprK2xPb29BYm5PYVFBNDRwZTVwUjBvQVRCb3dmV25VVUFOMm4xbzIrNXAxRkFEZGc5Nk5vcGFLQUUyajBwY0NpaWdBb29vb0FLS0tLQUVwYUtLQUVQU21qK2RLM1RGSU9XK2xBRDZLS0tBQ2lpaWdBb29vb0FTaWlpa0FVVVVVQUZGRkZBQlJpaWlnQnZRMDRITkI1cHZTZ0IxRkFPYUtBRnBLS0tBRm9wTTBaRk1CYUtUSW8zQ2dCYUtidW96N1VBT29wdVQ2VXZOQUMwVW1EUmcrdEFCMHB3SXBoeVBlbkRGSUJjMG1hTUNqQTlLWUJ1RkFiMHBjVUNnQk0rMUdUNlV0RkFDYytsS0F4RkZLS0FHNFByUnRQclRpS1NnQk52dlJ0SHZTMFVBSnRGRzBlbExSUUF3ZFBwVDZhZXA5NmN2SW9BS1dpaWdBb29vb0FLS0tLQUNpaWlnQW9vb29BS1Nsb29BU2lscEtBR252VGgwcHA3MDRVQUZGRkZBQlJSUlFBVVVVVUFGRkZGQUJSUlJRQWxGTFNVQUZGRkI2VUFOSjYwcWppbW5uQXA5QUJSUzBsQUJSUlJRQVVVdEZBRGFLYmcwWTk2QUhVbWFOdEcwV';
        ret = ret + 'UFHUlJ1RkdCNlV1QjZVQUp1bzNVdUtLUURjbjBvNTlLZFJRQXdIbkhRMDdCOWFHWFAxcEFleG9BWEh2UmluVVVBTjJpbDJqMHBhS0FFd1BTbG9vcGdGRkZGQUJSUlJRQVV0SlMwQUhVVTBjSEZPcHBIZWdCMUZOQnAxQUJSbWlpZ0Fvb29vQUtLS0tBRE5GRkZBQlJSUlFBVXRGRkFEVzdHaGVwRktlYWIwSW9BZlJSUlFBVVV0RkFDVVV0RkFDVVV0RkFDVVV0RkFDVVV0RkFDVVVVVUFNUFEwNmtQU25VQUpSUzBVQUpSUzBsQUJSUlJRQVVVVVVBRkZGRkFCUlJSUUFValV0Tlk0RkFDTHkyYWZTS01DbG9BS0tLS0FDaWlpZ0Fvb29vQWJSUlJRQVVVVVVBRkZGRkFCUlJTMEFKUzBsTFFBVTBqUDFwMUZBRFFhZFNFVWdOQURxS0tLQUNpaWlnQW9vb29BS1drb29BS0tXaWdBb29vb0FhUmcwb29QSXBCeFFBNmlpaWdBb29vb0FLS0tLQUNpaWxvQUtLS0tBQ2lpaWdBcHJEcmluVWhGQUNnNUdhV21wM0hwVHFBQ2lseFJpZ0JLV2pGRkFCUlM0b3hRQTJpbllveFFBbEppbllveFFBMmluWXBNVUFSbit0T3ByZjFwOUFDVVVVVUFGSlM1RkprVUFGTFRkdzlhTjRvQVdpazNVWjlxQUZvcE1uMG8rYjBvQVdpaytiMm93M3JRQXRNUExBVXZJUFdnRFBOQURxS1RiUnRGQUM1RkprVWJSUzRIcFFBbTRVbTRVN0ZGQUNidmFqZDdVdEZBRE9sTFJTZEtBRm9vRkxRQWxMUlJRQVVsTFJRQVVVVVVBRkZGRkFCU0VVdEZBQ0EwdElSUURRQXRGRkZBQlJSUlFBVXRKUzBBRkZGRkFCUlJSUUFVaEZMUlFBZ1BhbHBwNHAyYUFDaWlqTkFCUlJrVW00ZXRBQzB0TjNqMW8zVUFPb3B1NzJORzQrbEFEcUtiaytsTDgxQURxUTlLVDV2YWpCOWFBRUhFbjFxVUROUnIxR2ZYbXRkSW8xQTJxUHJRQm5LcEp3QmsxSWJlUURPMDFmQ2dISUFCK2xMUUJtaUp6MFVuNkNoWW5ib3BQNFZwVVVBVUZ0NUNjYmNWSWJRNCs4TTFib29BcEMwYytnL0dnV2o1NXdCNjFkb29BckMwL3dCcjlLayt6eDR4dC9XcGFLQUlQc3NlZTlNbXRVRVRNdVFRQ2F0VXlWUzBUS09wRkFHUmpPS1hiN21qSElwMUFETm85Nk5vL3dBbW5VVUFOMmowcGNEMHBhS0FFeFJSUzBBSlJSUlFBVVVVVUFGRkZJZWxBRFR6K05PSEFwbzVQMHA5QUJSUlJRQVVVVVVBRkpUVElvNzBxdUc2R2dCMUZGRkFEYUtLV2dCdVBTbEZMaW5wRVpEaFJrMEFNeFNWWk5wS0JuYm1vQ01VQU5vb0pvelFBVVVtZmFqSjlLQUZvcE9hT2ZhZ0JhS1REZW9vd2ZXZ0JhUWlqSHZSajYwQUFOTGtVMGpIUGFsR0RRQXVSU2JoUzRveFFBbTRVWjlxZFJRQTNQdFJrK2xPb29BYjgzcFI4M3RUcUtBRzgrdEdENjA2aWdCcEI5YUJ6VHFhUmcwQUx0RkdCU2c1b29BTUQwb3dQU2lsb0FTbG9vb0FLS0tLQUNsb29vQUtXa3BhQUc0NXJVdFRtM1Q2WXJOcTdZc05qTDNCelFCYW9vb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ21TLzZsL3dEZE5QcGszK3BmL2RQOHFBTXJ1S1dqdVBwUlFBVWxMUlFBbEZGRkFCUlJSUUFVVVVVQUZGRkZBQlRXcDFNYms0OWFRQ29PTTB0RkxUQVNpbG9vQVNrSXlNVXRGQUZkN2NIbkp6NlZKQ20xZVJnMUpSUUFVVVVVQVJnanVUVjIxTnV3Q3NCdTlUM3FwSkV5SDVsSStvcEUycWZtQnBBYkhrUmYzQlR3cXIwVUQ2Q3FOdmVLdnlQbkhZMWVCQkdRY2cwd0ZxdlBiYnlXWEgwcXhSUUJsUEdWSkJITlJrVnFTd0NYbk9EVkdXSW94Qm9BZ3BLZVJUY1VBSlJTMFVBSlJRU0IxcEF3UFEwQUxSUzBVQUpUVDh2MHA5RkFDQTVwYVo5MCsxUEZBQlJSUlFBVVVVVUFGRkZGQUJSUlJRQVVZelJSUUEwY1U2a0k3MEEwZ0hVVVVVd0NpaWlnQXBhS0tBQ2lpaWdCYUtLS0FGcWV6YmJNQWY0aGlvS1ZHMnVHSFk1b0ExYUtBY2pJb29BS0tLS0FDaWlpZ0Fvb29vQUtLS0tBQ21TLzZsLzkwMCtvNS84QVVQOEFTZ0RNL2kvQ2xwUDR2d295S0FDaWpJcE53b0FXaWszZXhwTjNzYUFGb3BNbis2YU1uMG9BV2lreWZTajV2YWdCYUtiODNyUmcrdEFEalRCeTFJU1FldEhTa0JKUlVKZkJ4bWtNaSt0QUUyYU1qMXFEekY5YVR6Vm9BbjNEMW8zajFxRHpsOURSNXkraC9PZ0NmY1BXamNLcitjUDd2NjBlYm5vdjYwd0xHNmpkN1ZYRHVld3FSYzUrYkZJRGJsakVpWVBYc2F6cDdXUkNUakk5UldwUVFDTUhrVXdNTVpROUtzUTNiUm5HTWowcWVheXlDeUhQdFZGazJHa0JzUlNyS3VWUDRVK3NhT1owWUZUZzFwUVhJbEdHNGIrZE1DZW1TUkxKOTRVK2lnRE9taE1iWTdkalVCRmE1VU1NRUFqM3FsUGJsU1NvSlgrVkFGVEZKVHlLYVJRQXhsRERtbzBodzJUbXA4VWxBQlJSUlFBVVVVVUFCcHYzZnBUcUtBQ2lrNkhyUzBnQ2lqaWpJcGdGRkp1SHJSdUhyU0FXaWszQ2szQ21BNmlrM2V4cE4zdFFBNmtQQnBOLzAvT2t5VDZVZ0hnMHRNVW1uYzB3SFVVM24xb3dmV2dCMUZOeDdtbDIrOUFDMFVtMmphS0FGeUtNaWphUFNqQTlLQUYzQ2dFWm94UWVsQUdsYk51Z1gxSEZTMVRzWDVaTzNXcmxBQlJSUlFBVVVVVUFGRkZGQUJSUlJRQVZIUDhBNmgvcFVsUjNIK29mNlVBWnA2bWt3S1h1YUtBRW9vb29BS0tLU2dBb29wS0FGb3BNMGxJQmMwaE5KbW1tZ0E2bWxKd00wZ0hCcHN4d29BNm1nQ0hQM205ZUJTWTVDOStwTlBBK1lEc296U0JTVko3bW1BenJram9LVEJxZnl1QU93cDZxb09TTTBBVmNHbkJHTldodEg4SS9LbTQ1cEFSTEY2bW5oQU9ncDJLS0FFcHlybm1rQXljVkljQVVBYktzR0dWT1JTMWxSVFBDZmxQSG9hdnczS1NqR2RyZWhwZ1RWRExiUnk1T01ONmlwcUtBTWVhRXhuQlVpbUE0UFVpdHBsREtWSXlEV2ZQWnNvTExnZ2ZuUUJKQmVEaFpHejcxZEJCR1J5S3hNRlRWaUM3YU00eDh2cFFCcDBVMUhFaTVXblVBVlpyYkpMSitWVTJVanRXdFVNdHVyNUk0WTBBWm5QcFNjMU02RlRnakZNSXBBTXdhTUduVWxNQk1IMW93ZlduVWxJQk1lOUczM05MUlRBYnNGSmpubW4wRVpwQVJrR21ra2RxazlqVFNLQUlqSVFlaG84ejJQNTA4MDBxdnB6UUEzemZiOWFUelQ3VXBpSGFtK1UzMW9BWHpUN2ZsU2VZZmFrOHRoMUJwTnBCeDM3ZTlNQi9tSDEvR3BJbjNjSHJVSDhqMTlxY0NRYzl4U0FzbjFwdzVwaU1HR2V4cHc0T0tBSFVDaWltQXRGRkZBQlMwbEZBQzBVVVVBTFJTVXRBRWx1MjJkT2UrSzBxeURXckcyK05XOVJRQTZpaWlnQW9vb29BS0tLS0FDaWlpZ0FxSzVPTGR2dy9uVXRRWGVmczV4NmpOQUZBZFRSU0E4bWlnQW9vcEtBQ2lpa29BS1NselNaRklBb3BOdzlhTnkrb29BRFRTYVhldnJTWStiUE5NQjM5S2pJM1NaN0NwUHdOSmoyTklCcW9PZmVuaGFUbis3K3RHRDZmclFBdUtURkxnK2dvdzN0UUFtS09LWERlby9LamEzOTc5S0FFcE1VN1lmN3hvMmVwTkFBTUtLYm5jM3RSam5BcDRRQVVBTFNnODAybHBnVzRMc3I4c21TUFh2VjFXVjEzS2Npc2VwSTVYamJLSEh0UUJxMFZCRGRMSmdOOHJmenFlZ0N0TlpveWtvTU4xNjlhem5RbzJDQ0Q3MXRWSE5Fc3FiVDE3SDBvQXk0cG1qWUVNUldqQmNwS0FNNGIwck9tZ2tpYjVoZ2V0TmlFaEpLRE9LUUcxUlZPQzZiSVNZWTlEVndFRVpISXBnTWxqRWk0UFhzYW9UUXRHZWVucldsVEpZeEttMC9oUUJsR2lwWm9taWJEZFBXb3FRQlJSUlFBbEZMUlRBS0tLS1FEU00wMzJQV3BLUWpOQUVaRk5JcVE4MDNGQURRS1hPS1hGR0tBRUpwQ0FhZGlreC9uRkFEU2cvT20rWDB4MUZTMFkrdEFERUd4dlkxS2VsTi9BMHVUNlVBS3BwMVJuSWFualB0UUE2aW04KzFMelFBdExUY0gxb3dmV2dCMUZOd2ZVMHUzM05BQzBVbTM2MGJSUUF0WExPWlJHVVk0SVBHYXBGUmlsV2dEVTgyUCsrdjUwdm1JUDQxL09zek5MbW1Cb0dlSWZ4aWsrMFJmMy93QkRWRE5KbWdEUSswUmYzdjBOTk4yZzZCalZITkdhQUxuMnhmN2pVZmJGL3VtcWVhVE5BRnhyd0RvbjYxWG51bmRRcEFBSjdWSFRINnI5YUFBQTlqUzRQclF2U2xvQWJnK3BvMis1cDFGSUJtMGVwL09qWVA4QUpwOUZBRE5nOUtOZzlCVDZLQUc3QjZVYlI2VTZpZ0JoQXBRT0tROG1uVUFGSlMwVUFKUlMwVUFKUzBVVUFGRkZGQUJTTWNVcE5OVWJqbjhxQUZVWUdUMU5Pb29vQVpSU1lGR0JRQXVhWEk5YWJnZWxMZ1VBTHVGV0lid3gvS3gzTC9LcTFMVEEwaGVRbnVmeW8rMXhlcC9Lc3pwMHBRMmZyUUJvUzNFRG9WSUxBKzFacFgwemluNW9vQWpDbXJFRThrUEhWZlExSFJTQXQvYm0vdUQ4NlVYeDd4ajg2cDBVQVRUM0RUTHQyZ0RPYWd5ZWhwYUR6UUFuNDBZOTZPbldsb0FUSHZSajNOTFJRQW1QYzBZRkxSUUFtMFVZSHBTMFVBSVY5S0JTMGhIZWdCYUtRSE5MUUFsR0tXaWdCdUtLV2lnQktLV2lnQkNNaWtVMDZtbjFvQWRTMGdPYUtBRm9vb29BV2lrb29BV2lrcGFBQ2tIQk5MU0hyUUE2aWtIU2lnQmFLU2ltQXRGSlJRQXRGSlJtZ0FwcmRSVHMweGpnak5JQnk5S1dtSzN5MHU2bUE2aWt6Um1rQXRGSm4yTkprK2xBRHFLYmsrbExrK2xBQzBocFBtOXFUblBOQUFPV0pwMUpqQW8vR2dCYVNreDcwWSt0QUMwVW0wVVlIcFFBdWFNajFvMmowb3dQU2dBM0QxbzNDaWtOQUNIbmluQTBDbG9BTTBaOXFLS0FHQTBVbUtNNG9BWE5MU1VVQUxSUlJRQVVZelJSbWdBemlselNaRkhIclFBNmltZzB1YUFGb3BNMFpvQVdpa3pSbjJvQVdrNlVtZmFqSjlLQUZCcGFZUWVvcFFTYUFIVVUzbWptZ0IxRkp6NjBtRDYwQU9vcE1lOUdQZWdBTkFOR0tRajBvQWRTWnBCZzB1QlFBWm96UmdVWUZBQ1pIclJ1SHJTNEhwUmdVQUp1SHJTYmg2MDdGRkFETTg4VTdkUVJRT2FBRGRSdTlqUzBVQUpuMm95ZlNsb29BTW4wb3lmU2lsb0FUbWc1cGFLQUVIWGlsNTlhUWNZL0tuVUFKejYwWTk2V2ltQW1QYzBZcGFLQUV3S01DbG9wQU4yaWtLKzFEeUJUelRBNU83dlFPeElCUzRxRXlFTU04ZTFQU1RkMm9GWWZSUlJRQVVVVVV3Q2lrb3BBTFRlOUxTRHJtZ0JhS0tTZ0JhS1NpZ0JhS1NqTkFDMFVtUlJrVUFCcEI2MEU1UHRTNXBnTFJTWnBNMEFPelJTWm96U0FiaWpGRkZBQmlqNjBVVUFMeFJnVW1QU2pOQUM0cGNVbEZBQzBVVVVBR0tUcDFwYUtBQ2lrK2xMbWdCYUtTbG9BS0tNVVVBSWFNVWhZZXRPSFBTZ0FGRkx0bzJuMG9BU2lsSXBLQUNpaWlnQW9wTTBaRkFCMDVvelJrVW1jVUFPb3BNMFpvQVdpa3pSbWdCYUtUTkZBQlNIaWxvNW9BS1dtaWxvQVdpazVvNW9BV2lrd2ZXakI5YUFGcGFiajNwY2U5QUFlOU9BSnB2UTFvMmdVd0tkb3lPRHhRQlNFYkVkRFJ0UHBXclNZSG9LWUdZSTJKNEJweGdrSDhCL0t0S2lnRE1FVGs0Q21uQzJrUDhKclJvb0F5cExac0hjcEE5YXA3bVE4VnZTcDVrVEpuR1Jpc0tSREhJUTNVR2tVaGpidHdMVk9oQVJhaWRnNUdLbWNCWWxBNmc1TkFNZG4yb3o3VVVVeVF6U2MwdEZBQ2MwYzBVVUFBenpSaWcrbEZJQXBNVXRGQUNZbzJpbG9wZ0pnVVlGTFJRQW1LRFMwZzlhQUZvb29vQUtLS0tBQ2lpbG9BanpSbWlqTklBelM1cEtXZ0F6UitGRkZBQ2MwdWFLTVpvQVdqbWs1SHZRRG1nQmVhT2FLS0FEbWlpaWdCMGUzZU4rZHZmRmFLVzBETGxlUjY1ck5xU0taNGpsVCtGQUdpTGVJZndEOGFyWDZJa2FsVndTZTFUd1hLUzhmZGIwcUxVUis3UStob0F6UmpHT2hxNXA4YXV6N2huQTRxcGo1cTB0UGkyeGx6MWIrVkNHeXlJMEhSRi9LbllHTVlvb3BpS3M5cUd5eWNIMHFreUZUZ2pGYTlSVFFMS1BSdldrQmw0cE1WTEpHMGJFTUtqb0FTaWlpZ0Fvb29vQVRwUzBVblNnQmFLS0tBQ2lpak5BQlJSbWpOQUNIMXBhS1RPRFFBdExTVVVBRkxTVVVBTFJTVXZOTUFxN1lQOTVQeHFselUxbzVXNFgzNG9BMDZLS0tBQ2lpaWdBb29vb0FLeXJ5TUxjUG52eldyV2ZlL3dDdi9BVWdLUGw3Y05qak9LbWtPOFk2Y1lwUzJVMjQ0em1tNG9zTnNLU2pBcE1pbUlYTkZBeFJTQU0wVVVVd0V6Um1sb29BVFB0Um4ycGFhV3d3R090QUM4K2xITkZGQUJ6UnpTMDNOQUNubWptaWxvQVRuMW81cGFLQUV4Umlsb29BVEZPQXBLbnQ0dk5iSFlkYUFLdEdhVWpGSlNBU2pOSVdBNjBvT2FBRnpSbWtvb0FYTkdhS0tBRnpTVVV0QUNacGMwVVVBRkxTVXRBQlJ6UlJRQXVTS3NSWFpVYlpSdlgzcXZRUFUwRFJmaWUzbWsyckdNa2R4VnNjREFyR1IyVmd5OEVkNjBJTHRYNGY1Vy9RMElHV2FLS0tZZ29vb29BYkpHc2k0WVZuejI3UkgxWDFyU3BDQXdJSXlEUUJqa1VsV0xxSHlXQkIrVTlLcjBnRXhSeFMwMVZ3eE5NQmNVWXBhS1FEUndjR25ZcENNMEE0b0FXaWpOR1JRQVVVWm96UUFVRWNVWm9vQUJTMDA1NjB0QUMwVVVVd0Npam1qbWdCYUJ3Y2lrcGVhQU5aRzNvckR1TTA2czJHNWVOTm94Z2V0U2ZiSk1kQlFCZW9xaDlxbC92RDhxQmR5ZW8vS2dDL1JXY2JtVS94ZmxRTG1VZngwQWFOWjE2ZjlJUDBGSTA4akhKYzFDU1M1Sk9hQUNpbTUrZkh0VHNVZ0VxTmtPZUNLbHhSaWdCaWpBOTZYaW5Zb3hUQWJtanZTdDBvSFNnQktLV2tvQUthUmtqMnAxRkFDVVV0RkFDRTBBZDZCeWZhbHBBRkZGRk1BcEtXaWdCS1B4b3pTRnUzZWdBSnFTS1I0amxXeG1veHhTNW9BdDNMV3pSa3A5L3RnVlJ6Um1rb0FRa0dqY0tNVWhXa0E3ZUtONHFJcVJTYzBBUzdoU2hxZ3BSbWdDd0RtaW9sWTA4TlFBNmptak5MVEFLT2FNMFVnQ2xwS09sQUM0bzZVQTBITkRHdHd6bWxGSi9GbjhLWE5BTWtFMGlqQWRzZlduQzRrL3Z0K2RRNW9waUpUTklUeTdmblFKcEIwZHZ6cUxOTG1rQTlwWFBWaWZ4b0Vyam96RDhhWlMwQURzWE9XSko5NmIwcGZ3by9DZ0JNVVlvd1JTaWdBeFNZcGFPYUFFeFFWcGVhT2FBR2lsb0l6U1p4UUF0Rk1NbU8xTk11TzFBRXRMVUhuR2p6ajZVQVQwZzQ0cUR6NmVzbTRab0FscGFZR3lLWE5BRHFLVE5IRkFDMFVuRkx4UUFEZzB0TVBCcDNGQUM1RkdhS0tBRElvelJTMHdFelRmNHFmVFYrOGFRRFR4S1BwVDZHUTcxUHBUc0dnYkcvaFIrRk8ybjBvMm4wb0VNL0Npbm1OZ09ocGpBaWdCckdtR1VEakZCSGVtYk0wQUw1MUhuVWdRVXV4ZlNnQlBPcGZNWTB1MzJvMm5zRFFBQXNlOUJ6bkdhVUFqNjA0SmlnQm9wYWZqMm94N1VBTXhSaW40OXFNZTFNQm1LTVUvOEFDbWs5aFNBYWZRZGFVTGlsQXhRVGlnQXhTWW8zZTFKdXBnUjVwYVRGR0tBSFVVM0JwZWFBRnhSZ1VZTkZBQmdVdUJSU1VBTGdVY1VuTkxRQXRGSlJRQXRLS1NpZ0IxRk56UzBBTGlsQklwdExTQVVVVW1LS0FIVVVsRkFDMGRLU2xvQUJ6VGdwUFFVM0FxNWIzUUFDeWY4QWZWQUVQa1NZenNQNVVnaGM5RlA1VnBnZ2pJT1JTMHdNd3dTRHFob0Z0SWVRcHJUb3BBWlR4dW4zbElwaHJYWlE2NFlaRlVaN1lweXZLL3lvQXE1b3pUaUtTZ0JLYXd6OWFmUlFCQ1Z6OWFRcWZTcGlBYVFIc2FBSWR2dFM3UGFwZUtUaWdDTHl4NlVxcnRQQXFUaWpJb0FZQ1FlbE9BOXFYZzBvTkFBUHBTNG96UzVvQVRCb3dhWE5HYUFHc0RpbFhPT3RPelRWUGFnQmNIMXBjR2pQdFJuMm9BTUgxb3dhTSsxTFFBbUQ2MVpzb2xjc1dHY1ZYcTVZOUgvQ2dDeHNYR05vL0tnUm9QNFIrVk9vcGdKZ1l4Z1VZSG9LV2lnQXFuZmtZUlIxem1ybFoxeTIrYzQ3Y1VBUmJSUnRIcFJSK05BQmlreFMvalJqM29BVEZHS1hGSmpKb0FSUjNwYVhBb3hRQWxGTGlrd0tBQ2twY0NrSTdDZ0JwUFlVRGdVdTNGSWFBQWtVM3Ixb3gzcDFBRENPYU1VcG9vQWpvcGFLQUNnVXRGQUJSUlJRQW1LTW1scEtBRE5GSWFibWdCL05HYWJtak5BRDgwWnBsTG1nQjJhS2JtbHpRQTdOR2FidTV4UlFBL05HYVptbHpRQTZqTk56UzVvQWRtak5NcGMwQVBvelRNMHVhUUZpSzRlSThISTlEVitHZEpSd2NONkdzak5LR0k1QnhUQTI2S3l4ZVRBZmUvU25HOWxJNmdmUVVBYVZGWmd2SlIvRitsSWJ1VW5PNC9oUUJadWJZYlM2Y1k1SXFpVFVwdkpTTWJ2MHFzVFNBZlJtbTVvelFBN05JYWJ1NXhSbWdCd05HUlRUUURRQTdJb3lLYm1qT';
        ret = ret + 'kFEc2lrSnh6U1pveUtBSEJoUzVxTUhGTHVvQWZtbHpVZTZsM1V3SDVwTTRhbTdxQ2FRRW1hTTB3TlJtbUEvTkxtbWJxTjFBRDgxUGFUckh1REE4K2xWZDFDbmswQWFmMnFQSGVrRjJub2F6OTFHNmdEUk4ybllHa0Yybm9hejkxRzZnQzg5NG9VNFU1N1ZTQlBVOTZheHpnVXVhQUZ5YVRjYU0wakRJb0FkazB2Tk5CbzNVQUtTUlFCZ1UwSEp6UzVvQWRSVGMwWm9BZFJUYzBoYWdCeDlCUUJUUlM1OTZBSFlwakRCcGMwaE5BQ1VVVWhOQUFhU25Ea1VsQUgvLzJRPT0iLAogICAgICAgICAiRm9ybWF0IiA6ICJpbWFnZS9qcGciCiAgICAgIH0KICAgXSwKICAgIlNjcmlwdCIgOiB7CiAgICAgICJDb2xvciIgOiAiMCIsCiAgICAgICJDb3VudCIgOiAiNzkyIiwKICAgICAgIkRhdGEiIDogImVKeE4wMDE3cWt3TUJ1QWYxTVVST255NHpBVDAyQmJiYUQxVmRvb1FGQzBLYXRSZi94TGJ4YnU2cjJjZ3pKQnJzb2QwQlF5dy8vV2IwMXc5Y0ZyQ0tiU05wRHU0aFBZTTZRRTRSdUgwck40aHZRTVRPcHlhLzJzNC9hUDZzSXlCRnhqUThoVzR3bENXRS9XSmx3c1ZPQzlWbEx4UkI1US9xeU1xSG5WdlhEemUvNENDMWFrVVYvVkxzZ2lrd2hWa2M1QUZGcHlkTkZlOC9xdjV3T3NLcmpPOGNCN0RiWVF1NVh1NEo5aW5Jb0VlWVN4YkI1d1d4OFJzaDRML3BCemIwUXh6S1gzNzBtSk5tMi83Um5pVjdkd21HUWJDTDNadGNFaFYzeGFFRTk3ZExVRzA1bjF0cVk2Ty9MMjJrMUZrb0pyYU1vdUdjSWh0V1VVek92UnNLZEVXam9VdFRYU1ZabWczY1FSOGFkUVBhc2YyYXFLYzJ0YmU0cWlWVTZJR2RMcm8rZ3ZkSnBybmNIUFZDdTVyZTBzaUVZa1I0eWhrT2FsL3dabXJFM2Irb0RYUml0MnR1cWZuQWRvcUVuN3VtajJMZk9rQjVpSEdaQmFZMVppSWFUQWxuSW54OFRQRWxYZ0RYSSs2STN2ditDK3pPL1ptbUFuVTdIM2l0SVVqZVc5SUFBMlpwNGRpNnQvOFdEOUNzRU1BcU1FMzZoNThWTGZnalZRR00xWXpEaVpXQUZMMkYrcVhlSVU2WTFPcm54UmNiSGYvcHVTN1AzcS9tdDVERHBxdS96QVZ2L2pSbXp3a1k5VUoremZiN1VQa2JkVVBNR3YxbllJbGROOVB1anIxamJ4YWZRWHpyTDZRU2RRUkJMWGUveUVIaVJxVDc2aVcvSzM2Sk82WEdvajdlRzdBSFVEWnczdlhmL1VDVGdobGlFZHlmTmdRN3RqeFlKTWhzK1lNbCtMMDFSbTdNV3dxSEl2N3JubEk3bHJ0eSsycTl1aitxdlcxM0d2Tks1RUViaG1PV1l6YTU5TlJiZW04VVZPNU1OeWttNk8yc2xHSUZ6cWM3V0NCS1RSb2g5MmNRYjJ5ODE1M3JwMXJGeUVTZjA5dDJ1dm1nOC8yS0xqaXpidHRDSzFzcjdhcGZ1eis3ejlwN0ZMMCIsCiAgICAgICJEZXZpY2UiIDogewogICAgICAgICAiQ2VydEluZm8iIDogewogICAgICAgICAgICAiQ2VydCIgOiAiIiwKICAgICAgICAgICAgIkNlcnRTTiIgOiAiIgogICAgICAgICB9LAogICAgICAgICAiRGV2aWNlSUQiIDogIjE0MDMxMVcxQkowMDAwMDUiLAogICAgICAgICAiRGV2aWNlTmFtZSIgOiAiUEFEX1NZTk8iLAogICAgICAgICAiRHJpdmVyVmVyIiA6ICJ2MS4wIiwKICAgICAgICAgIkhlaWdodCIgOiAzMDczLAogICAgICAgICAiUHJlc3NNYXgiIDogIjEwMjUiLAogICAgICAgICAiU2FtcGxlUmF0ZSIgOiAiMjQwIiwKICAgICAgICAgIldpZHRoIiA6IDYxNDUKICAgICAgfSwKICAgICAgIkZvcm1hdCIgOiAiemlwIiwKICAgICAgIkltYWdlIiA6IHsKICAgICAgICAgIkNvbnRlbnQiIDogIlIwbEdPRGxoY3dCeEFPY0FBQUFBQUFBQU13QXJBQUFyTXpNQUFETUFNek1yQURNck13QUFaak1yWmpOVkFETlZNd0JWWmpOVlptWXJabVpWTTJaVlpqTlZtV1pWbVdhQU0yYUFabWFBbVdhQXpKbFZNNW1BTTVtcVpzeXFacG1BbVptcW1abUF6Sm1xekptcS84eXFtY3lBek15cXpNelZtY3pWek16Vi84ei96TXovLy8vVnpQLy96UC8vL3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUNINUJBRUFBQ29BTEFBQUFBQnpBSEVBQUFqK0FGVUlIRWl3b01HRENCTXFYTWl3b2NPSEVDTktuRWl4b3NXTEdETnEzTWl4bzhlUElFT0tIRW15cE1tVEhWTllTSUd5cFVjSUJRd0FNTERCcFVrUEFRd1lDQ0RDSWdjQkI0QUdQV0F6WkFNREJ3Z01OU0RBUUVVT1Nna01VRHF6YUVjS1Nnc0FGUkJ6UUlFREFTaHlHSURVQU5rREJ3eXd0SW9Sd0ZDdVNJRVNBQXBnclVRRFdyKzYzVXVDclVXa2JwV2FqVG9BclFFTEZGUGtYRHIwZ0YyL0QxTzRqWHZBN2R1a1hCOUxWSkMwY21jQUFDQS9CTEY0NzRHWW5tTXVidEMyc1ZDaW9oa3lCV3lZN0ZRRkVBUnkySzN4OUU2OEF1YkdWcGdhS0cwQ21qMHE2SW8wS2V2aEJtY09sU29WcVVtbXFzMFdnRjRRNmRTa1p5ditKdytabG16TXB0d0ZtamFiVm10dWxBKzhtc1U3NFAxd3huQURqQzlKT3lnQnA4UE5sQmRjQSt4WFVncHhLVlZZYUtKUmx0WlFvaTBtR0ZpUW1VYmRhYkVWa0JOWk9RbGdZRW1OelJmVWh5M1JobGRsVmduSUZWY29jb2ZVaG9DUjZGRUY1VDA0WDNvcUxQWmJXZ0NhOUlCbjFIMG5ZMUZUbWJmaWtCaVpNRmg1WlJXSTQwRHRDYlVUU1NoTTVsVitzRDA1VUdIejVSUldTQ2tJTlZsYU9TSHAxNFZLWlJZU0FObDVwcE9XQnFXUTVsSUNnR1RsaTBoRkFPZEI1Z0dubDBkaWdtZmRuZ2RCRUZRQlp4bkhFWGh6dmtrb1FuQUJTVmFQRnBrdzE0TnVhZlZvUWh3c2FWeE9IRnlVUWw1dWtyV3BRazIyeVNCRkZkd0pwSm4rY0I3YVpGa1VhY0JrbTZjMnBOTjNRY0txVzA3WmNabXJROEFkY0phakQwRjFHWS9ET3BRQ3IwVVM4RnhEQ1N4SlZWck5QalRmc1Y1UjBCQUZPMjZGYmJiYVpwY1RVZ2tzRkVCMVlKMjRLcm02aG5nYVY5TWF4RlI1Y3dvUUFyd1BtV0N1aUFCNGNGQ21rUWJtTGI4UEVWaFdhUWJKZFZaMUJTaUFNRVFoeU9XbW13UTFHc0JTbEU3YzBMcGNMc2hqcUNyRTFhWlNYM29NMGNhQmxaZFhqdUdTYWNBRUtrOUVXV0RIR3ZmZGFqVlRKTmpEUmJZSm1IMDlSelJXc0xOaWVnREpSZHZNSHNwNC9iWVkwVTFMUkJobFVnNlFjdFVUZFdwa1RBTjJ6UFZkT3hZYjlkZ1ZOZkNWZG9GeWlMWkVIMndybUZidElmWEEydzl0RUpYK29FWU81ZGJXZUNOa3dtWEcwWDF0V1F3RXJ0Q0Z3QlpabzlSSU1hMDRRUTVUaHRRRXdFWTZtQUFhVEU3UW1CZTZKUkFHaWJiN1ZXVVNlRjV5bEV4bXFjSUZ2TDZGRkFHQW94MkE0MUtwSnJrS0RFd0hIdDBHSUJBNGdZMGVVTzlBNjE0Mk8xbDNvejNaWXZudFRwQjJmbjRhRkFoY2UzbXJXWjBUSnk1U3dHdEZRQVZGSTFBV3FVQlJqVkRVTU5JdHBmcndTcGlvYWc5dExHdWZBeEpnd3NRUXlPMm0yQXVaZ0dBMnRxM211Q1VEL09vVXNMd0R2b2xRd0hEZkFadkYwa1d1V1dXdWRnL3AzMUpzVXl5NitDbzJYam9SVURBSUVRbGM2MElXUzFNQkFMQy9VMWx3U2hnWmdhc1dZeHNWeXVRRG0ycEE3bDYwa1JTZzVVTCt2K25LbkpLeWdFMUJZQ3Z3dXdnQk9VUVpHeTVHZXFvVGlBYmtneTlqS2FpSkRvZ2lRdFFXS1oyZGNGSmFSQWpkTW9jYUJzNnJlV0VrQ0FTZ0o3UE1MU1VBVUl6aXMvekVudm1BRFRBazFDS1h5UGdXNE5VbGpRWTV5b01jVnNhTmpRK1FCbG5nL0NKbEtrUVNCQVIyak5SYnFQTEJzU25yVTFIN2lwRWNXUkFGUUUxMndLTWdKd1Z5Z3YvSVo0blgydGNva2RmRTd5U0lmS3NVaUFUWWVLaGoxU1NXS2dDU29GVFRJbHdXa0RsTHdhVkFydllkbktGeGxmNENDakR0R0VkRUR2RnZ3Sm1aTUMxMU1SRnBKWTlwSEJ4dGNCYTFkNjJ5TEdpcEhGb0EwTXcweWtSU0pnckFNVWU1UVZXbDVYaWMxQWt3ZGVRVmVEcFNRbTgvVEFwd2twaEdDTlN3VkV2NjR5b25nQnFIL1l5SHNleUFlYmlWSFlIR2NubnNrbEtkaENraVhXYXFuR25rNGlDWkkweURsRUFnNEJKbFIwZnFrWUFBQURzPSIsCiAgICAgICAgICJNaW1lVHlwZSIgOiAiaW1hZ2UvZ2lmIgogICAgICB9LAogICAgICAiUmVmSGVpZ2h0IiA6IDk4LAogICAgICAiUmVmV2lkdGgiIDogMTAwLAogICAgICAiV2lkdGgiIDogIjEwMCIKICAgfQp9Cg==","EventCert":"MIIDezCCAyGgAwIBAgIJEJEDAAAAAFLiMAoGCCqBHM9VAYN1MGcxCzAJBgNVBAYMAkNOMQ0wCwYDVQQKDARCSkNBMSUwIwYDVQQLDBxCSkNBIEFueXdyaXRlIFRydXN0IFNlcnZpY2VzMSIwIAYDVQQDDBlUcnVzdC1TaWduIFNNMiBDQS0yIFRlc3QyMB4XDTE2MTAxODAzNTYwNFoXDTE2MTAxOTAzNTYwNFowHjELMAkGA1UEBgwCQ04xDzANBgNVBAMMBuW8oOS4iTBZMBMGByqGSM49AgEGCCqBHM9VAYItA0IABKt7ykXf4/ytx3cYA99Y9jIg5a4XwxDrnvuudyP4m7toHORTeEYxtoJ4bliRXEltqvJ+TGbTN5Sz+gYxVBsi9pajggH9MIIB+TAfBgNVHSMEGDAWgBRzep2nB9IUhNK9bX4AqJSzhbr0IzAdBgNVHQ4EFgQUSWTmnqshfGnq0m7bzDP5N+KvqbwwCwYDVR0PBAQDAgbAMIIBqAYKKoEchu8yAgEJAQSCAZgMggGUZXlKQ2FXOUlZWE5vSWpvaVJVTkROREU1UmpBd01qSkVNVEF3TnpCRE9ESTBNVFUwTkVJMVFVVkZOMFE1UlRVd1FrUXlOeUlzSWtOc2FXVnVkRTlUSWpwN0lrVmthWFJwYjI0aU9pSkZiblJsY25CeWFYTmxJRVZrYVhScGIyNGlMQ0pPWVcxbElqb2lUV2xqY205emIyWjBJRmRwYm1SdmQzTWdNVEFnSWl3aVQxTkJjbU5vSWpvaU5qUWlMQ0pUWlhKMmFXTmxVR0ZqYXlJNklpSXNJbFpsY25OcGIyNGlPaUl4TUM0d0xqRTBNemt6SW4wc0lrbEVUblZ0WW1WeUlqb2lNVEl6TkRVMk56ZzVNREV5TXpRMU5qYzRJaXdpU1VSVWVYQmxJam9pTVNJc0lsSmhkMGhoYzJnaU9pSnROM1J2VjNCS2QzRkdTRzVQS3pjMFVtZDVjMGhhUlVScGFGRk9jME13ZUhaeU5qRjJNbmRNWVd0M1BTSXNJbFpsY25OcGIyNGlPaUl6TGpBdU1DSjkwCgYIKoEcz1UBg3UDSAAwRQIgBaV4RLLfumtIFAC6CgqjT7oVRSuhgecB6EdG0cckhIsCIQCWnVMKixftqEJJRgfjxwxYixWsCIG168pLNkstfqrNgg==","SigValue":"MEQCIDR1nbc8jpz6jqV48qN65rYVBpdj9BhdU1pl4Mn1F2iDAiAPn2xVXt5U4IjSEXwliXZ8SNGpcEubgGiQxASejpoqwg==","TSValue":"MIIEUAYKKoEcz1UGAQQCAqCCBEAwggQ8AgEBMQ8wDQYJKoEcz1UBgxEBBQAwZgYLKoZIhvcNAQkQAQSgVwRVMFMCAQEGCCsGAQUFBwMIMC0GCSqBHM9VAYMRAQQgagtX3Ryu4FofZ6gmx18rIXu8EkCe6sMF9EUGPgIjl8QCBAX14QEYDzIwMTYxMDE4MDM1NjA0WqCCAoswggKHMIICLKADAgECAgoaEAAAAAAABt1AMAoGCCqBHM9VAYN1MEQxCzAJBgNVBAYTAkNOMQ0wCwYDVQQKDARCSkNBMQ0wCwYDVQQLDARCSkNBMRcwFQYDVQQDDA5CZWlqaW5nIFNNMiBDQTAeFw0xNDAzMDMxNjAwMDBaFw0yNDAzMDQxNTU5NTlaME8xDzANBgNVBAMMBlRTU1NNMjEPMA0GA1UECwwGVFNTU00yMQ0wCwYDVQQKDARCSkNBMQ8wDQYDVQQKDAZUU1NTTTIxCzAJBgNVBAYMAkNOMFkwEwYHKoZIzj0CAQYIKoEcz1UBgi0DQgAE6ylKemgSF2U7hB6rIxBHbtLkao7BpXisTnUzmmK2aBWOW3HSWarOUZtA9ivDvxTA4yucP0k76ZNv9oOaRJY2T6OB+jCB9zAfBgNVHSMEGDAWgBQf5s/Uj8UiKpdKKYoV5xbJkjTEtjCBmwYDVR0fBIGTMIGQMF+gXaBbpFkwVzELMAkGA1UEBhMCQ04xDTALBgNVBAoMBEJKQ0ExDTALBgNVBAsMBEJKQ0ExFzAVBgNVBAMMDkJlaWppbmcgU00yIENBMREwDwYDVQQDEwhjYTIxY3JsMjAtoCugKYYnaHR0cDovL2NybC5iamNhLm9yZy5jbi9jcmwvY2EyMWNybDIuY3JsMBEGCWCGSAGG+EIBAQQEAwIA/zALBgNVHQ8EBAMCA/gwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwCgYIKoEcz1UBg3UDSQAwRgIhAKjm6O2GpylJGulP6fnCSIhlNsxF80ZlTN0cEt5fadLdAiEAqeT+UnDVoUdgxC7Zqz7U26AHHiuk7J3BYj6Xi2fQP1kxggEtMIIBKQIBATBSMEQxCzAJBgNVBAYTAkNOMQ0wCwYDVQQKDARCSkNBMQ0wCwYDVQQLDARCSkNBMRcwFQYDVQQDDA5CZWlqaW5nIFNNMiBDQQIKGhAAAAAAAAbdQDAMBggqgRzPVQGDEQUAoGswGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMBwGCSqGSIb3DQEJBTEPFw0xNjEwMTgwMzU2MDRaMC8GCSqGSIb3DQEJBDEiBCBS/eqMz5pr2BxZVJ2YdMzv+Zqzw48R2hXfzueZamZx0TANBgkqgRzPVQGCLQEFAARGMEQCIDOWrL34V1XRWZcQ+6o9UbSOcX8QMoEVIHN7OFHAx+ldAiA7wWYRqj3W9D3eCRCgwRiMLrpthJK81kD4O9rYcxIXqw==","Version":"1.0.0"}}';
        return ret;
    },
	getSignHash: function (signValue) {
		return signValue.Hash;
	},
	getSignScript: function (evidenceData) {
		for (var i = 0, max = evidenceData.Evidence.length; i < max; i++) {
			if (evidenceData.Evidence[i].Type === '0')
				return evidenceData.Evidence[i].Content;
		}
		return '';
	},
	getSignFingerprint: function (evidenceData) {
		for (var i = 0, max = evidenceData.Evidence.length; i < max; i++) {
			if (evidenceData.Evidence[i].Type === '1')
				return evidenceData.Evidence[i].Content;
		}
		return '';
	},
	getSignPhoto: function (evidenceData) {
		for (var i = 0, max = evidenceData.Evidence.length; i < max; i++) {
			if (evidenceData.Evidence[i].Type === '2')
				return evidenceData.Evidence[i].Content;
		}
		return '';
	},
	getAlgorithm: function (signValue) {
		return signValue.SigValue.Algorithm;
	},
	getBioFeature: function (signValue) {
		return signValue.SigValue.BioFeature;
	},
	getEventCert: function (signValue) {
		return signValue.SigValue.EventCert;
	},
	getSigValue: function (signValue) {
		return signValue.SigValue.SigValue;
	},
	getTSValue: function (signValue) {
		return signValue.SigValue.TSValue;
	},
	getVersion: function (signValue) {
		return signValue.SigValue.Version;
	},
	getUsrID: function (evidenceData) {
		return this.getSignHash(evidenceData) + (new Date()).getTime();
	}
};

// 数据式手写签名插件对象
var hsPluginData = {
	sign: function (parEditor) {
		debugger
		
		var isSigned = false;
		if (!handSignInterface && !handSignInterface.checkStatus()) {
			alert('请配置手写签名设备');
			return;
		}

		try {
			// 获取图片
			var evidenceData = handSignInterface.getEvidenceData();
			
			if (typeof evidenceData === 'undefined')
				return;
			//evidenceData = $.parseJSON(evidenceData);

			var signLevel = 'Patient';
			var signUserId = handSignInterface.getUsrID(evidenceData);
			var userName = 'Patient';
			var actionType = 'Append';
			var description = '患者';
			var img = handSignInterface.getSignScript(evidenceData);
			// 获取编辑器hash
			var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description);

			if (signInfo.result == 'OK') {
				isSigned = true;
				// 签名
				var signValueStr = handSignInterface.getSignDataValue(evidenceData.Hash, signInfo.Digest);
				if ('' == signValueStr)
					return;
				var signValue = $.parseJSON(signValueStr);
				// 向后台保存
				var argsData = {
					Action: 'SaveSignInfo',
					InsID: parEditor.instanceId,
					Algorithm: handSignInterface.getAlgorithm(signValue),
					BioFeature: handSignInterface.getBioFeature(signValue),
					EventCert: handSignInterface.getEventCert(signValue),
					SigValue: handSignInterface.getSigValue(signValue),
					TSValue: handSignInterface.getTSValue(signValue),
					Version: handSignInterface.getVersion(signValue),
					SignScript: handSignInterface.getSignScript(evidenceData),
					Fingerprint: handSignInterface.getSignFingerprint(evidenceData),
					PlainText: signInfo.Digest,
					SignData: signValueStr
				};

				$.ajax({
					type: 'POST',
					dataType: 'text',
					url: '../EMRservice.Ajax.anySign.cls',
					async: false,
					cache: false,
					data: argsData,
					success: function (ret) {
						ret = $.parseJSON(ret);
						if (ret.Err || false) {
							throw {
								message : 'SaveSignInfo 失败！' + ret.Err
							};
						} else {
							if ('-1' == ret.Value) {
								throw {
									message : 'SaveSignInfo 失败！'
								};
							} else {
								var signId = ret.Value;
								parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);
								handSign.closeDlg();
							}
						}
					},
					error: function (err) {
						throw {
							message : 'SaveSignInfo error:' + err
						};						
					}
				});

			} else {
				throw {
					message : '签名失败'
				};
			}
		} catch (err) {
			if (err.message === '用户取消签名,错误码：61') {
				return;
			}
			else if (isSigned) {
				parEditor.unSignedDocument();
			}
			alert(err.message);
		}
	}
};


// PDF手写签名插件对象
var hsPluginPDF = (function(){
	
	function pushToSignPDF(pdfName, pdfBase64, keyWord) {
		var keyWordStr = keyWord;
		var uRet = '';
		var argsData = {
			Action : 'pushToSignPDFBase64',
			pdfName: pdfName,
			pdfB64 : pdfBase64,
			keyWord : keyWordStr
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
		
		var instanceID = parEditor.signProps.instanceID;
		var episodeID = parEditor.signProps.episodeID
		var canDo = parEditor.canDoPDFSign("", instanceID);
		if (!canDo)  {
			handSign.closeDlg();
			return;
		}
		
		var updateInst = false;
		var allKeyWord = parEditor.getPatSignKeyWord(instanceID,updateInst);
		if (allKeyWord == "") {
			handSign.showTip("未找到有效的患者签名关键字！");
			return;
		}
		
		handSign.showTip("正在生成病历PDF, 请稍侯...");
		var pdfBase64 = parEditor.getSignedPDF(episodeID,instanceID);
		if (pdfBase64 == "") {
			pdfBase64 = parEditor.createToSignPDFBase64(instanceID);
		}
		if (pdfBase64 == "") {
			handSign.showTip("生成待签名PDF失败！");
			return;
		}
		
		var pdfName = parEditor.signProps.patientID + "-" + parEditor.signProps.episodeID + "-" + parEditor.signProps.instanceID;
	    pdfName = pdfName.replace("||",'@')
		
		try {
            var ret = pushToSignPDF(pdfName, pdfBase64, allKeyWord)
            if (ret != "") {
				//if ('function' === typeof onConfirm) 
				//{	}
			
                handSign.showTip("推送待签名PDF成功...");
                setTimeout("handSign.closeDlg()", 2000 )
	        }
        } catch (e) {
			handSign.showTip("推送待签名PDF失败：\r\n" + e.message);
		}
	}
	
	return {
		signPDF: function(parEditor){
			signPDF(parEditor);
		}
	}
	
})();



var global_hs_parEditor = "";

var handSign = (function(){
	
	var defaultTip = "请选择签署方式";
	var Hand_Sign_Vender_Code = "DHCC";
	
	function showHandSignDlg(onConfirm, onCancel, tip, showChoice, showQR, signTypeObj) {
		
		tip = tip || defaultTip;
		
		if ($('#handSign_dlg').length === 0) {
            var dialogHtml = '<div id="handSign_dlg" class="hisui-dialog" title="患者签名" style="display:none;overflow:hidden;background-color:#EFF9FF;width:430px;height:500px;">';
            dialogHtml += '<div id="handSign_tip" style="width:400px;height:50px;text-align:center;margin-top:15px;font-size:14px;background-color:#EFF9FF;">请稍候...</div>';
			if (showChoice) {
				dialogHtml += '<div id="handSign_choice" style="width:400px;height:50px;margin-left:15px;margin-top:5px"></div>';
            }
			if (showQR) {
				dialogHtml += '<img id="handSign_qr" src="" style="display:inline-block;width:280px;height:280px;border:darkgray;border-style:dashed;margin-left:75px"/>';
            }
			dialogHtml += '</div>';
            $('body').append(dialogHtml);
        }
        $('#handSign_tip').html(tip);
		
		if (showChoice) {
			$("#handSign_choice").append("<input class='hisui-radio' type='radio' label='患者同意' value='agree' name='handSign_choice_item',data-options='required:true,requiredSel:true,checked:true'>");
        	$("#handSign_choice").append("<input class='hisui-radio' type='radio' label='患者拒绝' value='refuse' name='handSign_choice_item',data-options='required:true,requiredSel:true,checked:false'>");
			$HUI.radio("#handSign_choice input.hisui-radio",{});
			
			//$("#handSign_choice").append("<input name='handSign_choice_item' class='hisui-radio radio-f' id='handSign_choice_item_agree' style='display: none;' type='radio' value='agree' label='患者同意'><label class='radio'>患者同意</label>");
			//$("#handSign_choice").append("<input name='handSign_choice_item' class='hisui-radio radio-f' id='handSign_choice_item_refuse' style='display: none;' type='radio' value='refuse' label='患者拒绝'><label class='radio'>患者拒绝</label>");
		}
		if (showQR) {
			$('#handSign_qr').attr('src', '');
		}
		
		var btns = [];
		if (signTypeObj != "") {
			if (signTypeObj.DataBoard.isOn) {
				btns.push({
					id: "handSign_btn_DataBoard",
					text: "PC签名板",
					handler: function() {
						doHandSign("", "DataBoard");
					}
				});
			}
			if (signTypeObj.PDFBoard.isOn) {
				btns.push({
					id: "handSign_btn_PDFBoard",
					text: "签名板签署",
					handler: function() {
						doHandSign("", "PDFBoard");
					}
				});
			}
			if (signTypeObj.PDFPad.isOn) {
				btns.push({
					id: "handSign_btn_PDFPad",
					text: "PAD签署",
					handler: function() {
						doHandSign("", "PDFPad");
					}
				});
			}
			if (signTypeObj.PDFWeChat.isOn) {
				btns.push({
					id: "handSign_btn_PDFWeChat",
					text: "微信签署",
					handler: function() {
						doHandSign("", "PDFWeChat");
					}
				});
			}
		}
		btns.push({
			id: "handSign_btn_confirmSign",
			text: "确定",
			handler: function() {
				if ('function' === typeof onConfirm) {}
				$('#handSign_dlg').dialog('close');
				$('#handSign_dlg').remove();
			}
		});
			
		$('#handSign_dlg').show().dialog({
			isTopZindex: true,
			closable: false,
			modal: true,
			buttons: btns
		});
	}
	
	function closeHandSignDlg() {
		$('#handSign_dlg').dialog('close');
		$('#handSign_dlg').remove();
	}
	
	function showHandSignTip(tip) {
		$('#handSign_tip').html(tip);
	}
	
	function disableHandSignBtn() {
		if ($("#handSign_btn_DataBoard").length > 0) {
			$("#handSign_btn_DataBoard").attr("disabled",true);
		}
		if ($("#handSign_btn_PDFBoard").length > 0) {
			$("#handSign_btn_PDFBoard").attr("disabled",true);
		}
		if ($("#handSign_btn_PDFPad").length > 0) {
			$("#handSign_btn_PDFPad").attr("disabled",true);
			$("#handSign_btn_PDFPad").attr("disabled","disabled");
		}
		if ($("#handSign_btn_PDFWeChat").length > 0) {
			$("#handSign_btn_PDFWeChat").attr("disabled",true);
		}
	}
	
	
	
	function getHandSignType(parEditor) {
		
		//从后台获取可用的签署方式：1、默认获取签名服务接口支持的所有签署方式；2、如果病历已签署过，继续使用原有签署方式
		var typeObj = {
			DataBoard:{isOn:false},
			PDFBoard:{isOn:false},
			PDFPad:{isOn:false},
			PDFWeChat:{isOn:false},
			signTypeCount:0
		};
		
		$.ajax({
			type: 'POST',
			dataType: 'text',
			url: '../EMRservice.Ajax.anySign.cls',
			async: false,
			cache: false,
			data: {
				Action : 'getHandSignType',
				episodeID: parEditor.signProps.episodeID,
				instanceID : parEditor.signProps.instanceID,
				handSignVenderCode: Hand_Sign_Vender_Code
			},
			success: function (ret) {
				var arr = JSON.parse(ret);
				if (arr.err == "") {
					if ((arr.DataBoard || "") == "1") {
						typeObj.DataBoard.isOn = true;
						typeObj.signTypeCount += 1;
					}
					if ((arr.PDFBoard || "") == "1") {
						typeObj.PDFBoard.isOn = true;
						typeObj.signTypeCount += 1;
					}
					if ((arr.PDFPad || "") == "1") {
						typeObj.PDFPad.isOn = true;
						typeObj.signTypeCount += 1;
					}
					if ((arr.PDFWeChat || "") == "1") {
						typeObj.PDFWeChat.isOn = true;
						typeObj.signTypeCount += 1;
					}
				} else { 
					throw { message : 'getHandSignType 失败！' + arr.err}; 
				}
			},
			error: function (ret) {
				throw { message : 'getHandSignType error:' + ret };
			}
		});
		
		
		//校验当前病历是否可以使用相应签署方式
		var tip = "";
		var showChoice = false;
		/*
		if (typeObj.PDFWeChat.isOn || typeObj.PDFPad.isOn) {
			var instanceID = parEditor.signProps.instanceID;
			var canDo = parEditor.canDoPDFSign("", instanceID);
			if (!canDo) {
				typeObj.PDFWeChat.isOn = false;
				typeObj.PDFPad.isOn = false;
			};
		
			var updateInst = false;
			var keyWordObj = parEditor.getPatSignKeyWordObj(instanceID,updateInst);
			keyWordObj = keyWordObj || "";
			if (!keyWordObj.allKeyWord){
				typeObj.PDFWeChat.isOn = false;
				typeObj.PDFPad.isOn = false;
				tip = "请配置有效的患者签名关键字！";
			}
		
			parEditor.signProps.allKeyWord = keyWordObj.allKeyWord||"";
			parEditor.signProps.refuseKeyWord = keyWordObj.refuseKeyWord||"";
			parEditor.signProps.agreeKeyWord = keyWordObj.agreeKeyWord||"";
			showChoice = (parEditor.signProps.agreeKeyWord != "")&&(parEditor.signProps.refuseKeyWord != "");
		}
		
		if (typeObj.DataBoard.isOn)&&(typeof(parEditor.canDoDataSign) == "function") {
			var instanceID = parEditor.signProps.instanceID;
			var canDo = parEditor.canDoDataSign("", instanceID);
			if (!canDo) {
				typeObj.DataBoard.isOn = false;
			};
		}
		*/
		
		typeObj.showChoice = showChoice;
		typeObj.tip = tip;
		if (typeObj.PDFWeChat.isOn) {
			typeObj.showQR = true;
		} else {
			typeObj.showQR = false;
		}
		return typeObj;
	}
	
	function selectHandSignType(parEditor) {
		
		var typeObj = getHandSignType(parEditor);
		
		if (typeObj.signTypeCount == 0) {
			showHandSignDlg("", "", "无可用签署方式", typeObj.showChoice, typeObj.showQR, typeObj);
		} else if (typeObj.signTypeCount == 1) {
			if (typeObj.DataBoard.isOn) {
				//数据签署时，使用PC签名板，无需弹出签名对话框
				doHandSign(parEditor, "DataBoard");
			} else {
				showHandSignDlg("", "", "请稍候...", typeObj.showChoice, typeObj.showQR, "");
				if (typeObj.PDFBoard.isOn) {
					doHandSign(parEditor, "PDFBoard")
				} else if (typeObj.PDFPad.isOn) {
					doHandSign(parEditor, "PDFPad")
				} else if (typeObj.PDFWeChat.isOn) {
					doHandSign(parEditor, "PDFWeChat")
				}
			}
		} else {
			var tip = "请选择签署方式";
			showHandSignDlg("", "", tip, typeObj.showChoice, typeObj.showQR, typeObj);
		}
	}
	
	function doHandSign(parEditor,signType) {
		disableHandSignBtn();
		parEditor =  parEditor || global_hs_parEditor;
		if (signType == "DataBoard") {
			hsPluginData.sign(parEditor);
		} else if (signType == "PDFBoard") {
			hsPluginPDF.signPDF(parEditor,"PDFBoard");
		} else if (signType == "PDFPad") {
			hsPluginPDF.signPDF(parEditor,"PDFPad");
		} else if (signType == "PDFWeChat") {
			hsPluginPDF.signPDF(parEditor,"PDFWeChat");
		} else {
			alert("未知的签署方式【" + signType + "】");
		}
	}
	
	return {
		sign: function(parEditor) {
			global_hs_parEditor = parEditor;
			selectHandSignType(parEditor);
		},
		showTip: function(tip) {
    		showHandSignTip(tip);
    	},
    	closeDlg: function() {
    		closeHandSignDlg();
    	}
	}
})();

/**
* @creator: Huxt 2019-11-27
* @desc: 住院发药打印相关使用lodop完成
* @js: scripts/pharmacy/inpha/ipprintcom.js
*      scripts/pha/ip/v1/ipprintcom.js
*/
var IPPRINTCOM = {
	PrintBy: 'Single', // All or Single
	/*
	* @desc: 住院药房打印统一入口
	* @params: _options.phacStr - 主表ID字符串, 格式: phac1^phac2^phac3
	* @params: _options.otherStr - 后台方法的其他入参字符串 str1^str3^str3
	* @params: _options.printType - 打印类型控制, 取值: 空-按默认配置, 1-明细, 2-汇总, 3-汇总&明细
	* @params: _options.reprintFlag - 补打标志, 1或者Y表示补打
	* @params: _options.pid - 打印库存不足时才传入
	*/
	Print: function(_options) {
	    _options.phacStr = _options.phacStr || "";
		_options.otherStr = _options.otherStr || "";
		_options.printType = _options.printType || "";
		_options.reprintFlag = _options.reprintFlag || "N";
		if(_options.phacStr == ""){
			return;
		}
		var pid = _options.pid || "";
		//打印普通单据
		if (this.PrintBy == 'Single') {
			this.PrintBySingle(_options);
		} else {
			this.PrintAll(_options);
		}
		//打印库存不足
		this.PrintNoStock(pid);
    },
	
	/*
	* @desc: 打印归类, 新的打印归类方式, 多个phac一起打印
	* @params: _options.phacStr - 主表ID字符串, 格式: phac1^phac2^phac3
	* @params: _options.otherStr - 后台方法的其他入参字符串 str1^str3^str3
	* @params: _options.printType - 打印类型控制, 取值: 1-明细, 2-汇总, 3-汇总&明细
	* @params: _options.reprintFlag - 补打标志, 1或者Y表示补打
	* @params: _options.isPreview - 是否预览, 1或者Y表示预览 (Chrome下多个预览任务有问题,不建议预览)
	* @others: 有些医院要求某一次发药的phac要一起打印,而不是一个phac打印一次;
	*		   多个phac一起打印走默认的配置已经没有意义,直接用参数控制
	*/
	PrintAll: function(_options){
		if (_options.printType == 1) {
			this.PrintDispDetail(_options);
		} else if (_options.printType == 2) {
			this.PrintDispTotal(_options);
		} else if (_options.printType == 3) {
			this.PrintDispDetail(_options);
			this.PrintDispTotal(_options);
		} else {
			alert("请选择打印明细或者汇总!");
		}
		this.PrintResRetDetail(_options);
	},
	
	/*
	* @desc: 打印归类, 此处按照老版本的方式归类, 一个phac打印一次
	* @params: phacStr - 主表ID字符串, 格式: phac1^phac2^phac3
	* @params: otherStr - 后台方法的其他入参字符串 str1^str3^str3
	* @params: printType - 打印类型控制, 取值: 1-明细, 2-汇总, 3-汇总&明细
	* @params: reprintFlag - 补打标志, 1或者Y表示补打
	*/
	PrintBySingle: function(_options){
		var newOptions = this.deepCopy(_options);
		var phacArr = [];
		var phacStr = _options.phacStr;
		phacArr = phacStr.split("^");
		for(var printi = 0; printi < phacArr.length; printi++){
			var phac = phacArr[printi];
			var phaType = this.GetDispType(phac);
			newOptions.phacStr = phac; //打印单个
			newOptions.phaType = phaType;
			this.ClassOfPrint(newOptions);
		}
	},
	
    /*
	* @ desc: 打印归类, 此处按照老版本的方式归类
	* @ 归类规则说明: 
	*  (1)优先按照界面勾选的打印,界面勾选的明细则打明细,勾选的汇总则打汇总,都勾选则都打印; 控制参数为printType, 1-明细, 2-汇总, 3-汇总&明细
	*  (2)发药时界面没有勾选明细和汇总,则按照配置的打印
	*  (3)特殊发药类别,先在配置界面配置打印函数名,再在js中添加该函数即可
	* @others: 
	*/
    ClassOfPrint: function(prtOptions) {
	    var phaType = prtOptions.phaType;
	    var printType = prtOptions.printType;
	    var reprintFlag = prtOptions.reprintFlag;
	    //状态值
	    prtOptions.isPreview = 0;
        var conDetail = 0, conTotal = 0, conOther = 0, prtResRet = 0, prtNoStock = 0;
        var flag = 0;
        var objDetailPrn = document.getElementById("DetailPrn"); //明细(兼容组件???)
        if (objDetailPrn) {
            if (objDetailPrn.checked == true) {
                flag = 1;
                conDetail = 1;
            }
        } else {
            if ((printType == 1) || (printType == 3)) {
                if (phaType == "ZCY") {
                    alert("草药不需要勾选打印汇总或打印明细!");
                    return;
                }
                flag = 1;
                conDetail = 1;
            }
        }
        var objTotalPrn = document.getElementById("TotalPrn"); //汇总(兼容组件???)
        if (objTotalPrn) {
            if (objTotalPrn.checked == true) {
                flag = 1;
                conTotal = 1;
            }
        } else {
            if ((printType == 2) || (printType == 3)) {
                if (phaType == "ZCY") {
                    alert("草药不需要勾选打印汇总或打印明细!");
                    return;
                }
                flag = 1;
                conTotal = 1;
            }
        }
        
		//发药打印(即reprintFlag="")或者界面未选择(即flag=0)时, 取默认配置的打印方式
        if ((flag == 0) || (reprintFlag == "")) {
            var configObj = this.GetPrtTypeConfig(phaType);
            var isPreview = parseFloat(configObj.isPreview);
            prtOptions.isPreview = configObj.isPreview || 0; 		//是否预览
            if (flag == 0) {
				conDetail = parseFloat(configObj.printDetail); 		//明细
                conTotal = parseFloat(configObj.printTotal); 		//汇总
                conOther = configObj.printOther || ""; 				//其它
                prtResRet = parseFloat(configObj.printResRet); 		//冲减退药
                prtNoStock = parseFloat(configObj.printNoStock); 	//库存不足
				if ((isNaN(conDetail)) && (isNaN(conTotal)) && (conOther == "")) {
                    alert("药品类别:" + phaType + "打印方式未设置,请核实!");
                    return;
                }
                if ((conDetail == 0) && (conTotal == 0) && (conOther == "")) {
                    alert("药品类别:" + phaType + "打印方式未设置,请核实!");
                    return;
                }
            }
        }
        
        //不印打明细和汇总,打印其他 (如:口服药标签,中草药处方)
        if (((conDetail == 0) & (conTotal == 0)) || (conOther != "")) {
            var conOtherArr = conOther.split(";");
            for (var otheri = 0; otheri < conOtherArr.length; otheri++) {
                var printother = conOtherArr[otheri];
                printother = printother.indexOf("IPPRINTCOM.") >=0 ? printother : "IPPRINTCOM." + printother;
                eval(printother)(prtOptions);
            }
        }
		
		//打印明细和汇总,不打印其他
        if (conOther == "") {
            //打印明细清单
            if (conDetail == 1) {
                this.PrintDispDetail(prtOptions);
            }
            //打印汇总单
            if (conTotal == 1) {
                this.PrintDispTotal(prtOptions);
            }
			//冲减退药明细打印
            if (prtResRet == 1) {
                this.PrintResRetDetail(prtOptions);
            }
        }
    },
	
    /*
	* @desc: 住院明细打印
	* @params: phacStr - 住院发药主表ID字符串
	* @others: 
	*/
    PrintDispDetail: function(prtOptions) {
		this.jsRunServer({
			ClassName: "web.DHCINPHA.Disp.Print",
			MethodName: "GetDetailJsonData",
			phacStr: prtOptions.phacStr,
			otherStr: prtOptions.otherStr
		}, function(retJson) {
			if(retJson.length == 0){
				return;
			}
			var LODOP = getLodop();
			IPPRINTCOM.PrintDispDetailLodop(LODOP, retJson, prtOptions);
		}, function(error){
			console.dir(error);
			alert(error.responseText);
		});
    },
	PrintDispDetailLodop: function(LODOP, jsonData, prtOptions) {
		var title = this.GetPrintTitle("发药明细单", prtOptions.reprintFlag);
		
		LODOP.PRINT_INIT("发药明细单");
	    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	    LODOP_TEXT(LODOP, title, "FromTop:15;FromLeft:45;Height:70;Width:600;FontName:宋体;FontSize:16;Alignment:2");
	    LODOP_PAGENO(LODOP, 35, 645);
	    LODOP_HTML(LODOP, {
		    //html
		    type: 'html',
		    FromTop: 50,
		    FromLeft: 5,
		    Width: '98%',
		    Height: '98%',
		    //table
		    data: jsonData,
			fontSize: 11,
			width: 195,
			padding: 2,
			columns: [
				{name:'床号', index:'bedNo', width:'12', maxTextLen:20},
				{name:'姓名', index:'patName', width:'12', hidden:false, maxTextLen:10},
				{name:'药品名称', index:'inciDesc', width:'32', hidden:false},
				{name:'剂量', index:'doseQty', width:'12', hidden:false},
				{name:'频率', index:'freqDesc', width:'11', hidden:false},
				{name:'用法', index:'instDesc', width:'14', hidden:false},
				{name:'时间', index:'timeDosingStr', width:'20', hidden:false},
				{name:'规格', index:'spec', width:'15', hidden:false},
				{name:'总量', index:'qty', width:'15', hidden:false},
				{name:'单位', index:'uomDesc', width:'11', hidden:false, align:'center'}
			],
			//表头
			formatHeader: function(main){
				return {
					marginTop: 20,
				    fontSize: 12,
				    data: [[
				    	{td: "申请科室：" + main.wardDesc, width:30},
				    	{td: "发药类别：" + main.phaType, width:15},
				    	{td: "*" + main.dispNo + "*", width:20, font:"C39HrP60DmTt", size:36} // C39P36DmTt or C39HrP60DmTt
				    ], [
				    	{td: "单号：" + main.dispNo},
				    	{td: "发药时间：" + main.phaDate},
				    	{td: "打印时间：" + main.sysDateTime}
				    ]]
				}
			},
			//表尾
			formatFooter: function(main){
				return {
				    fontSize: 12,
				    data: [[
				    	{td: "发药人：" + main.phaUserName},
				    	{td: "领药人："}
				    ], [
				    	{td: "总金额：" + main.amtSum + "元"},
				    	{td: ""}
				    ]]
				}
			}
		});
		
		if(prtOptions.isPreview==1 || prtOptions.isPreview=="1" || prtOptions.isPreview=="Y"){
			LODOP.PREVIEW();
		} else {
			LODOP.PRINT();
		}
    },
	
    /*
	* @desc: 住院汇总打印
	* @params: phacStr - 住院发药主表ID字符串
	* @others: 
	*/
    PrintDispTotal: function(prtOptions) {
	    this.jsRunServer({
			ClassName: "web.DHCINPHA.Disp.Print",
			MethodName: "GetTotalJsonData",
			phacStr: prtOptions.phacStr,
			otherStr: prtOptions.otherStr
		}, function(retJson) {
			if(retJson.length == 0){
				return;
			}
			var LODOP = getLodop();
			IPPRINTCOM.PrintDispTotalLodop(LODOP, retJson, prtOptions);
		}, function(error){
			console.dir(error);
			alert(error.responseText);
		});
    },
	PrintDispTotalLodop: function(LODOP, jsonData, prtOptions) {
		var title = this.GetPrintTitle("药品汇总清单", prtOptions.reprintFlag);
		
		LODOP.PRINT_INIT("药品汇总清单");
	    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	    LODOP_TEXT(LODOP, title, "FromTop:15;FromLeft:45;Width:600;Height:70;FontName:宋体;FontSize:16;Alignment:2");
	    LODOP_PAGENO(LODOP, 35, 645);
	    LODOP_HTML(LODOP, {
		    //html
		    type: 'html',
		    FromTop: 50,
		    FromLeft: 5,
		    Width: '98%',
		    Height: '98%',
		    //table
		    data: jsonData,
			fontSize: 11,
			width: 195,
			columns: [
				{name:'货位', index:'stkBin', width:'15', hidden:false},
				{name:'药品名称', index:'inciDesc', width:'32', maxTextLen:20},
				{name:'规格', index:'spec', width:'15', hidden:false, maxTextLen:10},
				{name:'发药数', index:'facQty', width:'12', hidden:false},
				{name:'医嘱数', index:'ordQty', width:'12', hidden:false},
				{name:'冲减数', index:'resQty', width:'12', hidden:false},
				{name:'总价', index:'amt', width:'12', hidden:false, align:'center'},
				{name:'床位数量', index:'bedQty', width:'30', hidden:false}
			],
			//表头
			formatHeader: function(main){
				return {
					marginTop: 20,
				    fontSize: 12,
				    data: [[
				    	{td: "申请科室：" + main.wardDesc, width:30},
				    	{td: "发药类别：" + main.phaType, width:15},
				    	{td: "*" + main.dispNo + "*", width:20, font:"C39HrP60DmTt", size:36} // C39P36DmTt or C39HrP60DmTt
				    ], [
				    	{td: "单号：" + main.dispNo},
				    	{td: "发药时间：" + main.phaDate},
				    	{td: "打印时间：" + main.sysDateTime}
				    ]]
				}
			},
			//表尾
			formatFooter: function(main){
				return {
				    fontSize: 12,
				    data: [[
				    	{td: "总金额：" + main.amtSum + "元"},
				    	{td: ""},
				    	{td: ""}
				    ], [
				    	{td: "制单人：" + session['LOGON.USERNAME']},
				    	{td: "领药人："},
				    	{td: "送药人："}
				    ]]
				}
			}
		});
	    if(prtOptions.isPreview==1 || prtOptions.isPreview=="1" || prtOptions.isPreview=="Y"){
			LODOP.PREVIEW();
		} else {
			LODOP.PRINT();
		}
    },

    /*
	* @desc: 打印冲减退药明细
	* @params: phacStr - 住院发药主表ID字符串
	* @others: 
	*/
    PrintResRetDetail: function(prtOptions) {
	    this.jsRunServer({
			ClassName: "web.DHCINPHA.Disp.Print",
			MethodName: "ResRetDetailJsonData",
			phacStr: prtOptions.phacStr,
			otherStr: prtOptions.otherStr
		}, function(retJson) {
			if(retJson.length == 0){
				return;
			}
			var LODOP = getLodop();
			IPPRINTCOM.PrintResRetDetailLodop(LODOP, retJson, prtOptions);
		}, function(error){
			console.dir(error);
			alert(error.responseText);
		});
    },
	PrintResRetDetailLodop: function(LODOP, jsonData, prtOptions) {
		var title = this.GetPrintTitle("冲减明细单", prtOptions.reprintFlag);
		
		LODOP.PRINT_INIT("冲减明细单");
	    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	    LODOP_TEXT(LODOP, title, "FromTop:15;FromLeft:45;Width:600;Height:70;FontName:宋体;FontSize:16;Alignment:2");
	    LODOP_PAGENO(LODOP, 45, 645);
	    LODOP_HTML(LODOP, {
		    //html
		    type: 'html',
		    FromTop: 50,
		    FromLeft: 5,
		    Width: '98%',
		    Height: '98%',
		    //table
		    data: jsonData,
			fontSize: 11,
			width: 195,
			columns: [
				{name:'药品名称', index:'inciDesc', width:'32'},
				{name:'规格', index:'spec', width:'15', hidden:false, maxTextLen:10},
				{name:'申请数量', index:'reqQty', width:'20', hidden:false},
				{name:'冲减数量', index:'resQty', width:'20', hidden:false},
				{name:'冲减人', index:'retPatName', width:'20', hidden:false}
			],
			//表头
			formatHeader: function(main){
				return {
					marginTop: 20,
				    fontSize: 12,
				    data: [[
				    	{td: "发药单号：" + main.dispNo, width:50},
				    	{td: ""},
				    	{td: "退药申请单号：" + main.reqNo, width:50},
				    	{td: ""}
				    ], [
				    	{td: "病区：" + main.wardDesc},
				    	{td: ""},
				    	{td: ""},
				    	{td: ""}
				    ], [
				    	{td: "床号：" + main.bedCode},
				    	{td: "登记号：" + main.patNo},
				    	{td: "姓名：" + main.patName},
				    	{td: "性别：" + main.patSex}
				    ]]
				}
			},
			//表尾
			formatFooter: function(main){
				return {
				    fontSize: 12,
				    data: [[
				    	{td: "制单人：" + session['LOGON.USERNAME']}
				    ]]
				}
			}
		});
	    if(prtOptions.isPreview==1 || prtOptions.isPreview=="1" || prtOptions.isPreview=="Y"){
			LODOP.PREVIEW();
		} else {
			LODOP.PRINT();
		}
    },
    
    /*
	* @desc: 打印库存不足 (注: 库存不足是根据发药时查询产生的临时Global来打印的,无法补打)
	* @params: pid - 查询明细或者汇总时产生的pid
	* @others: 
	*/
    PrintNoStock: function(pid) {
        if (pid == "") {
            return;
        }
        this.jsRunServer({
			ClassName: "web.DHCINPHA.Disp.Print",
			MethodName: "GetNoStock",
			Pid: pid
		}, function(retJson) {
			if(retJson.length == 0){
				return;
			}
			var LODOP = getLodop();
			IPPRINTCOM.PrintNoStockLodop(LODOP, retJson);
		}, function(error){
			console.dir(error);
			alert(error.responseText);
		});
    },
    PrintNoStockLodop: function(LODOP, jsonData) {
	    var prtOptions = {};
        var title = this.GetPrintTitle("库存不足明细", prtOptions.reprintFlag);
		
		LODOP.PRINT_INIT("库存不足明细");
	    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	    LODOP_TEXT(LODOP, title, "FromTop:15;FromLeft:45;Width:600;Height:70;FontName:宋体;FontSize:16;Alignment:2");
	    LODOP_PAGENO(LODOP, 45, 645);
	    LODOP_HTML(LODOP, {
		    //html
		    type: 'html',
		    FromTop: 50,
		    FromLeft: 5,
		    Width: '98%',
		    Height: '98%',
		    //table
		    data: jsonData,
			fontSize: 11,
			width: 195,
			columns: [
				{name:'药品名称', index:'incDesc', width:'32'},
				{name:'规格', index:'spec', width:'15', hidden:false, maxTextLen:10},
				{name:'数量', index:'qty', width:'20', hidden:false},
				{name:'单位', index:'uomDesc', width:'20', hidden:false}
			],
			//表头
			formatHeader: function(main){
				return {
					marginTop: 20,
				    fontSize: 12,
				    data: [[
				    	{td: "病区：" + main.wardDesc, width:50},
				    	{td: ""},
				    	{td: ""},
				    	{td: ""}
				    ], [
				    	{td: "登记号：" + main.patNo},
				    	{td: "姓名：" + main.patName},
				    	{td: "床号：" + main.bedCode},
				    	{td: "性别：" + main.patSex}
				    ]]
				}
			},
			//表尾
			formatFooter: function(main){
				return {
				    fontSize: 12,
				    data: [[
				    	{td: "打印人：" + session['LOGON.USERNAME']}
				    ]]
				}
			}
		});
	    if(prtOptions.isPreview==1 || prtOptions.isPreview=="1" || prtOptions.isPreview=="Y"){
			LODOP.PREVIEW();
		} else {
			LODOP.PRINT();
		}
    },
	
	/*
	* @desc: 中草药按处方打印 -- xml模板
	* @params: phacStr - 住院发药主表ID字符串
	* @others: 
	*   (1)中草药打印和明细&汇总打印二者不可能同时出现
	*   (2)csp页面引入js: scripts/pharmacy/inpha/dhcpha.inpha.hmprintcom.js
	*/
    PrintZCY: function(prtOptions) {
	    IPPRINTCOM.jsRunServer({
			ClassName: "web.DHCINPHA.Disp.Print",
			MethodName: "GetPrescNoArr",
			phacStr: prtOptions.phacStr
		}, function(retJson) {
			var pLen = retJson.length;
			for (var pi=0; pi<pLen; pi++) {
				var PrescNo = retJson[0];
				INPHA_PRINTCOM.Presc(PrescNo, "正方", "");
			}
		}, function(error){
			console.dir(error);
			alert(error.responseText);
		});
    },
	
	/*
	* @desc: 打印口服药标签 -- xml模板
	* @params: phacStr - 住院发药主表ID字符串
	* @others: 中草药打印和明细&汇总打印二者不可能同时出现
	*/
    PrintKFYLabel: function(prtOptions) {
	    IPPRINTCOM.jsRunServer({
			ClassName: "web.DHCINPHA.Disp.Print",
			MethodName: "GetKFYLabelJsonData",
			phacStr: prtOptions.phacStr,
			otherStr: prtOptions.otherStr
		}, function(retJson) {
			IPPRINTCOM.PrintKFYLabelLodop(retJson);
		}, function(error) {
			console.dir(error);
			alert(error.responseText);
		});
    },
    PrintKFYLabelLodop: function(jsonData){
	    var prtData = [];
	    var persons = jsonData.length;
	    for (var i = 0; i < persons; i++) {
		    var onePersonData = jsonData[i];
		    var mainData = onePersonData.main;
		    var detailData = onePersonData.detail;
			var myPara = "";
			var myList = "";
			for (var j = 0; j < detailData.length; j++) {
				prtData.push({
					Para: {
						warddesc: mainData.wardDesc,
						paname: mainData.patName,
						bed: mainData.bedCode,
						orddate: detailData[j].dodisDate,
						instruction: detailData[j].instDesc,
						freqflag: detailData[j].freqDesc
					},
					List: []
				});
			}
		}
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'DHCSTPJLABLE',
			data: prtData,
			oneTask: true
		});
	},
	
	/*
	* @desc: 获取发药主表对应的发药类别
	* @params: phac - 发药主表ID
	*/
	GetDispType: function(phac){
		var dispType = tkMakeServerCall("web.DHCINPHA.Disp.Print", "GetDispType", phac);
		return dispType;
	},
	/*
	* @desc: 公共变量(避免多次交互)
	*/
	CommonVar: null,
	GetCommonVar: function() {
		if (this.CommonVar != null) {
			return;
		}
		var phaloc = $("#sel-phaloc").val() || session['LOGON.CTLOCID'];
		var printConfigStr = tkMakeServerCall("web.DHCINPHA.Disp.Print", "GetPrintConfig", phaloc);
		this.CommonVar = eval("(" + printConfigStr + ")");
		return;
	},
	/*
	* @desc: 获取打印标题
	*/
	GetPrintTitle: function(type, reprintFlag){
		this.GetCommonVar();
		if (reprintFlag == "Y" || reprintFlag == 1 || reprintFlag == "1"){
			return (this.CommonVar.titlePrefix) + type + "(补)";
		}
		return (this.CommonVar.titlePrefix) + type;
	},
	/*
	* @desc: 获取某发药类别的
	* @params: dspTypeCode - 发药类别代码
	*/
	GetPrtTypeConfig: function(dspTypeCode) {
		this.GetCommonVar();
		return this.CommonVar[dspTypeCode] || {};
	},
	/*
	* @desc: 对象深拷贝
	*/
	deepCopy: function (source) {
		var result={};
		for (var key in source) {
			result[key] = typeof source[key]==='object'? IPPRINTCOM.deepCoyp(source[key]): source[key];
		}
		return result; 
	},
	/*
	* @desc: 8.3没有hisui的环境,先自定义一个ajax
	*/
	jsRunServer: function(_options, successFn, errorFn){
		$.ajax({
			url: "websys.Broker.cls",
			type: "post",
			async: false,
			dataType: "json",
			data: _options,
			success: function(jsonData){
				successFn(jsonData);
			},
			error: function(XMLHR){
				errorFn(XMLHR);
			}
	    })
	}
}

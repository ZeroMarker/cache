/**
* @creator: Huxt 2019-11-27
* @desc: סԺ��ҩ��ӡ���ʹ��lodop���
* @js: scripts/pharmacy/inpha/ipprintcom.js
*      scripts/pha/ip/v1/ipprintcom.js
*/
var IPPRINTCOM = {
	PrintBy: 'Single', // All or Single
	/*
	* @desc: סԺҩ����ӡͳһ���
	* @params: _options.phacStr - ����ID�ַ���, ��ʽ: phac1^phac2^phac3
	* @params: _options.otherStr - ��̨��������������ַ��� str1^str3^str3
	* @params: _options.printType - ��ӡ���Ϳ���, ȡֵ: ��-��Ĭ������, 1-��ϸ, 2-����, 3-����&��ϸ
	* @params: _options.reprintFlag - �����־, 1����Y��ʾ����
	* @params: _options.pid - ��ӡ��治��ʱ�Ŵ���
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
		//��ӡ��ͨ����
		if (this.PrintBy == 'Single') {
			this.PrintBySingle(_options);
		} else {
			this.PrintAll(_options);
		}
		//��ӡ��治��
		this.PrintNoStock(pid);
    },
	
	/*
	* @desc: ��ӡ����, �µĴ�ӡ���෽ʽ, ���phacһ���ӡ
	* @params: _options.phacStr - ����ID�ַ���, ��ʽ: phac1^phac2^phac3
	* @params: _options.otherStr - ��̨��������������ַ��� str1^str3^str3
	* @params: _options.printType - ��ӡ���Ϳ���, ȡֵ: 1-��ϸ, 2-����, 3-����&��ϸ
	* @params: _options.reprintFlag - �����־, 1����Y��ʾ����
	* @params: _options.isPreview - �Ƿ�Ԥ��, 1����Y��ʾԤ�� (Chrome�¶��Ԥ������������,������Ԥ��)
	* @others: ��ЩҽԺҪ��ĳһ�η�ҩ��phacҪһ���ӡ,������һ��phac��ӡһ��;
	*		   ���phacһ���ӡ��Ĭ�ϵ������Ѿ�û������,ֱ���ò�������
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
			alert("��ѡ���ӡ��ϸ���߻���!");
		}
		this.PrintResRetDetail(_options);
	},
	
	/*
	* @desc: ��ӡ����, �˴������ϰ汾�ķ�ʽ����, һ��phac��ӡһ��
	* @params: phacStr - ����ID�ַ���, ��ʽ: phac1^phac2^phac3
	* @params: otherStr - ��̨��������������ַ��� str1^str3^str3
	* @params: printType - ��ӡ���Ϳ���, ȡֵ: 1-��ϸ, 2-����, 3-����&��ϸ
	* @params: reprintFlag - �����־, 1����Y��ʾ����
	*/
	PrintBySingle: function(_options){
		var newOptions = this.deepCopy(_options);
		var phacArr = [];
		var phacStr = _options.phacStr;
		phacArr = phacStr.split("^");
		for(var printi = 0; printi < phacArr.length; printi++){
			var phac = phacArr[printi];
			var phaType = this.GetDispType(phac);
			newOptions.phacStr = phac; //��ӡ����
			newOptions.phaType = phaType;
			this.ClassOfPrint(newOptions);
		}
	},
	
    /*
	* @ desc: ��ӡ����, �˴������ϰ汾�ķ�ʽ����
	* @ �������˵��: 
	*  (1)���Ȱ��ս��湴ѡ�Ĵ�ӡ,���湴ѡ����ϸ�����ϸ,��ѡ�Ļ���������,����ѡ�򶼴�ӡ; ���Ʋ���ΪprintType, 1-��ϸ, 2-����, 3-����&��ϸ
	*  (2)��ҩʱ����û�й�ѡ��ϸ�ͻ���,�������õĴ�ӡ
	*  (3)���ⷢҩ���,�������ý������ô�ӡ������,����js����Ӹú�������
	* @others: 
	*/
    ClassOfPrint: function(prtOptions) {
	    var phaType = prtOptions.phaType;
	    var printType = prtOptions.printType;
	    var reprintFlag = prtOptions.reprintFlag;
	    //״ֵ̬
	    prtOptions.isPreview = 0;
        var conDetail = 0, conTotal = 0, conOther = 0, prtResRet = 0, prtNoStock = 0;
        var flag = 0;
        var objDetailPrn = document.getElementById("DetailPrn"); //��ϸ(�������???)
        if (objDetailPrn) {
            if (objDetailPrn.checked == true) {
                flag = 1;
                conDetail = 1;
            }
        } else {
            if ((printType == 1) || (printType == 3)) {
                if (phaType == "ZCY") {
                    alert("��ҩ����Ҫ��ѡ��ӡ���ܻ��ӡ��ϸ!");
                    return;
                }
                flag = 1;
                conDetail = 1;
            }
        }
        var objTotalPrn = document.getElementById("TotalPrn"); //����(�������???)
        if (objTotalPrn) {
            if (objTotalPrn.checked == true) {
                flag = 1;
                conTotal = 1;
            }
        } else {
            if ((printType == 2) || (printType == 3)) {
                if (phaType == "ZCY") {
                    alert("��ҩ����Ҫ��ѡ��ӡ���ܻ��ӡ��ϸ!");
                    return;
                }
                flag = 1;
                conTotal = 1;
            }
        }
        
		//��ҩ��ӡ(��reprintFlag="")���߽���δѡ��(��flag=0)ʱ, ȡĬ�����õĴ�ӡ��ʽ
        if ((flag == 0) || (reprintFlag == "")) {
            var configObj = this.GetPrtTypeConfig(phaType);
            var isPreview = parseFloat(configObj.isPreview);
            prtOptions.isPreview = configObj.isPreview || 0; 		//�Ƿ�Ԥ��
            if (flag == 0) {
				conDetail = parseFloat(configObj.printDetail); 		//��ϸ
                conTotal = parseFloat(configObj.printTotal); 		//����
                conOther = configObj.printOther || ""; 				//����
                prtResRet = parseFloat(configObj.printResRet); 		//�����ҩ
                prtNoStock = parseFloat(configObj.printNoStock); 	//��治��
				if ((isNaN(conDetail)) && (isNaN(conTotal)) && (conOther == "")) {
                    alert("ҩƷ���:" + phaType + "��ӡ��ʽδ����,���ʵ!");
                    return;
                }
                if ((conDetail == 0) && (conTotal == 0) && (conOther == "")) {
                    alert("ҩƷ���:" + phaType + "��ӡ��ʽδ����,���ʵ!");
                    return;
                }
            }
        }
        
        //��ӡ����ϸ�ͻ���,��ӡ���� (��:�ڷ�ҩ��ǩ,�в�ҩ����)
        if (((conDetail == 0) & (conTotal == 0)) || (conOther != "")) {
            var conOtherArr = conOther.split(";");
            for (var otheri = 0; otheri < conOtherArr.length; otheri++) {
                var printother = conOtherArr[otheri];
                printother = printother.indexOf("IPPRINTCOM.") >=0 ? printother : "IPPRINTCOM." + printother;
                eval(printother)(prtOptions);
            }
        }
		
		//��ӡ��ϸ�ͻ���,����ӡ����
        if (conOther == "") {
            //��ӡ��ϸ�嵥
            if (conDetail == 1) {
                this.PrintDispDetail(prtOptions);
            }
            //��ӡ���ܵ�
            if (conTotal == 1) {
                this.PrintDispTotal(prtOptions);
            }
			//�����ҩ��ϸ��ӡ
            if (prtResRet == 1) {
                this.PrintResRetDetail(prtOptions);
            }
        }
    },
	
    /*
	* @desc: סԺ��ϸ��ӡ
	* @params: phacStr - סԺ��ҩ����ID�ַ���
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
		var title = this.GetPrintTitle("��ҩ��ϸ��", prtOptions.reprintFlag);
		
		LODOP.PRINT_INIT("��ҩ��ϸ��");
	    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	    LODOP_TEXT(LODOP, title, "FromTop:15;FromLeft:45;Height:70;Width:600;FontName:����;FontSize:16;Alignment:2");
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
				{name:'����', index:'bedNo', width:'12', maxTextLen:20},
				{name:'����', index:'patName', width:'12', hidden:false, maxTextLen:10},
				{name:'ҩƷ����', index:'inciDesc', width:'32', hidden:false},
				{name:'����', index:'doseQty', width:'12', hidden:false},
				{name:'Ƶ��', index:'freqDesc', width:'11', hidden:false},
				{name:'�÷�', index:'instDesc', width:'14', hidden:false},
				{name:'ʱ��', index:'timeDosingStr', width:'20', hidden:false},
				{name:'���', index:'spec', width:'15', hidden:false},
				{name:'����', index:'qty', width:'15', hidden:false},
				{name:'��λ', index:'uomDesc', width:'11', hidden:false, align:'center'}
			],
			//��ͷ
			formatHeader: function(main){
				return {
					marginTop: 20,
				    fontSize: 12,
				    data: [[
				    	{td: "������ң�" + main.wardDesc, width:30},
				    	{td: "��ҩ���" + main.phaType, width:15},
				    	{td: "*" + main.dispNo + "*", width:20, font:"C39HrP60DmTt", size:36} // C39P36DmTt or C39HrP60DmTt
				    ], [
				    	{td: "���ţ�" + main.dispNo},
				    	{td: "��ҩʱ�䣺" + main.phaDate},
				    	{td: "��ӡʱ�䣺" + main.sysDateTime}
				    ]]
				}
			},
			//��β
			formatFooter: function(main){
				return {
				    fontSize: 12,
				    data: [[
				    	{td: "��ҩ�ˣ�" + main.phaUserName},
				    	{td: "��ҩ�ˣ�"}
				    ], [
				    	{td: "�ܽ�" + main.amtSum + "Ԫ"},
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
	* @desc: סԺ���ܴ�ӡ
	* @params: phacStr - סԺ��ҩ����ID�ַ���
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
		var title = this.GetPrintTitle("ҩƷ�����嵥", prtOptions.reprintFlag);
		
		LODOP.PRINT_INIT("ҩƷ�����嵥");
	    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	    LODOP_TEXT(LODOP, title, "FromTop:15;FromLeft:45;Width:600;Height:70;FontName:����;FontSize:16;Alignment:2");
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
				{name:'��λ', index:'stkBin', width:'15', hidden:false},
				{name:'ҩƷ����', index:'inciDesc', width:'32', maxTextLen:20},
				{name:'���', index:'spec', width:'15', hidden:false, maxTextLen:10},
				{name:'��ҩ��', index:'facQty', width:'12', hidden:false},
				{name:'ҽ����', index:'ordQty', width:'12', hidden:false},
				{name:'�����', index:'resQty', width:'12', hidden:false},
				{name:'�ܼ�', index:'amt', width:'12', hidden:false, align:'center'},
				{name:'��λ����', index:'bedQty', width:'30', hidden:false}
			],
			//��ͷ
			formatHeader: function(main){
				return {
					marginTop: 20,
				    fontSize: 12,
				    data: [[
				    	{td: "������ң�" + main.wardDesc, width:30},
				    	{td: "��ҩ���" + main.phaType, width:15},
				    	{td: "*" + main.dispNo + "*", width:20, font:"C39HrP60DmTt", size:36} // C39P36DmTt or C39HrP60DmTt
				    ], [
				    	{td: "���ţ�" + main.dispNo},
				    	{td: "��ҩʱ�䣺" + main.phaDate},
				    	{td: "��ӡʱ�䣺" + main.sysDateTime}
				    ]]
				}
			},
			//��β
			formatFooter: function(main){
				return {
				    fontSize: 12,
				    data: [[
				    	{td: "�ܽ�" + main.amtSum + "Ԫ"},
				    	{td: ""},
				    	{td: ""}
				    ], [
				    	{td: "�Ƶ��ˣ�" + session['LOGON.USERNAME']},
				    	{td: "��ҩ�ˣ�"},
				    	{td: "��ҩ�ˣ�"}
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
	* @desc: ��ӡ�����ҩ��ϸ
	* @params: phacStr - סԺ��ҩ����ID�ַ���
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
		var title = this.GetPrintTitle("�����ϸ��", prtOptions.reprintFlag);
		
		LODOP.PRINT_INIT("�����ϸ��");
	    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	    LODOP_TEXT(LODOP, title, "FromTop:15;FromLeft:45;Width:600;Height:70;FontName:����;FontSize:16;Alignment:2");
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
				{name:'ҩƷ����', index:'inciDesc', width:'32'},
				{name:'���', index:'spec', width:'15', hidden:false, maxTextLen:10},
				{name:'��������', index:'reqQty', width:'20', hidden:false},
				{name:'�������', index:'resQty', width:'20', hidden:false},
				{name:'�����', index:'retPatName', width:'20', hidden:false}
			],
			//��ͷ
			formatHeader: function(main){
				return {
					marginTop: 20,
				    fontSize: 12,
				    data: [[
				    	{td: "��ҩ���ţ�" + main.dispNo, width:50},
				    	{td: ""},
				    	{td: "��ҩ���뵥�ţ�" + main.reqNo, width:50},
				    	{td: ""}
				    ], [
				    	{td: "������" + main.wardDesc},
				    	{td: ""},
				    	{td: ""},
				    	{td: ""}
				    ], [
				    	{td: "���ţ�" + main.bedCode},
				    	{td: "�ǼǺţ�" + main.patNo},
				    	{td: "������" + main.patName},
				    	{td: "�Ա�" + main.patSex}
				    ]]
				}
			},
			//��β
			formatFooter: function(main){
				return {
				    fontSize: 12,
				    data: [[
				    	{td: "�Ƶ��ˣ�" + session['LOGON.USERNAME']}
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
	* @desc: ��ӡ��治�� (ע: ��治���Ǹ��ݷ�ҩʱ��ѯ��������ʱGlobal����ӡ��,�޷�����)
	* @params: pid - ��ѯ��ϸ���߻���ʱ������pid
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
        var title = this.GetPrintTitle("��治����ϸ", prtOptions.reprintFlag);
		
		LODOP.PRINT_INIT("��治����ϸ");
	    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	    LODOP_TEXT(LODOP, title, "FromTop:15;FromLeft:45;Width:600;Height:70;FontName:����;FontSize:16;Alignment:2");
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
				{name:'ҩƷ����', index:'incDesc', width:'32'},
				{name:'���', index:'spec', width:'15', hidden:false, maxTextLen:10},
				{name:'����', index:'qty', width:'20', hidden:false},
				{name:'��λ', index:'uomDesc', width:'20', hidden:false}
			],
			//��ͷ
			formatHeader: function(main){
				return {
					marginTop: 20,
				    fontSize: 12,
				    data: [[
				    	{td: "������" + main.wardDesc, width:50},
				    	{td: ""},
				    	{td: ""},
				    	{td: ""}
				    ], [
				    	{td: "�ǼǺţ�" + main.patNo},
				    	{td: "������" + main.patName},
				    	{td: "���ţ�" + main.bedCode},
				    	{td: "�Ա�" + main.patSex}
				    ]]
				}
			},
			//��β
			formatFooter: function(main){
				return {
				    fontSize: 12,
				    data: [[
				    	{td: "��ӡ�ˣ�" + session['LOGON.USERNAME']}
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
	* @desc: �в�ҩ��������ӡ -- xmlģ��
	* @params: phacStr - סԺ��ҩ����ID�ַ���
	* @others: 
	*   (1)�в�ҩ��ӡ����ϸ&���ܴ�ӡ���߲�����ͬʱ����
	*   (2)cspҳ������js: scripts/pharmacy/inpha/dhcpha.inpha.hmprintcom.js
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
				INPHA_PRINTCOM.Presc(PrescNo, "����", "");
			}
		}, function(error){
			console.dir(error);
			alert(error.responseText);
		});
    },
	
	/*
	* @desc: ��ӡ�ڷ�ҩ��ǩ -- xmlģ��
	* @params: phacStr - סԺ��ҩ����ID�ַ���
	* @others: �в�ҩ��ӡ����ϸ&���ܴ�ӡ���߲�����ͬʱ����
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
	* @desc: ��ȡ��ҩ�����Ӧ�ķ�ҩ���
	* @params: phac - ��ҩ����ID
	*/
	GetDispType: function(phac){
		var dispType = tkMakeServerCall("web.DHCINPHA.Disp.Print", "GetDispType", phac);
		return dispType;
	},
	/*
	* @desc: ��������(�����ν���)
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
	* @desc: ��ȡ��ӡ����
	*/
	GetPrintTitle: function(type, reprintFlag){
		this.GetCommonVar();
		if (reprintFlag == "Y" || reprintFlag == 1 || reprintFlag == "1"){
			return (this.CommonVar.titlePrefix) + type + "(��)";
		}
		return (this.CommonVar.titlePrefix) + type;
	},
	/*
	* @desc: ��ȡĳ��ҩ����
	* @params: dspTypeCode - ��ҩ������
	*/
	GetPrtTypeConfig: function(dspTypeCode) {
		this.GetCommonVar();
		return this.CommonVar[dspTypeCode] || {};
	},
	/*
	* @desc: �������
	*/
	deepCopy: function (source) {
		var result={};
		for (var key in source) {
			result[key] = typeof source[key]==='object'? IPPRINTCOM.deepCoyp(source[key]): source[key];
		}
		return result; 
	},
	/*
	* @desc: 8.3û��hisui�Ļ���,���Զ���һ��ajax
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

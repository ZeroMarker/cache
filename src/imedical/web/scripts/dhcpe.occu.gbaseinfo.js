// dhcpe.occu.gbaseinfo.js
// dhcpe.occu.gbaseinfo.csp
// 团体职业病信息

$(function() {
	InitCombo();
	
	$("#Update").click(function() {
		Update();
	});
	
	$("#Clean").click(function() {
		Clean();
	});
	
	InitDefVal();
});

function InitCombo() {
	// 是否分支机构
	$HUI.combobox("#OccIsSubOrg", {
		valueField:"id",
        textField:"text",
        panelHeight:"auto",
        editable:false,
        data:[
        	{id:"Y",text:$g("是")},
        	{id:"N",text:$g("否")}
        ]
	});
	
	// 所属省市县
	InitComboAREA("OccProv", "AREA", "BASE");
	
	// 行业类别
	$HUI.combobox("#OccIndustry", {
		url:$URL + "?ClassName=web.DHCPE.Industry&QueryName=SearchIndustry&Active=Y&ResultSetType=array",
		valueField:"TID",
        textField:"TDesc",
        editable:true,
		defaultFilter:4,
        onBeforeLoad:function(param) {
            var Desc = $("#OccIndustry").combobox("getText");
            param.Desc = Desc;
        },
        onSelect:function(record) {}
	});
	
	// 经济类型
	$cm({
		ClassName:"web.DHCPE.CT.Occu.DictionaryCode",
		MethodName:"GetBaseCodeObjByPIdNew",
		pType:"BASE",
		Type:"ECONOMIC",
		SubTree:3,
		RtnFlag:"String",
		Active:"Y"
	},function(jsonData){
		$HUI.combotree("#OccEconomicType", {
	        onlyLeafCheck:true,
	        editable:true,
	        panelHeight:"auto",
        	data:jsonData.children
		});
	});
	
	// 企业规模
	$HUI.combobox("#OccEnterpriseScale", {
		url:$URL + "?ClassName=web.DHCPE.CT.Occu.DictionaryCode&QueryName=SearchBaseCode&Type=SCALE&PType=BASE&Active=Y&ResultSetType=array",
		valueField:"TId",
        textField:"TDesc",
        editable:true,
		panelHeight:"auto",
        onBeforeLoad:function(param) {
            var Desc = $("#OccEnterpriseScale").combobox("getText");
            param.Desc = Desc;
        },
        onSelect:function(record) {
        }
	});
}

function InitComboAREA(eleName, Type, PType) {
	
	var subEle = "", clrEle = [];
	switch(eleName){    
	    case "OccProv": subEle = "OccCity", clrEle = ["OccCity", "OccCounty", "OccTown"]; break;
	    case "OccCity": subEle = "OccCounty", clrEle = ["OccCounty", "OccTown"]; break;
	    case "OccCounty": subEle = "OccTown", clrEle = ["OccTown"]; break;
		default: subEle = "", clrEle = [];
	};
	$HUI.combobox("#" + eleName, {
		url:$URL + "?ClassName=web.DHCPE.CT.Occu.DictionaryCode&QueryName=SearchBaseCode&Type=" + Type + "&PType=" + PType + "&Active=Y&ResultSetType=array",
		valueField:"TId",
        textField:"TDesc",
        editable:true,
		panelHeight:"auto",
        onBeforeLoad:function(param) {
            var Desc = $("#" + eleName).combobox("getText");
            param.Desc = Desc;
        },
        onSelect:function(record) {
			if (clrEle.length > 0) {
		        $("#" + clrEle.join(", #")).combobox("loadData", {}).combobox("clear");
		    }
		    if (subEle != "") InitComboAREA(subEle, record.TCode, Type);
        },
        onLoadSuccess:function() {
	        
        }
	});
}

function Update() {
	if (PreGBaseInfo == "") {
		$.messager.alert("提示", "团体ID为空！", "info");
		return false;
	}
	var obj;
	var OccIsSubOrg = "", OccUpCreditCode = "", OccCreditCode = "", OccPostalcode = "",
		OccProv = "", OccCity = "", OccCounty = "", OccTown = "",
		OccIndustry = "", OccEconomicType = "", OccEnterpriseScale = "",
		OccPELinkman = "", OccPELinkTitle = "", OccPELinkTel = "",
		OccRegArr = "", OccRegCapital = "",
		OccLegalPerson = "", OccLegalTel = "", OccSubordination = "",
		OccEstablishment = "", OccArea = "", OccCreateDate = "",
		OccTestman = "", OccTestTitle = "", OccTestTel = "",
		OccSafetyPerson = "", OccSafetyTitle = "", OccSafetyTel = "",
		OccWorkplace = "", OccZyPostalcode = "", OccOrganization = "";
		
	var WorkersNumber = "", ProductionNumber = "", EndangerWorkers = "",
		FemaleWorkers = "", FemaleProduction = "", FemaleEndanger = "";
	
	OccIsSubOrg = $("#OccIsSubOrg").combobox("getValue");  // 是否分支机构
	if (OccIsSubOrg == "") { $.messager.alert("提示", "请选择是否分支机构！", "info"); return false; }
	
	OccUpCreditCode = $("#OccUpCreditCode").val();  // 上级单位社会信用代码
	if (OccIsSubOrg == "Y" && OccUpCreditCode == "") { $.messager.alert("提示", "分支机构请输入上级单位社会信用代码！", "info"); return false; }
	
	OccCreditCode = $("#OccCreditCode").val();  // 统一社会信用代码
	if (OccCreditCode == "") { $.messager.alert("提示", "请填写统一社会信用代码！", "info"); return false; }
	
	OccPostalcode = $("#OccPostalcode").val();  // 注册邮编
	if (OccPostalcode == "") { $.messager.alert("提示", "请填写注册邮编！", "info"); return false; }
	
	OccProv = $("#OccProv").combobox("getValue");  // 所属省
	if (OccProv == "") { $.messager.alert("提示", "请选择所属省！", "info"); return false; }
	
	OccCity = $("#OccCity").combobox("getValue");  // 所属市
	if (OccCity == "") { $.messager.alert("提示", "请选择所属市！", "info"); return false; }
	
	OccCounty = $("#OccCounty").combobox("getValue");  // 所属区(县)
	if (OccCounty == "") { $.messager.alert("提示", "请选择所属区(县)！", "info"); return false; }
	
	OccTown = $("#OccTown").combobox("getValue");  // 所属镇(街道)
	if (OccTown == "") { $.messager.alert("提示", "请选择所属镇(街道)！", "info"); return false; }
	
	OccIndustry = $("#OccIndustry").combobox("getValue");  // 行业类别
	if (OccIndustry == "") { $.messager.alert("提示", "请选择行业类别！", "info"); return false; }
	
 	OccEconomicType = $("#OccEconomicType").combotree("getValue");  // 经济类型
	if (OccEconomicType == "") { $.messager.alert("提示", "请选择经济类型！", "info"); return false; }
	
	OccEnterpriseScale = $("#OccEnterpriseScale").combobox("getValue");  // 企业规模
	if (OccEnterpriseScale == "") { $.messager.alert("提示", "请选择企业规模！", "info"); return false; }
	
	OccPELinkman = $("#OccPELinkman").val();  // 体检联系人
	if (OccPELinkman == "") { $.messager.alert("提示", "请填写体检联系人！", "info"); return false; }
	
	OccPELinkTitle = $("#OccPELinkTitle").val();  // 体检联系人职务
	
	OccPELinkTel = $("#OccPELinkTel").val();  // 体检联系人电话
	if (OccPELinkTel == "") { $.messager.alert("提示", "请填写体检联系人电话！", "info"); return false; }
	
	OccRegArr = $("#OccRegArr").val();  // 注册地址
	if (OccRegArr == "") { $.messager.alert("提示", "请填写注册地址！", "info"); return false; }
	
	OccRegCapital = $("#OccRegCapital").val();  // 注册资金
	
	OccLegalPerson = $("#OccLegalPerson").val();  // 法人代表
	OccLegalTel = $("#OccLegalTel").val();  // 法人联系电话
	OccSubordination = $("#OccSubordination").val();  // 隶属关系
	
	OccEstablishment = $("#OccEstablishment").datebox("getValue");  // 建厂日期
	OccArea = $("#OccArea").val();  // 经营面积
	OccCreateDate = $("#OccCreateDate").datebox("getValue");  // 建档日期		
					
	OccTestman = $("#OccTestman").val();  // 检测联系人
	OccTestTitle = $("#OccTestTitle").val();  // 检测联系人职务
	OccTestTel = $("#OccTestTel").val();  // 检测联系人电话
	
	OccSafetyPerson = $("#OccSafetyPerson").val();  // 职业卫生安全负责人
	OccSafetyTitle = $("#OccSafetyTitle").val();  // 安全联系人职务
	OccSafetyTel = $("#OccSafetyTel").val();  // 职业卫生安全联系人电话
	
	OccWorkplace = $("#OccWorkplace").val();  // 作业场所地址
	OccZyPostalcode = $("#OccZyPostalcode").val(); // 作业场所邮政编码
	OccOrganization = $("#OccOrganization").val();  // 职业卫生管理机构
	
	// 人数
	WorkersNumber = $("#WorkersNumber").numberbox("getValue");  // 职工总人数
	ProductionNumber = $("#ProductionNumber").numberbox("getValue");  // 生产工人总数
	EndangerWorkers = $("#EndangerWorkers").numberbox("getValue");  // 接触有毒有害作业人数
	FemaleWorkers = $("#FemaleWorkers").numberbox("getValue");  // 女工数
	FemaleProduction = $("#FemaleProduction").numberbox("getValue");  // 女生产工人数
	FemaleEndanger = $("#FemaleEndanger").numberbox("getValue");  // 职工总人数
	
	var Data = OccIsSubOrg + "^" + OccUpCreditCode + "^" + OccCreditCode + "^" + OccPostalcode + "^"  // 4
			 + OccProv + "^" + OccCity + "^" + OccCounty + "^" + OccTown + "^"  // 8
			 + OccIndustry + "^" + OccEconomicType + "^" + OccEnterpriseScale + "^"  // 11
			 + OccPELinkman + "^" + OccPELinkTitle + "^" + OccPELinkTel + "^"  // 14
			 + OccRegArr + "^" + OccRegCapital + "^"  // 16
			 + OccLegalPerson + "^" + OccLegalTel + "^" + OccSubordination + "^"  // 19
			 + OccEstablishment + "^" + OccArea + "^" + OccCreateDate + "^"  // 22
			 + OccTestman + "^" + OccTestTitle + "^" + OccTestTel + "^"  // 25
			 + OccSafetyPerson + "^" + OccSafetyTitle + "^" + OccSafetyTel + "^"  // 28
			 + OccWorkplace + "^" + OccZyPostalcode + "^" + OccOrganization + "^"  // 31
			 + WorkersNumber + "^" + ProductionNumber + "^" + EndangerWorkers + "^"  // 34
			 + FemaleWorkers + "^" + FemaleProduction + "^" + FemaleEndanger  // 37
			 ;
			 
	$cm({
		ClassName:"web.DHCPE.Occu.GBaseInfo",
		MethodName:"UpdateOccuInfo",
		Id:PreGBaseInfo,
		BeL:"PreGBI",
		Type:"Set",
		DataString:Data,
		UpdUser:session["LOGON.USERID"]
	}, function(jsonData) {
		if (jsonData.code != "") {
			$.messager.alert("提示", jsonData.msg, "info");
		}
	});	 
}

function SetFileData() {
    var files = $("#Files").filebox("files");
    if (files.length == 0) {
	    $.messager.alert("提示", "请选择需要上传的文件！", "info");
        return false;
    }
    
    var formData = new FormData();
    formData.append("action", "uploadFile");
    formData.append("userID", session["LOGON.USERID"]);
    
    for (var i = 0; i < files.length; i++) {
        formData.append("Files" + i, files[i]);
    }
    
    formData.append("ClassName","web.DHCPE.DHCPEOccuBaseEx");
    formData.append("MethodName","setOccuComboByFile");
    formData.append("Type","Region");
    
	$.messager.progress({title: "提示", msg: "正在获取文件信息！", text: "请稍候..."});
			
    $.ajax({
	    url:"dhcpeuploadfile.csp",
	    data:formData,
        type: "POST",
        processData: false,
        contentType: false,
        dataType: "json",
	    success: function (data) {
		    $.messager.progress("close");
		    if (data.errInfo != "") {
			    $.messager.alert("提示", data.errInfo, "info");
		    } else {
		    	$.messager.alert("提示", "Name:" + data.Name + " Type:" + data.Type + " Size:" + data.Size, "info");
		    }
	    },
	    error: function () {
		    $.messager.progress("close");
		    $.messager.alert("提示", "断开连接或数据出错！", "info");
	    }
	});
}

function Clean() {
	$(".textbox").val("");
	$(".hisui-combobox").combobox("setValue","");
	$(".hisui-datebox").combobox("setValue","");
	$(".hisui-combotree").combotree("setValue","");
	
	$("#form-save").form("clear");
}

function InitDefVal() {
	if (PreGBaseInfo == "") {
		$.messager.alert("提示", "团体ID为空！", "info");
		return false;
	}
	
	$cm({
		ClassName:"web.DHCPE.Occu.GBaseInfo",
		MethodName:"UpdateOccuInfo",
		Id:PreGBaseInfo,
		BeL:"PreGBI",
		Type:"Get",
		DataString:"",
		UpdUser:session["LOGON.USERID"]
	},function(jsonData){
		if (jsonData.code == "0") {
			$("#OccIsSubOrg").combobox("setValue", jsonData.data.SubOrgFlag);  // 是否分支机构
			$("#OccUpCreditCode").val(jsonData.data.UpCreditCode);  // 上级单位社会信用代码
			$("#OccCreditCode").val(jsonData.data.CreditCode);  // 统一社会信用代码
			$("#OccPostalcode").val(jsonData.data.PostalCode);  // 注册邮编
			
			$("#OccProv").combobox("select", jsonData.data.Province);  // 所属省
			GetAREACombobox(jsonData.data.Province, "OccCity", jsonData.data);  // 所属市
			GetAREACombobox(jsonData.data.City, "OccCounty", jsonData.data);  // 所属区(县)
			GetAREACombobox(jsonData.data.County, "OccTown", jsonData.data);  // 所属镇(街道
			
			$("#OccIndustry").combobox("setValue", jsonData.data.IndusType);  // 行业类别
			$("#OccEconomicType").combotree("setValue", jsonData.data.Economy);  // 经济类型
			$("#OccEnterpriseScale").combobox("setValue", jsonData.data.CrptSize);  // 企业规模
			
			$("#OccPELinkman").val(jsonData.data.PELinkMan);  // 体检联系人
			$("#OccPELinkTitle").val(jsonData.data.PEPosition);  // 体检联系人职务
			$("#OccPELinkTel").val(jsonData.data.PELinkTel);  // 体检联系人电话
			
			$("#OccRegArr").val(jsonData.data.Address);  // 注册地址
			$("#OccRegCapital").val(jsonData.data.RegFund);  // 注册资金
			
			$("#OccLegalPerson").val(jsonData.data.CorporateDeputy);  // 法人代表
			$("#OccLegalTel").val(jsonData.data.CorporationTel);  // 法人联系电话
			$("#OccSubordination").val(jsonData.data.SubjeConn);  // 隶属关系
			
			$("#OccEstablishment").datebox("setValue", jsonData.data.BuildDate);  // 建厂日期
			$("#OccArea").val(jsonData.data.WorkArea);  // 经营面积
			$("#OccCreateDate").datebox("setValue",jsonData.data.FilingDate);  // 建档日期
			
			$("#OccTestman").val(jsonData.data.ChkLinkMan);  // 检测联系人
			$("#OccTestTitle").val(jsonData.data.ChkPosition);  // 检测联系人职务
			$("#OccTestTel").val(jsonData.data.ChkLinkTel);  // 检测联系人电话
			
			$("#OccSafetyPerson").val(jsonData.data.SafeLinkMan);  // 职业卫生安全负责人
			$("#OccSafetyTitle").val(jsonData.data.SafePosition);  // 安全联系人职务
			$("#OccSafetyTel").val(jsonData.data.SafeLinkTel);  // 职业卫生安全联系人电话
			
			$("#OccWorkplace").val(jsonData.data.EnrolAddress);  // 作业场所地址
			$("#OccZyPostalcode").val(jsonData.data.EnrolPostalCode); // 作业场所邮政编码
			$("#OccOrganization").val(jsonData.data.OccuManaOffice);  // 职业卫生管理机构
			
			$("#WorkersNumber").numberbox("setValue", jsonData.data.WorkForce);  // 职工总人数
			$("#ProductionNumber").numberbox("setValue", jsonData.data.WorkNum);  // 生产工人总数
			$("#EndangerWorkers").numberbox("setValue", jsonData.data.ExposureEndanges);  // 接触有毒有害作业人数
			$("#FemaleWorkers").numberbox("setValue", jsonData.data.FemaleWorkForce);  // 女工数
			$("#FemaleProduction").numberbox("setValue", jsonData.data.FemaleWorkNum);  // 女生产工人数
			$("#FemaleEndanger").numberbox("setValue", jsonData.data.FemaleExpEndanges);  // 接触有毒有害作业女人数
		}
	});
}

function GetAREACombobox(PId, Ele, cData) {
	$.cm({
		ClassName: "web.DHCPE.CT.Occu.DictionaryCode",
		MethodName: "GetOSubCodeByPId",
		pId: PId
	}, function (data) {
		var subEle = "", clrEle = [], DefValue = "";
		switch(Ele){    
		    case "OccProv": subEle = "OccCity", clrEle = ["OccCity", "OccCounty", "OccTown"], DefValue = cData.Province; break;
		    case "OccCity": subEle = "OccCounty", clrEle = ["OccCounty", "OccTown"], DefValue = cData.City; break;
		    case "OccCounty": subEle = "OccTown", clrEle = ["OccTown"], DefValue = cData.County; break;
		    case "OccTown": DefValue = cData.Town; break;
			default: subEle = "", clrEle = [], DefValue = "";
		};
		
		$HUI.combobox("#" + Ele, {
			valueField:"TId",
	        textField:"TDesc",
	        editable:true,
			panelHeight:"auto",
			data:data,
	        onBeforeLoad:function(param) {
	            var Desc = $("#" + Ele).combobox("getText");
	            param.Desc = Desc;
	        },
	        onSelect:function(record) {
				if (clrEle.length > 0) {
			        $("#" + clrEle.join(", #")).combobox("loadData", {}).combobox("clear");
			    }
			    if (subEle != "") InitComboAREA(subEle, record.TCode, record.TType);
			    //GetAREACombobox(record.TId, subEle, cData);
	        },
	        onLoadSuccess:function() {
		        if (DefValue != "" && DefValue != undefined && DefValue != "undefined") $("#" + Ele).combobox("setValue", DefValue);
	        }
		});
	});
}
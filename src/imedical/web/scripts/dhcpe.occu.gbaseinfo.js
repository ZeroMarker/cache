// dhcpe.occu.gbaseinfo.js
// dhcpe.occu.gbaseinfo.csp
// ����ְҵ����Ϣ

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
	// �Ƿ��֧����
	$HUI.combobox("#OccIsSubOrg", {
		valueField:"id",
        textField:"text",
        panelHeight:"auto",
        editable:false,
        data:[
        	{id:"Y",text:$g("��")},
        	{id:"N",text:$g("��")}
        ]
	});
	
	// ����ʡ����
	InitComboAREA("OccProv", "AREA", "BASE");
	
	// ��ҵ���
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
	
	// ��������
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
	
	// ��ҵ��ģ
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
		$.messager.alert("��ʾ", "����IDΪ�գ�", "info");
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
	
	OccIsSubOrg = $("#OccIsSubOrg").combobox("getValue");  // �Ƿ��֧����
	if (OccIsSubOrg == "") { $.messager.alert("��ʾ", "��ѡ���Ƿ��֧������", "info"); return false; }
	
	OccUpCreditCode = $("#OccUpCreditCode").val();  // �ϼ���λ������ô���
	if (OccIsSubOrg == "Y" && OccUpCreditCode == "") { $.messager.alert("��ʾ", "��֧�����������ϼ���λ������ô��룡", "info"); return false; }
	
	OccCreditCode = $("#OccCreditCode").val();  // ͳһ������ô���
	if (OccCreditCode == "") { $.messager.alert("��ʾ", "����дͳһ������ô��룡", "info"); return false; }
	
	OccPostalcode = $("#OccPostalcode").val();  // ע���ʱ�
	if (OccPostalcode == "") { $.messager.alert("��ʾ", "����дע���ʱ࣡", "info"); return false; }
	
	OccProv = $("#OccProv").combobox("getValue");  // ����ʡ
	if (OccProv == "") { $.messager.alert("��ʾ", "��ѡ������ʡ��", "info"); return false; }
	
	OccCity = $("#OccCity").combobox("getValue");  // ������
	if (OccCity == "") { $.messager.alert("��ʾ", "��ѡ�������У�", "info"); return false; }
	
	OccCounty = $("#OccCounty").combobox("getValue");  // ������(��)
	if (OccCounty == "") { $.messager.alert("��ʾ", "��ѡ��������(��)��", "info"); return false; }
	
	OccTown = $("#OccTown").combobox("getValue");  // ������(�ֵ�)
	if (OccTown == "") { $.messager.alert("��ʾ", "��ѡ��������(�ֵ�)��", "info"); return false; }
	
	OccIndustry = $("#OccIndustry").combobox("getValue");  // ��ҵ���
	if (OccIndustry == "") { $.messager.alert("��ʾ", "��ѡ����ҵ���", "info"); return false; }
	
 	OccEconomicType = $("#OccEconomicType").combotree("getValue");  // ��������
	if (OccEconomicType == "") { $.messager.alert("��ʾ", "��ѡ�񾭼����ͣ�", "info"); return false; }
	
	OccEnterpriseScale = $("#OccEnterpriseScale").combobox("getValue");  // ��ҵ��ģ
	if (OccEnterpriseScale == "") { $.messager.alert("��ʾ", "��ѡ����ҵ��ģ��", "info"); return false; }
	
	OccPELinkman = $("#OccPELinkman").val();  // �����ϵ��
	if (OccPELinkman == "") { $.messager.alert("��ʾ", "����д�����ϵ�ˣ�", "info"); return false; }
	
	OccPELinkTitle = $("#OccPELinkTitle").val();  // �����ϵ��ְ��
	
	OccPELinkTel = $("#OccPELinkTel").val();  // �����ϵ�˵绰
	if (OccPELinkTel == "") { $.messager.alert("��ʾ", "����д�����ϵ�˵绰��", "info"); return false; }
	
	OccRegArr = $("#OccRegArr").val();  // ע���ַ
	if (OccRegArr == "") { $.messager.alert("��ʾ", "����дע���ַ��", "info"); return false; }
	
	OccRegCapital = $("#OccRegCapital").val();  // ע���ʽ�
	
	OccLegalPerson = $("#OccLegalPerson").val();  // ���˴���
	OccLegalTel = $("#OccLegalTel").val();  // ������ϵ�绰
	OccSubordination = $("#OccSubordination").val();  // ������ϵ
	
	OccEstablishment = $("#OccEstablishment").datebox("getValue");  // ��������
	OccArea = $("#OccArea").val();  // ��Ӫ���
	OccCreateDate = $("#OccCreateDate").datebox("getValue");  // ��������		
					
	OccTestman = $("#OccTestman").val();  // �����ϵ��
	OccTestTitle = $("#OccTestTitle").val();  // �����ϵ��ְ��
	OccTestTel = $("#OccTestTel").val();  // �����ϵ�˵绰
	
	OccSafetyPerson = $("#OccSafetyPerson").val();  // ְҵ������ȫ������
	OccSafetyTitle = $("#OccSafetyTitle").val();  // ��ȫ��ϵ��ְ��
	OccSafetyTel = $("#OccSafetyTel").val();  // ְҵ������ȫ��ϵ�˵绰
	
	OccWorkplace = $("#OccWorkplace").val();  // ��ҵ������ַ
	OccZyPostalcode = $("#OccZyPostalcode").val(); // ��ҵ������������
	OccOrganization = $("#OccOrganization").val();  // ְҵ�����������
	
	// ����
	WorkersNumber = $("#WorkersNumber").numberbox("getValue");  // ְ��������
	ProductionNumber = $("#ProductionNumber").numberbox("getValue");  // ������������
	EndangerWorkers = $("#EndangerWorkers").numberbox("getValue");  // �Ӵ��ж��к���ҵ����
	FemaleWorkers = $("#FemaleWorkers").numberbox("getValue");  // Ů����
	FemaleProduction = $("#FemaleProduction").numberbox("getValue");  // Ů����������
	FemaleEndanger = $("#FemaleEndanger").numberbox("getValue");  // ְ��������
	
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
			$.messager.alert("��ʾ", jsonData.msg, "info");
		}
	});	 
}

function SetFileData() {
    var files = $("#Files").filebox("files");
    if (files.length == 0) {
	    $.messager.alert("��ʾ", "��ѡ����Ҫ�ϴ����ļ���", "info");
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
    
	$.messager.progress({title: "��ʾ", msg: "���ڻ�ȡ�ļ���Ϣ��", text: "���Ժ�..."});
			
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
			    $.messager.alert("��ʾ", data.errInfo, "info");
		    } else {
		    	$.messager.alert("��ʾ", "Name:" + data.Name + " Type:" + data.Type + " Size:" + data.Size, "info");
		    }
	    },
	    error: function () {
		    $.messager.progress("close");
		    $.messager.alert("��ʾ", "�Ͽ����ӻ����ݳ���", "info");
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
		$.messager.alert("��ʾ", "����IDΪ�գ�", "info");
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
			$("#OccIsSubOrg").combobox("setValue", jsonData.data.SubOrgFlag);  // �Ƿ��֧����
			$("#OccUpCreditCode").val(jsonData.data.UpCreditCode);  // �ϼ���λ������ô���
			$("#OccCreditCode").val(jsonData.data.CreditCode);  // ͳһ������ô���
			$("#OccPostalcode").val(jsonData.data.PostalCode);  // ע���ʱ�
			
			$("#OccProv").combobox("select", jsonData.data.Province);  // ����ʡ
			GetAREACombobox(jsonData.data.Province, "OccCity", jsonData.data);  // ������
			GetAREACombobox(jsonData.data.City, "OccCounty", jsonData.data);  // ������(��)
			GetAREACombobox(jsonData.data.County, "OccTown", jsonData.data);  // ������(�ֵ�
			
			$("#OccIndustry").combobox("setValue", jsonData.data.IndusType);  // ��ҵ���
			$("#OccEconomicType").combotree("setValue", jsonData.data.Economy);  // ��������
			$("#OccEnterpriseScale").combobox("setValue", jsonData.data.CrptSize);  // ��ҵ��ģ
			
			$("#OccPELinkman").val(jsonData.data.PELinkMan);  // �����ϵ��
			$("#OccPELinkTitle").val(jsonData.data.PEPosition);  // �����ϵ��ְ��
			$("#OccPELinkTel").val(jsonData.data.PELinkTel);  // �����ϵ�˵绰
			
			$("#OccRegArr").val(jsonData.data.Address);  // ע���ַ
			$("#OccRegCapital").val(jsonData.data.RegFund);  // ע���ʽ�
			
			$("#OccLegalPerson").val(jsonData.data.CorporateDeputy);  // ���˴���
			$("#OccLegalTel").val(jsonData.data.CorporationTel);  // ������ϵ�绰
			$("#OccSubordination").val(jsonData.data.SubjeConn);  // ������ϵ
			
			$("#OccEstablishment").datebox("setValue", jsonData.data.BuildDate);  // ��������
			$("#OccArea").val(jsonData.data.WorkArea);  // ��Ӫ���
			$("#OccCreateDate").datebox("setValue",jsonData.data.FilingDate);  // ��������
			
			$("#OccTestman").val(jsonData.data.ChkLinkMan);  // �����ϵ��
			$("#OccTestTitle").val(jsonData.data.ChkPosition);  // �����ϵ��ְ��
			$("#OccTestTel").val(jsonData.data.ChkLinkTel);  // �����ϵ�˵绰
			
			$("#OccSafetyPerson").val(jsonData.data.SafeLinkMan);  // ְҵ������ȫ������
			$("#OccSafetyTitle").val(jsonData.data.SafePosition);  // ��ȫ��ϵ��ְ��
			$("#OccSafetyTel").val(jsonData.data.SafeLinkTel);  // ְҵ������ȫ��ϵ�˵绰
			
			$("#OccWorkplace").val(jsonData.data.EnrolAddress);  // ��ҵ������ַ
			$("#OccZyPostalcode").val(jsonData.data.EnrolPostalCode); // ��ҵ������������
			$("#OccOrganization").val(jsonData.data.OccuManaOffice);  // ְҵ�����������
			
			$("#WorkersNumber").numberbox("setValue", jsonData.data.WorkForce);  // ְ��������
			$("#ProductionNumber").numberbox("setValue", jsonData.data.WorkNum);  // ������������
			$("#EndangerWorkers").numberbox("setValue", jsonData.data.ExposureEndanges);  // �Ӵ��ж��к���ҵ����
			$("#FemaleWorkers").numberbox("setValue", jsonData.data.FemaleWorkForce);  // Ů����
			$("#FemaleProduction").numberbox("setValue", jsonData.data.FemaleWorkNum);  // Ů����������
			$("#FemaleEndanger").numberbox("setValue", jsonData.data.FemaleExpEndanges);  // �Ӵ��ж��к���ҵŮ����
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
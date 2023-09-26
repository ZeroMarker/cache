var PageLogicObj = {
	m_FindPatListTabDataGrid: "",
	dw: $(window).width() - 400,
	dh: $(window).height() - 100,
	m_SessionStr: "^" + session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + "^" + session['LOGON.SITECODE'] + "^",
	m_SelectCardTypeRowID: "",
	m_OverWriteFlag: "",
	m_CardCost: "",
	m_CCMRowID: "",
	m_SetFocusElement: "",
	m_CardNoLength: "",
	m_SetRCardFocusElement: "",
	m_SetCardRefFocusElement: "",
	m_SetCardReferFlag: "",
	m_CardINVPrtXMLName: "",
	m_PatPageXMLName: "",
	m_CardTypePrefixNo: "",
	m_UsePANoToCardNO: "",
	m_RegCardConfigXmlData: "",
	m_PAPMINOLength: 10,
	m_PatMasFlag: "",
	m_CardRefFlag: "",
	m_AccManagerFlag: "",
	m_CardSecrityNo: "",
	m_MedicalFlag: 0, //��������ʶ
	m_CurSearchValue: "",
	m_tmformat: 'HMS',
	m_IDCredTypePlate: "01", //���֤�����ֶ�
	m_CardValidateCode: "",
	m_CardVerify: "",
	m_ModifiedFlag: "",
	m_ReceiptsType: "",
	m_IsNotStructAddress: "",
	m_CredTypeDef: "",
	m_TransferCardFlag: 0,
	//�ѻ�
	m_MarriedIDStr: "22^23^24^25^26^27",
	//�ѻ������������(Ů)
	m_MarriedLimitFemaleFAge: 18,
	//�ѻ������������(��)
	m_MarriedLimitMaleAge: 18,
	m_PrtXMLName: "UDHCAccDeposit",
	JumpAry: ["CardNo", "Name", "Sex", "CredNo", "PatType", "TelHome"],
	m_CardRegMustFillInArr: [],
	m_CardRegJumpSeqArr: [],
	m_CTDTemporaryCardFlag: ""
}
$(function () {
	//��ʼ��
	//Init();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	//setTimeout(function (){
	PageHandle();
	//},50)
})
$(window).load(function () {
	if (ServerObj.CardRefgDOMCache == "") {
		SaveCahce();
	}
	InitOtherCom();
	setTimeout(function () {
		ExtendComboxEvent();
		LoadPatInfoByRegNo();
	})
	Init();
	//DHCP_GetXMLConfig("DepositPrintEncrypt","UDHCAccDeposit"
	$("#ComputerIP").val(ClientIPAddress);
	$(window).resize(function () {
		$("#FindPatListTab").datagrid("getPanel").panel('resize', {
			width: $(window).width(),
			height: $(window).width() - 460
		});

	});
});
function Init() {
	PageLogicObj.m_FindPatListTabDataGrid = InitFindPatListTabDataGrid();
}
function InitEvent() {
	$("#PAPMINo").blur(PAPMINoOnblur);
	$("#PAPMINo").keydown(PAPMINoOnKeyDown);
	$("#InMedicare").blur(InMedicareOnBlur);
	$("#OpMedicare").blur(OpMedicareOnblur);
	$("#OpMedicare").keydown(OpMedicareOnKeyDown);
	$("#Birth").blur(BirthOnBlur);
	$("#BirthTime").blur(BirthTimeOnBlur);
	$("#Name").blur(SearchSamePatient);
	$("#TelHome").blur(SearchSamePatient);
	$("#PatYBCode").blur(SearchSamePatient);
	$("#Age").keypress(AgeOnKeypress);
	$("#Age").blur(AgeOnBlur);
	$("#CredNo").change(CredNoOnChange);
	//$("#CredNo").keypress(CredNoOnKeyPress);
	$("#CredNo").blur(SearchSamePatient);
	$("#Clear").click(Clearclick);
	$("#TransferCard").click(TransferCardClick)
	$("#BReadCard").click(ReadCardClickHandle);
	$("#ReadRegInfo").click(ReadRegInfoOnClick);
	$("#NewCard").click(NewCardclick);
	$("#BModifyInfo").click(BModifyInfoclick);
	//$("#PatPaySum").keypress(PatPaySumKeyPress);
	//�ϲ���
	$("#CardUnite").click(CardUniteClick);
	//��ӡ����
	$("#prt").click(prtClick);
	$("#CardSearch").click(CardSearchClick);
	$("#BOtherCredType").click(OtherCredTypeInput);
	$("#BAddressInoCollaps").click(BAddressInoCollapsClick);
	$("#BPayInoCollaps").click(BPayInoCollapsClick);
	$("#BBaseInoCollaps").click(BBaseInoCollapsClick);
	document.onkeydown = Doc_OnKeyDown;
}
function PageHandle() {
	//������
	LoadCardType();
	//֤�����͡���ϵ��֤������
	LoadCredType();
	//LoadForeignCredType();

	//��������
	LoadPatType();

	//���˼���
	//LoadPoliticalLevel();
	//�����ܼ�
	//LoadSecretLevel();
	//��ͬ��λ
	//LoadHCPDR();
	//����
	LoadCTNation();
	//��ϵ
	//LoadCTRelation();
	//ְҵ
	//LoadVocation();
	//�Ա�
	LoadSex();
	//��Ժ��Դ
	LoadIpSource();
	//����
	LoadCountry();
	//����(����LoadPayMode֮ǰ)
	LoadBank();
	//���п�����(����LoadPayMode֮ǰ)
	LoadBankCardType();
	//�豸����
	LoadIEType();
	IntDoc();
	setTimeout(function () {
		//֧����ʽ
		LoadPayMode();
		InitPatRegConfig();
		setTimeout(function () {
			for (var i = 0; i < PageLogicObj.m_CardRegMustFillInArr.length; i++) {
				var id = PageLogicObj.m_CardRegMustFillInArr[i]['id'];
				if (!id) continue;
				$("label[for=" + id + "]").addClass("clsRequired");
			}
		}, 50)
	}, 50);

	if (PageLogicObj.m_UsePANoToCardNO != "Y") {
		DisableBtn("NewCard", true);
	}
}
function InitOtherCom() {
	//����
	LoadMarital();
	//���˼���
	LoadPoliticalLevel();
	//�����ܼ�
	LoadSecretLevel();
	//��ͬ��λ
	LoadHCPDR();
	//��ϵ
	LoadCTRelation();
	//ְҵ
	LoadVocation();
	//��ϵ��ְҵ
	LoadForeignVocation()
	//��ϵ���Ա�
	LoadForeignSex();
}
function LoadCardType() {
	$("#CardTypeDefine").combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultCardTypePara),
		onSelect: function (rec) {
			CardTypeKeydownHandler();
		}
	})
	CardTypeKeydownHandler();
}
function LoadCredType() {
	var CredTypeData = JSON.parse(ServerObj.DefaultCredTypePara);
	$("#CredType,#ForeignCredType").combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		blurValidValue: true,
		data: CredTypeData
	})
	for (var i = 0; i < CredTypeData.length; i++) {
		if (CredTypeData[i]['selected'] == true) {
			PageLogicObj.m_CredTypeDef = CredTypeData[i]['id'];
			break;
		}
	}
}
/*function LoadForeignCredType(){
	$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadCredTypeExp",
		JSFunName:"GetCredTypeToHUIJson",
		ListName:""
	},function(Data){
		var cbox = $HUI.combobox("#ForeignCredType", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				data: JSON.parse(Data)
		 });
	});
}*/
function LoadPatType() {
	$("#PatType").combobox({
		width: 115,
		valueField: 'id',
		textField: 'text',
		//editable:false,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultPatTypePara),
		filter: function (q, row) {
			if (q == "") return true;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			var find = 0;
			if ((row["AliasStr"]) && (row["AliasStr"] != "")) {
				for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
					if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
						find = 1;
						break;
					}
				}
			}
			if (find == 1) return true;
			return false;
		},
		onSelect: function (rec) {
			PatTypeOnChange();
		}
	})
}
function LoadMarital() {
	$("#PAPERMarital").combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultMaritalPara)
	})
}
function LoadPoliticalLevel() {
	$("#PoliticalLevel").combobox({
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultPoliticalLevPara)
	})
}
function LoadSecretLevel() {
	$("#SecretLevel").combobox({
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultSecretLevelPara)
	})
}
function LoadHCPDR() {
	$("#HCPDR").combobox({
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultHCPDRPara)
	})
}
function LoadCTNation() {
	var cbox = $HUI.combobox("#NationDescLookUpRowID", {
		width: 115,
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultNationPara),
		filter: function (q, row) {
			if (q == "") return true;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			var find = 0;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		}
	});
}
function LoadCTRelation() {
	$("#CTRelationDR").combobox({
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultRelationPara)
	});
}
function LoadVocation() {
	$("#Vocation").combobox({
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultOccuptionPara),
		filter: function (q, row) {
			if (q == "") return true;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			var find = 0;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		}
	});
}
function LoadForeignVocation() {
	$("#PAPMIName8").combobox({
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultOccuptionPara),
		filter: function (q, row) {
			if (q == "") return true;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			var find = 0;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		}
	});
}
function LoadSex() {
	$HUI.combobox("#Sex", {
		width: 115,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultSexPara),
		filter: function (q, row) {
			if (q == "") return true;
			var find = 0;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		},
		onSelect: function (rec) {
			SearchSamePatient();
		}
	})

}
function LoadIpSource() {
	$HUI.combobox("#IpSourcePrim", {
		//width: 115,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultIpSourcePara),
		filter: function (q, row) {
			if (q == "") return true;
			var find = 0;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		},
		onSelect: function (rec) {
			SearchSamePatient();
		}
	})
	console.log(ServerObj.DefaultIpSourcePara);

}
function LoadForeignSex() {
	$HUI.combobox("#PAPMIName7", {
		//width: 115,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultSexPara),
		filter: function (q, row) {
			if (q == "") return true;
			var find = 0;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		},
		onSelect: function (rec) {
			SearchSamePatient();
		}
	})

}
function LoadCountry() {
	var cbox = $HUI.combobox("#CountryDescLookUpRowID,#CountryHome,#CountryBirth,#CountryHouse", {
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: false,
		//data: JSON.parse(ServerObj.DefaultCTCountryPara),
		filter: function (q, row) {
			if (q == "") return true;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			var find = 0;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		},
		onSelect: function (rec) {
			if (rec) {
				var id = rec.id //$(this).combobox("getValue");
				var Item = $(this)[0].id;
				var tt = Item;
				CountrySelect(Item, id);
			}
		}, onChange: function (newValue, oldValue) {
			if (newValue == "") {
				var item = $(this)[0].id;

				if (item == "CountryHome") {
					var provinceId = "ProvinceHome";
				} else if (item == "CountryBirth") {
					var provinceId = "ProvinceBirth";
				} else if (item == "CountryHouse") {
					var provinceId = "ProvinceInfoLookUpRowID"; //ʡ��ס
				} else if (item == "CountryDescLookUpRowID") {
					var provinceId = "ProvinceHouse"
				}
				$("#" + provinceId).combobox('select', '');
				(function (item) {
					setTimeout(function () {
						$("#" + item).combobox('setValue', "").combobox('setText', "");
						$($("#" + item).combobox('panel')[0].childNodes).removeClass("combobox-item-selected")
					})
				})(item)
			}
		},
		onShowPanel: function () {
			var item = $(this)[0].id;
			LoadCountryData(item);
		}
	});
	$HUI.combobox($("#ProvinceHome,#CityHome,#ProvinceBirth,#CityBirth,#AreaBirth,#ProvinceInfoLookUpRowID,#CityDescLookUpRowID,#CityAreaLookUpRowID,#Cityhouse,#AreaHouse"), { width: 110 });
	$HUI.combobox($("#ProvinceHouse"), {});
}
function LoadCountryData(id) {
	if (typeof id != "undefined") {
		var text = $("#" + id).combobox("getText");
		var data = $("#" + id).combobox("getData");
		$("#" + id).combobox("loadData", JSON.parse(ServerObj.DefaultCTCountryPara)).combobox("setText", text);
	}
}
function CountrySelect(id, value) {
	if (id == "CountryHome") {
		$("#CityHome").combobox("loadData", []).combobox('setValue', "");
		//$("#CityHome").combobox('select',"");
	} else if (id == "CountryBirth") {
		$("#CityBirth,#AreaBirth").combobox("loadData", []).combobox('setValue', "");
	} else if (id == "CountryHouse") {
		$("#CityDescLookUpRowID,#CityAreaLookUpRowID").combobox("loadData", []).combobox('setValue', "");
	} else if (id == "CountryDescLookUpRowID") {
		$("#Cityhouse,#AreaHouse").combobox("loadData", []).combobox('setValue', "");
	}
	LoadProvince(id, value);

}
function LoadPayMode() {
	$("#PayMode").combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultPaymodePara),
		onSelect: function (rec) {
			PayModeOnChange();
		},
		onLoadSuccess: function () {
			var Data = $(this).combobox("getData");
			if (Data.length > 0) {
				$(this).combobox("select", Data[0]["id"]);
				PayModeOnChange();
			}
		}
	});
}
function LoadBank() {
	$("#Bank").combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultBankPara)
	});
}
function LoadBankCardType() {
	$("#BankCardType").combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultBankCardTypePara)
	});
}
function LoadIEType() {
	$("#IEType").combobox({
		valueField: 'HGRowID',
		textField: 'HGDesc',
		editable: false,
		blurValidValue: true,
		data: JSON.parse(ServerObj.DefaultIETypePara),
		onLoadSuccess: function () {
			var Data = $(this).combobox("getData");
			if (Data.length > 0) {
				$(this).combobox("select", Data[0]["HGRowID"]);
			}
		}
	});
}
function LoadProvince(item, CountryId) {
	if (item == "CountryHome") {
		var provinceId = "ProvinceHome";
	} else if (item == "CountryBirth") {
		var provinceId = "ProvinceBirth";
	} else if (item == "CountryHouse") {
		var provinceId = "ProvinceInfoLookUpRowID"; //ʡ��ס
	} else if (item == "CountryDescLookUpRowID") {
		var provinceId = "ProvinceHouse"
	}
	if ((ServerObj.defaultCountryDr == CountryId) && (ServerObj.DefaultCTProvince != "")) {
		var Data = ServerObj.DefaultCTProvince
	} else {
		var Data = $.m({
			ClassName: "web.DHCBL.CTBASEIF.ICTCardRegLB",
			MethodName: "ReadBaseData",
			dataType: "text",
			TabName: "CTProvince",
			QueryInfo: CountryId + "^^^HUIJSON^" + provinceId
		}, false);
	}
	var cbox = $HUI.combobox("#" + provinceId, {
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(Data),
		filter: function (q, row) {
			if (q == "") return true;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			var find = 0;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		},
		onSelect: function (rec) {
			if (rec) {
				//��������Ϣ
				var id = rec.id; //$(this).combobox("getValue");
				var item = $(this)[0].id;
				if (item == "ProvinceHome") {

				} else if (item == "ProvinceBirth") {
					$("#AreaBirth").combobox("loadData", []);
					$("#AreaBirth").combobox('select', "");

				} else if (item == "ProvinceInfoLookUpRowID") {
					$("#CityAreaLookUpRowID").combobox("loadData", []);
					$("#CityAreaLookUpRowID").combobox('select', "");

				} else if (item == "ProvinceHouse") { //����
					$("#AreaHouse").combobox("loadData", []);
					$("#AreaHouse").combobox('select', "");
				}
				LoadCity($(this)[0].id, id);
			}
		}, onChange: function (newValue, oldValue) {
			if (newValue == "") {
				var item = $(this)[0].id;
				if (item == "ProvinceHome") {
					var cityId = "CityHome";
				} else if (item == "ProvinceBirth") {
					var cityId = "CityBirth";
				} else if (item == "ProvinceInfoLookUpRowID") {
					var cityId = "CityDescLookUpRowID";
				} else if (item == "ProvinceHouse") { //����
					var cityId = "Cityhouse"
				}
				$("#" + cityId).combobox('select', '');
			}
		}
	});
	var id = $("#" + provinceId).combobox("getValue");
	if (id != "") {
		LoadCity(provinceId, id);
	}
}
function LoadCity(item, ProvinceId) {
	if (item == "ProvinceHome") {
		var cityId = "CityHome";
	} else if (item == "ProvinceBirth") {
		var cityId = "CityBirth";
	} else if (item == "ProvinceInfoLookUpRowID") {
		var cityId = "CityDescLookUpRowID";
	} else if (item == "ProvinceHouse") { //����
		var cityId = "Cityhouse"
	}
	var Data = $.m({
		ClassName: "web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName: "ReadBaseData",
		dataType: "text",
		TabName: "CTCITY",
		QueryInfo: ProvinceId + "^^^HUIJSON"
	}, false);
	var cbox = $HUI.combobox("#" + cityId, {
		width: 110,
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(Data),
		filter: function (q, row) {
			if (q == "") return true;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			var find = 0;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		},
		onSelect: function (rec) {
			if (rec != undefined) {
				//��������Ϣ
				var id = rec.id; //$(this).combobox("getValue");
				LoadArea($(this)[0].id, id);
			}
		}, onChange: function (newValue, oldValue) {
			if (newValue == "") {
				var item = $(this)[0].id;
				if (item == "CityHome") {
					var areaId = "";
				} else if (item == "CityBirth") {
					var areaId = "AreaBirth";
				} else if (item == "CityDescLookUpRowID") {
					var areaId = "CityAreaLookUpRowID";
				} else if (item == "Cityhouse") {
					var areaId = "AreaHouse"
				}
				if (areaId != "") {
					$("#" + areaId).combobox('select', '');
				}
			}
		}
	});
	var id = $("#" + cityId).combobox("getValue");
	if (id != "") {
		LoadArea(cityId, id);
	}
}
function LoadArea(item, cityId) {
	if (item == "CityHome") {
		var areaId = "";
	} else if (item == "CityBirth") {
		var areaId = "AreaBirth";
	} else if (item == "CityDescLookUpRowID") {
		var areaId = "CityAreaLookUpRowID";
	} else if (item == "Cityhouse") {
		var areaId = "AreaHouse"
	}
	var Data = $.m({
		ClassName: "web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName: "ReadBaseData",
		dataType: "text",
		TabName: "CTCITYAREA",
		QueryInfo: cityId + "^^^HUIJSON"
	}, false);
	var cbox = $HUI.combobox("#" + areaId, {
		width: 110,
		valueField: 'id',
		textField: 'text',
		editable: true,
		blurValidValue: true,
		data: JSON.parse(Data),
		filter: function (q, row) {
			if (q == "") return true;
			if (row["text"].indexOf(q.toUpperCase()) >= 0) return true;
			var find = 0;
			for (var i = 0; i < row["AliasStr"].split("^").length; i++) {
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0) {
					find = 1;
					break;
				}
			}
			if (find == 1) return true;
			return false;
		}
	});
}
function CardTypeKeydownHandler() {
	var myoptval = $("#CardTypeDefine").combobox("getValue");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	if (myCardTypeDR == "") {
		return;
	}
	PageLogicObj.m_SelectCardTypeRowID = myCardTypeDR;
	PageLogicObj.m_OverWriteFlag = myary[23];
	$("#CardFareCost,#ReceiptNO,#CardNo").val("");
	if (ServerObj.defCardDr == myCardTypeDR) {
		var m_RegCardConfigXmlData = $("#RegCardConfigXmlData").val()
	} else {
		var m_RegCardConfigXmlData = $.m({
			ClassName: "web.DHCBL.CARD.UCardPATRegConfig",
			MethodName: "ReadDefaultCardTypeConfigByDR",
			CardTypeDR: PageLogicObj.m_SelectCardTypeRowID,
			SessionStr: ""
		}, false);
	}
	PageLogicObj.m_RegCardConfigXmlData = m_RegCardConfigXmlData;
	PageLogicObj.m_CardCost = 0;
	if (myary[3] == "C") {
		$("#CardFareCost").val(myary[6]);
		PageLogicObj.m_CardCost = myary[6];
		GetReceiptNo();
	}
	if (myary[16] == "Handle") {
		$("#CardNo").attr("disabled", false);
		DisableBtn("BReadCard", true);
		$("#CardNo").focus();
	} else {
		$("#CardNo").attr("disabled", true);
		DisableBtn("BReadCard", false);
		$("#BReadCard").focus();
	}
	PageLogicObj.m_CCMRowID = myary[14];
	PageLogicObj.m_SetFocusElement = myary[13];
	if (PageLogicObj.m_SetFocusElement != "") {
		$("#" + PageLogicObj.m_SetFocusElement).focus();
	}
	PageLogicObj.m_CardNoLength = myary[17];
	PageLogicObj.m_SetRCardFocusElement = myary[20];
	PageLogicObj.m_SetCardRefFocusElement = myary[22];
	PageLogicObj.m_SetCardReferFlag = myary[21];
	var myobj = document.getElementById("PAPMINo");
	if (PageLogicObj.m_SetCardReferFlag == "Y") {
		//myobj.onkeydown = PAPMINoOnKeyDown;
		//myobj.readOnly=false;
		$('#PAPMINo').removeAttr("disabled");
	} else {
		myobj.onclick = function () { return false; }
		//myobj.readOnly=true;
		$('#PAPMINo').val('').attr("disabled", true);
	}
	PageLogicObj.m_CardINVPrtXMLName = myary[25];
	PageLogicObj.m_PatPageXMLName = myary[26];
	PageLogicObj.m_CardTypePrefixNo = myary[29];
	//����ʹ�õǼǺ���Ϊ����
	if (myary.length >= 37) {
		PageLogicObj.m_UsePANoToCardNO = myary[36];
	}
	if (PageLogicObj.m_UsePANoToCardNO == "Y") {
		DisableBtn("BReadCard", true);
		$("#CardNo").attr("disabled", true);
		DisableBtn("NewCard", false);
		PageLogicObj.m_CardNoLength = 0;
		$('#Name').focus();
	}
	PageLogicObj.m_CTDTemporaryCardFlag = myary[38];
	//��ʼ����ʱ�����
	InitTemporaryCard($("#CardNo").val());
}
function ReadCardClickHandle() {
	if ($("#BReadCard").hasClass('l-btn-disabled')) {
		return false;
	}
	var myVersion = ServerObj.ConfigVersion;
	if (myVersion == "12") {
		M1Card_InitPassWord();
	}
	var rtn = DHCACC_ReadMagCard(PageLogicObj.m_CCMRowID, "R", "23");
	var myary = rtn.split("^");
	if (myary[0] == '0') {
		$("#CardNo").val(myary[1]);
		PageLogicObj.m_CardVerify = myary[2];
		PageLogicObj.m_CardValidateCode = myary[2];
		PageLogicObj.m_CardSecrityNo = myary[2];
		GetValidatePatbyCard();
	}
}
function M1Card_InitPassWord() {
	try {
		var myobj = document.getElementById("ClsM1Card");
		if (myobj == null) return;
		var rtn = myobj.M1Card_Init();
	} catch (e) {
	}
}
function GetReceiptNo() {
	var myPINVFlag = "Y";
	var myExpStr = session['LOGON.USERID'] + "^" + myPINVFlag;
	if (cspRunServerMethod(ServerObj.GetreceipNO, 'SetReceipNO', session['LOGON.USERID'], PageLogicObj.m_SelectCardTypeRowID, myExpStr) != '0') {
		$.messager.alert("��ʾ", t['InvalidReceiptNo']);
		return false;
	}
}
function SetReceipNO(value) {
	var myary = value.split("^");
	var ls_ReceipNo = myary[0];
	$('#ReceiptNO').val(ls_ReceipNo);
	//�������С����С��ʾ��change the Txt Color
	if (myary[1] != "0") {
		$("#ReceiptNO").addClass("newclsInvalid");
	}
}
function PAPMINoOnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$("#PAPMINo").unbind("blur");
		SetPAPMINoLenth();
		GetPatDetailByPAPMINo();
		setTimeout(function () {
			$("#PAPMINo").blur(PAPMINoOnblur);
		});
		return false;
	}
}
function PAPMINoOnblur() {
	SetPAPMINoLenth();
	GetPatDetailByPAPMINo();
}
function OpMedicareOnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$("#OpMedicare").unbind("blur");
		SetOpMedicareLenth();
		GetPatDetailByOpMedicare();
		setTimeout(function () {
			$("#OpMedicare").blur(OpMedicareOnblur);
		});
		return false;
	}
}
function OpMedicareOnblur() {
	SetOpMedicareLenth();
	GetPatDetailByOpMedicare();
}
function InMedicareOnBlur() {
	var myInMedicare = $("#InMedicare").val();
	if (myInMedicare.split('M').length > 1) {
		$("#InMedicare").val(myInMedicare.split('M')[0]);
	}
	SearchSamePatient();
}
function BirthOnBlur() {
	///������ʱ���ڴ���
	//var Obj=GetEventElementObj()
	//if (Obj.name=="Clear"){return websys_cancel();}
	var mybirth = $("#Birth").val();
	if ((mybirth != "") && ((mybirth.length != 8) && ((mybirth.length != 10)))) {
		$.messager.alert("��ʾ", "��������ȷ�ĳ�������!", "info", function () {
			$("#Birth").addClass("newclsInvalid");
			$("#Birth").focus();
		});
		return false;
	}
	$("#Birth").removeClass("newclsInvalid");
	if ((mybirth.length == 8)) {
		if (ServerObj.dtformat == "YMD") {
			var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8)
		}
		if (ServerObj.dtformat == "DMY") {
			var mybirth = mybirth.substring(6, 8) + "/" + mybirth.substring(4, 6) + "/" + mybirth.substring(0, 4)
		}
		$("#Birth").val(mybirth);
	}
	if (mybirth != "") {
		if (ServerObj.dtformat == "YMD") {
			var reg = /^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
		}
		if (ServerObj.dtformat == "DMY") {
			var reg = /^(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
		}
		var ret = mybirth.match(reg);
		if (ret == null) {
			$.messager.alert("��ʾ", "��������ȷ�ĳ�������!", "info", function () {
				$("#Birth").addClass("newclsInvalid");
				$("#Birth").focus();
			});
			return false;
		}
		if (ServerObj.dtformat == "YMD") {
			var myrtn = DHCWeb_IsDate(mybirth, "-")
		}
		if (ServerObj.dtformat == "DMY") {
			var myrtn = DHCWeb_IsDate(mybirth, "/")
		}
		if (!myrtn) {
			$.messager.alert("��ʾ", "��������ȷ�ĳ�������!", "info", function () {
				$("#Birth").addClass("newclsInvalid");
				$("#Birth").focus();
			});
			return false;
		} else {
			var mybirth1 = $("#Birth").val();
			var Checkrtn = CheckBirth(mybirth1);
			if (Checkrtn == false) {
				$.messager.alert("��ʾ", "�������ڲ��ܴ��ڽ������С�ڡ�����1840��!", "info", function () {
					$("#Birth").addClass("newclsInvalid");
					$("#Birth").focus();
				});
				return false;
			}
			var myAge = DHCWeb_GetAgeFromBirthDay("Birth");
			$("#Age").val(myAge);
		}
	} else {
		$("#Birth").removeClass("newclsInvalid");
	}
	SearchSamePatient();
}
function BirthTimeOnBlur() {
	var mybirthTime = $("#BirthTime").val();
	if (mybirthTime == "") return false;
	var eSrc = document.getElementById('BirthTime')
	if (!IsValidTime(eSrc)) {
		$.messager.alert("��ʾ", "��������ȷ�ĳ���ʱ��!", "info", function () {
			$("#BirthTime").addClass("newclsInvalid");
			$("#BirthTime").focus();
		});
		return false;
	}
	var mybirth = $("#Birth").val();
	if (mybirth == "") return false;
	var myage = $("#Age").val();
	var mybirthTime = $("#BirthTime").val();
	$.cm({
		ClassName: "web.UDHCJFCOMMON",
		MethodName: "DispPatAge",
		dataType: "text",
		birthDate: mybirth, admDate: "", birthTime: mybirthTime, admTime: "", controlFlag: "N",
		hospId: session['LOGON.HOSPID']
	}, function (ageStr) {
		var ageStr = ageStr.split("||")[0]
		$("#Age").val(ageStr);
	});
	$("#BirthTime").removeClass("newclsInvalid");
}
function AgeOnKeypress() {
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
	if (keycode == 45) { window.event.keyCode = 0; return websys_cancel(); }
	//����"." �����������
	if (keycode == 46) { window.event.keyCode = 0; return websys_cancel(); }
	if (((keycode > 47) && (keycode < 58)) || (keycode == 46)) {
	} else {
		window.event.keyCode = 0; return websys_cancel();
	}
}
function setBirthAndSex(mypId) {
	var myary = DHCWeb_GetInfoFromId(mypId);
	if (myary[0] == "1") {
		var myBirth = $("#Birth").val();
		$("#Birth").val(myary[2]);
		$("#Age").val(myary[4]);
		var mySexDR = "";
		switch (myary[3]) {
			case "��":
				mySexDR = "1";
				break;
			case "Ů":
				mySexDR = "2";
				break;
			default:
				mySexDR = "4";
				break;
		}
		$("#Sex").combobox("select", mySexDR);
	} else {
		$("#CredNo").focus();
		return false;
	}
}
function AgeOnBlur() {
	var myrtn = IsCredTypeID();
	var mypId = $("#CredNo").val();
	if ((myrtn) && (mypId != "")) {
		var Birth = $("#Birth").val();
		if (Birth == "") {
			setBirthAndSex(mypId);
		}
		return;
	};
	var myage = $("#Age").val();
	if (((myage.indexOf("��") != -1) || (!isNaN(myage))) && (myage != "")) {
		if (parseInt(myage) >= parseInt(ServerObj.LimitAge)) {
			$.messager.alert("��ʾ", "���䲻�ܳ���" + LimitAge + "��", "info", function () {
				$("#Birth").focus();
				$("#Birth").val("");
			});
			return false;
		}
	}
	var myBirth = $("#Birth").val();
	if ((myBirth == "") || (myBirth == undefined)) {
		$.cm({
			ClassName: "web.DHCDocCommon",
			MethodName: "GetBirthDateByAge",
			dataType: "text",
			Age: myage, Type: ""
		}, function (rtn) {
			$("#Birth").val(rtn);
		});
	}
}
function SetPAPMINoLenth() {
	var PAPMINo = $("#PAPMINo").val();
	if (PAPMINo != '') {
		if ((PAPMINo.length < PageLogicObj.m_PAPMINOLength) && (PageLogicObj.m_PAPMINOLength != 0)) {
			for (var i = (PageLogicObj.m_PAPMINOLength - PAPMINo.length - 1); i >= 0; i--) {
				PAPMINo = "0" + PAPMINo;
			}
		}
		$("#PAPMINo").val(PAPMINo);
	}
}
function GetPatDetailByPAPMINo() {
	$("#PAPMINo").removeClass("newclsInvalid");
	var myPAPMINo = $('#PAPMINo').val();
	if (myPAPMINo != "") {
		var myPatInfo = $.cm({
			ClassName: "web.DHCBL.CARD.UCardPaPatMasInfo",
			MethodName: "GetPatInfoByPANo",
			dataType: "text",
			PAPMINo: myPAPMINo,
			ExpStr: ""
		}, false);
		var myary = myPatInfo.split("^");
		if (myary[0] == "0") {
			//�����ҳ����Ϣ,��Ӧ�������ƥ���XML��ȡ:##class(web.DHCBL.UDHCUIDefConfig).ReadCardPatUDIef
			InitPatRegConfig();
			var myXMLStr = myary[1];
			var PAPMIXMLStr = GetRegMedicalEPMI("", myPAPMINo);
			if (PAPMIXMLStr != "") myXMLStr = PAPMIXMLStr;
			SetPatInfoByXML(myXMLStr);
			if (PageLogicObj.m_SetCardRefFocusElement != "") {
				$("#" + PageLogicObj.m_SetCardRefFocusElement).focus();
			}
			//����ͼƬbase64Ӧ��
			var PhotoInfo = $("#PhotoInfo").val();
			if (PhotoInfo != "") {
				var src = "data:image/png;base64," + PhotoInfo;
			} else {
				var src = "../images/uiimages/patdefault.png";
			}
			ShowPicBySrcNew(src, "imgPic");
			var PAPMIDR = $('#PAPMIRowID').val();
			return true;
		} else if (myary[0] == "2001") {
			$.messager.alert("��ʾ", "�޴˵ǼǺŵĻ���!");
		} else if (myary[0] == "-353") {
			$.messager.alert("��ʾ", "�˵ǼǺŲ����ظ������˻�!");
		} else {
			$.messager.alert("��ʾ", "Error Code: " + myary[0]);
		}
		$("#PAPMINo").addClass("newclsInvalid");
		return false;
	}
}
function SetOpMedicareLenth() {
	var PAPMINo = $("#OpMedicare").val();
	if (PAPMINo != '') {
		if ((PAPMINo.length < PageLogicObj.m_PAPMINOLength) && (PageLogicObj.m_PAPMINOLength != 0)) {
			for (var i = (PageLogicObj.m_PAPMINOLength - PAPMINo.length - 1); i >= 0; i--) {
				PAPMINo = "0" + PAPMINo;
			}
		}
		$("#OpMedicare").val(PAPMINo);
	}
}
function GetPatDetailByOpMedicare() {
	$("#OpMedicare").removeClass("newclsInvalid");
	var myPAPMINo = $('#OpMedicare').val();
	if (myPAPMINo != "") {
		var myPatInfo = $.cm({
			ClassName: "web.DHCBL.CARD.UCardPaPatMasInfo",
			MethodName: "GetPatInfoByPANo",
			dataType: "text",
			PAPMINo: myPAPMINo,
			ExpStr: ""
		}, false);
		var myary = myPatInfo.split("^");
		if (myary[0] == "0") {
			//�����ҳ����Ϣ,��Ӧ�������ƥ���XML��ȡ:##class(web.DHCBL.UDHCUIDefConfig).ReadCardPatUDIef
			var OpMedicare = $("#OpMedicare").val();
			InitPatRegConfig();
			var myXMLStr = myary[1];
			var PAPMIXMLStr = GetRegMedicalEPMI("", myPAPMINo);
			if (PAPMIXMLStr != "") myXMLStr = PAPMIXMLStr;
			SetPatInfoByXML(myXMLStr);
			if (PageLogicObj.m_SetCardRefFocusElement != "") {
				$("#" + PageLogicObj.m_SetCardRefFocusElement).focus();
			}
			//����ͼƬbase64Ӧ��
			var PhotoInfo = $("#PhotoInfo").val();
			if (PhotoInfo != "") {
				var src = "data:image/png;base64," + PhotoInfo;
			} else {
				var src = "../images/uiimages/patdefault.png";
			}
			ShowPicBySrcNew(src, "imgPic");
			var PAPMIDR = $('#PAPMIRowID').val();
			$("#OpMedicare").val(OpMedicare);
			return true;
		} else if (myary[0] == "2001") {
			$.messager.alert("��ʾ", "�޴�����ŵĻ���!");
		} else if (myary[0] == "-353") {
			$.messager.alert("��ʾ", "������Ų����ظ������˻�!");
		} else {
			$.messager.alert("��ʾ", "Error Code: " + myary[0]);
		}
		$("#OpMedicare").addClass("newclsInvalid");
		return false;
	}
}
function InitPatRegConfig() {
	/*var myvalue=$.cm({
		ClassName:"web.DHCBL.CARD.UCardPATRegConfig",
		MethodName:"GetCardPatRegConfig",
		dataType:"text",
		SessionStr:""
	},false);*/
	var myvalue = ServerObj.DefaultCardPatRegConfigPara;
	if (myvalue == "") {
		return;
	}
	var myRtnAry = myvalue.split(String.fromCharCode(2))
	var myary = myRtnAry[0].split("^");
	var mySetFocusElement = myary[2];
	PageLogicObj.m_IsNotStructAddress = myary[17];
	if (PageLogicObj.m_IsNotStructAddress == "Y") {
		InitAddressCombo();
	}
	PageLogicObj.m_SetFocusElement = mySetFocusElement;
	PageLogicObj.m_PatMasFlag = myary[3];
	PageLogicObj.m_CardRefFlag = myary[4];
	PageLogicObj.m_AccManagerFlag = myary[5];
	//SetPatInfoByXML(myRtnAry[1]);
	SetPatInfoByXML(ServerObj.CardPatUIDefStr);
	if (mySetFocusElement != "") {
		$("#" + mySetFocusElement).focus();
	}
	PageLogicObj.m_CardSecrityNo = "";
	PageLogicObj.m_CardRegMustFillInArr = JSON.parse(myary[19]);
	PageLogicObj.m_CardRegJumpSeqArr = JSON.parse(myary[20]);
}
function SetPatInfoByXML(XMLStr, CheckFlag, getMessageByIdCard) {
	XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
	var AddressObj = {
		AdrDesc: {
			Country: '',
			Province: '',
			City: '',
			Area: ''
		},
		AdrHouse: {
			Country: '',
			Province: '',
			City: '',
			Area: ''
		},
		AdrBirth: {
			Country: '',
			Province: '',
			City: '',
			Area: ''
		},
		AdrHome: {
			Country: '',
			Province: '',
			City: ''
		}
	};
	oldPersonMessage = [];
	if (typeof getMessageByIdCard != "undefined") {
		oldPersonMessageFromIDCard = {};
	}
	/*var xmlDoc = DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);*/
	var xmlDoc = DHCDOM_CreateXMLDOMNew(XMLStr);
	if (!xmlDoc) return;
	var nodes = xmlDoc.documentElement.childNodes;
	if (nodes.length <= 0) { return; }
	for (var i = 0; i < nodes.length; i++) {
		//var myItemName = nodes(i).nodeName;
		//var myItemValue = nodes(i).text;
		var myItemName = getNodeName(nodes, i);
		var myItemValue = getNodeValue(nodes, i);
		if ((myItemName == "OtherCardInfo") && (myItemValue != "")) {
			myItemValue = myItemValue.replace(/@/g, "^");
		}
		var _$id = $("#" + myItemName);
		if (_$id.length > 0) {
			//if (_$id.hasClass("hisui-combobox")){
			if (_$id.next().hasClass('combo')) {
				if (typeof getMessageByIdCard != "undefined") {
					if (myItemName == "PatType") {
						oldPersonMessageFromIDCard.PatType = myItemValue
					}
				} else {
					//��ַ��Ϣ�м���˳������,�����ȼ�¼,����
					if (myItemName == "CountryHouse") { //��(��ס)
						AddressObj.AdrDesc.Country = myItemValue;
					} else if (myItemName == "ProvinceInfoLookUpRowID") { //ʡ(��ס)
						AddressObj.AdrDesc.Province = myItemValue;
					} else if (myItemName == "CityDescLookUpRowID") { //��(��ס)
						AddressObj.AdrDesc.City = myItemValue;
					} else if (myItemName == "CityAreaLookUpRowID") { //CTArea ��(��ס)
						AddressObj.AdrDesc.Area = myItemValue;
					} else if (myItemName == "CountryDescLookUpRowID") { //����
						AddressObj.AdrHouse.Country = myItemValue;
					} else if (myItemName == "ProvinceHouse") { //ʡ(����)
						AddressObj.AdrHouse.Province = myItemValue;
					} else if (myItemName == "Cityhouse") { //��(����)
						AddressObj.AdrHouse.City = myItemValue;
					} else if (myItemName == "AreaHouse") { //��(����)
						AddressObj.AdrHouse.Area = myItemValue;
					} else if (myItemName == "CountryBirth") { //��(����)
						AddressObj.AdrBirth.Country = myItemValue;
					} else if (myItemName == "ProvinceBirth") { //ʡ(����)
						AddressObj.AdrBirth.Province = myItemValue;
					} else if (myItemName == "CityBirth") { //��(����)
						AddressObj.AdrBirth.City = myItemValue;
					} else if (myItemName == "AreaBirth") { //��(����)
						AddressObj.AdrBirth.Area = myItemValue;
					} else if (myItemName == "CountryHome") {
						AddressObj.AdrHome.Country = myItemValue;
					} else if (myItemName == "ProvinceHome") {
						AddressObj.AdrHome.Province = myItemValue;
					} else if (myItemName == "CityHome") {
						AddressObj.AdrHome.City = myItemValue;
					} else {
						if ((myItemName == "CardTypeDefine") || (myItemName == "PayMode") || (myItemName == "CredType") || (myItemName == "ForeignCredType")) {
							if (myItemName == "ForeignCredType") {
							}
							var Data = _$id.combobox("getData");
							for (var m = 0; m < Data.length; m++) {
								var id = Data[m]["id"];
								if (myItemValue == id.split("^")[0]) {
									_$id.combobox("select", id);
									break;
								}
							}
						} else if (myItemName == "IEType") {
							if (myItemValue != "") {
								_$id.combobox("select", myItemValue);
							}
						} else {
							//tanjishan 20200605��ֹ�޷�����onselect�¼�
							if ((_$id.combo("getValues") == myItemValue) && (myItemValue != "")) {
								_$id.combobox("setValues", "");
							}
							_$id.combobox("select", myItemValue);
						}
					}
				}
			} else {
				if (typeof getMessageByIdCard != "undefined") {
					if (myItemName == "InMedicare") {
						oldPersonMessageFromIDCard.InMedicare = myItemValue
					}
					if (myItemName == "Name") {
						oldPersonMessageFromIDCard.Name = myItemValue
					}
					if (myItemName == "CredNo") {
						oldPersonMessageFromIDCard.CredNo = myItemValue
					}
				} else {
					if ((PageLogicObj.m_IsNotStructAddress == "Y") && ((myItemName == "Address") || (myItemName == "RegisterPlace"))) {
						_$id.combobox("setText", myItemValue);
					} else {
						_$id.val(myItemValue);
					}
				}
				if ((myItemName == "InMedicare") && (myItemValue != "")) {
					$("#InMedicare").attr("disabled", true);
				} else if ((myItemName == "InMedicare") && (myItemValue == "") && (PageLogicObj.m_MedicalFlag == 1)) {
					$("#InMedicare").attr("disabled", false);
				}
			}
		}
	}
	delete (xmlDoc);
	//��ַ�ֶ�����(����,ʡ��,����)
	for (var Item in AddressObj) {
		if (Item === "AdrDesc") {
			SetCountryComboxData("CountryHouse", AddressObj[Item].Country);
			CountrySelect("CountryHouse", AddressObj[Item].Country);
			//$("#CountryHouse").combobox("select",AddressObj[Item].Country);
			$("#ProvinceInfoLookUpRowID").combobox("select", AddressObj[Item].Province);
			$("#CityDescLookUpRowID").combobox("select", AddressObj[Item].City);
			$("#CityAreaLookUpRowID").combobox("select", AddressObj[Item].Area);
		} else if (Item === "AdrHouse") {
			SetCountryComboxData("CountryDescLookUpRowID", AddressObj[Item].Country);
			CountrySelect("CountryDescLookUpRowID", AddressObj[Item].Country);
			//$("#CountryDescLookUpRowID").combobox("select",AddressObj[Item].Country);
			$("#ProvinceHouse").combobox("select", AddressObj[Item].Province);
			$("#Cityhouse").combobox("select", AddressObj[Item].City);
			$("#AreaHouse").combobox("select", AddressObj[Item].Area);
		} else if (Item === "AdrBirth") {
			SetCountryComboxData("CountryBirth", AddressObj[Item].Country);
			CountrySelect("CountryBirth", AddressObj[Item].Country);
			//$("#CountryBirth").combobox("select",AddressObj[Item].Country);
			$("#ProvinceBirth").combobox("select", AddressObj[Item].Province);
			$("#CityBirth").combobox("select", AddressObj[Item].City);
			$("#AreaBirth").combobox("select", AddressObj[Item].Area);
		} else if (Item === "AdrHome") {
			SetCountryComboxData("CountryHome", AddressObj[Item].Country);
			CountrySelect("CountryHome", AddressObj[Item].Country);
			//$("#CountryHome").combobox("select",AddressObj[Item].Country);
			$("#ProvinceHome").combobox("select", AddressObj[Item].Province);
			$("#CityHome").combobox("select", AddressObj[Item].City);
		}
	}
	if (typeof getMessageByIdCard != "undefined") {
		return;
	}
	oldPersonMessage.push($("#Name").val(), $("#CredNo").val(), $("#InMedicare").val(), $("#PatType").combobox("getText"));
	if (typeof CheckFlag != "undefined") {
		//��֤������ʱ���������������ڡ�֤���š����塢�Ա���Ϣ�����޸ģ��Զ�����ϢΪ׼��
		$("#Name,#Birth,#CredNo").attr("disabled", true);
		$('#NationDescLookUpRowID,#Sex').combobox('disable');
	} else {
		$("#Name,#Birth,#CredNo").attr("disabled", false);
		$('#NationDescLookUpRowID,#Sex').combobox('enable');
	}
}
///�ж��Ƿ�Ҫʹ��APP����¼��Ľ��������ݴ���Ϣ,���ʹ�������XML������SetPatInfoByXML�������ҳ�渳ֵ
///֧�ִ��벡��Rowid �� ���˵ǼǺţ���һ������
function GetRegMedicalEPMI(PAPMIRowID, PAPMINo) {
	if ((PAPMIRowID == "") && (PAPMINo == "")) return "";
	var ret = $.m({
		ClassName: "web.DHCBL.CARD.UCardPaPatMasInfo",
		MethodName: "IsNeedRegMedicalEPMI",
		PAPMIRowID: PAPMIRowID,
		PAPMINo: PAPMINo
	}, false);
	if (ret.split('^')[0] == "1") {
		var PAPMINo = ret.split('^')[1];
		var conFlag = confirm("����û�в��������Ѿ����ֻ�APP��ע���˴�����Ϣ,�Ƿ����룿");
		if (conFlag) {
			var ExpStr = "^1"
			var PAPMIXMLStr = $.m({
				ClassName: "web.DHCBL.CARD.UCardPaPatMasInfo",
				MethodName: "GetPatInfoByPANo",
				PAPMINo: PAPMINo,
				ExpStr: "^1"
			}, false);
			if (PAPMIXMLStr.split('^')[0] == "0") return PAPMIXMLStr.split('^')[1];
		}
	}
	return "";
}
function SearchSamePatient() {
	var name = "",
		sex = "",
		birth = "",
		CredNo = "";
	PatYBCode = "";
	var name = $('#Name').val();
	var sex = $("#Sex").combobox("getValue");
	var birth = $('#Birth').val();
	var CredNo = $("#CredNo").val();
	var PatYBCode = $("#PatYBCode").val();
	var InMedicare = $("#InMedicare").val();
	var OpMedicare = $("#OpMedicare").val();
	var TelHome = $("#TelHome").val()
	if (name == "" && ((CredNo == "") && (PatYBCode == "") && (InMedicare == "") && (TelHome == ""))) return false;
	var Age = $("#Age").val();
	var ArgValue = name + "^" + birth + "^" + CredNo + "^" + sex + "^" + Age + "^" + PatYBCode + "^" + InMedicare + "^" + TelHome;
	if (PageLogicObj.m_CurSearchValue == ArgValue) return false;
	PageLogicObj.m_CurSearchValue = ArgValue;
	var myval = $("#CredType").combobox("getValue");
	var myary = myval.split("^");
	var CredTypeID = myary[0];
	if (CredNo == "") CredTypeID = "";
	name = DHCC_CharTransAsc(name);
	$.cm({
		ClassName: "web.DHCPATCardUnite",
		QueryName: "PatientCardQuery",
		Name: name, CredNo: CredNo, BirthDay: birth, Sex: sex, UserID: "", TPAGCNTX: "",
		PatYBCode: PatYBCode, Age: Age, InMedicare: InMedicare, CredTypeID: CredTypeID,
		TelHome: TelHome,
		Pagerows: PageLogicObj.m_FindPatListTabDataGrid.datagrid("options").pageSize, rows: 99999
	}, function (GridData) {
		PageLogicObj.m_FindPatListTabDataGrid.datagrid({ loadFilter: pagerFilter }).datagrid('loadData', GridData);
	});
}
function InitFindPatListTabDataGrid() {
	var Columns = [[
		{ field: 'TPatientID', hidden: true, title: '' },
		{ field: 'Name', title: '����', width: 100 },
		{
			field: 'CardNO', title: '����', width: 200,
			formatter: function (value, row, index) {
				return value.replace("\\u", " ")
			}
		},
		{ field: 'Sex', title: '�Ա�', width: 50 },
		{ field: 'Birthday', title: '��������', width: 140 },
		{ field: 'CredTypeDesc', title: '֤������', width: 100 },
		{ field: 'CredNo', title: '֤������', width: 150 },
		{ field: 'RegNo', title: '�ǼǺ�', width: 120 },
		{ field: 'PatType', title: '��������', width: 90 },
		{ field: 'Telphone', title: '�绰', width: 100 },
		{ field: 'NewInMedicare', title: '������', width: 90 },
		{ field: 'Company', title: '��λ', width: 150 },
		{ field: 'Adress', title: '��ַ(��ס)', width: 150 },
		{ field: 'ContactPerson', title: '��ϵ��', width: 90 },
		{ field: 'PatYBCode', title: 'ҽ������', width: 90 },
		{ field: 'MobPhone', title: '�ֻ�', width: 100 },
		{ field: 'myOtherStr', title: '', hidden: true },
		{ field: 'EmployeeNo', title: '', hidden: true },
		{ field: 'IDCardNo', title: '', hidden: true },
		{ field: 'CardID', title: '', hidden: true },
		{ field: 'TCreateDate', title: '', hidden: true },
		{ field: 'TCreateUser', title: '', hidden: true },
		{ field: 'OtherCardNo', title: '', hidden: true }
	]]
	var FindPatListTabDataGrid = $("#FindPatListTab").datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		idField: 'CardID',
		columns: Columns,
		onDblClickRow: function (index, row) {
			CardSearchDBClickHander(row);
		},
		onBeforeLoad: function () {
			return false;
		}
	});
	FindPatListTabDataGrid.datagrid('loadData', { total: 0, rows: [] });
	return FindPatListTabDataGrid;
}
function pagerFilter(data) {
	if (typeof data.length == 'number' && typeof data.splice == 'function') {	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		showRefresh: false,
		onSelectPage: function (pageNum, pageSize) {
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh', {
				pageNumber: pageNum,
				pageSize: pageSize
			});
			dg.datagrid('loadData', data);
			dg.datagrid('scrollTo', 0); //������ָ������        
		}
	});
	if (!data.originalRows) {
		data.originalRows = (data.rows);
	}
	if (opts.pageNumber == 0) { opts.pageNumber = 1 }
	if (opts.pagination) {
		var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
		if ((start + 1) > data.originalRows.length) {
			//ȡ���������������ҳ��ʼֵ
			start = Math.floor((data.originalRows.length - 1) / opts.pageSize) * opts.pageSize;
			opts.pageNumber = (start / opts.pageSize) + 1;
		}
		var end = start + parseInt(opts.pageSize);
		data.rows = (data.originalRows.slice(start, end));
	}
	if (data.rows) {
		for (var i = 0; i < data.rows.length; i++) {
			var myOtherStr = data.rows[i].myOtherStr;
			data.rows[i].Sex = myOtherStr.split("^")[4];
			data.rows[i].Birthday = myOtherStr.split("^")[1];
			data.rows[i].RegNo = myOtherStr.split("^")[6];
			data.rows[i].PatType = myOtherStr.split("^")[5];
			data.rows[i].Telphone = myOtherStr.split("^")[0];
			data.rows[i].TPatType = myOtherStr.split("^")[5];
			data.rows[i].NewInMedicare = myOtherStr.split("^")[7];
			data.rows[i].Company = myOtherStr.split("^")[3];
			data.rows[i].Adress = myOtherStr.split("^")[2];
			data.rows[i].ContactPerson = myOtherStr.split("^")[13];
			data.rows[i].PatYBCode = myOtherStr.split("^")[16];
			data.rows[i].MobPhone = myOtherStr.split("^")[17];
		}
	}
	return data;
}
function CheckBirth(Birth) {
	var Year, Mon, Day, Str;
	if (ServerObj.dtformat == "YMD") {
		Str = Birth.split("-")
		Year = Str[0];
		Mon = Str[1];
		Day = Str[2];
	}
	if (ServerObj.dtformat == "DMY") {
		Str = Birth.split("/")
		Year = Str[2];
		Mon = Str[1];
		Day = Str[0];
	}

	var Today, ToYear, ToMon, ToDay;
	Today = new Date();
	ToYear = Today.getFullYear();
	ToMon = (Today.getMonth() + 1);
	ToDay = Today.getDate();
	if ((Year > ToYear) || (Year <= 1840)) {
		return false;
	} else if ((Year == ToYear) && (Mon > ToMon)) {
		return false;
	} else if ((Year == ToYear) && (Mon == ToMon) && (Day > ToDay)) {
		return false;
	} else {
		return true;
	}
}
function IsValidTime(fld) {
	var TIMER = 0;
	var tm = fld.value;
	var re = /^(\s)+/; tm = tm.replace(re, '');
	var re = /(\s)+$/; tm = tm.replace(re, '');
	var re = /(\s){2,}/g; tm = tm.replace(re, ' ');
	tm = tm.toUpperCase();
	var x = tm.indexOf(' AM');
	if (x == -1) x = tm.indexOf(' PM');
	if (x != -1) tm = tm.substring(0, x) + tm.substr(x + 1);
	if (tm == '') { fld.value = ''; return 1; }
	re = /[^0-9A-Za-z]/g;
	tm = tm.replace(re, ':');
	if (isNaN(tm.charAt(0))) return ConvNTime(fld);
	if ((tm.indexOf(':') == -1) && (tm.length > 2)) tm = ConvertNoDelimTime(tm);
	symIdx = tm.indexOf('PM');
	if (symIdx == -1) {
		symIdx = tm.indexOf('AM');
		if (symIdx != -1) {
			if (tm.slice(symIdx) != 'AM') return 0;
			else {
				tm = tm.slice(0, symIdx);
				TIMER = 1;
			}
		}
	} else {
		if (tm.slice(symIdx) != 'PM') return 0;
		else {
			tm = tm.slice(0, symIdx);
			TIMER = 2;
		}
	}
	if (tm == '') return 0;
	var tmArr = tm.split(':');
	var len = tmArr.length;
	if (len > 3) return 0;
	for (i = 0; i < len; i++) {
		if (tmArr[i] == '') return 0;
	}
	var hr = tmArr[0];
	var mn = tmArr[1];
	var sc = tmArr[2];
	if (len == 1) {
		mn = 0;
		sc = 0;
	} else if (len == 2) {
		if (mn.length != 2) return 0;
		sc = 0;
	} else if (len == 3) {
		if (mn.length != 2) return 0;
		if (sc.length != 2) return 0;
	}
	if ((hr > 12) && (TIMER == 1)) return 0;
	if ((hr == 12) && (TIMER == 1)) hr = 0;
	if (isNaN(hr) || isNaN(mn) || isNaN(sc)) return 0;
	hr = parseInt(hr, 10);
	mn = parseInt(mn, 10);
	sc = parseInt(sc, 10);
	if ((hr > 23) || (hr < 0) || (mn > 59) || (mn < 0) || (sc > 59) || (sc < 0)) return 0;
	if ((hr < 12) && (TIMER == 2)) hr += 12;
	fld.value = ReWriteTime(hr, mn, sc);
	websys_returnEvent();
	return 1;
}
function ConvertNoDelimTime(tm) {
	if (isNaN(tm)) return tm;
	var hr = tm.slice(0, 2);
	var mn = tm.slice(2, 4);
	var s = tm.slice(4);
	var tmconv = hr + ':' + mn + ':' + s;
	return tmconv
}
function ReWriteTime(h, m, s) {
	var newtime = '';
	if (h < 10) h = '0' + h;
	if (m < 10) m = '0' + m;
	if (s < 10) s = '0' + s;
	if (PageLogicObj.m_tmformat == 'HMS') { newtime = h + ':' + m + ':' + s; }
	if (PageLogicObj.m_tmformat == 'HM') { newtime = h + ':' + m; }
	return newtime;
}
function ConvNTime(fld) {
	var now = new Date();
	var tm = fld.value;
	var re = /(\s)+/g;
	tm = tm.replace(re, '');
	if (tm.charAt(0).toUpperCase() == 'N') {
		xmin = tm.slice(2);
		if (xmin == '') xmin = 0;
		if (isNaN(xmin)) return 0;
		xmin_ms = xmin * 60 * 1000;
		if (tm.charAt(1) == '+') now.setTime(now.getTime() + xmin_ms);
		else if (tm.charAt(1) == '-') now.setTime(now.getTime() - xmin_ms);
		else if (tm.length > 1) return 0;
		fld.value = ReWriteTime(now.getHours(), now.getMinutes(), now.getSeconds());
		websys_returnEvent();
		return 1;
	}
	return 0;
}
function PayModeOnChange() {
	var myoptval = $("#PayMode").combobox("getValue");
	var myary = myoptval.split("^");
	if (myary[2] == "Y") {
		SetPayInfoStatus(false);
	} else {
		SetPayInfoStatus(true);
	}
}
function SetPayInfoStatus(SFlag) {
	$("#ChequeDate").dateboxq('setValue', '');
	$("#PayCompany,#CardChequeNo,#PayAccNo").attr("disabled", SFlag).val(""); //#ChequeDate
	if (SFlag) {
		$('#Bank,#BankCardType').combobox('select', '').combobox('disable');
		//$("#ChequeDate").dateboxq('disable');
	} else {
		$('#Bank,#BankCardType').combobox('select', '').combobox('enable');
		//$("#ChequeDate").dateboxq('enable');
	}
	//Remark
}
function myformatter(date) {
	var y = date.getFullYear();
	var m = date.getMonth() + 1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat == "3") return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
	else if (ServerObj.sysDateFormat == "4") return (d < 10 ? ('0' + d) : d) + "/" + (m < 10 ? ('0' + m) : m) + "/" + y
	else return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
}
function myparser(s) {
	if (!s) return new Date();
	if (ServerObj.sysDateFormat == "4") {
		var ss = s.split('/');
		var y = parseInt(ss[2], 10);
		var m = parseInt(ss[1], 10);
		var d = parseInt(ss[0], 10);
	} else {
		var ss = s.split('-');
		var y = parseInt(ss[0], 10);
		var m = parseInt(ss[1], 10);
		var d = parseInt(ss[2], 10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
		return new Date(y, m - 1, d);
	} else {
		return new Date();
	}
}
function CredNoOnChange() {
	var myrtn = IsCredTypeID();
	var CredNo = $("#CredNo").val();
	if (myrtn) {
		$("#IDCardNo1").val(CredNo);
		//�������֤��Ĭ�Ϲ�(����)
		if ($("#CountryHome").combobox('getData').length == 0) {
			LoadCountryData("CountryHome");
		}
		$("#CountryHome").combobox('select', 1)
	}
	if (!myrtn) {
		$("#IDCardNo1").val("");
	}
}
function IsCredTypeID() {
	var myval = $("#CredType").combobox("getValue");
	var myary = myval.split("^");
	if (myary[1] == PageLogicObj.m_IDCredTypePlate) {
		return true;
	} else {
		return false;
	}
}
function ForeignIDCardOnKeyPress() {
	var myval = $("#ForeignCredType").combobox("getValue");
	var myary = myval.split("^");
	if (myary[1] == PageLogicObj.m_IDCredTypePlate) {
		var mypId = $("#ForeignIDCard").val();
		mypId = mypId.toUpperCase();
		$("#ForeignIDCard").val(mypId);
		if (mypId != "") {
			var myary = DHCWeb_GetInfoFromId(mypId);
			if (myary[0] == "1") {
				return true;
			}
			else {
				$("#ForeignIDCard").focus();
				return false;
			}
		}
	}
	return true
}
function CredNoOnKeyPress() {
	var winEvent = window.event;
	var mykey = winEvent.keyCode;
	if (mykey == 13) {
		var myrtn = IsCredTypeID();
		if (myrtn) {
			var mypId = $("#CredNo").val();
			mypId = mypId.toUpperCase();
			$("#CredNo").val(mypId);
			var RtnStr = $.cm({
				ClassName: "web.DHCRBAppointment",
				MethodName: "GetAppedCommomInfo",
				dataType: "text",
				CredNo: mypId
			}, false);
			var FindAppFlag = RtnStr.split("^")[0];
			if (FindAppFlag == "1") {
				var LastAppedInfo = RtnStr.split("^")[1];
				var LastAppendName = LastAppedInfo.split("$")[0];
				var LastAppenTelH = LastAppedInfo.split("$")[1];
				var DifferenceAppInfo = RtnStr.split("^")[2];
				if (DifferenceAppInfo != "") {
					$.messager.confirm('ȷ�϶Ի���', "�����֤�Ŵ���������Ч�Ĺ�����ԤԼԤ����Ϣ:\n����:" + LastAppendName + "  �绰:" + LastAppenTelH + "(���һ��Ԥ����Ϣ)\n" + DifferenceAppInfo + "\n�Ƿ�ȡ���һ�ε�Ԥ����Ϣ?", function (r) {
						if (r) {
							$("#Name").val(LastAppendName);
							$("#TelHome").val(LastAppenTelH);
						}
					});
				} else {
					$.messager.confirm('ȷ�϶Ի���', "�����֤�Ŵ�����Ч�Ĺ�����ԤԼԤ����Ϣ:\n����:" + LastAppendName + "  �绰:" + LastAppenTelH + "\n�Ƿ����ԤԼԤ����Ϣ?", function (r) {
						if (r) {
							$("#Name").val(LastAppendName);
							$("#TelHome").val(LastAppenTelH);
						}
					});
				}
			}
			if (mypId != "") {
				setBirthAndSex(mypId);
			}
			//�������֤��Ĭ�Ϲ�(����)
			if ($("#CountryHome").combobox('getData').length == 0) {
				LoadCountryData("CountryHome");
			}
			$("#CountryHome").combobox('select', 1)
		}
		CredNoOnChange();
		var myIDNo = $("#IDCardNo1").val();
		var myval = $("#CredType").combobox("getValue");
		var myCredTypeDR = myval.split("^")[0];
		var myCredNo = $("#CredNo").val();
		var myval = $("#CardTypeDefine").combobox("getValue");
		var myCardTypeDR = myval.split("^")[0];
		var myValidateMode = myval.split("^")[30];
		BuildAddressByIDCard(myCredNo);
		if (myValidateMode == "IDU") {
			if ((myIDNo != "") || (myCredNo != "")) {
				var myInfo = $.cm({
					ClassName: "web.DHCBL.CARD.UCardPATRegConfig",
					MethodName: "ReadConfigByIDU",
					dataType: "text",
					IDNo: myIDNo,
					CredTypeDR: myCredTypeDR,
					CredNo: myCredNo,
					CardTypeDR: myCardTypeDR
				}, false);
				var myary = myInfo.split(String.fromCharCode(1));
				switch (myary[0]) {
					case "0":
						break;
					case "-368":
						PageLogicObj.m_RegCardConfigXmlData = myary[1];
						var myPatInfoXmlData = myary[2];
						var myRepairFlag = myary[3];
						// myRepairFlag Ϊ���������õ�"��������ת����֤",���ڿ��Ʊ���ֵ��Ԫ���Ƿ���ٱ༭
						if (myRepairFlag == "Y") {
							SetPatInfoModeByXML(myPatInfoXmlData, false);
						} else {
							SetPatInfoModeByXML(myPatInfoXmlData, false);
						}
						GetPatDetailByPAPMINo();
						SetPatRegCardDefaultConfigValue(myary[4]);
						break;
					case "-365":
						$.messager.alert('��ʾ', '��֤�������Ѿ�����,������������������!');
						break;
					default:
						$.messager.alert('��ʾ', "" + " Err Code=" + myary[0]);
						break;
				}

			}
		}
	}
}
function SetPatInfoModeByXML(XMLStr, Mode) {
	XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
	var xmlDoc = DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if (xmlDoc.parseError.errorCode != 0) {
		alert(xmlDoc.parseError.reason);
		return;
	}
	var nodes = xmlDoc.documentElement.childNodes;
	for (var i = 0; i < nodes.length; i++) {
		var myItemName = nodes(i).nodeName;
		var myItemValue = nodes(i).text;
		var _$id = $("#" + myItemName);
		if (_$id.length > 0) {
			//if (_$id.hasClass("hisui-combobox")){
			if (_$id.next().hasClass('combo')) {
				if (Mode) {
					$('#NationDescLookUpRowID').combobox('disable');
				} else {
					$('#NationDescLookUpRowID').combobox('enable');
				}
				_$id.combobox("select", myItemValue);
			} else {
				_$id.attr("disabled", Mode);
			}
		}
	}
	delete (xmlDoc);
	//��������ʹ�õǼǺ���Ϊ���ţ���֤���ŵ���Ч��
	CheckForUsePANoToCardNO("New");
}
//��֤ʹ�õǼǺ�����û��Ϊ����ʱ��ǼǺ���Ϊ������û�б�ʹ��
function CheckForUsePANoToCardNO(Type) {
	var PAPMINO = $("#PAPMINo").val();
	if (PageLogicObj.m_UsePANoToCardNO == "Y") {
		if (PAPMINO != "") {
			$("#CardNo").val(PAPMINO);
			var myPAPMIStr = $.cm({
				ClassName: "web.DHCBL.CARD.UCardRefInfo",
				MethodName: "GetPAPMIInfoByCardNo",
				dataType: "text",
				CardNo: PAPMINO,
				CardType: PageLogicObj.m_SelectCardTypeRowID
			}, false);
			if (myPAPMIStr != "") {
				if (Type == "New") {
					$.messager.alert('��ʾ', "�õǼǺ��Ѿ���Ϊ���Ŵ���,�����ٴ�ʹ�ý���!", "info", function () {
						$("#CardNo").val("");
					});
				}
				DisableBtn("NewCard", true);
			} else {
				DisableBtn("NewCard", false);
			}
		} else {
			DisableBtn("NewCard", false);
		}

	}
}
function SetPatRegCardDefaultConfigValue(Value) {
	var myary = Value.split("^");
	PageLogicObj.m_PatMasFlag = myary[1];
	PageLogicObj.m_CardRefFlag = myary[2];
	PageLogicObj.m_AccManagerFlag = myary[3];
	PageLogicObj.m_SetCardReferFlag = myary[4];
}
function Clearclick() {
	SetUIDefaultValue();
	$(".newclsInvalid").removeClass("newclsInvalid");
	$("#PatYBCode,#ChequeDate,#PatPaySum,#OtherCardInfo").val("");
	$("#PAPERMarital,#Bank,#BankCardType").combobox('select', '');
	if (PageLogicObj.m_UsePANoToCardNO != "Y") {
		DisableBtn("NewCard", true);
	}
	PageLogicObj.m_CurSearchValue = "";
	$("#CredType,#ForeignCredType").combobox('select', PageLogicObj.m_CredTypeDef);
	if (PageLogicObj.m_IsNotStructAddress == "Y") {
		$("#Address").combobox('setText', "");
	} else {
		$("#Address").val("");
	}
	setTimeout(function () {
		PageLogicObj.m_FindPatListTabDataGrid.datagrid('loadData', { total: 0, rows: [] });
	}, 500);
}
function SetUIDefaultValue() {
	InitPatRegConfig();
	$("#OpMedicare,#InMedicare").attr("disabled", true);
	IDReadControlDisable(false);
	CardTypeKeydownHandler();
	var src = "../images/uiimages/patdefault.png";
	ShowPicBySrcNew(src, "imgPic");
}
function IDReadControlDisable(bFlag) {
	$("#CredNo,#Name,#Birth,#Age").attr("disabled", bFlag);
	if (bFlag) {
		$('#Sex,#NationDescLookUpRowID').combobox('disable');
	} else {
		$('#Sex,#NationDescLookUpRowID').combobox('enable');
	}
	//��ַ �нṹ����ַ todo
	//var myobj=document.getElementById("Address");
}
function GetValidatePatbyCard() {
	var myCardNo = $("#CardNo").val();
	if (myCardNo == "") {
		$.messager.alert('��ʾ', "���Ų���Ϊ��!");
		return false;
	}
	var rtn = $.m({
		ClassName: "web.DHCBL.CARDIF.ICardRefInfo",
		MethodName: "ReadPatValidateInfoByCardNo",
		CardNO: myCardNo,
		SecurityNo: PageLogicObj.m_CardVerify, CardTypeDR: PageLogicObj.m_SelectCardTypeRowID,
		ExpStr: ""
	}, false);
	var myary = rtn.split("^");
	if (rtn == "") return;
	if (myary[0] == '0') {
		//InitPatRegConfig();
		$("#CardNo").val(myCardNo);
		var myXMLStr = myary[1];
		SetPatInfoByXML(myXMLStr);
		DisableBtn("NewCard", false);
		if (PageLogicObj.m_SetRCardFocusElement != "") {
			$("#" + PageLogicObj.m_SetRCardFocusElement).focus();
		}
	} else {
		switch (myary[0]) {
			case "-341": //�Ѿ�����
				//������������Ѿ������Ĳ�����������Ϣ
				var CardNo = $("#CardNo").val();
				//IntListItemNew();
				//InitTextItem();
				//IntHelpControlNew();
				var myPAPMIStr = $.m({
					ClassName: "web.DHCBL.CARD.UCardRefInfo",
					MethodName: "GetPAPMIInfoByCardNo",
					CardNo: myCardNo,
					CardType: PageLogicObj.m_SelectCardTypeRowID
				}, false);
				if (myPAPMIStr != "") {
					$("#PAPMINo").val(myPAPMIStr.split("^")[1]);
					$("#PAPMIRowID").val(myPAPMIStr.split("^")[0]);
					var IsTemporaryCard = InitTemporaryCard(CardNo);
					if (IsTemporaryCard == "Y") {
						$.messager.alert('��ʾ', "�˿�Ϊ��ʱ��!");
						GetPatDetailByPAPMINo();
						SearchSamePatient();
						return;
					} else {
						$("#CardNo").val("");
						GetPatDetailByPAPMINo();
						SearchSamePatient();
					}
				}
				CardTypeKeydownHandler();
				if (PageLogicObj.m_MedicalFlag == 1) {
					var flag = ValidateRegInfoByCQU(myary[2]);
					if (flag) {
						DisableBtn("NewCard", false);
						return true;
					}
				}
				$.messager.alert('��ʾ', "�˿����Ѿ�����,���ܷ���!");
				break;
			case "-340":
				$.messager.alert('��ʾ', "�˿�û�ж�Ӧ�Ĳ�����Ϣ!");
				break;
			case "-350":
				$.messager.alert('��ʾ', "�˿��Ѿ�ʹ��,�����ظ�����!");
				break;
			case "-351":
				var CancelInfo = $.cm({
					ClassName: "web.UDHCAccManageCLS7",
					MethodName: "GetCancenlInfo",
					dataType: "text",
					cardno: myCardNo,
					CardTypeDR: PageLogicObj.m_SelectCardTypeRowID
				}, false);
				$.messager.alert('��ʾ', "�˿��Ѿ�����ʧ,����ʹ��,��ʧ��:" + CancelInfo.split("^")[0] + ",��ʧԭ��:" + CancelInfo.split("^")[1]);
				break;
			case "-352":
				$.messager.alert('��ʾ', "�˿��Ѿ�������,����ʹ��!");
				break;
			case "-356":
				$.messager.alert('��ʾ', "����ʱ,����Ҫ����������¼,���Ǵ˿����ݱ�Ԥ�����ɴ���!");
				break;
			case "-357":
				$.messager.alert('��ʾ', "����ʱ,����Ҫ����¿���¼,���Ǵ˿�����û��Ԥ������!");
				break;
			case "-358":
				$.messager.alert('��ʾ', "����ʱ,�˿��Ѿ��ж�Ӧ�ĵǼǺ���,����������!");
				break;
			default:
				$.messager.alert('��ʾ', "Error Code:" + myary[0]);
				break;
		}
		DisableBtn("NewCard", true);
	}
}
function DisableBtn(id, disabled) {
	if (disabled) {
		$HUI.linkbutton("#" + id).disable();
	} else {
		$HUI.linkbutton("#" + id).enable();
	}
}
function ReadRegInfoOnClick() {
	var myHCTypeDR = $("#IEType").combobox("getValue");
	var myInfo = DHCWCOM_PersonInfoRead(myHCTypeDR);
	var myary = myInfo.split("^");
	if (myary[0] == "0") {
		SetPatInfoByXML(myary[1]);
		var CredNo = $("#CredNo").val();
		$("#IDCardNo1").val(CredNo);
		//SetIDCredType();
		IDReadControlDisable(true);
		if ($("#CountryHome").combobox('getData').length == 0) {
			LoadCountryData("CountryHome");
		}
		$("#CountryHome").combobox('select', 1)
		BirthOnBlur();
		BuildAddressByIDCard(CredNo)
	}
	//ʹ�ö�ȡ����Ƭ�����ļ�
	var PhotoInfo = $("#PhotoInfo").val();
	if (PhotoInfo != "") {
		var src = "data:image/png;base64," + PhotoInfo;
	} else {
		var src = 'c://' + $("#CredNo").val() + ".bmp"
	}
	ShowPicBySrcNew(src, "imgPic");
}
function NewCardclick() {
	if ($("#NewCard").hasClass('l-btn-disabled')) {
		return false;
	}
	SaveDataToServer();
	return;
}
function BModifyInfoclick() {
	var PAPMIRowID = $("#PAPMIRowID").val();
	if (PAPMIRowID == "") {
		$.messager.alert("��ʾ", "����ѡ���˼�¼,�ٸ���!");
		return false;
	}
	PageLogicObj.m_MedicalFlag = 1;
	PageLogicObj.m_ModifiedFlag = 1;
	//����֤������Ϊ���֤ʱ����֤���֤���Ƿ��Ѿ����ڻ�����Ϣ������������ܸ���
	var myExpstr = "";
	var myIDrtn = IsCredTypeID();
	if (myIDrtn) {
		var CredNo = $("#CredNo").val();
		if (CredNo != "") {
			myExpstr = CredNo;
		}
	}
	var myPAPMINo = $('#PAPMINo').val();
	if (myExpstr != "") {
		var myPatInfo = $.cm({
			ClassName: "web.DHCBL.CARD.UCardPaPatMasInfo",
			MethodName: "GetPatInfoByPANo",
			dataType: "text",
			PAPMINo: "", ExpStr: myExpstr
		}, false);
		var myary = myPatInfo.split("^");
		if (myary[0] == "0") {
			var myXMLStr = myary[1];
			var PAPMIRowID = $("#PAPMIRowID").val();
			var PatientID = myXMLStr.split("<PAPMIRowID>")[1].split("</PAPMIRowID>")[0];
			if ((PatientID != "") && (PatientID != PAPMIRowID)) {
				$.messager.alert("��ʾ", "�����֤�Ѿ���ʹ��!", "info", function () {
					$("#CredNo").focus();
				})
				return false;
			}
		}
	}
	SaveDataToServer();
	PageLogicObj.m_MedicalFlag = 0;
	PageLogicObj.m_ModifiedFlag = 0;
}
function checkPatYBCode() {
	var PatYBCode = $('#PatYBCode').val();
	var myPatType = $("#PatType").combobox("getValue");
	myPatType = CheckComboxSelData("PatType", myPatType);
	if ((myPatType == "") || (myPatType == undefined)) {
		$.messager.alert("��ʾ", "��ѡ�������ͣ�", "info", function () {
			$('#PatType').next('span').find('input').focus();
		});
		return false;
	}
	var PatypeDrArray = myPatType.split("^");
	var PatypeDr = PatypeDrArray[0];
	var rtn = $.cm({
		ClassName: "web.DHCBL.CARD.UCardRefInfo",
		MethodName: "GetInsurFlag",
		dataType: "text",
		PatypeDr: PatypeDr
	}, false);
	if ((rtn == 0) && (PatYBCode != "")) {
		$.messager.alert("��ʾ", "��ҽ������,ҽ�����Ų�����!", "info", function () {
			$("#PatYBCode").focus();
		})
		return false;
	}
	if ((rtn != 0) && (PatYBCode == "")) {
		$.messager.alert("��ʾ", "ҽ������,����д��ȷ��ҽ������", "info", function () {
			$("#PatYBCode").focus();
		})
		return false;
	}
	return true;
}
function SaveDataToServer() {
	//������������֤ ���������Ƿ����� ,�����Ҫ������д
	//������Ҫ���ݵ� Cache�˵����ݴ�
	//����Cache����
	//�ֱ���ô�ӡ����
	//1.�������Ҫ�շ�, �Ƿ��ӡ��Ʊ,���ߴ�ӡС��(������)
	//2.�����Ԥ�����Ƿ���Ҫ��ӡС��;
	//3.���ݿ������Ƿ��ӡ������
	if (!CheckData()) {
		return false;
	}
	DisableBtn("NewCard", true);
	///������Ҫ���ݵ� Cache�˵����ݴ�
	var myPatInfo = GetPatMasInfo();
	var myCardInfo = GetCardRefInfo();
	var myCardInvInfo = GetCardINVInfo();
	var myAccInfo = GetAccManagerInfo();
	var myAccDepInfo = GetPreDepositeInfo();
	var mySecrityNo = "";
	//������޸Ĳ��˻�����Ϣ��������д����
	if ((PageLogicObj.m_MedicalFlag != "1") && (PageLogicObj.m_UsePANoToCardNO != "Y")) {
		if (PageLogicObj.m_CardRefFlag == "Y") {
			if (PageLogicObj.m_OverWriteFlag == "Y") {
				///����д��
				var myrtn = WrtCard();
				var myary = myrtn.split("^");
				if (myary[0] != "0") {
					DisableBtn("NewCard", false);
					return false;
				}
				var mySecrityNo = myary[1];
			} else {
				var mySecrityNo = PageLogicObj.m_CardSecrityNo;
			}
		}
	}
	var Password = "000000";
	if (PageLogicObj.m_AccManagerFlag == "Y") {
		var myDefaultPWDFlag = $("#SetDefaultPassword").checkbox('getValue');
		if (myDefaultPWDFlag) {
			var ren = DHCACC_GetValidatePWD(Password);
			var myary = ren.split("^");
			if (myary[0] == '0') {
				Password = myary[1];
			} else {
				$.messager.alert("��ʾ", "��������ʧ��!");
				DisableBtn("NewCard", false);
				return false;
			}
		} else {
			var ren = DHCACC_SetAccPWD();
			var myary = ren.split("^");
			if (myary[0] == '0') {
				Password = myary[1];
			} else {
				$.messager.alert("��ʾ", "��������ʧ��!");
				DisableBtn("NewCard", false);
				return false;
			}
		}
	}
	var myConfigInfo = PageLogicObj.m_RegCardConfigXmlData;
	var mySpecInfo = mySecrityNo;
	mySpecInfo += "^" + Password;
	var myExpStr = PageLogicObj.m_MedicalFlag + "^" + PageLogicObj.m_UsePANoToCardNO + "^" + session['LOGON.HOSPID'] + "^" + PageLogicObj.m_TransferCardFlag;
	myExpStr = myExpStr + "^" + "";
	var rtn = $.cm({
		ClassName: "web.DHCBL.CARDIF.ICardRefInfo",
		MethodName: "SavePCAInfoToServer",
		dataType: "text",
		ConfigInfo: myConfigInfo,
		PaPatInfo: myPatInfo,
		CardInfo: myCardInfo,
		AccInfo: myAccInfo,
		DepositInfo: myAccDepInfo,
		CardINVInfo: myCardInvInfo,
		SepcialInfo: mySpecInfo,
		ExpStr: myExpStr
	}, false);
	var myary = rtn.split(String.fromCharCode(1));
	if (myary[0] == '0') {
		//������Ƭ
		var PhotoInfo = $("#PhotoInfo").val();
		if (PhotoInfo != "") {
			$.cm({
				ClassName: "web.DHCPE.PreIBIUpdate",
				MethodName: "SavePhoto",
				dataType: "text",
				RegNo: PageLogicObj.m_MedicalFlag == 1 ? myary[3].split("^")[0] : myary[6],
				PhotoInfo: PhotoInfo
			}, false);
		}
		////�����������ô�ӡ
		////����ʱ�շ�Ʊ�ݴ�ӡ��RowID
		if (myary[1] != "") {
			var myCardCost = $("#CardFareCost").val();
			var myCardCost = parseFloat(myCardCost)             //ת������������
			if ((myCardCost > 0) && (myCardCost != "")) {
				PatRegPatInfoPrint(myary[1], PageLogicObj.m_CardINVPrtXMLName, "ReadCardINVEncrypt");
			}
		}
		////Ԥ����RowID
		var myAmtValue = $("#amt").val();
		if ((myAmtValue > 0) && (myary[2] != "")) {
			//Add Version Contral
			var myVersion = ServerObj.ConfigVersion;
			switch (myVersion) {
				case "1":
					var mystr = rtn + "^";
					Print_Click(mystr);
					break;
				default:
					PatRegPatInfoPrint(myary[2], PageLogicObj.m_PrtXMLName, "ReadAccDPEncrypt");
			}
		}
		////��ӡ�������
		if (myary[3] != "") { }
		///��ӡ��ҳ
		if (myary[4] != "") {
			PatRegPatInfoPrint(myary[4], PageLogicObj.m_PatPageXMLName, "ReadFirstPageEncrypt");
		}
		// �ϴ����֤��Ƭ�������� Start
		/*
			ChangeStrToPhotoNew(myary[4],mycredobj.value);
		*/
		// �ϴ����֤��Ƭ�������� End
		if (PageLogicObj.m_ModifiedFlag == 1) {
			$.messager.alert("��ʾ", "��Ϣ�޸ĳɹ�!");
			PageLogicObj.m_CurSearchValue = "";
			SearchSamePatient()
			return;
		} else if (PageLogicObj.m_MedicalFlag == 1) {
			$.messager.alert("��ʾ", "�������ɹ�!");
			return;
		}
		$.messager.alert("��ʾ", "�����ɹ�!", "info", function () {
			//ʹ�ú�̨���صĿ��ź͵ǼǺŴ������ֵ������ǵǼǺ���Ϊ���ŵĴ�ӡ�ǼǺ�
			var CardNo = $("#CardNo").val();
			if (CardNo == "") {
				$("#CardNo").val(myary[7]);
			}
			var PAPMINo = $("#PAPMINo").val();
			if (PAPMINo == "") {
				$("#PAPMINo").val(myary[6]);
			}
			if (PageLogicObj.m_UsePANoToCardNO == "Y") {
				PatInfoPrint("PAPMINo");
			}
			if ((window.parent) && (window.parent.SetPassCardNo)) {
				if (PageLogicObj.m_UsePANoToCardNO == "Y") {
					window.parent.SetPassCardNo(myary[6]);
				} else {
					window.parent.SetPassCardNo(CardNo);
				}
				window.parent.destroyDialog("CardReg");
				return;
			}
			/*var par_win = parent.window.opener;
			if (par_win){
				var CardNo=$("#CardNo").val();
				try{
					if ((par_win)&&(CardNo!='')){
						par_win.SetPassCardNo(CardNo,PageLogicObj.m_SelectCardTypeRowID);
					}
				}catch(e){}
				window.setTimeout("parent.window.close();",500);
					return;
			}*/
			Clearclick();
			DisableBtn("NewCard", false);
		});
	} else if (myary[0] == '-302') {
		$.messager.alert("��ʾ", "�˲����Ѿ��������Ŀ���,���ܷ���!");
	} else if (myary[0] == '-303') {
		$.messager.alert("��ʾ", "���Ų���Ϊ��,�����!");
	} else if (myary[0] == '-304') {
		$.messager.alert("��ʾ", "�˿����Ѿ�����,���ܷ���!");
	} else if (myary[0] == '-365') {
		$.messager.alert("��ʾ", "��֤�������Ѿ�����,������������������!");
	} else if (myary[0] == '-366') {
		$.messager.alert("��ʾ", "��ѡ������!");
	} else if (myary[0] == '-367') {
		$.messager.alert("��ʾ", "֤�����벻��Ϊ��!");
	} else if (myary[0] == '-369') {
		$.messager.alert("��ʾ", "������ʱ,��ȡ������Ϣ����!");
	} else if (myary[0] == '-364') {
		$.messager.alert("��ʾ", "�Ѿ����ڴ˿������µ���Ч��,�������ٷ�!");
	} else if (myary[0] == '-341') {
		$.messager.alert("��ʾ", "�˿��Ѿ�����,�����ظ�����!");
	} else if (myary[0] == '-3411') {
		$.messager.alert("��ʾ", "ת��ʽ��ʧ��,δ�ҵ���Ӧ�Ŀ���¼,���ʵ���źͿ�����!");
	} else {
		$.messager.alert("��ʾ", "Error Code: " + myary[0] + "  ��������ʧ��!");
	}
	if (myary[0] != '0') {
		DisableBtn("NewCard", false);
	}
}
function CardNokeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!SetCardNOLength()) return false;
	}
}
function PatPaySumKeyPress(e) {
	var key = event.keyCode;
	if (key == 13) {
		var PatPaySum = $("#PatPaySum").val();
		var CardFareCost = $("#CardFareCost").val()
		$("#amt").val(DHCCalCom(PatPaySum, CardFareCost, "-"));
		var myChange = $("#amt");
		if ((isNaN(myChange)) || (myChange == "")) {
			myChange = 0;
		}
		myChange = parseFloat(myChange);
		if (myChange < 0) {
			$.messager.alert("��ʾ", "������ý�����!", "info", function () {
				$("#PatPaySum").focus();
			})
		}
	}
}
function DHCCalCom(value1, value2, caloption) {
	var mynum1 = parseFloat(value1);
	if (isNaN(mynum1)) { var mynum1 = 0; }
	var mynum2 = parseFloat(value2);
	if (isNaN(mynum2)) { mynum2 = 0; }
	switch (caloption) {
		case "-":
			var myres = mynum1 - mynum2;
			break;
		case "+":
			var myres = mynum1 + mynum2;
			break;
		case "*":
			var myres = mynum1 * mynum2;
			break;
		case "%":
			var myres = mynum2 / mynum1;
			break;
		default:
			var myres = mynum1 * mynum2;
			break;
	}
	myres = parseFloat(myres) + 0.0000001;
	myres = myres.toFixed(2); //.toString();
	return myres.toFixed(2);
}
function TransferCardClick(e) {
	if ($("#TransferCard").hasClass('l-btn-disabled')) {
		return false;
	}
	var CardNo = $("#CardNo").val();
	if (CardNo == "") {
		$.messager.alert("��ʾ", "���Ų���Ϊ�ա�ת��ʽ��ǰ����˫����ʱ����¼������ʱ����!", "info", function () {
			$("#CardNo").focus();
		});
		return false;
	}
	var myval = $("#CardTypeDefine").combobox('getValue');
	var myCardTypeDR = myval.split("^")[0];
	var myCardType = myval.split("^")[2];
	var TemporaryCardFlag = $.m({
		ClassName: "web.DHCBL.CARD.UCardRefInfo",
		MethodName: "GetTemporaryCardFlag",
		CardTypeId: myCardTypeDR
	}, false)
	if (TemporaryCardFlag != "Y") {
		$.messager.alert("��ʾ", myCardType + " ����ʱ��Ȩ��!");
		return false;
	}
	PageLogicObj.m_MedicalFlag = 1;
	PageLogicObj.m_ModifiedFlag = 1;
	PageLogicObj.m_TransferCardFlag = 1;
	$("#TemporaryCard").switchbox("setValue", false);
	setTimeout(function () {
		SaveDataToServer();
		PageLogicObj.m_MedicalFlag = 0;
		PageLogicObj.m_ModifiedFlag = 0;
		PageLogicObj.m_TransferCardFlag = 0;
	});
}
function InitTemporaryCard(CardNo) {
	if (!CardNo) CardNo = "";
	if (CardNo != "") {
		var myval = $("#CardTypeDefine").combobox('getValue');
		var myCardTypeDR = myval.split("^")[0];
		var Data = $.m({
			ClassName: "web.DHCBL.CARD.UCardRefInfo",
			MethodName: "GetTemporaryCardFlag",
			CardTypeId: myCardTypeDR,
			CardNo: CardNo
		}, false)
	} else {
		var Data = PageLogicObj.m_CTDTemporaryCardFlag;
	}
	if (Data == "Y") {
		$("#TemporaryCard").switchbox('setActive', true)
		var Val = CardNo ? true : false
		$("#TemporaryCard").switchbox('setValue', Val)
		DisableBtn("TransferCard", false);
	} else {
		$("#TemporaryCard").switchbox('setActive', false)
		$("#TemporaryCard").switchbox('setValue', false)
		DisableBtn("TransferCard", true);
	}
	return Data
}
function IntDoc() {
	var myary = ServerObj.DefaultAccPara.split("^");
	if (isNaN(myary[0])) {
		var myVal = 0;
	} else {
		var myVal = parseInt(myary[0]);
	}
	if (myVal == 1) myVal = true;
	else myVal = false;
	$("#SetDefaultPassword").checkbox('setValue', myVal);
	if (myVal) {
		$("#SetDefaultPassword").checkbox('disable')
	} else {
		$("#SetDefaultPassword").checkbox('enable')
	}
	if (isNaN(myary[14])) {
		var myVal = 0;
	} else {
		var myVal = parseInt(myary[14]);
	}
	$("#DepPrice").val(myVal);
	GetCurrentRecNo();
	var src = "../images/uiimages/patdefault.png";
	ShowPicBySrcNew(src, "imgPic");
}
function GetCurrentRecNo() {
	/*$.m({
		ClassName:"web.UDHCAccAddDeposit",
		MethodName:"GetCurrentRecNo",
		userid:session['LOGON.USERID'],
		type:"D"
	},function(ren){
		var myary=ren.split("^");
		if (myary.length>5) PageLogicObj.m_ReceiptsType=myary[5];
		if (myary[0]=='0'){
			$("#ReceiptsNo").val(myary[3]);
		}
	});*/
	var myary = ServerObj.DefaultCurrentRecNoPara.split("^");
	if (myary.length > 5) PageLogicObj.m_ReceiptsType = myary[5];
	if (myary[0] == '0') {
		$("#ReceiptsNo").val(myary[3]);
	}
}
function prtClick() {
	if ($("#PAPMINo").val() == "") {
		$.messager.alert("��ʾ", "����ID����Ϊ��!");
		return false;
	}
	PatInfoPrint("PAPMINo");
}
function PatInfoPrint(ElementName) {
	var PatInfoXMLPrint = "PatInfoPrint";
	var Char_2 = "\x02";
	var InMedicare = $("#InMedicare").val();
	var Name = $("#Name").val();
	var RegNo = $("#" + ElementName).val();
	//����ǼǺŴ���ȥ��̨ȡ��������
	if (RegNo != "") {
		var PatStr = $.cm({
			ClassName: "web.DHCDocOrderEntry",
			MethodName: "GetPatientByNo",
			dataType: "text",
			PapmiNo: RegNo
		}, false)
		if (PatStr != "") { Name = PatStr.split("^")[2] }
	}
	var TxtInfo = "TPatName" + Char_2 + "��  ��:" + "^Name" + Char_2 + Name + "^TRegNo" + Char_2 + "����ID:" + "^RegNo" + Char_2 + RegNo + "^RegNoTM" + Char_2 + "*" + RegNo + "*"
	if (InMedicare != "") TxtInfo = TxtInfo + "^TMedicareNo" + Char_2 + "������:" + "^MedicareNo" + Char_2 + InMedicare;
	var ListInfo = "";
	DHCP_GetXMLConfig("DepositPrintEncrypt", PatInfoXMLPrint);
	//var myobj = document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj, TxtInfo, ListInfo);
	DHC_PrintByLodop(getLodop(), TxtInfo, ListInfo, "", "");
}
function CardSearchCallBack(cardno, Regno, patientid) {
	$("#PAPMINo").val(Regno);
	ValidateRegInfoByCQU(patientid);
}
function ValidateRegInfoByCQU(PAPMIDR) {
	var myval = $("#CardTypeDefine").combobox('getValue');
	var myCardTypeDR = myval.split("^")[0];
	var myValidateMode = myval.split("^")[30];
	if (myValidateMode == "CQU") {
		var myInfo = $.cm({
			ClassName: "web.DHCBL.CARD.UCardPATRegConfig",
			MethodName: "ReadConfigByCQU",
			dataType: "text",
			PAPMIDR: PAPMIDR, CardTypeDR: myCardTypeDR, SessionStr: ""
		}, false)
		var myary = myInfo.split(String.fromCharCode(1));
		switch (myary[0]) {
			case "0":
				break;
			case "-368":
				PageLogicObj.m_RegCardConfigXmlData = myary[1];
				var myPatInfoXmlData = myary[2];
				var myRepairFlag = myary[3];
				SetPatInfoByXML(myPatInfoXmlData);
				GetPatDetailByPAPMINo();
				SetPatRegCardDefaultConfigValue(myary[4]);
				break;
			case "-365":
				$.messager.alert("��ʾ", "��֤�������Ѿ�����,������������������!");
				break;
			default:
				$.messager.alert("��ʾ", "" + " Err Code=" + myary[0]);
				break;
		}
	} else {
		GetPatDetailByPAPMINo();
	}
}
function CardSearchClick() {
	var src = "reg.cardsearchquery.hui.csp";
	var $code = "<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='" + src + "'></iframe>";
	createModalDialog("FindPatReg", "����ѯ", 1260, PageLogicObj.dh, "icon-w-find", "", $code, "");
}
function OtherCredTypeInput() {
	var src = "doc.othercredtype.hui.csp?OtherCardInfo=" + $("#OtherCardInfo").val();;
	var $code = "<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='" + src + "'></iframe>";
	createModalDialog("OtherCredTypeManager", "����֤������", "500", "350", "icon-w-list", "", $code, "");
}
function CardUniteClick() {
	var src = "reg.dhcpatcardunite.hui.csp"; //websys.default.csp?WEBSYS.TCOMPONENT=DHCPATCardUnite
	var $code = "<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='" + src + "'></iframe>";
	createModalDialog("Find", "���ϲ�", PageLogicObj.dw + 150, PageLogicObj.dh + 100, "icon-w-edit", "", $code, "");
}
function CardTypeSave(newData) {
	$("#OtherCardInfo").val(newData);
}
function PatTypeOnChange() {
	var myoptval = $("#PatType").combobox("getText");
	if (myoptval == "��Ժְ��") {
		$("#CardFareCost").val("0");
	} else {
		$("#CardFareCost").val(PageLogicObj.m_CardCost);
	}
}
function Doc_OnKeyDown(e) {
	if (window.event) {
		var keyCode = window.event.keyCode;
		var type = window.event.type;
		var SrcObj = window.event.srcElement;
	} else {
		var keyCode = e.which;
		var type = e.type;
		var SrcObj = e.target;
	}
	if (keyCode == 13) {
		if ((SrcObj.tagName == "A") || (SrcObj.tagName == "INPUT")) {
			if ($(".window-mask").is(":visible")) {
				$(".messager-button a").click();
				return false;
			}
			var myComName = SrcObj.id;
			if (myComName == "CardNo") {
				CardNokeydown(e);
			}/*else if(myComName=="PAPMINo"){
				PAPMINoOnKeyDown(e);
			}*/if (myComName == "ForeignIDCard") {
				ForeignIDCardOnKeyPress(e);
			} else if (myComName == "CredNo") {
				CredNoOnKeyPress(e);
			} else if (myComName == "PatPaySum") {
				PatPaySumKeyPress(e);
			}
			return DOMFocusJump(myComName);
		}
		return true;
	}
	if (((event.altKey) && ((event.keyCode == 82) || (event.keyCode == 114)))) {
		DisableBtn("BReadCard", false);
		ReadCardClickHandle();
	}
	if ((event.keyCode == 119)) {
		ReadRegInfoOnClick();
	}
	if (event.keyCode == 118) {
		Clearclick();
	} else if (event.keyCode == 120) {
		CardSearchClick();
	}
	if (((event.altKey) && ((event.keyCode == 67) || (event.keyCode == 99)))) {
		NewCardclick();
	}
}
function InitAddressCombo() {
	var cbox = $HUI.combobox("#Address,#RegisterPlace", {
		valueField: 'provid',
		textField: 'provdesc',
		editable: true,
		mode: "remote",
		delay: "500",
		url: $URL + "?ClassName=web.DHCBL.CTBASEIF.ICTCardRegLB&QueryName=admaddressNewlookup&rows=999999",
		onBeforeLoad: function (param) {
			var desc = "";
			if (param['q']) {
				desc = param['q'];
			}
			param = $.extend(param, { desc: desc });
		},
		loadFilter: function (data) {
			return data['rows'];
		}
	});
	//$("#Address").combobox("resize","625");
}
function BAddressInoCollapsClick() {
	if ($(".addressinfo").css("display") == "none") {
		$(".addressinfo-div").removeClass("addressinfo-collapse").addClass("addressinfo-expand");
		$(".addressinfo").show();
		$("#BAddressInoCollaps .l-btn-text")[0].innerText = "����ȫ��";
		if (PageLogicObj.m_IsNotStructAddress == "Y") {
			$("#Address").combobox("resize", 547);
			$("#RegisterPlace").combobox("resize", 110);
		}
	} else {
		$(".addressinfo-div").removeClass("addressinfo-expand").addClass("addressinfo-collapse");
		$(".addressinfo").hide();
		$("#BAddressInoCollaps .l-btn-text")[0].innerText = "չ��ȫ��";
	}
}
function BPayInoCollapsClick() {
	if ($(".payinfo").css("display") == "none") {
		$(".payinfo-div").removeClass("payinfo-collapse").addClass("payinfo-expand");
		$(".payinfo").show();
		$("#BPayInoCollaps .l-btn-text")[0].innerText = "����ȫ��";
	} else {
		$(".payinfo-div").removeClass("payinfo-expand").addClass("payinfo-collapse");
		$(".payinfo").hide();
		$("#BPayInoCollaps .l-btn-text")[0].innerText = "չ��ȫ��";
	}
}
function BBaseInoCollapsClick() {
	if ($(".baseinfo").css("display") == "none") {
		$(".baseinfo-div").removeClass("baseinfo-collapse").addClass("baseinfo-expand");
		$(".baseinfo").show();
		$("#BBaseInoCollaps .l-btn-text")[0].innerText = "����ȫ��";
	} else {
		$(".baseinfo-div").removeClass("baseinfo-expand").addClass("baseinfo-collapse");
		$(".baseinfo").hide();
		$("#BBaseInoCollaps .l-btn-text")[0].innerText = "չ��ȫ��";
	}
}
function CheckData() {
	var IsTemporaryCard = $("#TemporaryCard").switchbox("getValue")
	if (IsTemporaryCard) {
		var myCardNo = $("#CardNo").val();
		if ((PageLogicObj.m_UsePANoToCardNO != "Y") && (myCardNo == "")) {
			$.messager.alert("��ʾ", "��������ʱ������!", "info", function () { $("#CardNo").focus(); });
			return false;
		}
		var myName = $("#Name").val();
		if (myName == "") {
			$.messager.alert("��ʾ", "�����뻼������!", "info", function () { $("#Name").focus(); });
			return false;
		}
		var mySex = $("#Sex").combobox("getValue");
		if ((mySex == "") || (mySex == undefined)) {
			$.messager.alert("��ʾ", "��ѡ���Ա�!", "info", function () {
				$('#Sex').next('span').find('input').focus();
			});
			return false;
		}
		var PAPMIRowID = $("#PAPMIRowID").val();
		if ((PAPMIRowID == "") && (!ChkCardCost())) return false;
		return true;	//��ʱ��ֻ��Ҫ��֤�������Ա𡢿�����
	}
	if (PageLogicObj.m_PatMasFlag == "Y") {
		var IsNullInfo = "", FocusName = "";
		//������Ŀ��֤
		var myrtn = true;
		for (var i = 0; i < PageLogicObj.m_CardRegMustFillInArr.length; i++) {
			var id = PageLogicObj.m_CardRegMustFillInArr[i]['id'];
			var text = PageLogicObj.m_CardRegMustFillInArr[i]['text'];
			var val = getValue(id);
			if (val == "") {
				if (IsNullInfo == "") IsNullInfo = text, FocusName = id;
				else IsNullInfo = IsNullInfo + " , " + text;

			}
		}
		if (IsNullInfo != "") {
			$.messager.alert("��ʾ", "������<font color=red>" + IsNullInfo + "</font> !", "info", function () {
				setFocus(FocusName)
			});
			return false;
		}
	}
	var myExpstr = "";
	//����֤������Ϊ���֤ʱ����֤���֤���Ƿ��Ѿ����ڻ�����Ϣ�������������»�����Ϣ
	var myIDrtn = IsCredTypeID();
	if (myIDrtn) {
		var CredNo = $("#CredNo").val();
		if (CredNo != "") {
			myExpstr = CredNo;
		}
	}
	var myPAPMINo = $('#PAPMINo').val();
	if ((myPAPMINo != "") || (myExpstr != "")) {
		var myPatInfo = $.cm({
			ClassName: "web.DHCBL.CARD.UCardPaPatMasInfo",
			MethodName: "GetPatInfoByPANo",
			dataType: "text",
			PAPMINo: myPAPMINo, ExpStr: myExpstr
		}, false);
		var myary = myPatInfo.split("^");
		if (myary[0] == "2001") {
			$.messager.alert("��ʾ", "�޴˵ǼǺŵĻ���,���ܽ���!", "info", function () {
				$("#PAPMINo").focus();
			});
			return false;
		} else if (myary[0] == "0") {
			var myXMLStr = myary[1];
			var PatientID = myXMLStr.split("<PAPMIRowID>")[1].split("</PAPMIRowID>")[0];
			if (PatientID != "") {
				$("#PAPMIRowID").val(PatientID);
			} else {
				$("#PAPMIRowID").val("");
			}
		}
	}
	var PAPMIRowID = $("#PAPMIRowID").val();
	//��֤������Ϣ(�������Ա𡢳������ڡ���ϵ�绰)�Ƿ����һ�µĻ���
	if (!PatInfoUnique()) {
		return false;
	}
	var InsuNo = $('#PatYBCode').val();
	//ҽ���ֲ��
	if ((InsuNo != "") && (InsuNo != "99999999999S")) {
		var Rtn = $.cm({
			ClassName: "web.DHCBL.Patient.DHCPatient",
			MethodName: "PatUniInfoQuery",
			dataType: "text",
			PatientDr: PAPMIRowID, Type: "InsuNo", NoStr: InsuNo
		}, false);
		if (Rtn > 0) {
			$.messager.alert("��ʾ", InsuNo + "ҽ�����ѱ�ʹ��!", "info", function () {
				$("#PatYBCode").focus();
			});
			return false
		}
	}
	var OpMedicareObj = document.getElementById('OpMedicare');
	if (PageLogicObj.m_PatMasFlag == "Y") {
		var myBirthTime = $("#BirthTime").val();
		if (myBirthTime != "") {
			var regTime = /^([0-2][0-9]):([0-5][0-9]):([0-5][0-9])$/;
			if (!regTime.test(myBirthTime)) {
				$.messager.alert("��ʾ", "��������ȷ�ĳ���ʱ��!", "info", function () {
					$("#BirthTime").focus();
				});
				return false;
			}
		}
		/*var IsNullInfo="",FocusIndex=""
		var myTelHome=$("#TelHome").val();
		if (myTelHome=="")
		{
			IsNullInfo="��ϵ�绰"
			FocusIndex="TelHome"
			//$.messager.alert("��ʾ","��������ϵ�绰!","info",function(){
			//	$("#TelHome").focus();
			//});
			//return false;
		}
		var myMobPhone=$("#MobPhone").val();
		if (myMobPhone!=""){
			if(myMobPhone.length!="11"){
				$.messager.alert("��ʾ","�ֻ����볤�ȴ���,ӦΪ��11��λ,���ʵ!","info",function(){
					$("#MobPhone").focus();
				});
				return false;
			}
		}
		var myName=$("#Name").val();
		if (myName==""){
			if (IsNullInfo=="")	{
				IsNullInfo="��������"
				FocusIndex="Name"
			}
			else IsNullInfo=IsNullInfo+"����������"
			//$.messager.alert("��ʾ","�����뻼������!","info",function(){
			//	$("#Name").focus();
			//});
			//return false;
		}
		var mySex=$("#Sex").combobox("getValue");
		if ((mySex=="")||(mySex==undefined)){
			if (IsNullInfo=="")	{
				IsNullInfo="�Ա�"
				FocusIndex="Sex"
			}
			else IsNullInfo=IsNullInfo+"���Ա�"
			//$.messager.alert("��ʾ","��ѡ���Ա�!","info",function(){
			//	$("#Sex").focus();
			//});
			//return false;
		}
		var myPatType= $("#PatType").combobox("getValue");
		myPatType=CheckComboxSelData("PatType",myPatType);
		if ((myPatType=="")||(myPatType==undefined)){
			if (IsNullInfo=="")	{
				IsNullInfo="��������"
				FocusIndex="PatType"
			}
			else IsNullInfo=IsNullInfo+"����������"
			//$.messager.alert("��ʾ","��ѡ��������!","info",function(){
			//	$("#PatType").focus();
			//});
			//return false;
		}
		var myBirth=$("#Birth").val();
		if (myBirth==""){
			if (IsNullInfo=="")	{
				IsNullInfo="��������"
				FocusIndex="Birth"
			}
			else IsNullInfo=IsNullInfo+"����������"
			//$.messager.alert("��ʾ","�������������!","info",function(){
			//	$("#Birth").focus();
			//});
			//return false;
		}
		if (IsNullInfo!=""){
			$.messager.alert("��ʾ",IsNullInfo+"����Ϊ��!","info",function(){
				$("#"+FocusIndex).focus();
			});
			return false;
		}*/
		//��ҽ�����Ͳ�����дҽ����
		if (!checkPatYBCode()) return false;
		if (!BirthCheck()) return false;
		if (!ForeignIDCardOnKeyPress()) return false;
		var myTelHome = $("#TelHome").val();
		if (myTelHome != "") {
			if (!CheckTelOrMobile(myTelHome, "TelHome", "��ϵ�绰")) return false;
		}
		var myMobPhone = $("#MobPhone").val();
		if (myMobPhone != "") {
			if (!CheckTelOrMobile(myMobPhone, "MobPhone", "�ֻ�")) return false;
		}
		var myTelOffice = $("#TelOffice").val();
		if (myTelOffice != "") {
			if (!CheckTelOrMobile(myTelOffice, "TelOffice", "�칫�绰")) return false;
		}
		var myBirth = $("#Birth").val();
		if (myBirth != "") {
			if (ServerObj.dtformat == "YMD") {
				var reg = /^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
			}
			if (ServerObj.dtformat == "DMY") {
				var reg = /^(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
			}
			var ret = myBirth.match(reg);
			if (ret == null) {
				$.messager.alert("��ʾ", "��������ȷ�ĳ�������!", "info", function () {
					$("#Birth").focus();
				});
				return false;
			}
			if (ServerObj.dtformat == "YMD") {
				var myrtn = DHCWeb_IsDate(myBirth, "-")
			}
			if (ServerObj.dtformat == "DMY") {
				var myrtn = DHCWeb_IsDate(myBirth, "/")
			}
			if (!myrtn) {
				$.messager.alert("��ʾ", "��������ȷ�ĳ�������!", "info", function () {
					$("#Birth").focus();
				});
				return false;
			} else {
				var mybirth1 = $("#Birth").val();
				var Checkrtn = CheckBirth(mybirth1);
				if (Checkrtn == false) {
					$.messager.alert("��ʾ", "�������ڲ��ܴ��ڽ������С�ڡ�����1840��!", "info", function () {
						$("#Birth").focus();
					});
					return false;
				}
			}
			var mybirth = $("#Birth").val();
			var myage = $("#Age").val();
			var mybirthTime = $("#BirthTime").val();
			var ageStr = $.cm({
				ClassName: "web.UDHCJFCOMMON",
				MethodName: "DispPatAge",
				dataType: "text",
				birthDate: mybirth, admDate: "", birthTime: mybirthTime, admTime: "", controlFlag: "N",
				hospId: session['LOGON.HOSPID']
			}, false);
			if ((ageStr.split("||")[1] != myage) && (ageStr.split("||")[0] != myage)) {
				$.messager.alert("��ʾ", "�������ڲ�������Ͳ����!", "info", function () {
					$("#Birth").focus();
				});
				return false;
			}
		}
		//��������������ʾ��ϢΪ����
		if ((PageLogicObj.m_MedicalFlag == 1) && (PageLogicObj.m_ModifiedFlag == 0)) {
			if (PageLogicObj.m_IsNotStructAddress == "Y") {
				var myAddress = $("#Address").combobox("getText");
				if (myAddress == "") {
					$.messager.alert("��ʾ", "û�е�ַ,����д��ַ!", "info", function () {
						$('#Address').next('span').find('input').focus();
					});
					return false;
				}
			} else {
				var myAddress = $("#Address").val();
				if (myAddress == "") {
					$.messager.alert("��ʾ", "û�е�ַ,����д��ַ!", "info", function () {
						$("#Address").focus();
					});
					return false;
				}
			}
			var myCountryDesc = $("#CountryDescLookUpRowID").combobox('getValue');
			myCountryDesc = CheckComboxSelData("CountryDescLookUpRowID", myCountryDesc);
			if (myCountryDesc == "") {
				$.messager.alert("��ʾ", "��ѡ�����!", "info", function () {
					$('#CountryDescLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myPAPERMarital = $("#PAPERMarital").combobox('getValue');
			if (myPAPERMarital == "") {
				$.messager.alert("��ʾ", "��ѡ�����״̬!", "info", function () {
					$('#PAPERMarital').next('span').find('input').focus();
				});
				return false;
			}
			var myProvinceBirth = $("#ProvinceBirth").combobox('getValue');
			myProvinceBirth = CheckComboxSelData("ProvinceBirth", myProvinceBirth);
			if (myProvinceBirth == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ��ʡ(����)!", "info", function () {
					$('#ProvinceBirth').next('span').find('input').focus();
				});
				return false;
			}
			var myNationDesc = $("#NationDescLookUpRowID").combobox('getValue');
			myNationDesc = CheckComboxSelData("NationDescLookUpRowID", myNationDesc);
			if (myNationDesc == "") {
				$.messager.alert("��ʾ", "��ѡ������!", "info", function () {
					$('#NationDescLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myCityBirth = $("#CityBirth").combobox('getValue');
			myCityBirth = CheckComboxSelData("CityBirth", myCityBirth);
			if (myCityBirth == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ����(����)!", "info", function () {
					$('#CityBirth').next('span').find('input').focus();
				});
				return false;
			}
			var myAreaBirth = $("#AreaBirth").combobox('getValue');
			myAreaBirth = CheckComboxSelData("AreaBirth", myAreaBirth);
			if (myAreaBirth == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ����(����)!", "info", function () {
					$('#AreaBirth').next('span').find('input').focus();
				});
				return false;
			}
			var myProvinceInfo = $("#ProvinceInfoLookUpRowID").combobox('getValue');
			myProvinceInfo = CheckComboxSelData("ProvinceInfoLookUpRowID", myProvinceInfo);
			if (myProvinceInfo == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ��ʡ(��ס)!", "info", function () {
					$('#AreaBirth').next('span').find('input').focus();
				});
				return false;
			}
			var myCityDesc = $("#CityDescLookUpRowID").combobox('getValue');
			myCityDesc = CheckComboxSelData("CityDescLookUpRowID", myCityDesc);
			if (myCityDesc == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ����(��ס)!", "info", function () {
					$('#CityDescLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myCTArea = $("#CityAreaLookUpRowID").combobox('getValue');
			myCTArea = CheckComboxSelData("CityAreaLookUpRowID", myCTArea);
			if (myCTArea == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ����(��ס)!", "info", function () {
					$('#CityAreaLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myCompany = $("#EmployeeCompanyLookUpRowID").val();
			if (myCompany == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "�����빤����λ!", "info", function () {
					$('#EmployeeCompanyLookUpRowID').focus();
				});
				return false;
			}
			var myProvinceHouse = $("#ProvinceHouse").combobox('getValue');
			myProvinceHouse = CheckComboxSelData("ProvinceHouse", myProvinceHouse);
			if (myProvinceHouse == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ��ʡ(����)!", "info", function () {
					$('#CityAreaLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myCityhouse = $("#Cityhouse").combobox('getValue');
			myCityhouse = CheckComboxSelData("Cityhouse", myCityhouse);
			if (myCityhouse == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ����(����)!", "info", function () {
					$('#CityAreaLookUpRowID').next('span').find('input').focus();
				});
				return false;
			}
			var myAreaHouse = $("#AreaHouse").combobox('getValue');
			myAreaHouse = CheckComboxSelData("AreaHouse", myAreaHouse);
			if (myAreaHouse == "") {
				if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ����(����)!", "info", function () {
					$('#AreaHouse').next('span').find('input').focus();
				});
				return false;
			}
			if (PageLogicObj.m_IsNotStructAddress == "Y") {
				var myAddress = $("#RegisterPlace").combobox("getText");
				if (myAddress == "") {
					if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
					$.messager.alert("��ʾ", "����д��ַ(����)!", "info", function () {
						$('#RegisterPlace').next('span').find('input').focus();
					});
					return false;
				}
			} else {
				var myAddress = $("#RegisterPlace").val();
				if (myAddress == "") {
					if (!AddressInfoIsExpand()) BAddressInoCollapsClick();
					$.messager.alert("��ʾ", "����д��ַ(����)!", "info", function () {
						$("#RegisterPlace").focus();
					});
					return false;
				}
			}
			var myCTRelationDR = $("#CTRelationDR").combobox("getText");
			myCTRelationDR = CheckComboxSelData("CTRelationDR", myCTRelationDR);
			if (myCTRelationDR == "") {
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("��ʾ", "��ѡ���ϵ!", "info", function () {
					$("#CTRelationDR").focus();
				});
				return false;
			}
			var myForeignPhone = $("#ForeignPhone").val();
			if (myForeignPhone == "") {
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("��ʾ", "��������ϵ�˵绰!", "info", function () {
					$("#ForeignPhone").focus();
				});
				return false;
			} else {
				if (!CheckTelOrMobile(myForeignPhone, "ForeignPhone", "��ϵ�˵绰")) return false;
			}
		}
	}
	//var OpMedicareObj = document.getElementById('OpMedicare');
	var CredNo = $("#CredNo").val();
	if (PageLogicObj.m_PatMasFlag == "Y") {
		var myForeignName = $("#ForeignName").val();
		if (myForeignName == "") {
			/*if(PageLogicObj.m_MedicalFlag==1){
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("��ʾ","��������ϵ��!","info",function(){
					$("#ForeignName").focus();
				});
				return false;
			}*/
		}
		/*var myTelHome = $("#TelHome").val();
		if (myTelHome == "") {
			$.messager.alert("��ʾ","��������ϵ�绰!","info",function(){
				$("#TelHome").focus();
			});
			return false;
		}else{
			if (!CheckTelOrMobile(myTelHome,"TelHome","")) return false;
		}
		var myBirth = $("#Birth").val();
		if (myBirth == "") {
			$.messager.alert("��ʾ","�������������!","info",function(){
				$("#Birth").focus();
			});
			return false;
		}*/
		if (CheckBirthAndBirthTime()) {
			$.messager.alert("��ʾ", "���������ǵ����,����ʱ�䲻�ܴ��ڵ�ǰʱ��,���ʵ!", "info", function () {
				$("#BirthTime").focus();
			});
			return false;
		}
		/*var mySex = $("#Sex").combobox("getValue");
		if (mySex == "") {
			$.messager.alert("��ʾ","��ѡ���Ա�!","info",function(){
				$('#Sex').next('span').find('input').focus();
			});
			return false;
		}*/
		var Age = AgeForYear(myBirth)
		if (Age < ServerObj.ForeignInfoByAge) {
			var ForeignName = $("#ForeignName").val();
			var ForeignPhone = $("#ForeignPhone").val();
			var ForeignIDCard = $("#ForeignIDCard").val();
			if (ForeignName == "") {
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("��ʾ", "����С��" + ServerObj.ForeignInfoByAge + "��,��ϵ�˲���Ϊ��!", "info", function () {
					$("#ForeignName").focus();
				});
				return false;
			}
			if (ForeignPhone == "") {
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("��ʾ", "����С��" + ServerObj.ForeignInfoByAge + "��,��ϵ�˵绰����Ϊ��!", "info", function () {
					$("#ForeignPhone").focus();
				});
				return false;
			}
			if (ForeignPhone != "") {
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				if (!CheckTelOrMobile(ForeignPhone, "ForeignPhone", "��ϵ�˵绰")) return false;
			}
			if (ForeignIDCard == "") {
				if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
				$.messager.alert("��ʾ", "����С��" + ServerObj.ForeignInfoByAge + "��,��ϵ��֤����Ϣ����Ϊ��", "info", function () {
					$("#ForeignIDCard").focus();
				});
				return false;
			}
		} else {
			var myForeignPhone = $("#ForeignPhone").val();
			if (myForeignPhone != "") {
				if (!CheckTelOrMobile(myForeignPhone, "ForeignPhone", "��ϵ�˵绰")) return false;
			}
		}
		/*����״̬���� start*/
		var mySex = $("#Sex").combobox('getText');
		var myPAPERMarital = $("#PAPERMarital").combobox('getValue');
		var AgeToMaritalFlag = 0
		if (mySex == "Ů") {
			if ((Age < PageLogicObj.m_MarriedLimitFemaleFAge) && (("^" + PageLogicObj.m_MarriedIDStr + "^").indexOf("^" + myPAPERMarital + "^") != -1)) {
				AgeToMaritalFlag = 1;
			}
		} else if (mySex == "��") {
			if ((Age < PageLogicObj.m_MarriedLimitMaleAge) && (("^" + PageLogicObj.m_MarriedIDStr + "^").indexOf("^" + myPAPERMarital + "^") != -1)) {
				AgeToMaritalFlag = 1;
			}
		}
		if (AgeToMaritalFlag == 1) {
			dhcsys_alert("�û���δ����������!");
		}
		/*����״̬���� end*/
		/*var myPatType = $("#PatType").combobox("getValue");
		myPatType=CheckComboxSelData("PatType",myPatType);
		if ((myPatType == "")||(myPatType==undefined)) {
			$.messager.alert("��ʾ","��ѡ��������","info",function(){
				$('#PatType').next('span').find('input').focus();
			});
			return false;
		}*/
		//���ڲ�������Ϊְ���ĶԹ��ŵ��ж�
		var myPatType = $("#PatType").combobox("getText");
		if (myPatType.indexOf('��Ժ') >= 0) {
			var EmployeeNo = $("#EmployeeNo").val();
			if (EmployeeNo == "") {
				$.messager.alert("��ʾ", "��Ժְ��,����дְ������!", "info", function () {
					$("#EmployeeNo").focus();
				});
				return false;
			}
			var curPAPMIRowID = $.cm({
				ClassName: "web.DHCBL.CARDIF.ICardPaPatMasInfo",
				MethodName: "GetPAPMIRowIDByEmployeeNo",
				dataType: "text",
				EmployeeNo: EmployeeNo
			}, false);
			var name = curPAPMIRowID.split("^")[1];
			var UserName = curPAPMIRowID.split("^")[2];
			curPAPMIRowID = curPAPMIRowID.split("^")[0];
			if (curPAPMIRowID == "0") {
				$.messager.alert("��ʾ", "���Ų���ȷ,���ʵ����!", "info", function () {
					$("#EmployeeNo").focus();
				});
				return false;
			}
			var PAPMIRowID = $("#PAPMIRowID").val();
			if ((PAPMIRowID != curPAPMIRowID) && (curPAPMIRowID != "")) {
				$.messager.alert("��ʾ", "�˹����Ѿ���'" + name + "'����,���ʵ����!", "info", function () {
					$("#EmployeeNo").focus();
				});
				return false;
			}
			var Name = $("#Name").val();
			if (UserName != Name) {
				$.messager.alert("��ʾ", "�˹��Ŷ�Ӧ����Ϊ'" + UserName + "'����¼��������һ��!", "info", function () {
					$("#Name").focus();
				});
				return false;
			}
		} else {
			var EmployeeNo = $("#EmployeeNo").val();
			if (EmployeeNo != "") {
				$.messager.alert("��ʾ", "�Ǳ�Ժְ�����Ų�����д!", "info", function () {
					$("#EmployeeNo").focus();
				});
				return false;
			}
		}
		var myIDNo = $("#CredNo").val();
		if (myIDNo != "") {
			var myval = $("#CredType").combobox("getValue");
			if (myval == "") {
				$.messager.alert("��ʾ", "֤�����벻Ϊ��ʱ,֤�����Ͳ���Ϊ��!");
				return false;
			}
			var myIDrtn = IsCredTypeID();
			if (myIDrtn) {
				var myIsID = DHCWeb_IsIdCardNo(myIDNo);
				if (!myIsID) {
					$("#CredNo").focus();
					return false;
				}
				var IDNoInfoStr = DHCWeb_GetInfoFromId(myIDNo)
				var IDBirthday = IDNoInfoStr[2]
				if (myBirth != IDBirthday) {
					$.messager.alert("��ʾ", "�������������֤��Ϣ����!", "info", function () {
						$("#Birth").focus();
					});
					return false;
				}
				var IDSex = IDNoInfoStr[3]
				if (mySex != IDSex) {
					$.messager.alert("��ʾ", "���֤��:" + myIDNo + "��Ӧ���Ա��ǡ�" + IDSex + "��,��ѡ����ȷ���Ա�!", "info", function () {
						$('#Sex').next('span').find('input').focus();
					});
					return false;
				}
			} else {
				var myval = $("#CredType").combobox("getValue");
				var myCredTypeDR = myval.split("^")[0];
				var PAPMIRowID = $("#PAPMIRowID").val();
				var mySameFind = $.cm({
					ClassName: "web.DHCBL.CARD.UCardPaPatMasInfo",
					MethodName: "CheckCredNoIDU",
					PatientID: PAPMIRowID, CredNo: myIDNo, CredTypeDR: myCredTypeDR,
					dataType: "text"
				}, false);
				if (mySameFind == "1") {
					$.messager.alert("��ʾ", myIDNo + " ��֤�������Ѿ���ʹ��!", "info", function () {
						$("#CredNo").focus();
					})
					return false;
				}
				//���֤�����Ͳ������֤,���IDCardNo1ֵ����ֹIDCardNo1���µ�papmi_id
				$("#IDCardNo1").val("");
			}
			var OtherCardInfo = $("#OtherCardInfo").val();
			if (OtherCardInfo != "") {
				var CredNo = $("#CredNo").val();
				var myval = $("#CredType").combobox("getValue");
				var myCredTypeDR = myval.split("^")[0];
				for (var i = 0; i < OtherCardInfo.split("!").length; i++) {
					var oneCredTypeId = OtherCardInfo.split("!")[i].split("^")[0];
					if (oneCredTypeId != myCredTypeDR) continue;
					var oneCredNo = OtherCardInfo.split("!")[i].split("^")[1];
					if ((oneCredNo != CredNo) && (oneCredNo != "")) {
						$.messager.alert("��ʾ", "֤������: " + CredNo + " ������֤��������֤ͬ������ά���ĺ���: " + oneCredNo + " ��һ��!���ʵ!", "info", function () {
							$("#CredNo").focus();
						});
						return false;
					}
				}
			}
		} else {
			var myval = $("#CredType").combobox("getValue");
			var myCredTypeDR = myval.split("^")[0];
			var CredNoRequired = $.cm({
				ClassName: "web.DHCBL.CARD.UCardRefInfo",
				MethodName: "CheckCardNoRequired",
				dataType: "text",
				CredTypeDr: myCredTypeDR
			}, false)
			var AgeAllow = $.cm({
				ClassName: "web.DHCDocConfig",
				MethodName: "GetDHCDocCardConfig",
				dataType: "text",
				Node: "AllowAgeNoCreadCard"
			}, false);
			var FlagNoCread = $.cm({
				ClassName: "web.DHCDocConfig",
				MethodName: "GetDHCDocCardConfig",
				dataType: "text",
				Node: "NOCREAD"
			}, false);
			if (CredNoRequired == "Y") {
				if ((AgeAllow != "") & (parseFloat(Age) <= parseFloat(AgeAllow))) { }
				else {
					$.messager.alert("��ʾ", "����д֤������!", "info", function () {
						$('#CredNo').focus();
					});
					return false;
				}
			}
		}
		var myval = $("#CardTypeDefine").combobox("getValue");
		var myary = myval.split("^");
		if (myary[3] == "C") {
			var mypmval = $("#PayMode").combobox("getValue");
			if (mypmval == "") {
				$.messager.alert("��ʾ", "��ѡ��֧����ʽ!", "info", function () {
					$('#PayMode').next('span').find('input').focus();
				});
				return false;
			}
			var mytmpary = mypmval.split("^");
			if (mytmpary[2] == "Y") {
				///Require Pay Info
				var myCheckNO = $("#CardChequeNo").val();
				if (myCheckNO == "") {
					if (!PayInfoIsExpand()) BPayInoCollapsClick();
					$.messager.alert("��ʾ", "������֧Ʊ/���ÿ���!", "info", function () {
						$('#CardChequeNo').focus();
					});
					return false;
				}
			}
		}
		var myOtheRtn = OtherSpecialCheckData();
		if (!myOtheRtn) {
			return myOtheRtn;
		}
		if (PageLogicObj.m_ModifiedFlag == 1) return true;
	}
	//������õǼǺź���Ϊ������ȡУ����濨��
	if ((PageLogicObj.m_CardRefFlag == "Y") && (PageLogicObj.m_UsePANoToCardNO != "Y")) {
		var myCardNo = $("#CardNo").val();
		if (myCardNo == "") {
			$.messager.alert("��ʾ", "���Ų���Ϊ��,�����!", "info", function () {
				if (PageLogicObj.m_SetFocusElement != "") {
					$("#" + PageLogicObj.m_SetFocusElement).focus();
				}
			});
			return false;
		}
		////Card NO Length ?= Card Type Define Length
		var myCTDefLength = 0;
		if (isNaN(PageLogicObj.m_CardNoLength)) {
			myCTDefLength = 0;
		} else {
			myCTDefLength = PageLogicObj.m_CardNoLength;
		}
		if ((myCTDefLength != 0) && (myCardNo.length != myCTDefLength)) {
			if (PageLogicObj.m_SetFocusElement != "") {
				$.messager.alert("��ʾ", "���ų��ȴ��� " + myCTDefLength + " ", "info", function () {
					$("#CardNo").focus();
				});
			}
			return false;
		}
		////Card No Pre ?= Card Type Define Pre
		if (PageLogicObj.m_CardTypePrefixNo != "") {
			var myPreNoLength = PageLogicObj.m_CardTypePrefixNo.length;
			var myCardNo = $("#CardNo").val();
			var myPreNo = myCardNo.substring(0, myPreNoLength);
			if (myPreNo != PageLogicObj.m_CardTypePrefixNo) {
				$.messager.alert("��ʾ", "������ǰ׺����!", "info", function () {
					$("#CardNo").focus();
				});
				return false;
			}
		}
	}
	if (!ChkCardCost()) return false;

	return myrtn;
}
function ChkCardCost() {
	var myPatPaySum = $("#PatPaySum").val();
	if ((myPatPaySum == "") && (+PageLogicObj.m_CardCost > 0)) {
		$.messager.alert("��ʾ", "�������տ���!", "info", function () {
			$("#PatPaySum").focus();
		});
		return false;
	} else {
		var PatPaySum = $("#PatPaySum").val();
		var CardFareCost = $("#CardFareCost").val()
		$("#amt").val(DHCCalCom(PatPaySum, CardFareCost, "-"));
		var myChange = $("#amt").val();
		if ((isNaN(myChange)) || (myChange == "")) {
			myChange = 0;
		}
		myChange = parseFloat(myChange);
		if (myChange < 0) {
			$.messager.alert("��ʾ", "������ý�����!", "info", function () {
				$("#PatPaySum").focus();
			});
			return false;
		}
		var ReceiptsNo = $("#ReceiptsNo").val();
		var myChange = $("#amt").val();
		if ((myChange != "") && (myChange != "0") && (ReceiptsNo == "") && (PageLogicObj.m_ReceiptsType != "")) {
			$.messager.alert("��ʾ", "���Ѿ�û�п����վ�,������ȡ�վ�!");
			return false;
		}
	}
	if (PageLogicObj.m_AccManagerFlag == "Y") {
		var amt = $("#amt").val();
		if ((!IsNumber(amt)) || (amt < 0)) {
			$.messager.alert("��ʾ", "�����������,����������!", "info", function () {
				$("#PatPaySum").focus();
			});
			return false;
		}
	}
	return true;
}
function CheckTelOrMobile(telephone, Name, Type) {
	if (telephone.length == 8) return true;
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.substring(0, 1) == 0) {
		if (telephone.indexOf('-') >= 0) {
			$.messager.alert("��ʾ", Type + "�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!", "info", function () {
				$("#" + Name).focus();
			})
			return false;
		} else {
			$.messager.alert("��ʾ", Type + "�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,���ʵ!", "info", function () {
				$("#" + Name).focus();
			})
			return false;
		}
	} else {
		if (telephone.length != 11) {
			$.messager.alert("��ʾ", Type + "�绰����ӦΪ��11��λ,���ʵ!", "info", function () {
				$("#" + Name).focus();
			})
			return false;
		} else {
			$.messager.alert("��ʾ", Type + "�����ڸúŶε��ֻ���,���ʵ!", "info", function () {
				$("#" + Name).focus();
			})
			return false;
		}
	}
	return true;
}
function CheckBirthAndBirthTime() {
	var Today = new Date();
	var mytime = Today.getHours();
	var CurMinutes = Today.getMinutes();
	if (CurMinutes <= 9) {
		CurMinutes = "0" + CurMinutes;
	}
	mytime = mytime + ":" + CurMinutes;
	var CurSeconds = Today.getSeconds();
	if (CurSeconds <= 9) {
		CurSeconds = "0" + CurSeconds;
	}
	mytime = mytime + ":" + CurSeconds;
	var Today = getNowFormatDate();
	var myBirth = $("#Birth").val();
	if (myBirth == Today) {
		var BirthTime = $("#BirthTime").val();
		if (BirthTime != "") {
			if (BirthTime.split(":").length == 2) {
				BirthTime = BirthTime + ":00"
			}
		}
		BirthTime = BirthTime.replace(/:/g, "")
		mytime = mytime.replace(/:/g, "")
		if (parseInt(BirthTime) > parseInt(mytime)) {
			return true
		} else {
			return false
		}
	}
	return false;
}
function getNowFormatDate() {
	var date = new Date();
	var seperator1 = "-";
	var month = date.getMonth() + 1;
	var strDate = date.getDate();
	if (month >= 1 && month <= 9) {
		month = "0" + month;
	}
	if (strDate >= 0 && strDate <= 9) {
		strDate = "0" + strDate;
	}
	if (ServerObj.dtformat == "YMD") {
		var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
	}
	if (ServerObj.dtformat == "DMY") {
		var seperator1 = "/";
		var currentdate = strDate + seperator1 + month + seperator1 + date.getFullYear()
	}
	return currentdate;
}
//��ȡ����--�������Ƚ�
function AgeForYear(strBirthday) {
	if (ServerObj.dtformat == "YMD") {
		var strBirthdayArr = strBirthday.split("-");
		var birthYear = strBirthdayArr[0];
		var birthMonth = strBirthdayArr[1];
		var birthDay = strBirthdayArr[2];
	}
	if (ServerObj.dtformat == "DMY") {
		var strBirthdayArr = strBirthday.split("/");
		var birthYear = strBirthdayArr[2];
		var birthMonth = strBirthdayArr[1];
		var birthDay = strBirthdayArr[0];
	}
	var d = new Date();
	var nowYear = d.getFullYear();
	var nowMonth = d.getMonth() + 1;
	var nowDay = d.getDate();
	var ageDiff = nowYear - birthYear; //��֮��
	return ageDiff
}
function OtherSpecialCheckData() {
	var myVer = ServerObj.ConfigVersion;
	switch (myVer) {
		case "7":
			var myAge = $("#Age").val();
			if (isNaN(myAge)) { myAge = 0 };
			if (myAge < 14) {
				var myForeignName = $("#ForeignName").val();
				if (myForeignName == "") {
					if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
					$.messager.alert("��ʾ", "14������,��ϵ���Ǳ�����Ŀ!", "info", function () {
						$("#ForeignName").focus();
					});
					return false;
				}
				if (PageLogicObj.m_IsNotStructAddress == "Y") {
					var myAddress = $("#Address").combobox("getText");
					if (myAddress == "") {
						if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
						$.messager.alert("��ʾ", "14������, ��ַ�Ǳ�����Ŀ!", "info", function () {
							$('#Address').next('span').find('input').focus();
						});
						return false;
					}
				} else {
					var myAddress = $("#Address").val();
					if (myAddress == "") {
						if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
						$.messager.alert("��ʾ", "14������, ��ַ�Ǳ�����Ŀ!", "info", function () {
							$("#Address").focus();
						});
						return false;
					}
				}
				var myTelHome = $("#TelHome").val();
				if (myTelHome == "") {
					if (!BaseInfoIsExpand()) BBaseInoCollapsClick();
					$.messager.alert("��ʾ", "14������, ��ϵ�绰�Ǳ�����Ŀ!", "info", function () {
						$("#TelHome").focus();
					});
					return false;
				}
			}
			break;
		default:
			break;
	}
	return true;
}
function IsNumber(string, sign) {
	var number;
	if (string == null) return false;
	if ((sign != null) && (sign != '-') && (sign != '+')) {
		return false;
	}
	number = new Number(string);
	if (isNaN(number)) {
		return false;
	} else if ((sign == null) || (sign == '-' && number < 0) || (sign == '+' && number > 0)) {
		return true;
	} else
		return false;
}
function PatInfoUnique() {
	var myoptval = $("#CardTypeDefine").combobox("getValue");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	var Name = $("#Name").val();
	var Sex = $("#Sex").combobox("getValue");
	var Birth = $('#Birth').val();
	var Tel = $("#TelHome").val();
	var PAPMIRowID = $("#PAPMIRowID").val()
	var rtn = $.cm({
		ClassName: "web.DHCPATCardUnite",
		MethodName: "GetPatByInfo",
		CardType: myCardTypeDR,
		Name: Name,
		Sex: Sex,
		Birth: Birth,
		Tel: Tel,
		PAPMIRowID: PAPMIRowID,
		dataType: "text"
	}, false)
	var RtnArr = rtn.split("^")
	if (RtnArr[0] == "0") {
		return true;
	} else if (RtnArr[0] == "S") {
		$.messager.alert('��ʾ', '�˿����͡��������Ա𡢳������ڡ���ϵ�绰��Ϣ���ѹ�ʧ��' + RtnArr[1] + ',�����ϴ˿������½���');
		return false;
	} else if (RtnArr[0] == "N") {
		$.messager.alert('��ʾ', '�˿����͡��������Ա𡢳������ڡ���ϵ�绰��Ϣ�󶨿�' + RtnArr[1] + ',��������������߲���');
		return false;
	}
	return true;
}
function BirthCheck() {
	var mybirth = $("#Birth").val();
	if ((mybirth == "") || ((mybirth.length != 8) && ((mybirth.length != 10)))) {
		$.messager.alert("��ʾ", "��������ȷ�ĳ�������!", "info", function () {
			$("#Birth").focus();
		});
		return false;
	} else {
		$("#Birth").removeClass("newclsInvalid");
	}
	if ((mybirth.length == 8)) {
		if (ServerObj.dtformat == "YMD") {
			var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8)
		}
		if (ServerObj.dtformat == "DMY") {
			var mybirth = mybirth.substring(6, 8) + "/" + mybirth.substring(4, 6) + "/" + mybirth.substring(0, 4)
		}
		$("#Birth").val(mybirth);
	}
	if (ServerObj.dtformat == "YMD") {
		var myrtn = DHCWeb_IsDate(mybirth, "-")
	}
	if (ServerObj.dtformat == "DMY") {
		var myrtn = DHCWeb_IsDate(mybirth, "/")
	}
	if (!myrtn) {
		$.messager.alert("��ʾ", "��������ȷ�ĳ�������!", "info", function () {
			$("#Birth").focus();
		});
		return false;
	} else {
		$("#Birth").removeClass("newclsInvalid");
	}
	return true;
}
function GetPatMasInfo() {
	var myxml = "";
	if (PageLogicObj.m_PatMasFlag == "Y") {
		var myparseinfo = $("#InitPatMasEntity").val();
		var myxml = GetEntityClassInfoToXML(myparseinfo)
	}
	return myxml;
}
function GetCardRefInfo() {
	var myxml = "";
	if (PageLogicObj.m_CardRefFlag == "Y") {
		var myparseinfo = $("#InitCardRefEntity").val();
		var myxml = GetEntityClassInfoToXML(myparseinfo)
	}
	return myxml;
}
function GetCardINVInfo() {
	var myxml = "";
	if (PageLogicObj.m_CardRefFlag == "Y") {
		var myparseinfo = $("#InitCardINVPRTEntity").val();
		var myxml = GetEntityClassInfoToXML(myparseinfo)
	}
	return myxml;
}
function GetAccManagerInfo() {
	var myxml = "";
	if (PageLogicObj.m_AccManagerFlag == "Y") {
		var myparseinfo = $("#InitAccManagerEntity").val();
		var myxml = GetEntityClassInfoToXML(myparseinfo)
	}
	return myxml;
}
function GetPreDepositeInfo() {
	var myxml = "";
	if (PageLogicObj.m_AccManagerFlag == "Y") {
		var myparseinfo = $("#InitAccPreDepositEncrypt").val();
		var myxml = GetEntityClassInfoToXML(myparseinfo)
	}
	return myxml;
}
function GetEntityClassInfoToXML(ParseInfo) {
	var myxmlstr = "";
	try {
		var myary = ParseInfo.split("^");
		var xmlobj = new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for (var myIdx = 1; myIdx < myary.length; myIdx++) {
			xmlobj.BeginNode(myary[myIdx]);
			var _$id = $("#" + myary[myIdx]);
			if (_$id.length == 0) {
				var myval = "";
			} else {
				//if (_$id.hasClass("hisui-combobox")){
				if (_$id.next().hasClass('combo')) {
					if ((myary[myIdx] == "RegisterPlace") || (myary[myIdx] == "Address")) {
						var myval = _$id.combobox("getText");
					} else {
						var myval = _$id.combobox("getValue");
						if (myval == undefined) myval = "";
						//��ֹ���Ϳ����͡�֧����ʽid���Ѵ�����ʽ����
						if (myval != "") {
							myval = myval.split("^")[0];
						}
					}
				} else if (_$id.hasClass("hisui-switchbox")) {
					var Val = _$id.switchbox("getValue");
					var myval = Val ? "Y" : "N"
				} else {
					if (PageLogicObj.m_IsNotStructAddress == "Y") {
						if ((myary[myIdx] == "RegisterPlace") || (myary[myIdx] == "Address")) {
							var myval = _$id.combobox("getText");
						} else {
							var myval = _$id.val();
						}
					} else {
						var myval = _$id.val();
					}
					if (myary[myIdx] == "PhotoInfo") {
						myval = "";
					}
				}
			}
			xmlobj.WriteString(myval);
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	} catch (Err) {
		$.messager.alert("��ʾ", "Error: " + Err.description);
	}
	return myxmlstr;
}
function WrtCard() {
	var myPAPMINo = $("#PAPMINo").val();
	var mySecrityNo = $.cm({
		ClassName: "web.UDHCAccCardManage",
		MethodName: "GetCardCheckNo",
		dataType: "text",
		PAPMINo: myPAPMINo
	}, false);
	if (mySecrityNo != "") {
		var rtn = DHCACC_WrtMagCard("3", "", mySecrityNo, PageLogicObj.m_CCMRowID);
		if (rtn != "0") {
			return "-1^"
		}
	} else {
		return "-1^";
	}
	return "0^" + mySecrityNo
}
function PatRegPatInfoPrint(RowIDStr, CurXMLName, EncryptItemName) {
	if (CurXMLName == "") {
		return;
	}
	var INVtmp = RowIDStr.split("^");
	if (INVtmp.length > 0) {
		DHCP_GetXMLConfig("DepositPrintEncrypt", CurXMLName);
	}
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = $("#" + EncryptItemName).val();
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", CurXMLName, INVtmp[invi], Guser, myExpStr);
		}
	}
}
function InvPrintNew(TxtInfo, ListInfo) {
	var HospName = $("#HospName").val();
	var PDlime = String.fromCharCode(2);
	var TxtInfo = TxtInfo + "^" + "HospName3" + PDlime + HospName;
	var TxtInfo = TxtInfo + "^" + "hospitalDesc" + PDlime + HospName;
	//var myPAName=$("#Name").val();
	//TxtInfo=TxtInfo+"^"+"PatName"+PDlime+myPAName;
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	DHC_PrintByLodop(getLodop(), TxtInfo, ListInfo, "", "");
}
function CheckComboxSelData(id, selId) {
	var Find = 0;
	var Data = $("#" + id).combobox('getData');
	for (var i = 0; i < Data.length; i++) {
		var CombValue = Data[i].id;
		var CombDesc = Data[i].text;
		if (selId == CombValue) {
			selId = CombValue;
			Find = 1;
			break;
		}
	}
	if (Find == "1") return selId
	return "";
}
function SetCardNOLength() {
	var CardNo = $("#CardNo").val();
	if ((PageLogicObj.m_CardNoLength != 0) && (CardNo.length > PageLogicObj.m_CardNoLength)) {
		$.messager.confirm('��ʾ', '����λ�����ڿ���������λ��,�Ƿ��ȡ?', function (r) {
			if (r) {
				GetPatByCardNo();
			} else {
				return false;
			}
		});
	} else {
		GetPatByCardNo();
	}
	function GetPatByCardNo() {
		if ((CardNo.length < PageLogicObj.m_CardNoLength) && (PageLogicObj.m_CardNoLength != 0)) {
			for (var i = (PageLogicObj.m_CardNoLength - CardNo.length - 1); i >= 0; i--) {
				CardNo = "0" + CardNo;
			}
		}
		if ((CardNo.length > PageLogicObj.m_CardNoLength) && (PageLogicObj.m_CardNoLength != 0)) {
			PageLogicObj.m_CardSecrityNo = CardNo.substring(PageLogicObj.m_CardNoLength, CardNo.length);
			CardNo = CardNo.substring(0, PageLogicObj.m_CardNoLength);
		}
		$("#CardNo").val(CardNo);
		PageLogicObj.m_CardVerify = "";
		GetValidatePatbyCard();
	}
	return true;
}
function createModalDialog(id, _title, _width, _height, _icon, _btntext, _content, _event) {
	$("body").append("<div id='" + id + "' class='hisui-dialog'></div>");
	if (_width == null)
		_width = 800;
	if (_height == null)
		_height = 500;
	$("#" + id).dialog({
		title: _title,
		width: _width,
		height: _height,
		cache: false,
		iconCls: _icon,
		//href: _url,
		collapsible: false,
		minimizable: false,
		maximizable: false,
		resizable: false,
		modal: true,
		closed: false,
		closable: true,
		content: _content,
		onClose: function () {
			destroyDialog(id);
		}
	});
}
function destroyDialog(id) {
	//�Ƴ����ڵ�Dialog
	$("body").remove("#" + id);
	$("#" + id).dialog('destroy');
}
//�жϻ�����Ϣ�Ƿ�ȫ��չ��
function BaseInfoIsExpand() {
	if ($(".baseinfo").css("display") == "none") {
		return false;
	}
	return true;
}
//�жϵ�ַ��Ϣ�Ƿ�ȫ��չ��
function AddressInfoIsExpand() {
	if ($(".addressinfo").css("display") == "none") {
		return false;
	}
	return true;
}
//�жϽɷ���Ϣ�Ƿ�ȫ��չ��
function PayInfoIsExpand() {
	if ($(".payinfo").css("display") == "none") {
		return false;
	}
	return true;
}
function CardSearchDBClickHander(row) {
	var myPatientID = row['TPatientID'];
	var Regno = row['RegNo'];
	var OtherCardNo = row['OtherCardNo'];
	$("#PAPMINo").val(row['RegNo']);
	GetPatDetailByPAPMINo();
	var CardNO = row['CardNO'];
	if (CardNO.indexOf(",") < 0) {
		var CardType = $.cm({
			ClassName: "web.DHCPATCardUnite",
			MethodName: "ReadCardTypeByDesc",
			Desc: CardNO,
			dataType: "text"
		}, false)
		$("#CardTypeDefine").combobox('select', CardType);
		var CardNo = CardNO.split(" ")[1];
		var IsTemporaryCard = InitTemporaryCard(CardNo);
		if (IsTemporaryCard == "Y") {
			$("#CardNo").val(CardNo);
		}
	} else {
		$.messagert.alert("��ʾ", "����ӵ�в�ֹһ�ֿ�,��ѡ����Ҫ�޸ĵĶ�Ӧ������!")
	}
	//��������֤����Ϣ
	CardTypeSave(OtherCardNo);
	//��������ʹ�õǼǺ���Ϊ���ţ���֤���ŵ���Ч��
	CheckForUsePANoToCardNO("Modify");
}

//cache�������Լ�ֵ�Ե���ʽ�洢���ǵĻ�������
var cache = {};
//index�����иô洢�������������˳�򣬿��Է������������������Ĵ���
var index = [];
function createCache() {
	return function (key, value) {
		//�������ֵ����˵��������ֵ
		if (value !== undefined) {
			//�����ݴ���cache����������
			cache[key] = value;
			//��������index�����У��Ժ�cache�е����ݽ��ж�Ӧ
			index.push(key);

			//�жϻ����е����������ǲ��ǳ���������
			if (index.length >= 150) {
				//�������������
				//ɾ��������洢���������
				//������뻺������ݵļ�����index����ĵ�һλ
				//ʹ�������shift�������Ի�ȡ��ɾ��������ĵ�һ��Ԫ��
				var tempKey = index.shift();
				//��ȡ��������뻺���������ݵļ�������ʹ���������ݴӻ������ɾ��
				delete cache[tempKey];
			}
		}
		return cache[key];
	}
}
function SaveCahce() {
	var typeCache = createCache();
	var $txt = $(".textbox");
	for (var i = 0; i < $txt.length; i++) {
		var id = $txt[i]['id'];
		var _$label = $("label[for=" + id + "]");
		if (_$label.length == 1) {
			var text = _$label[0].innerHTML;
			typeCache(id, text);
		}
	}
	$.cm({
		ClassName: "web.DHCBL.CARD.UCardPATRegConfig",
		MethodName: "SaveCardRegDOMCache",
		dataType: "text",
		obj: JSON.stringify(cache)
	}, function (rtn) { });
}
///����Ԫ�ص�classname��ȡԪ��ֵ
function getValue(id) {
	var className = $("#" + id).attr("class")
	if (typeof className == "undefined") {
		return $("#" + id).val()
	}
	if (className.indexOf("hisui-lookup") >= 0) {
		var txt = $("#" + id).lookup("getText")
		//����Ŵ��ı����ֵΪ��,�򷵻ؿ�ֵ
		if (txt != "") {
			var val = $("#" + id).val()
		} else {
			var val = ""
			$("#" + id + "Id").val("")
		}
		return val
	} else if (className.indexOf("combobox-f") >= 0) { //hisui-combobox
		var val = $("#" + id).combobox("getValue")
		if (typeof val == "undefined") val = ""
		return val
	} else if (className.indexOf("hisui-datebox") >= 0) {
		return $("#" + id).dateboxq("getValue")
	} else {
		return $("#" + id).val()
	}
	return ""
}
function setFocus(id) {
	var className = $("#" + id).attr("class")
	if (typeof className == "undefined") {
		$("#" + id).focus();
	}
	if (("^hisui-lookup^hisui-combobox^hisui-datebox^combobox-f").indexOf(("^" + className + "^")) >= 0) {
		$("#" + id).next('span').find('input').focus();
	} else {
		$("#" + id).focus();
	}
}
function DOMFocusJump(myComName) {
	var myComIdx = find(PageLogicObj.m_CardRegJumpSeqArr, myComName)
	if (myComIdx >= 0) {
		if (myComIdx == (PageLogicObj.m_CardRegJumpSeqArr.length - 1)) {
		} else {
			var id = PageLogicObj.m_CardRegJumpSeqArr[myComIdx + 1]['id'];
			if (id == "PAPMINo") {
				if ($("#PAPMINo").val() != "") {
					DOMFocusJump("PAPMINo");
					return;
				}
			}
			if (id != "undefined") {
				var _$id = $("#" + id);
				//if (_$id.hasClass("hisui-combobox")){
				if (_$id.next().hasClass('combo')) {
					_$id.next('span').find('input').focus();
				} else {
					_$id.focus();
				}

			}
		}
		return false;
	} else {
		return true;
	}
	function find(list, elem) {
		var index = -1;
		for (var i = 0; i < list.length; i++) {
			var current = list[i];
			if (elem == current['id']) {
				index = i;
				break;
			}
		}
		return index;
	}
}
///�������֤�Ÿ�ֵ�ṹ����ַ��Ϣ
function BuildAddressByIDCard(IDCard) {
	$.cm({
		ClassName: "web.DHCDocCommon",
		MethodName: "GetAddrInfoByCredNo",
		CredNo: IDCard,
		dataType: "text"
	}, function (Data) {
		if (Data == "") return;
		var DataArr = Data.split("!")
		var ProvInfo = DataArr[0]
		var CityInfo = DataArr[1]
		var AreaInfo = DataArr[2]
		if (ServerObj.BuildAddrHomeByIDCard == "Y") {
			if ($("#CountryHome").combobox('getData').length == 0) {
				LoadCountryData("CountryHome");
			}
			$("#CountryHome").combobox('select', 1)
			$("#ProvinceHome").combobox('select', ProvInfo.split("^")[0])
			$("#CityHome").combobox('select', CityInfo.split("^")[0])
		}
		if (ServerObj.BuildAddrBirthByIDCard == "Y") {
			if ($("#CountryBirth").combobox('getData').length == 0) {
				LoadCountryData("CountryBirth");
			}
			$("#CountryBirth").combobox('select', 1)
			$("#ProvinceBirth").combobox('select', ProvInfo.split("^")[0])
			$("#CityBirth").combobox('select', CityInfo.split("^")[0])
			$("#AreaBirth").combobox('select', AreaInfo.split("^")[0])
		}
		if (ServerObj.BuildAddrLookUpByIDCard == "Y") {
			if ($("#CountryHouse").combobox('getData').length == 0) {
				LoadCountryData("CountryHouse");
			}
			$("#CountryHouse").combobox('select', 1)
			$("#ProvinceInfoLookUpRowID").combobox('select', ProvInfo.split("^")[0])
			$("#CityDescLookUpRowID").combobox('select', CityInfo.split("^")[0])
			$("#CityAreaLookUpRowID").combobox('select', AreaInfo.split("^")[0])
		}
		if (ServerObj.BuildAddrHouseByIDCard == "Y") {
			if ($("#CountryDescLookUpRowID").combobox('getData').length == 0) {
				LoadCountryData("CountryDescLookUpRowID");
			}
			$("#CountryDescLookUpRowID").combobox('select', 1)
			$("#ProvinceHouse").combobox('select', ProvInfo.split("^")[0])
			$("#Cityhouse").combobox('select', CityInfo.split("^")[0])
			$("#AreaHouse").combobox('select', AreaInfo.split("^")[0])
		}
	})
}
function ExtendComboxEvent() {
	$.extend(true, $.fn.combobox.defaults, {
		keyHandler: {
			left: function (e) {
				return false;
			},
			right: function (e) {
				return false;
			},
			up: function (e) {
				nav(this, 'prev');
				e.preventDefault();
			},
			down: function (e) {
				var Data = $(this).combobox("getData");
				var CurValue = $(this).combobox("getValue");
				if ($(this).combobox('panel').is(":hidden")) {
					$(this).combobox('showPanel');
					return false;
				}
				nav(this, 'next');
				e.preventDefault();
			},
			query: function (q, e) {
				_8c0(this, q);
			},
			enter: function (e) {
				_8c5(this);
				var id = $(this)[0].id;
				return DOMFocusJump(id);
			}
		}
	});
	/*$HUI.combobox(".combobox-f", { //.hisui-combobox
		keyHandler:{
			left: function (e) {
				return false;
			},
			right: function (e) {
				return false;
			},
			up: function (e) {
				nav(this,'prev');
				e.preventDefault();
			 },
			 down: function (e) {
					var Data=$(this).combobox("getData");
				var CurValue=$(this).combobox("getValue");
				if ($(this).combobox('panel').is(":hidden")){
					$(this).combobox('showPanel');
					return false;
				}
				nav(this,'next');
				e.preventDefault();
			},
			query: function (q, e) {
				_8c0(this, q);
			},
			enter: function (e) { 
				_8c5(this);
				var id=$(this)[0].id;
				return DOMFocusJump(id);
			}
		}
	})*/
}
function SetCountryComboxData(comboId, CountryId) {
	if (comboId == "") return;
	if (CountryId == "") {
		$("#" + comboId).combobox('setValue', "").combobox('setText', text);
		return;
	}
	var CountryDataJson = JSON.parse(ServerObj.DefaultCTCountryPara);
	for (var k = 0; k < CountryDataJson.length; k++) {
		if (CountryDataJson[k]['id'] == CountryId) {
			var text = CountryDataJson[k]['text'];
			var AliasStr = CountryDataJson[k]['AliasStr'];
			break;
		}
	}
	$("#" + comboId).combobox('setValue', CountryId).combobox('setText', text);
}
function LoadPatInfoByRegNo() {
	if (ServerObj.PatientNoReg != "") {
		$("#PAPMINo").val(ServerObj.PatientNoReg);
		PAPMINoOnblur();
		ServerObj.PatientNoReg = "";
		if (typeof (history.pushState) === 'function') {
			//��ֹ�Ҽ�ˢ�º�ҽ���ظ�����
			var Url = window.location.href;
			var NewUrl = rewriteUrl(Url, { PatientNoReg: "" });
			history.pushState("", "", NewUrl);
		}
	}
}

// DHCPEOrderSets.Main.HISUITree.js
// by zhongricheng

var WIDTH = $(document).width();
var ItemType = "N", LisType = "N", MedType = "N", OtherType = "N";
$("#OrderSetsSearch").css("width", WIDTH*0.5);

$(function() {
	InitCombobox();
	InitARCOSDataGrid();
	
	//InitARCOSDetailDataGrid();
	
	// ��ʼ����Ŀ
	//InitItemDataGrid("#QryRisItemList","Item");
	//InitItemDataGrid("#QryLisItemList","Lab");
	//InitItemDataGrid("#QryMedicalItemList","Medical");
	//InitItemDataGrid("#QryOtherItemList","Other");
	
	$("#BSearchRisItem").click(function() {
		BSearchItem_click("R");
    });
    $("#RisItem").keydown(function(e) {
		if(e.keyCode==13){
			BSearchItem_click("R");
		}
	});
    
    $("#BSearchLisItem").click(function() {
		BSearchItem_click("L");
    });
    $("#LisItem").keydown(function(e) {
		if(e.keyCode == 13){
			BSearchItem_click("L");
		}
	});
    
    $("#BSearchMedicalItem").click(function() {
		BSearchItem_click("M");
    });
    $("#MedicalItem").keydown(function(e) {
		if(e.keyCode == 13){
			BSearchItem_click("M");
		}
	});
    
    $("#BSearchOtherItem").click(function() {
		BSearchItem_click("O");
    });
    $("#OtherItem").keydown(function(e) {
		if(e.keyCode == 13){
			BSearchItem_click("O");
		}
	});
});

// ��ʼ���ؼ�
function InitCombobox() {
	$.cm({
		ClassName:"web.DHCPE.HISUIOrderSets",
		MethodName:"GetARCItemCatID"
	},function(Data){
		$("#Category").val("ҽ����");
		$("#csubCatID").val(Data.ARCItemCatDesc);
		$("#subCatID").val(Data.ARCItemCatID);
	});
	
	// VIP�ȼ�	
	$HUI.combobox("#OrderSetVIPWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=SearchVIPLevel&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		allowNull:true,
		panelHeight:"auto",
		editable:false
	});
	
	// �Ա�	
	$HUI.combobox("#OrderSetSexWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'����'},
			{id:'1',text:'��'},
			{id:'2',text:'Ů'}
		]
	});
	
	// ����
	$HUI.combobox("#Conditiones", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1',text:'����'},
			{id:'2',text:'����',selected:'true'},
			{id:'3',text:'ȫԺ'}
		]
	});
	
	// ����
	$HUI.combobox("#ConditionesWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1', text:'����'},
			{id:'2', text:'����', selected:'true'},
			{id:'3', text:'ȫԺ'}
		]
	});
	
	// ���ÿ���	
	$HUI.combobox("#OSLocWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=QueryLoc&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		defaultFilter:4,
		onSelect:function(record) {   // ѡ������
		}
	});
	
	// ��������
	$HUI.combobox("#OrderSetsPGBIWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=QueryPGBI&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		defaultFilter:4,
		onSelect:function(record) {   // ѡ������
		},
		onLoadSuccess:function(data) {
		}
	});
		
	// վ��
	$HUI.combobox("#Station", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onSelect:function(record){
			$("#QryRisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#RisItem").val(),StationID:record.id}); 
		}
	});
	
	$HUI.tabs("#QryItem", {
		onSelect:function(title, index) {
			if (title == "�����Ŀ" && ItemType == "N") {
				InitItemDataGrid("#QryRisItemList","Item");
				ItemType = "Y";
			} else if (title == "������Ŀ" && LisType == "N") {
				InitItemDataGrid("#QryLisItemList","Lab");
				LisType = "Y";
			} else if (title == "ҩƷ��Ŀ" && MedType == "N") {
				InitItemDataGrid("#QryMedicalItemList","Medical");
				MedType = "Y";
			} else if (title == "������Ŀ" && OtherType == "N") {
				InitItemDataGrid("#QryOtherItemList","Other");
				OtherType = "Y";
			}
						
		}
	});
}

// ****************************************************�ײ�ά��********************************************************************** //

// ��ʼ��ҽ���ױ��
function InitARCOSDataGrid() {
	$HUI.treegrid("#OrderSetsList", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:session["LOGON.USERID"],  // $.session.get('USERID'),
			subCatID:$("#subCatID").val(),
			Conditiones:$("#Conditiones").combobox('getValue')
		},
		method: 'get',
		idField: 'ARCOSRowid',
		treeField: 'ARCOSOrdSubCat',
		columns:[[
			{field:'ARCOSRowid', title:'RowId', hidden:true},
			{field:'ARCOSOrdCatDR', title:'ARCOSOrdCatDR', hidden:true}, // ����ID
			{field:'ARCOSOrdSubCatDR' ,title:'ARCOSOrdSubCatDR', hidden:true},  // ����ID
			{field:'ARCOSEffDateFrom', title:'��Ч����', hidden:true},
			{field:'FavRowid', title:'FavRowid', hidden:true},
			{field:'FavUserDr', title:'FavUserDr', hidden:true},  // �û�
			{field:'FavDepDr', title:'FavDepDr', hidden:true},  // ����
			{field:'MedUnit', title:'MedUnit', hidden:true},  // ��
		
			{field:'OSExBreak', title:'OSExBreak', hidden:true},  // ���
			{field:'OSExSex', title:'OSExSex', hidden:true},  // �Ա�
			{field:'OSExDeit', title:'OSExDeit', hidden:true},  // ���
			{field:'OSLoc', title:'OSLoc', hidden:true},    // ���ÿ���
			{field:'OSExVIPLevel', title:'OSExVIPLevel', hidden:true},  // VIPID
			{field:'OSExPGBId', title:'OSExPGBId', hidden:true},   // ����
			
			{field:'ARCOSOrdCat', title:'����', hidden:true},
			
			{field:'ARCOSOrdSubCat', title:'����', width:200,},
			{field:'ARCOSCode',title:'����',align:'center'},
			{field:'ARCOSDesc',title:'����'},
			{field:'ARCOSAlias',title:'����',align:'center'},
			
			{field:'BreakDesc', title:'���', align:'center'},  // ���
			{field:'SexDesc', title:'��Ӧ�Ա�', align:'center'},  // �Ա�
			{field:'VIPDesc',title:'�ײ͵ȼ�'},
			{field:'DeitDesc',title:'���', align:'center'},
			{field:'LocDesc',title:'���ÿ���'},
			{field:'PGDesc',title:'��������'},  
			{field:'OSExPrice',title:'�ײͼ۸�', align:'right'},  // �۸�

			//{field:'FavUserDesc', title:'�û�', hidden:true},
			//{field:'FavDepDesc', title:'ά������', hidden:true},
			//{field:'MedUnitDesc', title:'����', hidden:true},
			
			/*
			{field:'IsBreakable',title:'����',formatter:function(value,rowData,rowIndex){
				return "<a href='#' onclick='DeleteARCOS("+rowData.ARCOSRowid+")'>\
							<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
						</a>";
				}
			},
			*/
		]],
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		fit:true,
		animate:true,
		//pagination:true,   // ���α�� ���ܷ�ҳ
		//pageSize:10,
		//pageList:[10,15,20,25,50,100],
		singleSelect:true,
		toolbar: [{
			iconCls: 'icon-search',
			text:'��ѯ',
			handler: function(){
				BSearch_click();
			}
		},{
			iconCls: 'icon-add',
			text:'����',
			handler: function(){
				BClear_click("1");
				$("#OrderSetsWin").show();
				
				$.cm({
					ClassName:"web.DHCPE.HISUIOrderSets",
					MethodName:"GetARCItemCatID"
				},function(Data){
					$("#CategoryWin").val("ҽ����");
					$("#csubCatIDWin").val(Data.ARCItemCatDesc);
					$("#CategoryIDWin").val(Data.Category);
					$("#subCatIDWin").val(Data.ARCItemCatID);
				});
				
				// ����
				var ARCOSCode=getnum(7);
				if ($("#CodeWin")) { $("#CodeWin").val(ARCOSCode); }
				
				$("#OrderSetsPGBIWin").combobox("setValue","UN");
					 
				var myWin = $HUI.dialog("#OrderSetsWin",{
					iconCls:'icon-w-add',
					resizable:true,
					title:'����',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'����',
						handler:function(){
							BAdd_click("Add");
						}
					},{
						text:'�ر�',
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		},{
			iconCls: 'icon-edit',
			text:'�޸�',
			id:'BUpd',
			disabled:true,
			handler: function(){
				$("#OrderSetsWin").show();
				
				var SelRowData = $("#OrderSetsList").treegrid("getSelected");
				$("#CategoryWin").val(SelRowData.ARCOSOrdCat);
				$("#csubCatIDWin").val(SelRowData.ARCOSOrdSubCat);
				$("#CategoryIDWin").val(SelRowData.ARCOSOrdCatDR);
				$("#subCatIDWin").val(SelRowData.ARCOSOrdSubCatDR);
				
				$("#CodeWin").val(SelRowData.ARCOSCode);  // ����
				$("#DescWin").val(SelRowData.ARCOSDesc);  // ����
				$("#AliasWin").val(SelRowData.ARCOSAlias);  // ����
				
				// ����  
				var InUser = SelRowData.FavUserDr;
				var FavDepList = SelRowData.FavDepDr;
				var DocMedUnit = SelRowData.MedUnit;
				var Conditiones="";
				if (InUser == "") {
					if (FavDepList == "") {
						if (DocMedUnit == "") { Conditiones = "3"; }
					} else {
						if (DocMedUnit == "") { Conditiones = "2"; }
					}
				} else {
					if (FavDepList == "") {
						if (DocMedUnit == "") { Conditiones = "1"; }
					} else {
						if (DocMedUnit != "") { Conditiones = "4"; }
					}
				}
				if (Conditiones == "") Conditiones = "2";
				$("#ConditionesWin").combobox("setValue", Conditiones);
				var iOSExVIPLevel=SelRowData.OSExVIPLevel;
				$("#OrderSetVIPWin").combobox("setValues", iOSExVIPLevel.split(","));  // VIP�ȼ�
				$("#OrderSetSexWin").combobox("setValue", SelRowData.OSExSex);  // �Ա�
				if (SelRowData.OSExBreak == "Y") $("#IsBreakWin").checkbox("setValue", true);  // ���
				else $("#IsBreakWin").checkbox("setValue", false);
				if (SelRowData.OSExDeit == "Y") $("#IsDeitWin").checkbox("setValue", true);  // ���
				else $("#IsDeitWin").checkbox("setValue", false);
				
				var PGBI = SelRowData.OSExPGBId;
				if (PGBI == "") PGBI = "UN";
				$("#OrderSetsPGBIWin").combobox("setValue", PGBI);  // ����
				
				var myWin = $HUI.dialog("#OrderSetsWin",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'�޸�',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'�޸�',
						handler:function(){
							BAdd_click("Upd");
						}
					},{
						text:'�ر�',
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		},{
			iconCls: 'icon-remove',
			text:'ɾ��',
			id:'BDel',
			disabled:true,
			handler: function(){
				BDel_click();
			}
		},{
			iconCls: 'icon-remove',
			text:'����',
			handler: function(){
				BClear_click("0");
			}
		},{
			iconCls: 'icon-house',
			text:'���ÿ���',
			id:'BLoc',
			disabled:true,
			handler: function(){
				$("#OrderSetsLocWin").show();
				
				$("#OSLocWin").combobox("setValue","");
				
				var SelRowData = $("#OrderSetsList").treegrid("getSelected");
				InitARCOSLocDataGrid(SelRowData.ARCOSRowid);
				
				var myWin = $HUI.dialog("#OrderSetsLocWin",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'���ÿ���ά��',
					modal:true,
					onClose: function() {
						$("#AddOSLocBtnWin").unbind("click");
						$("#DelOSLocBtnWin").unbind("click");
						$("#CloseOSLocBtnWin").unbind("click");
					},
					onOpen: function () {
						$("#AddOSLocBtnWin").click(function() { BUpdLoc_click("1"); });
						$("#DelOSLocBtnWin").click(function() { BUpdLoc_click("0"); });
						$("#CloseOSLocBtnWin").click(function() { myWin.close(); });
					}
				});
			}
		},{
			iconCls: 'icon-show-set',
			text:'�����ײ�',
			id:'BWebOS',
			disabled:true,
			handler: function(){
				BSelWeb_click();
			}
		}],		
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼� 	
			if ( rowData._parentId != "" ) {
				InitARCOSDetailDataGrid(rowData.ARCOSRowid);  // ҽ����ϸ  
				
				//$('#OrderSets').layout("collapse","west");  // �۵��¼�
				//$('#OrderSets').layout("expand","east");  // չ���¼�
				//$('#OrderSets').layout("expand","south");
				
				// ��ʼ����Ŀ
				ItemType = "N", LisType = "N", MedType = "N", OtherType = "N";
				var tab = $("#QryItem").tabs("getSelected");
				var title = tab.panel("options").title;
				if (title == "�����Ŀ" && LisType == "N") {
					InitItemDataGrid("#QryRisItemList","Item");
					ItemType = "Y";
				} else if (title == "������Ŀ" && LisType == "N") {
					InitItemDataGrid("#QryLisItemList","Lab");
					LisType = "Y";
				} else if (title == "ҩƷ��Ŀ" && MedType == "N") {
					InitItemDataGrid("#QryMedicalItemList","Medical");
					MedType = "Y";
				} else if (title == "������Ŀ" && OtherType == "N") {
					InitItemDataGrid("#QryOtherItemList","Other");
					OtherType = "Y";
				}
				//InitItemDataGrid("#QryRisItemList","Item");
				//InitItemDataGrid("#QryLisItemList","Lab");
				//InitItemDataGrid("#QryMedicalItemList","Medical");
				//InitItemDataGrid("#QryOtherItemList","Other");
				
		       	$("#Code").val(rowData.ARCOSCode);
		       	$("#Desc").val(rowData.ARCOSDesc);
		       	$("#Alias").val(rowData.ARCOSAlias);
				
				$('#BUpd').linkbutton('enable');
				$('#BDel').linkbutton('enable');
				$('#BLoc').linkbutton('enable');
				$('#BWebOS').linkbutton('enable'); 
			} else {
				$("#OrderSetsDetailList").datagrid('loadData',{total:0,rows:[]});
				
				BClear_click("0");
				
				$('#BUpd').linkbutton('disable');
				$('#BDel').linkbutton('disable');
				$('#BLoc').linkbutton('disable');
				$('#BWebOS').linkbutton('disable');
			}
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
			$("#OrderSetsList").treegrid("toggle",rowData.ARCOSRowid);
			
			//$("#OrderSetsDetailList").datagrid('loadData',{total:0,rows:[]});
		},
		onLoadSuccess:function(data){
			
		}
	});
}

// ��ѯ
function BSearch_click(){
	// $.messager.alert("��ʾ","Search");
	// �ײ��б�
	$HUI.treegrid("#OrderSetsList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:session['LOGON.USERID'],  // $.session.get('USERID'),
			subCatID:$("#subCatID").val(),
			Conditiones:$("#Conditiones").combobox('getValue'),
			Code:$("#Code").val(),
			Desc:$("#Desc").val(),
			Alias:$("#Alias").val()
		}
	});
}

// ����
function BAdd_click(type){
	// $.messager.alert("��ʾ","Add");
	if ( type == "Upd" ) { 
		var SelRowData = $("#OrderSetsList").datagrid("getSelected");
		if (SelRowData) {
			var FavRowid = SelRowData.FavRowid;
			var ARCOSRowid = SelRowData.ARCOSRowid;
			var tPGBId = SelRowData.OSExPGBId;
			if (tPGBId == "") tPGBId = "UN"; 
			if (FavRowid == "" || ARCOSRowid == "") {
				$.messager.alert("��ʾ","��ѡ��ҽ���׽����޸ġ�");
				return false; 
			}
		} else {
			$.messager.alert("��ʾ","��ѡ��ҽ���׽����޸ġ�");
			return false; 
		}
	}
	var ARCOSCatID="", ARCOSCode="", ARCOSDesc="", ARCOSAlias="", Conditiones="", ARCOSEffDateFrom="";
	
	var UserID = session["LOGON.USERID"]
	var UserCode = session["LOGON.USERCODE"];
	var	CTLOCID = session["LOGON.CTLOCID"];
	
	//var ARCOSCatID = 12;  // ҽ����ID OEC_OrderCategory
	if ($("#CategoryIDWin").val().replace(/(^\s*)|(\s*$)/g,'') != "") { ARCOSCatID = $("#CategoryIDWin").val(); }
	else { $.messager.alert("����", "ҽ���״���Ϊ�գ���͹���Ա��ϵ!"); return false; }
	
	if ($("#subCatIDWin").val().replace(/(^\s*)|(\s*$)/g,'') != "") { subCatID = $("#subCatIDWin").val(); }
	else { $.messager.alert("����", "ҽ��������Ϊ�գ���͹���Ա��ϵ!"); return false; }
	
	if ($("#CodeWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSCode = $("#CodeWin").val(); }
	else { $.messager.alert("����", "ҽ���״���Ϊ�գ���͹���Ա��ϵ!"); return false; }
	
	if ($("#DescWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSDesc = $("#DescWin").val(); }
	else { $.messager.alert("��ʾ", "ҽ������������Ϊ�գ�"); return false; }
	
	if ($("#AliasWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSAlias = $("#AliasWin").val(); }
	else { $.messager.alert("��ʾ", "ҽ���ױ�������Ϊ�գ�"); return false; }

	if ($("#ConditionesWin").combobox('getValue').replace(/(^\s*)|(\s*$)/g,"") != "") { Conditiones = $("#ConditionesWin").combobox('getValue'); }
	else { $.messager.alert("��ʾ", "��������Ϊ�գ�"); return false; }
		
	// ҽ���׵�����Ҫ����Code
	if (ARCOSDesc.indexOf("-") < 0) {
		ARCOSDesc = UserCode + "-" + ARCOSDesc;
	}
	// $.messager.alert("��ʾ","ARCOSDesc:"+ARCOSCode)
	
	// ȡ��
	var DocMedUnit = $.m({ClassName:"web.DHCUserFavItems", MethodName:"GetMedUnit", Guser:UserID, CTLOCID:CTLOCID}, false);
	var FavDepList = "";
	var InUser = UserID;
	
	// �����ж��������ֵ
	if (Conditiones == "1") {  // ����
		FavDepList = "";
		DocMedUnit = "";
	} else if (Conditiones == "2") {  // ����
		InUser = "";
		FavDepList = CTLOCID;
		DocMedUnit = "";
	} else if (Conditiones == "3") { // ȫԺ
		InUser = "";
		FavDepList = "";
		DocMedUnit = "";
	} else if (Conditiones == "4") {
		FavDepList = "";
		if (DocMedUnit == "") {
			$.messager.alert("��ʾ", "��û�б����뵽��½������Ч������,���ܽ��и���������");
			return false;
		}
	}
	
	var VIPLevel="", Break="", Sex="", Deit="", PGBId="", InString="", ret;
	
	PGBId = $("#OrderSetsPGBIWin").combobox("getValue");  // ����
	if (PGBId == undefined) {
		$.messager.alert("��ʾ", "�������岻��Ϊ��");
		return false;
	}
	
	VIPLevel = $("#OrderSetVIPWin").combobox("getValues");  // �ײ͵ȼ�
	
	cBreak = $("#IsBreakWin").checkbox("getValue");  // OSE_Break	�ɷ���
	if (cBreak) { Break = "Y"; }
	else { Break = "N"; }
	
	Sex = $("#OrderSetSexWin").combobox('getValue');  // OSE_Sex_DR ��Ӧ�Ա�
	
	cDeit = $("#IsDeitWin").checkbox("getValue");  // OSE_Break	�ɷ���
	if (cDeit) { Deit = "Y"; }
	else { Deit = "N"; }
	
	InString = VIPLevel + "^" + Break + "^" + Sex + "^" + Deit + "^" + PGBId;
	// alert(VIPLevel + "  " + Break + "  " + Sex + "  " + Deit);return false;
	if (type == "Add") {
		// ��Ч����ARCOSEffDateFrom
		if ($("#curDateWin").val() != "") { ARCOSEffDateFrom = $("#curDateWin").val(); }
		else { ARCOSEffDateFrom = 1; }
		
		// $.messager.alert("��ʾ",InUser+","+ARCOSCode+","+ARCOSDesc+","+ARCOSCatID+","+subCatID+","+ARCOSEffDateFrom+","+ARCOSAlias+","+UserID+","+FavDepList+","+DocMedUnit+")");
		// return false;
		// ret=tkMakeServerCall("web.DHCUserFavItems","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit)
		// ret=tkMakeServerCall("web.DHCPE.OrderSets","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit,"");
		// FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
	
		$.m({
			ClassName:"web.DHCPE.HISUIOrderSets",
			MethodName:"InsertUserARCOS",
			UserRowid:InUser,
			ARCOSCode:ARCOSCode,
			ARCOSDesc:ARCOSDesc,
			ARCOSCatID:ARCOSCatID,
			ARCOSSubCatID:subCatID,
			ARCOSEffectDate:ARCOSEffDateFrom,
			ARCOSAlias:ARCOSAlias,
			UserID:UserID,
			FavDepList:FavDepList,
			DocMedUnit:DocMedUnit,
			HospID:"",
			InString:InString
		},function(ret){  // FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
			if (ret == "-1") {
				$.messager.alert("��ʾ","����ҽ����ʧ����������д���Ѿ�ʹ�õĴ���!");
				return false;
			}
			$.messager.alert("��ʾ","����ɹ�!");
			var arr = new Array();
			arr = ret.split(String.fromCharCode(1));
			var iFavRowid = arr[0];
			var iARCOSRowid = arr[1];
			var iARCOSCode = arr[2];
			var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:iARCOSRowid}, false);
			var pId = "PGBIdUN";
			if ( OSExData.PGBId != "" ) pId = "PGBId" + OSExData.PGBId;
			$("#OrderSetsList").treegrid('append', {
				parent: pId,//treegrid ��id ����ָ��
				data: [{
					ARCOSRowid:iARCOSRowid,
					ARCOSOrdCatDR:ARCOSCatID,	// ����ID
					ARCOSOrdSubCatDR:subCatID,	// ����ID
					ARCOSEffDateFrom:ARCOSEffDateFrom,
					FavRowid:iFavRowid,
					FavUserDr:UserID,			// �û�
					FavDepDr:FavDepList,		// ����
					MedUnit:DocMedUnit,			// ��
		
					OSExBreak:OSExData.Break,			// ���
					OSExSex:OSExData.Sex,				// �Ա�
					OSExDeit:OSExData.Deit,				// ���
					OSExVIPLevel:OSExData.VIPLevel,		// VIPID
					OSExPGBId:OSExData.PGBId,
			
					ARCOSOrdCat:"ҽ����",
					ARCOSOrdSubCat:"���ҽ����",
					ARCOSCode:iARCOSCode,
					ARCOSDesc:ARCOSDesc,
					ARCOSAlias:ARCOSAlias,
			
					BreakDesc:OSExData.BreakDesc,  // ���
					SexDesc:OSExData.SexDesc,  // �Ա� $("#OrderSetSexWin").combobox('getValue')
					VIPDesc:OSExData.VIPDesc,
					DeitDesc:OSExData.DeitDesc,
					PGDesc:OSExData.PGDesc,
					OSExPrice:OSExData.OSExPrice,  // �۸�
				}]
			});
			
			/*
			$("#OrderSetsList").datagrid("insertRow", {
				index:0,
				row:{
					ARCOSRowid:iARCOSRowid,
					ARCOSOrdCatDR:ARCOSCatID,	// ����ID
					ARCOSOrdSubCatDR:subCatID,	// ����ID
					ARCOSEffDateFrom:ARCOSEffDateFrom,
					FavRowid:iFavRowid,
					FavUserDr:UserID,			// �û�
					FavDepDr:FavDepList,		// ����
					MedUnit:DocMedUnit,			// ��
		
					OSExBreak:OSExData.Break,			// ���
					OSExSex:OSExData.Sex,				// �Ա�
					OSExDeit:OSExData.Deit,				// ���
					OSExVIPLevel:OSExData.VIPLevel,		// VIPID
			
					ARCOSOrdCat:"ҽ����",
					ARCOSOrdSubCat:"���ҽ����",
					ARCOSCode:iARCOSCode,
					ARCOSDesc:ARCOSDesc,
					ARCOSAlias:ARCOSAlias,
			
					BreakDesc:OSExData.BreakDesc,  // ���
					SexDesc:OSExData.SexDesc,  // �Ա� $("#OrderSetSexWin").combobox('getValue')
					VIPDesc:OSExData.VIPDesc,
					DeitDesc:OSExData.DeitDesc,
					OSExPrice:OSExData.OSExPrice,  // �۸�
				}
			});
			*/
			
			$("#OrderSetsWin").window("close");
		}); 
	} else if (type == "Upd"){
		ARCOSEffDateFrom = SelRowData.ARCOSEffDateFrom;  // ��Ч����ARCOSEffDateFrom
		// $.messager.alert("��ʾ",FavRowid+","+ARCOSCode+","+ARCOSDesc+","+ARCOSCatID+","+subCatID+","+ARCOSEffDateFrom+","+ARCOSAlias+","+FavDepList+","+DocMedUnit+","+UserID+","+InString);
		// ret=tkMakeServerCall("web.DHCUserFavItems","UpdateUserARCOS",FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,FavDepList,DocMedUnit,InUser);
		$.m({
			ClassName:"web.DHCPE.HISUIOrderSets",
			MethodName:"UpdateUserARCOS",
			FavRowid:FavRowid,
			ARCOSCode:ARCOSCode,
			ARCOSDesc:ARCOSDesc,
			ARCOSCatID:ARCOSCatID,
			ARCOSSubCatID:subCatID,
			ARCOSEffectDate:ARCOSEffDateFrom,
			ARCOSAlias:ARCOSAlias,
			FavDepList:FavDepList,
			DocMedUnit:DocMedUnit,
			UserDr:InUser,
			InString:InString
		}, function(ret) {
			if (ret == "0") {
				$.messager.alert("��ʾ", "�޸ĳɹ�!");
				if ( tPGBId != PGBId ) {
					if (tPGBId == "") {
						$("#OrderSetsList").treegrid("reload", "PGBIdUN");
						$("#OrderSetsList").treegrid("reload", "PGBId" + PGBId, {onLoadSuccess: function(data){ $("#OrderSetsList").treegrid("select", ARCOSRowid); }});
					}
					if (PGBId == "") {
						$("#OrderSetsList").treegrid("reload", "PGBId" + tPGBId);
						$("#OrderSetsList").treegrid("reload", "PGBIdUN", {onLoadSuccess: function(data){ $("#OrderSetsList").treegrid("select", ARCOSRowid); }});
					}
					if (tPGBId != "" && PGBId != "") {
						$("#OrderSetsList").treegrid("reload", "PGBId" + tPGBId);
						$("#OrderSetsList").treegrid("reload", "PGBId" + PGBId, {onLoadSuccess: function(data){ $.messager.alert("��ʾ", ARCOSRowid);$("#OrderSetsList").treegrid("select", ARCOSRowid); }});
					}
				} else {
					var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
					
					$('#OrderSetsList').treegrid('update',{
						id: ARCOSRowid,
						row:{
							FavUserDr:UserID,			// �û�
							FavDepDr:FavDepList,		// ����
							MedUnit:DocMedUnit,			// ��
				
							OSExBreak:OSExData.Break,			// ���
							OSExSex:OSExData.Sex,				// �Ա�
							OSExDeit:OSExData.Deit,				// ���
							OSExVIPLevel:OSExData.VIPLevel,		// VIPID
							ARCOSDesc:ARCOSDesc,
							ARCOSAlias:ARCOSAlias,
					
							BreakDesc:OSExData.BreakDesc,  // ���
							SexDesc:OSExData.SexDesc,  // �Ա� $("#OrderSetSexWin").combobox('getValue')
							VIPDesc:OSExData.VIPDesc,
							DeitDesc:OSExData.DeitDesc,
							OSExPrice:OSExData.OSExPrice,  // �۸�
						}
					});
				}
				/*
				var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
				var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
				
				$("#OrderSetsList").datagrid("updateRow", {
					index: SelRowIndex,
					row:{
						FavUserDr:UserID,			// �û�
						FavDepDr:FavDepList,		// ����
						MedUnit:DocMedUnit,			// ��
			
						OSExBreak:OSExData.Break,			// ���
						OSExSex:OSExData.Sex,				// �Ա�
						OSExDeit:OSExData.Deit,				// ���
						OSExVIPLevel:OSExData.VIPLevel,		// VIPID
						ARCOSDesc:ARCOSDesc,
						ARCOSAlias:ARCOSAlias,
				
						BreakDesc:OSExData.BreakDesc,  // ���
						SexDesc:OSExData.SexDesc,  // �Ա� $("#OrderSetSexWin").combobox('getValue')
						VIPDesc:OSExData.VIPDesc,
						DeitDesc:OSExData.DeitDesc,
						OSExPrice:OSExData.OSExPrice,  // �۸�
					}
				});
				*/
				$("#OrderSetsWin").window("close");
			} else { 
				$.messager.alert("��ʾ", "����ʧ��!");
				return false;
			}
		});
		// tkMakeServerCall("web.DHCPE.HISUIOrderSets","SetARCOSEx",ARCOSRowid,VIPLevel,Break,Sex,Deit);
	}
}

// ɾ��
function BDel_click(){
	var SelRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData ) { $.messager.alert("��ʾ","��ѡ��ҽ���׽���ɾ����"); return false; }
	var UserID = session["LOGON.USERID"];
	var FavRowid = SelRowData.FavRowid;
	var ARCOSRowid = SelRowData.ARCOSRowid;
	$.messager.confirm("ȷ��", "ȷ��ɾ�����ײ���", function(r) {
		if (r){
			$.m({
				ClassName:"web.DHCPE.HISUIOrderSets",
				MethodName:"DeleteUserARCOS", 
				iFavRowid:FavRowid,
				iARCOSRowid:ARCOSRowid
			}, function(ReturnValue) {
				if (ReturnValue != "0") {
					$.messager.alert("��ʾ", ReturnValue+"ɾ��ҽ����ʧ��.");
				}else{
					$.messager.alert("��ʾ", "ɾ��ҽ���׳ɹ�.");
					$("#OrderSetsList").treegrid("remove", ARCOSRowid);
					//$("#OrderSetsList").datagrid("deleteRow", SelRowIndex);
					// ��Ҫ��ղ�ѯ����
					BClear_click("0");
				}
			});	
		}
	});
}

// ����
function BClear_click(Type) {
	if (Type == "0") {
		$("#Code").val("");
		$("#Desc").val("");
		$("#Alias").val("");
		$("#Conditiones").combobox("setValue", "2");
	}

	$("#CodeWin").val("");
	$("#DescWin").val("");
	$("#AliasWin").val("");
	$("#ConditionesWin").combobox("setValue", "2");
	$("#OrderSetVIPWin").combobox("setValues","");
	$("#OrderSetSexWin").combobox("setValue","");  // �Ա�
	$("#IsBreakWin").checkbox("setValue", false);  // ���
	$("#IsDeitWin").checkbox("setValue", false);	 // ���
	$("#OSLocWin").combobox("setValue","");
	$("#OrderSetsPGBIWin").combobox("setValue","");
}

// ���ÿ���ά��
function BUpdLoc_click(Type) {
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	if ( !SelOSRowData ) { $.messager.alert("��ʾ","��ѡ��ҽ�����ٽ����ײͿ��ÿ���ά���Ĳ�����"); return false; }
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	var loc = "", locdesc = "";
	if (Type == "1") {
		loc = $("#OSLocWin").combobox("getValue");
		locdesc = $("#OSLocWin").combobox("getText");
	} else if (Type == "0") {
		var SelRowData = $("#OSLocTable").datagrid("getSelected");
		if ( !SelRowData ) { $.messager.alert("��ʾ","��ѡ����Ҫɾ���Ŀ��ң�"); return false; }
		loc = SelRowData.LocId;
		locdesc = SelRowData.LocDesc;
	}
	$.m({
		ClassName:"web.DHCPE.HISUIOrderSets",
		MethodName:"SetARCOSLocInfo",
		ARCOSRowid:ARCOSRowid,
		LocId:loc,
		flag:Type
	}, function(ret) {
		if (ret == "0") {
			if (Type == "1") {
				$.messager.alert("��ʾ", "���ӳɹ�!");
				
				$("#OSLocTable").datagrid("insertRow", {
					index:0,
					row:{
						LocId:loc,
						LocDesc:locdesc
					}
				});
				
			} else if (Type == "0") {
				$.messager.alert("��ʾ", "ɾ���ɹ�!");
				
				var SelRowData = $("#OSLocTable").datagrid("getSelected");
				var SelRowIndex = $("#OSLocTable").datagrid("getRowIndex", SelRowData);
				$("#OSLocTable").datagrid("deleteRow", SelRowIndex);
			}
			
			var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
			$("#OrderSetsList").treegrid("update", {
				id: ARCOSRowid,
				row:{
					OSLoc:OSExData.LocId,
					LocDesc:OSExData.LocDesc
				}
			});
			
			/*   ��������
			var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
			var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
			$("#OrderSetsList").datagrid("updateRow", {
				index: SelOSRowIndex,
				row:{
					OSLoc:OSExData.LocId,
					LocDesc:OSExData.LocDesc
				}
			});
			*/
			
			$("#OrderSetsLocWin").window("close");
		} else { 
			if (Type == "1") { $.messager.alert("��ʾ", "����ʧ��!" + ret.split("^")[1]); }
			else if (Type == "0") { $.messager.alert("��ʾ", "ɾ��ʧ��!" + ret.split("^")[1]); }
			return false;
		}
	});
}

// �����ײ�
function BSelWeb_click() {
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( !SelOSRowData ) { $.messager.alert("��ʾ","��ѡ��ҽ������ά�������ײͣ�"); return false; }
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	var lnk = "dhcpenetsetsmanager.csp?&HisSetsID=" + ARCOSRowid;

	window.open(lnk,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=100,left=100,width=1200,height=700");

}

// ************************************************���ÿ���ά��************************************************************************** //

// ��ʼ��ҽ���׿��ÿ��ұ��
function InitARCOSLocDataGrid(ARCOSRowId){
	$HUI.datagrid("#OSLocTable",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"OrdSetsLocs",
			ARCOSRowId:ARCOSRowId
		},		
		columns:[[
			{field:'LocId', title:'����ID', width:100, align:'center'},
			{field:'LocDesc', title:'��������', width:400}
		]],
		tatle:"ҽ���׿��ÿ���",
		striped:true, // ���ƻ�
		rownumbers:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,25,30,35,40],
		fit:true,
		fitColumns:true,
		singleSelect:true,
		toolbar: [],
		onLoadSuccess: function (data) {  },
		onClickRow: function (rowIndex, rowData) {  }      // ѡ�����¼�  
		
	});
}

// ************************************************��ϸά��************************************************************************** //

// ��ʼ��ҽ������ϸ���
function InitARCOSDetailDataGrid(ARCOSRowid){
	$HUI.datagrid("#OrderSetsDetailList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCARCOrdSets",
			QueryName:"FindOSItem",
			ARCOSRowid:ARCOSRowid,
			QueryFlag:"1"
		},		
		columns:[[
			{field:'ARCOSItemRowid', title:'ARCOSItemRowid', hidden:true},  // ��Ŀ��ϸID
			{field:'ARCIMRowid', title:'ARCIMRowid', hidden:true},  // ARCIM
			{field:'ARCOSItemUOMDR' ,title:'ARCOSItemUOMDR', hidden:true},  // ��λ
			{field:'ARCOSItemFrequenceDR', title:'ARCOSItemFrequenceDR', hidden:true},  // Ƶ��
			{field:'ARCOSItemDurationDR', title:'ARCOSItemDurationDR', hidden:true},  // �Ƴ�
			{field:'ARCOSItemInstructionDR', title:'ARCOSItemInstructionDR', hidden:true},  // �÷�
			{field:'ARCOSItemCatDR', title:'ARCOSItemCatDR', hidden:true},  // 
			{field:'ARCOSItemSubCatDR', title:'ARCOSItemSubCatDR', hidden:true},  // 
			{field:'ARCOSItemOrderType', title:'ARCOSItemOrderType', hidden:true},  // 
			{field:'ARCOSDHCDocOrderTypeDR', title:'ARCOSDHCDocOrderTypeDR', hidden:true},  // ҽ������
			{field:'SampleID', title:'SampleID', hidden:true},  // �걾
			{field:'ITMSerialNo', title:'ITMSerialNo', hidden:true},  // 
			{field:'OrderPriorRemarksDR', title:'OrderPriorRemarksDR', hidden:true},  // 
			
			{field:'NO', title:'���', align:'center', hidden:true},
			{field:'IsBreakable',title:'����',
				formatter:function(value,rowData,rowIndex){
					// icon-cancel
					return "<a href='#' onclick='DeleteDetail(\"" + rowData.ARCOSItemRowid + "\",\"" + rowData.ARCIMRowid + "\",\"" + rowIndex + "\")'>\<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\</a>";
				}
			},
			{field:'ARCIMDesc',title:'����'},
			{field:'ARCOSDHCDocOrderType',title:'ҽ������',align:'center'},
			{field:'DHCDocOrdRecLoc',title:'���տ���',
				formatter:function(value,rowData,rowIndex){
					var arr=new Array();
					if (value.indexOf("-") > 0) {
						arr = value.split("-");
					}
					return arr[1];
				}
			},
			{field:'SampleDesc',title:'�걾',align:'center'},
			{field:'ItmPrice',title:'�۸�',align:'center',
				formatter: function(value,rowData,rowIndex){
					var value = $.m({
						ClassName:"web.DHCPE.Handle.ARCItmMast",
						MethodName:"GetItmPrice",
						ARCIMRowid:rowData.ARCIMRowid,
					}, false);
					return value;
				}
			},
			{field:'ARCOSItemQty',title:'����',align:'center'},
			{field:'ARCOSItemBillUOM',title:'��λ',align:'center'},
			{field:'ARCOSItemDoseQty',title:'����',align:'center'},
			{field:'ARCOSItemUOM',title:'������λ',align:'center'},
			{field:'ARCOSItemFrequence',title:'Ƶ��',align:'center'},
			{field:'ARCOSItemDuration',title:'�Ƴ�'},
			{field:'ARCOSItemInstruction',title:'�÷�'},
			{field:'ARCOSItmLinkDoctor',title:'����'},
			{field:'Tremark',title:'��ע'},
			{field:'OrderPriorRemarks',title:'����˵��'}
		]],
		tatle:"�ײ���Ŀ��ϸ",
		striped:true, // ���ƻ�
		rownumbers:true,
		pagination:true,
		pageSize:25,
		pageList:[10,15,25,50,100],
		fit:true,
		singleSelect:true,
		toolbar: [{
			iconCls: "icon-remove",
			text: "ɾ��",
			handler: function() {
				BDelDetail_click();
			}
		},{
			iconCls: 'icon-arrow-top',
			text:'����',
			handler: function(){
				var rowData = $('#OrderSetsDetailList').datagrid('getSelected');
				var rowIndex = $('#OrderSetsDetailList').datagrid('getRowIndex',rowData); 
				if (rowIndex >= 0){
					IMove(rowData,rowIndex,-1);
				} else {
					$.messager.alert("��ʾ", "��ѡ��һ�н����ƶ���");
				}
			}
		},{
			iconCls: 'icon-arrow-bottom',
			text:'����',
			handler: function(){
				var rowData = $('#OrderSetsDetailList').datagrid('getSelected');
				var rowIndex = $('#OrderSetsDetailList').datagrid('getRowIndex',rowData); 
				if (rowIndex >= 0){
					IMove(rowData,rowIndex,1);
				} else {
					$.messager.alert("��ʾ", "��ѡ��һ�н����ƶ���");
				}
			}
		},{
			iconCls: 'icon-fee',
			text:'�ײͶ���',
			handler: function(){
				var SelRowData = $("#OrderSetsList").treegrid("getSelected");
				//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
				//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
				if ( !SelRowData || SelRowData._parentId == "" ) { $.messager.alert("��ʾ","��ѡ��ҽ�����ٽ����ײͶ��ۣ�"); return false; }
				ClearPrice();
				$("#OrderSetsPriceWin").show();

				var ARCOSDesc = SelRowData.ARCOSDesc;
				var AmtData = $.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOrdSetsAmount", ARCOSRowId:ARCOSRowid}, false);
					
				if (AmtData.Amount <= 0) {
					$.messager.alert("��ʾ","ҽ����ԭ�۸�Ϊ�㣬����Ҫ���ۣ�","info");
					$("#OrderSetsPriceWin").window("close");
					return false;
				}
				
				$("#OSDescWin").val(ARCOSDesc);   // �ײ�����
				$("#OSAmountWin").val(AmtData.Amount);   // �ײ�ԭ��
				$("#OSPriceWin").val(AmtData.ARCOSPrice);   // �ײͶ���
	       	
					 
				var myWin = $HUI.dialog("#OrderSetsPriceWin", {
					iconCls:'icon-fee',
					resizable:true,
					title:'�ײͶ���',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'����',
						handler:function(){
							UpdPrice();
						}
					},{
						text:'��ԭ',
						handler:function(){
							UndoPrice();
						}
					}]
				});				
			}
		},{}],
		onLoadSuccess: function (data) {
			var SelOSRowData = $("#OrderSetsList").treegrid("getSelected"); 
			if ( SelOSRowData._parentId != "" ) {
				// ��ʼ����Ŀ
				//InitItemDataGrid("#QryRisItemList","Item");
				//InitItemDataGrid("#QryLisItemList","Lab");
				//InitItemDataGrid("#QryMedicalItemList","Medical");
				//InitItemDataGrid("#QryOtherItemList","Other");
			} else {
				$("#QryRisItemList").datagrid('loadData',{total:0,rows:[]});
				$("#QryLisItemList").datagrid('loadData',{total:0,rows:[]});
				$("#QryMedicalItemList").datagrid('loadData',{total:0,rows:[]});
				$("#QryOtherItemList").datagrid('loadData',{total:0,rows:[]});
			}
		},
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�     	
		}
	});
}

function BDelDetail_click(){
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData._parentId == "") { $.messager.alert("��ʾ","��ѡ��ҽ������ɾ����ϸ��"); return false; }
	
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	if (ARCOSRowid != "") {
		var SelRowData = $("#OrderSetsDetailList").datagrid("getSelected");
		var SelRowIndex = $("#OrderSetsDetailList").datagrid("getRowIndex", SelRowData);
		if (SelRowData) {
			DeleteDetail(SelRowData.ARCOSItemRowid, SelRowData.ARCIMRowid, SelRowIndex);
		} else { 
			$.messager.alert("��ʾ","��ѡ��һ�н���ɾ����");
			return false;
		}	
	} else {
		$.messager.alert("��ʾ","û��ѡ��ҽ���ף�","info");
		return false;
	}
}

function DeleteDetail(ItemRowid, ARCIMRowid, ind) {
	$.m({
		ClassName:"web.DHCARCOrdSets",
		MethodName:"DeleteItem",
		ARCOSItemRowid:ItemRowid,
		ARCIMRowid:ARCIMRowid
	}, function(ret) {
		if ( ret == 0 ) {
			$.messager.alert("��ʾ","ɾ���ɹ���", "info");
			
			$("#OrderSetsDetailList").datagrid("deleteRow", ind);
			
			$("#QryRisItemList").datagrid({ rowStyler:function(index, row) { return SetRowStyle(index, row, "Del"); } });
			$("#QryLisItemList").datagrid({ rowStyler:function(index, row) { return SetRowStyle(index, row, "Del"); } });
			$("#QryMedicalItemList").datagrid({ rowStyler:function(index, row) { return SetRowStyle(index, row, "Del"); } });
			$("#QryOtherItemList").datagrid({ rowStyler:function(index, row) { return SetRowStyle(index, row, "Del"); } });
			
		} else {
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�", "info");
		}
	});
}

// ����ҽ������ϸ
function IAdd(AddType,Id,AddAmount,Index,tablename){
	var ARCOSRowid="",ItemQty=1,DHCDocOrdRecLoc="",flag;
	
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData && SelOSRowData._parentId != "") { ARCOSRowid = SelOSRowData.ARCOSRowid; }  // ҽ����ID
	else { $.messager.alert("��ʾ","��ѡ��ҽ���ף�", "info"); return false; }
	
	// �ж�ҽ�������Ƿ��и�ҽ��
	flag = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveItemInOrdSets", ARCOSRowid:ARCOSRowid, ArcimRowId:Id}, false);
	if (flag == 1) { $.messager.alert("��ʾ", "����Ŀ�Ѵ��ڣ������ظ����"); return false; }
	
	// �걾
	var SampleId = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetDefLabSpecId", ArcimRowId:Id}, false);
	// 0 ��λ   1 ���տ���
	var rtn = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetItemLocIdAndUOMId", ArcimRowId:Id}, false);

	DHCDocOrdRecLoc = rtn.RecLoc;
	if (DHCDocOrdRecLoc == "") {
		if ( !confirm("����Ŀû�н��տ��ң�ȷ����ӣ�") ) {
			return false;
		}
	}
	
	var data = $.m({
		ClassName:"web.DHCARCOrdSets",
		MethodName:"InsertItem",
		ARCOSRowid:ARCOSRowid,
		ARCIMRowid:Id,
		ItemQty:1,
		ItemDoseQty:"",
		ItemDoseUOMID:"",
		ItemFrequenceID:"",
		ItemDurationID:"",
		ItemInstructionID:"",
		ItmLinkDoctor:"",
		remark:"",
		DHCDocOrderTypeID:3,
		SampleId:SampleId,
		ARCOSItemNO:"",
		OrderPriorRemarksDR:"",
		DHCDocOrderRecLoc:DHCDocOrdRecLoc,
	}, function (ret) {
		//$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
		//return ret;
		if (ret.indexOf("||") > 0) {
			var OSItemData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOSItemData", OSItemId:ret}, false);
			$("#OrderSetsDetailList").datagrid("insertRow", {
				index:(OSItemData.ITMSerialNo - 1),
				row:{
					ARCOSItemRowid:OSItemData.ARCOSItemRowid,
					ARCIMRowid:OSItemData.ARCIMRowid,
					ARCOSItemUOMDR:OSItemData.ARCOSItemUOMDR,
					ARCOSItemFrequenceDR:OSItemData.ARCOSItemFrequenceDR,
					ARCOSItemDurationDR:OSItemData.ARCOSItemDurationDR,
					ARCOSItemInstructionDR:OSItemData.ARCOSItemInstructionDR,
					ARCOSItemCatDR:OSItemData.ARCOSItemCatDR,
					ARCOSItemSubCatDR:OSItemData.ARCOSItemSubCatDR,
					ARCOSItemOrderType:OSItemData.ARCOSItemOrderType,
					ARCOSDHCDocOrderTypeDR:OSItemData.ARCOSDHCDocOrderTypeDR,
					SampleID:OSItemData.SampleID,
					ITMSerialNo:OSItemData.ITMSerialNo,
					OrderPriorRemarksDR:OSItemData.OrderPriorRemarksDR,
					NO:OSItemData.ITMSerialNo,
					ARCIMDesc:OSItemData.ARCIMDesc,
					ARCOSDHCDocOrderType:OSItemData.ARCOSDHCDocOrderType,
					DHCDocOrdRecLoc:OSItemData.DHCDocOrdRecLoc,
					SampleDesc:OSItemData.SampleDesc,
					ItmPrice:OSItemData.ItmPrice,
					ARCOSItemQty:OSItemData.ARCOSItemQty,
					ARCOSItemBillUOM:OSItemData.ARCOSItemBillUOM,
					ARCOSItemDoseQty:OSItemData.ARCOSItemDoseQty,
					ARCOSItemUOM:OSItemData.ARCOSItemUOM,
					ARCOSItemFrequence:OSItemData.ARCOSItemFrequence,
					ARCOSItemDuration:OSItemData.ARCOSItemDuration,
					ARCOSItemInstruction:OSItemData.ARCOSItemInstruction,
					ARCOSItmLinkDoctor:OSItemData.ARCOSItmLinkDoctor,
					Tremark:OSItemData.Tremark,
					OrderPriorRemarks:OSItemData.OrderPriorRemarks
				}
			});
		}
		
		$(tablename).datagrid({  
			rowStyler:function(index, row) { 
				return SetRowStyle(index, row, "Add"); 
			}  
		});
	});
	return data;
}

function GetTableTrID(name) {
	var p = $(name).prev().find('div table:eq(1)');
	var ID = $(p).find('tbody tr:first').attr('id');
	if (ID != undefined && ID != '' && ID.length > 3) {
		ID = ID.toString().substr(0, ID.toString().length - 1);
	}
	return ID;
}

// �ƶ�  flag -1 ����   1 ����
function IMove(Data,Index,flag) {
	var ARCOSRowid="";
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData && SelOSRowData._parentId != "") { ARCOSRowid = SelOSRowData.ARCOSRowid; }  // ҽ����ID
	else { $.messager.alert("��ʾ","��ѡ��ҽ���ף�", "info");return false; }
	if (ARCOSRowid == "") { $.messager.alert("��ʾ","��ѡ��ҽ���ף�", "info");return false; }
	if (Data) {
		// ��ǰ����ź�ID
		if (Data.ITMSerialNo != "") { var toup = Data.ITMSerialNo; }
		else { return false; }
		if (Data.ARCOSItemRowid != "") { var upid = Data.ARCOSItemRowid; }
		else { return false; }
		
		var changeRowData = $('#OrderSetsDetailList').datagrid('getRows');
		var rowData = changeRowData[Index + flag];
		
		// �����е���ź�ID
		if (rowData.ITMSerialNo != "") { var todown = rowData.ITMSerialNo; }
		else { return false; }
		if (rowData.ARCOSItemRowid != "") { var downid = rowData.ARCOSItemRowid; }
		else { return false; }
		
        UpdateSerialNO(downid,toup);
        UpdateSerialNO(upid,todown);
        
        $("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
	}
}

// ��������
function UpdateSerialNO(ARCOSItemRowid,SerNO) {
	$.m({
		ClassName:"web.DHCARCOrdSets",
		MethodName:"UpdateItemSerialNo",
		ARCOSItemRowid:ARCOSItemRowid,
		ItemSerialNo:SerNO
	},function(rtn){
		
	});
	//tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO)
}

// ************************************************�۸�ά��************************************************************************** //

// �ײͶ���
function UpdPrice() {
	var obj, Date = "", Price = "", ARCOSRowid = "", ARCOSAmount = "";
	
	var SelRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData || SelRowData._parentId == "") { $.messager.alert("��ʾ","��ѡ��ҽ�����ٽ����ײͶ��ۣ�","info"); return false; }
	ARCOSRowid = SelRowData.ARCOSRowid;
	
	if ($("#OSDateWin").val() != "") { Date = $("#OSDateWin").val(); }
	else { $.messager.alert("��ʾ","��ǰ����Ϊ�գ���ˢ�½���","info"); return false; }

	if ($("#OSAmountWin").val() != "") { ARCOSAmount = $("#OSAmountWin").val(); }

		
	if (($("#OSAmtWin").val() == "") && (($("#OSDiscountWin").val() == ""))) {
		$.messager.alert("��ʾ","������ �ײͶ��� �� �ۿ���.","info");
		return false;
	} else {
		if ($("#OSAmtWin").val() != "") Price_change("Amt");
		else  Price_change("Dis");
	}
	
	if ($("#OSAmtWin").val() != "") { Price=$("#OSAmtWin").val(); } 
		
	var MoneyF = /(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/;
	if (($("#OSAmtWin").val() != "") && (!MoneyF.test(Price))) {
		$.messager.alert("��ʾ","��������ȷ���.","info");
		return false;
	}
	
	$.m({  // var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,Date,Date,Price,"");
		ClassName:"web.DHCPE.HISUIOrderSets",
		MethodName:"UpdateARCOSPrice",
		ARCOSRowid:ARCOSRowid,
		DateFrom:Date,
		DateTo:Date,
		Price:Price,
		Amount:ARCOSAmount
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.alert("��ʾ","�ײͼ۸���³ɹ���","info");
			
			//var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
			
			$("#OrderSetsList").treegrid("update", {
				id: ARCOSRowid,
				row:{
					OSExPrice:Price+"Ԫ", // OSExData.OSExPrice,  // �۸�
				}
			});
			
			/*
			$("#OrderSetsList").datagrid("updateRow", {
				index: SelRowIndex,
				row:{
					OSExPrice:Price+"Ԫ", // OSExData.OSExPrice,  // �۸�
				}
			});
			*/
			$("#OrderSetsPriceWin").window("close");
			
		} else {
			$.messager.alert("��ʾ","�ײͼ۸����ʧ�ܣ�"+rtn,"info");
		}
	});
	ClearPrice();
}

// ��ԭ�۸�
function UndoPrice() {
	var ARCOSRowid = "", ARCOSAmount = 0;
	
	var SelRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData || SelRowData._parentId == "") { $.messager.alert("��ʾ","��ѡ��ҽ�����ٽ����ײͶ��ۣ�","info"); return false; }
	ARCOSRowid = SelRowData.ARCOSRowid;
	if ($("#OSAmountWin").val() != "") { ARCOSAmount = $("#OSAmountWin").val(); }
	$.m({  // var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,"","","","");
		ClassName:"web.DHCPE.HISUIOrderSets",
		MethodName:"UpdateARCOSPrice",
		ARCOSRowid:ARCOSRowid,
		DateFrom:"",
		DateTo:"",
		Price:""
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.alert("��ʾ","�ײͼ۸�ԭ�ɹ���","info");
			
			$("#OrderSetsList").treegrid("update", {
				id: ARCOSRowid,
				row:{
					OSExPrice:ARCOSAmount+"Ԫ", // OSExData.OSExPrice,  // �۸�
				}
			});
			
			/*
			$("#OrderSetsList").datagrid("updateRow", {
				index: SelRowIndex,
				row:{
					OSExPrice:ARCOSAmount+"Ԫ", // OSExData.OSExPrice,  // �۸�
				}
			});
			*/
			
			$("#OrderSetsPriceWin").window("close");
		} else {
			$.messager.alert("��ʾ","�ײͼ۸�ԭʧ�ܣ�"+rtn,"info");
		}
	});	
	ClearPrice();
}

function Price_change(type) {
	var Price = "", Discount = "";
	var userId = session["LOGON.USERID"];
	if ($("#OSAmountWin").val() > 0) {
		
		var ARCOSAmount = $("#OSAmountWin").val();
		
		if (type == "Amt") {
			if ($("#OSAmtWin").val() != "") {
				Price = $("#OSAmtWin").val();
			}
			if (isNaN(Price)) {
				$.messager.alert("��ʾ","��������ȷ�۸�","info");
				$("#OSAmtWin").val("");		
				return false;
			}
			Discount = (Price / ARCOSAmount * 100).toFixed(2);
			$("#OSDiscountWin").val(Discount);
		} else {	
			if ($("#OSDiscountWin").val() != "") {
				Discount = $("#OSDiscountWin").val();
			}
			if (isNaN(Discount)) {
				$.messager.alert("��ʾ","��������ȷ�ۿۣ�","info");
				$("#OSDiscountWin").val("");
				return false;
			}
			Price = (Discount / 100 * ARCOSAmount ).toFixed(2);
			$("#OSAmtWin").val(Price);			
		}
		
		var Dflag = UserDiscount(userId,Discount);
		if (Dflag == 0) { ClearPrice();return false; }
		
	} else {
		$.messager.alert("��ʾ","ҽ����ԭ�۸�Ϊ�㣬����Ҫ���ۣ�","info");
	}
}

function UserDiscount(userId,Discount) {
	var DFLimit = $.m({ClassName:"web.DHCPE.ChargeLimit", MethodName:"DFLimit", UserId:userId}, false);
	// DFLimit=tkMakeServerCall("web.DHCPE.ChargeLimit","DFLimit",userId);   // ȡUserId������ۿ���
	
	if (DFLimit==0) {
		ClearPrice();
		$.messager.alert("��ʾ", "û�д���Ȩ��", "info");
	    return 0;
	}
	if (+DFLimit>+Discount) {
		ClearPrice();
		$.messager.alert("��ʾ", "Ȩ�޲���,�����ۿ�Ȩ��Ϊ:"+DFLimit+"%", "info");
		return 0;
	}
	return 1;
}

function ClearPrice() {
	$("#OSAmtWin").val("");
	$("#OSDiscountWin").val("");
}

// ************************************************��Ŀά��************************************************************************** //

// ��ʼ����Ŀ������
function InitItemDataGrid(tablename,type) {
	var Tem = "";
	$HUI.datagrid(tablename,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"StationOrderList",
			Type:type,
			TargetFrame:"PreItemList"
		},
		columns:[[
			{field:'TUOM', title:'��λ', hidden:true},
			
			{field:'STORD_ARCIM_DR', title:'����', align:'center', width:7, formatter:function(value,row,index){
					return "<a href='#' onclick='IAdd(\"ITEM\", \"" + value + "\", \"" + row.STORD_ARCIM_Price + "\", \"" + index + "\", \"" + tablename + "\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
					</a>";
				}
			},
			{field:'STORD_ARCIM_Code', title:'����', width:15},
			{field:'STORD_ARCIM_Desc', title:'����', width:55},
			{field:'STORD_ARCIM_Price', title:'�۸�', align:'right', width:8},
			{field:'TLocDesc',title:'վ��', width:15}
		]],
		striped:true, // ���ƻ�
		pagination:true,
		pageSize:25,
		pageList:[10,25,50,100],
		fit:true,
		fitColumns:true,
		singleSelect:true,
		rowStyler: function(rowIndex,rowData) {
			return SetRowStyle(rowIndex,rowData,"Add");  
        },
		onDblClickRow:function(rowIndex,rowData){
			var ItemType = "ITEM";
			var ItemId = rowData.STORD_ARCIM_DR;
			var AddAmount = rowData.STORD_ARCIM_Price;
			
			IAdd(ItemType, ItemId, AddAmount, rowIndex, tablename);
		},
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�     	
		}
	});
}

function SetRowStyle(rowIndex,rowData,Type) {
	var SelRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( SelRowData && SelRowData._parentId != "") {
		var ARCOSRowid = SelRowData.ARCOSRowid;
		
		if (rowData) {
			var flag = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveItemInOrdSets", ARCOSRowid:ARCOSRowid, ArcimRowId:rowData.STORD_ARCIM_DR}, false);
			if (flag == "1") {
				return "background-color:lightgreen;";
			}
		}
	}
	return "";
	
	var Data = $("#OrderSetsDetailList").datagrid('getData');
	var Tem="";
	for(var i = 0; i < Data.rows.length; i++) {
		if(Tem.indexOf("^" + i + "^") >= 0) {
			continue;
		}
   		var ARCIMRowid = Data.rows[i].ARCIMRowid;
   		
		if(rowData && rowData.STORD_ARCIM_DR == ARCIMRowid) {
			Tem = Tem + "^" + i + "^";
			return "background-color:lightgreen;";
		} else {
			if (Type == "Del") {
				if ((rowIndex % 2) == 0) {
                	return "";
                } else {
                    //return "background-color:#fafafa;";
                }
			}
		}
	}
	return ""
}

// ��ѯ��Ŀ
function BSearchItem_click(type) {
	//$.messager.alert("type",type);
	if (type == "R") $("#QryRisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#RisItem").val(),StationID:$("#Station").combobox("getValue")}); 
	else if (type == "L") $("#QryLisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Lab",TargetFrame:"PreItemList",Item:$("#LisItem").val()}); 
	else if (type == "M") $("#QryMedicalItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Medical",TargetFrame:"PreItemList",Item:$("#MedicalItem").val()}); 
	else if (type == "O") $("#QryOtherItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Other",TargetFrame:"PreItemList",Item:$("#OtherItem").val()}); 
}

// ************************************************��������************************************************************************** //

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}

var jschars = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
// ȡ���ֵ
function getnum(num){
	var str=""
	for(var i=0;i<num;i++){
		var id=Math.ceil(Math.random()*35);
		str+=jschars[id];
	}
	return str;
}

// ��ǰʱ�� ��ʽ yyyy-MM-DD
function Dateformatter(date){  
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate();  
    return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);  
}

function OnPropChanged(event, type) {
	if (event.propertyName.toLowerCase() == "value") {
		BSearchItem_click(type);
	}
}

//����       dhcpe/ct/dhcpe.ct.ordersets.js
//����       ����ײ�ά������Ժ����
//��������  
//������     zhongricheng

var WIDTH = $(document).width();
var ItemType = "N", LisType = "N", MedType = "N", OtherType = "N", OrdSetsType = "N", IsShow = "N", IsFit = "N";
$("#OrderSetsSearch").css("width", WIDTH*0.5);

var SessionStr = session['LOGON.USERID']
			   + "^" + session['LOGON.GROUPID']
			   + "^" + session['LOGON.CTLOCID']
			   + "^" + session['LOGON.HOSPID']
			   ;
var tableName = "DHC_PE_OrdSetsEx";
var ItemPriceEnable = "Y";  // ������Ŀ�۸�

$(function() {
	//��ȡ���������б�
	GetLocComp(SessionStr);
	
	//���������б�change
	$("#LocList").combobox({
		onSelect:function(){ BSearch_click(); }
	});
	
	InitCombobox();
	InitARCOSDataGrid();
	
	InitARCOSDetailDataGrid("");
	
	// ��ʼ����Ŀ
	InitItemDataGrid("#QryRisItemList","NoShow");
	InitItemDataGrid("#QryLisItemList","NoShow");
	InitItemDataGrid("#QryMedicalItemList","NoShow");
	InitItemDataGrid("#QryOtherItemList","NoShow");
	// ��ʼ���ײ�
	InitOrdSetsDataGrid("#QryOrdSetsList","NoShow");
	
	$("#BSearch").click(function() {
		BSearch_click();
    });
    
    $("#BClear").click(function() {
		BClear_click("0");
    });
	
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
    
    $("#BSearchOrdSets").click(function() {
		BSearchOS_click();
    });
    $("#OrdSets").keydown(function(e) {
		if(e.keyCode == 13){
			BSearchOS_click();
		}
	});
	
	$("#ItemDoseQtyWin").blur(function(){
		var IDQty = $("#ItemDoseQtyWin").numberbox("getValue");
		if (IDQty < 0) {
			$("#ItemDoseQtyWin").numberbox("setValue","");
			$.messager.alert("��ʾ","��������Ϊ������", "info", function() { $("#ItemDoseQtyWin").focus(); });
			return false;
		}
	});
	
	$("#ItemLinkDoctorWin").blur(function() {
		var LD = $("#ItemLinkDoctorWin").val();
		if (LD != "") {
			var reg = /^\d+(?=\.{0,1}\d+$|$)/;
	  		if (!reg.test(LD)) {
				$("#ItemLinkDoctorWin").val("");
				$.messager.alert("��ʾ","����������������", "info", function() { $("#ItemLinkDoctorWin").focus(); });
				return false;
			}
		}
	});
});

// ��ʼ���ؼ�
function InitCombobox() {
	$.cm({
		ClassName:"web.DHCPE.CT.OrderSets",
		MethodName:"GetARCItemCatID"
	},function(Data){
		$("#Category").val("ҽ����");
		$("#csubCatID").val(Data.ARCItemCatDesc);
		$("#subCatID").val(Data.ARCItemCatID);
	});
	
	// �ײ͵ȼ� 
	$HUI.combobox("#OrderSetVIPWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		allowNull:false,
		panelHeight:"200",
		editable:false,
		onAllSelectClick: function(e) {
			var arr = $(this).combobox("getValues");
			if (arr && arr != "") {
				
			} else {
				
			}
		}
	});
	
	// �ײ͵ȼ� �����ϣ�
	$HUI.combobox("#NetSetsVIPWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		//multiple:true,
		//rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		panelHeight:"auto",
	    panelMaxHeight:150, //���߶�
		allowNull:false,
		editable:false,
		onLoadSuccess: function(data){
	        $("#NetSetsVIPWin").combobox("select", data[0].id);
	    }
		/*
		onAllSelectClick: function(e) {
			var arr = $(this).combobox("getValues");
			if (arr && arr != "") {
				
			} else {
				
			}
		}
		*/
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
	
	// �Ա�	
	$HUI.combobox("#NetSetsSexWin", {
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
	/*
	// �Ա�	
	$HUI.combobox("#NetSetsSexWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'����',text:'����'},
			{id:'��',text:'��'},
			{id:'Ů',text:'Ů'}
		]
	});
	
	*/
	// ����
	$HUI.combobox("#Conditiones", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1',text:'����'},
			{id:'2',text:'����',selected:'true'}
			//{id:'3',text:'ȫԺ'}
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
			{id:'2', text:'����', selected:'true'}
			//{id:'3', text:'ȫԺ'}
		]
	});
	// �Ա�	
	$HUI.combobox("#Win_NetSex", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'����',text:'����'},
			{id:'��',text:'��'},
			{id:'Ů',text:'Ů'}
		]
	});
	
	// ��������
	$HUI.combobox("#OrderSetsPGBIWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=QueryPGBI&ResultSetType=array",
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
		editable:false,
		onSelect:function(record){
			var SelRowData = $("#OrderSetsList").datagrid("getSelected");
			if ( SelRowData ) {
				$("#QryRisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#RisItem").val(),StationID:record.id,PreIADMID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
			}
		}
	});
	
	// ��Ŀ���ͣ������ײͣ�
	$HUI.combobox("#NetSetsItemTypeWin", {
		url:$URL+"?ClassName=web.DHCPE.NetPre.OrdSetsInfo&QueryName=GetItemType&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc',
		editable:false
	});
	
	// 
	$HUI.combobox("#NetSetsBaseActiveWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Y', text:'��', selected:'true'},
			{id:'N', text:'��'}
		]
	});
	
	$HUI.tabs("#QryItem", {
		onSelect:function(title, index) {
			if (IsShow == "Y") {
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
				} else if (title == "�ײ���Ŀ" && OrdSetsType == "N") {
					InitOrdSetsDataGrid("#QryOrdSetsList","");
					OrdSetsType = "Y";
				}
			}
		}
	});
}

// ****************************************************�ײ�ά��********************************************************************** //

// ��ʼ��ҽ���ױ��
function InitARCOSDataGrid() {
	var HospIDByLocID=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$("#LocList").combobox('getValue'));
	$HUI.datagrid("#OrderSetsList", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.OrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:session["LOGON.USERID"],  // $.session.get('USERID'),
			subCatID:$("#subCatID").val(),
			Conditiones:$("#Conditiones").combobox('getValue'),
			LocId:$("#LocList").combobox('getValue'),
			HospID:session['LOGON.HOSPID'],
			HospIDByLocID:HospIDByLocID

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
			{field:'OSExVIPLevel', title:'OSExVIPLevel', hidden:true},  // VIPID
			{field:'OSExPGBId', title:'OSExPGBId', hidden:true},   // ����
			
			{field:'ARCOSOrdCat', title:'����', hidden:true},
			
			{field:'ARCOSOrdSubCat', title:'����',},
			{field:'ARCOSCode',title:'����'},
			{field:'ARCOSDesc',title:'����'},
			{field:'ARCOSAlias',title:'����'},
			{field:'AddUser',title:'������'},
			
			{field:'BreakDesc', title:'���', hidden:true},  // ���
			{field:'SexDesc', title:'��Ӧ�Ա�', align:'center'},  // �Ա�
			{field:'VIPDesc',title:'�ײ͵ȼ�'},
			{field:'DeitDesc',title:'���', hidden:true},
			{field:'DateBeg',title:'��ʼ����'},
			{field:'DateEnd',title:'��ֹ����'},
			{field:'PGDesc',title:'��������'},
			{field:'Sort',title:'˳��'}, 
			{field:'Frequency',title:'ʹ��Ƶ��', hidden:true}, 
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
			{field:'Disable', title:'Disable', hidden:true},  // ����/���� ��ʶ
			{field:'DisableDesc', title:'״̬', align:'center'}  // ����/���� ����															 
		]],
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		fit:true,
		animate:true,
		pagination:true,   // ���α�� ���ܷ�ҳ
		pageSize:25,
		pageList:[10,25,50,100],
		singleSelect:true,
		toolbar: [
		/*
		{**
			iconCls: 'icon-search',
			text:'��ѯ',
			handler: function(){
				BSearch_click();
			}
		},**
		*/
		{
			iconCls: 'icon-add',
			text:'����',
			handler: function(){
				BClear_click("1");
				$("#OrderSetsWin").show();
				
				$.cm({
					ClassName:"web.DHCPE.CT.OrderSets",
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
		}, {
			iconCls: 'icon-write-order',
			text:'�޸�',
			id:'BUpd',
			disabled:true,
			handler: function(){
				$("#OrderSetsWin").show();
				
				var SelRowData = $("#OrderSetsList").datagrid("getSelected");
				if (!SelRowData) { 
					$.messager.alert("��ʾ","��ѡ����޸ĵ�ҽ���ף�", "info"); 
					return false; 
				}

				$("#CategoryWin").val(SelRowData.ARCOSOrdCat);
				$("#csubCatIDWin").val(SelRowData.ARCOSOrdSubCat);
				$("#CategoryIDWin").val(SelRowData.ARCOSOrdCatDR);
				$("#subCatIDWin").val(SelRowData.ARCOSOrdSubCatDR);
				
				$("#CodeWin").val(SelRowData.ARCOSCode);  // ����
				$("#DescWin").val(SelRowData.ARCOSDesc).validatebox("validate");  // ����
				$("#AliasWin").val(SelRowData.ARCOSAlias).validatebox("validate");  // ����
				
				// ����  
				var InUser = SelRowData.FavUserDr;
				var FavDepList = SelRowData.FavDepDr;
				var DocMedUnit = SelRowData.MedUnit;
				var FavHospDr = SelRowData.FavHospDr;
				var FavUserHospDr = SelRowData.FavUserHospDr;
				//alert(FavHospDr+"^"+FavUserHospDr+"^"+InUser)

				var Conditiones="";
				if (InUser == "") {
					if (FavDepList == "") {
						//if (DocMedUnit == "") { Conditiones = "3"; }
						if ((DocMedUnit == "")&&(FavHospDr!="")&&(FavHospDr==FavUserHospDr)) { Conditiones = "3"; }
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
				//if (SelRowData.OSExDeit == "Y") $("#IsDeitWin").checkbox("setValue", true);  // ���
				//else $("#IsDeitWin").checkbox("setValue", false);
				
				$("#SortWin").numberbox("setValue", SelRowData.Sort);  // ��ʾ˳��
				$("#EffDateBeginWin").datebox("setValue", SelRowData.DateBeg);  // ��Ч����
				$("#EffDateEndWin").datebox("setValue", SelRowData.DateEnd);  // ��ֹ����
				
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
		}, {
			iconCls: 'icon-unuse',
			text:'����/����',
			id:'BDisabled',
			disabled:true,
			handler: function(){
				BDisable_click();
			}
		}, {
			iconCls: 'icon-cancel',
			text:'ɾ��',
			id:'BDel',
			disabled:true,
			handler: function(){
				BDel_click();
			}
		},
		/*
		{
			iconCls: 'icon-remove',
			text:'����',
			handler: function(){
				BClear_click("0");
			}
		},
		*/
		{
			iconCls: 'icon-show-set',
			text:'�����ײ�',
			id:'BNetOS',
			disabled:true,
			handler: function(){
				show_netconfig();
			}
		}],		
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼� 	
			
			InitARCOSDetailDataGrid(rowData.ARCOSRowid);  // ҽ����ϸ  
			
			//$('#OrderSets').layout("collapse","west");  // �۵��¼�
			//$('#OrderSets').layout("expand","east");  // չ���¼�
			//$('#OrderSets').layout("expand","south");
			
			// ��ʼ����Ŀ
			//ItemType = "N", LisType = "N", MedType = "N", OtherType = "N";
			var tab = $("#QryItem").tabs("getSelected");
			var title = tab.panel("options").title;
			
			if (IsShow == "N") {
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
				} else if (title == "�ײ���Ŀ" && OrdSetsType == "N") {
					InitOrdSetsDataGrid("#QryOrdSetsList","");
					OrdSetsType = "Y";
				}
				IsShow = "Y";
			} else {
				if (title == "�����Ŀ") SetRowStyle("#QryRisItemList");
				else if (title == "������Ŀ") SetRowStyle("#QryLisItemList");
				else if (title == "ҩƷ��Ŀ") SetRowStyle("#QryMedicalItemList");
				else if (title == "������Ŀ") SetRowStyle("#QryOtherItemList");
				else if (title == "�ײ���Ŀ") InitOrdSetsDataGrid("#QryOrdSetsList","");
			}
			//InitItemDataGrid("#QryRisItemList","Item");
			//InitItemDataGrid("#QryLisItemList","Lab");
			//InitItemDataGrid("#QryMedicalItemList","Medical");
			//InitItemDataGrid("#QryOtherItemList","Other");
			
			//$("#Code").val(rowData.ARCOSCode);
			//$("#Desc").val(rowData.ARCOSDesc);
			//$("#Alias").val(rowData.ARCOSAlias);
			
			$('#BUpd').linkbutton('enable');
			$('#BDel').linkbutton('enable');
			$('#BLoc').linkbutton('enable');
			$('#BNetOS').linkbutton('enable');
			$('#BDisabled').linkbutton('enable');
			
			$('#BDisabled').linkbutton(rowData.Disable=="Y"?{text:'����',iconCls:'icon-accept'}:{text:'����',iconCls:'icon-forbid'});
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess:function(data){
			
		}
	});
}

// ��ѯ
function BSearch_click(){
	
	// �ײ��б�
	var HospID=session['LOGON.HOSPID']
	var HospIDByLocID=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$("#LocList").combobox('getValue'));
	$("#OrderSetsList").datagrid('clearSelections'); //ȡ��ѡ��״̬

	$("#OrderSetsList").datagrid('load',{
			ClassName:"web.DHCPE.CT.OrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:session['LOGON.USERID'], // $.session.get('USERID'),
			subCatID:$("#subCatID").val(),
			Conditiones:$("#Conditiones").combobox('getValue'),
			Code:$("#Code").val(),
			Desc:$("#Desc").val(),
			Alias:$("#Alias").val(),
			LocId:$("#LocList").combobox('getValue'),
			HospID:HospID,
			HospIDByLocID:HospIDByLocID
		}); 

	InitARCOSDetailDataGrid("");
}

// ����
function BAdd_click(type){
	var LocId = $("#LocList").combobox('getValue');
	if (LocId == "") {
		$.messager.alert("��ʾ","�޷���ȡ��ǰ���ң�", "info");
		return false; 
	}
	
	if ( type == "Upd" ) { 
		var SelRowData = $("#OrderSetsList").datagrid("getSelected");
		if (SelRowData) {
			var FavRowid = SelRowData.FavRowid;
			var ARCOSRowid = SelRowData.ARCOSRowid;
			var tPGBId = SelRowData.OSExPGBId;
			if (tPGBId == "") tPGBId = "UN"; 
			if (FavRowid == "" || ARCOSRowid == "") {
				$.messager.alert("��ʾ","��ѡ��ҽ���׽����޸ġ�", "info");
				return false; 
			}
		} else {
			$.messager.alert("��ʾ","��ѡ��ҽ���׽����޸ġ�", "info");
			return false; 
		}
	}
	var ARCOSCatID="", ARCOSCode="", ARCOSDesc="", ARCOSAlias="", Conditiones="", ARCOSEffDateFrom="";
	
	var UserID = session["LOGON.USERID"]
	var UserCode = session["LOGON.USERCODE"];
	//var CTLOCID = session["LOGON.CTLOCID"];
	//var HospID=session['LOGON.HOSPID'];
	var CTLOCID=$("#LocList").combobox('getValue');
	var HospID = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",CTLOCID);
	//var LogonHospID=session['LOGON.HOSPID'];
    var LogonHospID=HospID;
	//var ARCOSCatID = 12;  // ҽ����ID OEC_OrderCategory
	if ($("#CategoryIDWin").val().replace(/(^\s*)|(\s*$)/g,'') != "") { ARCOSCatID = $("#CategoryIDWin").val(); }
	else { $.messager.alert("����", "ҽ���״���Ϊ�գ���͹���Ա��ϵ!", "info"); return false; }
	
	if ($("#subCatIDWin").val().replace(/(^\s*)|(\s*$)/g,'') != "") { subCatID = $("#subCatIDWin").val(); }
	else { $.messager.alert("����", "ҽ��������Ϊ�գ���͹���Ա��ϵ!", "info"); return false; }
	
	if ($("#CodeWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSCode = $("#CodeWin").val(); }
	else { $.messager.alert("����", "ҽ���״���Ϊ�գ���͹���Ա��ϵ!", "info"); return false; }
	
	if ($("#DescWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSDesc = $("#DescWin").val(); }
	else { $.messager.alert("��ʾ", "ҽ������������Ϊ�գ�", "info"); return false; }
	
	if ($("#AliasWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSAlias = $("#AliasWin").val(); }
	else { $.messager.alert("��ʾ", "ҽ���ױ�������Ϊ�գ�", "info"); return false; }

	if ($("#ConditionesWin").combobox('getValue').replace(/(^\s*)|(\s*$)/g,"") != "") { Conditiones = $("#ConditionesWin").combobox('getValue'); }
	else { $.messager.alert("��ʾ", "��������Ϊ�գ�", "info"); return false; }
		
	// ҽ���׵�����Ҫ����Code
	if (ARCOSDesc.indexOf("-") < 0) {
		ARCOSDesc = UserCode + "-" + ARCOSDesc;
	}
	// $.messager.alert("��ʾ","ARCOSDesc:"+ARCOSCode, "info")
	
	// ȡ��
	var DocMedUnit = $.m({ClassName:"web.DHCUserFavItems", MethodName:"GetMedUnit", Guser:UserID, CTLOCID:CTLOCID}, false);
	var FavDepList = "";
	var InUser = UserID;
	
	// �����ж��������ֵ
	if (Conditiones == "1") {  // ����
		FavDepList = "";
		DocMedUnit = "";
		HospID="";
	} else if (Conditiones == "2") {  // ����
		InUser = "";
		FavDepList = CTLOCID;
		DocMedUnit = "";
		HospID="";
	} else if (Conditiones == "3") { // ȫԺ
		InUser = "";
		FavDepList = "";
		DocMedUnit = "";
		HospID=HospID;
	} else if (Conditiones == "4") {
		FavDepList = "";
		if (DocMedUnit == "") {
			$.messager.alert("��ʾ", "��û�б����뵽��½������Ч������,���ܽ��и���������", "info");
			return false;
		}
	}
	
	var VIPLevel="", Break="", Sex="", Deit="", PGBId="", InString="", ret;
	
	PGBId = $("#OrderSetsPGBIWin").combobox("getValue");  // ����
	if (PGBId == undefined) {
		$.messager.alert("��ʾ", "�������岻��Ϊ��", "info");
		return false;
	}
	
	VIPLevel = $("#OrderSetVIPWin").combobox("getValues");  // �ײ͵ȼ�
	
	cBreak = $("#IsBreakWin").checkbox("getValue");  // OSE_Break	�ɷ���
	if (cBreak) { Break = "Y"; }
	else { Break = "N"; }
	
	Sex = $("#OrderSetSexWin").combobox('getValue');  // OSE_Sex_DR ��Ӧ�Ա�
	
	var Deit = "N"
	/*cDeit = $("#IsDeitWin").checkbox("getValue");  // OSE_Break	�ɷ���
	if (cDeit) { Deit = "Y"; }
	else { Deit = "N"; }
	*/
	var Sort = $("#SortWin").numberbox("getValue");
	var EffDateBeg = $("#EffDateBeginWin").datebox("getValue");
	var EffDateEnd = $("#EffDateEndWin").datebox("getValue");
	if((EffDateBeg!="")&&(EffDateEnd!="")){ 
		var iEffDateBeg=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EffDateBeg);
		var iEffDateEnd=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EffDateEnd); 
		if(iEffDateBeg>=iEffDateEnd) {
        	$.messager.alert("��ʾ","��Ч���ڲ��ܴ��ڽ�ֹ���ڣ�","info");
        	return false;
    	}
	}


	InString = VIPLevel + "^" + Break + "^" + Sex + "^" + Deit + "^" + PGBId + "^" + LocId + "^" + Sort + "^" + EffDateBeg + "^" + EffDateEnd;
	// $.messager.alert("��ʾ",VIPLevel + " , " + Break + " , " + Sex + " , " + Deit, "info");//return false;
	if (type == "Add") {
		// ��Ч����ARCOSEffDateFrom
		if ($("#curDateWin").val() != "") { ARCOSEffDateFrom = $("#curDateWin").val(); }
		else { ARCOSEffDateFrom = daysBetween(""); }
		
		// $.messager.alert("��ʾ",InUser+","+ARCOSCode+","+ARCOSDesc+","+ARCOSCatID+","+subCatID+","+ARCOSEffDateFrom+","+ARCOSAlias+","+UserID+","+FavDepList+","+DocMedUnit+")");
		// return false;
		// ret=tkMakeServerCall("web.DHCUserFavItems","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit)
		// ret=tkMakeServerCall("web.DHCPE.OrderSets","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit,"");
		// FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
		
		$.m({
			ClassName:"web.DHCPE.CT.OrderSets",
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
			HospID:HospID,
			InString:InString,
			LogonHospID:LogonHospID,

		},function(ret){  // FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
			if (ret == "-1") {
				$.messager.alert("��ʾ","����ҽ����ʧ����������д���Ѿ�ʹ�õĴ���!", "info");
				return false;
			}
			$.messager.alert("��ʾ","����ɹ�!", "info");
			var arr = new Array();
			arr = ret.split(String.fromCharCode(1));
			var iFavRowid = arr[0];
			var iARCOSRowid = arr[1];
			var iARCOSCode = arr[2];
			var OSExData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetARCOSData", ARCOSRowid:iARCOSRowid}, false);
			$("#OrderSetsList").datagrid("insertRow", {
				index:0,
				row:{
					ARCOSRowid:iARCOSRowid,
					ARCOSOrdCatDR:ARCOSCatID,	// ����ID
					ARCOSOrdSubCatDR:subCatID,	// ����ID
					ARCOSEffDateFrom:ARCOSEffDateFrom,
					FavRowid:iFavRowid,
					FavUserDr:InUser,			// �û�		
					FavDepDr:FavDepList,		// ����
					MedUnit:DocMedUnit,			// ��
		
					OSExBreak:OSExData.Break,			// ���
					OSExSex:OSExData.Sex,				// �Ա�
					OSExDeit:OSExData.Deit,				// ���
					OSExVIPLevel:OSExData.VIPLevel,		// VIPID
					OSExPGBId:OSExData.PGBId,			// ����ID
			
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
					
					DateBeg:OSExData.DateBeg,  // ��ʼ����
					DateEnd:OSExData.DateEnd,  // ��������
					Sort:OSExData.Sort,  // ˳��
					Frequency:OSExData.Frequency,  // ʹ��Ƶ��
					OSExPrice:OSExData.OSExPrice,  // �۸�
					
					FavHospDr:HospID,
				    FavUserHospDr:HospID,

				}
			});
			
			//$("#OrderSetsWin").window("close");
			BClear_click("1");
			//$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetARCItemCatID"}, function(Data){ $("#CategoryWin").val("ҽ����"); $("#csubCatIDWin").val(Data.ARCItemCatDesc); $("#CategoryIDWin").val(Data.Category); $("#subCatIDWin").val(Data.ARCItemCatID);});
			var ARCOSCode=getnum(7); if ($("#CodeWin")) { $("#CodeWin").val(ARCOSCode); } // ����
			$("#OrderSetsPGBIWin").combobox("setValue","UN");
		}); 
	} else if (type == "Upd"){
		var upddata = $.cm({
			ClassName:"web.DHCPE.CT.OrderSets",
			MethodName:"IsCanUpdateOS",
			ARCOSRowid:ARCOSRowid,
			UpdData:Sex + "^" + VIPLevel,
			LocID:CTLOCID,
			HospID:LogonHospID
		}, false);
		if (upddata.code == "1") {
			$.messager.alert("��ʾ", upddata.msg, "info");
			return false;
		}
		
		ARCOSEffDateFrom = SelRowData.ARCOSEffDateFrom;  // ��Ч����ARCOSEffDateFrom
		// $.messager.alert("��ʾ",FavRowid+","+ARCOSCode+","+ARCOSDesc+","+ARCOSCatID+","+subCatID+","+ARCOSEffDateFrom+","+ARCOSAlias+","+FavDepList+","+DocMedUnit+","+UserID+","+InString);
		// ret=tkMakeServerCall("web.DHCUserFavItems","UpdateUserARCOS",FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,FavDepList,DocMedUnit,InUser);
		var amtflag = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveAmount", ARCOSRowid:ARCOSRowid}, false);
		//alert(amtflag)
		if (amtflag == "1") {
			var BreakNowStr=InString.split("^");
			var BreakNow=BreakNowStr[1];
			if(BreakNow=="Y"){var BreakDescNow="�ɲ��";}
			else{var BreakDescNow="���ɲ�";}
			
			if((BreakNow=="Y")&&(BreakDescNow!=SelRowData.BreakDesc)){
				var AmtData = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOrdSetsAmount", ARCOSRowId:ARCOSRowid}, false);
              
				$.messager.confirm("ȷ��", "���ײ��Ѷ��ۣ�������ײ����ָ�ԭ�ۣ�ȷ�ϲ�֣�", function(r){
				if (r){
						UndoPrice("0");
						InitARCOSDetailDataGrid(ARCOSRowid);
						$.m({
							ClassName:"web.DHCPE.CT.OrderSets",
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
							InString:InString,
							FavHospDr:HospID

						}, function(ret) {
							if (ret == "0") {
								$.messager.alert("��ʾ", "�޸ĳɹ�!", "info");
								var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
								var OSExData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
				                        
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
											OSExPGBId:OSExData.PGBId,			// ����ID
											ARCOSDesc:ARCOSDesc,
											ARCOSAlias:ARCOSAlias,
		
											BreakDesc:OSExData.BreakDesc,  // ���
											SexDesc:OSExData.SexDesc,  // �Ա� $("#OrderSetSexWin").combobox('getValue')
											VIPDesc:OSExData.VIPDesc,
											DeitDesc:OSExData.DeitDesc,
											PGDesc:OSExData.PGDesc,
					
											DateBeg:OSExData.DateBeg,  // ��ʼ����
											DateEnd:OSExData.DateEnd,  // ��������
											Sort:OSExData.Sort,  // ˳��
											Frequency:OSExData.Frequency,  // ʹ��Ƶ��
											OSExPrice:AmtData.Amount,  // �۸�
										}
									});
								$("#OrderSetsWin").window("close");
						} else { 
								$.messager.alert("��ʾ", "����ʧ��!", "info");
								return false;
						}
					});	
				} else {
					return false;
				}
			});
			
		}else{
			$.m({
				ClassName:"web.DHCPE.CT.OrderSets",
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
				InString:InString,
				FavHospDr:HospID
			}, function(ret) {
				if (ret == "0") {
					$.messager.alert("��ʾ", "�޸ĳɹ�!", "info");
	   
						var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
						var OSExData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
	
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
								OSExPGBId:OSExData.PGBId,			// ����ID
								ARCOSDesc:ARCOSDesc,
								ARCOSAlias:ARCOSAlias,

								BreakDesc:OSExData.BreakDesc,  // ���
								SexDesc:OSExData.SexDesc,  // �Ա� 
								VIPDesc:OSExData.VIPDesc,
								DeitDesc:OSExData.DeitDesc,
								PGDesc:OSExData.PGDesc,
								
								DateBeg:OSExData.DateBeg,  // ��ʼ����
								DateEnd:OSExData.DateEnd,  // ��������
								Sort:OSExData.Sort,  // ˳��
								Frequency:OSExData.Frequency,  // ʹ��Ƶ��
								OSExPrice:OSExData.OSExPrice,  // �۸�
							}
						});
						$("#OrderSetsWin").window("close");
					} else { 
						$.messager.alert("��ʾ", "����ʧ��!", "info");
						return false;
					}
				});
			}
		} else {
			$.m({
				ClassName:"web.DHCPE.CT.OrderSets",
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
				InString:InString,
				FavHospDr:HospID
			}, function(ret) {
					if (ret == "0") {
							$.messager.alert("��ʾ", "�޸ĳɹ�!", "info");
	
							var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
							var OSExData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
	
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
										OSExPGBId:OSExData.PGBId,			// ����ID
										ARCOSDesc:ARCOSDesc,
										ARCOSAlias:ARCOSAlias,
	
										BreakDesc:OSExData.BreakDesc,  // ���
										SexDesc:OSExData.SexDesc,  // �Ա� $("#OrderSetSexWin").combobox('getValue')
										VIPDesc:OSExData.VIPDesc,
										DeitDesc:OSExData.DeitDesc,
										PGDesc:OSExData.PGDesc,
										
										DateBeg:OSExData.DateBeg,  // ��ʼ����
										DateEnd:OSExData.DateEnd,  // ��������
										Sort:OSExData.Sort,  // ˳��
										Frequency:OSExData.Frequency,  // ʹ��Ƶ��
										OSExPrice:OSExData.OSExPrice,  // �۸�
									}
								});
							$("#OrderSetsWin").window("close");
					} else { 
							$.messager.alert("��ʾ", "����ʧ��!", "info");
							return false;
						}
			});
		}
	}
}

function BDisable_click() {
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData ) { $.messager.alert("��ʾ", "��ѡ��ҽ���׽��в�����", "info"); return false; }
	var UserID = session["LOGON.USERID"];
	var FavRowid = SelRowData.FavRowid;
	var ARCOSRowid = SelRowData.ARCOSRowid;
	var Disabled = SelRowData.Disable;
	var ADisable = (Disabled=="Y"?"����":"����");
	
	$.messager.confirm("ȷ��", "ȷ��" + ADisable + "���ײ���", function(r) {
		if (r){
			$.m({
				ClassName:"web.DHCPE.CT.OrderSets",
				MethodName:"UpdARCOSDisable", 
				ARCOSRowid:ARCOSRowid,
				Disabled:(Disabled=="Y"?"N":"Y"),
				LocID:session["LOGON.CTLOCID"],
				UserID:session["LOGON.USERID"]
			}, function(ReturnValue) {
				if (ReturnValue != "0") {
					$.messager.alert("��ʾ", ReturnValue + ADisable + "ʧ�ܡ�", "info");
				}else{
					$.messager.alert("��ʾ", "ҽ����" + ADisable + "�ɹ���", "info");
					$("#OrderSetsList").datagrid("updateRow", {
								index: SelRowIndex,
								row:{
										Disabled:Disabled,				// ����/���� ��ʶ
										DisableDesc:ADisable			// ����/���� ����
								}
					});
					// ��Ҫ��ղ�ѯ����
					BClear_click("0");
				}
			});	
		}
	});
}

// ɾ��
function BDel_click(){
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData ) { $.messager.alert("��ʾ", "��ѡ��ҽ���׽���ɾ����", "info"); return false; }
	var UserID = session["LOGON.USERID"];
	var FavRowid = SelRowData.FavRowid;
	var ARCOSRowid = SelRowData.ARCOSRowid;
	$.messager.confirm("ȷ��", "ȷ��ɾ�����ײ���", function(r) {
		if (r){
			$.m({
				ClassName:"web.DHCPE.CT.OrderSets",
				MethodName:"DeleteUserARCOS", 
				iFavRowid:FavRowid,
				iARCOSRowid:ARCOSRowid
			}, function(ReturnValue) {
				if (ReturnValue != "0") {
					$.messager.alert("��ʾ", ReturnValue+"ɾ��ҽ����ʧ�ܡ�", "info");
				}else{
					$.messager.alert("��ʾ", "ɾ��ҽ���׳ɹ���", "info");
					$("#OrderSetsList").datagrid("deleteRow", SelRowIndex);
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
	$("#DescWin").val("").validatebox("validate");
	$("#AliasWin").val("").validatebox("validate");
	$("#ConditionesWin").combobox("setValue", "2");
	$("#OrderSetVIPWin").combobox("setValues","");
	$("#OrderSetSexWin").combobox("setValue","");  // �Ա�
	$("#IsBreakWin").checkbox("setValue", false);  // ���
	//$("#IsDeitWin").checkbox("setValue", false);	 // ���
	$("#OSLocWin").combobox("setValue","");
	$("#OrderSetsPGBIWin").combobox("setValue","");
	$("#SortWin").numberbox("setValue",""); //��ʾ˳��
	$("#EffDateBeginWin").datebox("setValue","");//��Ч����
	$("#EffDateEndWin").datebox("setValue",""); //��������
	BSearch_click();
}

function InitNetSetsWin(NetOSInfo) {
	$("#NetSetsDescWin").val(NetOSInfo.Desc).validatebox("validate");  // ����
	$("#NetSetsPriceWin").numberbox("setValue",NetOSInfo.Price).validatebox("validate");  // �۸�
	$("#NetSetsSortWin").numberbox("setValue",NetOSInfo.Sort).validatebox("validate");  // ���
				
	var iNetOSVIPLevel = NetOSInfo.VIPLevel;
	if (iNetOSVIPLevel != "") {
		$("#NetSetsVIPWin").combobox("setValue", iNetOSVIPLevel);  // �ײ͵ȼ�
	} else {
		var val = $("#NetSetsVIPWin").combobox("getData");
		$("#NetSetsVIPWin").combobox('select', val[0].id);
    
	}
	
	$("#NetSetsSexWin").combobox("setValue", NetOSInfo.Sex);  // �Ա�
	$("#NetSetsRemrkWin").val(NetOSInfo.Remark);  // ��ע
				
	if (NetOSInfo.GIFlag == "I") $("#NetSetsIsPGWin").checkbox("setValue", false);  // ����
	else $("#NetSetsIsPGWin").checkbox("setValue", true);
	if (NetOSInfo.ActiveFlag == "Y") $("#NetSetsActiveWin").checkbox("setValue", true);  // ����
	else $("#NetSetsActiveWin").checkbox("setValue", false);
	ClearNetOS("");
	NetOSItemDesc("");
	NetOSItemDetail("");
	
	if(NetOSInfo.ID == "") {
		NetOSItemType("");
	}
	if(NetOSInfo.ID != "") {
		NetOSItemType(NetOSInfo.ID);
	}

}

// ���������ײ�
function NetOSOption(SelRowData, Type) {
	var NetOSInfo = $.cm({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"GetHisSetsInfoNew", SetsID:SelRowData.ARCOSRowid, LocID:session["LOGON.CTLOCID"]}, false);
	if (Type == "Add") {
		var StrInfo = "", NOSHisSetsID = "", NOSDesc = "", NOSVIPLevel = "", NOSSex = "";
		var NOSRemak = "", NOSSort = "", NOSGIFlag = "", NOSLocID = "", NOSActive = "";
		
		NOSHisSetsID = SelRowData.ARCOSRowid;
		if ($("#NetSetsDescWin").val() == "") { $.messager.alert("��ʾ", "δѡ��ҽ����!", "info"); return false; }
		
		NOSDesc = $("#NetSetsDescWin").val();  // ����
		if ($("#NetSetsDescWin").val() == "") { $.messager.alert("��ʾ", "��������Ϊ��!", "info"); return false; }
		
		NOSSort = $("#NetSetsSortWin").numberbox("getValue");  // ���
		if (NOSSort == "") { $.messager.alert("��ʾ", "��Ų���Ϊ��!", "info"); return false; }
		
		NOSVIPLevel = $("#NetSetsVIPWin").combobox("getValue");  // �ײ͵ȼ�
		if (NOSVIPLevel == "") { $.messager.alert("��ʾ", "�ײ͵ȼ�����Ϊ��!", "info"); return false; }
		
		NOSSex = $("#NetSetsSexWin").combobox("getValue");  // �Ա�
		if (NOSSex == "") { $.messager.alert("��ʾ", "�Ա���Ϊ��!", "info"); return false; }
		NOSRemak = $("#NetSetsRemrkWin").val();  // ��ע
		NOSLocID = session["LOGON.CTLOCID"];  // ����
		
		cIsIG = $("#NetSetsIsPGWin").checkbox("getValue");  // ����
		if (cIsIG) { NOSGIFlag = "G"; }
		else { NOSGIFlag = "I"; }
			    	
		cIsActive = $("#NetSetsActiveWin").checkbox("getValue");  // ����
		if (cIsActive) { NOSActive = "Y"; }
		else { NOSActive = "N"; }
		
		StrInfo = NOSHisSetsID + "^" + NOSDesc + "^^" + NOSVIPLevel + "^" + NOSSex + "^" + NOSRemak + "^" + NOSSort + "^" + NOSGIFlag + "^" + NOSLocID + "^" + NOSActive;
		
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"SaveOrdSets", ID:NetOSInfo.ID, StrInfo:StrInfo},
			function(ret) {
				if (ret.split("^")[0] == "-1") { $.messager.alert("��ʾ", "����ʧ��!" + ret.split("^")[1], "info"); return false; }
				else { $.messager.alert("��ʾ", "����ɹ�!", "info"); NetOSItemType(ret); }
			}
		);
	} else if (Type == "Undo") {
		if (NetOSInfo.ID == "") { $.messager.alert("��ʾ", "IDΪ�գ��޷�������", "info"); return false; }
		
		$.messager.confirm("ȷ��", "ȷ�������������ײͣ�", function(r){
			if (r){
				$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"DeleteOrdSets", ID:NetOSInfo.ID},
					function(ret) {
						if (ret == "0") {
							$.messager.alert("��ʾ", "�����ɹ�!", "info");
							var NetOSInfo = $.cm({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"GetHisSetsInfoNew", SetsID:SelRowData.ARCOSRowid, LocID:session["LOGON.CTLOCID"]}, false);
							InitNetSetsWin(NetOSInfo);
						} else {
							$.messager.alert("��ʾ", "����ʧ��!", "info");
							return false;
						}
					}
				);
			}
		});
	}
}

// ��Ŀ����ά��
function NetBaseType() {
	$HUI.datagrid("#tNetOrdSetsBaseDescWin", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.NetPre.OrdSetsInfo",
			QueryName:"GetItemType",
			Show:"ALL"
		},
		columns:[[
			{field:'TID', title:'TID', hidden:true},
			
			{field:'TDesc', title:'����'},
			{field:'TActive', title:'����', align:'center',
				formatter: function(value, rowData, rowIndex) {
					if (value == "Y") return "��";
					else return "��";
				}
			}
		]],
		collapsible:true, //�����������
		border:false,
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		
		pagination:false,
		//showPageList:false,
		//showRefresh:true,
		//beforePageText:'��',
		//afterPageText:'ҳ,��{pages}ҳ', displayMsg:'��{total}��',
		
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼� 	
			$("#NetSetsBaseDescWin").val(rowData.TDesc);
			$("#NetSetsBaseActiveWin").combobox("setValue",rowData.TActive);
		},
		onLoadSuccess:function(data){
			
		}
	});
}

// ��Ŀ���Ͳ���
function NetOSBaseTypeOption(Type) {
	var SelNetOSBaseTypeRowData = $("#tNetOrdSetsBaseDescWin").datagrid("getSelected");
	var TID = "";
	if ( SelNetOSBaseTypeRowData ) { TID = SelNetOSBaseTypeRowData.TID; }
	
	var typeDesc = $("#NetSetsBaseDescWin").val();
	if (typeDesc == "") { $.messager.alert("��ʾ", "��������Ϊ�գ�", "info"); return false; }
	
	var active = $("#NetSetsBaseActiveWin").combobox("getValue");  // ����
	
	if (Type == "Add") {
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"UpdItemType", ID:"", Desc:typeDesc, Active:active},
			function(ret) {
				if (ret.split("^")[0] == "0"){
					$.messager.alert("��ʾ", "��Ŀ�����������ӳɹ���", "info");
					$("#tNetOrdSetsBaseDescWin").datagrid("insertRow", {
						index:0,
						row:{
							TID: ret.split("^")[1],
							TDesc: typeDesc,
							TActive: active
						}
					});
					$HUI.combobox("#NetSetsItemTypeWin", "reload");
					
					$("#NetSetsBaseDescWin").val("");
					$("#NetSetsBaseActiveWin").combobox("setValue","Y");
				} else if (ret.split("^")[0] == "-1") { 
					$.messager.alert("��ʾ", "��Ŀ������������ʧ�ܣ�" + ret.split("^")[1], "info"); 
					return false; 
				} else { 
					$.messager.alert("��ʾ", "��Ŀ������������ʧ�ܣ�", "info"); 
					return false; 
				}
			}
		);
	} else if (Type == "Upd") {
		if ( TID == "" ) { $.messager.alert("��ʾ","����ѡ�������ٽ����޸Ĳ�����", "info"); return false; }

		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"UpdItemType", ID:TID, Desc:typeDesc, Active:active},
			function(ret) { 
				if (ret == "0") { 
					$.messager.alert("��ʾ", "��Ŀ���������޸ĳɹ���", "info");
					//var CurSelRowData = $("#tNetOrdSetsBaseDescWin").datagrid("getSelected");
					var CurSelRowIndex = $("#tNetOrdSetsBaseDescWin").datagrid("getRowIndex", SelNetOSBaseTypeRowData);
					$("#tNetOrdSetsBaseDescWin").datagrid("updateRow", {
						index: CurSelRowIndex,
						row:{
							TDesc: typeDesc,
							TActive: active
						}
					});
					$HUI.combobox("#NetSetsItemTypeWin", "reload");
					$("#NetSetsItemTypeWin").combobox("setValue","")
					$("#tNetOrdSetsItemTypeWin").datagrid("reload");
				} else {
					$.messager.alert("��ʾ", "��Ŀ���������޸�ʧ�ܣ�" + ret.split("^")[1], "info");
					return false;
				}
			}
		);
	}
}

// �����ײ���Ŀ����
function NetOSItemType(ID) {
	$HUI.datagrid("#tNetOrdSetsItemTypeWin", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.NetPre.OrdSetsInfo",
			QueryName:"SearchSetsItemType",
			ParRef:ID
		},
		columns:[[
			{field:'TID', title:'TID', hidden:true},
			{field:'TItemTypeID', title:'TItemTypeID', hidden:true},
			
			{field:'TItemTypeDesc',title:'����',width:30},
			{field:'TSort',title:'���'}
		]],
		collapsible:true, //�����������
		border:false,
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		
		pagination:true,
		showPageList:false,
		showRefresh:true,
		beforePageText:'��',
		afterPageText:'ҳ,��{pages}ҳ', displayMsg:'��{total}��',
		
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼� 	
			NetOSItemDesc(rowData.TID);
		},
		onLoadSuccess:function(data){
			$("#NetSetsIDWin").val(ID);
		}
	});
}

// �����ײ���Ŀ�������
function NetOSItemTypeOption(Type) {
	var SelNetOSItemTypeRowData = $("#tNetOrdSetsItemTypeWin").datagrid("getSelected");
	var TID = "";
	if ( SelNetOSItemTypeRowData ) { TID = SelNetOSItemTypeRowData.TID; }
	
	if (Type == "Add") {
		var pID = $("#NetSetsIDWin").val();
		if (pID == "") { $.messager.alert("��ʾ", "����ά�������ײ���Ϣ!", "info"); return false; }
		
		var itemType = $("#NetSetsItemTypeWin").combobox("getValue");
		if (itemType == "") { $.messager.alert("��ʾ", "��ѡ����Ŀ����", "info"); return false; }
		
		var sort = $("#NetSetsTypeSortWin").numberbox("getValue");  // ���
		if (sort == "") { $.messager.alert("��ʾ", "��Ų���Ϊ��!", "info"); return false; }
		
		var itemTypeDesc = $("#NetSetsItemTypeWin").combobox("getText");
		
		var Info = pID + "^" + itemType + "^" + sort ;
		
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"SaveSetsItemType", ID:"", StrInfo:Info},
			function(ret) {
				if (ret.split("^")[0] == "-1") { 
					$.messager.alert("��ʾ", "��Ŀ��������ʧ��!", "info"); 
					return false; 
				} else if (ret.split("^")[0] == "-2") { 
					$.messager.alert("��ʾ", "��Ŀ��������ʧ��!" + ret.split("^")[1], "info"); 
					return false; 
				//} else if (ret > 0) {
				} else {
					$.messager.alert("��ʾ", "��Ŀ�������ӳɹ�!", "info");
					$("#tNetOrdSetsItemTypeWin").datagrid("insertRow", {
						index:0,
						row:{
							TID: ret,
							TItemTypeID: itemType,
							
							TSort: sort, // ���
							TItemTypeDesc: itemTypeDesc, // ��Ŀ���
						}
					});
					ClearNetOS("Type");
					//ClearNetOS("Desc");
					//ClearNetOS("Detail");
					//NetOSItemDesc(ret);
				}
			}
		);
	} else if (Type == "Del") {
		if ( TID == "" ) { $.messager.alert("��ʾ","����ѡ����Ŀ�����ٽ���ɾ��������", "info"); return false; }
		
		$.messager.confirm("ȷ��", "ȷ��ɾ������Ŀ���ࣿ", function(r){
			if (r){
				$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"DeleteSetsItemType", ID:TID},
					function(ret) { 
						if (ret == "0") { 
							$.messager.alert("��ʾ", "��Ŀ����ɾ���ɹ�!", "info"); 
							NetOSItemDesc("");
							var CurSelRowData = $("#tNetOrdSetsItemTypeWin").datagrid("getSelected");
							var CurSelRowIndex = $("#tNetOrdSetsItemTypeWin").datagrid("getRowIndex", CurSelRowData);
							$("#tNetOrdSetsItemTypeWin").datagrid("deleteRow", CurSelRowIndex);
							ClearNetOS("Desc");
							
							NetOSItemDetail("");
							var CurSelRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
							var CurSelRowIndex = $("#tNetOrdSetsItemDescWin").datagrid("getRowIndex", CurSelRowData);
							$("#tNetOrdSetsItemDescWin").datagrid("deleteRow", CurSelRowIndex);
							ClearNetOS("Detail");
						} else {
							$.messager.alert("��ʾ", "��Ŀ����ɾ��ʧ��!", "info");
							return false;
						}
					}
				);
			}
		});
	}
}

// �����ײ���Ŀ
function NetOSItemDesc(ID) {
	$HUI.datagrid("#tNetOrdSetsItemDescWin", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.NetPre.OrdSetsInfo",
			QueryName:"SearchSetsItem",
			ParRef:ID
		},
		columns:[[
			{field:'TID', title:'TID', hidden:true},
			
			{field:'TDesc',title:'��Ŀ����',width:30},
			{field:'TSort',title:'���'}
		]],
		collapsible: true, //�����������
		border:false,
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		
		showPageList:false,
		showRefresh:true,
		afterPageText:'ҳ,��{pages}ҳ',
		beforePageText:'��', displayMsg:'��{total}��',
		pagination:true,
		
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼� 	
			NetOSItemDetail(rowData.TID);
		},
		onLoadSuccess:function(data) {
		}
	});
}

// �����ײ���Ŀ����
function NetOSItemDescOption(Type) {
	
	var TID = "";
	var SelNetOSItemDescRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
	if ( SelNetOSItemDescRowData ) { TID = SelNetOSItemDescRowData.TID; }	
	
	if (Type == "Add") {
		var SelNetOSItemTypeRowData = $("#tNetOrdSetsItemTypeWin").datagrid("getSelected");
		var pID = "";
		if ( SelNetOSItemTypeRowData ) { pID = SelNetOSItemTypeRowData.TID; }
		if (pID == "") { $.messager.alert("��ʾ", "����ѡ�������ײ���Ŀ����!", "info"); return false; }
		
		var itemDesc = $("#NetSetsItemDescWin").val();
		if (itemDesc == "") { $.messager.alert("��ʾ", "��Ŀ��������Ϊ��!", "info"); return false; }
				
		var sort = $("#NetSetsDescSortWin").numberbox("getValue");  // ���
		if (sort == "") { $.messager.alert("��ʾ", "��Ų���Ϊ��!", "info"); return false; }
				
		Info = pID + "^" + itemDesc + "^" + sort;
		var SelNetOSItemDescRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
		
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"SaveSetsItem", ID:"", StrInfo:Info},
			function(ret) {
				if (ret.split("^")[0] == "-1") {
					$.messager.alert("��ʾ", "��Ŀ��������ʧ��!", "info");
					return false;
				} else if (ret.split("^")[0] == "-2") { 
					$.messager.alert("��ʾ", "��Ŀ��������ʧ��!" + ret.split("^")[1], "info"); 
					return false; 
				//} else if (ret > 0) {
				} else {
					$.messager.alert("��ʾ", "��Ŀ�������ӳɹ�!", "info");
					$("#tNetOrdSetsItemDescWin").datagrid("insertRow", {
						index:0,
						row:{
							TID: ret,
							TDesc: itemDesc,
							TSort: sort, // ���
						}
					});
					ClearNetOS("Desc");
					//ClearNetOS("Detail");
					//NetOSItemDetail(ret);
				}
			}
		);
	} else if (Type == "Del") {
		if ( TID == "" ) { $.messager.alert("��ʾ","����ѡ����Ŀ�����ٽ���ɾ��������", "info"); return false; }
		$.messager.confirm("ȷ��", "ȷ��ɾ������Ŀ������", function(r){
			if (r){
				$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"DeleteSetsItem", ID:TID},
					function(ret) { 
						if (ret == "0") {
							$.messager.alert("��ʾ", "��Ŀ����ɾ���ɹ�!", "info");
							NetOSItemDetail("");
							var CurSelRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
							var CurSelRowIndex = $("#tNetOrdSetsItemDescWin").datagrid("getRowIndex", CurSelRowData);
							$("#tNetOrdSetsItemDescWin").datagrid("deleteRow", CurSelRowIndex);
							ClearNetOS("Detail");
						} else {
							$.messager.alert("��ʾ", "��Ŀ����ɾ��ʧ��!", "info");
							return false;
						}
					}
				);
			}
		});
	}
}

// �����ײ�ϸ������
function NetOSItemDetail(ID) {
	$HUI.datagrid("#tNetOrdSetsItemDetailWin", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.NetPre.OrdSetsInfo",
			QueryName:"SearchSetsItemDetail",
			ParRef:ID
		},
		columns:[[
			{field:'TID', title:'TID', hidden:true},
			
			{field:'TDesc',title:'ϸ������',width:30},
			{field:'TIntent',title:'���Ŀ��',width:30},
			{field:'TSort',title:'���'}
		]],
		collapsible: true, //�����������
		border:false,
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		pagination:true,
		pageSize:25,
		pageList:[10,25,50,100],
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼� 	
			
		},
		onLoadSuccess:function(data) {
		}
	});
}

// �����ײ���Ŀ��ϸ����
function NetOSItemDetailOption(Type) {
	var TID = "";
	var SelNetOSItemDetailRowData = $("#tNetOrdSetsItemDetailWin").datagrid("getSelected");
	if (SelNetOSItemDetailRowData) {TID = SelNetOSItemDetailRowData.TID;}
	
	if (Type == "Add") {
		var pID = "";
		var SelNetOSItemDescRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
		if ( SelNetOSItemDescRowData ) { pID = SelNetOSItemDescRowData.TID; }	
		if (pID == "") { $.messager.alert("��ʾ", "��ѡ�������ײ���Ŀ����!", "info"); return false; }
				
		var itemDetail = $("#NetSetsItemDetailWin").val();
		if (itemDetail == "") { $.messager.alert("��ʾ", "ϸ����������Ϊ��!", "info"); return false; }
				
		var sort = $("#NetSetsDetailSortWin").numberbox("getValue");  // ���
		if (sort == "") { $.messager.alert("��ʾ", "��Ų���Ϊ��!", "info"); return false; }
				
		var intent = $("#NetSetsDetailIntentWin").val();
		var Info = pID + "^" + itemDetail + "^" + intent + "^" + sort;
		
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"SaveSetsItemDetail", ID:"", StrInfo:Info},
			function(ret) {
				if (ret.split("^")[0] == "-1") {
					$.messager.alert("��ʾ", "ϸ����ϸ����ʧ��!", "info");
					return false;
				} else if (ret.split("^")[0] == "-2") { 
					$.messager.alert("��ʾ", "ϸ����ϸ����ʧ��!" + ret.split("^")[1], "info"); 
					return false; 
				//} else if (ret > 0) {
				} else {
					$.messager.alert("��ʾ", "ϸ����ϸ���ӳɹ�!", "info");
					$("#tNetOrdSetsItemDetailWin").datagrid("insertRow", {
						index:0,
						row:{
							TID: ret,
							TDesc: itemDetail,
							TIntent: intent,
							TSort: sort, // ���
						}
					});
					ClearNetOS("Detail");
				}
			}
		);
	} else if (Type == "Del") {
		if ( TID == "" ) { $.messager.alert("��ʾ","����ѡ��ϸ����ϸ�ٽ���ɾ��������", "info"); return false; }
		$.messager.confirm("ȷ��", "ȷ��ɾ����ϸ����ϸ��", function(r){
			if (r){
				$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"DeleteSetsItemDetail", ID:TID},
					function(ret) { 
						if (ret == "0") {
							$.messager.alert("��ʾ", "ϸ����ϸɾ���ɹ�!", "info");
							
							var CurSelRowData = $("#tNetOrdSetsItemDetailWin").datagrid("getSelected");
							var CurSelRowIndex = $("#tNetOrdSetsItemDetailWin").datagrid("getRowIndex", CurSelRowData);
							$("#tNetOrdSetsItemDetailWin").datagrid("deleteRow", CurSelRowIndex);
						} else {
							$.messager.alert("��ʾ", "ϸ����ϸɾ��ʧ��!", "info");
							return false;
						}
					}
				);
			}
		});
	}
}

function ClearNetOS(Type) {
	if (Type == "Type" || Type == "") {
		$("#NetSetsItemTypeWin").combobox('setValue',"");
		$("#NetSetsTypeSortWin").numberbox('setValue',"");
	}
	if (Type == "Desc" || Type == "") {
		$("#NetSetsItemDescWin").val("");
		$("#NetSetsDescSortWin").numberbox('setValue',"");
	}
	if (Type == "Detail" || Type == "") {
		$("#NetSetsItemDetailWin").val("");
		$("#NetSetsDetailSortWin").numberbox('setValue',"");
		$("#NetSetsDetailIntentWin").val("");
	}
}

// �����ײ�
function BSelWeb_click() {
	var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( !SelOSRowData ) { $.messager.alert("��ʾ","��ѡ��ҽ������ά�������ײͣ�", "info"); return false; }
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	var lnk = "dhcpenetsetsmanager.csp?&HisSetsID=" + ARCOSRowid;

	window.open(PEURLAddToken(lnk),"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=100,left=100,width=1200,height=700");
}

// ************************************************��ϸά��************************************************************************** //

// ��ʼ��ҽ������ϸ���
function InitARCOSDetailDataGrid(ARCOSRowid){
	var LocID=$("#LocList").combobox('getValue');
	var HospID= tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	
	$HUI.datagrid("#OrderSetsDetailList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.OrderSets",
			QueryName:"SearchPEOrderSetsDetail",
			ARCOSRowid:ARCOSRowid,
			QueryFlag:"1",
			Type:"B",
			LocID:LocID,
			hospId:HospID
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
			{field:'IsBreakable', title:'����', align:'center',
				formatter:function(value,rowData,rowIndex){
					var itemInfo=""
					// �ж��Ƿ�ҩƷҽ��
		 			if(rowData.ARCIMRowid!="") {
			 			var itemInfo = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetItemTypeAndDesc", ARCIMRowid:rowData.ARCIMRowid}, false);
		 			}
		 			
		 			if(itemInfo.ItemOrderType == "R"){
						return "<a href='#' onclick='UpdateDetail(\"" + rowData.ARCOSItemRowid + "\",\"" + rowIndex + "\")'>\<img style='' src='../scripts_lib/hisui-0.1.0/dist/css/icons/drug.png' border=0/>\</a>"
						 + "<a href='#' onclick='DeleteDetail(\"" + rowData.ARCOSItemRowid + "\",\"" + rowData.ARCIMRowid + "\",\"" + rowIndex + "\",\"" + ARCOSRowid + "\")'>\<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\</a>"
						 ;
		 			}else{
			 			return "<a href='#' onclick='DeleteDetail(\"" + rowData.ARCOSItemRowid + "\",\"" + rowData.ARCIMRowid + "\",\"" + rowIndex + "\",\"" + ARCOSRowid + "\")'>\<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\</a>"
						 ;
		 			}
				}
			},
			{field:'ARCIMDesc',title:'����'},
			{field:'ARCOSDHCDocOrderType',title:'ҽ������',align:'center'},
			/*
			{field:'DHCDocOrdRecLoc',title:'���տ���',
				formatter:function(value,rowData,rowIndex){
					var arr=new Array();
					if (value.indexOf("-") > 0) {
						arr = value.split("-");
					}
					return arr[1];
				}
			},
			*/
			{field:'SampleDesc',title:'�걾',align:'center'},
			{field:'ItmPrice',title:'�۸�',align:'right',
				formatter: function(value,rowData,rowIndex){
					if (ItemPriceEnable != "Y") {
						var value = $.m({
							ClassName:"web.DHCPE.Handle.ARCItmMast",
							MethodName:"GetItmPrice",
							ARCIMRowid:rowData.ARCIMRowid,
							LocID:$("#LocList").combobox('getValue')
						}, false);
					}
					return parseFloat(value).toFixed(2);
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
		pageSize:15,
		pageList:[10,15,20,25,30,35,40],
		fit:true,
		fitColumns:true,
		border:false,
		singleSelect:true,
		toolbar: [
		/**
		{
			iconCls: "icon-remove",
			text: "ɾ��",
			handler: function() {
				BDelDetail_click();
			}
		},
		**/
		{
			iconCls: 'icon-arrow-top',
			text:'����',
			handler: function(){
				var rowData = $('#OrderSetsDetailList').datagrid('getSelected');
				var rowIndex = $('#OrderSetsDetailList').datagrid('getRowIndex',rowData); 
				if (rowIndex >= 0){
					IMove(rowData,rowIndex,-1);
				} else {
					$.messager.alert("��ʾ", "��ѡ��һ�н����ƶ���", "info");
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
					$.messager.alert("��ʾ", "��ѡ��һ�н����ƶ���", "info");
				}
			}
		},{
			iconCls: 'icon-fee',
			text:'�ײͶ���',
			handler: function(){
				var SelRowData = $("#OrderSetsList").datagrid("getSelected");
				var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
				if ( !SelRowData ) { $.messager.alert("��ʾ","��ѡ��ҽ�����ٽ����ײͶ��ۣ�", "info"); return false; }
			    
				if (ItemPriceEnable == "Y") {
					var ARCOSDesc = SelRowData.ARCOSDesc;
					var lnk = "dhcpe.ct.ordsetsprice.csp?OrdSetsId=" + ARCOSRowid + "&LocList=" + $("#LocList").combobox('getValue');;
					websys_showModal({title:'�ײͶ���-' + ARCOSDesc, url:PEURLAddToken(lnk), width:'700',height:'600',iconCls:'icon-w-edit',onClose:function(){
						//var OSData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOrdSetsAmount", ARCOSRowid:ARCOSRowid, Type:"B", LocID:session["LOGON.CTLOCID"], HospID:session["LOGON.HOSPID"]}, false);
						var OSData = tkMakeServerCall("web.DHCPE.CT.OrderSets", "GetOrdSetsAmount", ARCOSRowid, "B", session["LOGON.CTLOCID"], session["LOGON.HOSPID"]);
						OSData = eval("(" + OSData +")");
						var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
						$("#OrderSetsList").datagrid("updateRow", {
							index: SelRowIndex,
							row:{
								OSExPrice:OSData.ARCOSPrice+"Ԫ", // OSExData.OSExPrice,  // �۸�
							}
						});
						$("#OrderSetsDetailList").datagrid("reload");
						InitToolbarForARCOSPrice(ARCOSRowid);
					}});
					//websys_lu(lnk,"aaaaaaa","iconCls=icon-w-edit,width=700,height=600,hisui=true,title=�ײͶ���-" + ARCOSDesc);
					return false;
				} else {
					if(SelRowData.BreakDesc == "�ɲ��") {
						$.messager.alert("��ʾ","ѡ���ҽ�����ǿɲ�ֵĲ��ܽ����ײͶ��ۣ�", "info"); 
						return false;
				    }

					ClearPrice();
					$("#OrderSetsPriceWin").show();

					var ARCOSDesc = SelRowData.ARCOSDesc;
					var AmtData = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOrdSetsAmount", ARCOSRowId:ARCOSRowid,Type:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}, false);
						
					if (AmtData.Amount <= 0) {
						$.messager.alert("��ʾ","ҽ����ԭ�۸�Ϊ�㣬����Ҫ���ۣ�","info");
						$("#OrderSetsPriceWin").window("close");
						return false;
					}
					
					$("#OSDescWin").val(ARCOSDesc);   // �ײ�����
					$("#OSAmountWin").val(AmtData.Amount);   // �ײ�ԭ��
					$("#OSPriceWin").val(AmtData.ARCOSPrice);   // �ײͶ���
		       	
					var myWin = $HUI.dialog("#OrderSetsPriceWin", {
						iconCls:'icon-w-paid',
						resizable:true,
						title:'�ײͶ���',
						modal:true,
						buttonAlign:'center',
						buttons:[{
							text:'ȷ��',
							handler:function(){
								UpdPrice();
							}
						},{
							text:'����',
							handler:function(){
								UndoPrice("1");
							}
						}]
					});
				}			
			}
		},{}],
		onLoadSuccess: function (data) {
			InitToolbarForARCOSPrice(ARCOSRowid);
		},
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�     	
		}
	});
}

function InitDrugInfo(Id) {	
	// ������λ
	$HUI.combobox("#ItemUOMWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDoseUOM&ARCIMRowid=" + Id + "&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	// Ƶ��
	$HUI.combobox("#ItemFrequenceWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemFreq&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	// �÷�
	$HUI.combobox("#ItemInstructionWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemInstruction&ARCIMRowid=" + Id + "&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	// �Ƴ�
	$HUI.combobox("#ItemDurationWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDuration&ARCIMRowid=" + Id + "&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	// ��ע
	$HUI.combobox("#ItemRemarkWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=Remark&ARCIMRowid=" + Id + "&ResultSetType=array",
		valueField:'Desc',
		textField:'Desc',
		defaultFilter:4
	});
	/*
	// ����˵��
	$HUI.combobox("#ItemPriorRemarksWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=PriorRemarks&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	*/
}

function ItemClear(Data) {
	$("#ItemDescWin").val(Data.ARCIMDesc);
	$("#ItemDoseQtyWin").numberbox('setValue',Data.ARCOSItemDoseQty);
	$("#ItemUOMWin").combobox('setValue',Data.ARCOSItemUOMDR);
	$("#ItemFrequenceWin").combobox('setValue',Data.ARCOSItemFrequenceDR);
	$("#ItemInstructionWin").combobox('setValue',Data.ARCOSItemInstructionDR);
	$("#ItemDurationWin").combobox('setValue',Data.ARCOSItemDurationDR);
	$("#ItemLinkDoctorWin").val(Data.ARCOSItmLinkDoctor);
	$("#ItemRemarkWin").combobox('setValue',Data.Tremark);
	$("#ItemPriorRemarksWin").combobox('setValue',Data.OrderPriorRemarksDR);
}

function BDelDetail_click(){
	var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	if (ARCOSRowid != "") {
		var SelRowData = $("#OrderSetsDetailList").datagrid("getSelected");
		var SelRowIndex = $("#OrderSetsDetailList").datagrid("getRowIndex", SelRowData);
		if (SelRowData) {
			DeleteDetail(SelRowData.ARCOSItemRowid, SelRowData.ARCIMRowid, SelRowIndex, ARCOSRowid);
		} else { 
			$.messager.alert("��ʾ","��ѡ��һ�н���ɾ����", "info");
			return false;
		}	
	} else {
		$.messager.alert("��ʾ","û��ѡ��ҽ���ף�","info");
		return false;
	}
}

function UpdateDetail(ItemRowid, curIndex) {
	// �ж��Ƿ�ҩƷҽ��
	var itemInfo = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOSItemData", OSItemId:ItemRowid}, false);
	if (itemInfo.ARCOSItemOrderType == "R") {
		$("#AddMedItemWin").show();
				
		InitDrugInfo(itemInfo.ARCIMRowid);
		ItemClear(itemInfo)
		
		var myWin = $HUI.dialog("#AddMedItemWin", {
			iconCls:'icon-w-plus',
			resizable:true,
			title:'ҩƷ��Ϣ',
			modal:true,
			onClose: function() {
				ItemClear("");
			},
			onOpen: function () {
			},
			buttonAlign:'center',
			buttons:[{
				text:'ȷ��',
				handler:function(){
					var DoseQty = $("#ItemDoseQtyWin").val();
					var DoseUOM = $("#ItemUOMWin").combobox('getValue');
					var Frequence = $("#ItemFrequenceWin").combobox('getValue');
					var Instruction = $("#ItemInstructionWin").combobox('getValue');
					var Duration = $("#ItemDurationWin").combobox('getValue');
					var LinkDoctor = $("#ItemLinkDoctorWin").val();
					var remark = $("#ItemRemarkWin").combobox('getValue');
					var PriorRemarksDR = ""  // $("#ItemPriorRemarksWin").combobox('getValue');
					
					var itemStr = DoseQty + "^" + DoseUOM + "^" + Frequence + "^" + Instruction + "^" + Duration + "^" + LinkDoctor + "^" + remark + "^" + PriorRemarksDR;
					var data = $.m({
						ClassName:"web.DHCPE.CT.OrderSets",
						MethodName:"UpdOSItemData",
						OSItemId:ItemRowid,
						Data:itemStr
					}, function (ret) {
						if (ret == "0") {
							$.messager.alert("��ʾ","���³ɹ���","info");
							curIndex = parseInt(curIndex);
							var OSItemData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOSItemData", OSItemId:ItemRowid}, false);
							$("#OrderSetsDetailList").datagrid("updateRow", {
								index:curIndex,
								row:{
									ARCOSItemUOMDR:OSItemData.ARCOSItemUOMDR,
									ARCOSItemFrequenceDR:OSItemData.ARCOSItemFrequenceDR,
									ARCOSItemDurationDR:OSItemData.ARCOSItemDurationDR,
									ARCOSItemInstructionDR:OSItemData.ARCOSItemInstructionDR,
									OrderPriorRemarksDR:OSItemData.OrderPriorRemarksDR,
									
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
							ItemClear("");
							myWin.close();
						}
					});
					return data;
				}
			},{
				text:'ȡ��',
				handler:function(){
					ItemClear("");
					myWin.close();
				}
			}]
		});
	} else {
		$.messager.alert("��ʾ","��ҩƷ��Ŀ����Ҫ�޸ģ�","info");
		return false;
	}
}

function DeleteDetail(ItemRowid, ARCIMRowid, ind, ARCOSRowid) {
	if (ItemPriceEnable == "Y") {
		var amtflag = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveAmountNew", ARCOSRowid:ARCOSRowid,Type:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}, false);
	} else {
		var amtflag = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveAmount", ARCOSRowid:ARCOSRowid}, false);
	}
	if (amtflag == "1") {
		/*if ( confirm("���ײ��Ѷ��ۣ���ɾ����Ŀ���ָ�ԭ�ۣ�ȷ��ɾ����")) {
			UndoPrice("0");
		} 
		*/
		$.messager.confirm("ȷ��", "���ײ��Ѷ��ۣ���ɾ����Ŀ���ָ�ԭ�ۣ�ȷ��ɾ����", function(r){
			if (r){
				UndoPrice("0");
				$.m({
					ClassName:"web.DHCARCOrdSets",
					MethodName:"DeleteItem",
					ARCOSItemRowid:ItemRowid,
					ARCIMRowid:ARCIMRowid
				}, function(ret) {
				if ( ret == 0 ) {
					$.messager.alert("��ʾ","ɾ���ɹ���", "info");
			
					if (ItemPriceEnable == "Y") {
						var iPrice = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"UpdateOSExPriceNew", ARCOSRowid:ARCOSRowid}, false);
						$("#OrderSetsDetailList").datagrid("reload");
					} else {
						var iPrice = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"UpdateOSExPrice", ARCOSRowid:ARCOSRowid}, false);
						$("#OrderSetsDetailList").datagrid("deleteRow", ind);
					}
					
					var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
					var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
			
					$("#OrderSetsList").datagrid("updateRow", {
						index: SelOSRowIndex,
						row:{
							OSExPrice: parseFloat(iPrice).toFixed(2)+"Ԫ",  // �۸�
						}
					});
			
					InitToolbarForARCOSPrice(ARCOSRowid);
						
					SetRowStyle("#QryRisItemList");
					SetRowStyle("#QryLisItemList");
					SetRowStyle("#QryMedicalItemList");
					SetRowStyle("#QryOtherItemList");
				} else {
					$.messager.alert("��ʾ","ɾ��ʧ�ܣ�", "info");
					$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
				}
			});
	
		}else {
				return false;
			}
		});
	
		
	} else if (amtflag == "-1") {
		$.messager.alert("��ʾ","�����ҽ���ף����ʵ��", "info");
		return false;
	} else {
		$.m({
			ClassName:"web.DHCARCOrdSets",
			MethodName:"DeleteItem",
			ARCOSItemRowid:ItemRowid,
			ARCIMRowid:ARCIMRowid
		}, function(ret) {
			if ( ret == 0 ) {
				
				if (ItemPriceEnable == "Y") {
					// ����۸�
					var preturn = tkMakeServerCall("web.DHCPE.CT.OrderSets", "UpdPEOnePrice", "DEL", ItemRowid, session["LOGON.CTLOCID"], session["LOGON.HOSPID"]);
					if (preturn != "0") {
						$.messager.alert("��ʾ", "��ϸɾ���ɹ����ײͼ۸����ʧ�ܣ�������ά���۸�" + preturn, "info");
					} else {
						$.messager.alert("��ʾ","ɾ���ɹ���", "info");
					}
					var iPrice = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"UpdateOSExPriceNew", ARCOSRowid:ARCOSRowid}, false);
				} else {
					$.messager.alert("��ʾ","ɾ���ɹ���", "info");
					var iPrice = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"UpdateOSExPrice", ARCOSRowid:ARCOSRowid}, false);
				}
				
				$("#OrderSetsDetailList").datagrid("deleteRow", ind);
				
				var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
				var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
				
				$("#OrderSetsList").datagrid("updateRow", {
					index: SelOSRowIndex,
					row:{
						OSExPrice: parseFloat(iPrice).toFixed(2)+"Ԫ",  // �۸�
					}
				});
				
				InitToolbarForARCOSPrice(ARCOSRowid);
				
				SetRowStyle("#QryRisItemList");
				SetRowStyle("#QryLisItemList");
				SetRowStyle("#QryMedicalItemList");
				SetRowStyle("#QryOtherItemList");
			} else {
				$.messager.alert("��ʾ","ɾ��ʧ�ܣ�", "info");
				$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
			}
		});
	}
}

// ����ҽ������ϸ
function IAdd(AddType,Id,AddAmount,Index,tablename){
	var ARCOSRowid="",flag;
	
	var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData) { ARCOSRowid = SelOSRowData.ARCOSRowid; }  // ҽ����ID
	else { $.messager.alert("��ʾ","��ѡ��ҽ���ף�", "info"); return false; }

	//�ж��Ƿ�����ų���Ŀ
	var ExcludeFlag=tkMakeServerCall("web.DHCPE.CT.OrderSets","IsExcludeArcItem",ARCOSRowid,Id)
	if(ExcludeFlag=="1"){
		$.messager.alert("��ʾ","�����ų���Ŀ�����������","info");
		return false;
	}
	var CTLOCID=$("#LocList").combobox('getValue');
	
	// �ж�ҽ�������Ƿ��и�ҽ��
	flag = $.m({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveItemInOrdSets", ARCOSRowid:ARCOSRowid, ArcimRowId:Id}, false);
	if (flag == 1) { $.messager.alert("��ʾ", "����Ŀ�Ѵ��ڣ������ظ���ӣ�", "info"); return false; }
	
	//�ж��ײ͵�VIP�ȼ����Ա��Ƿ��ҽ����һ��
	$.cm({
		ClassName:"web.DHCPE.CT.OrderSets",
		MethodName:"IsCanAddItem",
		ARCOSRowid:ARCOSRowid,
		ArcimRowId:Id,
		LocID:CTLOCID
	}, function (json) {
		if (json.code == 1) {
			AddOSItem(SelOSRowData,ARCOSRowid,Id);
		} else if (json.code == 0) {
			$.messager.confirm("ȷ��", json.msg, function(r){
				if (r) {
					flag = $.m({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"UpdateOSData", ARCOSRowid:ARCOSRowid, Data:json.data}, false);
					if (flag == "0") {
						var OSExData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
						var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
						$("#OrderSetsList").datagrid("updateRow", {
							index: SelOSRowIndex,
							row:{
								OSExSex:OSExData.Sex,				// �Ա�
								SexDesc:OSExData.SexDesc,  // �Ա� $("#OrderSetSexWin").combobox('getValue')
							}
						});
						
						AddOSItem(SelOSRowData,ARCOSRowid,Id);
					} else {
						$.messager.alert("��ʾ","����ʧ�ܣ�","info");
						return false;
					}
				}
			});
		} else {
			$.messager.alert("��ʾ",json.msg,"info");
			return false;
		}
	});
}

/// ҽ����ID
function AddOSItem(SelOSRowData,ARCOSRowid,ItmId)
{
	var DHCDocOrdRecLoc="";
	// �걾
	var SampleId = $.m({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetDefLabSpecId", ArcimRowId:ItmId}, false);
	// 0 ��λ   1 ���տ���
	var rtn = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetItemLocIdAndUOMId", ArcimRowId:ItmId}, false);

	DHCDocOrdRecLoc = rtn.RecLoc;
	if (DHCDocOrdRecLoc == "") {
		$.messager.confirm("ȷ��", "����Ŀû�н��տ��ң�ȷ����ӣ�", function(r){
			if (r){
				if (ItemPriceEnable == "Y") {
					var amtflag = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveAmountNew", ARCOSRowid:ARCOSRowid,Type:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}, false);
				} else {
					var amtflag = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveAmount", ARCOSRowid:ARCOSRowid}, false);
				}
				if (amtflag == "1") {
					$.messager.confirm("ȷ��", "���ײ��Ѷ��ۣ����������Ŀ���ָ�ԭ�ۣ�ȷ����ӣ�", function(r){
						if (r){
							UndoPrice("0");
							IAddItem(SelOSRowData, ARCOSRowid, ItmId, SampleId, DHCDocOrdRecLoc)
						}
					});	
				} else if (amtflag == "-1") {
					$.messager.alert("��ʾ","�����ҽ���ף����ʵ��", "info");
					return false;
				} else {
					IAddItem(SelOSRowData, ARCOSRowid, ItmId, SampleId, DHCDocOrdRecLoc)
				}
				
			}
		});
	} else {
		if (ItemPriceEnable == "Y") {
			var amtflag = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveAmountNew", ARCOSRowid:ARCOSRowid,Type:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}, false);
		} else {
			var amtflag = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveAmount", ARCOSRowid:ARCOSRowid}, false);
		}
		if (amtflag == "1") {
			$.messager.confirm("ȷ��", "���ײ��Ѷ��ۣ����������Ŀ���ָ�ԭ�ۣ�ȷ����ӣ�", function(r){
				if (r){
					UndoPrice("0");
					IAddItem(SelOSRowData, ARCOSRowid, ItmId, SampleId, DHCDocOrdRecLoc)
				}
			});	
		} else if (amtflag == "-1") {
			$.messager.alert("��ʾ","�����ҽ���ף����ʵ��", "info");
			return false;
		} else {
			IAddItem(SelOSRowData, ARCOSRowid, ItmId, SampleId, DHCDocOrdRecLoc)
		}
	}
}

function GetDrugByArcIM(ArcIMID)
{
	var LocID=session['LOGON.CTLOCID'];
	var Info=tkMakeServerCall("web.DHCPE.CT.HISUICommon","GetDrugByID",ArcIMID,LocID,"ArcimID"); 	
	//alert(Info)
	var InfoOne=Info.split("^");
	$("#ItemDoseQtyWin").numberbox('setValue',InfoOne[0]);
	$("#ItemUOMWin").combobox('setValue',InfoOne[1]);
	$("#ItemFrequenceWin").combobox('setValue',InfoOne[2]);
	$("#ItemDurationWin").combobox('setValue',InfoOne[3]);
	$("#ItemInstructionWin").combobox('setValue',InfoOne[4]);
		
}


function IAddItem(SelOSRowData, ARCOSRowid, Id, SampleId, DHCDocOrdRecLoc) {
	// �ж��Ƿ�ҩƷҽ��
	var itemInfo = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetItemTypeAndDesc", ARCIMRowid:Id}, false);
	if (itemInfo.ItemOrderType == "R") {
		$("#AddMedItemWin").show();
						
		InitDrugInfo(Id);
		
		GetDrugByArcIM(Id); //����ҽ�����ʼ��ҩƷ������Ϣ	
		
		$("#ItemDescWin").val(itemInfo.ARCIMDesc);
						
		var myWin = $HUI.dialog("#AddMedItemWin", {
			iconCls:'icon-w-plus',
			resizable:true,
			title:'ҩƷ��Ϣ',
			modal:true,
			onClose: function() {
				ItemClear("");
			},
			onOpen: function () {
			},
			buttonAlign:'center',
			buttons:[{
				text:'ȷ��',
				handler:function(){
					ItemDoseQty = $("#ItemDoseQtyWin").val();
					ItemDoseUOMID = $("#ItemUOMWin").combobox('getValue');
					ItemFrequenceID = $("#ItemFrequenceWin").combobox('getValue');
					ItemInstructionID = $("#ItemInstructionWin").combobox('getValue');
					ItemDurationID = $("#ItemDurationWin").combobox('getValue');
					ItmLinkDoctor = $("#ItemLinkDoctorWin").val();
					remark = $("#ItemRemarkWin").combobox('getValue');
					OrderPriorRemarksDR = ""  // $("#ItemPriorRemarksWin").combobox('getValue');
					
					var data = $.m({
						ClassName:"web.DHCARCOrdSets",
						MethodName:"InsertItem",
						ARCOSRowid:ARCOSRowid,
						ARCIMRowid:Id,
						ItemQty:1,
						ItemDoseQty:ItemDoseQty,
						ItemDoseUOMID:ItemDoseUOMID,
						ItemFrequenceID:ItemFrequenceID,
						ItemDurationID:ItemDurationID,
						ItemInstructionID:ItemInstructionID,
						ItmLinkDoctor:ItmLinkDoctor,
						remark:remark,
						DHCDocOrderTypeID:3,  // ^OECPR  3  ��ʱҽ��
						SampleId:SampleId,
						ARCOSItemNO:"",
						OrderPriorRemarksDR:OrderPriorRemarksDR,
						DHCDocOrderRecLoc:DHCDocOrdRecLoc
					}, function (ret) {
						//$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
						//return ret;
						if (ret.indexOf("||") > 0) {
							if (ItemPriceEnable == "Y") {
								// ����۸�
								var preturn = tkMakeServerCall("web.DHCPE.CT.OrderSets", "UpdPEOnePrice", "ADD", ret, session["LOGON.CTLOCID"], session["LOGON.HOSPID"]);
								if (preturn != "0") {
									$.messager.alert("��ʾ", "��ϸ���ӳɹ����ײͼ۸����ʧ�ܣ�������ά���۸�" + preturn, "info");
								}
								$("#OrderSetsDetailList").datagrid("reload");
								var OSPrice = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"UpdateOSExPriceNew", ARCOSRowid:ARCOSRowid}, false);
							} else {
								var OSItemData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOSItemData", OSItemId:ret}, false);
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
										//DHCDocOrdRecLoc:OSItemData.DHCDocOrdRecLoc,
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
								var OSPrice = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"UpdateOSExPrice", ARCOSRowid:ARCOSRowid}, false);
							}
							
							var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
							$("#OrderSetsList").datagrid("updateRow", {
								index: SelOSRowIndex,
								row:{
									OSExPrice:parseFloat(OSPrice).toFixed(2)+"Ԫ",  // �۸�
								}
							});
							
							InitToolbarForARCOSPrice(ARCOSRowid);
							
							SetRowStyle("#QryRisItemList");
							SetRowStyle("#QryLisItemList");
							SetRowStyle("#QryMedicalItemList");
							SetRowStyle("#QryOtherItemList");
							ItemClear("");
							myWin.close();
						}
					});
					return data;
				}
			},{
				text:'ȡ��',
				handler:function(){
					ItemClear("");
					myWin.close();
				}
			}]
		});
	} else {
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
			DHCDocOrderTypeID:3,  // ^OECPR  3  ��ʱҽ��
			SampleId:SampleId,
			ARCOSItemNO:"",
			OrderPriorRemarksDR:"",
			DHCDocOrderRecLoc:DHCDocOrdRecLoc
		}, function (ret) {
			//$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
			//return ret;
			if (ret.indexOf("||") > 0) {
				if (ItemPriceEnable == "Y") {
					// ����۸�
					var preturn = tkMakeServerCall("web.DHCPE.CT.OrderSets", "UpdPEOnePrice", "ADD", ret, session["LOGON.CTLOCID"], session["LOGON.HOSPID"]);
					if (preturn != "0") {
						$.messager.alert("��ʾ", "��ϸ���ӳɹ����ײͼ۸����ʧ�ܣ�������ά���۸�" + preturn, "info");
					}
					$("#OrderSetsDetailList").datagrid("reload");
					var OSPrice = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"UpdateOSExPriceNew", ARCOSRowid:ARCOSRowid}, false);
				} else {
					var OSItemData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOSItemData", OSItemId:ret}, false);
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
							//DHCDocOrdRecLoc:OSItemData.DHCDocOrdRecLoc,
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
					var OSPrice = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"UpdateOSExPrice", ARCOSRowid:ARCOSRowid}, false);
				}
				
				var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
				$("#OrderSetsList").datagrid("updateRow", {
					index: SelOSRowIndex,
					row:{
						OSExPrice:parseFloat(OSPrice).toFixed(2)+"Ԫ",  // �۸�
					}
				});
				InitToolbarForARCOSPrice(ARCOSRowid);
				
				SetRowStyle("#QryRisItemList");
				SetRowStyle("#QryLisItemList");
				SetRowStyle("#QryMedicalItemList");
				SetRowStyle("#QryOtherItemList");
				
				return data;
			}
		});
	}
}

// �ƶ�  flag -1 ����   1 ����
function IMove(Data,Index,flag) {
	var ARCOSRowid="";
	
	var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData) { ARCOSRowid = SelOSRowData.ARCOSRowid; }  // ҽ����ID
	else { $.messager.alert("��ʾ","��ѡ��ҽ���ף�", "info");return false; }
	if (ARCOSRowid == "") { $.messager.alert("��ʾ","��ѡ��ҽ���ף�", "info");return false; }
	if (Data) {
		// ��ǰ����ź�ID
		if (Data.ITMSerialNo != "") { var toup = Data.ITMSerialNo; }
		else { return false; }
		if (Data.ARCOSItemRowid != "") { var upid = Data.ARCOSItemRowid; }
		else { return false; }
		
		var changeRowData = $('#OrderSetsDetailList').datagrid('getRows');
		if( !changeRowData[Index + flag] ) return false;
		var rowData = changeRowData[Index + flag];
		
		// �����е���ź�ID
		if (rowData.ITMSerialNo != "") { var todown = rowData.ITMSerialNo; }
		else { return false; }
		if (rowData.ARCOSItemRowid != "") { var downid = rowData.ARCOSItemRowid; }
		else { return false; }
		
		UpdateSerialNO(downid,toup);
		UpdateSerialNO(upid,todown);
        
		var LocID=$("#LocList").combobox('getValue');
		var HospID= tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCPE.CT.OrderSets",QueryName:"SearchPEOrderSetsDetail",ARCOSRowid:ARCOSRowid,QueryFlag:"1",Type:"B",LocID:LocID,hospId:HospID}); 

		// $("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
	}
}

// ��������
function UpdateSerialNO(ARCOSItemRowid,SerNO) {
	$.m({
		ClassName:"web.DHCPE.CT.OrderSets",
		MethodName:"UpdateItemSerialNo",
		ARCOSItemRowid:ARCOSItemRowid,
		ItemSerialNo:SerNO,
		ArcimId:""
	},function(rtn){
		
	});
	///var rtn=tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO,arcimid)


	//tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO)
}


// ��ϸ�˵�������ʾ�ײͼ۸�
function InitToolbarForARCOSPrice(ARCOSRowid) {
	if (ARCOSRowid == "") return "";
	var AmtData = $.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetOrdSetsAmount",ARCOSRowId:ARCOSRowid,Type:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}, false);
	$("#OSAmountWin").val(AmtData.Amount);   // �ײ�ԭ��
	$("#OSPriceWin").val(AmtData.ARCOSPrice);   // �ײͶ���
				
	var gridToolbar = $("#OrderSetsDetailDiv .datagrid-toolbar table tr td:nth-child(4)");
	gridToolbar.empty();
	gridToolbar.append("<span>ԭ�ۣ�</span><span style='font-size:14px;color:brown;font-weight:700;'>" + AmtData.Amount + "</span>Ԫ&nbsp;&nbsp;�ۼۣ�</span><span style='font-size:14px;color:red;font-weight:700;'>" + AmtData.ARCOSPrice + "</span>Ԫ</span>");
}

// ************************************************�۸�ά��************************************************************************** //

// �ײͶ���
function UpdPrice() {
	var obj, Date = "", Price = "", ARCOSRowid = "", ARCOSAmount = "";
	
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData ) { $.messager.alert("��ʾ","��ѡ�����ҽ�����ٽ����ײͶ��ۣ�","info"); return false; }
	ARCOSRowid = SelRowData.ARCOSRowid;
	
	if ($("#OSDateWin").val() != "") { Date = $("#OSDateWin").val(); }
	else { $.messager.alert("��ʾ","��ǰ����Ϊ�գ���ˢ�½���","info"); return false; }

	if ($("#OSAmountWin").val() != "") { ARCOSAmount = $("#OSAmountWin").val(); }

		
	if (($("#OSAmtWin").val() == "") && (($("#OSDiscountWin").val() == ""))) {
		$.messager.alert("��ʾ","������ ���۶��� �� �����ۿ�.","info");
		return false;
	} else {
		if ($("#OSAmtWin").val() != "") {
			Price_change("Amt");
		} else {
			Price_change("Dis");
		}
	}
	
	if ($("#OSAmtWin").val() != "") { Price=$("#OSAmtWin").val(); } 
		
	var MoneyF = /(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/;
	if (($("#OSAmtWin").val() != "") && (!MoneyF.test(Price))) {
		$.messager.alert("��ʾ","��������ȷ���.","info");
		return false;
	}
	
	$.m({  // var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,Date,Date,Price,"");
		ClassName:"web.DHCPE.CT.OrderSets",
		MethodName:"UpdateARCOSPrice",
		ARCOSRowid:ARCOSRowid,
		DateFrom:Date,
		DateTo:Date,
		Price:Price,
		Amount:ARCOSAmount
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.alert("��ʾ","�ײͼ۸���³ɹ���","info");
			
			//var OSExData=$.cm({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
			
			$("#OrderSetsList").datagrid("updateRow", {
				index: SelRowIndex,
				row:{
					OSExPrice:Price+"Ԫ", // OSExData.OSExPrice,  // �۸�
				}
			});
			InitToolbarForARCOSPrice(ARCOSRowid);
			$("#OrderSetsPriceWin").window("close");
			
		} else {
			$.messager.alert("��ʾ","�ײͼ۸����ʧ�ܣ�"+rtn,"info");
		}
	});
	ClearPrice();
}

// ��ԭ�۸�
function UndoPrice(Flag) {
	var ARCOSRowid = "", ARCOSAmount = 0;
	
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData) { $.messager.alert("��ʾ","��ѡ��ҽ�����ٽ����ײͶ��ۣ�","info"); return false; }
	ARCOSRowid = SelRowData.ARCOSRowid;
	if ($("#OSAmountWin").val() != "") { ARCOSAmount = $("#OSAmountWin").val(); }
	$.m({  // var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,"","","","");
		ClassName:"web.DHCPE.CT.OrderSets",
		MethodName:"UpdateARCOSPrice" + ((ItemPriceEnable=="Y")?"New":""),
		ARCOSRowid:ARCOSRowid,
		DateFrom:"",
		DateTo:"",
		Price:""
	}, function(rtn) {
		if (rtn == "0") {
			if (Flag == "1") {
				$.messager.alert("��ʾ","�ײͼ۸�ԭ�ɹ���","info");
				if (ItemPriceEnable == "Y") $("#OrderSetsDetailList").datagrid('reload');
				$("#OrderSetsList").datagrid("updateRow", {
					index: SelRowIndex,
					row:{
						OSExPrice:ARCOSAmount+"Ԫ", // OSExData.OSExPrice,  // �۸�
					}
				});
				
				InitToolbarForARCOSPrice(ARCOSRowid);
				$("#OrderSetsPriceWin").window("close");
			}
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
			$("#OSDiscountWin").val("");
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
			$("#OSAmtWin").val("");
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
	//var DFLimit = $.m({ClassName:"web.DHCPE.ChargeLimit", MethodName:"DFLimit", UserId:userId}, false);
	
	var LocID=$("#LocList").combobox('getValue');
	var OPflag=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",userId,LocID);
	var OPflagOne=OPflag.split("^");
	var DFLimit=OPflagOne[4]; //����ۿ���
	 
	if (DFLimit=="0") {
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
	$("#OSAmtWin").numberbox('setValue',"");
	$("#OSDiscountWin").numberbox('setValue',"");
}

// ************************************************��Ŀά��************************************************************************** //

// ��ʼ����Ŀ������
function InitItemDataGrid(tablename,type) {
	$HUI.datagrid(tablename,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"StationOrderList",
			Type:type,
			TargetFrame:"PreItemList",
			PreIADMID:"", 
			StationID:"",
			BType:"B",
			LocID:session['LOGON.CTLOCID'],
			hospId:session['LOGON.HOSPID']
		},
		columns:[[
			{field:'TUOM', title:'��λ', hidden:true},
			
			{field:'STORD_ARCIM_DR', title:'����', align:'center', formatter:function(value,row,index) {
					return "<a href='#' onclick='IAdd(\"ITEM\", \"" + value + "\", \"" + row.STORD_ARCIM_Price + "\", \"" + index + "\", \"" + tablename + "\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
					</a>";
				}
			},
			{field:'STORD_ARCIM_Code', title:'����', width:15},
			{field:'STORD_ARCIM_Desc', title:'����', width:55},
			{field:'STORD_ARCIM_Price', title:'�۸�', align:'right', width:8, formatter:function(value,row,index) {
					return parseFloat(value).toFixed(2);
				}
			},
			{field:'TLocDesc',title:'վ��', width:15}
		]],
		striped:true, // ���ƻ�
		pagination:true,
		pageSize:25,
		pageList:[10,25,50,100],
		fit:true,
		border:false,
		fitColumns:true,
		singleSelect:true,
		//toolbar: [],
		rowStyler: function(rowIndex,rowData) {
			//return SetRowStyle(rowIndex,rowData,tablename);  
        },
		onDblClickRow:function(rowIndex,rowData){
			var ItemType = "ITEM";
			var ItemId = rowData.STORD_ARCIM_DR;
			var AddAmount = rowData.STORD_ARCIM_Price;
			
			IAdd(ItemType, ItemId, AddAmount, rowIndex, tablename);
			
			var obj = $(tablename).datagrid('getSelections');
			var selobj = $(tablename).datagrid("selectRecord",rowData.STORD_ARCIM_DR);
			selobj.css("background","#ccc");
		},
		onLoadSuccess: function (data) {
			SetRowStyle(tablename);
		},
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�     	
		}
	});
}

function InitOrdSetsDataGrid(tablename,type) {
	var ARCOSRowid = "";
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( SelRowData ) ARCOSRowid = SelRowData.ARCOSRowid;
	
	$HUI.datagrid(tablename,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.OrderSets",
			QueryName:"SearchPECanCopyOS",
			ARCOSRowid:ARCOSRowid,
			Desc:$("#OrdSets").val(),
			Type:type,
			LocID:$("#LocList").combobox('getValue'), //session['LOGON.CTLOCID'],
			HospID:session['LOGON.HOSPID']
		},
		columns:[[
			{field:'OSExSex', title:'OSExSex', hidden:true},
			{field:'OSExVIPLevel', title:'OSExVIPLevel', hidden:true},
			{field:'OSExLoc', title:'OSExLoc', hidden:true},
			
			{field:'ARCOSRowid', title:'����', align:'center', formatter:function(value,row,index) {
					return "<a href='#' onclick='ShowCopyOrdSetsItem(\"" + row.ARCOSRowid + "\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
					</a>";
				}
			},
			{field:'ARCOSDesc', title:'�ײ�����', width:35},
			{field:'SexDesc', title:'�Ա�', align:'center'},
			{field:'VIPDesc', title:'VIP�ȼ�', width:30},
			{field:'OSExPrice',title:'�ۼ�', align:'right'}
		]],
		striped:true, // ���ƻ�
		pagination:true,
		pageSize:25,
		pageList:[10,25,50,100],
		fit:true,
		border:false,
		fitColumns:true,
		singleSelect:true,
		onDblClickRow:function(rowIndex,rowData){
			ShowCopyOrdSetsItem(rowData.ARCOSRowid);
		},
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�     	
		}
	});
}

function SetRowStyle(tablename) {
	
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
//	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( SelRowData ) {
		var ARCOSRowid = SelRowData.ARCOSRowid;
		
		var rows = $(tablename).datagrid("getRows");
		for(var i=0;i<rows.length;i++) {
			var tableDiv = tablename.replace(/List/g, "Div");
			var gridTrbar = $(tableDiv+" .datagrid-btable tbody tr:nth-child(" + ( i + 1 ) + ")");
			if (gridTrbar) {
				var flag = $.m({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveItemInOrdSets", ARCOSRowid:ARCOSRowid, ArcimRowId:rows[i].STORD_ARCIM_DR}, false);
				if (flag == "1") {
					gridTrbar.css("background-color", "#CCCCCC");
				} else if ( (i % 2) == 0) {
					gridTrbar.css("background-color", "#FAFAFA");
				} else {
					gridTrbar.css("background-color", "#FFFFFF");
				}
				//return "background-color:#ccc;";
			}
		}
	}
}

// ��ʾ�ײ���Ŀ
function ShowCopyOrdSetsItem(id) {
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( SelRowData ) {
		var ARCOSRowid = SelRowData.ARCOSRowid;
		$("#CopyOSItemWin").show();
		
		$HUI.datagrid("#CopyOSItemList",{
			url:$URL,
			queryParams:{
				ClassName:"web.DHCPE.CT.OrderSets",
				QueryName:"SearchPEOrderSetsDetail",
				ARCOSRowid:id,
				QueryFlag:"1",
				Type:"B",
				LocID:session['LOGON.CTLOCID'],
				hospId:session['LOGON.HOSPID']
			},		
			columns:[[
				{field:'ARCOSItemRowid', title:'ARCOSItemRowid', checkbox:true},  // ,hidden:true},  // ��Ŀ��ϸID
				//{field:'ARCIMRowid', title:'ARCIMRowid', hidden:true},  // ARCIM
				//{field:'ARCOSItemUOMDR' ,title:'ARCOSItemUOMDR', hidden:true},  // ��λ
				//{field:'ARCOSItemFrequenceDR', title:'ARCOSItemFrequenceDR', hidden:true},  // Ƶ��
				//{field:'ARCOSItemDurationDR', title:'ARCOSItemDurationDR', hidden:true},  // �Ƴ�
				//{field:'ARCOSItemInstructionDR', title:'ARCOSItemInstructionDR', hidden:true},  // �÷�
				//{field:'ARCOSItemCatDR', title:'ARCOSItemCatDR', hidden:true},  // 
				//{field:'ARCOSItemSubCatDR', title:'ARCOSItemSubCatDR', hidden:true},  // 
				//{field:'ARCOSItemOrderType', title:'ARCOSItemOrderType', hidden:true},  // 
				//{field:'ARCOSDHCDocOrderTypeDR', title:'ARCOSDHCDocOrderTypeDR', hidden:true},  // ҽ������
				//{field:'SampleID', title:'SampleID', hidden:true},  // �걾
				//{field:'ITMSerialNo', title:'ITMSerialNo', hidden:true},  // 
				//{field:'OrderPriorRemarksDR', title:'OrderPriorRemarksDR', hidden:true},  // 
				
				//{field:'NO', title:'���', align:'center', hidden:true},
				{field:'ARCIMDesc',title:'����'},
				{field:'ARCOSDHCDocOrderType',title:'ҽ������',align:'center'},
				{field:'SampleDesc',title:'�걾',align:'center'},
				{field:'ItmPrice',title:'�۸�',align:'right',
					formatter: function(value,rowData,rowIndex){
						if (ItemPriceEnable != "Y") {
							var value = $.m({
								ClassName:"web.DHCPE.Handle.ARCItmMast",
								MethodName:"GetItmPrice",
								ARCIMRowid:rowData.ARCIMRowid,
							}, false);
						}
						return parseFloat(value).toFixed(2);
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
			singleSelect:false,
			pagination:true,
			pageSize:25,
			pageList:[10,25,40,100],
			fit:true,
			fitColumns:true,
			border:false,
			//toolbar: [],
			onLoadSuccess: function (data) {
				if (data) {
					$.each(data.rows, function (index, item) {
						var value = $.m({
							ClassName:"web.DHCPE.CT.OrderSets",
							MethodName:"IsHaveItemInOrdSets",
							ARCOSRowid:ARCOSRowid,
							ArcimRowId:item.ARCIMRowid
						}, false);
						if (value == "0") {
	                        $("#CopyOSItemList").datagrid('checkRow', index);
						} else {
		                    $("#CopyOSItemDiv [type='checkbox']")[0].disabled = true;
		                    $("#CopyOSItemDiv [type='checkbox']")[index + 1].disabled = true;
	                    }
	                });
				}
			},
			onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
				if ($("#CopyOSItemDiv [type='checkbox']")[rowIndex + 1].disabled) {
					$("#CopyOSItemDiv [type='checkbox']")[rowIndex + 1].checked = false;
					$("#CopyOSItemDiv [type='checkbox']")[0].checked = false;
					$("#CopyOSItemList").datagrid("unselectRow", rowIndex);
					return false;
				}
			}
		});
		
		var myWin = $HUI.dialog("#CopyOSItemWin", {
			iconCls:'icon-copy',
			resizable:true,
			title:'�����ײ���Ŀ',
			modal:true,
			onClose: function() {
				$("#BCopyOSItem").unbind("click");
			},
			onOpen: function() {
				$("#BCopyOSItem").click(function() {
					BCopyOSItem_click(ARCOSRowid);
			    });
			}
		});
	}
}

// �����ײ���Ŀ
function BCopyOSItem_click(selRowid) {
	
	var rowsData = $("#CopyOSItemList").datagrid("getSelections");
	if (rowsData) {
		var ArcimInfo = "";
		for(var rowIndex in rowsData){
			if (ArcimInfo == "") {
				ArcimInfo = rowsData[rowIndex].ARCOSItemRowid;
			} else {
				ArcimInfo = ArcimInfo + "^" +rowsData[rowIndex].ARCOSItemRowid;
			}
		}
		if (ArcimInfo != "") {
			if (ItemPriceEnable == "Y") {
				var amtflag = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveAmountNew", ARCOSRowid:selRowid,Type:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}, false);
			} else {
				var amtflag = $.cm({ ClassName:"web.DHCPE.CT.OrderSets", MethodName:"IsHaveAmount", ARCOSRowid:selRowid}, false);
			}
			if (amtflag == "1") {
				$.messager.confirm("ȷ��", "���ײ��Ѷ��ۣ����������Ŀ���ָ�ԭ�ۣ�ȷ����ӣ�", function(r){
					if (r){
						UndoPrice("0");
						var rtn = $.m({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"BatchUpdateUserARCOS", ARCOSRowid:selRowid, ArcimInfo:ArcimInfo, LocID:session['LOGON.CTLOCID'], HospID:session['LOGON.HOSPID']}, false);
						if (rtn == "1") {
							$.messager.alert("��ʾ", "���Ƴɹ�", "info");
							$("#OrderSetsDetailList").datagrid("reload");
							$("#CopyOSItemWin").window("close");
						} else if (rtn == "-1") {
							$.messager.alert("��ʾ", "��Ŀ����ʧ�ܣ�", "info");
						} else if (rtn == "-2") {
							$.messager.alert("��ʾ", "��Ŀ�۸����ʧ�ܣ�", "info");
						} else if (rtn == "-3") {
							$.messager.alert("��ʾ", "�ײͼ۸����ʧ�ܣ�", "info");
						} else if (rtn == "-101") {
							$.messager.alert("����", "���򱨴�", "error");
						}
					}
				});	
			} else if (amtflag == "-1") {
				$.messager.alert("��ʾ","�����ҽ���ף����ʵ��", "info");
				return false;
			} else {
				var rtn = $.m({ClassName:"web.DHCPE.CT.OrderSets", MethodName:"BatchUpdateUserARCOS", ARCOSRowid:selRowid, ArcimInfo:ArcimInfo, LocID:session['LOGON.CTLOCID'], HospID:session['LOGON.HOSPID']}, false);
				if (rtn == "1") {
					$.messager.alert("��ʾ", "���Ƴɹ�", "info");
					$("#OrderSetsDetailList").datagrid("reload");
					$("#CopyOSItemWin").window("close");
				} else if (rtn == "-1") {
					$.messager.alert("��ʾ", "��Ŀ����ʧ�ܣ�", "info");
				} else if (rtn == "-2") {
					$.messager.alert("��ʾ", "��Ŀ�۸����ʧ�ܣ�", "info");
				} else if (rtn == "-3") {
					$.messager.alert("��ʾ", "�ײͼ۸����ʧ�ܣ�", "info");
				} else if (rtn == "-101") {
					$.messager.alert("����", "���򱨴�", "error");
				}
			}
		} else {
			$.messager.alert("��ʾ", "û��ѡ���Ƶ���Ŀ��������ѡ��", "info");
		}
	} else {
		$.messager.alert("��ʾ", "û����Ҫ���Ƶ���Ŀ��������ѡ��", "info");
	}
	return false;
}

function GetTableTrID(name) {
	var p = $(name).prev().find('div table:eq(1)');
	var ID = $(p).find('tbody tr:first').attr('id');
	if (ID != undefined && ID != '' && ID.length > 3) {
		ID = ID.toString().substr(0, ID.toString().length - 1);
	}
	return ID;
}

// ��ѯ��Ŀ
function BSearchItem_click(type) {
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( SelRowData ) {
		if (type == "R") $("#QryRisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#RisItem").val(),StationID:$("#Station").combobox("getValue"),PreIADMID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
		else if (type == "L") $("#QryLisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Lab",TargetFrame:"PreItemList",Item:$("#LisItem").val(),PreIADMID:"",StationID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
		else if (type == "M") $("#QryMedicalItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Medical",TargetFrame:"PreItemList",Item:$("#MedicalItem").val(),PreIADMID:"",StationID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
		else if (type == "O") $("#QryOtherItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Other",TargetFrame:"PreItemList",Item:$("#OtherItem").val(),PreIADMID:"",StationID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
	}
}

// ��ѯ�ײ�
function BSearchOS_click() {
	var ARCOSRowid = "";
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( SelRowData ) {
		ARCOSRowid = SelRowData.ARCOSRowid;
	} else {
		//$.messager.alert("��ʾ","����ѡ�����ҽ���ף�","info");
		return false;
	}
	
	$("#QryOrdSetsList").datagrid("load", {
		ClassName:"web.DHCPE.CT.OrderSets",
		QueryName:"SearchPECanCopyOS",
		ARCOSRowid:ARCOSRowid,
		Desc:$("#OrdSets").val(),
		Type:"",
		LocID:$("#LocList").combobox('getValue'),  // session["LOGON.CTLOCID"],
		HospID:session["LOGON.HOSPID"]
	}); 
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
		if (type == "OS") {
			BSearchOS_click();
		} else {
			BSearchItem_click(type);
		}
	}
}

// ��ǰ���ھ� 1840-12-31 ������
function daysBetween(Date) {
	var OneYear = "1840", OneMonth = "12", OneDay = "31";
	if (iDate == "") {
		var mydate = new Date();
		OneYear = mydate.getFullYear();  //��ȡ���������(4λ,1970-????)
		OneMonth = mydate.getMonth()+1;  //��ȡ��ǰ�·�(0-11,0����1��)
		OneDay = mydate.getDate();       //��ȡ��ǰ��(1-31)
	} else {
		OneYear = iDate.split("-")[0];
		OneMonth = iDate.split("-")[1];
		OneDay = iDate.split("-")[2];
	}
	var cha=((Date.parse(OneMonth+'/'+OneDay+'/'+OneYear) - Date.parse("12/31/1840"))/86400000);
	return Math.abs(Math.floor(cha));
}

/**
 * [���������ײ���Ϣ]
 * @Author   wangguoying
 * @DateTime 2021-04-01
 */
function show_netconfig(){
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	var NetOSInfo = $.cm({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"GetHisSetsInfoNew", SetsID:SelRowData.ARCOSRowid, LocID:session["LOGON.CTLOCID"]}, false);
	InitNetSetsWinNew(NetOSInfo);
	$("#NetSetsCfgWin").window("open");	
}

function InitNetSetsWinNew(NetOSInfo) {
	$("#H_NetOrdSetsId").val(NetOSInfo.ID);
	$("#H_HisOrdSetsId").val(NetOSInfo.HisID);
	
	$("#Win_NetDesc").val(NetOSInfo.Desc).validatebox("validate");  // ����
	$("#Win_NetSort").numberbox("setValue",NetOSInfo.Sort).validatebox("validate");  // ���
				
	
	$("#Win_NetSex").combobox("setValue", NetOSInfo.Sex);  // �Ա�
	$("#Win_NetRemark").val(NetOSInfo.Remark);  // ��ע
				
	if (NetOSInfo.GIFlag == "I") $("#Win_NetGroup").checkbox("setValue", false);  // ����
	else $("#Win_NetGroup").checkbox("setValue", true);
	if (NetOSInfo.ActiveFlag == "Y") $("#Win_NetActive").checkbox("setValue", true);  // ����
	else $("#Win_NetActive").checkbox("setValue", false);
}

function update_netsets(){
	var StrInfo = "", NOSHisSetsID = "", NOSDesc = "", NOSVIPLevel = "", NOSSex = "";
	var NOSRemak = "", NOSSort = "", NOSGIFlag = "", NOSLocID = "", NOSActive = "";
	
	var ID = $("#H_NetOrdSetsId").val();	
	NOSHisSetsID = $("#H_HisOrdSetsId").val();
	if (NOSHisSetsID == "") { $.messager.alert("��ʾ", "δѡ��ҽ����!", "info"); return false; }
		
	NOSDesc = $("#Win_NetDesc").val();  // ����
	if (NOSDesc == "") { $.messager.alert("��ʾ", "��������Ϊ��!", "info"); return false; }
		
	NOSSort = $("#Win_NetSort").numberbox("getValue");  // ���
	if (NOSSort == "") { $.messager.alert("��ʾ", "��Ų���Ϊ��!", "info"); return false; }
		
	NOSVIPLevel = ""; //$("#Win_NetLevel").combobox("getValue");  // �ײ͵ȼ�
	//if (NOSVIPLevel == "") { $.messager.alert("��ʾ", "�ײ͵ȼ�����Ϊ��!", "info"); return false; }
		
	NOSSex = $("#Win_NetSex").combobox("getValue");  // �Ա�
	if (NOSSex == "") { $.messager.alert("��ʾ", "�Ա���Ϊ��!", "info"); return false; }
	NOSRemak = $("#Win_NetRemark").val();  // ��ע
	NOSLocID = session["LOGON.CTLOCID"];  // ����
		
	var cIsIG = $("#Win_NetGroup").checkbox("getValue");  // ����
	if (cIsIG) { NOSGIFlag = "G"; }
	else { NOSGIFlag = "I"; }
			    	
	var cIsActive = $("#Win_NetActive").checkbox("getValue");  // ����
	if (cIsActive) { NOSActive = "Y"; }
	else { NOSActive = "N"; }
		
	StrInfo = NOSHisSetsID + "^" + NOSDesc + "^^" + NOSVIPLevel + "^" + NOSSex + "^" + NOSRemak + "^" + NOSSort + "^" + NOSGIFlag + "^" + NOSLocID + "^" + NOSActive;
		
	$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"SaveOrdSets", ID:ID, StrInfo:StrInfo},
		function(ret) {
			if (ret.split("^")[0] == "-1") { $.messager.alert("��ʾ", "����ʧ��!" + ret.split("^")[1], "info"); return false; }
			else { $.messager.alert("��ʾ", "����ɹ�!", "info",cancel_netsets);  }
		}
	);
}

function cancel_netsets(){
	$("#NetSetsCfgWin").window("close");	
}
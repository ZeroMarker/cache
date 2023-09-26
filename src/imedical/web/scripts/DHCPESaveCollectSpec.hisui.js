 //����	DHCPESaveCollectSpec.hisui.js
//����  �걾�ɼ�
//����	2019.07.08
//������  xy

$(function() {

	SetRoomInfo();
	
	InitSaveCollectSpecGrid();

	CreateRoomRecordList();

	//��ӡ
	$("#BPrint").click(function() {
		BPrint_Click();
	});

	//�������
	$("#BShowSoftKey").click(function() {
		ShowSoftKey_click();
	});


	//ȫ������
	$("#BSRRef").click(function() {
		BSRRef_Click();
	});

	//ȫ��ȡ��
	$("#BSARef").click(function() {
		BSARef_Click();
	});

	//����
	$("#BSave").click(function() {
		Save_Click();
	});

	//����Ԥ�ƺ�
	$("#BCancelPlacerNo").click(function() {
		BCancelPlacerNo_Click();
	});

	$("#SpecNo").keydown(function(e) {

		if (e.keyCode == 13) {
			BSave_Click();
		}

	});
	
	$("#PlacerNo").keydown(function(e) {

	if (e.keyCode == 13) {
	// ��ȡ��һ��ѡ�е���
	var selectrow = $('#SaveCollectSpecGrid').datagrid('getSelected');
	if(selectrow==null)
	{
		$.messager.alert("��ʾ","��ѡ�������Ԥ�ƺŵ�ҽ��",'info');
		return false;
	}
	
	//��ȡѡ���е�index
	var selectindex=$('#SaveCollectSpecGrid').datagrid('getRowIndex',selectrow)
	
	//��ȡ��ǰҳ����
	var rows = $('#SaveCollectSpecGrid').datagrid('getRows');
	
	if(selectrow.TSpecNo==""){
		$.messager.alert("��ʾ","�걾��Ϊ��,���ܱ���Ԥ�ƺ�",'info');
		return false;
	}
	if(selectrow.TOSTATDesc!="��ʵ"){
		$.messager.alert("��ʾ","ҽ�����Ǻ�ʵ״̬,���ܱ���Ԥ�ƺ�",'info');
		return false;
	}
	if (selectrow.TOEORIRowId!=""){
		
			var	Strings=selectrow.TOEORIRowId+";"+$("#PlacerNo").val()+";"+selectrow.TSpecNo;
			
		}
	
	var flag = tkMakeServerCall("web.DHCPE.OEOrdItem","UpdateBarInfo",Strings,"N");
	
	if(flag!=0){
		$.messager.alert("��ʾ",flag+",�����ٴα���Ԥ�ƺ�",'info');
		return false;
	}
	if(flag==0){
		
		
		//�����޸ĵ�����
		$('#SaveCollectSpecGrid').datagrid("updateRow",{
			index:selectindex ,
			row: {
				TPlacesNo: $("#PlacerNo").val(),
		
			}
		});

		var i=selectindex+1;
		$("#PlacerNo").val("");
		//��������Ӧ����
		$('#SaveCollectSpecGrid').datagrid('scrollTo',i);
		
		//ѡ����Ӧ����
		$('#SaveCollectSpecGrid').datagrid('selectRow',i); 

	}
	
		}

	});

})
//��������Ź���
function BCancelPlacerNo_Click(){
	
	// ��ȡ��һ��ѡ�е���
	var selectrow = $('#SaveCollectSpecGrid').datagrid('getSelected');
	if(selectrow==null)
	{
		$.messager.alert("��ʾ","��ѡ�������Ԥ�ƺŵ�ҽ��",'info');
		return false;
	}
	if(selectrow.TSpecNo==""){
		$.messager.alert("��ʾ","�걾��Ϊ��,���ܳ���Ԥ�ƺ�",'info');
		return false;
	}
	if(selectrow.TOSTATDesc!="��ʵ"){
		$.messager.alert("��ʾ","ҽ�����Ǻ�ʵ״̬,���ܳ���Ԥ�ƺ�",'info');
		return false;
	}
	//��ȡѡ���е�index
	var selectindex=$('#SaveCollectSpecGrid').datagrid('getRowIndex',selectrow)
	
	if (selectrow.TOEORIRowId!=""){
			var	Strings=selectrow.TOEORIRowId+";"+selectrow.TPlacesNo+";"+selectrow.TSpecNo; 
		}
	
	var flag = tkMakeServerCall("web.DHCPE.OEOrdItem","UpdateBarInfo",Strings,"Y");
	
	if(flag!=0){
		$.messager.alert("��ʾ",flag,'info');
		return false;
	}else{
		$.messager.alert("��ʾ","����Ԥ�ƺųɹ�",'success');
		$("#PlacerNo").val("");
		$('#SaveCollectSpecGrid').datagrid("updateRow",{
			index:selectindex ,
			row: {
				TPlacesNo:"",
			}
		});
 		
		return false;
	}
		
}

function Save_Click() {
	$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex); //���һ�н����б༭	

	$.messager.confirm('ȷ��', 'ȷ��Ҫ����������', function(t) {
		if (t) {
			var rows = $('#SaveCollectSpecGrid').datagrid("getRows");
			if (rows.length > 0) {


				for (var i = 0; i < rows.length; i++) {
					var ret = tkMakeServerCall("web.DHCPE.BarPrint", "RefuseItemBySpecNo", rows[i].TSpecNo);
					if (ret == "0") {
						$("#SaveCollectSpecGrid").datagrid('load', {
							ClassName: "web.DHCPE.BarPrint",
							QueryName: "FindOItemStatusForSpecNo",
							SpecNo: $.trim($("#SpecNo").val()),
							RoomRecordID: $("#RoomRecordID").val(),
							RoomID: $("#RoomID").val(),
							PAADM: $("#PAADM").val(),
							RegNo: $("#RegNo").val(),
						})
					}
				}
			}


		}
	});
}
/*
function SetRoomID()
{
	
	var RoomID=GetValue("RoomID");;
	//SetValue("RoomID",RoomID);
	if (RoomID==""){
		var obj=GetObj("BWaitList");
		if (obj) obj.style.display='none';
		var obj=GetObj("BComplete");
		if (obj) obj.style.display='none';
		var obj=GetObj("BActiveRoom");
		if (obj) obj.style.display='none';
		var TotalLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail";
		var Info="<a href="+TotalLnk+" target='_blank' >�����Ϣ</a>"
	}else{
		var encmeth=GetValue("GetCheckInfoClass");
		var UserID=session['LOGON.USERID'];
		var CheckInfo=cspRunServerMethod(encmeth,RoomID,UserID);
		var Arr=CheckInfo.split("$");
		var NumInfo=Arr[0];
		var HadCheckStr=Arr[1];
		var NoCheckStr=Arr[2];
		var NumArr=NumInfo.split("^");
		var TotalPerson=NumArr[0];
		var HadCheckNum=NumArr[1];
		var NoCheckNum=NumArr[2];
		var NoCheckLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+RoomID+NoCheckStr;
		var HadCheckLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+RoomID+HadCheckStr;
		var TotalLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&StationID="+RoomID;
		var Info="<a href="+TotalLnk+" target='_blank' >��<font color=red size=6>"+TotalPerson+"</font>��</a>,<a href="+HadCheckLnk+" target='_blank' >�Ѽ�<font color=red size=6>"+HadCheckNum+"</font>��</a>,<a href="+NoCheckLnk+" target='_blank' >δ��<font size=6>"+NoCheckNum+"</font>��</a>"
	}
	var obj=document.getElementById("cCheckInfo");
	if (obj) obj.innerHTML=Info;
	
}
*/

function BSave_Click() {
	var vStatus = "",
		vDetailStatus = "",
		ReturnValue = "";

	var SpecNo = $("#SpecNo").val();
	if (SpecNo == "") {
		$.messager.popover({
			msg: "�걾�Ų���Ϊ��",
			type: "info"
		});
		return false;
	}

	var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", SpecNo);
	//alert(Value)
	var Arr = Value.split("^");
	var RegNoFlag = Arr[3];
	if (RegNoFlag == "1") {
		var PIADM = tkMakeServerCall("web.DHCPE.PreIADM", "GetPIADMByRegNo", SpecNo);
		if (PIADM == "") {
			return false
		}
		var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByRegNo", SpecNo);
		if (Status == "REGISTERED") {
			$.messager.confirm("ȷ��", "ȷ��Ҫ������", function(r) {
				if (r) {
					$.m({
						ClassName: "web.DHCPE.DHCPEIAdm",
						MethodName: "UpdateIADMInfo",
						PreIADMID: PIADM,
						Type: 3
					}, function(ReturnValue) {
						if (ReturnValue != '0') {
							var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByRegNo", SpecNo);
							if(Status!="ARRIVED"){
								$.messager.alert("��ʾ", "����ʧ��", "error");
							}
							
						}
					});
				}
			});
		}

		$("#SpecNo").val("");
		$("#RegNo").val(SpecNo);
		$("#PAADM").val(Arr[2]);

	} else {
		$("#RegNo").val("");
		var PAADM = Arr[2];
		$("#PAADM").val(Arr[2]);
		var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
		var AdmArr = Status.split("^");
		var PIADM = AdmArr[1];
		//alert(Status)
		if (PIADM == "") {
			return false
		}
		if (AdmArr[0] == "REGISTERED") {
			$.messager.confirm("ȷ��", "ȷ��Ҫ������", function(r) {
				if (r) {
					$.m({
						ClassName: "web.DHCPE.DHCPEIAdm",
						MethodName: "UpdateIADMInfo",
						PreIADMID: PIADM,
						Type: 3
					}, function(ReturnValue) {
						if (ReturnValue != '0') {
							var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
							if(Status.split("^")[0]!="ARRIVED"){
								$.messager.alert("��ʾ", "����ʧ��", "error");
							}
						}
					});
				}
			});

		}
	}

	if (Arr[0] == "0") {
		//$.messager.alert('��ʾ', Arr[1], "info");
		$.messager.popover({msg: Arr[1],type: "info"});
		return false;
	} else if (Arr[0] == "1") {

		$.messager.confirm("ȷ��", "�ñ걾����߲��ǵ��쵽��,�Ƿ�����걾�˶�?", function(r) {
			if (r) {
				var RoomID = $("#RoomID").val();
				if (RoomID != "") {

					var CurRoomID = Value.split("^")[1];
					vStatus = Value.split("^")[4];
					vDetailStatus = Value.split("^")[5];
					if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
					{
						if (!confirm("�����ߺͽк��߲���ͬһ����,�Ƿ����?")) return false;

					} else if (vRoomRecordID == "") {
						if (!confirm("û�нк�,�Ƿ����?")) return false;
					}
				}
				//parent.vRoomRecordID="";
				vRoomRecordID = CurRoomID;
				if (vStatus == "N") { //�ж��ǲ���ͬһ����
					if (vDetailStatus != "E") { //��������״̬�ģ��������죬����
						var UserID = session['LOGON.USERID'];
						var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

					}
				}

				Init();
				Find();
				BPrint_Click();

			}
		});

		//if (!(confirm("�ñ걾����߲��ǵ��쵽��,�Ƿ�����걾�˶�?"))) {  return false; }
	} else {


		var RoomID = $("#RoomID").val();
		if (RoomID != "") {

			var CurRoomID = Value.split("^")[1];
			vStatus = Value.split("^")[4];
			vDetailStatus = Value.split("^")[5];
			if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
			{
				if (!confirm("�����ߺͽк��߲���ͬһ����,�Ƿ����?")) return false;

			} else if (vRoomRecordID == "") {
				if (!confirm("û�нк�,�Ƿ����?")) return false;
			}
		}
		//parent.vRoomRecordID="";
		vRoomRecordID = CurRoomID;
		if (vStatus == "N") { //�ж��ǲ���ͬһ����
			if (vDetailStatus != "E") { //��������״̬�ģ��������죬����
				var UserID = session['LOGON.USERID'];
				var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

			}
		}

		Init();
		Find();
		BPrint_Click();
	}
}

function Init() {
	var SpecNo = $("#SpecNo").val();
	var RegNo = $("#RegNo").val();
	if ((SpecNo == "") && (RegNo == "")) return false;
	var Str = tkMakeServerCall("web.DHCPE.BarPrint", "GetBaseInfo", RegNo, SpecNo)
	Str = Str.split("^");
	$("#Name").val(Str[0]);
	$("#Sex").val(Str[1]);
	$("#CardID").val(Str[2]);
	$("#RegNo").val(Str[3]);

	var ret = tkMakeServerCall("web.DHCPE.BarPrint", "GetSaveSpecInfo", $("#SpecNo").val(), $("#RoomRecordID").val(), $("#RoomID").val(), $("#PAADM").val())
	$("#CheckInfo").val(ret);


}



function Find() {

	var PAADM = $("#PAADM").val();
	var SpecNo = $("#SpecNo").val();
	var RegNo = $("#RegNo").val();
	if ((vRoomRecordID == "") && (SpecNo == "") && (PAADM == "")) {
		$.messager.alert('��ʾ', '��ǰ�����ߺͱ걾�Ų��ܶ�Ϊ��', "info");
		return false;
	}
	var RoomID = $("#RoomID").val();
	if (RoomID == "") {
		vRoomRecordID = "";

	}

	$("#SaveCollectSpecGrid").datagrid('load', {
		ClassName: "web.DHCPE.BarPrint",
		QueryName: "FindOItemStatusForSpecNo",
		SpecNo: $.trim($("#SpecNo").val()),
		RoomRecordID: $("#RoomRecordID").val(),
		RoomID: $("#RoomID").val(),
		PAADM: $("#PAADM").val(),
		RegNo: $("#RegNo").val(),
		HospID:session['LOGON.HOSPID']
	})

}


//ȫ��ȡ��
function BSARef_Click() {
	var rrows = $('#SaveCollectSpecGrid').datagrid("getRows");
	for (var i = 0; i < rrows.length; i++) {
		var Refuse = rrows[i].TRefuse;
		var ID = rrows[i].TSpecNo;
		if (Refuse == "����") {
			RefuseApp(ID)
		}
	}

}

//ȫ������
function BSRRef_Click() {
	var rrows = $('#SaveCollectSpecGrid').datagrid("getRows");
	for (var i = 0; i < rrows.length; i++) {
		var Refuse = rrows[i].TRefuse;
		var ID = rrows[i].TSpecNo;
		if (Refuse == "ȡ��") {
			RefuseApp(ID)
		}
	}
}


function RefuseApp(ID) {

	var ret = tkMakeServerCall("web.DHCPE.BarPrint", "RefuseItemBySpecNo", ID);
	if (ret == "0") {
		$("#SaveCollectSpecGrid").datagrid('load', {
			ClassName: "web.DHCPE.BarPrint",
			QueryName: "FindOItemStatusForSpecNo",
			SpecNo: $.trim($("#SpecNo").val()),
			RoomRecordID: $("#RoomRecordID").val(),
			RoomID: $("#RoomID").val(),
			PAADM: $("#PAADM").val(),
			RegNo: $("#RegNo").val(),
		})
	}
}

//�������
function ShowSoftKey_click() {
	//var shell = new ActiveXObject("wscript.shell")
	//shell.run("osk.exe");
	location.replace("tabkey:");
	return false;
}

//��ӡ
function BPrint_Click() {
	var PAADM = "";
	var PrintBarFlag = 0;
	var PrintBarCode = $("#PrintBarCode").checkbox('getValue');
	if (PrintBarCode) { var PrintBarFlag = 1;}
    if (PrintBarFlag!==1) return ;
    
 	var RegNo = $("#RegNo").val();   
	var SpecNo = $("#SpecNo").val();

	if (SpecNo==""){ var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", RegNo);}
	else {var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", SpecNo);}
	var Arr = Value.split("^");
	var PAADM = Arr[2];

   if (RegNo==""){
		$.messager.alert("��ʾ", "�걾�Ų���Ϊ��", "info");
		return false;
	}else{
		if (SpecNo!==""){
			PrintAllApp(SpecNo, "Spec", "N")
		}else{
			PrintAllApp(PAADM, "PAADM", "N")
		}
	}
  
}

function InitSaveCollectSpecGrid() {
	$HUI.datagrid("#SaveCollectSpecGrid", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.BarPrint",
			QueryName: "FindOItemStatusForSpecNo",
		},
		onClickRow: onClickRow,
		onAfterEdit: function(index, row, changes) {
			/*
			modifyAfterRow = $('#SaveCollectSpecGrid').datagrid('getRows')[index]['TRefuse'] 
			if(modifyBeforeRow!=modifyAfterRow){
			var ret=tkMakeServerCall("web.DHCPE.BarPrint","RefuseItemBySpecNo",row.TSpecNo);
			if(ret=="0"){
				$("#SaveCollectSpecGrid").datagrid('load',{
					ClassName:"web.DHCPE.BarPrint",
					QueryName:"FindOItemStatusForSpecNo",
					SpecNo:$.trim($("#SpecNo").val()),
					RoomRecordID:$("#RoomRecordID").val(),
					RoomID:$("#RoomID").val(),
					PAADM:$("#PAADM").val(),
					RegNo:$("#RegNo").val(),
				})
			}
			}*/

		},
		onLoadSuccess: function(data) {
			editIndex = undefined;
		},
		columns: [
			[

				{
					field: 'TOEORIRowId',
					title: 'OEORIRowId',
					hidden: true
				}, {
					field: 'TOEORIItmMastDR',
					title: 'ItmMastDR',
					hidden: true
				}, {
					field: 'TAdmId',
					title: 'PAADM',
					hidden: true
				}, {
					field: 'TPlacerColor',
					title: 'PlacerColor',
					hidden: true
				}, {
					field: 'TItemName',
					width: '200',
					title: 'ҽ��',
					formatter: function(value, row, index) {
						return '<span style="color:white">' + value + '</span>';
					},

					styler: function(value, row, index) {
						return 'background-color:' + row.TPlacerColor;
					}
				}, {
					field: 'TSpecName',
					width: '100',
					title: '�걾����'
				}, {
					field: 'TSpecNo',
					width: '150',
					title: '�걾��'
				}, {
					field: 'TRegNo',
					width: '120',
					title: '�ǼǺ�'
				}, {
					field: 'TName',
					width: '100',
					title: '����'
				}, {
					field: 'TDate',
					width: '100',
					title: '����'
				}, {
					field: 'TTime',
					width: '100',
					title: 'ʱ��'
				}, {
					field: 'TUserName',
					width: '80',
					title: '�ɼ���'
				}, {
					field: 'TOSTATDesc',
					width: '80',
					title: 'ҽ��״̬'
				}, {
					field: 'TPlacerCode',
					width: '100',
					title: '����'
				},

				{
					field: 'TRefuse',
					width: '80',
					title: '״̬',
					editor: {
						type: 'switchbox',
						options: {
							onClass: 'primary',
							offClass: 'gray',
							onText: '����',
							offText: 'ȡ��'
						}
					}
				}, {
					field: 'TPlacesNo',
					width: '60',
					title: 'Ԥ�ƺ�'
				},{

					field: 'TSex',
					width: '60',
					title: '�Ա�'
				}, {
					field: 'TAge',
					width: '60',
					title: '����'
				},


			]
		],

		rowStyler: function(index, row) {

			if (row.TOSTATDesc == "л�����") {
				return 'background-color:#fff3dd;';
			}



		},
		onSelect: function(rowIndex, rowData) {


		}


	})

}


//�б�༭
var editIndex = undefined;
var modifyBeforeRow = "";
var modifyAfterRow = "";

//�����б༭
function endEditing() {

	if (editIndex == undefined) {
		return true
	}
	if ($('#SaveCollectSpecGrid').datagrid('validateRow', editIndex)) {

		$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex);



		editIndex = undefined;
		return true;
	} else {
		return false;
	}

}

//���ĳ�н��б༭
function onClickRow(index, value) {
	if (editIndex != index) {
		if (endEditing()) {
			$('#SaveCollectSpecGrid').datagrid('selectRow', index)
				.datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $('#SaveCollectSpecGrid').datagrid('getRows')[index]['TRefuse']

		} else {
			$('#SaveCollectSpecGrid').datagrid('selectRow', editIndex);
		}


	}

}
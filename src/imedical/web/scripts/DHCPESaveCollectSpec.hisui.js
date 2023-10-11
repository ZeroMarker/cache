//名称	DHCPESaveCollectSpec.hisui.js
//功能  标本采集
//创建	2019.07.08
//创建人  xy

$(function() {

	SetRoomInfo();
	
	InitSaveCollectSpecGrid();

	CreateRoomRecordList();

	//打印
	$("#BPrint").click(function() {
		BPrint_Click();
	});

	//打开软键盘
	$("#BShowSoftKey").click(function() {
		ShowSoftKey_click();
	});


	//全部启用
	$("#BSRRef").click(function() {
		BSRRef_Click();
	});

	//全部取消
	$("#BSARef").click(function() {
		BSARef_Click();
	});

	//保存
	$("#BSave").click(function() {
		Save_Click();
	});

	//撤销预制号
	$("#BCancelPlacerNo").click(function() {
		BCancelPlacerNo_Click();
	});

	$("#SpecNo").keydown(function(e) {

		if (e.keyCode == 13) {
			//BSave_Click();
			SpecNo_Click()
		}

	});
	
	$("#RegNo").keydown(function(e) {

		if (e.keyCode == 13) {
			RegNo_Click();
		}

	});


	$("#PlacerNo").keydown(function(e) {

	if (e.keyCode == 13) {
	// 获取第一个选中的行
	var selectrow = $('#SaveCollectSpecGrid').datagrid('getSelected');
	if(selectrow==null)
	{
		$.messager.alert("提示","请选择待保存预制号的医嘱",'info');
		return false;
	}
	
	//获取选中行的index
	var selectindex=$('#SaveCollectSpecGrid').datagrid('getRowIndex',selectrow)
	
	//获取当前页的行
	var rows = $('#SaveCollectSpecGrid').datagrid('getRows');
	
	if(selectrow.TSpecNo==""){
		$.messager.alert("提示","标本号为空,不能保存预制号",'info');
		return false;
	}
	if(selectrow.TOSTATDesc!="核实"){
		$.messager.alert("提示","医嘱不是核实状态,不能保存预制号",'info');
		return false;
	}
	if (selectrow.TOEORIRowId!=""){
		
			var	Strings=selectrow.TOEORIRowId+";"+$("#PlacerNo").val()+";"+selectrow.TSpecNo;
			
		}
	
	var flag = tkMakeServerCall("web.DHCPE.OEOrdItem","UpdateBarInfo",Strings,"N");
	
	if(flag!=0){
		$.messager.alert("提示",flag+",不能再次保存预制号",'info');
		return false;
	}
	if(flag==0){
		
		
		//更新修改的数据
		$('#SaveCollectSpecGrid').datagrid("updateRow",{
			index:selectindex ,
			row: {
				TPlacesNo: $("#PlacerNo").val(),
		
			}
		});

		var i=selectindex+1;
		$("#PlacerNo").val("");
		//滚动到相应的行
		$('#SaveCollectSpecGrid').datagrid('scrollTo',i);
		
		//选中相应的行
		$('#SaveCollectSpecGrid').datagrid('selectRow',i); 

	}
	
		}

	});

})
//撤销条码号关联
function BCancelPlacerNo_Click(){
	
	// 获取第一个选中的行
	var selectrow = $('#SaveCollectSpecGrid').datagrid('getSelected');
	if(selectrow==null)
	{
		$.messager.alert("提示","请选择待撤销预制号的医嘱",'info');
		return false;
	}
	if(selectrow.TSpecNo==""){
		$.messager.alert("提示","标本号为空,不能撤销预制号",'info');
		return false;
	}
	if(selectrow.TOSTATDesc!="核实"){
		$.messager.alert("提示","医嘱不是核实状态,不能撤销预制号",'info');
		return false;
	}
	if(selectrow.TPlacesNo==""){
		$.messager.alert("提示","预制号为空,不能撤销预制号",'info');
		return false;
	}

	//获取选中行的index
	var selectindex=$('#SaveCollectSpecGrid').datagrid('getRowIndex',selectrow)
	
	if (selectrow.TOEORIRowId!=""){
			var	Strings=selectrow.TOEORIRowId+";"+selectrow.TPlacesNo+";"+selectrow.TSpecNo; 
		}
	
	var flag = tkMakeServerCall("web.DHCPE.OEOrdItem","UpdateBarInfo",Strings,"Y");
	
	if(flag!=0){
		$.messager.alert("提示",flag,'info');
		return false;
	}else{
		$.messager.alert("提示","撤销预制号成功",'success');
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
	$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex); //最后一行结束行编辑	
	  $("#SaveCollectSpecGrid").datagrid('reload');
/*
	$.messager.confirm('确定', '确定要保存数据吗？', function(t) {
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
							HospID:session['LOGON.HOSPID']
						})
					}
				}
			}


		}
	});
	*/
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
		var Info="<a href="+TotalLnk+" target='_blank' >检查信息</a>"
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
		var Info="<a href="+TotalLnk+" target='_blank' >共<font color=red size=6>"+TotalPerson+"</font>人</a>,<a href="+HadCheckLnk+" target='_blank' >已检<font color=red size=6>"+HadCheckNum+"</font>人</a>,<a href="+NoCheckLnk+" target='_blank' >未检<font size=6>"+NoCheckNum+"</font>人</a>"
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
			msg: "标本号不能为空",
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
			$.messager.confirm("确认", "确定要到达吗？", function(r) {
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
								$.messager.alert("提示", "到达失败", "error");
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
			$.messager.confirm("确认", "确定要到达吗？", function(r) {
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
								$.messager.alert("提示", "到达失败", "error");
							}
						}
					});
				}
			});

		}
	}

	if (Arr[0] == "0") {
		//$.messager.alert('提示', Arr[1], "info");
		$.messager.popover({msg: Arr[1],type: "info"});
		return false;
	} else if (Arr[0] == "1") {

		$.messager.confirm("确认", "该标本体检者不是当天到达,是否继续标本核对?", function(r) {
			if (r) {
				var RoomID = $("#RoomID").val();
				if (RoomID != "") {

					var CurRoomID = Value.split("^")[1];
					vStatus = Value.split("^")[4];
					vDetailStatus = Value.split("^")[5];
					if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
					{
						if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;

					} else if (vRoomRecordID == "") {
						if (!confirm("没有叫号,是否继续?")) return false;
					}
				}
				//parent.vRoomRecordID="";
				vRoomRecordID = CurRoomID;
				if (vStatus == "N") { //判断是不是同一个人
					if (vDetailStatus != "E") { //不是正检状态的，设置正检，下屏
						var UserID = session['LOGON.USERID'];
						var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

					}
				}

				Init();
				Find();
				BPrint_Click();

			}
		});

		//if (!(confirm("该标本体检者不是当天到达,是否继续标本核对?"))) {  return false; }
	} else {


		var RoomID = $("#RoomID").val();
		if (RoomID != "") {

			var CurRoomID = Value.split("^")[1];
			vStatus = Value.split("^")[4];
			vDetailStatus = Value.split("^")[5];
			if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
			{
				if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;

			} else if (vRoomRecordID == "") {
				if (!confirm("没有叫号,是否继续?")) return false;
			}
		}
		//parent.vRoomRecordID="";
		vRoomRecordID = CurRoomID;
		if (vStatus == "N") { //判断是不是同一个人
			if (vDetailStatus != "E") { //不是正检状态的，设置正检，下屏
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

	var ret = tkMakeServerCall("web.DHCPE.BarPrint", "GetSaveSpecInfo", $("#SpecNo").val(), $("#RoomRecordID").val(), $("#RoomID").val(), $("#PAADM").val(),SpecNoType)
	$("#CheckInfo").val(ret);


}



function Find() {

	var PAADM = $("#PAADM").val();
	var SpecNo = $("#SpecNo").val();
	var RegNo = $("#RegNo").val();
	if ((vRoomRecordID == "") && (SpecNo == "") && (PAADM == "")) {
		$.messager.alert('提示', '当前就诊者和标本号不能都为空', "info");
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
		HospID:session['LOGON.HOSPID'],
		SpecNoType:SpecNoType
	})

}


//全部取消
function BSARef_Click() {
	var rrows = $('#SaveCollectSpecGrid').datagrid("getRows");
	for (var i = 0; i < rrows.length; i++) {
		var Refuse = rrows[i].TRefuse;
		var ID = rrows[i].TSpecNo;
		if (Refuse == "启用") {
			RefuseApp(ID)
		}
	}

}

//全部启用
function BSRRef_Click() {
	var rrows = $('#SaveCollectSpecGrid').datagrid("getRows");
	for (var i = 0; i < rrows.length; i++) {
		var Refuse = rrows[i].TRefuse;
		var ID = rrows[i].TSpecNo;
		if (Refuse == "取消") {
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
			HospID:session['LOGON.HOSPID'],
			SpecNoType:SpecNoType
		})
	}
}

//打开软键盘
function ShowSoftKey_click() {
	//var shell = new ActiveXObject("wscript.shell")
	//shell.run("osk.exe");
	location.replace("tabkey:");
	return false;
}

//打印
function BPrint_Click() {
	
	if(SpecNoType=="" ){
		SpecNoType="血";
	}
	
	//BloodFlag:2 血,1 非血,空 所有标本类型
	var BloodFlag="";
	if(SpecNoType.indexOf("血")>-1){
		var BloodFlag="2"; 
	}else if((SpecNoType.indexOf("尿")>-1)||(SpecNoType.indexOf("便")>-1)){
		var BloodFlag="1";
	}else{
		var BloodFlag="";
	}

	//var PAADM = "";
	var PAADM = $("#PAADM").val();
	var PrintBarFlag = 0;
	var PrintBarCode = $("#PrintBarCode").checkbox('getValue');
	if (PrintBarCode) { var PrintBarFlag = 1;}
    if (PrintBarFlag!==1) return ;
    
 	var RegNo = $("#RegNo").val();   
	var SpecNo = $("#SpecNo").val();
	var LocID=session['LOGON.CTLOCID'];
	var SpecOneFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"CollectSpecOne");

/*
	if (SpecNo==""){ var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", RegNo);}
	else {var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", SpecNo);}
	var Arr = Value.split("^");
	var PAADM = Arr[2];
*/
   if (RegNo==""){
		$.messager.alert("提示", "标本号不能为空", "info");
		return false;
	}else{
		if (SpecNo!==""){
			if (SpecOneFlag=="Y"){
				PrintAllApp(SpecNo, "Spec", "N","",BloodFlag)
			}else{
				PrintAllApp(PAADM, "PAADM", "N","",BloodFlag)
			}
			
		}else{
			PrintAllApp(PAADM, "PAADM", "N","",BloodFlag)
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
			SpecNoType:SpecNoType
		},
		onClickRow: onClickRow,
		onAfterEdit: function(index, row, changes) {
			
		//$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex); //最后一行结束行编辑 
			modifyAfterRow = $('#SaveCollectSpecGrid').datagrid('getRows')[index]['TRefuse'] 
			//alert(modifyBeforeRow+"^"+modifyAfterRow)
			if(modifyBeforeRow!=modifyAfterRow){
				$.messager.confirm('确定', '确定要保存数据吗？', function(t) {
				if (t) { 
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
							SpecNoType:SpecNoType
						})
					}
				}
			})
		
			}


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
					width: '100',
					title: '容器颜色',
					styler: function(value, row, index) {
						return 'background-color:' + row.TPlacerColor;
					}

				}, {
					field: 'TPlacerCode',
					width: '100',
					title: '容器名称'
				}, {
					field: 'TItemName',
					width: '200',
					title: '医嘱'
					
				}, {
					field: 'TSpecName',
					width: '100',
					title: '标本名称'
				}, {
					field: 'TSpecNo',
					width: '150',
					title: '标本号'
				}, {
					field: 'TRegNo',
					width: '120',
					title: '登记号'
				}, {
					field: 'TName',
					width: '100',
					title: '姓名'
				}, {
					field: 'TDate',
					width: '100',
					title: '日期'
				}, {
					field: 'TTime',
					width: '100',
					title: '时间'
				}, {
					field: 'TUserName',
					width: '80',
					title: '采集人'
				}, {
					field: 'TOSTATDesc',
					width: '80',
					title: '医嘱状态'
				},{
					field: 'TRefuse',
					width: '80',
					title: '状态',
					editor: {
						type: 'switchbox',
						options: {
							onClass: 'primary',
							offClass: 'gray',
							onText: '启用',
							offText: '取消'
						}
					}
				}, {
					field: 'TPlacesNo',
					width: '60',
					title: '预制号'
				},{

					field: 'TSex',
					width: '60',
					title: '性别'
				}, {
					field: 'TAge',
					width: '60',
					title: '年龄'
				}


			]
		],

		rowStyler: function(index, row) {

			if (row.TOSTATDesc == "谢绝检查") {
				return 'background-color:#fff3dd;';
			}



		},
		onSelect: function(rowIndex, rowData) {


		}


	})

}




//列表编辑
var editIndex = undefined;
var modifyBeforeRow = "";
var modifyAfterRow = "";

//结束行编辑
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

//点击某行进行编辑
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



function SpecNo_Click() {
	var vStatus = "",
		vDetailStatus = "",
		ReturnValue = "";

	var SpecNo = $("#SpecNo").val();
	if (SpecNo == "") {
		$.messager.popover({
			msg: "标本号不能为空",
			type: "info"
		});
		return false;
	}
     //判断输入的标本号是不是包含在该采集界面维护的类型中
    var Flag=tkMakeServerCall("web.DHCPE.BarPrint", "IsCanSaveSpec",SpecNo,SpecNoType);
    if(Flag=="0"){
	    $.messager.popover({
			msg: "输入的标本号不在该界面采集，请核实！",
			type: "info"
		});
		return false;
	    
    }else{
	    if (Flag!="1"){
		     $.messager.popover({
				msg: Flag,
				type: "info"
			});
			return false;
		    
	    }
	    
    }


	var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDateBySpecNo", SpecNo);
	//alert(Value)
	var Arr = Value.split("^"); 
		var PAADM = Arr[2];
		$("#PAADM").val(Arr[2]);
		GetSaveCollectByPAADM(PAADM); 
		
}



function RegNo_Click()
{
	var CTLocID=session['LOGON.CTLOCID'];
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo,
			"CTLocID":CTLocID
		}, false);
		
			$("#RegNo").val(iRegNo)
		} 
		if (iRegNo=="") 
	   {
			$.messager.popover({msg: "请输入登记号", type: "info"});
		   return false;
	   }
	   
		var PAADMS=tkMakeServerCall("web.DHCPE.BarPrint","GetSaveCollectRecord",iRegNo);
		//alert(PAADMS)
		if (PAADMS.split("^")[0]!="0"){
			//alert(PADMS.split("^")[1]);
			$.messager.popover({msg: PAADMS.split("^")[1], type: "info"});
			return false;
		}
		var PAADM=PAADMS.split("^")[1];
		if (PAADM==""){
			$.messager.popover({msg: "没有要采集标本的记录", type: "info"});
			return false;
			}
		var PAADMArr=PAADM.split("$");
		
		if (PAADMArr.length>2){
           openPEPAADMRecord(iRegNo)
   
		}else{
			GetSaveCollectByPAADM(PAADMArr[0]);
			
	}
		
}


var openPEPAADMRecord= function(RegNo){
    
    $HUI.window("#PEPAADMRecordWin",{
        title:"体检就诊信息",
        minimizable:false,
        collapsible:false,
        modal:true,
        width:930,
        height:400
    });
    
    var PEPAADMLisObj = $HUI.datagrid("#PEPAADMRecordList",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.BarPrint",
            QueryName:"FindPAADMInfo",
            RegNo:RegNo, 
			HospID:session['LOGON.HOSPID']
        },
        columns:[[
        	{field:'PAADM',title:'PAADM',hidden:true},
            {field:'Name',width:120,title:'姓名'},
            {field:'RegNo',width:120,title:'登记号'},
            {field:'HPNo',width:120,title:'体检编号'},
            {field:'AdmDate',width:100,title:'日期'},
            {field:'StatusDesc',width:100,title:'状态'},
            {field:'GName',width:200,title:'团体名称'},
            {field:'TeamName',width:120,title:'分组名称'},
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true,
        onDblClickRow: function(rowIndex,rowData){
	          $("#SpecNo").val("");
	           GetSaveCollectByPAADM(rowData.PAADM);
	 
  				}
        
        })
    
}


function GetSaveCollectByPAADM(PAADM){
		var vStatus = "",vDetailStatus = "",ReturnValue = "";
		$("#PAADM").val(PAADM);
			var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
			var AdmArr = Status.split("^");
			var PIADM = AdmArr[1];
			//alert(Status)
		if (PIADM == "") {
				return false;
			}
		if (AdmArr[0] == "REGISTERED") {
			$.messager.confirm("确认", "确定要到达吗？", function(r) {
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
								$.messager.alert("提示", "到达失败", "error");
								return false;
							}
						}else{
							SaveCollectByPAADM(PAADM);		
						}
					});
				}
			});

	}else{
		SaveCollectByPAADM(PAADM);
	}
}


function SaveCollectByPAADM(PAADM)
{	
	var vStatus = "",vDetailStatus = "",ReturnValue = "";
	var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDateByPAADM", PAADM);
	//alert(Value)
	var Arr = Value.split("^");
	if (Arr[0] == "0") {
		$.messager.popover({msg: Arr[1],type: "info"});
		return false;
	} else if (Arr[0] == "1") {

		$.messager.confirm("确认", "该标本体检者不是当天到达,是否继续标本核对?", function(r) {
			if (r) {
				var RoomID = $("#RoomID").val();
				if (RoomID != "") {

					var CurRoomID = Value.split("^")[1];
					vStatus = Value.split("^")[4];
					vDetailStatus = Value.split("^")[5];
					if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
					{
						if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;

					} else if (vRoomRecordID == "") {
						if (!confirm("没有叫号,是否继续?")) return false;
					}
				}
				//parent.vRoomRecordID="";
				vRoomRecordID = CurRoomID;
				if (vStatus == "N") { //判断是不是同一个人
					if (vDetailStatus != "E") { //不是正检状态的，设置正检，下屏
						var UserID = session['LOGON.USERID'];
						var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

					}
				}
                
				Init();
				Find();
				BPrint_Click();

			}
		});

		
	} else {

		var RoomID = $("#RoomID").val();
		if (RoomID != "") {
			var CurRoomID = Value.split("^")[1];
			vStatus = Value.split("^")[4];
			vDetailStatus = Value.split("^")[5];
			if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
			{
				if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;

			} else if (vRoomRecordID == "") {
				if (!confirm("没有叫号,是否继续?")) return false;
			}
		}
		//parent.vRoomRecordID="";
		vRoomRecordID = CurRoomID;
		if (vStatus == "N") { //判断是不是同一个人
			if (vDetailStatus != "E") { //不是正检状态的，设置正检，下屏
				var UserID = session['LOGON.USERID'];
				var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

			}
		}

		Init();
		Find();
		BPrint_Click();
	}
	
}
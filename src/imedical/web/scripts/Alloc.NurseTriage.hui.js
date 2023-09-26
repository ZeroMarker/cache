var PageLogicObj={
	m_AllocListTabDataGrid:"",
	dw:$(window).width()-200,
	dh:$(window).height()-100,
	ExabAutoReport:0,
	AutoReportFlag:0,
	ExabFirstResonFlag:0
	
};
$(function(){
	//页面元素初始化
	PageHandle();
	//页面数据初始化
	Init();
	//事件初始化
	InitEvent();
});
function Init(){
	PageLogicObj.m_AllocListTabDataGrid=InitAllocListTabDataGrid();
}
function PageHandle(){
	//分诊区
	LoadTZoon();
	FindCheckinStatus();
}
function InitEvent(){
	$("#BFindPatQue").click(function(){LoadPatQueue("")});
	$("#CardNo").keydown(CardNoKeydown);
	$("#T_RegNo").keydown(RegNoKeydown);
	$("#BClear").click(BClearClick);
	$("#BReadCard").click(BReadCardClickHandle);
	$HUI.checkbox(".hisui-checkbox",{
        onChecked:function(e,value){
	        var id=e.target.id;
	        $(".hisui-checkbox").not("#"+id).checkbox('setValue',false);
	        setTimeout(function(){LoadPatQueue("");});
        }
    });
    document.onkeydown = DocumentOnKeyDown;
    $('#CancleMuni_toolbar').appendTo('#CancleMuni');
    $('#CancleMuni').find("span").eq(0).css("display","none");
    $("#CancleQueCheckin").click(CancleQueCheckinclick)
    $("#CancleQueAgain").click(CancleQueAgainclick)
    $("#CanclePrior").click(CanclePriorclick)
    $("#CancleAdjConfirm").click(CancleAdjConfirmclick)
    $("#BSaveFrist").click(BSaveFristclick)
    
}
function ChangeMenuDisable(id,value){
	if (value==true){
		$("#"+id).addClass("menu-item menu-item-disabled")
    	$("#"+id).attr("disabled",true);
	}else{
		$("#"+id).removeClass("menu-item menu-item-disabled")
    	$("#"+id).attr("disabled","");	
		}
	}
function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) { 
		if ((SrcObj) && ((SrcObj.id.indexOf("CardNo")>=0) ||(SrcObj.id.indexOf("T_RegNo")>=0))){
			return false;
		}
		return true;
	}
}
function InitAllocListTabDataGrid(){
	var toobar=[{
        text: '报到',
        iconCls: 'icon-check-reg',
        handler: function() {QueCheckinclick(); }
    },{
        text: '复诊',
        iconCls: 'icon-end-adm',
        handler: function() {QueAgainclick();}
    },{
        text: '优先',
        iconCls: 'icon-upload-cloud',
        handler: function() {Priorclick();}
    },{
        text: '指定医生',
        iconCls: 'icon-doctor',
        handler: function() {AdjConfirmclick();}
    },{
        id:"CancleMuni"
    }
    ,'-',{
        text: '等候人数',
        iconCls: 'icon-sum',
        handler: function() {B_SumOnclick();}
    }];
	var Columns=[[ 
		{field:'TQueID',hidden:true,title:''},
		{field:'RoomName',title:'诊室',width:140,sortable:true},
		{field:'MarkName',title:'号别',width:140,sortable:true},
		{field:'CardNo',title:'卡号',width:120,sortable:true},
		{field:'PatName',title:'姓名',width:100,sortable:true},
		{field:'RSex',title:'性别',width:50,sortable:true},
		{field:'RBirth',title:'年龄',width:50,sortable:true},
		{field:'DocName',title:'医生',width:100,sortable:true},
		{field:'status',title:'状态',width:50,sortable:true},
		{field:'Prior',title:'优先级',width:60,sortable:true},
		{field:'TFirstReson',title:'优先原因',width:100,sortable:true},
		{field:'TSeqNo',title:'排队号',width:60,sortable:true},
		//{field:'Tbl_ComputerIP',title:'工作站名称',width:100},
		{field:'DeptDesc',title:'科室',width:140,sortable:true},
		{field:'AdmDate',title:'就诊日期',width:100,sortable:true},
		{field:'AdmWeek',title:'就诊星期',width:100,sortable:true},
		//{field:'ConsultatFlage',title:'会诊',width:50},
		{field:'PatientID',title:'',hidden:true},
		{field:'EpisodeID',title:'',hidden:true},
		{field:'mradm',title:'',hidden:true}
    ]]
	var AllocListTabDataGrid=$("#AllocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : false,  
		idField:'TQueID',
		columns :Columns,
		toolbar:toobar,
		remoteSort:false,
		onLoadSuccess:function(data){
			var CardNo=$('#CardNo').val();
			var RegNo=$("#T_RegNo").val();
			if ((CardNo!="")||(RegNo!="")){
				if (data.length>0){
					PageLogicObj.m_AllocListTabDataGrid.datagrid('selectRow', 0);
					var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');
					LoadDocList(row["TQueID"]);  
				}
			}
			///自动报到
			if (PageLogicObj.AutoReportFlag==1){
				PageLogicObj.AutoReportFlag=0
				if (PageLogicObj.ExabAutoReport==1){
					AutoQueCheckin()
					}
				}
			
		},
		
		onClickRow:function(index, row){
			LoadDocList(row["TQueID"]);
			var QueCheckinFlag=$.cm({
				ClassName:"web.DHCAlloc", 
				MethodName:"CheckForQueCheckin",
				QueID:row["TQueID"],
				dataType:"text"
			},false)
			var QueCalledFlag=$.cm({
				ClassName:"web.DHCAlloc", 
				MethodName:"GetQueCalledFlag",
				QueID:row["TQueID"],
				dataType:"text"
			},false)
			if ((row["StatusPerName"]=="等候")&&(QueCheckinFlag=="1")&&(QueCalledFlag!="Y")){ChangeMenuDisable("CancleQueCheckin",false);}else{ChangeMenuDisable("CancleQueCheckin",true);}
			if (row["StatusPerName"]!="复诊"){ChangeMenuDisable("CancleQueAgain",true);}else{ChangeMenuDisable("CancleQueAgain",false);}
			if (row["Prior"]!="优先"){ChangeMenuDisable("CanclePrior",true);}else{ChangeMenuDisable("CanclePrior",false);}
			//(row["status"]=="等候")&&
			if ((row["DocName"]!="")&&(row["StatusPerName"]!="到达")&&(row["StatusPerName"]!="复诊")&&(QueCalledFlag!="Y")){ChangeMenuDisable("CancleAdjConfirm",false);}else{ChangeMenuDisable("CancleAdjConfirm",true);}
		}
	}); 
	return AllocListTabDataGrid;
}
function LoadTZoon(){
	$.cm({
		ClassName:"web.DHCAlloc", 
		QueryName:"QueryExaborough",
		UserId:session['LOGON.USERCODE']
	},function(GridData){
		var cbox = $HUI.combobox("#T_Zone", {
			valueField: 'HIDDEN',
			textField: 'exabname', 
			editable:false,
			data: GridData["rows"],
			onLoadSuccess:function(){
				if (GridData["rows"].length>0){
					//默认选中第一个
					/*var ZoneID=GridData["rows"][0]["HIDDEN"]
					$.m({
						ClassName:"web.DHCAlloc", 
						MethodName:"GetLastSelectZone",
						Userid:session['LOGON.USERID']
					},function(GridDataD){
						if (GridDataD!=""){
							$("#T_Zone").combobox('select',GridDataD);
						}else{
							$("#T_Zone").combobox('select',ZoneID);
							}
					})*/
					var DefaultZoneID="";
					for (var i=0;i<GridData["rows"].length;i++){
						if (GridData["rows"][i]["isDefault"]=="true"){
							DefaultZoneID=GridData["rows"][i]["HIDDEN"];
							break;
						}
					}
					if (DefaultZoneID!=""){
						$("#T_Zone").combobox('select',DefaultZoneID);
					}else{
						$("#T_Zone").combobox('select',GridData["rows"][0]["HIDDEN"]);
					}
				}
			},
			onSelect:function(rec){
				//清空医生列表
				$($("#acc ul")[2]).empty();
				LoadPatQueue("");
				//诊室
				LoadTZoom();
				//号别
				LoadCarePrv();
				$("#allocroomview").attr("src","dhcdocallocroomview.csp?BorUserId="+rec["HIDDEN"]);
				$.m({
					ClassName:"web.DHCAlloc", 
					MethodName:"SaveLastSelectZone",
					Userid:session['LOGON.USERID'], Zoneid:rec["HIDDEN"]
				},function(GridData){})
				if (rec["isReport"]=="Y"){PageLogicObj.ExabAutoReport=1}else{PageLogicObj.ExabAutoReport=0}
				if (rec["isFirst"]=="Y"){PageLogicObj.ExabFirstResonFlag=1}else{PageLogicObj.ExabFirstResonFlag=0}
			}
		})
	})
}
function LoadTZoom(){
	var Zone=$("#T_Zone").combobox('getValue');
	$.cm({
		ClassName:"web.DHCAlloc", 
		QueryName:"QueryExab",
		UserId:session['LOGON.USERCODE'], Zone:Zone,
		rows:99999
	},function(GridData){
		$($("#acc ul")[0]).empty();
		for (var i=0;i<GridData["rows"].length;i++){
			var id=GridData["rows"][i].ID;
			var name=GridData["rows"][i].ExarName;
			$($("#acc ul")[0]).append("<li><a onClick='ZRoomClick("+id+")'  id='"+id+"'>"+name+"</a></li>");
		}
	})
}
function LoadCarePrv(){
	var Zone=$("#T_Zone").combobox('getValue');
	$.cm({
		ClassName:"web.DHCAlloc", 
		QueryName:"QueryRoomMark",
		UserId:session['LOGON.USERCODE'], Zone:Zone,
		rows:99999
	},function(GridData){
		$($("#acc ul")[1]).empty()
		for (var i=0;i<GridData["rows"].length;i++){
			var id=GridData["rows"][i]["ID"];
			var name=GridData["rows"][i]["ctpcp_desc"];
			$($("#acc ul")[1]).append("<li><a onClick='ZCarePrvClick("+id+")' id='"+id+"'>"+name+"</a></li>");
		}
	})
}
function LoadDocList(QueID){
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"FindMarkDocDr",
		itmjs:"GetMarkDocToHUIJson", itmjsex:"", QueID:QueID,
		rows:99999
	},function(data){
		$($("#acc ul")[2]).empty();
		for (var i=0;i<data.length;i++){
			var id=data[i]["id"];
			var name=data[i]["text"];
			$($("#acc ul")[2]).append("<li><a onClick='ZMarkDocClick("+id+")' id='"+id+"'>"+name+"</a></li>");
		}
	})
}
function LoadPatQueue(MarkID){
	var checkedId=$("input[type='checkbox']:checked")[0]["id"];
	var QueryST=$("#"+checkedId)[0]["attributes"]["label"].value;
	var UserCode=session['LOGON.USERCODE']
	var CompName=""
	var Zone=$("#T_Zone").combobox('getValue');
	var PapmiNo=$("#PapmiNo").val();
	var PatID=$("#T_RegNo").val();
	var RoomDr=""; //诊室 后台是根据描述过滤的
	if ($(".room-select").length>0){
		RoomDr=$(".room-select")[0].text;
	}
	var MarkDr="";
	if (MarkID!=""){
		MarkDr=MarkID
		}else{
		if ($(".mark-select").length>0){
			MarkDr=$(".mark-select")[0].id;
		}
	}
	var StartDate=$("#StartDate").datebox("getValue")
	var EndDate=$("#EndDate").datebox("getValue")
	 $.cm({
		ClassName:"web.DHCAlloc", 
		QueryName:"QueryFindPatQueue",
		UserCode:UserCode, CompName:CompName,
	    QueryST:QueryST, RoomDr:RoomDr, MarkDr:MarkDr,
	    PatID:PatID, PapmiNo:PapmiNo, Zone:Zone,
	    StartDate:StartDate,EndDate:EndDate,
	    rows:999999
	},function(GridData){
		PageLogicObj.m_AllocListTabDataGrid.datagrid('unselectAll').datagrid('loadData',GridData);
		$("#QueCount").html(GridData["total"]);
	})
}
function ZRoomClick(id){
	var selRoomDr="";
	if ($(".room-select").length>0){
		selRoomDr=$(".room-select")[0].id;
	}
	$(".room-select").removeClass("room-select");
	if (selRoomDr!=id){
		$("#"+id).addClass("room-select");
	}
	LoadPatQueue("");
}
function ZCarePrvClick(id){
	var selMarkDr="";
	if ($(".mark-select").length>0){
		selMarkDr=$(".mark-select")[0].id;
	}
	$(".mark-select").removeClass("mark-select");
	if (selMarkDr!=id){
		$("#"+id).addClass("mark-select");
	}
	LoadPatQueue("");
}
function ZMarkDocClick(id){
	$(".markdoc-select").removeClass("markdoc-select");
	$("#"+id).addClass("markdoc-select");
}
function FindCheckinStatus()
{
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"FindCheckinStatus",
		dataType:"text",
		itmjs:"", itmjsex:"", UserCode:session['LOGON.USERCODE']
	},function(Rtn){
		if (Rtn=="Y"){
			$HUI.checkbox("#C_Reg").setValue(true);
		}else{
			$HUI.checkbox("#C_Wait").setValue(true);
		}
	})
}
function CardNoKeydown(e){ 
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$('#CardNo').val();
		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","","CardNoKeyDownCallBack");
	}
}
function BReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function CardNoKeyDownCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "-200": 
			$.messager.alert("提示","卡无效!","info",function(){
				$("#T_RegNo").val("");
				$('#CardNo').focus();
			});
			break;
		default:
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$('#CardNo').val(CardNo);
			$("#T_RegNo").val(myary[5]);
			LoadPatQueue("");
			PageLogicObj.AutoReportFlag=1
			break;
	}
}
function RegNoKeydown(e){ 
	var key=websys_getKey(e);
	if (key==13) {
		var RegNo=$("#T_RegNo").val();
		if (RegNo=="") return;
		var T_IDLength=10;
		if ((RegNo.length<T_IDLength)&&(T_IDLength!=0)) {
			for (var i=(T_IDLength-RegNo.length-1); i>=0; i--) {
				RegNo="0"+RegNo;
		
			}
		}
		$("#T_RegNo").val(RegNo);
		PageLogicObj.AutoReportFlag=1
		LoadPatQueue("");
	}
}
function QueCheckinclick(){
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要报到的记录!");
		return false;
	}    
	var QueID=row["TQueID"];
	/*if ((row["status"]!="报到")&&(row["status"]!="过号")){
		$.messager.alert("提示","非【报到】或【过号】状态的记录不能进行报到!");
		return false;
	}*/
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"PatArrive",
		dataType:"text",
		itmjs:"PatArriveToHUI", itmjsex:"", QueID:QueID,UserID:session['LOGON.USERID']
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("提示","报到失败!"+rtn);
			return false;
		}
		LoadPatQueue("");
	})
}
function QueAgainclick(){
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要复诊的记录!");
		return false;
	}
	var QueID=row["TQueID"];
	/*if ((row["DocName"]=="")||(row["status"]=="退号")){
		$.messager.alert("提示","未就诊或已退号记录不能进行复诊!");
		return false;
	}*/
	$.messager.confirm('确认对话框', '该病人是否需要复诊?', function(r){
		if (r){
		    $.cm({
				ClassName:"web.DHCAlloc", 
				MethodName:"PatAgain",
				dataType:"text",
				itmjs:"PatAgainToHUI", itmjsex:"", QueID:QueID,UserID:session['LOGON.USERID']
			},function(rtn){
				if (rtn!=0){
					$.messager.alert("提示","复诊失败!"+rtn);
					return false;
				}
				LoadPatQueue("");
			})
		}
	});
}
function AdjConfirmclick(){
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要指定医生的记录!");
		return false;
	}
	var QueID=row["TQueID"];
	var SelDocDr="";
	if ($(".markdoc-select").length>0){
		SelDocDr=$(".markdoc-select")[0].id;
	}
	if (row["RoomName"]!="") {
		$.messager.alert("提示","已有医师呼叫的病人不能再指定其他医师!");
		return false;
	}
	if ((row["StatusPerName"]=="到达")||(row["StatusPerName"]=="复诊")){
		$.messager.alert("提示","已就诊记录不能指定医生!");
		return false;
	}
    if (SelDocDr=="") {
        $.messager.alert("提示","请选择需要指定医生!");
		return false;
	}
	$.messager.confirm('确认对话框', '该病人需要调整医生吗?', function(r){
		if (r){
		    $.cm({
				ClassName:"web.DHCAlloc", 
				MethodName:"PatAdjDoc",
				dataType:"text",
				itmjs:"PatAdjDocToHUI", itmjsex:"", QueID:QueID,AdjDocDr:SelDocDr,Usercode:session['LOGON.USERID']
			},function(rtn){
				if (rtn!=0){
					$.messager.alert("提示","指定医生失败!"+rtn);
					return false;
				}
				LoadPatQueue("");
			})
		}
	});
}
function Priorclick(){
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要优先的记录!");
		return false;
	}
	var QueID=row["TQueID"];
	if (PageLogicObj.ExabFirstResonFlag==1){
		$("#FristReson-dialog").dialog("open");
		$("#FristReson").val("").focus();
	}else{
	    $.messager.confirm('确认对话框', '该病人是否需要优先?', function(r){
			if (r){
			    $.cm({
					ClassName:"web.DHCAlloc", 
					MethodName:"PatPrior",
					dataType:"text",
					itmjs:"PatPriorToHUI", itmjsex:"", QueID:QueID,QueFirstReason:""
				},function(rtn){
					if (rtn!=0){
						$.messager.alert("提示","置优先失败!"+rtn);
						return false;
					}
					LoadPatQueue("");
				})
			}
		});
	}
}
function BSaveFristclick(){
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要优先的记录!");
		return false;
	}
	var QueID=row["TQueID"];
	var FirsReson=$.trim($("#FristReson").val());
	if (FirsReson==""){
		$.messager.alert("提示","请先填写优先原因!","info",function(){
			$("#FristReson").val("");
		});
		return false;
	}
    $.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"PatPrior",
		dataType:"text",
		itmjs:"PatPriorToHUI", itmjsex:"", QueID:QueID,QueFirstReason:FirsReson
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("提示","置优先失败!"+rtn);
			return false;
		}
		LoadPatQueue("");
	})
	$("#FristReson-dialog").dialog("close");
	}
function B_SumOnclick(){
	var T_RegNo=$("#T_RegNo").val();
	if(T_RegNo==""){
		$.messager.alert("提示","请输入登记号后进行查询!","info",function(){
			$("#T_RegNo").focus();
		})	
	}else{
		var rtn=$.cm({
			ClassName:"web.DHCAlloc", 
			MethodName:"GetDHCPerStateFlag",
			dataType:"text",
			PersonId:T_RegNo
		},false);
		var rtnCode=rtn.split("^")[0];
		var ErrMsg=rtn.split("^")[1];
		if(rtnCode!=0){
			$.messager.alert("提示",ErrMsg);	
			return false;
		}
		var PatSum=$.cm({
			ClassName:"web.DHCAlloc", 
			MethodName:"GetPatSum",
			dataType:"text",
			PersonId:T_RegNo,
			Zone:$("#T_Zone").combobox('getValue')
		},false);
		var PatSumArr=PatSum.split("^")
		if((PatSumArr[0]=="-1")||(PatSumArr[0]=="")){
			$.messager.alert("提示","没有输入登记号!","info",function(){
				$("#T_RegNo").focus();
			})	
			return false;
		}
		var Str=""
		if(PatSumArr.length<1){
			$.messager.alert("提示","没有数据")
			return false;	
		}
		for(i=0;i<PatSumArr.length;i++){
			var PatSumStr=PatSumArr[i].split("$")
			var DocName=PatSumStr[0]
			var QuePatNo=PatSumStr[1]
			var Sum=PatSumStr[2]
			var FZSum=PatSumStr[3]
			var DHSum=PatSumStr[4]
			if(Str==""){
				Str=DocName+"前面有 "+Sum+" 人。其中复诊为 "+FZSum+" 人，等待为 "+DHSum+" 人。"
			}else{
				Str=Str+"<br/>"+DocName+"前面有"+Sum+"人。其中复诊为"+FZSum+"人，等待为 "+DHSum+" 人。"
			}
		}
		if(Str!=""){
			$.messager.alert("提示",Str)	
		}else{
			$.messager.alert("提示","没有查询到数据!")	
		}
	}
}
function BClearClick(){
	window.location.reload();
}
function CancleQueCheckinclick(){
	if ($("#CancleQueCheckin").hasClass("menu-item-disabled")) {
		return;
	}
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要取消报到的记录!");
		return false;
	}    
	var QueID=row["TQueID"];
	/*if ((row["status"]!="等候")){
		$.messager.alert("提示","非【等候】状态的记录不能进行取消报到!");
		return false;
	}*/
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"CancleQueCheckin",
		dataType:"text",
		QueID:QueID,UserID:session['LOGON.USERID']
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("提示","取消报到失败!"+rtn);
			return false;
		}
		LoadPatQueue("");
	})
}
function CancleQueAgainclick(){
	if ($("#CancleQueAgain").hasClass("menu-item-disabled")) {
		return;
	}
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要取消复诊的记录!");
		return false;
	}    
	var QueID=row["TQueID"];
	/*if ((row["status"]!="复诊")){
		$.messager.alert("提示","非【复诊】状态的记录不能进行取消复诊!");
		return false;
	}*/
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"CancleQueAgain",
		dataType:"text",
		QueID:QueID,UserID:session['LOGON.USERID']
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("提示","取消复诊失败!"+rtn);
			return false;
		}
		LoadPatQueue("");
	})}
function CanclePriorclick(){
	if ($("#CanclePrior").hasClass("menu-item-disabled")) {
		return;
	}
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要取消优先的记录!");
		return false;
	}    
	var QueID=row["TQueID"];
	if ((row["Prior"]!="优先")){
		$.messager.alert("提示","非【优先】状态的记录不能进行取消优先!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"CanclePrior",
		dataType:"text",
		QueID:QueID,UserID:session['LOGON.USERID']
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("提示","取消优先失败!"+rtn);
			return false;
		}
		LoadPatQueue("");
	})}
function CancleAdjConfirmclick(){
	if ($("#CancleAdjConfirm").hasClass("menu-item-disabled")) {
		return;
	}
	var row = PageLogicObj.m_AllocListTabDataGrid.datagrid('getSelected');  
	if (row.length==0){
		$.messager.alert("提示","请选择需要取消指定医生的记录!");
		return false;
	}    
	var QueID=row["TQueID"];
	if ((row["DocName"]=="")){ //(row["status"]!="等候")||
		$.messager.alert("提示","非【指定医生】的记录不能进行【取消指定医生】!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"CancleAdjConfirm",
		dataType:"text",
		QueID:QueID,UserID:session['LOGON.USERID']
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("提示","取消指定医生失败!"+rtn);
			return false;
		}
		LoadPatQueue("");
	})}
//自动报到
function AutoQueCheckin(){
	var ReportQueIDStr=""
	var Rows=PageLogicObj.m_AllocListTabDataGrid.datagrid('getRows');
	var ListData =PageLogicObj.m_AllocListTabDataGrid.datagrid('getData');
	for (i=0;i<ListData.rows.length;i++){
		var status=ListData.rows[i].status
		if (status.indexOf("报到")>=0){
			if (ReportQueIDStr==""){ReportQueIDStr=ListData.rows[i].TQueID}
			else{ReportQueIDStr=ReportQueIDStr+"^"+ListData.rows[i].TQueID}
		}
	}
	if (ReportQueIDStr!=""){
		if (ReportQueIDStr.split("^").length>1){
			$.messager.confirm("确认对话框", "患者有多条需要报到记录是否同时报到?", function (r) {
				if (r) {
					for (j=0;j<ReportQueIDStr.split("^").length;j++){
						var QueID=ReportQueIDStr.split("^")[j]
						$.cm({
							ClassName:"web.DHCAlloc", 
							MethodName:"PatArrive",
							dataType:"text",
							itmjs:"PatArriveToHUI", itmjsex:"", QueID:QueID,UserID:session['LOGON.USERID']
						},function(rtn){
							if (rtn!=0){
								$.messager.alert("提示","报到失败!"+rtn);
								return false;
							}
						})
						LoadPatQueue("");
					}
				}
			});
		}else{
			var QueID=ReportQueIDStr
			$.cm({
				ClassName:"web.DHCAlloc", 
				MethodName:"PatArrive",
				dataType:"text",
				itmjs:"PatArriveToHUI", itmjsex:"", QueID:QueID,UserID:session['LOGON.USERID']
			},function(rtn){
				if (rtn!=0){
					$.messager.alert("提示","报到失败!"+rtn);
					return false;
				}
			})
			LoadPatQueue("");
		}
	}
}
	
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
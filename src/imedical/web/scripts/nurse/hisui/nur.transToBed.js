/**
 * @author piwenpig
 * @description 患者列表
 */
var GV = {
    ClassName: "Nur.HISUI.TransToBed"
}
/*-----------------------------------------------------------*/
var init = function () {
    //表格初始化
	initPage();
	//按钮事件初始化
	InitEvent();
	//回车事件
	key_enter();
}
$(init)

//按钮事件初始化
function InitEvent() {
	//分床按钮
	$("#Trans").click(TransToBed);
	
	//查询按钮
	$("#Find").click(RunQuery);
	
	//清屏按钮
	$("#clear").click(clear_click);
}

/**
 * @description 初始化页面元素
 */
function initPage() {
	var wardID=session['LOGON.WARDID'];
	var locID=session['LOGON.CTLOCID'];
	var BtnColumns=[[
		{field:'TransToBed',title:'分床',width:60,align:'center',
			formatter: function(value,row,index){
				if(row["CurrType"]!="转出区"){
					var TransEpisodeID=row["CurrEpisodeID"];
					var TransBedCode=row["CurrBedCode"];
					var TransPatName=row["CurrPatName"];
					var TransIfFirstToBed=row["CurrIfFirstToBed"];
					var IPAppBedID=row["IPAppBedID"];
					var ifNewBaby=row["ifNewBaby"];
					if ((ifNewBaby=="Y")&&((bedSetting.AllowBabyAloneAssignBedSwitch!="Y")||(bedSetting.maternalBabyWardFlag === "Y"))){return "";}
					var btn = '<a class="editCls" onclick="OpenWindows(\'' +TransEpisodeID+ '\' , \''+TransBedCode + '\', \''+TransPatName + '\', \''+TransIfFirstToBed + '\', \''+IPAppBedID + '\')"><font color="">'+$g('分床')+'</font></a>';
					return btn;
				}
			}
		},
		{field:'Trans',title:'转科',width:100,align:'center',
			formatter: function(value,row,index){
				if(row["CurrType"]!="转出区"){
					var btn = '<a class="editCls" onclick="OpenTransferCsp(\'' + row["CurrEpisodeID"] + '\',\''+ row["CurrBedId"] +'\')"><font color="">'+$g('转科')+'</font></a>';
				}else{
					var btn = '<a class="editCls" onclick="CancelTransLocApply(\'' + row["CurrEpisodeID"] + '\')"><font color="red">'+$g('撤销转科')+'</font></a>';
				}
				return btn;
			}
		},
		{field:'Discharge',title:'出院',width:60,align:'center',
			formatter: function(value,row,index){
				if(row["CurrType"]!="转出区"){
					var btn = '<a class="editCls" onclick="OpenDischargeCsp(\'' + row["CurrEpisodeID"] + '\')"><font color="">'+$g('出院')+'</font></a>';
					return btn;
				}
				
			}
		},
	]]
	
	var WaitColumns=[[ 
		{field:'ck',checkbox:true,width:10},
		{field:'CurrType',title:'患者类型',width:80},
		{field:'CurrBedCode',title:'床位',width:60},
		{field:'CurrPatName',title:'患者姓名',width:100},
		{field:'CurrRegNo',title:'登记号',width:120},
		{field:'CurrSex',title:'性别',width:50,hidden:true},
		{field:'CurrAge',title:'年龄',width:50,hidden:true},
		{field:'CurrMedicare',title:'住院号',width:100,hidden:true},
		{field:'CurrEpisodeID',title:'就诊号',width:100,hidden:true},
		{field:'CurrIfFirstToBed',title:'是否首次分床',width:100,hidden:true},
    ]]
    $('#WardWaitGrid').datagrid({
		url:$URL + '?ClassName='+GV.ClassName+'&QueryName=FindWardWait'+'&wardID='+wardID+'&locID='+locID,
		pageSize:20,
		pageList : [20,50,100,200],
		autoSizeColumn:false,
		rownumbers:false,
		pagination:true,
		border:false,
		frozenColumns:WaitColumns,
		columns :BtnColumns,
		iconCls:'icon-bed',
        toolbar: [{
            iconCls: 'icon-ok',
            text:'批量分床',
            handler: BatchTransToBed
        },'-',{
            iconCls: 'icon-reload',
            text:'刷新列表',
            handler: findWardWait
        }],
		onCheck:function(index, row){
            var frm=dhcsys_getmenuform();
            if (frm){
                frm.EpisodeID.value=row["CurrEpisodeID"];
            }
        },
    });
    
    var wardColumns=[[ 
		{field:'ck',checkbox:true,width:10},
		{field:'CurrBedCode',title:'床位',width:60},
		{field:'CurrPatName',title:'患者姓名',width:100},
		{field:'CurrSex',title:'性别',width:50},
		{field:'CurrAge',title:'年龄',width:50},
		{field:'CurrRegNo',title:'登记号',width:120},
		{field:'CurrMedicareNo',title:'住院号',width:80},
		{field:'CurrEpisodeID',title:'就诊号',width:100,hidden:true},
		{field:'CurrIfFirstToBed',title:'是否首次分床',width:100,hidden:true},
    ]]
    $('#wardBedGrid').datagrid({
		url:$URL + '?ClassName='+GV.ClassName+'&QueryName=FindWardBed'+'&wardID='+wardID,
		pageSize:50,
		pageList : [50,100,150,200],
		autoSizeColumn:false,
		rownumbers:false,
		pagination:true,
		iconCls:'icon-bed',
		border:false,
		frozenColumns:wardColumns,
		columns :BtnColumns,
        toolbar: [{
            iconCls: 'icon-ok',
            text:'批量转移至等候区',
            handler: TransToWaitRoom
        },'-',{
            iconCls: 'icon-reload',
            text:'刷新列表',
            handler: findWardBed
        }],
		onCheck:function(index, row){
            var frm=dhcsys_getmenuform();
            if (frm){
                frm.EpisodeID.value=row["CurrEpisodeID"];
            }
        },
    });
	$HUI.combobox('#PatName', {
		valueField: 'ID',
		textField: 'name',
		url:$URL+'?ClassName='+GV.ClassName+'&MethodName=getPatName'+'&wardID='+wardID,
		filter: function(q, row){
                var opts = $(this).combobox('options');
				var Name=String(row[opts.textField]);
                return Name.indexOf(q)>-1;
        },
		onSelect: function(){
	            RunQuery();
        }
	});

}

/**
 * @description 查询等候区患者
 */
function findWardWait(){
	$("#BedCode").val("");
	$("#RegNo").val("");
	$HUI.combobox('#PatName').setValue("");
	$('#WardWaitGrid').datagrid({
		url:$URL,
		queryParams:{
			ClassName:GV.ClassName,
			QueryName:"FindWardWait",
			wardID:session['LOGON.WARDID'],
			locID:session['LOGON.CTLOCID'],	
		},
	});
}
/**
 * @description 查询在床患者
 */
function findWardBed(){
	$("#BedCode").val("");
	$("#RegNo").val("");
	$HUI.combobox('#PatName').setValue("");
	$('#wardBedGrid').datagrid({
		url:$URL,
		queryParams:{
			ClassName:GV.ClassName,
			QueryName:"FindWardBed",
			wardID:session['LOGON.WARDID'],
		},
	});
}

/**
 * @description 一键批量分床
 */
function BatchTransToBed(){
	var wardID=session['LOGON.WARDID'];
	var UserId=session['LOGON.USERID'];
	var bedStr="";
	var Error="";
	var Success="";
    var selectRows=$('#WardWaitGrid').datagrid('getSelections');

	if(selectRows.length==0){
        $.messager.popover({msg:'请选中患者进行分床!',type:'alert'});
        return;
    }
    var locNurseArr = $cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		MethodName:"GetMainNurses",
		locID:session['LOGON.CTLOCID']
	},false);
    selectRows.forEach(function(row){
	    if(row.CurrType=="转出区"){
		    var ErrRet=row.CurrPatName+"分床失败!&nbsp;&nbsp;&nbsp失败原因为：转出区患者不允许分床";
		    Error=Error==""?ErrRet:Error+"<p style='padding-top:15px'>"+ErrRet+"</p>";
		    return
		 }
	    
        if(row.CurrEpisodeID!=""){
	        if ((row.ifNewBaby=="Y")&&((bedSetting.AllowBabyAloneAssignBedSwitch!="Y")||(bedSetting.maternalBabyWardFlag === "Y"))){
		        $.messager.popover({msg:'婴儿无法单独分床！',type:'error'});
				return;
		    }
	        
			var bedID=tkMakeServerCall(GV.ClassName, 'getFristEmptyBeds', wardID,bedStr,row.CurrEpisodeID)
			if(bedID==""){
				$.messager.popover({msg:'该病区没有床位，无法进行分床!',type:'error'});
				return;
			}
			var mainDoc=tkMakeServerCall(GV.ClassName, 'getMainDoctorID', row.CurrEpisodeID);
			if(mainDoc==""){
				mainDoc=tkMakeServerCall(GV.ClassName, 'getBedDoc', bedID,row.CurrEpisodeID);
			}
			var currLocID=$.cm({
				ClassName:"Nur.NIS.Service.Base.Patient",
				MethodName:"GetCurrLocID",
				EpisodeID:row.CurrEpisodeID
			},false)
			var docArr=$.cm({
				ClassName:"Nur.NIS.Service.Base.Ward",
				MethodName:"GetMainDoctors",
				locID:currLocID
			},false)
			if($.hisui.indexOfArray(docArr,"ID",mainDoc)<0) mainDoc="";
			if ((bedSetting.MainDocRequired=="Y")&&(mainDoc=="")){
				$.messager.popover({msg: "请选择主管医生！",type:'error'});
				return
			}
			var mainNurse=tkMakeServerCall(GV.ClassName, 'getMainNurseID', row.CurrEpisodeID);
			if(mainNurse==""){
				mainNurse=tkMakeServerCall(GV.ClassName, 'getBedNur', bedID);
			}
			if($.hisui.indexOfArray(locNurseArr,"ID",mainNurse)<0) mainNurse="";
			if ((bedSetting.MainNurseRequired=="Y")&&(mainNurse=="")){
				$.messager.popover({msg: "请选择主管护士！",type:'error'});
				return
			}
			var jsonData = $cm({
				ClassName:"Nur.NIS.Service.Transaction",
				MethodName:"TransToBed",
				episodeID:row.CurrEpisodeID,
				bedID:bedID,
				userID:UserId,
				mainDoc:mainDoc,
				mainNurse:mainNurse,
				firstTrans:row.CurrIfFirstToBed,
			},false);
			if(jsonData.status!="0"){
				var ErrRet=row.CurrPatName+"分床失败!&nbsp;&nbsp;&nbsp失败原因为："+jsonData.status;
				Error=Error==""?ErrRet:Error+"<p style='padding-top:10px'>"+ErrRet+"</p>";
				bedStr=bedStr+"^"+bedID;
			}else{
				var SucRet=row.CurrPatName+"   分床成功!";
				Success=Success==""?SucRet:Success+"<p style='padding-top:10px'>"+SucRet+"</p>";
			}
        }
    });
	if(Error!=""){
		$.messager.popover({msg: Error,type:'error'});
	}
	if(Success!=""){
		$.messager.popover({msg: Success,type:'success'});
		findWardWait();
		findWardBed();
	}
}
/**
 * @description 一键批量转移至等候区
 */
function TransToWaitRoom()
{
	var Error="";
	var Success="";
    var selectRows=$('#wardBedGrid').datagrid('getSelections');
	if(selectRows.length==0){
        $.messager.popover({msg:'请选中患者!',type:'error'});
        return;
    }
    var roomDR=tkMakeServerCall(GV.ClassName, 'getWaitRoomId', session['LOGON.WARDID']);
    if (roomDR==""){
	    $.messager.popover({msg:'该病区未维护等候区',type:'error'});
        return;
	}
    selectRows.forEach(function(row){ 
        if(row.CurrEpisodeID!=""){
			/*var bedID=tkMakeServerCall(GV.ClassName, 'getFristEmptyBeds', session['LOGON.WARDID'],"");
			if (bedID==""){
				 $.messager.alert("提示", "该患者不在床位上,无法转移至等候区！", 'info');
				 return;
			}*/
			var canTransToWaitRoom=1;
			if (bedSetting.tranToWaitRoom=="OnlyNoAdmitDiagORDocDisch"){
				var ifDocDisch=tkMakeServerCall("Nur.NIS.Service.Base.Patient","GetIfDischarge",row.CurrEpisodeID);
				var admitDiagCount=tkMakeServerCall("Nur.NIS.Service.Base.Patient","getAdmitDiagCount",row.CurrEpisodeID);
				if (ifDocDisch != 1 && admitDiagCount > 0) {
					var ErrRet=row.CurrPatName+"转移至等候区失败!&nbsp;&nbsp;&nbsp;失败原因为：只允许医疗结算或未开入院诊断的患者分配到等候区!";
					Error=Error==""?ErrRet:Error+"<p style='padding-top:10px'>"+ErrRet+"</p>";
					canTransToWaitRoom=0;
				}
			}
			if (canTransToWaitRoom==1){
				var doctorID=tkMakeServerCall(GV.ClassName, 'getMainDoctorID', row.CurrEpisodeID);
				var nurseID=tkMakeServerCall(GV.ClassName, 'getMainNurseID', row.CurrEpisodeID);
				
				var jsonData = $cm({
					ClassName:"Nur.NIS.Service.Transaction",
					MethodName:"TransToWaitRoom",
					episodeID:row.CurrEpisodeID,
					wardID:session['LOGON.WARDID'],
					userID:session['LOGON.USERID'],
					roomDR:roomDR,
					mainDoc:doctorID,
					mainNurse:nurseID,
				},false);
				if(jsonData.status!="0"){
					var ErrRet=row.CurrPatName+"转移至等候区失败!&nbsp;&nbsp;&nbsp;失败原因为："+jsonData.status;
					Error=Error==""?ErrRet:Error+"<p style='padding-top:10px'>"+ErrRet+"</p>";
				}else{
					var SucRet=row.CurrPatName+"   转移至等候区成功!";
					Success=Success==""?SucRet:Success+"<p style='padding-top:10px'>"+SucRet+"</p>";
				}
			}
        }
    });
	if(Error!=""){
		$.messager.popover({msg: Error,type:'error'});
	}
	if(Success!=""){
		$.messager.popover({msg: Success,type:'success'});
		findWardWait();
		findWardBed();
	}
}
/**
 * @description 打开隐藏窗口并初始化赋值
 */
 var TransInfo={
	 EpisodeID:"",
	 BedCode:"",
	 PatName:"",
	 IfFirstToBed:"",
}
function OpenWindows(CurrEpisodeID,CurrBedCode,CurrPatName,CurrIfFirstToBed,IPAppBedID){
	var wardID=session['LOGON.WARDID'];
	var UserId=session['LOGON.USERID'];
	var locID=session['LOGON.CTLOCID'];
    
    $("#Win").dialog("open");
	$("#Win").dialog("center");
	$("#patientName").val(CurrBedCode+"  "+CurrPatName);
	
	var bedID=tkMakeServerCall(GV.ClassName, 'getFristEmptyBeds', wardID,"");
	//IPAppBedID
	$HUI.combobox('#bedNo', {
		valueField: 'ID',
		textField: 'code',
		value:bedID,
		mode:'remote',
		url:$URL+'?ClassName='+GV.ClassName+'&MethodName=getEmptyBeds'+'&wardID='+wardID,
		onLoadSuccess:function(){
			if (IPAppBedID){
				var index=$.hisui.indexOfArray($("#bedNo").combobox("getData"),"ID",IPAppBedID)
				if (index>=0){
					$("#bedNo").combobox("select",IPAppBedID);
				}
			}
		}
	});

	var doctorID=tkMakeServerCall(GV.ClassName, 'getMainDoctorID', CurrEpisodeID);
	$HUI.combobox('#doctor', {
		valueField: 'ID',
		textField: 'name',
		value:doctorID,
		url:$URL+'?ClassName='+GV.ClassName+'&MethodName=getMainDoctors'+'&episodeID='+CurrEpisodeID,
		defaultFilter:6,
		multiple:bedSetting.MainDocMulti=="Y"?true:false,
		rowStyle:bedSetting.MainDocMulti=="Y"?"checkbox":"",
		onSelect:function(rec){
			if (bedSetting.MainDocMulti=="Y"){
				var selValArr=$('#doctor').combobox("getValues");
				if (selValArr.length>=3){
					$('#doctor').combobox("setValues",selValArr.slice(1,3))
				}
			}
		}
	});
	var nurData=$.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"GetMainNurseID",
		EpisodeID:CurrEpisodeID
	},false)
	$HUI.combobox('#nurse', {
		valueField: 'ID',
		textField: 'name',
		value:bedSetting.MainNurseMulti=="Y"?nurData:nurData[0],
		url:$URL+'?ClassName='+GV.ClassName+'&MethodName=getMainNurses'+'&locID='+locID,
		defaultFilter:6,
		multiple:bedSetting.MainNurseMulti=="Y"?true:false,
		rowStyle:bedSetting.MainNurseMulti=="Y"?"checkbox":"",
		onSelect:function(rec){
			if (bedSetting.MainNurseMulti=="Y"){
				var selValArr=$('#nurse').combobox("getValues");
				if (selValArr.length>=3){
					$('#nurse').combobox("setValues",selValArr.slice(1,3))
				}
			}
		}
	});
	
	if(CurrIfFirstToBed=="Y"){
		$("#firstAssignBedFlag").text($g("首次分床"));
	}else{
		$("#firstAssignBedFlag").text($g("分床"));
	}
	TransInfo.EpisodeID=CurrEpisodeID;
	TransInfo.BedCode=CurrBedCode;
	TransInfo.PatName=CurrPatName;
	TransInfo.IfFirstToBed=CurrIfFirstToBed;
}

/**
 * @description 分床
 */
function TransToBed(){
	var UserId=session['LOGON.USERID'];
	var bedID=$HUI.combobox('#bedNo').getValue();
	var mainDoc=$HUI.combobox('#doctor').getValues().join(",");
	var mainNurse=$HUI.combobox('#nurse').getValues().join(",");
	
	if (bedID==""){
		$.messager.popover({msg: "请选择需要转移的床位！",type:'error'});
		return
	}
	else if (bedID.indexOf("||")<0){
		$.messager.popover({msg: "请选择下拉框里面的床位！",type:'error'});
		return
	}
	if ((bedSetting.MainDocRequired=="Y")&&(mainDoc=="")){
		$.messager.popover({msg: "请选择主管医生！",type:'error'});
		return
	}
	if ((bedSetting.MainNurseRequired=="Y")&&(mainNurse=="")){
		$.messager.popover({msg: "请选择主管护士！",type:'error'});
		return
	}
	$cm({
		ClassName:"Nur.NIS.Service.Transaction",
		MethodName:"TransToBed",
		episodeID:TransInfo.EpisodeID,
		bedID:bedID,
		userID:UserId,
		mainDoc:mainDoc,
		mainNurse:mainNurse,
		firstTrans:TransInfo.IfFirstToBed
		},function(jsonData){
			if(jsonData.status!="0"){
				$.messager.popover({msg: TransInfo.PatName+"   分床失败!失败原因为："+jsonData.status,type:'error'});
				return
			}else{
				$.messager.popover({msg: TransInfo.PatName+"   分床成功!",type:'success'});
				$("#Win").dialog("close");		//关闭窗口
				findWardWait();
				findWardBed();
			}
	});
}

/**
 * @description 撤销转科申请
 */
function CancelTransLocApply(CurrEpisodeID){
	$.messager.confirm("确认", "本操作将取消转移, 是否继续?", function (r) {
		if (r) {
		$cm({
			ClassName:"Nur.NIS.Service.Base.Transfer",
			MethodName:"CancelTransLocApply",
			EpisodeID:CurrEpisodeID,
			UserID:session['LOGON.USERID'],
			},function(ret){
				if (String(ret) === "0") {
					$.messager.popover({msg: "取消转移成功!",type:'success'});
					findWardWait();
              	} else {
	              	$.messager.popover({msg: "取消转移失败!失败原因为："+ret,type:'error'});
           		}
			});
		}else{
			return
		}
	});

}
/**
 * @description 打开转科界面
 */
function OpenTransferCsp(CurrEpisodeID,curBedId){
	var patOccupyBed=$m({
		ClassName:GV.ClassName,
		MethodName:"ifPatOccupyBed",
		episodeID:CurrEpisodeID,
		wardId:session['LOGON.WARDID']
	},false);
	if (patOccupyBed=="Y"){
		$.messager.popover({msg: "患者包床/包间未结束,不能转移,请先结束包床/包间!",type:'error'});
		return;
	}
	var URL="../csp/nur.hisui.transferdept.csp?EpisodeID="+CurrEpisodeID;
	websys_showModal({
      iconCls: "icon-w-export",
      url: URL,
      title: $g("转科"),
      width: 830,
      height: 632,
      CallBackFunc: function() {
        websys_showModal("close");
        findWardWait();
        findWardBed();
      }
    });
}
/**
 * @description 打开出院界面
 */
function OpenDischargeCsp(CurrEpisodeID){
	var iTop=(window.screen.height-500)/2;
	var iLeft=(window.screen.width-30-747)/2;
	var URL="../csp/nur.hisui.discharge.csp?EpisodeID="+CurrEpisodeID+"&type=F&TMENU";
	websys_createWindow(
		URL,
		"出院",
		"width=767,height=415,top="+iTop+",left="+iLeft
	);
}
/**
 * @description 查询按钮
 */
function RunQuery()
{
	var BedCodeStr=$("#BedCode").val();
	var RegNoStr=$("#RegNo").val();
	var PatNameStr=$HUI.combobox('#PatName').getValue();
	$('#WardWaitGrid').datagrid({
		url:$URL,
		queryParams:{
			ClassName:GV.ClassName,
			QueryName:"FindWardWait",
			wardID:session['LOGON.WARDID'],
			locID:session['LOGON.CTLOCID'],	
			BedCodeStr:BedCodeStr,
			RegNoStr:RegNoStr,
			PatNameStr:PatNameStr
		},
	});
	$('#wardBedGrid').datagrid({
		url:$URL,
		queryParams:{
			ClassName:GV.ClassName,
			QueryName:"FindWardBed",
			wardID:session['LOGON.WARDID'],
			BedCodeStr:BedCodeStr,
			RegNoStr:RegNoStr,
			PatNameStr:PatNameStr
		},
	});
}

/**
 * @description 回车事件
 */
function key_enter(){
	$('#RegNo').keyup(function(event){
		if(event.keyCode ==13){
			TmpRegNo=tkMakeServerCall(GV.ClassName,"RegNoCon",$('#RegNo').val())	//登记号补全
			$("#RegNo").val(TmpRegNo)
			RunQuery();	
		}
	});
	$('#BedCode').keyup(function(event){
		if(event.keyCode ==13){
			RunQuery();	
		}
	});
}
/**
 * @description 清屏按钮
 */
function clear_click() {
	window.location.reload();
}

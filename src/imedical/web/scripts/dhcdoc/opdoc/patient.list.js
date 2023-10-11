$(function(){
    InitShortcutBar();
	InitKWStatus();
	InitMarkComb();
	InitDateBox();
    InitOutPatientDataGrid();
    InitEvent();
});
function InitEvent()
{
	$('#PatientNo').keyup(function(e){
		if(e.keyCode==13){
            var PatientNo=$(this).val().replace(/\s+/g,"");
            if(PatientNo.length==0) return;
			while(PatientNo.length<10){PatientNo='0'+PatientNo;}
			$(this).val(PatientNo);
			LoadOutPatientDataGrid();
        }
	});
	$('#CardNo').keyup(function(e){
		var CardNo=$(this).val().replace(/\s+/g,"");
		if (CardNo==""){	//删除卡号 同步删除登记号
			$('#PatientNo').val('');
		}
		if(e.keyCode==13){
			if(CardNo==''){
				LoadOutPatientDataGrid();
			}else{
				DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardTypeCallBack);
			}
		 }
	});
	$('#BReadCard').click(function(e){
		DHCACC_GetAccInfo7(CardTypeCallBack);
	});
	$('#Name,#QueueNo').keyup(function(e){
		if(e.keyCode==13){
			var val=$(this).val().replace(/\s+/g,"");
			if(val=='') return;
			LoadOutPatientDataGrid();
        }
	});
	$('#BFind').click(LoadOutPatientDataGrid);
	$('#BCondShow').click(function(){
		var $obj=$(this).find('span');
		if(!$obj.size()) $obj=$(this).parent().find('span');
		var text=$obj.eq(0).text();
		if(text=='∨'){
			$obj.text('∧');
			$('#layoutCond').layout('panel', 'north').panel("resize", { height: 92 });
		}else{
			$obj.text('∨');
			$('#layoutCond').layout('panel', 'north').panel("resize", { height: 50 });
		}
		$('#layoutCond').layout('resize');
	});
	if(ServerObj.OPDefDisplayMoreContions=='Y'){
		$('#BCondShow').click();
	}
}
function InitShortcutBar()
{
	$('#btnList').marybtnbar({
		direction:'y',
		barCls:'btn-bar',
		btnCls:'btn-bar-btn',
        queryParams:{ClassName:'DHCDoc.OPDoc.MainFrame',QueryName:'QueryBtnCfg',url:'opdoc.patient.list.csp'},
        onClick:function(jq,cfg){
            if(cfg.url){
				if(cfg.id=='Registration'){
					var width=570,height=345;
					cfg.iconCls="icon-w-batch-add";
                    if ("undefined"!=typeof HISUIStyleCode && window.HISUIStyleCode=="lite"){
                        width=540;
                    }
				}else{
					var width=$(document).width()*0.8,height=$(document).height()*0.8;
				}
				ShowHISUIWindow($g(cfg.text),cfg.url,cfg.iconCls||'',width,height);
            }
        }
    });
}
function InitMarkComb()
{
	$("#MarkDocList").combobox({
		url:'websys.Broker.cls?ClassName=DHCDoc.OPDoc.PatientList&MethodName=DocRegList&userId='+session['LOGON.USERID']+'&locId='+session['LOGON.CTLOCID'],
		valueField: 'id',
		textField: 'des',
		onSelect: function (rec) {
			LoadOutPatientDataGrid();
		},
        onLoadSuccess:function(data){
            var MarkDocID=$("#MarkDocList").getValue();
            if (MarkDocID!="") LoadOutPatientDataGrid();
        }
   	});
}
function InitKWStatus()
{
    $("#kwStatus").keywords({
        singleSelect:true,
        items:[
            {text:$g('待就诊')+'(0)',id:'RegQue',selected:ServerObj.InitPatListType=='RegQue'},
            {text:$g('已就诊')+'(0)',id:'ArrivedQue',selected:ServerObj.InitPatListType=='ArrivedQue'},
            {text:$g('未报到')+'(0)',id:'Report',selected:ServerObj.InitPatListType=='Report'},
            {text:$g('已完成')+'(0)',id:'Complete',selected:ServerObj.InitPatListType=='Complete'}
        ],
        onClick:function(v){
            LoadOutPatientDataGrid();
        }
    });
}
function InitDateBox()
{
	$('#DateFrom,#DateTo').datebox({
		onSelect:function(){
			LoadOutPatientDataGrid();
		},onChange: function(newValue, oldValue){
			if (newValue!=oldValue){
				//由于同步调用不能触发查询的方法使用setTimeout
				setTimeout(function(){
					LoadOutPatientDataGrid()
				},60);
			}
		}
	})
}
function InitOutPatientDataGrid(){
	var LoadTimer=null;
	///新增数据列请修改对应Query，新增操作列请修改DHCDoc.OPDoc.PatientList GetOutPatientListColSet
	var frozenColumns=[
		{field:'LocSeqNo',title:'序号',align:'center',width:50},
		{field:'PAPMINO',title:'登记号',align:'center',width:120,
			formatter: function(value,row,index){
				return '<a style="cursor:pointer;" onclick="ShowPatInfo(\'' + row.EpisodeID + '\')">'+value+'</a>';
			}
		},
		{field:'PAPMIName',title:'姓名',align:'center',width:70,
			formatter: function(value,row,index){
				if (ServerObj.ClickNameCall=="Y"){
					if (($("#kwStatus").keywords('getSelected')[0].id=='RegQue')&&(CheckAdmDate(row.PAAdmDate))){
						return '<a style="cursor:pointer;" onclick="callOnePatient(\'' + row.EpisodeID + '\')">'+value+'</a>';
					}
				}
				return value;
			}
		}
	];
	var frozenFieldStr="";
	for (var i=0;i<frozenColumns.length;i++){
		if (frozenFieldStr==""){
			frozenFieldStr=frozenColumns[i].field;
		}else{
			frozenFieldStr=frozenFieldStr+"^"+frozenColumns[i].field;
		}
	}
	//过滤掉冻结的列
	var Columns = [];
	ServerObj.Columns.forEach(function (v, i,arry) {
		if (("^"+frozenFieldStr+"^").indexOf("^"+v.field+"^")==-1) {
			Columns.push(v);
		}
	});
	//给列添加其他属性
	Columns.forEach(function (v, i,arry) {
		columnsConfig={align:'center'};
		filedName=v.field;
		switch (filedName) {
			case "WalkStatus":
				$.extend(columnsConfig,{
					styler: function(value,row,index){
						var WalkStatus=row['StatusCode'];
						if (WalkStatus=='03'){
							return 'background-color: #ff7373  !important;color:#fff !important;';
						}
					}
				});
			break;
			case "DrugsStatus":
				$.extend(columnsConfig,{
					formatter: function(value,row,index){
						return renderWorkStatusCols(value,row,"Drug");
					}
				});
			break;
			case "InspectStatus":
				$.extend(columnsConfig,{
					formatter: function(value,row,index){
						return renderWorkStatusCols(value,row,"Exam");
					}
				});
			break;
			case "LaboratoryStatus":
				$.extend(columnsConfig,{
					formatter: function(value,row,index){
						return renderWorkStatusCols(value,row,"Lab");
					}
				});
			break;
			case "TreatmentStatus":
				$.extend(columnsConfig,{
					formatter: function(value,row,index){
						return renderWorkStatusCols(value,row,"Treat");
					}
				});
			break;
			case "TransEpisodeID":
				$.extend(columnsConfig,{
					title:$g("转诊"),
					formatter: function(value,row,index){
						return '<a><img style="cursor:pointer" src="../images/websys/update.gif" border="0" onclick="PatTransfer('+row.EpisodeID+')"></a>';
					}
				});
			break;
			case "CancleEpisodeID":
				$.extend(columnsConfig,{
					title:$g("取消接诊"),
					formatter: function(value,row,index){
						return '<a><img style="cursor:pointer" src="../images/websys/delete.gif" border="0" onclick="CancleTransfer('+row.EpisodeID+')"></a>';
					}
				});
			break;
			case "PAAdmReMark":
				$.extend(columnsConfig,{
					sortable:true,
					formatter:function(value,rec){  
						if ((value)&&(value!="")&&(value!=" ")){
							var btn = '<a href="javascript:void(0)" id ="Remark'+rec.EpisodeID +'"title="'+value+'" class="hisui-tooltip" onmouseover="PAAdmReMarkonmouse(\'' + rec.EpisodeID+ '\') " onclick="PAAdmReMarkShow(\'' + rec.EpisodeID + '\',\''+rec.PAPMIName+'\')">'+value+'</a>';
						}else{
							var btn = '<a href="javascript:void(0)"  class="editcls" onclick="PAAdmReMarkShow(\'' + rec.EpisodeID + '\',\''+rec.PAPMIName+'\')"><img src="../scripts/dhcdoc/dhcapp/images/adv_sel_11.png" title="'+$g("医生便签")+'" border="0"></a>';
						}
						return btn;
					}
				});
			break;
			default:
			break;
		}
		$.extend(v,columnsConfig);
	});
	Columns=new Array(Columns);
	frozenColumns=new Array(frozenColumns);

	$("#tabPatList").datagrid({
        url:'websys.Broker.cls',
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:false,
		pagination : false,
		rownumbers : false,
		frozenColumns:frozenColumns,
		idField:'EpisodeID',
		columns :Columns,
		remoteSort:false,
		//columns :[myColumns],
		onDblClickHeader:function(e,field){
			if ((ServerObj.lookupListComponetId != "")&&((ServerObj.AllowWebColumnManagerFlag == "1"))) {
				websys_lu('../csp/websys.component.customiselayout.csp?ID=' + ServerObj.lookupListComponetId + 
					'&CONTEXT=K' + ServerObj.ListColSetCls + '.' + ServerObj.ListColSetMth + '.' + ServerObj.XCONTEXT + 
					"&GETCONFIG=1&DHCICARE=2", false);
			}
		},
		rowStyler: function(index,row){
			var Called=row['Called']; 
			if (Called=="1"){
				 return 'background-color:#D1F1D9;color:#000;'; //#00DC00 , #21ba45
			}
			if (Number(Called)>1){
				return 'background-color:#d2eafe;color:#000;';
			}
		},
        onSelect:function(rowIndex, rowData){
			ShowSecondeWin(rowData);
		},
		onDblClickRow:function(rowIndex, rowData){
			if (rowData.WalkStatus==$g("未报到")){
				$.messager.alert("提示","患者未报到！","info",function(){
					switchPatient(rowData.PatientID,rowData.EpisodeID,rowData.mradm)
				});
			}else{
				switchPatient(rowData.PatientID,rowData.EpisodeID,rowData.mradm)
			}
		},
		onLoadSuccess:function(data){
			var dataStr = JSON.stringify(data);
			if ("string" == typeof dataStr ){ 
				if (dataStr.toLowerCase().indexOf("logon")>-1 || dataStr.toLowerCase().indexOf("login")>-1){
					//console.log("dataStr:"+dataStr)
					clearTimeout(LoadTimer);
					var MWToken = "";
					if ('function'==typeof websys_getMWToken) MWToken = websys_getMWToken();
					var MenuWin = websys_getMenuWin();
					if ((MWToken)&&('undefined'!==typeof MenuWin.lockScreenOpt && 'function'==typeof MenuWin.lockScreenOpt.lockScrn)){  /// 超时后自动锁屏
						 MenuWin.lockScreenOpt.lockScrn();
					}else{
						$.messager.alert("提示","系统已超时,请关闭界面,重新登录!");
					}
					return "";
				}
			}

			var CurDate=GetCurrentDate();
			var kwStatus=$("#kwStatus").keywords('getSelected')[0].id;
			var $grid=$('#tabPatList').prev().children('.datagrid-body').children('.datagrid-btable');
			if(kwStatus=='RegQue') $('.call-pat-name').empty();
			for(var i=0;i<data.rows.length;i++){
				if((data.rows[i].Called=='1')&&(kwStatus=='RegQue')){	//&&(data.rows[i].PAAdmDate==CurDate)
					$('.call-pat-name').append('<li>'+data.rows[i].PAPMIName+'</li>');
				}
				InitWorkStatus($grid.find('tr.datagrid-row[datagrid-row-index='+i+'] a[name=WorkStatus]'),data.rows[i]);
			}
			UpdateOutPatListCatCount();
			if (data.rows.length>0){
				//查询到数据之后，清除登记号和卡号等信息
				$("#CardNo,#PatientNo,#Name,#QueueNo").val("");
			}
			$(this).prev().find('.datagrid-body').find('div.datagrid-cell').overflowtip();
			LoadTimer=setTimeout(function(){
				for(var i=0;i<data.rows.length;i++){
					$grid.find('tr.datagrid-row[datagrid-row-index='+i+'] a[name=WorkStatus]').each(function(){
						$(this).tooltip('destroy');
					})
				}
				LoadOutPatientDataGrid()
			
			},60000);
        },
        onBeforeLoad:function(param){
            param.ClassName="DHCDoc.OPDoc.PatientList";
            param.MethodName="OutPatientList";
            param.LocID=session['LOGON.CTLOCID'];
            param.UserID=session['LOGON.USERID'];
            param.IPAddress="";
            param.AllPatient="";
            param.PatientNo= $("#PatientNo").val();
            param.SurName=$("#Name").val();
            param.StartDate=$("#DateFrom").datebox('getValue');
            param.EndDate=$("#DateTo").datebox('getValue');
            param.ArrivedQue="";
            param.RegQue="";
            param.Consultation="";
            param.MarkID=$("#MarkDocList").getValue();
			param.CheckName=$("#kwStatus").keywords('getSelected')[0].id;
			param.PatSeqNo=$('#QueueNo').val();
			clearTimeout(LoadTimer);
			$("#tabPatList").datagrid('unselectAll');
        }
	})
}
function LoadOutPatientDataGrid()
{
	$("#tabPatList").datagrid('reload');
}
function findPatientTree(){
	$('#kwStatus').keywords('select','RegQue');
}
function UpdateOutPatListCatCount(){
	$.cm({
	    ClassName : "DHCDoc.OPDoc.PatientList",
	    MethodName : "OutPatientListCatCount",
	    LocID: session['LOGON.CTLOCID'],
	    UserID: session['LOGON.USERID'],
	    IPAddress: "",
	    AllPatient: "",
	    PatientNo: $("#PatientNo").val(),
	    SurName: $("#Name").val(),
	    StartDate:$("#DateFrom").datebox('getValue'),
	    EndDate:$("#DateTo").datebox('getValue'),
	    ArrivedQue: "",
	    RegQue: "",
	    Consultation:"",
	    MarkID:$("#MarkDocList").getValue(),
	    CheckName:$("#kwStatus").keywords('getSelected')[0].id
	},function(data){
        $('#RegQue a').text($g('待就诊')+'('+data.RegQue+')');
        $('#ArrivedQue a').text($g('已就诊')+'('+data.Complete+')');
		$('#Report a').text($g('未报到')+'('+data.Report+')');
		$('#Complete a').text($g('已完成')+'('+data.DocComplete+')');
		//$("#WaitPatNum",window.parent.document).text(data.RegQue);
		if (($("#PatientNo").val()!="")||($("#Name").val()!="")){
			var CurrKey=$("#kwStatus").keywords("getSelected")[0].id
			if (typeof data[CurrKey] !="undefined" && parseInt(data[CurrKey]) == 0){
				//var clickFun=$("#kwStatus").keywords("options").onClick
				//$("#kwStatus").keywords("options").onClick=function(){}
				if (parseInt(data.RegQue)>0){
					if (CurrKey!="RegQue") $('#kwStatus').keywords('select','RegQue');
				}else if(parseInt(data.Complete)>0){
					if (CurrKey!="ArrivedQue") $('#kwStatus').keywords('select','ArrivedQue');
				}else if(parseInt(data.Report)>0){
					if (CurrKey!="Report") $('#kwStatus').keywords('select','Report');
				}else if(parseInt(data.DocComplete)>0){
					if (CurrKey!="Complete") $('#kwStatus').keywords('select','Complete');
				}
			}
			//$("#kwStatus").keywords("options").onClick=clickFun
			//clickFun();
		}
		if(typeof parent.UpdateWaitTip=='function'){
			parent.UpdateWaitTip(data);
		}
	}); 
}
function renderWorkStatusCols(value,row,renderType)
{
	var ic=getWorkStatusIcon(value);
	return ic?'<a href="#" name="WorkStatus" class="'+ic+'">&nbsp;&nbsp;&nbsp;&nbsp;</a>':'';
}
function getWorkStatusIcon(statusCode,otherClass,style)
{
	var ic='';
	switch(statusCode){
		case "S0":break;
		case "S1":ic="icon-funnel-empty hisui-linkbutton";break;
		case "S2":ic="icon-funnel-half status-s2";break;
		case "S3":ic="icon-ok status-finish";break;
		default:
			if((statusCode.indexOf("S3")>0) || (statusCode.indexOf("S2")>0) || (statusCode.indexOf("S1")>0)){
				ic="icon-funnel-half status-s1";
			}
			break;
	}
	if(otherClass) ic+=' '+otherClass;
	return ic;
}
function InitWorkStatus($obj,row)
{
	$obj.each(function(){
		var that=this;
		var field=$(this).parent().parent().attr('field');
		var column=$("#tabPatList").datagrid('getColumnOption',field);
		var title=$g(column.title);
		var positionsign="bottom"
		var offsettop = $(this).offset().top;
		var windowsheigth=$(document.body).height();
		if ((offsettop*2)>windowsheigth) var positionsign="top"
		$(this).tooltip({
			content: $g('加载中..'),
			position:positionsign,
			onShow:function(){
				$.cm({
					ClassName:"DHCDoc.OPDoc.PatientList",
					MethodName:"GetOPHandleStatusData",
					EpisodeID:row.EpisodeID,
					format:"JSON",
					list:""
				},function(data){
					var content='';
					for(var i=0;i<data.length;i++){
						if(data[i]["des"].indexOf(title)>-1){
							data[i]["des"]=$g(data[i]["des"])
							content=(content=='')?data[i]["des"]:content+'<br/>'+data[i]["des"];
							var list=data[i]['list'];
							for(var j=0;j<list.length;j++){
								content=(content=='')?list[j]:content+'<br/>'+(j+1)+'.'+list[j];
							}
						}
					}
					$(that).tooltip('update',content).tooltip('reposition');
				});
			}
		});
	})
}
function switchPatient(PatientID,EpisodeID,mradm)
{
	if(websys_getTop && websys_getTop().doingSthConfirm){
		var t = {PatientID:PatientID,EpisodeID:EpisodeID,mradm:mradm};
		websys_getTop().doingSthConfirm(doSwitchCallbackObj,t,'保存','不存')
		return false;
	}else{
		var frm = dhcsys_getmenuform();
		if(frm.DoingSth&&frm.DoingSth.value){
			$.messager.alert("提示",frm.DoingSth.value+"请稍后再试");
			return false; //不能切换病人
		}else{
			doSwitchCallbackObj();
		}
	}
	function doSwitchCallbackObj(){
		clearSearch()
		if(parent.hidePatListWin) parent.hidePatListWin();
		if(parent.switchPatient){
			parent.switchPatient(PatientID,EpisodeID,mradm);
		}else{
			var frm = dhcsys_getmenuform();
			if((frm) &&(frm.EpisodeID.value != EpisodeID)){
				frm.EpisodeID.value = EpisodeID;
				frm.PatientID.value = PatientID; 
				frm.mradm.value = mradm; 	
			}
		}
	}
}
function clearSearch(){
	$("#PatientNo,#Name,#QueueNo,#CardNo,#CardTypeNew").val("");
    LoadOutPatientDataGrid()
}
//业务代码
function CardTypeCallBack(myrtn)
{
	var myary=myrtn.split("^");
	var rtn=myary[0];
	if((rtn=='0')||(rtn=='-201')){
		var PatientNo=myary[5],CardNo=myary[1]
		$("#CardNo").focus().val(CardNo);
		$("#PatientNo").val(PatientNo);
		LoadOutPatientDataGrid();
	}else{
		$.messager.alert("提示","卡无效!","info",function(){$("#CardNo").select();});
	}
}
function callPatientHandler(event){
	var rows = $("#tabPatList").datagrid('getRows');
	if (rows[0]){
		var RowData=rows[0]
		if (RowData.PAAdmReMark!=""){
			$.messager.popover({msg:$g("患者:")+RowData.PAPMIName+$g("   便签信息:")+RowData.PAAdmReMark,type:'info'});
			}
		}
	var ret=tkMakeServerCall("web.DHCVISQueueManage","RunNextButton","","",GetCacheIPAddress());
	return CalledAfter(ret);
}
function reCallPatientHandler(event){
	var rows = $("#tabPatList").datagrid('getRows');
	if (rows[0]){
		var RowData=rows[0]
		if (RowData.PAAdmReMark!=""){
			$.messager.popover({msg:$g("患者:")+RowData.PAPMIName+$g("   便签信息:")+RowData.PAAdmReMark,type:'info'});
			}
		}
	var ret=tkMakeServerCall("web.DHCVISQueueManage","RecallButton","","",GetCacheIPAddress());
	return CalledAfter(ret);
}
function callOnePatient(EpisodeID){
	var MarkID=$("#MarkDocList").getValue();
	var rows = $("#tabPatList").datagrid('getRows');
	for(var i=0;i<rows.length;i++){
		var RowData=rows[i]
		if ((RowData.EpisodeID==EpisodeID)&&(RowData.PAAdmReMark!="")){
			$.messager.popover({msg:$g("患者:")+RowData.PAPMIName+$g("   便签信息:")+RowData.PAAdmReMark,type:'info'});
			}
		}
	var ret=tkMakeServerCall("web.DHCVISQueueManage","FrontQueueInsert",EpisodeID,session['LOGON.CTLOCID'],session['LOGON.USERID'],GetCacheIPAddress(),MarkID);
	return CalledAfter(ret);
}
function CalledAfter(ret){
	var retArr=ret.split('^');
    if(retArr[0]=="0") {
		$('#kwStatus').keywords('select','RegQue');
		return true;
	}else{
		$.messager.alert('叫号失败',retArr[1]||ret);
		return false;
	}
}
function skipCallPatientHandler(event){
	var row=$("#tabPatList").datagrid('getSelected');
	if (!row) {
		$.messager.popover({msg: t['SelectOnePatient'],type:'alert'});
		return false;
	}
	 if(!row.EpisodeID)return false;
	 if (row.Called==""){
		$.messager.popover({msg:"没有呼叫的病人不能过号!",type:'error'});
		return false;
	 }
	 $.messager.confirm('确认对话框', t['SkipNumberMsg'], function(r){
		if (r){
		    $.cm({ 
				ClassName:"web.DHCDocOutPatientList",
				MethodName:"SetSkipStatus", 
				Adm:row.EpisodeID,
				DocDr:ServerObj.DoctorID,
				dataType:'text'
			},function(stat){
				if (stat!='1'){
					$.messager.alert("提示",t['StatusFailure']);
					return false;
				}else{
					LoadOutPatientDataGrid();
				}
			});
		}
	});		 
}
function admissionsHandler(){
}
function CompleteAdmHandle(){
	var frm = dhcsys_getmenuform();
	var EpisodeID=frm.EpisodeID.value;
	var row=$("#tabPatList").datagrid('getSelected');
   	if(row) {
		EpisodeID=row["EpisodeID"];
	}
	if(!EpisodeID){
		$.messager.popover({msg: t['SelectOnePatient'],type:'alert'});
		return false;
	}
	CompleteAdm(EpisodeID);
}
function CompleteAdm(Adm){
	$.m({
		ClassName:"web.DHCDocOutPatientList",
		MethodName:"SetComplate",
		Adm:Adm,
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID']
	},function(rtn){
		if (rtn!="0"){
			$.messager.alert("提示",rtn.split("^")[1]);
			return false;
		}else{
			$.messager.popover({msg: "完成接诊成功",type:'success'});
			LoadOutPatientDataGrid();
		}
	});
}
function PatTransfer(){
	var row=$("#tabPatList").datagrid('getSelected');
	if (!row) {
		$.messager.popover({msg: t['SelectOnePatient'],type:'alert'});
		return false;
	}
	var EpisodeID=row["EpisodeID"];
	var Status=$.cm({ 
		ClassName:"web.DHCDocTransfer",
		MethodName:"GetQueStatusByAdm", 
		Adm:EpisodeID,
		dataType:"text"
	},false);	
	if(Status=="到达"){
		$.messager.alert("提示","已就诊患者不能转诊!");
		return false;
	}else if(Status=="报到"){
		$.messager.alert("提示","未报到患者不能转诊!");
		return false;
	}
	websys_showModal({
		iconCls:'icon-w-update',
		url:"opdoc.transfer.hui.csp?EpisodeID=" + EpisodeID,
		title:$g('转诊'),
		width:300,height:195,
		LoadOutPatientDataGrid:LoadOutPatientDataGrid
	});
}
//取消接诊
function CancelAdmiss(EpisodeID){
	var row=$("#tabPatList").datagrid('getSelected');
	if (!row) {
		$.messager.popover({msg: t['SelectOnePatient'],type:'alert'});
		return false;
	}
	var EpisodeID=row.EpisodeID;
	if(!EpisodeID)return false;
	$.cm({ 
		ClassName:"web.DHCDocOutPatientList",
		MethodName:"CancelAdmiss", 
		Adm:EpisodeID,
		DocDr:ServerObj.DoctorID,
		dataType:"text"
	},function(stat){
		if (stat!='0'){
			var message=""
			if (stat=="NoToday"){message="只能取消当日就诊的接诊!"}
			else if (stat=="AddMark"){message="加号患者不能取消接诊!"}
			else if (stat=="diagnos"){message="患者已经录入诊断或者存在有效的医嘱不可取消接诊!"}
			else if (stat=="NoAdmiss"){message="未接诊的就诊不能取消!"}
			else if (stat=="NoSelf"){message="只能取消本人接诊的就诊记录!"}
			else if (stat=="InsertFail"){message="队列表记录更新失败."}
			else if (stat=="UpdateAdmDocFail"){message="更新就诊科室与医生失败!"}
			else if (stat=="NoInitData"){message="未得到接诊状态改变记录!"}
			else {message="取消接诊失败,"+stat}
			$.messager.alert("提示",message);
			return false;
		}else{
			$.messager.popover({msg: "取消接诊成功",type:'success'});
			LoadOutPatientDataGrid();
		}
	});
}
//报到
function PatArrive(){
	var row=$("#tabPatList").datagrid('getSelected');
	if (!row) {
		$.messager.popover({msg: t['SelectOnePatient'],type:'alert'});
		return false;
	}
	var QueRowId=row.QueRowId;
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"PatArrive",
		dataType:"text",
		itmjs:"PatArriveToHUI", itmjsex:"", QueID:QueRowId,UserID:session['LOGON.USERID'],GroupID:session['LOGON.GROUPID']
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("提示","报到失败!"+rtn);
		}else{
			LoadOutPatientDataGrid();
		}
	})
}
function refundHandler(){
	var row=$("#tabPatList").datagrid('getSelected');
	var EpisodeID=row?row.EpisodeID:'';
	var src='dhcbill.opbill.refrequest.csp?EpisodeID='+EpisodeID;
	 websys_showModal({
		 url:src,
		 title:$g('退费申请'),
		 width:'97%',height:'95%'
	});
 }
 function ShowPatInfo(EpisodeID){
	$.get("opdoc.patientbasicinfo.csp"+((typeof websys_getMWToken=='function')?("?MWToken="+websys_getMWToken()):""),function(data){
		ShowHISUIWindow({
			width:630,
			height:'auto',
			iconCls:'icon-w-eye',
			title:$g('患者基本信息'),
			content:data
		});
		InitPatInfo(EpisodeID);
	},'html');
}
//hisui弹窗 支持对象类型传参(参数按hisui window)，推荐使用基础平台的websys_showModal
function ShowHISUIWindow(title,src,iconCls,width,height)
{
    if(!width) width=900;
    if(!height) height=500;
    if(!$('#_HUI_Model_Win').size()){
        $("body").append("<div id='_HUI_Model_Win' class='hisui-window' style='overflow:hidden;'></div>");
    }
    if((arguments.length==1)&&(typeof arguments[0]=='object')){
        if(typeof websys_writeMWToken=='function') arguments[0].src=websys_writeMWToken(arguments[0].src);
        var opts=$.extend({
            width:width,
            height:height,
            collapsible:false,
            maximizable:false,
            minimizable:false,
            modal:true,
            content:"<iframe width='100%' height='100%' frameborder='0' src='"+arguments[0].src+"'></iframe>"
        },arguments[0]);
    }else{
        if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
        var opts={
            iconCls:iconCls,
            width:width,
            height:height,
            title:title,
            collapsible:false,
            maximizable:false,
            minimizable:false,
            modal:true,
            content:"<iframe width='100%' height='100%' frameborder='0' src='"+src+"'></iframe>"
        };
    }
    return $('#_HUI_Model_Win').window(opts).window('center');
}
function InitPatInfo(EpisodeID){
	$.m({
	    ClassName:"DHCDoc.OPDoc.AjaxPatientAgentInfor",
	    MethodName:"NurPatInfo",
	    EpisodeID:EpisodeID
	},function(val){
		var PatInfoArr = val.split("^");
		$("#patno").val(PatInfoArr[4]);
		$("#patname").val(PatInfoArr[0]);
		$("#Age").val(PatInfoArr[2]);
		$("#Sex").val(PatInfoArr[1]);
		$("#National").val(PatInfoArr[16]);
		$("#Address").val(PatInfoArr[13]);
		$("#lxman").val(PatInfoArr[17]);
		$("#homtel").val(PatInfoArr[14]);
		//加入图片base64应用
		var PhotoInfo=PatInfoArr[20];
		if (PhotoInfo){
			var src="data:image/png;base64,"+PhotoInfo;
		}else{
			var src="../images/uiimages/patdefault.png";
		}
		$('#imgPic').attr('src',src);
		var TranLateStr="patno^patname^Age^Sex^National^Address^lxman^homtel"
		var TranLateArr=TranLateStr.split("^")
		for (var j=0; j< TranLateArr.length; j++){
			var domId = TranLateArr[j];
			if (domId == "") {
				continue;
			}
			var _$label =$("td[for="+domId+"]");
			if (_$label.length > 0){
			   domName = _$label[0].innerHTML;
			    _$label[0].innerHTML=$g(domName);
			}
			}
	});
}
function CheckAdmDate(AdmDate)	{
	var ToDay= new Date();
	var Year=ToDay.getFullYear();
	var Month=ToDay.getMonth();
	Month=Month+1;
	if (Month<10) {Month='0'+Month;}
	var Day=ToDay.getDate();
	if (Day<10) Day='0'+Day;
	if (dtformat=="DMY"){
		var StrDate=Day+'/'+Month+'/'+Year
	}else{
		var StrDate=Year+'-'+Month+'-'+Day
	}
	if (StrDate==AdmDate) {return true}
	else  {return false;}	
}
function ShowEditWin(){
	$("#EditWin").window("open").window('center');
	InitScheduleListDataGrid();
}
function InitScheduleListDataGrid(){
	var columns=[[
			{field:'ASRowId',hidden:true},
			{field:'LocDesc',title:'出诊科室',width:150,sortable:true},
			{field:'DocDesc',title:'出诊医生',width:100,sortable:true},
            {field:'ASRoom',title:'诊室名称',width:120,sortable:true},
			{field:'ASSessionType',title:'职称',width:100,sortable:true},
			{field:'TimeRange',title:'时段',width:60,sortable:true},
			{field:'ASAddLoad',title:'加号限额',width:70,
				editor:{type:'numberbox',options:{min:0,max:9999,precision:0}}
			},
			{field:'ASLoad',title:'挂号限额',width:70},
			{field:'QueueNO',title:'剩号',width:60},
			{field:'ASAppLoad',title:'预约限额',width:70},
			{field:'AppStartSeqNo',title:'预约起始号',width:80},
			{field:'ASSessStartTime',title:'开始时间',width:70},
			{field:'ASSessionEndTime',title:'结束时间',width:70},
			{field:'ASQueueNoCount',title:'合计限额',width:70},
			{field:'RegisterNum',title:'已挂号数',width:70},
			{field:'AppedNum',title:'已预约数',width:70,},
			{field:'AppedArriveNum',title:'已取号数',width:60},
			{field:'StopRegFlag',title:'停止挂号',width:70,},
			{field:'ASStatus',title:'状态',width:40,sortable:true},
			{field:'ReferralUser',title:'替诊人',width:80}
		]];	
	$("#tabScheduleList").datagrid({
		border : false,
		singleSelect : true,
		fitColumns : false,
		autoSizeColumn : false,
		idField:'ASRowId',
		columns :columns,
		onBeforeLoad:function(param){
			$.extend(param,{
				ClassName:"web.DHCApptScheduleNew",
				QueryName:"ApptScheduleRegDoc",
				Loc:session['LOGON.CTLOCID'],
				HospId:session['LOGON.HOSPID'],
				Doc:ServerObj.DoctorID,
				StDate:ServerObj.CurrentDate,
				EnDate:ServerObj.CurrentDate
			});
		},
		onLoadSuccess:function(data){
			for(var i=0;i<data.rows.length;i++){
				$(this).datagrid('beginEdit',i);
			}
		},
		onBeginEdit:function(index, row){
			var ed=$(this).datagrid('getEditor',{index:index,field:'ASAddLoad'});
			$(ed.target).focus(function(){
				$(this).select();
			});
		}
	});
}
function ChangeAddNumClick(){
	var rows=$("#tabScheduleList").datagrid('getEditRows');
	if(!rows.length){
		$.messager.popover({msg:'今日没有排班',type:'alert'});
		return;
	}
	var retObj=$.cm({
		ClassName:"web.DHCRBApptSchedule", 
		MethodName:"UpdateMulScheduleAddNum",
		InputStr:JSON.stringify(rows)
	},false);
	if(retObj.code==0){
		$.messager.popover({msg:retObj.msg,type:'success'});
		$("#tabScheduleList").datagrid('reload');	
	}else{
		$.messager.alert("提示",retObj.msg,"info");
	}
}
function PAAdmReMarkShow(EpsiodeID,PAPMIName){
	IsCellCheckFlag=true;
	 websys_showModal({
			url:"dhcdocadmremark.csp?EpisodeID="+EpsiodeID,
			title:PAPMIName+':'+$g('医生便签'),
			width:300,height:220,
			ChangePAAdmReMark:ChangePAAdmReMark
	});
	setTimeout(function(){
		IsCellCheckFlag=false;
	})
}
function ChangePAAdmReMark(Text){
	LoadOutPatientDataGrid();
}
function PanelOnResize()
{
	$('#layoutCond').layout('resize');
	if(parent.$('#PatListWin').size()){
		var maximized=parent.$('#PatListWin').window('options').maximized;
		$('.body-back').css('background',maximized?'#F5F5F5':'#fff');
	}
}
function SuspendRecentWin(){
	 websys_showModal({
			url:"opdoc.suspendrecent.hui.csp?PersonFlag=Y&InitDocID="+ServerObj.DoctorID+"&InitLocID="+session['LOGON.CTLOCID'],
			title:$g('医生暂时离开'),
			width:320,height:250,
			iconCls:'icon-w-update',
	});
}

//双屏应用
function ShowSecondeWin(rowData){
	var MainSreenFlag=websys_getAppScreenIndex();
    if (MainSreenFlag==0){
	    var Flag="onSelectIPPatient"
	    var Obj={PatientID:rowData.PatientID,EpisodeID:rowData.EpisodeID,mradm:rowData.mradm};
    	if (rowData.WalkStatus=="到达"){
	    	Flag="onOpenDHCDoc"
	    	//var CSPLink="opdoc.treatprint.csp?EpisodeID=1911&PatientID=62&mradm=1911"
	    	var CSPLink=rewriteUrl("opdoc.treatprint.csp",Obj)		
	    	var frameurl=CSPLink.replace(/&/g,"!@")		//基础平台需解决&符号传值
			websys_emit(Flag,{title:"总览打印",frameurl:frameurl});
    	}else{
			websys_emit(Flag,Obj);
    	}
    }
}

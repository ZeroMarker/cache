/**
 * 名称:	 处方点评-点评住院医嘱
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-14
 */
PHA_COM.App.Csp = "pha.prc.v2.comment.ipmain.csp";
PHA_COM.App.Name = "PRC.Comment.Main";
PHA_COM.App.Load = "";
var EpisodeId="";
var LoadAdmId="";
var logonLocId = session['LOGON.CTLOCID'] ;
var logonUserId = session['LOGON.USERID'] ;
var logonGrpId = session['LOGON.GROUPID'] ;
var loadWayId = gLoadWayID		//加载点评单对应的点评方式
var loadPcntId = gLoadPcntID ;
var longoninfo = logonGrpId + "^" + logonLocId + "^" + logonUserId ;
$(function () {
	InitGridIPMain();
    InitGridOrdDetail();			
    InitGridLog();
    InitGridAllLog();
    InitSetPatInfo("I");
	
    InitDiagReason("IP");	// 不合理原因窗口
    InitFindNoDialog({type: "IP", callback: LoadCommentNo});		// 查单窗口
	
    $("#btnFind").on("click", function () {
		ShowDiagFindNo();
	});
	$("#btnLog").on("click", function () {
		ShowDiagLog(this)
	});
	$("#btnAllLog").on("click", function () {
		ShowDiagAllLog(this)
	});
	$("#btnSearch").on("click", function () {
		SearchComments()
	});
	$("#btnSelect").on("click", function () {
		SelectCommentItms()
	});
	$("#btnDelete").on("click", function () {
		DeleteComment()
	});
	$("#btnSubmit").on("click", function () {
		SubmitComment()
	});
	//点评通过(合理)
	$("#btnPass").on("click", function () {
		CommentOK()
	});
	//点评不通过(不合理)
	$("#btnRefuse").on("click", function () {
		ShowDiagUnreason(this) ;
	});
	// 用药分析
	$("#btnAnaly").on("click", function () {
		OrderAnalyse()
	});
	
	$("#tabsForm").tabs({
        onSelect: function(title) {
	        var gridSelect = $("#gridIPMain").datagrid("getSelected");
			if (gridSelect==null){
				$.messager.alert('提示',"请先选中需要查看的病历!","info");
				return;
			}
			var EpisodeId = gridSelect.adm;
		    // 这不常用,每次tk下没事
		    var admData=tkMakeServerCall("web.DHCSTPIVAS.Common","GetAdmInfo",EpisodeId);
		    var patId=admData.toString().split("^")[0]||"";

			/* MaYuqiang 20220517 将患者信息传至头菜单，避免引用界面串患者 */
			var menuWin = websys_getMenuWin();  // 获得头菜单Window对象
			if (menuWin){		
				var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
				if((frm) &&(frm.EpisodeID.value != EpisodeId)){
					if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails();  //清除头菜单上所有病人相关信息
					frm.EpisodeID.value = EpisodeId; 
					frm.PatientID.value = patId;
				}
			}
			if(title==="医嘱明细"){
				QueryAdmOrdDetail() ;	
			}else if (title=="病历浏览"){
		        if ($('#ifrmEMR').attr('src')==""||"undefined"){
                    var fixUrl = 'websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&SwitchSysPat=N' + "&MWToken="+websys_getMWToken();
                	$('#ifrmEMR').attr('src', fixUrl + '&EpisodeID=' + EpisodeId);
		        } 
		    }
        }
    });  
    if (loadPcntId === ""){
		setTimeout(function(){
			ShowDiagFindNo();
		}, 500);
    }
});

// 表格-点评处方
function InitGridIPMain() {
	var columns = [
        [
            { field: "patNo", title: '登记号' ,width: 120},
            { field: "patName", title: '姓名' ,width: 100},
            { field: "sexDesc", title: '性别',width: 120, hidden: true},
            { field: 'patAge', title: '年龄', width: 200, hidden: true},
            { field: "typeDesc", title: '费别' ,width: 120, hidden: true},
            { field: "diag", title: '诊断', width: 100,hidden: true },
            { field: 'curret', title: '结果', width: 100},
            { field: 'oriCurret', title: '初评结果', width: 80, hidden: true},
            { field: "doclocDesc", title: '科室' ,width: 120, hidden: true},
            { field: "adm", title: 'adm',width: 120 , hidden: true},
            { field: "wayCode", title: 'waycode',width: 100, hidden: true },
            { field: "pcntItm", title: '点评明细id',width: 120, hidden: true},
            { field: "papmi", title: 'papmi', width: 100,hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectCommentItms',
            pcntId: loadPcntId || '' ,
            comResult: '',
            phaUserId: ''
        },
        columns: columns,
        toolbar: "#gridIPMainBar",
        onClickRow:function(rowIndex,rowData){
	        var EpisodeId = rowData.adm ;
			LoadPatInfo(rowData);

			var tab = $('#tabsForm').tabs('getSelected');
			var index = $('#tabsForm').tabs('getTabIndex',tab);
			if (index==0){			//医嘱明细
				QueryAdmOrdDetail() ;			
			}else if (index==1){	//病历浏览
				var fixUrl = 'websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&SwitchSysPat=N'+ "&MWToken="+ websys_getMWToken();
                $('#ifrmEMR').attr('src', fixUrl + '&EpisodeID=' + EpisodeId);
			}
		}  
    }; 

    PHA.Grid("gridIPMain", dataGridOption);
}
function InitGridOrdDetail() {
    var columns = [
        [
            { field: "analysisResult", title: '合理用药',width: 80,align: 'center',formatter: druguseFormatter },
			{ field: "orderResult", title: '点评结果',width: 110,align: 'center', 
				styler: function (value, row, index) {
					if ((row.orderResult.indexOf("不通过")>-1)||(row.orderResult.indexOf("不合")>-1)) {
                        return 'background-color:#EE4F38;color:white;';
                    }
				}
			},
			{ field: "oriOrderResult", title: '初次点评结果',width: 110,align: 'center', hidden :true,
				styler: function (value, row, index) {
					if (row.oriOrderResult.indexOf("不合")>-1) {
                        return 'background-color:#EE4F38;color:white;';
                    }
				}
			},
			{ field: "oeoriSign", title: '组',width: 30 },
            { field: "arcimdesc", title: '医嘱名称',align: 'left',width: 200 },
            { field: "qty", title: '数量',align: 'left',width: 50 },
            { field: "uomdesc", title: '单位',align: 'left',width: 50 },
            { field: "dosage", title: '剂量',align: 'left',width: 50 },
            { field: "freq", title: '频次',align: 'left',width: 50 },
            { field: "instruc", title: '用法',align: 'left',width: 80 },
            { field: "form", title: '剂型',width: 80 },
            { field: "priorty", title: '医嘱优先级',align: 'left',width: 100 },
            { field: "basflag", title: '基本药物',align: 'left',width: 60 },
            { field: "doctor", title: '医生',width: 60 },
            { field: "orddate", title: '医嘱开单日期',align: 'left',width: 150 },
            { field: "remark", title: '医嘱备注',align: 'left',width: 120 },
            { field: "orditm", title: 'orditem',width: 120,align: 'left',hidden:false },
            { field: "prescno", title: 'prescno',width: 120,align: 'left',hidden:true },
			{ field: "analysisData", title: '分析返回值' ,width: 120, align: 'left',hidden: true},
            { field: "colorflag", title: 'colorflag',width: 120,align: 'left',hidden:true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.IPMain',
            QueryName: 'SelectAdmOrderDetail',
			pcntsitm: '' ,
			adm:''
        },
        columns: columns,
        toolbar: "#gridOrderBar",
        onClickRow:function(rowIndex,rowData){
	        if (rowData){
	        	var prescNo = rowData.prescno ;
			}   
		},
		onRowContextMenu: rightClickYDTSFn ,
		rowStyler: function(rowIndex, rowData) {        
            var colorflag=rowData.colorflag;
            var colorStyle="";
            if (colorflag==1){	// 按成组的背景色
				//colorStyle="background-color:pink";
            }
            return colorStyle;	
            
        },
        onClickCell: function (rowIndex, field, value) {
			var rows = $(this).datagrid('getRows');
			var rowData = rows[rowIndex];
            if (field != "analysisResult") {
                return
            }
            var content = rowData.analysisData;
            DHCSTPHCMPASS.AnalysisTips({
                Content: content
            })
        }
    };
    PHA.Grid("gridOrder", dataGridOption);
}

function InitGridLog() {
    var columns = [
        [
            { field: "grpNo", title: '组号',width: 40 },
            { field: 'reasonDesc', title: '点评原因', width: 250,
            	formatter:function(v){
					return v.replace('└──','<span style="color:#999999">└──</span>')
				}
			},
            { field: 'pcntDate', title: '点评日期', width: 100},
            { field: "pcntTime", title: '点评时间', width: 80 },
            { field: "pcntUser", title: '点评人' ,width: 80},
            { field: "pcntResult", title: '点评结果',width: 80 },
            { field: 'pcntFactor', title: '不合理警示值', width: 150},
            { field: "pcntAdvice", title: '药师建议' ,width: 150},
			{ field: "pcntNote", title: '药师备注' ,width: 150},
			{ field: "pcntDocNote", title: '医生备注' ,width: 150},
			{ field: "reSaveFlag", title: '二次点评',width: 70 },
			{ field: "pcntActive", title: '有效状态' ,width: 80}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.IPMain',
            QueryName: 'SelectCommentLog',
			pcntItmId: '',
			orditem: ''
        },      
        columns: columns,
        toolbar: null,
        border:true,
        bodyCls:'panel-header-gray',
        onClickRow:function(rowIndex,rowData){
	         
		}   
    };
	PHA.Grid("gridLog", dataGridOption);
}

function InitGridAllLog() {
    var columns = [
        [
            { field: "grpNo", title: '组号',width: 40 },
            { field: 'reasonDesc', title: '点评原因', width: 250,
            	formatter:function(v){
					return v.replace('└──','<span style="color:#999999">└──</span>')
				}
			},
            { field: 'pcntDate', title: '点评日期', width: 100},
            { field: "pcntTime", title: '点评时间', width: 80 },
            { field: "pcntUser", title: '点评人' ,width: 80},
            { field: "pcntResult", title: '点评结果',width: 80 },
            { field: 'pcntFactor', title: '不合理警示值', width: 150},
            { field: "pcntAdvice", title: '药师建议' ,width: 150},
			{ field: "pcntNote", title: '药师备注' ,width: 150},
			{ field: "pcntDocNote", title: '医生备注' ,width: 150},
			{ field: "reSaveFlag", title: '二次点评',width: 70 },
			{ field: "pcntActive", title: '有效状态' ,width: 80}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.IPMain',
            QueryName: 'SelectCommentAllLog',
			pcntItmId: ''
        },      
        columns: columns,
        toolbar: null,
        border:true,
        bodyCls:'panel-header-gray',
        onClickRow:function(rowIndex,rowData){
	         
		}   
    };
	PHA.Grid("gridAllLog", dataGridOption);
}

function ShowDiagUnreason(btnOpt) {
	var itmGridSelect = $("#gridOrder").datagrid("getSelected");
	if (itmGridSelect==null){
		PHA.Popover({ msg: "请先选中医嘱!", type: 'alert'});	
		return false;
	}	
	var orditm = itmGridSelect.orditm ;		
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		PHA.Popover({ msg: "请先选中需要点评的病历!", type: 'alert'});
		return false;
	}
	//获取点评权限
	var pcntsItm = gridSelect.pcntItm ;		//点评子表id
	var pcntsAuth = tkMakeServerCall("PHA.PRC.Create.Main","ChkItmComAuth", longoninfo, pcntsItm)			
	if (pcntsAuth !== "1"){
		var pcntsAuthData = pcntsAuth.split("^")
		$.messager.alert('提示',pcntsAuthData[1],"info");
		return false;
	}
	showDialogSelectReason(orditm, pcntsItm, SaveIPCommentResult);
}

function ShowDiagLog(btnOpt) {
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要点评的病历!","info");
		return;
	}
	var pcntItm = gridSelect.pcntItm ;
	var itmGridSelect = $("#gridOrder").datagrid("getSelected");
	if (itmGridSelect==null){
		$.messager.alert('提示',"请先选中医嘱!","info");
		return ;
	}	
	var orditem = itmGridSelect.orditm ;		//医嘱id
	$('#diagLog').dialog({
		title: "日志" ,
		iconCls:  'icon-w-paper' ,
		modal: true,
		width: $('body').width() - 40,
		height: $('body').height() * 0.8
	})
	$('#diagLog').dialog('open');
	$('#gridLog').datagrid('query', {
        pcntItmId: pcntItm,
		orditem: orditem
    });
}

function ShowDiagAllLog(btnOpt) {
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要点评的病历!","info");
		return;
	}
	var pcntItm = gridSelect.pcntItm ;
	
	$('#diagAllLog').dialog({
		title: "全部日志" ,
		iconCls:  'icon-w-paper' ,
		modal: true,
		width: $('body').width() - 40,
		height: $('body').height() * 0.8
	})
	
	$('#diagAllLog').dialog('open');
	$('#gridAllLog').datagrid('query', {
        pcntItmId: pcntItm
    });
}

///获取就诊医嘱明细信息
function QueryAdmOrdDetail() {
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要查看的就诊信息!","info");
		return;
	}
	var adm = gridSelect.adm;
	var pcntsitm = gridSelect.pcntItm ;
    $('#gridOrder').datagrid('query', {
		pcntsitm: pcntsitm,
        adm: adm
    });
}

function CommentOK(){
	var gridSelect = $("#gridIPMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要点评的病历!","info");
		return;
	}
	var pcntItm = gridSelect.pcntItm ;
	var itmGridSelect = $("#gridOrder").datagrid("getSelected");
	if (itmGridSelect==null){
		var orditm = "" ;
	}else {
		var orditm = itmGridSelect.orditm ;		//医嘱id
	}	
	var result = "Y"
	var reasonstr = ""
	var remarkStr = ""
	var otherstr = orditm	
	SaveIPCommentResult(pcntItm, result, longoninfo, reasonstr, remarkStr, otherstr) ;
}

// 医嘱点评保存结果
function SaveIPCommentResult(pcntItm, result, longoninfo, reasonIdStr, remarkStr, otherstr){
	var OKRet = $.cm({
		ClassName: 'PHA.PRC.Create.IPMain',
		MethodName: 'SaveComItmResult',
		pcntItm: pcntItm,
		result: result,
		longoninfo: longoninfo,
		reasonstr: reasonIdStr,
		input: remarkStr ,
		otherstr: otherstr ,			
		dataType: 'text'
	}, false);
	var RetArr = OKRet.split('^');
	var RetVal = RetArr[0];
	var RetInfo = RetArr[1];	
	if (RetVal < 0) {
		PHA.Alert('提示', RetInfo, 'warning');
		return;
	}else{
		var gridSelect = $("#gridIPMain").datagrid("getSelected");
		var seqNo = $('#gridIPMain').datagrid('getRowIndex',gridSelect);
		var $gridOrder = $("#gridOrder");
		var selectedOrder = $gridOrder.datagrid('getSelected');
		var tmpOeori = selectedOrder? selectedOrder.orditm : "";
		var orderRows = $gridOrder.datagrid("getRows");
		var resultFlag = result;
		if((tmpOeori === "")&&(result === "Y")){
			resultFlag = "Y";
		}else{
			for (var i = 0; i < orderRows.length; i++){
				if(orderRows[i].orditm === tmpOeori){
					continue;
				}			
				if ((orderRows[i].orderResult.indexOf("不通过")>-1)||(orderRows[i].orderResult.indexOf("不合")>-1)) {
					resultFlag = "N";		
	                break;
	            }
			}
		}
		if (resultFlag === "N"){
			if(FindNoDialog.loadWayCode == "RE"){
				var ResultDesc = $g("不通过");	
			}else{
				var ResultDesc = $g("不合理");	
			}	
		} else if (resultFlag === "Y") {
			if(FindNoDialog.loadWayCode == "RE"){
				var ResultDesc = $g("通过");	
			}else{
				var ResultDesc = $g("合理");
			}
		} else {
			var ResultDesc = "";		
		}
		$("#gridIPMain").datagrid('updateRow', {
			index: seqNo,
			row: { curret: ResultDesc }
		}) 
		$gridOrder.datagrid("reload");		
	}		
}

// 查询点评单回调函数，选择点评单时更新主界面数据
function LoadCommentNo(param){
	ClearCommentGrid();
	$('#gridIPMain').datagrid('clear');	
	if (param.loadWayCode == "RE"){
		$('#gridIPMain').datagrid('showColumn', 'oriCurret');
		$('#gridIPMain').datagrid('getColumnOption', 'patNo').width = 110;
		$('#gridIPMain').datagrid('getColumnOption', 'patName').width = 100;	
		$('#btnPass').linkbutton({text:'通过'});
		$('#btnRefuse').linkbutton({text:'不通过'});
	}else{
		$('#gridIPMain').datagrid('hideColumn', 'oriCurret');
		$('#gridIPMain').datagrid('getColumnOption', 'patNo').width = 140;
		$('#gridIPMain').datagrid('getColumnOption', 'patName').width = 140;
		$('#btnPass').linkbutton({text:'合理'});
		$('#btnRefuse').linkbutton({text:'不合理'});
	} 
	$('#gridIPMain').datagrid('query', param);	
	$('#gridIPMain').datagrid();
}

function LoadMsgComment(){
	if (gWayCode == "RE"){
		$('#gridIPMain').datagrid('showColumn', 'oriCurret');
		$('#gridIPMain').datagrid('getColumnOption', 'patNo').width = 110;
		$('#gridIPMain').datagrid('getColumnOption', 'patName').width = 100;	
		$('#btnPass').linkbutton({text:'通过'});
		$('#btnRefuse').linkbutton({text:'不通过'});
	}else{
		$('#gridIPMain').datagrid('hideColumn', 'oriCurret');
		$('#gridIPMain').datagrid('getColumnOption', 'patNo').width = 140;
		$('#gridIPMain').datagrid('getColumnOption', 'patName').width = 140;
		$('#btnPass').linkbutton({text:'合理'});
		$('#btnRefuse').linkbutton({text:'不合理'});
	} 
}

function ClearCommentGrid(){
	InitSetPatInfo("I") ;
	$("#gridLog").datagrid("clear");
	$("#gridOrder").datagrid("clear");	
	$('#gridIPMain').datagrid('clear');
}

//处方分析
function OrderAnalyse(){
	var passTypeInfo=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
	if (passTypeInfo==""){
		$.messager.alert('注意',"未设置处方分析接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商!","info");
		return;
	}
	var passTypeData=passTypeInfo.split("^")
	var passType=passTypeData[0];
	if (passType=="DHC"){
		// 东华知识库
		 DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "gridOrder", 
		 	MOeori: "orditm",
		 	PrescNo:"prescno", 
		 	GridType: "EasyUI", 
		 	Field: "analysisResult",
			ResultField: "analysisData"
		 	//CallBack: 
		 });
	}else if (passType=="DT"){
		// 大通
		dhcphaMsgBox.alert("接口尚未开放");
	}else if (passType=="MK"){
		// 美康
		dhcphaMsgBox.alert("接口尚未开放");
		//MKPrescAnalyse(); 
	}else if (passType=="YY"){
		dhcphaMsgBox.alert("接口尚未开放");
	}
}

// 药典提示
function rightClickYDTSFn(e, rowIndex, rowData) {
	var menuId = "PHA_GRID_" + "onRowContextMenu";
	var gridId = this.id;
	e.preventDefault(); //阻止向上冒泡
	if ($("#" + menuId).length > 0) {
		$("#" + menuId).remove();
	}
	var menuHtml =
		'<div id=' + menuId + ' class="hisui-menu" style="width: 150px; display: none;">' +
		'<div id=' + menuId + '_YDTS' + ' data-options="' + "iconCls:'icon-tip'" + '">'+$g("药典提示")+'</div>' +
		'</div>'
	$("body").append(menuHtml);
	$("#" + menuId).menu()
	$("#" + menuId).menu('show', {
		left: e.pageX,
		top: e.pageY
	});
	$("#" + menuId + "_YDTS").on("click", function () {
		var passTypeInfo=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if (passTypeInfo==""){
			PHA.Alert("提示","未设置药典接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商",'warning');
			return;
		}
		var passTypeData=passTypeInfo.split("^")
		var passType=passTypeData[0];
		if (passType=="DHC"){
			// 东华知识库
			var ordGridSelect = $("#gridOrder").datagrid("getSelected");
			if((ordGridSelect=="")||(ordGridSelect==null)){
				PHA.Alert("提示","请先选择需要查看药典提示的明细记录!",'warning');
				return;
			}
			var userInfo = logonUserId + "^" + logonLocId + "^" + logonGrpId;
			var incDesc = ordGridSelect.arcimdesc;
			var selOrdItm = ordGridSelect.orditm
			DHCSTPHCMPASS.MedicineTips({
				Oeori: selOrdItm,
				UserInfo: userInfo,
				IncDesc: incDesc
			})
		}else if (passType=="DT"){
			dhcphaMsgBox.alert("接口尚未开放");
			// 大通
		}else if (passType=="MK"){
			dhcphaMsgBox.alert("接口尚未开放");
			// 美康
			//MKPrescYDTS(selOrdItm) ; 
		}else if (passType=="YY"){
			dhcphaMsgBox.alert("接口尚未开放");
		}		
	})
}

//格式化列
function druguseFormatter(cellvalue, options, rowdata){
	if (cellvalue==undefined){
		cellvalue="";
	}
	/*if (cellvalue!=""){
		var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if(passType.indexOf("^") > -1){
			passType = passType.split("^")[0];	
		}
		if (passType=="DHC"){
			var cellvalue = (cellvalue == 1) ? 0 : 1;
		}
	} */
	var imageid="";
	if (cellvalue=="0"){
		imageid="warning0.gif";
	}else if (cellvalue=="1"){
		imageid="yellowlight.gif";
	}else if (cellvalue=="2"){
		imageid="warning2.gif"
	}
	else if (cellvalue=="3"){
		imageid="warning3.gif"
	}
	else if (cellvalue=="4"){
		imageid="warning4.gif"
	}
	if (imageid==""){
		return cellvalue;
	}
	return '<img src="../scripts/pharmacy/images/'+imageid+'" ></img>'
}
    
/********************** 调用美康合理用药 start   **************************/
//美康处方分析
function MKPrescAnalyse() {
    var rows = $("#gridOrder").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    for (var i = 0; i < rows.length; i++) {
        var prescno = rows[i].prescno;
        myrtn = HLYYPreseCheck(prescno,0); 
        var imgname = "warningnull.gif"
        if (myrtn == 0) { var imgname = "warning0.gif"; }	// 合理
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// 黄灯
        if (myrtn == 2) { var imgname = "warning2.gif"; }	// 
        if (myrtn == 3) { var imgname = "warning3.gif"; }	// 
        if (myrtn == 4) { var imgname = "warning4.gif"; }	// 
        if (imgname == "") { var imgname = myrtn }
        var str = "<img id='analysisResult" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
		$("#gridOrder").datagrid('updateRow', {
			index: i,
			row: {
				analysisResult: str,
				analyResultRet: myrtn
			}
		})
    }
}


function HLYYPreseCheck(prescno,flag){
	var XHZYRetCode=0  //处方检查返回代码
	MKXHZY1(prescno,flag);
	//若为同步处理,取用McPASS.ScreenHighestSlcode
	//若为异步处理,需调用回调函数处理.
	//同步异步为McConfig.js MC_Is_SyncCheck true-同步;false-异步
	XHZYRetCode=McPASS.ScreenHighestSlcode;
	return XHZYRetCode	
}

function MKXHZY1(prescno,flag){
	MCInit1(prescno);
	HisScreenData1(prescno);
	MDC_DoCheck(HIS_dealwithPASSCheck,flag);
}

function MCInit1(prescno) {
	var PrescStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var prescdetail=PrescStr.split("^")
	var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];  
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode ="mzyf"  //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
	if (result > 0) {
        
    } else {
		//alert("没问题");
	}
	return result ;
}


function HisScreenData1(prescno){
	var Orders="";
	var Para1=""
	
	var PrescMStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var PrescMInfo=PrescMStr.split("^")
	var Orders=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
	if (Orders==""){return;}
	var DocName=PrescMInfo[2];
	var EpisodeID=PrescMInfo[5];
	if (EpisodeID==""){return}
	var ret=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",EpisodeID,Orders,DocName);
	var TempArr=ret.split(String.fromCharCode(2));
	var PatInfo=TempArr[0];
	var MedCondInfo=TempArr[1];
	var AllergenInfo=TempArr[2];
	var OrderInfo=TempArr[3];
	var PatArr=PatInfo.split("^");
	
	
	var ppi = new Params_MC_Patient_In();
	ppi.PatCode = PatArr[0];			// 病人编码
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // 住院次数
	ppi.Name = PatArr[1];				// 病人姓名
	ppi.Sex = PatArr[2];				// 性别
	ppi.Birthday = PatArr[3];			// 出生年月
	
	ppi.HeightCM = PatArr[5];			// 身高
	ppi.WeighKG = PatArr[6];			// 体重
	ppi.DeptCode  = PatArr[8];			// 住院科室
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// 医生
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// 使用时间
	ppi.CheckMode = MC_global_CheckMode
	ppi.IsDoSave = 1
	MCpatientInfo  = ppi;
    var arrayDrug = new Array();
	var pri;
  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
  	//alert(OrderInfo)
  	McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++){    
		var OrderArr=OrderInfoArr[i].split("^");
		//传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//药品序号
        drug.OrderNo =OrderArr[0]; 		        		//医嘱号
        drug.DrugUniqueCode = OrderArr[1];  	//药品编码
        drug.DrugName =  OrderArr[2]; 			//药品名称
        drug.DosePerTime = OrderArr[3]; 	   //单次用量
		drug.DoseUnit =OrderArr[4];   	        //给药单位      
        drug.Frequency =OrderArr[5]; 	        //用药频次
        drug.RouteCode = OrderArr[8]; 	   		//给药途径编码
        drug.RouteName = OrderArr[8];   		//给药途径名称
		drug.StartTime = OrderArr[6];			//开嘱时间
        drug.EndTime = OrderArr[7]; 			//停嘱时间
        drug.ExecuteTime = ""; 	   				//执行时间
		drug.GroupTag = OrderArr[10]; 	       //成组标记
        drug.IsTempDrug = OrderArr[11];          //是否临时用药 0-长期 1-临时
        drug.OrderType = 0;    //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //开嘱科室编码
        drug.DeptName =  PrescMInfo[4]; 	  //开嘱科室名称
        drug.DoctorCode =PrescMInfo[6];   //开嘱医生编码
        drug.DoctorName =PrescMInfo[2];     //开嘱医生姓名
		drug.RecipNo = "";            //处方号
        drug.Num = OrderArr[15];                //药品开出数量
        drug.NumUnit = OrderArr[16];            //药品开出数量单位          
        drug.Purpose = 0;             //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
		drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
		drug.Remark = "";             //医嘱备注 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
        
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //序号  
      	allergen.AllerCode = AllergenArr[0];    //编码
      	allergen.AllerName = AllergenArr[1];    //名称  
      	allergen.AllerSymptom =AllergenArr[3]; //过敏症状 
      	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//病生状态类数组
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//诊断序号
     	medcond.DiseaseCode = MedCondArr[0];        //诊断编码
      	medcond.DiseaseName = MedCondArr[1];     //诊断名称
 		medcond.RecipNo = "";              //处方号
      	arrayMedCond[arrayMedCond.length] = medcond;     
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

/// 美康药典提示
function MKPrescYDTS(orditm){
	//alert("orditm:"+orditm)
	var ordInfoStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface","GetOrderMainInfo",orditm)
	//alert("ordInfoStr:"+ordInfoStr)
	var ordInfo = ordInfoStr.split("^")
	var prescNo = ordInfo[10]
	var incicode = ordInfo[8]
	var incidesc = ordInfo[9]
	var cyFlag =  ordInfo[11]		//草药标志
	
	MCInit1(prescNo);
	HisQueryData(incicode,incidesc);
	if (cyFlag == "Y"){
		MDC_DoRefDrug(24)	
	}
	else {
		MDC_DoRefDrug(11)
	}
}

function HisQueryData(incicode,incidesc) {   
    var drug = new Params_MC_queryDrug_In();
    drug.ReferenceCode = incicode; //查询药品的编码
    drug.CodeName =incidesc;  //查询药品的名称           
    MC_global_queryDrug = drug;   //赋值给全局变量
}

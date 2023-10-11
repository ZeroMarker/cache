/**
 * @author liujie
 * @version 20191212
 * @description 病人基本信息打印界面
 * @name nur.patinfoprint.js
 */
var GV = {
    _CALSSNAME: "Nur.HISUI.PatInfoPrint",
	_QueryName: "FindCurWardPat",
	defaultPageSize: 200,
	defaultPageList: [200, 400, 600, 800, 1000],
	lockShortName:{
		"床头卡":[$g("床"),20],
		"新生儿床头卡":[$g("床(新)"),45],
		"成人腕带":[$g("腕(成)"),45],
		"儿童腕带":[$g("腕(儿)"),45],
		"新生儿腕带":[$g("腕(新)"),45]
	}
};
var init = function () {
    initOrdGrid();
}
$(init)
/*----------------------------------------------------------------------------------*/
/**
 * @description 初始化医嘱列表
 */
function initOrdGrid() {
	var toolBars = [];
	toolBars.push({
		iconCls: 'icon-search',
		text: '查询',
		handler: function() {
			ordGridReload();
		}									
	});
	$cm({
		ClassName:"Nur.NIS.Service.OrderExcute.NurPrintBusiness",
		MethodName:"GetPatInfoPrtBtn",
		hospId:session['LOGON.HOSPID'], 
		wardId:session['LOGON.WARDID']
	},function(btnList){
		btnList.forEach(function(item) {
			toolBars.push({
				iconCls: 'icon-print',
				text: item.btnName,
				handler: function() {
					printIntercept(item.formworkId,item.btnName);
				}
			})
		})
		
	var columns=[[
			{ field: 'checkCol', title: '选择', checkbox: true, width: 30 },
			{ field: 'episodeID', title: '就诊号', width: 30, hidden: true },
            { field: 'bedCode', title: '床号', width: 80 },
            { field: 'patName', title: '姓名', width: 100 },
			{ field: 'locks', title: '锁标记', width: 200,
				formatter: function (val, row, index) {
					var htmlStr = ""
					//图标处理
					var tempObj={}
					row["patPrtInfo"].split("^").forEach(function(item) {
						tempObj[item.split("@")[0]]=item.split("@")[1]
					});
					btnList.forEach(function(item){
						if (tempObj[item.formworkId] === "Y" ){
							htmlStr += "<span title='"+$g(item.btnName)+$g("打印已锁")+"'><a style=' background-color:#FF7965;display:inline-block;border-radius:4px;width:"+ GV.lockShortName[item.btnName][1] +"px;height:20px;text-align:center;margin-left:1px'><span style='color:#FFF;font-size:14px;text-align:center;'>"+ GV.lockShortName[item.btnName][0] +"</span></a></span>";							
						}

					})
					return htmlStr;
				}
			},
            { field: 'medicareNo', title: '住院号', width: 100 },
            { field: 'regNo', title: '登记号', width: 100 },
            { field: 'age', title: '年龄', width: 80 },
            { field: 'sex', title: '性别', width: 80 },
            { field: 'admDateTime', title: '入院时间', width: 150 },
			{ field: 'bedCardLock', title: '床头卡锁', width: 30, hidden: true },
			{ field: 'WDLock', title: '腕带锁', width: 30, hidden: true },
        ]];
    $('#patGrid').datagrid({
		url: $URL,
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: GV._QueryName,
            ResultSetType: 'array',
            wardId: session['LOGON.WARDID'],
			locId: session['LOGON.CTLOCID']
        },
		autoSizeColumn: false,
		fit: true,
		fitColumns: false,
		showFooter: false,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageSize: GV.defaultPageSize,
		pageList: GV.defaultPageList,
		toolbar: toolBars,
        columns: columns,
        idField: 'episodeID',
	});		
	})
}
function printIntercept(printFormworkID,btnName) {
	var selectArray = $('#patGrid').datagrid('getSelections');
    
    var formwork=$cm({
		ClassName:"Nur.NIS.Service.OrderExcute.XMLPrint",
		MethodName:"GetFormwork",
		sheetID: printFormworkID
	},false);
	
	var alertInfos=[];
    var admIdArray = selectArray.map(function (row) {
		var tempObj={}
		row["patPrtInfo"].split("^").forEach(function(item) {
			tempObj[item.split("@")[0]]=item.split("@")[1]
		});			
		var episodeID=row.episodeID;
		if(tempObj[printFormworkID] === "Y" && formwork.forbidReprint==="Y" && session['LOGON.GROUPDESC'].indexOf("护士长") === -1) {
			var alertInfo = row.bedCode+" "+row.patName+"，"+ btnName + "已打";
			alertInfos.push(alertInfo);
			return ""
		}else{
			return episodeID
		}
        
    });
   	//去除空元素
	var admIdArray=admIdArray.filter(function(s){
		return s&&s.trim();
	});
	if (admIdArray.length === 0 && alertInfos.length === 0) {
		$.messager.popover({ msg: "请选择患者!", type: 'error', timeout: 2000 });
	}
	if (admIdArray.length>0) {
		$m({
			ClassName:"Nur.NIS.Service.OrderExcute.XMLPrint",
			MethodName:"GetPrintData",
			sheetID: printFormworkID,
			parr: admIdArray.join("@"),
			type: "para"
		},function(paraData){
			console.dir(paraData); 
			$m({
				ClassName:"Nur.NIS.Service.OrderExcute.XMLPrint",
				MethodName:"GetPrintData",
				sheetID: printFormworkID,
				parr: admIdArray.join("@"),
				type: "list"
			},function(listData){
				console.dir(listData); 
				window.NurPrtCommOutSide(formwork, paraData, listData);
				if (formwork.forbidReprint==="Y") {
					$cm({
						ClassName:"Nur.Print.Service.PatInfoPrint",
						MethodName:"InsertPrintLockChunks",	
						admStr:admIdArray.join("^"), 
						wardId: session['LOGON.WARDID'], 
						formworkID:printFormworkID, 
						userId:session['LOGON.USERID']		
					},function(ret){
						if (ret.status === 0) {
							$.messager.popover({msg: "打印加锁成功",type:'success'});
						}else{
							$.messager.popover({msg: ret.errList.join(" "),type:'info'});
						}
						ordGridReload();
					})		
				}
			});
		});	
	}else{
		if(alertInfos.length>0) {
			$.messager.popover({ msg: alertInfos.join('<br />') + "!", type: 'alert', timeout: 2000 });
		}		
	}


}
/**
 * @description 医嘱列表刷新
 */
function ordGridReload() {
	$HUI.datagrid('#patGrid').clearSelections();
	$HUI.datagrid('#patGrid').clearChecked();
    $('#patGrid').datagrid('reload',{
		ClassName: GV._CALSSNAME,
		QueryName: GV._QueryName,
		ResultSetType: 'array',
		wardId: session['LOGON.WARDID'],
		locId: session['LOGON.CTLOCID']
    });
}

function resetWirstPrtFlag() {
	var selectArray = $('#patGrid').datagrid('getSelections');
    var admIdArray = selectArray.map(function (row) {
        return row.episodeID
    })
    if(admIdArray.length>0){
    	var admIds = admIdArray.join('^');
		var groupDesc= session['LOGON.GROUPDESC'];
		var LocId= session['LOGON.CTLOCID'];
		var resetWirstPrtFlag = tkMakeServerCall('Nur.HISUI.PatInfoPrint', 'resetWirstPrtFlag', admIds,groupDesc,LocId);
		if(resetWirstPrtFlag!=0) {
			$.messager.popover({ msg: resetWirstPrtFlag, type: 'alert', timeout: 1500 });
		}
		else {
			$.messager.popover({ msg: "解锁成功", type: 'success', timeout: 1500 });
		}
		ordGridReload();
    }else{
	    $.messager.popover({ msg: '请选择患者!', type: 'alert', timeout: 1500 });
	}
}

function resetBedCardPrtFlag() {
	var selectArray = $('#patGrid').datagrid('getSelections');
    var admIdArray = selectArray.map(function (row) {
        return row.episodeID
    })
    if(admIdArray.length>0){
    	var admIds = admIdArray.join('^');
		var groupDesc= session['LOGON.GROUPDESC'];
		var ctLocId= session['LOGON.CTLOCID'];
		var ret = tkMakeServerCall('Nur.HISUI.PatInfoPrint', 'resetBedCardPrtFlag', admIds, ctLocId, groupDesc);
		if(ret!=0) {
			$.messager.popover({ msg: ret, type: 'alert', timeout: 1500 });
		}
		else {
			$.messager.popover({ msg: "解锁成功", type: 'success', timeout: 1500 });
		}
		ordGridReload();
    }else{
	    $.messager.popover({ msg: '请选择患者!', type: 'alert', timeout: 1500 });
	}
}

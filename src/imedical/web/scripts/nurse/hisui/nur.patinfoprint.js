/**
 * @author liujie
 * @version 20191212
 * @description ���˻�����Ϣ��ӡ����
 * @name nur.patinfoprint.js
 */
var GV = {
    _CALSSNAME: "Nur.HISUI.PatInfoPrint",
	_QueryName: "FindCurWardPat",
	defaultPageSize: 200,
	defaultPageList: [200, 400, 600, 800, 1000],
	lockShortName:{
		"��ͷ��":[$g("��"),20],
		"��������ͷ��":[$g("��(��)"),45],
		"�������":[$g("��(��)"),45],
		"��ͯ���":[$g("��(��)"),45],
		"���������":[$g("��(��)"),45]
	}
};
var init = function () {
    initOrdGrid();
}
$(init)
/*----------------------------------------------------------------------------------*/
/**
 * @description ��ʼ��ҽ���б�
 */
function initOrdGrid() {
	var toolBars = [];
	toolBars.push({
		iconCls: 'icon-search',
		text: '��ѯ',
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
			{ field: 'checkCol', title: 'ѡ��', checkbox: true, width: 30 },
			{ field: 'episodeID', title: '�����', width: 30, hidden: true },
            { field: 'bedCode', title: '����', width: 80 },
            { field: 'patName', title: '����', width: 100 },
			{ field: 'locks', title: '�����', width: 200,
				formatter: function (val, row, index) {
					var htmlStr = ""
					//ͼ�괦��
					var tempObj={}
					row["patPrtInfo"].split("^").forEach(function(item) {
						tempObj[item.split("@")[0]]=item.split("@")[1]
					});
					btnList.forEach(function(item){
						if (tempObj[item.formworkId] === "Y" ){
							htmlStr += "<span title='"+$g(item.btnName)+$g("��ӡ����")+"'><a style=' background-color:#FF7965;display:inline-block;border-radius:4px;width:"+ GV.lockShortName[item.btnName][1] +"px;height:20px;text-align:center;margin-left:1px'><span style='color:#FFF;font-size:14px;text-align:center;'>"+ GV.lockShortName[item.btnName][0] +"</span></a></span>";							
						}

					})
					return htmlStr;
				}
			},
            { field: 'medicareNo', title: 'סԺ��', width: 100 },
            { field: 'regNo', title: '�ǼǺ�', width: 100 },
            { field: 'age', title: '����', width: 80 },
            { field: 'sex', title: '�Ա�', width: 80 },
            { field: 'admDateTime', title: '��Ժʱ��', width: 150 },
			{ field: 'bedCardLock', title: '��ͷ����', width: 30, hidden: true },
			{ field: 'WDLock', title: '�����', width: 30, hidden: true },
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
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
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
		if(tempObj[printFormworkID] === "Y" && formwork.forbidReprint==="Y" && session['LOGON.GROUPDESC'].indexOf("��ʿ��") === -1) {
			var alertInfo = row.bedCode+" "+row.patName+"��"+ btnName + "�Ѵ�";
			alertInfos.push(alertInfo);
			return ""
		}else{
			return episodeID
		}
        
    });
   	//ȥ����Ԫ��
	var admIdArray=admIdArray.filter(function(s){
		return s&&s.trim();
	});
	if (admIdArray.length === 0 && alertInfos.length === 0) {
		$.messager.popover({ msg: "��ѡ����!", type: 'error', timeout: 2000 });
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
							$.messager.popover({msg: "��ӡ�����ɹ�",type:'success'});
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
 * @description ҽ���б�ˢ��
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
			$.messager.popover({ msg: "�����ɹ�", type: 'success', timeout: 1500 });
		}
		ordGridReload();
    }else{
	    $.messager.popover({ msg: '��ѡ����!', type: 'alert', timeout: 1500 });
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
			$.messager.popover({ msg: "�����ɹ�", type: 'success', timeout: 1500 });
		}
		ordGridReload();
    }else{
	    $.messager.popover({ msg: '��ѡ����!', type: 'alert', timeout: 1500 });
	}
}

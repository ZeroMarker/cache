$(function() {
    strXml = convertToXml(scheme);
    var interface = $(strXml).find("interface").text();
    var checkstyle = $(strXml).find("checkstyle").text();
    pageConfig = $(strXml).find("pageConfig").text();
    $("#comboxEpisode").hide();
    $("#resourceConfig").hide();
    if (pageConfig == "Y") {
        $("#resourceConfig").show();
        //获取其它资源区的查询按钮配置项数据
        resourceConfig = getResourceConfig();
        var configItem = resourceConfig.Lis;
        if ((configItem != "") && (configItem != undefined)) {
            $('#' + configItem).attr("checked", true);
            if (configItem == "allEpisode") {
                $("#comboxEpisode").show();
            }
        } else {
            $('#currentEpisode').attr("checked", true);
        }
    } else {
		    $('#recentTwice').attr("checked", true);
    }
    initEpisodeList("#EpisodeList");
    setDataGrid(interface, checkstyle);
    $('#seekform').find(':radio').change(function() {
        if (this.id == "allEpisode") {
            $("#comboxEpisode").show();
        } else {
            $("#comboxEpisode").hide();
            queryData();
        }
        if (pageConfig == "Y") {
            resourceConfig.Lis = this.id;
        }
    });

    $('#lisDataPnl').panel('resize', {
        height: $('#dataPnl').height() * 0.60
    });

    $('body').layout('resize');
});

//设置数据
function setDataGrid(interface, checkstyle) {
    var param = getParam();
    if ($('#allEpisode')[0].checked) {
        param.EpisodeID = getAllEpisodeIdByPatientId();
    }
    $('#lisData').datagrid({
        pageSize: 10,
        pageList: [10, 20, 30],
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.lisData.cls?Action=GetLisData&InterFace=' + encodeURI(encodeURI(interface)),
        rownumbers: true,
        pagination: true,
        singleSelect: false,
        queryParams: param,
        idField: 'OEordItemRowID',
        fit: true,
        columns: getColumnScheme("show>parent>item"),
        //sortName: 'AuthorisationDate',
        sortOrder: 'desc',
        remoteSort: false,
        onCheck: function(rowIndex, rowData) {
            var ordItemId = rowData.OEordItemRowID;
            quoteData[ordItemId] = {};
            if (checkstyle == "Multiple") {
                loadMultiSubData();
            } else {
                loadSubData(rowData.EpisodeID, ordItemId, rowData.LabEpisodeNo);
            }
        },
        onUncheck: function(rowIndex, rowData) {
            if (checkstyle == "Multiple") {
                quoteData = {};
                loadMultiSubData();
            } else {
                $('#lisSubData').datagrid('uncheckAll');
                delete quoteData[rowData.OEordItemRowID];
            }
        },
        onCheckAll: function(rows) {
            quoteData = {};
            var length = rows.length;
            if (length == 0) return;
            if (checkstyle == "Multiple") {
                loadMultiSubData();
            } else {
                for (i = 0; i < length; i++) {
                    quoteData[rows[i].OEordItemRowID] = {};
                    loadSubData(rows[i].EpisodeID, rows[i].OEordItemRowID, rows[i].LabEpisodeNo);
                }
            }
        },
        onUncheckAll: function(rows) {
            quoteData = {};
            $('#lisSubData').datagrid('loadData', { total: 0, rows: [] });
        },
        /*liuzhongwan 在加载页面时和默认选择本次就诊时程序连续发送了两个异步ajax请求，当加载时的请求后接收时就显示空表。
        解决方案：给grid添加onBeforeLoad事件，只有在就诊参数不为空时才发送请求，否则不发。
        */
        onBeforeLoad: function(param) {
                if (param.EpisodeID == undefined) return false;
                return true;
            }
            //liuzhongwan end
    });
    $('#lisSubData').datagrid({
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.lisData.cls?Action=GetSubLis&InterFace=' + encodeURI(encodeURI(interface)),
        singleSelect: true,
        rownumbers: true,
        singleSelect: false,
        fit: true,
        columns: getColumnScheme("show>child>item"),
        onCheck: function(rowIndex, rowData) {
            quoteData[rowData.OeordID]["child" + rowIndex] = { "ItemDesc": rowData.ItemDesc, "Synonym": rowData.Synonym, "ItemResult": rowData.ItemResult, "ItemUnit": rowData.ItemUnit, "AbnorFlag": rowData.AbnorFlag, "ItemRanges": rowData.ItemRanges };
        },
        onUncheck: function(rowIndex, rowData) {
            delete quoteData[rowData.OeordID]["child" + rowIndex];
        },
        onCheckAll: function(rows) {
            var length = rows.length;
            if (length <= 0) return;
            if (checkstyle == "Multiple") {
                var ids = $('#lisData').datagrid('getChecked');
                for (var i = 0; i < ids.length; i++) {
                    quoteData[ids[i].OEordItemRowID] = {};
                }
            } else {
                delete quoteData[rows[0].OeordID]
                quoteData[rows[0].OeordID] = {};
            }
            for (i = 0; i < length; i++) {
                quoteData[rows[i].OeordID]["child" + i] = { "ItemDesc": rows[i].ItemDesc, "Synonym": rows[i].Synonym, "ItemResult": rows[i].ItemResult, "ItemUnit": rows[i].ItemUnit, "AbnorFlag": rows[i].AbnorFlag, "ItemRanges": rows[i].ItemRanges };
            }
        },
        onUncheckAll: function(rows) {
            var length = rows.length;
            if (length <= 0) return;
            if (checkstyle == "Multiple") {
                var ids = $('#lisData').datagrid('getChecked');
                for (var i = 0; i < ids.length; i++) {
                    quoteData[ids[i].OEordItemRowID] = {};
                }
            } else {
                quoteData[rows[0].OeordID] = {};
            }
        },
        rowStyler: function(index, row) {
            if ((row.AbnorFlag == "高") ||(row.AbnorFlag == "H")||(row.AbnorFlag == "PH")||(row.AbnorFlag == "↑")||(row.AbnorFlag == "↑↑")||(row.AbnorFlag == "荒诞高值")) {
                return 'color:#FF0000;';
            } else if ((row.AbnorFlag == "低") ||(row.AbnorFlag == "L")||(row.AbnorFlag == "PL")||(row.AbnorFlag == "↓")||(row.AbnorFlag == "↓↓")) {
                return 'color:#0000FF;';
            }
        },
        onLoadSuccess: function(data) { //当表格成功加载时执行               
            var rowData = data.rows;
            $.each(rowData, function(idx, val) { //遍历JSON
                //AbnorFlagCheck检验数据启用异常值默认勾选
                if (AbnorFlagCheck == "N" && val.AbnorFlag != "" && val.AbnorFlag != "正常") {
                    $("#lisSubData").datagrid("selectRow", idx); //选中行
                }
            });
        }
    });
}

///加载子项
function loadSubData(episodeId, oeordId, labEpisodeNo) {
    $('#lisSubData').datagrid('load', {
        Action: 'GetSubLis',
        EpisodeID: episodeId,
        ID: oeordId,
        LabEpisodeNo: labEpisodeNo
    });
}

///加载全选的多个子项
function loadMultiSubData() {
    var ordItemId = "";
    var episodeId = "";
    var labEpisodeNo = ""
    var ids = $('#lisData').datagrid('getChecked');
    for (var i = 0; i < ids.length; i++) {
        quoteData[ids[i].OEordItemRowID] = {};
        if (ordItemId == "") {
            ordItemId = ids[i].OEordItemRowID;
        } else {
            ordItemId = ordItemId + "^" + ids[i].OEordItemRowID;
        }
        if (episodeId == "") {
            episodeId = ids[i].EpisodeID;
        } else {
            episodeId = episodeId + "^" + ids[i].EpisodeID;
        }
        if (labEpisodeNo == "") {
            labEpisodeNo = ids[i].LabEpisodeNo;
        } else {
            labEpisodeNo = labEpisodeNo + "^" + ids[i].LabEpisodeNo;
        }
    }
    $('#lisSubData').datagrid('load', {
        Action: 'GetMultiSubLis',
        EpisodeID: episodeId,
        ID: ordItemId,
        LabEpisodeNo: labEpisodeNo
    });
}

// 查询
function queryData() {
    var param = getParam();
    $('#lisData').datagrid('load', param);
}

//获取查询参数
function getParam() {
    var stDateTime = "",
        endDateTime = "";
    //authStDateTime、authEndDateTime是按审核日期查询的始末条件
    var authStDateTime = "",
        authEndDateTime = "";
    var authorizedFlag = "";
    var epsodeIds = episodeID;
    var dateGap = "";
	if ($('#currentEpisode')[0].checked)
    {
        //本次就诊
        authorizedFlag = 1;
    }else if ($('#recentTwice')[0].checked) {
        epsodeIds = "";
        authorizedFlag = 2;
    }else if ($('#sixMonths')[0].checked) {
        epsodeIds = "";
        dateGap = 180;
    }else //if ($('#allEpisode')[0].checked)
    {
        epsodeIds = "";
        var values = $('#EpisodeList').combogrid('getValues');
        for (var i=0;i< values.length;i++)
        {
            epsodeIds = (i==0)?"":epsodeIds + ",";
            epsodeIds = epsodeIds + values[i];
        }
        authorizedFlag ="";
    }
    var param = {
        EpisodeID: epsodeIds,
        StartDateTime: stDateTime,
        EndDateTime: endDateTime,
        AuthStartDateTime: authStDateTime,
        AuthEndDateTime: authEndDateTime,
        AuthorizedFlag: authorizedFlag,
        PatientID: patientID,
        DateGap: dateGap
        
    };
    return param;
}
//引用数据
function getData() {
    var resultItems = new Array();
    var result = "";
    var parentList = getRefScheme("reference>parent>item");
    var childList = getRefScheme("reference>child>item");
    var separate = $(strXml).find("reference>separate").text();
    separate = (separate == "enter") ? "\n" : separate;
    var quality = $(strXml).find("quality").text();
    var checkedItems = $('#lisData').datagrid('getChecked');
	var param = {"action":"GET_DOCUMENT_CONTEXT"};
	documentContext = parent.eventDispatch(param);
    $.each(checkedItems, function(index, item) {
        if (quality == "1")
		{
			var happenDatetime = documentContext.HappenDateTime;
			var tmpDatetime = item.AuthorisationDate + " "+ item.AuthorisationTime;
			if (compareDateTime(tmpDatetime,happenDatetime))
			{
				alert("审核时间大于病历时间,不能引用");
				return false;
			}
		}
        if (quoteData[item.OEordItemRowID]) {
            //收集父内容
            for (var i = 0; i < parentList.length; i++) {
                result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
            }
            //收集子表内容
            $.each(quoteData[item.OEordItemRowID], function(index, item) {
                for (j = 0; j < childList.length; j++) {
                    if (childList[j].code == "ItemUnit") {
                        var obj = getFormatString(item[childList[j].code]);
                        if (obj != "") {
                            var idx1 = item[childList[j].code].indexOf(obj.subChar1);
                            var idx2 = item[childList[j].code].indexOf(obj.subChar2);
                            if (item[childList[j].code].charAt(0) != "*") {
                               // result = result + "*";
                            }
                            result = result + item[childList[j].code].substring(0, idx1);
                            resultItems.push({ "TEXT": result });
                            resultItems.push({ "STYLE": [obj.Style], "TEXT": item[childList[j].code].substring(idx1 + 1, idx2) });
                            result = item[childList[j].code].substring(idx2);
                        } else {
                            result = result + item[childList[j].code];
                        }
                    } else {
                        result = result + item[childList[j].code];
                    }
                    result = result + childList[j].separate;
                }
            });
            if (checkedItems.length - 1 > index) {
                result = result + separate;
            }
            
	    inputReferenceDataLog(item.EpisodeID,item.OEordItemRowID,item.OEordItemDesc)  
        }
    });
    resultItems.push({ "TEXT": result });
    var param = { "action": "INSERT_STYLE_TEXT_BLOCK", "args": { "items": resultItems } };
    parent.eventDispatch(param);
    UnCheckAll();
}

//判断字符处理
function getFormatString(text) {
    var obj = "";
    $.each(formatStrings, function(index, item) {
        if (text.indexOf(item.string) > -1) {
            obj = item;
            return true;
        }
    });
    return obj;
}

//去掉选择
function UnCheckAll() {
    $("#lisData").datagrid("uncheckAll");
}

//记录用户引用检验数据记录
function inputReferenceDataLog(episodeId,OEordItemRowID,OEordItemDesc)
{
	jQuery.ajax({
			type : "GET",
			dataType : "text",
			url : "../EMRservice.Ajax.lisData.cls",
			async : true,
			data : {
						"Action":"InputReferenceDataLog",
						"EpisodeID":episodeId,
						"OEordItemRowID":OEordItemRowID,
						"OEordItemDesc":OEordItemDesc
					},
			success : function(d) {
					},
			error : function(d) { alert("input ReferenceDataLog error");}
		});	
}

//患者就诊类型
function getEpisodeType(){
	var result = "O"
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.lisData.cls",
		async : false,
		data : {
					"Action":"getEpisodeType",
					"EpisodeID":episodeID
				},
		success : function(d) {
			result =d
			},
		error : function(d) { alert("input ReferenceDataLog error");}
	});
	return result
}
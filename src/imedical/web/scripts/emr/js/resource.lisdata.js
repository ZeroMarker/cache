$(function() {
    strXml = convertToXml(scheme);
    var interface = $(strXml).find("interface").text();
    var checkstyle = $(strXml).find("checkstyle").text();
    pageConfig = $(strXml).find("pageConfig").text();
    var unAudit = $(strXml).find("unAudit").text();
	selectConfig=$(strXml).find("datagridConfig>selectConfig").text();
    if(selectConfig=="Y"){
	     selectOnCheckFlag=false
   		checkOnSelectFlag=false
	}
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
        $('#currentEpisode').attr("checked", true);
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
        height: $('#dataPnl').height() * 0.50
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
		selectOnCheck: selectOnCheckFlag,
        checkOnSelect: checkOnSelectFlag,
        singleSelect: false,
        queryParams: param,
        idField: 'OEordItemRowID',
        fit: true,
        columns: getColumnScheme("show>parent>item"),
        //sortName: 'AuthorisationDate',
        sortOrder: 'desc',
        remoteSort: false,
        onCheck: function(rowIndex, rowData) {
             clickFlag=true;
            onCheckPar(rowIndex, rowData,checkstyle);
         
        },
        onUncheck: function(rowIndex, rowData) {
            onUnCheckPar(rowData,checkstyle);
        },
		onSelect:function(rowIndex, rowData){
	         clickFlag=false;
	         if(selectConfig!="Y")return
	         onCheckPar(rowIndex, rowData,checkstyle);
	    },
        onUnselect:function(rowIndex, rowData) {
	        if(selectConfig=="")return
           	onUnCheckPar(rowData,checkstyle);
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
            quoteData[rowData.OeordID]["child" + rowIndex] = { "ItemDesc": rowData.ItemDesc, "Synonym": rowData.Synonym, "ItemResult": rowData.ItemResult, "ItemUnit": rowData.ItemUnit, "AbnorFlag": rowData.AbnorFlag, "ItemRanges": rowData.ItemRanges, "DetailData": rowData.DetailData, "ReportDR": rowData.ReportDR };
            if ((rowData.DetailData.length > 0)&&(rowData.ReportDR != ""))
            {
	            qryAnt[rowData.ReportDR] = {};
	            $('#Sub-'+rowIndex).datagrid('checkAll');
            }
        },
        onUncheck: function(rowIndex, rowData) {
            delete quoteData[rowData.OeordID]["child" + rowIndex];
            if ((rowData.DetailData.length > 0)&&(rowData.ReportDR != "")) 
            {
	            delete qryAnt[rowData.ReportDR];
	            $('#Sub-'+rowIndex).datagrid('uncheckAll');
            }
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
                quoteData[rows[i].OeordID]["child" + i] = { "ItemDesc": rows[i].ItemDesc, "Synonym": rows[i].Synonym, "ItemResult": rows[i].ItemResult, "ItemUnit": rows[i].ItemUnit, "AbnorFlag": rows[i].AbnorFlag, "ItemRanges": rows[i].ItemRanges, "DetailData":  rows[i].DetailData, "ReportDR":  rows[i].ReportDR  };
                if ((rows[i].DetailData.length > 0)&&(rows[i].ReportDR != "")) 
                {
	                qryAnt[rows[i].ReportDR] = {};
                	$('#Sub-'+i).datagrid('checkAll');
                }
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
                for (i = 0; i < length; i++) {
	                ((rows[0].DetailData.length > 0)&&(rows[0].ReportDR != "")) 
	                {
		                delete qryAnt[rows[0].ReportDR];
		                $('#Sub-'+i).datagrid('uncheckAll');
	                }
	            }
            }
        },
        rowStyler: function(index, row) {
            if ((row.AbnorFlag == "高") ||(row.AbnorFlag == "H")||(row.AbnorFlag == "↑")||(row.AbnorFlag == "荒诞高值")) {
                return 'color:#FF0000;';
            } else if ((row.AbnorFlag == "低") ||(row.AbnorFlag == "L")||(row.AbnorFlag == "↓")) {
                return 'color:#0000FF;';
            }
        },
        view: detailview,
		detailFormatter: function(rowIndex, rowData){
			if (rowData.DetailData.length > 0){
				return '<div style="padding:2px"><table id="Sub-' + rowIndex + '"></table></div>';
			}
		},
		onExpandRow: function(index,row){
			if (row.DetailData.length > 0)
			{
				var expanderdata = row.DetailData;
				qryAnt[row.ReportDR] = {};
				$('#Sub-'+index).datagrid({
					loadMsg:'数据装载中......',
					autoRowHeight:true,
					data:expanderdata,
					rownumbers:true,
					singleSelect:false,
					idField:'ReportDR',
					columns:[[  
				        {field:'ck',checkbox:true},
				        {field:'ReportDR',title:'ReportDR',width:80,hidden:true},
				        {field:'AntCode',title:'抗生素代码',width:80},
				        {field:'AntName',title:'抗生素名称',width:80},
				        {field:'LowRange',title:'最低抑菌浓度',width:80},
				        {field:'SenCode',title:'药敏结果代码',width:80},
						{field:'SenName',title:'药敏结果描述',width:80,sortable:true},
						{field:'Suggest',title:'建议',width:80},
				        {field:'SenMethod',title:'药敏方法',width:80,sortable:true}
				    ]],
					sortOrder:'SenName',
					onResize:function(){
						$('#lisSubData').datagrid('fixDetailRowHeight',index);
					},
					onCheck: function(rowIndex, rowData) {
			            qryAnt[rowData.ReportDR]["child" + rowIndex] = { "ReportDR": rowData.ReportDR, "AntCode": rowData.AntCode, "AntName": rowData.AntName, "SenCode": rowData.SenCode, "SenName": rowData.SenName, "SenMethod": rowData.SenMethod, "LowRange": rowData.LowRange, "Suggest": rowData.Suggest };
			        },
			        onUncheck: function(rowIndex, rowData) {
			            delete qryAnt[rowData.ReportDR]["child" + rowIndex];
			        },
			        onCheckAll: function(rows) {
			            var length = rows.length;
			            if (length <= 0) return;
			            for (i = 0; i < length; i++) {
			                qryAnt[rows[i].ReportDR]["child" + i] = { "ReportDR": rows[i].ReportDR, "AntCode": rows[i].AntCode, "AntName": rows[i].AntName, "SenCode": rows[i].SenCode, "SenName": rows[i].SenName, "SenMethod": rows[i].SenMethod, "LowRange": rows[i].LowRange, "Suggest": rows[i].Suggest };
			            }
			        },
			        onUncheckAll: function(rows) {
			            var length = rows.length;
			            if (length <= 0) return;
			            for (i = 0; i < length; i++) {
			            	qryAnt[rows[i].ReportDR] = {};
			            }
			        },
					onLoadSuccess:function(data){
						setTimeout(function(){
							$('#lisSubData').datagrid('fixDetailRowHeight',index);
						},0);
					}
				});
				$('#lisSubData').datagrid('fixDetailRowHeight',index);
			}else{
				$('#lisSubData').datagrid('collapseRow',index);
				
			}
		},
        onLoadSuccess: function(data) { //当表格成功加载时执行               
            var rowData = data.rows;
            $.each(rowData, function(idx, val) { //遍历JSON
                if (rowData[idx].DetailData.length > 0){
					$('#lisSubData').datagrid('expandRow',idx);
				}
                
                if(selectConfig == "Y"){
					if (AbnorFlagCheck == "N" && val.AbnorFlag != "" && val.AbnorFlag != "正常" &&clickFlag) {
						$("#lisSubData").datagrid("selectRow", idx); //选中行
					}
				}else{
                //AbnorFlagCheck检验数据启用异常值默认勾选
					if (AbnorFlagCheck == "N" && val.AbnorFlag != "" && val.AbnorFlag != "正常") {
						$("#lisSubData").datagrid("selectRow", idx); //选中行
					}
				}
                
            });
        }
    });
}
//父表选中
function onCheckPar(rowIndex, rowData,checkstyle){
    var ordItemId = rowData.OEordItemRowID;
    quoteData[ordItemId] = {};
    if (checkstyle == "Multiple") {
        loadMultiSubData();
    } else {
        loadSubData(rowData.EpisodeID, ordItemId, rowData.LabEpisodeNo);
    }	
}
//父表 取消选中
function onUnCheckPar(rowData,checkstyle){
	if (checkstyle == "Multiple") {
                quoteData = {};
                loadMultiSubData();
            } else {
                $('#lisSubData').datagrid('uncheckAll');
                delete quoteData[rowData.OEordItemRowID];
            }
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
    $('#lisData').datagrid('reload', param);
}

//获取查询参数
function getParam() {
    var stDateTime = "",
        endDateTime = "";
    //authStDateTime、authEndDateTime是按审核日期查询的始末条件
    var authStDateTime = "",
        authEndDateTime = "";
    var authorizedFlag = "";
    var dateGap = "";
    var epsodeIds = episodeID;
    if ($('#currentDay')[0].checked) {
        //stDateTime = new Date().format("yyyy-MM-dd");
        //endDateTime = new Date().format("yyyy-MM-dd");
        //按审核日期当日查询
        authStDateTime = new Date().format("yyyy-MM-dd");
        authEndDateTime = new Date().format("yyyy-MM-dd");
        dateGap = "1";
    } else if ($('#ThreeDays')[0].checked) {
        var start = new Date();
        start.setDate(start.getDate() - 2);
        //stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
        //endDateTime = new Date().format("yyyy-MM-dd");
        //按审核日期三日内查询查询
        authStDateTime = start.getFullYear() + "-" + (start.getMonth() + 1) + "-" + start.getDate();
        authEndDateTime = new Date().format("yyyy-MM-dd");
        dateGap = "3";
    } else if ($('#sevenDays')[0].checked)
	{
		var start = new Date();
        start.setDate(start.getDate() - 6);
        //stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
        //endDateTime = new Date().format("yyyy-MM-dd");
        //按审核日期七日内查询查询
        authStDateTime = start.getFullYear() + "-" + (start.getMonth() + 1) + "-" + start.getDate();
        authEndDateTime = new Date().format("yyyy-MM-dd");
        dateGap = "7";
	} else if ($('#currentWeek')[0].checked) {
        var now = new Date();
        var start = new Date();
        var n = now.getDay();
        start.setDate(now.getDate() - n + 1);
        //stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate();   
        //endDateTime = new Date().format("yyyy-MM-dd");
        //按审核日期一周内查询
        authStDateTime = start.getFullYear() + "-" + (start.getMonth() + 1) + "-" + start.getDate();
        authEndDateTime = new Date().format("yyyy-MM-dd");
        dateGap = "currentWeek";
    } else if ($('#allEpisode')[0].checked) {
        epsodeIds = "";
        var values = $('#EpisodeList').combogrid('getValues');
        for (var i = 0; i < values.length; i++) {
            epsodeIds = (i == 0) ? "" : epsodeIds + ",";
            epsodeIds = epsodeIds + values[i];
        }
        authorizedFlag = "";
    } else if ($('#noAuthEpisode')[0].checked) {
        //未审核查询
        authorizedFlag = 0;
    } else if ($('#currentEpisode')[0].checked) {
        //本次就诊
        authorizedFlag = 1;
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
    var classField = $(strXml).find("reference>parent>classField").text();
    var classItems = [];
    if (classField != "") {
        classItems = classByField(checkedItems,classField);
    }else{
        classItems.push({id:"",data: checkedItems});
    }
    var map = {};
    var param = {"action":"GET_DOCUMENT_CONTEXT"};
    documentContext = parent.eventDispatch(param);
    $.each(classItems, function(index, item) {
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
                    if ((item[classField] != "")&&(parentList[i].code == classField)) {
                        if(!map[classField + item[classField]]) {
                            map[classField + item[classField]] = item;
                            result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
                        }
                    }else {
                        result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
                    }
                }
                //根据配置决定未审核医嘱引用时是否自动增加类似于"未回报"的信息
                if ((item.AuthorisationDate === "")&&(item.AuthorisationTime === "")&&(unAudit !== ""))
                {
                    result = result + unAudit;
                }
                var length = countProperties(quoteData[item.OEordItemRowID]);
                var childCount = 0;
                //收集子表内容
                $.each(quoteData[item.OEordItemRowID], function(index, item) {
                    childCount = childCount + 1;
                    for (j = 0; j < childList.length; j++) {
                        if (childList[j].code == "ItemUnit") {
                            var obj = getFormatString(item[childList[j].code]);
                            if (obj != "") {
                                var idx1 = item[childList[j].code].indexOf(obj.subChar1);
                                var idx2 = item[childList[j].code].indexOf(obj.subChar2);
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
                        if (childList.length-1 > j) {
                            result = result + childList[j].separate;
                        }else{
                            if (length == childCount){
                                //每条父项检验医嘱数据是换行符时,再引用子项检验医嘱数据的分隔符
                                if (separate == "\n") result = result + childList[j].separate;
                            }else{
                                result = result + childList[j].separate;
                            }
                        }
                    }
                if ((item["DetailData"].length > 0)&&(item["ReportDR"] != ""))
	            {
            		result = result + "\n";
            		$.each(qryAnt[item["ReportDR"]], function(row, rowData) {
	            		result = result + rowData.AntName + "：" + rowData.SenName + rowData.Suggest + "；";	
            		});
	            }
            });
                if (checkedItems.length - 1 > index) {
                    result = result + separate;
                }
                inputReferenceDataLog(item.EpisodeID,item.OEordItemRowID,item.OEordItemDesc)  
            }
        });
    });
    resultItems.push({ "TEXT": result });
    var param = { "action": "INSERT_STYLE_TEXT_BLOCK", "args": { "items": resultItems } };
    parent.eventDispatch(param);
    UnCheckAll();
}

//根据classField字段对数组arr进行分类
function classByField(arr,classField)
{
    var map = {},dest = [];
    for(var i = 0; i < arr.length; i++){
        var ai = arr[i];
        if(!map[ai[classField]]){
            dest.push({
                id: ai[classField],
                data: [ai]
            });
            map[ai[classField]] = ai;
        }else{
            for(var j = 0; j < dest.length; j++){
                var dj = dest[j];
                if(dj.id== ai[classField]){
                    dj.data.push(ai);
                    break;
                }
            }
        }
    }
    return dest;
}

//计算对象的长度
function countProperties (obj) {
    var count = 0;
    for (var property in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, property)) {
            count++;
        }
    }
    return count;
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
var lisSubColumn = {"ItemDesc":{"check":true},
					"Synonym":{"check":true},
					"ItemResult":{"check":true},
					"ItemUnit":{"check":true},
					"AbnorFlag":{"check":true},
					"ItemRanges":{"check":true}};
$(function() {
    strXml = convertToXml(scheme);
    var interface = $(strXml).find("interface").text();
    var checkstyle = $(strXml).find("checkstyle").text();
    pageConfig = $(strXml).find("pageConfig").text();
    selectConfig=$(strXml).find("datagridConfig>selectConfig").text();
    if(selectConfig=="Y"){
	     selectOnCheckFlag=false
   	     checkOnSelectFlag=false
	}
    $("#comboxEpisode").hide();
    initEpisodeList("#EpisodeList");
	$('#searchLisdata').searchbox({ 
	    searcher:function(value,name){ 
	    	queryData();
	    }          
	  }); 
    setDataGrid(interface, checkstyle);
	$HUI.radio("[name='episode']",{
        onChecked:function(e,value){
            var value = $(e.target).attr("value");
            if (value === "allEpisode")
            {
				$("#comboxEpisode").show(); 
	        } 
	        else
	        {
				$("#comboxEpisode").hide();
 				$("#EpisodeList").combogrid('hidePanel');
				queryData();
		    }
		   	if (pageConfig == "Y")
			{
				resourceConfig.Lis = this.id;
				saveResourceConfig('Lis');
			} 
        }
    }); 
    
  	if (pageConfig == "Y")
	{
		//获取其它资源区的查询按钮配置项数据
		resourceConfig = getResourceConfig();
		var configItem = resourceConfig.Lis;
		if ((configItem != "")&&(configItem != undefined))
		{
			$HUI.radio("#"+configItem).setValue(true);
		}
		else
		{
			$HUI.radio("#currentEpisode").setValue(true);
		}
	}
	else
	{
		$HUI.radio("#currentEpisode").setValue(true);
	}     
	initlisSubTable();
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
	    headerCls:'panel-header-gray',
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
        sortOrder: 'desc',
        remoteSort: false,
		sortName: 'AuthorisationDate,AuthorisationTime',
		border:false,
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
		rowStyler: function(index, row) {
            if (row.IsReferenceOEord == "1")
			{
				return 'color:#CCCCCC;';
			}
            if (row.ResultStatus == "1") {
                return 'color:#60F807;';
            }
            if (row.AbnormalFlag == "1") {
                return 'color:#FF0000;';
            }
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
    lisSubItems = getColumnScheme("show>child>item");
    var wid = 0;
    for (var i=0;i<lisSubItems[0].length;i++)
    {
	    wid = wid + lisSubItems[0][i].colwidth;
	}
    $('#lisSubData').datagrid({
	    headerCls:'panel-header-gray',
        //loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.lisData.cls?Action=GetSubLis&InterFace=' + encodeURI(encodeURI(interface)),
        singleSelect: true,
        rownumbers: true,
        singleSelect: false,
        fit: true,
        border:false,
        //width:wid,
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
                quoteData[rows[i].OeordID]["child" + i] = { "ItemDesc": rows[i].ItemDesc, "Synonym": rows[i].Synonym, "ItemResult": rows[i].ItemResult, "ItemUnit": rows[i].ItemUnit, "AbnorFlag": rows[i].AbnorFlag, "ItemRanges": rows[i].ItemRanges, "DetailData": rows[i].DetailData, "ReportDR": rows[i].ReportDR  };
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
            if ((row.AbnorFlag == "高") ||(row.AbnorFlag == "H")||(row.AbnorFlag == "↑")||(row.AbnorFlag == "荒诞高值")||(row.AbnorFlag == "A")) {
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
					headerCls:'panel-header-gray',
					loadMsg:'数据装载中......',
					autoRowHeight:true,
					data:expanderdata,
					rownumbers:true,
					singleSelect:false,
					idField:'ReportDR',
					columns:[[  
				        {field:'ck',checkbox:true},
				        {field:'ReportDR',title:'ReportDR',width:80,hidden:true},
				        {field:'RowID',title:'药敏结果ID',width:80,hidden:true},
				        {field:'Sequence',title:'序号',width:80},
				        {field:'AntibioticsDR',title:'抗生素代码',width:80},
				        {field:'AntibioticsName ',title:'抗生素名称',width:80},
				        {field:'SName',title:'抗生素缩写',width:80},
				        {field:'SensitivityDR',title:'药敏结果代码',width:80},
				        {field:'SensitivityName',title:'药敏结果名称',width:80},
				        {field:'SenMethod',title:'试验方法',width:80},
				        {field:'SenValue',title:'结果值',width:80},
						{field:'IRanges',title:'I折点范围',width:80},
						{field:'SRanges',title:'S折点范围',width:80},
				        {field:'RRanges',title:'R折点范围',width:80},
				        {field:'AntibioticsClassDR',title:'抗生素级别代码',width:80}
				    ]],
					sortOrder:'SensitivityName',
					onResize:function(){
						$('#lisSubData').datagrid('fixDetailRowHeight',index);
					},
					onCheck: function(rowIndex, rowData) {
			            qryAnt[rowData.ReportDR]["child" + rowIndex] = { "ReportDR": rowData.ReportDR, "Sequence": rowData.Sequence, "AntibioticsDR": rowData.AntibioticsDR, "AntibioticsName": rowData.AntibioticsName, "SName": rowData.SName, "SensitivityDR": rowData.SensitivityDR, "SensitivityName": rowData.SensitivityName, "SenMethod": rowData.SenMethod, "SenValue": rowData.SenValue, "IRanges": rowData.IRanges, "SRanges": rowData.SRanges, "RRanges": rowData.RRanges, "AntibioticsClassDR": rowData.AntibioticsClassDR };
			        },
			        onUncheck: function(rowIndex, rowData) {
			            delete qryAnt[rowData.ReportDR]["child" + rowIndex];
			        },
			        onCheckAll: function(rows) {
			            var length = rows.length;
			            if (length <= 0) return;
			            for (i = 0; i < length; i++) {
			                qryAnt[rows[i].ReportDR]["child" + i] = { "ReportDR": rows[i].ReportDR, "Sequence": rows[i].Sequence, "AntibioticsDR": rows[i].AntibioticsDR, "AntibioticsName": rows[i].AntibioticsName, "SName": rows[i].SName, "SensitivityDR": rows[i].SensitivityDR, "SensitivityName": rows[i].SensitivityName, "SenMethod": rows[i].SenMethod, "SenValue": rows[i].SenValue, "IRanges": rows[i].IRanges, "SRanges": rows[i].SRanges, "RRanges": rows[i].RRanges, "AntibioticsClassDR": rows[i].AntibioticsClassDR };
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
    if ($('#currentDay')[0].checked) {
        //stDateTime = new Date().format("yyyy-MM-dd");
        //endDateTime = new Date().format("yyyy-MM-dd");
        //按审核日期当日查询
        authStDateTime = new Date().format("yyyy-MM-dd");
        authEndDateTime = new Date().format("yyyy-MM-dd");
    } else if ($('#ThreeDays')[0].checked) {
        var start = new Date();
        start.setDate(start.getDate() - 2);
        //stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
        //endDateTime = new Date().format("yyyy-MM-dd");
        //按审核日期三日内查询查询
        authStDateTime = start.getFullYear() + "-" + (start.getMonth() + 1) + "-" + start.getDate();
        authEndDateTime = new Date().format("yyyy-MM-dd");
    } else if ($('#sevenDays')[0].checked)
	{
		var start = new Date();
        start.setDate(start.getDate() - 6);
        //stDateTime = start.getFullYear() + "-" + (start.getMonth()+1) + "-" + start.getDate()   
        //endDateTime = new Date().format("yyyy-MM-dd");
        //按审核日期七日内查询查询
        authStDateTime = start.getFullYear() + "-" + (start.getMonth() + 1) + "-" + start.getDate();
        authEndDateTime = new Date().format("yyyy-MM-dd");
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
    var searchInput = $('#searchLisdata').searchbox('getValue');
    var param = {
        EpisodeID: epsodeIds,
        SearchInput:searchInput,
        StartDateTime: stDateTime,
        EndDateTime: endDateTime,
        AuthStartDateTime: authStDateTime,
        AuthEndDateTime: authEndDateTime,
        AuthorizedFlag: authorizedFlag
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
	var endseparate = $(strXml).find("endseparate").text();
    var quality = $(strXml).find("quality").text();
    var checkedItems = $('#lisData').datagrid('getChecked');
	checkedItems = setArrValue(checkedItems);
	// 将数据按照时间倒叙排序
	checkedItems.sort(compareOrdDT("ReceiveDateTime","inverted")); 	
	var param = {"action":"GET_DOCUMENT_CONTEXT"};
	documentContext = parent.eventDispatch(param);
    $.each(checkedItems, function(index, item) {
        if (quality == "1")
		{
			var happenDatetime = documentContext.HappenDateTime;
			var tmpDatetime = item.AuthorisationDate + " "+ item.AuthorisationTime;
			if (compareDateTime(happenDatetime,tmpDatetime))
			{
				top.$.messager.alert("提示","审核时间大于病历时间,不能引用");
				return false;
			}
		}
        if (quoteData[item.OEordItemRowID]) {
            //收集父内容
            for (var i = 0; i < parentList.length; i++) {
                result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
            }
            //收集子表内容
			var childLength = Object.keys(quoteData[item.OEordItemRowID]).length;
            var count = 0;
            $.each(quoteData[item.OEordItemRowID], function(index1, item) {
                for (j = 0; j < childList.length; j++) {	            
	                if(lisSubColumn[childList[j].code].check==true)
	                {		             
	                    if (childList[j].code == "ItemUnit") 
	                    {
	                        var obj = getFormatString(item[childList[j].code]);
	                        if (obj != "") {
	                            var idx1 = item[childList[j].code].indexOf(obj.subChar1);
	                            var idx2 = item[childList[j].code].indexOf(obj.subChar2);
	                            if ((item[childList[j].code].charAt(0) != "*")&&(item[childList[j].code].charAt(0) != "×")) {
	                                result = result + "*";
	                            }
	                            result = result + item[childList[j].code].substring(0, idx1);
	                            resultItems.push({ "TEXT": result });
	                            resultItems.push({ "STYLE": [obj.Style], "TEXT": item[childList[j].code].substring(idx1 + 1, idx2) });
	                            result = item[childList[j].code].substring(idx2);
	                        } 
	                        else 
	                        {
	                            result = result + item[childList[j].code];
	                        }
	                    } 
	                    else 
	                    {
	                        result = result + item[childList[j].code];
	                    }
                    if (childLength-1 > count)
                    {
                    	result = result + childList[j].separate;
                    }
					count = count +1;					
                }
                    
            }
			if ((item["DetailData"].length > 0)&&(item["ReportDR"] != ""))
			{
				result = result + "\n";
				$.each(qryAnt[item["ReportDR"]], function(row, rowData) {
					result = result + rowData.AntibioticsName + "：" + rowData.SensitivityName + " " + rowData.SenValue + "；";	
				});
			}
        });
		if (checkedItems.length  > index) {
			result = result + separate;
		}
	    inputReferenceDataLog(item.EpisodeID,item.OEordItemRowID,item.OEordItemDesc)
			
			var curIndex = $('#lisData').datagrid('getRowIndex',item.OEordItemRowID);
		if((curIndex !=undefined)&&(curIndex >-1)){
				$('#lisData').datagrid('updateRow',{
					index: curIndex,
					row: {
						IsReferenceOEord: "1"
					}
				});	
			}	
        }
    });
	
    if((endseparate != "")&&(result.charAt(result.length-1) == ","))
    {
	    result = result.substring(0, result.length-2) + endseparate;
	}	
	
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

function initlisSubTable()
{
	var tr = $('<tr class="datagrid-header-row lisSubData-header-row0"></tr>');
	lisSubItems = getColumnScheme("show>child>item")
	var lisSubRefScheme = getRefScheme("reference>child>item");
	tda = "<td class='datagrid-header-rownumber'></td><td style='width:22px;'></td><td class='datagrid-header-over' id='' style='width:15px;'><input class='hisui-checkbox' type='checkbox' name='SubPacs' data-options='onCheckChange:function(event,value){checkAllData(this)}'/></td>"
	$(tr).append(tda);
	for (var i=1;i<lisSubItems[0].length;i++)
	{
		var	td = "";		
		if (lisSubItems[0][i].hidden)
		{ 
			td= "<td class='' id='" +lisSubItems[0][i].field+ "' style='display:none;'><input class='hisui-checkbox' type='checkbox' name='SubPacs' label='" + lisSubItems[0][i].title + "'/></td>"    
		}
		else
		{
			var isCheckField = true;
			$.each(lisSubRefScheme, function(index, item){
				if (item.code == lisSubItems[0][i].field)
				{
					isCheckField = true
					return false;
				}
				else
				{
					isCheckField = false
					return;
				}
				
			})
			
			if (isCheckField == true)
			{
				td= "<td class='' id='" +lisSubItems[0][i].field+ "' style='width:" +(lisSubItems[0][i].width-2)+ ";' align='center'><input class='hisui-checkbox' type='checkbox' name='" +lisSubItems[0][i].field+ "' data-options='onCheckChange:function(event,value){checkOnClick(this)}' label='" + lisSubItems[0][i].title + "'/></td>" 			
			}
			else
			{
				td= "<td class='' id='" +lisSubItems[0][i].field+ "' style='width:" +lisSubItems[0][i].width+ ";' align='center'>"+emrTrans(lisSubItems[0][i].title)+"</td>" 			

			}
		}
		
		$(tr).append(td);
	}
	$("#lisSubColumn").append(tr);
	$.parser.parse('#lisSubColumn');
	if(selectConfig=="Y"&&clickFlag==false)return
	for (var i=0;i<lisSubRefScheme.length; i++)
	{
		if (lisSubRefScheme[i].check)
		{ 
			var code = lisSubRefScheme[i].code;
			//$('#'+ code+ " input").attr("checked",true);
			$HUI.checkbox('#'+ code+ " input").setValue(true);
		}
	}	
}

function checkAllData(obj)
{
	if(obj.checked)
	{
		$('#lisSubData').datagrid('checkAll');	
	}
	else
	{
		$('#lisSubData').datagrid('uncheckAll');
	}
	
}

//选择子项目
function checkOnClick(obj)
{
	try
	{		
		if (!$("#lisSubColumn tr td")) return;
		var field = obj.name;
		var lisSubItems = getColumnScheme("show>child>item");
		//lisSubColumn = lisSubItems[0];
		if(obj.checked)
		{
			for(var i=0;i<lisSubItems[0].length;i++)
			{
				if((lisSubItems[0][i])&&(lisSubItems[0][i].field))
				{
					if (lisSubItems[0][i].field == field)
					{
						lisSubColumn[field].check = true;					
					}
				}
			}
		}
		else
		{
			for(var i=0;i<lisSubItems[0].length;i++)
			{
				if((lisSubItems[0][i])&&(lisSubItems[0][i].field))
				{
					if (lisSubItems[0][i].field == field)
					{
						lisSubColumn[field].check = false;
					}
				}
			}
		}	
	}
	catch(err)
	{
	}

}

function setArrValue(data)
{
	if(data.length == 0) return
	for(var i = 0; i < data.length; i++)
	{
		data[i].ReceiveDateTime = data[i].ReceiveDate+" "+data[i].ReceiveTime
	}
	return data
}
// positive 正序  inverted倒叙
function compareOrdDT(prop,align){
	return function(a,b){
        var value1=a[prop].replace(/-/g,"/");
        var value2=b[prop].replace(/-/g,"/");
        if(align=="positive"){//正序
            return new Date(value1)-new Date(value2);
        }else if(align=="inverted"){//倒序
            return new Date(value2)-new Date(value1);
        }
	}
}

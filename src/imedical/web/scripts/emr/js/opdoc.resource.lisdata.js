$(function(){
    strXml = convertToXml(scheme);
    var interface =$(strXml).find("interface").text();
    var checkstyle =$(strXml).find("checkstyle").text();
    pageConfig = $(strXml).find("pageConfig").text();
    $("#resourceConfig").hide();
    $HUI.radio("[name='episode']",{
        onChecked:function(e,value){
            //alert("选中事件");
            queryData();
            $('#EpisodeList').combogrid('setValue','');
            if (pageConfig == "Y") {
                resourceConfig.Lis = this.id;
            }
        }
    });
    if (pageConfig == "Y") {
        $("#resourceConfig").show();
        //获取其它资源区的查询按钮配置项数据
        resourceConfig = getResourceConfig();
        var configItem = resourceConfig.Lis;
        if ((configItem != "")&&(configItem != undefined))
        {
            $HUI.radio("#"+configItem).setValue(true);
        }else{
            //$('#currentEpisode').attr("checked",true);
            $HUI.radio("#currentEpisode").setValue(true);
        }
    }else{
        $HUI.radio("#currentEpisode").setValue(true);
        //默认加载前5条就诊的所有检验数据
        //$('#allEpisode').attr("checked",true);
        //$("#comboxEpisode").show();
    }
    initEpisodeList("#EpisodeList");
    setDataGrid(interface,checkstyle);
    /*
    $('#seekform').find(':radio').change(function () {
        
        if (this.id == "allEpisode")
        {
            $("#comboxEpisode").show();
        }
        else
        {
            $("#comboxEpisode").hide();
            queryData();
        }
        if (pageConfig == "Y")
        {
            resourceConfig.Lis = this.id;
        }
        
    });
    */

    $('#lisDataPnl').panel('resize', {
        height: $('#dataPnl').height() * 0.50
    });
 
    $('body').layout('resize');
});

//设置数据
function setDataGrid(interface,checkstyle)
{
    var param = getParam();
    /*
    if ($('#allEpisode')[0].checked)
    {
        param.EpisodeID = getAllEpisodeIdByPatientId();
    }
    */
    $('#lisData').datagrid({
        pageSize:10,
        pageList:[10,20,30], 
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        url:'../EMRservice.Ajax.lisData.cls?Action=GetLisData&InterFace='+encodeURI(encodeURI(interface)), 
        rownumbers:true,
        pagination:true,
        singleSelect:false,
        queryParams:param,
        idField:'OEordItemRowID',
        fit:true,
        columns:getColumnScheme("show>parent>item"),
        sortName:'AuthorisationDate',
        sortOrder:'desc',
        remoteSort:false,
        onCheck:function(rowIndex,rowData){
            var ordItemId = rowData.OEordItemRowID;
            quoteData[ordItemId]={};
            if (checkstyle == "Multiple")
            {
                loadMultiSubData();
            }
            else
            {
                loadSubData(rowData.EpisodeID,ordItemId,rowData.LabEpisodeNo);
            }
        },
        onUncheck:function(rowIndex,rowData){
            if (checkstyle == "Multiple")
            {
                quoteData = {};
                loadMultiSubData();
            }
            else
            {
                $('#lisSubData').datagrid('uncheckAll');
                
                //delete quoteData[rowData.OEordItemRowID];
                quoteData = {};
                $('#lisSubData').datagrid('loadData',{total:0,rows:[]});
            }
        },
        onCheckAll:function(rows)
        {
            quoteData = {};
            var length = rows.length; 
            if (length == 0) return;
            if (checkstyle == "Multiple")
            {
                loadMultiSubData();
            }
            else
            {
                quoteData = {};	
                $('#lisSubData').datagrid('loadData',{total:0,rows:[]});
                for(i = 0; i < length; i ++){ 
                    quoteData[rows[i].OEordItemRowID] = {};	
                    loadSubData(rows[i].EpisodeID,rows[i].OEordItemRowID,rows[i].LabEpisodeNo);
                }
            }
        },
        onUncheckAll:function(rows)
        {
            quoteData = {};	
            $('#lisSubData').datagrid('loadData',{total:0,rows:[]});
        }
    });
    $('#lisSubData').datagrid({ 
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        url:'../EMRservice.Ajax.lisData.cls?Action=GetSubLis&InterFace='+encodeURI(encodeURI(interface)), 
        singleSelect:true,
        rownumbers:true,
        singleSelect:false,
        fit:true,
        columns:getColumnScheme("show>child>item"),
        onCheck:function(rowIndex,rowData){
            quoteData[rowData.OeordID]["child" + rowIndex] = { "ItemDesc": rowData.ItemDesc, "Synonym": rowData.Synonym, "ItemResult": rowData.ItemResult, "ItemUnit": rowData.ItemUnit, "AbnorFlag": rowData.AbnorFlag, "ItemRanges": rowData.ItemRanges, "DetailData": rowData.DetailData, "ReportDR": rowData.ReportDR };
            if ((rowData.DetailData.length > 0)&&(rowData.ReportDR != ""))
            {
	            qryAnt[rowData.ReportDR] = {};
	            $('#Sub-'+rowIndex).datagrid('checkAll');
            }
        },
        onUncheck:function(rowIndex,rowData){
            delete quoteData[rowData.OeordID]["child"+rowIndex];
            if ((rowData.DetailData.length > 0)&&(rowData.ReportDR != "")) 
            {
	            delete qryAnt[rowData.ReportDR];
	            $('#Sub-'+rowIndex).datagrid('uncheckAll');
            }
        },
        onCheckAll:function(rows){
            var length = rows.length;
            if (length <= 0) return; 
            if (checkstyle == "Multiple")
            {
                var ids = $('#lisData').datagrid('getChecked');
                for(var i=0;i<ids.length;i++) {
                    quoteData[ids[i].OEordItemRowID] = {};
                }
            }
            else
            {
                delete quoteData[rows[0].OeordID]
                quoteData[rows[0].OeordID] = {};
            }
            for(i = 0; i < length; i ++){ 
                quoteData[rows[i].OeordID]["child" + i] = { "ItemDesc": rows[i].ItemDesc, "Synonym": rows[i].Synonym, "ItemResult": rows[i].ItemResult, "ItemUnit": rows[i].ItemUnit, "AbnorFlag": rows[i].AbnorFlag, "ItemRanges": rows[i].ItemRanges, "DetailData": rows[i].DetailData, "ReportDR": rows[i].ReportDR  };
                if ((rows[i].DetailData.length > 0)&&(rows[i].ReportDR != "")) 
                {
	                qryAnt[rows[i].ReportDR] = {};
                	$('#Sub-'+i).datagrid('checkAll');
                }
            }
        },
        onUncheckAll:function(rows)
        {
            var length = rows.length;
            if (length <= 0) return; 
            if (checkstyle == "Multiple")
            {
                var ids = $('#lisData').datagrid('getChecked');
                for(var i=0;i<ids.length;i++) {
                    quoteData[ids[i].OEordItemRowID] = {};
                }
            }
            else
            {
                quoteData[rows[0].OeordID]={};
		for (i = 0; i < length; i++) {
	                ((rows[0].DetailData.length > 0)&&(rows[0].ReportDR != "")) 
	                {
		                delete qryAnt[rows[0].ReportDR];
		                $('#Sub-'+i).datagrid('uncheckAll');
	                }
	            }
            }
        },
        rowStyler: function(index,row){
            /*if ((row.AbnorFlag != "")&&(row.AbnorFlag != "正常")){
                return 'color:#FF0000;';
            }*/
            if ((row.AbnorFlag == "H")||(row.AbnorFlag == "PH")){
                return 'color:#FF0000;';
            }
            else if(row.AbnorFlag == "L")
            {
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
	onLoadSuccess:function(data){//当表格成功加载时执行
            var rowData = data.rows;
            $.each(rowData,function(idx,val){//遍历JSON
                if (rowData[idx].DetailData.length > 0){
					$('#lisSubData').datagrid('expandRow',idx);
				}
            //AbnorFlagCheck检验数据启用异常值默认勾选
            if( AbnorFlagCheck == "N" && val.AbnorFlag != "" && val.AbnorFlag != "正常"){
                     $("#lisSubData").datagrid("selectRow", idx); //选中行
                }
           });
        }
    }); 
}

///加载子项
function loadSubData(episodeId,oeordId,labEpisodeNo)
{
    $('#lisSubData').datagrid('load',{
        Action: 'GetSubLis',
        EpisodeID: episodeId,
        ID: oeordId,
        LabEpisodeNo:labEpisodeNo
    });
}

///加载全选的多个子项
function loadMultiSubData() {
    var ordItemId = "";
    var episodeId = "";
    var labEpisodeNo = ""
    var ids = $('#lisData').datagrid('getChecked');
    for(var i=0;i<ids.length;i++) {
        quoteData[ids[i].OEordItemRowID] = {};
        if (ordItemId == "") 
        { 
            ordItemId = ids[i].OEordItemRowID; 
        }
        else 
        { 
            ordItemId = ordItemId + "^" + ids[i].OEordItemRowID; 
        }
        if (episodeId == "") 
        { 
            episodeId = ids[i].EpisodeID; 
        }
        else 
        { 
            episodeId = episodeId + "^" + ids[i].EpisodeID; 
        }
        if (labEpisodeNo == "") 
        { 
            labEpisodeNo = ids[i].LabEpisodeNo; 
        }
        else 
        { 
            labEpisodeNo = labEpisodeNo + "^" + ids[i].LabEpisodeNo; 
        }
    }
    $('#lisSubData').datagrid('load',{
        Action: 'GetMultiSubLis',
        EpisodeID: episodeId,
        ID: ordItemId,
        LabEpisodeNo:labEpisodeNo
    });
}

// 查询
function queryData()
{
    var param = getParam();
    $('#lisData').datagrid('load',param);
    $('#lisSubData').datagrid('loadData',{total:0,rows:[]});
}

//获取查询参数
function getParam()
{
    var stDateTime = "",endDateTime = "";
    //authStDateTime、authEndDateTime是按审核日期查询的始末条件
    var authStDateTime = "",authEndDateTime = "";
    var authorizedFlag ="";
    //三个月时间标识
    var dateGap = "";
    var epsodeIds = episodeID;
    if ($('#currentEpisode')[0].checked)
    {
	//本次就诊
        //authorizedFlag = 1;
    }else if ($('#recentTwice')[0].checked) {
        authorizedFlag = 2;
    //}else if ($('#threeMonths')[0].checked) {
        //dateGap = $('#threeMonths').attr('value');
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
function getData()
{
    var resultItems = new Array(); 
    var result = "";
    var parentList = getRefScheme("reference>parent>item");
    var childList = getRefScheme("reference>child>item");
    var separate = $(strXml).find("reference>separate").text();
    separate = (separate=="enter")?"\n":separate
    var checkedItems = $('#lisData').datagrid('getChecked');
    $.each(checkedItems, function(index, item)
    {
        if (quoteData[item.OEordItemRowID])
        {
            //收集父内容
            for (var i=0;i<parentList.length;i++)
            {
                result = result + parentList[i].desc + item[parentList[i].code] + parentList[i].separate;
            }
            //收集子表内容
            $.each(quoteData[item.OEordItemRowID], function(index, item)
            {
                for (j=0;j<childList.length;j++)
                {
                    if (childList[j].code == "ItemUnit")
                    {
                        var obj = getFormatString(item[childList[j].code]);
                        if (obj != "")
                        {
                            var idx1 = item[childList[j].code].indexOf(obj.subChar1);
                            var idx2 = item[childList[j].code].indexOf(obj.subChar2);
                            if (item[childList[j].code].charAt(0) != "*")
                            {
                                result = result + "*";
                            }
                            result = result + item[childList[j].code].substring(0,idx1);
                            resultItems.push({"TEXT":result});
                            resultItems.push({"STYLE":[obj.Style],"TEXT":item[childList[j].code].substring(idx1+1,idx2)});
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
                    result = result + childList[j].separate;
                }
                if(item["DetailData"]!=null){
	                if ((item["DetailData"].length > 0)&&(item["ReportDR"] != ""))
		            {
	            		result = result + "\n";
	            		$.each(qryAnt[item["ReportDR"]], function(row, rowData) {
		            		result = result + rowData.AntName + "：" + rowData.SenName + "：" + rowData.Suggest + "；";	
	            		});
		            }
		    	}
            });
            if (checkedItems.length-1 > index)
            {
                result = result + separate;
            }
        }
    }); 
    resultItems.push({"TEXT":result});
    var param = {"action":"INSERT_STYLE_TEXT_BLOCK","args":{"items":resultItems}};
    parent.eventDispatch(param); 
    UnCheckAll();             
}

//判断字符处理
function getFormatString(text)
{
    var obj = "";
    $.each(formatStrings, function(index, item){
        if (text.indexOf(item.string)>-1)
        {
            obj = item;
            return true;
        }
    });
    return obj;
}

//去掉选择
function UnCheckAll()
{
    $("#lisData").datagrid("uncheckAll");
}
function onHidePanel()
{
    if ($('#currentEpisode')[0].checked) {
        $HUI.radio("#currentEpisode").setValue(false);
    }else if ($('#recentTwice')[0].checked) {
        $HUI.radio("#recentTwice").setValue(false);
    //}else if ($('#threeMonths')[0].checked) {
        //$HUI.radio("#threeMonths").setValue(false);
    }
    queryData();
}

var selectedGridId = "norders";
$(function(){
	strXml = convertToXml(scheme);
	var interface = $(strXml).find("interface").text();
	var display = $(strXml).find("display").text();
	$("#comboxEpisode").css('display','none');
	initEpisodeList("#EpisodeList");
	setDataGird(display,interface);
    $HUI.radio("[name='episode']",{
        onChecked:function(e,value){
            var value = $(e.target).attr("value");
            if (value === "allEpisode")
            {
				$("#comboxEpisode").css('display','inline');; 
	        } 
	        else
	        {
				$("#comboxEpisode").css('display','none');
 				$("#EpisodeList").combogrid('hidePanel');
				queryData();
				initQuoteList("#quoteList");		        
		    }
        }
    });
    $('#btnorders').keywords({
        singleSelect:true,
        items:[
            {text:emrTrans('临时医嘱'),id:'nordersBtn',selected:true},
            {text:emrTrans('长期医嘱'),id:'sordersBtn'},
            {text:emrTrans('出院带药'),id:'oordersBtn'}
        ],
        onClick:function(v){
            toggleBtn(v.id);
        }
    });   
    $HUI.radio("#currentEpisode").setValue(true);
/*     $('#btnorders').trigger("click");
    
    $("#btnorders").click(function(){
		initData("norders");
	})
  	$("#btsorders").click(function(){
		initData("sorders");
	})
  	$("#btoorders").click(function(){
		initData("oorders");
	}) */
	$("#OrderQuery").click(function () {
		queryData();
    })	
});

function toggleBtn(tabId)
{
    if (tabId == "nordersBtn")
    {
	  initData("norders");
    }
    else if(tabId == "sordersBtn")
    {
	  initData("sorders");
    }
    else
    {
	  initData("oorders");
	}     
}
function initData(gridId)
{
	selectedGridId = gridId;
 	//$(".btn-group button").removeClass("focus");
	if (selectedGridId == "norders")
	{
		$("#norders").parent().parent().parent().css("display","block");
		$("#sorders").parent().parent().parent().css("display","none");
		$("#oorders").parent().parent().parent().css("display","none");
		$("#btnorders").addClass("focus");
	}
	else if(selectedGridId == "sorders")
	{
		$("#norders").parent().parent().parent().css("display","none");
		$("#sorders").parent().parent().parent().css("display","block");
		$("#oorders").parent().parent().parent().css("display","none");
		$("#btsorders").addClass("focus");
	}
	else
	{
		$("#norders").parent().parent().parent().css("display","none");
		$("#sorders").parent().parent().parent().css("display","none");
		$("#oorders").parent().parent().parent().css("display","block");
		$("#btoorders").addClass("focus");		
	}
	queryData();
	initQuoteList("#quoteList");
}

function initQuoteList(comboName)
{
	//var id = getSelectGridId();
	var id = selectedGridId;
	var json = [];
	$.each($(strXml).find(id+">text"), function(idx, val){
		var j = {};
		j.value = idx;
		j.text = (typeof val.text == "undefined")?val.textContent:val.text;
		j.text = emrTrans(j.text);
		json.push(j);
	});
	$(comboName).combobox({
		data: json,
		valueField: 'value',
		textField: 'text',
		editable: false
	});
}
	
///初始化界面
function setDataGird(display,interface)
{
	var columns = getColumnScheme("scheme>show>parent>item");
	initDataGrid('#norders',columns,'N',display,interface);
	initDataGrid('#sorders',columns,'S',display,interface);
	initDataGrid('#oorders',columns,'O',display,interface);
}

//设置数据
function initDataGrid(id,columns,type,display,interface)
{
	var param = getParam();
	$(id).datagrid({ 
	    width:'100%',
	    height:'100%',
	    headerCls:'panel-header-gray', 
	    pageSize:10,
	    pageList:[10,20,30], 
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    url:'../EMRservice.Ajax.orderData.cls?Action=GetOrderData&OrderType='+type+'&InterFace='+encodeURI(encodeURI(interface)), 
	    rownumbers:true,
	    pagination:true,
	    singleSelect:false,
	    queryParams:param,
	    idField:'OEItemID',
	    fit:true,
	    columns:columns,
	    remoteSort:false,
        sortName: 'OrdCreateDate,OrdCreateTime', 
	    sortOrder:'desc,desc',
	    border:false,
	    rowStyler:function(index,row){
		    if (row.Reflag == "Parent"){
			    return 'background-color:#CBE8F6;';
			}
		},
		view: detailview,
		detailFormatter: function(rowIndex, rowData){
			if (rowData.Reflag == "Parent"){
				return '<div style="padding:2px"><table class="Sub-' + rowIndex + '"></table></div>';
			}
		},
		onExpandRow: function(index,row){
			if(row.Reflag == "Parent")
			{
				var epsodeIds = episodeID;
				if ($('#allEpisode')[0].checked)
				{
					epsodeIds = "";
					var values = $('#EpisodeList').combogrid('getValues');
					for (var i=0;i< values.length;i++)
					{
						epsodeIds = (i==0)?"":epsodeIds + ",";
						epsodeIds = epsodeIds + values[i];
					}	
				}
				$('.Sub-'+index).datagrid({
					loadMsg:'数据装载中......',
					autoRowHeight:true,
					url:'../EMRservice.Ajax.orderData.cls?Action=GetSubOrderData&OrderType='+type+'&EpisodeID='+epsodeIds+'&OEItemID='+row.OEItemID+'&InterFace='+encodeURI(encodeURI(interface)),
					rownumbers:true,
					singleSelect:false,
					idField:'OEItemID',
					columns:getColumnScheme("scheme>show>child>item"),
                    sortName: 'OrdCreateDate,OrdCreateTime', 
					sortOrder:'desc',
					onResize:function(){
						$(id).datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess:function(data){
						setTimeout(function(){
							$(id).datagrid('fixDetailRowHeight',index);
						},0);
					}
				});
				$(id).datagrid('fixDetailRowHeight',index);
			}else{
				$(id).datagrid('collapseRow',index);
				
			}
		},
		onCheck:function(rowIndex,rowData){
			if (rowData.Reflag == "Parent"){
				$('.Sub-'+rowIndex).datagrid('checkAll');
			}
		},
		onUncheck:function(rowIndex,rowData){
			if (rowData.Reflag == "Parent"){
				$('.Sub-'+rowIndex).datagrid('uncheckAll');
			}
		},
		onCheckAll:function(rows){
			for(var i=0;i<rows.length;i++){
				if (rows[i].Reflag == "Parent"){
					$('.Sub-'+i).datagrid('checkAll');
				}
			}
		},
		onUncheckAll:function(rows){
			for (var i=0;i<rows.length;i++){
				if (rows[i].Reflag == "Parent"){
					$('.Sub-'+i).datagrid('uncheckAll');
				}
			}
		},
		onLoadSuccess: function(data){
			//var selectID = "#" + getSelectGridId();
			var selectID = "#" + selectedGridId;
			if (selectID == id)
			{   
				$.each(data.rows,function(idx,val){
					if (val.Reflag == "Parent"){
						$(id).datagrid('expandRow',idx);
					}
				});
			}
		}
  });
}
// 查询
function queryData()
{
	var param = getParam();
	var id = selectedGridId //getSelectGridId();
	$('#'+id).datagrid('load',param);
}

//获取查询参数
function getParam()
{
	var epsodeIds = episodeID; 
	if ($('#allEpisode')[0].checked)
	{
		epsodeIds = "";
		var values = $('#EpisodeList').combogrid('getValues');
		for (var i=0;i< values.length;i++)
		{
			epsodeIds = (i==0)?"":epsodeIds + ",";
			epsodeIds = epsodeIds + values[i];
		}	
	}
	var searchInput = $('#searchMedorder').searchbox('getValue');
	var startDate = $("#startDate").datebox("getValue");
	var endDate = $("#endDate").datebox("getValue");	
	var param = {
		EpisodeID:epsodeIds,
		SearchInput:searchInput,
		StartDate:startDate,
		EndDate:endDate
	};
	return param;		
}

//搜索框回车查询
$("#searchInput").keydown(function(){
	if(event.keyCode == 13)
	{
		queryData();
	}	
});

$('#searchMedorder').searchbox({ 
    searcher:function(value,name){ 
    	queryData();
    }          
  });

//引用数据
function getData()
{
	var idx = $("#quoteList").combobox('getValue');
	rowArray = [];
	referenceParent = [];
	referenceChild = [];
	var id = selectedGridId //getSelectGridId();
	var checkedItems = $('#'+id).datagrid('getChecked');
	checkedItems = setArrValue(checkedItems);
	// 将数据按照时间倒叙排序
	checkedItems.sort(compareOrdDT("OrdCreateDateTime","inverted"));	
	var allItems = $('#'+id).datagrid('getRows');
	if (allItems.length == 0) return;
	var refScheme = getRefScheme("scheme>reference>"+id+">parent:eq("+idx+")>item");
	var refSubScheme = getRefScheme("scheme>reference>"+id+">child:eq("+idx+")>item");
	var separate = $(strXml).find("scheme>reference>"+id+">separate").text();
	separate = separate=="enter"?"\n":separate;
    var childseparate = $(strXml).find("scheme>reference>"+id+">childseparate").text();
    childseparate = childseparate=="plus"?"+":"\n";
	var seq = $(strXml).find("scheme>reference>"+id+">seq").text();
	seq = seq==""?"parent":seq;
    var childlinenum = $(strXml).find("scheme>reference>"+id+">childlinenum").text();
    childlinenum = childlinenum=="Y"?"@":"";
    getCheck(id,checkedItems,refScheme,refSubScheme,childseparate,seq,childlinenum);
    getOnlyChildCheck(id,allItems,refScheme,refSubScheme,childseparate,seq,childlinenum);
	var result = "";
	if (seq == "parent")
	{
        result = getParentSeqData(id,checkedItems,refScheme,refSubScheme,separate,childseparate,childlinenum);
	}else if (seq == "child"){
		result = getChildSeqData(id,checkedItems,refScheme,refSubScheme,separate);
	}
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param);            
	//去掉选择
	$("#"+id).datagrid("uncheckAll");
}

//普通医嘱或者主医嘱勾选情况
function getCheck(id,checkedItems,refScheme,refSubScheme,childseparate,seq,childlinenum)
{
	$.each(checkedItems, function(index, item){
		var parent = "";
		var child = "";
		var rowIndex = $('#'+id).datagrid('getRowIndex',item["OEItemID"]);
		rowArray.push(rowIndex);
		var checkedsubItems = "";
		if (item["Reflag"] == "Parent"){
			checkedsubItems = $('.Sub-'+rowIndex).datagrid('getChecked');
		}
		for (i=0;i<refScheme.length;i++ ){
			//判断引用字段是否为空
			if (item[refScheme[i].code] != "")
			{
				parent = parent + refScheme[i].desc + item[refScheme[i].code] + refScheme[i].separate;
			}
			if (i == refScheme.length-1)
			{
				if ((parent != "")&&(item[refScheme[i].code] == "")&&(refScheme[i-1].separate != ""))
				{
					parent = parent.substring(0,parent.length-1);
				}
			}
		}
		referenceParent[rowIndex] = parent;
		//关联医嘱
		if (checkedsubItems.length != 0){
			$.each(checkedsubItems, function(index, item){
				for (i=0;i<refSubScheme.length;i++ ){
					if (item[refSubScheme[i].code] != ""){
						child = child + refSubScheme[i].desc + item[refSubScheme[i].code] + refSubScheme[i].separate;
					}
					if (i == refSubScheme.length-1){
						if ((child != "")&&(item[refSubScheme[i].code] == "")&&(refSubScheme[i-1].separate != "")){
							child = child.substring(0,child.length-1);
						}
					}
				}
				if (seq == "parent")
				{
					if (checkedsubItems.length-1 > index){
                        if (childlinenum != ""){
                            child = child + childseparate + childlinenum;
                        }else{
                            child = child + childseparate + "  ";
                        }
					}
				}
			});
			$('.Sub-'+rowIndex).datagrid('uncheckAll');
		}
		referenceChild[rowIndex] = child;
	});       
}

//只有子医嘱勾选情况
function getOnlyChildCheck(id,allItems,refScheme,refSubScheme,childseparate,seq,childlinenum)
{
	$.each(allItems, function(index, item){
		var parent = "";
		var child = "";
		var rowIndex = $('#'+id).datagrid('getRowIndex',item["OEItemID"]);
		if ($.inArray(rowIndex,rowArray) == -1)
		{
			rowArray.push(rowIndex);
			var checkedsubItems = "";
			if (item["Reflag"] == "Parent"){
				checkedsubItems = $('.Sub-'+rowIndex).datagrid('getChecked');
			}
			referenceParent[rowIndex] = parent;
			//关联医嘱
			if (checkedsubItems.length != 0){
				$.each(checkedsubItems, function(index, item){
					for (i=0;i<refSubScheme.length;i++ ){
						if (item[refSubScheme[i].code] != ""){
							child = child + refSubScheme[i].desc + item[refSubScheme[i].code] + refSubScheme[i].separate;
						}
						if (i == refSubScheme.length-1){
							if ((child != "")&&(item[refSubScheme[i].code] == "")&&(refSubScheme[i-1].separate != "")){
								child = child.substring(0,child.length-1);
							}
						}
					}
					if (seq == "parent")
					{
						if (checkedsubItems.length-1 > index){
                            if (childlinenum != ""){
                                child = child + childseparate + childlinenum;
                            }else{
                                child = child + childseparate + "  ";
                            }
                        }
					}
				});
				$('.Sub-'+rowIndex).datagrid('uncheckAll');
			}
			referenceChild[rowIndex] = child;
		}
	});       
}

//关联医嘱父项在前的引用格式
function getParentSeqData(id,checkedItems,refScheme,refSubScheme,separate,childseparate,childlinenum)
{
    //序号勾选标识
    var numFlag = $("#orderNum")[0].checked;
	var result = "",num = 1;
	for (j=0;j<rowArray.length;j++ ){
		var i = rowArray[j];
		if ((referenceParent[i] != "")||(referenceChild[i] != ""))
		{
            if (numFlag){
                result = result + num + ".";
            }
            result = result + referenceParent[i];
            
            if (referenceChild[i] != "")
            {
                if (referenceParent[i] != "")
                {
                    result = result + childseparate;
                }
                if (childlinenum != ""){
                    $.each(referenceChild[i].split(childlinenum), function(index, item){
                        if (numFlag){
                            var childNum = index + 1;
                            result = result + num + "." + childNum;
                        }
                        result = result + "  " + item;
                    });
                }else{
                    result = result + "  " + referenceChild[i];
                }
			}
			result = result + separate;
			num = num + 1;
		}
	}
	return result;     
}
//关联医嘱子项在前的引用格式
function getChildSeqData(id,checkedItems,refScheme,refSubScheme,separate)
{
    //序号勾选标识
    var numFlag = $("#orderNum")[0].checked;
	var result = "",num = 1;
	for (j=0;j<rowArray.length;j++ ){
		var i = rowArray[j];
		if ((referenceParent[i] != "")||(referenceChild[i] != ""))
		{
            if (numFlag){
                result = result + num + ".";
            }
			result = result + referenceChild[i];
			if ((referenceChild[i] != "")&&(referenceParent[i] != ""))
			{
				result = result + "入";
			}
			result = result + referenceParent[i];
			result = result + separate;
			num = num + 1;
		}
	}
	return result; 
}

function setArrValue(data)
{
	if(data.length == 0) return
	for(var i = 0; i < data.length; i++)
	{
		data[i].OrdCreateDateTime = data[i].OrdCreateDate+" "+data[i].OrdCreateTime
	}
	return data
}

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


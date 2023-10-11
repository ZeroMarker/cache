var returnValue = {};
//returnValue.checkStatu = "True";
var dataStr = '';
var partDataStr = '';
var nullDataStr = '';
/*** 同步数据界面部分规则
*1.对于当前病历上的值是“-”，来源值是空值时，过滤掉，不会传到这个同步数据界面来
*2.同步数据界面对数据进行分类，分成三个页签，
*	（显示全部、显示非空来源值（NewValue不为空）、显示空来源值（NewValue为空）），以下称为第一、第二、第三页签
*3.在数据同步界面打开时，默认加载第二页签，但是如果非空来源值页签没有数据，则不会自动弹出的
*4.对于第二、第三页签，用户可以对页签内具体一条或多条数据进行点击“默认不再提示选中项”操作，
*	则选中的数据就不会出现在第二或第三页签中，（在第一页签中可见，并标注为红色）
*5.不管当前在哪个页签中，数据是否标注红色，都可以选中一条或多条进行“同步数据”操作；
***/

$(function(){
	//dataStr = parent.dataObjStr;
	dataStr = window.top.dataObjStr;
	window.top.dataObjStr = "";
	//dataStr = {"AutoRefresh":"true","SyncDialogVisible":"true"," SilentRefresh ":"false","result":"OK","Items":[{"SectionName":"基本信息","SectionCode":"S001","DisplayName":"姓名","Path":"S001_V001_L0001","OldValue":"张三李四王五赵六张三李四王五赵六","NewValue":"李四"},{"SectionName":"基本信息","SectionCode":"S001","DisplayName":"姓名","Path":"S001_V001_L0001","OldValue":"张三 ","NewValue":""}]}
	
	//setBouncedStatu();	//设置下次不再询问的状态
	
	dataStr.total = dataStr.Items.length;
	dataStr = JSON.parse(JSON.stringify(dataStr).replace(/Items/g, "rows"));
	
	//把NewValue不是空值的数据拷贝到partDataStr,空值拷贝到nullDataStr中	(不包含医生勾选默认不显示的数据)
	partDataStr = {
			rows:[],
			total:0
		};
	nullDataStr = {
			rows:[],
			total:0
		};
	
	jQuery.ajax({
		type : "GET", 
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls",
		async : false,
		data : {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLRefreshDataHidden",
				"Method":"GetAllCodeByInstanceID",	
				"p1":InstanceID
			},
		success : function(d) {
			var Codes = d.split("^");
			for (var i=0;i<dataStr.total;i++)
			{
				if(Codes.indexOf(dataStr.rows[i].Code) == -1)	//把医生勾选默认不显示项去除掉
				{
					if(dataStr.rows[i].NewValue != "")
					{
						partDataStr.total++;
						partDataStr.rows.push(dataStr.rows[i]);
					}else{
						nullDataStr.total++;
						nullDataStr.rows.push(dataStr.rows[i]);
					}
				}
				else
				{
					dataStr.rows[i].flag = 1;
				}
			}
		}
	})
	
	$('#differentData').datagrid({
	    loadMsg:'数据装载中......',
	    autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		fit:true,
	    columns:[[
	    		{field:'ck',checkbox:"true"},
				{field:'SectionName',title:'章节名称',width:100, formatter: function (value,row,index) {
						if (row.flag == 1){
	                		return "<span style='color:red'>" + value + "</span>";
						}else{
							return value;
						}
	            	}
				},
				{field:'DisplayName',title:'元素名称',width:100, formatter: function (value,row,index) {
	                	if (row.flag == 1){
	                		return "<span style='color:red'>" + value + "</span>";
						}else{
							return value;
						}
	            	}
				},
				{field:'OldValue',title:'当前病历值',width:200, formatter: function (value,row,index) {
	                	if (row.flag == 1){
	                		return "<span style='color:red' title='" + value + "'>" + value + "</span>";
						}else{
							return "<span title='" + value + "'>" + value + "</span>";
						}
	            	}
				},
				{field:'NewValue',title:'数据来源值',width:200, formatter: function (value,row,index) {
	                	if (row.flag == 1){
	                		return "<span style='color:red' title='" + value + "'>" + value + "</span>";
						}else{
							return "<span title='" + value + "'>" + value + "</span>";
						}
	            	}
				} 
		]], 
		onSelect:function(rowIndex, rowData)
		{
			$("div").remove("#textContent div");
			$("#textContent").append("<div><div class='textConcentDiv'>"+emrTrans("当 前 病 历 值：")+"</div><div class='textConcentDiv'>"+rowData.OldValue+"</div></div>");
			$("#textContent").append("<div class='textConcentDiv'>"+emrTrans("数 据 来 源 值：")+"</div><div class='textConcentDiv'>"+rowData.NewValue+"</div>");
		},
		onUnselect:function(rowIndex, rowData)
		{
			$("div").remove("#textContent div");
			$("#textContent").append("<div style='padding-bottom:10px;'>"+emrTrans("当 前 病 历 值：")+"</div>");
			$("#textContent").append("<div style='padding-bottom:10px;'>"+emrTrans("数 据 来 源 值：")+"</div>");
		}
	});
	
	$HUI.radio("[name='dataType']",{
	    onChecked:function(e,value){
            var ID = $(e.target).attr("id");
            if (ID == "all")	//显示全部
			{
				$('#differentData').datagrid("loadData",dataStr);
				$('#noShowSelected').hide();
			}
			else if(ID == "notEmpty")	//显示来源值不是空值数据
			{
				$('#differentData').datagrid("loadData",partDataStr);
				$('#noShowSelected').show();
			}
			else	//显示来源值是空值数据
			{
				$('#differentData').datagrid("loadData",nullDataStr);
				$('#noShowSelected').show();
			}
	    }
    });	 
    /*
    if (partDataStr.rows.length !== 0)
    {
	    $HUI.radio("#notEmpty").setValue(true);
	}
	else
	{
		$HUI.radio("#empty").setValue(true);
	}*/
	//优化为默认为非空页面，空值在实际业务中属于特殊场景的页面，不作为默认值。
	$HUI.radio("#notEmpty").setValue(true);
	
	$("#textContent").append("<div style='padding-bottom:10px;'>"+emrTrans("当 前 病 历 值：")+"</div>");
	$("#textContent").append("<div style='padding-bottom:10px;'>"+emrTrans("数 据 来 源 值：")+"</div>");
});

//同步数据
document.getElementById("synData").onclick = function(){
	var updataStr = $("#differentData").datagrid('getSelections');
	var pathAndValueStr = [];
	if (updataStr.length !== 0)
	{
		//for循环取path和value和BindCode、BindRowID
		for (var i=0;i<updataStr.length;i++)
		{
			var pathAndValue = {};
			pathAndValue.Path = updataStr[i].Path;
			pathAndValue.Value = updataStr[i].NewValue;
			pathAndValue.BindCode = updataStr[i].BindCode;
			pathAndValue.BindRowID = updataStr[i].BindRowID;
			pathAndValueStr.push(pathAndValue);
		}
		//checkStatu();
		returnValue.updataStr = pathAndValueStr;
		closeWindow();
	}else{
		top.$.messager.alert("提示","请选择需要更新的数据!");
	}
}

//退出
document.getElementById("btnCancel").onclick = function(){
	//checkStatu();
	closeWindow();
}

//医生勾选默认不显示
document.getElementById("noShowSelected").onclick = function(){
	var noShowStr = $("#differentData").datagrid('getSelections');
	var noShowCodes = '';
	if (noShowStr.length == 0) return;
	for (var i=0;i<noShowStr.length;i++)
	{
		if (i==0)
		{
			noShowCodes = noShowStr[i].Code;
		}else{
			noShowCodes = noShowCodes + "^" + noShowStr[i].Code;
		}
	}
	jQuery.ajax({
		type : "GET", 
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls",
		async : false,
		data : {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLRefreshDataHidden",
				"Method":"InsertData",	
				"p1":InstanceID,
				"p2":noShowCodes
			},
		success : function(d) {
			if(d == 1)
			{
				var Codes = noShowCodes.split("^");
				var tempPartDataStr = {rows:[],total:0};
				for (var i=0; i<partDataStr.rows.length; i++)
				{
					if (Codes.indexOf(partDataStr.rows[i].Code) == -1)	
					{
						tempPartDataStr.rows.push(partDataStr.rows[i]);
						tempPartDataStr.total++;
					}
				}
				var tempNullDataStr = {rows:[],total:0};
				for (var i=0; i<nullDataStr.rows.length; i++)
				{
					if (Codes.indexOf(nullDataStr.rows[i].Code) == -1)	
					{
						tempNullDataStr.rows.push(nullDataStr.rows[i]);
						tempNullDataStr.total++;
					}
				}
				partDataStr = tempPartDataStr;
				nullDataStr = tempNullDataStr;
				var dataTypeId = $HUI.radio("[name='dataType']:checked").jdata.options.id;
				if (dataTypeId == "notEmpty")	//显示来源值不是空值数据
				{
					$('#differentData').datagrid("loadData",partDataStr);
				}
				else	//显示来源值是空值数据
				{
					$('#differentData').datagrid("loadData",nullDataStr);
				}
				for (var i=0; i<dataStr.total; i++)
				{
					if(Codes.indexOf(dataStr.rows[i].Code) !== -1)
					{
						dataStr.rows[i].flag = 1;
					}
				}
			}
		}
	})

}

//数据来源值空值不显示
/*document.getElementById("filterNull").onclick = function(){
	var filterNull = $("#filterNull")[0].checked;
	if (filterNull)
	{
		$('#differentData').datagrid("loadData",partDataStr);
	}
	else
	{
		$('#differentData').datagrid("loadData",dataStr);
	}
}*/

//下次是否询问
/* document.getElementById("bounced").onclick = function(){
	checkStatu();
}
 */
//取下次是否询问表中状态值
/* function setBouncedStatu()
{
	//var InstanceID = parent.getLastInstanceID().InstanceID;
	jQuery.ajax({
		type : "GET", 
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls",
		async : true,
		data : {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLRefreshBindData",
				"Method":"getBindDataSyncDialogVisible",			
				"p1":InstanceID
			},
		success : function(d) {
           if (d == "True") $('#bounced').checkbox({checked: false});
           else if(d == "False") $('#bounced').checkbox({checked: true});
		}
	});	
}
 */
//记录下次是否询问的状态
/* function checkStatu()
{
	var checkStatu = $("#bounced")[0].checked;
	if (checkStatu) checkStatu = "False";
	if (!checkStatu) checkStatu = "True";
	returnValue.checkStatu = checkStatu;
}
 */
//关闭窗口
function closeWindow()
{
	//parent.closeDialog("dialogSynData");
	closeDialogTop("dialogSynData");
}


///modified by ZY0247  2020-12-14
var editFlag="undefined";
$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initMessage("BenefitEquipList");
	defindTitleStyle();
	initButtonWidth();
	initButton(); //按钮初始化
    setElementEnabled(); //输入框只读控制 
    initEvent();
	$HUI.datagrid("#tDHCEQUsedResourceList",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQUsedResource",
	        	QueryName:"GetUsedResourceFeeDetail",
	        	SourceType:getElementValue("SourceType"),
	        	SourceID:getElementValue("SourceID"),
	        	Year:getElementValue("Year"),
	        	Month:getElementValue("Month")
			},
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fit:true,
			border:false,
			//columns:Columns,
			columns:[[
				{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
				{field:'TTypeRowID',title:'TTypeRowID',width:50,align:'center',hidden:true},
				{field:'TTypeCode',title:'资源代码',width:100,align:'center'},
				{field:'TTypeDesc',title:'资源类型',width:100,align:'center'},
				{field:'TAmount',title:'金额',width:100,align:'center',editor:{type: 'text',options: {required: true	}}},
			]],
	    	onClickRow: function (rowIndex,rowData) {//onClickDeviceMapRow(rowIndex,rowData)
	    		if (editFlag!="undefined")
		    	{
	                $('#tDHCEQUsedResourceList').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
		    //modifed BY ZY0217 2020-04-08
	            else if(rowData.TTypeCode!="05")
	            {
		            $('#tDHCEQUsedResourceList').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }},
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
};
function setElementEnabled()
{
	if(jQuery("#Year").val()!="")jQuery("#Year").attr("disabled", "disabled");
	if(jQuery("#Month").val()!="")jQuery("#Month").attr("disabled", "disabled");
}

function initEvent() 
{	
	if (jQuery("#BGatherResource").length>0)
	{
		jQuery("#BGatherResource").on("click", BGatherResource_Clicked);
	}
}


function BSave_Clicked()
{
	if(editFlag>="0"){
		$('#tDHCEQUsedResourceList').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQUsedResourceList').datagrid('getChanges');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var SourceType=getElementValue("SourceType")
	var SourceID=getElementValue("SourceID")
	var Year=getElementValue("Year")
	var Month=getElementValue("Month")
	if((Year=="")||(Month=="")){
		jQuery.messager.alert("提示","年月不能为空!");
		return;
	}
	var dataList=""
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.TAmount=="")
		{
			alertShow("第"+(i+1)+"行数据金额不能为空!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUsedResource","SaveUsedResource",Year,Month,SourceType,SourceID,dataList,"Y");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		setElementEnabled()
		var val="&SourceType="+SourceType+'&SourceID='+SourceID+"&Year="+Year+'&Month='+Month;
		var url="dhceq.ba.usedresourcelist.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		///modified by ZY0254 20210203
        websys_showModal("options").mth();
		window.location.reload(url);
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	var rows = $('#tDHCEQUsedResourceList').datagrid('getSelected');  //选中要删除的行
	///modified by ZY0254 20210203
	if((rows==null)||(rows.length<=0)){
		alertShow("请选择要删除的行.");
		return;
	}
	var DeleteRowID=(typeof rows.TRowID == 'undefined') ? "" : rows.TRowID
	if (DeleteRowID=="")
	{
		if(editDeviceMapIndex>="0"){
			$("#tDHCEQUsedResourceList").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
			if(editFlag>="1")$("#tDHCEQUsedResourceList").datagrid('deleteRow',editFlag)
		}
		///modified by ZY0254 20210203
		alertShow("当前行数据为空,不能删除.");
		return
	}
	else
	{
		var truthBeTold = window.confirm(t[-9203]);
		if (!truthBeTold) return;
		
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUsedResource","SaveData","","","","","","",DeleteRowID,"1");
		if (jsonData==0)
		{
			messageShow("","","","操作成功!");
			var val="&SourceType="+getElementValue("SourceType")+'&SourceID='+getElementValue("SourceID")+"&Year="+getElementValue("Year")+'&Month='+getElementValue("Month");
			var url="dhceq.ba.usedresourcelist.csp?"+val;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			///modified by ZY0254 20210203
        	websys_showModal("options").mth();
			window.location.reload(url);
		}
		else
	    {
			messageShow("","","","错误信息:"+jsonData);
			return
	    }
	}
	
}
function BGatherResource_Clicked()
{
	var SourceType=getElementValue("SourceType")
	var SourceID=getElementValue("SourceID")
	var Year=getElementValue("Year")
	var Month=getElementValue("Month")
	if((Year=="")||(Month=="")){
		jQuery.messager.alert("提示","年月不能为空!");
		return;
	}
	var dataList=""
	var rows = $('#tDHCEQUsedResourceList').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有需要提取的资源类型数据!");
		return;
	}
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	///modified by ZY0269 20210615
	messageShow("confirm","info","提示","是否保留界面录入的数值?","",function(){
		var InputFlag="Y";
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUsedResource","SaveUsedResource",Year,Month,SourceType,SourceID,dataList,InputFlag);
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
		{
			setElementEnabled()
			var val="&SourceType="+SourceType+'&SourceID='+SourceID+"&Year="+Year+'&Month='+Month;
			var url="dhceq.ba.usedresourcelist.csp?"+val;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			///modiefied by ZY0255 20210228
	    	websys_showModal("options").mth();
			window.location.reload(url);
		}
		else
	    {
			alertShow("错误信息:"+jsonData.Data);
			return
	    }
	},function(){
		var InputFlag="N";
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUsedResource","SaveUsedResource",Year,Month,SourceType,SourceID,dataList,InputFlag);
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
		{
			setElementEnabled()
			var val="&SourceType="+SourceType+'&SourceID='+SourceID+"&Year="+Year+'&Month='+Month;
			var url="dhceq.ba.usedresourcelist.csp?"+val;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			///modiefied by ZY0255 20210228
	    	websys_showModal("options").mth();
			window.location.reload(url);
		}
		else
	    {
			alertShow("错误信息:"+jsonData.Data);
			return
	    }
	},"保留","取消");
}
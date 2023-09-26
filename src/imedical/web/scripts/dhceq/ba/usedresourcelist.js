var HSColumns=getCurColumnsInfo('BA.G.EquipSercie.ServiceItem','','','')
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
				{field:'TTypeCode',title:'资源代码',width:100,align:'center',hidden:true},
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
	var dataList=""
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.TAmount=="")
		{
			alertShow("第"+(i+1)+"行数据不正确!")
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
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUsedResource","SaveUsedResource",Year,Month,SourceType,SourceID,dataList);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		setElementEnabled()
		var val="&SourceType="+SourceType+'&SourceID='+SourceID+"&Year="+Year+'&Month='+Month;
		url="dhceq.ba.usedresourcelist.csp?"+val;
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
	
}
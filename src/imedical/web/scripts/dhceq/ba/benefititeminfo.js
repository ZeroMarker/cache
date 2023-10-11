var editFlag="undefined";
var Columns=getCurColumnsInfo('BA.G.BenefitSummary.BenefitItemInfo','','','')
jQuery(document).ready(function()
{
	initUserInfo();
    initMessage("BA"); //获取所有业务消息
	//initLookUp();
	//defindTitleStyle();
	//fillData(); //数据填充
	//showFieldsTip();
    //setEnabled(); //按钮控制
    initApproveButtonNew(); //初始化审批按钮
    initButton();
	initButtonWidth();	
	$HUI.datagrid("#tDHCEQBenefititeminfo",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSBenefitSummary",
	        	QueryName:"GetBenefitItemInfo",
				UseContextDR:getElementValue("UCRowID")
		},
    	border:'true',
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		columns:Columns,
	    onClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    	if (editFlag!="undefined")
	    	{
                $('#tDHCEQBenefititeminfo').datagrid('endEdit', editFlag);
                editFlag="undefined"
            }
            else
            {
	            $('#tDHCEQBenefititeminfo').datagrid('beginEdit', rowIndex);
	            editFlag =rowIndex;
	        }
        },
		toolbar:[
			{
				id:"save",
				iconCls:'icon-save',
				text:'保存',
				handler:function(){SaveGridData();}
			}
			
		],
		pagination:true,
		pageSize:18,
		pageNumber:18,
		pageList:[18,36,54,72,90]
	});
	setEnabled()
	}
)
function SaveGridData()
{
	var dataList=""
	var rows = $('#tDHCEQBenefititeminfo').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.BIIScore=="")
		{
			alertShow("第"+(i+1)+"行分数为空!")
			return "-1"
		}
		if ((oneRow.BIIScore>oneRow.BIMaxScore)||(oneRow.BIIScore<oneRow.BIMinScore))
		{
			alertShow("第"+(i+1)+"行分数不在规定范围内!")
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
	if (dataList=="")
	{
		alertShow("数据明细不能为空!");
		return;
	}
	var UCRowID=getElementValue("UCRowID")
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitSummary","SaveBenefitItemInfo",dataList,UCRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&UCRowID="+jsonData.Data
		url="dhceq.ba.benefititeminfo.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
		parent.opener.location.reload= 'dhceq.ba.benefitsummary.csp?RowID='+getElementValue("BenefitSummaryDR");
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function setEnabled()
{
	var Status=getElementValue("Status")
	if (Status>0)
	{
		disableElement("save",true)
	}
}

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
	initButton(); //��ť��ʼ��
    setElementEnabled(); //�����ֻ������ 
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
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
			singleSelect:true,
			fit:true,
			border:false,
			//columns:Columns,
			columns:[[
				{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
				{field:'TTypeRowID',title:'TTypeRowID',width:50,align:'center',hidden:true},
				{field:'TTypeCode',title:'��Դ����',width:100,align:'center'},
				{field:'TTypeDesc',title:'��Դ����',width:100,align:'center'},
				{field:'TAmount',title:'���',width:100,align:'center',editor:{type: 'text',options: {required: true	}}},
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
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var SourceType=getElementValue("SourceType")
	var SourceID=getElementValue("SourceID")
	var Year=getElementValue("Year")
	var Month=getElementValue("Month")
	if((Year=="")||(Month=="")){
		jQuery.messager.alert("��ʾ","���²���Ϊ��!");
		return;
	}
	var dataList=""
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.TAmount=="")
		{
			alertShow("��"+(i+1)+"�����ݽ���Ϊ��!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUsedResource","SaveUsedResource",Year,Month,SourceType,SourceID,dataList,"Y");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		setElementEnabled()
		var val="&SourceType="+SourceType+'&SourceID='+SourceID+"&Year="+Year+'&Month='+Month;
		var url="dhceq.ba.usedresourcelist.csp?"+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		///modified by ZY0254 20210203
        websys_showModal("options").mth();
		window.location.reload(url);
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	var rows = $('#tDHCEQUsedResourceList').datagrid('getSelected');  //ѡ��Ҫɾ������
	///modified by ZY0254 20210203
	if((rows==null)||(rows.length<=0)){
		alertShow("��ѡ��Ҫɾ������.");
		return;
	}
	var DeleteRowID=(typeof rows.TRowID == 'undefined') ? "" : rows.TRowID
	if (DeleteRowID=="")
	{
		if(editDeviceMapIndex>="0"){
			$("#tDHCEQUsedResourceList").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
			if(editFlag>="1")$("#tDHCEQUsedResourceList").datagrid('deleteRow',editFlag)
		}
		///modified by ZY0254 20210203
		alertShow("��ǰ������Ϊ��,����ɾ��.");
		return
	}
	else
	{
		var truthBeTold = window.confirm(t[-9203]);
		if (!truthBeTold) return;
		
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUsedResource","SaveData","","","","","","",DeleteRowID,"1");
		if (jsonData==0)
		{
			messageShow("","","","�����ɹ�!");
			var val="&SourceType="+getElementValue("SourceType")+'&SourceID='+getElementValue("SourceID")+"&Year="+getElementValue("Year")+'&Month='+getElementValue("Month");
			var url="dhceq.ba.usedresourcelist.csp?"+val;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
			///modified by ZY0254 20210203
        	websys_showModal("options").mth();
			window.location.reload(url);
		}
		else
	    {
			messageShow("","","","������Ϣ:"+jsonData);
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
		jQuery.messager.alert("��ʾ","���²���Ϊ��!");
		return;
	}
	var dataList=""
	var rows = $('#tDHCEQUsedResourceList').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û����Ҫ��ȡ����Դ��������!");
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
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
		}
	}
	///modified by ZY0269 20210615
	messageShow("confirm","info","��ʾ","�Ƿ�������¼�����ֵ?","",function(){
		var InputFlag="Y";
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUsedResource","SaveUsedResource",Year,Month,SourceType,SourceID,dataList,InputFlag);
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
		{
			setElementEnabled()
			var val="&SourceType="+SourceType+'&SourceID='+SourceID+"&Year="+Year+'&Month='+Month;
			var url="dhceq.ba.usedresourcelist.csp?"+val;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
			///modiefied by ZY0255 20210228
	    	websys_showModal("options").mth();
			window.location.reload(url);
		}
		else
	    {
			alertShow("������Ϣ:"+jsonData.Data);
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
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
				url += "&MWToken="+websys_getMWToken()
			}
			///modiefied by ZY0255 20210228
	    	websys_showModal("options").mth();
			window.location.reload(url);
		}
		else
	    {
			alertShow("������Ϣ:"+jsonData.Data);
			return
	    }
	},"����","ȡ��");
}
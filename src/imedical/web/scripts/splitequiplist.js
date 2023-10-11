///拆分明细设备
///Add By czf 2014955 2021-07-04
var editIndex=undefined;
var Columns=getCurColumnsInfo('EM.G.Split.SplitEquipList','','','');
$(function(){
	initDocument();
	if (getElementValue("Status")>0) disableElement("update",true);	
});
function initDocument()
{
	initUserInfo();
	$HUI.datagrid("#DHCEQSLEquipListGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSSplit",
			QueryName:"GetEquipsBySplit",
			MainEquipNo:getElementValue("EquipNo"),
			SourceID:getElementValue("SourceID"),
			QuantityNum:getElementValue("QuantityNum"),
			Job:getElementValue("Job"),
			Index:getElementValue("Index")
		},
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
	    toolbar:[
		    {
				iconCls: 'icon-save',
	            text:'更新',
	            id:'update',       
	            handler: function(){
	                 updateRow();
	            }
	        }
        ],
		fitColumns:true, 
	    columns:Columns,
		pagination:true,
		pageSize:30,
		pageNumber:1,
		pageList:[30,60,100]
	});
}
function onClickRow(index)
{
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#DHCEQSLEquipListGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			//modifyBeforeRow = $.extend({},$('#DHCEQUpdateEquipsByList').datagrid('getRows')[editIndex]);
		} else {
			$('#DHCEQSLEquipListGrid').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQSLEquipListGrid').datagrid('validateRow', editIndex)){
		$('#DHCEQSLEquipListGrid').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function updateRow()
{	
	if (editIndex != undefined){ $('#DHCEQSLEquipListGrid').datagrid('endEdit', editIndex);}

	var rows = $("#DHCEQSLEquipListGrid").datagrid("getRows");
	//var TJob=rows[0].TJob;
	//setElement("Job",TJob);
	
	var EquipNo=getElementValue("EquipNo");
	var SourceID=getElementValue("SourceID");
	var QuantityNum=getElementValue("QuantityNum");
	var Job=getElementValue("Job");
	var Index=getElementValue("Index");
	var Type=getElementValue("Type");
	var ListInfo = ""
	var RtnMsg = ""
	for (i=0;i<rows.length;i++)
	{
		$('#DHCEQUpdateEquipsByList').datagrid('endEdit', i)
		var TRowID=rows[i].TRowID;
		var listInfo=TRowID;
		var TEquipNo=rows[i].TEquipNo;
		var TLeavefactoryNo=rows[i].TLeavefactoryNo;
		var TFileNo=rows[i].TFileNo;
		var List = TRowID+"^"+TEquipNo+"^"+TLeavefactoryNo+"^"+TFileNo;
		if(ListInfo == ""){
			ListInfo = List;
		}else{
			ListInfo = ListInfo +getElementValue("SplitRowCode")+ List;
		}
		
		/*
		var rtn=CheckLeaveFactoryNo(ListInfo);
		if (rtn!="1") return;
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSSplit","UpdateLeaveFactoryNo",List);
		if (result!=0){
			messageShow('alert','error','提示',"出厂编号更新失败!");
		}
		*/
		
		var Num=i;
		var MXInfo=Job+"^"+Index+"^"+Num+"^"+SourceID+"^"+Type+"^"+EquipNo;		//czf 2021-08-04
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSSplit","UpdateEquipsByList",List,MXInfo,curUserID);
		if (result!=0) RtnMsg=RtnMsg+","+result
	}
	if (RtnMsg=="")
	{
		var val="&Job="+Job;
		val=val+"&Index="+Index;
		val=val+"&SourceID="+SourceID;
		val=val+"&EquipNo="+EquipNo;
		val=val+"&QuantityNum="+QuantityNum;
		val=val+"&Status="+getElementValue("Status");
		val=val+"&Type="+Type;
		var url='dhceq.em.splitequiplist.csp?'+val;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
	else
	{
		messageShow('alert','error','提示',"更新失败!");
	}
}

function CheckLeaveFactoryNo(value)
{
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSUpdateEquipByList","CheckLeaveFactoryNo",value);
	if (result!=0)
	{
		var list=result.split("^");
		var msg="";
		if (list[0]=="1")
		{	msg="待更新的出厂编号中有重复编号:"+list[1];}
		else
		{	msg="已有设备使用此出厂编号:"+list[1];		}
		
		var truthBeTold = window.confirm(msg+",是否继续更新保存?");
    	if (!truthBeTold) return 0;
	}
	return 1;
}

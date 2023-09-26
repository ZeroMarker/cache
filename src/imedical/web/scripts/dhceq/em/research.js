
var editFlag="undefined";
var Selectindex="";	//modified by zy ZY0223 2020-04-17
var Columns=getCurColumnsInfo('EM.G.Research','','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

//modify by wl 2020-1-21  增加BussType,RFunProFlag
function initDocument()
{
	initUserInfo();
    initMessage("BuyRequest"); //获取所有业务消息
    //initLookUp();
	defindTitleStyle(); 
    //initButton();
    //initButtonWidth();
	$HUI.datagrid("#tDHCEQResearch",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSResearch",
	        QueryName:"ResearchList",
	        BussType:getElementValue("BussType"), 		        
	        SourceType:getElementValue("SourceType"),
	        SourceID:getElementValue("SourceID"),
	        RFunProFlag:getElementValue("RFunProFlag")
			},
			fit:true,
			//border:false,	//modified zy ZY0215 2020-04-01
			fitColumns : true,    //add by lmm 2020-06-04
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			toolbar:[{
				iconCls:'icon-add',
				text:'新增',
				id:"add",
				handler:function(){insertRow();}
			},
			{
				iconCls:'icon-save',
				text:'保存',
				id:"save",
				handler:function(){SaveData();}
			},
			{
                iconCls: 'icon-cancel',
				text:'删除',
				id:"delete",
				handler:function(){DeleteData();}
			}],
			columns:Columns,
			pageSize:20,  // 每页显示的记录条数
			pageList:[20],   // 可以设置每页记录条数的列表
	        singleSelect:true,
			loadMsg: '正在加载信息...',
			pagination:true,
		    onClickRow: function (rowIndex, rowData) {//双击选择行编辑
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQResearch').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQResearch').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        },
			onSelect:function(index,row){ 
				//modified by zy ZY0223 2020-04-17
				if (Selectindex!=index)
				{
					Selectindex=index
				}
				else
				{
					Selectindex=""
				}
			}
	});
	if (getElementValue("ReadOnly")==1)
	{
		$("#add").linkbutton("disable");
		$("#save").linkbutton("disable");
		$("#delete").linkbutton("disable");
	}
	if(getElementValue("RFunProFlag")=="1")
	{//RUsedFlag,RInvalidFlag RUserDR_UName
		$("#tDHCEQResearch").datagrid('hideColumn','RTypeDesc');
		$("#tDHCEQResearch").datagrid('hideColumn','RLevel');
		$("#tDHCEQResearch").datagrid('hideColumn','RUsedFlag');
		$("#tDHCEQResearch").datagrid('hideColumn','RInvalidFlag');
		$("#tDHCEQResearch").datagrid('hideColumn','RUserDR_UName');
		$("#tDHCEQResearch").datagrid('hideColumn','RParticipant');
		$("#tDHCEQResearch").datagrid('hideColumn','RBeginDate');
		$("#tDHCEQResearch").datagrid('hideColumn','REndDate');
	}
	else
	{
		//RDevelopStatusDesc
		$("#tDHCEQResearch").datagrid('hideColumn','RDevelopStatusDesc');
		//add by zy ZY0224 2020-04-26
		$("#tDHCEQResearch").datagrid('hideColumn','RUsedFlag');
	}
	
}

// 插入新行
//modify by wl 2020-1-21 修改字段名称 增加BussType
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQResearch").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
    var rows = $("#tDHCEQResearch").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var RDesc = (typeof rows[lastIndex].RDesc == 'undefined') ? "" : rows[lastIndex].RDesc;
    var RLevel = (typeof rows[lastIndex].RLevel == 'undefined') ? "" : rows[lastIndex].RLevel;
    
    if ((RDesc=="")&&(RLevel==""))
    {
	    messageShow('alert','error','错误提示','第'+newIndex+'行数据为空!请先填写数据.');
	}
	else
	{
		$("#tDHCEQResearch").datagrid('insertRow', {index:newIndex,row:{}});
		editFlag=0;
	}
}
// 保存编辑行
//modify by wl 2020-1-21 修改字段名称 增加BussType
function SaveData()
{
	if(editFlag>="0"){
		$('#tDHCEQResearch').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQResearch').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList=""
	for (var i = 0; i < rows.length; i++) 
	{
		//add by zy ZY0224 2020-04-26
		var RFunProFlag=getElementValue("RFunProFlag")
		rows[i].RBussType=getElementValue("BussType");
		rows[i].RSourceType=getElementValue("SourceType")
		rows[i].RSourceID=getElementValue("SourceID")
		rows[i].RFunProFlag=RFunProFlag
		//var RFunProFlag=(typeof rows[i].RFunProFlag == 'undefined') ? "" : rows[i].RFunProFlag
		var RDesc=(typeof rows[i].RDesc == 'undefined') ? "" : rows[i].RDesc
		var RTypeDesc=(typeof rows[i].RTypeDesc == 'undefined') ? "" : rows[i].RTypeDesc
		var RDevelopStatus=(typeof rows[i].RDevelopStatus == 'undefined') ? "" : rows[i].RDevelopStatus
		
		var oneRow=rows[i]

		if(RFunProFlag=="1")
		{ 
			oneRow.RType="2";
			if (RDevelopStatus=="")
			{
				alertShow("第"+(i+1)+"行新开发功能标记不能为空!")
				return "-1"
			}
		}
		else
		{
			if (RTypeDesc=="")
			{
				alertShow("第"+(i+1)+"行功能类型标记不能为空!")
				return "-1"
			}
		}
		if (RDesc=="")
		{
			alertShow("第"+(i+1)+"行名称不能为空!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+"&"+RowData
		}
	}
	if (dataList=="")
	{
		alertShow("明细不能为空!");
		//return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSResearch","SaveData",dataList);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var BussType=getElementValue("BussType")
		var SourceType=getElementValue("SourceType");
		var SourceID=getElementValue("SourceID"); 
		//add by zy ZY0224 2020-04-26
		var RFunProFlag=getElementValue("RFunProFlag")
		//modify by wl 2020-2-12
		var val="BussType="+BussType+"&SourceType="+SourceType+"&SourceID="+SourceID+"&RFunProFlag="+RFunProFlag;
		url="dhceq.em.research.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth(RFunProFlag);
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}

//modified by ZY0223 2020-04-17 删除逻辑bug
//******************************************/
// 删除选中行
// 修改人：JYP
// 修改时间：2016-9-1
// 修改描述：添加了判断，使其可以删除空行
//******************************************/
//modify by wl 2020-1-21 增加BussType
function DeleteData()
{
	var rows = $('#tDHCEQResearch').datagrid('getSelected'); //选中要删除的行
	if(rows.length<=0){
		alertShow("请选择要删除的项.");
		return;
	}
	var RowID=(typeof rows.RRowID == 'undefined') ? "" : rows.RRowID
	if (RowID=="")
	{
		if(Selectindex>="0"){
			$("#tDHCEQResearch").datagrid('endEdit', Selectindex);//结束编辑，传入之前编辑的行
			if(Selectindex>="1")$("#tDHCEQResearch").datagrid('deleteRow',Selectindex)
		}
		return
	}
	else
	{
		Selectindex=RowID
		messageShow("confirm","","",t[-9203],"",confirmFun,"")
	}
	
}
//modified by ZY0222 2020-04-16
function confirmFun()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSResearch","SaveDataList",Selectindex,"1");
	//jsonData=JSON.parse(jsonData)
	//if (jsonData.SQLCODE==0)
	if (jsonData==0)
	{
		var BussType=getElementValue("BussType")
		var SourceType=getElementValue("SourceType");
		var SourceID=getElementValue("SourceID"); 
		//add by zy ZY0224 2020-04-26
		var RFunProFlag=getElementValue("RFunProFlag")
		//modified by ZY0219 2020-04-13
		var val="BussType="+BussType+"&SourceType="+SourceType+"&SourceID="+SourceID+"&RFunProFlag="+RFunProFlag;
		url="dhceq.em.research.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth(RFunProFlag);
	}
	else
    {
		alertShow("错误信息:"+jsonData);
		return
    }
}
//add by wl 2020-1-21 
function GetResearchType(index,data)
{ 
	var rowData = $('#tDHCEQResearch').datagrid('getSelected');
	rowData.RType=data.TRowID;
	var RTypeEdt = $("#tDHCEQResearch").datagrid('getEditor', {index:editFlag,field:'RTypeDesc'});
	$(RTypeEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch').datagrid('endEdit',editFlag);
}
//add by wl 2020-1-21 
function EQUser(index,data)
{ 
	var rowData = $('#tDHCEQResearch').datagrid('getSelected');
	rowData.RUserDR=data.TRowID;
	var RUserEdt = $("#tDHCEQResearch").datagrid('getEditor', {index:editFlag,field:'RUserDR_UName'});
	$(RUserEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch').datagrid('endEdit',editFlag);
}
//add by wl 2020-2-12 
//modify by wl 2020-03-10 删除alert
function GetFuncProjType(index,data)
{ 
	var rowData = $('#tDHCEQResearch').datagrid('getSelected');
	rowData.RDevelopStatus=data.TRowID;
	var RDevelopStatusEdt = $("#tDHCEQResearch").datagrid('getEditor', {index:editFlag,field:'RDevelopStatusDesc'});
	$(RDevelopStatusEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch').datagrid('endEdit',editFlag);
}

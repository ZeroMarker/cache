var preRowID=0
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//初始化查询头面板
function initTopPanel()
{
	initButton(); //按钮初始化 add by wy 2019-4-22
    initButtonWidth();
	jQuery('#BAdd').on("click", BAdd_Clicked);
	initLookUp();
	defindTitleStyle();
	setRequiredElements("User^Group")
	initMessage("");
	initDHCEQCManageLimit();			//初始化表格
	setEnabled();	// MZY0025	1318603		2020-05-13
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	if (vElementID=="Group")
	{
		setElement("Group",item.TGroupName);
		setElement("GroupDR",item.TGroupID);
	}
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function CombineData()
{
	var val="";
	val=getElementValue("RowID");
	val+="^"+getElementValue("UserDR");
	val+="^"+getElementValue("GroupDR");
	val+="^"+getElementValue("RoleDR");
	val+="^"+GetCheckValue("EquipTypeFlag");
	val+="^"+GetCheckValue("StatCatFlag");
	val+="^"+GetCheckValue("EquipCatFlag");
	val+="^"+GetCheckValue("LocFlag");
	val+="^"+GetCheckValue("EquipFlag");
	val+="^"+GetCheckValue("ItemFlag");
	return val;
}
function GetCheckValue(checkName)
{
	return (jQuery("#" + checkName).is(':checked')==true)?"Y":"N";
}
function OnclickRow()
{
	var selected=$('#tDHCEQCManageLimit').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			FillData(selectedRowID)
			setElement("RowID",selectedRowID);
			preRowID=selectedRowID;
			setDisEnabled();	// MZY0025	1318603		2020-05-13
		}
		else
		{
			ClearElement();
			$('#tDHCEQCManageLimit').datagrid('unselectAll');
			selectedRowID = 0;
			preRowID=0;
			setEnabled();	// MZY0025	1318603		2020-05-13
		}
	}
}
function FillData(rowid)
{
	// MZY0022	1306036		2020-05-07	修正取值方式
	var data = tkMakeServerCall("web.DHCEQ.Plat.CTManageLimit", "GetOneManageLimit", rowid);
	var list=data.split("^");
	//messageShow("","","",list)
	setElement("User",list[9]);
	setElement("UserDR",list[0]);
	setElement("Group",list[10]);
	setElement("GroupDR",list[1]);
	setElement("Role",list[11]);
	setElement("RoleDR",list[2]);
	setElement("EquipTypeFlag",list[3]);
	setElement("StatCatFlag",list[4]);
	setElement("EquipCatFlag",list[5]);
	setElement("LocFlag",list[6]);
	setElement("EquipFlag",list[7]);
	setElement("ItemFlag",list[8]);
}
function ClearElement()
{
	setElement("RowID","");
	setElement("User","");
	setElement("UserDR","");
	setElement("Group","");
	setElement("GroupDR","");
	setElement("Role","");
	setElement("RoleDR","");
	setElement("EquipTypeFlag","");
	setElement("StatCatFlag","");
	setElement("EquipCatFlag","");
	setElement("LocFlag","");
	setElement("EquipFlag","");
	setElement("ItemFlag","");
}
function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQCManageLimit",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTManageLimit",
	        QueryName:"GetManageLimit",
	        User:getElementValue("UserDR"),
	        Group:getElementValue("GroupDR"),
	        Role:getElementValue("RoleDR"),
	    },
	})    
}

function BAdd_Clicked()
{
	if (getElementValue("RowID")!=""){
			$.messager.popover({msg:"新增失败,你可能选中一条记录",type:'alert'});
            return false;
    } 
	if (checkMustItemNull()) return;
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Plat.CTManageLimit',
			MethodName:'SaveManageLimit',
			Arg1:CombineData(),
			Arg2:'',
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",XMLHttpRequest.status);
			messageShow("","","",XMLHttpRequest.readyState);
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			data=data.split("^");
			if(data>0)
			{
				$.messager.popover({msg:"保存成功",type:'success'});
				$('#tDHCEQCManageLimit').datagrid('reload');
				ClearElement();
			}
			else
			{
				$.messager.popover({msg:"保存失败",type:'error'});
			}
		}
	});
}
function BSave_Clicked()
{
	if (getElementValue("RowID")==""){
			$.messager.popover({msg:"请选择一行",type:'alert'});
            return false;
    } 
	if (checkMustItemNull()) return;
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Plat.CTManageLimit',
			MethodName:'SaveManageLimit',
			Arg1:CombineData(),
			Arg2:'',
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			data=data.split("^");
			if(data>0)
			{
				$.messager.popover({msg:"保存成功",type:'success'});
				$('#tDHCEQCManageLimit').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.popover({msg:"保存失败",type:'error'});
		}
	});
}
function BDelete_Clicked()
{
	if (getElementValue("RowID")==""){
            $.messager.popover({msg:"请选择一行",type:'alert'}); 
            return false;
    } 
	$.messager.confirm('确认', '您确定要删除所选的行吗？', function(b)
	{
		if (b==false){return;}
        else
        {
		$.ajax({
			url:'dhceq.jquery.method.csp',
			type:'POST',
			data:{
					ClassName:'web.DHCEQ.Plat.CTManageLimit',
					MethodName:'SaveManageLimit',
					Arg1:CombineData(),
					Arg2:'1',
					ArgCnt:2
			},
			beforeSend:function(){$.messager.progress({text:'正在删除中'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data>0)
				{
					$.messager.popover({msg:"删除成功",type:'success'});
					$('#tDHCEQCManageLimit').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.popover({msg:"删除失败",type:'error'});
			}
		});
        }
	});
}
function initDHCEQCManageLimit()
{
	$HUI.datagrid("#tDHCEQCManageLimit",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTManageLimit",
	        QueryName:"GetManageLimit",
	    },
	    fie:true,
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
    	columns:[[
    	{field:'TRowID',title:'TRowID',width:50,hidden:true}, 
    	{field:'TUserDR',title:'TUserDR',width:50,hidden:true},   
        {field:'TUser',title:'操作人',width:60,align:'center'},
        {field:'TGroupDR',title:'TGroupDR',width:50,hidden:true}, 
        {field:'TGroup',title:'安全组',width:95,align:'center'},
        {field:'TRoleDR',title:'TRoleDR',width:50,hidden:true},
        {field:'TRole',title:'角色',width:100,align:'center'},    
        {field:'TEquipTypeFlag',title:'管理类组',width:100,align:'center',formatter: equiptypeOperation},
        {field:'TStatCatFlag',title:'设备类型',width:100,align:'center',formatter: statcatOperation},    
        {field:'TEquipCatFlag',title:'设备分类',width:70,align:'center',formatter: equipcatOperation},    
        {field:'TLocFlag',title:'科室',width:100,align:'center',formatter: locOperation},
        {field:'TEquipFlag',title:'设备',width:100,align:'center',formatter: equipOperation},    
        {field:'TItemFlag',title:'设备项',width:100,align:'center',formatter: itemOperation},                
    	]],
		onClickRow:function(rowIndex,rowData){OnclickRow();},

	});
}
function equiptypeOperation(value,row,index)
{
	return GetFlagHtml(1,value,row);
}
 
function statcatOperation(value,row,index)
{
	return GetFlagHtml(2,value,row);
}
 
function equipcatOperation(value,row,index)
{
	return GetFlagHtml(3,value,row);
}
 
function locOperation(value,row,index)
{
	return GetFlagHtml(4,value,row);
}	

function equipOperation(value,row,index)
{
	return GetFlagHtml(5,value,row);
}

function itemOperation(value,row,index)
{
	return GetFlagHtml(6,value,row);
}

function GetFlagHtml(type,value,row)
{
	var btn=""
	if ("Y"==value)
	{
		var para="ManageLimitDR="+row.TRowID+"&Type="+type;
		var url="dhceq.plat.cmanagelimitlist.csp?";
		if (type<3)
		{	para=para+"&Group="+row.TGroupDR;
			url="dhceq.plat.cmanagelimitlistinfo.csp?";
		}
		url=url+para;
		var width=""   // modfied by wy  2019-2-1 815075
	    var height=""
		var icon="icon-paper"
	    var title="限定明细"
	    //modify by lmm 2020-06-05 UI
	    var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;'+width+'&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;small&quot;)" href="#">	<span class="icon-paper" style="display:inline-block;height:24px;width:24px;"></span></A>'    // modfied by wy 2019-2-19 
	}
	return btn;
}
// MZY0025	1318603		2020-05-13
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
function setDisEnabled()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}
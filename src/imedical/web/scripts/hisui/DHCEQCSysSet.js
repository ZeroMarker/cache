//设备系统配置表
var Component="tDHCEQCSysSet"  //add by lmm 2018-09-05 hisui改造：定义组件名
var editIndex=undefined;
var objtbl=$('#tDHCEQCSysSet');
function BodyLoadHandler() 
{	
	InitUserInfo();
	//initButtonWidth();  //add by lmm 2018-09-05 hisui改造：修改按钮长度
	$('#'+Component).datagrid({
		onClickRow:function (rowIndex, rowData) {
		    if (rowData.TCode!="990018")
		    {
			    $('#'+Component).datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		    }
		    else
		    {
			    ///FTP独立维护窗口
			    var url='dhceq.plat.ftpserver.csp?&SSRowID='+rowData.TRowID;	//CZF0138
			    showWindow(url,"FTPServer配置","","6row","icon-w-paper","modal","","","small"); //modify by lmm 2020-06-05 UI
		    }
			},
		//onLoadSuccess:function(){}    //modify by lmm 2020-09-23 1514376 gen文已定义，重复定义		
	})
	initBDPHospComponent("DHC_EQCSysSet");	//CZF0138 多院区改造 begin
	var HospFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051")
	if (HospFlag!=2)
	{
		hiddenObj("BAdd",true);
		$("#tDHCEQCSysSet").datagrid('getColumnOption', 'TCode').editor = {};
		$("#tDHCEQCSysSet").datagrid('getColumnOption', 'TDesc').editor = {};
		$("#tDHCEQCSysSet").datagrid('getColumnOption', 'TRemark').editor = {};
	}										//CZF0138 多院区改造 end
}

//CZF0138 平台医院组件选择事件
function onBDPHospSelectHandler()
{
	initSysSetGrid();
}

//CZF0138
function initSysSetGrid()
{
	var HospDR=GetBDPHospValue("_HospList");
	$("#tDHCEQCSysSet").datagrid({
		url:$URL,
		queryParams:{
			ComponentID:GetElementValue("GetComponentID"),
			gHospId:curSSHospitalID,
			BDPHospId:HospDR
		},
		showRefresh:false,
		showPageList:false,
		afterPageText:'',
		beforePageText:''
	})
}

//CZF0138
//数据关联医院按钮点击事件
function HospitalHandle()
{
	var rows=$("#tDHCEQCSysSet").datagrid('getSelected');
	if (rows==null)
	{
		$.messager.alert("提示", "请选择设备配置!", 'info');
		return
	}
	var SSRowID=rows.TRowID;
	if(SSRowID==""){
		$.messager.alert("提示", "请选择设备配置!", 'info');
		return 
	}
	genHospWinNew("DHC_EQCSysSet",SSRowID,function(){
		//回调函数;
	});
}

///modify by lmm 2018-09-05
///描述：hisui改造：重写更新方法列数据获取
function BUpdate_Click()
{
	var rows = $('#'+Component).datagrid('getRows');
	var RowCount=rows.length
	if(RowCount<=0){
		alertShow("没有待保存数据");
		return;
	}
	var combindata=GetTableInfo();
	if (combindata==-1) return;
	SetData(combindata);//调用函数	
}
function SetData(combindata)
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata,curSSHospitalID,GetBDPHospValue("_HospList"));
	var plist=gbldata.split("^");
    //location.reload();
    $("#tDHCEQCSysSet").datagrid('reload');
}
///add by lmm 2018-10-28
///hisui改造：增加可编辑列表按钮
$('#'+Component).datagrid({
	toolbar:[{  
		iconCls: 'icon-save', 
        text:'保存',          
        handler: function(){
            BUpdate_Click();
        }  
    },{ 
    	id:'BAdd',
		iconCls: 'icon-add', 
        text:'新增',          
        handler: function(){
            insertRow();
        }  
    }],
})

// 插入新行
function insertRow()
{
	if(editIndex>="0"){
		objtbl.datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = objtbl.datagrid('getRows');
    var newIndex=rows.length; 
    if(GetTableInfo()=="-1")
    {
	    return
	}
	else
	{
		objtbl.datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
	}
}


//获取列表明细
function GetTableInfo()
{
	var valList="";
	//if (editIndex != undefined){ objtbl.datagrid('endEdit', editIndex);}
	var rows = objtbl.datagrid('getRows');
	var RowNo = ""
	for (var i = 0; i < rows.length; i++) 
	{
		objtbl.datagrid('endEdit', i);
		RowNo=i+1;
		var TRowID=(typeof rows[i].TRowID == 'undefined') ? "" : rows[i].TRowID
		var TCode=(typeof rows[i].TCode == 'undefined') ? "" : rows[i].TCode
		var TDesc=(typeof rows[i].TDesc == 'undefined') ? "" : rows[i].TDesc
		if(TCode=="")
		{
			messageShow('alert','error','提示',t[-9251].replace('[RowNo]',RowNo))	//"第[RowNo]行代码不能为空!"
			return -1
		}
		if(TDesc=="")
		{
			messageShow('alert','error','提示',t[-9251].replace('[RowNo]',RowNo))	//"第[RowNo]行描述不能为空!"
			return -1
		}
		if ((TCode=="990018")&&(TRowID!="")) continue;			//ftp信息在弹窗中填写
		if ((TCode=="")||(TDesc=="")) continue;	
		var RowData=JSON.stringify(rows[i]);
		if (valList=="")
		{
			valList=RowData;
		}
		else
		{
			valList=valList+"$$"+RowData;
		}
	}
	if ((valList=="")&&(rows.length>0))
	{
		messageShow('alert','error','提示',t[-9248]);	//"列表明细不能为空!"
		return -1;
	}
	return valList;
}

document.body.onload = BodyLoadHandler;
//Creator:CZF0138 2021-05-25
//description:功能分类维护
var Columns=getCurColumnsInfo('Plat.G.FunctionCat','','','');
var SelectedRow = -1 ; 

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  //界面加载效果影藏
});

function initDocument()
{
	initUserInfo();
	initMessage();
	defindTitleStyle();
	initLookUp();
	initButton();
	//initButtonWidth();
	muilt_Tab();  // 回车下一输入框
	setRequiredElements("FCCode^FCDesc");
	initBDPHospComponent("DHC_EQCFunctionCat");	//CZF0138 多院区改造
	initFunctionCatGrid();
	disabled(true);
}

//CZF0138 平台医院组件选择事件
function onBDPHospSelectHandler()
{
	BClear_Clicked();
	initFunctionCatGrid();
}

function initFunctionCatGrid()
{
	FunctionCatGrid = $HUI.datagrid("#DHCEQCFunctionCat",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTFunctionCat",
			QueryName:"GetFunctionCat",
			Code:getElementValue("FCCode"),
			Desc:getElementValue("FCDesc"),
			gHospId:curSSHospitalID,
			BDPHospId:GetBDPHospValue("_HospList")
		},
		border:false,
	    fit:true,
		fitColumns:true,
	    singleSelect:true,
	    rownumbers: true, 
	    columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
	    onClickRow:function(rowIndex, rowData){
		    OnClickRow(rowIndex,rowData);
		},
		onLoadSuccess:function(){
		}
	});
}

//数据关联医院按钮点击事件
function HospitalHandle()
{
	var FCRowID=getElementValue("FCRowID");
	if(FCRowID==""){
		$.messager.alert("提示", "请选择核算项目!", 'info');
		return 
	}
	genHospWinNew("DHC_EQCFunctionCat",FCRowID,function(){
		//回调函数;
	});
}

function BSave_Clicked() 
{
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTFunctionCat","SaveData",data,"0",curSSHospitalID,GetBDPHospValue("_HospList"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("popover","success","提示","保存成功！");
		FunctionCatGrid.reload();
		BClear_Clicked();
	}
	else{
		messageShow('popover','error','提示',"保存失败！错误信息:"+jsonData.Data);
	}	
}

function BDelete_Clicked() 
{
	var FCRowID=getElementValue("FCRowID")
	if (FCRowID==""){
            $.messager.popover({msg:"请选择一行",type:'alert'}); 
            return false;
    } 
    $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) { 
    	if (b==false)
    	{
        	 return;
   	 	}
    	else
    	{
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTFunctionCat","SaveData",FCRowID,"1",curSSHospitalID,GetBDPHospValue("_HospList"));
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0){
				messageShow("popover","success","提示","删除成功！");
				FunctionCatGrid.reload();
				BClear_Clicked();
			}else{
				messageShow('popover','error','提示',"删除失败！错误信息:"+jsonData.Data);
			}
    	}       
  })
}

function BClear_Clicked()
{
	setElement("FCRowID","");
	setElement("FCCode",""); 
	setElement("FCDesc","");
	setElement("FCRemark","");
}

function OnClickRow(index,rowdata)
{
	if (SelectedRow==index){
		BClear_Clicked();
		disabled(true)	
		SelectedRow=-1;
		setElement("FCRowID","");
		$('#DHCEQCFunctionCat').datagrid('unselectAll');  
	}else{
		SelectedRow=index;
		setElement("FCRowID",rowdata.TRowID);
        setElement("FCCode",rowdata.TCode);
        setElement("FCDesc",rowdata.TName);
        setElement("FCRemark",rowdata.TRemark);
		disabled(false);
	}
}

function disabled(value)
{
	if (getElementValue("ReadOnly")==1){
		disableElement("BDelete",true)
	}else{
		disableElement("BDelete",value)
	}
}


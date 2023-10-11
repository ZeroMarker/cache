//Creator:CZF0138 2021-05-25
//description:医院核算项目维护
var Columns=getCurColumnsInfo('Plat.G.FinaceItem','','','');
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
	setRequiredElements("FICode^FIDesc");
	initBDPHospComponent("DHC_EQCFinaceItem");	//CZF0138 多院区改造
	initFinanceItemGrid();
	disabled(true);
}

//CZF0138 平台医院组件选择事件
function onBDPHospSelectHandler()
{
	BClear_Clicked();
	initFinanceItemGrid();
}

function initFinanceItemGrid()
{
	FinanceItemGrid = $HUI.datagrid("#DHCEQCFinanceItem",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTFinanceItem",
			QueryName:"GetFinanceItem",
			Code:getElementValue("FICode"),
			Desc:getElementValue("FIDesc"),
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
	var FIRowID=getElementValue("FIRowID");
	if(FIRowID==""){
		$.messager.alert("提示", "请选择核算项目!", 'info');
		return 
	}
	genHospWinNew("DHC_EQCFinaceItem",FIRowID,function(){
		//回调函数;
	});
}

function BSave_Clicked() 
{
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTFinanceItem","SaveData",data,"0",curSSHospitalID,GetBDPHospValue("_HospList"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("popover","success","提示","保存成功！");
		FinanceItemGrid.reload();
		BClear_Clicked();
	}
	else{
		messageShow('popover','error','提示',"保存失败！错误信息:"+jsonData.Data);
	}	
}

function BDelete_Clicked() 
{
	var FIRowID=getElementValue("FIRowID")
	if (FIRowID==""){
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
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTFinanceItem","SaveData",FIRowID,"1",curSSHospitalID,GetBDPHospValue("_HospList"));
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0){
				messageShow("popover","success","提示","删除成功！");
				FinanceItemGrid.reload();
				BClear_Clicked();
			}else{
				messageShow('popover','error','提示',"删除失败！错误信息:"+jsonData.Data);
			}
    	}       
  })
}

function BClear_Clicked()
{
	setElement("FIRowID","");
	setElement("FICode",""); 
	setElement("FIDesc","");
	setElement("FIRemark","");
}

function OnClickRow(index,rowdata)
{
	if (SelectedRow==index){
		BClear_Clicked();
		disabled(true);	
		SelectedRow=-1;
		setElement("FIRowID","");
		$('#DHCEQCFinanceItem').datagrid('unselectAll');  
	}else{
		SelectedRow=index;
		setElement("FIRowID",rowdata.TRowID);
        setElement("FICode",rowdata.TCode);
        setElement("FIDesc",rowdata.TName);
        setElement("FIRemark",rowdata.TRemark);
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


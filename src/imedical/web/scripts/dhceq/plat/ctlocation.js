var columns=getCurColumnsInfo('PLAT.G.Location','','','');
$.extend($.fn.datagrid.defaults.view,{
	onAfterRender:function(target){	
	var h = $(window).height();
	var offset = $(target).closest('.datagrid').offset();
	$(target).datagrid('resize',{height:parseInt(h-offset.top-13)});
	}
});
var PreSelectedRowID = "";	//取当前选中的组件设备记录ID
//界面入口
jQuery(document).ready
(
	function()
	{
		initDocument();
	}
);

//初始化界面
function initDocument()
{
	initUserInfo();
	defindTitleStyle(); //默认Style
	initMessage();
	initPage();			//放大镜及按钮初始化
	setEnabled();		//按钮控制
	initBDPHospComponent("DHC_EQCLocation");	//多院区改造
	if (HospFlag==2)
	{
		hiddenObj("LHospital",true);
		hiddenObj("cLHospital",true);
	}
}

//平台医院组件选择事件
function onBDPHospSelectHandler()
{
	BClear_Clicked();
	initMaindatagrid();
}

//初始化按钮状态
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}

//选中行按钮状态
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}
//初始化放大镜、初始化按钮
function initPage()
{
	initLookUp();		//初始化放大镜
	initButton();		//初始化按钮
	initButtonWidth();
	initMaindatagrid();
	setRequiredElements("LCode^LDesc");
}

//放大镜选取后执行方法
function setSelectValue(vElementID,rowData)
{
	if (vElementID=="LHospital"){setElement("LHospitalDR",rowData.TRowID)}
	else if (vElementID=="LLoc"){setElement("LLocDR",rowData.TRowID)}
}

//查询按钮点击事件
function BFind_Clicked()
{
	$HUI.datagrid("#maindatagrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTLocaton",
			QueryName:"GetLocationDetails",
			Code:getElementValue("LCode"),
			Desc:getElementValue("LDesc")
		}
	});
}

//加载主GRID
function initMaindatagrid()
{
	$(function(){
		$HUI.datagrid('#maindatagrid',{
			url:$URL,
			queryParams:{
        				ClassName:"web.DHCEQ.Plat.CTLocaton",
        				QueryName:"GetLocationDetails",
        				gHospId:curSSHospitalID,
        				BDPHospId:GetBDPHospValue("_HospList")
    			},
			onSelect:function(rowIndex,rowData){
				fillData_OnClickRow(rowIndex, rowData);
			},
			
			onLoadSuccess:function(data){

			},
			autoSizeColumn:true,
			fitColumns:true,
			cache: false,
			columns:columns,
			//idField:'id',
			pagination:true,
			pageSize:15,
			pageNumber:1,
			pageList:[15,30,60,100,200],
			//rownumbers:true,
			singleSelect:true
		})
	})		
}

//点击行事件
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{
		setElement("LRowID",rowData.TRowID);
		setElement("LCode",rowData.TCode);
		setElement("LDesc",rowData.TDesc);
		setElement("LPlace",rowData.TPlace);
		setElement("LRemark",rowData.TRemark);
		setElement("LHospital",rowData.THospital);
		setElement("LLoc",rowData.TLoc);
		setElement("LHospitalDR",rowData.THospitalDR);
		setElement("LLocDR",rowData.TLocDR);
		UnderSelect();
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Clicked();
		PreSelectedRowID=""
	}	
}

//清空Lookup
function clearData(vElementID)
{
 	if (vElementID=="LHospital"){setElement("LHospitalDR","")}
	if (vElementID=="LLoc"){setElement("LLocDR","")}
}

//Creator: cjt
//CreatDate: 2022-09-10
//Description: 数据删除方法
function BDelete_Clicked()
{
	var truthBeTold = window.confirm("是否删除此条记录？");
	if (!truthBeTold) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","SaveData",data,"1",curSSHospitalID,GetBDPHospValue("_HospList"));
	var jsonData=JSON.parse(result);
	if (jsonData.SQLCODE==0) {
		messageShow("popover","success","提示","删除成功！");
		$("#maindatagrid").datagrid('reload');
		BClear_Clicked();
	}else{
		messageShow('popover','error','提示',"删除失败！错误信息:"+jsonData.Data);
	}
}

//Creator: cjt
//CreatDate: 2022-09-10
//Description: 数据增加方法
function BAdd_Clicked()
{
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","SaveData",data,"2",curSSHospitalID,GetBDPHospValue("_HospList"));
	var jsonData=JSON.parse(result);
	if (jsonData.SQLCODE==0) {
		messageShow("popover","success","提示","增加成功！");
		$("#maindatagrid").datagrid('reload');
		BClear_Clicked();
	}else{
		messageShow('popover','error','提示',"增加失败!错误信息:"+jsonData.Data);
	}
}

//Creator: cjt
//CreatDate: 2022-09-10
//Description: 数据保存方法
function BSave_Clicked()
{
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTLocaton","SaveData",data,"3",curSSHospitalID,GetBDPHospValue("_HospList"));
	var jsonData=JSON.parse(result);
	if (jsonData.SQLCODE==0) {
		messageShow("popover","success","提示","保存成功！");
		$("#maindatagrid").datagrid('reload');
		BClear_Clicked();
	}else{
		messageShow('popover','error','提示',"保存失败！错误信息:"+jsonData.Data);
	}
}

//清空按钮触发事件，取消选中行触发事件
function BClear_Clicked()
{
	setElement("LRowID","");
	setElement("LCode","");
	setElement("LDesc","");
	setElement("LPlace","");
	setElement("LRemark","");
	setElement("LHospital","");
	setElement("LLoc","");
	setElement("LHospitalDR","");
	setElement("LLocDR","");
	setEnabled();
	PreSelectedRowID="";
}

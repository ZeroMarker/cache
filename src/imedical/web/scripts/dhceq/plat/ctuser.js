var columns=getCurColumnsInfo('PLAT.G.CT.User','','','');
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
///初始化界面
function initDocument()
{
	defindTitleStyle(); //默认Style
	initMessage();
	initPage();			//放大镜及按钮初始化
	setEnabled();		//按钮控制
}
///初始化按钮状态
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
///选中行按钮状态
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}
//放大镜及按钮初始化
function initPage()
{
	initLookUp();		//初始化放大镜
	jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BSave").on("click", BSave_Clicked);
	jQuery("#BDelete").linkbutton({iconCls: 'icon-w-close'});
	jQuery("#BDelete").on("click", BDelete_Clicked);
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	jQuery("#BClear").linkbutton({iconCls: 'icon-w-clean'});
	jQuery("#BClear").on("click", BClear_Clicked);
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Clicked);
	initButtonWidth();
	initMaindatagrid();
	setRequiredElements("ULoginName^ULogoinPassword^UName^UOrganizeTypeDesc^UOrganizeDesc")
}
//放大镜选取后执行方法
function setSelectValue(vElementID,rowData)
{
 	if (vElementID=="UGroupDR_SSGRPDesc"){setElement("UGroupDR",rowData.TGroupID)}
	else if (vElementID=="UActiveFlagDesc"){setElement("UActiveFlag",rowData.TRowID)}
	else if (vElementID=="UUserTypeDesc"){setElement("UUserType",rowData.TRowID)}
	else if (vElementID=="UDefaultLocDR_CTLOCDesc"){setElement("UDefaultLocDR",rowData.TRowID)}
	else if (vElementID=="UOrganizeTypeDesc")
	{
		setElement("UOrganizeType",rowData.TRowID)
		if(rowData.TRowID=="1")
		{
			singlelookup("UOrganizeDesc",'PLAT.L.Hospital',[{name:'Hospital',type:1,value:'UOrganizeIDDesc'},{name:'CurGorupID',type:2,value:''}],"");
			setRequiredElements("UExTypeDesc^UExIDDesc")
		}
		else if(rowData.TRowID=="2"){
			singlelookup("UOrganizeDesc",'PLAT.L.Vendor',[{name:'Provider',type:1,value:'UOrganizeIDDesc'}],"");
			removeRequiredElements("UExTypeDesc^UExIDDesc")
		}
		else{
			removeRequiredElements("UExTypeDesc^UExIDDesc")
		}
	}
	else if (vElementID=="UOrganizeDesc"){setElement("UOrganizeID",rowData.TRowID)}
	else if (vElementID=="UExTypeDesc"){setElement("UExType",rowData.TRowID)}
	else if (vElementID=="UExIDDesc"){setElement("UExID",rowData.TRowID)}
	else if (vElementID=="USexDesc"){setElement("USex",rowData.TRowID)}
	else if (vElementID=="ULeaderDR_UName"){setElement("ULeaderDR",rowData.TRowID)}
}
//查找按钮点击事件
function BFind_Clicked()
{
	$HUI.datagrid("#maindatagrid",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.Plat.CTUser",
	    	QueryName:"GetUserData",
	    	vData:getDataList()
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
        		ClassName:"web.DHCEQ.Plat.CTUser",
        		QueryName:"GetUserData",
        		Arg1:"",
        		ArgCnt:1
    		},
			onSelect:function(rowIndex,rowData){
				fillData_OnClickRow(rowIndex, rowData);
			},
			
			onLoadSuccess:function(data){

			},
			//autoSizeColumn:false,
			//fitColumns:true,
			fitColumns:true,
			cache: false,
			columns:columns,
			//idField:'id',
			pagination:true,
			pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
			//rownumbers:true,
			singleSelect:true,
			//width:500,
			//height:330,
			//title:'人员明细'
		})
	})		
}
///点击行事件
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{if(rowData.TOrganizeType=="1")
		{
			singlelookup("UOrganizeDesc",'PLAT.L.Hospital',[{name:'Hospital',type:1,value:'UOrganizeIDDesc'},{name:'CurGorupID',type:2,value:''}],"");
			setRequiredElements("UExTypeDesc^UExIDDesc")
		}
		else if(rowData.TOrganizeType=="2"){
			singlelookup("UOrganizeDesc",'PLAT.L.Vendor',[{name:'Provider',type:1,value:'UOrganizeIDDesc'}],"");
			removeRequiredElements("UExTypeDesc^UExIDDesc")
		}
		else{
			removeRequiredElements("UExTypeDesc^UExIDDesc")
		}
		setElement("URowID",rowData.TRowID);
		setElement("ULoginName",rowData.TLoginName);
		setElement("ULogoinPassword",rowData.TLogoinPassword);
		setElement("UCode",rowData.TCode);
		setElement("UName",rowData.TName);
		setElement("USex",rowData.TSex);
		setElement("USexDesc",rowData.TSexDesc);
		setElement("UMobilePhone",rowData.TMobilePhone);
		setElement("UOfficePhone",rowData.TOfficePhone);
		setElement("UEmail",rowData.TEmail);
		setElement("UFax",rowData.TFax);
		setElement("UQQ",rowData.TQQ);
		setElement("UWeChat",rowData.TWeChat);
		setElement("UOrganizeTypeDesc",rowData.TOrganizeTypeDesc);
		setElement("UOrganizeID",rowData.TOrganizeID);
		setElement("UOrganizeDesc",rowData.TOrganizeDesc);
		setElement("UDefaultLocDR",rowData.TDefaultLocDR);
		setElement("UDefaultLocDR_CTLOCDesc",rowData.TDefaultLocDR_CTLOCDesc);
		setElement("UGroupDR",rowData.TGroupDR);
		setElement("UGroupDR_SSGRPDesc",rowData.TGroupDR_SSGRPDesc);
		setElement("ULeaderDR",rowData.TLeaderDR);
		setElement("ULeaderDR_UName",rowData.TLeaderDR_UName);
		setElement("UUserTypeDesc",rowData.TUserTypeDesc);
		setElement("UExTypeDesc",rowData.TExTypeDesc);
		setElement("UExID",rowData.TExID);
		setElement("UActiveFlagDesc",rowData.TActiveFlagDesc);
		setElement("UDateFrom",rowData.TDateFrom);
		setElement("UDateTo",rowData.TDateTo);
		setElement("UExIDDesc",rowData.TExIDDesc);
		setElement("UOrganizeType",rowData.TOrganizeType);
		setElement("UUserType",rowData.TUserType);
		setElement("UExType",rowData.TExType);
		setElement("UActiveFlag",rowData.TActiveFlag);
		UnderSelect();
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Clicked();
		PreSelectedRowID=""
	}
	
}
///清空Lookup
function clearData(vElementID)
{
 	if (vElementID=="UGroupDR_SSGRPDesc"){setElement("UGroupDR","")}
	else if (vElementID=="UActiveFlagDesc"){setElement("UActiveFlag","")}
	else if (vElementID=="UUserTypeDesc"){setElement("UUserType","")}
	else if (vElementID=="UDefaultLocDR_CTLOCDesc"){setElement("UDefaultLocDR","")}
	else if (vElementID=="UOrganizeTypeDesc")
	{
		setElement("UOrganizeType","");
		singlelookup("UOrganizeDesc","","","");
		setElement("UOrganizeID","");
	}
	else if (vElementID=="UOrganizeDesc"){setElement("UOrganizeID","")}
	else if (vElementID=="UExTypeDesc"){setElement("UExType","")}
	else if (vElementID=="UExIDDesc"){setElement("UExID","")}
	else if (vElementID=="USexDesc"){setElement("USex","")}
	else if (vElementID=="ULeaderDR_UName"){setElement("ULeaderDR","")}
}

//////////////////////////////////业务处理函数/////////////////////////////////////////////

///Creator: jyp
///CreatDate: 2018-10-09
///Description: 数据新增方法
function BAdd_Clicked()
{
	if(checkMustItemNull()){return;}
	if (getElementValue("UOrganizeType")=="")
	{
		messageShow("alert","error","错误提示","请选择组织类型!")
		return
	}
	if (getElementValue("UOrganizeID")=="")
	{
		messageShow("alert","error","错误提示","请选择组织!")
		return
	}
	if (getElementValue("UOrganizeType")=="1")
	{
		if (getElementValue("UExType")=="")
		{
			messageShow("alert","error","错误提示","请选择关联系统!")
			return
		}
		if (getElementValue("UExID")=="")
		{
			messageShow("alert","error","错误提示","请选择关联用户!")
			return
		}
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTUser","SaveData",data,"2");
	jsonData=JSON.parse(jsonData);		// MZY0021	1304171		2020-05-06
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","新增成功！");
	window.setTimeout(function(){window.location.href= "dhceq.plat.ctuser.csp?&RowID="},50);
}

///Creator: jyp
///CreatDate: 2018-10-09
///Description: 数据保存方法
function BSave_Clicked()
{
	if(checkMustItemNull()){return;}
	if (getElementValue("UOrganizeType")=="")
	{
		messageShow("alert","error","错误提示","请选择组织类型!")
		return
	}
	if (getElementValue("UOrganizeID")=="")
	{
		messageShow("alert","error","错误提示","请选择组织!")
		return
	}
	if (getElementValue("UOrganizeType")=="1")
	{
		if (getElementValue("UExType")=="")
		{
			messageShow("alert","error","错误提示","请选择关联系统!")
			return
		}
		if (getElementValue("UExID")=="")
		{
			messageShow("alert","error","错误提示","请选择关联用户!")
			return
		}
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTUser","SaveData",data,"");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","修改成功！");
	window.setTimeout(function(){window.location.href= "dhceq.plat.ctuser.csp?&RowID="},50);
}
///Creator: jyp
///CreatDate: 2018-10-09
///Description: 数据删除方法
function BDelete_Clicked()
{
	var truthBeTold = window.confirm("是否删除此条记录？");  //add hly 20190802
	if (!truthBeTold) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTUser","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","删除成功！");
	window.setTimeout(function(){window.location.href= "dhceq.plat.ctuser.csp?&RowID="},50);
}
//清空按钮触发事件，取消选中行触发事件
function BClear_Clicked()
{
	setElement("URowID","");
	setElement("ULoginName","");
	setElement("ULogoinPassword","");
	setElement("UCode","");
	setElement("UName","");
	setElement("USex","");
	setElement("USexDesc","");
	setElement("UMobilePhone","");
	setElement("UOfficePhone","");
	setElement("UEmail","");
	setElement("UFax","");
	setElement("UQQ","");
	setElement("UWeChat","");
	setElement("UOrganizeTypeDesc","");
	setElement("UOrganizeID","");
	setElement("UOrganizeDesc","");
	setElement("UDefaultLocDR","");
	setElement("UDefaultLocDR_CTLOCDesc","");
	setElement("UGroupDR","");
	setElement("UGroupDR_SSGRPDesc","");
	setElement("ULeaderDR","");
	setElement("ULeaderDR_UName","");
	setElement("UUserTypeDesc","");
	setElement("UExTypeDesc","");
	setElement("UExID","");
	setElement("UActiveFlagDesc","");
	setElement("UDateFrom","");
	setElement("UDateTo","");
	setElement("UExIDDesc","");
	setElement("UOrganizeType","");
	setElement("UUserType","");
	setElement("UExType","");
	setElement("UActiveFlag","");
	setEnabled();
	PreSelectedRowID=""
	removeRequiredElements("UExTypeDesc^UExIDDesc")
}
//查询参数拼串
function getDataList()
{
	var combindata="";
	combindata=combindata+"^LoginName="+getElementValue("ULoginName") ;
	combindata=combindata+"^Code="+getElementValue("UCode") ;
	combindata=combindata+"^Name="+getElementValue("UName") ;
	combindata=combindata+"^Sex="+getElementValue("USex") ;
	combindata=combindata+"^MobilePhone="+getElementValue("UMobilePhone") ;
	combindata=combindata+"^OfficePhone="+getElementValue("UOfficePhone") ;
	combindata=combindata+"^Email="+getElementValue("UEmail") ;
	combindata=combindata+"^Fax="+getElementValue("UFax") ;	
	combindata=combindata+"^QQ="+getElementValue("UQQ") ;
	combindata=combindata+"^WeChat="+getElementValue("UWeChat") ;
	combindata=combindata+"^ActiveFlag="+getElementValue("UActiveFlag") ;
	combindata=combindata+"^LeaderDR="+getElementValue("ULeaderDR") ;
	combindata=combindata+"^UserType="+getElementValue("UUserType") ;
	combindata=combindata+"^GroupDR="+getElementValue("UGroupDR") ;
	combindata=combindata+"^DefaultLocDR="+getElementValue("UDefaultLocDR") ;
	combindata=combindata+"^UOrganizeType="+getElementValue("UOrganizeType") ;
	combindata=combindata+"^OrganizeID="+getElementValue("UOrganizeID") ;
	combindata=combindata+"^ExType="+getElementValue("UExType") ;
	combindata=combindata+"^ExID="+getElementValue("UExID") ;
	combindata=combindata+"^DateFrom="+getElementValue("UDateFrom") ;
	combindata=combindata+"^DateTo="+getElementValue("UDateTo") ;
    return combindata;
}

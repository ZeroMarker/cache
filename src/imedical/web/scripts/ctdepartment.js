var columns=getCurColumnsInfo('Plat.G.CT.Department','','','');
$.extend($.fn.datagrid.defaults.view,{
	onAfterRender:function(target){	
	var h = $(window).height();
	var offset = $(target).closest('.datagrid').offset();
	$(target).datagrid('resize',{height:parseInt(h-offset.top-13)});
	}
});
var PreSelectedRowID = "";	//ȡ��ǰѡ�е�����豸��¼ID
//�������
jQuery(document).ready
(
	function()
	{
		initDocument();
	}
);

function initDocument()
{
	initUserInfo();		//CZF0138 
	defindTitleStyle(); //Ĭ��Style
	initMessage();
	initBDPHospComponent("DHC_EQCDepartment");	//CZF0138 ��Ժ������
	initPage();			//�Ŵ󾵼���ť��ʼ��
	setEnabled();
}

//CZF0138 ƽ̨ҽԺ���ѡ���¼�
function onBDPHospSelectHandler()
{
	BClear_Clicked();
	initMaindatagrid();
}

function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
function initPage()
{
	initLookUp();		//��ʼ���Ŵ�
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
	setRequiredElements("DeptDesc^DeptOrganizeTypeDesc^DeptCode^DeptOrganizeDesc")  //modify by jyp 2018-12-28
}

function setSelectValue(vElementID,rowData)
{
 	if (vElementID=="DeptLeaderUserDR_UName"){setElement("DeptLeaderUserDR",rowData.TRowID)}
	else if (vElementID=="DeptContactsUserDR_UName"){setElement("DeptContactsUserDR",rowData.TRowID)}
	else if (vElementID=="DeptActiveFlagDesc"){setElement("DeptActiveFlag",rowData.TRowID)}
	else if (vElementID=="DeptDeptTypeDesc"){setElement("DeptDeptType",rowData.TRowID)}
	else if (vElementID=="DeptOrganizeTypeDesc")
	{
		setElement("DeptOrganizeType",rowData.TRowID)
		if(rowData.TRowID=="1")
		{
			singlelookup("DeptOrganizeDesc",'PLAT.L.Hospital',[{name:'Hospital',type:1,value:'DeptOrganizeDesc'},{name:'CurGorupID',type:2,value:''}],"");
			setRequiredElements("DeptExTypeDesc^DeptExIDDesc")
		}
		else if(rowData.TRowID=="2"){
			singlelookup("DeptOrganizeDesc",'PLAT.L.Vendor',[{name:'Provider',type:1,value:'DeptOrganizeDesc'}],"");
			removeRequiredElements("DeptExTypeDesc^DeptExIDDesc")
		}
		else{
			removeRequiredElements("DeptExTypeDesc^DeptExIDDesc")
		}
	}
	else if (vElementID=="DeptOrganizeDesc"){setElement("DeptOrganizeID",rowData.TRowID)}
	else if (vElementID=="DeptExTypeDesc"){setElement("DeptExType",rowData.TRowID)}
	else if (vElementID=="DeptExIDDesc"){setElement("DeptExID",rowData.TRowID)}
}

function onBeforeShowPanel()
{
}

function initMaindatagrid()
{
	Maindatagrid=$HUI.datagrid('#maindatagrid',{ //modify by zyq 2022-11-14
	url:$URL,
	queryParams:{
		ClassName:"web.DHCEQ.Plat.CTDepartment",
		QueryName:"GetDepartmentData",
		gHospId:curSSHospitalID,	//CZF0138
		BDPHospId:GetBDPHospValue("_HospList")
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
})	
}

function clearData(vElementID)
{
 	if (vElementID=="DeptLeaderUserDR_UName"){setElement("DeptLeaderUserDR","")}
	else if (vElementID=="DeptContactsUserDR_UName"){setElement("DeptContactsUserDR","")}
	else if (vElementID=="DeptActiveFlagDesc"){setElement("DeptActiveFlag","")}
	else if (vElementID=="DeptDeptTypeDesc"){setElement("DeptDeptType","")}
	else if (vElementID=="DeptOrganizeTypeDesc")
	{
		setElement("DeptOrganizeType","")
		removeRequiredElements("DeptExTypeDesc^DeptExIDDesc")
		setElement("DeptOrganizeID","")
	}
	else if (vElementID=="DeptOrganizeDesc"){setElement("DeptOrganizeID","")}
	else if (vElementID=="DeptExTypeDesc"){setElement("DeptExType","")}
	else if (vElementID=="DeptExIDDesc"){setElement("DeptExID","")}   //modified by myl  2173537  20211109
}

//////////////////////////////////ҵ������/////////////////////////////////////////////
///Creator: jyp
///CreatDate: 2018-10-09
///Description: �����޸ķ���
function BSave_Clicked()
{
		if(checkMustItemNull()){return;}
	if (getElementValue("DeptOrganizeType")=="")
	{
		messageShow("alert","error","������ʾ","��ѡ����֯����!")
		return
	}
	if (getElementValue("DeptOrganizeID")=="")
	{
		messageShow("alert","error","������ʾ","��ѡ����֯!")
		return
	}
	if (getElementValue("DeptOrganizeType")=="1")
	{
		if (getElementValue("DeptExType")=="")
		{
			messageShow("alert","error","������ʾ","��ѡ�����ϵͳ!")
			return
		}
		if (getElementValue("DeptExID")=="")
		{
			messageShow("alert","error","������ʾ","��ѡ������û�!")
			return
		}
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTDepartment","SaveData",data,"");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","������ʾ","�޸ĳɹ���");
	Maindatagrid.reload();//modified by zyq 2022-11-14
	BClear_Clicked()//modified by zyq 2022-11-14
	//window.setTimeout(function(){window.location.href= "dhceq.plat.ctdepartment.csp?&RowID="},50);
}
///Creator: jyp
///CreatDate: 2018-10-09
///Description: ������������
function BAdd_Clicked()
{
	if(checkMustItemNull()){return;}
	if (getElementValue("DeptOrganizeType")=="")
	{
		messageShow("alert","error","������ʾ","��ѡ����֯����!")
		return
	}
	if (getElementValue("DeptOrganizeID")=="")
	{
		messageShow("alert","error","������ʾ","��ѡ����֯!")
		return
	}
	if (getElementValue("DeptOrganizeType")=="1")
	{
		if (getElementValue("DeptExType")=="")
		{
			messageShow("alert","error","������ʾ","��ѡ�����ϵͳ!")
			return
		}
		if (getElementValue("DeptExID")=="")
		{
			messageShow("alert","error","������ʾ","��ѡ������û�!")
			return
		}
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTDepartment","SaveData",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�����ɹ���");  //modify hly 20190802
	var url="dhceq.plat.ctdepartment.csp?&RowID=";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}

///Creator: jyp
///CreatDate: 2018-10-09
///Description: ����ɾ������
function BDelete_Clicked()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var truthBeTold = window.confirm("�Ƿ�ɾ��������¼��");  //add hly 20190802
	if (!truthBeTold) return;
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTDepartment","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","ɾ���ɹ���");  //modify hly 20190802
	var url="dhceq.plat.ctdepartment.csp?&RowID=";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}

//���Ұ�ť����¼�
function BFind_Clicked()
{
	$HUI.datagrid("#maindatagrid",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.Plat.CTDepartment",
	    	QueryName:"GetDepartmentData",
	    	Code:getElementValue("DeptCode"),
	    	Desc:getElementValue("DeptDesc"),
	    	LeaderUserDR:getElementValue("DeptLeaderUserDR"),
	    	ContactsUserDR:getElementValue("DeptContactsUserDR"),
	    	Telephone:getElementValue("DeptTelephone"),
	    	Address:getElementValue("DeptAddress"),
	    	OrganizeType:getElementValue("DeptOrganizeType"),
	    	OrganizeID:getElementValue("DeptOrganizeID"),
	    	ExType:getElementValue("DeptExType"),
	    	ExID:getElementValue("DeptExID"),
	    	ExDesc:getElementValue("DeptExDesc"),
	    	ActiveFlag:getElementValue("DeptActiveFlag"),
	    	gHospId:curSSHospitalID,	//CZF0138
			BDPHospId:GetBDPHospValue("_HospList")
		}
	});
}
//////////////////////////////////////���ܴ�����///////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///������¼�
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{if(rowData.TOrganizeType=="1")
		{
			singlelookup("DeptOrganizeDesc",'PLAT.L.Hospital',[{name:'Hospital',type:1,value:'DeptOrganizeIDDesc'},{name:'CurGorupID',type:2,value:''}],"");
			setRequiredElements("DeptExTypeDesc^DeptExIDDesc")
		}
		else if(rowData.TOrganizeType=="2"){
			singlelookup("DeptOrganizeDesc",'PLAT.L.Vendor',[{name:'Provider',type:1,value:'DeptOrganizeIDDesc'}],"");
			removeRequiredElements("DeptExTypeDesc^DeptExIDDesc")
		}
		else{
			removeRequiredElements("DeptExTypeDesc^DeptExIDDesc")
		}
		setElement("DeptRowID",rowData.TRowID);
		setElement("DeptCode",rowData.TCode);
		setElement("DeptDesc",rowData.TDesc);
		setElement("DeptLeaderUserDR_UName",rowData.TLeaderUserName);
		setElement("DeptLeaderUserDR",rowData.TLeaderUserDR);
		setElement("DeptContactsUserDR_UName",rowData.TContactsUserName);
		setElement("DeptContactsUserDR",rowData.TContactsUserDR);
		setElement("DeptTelephone",rowData.TTelephone);
		setElement("DeptAddress",rowData.TAddress);
		setElement("DeptOrganizeType",rowData.TOrganizeType);
		setElement("DeptOrganizeTypeDesc",rowData.TOrganizeTypeDesc);
		setElement("DeptOrganizeID",rowData.TOrganizeID);
		setElement("DeptOrganizeDesc",rowData.TOrganize);
		setElement("DeptActiveFlagDesc",rowData.TActiveFlagDesc);
		setElement("DeptActiveFlag",rowData.TActiveFlag);
		setElement("DeptExTypeDesc",rowData.TExTypeDesc);
		setElement("DeptExType",rowData.TExType);
		setElement("DeptExID",rowData.TExID);
		setElement("DeptExIDDesc",rowData.TExName);
		setElement("DeptExDesc",rowData.TExDesc);
		setElement("DeptDeptType",rowData.TUserTypeDesc);
		setElement("DeptDeptTypeDesc",rowData.TUserTypeDesc);
		setElement("DeptDateFrom",rowData.TDateFrom);
		setElement("DeptDateTo",rowData.TDateTo);
		///add by ZY0210
		setElement("ARowID",rowData.ARowID);
		setElement("AText",rowData.AText);
		
		UnderSelect();
		PreSelectedRowID=rowData.TRowID
	}
	else
	{
		BClear_Clicked();
		PreSelectedRowID=""
	}
	
}
///ѡ���а�ť״̬
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}
//��հ�ť�����¼���ȡ��ѡ���д����¼�
function BClear_Clicked()
{
	setElement("DeptRowID","");
	setElement("DeptCode","");
	setElement("DeptDesc","");
	setElement("DeptLeaderUserDR_UName","");
	setElement("DeptLeaderUserDR","");
	setElement("DeptContactsUserDR_UName","");
	setElement("DeptContactsUserDR","");
	setElement("DeptTelephone","");
	setElement("DeptAddress","");
	setElement("DeptOrganizeType","");
	setElement("DeptOrganizeTypeDesc","");
	setElement("DeptOrganizeID","");
	setElement("DeptOrganizeDesc","");
	setElement("DeptActiveFlagDesc","");
	setElement("DeptActiveFlag","");
	setElement("DeptExTypeDesc","");
	setElement("DeptExType","");
	setElement("DeptExID","");
	setElement("DeptExIDDesc","");
	setElement("DeptExDesc","");
	setElement("DeptDeptType","");
	setElement("DeptDeptTypeDesc","");
	setElement("DeptDateFrom","");
	setElement("DeptDateTo","");
	///add by ZY0210
	setElement("ARowID","");
	setElement("AText","");
	setEnabled();
	PreSelectedRowID=""
	removeRequiredElements("UExTypeDesc^UExIDDesc")
}

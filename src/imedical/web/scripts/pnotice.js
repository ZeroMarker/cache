$(function(){
	initDocument();
});
function initDocument()
{
	//modify by lmm 2020-03-17 1224191
	initUserInfo();
	setElement("ManageLocDR",curLocID);
	setElement("ManageLoc",curLocName);
	initLookUp();
	initMessage();
	defindTitleStyle();
	initButton();
	setRequiredElements("NoticeCat^NoticeCatDR^Title^ContentType^ManageLoc^ManageLocDR^EffectiveDate^SourceType^SourceID"); //必填项
	initCombobox();
	ChangeCombobox();
	jQuery("#BAppendFile").linkbutton({iconCls: 'icon-w-paper'});
	jQuery("#BAppendFile").on("click", BAppendFile_Clicked);
	//modify by lmm 2020-03-17 1223518 图片点击事件已存在，删掉注释代码
	//jQuery("#BPicture").linkbutton({iconCls: 'icon-w-paper'});
	//jQuery("#BPicture").on("click", BPicture_Clicked);
	fillData();
	SetEnabled();
	//add by lmm 2020-04-20 增加查阅范围
	initSourceTypeData();   
	changeCombobox();
};


function BAppendFile_Clicked()
{
	var result=getElementValue("RowID");
	if (result<=0)
	{
		messageShow("alert","error","提示","公告未保存！");
		return;
	}
	
	var Status=getElementValue("Status");
	//Modefied by zc0060 20200329 文件上传改造  begin
	//var str='dhceq.process.appendfile.csp?&CurrentSourceType=67&CurrentSourceID='+result+'&Status='+Status
	//modify by lmm 2020-04-10 1260818
	var str='dhceq.plat.appendfile.csp??&CurrentSourceType=67&CurrentSourceID='+result+'&Status='+Status+'&ReadOnly=';
	//Modefied by zc0060 20200329 文件上传改造  end
	//window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	showWindow(str,"电子资料","","","icon-w-paper","modal","","","large");     //modify by lmm 2019-02-16

}
function BPicture_Clicked()
{
	var result=getElementValue("RowID");
	if (result<=0)
	{
		messageShow("alert","error","提示","公告未保存！");
		return;
	}
	var Status=getElementValue("Status");

	var url='dhceq.plat.picturemenu.csp?&CurrentSourceType=67&CurrentSourceID='+result+'&Status='+Status+'&ReadOnly=';
	showWindow(url,"图片资料","","","icon-w-paper","modal","","","middle");    //modify by lmm 2020-06-05 UI


}
function BSave_Clicked()
{
	if(checkMustItemNull()) return;
	if(($("#ContentType").combobox("getValue")==0)&&(getElementValue("Content")==""))
	{
		messageShow("alert","error","提示","文本不能为空！");
		return;
	}
	
		
	var CombineData=combineData()   //modify by lmm 2020-04-20 1278060
	var Data=tkMakeServerCall("web.DHCEQ.Plat.LIBPNotice","SaveData",CombineData);
	//modify by lmm 2020-04-14 1270027
	if (Data<0) {messageShow("alert","error","错误提示","操作失败!");return;}
	messageShow("alert","success","提示","操作成功！");
	var RowID=Data;
	var url="dhceq.plat.pnotice.csp?&RowID="+RowID;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url;},50);
	
}

function combineData()
{
	var val="";
	val=getElementValue("RowID");
	val+="^"+getElementValue("HospitalDR");
	val+="^"+getElementValue("NoticeCatDR");
	val+="^"+getElementValue("Title");
	val+="^"+getElementValue("SubTitle");
	val+="^"+getElementValue("PublishDept");
	val+="^"+getElementValue("PublishUser");
	val+="^"+getElementValue("PublishDate");
	val+="^"+getElementValue("PublishTime");
	val+="^"+getElementValue("EffectiveDate");
	val+="^"+getElementValue("Abstract");
	val+="^"+getElementValue("ContentType");
	val+="^"+getElementValue("Content");
	val+="^"+getElementValue("Standard");
	val+="^"+getElementValue("Source");
	val+="^"+getElementValue("ManageLocDR");
	val+="^"+getElementValue("Remark");
	val+="^"+getElementValue("Hold1");
	val+="^"+getElementValue("Hold2");
	val+="^"+getElementValue("Hold3");
	val+="^"+getElementValue("Hold4");
	val+="^"+getElementValue("Hold5");
	//add by lmm 2020-04-20
	val+="^"+getElementValue("SourceType");
	val+="^"+getElementValue("SourceIDDR");
	return val;
	
	
}
function fillData()
{
	var RowID=getElementValue("RowID")
	if (RowID=="") return
	var NoticeInfo=tkMakeServerCall("web.DHCEQ.Plat.LIBPNotice","GetOnePNotice",RowID);
	var NoticeInfo=NoticeInfo.split("^")
	setElement("HospitalDR",NoticeInfo[0]);
	setElement("Hospital",NoticeInfo[25]);   //modify by lmm 2020-04-20
	setElement("NoticeCatDR",NoticeInfo[1]);
	setElement("NoticeCat",NoticeInfo[26]);   //modify by lmm 2020-04-20
	setElement("Title",NoticeInfo[2]);
	setElement("SubTitle",NoticeInfo[3]);
	setElement("PublishDept",NoticeInfo[4]);
	setElement("PublishUser",NoticeInfo[5]);
	setElement("PublishDate",NoticeInfo[6]);
	setElement("PublishTime",NoticeInfo[7]);
	setElement("EffectiveDate",NoticeInfo[8]);
	setElement("Abstract",NoticeInfo[9]);
	setElement("ContentType",NoticeInfo[10]);
	setElement("Content",NoticeInfo[11]);
	setElement("Standard",NoticeInfo[12]);
	setElement("Source",NoticeInfo[13]);
	setElement("ManageLocDR",NoticeInfo[14]);
	setElement("Status",NoticeInfo[15]);
	setElement("ManageLoc",NoticeInfo[27]);   //modify by lmm 2020-04-20
	setElement("Remark",NoticeInfo[16]);
	setElement("Hold1",NoticeInfo[18]);
	setElement("Hold2",NoticeInfo[19]);
	setElement("Hold3",NoticeInfo[20]);
	setElement("Hold4",NoticeInfo[21]);
	setElement("Hold5",NoticeInfo[22]);
	//add by lmm 2020-04-20 
	setElement("SourceType",NoticeInfo[23]);
	setElement("SourceIDDR",NoticeInfo[24]);
	setElement("SourceID",NoticeInfo[28]);
	// MZY0141	3032819		2022-11-02
	if (NoticeInfo[23]==1)
	{
		setRequiredElements("SourceID",0);
		setElement("SourceID","");
	}
}
function BSubmit_Clicked()
{
	var RowID=getElementValue("RowID")
	var PictrueID=tkMakeServerCall("web.DHCEQ.Plat.LIBPicture","GetPictureIDBySource","67",RowID);
	if ((getElementValue("ContentType")==1)&&(PictrueID==""))
	{
		messageShow("alert","error","错误提示","图片未上传！");
		return;
	}
	var AppendFileID=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetAppenfFileIDBySource","67",RowID);  //Modefied by zc0059 20200319 将web.DHCEQ.Process.DHCEQAppendFile改成GetAppenfFileIDBySource
	if ((getElementValue("ContentType")==2)&&(AppendFileID==""))
	{
		messageShow("alert","error","错误提示","电子文件未上传！");
		return;
	}
	
	
	var Data=tkMakeServerCall("web.DHCEQ.Plat.LIBPNotice","SubmitData",RowID);
	if (Data<0) {messageShow("alert","error","错误提示",Data);return;}
	messageShow("alert","success","提示","修改成功！");
	var RowID=Data;
	var url= "dhceq.plat.pnotice.csp?&RowID="+RowID;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url;},50);
	
}
function BDelete_Clicked()
{
	var RowID=getElementValue("RowID")
	var Data=tkMakeServerCall("web.DHCEQ.Plat.LIBPNotice","DeleteData",RowID);
	if (Data<0) {messageShow("alert","error","错误提示",Data);return;}
	messageShow("alert","success","提示","修改成功！");
	var RowID=Data;
	var url= "dhceq.plat.pnotice.csp?&RowID=";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url;},50);
}
function BAudit_Clicked()
{
	var RowID=getElementValue("RowID")
	var Data=tkMakeServerCall("web.DHCEQ.Plat.LIBPNotice","AuditData",RowID);
	if (Data<0) {messageShow("alert","error","错误提示",Data);return;}
	messageShow("alert","success","提示","修改成功！");
	var RowID=Data;
	var url= "dhceq.plat.pnotice.csp?&RowID=";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url;},50);
}
function initCombobox()
{
	var ContentType = $HUI.combobox('#ContentType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: '文本'
			},{
				id: '1',
				text: '图片'
			},{
				id: '2',
				text: '电子文件'
			}]
});
	
}

function ChangeCombobox()
{
	$("#ContentType").combobox({
		onChange: function(SourceType,TSourceType){
			if($("#ContentType").combobox("getValue")==0)
			{
	    		disableElement("Content",false)
	    		disableElement("BPicture",true)
	    		disableElement("BAppendFile",true)
			}

			else if($("#ContentType").combobox("getValue")==1)
			{
	    		disableElement("Content",true)
	    		disableElement("BPicture",false)
	    		disableElement("BAppendFile",true)
				setElement("Content","")
	
			}
			else if($("#ContentType").combobox("getValue")==2)
			{
	    		disableElement("Content",true)
	    		disableElement("BAppendFile",false)
	    		disableElement("BPicture",true)
				setElement("Content","")
			}
		}
	});
	
}

function SetEnabled()
{
	var Status=$("#Status").val();
	if (Status=="")
	{
		jQuery("#BSave").linkbutton("enable")
		jQuery("#BSubmit").linkbutton("disable")   //modify by lmm 2020-04-14 1269983
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BDelete").unbind();
		jQuery("#BAudit").linkbutton("disable")
		jQuery("#BAudit").unbind();
		//DisableBElement("BUpdate",true);
		//DisableBElement("BDelete",true);
		//DisableBElement("BSubmit",true);
	}
	else if (Status=="0")
	{
		jQuery("#BSave").linkbutton("enable")
		jQuery("#BSubmit").linkbutton("enable")
		jQuery("#BDelete").linkbutton("enable")
		jQuery("#BAudit").linkbutton("disable")
		jQuery("#BAudit").unbind();
	}
	else if (Status=="1")
	{
		jQuery("#BSave").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BAudit").linkbutton("enable")
	}
	else if (Status=="2")
	{
		jQuery("#BSave").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		//jQuery("#BDelete").linkbutton("disable")
		jQuery("#BAudit").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BSubmit").unbind();
		//jQuery("#BDelete").unbind();
		jQuery("#BAudit").unbind();
		//DisableBElement("BUpdate",true);
		//DisableBElement("BDelete",true);
		//DisableBElement("BSubmit",true);
	}
}

function setSelectValue(elementID,rowData)
{
	setElement(elementID+"DR",rowData.TRowID)
}

function clearData(elementID)
{
	setElement(elementID+"DR","")
}
///add by lmm 2020-04-20 增加查阅范围
function initSourceTypeData()
{
	var SourceType = $HUI.combobox('#SourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '1',
				text: '全院'
			},{
				id: '2',
				text: '指定安全组'
			},{
				id: '3',
				text: '指定科室'
			},{
				id: '4',
				text: '指定角色'
			},{
				id: '5',
				text: '指定人员'
			}]
});
}

function changeCombobox()
{
	disableElement("SourceID",true)
	$("#SourceType").combobox({
		onChange: function(SourceType,TSourceType){
			if($("#SourceType").combobox("getValue")==1)
			{
	    		disableElement("SourceID",true)
	    		setElement("SourceID","")
	    		setElement("SourceIDDR","")
				setRequiredElements("SourceID",0);	// MZY0141	3032819		2022-11-02
			}
			else if($("#SourceType").combobox("getValue")==2)
			{
	    		disableElement("SourceID",false)
	    		setElement("SourceID","")
				singlelookup("SourceID","PLAT.L.Group","",setGroupValue)
				setRequiredElements("SourceID",1);	// MZY0141	3032819		2022-11-02
			}
			else if($("#SourceType").combobox("getValue")==3)
			{
	    		disableElement("SourceID",false)
	    		setElement("SourceID","")
				singlelookup("SourceID","PLAT.L.Loc","","")
				setRequiredElements("SourceID",1);	// MZY0141	3032819		2022-11-02
			}
			else if($("#SourceType").combobox("getValue")==4)
			{
	    		disableElement("SourceID",false)
	    		setElement("SourceID","")
				singlelookup("SourceID","PLAT.L.Role","","")
				setRequiredElements("SourceID",1);	// MZY0141	3032819		2022-11-02
			}
			else if($("#SourceType").combobox("getValue")==5)
			{
	    		disableElement("SourceID",false)
	    		setElement("SourceID","")
				singlelookup("SourceID","PLAT.L.EQUser","","")
				setRequiredElements("SourceID",1);	// MZY0141	3032819		2022-11-02
			}
		}
	});
	
}

function setGroupValue(item)
{
	setElement("SourceID",item.TGroupName);
	setElement("SourceIDDR",item.TGroupID);
	
}

$(function(){
	initDocument();
});
function initDocument()
{
	initUserInfo();
	initMessage(""); 
	setRequiredElements("FromDeptType^FromDeptID_Desc^MCreateDate^AcceptUser"); 
	initFromDeptTypeData();
	initLookUp();
	initButtonWidth();
	initEvent();
	FillData();
	FillEquipData();
	SetEnabled();
}
function initFromDeptTypeData()
{
	$("#cFromDeptID_Desc").html("来源名称")
	var jsonData=tkMakeServerCall("web.DHCEQMoveNew","ReturnJsonFromDeptType")
	jsonData=jQuery.parseJSON(jsonData);
	var data=eval('(' + jsonData.Data+ ')');
	var FromDeptType = $HUI.combobox("#FromDeptType",{
		valueField:'id', textField:'text',panelHeight:"auto",editable:true,
		data:data,
		onChange: function () {
	    		ValueClear()
	    		var SourceType = getElementValue("FromDeptType");
	    		if (SourceType=="1")
				{
					if (getElementValue("MEventType")=="1")
					{
						$("#cFromDeptID_Desc").html("取回科室")
					}
					else
					{
						$("#cFromDeptID_Desc").html("归还科室")
					}
					setElement("FromDeptID_Desc","")
                	var paramsFrom=[{"name":"Type","type":"2","value":"0"},{"name":"LocDesc","type":"1","value":"FromDeptID_Desc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":""},{"name":"notUseFlag","type":"2","value":""}];
        			singlelookup("FromDeptID_Desc","PLAT.L.Loc",paramsFrom,"");
				}
				else if (SourceType=="2")
				{
					if (getElementValue("MEventType")=="1")
					{
						$("#cFromDeptID_Desc").html("取回服务商")
					}
					else
					{
						$("#cFromDeptID_Desc").html("归还服务商")
					}
					singlelookup("FromDeptID_Desc","EM.L.Service","","");
				}
				else if (SourceType=="3")
				{
					if (getElementValue("MEventType")=="1")
					{
						$("#cFromDeptID_Desc").html("取回供应商")
					}
					else
					{
						$("#cFromDeptID_Desc").html("归还供应商")
					}
					singlelookup("FromDeptID_Desc","PLAT.L.Vendor","","");
				}
				else if (SourceType=="4")
				{
					if (getElementValue("MEventType")=="1")
					{
						$("#cFromDeptID_Desc").html("取回生产厂商")
					}
					else
					{
						$("#cFromDeptID_Desc").html("归还生产厂商")
					}
					singlelookup("FromDeptID_Desc","PLAT.L.ManuFacturer","","");
				}
				else
				{
				}
				$("#FromDeptID_Desc").attr("data-required",true).attr("title","必填项");
			}
	});
}
function ValueClear()
{
	setElement("FromDeptID_Desc","");
	setElement("FromDeptID","");
}
function initEvent()
{
	$('#BSave').on("click", BSave_Clicked);
	if (getElementValue("MEventType")=="2")
	{
		$("#cMCreateDate").html("归还日期")
		$("#cAcceptUser").html("归还人")
	}
}

function BSave_Clicked()
{
	if(checkMustItemNull()){return;}
	var MRowID=getElementValue("MRowID");
	var MSourceType=getElementValue("MSourceType");
	var MSourceID=getElementValue("MSourceID");
	var MEventType=getElementValue("MEventType");
	var MObjID=getElementValue("MObjID");
	var MObjType=getElementValue("MObjType")
	var FromDeptType=getElementValue("FromDeptType");
	var FromDeptID=getElementValue("FromDeptID");
	var MCreateDate=getElementValue("MCreateDate");
	var AcceptUserDR=getElementValue("AcceptUserDR");
	var data=MRowID+"^^"+MObjID+"^"+MSourceType+"^"+MSourceID+"^"+MEventType+"^^"+FromDeptType+"^"+FromDeptID+"^^^^^^^^^^"+AcceptUserDR+"^^"
	var ret=tkMakeServerCall("web.DHCEQMoveNew","SaveData",data,curUserID,'','');
	if (ret<0)
	{
		messageShow('alert','error','提示',"保存失败!"+ret)
	}
	else
	{
		messageShow('popover','success','提示','保存成功！','','','');
		var url="dhceq.em.maintmoveinfo.csp?&MRowID="+ret+"&SourceType="+MSourceType+"&EventType="+MEventType+"&ObjType="+MObjType+"&SourceID="+MSourceID+"&EquipDR="+MObjID+"&Action="+getElementValue("Action");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	if(vElementID=="FromDeptID_Desc") {setElement("FromDeptID",item.TRowID);}
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
	if (vElementID=="FromDeptID_Desc")
	{
		setElement("FromDeptID","");
		setElement("FromDeptID_Desc","");
	}
}
function FillData()
{
	if (getElementValue("MRowID")=="") return;
	var info = tkMakeServerCall("web.DHCEQMoveNew", "GetOneMoveByID",getElementValue("MRowID"));
	var InfoStr = info.split("^");
	var sort=39;
	setElement("FromDeptType",InfoStr[7]);
	setElement("FromDeptID_Desc",InfoStr[sort+7]);
	setElement("FromDeptID",InfoStr[8]);
	setElement("MCreateDate",InfoStr[20]);
	setElement("AcceptUser",InfoStr[sort+17]);
	setElement("AcceptUserDR",InfoStr[17]);
}
function FillEquipData()
{
	var EquipDR=getElementValue("MObjID");
	if (EquipDR!="")
	{
		$cm({
			ClassName:"web.DHCEQ.EM.BUSEquip",
			MethodName:"GetOneEquip",
			RowID:EquipDR
		},function(jsonData){
			if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
    			setElement("EQName",jsonData.Data["EQName"]);
				setElement("EQNo",jsonData.Data["EQNo"]);
		});
	}
}
//modified by wy 2022-5-5 
function SetEnabled()
{
	var MEventType=getElementValue("MEventType");
	var Action=getElementValue("Action");
	disableElement("BSave",true);
	if ((Action=="WX_Finish")||(Action=="WX_Return"))
	{
		if (MEventType=="2")
		{
			disableElement("BSave",false);
		}
	}
	if ((Action=="WX_Maint")||(Action=="WX_Retrieve"))
	{
		if (MEventType=="1")
		{
			disableElement("BSave",false);
		}
	}
}
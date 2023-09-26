var EquipDR=getElementValue("BELEquipDR")
var editDeviceMapIndex=undefined;
var editUseContextYearIndex=undefined;
var editUseContextMonthIndex=undefined;
var editResearchIndex=undefined;
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	var obj=document.getElementById("Banner");
	if (obj){$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+EquipDR)}
	initUserInfo();
    initMessage("ba"); //获取所有业务消息
    initLookUp();
	defindTitleStyle(); 
  	initButton();
	fillData();
    initButtonWidth();
    initDeviceMap();
	$HUI.tabs("#tDHCEQBene",{
		onSelect:function(title)
		{
			if (title=="数据来源")
			{
				initDeviceMap()
			}
			else if (title=="年度评价")
			{
				initUseContextYear()
			}
			else if (title=="月度经济信息")
			{
				initUseContextMonth()
			}
			else if (title=="月度成本信息")
			{
				initUsedResource()
			}
			else if (title=="服务项")
			{
				initServiceMap()
			}
			else if (title=="其他内容")
			{
				initResearch()	//modifed BY ZY0217 2020-04-08
			}
		}
	});
	jQuery(window).resize(function(){window.location.reload()})
}
function initDeviceMap()
{
	var Columns=getCurColumnsInfo('BA.G.BenefitEquipList.DeviceMap','','','')
	$HUI.datagrid("#tDHCEQDeviceMap",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.BA.BUSDeviceMap",
	        	QueryName:"GetDeviceMap",
				EquipDR:EquipDR
			},
			toolbar:[
				{
					iconCls:'icon-add',
					text:'新增',
					handler:function(){AddDeviceMapData();}
				},'-----------------------------------',
				{
					iconCls:'icon-cancel',
					text:'删除',
					handler:function(){DeleteDeviceMapData();}
				}
			],
			rownumbers: true,  //如果为true，则显示一个行号列。
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
	    	onClickRow: function (rowIndex,rowData) {onClickDeviceMapRow(rowIndex,rowData)},
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

// 插入新行
function AddDeviceMapData()
{
	if(editDeviceMapIndex>="0"){
		$('#tDHCEQDeviceMap').datagrid('endEdit', editDeviceMapIndex);//结束编辑，传入之前编辑的行
	}
	$('#tDHCEQDeviceMap').datagrid('appendRow', 
	{
		DMRowID: '',
		DMDeviceSource:'',
		DMDeviceDesc: '',
		DMDeviceID:'',
		DMRemark:''
	});
	editDeviceMapIndex=0;
}
function DeleteDeviceMapData()
{
	var DeleteRowID=""
	if (editDeviceMapIndex>="0")
	{
		jQuery("#tDHCEQDeviceMap").datagrid('endEdit', editDeviceMapIndex);//结束编辑，传入之前编辑的行
		var rows = $('#tDHCEQDeviceMap').datagrid('getRows');
		DeleteRowID=rows[editDeviceMapIndex].DMRowID
	}
	if(DeleteRowID!="")
	{
		var truthBeTold = window.confirm(t[-9203]);
		if (!truthBeTold) return;
	}
	else
	{
		messageShow("","","","无记录删除");
		return
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSDeviceMap","SaveData",DeleteRowID,"","1");
	if (jsonData==0)
	{
		messageShow("","","","操作成功!");
		$('#tDHCEQDeviceMap').datagrid('deleteRow',editDeviceMapIndex)
	}
	else
    {
		messageShow("","","","错误信息:"+jsonData);
		return
    }
}

function onClickDeviceMapRow(index,rowData)
{
	//var rowData = $('#tDHCEQDeviceMap').datagrid('getSelected');
	if (rowData.DMDeviceSource!="") setElement("DeviceSourceDR",rowData.DMDeviceSource);
	if (editDeviceMapIndex!=index)
	{
		if (endDeviceMapEditing())
		{
			$('#tDHCEQDeviceMap').datagrid('selectRow', index).datagrid('beginEdit', index);
			editDeviceMapIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQDeviceMap').datagrid('getRows')[editDeviceMapIndex]);
		} else {
			$('#tDHCEQDeviceMap').datagrid('selectRow', editDeviceMapIndex);
		}
	}
	else
	{
		endDeviceMapEditing();
	}
}
function endDeviceMapEditing(){
	if (editDeviceMapIndex == undefined){return true}
	if ($('#tDHCEQDeviceMap').datagrid('validateRow', editDeviceMapIndex)){
		$('#tDHCEQDeviceMap').datagrid('endEdit', editDeviceMapIndex);
		editDeviceMapIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function getDeviceSourceDR(index,data)
{
	var rows = $('#tDHCEQDeviceMap').datagrid('getRows');
	var len=rows.length
	var lastIndex=len-2
	if (lastIndex>=0)
	{
		var lastSourceType=rows[lastIndex].DMDeviceSource
		if (lastSourceType!=data.DeviceSource)
		{
			alertShow("数据来源类型与第"+(len-2)+"行不一致!同一设备得数据来源类型应保持一致!")
			return
		}
	}
	var eg = $('#tDHCEQDeviceMap').datagrid('getEditor', {index:editDeviceMapIndex,field:'DMDeviceSource'});
	$(eg.target).combogrid("setValue",data.DeviceSource);
	$('#tDHCEQDeviceMap').datagrid('endEdit',editDeviceMapIndex);
	setElement("DeviceSourceDR",data.DeviceSource);
}
function getDeviceDR(index,data)
{
	/// w ##Class(web.DHCEQ.BA.BUSDeviceMap).CheckDeviceSource(EquipID, SourceType, SourceID)
	var SourceType=getElementValue("DeviceSourceDR")
	var SourceID=data.RowID
	if ((SourceType=="")||(SourceID=="")) return
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSDeviceMap","CheckDeviceSource",EquipDR,SourceType,SourceID)
	if (jsonData!=0)
	{
		alertShow("数据来源已经对照其他设备,请重新选择!")
		return
	}
	var rowData = $('#tDHCEQDeviceMap').datagrid('getSelected');
	rowData.DMDeviceID=data.RowID;
	var eg = $('#tDHCEQDeviceMap').datagrid('getEditor', {index:editDeviceMapIndex,field:'DMDeviceDesc'});
	$(eg.target).combogrid("setValue",data.Name);
	$('#tDHCEQDeviceMap').datagrid('endEdit',editDeviceMapIndex);
}

function initUseContextYear()
{
	setElement("YearFlag",1);
	var Columns=getCurColumnsInfo("BA.G.BenefitEquipList.UseContextYear",'','','')
	$HUI.datagrid("#tDHCEQUseContextYear",{
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.BA.BUSUseContext",
	        	QueryName:"GetUseContext",
				EquipDR:EquipDR,
				YearFlag:getElementValue("YearFlag")
			},
			toolbar:[
				{
					iconCls:'icon-add',
					text:'新增',
					handler:function(){AddUseContextYearData();}
				},'-----------------------------------',
				{
					iconCls:'icon-cancel',
					text:'删除',
					handler:function(){DeleteUseContextYearData();}
				}
			],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
	    	onClickRow: function (rowIndex,rowData) {onClickUseContextYearRow(rowIndex,rowData)},
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}
function onClickUseContextYearRow(index,rowData)
{
	//var rowData = $('#tDHCEQUseContextYear').datagrid('getSelected');
	//if (rowData.DMDeviceSource!="") setElement("DeviceSourceDR",rowData.DMDeviceSource);
	if (editUseContextYearIndex!=index)
	{
		if (endUseContextYearEditing())
		{
			$('#tDHCEQUseContextYear').datagrid('selectRow', index).datagrid('beginEdit', index);
			editUseContextYearIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQUseContextYear').datagrid('getRows')[editUseContextYearIndex]);
		} else {
			$('#tDHCEQUseContextYear').datagrid('selectRow', editUseContextYearIndex);
		}
	}
	else
	{
		endUseContextYearEditing();
	}
}
function endUseContextYearEditing(){
	if (editUseContextYearIndex == undefined){return true}
	if ($('#tDHCEQUseContextYear').datagrid('validateRow', editUseContextYearIndex)){
		$('#tDHCEQUseContextYear').datagrid('endEdit', editUseContextYearIndex);
		editUseContextYearIndex = undefined;
		return true;
	} else {
		return false;
	}
}

// 插入新行
function AddUseContextYearData()
{
	if(editUseContextYearIndex>="0"){
		$('#tDHCEQUseContextYear').datagrid('endEdit', editUseContextYearIndex);//结束编辑，传入之前编辑的行
	}
	$('#tDHCEQUseContextYear').datagrid('appendRow', 
	{
		UCRowID: '',
		UCYear: '',
		UCExpectedSatis: '',
		UCActualSatis: '',
		UCPatientSatis: '',
		UCNewFunction: '',
		UCSpecialService: '',
		UCOtherSocial: '',
		UCGraduateNum: '',
		UCStaffNum: '',
		UCOtherTasks: '',
		UCTotalScore: '',
		UCBenefitAnalysis: '',
		UCUseEvaluation: '',
		UCBriefEvaluation: '',
		UCOverallEvaluation: '',
		UCStatus: '',
	});
	editUseContextYearIndex=0;
}
function DeleteUseContextYearData()
{
	var DeleteRowID=""
	if (editUseContextYearIndex>="0")
	{
		jQuery("#tDHCEQUseContextYear").datagrid('endEdit', editUseContextYearIndex);//结束编辑，传入之前编辑的行
		var rows = $('#tDHCEQUseContextYear').datagrid('getRows');
		DeleteRowID=rows[editUseContextYearIndex].UCRowID
	}
	if(DeleteRowID!="")
	{
		var truthBeTold = window.confirm(t[-9203]);
		if (!truthBeTold) return;
	}
	else
	{
		messageShow("","","","无记录删除");
		return
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUseContext","SaveData",DeleteRowID,"","1");
	if (jsonData==0)
	{
		messageShow("","","","操作成功!");
		$('#tDHCEQUseContextYear').datagrid('deleteRow',editUseContextYearIndex)
	}
	else
    {
		messageShow("","","","错误信息:"+jsonData);
		return
    }
}

function initUseContextMonth()
{
	setElement("YearFlag",0);
	var Columns=getCurColumnsInfo("BA.G.BenefitEquipList.UseContextMonth",'','','')
	$HUI.datagrid("#tDHCEQUseContextMonth",{
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.BA.BUSUseContext",
	        	QueryName:"GetUseContext",
				EquipDR:EquipDR,
				YearFlag:getElementValue("YearFlag")
			},
			toolbar:[
				{
					iconCls:'icon-add',
					text:'新增',
					handler:function(){AddUseContextMonthData();}
				}/*,'-----------------------------------',
				{
					iconCls:'icon-cancel',
					text:'删除',
					handler:function(){DeleteUseContextMonthData();}
				}*/
			],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
	    	onClickRow: function (rowIndex,rowData) {onClickUseContextMonthRow(rowIndex,rowData)},
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

function onClickUseContextMonthRow(index,rowData)
{
	//var rowData = $('#tDHCEQUseContextYear').datagrid('getSelected');
	//if (rowData.DMDeviceSource!="") setElement("DeviceSourceDR",rowData.DMDeviceSource);
	if (editUseContextMonthIndex!=index)
	{
		if (endUseContextMonthEditing())
		{
			$('#tDHCEQUseContextMonth').datagrid('selectRow', index).datagrid('beginEdit', index);
			editUseContextMonthIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQUseContextMonth').datagrid('getRows')[editUseContextMonthIndex]);
		} else {
			$('#tDHCEQUseContextMonth').datagrid('selectRow', editUseContextMonthIndex);
		}
	}
	else
	{
		endUseContextMonthEditing();
	}
}
function endUseContextMonthEditing(){
	if (editUseContextMonthIndex == undefined){return true}
	if ($('#tDHCEQUseContextMonth').datagrid('validateRow', editUseContextMonthIndex)){
		$('#tDHCEQUseContextMonth').datagrid('endEdit', editUseContextMonthIndex);
		editUseContextMonthIndex = undefined;
		return true;
	} else {
		return false;
	}
}

// 插入新行
function AddUseContextMonthData()
{
	if(editUseContextMonthIndex>="0"){
		$('#tDHCEQUseContextMonth').datagrid('endEdit', editUseContextMonthIndex);//结束编辑，传入之前编辑的行
	}
	$('#tDHCEQUseContextMonth').datagrid('appendRow', 
	{
		UCRowID: '',
		UCYear: '',
		UCMonth: '',
		UCIncome: '',
		UCPersonTime: '',
		UCActualWorkLoad: '',
		UCPositiveCases: '',
		UCRunTime: '',
		UCFailureTimes: '',
		UCMaintTimes: '',
		UCPMTimes: '',
		UCDetectionTimes: '',
		UCWaitingTimes: '',
		UCAverageWorkHour: '',
		UCActualWorkDays: '',
		UCFailureDays: '',
	});
	editUseContextMonthIndex=0;
}
function DeleteUseContextMonthData()
{
	if (editUseContextMonthIndex>="0")
	{
		jQuery("#tDHCEQUseContextMonth").datagrid('endEdit', editUseContextMonthIndex);//结束编辑，传入之前编辑的行
	}
	var rows = $('#tDHCEQUseContextMonth').datagrid('getRows');
	var DeleteRowID=rows[editUseContextMonthIndex].UCRowID
	if(DeleteRowID!="")
	{
		var truthBeTold = window.confirm(t[-9203]);
		if (!truthBeTold) return;
	}
	else
	{
		messageShow("","","","无记录删除");
		return
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUseContext","SaveData",DeleteRowID,"","1");
	if (jsonData==0)
	{
		messageShow("","","","操作成功!");
		$('#tDHCEQUseContextMonth').datagrid('deleteRow',editUseContextMonthIndex)
	}
	else
    {
		messageShow("","","","错误信息:"+jsonData);
		return
    }
}

function initServiceMap()
{
	//add by ZY0224 20220-04-24
	var BussType=getElementValue("BussType")
	var SourceType=getElementValue("SourceType")
	var SourceID=getElementValue("SourceID")
	var Columns=getCurColumnsInfo("BA.G.EquipSercie.EquipService",'','','')
	$HUI.datagrid("#tDHCEQServiceMap",{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.BA.CTEquipService",
	        	QueryName:"GetEquipService",
				BussType:BussType,
				SourceType:SourceType,
				SourceID:SourceID,
			},
			toolbar:[
				{
					iconCls:'icon-add',
					text:'新增',
					handler:function(){AddServiceData();}
				},'-----------------------------------',
				{
					iconCls:'icon-cancel',
					text:'删除',
					handler:function(){DeleteServiceData();}
				}
			],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
	
}

function AddServiceData()
{
	var str="dhceq.ba.historylocservice.csp?&SLocDR="+getElementValue("StoreLocDR")+"&EQRowID="+EquipDR
	showWindow(str,"科室历史医嘱项","","","icon-w-paper","modal","","","large",findEquipService)
}
function DeleteServiceData()
{
	var DeleteRowIDs=""
	var rows = $('#tDHCEQServiceMap').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.Opt=="Y")
		{
			DeleteRowIDs=DeleteRowIDs+","+oneRow.TRowID
		}
	}
	if (DeleteRowIDs=="")
	{
		messageShow("","","","无记录删除");
		return
	}
	else
	{
		var truthBeTold = window.confirm(t[-9203]);
		if (!truthBeTold) return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.CTEquipService","DeleteData",DeleteRowIDs);
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","操作成功!");
		findEquipService()
	}
	else
    {
		messageShow("","","","错误信息:"+jsonData.Data);
		return
    }
}
function checkboxOnChange(Opt,rowIndex)
{
	var row = jQuery('#tDHCEQServiceMap').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (Opt==key)
			{
				if (((val=="N")||val==""))
				{
					row.Opt="Y"
				}
				else
				{
					row.Opt="N"
				}
			}
		})
	}
}

function findEquipService()
{
	return
	$HUI.datagrid("#tDHCEQServiceMap",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.CTEquipService",
	        	QueryName:"GetEquipService",
				vEquipDR:EquipDR
		},
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		border:false,
		columns:ESColumns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
	    onClickRow: function (rowIndex,rowData) {}
	});
}
function initUsedResource()
{
	var Columns=new Array();
	var column={field:'TYear',title:'年度',width:60};Columns.push(column);
	var column={field:'TMonth',title:'月份',width:60};Columns.push(column);
	data=tkMakeServerCall("web.DHCEQCResourceType","GetAllResourceType")
	data=data.replace(/\ +/g,"")	//去掉空格
	data=data.replace(/[\r\n]/g,"")	//去掉回车换行
	var listInfo=data.split('&')
	for(i=0;i<listInfo.length;i++)
	{
		var column={};
		list=listInfo[i].split('^')
		column["title"]=list[2];
        column["field"]='Type'+list[0];
        column["align"]='center';
        column["width"]=100;	
        column["editor"]={type: 'text',options: {required: true	}}
        Columns.push(column);
	}
	var column={field:'TTypeFee',title:'TTypeFee',width:60,hidden:true};Columns.push(column);
	$HUI.datagrid("#tDHCEQUsedResource",{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQUsedResource",
	        	QueryName:"GetUsedResourceFee",
				SourceType:"1",
				SourceID:EquipDR
			},
			toolbar:[
				{
					iconCls:'icon-add',
					text:'新增',
					handler:function(){AddUsedResourceData();}
				}
			],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:[Columns],
	    	onClickRow: function (rowIndex,rowData) {onClickUsedResourceRow(rowIndex,rowData)},
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			onLoadSuccess: function (data) {
				for(i=0;i<data.total;i++)
				{
					$('#tDHCEQUsedResource').datagrid('beginEdit',i);
					var listinfo=data.rows[i].TTypeFee.split('&');
					for(j=0;j<listinfo.length;j++)
					{
			 			var list=listinfo[j].split('^');
			 			var ed=$('#tDHCEQUsedResource').datagrid('getEditor',{index:i,field:'Type'+list[0]});
			 			jQuery(ed.target).val(list[1]);  //设置ID
					}
					$('#tDHCEQUsedResource').datagrid('endEdit', i);
				}
			}
	});
	
}
function AddUsedResourceData()
{
	var val="&Year=&Month=&SourceType=1&SourceID="+EquipDR;
	url="dhceq.ba.usedresourcelist.csp?"+val;
	showWindow(url,"资源消耗信息","","","icon-w-paper","modal","","","small");
}

function onClickUsedResourceRow(index,rowData)
{
	var val="&Year="+rowData.TYear+'&Month='+rowData.TMonth+'&SourceType=1&SourceID='+EquipDR;
	url="dhceq.ba.usedresourcelist.csp?"+val;
	showWindow(url,"资源消耗信息","","","icon-w-paper","modal","","","small");
}
///modified by ZY0217 2020-04-08
function initResearch()
{	
	var Columns=getCurColumnsInfo("EM.G.Research",'','','')
	$HUI.datagrid("#tDHCEQResearch",{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSResearch",
	        	QueryName:"ResearchList",
		        BussType:"0", 		        
		        SourceType:"3",
		        SourceID:getElementValue("BELRowID"),
		        RFunProFlag:""
			},
			toolbar:[
				{
					iconCls:'icon-add',
					text:'新增',
					handler:function(){AddResearchData();}
				},'-----------------------------------',
				{
					iconCls:'icon-cancel',
					text:'删除',
					handler:function(){DeleteResearchData();}
				}
			],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
	    	onClickRow: function (rowIndex,rowData) {onClickResearchRow(rowIndex,rowData)},
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}
//modifed BY ZY0217 2020-04-08
function AddResearchData()
{
	if(editResearchIndex>="0"){
		$('#tDHCEQResearch').datagrid('endEdit', editResearchIndex);//结束编辑，传入之前编辑的行
	}
	$('#tDHCEQResearch').datagrid('appendRow', 
	{
		RRowID: '',
		RSourceType:'',
		RSourceID: '',
		RCode:'',
		RDesc:'',
		RType:'',
		RTypeDesc:'',
		RUserDR:'',
		RUserDR_UName:'',
		RParticipant:'',
		RLevel:'',
		RBeginDate:'',
		REndDate:'',
		RUsedFlag:'',
		RDevelopStatus:'',
		RDevelopStatusDesc:'',
		RInvalidFlag:'',
		RUpdateUser:'',
		RUpdateDate:'',
		RUpdateTime:'',
		RRemark:''
	});
	editResearchIndex=0;
}
//modifed BY ZY0217 2020-04-08
function DeleteResearchData()
{
	var DeleteRowID=""
	if (editResearchIndex>="0")
	{
		jQuery("#tDHCEQResearch").datagrid('endEdit', editResearchIndex);//结束编辑，传入之前编辑的行
		var rows = $('#tDHCEQResearch').datagrid('getRows');
		DeleteRowID=rows[editResearchIndex].RRowID
	}
	if(DeleteRowID!="")
	{
		var truthBeTold = window.confirm(t[-9203]);
		if (!truthBeTold) return;
	}
	else
	{
		messageShow("","","","无记录删除");
		return
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSResearch","SaveDataList",DeleteRowID,"","1");
	if (jsonData==0)
	{
		messageShow("","","","操作成功!");
		$('#tDHCEQResearch').datagrid('deleteRow',editResearchIndex)
	}
	else
    {
		messageShow("","","","错误信息:"+jsonData);
		return
    }
}

//modifed BY ZY0217 2020-04-08
function onClickResearchRow(index,rowData)
{
	//if (rowData.RBussType="") setElement("RBussType",rowData.DMDeviceSource);
	//if (rowData.RSourceType!="") setElement("RSourceType",rowData.DMDeviceSource);
	if (editResearchIndex!=index)
	{
		if (endResearchEditing())
		{
			$('#tDHCEQResearch').datagrid('selectRow', index).datagrid('beginEdit', index);
			editResearchIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQResearch').datagrid('getRows')[editResearchIndex]);
		} else {
			$('#tDHCEQResearch').datagrid('selectRow', editResearchIndex);
		}
	}
	else
	{
		endResearchEditing();
	}
}
//modifed BY ZY0217 2020-04-08
function endResearchEditing(){
	if (editResearchIndex == undefined){return true}
	if ($('#tDHCEQResearch').datagrid('validateRow', editResearchIndex)){
		$('#tDHCEQResearch').datagrid('endEdit', editResearchIndex);
		editResearchIndex = undefined;
		return true;
	} else {
		return false;
	}
}

//modifed BY ZY0217 2020-04-08
function GetResearchType(index,data)
{ 
	var rowData = $('#tDHCEQResearch').datagrid('getSelected');
	rowData.RType=data.TRowID;
	var RTypeEdt = $("#tDHCEQResearch").datagrid('getEditor', {index:editResearchIndex,field:'RTypeDesc'});
	$(RTypeEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch').datagrid('endEdit',editResearchIndex);
}
//modifed BY ZY0217 2020-04-08
function EQUser(index,data)
{ 
	var rowData = $('#tDHCEQResearch').datagrid('getSelected');
	rowData.RUserDR=data.TRowID;
	var RUserEdt = $("#tDHCEQResearch").datagrid('getEditor', {index:editResearchIndex,field:'RUserDR_UName'});
	$(RUserEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch').datagrid('endEdit',editResearchIndex);
}
//modifed BY ZY0217 2020-04-08
function GetFuncProjType(index,data)
{ 
	var rowData = $('#tDHCEQResearch').datagrid('getSelected');
	rowData.RDevelopStatus=data.TRowID;
	var RDevelopStatusEdt = $("#tDHCEQResearch").datagrid('getEditor', {index:editResearchIndex,field:'RDevelopStatusDesc'});
	$(RDevelopStatusEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch').datagrid('endEdit',editResearchIndex);
}

function fillData()
{
	var RowID=getElementValue("BELRowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitEquipList","GetOneEquipList",RowID)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}

function BSave_Clicked()
{
	var data=getInputList();
	data=JSON.stringify(data);
	//仪器对照数据
	var DeviceMapdataList=""
	var rows = $('#tDHCEQDeviceMap').datagrid('getRows');
	endDeviceMapEditing()
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if ((oneRow.DMDeviceSource=="")||(oneRow.DMDeviceDesc==""))
		{
			alertShow("'数据来源'页 第"+(i+1)+"行数据来源不正确!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (DeviceMapdataList=="")
		{
			DeviceMapdataList=RowData
		}
		else
		{
			DeviceMapdataList=DeviceMapdataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	//年度评价信息
	var UseContextYeardataList=""
	var rows = $('#tDHCEQUseContextYear').datagrid('getRows');
	endUseContextYearEditing()
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.UCYear=="")
		{
			alertShow("'年度评价'页 第"+(i+1)+"行数据来源不正确!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (UseContextYeardataList=="")
		{
			UseContextYeardataList=RowData
		}
		else
		{
			UseContextYeardataList=UseContextYeardataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	//月度经济信息
	var UseContextMonthdataList=""
	var rows = $('#tDHCEQUseContextMonth').datagrid('getRows');
	endUseContextMonthEditing()
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if ((oneRow.UCYear=="")||(oneRow.UCMonth==""))
		{
			alertShow("'月度经济信息'页 第"+(i+1)+"行数据必须通过系统报表汇总任务生成记录,之后才可修改!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (UseContextMonthdataList=="")
		{
			UseContextMonthdataList=RowData
		}
		else
		{
			UseContextMonthdataList=UseContextMonthdataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	//科研论文等
	var ResearchdataList=""
	var rows = $('#tDHCEQResearch').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		
		//modifed BY ZY0217 2020-04-08
		oneRow.RBussType=0;
		oneRow.RSourceType=3
		oneRow.RSourceID=getElementValue("BELRowID")
		if ((oneRow.RType=="")||(oneRow.RDesc==""))
		{
			alertShow("第"+(i+1)+"行数据不正确!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (ResearchdataList=="")
		{
			ResearchdataList=RowData
		}
		else
		{
			ResearchdataList=ResearchdataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 分隔符号修改
		}
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitEquipList","SaveData",data,"0",DeviceMapdataList,UseContextYeardataList,UseContextMonthdataList,ResearchdataList);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&RowID="+jsonData.Data;
		url="dhceq.ba.benefitequiplist.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if(GlobalObj.RowID==""){$.messager.alert('提示','设备不能为空！','warning');return;}
	var val=CombineData()
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQBenefitEquipList',
			MethodName:'SaveData',
			Arg1:GlobalObj.RowID,
			Arg2:"1",
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			alertShow(XMLHttpRequest.status);
			alertShow(XMLHttpRequest.readyState);
			alertShow(textStatus);
		},
		success:function(data,response,status)
		{
			
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			$.messager.progress('close');
			if(list[0]==0)
			{
				$.messager.show({title: '提示',msg: '更新成功'});
				GlobalObj.RowID=list[1]
				window.location.href='dhceq.process.benefitequiplist.csp?';
			}
			else
				$.messager.alert('更新失败！','错误代码:'+data, 'warning');
		}
	});
}


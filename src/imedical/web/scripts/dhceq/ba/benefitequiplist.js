var EquipDR=getElementValue("BELEquipDR")
var editDeviceMapIndex=undefined;
var editUseContextYearIndex=undefined;
var editUseContextMonthIndex=undefined;
var editResearchIndex=undefined;
/// add by ZY0279 20210907
var updateflag=""  //������ز�(ɾ��ԭ������)�����ǲ���(��ɾ���ݣ�����������ݺ�ִ��)
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	var obj=document.getElementById("Banner");
	if (obj){$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+EquipDR)}
	initUserInfo();
    initMessage("ba"); //��ȡ����ҵ����Ϣ
    initLookUp();
	defindTitleStyle(); 
  	initButton();
	fillData();
    initButtonWidth();
    initDeviceMap();
	$HUI.tabs("#tDHCEQBene",{
		onSelect:function(title)
		{
			if (title=="������Դ")
			{
				initDeviceMap()
			}
			else if (title=="�������")
			{
				initUseContextYear()
			}
			else if (title=="�¶Ⱦ�����Ϣ")
			{
				initUseContextMonth()
			}
			else if (title=="�¶ȳɱ���Ϣ")
			{
				initUsedResource()
			}
			else if (title=="������")
			{
				initServiceMap()
			}
			/// add by ZY0288 20211216
			else if (title=="������Ŀ")
			{
				initResearch(0)	//modifed BY ZY0217 2020-04-08
			}
			else if (title=="����")
			{
				initResearch(1)	//modifed BY ZY0217 2020-04-08
			}
			else if (title=="��������")
			{
				initResearch(2)	//modifed BY ZY0217 2020-04-08
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
					text:'����',
					handler:function(){AddDeviceMapData();}
				},
				{
					iconCls:'icon-cancel',
					text:'ɾ��',
					handler:function(){DeleteDeviceMapData();}
				}
			],
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
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

// ��������
function AddDeviceMapData()
{
	//modified by ZY0261 20210506
	if (EquipDR=="")
	{
		messageShow("","","","���ȱ��������Ϣ!");
		return
	}
	if(editDeviceMapIndex>="0"){
		$('#tDHCEQDeviceMap').datagrid('endEdit', editDeviceMapIndex);//�����༭������֮ǰ�༭����
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

///modified by ZY0247  2020-12-14
function DeleteDeviceMapData()
{
	var rows = $('#tDHCEQDeviceMap').datagrid('getSelected');  //ѡ��Ҫɾ������
	if(rows.length<=0){
		alertShow("��ѡ��Ҫɾ������.");
		return;
	}
	var DeleteRowID=(typeof rows.DMRowID == 'undefined') ? "" : rows.DMRowID
	if (DeleteRowID=="")
	{
		if(editDeviceMapIndex>="0"){
			$("#tDHCEQDeviceMap").datagrid('endEdit', editDeviceMapIndex);//�����༭������֮ǰ�༭����
			if(editDeviceMapIndex>="1")$("#tDHCEQDeviceMap").datagrid('deleteRow',editDeviceMapIndex)
		}
		return
	}
	else
	{
		var truthBeTold = window.confirm(t[-9203]);
		if (!truthBeTold) return;
		
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSDeviceMap","SaveData",DeleteRowID,"","1");
		if (jsonData==0)
		{
			messageShow("","","","�����ɹ�!");
			$('#tDHCEQDeviceMap').datagrid('deleteRow',editDeviceMapIndex)
		}
		else
	    {
			messageShow("","","","������Ϣ:"+jsonData);
			return
	    }
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
	if (editDeviceMapIndex>0)
	{
		var lastIndex=editDeviceMapIndex-1
		var lastSourceType=rows[lastIndex].DMDeviceSource
		if (lastSourceType!=data.DeviceSource)
		{
			alertShow("������Դ�������"+(lastIndex+1)+"�в�һ��!ͬһ�豸��������Դ����Ӧ����һ��!")
			return
		}
	}
	///modified by ZY0259 20210420
	var rowData = $('#tDHCEQDeviceMap').datagrid('getSelected');
	rowData.DMDeviceID="";
	var eg = $('#tDHCEQDeviceMap').datagrid('getEditor', {index:editDeviceMapIndex,field:'DMDeviceSource'});
	$(eg.target).combogrid("setValue",data.DeviceSource);
	var eg = $('#tDHCEQDeviceMap').datagrid('getEditor', {index:editDeviceMapIndex,field:'DMDeviceDesc'});
	$(eg.target).combogrid("setValue","");
	var eg = $('#tDHCEQDeviceMap').datagrid('getEditor', {index:editDeviceMapIndex,field:'DMRemark'});
	$(eg.target).val("");
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
		alertShow("������Դ�Ѿ����������豸,������ѡ��!")
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
					text:'����',
					handler:function(){AddUseContextYearData();}
				},
				{
					iconCls:'icon-cancel',
					text:'ɾ��',
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

// ��������
function AddUseContextYearData()
{
	//modified by ZY0261 20210506
	if (EquipDR=="")
	{
		messageShow("","","","���ȱ��������Ϣ!");
		return
	}
	if(editUseContextYearIndex>="0"){
		$('#tDHCEQUseContextYear').datagrid('endEdit', editUseContextYearIndex);//�����༭������֮ǰ�༭����
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
		jQuery("#tDHCEQUseContextYear").datagrid('endEdit', editUseContextYearIndex);//�����༭������֮ǰ�༭����
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
		messageShow("","","","�޼�¼ɾ��");
		return
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSUseContext","SaveData",DeleteRowID,"","1");
	if (jsonData==0)
	{
		messageShow("","","","�����ɹ�!");
		$('#tDHCEQUseContextYear').datagrid('deleteRow',editUseContextYearIndex)
	}
	else
    {
		messageShow("","","","������Ϣ:"+jsonData);
		return
    }
}
/// modified by ZY0279 20210907
///modified by ZY0247  2020-12-14
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
					text:'����',
					handler:function(){AddUseContextMonthData();}
				},
				{
					iconCls:'icon-update',
					text:'�ز�����',
					handler:function(){gatherUseContextMonthData();}
				},
				{
					iconCls:'icon-update',
					text:'��������',
					handler:function(){gatherUseContextMonthDataByDate();}
				}
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

// ��������
function AddUseContextMonthData()
{
	//modified by ZY0261 20210506
	if (EquipDR=="")
	{
		messageShow("","","","���ȱ��������Ϣ!");
		return
	}
	if(editUseContextMonthIndex>="0"){
		$('#tDHCEQUseContextMonth').datagrid('endEdit', editUseContextMonthIndex);//�����༭������֮ǰ�༭����
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
/// modified by ZY0279 20210907
///����ɼ�һ��ʱ���
function gatherUseContextMonthDataByDate()
{
	var CurTime=getElementValue("CurTime")
	if ((CurTime>=28800)&&(CurTime<=64800))
	{
		alertShow("(8:00--18:00)�ϰ�߷��ڽ�ֹ��������!")
		return
	}
	
    $HUI.dialog('#UpdateBAEQWin', {
		width: 300,
		height: 200,
		modal:true,
		title: '��д�������ݵ�ʱ��',
		buttons:[{
			text:'�ɼ�',
			handler:function(){
				var vStartDate=getElementValue("vStartDate")
				var vEndDate=getElementValue("vEndDate")
				if ((vStartDate=="")||(vEndDate==""))
				{
					alertShow("ʱ�䲻��Ϊ��!")
					return
				}
				
				setElement("StartDate",vStartDate)
				setElement("EndDate",vEndDate)
				updateflag=1
				confirmGatherDataFun()
				
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog("#UpdateBAEQWin").close();
				}
			}],
		onOpen: function(){
			//ִ�н����ʼ��
			setRequiredElements("vStartDate^vStartDate")
		}
	}).open();
}
/// modified by ZY0279 20210907
//�زɵ�ǰ��
function BgatherUseContextMonthData()
{
	var rowData =  $("#tDHCEQUseContextMonth").datagrid("getRows")[editUseContextMonthIndex];
	var UCRowID=rowData.UCRowID;
    var UCYear=rowData.UCYear;
    var UCMonth=rowData.UCMonth;
	var SysDateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
	var StartDate=tkMakeServerCall("web.DHCEQReport","GetReportDate",UCYear+"-"+UCMonth,"1",SysDateFormat);
	var EndDate=tkMakeServerCall("web.DHCEQReport","GetReportDate",UCYear+"-"+UCMonth,"2",SysDateFormat);
		
	if ((StartDate=="")||(EndDate==""))
	{
		alertShow("'�ɼ��·ݲ���Ϊ��'����Ϊ��!")
		return
	}
	
	setElement("StartDate",StartDate)
	setElement("EndDate",EndDate)
	var MsgDesc='�������豸��"'+StartDate+'"��"'+EndDate+'"ʱ����ڵ�ʹ�ü�¼����,�����ݷ������Ķ������ɲ�����������.�ɼ����ݺ�ʱ�ϳ�,��ȴ�������ʾ���!'
	messageShow("confirm","","",MsgDesc,"",function(){
		updateflag=1
		confirmGatherDataFun()
		},"")
}
/// modified by ZY0279 20210907
///modified by ZY0247  2020-12-14
///���²ɼ����ݴӷ�����ʼ��ȿ�ʼ
function gatherUseContextMonthData()
{
	//modified by ZY0261 20210506
	if (EquipDR=="")
	{
		messageShow("","","","���ȱ��������Ϣ!");
		return
	}
	var CurTime=getElementValue("CurTime")
	if ((CurTime>=28800)&&(CurTime<=64800))
	{
		alertShow("(8:00--18:00)�ϰ�߷��ڽ�ֹ�ز�����!")
		return
	}
	var DMDeviceSource=getElementValue("DMDeviceSource")
	if (DMDeviceSource=="DHC-HIS")
	{
		var rows = $('#tDHCEQServiceMap').datagrid('getRows');
		if (rows.length<1)
		{
			alertShow("'������'ҳ ����������Ϣ����Ϊ��!")
			return
		}
	}
	else
	{
		var rows = $('#tDHCEQDeviceMap').datagrid('getRows');
		if (rows.length<1)
		{
			alertShow("'������Դ'ҳ ������Դ������Ϣ����Ϊ��!")
			return
		}
	}
	
	var BELInitYear=getElementValue("BELInitYear")
	if (BELInitYear=="")
	{
		alertShow("'������ʼ���'����Ϊ��!")
		return
	}
	else
	{
		var SysDateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
		var StartDate=tkMakeServerCall("web.DHCEQReport","GetReportDate",BELInitYear+"-01","1",SysDateFormat);
		var EndDate=GetCurrentDate()
		setElement("StartDate",StartDate)
		setElement("EndDate",EndDate)
	}
	var StartDate=getElementValue("StartDate")
	var EndDate=getElementValue("EndDate")
	if ((StartDate=="")||(EndDate==""))
	{
		alertShow("�ɼ�ʱ��Ϊ��!")
		return
	}
	var MsgDesc='����'+DMDeviceSource+'ϵͳ�вɼ��豸��"'+StartDate+'"��"'+EndDate+'"ʱ����ڵ�ʹ�ü�¼����,�����ݷ������Ķ������ɲ�����������.�ɼ����ݺ�ʱ�ϳ�,��ȴ�������ʾ���!'
	messageShow("confirm","","",MsgDesc,"",confirmGatherDataFun,"")
}
/// modified by ZY0279 20210907
function confirmGatherDataFun()
{
	var SourceType=1
	var SourceID=EquipDR
	var DMDeviceSource=getElementValue("DMDeviceSource")
	if (DMDeviceSource=="")
	{
		alertShow("'������Դ'ҳ ������Դ������Ϣ����Ϊ��!")
		return
	}
	var StartDate=getElementValue("StartDate")
	var EndDate=getElementValue("EndDate")
	//modified by ZY 202208-08  2690292
	var DateNum=DateDiff(EndDate,StartDate)
	if (DateNum>30)
	{
		alertShow("��Ҫ�ɼ������ݳ���һ����,����������Ӱ����������ȶ�,��ʹ�ò������ݵ�������вɼ�!")
		return
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitEquipList","GatherData",SourceType,SourceID,DMDeviceSource,StartDate,EndDate,updateflag)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","","","�����ɹ�!");
		$("#tDHCEQUseContextMonth").datagrid("reload"); 
		return
	}
	else
    {
		messageShow("","","","������Ϣ:"+jsonData.Data);
		return
    }
}
///modified by ZY0254 20210203
///modified by ZY0247  2020-12-14
function initServiceMap()
{
	var BussType=0
	var SourceType=1
	var SourceID=getElementValue("BELEquipDR")
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
					text:'����',
					handler:function(){AddServiceData();}
				},
				{
					iconCls:'icon-cancel',
					text:'ɾ��',
					handler:function(){DeleteServiceData();}
				},
				{
					iconCls:'icon-export',
					text:'����(������)',
					handler:function(){SaveServiceData();}
				},
				{
					iconCls:'icon-import',
					text:'����(��������������)',
					handler:function(){ImportServiceConsumableData();}
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
	//modified by ZY0261 20210506
	if (EquipDR=="")
	{
		messageShow("","","","���ȱ��������Ϣ!");
		return
	}
	var str="dhceq.ba.historylocservice.csp?&SLocDR="+getElementValue("StoreLocDR")+"&BussType=0&SourceType=1&SourceID="+EquipDR
	showWindow(str,"������ʷҽ����","","","icon-w-paper","modal","","","large",initServiceMap)	//modified by ZY0259 20210420
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
		messageShow("","","","�޼�¼ɾ��");
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
		messageShow("","","","�����ɹ�!");
		$("#tDHCEQServiceMap").datagrid("reload"); //add by sjh SJH0045 2021-02-20
		findEquipService()
	}
	else
    {
		messageShow("","","","������Ϣ:"+jsonData.Data);
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
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
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

///modified by ZY0247  2020-12-14
function SaveServiceData()
{
	var str="dhceq.stat.equipservice.csp?&ReportFileName=DHCEQEquipService.raq"+'&BussType=0&SourceType=1&SourceID='+getElementValue("BELEquipDR")
	showWindow(str,"��������ϸ����","","","icon-w-paper","modal","","","large")
}
function ImportServiceConsumableData()
{
	//modified by ZY0261 20210506
	if (EquipDR=="")
	{
		messageShow("","","","���ȱ��������Ϣ!");
		return
	}
	var str="dhceq.plat.importdata.csp?&TableListOptions='ServiceConsumable^����������������'"
	showWindow(str,"���������������ݵ���","","","icon-w-paper","modal","","","large")
}
function initUsedResource()
{
	var Columns=new Array();
	var column={field:'TYear',title:'���',width:60};Columns.push(column);
	var column={field:'TMonth',title:'�·�',width:60};Columns.push(column);
	data=tkMakeServerCall("web.DHCEQCResourceType","GetAllResourceType")
	data=data.replace(/\ +/g,"")	//ȥ���ո�
	data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
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
					text:'����',
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
			 			jQuery(ed.target).val(list[1]);  //����ID
					}
					$('#tDHCEQUsedResource').datagrid('endEdit', i);
				}
			}
	});
	
}
///modified by ZY0254 20210203
function AddUsedResourceData()
{
	//modified by ZY0261 20210506
	if (EquipDR=="")
	{
		messageShow("","","","���ȱ��������Ϣ!");
		return
	}
	var val="&Year=&Month=&SourceType=1&SourceID="+EquipDR;
	url="dhceq.ba.usedresourcelist.csp?"+val;
	showWindow(url,"��Դ������Ϣ","900","800","icon-w-paper","modal","","","small",initUsedResource);
}
///modified by ZY0254 20210203
function onClickUsedResourceRow(index,rowData)
{
	var val="&Year="+rowData.TYear+'&Month='+rowData.TMonth+'&SourceType=1&SourceID='+EquipDR;
	url="dhceq.ba.usedresourcelist.csp?"+val;
	showWindow(url,"��Դ������Ϣ","900","800","icon-w-paper","modal","","","small",initUsedResource);
}
/// modified by ZY0288 20211216
/// modified by ZY0279 20210907
//modified by ZY0259 20210420  �޸�sourcetype��sourceid
///modified by ZY0217 2020-04-08
function initResearch(type)
{
	if (type==0)
	{
		var TableID="tDHCEQResearch0"
		var RFunProFlag=0
		var Columns=getCurColumnsInfo("EM.G.Research",'','','')
	}
	else if (type==1)
	{
		var TableID="tDHCEQResearch1"
		var RFunProFlag=1
		var Columns=getCurColumnsInfo("EM.G.ResearchP",'','','')
	}
	else if (type==2)
	{
		var TableID="tDHCEQResearch2"
		var RFunProFlag=2
		var Columns=getCurColumnsInfo("EM.G.ResearchS",'','','')
	}
	$HUI.datagrid("#"+TableID,{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSResearch",
	        	QueryName:"ResearchList",
		        BussType:"0", 		        
		        SourceType:"2",
		        SourceID:EquipDR,
		        RFunProFlag:RFunProFlag
			},
			toolbar:[
				{
					iconCls:'icon-add',
					text:'����',
					handler:function(){AddResearchData(TableID,RFunProFlag);}
				},
				{
					iconCls:'icon-cancel',
					text:'ɾ��',
					handler:function(){DeleteResearchData(TableID,RFunProFlag);}
				}
			],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
	    	onClickRow: function (rowIndex,rowData) {onClickResearchRow(rowIndex,rowData,TableID)},
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}
/// modified by ZY0279 20210907
//modifed BY ZY0217 2020-04-08
function AddResearchData(TableID,RFunProFlag)
{
	//modified by ZY0261 20210506
	if (EquipDR=="")
	{
		messageShow("","","","���ȱ��������Ϣ!");
		return
	}
	if(editResearchIndex>="0"){
		$("#"+TableID).datagrid('endEdit', editResearchIndex);//�����༭������֮ǰ�༭����
	}
	$("#"+TableID).datagrid('appendRow', 
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
/// modified by ZY0279 20210907
//modifed BY ZY0217 2020-04-08
function DeleteResearchData(TableID,RFunProFlag)
{
	var DeleteRowID=""
	if (editResearchIndex>="0")
	{
		jQuery("#"+TableID).datagrid('endEdit', editResearchIndex);//�����༭������֮ǰ�༭����
		var rows = $("#"+TableID).datagrid('getRows');
		DeleteRowID=rows[editResearchIndex].RRowID
	}
	if(DeleteRowID!="")
	{
		var truthBeTold = window.confirm(t[-9203]);
		if (!truthBeTold) return;
	}
	else
	{
		messageShow("","","","�޼�¼ɾ��");
		return
	}
	
	/// modified by ZY0287 20211216
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSResearch","SaveDataList",DeleteRowID,"1");
	if (jsonData==0)
	{
		messageShow("","","","�����ɹ�!");
		$("#"+TableID).datagrid('deleteRow',editResearchIndex)
	}
	else
    {
		messageShow("","","","������Ϣ:"+jsonData);
		return
    }
}
/// modified by ZY0279 20210907
//modifed BY ZY0217 2020-04-08
function onClickResearchRow(index,rowData,TableID)
{
	//if (rowData.RBussType="") setElement("RBussType",rowData.DMDeviceSource);
	//if (rowData.RSourceType!="") setElement("RSourceType",rowData.DMDeviceSource);
	if (editResearchIndex!=index)
	{
		/// modified by ZY0287 20211216
		if (endResearchEditing(TableID))
		{
			$("#"+TableID).datagrid('selectRow', index).datagrid('beginEdit', index);
			editResearchIndex = index;
			modifyBeforeRow = $.extend({},$("#"+TableID).datagrid('getRows')[editResearchIndex]);
		} else {
			$("#"+TableID).datagrid('selectRow', editResearchIndex);
		}
	}
	else
	{
		endResearchEditing(TableID);
	}
}
//modifed BY ZY0217 2020-04-08
function endResearchEditing(TableID){
	if (editResearchIndex == undefined){return true}
	if ($("#"+TableID).datagrid('validateRow', editResearchIndex)){
		$("#"+TableID).datagrid('endEdit', editResearchIndex);
		editResearchIndex = undefined;
		return true;
	} else {
		return false;
	}
}

//modifed BY ZY0217 2020-04-08
function GetResearchType(index,data)
{ 
	var rowData = $('#tDHCEQResearch1').datagrid('getSelected');
	rowData.RType=data.TRowID;
	var RTypeEdt = $("#tDHCEQResearch1").datagrid('getEditor', {index:editResearchIndex,field:'RTypeDesc'});
	$(RTypeEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch1').datagrid('endEdit',editResearchIndex);
}
//modified by ZY0301 20220523
//modifed BY ZY0217 2020-04-08
function EQUser(index,data)
{
	var rowData = $('#tDHCEQResearch0').datagrid('getSelected');
	rowData.RUserDR=data.TRowID;
	var RUserEdt = $("#tDHCEQResearch0").datagrid('getEditor', {index:editResearchIndex,field:'RUserDR_UName'});
	$(RUserEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch0').datagrid('endEdit',editResearchIndex);
}
//modified by ZY0301 20220523
function EQUserS(index,data)
{ 
	var rowData = $('#tDHCEQResearch1').datagrid('getSelected');
	rowData.RUserDR=data.TRowID;
	var RUserEdt = $("#tDHCEQResearch1").datagrid('getEditor', {index:editResearchIndex,field:'RUserDR_UName'});
	$(RUserEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch1').datagrid('endEdit',editResearchIndex);
}
//modifed BY ZY0217 2020-04-08
function GetFuncProjType(index,data)
{ 
	var rowData = $('#tDHCEQResearch2').datagrid('getSelected');
	rowData.RDevelopStatus=data.TRowID;
	var RDevelopStatusEdt = $("#tDHCEQResearch2").datagrid('getEditor', {index:editResearchIndex,field:'RDevelopStatusDesc'});
	$(RDevelopStatusEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch2').datagrid('endEdit',editResearchIndex);
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
/// modified by ZY0279 20210907
function BSave_Clicked()
{
    ///modified by ZY0256 20210315
    var BELInitYear=getElementValue("BELInitYear");
    if ((BELInitYear<2010)||(BELInitYear>2040))
    {
        alertShow("'������ʼ���'��д������,���޸�!")
        return;
    }
        
    var data=getInputList();
    data=JSON.stringify(data);
    //������������
    var DeviceMapdataList=""
    var rows = $('#tDHCEQDeviceMap').datagrid('getRows');
    endDeviceMapEditing()
    for (var i = 0; i < rows.length; i++) 
    {
        var oneRow=rows[i]
        if ((oneRow.DMDeviceSource=="")||(oneRow.DMDeviceDesc==""))
        {
            alertShow("'������Դ'ҳ ��"+(i+1)+"��������Դ����ȷ!")
            return "-1"
        }
        var RowData=JSON.stringify(rows[i])
        if (DeviceMapdataList=="")
        {
            DeviceMapdataList=RowData
        }
        else
        {
            DeviceMapdataList=DeviceMapdataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
        }
    }
    //���������Ϣ
    var UseContextYeardataList=""
    var rows = $('#tDHCEQUseContextYear').datagrid('getRows');
    endUseContextYearEditing()
    for (var i = 0; i < rows.length; i++) 
    {
        var oneRow=rows[i]
        if (oneRow.UCYear=="")
        {
            alertShow("'�������'ҳ ��"+(i+1)+"����Ȳ���Ϊ��!") /// modified by ZY0288 20211216
            return "-1"
        }
        var RowData=JSON.stringify(rows[i])
        if (UseContextYeardataList=="")
        {
            UseContextYeardataList=RowData
        }
        else
        {
            UseContextYeardataList=UseContextYeardataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
        }
    }
    //�¶Ⱦ�����Ϣ
    var UseContextMonthdataList=""
    var rows = $('#tDHCEQUseContextMonth').datagrid('getRows');
    endUseContextMonthEditing()
    for (var i = 0; i < rows.length; i++) 
    {
        var oneRow=rows[i]
        if ((oneRow.UCYear=="")||(oneRow.UCMonth==""))
        {
            alertShow("'�¶Ⱦ�����Ϣ'ҳ ��"+(i+1)+"�����ݱ���ͨ��ϵͳ��������������ɼ�¼,֮��ſ��޸�!")
            return "-1"
        }
        var RowData=JSON.stringify(rows[i])
        if (UseContextMonthdataList=="")
        {
            UseContextMonthdataList=RowData
        }
        else
        {
            UseContextMonthdataList=UseContextMonthdataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
        }
    }
    /// modified by ZY0288 20211216
    //����
    var ResearchdataList=""
    var rows = $('#tDHCEQResearch0').datagrid('getRows');
    ///modified by ZY 20220913 2690292 2690311
    $("#tDHCEQResearch0").datagrid('endEdit', editResearchIndex);
    //endResearchEditing("tDHCEQResearch0")
    for (var i = 0; i < rows.length; i++) 
    {
        var oneRow=rows[i]
        //modified by ZY0259 20210420  �޸�sourcetype��sourceid
        //modifed BY ZY0217 2020-04-08
        oneRow.RBussType=0;
        oneRow.RSourceType=2
        oneRow.RSourceID=EquipDR
        oneRow.RType=0
        if (oneRow.RDesc=="")
        {
            alertShow("'������Ŀ'ҳ ��"+(i+1)+"�����ݲ���ȷ!")
            return "-1"
        }
        var RowData=JSON.stringify(rows[i])
        if (ResearchdataList=="")
        {
            ResearchdataList=RowData
        }
        else
        {
            ResearchdataList=ResearchdataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
        }
    }
    //����
    var rows = $('#tDHCEQResearch1').datagrid('getRows');
    ///modified by ZY 20220913 2690292 2690311
    $("#tDHCEQResearch1").datagrid('endEdit', editResearchIndex);
    //endResearchEditing("tDHCEQResearch1")
    for (var i = 0; i < rows.length; i++) 
    {
        var oneRow=rows[i]
        //modified by ZY0259 20210420  �޸�sourcetype��sourceid
        //modifed BY ZY0217 2020-04-08
        oneRow.RBussType=0;
        oneRow.RSourceType=2
        oneRow.RSourceID=EquipDR
        oneRow.RType=1
        if (oneRow.RDesc=="")
        {
            alertShow("'����'ҳ ��"+(i+1)+"�����ݲ���ȷ!")
            return "-1"
        }
        var RowData=JSON.stringify(rows[i])
        if (ResearchdataList=="")
        {
            ResearchdataList=RowData
        }
        else
        {
            ResearchdataList=ResearchdataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
        }
    }
    var rows = $('#tDHCEQResearch2').datagrid('getRows');
    ///modified by ZY 20220913 2690292 2690311
    $("#tDHCEQResearch2").datagrid('endEdit', editResearchIndex);
    //endResearchEditing("#tDHCEQResearch2")
    for (var i = 0; i < rows.length; i++) 
    {
        var oneRow=rows[i]
        //modified by ZY0259 20210420  �޸�sourcetype��sourceid
        //modifed BY ZY0217 2020-04-08
        oneRow.RBussType=0;
        oneRow.RSourceType=2
        oneRow.RSourceID=EquipDR
        oneRow.RType=2
        if ((oneRow.RType=="")||(oneRow.RDesc==""))
        {
            alertShow("'������Ŀ'ҳ ��"+(i+1)+"�����ݲ���ȷ!")
            return "-1"
        }
        var RowData=JSON.stringify(rows[i])
        if (ResearchdataList=="")
        {
            ResearchdataList=RowData
        }
        else
        {
            ResearchdataList=ResearchdataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
        }
    }
    var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitEquipList","SaveData",data,"0",DeviceMapdataList,UseContextYeardataList,UseContextMonthdataList,ResearchdataList);
    jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
        var val="&RowID="+jsonData.Data;
        url="dhceq.ba.benefitequiplist.csp?"+val
        if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
        ///modified by ZY0272 20210628
        websys_showModal("options").mth();
		window.location.reload(url);
	    //window.location.href= url;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
///modified by ZY0255 20210301
function BDelete_Clicked()
{
	var RowID=getElementValue("BELRowID");
	if(RowID=="")
	{
		alertShow("'����Ϊ��!")
		return
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitEquipList","SaveData",RowID,"1");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var para="&QXType="+getElementValue("QXType")
		var url="dhceq.ba.benefitequiplist.csp?"+para;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		///modified by ZY0272 20210628
        websys_showModal("options").mth();
		///modified by ZY0274 20210712
        closeWindow('modal');
		//window.location.reload(url);
	    //window.location.href= url;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}


//var EquipRangeMastitemcolumns=GetCurColumnsInfo('EquipRangeMastitem','','',''); 
//界面入口
$(document).ready(function () {
	initDocument();
	});

/*jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);*/
function initDocument()
{
	initCombogrid();
	initTopPanel();
	
}
//初始化查询头面板
function initTopPanel()
{
	initDataGridPanel();
	jQuery("#BSave").linkbutton({iconCls: 'icon-save'});
	jQuery("#BSave").on("click", BSave_Clicked);
	jQuery("#BSubmit").linkbutton({iconCls: 'icon-ok'});
	jQuery("#BSubmit").on("click", BSubmit_Clicked);
	jQuery("#BDelete").linkbutton({iconCls: 'icon-cancel'});
	jQuery("#BDelete").on("click", BDelete_Clicked);
	//jQuery("#EquipList").on("click", EquipList_Clicked);
	//jQuery("#RowID").val(9)
	FillData();
	FillEquipRangeData();
	initDataGrid();
	SetEnabled();
	CheckContrl();
	
	

}
function initDataGridPanel()
{
	$("#EquipType").combogrid({
		panelWidth: 450, 
		multiple: true,
		rownumbers: true,
		idField:'rowid',
		textField:'desc',
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:'web.DHCEQCManageLimit',
			QueryName:'GetValue',
			Arg1:'1',Arg2:'',
			ArgCnt:2
			},
		columns:[[
			{field:'ck',checkbox:true},
			{field:'rowid',title:'rowid',width:30,align:'center',hidden:true},
			{field:'desc',title:'描述',width:170,align:'center',width:350}
		]]
		});
	$("#StatCat").combogrid({
		panelWidth: 450, 
		multiple: true,
		rownumbers: true,
		idField:'rowid',
		textField:'desc',
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:'web.DHCEQCManageLimit',
			QueryName:'GetValue',
			Arg1:'2',Arg2:'',
			ArgCnt:2
			},
		columns:[[
			{field:'ck',checkbox:true},
			{field:'rowid',title:'rowid',width:30,align:'center',hidden:true},
			{field:'desc',title:'描述',width:170,align:'center',width:350}
		]],
		onLoadSuccess:function(data) {
				
				},
		onSelect: function(rowIndex, rowData) {
				}
		});
	
}
/*
 *Description:列表数据加载
 *author:李苗苗
*/
function initDataGrid()
{
	EquipRangeLocDataGrid("DHCEQLoc","4","科室列表");
	EquipRangeMastitemDataGrid("DHCEQMastitem","6","设备项列表");
	EquipRangeEquipDataGrid("DHCEQEquip","5","设备列表");
}
/*
 *Description:点击添加弹出列表添加界面
 *params:SourceType：列表类型序号
 *author:李苗苗
*/
function AddgridData(type)
{
	if(type==4)
	{
		url="dhceqmaintloclimitlist.csp?"+"&SourceType="+type;	
	}
	else if(type==5)
	{
		url="dhceqmaintequiplimitlist.csp?"+"&SourceType="+type;	
	}
	else if(type==6)
	{
		url="dhceqmaintmasteritemlimitlist.csp?"+"&SourceType="+type;	
	}
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
    window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	
}
/*
 *Description:勾选框控制列表是否隐藏
 *author:李苗苗
*/
function CheckContrl()
{
	if($("#LocFlag").is(':checked')==false) $('#div-DHCEQLoc').hide()
	if($("#ItemFlag").is(':checked')==false) $('#div-DHCEQMastitem').hide()
	if($("#EquipFlag").is(':checked')==false) $('#div-DHCEQEquip').hide()
	if($("#TempPlanflag").is(':checked')==true)
	{
		$("#CycleNum").textbox({disabled:true});
		$("#CycleUnit").combogrid({disabled:true});
		//$("#CycleUnit").combogrid("disable");
		$("#CycleUnit").combogrid('setValue','')
		$("#CycleUnit").combogrid('setText','')
		
	}
	if($("#FixTimeflag").is(':checked')==true)
	{
		$("#SDate").datebox("enable");
		$("#EDate").datebox("enable");
	}
	//PanelHidden();
	
	$('#LocFlag').change(function() { 
		if($("#LocFlag").is(':checked')==true)
		{
			$('#div-DHCEQLoc').show()
			$('#DHCEQLoc').datagrid('reload');

		}
		else
		{
			$('#div-DHCEQLoc').hide()
		}
	}); 
	$('#ItemFlag').change(function() { 
		if($("#ItemFlag").is(':checked')==true)
		{
			$('#div-DHCEQMastitem').show()
			$('#DHCEQMastitem').datagrid('reload');

		}
		else
		{
			$('#div-DHCEQMastitem').hide()
		}
	}); 
	$('#EquipFlag').change(function() { 
		if($("#EquipFlag").is(':checked')==true)
		{
			$('#div-DHCEQEquip').show()
			$('#DHCEQEquip').datagrid('reload');

		}
		else
		{
			$('#div-DHCEQEquip').hide()
		}
	}); 
	$('#TempPlanflag').change(function() { 
		if($("#TempPlanflag").is(':checked')==true)
		{
			
			$("#CycleUnit").combogrid({disabled:true});
			$("#CycleNum").textbox({disabled:true});
			$("#CycleNum").textbox('setValue','');
			//$("#CycleUnit").combogrid("disable");
			$("#CycleUnit").combogrid('setValue','')
			$("#CycleUnit").combogrid('setText','')
			$("#SDate").datebox("disable");
			$("#EDate").datebox("disable");
			$("#FixTimeflag").removeAttr("disabled");
			$("#FixTimeflag").attr("disabled","true");

		}
		else
		{
			
			$("#CycleNum").textbox({disabled:false});
			$("#CycleUnit").combogrid({disabled:false});
			$("#FixTimeflag").removeAttr("disabled");
			//$("#CycleUnit").combogrid("enable");
		}
	}); 
	$('#FixTimeflag').change(function() { 
		if($("#FixTimeflag").is(':checked')==true)
		{

			$("#SDate").datebox("enable");
			$("#EDate").datebox("enable");

		}
		else
		{
			$("#SDate").datebox("disable");
			$("#EDate").datebox("disable");
		}
	}); 

	
}
function PanelHidden()
{
	jQuery("input[type='checkbox']").each(function() {

		$(this).change(function() { 
			if($(this).is(':checked')==true)
			{
				$(this).parent().show()

			}
			else
			{
				$(this).parent().hide()
			}
		}); 
	}); 

	
}
/*
 *Description:列表插入新行
 *params:SourceType：列表类型序号 copyrows:列表数据数组
 *author:李苗苗
*/
function insertLocRow(SourceType,copyrows)
{
	len=copyrows.length
	for(i=0;i<len;i++)
	{
			var ComponentID="DHCEQLoc"
			var morows = $("#"+ComponentID).datagrid("getRows")
			var index=morows.length;
    		var vallist=""
				$.each(morows, function(rowIndex, rowData){
					if (vallist=="")
					{ 
						vallist=","+rowData.valuedr+",";
					}
					 else vallist=vallist+rowData.valuedr+","; 
				}); 
				if (vallist.indexOf(","+copyrows[i].Hidden+",")==-1)
				{
					$("#"+ComponentID).datagrid('appendRow',{ 
						 rowid : '',
						 equiprangedr:equiprangedr,
						 typedr : SourceType,
						 //type : Desc,
						 valuedr : copyrows[i].Hidden,
						 value : copyrows[i].Desc,
						 code : copyrows[i].Code,
						 accessflag:'Y'
						})  
					var equiprangedr=""	
					
				}
	}
}
/*
 *Description:列表插入新行
 *params:SourceType：列表类型序号 copyrows:列表数据数组
 *author:李苗苗
*/
function insertMastitemRow(SourceType,copyrows)
{
	len=copyrows.length
	for(i=0;i<len;i++)
	{
			var ComponentID="DHCEQMastitem"
			var morows = $("#"+ComponentID).datagrid("getRows");
			var index=morows.length;
    		var vallist=""
				$.each(morows, function(rowIndex, rowData){
					if (vallist=="")
					{ 
						vallist=","+rowData.valuedr+",";
					}
					 else vallist=vallist+rowData.valuedr+","; 
				}); 
				if (vallist.indexOf(","+copyrows[i].TRowID+",")==-1)
				{
					$("#"+ComponentID).datagrid('appendRow',{ 
				             	rowid : '',
				             	equiprangedr:equiprangedr,
				             	typedr : SourceType,
				             	//type : Desc,
				             	valuedr : copyrows[i].TRowID,
				             	value : copyrows[i].TDesc,
				             	equiptypedr : copyrows[i].TDesc,
				             	equiptypedesc : copyrows[i].TEquipType,
				             	accessflag:'Y'
				     })  
			
					var equiprangedr=""
					
				}
	}
}
/*
 *Description:列表插入新行
 *params:SourceType：列表类型序号 copyrows:列表数据数组
 *author:李苗苗
*/
function insertEquipRow(SourceType,copyrows)
{
	len=copyrows.length
	for(i=0;i<len;i++)
	{
			var ComponentID="DHCEQEquip"
			var morows = $("#"+ComponentID).datagrid("getRows");
			var index=morows.length;
    		var vallist=""
				$.each(morows, function(rowIndex, rowData){
					if (vallist=="")
					{ 
						vallist=","+rowData.valuedr+",";
					}
					 else vallist=vallist+rowData.valuedr+","; 
				}); 
				if (vallist.indexOf(","+copyrows[i].RowID+",")==-1)
				{
					$("#"+ComponentID).datagrid('appendRow',{ 
				             	rowid : '',
				             	equiprangedr:equiprangedr,
				             	typedr : SourceType,
				             	//type : Desc,
				             	valuedr : copyrows[i].RowID,
				             	value : copyrows[i].Name,
				             	no : copyrows[i].TNo,
				             	model : copyrows[i].Model,
				             	useloc : copyrows[i].UseLoc,
				             	leavefactoryno : copyrows[i].LeaveFactoryNo,
				             	equiptypedesc : copyrows[i].TEquipType,
				             	accessflag:'Y'
				     })  			
					var equiprangedr=""
					
				}
				
	}
}
/*
 *Description:列表插入新行
 *params:SourceType：列表类型序号 RowID:当前行RowID index：当前行行号
 *author:李苗苗
*/
function deleterow(rowlist)
{
	var rowlist=rowlist.split(",")
	var SourceType=rowlist[0]
	var RowID=rowlist[1]
	var index=rowlist[2]
	if (SourceType==4){
		var ComponentID="DHCEQLoc"
		}
	else if (SourceType==6){
		var ComponentID="DHCEQMastitem"
		}
	else if (SourceType==5){
		var ComponentID="DHCEQEquip"
		}
	if(RowID=="")
	{
		$("#"+ComponentID).datagrid('deleteRow',index);
	}
	else
	{
		
		var Rtn = tkMakeServerCall("web.DHCEQEquipRange", "DeleteManageLimitList",RowID);
		if (Rtn ==0) {
			alertShow("删除成功!")
			$("#"+ComponentID).datagrid('reload',{
		        ClassName:"web.DHCEQEquipRange",
		        QueryName:"GetEquipRangeList",
		        Arg1:$('#EquipRangeDR').val(),
		        Arg2:SourceType,
		        Arg3:'',
		        ArgCnt:3
			});
							
		}
		else
		{
			$.messager.alert('删除失败！',data, 'warning')
			return;
		}
		
	}
		
	
}
/*
 *Description:计划填充事件
 *author:李苗苗
*/
function FillData()
{
	
	var RowID=getJQValue($("#RowID"));
  	if ((RowID=="")||(RowID==0)) return;
  	
	var list = tkMakeServerCall("web.DHCEQMaintPlanNew", "GetOneMaintPlan",RowID);
	list=list.replace(/\ +/g,"")	//去掉空格
	list=list.replace(/[\r\n]/g,"")	//去掉回车换行
	list=list.split("^");

	var sort=50;		
	setJQValue($("#Name"),list[0]);
	setJQValue($("#Type"),list[1]);
	setJQValue($("#Content"),list[5]);
	setJQValue($("#CycleNum"),list[6]);
	setJQValue($("#CycleUnitDR"),list[7]);
	setJQValue($("#MaintTypeDR"),list[8]);
	setJQValue($("#FromDate"),list[9]);
	//setJQValue($("#EndDate"),list[10]);
	setJQValue($("#PreWarnDaysNum"),list[11]);
	setJQValue($("#MaintFee"),list[12]);
	setJQValue($("#MaintLocDR"),list[13]);
	setJQValue($("#MaintUserDR"),list[14]);
	setJQValue($("#MaintModeDR"),list[15]);
	setJQValue($("#MeasureDeptDR"),list[18]);
	setJQValue($("#MeasureHandler"),list[19]);
	setJQValue($("#MeasureTel"),list[20]);
	setJQValue($("#ServiceDR"),list[21]);
	setJQValue($("#ServiceHandler"),list[22]);
	setJQValue($("#ServiceTel"),list[23]);
	setJQValue($("#Remark"),list[24]);
	setJQValue($("#Status"),list[25]);
	setJQValue($("#InvalidFlag"),list[35]);
	setJQValue($("#Hold1"),list[39]);
	setJQValue($("#Hold2"),list[40]);
	setJQValue($("#Hold3"),list[41]);
	setJQValue($("#Hold4"),list[42]);
	setJQValue($("#Hold5"),list[43]);
	setJQValue($("#TotalFee"),list[44]);
	if(list[45]=="Y") jQuery("#TempPlanflag").prop("checked",true); 
	if(list[45]=="N") jQuery("#TempPlanflag").prop("checked",false); 
	//$("#TempPlanflag").prop("checked","checked")
	if(list[46]=="Y") $("#FixTimeflag").prop("checked","checked")
	setJQValue($("#SDate"),list[47]);
	setJQValue($("#EDate"),list[48]);
	setJQValue($("#PlanNo"),list[49]);
	setJQValue($("#CycleUnit"),list[7],"value");	
	setJQValue($("#CycleUnit"),list[sort+3],"text");
	setJQValue($("#MaintType"),list[8],"value");
	setJQValue($("#MaintType"),list[sort+4],"text");
	setJQValue($("#MaintLoc"),list[sort+5],"text");
	setJQValue($("#Service"),list[sort+10],"text");
	setJQValue($("#MaintMode"),list[sort+7],"text");
}

/*
 *Description:计划保存事件
 *params:SourceType：列表类型序号 RowID:当前行RowID index：当前行行号
 *author:李苗苗
*/
function BSave_Clicked() 
{	

	var ReqNum=0;
	jQuery('input.validatebox-invalid').each(function(){ ReqNum++});
	if (ReqNum>0) {
		jQuery.messager.alert("提示", "请检查必填字段！");
		return;
	}
	if(CheckInvalidData()) return;
	if(CheckEquipRangeData()) return;
	if(CheckGridData()) return;
	
	
	var combindata=GetMaintInfoList();
	var EquipRangeval=GetEquipRangeval();
	var EquipRangevalList=GetEquipRangevalList();
	var Rtn = tkMakeServerCall("web.DHCEQMaintPlanNew", "SaveData",combindata,EquipRangeval,EquipRangevalList);
	var Rtn=Rtn.split("^")
	$('#RowID').val(Rtn[2])
	if (Rtn[2]<0) 
	{
		alertShow("更新失败！");
		return;	
	}
		alertShow("更新成功！");
	//****************************	
	var url = 'dhceq.process.maintplan.csp?RowID='+$('#RowID').val()+"&BussType="+getJQValue($("#BussType"))+"&Status=0&SourceType=2";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url


}
/*
 *Description:获取计划信息串
 *author:李苗苗
*/
function GetMaintInfoList()
{
	
	
	var combindata="";
  	combindata=getJQValue($("#RowID")) ; 
	combindata=combindata+"^"+getJQValue($("#Name")) ; 
	combindata=combindata+"^"+getJQValue($("#BussType")) ; 
	combindata=combindata+"^"; 
	combindata=combindata+"^"; 
	combindata=combindata+"^"; 
	combindata=combindata+"^"+getJQValue($("#Content")); 
	combindata=combindata+"^"+getJQValue($("#CycleNum")) ; 
	combindata=combindata+"^"+getJQValue($("#CycleUnitDR")); 
	combindata=combindata+"^"+getJQValue($("#MaintTypeDR")); 
	combindata=combindata+"^"+getJQValue($("#FromDate")) ; 
	combindata=combindata+"^"; //+getJQValue($("#EndDate")) 
	combindata=combindata+"^"+getJQValue($("#PreWarnDaysNum")) ; 
	combindata=combindata+"^"+getJQValue($("#MaintFee")) ; 
	combindata=combindata+"^"+getJQValue($("#MaintLocDR")) ; 
	combindata=combindata+"^"+getJQValue($("#MaintUserDR")) ; 
	combindata=combindata+"^"+getJQValue($("#MaintModeDR")) ; 
	combindata=combindata+"^"; //+getJQValue($("#ContractDR"))
	combindata=combindata+"^"; //+GetCheckValue("MeasureFlag") 
	combindata=combindata+"^"+getJQValue($("#MeasureDeptDR")) ; 
	combindata=combindata+"^"+getJQValue($("#MeasureHandler")) ; 
	combindata=combindata+"^"+getJQValue($("#MeasureTel")) ; 
	combindata=combindata+"^"+getJQValue($("#ServiceDR")) ; 
	combindata=combindata+"^"+getJQValue($("#ServiceHandler")) ; 
	combindata=combindata+"^"+getJQValue($("#ServiceTel")) ; 
	combindata=combindata+"^"+getJQValue($("#Remark")) ; 
	combindata=combindata+"^"+getJQValue($("#Status")) ; 
	combindata=combindata+"^"+getJQValue($("#InvalidFlag")) ; 
	combindata=combindata+"^"+getJQValue($("#Hold1")) ; 
	combindata=combindata+"^"+getJQValue($("#Hold2")) ; 
	combindata=combindata+"^"+getJQValue($("#Hold3")) ; 
	combindata=combindata+"^"+getJQValue($("#Hold4")) ; 
	combindata=combindata+"^"+getJQValue($("#Hold5")) ; 
	combindata=combindata+"^"+getJQValue($("#TotalFee")) ; 
	combindata=combindata+"^"+getJQValue($("#TempPlanflag")) ; 
	combindata=combindata+"^"+getJQValue($("#FixTimeflag")); 
	combindata=combindata+"^"+getJQValue($("#SDate")) ; 
	combindata=combindata+"^"+getJQValue($("#EDate")) ; 
	
	return combindata;
}
/*
 *Description:计划提交事件
 *author:李苗苗
*/
function BSubmit_Clicked()
{
	if ($('#RowID').val()=="") return;
	var Rtn = tkMakeServerCall("web.DHCEQMaintPlanNew", "SubmitData",$('#RowID').val());
	if (Rtn<0) 
	{
		alertShow("更新失败！");
		return;	
	}
		alertShow("更新成功！");
	//****************************	
	var url='dhceq.process.maintplan.csp?RowID='+Rtn+"&QXType="+getJQValue($("#QXType"))+"&BussType="+getJQValue($("#BussType"))+"&MaintTypedr="+getJQValue($("#MaintTypedr"))+"&Status=2&SourceType=2";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
	
}
/*
 *Description:按钮灰化事件
 *author:李苗苗
*/
function SetEnabled()
{
	var Status=$("#Status").val();
	var ReadOnly=$("#ReadOnly").val;
	if (Status=="")
	{
		jQuery("#BSave").linkbutton("enable")
		jQuery("#BSubmit").linkbutton("enable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BDelete").unbind();
		//DisableBElement("BUpdate",true);
		//DisableBElement("BDelete",true);
		//DisableBElement("BSubmit",true);
	}
	else if (Status=="0")
	{
		jQuery("#BSave").linkbutton("enable")
		jQuery("#BSubmit").linkbutton("enable")
		jQuery("#BDelete").linkbutton("enable")
	}
	else if (Status=="2")
	{
		jQuery("#BSave").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").unbind();
		//DisableBElement("BUpdate",true);
		//DisableBElement("BDelete",true);
		//DisableBElement("BSubmit",true);
	}
	else if (ReadOnly=="1")
	{
		jQuery("#BSave").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").unbind();
	}	
	else 
	{
		jQuery("#BSave").linkbutton("enable")
		jQuery("#BSubmit").linkbutton("enable")
		jQuery("#BDelete").linkbutton("enable")
	}
}
/*
 *Description:按钮灰化事件
 *params:vElementID：按钮id vValue：灰化值
 *author:李苗苗
*/
function DisableBElement(vElementID,vValue)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			//按钮灰化处理
			jQuery("#"+vElementID).linkbutton("disable")
			
		}
		else
		{
			//按钮启用
			jQuery("#"+vElementID).linkbutton("enable")
		}
	}
}
/*
 *Description:计划删除事件
 *params:SourceType：列表类型序号 RowID:当前行RowID index：当前行行号
 *author:李苗苗
*/
function BDelete_Clicked() 
{
	
	truthBeTold = window.confirm("是否删除计划单据?");
	if (!truthBeTold) return;
	var RowID=getJQValue($("#RowID"));
	var EquipRangeDR=getJQValue($("#EquipRangeDR"));
	//var DeleteEquipRangevalList=EquipRangedelvalList();
  	if (RowID=="") return;
	var Rtn = tkMakeServerCall("web.DHCEQMaintPlanNew", "DeleteData",RowID,EquipRangeDR);
	if (Rtn<0) 
	{
		alertShow("更新失败！");
		return;	
	}
		alertShow("更新成功！");
	//****************************
	var url='dhceq.process.maintplan.csp?RowID='+"&QXType="+getJQValue($("#QXType"))+"&BussType="+getJQValue($("#BussType"))+"&MaintTypedr="+getJQValue($("#MaintTypedr"))+"&Status=&SourceType=2";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}	
	window.location.href= url;
}
/*
 *Description:计划删除事件
 *params:SourceType：列表类型序号 RowID:当前行RowID index：当前行行号
 *author:李苗苗
*/
function CheckInvalidData()
{
	if (IsValidateNumber(getJQValue($("#PreWarnDaysNum")),0,0,0,1)==0)
	{
		alertShow("预警天数异常,请修正.");
		return true;
	}
	if ((IsValidateNumber(getJQValue($("#CycleNum")),0,0,0,1)==0)&&($("#TempPlanflag").is(':checked')==false))
	{
		alertShow("保养周期数据异常,请修正.");
		return true;
	}
	return false;
}
/*
 *Description:设备范围限定数据科室列表定义
 *params:EquipRangeListID：设备范围明细ID Type:范围类型 title：列表标题
 *author:李苗苗
*/
function EquipRangeLocDataGrid(EquipRangeListID,Type,title)
{
		$('#'+EquipRangeListID).datagrid({   
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQEquipRange",
	        QueryName:"GetEquipRangeList",
	        Arg1:$('#EquipRangeDR').val(),
	        Arg2:Type,
	        Arg3:'',
	        ArgCnt:3
	    },
	    title:title,
	    border:'true',
		fit:true,
	    fitColumns:false,
		//width:'50px',
	    singleSelect:true,
	    toolbar:[{   
	    			iconCls: 'icon-add',
	                text:'新增',          
	                handler: function(){   
	                     AddgridData(Type);
	                }   
	                 }] , 
   
	    columns:[[
	    	{field:'rowid',title:'Rowid',hidden:true},    
	        {field:'equiprangedr',title:'equiprangedr',align:'center',hidden:true},
	        {field:'typedr',title:'typedr',align:'center',hidden:true}, 
	        {field:'valuedr',title:'valuedr',align:'center',hidden:true},       
	        {field:'value',title:'名称',width:90,align:'center'}, 
	        {field:'code',title:'代码',width:90,align:'center'}, 
	        {field:'accessflag',title:'访问标识',align:'center',hidden:true}, 
	        {field:'TDeleteList',title:'删除',width:50,align:'center',
	        formatter:function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow(&quot;'+4+','+row.rowid+','+index+'&quot;)">删除</a> '; return MOLID; 
	 		}},	        
	        
	    ]]
		});

	
}
/*
 *Description:设备范围限定数据设备项列表定义
 *params:EquipRangeListID：设备范围明细ID Type:范围类型 title：列表标题
 *author:李苗苗
*/
function EquipRangeMastitemDataGrid(EquipRangeListID,Type,title)
{
		$('#'+EquipRangeListID).datagrid({   
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQEquipRange",
	        QueryName:"GetEquipRangeList",
	        Arg1:$('#EquipRangeDR').val(),
	        Arg2:Type,
	        Arg3:'',
	        ArgCnt:3
	    },
	    title:title,
	    border:'true',
		fit:true,
	    fitColumns:false,
		//width:'50px',
	    singleSelect:true,
	    toolbar:[{   
	    			iconCls: 'icon-add',
	                text:'新增',          
	                handler: function(){   
	                     AddgridData(Type);
	                }   
	                 }] , 
   
	    columns:[[
	    	{field:'rowid',title:'Rowid',hidden:true},    
	        {field:'equiprangedr',title:'equiprangedr',align:'center',hidden:true},
	        {field:'typedr',title:'typedr',align:'center',hidden:true}, 
	        {field:'valuedr',title:'valuedr',align:'center',hidden:true},       
	        {field:'value',title:'名称',width:90,align:'center'}, 
	        {field:'equiptypedr',title:'equiptypedr',align:'center',hidden:true},       
	        {field:'equiptypedesc',title:'类组',width:90,align:'center'}, 
	        {field:'accessflag',title:'访问标识',align:'center',hidden:true}, 
	        {field:'TDeleteList',title:'删除',width:50,align:'center',
	        formatter:function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow(&quot;'+6+','+row.rowid+','+index+'&quot;)">删除</a> '; return MOLID; 
	 		}},	        
	        
	    ]]
		});

	
}
/*
 *Description:设备范围限定数据设备列表定义
 *params:EquipRangeListID：设备范围明细ID Type:范围类型 title：列表标题
 *author:李苗苗
*/
function EquipRangeEquipDataGrid(EquipRangeListID,Type,title)
{
		$('#'+EquipRangeListID).datagrid({   
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQEquipRange",
	        QueryName:"GetEquipRangeList",
	        Arg1:$('#EquipRangeDR').val(),
	        Arg2:Type,
	        Arg3:'',
	        ArgCnt:3
	    },
	    title:title,
	    border:'true',
		fit:true,
	    fitColumns:false,
		//width:'50px',
	    singleSelect:true,
	    toolbar:[{   
	    			iconCls: 'icon-add',
	                text:'新增',          
	                handler: function(){   
	                     AddgridData(Type);
	                }   
	                 }] , 
   
	    columns:[[
	    	{field:'rowid',title:'Rowid',hidden:true},    
	        {field:'equiprangedr',title:'equiprangedr',align:'center',hidden:true},
	        {field:'typedr',title:'typedr',align:'center',hidden:true}, 
	        {field:'valuedr',title:'valuedr',align:'center',hidden:true},       
	        {field:'value',title:'名称',width:100,align:'center'}, 
	        {field:'no',title:'设备编号',width:100,align:'center'}, 
	        {field:'leavefactoryno',title:'sv码',width:70,align:'center'}, 
	        {field:'modeldr',title:'modeldr',align:'center',hidden:true}, 
	        {field:'model',title:'机型',width:70,align:'center'}, 
	        {field:'uselocdr',title:'uselocdr',align:'center',hidden:true}, 
	        {field:'useloc',title:'科室',width:90,align:'center'}, 
	        {field:'equiptypedr',title:'equiptypedr',align:'center',hidden:true},       
	        {field:'equiptypedesc',title:'类组',width:100,align:'center'}, 
	        {field:'accessflag',title:'访问标识',align:'center',hidden:true}, 
	        {field:'TDeleteList',title:'删除',width:50,align:'center',
	        formatter:function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow(&quot;'+5+','+row.rowid+','+index+'&quot;)">删除</a> '; return MOLID; 
	 		}},	        
	        
	    ]]
		});

	
}

/*
 *Description:设备范围列表串
 *author:李苗苗
*/
function GetEquipRangeval()
{
	var combindata="";
  	combindata=getJQValue($("#EquipRangeDR")) ; 
	combindata=combindata+"^"+getJQValue($("#RangeDesc")) ; 
	combindata=combindata+"^"+getJQValue($("#SourceType")) ; 
	combindata=combindata+"^"+getJQValue($("#RowID")) ; 
	if($("#EquipType").combogrid("getValues")!="") combindata=combindata+"^Y"
	else combindata=combindata+"^N"
	if($("#StatCat").combogrid("getValues")!="") combindata=combindata+"^Y"
	else combindata=combindata+"^N"
	combindata=combindata+"^N";
	combindata=combindata+"^"+getJQValue($("#LocFlag")) ; 
	combindata=combindata+"^"+getJQValue($("#EquipFlag")) ;
	combindata=combindata+"^"+getJQValue($("#ItemFlag")) ;
	return combindata;
}

/*
 *Description:设备范围列表明细串
 *author:李苗苗
*/
function GetEquipRangevalList()
{
	var combindata="";
	var flag=0  //判断是否存在第一串明细数据
	if($("#EquipType").combogrid("getValues")!="") 
	{
		var flag=1
		var EquipTypeStr=$("#EquipType").combogrid("getValues")
		combindata=combindata+getJQValue($("#EquipRangeEquipTypeDR"));
		combindata=combindata+"^1";
		combindata=combindata+"^"+EquipTypeStr;
		combindata=combindata+"^Y";
	}
	if($("#StatCat").combogrid("getValues")!="") 
	{		
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var StatCatStr=$("#StatCat").combogrid("getValues")
		combindata=combindata+getJQValue($("#EquipRangeStatCatDR"));
		combindata=combindata+"^2";
		combindata=combindata+"^"+StatCatStr;
		combindata=combindata+"^Y";
	}
	if(getJQValue($("#LocFlag"))=="Y") 
	{
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var LocStr=GetDataGridIDs("DHCEQLoc")
		combindata=combindata+LocStr;
		
	}
	if(getJQValue($("#EquipFlag"))=="Y") 
	{
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var EquipStr=GetDataGridIDs("DHCEQEquip")
		combindata=combindata+EquipStr;
		
	}
	if(getJQValue($("#ItemFlag"))=="Y") 
	{
		if(flag==1) combindata=combindata+"&";
		var flag=1
		var MastitemStr=GetDataGridIDs("DHCEQMastitem")
		combindata=combindata+MastitemStr;
		
	}
	return combindata;
	
}
/*
 *Description:设备数据列表串
 *params:DataGridID：设备数据列表ID
 *author:李苗苗
*/
function GetDataGridIDs(DataGridID)
{
	var rows = $("#"+DataGridID).datagrid("getRows"); //这段代码是获取当前页的所有行。
	var vallist=""
		$.each(rows, function(rowIndex, rowData){
						
			if (vallist=="")
			{ 
				vallist=rowData.rowid+"^"+rowData.typedr+"^"+rowData.valuedr+"^"+rowData.accessflag;
			}
			 else 
			{
			 vallist=vallist+"&"+rowData.rowid+"^"+rowData.typedr+"^"+rowData.valuedr+"^"+rowData.accessflag; 
			}
		}); 
	return vallist;
}

/*
 *Description:设备范围表单数据填充
 *author:李苗苗
*/
function FillEquipRangeData()
{
	var RowID=getJQValue($("#RowID"));
  	if ((RowID=="")||(RowID==0)) return;
	var list = tkMakeServerCall("web.DHCEQEquipRange","GetOneEquipRange",RowID);
	list=list.replace(/\ +/g,"")	//去掉空格
	list=list.replace(/[\r\n]/g,"")	//去掉回车换行
	list=list.split("^");
	setJQValue($("#EquipRangeDR"),list[0]);
	setJQValue($("#RangeDesc"),list[1]);
	setJQValue($("#SourceType"),list[2]);
	if(list[7]=="Y") $("#LocFlag").prop("checked","checked")
	if(list[8]=="Y") $("#EquipFlag").prop("checked","checked")
	if(list[9]=="Y") $("#ItemFlag").prop("checked","checked")
	
	$("#EquipType").combogrid('setValues',list[17])
	$("#EquipType").combogrid('setText',list[18])
	setJQValue($("#EquipRangeEquipTypeDR"),list[19]);
	$("#StatCat").combogrid('setValues',list[20])
	$("#StatCat").combogrid('setText',list[21])
	setJQValue($("#EquipRangeStatCatDR"),list[22]);
	
}
/*
 *Description:检测勾选框勾选，对应列表是否存在数据
 *author:李苗苗
*/
function CheckGridData()
{
	var loclen=$("#DHCEQLoc").datagrid("getRows").length
	var mastitemlen=$("#DHCEQMastitem").datagrid("getRows").length
	var equiplen=$("#DHCEQEquip").datagrid("getRows").length
	if((getJQValue($("#LocFlag"))=="Y")&&(loclen==0)) 
	{
		alertShow("科室列表无数据！");
		return true;		
	}
	if((getJQValue($("#EquipFlag"))=="Y")&&(equiplen==0)) 
	{
		alertShow("设备列表无数据！");
		return true;		
	}
	if((getJQValue($("#ItemFlag"))=="Y")&&(mastitemlen==0)) 
	{
		alertShow("设备项列表无数据！");
		return true;		
	}
		return false;		

}
function EquipList_Clicked()
{
	url="dhceqmaintequiplist.csp?"+"&SourceType="+type;	
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
    window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	
}
function CheckEquipRangeData()
{
	if((getJQValue($("#LocFlag"))=="N")&&(getJQValue($("#EquipFlag"))=="N")&&(getJQValue($("#ItemFlag"))=="N")&&($("#EquipType").combogrid("getValues")=="")&&($("#StatCat").combogrid("getValues")==""))
	{
		alertShow("无设备范围定义！")
		return true;
	}
	return false;
	
}

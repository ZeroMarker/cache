//var EquipRangeMastitemcolumns=GetCurColumnsInfo('EquipRangeMastitem','','',''); 
//�������
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
//��ʼ����ѯͷ���
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
			{field:'desc',title:'����',width:170,align:'center',width:350}
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
			{field:'desc',title:'����',width:170,align:'center',width:350}
		]],
		onLoadSuccess:function(data) {
				
				},
		onSelect: function(rowIndex, rowData) {
				}
		});
	
}
/*
 *Description:�б����ݼ���
 *author:������
*/
function initDataGrid()
{
	EquipRangeLocDataGrid("DHCEQLoc","4","�����б�");
	EquipRangeMastitemDataGrid("DHCEQMastitem","6","�豸���б�");
	EquipRangeEquipDataGrid("DHCEQEquip","5","�豸�б�");
}
/*
 *Description:�����ӵ����б���ӽ���
 *params:SourceType���б��������
 *author:������
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
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
    window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	
}
/*
 *Description:��ѡ������б��Ƿ�����
 *author:������
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
 *Description:�б��������
 *params:SourceType���б�������� copyrows:�б���������
 *author:������
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
 *Description:�б��������
 *params:SourceType���б�������� copyrows:�б���������
 *author:������
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
 *Description:�б��������
 *params:SourceType���б�������� copyrows:�б���������
 *author:������
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
 *Description:�б��������
 *params:SourceType���б�������� RowID:��ǰ��RowID index����ǰ���к�
 *author:������
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
			alertShow("ɾ���ɹ�!")
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
			$.messager.alert('ɾ��ʧ�ܣ�',data, 'warning')
			return;
		}
		
	}
		
	
}
/*
 *Description:�ƻ�����¼�
 *author:������
*/
function FillData()
{
	
	var RowID=getJQValue($("#RowID"));
  	if ((RowID=="")||(RowID==0)) return;
  	
	var list = tkMakeServerCall("web.DHCEQMaintPlanNew", "GetOneMaintPlan",RowID);
	list=list.replace(/\ +/g,"")	//ȥ���ո�
	list=list.replace(/[\r\n]/g,"")	//ȥ���س�����
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
 *Description:�ƻ������¼�
 *params:SourceType���б�������� RowID:��ǰ��RowID index����ǰ���к�
 *author:������
*/
function BSave_Clicked() 
{	

	var ReqNum=0;
	jQuery('input.validatebox-invalid').each(function(){ ReqNum++});
	if (ReqNum>0) {
		jQuery.messager.alert("��ʾ", "��������ֶΣ�");
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
		alertShow("����ʧ�ܣ�");
		return;	
	}
		alertShow("���³ɹ���");
	//****************************	
	var url = 'dhceq.process.maintplan.csp?RowID='+$('#RowID').val()+"&BussType="+getJQValue($("#BussType"))+"&Status=0&SourceType=2";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url


}
/*
 *Description:��ȡ�ƻ���Ϣ��
 *author:������
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
 *Description:�ƻ��ύ�¼�
 *author:������
*/
function BSubmit_Clicked()
{
	if ($('#RowID').val()=="") return;
	var Rtn = tkMakeServerCall("web.DHCEQMaintPlanNew", "SubmitData",$('#RowID').val());
	if (Rtn<0) 
	{
		alertShow("����ʧ�ܣ�");
		return;	
	}
		alertShow("���³ɹ���");
	//****************************	
	var url='dhceq.process.maintplan.csp?RowID='+Rtn+"&QXType="+getJQValue($("#QXType"))+"&BussType="+getJQValue($("#BussType"))+"&MaintTypedr="+getJQValue($("#MaintTypedr"))+"&Status=2&SourceType=2";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
	
}
/*
 *Description:��ť�һ��¼�
 *author:������
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
 *Description:��ť�һ��¼�
 *params:vElementID����ťid vValue���һ�ֵ
 *author:������
*/
function DisableBElement(vElementID,vValue)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			//��ť�һ�����
			jQuery("#"+vElementID).linkbutton("disable")
			
		}
		else
		{
			//��ť����
			jQuery("#"+vElementID).linkbutton("enable")
		}
	}
}
/*
 *Description:�ƻ�ɾ���¼�
 *params:SourceType���б�������� RowID:��ǰ��RowID index����ǰ���к�
 *author:������
*/
function BDelete_Clicked() 
{
	
	truthBeTold = window.confirm("�Ƿ�ɾ���ƻ�����?");
	if (!truthBeTold) return;
	var RowID=getJQValue($("#RowID"));
	var EquipRangeDR=getJQValue($("#EquipRangeDR"));
	//var DeleteEquipRangevalList=EquipRangedelvalList();
  	if (RowID=="") return;
	var Rtn = tkMakeServerCall("web.DHCEQMaintPlanNew", "DeleteData",RowID,EquipRangeDR);
	if (Rtn<0) 
	{
		alertShow("����ʧ�ܣ�");
		return;	
	}
		alertShow("���³ɹ���");
	//****************************
	var url='dhceq.process.maintplan.csp?RowID='+"&QXType="+getJQValue($("#QXType"))+"&BussType="+getJQValue($("#BussType"))+"&MaintTypedr="+getJQValue($("#MaintTypedr"))+"&Status=&SourceType=2";
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}	
	window.location.href= url;
}
/*
 *Description:�ƻ�ɾ���¼�
 *params:SourceType���б�������� RowID:��ǰ��RowID index����ǰ���к�
 *author:������
*/
function CheckInvalidData()
{
	if (IsValidateNumber(getJQValue($("#PreWarnDaysNum")),0,0,0,1)==0)
	{
		alertShow("Ԥ�������쳣,������.");
		return true;
	}
	if ((IsValidateNumber(getJQValue($("#CycleNum")),0,0,0,1)==0)&&($("#TempPlanflag").is(':checked')==false))
	{
		alertShow("�������������쳣,������.");
		return true;
	}
	return false;
}
/*
 *Description:�豸��Χ�޶����ݿ����б���
 *params:EquipRangeListID���豸��Χ��ϸID Type:��Χ���� title���б����
 *author:������
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
	                text:'����',          
	                handler: function(){   
	                     AddgridData(Type);
	                }   
	                 }] , 
   
	    columns:[[
	    	{field:'rowid',title:'Rowid',hidden:true},    
	        {field:'equiprangedr',title:'equiprangedr',align:'center',hidden:true},
	        {field:'typedr',title:'typedr',align:'center',hidden:true}, 
	        {field:'valuedr',title:'valuedr',align:'center',hidden:true},       
	        {field:'value',title:'����',width:90,align:'center'}, 
	        {field:'code',title:'����',width:90,align:'center'}, 
	        {field:'accessflag',title:'���ʱ�ʶ',align:'center',hidden:true}, 
	        {field:'TDeleteList',title:'ɾ��',width:50,align:'center',
	        formatter:function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow(&quot;'+4+','+row.rowid+','+index+'&quot;)">ɾ��</a> '; return MOLID; 
	 		}},	        
	        
	    ]]
		});

	
}
/*
 *Description:�豸��Χ�޶������豸���б���
 *params:EquipRangeListID���豸��Χ��ϸID Type:��Χ���� title���б����
 *author:������
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
	                text:'����',          
	                handler: function(){   
	                     AddgridData(Type);
	                }   
	                 }] , 
   
	    columns:[[
	    	{field:'rowid',title:'Rowid',hidden:true},    
	        {field:'equiprangedr',title:'equiprangedr',align:'center',hidden:true},
	        {field:'typedr',title:'typedr',align:'center',hidden:true}, 
	        {field:'valuedr',title:'valuedr',align:'center',hidden:true},       
	        {field:'value',title:'����',width:90,align:'center'}, 
	        {field:'equiptypedr',title:'equiptypedr',align:'center',hidden:true},       
	        {field:'equiptypedesc',title:'����',width:90,align:'center'}, 
	        {field:'accessflag',title:'���ʱ�ʶ',align:'center',hidden:true}, 
	        {field:'TDeleteList',title:'ɾ��',width:50,align:'center',
	        formatter:function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow(&quot;'+6+','+row.rowid+','+index+'&quot;)">ɾ��</a> '; return MOLID; 
	 		}},	        
	        
	    ]]
		});

	
}
/*
 *Description:�豸��Χ�޶������豸�б���
 *params:EquipRangeListID���豸��Χ��ϸID Type:��Χ���� title���б����
 *author:������
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
	                text:'����',          
	                handler: function(){   
	                     AddgridData(Type);
	                }   
	                 }] , 
   
	    columns:[[
	    	{field:'rowid',title:'Rowid',hidden:true},    
	        {field:'equiprangedr',title:'equiprangedr',align:'center',hidden:true},
	        {field:'typedr',title:'typedr',align:'center',hidden:true}, 
	        {field:'valuedr',title:'valuedr',align:'center',hidden:true},       
	        {field:'value',title:'����',width:100,align:'center'}, 
	        {field:'no',title:'�豸���',width:100,align:'center'}, 
	        {field:'leavefactoryno',title:'sv��',width:70,align:'center'}, 
	        {field:'modeldr',title:'modeldr',align:'center',hidden:true}, 
	        {field:'model',title:'����',width:70,align:'center'}, 
	        {field:'uselocdr',title:'uselocdr',align:'center',hidden:true}, 
	        {field:'useloc',title:'����',width:90,align:'center'}, 
	        {field:'equiptypedr',title:'equiptypedr',align:'center',hidden:true},       
	        {field:'equiptypedesc',title:'����',width:100,align:'center'}, 
	        {field:'accessflag',title:'���ʱ�ʶ',align:'center',hidden:true}, 
	        {field:'TDeleteList',title:'ɾ��',width:50,align:'center',
	        formatter:function(value,row,index){
			var MOLID = '<a href="#"  onclick="deleterow(&quot;'+5+','+row.rowid+','+index+'&quot;)">ɾ��</a> '; return MOLID; 
	 		}},	        
	        
	    ]]
		});

	
}

/*
 *Description:�豸��Χ�б�
 *author:������
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
 *Description:�豸��Χ�б���ϸ��
 *author:������
*/
function GetEquipRangevalList()
{
	var combindata="";
	var flag=0  //�ж��Ƿ���ڵ�һ����ϸ����
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
 *Description:�豸�����б�
 *params:DataGridID���豸�����б�ID
 *author:������
*/
function GetDataGridIDs(DataGridID)
{
	var rows = $("#"+DataGridID).datagrid("getRows"); //��δ����ǻ�ȡ��ǰҳ�������С�
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
 *Description:�豸��Χ���������
 *author:������
*/
function FillEquipRangeData()
{
	var RowID=getJQValue($("#RowID"));
  	if ((RowID=="")||(RowID==0)) return;
	var list = tkMakeServerCall("web.DHCEQEquipRange","GetOneEquipRange",RowID);
	list=list.replace(/\ +/g,"")	//ȥ���ո�
	list=list.replace(/[\r\n]/g,"")	//ȥ���س�����
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
 *Description:��⹴ѡ��ѡ����Ӧ�б��Ƿ��������
 *author:������
*/
function CheckGridData()
{
	var loclen=$("#DHCEQLoc").datagrid("getRows").length
	var mastitemlen=$("#DHCEQMastitem").datagrid("getRows").length
	var equiplen=$("#DHCEQEquip").datagrid("getRows").length
	if((getJQValue($("#LocFlag"))=="Y")&&(loclen==0)) 
	{
		alertShow("�����б������ݣ�");
		return true;		
	}
	if((getJQValue($("#EquipFlag"))=="Y")&&(equiplen==0)) 
	{
		alertShow("�豸�б������ݣ�");
		return true;		
	}
	if((getJQValue($("#ItemFlag"))=="Y")&&(mastitemlen==0)) 
	{
		alertShow("�豸���б������ݣ�");
		return true;		
	}
		return false;		

}
function EquipList_Clicked()
{
	url="dhceqmaintequiplist.csp?"+"&SourceType="+type;	
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
    window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	
}
function CheckEquipRangeData()
{
	if((getJQValue($("#LocFlag"))=="N")&&(getJQValue($("#EquipFlag"))=="N")&&(getJQValue($("#ItemFlag"))=="N")&&($("#EquipType").combogrid("getValues")=="")&&($("#StatCat").combogrid("getValues")==""))
	{
		alertShow("���豸��Χ���壡")
		return true;
	}
	return false;
	
}

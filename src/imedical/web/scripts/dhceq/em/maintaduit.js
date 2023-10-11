var columns=getCurColumnsInfo('DHCEQ.G.Maint.MaintList','','','');  
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	initUserInfo();
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	jQuery("#BExecute").on("click", BExecute_Clicked);

	$HUI.datagrid("#tDHCEQMaint",{   
	   	url:$URL, 
		idField:'TRowID', //����
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSMaint",
	        QueryName:"GetMaint",
	        BussType:getElementValue("BussType"),
	        EquipDR:getElementValue("EquipDR"),
	        MaintLocDR:getElementValue("MaintLocDR"),
	        MaintUserDR:getElementValue("MaintUserDR"),
	        MaintTypeDR:getElementValue("MaintTypeDR"),
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
	        Status:1,
	        QXType:getElementValue("QXType"),
	        CurUser:'',
	        TypeCode:'',
		},
		//fitColumns:true,
		pagination:true,
    	columns:columns, 
	});
	//End By QW20181225 �����:786608
	var TDetail=$("#tDHCEQMaint").datagrid('getColumnOption','TDetail');
	TDetail.formatter=	function(value,row,index){
			return mainOperation(value,row,index)	
		}	    
	var TMaintPlan=$("#tDHCEQMaint").datagrid('getColumnOption','TMaintPlan');
	TMaintPlan.formatter=	function(value,row,index){
			return mainplanOperation(value,row,index)	
		}
		
	var TMaintDate=$('#tDHCEQMaint').datagrid('getColumnOption','TMaintDate');
	var TMaintLoc=$('#tDHCEQMaint').datagrid('getColumnOption','TMaintLoc');
	var TMaintMode=$('#tDHCEQMaint').datagrid('getColumnOption','TMaintMode');
	var TMaintType=$('#tDHCEQMaint').datagrid('getColumnOption','TMaintType');
	var TMaintUser=$('#tDHCEQMaint').datagrid('getColumnOption','TMaintUser');
	
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		TMaintDate.title='��������'
		TMaintLoc.title='��������'
		TMaintMode.title='������ʽ'
		TMaintType.title='��������'
		TMaintUser.title='������'
	}
	else if (getElementValue("BussType")==1)
	{
		TMaintDate.title="��������"
		TMaintLoc.title='��������'
		TMaintMode.title='������ʽ'
		TMaintType.title='��������'
		TMaintUser.title='������'
	}	
	else
	{
		TMaintDate.title='Ѳ������'
		TMaintLoc.title='Ѳ�����'
		TMaintMode.title='Ѳ�췽ʽ'
		TMaintType.title='Ѳ������'
		TMaintUser.title='Ѳ����'
	}
	$('#tDHCEQMaint').datagrid();
	
	jQuery("#BColSet").linkbutton({iconCls: 'icon-w-config'});
	jQuery("#BColSet").on("click", BColSet_Clicked);
	jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-w-export'});
	jQuery("#BSaveExcel").on("click", BSaveExcel_Clicked);
}
function GetLnk()
{
	var lnk="";
	lnk=lnk+"^BussType="+getElementValue("BussType");
	lnk=lnk+"^EquipDR="+getElementValue("EquipDR");
	lnk=lnk+"^ManageLocDR="+getElementValue("ManageLocDR");
	lnk=lnk+"^MaintUserDR="+getElementValue("MaintUserDR");
	lnk=lnk+"^MaintTypeDR="+getElementValue("MaintTypeDR");
	lnk=lnk+"^StartDate="+getElementValue("StartDate");
	lnk=lnk+"^EndDate="+getElementValue("EndDate");
	lnk=lnk+"^Status="+getElementValue("Status");
	lnk=lnk+"^QXType="+getElementValue("QXType");
	lnk=lnk+"^QXType=";
	lnk=lnk+"^CurUser=";
	lnk=lnk+"^TypeCode=";
	return lnk
}
//Modified By QW20181225 �����:786608
function BFind_Clicked()
{
		$HUI.datagrid("#tDHCEQMaint",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSMaint",
	        QueryName:"GetMaint",
	        BussType:getElementValue("BussType"),
	        EquipDR:getElementValue("EquipDR"),
	        MaintLocDR:getElementValue("MaintLocDR"),	//  modify by yh 2019-10-28 YH00018
	        MaintUserDR:getElementValue("MaintUserDR"),
	        MaintTypeDR:getElementValue("MaintTypeDR"),//modified by csj 20181211
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
	        Status:1,
	        QXType:getElementValue("QXType"),
	        CurUser:'',
	        TypeCode:'',
        MaintIDs:getElementValue("MaintIDs")	//CZF0134 2021-02-23
		    },
	});
}
///modify by lmm 2019-02-16 ���ӱ��⼰�����ߴ�
function mainplanOperation(value,row,index)
{
	var btn=""
	//modify by lmm 2020-05-26 1336941
		var para="&ReadOnly=1&BussType="+getElementValue("BussType")+"&SourceType=2&QXType=1&MaintLocDR="+row.TMaintLocDR+"&RowID="+row.TMaintPlanDR+"&ReadOnly=1"+"&EquipRangeDR="+row.TEquipRangeID;	//CZF0134 2021-02-23
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterageplan.csp?";
		var title="�����ƻ�"
	}
	else if (getElementValue("BussType")==1)
	{
		// MZY0082	1965403		2021-07-14	�������Ӵ���
		var url="dhceq.em.maintplan.csp?";
		//var title="�����ƻ�"
		var title="Ԥ����ά���ƻ�";
	}	
	else
	{
		var url="dhceq.em.inspectplan.csp?";
		var title="Ѳ��ƻ�"
	}	
		
		url=url+para;
		var icon="icon-w-paper"	 //modify by lmm 2018-11-14
		var type=""	 //modify by lmm 2018-11-14
		//modified by csj 20181128 �����:762692
		//modify by lmm 2020-0202-06-05 UI
		btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#">'+row.TMaintPlan+'</A>';
	return btn;
	
}
//Add By QW20181225 �����:786608
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	//add hly 2019-10-14
	if(vElementID=="MaintType")
	{
		setElement("MaintType",item.TDesc);
	}
}
//Add By QW20181225 �����:786608
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function mainOperation(value,row,index)
{
	var btn=""
	//modify by lmm 2020-08-10
		var para="&BussType="+getElementValue("BussType")+"&EquipDR="+row.TEquipDR+"&RowID="+row.TRowID+"&CollectFlag="+getElementValue("CollectFlag");
		if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
		{
			var url="dhceq.em.meterage.csp?";
			var title="������¼"
		}
		else if (getElementValue("BussType")==1)
		{
			// MZY0076	2021-05-25
			//var url="dhceq.em.maint.csp?";
			//var title="������¼"
			var url="dhceq.em.preventivemaint.csp?";
			var title="Ԥ����ά����¼";
		}	
		else
		{
			var url="dhceq.em.inspect.csp?";
			var title="Ѳ���¼"
		}	
		url=url+para;	
		var icon="icon-w-paper"
		var type=""
		btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>';
	return btn;
}

///add by czf ������ʷά����¼
function maintHistoryList(index)
{
	var curRowObj=$('#tDHCEQMaint').datagrid('getRows')[index];
	var MPType=getElementValue("BussType");
	var MaintType=getElementValue("MaintTypeDR");
	var EquipDR=curRowObj.TEquipDR;
	$.cm({
		ClassName:"web.DHCEQ.EM.BUSMaint",
		QueryName:"GetMaint",
		BussType:MPType,
		EquipDR:EquipDR,
		MaintTypeDR:MaintType
	},function(jsonData){
		if(jsonData.rows.length<1)
		{
			alertShow("û����ʷά����¼");
			return;
		}
		else
		{
			var url="dhceq.em.mainthistorylist.csp?&MPType="+MPType+"&MaintType="+MaintType+"&EquipDR="+EquipDR;
			//modify by lmm 2020-06-03
			showWindow(url,"��ʷά����¼","","16row","icon-w-paper","modal","","","small") //modify by lmm 2020-06-05 UI
		}
	});
}
function BExecute_Clicked()
{
	var checkedItems = $('#tDHCEQMaint').datagrid('getChecked');
	var selectItems = [];
	var str=""
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	if(selectItems=="")
	{
		messageShow('popover','error','��ʾ',"δѡ������¼��")
		return false;
	}
	for(i=0;i<selectItems.length;i++)//��ʼѭ��
	{
		if (str=="")
		{
			str=selectItems[i];//ѭ����ֵ	
		}
		else
		{
			str=str+","+selectItems[i]
		}
	}
	var result=tkMakeServerCall("web.DHCEQ.EM.BUSMaint","BatckExecute",str,curUserID);
	if(result!=0)
	{
		messageShow('alert','error','��ʾ',"ȷ��ʧ��!"+result)
	}
	else
	{
		jQuery('#tDHCEQMaint').datagrid('reload');
	}
}
function BColSet_Clicked()
{
	var para="&TableName=Maint&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)
}
// MZY0074	1839435		2021-04-30	����Jobȡֵ
function BSaveExcel_Clicked()
{
	var rows = $("#tDHCEQMaint").datagrid('getRows');
	if (rows.length>0)
	{
    	var vData=GetLnk()
		PrintDHCEQEquipNew("Maint",1,rows[0].TJob,vData,"",100);
	}
}
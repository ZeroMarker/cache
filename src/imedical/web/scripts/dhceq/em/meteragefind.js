var columns=getCurColumnsInfo('DHCEQ.G.Maint.MaintList','','','');  

$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	//Modified By QW20181225 �����:786608
	$HUI.datagrid("#maintfinddatagrid",{   
	   	url:$URL, 
		idField:'TRowID', //����   //add by lmm 2018-10-23
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
	        MaintLocDR:getElementValue("ManageLocDR"),
	        MaintUserDR:getElementValue("MaintUserDR"),
	        MaintTypeDR:getElementValue("MaintTypeDR"),
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
	        Status:getElementValue("Status"),
	        QXType:getElementValue("QXType"),
	        CurUser:'',
	        TypeCode:'',
		},
		//fitColumns:true,
		pagination:true,
    	columns:columns, 
	});
	//End By QW20181225 �����:786608
	var TDetail=$("#maintfinddatagrid").datagrid('getColumnOption','TDetail');
	TDetail.formatter=	function(value,row,index){
			return mainOperation(value,row,index)	
		}	    
	var TMaintPlan=$("#maintfinddatagrid").datagrid('getColumnOption','TMaintPlan');
	TMaintPlan.formatter=	function(value,row,index){
			return mainplanOperation(value,row,index)	
		}
		
	//add by lmm 2018-11-14 begin 606420
	if (jQuery("#Status").prop("type")!="hidden")
	{
		var MapType = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data: [{
			id: '0',
			text: '����'
		},{
			id: '1',
			text: '�ύ'
		},{
			id: '2',
			text: '���'
		}],
		});
	}
		
	//add by lmm 2018-11-14 end 606420	
	//add by lmm 2019-10-22 begin
	var TMaintDate=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintDate');
	var TMaintLoc=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintLoc');
	var TMaintMode=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintMode');
	var TMaintType=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintType');
	var TMaintUser=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintUser');
	
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
	$('#maintfinddatagrid').datagrid();
	
	//add by lmm 2019-10-22 end	
	//add by lmm 2020-04-29 begin
	jQuery("#BColSet").linkbutton({iconCls: 'icon-w-config'});
	jQuery("#BColSet").on("click", BColSet_Clicked);
	jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-w-export'});
	jQuery("#BSaveExcel").on("click", BSaveExcel_Clicked);
			    
}
//add by lmm 2020-04-29
function BColSet_Clicked()
{
	var para="&TableName=Maint&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)
}
//add by lmm 2020-04-29
function BSaveExcel_Clicked()
{
	var vData=GetLnk()
	PrintDHCEQEquipNew("Maint",1,getElementValue("Job"),vData,"",100); 
	return
	
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
function BAdd_Clicked()
{
	//modify by lmm 2018-11-14 begin 748324
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR"); //modified by csj 20181211
		var title="������¼"
	}
	else if (getElementValue("BussType")==1)
	{
		var url="dhceq.em.maint.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR"); //modified by csj 20181211
		var title="������¼"
	}	
	else
	{
		var url="dhceq.em.inspect.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR"); //modified by csj 20181211
		var title="Ѳ���¼"
	}
	//modify by lmm 2020-05-09 1311841
	var width=""
	var height="10row"   //MODIFY BY LMM 2020-06-17 UI
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","middle");   //modify by lmm 2020-06-05 UI
	//modify by lmm 2018-11-14 end 748324
}
//Modified By QW20181225 �����:786608
function BFind_Clicked()
{
		$HUI.datagrid("#maintfinddatagrid",{   
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
	        Status:getElementValue("Status"),
	        QXType:getElementValue("QXType"),
	        CurUser:'',
	        TypeCode:'',
		    },
	});
	
}
///modify by lmm 2019-02-16 ���ӱ��⼰�����ߴ�
function mainplanOperation(value,row,index)
{
	var btn=""
	//modify by lmm 2020-05-26 1336941
		var para="&ReadOnly=1&BussType="+getElementValue("BussType")+"&SourceType=2&QXType=1&MaintLocDR="+row.TMaintLocDR+"&RowID="+row.TMaintPlanDR+"&ReadOnly=1";
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterageplan.csp?";
		var title="�����ƻ�"
	}
	else if (getElementValue("BussType")==1)
	{
		var url="dhceq.em.maintplan.csp?";
		var title="�����ƻ�"
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
		var para="&BussType="+getElementValue("BussType")+"&EquipDR="+row.TEquipDR+"&RowID="+row.TRowID;
		if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
		{
			var url="dhceq.em.meterage.csp?";
			var title="������¼"
		}
		else if (getElementValue("BussType")==1)
		{
			var url="dhceq.em.maint.csp?";
			var title="������¼"
		}	
		else
		{
			var url="dhceq.em.inspect.csp?";
			var title="Ѳ���¼"
		}	
		url=url+para;	
		var icon="icon-w-paper"	 //modify by lmm 2018-11-14
		var type=""	 //modify by lmm 2018-11-14	
		//modified by csj 20181128 �����:762692
		//modified by czf 20190902 �����:928402
		//modify by lmm 2020-05-09 1311841
		//modify by lmm 2020-06-17 UI
		btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;1200&quot;,&quot;10row&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>';
	return btn;
}

///add by czf ������ʷά����¼
function maintHistoryList(index)
{
	var curRowObj=$('#maintfinddatagrid').datagrid('getRows')[index];
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


var columns=getCurColumnsInfo('EM.G.Maint.MaintEquipAlert','','','');   ///Modefied by zc0134 2023-04-21  �����ж���   
//�������
jQuery(document).ready
(    
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initUserInfo();
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	initMessage("");
	initMaintEquipAlertData();
	jQuery('#BFind').on("click", BFind_Clicked);
	jQuery('#BExecute').on("click", BExecute_Clicked);
}
	
function initMaintEquipAlertData(){
	$HUI.datagrid("#tDHCEQMaintEquipAlert",{   
	    url:$URL, 
    	queryParams:{
        	ClassName:"web.DHCEQ.EM.BUSMaintPlan",
        	QueryName:"GetPlanAlertNew",
        	BussType:getElementValue("BussType"),
        	EquipDR:getElementValue("EquipDR"),
        	MaintLocDR:getElementValue("MPMaintLocDR"),
        	MaintTypeDR:getElementValue("MPMaintTypeDR"),
        	QXType:getElementValue("QXType"),
        	PlanNameDR:getElementValue("MPNameDR"),
        	No:getElementValue("EquipNo"),
        	PlanName:getElementValue("MPName")
    	},
  		singleSelect:false,
   		fitColumns:true,
		///Modefied by zc0134 2023-04-21  �����ж���   begin
	    /*/columns:[[
	    	{field:'TRowID',title:'TRowID',width:10,hidden:'ture'},
    		{field:'Chk',title:'���',align:'center',width:20,checkbox:true}, 
    		{field:'TRow',title:'���',align:'center',width:20},
	    	{field:'TName',title:'�ƻ�����',width:60,formatter:MaintPlanName},   
	        {field:'TNo',title:'�豸���',width:60},
	        {field:'TEquip',title:'�豸����',width:60},
	        {field:'TEquipDR',title:'TEquipDR',width:10,hidden:'ture'},
	        {field:'TModel',title:'����ͺ�',width:60},
	        {field:'TMaintType',title:'��������',width:60,align:'center'},
	        {field:'TLastDate',title:'�ϴα�������',width:40,align:'center'}, 
	        {field:'TCycleNum',title:'��������',width:30,align:'center'},      
	        {field:'TPreWarnDaysNum',title:'Ԥ������',width:30,align:'center'},
	        {field:'TNextDate',title:'�´α�������',width:40,align:'center'},
	        {field:'TMaintFee',title:'��������',width:60,align:'center'}, 
	        {field:'TMaintLoc',title:'��������',width:30,align:'center'},
	        {field:'TMaintMode',title:'ά����ʽ',width:30,align:'center'}, 
	        {field:'TRemark',title:'��ע',width:40}, 
	        {field:'TLocation',title:'��ŵص�',width:40}, 
	        {field:'TEquipRangeDR',title:'TEquipRangeDR',hidden:'true'},
	        {field:'TPERowID',title:'TPERowID',hidden:'true'},		// MZY0085	1975493		2021-07-28
	        {field:'TPELRowID',title:'TPELRowID',hidden:'true'},	// MZY0085	1975493		2021-07-28
	    ]],*/
		columns:columns,   ///Modefied by zc0134 2023-04-21  �����ж���   end
	    pagination:true,
	    pageSize:15,
	    pageNumber:1,
	    pageList:[15,30,45,60,75]   
});
	///Modefied by zc0134 2023-04-21  ���ӵ���¼� begin
	var TName=$("#tDHCEQMaintEquipAlert").datagrid('getColumnOption','TName');
	TName.formatter=	function(value,row,index){
			return MaintPlanName(value,row)	
		}
	///Modefied by zc0134 2023-04-21  ���ӵ���¼� end
}

function MaintPlanName(rowIndex, rowData)
{
	if(rowData.TRowID!="")
	{
		var MaintPlanName=rowData.TName
		var EquipRangeDR=rowData.TEquipRangeDR
		/*
		var IconName=MaintPlanName.split("^")
		var Icon=IconName[0];
		var Name=IconName[1];
		var ImageSrc=""
		if (Icon){
			ImageSrc='<img border=0 complete="complete" src="../images/'+Icon+'" />'
		}*/
		var url="dhceq.em.maintplan.csp?RowID="+rowData.TRowID+"&BussType="+getElementValue("BussType")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR")+"&EquipRangeDR="+EquipRangeDR;
		// MZY0082	1969298,1969317		2021-07-14	��������
		var btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+MaintPlanName+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+'&quot;,&quot;'+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#">'+MaintPlanName+'</A>';
		return btn;
	}
}

function BExecute_Clicked()
{
	var BussType=getElementValue("BussType")
	var selectrow = $("#tDHCEQMaintEquipAlert").datagrid("getChecked");
	if (selectrow.length==0)
	{
		alertShow("��ѡ��Ҫִ�е��豸")
		return
	}
	var ValRowIDs = [];
	for(var i=0;i<selectrow.length;i++)
	{
		var ListInfo=selectrow[i].TRowID+"^"+selectrow[i].TEquipDR;
		//	MZY0085	1975493		2021-07-28	����ִ�е��ĵ�������
		if (selectrow[i].TPERowID=="")
		{
			ValRowIDs.push(ListInfo);
		}
		else
		{
			var valList=selectrow[i].TRowID+"^"+selectrow[i].TEquipDR+"^"+selectrow[i].TPELRowID+"^��ִ��^"+selectrow[i].TMaintFee+"^^^";
			//alert(valList)
			var Result=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","ExecutePlan",selectrow[i].TPERowID,valList,getElementValue("BussType"))
			if (Result<0)
			{
				alertShow("����ʧ��!   "+selectrow[i].TNo)
				return
			}
		}
	}
	var val=""
	for(var j=0;j<ValRowIDs.length;j++)
	{
		if (j==0)  
		{	val=ValRowIDs[j]	}
		else
		{	val=val+","+ValRowIDs[j]	}
	}
	// MZY0085	1975493		2021-07-28
	if (val=="")
	{
		location.reload();
		return
	}
	var Result=tkMakeServerCall("web.DHCEQMaintNew","Execute",val,BussType)
	var BussType=getElementValue("BussType");
	var QXType=getElementValue("QXType");
	var MaintLocDR=getElementValue("MaintLocDR");
	var MaintTypeDR=getElementValue("MaintTypeDR");
	var List=Result.split("^")
	if (List[0]==0)
	{
		//window.location.reload();
		//var url="dhceq.em.meteragefind.csp?&BussType="+BussType+"&QXType="+QXType+"&ManageLocDR="+MaintLocDR+"&MaintTypeDR="+MaintTypeDR+"&MaintIDs="+List[1]+"&TempFlag=1";
		//showWindow(url,"������¼","","","icon-w-paper","modal")
		//ˢ�¸�����
		location.reload();
		//websys_showModal("options").mth();
	}
	else
	{
		alertShow(t[Result])
	}
}

function BFind_Clicked(){
	$HUI.datagrid("#tDHCEQMaintEquipAlert",{   
	    url:$URL, 
    	queryParams:{
        	ClassName:"web.DHCEQ.EM.BUSMaintPlan",
        	QueryName:"GetPlanAlertNew",
        	BussType:getElementValue('BussType'),
        	EquipDR:getElementValue('EquipDR'),
        	MaintLocDR:getElementValue('MPMaintLocDR'),
        	MaintTypeDR:getElementValue('MPMaintTypeDR'),
        	QXType:getElementValue('QXType'),
        	PlanNameDR:getElementValue('MPNameDR'),
        	No:getElementValue('EquipNo'),
        	PlanName:getElementValue('MPName'),
        	FixTimeFlag:getElementValue('FixTimeFlag')
        	//TempPlanFlag:getElementValue('TempPlanFlag')		//MZY0091 2074805,2078709 2021-08-26 ȡ��������
    	},
	});
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	// MZY0082	1969298,1969317		2021-07-14
	if(vElementID=="MPName")
	{
		setElement("MPName",item.TName);
	}
	if(vElementID=="MPMaintType")
	{
		setElement("MPMaintType",item.TDesc);
	}
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

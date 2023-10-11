var columns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','N');  ///Modefidy by zc 2018-10-29 ZC0041 �޸�ҳ�治��ʾ�����
var frozencolumns=getCurColumnsInfo('EM.G.Equip.EquipList','','','','Y');  ///Modefidy by zc 2018-10-29 ZC0041 �޸�ҳ�治��ʾ�����
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
	initUserInfo();  ///Add By zc0096 20210121 sessionֵ��ʼ��
	initPanel();
}
function initPanel()
{
	initTopPanel();
	initStatusData();		
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	initLookUp();
	singlelookup("StatCat","PLAT.L.StatCat","",GetStatCat)
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	initStatusData();
	initMessage("");
	defindTitleStyle();
	setRequiredElements("SnapShot")
	initDHCEQSnapEquipList();			//��ʼ�����
	$("#EquipType").lookup({
            onSelect:function(index,rowData){
	            setElement("EquipTypeDR",rowData.TRowID)
                singlelookup("StatCat","PLAT.L.StatCat","",GetStatCat)
            },
       });
}

function GetStatCat(item)
{
	setElement("StatCat",item.TName);			
	setElement("StatCatDR",item.TRowID);
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	if(vElementID=="SnapShot")
	{
		setElement(vElementID,item.TDate)
	}
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
	if(vElementID=="EquipType")
	{
		setElement("StatCatDR","")
		setElement("StatCat","")
	}
	if(vElementID=="SnapShot")
	{
		setElement(vElementID,"")
	}
}
///add by lmm 2017-06-28 394342 ״̬����������ȫ��״̬
function initStatusData()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: 'ȫ��'
			},{
				id: '0',
				text: '�ڿ�'
			},{
				id: '1',
				text: '����'
			},{
				id: '2',
				text: 'ͣ��'
			}]
});
}
function initDHCEQSnapEquipList()
{
	$HUI.datagrid("#tDHCEQSnapEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSSnapShot",   //Modefied by zc0044 2018-11-22 �޸�query����
	        QueryName:"GetEquipList",
	        vData:"^IsOut=N^IsDisused=N^",
	        SnapShotID:$('#SnapShotDR').val(),
	        Ejob:getElementValue("Job")  // Modified By QW20210705 BUG:QW0136 �������Ejob�����ϼƴ���
	    },
	    border : false,
		striped : true,
	    cache: false,
		//fitColumns:true,
    	columns:columns, 
    	frozenColumns:frozencolumns,
		fit:true,
    	pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
    	toolbar:[
                {
                iconCls: 'icon-export',
                text:'����',
                handler: function(){
                     BSaveExcel_Click();
                }},'----------',
                {
                iconCls: 'icon-set-col',
                text:'����������',
                handler: function(){
                     BColSet_Click();
                }}],
		onLoadSuccess: function (data) {
			InitToolbarForAmountInfo();	
		},
});
}
/***************************************��ť���ú���*****************************************************/
function BFind_Clicked()
{
	if (checkMustItemNull()) return;
	var lnk=GetLnk()
	//lnk=lnk+"&SnapShotID="+GetElementValue("SnapShotDR");
	$HUI.datagrid("#tDHCEQSnapEquipList",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSSnapShot",  //Modefied by zc0044 2018-11-22 �޸�query����
	        QueryName:"GetEquipList",
	        vData:lnk,
	        SnapShotID:$('#SnapShotDR').val(),
	        Ejob:getElementValue("Job")  // Modified By QW20210705 BUG:QW0136 �������Ejob�����ϼƴ���
	    },
	    onLoadSuccess: function (data) {
			InitToolbarForAmountInfo();
		}
	    });
	jQuery('#tDHCEQSnapEquipList').datagrid('unselectAll')  
}
function GetLnk()
{
	var lnk="";
	lnk=lnk+"^No="+getElementValue("No");
	lnk=lnk+"^Name="+getElementValue("Name");
	lnk=lnk+"^EquipCatDR="+getElementValue("EquipCatDR");
	lnk=lnk+"^Code="+getElementValue("Code");
	lnk=lnk+"^UseLocDR="+getElementValue("UseLocDR");
	if (getElementValue("IncludeFlag")==true)
		lnk=lnk+"^IncludeFlag=1"
	else 
		lnk=lnk+"^IncludeFlag=0"
	lnk=lnk+"^MinValue="+getElementValue("MinValue");
	lnk=lnk+"^MaxValue="+getElementValue("MaxValue");
	lnk=lnk+"^FundsTypeDR="+getElementValue("FundsTypeDR");
	lnk=lnk+"^LocationDR="+getElementValue("LocationDR");
	lnk=lnk+"^BeginInStockDate="+GetJQueryDate('#BeginInStockDate');   
	lnk=lnk+"^EndInStockDate="+GetJQueryDate('#EndInStockDate');
	lnk=lnk+"^EquipTypeDR="+getElementValue("EquipTypeDR");
	lnk=lnk+"^StatCatDR="+getElementValue("StatCatDR");
	lnk=lnk+"^ProviderDR="+getElementValue("ProviderDR");
	lnk=lnk+"^ManuFactoryDR="+getElementValue("ManuFactoryDR");
	lnk=lnk+"^Status="+getElementValue("Status");
	lnk=lnk+"^InStockNo="+getElementValue("InStockNo");
	lnk=lnk+"^StoreMoveNo="+getElementValue("StoreMoveNo");
	lnk=lnk+"^QXType="+getElementValue("QXType");
	lnk=lnk+"^IsDisused=N";                ;
	lnk=lnk+"^IsOut=N";
	lnk=lnk+"^Chk=";	//δ��ӡ����
	if (getElementValue("Chk")==true)
	{
		lnk=lnk+"1";
	} 
	if (getElementValue("CheckRentFlag")==true)
		lnk=lnk+"^CheckRentFlag=1"
	else 
		lnk=lnk+"^CheckRentFlag=0"
	return lnk
}
function BSaveExcel_Click() //����
{	
	//Modefied by zc0093  ��Ǭ�����޸� 2021-01-07 begin
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		var Rows = $('#tDHCEQSnapEquipList').datagrid('getRows');
		var RowCount=Rows.length;
		if(RowCount<=0){
			messageShow("","","","û������!")
			return;
		}
		// MZY0121	2587810		2022-04-15
		if (!CheckColset("Equip"))
		{
			messageShow('popover','alert','��ʾ',"����������δ����!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQSnapEquipExport.raq&CurTableName=Equip&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+getElementValue("Job")
    	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		var vData=GetLnk();
		PrintDHCEQEquipNew("Equip",1,getElementValue("Job"),vData,"SnapEquipList",50);	//Mozy	914705	2019-5-27
		return
	}
	//Modefied by zc0093  ��Ǭ�����޸� 2021-01-07 end
}
function BColSet_Click() //��������������
{
	var para="&TableName=Equip&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)   //modify by lmm 2020-06-05 UI
	//Modefidy by zc0046 �޸ĵ����ڲ�ͬ�ֱ��ʵ�����������
	//Modefied by zc0044 2018-11-22 �޸ĵ�����С
}
// ̨����ϸ�˵�������ʾ�ϼ���Ϣ
function InitToolbarForAmountInfo() {
	var Ejob=getElementValue("Job");  // Add By QW20210705 BUG:QW0136 �������Ejob�����ϼƴ���
	var Data = tkMakeServerCall("web.DHCEQ.EM.BUSSnapShot","GetEquipSumInfo",'',Ejob);  // Modified By QW20210705 BUG:QW0136 �������Ejob�����ϼƴ���
	$("#sumTotal").html(Data);	
}

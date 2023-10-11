var Job=getElementValue("Job")
var DisplayFlag="";

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	setElement("NoDealFlag",true)
	initUserInfo();
    initMessage("dis"); //��ȡ����ҵ����Ϣ
    initLookUp();
	defindTitleStyle(); 
  	initButton();
    //initButtonWidth();
    initPage();//��ͨ�ð�ť��ʼ��
    initType();
	$HUI.datagrid("#tDHCEQDisuse",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQBatchDisuseRequest",
	        	QueryName:"GetImportDisuseEquipList",
				Job:Job,
			},
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:[[
				{field:'TNo',title:'�ʲ�����',width:150,align:'left'},
				{field:'TFileNo',title:'������',width:80,align:'left'},
				{field:'TEquipName',title:'����',width:150,align:'left'},
				{field:'TModel',title:'�ͺ�',width:180,align:'left'},
				{field:'TStoreLoc',title:'����',width:150,align:'left'},
				{field:'TStatus',title:'״̬',width:50,align:'center'},
				{field:'TEquipType',title:'����',width:80,align:'center'},
				{field:'TTransAssetDate',title:'�������',width:100,align:'center'},
				{field:'TOriginalFee',title:'ԭֵ',width:100,align:'right'},
				{field:'TNetFee',title:'��ֵ',width:100,align:'right'},
				{field:'TDepreTotalFee',title:'�ۻ��۾�',width:100,align:'right'},
				{field:'TFlag',title:'�쳣���',width:10,align:'left',hidden:true},		
				{field:'TFlagRemark',title:'�쳣״̬',width:550,align:'left'},
			]],
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			onLoadSuccess:function(){
				//creatToolbar();
			}
	});
	initEquipFilter();
}
	
function initEquipFilter()
{
	 $("#EquipFilter").keywords({
        singleSelect:true,
        onClick:function(v){},
        onUnselect:function(v){
	    },
        onSelect:function(v){
	        var selectItemID=v.id;
	        if (selectItemID=="allflag")
			{
				BAll_Clicked();
			}
			else if (selectItemID=="diffflag")
			{
				BDiff_Clicked();
			}
			
        },
        labelCls:'blue',
        items:[
            {text:'ȫ���豸',id:'allflag',selected:true},
            {text:'�쳣�豸',id:'diffflag'},
        ]
	 });
}

function creatToolbar()
{
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:0px'>ȫ���豸</a>"+
						"<a id='diffflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-left:20px;margin-right:0px;'>�쳣�豸</a>"
	
	$("#sumTotal").html(lable_innerText);
	if (jQuery("#allflag").length>0)
	{
		jQuery("#allflag").linkbutton({iconCls: 'icon-star-yellow'});
		jQuery("#allflag").on("click", BAll_Clicked);
	}
	if (jQuery("#diffflag").length>0)
	{
		jQuery("#diffflag").linkbutton({iconCls: 'icon-star-half'});
		jQuery("#diffflag").on("click", BDiff_Clicked);
	}
}

function BAll_Clicked()
{
	DisplayFlag="";
	$("#allflag").css("color", "#FF0000");
	$("#diffflag").css("color", "#FFFFFF");
	BFind_Clicked();
}
function BDiff_Clicked()
{
	DisplayFlag="1";
	$("#allflag").css("color", "#FFFFFF");
	$("#diffflag").css("color", "#FF0000");
	BFind_Clicked();
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQDisuse",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQBatchDisuseRequest",
	        	QueryName:"GetImportDisuseEquipList",
				Job:Job,
				DisplayFlag:DisplayFlag
			},
	});
}

function initPage()
{
	if (jQuery("#BBatchDisuse").length>0)
	{
		jQuery("#BBatchDisuse").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BBatchDisuse").on("click", BBatchSaveDisuseRequest_Clicked);
		jQuery("#BBatchDisuse").linkbutton({text:'���ɵ���'});
	}
}
function initType()
{
	var OperationType = $HUI.combobox('#OperationType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: 'δ����'
			},{
				id: '1',
				text: '�����½����ϵ�'
			},{
				id: '2',
				text: '�����ύ���ϵ�'
			},{
				id: '3',
				text: '����Ԥ���ϵ�'
			},{
				id: '4',
				text: '���������ϱ��ϵ�'
			}]
	});
	var KindType = $HUI.combobox('#KindType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: '��̨����'
			},{
				id: '2',
				text: '������'
			}]
	});
	
}
function ImportData()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
}

function BImport_Chrome()
{
	if (Job=="")
	{
		messageShow('alert','error','������ʾ',"Job����Ϊ��!")
		return;
	}
    
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))
	{
		alertShow("û�����ݵ��룡")
		return 0;
	}
    var EquipIDs=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
	    var Col=0;
	    var No=RowInfo[Row-1][Col++];
	    if (No==undefined) No=""
	    if (No=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"�豸���Ϊ��!")
		    return 1;
	    }
	    No=No.replace(/\ +/g,"")	//ȥ���ո�
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+'�豸:'+No+'���Ϊ��!')
		    return 1;
	    }
	    else
	    {
		    if (EquipIDs=="") EquipIDs=EquipID
		    else EquipIDs=EquipIDs+"^"+EquipID
		}
	}    
	if (EquipIDs=="")
	{
		messageShow('alert','error','������ʾ',"�������Ϊ��!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQBatchDisuseRequest","ImportDisuseEquip",Job,EquipIDs);
	if (result!=0)
	{
	    messageShow("","","","������Ϣ:��"+result+"���豸��������;�е�ҵ��!���ȴ�������ٽ�����һ��.");
	}
    else
    {
		messageShow("","success","","�������!");
		
		disableElement("BBatchDisuse",0)
	}
	BFind_Clicked()
}
function BImport_IE()
{
	if (Job=="")
	{
		messageShow('alert','error','������ʾ',"Job����Ϊ��!")
		return;
	}
	
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets(1);
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
    var EquipIDs=""
	for (var Row=2;Row<=ExcelRows;Row++)
	{
	    var Col=1;
	    var No=xlsheet.cells(Row,Col++).value;
	    if (No==undefined) No=""
	    if (No=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"�豸���Ϊ��!")
		    return 1;
	    }
	    No=No.replace(/\ +/g,"")	//ȥ���ո�
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+'�豸:'+No+'���Ϊ��!')
		    return 1;
	    }
	    else
	    {
		    if (EquipIDs=="") EquipIDs=EquipID
		    else EquipIDs=EquipIDs+"^"+EquipID
		}
	}
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet.Quit;
    xlsheet=null;
    
	if (EquipIDs=="")
	{
		messageShow('alert','error','������ʾ',"�������Ϊ��!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQBatchDisuseRequest","ImportDisuseEquip",Job,EquipIDs);
	if (result!=0)
	{
	    messageShow("","","","������Ϣ:��"+result+"���豸��������;�е�ҵ��!���ȴ�������ٽ�����һ��.");
	}
    else
    {
		messageShow("","success","","�������!");
		
		disableElement("BBatchDisuse",0)
	}
	BFind_Clicked()
}

function BBatchSaveDisuseRequest_Clicked()
{
	var KindType=getElementValue("KindType")
	if (KindType=="")
	{
		messageShow('alert','error','������ʾ',"��������Ϊ��!")
		return;
	}
	var OperationType=getElementValue("OperationType")
	if (OperationType=="")
	{
		messageShow('alert','error','������ʾ',"��������Ϊ��!")
		return;
	}
	var NoDealFlag=getElementValue("NoDealFlag")
	var result=tkMakeServerCall("web.DHCEQBatchDisuseRequest","BuildDisuseRequest",Job,OperationType,KindType,NoDealFlag);
	if (result!=0)
	{
	    messageShow("","","","������Ϣ:"+result);
	}
    else
    {
		messageShow("","success","","���ɳɹ�!");
		disableElement("BBatchDisuse",1)
	}
}

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
    initMessage(); //��ȡ����ҵ����Ϣ
    initLookUp();
	defindTitleStyle(); 
  	initButton();
    //initButtonWidth();
    initPage();//��ͨ�ð�ť��ʼ��
    initType();
	$HUI.datagrid("#tDHCEQStoreMove",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQStoreMoveNew",
	        	QueryName:"GetImportSMEquipList",
				Job:Job,
			},
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
			singleSelect:true,
			fit:true,
			border:false,
			columns:[[
				{field:'TNo',title:'�ʲ�����',width:150,align:'left'},
				{field:'TLeaveFactoryNo',title:'�������',width:150,align:'left'},
				{field:'TEquipName',title:'�ʲ�����',width:150,align:'left'},
				{field:'TModel',title:'�ͺ�',width:180,align:'left'},
				{field:'TFromLoc',title:'��������',width:150,align:'left'},
				{field:'TToLoc',title:'���տ���',width:150,align:'left'},
				{field:'TReceiver',title:'������',width:80,align:'left'},
				{field:'TLocation',title:'��ŵص�',width:100,align:'left'},
				{field:'TStatus',title:'״̬',width:50,align:'center'},
				{field:'TEquipType',title:'����',width:80,align:'center'},
				{field:'TTransAssetDate',title:'�������',width:100,align:'center'},
				{field:'TOriginalFee',title:'ԭֵ',width:100,align:'right'},
				{field:'TNetFee',title:'��ֵ',width:100,align:'right'},
				{field:'TDepreTotalFee',title:'�ۻ��۾�',width:100,align:'right'},
				{field:'TFlag',title:'�쳣���',width:10,align:'left',hidden:true},		
				{field:'TFlagRemark',title:'�쳣״̬',width:100,align:'left'},
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
	var lable_innerText="<a id='allflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-right:10px'>ȫ���豸</a>"+
						"<a id='diffflag' href='#' class='hisui-linkbutton' data-options='stopAllEventOnDisabled:true' style='margin-right:10px;'>�쳣�豸</a>"
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
	BFind_Clicked();
}
function BDiff_Clicked()
{
	DisplayFlag="1";
	BFind_Clicked();
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQStoreMove",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQStoreMoveNew",
	        	QueryName:"GetImportSMEquipList",
				Job:Job,
				DisplayFlag:DisplayFlag
			},
	});
}

function initPage()
{
	if (jQuery("#BBatchStoreMove").length>0)
	{
		jQuery("#BBatchStoreMove").linkbutton({iconCls: 'icon-w-stamp'});
		jQuery("#BBatchStoreMove").on("click", BBatchStoreMove_Clicked);
		jQuery("#BBatchStoreMove").linkbutton({text:'���ɵ���'});
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
				text: '�����½�ת�Ƶ�'
			},{
				id: '2',
				text: '�����ύת�Ƶ�'
			},{
				id: '3',
				text: '����������ת�Ƶ�'
			}]
	});
	/*
	var MoveType = $HUI.combobox('#MoveType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: '�ⷿ����'
			},{
				id: '1',
				text: '���ҵ���'
			},{
				id: '2',
				text: '����ת���Ͽ�'
			},{
				id: '3',
				text: '�����˿�'
			},{
				id: '4',
				text: '�ⷿ����'
			}]
	});*/
	var KindType = $HUI.combobox('#KindType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: '��̨'
			},{
				id: '2',
				text: '����'
			}]
	});
}

///������:�ʲ����ơ��ʲ���š����տ��ҡ������ˡ���ŵص�
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
    var ImportInfo=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
	    var Col=1;
	    var No=RowInfo[Row-1][Col++];
	    if (No==undefined) No=""
	    var ToLoc=RowInfo[Row-1][Col++];
	    if (ToLoc==undefined) ToLoc=""
	    var Receiver=RowInfo[Row-1][Col++];
	    if (Receiver==undefined) Receiver=""
	    var Location=RowInfo[Row-1][Col++];
	    if (Location==undefined) Location=""
	    
	    if (No=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"�ʲ���Ų���Ϊ��!")
		    //return 1;  /// Modefied By ZC0133 2023-4-20 
	    }
	    No=No.replace(/\ +/g,"")	//ȥ���ո�
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+'�ʲ����:'+No+'������!')
		    //return 1;  /// Modefied By ZC0133 2023-4-20 
	    }
		
		if (ToLoc=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"���տ��Ҳ���Ϊ��!")
		    //return 1;  /// Modefied By ZC0133 2023-4-20 
	    }
	    ToLoc=ToLoc.replace(/\ +/g,"")	//ȥ���ո�
		var ToLocID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",ToLoc);
	    if (ToLocID=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+'���տ���:'+ToLoc+'������!')
		   // return 1;  /// Modefied By ZC0133 2023-4-20 
	    }
	    var StoreLocID=tkMakeServerCall("web.DHCEQStoreMoveNew","GetEQStoreLocID",EquipID)
		if (StoreLocID==ToLocID)
		{
			messageShow('alert','error','������ʾ',"��"+Row+"��"+'���տ���:'+ToLoc+'���豸���ڿ�����ͬ,����ת��!')
		   // return 1;  /// Modefied By ZC0133 2023-4-20 
		}
	    var ToLocType=tkMakeServerCall("web.DHCEQCommon","CheckLocTypeNew",ToLocID)
	 	if (ToLocType="")
	 	{
		 	messageShow('alert','error','������ʾ',"��"+Row+"��"+'���տ���:'+ToLoc+'��������δ����,�������ÿ�������!')
		    //return 1;  /// Modefied By ZC0133 2023-4-20 
		}
		
	    var ReceiverID=""
	    if(Receiver!="")
	    {
		    ReceiverID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUser",Receiver);
		    if (ReceiverID=="")
		    {
			    messageShow('alert','error','������ʾ',"��"+Row+"��"+'������:'+Receiver+'������!')
		    }
		}
		
		var LocationID=""
	    if(Location!="")
	    {
		    LocationID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCLocation",Location);
		    if (LocationID=="")
		    {
			    messageShow('alert','error','������ʾ',"��"+Row+"��"+'��ŵص�:'+Location+'������!')
			    LocationID="" /// Modefied By ZC0133 2023-4-20 
		    }
		}
		
	    if (ImportInfo=="") ImportInfo=EquipID+"^"+ToLocID+"^"+ReceiverID+"^"+LocationID
		else ImportInfo=ImportInfo+"$$"+EquipID+"^"+ToLocID+"^"+ReceiverID+"^"+LocationID
	}    
	if (ImportInfo=="")
	{ 
		messageShow('alert','error','������ʾ',"�������Ϊ��!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQStoreMoveNew","ImportStoreMoveEquip",Job,ImportInfo);
	if (result.split("^")[0]!=0)		//2006617 czf 20210707
	{
	    messageShow("","","","������Ϣ:"+result.split("^")[1]+",���ȴ�������ٽ�����һ����");
	}
    else
    {
		messageShow("","success","","�������!");
		
		disableElement("BBatchStoreMove",0)
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
    var ImportInfo=""
	for (var Row=2;Row<=ExcelRows;Row++)
	{
	    var Col=2;
	    var No=xlsheet.cells(Row,Col++).value;
	    if (No==undefined) No=""
	    var ToLoc=xlsheet.cells(Row,Col++).value;
	    if (ToLoc==undefined) ToLoc=""
	    var Receiver=xlsheet.cells(Row,Col++).value;
	    if (Receiver==undefined) Receiver=""
	    var Location=xlsheet.cells(Row,Col++).value;
	    if (Location==undefined) Location=""
	    if (No=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"�ʲ���Ų���Ϊ��!")
		    //return 1;   /// Modefied By ZC0133 2023-4-20 
	    }
	    No=No.replace(/\ +/g,"")	//ȥ���ո�
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",No);
	    if (EquipID=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+'�ʲ����:'+No+'������!')
		    //return 1; /// Modefied By ZC0133 2023-4-20 
	    }
		
		if (ToLoc=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+"���տ��Ҳ���Ϊ��!")
		    //return 1; /// Modefied By ZC0133 2023-4-20 
	    }
	    ToLoc=ToLoc.replace(/\ +/g,"")	//ȥ���ո�
		var ToLocID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","CTLoc",ToLoc);
	    if (ToLocID=="")
	    {
		    messageShow('alert','error','������ʾ',"��"+Row+"��"+'���տ���:'+ToLoc+'������!')
		    //return 1; /// Modefied By ZC0133 2023-4-20 
	    }
	    var StoreLocID=tkMakeServerCall("web.DHCEQStoreMoveNew","GetEQStoreLocID",EquipID)
		if (StoreLocID==ToLocID)
		{
			messageShow('alert','error','������ʾ',"��"+Row+"��"+'���տ���:'+ToLoc+'���豸���ڿ�����ͬ,����ת��!')
		    //return 1; /// Modefied By ZC0133 2023-4-20 
		}
	    var ToLocType=tkMakeServerCall("web.DHCEQCommon","CheckLocTypeNew",ToLocID)
	 	if (ToLocType="")
	 	{
		 	messageShow('alert','error','������ʾ',"��"+Row+"��"+'���տ���:'+ToLoc+'��������δ����,�������ÿ�������!')
		    //return 1; /// Modefied By ZC0133 2023-4-20 
		}
		
	    var ReceiverID=""
	    if(Receiver!="")
	    {
		    ReceiverID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCUser",Receiver);
		    if (ReceiverID=="")
		    {
			    messageShow('alert','error','������ʾ',"��"+Row+"��"+'������:'+Receiver+'������!')
		    }
		}
		
		var LocationID=""
	    if(Location!="")
	    {
		    LocationID=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCLocation",Location);
		    if (LocationID=="")
		    {
			    var val=getPYCode(Location)+"^"+Location;
				var LocationID=tkMakeServerCall("web.DHCEQCLocation","UpdLocation",val);
		  		if ((LocationID<=0)&&(GetElementValue("Location")!=""))
			    {
				    messageShow('alert','error','������ʾ',"��"+Row+"��"+'��ŵص�:'+Location+'�ǼǴ���!!')
				    //return 1;   /// Modefied By ZC0133 2023-4-20 
				    LocationID=""  /// Modefied By ZC0133 2023-4-20 
			    }
		    }
		}
		
	    if (ImportInfo=="") ImportInfo=EquipID+"^"+ToLocID+"^"+ReceiverID+"^"+LocationID
		else ImportInfo=ImportInfo+"$$"+EquipID+"^"+ToLocID+"^"+ReceiverID+"^"+LocationID
	}
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    //xlsheet.Quit;
    xlsheet=null;
    
	if (ImportInfo=="")
	{
		messageShow('alert','error','������ʾ',"�������Ϊ��!")
		return
	}
	var result=tkMakeServerCall("web.DHCEQStoreMoveNew","ImportStoreMoveEquip",Job,ImportInfo);
	if (result.split("^")[0]!=0)
	{
	    messageShow("","","","������Ϣ:"+result.split("^")[1]+",���ȴ�������ٽ�����һ����");
	}
    else
    {
		messageShow("","success","","�������!");
		disableElement("BBatchStoreMove",0);
	}
	BFind_Clicked()
}

function BBatchStoreMove_Clicked()
{
	var OperationType=getElementValue("OperationType")
	if (OperationType=="")
	{
		messageShow('alert','error','������ʾ',"�������Ͳ���Ϊ��!")
		return;
	}
	var KindType=getElementValue("KindType")
	if (KindType=="")
	{
		messageShow('alert','error','������ʾ',"�Ƿ���������Ϊ��!")
		return;
	}
	var result=tkMakeServerCall("web.DHCEQStoreMoveNew","BuildStoreMoveRequest",Job,OperationType,KindType);
	if (result!=0)
	{
	    messageShow('alert','error','������ʾ',result);
	}
    else
    {
		messageShow("","success","","���ɳɹ�!");
		disableElement("BBatchStoreMove",1)
		//BFind_Clicked();
	}
}

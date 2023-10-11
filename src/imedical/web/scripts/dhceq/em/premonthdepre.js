var Columns=getCurColumnsInfo('EM.G.Depre.PreEquipDepre','','','')

$(function(){
	initDocument();
});

function initDocument()
{
	initUserInfo();
	initMessage();
	defindTitleStyle();
	initLookUp();
	initButton();
	initButtonWidth();
	initIsDepre();
	initIsDepring();
	initIsCostAllot();
	initIsPostpone();
	singlelookup("EquipType","PLAT.L.EquipType",[{name:"Desc",type:1,value:"EquipType"},{name:"GroupID",type:3,value:"GroupID"},{name:"FixFlag",type:4,value:"FixEquipFlag"}])
    initDataGrid();
	$("#BPreDepre").on("click",function(){
		BPreDepre_Clicked()
	})
};
	
function initDataGrid()
{
	$HUI.datagrid("#DHCEQPreMonthDepre",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.BUSMonthDepre",
	        	QueryName:"GetEquipPreDepre",
				vData:getLnk()
		},
		fitColumns : true, 
		scrollbarSize:0,
		rownumbers: true,
		singleSelect:true,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		toolbar:[{
				iconCls:'icon-green-chart',
				text:'�۾���ϸ��',
				id:'BDepreListReport',
				handler:function(){DepreListReport();}
			},
			{
                iconCls: 'icon-paper-chart',
				text:'�����۾ɻ��ܱ�',
				id:'BLocDepreReport',
				handler:function(){LocDepreReport();}
			}],
		pageList:[15,50,75,100],
		onLoadSuccess:function(){
			//InitAmountInfo()
		},
		onLoadError:function(err){
			alert(JSON.stringify(err))
		}
	});
}

function getLnk()
{
	var lnk="";
	lnk += "^SSLocID="+curLocID;
	lnk += "^SSGroupID="+curSSGroupID;
	lnk += "^SSUserID="+curUserID;
	lnk += "^QXType=";
	lnk += "^Name="+getElementValue("Name");
	lnk += "^No="+getElementValue("No");
	lnk += "^UseLocDR="+getElementValue("UseLocDR");
	lnk += "^EquipTypeDR="+getElementValue("EquipTypeDR");
	lnk += "^BeginStartDate="+getElementValue("BeginStartDate");
	lnk += "^EndStartDate="+getElementValue("EndStartDate");
	lnk += "^BeginDepreDate="+getElementValue("BeginDepreDate");
	lnk += "^EndDepreDate="+getElementValue("EndDepreDate");
	lnk += "^FixEquipFlag="+getElementValue("FixEquipFlag");
	lnk += "^OriginalFeeFrom="+getElementValue("OriginalFeeFrom");
	lnk += "^OriginalFeeTo="+getElementValue("OriginalFeeTo");
	lnk += "^IsDepre="+getElementValue("IsDepre");
	lnk += "^IsDepring="+getElementValue("IsDepring");
	lnk += "^IsCostAllot="+getElementValue("IsCostAllot");
	lnk += "^IsPostpone="+getElementValue("IsPostpone");
	return lnk;
}

function BFind_Clicked()
{
	initDataGrid()
}

function setSelectValue(vElementID,rowData)
{
	setElement(vElementID+"DR",rowData.TRowID)
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

function DepreListReport()
{
	var url="dhceq.fam.monthdeprelist.csp?ReportFileName=DHCEQMonthDepreList.raq&FixEquipFlag="+getElementValue("FixEquipFlag");
	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1440,height=900,left=120,top=0');
}

function LocDepreReport()
{
	var url="dhceq.fam.monthdeprelist.csp?ReportFileName=DHCEQMonthDepreLoc.raq&DepreFlag=1&FixEquipFlag="+getElementValue("FixEquipFlag");
	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1440,height=900,left=120,top=0');
}

///�豸Ԥ�۾�
function BPreDepre_Clicked()
{
	var pMonthStr=getElementValue("CurMonth");
	if (pMonthStr=="")
	{
		messageShow('alert','error','������ʾ',"Ԥ�۾��·ݲ���Ϊ��!")
		return;
	}
	var EquipTypeIDS=getElementValue("EquipTypeIDS");
	var jsonData=tkMakeServerCall("web.DHCEQMonthDepre","GetPreMonthDepre",pMonthStr);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		messageShow("","success","","Ԥ�۾����");
		initDataGrid();
		return
	}
    else
    {
	    if (jsonData.SQLCODE=="-1001") messageShow("","","","������Ϣ:"+jsonData.Data);
	    else messageShow('alert','error','������ʾ',"��"+jsonData.Data+"���ʲ��۾ɳ���!")
		return;
	}
}

function initIsDepre()
{
	var IsDepre = $HUI.combobox("#IsDepre",{
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'},
			{id:'',text:'ȫ��'}
		],
		onChange:function(newval,oldval){}
	});
}

function initIsDepring()
{
	var IsDepring = $HUI.combobox("#IsDepring",{
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'},
			{id:'',text:'ȫ��'}
		],
		onChange:function(newval,oldval){}
	});
}

function initIsCostAllot()
{
	var IsCostAllot = $HUI.combobox("#IsCostAllot",{
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'},
			{id:'',text:'ȫ��'}
		],
		onChange:function(newval,oldval){}
	});
}

function initIsPostpone()
{
	var IsPostpone = $HUI.combobox("#IsPostpone",{
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		data:[
			{id:'1',text:'��'},
			{id:'0',text:'��'},
			{id:'',text:'ȫ��'}
		],
		onChange:function(newval,oldval){}
	});
}
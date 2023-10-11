var Job=getElementValue("Job");
var AppListColumns=[[
	{field:'TApproveType',title:'ҵ������ID',width:10,align:'center',hidden:true},
	{field:'TBussID',title:'ҵ��ID',width:10,align:'center',hidden:true},
	{field:'TAppTypeDesc',title:'ҵ������',width:60,align:'center'},
	{field:'TBussNo',title:'ҵ�񵥺�',width:100,align:'center',formatter:bussInfo},
	{field:'TName',title:'�豸����',width:150,align:'center'},
	{field:'TRequestLoc',title:'�������',width:110,align:'center'},
	{field:'TRequestDate',title:'��������',width:80,align:'center'},
	{field:'TStatusDesc',title:'����״̬',width:60,align:'center'},
	{field:'TUseLoc',title:'ʹ�ÿ���',width:110,align:'center'},
	{field:'TFromLoc',title:'��������',width:110,align:'center'},
	{field:'TToLoc',title:'���տ���',width:110,align:'center'},
	{field:'TRowID',title:'TRowID',width:110,align:'center',hidden:true},
	{field:'TApproveDate',title:'��������',width:80,align:'center'},
	{field:'TApproveTime',title:'����ʱ��',width:80,align:'center'},
	{field:'TApproveRole',title:'������ɫ',width:80,align:'center'},
	{field:'TApproveUser',title:'������',width:80,align:'center'},
	{field:'TOpinion',title:'�������',width:100,align:'center'},
	{field:'TAction',title:'����',width:60,align:'center'},
	{field:'TAppStatus',title:'����״̬',width:100,align:'center'}
]];

var AppColumns=[[
	{field:'TApproveType',title:'ҵ������ID',width:30,align:'center',hidden:true},
	{field:'TBussID',title:'ҵ��ID',width:30,align:'center',hidden:true},
	{field:'TAppTypeDesc',title:'ҵ������',width:80,align:'center'},
	{field:'TBussNo',title:'ҵ�񵥺�',width:120,align:'center',formatter:bussInfo},
	{field:'TName',title:'�豸����',width:150,align:'center'},
	{field:'TRequestLoc',title:'�������',width:120,align:'center'},
	{field:'TRequestDate',title:'��������',width:100,align:'center'},
	{field:'TStatusDesc',title:'״̬',width:80,align:'center'},
	{field:'TUseLoc',title:'ʹ�ÿ���',width:120,align:'center'},
	{field:'TFromLoc',title:'��������',width:120,align:'center'},
	{field:'TToLoc',title:'���տ���',width:120,align:'center'},
	{field:'TRowID',title:'TRowID',width:110,align:'center',hidden:true},
	{field:'TRecentDateTime',title:'�������ʱ��',width:135,align:'center'},
	{field:'TRecentRole',title:'���������ɫ',width:110,align:'center'},
	{field:'TRecentUser',title:'���������',width:110,align:'center'},
	{field:'TRecentOpinion',title:'����������',width:100,align:'center'},
	{field:'TRecentAction',title:'�����������',width:100,align:'center'},
	{field:'TApproveInfo',title:'��������',width:120,align:'center',formatter:approveInfo},
	{field:'TNextRole',title:'��һ��������ɫ',width:110,align:'center'}
]];

var Columns=AppListColumns;

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage(); //��ȡ����ҵ����Ϣ
    initLookUp();
    //Add By QW20211110 BUG:QW0154 ���Ӷ����ͽ�ɫ begin
    var params=[{name:'Buss',type:7,value:'BussType'},{name:'Type',type:2,value:'0'}]   
	singlelookup("ApproveRoleDR_Desc","PLAT.L.RoleAction",params,"")
	var params=[{name:'Buss',type:7,value:'BussType'},{name:'Type',type:2,value:'1'}]  
	singlelookup("ApproveActionDR_Desc","PLAT.L.RoleAction",params,"")
	//Add By QW20211110 BUG:QW0154 end
	defindTitleStyle(); 
  	initButton();
    initButtonWidth();
    initPage();	//��ͨ�ð�ť��ʼ��
    initType();
    setElement("Status",1);	//��ʼ��Ĭ��Ϊ�ύ
    if (getElementValue("QXType")=="1") Columns=AppColumns;	//QXType=1����������ʾ������Ϣ
    initBussAppListGrid();
}
function initPage()
{
	if (jQuery("#BSaveExcel").length>0)
	{
		jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-w-back',text:'����'});
		jQuery("#BSaveExcel").on("click", BSaveExcel_Clicked);
	}
}

function initBussAppListGrid()
{
	var ApproveInfoObj=$HUI.datagrid("#tDHCEQBussAppList",{
		url:$URL,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBMessages",
			QueryName:"GetBussApproveList",
			BussType:getElementValue("BussType"),
			vBussNo:getElementValue("BussNo"),
			Status:getElementValue("Status"),
			RequestDateFrom:getElementValue("RequestDateFrom"),
			RequestDateTo:getElementValue("RequestDateTo"),
			AuditDateFrom:getElementValue("AuditDateFrom"),
			AuditDateTo:getElementValue("AuditDateTo"),
			EJob:getElementValue("Job"),
			vApproveUser:getElementValue("ApproveUserDR"),
			vApproveRoleDR:getElementValue("ApproveRoleDR"),  //Add By QW20211110 BUG:QW0154 ���ӽ�ɫ
			vApproveActionDR:getElementValue("ApproveActionDR"),  //Add By QW20211110 BUG:QW0154 ���Ӷ���
			QXType:getElementValue("QXType"),	//czf 20211112 QXType������ʾ������ϸ�򵥾�
			BussTypeIDs:getElementValue("BussTypeIDs"),	//��ʾ��ҵ������ID��
			APPStatus:getElementValue("APPStatus")	//�����������������������
		},
	    columns:Columns,
		onLoadSuccess: function(){
			if (getElementValue("QXType")!="1")
			{
				//���õ�Ԫ�񱳾����ı���ɫ
				var trs = $(this).prev().find('div.datagrid-body').find('tr');
				for (var i = 0; i < trs.length; i++)
				{
					var TRowID="";
					for (var j = 0; j < trs[i].cells.length; j++)
					{
						var row_html = trs[i].cells[j];
	                    var cell_field=$(row_html).attr('field');
						if (cell_field=="TAppStatus")
						{
				 			// �ı䵥Ԫ����ɫ
							TAppStatus=$(row_html).find('div').html();
							if (TAppStatus=="������") trs[i].cells[j].style.cssText = 'background:#ffff00';
						    if (TAppStatus=="�������") trs[i].cells[j].style.cssText = 'background:#ff8000';
						    if (TAppStatus=="������") trs[i].cells[j].style.cssText = 'background:#c0c0c0';
						}
					}
				}
			}
		}
	});
}

function bussInfo(rowIndex, rowData)
{
	var BussNo=rowData.TBussNo;
	var BussType=rowData.TBussType;
	var BussID=rowData.TBussID;
	var Title="";
	if((BussType!="")&&(BussID!=""))
	{
		var Lnk="";
		var ReadOnly=1;
		if(BussType=="11")
		{
			Title="���յ�";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequest&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="21")
		{
			Title="��ⵥ";
			Lnk="dhceq.em.instock.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="22")
		{
			Title="ת�Ƶ�";
			Lnk="dhceq.em.storemove.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="23")
		{
			Title="�˻���";
			Lnk="dhceq.em.return.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="31")
		{
			Title="ά�޵�";
			Lnk="dhceq.em.mmaintrequest.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;	 
		}
		else if (BussType=="34")
		{
			Title="���ϵ�";
			var KindFlag=rowData.TKindFlag;
			if (KindFlag==2)
			{
				Lnk="dhceq.em.disusesimlpe.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;	 
			}
			else{
				var ComponentName="DHCEQBatchDisuseRequest;"
				Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+ComponentName+"&RowID="+BussID+"&ReadOnly="+ReadOnly;
			}
		}
		else if (BussType=="91")
		{
			Title="�ɹ�����";
			Lnk="dhceq.em.buyrequest.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;	
		}
		else if (BussType=="92")
		{
			Title="�ɹ��ƻ�";
			Lnk="dhceq.em.buyplan.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;	
		}
		else if (BussType=="93")
		{
			Title="�豸�б�";
			Lnk="dhceq.em.ifb.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="94")
		{
			Title="��ͬ";
			Lnk="dhceq.con.contract.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="61")
		{
			Title="���̹���";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQProject&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="62")
		{
			Title="���п���";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQIssue&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="A01")
		{	
			Title="������";
		    Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAInStock&RowID="+BussID+"&ReadOnly="+ReadOnly;		
		}
		else if (BussType=="A02")
		{
			Title="���ת��";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&RowID="+BussID+"&ReadOnly="+ReadOnly;			
		}
		else if (BussType=="A03")
		{
			Title="����˻�";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAReduce&RowID="+BussID+"&ReadOnly="+ReadOnly;		
		}
		else if (BussType=="A04")
		{
			Title="�������";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAReduce&RowID="+BussID+"&ReadOnly="+ReadOnly;		
		}
		else if (BussType=="64")
		{
			Title="���޵�";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&RowID="+BussID+"&ReadOnly="+ReadOnly;	
		}
		var btn='<A onclick="showWindow(&quot;'+Lnk+'&quot;,&quot;'+Title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;'+'modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+'verylarge'+'&quot;)" href="#">'+BussNo+'</A>';
		return btn;
	}
}

function approveInfo(rowIndex, rowData)
{
	var Lnk="dhceq.plat.approvelist.csp?&BussType="+rowData.TBussType+"&BussID="+rowData.TBussID;
	var Title="��������";
	var btn='<A onclick="showWindow(&quot;'+Lnk+'&quot;,&quot;'+Title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;'+'modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+'small'+'&quot;)" href="#">'+'<img border="0" complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png">'+'</A>';
	return btn;
}

var BussTypeData=[
	{
		id: '',
		text: 'ȫ��'
	},{
		id: '11',
		text: '����'
	},{
		id: '21',
		text: '���'
	},{
		id: '22',
		text: 'ת��'
	},{
		id: '34',
		text: '����'
	},{
		id: '31',
		text: 'ά��'
	},{
		id: '23',
		text: '�˻�����'
	},{
		id: '91',
		text: '�ɹ�����'
	},{
		id: '92',
		text: '�ɹ��ƻ�'
	},{
		id: '93',
		text: '�ɹ��б�'
	},{
		id: '94',
		text: '�ɹ���ͬ'
}]
function initType()
{
	var TypeArray=new Array();
	var BussTypeIDsStr=getElementValue("BussTypeIDs");
	BussTypeIDs=BussTypeIDsStr.split(",");
	if ((BussTypeIDsStr!="")&&(BussTypeIDs.length>0)){
		TypeArray.push({id: '',text: 'ȫ��'});
		for (var i=0;i<BussTypeIDs.length;i++)
		{
			var BussTypeID=BussTypeIDs[i];
			if (!BussTypeID) continue;
			var TypeObj=new Object();
			var TypeDesc=getBussTypeDesc(BussTypeID);
			if (TypeDesc){
				TypeObj.id=BussTypeID;
				TypeObj.text=TypeDesc;
				TypeArray.push(TypeObj)
			}
		}
	}else{
		TypeArray=BussTypeData
	}
	var BussType = $HUI.combobox('#BussType',{
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		data:TypeArray
	});
	
	var Status = $HUI.combobox('#Status',{
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		data:[{
				id: '',
				text: 'ȫ��'
			},{
				id: '1',
				text: '�ύ'
			},{
				id: '2',
				text: '���'
			}]
	});
	
	var APPStatus=$HUI.combobox('#APPStatus',{
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		data:[{
				id: '',
				text: 'ȫ��'
			},{
				id: '0',
				text: '������'
			},{
				id: '1',
				text: '�������'
			},{
				id: '2',
				text: '������'
			}]
	});
}

function getBussTypeDesc(TypeID)
{
	if (!TypeID) return;
	switch(TypeID){
		case '11':return '����';break;
		case '21':return '���';break;
		case '22':return 'ת��';break;
		case '23':return '�˻�/����';break;
		case '31':return 'ά��';break;
		case '34':return '����';break;
		case '55':return '���';break;
		case '76':return '����';break;
		case '91':return '�ɹ�����';break;
		case '92':return '�ɹ��ƻ�';break;
		case '93':return '�ɹ��б�';break;
		case '94':return '�ɹ���ͬ';break;
		default:return;break;
	}	
}
function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQBussAppList",{   
	    url:$URL, 
	    queryParams:{
        	ClassName:"web.DHCEQ.Plat.LIBMessages",
        	QueryName:"GetBussApproveList",
        	BussType:getElementValue("BussType"),
			vBussNo:getElementValue("BussNo"),
			Status:getElementValue("Status"),
			RequestDateFrom:getElementValue("RequestDateFrom"),
			RequestDateTo:getElementValue("RequestDateTo"),
			AuditDateFrom:getElementValue("AuditDateFrom"),
			AuditDateTo:getElementValue("AuditDateTo"),
			EJob:getElementValue("Job"),
			vApproveUser:getElementValue("ApproveUserDR"),
			vApproveRoleDR:getElementValue("ApproveRoleDR"),  //Add By QW20211110 BUG:QW0154 ���ӽ�ɫ
			vApproveActionDR:getElementValue("ApproveActionDR"),  //Add By QW20211110 BUG:QW0154 ���Ӷ���
			QXType:getElementValue("QXType"),	//czf 20211112 QXType������ʾ������ϸ�򵥾�
			BussTypeIDs:getElementValue("BussTypeIDs"),
			APPStatus:getElementValue("APPStatus")	//�����������������������
		},
	});
}

function setSelectValue(elementID,rowData)
{
	setElement(elementID.split("_")[0],rowData.TRowID)
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	
	return;
}

function BSaveExcel_Clicked()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		BSaveExcel_Chrome()
	}
	else
	{
		BSaveExcel_IE()
	}
}

function BSaveExcel_Chrome()
{
	var Node="BussApproveList";
	var encmeth=getElementValue("GetNum");
	if (getElementValue("Job")=="")  return;
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	if (+TotalRows<1)
	{
		alertShow("û�����ݵ���!");
		return;
	}
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
    var encmeth=getElementValue("GetRepPath");
	if (encmeth=="") return;
	var TemplatePath=cspRunServerMethod(encmeth);
    var Template=TemplatePath+"DHCEQBussApproveList.xls";
	var encmeth=getElementValue("GetList");
	var AllListInfo=new Array();
	for (var i=0;i<=Pages;i++)
	{
    	var OnePageRow=PageRows;
    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
    	for (var k=1;k<=OnePageRow;k++)
    	{
	    	var rowIndex=i*PageRows+k
	    	var OneDetails=cspRunServerMethod(encmeth,Node,getElementValue("Job"),rowIndex);
	    	var OneDetailList=OneDetails.split("^");
	    	AllListInfo.push(OneDetail)
    	}
	}
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var NewFileName=filepath(FileName,"\\","\\\\")
	var NewFileName=NewFileName.substr(0,NewFileName.length-4)
	
	//Chorme����������Դ���
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="xlApp = new ActiveXObject('Excel.Application');"
	Str +="for (var i=0;i<="+Pages+";i++){"
	Str +="xlBook = xlApp.Workbooks.Add('"+Template+"');"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="xlsheet.PageSetup.TopMargin=0;"
	Str +="var OnePageRow="+PageRows+";"
	Str +="if ((i=="+Pages+")&&("+ModRows+"!=0)) OnePageRow="+ModRows+";"
	Str +="xlsheet.cells.replace('[Hospital]'"+",'"+curHospitalName+"');" //add by sjh SJH0044 2021-01-21
	Str +="for (var k=1;k<=OnePageRow;k++){"
	Str +="var l=i*"+PageRows+"+k;"
	Str +="var AllListInfoStr='"+AllListInfo+"';"
	Str +="var AllListInfo=AllListInfoStr.split(',');"
	Str +="var OneDetailList=AllListInfo[l-1].split('^');"
	Str +="var j=k+3;"
	Str +="xlsheet.Rows(j).Insert();"
	Str +="var col=1;"
	Str +="xlsheet.cells(j,col++)=OneDetailList[10];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[4];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[8];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[9];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[6];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[11];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[12];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[13];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[15];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[16];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[18];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[19];}"
	Str +="xlsheet.Rows(j+1).Delete();"
	Str +="var printpage='';"
	Str +="if (i>0) {printpage='_'+i;}"
	Str +="var savefile='"+NewFileName+"'+printpage+'.xls';"
	Str +="xlBook.SaveAs(savefile);"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;}"
	Str +="xlApp=null;"
	Str +="return 1;}());";
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn = 0;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
    alertShow("�������!");
}

function BSaveExcel_IE()
{
	var Node="BussApproveList";
	var encmeth=getElementValue("GetNum");
	if (getElementValue("Job")=="")  return;
	var TotalRows=cspRunServerMethod(encmeth,Node,getElementValue("Job"));
	if (+TotalRows<1)
	{
		alertShow("û�����ݵ���!");
		return;
	}
	var PageRows=TotalRows; //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
        var encmeth=getElementValue("GetRepPath");
		if (encmeth=="") return;
		var TemplatePath=cspRunServerMethod(encmeth);
	    var Template=TemplatePath+"DHCEQBussApproveList.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=getElementValue("GetList");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	//xlsheet.cells(2,1)=xlsheet.cells(2,1) //+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	xlsheet.cells.replace("[Hospital]",curHospitalName);    // add by sjh SJH0044 2021-01-21
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var rowIndex=i*PageRows+k
	    		var OneDetails=cspRunServerMethod(encmeth,Node,getElementValue("Job"),rowIndex); 
	    		var OneDetailList=OneDetails.split("^");
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	xlsheet.cells(j,col++)=OneDetailList[10];
		    	xlsheet.cells(j,col++)=OneDetailList[4];
		    	xlsheet.cells(j,col++)=OneDetailList[8];
		    	xlsheet.cells(j,col++)=OneDetailList[9];
		    	xlsheet.cells(j,col++)=OneDetailList[6];
		    	xlsheet.cells(j,col++)=OneDetailList[11];
		    	xlsheet.cells(j,col++)=OneDetailList[12];
		    	xlsheet.cells(j,col++)=OneDetailList[13];
		    	xlsheet.cells(j,col++)=OneDetailList[15];
		    	xlsheet.cells(j,col++)=OneDetailList[16];
		    	xlsheet.cells(j,col++)=OneDetailList[18];
		    	xlsheet.cells(j,col++)=OneDetailList[19];
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="�Ʊ���:"+curUserName

			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	       	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("�������!");
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
}

function mergeCellsByField(tableID, colList) {
    var ColArray = colList.split(",");
    var tTable = $("#" + tableID);
    var TableRowCnts = tTable.datagrid("getRows").length;
    var tmpA;
    var tmpB;
    var PerTxt = "";
    var CurTxt = "";
    var alertStr = "";
    for (j = ColArray.length - 1; j >= 0; j--) {
        PerTxt = "";
        tmpA = 1;
        tmpB = 0;

        for (i = 0; i <= TableRowCnts; i++) {
            if (i == TableRowCnts) {
                CurTxt = "";
            }
            else {
                CurTxt = tTable.datagrid("getRows")[i][ColArray[j]];
            }
            if (PerTxt == CurTxt) {
                tmpA += 1;
            }
            else {
                tmpB += tmpA;
                
                tTable.datagrid("mergeCells", {
                    index: i - tmpA,
                    field: ColArray[j],
                    rowspan: tmpA,
                    colspan: null,
                });
                tTable.datagrid("mergeCells", { 
                    index: i - tmpA,
                    field: "Ideparture",
                    rowspan: tmpA,
                    colspan: null
                });
               
                tmpA = 1;
            }
            PerTxt = CurTxt;
        }
    }
}

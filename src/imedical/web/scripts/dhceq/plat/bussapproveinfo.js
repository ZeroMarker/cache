var Job=getElementValue("Job");
var AppListColumns=[[
	{field:'TApproveType',title:'业务类型ID',width:10,align:'center',hidden:true},
	{field:'TBussID',title:'业务ID',width:10,align:'center',hidden:true},
	{field:'TAppTypeDesc',title:'业务类型',width:60,align:'center'},
	{field:'TBussNo',title:'业务单号',width:100,align:'center',formatter:bussInfo},
	{field:'TName',title:'设备名称',width:150,align:'center'},
	{field:'TRequestLoc',title:'申请科室',width:110,align:'center'},
	{field:'TRequestDate',title:'申请日期',width:80,align:'center'},
	{field:'TStatusDesc',title:'单据状态',width:60,align:'center'},
	{field:'TUseLoc',title:'使用科室',width:110,align:'center'},
	{field:'TFromLoc',title:'供给科室',width:110,align:'center'},
	{field:'TToLoc',title:'接收科室',width:110,align:'center'},
	{field:'TRowID',title:'TRowID',width:110,align:'center',hidden:true},
	{field:'TApproveDate',title:'审批日期',width:80,align:'center'},
	{field:'TApproveTime',title:'审批时间',width:80,align:'center'},
	{field:'TApproveRole',title:'审批角色',width:80,align:'center'},
	{field:'TApproveUser',title:'审批人',width:80,align:'center'},
	{field:'TOpinion',title:'审批意见',width:100,align:'center'},
	{field:'TAction',title:'动作',width:60,align:'center'},
	{field:'TAppStatus',title:'审批状态',width:100,align:'center'}
]];

var AppColumns=[[
	{field:'TApproveType',title:'业务类型ID',width:30,align:'center',hidden:true},
	{field:'TBussID',title:'业务ID',width:30,align:'center',hidden:true},
	{field:'TAppTypeDesc',title:'业务类型',width:80,align:'center'},
	{field:'TBussNo',title:'业务单号',width:120,align:'center',formatter:bussInfo},
	{field:'TName',title:'设备名称',width:150,align:'center'},
	{field:'TRequestLoc',title:'申请科室',width:120,align:'center'},
	{field:'TRequestDate',title:'申请日期',width:100,align:'center'},
	{field:'TStatusDesc',title:'状态',width:80,align:'center'},
	{field:'TUseLoc',title:'使用科室',width:120,align:'center'},
	{field:'TFromLoc',title:'供给科室',width:120,align:'center'},
	{field:'TToLoc',title:'接收科室',width:120,align:'center'},
	{field:'TRowID',title:'TRowID',width:110,align:'center',hidden:true},
	{field:'TRecentDateTime',title:'最近审批时间',width:135,align:'center'},
	{field:'TRecentRole',title:'最近审批角色',width:110,align:'center'},
	{field:'TRecentUser',title:'最近审批人',width:110,align:'center'},
	{field:'TRecentOpinion',title:'最近审批意见',width:100,align:'center'},
	{field:'TRecentAction',title:'最近审批动作',width:100,align:'center'},
	{field:'TApproveInfo',title:'审批进度',width:120,align:'center',formatter:approveInfo},
	{field:'TNextRole',title:'下一步审批角色',width:110,align:'center'}
]];

var Columns=AppListColumns;

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage(); //获取所有业务消息
    initLookUp();
    //Add By QW20211110 BUG:QW0154 增加动作和角色 begin
    var params=[{name:'Buss',type:7,value:'BussType'},{name:'Type',type:2,value:'0'}]   
	singlelookup("ApproveRoleDR_Desc","PLAT.L.RoleAction",params,"")
	var params=[{name:'Buss',type:7,value:'BussType'},{name:'Type',type:2,value:'1'}]  
	singlelookup("ApproveActionDR_Desc","PLAT.L.RoleAction",params,"")
	//Add By QW20211110 BUG:QW0154 end
	defindTitleStyle(); 
  	initButton();
    initButtonWidth();
    initPage();	//非通用按钮初始化
    initType();
    setElement("Status",1);	//初始化默认为提交
    if (getElementValue("QXType")=="1") Columns=AppColumns;	//QXType=1，按单据显示审批信息
    initBussAppListGrid();
}
function initPage()
{
	if (jQuery("#BSaveExcel").length>0)
	{
		jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-w-back',text:'导出'});
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
			vApproveRoleDR:getElementValue("ApproveRoleDR"),  //Add By QW20211110 BUG:QW0154 增加角色
			vApproveActionDR:getElementValue("ApproveActionDR"),  //Add By QW20211110 BUG:QW0154 增加动作
			QXType:getElementValue("QXType"),	//czf 20211112 QXType控制显示审批明细或单据
			BussTypeIDs:getElementValue("BussTypeIDs"),	//显示的业务类型ID串
			APPStatus:getElementValue("APPStatus")	//已审批、最近审批、待审批
		},
	    columns:Columns,
		onLoadSuccess: function(){
			if (getElementValue("QXType")!="1")
			{
				//设置单元格背景及文本颜色
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
				 			// 改变单元格颜色
							TAppStatus=$(row_html).find('div').html();
							if (TAppStatus=="已审批") trs[i].cells[j].style.cssText = 'background:#ffff00';
						    if (TAppStatus=="最近审批") trs[i].cells[j].style.cssText = 'background:#ff8000';
						    if (TAppStatus=="待审批") trs[i].cells[j].style.cssText = 'background:#c0c0c0';
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
			Title="验收单";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequest&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="21")
		{
			Title="入库单";
			Lnk="dhceq.em.instock.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="22")
		{
			Title="转移单";
			Lnk="dhceq.em.storemove.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="23")
		{
			Title="退货单";
			Lnk="dhceq.em.return.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="31")
		{
			Title="维修单";
			Lnk="dhceq.em.mmaintrequest.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;	 
		}
		else if (BussType=="34")
		{
			Title="报废单";
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
			Title="采购申请";
			Lnk="dhceq.em.buyrequest.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;	
		}
		else if (BussType=="92")
		{
			Title="采购计划";
			Lnk="dhceq.em.buyplan.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;	
		}
		else if (BussType=="93")
		{
			Title="设备招标";
			Lnk="dhceq.em.ifb.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="94")
		{
			Title="合同";
			Lnk="dhceq.con.contract.csp?&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="61")
		{
			Title="工程管理";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQProject&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="62")
		{
			Title="科研课题";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQIssue&RowID="+BussID+"&ReadOnly="+ReadOnly;
		}
		else if (BussType=="A01")
		{	
			Title="配件入库";
		    Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAInStock&RowID="+BussID+"&ReadOnly="+ReadOnly;		
		}
		else if (BussType=="A02")
		{
			Title="配件转移";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&RowID="+BussID+"&ReadOnly="+ReadOnly;			
		}
		else if (BussType=="A03")
		{
			Title="配件退货";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAReduce&RowID="+BussID+"&ReadOnly="+ReadOnly;		
		}
		else if (BussType=="A04")
		{
			Title="配件减少";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAReduce&RowID="+BussID+"&ReadOnly="+ReadOnly;		
		}
		else if (BussType=="64")
		{
			Title="租赁单";
			Lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQRent&RowID="+BussID+"&ReadOnly="+ReadOnly;	
		}
		var btn='<A onclick="showWindow(&quot;'+Lnk+'&quot;,&quot;'+Title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;'+'modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+'verylarge'+'&quot;)" href="#">'+BussNo+'</A>';
		return btn;
	}
}

function approveInfo(rowIndex, rowData)
{
	var Lnk="dhceq.plat.approvelist.csp?&BussType="+rowData.TBussType+"&BussID="+rowData.TBussID;
	var Title="审批进度";
	var btn='<A onclick="showWindow(&quot;'+Lnk+'&quot;,&quot;'+Title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;'+'modal&quot;,&quot;&quot;,&quot;&quot;,&quot;'+'small'+'&quot;)" href="#">'+'<img border="0" complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png">'+'</A>';
	return btn;
}

var BussTypeData=[
	{
		id: '',
		text: '全部'
	},{
		id: '11',
		text: '验收'
	},{
		id: '21',
		text: '入库'
	},{
		id: '22',
		text: '转移'
	},{
		id: '34',
		text: '报废'
	},{
		id: '31',
		text: '维修'
	},{
		id: '23',
		text: '退货减少'
	},{
		id: '91',
		text: '采购申请'
	},{
		id: '92',
		text: '采购计划'
	},{
		id: '93',
		text: '采购招标'
	},{
		id: '94',
		text: '采购合同'
}]
function initType()
{
	var TypeArray=new Array();
	var BussTypeIDsStr=getElementValue("BussTypeIDs");
	BussTypeIDs=BussTypeIDsStr.split(",");
	if ((BussTypeIDsStr!="")&&(BussTypeIDs.length>0)){
		TypeArray.push({id: '',text: '全部'});
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
				text: '全部'
			},{
				id: '1',
				text: '提交'
			},{
				id: '2',
				text: '审核'
			}]
	});
	
	var APPStatus=$HUI.combobox('#APPStatus',{
		valueField:'id', 
		textField:'text',
		panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '已审批'
			},{
				id: '1',
				text: '最近审批'
			},{
				id: '2',
				text: '待审批'
			}]
	});
}

function getBussTypeDesc(TypeID)
{
	if (!TypeID) return;
	switch(TypeID){
		case '11':return '验收';break;
		case '21':return '入库';break;
		case '22':return '转移';break;
		case '23':return '退货/减少';break;
		case '31':return '维修';break;
		case '34':return '报废';break;
		case '55':return '拆分';break;
		case '76':return '付款';break;
		case '91':return '采购申请';break;
		case '92':return '采购计划';break;
		case '93':return '采购招标';break;
		case '94':return '采购合同';break;
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
			vApproveRoleDR:getElementValue("ApproveRoleDR"),  //Add By QW20211110 BUG:QW0154 增加角色
			vApproveActionDR:getElementValue("ApproveActionDR"),  //Add By QW20211110 BUG:QW0154 增加动作
			QXType:getElementValue("QXType"),	//czf 20211112 QXType控制显示审批明细或单据
			BussTypeIDs:getElementValue("BussTypeIDs"),
			APPStatus:getElementValue("APPStatus")	//已审批、最近审批、待审批
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
		alertShow("没有数据导入!");
		return;
	}
	var PageRows=TotalRows; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
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
	
	//Chorme浏览器兼容性处理
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
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn = 0;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
    alertShow("导出完成!");
}

function BSaveExcel_IE()
{
	var Node="BussApproveList";
	var encmeth=getElementValue("GetNum");
	if (getElementValue("Job")=="")  return;
	var TotalRows=cspRunServerMethod(encmeth,Node,getElementValue("Job"));
	if (+TotalRows<1)
	{
		alertShow("没有数据导入!");
		return;
	}
	var PageRows=TotalRows; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
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
			//xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
			//xlsheet.cells(2,1)="时间范围:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="制表人:"+curUserName

			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	       	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("导出完成!");
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

var columns=getCurColumnsInfo('DHCEQ.G.Maint.MaintList','','','');  
var toolbar=""  //Modefied by zc0107 2021-11-15
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
	var TempFlag=$("#TempFlag").val();
	if (TempFlag==1) {hiddenObj("BAdd",1)}
    //modified by ZY20221115 重复定义事件
	//jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	//jQuery("#BAdd").on("click", BAdd_Clicked);
	if (getElementValue("CollectFlag")=="Y")
	{
		jQuery("#BAdd").linkbutton("disable")
		jQuery("#BAdd").unbind();			
	}
	//Modefied by zc0103 2021-06-02 计量信息导入 begin
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		toolbar=[
			{
				id:"import",
				iconCls:'icon-import',
				text:'导入',
				handler:function(){ImportData();}
			}	
		]
	}
	if (getElementValue("PrivateFlag")!="")
	{
		setElement("PrivateFlag",curUserID);//MZY0121 2022-04-15
		disableElement("MaintUser",1);//MZY0124 2022-05-23
		setElement("MaintUser",curUserName);//modified by cjt 20221215 需求号3118651
		setElement("MaintUserDR",curUserID);//modified by cjt 20221215 需求号3118651
	}
	//Modefied by zc0103 2021-06-02 计量信息导入 end
	$HUI.datagrid("#maintfinddatagrid",{   
	   	url:$URL, 
		idField:'TRowID', //主键
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
	        CurUser:getElementValue("PrivateFlag"),	// MZY0121	2022-04-15
	        TypeCode:'',
	        MaintIDs:getElementValue("MaintIDs")	//CZF0134 2021-02-23
		},
		//fitColumns:true,
		pagination:true,
    	columns:columns, 
	});
	//End By QW20181225 需求号:786608
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
			text: '新增'
		},{
			id: '1',
			text: '提交'
		},{
			id: '2',
			text: '审核'
		}],
		});
	}
	var TMaintDate=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintDate');
	var TMaintLoc=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintLoc');
	var TMaintMode=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintMode');
	var TMaintType=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintType');
	var TMaintUser=$('#maintfinddatagrid').datagrid('getColumnOption','TMaintUser');
	
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		TMaintDate.title='计量日期'
		TMaintLoc.title='计量科室'
		TMaintMode.title='计量方式'
		TMaintType.title='计量类型'
		TMaintUser.title='计量人'
	}
	else if (getElementValue("BussType")==1)
	{
		TMaintDate.title="保养日期"
		TMaintLoc.title='保养科室'
		TMaintMode.title='保养方式'
		TMaintType.title='保养类型'
		TMaintUser.title='保养人'
	}	
	else
	{
		TMaintDate.title='巡检日期'
		TMaintLoc.title='巡检科室'
		TMaintMode.title='巡检方式'
		TMaintType.title='巡检类型'
		TMaintUser.title='巡检人'
	}
	$('#maintfinddatagrid').datagrid();
	
	jQuery("#BColSet").linkbutton({iconCls: 'icon-w-config'});
	jQuery("#BColSet").on("click", BColSet_Clicked);
	jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-w-export'});
	jQuery("#BSaveExcel").on("click", BSaveExcel_Clicked);
}

function BColSet_Clicked()
{
	var para="&TableName=Maint&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)
}
// MZY0074	1839435		2021-04-30	修正Job取值
function BSaveExcel_Clicked()
{
	var rows = $("#maintfinddatagrid").datagrid('getRows');
	if (rows.length>0)
	{
    	var vData=GetLnk()
		PrintDHCEQEquipNew("Maint",1,rows[0].TJob,vData,"",100);
	}
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
	var height="";   //Modefied by zc0132 2023-03-15 初始化弹窗高度
	var model="large"  //Modefied by zc0132 2023-03-15 初始化弹窗大小
	//modify by lmm 2018-11-14 begin 748324
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR"); //modified by csj 20181211
		var title="计量记录";
		model="middle"   //Modefied by zc0132 2023-03-15 自定义弹窗大小
		height="10row" 	 //Modefied by zc0132 2023-03-15 自定义弹窗高度
	}
	else if (getElementValue("BussType")==1)
	{
		// MZY0078	1958704		2021-05-31
		//var url="dhceq.em.maint.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR"); //modified by csj 20181211
		//var title="保养记录"
		var url="dhceq.em.preventivemaint.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR");
		var title="预防性维护记录";
	}	
	else
	{
		var url="dhceq.em.inspect.csp?"+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR"); //modified by csj 20181211
		var title="巡检记录";
	}
	//modify by lmm 2020-05-09 1311841
	var width=""
	// MZY0082	1965403		2021-07-14
	//var height="11row"   //MODIFY BY LMM 2021-03-09 1775358
	//var height="";    //Modefied by zc0132 2023-03-15 初始化弹窗高度位置调整
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","",height);   //Modefied by zc0132 2023-03-15 自定义弹窗大小
	//modify by lmm 2018-11-14 end 748324
}
//Modified By QW20181225 需求号:786608
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
	        CurUser:getElementValue("PrivateFlag"),	// MZY0121	2022-04-15
	        TypeCode:'',
        MaintIDs:getElementValue("MaintIDs")	//CZF0134 2021-02-23
		    },
	});
}
///modify by lmm 2019-02-16 增加标题及弹窗尺寸
function mainplanOperation(value,row,index)
{
	var btn=""
	var height="710px"  //Modefied by zc0132 2023-03-15 初始化弹窗高度
	//modify by lmm 2020-05-26 1336941
		var para="&ReadOnly=1&BussType="+getElementValue("BussType")+"&SourceType=2&QXType=1&MaintLocDR="+row.TMaintLocDR+"&RowID="+row.TMaintPlanDR+"&ReadOnly=1"+"&EquipRangeDR="+row.TEquipRangeID;	//CZF0134 2021-02-23
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var url="dhceq.em.meterageplan.csp?";
		var title="计量计划"
	}
	else if (getElementValue("BussType")==1)
	{
		// MZY0082	1965403		2021-07-14	修正链接错误
		var url="dhceq.em.maintplan.csp?";
		//var title="保养计划"
		var title="预防性维护计划";
	}	
	else
	{
		var url="dhceq.em.inspectplan.csp?";
		var title="巡检计划"
		height="560px"  //Modefied by zc0132 2023-03-15 巡检重定义弹窗高度
	}	
		
		url=url+para;
		var icon="icon-w-paper"	 //modify by lmm 2018-11-14
		var type=""	 //modify by lmm 2018-11-14
		//modified by csj 20181128 需求号:762692
		//modify by lmm 2020-0202-06-05 UI
		btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#">'+row.TMaintPlan+'</A>';   //Modefied by zc0132 2023-03-15 修改弹窗高度
	return btn;
	
}
//Add By QW20181225 需求号:786608
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	//add hly 2019-10-14
	if(vElementID=="MaintType")
	{
		setElement("MaintType",item.TDesc);
	}
}
//Add By QW20181225 需求号:786608
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function mainOperation(value,row,index)
{
	var btn=""
	var height="";   //Modefied by zc0132 2023-03-15 初始化弹窗高度
	var model="large"  //Modefied by zc0132 2023-03-15 初始化弹窗大小
	//modify by lmm 2020-08-10
		var para="&BussType="+getElementValue("BussType")+"&EquipDR="+row.TEquipDR+"&RowID="+row.TRowID+"&CollectFlag="+getElementValue("CollectFlag");
		if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
		{
			var url="dhceq.em.meterage.csp?";
			var title="计量记录"
			model="middle"   //Modefied by zc0132 2023-03-15 自定义弹窗大小
			height="10row" 	 //Modefied by zc0132 2023-03-15 自定义弹窗高度
		}
		else if (getElementValue("BussType")==1)
		{
			// MZY0076	2021-05-25
			//var url="dhceq.em.maint.csp?";
			//var title="保养记录"
			var url="dhceq.em.preventivemaint.csp?";
			var title="预防性维护记录";
		}	
		else
		{
			var url="dhceq.em.inspect.csp?";
			var title="巡检记录"
		}	
		url=url+para;	
		var icon="icon-w-paper"
		var type=""
		btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+model+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>'; //Modefied by zc0132 2023-03-15 自定义弹窗大小
	return btn;
}

///add by czf 增加历史维护记录
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
		CurUser:getElementValue("PrivateFlag"),	// MZY0121	2022-04-15
		MaintTypeDR:MaintType
	},function(jsonData){
		if(jsonData.rows.length<1)
		{
			alertShow("没有历史维护记录");
			return;
		}
		else
		{
			var url="dhceq.em.mainthistorylist.csp?&MPType="+MPType+"&MaintType="+MaintType+"&EquipDR="+EquipDR;
			//modify by lmm 2020-06-03
			showWindow(url,"历史维护记录","","16row","icon-w-paper","modal","","","small") //modify by lmm 2020-06-05 UI
		}
	});
}
//Modefied by zc0103 2021-06-02 计量信息导入 
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
//Modefied by zc0103 2021-06-02 计量信息导入 
function BImport_Chrome()
{
	var RowInfo=websys_ReadExcel('');
	if ((RowInfo=="")||(RowInfo.length<=1))
	{
		alertShow("没有数据导入！")
		return 0;
	}
    var EquipIDs=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
	    var Col=0;  
		var	EquipID=""
		var EqNo=trim(RowInfo[Row-1][Col++]);   						//设备编号
		if (EqNo==undefined) EqNo=""
		var EqName=trim(RowInfo[Row-1][Col++]);							//设备名称
		if (EqName==undefined) EqName=""
		var UseLoc=trim(RowInfo[Row-1][Col++]);						//使用科室
		if (UseLoc==undefined) UseLoc=""
		var UseLocDR="";  
		var MaintLoc=trim(RowInfo[Row-1][Col++]);						//计量科室
		if (MaintLoc==undefined) MaintLoc=""
		var MaintLocDR="";  
		var MaintType=trim(RowInfo[Row-1][Col++]);						//计量方式
		if (MaintType==undefined) MaintType=""
		var MaintTypeDR=""
		var MaintDate=trim(RowInfo[Row-1][Col++]);						//计量日期
		if (MaintDate==undefined) MaintDate=""
		var CertificateNo=trim(RowInfo[Row-1][Col++]);					//计量证书号
		if (CertificateNo==undefined) CertificateNo=""
		var CertificateValidityNum=trim(RowInfo[Row-1][Col++]);	//计量有效期(月)
		if (CertificateValidityNum==undefined) CertificateValidityNum=""
		var MaintFee=trim(RowInfo[Row-1][Col++]);						//计量费用
		if (MaintFee==undefined) MaintFee=""
		if (EqNo=="")
		{
		    alertShow("第"+Row+"行"+"设备编号为空!");
		    return 0;
		}
		if (EqName=="")
		{
		    alertShow("第"+Row+"行"+"设备名称为空!");
		    return 0;
		}
		if (MaintDate=="")
		{
		    alertShow("第"+Row+"行"+"计量日期为空!");
		    return 0;
		}
		if (MaintType=="")
		{
		    alertShow("第"+Row+"行"+"计量类型为空!");
		    return 0;
		}
		if (CertificateValidityNum=="")
		{
		    alertShow("第"+Row+"行"+"计量有效期为空!");
		    return 0;
		}
		if (isNaN(CertificateValidityNum))
		{
		    alertShow("第"+Row+"行"+"计量有效期(月)不为数值!");
		    return 0;
		}
		var CertificateValidityDate=tkMakeServerCall("web.DHCEQCommon","DateAdd",'M',CertificateValidityNum,MaintDate);
		if (CertificateNo=="")
		{
		    alertShow("第"+Row+"行"+"计量证书号为空!");
		    return 0;
		}
		if (CertificateValidityDate=="")
		{
		    alertShow("第"+Row+"行"+"计量有效期为空!");
		    return 0;
		}
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",EqNo);
		if (EquipID=="")
		{
			alertShow("第"+Row+"行"+EqName+"不存在!");
		    return 1;
		}
		if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc);
			if (UseLocDR=="")
			{
				alertShow("第"+Row+"行 使用科室的信息不正确:"+MaintLoc);
				return 0;
			}
		}
		if (MaintLoc!="")
		{
			MaintLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",MaintLoc);
			if (MaintLocDR=="")
			{
				alertShow("第"+Row+"行 计量科室的信息不正确:"+MaintLoc);
				return 0;
			}
		}
		if (MaintType!="")
		{
			MaintTypeDR=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCMaintType",MaintType);
			if (MaintTypeDR=="")
			{
				alertShow("第"+Row+"行 计量科室的信息不正确:"+MaintType);
				return 0;
			}
		}
		var combindata="";	//1
		combindata="" ; //1
		combindata=combindata+"^"+EquipID ; //2
		combindata=combindata+"^"+getElementValue("BussType") ; //3
		combindata=combindata+"^"+"" ; //4
		combindata=combindata+"^"+MaintTypeDR; //5
		combindata=combindata+"^"+MaintDate ; //6
		combindata=combindata+"^"+MaintLocDR ; //7
		combindata=combindata+"^"+"" ; //8
		combindata=combindata+"^"+""; //9
		combindata=combindata+"^"+MaintFee ; //10
		combindata=combindata+"^"+"" ; //11
		combindata=combindata+"^"+"" ; //12
		combindata=combindata+"^"+UseLocDR ; //13
		combindata=combindata+"^"+"" ; //14
		combindata=combindata+"^"+"" ; //15
		combindata=combindata+"^"+MaintFee ; //16
		combindata=combindata+"^"+"" ; //17  Hold1改为合同  modify by lmm 2020-04-29 1279496
		combindata=combindata+"^"+"" ; //18
		combindata=combindata+"^"+"" ; //19
		combindata=combindata+"^"+""; //20
		combindata=combindata+"^"+"" ; //21
		combindata=combindata+"^"+"" ; //22
		combindata=combindata+"^"+"" ; //23
		combindata=combindata+"^"+"" ; //24
		combindata=combindata+"^"+"" ; //25
		combindata=combindata+"^"+"" ; //26
		combindata=combindata+"^"+""; //27
		combindata=combindata+"^"+"" ; //28
		combindata=combindata+"^"+"" ; //29
		combindata=combindata+"^"+"" ; //30
		combindata=combindata+"^"+"0" ; //31
		combindata=combindata+"^"+CertificateValidityDate ; //32
		combindata=combindata+"^"+CertificateNo ; //33	Mozy0193	20170817
		combindata=combindata+"^"+"" ; //34	add by csj 20191018 计划执行单ID
	}    
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SaveData",combindata,'1','1');
		
	if (Rtn<0) 
	{
		alertShow("第"+i+"行 <"+xlsheet.cells(i,4).text+"> 信息导入失败!!!请载剪该行信息重新整理后再次导入该行信息.");;
		return;	
	}
	else
	{
		var result = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SubmitData",Rtn,"",getElementValue("BussType"),EquipID,"","");
		if (result<0) 
		{
			alertShow("第"+i+"行 <"+xlsheet.cells(i,4).text+"> 信息导入导入成功需要手工提交该行信息.");;
			return;	
		}
	}
	alertShow("导入计量信息操作完成!请核对相关信息.");
	window.location.reload();

}
//Modefied by zc0103 2021-06-02 计量信息导入 
function BImport_IE()
{
	
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets(1);
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var	EquipID=""
		var EqNo=trim(xlsheet.cells(Row,Col++).text);     						//设备编号
		var EqName=trim(xlsheet.cells(Row,Col++).text);							//设备名称
		var UseLoc=trim(xlsheet.cells(Row,Col++).text);						//使用科室
		var UseLocDR="";  
		var MaintLoc=trim(xlsheet.cells(Row,Col++).text);						//计量科室
		var MaintLocDR="";  
		var MaintType=trim(xlsheet.cells(Row,Col++).text);						//计量方式
		var MaintTypeDR=""
		var MaintDate=trim(xlsheet.cells(Row,Col++).text);						//计量日期
		var CertificateNo=trim(xlsheet.cells(Row,Col++).text);					//计量证书号
		var CertificateValidityNum=trim(xlsheet.cells(Row,Col++).text);		//计量有效期(月)
		var MaintFee=trim(xlsheet.cells(Row,Col++).text);						//计量费用
		if (EqNo=="")
		{
		    alertShow("第"+Row+"行"+"设备编号为空!");
		    return 0;
		}
		if (EqName=="")
		{
		    alertShow("第"+Row+"行"+"设备名称为空!");
		    return 0;
		}
		if (MaintDate=="")
		{
		    alertShow("第"+Row+"行"+"计量日期为空!");
		    return 0;
		}
		if (MaintType=="")
		{
		    alertShow("第"+Row+"行"+"计量类型为空!");
		    return 0;
		}
		if (CertificateValidityNum=="")
		{
		    alertShow("第"+Row+"行"+"计量有效期为空!");
		    return 0;
		}
		if (isNaN(CertificateValidityNum))
		{
		    alertShow("第"+Row+"行"+"计量有效期(月)不为数值!");
		    return 0;
		}
		var CertificateValidityDate=tkMakeServerCall("web.DHCEQCommon","DateAdd",'M',CertificateValidityNum,MaintDate);
		if (CertificateNo=="")
		{
		    alertShow("第"+Row+"行"+"计量证书号为空!");
		    return 0;
		}
		if (CertificateValidityDate=="")
		{
		    alertShow("第"+Row+"行"+"计量有效期为空!");
		    return 0;
		}
		var EquipID=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",EqNo);
		if (EquipID=="")
		{
			alertShow("第"+Row+"行"+EqName+"不存在!");
		    return 1;
		}
		if (UseLoc!="")
		{
			UseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",UseLoc);
			if (UseLocDR=="")
			{
				alertShow("第"+Row+"行 使用科室的信息不正确:"+MaintLoc);
				return 0;
			}
		}
		if (MaintLoc!="")
		{
			MaintLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",MaintLoc);
			if (MaintLocDR=="")
			{
				alertShow("第"+Row+"行 计量科室的信息不正确:"+MaintLoc);
				return 0;
			}
		}
		if (MaintType!="")
		{
			MaintTypeDR=tkMakeServerCall("web.DHCEQCommonEX","GetIDByDesc","DHCEQCMaintType",MaintType);
			if (MaintTypeDR=="")
			{
				alertShow("第"+Row+"行 计量科室的信息不正确:"+MaintType);
				return 0;
			}
		}
		var combindata="";	//1
		combindata="" ; //1
		combindata=combindata+"^"+EquipID ; //2
		combindata=combindata+"^"+getElementValue("BussType") ; //3
		combindata=combindata+"^"+"" ; //4
		combindata=combindata+"^"+MaintTypeDR; //5
		combindata=combindata+"^"+MaintDate ; //6
		combindata=combindata+"^"+MaintLocDR ; //7
		combindata=combindata+"^"+"" ; //8
		combindata=combindata+"^"+""; //9
		combindata=combindata+"^"+MaintFee ; //10
		combindata=combindata+"^"+"" ; //11
		combindata=combindata+"^"+"" ; //12
		combindata=combindata+"^"+UseLocDR ; //13
		combindata=combindata+"^"+"" ; //14
		combindata=combindata+"^"+"" ; //15
		combindata=combindata+"^"+MaintFee ; //16
		combindata=combindata+"^"+"" ; //17  Hold1改为合同  modify by lmm 2020-04-29 1279496
		combindata=combindata+"^"+"" ; //18
		combindata=combindata+"^"+"" ; //19
		combindata=combindata+"^"+""; //20
		combindata=combindata+"^"+"" ; //21
		combindata=combindata+"^"+"" ; //22
		combindata=combindata+"^"+"" ; //23
		combindata=combindata+"^"+"" ; //24
		combindata=combindata+"^"+"" ; //25
		combindata=combindata+"^"+"" ; //26
		combindata=combindata+"^"+""; //27
		combindata=combindata+"^"+"" ; //28
		combindata=combindata+"^"+"" ; //29
		combindata=combindata+"^"+"" ; //30
		combindata=combindata+"^"+"0" ; //31
		combindata=combindata+"^"+CertificateValidityDate ; //32
		combindata=combindata+"^"+CertificateNo ; //33	Mozy0193	20170817
		combindata=combindata+"^"+"" ; //34	add by csj 20191018 计划执行单ID
	}
	xlsheet.Quit;
	xlsheet=null;
	xlBook.Close (savechanges=false);
	xlApp=null;
	
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SaveData",combindata,'1','1');
		
	if (Rtn<0) 
	{
		alertShow("第"+i+"行 <"+xlsheet.cells(i,4).text+"> 信息导入失败!!!请载剪该行信息重新整理后再次导入该行信息.");;
		return;	
	}
	else
	{
		var result = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SubmitData",Rtn,"",getElementValue("BussType"),EquipID,"","");
		if (result<0) 
		{
			alertShow("第"+i+"行 <"+xlsheet.cells(i,4).text+"> 信息导入导入成功需要手工提交该行信息.");;
			return;	
		}
	}
	alertShow("导入计量信息操作完成!请核对相关信息.");
	window.location.reload();
}

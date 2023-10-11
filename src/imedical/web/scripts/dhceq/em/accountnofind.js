var editFlag="undefined";
var SelectRowID="";
var Columns=getCurColumnsInfo('EM.G.AccountNo.AccountNoFind','','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage("inventory"); //获取所有业务消息
    initLookUp();
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"LocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("LocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	defindTitleStyle();
  	initButton();
  	initEvent();
  	setEnabled(); //按钮控制
    initButtonWidth();
	$HUI.datagrid("#tDHCEQAccountNoFind",{
	    url:$URL,
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSAccountNo",
	        	QueryName:"GetAccountNo",
				AccountNo:getElementValue("AccountNo"),
				LocDR:getElementValue("LocDR"),
				Status:getElementValue("Status"),
				ProviderDR:getElementValue("ANProviderDR"),
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate")
			},
			fitColumns: true,
			striped: false,
			rownumbers: true,  //如果为true则显示一个行号列
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			onLoadSuccess:function(){
			}
	});
}

function initEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj)
	{
		jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
		jQuery("#BAdd").on("click", BAdd_Clicked);
	}
	var obj=document.getElementById("BExport");
	if (obj)
	{
		jQuery("#BExport").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BExport").on("click", BExport_Clicked);
	}
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQAccountNoFind",{
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.EM.BUSAccountNo",
	        	QueryName:"GetAccountNo",
				AccountNo:getElementValue("AccountNo"),
				LocDR:getElementValue("LocDR"),
				Status:getElementValue("Status"),
				ProviderDR:getElementValue("ANProviderDR"),
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate")
			},
			rownumbers: true,  //如果为true则显示一个行号列
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}
function BAdd_Clicked()
{
	var url= 'dhceq.em.accountno.csp?';
	showWindow(url,"设备凭单新增","","","icon-w-paper","modal","","","large",refreshWindow)
}
function BExport_Clicked()
{
	var ObjTJob=$('#tDHCEQAccountNoFind').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"]) TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="") return;
	
	var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	var TotalRows=tkMakeServerCall("web.DHCEQ.EM.BUSAccountNo","GetOneAccountNoDetail",0,TJob);
	var PageRows=43;				//每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //总页数-1
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQAccountNoDetail.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows;
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows;
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows;
		    	}
	    	}
	    	xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"));
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
			    var OneDetail=tkMakeServerCall("web.DHCEQ.EM.BUSAccountNo","GetOneAccountNoDetail",l,TJob);
		    	var OneDetailList=OneDetail.split("^");
		    	//alert(OneDetail)
		    	//TRowID_"^"_TAccountNo_"^"_TAccountDate_"^"_TLoc_"^"_TProvider_"^"_TEquipType_"^"_TCheckDate_"^"_TTotalFee_"^"_TStatus_"^"_TRemark
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[1];
		    	xlsheet.cells(j,2)=OneDetailList[2];
		    	xlsheet.cells(j,3)=OneDetailList[3];
		    	xlsheet.cells(j,4)=OneDetailList[4];
		    	xlsheet.cells(j,5)=OneDetailList[5];
		    	xlsheet.cells(j,6)=OneDetailList[6];
		    	xlsheet.cells(j,7)=OneDetailList[7];
		    	xlsheet.cells(j,8)=OneDetailList[8];
		    	xlsheet.cells(j,9)=OneDetailList[9];
			}
			
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			xlsheet.cells(2,1)="时间范围:"+FormatDate(getElementValue("StartDate"))+"--"+FormatDate(getElementValue("EndDate"));
			xlsheet.cells(j+1,7)="制表人:";
			xlsheet.cells(j+1,8)=session['LOGON.USERNAME'];
	    	//xlsheet.printout; //打印输出
			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alert("操作完成.")
	} 
	catch(e)
	{
		alert(e.message);
	}
}
function setEnabled()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '4',text: '全部'},{id: '0',text: '新增'},{id: '2',text: '审核'},{id: '3',text: '作废'}],
		onSelect : function(){}
	});
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="LocDR_CTLOCDesc") {setElement("LocDR",rowData.TRowID)}
	else if(elementID=="ANProviderDR_VDesc") {setElement("ANProviderDR",rowData.TRowID)}
}
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}
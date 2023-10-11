//界面入口
jQuery(document).ready(function(){
	initDocument();
});
function initDocument()
{
	jQuery("input[name='combogrid']").each(function() { 
		var options=eval('(' + jQuery(this).attr("data-options") + ')');
		jQuery(this).initComboGrid(options);
	});
	jQuery("#BAdd").on("click", BAdd_Click);
	jQuery("#BFind").on("click", BFind_Click);
	jQuery("#BPrint").on("click", BPrintBar_Click);
	jQuery("#BExport").on("click", BExport_Click);
}

jQuery('#tDHCEQEquipFacilityFind').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		queryParams:{
			ClassName:"web.DHCEQEquip",
			QueryName:"GetEquipList",
			Arg1:'^FacilityFlag=1',
			Arg2:'',
			ArgCnt:2
			},
		fit:true,
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
    	columns:[[
    		{field:'TDetail',title:'详细',width:'5%',align:'center',formatter:equipDetail},
    		{field:'TRowID',title:'RowID',width:'3%',hidden:true},
        	{field:'TName',title:'设备名称',align:'center',width:'12%'},
        	{field:'TNo',title:'设备编号',align:'center',width:'10%'},
        	{field:'TUseLoc',title:'使用科室',align:'center',width:'12%'},
        	{field:'TModel',title:'规格型号',align:'center',width:'12%'},
        	{field:'TQuantity',title:'数量',align:'center',width:'5%'},
        	{field:'TOriginalFee',title:'原值',align:'center',width:'5%'},
        	{field:'TEquipType',title:'设备类组',align:'center',width:'8%'},
        	{field:'TProvider',title:'供货商',align:'center',width:'12%'},
        	{field:'TManuFactory',title:'生产厂商',align:'center',width:'12%'},
        	{field:'TFileNo',title:'档案编号',align:'center',width:'8%'},
    	]],
		onLoadSuccess:function(data){},
		onClickRow:function(rowIndex,rowData){},
		onLoadError: function(resullt) { messageShow("","","",JSON.stringify(resullt)) },//jQuery.messager.alert("错误", "加载列表错误.");},
		rowStyler:function(index,row){},
		pagination:true,
		pageSize:30,
		pageNumber:1,
		pageList:[10,20,30,40,50]
	});
function BAdd_Click()
{
	var url='dhceq.process.equipfacility.csp?rowid='
	OpenNewWindow(url);
}
function BFind_Click()
{
	jQuery('#tDHCEQEquipFacilityFind').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		queryParams:{
			ClassName:"web.DHCEQEquip",
			QueryName:"GetEquipList",
			Arg1:GetParams(),
			Arg2:'',
			ArgCnt:2
		}
	});
}

function GetParams()
{
	var Params="^No="+jQuery("#equipno").textbox("getValue");
	Params=Params+"^Name="+jQuery("#equipname").textbox("getValue");
	Params=Params+"^UseLocDR="+jQuery("#uselocdr").val();
	Params=Params+"^ProviderDR="+jQuery("#providerdr").val();
	Params=Params+"^EquipTypeDR="+jQuery("#equiptypedr").val();
	Params=Params+"^FileNo="+jQuery("#fileno").textbox("getValue");
	Params=Params+"^BeginTransAssetDate="+changeDateformat(jQuery('#benginstartdate').datebox("getText"));
	Params=Params+"^EndTransAssetDate="+changeDateformat(jQuery('#endstartdate').datebox("getText"));
	if (jQuery('#chk').is(':checked'))
  	{
	  	Params=Params+"^Chk=1";
	}
	Params=Params+"^FacilityFlag=1";
	return Params;
}
function equipDetail(rowIndex, rowData)
{
	if(rowData.TRowID!="")
	{
		var url="dhceq.process.equipfacility.csp?rowid="+rowData.TRowID;
		var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>';
		return btn;
	}
}
function changeDateformat(Date)
{
	if (Date=="") return "";
	var date=Date.split("-")
	var temp=date[2]+"/"+date[1]+"/"+date[0];   //日期格式变换
	return temp;
}
///打印条码
function BPrintBar_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPrintBarCode';
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=480,height=280,left=120,top=0')
}
///add by jyp 2018-06-15 
function BExport_Click()
{
	vData=GetParams();
	PrintDHCEQEquipNew("Equip","1","",vData,"",50);
}
  
///add by jyp 2018-06-15 
function  PrintDHCEQEquipNew(TableName,SaveOrPrint,job,vData,TempNode,GetRowsPerTime)
{
	window.clipboardData.clearData(); // Modified by QW 20170808  QW0007
	///Modified by jdl 2011-10-28 JDL0099
	if (!TempNode)
	{
		TempNode="";
	} 
	var num=tkMakeServerCall("web.DHCEQEquipSave","GetNum","","")
	
	if (num<=1) {alertShow("表没值")}
	else
	{
     try {
	     if (SaveOrPrint=="1")
	     {
		     var FileName=GetFileName();
		     if (FileName=="") {return;}
	     }
      	var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");

		var	colsets=tkMakeServerCall("web.DHCEQCColSet","GetColSets","","2","",TableName); //用户级设置
		if (colsets=="")
		{
			var	colsets=tkMakeServerCall("web.DHCEQCColSet","GetColSets","","1","",TableName); //安全组级设置
			if (colsets=="")
			{
				var	colsets=tkMakeServerCall("web.DHCEQCColSet","GetColSets","","0","",TableName); //系统设置
			}
		}
		if (colsets=="")
		{
			alertShow("导出数据列未设置!")
			return
		}
		var colsetlist=colsets.split("&");
		var colname=new Array()
		var colcaption=new Array()
		var colposition=new Array()
		var colformat=new Array()
		var colwidth=new Array()
		var cols=colsetlist.length
		for (i=0;i<cols;i++)
		{
			var colsetinfo=colsetlist[i].split("^");
			colcaption[i]=colsetinfo[1];
			colname[i]=colsetinfo[2];
			colposition[i]=colsetinfo[3];
			colformat[i]=colsetinfo[4];
			colwidth[i]=colsetinfo[5];
		}
			
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQBlank.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet
	    //获取表头信息
	    var TitleInfo=tkMakeServerCall("web.DHCEQCommon","GetTitleInfo","Equip");
	    var TitleRow=0
	    if (TitleInfo!="")
	    {
		    TitleInfo=TitleInfo.split("@")
		    TitleRow=TitleInfo[0]*1
		    var ParaInfo=TitleInfo[1].split("&")
		    for (i=1;i<=TitleRow;i++)
		    {
			    xlsheet.Range(xlsheet.Cells(i,1),xlsheet.Cells(i,cols)).MergeCells = true;
			    xlsheet.cells(i,1)=ParaInfo[i-1]
		    }
		    if (TitleRow>0)
		    {
			    xlsheet.cells(1,1).Font.Bold = true;
			    xlsheet.cells(1,1).Font.Size = 20;
			    xlsheet.cells(1,1).EntireRow.AutoFit
			    xlsheet.cells(1,1).HorizontalAlignment = 3;
			    xlsheet.PageSetup.PrintTitleRows ="$1:$"+(TitleRow+1)
		    }
		    ParameterReplace(xlsheet,vData)
	    }
	    else
	    {
		    xlsheet.PageSetup.PrintTitleRows ="$1:$1"
	    }
	    xlsheet.PageSetup.LeftFooter="制表人:"+curUserName
	    xlsheet.PageSetup.RightFooter="第&P页(共&N页)"
	    //
	    for (i=0;i<cols;i++)
	    {
		    xlsheet.cells(TitleRow+1,i+1)=colcaption[i];
	    	if (colwidth[i]!="")
	    	{
		    	xlsheet.Columns(i+1).ColumnWidth =colwidth[i];
	    	}
		}
	    num=parseFloat(num);
	    
	    ///Modified by jdl 2011-10-28 JDL0099  web.DHCEQEquipSave GetList
	    /// Modified by jdl 2013-7-16 JDL0133 优化台帐导出效率?增加参数每次获取行数信息
	    var splitChar=String.fromCharCode(2);
	    var endRow;
	    
	    for (Row=1;Row<=num;Row++)
	    { 
	   		var list=document.getElementById('GetList');
		 	if (list) {var encmeth=list.value} else {var encmeth=''};
		 	
		 	/// Modified by jdl 2013-7-16 JDL0133 优化台帐导出效率?增加参数每次获取行数信息
		 	if (!GetRowsPerTime)
		 	{	endRow=Row;	}
		 	else
			{	endRow=Row+GetRowsPerTime-1;	}
			if (endRow>num) endRow=num;
			var rowsCount=endRow-Row+1;
			var strConcat="";
			var strArr=new Array();
			var beginRow=Row;
			var fieldVal;
		
		 	///Modified by jdl 2011-10-28 JDL0099
		 	if (!GetRowsPerTime)
		 	{
			 	var str=tkMakeServerCall("web.DHCEQEquipSave","GetList",TempNode,job,Row);
		 	}
		 	else
		 	{
				var str=tkMakeServerCall("web.DHCEQEquipSave","GetList",TempNode,job,Row,rowsCount)
		 	}
			var rowVal=str.split(splitChar);
			
			for (j=0;j<rowsCount;j++)
			{
				//if ((Row>430)&(Row<450)) messageShow("","","",j+"&"+rowVal[j]+String.fromCharCode(67));			
				var List=rowVal[j].split("^");
				//xlsheet.Rows(Row+TitleRow+1).Insert()
		    	var strLine=""
		    	for (i=1;i<=cols;i++)
		    	{
			    	var position=colposition[i-1];
			    	if (position>0)
			    	{	position=position-1;}
			    	else
			    	{	position=0}
			    	
			    	fieldVal=List[position];
			    	if (colformat[i-1]==2)
				    {
					   	if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "0.00_ ";
					}
					else if (colformat[i-1]==4)
					{
					    if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "@";
					}
				    else if (colformat[i-1]!="")
				    {
				    	fieldVal=ColFormat(fieldVal,colformat[i-1]);
				    }
				    fieldVal=fieldVal.replace(/\t/g," ");
				    fieldVal=fieldVal.replace(/\r\n/g," ");
				    strLine=strLine+fieldVal;
				    if (i<cols) strLine=strLine+"\t";
		    	}
		    	if (j!=0) strLine="\r"+strLine;
		    	strArr.push(strLine);
		    	if (Row<endRow) Row++;
			}
	     	strConcat=String.prototype.concat.apply("",strArr);
	     	xlsheet.Cells(beginRow+TitleRow+1,1).Select();
		 	window.clipboardData.setData("Text",strConcat);
		 	xlsheet.Paste();
			
	    	/*	
			for (i=1;i<=cols;i++)
	    	{
		    	var position=colposition[i-1];
		    	if (position>0)
		    	{	position=position-1;}
		    	else
		    	{	position=0}
		    	
		    	//if (Row==1) messageShow("","","",position+"&"+List[position]);
		    	if (colformat[i-1]!="")
		    	{
			    	if (colformat[i-1]==2)
			    	{
				    	if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "0.00_ ";
				    	xlsheet.cells(Row+TitleRow+1,i)=List[position];
				    }
				    else if (colformat[i-1]==4)
				    {
					    if (Row==1) xlsheet.Range(xlsheet.Cells(2+TitleRow,i),xlsheet.Cells(num+TitleRow+1,i)).NumberFormatLocal = "@";
					    xlsheet.cells(Row+TitleRow+1,i)=List[position];
					}
			    	else
			    	{
			    		xlsheet.cells(Row+TitleRow+1,i)=ColFormat(List[position],colformat[i-1]);
			    	}
		    	}
		    	else
		    	{
		    		xlsheet.cells(Row+TitleRow+1,i)=List[position];
		    	}
			}	
			*/		
			
	     }
	     
	     if (SaveOrPrint=="1")
	     {
		     xlBook.SaveAs(FileName);
	     }
	     else
	     {
		     xlsheet.printout; //打印输出
	     }
	    
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    if (SaveOrPrint=="1")
	    {
		    alertShow("导出完成!");
	    }
	    } 
	catch(e)
	 {
		messageShow("","","",e.message);
	 }
	}
}
///add by jyp 2018-06-15 
function ParameterReplace(xlsheet,vData)
{
	var Find=xlsheet.cells.find("[Hospital]")
	var Hospital=tkMakeServerCall("web.DHCEQCommon","GetHospitalDesc")
	if (Find!=null) {xlsheet.cells.replace("[Hospital]",Hospital)}
	
	var vInfo=vData.split("^")
	var vCount=vInfo.length
	var vCurInfo=""
	for (var i=1;i<vCount;i++)
	{
		vCurInfo=vInfo[i].split("=")
		Find=xlsheet.cells.find("["+vCurInfo[0]+"]")
		if (Find!=null)
		{
			xlsheet.cells.replace("["+vCurInfo[0]+"]",vCurInfo[1])
		}
	}
}
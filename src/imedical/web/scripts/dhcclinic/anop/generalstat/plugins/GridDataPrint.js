function InitGridPrint(obj)
{
	function PrintAllAnOpList()
	{
		var operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var row=1;
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add();
		xlsSheet = xlsBook.ActiveSheet;
		//var count=obj.retGridPanelStore.totalLength; //数据总数
		var count=Number(obj._DHCANOPStat.GetInquiryResultCount(obj.anciId,obj.historySeq));
		var sumType=obj.comRetSumType.getValue();
		var columnModel=obj.retGridPanel.getColumnModel();
		var cols=columnModel.getColumnCount();//显示列数
		
		//打印表头
		xlsSheet.Range(xlsSheet.Cells(row, 1), xlsSheet.Cells(row,cols-2)).Font.Size = 16;
		xlsSheet.Range(xlsSheet.Cells(row, 1), xlsSheet.Cells(row,cols-2)).MergeCells = 1;
		xlsSheet.Range(xlsSheet.Cells(row, 1), xlsSheet.Cells(row,cols-2)).HorizontalAlignment =-4108;
		var index = obj.comInquiryStore.indexOfId(obj.anciId);
		var record = obj.comInquiryStore.getAt(index);
		xlsSheet.cells(row,1)=record.get("ANCIDesc");
		row++;
		var dateTitleStr="";
		if(obj.chkDateTypeOP.getValue()) dateTitleStr=obj.chkDateTypeOP.fieldLabel;
		if(obj.chkDateTypeAdm.getValue()) dateTitleStr=obj.chkDateTypeAdm.fieldLabel;
		if(obj.chkDateTypeDischarge.getValue()) dateTitleStr=obj.chkDateTypeDischarge.fieldLabel;
		dateTitleStr = dateTitleStr+":  "+obj.itemDateFrm.getRawValue()+"  到  "+obj.itemDateTo.getRawValue();
		xlsSheet.Range(xlsSheet.Cells(row, 1), xlsSheet.Cells(row,cols-2)).Font.Size = 14;
		xlsSheet.Range(xlsSheet.Cells(row, 1), xlsSheet.Cells(row,cols-2)).MergeCells = 1;
		xlsSheet.cells(row,1)=dateTitleStr;
		row++;
		
		for(var j=2;j<cols;j++)
		{
			var colName=columnModel.getDataIndex(j);
			var colVal=columnModel.getColumnHeader(j);
			var colWidth=columnModel.getColumnWidth(j);
			colWidth = colWidth/10;
			xlsSheet.Columns(j-1).ColumnWidth = colWidth;
			if(colVal)
			{
				xlsSheet.cells(row,j-1)=colVal;
			}
			else xlsSheet.cells(row,j-1)="";
		}
		xlsSheet.Range(xlsSheet.Cells(row,1), xlsSheet.Cells(row,cols-2)).Borders.Weight = 2;
		xlsSheet.Range(xlsSheet.Cells(row,1), xlsSheet.Cells(row,cols-2)).Borders.LineStyle = 1;
		
		xlsSheet.Range(xlsSheet.Cells(row+1,1), xlsSheet.Cells(row+count,cols-2)).Borders.Weight = 1;
		xlsSheet.Range(xlsSheet.Cells(row+1,1), xlsSheet.Cells(row+count,cols-2)).Borders.LineStyle = 1;
		for (var i=0;i<count;i++)
		{
			var chk=""
			var data=obj._DHCANOPStat.GetSingleInquiryResult(obj.anciId,i+1,sumType,obj.historySeq);
			data=eval('('+data+')');
			row=row+1;
			for(var j=2;j<cols;j++)
			{
				var colName=columnModel.getDataIndex(j);
				var colVal=data[colName];
				if(colVal)
				{
					if(colVal.indexOf("ShowOpaInfo")>-1)
					{
						colVal = GetOpaInfo(colVal);
					}
					else if(colVal.indexOf(">")>-1)
					{
						colVal = colVal.split(">")[1].split("<")[0];
					}
					xlsSheet.cells(row,j-1)=colVal;
				}
				else xlsSheet.cells(row,j-1)="";
			}
		}
		xlsExcel.Visible = true;
		//xlsSheet.PrintPreview;
		//xlsSheet.PrintOut(); 
	}
	function GetOpaInfo(link)
	{
		var idStr=link.split("ShowOpaInfo(")[1].split(")")[0];
		var idArr=idStr.split(",");
		if(idArr.length<4) return "";
		return obj._DHCANOPStat.GetOpaInfo(idArr[0],idArr[1],idArr[2],idArr[3]);
	}

	obj.menuItemPrintResult.on('click',function(){
			if(!obj.CheckSelectInquiry()) return;
			obj.ResetStartEndDate();
			PrintAllAnOpList();
		},obj);

	obj.menuItemPrintToHtml.on("click",function(){
			if(!obj.CheckSelectInquiry()) return;
			obj.ResetStartEndDate();
			var anciDesc = obj.comInquiry.getRawValue();
			var lnk = "dhcclinic.anop.statshow.csp?anciId="+obj.anciId+"&sumType="+obj.comRetSumType.getValue()+"&showZero="+(obj.chkShowZero.getValue()?1:0)+"&title="+escape("[请通过复制粘贴的方式自行导出]   手术综合查询: "+anciDesc);
			window.open(lnk,"","height=600,width=900,toolbar=no,menubar=no,scrollbars=yes,resizable=yes");
		},obj);
}
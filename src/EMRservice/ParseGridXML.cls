/// Creator:    yn
/// Desc       	解析grid xml
Class EMRservice.ParseGridXML Extends EMRservice.BLBSParseXML
{

Parameter FONTSIZE = "10.5pt";

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      拼接html文档
/// Out      	全局样式
/// Debug:     
ClassMethod initStyle(styleS)
{
	s pageStyle = ".page-style{padding: 1cm;margin: 0 auto;border: 1px #D3D3D3 solid;border-radius: 5px;background: white;box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);margin-bottom: 5px;}"
	s gridTable = ".page-gridtable{ width: 100%;min-height: 100%;table-layout: fixed;} "
	//.page-gridtable,.page-gridtable td{border:1px solid rgba(255,0,0,0.1);}
	d styleS.Write("*{font-family:宋体;font-size:"_..#FONTSIZE_";} p{margin:0px;}")
	d styleS.Write(pageStyle)
	d styleS.Write(gridTable)
}

/// Creator:    yn
/// CreateDate: 2023-04-13
/// Input:      病历xml的流数据
/// Out      	grid的媒体数据
/// Desc       	将媒体数据放在数组中并返回
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).GetMediasArry()
ClassMethod GetMediasArry(document)
{
	s res = ##Class(%ArrayOfDataTypes).%New()
	s sc = document.EvaluateExpression("/Document/StructuredBody/Medias","count(Media)",.totalList)
	if ($$$ERROR(sc)){
		q res
	}
	s total = totalList.GetAt(1).Value
	for i=1:1:total{
		s sc = document.EvaluateExpression("/Document/StructuredBody/Medias","Media["_i_"]/@ID",.IDList)
		s ID = IDList.GetAt(1).Value
		s sc = document.EvaluateExpression("/Document/StructuredBody/Medias","Media["_i_"]/Resource/text()",.dataList)
		s data = dataList.GetAt(1).Value
		d res.SetAt(data,ID)
	}
	q res
}

/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      
/// Out      	全局样式
/// Desc 		解析失败时显示空白a4纸
/// Debug:     
ClassMethod initErrorPage(res)
{
	s styleHtml = "<style>.page-style{width:210mm;height:297mm;padding: 1cm;margin: 0 auto;border: 1px #D3D3D3 solid;border-radius: 5px;background: white;box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);margin-bottom: 5px;}</style>"
	d res.Write("<!DOCTYPE html><html>")
	d res.Write("<head><meta  charset=""utf-8"" /><title >电子病历</title>"_styleHtml_"</head>")
	d res.Write("<body>")
	d res.Write("<div class=""page-style""></div>")
	d res.Write("</body>")
	d res.Write("</html>")
}

/// Creator:    yn
/// CreateDate: 2022-09-21
/// Input:      病历xml流数据，AInstanceId：实例ID
/// Out      	病历xml异常返回"" 正常返回html流
/// Desc       	对病历xml节点进行遍历，获取所需要的header以及section部分并处理获得最终的html流
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).handleGridXmlByXPath()
ClassMethod handleGridXmlByXPath(xmlStream, AInstanceId, htmlResArry) As %GlobalBinaryStream
{
	s $zt = "Error"
	s resErrorPage = ##class(%GlobalBinaryStream).%New()
	s htmlS = ##class(%GlobalBinaryStream).%New()
	s styleS = ##class(%GlobalBinaryStream).%New()
	s bodyS = ##class(%GlobalBinaryStream).%New()
	//定义纸张样式
	d ..initStyle(styleS)
	//定义出错时返回的html
	d ..initErrorPage(resErrorPage)
	
	s sc = ##class(%XML.XPATH.Document).CreateFromStream(xmlStream,.document)
	if ($$$ERROR(sc)) {
		d:htmlResArry'="" htmlResArry.SetAt("-1^xml文档解析失败","resDesc")
		q resErrorPage
	}
	//初始化style以及head->style->pagesize
	s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","PrintSetup",.PrintSetup)
	if ($$$ERROR(sc)){
		d:htmlResArry'="" htmlResArry.SetAt("-1^xml文档解析失败","resDesc")
		q resErrorPage
	}
	d ..handleGridPageSize(styleS,PrintSetup)
	s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","count(Sheets/Sheet)",.SheetNumObj)
	if ($$$ERROR(sc)){
		d:htmlResArry'="" htmlResArry.SetAt("-1^xml文档解析失败","resDesc")
		q resErrorPage
	}
	s mediasArry = ..GetMediasArry(document)
	//sheet的个数
	s sheetNum = $case(SheetNumObj.Count(),0:0,:SheetNumObj.GetAt(1).Value)
	s docArray = ##Class(%Library.ArrayOfDataTypes).%New()

	//对cell进行处理
	for i=1:1:sheetNum{
		s sheetArray = ##Class(%Library.ArrayOfDataTypes).%New()
		s temp = ##Class(%Library.ArrayOfDataTypes).%New()
		//获取sheet大小信息
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_i_"]/@Rows",.SheetRows)	
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_i_"]/@Columns",.SheetColumns)
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_i_"]/@CellHeight",.CellHeight)
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_i_"]/@CellWidth",.CellWidth)
		//生成整体的table
		s SheetRows = SheetRows.GetAt(1).Value
		s SheetColumns = SheetColumns.GetAt(1).Value
		s CellHeight = CellHeight.GetAt(1).Value
		s CellWidth = CellWidth.GetAt(1).Value
		for iRow=1:1:(SheetRows+1){
			s itemArry = ##Class(%Library.ArrayOfDataTypes).%New()
			d sheetArray.SetAt(itemArry,iRow)
			for jCol=1:1:(SheetColumns+1){
				d sheetArray.GetAt(iRow).SetAt("[td]",jCol)
			}
		}
		//预处理划线
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor/Sheets","Sheet["_sheetNum_"]/Lines/@Version",.Version)
		if (Version.Count()=0){
				//合并cell
				//s lineArry = ..ClearLine(document, i)
				d ..handleVersionTableShow(document, i,CellHeight, sheetArray)
				d ..handleDrawTypeLine(document, i, sheetArray,SheetRows,SheetColumns)				
				/*方式1
				//对线进行处理偶数个不画奇数个画
				s lineArry = ..ClearLine(document, i)
				//合并cell
				d ..handleTableShow(document, i,CellHeight, sheetArray,SheetRows,SheetColumns)	
				//划线，画所有的线
				d ..handleCommonLine(document, lineArry,sheetArray)
				//划handleCommonLine中对重新赋值掉的线
				d ..handleOffSetLine(document, lineArry, sheetArray)
				*/
			}else{
				//合并cell
				d ..handleVersionTableShow(document, i,CellHeight, sheetArray)	
				//处理划线
				d ..handleTableLine(document, i, sheetArray,SheetRows,SheetColumns)	
			}
		d docArray.SetAt(sheetArray,i)
	}
	//生成html table结构
	d ..handleGridSheetCell(bodyS,docArray,mediasArry)
	//d ..WriteArry(docArray) //调试程序使用
	d ..concatHtml(htmlS,styleS,bodyS)
	q htmlS
Error
	d:htmlResArry'="" htmlResArry.SetAt("-1^handleGridXmlByXPath发生异常"_$zerror,"resDesc")
	q resErrorPage
}

/// Creator:    yn
/// CreateDate: 2020-09-12
/// Input:      拼接html文档
/// Out      	病历html
/// Debug:      w ##Class(EMRservice.BLBSParseXML).concatHtml("270||8")
ClassMethod concatHtml(htmlS As %GlobalBinaryStream, styleS As %GlobalBinaryStream, bodyS As %GlobalBinaryStream)
{
	d styleS.Rewind()
	s styleHtml = "<style>"_styleS.Read()_"</style>"
	d htmlS.Write("<!DOCTYPE html><html>")
	d htmlS.Write("<head><meta  charset=""utf-8"" /><title >电子病历</title>"_styleHtml_"</head>")
	d htmlS.Write("<body style=""margin:0"">")
	d bodyS.Rewind()
	while (bodyS.AtEnd = 0)
	{
		d htmlS.Write(bodyS.Read(32000))
	}
	d htmlS.Write("</body>")
	d htmlS.Write("</html>")
}

/// Creator:    yn
/// CreateDate: 2023-1-16
/// Input:      对线进行处理
/// Out      	
/// Debug:      w ##Class(EMRservice.BLBSParseXML).ClearLine()
ClassMethod ClearLine(document, sheetNum)
{
	s lineArry = ##Class(%Library.ArrayOfDataTypes).%New()
	s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor/Sheets","count(Sheet["_sheetNum_"]/Lines/Line)",.LineNum)
	s LineNum = LineNum.GetAt(1).Value
	for i=1:1:LineNum{
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_sheetNum_"]/Lines/Line["_i_"]",.LineItemObj) 
		s LineItemObj = LineItemObj.GetAt(1)
		s item = ..GetGridKeyValue(LineItemObj)	
		s StartRow = +item.GetAt("StartRow")
		s StartCol = +item.GetAt("StartCol")
		s EndRow = +item.GetAt("EndRow")
		s EndCol = +item.GetAt("EndCol")	
		s DrawType = $replace(item.GetAt("DrawType")," ","")
		s lineKey = StartRow_"^"_StartCol_"^"_EndRow_"^"_EndCol_"^"_DrawType
		if (lineArry.GetAt(lineKey)'=""){
			d lineArry.SetAt("",lineKey)
			}else{
			d lineArry.SetAt(1,lineKey)	
			}
	}
	q lineArry
}

/// Creator:    yn
/// CreateDate: 2022-10-10
/// Input:      只合并单元格，以及记录当前单元格被谁合并
/// Out      	
/// Debug:      w ##Class(EMRservice.BLBSParseXML).handleTableShow()
ClassMethod handleVersionTableShow(document, i, CellHeight, sheetArray)
{
	//处理cell	
	s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","count(Sheets/Sheet["_i_"]/Cell)",.SheetCellNumObj)	
	s SheetCellNum = SheetCellNumObj.GetAt(1).Value
	for j=1:1:SheetCellNum{
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_i_"]/Cell["_j_"]",.CellObj)	
		s tResult = CellObj.GetAt(1)
		s row = "",col="",colspan="",rowspan="",cellStr = ""
		while(tResult.Read()){
            If tResult.NodeType="element"
            {  
                if tResult.HasAttributes {
                    For tJ=1:1:tResult.AttributeCount
                    {
                        Do tResult.MoveToAttributeIndex(tJ)
                    	s:tResult.Name="Row" row=+tResult.Value+1 //cell row坐标+1
                    	s:tResult.Name="Col" col=+tResult.Value+1 //cell col坐标+1
                    	s:tResult.Name="Rows" rowspan=tResult.Value 
                    	s:tResult.Name="Columns" cospan=tResult.Value   
                  		s cellStr = cellStr_tResult.Name_":"_tResult.Value_";"                                       
                    }
                }
            }				
		}
		s cellStr = cellStr_"height:"_CellHeight_"px;"
		s showCell = "merge^"_row_","_col //当前单元格被showCell合并
		//处理影响当前行合并的列
		s startCol = col+1
		s endCol = col+cospan-1
		for jC=startCol:1:endCol{
			d sheetArray.GetAt(row).SetAt(showCell,jC)
			}
		//处理影响合并行的列
		s startRow = row+1
		s startCol = col
		s endCol = col+cospan-1
		s endRow = row+rowspan-1
		for kC=startRow:1:endRow{	  
		  for jC=startCol:1:endCol{
		    d sheetArray.GetAt(kC).SetAt(showCell,jC)
		  }
		}
		
		d sheetArray.GetAt(row).SetAt(cellStr,col)
	}
}

/// Creator:    yn
/// CreateDate: 2023-01-15
/// Input:      
/// Out      	处理掉对冲的线
/// Debug:      w ##Class(EMRservice.BLBSParseXML).handleTableShow()
ClassMethod handleOffSetLine(document, lineArry, sheetArray)
{
	s total = lineArry.Count()
	q:total=0
	s lineKey = ""
	for i=1:1:total{
		s lineKey = lineArry.Next(lineKey)
		s StartRow = +$p(lineKey,"^",1)
		s StartCol = +$p(lineKey,"^",2)
		s EndRow = +$p(lineKey,"^",3)
		s EndCol = +$p(lineKey,"^",4)
		s DrawType = +$p(lineKey,"^",5)
		continue:lineArry.GetAt(lineKey)=""
		s pointRow = StartRow+1
		s pointCol = StartCol+1 
		s value = sheetArray.GetAt(pointRow).GetAt(pointCol)
		if (value'["|"){
			s value = value_"|"
		}
		//画某一条线所经历的单元格
		d $case(+DrawType
			,0:toggleTopLine
			,1:toggleBottomLine
			,3:toggleRightLine
			,4:toggleAll
			,:defalut
			)
	}
	q
	//画合并单元格的线
toggleTopLine
	//画上线
	if (value'["^Top"){
		d sheetArray.GetAt(pointRow).SetAt(value_"^Top",pointCol)
	}
	q
toggleBottomLine
	//下线
	if (value'["^Bottom"){
		d sheetArray.GetAt(pointRow).SetAt(value_"^Bottom",pointCol)
	}	
	q
toggleRightLine
	//右线
	//获取元素信息
	s cellArry = ..GetKeyValue(value)
	s lineEnd = EndRow+1
	s cellEnd = +cellArry.GetAt("Row")+cellArry.GetAt("Rows")
	s lineStart = StartRow+1
	s cellStart = +cellArry.GetAt("Row")+1
	if (value'["^Right"){
		if ((lineEnd=cellEnd)&&(lineStart=cellStart)){
			d sheetArray.GetAt(pointRow).SetAt(value_"^Right",pointCol)
		}
	}
	q	
toggleAll
	if (value'["^All"){
		d sheetArray.GetAt(pointRow).SetAt(value_"^All",pointCol)
	}
	q		
defalut
	q
}

/// Creator:    yn
/// CreateDate: 2022-10-10
/// Input:      
/// Out      	处理table画线通用方法，包含lines version2.0与lines 非2.0
/// Debug:      w ##Class(EMRservice.BLBSParseXML).handleTableShow()
ClassMethod handleCommonLine(document, lineArry, sheetArray)
{
	//对lineArry进行划线
	s total = lineArry.Count()
	q:total=0
	s lineKey = ""
	for i=1:1:total{
		s lineKey = lineArry.Next(lineKey)
		s StartRow = $p(lineKey,"^",1)
		s StartCol = $p(lineKey,"^",2)
		s EndRow = $p(lineKey,"^",3)
		s EndCol = $p(lineKey,"^",4)
		s DrawType = $p(lineKey,"^",5)
		continue:(lineArry.GetAt(lineKey)="")
		//画某一条线所经历的单元格
		d $case(+DrawType
			,0:toggleTopLine
			,1:toggleBottomLine
			,2:toggleLeftLine
			,3:toggleRightLine
			,:defalut
			)
		
	}	
	q
	//画合并单元格的线
toggleTopLine
	//画上线
	s fixRow = StartRow+1
	s startColPoint = StartCol+1
	s endColPoint = EndCol+1
	for topI=startColPoint:1:endColPoint{
		s value = sheetArray.GetAt(fixRow).GetAt(topI)
		if (value'["|"){
			s value = value_"|"
			}
		if (value'["^Top"){
			d sheetArray.GetAt(fixRow).SetAt(value_"^Top",topI)
			}else{
			s newValue = $replace(value,"^Top","")	
			d sheetArray.GetAt(fixRow).SetAt(newValue,topI)
			}
	}
	q
toggleBottomLine
	//下线
	s fixRow = EndRow+1
	s startColPoint = StartCol+1
	s endColPoint = EndCol+1
	for BottomI=startColPoint:1:endColPoint{
		s value = sheetArray.GetAt(fixRow).GetAt(BottomI)
		if (value'["|"){
			s value = value_"|"
			}
		if (value'["^Bottom"){
			d sheetArray.GetAt(fixRow).SetAt(value_"^Bottom",BottomI)
			}else{
			s newValue = $replace(value,"^Bottom","")	
			d sheetArray.GetAt(fixRow).SetAt(newValue,BottomI)
			}
	}	
	q
toggleLeftLine
	//左线
	s fixCol = StartCol+1
	s startRowPoint = StartRow+1
	s endRowPoint = EndRow+1
	for LeftI=startRowPoint:1:endRowPoint{
		s value = sheetArray.GetAt(LeftI).GetAt(fixCol)
		if (value'["|"){
			s value = value_"|"
			}
		if (value'["^Left"){
			d sheetArray.GetAt(LeftI).SetAt(value_"^Left",fixCol)
			}else{
			s newValue = $replace(value,"^Left","")	
			d sheetArray.GetAt(LeftI).SetAt(newValue,fixCol)
			}
	}
	q
toggleRightLine
	//右线
	s fixCol = EndCol+1
	s startRowPoint = StartRow+1
	s endRowPoint = EndRow+1
	for RightI=startRowPoint:1:endRowPoint{
		s value = sheetArray.GetAt(RightI).GetAt(fixCol)
		if (value'["|"){
			s value = value_"|"
			}
		if (value'["^Right"){
			d sheetArray.GetAt(RightI).SetAt(value_"^Right",fixCol)
			}else{
			s newValue = $replace(value,"^Right","")	
			d sheetArray.GetAt(RightI).SetAt(newValue,fixCol)
			}
	}	
	q
defalut
	q
}

/// Creator:    yn 
/// CreateDate: 2023-04-27
/// modify: 2023-04-27
/// Input:      
/// Out：处理带drawType的划线
/// Debug:w ##Class(EMRservice.BLBSParseXML).drawTypeCross(sheetArray, SheetRows, initStartRow, initEndRow, initStartCol, initEndCol, drawType)
ClassMethod drawTypeVertical(sheetArray, SheetColumns, StartRow, EndRow, LineCol, Atype)
{
	if ((LineCol'=0)&&(LineCol<=SheetColumns)){
		//画竖线;
			for kRow=StartRow:1:EndRow{
				s value = sheetArray.GetAt(kRow).GetAt(LineCol)
				if (value["merge"){
					//获取合并单元格的坐标
					s showCell = $p(value,"^",2)
					s rSite = $p(showCell,",",1)
					s cSite = $p(showCell,",",2)
					s cellVale = sheetArray.GetAt(rSite).GetAt(cSite)
					if (cellVale'[("^"_Atype)){
						s:cellVale'["|" cellVale = cellVale_"|"
						d sheetArray.GetAt(rSite).SetAt(cellVale_"^"_Atype,cSite)
					}
				}else{
					if (value'[("^"_Atype)){
						s:(value'["|") value = value_"|"
						d sheetArray.GetAt(kRow).SetAt(value_"^"_Atype,LineCol)
					}						
				}
			}
		}
}

/// Creator:    yn 
/// CreateDate: 2023-04-27
/// modify: 2023-04-27
/// Input:      
/// Out：处理带drawType的划线
/// Debug:w ##Class(EMRservice.BLBSParseXML).drawTypeCross(sheetArray, SheetRows, initStartRow, initEndRow, initStartCol, initEndCol, drawType)
ClassMethod drawTypeCross(sheetArray, SheetRows, StartRow, EndRow, StartCol, EndCol, Atype)
{
	
	if ((StartRow=EndRow)&&(StartRow'=0)&&(StartRow<=SheetRows)){
		//画横线：bottom 线所描述的单元格都应画下线
			for jCol=StartCol:1:EndCol{
				s value = sheetArray.GetAt(StartRow).GetAt(jCol)
				if (value["merge"){
					//获取合并单元格的坐标
						s showCell = $p(value,"^",2)
						s rSite = $p(showCell,",",1)
						s cSite = $p(showCell,",",2)
						s cellVale = sheetArray.GetAt(rSite).GetAt(cSite)
						if (cellVale'[("^"_Atype)){
							s:cellVale'["|" cellVale = cellVale_"|"
							d sheetArray.GetAt(rSite).SetAt(cellVale_"^"_Atype,cSite)
						}
					}else{
						//给单元格单独的样式
						if (value'[("^"_Atype)){
							s:(value'["|") value = value_"|"
							d sheetArray.GetAt(StartRow).SetAt(value_"^"_Atype,jCol)
							}
					}
				
			}
	}
}

/// Creator:    yn
/// CreateDate: 2023-04-27
/// modify: 2023-04-27
/// Input:      
/// Out：处理带drawType的划线
/// Debug:w ##Class(EMRservice.BLBSParseXML).drawTypeAll(sheetArray, SheetRows, initStartRow, initEndRow, initStartCol, initEndCol, drawType)
ClassMethod drawTypeAll(sheetArray, SheetRows, SheetColumns, StartRow, EndRow, StartCol, EndCol)
{
	//startrow画上线
	d drawCrossLine(StartRow,"Top")
	//EndRow画下线
	d drawCrossLine(EndRow,"Bottom")
	//StartCol画左线
	d drawVerticalLine(StartCol,"Left")
	//EndCol画右线
	d drawVerticalLine(EndCol,"Right")
	q
drawVerticalLine(colNum,dir)
		if ((colNum'=0)&&(colNum<=SheetColumns)){
			//画竖线：left
				for kRow=StartRow:1:EndRow{
					s value = sheetArray.GetAt(kRow).GetAt(colNum)
					if (value["merge"){
						//获取合并单元格的坐标
						s showCell = $p(value,"^",2)
						s rSite = $p(showCell,",",1)
						s cSite = $p(showCell,",",2)
						s cellVale = sheetArray.GetAt(rSite).GetAt(cSite)
						if (cellVale'[("^"_dir)){
							s:cellVale'["|" cellVale = cellVale_"|"
							d sheetArray.GetAt(rSite).SetAt(cellVale_"^"_dir,cSite)
						}
					}else{
						if (value'[("^"_dir)){
							s:(value'["|") value = value_"|"
							d sheetArray.GetAt(kRow).SetAt(value_"^"_dir,colNum)
						}						
					}
				}
			}	
drawCrossLine(rowNum,dir)
	if ((rowNum'=0)&&(rowNum<=SheetRows)){
			for jCol=StartCol:1:EndCol{
				s value = sheetArray.GetAt(rowNum).GetAt(jCol)
				if (value["merge"){
					//获取合并单元格的坐标
						s showCell = $p(value,"^",2)
						s rSite = $p(showCell,",",1)
						s cSite = $p(showCell,",",2)
						s cellVale = sheetArray.GetAt(rSite).GetAt(cSite)
						if (cellVale'[dir){
							s:cellVale'["|" cellVale = cellVale_"|"
							d sheetArray.GetAt(rSite).SetAt(cellVale_"^"_dir,cSite)
						}
					}else{
						//给单元格单独的样式
						if (value'[dir){
							s:(value'["|") value = value_"|"
							d sheetArray.GetAt(rowNum).SetAt(value_"^"_dir,jCol)
							}
					}
				
			}
	}
	q
}

/// Creator:    yn
/// CreateDate: 2023-04-27
/// modify: 2023-04-27
/// Input:      
/// Out：处理带drawType的划线
/// Debug:w ##Class(EMRservice.BLBSParseXML).handleTableShow(document, sheetNum, sheetArray, SheetRows, SheetColumns)
ClassMethod handleDrawTypeLine(document, sheetNum, sheetArray, SheetRows, SheetColumns)
{
	s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor/Sheets","count(Sheet["_sheetNum_"]/Lines/Line)",.LineNum)
	s LineNum = LineNum.GetAt(1).Value
	for i=1:1:LineNum{
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_sheetNum_"]/Lines/Line["_i_"]",.LineItemObj) 
		s LineItemObj = LineItemObj.GetAt(1)
		s item = ..GetGridKeyValue(LineItemObj)
		//因cell坐标都加了1，所以线的规则也要加1，因为Arrayofdatatypes下标是从1开始的，而病案xml表格是从0开始的
		s initStartRow = item.GetAt("StartRow")+1
		s initEndRow = item.GetAt("EndRow")+1
		s initStartCol = item.GetAt("StartCol")+1
		s initEndCol = item.GetAt("EndCol")+1
		s drawType = item.GetAt("DrawType")
		d $case(
			drawType
			,"0":..drawTypeCross(sheetArray, SheetRows, initStartRow, initEndRow, initStartCol, initEndCol,"Top")
			,"1":..drawTypeCross(sheetArray, SheetRows, initStartRow, initEndRow, initStartCol, initEndCol,"Bottom")
			,"2":..drawTypeVertical(sheetArray, SheetColumns, initStartRow, initEndRow, initStartCol,"Left")
			,"3":..drawTypeVertical(sheetArray, SheetColumns, initStartRow, initEndRow,  initEndCol,"Right")			
			,"4":..drawTypeAll(sheetArray, SheetRows,SheetColumns, initStartRow, initEndRow, initStartCol, initEndCol)
			,:default
		)	
		
		}
	q
default
	q
}

/// Creator:    yn
/// CreateDate: 2022-10-10
/// desc: 获取grid里面描述第几行的线，方便调试
/// Input:      
/// Out      	处理table线，按照线的描述直译，画上线跟左线
/// Debug:      w ##Class(EMRservice.ParseGridXML).exportTableLine("sy1",37,"",1)
ClassMethod exportTableLine(fileName, rowNum = "", colNum = "", drawType = "", sheetNum = "1")
{
	s res = ##class(%GlobalBinaryStream).%New()
	s xmlStream= ..ReadFile(fileName,"GRID")
	q:xmlStream.FileBinarySize()=0 res
	s sc = ##class(%XML.XPATH.Document).CreateFromStream(xmlStream,.document)
	s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor/Sheets","count(Sheet["_sheetNum_"]/Lines/Line)",.LineNum)
	s LineNum = LineNum.GetAt(1).Value
	s argOutData = ##class(%FileBinaryStream).%New() 
	for i=1:1:LineNum{
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_sheetNum_"]/Lines/Line["_i_"]",.LineItemObj) 
		s LineItemObj = LineItemObj.GetAt(1)
		s item = ..GetGridKeyValue(LineItemObj)
		s linestr = ""
		//因cell坐标都加了1，所以线的规则也要加1，因为Arrayofdatatypes下标是从1开始的，而病案xml表格是从0开始的
		s initStartRow = item.GetAt("StartRow")+1
		s initEndRow = item.GetAt("EndRow")+1
		s initStartCol = item.GetAt("StartCol")+1
		s initEndCol = item.GetAt("EndCol")+1
		s initdrawType = item.GetAt("DrawType")
		s linestr = "<Line StartRow="_item.GetAt("StartRow")_" StartCol="_item.GetAt("StartCol")
		s linestr = linestr_" EndRow="_item.GetAt("EndRow")_" EndCol="_item.GetAt("EndCol")
		s linestr = linestr_" DrawType="_drawType_" >"
		
		if ((rowNum'="")&&(rowNum=initStartRow)&&(drawType=initdrawType)){
			s desc = $case(drawType,"0":"top","1":"bottom",:"")
			s linestr = linestr_" r"_rowNum_""_" draw"_initStartCol_"-"_initEndCol_" "_desc
			
			d argOutData.Write(linestr)
			d argOutData.Write($CHAR(10))
			}
			s coldesc = $case(drawType,"2":initStartCol,"3":initEndCol,:"")	
		if ((rowNum=initStartRow)||(colNum=coldesc)||(drawType=initdrawType&&(colNum=""))){
			s desc = $case(drawType,"2":"left","3":"right",:"")
			s linestr = linestr_" c"_coldesc_""_" draw"_initStartRow_"-"_initEndRow_" "_desc
			d argOutData.Write(linestr)
			d argOutData.Write($CHAR(10))
			}
		}
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="D:\emrparse\GRID\Line\Line_"_sheetNum_".txt"
	d argOutData.Rewind()
	while (argOutData.AtEnd = 0)
	{
		s tmpOut = argOutData.Read(32000)
		s tmpOut = $zcvt(tmpOut,"I","UTF8") //	s tmpOut = $zcvt(tmpOut,"I","UTF8") 
		d AStream.Write(tmpOut)
	}
	;d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
	q 1
default
	q
}

/// Creator:    yn
/// CreateDate: 2022-10-10
/// modify: 2023-04-14
/// Input:      
/// Out      	处理table线，按照线的描述直译，画上线跟左线
/// Debug:      w ##Class(EMRservice.BLBSParseXML).handleTableShow()
ClassMethod handleTableLine(document, sheetNum, sheetArray, SheetRows, SheetColumns)
{
	s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor/Sheets","count(Sheet["_sheetNum_"]/Lines/Line)",.LineNum)
	s LineNum = LineNum.GetAt(1).Value
	for i=1:1:LineNum{
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_sheetNum_"]/Lines/Line["_i_"]",.LineItemObj) 
		s LineItemObj = LineItemObj.GetAt(1)
		s item = ..GetGridKeyValue(LineItemObj)
		//因cell坐标都加了1，所以线的规则也要加1，因为Arrayofdatatypes下标是从1开始的，而病案xml表格是从0开始的
		s initStartRow = item.GetAt("StartRow")+1
		s initEndRow = item.GetAt("EndRow")+1
		s initStartCol = item.GetAt("StartCol")+1
		s initEndCol = item.GetAt("EndCol")+1
				
		s StartRow = initStartRow-1
		s EndRow = initEndRow-1
		s StartCol = initStartCol
		s EndCol = initEndCol-1 //到endcol-1
		
		if (StartRow=EndRow&&(StartRow'=0)&&(StartRow<=SheetRows)){
			//画横线：bottom 线所描述的单元格都应画下线
				for jCol=StartCol:1:EndCol{
					s value = sheetArray.GetAt(StartRow).GetAt(jCol)
					if (value["merge"){
						//获取合并单元格的坐标
							s showCell = $p(value,"^",2)
							s rSite = $p(showCell,",",1)
							s cSite = $p(showCell,",",2)
							s cellVale = sheetArray.GetAt(rSite).GetAt(cSite)
							if (cellVale'["Bottom"){
								s:cellVale'["|" cellVale = cellVale_"|"
								d sheetArray.GetAt(rSite).SetAt(cellVale_"^Bottom",cSite)
							}
						}else{
							//给单元格单独的样式
							if (value'["Bottom"){
								s value = value_"|"
								d sheetArray.GetAt(StartRow).SetAt(value_"^Bottom",jCol)
								}
						}
					
				}
			}
		s StartRow = initStartRow
		s EndRow = initEndRow-1
		s StartCol = initStartCol
		s EndCol = initEndCol
		
		if (StartCol=EndCol&&(StartCol'=0)&&(StartCol<=SheetColumns)){
			//画竖线：left
				for kRow=StartRow:1:EndRow{
					s value = sheetArray.GetAt(kRow).GetAt(StartCol)
					if (value'["|"){
						s value = value_"|"
					}
					d sheetArray.GetAt(kRow).SetAt(value_"^Left",StartCol)
					}
			}
		}
}

/// Creator:    yn
/// CreateDate: 2022-10-10
/// Input:      
/// Out      	合并cell，无返回值
/// Debug:      w ##Class(EMRservice.BLBSParseXML).handleTableShow()
ClassMethod handleTableShow(document, sheetNum, CellHeight, sheetArray, SheetRows, SheetColumns)
{
	//处理cell	
	s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","count(Sheets/Sheet["_sheetNum_"]/Cell)",.SheetCellNumObj)	
	s SheetCellNum = SheetCellNumObj.GetAt(1).Value
	for j=1:1:SheetCellNum{
		s sc = document.EvaluateExpression("/Document/StructuredBody/NInstanceData/iEditor","Sheets/Sheet["_sheetNum_"]/Cell["_j_"]",.CellObj)	
		s tResult = CellObj.GetAt(1)
		s row = "",col="",colspan="",rowspan="",cellStr = ""
		while(tResult.Read()){
            If tResult.NodeType="element"
            {  
                if tResult.HasAttributes {
                    For tJ=1:1:tResult.AttributeCount
                    {
                        Do tResult.MoveToAttributeIndex(tJ)
                    	s:tResult.Name="Row" row=+tResult.Value+1
                    	s:tResult.Name="Col" col=+tResult.Value+1
                    	s:tResult.Name="Rows" rowspan=tResult.Value 
                    	s:tResult.Name="Columns" cospan=tResult.Value   
                  		s cellStr = cellStr_tResult.Name_":"_tResult.Value_";"                                       
                    }
                }
            }				
		}
		if ((row>SheetRows)||(col>SheetColumns)){
			continue
			}
		s cellStr = cellStr_"height:"_CellHeight_"px;"
		//处理影响当前行合并的列
		s startCol = col+1
		s endCol = col+cospan-1
		for jC=startCol:1:endCol{
			d sheetArray.GetAt(row).SetAt("merge",jC)
			}
		//处理影响合并行的列
		s startRow = row+1
		s startCol = col
		s endCol = col+cospan-1
		s endRow = row+rowspan-1
		s flag = 1
		for kC=startRow:1:endRow{	  
		  for jC=startCol:1:endCol{
		    d sheetArray.GetAt(kC).SetAt("merge",jC)
		  }
		}
		d sheetArray.GetAt(row).SetAt(cellStr,col)
	}
}

/// Creator:    yn
/// CreateDate: 2020-6-12
/// Input:      
/// Out      	打印xml解析结果
/// Debug:      w ##Class(EMRservice.BLBSParseXML).handleGridPageSize()
ClassMethod handleGridPageSize(styleS, PrintSetup)
{
  s node = PrintSetup.GetAt(1) 
  s array = ..GetGridKeyValue(node)
  s:array.GetAt("PageWidth")'="" width = array.GetAt("PageWidth")
  s width = $case(array.GetAt("PageWidth"),"":"210",:array.GetAt("PageWidth"))
  s height = $case(array.GetAt("PageHeight"),"":"297",:array.GetAt("PageHeight"))
  s units = $case(array.GetAt("Unit"),"":"mm",:array.GetAt("Unit"))
  s paddingTop = $case(array.GetAt("MarginTop"),"":"0px",:array.GetAt("MarginTop"))
  s paddingBottom = $case(array.GetAt("MarginBottom"),"":"0px",:array.GetAt("MarginBottom"))
  s paddingLeft = $case(array.GetAt("MarginLeft"),"":"0px",:array.GetAt("MarginLeft"))
  s paddingRight = $case(array.GetAt("MarginRight"),"":"0px",:array.GetAt("MarginRight"))
  d styleS.Write(".page-size{")
  d styleS.Write("width:"_width_units_";")
  d styleS.Write("min-height:"_height_units_";")
  //d styleS.Write("padding:"_paddingTop_units_" "_paddingRight_units_" "_paddingBottom_units_" "_paddingLeft_units_";")
  d styleS.Write("}")
}

/// Creator:    yn
/// CreateDate: 2020-6-12
/// Input:      
/// Out      	返回单个处理的sheet
/// Desc		处理单个sheet的所有Cell
/// Debug:      w ##Class(EMRservice.BLBSParseXML).handleGridSheetCell()
ClassMethod handleGridSheetCell(bodyS, docArray, mediasArry)
{
	s count = docArray.Count() 
	s sheetKey = ""
	s sectionStr = ##Class(%GlobalBinaryStream).%New()
	for i=1:1:count{
		if (i=1){
			d sectionStr.Write("<section class=""page-size page-style""><table cellspacing=0 class=""page-gridtable"">")
		}else{
			d sectionStr.Write("</table></section><section class=""page-size page-style""><table cellspacing=0 class=""page-gridtable"">")
			}
		s sheetKey = docArray.Next(sheetKey)
		s sheetArry = docArray.GetAt(sheetKey)
		s rowCount = sheetArry.Count()
		for j=1:1:rowCount{
			if (j=1){
				d sectionStr.Write("<tr>")
			}else{
				d sectionStr.Write("</tr><tr>")
				}
			s row = sheetArry.GetAt(j)
			s colCount = row.Count()
			for k=1:1:colCount{
				s cell = row.GetAt(k)			
				continue:(cell["merge")
				if (cell["[td]"){
					s cellStyles = ..GetTdLine("",cell)
					s cellStyles = cellStyles_"height:15px;"
					if (j=1){
						s value = k
						}elseif (k=1){
						s value = j	
						}else{
							s value = ""
							}
					s value = ""
				 	d sectionStr.Write("<td name=""r"_j_"c"_k_""" style="""_cellStyles_""">"_value_"</td>")
					}else{
					s attrArry = ..GetKeyValue(cell)
					s cellStyles = ..GetGridStyles(cell)
					s cellStyles = cellStyles_"word-break:break-all;"
					s cellStyles = ..GetTdLine(cellStyles,cell)
					d sectionStr.Write("<td  name=""r"_j_"c"_k_"""  colspan="""_attrArry.GetAt("Columns")_""" rowspan="""_attrArry.GetAt("Rows"))
					d sectionStr.Write(""" style="""_cellStyles_""">")
					if (attrArry.GetAt("DrawInboxRect")="4"){
						d sectionStr.Write("<div style=""height:60%;border:1px solid #000"">")
						d sectionStr.Write(attrArry.GetAt("Value"))
						d sectionStr.Write("</div>")
						}elseif(attrArry.GetAt("Type")="14"){
							s imgCode = attrArry.GetAt("Code")
							s imgData = mediasArry.GetAt(imgCode)
							if (imgCode'=""&&(imgData'="")){
								d sectionStr.Write("<img style=""width:100%;"" ")
								if ($isObject(imgData)){
									d sectionStr.Write(" src=""data:image/png;base64,")
									d imgData.Rewind()
									while (imgData.AtEnd = 0)
									{
										d sectionStr.Write(imgData.Read(32000))
									} 
									d sectionStr.Write(""" />")	
								}else{
									d sectionStr.Write(" src=""data:image/png;base64,"_imgData_""" />")	
								}
							}
							}
						else{
							d sectionStr.Write(attrArry.GetAt("Value"))
						}
					d sectionStr.Write("</td>")
					}
			}
				
		}
		if (i=count){
			d sectionStr.Write("</tr></table></section>")
		}
	}
	d sectionStr.Rewind()
	while (sectionStr.AtEnd = 0)
	{
		d bodyS.Write(sectionStr.Read(32000))
	}
}

ClassMethod GetTdLine(cellStyles, cell)
{
	s cellprops = $p(cell,"|",2)
	s leng = $l(cellprops,"^")
	for pItem=1:1:leng{
		s styleItem=$p(cellprops,"^",pItem)
		if (styleItem="Bottom"){
			s cellStyles = cellStyles_"border-bottom:1px solid #000;"
			}
		if (styleItem="Right"){
			s cellStyles = cellStyles_"border-right:1px solid #000;"
			}
		if (styleItem="Top"){
			s cellStyles = cellStyles_"border-top:1px solid #000;"
			}
		if (styleItem="Left"){
			s cellStyles = cellStyles_"border-left:1px solid #000;"
			}
		if (styleItem="All"){
			s cellStyles = cellStyles_"border:1px solid #000;"
			}
	}
	q cellStyles
}

/// Creator:    yn
/// CreateDate: 2020-6-12
/// Input:      
/// Out      	返回styles样式
/// Debug:      w ##Class(EMRservice.BLBSParseXML).GetGridStyles()
ClassMethod GetGridStyles(props)
{
	s res = ""
	q:props="" ""
	s total = $l(props,";")
	for i=1:1:total{
		s item = $p(props,";",i)
		s propName = $replace($p(item,":",1)," ","")
		s value = $p(item,":",2)
			d $Case(
				propName
				,"border-right":border
				,"border-bottom":border
				,"height":height
				,"Horizontal":textAlign
				,"Vertical":verticalAlign
				,"FontName":FontFamily
				,"FontSize":FontSize
				,"FontWeight":FontWeight
				,"UnderLine":UnderLine
				,"FontColor":FontColor
				,"FontSize":FontSize
				,:default
				)
	}
	q res	
border
	s res = res_propName_":"_value_";"
	q res
height
	s res = res_"height:"_value_";"
	q	
textAlign
	s res = res_"text-align:"_value_";"
	q
verticalAlign
	s res = res_"vertical-align:"_value_";"
	q
FontFamily
	s res = res_"font-family:"_value_";"
	q
FontSize
	s res = res_"font-size:"_value_"px;"
	q
FontWeight
	s res = res_"font-weight:"_value_";"
	q
UnderLine
	if ($replace($zconvert(value,"U")," ","")="TRUE"){
		s res = res_"text-decoration:underline;"
	}
	q
FontColor
	s res = res_"color:"_value_";"
	q
default
	q
}

/// Creator:    yn
/// CreateDate: 2020-09-29
/// Input:      当前节点
/// Out      	属性名值键值对,只取当前传过来的单个节点属性，不遍历其子节点
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).GetGridKeyValue("270||8")
ClassMethod GetGridKeyValue(node As %XML.XPATH.DOMResult) As %ArrayOfDataTypes
{
	s array = ##Class(%ArrayOfDataTypes).%New()
	q:node="" array
	d node.Read()
	If node.NodeType="element"
	{
		If node.HasAttributes {
	    	For tJ=1:1:node.AttributeCount
	    	{
	        	Do node.MoveToAttributeIndex(tJ)
	        	d array.SetAt(node.Value,node.Name)
	    	}
		}
	}
	q array
}

/// Creator:    yn
/// CreateDate: 2022-10-09
/// Input:      
/// Out      	
/// Desc		调试用：输出sheetarry的数据
/// Debug:      w ##Class(EMRservice.BLBSParseXML).GetXpathNodeAttr()
ClassMethod WriteArry(docArray)
{
	s res = ##class(%GlobalBinaryStream).%New()
	s count = docArray.Count() 
	s sheetKey = ""
	for i=1:1:count{
		s sheetKey = docArray.Next(sheetKey)
		s sheetArry = docArray.GetAt(sheetKey)
		s rowCount = sheetArry.Count()
		d res.Write("<table border=1 style=""border-collapse:collapse;"">")
		for j=1:1:rowCount{
			d res.Write("<tr>")
			s row = sheetArry.GetAt(j)
			s colCount = row.Count()
			for k=1:1:colCount{
				s cell = row.GetAt(k)		
				d res.Write("<td>"_cell_"</td> ")
			}
			d res.Write("</tr>")	
		}
		d res.Write("</table>")
	}
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\emrparse\array.html"
	d AStream.CopyFrom(res)
	d AStream.SaveStream()
	d AStream.%Close()
}

}

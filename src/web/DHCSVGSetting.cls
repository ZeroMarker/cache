/// SVG 设置
/// By wuqk 2007-10
Class web.DHCSVGSetting Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 4;

ClassMethod GetSVGSetting()
{
	n
	s BackGround=$g(^DHCSVG("BackGround"))  ///背景色 X轴色 Y轴色
	s TitleFont=$g(^DHCSVG("TitleFont"))   	///字体 大小 颜色
	s ElseFont=$g(^DHCSVG("ElseFont"))   	///字体 大小 颜色
	s LineColor=$g(^DHCSVG("LineColor")) 	///
	s LineWidth=$g(^DHCSVG("LineWidth"))   	///X轴宽 Y轴宽 线条宽
	s XLableType=$g(^DHCSVG("XLableType"))  ///X轴坐标显示基数 X坐标是否上下显示(1:是 0:否)
	s ret=BackGround_$c(1)_TitleFont_$c(1)_ElseFont_$c(1)_LineColor_$c(1)_LineWidth_$c(1)_XLableType
	q ret
}

ClassMethod GetUnicode(str As %String)
{
   n (str)
   s ret=""
   FOR i=1:1:$LENGTH(str) {
    SET ret=ret_"&#x"_$zh($ASCII(str,i))_";"
    }
   q ret
}

ClassMethod GetYMax(MaxData As %String)
{
	n (MaxData)
    s MaxData=+MaxData
	s YMax=0
	i MaxData<10 d
	.s:MaxData>4 YMax=10
	.s:MaxData'>4 YMax=5
	e  d
	.s YMaxLen=$l(MaxData)
	.s Max1=$e(MaxData,1,1)
	.s Max2=$e(MaxData,2,2)
	.i Max2>4 d
	..s Max1=Max1+1
	..s Max2=0
	.e  d
	..s Max2=5
	.s YMax=Max1_Max2
	.f i=3:1:YMaxLen d
	..s YMax=YMax_"0"
	s YMax=+YMax
	q YMax
}

ClassMethod GetPieRows(iPies)
{
	n (iPies)
    s iPies=+iPies
    s Rows=0
    i iPies>16 d
    .s Rows=iPies\5
    .s mod=iPies#5
    .s:mod>0 Rows=Rows+1
    e  i iPies>12 d
    .s Rows=4
    e  i iPies>8 d
    .s Rows=3
    e  i iPies>3 d
    .s Rows=2
    e  d
    .s Rows=1
	q Rows
}

/// 返回行列数 半径
ClassMethod GetPieSetting(iPies, svgX, svgY)
{
	n (iPies,svgX,svgY)
	s svgX0=0,XWidth=svgX*4/5              ;80%X
	s svgY0=svgY/10 ,YHeigth=svgY*9/10     ;90%Y
	s Rows=+..GetPieRows(iPies)
	s Cols=iPies\Rows
	s:iPies#Rows>0 Cols=Cols+1
	
	s pieXWidth=XWidth/Cols
	s pieYHeigth=YHeigth/Rows*9/10
	
	s DIA=pieXWidth
	s:pieYHeigth<pieXWidth DIA=pieYHeigth
	s DIA=DIA*9/10
	s Radii=DIA/2                      ;pie=90% max
	
	q Rows_"^"_Cols_"^"_Radii_"^"_pieXWidth_"^"_pieYHeigth
}

ClassMethod GetPieX0(index, iPies, svgX, svgY)
{
	n (index,iPies,svgX,svgY)
	s svgX0=0,XWidth=svgX*4/5              ;80%X
	s svgY0=svgY/10 ,YHeigth=svgY*9/10     ;90%Y
	s tmp=..GetPieSetting(iPies,svgX,svgY)
	s Rows=$p(tmp,"^",1)
	s Cols=$p(tmp,"^",2)
	s Radii=$p(tmp,"^",3)
	
	s pieXWidth=XWidth/Cols
	s pieYHeigth=YHeigth/Rows*9/10
	
	s iRow=index\Cols
	s:index#Cols=0 iRow=iRow-1
	s iCol=(index-1)#Cols
	;s:iCol=0 iRow=iRow-1
	;s:iCol=0 iCol=Cols-1
	;w !,iRow_" "_iCol
	s X0=pieXWidth*iCol+svgX0
	s Y0=pieYHeigth*iRow+svgY0
	
	s pieX0=X0+(pieXWidth/2)
	
	q pieX0
}

ClassMethod GetPieY0(index, iPies, svgX, svgY)
{
	n (index,iPies,svgX,svgY)
	s svgX0=0,XWidth=svgX*4/5              ;80%X
	s svgY0=svgY/10 ,YHeigth=svgY*9/10     ;90%Y
	s tmp=..GetPieSetting(iPies,svgX,svgY)
	s Rows=$p(tmp,"^",1)
	s Cols=$p(tmp,"^",2)
	s Radii=$p(tmp,"^",3)
	
	s pieXWidth=XWidth/Cols
	s pieYHeigth=YHeigth/Rows*9/10
	
	s iRow=index\Cols
	s:index#Cols=0 iRow=iRow-1
	s iCol=(index-1)#Cols
	;s:iCol=0 iRow=iRow-1
	;s:iCol=0 iCol=Cols-1
	;w !,iRow_" "_iCol
	s X0=pieXWidth*iCol+svgX0
	s Y0=pieYHeigth*iRow+svgY0
	
	s pieY0=Y0+(pieYHeigth/2)
	
	q pieY0
}

ClassMethod GetX0(index, iPies, svgX, svgY)
{
	n (index,iPies,svgX,svgY)
	s svgX0=0,XWidth=svgX*4/5              ;80%X
	s svgY0=svgY/10 ,YHeigth=svgY*9/10     ;90%Y
	s tmp=..GetPieSetting(iPies,svgX,svgY)
	s Rows=$p(tmp,"^",1)
	s Cols=$p(tmp,"^",2)
	s Radii=$p(tmp,"^",3)
	
	s pieXWidth=XWidth/Cols
	s pieYHeigth=YHeigth/Rows*9/10
	
	s iRow=index\Cols
	s:index#Cols=0 iRow=iRow-1
	s iCol=(index-1)#Cols
	;s:iCol=0 iRow=iRow-1
	;s:iCol=0 iCol=Cols-1
	;w !,iRow_" "_iCol
	s X0=pieXWidth*iCol+svgX0
	s Y0=pieYHeigth*iRow+svgY0
	
	
	q X0
}

ClassMethod GetY0(index, iPies, svgX, svgY)
{
	n (index,iPies,svgX,svgY)
	s svgX0=0,XWidth=svgX*4/5              ;80%X
	s svgY0=svgY/10 ,YHeigth=svgY*9/10     ;90%Y
	s tmp=..GetPieSetting(iPies,svgX,svgY)
	s Rows=$p(tmp,"^",1)
	s Cols=$p(tmp,"^",2)
	s Radii=$p(tmp,"^",3)
	
	s pieXWidth=XWidth/Cols
	s pieYHeigth=YHeigth/Rows*9/10
	
	s iRow=index\Cols
	s:index#Cols=0 iRow=iRow-1
	s iCol=(index-1)#Cols
	s X0=pieXWidth*iCol+svgX0
	s Y0=pieYHeigth*iRow+svgY0
	q Y0
}

}

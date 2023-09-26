Import sqluser

Class web.DHCST.Tools.ImportInRcp Extends (%RegisteredObject, %XML.Adaptor, web.DHCST.StkTypeG) [ Not ProcedureBlock ]
{

/// w ##class(web.DHCST.Tools.ImportInRcp).StartInput("d:/tmp/a.xls")
ClassMethod StartInput(fileName As %String) As %String
{
  n (fileName)
  s sub="web.DHCST.Tools.ImportInRcp"
  s p=$zn
  k ^zTSA(p,sub)
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .s cnt=cnt+1
  .tstart
  .s insRet=..InsertIncItmRcp(rowStr)
  .i +insRet=0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  ..w insRet,!
  ..tro
  k ^zTSA(p,sub)  //删除临时global
  q "总记录数:"_cnt_",成功记录数:"_successCnt
}

ClassMethod InsertIncItmRcp(rowData)
{
	n (rowData)
	s code=$p(rowData,"^",1)
	q:code="" -1
	s desc=$p(rowData,"^",2)
	s qty=$p(rowData,"^",3)
	s uom=$p(rowData,"^",4)
	s ratio=$p(rowData,"^",5)
	s Remark=$p(rowData,"^",6)
	s inrinCode=$p(rowData,"^",7)
	s inrinDesc=$p(rowData,"^",8)
	s inrinQty=$p(rowData,"^",9)
	s inrinUom=$p(rowData,"^",10)
	s Inci=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(code)_"Z",""))
	q:Inci="" -1_"^"_"制剂药品不存在"_"^"_desc_"^"_inrinDesc
	s uomdr=$o(^CT("UOM",0,"Desc",$$ALPHAUP^SSUTIL4(uom),""))
	q:uomdr="" -1_"^"_"制剂单位不存在"_"^"_desc_"^"_inrinDesc
	s inrinUomdr=$o(^CT("UOM",0,"Desc",$$ALPHAUP^SSUTIL4(inrinUom),""))
	q:inrinUomdr="" -1_"^"_"制剂原料单位不存在"_"^"_desc_"^"_inrinDesc
	s inrinInci=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(inrinCode)_"Z",""))
	q:inrinInci="" -1_"^"_"制剂原料不存在"_"^"_desc_"^"_inrinDesc
	s name=$p(^INCI(Inci,1),"^",2)
	s InRec=""
	s chl="" 
	f  s chl=$o(^INCI(Inci,"REC",chl)) q:(chl="")||(InRec'="")  d
	.s InRcpUom=$p(^INCI(Inci,"REC",chl),"^",1)
	.s InRcpQty=$p(^INCI(Inci,"REC",chl),"^",2)
	.q:(InRcpUom'=uomdr)||(InRcpQty'=qty) 
	.s InRec=Inci_"||"_chl
	s err=0
	i InRec="" d
	.s maindata=InRec_"^"_qty_"^"_uomdr_"^"_name_"^"_Remark_"^"_ ratio
	.s ret=##class(web.DHCST.IncItmRcp).SaveInRcp(Inci,maindata,1)
	.i +ret<0 s err=ret
	q:err'=0 err_"^"_desc_"^"_inrinDesc
	s InRin=""
	s chl="" 
	f  s chl=$o(^INCI(Inci,"REC",chl)) q:(chl="")||(InRin'="")  d
	.s InRcpUom=$p(^INCI(Inci,"REC",chl),"^",1)
	.s InRcpQty=$p(^INCI(Inci,"REC",chl),"^",2)
	.q:(InRcpUom'=uomdr)||(InRcpQty'=qty) 
	.s InRec=Inci_"||"_chl
	.s sub=""
	.f  s sub=$o(^INCI(Inci,"REC",chl,"ING",sub)) q:(sub="")||(InRin'="")  d
	..s tmpinrinInci=$p(^INCI(Inci,"REC",chl,"ING",sub),"^",1)
	..q:tmpinrinInci'=inrinInci
	..s InRin=Inci_"||"_chl_"||"_sub
	..
	q:InRec="" -3_"^"_"获取制剂i失败"_"^"_desc_"^"_inrinDesc
	i InRec'="" d
	.s listdata=InRin_"^"_inrinInci_"^"_inrinQty_"^"_inrinUomdr
	.s ret=##class(web.DHCST.IncItmRcp).SaveInRecIngr(InRec,listdata,1)
	.i +ret<0 s err=ret
	q:err'=0 err
	q 0
}

/// w ##class(web.DHCST.Tools.ImportInRcp).ExportInRec("d:/tmp/a.xls")
ClassMethod ExportInRec(filename)
{
	n (filename)
	q:filename="" "无路径!"
	s num=1
 	o filename:"WNS"
 	u filename
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci="0"
	.s incidesc=$p(^INCI(Inci,1),"^",2)
	.s incicode=$p(^INCI(Inci,1),"^",1)
	.s chl=0
	.f  s chl=$o(^INCI(Inci,"REC",chl)) q:chl=""  d
	..s InRcpUom=$p(^INCI(Inci,"REC",chl),"^",1)
	..s InRcpQty=$p(^INCI(Inci,"REC",chl),"^",2)
	..s inrec=Inci_"||"_chl
	..s Remark=$g(^INCI(Inci,"REC",chl,"REM",1))    //$LTS(^INCI(Inci,"REC",chl,"REM"))
	..s dhcinrec=$o(^DHCINREC(0,"INREC",inrec,""))
	..s Ratio=""
	..i dhcinrec'=""  d
	...s Ratio=$p(^DHCINREC(dhcinrec),"^",2)
	..i InRcpUom'="" s InRcpUom=$p(^CT("UOM",InRcpUom),"^",2)
	..s sub=0
	..f  s sub=$o(^INCI(Inci,"REC",chl,"ING",sub)) q:sub=""  d
	...s inrinInci=$p(^INCI(Inci,"REC",chl,"ING",sub),"^",1)
	...s inrinQty=$p(^INCI(Inci,"REC",chl,"ING",sub),"^",2)
	...s inrinUom=$p(^INCI(Inci,"REC",chl,"ING",sub),"^",3)
	...s inrinInciCode=$p(^INCI(inrinInci,1),"^",1)
	...s inrinInciDesc=$p(^INCI(inrinInci,1),"^",2)
	...i inrinUom'="" s inrinUom=$p(^CT("UOM",inrinUom),"^",2)
	...i num=1 d
 	....w "制剂代码"_$c(9)_"制剂名称"_$c(9)_"制剂数量"_$c(9)_"制剂单位"_$c(9)_"制剂加成"_$c(9)_"制剂备注"_$c(9)_"原料代码"_$c(9)_"原料名称"_$c(9)_"原料数量"_$c(9)_"原料单位"
    ...s outputdata=incicode_$c(9)_incidesc_$c(9)_InRcpQty_$c(9)_InRcpUom_$c(9)_Ratio_$c(9)_Remark_$c(9)_inrinInciCode_$c(9)_inrinInciDesc_$c(9)_inrinQty_$c(9)_inrinUom
 	...s outputdata=$tr(outputdata,$c(13,10),"")
 	...w !,outputdata
 	...s num=num+1
 	c filename
    q "导出完成!"
}

}

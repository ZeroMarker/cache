/// 名称: DHCMA.CPW.KBS.HandleEMRCode
/// 描述: 处理诊疗项目关联病历代码
/// 编写者：yankai
/// 编写日期: 2022-07-07
Class DHCMA.CPW.KBS.HandleEMRCode Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 通过关键字查询诊疗项目并自动更新病历代码
/// w ##class(DHCMA.CPW.KBS.HandleEMRCode).AutoRelateEMRCode()
ClassMethod AutoRelateEMRCode() As %String
{
	&sql(UPDATE DHCMA_CPW_KB.ClinItemBase SET CIEMRCode = NULL )
	
	// 1.治疗记录
	Set return=0
	&sql(declare zljlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc NOT LIKE '%向患者%' AND CIDesc NOT LIKE '%出院%' 
			AND (CIDesc LIKE '%治疗方案%' OR CIDesc LIKE '%诊疗方案%' OR CIDesc LIKE '%诊治方案%') 		
	)
	&sql(open zljlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch zljlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR050101"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR050101"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close zljlCursor)
	w "治疗记录更新"_return_"条",!
	
	// 2.手术记录
	Set return=0
	&sql(declare sshjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%手术记录%' OR CIDesc LIKE '%术后记录%' OR CIDesc LIKE '%实施手术%' OR CIDesc LIKE '%完成手术%' 
	)
	&sql(open sshjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch sshjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR050102"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR050102"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close sshjlCursor)
	w "手术记录更新"_return_"条",!
	
	// 3.麻醉记录
	Set return=0
	&sql(declare mzjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%麻醉记录%'
	)
	&sql(open mzjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch mzjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR050103"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR050103"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close mzjlCursor)
	w "麻醉记录更新"_return_"条",!
	
	// 4.输血记录
	Set return=0
	&sql(declare sxjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where (CIDesc LIKE '%输血%' OR  CIDesc LIKE '%换血%')  AND CIDesc NOT LIKE '%同意书%' AND CIDesc NOT LIKE '%血前%' AND CIDesc NOT LIKE '%血后%'
	)
	&sql(open sxjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch sxjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR050104"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR050104"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close sxjlCursor)
	w "输血记录更新"_return_"条",!
	
	// 5.手术同意书
	Set return=0
	&sql(declare sstysCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%手术同意书%' OR CIDesc LIKE '%手术知情同意书%'
	)
	&sql(open sstysCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch sstysCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR070001"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR070001"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close sstysCursor)
	w "手术同意书更新"_return_"条",!
	
	// 6.特殊检查及治疗同意书
	Set return=0
	&sql(declare tsjcjzltysCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%同意书%' AND CIDesc LIKE '%特殊%' AND (CIDesc LIKE '%检查%' OR CIDesc LIKE '%治疗%')
	)
	&sql(open tsjcjzltysCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch tsjcjzltysCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR070002"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR070002"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close tsjcjzltysCursor)
	w "特殊检查及治疗同意书更新"_return_"条",!
	
	//特殊药品及材料使用同意书
	
	// 7.输血同意书
	Set return=0
	&sql(declare sxtysCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where (CIDesc LIKE '%输血%' OR CIDesc LIKE '%换血%') and CIDesc LIKE '%同意书%'
	)
	&sql(open sxtysCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch sxtysCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR070004"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR070004"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close sxtysCursor)
	w "输血同意书更新"_return_"条",!

	// 8.病重病危通知书
	Set return=0
	&sql(declare bzbwtzsCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where (CIDesc LIKE '%病重%' or CIDesc LIKE '%病危%') AND CIDesc LIKE '%通知%'
	)
	&sql(open bzbwtzsCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch bzbwtzsCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR070005"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR070005"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close bzbwtzsCursor)
	w "病重病危通知书更新"_return_"条",!

	// 9.麻醉、精神药品同意书
	Set return=0
	&sql(declare mzjsyptysCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where (CIDesc LIKE '%麻醉%' or CIDesc LIKE '%精神药品%') AND CIDesc LIKE '%同意书%' 
	)
	&sql(open mzjsyptysCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch mzjsyptysCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR070006"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR070006"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close mzjsyptysCursor)
	w "麻醉、精神药品同意书更新"_return_"条",!

	// 10.入院记录
	Set return=0
	&sql(declare ryjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where (CIDesc LIKE '%入院记录%' OR CIDesc LIKE '%住院志%' OR CIDesc LIKE '%询问病史%' OR CIDesc LIKE '%体格检查%') AND CIDesc  NOT LIKE '%出院%'
	)
	&sql(open ryjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch ryjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR090001"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR090001"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close ryjlCursor)
	w "入院记录"_return_"条",!
	
	// 11.24小时入出院记录
	Set return=0
	&sql(declare rcy24Cursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%24%' AND CIDesc LIKE  '%出入院%'
	)
	&sql(open rcy24Cursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch rcy24Cursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR090002"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR090002"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close rcy24Cursor)
	w "24小时入出院记录"_return_"条",!
	
	// 12.24小时内入院死亡记录
	// sql查询无数据
	
	// 13.首次病程记录
	Set return=0
	&sql(declare scbcCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%首次病程%' OR CIDesc LIKE '%首程%' 
	)
	&sql(open scbcCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch scbcCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100001"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100001"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close scbcCursor)
	w "首次病程记录"_return_"条",!
	
	// 14.日常病程记录
	Set return=0
	&sql(declare rcbcCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%病程%' AND  (CIDesc NOT LIKE '%首次%' AND CIDesc NOT LIKE '%术后%' AND CIDesc NOT LIKE '%如%' AND  CIDesc NOT LIKE '%手术%')
	)
	&sql(open rcbcCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch rcbcCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100002"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100002"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close rcbcCursor)
	w "日常病程记录"_return_"条",!
	
	// 15.上级医师查房记录
	Set return=0
	&sql(declare sjyscfCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%上级医师查房%' 
	)
	&sql(open sjyscfCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch sjyscfCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100003"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100003"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close sjyscfCursor)
	w "上级医师查房记录"_return_"条",!
	
	// 16.疑难病例讨论记录
	Set return=0
	&sql(declare ynbltlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%疑难%' AND CIDesc LIKE '%讨论%' 
	)
	&sql(open ynbltlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch ynbltlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100004"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100004"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close ynbltlCursor)
	w "疑难病例讨论记录"_return_"条",!
	
	// 17.交接班记录
	Set return=0
	&sql(declare jjbjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%交班%' OR CIDesc LIKE '%接班%'
	)
	&sql(open jjbjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch jjbjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100005"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100005"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close jjbjlCursor)
	w "交接班记录"_return_"条",!
	
	// 18.转科记录
	Set return=0
	&sql(declare zkjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%转科%' and (CIDesc LIKE '%记录%' or CIDesc LIKE '%录%')
	)
	&sql(open zkjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch zkjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100006"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100006"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close zkjlCursor)
	w "转科记录"_return_"条",!
	
	// 19.阶段小结
	Set return=0
	&sql(declare jdxjCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%阶段%' OR (CIDesc LIKE '%评估%' AND CIDesc LIKE '%治疗%' AND CIDesc LIKE '%效果%' AND CIDesc NOT LIKE '%出院%' AND CIDesc NOT LIKE '%术前%' AND CIDesc NOT LIKE '%手术%' AND CIDesc NOT LIKE '%术后%' AND CIDesc NOT LIKE '%查房%')
	)
	&sql(open jdxjCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch jdxjCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100007"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100007"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close jdxjCursor)
	w "阶段小结"_return_"条",!
	
	// 20.抢救记录
	Set return=0
	&sql(declare qjjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%抢救%' AND CIDesc NOT LIKE '%同意%'
	)
	&sql(open qjjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch qjjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100008"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100008"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close qjjlCursor)
	w "抢救记录"_return_"条",!
	
	// 21.会诊记录
	Set return=0
	&sql(declare hzjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%会诊%'
	)
	&sql(open hzjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch hzjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100009"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100009"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close hzjlCursor)
	w "会诊记录"_return_"条",!
	
	// 22.术前小结
	Set return=0
	&sql(declare sqxjCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%术前小结%' OR CIDesc LIKE '%术前评估%' 
	)
	&sql(open sqxjCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch sqxjCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100010"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100010"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close sqxjCursor)
	w "术前小结"_return_"条",!
	
	// 23.术前讨论
	Set return=0
	&sql(declare sqtlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%术前%' AND CIDesc LIKE '%讨论%'
	)
	&sql(open sqtlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch sqtlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100011"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100011"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close sqtlCursor)
	w "术前讨论"_return_"条",!
	
	// 24.术后首次病程记录
	Set return=0
	&sql(declare shscbcCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%术后%' AND CIDesc LIKE '%病程%'
	)
	&sql(open shscbcCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch shscbcCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100012"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100012"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close shscbcCursor)
	w "术后首次病程记录"_return_"条",!
	
	// 25.出院小结
	Set return=0
	&sql(declare cyxjCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%出院小结%'
	)
	&sql(open cyxjCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch cyxjCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100013"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100013"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close cyxjCursor)
	w "出院小结"_return_"条",!
	
	// 26.死亡记录
	// 27.死亡病例讨论记录
	
	// 28.麻醉术前访视记录	
	Set return=0
	&sql(declare mzsqfsjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%麻醉%' AND CIDesc LIKE '%访视%'
	)
	&sql(open mzsqfsjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch mzsqfsjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100017"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100017"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close mzsqfsjlCursor)
	w "麻醉术前访视记录"_return_"条",!
	
	// 29.麻醉术后访视记录	
	Set return=0
	&sql(declare mzshfsjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%麻醉%' AND CIDesc LIKE '%访视%' AND CIDesc NOT LIKE '%术前%' AND  CIDesc NOT LIKE '%同意%'
	)
	&sql(open mzshfsjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch mzshfsjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR100018"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR100018"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close mzshfsjlCursor)
	w "麻醉术后访视记录"_return_"条",!
	
	// 30.出院记录	
	Set return=0
	&sql(declare cyjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%出院%' AND CIDesc NOT LIKE '%小结%'
	)
	&sql(open cyjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch cyjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR120001"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR120001"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close cyjlCursor)
	w "出院记录"_return_"条",!
	
	// 31.转诊(院)记录	
	Set return=0
	&sql(declare zzyjlCursor cursor for select %ID,CIDesc,CIEMRCode
		into :ID,:Desc,:EMRCode
		from DHCMA_CPW_KB.ClinItemBase
		where CIDesc LIKE '%转诊%' or CIDesc LIKE '%转院%'
	)
	&sql(open zzyjlCursor)
	Set clinItemArr=##class(%DynamicArray).%New()
	For{
		&sql(fetch zzyjlCursor)
		Quit:(SQLCODE'=0)
		
		Set objItem=##class(DHCMA.CPW.KB.ClinItemBase).%OpenId(ID)
		Continue:'$IsObject(objItem)
		Set:objItem.CIEMRCode'="" objItem.CIEMRCode=objItem.CIEMRCode_","_"EMR130001"
		Set:objItem.CIEMRCode="" objItem.CIEMRCode="EMR130001"
		Set ret=objItem.%Save()
		If '$system.Status.IsError(ret) {
			Set return=return+1	
		}
	}
	&sql(close zzyjlCursor)
	w "转诊(院)记录"_return_"条",!
	
	Quit "ok"
}

/// 更新PDF文档存储字段
/// w ##class(DHCMA.CPW.KBS.HandleEMRCode).AddDocPath()
ClassMethod AddDocPath() As %String
{
	Set count=0
	Set xPath = ""
	For {
		Set xPath = $o(^CT.MA.CPW.KB.PathBaseD(xPath))
		Quit:xPath=""
		
		Set objPath = ##class(DHCMA.CPW.KB.PathBase).%OpenId(xPath)
		Continue:'$IsObject(objPath)
		Set xCode = objPath.PBCode
		Set xDesc = $tr(objPath.PBDesc,"/","")
		Set xFileName=xCode_"-"_xDesc_".pdf"
		Set xDir="D:\DtHealth\app\dthis\web\scripts\DHCMA\CPW\KBDoc\"_xFileName
		If ##class(%File).Exists(xDir){
			Set objPath.PBPDFPath = "/scripts/DHCMA/CPW/KBDoc/"_xFileName
			
			Set sc=objPath.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
		   		Set return=-1
			}else{
				Set return=objPath.%Id()
				Set count = count + 1
			}
			Do objPath.%Close()
		}
	}
	
	Quit count
}

}

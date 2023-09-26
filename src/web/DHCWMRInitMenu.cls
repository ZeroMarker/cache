/// Creator:wangCS
/// CreateDate:2011-10-17
/// Description:DHCMedBase 2.0里面初始化病案菜单
Class web.DHCWMRInitMenu Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// Creator:wangCS
/// CreateDate:2011-10-17
/// Description:初始化病案管理菜单
/// debug: w ##class(web.DHCWMRInitMenu).InitMenuItem()
ClassMethod InitMenuItem()
{
    	w "************初始化病案管理菜单*************",!
		//1:Rowid 2:ProCode 3:ProName 4:ProVersion 5:IconClass 6:ShowIndex 7:ProActive 8:ProResume
		Set IsActive="",ProID=""
		For {
			Set IsActive=$o(^DHCMed.SS.ProductsI("ProductActive","WMR",IsActive))
			Quit:IsActive=""
			Set ProID=$o(^DHCMed.SS.ProductsI("ProductActive","WMR",IsActive,0))
		}
		If ProID="" {
			Set InputStr="^WMR^病案系统管理^v3.1.0^icon-wmr^3^1^" //Modified By LiYang 2011-06-13 增加菜单图标
			set id=##class(DHCMed.SS.Products).Update(InputStr)
		}Else{
			Set InputStr=ProID_"^WMR^病案系统管理^v3.1.0^icon-wmr^3^1^" //Modified By LiYang 2011-06-13 增加菜单图标
			set id=##class(DHCMed.SS.Products).Update(InputStr)
		}
		
		m ^DHCMed.SS.MenusDTMP=^DHCMed.SS.MenusD
		m ^DHCMed.SS.MenusITMP=^DHCMed.SS.MenusI
		&SQL(DELETE FROM DHCMed_SS.Menus WHERE ProductDr=:id)
		
		//1:Rowid 2:MenuCode 3:MenuCaption 4:LinkUrl 5:Expression 6:ProductDr 7:ShowIndex 8:IconClass 9:ParentMenuDr
		//set parent=##class(DHCMed.SS.Menus).Update("^DHCWMR^病案管理^dhc.wmr.discharge.qry.csp^^"_id_"^1^icon-menu^")
		//set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		//set mid=##class(DHCMed.SS.Menus).Update("^DHCWMR^病案管理^dhc.wmr.discharge.qry.csp^^"_id_"^1^icon-menu^"_parent)
		//set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
		
		//**********************************************住院病案接诊**************************************************
		set parent=##class(DHCMed.SS.Menus).Update("^WMRIPNew^住院病案接诊^^^"_id_"^10^^")
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPPaadmQuery^新建病案^dhc.wmr.paadm.query.csp^&MrType=7&AdmTypeFlag=I&WorkItem=&RequestType=&AutoTransfer=&AutoRequest=&MultiAdmit=Y&MRChange=N^"_id_"^110^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPNoSta^新建病案统计^dhc.wmr.no.sta.csp^^"_id_"^120^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPJZQuery^接诊明细查询^dhc.wmr.jzquery.csp^&MrType=7&AdmType=I^"_id_"^130^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPReceiptLog^接诊日志查询^dhc.wmr.receiptlog.qry.csp^&MrType=7&AdmType=I^"_id_"^140^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPXRecpt^接诊工作量统计^dhc.wmr.xrecpt.csp^&MrType=7&AdmType=I&ItemDr=1^"_id_"^150^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		
		//**********************************************住院病案流程**************************************************
		set parent=##class(DHCMed.SS.Menus).Update("^WMRIPOperation^住院病案流程^^^"_id_"^20^^")
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPDischargeQuery^出院病历查询^dhc.wmr.discharge.qry.csp^^"_id_"^210^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPWorkFlowRun^住院病案流程^dhc.wmr.workflow.csp^&MrType=7&AdmType=I^"_id_"^220^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPCurrVolStu^卷当前状态查询^dhcwmrcurrvolstu.csp^&MrType=7&AdmType=I&ItemStr=1|2|8|9|10|11|12^"_id_"^230^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		
		//**********************************************住院病案编目**************************************************
		set parent=##class(DHCMed.SS.Menus).Update("^WMRIPCoding^住院病案编目^^^"_id_"^30^^")
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPCodingInputFP^病案编目录入^dhc.wmr.frontpage.edit.csp^&MrType=7&AdmType=I&WorkItem=&UseHisDiagnose=Y&UseHisOperation=Y^"_id_"^310^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPXVolume^病案编目查询^dhc.wmr.xvolume.csp^&MrType=7&AdmType=I^"_id_"^320^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPCirculQryNotFrontPage^未输病案查询^dhc.wmr.circul.qrynotfrontpage.csp^^"_id_"^330^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)		
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPCirculQryFrontPage^已输病案查询^dhc.wmr.circul.qryfrontpage.csp^^"_id_"^340^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		
		//**********************************************住院病案查询**************************************************
		set parent=##class(DHCMed.SS.Menus).Update("^WMRIPQuery^住院病案查询^^^"_id_"^40^^")
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPStatusInfoB1^已完成操作查询^dhc.wmr.statusinfob.qry.csp^&MrType=7&AdmType=I&HospitalDR=^"_id_"^410^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPQueryMissVolume^未完成操作查询^dhc.wmr.missingvol.csp^&MrType=7&AdmType=I&WorkFlow=1^"_id_"^420^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPMainStayOut^未归架病案查询^dhc.wmr.mainstayout.query.csp^&MrTypeDr=7&IsStayIn=N^"_id_"^430^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)		
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPQueryLendOut^借出病案查询^dhc.wmr.querylendout.csp^&MrType=7&AdmType=I&StatusID=10^"_id_"^440^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPXOneItemTimey^单项跨度查询^dhc.wmr.xoneitmtimeslot.csp^&MrType=7&AdmType=I^"_id_"^450^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPXTowItemTime^两项跨度查询^dhc.wmr.xtowitmtimeslot.csp^&MrType=7&AdmType=I^"_id_"^460^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPMainByNoQry^号码查询病案^dhc.wmr.mainbyno.qry.csp^&MrType=7&AdmType=I^"_id_"^470^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPHistoryQuery^病案综合查询^dhc.wmr.history.query.csp^&MrType=7&AdmType=I^"_id_"^480^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPDelayDischargeQry^延迟出院查询^dhc.wmr.delaydischarge.csp^^"_id_"^490^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		
		//**********************************************住院病案其他功能**************************************************
		set parent=##class(DHCMed.SS.Menus).Update("^WMRIPOtherFunction^住院病案其他功能^^^"_id_"^50^^")
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPXWorkload^工作量统计^dhc.wmr.xworkload.csp^&MrType=7&AdmType=I&ItemStr=1|2|8|9|10|11|12|13^"_id_"^510^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPMRMerger^病案合并转换^dhc.wmr.mrmerger.csp^&MrType=7&AdmType=I^"_id_"^520^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRIPInputHistory^历史信息录入^dhc.wmr.inputhistory.csp^&MrType=7&AdmType=I^"_id_"^530^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSICDQry^ICD字典查询^dhc.wmr.icddic.qry.csp^^"_id_"^540^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		
	    //**********************************************急诊病案管理**************************************************
		set parent=##class(DHCMed.SS.Menus).Update("^WMREPManage^急诊病案管理^^^"_id_"^60^^")
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMREPPaadmQuery^新建急诊病案^dhc.wmr.paadm.query.csp^&MrType=101&AdmTypeFlag=E&WorkItem=16&RequestType=87&AutoTransfer=Y&AutoRequest=Y&MultiAdmit=N&MRChange=N^"_id_"^610^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMREPWorkFlowRun^急诊病案流程^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.WorkFlow.SequenceRun&MrType=101^"_id_"^620^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)		
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMREPMainByNoQry^号码查询病案^dhc.wmr.mainbyno.qry.csp^&MrType=101^"_id_"^630^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMREPHistoryQuery^病案综合查询^dhc.wmr.history.query.csp^&MrType=101&AdmType=E^"_id_"^640^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
			
		
		//**********************************************门诊病案管理**************************************************
		set parent=##class(DHCMed.SS.Menus).Update("^WMROPManage^门诊病案管理^^^"_id_"^70^^")
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMROPReqFirstFlag^病案申请激活^dhc.wmr.reqfirstflag.csp^&OMrType=6&IMrType=7&sWorkItem=16&sReqType=87&AdmType=O^"_id_"^710^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMROPReqQuery^病案申请查询^dhc.wmr.req.query.csp^&TransferItemDr=18&OMrType=6&IMrType=7^"_id_"^720^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)		
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMROPWorkFlowRun^门诊病案流程^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.WorkFlow.SequenceRun&MrType=6^"_id_"^730^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMROPMainByNoQry^号码查询病案^dhc.wmr.mainbyno.qry.csp^&MrType=6^"_id_"^740^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMROPHistoryQuery^病案综合查询^dhc.wmr.history.query.csp^&MrType=6&AdmType=O^"_id_"^750^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMROPMRMerger^病案合并转换^dhc.wmr.mrmerger.csp^&MrType=6&AdmType=O^"_id_"^760^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMROPPaadmQuery^新建门诊病案^dhc.wmr.paadm.query.csp^&MrType=6&AdmTypeFlag=O&WorkItem=16&RequestType=87&AutoTransfer=Y&AutoRequest=Y&MultiAdmit=N&MRChange=N^"_id_"^770^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		
		//******************************************病案系统管理****************************************************
		set parent=##class(DHCMed.SS.Menus).Update("^WMRSYSManage^病案系统维护^^^"_id_"^80^^")
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSDictionary^字典维护^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.Dictionary.List ^"_id_"^810^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSNoType^病案号格式^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.MrNoLen.Edit^"_id_"^820^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)		
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSWorkFlow^工作流维护^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.WorkFlow.List ^"_id_"^830^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSWorkItem^操作项维护^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.WorkItem.List^"_id_"^840^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSICDDictionary^ICD字典维护^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.ICDDx.List^"_id_"^850^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSICDVersion^ICD字典版本^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.ICDVersion.List^"_id_"^860^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSICDExplain^ICD字典注释^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.ICDExplain.List^"_id_"^870^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSEpTemp^首页模板维护^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.FPTemp.List^"_id_"^880^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^WMRSYSFPIDic^首页项目字典^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.FPIDic.List^"_id_"^890^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
		
		/*
		set parent=##class(DHCMed.SS.Menus).Update("^DHCWMRSYSManagement^病案系统管理^^^"_id_"^2^icon-menu^")
		set sid=##class(DHCMed.SS.Security).Update(1,id,parent,1)
		
		set mid2=##class(DHCMed.SS.Menus).Update("^DHCWMRDictionary^字典维护^websys.default.csp^&WEBSYS.TCOMPONENT=DHC.WMR.ICDDx.List^"_id_"^2^icon-menu^"_parent)
		set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
		
		set description="字典维护"
		set cbID=..EPRChartBook("DHC.WMR.Dictionary.Edit","DHC.WMR.Dictionary.List",description,1,"websys.default.csp","0")
		if (cbID<0){
			w !,"菜单"_description_"导入错误"	
		}else{
			set expression="&ChartID="
		    set chartID=..EPRChart(cbID,description,1)
		    if (chartID>0){
				set expression=expression_chartID
				set mid2=##class(DHCMed.SS.Menus).Update("^DHCWMRDictionary^"_description_"^epr.dhcwmr.chart.csp^"_expression_"^"_id_"^2^icon-menu^"_parent)
		        set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
			}
		}
		
		set description="操作项维护"
		set cbID=..EPRChartBook("DHC.WMR.WorkItem.Edit","DHC.WMR.WorkItem.List",description,1,"websys.default.csp","0")
		if (cbID<0){
			w !,"菜单"_description_"导入错误"	
		}else{
			set expression="&ChartID="
		    set chartID=..EPRChart(cbID,description,1)
		    if (chartID>0){
				set expression=expression_chartID
				set mid2=##class(DHCMed.SS.Menus).Update("^DHCWMRWorkItem^"_description_"^epr.dhcwmr.chart.csp^"_expression_"^"_id_"^2^icon-menu^"_parent)
		        set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
			}
		}
		
		set description="操作项维护"
		set cbID=..EPRChartBook("DHC.WMR.WorkItem.Edit","DHC.WMR.WorkItem.List",description,1,"websys.default.csp","0")
		if (cbID<0){
			w !,"菜单"_description_"导入错误"	
		}else{
			set expression="&ChartID="
		    set chartID=..EPRChart(cbID,description,1)
		    if (chartID>0){
				set expression=expression_chartID
				set mid2=##class(DHCMed.SS.Menus).Update("^DHCWMRWorkItem^"_description_"^epr.dhcwmr.chart.csp^"_expression_"^"_id_"^2^icon-menu^"_parent)
		        set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
			}
		}
		
		set description="工作流维护"
		set cbID=..EPRChartBook("DHC.WMR.WorkFlow.Edit","DHC.WMR.WorkFlow.List",description,1,"websys.default.csp","0")
		if (cbID<0){
			w !,"菜单"_description_"导入错误"	
		}else{
			set expression="&ChartID="
		    set chartID=..EPRChart(cbID,description,1)
		    if (chartID>0){
				set expression=expression_chartID
				set mid2=##class(DHCMed.SS.Menus).Update("^DHCWMRWorkFlow^"_description_"^epr.dhcwmr.chart.csp^"_expression_"^"_id_"^2^icon-menu^"_parent)
		        set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
			}
		}	
		
		set description="病案号格式"
		set cbID=..EPRChartBook("","DHC.WMR.MrNoLen.Edit",description,0,"websys.default.csp","0")
		if (cbID<0){
			w !,"菜单"_description_"导入错误"	
		}else{
			set expression="&ChartID="
		    set chartID=..EPRChart(cbID,description,1)
		    if (chartID>0){
				set expression=expression_chartID
				set mid2=##class(DHCMed.SS.Menus).Update("^DHCWMRMrNoLen^"_description_"^epr.dhcwmr.chart.csp^"_expression_"^"_id_"^2^icon-menu^"_parent)
		        set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
			}
		}	
		
		set description="ICD字典维护"
		set cbID=..EPRChartBook("DHC.WMR.ICDDx.Edit","DHC.WMR.ICDDx.List",description,1,"websys.default.csp","0")
		if (cbID<0){
			w !,"菜单"_description_"导入错误"	
		}else{
			set expression="&ChartID="
		    set chartID=..EPRChart(cbID,description,1)
		    if (chartID>0){
				set expression=expression_chartID
				set mid2=##class(DHCMed.SS.Menus).Update("^DHCWMRICDDx^"_description_"^epr.dhcwmr.chart.csp^"_expression_"^"_id_"^2^icon-menu^"_parent)
		        set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)	
			}
		}	
		*/
		w "菜单初始化完毕！",!
		q "OK"
}

/// 描述：图表类型定义
/// debug:w ##Class(web.DHCWMRInitMenu).EPRChartBook("","DHC.WMR.MrNoLen.Edit","病案号格式",0,"websys.default.csp","0")
ClassMethod EPRChartBook(editComponent, listComponent, description, allowAddition, eprurl, isHistoryPage)
{
	;n (editComponent,listComponent,description,allowAddition,eprurl,isHistoryPage)
	set ret=""
	set cId=-100,count=-1
	;&SQL(select EditComponentDR->Name,ListComponentDR->Name,Description,ID into:editName,:listName,:description,:cId from epr.CTEPRPages where description=:description)	
	;if (listName'=listComponent)!(editName'=editComponent){
		//&SQL(select * from websys.component where
		//&SQL(insert into epr.CTEPRPages (AllowAddition,Description,EditComponentDR,IsHistoryPage,ListComponentDR,URL) values(1,:description,:,0,52105,'websys.default.csp')
	;}
	&SQL(select count(*) into :count from epr.CTEPRPages where description=:description and EditComponentDR->Name=:editComponent and ListComponentDR->Name=:listComponent)
	;b ;count
	if (count<1){
		set eprObj=##Class(epr.CTEPRPages).%New()
		if (editComponent'=""){
		   set editObj=##Class(websys.Component).OpenName(editComponent)
		   if ('$IsObject(editObj)){ 
		       w !," 请导入"_editComponent_"组件"
		   }else{
			   set eprObj.EditComponentDR=editObj
		   }
		}
		if (listComponent'=""){
		  set listObj=##Class(websys.Component).OpenName(listComponent)
		  if ('$IsObject(listObj)){ 
		     w !," 请导入"_listComponent_"组件"
		  }else{
			set eprObj.ListComponentDR=listObj
		  }
		}
		;q:ret'="" ret
		set eprObj.Description=description
		set eprObj.AllowAddition=allowAddition
		set eprObj.URL=eprurl
		set eprObj.IsHistoryPage=isHistoryPage
		set retValue=eprObj.%Save()
		if $system.Status.IsError(retValue){
			do $system.OBJ.DisplayError(retValue)
			set cId=-1	
		}else{
			set cId=eprObj.%Id()
		}
		do eprObj.%Close()
	}else{
		&SQL(select top 1 ID into:cId from epr.CTEPRPages where description=:description and EditComponentDR->Name=:editComponent and ListComponentDR->Name=:listComponent)	
	}
    q cId
}

/// 图表定义
/// debug:w ##Class(web.DHCWMRInitMenu).EPRChart(56,"字典维护",1)
ClassMethod EPRChart(cId, description, add)
{
	;n (cId,description,add)
    set count=-1
    set ret=0
	&SQL(select count(*) into:count from epr.chart where name=:description and chartsettings like '%'_:cId_'%')
	if (count<1){
		w !,description_"图表不存在，请先定义图表"
    }else{
		&SQL(select top 1 ID into:ret from epr.chart where name=:description and chartsettings like '%'_:cId_'%')
	}	
	q ret
}

}

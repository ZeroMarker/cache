
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	//报告标题
	var RepTitle = 'HIV个案随访表';
	obj.txtFollowNo = Common_TextField1("txtFollowNo","卡片编号",100,'100%');
	obj.cboFollowStatus=Common_ComboToDic("cboFollowStatus","随访状态","EPDFollowStatus");
	obj.txtFollowTimes= Common_NumberField("txtFollowTimes","随访次数",0,0);
	obj.cboIsCustody= Common_ComboToDic("cboIsCustody","当前是否羁押","EPDIsCheck");
	obj.cboReasons= Common_ComboToDic("cboReasons","失访原因","EPDNotFollowReasons");
	
	//基本信息
	obj.txtPatName=Common_TextField1("txtPatName","患者姓名",40,'80%');
	obj.txtPatSex=Common_TextField1("txtPatSex","患者性别",40,'80%');
	obj.txtParentName=Common_TextField1("txtParentName","患儿家长姓名",40,'80%');
	obj.txtPatNo=Common_TextField1("txtPatNo","身份证号",100,'90%');
	obj.txtPhoneNo=Common_TextField1("txtPhoneNo","联系电话",50,'90%');
	obj.txtAddress=Common_TextField1("txtAddress","现住地址",200,'90%');
	
	//HIV检测信息
	obj.cbgIsHIVTest=Common_RadioGroupToDic("cbgIsHIVTest","本次被诊断为HIV阳性以前是否还做过HIV监测","EPDIsCheck",2);
	obj.chkNeverHIVTest = Common_Checkbox("chkNeverHIVTest","无HIV阴性检测史");
	obj.txtLastHIVTestDate=Common_DateFieldToMonth1("txtLastHIVTestDate","最后一次HIV检测为阴性的时间");
	obj.txtFirstHIVTestDate=Common_DateFieldToMonth1("txtFirstHIVTestDate","第一次HIV检测为阳性的时间");
	obj.txtHIVTestTimes=Common_TextField1("txtHIVTestTimes","第一次HIV检测为阳性之前的24个月中做过HIV检测的次数",10,'45%');
	
	//死亡个案
	obj.cboIsDead=Common_ComboToDic("cboIsDead","是否死亡","EPDIsCheck");
	obj.txtDeathDate = Common_DateFieldToDate1("txtDeathDate","死亡日期");
	obj.cboDeathStage=Common_ComboToDic("cboDeathStage","死亡时病程阶段","EPDDeathStage");
	obj.cboDeathPlace=Common_ComboToDic("cboDeathPlace","死亡地点","EPDDeathPlace");
	obj.txtDeathOtherPlace=Common_TextField1("txtDeathOtherPlace","",80,'100%',"其他死亡地点");
	obj.cbgDeathReasonSource= Common_CheckboxGroupToDic("cbgDeathReasonSource","死因信息收集来源(可多选)","EPDDeathReasonSource",5);
	obj.txtDeathOtherSource=Common_TextField1("txtDeathOtherSource","",80,'80%',"其他信息来源");
	obj.cboDeathReason=Common_ComboToDic("cboDeathReason","主要死因","EPDDeathReason");
	obj.cbgDeathReasonHIV=Common_CheckboxGroupToDic("cbgDeathReasonHIV","艾滋病相关疾病死亡","EPDDeathReasonHIV",3);
	obj.cbgDeathReasonOthers=Common_CheckboxGroupToDic("cbgDeathReasonOthers","艾滋病无关死亡","EPDDeathReasonOthers",4);
	 
	//临床表现
	obj.cboHIVManifestation=Common_CheckboxGroupToDic("cboHIVManifestation","可多选","EPDHIVManifestation",4);
	
	//HIV调查
	obj.cboCourseStage=Common_ComboToDic("cboCourseStage","病程阶段","EPDCourseStage");
	obj.txtHIVDate= Common_DateFieldToDate1("txtHIVDate","艾滋病确诊日期");
	obj.cboSpouseSituation=Common_ComboToDic("cboSpouseSituation","自上次随访以来配偶/固定性伴变化情况","EPDSpouseSituation");
	obj.cboSpouseHIV=Common_ComboToDic("cboSpouseHIV","当前配偶/固定性伴感染状况","EPDSpouseHIV","",'65%');
	obj.txtSpouseHIVDate= Common_DateFieldToDate1("txtSpouseHIVDate","若已检测，检测日期");
	obj.txtSpouseCaseNo=Common_TextField1("txtSpouseCaseNo","若当前配偶/固定性伴感染状况为阳性，其卡片编号为：",100,'100%');
	obj.txtChildren=Common_TextField1("txtChildren","子女检测状况：子女数",10,'90%');
	obj.txtChildren1=Common_TextField1("txtChildren1","，其中阳性人数",10,'90%');
	obj.txtChildren2=Common_TextField1("txtChildren2","，阴性人数",10,'90%');
	obj.txtChildren3=Common_TextField1("txtChildren3","，检测结果不确定人数",10,'90%');
	obj.txtChildren4=Common_TextField1("txtChildren4","，未查/不详人数",10,'90%');
	obj.cboHIVSurvey1=Common_ComboToDic("cboHIVSurvey1","现在是否为同伴教育员","EPDIsCheck");
	obj.cboHIVSurvey2=Common_ComboToDic("cboHIVSurvey2","过去3个月，是否每次发生性行为都用安全套","EPDIsCheckSurvey2","",'95%');
	obj.txtHIVSurvey2No=Common_TextField1("txtHIVSurvey2No","如果回答“否”，在最近3个月与您有过性行为的人数",10,'90%');
	obj.cboHIVSurvey3=Common_ComboToDic("cboHIVSurvey3","过去3个月，是否每次与配偶/固定性伴发生性行为都用安全套","EPDIsCheckSurvey3");
	obj.cboHIVSurvey4=Common_ComboToDic("cboHIVSurvey4","过去3个月，是否共用过注射器注射毒品","EPDIsCheckSurvey4");
	obj.txtHIVSurvey4No=Common_TextField1("txtHIVSurvey4No","如果回答“是”，在最近3个月与您共用过注射器的人数",10,'90%');
	obj.cboHIVSurvey5=Common_ComboToDic("cboHIVSurvey5","过去3个月，是否参加针具交换","EPDIsCheckSurvey4");
	obj.txtHIVSurvey5No=Common_TextField1("txtHIVSurvey5No","如果回答“是”，在最近3个月交出针具支数",10,'90%');
	obj.txtHIVSurvey5No1=Common_TextField1("txtHIVSurvey5No1","换回针具支数",10,'90%');
	obj.cboHIVSurvey6=Common_ComboToDic("cboHIVSurvey6","目前是否接受社区美沙酮维持治疗","EPDIsCheck");
	obj.txtHIVSurvey6No=Common_TextField1("txtHIVSurvey6No","社区美沙酮维持治疗编号",50,'90%');
	obj.cboHIVSurvey7=Common_ComboToDic("cboHIVSurvey7","若为育龄妇女，目前为","EPDIsCheckSurvey7");
	obj.cbgIsHIVSurvey7=Common_ComboToDic("cbgIsHIVSurvey7","若在“孕期”或“产后”，在孕期、产时、产后是否为预防母婴传播服用抗病毒治疗药物","EPDIsCheck");
	obj.txtHIVSurvey8=Common_TextField1("txtHIVSurvey8","过去6个月您或您的家庭是否获得过来自亲戚、朋友以外的其他组织或个人的关怀、支持和服务",0,'0%');
	obj.cboHIVSurvey8a=Common_ComboToDic("cboHIVSurvey8a","宣传咨询(宣传材料、咨询服务)","EPDIsCheck");
	obj.txtHIVSurvey8aNo1=Common_TextField1("txtHIVSurvey8aNo1","获得安全套个数",10,'90%');
	obj.txtHIVSurvey8aNo2=Common_TextField1("txtHIVSurvey8aNo2","获得宣传材料份数",10,'90%');
	obj.cboHIVSurvey8b=Common_ComboToDic("cboHIVSurvey8b","药物提供(提供抗机会性感染药物)","EPDIsCheck");
	obj.cboHIVSurvey8c=Common_ComboToDic("cboHIVSurvey8c","关怀救助(经济支持、生活帮助)","EPDIsCheck");
	obj.cboHIVSurvey9=Common_CheckboxGroupToDic("cboHIVSurvey9","本次随访是否出现以下结核病可疑筛查症状","EPDHIVSurvey9",3);
	obj.cbgIsHIVSurvey10=Common_ComboToDic("cbgIsHIVSurvey10","过去6个月是否接受过结核病检查","EPDIsCheck");
	obj.cboHIVSurvey10=Common_ComboToDic("cboHIVSurvey10","结果","EPDHIVSurvey10");
	obj.cbgIsHIVSurvey11=Common_ComboToDic("cbgIsHIVSurvey11","目前是否接受国家免费艾滋病抗病毒治疗","EPDIsCheck");
	obj.txtIsHIVSurvey11No=Common_TextField1("txtIsHIVSurvey11No","抗病毒治疗编号",10,'90%');
	
	//CD4检测
	obj.txtCD4TestTimes=Common_TextField1("txtCD4TestTimes","自上次随访以来，做过CD4检测次数",10,'90%');
	obj.txtCD4TestResult=Common_TextField1("txtCD4TestResult","最近一次CD4检测结果(个/ul)",10,'90%');
	obj.txtCD4TestDate= Common_DateFieldToDate1("txtCD4TestDate","检测日期");
	obj.txtCD4TestUnit=Common_TextField1("txtCD4TestUnit","检测单位",10,'90%');
	
	//随访信息
	obj.txtSurveyOrgan=Common_TextField1("txtSurveyOrgan","随访单位",10,'90%');
	obj.txtSurveyName=Common_TextField1("txtSurveyName","随访人",10,'90%');
	obj.txtSurveyDate= Common_DateFieldToDate("txtSurveyDate","随访日期");
	obj.txtComments=Common_TextField1("txtComments","备注",10,'90%');
	
	obj.Title_ViewPort = {
		//title : '',
		layout : 'fit',
		//frame : true,
		height : 100,
		anchor : '-20',
		items : [
			{
				layout : 'column',
				frame : true,
				items : [
					{
						columnWidth:.03,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : []
					},{
						columnWidth:.80,
						region: 'center',
						layout : 'form',
						height : 180,
						//frame : true,
						items : [
							{
								layout : 'form',
								width : 500,
								labelWidth : 60,
								labelAlign : 'left',
								items : [
									obj.txtFollowNo
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.28,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.cboFollowStatus,obj.cboReasons]
									},{
										columnWidth:.15,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.txtFollowTimes]
									},{
										columnWidth:.15,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 80,
										items : [obj.cboIsCustody]
									}
								]
							}
						]
					}
				]
			}
		]
	}
	
	obj.BaseInfo_ViewPort = {
		//title : '',
		layout : 'fit',
		//frame : true,
		height : 130,
		anchor : '-20',
		items : [
			{
				layout : 'column',
				frame : true,
				items : [
					{
						columnWidth:.03,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : []
					},{
						columnWidth:.80,
						region: 'center',
						layout : 'form',
						height : 180,
						//frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth:.40,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.txtPatName,obj.txtPatNo,obj.txtPhoneNo]
									},{
										columnWidth:.40,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 80,
										items : [obj.txtParentName,obj.txtPatSex]
									}
								]
							},{
								layout : 'form',
								width : 800,
								labelWidth : 60,
								labelAlign : 'left',
								items : [
									obj.txtAddress
								]
							}
						]
					}
				]
			}
		]
	}
	
	obj.HIVTest_ViewPort = {
		//title : '',
		layout : 'fit',
		//frame : true,
		height : 130,
		anchor : '-20',
		items : [
			{
				layout : 'column',
				frame : true,
				items : [
					{
						columnWidth:.03,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : []
					},{
						columnWidth:.80,
						region: 'center',
						layout : 'form',
						height : 180,
						//frame : true,
						items : [
							{
								layout : 'form',
								width : 380,
								labelWidth : 260,
								labelAlign : 'left',
								items : [
									obj.cbgIsHIVTest
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.40,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 220,
										items : [obj.txtLastHIVTestDate,obj.txtFirstHIVTestDate]
									},{
										columnWidth:.40,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 120,
										items : [obj.chkNeverHIVTest]
									},{
										columnWidth:.12,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 120,
										html : '<b><h1>' + '一个病例只需要填写一次' + '</h1></b>'
									}
								]
							},{
								layout : 'form',
								width : 800,
								labelWidth : 320,
								labelAlign : 'left',
								items : [
									obj.txtHIVTestTimes
								]
							}
						]
					}
				]
			}
		]
	}
	
	obj.DeathInfo_ViewPort = {
		//title : '',
		layout : 'fit',
		//frame : true,
		height : 620,
		anchor : '-20',
		items : [
			{
				layout : 'column',
				frame : true,
				items : [
					{
						columnWidth:.03,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : []
					},{
						columnWidth:.80,
						region: 'center',
						layout : 'form',
						height : 700,
						//frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth:.25,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.cboIsDead,obj.cboDeathStage]
									},{
										columnWidth:.25,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.txtDeathDate,obj.cboDeathPlace]
									},{
										columnWidth:.35,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.cboDeathReason,obj.txtDeathOtherPlace]
									}
								]
							},{
								layout : 'form',
								labelAlign : 'left',
								labelWidth : 100,
								items : [obj.cbgDeathReasonSource,obj.txtDeathOtherSource]
							},{
								layout : 'form',
								width : 900,
								labelWidth : 60,
								labelAlign : 'left',
								items : [
									obj.cbgDeathReasonHIV
								]
							},{
								layout : 'form',
								width : 870,
								labelWidth : 60,
								labelAlign : 'left',
								items : [
									obj.cbgDeathReasonOthers
								]
							}
						]
					}
				]
			}
		]
	}
	
	obj.HIVManifest_ViewPort = {
		//title : '',
		layout : 'fit',
		//frame : true,
		height : 140,
		anchor : '-20',
		tbar : ['过去6个月有无以下艾滋病相关临床表现'],
		items : [
			{
				layout : 'column',
				frame : true,
				items : [
					{
						columnWidth:.03,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : []
					},{
						columnWidth:.85,
						region: 'center',
						layout : 'form',
						height : 140,
						//frame : true,
						labelWidth : 60,
						items : [
							obj.cboHIVManifestation
						]
					}
				]
			}
		]
	}
	
	obj.HIVSurvey_ViewPort = {
		//title : '',
		layout : 'fit',
		//frame : true,
		height : 570,
		anchor : '-20',
		items : [
			{
				layout : 'column',
				frame : true,
				items : [
					{
						columnWidth:.03,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : []
					},{
						columnWidth:.85,
						region: 'center',
						layout : 'form',
						height : 950,
						//frame : true,
						labelWidth : 60,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth:.23,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 60,
										items : [obj.cboCourseStage]
									},{
										columnWidth:.22,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 100,
										items : [obj.txtHIVDate]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.42,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 125,
										items : [obj.cboSpouseSituation]
									},{
										columnWidth:.45,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 160,
										items : [obj.cboSpouseHIV]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.28,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 155,
										items : [obj.txtSpouseHIVDate]
									},{
										columnWidth:.65,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 340,
										items : [obj.txtSpouseCaseNo]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.20,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 130,
										items : [obj.txtChildren]
									},{
										columnWidth:.15,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 95,
										items : [obj.txtChildren1]
									},{
										columnWidth:.12,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 68,
										items : [obj.txtChildren2]
									},{
										columnWidth:.20,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 128,
										items : [obj.txtChildren3]
									},{
										columnWidth:.18,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 98,
										items : [obj.txtChildren4]
									}
								]
							},{
								layout : 'form',
								width : 250,
								labelWidth : 130,
								labelAlign : 'left',
								items : [obj.cboHIVSurvey1]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.45,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 260,
										items : [obj.cboHIVSurvey2]
									},{
										columnWidth:.42,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 300,
										items : [obj.txtHIVSurvey2No]
									}
								]
							},{
								layout : 'form',
								width : 460,
								labelWidth : 340,
								labelAlign : 'left',
								items : [obj.cboHIVSurvey3]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.38,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 220,
										items : [obj.cboHIVSurvey4]
									},{
										columnWidth:.45,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 320,
										items : [obj.txtHIVSurvey4No]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.32,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 180,
										items : [obj.cboHIVSurvey5]
									},{
										columnWidth:.35,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 250,
										items : [obj.txtHIVSurvey5No]
									},{
										columnWidth:.18,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 80,
										items : [obj.txtHIVSurvey5No1]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.30,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 195,
										items : [obj.cboHIVSurvey6]
									},{
										columnWidth:.45,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 160,
										items : [obj.txtHIVSurvey6No]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.25,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 140,
										items : [obj.cboHIVSurvey7]
									},{
										columnWidth:.65,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 515,
										items : [obj.cbgIsHIVSurvey7]
									}
								]
							},{
								layout : 'form',
								width : 550,
								labelWidth : 520,
								labelAlign : 'left',
								items : [obj.txtHIVSurvey8]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.33,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 235,
										items : [obj.cboHIVSurvey8a]
									},{
										columnWidth:.16,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 100,
										items : [obj.txtHIVSurvey8aNo1]
									},{
										columnWidth:.18,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 120,
										items : [obj.txtHIVSurvey8aNo2]
									}
								]	
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.33,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 240,
										items : [obj.cboHIVSurvey8b]
									},{
										columnWidth:.30,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 185,
										items : [obj.cboHIVSurvey8c]
									}
								]	
							},{
								layout : 'form',
								width : 730,
								labelWidth : 240,
								labelAlign : 'left',
								items : [obj.cboHIVSurvey9]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.30,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 195,
										items : [obj.cbgIsHIVSurvey10]
									},{
										columnWidth:.25,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 55,
										items : [obj.cboHIVSurvey10]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.35,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 225,
										items : [obj.cbgIsHIVSurvey11]
									},{
										columnWidth:.45,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 149,
										items : [obj.txtIsHIVSurvey11No]
									}
								]
							}
						]
					}
				]
			}
		]
	}
	
	obj.CD4Test_ViewPort = {
		//title : '',
		layout : 'fit',
		//frame : true,
		height : 70,
		anchor : '-20',
		items : [
			{
				layout : 'column',
				frame : true,
				items : [
					{
						columnWidth:.03,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : []
					},{
						columnWidth:.85,
						region: 'center',
						layout : 'form',
						height : 70,
						//frame : true,
						labelWidth : 60,
						items : [
							{
								layout : 'form',
								width : 350,
								labelWidth : 220,
								labelAlign : 'left',
								items : [
									obj.txtCD4TestTimes
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.35,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 200,
										items : [obj.txtCD4TestResult]
									},{
										columnWidth:.20,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.txtCD4TestDate]
									},{
										columnWidth:.20,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.txtCD4TestUnit]
									}
								]
							}
						]
					}
				]
			}
		]
	}
	
	obj.SurveyInfo_ViewPort = {
		//title : '',
		layout : 'fit',
		//frame : true,
		height : 70,
		anchor : '-20',
		items : [
			{
				layout : 'column',
				frame : true,
				items : [
					{
						columnWidth:.03,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : []
					},{
						columnWidth:.85,
						region: 'center',
						layout : 'form',
						height : 70,
						//frame : true,
						labelWidth : 60,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth:.40,
										layout : 'form',
										labelAlign : 'left',
										labelWidth : 60,
										items : [obj.txtSurveyOrgan]
									},{
										columnWidth:.20,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.txtSurveyName]
									},{
										columnWidth:.18,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [obj.txtSurveyDate]
									}
								]
							},{
								layout : 'form',
								width : 800,
								labelWidth : 40,
								labelAlign : 'left',
								items : [
									obj.txtComments
								]
							}
						]
					}
				]
			}
		]
	}
	
	//初始化界面模块
	var arrTabItems = [];
	arrTabItems = arrTabItems.concat([obj.Title_ViewPort]);
	arrTabItems = arrTabItems.concat([obj.BaseInfo_ViewPort]);
	arrTabItems = arrTabItems.concat([obj.HIVTest_ViewPort]);
	arrTabItems = arrTabItems.concat([obj.DeathInfo_ViewPort]);
	arrTabItems = arrTabItems.concat([obj.HIVManifest_ViewPort]);
	arrTabItems = arrTabItems.concat([obj.HIVSurvey_ViewPort]);
	arrTabItems = arrTabItems.concat([obj.CD4Test_ViewPort]);
	arrTabItems = arrTabItems.concat([obj.SurveyInfo_ViewPort]);
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 75
		,text : '保存'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 75
		,text : '删除'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 75
		,text : '导出'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 75
		,text : '打印'
	});
	
	//界面整体布局
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort',
		layout : 'border',
		items : [
			{
				region : 'north',
				layout : 'form',
				height : 45,
				frame : true,
				html : '<table border="0" width="100%" height="100%"><tr><td align="center" ><big><b>' + RepTitle + '</b></big></td></tr></table>'
			},{
				region : 'center',
				layout : 'anchor',
				autoScroll : true,
				items : arrTabItems,
				bbar : ['->',obj.btnSave,obj.btnDelete,obj.btnExport,obj.btnPrint]
			}
		]
	});
	
	InitViewPortEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
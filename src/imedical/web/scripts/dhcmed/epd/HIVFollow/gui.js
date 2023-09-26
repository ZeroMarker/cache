
function InitViewPort()
{
	var obj = new Object();
	obj.ReportID=ReportID;
	
	//�������
	var RepTitle = 'HIV������ñ�';
	obj.txtFollowNo = Common_TextField1("txtFollowNo","��Ƭ���",100,'100%');
	obj.cboFollowStatus=Common_ComboToDic("cboFollowStatus","���״̬","EPDFollowStatus");
	obj.txtFollowTimes= Common_NumberField("txtFollowTimes","��ô���",0,0);
	obj.cboIsCustody= Common_ComboToDic("cboIsCustody","��ǰ�Ƿ��Ѻ","EPDIsCheck");
	obj.cboReasons= Common_ComboToDic("cboReasons","ʧ��ԭ��","EPDNotFollowReasons");
	
	//������Ϣ
	obj.txtPatName=Common_TextField1("txtPatName","��������",40,'80%');
	obj.txtPatSex=Common_TextField1("txtPatSex","�����Ա�",40,'80%');
	obj.txtParentName=Common_TextField1("txtParentName","�����ҳ�����",40,'80%');
	obj.txtPatNo=Common_TextField1("txtPatNo","���֤��",100,'90%');
	obj.txtPhoneNo=Common_TextField1("txtPhoneNo","��ϵ�绰",50,'90%');
	obj.txtAddress=Common_TextField1("txtAddress","��ס��ַ",200,'90%');
	
	//HIV�����Ϣ
	obj.cbgIsHIVTest=Common_RadioGroupToDic("cbgIsHIVTest","���α����ΪHIV������ǰ�Ƿ�����HIV���","EPDIsCheck",2);
	obj.chkNeverHIVTest = Common_Checkbox("chkNeverHIVTest","��HIV���Լ��ʷ");
	obj.txtLastHIVTestDate=Common_DateFieldToMonth1("txtLastHIVTestDate","���һ��HIV���Ϊ���Ե�ʱ��");
	obj.txtFirstHIVTestDate=Common_DateFieldToMonth1("txtFirstHIVTestDate","��һ��HIV���Ϊ���Ե�ʱ��");
	obj.txtHIVTestTimes=Common_TextField1("txtHIVTestTimes","��һ��HIV���Ϊ����֮ǰ��24����������HIV���Ĵ���",10,'45%');
	
	//��������
	obj.cboIsDead=Common_ComboToDic("cboIsDead","�Ƿ�����","EPDIsCheck");
	obj.txtDeathDate = Common_DateFieldToDate1("txtDeathDate","��������");
	obj.cboDeathStage=Common_ComboToDic("cboDeathStage","����ʱ���̽׶�","EPDDeathStage");
	obj.cboDeathPlace=Common_ComboToDic("cboDeathPlace","�����ص�","EPDDeathPlace");
	obj.txtDeathOtherPlace=Common_TextField1("txtDeathOtherPlace","",80,'100%',"���������ص�");
	obj.cbgDeathReasonSource= Common_CheckboxGroupToDic("cbgDeathReasonSource","������Ϣ�ռ���Դ(�ɶ�ѡ)","EPDDeathReasonSource",5);
	obj.txtDeathOtherSource=Common_TextField1("txtDeathOtherSource","",80,'80%',"������Ϣ��Դ");
	obj.cboDeathReason=Common_ComboToDic("cboDeathReason","��Ҫ����","EPDDeathReason");
	obj.cbgDeathReasonHIV=Common_CheckboxGroupToDic("cbgDeathReasonHIV","���̲���ؼ�������","EPDDeathReasonHIV",3);
	obj.cbgDeathReasonOthers=Common_CheckboxGroupToDic("cbgDeathReasonOthers","���̲��޹�����","EPDDeathReasonOthers",4);
	 
	//�ٴ�����
	obj.cboHIVManifestation=Common_CheckboxGroupToDic("cboHIVManifestation","�ɶ�ѡ","EPDHIVManifestation",4);
	
	//HIV����
	obj.cboCourseStage=Common_ComboToDic("cboCourseStage","���̽׶�","EPDCourseStage");
	obj.txtHIVDate= Common_DateFieldToDate1("txtHIVDate","���̲�ȷ������");
	obj.cboSpouseSituation=Common_ComboToDic("cboSpouseSituation","���ϴ����������ż/�̶��԰�仯���","EPDSpouseSituation");
	obj.cboSpouseHIV=Common_ComboToDic("cboSpouseHIV","��ǰ��ż/�̶��԰��Ⱦ״��","EPDSpouseHIV","",'65%');
	obj.txtSpouseHIVDate= Common_DateFieldToDate1("txtSpouseHIVDate","���Ѽ�⣬�������");
	obj.txtSpouseCaseNo=Common_TextField1("txtSpouseCaseNo","����ǰ��ż/�̶��԰��Ⱦ״��Ϊ���ԣ��俨Ƭ���Ϊ��",100,'100%');
	obj.txtChildren=Common_TextField1("txtChildren","��Ů���״������Ů��",10,'90%');
	obj.txtChildren1=Common_TextField1("txtChildren1","��������������",10,'90%');
	obj.txtChildren2=Common_TextField1("txtChildren2","����������",10,'90%');
	obj.txtChildren3=Common_TextField1("txtChildren3","���������ȷ������",10,'90%');
	obj.txtChildren4=Common_TextField1("txtChildren4","��δ��/��������",10,'90%');
	obj.cboHIVSurvey1=Common_ComboToDic("cboHIVSurvey1","�����Ƿ�Ϊͬ�����Ա","EPDIsCheck");
	obj.cboHIVSurvey2=Common_ComboToDic("cboHIVSurvey2","��ȥ3���£��Ƿ�ÿ�η�������Ϊ���ð�ȫ��","EPDIsCheckSurvey2","",'95%');
	obj.txtHIVSurvey2No=Common_TextField1("txtHIVSurvey2No","����ش𡰷񡱣������3���������й�����Ϊ������",10,'90%');
	obj.cboHIVSurvey3=Common_ComboToDic("cboHIVSurvey3","��ȥ3���£��Ƿ�ÿ������ż/�̶��԰鷢������Ϊ���ð�ȫ��","EPDIsCheckSurvey3");
	obj.cboHIVSurvey4=Common_ComboToDic("cboHIVSurvey4","��ȥ3���£��Ƿ��ù�ע����ע�䶾Ʒ","EPDIsCheckSurvey4");
	obj.txtHIVSurvey4No=Common_TextField1("txtHIVSurvey4No","����ش��ǡ��������3�����������ù�ע����������",10,'90%');
	obj.cboHIVSurvey5=Common_ComboToDic("cboHIVSurvey5","��ȥ3���£��Ƿ�μ���߽���","EPDIsCheckSurvey4");
	obj.txtHIVSurvey5No=Common_TextField1("txtHIVSurvey5No","����ش��ǡ��������3���½������֧��",10,'90%');
	obj.txtHIVSurvey5No1=Common_TextField1("txtHIVSurvey5No1","�������֧��",10,'90%');
	obj.cboHIVSurvey6=Common_ComboToDic("cboHIVSurvey6","Ŀǰ�Ƿ����������ɳͪά������","EPDIsCheck");
	obj.txtHIVSurvey6No=Common_TextField1("txtHIVSurvey6No","������ɳͪά�����Ʊ��",50,'90%');
	obj.cboHIVSurvey7=Common_ComboToDic("cboHIVSurvey7","��Ϊ���举Ů��ĿǰΪ","EPDIsCheckSurvey7");
	obj.cbgIsHIVSurvey7=Common_ComboToDic("cbgIsHIVSurvey7","���ڡ����ڡ��򡰲��󡱣������ڡ���ʱ�������Ƿ�ΪԤ��ĸӤ�������ÿ���������ҩ��","EPDIsCheck");
	obj.txtHIVSurvey8=Common_TextField1("txtHIVSurvey8","��ȥ6�����������ļ�ͥ�Ƿ��ù��������ݡ����������������֯����˵Ĺػ���֧�ֺͷ���",0,'0%');
	obj.cboHIVSurvey8a=Common_ComboToDic("cboHIVSurvey8a","������ѯ(�������ϡ���ѯ����)","EPDIsCheck");
	obj.txtHIVSurvey8aNo1=Common_TextField1("txtHIVSurvey8aNo1","��ð�ȫ�׸���",10,'90%');
	obj.txtHIVSurvey8aNo2=Common_TextField1("txtHIVSurvey8aNo2","����������Ϸ���",10,'90%');
	obj.cboHIVSurvey8b=Common_ComboToDic("cboHIVSurvey8b","ҩ���ṩ(�ṩ�������Ը�Ⱦҩ��)","EPDIsCheck");
	obj.cboHIVSurvey8c=Common_ComboToDic("cboHIVSurvey8c","�ػ�����(����֧�֡��������)","EPDIsCheck");
	obj.cboHIVSurvey9=Common_CheckboxGroupToDic("cboHIVSurvey9","��������Ƿ�������½�˲�����ɸ��֢״","EPDHIVSurvey9",3);
	obj.cbgIsHIVSurvey10=Common_ComboToDic("cbgIsHIVSurvey10","��ȥ6�����Ƿ���ܹ���˲����","EPDIsCheck");
	obj.cboHIVSurvey10=Common_ComboToDic("cboHIVSurvey10","���","EPDHIVSurvey10");
	obj.cbgIsHIVSurvey11=Common_ComboToDic("cbgIsHIVSurvey11","Ŀǰ�Ƿ���ܹ�����Ѱ��̲�����������","EPDIsCheck");
	obj.txtIsHIVSurvey11No=Common_TextField1("txtIsHIVSurvey11No","���������Ʊ��",10,'90%');
	
	//CD4���
	obj.txtCD4TestTimes=Common_TextField1("txtCD4TestTimes","���ϴ��������������CD4������",10,'90%');
	obj.txtCD4TestResult=Common_TextField1("txtCD4TestResult","���һ��CD4�����(��/ul)",10,'90%');
	obj.txtCD4TestDate= Common_DateFieldToDate1("txtCD4TestDate","�������");
	obj.txtCD4TestUnit=Common_TextField1("txtCD4TestUnit","��ⵥλ",10,'90%');
	
	//�����Ϣ
	obj.txtSurveyOrgan=Common_TextField1("txtSurveyOrgan","��õ�λ",10,'90%');
	obj.txtSurveyName=Common_TextField1("txtSurveyName","�����",10,'90%');
	obj.txtSurveyDate= Common_DateFieldToDate("txtSurveyDate","�������");
	obj.txtComments=Common_TextField1("txtComments","��ע",10,'90%');
	
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
										html : '<b><h1>' + 'һ������ֻ��Ҫ��дһ��' + '</h1></b>'
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
		tbar : ['��ȥ6�����������°��̲�����ٴ�����'],
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
	
	//��ʼ������ģ��
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
		,text : '����'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 75
		,text : 'ɾ��'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 75
		,text : '����'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 75
		,text : '��ӡ'
	});
	
	//�������岼��
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
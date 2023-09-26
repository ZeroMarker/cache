var objScreen = new Object();
function InitClinRepToAdm(){
	var obj = objScreen;
	
	obj.RepTypeList = new Array();
	var arrRepType = RepTypeList.split(',');
	for (var indRepType = 0; indRepType < arrRepType.length; indRepType++) {
		var tmpReport = arrRepType[indRepType];
		if (!tmpReport) continue;
		var arrTmp = tmpReport.split('-');
		if (arrTmp.length < 3) continue;
		obj.RepTypeList[indRepType] = {
			TypeCate : arrTmp[0],
			TypeCode : arrTmp[1],
			TypeDesc : arrTmp[2],
			ReportList : new Array(),
			ReportCount : 0
		}
	}
	
	var htmlMainPanel = '';
	if (obj.RepTypeList.length < 1) { 
		htmlMainPanel += ''
		+ '<table style="border:1px solid #F78181;width=100%;">'
		+ 	'<tr>'
		+ 		'<td style="width:15%;font-family:verdana;color:#FFFFFF;font-size:18px;background-color:#4499EE;" align="center">δ���ñ���</td>'
		+ 		'<td style="width:15%;font-family:verdana;color:#FFFFFF;font-size:18px;background-color:#4C4C4C;" align="center">δ���ñ���</td>'
		+ 		'<td style="width:15%;font-family:verdana;color:#FFFFFF;font-size:18px;background-color:#4C4C4C;" align="center">δ���ñ���</td>'
		+ 		'<td style="width:15%;font-family:verdana;color:#FFFFFF;font-size:18px;background-color:#4C4C4C;" align="center">δ���ñ���</td>'
		+ 		'<td style="width:15%;font-family:verdana;color:#FFFFFF;font-size:18px;background-color:#4C4C4C;" align="center">δ���ñ���</td>'
		+ 	'</tr>'
		+ '</table>'
	} else {
		if (obj.RepTypeList.length > 1){
			var TDIndex = 0;
			htmlMainPanel += ''
			+ '<table cellspacing="10" style="border:0px solid wight;">'
			+	'<tr>'
			+		'<td id="tdRepType' + TDIndex + '" class="title_button" onclick="objScreen.btnRepType_OnClick(' + -1 + ');"'
			+		' align="center"><b>ȫ��</b></td>'
			for (var indRepType = 0; indRepType < obj.RepTypeList.length; indRepType++) {
				var indNumber = indRepType+1;
				//if ((indNumber%5) == 0) htmlMainPanel += '<tr>';
				var objRepType = obj.RepTypeList[indRepType];
				TDIndex = indRepType+1;
				htmlMainPanel += '<td id="tdRepType' + TDIndex + '" class="title_button"  onclick="objScreen.btnRepType_OnClick(' + indRepType + ');"'
							+ ' align="center"><b>' + objRepType.TypeDesc + '</b></td>';
				//if ((indNumber%5) == 4) htmlMainPanel += '</tr>';
			}
			/* if ((indNumber%5) < 4) {
				for (var indTmp = 0; indTmp < (4-(indNumber%5)); indTmp++) {
					htmlMainPanel += '<td '
					+ 'style="font-family:verdana;color:#FFFFFF;font-size:18px;background-color:#4C4C4C;cursor:pointer; align="center">&nbsp;</td>';
				}
				htmlMainPanel += '</tr>';
			} */
			htmlMainPanel += '</table>';
		}
	}
	htmlMainPanel += '<div id="RepXTemplateDIV"></div>';
	htmlMainPanel += '<div id="ErrXTemplateDIV"></div>';
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,autoScroll : true
		//,frame : true
		,html : htmlMainPanel
	});
	
	obj.ClinRepToAdmWin = new Ext.Viewport({
		id : 'ClinRepToAdmWin'
		,layout : 'fit'
		,items:[
			obj.MainPanel
		]
	});

	obj.RepXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<div style="border:0px solid wight;padding:3px;width:100%;">',
			
			//��Ⱦ������ڶ����б���ʾ
			'<tpl if="(TypeCate==\'EPD\')&&(TypeCode==\'2\')">',
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							 '<td width="20%" class="subtotal_td">{TypeDesc}��&nbsp;&nbsp;<span class="subtotal_number">��{ReportCount}��</span>&nbsp;&nbsp;</td>',
							 '<td>',
								//'<span class="subtotal_button" onclick="{[this.OpenNewReportWinByComA(values)]}">�ν�˲���ת�ﵥ</span>',
								//'<span class="subtotal_button" onclick="{[this.OpenNewReportWinByCom(values)]}">��Ⱦ������</span>',
								'<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.OpenNewReportWinByCom(values)]}">��Ⱦ������</span>',
							 '</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">�ǼǺ�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�Ա�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�����ܼ�</td>',
						'<td align="center" class="List_td">���˼���</td>',
						'<td align="center" class="List_td">ID</td>',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">״̬</td>',
						'<td align="center" class="List_td">ԭ��</td>',
						'<td align="center" class="List_td">����ʱ��</td>',
						'<td align="center" class="List_td">������</td>',
						'<td align="center" class="List_td">���ʱ��</td>',
						'<td align="center" class="List_td">�����</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="center">{RegNo}</td>',
								'<td align="left">{PatientName}</td>',
								'<td align="center">{Sex}</td>',
								'<td align="center">{Age}</td>',
								'<td align="center">{EncryptLevel}</td>',
								'<td align="center">{PatLevel}</td>',
								//'<td align="center" style="cursor:pointer;"> <span onclick="{[this.OpenReportWinByCom(\'EPD\',\'2\',values)]}" style="border-bottom:1px #F78181 solid;">{RepNo}</span></td>',
								'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenReportWinByCom(\'EPD\',\'2\',values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{RepNo}</span>':'{RepNo}') + '</td>',
								'<td align="left">{DiseaseName}</td>',
								'<td align="center">{Status}</td>',
								'<td align="left">{DelReason}</td>',
								'<td align="center">{RepDate} {RepTime}</td>',
								'<td align="center">{RepUserName}</td>',
								'<td align="center">{CheckDate} {CheckTime}</td>',
								'<td align="center">{CheckUserName}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,15) ]}',            //fix by pylian������벡���ܼ�ʱ���ֵ�ɫ����
					'</tbody>',
				'</table>',
			'</tpl>',
			
			//Ժ�й���������б���ʾ
			'<tpl if="(TypeCate==\'INF\')&&(TypeCode==\'3\')">',
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							 '<td width="20%" class="subtotal_td">{TypeDesc}��&nbsp;&nbsp;<span class="subtotal_number">��{ReportCount}��</span>&nbsp;&nbsp;</td>',
							 '<td>',
								'<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.OpenNewReportWinByTp(values,\"OPR\")]}">�����пڼ��</span>',
								'<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.OpenNewReportWinByTp(values,\"ICU\")]}">ICU��Ⱦ���</span>',
								'<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.OpenNewReportWinByTp(values,\"NICU\")]}">NICU��Ⱦ���</span>',
								'<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.OpenNewReportWinByTp(values,\"NCOM\")]}">��������Ⱦ����</span>',
								'<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.OpenNewReportWinByTp(values,\"COMP\")]}" >ҽԺ��Ⱦ����</span>',
							 '</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">�ǼǺ�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�Ա�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�����ܼ�</td>',
						'<td align="center" class="List_td">���˼���</td>',
						'<td align="center" class="List_td">ID</td>',
						'<td align="center" class="List_td">��������</td>',
						'<td align="center" class="List_td">״̬</td>',
						//'<td align="center" class="List_td">�������</td>',
						//'<td align="center" class="List_td">����ʱ��</td>',
						//'<td align="center" class="List_td">������</td>',
						'<td align="center" class="List_td">��Ⱦ��λ</td>',
						'<td align="center" class="List_td">��Ⱦ����</td>',
						'<td align="center" class="List_td">��Ⱦ���</td>',
						'<td align="center" class="List_td">����걾</td>',
						'<td align="center" class="List_td">��ԭ��</td>',
						//'<td align="center" class="List_td">��ע</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="center">{RegNo}</td>',
								'<td align="center">{PatName}</td>',
								'<td align="center">{Sex}</td>',
								'<td align="center">{Age}</td>',
								'<td align="center">{EncryptLevel}</td>',
								'<td align="center">{PatLevel}</td>',
								//'<td align="center" style="cursor:pointer;" onclick="{[this.OpenReportWinByTp(\'INF\',\'3\',values)]}"><span style="border-bottom:1px #F78181 solid;">{ReportID}</td>',
								'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenReportWinByTp(\'INF\',\'3\',values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{ReportID}</span>':'{ReportID}') + '</td>',
								'<td align="center">{ReportTypeDesc}</td>',
								'<td align="center">{ReportStatusDesc}</td>',
								//'<td align="center">{ReportLocDesc}</td>',
								//'<td align="center">{ReportDate} {ReportTime}</td>',
								//'<td align="center">{ReportUserDesc}</td>',
								'<td align="center">{InfPos}</td>',
								'<td align="center">{InfDate}</td>',
								'<td align="center">{InfDiag}</td>',
								'<td align="center">{Specimen}</td>',
								'<td align="center">{TestResults}</td>',     //fix bug 8305 by pyian 2015-03-28 ҽԺ��Ⱦ����-��ԭ�岻Ϊ�յĸ�Ⱦ���没ԭ����ʾΪ��
								//'<td align="center">{LogResume}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,15)]}',
					'</tbody>',
				'</table>',
				
				//���Ʋ������ü�¼
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							 '<td width="20%" class="subtotal_td">���Ʋ������ã�&nbsp;&nbsp;<span class="subtotal_number">��{InfCasesCount}��</span>&nbsp;&nbsp;</td>',
							 '<td>',
								'<span class="subtotal_button_Oper NINFOper4" onclick="{[this.ViewInfBaseInfo()]}">ժҪ��Ϣ</span>',
							//	'<span class="subtotal_button_Oper NINFOper3" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.InfCasesOperClick(5)]}">��Ⱦ����</span>', //modify by mxp 20170628 ȥ������Ⱦ����������
								'<span class="subtotal_button_Oper NINFOper2" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.InfCasesOperClick(1)]}">�ų�</span>',
								'<span class="subtotal_button_Oper NINFOper1" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.InfCasesOperClick(3)]}">ȷ��</span>',
							 '</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">���ò���</td>',
						'<td align="center" class="List_td">��������</td>',
						'<td align="center" class="List_td">������</td>',
						'<td align="center" class="List_td">�������</td>',
						'<td align="center" class="List_td">Ŀ�����</td>',
						'<td align="center" class="List_td">����ҽ��</td>',
						'<td align="center" class="List_td">��������</td>',
						'<td align="center" class="List_td">ȷ������</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="InfCasesList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="center">{Operation}</td>',
								'<td align="center">{ActDate} {ActTime}</td>',
								'<td align="center">{ActUser}</td>',
								'<td align="',
									'<tpl if="(HandleType==\'HA\')">left</tpl>',
									'<tpl if="(HandleType==\'HB\')">right</tpl>',
								'" ondblclick="{[ this.TableOnDblClick(values)]}">{Opinion}</td>',
								'<td align="center">{TargetDept}/{TargetWard}</td>',
								'<td align="center">{TargetDoc}</td>',
								'<td align="center">{CasesXDate}</td>',
								'<td align="center">{InfDays}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRowB(values,9) ]}',
					'</tbody>',
				'</table>',
				/* update by zf 2014-09-02
				'<div id="divInfCtlResult" style="border:3px white solid;margin-left:0%;width:100%;display:block;">',
					'<div id="divInfCtlResult-scroll" style="border:1px #BDBDBD solid;overflow:auto;overflow-y:auto;overflow-x:hidden;width:100%;">',
					'<table id="divInfCtlResult-table" width="{[ this.GetTableWidth(values) ]}" cellpadding="0" cellspacing="0" border="0">',
						'{[ this.Gettable_header(values) ]}',
						'<tpl for="CtlRstList">',
							'{[ this.GetTableData(values) ]}',
						'</tpl>',
					'</table>',
					'</div>',
					'<div id="divInfCtlResult-x-scroll" style="border:0px solid;overflow:auto;overflow-x:auto;overflow-y:hidden;width:100%;height:16px">',
						'<table id="divInfCtlResult-x-table" style="border:0px solid;"><tr><td></td></tr></table>',
					'</div>',
				'</div>',
				*/
			'</tpl>',
			
			//ҽԺ��Ⱦ����V4.0�б���ʾ
			'<tpl if="(TypeCate==\'HAI\')&&(TypeCode==\'1\')">',
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							 '<td width="20%" class="subtotal_td">{TypeDesc}��&nbsp;&nbsp;<span class="subtotal_number">��{ReportCount}��</span>&nbsp;&nbsp;</td>',
							 '<td>',
								'<span class="subtotal_button" onclick="{[this.OpenHAIReport(values,\"1\")]}">ҽԺ��Ⱦ����</span>',
							 '</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td"><b>���</b></td>',
						'<td align="center" class="List_td"><b>�ǼǺ�</b></td>',
						'<td align="center" class="List_td"><b>����</b></td>',
						'<td align="center" class="List_td"><b>�Ա�</b></td>',
						'<td align="center" class="List_td"><b>����</b></td>',
						//'<td align="center" class="List_td"><b>�����ܼ�</b></td>',
						//'<td align="center" class="List_td"><b>���˼���</b></td>',
						'<td align="center" class="List_td"><b>ID</b></td>',
						'<td align="center" class="List_td"><b>��������</b></td>',
						'<td align="center" class="List_td"><b>״̬</b></td>',
						//'<td align="center" class="List_td"><b>�������</b></td>',
						//'<td align="center" class="List_td"><b>����ʱ��</b></td>',
						//'<td align="center" class="List_td"><b>������</b></td>',
						'<td align="center" class="List_td"><b>��Ⱦ���</b></td>',
						'<td align="center" class="List_td"><b>��Ⱦ����</b></td>',
						'<td align="center" class="List_td"><b>��Ⱦ����</b></td>',
						'<td align="center" class="List_td"><b>����걾</b></td>',
						'<td align="center" class="List_td"><b>��ԭ��</b></td>',
						'<td align="center" class="List_td"><b>�˻�ԭ��</b></td>',
						//'<td align="center" class="List_td"><b>��ע</b></td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="center">{RegNo}</td>',
								'<td align="center">{PatName}</td>',
								'<td align="center">{Sex}</td>',
								'<td align="center">{Age}</td>',
								//'<td align="center">{EncryptLevel}</td>',
								//'<td align="center">{PatLevel}</td>',
								'<td align="center" style="cursor:pointer;" onclick="{[this.OpenHAIReport(\'HAI\',\'1\',values)]}"><span style="border-bottom:1px #F78181 solid;">{ReportID}</td>',
								'<td align="center">{ReportTypeDesc}</td>',
								'<td align="center">{ReportStatusDesc}</td>',
								//'<td align="center">{ReportLocDesc}</td>',
								//'<td align="center">{ReportDate} {ReportTime}</td>',
								//'<td align="center">{ReportUserDesc}</td>',
								'<td align="center">{InfPos}</td>',
								'<td align="center">{InfDate}</td>',
								'<td align="center">{InfDiag}</td>',
								'<td align="center">{Specimen}</td>',
								'<td align="center">{TestResults}</td>',
								'<td align="center">{BackOpinion}</td>',
								//'<td align="center">{LogResume}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,14)]}',
					'</tbody>',
				'</table>',
				
				//���Ʋ���ɸ���¼
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							 '<td width="20%" class="subtotal_td">����ɸ��ָ�꣺&nbsp;&nbsp;<span class="subtotal_number">��{InfCasesCount}��</span>&nbsp;&nbsp;</td>',
							 '<td width="20%" class="subtotal_td">',
							 '<tpl if="(SusInfStatus!=\'\')">����״̬��</tpl>',
							 '&nbsp;&nbsp;<span class="subtotal_number" id="SusInfStatus">{SusInfStatus}</span></td>',
							 '<td>',
								'<span class="subtotal_button_Oper NINFOper4" onclick="{[this.HAIViewBaseInfo()]}">ժҪ��Ϣ</span>',
								'<span class="subtotal_button_Oper NINFOper2" onclick="{[this.HAICasesDetOper()]}">�ų�</span>',
								'<span class="subtotal_button_Oper NINFOper1" onclick="{[this.HAICasesMsgOper()]}">��Ϣ</span>',
							 '</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td"><b>���</b></td>',
						'<td align="center" class="List_td"><b>��Ⱦ���ָ��</b></td>',
						'<td align="center" class="List_td"><b>����</b></td>',
						'<td align="center" class="List_td"><b>ʱ��</b></td>',
						'<td align="center" class="List_td"><b>����</b></td>',
						'<td align="center" class="List_td"><b>����</b></td>',
						'<td align="center" class="List_td"><b>Ѫ����</b></td>',
						'<td align="center" class="List_td"><b>����|����|PICC</b></td>',
					'</tr>',
					'<tbody>',
						'<tpl for="InfCasesList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="center">{ResultNote}</td>',
								'<td align="center">{ResultCnt}</td>',
								'<td align="center">{ResultDate}</td>',
								'<td align="center">{ResultDays}</td>',
								'<td align="center">{FeverDays}</td>',
								'<td align="center">{TestAbTimes}</td>',
								'<td align="center">{OEUCIntuDays}|{OEVAPIntuDays}|{OEPICCIntuDays}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRowB(values,8) ]}',
					'</tbody>',
				'</table>',
			'</tpl>',
			
			//����֤������ڶ����б���ʾ
			'<tpl if="(TypeCate==\'DTH\')&&(TypeCode==\'2\')">',
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							 '<td width="25%" class="subtotal_td">{TypeDesc}��&nbsp;&nbsp;<span class="subtotal_number">��{ReportCount}��</span>&nbsp;&nbsp;</td>',
							 '<td>',
								'<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.OpenNewReportWinByCom(values)]}">��������</span>',
							 '</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">�ǼǺ�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�Ա�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�����ܼ�</td>',
						'<td align="center" class="List_td">���˼���</td>',
						'<td align="center" class="List_td">����֤�����</td>',
						'<td align="center" class="List_td">״̬</td>',
						'<td align="center" class="List_td">ԭ��</td>',
						'<td align="center" class="List_td">����ʱ��</td>',
						'<td align="center" class="List_td">�������</td>',
						'<td align="center" class="List_td">������</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center">{[xindex]}</td>',
							//	'<td align="center">{PapmiNo}</td>',
								'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenReportWinByCom(\'DTH\',\'2\',values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{PapmiNo}</span>':'{PapmiNo}') + '</td>',
								'<td align="left">{PatName}</td>',
								'<td align="center">{Sex}</td>',
								'<td align="center">{Age}</td>',
								'<td align="center">{EncryptLevel}</td>',
								'<td align="center">{PatLevel}</td>',
								'<td align="center" >{DeathNo}</td>',
							//	'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenReportWinByCom(\'DTH\',\'2\',values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{DeathNo}</span>':'{DeathNo}') + '</td>',
								'<td align="center">{RepStatusDesc}</td>',
								'<td align="left">{BackReason}</td>',
								'<td align="center">{RepDate} {RepTime}</td>',
								'<td align="left">{RepLoc}</td>',
								'<td align="left">{RepUser}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,13) ]}',
					'</tbody>',
				'</table>',
			'</tpl>',
			
			//�Զ�����б���ʾ
			'<tpl if="(TypeCate==\'CRF\')">',
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							 '<td width="80%" class="subtotal_td">{TypeDesc}��&nbsp;&nbsp;<span class="subtotal_number">��{ReportCount}��</span>&nbsp;&nbsp;</td>',
							 '<td width="15%" class="subtotal_td"' + (DoctorFlag!='D'?' disabled ':'') + '><span onclick="{[this.OpenNewReportWinByCom(values)]}" style="font-size:17px;color:#1291A9;text-decoration:underline;cursor:pointer;" align="center">��������</span></td>',
							 '<td>&nbsp;&nbsp;</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">�ǼǺ�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�Ա�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�����ܼ�</td>',
						'<td align="center" class="List_td">���˼���</td>',
						'<td align="center" class="List_td">ID</td>',
						'<td align="center" class="List_td">״̬</td>',
						'<td align="center" class="List_td">����ʱ��</td>',
						'<td align="center" class="List_td">�������</td>',
						'<td align="center" class="List_td">������</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center" class="List_td">{[xindex]}</td>',
								'<td align="center" class="List_td">{patientNo}</td>',
								'<td align="left" class="List_td">{patientName}</td>',
								'<td align="center" class="List_td">{patientSex}</td>',
								'<td align="center" class="List_td">{patientAge}</td>',
								'<td align="center" class="List_td">{EncryptLevel}</td>',
								'<td align="center" class="List_td">{PatLevel}</td>',
							//	'<td align="center" style="border:1 solid #FFFFFF;cursor:pointer;" onclick="{[this.OpenReportWinByCom(\'CRF\',\'2\',values)]}"><span style="border-bottom:1px #F78181 solid;">{DataId}</td>',
								'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenReportWinByCom(\'CRF\',\'2\',values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{DataId}</span>':'{DataId}') + '</td>',
								'<td align="center" class="List_td">{CurrentStatus}</td>',
								'<td align="center" class="List_td">{CreateDate} {CreateTime}</td>',
								'<td align="left" class="List_td">{CreateCTLocDesc}</td>',
								'<td align="left" class="List_td">{CreateUserName}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,13) ]}',
					'</tbody>',
				'</table>',
			'</tpl>',
			
			// ʳԴ�Լ�����һ���б���ʾ
			'<tpl if="(TypeCate==\'FBD\')&&(TypeCode==\'1\')">',
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							'<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							'<td width="20%" class="subtotal_td">{TypeDesc}��&nbsp;&nbsp;<span class="subtotal_number">��{ReportCount}��</span>&nbsp;&nbsp;</td>',
							'<td>',
								'<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.OpenNewReportWinByCom(values)]}">ʳԴ�Լ�������</span>',
							'</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">�ǼǺ�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�Ա�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�����ܼ�</td>',
						'<td align="center" class="List_td">���˼���</td>',
						'<td align="center" class="List_td">��Ƭ���</td>',
						'<td align="center" class="List_td">״̬</td>',
						'<td align="center" class="List_td">��������</td>',
						'<td align="center" class="List_td">����ʱ��</td>',
						'<td align="center" class="List_td">������</td>',
						'<td align="center" class="List_td">���ʱ��</td>',
						'<td align="center" class="List_td">�����</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="center">{PapmiNo}</td>',
								'<td align="left">{PatName}</td>',
								'<td align="center">{Sex}</td>',
								'<td align="center">{PatAge}</td>',
								'<td align="center">{EncryptLevel}</td>',
								'<td align="center">{PatLevel}</td>',
								//'<td align="center" style="cursor:pointer;"> <span onclick="{[this.OpenReportWinByCom(\'FBD\',\'1\',values)]}" style="border-bottom:1px #F78181 solid;">{CardNo}</span></td>',
								'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenReportWinByCom(\'FBD\',\'1\',values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{CardNo}</span>':'{CardNo}') + '</td>',
								'<td align="center">{StatusDesc}</td>',
								'<td align="left">{DiseaseDesc}</td>',
								'<td align="center">{RepDateTime} {RepTime}</td>',
								'<td align="center">{RepUserName}</td>',
								'<td align="center">{ChkDateTime} {CheckTime}</td>',
								'<td align="center">{ChkUserName}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,14) ]}',
					'</tbody>',
				'</table>',
			'</tpl>',
			
			//���񼲲�����
			'<tpl if="(TypeCate==\'SMD\')&&(TypeCode==\'1\')">',
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							'<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							'<td width="65%" class="subtotal_td">{TypeDesc}��&nbsp;&nbsp;<span class="subtotal_number">��{ReportCount}��</span>&nbsp;&nbsp;</td>',
							'{[ this.DisplaySMDButton(values) ]}',
							'<td>&nbsp;&nbsp;</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">�ǼǺ�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�Ա�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�����ܼ�</td>',
						'<td align="center" class="List_td">���˼���</td>',
						'<td align="center" class="List_td">��Ƭ���</td>',
						'<td align="center" class="List_td">��������</td>',
						'<td align="center" class="List_td">��������</td>',
						'<td align="center" class="List_td">״̬</td>',
						'<td align="center" class="List_td">����ʱ��</td>',
						'<td align="center" class="List_td">������</td>',
						'<td align="center" class="List_td">���ʱ��</td>',
						'<td align="center" class="List_td">�����</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="center">{PapmiNo}</td>',
								'<td align="left">{PatName}</td>',
								'<td align="center">{Sex}</td>',
								'<td align="center">{Age}</td>',
								'<td align="center">{EncryptLevel}</td>',
								'<td align="center">{PatLevel}</td>',
								//'<td align="center" style="cursor:pointer;"><span onclick="{[this.OpenReportWinByCom(\'SMD\',\'1\',values)]}" style="border-bottom:1px #F78181 solid;">{CardNo}</span></td>',
								'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenReportWinByCom(\'SMD\',\'1\',values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{CardNo}</span>':'{CardNo}') + '</td>',
								'<td align="center">{RepTypeDesc}</td>',
								'<td align="center">{DiseaseDesc}</td>',
								'<td align="center">{StatusDesc}</td>',
								'<td align="center">{RepDate} {RepTime}</td>',
								'<td align="left">{RepUserDesc}</td>',
								'<td align="center">{CheckDate} {CheckTime}</td>',
								'<td align="center">{CheckUserDesc}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,15) ]}',
					'</tbody>',
				'</table>',
			'</tpl>',
			
			// ������������һ���б���ʾ
			'<tpl if="(TypeCate==\'CD\')&&(TypeCode==\'1\')">',
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							'<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							'<td width="20%" class="subtotal_td">{TypeDesc}��&nbsp;&nbsp;<span class="subtotal_number">��{ReportCount}��</span>&nbsp;&nbsp;</td>',
						//	'{[ this.DisplayCDButton(values) ]}',
							'<td width="75%"></td>',
						'</tr>',
					'</table>',
					'<table width="100%">',
						'<tr>',
							'{[ this.DisplayCDButton(values) ]}',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">�ǼǺ�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�Ա�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">��������</td>',
						'<td align="center" class="List_td">��Ƭ���</td>',
						'<td align="center" class="List_td">״̬</td>',
						'<td align="center" class="List_td">��������</td>',
						'<td align="center" class="List_td">������</td>',
						'<td align="center" class="List_td">�������</td>',
						'<td align="center" class="List_td">�����</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="center">{PapmiNo}</td>',
								'<td align="left">{PatName}</td>',
								'<td align="center">{PatSex}</td>',
								'<td align="center">{PatAge}</td>',
								'<td align="center">{RepTypeDesc}</td>',
							//	'<td align="center" style="cursor:pointer;"> <span onclick="{[this.OpenReportWinByTp(\'CD\',\'1\',values)]}" style="border-bottom:1px #F78181 solid;">{KPBH}</span></td>',
								'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenReportWinByTp(\'CD\',\'1\',values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{KPBH}</span>':'{KPBH}') + '</td>',
								'<td align="center">{RepStatusDesc}</td>',
								'<td align="center">{ReportDate}</td>',
								'<td align="center">{ReportUser}</td>',
								'<td align="center">{CheckDate}</td>',
								'<td align="center">{CheckUser}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,12) ]}',
					'</tbody>',
				'</table>',
			'</tpl>',

			//���⻼�߹���
			'<tpl if="(TypeCate==\'SPE\')&&(TypeCode==\'1\')">',
				'<div class="subtotal">',
					'<table width="100%">',
						'<tr>',
							'<td width="5%" class="subtotal_td"><div style="position: relative; width: 34px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" style="position: absolute; top: 2; left: 10;" /></div></td>',
							'<td width="20%" class="subtotal_td">{TypeDesc}��&nbsp;&nbsp;<span class="subtotal_number">��{ReportCount}��</span>&nbsp;&nbsp;</td>',
							'<td>',
								'<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[this.OpenNewReportWinByCom(values)]}">������⻼��</span>',
							'</td>',
						'</tr>',
					'</table>',
				'</div>',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:13px;height:24px;">',
						'<td align="center" class="List_td">���</td>',
						'<td align="center" class="List_td">�ǼǺ�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�Ա�</td>',
						'<td align="center" class="List_td">����</td>',
						'<td align="center" class="List_td">�����ܼ�</td>',
						'<td align="center" class="List_td">���˼���</td>',
						'<td align="center" class="List_td">��������</td>',
						'<td align="center" class="List_td">״̬</td>',
						'<td align="center" class="List_td">��Ϣ</td>',
						'<td align="center" class="List_td">���˵��</td>',
						'<td align="center" class="List_td">�������</td>',
						'<td align="center" class="List_td">�����</td>',
						'<td align="center" class="List_td">������</td>',
						'<td align="center" class="List_td">�������</td>',
						//'<td align="center" class="List_td">�����</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:13px;height:24px;cursor:pointer;" >',
								'<td align="center">{[xindex]}</td>',
								'<td align="center">{RegNo}</td>',
								'<td align="center">{PatName}</td>',
								'<td align="center">{Sex}</td>',
								'<td align="center">{PatientAge}</td>',
								'<td align="center">{EncryptLevel}</td>',
								'<td align="center">{PatLevel}</td>',
							//	'<td align="center" style="cursor:pointer;"><span onclick="{[this.OpenReportWinByCom(\'SPE\',\'1\',values)]}" style="border-bottom:1px #F78181 solid;">{PatTypeDesc}</span></td>',
								'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenReportWinByCom(\'SPE\',\'1\',values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{PatTypeDesc}</span>':'{PatTypeDesc}') + '</td>',
								'<td align="center">{StatusDesc}</td>',
							//	'<td align="center" style="cursor:pointer;"><span onclick="{[this.OpenSpeNewsWin(values)]}" style="border-bottom:1px #F78181 solid;">{ReadStatus}</span></td>',
								'<td align="center">' + (DoctorFlag=='D'?'<span onclick="{[this.OpenSpeNewsWin(values)]}" style="border-bottom:1px #F78181 solid;cursor:pointer;">{ReadStatus}</span>':'{ReadStatus}') + '</td>',
								'<td align="left">{Note}</td>',
								'<td align="center">{MarkDate}</td>',
								'<td align="center">{MarkUser}</td>',
								'<td align="left">{CheckOpinion}</td>',
								'<td align="center">{CheckDate}</td>',
								//'<td align="center">{CheckUser}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,15) ]}',
					'</tbody>',
				'</table>',
			'</tpl>',
			'<table style="border:1px #3399CC solid;width:100%;height:2px;background-color:#3399CC"><tr><td></td></tr></table>',
			'</div>',
		'</tpl>',
		{
			OpenNewReportWinByCom : function(values){
				var tabEv = 'objScreen.OpenReportWinByCom(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'\');';
				return tabEv;
			},
			OpenNewReportWinByComA : function(values){
				var tabEv = 'objScreen.OpenReportWinByComA(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'\');';
				return tabEv;
			},
			OpenReportWinByCom : function(TypeCate,TypeCode,values){
				if (TypeCate == 'CRF') {
					var arrTmp = values.FormVerDR.split('||');
					TypeCode = arrTmp[0];
				}
				var tabEv = 'objScreen.OpenReportWinByCom(\'' + TypeCate + '\',\'' + TypeCode + '\',\'' + values.RowID + '\');';
				return tabEv;
			},
			OpenNewReportWinByTp : function(values,reptype){
				var tabEv = 'objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'' + reptype + '\');';
				return tabEv;
			},
			//ҽԺ��Ⱦ����V4.0
			OpenHAIReport : function(values,reptype){
				if (arguments.length==2){	//���±���
					var values = arguments[0];
					var NewBabyFlg = ExtTool.RunServerMethod("DHCHAI.DP.PAAdm", "GetNewBabyById",HAIEpisodeDr);
					if (NewBabyFlg=="1"){
						reptype = 2;
					}
					var tabEv = 'objScreen.OpenHAIReport(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'' + reptype  + '\',\'' + '' + '\');';
					return tabEv;
				}
				if (arguments.length==3){	//�����б���
					var TypeCate = arguments[0];
					var TypeCode = arguments[1];
					var values = arguments[2];
					var tabEv = 'objScreen.OpenHAIReport(\'' + TypeCate + '\',\'' + TypeCode + '\',\'' + values.ReportTypeCode  + '\',\'' + values.ReportID + '\');';
					return tabEv;
				}
			},
			OpenReportWinByTp : function(TypeCate,TypeCode,values){
				if(TypeCate == 'CD'){
					TypeCode=values.RepTypeCode;
				}
				var tabEv = 'objScreen.OpenReportWinByCom(\'' + TypeCate + '\',\'' + TypeCode + '\',\'' + values.ReportID + '\');';
				return tabEv;
			},
			GetSpacebarRow : function(values,colnum){
				//��ӿ���
				var tabEv = '';
				var row = values.ReportList.length;
				var minRow = 3;
				if (row>=minRow) minRow = row +1;
				if (row < minRow) {
					for (var indRow = row; indRow < minRow; indRow++){
						tabEv += '<tr class="' + (indRow % 2 == 1 ? 'RowOdd' : 'RowEven') + '" style="font-size:11px;height:20px;">'
						for (var indCol = 0; indCol < colnum; indCol++){
							tabEv += 	'<td align="center">&nbsp;</td>'
						}
						tabEv += '</tr>'
					}
				}
				return tabEv;
			},
			GetSpacebarRowB : function(values,colnum){
				//��ӿ���
				var tabEv = '';
				var row = values.InfCasesList.length;
				var minRow = 2;
				if (row < minRow) {
					for (var indRow = row; indRow < minRow; indRow++){
						tabEv += '<tr class="' + (indRow % 2 == 1 ? 'RowOdd' : 'RowEven') + '" style="font-size:11px;height:20px;">'
						for (var indCol = 0; indCol < colnum; indCol++){
							tabEv += 	'<td align="center">&nbsp;</td>'
						}
						tabEv += '</tr>'
					}
				}
				return tabEv;
			},
			ViewInfCtlResult : function(){
				var divId = 'divInfCtlResult';
				//���Ʋ���������ϸ��¼
				var tabEv = '';
				tabEv += "if (document.all['" + divId + "'].style.display == 'none') {"
				tabEv +=     "document.all['" + divId + "'].style.display = 'block';"
				tabEv += "} else {"
				tabEv +=    "document.all['" + divId + "'].style.display = 'none';"
				tabEv += "}"
				return tabEv;
			},
			GetTableWidth : function(values){
				var tabEv = 150;
				if (values.CtlDateList){
					if (values.CtlDateList.length){
						tabEv = (values.CtlDateList.length * 180 + 150)
					}
				}
				tabEv += 'px';
				return tabEv;
			},
			Gettable_header : function(values){
				var tmpDateList = values.CtlDateList;
				var tabEv = '';
				if(tmpDateList == null)
					tmpDateList = new Array();
				tabEv += '<tr class="fixedtitle_row">';
				tabEv += 	'<td width="150px" align="center" class="fixedtitle_col" style="border:1px Lavender solid;border-collapse:collapse;">��Ŀ����</td>';
				for (var indDate = 0; indDate < tmpDateList.length; indDate++) {
					tabEv += 	'<td width="180px" align="center" style="border:1px Lavender solid;border-collapse:collapse;">' + tmpDateList[indDate] + '</td>';
				}
				tabEv += '</tr>';
				return tabEv;
			},
			GetTableData : function(values){
				var tabEv = '';
				tabEv += '<tr>';
				tabEv += 	'<td width="150px"  class="fixeddata_col" style="border:1px Lavender solid;border-collapse:collapse;">' + values.ItemSubCat + '</td>';
				
				var tmpDateList = values.CtlDateList;
				for (var indDate = 0; indDate < tmpDateList.length; indDate++) {
					tabEv += '<td width="180px" style="border:1px Lavender solid;border-collapse:collapse;">';
					
					var tmpDate = tmpDateList[indDate];
					if (typeof(values.ItemDateList[tmpDate]) != 'undefined') {
						var arrItemList = values.ItemDateList[tmpDate].ItemList;
						for (var indItem = 0; indItem < arrItemList.length; indItem++) {
							if (indItem > 0) {
								tabEv += '<div style="border-top:1px #58D3F7 solid;">' + arrItemList[indItem].DataValue + '</div>';
							} else {
								tabEv += '<div>' + arrItemList[indItem].DataValue + '</div>';
							}
						}
					} else {
						tabEv += '<div>&nbsp;</div>';
					}
					
					tabEv += '</td>';
				}
				
				tabEv += '</tr>'
				return tabEv;
			},
			ViewInfBaseInfo : function(){
				//���Ʋ��� �鿴ժҪ��Ϣ����
				var tabEv = 'objScreen.ViewInfBaseInfo(\'' + EpisodeID + '\');';
				return tabEv;
			},
			HAIViewBaseInfo : function(){
				//���Ʋ��� �鿴ժҪ��Ϣ������ҽԺ��Ⱦ����V4.0��
				var tabEv = 'objScreen.HAIViewBaseInfo(\'' + HAIEpisodeDr + '\');';
				return tabEv;
			},
			HAICasesMsgOper : function(){
				//���Ʋ�����Ϣ�����¼���ҽԺ��Ⱦ����V4.0��
				var tabEv = 'objScreen.HAICasesMsgOper(\'' + HAIEpisodeDr + '\');';
				return tabEv;
			},
			HAICasesDetOper : function(operation){
				//���Ʋ����ų������¼���ҽԺ��Ⱦ����V4.0��
				var tabEv = 'objScreen.HAICasesDetOper(\'' + HAIEpisodeDr + '\');';
				return tabEv;
			},
			InfCasesOperClick : function(operation){
				//���Ʋ������ô����¼�
				var tabEv = 'objScreen.btnHandle_onClick(\'' + EpisodeID + '\',\'' + operation + '\');';
				return tabEv;
			},
			TableOnDblClick : function(values){
				//ȡ�����ü�¼�����¼�
				var tabEv = 'objScreen.tabCancelHandle_onDblClick(\'' + values.HandleType + '\',\'' + values.CasesID + '||' + values.SubID + '\');';
				return tabEv;
			},
			DisplaySMDButton : function(values){
				//�������Ϳ��ƾ��񼲲�������ť��ʾ
				var tabEv = '';
				if (AdmType == 'I') {
					tabEv += '<td><span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',4);">��Ժ��Ϣ��</span></td>'
					tabEv += '<td><span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',3);">�������濨</span></td>'
				} else {
					tabEv += '<td><span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',1);">�������濨</span></td>'
				}
				return tabEv;
			},
			DisplayCDButton : function(values){
				//���ÿ�������������ť��ʾ
				var tabEv = '<td style="padding-bottom:5px">';
				if (CDTypeList.indexOf("ZLK")>-1) {
					tabEv += '<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'ZLK\')]}">��������</span>'
				} 
				if (CDTypeList.indexOf("XNXG")>-1) {
					tabEv += '<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'XNXG\')]}">����Ѫ�ܱ���</span>'
				} 
				if (CDTypeList.indexOf("SHK")>-1) {
					tabEv += '<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'SHK\')]}">�˺���ⱨ��</span>'
				} 
				if (CDTypeList.indexOf("NYZD")>-1) {
					tabEv += '<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'NYZD\')]}">ũҩ�ж�����</span>'
				} 
				if (CDTypeList.indexOf("GWZS")>-1) {
					tabEv += '<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'GWZS\')]}">���������</span>'
				} 
				if (CDTypeList.indexOf("TNB")>-1) {
					tabEv += '<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'TNB\')]}">���򲡱���</span>'
				} 
				if (CDTypeList.indexOf("YSZYB")>-1) {
					tabEv += '<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'YSZYB\')]}">ְҵ������</span>'
				} 
				if (CDTypeList.indexOf("FZYCO")>-1) {
					tabEv += '<span class="subtotal_button" ' + (DoctorFlag!='D'?'disabled ':'') + 'onclick="{[objScreen.OpenReportWinByTp(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'FZYCO\')]}">CO�ж�����</span>'
				} 
				tabEv += '</td>';
				return tabEv;
			},
			OpenSpeNewsWin : function(values){
				//���⻼����Ϣ�б�
				var tabEv = 'objScreen.OpenSpeNewsWin(\'' + values.RowID + '\');';
				return tabEv;
			}
		}
	);
	
	InitClinRepToAdmEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
var OpinionText='���������';
var objScreenMsg = new Object();

function InitCasesXDtl(obj){
	objScreenMsg = obj;
	obj.CasesXData = new Object();
	obj.CasesXData.PatientList = new Array();
	
	obj.UpLoadCasesXDtl = function(){
		obj.LoadCasesXDtl();
	}
	
	obj.LoadCasesXDtlArgs = new Object();
	obj.LoadCasesXDtl = function(divCasesXDtl,SubjectCode,EpisodeID,CasesXDates)
	{
		if (divCasesXDtl) {
			obj.LoadCasesXDtlArgs.DivName = divCasesXDtl;
			obj.LoadCasesXDtlArgs.ConfigCode = SubjectCode;
			obj.LoadCasesXDtlArgs.EpisodeID = EpisodeID;
			obj.LoadCasesXDtlArgs.ActDates = CasesXDates;
		} else {
			divCasesXDtl = obj.LoadCasesXDtlArgs.DivName;
		}
		if (!divCasesXDtl) return;
		
		var objResult = new Object();
		var ConfigCode = obj.LoadCasesXDtlArgs.ConfigCode;
		var EpisodeID = obj.LoadCasesXDtlArgs.EpisodeID;
		var ActDates = obj.LoadCasesXDtlArgs.ActDates;
		var BaseInfo = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesXSrv", "GetCasesXPatInfo", ConfigCode, EpisodeID);
		var arrBaseInfo = BaseInfo.split('^');
		
		objResult.ConfigCode    = ConfigCode;
		objResult.EpisodeID     = EpisodeID;
		objResult.ActDates      = ActDates;
		
		if (arrBaseInfo.length > 33) {
			//objResult.EpisodeID    = arrBaseInfo[0];
			objResult.PatientID    = arrBaseInfo[1];
			objResult.HandleStatus = arrBaseInfo[2];
			objResult.HandleDate   = arrBaseInfo[3];
			objResult.HandleTime   = arrBaseInfo[4];
			objResult.SttDate      = arrBaseInfo[5];
			objResult.EndDate      = arrBaseInfo[6];
			objResult.RegNo        = arrBaseInfo[7];
			objResult.PatName      = arrBaseInfo[8];
			objResult.MrNo         = arrBaseInfo[9];
			objResult.Sex          = arrBaseInfo[10];
			objResult.Age          = arrBaseInfo[11];
			objResult.AdmDate      = arrBaseInfo[12];
			objResult.AdmTime      = arrBaseInfo[13];
			objResult.LocID        = arrBaseInfo[14];
			objResult.LocDesc      = arrBaseInfo[15];
			objResult.LocGrp       = arrBaseInfo[16];
			objResult.WardID       = arrBaseInfo[17];
			objResult.WardDesc     = arrBaseInfo[18];
			objResult.WardGrp      = arrBaseInfo[19];
			objResult.BedID        = arrBaseInfo[20];
			objResult.BedDesc      = arrBaseInfo[21];
			objResult.DocID        = arrBaseInfo[22];
			objResult.DocName      = arrBaseInfo[23];
			objResult.DisDate      = arrBaseInfo[24];
			objResult.DisTime      = arrBaseInfo[25];
			objResult.AdmStatus    = arrBaseInfo[26];
			objResult.InHospLocDesc  = arrBaseInfo[27];
			objResult.InHospWardDesc = arrBaseInfo[28];
			objResult.InHospDays   = arrBaseInfo[29];
			objResult.InLocDate    = arrBaseInfo[30];
			objResult.InLocTime    = arrBaseInfo[31];
			objResult.InWardDate   = arrBaseInfo[32];
			objResult.InWardTime   = arrBaseInfo[33];
		}
		
		obj.CasesXMainTemplate.overwrite(divCasesXDtl,[objResult]);
		
		var HandleStatus = objResult.HandleStatus;
		var EpisodeID = objResult.EpisodeID;
		
		if (HandleStatus == 'δ����') {
			obj.setButtonDisabled('Button5-' + EpisodeID,true);
		}
		if (HandleStatus == '�ų�') {
			obj.setButtonDisabled('Button5-' + EpisodeID,true);
		}
		if (HandleStatus == '����') {
			//obj.setButtonDisabled('Button2-' + EpisodeID,true);
			obj.setButtonDisabled('Button5-' + EpisodeID,true);
		}
		if (HandleStatus == 'ȷ��') {
			obj.setButtonDisabled('Button1-' + EpisodeID,true);
			obj.setButtonDisabled('Button2-' + EpisodeID,true);
			obj.setButtonDisabled('Button3-' + EpisodeID,true);
		}
	}
	
	//Ժ�б����б�չ�ָ�ʽ
	obj.InfReportTemplate = new Ext.XTemplate(
		'<table width="100%">',
			'<tr>',
				'<td align="center" width="5%">���</td>',
				'<td align="center" width="10%">��Ⱦ��λ</td>',
				'<td align="center" width="15%">��Ⱦ���</td>',
				'<td align="center" width="10%">��Ⱦ����</td>',
				'<td align="center" width="20%">��ԭѧ����</td>',
				'<td align="center" width="10%">����״̬</td>',
				'<td align="center" width="20%">��������</td>',
			'</tr>',
			'<tbody>',
				'<tpl for=".">',
					'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
						'<td align="center">{[xindex]}</td>',
						'<td align="center">{InfPos}</td>',
						'<td align="center">{InfDiagnos}</td>',
						'<td align="center">{InfDate}</td>',
						'<td align="center">{TestCode}</td>',
						'<td align="center">{RepStatus}</td>',
						'<td align="center">{RepDate} {RepTime}</td>',
					'</tr>',
				'</tpl>',
				'{[ this.GetSpacebarRow(values) ]}',
			'</tbody>',
		'</table>',
		{
			GetSpacebarRow : function(values){
				//��ӿ���
				var tabEv = '';
				var row = values.length;
				var maxRow = row + 1;
				if (row < maxRow) {
					for (var indRow = row; indRow < maxRow; indRow++){
						tabEv += '<tr  class="' + ((indRow + 1) % 2 == 1 ? 'RowEven' : 'RowOdd') + '" style="border-bottom:1px #BDBDBD solid;">'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += 	'<td align="left">&nbsp;</td>'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += '</tr>'
					}
				}
				return tabEv;
			}
		}
	);
	
	//����ɸ����ϸչ�ָ�ʽ
	obj.CasesXRstTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<table width="100%" style="border:0px #BDBDBD solid;">',
				'<tr>',
					'{[ this.GetTitle(values) ]}',
				'</tr>',
				'<tr>',
					 '<td width="100%">',
						'<div>',
							'<table width="100%">',
								'<tr>',
									'<td align="center" width="5%">���</td>',
									'<td align="center" width="60%">ԭ��</td>',
									'<td align="center" width="15%">��������</td>',
									'<td align="center" width="10%">����ʱ��</td>',
									'<td align="center" width="10%">�û�</td>',
								'</tr>',
								'<tbody>',
									'<tpl for="CtlResult">',
										'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
											'<td align="center">{[xindex]}</td>',
											'<td align="left">{Summary}</td>',
											'<td align="center">{OccurDate}</td>',
											'<td align="center">{OccurTime}</td>',
											'<td align="center">{UserDesc}</td>',
										'</tr>',
									'</tpl>',
									//'{[ this.GetSpacebarRow(values) ]}',
								'</tbody>',
							'</table>',
						'</div>',
					 '</td>',
				'</tr>',
			'</table>',
		'</tpl>',
		{
			GetTitle : function(values){
				var ActDate = values.ActDate;
				//var arrDate = ActDate.split('-');
				//var strTitle = arrDate[0] + '��' + arrDate[1] + '��' + arrDate[2] + '��&nbsp;&nbsp;&nbsp;&nbsp;';
				var strTitle = ActDate;
				strTitle = strTitle + values.ScreenGrade + '&nbsp;&nbsp;&nbsp;&nbsp;' + values.HandleGrade;
				var tabEv = '';
				if (values.HandleGrade == 'δ����') {
					tabEv = '<td colspan="5" align="center" style="border-bottom:1px #F78181 solid;font-family:times;color:#F78181;font-size:12px;"><b>' + strTitle + '</b></td>'
				} else if (values.HandleGrade == '�ų�') {
					tabEv = '<td colspan="5" align="center" style="border-bottom:1px #BDBDBD solid;font-family:times;color:#BDBDBD;font-size:12px;"><b>' + strTitle + '</b></td>'
				} else {
					tabEv = '<td colspan="5" align="center" style="border-bottom:1px #58D3F7 solid;font-family:times;color:#58D3F7;font-size:12px;"><b>' + strTitle + '</b></td>'
				}
				return tabEv;
			},
			GetSpacebarRow : function(values){
				//��ӿ���
				var tabEv = '';
				var row = values.CtlResult.length;
				if (row < 5) {
					var maxRow = 5;
				} else {
					var maxRow = row + 1;
				}
				if (row < maxRow) {
					for (var indRow = row; indRow < maxRow; indRow++){
						tabEv += '<tr  class="' + ((indRow + 1) % 2 == 1 ? 'RowEven' : 'RowOdd') + '" style="border-bottom:1px #BDBDBD solid;">'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += 	'<td align="left">&nbsp;</td>'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += 	'<td align="center">&nbsp;</td>'
						tabEv += '</tr>'
					}
				}
				return tabEv;
			}
		}
	);
	
	obj.CasesMsgTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<tpl if="HandleType==\'HA\'">',
				'<table width="100%" style="border:0px #BDBDBD solid;" ondblclick="{[ this.TableOnDblClick(values) ]}">',
					'<tr><td width="100%" align="left" style="border-bottom:1px {[ this.GetTitle("#58D3F7",values) ]} solid;font-family:times;color:{[ this.GetTitle("#58D3F7",values) ]};font-size:12px;"><b>{ActDate} {ActTime}&nbsp;&nbsp;&nbsp;&nbsp;{Operation}</b></td></tr>',
					'<tpl if="Opinion!=\'\'">',
						'<tr><td width="100%" align="left">���������{Opinion}</td></tr>',
					'</tpl>',
					'<tpl if="CasesXDate!=\'\'">',
						'<tr><td width="100%" align="left">������ڣ�{CasesXDate}</td></tr>',
					'</tpl>',
					'<tpl if="TargetDoc!=\'\'">',
						'<tr><td width="100%" align="left">����ҽ����{TargetDoc}({TargetDept})</td></tr>',
					'</tpl>',
					'<tr><td width="100%" align="left">�� �� �ˣ�{ActDept} {ActUser}</td></tr>',
				'</table>',
				'<table style="border:0px solid;"><tr><td></td></tr></table>',
			'</tpl>',
			'<tpl if="HandleType==\'HB\'">',
				'<table width="100%" style="border:0px #BDBDBD solid;">',
					'<tr><td width="100%" align="right" style="border-bottom:1px {[ this.GetTitle("#58D3F7",values) ]} solid;font-family:times;color:{[ this.GetTitle("#58D3F7",values) ]};font-size:12px;"><b>{ActDate} {ActTime}&nbsp;&nbsp;&nbsp;&nbsp;{Operation}</b></td></tr>',
					'<tr><td width="100%" align="right">���������{Opinion}</td></tr>',
					'<tr><td width="100%" align="right">�����ˣ�{ActDept} {ActUser}</td></tr>',
				'</table>',
				'<table style="border:0px solid;"><tr><td></td></tr></table>',
			'</tpl>',
		'</tpl>',
		{
			GetTitle : function(color,values){
				var tabEv = color;
				if (values.Operation == '�ų�') {
					tabEv = '#BDBDBD'
				}
				return tabEv;
			},
			TableOnDblClick : function(values){
				//ȡ�����ü�¼�����¼�
				var tabEv = 'objScreenMsg.tabCancelHandle_onDblClick(\'' + values.HandleType + '\',\'' + values.CasesID + '||' + values.SubID + '\');';
				return tabEv;
			}
		}
	);
	
	obj.CtlResultXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<div id="divCtlResult-{EpisodeID}-scroll" style="border:1px #BDBDBD solid;overflow:auto;overflow-y:auto;overflow-x:hidden;width:100%;">',
			'<table id="divCtlResult-{EpisodeID}-table" width="{[ this.GetTableWidth(values) ]}" cellpadding="0" cellspacing="0" border="0">',
				'{[ this.Gettable_header(values) ]}',
				'<tpl for="CtlRstList">',
					'{[ this.GetTableData(values) ]}',
				'</tpl>',
			'</table>',
			'</div>',
			'<div id="divCtlResult-{EpisodeID}-x-scroll" style="border:0px solid;overflow:auto;overflow-x:auto;overflow-y:hidden;width:100%;height:16px">',
				'<table id="divCtlResult-{EpisodeID}-x-table" style="border:0px solid;"><tr><td></td></tr></table>',
			'</div>',
		'</tpl>',
		{
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
			}
		}
	);
	
	obj.CasesXMainTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			//������Ϣ
			'<div id="divBaseInfo-{EpisodeID}" class="table_bg" ondblclick="{[this.RowOnClick(values)]}">',
				'<div class="table_header" style="border:1px Lavender solid;">',
					'<div class="table_header_text">',
						'{[ this.GetTitle(values) ]}',
					'</div>',
				'</div>',
			'</div>',
			//�����Ϣ
			'<div id="divCasesXInfo-{EpisodeID}" style="margin-left:0%;width:100%;display:block">',
				'<table width="100%" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;">',
					'<tr>',
						'<td width="70%" style="border:1px Lavender solid;"><table width="100%" class="table1"><tr><td>���ָ��</td></tr></table></td>',
						'<td width="30%" style="border:1px Lavender solid;"><table width="100%" class="table1"><tr><td>���ü�¼</td></tr></table></td>',
					'</tr>',
					'<tr>',
						//����ɸ���б�
						'<td style="border:1px Lavender solid;">',
							'<div id="divCasesXLeft-{EpisodeID}" >',
								//����ɸ����ϸ
							 	'<div id="divCasesXRst-{EpisodeID}">{[this.LoadCasesXRst(values)]}</div>',
								//update 2015-11-03 �޸�bug134018 ,IE11�Ǽ����� ���Ʋ���ɸ������ж����ַ�����undefined�� 
								//��Ⱦ�����б�
								'<div>',
									'<table width="100%" style="border:0px #BDBDBD solid;">',
										'<tr><td colspan="7" align="center" style="border-bottom:1px #58D3F7 solid;font-family:times;color:#58D3F7;font-size:12px;"><b>��Ⱦ���� ��Ⱦ��λ�б�</b></td></tr>',
										'<tr>',
											'<td width="100%">',
												'<div id="divInfReport-{EpisodeID}">{[this.LoadInfReport(values)]}</div>',
											'</td>',
										'</tr>',
									'</table>',
								'</div>',
								//������������
								'<div>',
									'<textarea id="txtOpinion-{EpisodeID}" style="width: 100%; height: 40px; font-size:14px;" onFocus="{[ this.TxtOnFocus(values) ]}" onBlur="{[ this.TxtOnBlur(values) ]}">' + OpinionText + '</textarea>',
								'</div>',
							'</div>',
						'</td>',
						//������Ϣ�б�
						'<td width="30%" style="border:1px Lavender solid;">',
							'<div id="divCasesMsg-{EpisodeID}" style="position:relative;overflow-y:auto;">{[this.LoadCasesMsg(values)]}</div>',
						'</td>',
					'</tr>',
				'</table>',
				//������ť
				'<table width="100%">',
					'<tr>',
						'<td width="10%">',
							'<span style="border:1px Lavender solid;"><input id="Button1-{EpisodeID}" name="Button1-{EpisodeID}" type="submit" onclick="{[this.BtnOnClickB(values,1)]}" value="�ų�" class="button1" style="width:80px;"></span>',
						'</td>',
						'<td width="10%">',
							'<span style="border:1px Lavender solid;"><input id="Button2-{EpisodeID}" name="Button2-{EpisodeID}" type="submit" onclick="{[this.BtnOnClickB(values,2)]}" value="����" class="button1" style="width:80px;"></span>',
						'</td>',
						'<td width="10%">',
							'<span style="border:1px Lavender solid;"><input id="Button3-{EpisodeID}" name="Button3-{EpisodeID}" type="submit" onclick="{[this.BtnOnClickB(values,3)]}" value="ȷ��" class="button1" style="width:80px;"></span>',
						'</td>',
						/* //modify by mxp 20170628 ȥ������Ⱦ����������
						'<td width="10%" align="right">',
							'<span style="border:1px Lavender solid;"><input id="Button5-{EpisodeID}" name="Button5-{EpisodeID}" type="submit" onclick="{[this.BtnOnClickB(values,5)]}" value="��Ⱦ����" class="button1" style="width:80px;"></span>',
						'</td>',
						*/
						'<td width="10%">',
							'<span style="border:1px Lavender solid;"><input id="Button4-{EpisodeID}" name="Button4-{EpisodeID}" type="submit" onclick="{[this.BtnOnClickB(values,4)]}" value="����Ϣ" class="button1" style="width:80px;"></span>',
						'</td>',
					/*	'<td width="10%" align="right">',
							'<span style="border:1px Lavender solid;"><input type="submit" onclick="{[this.BtnOnClickA(values)]}" value="ָ��ֲ�" class="button1" style="width:80px;"></span>',
						'</td>',*/
						'<td width="10%" align="right">',
							'<span style="border:1px Lavender solid;"><input type="submit" onclick="{[this.BtnOnClickC(values)]}" value="ժҪ" class="button1" style="width:80px;"></span>',
						'</td>',
						'<td width="40%">',
						'</td>',
					'</tr>',
				'</table>',
				//���ָ��ֲ�
				'<div id="divCtlResult-{EpisodeID}" style="border:3px white solid;margin-left:0%;width:100%;display:none;"></div>',
			'</div>',
			'<table class="table0" style="width:100%;height:2px;"><tr><td></td></tr></table>',
		'</tpl>',
		{
			GetTitle : function(values){
				var html = '';
				html = values.RegNo +  ' ' + values.PatName +  ' ' + values.MrNo +  ' ' + values.Sex +  ' ' + values.Age
				if (values.HandleDate) {
					html = html + ' ��' + values.HandleStatus + ' ' + values.HandleDate +  ' ' + values.HandleTime + '�� '
				} else {
					html = html + ' ��' + values.HandleStatus + '�� '
				}
				html = html + values.WardDesc +  ' ' + values.BedDesc +  ' ' + values.DocName +  ' ' + values.AdmStatus +  ' ' + values.AdmDate;
				return html;
			},
			LoadCasesXRst : function(values){
				var ConfigCode = values.ConfigCode;
				var EpisodeID = values.EpisodeID;
				var ActDates = values.ActDates;
				
				obj.CasesXData.PatientList[EpisodeID] = new Object();
				var objPatient = obj.CasesXData.PatientList[EpisodeID];
				objPatient.CasesXList = new Array();
				objPatient.CasesXListI = new Array();
				
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.NINFService.BC.CasesXSrv',
						QueryName : 'QryCasesXDtl',
						Arg1 : ConfigCode,
						Arg2 : EpisodeID,
						Arg3 : ActDates,
						ArgCnt : 3
					},
					success: function(response, opts) {
						var objData = Ext.decode(response.responseText);
						
						var objItem = null;
						for(var i = 0; i < objData.total; i ++)
						{
							objItem = objData.record[i];
							if (!objItem) continue;
							var CasesXID = objItem.CasesXID;
							
							if (typeof(objPatient.CasesXListI[CasesXID]) != 'undefined') {
								var ind = objPatient.CasesXListI[CasesXID];
								var objCasesX = objPatient.CasesXList[ind];
							} else {
								var objCasesX = {
									CasesXID : CasesXID,
									EpisodeID : objItem.EpisodeID,
									ScreenGrade : objItem.CXScreenGrade,
									HandleGrade : objItem.CXHandleGrade,
									ActDate : objItem.CXActDate,
									ItemCount : 0,
									CtlResult : new Array()
								};
								var ind = objPatient.CasesXList.length;
								objPatient.CasesXList[ind] = objCasesX;
								objPatient.CasesXListI[CasesXID] = ind;
							}
							var ind = objCasesX.CtlResult.length;
							objCasesX.CtlResult[ind] = objItem;
							objCasesX.ItemCount++;
							var ind = objPatient.CasesXListI[CasesXID];
							objPatient.CasesXList[ind] = objCasesX;
						}
						obj.CasesXData.PatientList[EpisodeID] = objPatient;
						obj.CasesXRstTemplate.overwrite("divCasesXRst-" + EpisodeID,objPatient.CasesXList);
						
						//�����Ҳ�DIV�߶������DIVһ����
						var divCtlHeight = document.getElementById("divCasesXLeft-" + EpisodeID).offsetHeight;
						document.getElementById("divCasesMsg-" + EpisodeID).style.height = divCtlHeight + "px";
					},
					failure: function(response, opts) {
						var objTargetElement = document.getElementById("divCasesXRst-" + EpisodeID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});
			},
			LoadInfReport : function(values){
				var EpisodeID = values.EpisodeID;
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.NINFService.BC.CommonSrv',
						QueryName : 'QryReportByAdm',
						Arg1 : EpisodeID,
						ArgCnt : 1
					},
					success: function(response, opts) {
						var objData = Ext.decode(response.responseText);
						var arryData = new Array();
						var objItem = null;
						for(var i = 0; i < objData.total; i ++)
						{
							objItem = objData.record[i];
							arryData[arryData.length] = objItem;
						}
						
						obj.InfReportTemplate.overwrite("divInfReport-" + EpisodeID, arryData);
						
						//�����Ҳ�DIV�߶������DIVһ����
						var divCtlHeight = document.getElementById("divCasesXLeft-" + EpisodeID).offsetHeight;
						document.getElementById("divCasesMsg-" + EpisodeID).style.height = divCtlHeight + "px";
					},
					failure: function(response, opts) {
						var objTargetElement = document.getElementById("divInfReport-" + EpisodeID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});
			},
			LoadCasesMsg : function(values){
				var EpisodeID = values.EpisodeID;
				var ConfigCode = values.ConfigCode;
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.NINFService.BC.CasesSrv',
						QueryName : 'QryHandleDtl',
						Arg1 : ConfigCode,
						Arg2 : EpisodeID,
						ArgCnt : 2
					},
					success: function(response, opts) {
						var objData = Ext.decode(response.responseText);
						var arryData = new Array();
						var objItem = null;
						for(var i = 0; i < objData.total; i ++)
						{
							objItem = objData.record[i];
							arryData[arryData.length] = objItem;
						}
						
						obj.CasesMsgTemplate.overwrite("divCasesMsg-" + EpisodeID,arryData);
					},
					failure: function(response, opts) {
						var objTargetElement = document.getElementById("divCasesMsg-" + EpisodeID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});
				
				//���ô����б������λ��
				setTimeout('objScreenMsg.setCasesMsgScrollTop("divCasesMsg-' + EpisodeID + '")',500);
			},
			TxtOnFocus : function(values){
				//���������ȡ���㴥���¼�
				var tabEv = 'objScreenMsg.txtOpinion_onFocus(\'' + values.EpisodeID + '\');';
				return tabEv;
			},
			TxtOnBlur : function(values){
				//�������ʧȥ���㴥���¼�
				var tabEv = 'objScreenMsg.txtOpinion_onBlur(\'' + values.EpisodeID + '\');';
				return tabEv;
			},
			RowOnClick : function(values){
				var divId = 'divCasesXInfo-' + values.EpisodeID;
				//���Ʋ���ɸ����ϸ��ʾ/���ش���ʱ��
				var tabEv = '';
				tabEv += "if (document.all['" + divId + "'].style.display == 'none') {"
				tabEv +=     "document.all['" + divId + "'].style.display = 'block';"
				tabEv += "} else {"
				tabEv +=    "document.all['" + divId + "'].style.display = 'none';"
				tabEv += "}"
				return tabEv;
			},
			BtnOnClickA : function(values){
				var divId = 'divCtlResult-' + values.EpisodeID;
				//"��ʾ������Ϣ"��ť�����¼�
				var tabEv = '';
				tabEv += "if (document.all['" + divId + "'].style.display == 'none') {"
				tabEv +=     "document.all['" + divId + "'].style.display = 'block';"
				tabEv +=     "objScreenMsg.btnBaseInfo_onClick(\'" + values.EpisodeID + "\');"
				tabEv += "} else {"
				tabEv +=    "document.all['" + divId + "'].style.display = 'none';"
				tabEv += "}"
				return tabEv;
			},
			BtnOnClickB : function(values,operation){
				//���Ʋ������ô����¼�
				var tabEv = 'objScreenMsg.btnHandle_onClick(\'' + values.EpisodeID + '\',\'' + operation + '\');';
				return tabEv;
			},
			BtnOnClickC : function(values){
				//���Ʋ��� �鿴ժҪ��Ϣ����
				var tabEv = 'objScreenMsg.btnSummary_onClick(\'' + values.EpisodeID + '\');';
				return tabEv;
			}
		}
	);
	
	obj.setCasesMsgScrollTop = function(aCmpId)
	{
		var objCmp = document.getElementById(aCmpId);
		if (objCmp) objCmp.scrollTop = objCmp.scrollHeight;
	}
	
	obj.btnSummary_onClick = function(EpisodeID)
	{
		var ConfigCode = obj.LoadCasesXDtlArgs.ConfigCode;
		var objDisplayWin = new InitPatientDtl(EpisodeID, ConfigCode);
		objDisplayWin.WinPatientDtl.show();
	}
	
	obj.btnHandle_onClick = function(EpisodeID, aOperation)
	{
		var Operation = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CommonSrv", "GetHandleGradeByCode", aOperation);
		if (!Operation) return;
		
		var objPatient = obj.CasesXData.PatientList[EpisodeID];
		if (!objPatient) return;
		var CasesXIDs = '';
		if ((aOperation != '4')&&(aOperation != '5')){
			for (var indCasesX = 0; indCasesX < objPatient.CasesXList.length; indCasesX++) {
				var objCasesX = objPatient.CasesXList[indCasesX];
				if (objCasesX.HandleGrade != 'δ����') continue;
				CasesXIDs = CasesXIDs + ',' + objCasesX.CasesXID;
			}
			CasesXIDs = CasesXIDs.substring(1,CasesXIDs.length);
			if (CasesXIDs == '') {
				ExtTool.alert('��ʾ','��"δ����"�����Ʋ���ɸ���¼,������' + Operation + '������!');
				return;
			}
		}
		
		//��鴦�ò����뵱ǰ״̬�Ƿ����
		var ConfigCode = obj.LoadCasesXDtlArgs.ConfigCode;
		var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "CheckCasesHandle", "HA", ConfigCode, EpisodeID, aOperation);
		if (parseInt(flg) < 1) {
			var arrError = flg.split('^');
			if (arrError[0] == '-1') {
				ExtTool.alert('������ʾ',arrError[1]);
			} else if (arrError[0] == '-999') {
				ExtTool.alert('������ʾ',arrError[1]);
			} else {
				ExtTool.alert('������ʾ','Error:' + flg);
			}
			return;
		}
		
		//�������ȡֵ
		var Opinion = '';
		var objCmp = document.getElementById('txtOpinion-' + EpisodeID);
		if (objCmp) Opinion = objCmp.value;
		if (Opinion == OpinionText) Opinion = '';
		if (((aOperation == '2')||(aOperation == '3')||(aOperation == '4'))&&(Opinion == '')) {
			ExtTool.alert('��ʾ','��' + Operation + '��������Ҫ��д"�������",����ɺ����ύ!');
			return;
		}
		
		if (aOperation == '5') {
			//���Ʋ�������(��Ⱦ����)
			var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "CloseCasesHandle", "HA", ConfigCode, EpisodeID, Opinion, session['LOGON.CTLOCID'], session['LOGON.USERID']);
		} else {
			//���Ʋ�������(�ų�\����\ȷ��\��Ϣ)
			var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "ProcCasesHandle", "HA", ConfigCode, EpisodeID, CasesXIDs, aOperation, Opinion, session['LOGON.CTLOCID'], session['LOGON.USERID'],0);
		}
		if (parseInt(flg) > 0) {
			//ExtTool.alert('��ʾ','��' + Operation + '�������ɹ�!');
		} else {
			ExtTool.alert('������ʾ','��' + Operation + '����������!Error=' + flg);
		}
		//���¼�������
		obj.UpLoadCasesXDtl();
	}
	
	//"��ʾ������Ϣ"��ť�����¼�
	obj.btnBaseInfo_onClick = function(EpisodeID)
	{
		if (!EpisodeID) return;
		
		var objPatient = obj.CasesXData.PatientList[EpisodeID];
		if (!objPatient) return;
		
		var ConfigCode = obj.LoadCasesXDtlArgs.ConfigCode;
		var strDateList = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesXSrv", "GetCtlDateList", ConfigCode, EpisodeID);
		if (!strDateList) return;
		var arrDateList = strDateList.split(',');
		objPatient.CtlDateList = arrDateList;
		objPatient.CtlDateListI = new Array();
		for (var indDate = 0; indDate < arrDateList.length; indDate++) {
			var tmpDate = arrDateList[indDate];
			objPatient.CtlDateListI[tmpDate] = indDate;
		}
		
		//���ػ�����Ϣ����
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.CasesXSrv',
				QueryName : 'QryCtlResult',
				Arg1 : ConfigCode,
				Arg2 : EpisodeID,
				ArgCnt : 2
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				
				var objPatient = obj.CasesXData.PatientList[EpisodeID];
				if (!objPatient) return;
				objPatient.CtlRstList = new Array();
				objPatient.CtlRstListI = new Array();
				
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					if (typeof(objPatient.CtlDateListI[objItem.OccurDate]) == 'undefined') continue;
					
					var ItemCat = objItem.ItemCatID;
					var ItemSubCat = objItem.SubCatID;
					var indexItemCat = ItemCat + '-' + ItemSubCat;
					
					if (typeof(objPatient.CtlRstListI[indexItemCat]) != 'undefined') {
						var ind = objPatient.CtlRstListI[indexItemCat];
						var objSubCat = objPatient.CtlRstList[ind];
						if (typeof(objSubCat.ItemDateList[objItem.OccurDate]) != 'undefined') {
						} else {
							objSubCat.ItemDateList[objItem.OccurDate] = {
								ItemDate : objItem.OccurDate,
								ItemList : new Array
							}
						}
					} else {
						var objSubCat = {
							ItemCatID : objItem.ItemCatID,
							ItemCat : objItem.ItemCatDesc,
							ItemSubCatID : objItem.SubCatID,
							ItemSubCat : objItem.SubCatDesc,
							ItemDateList : new Array()
						}
						objSubCat.ItemDateList[objItem.OccurDate] = {
							ItemDate : objItem.OccurDate,
							ItemList : new Array
						}
						var ind = objPatient.CtlRstList.length;
						objPatient.CtlRstListI[indexItemCat] = ind;
						objPatient.CtlRstList[ind] = objSubCat;
					}
					var ind = objSubCat.ItemDateList[objItem.OccurDate].ItemList.length;
					objSubCat.ItemDateList[objItem.OccurDate].ItemList[ind] = objItem;
					var ind = objPatient.CtlRstListI[indexItemCat];
					objSubCat.CtlDateList = new Array();
					objSubCat.CtlDateList = objPatient.CtlDateList;
					objPatient.CtlRstList[ind] = objSubCat;
				}
				obj.CasesXData.PatientList[EpisodeID] = objPatient;
				
				obj.CtlResultXTemplate.overwrite("divCtlResult-" + EpisodeID,[objPatient]);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divCtlResult-" + EpisodeID);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
		
		//���û�����ϢX�������λ��
		setTimeout('objScreenMsg.setBaseInfoScrollLeft("divCtlResult-' + EpisodeID + '")',500);
	}
	
	obj.setBaseInfoScrollLeft = function(aCmpId)
	{
		var XTable = document.getElementById(aCmpId + '-x-table');
		var Table = document.getElementById(aCmpId + '-table');
		var XScroll = document.getElementById(aCmpId + '-x-scroll');
		var Scroll = document.getElementById(aCmpId + '-scroll');
		if ((!XTable)||(!Table)||(!XScroll)||(!Scroll)) return;
		
		XTable.style.width = (Table.clientWidth+20) + "px";
		XScroll.scrollLeft = XScroll.scrollWidth;
		Scroll.scrollLeft = Scroll.scrollWidth;
		
		XScroll.onscroll = function (e) {
			Scroll.scrollLeft = XScroll.scrollLeft;
		}
	}
	
	obj.tabCancelHandle_onDblClick = function(aHandleType,aHandleID)
	{
		if (aHandleType != "HA") {
			ExtTool.alert('������ʾ','���ܳ����Լ��Ĵ��ü�¼');
			return;
		}
		//ȡ�����ü�¼
		var flg = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv", "CancelCasesHandle", 'HA', aHandleID, session['LOGON.CTLOCID'], session['LOGON.USERID']);
		if (parseInt(flg) > 0) {
			//���¼��ص�ǰ�������Ʋ���ɸ������
			var EpisodeID = flg;
			//obj.LoadAdmCasesX(EpisodeID);
		} else {
			var tmpRet=flg.split('^');
			if (tmpRet[0] == '-999') {
				ExtTool.alert('������ʾ','ȡ�����ü�¼ʧ��!Error:' + tmpRet[1]);
			} else if (tmpRet[0] == '-1') {
				ExtTool.alert('������ʾ',tmpRet[1]);
			} else {
				ExtTool.alert('������ʾ','ȡ�����ü�¼ʧ��!Error=' + flg);
			}
		}
		//���¼�������
		obj.UpLoadCasesXDtl();
	}
	
	//��������ı����ȡ���㴥���¼�
	obj.txtOpinion_onFocus = function(EpisodeID)
	{
		var txtId = 'txtOpinion-' + EpisodeID;
		var objCmp = document.getElementById(txtId);
		if (objCmp) {
			var Opinion = objCmp.value;
			if (Opinion == OpinionText) {
				objCmp.value = '';
			}
		}
	}
	
	//��������ı���ʧȥ���㴥���¼�
	obj.txtOpinion_onBlur = function(EpisodeID)
	{
		var txtId = 'txtOpinion-' + EpisodeID;
		var objCmp = document.getElementById(txtId);
		if (objCmp) {
			var Opinion = objCmp.value;
			if (Opinion == '') {
				objCmp.value = OpinionText;
			}
		}
	}
	
	obj.setButtonDisabled = function(aButtonId,aFlag)
	{
		var button= document.getElementById(aButtonId);
		if (button) {
			button.disabled = aFlag;
			button.setAttribute("class","button2");
		}
	}
	
	return obj;
}
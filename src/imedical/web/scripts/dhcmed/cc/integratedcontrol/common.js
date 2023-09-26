var objINTCCommon = new Object();
objINTCCommon.RenderCtlResult = function(TargetElement, arryResult)
{
	var objTargetElement = document.getElementById(TargetElement);
	if (!objTargetElement) return;
	if(arryResult.length == 0) {
		objTargetElement.innerHTML = "";
		return;
	}
	
	arryResult.SubType = new Object();
	for (var i = 0 ; i < arryResult.length; i++)
	{
		objItm = arryResult[i];
		var strSubCat = objItm.SubCatTitle;
		if (strSubCat != "")
		{
			if (arryResult.SubType[strSubCat] == null)
			{
				arryResult.SubType[strSubCat] = new Array();
			}
			arryResult.SubType[strSubCat][arryResult.SubType[strSubCat].length] = objItm;
		} else {
			if (arryResult.SubType['����'] == null)
			{
				arryResult.SubType['����'] = new Array();
			}
			arryResult.SubType['����'][arryResult.SubType['����'].length] = objItm;
		}
	}
	
	arrySubCat = new Array();
	for (var strSubCat in arryResult.SubType)
	{
		var objSubCat = new Object();
		objSubCat.SubCatDesc = strSubCat;
		objSubCat.RecordCount = arryResult.SubType[strSubCat].length;
		arrySubCat[arrySubCat.length] = objSubCat;
	}
	
	var objTemplateDtl = new Ext.XTemplate(
		'<table width="98%" class="table4">',
			'<tr>',
				'<td width="5%">���</td>',
				'<td width="60%">��Ŀ</td>',
				'<td width="10%">�û�</td>',
				'<td width="10%">����</td>',
				'<td width="10%">ʱ��</td>',
			'</tr>',
			'<tbody>',
			'<tpl for=".">',
				'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
					'<td>{[ this.GetActNote([xindex],values.ActFlag) ]}</td>',
					'<td>{Summary}</td>',
					'<td>{UserName}</td>',
					'<td>{ActDate}</td>',
					'<td>{ActTime}</td>',
				'</tr>',
			'</tpl>',
			'</tbody>',
		'</table>',
		'<br/>',
		{
			GetActNote : function(note,actfalg)
			{
				if (actfalg == 1) {
					return "<font style='color:red;'>" + note + "</font>";
				} else {
					return note;
				}
			}
		}
	);
	
	var objTemplate = new Ext.XTemplate(
		'<table width="100%" class="table1"><tr><td>������ָ��</td></tr></table>',
		'<table width="100%" class="table2">',
			'<tr>',
				'<td width="100%">',
					'<table width="100%" class="table3">',
						'<tr>',
							'<td width="5%">���</td>',
							'<td width="20%">��������</td>',
							'<td width="60%">��¼��</td>',
						'</tr>',
					'</table>',
				'</td>',
			'</tr>',
			'<tbody>',
			'<tpl for=".">',
				'<tr>',
					'<td width="100%" ondblclick="{[this.RowOnClick(values)]}">',
						'<table width="100%" class="table3">',
							'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
								'<td width="5%">{[xindex]}</td>',
								'<td width="20%">{SubCatDesc}</td>',
								'<td width="60%">�� {RecordCount} ����¼</td>',
							'</tr>',
						'</table>',
					'</td>',
				'</tr>',
				'<tr>',
					'<td width="100%">',
						'{[this.FormatHTML(values)]}',
					'</td>',
				'</tr>',
			'</tpl>',
			'</tbody>',
		'</table>',
		'<br/>',
		{
			FormatHTML : function(values)
			{
				var divId = 'pnDtl-' + TargetElement + '-' + values.SubCatDesc
				
				var div = ''
				div +=    '<div style="margin-left:0%;width:99%;display:none" id="' + divId + '">'
				div +=        objTemplateDtl.apply(arryResult.SubType[values.SubCatDesc]);
				div +=    '</div>'
				
				return div;
			},
			RowOnClick : function(values)
			{
				var divId = 'pnDtl-' + TargetElement + '-' + values.SubCatDesc;
				
				var tabEv = '';
				tabEv += "if (document.all['" + divId + "'].style.display == 'none') {"
				tabEv +=     "document.all['" + divId + "'].style.display = 'block';"
				tabEv += "} else {"
				tabEv +=    "document.all['" + divId + "'].style.display = 'none';"
				tabEv += "}"
				
				return tabEv;
			}
		}
	);
	objTemplate.overwrite(TargetElement, arrySubCat);
}

objINTCCommon.RenderInfReport = function(TargetElement, arryResult)
{
	var objTargetElement = document.getElementById(TargetElement);
	if (!objTargetElement) return;
	if(arryResult.length == 0) {
		objTargetElement.innerHTML = "";
		return;
	}
	var objTemplate = new Ext.XTemplate(
		'<table width="100%" class="table1"><tr><td>ҽԺ��Ⱦ����</td></tr></table>',
		'<table class="table2" width="100%">',
			'<tr>',
				'<td width="5%">���</td>',
				'<td width="20%">��λ</td>',
				'<td width="20%">��Ⱦ���</td>',
				'<td width="8%">�걾</td>',
				'<td width="17%">��ԭ��</td>',
				'<td width="10%">�ϱ�����</td>',
				'<td width="10%">����</td>',
				'<td width="5%">ʱ��</td>',
			'</tr>',
			'<tpl for=".">',
				'<tr class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
					'<td>{[xindex]}</td>',
					'<td><a href="#" onclick="window.open(\'./dhcmed.ninf.rep.infreport.csp?&ReportID={ReportID}\',\'_blank\',\'width=850,height=550,scrollbars=no,resizable=no\')">{Position}</a></td>',
					'<td>{Diagnose}</td>',
					'<td>{Specimen}</td>',
					'<td>{Pathogeny}</td>',
					'<td>{RepCtloc}</td>',
					'<td>{RepDate}</td>',
					'<td>{RepTime}</td>',
				'</tr>',
			'</tpl>',
		'</table>',
		'<br/>'
	);		
	objTemplate.overwrite(TargetElement, arryResult);
}


objINTCCommon.RenderEpdReport = function(TargetElement, arryResult)
{
	var objTargetElement = document.getElementById(TargetElement);
	if (!objTargetElement) return;
	if(arryResult.length == 0) {
		objTargetElement.innerHTML = "";
		return;
	}
	var objTemplate = new Ext.XTemplate(
		'<table width="100%" class="table1"><tr><td>��Ⱦ������</td></tr></table>',
		'<table class="table2" width="100%">',
			'<tr>',
				'<td width="5%">���</td>',
				'<td width="15%">��Ⱦ������</td>',
				'<td width="20%">��������</td>',
				'<td width="8%">״̬</td>',
				'<td width="17%">�ϱ�������</td>',
				'<td width="15%">�ϱ�����</td>',
				'<td width="10%">����</td>',
				'<td width="5%">ʱ��</td>',
			'</tr>',
			'<tpl for=".">',
				'<tr class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
					'<td>{[xindex]}</td>',
					'<td>{RepRank}</td>',
					'<td><a href="#" onclick="window.open(\'./dhcmed.epd.report.csp?1=1&PatientID={PatientID}&EpisodeID={Paadm}&ReportID={RowID}\',\'_blank\',\'width=900,height=650,scrollbars=no,resizable=no\')">{DiseaseName}</a></td>',
					'<td>{Status}</td>',
					'<td>{RepUserName}</td>',
					'<td>{ReportDep}</td>',
					'<td>{RepDate}</td>',
					'<td>{RepTime}</td>',
				'</tr>',
			'</tpl>',
		'</table>',
		'<br/>'
	);		
	objTemplate.overwrite(TargetElement, arryResult);
}

objINTCCommon.RenderSummary = function(TargetElement, arryResult)
{
	var objTargetElement = document.getElementById(TargetElement);
	if (!objTargetElement) return;
	if(arryResult.length == 0) {
		objTargetElement.innerHTML = "";
		return;
	}
	var objTemplate = new Ext.XTemplate(
		'<table width="100%" class="table1"><tr><td>��ؽ������</td></tr></table>',
		'<table class="table2" width="100%">',
			'<tr>',
				'<td>���</td>',
				'<td>����</td>',
				'<td>��������Ŀ����</td>',
				'<td>��������Ŀ����</td>',
				'<td>�÷�</td>',
				'<td>״̬</td>',
			'</tr>',
			'<tpl for=".">',
				'<tr class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
					'<td>{[xindex]}</td>',
					'<td>{ActDate}</td>',
					'<td>{SensitiveAmount}</td>',
					'<td>{SpecificityAmount}</td>',
					'<td>{ScoreThisTime}</td>',
					'<td>{Status}</td>',
				'</tr>',
			'</tpl>',
		'</table>',
		'<br/>'
	);		
	objTemplate.overwrite(TargetElement, arryResult);
}

objINTCCommon.RenderFeedback = function(TargetElement, arryResult, showAll)
{
	var objTargetElement = document.getElementById(TargetElement);
	if (!objTargetElement) return;
	if(arryResult.length == 0) {
		objTargetElement.innerHTML = "";
		return;
	}
	var objTemplate = new Ext.XTemplate(
		'<div class="t-bg">',
			'<table width="100%" class="table1"><tr><td>������Ϣ</td></tr></table>',
			'<table class="table2" width="100%">',
				//'<tdead>',
				//'<tr>',
				//	'<td class="Result_Table_Notice_th" colspan="12"><b>��ʾ��Ϣ</b></td>',
				//'</tr>',
				'<tr>',
					'<td>���</td>\r\n',
					'<td>��������</td>\r\n',
					'<td>����ҽʦ</td>\r\n',
					'<td>��������</td>\r\n',
					'<td>����ʱ��</td>\r\n',
					'<td>�ظ���Ϣ</td>\r\n',
					'<td>�ظ�ҽʦ</td>\r\n',
					'<td>�ظ�����</td>\r\n',
					'<td>�ظ�ʱ��</td>\r\n',	
					'<td>�������</td>\r\n',	
					'<td>��ǰ״̬</td>\r\n',
					//'<td>����</td>\r\n',
				'</tr>\r\n',
				'</thead>\r\n',
				//'<tbody>',
				'<tpl for=".">',
					'<tr class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">\r\n',
						//'<td>{[xindex]}</td>',
						'<td>{[ this.GetActNote([xindex],values.ActFlag) ]}</td>\r\n',
						'<td>{FeedBackNote}</td>\r\n',
						'<td>{FeedBackUser}</td>\r\n',
						'<td>{FeedBackDate}</td>\r\n',
						'<td>{FeedBackTime}</td>\r\n',
						'<td>{ReceiveNote}</td>\r\n',
						'<td>{ReceiveUser}</td>\r\n',
						'<td>{ReceiveDate}</td>\r\n',
						'<td>{ReceiveResult}</td>\r\n',
						'<td>{ReceiveTime}</td>\r\n',
						'<td>{[ this.GetStatusDesc(values.Status) ]}</td>\r\n',
						//'<td>{[ this.GetReportButton(values.FeedBackRepType,values.EpisodeID,values.PatientID) ]}</td>',
						//'<td>aaa</td>\r\n',
					'</tr>\r\n',
				'</tpl>',
				//'</tbody>',
			'</table>\r\n',
		'</div>',
		'<br/>',
		{
			GetStatusDesc : function(v)
			{
				if(v == 0)
					return "<B style='color:red;'>��δ��Ӧ<B>";
				if(v == 1)
					return "<B style='color:blue;'>����</B>";
				if(v== 2)
					return "<B>�ų�</b>";
			},
			GetActNote : function(note,actfalg)
			{
				if (actfalg == 1) {
					return "<font style='color:red;'>" + note + "</font>";
				} else {
					return note;
				}
			},
			GetReportButton : function(RepType, EpisodeID, PatientID)
			{
				var strHTML = "";
				switch(RepType)
				{
					case "01":
						strHTML = '<a href="#" onclick="window.showModalDialog(\'./dhcmed.ninf.rep.infreport.csp?&ReportType=COMP&EpisodeID=' + EpisodeID + '\',\'\',\'dialogWidth:900px;dialogHeight:600px;center:on;scrollbars:no;resizable:no;\')"><img src="../scripts/dhcmed/img/reportinf.gif"  alt="ҽԺ��Ⱦ����" /></a> ';
						break;
					case "02":
						strHTML = '<a href="#" onclick="window.showModalDialog(\'./dhcmed.epd.report.csp?&1=1&PatientID='+PatientID+'&EpisodeID='+EpisodeID+'&ReportID=\',\'\',\'dialogWidth=920px;dialogHeight=640px;status=no;\');"><img src="../scripts/dhcmed/img/reportepd.gif"  alt="��Ⱦ������" /></a> ';
						break;
				}
				return strHTML;
			}
		}
		
	);		
	//var strTmp = objTemplate.apply(arryResult);
	//window.alert(strTmp);
	objTemplate.overwrite(TargetElement, arryResult);
}

// ���ڴ�С�Ƚ�  ��ʽ��2013-03-22
objINTCCommon.CompareDate = function(startDate,endDate) {
	var startMonth = startDate.substring(5,startDate.lastIndexOf ("-"));
	var startDay = startDate.substring(startDate.length,startDate.lastIndexOf ("-")+1);
	var startYear = startDate.substring(0,startDate.indexOf ("-"));
	
	var endMonth = endDate.substring(5,endDate.lastIndexOf ("-"));
	var endDay = endDate.substring(endDate.length,endDate.lastIndexOf ("-")+1);
	var endYear = endDate.substring(0,endDate.indexOf ("-"));
	
	if (Date.parse(startMonth+"/"+startDay+"/"+startYear) > Date.parse(endMonth+"/"+endDay+"/"+endYear)) { 
		return false;
	}
	return true;
}
	

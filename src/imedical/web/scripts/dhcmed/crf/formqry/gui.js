var objScreen = new Object();
function InitFormQry(){
	var obj = objScreen;
	
	var htmlNorthPanel = ''
		+ '<table>'
		+ 	'<tr>'
		+ 		'<td><span style="width=60px;">报告日期:</span></td><td id="txtDateFromTD"></td><td>-</td><td id="txtDateToTD"></td>'
		+ 		'<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>'
		+ 		'<td><span style="width=60px;">报告状态:</span></td><td id="cbgRepStatusTD"></td>'
		+ 		'<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>'
		+ 		'<td id="btnQueryTD"></td>'
		+ 		'<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>'
		+ 		'<td id="btnExportTD"></td>'
		+ 		'<td width="90%"></td>'
		+ 	'</tr>'
		+ '</table>'
	
	obj.NorthPanel = new Ext.Panel({
		id : 'NorthPanel',
		region : 'north',
		frame : true,
		html : htmlNorthPanel,
		height : 45
	});
	
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
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#483D8B;" align="center">未设置报告</td>'
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#4682B4;" align="center">未设置报告</td>'
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#4682B4;" align="center">未设置报告</td>'
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#4682B4;" align="center">未设置报告</td>'
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#4682B4;" align="center">未设置报告</td>'
		+ 	'</tr>'
		+ '</table>'
	} else {
		if (obj.RepTypeList.length > 1){
			htmlMainPanel += ''
			+ '<table style="border:1px solid wight;width=100%;">'
			var indNumber = 0;
			for (var indRepType = 0; indRepType < obj.RepTypeList.length; indRepType++) {
				if ((indNumber%5) == 0) htmlMainPanel += '<tr>';
				var objRepType = obj.RepTypeList[indRepType];
				htmlMainPanel += '<td  onclick="objScreen.btnRepType_OnClick(' + indRepType + ');"'
							+ 'style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#4682B4;" align="center">' + objRepType.TypeDesc + '</td>';
				if ((indNumber%5) == 4) htmlMainPanel += '</tr>';
				indNumber++;
			}
			indNumber--;
			if ((indNumber%5) < 4) {
				for (var indTmp = 0; indTmp < (4-(indNumber%5)); indTmp++) {
					htmlMainPanel += '<td '
					+ 'style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#4682B4; align="center">&nbsp;</td>';
				}
				htmlMainPanel += '</tr>';
			}
			htmlMainPanel += '</table>';
		}
	}
	htmlMainPanel += '<div id="RepXTemplateDIV"></div>';
	htmlMainPanel += '<div id="ErrXTemplateDIV"></div>';
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,region : 'center'
		,autoScroll : true
		//,frame : true
		,html : htmlMainPanel
	});
	
	obj.FormQryWin = new Ext.Viewport({
		id : 'FormQryWin'
		,layout : 'border'
		,items:[
			obj.NorthPanel
			,obj.MainPanel
		]
	});
	
	obj.txtDateFrom = new Ext.form.DateField({
		id : 'txtDateFrom'
		,fieldLabel : '开始日期'
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateFromTD'
		,value : new Date().add(Date.DAY,-1)
	});
	obj.txtDateTo = new Ext.form.DateField({
		id : 'txtDateTo'
		,fieldLabel : '结束日期'
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateToTD'
		,value : new Date()
	});
	obj.cbgRepStatus = new Ext.form.CheckboxGroup({
		id : 'cbgRepStatus'
		,fieldLabel : '报告状态'
		,xtype : 'checkboxgroup'
		,columns : 3
		,items : [
			{id : 'cbgRepStatus-01', boxLabel : '待审', name : 'cbgRepStatus-01', inputValue : '01', checked : true}
			,{id : 'cbgRepStatus-02', boxLabel : '审核', name : 'cbgRepStatus-02', inputValue : '02', checked : false}
			,{id : 'cbgRepStatus-99', boxLabel : '删除', name : 'cbgRepStatus-99', inputValue : '99', checked : false}
		]
		,width : 200
		,height : 22
		,renderTo : 'cbgRepStatusTD'
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,width : 60
		,text : '查询'
		,renderTo : 'btnQueryTD'
	})
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,width : 60
		,text : '导出'
		,renderTo : 'btnExportTD'
	})
	
	obj.RepXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<div class="subtotal">', 
				'<table width="100%">',
					'<tr>',
						 '<td width="5%" class="subtotal_td"><img src="../scripts/dhcmed/img/clinrep08.png" width="98" height="31" /></td>',
						 '<td width="85%" class="subtotal_td">&nbsp;&nbsp;&nbsp;&nbsp;{TypeDesc}：&nbsp;&nbsp;<span class="subtotal_number">共{ReportCount}份</span>&nbsp;&nbsp;</td>',
						 '<td width="10%" class="subtotal_td"></td>',
					'</tr>',
				'</table>',
			'</div>',
			//自定义表单列表显示
			'<tpl if="(TypeCate==\'CRF\')">',
				'<table width="100%" class="table1">',
					'<tr style="border-bottom:1px #BDBDBD solid;font-size:16px;">',
						'<td align="center">序号</td>',
						'<td align="center">姓名</td>',
						'<td align="center">性别</td>',
						'<td align="center">年龄</td>',
						'<td align="center">报告ID</td>',
						'<td align="center">状态</td>',
						'<td align="center">报告时间</td>',
						'<td align="center">报告科室</td>',
						'<td align="center">报告人</td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;font-size:16px;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="left">{patientName}</td>',
								'<td align="center">{patientSex}</td>',
								'<td align="center">{patientAge}</td>',
								'<td align="center" onclick="{[this.LnkRepOnClick(\'CRF\',\'\',values)]}"><span style="border-bottom:1px #F78181 solid;">{DataId}</span></td>',
								'<td align="center">{CurrentStatus}</td>',
								'<td align="center">{CreateDate} {CreateTime}</td>',
								'<td align="left">{CreateCTLocDesc}</td>',
								'<td align="left">{CreateUserName}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,9) ]}',
					'</tbody>',
				'</table>',
			'</tpl>',
			//'<table style="border:1px #F78181 solid;width:100%;height:2px;background-color:#F78181"><tr><td></td></tr></table>',
		'</tpl>',
		{
			NewRepOnClick : function(values){
				var tabEv = 'objScreen.LnkRepOnClick(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\',\'\');';
				return tabEv;
			},
			LnkRepOnClick : function(TypeCate,TypeCode,values){
				if (TypeCate == 'CRF') {
					var arrTmp = values.FormVerDR.split('||');
					TypeCode = arrTmp[0];
				}
				var tabEv = 'objScreen.LnkRepOnClick(\'' + TypeCate + '\',\'' + TypeCode + '\',\'' + values.DataId + '\');';
				return tabEv;
			},
			GetSpacebarRow : function(values,colnum){
				//添加空行
				var tabEv = '';
				var row = values.ReportList.length;
				if (row < 1) {
					for (var indRow = row; indRow < 1; indRow++){
						tabEv += '<tr  class="' + ((indRow + 1) % 2 == 1 ? 'RowEven' : 'RowOdd') + '" style="border-bottom:1px #BDBDBD solid;">'
						for (var indCol = 0; indCol < colnum; indCol++){
							tabEv += 	'<td align="center">&nbsp;</td>'
						}
						tabEv += '</tr>'
					}
				}
				return tabEv;
			}
		}
	);
	
	InitFormQryEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
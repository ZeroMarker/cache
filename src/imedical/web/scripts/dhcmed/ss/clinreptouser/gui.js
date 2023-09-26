var objScreen = new Object();
function InitClinRepToUser(){
	var obj = objScreen;
	
	var htmlNorthPanel = ''
		+ '<table>'
		+ 	'<tr>'
		+ 		'<td><span style="width=60px;">报告日期:</span></td>'
		+ 		'<td id="txtDateFromTD"></td><td>-</td><td id="txtDateToTD"></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>'
		+ 		'<td id="btnQueryTD"></td>'
		+ 		'<td width="90%"></td>'
		+ 	'</tr>'
		+ '</table>'
	
	obj.NorthPanel = new Ext.Panel({
		id : 'NorthPanel',
		region : 'north',
		split:true,
		collapsible: true,
		collapsed : true,
        lines:false,
        animCollapse:false,
        animate: false,
        collapseMode:'mini',
		collapseFirst:false,
		hideCollapseTool:true,
		border:true,
		boxMinHeight : 45,
		boxMaxHeight : 45,
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
		+ '<table style="border:0px solid wight;width=100%;">'
		+ 	'<tr>'
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#330099;" align="center"><b>未设置报告</b></td>'
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#3399CC;" align="center"><b>未设置报告</b></td>'
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#3399CC;" align="center"><b>未设置报告</b></td>'
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#3399CC;" align="center"><b>未设置报告</b></td>'
		+ 		'<td style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#3399CC;" align="center"><b>未设置报告</b></td>'
		+ 	'</tr>'
		+ '</table>'
	} else {
		if (obj.RepTypeList.length > 1){
			htmlMainPanel += ''
			+ '<table style="border:0px solid wight;width=100%;">'
			+	'<tr>'
			+		'<td onclick="objScreen.btnRepType_OnClick(' + -1 + ');"'
			+		'style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#330099;" align="center"><b>全部</b></td>'
			for (var indRepType = 0; indRepType < obj.RepTypeList.length; indRepType++) {
				var indNumber = indRepType+1;
				if ((indNumber%5) == 0) htmlMainPanel += '<tr>';
				var objRepType = obj.RepTypeList[indRepType];
				htmlMainPanel += '<td  onclick="objScreen.btnRepType_OnClick(' + indRepType + ');"'
							+ 'style="width:20%;font-family:verdana;color:red;font-size:24px;background-color:#3399CC;" align="center"><b>' + objRepType.TypeDesc + '</b></td>';
				if ((indNumber%5) == 4) htmlMainPanel += '</tr>';
			}
			if ((indNumber%5) < 4) {
				for (var indTmp = 0; indTmp < (4-(indNumber%5)); indTmp++) {
					htmlMainPanel += '<td '
					+ 'style="width:20%;font-family:verdana;color:red;font-size:20px;background-color:#3399CC; align="center">&nbsp;</td>';
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
	
	obj.ClinRepToUserWin = new Ext.Viewport({
		id : 'ClinRepToUserWin'
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
		,value : new Date().add(Date.DAY,-30*2)
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
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,width : 60
		,text : '查询'
		,renderTo : 'btnQueryTD'
	})
	
	obj.RepXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<div style="border:0px solid wight;padding:3px;width:100%;">',
			'<div class="subtotal">',
				'<table width="100%">',
					'<tr>',
						 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 80px; height: 30px;"><img src="../scripts/dhcmed/img/clinrep08.png" width="60" height="25" style="position: absolute; top: 2; left: 10;" /></div></td>',
						 '<td width="80%" class="subtotal_td">{TypeDesc}：&nbsp;&nbsp;<span class="subtotal_number">共{ReportCount}份</span>&nbsp;&nbsp;</td>',
				//		 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 100px; height: 30px;"><img  onclick="{[this.NewRepOnClick(values)]}" src="../scripts/dhcmed/img/newreport.gif" width="100" height="28" /><span style="position: absolute; top: 1; left: 12;color:#6293a9;">新建报告</span></div></td>',
						 '<td width="5%" class="subtotal_td"><div style="position: relative;width: 100px;  height: 30px;"><img  onclick="{[this.NewRepOnClick(values)]}" src="../scripts/dhcmed/img/newreport.PNG" width="100" height="28" /></div></td>',
						 '<td width="5%" class="subtotal_td"></td>',
						 '<td width="5%" class="subtotal_td"><div id="btnExport" style="position: relative; height: 30px;"><img  onclick="{[this.ExportOnClick(values)]}" src="../scripts/dhcmed/img/export1.PNG" width="62" height="28" /></div></td>',
					'</tr>',
				'</table>',
			'</div>',
			//自定义表单列表显示
			'<tpl if="(TypeCate==\'CRF\')">',
				'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
					'<tr style="font-size:18px;height:30px;">',
						'<td align="center"><b>序号</b></td>',
						'<td align="center"><b>姓名</b></td>',
					//	'<td align="center"><b>性别</b></td>',
					//	'<td align="center"><b>年龄</b></td>',
						'<td align="center"><b>报告ID</b></td>',
						'<td align="center"><b>状态</b></td>',
						'<td align="center"><b>报告时间</b></td>',
						'<td align="center"><b>报告科室</b></td>',
						'<td align="center"><b>报告人</b></td>',
					'</tr>',
					'<tbody>',
						'<tpl for="ReportList">',
							'<tr  class="{[ (xindex % 2 == 1 ? \"RowEven\" : \"RowOdd\")]}" style="font-size:16px;height:30px;">',
								'<td align="center" style="border-top:1 solid cornflowerblue;border-left:1 solid cornflowerblue;border-right:1 solid cornflowerblue;border-bottom:1 solid conflowerblue">{[xindex]}</td>',
								'<td align="left" style="border-top:1 solid cornflowerblue;border-left:1 solid cornflowerblue;border-right:1 solid cornflowerblue;border-bottom:1 solid conflowerblue">{GoalUserName}</td>',
							//	'<td align="center" style="border-top:1 solid cornflowerblue;border-left:1 solid cornflowerblue;border-right:1 solid cornflowerblue;border-bottom:1 solid conflowerblue">{patientSex}</td>',
							//	'<td align="center" style="border-top:1 solid cornflowerblue;border-left:1 solid cornflowerblue;border-right:1 solid cornflowerblue;border-bottom:1 solid conflowerblue">{patientAge}</td>',
								'<td align="center"  style="border-top:1 solid cornflowerblue;border-left:1 solid cornflowerblue;border-right:1 solid cornflowerblue;border-bottom:1 solid conflowerblue" onclick="{[this.LnkRepOnClick(\'CRF\',\'\',values)]}"><span style="border-bottom:1px #F78181 solid;">{DataId}</span></td>',
								'<td align="center" style="border-top:1 solid cornflowerblue;border-left:1 solid cornflowerblue;border-right:1 solid cornflowerblue;border-bottom:1 solid conflowerblue">{CurrentStatus}</td>',
								'<td align="center" style="border-top:1 solid cornflowerblue;border-left:1 solid cornflowerblue;border-right:1 solid cornflowerblue;border-bottom:1 solid conflowerblue">{CreateDate} {CreateTime}</td>',
								'<td align="left" style="border-top:1 solid cornflowerblue;border-left:1 solid cornflowerblue;border-right:1 solid cornflowerblue;border-bottom:1 solid conflowerblue">{CreateCTLocDesc}</td>',
								'<td align="left" style="border-top:1 solid cornflowerblue;border-left:1 solid cornflowerblue;border-right:1 solid cornflowerblue;border-bottom:1 solid conflowerblue">{CreateUserName}</td>',
							'</tr>',
						'</tpl>',
						'{[ this.GetSpacebarRow(values,7) ]}',
					'</tbody>',
				'</table>',
			'</tpl>',
			'<table style="border:1px #3399CC solid;width:100%;height:2px;background-color:#3399CC"><tr><td></td></tr></table>',
			'</div>',
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
			ExportOnClick: function(values){
				var tabEv = 'objScreen.ExportOnClick(\'' + values.TypeCate + '\',\'' + values.TypeCode + '\');';
				return tabEv;
			},
			GetSpacebarRow : function(values,colnum){
				//添加空行
				var tabEv = '';
				var row = values.ReportList.length;
				var minRow = 3;
				if (row < minRow) {
					for (var indRow = row; indRow < minRow; indRow++){
						tabEv += '<tr  class="' + ((indRow + 1) % 2 == 1 ? 'RowEven' : 'RowOdd') + '" style="font-size:16px;height:30px;">'
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
	
	InitClinRepToUserEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
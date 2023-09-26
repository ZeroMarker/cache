var objScreen = new Object();
function InitWarningCtl(){
	var obj = objScreen;
	
	//查询条件
	obj.QueryArgs = {
		ViewType : '',
		WarningDate : '',
		HospitalID : ''
	}
	
	var htmlNorthPanel = ''
		+ '<table width="100%" height="100%"><tr>'
		+ '<td width="1%"><div style="border:0px solid #F78181;height=35px;">'
		+ '<table><tr>'
		+ '    <td><div style="width:35px;text-align:right;overflow:hidden;">医院:</div></td>'
		+ '    <td><div id="cboSSHospTD" style="width:150px;overflow:hidden;"></div></td>'
		+ '    <td><div style="width:35px;text-align:right;overflow:hidden;">日期:</div></td>'
		+ '    <td><div id="txtWarningDateTD" style="width:120px;overflow:hidden;"></div></td>'
		+ '    <td id="btnQueryTD"></td>'
		+ '    <td><div style="width:60px;text-align:right;overflow:hidden;">显示方式:</div></td>'
		+ '    <td><div id="cbgViewTypeTD" style="width:180px;overflow:hidden;"></div></td>'
		+ '</tr></table>'
		+ '</div></td>'
		+ '</tr></table>'
	
	var htmlMainPanel = '<div id="LocXTemplateDIV"></div>'
	
	obj.NorthPanel = new Ext.Panel({
		id : 'NorthPanel',
		region : 'north',
		split:true,
		collapsible: true,
		collapsed : false,
        lines:false,
        animCollapse:false,
        animate: false,
        collapseMode:'mini',
		collapseFirst:false,
		hideCollapseTool:true,
		border:true,
		boxMinHeight : 40,
		boxMaxHeight : 40,
		//frame : true,
		html : htmlNorthPanel,
		height : 40
	});
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,region : 'center'
		,autoScroll : true
		//,frame : true
		,html : htmlMainPanel
	});
	
	obj.WarningWin = new Ext.Viewport({
		id : 'WarningWin'
		,layout : 'border'
		,items:[
			obj.NorthPanel
			,obj.MainPanel
		]
	});
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"NINF");
	
	obj.txtWarningDate = new Ext.form.DateField({
		id : 'txtWarningDate'
		,fieldLabel : '预警日期'
		,format : 'Y-m-d'
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtWarningDateTD'
		,value : new Date()
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,width : 40
		,text : '查询'
		,renderTo : 'btnQueryTD'
	})
	
	obj.cbgViewType = new Ext.form.CheckboxGroup({
		id : 'cbgViewType'
		,fieldLabel : '显示方式'
		,xtype : 'checkboxgroup'
		,columns : 2
		,items : [
			{id : 'cbgViewType-1', boxLabel : '按科室显示', name : 'cbgViewType-1', inputValue : '1', checked : false,
				listeners : {
					check : function(checkbox, checked) {
						if (checked) {
							var chkBoxId = checkbox.id;
							var chkBoxValue = checkbox.inputValue;
							var chkGrpId = chkBoxId.substring(0, chkBoxId.length - chkBoxValue.length-1);
							var chkGrp = Ext.getCmp(chkGrpId);
							if (chkGrp) {
								for (idx = 0; idx < chkGrp.items.length; idx++) {
									var cbId=chkGrp.items.items[idx].id;
									if (cbId!=chkBoxId) {
										chkGrp.setValue(cbId,false);
									}
								}
							}
						}
					}
				}
			}
			,{id : 'cbgViewType-2', boxLabel : '按病区显示', name : 'cbgViewType-2', inputValue : '2', checked : false,
				listeners : {
					check : function(checkbox, checked) {
						if (checked) {
							var chkBoxId = checkbox.id;
							var chkBoxValue = checkbox.inputValue;
							var chkGrpId = chkBoxId.substring(0, chkBoxId.length - chkBoxValue.length-1);
							var chkGrp = Ext.getCmp(chkGrpId);
							if (chkGrp) {
								for (idx = 0; idx < chkGrp.items.length; idx++) {
									var cbId=chkGrp.items.items[idx].id;
									if (cbId!=chkBoxId) {
										chkGrp.setValue(cbId,false);
									}
								}
							}
						}
					}
				}
			}
		]
		,width : 200
		,renderTo : 'cbgViewTypeTD'
	});
	
	obj.LocXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<div style="border:0px solid wight;padding:3px;width:100%;">',
			'<div class="subtotal">', 
				'<table width="100%" onclick="{[this.LocGrpOnClick(values)]}">',
					'<tr>',
						 '<td width="5%" class="subtotal_td"><div style="position: relative; width: 80px; height: 30px;"><img src="../scripts/dhcmed/img/ninf/subtotal08.png" width="60" height="25" style="position: absolute; top: 2; left: 10;" /></div></td>',
						 '<td width="95%" class="subtotal_td">{LocGroup}&nbsp;&nbsp;预警科室：&nbsp;&nbsp;<span class="subtotal_number">共{[this.GetLocGrpCnt(values)]}个</span></td>',
					'</tr>',
				'</table>',
			'</div>',
			'<div id="divLocGrp-{LocGroup}">',
				'<table  width="100%"><tbody>',
					'{[this.FormatHTMLStt()]}',
					'<tpl for="LocList">',
						'{[this.FormatHTML(values,3)]}',
					'</tpl>',
					'{[this.FormatHTMLEnd(3)]}',
				'</tbody></table>',
				'<table class="table0" style="width:100%;height:2px;"><tr><td></td></tr></table>',
			'</div>',
			'</div>',
		'</tpl>',
		{
			GetLocGrpCnt : function(values)
			{
				var LocGrpCnt = values.LocList.length;
				return LocGrpCnt;
			},
			LocGrpOnClick : function(values){
				var divId = 'divLocGrp-' + values.LocGroup;
				//"显示科室明细信息"按钮单击事件
				var tabEv = '';
				tabEv += "if (document.all['" + divId + "'].style.display == 'none') {"
				tabEv +=     "document.all['" + divId + "'].style.display = 'block';"
				tabEv += "} else {"
				tabEv +=    "document.all['" + divId + "'].style.display = 'none';"
				tabEv += "}"
				return tabEv;
			},
			FormatHTMLStt : function()
			{
				objScreen.LocCount = 0;
				return '';
			},
			FormatHTMLEnd : function(colCount)
			{
				var ret = '';
				var LocCount = objScreen.LocCount;
				if ((LocCount-1)%colCount != (colCount-1)) {
					var xcolnum = (colCount-1)-((LocCount-1)%colCount)
					for (var xcol=0;xcol<xcolnum;xcol++) {
						ret += '<td width="' + 100/colCount + '%" style="border:1px Lavender solid;"><table id="tb-Null' + xcol + '" width="100%"><tbody><tr><td></td><tr></tbody></table></td>'
					}
					ret += '</tr>'
				}
				return ret;
			},
			FormatHTML : function(values,colCount)
			{
				var LocCount = objScreen.LocCount;
				LocCount++;
				objScreen.LocCount = LocCount;
				
				var ret = '';
				if ((LocCount-1)%colCount == 0) ret += '<tr>';
				
				ret += '<td width="' + 100/colCount + '%" valign="top" style="border:1px Lavender solid;">'
				ret += '<div>'
				ret += '<table id="tb-' + values.LocID + '" width="100%">'
				ret +=     '<tr>'
				ret +=         '<td colspan="10" align="center" style="border-bottom:1px #F78181 solid;font-family:times;color:#F78181;font-size:20px;"><b>' + values.LocDesc + '</b></td>'
				ret +=     '</tr>'
				
				ret +=     '<tr>'
				ret +=         '<td align="center" style="border-bottom:1px Lavender solid;width:28%">项目</td>'
				var arrWarningDays = objScreen.LocGrpData.WarningDays;
				for (var indDays = 0; indDays < arrWarningDays.length; indDays++) {
					ret +=         '<td align="center" style="border-bottom:1px Lavender solid;width:8%"><a onclick="{[objScreen.LoadWarningList(\'' + values.LocID + '\',\'\',\'Day' + (indDays+1) + '\')]}" href="#">' + arrWarningDays[indDays] + '</a></td>'
				}
				ret +=         '<td align="center" style="border-bottom:1px Lavender solid;width:8%"><a onclick="{[objScreen.LoadWarningList(\'' + values.LocID + '\',\'\',\'Cnt3\')]}" href="#">近3天</a></td>'
				ret +=         '<td align="center" style="border-bottom:1px Lavender solid;width:8%"><a onclick="{[objScreen.LoadWarningList(\'' + values.LocID + '\',\'\',\'Cnt7\')]}" href="#">近7天</a></td>'
				ret +=     '</tr>'
				
				var arryData = values.WarningList;
				for(var indRow = 0; indRow < arryData.length; indRow++)
				{
					var objRec = arryData[indRow];
					if (!objRec) continue;
					
					ret +=     '<tr  class="' + ((indRow % 2 == 1) ? 'RowEven' : 'RowOdd') + '">'
					ret +=         '<td align="right">' + objRec.DataValue + '</td>'
					
					var minNum = 3;
					var num = objRec.Day1;
					if (parseInt(num)<minNum) {
						ret +=         '<td align="center"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day1\')]}" href="#">' + num + '</a></td>'
					} else {
						ret +=         '<td align="center" style="background-color:#F78181"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day1\')]}" href="#">' + num + '</a></td>'
					}
					var num = objRec.Day2;
					if (parseInt(num)<minNum) {
						ret +=         '<td align="center"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day2\')]}" href="#">' + num + '</a></td>'
					} else {
						ret +=         '<td align="center" style="background-color:#F78181"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day2\')]}" href="#">' + num + '</a></td>'
					}
					var num = objRec.Day3;
					if (parseInt(num)<minNum) {
						ret +=         '<td align="center"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day3\')]}" href="#">' + num + '</a></td>'
					} else {
						ret +=         '<td align="center" style="background-color:#F78181"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day3\')]}" href="#">' + num + '</a></td>'
					}
					var num = objRec.Day4;
					if (parseInt(num)<minNum) {
						ret +=         '<td align="center"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day4\')]}" href="#">' + num + '</a></td>'
					} else {
						ret +=         '<td align="center" style="background-color:#F78181"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day4\')]}" href="#">' + num + '</a></td>'
					}
					var num = objRec.Day5;
					if (parseInt(num)<minNum) {
						ret +=         '<td align="center"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day5\')]}" href="#">' + num + '</a></td>'
					} else {
						ret +=         '<td align="center" style="background-color:#F78181"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day5\')]}" href="#">' + num + '</a></td>'
					}
					var num = objRec.Day6;
					if (parseInt(num)<minNum) {
						ret +=         '<td align="center"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day6\')]}" href="#">' + num + '</a></td>'
					} else {
						ret +=         '<td align="center" style="background-color:#F78181"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day6\')]}" href="#">' + num + '</a></td>'
					}
					var num = objRec.Day7;
					if (parseInt(num)<minNum) {
						ret +=         '<td align="center"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day7\')]}" href="#">' + num + '</a></td>'
					} else {
						ret +=         '<td align="center" style="background-color:#F78181"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Day7\')]}" href="#">' + num + '</a></td>'
					}
					var num = objRec.Cnt3;
					if (parseInt(num)<minNum) {
						ret +=         '<td align="center"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Cnt3\')]}" href="#">' + num + '</a></td>'
					} else {
						ret +=         '<td align="center" style="background-color:#F78181"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Cnt3\')]}" href="#">' + num + '</a></td>'
					}
					var num = objRec.Cnt7;
					if (parseInt(num)<minNum) {
						ret +=         '<td align="center"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Cnt7\')]}" href="#">' + num + '</a></td>'
					} else {
						ret +=         '<td align="center" style="background-color:#F78181"><a onclick="{[objScreen.LoadWarningList(\'' + objRec.LocID + '\',\'' + objRec.DataValue + '\',\'Cnt7\')]}" href="#">' + num + '</a></td>'
					}
					ret +=     '</tr>'
				}
				
				ret += '</table>'
				ret += '<br>'
				ret += '</div>'
				ret += '</td>'
				
				if ((LocCount-1)%colCount == (colCount-1)) ret += '</tr>';
				return ret;
			}
		}
	);
	
	Ext.ComponentMgr.all.each(function(cmp){
		var objTD = document.getElementById(cmp.id + 'TD');
		if (objTD) {
			cmp.setWidth(objTD.offsetWidth);
			cmp.render(cmp.id + 'TD');
		}
	});
	
	InitWarningCtlEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
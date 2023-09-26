function InitFPPatInfo(obj){
    obj.FPP_InitView = function(){
		obj.FPP_LoadFPQuery();
	}
	
	obj.FPP_LoadFPQuery = function(){
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCWMR.FPService.FPPatInfoSrv',
				QueryName : 'QryPatInfo',
				Arg1 : obj.FrontPage.FrontPageID,
				Arg2 : obj.FrontPage.VolumeID,
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
				obj.FPP_Template.overwrite("divPatInfo-FP",arryData);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divPatInfo-FP");
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	obj.FPP_Template = new Ext.XTemplate(
		'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;width:100%;">',
			'<tpl for=".">',
				'<tr style="font-size:13px;height:30px;">',
					'<td width="10%" {[this.labelStyle()]}>病案类型：</td><td width="10%" {[this.textStyle()]}>{MrTypeDesc}&nbsp;</td>',
					'<td width="10%" {[this.labelStyle()]}>病案号：</td><td width="10%" {[this.textStyle()]}>{MrNo}&nbsp;</td>',
					'<td width="10%" {[this.labelStyle()]}>姓名：</td><td width="10%" {[this.textStyle()]}>{PatName}&nbsp;</td>',
					'<td width="10%" {[this.labelStyle()]}>性别：</td><td id="txtSex" width="10%" {[this.textStyle()]}>{Sex}&nbsp;</td>',
					'<td width="10%" {[this.labelStyle()]}>年龄：</td><td width="10%" {[this.textStyle()]}>{Age}&nbsp;</td>',
				'</tr>',
				'<tr style="font-size:13px;height:30px;">',
					'<td {[this.labelStyle()]}>登记号：</td><td {[this.textStyle()]}>{PapmiNo}&nbsp;</td>',
					'<td {[this.labelStyle()]}>国籍：</td><td {[this.textStyle()]}>{Country}&nbsp;</td>',
					'<td {[this.labelStyle()]}>证件类型：</td><td {[this.textStyle()]}>{PersonalType}&nbsp;</td>',
					'<td {[this.labelStyle()]}>身份证号：</td><td {[this.textStyle(3)]}>{PersonalID}&nbsp;</td>',
				'</tr>',
				'<tr style="font-size:13px;height:30px;">',
					'<td {[this.labelStyle()]}>入院日期：</td><td {[this.textStyle()]}>{AdmDate} {AdmTime}&nbsp;</td>',
					//'<td {[this.labelStyle()]}>医疗结算：</td><td {[this.textStyle()]}>{EstDischDate} {EstDischTime}&nbsp;</td>',
					'<td {[this.labelStyle()]}>出院日期：</td><td {[this.textStyle()]}>{DischDate} {DischTime}&nbsp;</td>',
					'<td {[this.labelStyle()]}>主管医生：</td><td {[this.textStyle()]}>{DocName}({DocCode})&nbsp;</td>',
					'<td {[this.labelStyle()]}>民族：</td><td {[this.textStyle()]}>{Nation}&nbsp;</td>',
					'<td {[this.labelStyle()]}>婚姻状况：</td><td {[this.textStyle()]}>{Marital}&nbsp;</td>',
				'</tr>',
				'<tr style="font-size:13px;height:30px;">',
					'<td {[this.labelStyle()]}>科室：</td><td {[this.textStyle(3)]}>{Loc}&nbsp;</td>',
					'<td {[this.labelStyle()]}>病区：</td><td {[this.textStyle(3)]}>{Ward}&nbsp;</td>',
					'<td {[this.labelStyle()]}>床位：</td><td {[this.textStyle()]}>{Bed}&nbsp;</td>',
				'</tr>',
				'<tr style="font-size:13px;height:30px;">',
					'<td {[this.labelStyle()]}>编目状态：</td><td {[this.textStyle()]}>{StatusDesc}&nbsp;</td>',
					'<td {[this.labelStyle()]}>编目日期：</td><td {[this.textStyle()]}>{BuildDate} {BuildTime}&nbsp;</td>',
					'<td {[this.labelStyle()]}>编目人：</td><td {[this.textStyle()]}>{BuildUser}&nbsp;</td>',
					'<td {[this.labelStyle()]}>修改日期：</td><td {[this.textStyle()]}>{UpdateDate} {UpdateTime}&nbsp;</td>',
					'<td {[this.labelStyle()]}>修改人：</td><td {[this.textStyle()]}>{UpdateUser}&nbsp;</td>',
				'</tr>',
				'<tr style="font-size:13px;height:30px;">',
					//'<td {[this.labelStyle()]}>病人密级：</td><td {[this.textStyle()]}>{EncryptLevel}&nbsp;</td>',
					//'<td {[this.labelStyle()]}>病人级别：</td><td {[this.textStyle()]}>{PatLevel}&nbsp;</td>',
				'</tr>',
			'</tpl>',
		'</table>',
		{
			labelStyle : function(colspan){
				if (!colspan) colspan=1;
				var tabEv = ''
				tabEv += ' colspan="' + colspan + '"'
				tabEv += ' style="border:1px solid #DAE0EF;"'
				tabEv += ' align="right"'
				return tabEv;
			},
			textStyle : function(colspan){
				if (!colspan) colspan=1;
				var tabEv = ''
				tabEv += ' colspan="' + colspan + '"'
				tabEv += ' style="border:1px solid #DAE0EF;background-color:#FFFFFF;"'
				tabEv += ' align="left"'
				return tabEv;
			},
			displayDischDate : function(values){
				if (values.EstDischDate != ''){
					return values.EstDischDate + ' ' + values.EstDischTime + '【' + values.DischDate + ' ' + values.DischTime + '】';
				} else {
					return values.DischDate + ' ' + values.DischTime;
				}
			}
		}
	);
}

function InitNBINF(obj)
{
	//新生儿体重
	obj.NBINF_cboBornWeightCat = Common_ComboToDic("NBINF_cboBornWeightCat","<span style='color:red'><b>体重</b></span>","NINFInfNICUBornWeight","","100%");
	//感染日期
	obj.NBINF_txtInfDate = Common_DateFieldToDate("NBINF_txtInfDate","<span style='color:red'><b>感染日期</b></span>","100%");
	//感染诊断
	obj.NBINF_cbgInfDiagnos = Common_CheckboxGroupToDic("NBINF_cbgInfDiagnos","<span style='color:red'><b>感染诊断</b></span>","NINFInfNICUInfDiag",3);
	//易感因素
	obj.NBINF_cbgInfFactors = Common_CheckboxGroupToDic("NBINF_cbgInfFactors","<span style='color:red'><b>易感因素</b></span>","NINFInfNICUInfFactors",3);
	
	//感染相关 界面布局
	obj.NBINF_ViewPort = {
		//title : '感染相关',
		layout : 'fit',
		//frame : true,
		height : 320,
		anchor : '-20',
		tbar : ['<b>新生儿感染信息</b>'],
		items : [
			{
				layout : 'form',
				frame : true,
				labelWidth : 60,
				items : [
					{
						layout : 'column',
						items : [
							{
								width:200
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.NBINF_cboBornWeightCat]
							},{
								width:210
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.NBINF_txtInfDate]
							}
						]
					}
					,obj.NBINF_cbgInfDiagnos
					,obj.NBINF_cbgInfFactors
				]
			}
		]
	}
	
	//感染相关 界面初始化
	obj.NBINF_InitView = function(){
		if(obj.CurrReport.RowID != "") {
			//初始化"体重"值
			var objBornWeightCat = obj.CurrReport.ChildSumm.BornWeightCat;
			if (objBornWeightCat){
				var itemValue = objBornWeightCat.RowID;
				var itemDesc = objBornWeightCat.Description;
			}
			Common_SetValue('NBINF_cboBornWeightCat',itemValue,itemDesc);
			
			//初始化"感染日期"、"感染诊断"值
			var InfDate = '',InfDiagCat = '';
			if (obj.CurrReport.ChildInfPos) {
				var arrInfPos = obj.CurrReport.ChildInfPos;
				for (var ind = 0; ind < arrInfPos.length; ind++) {
					var objInfPos = arrInfPos[ind];
					if (objInfPos) {
						InfDate = objInfPos.InfDate;
						if (objInfPos.InfDiagCat) {
							var objDic = objInfPos.InfDiagCat;
							InfDiagCat = (InfDiagCat == '' ? objDic.RowID : InfDiagCat + ',' + objDic.RowID);
						}
					}
				}
			}
			Common_SetValue('NBINF_txtInfDate',InfDate);
			Common_SetValue('NBINF_cbgInfDiagnos',InfDiagCat);
			
			//初始化"易感因素"值
			var InfFactors = '';
			if (obj.CurrReport.ChildSumm.InfFactors) {
				var arrInfFactors = obj.CurrReport.ChildSumm.InfFactors;
				for (var ind = 0; ind < arrInfFactors.length; ind++) {
					var objDic = arrInfFactors[ind];
					if (objDic) {
						InfFactors = (InfFactors == '' ? objDic.RowID : InfFactors + ',' + objDic.RowID);
					}
				}
			}
			Common_SetValue('NBINF_cbgInfFactors',InfFactors);
		}
	}
	
	//感染相关 数据存储
	obj.NBINF_SaveData = function(){
		var errinfo = '';
		
		//新生儿体重
		var BornWeightCat = Common_GetValue('NBINF_cboBornWeightCat');
		obj.CurrReport.ChildSumm.BornWeightCat = obj.ClsSSDictionary.GetObjById(BornWeightCat);
		
		//感染信息
		if (obj.CurrReport.RowID != ''){
			var ReportID = obj.CurrReport.RowID;
			var flg = obj.ClsInfReportInfPosSrv.DelInfPos(ReportID);
		}
		obj.CurrReport.ChildInfPos   = new Array();
		var InfDate = Common_GetText('NBINF_txtInfDate');
		var today = new Date();
		var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (InfDate!=='') {
			var flg = Common_CompareDate(InfDate,CurrDate);
			if (!flg) errinfo = errinfo + '感染日期不能大于当前日期!<br>'
		}
		var itmValue = Common_GetValue('NBINF_cbgInfDiagnos');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var InfDiagnos = arrValue[ind];
				if (!InfDiagnos) continue;
				var objInfPos = obj.ClsInfReportInfPosSrv.GetSubObj('');
				if (objInfPos) {
					objInfPos.RowID = '';
					objInfPos.DataSource = '';
					objInfPos.InfPos = '';
					objInfPos.InfDate = InfDate; 
					objInfPos.InfEndDate = '';
					objInfPos.InfEndResult = '';
					objInfPos.InfDiag = '';
					objInfPos.InfDiagCat = obj.ClsSSDictionary.GetObjById(InfDiagnos);
					objInfPos.DiagnosisBasis = '';
					objInfPos.DiseaseCourse = '';
					objInfPos.InfPosOpr = new Array();
				}
				obj.CurrReport.ChildInfPos.push(objInfPos);
			}
		}
		
		//易感因素
		obj.CurrReport.ChildSumm.InfFactors = new Array();
		var itmValue = Common_GetValue('NBINF_cbgInfFactors');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var objDic = obj.ClsSSDictionary.GetObjById(arrValue[ind]);
				if (objDic) {
					obj.CurrReport.ChildSumm.InfFactors.push(objDic);
				}
			}
		}
		
		//数据完整性校验
		if (!obj.CurrReport.ChildSumm.BornWeightCat) {
			errinfo = errinfo + '新生儿体重未填!<br>'
		}
		if (InfDate == '') {
			errinfo = errinfo + '感染日期未填!<br>'
		}
		if (obj.CurrReport.ChildInfPos.length < 1) {
			errinfo = errinfo + '感染诊断未填!<br>'
		}
		if (obj.CurrReport.ChildSumm.InfFactors.length < 1) {
			errinfo = errinfo + '易感因素未填!<br>'
		}
		
		return errinfo;
	}
	
	return obj;
}
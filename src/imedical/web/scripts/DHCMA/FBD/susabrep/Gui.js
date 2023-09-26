function InitReportWin(){
	//$.parser.parse(); // 解析整个页面 
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 
	if (EpisodeID=="" || PatientID=="") {
		$.messager.alert("提示", "患者信息不存在!",'info');
		return;
	}
	
	var obj = new Object();
	obj.reportID = ReportID;
	obj.diseaseID = DiseaseID;
	obj.objCurrPaadm = null;
	obj.objCurrPatient = null;
	obj.objCurrReport = null;
	obj.objCurrCtLoc = null;
	obj.objCurrUser = null;
	obj.IsUpdatePatInfo = IsUpdatePatInfo;
	obj.IsUpdateReportNo = IsUpdateReportNo;
	obj.IsUpdateSampleNo = IsUpdateSampleNo;
	
	//加载症状与体征
	obj.BuildSign = function() {
		$cm({
			ClassName:"DHCMed.FBDService.ReportSrv",
			QueryName:"QryReportSign",
			ResultSetType:'array',
			aReportID:obj.reportID,
			aType:1
		},function(objdataSign){
			if (!objdataSign) return;
			var len = objdataSign.length;
			var ParrefCode='',ParrefList='';
			var arrayData3 = new Array(), arrayData6 = new Array(), arrayData9 = new Array();
			for (var i=0; i<len; i++) {
				var objTmp = objdataSign[i];
				if (objTmp.Code.length==3) {
					arrayData3[arrayData3.length] = objTmp;
				} else if (objTmp.Code.length==6) {
					arrayData6[arrayData6.length] = objTmp;
				} 
			}
			var htmlStr='';
			for (var i=0; i<arrayData3.length; i++) {
				var objTmp3 = arrayData3[i];
				htmlStr += 	'<tr class="report-tr">'
				htmlStr += 		'<td class="report-td fbdsign" style="width:120px;">'+objTmp3.Desc+'</td>'
				htmlStr += 	    '<td>'
				var groupStr6 = "", flgSub3 = 0;
				for (var j=0; j<arrayData6.length; j++) {
					var objTmp6 = arrayData6[j];
					if (objTmp6.Code.substring(0, 3)!=objTmp3.Code) { continue; }
					var IsExist = ParrefList.indexOf(objTmp6.Code); 
					if (IsExist<1) { //不存在
						htmlStr += '<div class="td-quarter">'
						if (objTmp6.ExtraTypeDesc !="无") {
							htmlStr += '<input id=chk'+objTmp6.ID+' type="checkbox" class="hisui-checkbox" '+(objTmp6.Impl==1? 'checked="checked"':"")+' label='+objTmp6.Desc+' name="chkList"  value='+objTmp6.chkID+'>'
							htmlStr += '<input id=txt'+objTmp6.ID+' class="textbox text-resume" name="txtList" value='+objTmp6.ExtraText+'>'+objTmp6.ExtraUnit
						}else {
							htmlStr += '<input id=chk'+objTmp6.ID+' type="checkbox" class="hisui-checkbox" '+(objTmp6.Impl==1? 'checked="checked"':"")+' label='+objTmp6.Desc+' name="chkList" value='+objTmp6.chkID+'>'	
						}
						htmlStr += '</div>'
					}else {  //存在
						htmlStr += '<table>'
						htmlStr += 	'<tr class="report-tr">'
						htmlStr +=    '<td id=SignSub'+objTmp6.ID+'>'+objTmp6.Desc+'</td>'
						var groupStr9 = "", flgSub6 = 0;
						for (var k=0; k<arrayData9.length; k++) {
							var objTmp9 = arrayData9[k];
							if (objTmp9.Code.substring(0, 6)!=objTmp6.Code) { continue; }
							htmlStr += '<td><input id=chk'+objTmp9.ID+' type="checkbox" class="hisui-checkbox" '+(objTmp9.Impl==1? 'checked="checked"':"")+' label='+objTmp9.Desc+' name="chkList" value='+objTmp9.chkID+'></td>'
						}
						htmlStr += 	'</tr>'
						htmlStr += ' </table>'
					}
				}	
				htmlStr +=      '</td>'
				htmlStr += 	'</tr>'
			
			}
			$('#SignInfoTab').append(htmlStr);
			$.parser.parse('#SignInfoTab');  //checkbox		
	         
		});
     
	}

	obj.LoadPatInfo = function() {
		
		//职业
		obj.cboOccupation = Common_ComboDicID("cboOccupation","FBDOccupation");
		//病人属于
		obj.cboPatArea = Common_ComboDicID("cboPatArea","FBDReportRegion");
		//疾病分类
		obj.cboDisCate = Common_ComboDicID("cboDisCate","FBDDiseaseType");
		
		$('#cboDisDesc').combobox({}); //联动表格需先初始化
		//疾病分类 疾病名称联动
		$HUI.combobox('#cboDisCate',{
		    onChange:function(newValue,oldValue){
			    var CateID = newValue;
				//疾病名称
				obj.cboDisDesc = $HUI.combobox('#cboDisDesc', {
					editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
					defaultFilter:4,
					valueField: 'ID',
					textField: 'IDDesc',
					onShowPanel: function () {
						var url=$URL+"?ClassName=DHCMed.SSService.DiseaseSrv&QueryName=QryDisease&ResultSetType=array&aProductCode=FBD&aIsActive=1&aCateID="+CateID;
						$('#cboDisDesc').combobox('reload',url);
					}
				});
		    }
	    });
		obj.cboCardType   = Common_ComboToDic("cboCardType","FBDSusCardType",1);     // 证件类型
		obj.cboReason = Common_ComboDicID("cboReason","FBDSusReason");    //上报原因
	    obj.chkPreDiagnos = Common_CheckboxToDic("chkPreDiagnosDrs","FBDPreDiagnos",2);   //初步诊断
	    obj.chkSusAbCause = Common_CheckboxToDic("chkSusAbCauseDrs","FBDSusCause",2);       //可疑病因
		//现住省
		obj.cboCurrProvince = $HUI.combobox('#cboCurrProvince', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=1";
		   	 	$('#cboCurrProvince').combobox('reload',url);
			}, onChange:function(newValue,oldValue){		
				$('#cboCurrCity').combobox('clear');
				$('#cboCurrCounty').combobox('clear');
				$('#cboCurrVillage').combobox('clear');
				$('#txtCurrRoad').val('');
				obj.cboCurrCity.reload();
			}
		});

		//现住市
		obj.cboCurrCity = $HUI.combobox('#cboCurrCity', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboCurrProvince').combobox('getValue');
		   	 	$('#cboCurrCity').combobox('reload',url);
			}, onChange:function(newValue,oldValue){
				$('#cboCurrCounty').combobox('clear');
				$('#cboCurrVillage').combobox('clear');
				$('#txtCurrRoad').val('');
				obj.cboCurrCounty.reload();
			}
		});	
		//现住县
		obj.cboCurrCounty = $HUI.combobox('#cboCurrCounty', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboCurrCity').combobox('getValue');
		   	 	$('#cboCurrCounty').combobox('reload',url);
			}, onChange:function(newValue,oldValue){
				$('#cboCurrVillage').combobox('setValue','');
				$('#txtCurrRoad').val('');
				obj.cboCurrVillage.reload();
			}
		});

		//现住乡
		obj.cboCurrVillage = $HUI.combobox('#cboCurrVillage', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboCurrCounty').combobox('getValue');
		   	 	$('#cboCurrVillage').combobox('reload',url);
			},
			onSelect:function(record){
				$('#txtCurrRoad').val('');
				$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText'));
			}
		});
		//户籍省
		obj.cboRegProvince = $HUI.combobox('#cboRegProvince', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=1";
		   	 	$('#cboRegProvince').combobox('reload',url);
			}, onChange:function(newValue,oldValue){		
				$('#cboRegCity').combobox('clear');
				$('#cboRegCounty').combobox('clear');
				$('#cboRegVillage').combobox('clear');
				$('#txtRegRoad').val('');
				obj.cboRegCity.reload();
			}
		});

		//户籍市
		obj.cboRegCity = $HUI.combobox('#cboRegCity', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboRegProvince').combobox('getValue');
		   	 	$('#cboRegCity').combobox('reload',url);
			}, onChange:function(newValue,oldValue){
				$('#cboRegCounty').combobox('clear');
				$('#cboRegVillage').combobox('clear');
				$('#txtRegRoad').val('');
				obj.cboRegCounty.reload();
			}
		});	
		//户籍县
		obj.cboRegCounty = $HUI.combobox('#cboRegCounty', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboRegCity').combobox('getValue');
		   	 	$('#cboRegCounty').combobox('reload',url);
			}, onChange:function(newValue,oldValue){
				$('#cboRegVillage').combobox('setValue','');
				$('#txtRegRoad').val('');
				obj.cboRegVillage.reload();
			}
		});

		//户籍乡
		obj.cboRegVillage = $HUI.combobox('#cboRegVillage', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboRegCounty').combobox('getValue');
		   	 	$('#cboRegVillage').combobox('reload',url);
			},
			onSelect:function(record){
				$('#txtRegRoad').val('');
				$('#txtRegAddress').val($('#cboRegProvince').combobox('getText')+$('#cboRegCity').combobox('getText')+$('#cboRegCounty').combobox('getText')+$('#cboRegVillage').combobox('getText'));
			}
		});
		
	}
	
	InitReportWinEvent(obj);
	obj.LoadEvent();
	return obj;

}

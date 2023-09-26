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
	obj.DelListFood = "";
	obj.DelListSample = "";
	obj.currGridFoodRowID = "";
	obj.currGridSampleRowID = "";
	obj.IsUpdatePatInfo = IsUpdatePatInfo;
	obj.IsUpdateReportNo = IsUpdateReportNo;
	obj.IsUpdateSampleNo = IsUpdateSampleNo;

	//加载症状与体征
	obj.BuildSign = function() {
		$cm({
			ClassName:"DHCMed.FBDService.ReportSrv",
			QueryName:"QryReportSign",
			ResultSetType:'array',
			aReportID:obj.reportID
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
				} else if (objTmp.Code.length==9) {
					arrayData9[arrayData9.length] = objTmp;
					if(ParrefCode == objTmp.Code.substring(0, 6)) continue;
					ParrefCode = objTmp.Code.substring(0, 6);
					ParrefList = ParrefList+','+ParrefCode;  //存在子节点的项目List
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
		obj.cboOccupation = Common_ComboToDic("cboOccupation","FBDOccupation","",session['LOGON.HOSPID']);
		//病人属于
		obj.cboPatArea = Common_ComboToDic("cboPatArea","FBDReportRegion","",session['LOGON.HOSPID']);
		//疾病分类
		obj.cboDisCate = Common_ComboToDic("cboDisCate","FBDDiseaseType","",session['LOGON.HOSPID']);
		
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
	    obj.chkPreDiagnos = Common_CheckboxToDic("chkPreDiagnosDrs","FBDPreDiagnos",2);   //初步诊断
	    $HUI.checkbox("[name='chkPreDiagnosDrs']",{  
			onCheckChange:function(e,value){
				var PerDiagnos = $(e.target).attr("label");   //当前选中的值
				if (PerDiagnos=='其他') {
					if(value==false){	
						$('#txtPreDiagnos').val("")						
						$('#txtPreDiagnos').attr('disabled','disabled');
					}else{
						$('#txtPreDiagnos').removeAttr('disabled');
					}
				}
				
			}
		});
	    obj.chkAnamnesis = Common_CheckboxToDic("chkAnamnesisDrs","FBDAnamnesis",2);  //既往病史
	    $HUI.checkbox("[name='chkAnamnesisDrs']",{  
			onCheckChange:function(e,value){
				var Anamnesis = $(e.target).attr("label");   //当前选中的值
				if (Anamnesis=='其他') {
					if(value==false){
						$('#txtAnamnesis').val("")
						$('#txtAnamnesis').attr('disabled','disabled');
					}else{
						$('#txtAnamnesis').removeAttr('disabled');
					}
				}			
			}
		});       
		//省
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

		//市
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
		//县
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

		//乡
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
	}
	obj.LoadDicInfo = function() {
		
		//样本类型
		obj.cboSampleType = Common_ComboToDic("cboSampleType","FBDSampleType","",session['LOGON.HOSPID']);
		//单位
		obj.cboSampleUnit = Common_ComboToDic("cboSampleUnit","FBDSampleUnit","",session['LOGON.HOSPID']);
		//食品分类
		obj.cboFoodType = Common_ComboToDic("cboFoodType","FBDFoodType","",session['LOGON.HOSPID']);
		//加工或包装方式
		obj.cboPacking = Common_ComboToDic("cboPacking","FBDPacking","",session['LOGON.HOSPID']);
		//进食场所类型
		obj.cboEatingSiteCate = Common_ComboToDic("cboEatingSiteCate","FBDEatingSite","",session['LOGON.HOSPID']);
		//进食场所
		$('#cboEatingSite').combobox({});  //联动表格需先初始化
		$HUI.combobox('#cboEatingSiteCate',{                                                                      //工种
			onSelect:function(rows){
				var DicCode=rows["DicCode"];
				var DicType="FBDEatingSite"+DicCode;
				obj.cboEatingSite = Common_ComboToDic("cboEatingSite",DicType);
			}
		});
		//购买场所类型
		obj.cboBuySiteCate = Common_ComboToDic("cboBuySiteCate","FBDBuySite","",session['LOGON.HOSPID']);
		//购买场所类型
		$('#cboBuySite').combobox({});   //联动表格需先初始化
		$HUI.combobox('#cboBuySiteCate',{                                                                      //工种
			onSelect:function(rows){
				var DicCode=rows["DicCode"];
				var DicType="FBDBuySite"+DicCode;
				obj.cboBuySite = Common_ComboToDic("cboBuySite",DicType,"",session['LOGON.HOSPID']);
			}
		});
		obj.radEatType = Common_RadioToDic("radEatTypeList","FBDAdressType",2); 
	
		$HUI.radio("[name='radEatTypeList']",{  //进食地点选项触发事件
			onChecked:function(e,value){
				var EatType = $(e.target).attr("label");   //当前选中的值
				if (EatType=='境内') {				
					obj.LoadEatAddress();
					$('#cboEatProvince').combobox('enable');
					$('#cboEatCity').combobox('enable');
					$('#cboEatCounty').combobox('enable');
				}else{
					$('#cboEatProvince').combobox('clear');
					$('#cboEatCity').combobox('clear');
					$('#cboEatCounty').combobox('clear');
					$('#cboEatProvince').combobox('disable');
					$('#cboEatCity').combobox('disable');
					$('#cboEatCounty').combobox('disable');
				}
			}
		});
		obj.radBuyType = Common_RadioToDic("radBuyTypeList","FBDAdressType",2);
		$HUI.radio("[name='radBuyTypeList']",{  //进食地点选项触发事件
			onChecked:function(e,value){
				var BuyType = $(e.target).attr("label");   //当前选中的值
				if (BuyType=='境内') {	
					obj.LoadBuyAddress();
					$('#cboBuyProvince').combobox('enable');
					$('#cboBuyCity').combobox('enable');
					$('#cboBuyCounty').combobox('enable');
				}else{
					$('#cboBuyProvince').combobox('clear');
					$('#cboBuyCity').combobox('clear');
					$('#cboBuyCounty').combobox('clear');
					$('#cboBuyProvince').combobox('disable');
					$('#cboBuyCity').combobox('disable');
					$('#cboBuyCounty').combobox('disable');
				}
			}
		});
		
	}	
	
	obj.LoadEatAddress = function() {
		obj.cboEatProvince = $HUI.combobox('#cboEatProvince', {
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=1";
		   	 	$('#cboEatProvince').combobox('reload',url);
			},
			onChange:function(newValue,oldValue){		
				$('#cboEatCity').combobox('clear');
				$('#cboEatCounty').combobox('clear');
				$('#txtEatingPlaces').val('');
				obj.cboEatCity.reload();
			}
		});
		//市
		obj.cboEatCity = $HUI.combobox('#cboEatCity', {
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboEatProvince').combobox('getValue');
		   	 	$('#cboEatCity').combobox('reload',url);
			},
			onChange:function(newValue,oldValue){
				$('#cboEatCounty').combobox('clear');
				$('#txtEatingPlaces').val('');
				obj.cboEatCounty.reload();
			}
		});
		//县
		obj.cboEatCounty = $HUI.combobox('#cboEatCounty', {
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboEatCity').combobox('getValue');
		   	 	$('#cboEatCounty').combobox('reload',url);
			},
			 onChange:function(newValue,oldValue){
				$('#txtEatingPlaces').val('');
			}
		});		
	}
	
	obj.LoadBuyAddress = function() {
		
		obj.cboBuyProvince = $HUI.combobox('#cboBuyProvince', {
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=1";
		   	 	$('#cboBuyProvince').combobox('reload',url);
			},
			onChange:function(newValue,oldValue){		
				$('#cboBuyCity').combobox('clear');
				$('#cboBuyCounty').combobox('clear');
				$('#txtWhereToBuy').val('');
				obj.cboBuyCity.reload();
			}
		});
		//市
		obj.cboBuyCity = $HUI.combobox('#cboBuyCity', {
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboBuyProvince').combobox('getValue');
		   	 	$('#cboBuyCity').combobox('reload',url);
			},
			onChange:function(newValue,oldValue){
				$('#cboBuyCounty').combobox('clear');
				$('#txtWhereToBuy').val('');
				obj.cboBuyCounty.reload();
			}
		});
		//县
		obj.cboBuyCounty = $HUI.combobox('#cboBuyCounty', {
			editable: true,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboBuyCity').combobox('getValue');
		   	 	$('#cboBuyCounty').combobox('reload',url);
			},
			onChange:function(newValue,oldValue){
				$('#txtWhereToBuy').val('');
			}
		});
	}
	obj.gridFood = $HUI.datagrid("#gridFoodInfo",{
		title:'暴露信息（是否怀疑是进食了某些食品后出现以上症状，如果"是"请于下列表格中填写食品信息，可填写多个。购买地点和进食场所至少填写一项）',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		columns:[[
			{field:'FoodName',title:'食品名称',width:'80'},
			{field:'FoodType',title:'食品分类',width:'80'},
			{field:'Packing',title:'加工或<br>包装方式',width:'80'},
			{field:'FoodBrand',title:'食品品牌',width:'80'},
			{field:'Manufacturer',title:'生产厂家',width:'80'},
			{field:'EatingSite',title:'进食场所',width:'120',
				formatter: function(value,row,index){
					return row.EatingSiteCate+" "+row.EatingSite;					
				}
			}, 
			{field:'BuySite',title:'购买场所',width:'120',
				formatter: function(value,row,index){
					return row.BuySiteCate+" "+row.BuySite;					
				}
			}, 
			{field:'EatingPlaces',title:'进食地点',width:'130',
				formatter: function(value,row,index){
					return row.EatingTypeDesc+" ("+row.EatProvinceDesc+" "+row.EatCityDesc+" "+row.EatCountyDesc+" "+row.EatingPlaces+')';					
				}
			}, 
			{field:'BuyPlaces',title:'购买地点',width:'130',
				formatter: function(value,row,index){
					return row.BuyTypeDesc+" ("+row.BuyProvinceDesc+" "+row.BuyCityDesc+" "+row.BuyCountyDesc+" "+row.WhereToBuy+')';										
				}
			}, 
			{field:'EatingDateTime',title:'进食时间',width:'160',
				formatter: function(value,row,index){
					return row.EatingDate+" "+row.EatingTime;					
				}
			}, 
			{field:'EatingNum',title:'进食<br>人数',width:'40'},
			{field:'IsIncidenceDesc',title:'其他人<br>是否发病',width:'80'},
			{field:'IsSamplingDesc',title:'是否<br>采样',width:'40'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridFood_rowclick();
			}
		}
	});
	
	obj.gridSample = $HUI.datagrid("#gridSampleInfo",{
		//fit: true,
		title:'生物样本采集（是否采集生物标本，如果“是”请于表格中填写标本信息）',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		columns:[[
			{field:'SampleNo',title:'样本编号',width:'200'},
			{field:'SampleTypeDesc',title:'样本类型',width:'200'},
			{field:'SampleNumber',title:'样本数量',width:'100'},
			{field:'SampleUnitDesc',title:'单位',width:'200'},
			{field:'SampleDate',title:'采样日期',width:'100'},
			{field:'Resume',title:'备注',width:'300'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridSample_rowclick();
			}
		}
	});
	
	InitReportWinEvent(obj);
	obj.LoadEvent();
	return obj;

}

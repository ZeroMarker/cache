function InitReportWin(){
	//$.parser.parse(); // 解析整个页面 
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 
	if (EpisodeID=="" || PatientID=="") {
		$.messager.alert($g("提示"), $g("患者信息不存在!"),'info');
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
						if (objTmp6.ExtraTypeDesc !=$g("无")) {
							htmlStr += '<input id=chk'+objTmp6.ID+' type="checkbox" class="hisui-checkbox" '+(objTmp6.Impl==1? 'checked="checked"':"")+' label='+objTmp6.Desc+' name="chkList"  value='+objTmp6.chkID+'>'
							if(objTmp6.Desc==$g("发热")){
								htmlStr += '<input id=txt'+objTmp6.ID+' style="margin:5px 0px 5px 5px;" class="hisui-numberbox" data-options="precision:1,forcePrecisionZoer:false,fix:false,max:46.5,min:14.2" name="txtList" value='+objTmp6.ExtraText+'>'+objTmp6.ExtraUnit
							}else if((objTmp6.Desc==$g("腹泻"))||(objTmp6.Desc==$g("呕吐"))){
								htmlStr += '<input id=txt'+objTmp6.ID+' style="margin:5px 0px 5px 5px;" class="hisui-numberbox" name="txtList" value='+objTmp6.ExtraText+'>'+objTmp6.ExtraUnit
							}else{
								htmlStr += '<input id=txt'+objTmp6.ID+' style="margin:5px 0px 5px 5px;" class="textbox" name="txtList" value='+objTmp6.ExtraText+'>'+objTmp6.ExtraUnit
							}
						}else {
							htmlStr += '<input id=chk'+objTmp6.ID+' type="checkbox" class="hisui-checkbox" '+(objTmp6.Impl==1? 'checked="checked"':"")+' label='+objTmp6.Desc+' name="chkList" value='+objTmp6.chkID+'>'	
						}
						htmlStr += '</div>'
					}else {  //存在
						htmlStr += '<table>'
						htmlStr += 	'<tr class="report-tr">'
						htmlStr +=    '<td id=SignSub'+objTmp6.ID+' style="padding-right:10px;">'+objTmp6.Desc+'</td>'
						var groupStr9 = "", flgSub6 = 0;
						for (var k=0; k<arrayData9.length; k++) {
							var objTmp9 = arrayData9[k];
							if (objTmp9.Code.substring(0, 6)!=objTmp6.Code) { continue; }
							htmlStr += '<td style="padding-right:20px;"><input id=chk'+objTmp9.ID+'  type="checkbox" class="hisui-checkbox" '+(objTmp9.Impl==1? 'checked="checked"':"")+' label='+objTmp9.Desc+' name="chkList" value='+objTmp9.chkID+'></td>'
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
		//省
		obj.cboCurrProvince = $HUI.combobox('#cboCurrProvince', {
			editable: true,
			defaultFilter:4,
			valueField: 'ID',
			textField: 'ShortDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=1"+ "&aFlag=1";
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
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboCurrProvince').combobox('getValue')+ "&aFlag=2";
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
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboCurrCity').combobox('getValue')+ "&aFlag=3";
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
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboCurrCounty').combobox('getValue')+ "&aFlag=4";
		   	 	$('#cboCurrVillage').combobox('reload',url);
			},
			onSelect:function(record){
				$('#txtCurrRoad').val('');
				$('#txtCurrAddress').val($('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText'));
			}
		});
		
		// 食源性疾病所属与现住址强制关联
		if (ServerObj.FBDRegionRelateCurrAdd == '1' && ServerObj.FBDInitAddressByLocalHospital != '') {
			var InitAddrArray = ServerObj.FBDInitAddressByLocalHospital.split('`');
			$('#cboPatArea').combobox({
				onSelect: function(newValue,oldValue) {
					setTimeout(function(){
						var PatAreaDesc = $('#cboPatArea').combobox('getText');
						if (PatAreaDesc == $g("本县区")) {				//本县区
							$('#cboCurrProvince').combobox('setValue',InitAddrArray[0].split('^')[0]);
							$('#cboCurrProvince').combobox('setText',InitAddrArray[0].split('^')[1]);
							$('#cboCurrCity').combobox('setValue',InitAddrArray[1].split('^')[0]);
							$('#cboCurrCity').combobox('setText',InitAddrArray[1].split('^')[1]);
							$('#cboCurrCounty').combobox('setValue',InitAddrArray[2].split('^')[0]);
							$('#cboCurrCounty').combobox('setText',InitAddrArray[2].split('^')[1]);
							$('#cboCurrVillage').combobox('clear');
							$('#txtCurrRoad').val("");
							$('#txtCurrAddress').val("");
						}else if (PatAreaDesc == $g("本市其它县区")) {		//本市其他县区
							$('#cboCurrProvince').combobox('setValue',InitAddrArray[0].split('^')[0]);
							$('#cboCurrProvince').combobox('setText',InitAddrArray[0].split('^')[1]);
							$('#cboCurrCity').combobox('setValue',InitAddrArray[1].split('^')[0]);
							$('#cboCurrCity').combobox('setText',InitAddrArray[1].split('^')[1]);
							$('#cboCurrCounty').combobox('clear');
							$('#cboCurrVillage').combobox('clear');
							$('#txtCurrRoad').val("");
							$('#txtCurrAddress').val("");
						}else if (PatAreaDesc == $g("本省其它城市")) {		//本省其它地市
							$('#cboCurrProvince').combobox('setValue',InitAddrArray[0].split('^')[0]);
							$('#cboCurrProvince').combobox('setText',InitAddrArray[0].split('^')[1]);
							$('#cboCurrCity').combobox('clear');
							$('#cboCurrCounty').combobox('clear');
							$('#cboCurrVillage').combobox('clear');
							$('#txtCurrRoad').val("");
							$('#txtCurrsAddress').val("");
						}else{
							$('#cboCurrProvince').combobox('clear');
							$('#cboCurrCity').combobox('clear');
							$('#cboCurrCounty').combobox('clear');
							$('#cboCurrVillage').combobox('clear');
							$('#txtCurrRoad').val("");
							$('#txtCurrsAddress').val("");
						}
			        }, 200)
				}
			})
		}
	}
	obj.LoadDicInfo = function() {
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
				if (EatType==$g('境内')) {				
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
				if (BuyType==$g('境内')) {	
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
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=1"+ "&aFlag=1";
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
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboEatProvince').combobox('getValue')+ "&aFlag=2";
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
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboEatCity').combobox('getValue')+ "&aFlag=3";
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
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=1"+ "&aFlag=1";
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
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboBuyProvince').combobox('getValue')+ "&aFlag=2";
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
				var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboBuyCity').combobox('getValue')+ "&aFlag=3";
		   	 	$('#cboBuyCounty').combobox('reload',url);
			},
			onChange:function(newValue,oldValue){
				$('#txtWhereToBuy').val('');
			}
		});
	}
	obj.gridFood = $HUI.datagrid("#gridFoodInfo",{
		title:$g('暴露信息（是否怀疑是进食了某些食品后出现以上症状，如果"是"请于下列表格中填写食品信息，可填写多个。购买地点和进食场所至少填写一项）'),
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		columns:[[
			{field:'FoodName',title:'食品名称',width:'80'},
			{field:'FoodType',title:'食品分类',width:'80'},
			{field:'Packing',title:'加工或包装方式',width:'120'},
			{field:'FoodBrand',title:'食品品牌',width:'80'},
			{field:'EatingPlaces',title:'进食地点',width:'230',
				formatter: function(value,row,index){
					return row.EatingTypeDesc+" ("+row.EatProvinceDesc+" "+row.EatCityDesc+" "+row.EatCountyDesc+" "+row.EatingPlaces+')';					
				}
			}, 
			{field:'BuyPlaces',title:'购买地点',width:'230',
				formatter: function(value,row,index){
					return row.BuyTypeDesc+" ("+row.BuyProvinceDesc+" "+row.BuyCityDesc+" "+row.BuyCountyDesc+" "+row.WhereToBuy+')';										
				}
			}, 
			{field:'EatingDateTime',title:'进食时间',width:'160',
				formatter: function(value,row,index){
					return row.EatingDate+" "+row.EatingTime;					
				}
			}, 
			{field:'EatingNum',title:'进食人数',width:'80'},
			{field:'IsIncidenceDesc',title:'其他人是否发病',width:'160'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridFood_rowclick();
			}
		}
	});
	
	
	InitReportWinEvent(obj);
	obj.LoadEvent();
	return obj;

}

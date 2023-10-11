function InitBactTrendWin(){
	var obj = new Object();
	$.parser.parse();
	LogonHospID=$.LOGON.HOSPID;
	obj.BacteriaDr = "";
	obj.BactDesc   = "";
	obj.TypeCode="";	
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:LogonHospID
	},false);
	obj.HospData = HospList.rows;
    $HUI.radio("#chkStatunit-Ward").setValue(true);
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){//给医院增加Select事件，更新科室列表
			HospIDs=rec.ID;
			var Alias   = "";
			var LocCate = "I";
			var LocType = Common_CheckboxValue('chkStatunit');
			obj.cboSubLoc  = $HUI.combobox("#cboSubLoc", {
				url: $URL,
				editable: true,
				allowNull: true, 
				multiple:true,
				rowStyle:'checkbox',
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'LocDesc2',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.BTS.LocationSrv';
					param.QueryName = 'QryLoc';
					param.aHospIDs = HospIDs;
					param.aAlias = Alias;
					param.aLocCate = LocCate;
					param.aLocType = LocType;
					param.aIsActive = 1;
					param.ResultSetType = 'array';
				}
			});
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	obj.cboInfType = $HUI.combobox("#cboInfType", {
		url:$URL,
		editable: true,
		allowNull: true, 
		valueField: 'ID',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.DictionarySrv';
			param.QueryName = 'QryDic';
			param.aTypeCode = 'IRInfType';
			param.aActive = 1;
			param.ResultSetType = 'array';
		},onSelect:function(rec){//给医院增加Select事件，更新科室列表
			obj.TypeCode=rec.DicCode;
		}
	});
	
  	$HUI.radio("[name='chkStatunit']",{
        onCheckChange:function(e,value){
	        var Statunit = $(e.target).val();   //当前选中的值
			var HospIDs = $.LOGON.HOSPID;
			var Alias   = "";
			var LocCate = "I";
			var LocType = Statunit;
	        setTimeout(function(){
		      	obj.cboSubLoc  = $HUI.combobox("#cboSubLoc", {
					url: $URL,
					editable: true,
					allowNull: true, 
					multiple:true,
					rowStyle:'checkbox',
					defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
					valueField: 'ID',
					textField: 'LocDesc2',
					onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
						param.ClassName = 'DHCHAI.BTS.LocationSrv';
						param.QueryName = 'QryLoc';
						param.aHospIDs = HospIDs;
						param.aAlias = Alias;
						param.aLocCate = LocCate;
						param.aLocType = LocType;
						param.aIsActive = 1;
						param.ResultSetType = 'array';
					}
				});
			 }, 200);
        }
    });
    $HUI.radio("#chkStatunit-Ward").setValue(true);
    obj.cboBacteria = $HUI.lookup("#cboBacteria", {
		url:$URL,
		panelWidth:300,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:0,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'BacDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabBactSrv',QueryName: 'QryLabBacteria',aAlias:"",aIsCommon:"1"},
		columns:[[  
			{field:'BacDesc',title:'细菌名称',width:280}  
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){ 
			obj.BacteriaDr = rowData.ID;
			obj.BactDesc   = rowData.BacDesc;	
		}
	});
	//默认耐药级别
	$HUI.combobox("#cboDrugLevel",{
		data:[{Id:'1',text:'多耐'},{Id:'2',text:'敏感'}],
		valueField:'Id',
		textField:'text'
	});
	// 日期赋初始值
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYearFrom",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows
	});
	$HUI.combobox("#cboYearTo",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows
	});
	
	function MonthSetValue(aTypeID) {
		 var MonthList = $cm ({									//初始化月+季度+全年
			ClassName:"DHCHAI.STATV2.AbstractComm",
			QueryName:"QryMonth",
			aTypeID:aTypeID
		},false);
		
		$HUI.combobox("#cboMonthFrom",{
			valueField:'ID',
			textField:'Desc',
			editable:false,
			data:MonthList.rows
		});
		$HUI.combobox("#cboMonthTo",{
			valueField:'ID',
			textField:'Desc',
			editable:false,
			data:MonthList.rows
		});
		
		$('#cboMonthFrom').combobox('setValue',NowMonth);
		$('#cboMonthTo').combobox('setValue',NowMonth);
		
	}
	
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	var NowQuarter = Math.floor( ( NowMonth % 3 == 0 ? ( NowMonth / 3 ) : ( NowMonth / 3 + 1 ) ) );   //当前季度
	$('#cboYearFrom').combobox('select',NowYear);
	$('#cboYearTo').combobox('select',NowYear);
	
	$HUI.combobox("#cboUnit",{
		data:[{Id:'1',text:'月',selected:true},{Id:'2',text:'季度'},{Id:'3',text:'年'}],
		valueField:'Id',
		textField:'text',
		onSelect:function(rec){
	        var Unit = rec.Id;   //当前选中的值
			MonthSetValue(Unit);
			if (Unit=="1"){ //月份
				$('#cboMonthFrom').combobox('enable');
				$('#cboMonthTo').combobox('enable');
				$('#cboMonthFrom').combobox('setValue',NowMonth);
				$('#cboMonthTo').combobox('setValue',NowMonth);
			}else if (Unit=="2"){  // 季度
				$('#cboMonthFrom').combobox('enable');
				$('#cboMonthTo').combobox('enable');
				$('#cboMonthFrom').combobox('setValue',"JD"+NowQuarter);
				$('#cboMonthTo').combobox('setValue',"JD"+NowQuarter);
			}else{ // 年
				$('#cboMonthFrom').combobox('disable');
				$('#cboMonthTo').combobox('disable');
				$('#cboMonthFrom').combobox('setValue',"QN");
				$('#cboMonthTo').combobox('setValue',"QN");
			}
        }
	});
	MonthSetValue($('#cboUnit').combobox('getValue'));
	//默认日期类型
	$HUI.combobox("#cboDateType",{
		data:[{Id:'1',text:'送检日期',selected:true},{Id:'2',text:'报告日期'}],
		valueField:'Id',
		textField:'text'
	});	
	
	InitFloatWin(obj);
	InitBactTrendWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
